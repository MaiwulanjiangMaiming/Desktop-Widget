#  Author: Maiwulanjiang Maiming
#  Email: mawlan.momin@gmail.com

# This widget requires the companion Python script todo_helper.py to function.
# Place todo_helper.py in the same directory as this widget file.

command: "/usr/bin/python3 todo_helper.py list"

refreshFrequency: 60000

style: """
  bottom: 73px
  left: 20px
  width: 300px
  height: 300px
  overflow: hidden
  overflow-x: hidden
  display: flex
  flex-direction: column
  
  font-family: "Avenir Next", "Helvetica Neue", "Segoe UI", sans-serif
  font-weight: 400
  color: #fff
  
  background: rgba(30, 30, 30, 0.65)
  isolation: isolate
  border-radius: 10px
  border: 1px solid rgba(255, 255, 255, 0.1)
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.4)
  
  padding: 10px
  box-sizing: border-box

  @keyframes fadeIn
    from
      opacity: 0
      transform: translateY(-4px)
    to
      opacity: 1
      transform: translateY(0)
  
  @keyframes checkPop
    0%
      transform: scale(0.8)
    50%
      transform: scale(1.2)
    100%
      transform: scale(1)
  
  @keyframes pulse
    0%, 100%
      opacity: 1
    50%
      opacity: 0.6

  ::-webkit-scrollbar
    width: 4px
  ::-webkit-scrollbar-track
    background: transparent
  ::-webkit-scrollbar-thumb
    background: rgba(255, 255, 255, 0.2)
    border-radius: 2px
  ::-webkit-scrollbar-thumb:hover
    background: rgba(255, 255, 255, 0.3)

  h1
    font-family: "Gill Sans", "Avenir Next", sans-serif
    margin: 0 0 10px 0
    font-size: 16px
    font-weight: 600
    text-transform: uppercase
    letter-spacing: 1px
    color: rgba(255, 255, 255, 0.8)
    display: flex
    justify-content: space-between
    align-items: center
    border-bottom: 1px solid rgba(255, 255, 255, 0.1)
    padding-bottom: 6px

  .title-actions
    display: flex
    align-items: center
    gap: 6px

  .refresh-btn
    font-size: 12px
    opacity: 0.65
    cursor: pointer
    transition: all 0.2s ease

  .add-section-btn
    font-size: 14px
    opacity: 0.75
    cursor: pointer
    transition: all 0.2s ease

  .open-file-btn
    font-size: 12px
    opacity: 0.7
    cursor: pointer
    transition: all 0.2s ease

  .refresh-btn:hover, .add-section-btn:hover, .open-file-btn:hover
    opacity: 1
    transform: scale(1.1)

  #todo-content
    overflow-y: auto
    overflow-x: hidden
    height: calc(300px - 46px)

  .section
    margin-bottom: 10px
    animation: fadeIn 0.3s ease

  h2
    margin: 0 0 4px 0
    font-size: 14px
    font-weight: 600
    color: #ffd700
    display: flex
    justify-content: space-between
    align-items: center

  .section-title
    min-width: 0
    overflow: hidden
    text-overflow: ellipsis
    white-space: nowrap

  .section-actions
    display: inline-flex
    align-items: center
    gap: 1px

  .add-btn
    cursor: pointer
    opacity: 0
    transition: all 0.2s ease
    font-size: 14px
    padding: 0 2px
    width: 16px
    text-align: center

  .clear-btn
    cursor: pointer
    opacity: 0
    transition: all 0.2s ease
    font-size: 14px
    padding: 0 2px
    width: 16px
    text-align: center

  .delete-section-btn
    cursor: pointer
    opacity: 0
    transition: all 0.2s ease
    font-size: 13px
    color: #ff8585
    padding: 0 2px
    width: 16px
    text-align: center
  
  h2:hover .add-btn
    opacity: 1

  h2:hover .clear-btn
    opacity: 1

  h2:hover .delete-section-btn
    opacity: 1

  ul
    margin: 0
    padding: 0
    list-style: none

  li
    position: relative
    display: flex
    align-items: flex-start
    padding: 2px 0
    font-size: 14px
    line-height: 1.3
    color: rgba(255, 255, 255, 0.9)
    transition: all 0.2s ease
    animation: fadeIn 0.25s ease

  li:hover
    background: rgba(255, 255, 255, 0.05)
    border-radius: 4px
    margin: 0 -4px
    padding: 2px 4px

  .priority-indicator
    width: 3px
    height: 14px
    border-radius: 2px
    margin-right: 6px
    margin-top: 2px
    flex-shrink: 0
    transition: all 0.2s ease

  .priority-indicator.priority-high
    background: linear-gradient(180deg, #ff5f5f, #ff8585)
    box-shadow: 0 0 6px rgba(255, 95, 95, 0.5)

  .priority-indicator.priority-medium
    background: linear-gradient(180deg, #ffce54, #ffd98a)

  .priority-indicator.priority-low
    background: linear-gradient(180deg, #6dd382, #9de9af)

  .priority-indicator.priority-none
    background: transparent

  .checkbox
    width: 12px
    height: 12px
    border: 1px solid rgba(255, 255, 255, 0.4)
    border-radius: 3px
    margin-right: 8px
    margin-top: 2px
    cursor: pointer
    flex-shrink: 0
    transition: all 0.2s ease
    position: relative

  .checkbox:hover
    border-color: #66ccff
    transform: scale(1.1)

  li.completed .checkbox
    background: #66ccff
    border-color: #66ccff
    animation: checkPop 0.3s ease

  li.completed .checkbox:after
    content: ''
    position: absolute
    left: 3px
    top: 1px
    width: 3px
    height: 6px
    border: solid white
    border-width: 0 1.5px 1.5px 0
    transform: rotate(45deg)

  li.completed .text
    text-decoration: line-through
    color: rgba(255, 255, 255, 0.4)

  .text
    flex-grow: 1
    word-break: break-word
    cursor: pointer

  .text-wrap
    flex-grow: 1
    min-width: 0

  .meta
    margin-top: 2px
    display: flex
    gap: 4px
    flex-wrap: wrap

  .badge
    font-size: 9px
    line-height: 1
    padding: 2px 5px
    border-radius: 8px
    background: rgba(255, 255, 255, 0.12)
    color: rgba(255, 255, 255, 0.78)
    transition: all 0.2s ease

  .badge.due-overdue
    background: rgba(255, 92, 92, 0.25)
    color: #ff9d9d
    animation: pulse 2s infinite

  .badge.due-today
    background: rgba(255, 159, 67, 0.25)
    color: #ffb380

  .badge.due-tomorrow
    background: rgba(255, 206, 84, 0.22)
    color: #ffd98a

  .badge.due-soon
    background: rgba(102, 204, 255, 0.22)
    color: #99ddff

  li.parent-task .text
    font-weight: 500

  li.sub-task .text
    font-size: 12px
    color: rgba(255, 255, 255, 0.72)

  li.sub-task .checkbox
    width: 10px
    height: 10px
    margin-top: 3px

  li.sub-task .priority-indicator
    height: 10px
    margin-top: 3px

  .delete-btn
    opacity: 0
    cursor: pointer
    color: #ff4d4d
    margin-left: 6px
    font-weight: bold
    font-size: 14px
    line-height: 12px
    transition: all 0.2s ease
  
  li:hover .delete-btn
    opacity: 1

  .delete-btn:hover
    transform: scale(1.2)

  .add-sub-btn
    opacity: 0
    cursor: pointer
    color: #66ccff
    margin-left: 6px
    font-weight: bold
    font-size: 13px
    line-height: 12px
    transition: all 0.2s ease

  li:hover .add-sub-btn
    opacity: 1

  .add-sub-btn:hover
    transform: scale(1.2)

  .section-empty
    opacity: 0.45
    font-size: 12px
    padding: 2px 0 4px 20px

  .error
    color: #ff4d4d
    font-size: 11px
"""

render: -> """
  <div class="todo-container">
    <h1>
      <span>Agenda</span>
      <span class="title-actions">
        <span class="add-section-btn" title="Add category">＋</span>
        <span class="open-file-btn" title="Open todo.txt">📄</span>
        <span class="refresh-btn" title="Refresh">↻</span>
      </span>
    </h1>
    <div id="todo-content">Loading...</div>
  </div>
"""

renderOutput: (output, domEl) ->
  try
    if output.trim().startsWith("Traceback") or output.trim().length == 0
      $(domEl).find('#todo-content').html("<div class='error'>Error loading tasks.</div>")
      return

    data = JSON.parse(output)
    html = ""

    escapeHtml = (value) ->
      String(value ? "")
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#39;")
    
    escapeAttr = (value) ->
      escapeHtml(value)
    
    if data.sections.length == 0
      html = "<div style='opacity: 0.5; text-align: center; padding: 20px;'>No tasks found</div>"
    
    for section in data.sections
      actions = ""
      sectionTitle = section.title ? ""
      if section.allow_add != false
        actions += "<span class='add-btn' title='Add task to #{escapeAttr(sectionTitle)}' data-section='#{escapeAttr(sectionTitle)}'>+</span>"
      if section.clearable
        actions += "<span class='clear-btn' title='Clear done tasks'>🆑</span>"
      if section.deletable != false
        actions += "<span class='delete-section-btn' title='Delete category' data-section='#{escapeAttr(sectionTitle)}'>×</span>"

      html += "<div class='section'>"
      html += "<h2><span class='section-title'>#{escapeHtml(sectionTitle)}</span><span class='section-actions'>#{actions}</span></h2>"
      html += "<ul>"
      if !section.tasks or section.tasks.length == 0
        html += "<li class='section-empty'>No tasks</li>"
      for task in section.tasks
        completedClass = if task.completed then "completed" else ""
        priority = task.priority ? ""
        priorityClass = if priority then "priority-#{priority}" else "priority-none"
        level = Math.max(0, Math.floor(parseInt(task.indent ? 0, 10) / 2))
        indentPx = level * 12
        taskTypeClass = if level > 0 then "sub-task" else "parent-task"
        taskText = task.text ? ""
        taskDue = task.due ? ""
        taskDueInfo = task.dueInfo ? {}
        taskSection = task.section ? sectionTitle
        
        dueHtml = ""
        if taskDueInfo.text and taskDueInfo.text.length > 0
          dueStatus = taskDueInfo.status ? ""
          dueHtml = "<span class='badge due-#{escapeAttr(dueStatus)}'>#{escapeHtml(taskDueInfo.text)}</span>"

        html += "<li class='task-item #{taskTypeClass} #{completedClass}' data-id='#{task.id}' data-level='#{level}' data-priority='#{escapeAttr(priority)}' data-due='#{escapeAttr(taskDue)}' data-section='#{escapeAttr(taskSection)}' style='margin-left: #{indentPx}px'>"
        html += "<div class='priority-indicator #{priorityClass}' title='Priority: #{if priority then priority else 'none'}'></div>"
        html += "<div class='checkbox'></div>"
        html += "<div class='text-wrap'>"
        html += "<div class='text edit-task-btn' title='Edit task'>#{escapeHtml(taskText)}</div>"
        html += "<div class='meta'>#{dueHtml}</div>"
        html += "</div>"
        html += "<div class='add-sub-btn' title='Add sub-task'>+</div>"
        html += "<div class='delete-btn' title='Delete'>×</div>"
        html += "</li>"
      html += "</ul>"
      html += "</div>"
    
    $(domEl).find('#todo-content').html(html)
  catch e
    $(domEl).find('#todo-content').html("<div class='error'>Parse Error</div>")
    console.error(e)

update: (output, domEl) ->
  @renderOutput(output, domEl)

afterRender: (domEl) ->
  helperPath = "todo_helper.py"
  pythonCmd = "/usr/bin/python3"

  escapeForAppleScript = (text) ->
    String(text).replace(/\\/g, "\\\\").replace(/"/g, '\\"').replace(/'/g, "\\'")

  shellEscape = (text) ->
    String(text ? "").replace(/'/g, "'\\''")

  refreshData = =>
    @run "#{pythonCmd} #{helperPath} list", (err, output) =>
      if !err && output
        @renderOutput(output, domEl)

  showInputDialog = (titleText, promptText, defaultValue, callback) =>
    safeTitle = escapeForAppleScript(titleText)
    safePrompt = escapeForAppleScript(promptText)
    safeDefault = escapeForAppleScript(defaultValue ? "")
    script = """
    osascript -e 'tell application "Finder" to activate' -e 'tell application "Finder" to display dialog "#{safePrompt}" default answer "#{safeDefault}" with title "#{safeTitle}"' -e 'text returned of result'
    """
    @run script, callback
  
  $(domEl).on 'click', '.checkbox', (e) =>
    e.stopPropagation()
    id = $(e.currentTarget).closest('.task-item').data('id')
    @run "#{pythonCmd} #{helperPath} toggle #{id}", (err, output) =>
      if !err && output
        @renderOutput(output, domEl)

  $(domEl).on 'click', '.delete-btn', (e) =>
    e.stopPropagation()
    id = $(e.currentTarget).closest('.task-item').data('id')
    @run "#{pythonCmd} #{helperPath} delete #{id}", (err, output) =>
      if !err && output
        @renderOutput(output, domEl)

  $(domEl).on 'click', '.add-btn', (e) =>
    e.stopPropagation()
    section = $(e.currentTarget).data('section')

    showInputDialog "New Task", "Add task to #{section}:", "", (err, output) =>
      if !err && output
        taskText = output.trim()
        if taskText.length > 0
          safeTask = shellEscape(taskText)
          safeSectionArg = shellEscape(section)
          
          @run "#{pythonCmd} #{helperPath} add '#{safeSectionArg}' '#{safeTask}'", (addErr, addOutput) =>
            if !addErr && addOutput
              @renderOutput(addOutput, domEl)

  $(domEl).on 'click', '.add-sub-btn', (e) =>
    e.stopPropagation()
    taskEl = $(e.currentTarget).closest('.task-item')
    id = taskEl.data('id')
    parentText = taskEl.find('.text').text()

    showInputDialog "New Sub-task", "Add note under #{parentText}:", "", (err, output) =>
      if !err && output
        taskText = output.trim()
        if taskText.length > 0
          safeTask = shellEscape(taskText)
          @run "#{pythonCmd} #{helperPath} add_subtask #{id} '#{safeTask}'", (addErr, addOutput) =>
            if !addErr && addOutput
              @renderOutput(addOutput, domEl)

  $(domEl).on 'click', '.edit-task-btn', (e) =>
    e.stopPropagation()
    taskEl = $(e.currentTarget).closest('.task-item')
    id = taskEl.data('id')
    currentText = taskEl.find('.edit-task-btn').text().trim()
    currentPriority = String(taskEl.data('priority') ? "").trim()
    currentDue = String(taskEl.data('due') ? "").trim()
    currentSection = String(taskEl.data('section') ? "").trim()

    showInputDialog "Edit Task", "Task content:", currentText, (err1, out1) =>
      if err1 or !out1
        return
      nextText = out1.trim()
      if nextText.length == 0
        return

      showInputDialog "Edit Task", "Priority (high / medium / low, empty = none):", currentPriority, (err2, out2) =>
        if err2 or !out2
          return
        nextPriority = out2.trim().toLowerCase()
        if ["high", "medium", "low"].indexOf(nextPriority) == -1
          nextPriority = ""

        showInputDialog "Edit Task", "Due date (YYYY-MM-DD, empty = none):", currentDue, (err3, out3) =>
          if err3 or !out3
            return
          nextDue = out3.trim()

          showInputDialog "Edit Task", "Category:", currentSection, (err4, out4) =>
            if err4 or !out4
              return
            nextSection = out4.trim()
            if nextSection.length == 0
              nextSection = currentSection

            safeText = shellEscape(nextText)
            safePriority = shellEscape(nextPriority)
            safeDue = shellEscape(nextDue)
            safeSection = shellEscape(nextSection)
            @run "#{pythonCmd} #{helperPath} edit #{id} '#{safeText}' '#{safePriority}' '#{safeDue}' '#{safeSection}'", (editErr, editOutput) =>
              if !editErr && editOutput
                @renderOutput(editOutput, domEl)

  $(domEl).on 'click', '.clear-btn', (e) =>
    e.stopPropagation()
    @run "#{pythonCmd} #{helperPath} clear_done", (err, output) =>
      if !err && output
        @renderOutput(output, domEl)

  $(domEl).on 'click', '.delete-section-btn', (e) =>
    e.stopPropagation()
    section = $(e.currentTarget).data('section')
    if !section
      return
    safeSection = shellEscape(section)
    @run "#{pythonCmd} #{helperPath} delete_section '#{safeSection}'", (err, output) =>
      if !err && output
        @renderOutput(output, domEl)

  $(domEl).on 'click', '.refresh-btn', (e) =>
    e.stopPropagation()
    refreshData()

  $(domEl).on 'click', '.add-section-btn', (e) =>
    e.stopPropagation()
    showInputDialog "New Category", "Category name:", "", (nameErr, nameOutput) =>
      if nameErr or !nameOutput
        return
      sectionName = nameOutput.trim()
      if sectionName.length == 0
        return
      safeName = shellEscape(sectionName)
      @run "#{pythonCmd} #{helperPath} add_section '#{safeName}'", (addErr, addOutput) =>
        if !addErr && addOutput
          @renderOutput(addOutput, domEl)

  $(domEl).on 'click', '.open-file-btn', (e) =>
    e.stopPropagation()
    @run "open \"$HOME/Documents/todo.txt\""
