if SL.Global.GameMode ~= "Casual" then
	local player = ...
	local optionslist = PlayerModifiersString(player)
	local font_zoom = 0.7

	return Def.ActorFrame{
		OnCommand=function(self) self:y(_screen.cy+200.5) end,

		Def.Quad{
			InitCommand=function(self) self:diffuse(color("#1E282F")):zoomto(300, 26) end
		},

		LoadFont("Common Normal")..{
			Text=optionslist,
			InitCommand=function(self) self:zoom(font_zoom):xy(-140,-5):align(0,0):vertspacing(-6):_wrapwidthpixels(290 / font_zoom) end
		}
	}
end
