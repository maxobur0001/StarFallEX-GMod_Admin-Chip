# Admin-Chip
## You founded it!
This small chip in the StarFallEX language has 50 functions! These features will help you destroy evil players who interfere with other players in any way. This chip is a real find. Use wisely, dear Garry's Mod admins.
## Explanation of some functions
### 1. Anti-Aim
It turns the sight in the opposite direction when pointing at the player. Useful against cheaters.
### 2. Wallhack Chip
A special WH that can notice StarFall and Expression 2 chips.
### 3. Admin-weapons
This feature includes special weapons with some features. Crowbar deals 10,000 damage, Gravity gun can lift and throw players and NPCs, Crossbow shoots explosive charges.
### 4. BHOP
Pinch the space bar and jump with increasing speed!
### 5. Bury
Buries players underground.
### 6. Stumble
Makes the player stumble. He is dealt damage of 10 units and loses weapons.
### 7. Aim-entity info
Gives information on the player or entity. By entity: the position of the entity, its owner, the time since the creation of the entity, its health, model, class. By player: his nickname, his group, model, health, armor, kills and deaths.
### 8. Disorientate
Forces the player to throw out several weapons, changes his position and the angle of rotation of the eyes.
### 9. Trip
Oh... it's better to see it with your own eyes.
### 10. Poison
Just slowly takes away HP.
### 11. Vampirizm
Activated players begin not just to deal damage, but to take away HP.
### 12. Revenge
Kills your killer.
### 13. Nausea
Just blindness with a green blur.
### 14. WRITEZ Blind
Blindness that breaks the visibility of some props and players.
### 15. Invisibility
Invisibility with model size reduction to 1%.
# Menu base
## What is this?
This is the menu base from the admin chip.
## How do I add functions?
To add a custom function, you need to find the "options" variable, and then add the name of your function to the curly brackets separated by commas in quotation marks. Functions have attributes:
(SWITCH) is a cyclic function.
(OFF) - included function
They should be added to the end.

### Single function
For a single function code, add after if SERVER then:
```lua
net.receive("function name", function()
ply = net.readEntity()
--write the code here (instead of this inscription) (player variable - ply)
end)
```
### Cyclic function
For the cyclic function code, add:
```lua
net.receive("function name (SWITCH)", function() -- this net.receive will be activated immediately after the player is turned on.
    ply = net.readEntity() --entity of the selected player
end)
hook.add("same hook name", "same name", function()
    for i, v in pairs(GetTargets("function name (SWITCH)")) do --GetTargets() gets the players of your looping function.
        --write the code here (instead of this inscription) (player variable - v)
    end
end)
```
### Included function
For the code of the included function, add:
```lua
net.receive("function name (ON)", function()
--here write the code (instead of this inscription) (code when turned on)
end)
net.receive("function name (OFF)", function()
--here write the code (instead of this inscription) (code when turned off)
end)
```