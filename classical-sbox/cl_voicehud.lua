-- Оригинальный аддон https://steamcommunity.com/sharedfiles/filedetails/?id=1693606237
-- Требуется https://github.com/Threebow/tdlib


surface.CreateFont( "GTowerHudCSubText", { font = "default", size = 22, weight = 700, } )
surface.CreateFont( "GTowerHudCSubText-", { font = "default", size = 14, weight = 700, } )

local PlayerVoicePanels = {}
local PANEL = {}
PANEL.Margin = 2
PANEL.Padding = 16
PANEL.WaveyColor = Color(255, 255, 255, 255)
PANEL.Font = "GTowerHudCSubText"
local utf8pattern = "[%z\1-\127\194-\244][\128-\191]*"

local color_gray = Color(45, 45, 45)

function PANEL:Init()
    --self.Avatar = vgui.Create("AvatarImage", self)
    --self.Avatar:SetSize(32, 32)
    --self.Avatar:SetPos(self.Padding / 2, self.Padding / 2)


        self.Avatar = TDLib("DPanel", self)
        self.Avatar:SetSize(32,32)
        self.Avatar:SetPos(self.Padding / 2, self.Padding / 2)
        self.Avatar:CircleAvatar():SetPlayer(LocalPlayer(), 64)



    self.Color = color_transparent
    self:SetSize(300, 32 + self.Padding)
    self:DockMargin(0, 5, 0, 5)
    self:Dock(BOTTOM)
end

function PANEL:Setup(ply)
    self.ply = ply
    self.Avatar:SetPlayer(ply)
    self.Color = Color(255, 0, 0)
    self:InvalidateLayout()
end

function PANEL:Paint(w, h)
    if (not IsValid(self.ply)) then return end
    local nick = self.ply:Name()
    surface.SetFont(self.Font)
    local tw = surface.GetTextSize(nick)
    local halfheight = h / 2
    w = 32 + 8 * 2 + tw
    local color = self.ply:GetPlayerColor() * 255
    draw.RoundedBox(25, 0, 0, 250, h, color_gray)
    local x = 32 + 10
    draw.DrawText( nick, self.Font, 140 , 8, color_white, TEXT_ALIGN_CENTER )
    draw.DrawText( team.GetName(self.ply:Team()), "GTowerHudCSubText-",140, 30, color_white, TEXT_ALIGN_CENTER )


    local x, y = self.Avatar:GetX(), self.Avatar:GetY()
    x = x + 16
    y = y + 16 
    local color_team = team.GetColor( self.ply:Team() )
    surface.DrawCircle( x , y, 16, color_team )
    surface.DrawCircle( x , y, 17, color_team )
    surface.DrawCircle( x , y, 18, color_team )


end

function PANEL:Think()
    if (self.fadeAnim) then
        self.fadeAnim:Run()
    end
end

function PANEL:FadeOut(anim, delta, data)
    if (anim.Finished) then
        if (IsValid(PlayerVoicePanels[self.ply])) then
            PlayerVoicePanels[self.ply]:Remove()
            PlayerVoicePanels[self.ply] = nil

            return
        end

        return
    end

    self:SetAlpha(255 - (255 * delta))
end

derma.DefineControl("GMTVoiceNotify", "", PANEL, "DPanel")

hook.Add("PlayerStartVoice", "GMT_StartVoice", function(ply)
    if (not IsValid(VoicePanelList)) then return end
    -- There'd be an exta one if voice_loopback is on, so remove it.
    gamemode.Call("PlayerEndVoice", ply)

    if (IsValid(PlayerVoicePanels[ply])) then
        if (PlayerVoicePanels[ply].fadeAnim) then
            PlayerVoicePanels[ply].fadeAnim:Stop()
            PlayerVoicePanels[ply].fadeAnim = nil
        end

        PlayerVoicePanels[ply]:SetAlpha(255)

        return
    end

    if (not IsValid(ply)) then return end
    local pnl = VoicePanelList:Add("GMTVoiceNotify")
    pnl:Setup(ply)
    PlayerVoicePanels[ply] = pnl
end)

local function VoiceClean()
    for k, v in pairs(PlayerVoicePanels) do
        if (not IsValid(k)) then
            gamemode.Call("PlayerEndVoice", k)
        end
    end
end

timer.Create("VoiceClean", 10, 0, VoiceClean)

hook.Add("PlayerEndVoice", "GMT_EndVoice", function(ply)
    if (IsValid(PlayerVoicePanels[ply])) then
        if (PlayerVoicePanels[ply].fadeAnim) then return end
        PlayerVoicePanels[ply].fadeAnim = Derma_Anim("FadeOut", PlayerVoicePanels[ply], PlayerVoicePanels[ply].FadeOut)
        PlayerVoicePanels[ply].fadeAnim:Start(2)
    end
end)

local function CreateVoiceVGUI()
    if IsValid(g_VoicePanelList) then
        g_VoicePanelList:Remove()
    end

    VoicePanelList = vgui.Create("DPanel")
    VoicePanelList:ParentToHUD()
    VoicePanelList:SetPos(ScrW() - 350, 100)
    VoicePanelList:SetSize(300, ScrH() - 200)
    VoicePanelList:SetPaintBackground(false)
end

hook.Add("InitPostEntity", "CreateVoiceVGUI", CreateVoiceVGUI)
