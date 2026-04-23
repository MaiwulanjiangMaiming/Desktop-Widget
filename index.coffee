#  Author: Maiwulanjiang Maiming
#  Email: mawlan.momin@gmail.com
#
#  Desktop Agenda - A beautiful todo widget for Übersicht
#  Pure CoffeeScript implementation - no Python required!

command: "cat \"$HOME/Documents/todo.txt\" 2>/dev/null || echo ''"

refreshFrequency: 60000

style: """
  bottom: 73px
  left: 20px
  width: 300px
  height: 340px
  overflow: hidden
  overflow-x: hidden
  display: flex
  flex-direction: column
  
  font-family: -apple-system, "SF Pro Display", "Avenir Next", "Helvetica Neue", sans-serif
  font-weight: 400
  color: #fff
  -webkit-font-smoothing: antialiased
  
  background: rgba(30, 30, 35, 0.55)
  border-radius: 14px
  border: 1px solid rgba(255, 255, 255, 0.08)
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5), inset 0 1px 0 rgba(255, 255, 255, 0.06)
  
  padding: 12px
  box-sizing: border-box

  @keyframes fadeIn
    from
      opacity: 0
      transform: translateY(-6px)
    to
      opacity: 1
      transform: translateY(0)
  
  @keyframes checkPop
    0%
      transform: scale(0.6)
    50%
      transform: scale(1.25)
    100%
      transform: scale(1)
  
  @keyframes pulse
    0%, 100%
      opacity: 1
    50%
      opacity: 0.5

  @keyframes shimmer
    0%
      background-position: -200px 0
    100%
      background-position: 200px 0

  @keyframes slideIn
    from
      opacity: 0
      transform: translateX(-8px)
    to
      opacity: 1
      transform: translateX(0)

  ::-webkit-scrollbar
    width: 3px
  ::-webkit-scrollbar-track
    background: transparent
  ::-webkit-scrollbar-thumb
    background: rgba(255, 255, 255, 0.15)
    border-radius: 3px
  ::-webkit-scrollbar-thumb:hover
    background: rgba(255, 255, 255, 0.25)

  .header
    display: flex
    justify-content: space-between
    align-items: center
    margin-bottom: 10px
    padding-bottom: 8px
    border-bottom: 1px solid rgba(255, 255, 255, 0.06)

  .header-left
    display: flex
    align-items: center
    gap: 8px

  .header-icon
    font-size: 14px
    opacity: 0.8

  h1
    font-family: -apple-system, "SF Pro Display", sans-serif
    margin: 0
    font-size: 15px
    font-weight: 600
    letter-spacing: 0.3px
    color: rgba(255, 255, 255, 0.92)

  .header-actions
    display: flex
    align-items: center
    gap: 4px

  .action-btn
    width: 22px
    height: 22px
    display: flex
    align-items: center
    justify-content: center
    border-radius: 6px
    cursor: pointer
    transition: all 0.15s ease
    opacity: 0.5
    font-size: 11px

  .action-btn:hover
    opacity: 1
    background: rgba(255, 255, 255, 0.08)

  .action-btn:active
    transform: scale(0.9)

  .stats-bar
    display: flex
    gap: 6px
    margin-bottom: 8px
    padding-bottom: 8px
    border-bottom: 1px solid rgba(255, 255, 255, 0.04)

  .stat
    font-size: 10px
    color: rgba(255, 255, 255, 0.4)
    display: flex
    align-items: center
    gap: 3px

  .stat-dot
    width: 5px
    height: 5px
    border-radius: 50%

  .stat-dot.active
    background: #66ccff

  .stat-dot.done
    background: rgba(255, 255, 255, 0.25)

  .stat-dot.overdue
    background: #ff5f5f

  .progress-track
    height: 2px
    background: rgba(255, 255, 255, 0.06)
    border-radius: 1px
    margin-bottom: 8px
    overflow: hidden

  .progress-fill
    height: 100%
    background: linear-gradient(90deg, #66ccff, #6dd382)
    border-radius: 1px
    transition: width 0.5s cubic-bezier(0.4, 0, 0.2, 1)

  #todo-content
    overflow-y: auto
    overflow-x: hidden
    height: calc(340px - 100px)

  .section
    margin-bottom: 8px
    animation: fadeIn 0.3s ease

  .section-header
    display: flex
    justify-content: space-between
    align-items: center
    padding: 3px 4px
    margin-bottom: 2px
    border-radius: 4px
    transition: background 0.15s ease

  .section-header:hover
    background: rgba(255, 255, 255, 0.03)

  .section-left
    display: flex
    align-items: center
    gap: 6px
    min-width: 0
    flex: 1

  .section-dot
    width: 6px
    height: 6px
    border-radius: 50%
    background: #ffd700
    flex-shrink: 0

  .section-title
    font-size: 12px
    font-weight: 600
    color: rgba(255, 255, 255, 0.7)
    text-transform: uppercase
    letter-spacing: 0.5px
    overflow: hidden
    text-overflow: ellipsis
    white-space: nowrap

  .section-count
    font-size: 10px
    color: rgba(255, 255, 255, 0.3)
    flex-shrink: 0
    min-width: 14px
    text-align: center

  .section-actions
    display: inline-flex
    align-items: center
    gap: 1px
    opacity: 0
    transition: opacity 0.15s ease

  .section-header:hover .section-actions
    opacity: 1

  .sec-btn
    cursor: pointer
    padding: 0 3px
    font-size: 12px
    transition: all 0.15s ease
    border-radius: 3px
    line-height: 16px

  .sec-btn:hover
    background: rgba(255, 255, 255, 0.08)

  .sec-btn.add-btn
    color: rgba(255, 255, 255, 0.5)

  .sec-btn.clear-btn
    font-size: 10px
    color: rgba(255, 255, 255, 0.4)

  .sec-btn.delete-section-btn
    color: rgba(255, 130, 130, 0.6)

  ul
    margin: 0
    padding: 0
    list-style: none

  li
    position: relative
    display: flex
    align-items: flex-start
    padding: 3px 4px
    font-size: 13px
    line-height: 1.35
    color: rgba(255, 255, 255, 0.88)
    transition: all 0.15s ease
    animation: slideIn 0.2s ease
    border-radius: 5px

  li:hover
    background: rgba(255, 255, 255, 0.04)

  .priority-bar
    width: 2px
    height: 16px
    border-radius: 1px
    margin-right: 8px
    margin-top: 3px
    flex-shrink: 0
    transition: all 0.2s ease

  .priority-bar.high
    background: linear-gradient(180deg, #ff5f5f, #ff8585)
    box-shadow: 0 0 8px rgba(255, 95, 95, 0.4)

  .priority-bar.medium
    background: linear-gradient(180deg, #ffce54, #ffd98a)

  .priority-bar.low
    background: linear-gradient(180deg, #6dd382, #9de9af)

  .priority-bar.none
    background: transparent

  .checkbox
    width: 13px
    height: 13px
    border: 1.5px solid rgba(255, 255, 255, 0.25)
    border-radius: 4px
    margin-right: 8px
    margin-top: 2px
    cursor: pointer
    flex-shrink: 0
    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1)
    position: relative

  .checkbox:hover
    border-color: #66ccff
    background: rgba(102, 204, 255, 0.08)
    transform: scale(1.08)

  li.completed .checkbox
    background: #66ccff
    border-color: #66ccff
    animation: checkPop 0.35s cubic-bezier(0.4, 0, 0.2, 1)

  li.completed .checkbox:after
    content: ''
    position: absolute
    left: 3.5px
    top: 1px
    width: 3px
    height: 6px
    border: solid white
    border-width: 0 1.5px 1.5px 0
    transform: rotate(45deg)

  li.completed .task-text
    text-decoration: line-through
    color: rgba(255, 255, 255, 0.3)

  .task-body
    flex: 1
    min-width: 0

  .task-text
    word-break: break-word
    cursor: pointer
    transition: color 0.15s ease

  .task-text:hover
    color: rgba(255, 255, 255, 1)

  .task-meta
    margin-top: 2px
    display: flex
    gap: 4px
    flex-wrap: wrap

  .tag
    font-size: 9px
    line-height: 1
    padding: 2px 6px
    border-radius: 6px
    background: rgba(255, 255, 255, 0.06)
    color: rgba(255, 255, 255, 0.5)
    transition: all 0.15s ease

  .tag.overdue
    background: rgba(255, 92, 92, 0.18)
    color: #ff9d9d
    animation: pulse 2s infinite

  .tag.today
    background: rgba(255, 159, 67, 0.18)
    color: #ffb380

  .tag.tomorrow
    background: rgba(255, 206, 84, 0.18)
    color: #ffd98a

  .tag.soon
    background: rgba(102, 204, 255, 0.18)
    color: #99ddff

  li.sub-task .task-text
    font-size: 12px
    color: rgba(255, 255, 255, 0.6)

  li.sub-task .checkbox
    width: 11px
    height: 11px
    margin-top: 3px

  li.sub-task .priority-bar
    height: 11px
    margin-top: 4px

  .task-actions
    display: flex
    align-items: center
    gap: 2px
    opacity: 0
    transition: opacity 0.15s ease
    margin-left: 4px
    flex-shrink: 0

  li:hover .task-actions
    opacity: 1

  .task-btn
    cursor: pointer
    padding: 0 2px
    font-size: 12px
    line-height: 14px
    border-radius: 3px
    transition: all 0.15s ease

  .task-btn:hover
    transform: scale(1.15)

  .task-btn.add-sub-btn
    color: rgba(102, 204, 255, 0.6)

  .task-btn.delete-btn
    color: rgba(255, 77, 77, 0.5)

  .empty-section
    opacity: 0.3
    font-size: 11px
    padding: 2px 0 2px 22px
    font-style: italic

  .empty-state
    display: flex
    flex-direction: column
    align-items: center
    justify-content: center
    padding: 30px 20px
    opacity: 0.4

  .empty-state-icon
    font-size: 24px
    margin-bottom: 8px

  .empty-state-text
    font-size: 12px
    text-align: center

  .error
    color: #ff4d4d
    font-size: 11px
"""

render: -> """
  <div class="todo-container">
    <div class="header">
      <div class="header-left">
        <span class="header-icon">✦</span>
        <h1>Agenda</h1>
      </div>
      <div class="header-actions">
        <span class="action-btn add-section-btn" title="Add category">＋</span>
        <span class="action-btn open-file-btn" title="Open todo.txt">📄</span>
        <span class="action-btn refresh-btn" title="Refresh">↻</span>
      </div>
    </div>
    <div class="stats-bar">
      <span class="stat"><span class="stat-dot active"></span><span id="stat-active">0</span></span>
      <span class="stat"><span class="stat-dot done"></span><span id="stat-done">0</span></span>
      <span class="stat"><span class="stat-dot overdue"></span><span id="stat-overdue">0</span></span>
    </div>
    <div class="progress-track"><div class="progress-fill" id="progress-fill" style="width: 0%"></div></div>
    <div id="todo-content">Loading...</div>
  </div>
"""

DELIMITER: '=========='

_cachedContent: null

escapeHtml: (value) ->
  String(value ? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;")

formatDueDate: (dueStr) ->
  return {text: "", status: "", days: null} unless dueStr
  try
    parts = dueStr.split('-')
    return {text: dueStr, status: "unknown", days: null} if parts.length != 3
    year = parseInt(parts[0])
    month = parseInt(parts[1]) - 1
    day = parseInt(parts[2])
    dueDate = new Date(year, month, day)
    today = new Date()
    today.setHours(0, 0, 0, 0)
    dueDate.setHours(0, 0, 0, 0)
    delta = Math.round((dueDate - today) / 86400000)
    if delta < 0
      {text: "已过期 #{-delta}天", status: "overdue", days: delta}
    else if delta == 0
      {text: "今天", status: "today", days: 0}
    else if delta == 1
      {text: "明天", status: "tomorrow", days: 1}
    else if delta <= 7
      {text: "#{delta}天后", status: "soon", days: delta}
    else
      {text: dueStr, status: "future", days: delta}
  catch
    {text: dueStr, status: "unknown", days: null}

parseTaskLine: (line) ->
  indent = line.length - line.trimLeft().length
  stripped = line.trim()
  completed = false
  if stripped.startsWith('-')
    completed = true
    stripped = stripped.substring(1).trim()
  if stripped.startsWith('·')
    stripped = stripped.substring(1).trim()
  parts = stripped.split('|').map (p) -> p.trim()
  text = parts[0] || ""
  priority = ""
  due = ""
  for token in parts.slice(1)
    if token.startsWith('p:')
      val = token.substring(2).toLowerCase()
      priority = val if val in ['high', 'medium', 'low']
    else if token.startsWith('d:')
      due = token.substring(2)
  dueInfo = @formatDueDate(due)
  {indent, completed, text, priority, due, dueInfo}

parseTodo: (content) ->
  return {sections: [], activeCount: 0, doneCount: 0, overdueCount: 0} unless content
  lines = content.split('\n')
  delimiterCount = 0
  startIndex = 0
  if lines.length > 0 and lines[0].trim() == @DELIMITER
    delimiterCount++
  for line, i in lines
    continue if i == 0 and line.trim() == @DELIMITER
    if line.trim() == @DELIMITER
      delimiterCount++
      if delimiterCount >= 2
        startIndex = i + 1
        break
  contentLines = lines.slice(startIndex)
  currentSection = null
  sections = []
  doneTasks = []
  hasHeader = false
  activeCount = 0
  overdueCount = 0
  for line, i in contentLines
    originalLineNum = startIndex + i
    stripped = line.trim()
    continue unless stripped
    if stripped.startsWith('#')
      hasHeader = true
      if currentSection?
        sections.push(currentSection)
      title = stripped.replace(/^#+/, '').trim()
      currentSection = {title, deletable: true, tasks: []}
    else
      if !currentSection?
        currentSection = {title: "Inbox", deletable: false, tasks: [], _implicit: true}
      task = @parseTaskLine(line)
      task.id = originalLineNum
      task.section = currentSection.title
      if task.completed
        doneTasks.push(task)
      else
        activeCount++
        overdueCount++ if task.dueInfo?.status == 'overdue'
        currentSection.tasks.push(task)
  if currentSection?
    sections.push(currentSection)
  if sections.length > 0 and sections[0]._implicit and sections[0].tasks.length == 0 and hasHeader
    sections.shift()
  doneCount = doneTasks.length
  if doneTasks.length > 0
    sections.push({title: "Done", deletable: false, tasks: doneTasks, allow_add: false, clearable: true})
  {sections, activeCount, doneCount, overdueCount}

renderOutput: (content, domEl) ->
  try
    data = @parseTodo(content)
    total = data.activeCount + data.doneCount
    progress = if total > 0 then Math.round(data.doneCount / total * 100) else 0
    
    $(domEl).find('#stat-active').text(data.activeCount)
    $(domEl).find('#stat-done').text(data.doneCount)
    $(domEl).find('#stat-overdue').text(data.overdueCount) if data.overdueCount > 0
    $(domEl).find('#progress-fill').css('width', progress + '%')
    
    html = ""
    if data.sections.length == 0
      html = "<div class='empty-state'><div class='empty-state-icon'>✎</div><div class='empty-state-text'>Add your first task</div></div>"
    
    for section in data.sections
      sectionTitle = section.title ? ""
      taskCount = if section.tasks then section.tasks.length else 0
      
      actions = ""
      if section.allow_add != false
        actions += "<span class='sec-btn add-btn' title='Add task' data-section='#{@escapeHtml(sectionTitle)}'>+</span>"
      if section.clearable
        actions += "<span class='sec-btn clear-btn' title='Clear done'>🆑</span>"
      if section.deletable != false
        actions += "<span class='sec-btn delete-section-btn' title='Delete' data-section='#{@escapeHtml(sectionTitle)}'>×</span>"
      
      html += "<div class='section'>"
      html += "<div class='section-header'>"
      html += "<div class='section-left'><span class='section-dot'></span><span class='section-title'>#{@escapeHtml(sectionTitle)}</span><span class='section-count'>#{taskCount}</span></div>"
      html += "<span class='section-actions'>#{actions}</span>"
      html += "</div>"
      html += "<ul>"
      
      if taskCount == 0
        html += "<li class='empty-section'>empty</li>"
      
      for task in section.tasks
        completedClass = if task.completed then "completed" else ""
        priority = task.priority ? ""
        priorityClass = if priority then priority else "none"
        level = Math.max(0, Math.floor((task.indent ? 0) / 2))
        indentPx = level * 14
        taskTypeClass = if level > 0 then "sub-task" else "parent-task"
        
        dueHtml = ""
        if task.dueInfo?.text
          dueStatus = task.dueInfo.status ? ""
          dueHtml = "<span class='tag #{@escapeHtml(dueStatus)}'>#{@escapeHtml(task.dueInfo.text)}</span>"
        
        html += "<li class='task-item #{taskTypeClass} #{completedClass}' data-id='#{task.id}' data-level='#{level}' data-priority='#{@escapeHtml(priority)}' data-due='#{@escapeHtml(task.due ? "")}' data-section='#{@escapeHtml(task.section ? sectionTitle)}' style='margin-left: #{indentPx}px'>"
        html += "<div class='priority-bar #{priorityClass}'></div>"
        html += "<div class='checkbox'></div>"
        html += "<div class='task-body'>"
        html += "<div class='task-text edit-task-btn'>#{@escapeHtml(task.text)}</div>"
        html += "<div class='task-meta'>#{dueHtml}</div>"
        html += "</div>"
        html += "<div class='task-actions'>"
        html += "<span class='task-btn add-sub-btn' title='Sub-task'>+</span>"
        html += "<span class='task-btn delete-btn' title='Delete'>×</span>"
        html += "</div>"
        html += "</li>"
      
      html += "</ul></div>"
    
    $(domEl).find('#todo-content').html(html)
  catch e
    $(domEl).find('#todo-content').html("<div class='error'>Parse Error</div>")
    console.error(e)

update: (output, domEl) ->
  @_cachedContent = output
  @renderOutput(output, domEl)

saveAndRefresh: (content, domEl) ->
  @_cachedContent = content
  @renderOutput(content, domEl)
  safeContent = content.replace(/'/g, "'\\''")
  @run "echo '#{safeContent}' > \"$HOME/Documents/todo.txt\""

getCachedLines: ->
  (@_cachedContent ? "").split('\n')

toggleLine: (lines, lineNum) ->
  return lines unless 0 <= lineNum < lines.length
  line = lines[lineNum]
  stripped = line.trim()
  return lines if stripped.startsWith('#') or stripped == @DELIMITER
  indent = line.length - line.trimLeft().length
  prefix = line.substring(0, indent)
  content = line.substring(indent)
  if content.startsWith('- ')
    newContent = content.substring(2)
  else if content.startsWith('-')
    newContent = content.substring(1).trimLeft()
  else
    newContent = '- ' + content.trimLeft()
  if !newContent.endsWith('\n')
    newContent += '\n'
  lines[lineNum] = prefix + newContent
  lines

deleteLine: (lines, lineNum) ->
  return lines unless 0 <= lineNum < lines.length
  lines.slice(0, lineNum).concat(lines.slice(lineNum + 1))

findSectionBounds: (lines, sectionTitle) ->
  target = sectionTitle.trim()
  for line, i in lines
    stripped = line.trim()
    continue unless stripped.startsWith('#')
    title = stripped.replace(/^#+/, '').trim()
    if title == target
      nextHeader = lines.length
      for j in [i + 1...lines.length]
        if lines[j].trim().startsWith('#')
          nextHeader = j
          break
      return [i, nextHeader]
  null

afterRender: (domEl) ->
  refreshData = =>
    @run "cat \"$HOME/Documents/todo.txt\" 2>/dev/null || echo ''", (err, output) =>
      if !err && output?
        @_cachedContent = output
        @renderOutput(output, domEl)

  showInputDialog = (titleText, promptText, defaultValue, callback) =>
    safeTitle = titleText.replace(/\\/g, "\\\\").replace(/"/g, '\\"').replace(/'/g, "\\'")
    safePrompt = promptText.replace(/\\/g, "\\\\").replace(/"/g, '\\"').replace(/'/g, "\\'")
    safeDefault = (defaultValue ? "").replace(/\\/g, "\\\\").replace(/"/g, '\\"').replace(/'/g, "\\'")
    script = "osascript -e 'tell application \"Finder\" to activate' -e 'tell application \"Finder\" to display dialog \"#{safePrompt}\" default answer \"#{safeDefault}\" with title \"#{safeTitle}\"' -e 'text returned of result'"
    @run script, callback

  $(domEl).on 'click', '.checkbox', (e) =>
    e.stopPropagation()
    id = $(e.currentTarget).closest('.task-item').data('id')
    lines = @getCachedLines()
    lines = @toggleLine(lines, id)
    @saveAndRefresh lines.join('\n'), domEl

  $(domEl).on 'click', '.delete-btn', (e) =>
    e.stopPropagation()
    id = $(e.currentTarget).closest('.task-item').data('id')
    lines = @getCachedLines()
    lines = @deleteLine(lines, id)
    @saveAndRefresh lines.join('\n'), domEl

  $(domEl).on 'click', '.add-btn', (e) =>
    e.stopPropagation()
    section = $(e.currentTarget).data('section')
    showInputDialog "New Task", "Add task to #{section}:", "", (err, output) =>
      return if err or !output
      taskText = output.trim()
      return if taskText.length == 0
      lines = @getCachedLines()
      targetHeader = "# #{section}"
      insertIndex = lines.length
      sectionFound = false
      for line, i in lines
        if line.trim() == targetHeader
          sectionFound = true
          for j in [i + 1...lines.length]
            if lines[j].trim().startsWith('#') and lines[j].trim() != @DELIMITER
              insertIndex = j
              break
          break
      newLine = "· #{taskText}\n"
      if sectionFound
        lines.splice(insertIndex, 0, newLine)
      else
        if lines.length > 0 and lines[lines.length - 1].trim() != ""
          lines.push("")
        lines.push("")
        lines.push(targetHeader)
        lines.push(newLine)
      @saveAndRefresh lines.join('\n'), domEl

  $(domEl).on 'click', '.add-sub-btn', (e) =>
    e.stopPropagation()
    taskEl = $(e.currentTarget).closest('.task-item')
    id = taskEl.data('id')
    parentText = taskEl.find('.task-text').text()
    showInputDialog "New Sub-task", "Add note under #{parentText}:", "", (err, output) =>
      return if err or !output
      taskText = output.trim()
      return if taskText.length == 0
      lines = @getCachedLines()
      return if id < 0 or id >= lines.length
      parentLine = lines[id]
      parentIndent = parentLine.length - parentLine.trimLeft().length
      childIndent = parentIndent + 2
      insertIndex = id + 1
      while insertIndex < lines.length
        candidate = lines[insertIndex]
        candidateStripped = candidate.trim()
        break if candidateStripped.startsWith('#') or candidateStripped == @DELIMITER
        candidateIndent = candidate.length - candidate.trimLeft().length
        break if candidateIndent <= parentIndent
        insertIndex++
      newLine = " ".repeat(childIndent) + "· #{taskText}\n"
      lines.splice(insertIndex, 0, newLine)
      @saveAndRefresh lines.join('\n'), domEl

  $(domEl).on 'click', '.edit-task-btn', (e) =>
    e.stopPropagation()
    taskEl = $(e.currentTarget).closest('.task-item')
    id = taskEl.data('id')
    currentText = taskEl.find('.edit-task-btn').text().trim()
    currentPriority = String(taskEl.data('priority') ? "").trim()
    currentDue = String(taskEl.data('due') ? "").trim()
    currentSection = String(taskEl.data('section') ? "").trim()
    showInputDialog "Edit Task", "Task content:", currentText, (err1, out1) =>
      return if err1 or !out1
      nextText = out1.trim()
      return if nextText.length == 0
      showInputDialog "Edit Task", "Priority (high/medium/low):", currentPriority, (err2, out2) =>
        return if err2 or !out2
        nextPriority = out2.trim().toLowerCase()
        nextPriority = "" unless nextPriority in ['high', 'medium', 'low']
        showInputDialog "Edit Task", "Due date (YYYY-MM-DD):", currentDue, (err3, out3) =>
          return if err3 or !out3
          nextDue = out3.trim()
          showInputDialog "Edit Task", "Category:", currentSection, (err4, out4) =>
            return if err4 or !out4
            nextSection = out4.trim()
            nextSection = currentSection if nextSection.length == 0
            lines = @getCachedLines()
            return if id < 0 or id >= lines.length
            line = lines[id]
            stripped = line.trim()
            return if stripped.startsWith('#') or stripped == @DELIMITER
            indent = line.length - line.trimLeft().length
            completed = stripped.startsWith('-')
            metadata = []
            if nextPriority
              metadata.push("p:#{nextPriority}")
            if nextDue
              metadata.push("d:#{nextDue}")
            body = "· #{nextText}"
            if metadata.length > 0
              body += " |" + metadata.join(" |")
            prefix = " ".repeat(indent)
            if completed
              lines[id] = "#{prefix}- #{body}\n"
            else
              lines[id] = "#{prefix}#{body}\n"
            @saveAndRefresh lines.join('\n'), domEl

  $(domEl).on 'click', '.clear-btn', (e) =>
    e.stopPropagation()
    lines = @getCachedLines()
    filtered = lines.filter (line) =>
      stripped = line.trim()
      !(stripped and !stripped.startsWith('#') and stripped.startsWith('-'))
    @saveAndRefresh filtered.join('\n'), domEl

  $(domEl).on 'click', '.delete-section-btn', (e) =>
    e.stopPropagation()
    section = $(e.currentTarget).data('section')
    return unless section
    lines = @getCachedLines()
    bounds = @findSectionBounds(lines, section)
    return unless bounds
    [startIdx, endIdx] = bounds
    lines = lines.slice(0, startIdx).concat(lines.slice(endIdx))
    @saveAndRefresh lines.join('\n'), domEl

  $(domEl).on 'click', '.refresh-btn', (e) =>
    e.stopPropagation()
    refreshData()

  $(domEl).on 'click', '.add-section-btn', (e) =>
    e.stopPropagation()
    showInputDialog "New Category", "Category name:", "", (err, output) =>
      return if err or !output
      sectionName = output.trim()
      return if sectionName.length == 0
      lines = @getCachedLines()
      targetHeader = "# #{sectionName}"
      for line in lines
        return if line.trim() == targetHeader
      if lines.length > 0 and lines[lines.length - 1].trim() != ""
        lines.push("")
      lines.push(targetHeader)
      @saveAndRefresh lines.join('\n'), domEl

  $(domEl).on 'click', '.open-file-btn', (e) =>
    e.stopPropagation()
    @run "open \"$HOME/Documents/todo.txt\""
