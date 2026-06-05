#  Author: Maiwulanjiang Maiming
#  Email: mawlan.momin@gmail.com
#
#  Desktop Agenda - A beautiful todo widget for Übersicht
#  Pure CoffeeScript implementation - no Python required!
#
#  --------------------------------------------------------------------------
#  AI features: fill in apiKey below to enable natural-language task input.
#  Any OpenAI-compatible endpoint works (OpenAI / Anthropic-via-proxy / Ollama / etc.)
#  For local Ollama, set apiKey to "" and apiUrl to http://localhost:11434/v1/chat/completions
#  --------------------------------------------------------------------------

command: "cat \"$HOME/Documents/todo.txt\" 2>/dev/null || echo ''"

refreshFrequency: 3600000

AI_CONFIG:
  apiUrl: "https://api.minimaxi.com/v1/chat/completions"
  apiKey: ""
  model: "MiniMax-M2.5-highspeed"

TOKEN_CONFIG:
  monthlyBudget: 1000000
  storageKey: "desktop_agenda_token_usage"

SETTINGS_STORAGE_KEY: "desktop_agenda_ai_settings"

style: """
  bottom: 73px
  left: 20px
  width: 300px
  height: 390px
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

  .token-ring-wrap
    position: relative
    width: 22px
    height: 22px
    display: flex
    align-items: center
    justify-content: center
    cursor: help
    margin-right: 2px

  .token-ring-wrap svg
    width: 22px
    height: 22px
    display: block

  .token-ring-bg
    fill: none
    stroke: rgba(255, 255, 255, 0.1)
    stroke-width: 3

  .token-ring-fg
    fill: none
    stroke-width: 3
    stroke-linecap: round
    transform: rotate(-90deg)
    transform-origin: center
    transition: stroke-dashoffset 0.5s cubic-bezier(0.4, 0, 0.2, 1), stroke 0.3s ease

  .token-ring-fg.low
    stroke: #66ccff

  .token-ring-fg.medium
    stroke: #ffce54

  .token-ring-fg.high
    stroke: #ff8585

  .token-ring-fg.over
    stroke: #ff5f5f

  .token-ring-text
    font-size: 7px
    fill: rgba(255, 255, 255, 0.85)
    text-anchor: middle
    dominant-baseline: central
    font-weight: 600
    font-family: -apple-system, "SF Pro Display", sans-serif
    pointer-events: none

  .token-tooltip
    position: absolute
    top: 30px
    right: -4px
    min-width: 180px
    background: rgba(20, 20, 25, 0.96)
    border: 1px solid rgba(255, 255, 255, 0.12)
    border-radius: 8px
    padding: 10px 12px
    font-size: 11px
    color: rgba(255, 255, 255, 0.9)
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5)
    opacity: 0
    visibility: hidden
    transform: translateY(-4px)
    transition: opacity 0.15s ease, transform 0.15s ease, visibility 0.15s
    z-index: 100
    pointer-events: none
    line-height: 1.6

  .token-ring-wrap:hover .token-tooltip
    opacity: 1
    visibility: visible
    transform: translateY(0)

  .token-tooltip-title
    font-size: 10px
    color: rgba(255, 255, 255, 0.5)
    text-transform: uppercase
    letter-spacing: 0.5px
    margin-bottom: 6px
    padding-bottom: 4px
    border-bottom: 1px solid rgba(255, 255, 255, 0.08)

  .token-tooltip-row
    display: flex
    justify-content: space-between
    gap: 12px
    margin: 2px 0

  .token-tooltip-label
    color: rgba(255, 255, 255, 0.55)

  .token-tooltip-value
    color: rgba(255, 255, 255, 0.92)
    font-weight: 500
    font-variant-numeric: tabular-nums

  .token-tooltip-bar
    margin-top: 6px
    height: 3px
    background: rgba(255, 255, 255, 0.08)
    border-radius: 2px
    overflow: hidden

  .token-tooltip-bar-fill
    height: 100%
    border-radius: 2px
    transition: width 0.3s ease, background 0.3s ease

  .action-btn
    width: 26px
    height: 26px
    display: flex
    align-items: center
    justify-content: center
    border-radius: 7px
    cursor: pointer
    transition: all 0.15s ease
    opacity: 0.5
    font-size: 14px

  .action-btn:hover
    opacity: 1
    background: rgba(255, 255, 255, 0.08)

  .action-btn:active
    transform: scale(0.9)

  .action-btn.open-file-btn
    width: 22px
    height: 22px
    font-size: 11px
    border-radius: 6px

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

  .todo-container
    display: flex
    flex-direction: column
    height: 100%

  #todo-content
    overflow-y: auto
    overflow-x: hidden
    flex: 1
    min-height: 0

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

  .input-bar
    display: flex
    align-items: center
    gap: 6px
    padding-top: 8px
    border-top: 1px solid rgba(255, 255, 255, 0.06)
    margin-top: 6px
    flex-shrink: 0

  .input-field
    flex: 1
    background: rgba(255, 255, 255, 0.06)
    border: 1px solid rgba(255, 255, 255, 0.1)
    border-radius: 8px
    padding: 6px 10px
    font-size: 12px
    line-height: 1.4
    color: rgba(255, 255, 255, 0.9)
    outline: none
    font-family: -apple-system, "SF Pro Display", sans-serif
    transition: all 0.15s ease
    resize: none
    overflow-y: auto
    min-height: 28px
    max-height: 110px
    box-sizing: border-box
    width: 100%
    word-break: break-word
    white-space: pre-wrap
    align-self: center

  .input-field:focus
    border-color: #66ccff
    background: rgba(255, 255, 255, 0.08)
    box-shadow: 0 0 0 2px rgba(102, 204, 255, 0.15)

  .input-field::placeholder
    color: rgba(255, 255, 255, 0.3)

  .input-field:disabled
    opacity: 0.5
    cursor: not-allowed

  .send-btn
    width: 28px
    height: 28px
    display: flex
    align-items: center
    justify-content: center
    border-radius: 7px
    background: rgba(102, 204, 255, 0.15)
    color: #66ccff
    cursor: pointer
    font-size: 13px
    transition: all 0.15s ease
    flex-shrink: 0

  .send-btn:hover
    background: rgba(102, 204, 255, 0.25)

  .send-btn:disabled
    opacity: 0.3
    cursor: not-allowed

  .ai-status
    font-size: 10px
    color: rgba(102, 204, 255, 0.6)
    padding-top: 3px
    display: none
    flex-shrink: 0

  .ai-status.visible
    display: block
    animation: pulse 1.5s infinite

  .ai-status.error
    color: #ff9d9d
    animation: none

  .settings-overlay
    position: fixed
    top: 0
    left: 0
    right: 0
    bottom: 0
    background: rgba(0, 0, 0, 0.55)
    display: none
    align-items: center
    justify-content: center
    z-index: 200
    backdrop-filter: blur(4px)
    -webkit-backdrop-filter: blur(4px)

  .settings-overlay.visible
    display: flex

  .settings-modal
    width: 280px
    background: rgba(30, 30, 35, 0.98)
    border: 1px solid rgba(255, 255, 255, 0.12)
    border-radius: 12px
    padding: 16px
    box-shadow: 0 16px 48px rgba(0, 0, 0, 0.6)
    color: #fff
    font-family: -apple-system, "SF Pro Display", sans-serif
    animation: fadeIn 0.2s ease

  .settings-title
    display: flex
    justify-content: space-between
    align-items: center
    margin-bottom: 12px
    padding-bottom: 8px
    border-bottom: 1px solid rgba(255, 255, 255, 0.08)

  .settings-title-text
    font-size: 13px
    font-weight: 600
    color: rgba(255, 255, 255, 0.92)

  .settings-close
    cursor: pointer
    color: rgba(255, 255, 255, 0.5)
    font-size: 16px
    line-height: 1
    padding: 2px 6px
    border-radius: 4px
    transition: all 0.15s ease

  .settings-close:hover
    background: rgba(255, 255, 255, 0.08)
    color: rgba(255, 255, 255, 0.9)

  .settings-hint
    font-size: 10px
    color: rgba(255, 255, 255, 0.4)
    margin-bottom: 10px
    line-height: 1.5

  .settings-field
    margin-bottom: 10px

  .settings-label
    display: flex
    justify-content: space-between
    align-items: center
    font-size: 10px
    color: rgba(255, 255, 255, 0.55)
    text-transform: uppercase
    letter-spacing: 0.5px
    margin-bottom: 4px

  .settings-label-hint
    color: rgba(255, 255, 255, 0.3)
    text-transform: none
    letter-spacing: 0
    font-size: 9px

  .settings-input-wrap
    position: relative
    display: flex
    align-items: center

  .settings-input
    width: 100%
    background: rgba(255, 255, 255, 0.06)
    border: 1px solid rgba(255, 255, 255, 0.1)
    border-radius: 6px
    padding: 6px 28px 6px 8px
    font-size: 11px
    color: rgba(255, 255, 255, 0.92)
    font-family: -apple-system, "SF Pro Display", monospace
    outline: none
    box-sizing: border-box
    transition: all 0.15s ease

  .settings-input:focus
    border-color: #66ccff
    background: rgba(255, 255, 255, 0.08)
    box-shadow: 0 0 0 2px rgba(102, 204, 255, 0.15)

  .settings-input::placeholder
    color: rgba(255, 255, 255, 0.25)

  .settings-eye
    position: absolute
    right: 6px
    cursor: pointer
    color: rgba(255, 255, 255, 0.4)
    font-size: 12px
    padding: 2px 4px
    border-radius: 3px
    user-select: none
    transition: color 0.15s ease

  .settings-eye:hover
    color: rgba(255, 255, 255, 0.85)

  .settings-actions
    display: flex
    gap: 6px
    margin-top: 12px
    padding-top: 10px
    border-top: 1px solid rgba(255, 255, 255, 0.08)

  .settings-btn
    flex: 1
    padding: 6px 10px
    border-radius: 6px
    font-size: 11px
    cursor: pointer
    text-align: center
    border: none
    font-family: -apple-system, "SF Pro Display", sans-serif
    transition: all 0.15s ease

  .settings-btn.primary
    background: rgba(102, 204, 255, 0.2)
    color: #66ccff
    font-weight: 500

  .settings-btn.primary:hover
    background: rgba(102, 204, 255, 0.32)

  .settings-btn.secondary
    background: rgba(255, 255, 255, 0.06)
    color: rgba(255, 255, 255, 0.6)

  .settings-btn.secondary:hover
    background: rgba(255, 255, 255, 0.1)
    color: rgba(255, 255, 255, 0.85)

  .settings-btn.danger
    background: rgba(255, 92, 92, 0.1)
    color: rgba(255, 130, 130, 0.7)

  .settings-btn.danger:hover
    background: rgba(255, 92, 92, 0.2)
    color: #ff9d9d

  .settings-status
    font-size: 10px
    margin-top: 6px
    text-align: center
    min-height: 14px
    color: rgba(102, 204, 255, 0.7)

  .settings-status.error
    color: #ff9d9d

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
        <div class="token-ring-wrap" id="token-ring">
          <svg viewBox="0 0 22 22">
            <circle class="token-ring-bg" cx="11" cy="11" r="8.5"></circle>
            <circle class="token-ring-fg low" id="token-ring-fg" cx="11" cy="11" r="8.5" stroke-dasharray="53.41" stroke-dashoffset="53.41"></circle>
            <text class="token-ring-text" id="token-ring-text" x="11" y="11">0%</text>
          </svg>
          <div class="token-tooltip" id="token-tooltip">
            <div class="token-tooltip-title">Token Usage</div>
            <div class="token-tooltip-row"><span class="token-tooltip-label">Used</span><span class="token-tooltip-value" id="tt-used">0</span></div>
            <div class="token-tooltip-row"><span class="token-tooltip-label">Budget</span><span class="token-tooltip-value" id="tt-budget">—</span></div>
            <div class="token-tooltip-row"><span class="token-tooltip-label">Remaining</span><span class="token-tooltip-value" id="tt-remaining">—</span></div>
            <div class="token-tooltip-row"><span class="token-tooltip-label">Calls</span><span class="token-tooltip-value" id="tt-calls">0</span></div>
            <div class="token-tooltip-row"><span class="token-tooltip-label">Last call</span><span class="token-tooltip-value" id="tt-last">—</span></div>
            <div class="token-tooltip-bar"><div class="token-tooltip-bar-fill" id="tt-bar-fill" style="width: 0%"></div></div>
          </div>
        </div>
        <span class="action-btn settings-btn-icon" title="AI Settings">⚙</span>
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
    <div class="input-bar">
      <textarea class="input-field" id="ai-input" placeholder="Type a task or command..." rows="1" autocomplete="off" spellcheck="false"></textarea>
      <span class="send-btn" id="ai-send-btn">↑</span>
    </div>
    <div class="ai-status" id="ai-status">AI processing...</div>
  </div>
  <div class="settings-overlay" id="settings-overlay">
    <div class="settings-modal">
      <div class="settings-title">
        <span class="settings-title-text">⚙ AI Settings</span>
        <span class="settings-close" id="settings-close">×</span>
      </div>
      <div class="settings-hint">Fill in your AI provider details. Saved locally in this widget only.</div>
      <div class="settings-field">
        <div class="settings-label">API URL <span class="settings-label-hint">/chat/completions endpoint</span></div>
        <div class="settings-input-wrap"><input type="text" class="settings-input" id="setting-api-url" placeholder="https://api.openai.com/v1/chat/completions" /></div>
      </div>
      <div class="settings-field">
        <div class="settings-label">API Key <span class="settings-label-hint">leave empty if not required</span></div>
        <div class="settings-input-wrap">
          <input type="password" class="settings-input" id="setting-api-key" placeholder="sk-..." />
          <span class="settings-eye" id="setting-api-key-eye">👁</span>
        </div>
      </div>
      <div class="settings-field">
        <div class="settings-label">Model <span class="settings-label-hint">e.g. gpt-4o-mini</span></div>
        <div class="settings-input-wrap"><input type="text" class="settings-input" id="setting-model" placeholder="gpt-4o-mini" /></div>
      </div>
      <div class="settings-field">
        <div class="settings-label">Monthly Token Budget <span class="settings-label-hint">0 = hide ring</span></div>
        <div class="settings-input-wrap"><input type="number" class="settings-input" id="setting-budget" min="0" step="10000" placeholder="1000000" /></div>
      </div>
      <div class="settings-actions">
        <span class="settings-btn danger" id="settings-reset">Reset</span>
        <span class="settings-btn secondary" id="settings-cancel">Cancel</span>
        <span class="settings-btn primary" id="settings-save">Save</span>
      </div>
      <div class="settings-status" id="settings-status"></div>
    </div>
  </div>
"""

DELIMITER: '=========='

_cachedContent: null
_commandHistory: []
_historyIndex: -1
_draftBeforeHistory: ""

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

buildAIPrompt: ->
  today = new Date()
  y = today.getFullYear()
  m = String(today.getMonth() + 1).padStart(2, '0')
  d = String(today.getDate()).padStart(2, '0')
  dateStr = "#{y}-#{m}-#{d}"
  """You are a task management assistant. The user sends natural-language commands in Chinese (mostly). Understand the intent and return the updated full task list.

## File format rules
- Lines starting with # are category titles, e.g. # Work
- Lines starting with · are pending tasks, e.g. · write report |p:high |d:2026-06-15
- Lines starting with - are completed tasks (- space then content), e.g. - · write report |p:high |d:2026-06-15
- |p:high / |p:medium / |p:low for priority
- |d:YYYY-MM-DD for due date
- 2-space indent means a sub-task

## Behavior rules
1. Output ONLY the updated full file content. No explanation, no comments, no markdown fences.
2. Execute the intent: add / complete / delete / modify / new category, etc.
3. When adding a task without a specified category, place it in the most appropriate existing category; otherwise use # Inbox.
4. New tasks default to · prefix.
5. "完成/做完了/搞定了/done" → mark the matching task(s) as completed (prefix with - ).
6. "删除/去掉/remove" → delete the matching task(s).
7. Preserve existing task metadata (priority, due date) when unchanged.
8. Parse provided due date / priority tokens and attach them.
9. Today's date is #{dateStr}. Interpret relative dates accordingly (今天=0, 明天=+1, 这周=next Sunday, 下周=+7, etc.).
10. If the message is unrelated to tasks, return the list unchanged.

## Batch / multi-task rules (IMPORTANT)
11. When the user lists multiple items with separators like "、" / "和" / "and" / ",", apply the SAME operation to ALL matching items in a single response.
    Examples:
    - "把 A 和 B 都删了" → delete both A and B
    - "A、B、C 都完成了" → mark A, B, C as completed
    - "添加三个任务：X、Y、Z" → add three new tasks
12. When the user provides a list of new tasks in one message, create ALL of them in one response.
13. When the user says "移到 X 分类" or "move to X", remove the task from its current category and place it under the target category header (create the category if it doesn't exist).
14. Sub-tasks: if the user says "在 X 下加一个子任务 Y", insert Y with 2-space indent directly below X.
15. For ambiguous matches, prefer the most recent / first match rather than asking for clarification.
16. Return the FULL file content every time, not just the diff."""

callAI: (userInput, domEl) ->
  content = @_cachedContent ? ""
  inputField = $(domEl).find('#ai-input')
  sendBtn = $(domEl).find('#ai-send-btn')
  statusEl = $(domEl).find('#ai-status')

  if @_commandHistory[@_commandHistory.length - 1] != userInput
    @_commandHistory.push(userInput)
    if @_commandHistory.length > 30
      @_commandHistory.shift()
  @_historyIndex = -1
  @_draftBeforeHistory = ""

  inputField.prop('disabled', true)
  sendBtn.prop('disabled', true)
  statusEl.text('AI processing...').addClass('visible')

  systemPrompt = @buildAIPrompt()
  userMessage = "Current task list:\n#{content}\n\nUser input: #{userInput}"

  headers = { "Content-Type": "application/json" }
  if @AI_CONFIG.apiKey
    headers["Authorization"] = "Bearer #{@AI_CONFIG.apiKey}"

  requestBody = JSON.stringify({
    model: @AI_CONFIG.model
    messages: [
      { role: "system", content: systemPrompt }
      { role: "user", content: userMessage }
    ]
    temperature: 0.3
  })

  self = @
  fetch(@AI_CONFIG.apiUrl, {
    method: "POST"
    headers: headers
    body: requestBody
  })
  .then (response) ->
    if !response.ok
      throw new Error("HTTP " + response.status)
    response.json()
  .then (data) ->
    inputField.prop('disabled', false)
    sendBtn.prop('disabled', false)
    statusEl.removeClass('visible').text('AI processing...')
    @_resetInput(domEl)

    if data.choices?[0]?.message?.content
      newContent = data.choices[0].message.content.trim()
      newContent = newContent.replace(/^```[a-z]*\n?/i, '').replace(/\n?```$/, '')
      newContent = newContent.replace(/<think\s*\/?>[\s\S]*?<\/think\s*\/?>/gi, '')
      newContent = newContent.trim()
      totalTokens = parseInt(data.usage?.total_tokens) || 0
      if totalTokens > 0
        self._recordTokenUsage(totalTokens, domEl)
      if newContent.length > 0
        self.saveAndRefresh(newContent, domEl)
      else
        self._showError(statusEl, "Empty response, list unchanged")
    else if data.base_resp?.status_msg
      self._showError(statusEl, "AI: " + data.base_resp.status_msg)
    else
      self._showError(statusEl, "Unexpected response format")
  .catch (err) ->
    inputField.prop('disabled', false)
    sendBtn.prop('disabled', false)
    self._showError(statusEl, "Failed: " + (err.message || err))
    console.error("AI error:", err)

_showError: (statusEl, msg) ->
  statusEl.text(msg).addClass('visible error')
  setTimeout (=> statusEl.removeClass('visible error').text('AI processing...')), 4000

_tokenUsageCache: null

_currentMonthKey: ->
  t = new Date()
  "#{t.getFullYear()}-#{String(t.getMonth() + 1).padStart(2, '0')}"

_loadTokenUsage: (callback) ->
  @_tokenUsageCache = {month: @_currentMonthKey(), totalTokens: 0, calls: 0, lastCallAt: null}
  try
    raw = localStorage.getItem(@TOKEN_CONFIG.storageKey)
    if raw
      parsed = JSON.parse(raw)
      if parsed.month == @_currentMonthKey()
        @_tokenUsageCache.totalTokens = parseInt(parsed.totalTokens) || 0
        @_tokenUsageCache.calls = parseInt(parsed.calls) || 0
        @_tokenUsageCache.lastCallAt = parseInt(parsed.lastCallAt) || null
  catch
    pass
  callback?(@_tokenUsageCache)

_recordTokenUsage: (tokens, domEl) ->
  @_tokenUsageCache ?= {month: @_currentMonthKey(), totalTokens: 0, calls: 0, lastCallAt: null}
  if @_tokenUsageCache.month != @_currentMonthKey()
    @_tokenUsageCache = {month: @_currentMonthKey(), totalTokens: 0, calls: 0, lastCallAt: null}
  @_tokenUsageCache.totalTokens += tokens
  @_tokenUsageCache.calls += 1
  @_tokenUsageCache.lastCallAt = Date.now()
  @_saveTokenUsage()
  @_renderTokenRing(domEl)

_saveTokenUsage: ->
  try
    localStorage.setItem(@TOKEN_CONFIG.storageKey, JSON.stringify(@_tokenUsageCache))
  catch
    pass

_formatNumber: (n) ->
  n = parseInt(n) || 0
  if n >= 1000000
    (n / 1000000).toFixed(2) + "M"
  else if n >= 1000
    (n / 1000).toFixed(1) + "k"
  else
    String(n)

_formatRelativeTime: (ts) ->
  return "—" unless ts
  diff = Date.now() - ts
  if diff < 60000 then "just now"
  else if diff < 3600000 then Math.floor(diff / 60000) + "m ago"
  else if diff < 86400000 then Math.floor(diff / 3600000) + "h ago"
  else Math.floor(diff / 86400000) + "d ago"

_renderTokenRing: (domEl) ->
  return unless @_tokenUsageCache
  return unless domEl
  $ring = $(domEl).find('#token-ring-fg')
  $text = $(domEl).find('#token-ring-text')
  $used = $(domEl).find('#tt-used')
  $budget = $(domEl).find('#tt-budget')
  $remaining = $(domEl).find('#tt-remaining')
  $calls = $(domEl).find('#tt-calls')
  $last = $(domEl).find('#tt-last')
  $bar = $(domEl).find('#tt-bar-fill')
  return unless $ring.length

  circumference = 2 * Math.PI * 8.5
  used = @_tokenUsageCache.totalTokens
  budget = parseInt(@TOKEN_CONFIG.monthlyBudget) || 0
  pct = if budget > 0 then Math.min(100, Math.round(used / budget * 100)) else 0
  remaining = Math.max(0, budget - used)

  dashOffset = circumference * (1 - pct / 100)
  $ring.attr('stroke-dasharray', circumference.toFixed(2))
  $ring.attr('stroke-dashoffset', dashOffset.toFixed(2))

  levelClass = if pct >= 100 then 'over' else if pct >= 80 then 'high' else if pct >= 50 then 'medium' else 'low'
  $ring.attr('class', "token-ring-fg #{levelClass}")
  $text.text(if pct >= 100 then "!" else "#{pct}%")

  $used.text(@_formatNumber(used))
  $budget.text(if budget > 0 then @_formatNumber(budget) else "—")
  $remaining.text(if budget > 0 then @_formatNumber(remaining) else "—")
  $calls.text(@_tokenUsageCache.calls)
  $last.text(@_formatRelativeTime(@_tokenUsageCache.lastCallAt))

  $bar.css('width', Math.min(100, pct) + '%')
  barColor = if pct >= 100 then '#ff5f5f' else if pct >= 80 then '#ff8585' else if pct >= 50 then '#ffce54' else '#66ccff'
  $bar.css('background', barColor)

_loadStoredConfig: ->
  try
    raw = localStorage.getItem(@SETTINGS_STORAGE_KEY)
    if raw
      stored = JSON.parse(raw)
      @AI_CONFIG.apiUrl = String(stored.apiUrl || @AI_CONFIG.apiUrl)
      @AI_CONFIG.apiKey = String(if stored.apiKey != null then stored.apiKey else @AI_CONFIG.apiKey)
      @AI_CONFIG.model = String(stored.model || @AI_CONFIG.model)
      @TOKEN_CONFIG.monthlyBudget = parseInt(stored.monthlyBudget) || @TOKEN_CONFIG.monthlyBudget
  catch
    pass

_saveStoredConfig: (cfg) ->
  try
    localStorage.setItem(@SETTINGS_STORAGE_KEY, JSON.stringify(cfg))
    return true
  catch
    return false

_resetStoredConfig: ->
  try
    localStorage.removeItem(@SETTINGS_STORAGE_KEY)
  catch
    pass

_openSettings: (domEl) ->
  $(domEl).find('#setting-api-url').val(@AI_CONFIG.apiUrl)
  $(domEl).find('#setting-api-key').val(@AI_CONFIG.apiKey).attr('type', 'password')
  $(domEl).find('#setting-model').val(@AI_CONFIG.model)
  $(domEl).find('#setting-budget').val(@TOKEN_CONFIG.monthlyBudget)
  $(domEl).find('#settings-status').text('').removeClass('error')
  $(domEl).find('#settings-overlay').addClass('visible')
  setTimeout (=> $(domEl).find('#setting-api-key').focus()), 100

_closeSettings: (domEl) ->
  $(domEl).find('#settings-overlay').removeClass('visible')

_saveSettingsFromUI: (domEl) ->
  apiUrl = $(domEl).find('#setting-api-url').val().trim()
  apiKey = $(domEl).find('#setting-api-key').val()
  model = $(domEl).find('#setting-model').val().trim()
  budget = parseInt($(domEl).find('#setting-budget').val()) || 0
  $status = $(domEl).find('#settings-status').removeClass('error')

  if apiUrl.length == 0
    $status.text('API URL cannot be empty').addClass('error')
    return
  if model.length == 0
    $status.text('Model cannot be empty').addClass('error')
    return

  @AI_CONFIG.apiUrl = apiUrl
  @AI_CONFIG.apiKey = apiKey
  @AI_CONFIG.model = model
  @TOKEN_CONFIG.monthlyBudget = budget

  ok = @_saveStoredConfig({
    apiUrl: apiUrl
    apiKey: apiKey
    model: model
    monthlyBudget: budget
  })

  if ok
    $status.text('✓ Saved').removeClass('error')
    setTimeout (=> @_closeSettings(domEl); @_renderTokenRing(domEl)), 600
  else
    $status.text('Failed to save').addClass('error')

_autoResize: (domEl) ->
  $input = $(domEl).find('#ai-input')
  return unless $input.length
  return if $input.prop('disabled')
  $input[0].style.height = 'auto'
  naturalH = $input[0].scrollHeight
  $input[0].style.height = Math.min(110, Math.max(28, naturalH)) + 'px'
  $input[0].scrollTop = $input[0].scrollHeight

_resetInput: (domEl) ->
  $input = $(domEl).find('#ai-input')
  $input.val('')
  @_autoResize(domEl)

afterRender: (domEl) ->
  @_loadStoredConfig()
  @_loadTokenUsage (usage) =>
    @_renderTokenRing(domEl)

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

  $(domEl).on 'input', '#ai-input', (e) =>
    @_autoResize(domEl)

  $(domEl).on 'keydown', '#ai-input', (e) =>
    inputEl = $(e.currentTarget)
    key = e.key
    code = e.keyCode

    if key == 'Enter' or code == 13
      if e.shiftKey
        return
      e.preventDefault()
      val = inputEl.val().trim()
      return if val.length == 0
      @callAI(val, domEl)
      return

    if key == 'Escape' or code == 27
      e.preventDefault()
      @_resetInput(domEl)
      @_historyIndex = -1
      @_draftBeforeHistory = ""
      return

    if (key == 'ArrowUp' or code == 38) and @_commandHistory.length > 0
      e.preventDefault()
      if @_historyIndex == -1
        @_draftBeforeHistory = inputEl.val()
        @_historyIndex = @_commandHistory.length - 1
      else if @_historyIndex > 0
        @_historyIndex--
      inputEl.val(@_commandHistory[@_historyIndex] ? "")
      setTimeout((=>
        inputEl[0].selectionStart = inputEl.val().length
        @_autoResize(domEl)
      ), 0)
      return

    if (key == 'ArrowDown' or code == 40)
      e.preventDefault()
      if @_historyIndex == -1
        return
      if @_historyIndex < @_commandHistory.length - 1
        @_historyIndex++
        inputEl.val(@_commandHistory[@_historyIndex] ? "")
      else
        @_historyIndex = -1
        inputEl.val(@_draftBeforeHistory)
      setTimeout((=> @_autoResize(domEl)), 0)
      return

    if key == 'Tab' or code == 9
      e.preventDefault()
      inputEl.val(inputEl.val() + ' ') if inputEl.val().length > 0 and !inputEl.val().endsWith(' ')

  $(domEl).on 'click', '#ai-send-btn', (e) =>
    e.stopPropagation()
    val = $(domEl).find('#ai-input').val().trim()
    return if val.length == 0
    @callAI(val, domEl)

  $(domEl).on 'click', '.settings-btn-icon', (e) =>
    e.stopPropagation()
    @_openSettings(domEl)

  $(domEl).on 'click', '#settings-close, #settings-cancel', (e) =>
    e.stopPropagation()
    @_closeSettings(domEl)

  $(domEl).on 'click', '#settings-save', (e) =>
    e.stopPropagation()
    @_saveSettingsFromUI(domEl)

  $(domEl).on 'click', '#settings-reset', (e) =>
    e.stopPropagation()
    $status = $(domEl).find('#settings-status')
    $reset = $(e.currentTarget)
    if $reset.data('confirming')
      @_resetStoredConfig()
      @AI_CONFIG.apiUrl = "https://api.minimaxi.com/v1/chat/completions"
      @AI_CONFIG.apiKey = ""
      @AI_CONFIG.model = "MiniMax-M2.5-highspeed"
      @TOKEN_CONFIG.monthlyBudget = 1000000
      $reset.data('confirming', false).text('Reset')
      $status.text('✓ Reset to defaults').removeClass('error')
      @_openSettings(domEl)
      setTimeout (=> @_closeSettings(domEl); @_renderTokenRing(domEl)), 800
    else
      $reset.data('confirming', true).text('Click again to confirm')
      $status.text('Click Reset again to confirm').removeClass('error')
      setTimeout (=> $reset.data('confirming', false).text('Reset') if $reset.data('confirming')), 3000

  $(domEl).on 'click', '#settings-overlay', (e) =>
    if e.target == e.currentTarget
      @_closeSettings(domEl)

  $(domEl).on 'click', '#setting-api-key-eye', (e) =>
    e.stopPropagation()
    $input = $(domEl).find('#setting-api-key')
    if $input.attr('type') == 'password'
      $input.attr('type', 'text')
      $(e.currentTarget).text('🙈')
    else
      $input.attr('type', 'password')
      $(e.currentTarget).text('👁')

  $(domEl).on 'keydown', '.settings-input', (e) =>
    if e.key == 'Enter' or e.keyCode == 13
      e.preventDefault()
      @_saveSettingsFromUI(domEl)
    if e.key == 'Escape' or e.keyCode == 27
      e.preventDefault()
      @_closeSettings(domEl)

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
