local path = table.pack(...)[1]

SF = {}

-- Ебаная магия луа
LuaUserData.MakeMethodAccessible(Descriptors["Barotrauma.Explosion"], "GetObstacleDamageMultiplier")

-- Блок инициализации функций мода
dofile(path .. "/Lua/SharedFunc/AARFunc.lua")

-- Блок хуков луа для xml
dofile(path .. "/Lua/Hooks/SFFuleRod.lua")
dofile(path .. "/Lua/Hooks/SFOverheating.lua")
dofile(path .. "/Lua/Hooks/SFRandom.lua")

--
print("SF loaded")
