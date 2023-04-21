local CurrentJob = { name = nil, rank = nil, duty = false }
local coreExports = exports['rpx-core']

--
-- Main radial menus that are available to everyone.
--

exports('settingsRadialHandler', function(menu, item)
    if menu == 'minimap_menu' and item == 1 then
        ExecuteCommand('minimap')
    elseif menu == 'minimap_menu' and item == 2 then
        ExecuteCommand('minimap zoomin')
    elseif menu == 'minimap_menu' and item == 3 then
        ExecuteCommand('minimap zoomout')
    end
end)

lib.registerRadial({
    id = 'settings_menu',
    items = {
        {
            label = 'Minimap',
            icon = 'map',
            menu = 'minimap_menu'
        },
    }
})

lib.registerRadial({
    id = 'minimap_menu',
    items = {
        {
            label = 'Toggle Mode',
            icon = 'map',
            onSelect = 'settingsRadialHandler',
        },
        {
            label = 'Zoom In',
            icon = 'search-plus',
            onSelect = 'settingsRadialHandler',
        },
        {
            label = 'Zoom Out',
            icon = 'search-minus',
            onSelect = 'settingsRadialHandler'
        },
    }
})

lib.registerRadial({
    id = 'interaction_menu',
    items = {
        {
            label = 'Search Person',
            icon = 'magnifying-glass',
            onSelect = 'settingsRadialHandler'
        },
        {
            label = 'Drag Person',
            icon = 'people-pulling',
            onSelect = 'settingsRadialHandler'
        },
    }
})

lib.addRadialItem({
    {
        id = 'interactions',
        label = 'Interactions',
        icon = 'user-gear',
        menu = 'interaction_menu'
    },
})
  
lib.addRadialItem({
    {
        id = 'settings',
        label = 'Settings',
        icon = 'cog',
        menu = 'settings_menu'
    },
})
  
lib.disableRadial(false)

--
-- Job-only radial menus and interactions.
--

AddStateBagChangeHandler("job", nil, function(bagName, key, value) 
    if GetPlayerFromStateBagName(bagName) ~= PlayerId() then return end
    CurrentJob.name = value.name
    CurrentJob.rank = value.rank
    CurrentJob.duty = value.duty

    ResetJobMenus()
end)

exports('jobRadialHandler', function(menu, item)
    -- Sheriff Menu
    if menu == 'sheriff_menu' then
        if item == 1 then
            return TriggerEvent("rpx-policejob:client:PoliceAction", "cuff")
        elseif item == 2 then
            return TriggerEvent("rpx-policejob:client:PoliceAction", "hogtie")
        elseif item == 3 then
            return TriggerEvent("rpx-policejob:client:PoliceAction", "frisk")
        elseif item == 4 then
            return TriggerEvent("rpx-policejob:client:PoliceAction", "drag")
        end
    end

    -- Doctor Menu
    if menu == 'doctor_menu' then
        if item == 1 then
            return TriggerEvent("rpx-doctorjob:client:DoctorAction", "revive")
        elseif item == 2 then
            return TriggerEvent("rpx-doctorjob:client:DoctorAction", "heal")
        elseif item == 3 then
            return TriggerEvent("rpx-doctorjob:client:DoctorAction", "drag")
        end
    end
end)

function ResetJobMenus()
    -- We want to remove all job-related radial menus and items before adding them back in, whether they were added already or not.
    lib.removeRadialItem('sheriff')
    lib.removeRadialItem('doctor')

    if not CurrentJob.name then
        CurrentJob.name = LocalPlayer.state.job.name
    end
    if not CurrentJob.rank then
        CurrentJob.rank = LocalPlayer.state.job.rank
    end
    if CurrentJob.duty == false and Config.JobDutyOnly then return end

    local hasSheriffMenu = coreExports:HasJobPermission(CurrentJob.name, CurrentJob.rank, 'sheriff:general')
    local hasDoctorMenu = coreExports:HasJobPermission(CurrentJob.name, CurrentJob.rank, 'doctor:general')

    if hasSheriffMenu then
        lib.addRadialItem({
            {
                id = 'sheriff',
                label = 'Sheriff',
                icon = 'shield-halved',
                menu = 'sheriff_menu'
            },
        })
        lib.registerRadial({
            id = 'sheriff_menu',
            items = {
                {
                    label = 'Handcuff',
                    icon = 'handcuffs',
                    onSelect = 'jobRadialHandler'
                },
                {
                    label = 'Hogtie',
                    icon = 'hands-bound',
                    onSelect = 'jobRadialHandler'
                },
                {
                    label = 'Frisk',
                    icon = 'magnifying-glass',
                    onSelect = 'jobRadialHandler'
                },
                {
                    label = 'Drag',
                    icon = 'people-pulling',
                    onSelect = 'jobRadialHandler'
                },
            }
        })
    end


    if hasDoctorMenu then
        lib.addRadialItem({
            {
                id = 'doctor',
                label = 'Doctor',
                icon = 'user-doctor',
                menu = 'doctor_menu'
            },
        })
        lib.registerRadial({
            id = 'doctor_menu',
            items = {
                {
                    label = 'Revive',
                    icon = 'heart-pulse',
                    onSelect = 'jobRadialHandler'
                },
                {
                    label = 'Heal',
                    icon = 'bandage',
                    onSelect = 'jobRadialHandler'
                },
                {
                    label = 'Drag',
                    icon = 'people-pulling',
                    onSelect = 'jobRadialHandler'
                },
            }
        })
    end
end