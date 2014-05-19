{WorkspaceView} = require 'atom'
LogLastCommand = require '../lib/log-last-command'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "LogLastCommand", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('log-last-command')

  describe "when the log-last-command:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.log-last-command')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'log-last-command:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.log-last-command')).toExist()
        atom.workspaceView.trigger 'log-last-command:toggle'
        expect(atom.workspaceView.find('.log-last-command')).not.toExist()
