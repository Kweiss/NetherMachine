local L = NetherMachine.locale.get

NetherMachine.protected.generic_check = false

function NetherMachine.protected.Generic()
	if not NetherMachine.protected.method and not NetherMachine.faceroll.rolling then
		pcall(RunMacroText, "/run NetherMachine.protected.generic_check = true")
		if NetherMachine.protected.generic_check then
			NetherMachine.protected.unlocked = true
			NetherMachine.protected.method = "generic"
			NetherMachine.timer.unregister('detectUnlock')
			NetherMachine.print(L('unlock_generic'))

			function Cast(spell, target)
				if type(spell) == "number" then
					CastSpellByID(spell, target)
				else
					CastSpellByName(spell, target)
				end
			end

			function CastGround(spell, target)
				local stickyValue = GetCVar("deselectOnClick")
				SetCVar("deselectOnClick", "0")
				CameraOrSelectOrMoveStart(1)
				Cast(spell)
				CameraOrSelectOrMoveStop(1)
				SetCVar("deselectOnClick", "1")
				SetCVar("deselectOnClick", stickyValue)
			end

			function Macro(text)
				return RunMacroText(text)
			end

			function UseItem(name, target)
				return UseItemByName(name, target)
			end

			-- this will work for now
			if IsMacClient() then
				NetherMachine.timer.register("detectWoWSX", function()
					NetherMachine.protected.WoWSX()
				end, 1000)
			end

		else
			NetherMachine.faceroll.rolling = true
			NetherMachine.faceroll.noticed = false
		end
	elseif NetherMachine.faceroll.rolling and not NetherMachine.faceroll.noticed then
		NetherMachine.print(L('unlock_none'))
		NetherMachine.faceroll.noticed = true
	end
end
