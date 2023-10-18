-- Требуется https://github.com/Threebow/tdlib

surface.CreateFont( "classical-sandbox-hud-", {
	font = "Trebuchet24", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 22,
	weight = 1,
	antialias = true,
	underline = false,
	italic = false,
	--outline  = true,
} )

surface.CreateFont( "classical-sandbox-hud", {
	font = "Trebuchet24", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 26,
	weight = 1,
	antialias = true,
	underline = false,
	italic = false,
	--outline  = true,
} )

surface.CreateFont( "classical-sandbox-hud+", {
	font = "Trebuchet24", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 36,
	weight = 1,
	antialias = true,
	underline = false,
	italic = false,
	--outline  = true,
} )




local color_gray = Color(75, 75, 75)
local color_red = Color(255,56,56)
local color_blue = Color(0,125,255)
local color_black = Color(46,46,46)

local H = ScrH()
local W = ScrW()
local me


local function HUDGenerate()

	if IsValid(gHUD) then gHUD:Remove() end

	local HTML_CODE = [[<html>
		<div style="width: 300px; height: 100px; background-color: rgba(46,46,46, 1); border: 0px solid #000000; border-radius: 35px 35px 35px 35px;"></div>
	</html>]]


	local frame = vgui.Create( "DFrame" )
	gHUD = frame
	frame:SetPos(15,H-160)
	frame:SetSize(400,250)
	frame.Paint = nil
	frame:ShowCloseButton(false)
	frame:SetTitle( "" )
	--timer.Simple(10,function() frame:Remove() end)


	local dhtml = vgui.Create( 'DHTML', frame )
	dhtml:Dock( FILL )
	dhtml:SetHTML( HTML_CODE )



	local frameNickName = vgui.Create( "DFrame",frame )
	frameNickName:SetTitle( "" )
	frameNickName:SetSize( 185,35 )
	frameNickName:SetPos( 105,38 )	
	frameNickName:ShowCloseButton(false)

	frameNickName.Paint = function( self, w, h )
		draw.DrawText( LocalPlayer():GetName(), "classical-sandbox-hud", w/2,5, color_white, TEXT_ALIGN_CENTER )
	end

	local frameHealth = vgui.Create( "DFrame",frame)
	frameHealth:SetTitle( "" )
	frameHealth:SetSize( 185,35 )
	frameHealth:SetPos( 105,72 )	
	frameHealth:ShowCloseButton(false)


	frameHealth.Paint = function( self, w, h )
		local health = math.min(LocalPlayer():Health() or 0,100)
		draw.DrawText( health, "classical-sandbox-hud+",w/7,0, color_red, TEXT_ALIGN_LEFT )

		local armor = math.min(LocalPlayer():Armor() or 0,100)
		draw.DrawText( armor, "classical-sandbox-hud+",w-w/7,0, color_blue, TEXT_ALIGN_RIGHT )

	end


	local frameRoleName = vgui.Create( "DFrame",frame )
	frameRoleName:SetTitle( "" )
	frameRoleName:SetSize( 185,27 )
	frameRoleName:SetPos( 105,106 )	
	frameRoleName:ShowCloseButton(false)

	frameRoleName.Paint = function( self, w, h )

		local color_team = team.GetColor( LocalPlayer():Team() )
		draw.DrawText( team.GetName(LocalPlayer():Team()), "classical-sandbox-hud-",w/2,0, color_team, TEXT_ALIGN_CENTER )

	end


	local frameCircle = vgui.Create( "DFrame",frame )

	frameCircle:SetTitle( "" )
	frameCircle:SetSize( 68,68 )
	frameCircle:SetPos( 28,53 )	
	frameCircle:ShowCloseButton(false)

	frameCircle.Paint = function( self, w, h )

		local color_team = team.GetColor( LocalPlayer():Team() )
		surface.DrawCircle( w/2, h/2, 32, color_team )
		surface.DrawCircle( w/2, h/2, 33, color_team )
		surface.DrawCircle( w/2, h/2, 34, color_team )


	end


	    local avatar = TDLib("DPanel", frame)
	    avatar:SetSize(62,62)

	    avatar:SetPos(31,56)
	    avatar:CircleAvatar():SetPlayer(LocalPlayer(), 64)



	local ammoFrame = vgui.Create( "DFrame" )
	gHUDAmmo = ammoFrame
	--ammoFrame:SetParent(frame)
	ammoFrame:SetPos(325,H-98)
	ammoFrame:SetSize(256,128)
	ammoFrame.Paint = nil
	ammoFrame:ShowCloseButton(false)
	ammoFrame:SetTitle( "" )
	--timer.Simple(10,function() ammoFrame:Remove() end)


	local HTML_CODE_ammo = [[

	<html>

		<style>

		@import url('https://fonts.googleapis.com/css2?family=Roboto&display=swap');
		body {
			font-family: 'Roboto', sans-serif;
			font-size: 32px;
			text-align: left;
			clear: both;
		}

		costyl {
		
		}

		ammo {
			width: 78px; 
			height: 35px; 
			background-color: rgba(46,46,46, 1);
			border: 0px solid #000000;
			border-radius: 35px 35px 35px 35px;
			color: rgb(255,255,255);
		  padding-right: 25px;
		  padding-left: 25px;
		}

		</style>

		<ammo id="ammo"></ammo>
	</html>

	]]


	local ammoDhtml = vgui.Create( 'DHTML', ammoFrame )
	ammoDhtml:Dock( FILL )
	ammoDhtml:SetHTML( HTML_CODE_ammo )

	local frameAmmo = vgui.Create( "DFrame",ammoFrame )
	frameAmmo:SetTitle( "" )
	frameAmmo:SetSize( 256,128 )
	frameAmmo:SetPos( 0,0 )	
	frameAmmo:ShowCloseButton(false)

	frameAmmo.Paint = function( self, w, h )

	    local wep  = me:GetActiveWeapon()
	    if IsValid(wep) then
	        local WEPname = wep:GetPrintName()
	        local CLIP    = wep:Clip1()
	        local AMMO    = me:GetAmmoCount(wep:GetPrimaryAmmoType())
	        local AMMOalt = me:GetAmmoCount(wep:GetSecondaryAmmoType())

	        if AMMO > 0 or CLIP > 0 then

	        		local ammo = CLIP.."/"..AMMO
	        		if CLIP == -1 then
	        				ammo = AMMO
	        		end

	            surface.SetFont( "classical-sandbox-hud+" )
							local width, height = surface.GetTextSize( ammo )
	    				local call =  "document.getElementById('ammo').textContent = '"..ammo.."';"
	    				call = call .. "document.getElementById('ammo').style.display = 'inline';"
				    	ammoDhtml:Call( call )
	        else
	    				local call =  "document.getElementById('ammo').style.display = 'none';"
				    	ammoDhtml:Call( call )
	        end
	    end

	end


end


hook.Add( "InitPostEntity", "classical-sandbox-hud", function()

	me = LocalPlayer()
	H = ScrH()
	W = ScrW()

	timer.Simple(1,function() HUDGenerate() end)

end)

--me = LocalPlayer()
--HUDGenerate()

hook.Remove("HUDPaint","player")

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	['CHudSecondaryAmmo'] = true,
	['CHudAmmo'] = true,
}

hook.Add( "HUDShouldDraw", "classical-sandbox-hud", function( name )
	if ( hide[ name ] ) then
		return false
	end
end )

hook.Add( "PlayerSwitchWeapon", "classical-sandbox-hud", function( ply, oldWeapon, newWeapon )
	

	local nwep = newWeapon:GetClass() or "nil"
	local owep = oldWeapon:GetClass() or "nil"
	if nwep == "gmod_camera" then
		gHUD:SetPos(15,H*2)
		gHUDAmmo:SetPos(325,H*2)
	elseif owep == "gmod_camera" then
		gHUD:SetPos(15,H-160)
		gHUDAmmo:SetPos(325,H-98)
	end


end)
