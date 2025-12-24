local overheating_prefab = AfflictionPrefab.Prefabs["overheating"]

local ApplyAfflictionRadius = SF.ApplyAfflictionRadius

Hook.Add("SF.Overheating", "SF.XML.Overheating", function(effect, deltaTime, item, targets, worldPosition, element)
    ApplyAfflictionRadius(item.WorldPosition, 750, 1, 0, {overheating_prefab.Instantiate(0.1)})
end)
