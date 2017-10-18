local Players = GAMESTATE:GetHumanPlayers();

local t = Def.ActorFrame{
	LoadFont("_wendy white")..{
		Text="GAME",
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy-40):croptop(1):fadetop(1):zoom(1.2):shadowlength(1) end,
		OnCommand=function(self) self:decelerate(0.5):croptop(0):fadetop(0):glow(1,1,1,1):decelerate(1):glow(1,1,1,1) end,
		OffCommand=function(self) self:accelerate(0.5):fadeleft(1):cropleft(1) end
	},
	LoadFont("_wendy white")..{
		Text="OVER",
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy+40):croptop(1):fadetop(1):zoom(1.2):shadowlength(1) end,
		OnCommand=function(self) self:decelerate(0.5):croptop(0):fadetop(0):glow(1,1,1,1):decelerate(1):glow(1,1,1,1) end,
		OffCommand=function(self) self:accelerate(0.5):fadeleft(1):cropleft(1) end
	},

	--Player 1 Stats BG
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(160,_screen.h):xy(80, _screen.h/2):diffuse(color("#00000099"))
			if ThemePrefs.Get("RainbowMode") then self:diffuse(color("#000000dd")) end
		end,
	},

	--Player 2 Stats BG
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(160,_screen.h):xy(_screen.w-80, _screen.h/2):diffuse(color("#00000099"))
			if ThemePrefs.Get("RainbowMode") then self:diffuse(color("#000000dd")) end
		end,
	}
}

local function juustot(position, align, calories)
	local burgerholder = Def.ActorFrame{
		InitCommand=function(self) 
			self:xy(position, 110)
		end
	}
	local burgers = (calories / 600)
	
	local currentBurger = 0
	while currentBurger < burgers do
		local lul = currentBurger
		burgerholder[#burgerholder+1] = Def.Sprite{
			Texture=THEME:GetPathB("ScreenGameOver", "overlay/triplajuusto.png"),
			InitCommand=function(self)
				self:zoomto(50,50):x(lul*40*align):cropright(1 - (burgers - lul))
			end
		}

		currentBurger = currentBurger + 1
		
	end

	return burgerholder
end

for player in ivalues(Players) do
	local line_height = 60
	local middle_line_y = 220
	local x_pos = player == PLAYER_1 and 80 or _screen.w-80
	local PlayerStatsAF = Def.ActorFrame{ Name="PlayerStatsAF_"..ToEnumShortString(player) }
	local stats

	-- first, check if this player is using a profile (local or MemoryCard)
	if PROFILEMAN:IsPersistentProfile(player) then

		-- if a profile is in use, grab gameplay stats for this session that are pertinent
		-- to this specific player's profile (highscore name, calories burned, total songs played)
		stats = LoadActor("PlayerStatsWithProfile.lua", player)

		-- loop through those stats, adding them to the ActorFrame for this player as BitmapText actors
		for i,stat in ipairs(stats) do
			PlayerStatsAF[#PlayerStatsAF+1] = LoadFont("Common Normal")..{
				Text=stat,
				InitCommand=function(self)
					self:diffuse(PlayerColor(player))
						:xy(x_pos, (line_height*(i-1)) + 40)
						:maxwidth(150)
				end
			}
		end

	end

	-- draw a thin line (really just a Def.Quad) separating
	-- the upper (profile) stats from the lower (general) stats
	PlayerStatsAF[#PlayerStatsAF+1] = Def.Quad{
		InitCommand=function(self)
			self:zoomto(120,1):xy(x_pos, middle_line_y)
				:diffuse( PlayerColor(player) )
		end
	}

	-- retrieve general gameplay session stats for which a profile is not needed
	stats = LoadActor("PlayerStatsWithoutProfile.lua", player)

	-- loop through those stats, adding them to the ActorFrame for this player as BitmapText actors
	for i,stat in ipairs(stats) do
		PlayerStatsAF[#PlayerStatsAF+1] = LoadFont("Common Normal")..{
			Text=stat,
			InitCommand=function(self)
				self:diffuse(PlayerColor(player))
					:xy(x_pos, (line_height*i) + middle_line_y)
					:maxwidth(150)
			end
		}
	end

	t[#t+1] = PlayerStatsAF

	if PROFILEMAN:IsPersistentProfile(player) then
		local calories = PROFILEMAN:GetProfile(player):GetCaloriesBurnedToday()
		local burger_pos = player == PLAYER_1 and 35 or _screen.w-35
		local burger_alignment = player == PLAYER_1 and 1 or -1	
		t[#t+1] = juustot(burger_pos, burger_alignment, calories)
	end
end

return t
