
module.exports =

  # Require rubyjs to provide the magic R() method.
  # require('rubyjs')

  activate: ->
    atom.workspaceView.command "log-last-command:copy-to-other-pane", => @copy_to_other_pane()
