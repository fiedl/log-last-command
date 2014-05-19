
module.exports =

  # Require rubyjs to provide the magic R() method.
  # require('rubyjs')

  activate: ->
    atom.workspaceView.command "log-last-command:copy-to-other-pane", => @copy_to_other_pane()


  copy_to_other_pane: ->

    panes = atom.workspace.getPanes()
    active_pane = atom.workspace.activePane
    active_pane_item = atom.workspace.activePaneItem

    text_to_insert = ""

    # The active pane is an editor.
    if (typeof(active_pane_item.insertText) == 'function')
      # If something is selected, take the selection.
      # Otherwise, take the current line.
      text_to_insert = active_pane_item.getSelection().getText()
      if text_to_insert == ""
        current_row = active_pane_item.getCursorBufferPosition().row
        text_to_insert = active_pane_item.lineForBufferRow(current_row)

    panes.splice(panes.indexOf(active_pane), 1)

    if panes.length > 0
      other_pane = panes[0]
      other_pane_item = other_pane.activeItem

      # Insert the content to an editor pane:
      if (typeof(other_pane_item.insertText) == 'function')  # responds_to? :insertText
        other_pane_item.insertText text_to_insert

      # Insert the content to a terminal pane:
      else if other_pane_item.hasClass("term2")
        other_pane_item.pty.write text_to_insert
