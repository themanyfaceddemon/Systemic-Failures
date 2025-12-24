local overheating_prefab = AfflictionPrefab.Prefabs["overheating"]

local function GetCharactersInRadiusSq(pos, maxDistSq)
    local res = {}

    for c in Character.CharacterList do
        local dx = c.WorldPosition.X - pos.X
        local dy = c.WorldPosition.Y - pos.Y
        local distSq = dx * dx + dy * dy
        if distSq <= maxDistSq then
            res[#res + 1] = { c, distSq }
        end
    end

    return res
end

local function ApplyAfflictionRadius(position, maxDistance, wallPenetration, armorPenetration, afflictions)
    local maxDistSq = maxDistance * maxDistance
    local chars = GetCharactersInRadiusSq(position, maxDistSq)
    if #chars == 0 then return end

    local simPos = ConvertUnits.ToSimUnits(position)

    for _, entry in ipairs(chars) do
        local character = entry[1]
        local distSq = entry[2]

        local obstacle = Explosion.GetObstacleDamageMultiplier(
            simPos,
            position,
            character.SimPosition
        )

        local visibility = obstacle + wallPenetration
        if visibility > 0 then
            if visibility > 1 then visibility = 1 end

            local dist = math.sqrt(distSq)
            local factor = visibility * (1 - dist / maxDistance)

            if factor > 0 then
                local limb = character.AnimController.MainLimb
                local attackResult = limb.AddDamage(
                    limb.SimPosition,
                    afflictions,
                    false,
                    factor,
                    armorPenetration,
                    nil
                )
                character.CharacterHealth.ApplyDamage(limb, attackResult, true)
            end
        end
    end
end

Hook.Add("SF.Overheating", "SF.XML.Overheating", function(effect, deltaTime, item, targets, worldPosition, element)
    ApplyAfflictionRadius(
        worldPosition,
        tonumber(element.GetAttributeString("maxdistance")),
        tonumber(element.GetAttributeString("wallPenetration")),
        0,
        {overheating_prefab.Instantiate(tonumber(element.GetAttributeString("strength")))}
    )
end)
