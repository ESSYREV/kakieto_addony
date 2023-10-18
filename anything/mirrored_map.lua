local rt
local mat
local enabled=true

local function renderScene(origin,angles,fov)
    render.SetRenderTarget( rt )
end


local function drawHud()
    if IsValid(LocalPlayer()) then
        surface.SetDrawColor( color_white )
        surface.SetMaterial( mat )
        surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
    end
end


local function inputMouse(cmd,x,y,ang)
    local sens = GetConVar("sensitivity"):GetFloat() / 100
 
    ang.y = ang.y+(x*sens)
    ang.p = ang.p+(y*sens)

    cmd:SetViewAngles( ang )
     
    return true
end


local function createMove(cmd)
    cmd:SetSideMove(-cmd:GetSideMove())
    return true
end

concommand.Add( "cl_mirroredmap", function( ply, cmd, args )
    local isEnable = tonumber(args[1]) or 0
    if isEnable == 1 then

        rt = GetRenderTarget( "esrv.rendertarget", ScrW(), ScrH() )
        mat = CreateMaterial( "esrv.rendertargetMaterial", "UnlitGeneric", {
            ["$basetexture"] = rt:GetName(),
            ['$basetexturetransform'] = "center .5 .5 scale -1 1 rotate 0 translate 0 0"
        })

        hook.Add("RenderScene"              ,"esrv.MirroredMap",renderScene )
        hook.Add("HUDPaint"                 ,"esrv.MirroredMap",drawHud         )
        hook.Add("InputMouseApply"          ,"esrv.MirroredMap",inputMouse  )
        hook.Add("CreateMove"               ,"esrv.MirroredMap",createMove  )

        enabled = true

    else

        hook.Remove("RenderScene"           ,"esrv.MirroredMap")
        hook.Remove("HUDPaint"              ,"esrv.MirroredMap")
        hook.Remove("InputMouseApply"       ,"esrv.MirroredMap")
        hook.Remove("CreateMove"            ,"esrv.MirroredMap")

        enabled = false

    end
end)
