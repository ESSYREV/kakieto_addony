local warn_limits = 4
------------------------------ warn ------------------------------
function ulx.warn(calling_ply, target_ply, reason)

    local warns = util.JSONToTable( target_ply:GetPData( "ulx-warns", "[]" ) ) 
    warns[#warns + 1] = reason .. " | Выдано: ".. calling_ply:Nick()
    target_ply:SetPData( "ulx-warns", util.TableToJSON(warns) )

    if #warns >= warn_limits then
        RunConsoleCommand("ulx","removeuserid", target_ply:SteamID())
    end

end
local warn = ulx.command( CATEGORY_NAME, "ulx warn", ulx.warn, "!warn")
warn:addParam{ type=ULib.cmds.PlayerArg }
warn:addParam{ type=ULib.cmds.StringArg, hint="Причина" }
warn:defaultAccess( ULib.ACCESS_ADMIN )
warn:help( "Выдать игроку предупреждение" )
function ulx.getwarns(calling_ply, target_ply)

    local warns = util.JSONToTable( target_ply:GetPData( "ulx-warns", "[]" ) )

    if #warns == 0 then
        calling_ply:PrintMessage(3,"У игрока ".. target_ply:GetName().." нет варнов! :)")
        return
    end


    local str = ""
    for key, val in pairs(warns) do
        str = str .. "["..key..'] '.. val .. "\n"
    end

    calling_ply:PrintMessage(3,str)

end
local getwarns = ulx.command( CATEGORY_NAME, "ulx getwarns", ulx.getwarns, "!getwarns")
getwarns:addParam{ type=ULib.cmds.PlayerArg }
getwarns:defaultAccess( ULib.ACCESS_ALL )
getwarns:help( "Получить список предупреждений игрока" )



function ulx.resetwarns(calling_ply, target_ply)

    target_ply:SetPData( "ulx-warns", "[]" )

end
local resetwarns = ulx.command( CATEGORY_NAME, "ulx resetwarns", ulx.resetwarns, "!resetwarns")
resetwarns:addParam{ type=ULib.cmds.PlayerArg }
resetwarns:defaultAccess( ULib.ACCESS_ADMIN )
resetwarns:help( "Отпустить все проступки" )







function ulx.removewarn(calling_ply, target_ply, warn_number)

    local tonum = tonumber(warn_number)

    if not isnumber(tonum) then 
        calling_ply:PrintMessage(3,'Укажите правильный ID варна для удаления.')
        return 
    end
 
    local warns = util.JSONToTable( target_ply:GetPData( "ulx-warns", "[]" ) )

    if warns[tonum] then 

        calling_ply:PrintMessage(3,'Вы удалили варн "'.. warns[tonum] ..'" у игрока '.. target_ply:GetName() )

        warns[tonum] = nil
        target_ply:SetPData( "ulx-warns", util.TableToJSON(warns) )

    else

        calling_ply:PrintMessage(3,'Данного варн ID у игрока '..calling_ply:GetName().." не существует." )
        return 
    end


end
local removewarn = ulx.command( CATEGORY_NAME, "ulx removewarn", ulx.removewarn, "!removewarn")
removewarn:addParam{ type=ULib.cmds.PlayerArg }
removewarn:addParam{ type=ULib.cmds.StringArg, hint="ID Варна" }
removewarn:defaultAccess( ULib.ACCESS_ADMIN )
removewarn:help( "Удалить предупреждение у игрока" )
