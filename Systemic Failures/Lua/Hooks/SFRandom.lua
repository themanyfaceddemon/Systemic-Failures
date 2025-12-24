local SFRandomDispatch = {}
SFRandomDispatch["spawnitem"] = function(ctx, item, action)
    if Game.IsMultiplayer and CLIENT then return end
    local to_inv = action.GetAttributeString("sameinventory") == "true"

    Entity.Spawner.AddItemToSpawnQueue(
        ItemPrefab.GetItemPrefab(action.GetAttributeString("identifier")),
        item.worldPosition,
        nil,
        nil,
        function(newitem)
            if not to_inv then return end

            local suc = item.ParentInventory.TryPutItemInAnySlot(newitem)
            if not suc then
                if Game.IsMultiplayer and CLIENT then return end
                Entity.Spawner.AddEntityToRemoveQueue(item)
            end
        end
    )
end

SFRandomDispatch["fire"] = function(ctx, item, action)
    local fire = FireSource(item.worldPosition, item.CurrentHull, nil, true)
    fire.Size = Vector2(tonumber(action.GetAttributeString("size")), fire.Size.Y)
end

-- Фактически, хук в xml в случае если это не nil возвращает значение. Позволяет по факту имитировать Conditional + какое-то поведение. Это всё равно лучше чем кидать кубик через спавн энтити, но выглядит проклято
Hook.Add("SF.Random", "SF.XML.Random", function(effect, deltaTime, item, targets, worldPosition, element)
    local chance = tonumber(element.GetAttributeString("chance", "0"))
    if math.random() >= chance then return false end

    local actionType = element.GetAttributeString("type")
    local handler = SFRandomDispatch[actionType]
    if handler then
        handler({
            effect = effect,
            targets = targets,
            worldPosition = worldPosition,
            deltaTime = deltaTime
        }, item, element)
    end

    return true
end)

print("SFRandom init done")
