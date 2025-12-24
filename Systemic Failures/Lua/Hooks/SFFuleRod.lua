local radiationSickness_prefab = AfflictionPrefab.Prefabs["radiationsickness"]
local contaminated_prefab      = AfflictionPrefab.Prefabs["contaminated"]
local radiationSounds_prefab   = AfflictionPrefab.Prefabs["radiationsounds"]
local burn_prefab              = AfflictionPrefab.Prefabs["burn"]
local overheating_prefab       = AfflictionPrefab.Prefabs["overheating"]

local ApplyAfflictionRadius = SF.ApplyAfflictionRadius

Hook.Add("SF.FuelRod", "SF.XML.FuelRod", function(effect, deltaTime, item, targets, worldPosition, element)
    if not item.HasTag("activefuelrod") then return end

    local inventory = item.ParentInventory
    if not inventory then return end

    local owner = inventory.Owner
    local is_item_inventory = LuaUserData.IsTargetType(inventory, "Barotrauma.ItemInventory")

    local radiationSickness = tonumber(element.GetAttributeString("radiationSickness"))
    local contaminated      = tonumber(element.GetAttributeString("contaminated"))
    local radiationSounds   = tonumber(element.GetAttributeString("radiationSounds"))
    local overheating       = tonumber(element.GetAttributeString("overheating"))
    local burn              = tonumber(element.GetAttributeString("burn"))

    local blocked = is_item_inventory and (owner.HasTag("deepdivinglarge") or owner.HasTag("containradiation"))

    if not blocked then
        ApplyAfflictionRadius(item.WorldPosition, 750, 1, 0, {
            radiationSickness_prefab.Instantiate(radiationSickness),
            contaminated_prefab.Instantiate(contaminated),
            radiationSounds_prefab.Instantiate(1.25 * radiationSounds),
            overheating_prefab.Instantiate(0.05 * overheating)
        })

        if not is_item_inventory then
            local slot = inventory.FindIndex(item)

            if slot == inventory.FindLimbSlot(InvSlotType.RightHand) then
                owner.CharacterHealth.ApplyAffliction(
                    owner.AnimController.GetLimb(InvSlotType.RightHand),
                    burn_prefab.Instantiate(burn)
                )
            elseif slot == inventory.FindLimbSlot(InvSlotType.LeftHand) then
                owner.CharacterHealth.ApplyAffliction(
                    owner.AnimController.GetLimb(InvSlotType.LeftHand),
                    burn_prefab.Instantiate(burn)
                )
            end
        end
    end

    if is_item_inventory and owner.GetComponentString("Reactor") and owner.ConditionPercentage < 75 then
        ApplyAfflictionRadius(item.WorldPosition, 750, 0.6, 0, {
            radiationSickness_prefab.Instantiate((0.45 - owner.ConditionPercentage * 0.006) * radiationSickness),
            contaminated_prefab.Instantiate((0.45 - owner.ConditionPercentage * 0.006) * contaminated),
            radiationSounds_prefab.Instantiate((2.9 - owner.ConditionPercentage * 0.038) * radiationSounds),
            overheating_prefab.Instantiate((0.18 - owner.ConditionPercentage * 0.0024) * overheating)
        })
    end
end)
