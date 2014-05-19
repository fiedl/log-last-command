
module.exports =

  # Require rubyjs to provide the magic R() method.
  # require('rubyjs')

  activate: ->
    atom.workspaceView.command "log-last-command:copy-to-other-pane", => @copy_to_other_pane()

  copy_to_other_pane: ->
    @insert_to_other_pane_item(@text_to_insert())

  text_to_insert: ->
    if @pane_item_is_editor(@active_pane_item())
      text_to_insert = @active_pane_item().getSelection().getText()
      if text_to_insert == ""
        current_row = @active_pane_item().getCursorBufferPosition().row
        text_to_insert = @active_pane_item().lineForBufferRow(current_row)
      return text_to_insert
    else if @pane_item_is_terminal(@active_pane_item())
      lines = @active_pane_item().text().split("\n")
      text_to_insert = lines.pop()
      console.log text_to_insert
      return text_to_insert
    else
      return ""

  insert_to_other_pane_item: (text)->
    if @other_pane_item_exists()
      if @pane_item_is_editor(@other_pane_item())
        @other_pane_item().insertText text
      else if @pane_item_is_terminal(@other_pane_item())
        @other_pane_item().pty.write text

  active_pane_item: ->
    atom.workspace.activePaneItem

  other_pane_item: ->
    tmp_panes = @panes()
    tmp_panes.splice(tmp_panes.indexOf(@active_pane_item()))
    if tmp_panes.length > 0
      return tmp_panes[0].activeItem

  other_pane_item_exists: ->
    typeof(@other_pane_item()) != 'undefined'

  panes: ->
    atom.workspace.getPanes()

  pane_item_is_editor: (pane_item) ->
    # The pane item responds to the 'insertText' method and
    # therefore is an editor.
    typeof(pane_item.insertText) == 'function'

  pane_item_is_terminal: (pane_item) ->
    # The pane item is a div and has the class 'term2'.
    (typeof(pane_item.hasClass) == 'function') && (pane_item.hasClass('term2'))
