if SL.Global.GameMode == "StomperZ" then return end

local player = ...

local playerStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
local grade = playerStats:GetGrade()
local radarvalues = playerStats:GetRadarPossible():GetValue( "RadarCategory_TapsAndHolds")

-- "I passd with a q though."
local title = GAMESTATE:GetCurrentSong():GetDisplayFullTitle()
if title == "D" then grade = "Grade_Tier99" end

local t = Def.ActorFrame{}

t[#t+1] = LoadActor(THEME:GetPathG("", "_grades/"..grade..".lua"), playerStats)..{
	InitCommand=function(self)
		self:x(70 * (player==PLAYER_1 and -1 or 1))
		self:y(_screen.cy-134)
	end,
	OnCommand=function(self) self:zoom(0.4) end
}

local finaldp = GetGrindistaScore(playerStats, radarvalues)
t[#t+1] = Def.BitmapText{
    Font="_miso",
	Text="Grindistä :D:D -Score",
	InitCommand=function(self)
		self:x(-175)
		self:y(_screen.cy-140)
		self:zoom(0.9)
		if player == PLAYER_2 then
			self:x( self:GetX() * -1 )
		end
    end
  }
  t[#t+1] = Def.BitmapText{
    Font="_miso",
	Text="Grind more",
	InitCommand=function(self)
		local finalscore = FormatPercentScore(finaldp)
			self:settext(finalscore)
			self:zoom(1.5)
		self:x(-195)
		self:y(_screen.cy-107)
		if player == PLAYER_2 then
			self:x( self:GetX() * -1 )
		end
    end
  }

local image = "empty"
if finaldp>=0.999 then image="legendary" 
elseif finaldp>=0.9975 then image="epic" 
elseif finaldp>=0.995 then image="rare" 
elseif finaldp>=0.99 then image="diamond"
elseif finaldp>=0.98 then image="platinum" 
elseif finaldp>=0.96 then image="gold" 
elseif finaldp>=0.92 then image="silver" 
elseif finaldp>=0.80 then image="bronze" end

  t[#t+1] = LoadActor("icons/"..image..".png")..{
	InitCommand=function(self)
		self:x(-133)
		self:y(_screen.cy-105)
		self:zoom(0.25)
		if player == PLAYER_2 then
			self:x( self:GetX() * -1)
	end
end
  }

return t