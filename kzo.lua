local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- GUI
local Window = Rayfield:CreateWindow({
   Name = "KZO Hub",
   Icon = 0, -- Sử dụng Lucide Icon hoặc Roblox Image
   LoadingTitle = "Hang tight, we’re crafting something epic!",
   LoadingSubtitle = "by Anphecan123p",
   Theme = "DarkBlue",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "KZO Hub | Key",
      Subtitle = "Discord: kabachi1311",
      Note = "Contact AD for key | Discord: kabachi1311",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"kzo_ontop131109"}
   }
})

-- Tạo Tab và Section
local MainTab = Window:CreateTab("🏠 Player", nil) -- Tab chính
local MainSection = MainTab:CreateSection("Main") -- Section trong tab

-- Thông báo
Rayfield:Notify({
   Title = "Thanks For Using My Script!",
   Content = "Have Fun 🙂",
   Duration = 6.5,
   Image = nil,
})

--walkspeed

local Slider = MainTab:CreateSlider({
   Name = "Speed",
   Range = {0, 300},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})

--high jump

local Slider = MainTab:CreateSlider({
   Name = "High Jump",  -- Tên của slider
   Range = {50, 300},  -- Giới hạn giá trị từ 50 đến 300 (tùy theo yêu cầu)
   Increment = 10,  -- Gia số khi thay đổi
   Suffix = "Power",  -- Gắn thêm dấu suffix như là đơn vị "Power"
   CurrentValue = 50,  -- Giá trị hiện tại của slider
   Flag = "Slider1",  -- Flag để nhận dạng trong hệ thống lưu cấu hình
   Callback = function(Value)  -- Hàm Callback sẽ nhận giá trị từ slider
      -- Ở đây, Value là giá trị mà bạn chọn từ slider
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoid = character:FindFirstChildOfClass("Humanoid")
      
      -- Áp dụng giá trị vào JumpPower của nhân vật
      if humanoid then
         humanoid.JumpPower = Value  -- Thay đổi lực nhảy (JumpPower) theo giá trị slider
      end
   end,
})




-- Infinite Jump
local InfiniteJumpEnabled = false

local Toggle = MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "Jump", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      InfiniteJumpEnabled = not InfiniteJumpEnabled
      game:GetService("UserInputService").JumpRequest:Connect(function()
         if InfiniteJumpEnabled then
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("Humanoid") then
               player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
         end
      end)
      Rayfield:Notify({
         Title = "Infinite Jump Toggled",
         Content = InfiniteJumpEnabled and "Enabled!" or "Disabled!",
         Duration = 4,
         Image = nil,
      })
   end,
})

--God mode
local godModeEnabled = false  -- Biến để theo dõi trạng thái của God Mode

local Toggle = MainTab:CreateToggle({
   Name = "God Mode",
   CurrentValue = false,
   Flag = "God Mode", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
       local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoid = character:FindFirstChildOfClass("Humanoid")

      if humanoid then
         if not godModeEnabled then
            -- Bật God Mode
            humanoid.MaxHealth = math.huge  -- Đặt máu tối đa vô hạn
            humanoid.Health = humanoid.MaxHealth  -- Đặt máu hiện tại bằng máu tối đa
            humanoid:SetAttribute("GodMode", true)  -- Đặt thuộc tính GodMode
            godModeEnabled = true  -- Cập nhật trạng thái God Mode
            Rayfield:Notify({
               Title = "God Mode",
               Content = "You are now invincible! 🛡️",
               Duration = 4,
            })
         else
            -- Tắt God Mode
            humanoid.MaxHealth = 100  -- Đặt lại máu tối đa (hoặc giá trị mặc định)
            humanoid.Health = humanoid.MaxHealth  -- Đặt lại máu hiện tại
            humanoid:SetAttribute("GodMode", false)  -- Xóa thuộc tính GodMode
            godModeEnabled = false  -- Cập nhật trạng thái God Mode
            Rayfield:Notify({
               Title = "God Mode",
               Content = "God Mode is now disabled. ⚔️",
               Duration = 4,
            })
         end
      else
         Rayfield:Notify({
            Title = "God Mode",
            Content = "Humanoid not found. Make sure your character is loaded! ❌",
            Duration = 4,
         })
      end
   end,
})



--freecam

local Toggle = MainTab:CreateToggle({
    Name = "Toggle Free Cam",
    CurrentValue = false,
    Flag = "ToggleFreeCam", -- A flag is the identifier for the configuration file
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local camera = game.Workspace.CurrentCamera
        local userInputService = game:GetService("UserInputService")
        local runService = game:GetService("RunService")
        
        local isFreeCamActive = Value  -- Sử dụng giá trị toggle để kiểm tra trạng thái Free Cam
        local cameraPosition = camera.CFrame.Position
        local cameraRotation = camera.CFrame.Rotation
        
        -- Hàm bật/tắt Free Cam
        local function toggleFreeCam()
            if isFreeCamActive then
                -- Khi bật Free Cam, chuyển camera sang chế độ Scriptable
                camera.CameraType = Enum.CameraType.Scriptable
                camera.CFrame = CFrame.new(cameraPosition)  -- Đặt vị trí camera tại điểm hiện tại
                -- Ẩn cơ thể người chơi, làm cho nó đứng im
                player.Character.HumanoidRootPart.Anchored = true
            else
                -- Khi tắt Free Cam, phục hồi camera về chế độ Custom
                camera.CameraType = Enum.CameraType.Custom
                player.Character.HumanoidRootPart.Anchored = false  -- Hủy chế độ Anchor, cho phép di chuyển bình thường
            end
        end

        -- Di chuyển camera tự do khi Free Cam được bật
        local function moveFreeCam(deltaTime)
            if isFreeCamActive then
                local moveSpeed = 50  -- Tốc độ di chuyển camera
                local rotateSpeed = 0.5  -- Tốc độ quay camera

                -- Di chuyển camera theo các phím WASD
                local moveDirection = Vector3.new()
                if userInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + camera.CFrame.LookVector
                end
                if userInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - camera.CFrame.LookVector
                end
                if userInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - camera.CFrame.RightVector
                end
                if userInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + camera.CFrame.RightVector
                end

                -- Di chuyển camera theo hướng di chuyển
                cameraPosition = cameraPosition + (moveDirection.Unit * moveSpeed * deltaTime)

                -- Quay camera theo chuột
                local mouseDelta = userInputService:GetMouseDelta()
                cameraRotation = cameraRotation * CFrame.Angles(0, -mouseDelta.X * rotateSpeed, 0)
                cameraRotation = cameraRotation * CFrame.Angles(-mouseDelta.Y * rotateSpeed, 0, 0)

                -- Cập nhật lại camera
                camera.CFrame = CFrame.new(cameraPosition) * cameraRotation
            end
        end

        -- Điều chỉnh camera lên/xuống bằng phím Q và E
        local function adjustCameraHeight()
            if isFreeCamActive then
                if userInputService:IsKeyDown(Enum.KeyCode.Q) then
                    cameraPosition = cameraPosition - Vector3.new(0, 1, 0)  -- Di chuyển xuống
                elseif userInputService:IsKeyDown(Enum.KeyCode.E) then
                    cameraPosition = cameraPosition + Vector3.new(0, 1, 0)  -- Di chuyển lên
                end
                camera.CFrame = CFrame.new(cameraPosition) * cameraRotation
            end
        end

        -- Liên tục gọi hàm di chuyển và quay camera mỗi frame
        runService.RenderStepped:Connect(function(_, deltaTime)
            moveFreeCam(deltaTime)
            adjustCameraHeight()
        end)

        -- Bật/tắt Free Cam khi toggle được nhấn
        toggleFreeCam()
    end,
})

--noclip

local noclipEnabled = false  -- Biến lưu trạng thái Noclip
local Button = MainTab:CreateButton({
   Name = "Noclip",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoid = character:FindFirstChildOfClass("Humanoid")
      
      if humanoid then
         -- Bật/Tắt Noclip
         noclipEnabled = not noclipEnabled

         if noclipEnabled then
            -- Khi bật Noclip
            humanoid.PlatformStand = true  -- Ngừng kiểm tra va chạm
            character.HumanoidRootPart.CanCollide = false -- Tắt va chạm
            for _, part in pairs(character:GetChildren()) do
               if part:IsA("BasePart") then
                  part.CanCollide = false -- Tắt va chạm cho tất cả các bộ phận
               end
            end
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)  -- Chuyển sang trạng thái vật lý, tránh rơi xuống
            humanoid.WalkSpeed = 50  -- Tăng tốc độ di chuyển khi Noclip (Tùy chọn)
            Rayfield:Notify({
               Title = "Noclip Enabled",
               Content = "You can now phase through walls! 🚀",
               Duration = 4,
            })
         else
            -- Khi tắt Noclip
            humanoid.PlatformStand = false  -- Bật lại kiểm tra va chạm
            character.HumanoidRootPart.CanCollide = true -- Bật lại va chạm
            for _, part in pairs(character:GetChildren()) do
               if part:IsA("BasePart") then
                  part.CanCollide = true -- Bật lại va chạm cho các bộ phận
               end
            end
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)  -- Trở lại trạng thái bình thường
            humanoid.WalkSpeed = 16  -- Đặt lại tốc độ di chuyển bình thường (Tùy chọn)
            Rayfield:Notify({
               Title = "Noclip Disabled",
               Content = "You are back to normal! 🚫",
               Duration = 4,
            })
         end
      else
         Rayfield:Notify({
            Title = "Noclip Error",
            Content = "Humanoid not found! ❌",
            Duration = 4,
         })
      end
   end,
})

--click tp

local clickTPEnabled = false  -- Biến để theo dõi trạng thái của Click TP

local Button = MainTab:CreateButton({
   Name = "Click TP",
   Callback = function()
      local player = game.Players.LocalPlayer
      local mouse = player:GetMouse()
      local character = player.Character or player.CharacterAdded:Wait()
      local rootPart = character:FindFirstChild("HumanoidRootPart")

      if clickTPEnabled then
         -- Tắt Click TP
         clickTPEnabled = false
         Rayfield:Notify({
            Title = "Click TP",
            Content = "Click TP is now disabled. 🚫",
            Duration = 4,
         })
      else
         -- Bật Click TP
         clickTPEnabled = true
         Rayfield:Notify({
            Title = "Click TP",
            Content = "Click anywhere to teleport! 🚀",
            Duration = 5,
         })

         -- Sự kiện click chuột
         mouse.Button1Down:Connect(function()
            if clickTPEnabled and rootPart then
               rootPart.CFrame = CFrame.new(mouse.Hit.p)  -- Dịch chuyển đến vị trí con trỏ chuột
            elseif not rootPart then
               Rayfield:Notify({
                  Title = "Click TP",
                  Content = "HumanoidRootPart not found! ❌",
                  Duration = 4,
               })
            end
         end)
      end
   end,
})

--tang hinh

local invisibleEnabled = false  -- Biến theo dõi trạng thái của Invisible Mode

local Button = MainTab:CreateButton({
   Name = "Invisible",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()

      if invisibleEnabled then
         -- Tắt chế độ tàng hình
         if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local torso = character:FindFirstChild("UpperTorso")

            if humanoidRootPart and head and torso then
               -- Đặt lại độ trong suốt và va chạm của các bộ phận
               humanoidRootPart.Transparency = 0
               head.Transparency = 0
               torso.Transparency = 0
               for _, part in pairs(character:GetChildren()) do
                  if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                     part.LocalTransparencyModifier = 0 -- Đặt lại các bộ phận về bình thường
                  end
               end

               humanoidRootPart.CanCollide = true -- Bật va chạm lại
               head.CanCollide = true
               torso.CanCollide = true

               Rayfield:Notify({
                  Title = "Invisible Mode",
                  Content = "You are now visible again! 👀",
                  Duration = 4,
               })
            end
         end
      else
         -- Bật chế độ tàng hình
         if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local torso = character:FindFirstChild("UpperTorso")
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            -- Nếu các bộ phận tồn tại
            if humanoidRootPart and head and torso and humanoid then
               humanoidRootPart.Transparency = 1
               head.Transparency = 1
               torso.Transparency = 1
               for _, part in pairs(character:GetChildren()) do
                  if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                     part.LocalTransparencyModifier = 1 -- Đặt các bộ phận còn lại thành trong suốt
                  end
               end

               humanoidRootPart.CanCollide = false -- Tắt va chạm để không bị mắc kẹt
               head.CanCollide = false
               torso.CanCollide = false

               Rayfield:Notify({
                  Title = "Invisible Mode",
                  Content = "You are now invisible! 👻",
                  Duration = 4,
               })
            end
         end
      end

      -- Chuyển trạng thái bật/tắt của Invisible Mode
      invisibleEnabled = not invisibleEnabled
   end,
})

--COMBAT MODULE

local CombatTab = Window:CreateTab("⚔️Combat", nil) -- Title, Image
local CombatSection = CombatTab:CreateSection("Players Esp") -- Section trong tab

--hàm esp

local espEnabled = false
local espObjects = {}
local selectedColor = Color3.fromRGB(255, 255, 255) -- Màu mặc định

-- Tạo ColorPicker
local ColorPicker = CombatTab:CreateColorPicker({
    Name = "ESP Color Picker",
    Color = selectedColor,
    Flag = "ESPColor",
    Callback = function(Value)
        selectedColor = Value -- Cập nhật màu được chọn
        for _, esp in pairs(espObjects) do
            if esp[2] then
                esp[2].FillColor = selectedColor
                esp[2].OutlineColor = selectedColor
            end
        end
    end
})

-- Hàm tạo ESP cho player
local function createEspForPlayer(player)
    local character = player.Character or player.CharacterAdded:Wait()
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- Tạo Highlight cho ESP
        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.FillTransparency = 0.5 -- Độ trong suốt
        highlight.OutlineTransparency = 0
        highlight.FillColor = selectedColor
        highlight.OutlineColor = selectedColor
        highlight.Parent = character

        -- Lưu ESP để xóa sau này
        table.insert(espObjects, {player, highlight})
    end
end

-- Hàm xóa ESP khi player rời khỏi
local function removeEspForPlayer(player)
    for i, esp in pairs(espObjects) do
        if esp[1] == player then
            esp[2]:Destroy()
            table.remove(espObjects, i)
            break
        end
    end
end


-- Nút bật/tắt ESP
local Button = CombatTab:CreateButton({
    Name = "Toggle ESP",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer

        espEnabled = not espEnabled

        if espEnabled then
            -- Tạo ESP cho tất cả người chơi hiện tại
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= localPlayer then
                    createEspForPlayer(player)
                end
            end

            -- Kết nối sự kiện PlayerAdded
            game.Players.PlayerAdded:Connect(function(player)
                if espEnabled then
                    createEspForPlayer(player)
                end
            end)

            -- Kết nối sự kiện PlayerRemoving
            game.Players.PlayerRemoving:Connect(function(player)
                removeEspForPlayer(player)
            end)

            Rayfield:Notify({
                Title = "ESP",
                Content = "ESP is now enabled! 👀",
                Duration = 4,
            })
        else
            -- Tắt ESP và xóa tất cả Highlight
            for _, esp in pairs(espObjects) do
                esp[2]:Destroy()
            end
            espObjects = {}

            Rayfield:Notify({
                Title = "ESP",
                Content = "ESP has been disabled! 🚫",
                Duration = 4,
            })
        end
    end
})

--section
local CombatSection = CombatTab:CreateSection("Aimbot") -- Section trong tab

--aimbot
local Button = CombatTab:CreateButton({
    Name = "Player Aimbot",
    Callback = function()
        local player = game.Players.LocalPlayer
        local camera = game.Workspace.CurrentCamera
        local character = player.Character or player.CharacterAdded:Wait()
        local head = character:WaitForChild("Head")

        -- Biến trạng thái cho Aimbot và khoảng cách
        local isAimbotActive = false
        local maxDistance = 50 -- Khoảng cách mặc định cho aimbot

        -- Tạo slider để điều chỉnh khoảng cách
        local Slider = CombatTab:CreateSlider({
            Name = "Aimbot Distance",
            Range = {0, 100}, -- Khoảng cách từ 0 đến 100
            Increment = 1, -- Mỗi lần thay đổi là 1
            Suffix = "Studs", -- Đơn vị là Studs
            CurrentValue = maxDistance, -- Giá trị mặc định của slider
            Flag = "AimbotDistance", -- Flag cho việc lưu cấu hình
            Callback = function(Value)
                maxDistance = Value
                updateAimCircle() -- Cập nhật vòng tròn khi slider thay đổi
            end,
        })

        -- Tạo vòng tròn aim dưới chân của người chơi
        local aimCircle = Instance.new("Part")
        aimCircle.Shape = Enum.PartType.Cylinder
        aimCircle.Size = Vector3.new(maxDistance * 2, 1, maxDistance * 2) -- Kích thước của vòng tròn
        aimCircle.Anchored = true
        aimCircle.CanCollide = false
        aimCircle.Material = Enum.Material.SmoothPlastic
        aimCircle.Color = Color3.fromRGB(255, 255, 255) -- Màu trắng mặc định
        aimCircle.Position = character.HumanoidRootPart.Position -- Đặt vòng tròn tại chân của người chơi
        aimCircle.Parent = game.Workspace

        -- Hàm cập nhật vòng tròn theo khoảng cách
        local function updateAimCircle()
            aimCircle.Size = Vector3.new(maxDistance * 2, 1, maxDistance * 2) -- Cập nhật kích thước
            aimCircle.Position = character.HumanoidRootPart.Position -- Đặt lại vị trí vòng tròn dưới chân người chơi
            aimCircle.Color = Color3.fromRGB(255 - (maxDistance * 2), maxDistance * 2, 0) -- Màu vòng tròn thay đổi theo khoảng cách
        end

        -- Hàm tìm kiếm mục tiêu gần nhất trong phạm vi khoảng cách
        local function getClosestTarget()
            local closestTarget = nil
            local closestDistance = math.huge

            -- Duyệt qua tất cả các đối tượng người chơi trong game
            for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") then
                    local targetHead = otherPlayer.Character.Head
                    local distance = (targetHead.Position - head.Position).Magnitude

                    -- Kiểm tra nếu khoảng cách nhỏ hơn maxDistance
                    if distance < closestDistance and distance <= maxDistance then
                        closestTarget = targetHead
                        closestDistance = distance
                    end
                end
            end

            return closestTarget
        end

        -- Hàm aim vào mục tiêu một cách nhanh và mượt (interpolation)
        local function aimAtTargetSmoothly(targetHead)
            local direction = (targetHead.Position - camera.CFrame.Position).unit
            local targetCFrame = CFrame.lookAt(camera.CFrame.Position, camera.CFrame.Position + direction)

            -- Tăng tốc độ của sự chuyển động camera, làm cho aim nhanh hơn
            camera.CFrame = camera.CFrame:Lerp(targetCFrame, 1.5) -- Tăng tỷ lệ Lerp để aim nhanh hơn
        end

        -- Hàm auto aim
        local function autoAim()
            -- Lấy mục tiêu gần nhất
            local target = getClosestTarget()

            if target then
                -- Nhắm vào mục tiêu gần nhất
                aimAtTargetSmoothly(target)
            end
        end

        -- Bật/Tắt Aimbot
        local function toggleAimbot()
            isAimbotActive = not isAimbotActive -- Chuyển đổi trạng thái
            if isAimbotActive then
                -- Khi bật Aimbot, liên tục chạy auto aim
                while isAimbotActive do
                    autoAim()
                    wait(0.1)
                end
            end
        end

        -- Gọi toggleAimbot để bật tắt aimbot khi ấn nút
        toggleAimbot()
    end,
})
--Teleport

local TeleTab = Window:CreateTab("🗺️Teleport", nil) -- Title, Image
local TeleSection = TeleTab:CreateSection("Players Teleport") -- Section trong tab

--tele player

local selectedPlayerName = nil -- Biến lưu trữ tên player đã chọn

-- Dropdown để chọn player
local Dropdown = TeleTab:CreateDropdown({
   Name = "Choose Players",
   Options = function()
      local players = game.Players:GetPlayers()
      local playerNames = {}
      
      -- Lấy tên của tất cả các player trong game
      for _, p in pairs(players) do
         table.insert(playerNames, p.Name)
      end
      
      return playerNames
   end,
   CurrentOption = {"Player Name"},  -- Hiển thị tên người chơi mặc định
   MultipleOptions = false,  -- Không chọn nhiều người chơi
   Flag = "Dropdown1", -- Dùng để xác định trong tệp cấu hình
   Callback = function(Options)
      selectedPlayerName = Options[1]  -- Lưu tên player đã chọn
   end,
})

-- Button để teleport
local Button = TeleTab:CreateButton({
   Name = "Teleport to Player",
   Callback = function()
      if selectedPlayerName then
         local selectedPlayer = game.Players:FindFirstChild(selectedPlayerName)

         -- Kiểm tra nếu người chơi tồn tại và có nhân vật
         if selectedPlayer and selectedPlayer.Character then
            local character = selectedPlayer.Character
            if character:FindFirstChild("HumanoidRootPart") then
               local rootPart = character:FindFirstChild("HumanoidRootPart")
               local playerRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

               -- Dịch chuyển đến vị trí của player đã chọn
               playerRootPart.CFrame = rootPart.CFrame
               Rayfield:Notify({
                  Title = "Teleport Player",
                  Content = "Teleported to " .. selectedPlayerName .. "!",
                  Duration = 4,
               })
            end
         else
            Rayfield:Notify({
               Title = "Teleport Error",
               Content = "Selected player does not have a valid character! ❌",
               Duration = 4,
            })
         end
      else
         Rayfield:Notify({
            Title = "Teleport Error",
            Content = "Please select a player first! ❌",
            Duration = 4,
         })
      end
   end,
})

local WorldTab = Window:CreateTab("World", nil) -- Title, Image


local Toggle = WorldTab:CreateToggle({
    Name = "NoRender",
    CurrentValue = false,
    Flag = "NoRenderToggle",  -- Flag cho lưu cấu hình
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local camera = game.Workspace.CurrentCamera

        -- Hàm bật/tắt NoRender
        local function toggleNoRender()
            if Value then
                -- Khi bật NoRender, ẩn nhân vật của người chơi
                if character and character:FindFirstChild("Head") then
                    character:FindFirstChild("Head").Transparency = 1  -- Ẩn đầu
                    character:FindFirstChild("HumanoidRootPart").Transparency = 1  -- Ẩn RootPart
                    -- Ẩn tất cả các bộ phận khác của nhân vật
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 1
                        end
                    end
                    -- Ẩn mọi thứ khác trong Workspace
                    for _, obj in pairs(workspace:GetChildren()) do
                        if obj:IsA("Model") and obj ~= character then
                            obj:Destroy()  -- Xóa các đối tượng trong game, ngoại trừ nhân vật
                        end
                    end
                end

                -- Tắt render cho camera, nếu cần
                camera.FieldOfView = 0  -- Giảm Field of View để tạo cảm giác như không render
            else
                -- Khi tắt NoRender, phục hồi lại mọi thứ
                if character then
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 0  -- Hiển thị lại các bộ phận
                        end
                    end
                end
                -- Phục hồi lại Field of View của camera
                camera.FieldOfView = 70
            end
        end

        -- Gọi hàm bật/tắt NoRender
        toggleNoRender()
    end,
})


