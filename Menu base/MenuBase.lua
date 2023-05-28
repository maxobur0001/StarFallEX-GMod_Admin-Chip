--@name Menu
--@author maxobur0001
--@shared

options = {"Switch players! (SWITCH)", "Switch function! (OFF)", "Default =)", "HUD function! (OFF)", "Info"} -- Functions
switches = {}

for i, v in pairs(options) do
    if string.sub(v, -8) == "(SWITCH)" then
        switches[v] = { }
    end
end

if SERVER then
    
    net.receive("set_switches", function()
        switches = net.readTable()
    end)
    function GetTargets(name)
        return switches[name]
    end
    
    --------- Players switches ----------------
    net.receive("Switch players! (SWITCH)", function()
        ply = net.readEntity() -- Enabled now
        if table.hasValue(GetTargets("Switch players! (SWITCH)"), ply) then
            print(Color(255, 255, 255), "Player " .. ply:getName() .. " enabled!")
        else
            print(Color(255, 255, 255), "Player " .. ply:getName() .. " off!")
        end
    end)
    
    -------- Switch function ------------------
    net.receive("Switch function! (ON)", function()
        print(Color(255, 255, 255), "Function enabled!")
    end)
    net.receive("Switch function! (OFF)", function()
        print(Color(255, 255, 255), "Function off!")
    end)
    
    ------- Default function ------------------
    net.receive("Default =)", function()
        ply = net.readEntity()
        print(Color(255, 255, 255), "Player name: " .. ply:getName())
    end)
end

if CLIENT then
    if player() == owner() then
        enableHud(owner(), true)
        ---------------------- Vars --------------------------
        ppage = 1
        menupage = 1
        
        -------------------- Options -------------------------
        authors = {"Author: Me!", "Coder: Yeah, that's me.", "Ideas: Me! Me!"} -- Info
        menu_color = Color(150, 150, 255, 50) -- Menu color (RGBA)
        menu_title = "This is a menu :^" -- Menu title
        menu_butt = 93 -- Menu button ( KEY enums )
        ------------------------------------------------------
        
        is_main = true
        is_authors = false
        option = 1
        onned = false
        
        ---------------- Draw menu function ------------------
        function drawmenu(title, options, page, is_players, is_switch, switches, numeration, color)
            sx, sy = render.getGameResolution()
            render.setColor(color)
            render.drawRoundedBox(15, 20, sy/2-125, 220, 205)
            render.setColor(Color(255, 255, 255))
            render.drawText(30, sy/2-115, title, 0)
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
        
        
        hook.add("drawhud", "", function()
            ----------------------- Menu --------------------------
            if onned then
                -------main-------
                if is_main then
                    drawmenu(menu_title, options, menupage, false, false, nil, true, menu_color)
                -------info-------
                elseif option == "Info" then
                    drawmenu("Info", authors, 1, false, false, nil, false, menu_color)
                ------players-----
                else
                    is_switch = string.sub(option, -8) == "(SWITCH)"
                    drawmenu(option, find.allPlayers(), ppage, true, is_switch, switches, true, menu_color)
                end
                
            end
            ----------------------- HUD function -----------------------
            if options[4] == "HUD function! (ON)" then
                sx, sy = render.getGameResolution()
                render.drawText(sx/2, sy/2-8, "HUD ON!", 1)
            end 
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
                        if string.sub(option, -8) != "(SWITCH)" then
                            net.start(option)
                            net.writeEntity(find.allPlayers()[(butt-1)+((ppage*7)-7)])
                            net.send()
                        else
                            if table.hasValue(switches[option], find.allPlayers()[(butt-1)+((ppage*7)-7)]) then
                                table.removeByValue(switches[option], find.allPlayers()[(butt-1)+((ppage*7)-7)])
                            else
                                table.insert(switches[option], find.allPlayers()[(butt-1)+((ppage*7)-7)])
                            end
                            net.start("set_switches")
                            net.writeTable(switches) 
                            net.send()
                            
                            net.start(option)
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
                            option = options[(butt-1)+((menupage*7)-7)]
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
                if butt == menu_butt then
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
end
