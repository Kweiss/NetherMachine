local L = NetherMachine.locale.get

NetherMachine.toggle = {}

NetherMachine.toggle.create = function(toggle_name, icon, tooltipl1, tooltipl2, callback)
  local toggleCallback = function(self)
    self.checked = not self.checked
    if self.checked then
      NetherMachine.buttons.setActive(toggle_name)
    else
      NetherMachine.buttons.setInactive(toggle_name)
    end
    NetherMachine.config.write('button_states', toggle_name, self.checked)
    if callback then callback(self, mouseButton) end
  end
  NetherMachine.buttons.create(toggle_name, icon, toggleCallback, tooltipl1, tooltipl2)
  NetherMachine.buttons.loadStates()
end
