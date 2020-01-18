function PlayerModifiersString(player)
  local pn = ToEnumShortString(player)

	local PlayerState = GAMESTATE:GetPlayerState(player)
	-- grab the song options from this PlayerState
	local PlayerOptions = PlayerState:GetPlayerOptionsArray(0)
	-- start with an empty string...
	local optionslist = ""

	-- if the player used an xMod of 1x, it won't be in PlayerOptions list
	-- so check here, and add it in manually if necessary
	if SL[pn].ActiveModifiers.SpeedModType == "x" and SL[pn].ActiveModifiers.SpeedMod == 1 then
		optionslist = "1x, "
	end

	local TimingWindowScale = round(PREFSMAN:GetPreference("TimingWindowScale") * 100)

	--  ...and append options to that string as needed
	for i,option in ipairs(PlayerOptions) do

		-- these don't need to show up in the mods list
		if option ~= "FailAtEnd" and option ~= "FailImmediateContinue" and option ~= "FailImmediate" then
			-- 100% Mini will be in the PlayerOptions as just "Mini" so use the value from the SL table instead
			if option:match("Mini") then
				option = SL[pn].ActiveModifiers.Mini .. " Mini"
			end

			if option:match("Cover") then
				option = THEME:GetString("OptionNames", "Cover")
			end

			if i < #PlayerOptions then
				optionslist = optionslist..option..", "
			else
				optionslist = optionslist..option
			end
		end
	end

	-- Display TimingWindowScale as a modifier if it's set to anything other than 1.0
	if TimingWindowScale ~= 100 then
		optionslist = optionslist .. ", " .. tostring(TimingWindowScale) .. "% Timing Window"
  end
  
  return optionslist
end
