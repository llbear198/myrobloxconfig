
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

getgenv().Key = "49d6b42c7803d3406eaba679"

getgenv().Config = {

    ["Enable Screen Black"]       = true,   -- should the screen be blacked out at startup?
    ["Screen Black FPS Cap"]      = 30,     -- FPS cap when removing blackout
    ["Buy Egg"]                   = {
        ["Select Egg"] = {
            ["Night Egg"]    = true,
            ["Bug Egg"]      = true,
            ["Mythical Egg"] = true,
            ["Legendary Egg"]= true
        }
    },
    ["Delete Pet"]                = {
        ["Enabled"]        = false,
        ["Pet Dont Delete"] = {"Kiwi","Raccoon","Dragon Fly","Queen Bee"}
    },
    ["dont Buy Seed low Price"]   = {
        ["Enabled"] = true,
        ["Money"]   = 50000
    },
    ["Auto Delete Seed Planted"]  = {
        ["Enabled"]                 = true,
        ["Auto Delete Seed Low Price"] = true,
        ["Slot"]                    = 100,
        ["Name Seed Delete"]        = {"Strawberry","Blueberry","Tomato","Corn"}
    },
    ["Dont collect during weather events"] = {
        ["Enabled"] = false,
        ["Weather"] = {
          ["Rain"] = false,
          ["Frost"] = false,
          ["Thunderstorm"] = false}
    },
    ["Gear"]                      = {
        ["Buy Gear"] = {
            ["Enabled"] = true,
            ["Select Gear"] = {
                ["Basic Sprinkler"]   = true,
                ["Advanced Sprinkler"] = true,
                ["Godly Sprinkler"]    = true,
                ["Master Sprinkler"]   = true
            }
        },
        ["Use Gear"] = {
            ["Enabled"] = false,
            ["Select Gear"] = {
                ["Basic Sprinkler"]   = false,
                ["Advanced Sprinkler"] = false,
                ["Godly Sprinkler"]    = true,
                ["Master Sprinkler"]   = true
            },
            ["Stack Gear"] = {
                ["Enabled"] = false,
                ["Select Gear"] = {
                    ["Basic Sprinkler"]   = false,
                    ["Advanced Sprinkler"] = false,
                    ["Godly Sprinkler"]    = true,
                    ["Master Sprinkler"]   = true
                }
            }
        }
    },
    ["Webhook"] = {
        ["Enabled"] = true,
        ["Url"] = "",
        ["Webhook Profile"] = true,
        ["Webhook Collect Egg"] = true
    },
    ["Hop Server"] = {
      ["Enabled"] = false,
      ["Minutes"] = 15},
    ["Auto Rejoin"] = {
      ["Enabled"] = true,
      ["Delay"] = 5},
    ["FPS Lock"]    = {
      ["Enabled"] = true,
      ["Value"] = 60},
    ["Buy Honey Shop"] = {
        ["Flower Seed Pack"] = true,
        ["Nectarine"] = false,
        ["Hive Fruit"] = false,
        ["Honey Sprinkler"] = true,
        ["Bee Egg"] = true,
        ["Bee Crate"] = false,
        ["Honey Comb"] = false,
        ["Bee Chair"] = false,
        ["Honey Torch"] = false,
        ["Honey Walkway"] = false
    },
    ["Dupe Seed"]   = {
      ["Enabled"] = false,
      ["Delay"] = 3},

    ["Auto Place Pet Egg"] = {
      ["Enabled"] = true},
    ["Auto Hatch Egg"]     = {
      ["Enabled"] = false},
    ["World Optimization"] = {
        ["Enabled"] = true,
        ["KeywordsToRemove"] = {"grass","dirt","ground","path","road","bush",
                              "rock","stone","tile","fence","deco","small"},
                              
        ["SafeWords"]       = {"fruit","tree","plantbox","character","npc"},
        ["MaxToRemove"] = 200
    },
    ["Remove Specific Parts"] = {
        ["Enabled"] = true,
        ["Tolerance"] = 0.1,
        ["Targets"] = {
            {-104.5,-10,-13.5},{28,0.060024,-105},{40,0.060024,-105},
            {-4,0.060024,-105},{72,0.060024,-104.5},{-104.5,-75.5,-13}
        }
    },
    ["Remove Structures"] = {
        ["Enabled"] = true,
        ["Keywords"] = {"house","home","building","structure"}
    },
    ["Anti Fall Ground"] = {
        ["Enabled"] = true,
        ["Size"] = {1000,1,1000},
        ["Position"] = {0,-10,0},
        ["Transparency"] = 1
    }
}

loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/KaitunGAG.lua"
))()

task.delay(6,function()
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/DonkiRoblox111/config/refs/heads/main/Alr"
    ))()
end)

local Player = game:GetService("Players").LocalPlayer

local function getFarm()
    for _, farm in ipairs(workspace:WaitForChild("Farm"):GetChildren()) do
        local ok, owner = pcall(function()
            return farm:WaitForChild("Important").Data.Owner.Value
        end)
        if ok and owner == Player.Name then
            return farm
        end
    end
    return nil
end

local farm = getFarm()
local cachedPlayerData = nil

task.spawn(function()
    local DataService = require(game:GetService("ReplicatedStorage").Modules.DataService)
    if typeof(DataService.GetData) == "function" then
        local old = DataService.GetData
        DataService.GetData = function(self,...)
            local data = old(self,...)
            cachedPlayerData = data
            return data
        end
    end
end)

spawn(function()
    wait(5)
    local shop = getgenv().Config["Buy Honey Shop"]
    local function buyEventShopItems()
        local data = cachedPlayerData
        if not data or not data.EventShopStock or not data.EventShopStock.Stocks then return end
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):FindFirstChild("BuyEventShopStock")
        for itemName,enabled in pairs(shop) do
            if enabled then
                local stock = data.EventShopStock.Stocks[itemName]
                if stock and stock.Stock>0 then
                    pcall(function() remote:FireServer(itemName) end)
                    task.wait()
                end
            end
        end
    end
    while task.wait(5) do pcall(buyEventShopItems) end
end)

spawn(function()
    if not (farm and getgenv().Config["Auto Place Pet Egg"].Enabled) then return end
    wait(5)
    local placeEgg = {}
    local base = farm:WaitForChild("Important").Plant_Locations.Can_Plant.Position
    for _,z in ipairs({-15,-19}) do
        for i = (z==-15 and -2 or -1),(z==-15 and 2 or 1) do
            table.insert(placeEgg,{Used=false,Position=Vector3.new(base.X+i*4,base.Y,base.Z+z)})
        end
    end
    while task.wait(5) do
        pcall(function()
            local data = cachedPlayerData; if not data or not data.InventoryData then return end
            local petEggs={}
            for id,item in pairs(data.InventoryData) do
                if item.ItemType=="PetEgg" then
                    table.insert(petEggs,{id=id,name=item.ItemData and item.ItemData.EggName or"Unknown",
                        uses=item.ItemData and item.ItemData.Uses or 0})
                end
            end
            if #petEggs==0 then return end
            for _,e in ipairs(placeEgg) do e.Used=false end
            local eggPlaced=0
            for _,egg in ipairs(farm:WaitForChild("Important").Objects_Physical:GetChildren()) do
                if egg.Name~="PetEgg" then continue end
                eggPlaced+=1
                local pos=egg.PetEgg.Position
                for _,entry in ipairs(placeEgg) do
                    if not entry.Used and math.abs(entry.Position.X-pos.X)<=1 and math.abs(entry.Position.Z-pos.Z)<=1 then
                        entry.Used=true; break
                    end
                end
            end
            local maxEggs=data.PetsData.MutableStats.MaxEggsInFarm
            if eggPlaced>=maxEggs then return end
            for _,egg in ipairs(petEggs) do
                pcall(function()
                    Player.Character.Humanoid:EquipTool(Player.Backpack[egg.name.." x"..egg.uses])
                end)
                task.wait(2)
                for _=1,egg.uses do
                    local target=nil
                    for _,entry in ipairs(placeEgg) do if not entry.Used then target=entry break end end
                    if not target then return end
                    game:GetService("ReplicatedStorage").GameEvents.PetEggService:FireServer("CreateEgg",target.Position)
                    target.Used=true; eggPlaced+=1; task.wait(1)
                    if eggPlaced>=maxEggs then return end
                end
            end
        end)
    end
end)

spawn(function()
    if not (farm and getgenv().Config["Auto Hatch Egg"].Enabled) then return end
    while task.wait(5) do
        pcall(function()
            for _,egg in ipairs(farm:WaitForChild("Important").Objects_Physical:GetChildren()) do
                if egg.Name~="PetEgg" then continue end
                if egg:GetAttribute("TimeToHatch")==0 then
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents")
                        :WaitForChild("PetEggService"):FireServer("HatchPet",egg)
                end
            end
        end)
    end
end)

spawn(function()
    local cfg=getgenv().Config["Hop Server"]
    if not (cfg and cfg.Enabled) then return end
    local hopMinutes=cfg.Minutes or 10
    while true do
        if getgenv().UpdateAction then getgenv().UpdateAction("Hopping server in "..hopMinutes.." minutes") end
        wait(hopMinutes*60)
        if getgenv().UpdateAction then getgenv().UpdateAction("Teleporting to new server...") end
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
end)

task.spawn(function()
    repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
    if not getgenv().Config["Enable Screen Black"] then
        task.delay(6,function()
            pcall(function()
                local fpsCap=getgenv().Config["Screen Black FPS Cap"] or 30
                if typeof(setfpscap)=="function" then setfpscap(fpsCap) end
                for _,v in ipairs(game:GetDescendants()) do
                    if v:IsA("LocalScript") and v.Name:lower():find("blackscreen") then v:Destroy()
                    elseif v:IsA("Frame") and v.BackgroundColor3==Color3.new(0,0,0)
                         and v.AbsoluteSize.X>300 and v.AbsoluteSize.Y>200 then v:Destroy()
                    elseif v:IsA("ImageLabel") and v.ImageColor3==Color3.new(0,0,0) then v:Destroy()
                    end
                end
                for _,gui in ipairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") and gui.Name:lower():find("black") then gui:Destroy() end
                end
            end)
        end)
    end
end)

pcall(function()
    local ts=game:GetService("TeleportService")
    local cfg=getgenv().Config["Auto Rejoin"]
    if cfg.Enabled then
        local delayTime=cfg.Delay or 5
        local function TryRejoin() task.wait(delayTime); ts:Teleport(game.PlaceId,Player) end
        pcall(function()
            Player.OnTeleport:Connect(function(state)
                if state==Enum.TeleportState.Failed or state==Enum.TeleportState.RequestRejected then TryRejoin() end
            end)
        end)
        pcall(function()
            game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                if child.Name=="ErrorPrompt" then TryRejoin() end
            end)
        end)
    end
end)

pcall(function()
    local cfg=getgenv().Config["World Optimization"]; if not cfg.Enabled then return end
    local removed,limit=0,cfg.MaxToRemove
    for _,v in pairs(workspace:GetDescendants()) do
        if removed>=limit then break end
        if v:IsA("BasePart") or v:IsA("Model") then
            local name=v.Name:lower(); local remove=false
            for _,kw in ipairs(cfg.KeywordsToRemove) do if name:find(kw) then remove=true break end end
            for _,safe in ipairs(cfg.SafeWords) do if name:find(safe) then remove=false break end end
            if remove then pcall(function() v:Destroy() end); removed+=1 end
        end
    end
end)

pcall(function()
    local cfg=getgenv().Config["Remove Specific Parts"]; if not cfg.Enabled then return end
    local tol,cframes=cfg.Tolerance or 0.1,{}
    for _,t in ipairs(cfg.Targets) do table.insert(cframes,CFrame.new(unpack(t))) end
    for _,cf in ipairs(cframes) do
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.CFrame.Position:FuzzyEq(cf.Position,tol) then pcall(function() v:Destroy() end) end
        end
    end
end)

pcall(function()
    local cfg=getgenv().Config["Remove Structures"]; if not cfg.Enabled then return end
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") or v:IsA("BasePart") then
            local name=v.Name:lower()
            for _,kw in ipairs(cfg.Keywords) do
                if name:find(kw) then pcall(function() v:Destroy() end) break end
            end
        end
    end
end)

pcall(function()
    local cfg=getgenv().Config["Anti Fall Ground"]; if not cfg.Enabled then return end
    local part=Instance.new("Part")
    part.Size=Vector3.new(unpack(cfg.Size)); part.Position=Vector3.new(unpack(cfg.Position))
    part.Anchored=true; part.CanCollide=true; part.Transparency=cfg.Transparency
    part.Name="AntiFallGround"; part.Parent=workspace
end)

pcall(function()
    local cfg=getgenv().Config["FPS Lock"]; if cfg.Enabled then
        local fps=tonumber(cfg.Value); if fps and fps>=30 and fps<=100 and typeof(setfpscap)=="function" then
            pcall(function() setfpscap(fps) end)
        end
    end
end)

task.spawn(function()
    local cfg=getgenv().Config["Dupe Seed"]; if not cfg.Enabled then return end
    local delayTime=cfg.Delay or 3
    local fc=setmetatable({},{
        __index=function(_,i)
            if i=="Seed" then
                return function(ins)
                    if ins and ins:GetAttribute("Quantity") then
                        ins:SetAttribute("Quantity",ins:GetAttribute("Quantity")+1)
                        ins.Name = ins.Name:gsub("%d+",tostring(ins:GetAttribute("Quantity")))
                    end
                end
            else
                return function(ins)
                    if not ins then return end
                    local clone=ins:Clone(); clone.Parent=Player.Backpack
                    local amt,name=clone.Name:match("%[(.-)%]"),clone.Name:match("(%a+)")
                    amt=tonumber(amt:gsub("kg","")) or 1
                    local newVal=tostring(math.random(math.floor(amt)*100,(math.ceil(amt)+1)*100))/100
                    clone.Name=string.format("%s [%skg]",name,newVal)
                end
            end
        end,__newindex=function()end,__metatable="locked"
    })
    while task.wait(delayTime) do
        for _,item in ipairs(Player.Backpack:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("Handle") and item:GetAttribute("Quantity") then
                pcall(function() fc.Seed(item) end)
            end
        end
    end
end)
