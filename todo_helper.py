#  Author: Maiwulanjiang Maiming
#  Email: mawlan.momin@gmail.com

#  Todo Parser for Übersicht
#  This Python backend is designed to work with a corresponding .coffee widget
#  for the Übersicht desktop-widget system (https://tracesof.net/uebersicht/).
#  The .coffee file calls this script to parse and manipulate a plain-text todo file,
#  returning JSON that the widget renders on macOS.

import sys
import json
import os
from datetime import datetime, date

TODO_FILE = os.environ.get('TODO_FILE') or os.path.expanduser('~/Documents/todo.txt')
DELIMITER = '=========='

def read_lines():
    if not os.path.exists(TODO_FILE):
        return []
    with open(TODO_FILE, 'r', encoding='utf-8') as f:
        return f.readlines()

def write_lines(lines):
    with open(TODO_FILE, 'w', encoding='utf-8') as f:
        f.writelines(lines)

def leading_spaces(line):
    return len(line) - len(line.lstrip(' '))

def parse_inline_metadata(text):
    parts = [p.strip() for p in text.split('|')]
    base = parts[0].strip() if parts else ""
    attrs = {}
    for token in parts[1:]:
        if ':' in token:
            key, value = token.split(':', 1)
            attrs[key.strip().lower()] = value.strip()
    return base, attrs

def normalize_priority(value):
    if not value:
        return ""
    normalized = value.strip().lower()
    if normalized in ["high", "medium", "low"]:
        return normalized
    return ""

def normalize_due(value):
    if not value:
        return ""
    return value.strip()

def format_due_date(due_str):
    if not due_str:
        return {"text": "", "status": "", "days": None}
    
    try:
        due_date = datetime.strptime(due_str, "%Y-%m-%d").date()
        today = date.today()
        delta = (due_date - today).days
        
        if delta < 0:
            return {"text": f"已过期 {-delta} 天", "status": "overdue", "days": delta}
        elif delta == 0:
            return {"text": "今天", "status": "today", "days": 0}
        elif delta == 1:
            return {"text": "明天", "status": "tomorrow", "days": 1}
        elif delta <= 7:
            return {"text": f"{delta} 天后", "status": "soon", "days": delta}
        else:
            return {"text": due_str, "status": "future", "days": delta}
    except ValueError:
        return {"text": due_str, "status": "unknown", "days": None}

def parse_section_header(line):
    stripped = line.strip()
    if not stripped.startswith('#'):
        return None
    header_text = stripped.lstrip('#').strip()
    title, attrs = parse_inline_metadata(header_text)
    return {
        "title": title,
        "color": attrs.get("color", "")
    }

def compose_section_header(title, color=""):
    clean_title = title.strip()
    clean_color = color.strip()
    if clean_color:
        return f"# {clean_title} |color:{clean_color}\n"
    return f"# {clean_title}\n"

def parse_task_line(line):
    indent = leading_spaces(line)
    stripped = line.strip()
    completed = False
    if stripped.startswith('-'):
        completed = True
        stripped = stripped[1:].strip()
    if stripped.startswith('·'):
        stripped = stripped[1:].strip()
    text, attrs = parse_inline_metadata(stripped)
    return {
        "indent": indent,
        "completed": completed,
        "text": text,
        "priority": normalize_priority(attrs.get("p", "")),
        "due": normalize_due(attrs.get("d", ""))
    }

def compose_task_line(text, completed=False, indent=0, priority="", due=""):
    clean_text = text.strip()
    if not clean_text:
        clean_text = "Untitled"
    metadata_tokens = []
    clean_priority = normalize_priority(priority)
    clean_due = normalize_due(due)
    if clean_priority:
        metadata_tokens.append(f"p:{clean_priority}")
    if clean_due:
        metadata_tokens.append(f"d:{clean_due}")
    body = f"· {clean_text}"
    if metadata_tokens:
        body += " |" + " |".join(metadata_tokens)
    prefix = " " * max(0, int(indent))
    if completed:
        return f"{prefix}- {body}\n"
    return f"{prefix}{body}\n"

def find_section_bounds(lines, section_title):
    target = section_title.strip()
    for i, line in enumerate(lines):
        parsed = parse_section_header(line)
        if not parsed:
            continue
        if parsed["title"] == target:
            next_header = len(lines)
            for j in range(i + 1, len(lines)):
                if parse_section_header(lines[j]):
                    next_header = j
                    break
            return i, next_header
    return None

def ensure_section(lines, section_title, color=""):
    if not section_title.strip():
        return lines
    if find_section_bounds(lines, section_title):
        return lines
    if lines and lines[-1].strip() != "":
        lines.append("\n")
    lines.append(compose_section_header(section_title, color))
    return lines

def section_for_line(lines, line_num):
    for i in range(line_num, -1, -1):
        parsed = parse_section_header(lines[i])
        if parsed:
            return parsed["title"]
    return "Inbox"

def insert_task_into_section(lines, section_title, task_line):
    if not section_title.strip():
        section_title = "Inbox"
    lines = ensure_section(lines, section_title)
    bounds = find_section_bounds(lines, section_title)
    if not bounds:
        lines.append(task_line)
        return lines
    _, section_end = bounds
    insert_index = section_end
    lines.insert(insert_index, task_line)
    return lines

def parse_todo():
    lines = read_lines()
    delimiter_count = 0
    start_index = 0

    if lines and lines[0].strip() == DELIMITER:
        delimiter_count += 1

    for i, line in enumerate(lines):
        if i == 0 and line.strip() == DELIMITER:
            continue

        if line.strip() == DELIMITER:
            delimiter_count += 1
            if delimiter_count >= 2:
                start_index = i + 1
                break

    content_lines = lines[start_index:]
    current_section = None
    sections = []
    done_tasks = []
    has_header = False

    for i, line in enumerate(content_lines):
        original_line_num = start_index + i
        stripped = line.strip()

        if not stripped:
            continue

        parsed_header = parse_section_header(line)
        if parsed_header:
            has_header = True
            if current_section is not None:
                sections.append(current_section)
            current_section = {
                "title": parsed_header["title"],
                "color": parsed_header["color"],
                "deletable": True,
                "tasks": []
            }
        else:
            if current_section is None:
                current_section = {"title": "Inbox", "color": "", "deletable": False, "tasks": [], "_implicit": True}

            parsed_task = parse_task_line(line)
            due_info = format_due_date(parsed_task["due"])
            
            task = {
                "id": original_line_num,
                "text": parsed_task["text"],
                "completed": parsed_task["completed"],
                "priority": parsed_task["priority"],
                "due": parsed_task["due"],
                "dueInfo": due_info,
                "section": current_section["title"],
                "raw": stripped,
                "indent": parsed_task["indent"]
            }

            if parsed_task["completed"]:
                done_tasks.append(task)
            else:
                current_section["tasks"].append(task)

    if current_section is not None:
        sections.append(current_section)

    if sections and sections[0].get("_implicit") and not sections[0]["tasks"] and has_header:
        sections.pop(0)

    if done_tasks:
        sections.append({
            "title": "Done Projects",
            "color": "#66ccff",
            "deletable": False,
            "tasks": done_tasks,
            "allow_add": False,
            "clearable": True
        })

    return json.dumps({"sections": sections})

def toggle_task(line_num):
    lines = read_lines()
    if 0 <= line_num < len(lines):
        line = lines[line_num]
        stripped = line.strip()
        if stripped and not stripped.startswith('#') and stripped != DELIMITER:
            parsed_task = parse_task_line(line)
            lines[line_num] = compose_task_line(
                parsed_task["text"],
                not parsed_task["completed"],
                parsed_task["indent"],
                parsed_task["priority"],
                parsed_task["due"]
            )
        write_lines(lines)
    return parse_todo()

def add_task(section_title, task_text, priority="", due=""):
    lines = read_lines()
    new_line = compose_task_line(task_text, False, 0, priority, due)
    lines = insert_task_into_section(lines, section_title, new_line)
    write_lines(lines)
    return parse_todo()

def add_subtask(parent_line_num, task_text):
    lines = read_lines()
    if not (0 <= parent_line_num < len(lines)):
        return parse_todo()

    parent_line = lines[parent_line_num]
    parent_info = parse_task_line(parent_line)
    parent_indent = parent_info["indent"]
    child_indent = parent_indent + 2
    insert_index = parent_line_num + 1

    while insert_index < len(lines):
        candidate = lines[insert_index]
        candidate_stripped = candidate.strip()
        if not candidate_stripped:
            insert_index += 1
            continue
        if candidate_stripped.startswith('#') or candidate_stripped == DELIMITER:
            break
        candidate_indent = leading_spaces(candidate)
        if candidate_indent <= parent_indent:
            break
        insert_index += 1

    new_line = compose_task_line(task_text, False, child_indent)
    lines.insert(insert_index, new_line)
    write_lines(lines)
    return parse_todo()

def add_section(section_title, color=""):
    lines = read_lines()
    clean_title = section_title.strip()
    if not clean_title:
        return parse_todo()
    ensure_section(lines, clean_title, color)
    write_lines(lines)
    return parse_todo()

def delete_section(section_title):
    lines = read_lines()
    clean_title = section_title.strip()
    if not clean_title:
        return parse_todo()

    bounds = find_section_bounds(lines, clean_title)
    if not bounds:
        return parse_todo()

    start_index, end_index = bounds
    lines = lines[:start_index] + lines[end_index:]

    if start_index > 0 and start_index < len(lines):
        if lines[start_index - 1].strip() == "" and lines[start_index].strip() == "":
            lines.pop(start_index)

    write_lines(lines)
    return parse_todo()

def edit_task(line_num, text, priority, due, section_title):
    lines = read_lines()
    if not (0 <= line_num < len(lines)):
        return parse_todo()

    line = lines[line_num]
    stripped = line.strip()
    if not stripped or stripped.startswith('#') or stripped == DELIMITER:
        return parse_todo()

    old_section = section_for_line(lines, line_num)
    parsed = parse_task_line(line)
    new_text = text.strip() if text.strip() else parsed["text"]
    new_priority = normalize_priority(priority)
    new_due = normalize_due(due)
    target_section = section_title.strip() if section_title.strip() else old_section

    if target_section != old_section:
        lines.pop(line_num)
        moved_line = compose_task_line(new_text, parsed["completed"], 0, new_priority, new_due)
        lines = insert_task_into_section(lines, target_section, moved_line)
    else:
        lines[line_num] = compose_task_line(
            new_text,
            parsed["completed"],
            parsed["indent"],
            new_priority,
            new_due
        )

    write_lines(lines)
    return parse_todo()

def delete_task(line_num):
    lines = read_lines()
    if 0 <= line_num < len(lines):
        lines.pop(line_num)
        write_lines(lines)
    return parse_todo()

def clear_completed():
    lines = read_lines()
    filtered_lines = []
    for line in lines:
        stripped = line.strip()
        if stripped and not stripped.startswith('#') and stripped.startswith('-'):
            continue
        filtered_lines.append(line)
    write_lines(filtered_lines)
    return parse_todo()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(parse_todo())
    else:
        command = sys.argv[1]
        if command == "list":
            print(parse_todo())
        elif command == "toggle":
            print(toggle_task(int(sys.argv[2])))
        elif command == "add":
            section = sys.argv[2]
            text = sys.argv[3]
            priority = sys.argv[4] if len(sys.argv) > 4 else ""
            due = sys.argv[5] if len(sys.argv) > 5 else ""
            print(add_task(section, text, priority, due))
        elif command == "add_subtask":
            parent_line = int(sys.argv[2])
            text = sys.argv[3]
            print(add_subtask(parent_line, text))
        elif command == "add_section":
            title = sys.argv[2]
            color = sys.argv[3] if len(sys.argv) > 3 else ""
            print(add_section(title, color))
        elif command == "delete_section":
            title = sys.argv[2]
            print(delete_section(title))
        elif command == "edit":
            line_num = int(sys.argv[2])
            text = sys.argv[3]
            priority = sys.argv[4] if len(sys.argv) > 4 else ""
            due = sys.argv[5] if len(sys.argv) > 5 else ""
            section_title = sys.argv[6] if len(sys.argv) > 6 else ""
            print(edit_task(line_num, text, priority, due, section_title))
        elif command == "delete":
            print(delete_task(int(sys.argv[2])))
        elif command == "clear_done":
            print(clear_completed())
