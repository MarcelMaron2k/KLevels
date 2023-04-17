local Config = KLevels.Config
local Client = KLevels.Client

surface.CreateFont( "KBender1", {
	font = "Bender",
	size = 75,
	weight = 500,
} )

surface.CreateFont( "KBender2", {
	font = "Bender",
	size = 25,
	weight = 500,
} )

surface.CreateFont( "KBender3", {
	font = "Bender",
	size = 20,
	weight = 500,
} )

surface.CreateFont( "KBender4", {
	font = "Bender",
	size = 15,
	weight = 500,
} )

local newcommands = {}

for k,v in ipairs(Config.Commands) do
    newcommands[v] = true
end
hook.Add("OnPlayerChat", "KLevels_OpenMenu", function(ply, text, teamChat, isDead)
    if (ply != LocalPlayer()) then return nil end
    if not (newcommands[string.lower(text)]) then return nil end

    KLevels.OpenMenu()
end)

local skillPanelWide = 96

local border_color = Color(54,54,54)
local xp_color = Color(150,150,150)
local rem_color = Color(12,12,12, 200)

function KLevels.OpenMenu()

    local ply = LocalPlayer()
    local scrw, scrh = ScrW(), ScrH()

    local sideFillerRatio = 300/1920
    local topFillerRatio = 185/1080

    local levelPanelRatio = 115/1080
    local skillsPanelRatio = 700/1080

    Client.Frame = vgui.Create("DFrame")
    Client.Frame:SetSize(scrw,scrh)
    Client.Frame:Center()
    Client.Frame:SetBackgroundBlur(true)
    Client.Frame:MakePopup(true)
    Client.Frame:SetDraggable(false)
    Client.Frame:ShowCloseButton(false)
    Client.Frame:SetDeleteOnClose(true)
    Client.Frame.Paint = function(s,w,h)   
        surface.SetDrawColor(16,16,16, 250)
        surface.DrawRect(0,0,w,h)

        Client.DrawBlur( s, 2, 5, 200 )
    end
    
    local closeButton = vgui.Create("DButton", Client.Frame)
    closeButton:SetSize(30,15)
    closeButton:SetPos(scrw - 35, 5)
    closeButton:SetText("")
    closeButton.Paint = function(s,w,h)
        if (s:IsHovered()) then
            surface.SetDrawColor(250, 0, 0)
        else
            surface.SetDrawColor(250, 0, 0,150)
        end
        surface.DrawRect(0, 0, w, h)
    end
    function closeButton:DoClick()
        self:GetParent():Close()
    end
    local fillerpanelleft = vgui.Create("DPanel", Client.Frame)
    fillerpanelleft:Dock(LEFT)
    fillerpanelleft:SetWide(scrw*sideFillerRatio)
    fillerpanelleft.Paint = function(s,w,h)   end

    local fillerpanelright = vgui.Create("DPanel", Client.Frame)
    fillerpanelright:Dock(RIGHT)
    fillerpanelright:SetWide(scrw*sideFillerRatio)
    fillerpanelright.Paint = function(s,w,h)   end

    local fillerpaneltop = vgui.Create("DPanel", Client.Frame)
    fillerpaneltop:Dock(TOP)
    fillerpaneltop:SetTall(scrh*topFillerRatio)
    fillerpaneltop.Paint = function(s,w,h)   end

    local plylvl, nextlvlXP, prevlvlXP = ply:GetLevel()

    local curXP = ply:GetNWInt("KLevels_TotalXP", 0) - prevlvlXP
    local remainingXP = nextlvlXP - prevlvlXP

    local xpRatio = curXP / remainingXP

    local curlevelMat = Config.GetMaterial(plylvl)
    local nextlevelMat = Config.GetMaterial(plylvl + 1)

    local levelpanel = vgui.Create("DPanel", Client.Frame)
    levelpanel:Dock(TOP)
    levelpanel:SetTall(scrh * levelPanelRatio)

    surface.SetFont( "KBender1" )
    local levelpanelH = levelpanel:GetTall()
    local textW1,textH1 = surface.GetTextSize(plylvl)
    local textW2,textH2 = surface.GetTextSize(plylvl + 1)

    surface.SetFont( "KBender2" )
    local curText = "current: "
    local curTextW, curTextH = surface.GetTextSize(curText)

    local remainingText = "remaining: "
    local remainingTextW, remainingTextH = surface.GetTextSize(remainingText)
    local remainingXPW = surface.GetTextSize(tostring(remainingXP))

    local panelWidth = levelpanel:GetWide()
    local xpBarX = levelpanel:GetTall() + textW1 + 10
    local xpBarY = levelpanel:GetTall() / 2 - 10

    local xpBarSize = nil

    local xpLeftPos = nil
    local xpLeftSize = nil
    levelpanel.Paint = function(s,w,h)

        surface.SetMaterial(curlevelMat) // Current Level Emblem
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawTexturedRect(0, 0, s:GetTall(),s:GetTall())

        surface.SetMaterial(nextlevelMat) // Next Level Emblem
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawTexturedRect(s:GetWide() - s:GetTall() - textW2, 0, s:GetTall() , s:GetTall())

        surface.SetFont( "KBender1" ) // Current Level Text
        surface.SetTextColor( 255, 255, 255 )
        surface.SetTextPos( s:GetTall(), s:GetTall() / 2 - textH1 /2 ) 
        surface.DrawText(plylvl)

        surface.SetFont( "KBender1" ) // Next Level Text
        surface.SetTextColor( 255, 255, 255 )
        surface.SetTextPos(s:GetWide() - textW2, s:GetTall() / 2 - textH2 /2 ) 
        surface.DrawText(plylvl + 1)

        xpBarSize = (levelpanel:GetWide() - (levelpanel:GetTall() + textW1) * 2 - 20) * xpRatio
        xpLeftSize = (levelpanel:GetWide() - (levelpanel:GetTall() + textW1) * 2 - 20) * (1 - xpRatio)

        xpLeftPosX = xpBarX + xpBarSize
        xpLeftPosY = s:GetTall() / 2 - 10 

        Client.DrawBars(xpBarX, xpBarY, xpBarSize, 20, xpLeftPosX, xpLeftPosY, xpLeftSize, 20)

        surface.SetFont( "KBender1" ) // Next Level Text
        surface.SetTextColor( 255, 255, 255 )
        surface.SetTextPos(s:GetWide() - textW2, s:GetTall() / 2 - textH2 /2 ) 
        surface.DrawText(plylvl + 1)

        surface.SetFont("KBender2") // Current XP Text
        surface.SetTextColor( 128,128,128 )
        surface.SetTextPos(xpBarX, xpBarY + 20) 
        surface.DrawText(curText)

        surface.SetTextColor(220,220,220) // Current XP Text
        surface.SetTextPos(xpBarX + curTextW, xpBarY + 20)
        surface.DrawText(curXP)

        surface.SetTextColor( 220,220,220 ) // Remaining XP Text
        surface.SetTextPos(xpLeftSize + xpLeftPosX - remainingXPW, xpBarY + 20) 
        surface.DrawText(remainingXP)

        surface.SetTextColor(128,128,128) // Remaining XP Text
        surface.SetTextPos(xpLeftSize + xpLeftPosX - remainingXPW - remainingTextW, xpBarY + 20)
        surface.DrawText(remainingText)
    end

    local fillerpanelmid = vgui.Create("DPanel", Client.Frame)
    fillerpanelmid:Dock(TOP)
    fillerpanelmid:SetTall(30)
    fillerpanelmid.Paint = function() end

    local skillsholder = vgui.Create("DScrollPanel", Client.Frame)
    skillsholder:Dock(TOP)
    skillsholder:SetTall(scrh * skillsPanelRatio)
    
    Client.DrawSkills(skillsholder)
end

function Client.DrawBars(xpos1, ypos1, width1, height1, xpos2, ypos2, width2, height2)

    surface.SetDrawColor(xp_color) // XP amount
    surface.DrawRect(xpos1, ypos1, width1, height1)

    -- Draw Border1
    surface.SetDrawColor(border_color) -- Left Border
    surface.DrawRect(xpos1-1, ypos1-1, 1, height1+2)

    surface.SetDrawColor(border_color) -- Top Border
    surface.DrawRect(xpos1, ypos1-1, width1, 1)

    surface.SetDrawColor(border_color) -- Bottom Border
    surface.DrawRect(xpos1,ypos1 +height1, width1, 1)

    ----------------
    surface.SetDrawColor(rem_color) // XP amount left
    surface.DrawRect(xpos2, ypos2 , width2, height2)
    
    -- Draw Border 2
    surface.SetDrawColor(border_color) -- Right Border
    surface.DrawRect(xpos2 + width2 - 1, ypos2 - 1, 1, height2 + 2)

    surface.SetDrawColor(border_color) -- Top Border
    surface.DrawRect(xpos2, ypos2-1, width2, 1)

    surface.SetDrawColor(border_color) -- Bottom Border
    surface.DrawRect(xpos2,ypos2 + height2, width2, 1)
    --------------
end

function Client.DrawBorders(xpos, ypos, width, height, border, level)

    surface.SetDrawColor(border_color)

    surface.DrawRect(xpos, ypos, border, height) -- Left Border
    surface.DrawRect(xpos, ypos, width, border) -- Top Border
    surface.DrawRect(xpos + width - border, ypos, border, height) -- Right Border
    surface.DrawRect(xpos, ypos + height - border, width , border) -- Bottom Border
end

function Client.DrawSkills(panel)
    local tbl = KAbility.List

    for k,v in pairs(tbl) do
        if (k % 2 == 0) then continue end
        local newpanel = vgui.Create("DPanel", panel)
        newpanel:Dock(TOP)
        newpanel:DockMargin(0,25,0,0)
        newpanel:SetTall(skillPanelWide)
        newpanel.Paint = function() end
        local newWidth = nil
        local newHeight = nil
        function newpanel:OnSizeChanged(wide,high) -- workaround cause Docking in GMod is shit

            if (v) then
                local skill1 = vgui.Create("DPanel", newpanel)
                skill1:Dock(LEFT)
                skill1:SetWide(wide/2)
                local mat = v:GetIcon()
                local name = v:GetName()

                local plylvl, xpLeft, nextlvlXP = ply:GetAbilityLevel(v)

                local xpRatio = xpLeft / nextlvlXP

                local level = "Level: "..plylvl
                local remText = "/"..nextlvlXP/10

                surface.SetFont("KBender3")
                local nameW, nameH = surface.GetTextSize(name)
                local curXPW, curXPH = surface.GetTextSize(xpLeft/10)
                local remXPW, remXPH = surface.GetTextSize(remText)

                local abilityBarSize = (wide/2 - skillPanelWide - 30) * xpRatio
                local abilityleftBarSize = (wide/2 - skillPanelWide - 30) * (1 - xpRatio)

                skill1.Paint = function(s,w,h)

                    surface.SetFont("KBender3")
                    surface.SetTextColor( 128,128,128 )
                    surface.SetTextPos(skillPanelWide + 10, 0) 
                    surface.DrawText(name)

                    surface.SetMaterial(mat)
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.DrawTexturedRect(0, 0, skillPanelWide, skillPanelWide) 

                    Client.DrawBars(skillPanelWide + 10, nameH+10, abilityBarSize, 20, skillPanelWide + 10 + abilityBarSize, nameH + 10, abilityleftBarSize, 20)
                    
                    Client.DrawBorders(0, 0, skillPanelWide, skillPanelWide, 2, plylvl)

                    surface.SetFont("KBender3")
                    surface.SetTextColor( 128,128,128 )
                    surface.SetTextPos(skillPanelWide + 10, nameH + 35) 
                    surface.DrawText(level)
                    
                    surface.SetFont("KBender3")
                    surface.SetTextColor( 128,128,128 )
                    surface.SetTextPos(skillPanelWide + abilityBarSize + abilityleftBarSize - 20, nameH + 35) 
                    surface.DrawText(remText)

                    surface.SetFont("KBender3")
                    surface.SetTextColor( 220,220,220 )
                    surface.SetTextPos(skillPanelWide + abilityBarSize + abilityleftBarSize - curXPW - remXPW + 7, nameH + 35) 
                    surface.DrawText(xpLeft/10)
                end
            end
    
            local v2 = tbl[k+1]
            if (v2) then
                local skill2 = vgui.Create("DPanel", newpanel)
                skill2:Dock(RIGHT)
                skill2:SetWide(wide/2)

                local mat = v2:GetIcon()
                local name = v2:GetName()

                local plylvl, xpLeft, nextlvlXP = ply:GetAbilityLevel(v2)

                local xpRatio = xpLeft / nextlvlXP
                --print(xpRatio, xpLeft, nextlvlXP,v2:GetSQL())
                local level = "Level: "..plylvl
                local remText = "/"..nextlvlXP/10

                surface.SetFont("KBender3")
                local nameW, nameH = surface.GetTextSize(name)
                local curXPW, curXPH = surface.GetTextSize(xpLeft/10)
                local remXPW, remXPH = surface.GetTextSize(remText)

                local abilityBarSize = (wide/2 - skillPanelWide - 30) * xpRatio
                local abilityleftBarSize = (wide/2 - skillPanelWide - 30) * (1 - xpRatio)
                
                skill2.Paint = function(s,w,h)

                    surface.SetFont("KBender3")
                    surface.SetTextColor( 128,128,128 )
                    surface.SetTextPos(skillPanelWide + 10, 0) 
                    surface.DrawText(name)

                    surface.SetMaterial(mat)
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.DrawTexturedRect(0, 0, skillPanelWide, skillPanelWide) 

                    Client.DrawBars(skillPanelWide + 10, nameH+10, abilityBarSize, 20, skillPanelWide + 10 + abilityBarSize, nameH + 10, abilityleftBarSize, 20)
                    
                    Client.DrawBorders(0, 0, skillPanelWide, skillPanelWide, 2, plylvl)

                    surface.SetFont("KBender3")
                    surface.SetTextColor( 128,128,128 )
                    surface.SetTextPos(skillPanelWide + 10, nameH + 35) 
                    surface.DrawText(level)

                    surface.SetFont("KBender3")
                    surface.SetTextColor( 128,128,128 )
                    surface.SetTextPos(skillPanelWide + abilityBarSize + abilityleftBarSize - 20, nameH + 35) 
                    surface.DrawText(remText)

                    surface.SetFont("KBender3")
                    surface.SetTextColor( 220,220,220 )
                    surface.SetTextPos(skillPanelWide + abilityBarSize + abilityleftBarSize - curXPW - remXPW + 7, nameH + 35) 
                    surface.DrawText(xpLeft/10)

                end
            end

        end
    end
end

local blur = Material( "pp/blurscreen" )
function Client.DrawBlur( panel, layers, density, alpha ) -- ripped off PubgInv to make the blur identical
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end