local App = loadstring(game:HttpGet("https://raw.githubusercontent.com/ImNotABotIPromise/UILibrary/main/Index.lua", true))() 

local LocalPlayer = game:GetService("Players").LocalPlayer
if game.CoreGui:FindFirstChild("StandsAwakening") then game.CoreGui.StandsAwakening:Destroy() end

local AllItems = {
    ["Dio's Skull"] = false,
    ["Camera"] = false,
    ["Pot Platinum's Diary"] = false,
    ["Solar Diary"] = false,
    ["Ornstein's Spear"] = false,
    ["True Requiem Arrow"] = false,
    ["Aja Mask"] = false,
    ["Hell Arrow"] = false,
    ["Volcanic Rock"] = false,
    ["Ender Pearl"] = false,
    ["Samurai Diary"] = false,
    ["Bone"] = false,
    ["Toxic Chemicals"] = false,
    ["Requiem Arrow"] = false,
    ["DIO's Diary"] = false,
    ["Vampire Mask"] = false,
    ["Frog"] = false,
    ["Arrow"] = false,
    ["Rokakaka Fruit"] = false,
    ["Banknote"] = false
}

local Exists = true
game.CoreGui.ChildRemoved:Connect(function(obj)
    if obj:IsA("ScreenGui") and obj.Name == "StandsAwakening" then
        print(Exists)
        Exists = false
        print(Exists)
    end
end)

App, Gui = App.Load({ 
    Name = "StandsAwakening"; 
    Title = "Stands Awakening  |  Item Sniper";
    CodeStyle = 2;
})

local Home = App.New({
    Title = "Items";
    Active = true;
})

local Items = {}
local NoLagBtns = {}

local Filter = App.New({
    Title = "Filter";
})

Filter.Label("Filters")

local Filters = {}

for Item,_ in pairs(AllItems) do
    Filters[Item] = false
end

local ItemTable = {}

function updateList()
    for _,Item in pairs(ItemTable) do Item.Btn:Destroy() wait(.05) end
    ItemTable = {}

    for _,obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and Filters[obj.Name] == true then
            local Button = Filter.Button({
                Title = obj.Name
            }, function()
                local s, f = pcall(function()
                    LocalPlayer.Character.HumanoidRootPart.CFrame = obj.Handle.CFrame
                end)
                        
                print(s, f)
            end)

            ItemTable[#ItemTable + 1] = {
                Btn = Button.Object,
                Obj = obj
            }
        end
    end
end

for FilterToggle,FilterValue in pairs(Filters) do
    Filter.Toggle({
        Title = FilterToggle
    }, function(toggled)
        Filters[FilterToggle] = toggled
        updateList()
    end)
end

Filter.Label("Items")

local Afk = App.New({ 
    Title = "Afk"; 
})

Afk.Label("Auto-Use")

local Banknote = false

Afk.Toggle({
    Title = "Banknote"
}, function(toggled)
    Banknote = toggled
end)

Afk.Label("Auto-Pickup")

local AutoPickups = {}

for Item,_ in pairs(AllItems) do
    AutoPickups[Item] = false
end

for PickupToggle,_ in pairs(AutoPickups) do
    Afk.Toggle({
        Title = PickupToggle
    }, function(toggled)
        AutoPickups[PickupToggle] = toggled
        updateList()
    end)
end

Afk.Label("Auto-Delete")

local AutoDelete = {}

for Item,_ in pairs(AllItems) do
    AutoDelete[Item] = false
end

for DeleteToggle,_ in pairs(AutoDelete) do
    Afk.Toggle({
        Title = DeleteToggle
    }, function(toggled)
        AutoDelete[DeleteToggle] = toggled
        updateList()
    end)
end

local Settings = App.New({ 
    Title = "Settings"; 
})

Settings.Button({ 
    Title = "Destroy GUI"; 
}, function()
    Gui:Destroy() 
end)

-- List - NORMAL

for _,obj in pairs(workspace:GetChildren()) do
    if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
        local Button = Home.Button({
            Title = obj.Name
        }, function()
            local s, f = pcall(function()
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.Handle.CFrame
            end)
                    
            print(s, f)
        end)

        Items[#Items + 1] = {
            Btn = Button.Object,
            Obj = obj
        }
    end
end

workspace.ChildAdded:Connect(function(obj)
    if Exists then
        if obj:IsA("Tool") then
            obj:WaitForChild("Handle")

            local Button = Home.Button({
                Title = obj.Name
            }, function()
                local s, f = pcall(function()
                    LocalPlayer.Character.HumanoidRootPart.CFrame = obj.Handle.CFrame
                end)
                    
                print(s, f)
            end)
    
            Items[#Items + 1] = {
                Btn = Button.Object,
                Obj = obj
            }
        end
    end
end)

workspace.ChildRemoved:Connect(function(o)
    if Exists then
        for _,Item in pairs(Items) do 
            if Item.Obj == o then
                Item.Btn:Destroy() 
            end
        end
    end
end)

-- List - FILTER

workspace.ChildAdded:Connect(function(obj)
    if Exists then
        if obj:IsA("Tool") and Filters[obj.Name] == true then
            obj:WaitForChild("Handle")

            local Button = Filter.Button({
                Title = obj.Name
            }, function()
                local s, f = pcall(function()
                    LocalPlayer.Character.HumanoidRootPart.CFrame = obj.Handle.CFrame
                end)
                
                print(s, f)
            end)

            ItemTable[#ItemTable + 1] = {
                Btn = Button.Object,
                Obj = obj
            }
        end
    end
end)

workspace.ChildRemoved:Connect(function(o)
    if Exists then
        for _,Item in pairs(ItemTable) do 
            if Item.Obj == o then
                Item.Btn:Destroy() 
            end
        end
    end
end)

--Auto-Use - BANKNOTE

LocalPlayer.Character.ChildAdded:Connect(function(obj)
    if Exists then
        if Banknote == true then
            if obj.Name == "Banknote" then
                wait(.125)
                pcall(function()
                    obj:Activate()
                end)
            end
        end
        
        if AutoDelete[obj.Name] == true then
            obj:Destroy()
            
            wait(.025)
            
            local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if Humanoid then 
				Humanoid:UnequipTools()
			end
        end
    end
end)

-- Auto-Delete

LocalPlayer.Backpack.ChildAdded:Connect(function()
    if Exists then
        wait(.02)
            
        local s, f = pcall(function()
            for _,obj in pairs(LocalPlayer.Backpack:GetChildren()) do
                if AutoDelete[obj.Name] == true then
                    obj:Destroy()
                end
            end
        end)

        print(s, f)
    end
end)

-- Auto-Pickup

spawn(function()
    local Teleporting = false

    workspace.ChildAdded:Connect(function(obj)
        if Exists then
            spawn(function()
                if obj:IsA("Tool") and AutoPickups[obj.Name] == true then
                    obj:WaitForChild("Handle")
                    
                    repeat wait() until Teleporting == false
                    Teleporting = true
        
                    local oldCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        
                    LocalPlayer.Character.HumanoidRootPart.CFrame = obj.Handle.CFrame
                    
                    wait(.125)
                    
                    LocalPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
                    
                    Teleporting = false
                end
            end)
        end
    end)
end)
