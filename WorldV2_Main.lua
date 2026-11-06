-- Official Luraph Macro SDK embedded for addon environments without loadstring.
-- SDK snapshot: 8d9ff65c66a7996e5567f11fed1f7e0ba27866ed (Luraph/macrosdk).
--[=[
MIT License

Copyright (c) 2024 CorruptedMemes LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]=]
if not LPH_OBFUSCATED then

    -- Macros:

    LPH_ENCSTR = function(n) return n end
    LPH_ENCNUM = function(n) return n end

    LPH_STRENC = function(n) return n end
    LPH_NUMENC = function(n) return n end

    if buffer then

        local buffer_fromstring = buffer.fromstring
        
        LPH_ENCBUF = function(n) return buffer_fromstring(n) end
        LPH_BUFENC = function(n) return buffer_fromstring(n) end
        
    end
     
    LPH_CRASH = function() end

    do

        local table_unpack = table.unpack or unpack
        local table_pack = table.pack or function(...) return { n = select("#", ...), ... } end

        local __stackalloc = { }
        __stackalloc.__index = __stackalloc

        __stackalloc.clear = function(self, first, last) 

            first = first or self.__base
            last = last or self.__end
            
            for i = first, last do self[i] = nil end 

        end

        __stackalloc.unpack = function(self, first, last) 

            first = first or self.__base
            last = last or self.__end
            
            return table_unpack(self, first, last) 
        
        end

        __stackalloc.pack = function(self, first, last) 
            
            first = first or self.__base
            last = last or self.__end

            return table_pack(table_unpack(self, first, last))
        
        end
        
        __stackalloc.__len = function(self) return self.__size end
        
        LPH_STACKALLOC = function(size, base)

            base = base or 1

            local allocation = { }
            allocation.__size = size
            allocation.__base = base
            allocation.__end = base + size - 1

            return setmetatable(allocation, __stackalloc)

        end

    end

    LPH_PRECHECK = function(check) check() end

    LPH_REWRITE = function(e) return e end
    LPH_ASSUME = function(e) return e end
    LPH_OPAQUE = function(e) return e end

    -- Attributes:

    local __attribute = function() end

    LPH_ATTRIBUTES = __attribute

    ENCRYPT = __attribute

    VM = __attribute
    PRESET = __attribute
    OPTIMIZE = __attribute
    NO_UPVALUES = __attribute
    ERROR_HANDLING = __attribute
    UNSAFE_ENVIRONMENT = __attribute

    UNROLL = __attribute
    INLINE = __attribute

    TRANSFORM = __attribute

    -- VM Options:

    NONE = __attribute
    OPAL = __attribute
    ONYX = __attribute

    -- PRESET Options:

    FAST = __attribute
    BALANCED = __attribute
    SECURE = __attribute

    -- TRANSFORM Options:

    EXTRACT = __attribute
    CONTROL_FLOW = __attribute
    REWRITE_NAMECALLS = __attribute

    -- EXTRACT Options:

    GLOBALS = __attribute
    CONSTANTS = __attribute

end

local shared, globalShared = odh_shared_plugins, shared
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local task = type(task) == "table" and task or {
defer = function(fn, ...) if type(spawn) == "function" then local args = table.pack(...); return spawn(function() fn(table.unpack(args, 1, args.n)) end) end return coroutine.wrap(fn)(...) end,
spawn = function(fn, ...) if type(spawn) == "function" then local args = table.pack(...); return spawn(function() fn(table.unpack(args, 1, args.n)) end) end return coroutine.wrap(fn)(...) end,
wait = type(wait) == "function" and wait or function() return 0 end,
delay = function(t, fn, ...) if type(delay) == "function" then local args = table.pack(...); return delay(t, function() fn(table.unpack(args, 1, args.n)) end) end end,
cancel = function() end,
}
local mainTab
local CFG_FILE = "WorldV2_settings.json"
local ConfigData = {}
local PositionData = {}
local configResetting = false
local runtimeAlive = true
local bootStarted=os.clock()
local function bootBudget(normal)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
return os.clock()-bootStarted<10 and normal*0.5 or normal
end
local controlsReady=false
local silentControlDepth=0
local function silentControl(callback,...)
silentControlDepth=silentControlDepth+1
local results=table.pack(pcall(callback,...))
silentControlDepth=silentControlDepth-1
return table.unpack(results,1,results.n)
end
local env = {}
if type(getgenv) == "function" then
local ok, result = pcall(getgenv)
if ok and type(result) == "table" then env = result end
end
local inMurderMystery = game.GameId == 66654135 or game.PlaceId == 142823291
or game.GameId == 10413186812 or game.GameId == 10769671266
or game.PlaceId == 93017634738276 or game.PlaceId == 81374640397860
or (type(shared) == "table" and (shared.game_name == "Murder Mystery 2" or shared.game_name == "Murder Mystery Modded"))
local function w2Section(build,label)
local ok,problem=xpcall(build,function(message)
local traced=nil
pcall(function() traced=debug.traceback(tostring(message),2) end)
return traced or tostring(message)
end)
if ok then return end
pcall(warn,"[World V2] "..tostring(label).." couldn't load; the rest still works.\n"..tostring(problem))
pcall(function() shared.Notify("World V2: "..tostring(label).." couldn't load. The rest still works (details in the console).",1) end)
end
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE))
local bridge=env.WorldV2ControlAudioBridge
if type(bridge)~="table" then bridge={methods={}};env.WorldV2ControlAudioBridge=bridge end
local soundService=game:GetService("SoundService")
bridge.handler=function(sound)
if not runtimeAlive or (controlsReady and silentControlDepth==0) then return false end
if typeof(sound)~="Instance" or not sound:IsA("Sound") or sound.Looped
or sound:GetAttribute("VisualsV2_GunCosmetic") then return false end
local parent=sound.Parent
if not parent or sound:IsDescendantOf(soundService) then return true end
while parent and parent~=game do
if parent:IsA("GuiBase2d") or parent:IsA("LayerCollector") then return true end
if parent==workspace then return false end
parent=parent.Parent
end
return false
end
local hook=hookfunction or env.hookfunction
local closure=newcclosure or env.newcclosure
if type(hook)=="function" then
local sample=Instance.new("Sound")
for _,method in ipairs({"Play","PlayLocalSound"}) do
if not bridge.methods[method] then
local previous
local wrapper=function(object,...)
local sound=method=="Play" and object or select(1,...)
if bridge.handler and bridge.handler(sound) then return end
return previous(object,...)
end
if type(closure)=="function" then wrapper=closure(wrapper) end
local target=method=="Play" and sample.Play or soundService.PlayLocalSound
local ok,result=pcall(hook,target,wrapper)
if ok and type(result)=="function" then previous=result;bridge.methods[method]=true end
end
end
sample:Destroy()
end
end,"Part at line 58")
do
-- (if ODH can't download the tab icon it raises an error; the tab is then made without an icon, so
-- World V2 still loads)
local made,tab=pcall(shared.CreateTab,"World V2","/genshinplayer01234-cyber/WorldV2DEV/refs/heads/main/icon")
if not made or tab==nil then made,tab=pcall(shared.CreateTab,"World V2") end
if not made then error(tab,0) end
mainTab=tab
end
local previousThrowableBridge=env.WorldV2ThrowableAimBridge
if type(previousThrowableBridge)=="table" then previousThrowableBridge.handler=nil end
local read = type(readfile) == "function" and readfile or env.readfile
local write = type(writefile) == "function" and writefile or env.writefile
local exists = type(isfile) == "function" and isfile or env.isfile
local configExistedAtStart=false
if type(exists)=="function" then
local ok,result=pcall(exists,CFG_FILE)
configExistedAtStart=ok and result==true
elseif type(read)=="function" then
configExistedAtStart=pcall(read,CFG_FILE)
end
local migratedSettings=false
if not configExistedAtStart and type(read)=="function" and type(write)=="function" then
local ok,text=pcall(read,"VisualsV2_settings.json")
if ok and type(text)=="string" and #text>2 then
local decoded=nil
pcall(function() decoded=HttpService:JSONDecode(text) end)
if type(decoded)=="table" and (type(decoded.settings)=="table" or type(decoded.positions)=="table") then
if pcall(write,CFG_FILE,text) then configExistedAtStart=true;migratedSettings=true end
end
end
end
local freshInstall=not configExistedAtStart
local defaultOnControls={}
local function isPositionKey(key)
return type(key) == "string" and key:lower():find("position", 1, true) ~= nil
end
local function encodeConfigValue(value)
if typeof(value) == "Color3" then
return {color3 = {value.R, value.G, value.B}}
end
return value
end
local function decodeConfigValue(value, default)
if typeof(default) == "Color3" and type(value) == "table" then
local color = value.color3 or value
if type(color) == "table" and #color >= 3 then
local r, g, b = tonumber(color[1]), tonumber(color[2]), tonumber(color[3])
if r and g and b then
if r > 1 or g > 1 or b > 1 then
return Color3.fromRGB(r, g, b)
end
return Color3.new(r, g, b)
end
end
end
return value
end
-- (MM2 and MMV each keep their own settings, in the same file: under games.MM2 and games.MMV. Button
-- positions are shared. The first time in a game, it starts from the settings saved before this)
local SAVE_GAME=(game.GameId==10413186812 or game.GameId==10769671266 or game.PlaceId==93017634738276
or game.PlaceId==81374640397860 or (type(shared)=="table" and shared.game_name=="Murder Mystery Modded")) and "MMV"
or ((game.GameId==66654135 or game.PlaceId==142823291 or (type(shared)=="table" and shared.game_name=="Murder Mystery 2")) and "MM2")
or "Other"
local savedGames={}
local function readSaved()
local ok, decoded = pcall(function()
return HttpService:JSONDecode(read(CFG_FILE))
end)
if ok and type(decoded) == "table" then return decoded end
return nil
end
local function loadConfig()
LPH_ATTRIBUTES(PRESET(FAST))
if type(read) ~= "function" then return end
local found = true
if type(exists) == "function" then
local ok, result = pcall(exists, CFG_FILE)
found = ok and result
end
if not found then return end
local decoded = readSaved()
if type(decoded) ~= "table" then return end
if type(decoded.games) == "table" then savedGames = decoded.games end
local mine = savedGames[SAVE_GAME]
if type(mine) == "table" and type(mine.settings) == "table" then
ConfigData = mine.settings
elseif type(decoded.settings) == "table" then
ConfigData = decoded.settings
end
if type(decoded.positions) == "table" then
PositionData = decoded.positions
end
end
local function saveConfig()
if not runtimeAlive or type(write) ~= "function" then return false end
-- (the other game's settings are read fresh first, so playing both at once doesn't lose either)
if type(read) == "function" then
local latest = readSaved()
if type(latest) == "table" and type(latest.games) == "table" then
for name, saved in pairs(latest.games) do
if name ~= SAVE_GAME then savedGames[name] = saved end
end
end
end
savedGames[SAVE_GAME] = {settings = ConfigData}
local payload = {
version = 3,
settings = ConfigData,
positions = PositionData,
games = savedGames,
}
return pcall(function()
write(CFG_FILE, HttpService:JSONEncode(payload))
end)
end
local function C(key, default)
local source = isPositionKey(key) and PositionData or ConfigData
local value = source[key]
if value == nil then
local seededDefault=default
if freshInstall and type(default)=="boolean" and not defaultOnControls[key] then
seededDefault=false
end
if seededDefault ~= nil then
source[key]=encodeConfigValue(seededDefault)
end
return seededDefault
end
return decodeConfigValue(value, default)
end
local configSaveQueued=false
local function SetCfg(key, value)
if configResetting or not runtimeAlive then return end
local target = isPositionKey(key) and PositionData or ConfigData
local encoded
if value~=nil then encoded=encodeConfigValue(value) end
if target[key]==encoded then return end
target[key]=encoded
if configSaveQueued then return end
configSaveQueued=true
task.defer(function()
configSaveQueued=false
if runtimeAlive and not configResetting then saveConfig() end
end)
end
local restoreQueue={}
local restoreRunning=false
local function queueRestore(callback)
restoreQueue[#restoreQueue+1]=callback
if restoreRunning then return end
restoreRunning=true
task.defer(function()
local index=1
local started=os.clock()
while restoreQueue[index] do
if not runtimeAlive then break end
local item=restoreQueue[index]
restoreQueue[index]=false
index=index+1
task.spawn(function() pcall(item) end)
if os.clock()-started>=0.006 then task.wait();started=os.clock() end
end
table.clear(restoreQueue)
restoreRunning=false
end)
end
local function addToggle(section, name, defaultValue, callback)
local uiState = false
local applied = false
local rawToggle
local constructing=true
local function apply(newState)
if applied == newState then return end
applied = newState
callback(newState)
end
rawToggle = section:AddToggle(name, function(newState)
uiState = not not newState
if constructing then return end
if runtimeAlive or not uiState then apply(uiState) end
end)
constructing=false
local controller = {Raw = rawToggle}
-- (the switch is flipped once; when the hub reports the flip a moment later rather than straight
-- away, it's checked again next frame instead of being flipped back)
local wanted = nil
function controller:Set(newState)
newState = not not newState
wanted = newState
if uiState ~= newState then
silentControl(rawToggle)
if uiState ~= newState then
task.defer(function()
if wanted == newState and uiState ~= newState then silentControl(rawToggle) end
end)
end
end
if applied ~= newState and (runtimeAlive or not newState) then apply(newState) end
end
function controller:Get()
return applied
end
queueRestore(function()
if runtimeAlive then controller:Set(defaultValue==true) end
end)
return controller
end
local function addDropdown(section, name, items, defaultValue, callback, notification)
local function valueOf(value)
if type(value)=="table" then value=value[1] or value.Value or value.value end
return value
end
local selectedValue=valueOf(defaultValue)
local silent=1
local revision=0
local constructing=true
local function changed(value)
if constructing then return end
local selected=valueOf(value)
local previous=selectedValue
local userChange=silent==0 and selected~=previous
selectedValue=selected
if userChange then revision=revision+1 end
local accepted=callback(selected)
if accepted==false then selectedValue=previous; return end
if not userChange or not runtimeAlive or configResetting or notification==false then return end
local message
if type(notification)=="function" then
message=notification(selected,previous)
elseif selected~=nil then
message=name:gsub("^W2 ","")..": "..tostring(selected)
end
if message then pcall(shared.Notify,message,2) end
end
local rawController=section:AddDropdown(name,items,changed)
constructing=false
silent=0
selectedValue=valueOf(defaultValue)
local controller={}
if type(rawController)=="table" then
setmetatable(controller,{__index=rawController})
for _,method in ipairs({"Select","Change","ChangeItems"}) do
local method=method
if type(rawController[method])=="function" then
controller[method]=function(first,...)
local args=first==controller and table.pack(...) or table.pack(first,...)
revision=revision+1
if method=="Select" then selectedValue=valueOf(args[1]) end
silent=silent+1
local ok,result=silentControl(rawController[method],table.unpack(args,1,args.n))
if not ok then
ok,result=silentControl(rawController[method],rawController,table.unpack(args,1,args.n))
end
silent=silent-1
if not ok then error(result,0) end
return result
end
end
end
end
if defaultValue~=nil then
queueRestore(function()
if not runtimeAlive or configResetting or revision~=0 then return end
silent=silent+1
if type(controller.Select)=="function" then pcall(controller.Select,defaultValue) end
pcall(changed,defaultValue)
silent=silent-1
end)
end
return type(rawController)=="table" and controller or rawController
end
;w2Section(function()
local previousBridge=LocalPlayer:FindFirstChild("WorldV2_RuntimeBridge")
if previousBridge and previousBridge:IsA("BindableFunction") and previousBridge:GetAttribute("WorldV2_RuntimeBridge") then
pcall(function() previousBridge:Invoke("Cleanup") end)
pcall(function() previousBridge:Destroy() end)
end
end,"Part at line 355")
local previousRuntime = env.WorldV2Runtime
if type(previousRuntime) == "table" and type(previousRuntime.Cleanup) == "function" then
pcall(previousRuntime.Cleanup)
end
loadConfig()
if next(ConfigData)==nil and next(PositionData)==nil then freshInstall=true end
env.WorldV2Runtime = {Resetters = {}, Build = "2026-10-25-w2-1"}
env.WorldV2Runtime.MakeBatcher = function(handler, budget, limit)
LPH_ATTRIBUTES(PRESET(FAST))
local queue, head, tail, running = {}, 1, 0, false
local queued = setmetatable({}, {__mode = "k"})
local batcher = {}
local function drain()
while head <= tail and runtimeAlive do
local started = os.clock()
local cap = limit and math.max(1, math.floor(bootBudget(limit))) or math.huge
local handled = 0
while head <= tail and handled < cap and os.clock() - started < bootBudget(budget or 0.002) do
handled = handled + 1
local item = queue[head]
queue[head] = nil
head = head + 1
if item ~= nil then
queued[item] = nil
pcall(handler, item)
end
end
if head <= tail then task.wait() end
end
head, tail, running = 1, 0, false
end
function batcher.Push(item)
if item == nil or queued[item] then return end
queued[item] = true
tail = tail + 1
queue[tail] = item
if not running then running = true; task.defer(drain) end
end
function batcher.Clear()
table.clear(queue); table.clear(queued); head, tail = 1, 0
end
function batcher.Pending() return tail - head + 1 end
return batcher
end
do
local busy, busySince, last = false, 0, -math.huge
local queued = 0
env.WorldV2Runtime.GetObjects = function(url)
queued = queued + 1
while busy and os.clock() - busySince < 10 do task.wait(0.05) end
queued = math.max(queued - 1, 0)
busy, busySince = true, os.clock()
local hold = math.max(bootStarted + 1.5 - os.clock(), last + 0.25 - os.clock())
if hold > 0 then task.wait(hold) end
local ok, result = pcall(function() return game:GetObjects(url) end)
last, busy = os.clock(), false
if not ok then error(result, 0) end
return result
end
env.WorldV2Runtime.DownloadsBusy = function() return busy or queued > 0 end
end
-- (Trick Shoot, Shiftlock Shoot and throwing the Fake Bomb all turn your character by hand: each one
-- holds rotation, and it only comes back on when the last of them lets go, so two of them at once
-- never leave your character stuck facing one way)
do
local held=setmetatable({}, {__mode="k"})
env.WorldV2Runtime.HoldRotation = function(humanoid)
if typeof(humanoid)~="Instance" then return function() end end
local record=held[humanoid]
if not record then
record={count=0,original=humanoid.AutoRotate}
held[humanoid]=record
end
record.count=record.count+1
pcall(function() humanoid.AutoRotate=false end)
local released=false
return function()
if released then return end
released=true
record.count=record.count-1
if record.count<=0 and held[humanoid]==record then
held[humanoid]=nil
pcall(function() humanoid.AutoRotate=record.original end)
end
end
end
end
-- (a key typed into a text box, for your own ODH keys: ODH won't take a key in a keybind field when
-- it already uses that key itself. A letter, a number or a key's name, in any case; nil if it isn't one)
do
local NUMBERS={["0"]="Zero",["1"]="One",["2"]="Two",["3"]="Three",["4"]="Four",["5"]="Five",["6"]="Six",["7"]="Seven",["8"]="Eight",["9"]="Nine"}
env.WorldV2Runtime.KeyFromText = function(text)
local raw=tostring(text or ""):gsub("%s","")
if raw=="" then return nil end
local tries={NUMBERS[raw] or raw,raw:upper(),raw:sub(1,1):upper()..raw:sub(2):lower(),raw:sub(1,1):upper()..raw:sub(2)}
for _,name in ipairs(tries) do
local ok,code=pcall(function() return Enum.KeyCode[name] end)
if ok and code and code~=Enum.KeyCode.Unknown then return code.Name end
end
return nil
end
end
env.WorldV2Runtime.RegisterReset = function(callback)
if type(callback) == "function" then table.insert(env.WorldV2Runtime.Resetters, callback) end
end
env.WorldV2Runtime.Cleanup = function()
if not runtimeAlive then return end
saveConfig()
runtimeAlive = false
configResetting = true
for _, resetter in ipairs(env.WorldV2Runtime.Resetters or {}) do pcall(resetter) end
configResetting = false
end
;w2Section(function()
local runtime=env.WorldV2Runtime
local STARS={
{x=0.5,y=0.5,w=1,h=1,offset=0,rect={327,0,144,144}},
}
local ICON_SIZE=64
local function decode64(text)
LPH_ATTRIBUTES(PRESET(FAST))
for _,candidate in ipairs({
type(crypt)=="table" and crypt.base64decode, type(crypt)=="table" and crypt.base64_decode,
rawget(env,"base64_decode"), type(base64)=="table" and base64.decode,
}) do
if type(candidate)=="function" then
local ok,result=pcall(candidate,text)
if ok and type(result)=="string" and result:sub(2,4)=="PNG" then return result end
end
end
local alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local values={}
for index=1,64 do values[alphabet:byte(index)]=index-1 end
local out,buffer,bits={},0,0
for index=1,#text do
local value=values[text:byte(index)]
if value then
buffer=bit32.bor(bit32.lshift(buffer,6),value);bits=bits+6
if bits>=8 then
bits=bits-8
out[#out+1]=string.char(bit32.band(bit32.rshift(buffer,bits),255))
buffer=bit32.band(buffer,bit32.lshift(1,bits)-1)
end
end
end
return table.concat(out)
end
local parent
do
local hidden=type(gethui)=="function" and gethui or env.gethui
if type(hidden)=="function" then local ok,root=pcall(hidden);if ok and typeof(root)=="Instance" then parent=root end end
if not parent then pcall(function() parent=game:GetService("CoreGui") end) end
if not parent then parent=LocalPlayer:FindFirstChildOfClass("PlayerGui") end
end
if not parent then return end
pcall(function() local old=parent:FindFirstChild("WorldV2_Loading");if old then old:Destroy() end end)
local gui=Instance.new("ScreenGui")
gui.Name="WorldV2_Loading"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.DisplayOrder=1000
pcall(function() gui.ScreenInsets=Enum.ScreenInsets.None end)
local card=Instance.new("Frame")
card.Name="Card"
card.AnchorPoint=Vector2.new(0.5,0.5)
card.Position=UDim2.fromScale(0.5,0.5)
card.Size=UDim2.fromOffset(130,ICON_SIZE+38)
card.BackgroundTransparency=1
card.BorderSizePixel=0
card.Active=false
card.Parent=gui
local screensHost=type(getgenv)=="function" and env or (type(shared)=="table" and shared or {})
if type(screensHost.V2LoadingScreens)~="table" then screensHost.V2LoadingScreens={} end
local loadingScreens=screensHost.V2LoadingScreens
loadingScreens.WorldV2=card
local SIDE=1
local cardOffset=nil
local function placeCard(dt)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local other=loadingScreens.VisualsV2
local together=false
pcall(function() together=other~=nil and other.Parent~=nil and other.Parent.Parent~=nil end)
local target=together and SIDE*75 or 0
if not cardOffset then
cardOffset=target
else
cardOffset=cardOffset+(target-cardOffset)*math.min(1,(dt or 1/60)*10)
if math.abs(target-cardOffset)<0.5 then cardOffset=target end
end
card.Position=UDim2.new(0.5,math.floor(cardOffset+0.5),0.5,0)
end
placeCard()
local icon=Instance.new("Frame")
icon.Name="Icon"
icon.AnchorPoint=Vector2.new(0.5,0)
icon.Position=UDim2.new(0.5,0,0,7)
icon.Size=UDim2.fromOffset(ICON_SIZE,ICON_SIZE)
icon.BackgroundTransparency=1
icon.Parent=card
local text=Instance.new("TextLabel")
text.Name="Text"
text.AnchorPoint=Vector2.new(0.5,1)
text.Position=UDim2.new(0.5,0,1,-8)
text.Size=UDim2.new(1,0,0,14)
text.BackgroundTransparency=1
text.Font=Enum.Font.GothamBold
text.Text="World V2 is loading"
text.TextColor3=Color3.fromRGB(255,255,255)
text.TextStrokeColor3=Color3.fromRGB(0,0,0)
text.TextStrokeTransparency=0.45
text.TextSize=11
text.Parent=card
local customAsset=type(getcustomasset)=="function" and getcustomasset or env.getcustomasset
or type(getsynasset)=="function" and getsynasset or env.getsynasset
local writeFile=type(writefile)=="function" and writefile or env.writefile
local SHEET_FILE="V2_LoadingSheet_v1.png"
local SHEET="iVBORw0KGgoAAAANSUhEUgAAAdcAAACeCAYAAABgpEDRAABD+UlEQVR42u2dd7hkVZX2fxXu7W5yaARJIlmSCCKgRAEDimFMY06MedTxM6DoDIg5jGHMCqg46mBCxYQJQSTTRGmCgIKAItBN7L63qs73x1rLs2r3qXhPhVO11/PU07dv1a06tc/e613xXaUkSYgSJUqTlPTfeDgGt75xbYcnZbfuZV37WvCaKvBQYAtgW/13S2BrYCNgfWBdYFYf9p4NYE4f9wIrgLuBv+jjVuBG4Bbg9ozPrbhrarhzV/j9UYrgGiVKlCgTC6plBdX5wLjZAtgN2APYHdgV2BTYGFiU83XMAXcAfwP+CFwBXA5cqaDrZUb/rTuwjeA64Vb2jsD1Rb/hUdpKRQ/1U4C1gVPd76LkI2sDTwO+pYo/nqf89VXZAZTJQ4C9gEOB/RVMN8r4e/MgS4EHWQ4+I/wbnCebBK8vZ/wNwF0KsH8AzgSWAX8PzqN/zwiuEwqurwb+F7iPGNaaVKkiYavjgO2AF7vfRcnnHG0GnKQAW4/nKJd1tUdFvUSTzYBDgKcDByBh3hAU68F70AIIFyKJ+zdx4FsOXncL8Hvghwq2t7vnFjlvNskA9bFUJlG62xiHAN9XcI0y2bI9knciela5g+umur7RYMlnTav675yCzzrA44HnAocpwOI82QbN4eLqkK6zlcfrPd0tgX/Vx+3Ar5Ho0a+B+/VvLGw89vsngmt3G6OinsxDkNxB9FwnUywctjmwVQTXgcmWur43E0PD/UqYS91RAfX5wC7udTUF1ar+TaUP5yIsMEq6ANBSFx5wyV2PedE1vdbNgBfq4yrgmwq01+vrKzQXQUVwLai1va5u2PUGFDaJMj7gioLrhmpM/T0aU7mBQQPJ9S1xZylK954fDozMc3sM8G/As4EN3D5u6GsrTs93u4cT9xkzC9B38+6zu3mPigNNA9uy7pn3A28Fvgd8CbjQebI+vD02YBvBtfvNtjawDXBuBNeJNqQ2VCW1toIAEVxzlbX03z3UI4mea/f7s0qaUz0YeCPwDNLcZY20taXcAaQ7yRyS57xV79PdSJvNg8AqB+4zek6W6NlZqg8zUOeQ1p1eDIhSgE8NdzaPBl6B5GX/G8nRop9RH6ezGsG1s7VdR3JEqAcbZfLBdan+vDPw5wgAucrefSj6afdWq+oFzun6vQ34FwW2uj6XZ/60psB6FVJ4dkOPf78YCft/Cniyvl8rwO9WD0NzzviZSFX/d4GPA5c4sJ8fF/CI0t1mAclrRJlcQwpgJ9J80eZxWXKTRNd0Hf3/XnFJunJ+KgoWmwGfBs4Bnqe/N9CayRFY5/T9rgSOVGC16/Bh5vDhPebVwHVIlfIn9fmG83YbfRqrFb02c3qqwAvUe/2krtE8zaHwCK5jbj1agcD6TlFEmUzZ3J2L3eNy5CbWdrOH/v8RTtFGWVPvVJ1H+jrgIuDfFVwMVKs5RgAaSLh3FiF6eCrCsORbYOqkRUfhox6AZll//x/Am9x3quW0Pgbm83qNb9I1eo3zvmcYYYQkgmt3sp3+u0ME14kXD6i7RADI1UjdAAm5Azw8rm1LnWxVwHsBPwc+izAqzdE+/Nsvq5F5lYudx/pn/f98HzrPV/HOqMf9bKSN0UhZ8sKeGedxbwF8XtfsUXrtZUaEcxFcO28SkEImkOrRxRFcJ/peb5Hhxcb7nQ+4WqGLre1mwfPTuja+gMdA6Z3A2UjP6rwC0kyLfVsjrQ4u00zOkWSAnvdADQdm9fMMWGeR8G6Sca3GAmXhaAsLl1pc2yLgNCRHejf550XtWuw7HY6Eio9x37masd4RXEe46a3v8WFOIaxDmj+KMjnSUCWwp/vdw0mLm+JZWTi4bueU3fqk9HvxLAmY1ZDo2M+ADyCV1QaqlQxgMJC0HtbvAj8hbWeZpzlsa6Doc6erkTzuq4EnIL3HFpLO6nEt6fU0Mt6/FcCu1u93FlIgtXIARmvJfa+art0HgZ+SkpbM0JqKMXeJ1cKdvZkKwioDUi28HfAPZyFGKb5YNfDGpOQRiUYpNqKZ7zRK/+BqxWKr1ZDZGcnvTXM1tq3NHEIC8T9IhMwAqZxhzCdONwGcjlTm/kpB5WTgWRme7rwC2y3AZcAF6uFdrs8b4NaDa/NesLUDbaUe4qy+bhlwvjMSwvtpLTnnIMQQP2AwdIslmguonqge+RuQHtkIrmOy6Y0LdTPnvSyJSzPRyt+scgslPRJYHr2rXGTXYM13nPI9Z15WBSFJeJc+t9qBVqsoSwm4GAkf/9Lp8weQauK9kXTWYgeqf0MY5m4LwK/svN26A9JSBl7MA0cBn6OZq3g1wsn9IdJCq9DzteKjn6hX+Z+kjEyDMJhn9Lo2U6/+BL3GemBEDCTtE8G1s8LdQTeoWV6PQEilo7KdvHt9CGmVo8mjgP+L93tBYkpsF6f4APYZpHIb0z1m399CskuBryBtKwaa7Ua+ea/1OAXWGeepGahdrI9W11J2r23VGpPQnF9djfTXfst5qD5f/EF97QdISR3CnK8VGX0ZeAuSZmswmLSLraUZDe9BChaPBu7U5yy8PRB0j9L+MGzmrEVIqxyjTI7YvT3I3ftSAACxqnXhESDrbbVw5m5MZ3rFgGoH4AwF1tV0V2xjodk7gUvd+jUCQyXsSQ2ZmxK6qy62iN1qPQsn63utprn/NUFaed6PEO/PsSaPcSk4S7UMw6MfaTdc3RsIqxBGq1+oHrfvMJBQcQTXzrJD8P/tp8janhbl31APYk93Luxs7I3kYhvRe+1LTME+mrRAp+wM1W2nRBeVHLCuQmaq/pa0ZWSmR0PwTCR3WmoBLmFPqu9DTboENQOlBGmjOhnhhM6qXLYwdwMJGe+uAFsOgM5kU+e1LgRQG84oaVUlbdc3S8pydSawL0LnWCWC60jk4cFa+VFkUdkWX+y+7qEKpB4c1vVVAcbzsjBgOTjwJKx68zE0D/iexO9eDpT7E5Eq1i3ovoo1CYDxxBag1a+3l8Xtm7hz8H4kZ14nLbQKjSgj0d8Q+CIps10pWAsD1+oCnBQ/F/ZeUmYmC483aM4b22dbuHprpB/2cFJWqgo5tupEZdHZQtwhWKsdgYcS23EmzaN4Uoaisp8P7NLSj7KmmDdxQHCObC2fSvuw3iRIQhoKPgqZC70B2aHTdkBiQPx/SGjTF+XkcY04cFlLwb+C9L6+qsvrtYHt+yOsSXWax8olgZOyEHAtIVXPe+vnnUhztXDS5hpX6T34IdJ/u5qcGZ0iuLa/eUtIK+LK7nebxuWZKOU/i+RiwjNhB+0JRPL+fvWLDUB4ZIYnYYbLEhcxmESpqjI/CplJauHxbsORBqCzwHcQir9BT3+pIFNn/gJ8g95mwZq3e2QL4Ibmlrdugd8IMKwIKUHCu9chxVtHqyd6DilNZNLi/YyzebGu6VP0HlXyWtcIru2VwkNI23BKbpPvFNdvIsQO0t5ILj2sWvTP78Tgqhon+RwBPCcDQK0QZ0tVwiV6H+Q97hGRqgLiPBIK/rYqc8+m1A5Q6uoFGji/FemFXeHAZhBOBUio9c0IqcSGpAVX7f6u4a65QjoOrpQBpA/JANx2XnvDAXxZ17Gs+6ek/68geeyDEMpFC8PXAg/fiDAsjL1IjZ7DSfPfC/Zio6JofTAsdLGYNUPAu8Ulmqj7/FxaD1q24o2nxTPT89o2FFRf1GHtXk0zH+0kiFX1rgYeh4RyzcDoZg9Z7nAWqQp+PDJarcKaxTuDuPYK0g9rnuAS2resNByArY2ErT9KyiUcytIersVaeC5UT/Us/fccNTRmFEQ9m9WbEGKNRW08WDOgG86D3ZfeCswiuPapdMPJHfb7vXsIaUQZ33tcR1i3XuAOWqszcjRpOC/mXruLCjSQcNuOLUDFQu0H61lLJsh7tbzeDuqxrk86zaYbYK0oMHxV18fYjxpD0jsNBZiVyOzU37UBKsurWiX0R5A0y4pAT3oDdu0ur8Pe+7vAfsChuh6HInn8owNDwwyAWfW8P0FaWNVOF9SQHOyp6lQ9sNC9GMG1vezSAnR3VUsu5uCKrfwADkNCVK1A08KX2yOhPZis8OWgDJdEFdz7aF38Z8p2Fmnwn4QiwZIzGpaqN7Ql7Yn3PZAYycL9SG715UiI1gqFhgGs3lu0ntqnI+T7fnC7cQtXEEL+ryIh2XcoyIY9zP7+tuIubiXLHeD7AQJkePHzpNXDb1EPttrG26+QkmJsrfdsKWkoui+cjODa2lqCtAWjFCiNTfQRCd2LK3aoX9PD61/N5Fe25mW41HVtO+WqTek9F2HIqhXceLGWmgpwElLI5atsSy0Mdu8t3gAcgbSzLKK53mMUurAK3IPwFRv70ixp6PtrCEHIy4FLHABm9Zra972N5uEo7YwVFOBDSsWki/NtHuy3aB2i9ntxTr/LicH1lvrZCFGyre71WLNwyZ5bQlpKHkOExVT+DaS39VA6hyPtuUP1bxrRe22rU8zTfz/d5xgrwCdVGRb1XJWcsXA8Uh08R3f5O8vzXajRlHPpnC8clhj/bxk4Fgn1X6z36ksKqjfp9c92YQiU1DvEeYy08ernkOKoXvPyiTN2vtPlvrL87dNo5iGOnmtOygEkT7RxRqjKbu5uEVwL77m+p0tlYBa8D19GaX1+EoQ7dp0uz4gR2D9S17dvhTZisQKm5yEk/HU6V536/tUzgSc7oFpNPoVLpYxH2T26qQKuufvyUyTfeQTw785Tt3Bxo4Vnad+1jJD3vwjJ6ZpBYnNr7fOsUvoU4ApS0oledK7p620CwO5kIM2rIfEvdN+PHMG1i8U18EzaKN5Y1FRcr7WuXugze1DkpgCeqX9bj95rptVfUw/0EHoL8RrAvhsJEedSsTlko2IeiXZ9hjQU3gkIzCu8TL/3Xeqx1gd4nVUHrBX3/07GaOL2/SpkxJ2R9/dyvXbm/hfpc/4B6XCAirvGRUjV8VtoHiTfiwFtxsmRPa6RteF9Dhkz2m0xWgokSRKxIUOJ1pCY+ytYcySSba5LFWCTCLKFMpxMqVyM8J/2ApL22iv03odcrdMOrPNIXvoLDlj78TLuRYrHznfvWwS9UUYo9Q7t0jgwr3AV0vJyHmnLS4P8CiZLgQETGpoeVBo9vKcnakh6uI7EAegcKT3mc5B851LgduDHSDGSFXmFxVHdGGwNhGLzLKfHuwVJu4e/QRjckl4iCRFcW4e1LkGI3Fsp33kk73oLkb2naIbTCeoh9eN92t+8DwlhVmmdM5omg8UKmD5PmmftJ2ViHt8KJER6Hu3Zdsbh+88iIdxjdV/MdekN2l66iHT6kvcuGy1AttQCZLzH5Y2VsvOSN1an4QikPehvCAXgN0lJ7LsFEKtB6ZctqsSac2RBWmdWudeUetCvZffd7WyehlQ79zo71iqmZ4FjgA/3YuxFcM3eLFsA1yC9WFkxfjsURwI/o3MVWpTRi92jR6tHlPQJAH4Sx76qGKf1/vvv/VaENGAhwBoC7ErgtUilZ6+e1bD0heXn9kKKbmbpfhCB7aXVSD/mL4A/I6xIifvO5TYRksRFDjoZIEfp52yX8dzFSGHSFUPcz+GMW0+OUcrwtHvZl9a69Bykd7Xfoez+Hh0ALOt2fSK4ZiuLZyB5gFaejd2oD6i1Ou3eSxGiESAht/OQfPpCqAztb69EGtsfDDyFaVhPGyq/IZJjfUlOwBquMUjV8Qmk8zcHyU7Uj+dVAX6NMDH1Gg2pB2B8N3AtEsY8A/gDQmjgdVToKRoArEvK1XwzcL2+/84aVXip/u1ccI/mEYKUe5B0x58yvOJBg2uS4eT0K+ZdbqnnfTO3dv2CawU4Gwnf17sB11jQlH2zD+mwuex1jxrSJoyysHtqYaXPK7DWF7j3LQy6m76nnyk56aDqx3o9VT33l9BfjrXTZ1m48FiEIWhP551VR7zeJWdUv1aBtZ8e3Yoz2G1c277A24BfIumpjwKPVdCwGa1192ggxVAXIlW431VQuUof5wIvC8Dcj1Vci3TQ+e0MfiiAB652o+988VWnnlMzUBYpsBq71Rb0z/zlPeh5NVz+jeYq8FL0XLsHVvNIdm7j3dii34W07Nw5xA0Zpbd7akD4ZYQqrd/wEG0iGF/RQ2fAM0n7oOzW0L7XXkgF5wudwh5k5XTNeaz/jZCy3xKA0zDX3bMwbYGEVJfm5LCERPVl9/tL1UP+vX7/eWS6zMuAZ7t7EXpp3vvKulfX6/490xk1yQjPrPde7TqqNJNOJBlOouVCH4r03z41x71p++tO3f+3ZZyLCK5tlEgDaX5f3sUNsc3/FKTvK+Zdx+9+mmX+FeCVOQNrqPhPVPCuUFwS+rAXMiymeQxCiP489z2HxVLmDd271Vj6DBL+9F5gidZ9lnl7rfNIq8ZrB7S3fPtLKXh/6wldHABLqYUHiPOsL1MHYjckx/s6BYtF7p6PUpdZWHcJ8K/qkV/Zxd9tjLBIvQt4GPm2c/l+5C/oPa9GcO1OLMRjFY+dDos9/yHgncS86zjeS2jdUjUIgD1JQZwx3w8hiELrnu4dkKrd55AOPB+Gt9pK/OeuQHotf4CEUO9o4XV7oMoDdE2pWhFTVugyb8kC2oSU4KCXvX24esC+KnfWvdcwjMMSzfnjujPULIz7NWSoxv0KsD9GctHmhS8BNgIerobf40jnxOZ93hO3/2pImH5Zu3MewbX5ICZ6WB/fhfKw56/UQ1YLbkKU0dxD83K2RsKHT2ewwBoC7A+BNyJDpv31jErCPGi7YqAywmSzB5LfPEAfi4K/z6toaSGKLqSg/Icq3rORHOOf9HfdrEtCb2Fli1KdNsT9FXpQCWne7179vncgxXVrIbnbjZF2m1kF0RuQauFvKbD6Ga2NEezLekY0wDzXE9VrnSOlxPRnrRWhfrvn8jzn31cvOYJrF1aUEfLfgNC2dUOzZa95BBJKjv2uowPVstvkr9CIwiZD9rDss+5A+uJOcp5OY4z2xhKkgnJb/Xdvtf530d9VMxTKOA4z9x5WeG13ApcjIdCLkH7OGxBqwYXcBwOFg9UQH6Qib/Wd59TgWYmExr8FXKe/99e5rgPX1Uie1oYDjJIAxfTkPgi94EXqlc7pcx9CCrpWkc7TbjiPNgn0r+VhB2n0JYEh0lAn7GxapASLyN85SCvqcAXWbhWy0Xg9NYLrSAyisjt4DYSb9gSknw+GH7q0fbSJWt7PQIgmLnNKpTQkpWYG45OQ/NP+qmh3VY9mow77OnFrXB3jPVDJ8D4r+h0P1QdOKd6qSvxq9fZuAG5EQny3dLgvvpDmHc5ryRNcvcGQFWZuKLD+FuH1vcrtrap7TYKEzVdkeIejNPRsDddH6A930N+fq2t6tkZPwsIlHwWyc+9D8aUMEMz7uv09qqoBcHbwmUkYRpt2sc14dLhAXVhgIM3XZWJB07CUqeWbrA1hTyQEfJ4Ca53RDd72jDNH6TV9Wq+x4a6tSr6tK60s7ZuRAqBL9eer1Kv7E61zwlEvZO89A6bHAU8g/+lIdfUwrXe2TDrDtUY6o/SjCD3kVeqFlt1rag48S4FHZ6+xPTgqrzVBujG2J529uj9CovFcpN+2nAGePk/rvdRSCxActBH9JKRtymYSN312DAs3VwlfQZpf6vYmmQV4gFpfsWo4P2XWrnJ1CcKQ9WJkPFRpRN5qJ2XpPasfIRM+fkpKPIFTJHkW3XSjIB6GhIE3RZirHonkWzfO+B4w+lxrOy9v0GFh6/GdR6gCn092PnAh38WqUU9Sz/Rtej9s8PgsUq39adLWlPmCnWvTj49HwurmiRrN4IPqbW9K/yxqwxCrRP6G6qA1CsEiuKahHeMF7bU4wV5/MpLri+DaH4iWA4MlSwFugjAiPQXhRt02AIBxPIhZxTc3INWtP1HP9o4WyrycEV3p9cCGVaxJh/25FKHH2x9pmj+ItIdzXNZ5FAVNpid2RELIi3OMjviWprcBH9PfPxwhjd9G//8O4CP62XVG3zKzEHA9ECEGSYLvb2s67sQspp/uR2oWrieIXkZwlZu3SA9MO+KIdgejpNbWNkiRQSSUyF7ncg9KfpGC6W66eQ9Q72ppBuAUZfRbPcOQ+Id6Vr9HyAiuVLBd3SUw2PsmfdyPMF+VZdRsoobMM5GahA1GHCEYVSuO9V6+Tw3xvCqEfbGYeaXWu7pKPdePqyH2SVKWpqLWdlikcE/gAtLiqiKmItoO8Zh2cLXFeL6GevpVGPZ3r1APNva8di+bAJsjhQ0PIc3F7IwwrSzOWOuE4Vdp5m31NsiuwF2FNPQvV2t4OfB3pBr0Nv15WJGE0ADaCngDwuazofsuk04iYcbHumqEb5vT9zaAbuianoSkO+bcHg9HxA0rbTDI/ZUgYd8r1VguKriaY3WdOgD3esdq2sHVbuiZ6hn1W6Bg4LqcdEZo9FybZWvgMFVQ++ih2gFpBVm7w9omDL7UfpQHtEEzj2kruVfB9WqNkFyoYalfIxWvg4w44IB2S6SX9y2kk0sGWVE8avpDC2XahJWFeu2+qO1vSCHl6UjOMYwelDP2CgXXL2bAnYWkH6zroohn2/bCs5De13+mBae5KrDiwhMHBge13/faGSn9L1KoctyBJ/QeplmW6L7aSj36TVUhzwxwjcx79cxAtwBvJx3fN6hJNYlTvOfr571dP9+UcX3AxqyvSP3XPoHNvkfNKWMjHHmcAuuMeqy+2tcGJNQYfZXvIHTvD2ku5qtR3HqV54V7Zpo9V4v9n4HklPKwRm0s0UHEwqZuxYeFN0GIDPZECkce0sKLKboX20tY+DYk7HQdUgF7y5h4HuaxLkLyTce671bOaY3GYeSc6YmtkOrjDfr4jp5RCeAc9cC/r/+vMng+5HH0XNdFquf3QyrUrfVotkDfxSJOdyNRy7/anplWcDXgO0LBNS+FYAD7IqRBOuZemw9ULwVNGyC5rV00srA/sFNw8AZNdTaIEFIeBU3hdx5VGsKTpjwf4eReP4fzNE7D0u0MvxIZADFHSjvYi/JdoZ7aKUiVrLXd2DloNxB9UnWwRfiWIuQmnyftACjKmfbRlZcjY+6qQG3awfVsDcvk1Qxuh+R6pMq1NkXW6EKt2E5gUUJaRI5AKNMOIC12aozxgcyzFQfGr0rUT4jZD/hZn95dCKwrkIEB5ykI1UZwjryHfhrCIzxPd/lB37d6GjLcY3lgaDamXDeErEYvUKdknHrVu5F5d5+fadGVaQRXs0RfiDQA530j7f3eiXBkRu914aCb5eVuh7DkvAyZiNHKMxy1pzquJBJ5i7Wq7Isw7azbh8FjhsO9CAPR+e59R2WEN5Cq9WVImqJbo8H24nKkknQVEkIfdI64qDo5UYfkQufRFyXtY+f8b0hK629AadoKmqxMfynSjD2IG2gW6bEKAHUindxCPL5aAJo23utPSBhpP4Qy7QJSyrj6GFy7HbhVwP8gk5OeAXxPgdXTH/rvWVRvxqz384FX9eGZ+QHhrxoDYDV9kajx9pAujeTEea0l9bxXIcVo88RIViujqg48oI8i4so8UmC4j97f8rQpfbNEP4gU0QwC+OxArgN8ieENk54msG04oE2A7ziQvZzRDiw3Q6CCTPrYD2lbuZSUQq9Ec/XnpIgB7KlIY321B0PH8lbv078fNbB6OSw43+1A1SIui/TfH+jzqykmo9KwwLWMUFNeR+8jAMcBXNfYK9Ok9C13cjBSnGCHeZCf9Xjg9Qx33uM0HciaW28UZPdV44kReLF+5NwrEc7jy5y33WDyQ4I1XYMT3Hevd7FuVX39Ce78jMt32d/tp1IHA/BGpObiKoRx6Wek1cBRWovxC5/iojlF8lxNBz1Wf56anKuFFNdDKjMfPgSP0o9C2x+pBI3tOYM3oGx9Hw18Acl3TfOw9FHeh0MQekJvALUCVxB6xTPH7Jxsr1GHtWmfRjLD6pmkhPQPINXt9XjuuwJXkGrzZQjpTJ3iOCW2N+5F8q43TIPnWnLW84nkR13WzeeWkPDWNxXYi5SkL6J4ooOLVFl/ncEXlRmwnoTkVf/C+A1IH/Z9qCpQntrBEzXv8FR9fS+h5GHI7gqsjS68VoC1gPtIp7zMR2DtGpwqSL/of7EmP3tSkH2/LlKYNRVhYRsT9S61KmsMr8zbwpI7IiXmDYpL81WkQ2r3eAXwUjWqBgWwBqwnIqFgK6qqxftACQnzzpFWQ4evMeKAExjPgReP6jH6sNSd7zli8VKvZ6kCfA2JAM24czTuOtOHsh81DeBqCvUZCMvLMIHVg3sNeCrwCdI+uSiDtyKtgOhohAAgb4A1YP2KfkZlir3VVlGEqxHShCwCCIsg/U5fVxpDL2+PHpX7lox2EHkleBRRx5eRARE3UqxWxtK0gKvdlF0Rhhc7yKURXsubgVdHgB2aGNBVkKkjp5Bf2NFCn6foexuwRk+lWUmWgC92eN0XGa/+ZJN1kKhTN+Bqzz8ieK3/XoOYT1pyQGoFc/5h+7/KeM9HNYPEjOJbEKY7a82ZL8DZsvu8HbDWpBY0GZg9Aiku2JzRjzXyTD2vUYUyTu0Gk67kQXoNz0NyIgvZD/a3VyKtNg+630dpVvyJrvu16tU1nBdrSnRHXcNxCwvvqPtlQ7qrl0gQOstHArfTHNYcRP7QWn5W6f/31cfmqlduQPq/r9LnwwlCpeCaSjlf30INhhoyLOEUmqdGjbOBUEI4wPebRO/JAGucgNVbsHWkitUs9ujxDMeDrSDj2V6OEBQk9FdgljhD6eX6nrEKvPVaVRQ4z0b4h5NAgZ+tz4/jGm6NVK92ezZryPCJ9wCvQ3KuOM8yCQzthQJZSYF1H6T97CDS4QAmq4A/AJ8lHRRAC32YtPDSR6GbLDL0bYTm9GSayVnGGWA3BLaetLBwFrCOE0OS5xT9ApIH9sO/owz+sF4EfMAZNf0C9Qf0vcatunUcvdcSMlaNDHA9nfENVz7cnddShoEVgo4VT74Wobg8Aqkerevvw9FxC/nOBtZ7q647jDRi5x+LkX777wHfRZjCFtE81s6M+7X19aXg3o0CoOzMLkLI8F9AymwWrqX9Gz6GPaqv5HT5NpMSFvZhhCciLRGbM74E0D5E/BWk2fwBIg/xsIybMtJ3vHuPe8Ree4UqtUaMOnQUA6ftgT/SzBs7j0w9up7RTLzpJO9DaEzDPeKHKJQc0JVYc1DDDQhr2DVIqPgBJGz4G6Qnsl9SEVuv7yNdEKtIB1mEusaMv6p609fqtVgofpE+tkCmM70sMD6TEZ9Zm3W7nzolj+zjfeYCr35QRoPtleMnAVw94fnzETJ+n9MZZzG6uHOQlpE/Mfx5ldMmFn48FJlMQ4/ginokvyWGg3s9p1cjeUyrsr5Wo0zjmqv+BjLgIyQhCQHU6xrvdZXa7K3DdA/1wyJmIL6xGnqb0Tn6lbjv0alf9yAF2VFNI8oCQPNY11UH6uFqDCxFeosXO/Csq+FwHzIP+VdICudfh+Bw2Rp/reg5V/P0ZoD3Asc4b6IIYVbbvI8DzgJegUwUISrugYkdrt8ivK/PpjsGJ3vN9yKw9m3QXKngaiH6Kx1IjeNaPjRDyZtuWYaQHfwHEnY1L7bkdJNnabPveRXwdqT9yACjH9BJFFw2pnPIM3H6xnuyPtxtkYTFCCfAkc4oqrcBPu+x5y2Jc55Mz9+HhLd7lfv0rPsowyBl86Lm+Sy0V0MGaJ+twDpuI8e6NRDqSBj7Z0hhwmLGP3FfdPEEB5Uu9xykbSPxvvTugVwYKPsLM8BrnGTDjOuza78Ryau+QZ+fywBKn4aoIqQmR6gBXXH6ql+ZdXu33GH9PYhagdWMXpdNaFqsOvVJyCzdeSRcXHWv9X83OwRd22DNSUN2PXYdZfcdbc0r7rvNAOcioXi7V52MgdAwatBd3tbWeaNyAQ+pp5X7d6TUfF9SgogiKj1fSXgMUt13BGl4OLI65e+9lpFc2G/d79od8JLel1+TTrWJ0ptcG3g614759W7YBvzv1nN7A/BxBSaf0vFTnMxbXFujU7BmDrAfeQCZtpOnHi85w7Oin1EjLSKy4qx50kk/w9K7fk19sZIHPr/2dbf+CTL6sZvweSMwjMoBgHcDrusXJSzsC5ZqSEL7Q2phQbEInjvdlBrC8HEGkvN5B3Br4OXGfGx+SuSLSA6nm/DUR0gpLGNPa2/eB8jgcCugsf8zxmu5dou9ALDSGWlvA/4KHIe07oSeK27ffFD119uBm51uqwfeV4nmEG6W3InkFteiOQe8UEO/jhTs/S/Sh7wZQqgxq0bBCqQI7SL1CFe6vx2HIqhQzOP9BVLI+Gg1DBYF9zVxUYBbW9z7EjLbtxPerDPuBU0eVEGa0N+IVNfOus1dmlBlVEaq+j6MVEDfE0E2d2NmCTLqbHuyc/X2u+uRaRcPEgde97PWiSrpq4ENVEE/Qvd3aUzXcyVrDtyw3PtxwPGkecya7qFNHSAuQkZcPhupTLew8QxSaPNehJN6vs2Znsn4/ayCw9OQauHEeVd5eond6NUbkMEkn1dAWqwAPG4GkxkNT1OjYR3WbIOs63ofD3wqMBYsDbkH8HPSyuxWa7RiXMPCFi+3TbuOguoytRINWCc1J2kHpa4K6RP63d+ka2GhjqJyh46DJC7s9ZU2HpT97isIYUQ5Amtfa40CqXkEt+r/GeP1rGRcn+mb+wPDYUYNsHMQVqfzkKKl9yIkDx8jDQPP6bn+PFIv8mT9/XpIFewBSDvMLnrWy8HnGwi8013jIGgVw15R3z9qoeFtgXcjKZPnIy1B41hQanjxI13fHzicqek1W2HscerI/AO4yz1WaJRrCa3z5bZXquPkufoiJZOtEKaT5+pNNMtxmgp9svrm/ifwZD0YR8Xf255rqAdlg72z2GksFXE149mPWaS1Ph14CvATZJjFOK/nfUjI1YOXKek3AZ9WQ79Gdi7PwsJzCHPTlfqvp0Sc1Z8vUXBdqp49CtQHOQBPnNf6SjX4PPiWh6SP7LtZrrPuvsdn1QEaR9Ytww1b/6cpkNrkI4tGVN13NQ++pN9xGVLx3nCGdhaN5P3lMThwFXfALDb+eOBzSMHJMQqs01rcU6KZlHtb9WSvAD6KVEs3Am82FkB1J3ZArkFyMeFUFrNOL9bXRGBd2FmHNM+6fIiAsNDzV+qwhzzIhA+b63oHQuVXcnrMh4L3QsLKG+j/VyEtesc6z7iiwPpQBYK605/lEayH6e9Z59G+HvixGgnjVgvTcMbIjHqxjwX+Ux/HO13ri6UMkA8Gdgg881LG+oxkY5cC5d9wX2B7pGfsEqQi87W60WoMtyJtnJWTB9mtgbeqAfJD4CWkrFQ1Z0FV49p15VGdEVjm/uczKE7v9LjLsuDfohhhofRS6WtG2pdJq4TrDphrCprzzluqqvf3F33Naj3HT1CQ3oLh9Gv24hVW9PsdpsC10Zidm8TdTwutr0Iqo09QIyGrnsL+/zya57a23SuDtCp8z5G38LxnsA1wCMKC8lgXgvFN13E0W7YHYGs0q+GNpyEFGKcjjCS/QIomasHfWigj0vY1H5yzMyzRUvBcXK98gCopSASgkbEnbA8s6fF9KkhY+I1IrrWVXpt3eu8mpCL38Qij2JOQSldYMxc7Ll6+Adb+wHeAo/T/41a05sfb+fbOrO9URyqEj+zBoKlXc1zUrBLy8BBtgvSkHqAhj0fTzIdZo7mvKEp7kC0Ha7y+GiovVKC9AiGmOBvJKd6TsYEqNOd0pq0StuE8qRWkYTlbmxXOy4oh4YWv81W6364qwJquRuj2smRJFwZXEnivVaT1q4q04vwF+DNSR3EdQn/6MQWmGjIX9DLW5DU2z3Ycz6m1Ws2pUfBxJAo5bh0OXs/NtfkuxqL1ZMWvuQ4OnwHvqmqPi1YKvCfvASUZyn9rJFm8j26YXfUCw5AJzoKI0vtmrgTWWEmB9gB9oF7sMge0y5BqzXob4A4P9CR6b1aIcidwqUZSGg5cL9XnYr41H1mJEDCsLMC13o/kDrNk/T49pSpS9HMKQtyfZHymnTnTufOkUcBw+Pq46iSbUHY0Unx5IcWkDLU1Psrpim7W/YFqBw/UK1evYEMlsyES4t1GwfRRwM5Ite+iDDBNaKapipLfRqhmGD4VpAjioaScoSudxbwMKdj5I9IicW8bIAnzt5Pg8RpwnqXg6r/HWcFroizMc/07UgX79wJ4rve6awxbXjbo05CzXN+9NLfS+a4AX0UcOjNFA6UqUoR5YUH1wrzqzYMDA6fdPq8AK6ttXOWsD9pSPc8dkYb6nfSDt0eS11kSwXT0Hm0ItmW1vM0Qeq67V3doeOoqhJ7uz0gLyj/0uUkkq7c9fybSs+fz2mdOqMc+SpC9vSCGyl1tQGPjPveFtXbZeas53WjTXEq6776kIPwA8CqkoKabIRPjcJ6MaP82JFpWxILKKpIaeBZp9XO3+HW3v0lrK3Cug7CMbKcKeDcF0K30sXabN/RAWqL9yKUoowdbn6+15zfTx+MChbhCvY1r9ecrkfDejQj12yoF3/sLDK7XkJKVowfrmgiuucpqpE97dQGu9Y42z21Bc59j0sd+C89iBekA+ATCee3nsH6mYAaUta+8FomGzRTMMLe2p82Qvt1OnMShc3p71W2M3ZGZdw9FeCU37/BGdZrpo8pMJhXhJIOtz99YyKpB8xBoC11tpI+dg/e5HalqvBw4GWGmGVc6u07K4E6E73V7/f3N+rtO5fdRepPLC3KdN7r9UcnwXDdWAM5D5xlIX01KVrJYjb3nIkQn8wVxVozt6LVIm+ASuptEMy5iUYR1EH73remupcinU2/yFWdG2WUv2ky91F1Vqe6u3qyFgdenOS/QyYONoDs+Xpp/GIh6MPWH5G6E1u1WJEd7uf7uKj3sN2cATxG9vLJaqpc6cL2UtL8wzm7N17Arwh65KQBU//NGSKTvjpy+T+IUuOcxrpPWSVAAPWo55S8CXyAl+y8SsJaQttBvIz27q9tgXSu5uZqBuqZ0b9PfX5/xhxshfT/bIGHjPRR4d9ANl2Vd1dzFxzab4VuSBoCt2JvuIG0HuBwJ+96EhILv6nJTFrmoydbkr+53fy2IQiuigVcE+Yv+W8kAkMVIoc4fc9wfWednlpSeb9zJYBJniH7BRXyKFPWpqNPwfoSm0xi2ul1304M3VVvc2Ky2G29dGZHxcmRCgMkGSNHTrgjp9J4IrdcWrJmE94n8qLzy3+S+H84bNImCxiXqmf1RvdBbkFxqK+AJ71Mj2DeTEja9osXPUaZPbkSq6tenmTzAwsQ7IaQtg9BfVp2+NmllclH05INIAWTRjG2rDt4JaSHqtXjM9sgK4MZqFxZUK9aKkDTCil5WqNdjsg4y6WFfhIR6P/Vwq4ElSATaXADVrC9vbV+HhPzPAs5XpXFfBxANw8fTEha91e39W+O2mmq5VUFi/Rae924D9sRLClQPkLLbFYE3fAkSwbylYPfb1vVIxa15egv5G7jeAdzab0l3K4skq0jmPvUArkCmOMyoV3uEgu3ByDSIEGhjlXF3Us8A1HuQcVdnAb9U73Q+I/zhLfFpA9FQzDC5xq3LNW0MzCiTL3chqZHtaC5qsn93cR5m3nlkC7GuQnh630JndqBxACdrV3kEKbNZUbxXu87DgkhFqQcdUraIR3UAFxeGCD3gJqrkL9PHx5Aw8n4I8bwH2oTJntm60HWutwDUr6uXeksLMG1MOYh2Olh3IxXC9nORlEOU/OVyp2xDD2cXpJL0JgYz59cA9v2qIx/L+Pe52hrshQxRL5LXmiAFu/sGTmKv3/1yhnSTsvopS87iuwX4rj42R8ipXwYc6K7PCJanHWQ9i4utzdnAV5Hctw9jlt0aRzDtDVzvieAaReWSDO/Ft2rsoeBaGtCeLKkH/SzgN+oR9kJmMIxzU2LNnPRWBTs7xiF8FEIYMU9vk4/8HrkERlO1awBRo7mfsqzgcBISLj5Ef17lvK5pHQbuOYMtVHSSrtFB+vOtpAxYpWCNIzh0J2bA/VUfJWJl+7TLZapoQ8/Ufj4w2Dt560lrbbmddCDHuICWTyXVSEfmlZEWPQriEFX1+jdBCCMafayxD+NfwZgoDk9e4Hsufwe8UsMLXySdbF+aMi/Mg+qDuhZ76dr8LlizxhQbIHmBa+LANSGC67TL9Uh/t8+p+n1xIIPvg7bWn2XAh0nnpo7inNcDx8gM+hn3+DXCMlUpgC7yhblfQnrca31EBsxzv0H3zNgpDj+qzvKJVwOvUUD5kvNk60x2oUnDhX9W6XffS9fiarc+SQTU3GW5PqJMt8yoQXuBO5OhvtqNtOBpUPo0cd7zV5Ew8SIFgWGce++hWkqqjKRPbgIuBr4HfADJTz/RRX7GWUebYzKP1P88g+aisV68bvueF6i+ro5zYjxsz1kOvFotouNpJpuftMpi/51OBf7LKXsPqFHyVyIA52b8Lsr0iSnX3wIvZk0WpTrSh3oEwrldYXBpGPMUb1MQeDfwBNJ2kUEVfjacJ1dBKuhPQlr6/qJAH07RMm+2Nsb31gyEOeAdwH/oWlbpnVHQ3/Pf2N4pJUlhdIff0Ci4vl/d+ITJCOH5GY7XA8cquHpQjW0hUaIMTwHXkL78i5ECJq9nrHL3pwibz6DANaRfNB1wnBrecw4sBmFw2oSbT+pnrsy4Pt8fP+51HjY7fA7JsX6ElOa0HyPFDK6VCJvWjUClSGBkYVKrgj0VCZN+2C1Ykb25ujscH9bvdqr7vpMeBh83jyW2f0UxpfknpALUJr0kgcF7kBr59SEY+DbrdUaB7pf6/8aAPssKqo5R724lQhLhh3qY/jIu5HEGVjOA5oD3KLCax+qBtRfiCPPQl6k3XwEa5YJu+IYuxr160w8mzUPWCvidLOxytX6XY/S7VSkeN+ckSJE5kqPkD64N9U6zjDBryTkqw8vMez/awxczfZT8o3YGqgY6X1SDf0Y/50HSqWhF6UawKUN1NQ6+ALy3BbD2eh/t+/+UtAA1KVJYuJWHYYC6AcIA9Syaw6tFUOJlpCDgaIQ+skosUooSZVyUcgOZCnYBKYl7yXlsFX3uAIZXZGT6b1Y/ew/yK6pKnBe+HNhfATUpqPMCaYh/b2Se8P5qpJRZWL7adPhq4NEIG165qJ5rlkteUVB6NlLsZC0V4+zxNRywHq/XvsIZCxFYo0QZDx1TRoZbnO/ANgTfRyPMPjC8Aksb6H1m4EHlaVgci1QFF3mmcVl16ssRStj9aeZPWIgTZkbIeUix1z/7oSelh8/3gh4HPMcdinHcEA13E56j1zyNPbxRohQFXBsIi1yW92jn+d8YbmGlgen57lry0k9V4FfIsHPrqy0iuM7odb8EqXJeokC7mDUHnPQbPQCpj/lnSBig6GHhVtZcXUM0pyJckePUrmPXchtS8fx74jDuKFHGWUyBbo4wNm3MmnR/IENK9kR6P4dR/2F6Yx/1nMrBdS0EXBOk1ec3pCHVImJBA6EzvDTAgjwMEQPPO/S+3+bBdRLZZ2ws0++Bw/ULjwt4eWA9XK+xGoE1SpSx914rCDHCjwJAxXm26yEkL3kAXC/K/TakADIvHVVGOMvPLLjhb0C3qxpGNt86L7Hanh/qPZgl2BSTKNZ/9scAYEcZ1mgEwPrHAluEUaJMq/d6sp7ZcMSceY0vBTbV11jv56CA1j5/BemwiWSB72d/fxLN6auiGkXh9yKH++Hfb073hPf4JxpcswD2PkaXlDcL574IrFGiFFLMOP6DenVhz6v1om8KvI7h5F5LTtfN5QRGVYR0/ycUvwbE7s3NqnvzNBSMjvJ3SM57jQjkpJOSe4B9Mc29YsO8wfZ4cQTWKFEKq6hNgX6WZsJ3AoB9HTLntc5gw8OezCKPcKfppNMRWsNqwe+ZOTU3qd5dqGfvjRqLSnyOFlN0pmHih1F3nQa8i+HnECzP+i69hpkIrFGiFFJRG4/v6UiBTGgkW6h4KcJXa2xKgwJYe9/19MECPsuHgE+jmcqwyGJEPL9x+nihAGt1PRchxBGZHv60jNOywbcfBr7N8IqI7CZ8m5ThZD7qqShRCguwZaS39KMtwMx6Kl+BUJiuGqCetc/eGlg/B3CtIry45zI5w0FsPX5CWqyVV+TyY6REFMm0gqt5sBVkss51DL7AyXI01+lnFpWaMUqUKM0GszGqXRyc65LTqYuREWzWAjioqTUA27BwbnUDh58jlcdFmMXaDbBaaP4i4PIcvpfhyAXA92nDpTBN4GoLeg+S+zTO3mRAn2Xv/2LyqeSLEiXKeIh5rycE593Ot4WLnwi8iMFVDpda/NuPGOj8ZMJ0vqXlVqtBRJ9GSBgiPwGJQrYE6/KUHQoL056PhHWqA/JeLcTyUVpUkkWJEqWwYuf7x8CvkXTPHGu2e9SBDwJbkrbvDMJhuEzBw/KkSR/vU0YKf/7gvuMk3S8QUqH79H71ukZWHV4FfobkWtvq9fIUHgyzZI5DSKnzDg9bOHg5Ka1hBNYoUSZLDMjeSTpPNfQE6wgr0EcYTGuO6bKrVeGX+gRx039nkA4OmaQomxlD16lB1E+LkeXbHwD+k7QSmQiua1p7q4A3k39rjr3fm/UzIIaDo0SZNB1iubcLkfFlWVGwKhI6fD5CGj9PwOKTE8ijhvwD9Menbv3/35mCe/dl+pseZFHPzyP5W7vfLXX7JHILdytmWf4cyY3UWHhfl73HL4AnRa81SpSJFlPQGyIFLttkOC1mbN+D8J1fRf597qZn3gx8Qo36RV16sKazLgceowbAJM4ztsEuIAMJDu4BZM1YuUHXaGXgNMWca4sFfyeSr1hoibaFfVbre5ai7okSZeI92DJwJ/D2FjrEvMINEJq8JeTPPWxhz08CX0MqlWtdXr9d79dVd1Um/F7VEIYtevDw7W/fBtzdLVZMM7haSf0y3VgLHU9nVtDX9T0XWhofJUqUYuiRWaQS9RSy5zFbteo+SFjRcqV56V+rZK0ArwXOIe2pT7oA5duBb/QIOEV0pOaBdYB/6QH/rCL4qwi5xmy3en3aPVezID9GWi7fr5hV9DHWJPWOEiXKZOqPxOmOtyIkDKFhXULCtDWE2P+tpMxxeXqvJeBBJMd7A53Dz6b/vgz8jTS8PIm6y7zNA4FdnHPVTuy+/km91rIznDpS6U47uNqGvBaplCvRXy7EKvTO0Pca1YCAKFGijE6P/B0ZOdfJAP+wAuBq8itwKjlP9GbgBQq0rSJyNkbvdoQreaGRu6LIkV166L5Y6dXAP3rV6+V4Lv6Z+/jQAtakHLxHzLdGiTJdYqHeM4D3kt0DaUU1CXAicBjSxpMHwJoXVVeP+HykwKlCdlVrI/BaizxarlsDqIyE5jvp+cRFFo5Depl75iqY5mrhEFxtes729Faqba+9XsMNNXeDokSJMl26xJTw6cCTFTxnAoN7Xl93p3pSFyJh49U5XouFeE9BWKKMA9f3sD6A8B9fx2TWiJQCwFyKUFZuTeuiskTXapHew6P0/tV79eyj55qGR+aRSjt6XER77dfoQIcVJUqUidclpg9eipA7zLLmsA4reloK/AjYk3xDxN5LfjtwC81VwOa1/l6dgkHzrI/yfvh5u5b7bifz+pqrkOELZfqkyY3g2gyQ30DyFN0CpAHzg0x+tV2UKFE6A5p5r3cgec+VNBNMmMK3YqPNED7ffZyXm5dOqwC3ITy4lUBvgbSkdGQamgCx9X8UMpqv1Zxdy1nfDbxQ72FHsogIrp03onFr/p7uE9feAryJ6SkKiBIlSraxXXcgeSkpcb+FG80gLzmA3Rzhqj2ElMWplMO1zKtO+gYp1asP/V5dUOMlfLTDt0W6Dk8G/q+F52r3pqH344UIX3NVf9+XRHBdcy2+3MfffjmuZ5QoUZyHUyPN272G1n2tPkT8Y+A5pFzFeegT48P9agYQPZhx3ZOkz43U58XAD5CZt1n1NA1n7ByN8DTPsMD6mQgGzQsM0oBtTCVJh0NkzeHnBO8RJUqUKHWELelkpE/Sip2SQI+UFVDXAr4NvJGUAGKhOtqA49sIKb+Prm3epQc4jsBZcY9ycP1V54W+CyH2sShBKWP9Gwqmb0YKwGbJIVwewbV5E5aBW4GzugBLe+4s/ZsYEo4SJYpX2nU1vqsIucyxpMxJ807Zl0hDwQnwKYTJyZT8IgcofnZrqcPne+D4M/BNmnv5Hztkj9XnpGcc/lSdp9kpzGuVuzX3MCCs6JrVECamU4D3k5JBzLjPaej7WOvSu3Td7f4smEwjgmv2evysi3BAErw2rmWUKFGydIQB5AeA99BcFVxizWHnc0go+ZfATqTc5/51vZDrm+PwUYQMYUZ/dxQya3Y+Z/1l38laf/zDwG+etIDIA2Qp473CtTkA+CIypOApSKGSgeUcsDvSm+pbkML3abjPPxaZu7uYHNuRIiBkH4Y/dBGSsabrP3QBxFGiRJluvVJTYHkfcAxpVXCoNyr63GqEqu8shM3JvLR+q4lnkaLL49z7bwK8m/yn4BiYNQIPc14/dyvgLcBvkWlCnwY2Jh3rFq6deZt1NU7OBF6FhHFPRwgzfgvsBrwE+B0yvcbam8oZ71nSdXirGj3WMpXbOkQSiWyraxYhlNiW1gnwMsLfuQtpFWCUKFGidPLmagoOnyMtaCqz5qg6D6ZfUg/rH6REEI0uDfuSA706UoB5tPPejlQvudLDe7b7LKtHeSSwA5LbXU8/f3tkHOdGwd9dBDwD+CspOb6th/UJfwZ4vft/meac8X1IOBjSebulQG9bGHgeoTU82X1egwiuAxUrV/9fpE8ta86r/e6bSNl2nNsaJUqUbgDOjPdVwNORNpl1aE2D6AHBCOR/4LzRGt3XeniAfyfwBuAhSEHmgTQX+yQL+I57KBDu28bT9qFomyx0hercK4PXbgD8D2mYtxS8b+K83oYD3lBWIaHfe5AK4h+RturkPsM2guuaYjmA/4fkKOotwLWiG/3j5D/8OEqUKJMJrqhCT5Cw5b4KsNuT8hNnAWzNge//IeHd5YFD0K3zUFZA2RJ4nILNz4PX9QMMdh1fAV5JmisO37fqvFvcWixGKpo/o570PEKu8TrS3HM18FqzrrnUZv2uU5C+wAHrQApRI7i23iD7AueRzUFpv9sPifdHzzVKlCi9AK1Vzc4BD0XoU49weiSLUanhwOluBaFPIRzF0Nyb2QpsLIdplK/+mhYKBuZkPEW9QkufdVvbkxUl9M/5MHC3Undr9gvgZcgkoFatOblJLGjKthJBRsetILsvqqTPXRv8TZQoUaJ0I8agNItQFD4FGUVnvZu1DDCuOFDcECnuuQgp7NnAgWW1AwA1SMOyVfrnQy8F15aoN/gT4B00h2m7BeeE5jYYy4VW6dyqkwXIFf3bDwFPRSYAzTKEASsRXLM3fVktw0szwNN+vlRfM+mjmqJEiTI4mXegcgzwLKSox7eohGKFR3PANkhLygVIKmtz0lBnpQPQWri0l6hbxQGdHxhuPaM22eceWk+e6QTYPlxc6QOnLE9dRYYWPBPJMZec4TJw0owIru3X5bIM6yYJnotrGCVKlF4NeB+y9aHL7yN50O87EDOwTAKP0RMq7IAQVZyP1Irs7p4zz68dpWInvl4DJv+ei4AlSOXvtsChCvC/QvpQF8Iw1Uv4NwmiARb2/g5ClHEaKTtWnQEUL2V+gZhzbRmeMALnb9BcaGA/vwipKI7FTFGiRMlb94CMPHsfkpOt00z6H4oHaBA+4V8iHQ2/QVp4vPdZcR5eq7oSkxn32l2Rvtv9kT7ZioLsUoS71//9sCgVraXIDIDbkLalk9311xhyhDGCa+vQRx2pVDsv8FAtTLMfMuQ4FjNFiRIlTyk7j/ZhwHuR1pFS4JlleXCeecjA7Wb1Jn8EnIvkHUN9Vwq8ag9WNfVQ34cwR63VBuRsnFt1yMBqofWvA/8J/IU052vfJYLrGIjdiE2Q3rJ1g5DMvcB2yLy/od+0KFGiTAXA+pFnT1SQfYz+34NsEugh+7lOcw4ThAf9fITl6Hykp/T+FtdgrEUbA6ciYV8LvYY8x1k6dJASeurnAscjFcF27b30AEdwHTLAVoFlGgrxzclXIXyWQw81RIkSZWr0Dw4c55Hw5ksRyr6d9PlVpPnUTt5dCLQJcCNC3nCp6rVrkLDqCv3MtZAe2AOREXVLRrgmdWcwGInEcoRr4KukjFZjoZcjuLYWC/d+k5TbE93E30KYRGJIOEqUKMPQRRUHLush+djXI+QTkFbAVjq8lwFtq0rceeDvSO/s1eq1Hk46hrM6ojWw725EGtcCn1VQvcd5+iP1ViO4did2o96ilpEH1/8H/DexmClKlCiDl3IAtNbPuiFSdPkqpDoYB7SecKFVwZJ/eL0XSs1dw6C7I3yI23K//pquQMbxfRNYqb9rRZ4xcgCJ0l6WB5szIaUdixIlSpRBS9hnb/zAxtJ0IvA0ZCLM4c67s/CoZ0nqNA82CcB3WMVJSeBZ2+eW1Wv+JcJidToSCjdDo0Ez09TYSPRc21uLDWBnDY94eYQCbByQHiVKlFHqqFkFH1PkuyMpq6erniIDtEKgHZWEtI4hVeLVwPeQftXLHaBWGSAncATXIayN3vANkIphG5F0F1IpvIJYKRwlSpTR66kSzX2rAGsjZBTPBB4P7JjhDfsB5b1y9vYLpkngFYc54muQvtzTgN8j/bo477kRvFcE14ID7FlItRzA2cBBEVijRIkypt6szYw1WQfYCzgMOBgZCbdhC/BrOODrF3BDEC0HHrOXu5A86u+Q0O8lDlDNU00oYIQw5lw7b9Q6wk9pckvwXJQoUaKMi4ThXxsifpY+ALZCwsf7AHsi4eNNkShdpQNglto83yncvAKZSHM10vpzIdJne3Pwuor7LoXVsRFcO3uu0JxzvbrDBooSJUqUUUvigMl7jg0Fs5uBn+rz6yGE/9vrYweEK3gzhEhnHSS3OxN4n0kA6nNI/vdehG7xNqSP9loktXYdQmJxbwtvOwmuu9ASwbU7ubHFz1GiRIlSBG+WNqB1jz6Wj/D6Jq4wNE506Wz9AdzkfndThtUWJUqUKFGiRM+1R3BdSdpLtTKCa5QoUaJEieCaj+e6OnquUaJEiRIlgms+4FpGCKtv1d89SCSPiBIlSpQoEVwXLDUk4W8/x1x1lChRokSJ4LoAMS/12ozfRYkSJUqUKBFcFyAPxCWIEiVKlCgRXPOVZXEJokSJEiVKBNd85f64BFGiRIkSJYJrPmKsJhdk/C5KlChRokSJ4LoAWRmXIEqUKFGidCNx5FyUKFGiRImSs8R+zShRokSJEiVn+f8nqU//ua5hKQAAAABJRU5ErkJggg=="
local sheetAsset=nil
local function pictureFor()
if sheetAsset==nil then
sheetAsset=false
if type(customAsset)=="function" and type(writeFile)=="function" then
local ok,asset=pcall(function()
writeFile(SHEET_FILE,decode64(SHEET))
return customAsset(SHEET_FILE)
end)
if ok and type(asset)=="string" and asset~="" then sheetAsset=asset end
end
end
return sheetAsset or nil
end
local function showPart(image,star)
image.ImageRectOffset=Vector2.new(star.rect[1],star.rect[2])
image.ImageRectSize=Vector2.new(star.rect[3],star.rect[4])
end
local WORLD=48
local PIXELS="RAAAASABABUABACWADBDaABACcAAABdABAAPBAABQBAACRBEADaBEADfBAACgBAABNCAABOCGADVCAACWCDABaCAACbCGADiCAABLDAABMDHADUDAACVDAAAbDAABcDHADkDAABJEAAAKEAACLECADOEBACQEBADSEAACTEAABYEAAAcEAABdEHADlEAACmEAAAIFAAAJFDBDNFAABQFAAAXFAACYFADDZFAACdFACCeFIADnFAAAHGAABIGAIDWGAABXGACDZGABDaGAABeGEBDjGAACkGDADoGAABGHAABHHAIDJHBADLHAACMHAAAVHAAAWHAADaHAACjHAAAlHAACmHCADpHAABFIAAAGIAHDJIAADKIAACWIAAAZIAABdIDADhIAAAmIAACnICODqIAAAEJAAAFJAHDJJAABXJBAAdJAABeJBADgJAACmJAABqJANDrJAAAEKAACJKAAARKAAASKBABfKAAAmKAACrKAACDLAABELAGDJLACDKLAACLLAABMLAAAOLAABPLBACRLCADULAAAlLAABmLAJDrLALDsLAABDMAJDKMGADRMAACSMAAAgMAAChMCABkMAAClMAIDsMAKDCNAABKNCADNNAABdNCABgNEGDtNAABCOAHDJOAACKOAAALOAACMOAAAdOAACeOBBDtOATDBPAABIPAACdPAABuPAABBQAACGQAACHQAAAeQAABfQABDuQAACARAAABRANDFRAACuRANDvRAAAASABBESABBFSAAAfSAACvSABBAUAACEUAACFUAAAOUAABPUBACRUAAAgUAAAhUDADvUAACAVAFDEVBBDGVAACHVAABNVABAOVDKDSVAACTVAPDUVAAChVAAAiVDABmVAACvVAFDCWBABGWAADHWAAASWAQDUWALDVWAABWWBAACXADBEXBAAGXAABHXABDIXAABJXAAAKXAABNXAABVXDGDZXAABnXAAAoXAADpXAACqXAAAsXAABIYCADLYAAAMYAABNYAFDZYAFDaYAABsYAACHZCAAKZCADaZABDbZABArZAAAsZAKDKaAAALaACBMaACDraAACAbAACCbAACabACBqbAABrbAJDvbAACAcABBCcAFDqcAKDvcABBDdAAAMdAACpdAAAAeAAADeAABMeAAANeAACVeBADXeAABYeBAAoeAAApeAJDveAAABfAACDfAACVfAADWfAAAnfAAAofAJDufAACBgAABDgADDEgAAAOgADCPgCEDVgAABmgAABngADDugAABEhAACVhAAAmhAACCiAABEiACDFiAAAUiAACmiAABtiAABCjAAAFjAACUjAABmjAAAtjAAADkAABFkACDGkAABOkAAAnkAACskAABElAACGlACDHlAAAPlAABQlBADTlAACnlAABrlAACEmAAAHmACDImAAAQmAACRmABDTmAAAnmADDrmAAAFnAABInACDJnAAAQnAAASnABCmnAAAqnAABGoAABJoACDKoAAARoAACloAAAmoACDpoAABHpAABKpABDLpAABRpAAASpAADTpABAbpBAAdpAABepAAAhpAAAipBACkpAABlpABDopAABIqAABLqABDMqAACNqAAASqAAAaqABCbqDEDfqBABhqDBDnqAABJrAAAKrAACMrBBDOrAACPrAAAZrAAAfrBCDlrAACmrAAALsAABOsBBDQsAACRsAABSsAAAWsAAAXsAACYsCDDhsCADksAABMtAAANtAACQtCADTtBACVtAABWtBCDhtAADitAACjtAAAOuAAAPuAABQuAACRuEADfuAACguAABhuAAARvAAASvAABTvBACVvAADbvBACdvAABevAAA"
local function drawWorld(holder)
LPH_ATTRIBUTES(PRESET(FAST))
local digits={}
local alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
for index=1,64 do digits[alphabet:byte(index)]=index-1 end
local start=(ICON_SIZE-WORLD)/2
local pieces={}
for index=1,#PIXELS-4,5 do
local x,y,w,h,level=PIXELS:byte(index,index+4)
local piece=Instance.new("Frame")
piece.BorderSizePixel=0
piece.BackgroundColor3=Color3.fromRGB(255,255,255)
piece.Position=UDim2.fromOffset(start+digits[x],start+digits[y])
piece.Size=UDim2.fromOffset(digits[w]+1,digits[h]+1)
piece.Parent=holder
pieces[#pieces+1]={frame=piece,alpha=(digits[level]+1)/4}
end
return pieces
end
local sparkles={}
for index,star in ipairs(STARS) do
local holder=Instance.new("Frame")
holder.Name="Sparkle"..index
holder.AnchorPoint=Vector2.new(0.5,0.5)
holder.Position=UDim2.fromScale(star.x,star.y)
holder.Size=UDim2.fromScale(star.w,star.h)
holder.BackgroundTransparency=1
holder.BorderSizePixel=0
holder.Parent=icon
local scale=Instance.new("UIScale")
scale.Parent=holder
local sparkle={holder=holder,scale=scale,offset=star.offset,pieces={}}
local asset=pictureFor()
if asset then
local image=Instance.new("ImageLabel")
image.Name="Image"
image.Position=UDim2.fromOffset((ICON_SIZE-WORLD)/2,(ICON_SIZE-WORLD)/2)
image.Size=UDim2.fromOffset(WORLD,WORLD)
image.BackgroundTransparency=1
image.Image=asset
showPart(image,star)
image.ScaleType=Enum.ScaleType.Fit
image.Parent=holder
sparkle.image=image
else
sparkle.pieces=drawWorld(holder)
end
sparkles[index]=sparkle
end
gui.Parent=parent
task.spawn(function()
local provider
pcall(function() provider=game:GetService("ContentProvider") end)
if not provider then return end
for _,sparkle in ipairs(sparkles) do
local image=sparkle.image
if image then
pcall(function()
provider:PreloadAsync({image.Image},function(_,fetch)
local state=tostring(fetch)
if state:find("Failure",1,true) or state:find("TimedOut",1,true) then
task.delay(1.5,function()
local loaded=true
pcall(function() loaded=image.IsLoaded end)
if loaded or sparkle.image~=image then return end
pcall(function() image:Destroy() end)
sparkle.image=nil
sparkle.pieces=drawWorld(sparkle.holder)
end)
end
end)
end)
end
end
end)
local function bump(phase,at,width)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
return math.exp(-((phase-at)/width)^2)
end
local function beat(phase)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
return bump(phase,0.12,0.045)+0.55*bump(phase,0.3,0.05)
end
local function setFade(sparkle,value)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if sparkle.image then sparkle.image.ImageTransparency=value;return end
for _,piece in ipairs(sparkle.pieces) do
piece.frame.BackgroundTransparency=1-(1-value)*piece.alpha
end
end
local started=os.clock()
local fading=false
local animation=RunService.RenderStepped:Connect(function(dt)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local t=os.clock()-started
placeCard(dt)
for _,sparkle in ipairs(sparkles) do
local phase=(t*0.85+sparkle.offset)%1
local amount=beat(phase)
sparkle.scale.Scale=0.9+0.25*amount
if not fading then setFade(sparkle,0.25-0.25*math.min(amount,1)) end
end
if not fading then text.TextTransparency=0.1+0.15*math.sin(t*3) end
end)
local LIMIT=45
local function stillLoading()
local downloads=runtime.DownloadsBusy
if type(downloads)=="function" then
local ok,busy=pcall(downloads)
if ok and busy then return "models" end
end
return nil
end
local finished=false
local function finish()
if finished then return end
finished=true
task.spawn(function()
local hold=1.2-(os.clock()-started)
if hold>0 then task.wait(hold) end
local quietSince=nil
while gui.Parent and os.clock()-started<LIMIT and runtimeAlive do
local loading=nil
pcall(function() loading=stillLoading() end)
runtime.LoadingScreen.Waiting=loading
if loading then quietSince=nil
else
quietSince=quietSince or os.clock()
if os.clock()-quietSince>=0.5 then break end
end
task.wait(0.1)
end
runtime.LoadingScreen.Waiting=nil
fading=true
local fadeStart=os.clock()
while os.clock()-fadeStart<0.35 and gui.Parent do
local alpha=(os.clock()-fadeStart)/0.35
for _,sparkle in ipairs(sparkles) do setFade(sparkle,0.25+0.75*alpha) end
text.TextTransparency=0.1+0.9*alpha
text.TextStrokeTransparency=0.45+0.55*alpha
RunService.RenderStepped:Wait()
end
animation:Disconnect()
gui:Destroy()
if loadingScreens.WorldV2==card then loadingScreens.WorldV2=nil end
end)
end
runtime.LoadingScreen={Finish=finish,Gui=gui,StillLoading=stillLoading}
task.delay(30,finish)
runtime.RegisterReset(function() if not runtimeAlive then animation:Disconnect();pcall(function() gui:Destroy() end) end end)
end,"Part at line 454")
;w2Section(function()
local runtime=env.WorldV2Runtime
local MINIMUM={3,9}
local MESSAGE="You’re using a fake version of Overdrive! Please only use the official loadstring located in our Discord server: discord.gg/overdrivehub"
local function parse(text)
if type(text)~="string" then return nil end
local major,minor=text:match("[vV]%s*(%d+)%.(%d+)")
if not major then major,minor=text:match("(%d+)%.(%d+)") end
major,minor=tonumber(major),tonumber(minor)
if not major or major>99 then return nil end
return major,minor
end
local function tooOld(major,minor)
return major<MINIMUM[1] or (major==MINIMUM[1] and minor<MINIMUM[2])
end
local function refuse(found)
pcall(shared.Notify,MESSAGE,0)
if type(shared.kick)=="function" then
pcall(shared.kick,MESSAGE)
else
pcall(function() LocalPlayer:Kick(MESSAGE) end)
end
pcall(runtime.Cleanup)
end
local function check(text)
local major,minor=parse(text)
if not major then return false end
if tooOld(major,minor) then refuse(text) end
return true
end
task.spawn(function()
local core
pcall(function() core=game:GetService("CoreGui") end)
local roots={}
local hidden=type(gethui)=="function" and gethui or env.gethui
if type(hidden)=="function" then local ok,root=pcall(hidden);if ok and typeof(root)=="Instance" then roots[#roots+1]=root end end
if core then roots[#roots+1]=core end
local deadline=os.clock()+45
while runtimeAlive and os.clock()<deadline do
for _,root in ipairs(roots) do
local marker
pcall(function() marker=root:FindFirstChild("@bubbles.elia",true) end)
if marker and marker.Parent then
local label
pcall(function() label=marker.Parent:FindFirstChild("Version",true) end)
if label and (label:IsA("TextLabel") or label:IsA("TextButton")) and label.Text~="" then
if check(label.Text) then return end
end
end
end
task.wait(1)
end
end)
end,"Part at line 720")
;w2Section(function()
local runtime=env.WorldV2Runtime
local bridge=Instance.new("BindableFunction")
bridge.Name="WorldV2_RuntimeBridge"
bridge:SetAttribute("WorldV2_RuntimeBridge",true)
bridge.OnInvoke=function(operation)
if operation=="Cleanup" then runtime.Cleanup();return true end
if not runtimeAlive then return nil,"World V2 is no longer running" end
return nil,"Unknown diagnostic operation"
end
bridge.Parent=LocalPlayer
runtime.RegisterReset(function()
if not runtimeAlive then bridge:Destroy() end
end)
end,"Part at line 778")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local runtime=env.WorldV2Runtime
local trade={active=false,roots={},listeners={}}
runtime.Trade=trade
local exact={trade=true,trading=true,tradegui=true,tradinggui=true,tradeframe=true,tradewindow=true,tradescreen=true}
local function nameOf(object) return object.Name end
local function isRoot(object)
local named,raw=pcall(nameOf,object)
if not named or type(raw)~="string" or not raw:find("[Tt][Rr][Aa][Dd]") then return false end
local ok,result=pcall(function()
local name=object.Name:lower():gsub("[^%w]","")
if object:IsA("ScreenGui") then
return exact[name]==true or name:sub(1,8)=="tradegui" or name:sub(1,10)=="tradinggui"
end
return object:IsA("GuiObject") and not object:IsA("GuiButton") and exact[name]==true
end)
return ok and result==true
end
local function shown(object,gui)
local current=object
while current and current~=gui do
if current:IsA("GuiObject") and not current.Visible then return false end
if current:IsA("LayerCollector") and not current.Enabled then return false end
current=current.Parent
end
return current==gui
end
local gui
local rootSet=setmetatable({}, {__mode="k"})
local frameRoots={}
local SETTLE=3
local lastOpenAt=-math.huge
local function scan()
gui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
table.clear(trade.roots)
table.clear(rootSet)
table.clear(frameRoots)
if not gui then return end
local pending={{gui,0}}
local inspected=0
while #pending>0 and inspected<4000 do
local entry=table.remove(pending)
for _,child in ipairs(entry[1]:GetChildren()) do
inspected=inspected+1
if isRoot(child) then
trade.roots[#trade.roots+1]=child;rootSet[child]=true
if not child:IsA("LayerCollector") then frameRoots[#frameRoots+1]=child end
elseif entry[2]<3 and (child:IsA("LayerCollector") or child:IsA("GuiObject") or child:IsA("Folder"))
and not child:IsA("ScrollingFrame") then
pending[#pending+1]={child,entry[2]+1}
end
end
end
end
local function windowOpen(root)
if not root.Parent or not shown(root,gui) then return false end
local camera=workspace.CurrentCamera
local viewport=camera and camera.ViewportSize
local area=viewport and viewport.X*viewport.Y or 0
local function big(object)
local size=object.AbsoluteSize
return area<=0 or size.X*size.Y>=area*0.2
end
if root:IsA("GuiObject") then return big(root) end
for _,child in ipairs(root:GetChildren()) do
if child:IsA("GuiObject") and child.Visible and big(child) then return true end
end
return false
end
local function update()
local active=false
for _,root in ipairs(trade.roots) do
if windowOpen(root) then active=true;break end
end
if active then lastOpenAt=os.clock()
elseif trade.active and os.clock()-lastOpenAt<SETTLE then return end
if active==trade.active then return end
trade.active=active
if active then
for _,listener in ipairs(trade.listeners) do task.spawn(function() pcall(listener,true) end) end
else
task.spawn(function()
for _,listener in ipairs(trade.listeners) do
if trade.active or not runtimeAlive then return end
pcall(listener,false)
task.wait(0.35)
end
end)
end
end
function trade.OnChanged(listener) trade.listeners[#trade.listeners+1]=listener end
local layerCache=setmetatable({}, {__mode="k"})
function trade.InWindow(object)
if typeof(object)~="Instance" then return false end
local ok,layer=pcall(object.FindFirstAncestorWhichIsA,object,"LayerCollector")
if not ok then return false end
if layer then
if rootSet[layer] then return true end
local known=layerCache[layer]
if known==nil then known=isRoot(layer);layerCache[layer]=known end
if known then return true end
end
for _,root in ipairs(frameRoots) do
if root.Parent and object:IsDescendantOf(root) then return true end
end
return false
end
function trade.IsActive() return trade.active end
local nextScan,elapsed=0,0
local connection
connection=RunService.Heartbeat:Connect(function(dt)
if not runtimeAlive then connection:Disconnect();trade.active=false;return end
elapsed=elapsed+dt
if elapsed<0.15 then return end
elapsed=0
local now=os.clock()
if now>=nextScan then nextScan=now+2;pcall(scan) end
pcall(update)
end)
local watchedGui
local function watchGui()
local playerGui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
if not playerGui or playerGui==watchedGui then return end
watchedGui=playerGui
playerGui.DescendantAdded:Connect(function(object)
if trade.active or not runtimeAlive then return end
local ok,name=pcall(function() return object.Name end)
if ok and type(name)=="string" and name:find("[Tt][Rr][Aa][Dd]") and isRoot(object) then
nextScan=0;elapsed=1
end
end)
end
pcall(watchGui)
LocalPlayer.ChildAdded:Connect(function(child) if child:IsA("PlayerGui") then pcall(watchGui) end end)
pcall(scan)
end,"Part at line 801")
pcall(function()
LocalPlayer.OnTeleport:Connect(function()
saveConfig()
end)
end)
pcall(function()
game:BindToClose(function()
saveConfig()
end)
end)
local ButtonAudio={sounds=setmetatable({}, {__mode="k"})}
ButtonAudio.muted=C("vv2MuteButtonSFX",nil)
if ButtonAudio.muted==nil then
ButtonAudio.muted=C("vv2BombJump_MuteButtonSFX",false)==true
SetCfg("vv2MuteButtonSFX",ButtonAudio.muted)
end
function ButtonAudio:Register(sound,volume)
self.sounds[sound]=volume or sound.Volume
sound.Volume=self.muted and 0 or self.sounds[sound]
return sound
end
function ButtonAudio:SetMuted(value)
self.muted=value==true
SetCfg("vv2MuteButtonSFX",self.muted)
for sound,volume in pairs(self.sounds) do
pcall(function()
sound.Volume=self.muted and 0 or volume
if self.muted then sound:Stop() end
end)
end
end
env.WorldV2Runtime.ButtonAudio=ButtonAudio
env.WorldV2Runtime.RegisterReset(function()
if runtimeAlive then ButtonAudio:SetMuted(false);return end
for sound,volume in pairs(ButtonAudio.sounds) do
pcall(function() sound.Volume=volume end)
end
table.clear(ButtonAudio.sounds)
end)
local player = LocalPlayer
if migratedSettings then
task.delay(4,function() pcall(shared.Notify,"World V2: your settings for these features came over from Visuals V2",3) end)
end
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local runtime=env.WorldV2Runtime
local function compact(value) return type(value)=="string" and value:lower():gsub("[^%w]","") or "" end
local function kindOf(value)
local name=compact(value)
if name=="gun" or name=="guns" or name=="pistol" or name=="revolver" or name=="firearm" or name=="gunskins" then return "Gun" end
if name=="knife" or name=="knives" or name=="melee" or name=="sword" or name=="knifeskins" then return "Knife" end
end
local function toolKind(tool)
if typeof(tool)~="Instance" or not tool:IsA("Tool") then return nil end
local visuals=env.VisualsV2Runtime
local skins=type(visuals)=="table" and visuals.ClientWeaponSkins
if type(skins)=="table" and type(skins.GetKind)=="function" then
local ok,kind=pcall(skins.GetKind,tool)
if ok and kind then return kind end
end
local kind=kindOf(tool.Name) or kindOf(tool:GetAttribute("WeaponType")) or kindOf(tool:GetAttribute("ItemType"))
if kind then return kind end
if tool:GetAttribute("IsGun")==true then return "Gun" end
if tool:GetAttribute("IsKnife")==true then return "Knife" end
for _,candidate in ipairs({"Gun","Knife"}) do
local ok,tagged=pcall(function() return tool:HasTag("Weapon_"..candidate) end)
if ok and tagged then return candidate end
end
end
runtime.ClientWeaponSkins={GetKind=toolKind}
task.delay(6,function()
local visuals=env.VisualsV2Runtime
if runtimeAlive and type(visuals)=="table" and (visuals.TrickShoot or visuals.BombFling or visuals.GiveGun) then
pcall(shared.Notify,"World V2: an older Visuals V2 with these same features is running too. Update Visuals V2 so they don't run twice.",0)
end
end)
end,"Part \"Weapon kinds\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local runtime=env.WorldV2Runtime
local ReplicatedStorage=game:GetService("ReplicatedStorage")
-- (the game's GetPlayerData is only ever asked in the background and nothing waits for it: in a game
-- where it never answers (like MMV), a question that hangs would otherwise freeze whatever asked. No
-- answer in 3 s counts as a miss, and after 3 misses in a row it isn't asked again)
local cache={data=nil,at=-math.huge,asking=false,misses=0,token=nil}
local function ask()
if cache.asking or cache.misses>=3 then return end
local remote=ReplicatedStorage:FindFirstChild("GetPlayerData",true)
if not (remote and remote:IsA("RemoteFunction")) then cache.at=os.clock();return end
cache.asking=true
local token={}
cache.token=token
task.spawn(function()
local ok,result=pcall(function() return remote:InvokeServer() end)
if cache.token~=token then return end
if ok and type(result)=="table" then cache.data=result;cache.misses=0 elseif not ok then cache.data=nil end
cache.at=os.clock();cache.asking=false
end)
task.delay(3,function()
if cache.token==token and cache.asking then
cache.token=nil;cache.asking=false;cache.at=os.clock()
cache.misses=cache.misses+1
end
end)
end
local function data()
if os.clock()-cache.at>=2 then ask() end
return cache.data
end
local function roleOf(value)
if type(value)~="string" then return nil end
local text=value:lower()
if text:find("murder",1,true) then return "Murderer" end
if text:find("sheriff",1,true) or text:find("hero",1,true) then return "Sheriff" end
if text:find("innocent",1,true) then return "Innocent" end
return nil
end
local function entryFor(info,plr)
if type(info)~="table" then return nil end
local entry=info[plr.Name] or info[plr] or info[plr.UserId] or info[tostring(plr.UserId)]
if type(entry)=="table" then return entry end
for _,inner in pairs(info) do
if type(inner)=="table" then
local nested=inner[plr.Name] or inner[plr.UserId] or inner[tostring(plr.UserId)]
if type(nested)=="table" then return nested end
end
end
return nil
end
-- Roles the moment the game sends them: the game's PlayerDataChanged message (Remotes.Gameplay, in MM2
-- and MMV alike) is read for the list of players with their roles (Murderer, Sheriff/Hero, Innocent)
-- and whether they're dead. Only that message is listened to (or, without it, only the Gameplay ones),
-- never during a trade, and a list bigger than a server's worth of players is skipped, so trading
-- never has to wait on it. What's heard there comes first; the game's GetPlayerData answer is only used
-- when nothing has been heard. A list goes stale after 5 minutes.
local heard={}
local heardAt=-math.huge
local function playerNamed(key)
if typeof(key)=="Instance" and key:IsA("Player") then return key end
if type(key)=="string" then return Players:FindFirstChild(key) end
-- (a number is a user ID only when it's big enough to be one, not a place in a list)
if type(key)=="number" and key>=1000 then return Players:GetPlayerByUserId(key) end
return nil
end
local function noteEntry(batch,plr,entry)
local role=roleOf(entry.Role) or roleOf(entry.role) or roleOf(entry.CurrentRole) or roleOf(entry.GameRole)
local dead=entry.Dead==true or entry.Killed==true or entry.dead==true or entry.killed==true
if not role and not dead then return false end
batch[plr.Name]={role=role,dead=dead}
batch.count=batch.count+1
return true
end
local function look(batch,value,depth,budget)
if type(value)~="table" or depth>3 or budget.left<=0 then return end
local size=0
for _ in pairs(value) do
size=size+1
if size>64 then return end
end
for key,inner in pairs(value) do
budget.left=budget.left-1
if budget.left<=0 then break end
if type(inner)=="table" then
local plr=playerNamed(inner.Player) or playerNamed(inner.player) or playerNamed(inner.Name)
or playerNamed(inner.UserId) or playerNamed(key)
if not (plr and noteEntry(batch,plr,inner)) then look(batch,inner,depth+1,budget) end
end
end
end
-- (a list of two or more players is the round's roles and replaces what was heard; one player is an
-- update to that player, keeping their role if the update only says they died)
local function take(batch)
if batch.count==0 then return end
batch.count=nil
if next(batch)==nil then return end
local single=nil
for _ in pairs(batch) do single=(single==nil) end
if single then
for name,entry in pairs(batch) do
local previous=heard[name]
heard[name]={role=entry.role or (previous and previous.role),dead=entry.dead}
end
else
heard=batch
end
heardAt=os.clock()
end
local listening={}
local function listen(remote)
if listening[remote] or not remote:IsA("RemoteEvent") then return end
listening[remote]=remote.OnClientEvent:Connect(function(...)
if not runtimeAlive then return end
local trading=runtime.Trade
if trading and trading.active then return end
local budget={left=400}
local batch={count=0}
for index=1,select("#",...) do look(batch,(select(index,...)),0,budget) end
take(batch)
end)
end
local function hookRoleMessages()
local remotes=ReplicatedStorage:FindFirstChild("Remotes")
local gameplay=remotes and remotes:FindFirstChild("Gameplay")
if not gameplay then return false end
local known=gameplay:FindFirstChild("PlayerDataChanged")
if known and known:IsA("RemoteEvent") then pcall(listen,known);return true end
for _,item in ipairs(gameplay:GetChildren()) do
if item:IsA("RemoteEvent") then pcall(listen,item) end
end
return true
end
task.spawn(function()
for _=1,60 do
if not runtimeAlive or hookRoleMessages() then return end
task.wait(2)
end
end)
runtime.RegisterReset(function()
if runtimeAlive then return end
for _,connection in pairs(listening) do pcall(function() connection:Disconnect() end) end
table.clear(listening)
end)
local function heardRole(plr)
if os.clock()-heardAt>300 then return nil end
local entry=heard[plr.Name]
if not entry then return nil end
if entry.dead then return "Dead" end
return entry.role
end
local function dataRole(plr)
local quick=heardRole(plr)
if quick then return quick end
local entry=entryFor(data(),plr)
if not entry then return nil end
if entry.Dead==true or entry.Killed==true then return "Dead" end
return roleOf(entry.Role) or roleOf(entry.role) or roleOf(entry.CurrentRole)
end
local function attributeRole(plr)
for _,owner in ipairs({plr,plr.Character or false}) do
if owner then
for _,name in ipairs({"Role","CurrentRole","GameRole"}) do
local ok,value=pcall(function() return owner:GetAttribute(name) end)
local role=ok and roleOf(value)
if role then return role end
end
end
end
return nil
end
local WORDS={Gun={"gun","pistol","revolver","shotgun","rifle","blaster"},Knife={"knife","blade","dagger"}}
local function toolKind(tool)
local skins=runtime.ClientWeaponSkins
if skins and type(skins.GetKind)=="function" then
local ok,kind=pcall(skins.GetKind,tool)
if ok and (kind=="Gun" or kind=="Knife") then return kind end
end
local name=tool.Name:lower()
for kind,words in pairs(WORDS) do
for _,word in ipairs(words) do if name:find(word,1,true) then return kind end end
end
return nil
end
local function holds(plr,kind)
for _,container in ipairs({plr.Character or false,plr:FindFirstChildOfClass("Backpack") or false}) do
if container then
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and toolKind(tool)==kind then return true end
end
end
end
return false
end
local function living(plr)
local character=plr.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
return humanoid~=nil and humanoid.Health>0
end
local function roleNow(plr)
local role=attributeRole(plr) or dataRole(plr)
if role=="Dead" then return nil end
if role then return role end
if holds(plr,"Knife") then return "Murderer" end
if holds(plr,"Gun") then return "Sheriff" end
return nil
end
local function find(role,kind,skip)
local fallback=nil
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and not (skip and skip(plr)) and living(plr) then
local said=attributeRole(plr) or dataRole(plr)
if said==role then return plr end
if not fallback and said~="Dead" and (said==nil or said==role) and holds(plr,kind) then fallback=plr end
end
end
return fallback
end
runtime.Roles={
Data=data,
Holds=holds,
RoleOf=roleNow,
Sheriff=function(skip) return find("Sheriff","Gun",skip) end,
Murderer=function(skip) return find("Murderer","Knife",skip) end,
IsMine=function(role)
local said=attributeRole(LocalPlayer) or dataRole(LocalPlayer)
if said then return said==role end
return holds(LocalPlayer,role=="Murderer" and "Knife" or "Gun")
end,
}
local roundMap={at=-math.huge,model=nil,box=nil}
local function currentMap()
if os.clock()-roundMap.at<2 then return roundMap.model,roundMap.box end
roundMap.at=os.clock();roundMap.model=nil;roundMap.box=nil
for _,top in ipairs(workspace:GetChildren()) do
local holder,container=top,top:FindFirstChild("CoinContainer")
if not container then
for _,child in ipairs(top:GetChildren()) do
container=child:FindFirstChild("CoinContainer")
if container then holder=child;break end
end
end
if container then
local ok,cframe,size=pcall(function() return holder:GetBoundingBox() end)
if ok and typeof(cframe)=="CFrame" and typeof(size)=="Vector3" then
roundMap.model,roundMap.box=holder,{cframe=cframe,size=size}
end
break
end
end
return roundMap.model,roundMap.box
end
local function onMap(plr,box)
local character=plr.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
if not root then return false end
local at=box.cframe:PointToObjectSpace(root.Position)
local half=box.size/2+Vector3.new(40,80,40)
return math.abs(at.X)<=half.X and math.abs(at.Y)<=half.Y and math.abs(at.Z)<=half.Z
end
local function inRound(plr)
local model,box=currentMap()
return model~=nil and living(plr) and onMap(plr,box)
end
-- (Assassin: everyone gets a knife. Once two players are seen with knives at the same time, or the
-- round data names an Assassin role, it's taken as Assassin until the round's map goes away)
local assassin={round=nil,seen=false,at=-math.huge,value=false}
runtime.Roles.Assassin=function()
local now=os.clock()
if now-assassin.at<0.5 then return assassin.value end
assassin.at=now
local key=currentMap()
if key~=assassin.round then assassin.round,assassin.seen=key,false end
if key and not assassin.seen then
local knives=0
for _,plr in ipairs(Players:GetPlayers()) do
if living(plr) and holds(plr,"Knife") then knives=knives+1 end
end
if knives>=2 then assassin.seen=true end
local info=cache.data
if not assassin.seen and type(info)=="table" then
for _,entry in pairs(info) do
local role=type(entry)=="table" and (entry.Role or entry.role or entry.CurrentRole)
if type(role)=="string" and role:lower():find("assassin",1,true) then assassin.seen=true;break end
end
end
end
assassin.value=key~=nil and assassin.seen
return assassin.value
end
runtime.Round={
Key=function() return (currentMap()) end,
Has=inRound,
Players=function(skip)
local list={}
if not currentMap() then return list end
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and not (skip and skip(plr)) and inRound(plr) then list[#list+1]=plr end
end
return list
end,
}
-- Main whitelist (Miscellaneous): the one whitelist for all of World V2. Players on it are left alone by
-- Auto-farm Helper, Bomb Fling, Bomb Ragdoll, Fling, Reset Player and Auto Draw/Throw/Stab. Players
-- picked in the dropdown stay on it until you leave the game; the two Permanent Whitelist usernames
-- (or user IDs) are saved and count whenever Enable Permanent Whitelist is on
do
local session={}
local function clean(text)
local value=tostring(text or ""):gsub("^%s+",""):gsub("%s+$","")
value=value:gsub("^@","")
return value
end
local permanent={clean(C("w2PermWhitelist1","")),clean(C("w2PermWhitelist2","")),clean(C("w2PermWhitelist3",""))}
-- (the permanent names can be switched off as a whole; the dropdown picks always count)
local permanentOn=C("w2PermWhitelistEnabled",true)~=false
runtime.Whitelist={
Has=function(plr)
if typeof(plr)~="Instance" or not plr:IsA("Player") then return false end
if session[plr.UserId] then return true end
if not permanentOn then return false end
local name,id=plr.Name:lower(),tostring(plr.UserId)
for _,entry in ipairs(permanent) do
if entry~="" and (entry:lower()==name or entry==id) then return true end
end
return false
end,
Add=function(plr) if typeof(plr)=="Instance" and plr:IsA("Player") then session[plr.UserId]=true end end,
Clear=function() table.clear(session) end,
SetPermanent=function(slot,text) permanent[slot]=clean(text);return permanent[slot] end,
Permanent=function(slot) return permanent[slot] or "" end,
PermanentOn=function() return permanentOn end,
SetPermanentOn=function(value) permanentOn=value==true end,
Clean=clean,
}
end
function runtime.EveryoneNotices(prefix,action,done)
local tracker={round=nil,hit=setmetatable({},{__mode="k"}),told=false}
local function say(text,kind) pcall(shared.Notify,prefix..": "..text,kind) end
function tracker.InRound(plr)
local ok,value=pcall(inRound,plr)
return ok and value==true
end
function tracker.Flung(plr,skip,wasInRound)
local key=currentMap()
if key~=tracker.round then
tracker.round=key;tracker.hit=setmetatable({},{__mode="k"});tracker.told=false
end
if not key or tracker.told or not wasInRound then return end
tracker.hit[plr]=true
for _,other in ipairs(runtime.Round.Players(skip)) do
if not tracker.hit[other] then return end
end
tracker.told=true
say("everyone in the round has been "..done,2)
end
function tracker.Pass()
local pass={targets=0,hits=0,closed=false}
function pass.Result(hit)
pass.targets=pass.targets+1
if hit then pass.hits=pass.hits+1 end
end
function pass.Close()
if pass.closed then return end
pass.closed=true
if pass.targets==0 then say("there was nobody to "..action,3)
elseif pass.hits==pass.targets then
say(("everyone has been %s (%d player%s)"):format(done,pass.targets,pass.targets==1 and "" or "s"),2)
else
say(("%d of %d players %s; %d couldn't be %s."):format(pass.hits,pass.targets,done,pass.targets-pass.hits,done),3)
end
end
return pass
end
return tracker
end
end,"Part \"Roles\"")
local antisSection
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local runtime=env.WorldV2Runtime
local section=mainTab:AddSection("Antis","Utilities")
antisSection=section
local alive=true
local controls={}
local function toggle(name,key,callback)
local controller=addToggle(section,name,C(key,false),function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
local function disconnectAll(list)
for _,connection in ipairs(list) do pcall(function() connection:Disconnect() end) end
table.clear(list)
end
local ghost={changed=setmetatable({}, {__mode="k"}),from=setmetatable({}, {__mode="k"}),iy=false,lowEnd=false,iyConnection=nil,lowEndConnections={},sweptAt=0}
local function ghostPart(part,character)
if not part:IsA("BasePart") then return end
if ghost.changed[part]==nil then ghost.changed[part]=part.CanCollide end
if character then ghost.from[part]=character end
if part.CanCollide then part.CanCollide=false end
end
-- (a part that has left the other player's character, like a bomb they've thrown, gets its collision
-- back, so it doesn't fall through the floor when your game ends up moving it)
local function ghostSweep()
local now=os.clock()
if now-ghost.sweptAt<0.2 then return end
ghost.sweptAt=now
for part,value in pairs(ghost.changed) do
local character=ghost.from[part]
if character and not part:IsDescendantOf(character) then
ghost.changed[part],ghost.from[part]=nil,nil
if part.Parent then pcall(function() part.CanCollide=value end) end
end
end
end
local function ghostRelease()
if ghost.iy or ghost.lowEnd then return end
for part,value in pairs(ghost.changed) do
if part.Parent then pcall(function() part.CanCollide=value end) end
end
table.clear(ghost.changed);table.clear(ghost.from)
end
toggle("W2 Enable IY Anti Fling","w2AntiIYFling",function(value)
ghost.iy=value
if ghost.iyConnection then ghost.iyConnection:Disconnect();ghost.iyConnection=nil end
if value then
ghost.iyConnection=RunService.Stepped:Connect(function()
if not alive or not runtimeAlive then return end
pcall(ghostSweep)
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and plr.Character then
local character=plr.Character
for _,part in ipairs(character:GetDescendants()) do
if part:IsA("BasePart") then ghostPart(part,character) end
end
end
end
end)
end
ghostRelease()
end)
toggle("W2 Enable Low-End Device Anti-Fling","w2AntiLowEndFling",function(value)
ghost.lowEnd=value
disconnectAll(ghost.lowEndConnections)
if value then
local connections=ghost.lowEndConnections
local function setupCharacter(character)
for _,part in ipairs(character:GetDescendants()) do ghostPart(part,character) end
connections[#connections+1]=character.DescendantAdded:Connect(function(part)
if ghost.lowEnd then ghostPart(part,character) end
end)
connections[#connections+1]=character.DescendantRemoving:Connect(function()
task.defer(function() pcall(ghostSweep) end)
end)
end
local function watchPlayer(plr)
if plr==LocalPlayer then return end
if plr.Character then setupCharacter(plr.Character) end
connections[#connections+1]=plr.CharacterAdded:Connect(setupCharacter)
end
for _,plr in ipairs(Players:GetPlayers()) do watchPlayer(plr) end
connections[#connections+1]=Players.PlayerAdded:Connect(watchPlayer)
end
ghostRelease()
end)
local afkConnection
toggle("W2 Enable True Anti AFK","w2AntiAFK",function(value)
if afkConnection then afkConnection:Disconnect();afkConnection=nil end
if value then
afkConnection=LocalPlayer.Idled:Connect(function()
pcall(function()
local virtualUser=game:GetService("VirtualUser")
virtualUser:CaptureController()
virtualUser:ClickButton2(Vector2.new())
end)
end)
end
end)
local void={on=false,original=nil,run=0}
local function setVoid(value)
void.on=value
void.run=void.run+1
if value then
local ok,current=pcall(function() return workspace.FallenPartsDestroyHeight end)
if void.original==nil and ok and current==current then void.original=current end
local run=void.run
task.spawn(function()
while void.on and void.run==run and alive and runtimeAlive do
pcall(function()
local height=workspace.FallenPartsDestroyHeight
if height==height then workspace.FallenPartsDestroyHeight=0/0 end
end)
task.wait(1)
end
end)
elseif void.original~=nil then
local original=void.original
void.original=nil
pcall(function() workspace.FallenPartsDestroyHeight=original end)
end
end
toggle("W2 Enable True Anti Void","w2AntiVoid",setVoid)
local anti={enabled=false,changed={},connections={},bombs={},safe=nil,blocked=0,noticeAt=-math.huge,scan=0}
local OWN_JUMP_TIME=2.5
local FLUNG_FLAT,FLUNG_RISE,FLUNG_SPIN=100,150,40
local SUDDEN_SPEED,SUDDEN_SPIN=80,30
local FAST_PART,SPIN_PART,NEAR_PART=60,30,20
local function inCharacterOrTool(object)
local current=object.Parent
for _=1,8 do
if not current or current==workspace then return false end
if current:IsA("Tool") or current:IsA("Accessory") or current:FindFirstChildOfClass("Humanoid") then return true end
current=current.Parent
end
return false
end
local function bombLike(part)
if not part:IsA("BasePart") or part.Anchored then return false end
local name=part.Name:lower()
local parent=part.Parent
local parentName=parent and parent.Name:lower() or ""
if not (name:find("fakebomb",1,true) or parentName:find("fakebomb",1,true) or name=="bomb" or parentName=="bomb"
or name=="handle") then return false end
return not inCharacterOrTool(part)
end
local function owned(part)
local ok,age=pcall(function() return part.ReceiveAge end)
return not ok or age==0
end
local function ownBomb()
local fling=runtime.BombFling
if type(fling)~="table" then return nil end
local get=fling.MyBomb
if type(get)~="function" then return nil end
local ok,part=pcall(get)
return ok and part or nil
end
local function release(part)
local original=anti.changed[part]
if original==nil then return end
anti.changed[part]=nil
pcall(function() part.CanCollide=original.collide;part.CanTouch=original.touch end)
end
local function shield(part,mine)
if part==mine or not part.Parent then return end
if anti.changed[part]==nil then
local ok,collide,touch=pcall(function() return part.CanCollide,part.CanTouch end)
if not ok then return end
anti.changed[part]={collide=collide,touch=touch,at=os.clock()}
end
pcall(function()
if part.CanCollide then part.CanCollide=false end
if part.CanTouch then part.CanTouch=false end
end)
end
local overlap=OverlapParams.new()
overlap.FilterType=Enum.RaycastFilterType.Exclude
-- (a bomb your game is moving, like one the game hands to you because you're the closest, keeps its
-- collision: without it, it falls through the floor, for everyone)
local function shieldStep(root,character)
local mine=ownBomb()
for part in pairs(anti.bombs) do
if not part.Parent then anti.bombs[part]=nil
elseif owned(part) then release(part)
elseif part~=mine then shield(part,mine) end
end
if root then
overlap.FilterDescendantsInstances={character}
local ok,nearby=pcall(function() return workspace:GetPartBoundsInRadius(root.Position,NEAR_PART,overlap) end)
if ok then
for _,part in ipairs(nearby) do
if anti.changed[part]==nil and not part.Anchored and part~=mine
and (part.AssemblyLinearVelocity.Magnitude>FAST_PART or part.AssemblyAngularVelocity.Magnitude>SPIN_PART)
and not inCharacterOrTool(part) and not owned(part) then
shield(part,mine)
end
end
end
end
for part,original in pairs(anti.changed) do
if not part.Parent then anti.changed[part]=nil
elseif owned(part) or part==mine then release(part)
elseif anti.bombs[part] or os.clock()-original.at<=3 or part.AssemblyLinearVelocity.Magnitude>=20 then shield(part,mine)
else release(part) end
end
end
local function sinceOwnJump()
local bombJump=runtime.VV2BombJump
if bombJump and type(bombJump.SinceJump)=="function" then
local ok,since=pcall(bombJump.SinceJump)
if ok and tonumber(since) then return tonumber(since) end
end
return math.huge
end
local function guardStep(root,humanoid)
if not root or not humanoid or humanoid.Health<=0 or humanoid.SeatPart
or humanoid:GetState()==Enum.HumanoidStateType.Physics then anti.safe=nil;return end
local now=os.clock()
local velocity,spin=root.AssemblyLinearVelocity,root.AssemblyAngularVelocity
local flat=Vector3.new(velocity.X,0,velocity.Z)
local move=humanoid.MoveDirection
local steering=move.Magnitude>0.1 and flat.Magnitude>1 and flat.Unit:Dot(move.Unit)>0.9
local wild=(flat.Magnitude>FLUNG_FLAT and not steering) or velocity.Y>FLUNG_RISE or spin.Magnitude>FLUNG_SPIN
local safe=anti.safe
if wild and safe and safe.root==root and now-safe.at<2 and sinceOwnJump()>OWN_JUMP_TIME
and ((velocity-safe.velocity).Magnitude>SUDDEN_SPEED or (spin-safe.spin).Magnitude>SUDDEN_SPIN) then
pcall(function()
root.CFrame=safe.cframe
root.AssemblyLinearVelocity=safe.velocity
root.AssemblyAngularVelocity=Vector3.zero
end)
local state=humanoid:GetState()
if state==Enum.HumanoidStateType.FallingDown or state==Enum.HumanoidStateType.Ragdoll then
pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
end
anti.blocked=anti.blocked+1
return
end
if not wild then anti.safe={root=root,cframe=root.CFrame,velocity=velocity,spin=spin,at=now} end
end
local function consider(part)
if anti.enabled and not anti.bombs[part] and bombLike(part) then anti.bombs[part]=os.clock() end
end
local function antiOff()
anti.scan=anti.scan+1
disconnectAll(anti.connections)
for part in pairs(anti.changed) do release(part) end
table.clear(anti.bombs)
anti.safe=nil
end
if inMurderMystery then toggle("Anti Bomb Fling","bombFlingAnti",function(value)
anti.enabled=value
antiOff()
if not value then return end
local connections=anti.connections
connections[#connections+1]=workspace.DescendantAdded:Connect(function(object)
if object:IsA("BasePart") then task.defer(consider,object) end
end)
connections[#connections+1]=workspace.DescendantRemoving:Connect(function(object)
if anti.bombs[object] then anti.bombs[object]=nil end
end)
local scan=anti.scan
task.spawn(function()
local ok,list=pcall(workspace.GetDescendants,workspace)
if not ok then return end
local started=os.clock()
for index,object in ipairs(list) do
if anti.scan~=scan or not alive then return end
if object:IsA("BasePart") then consider(object) end
if index%300==0 and os.clock()-started>0.003 then task.wait();started=os.clock() end
end
end)
connections[#connections+1]=RunService.Stepped:Connect(function()
if not alive or not runtimeAlive then return end
local character=LocalPlayer.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
pcall(shieldStep,root,character)
pcall(guardStep,root,humanoid)
end)
end) end
runtime.RegisterReset(function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
ghost.iy,ghost.lowEnd=false,false
if ghost.iyConnection then ghost.iyConnection:Disconnect();ghost.iyConnection=nil end
disconnectAll(ghost.lowEndConnections)
ghostRelease()
if afkConnection then afkConnection:Disconnect();afkConnection=nil end
setVoid(false)
anti.enabled=false
antiOff()
if not runtimeAlive then alive=false end
end)
end,"Section \"Antis\"")
local noInterruptionEmote=C("noInterruptionEmote",false)
local setupAutomaticEmoteProtection
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local DEBUG=false
local GRACE=0.3
local WATCHDOG=0.25
local TREAT_UNKNOWN_AS_EMOTE=true
local MIN_UNKNOWN_LENGTH=0.6
local CLASSIC_EMOTE_IDS={
[507770239]=true,[507770453]=true,[507771019]=true,[507776043]=true,
[507777268]=true,[507770818]=true,[507770677]=true,
[128777973]=true,[128853357]=true,[182435998]=true,[182491037]=true,
[182491065]=true,[129423131]=true,[129423030]=true,
}
local LOCOMOTION_IDS={
[507766666]=true,[507766951]=true,[507766388]=true,[507777826]=true,
[507767714]=true,[507765000]=true,[507767968]=true,[507765644]=true,
[507784897]=true,[507785072]=true,[2506281703]=true,[507768375]=true,
[522635514]=true,[522638767]=true,
[180435571]=true,[180435792]=true,[180426354]=true,[125750702]=true,
[180436148]=true,[180436334]=true,[178130996]=true,[182393478]=true,
[129967390]=true,[129967478]=true,
}
local EXCLUDED_ANIMATION_IDS={}
local EMOTE_GROUPS={
wave=true,point=true,dance=true,dance2=true,dance3=true,laugh=true,cheer=true,
}
local LOCOMOTION_PROPS={
"ClimbAnimation","FallAnimation","IdleAnimation","JumpAnimation",
"RunAnimation","SwimAnimation","WalkAnimation",
}
local emoteIds,locomotionIds=CLASSIC_EMOTE_IDS,LOCOMOTION_IDS
local active=setmetatable({}, {__mode="k"})
local verdicts=setmetatable({}, {__mode="k"})
local stoppedConns={}
local changed=setmetatable({}, {__mode="k"})
local charConns,humanoidConns,animatorConns={}, {}, {}
local stepConn=nil
local graceUntil=0
local session=0
local boundChar,boundHumanoid,boundAnimator=nil,nil,nil
local resolveBindings
local function dprint(...)
if DEBUG then print("[VisualsV2 emote]",...) end
end
local function numericId(value)
if type(value)=="number" then
if value>0 then return value end
return nil
end
if type(value)~="string" then return nil end
return tonumber(value:match("%d+"))
end
local function addId(set,value)
local id=numericId(value)
if id then set[id]=true end
end
local function disconnectAll(list)
for i=#list,1,-1 do
local conn=list[i]
list[i]=nil
pcall(function() conn:Disconnect() end)
end
end
local function animateGroupName(animation,char)
if not char or not animation:IsDescendantOf(char) then return nil end
local node=animation
while node.Parent and node.Parent~=char do
if node.Parent:IsA("LuaSourceContainer") then
return node.Name:lower()
end
node=node.Parent
end
return nil
end
local function isEmoteGroup(name)
if EMOTE_GROUPS[name] then return true end
return name:find("emote",1,true)~=nil
end
local function isGameOwned(animation,char)
if animation:FindFirstAncestorOfClass("Tool") then return true end
if char and animation:IsDescendantOf(char) then return false end
return animation:IsDescendantOf(game)
end
local function refreshCatalog(char,humanoid)
local emotes,moves={}, {}
for id in pairs(CLASSIC_EMOTE_IDS) do emotes[id]=true end
for id in pairs(LOCOMOTION_IDS) do moves[id]=true end
if char then
for _,child in ipairs(char:GetChildren()) do
if child:IsA("LuaSourceContainer") then
for _,animation in ipairs(child:GetDescendants()) do
if animation:IsA("Animation") then
local id=numericId(animation.AnimationId)
local group=animateGroupName(animation,char)
if id and group then
if isEmoteGroup(group) then
emotes[id]=true
else
moves[id]=true
end
end
end
end
end
end
end
if humanoid then
local okDescription,description=pcall(function()
return humanoid:GetAppliedDescription()
end)
if okDescription and description then
for _,prop in ipairs(LOCOMOTION_PROPS) do
local okProp,value=pcall(function() return description[prop] end)
if okProp then addId(moves,value) end
end
local okEmotes,dictionary=pcall(function()
return description:GetEmotes()
end)
if okEmotes and type(dictionary)=="table" then
for _,ids in pairs(dictionary) do
if type(ids)=="table" then
for _,id in ipairs(ids) do addId(emotes,id) end
end
end
end
end
end
for id in pairs(moves) do emotes[id]=nil end
emoteIds,locomotionIds=emotes,moves
end
local function judgeTrack(track,char)
local animation=track.Animation
if not animation then return false,"track has no Animation" end
local id=numericId(animation.AnimationId)
if id and EXCLUDED_ANIMATION_IDS[id] then return false,"excluded id" end
if id and locomotionIds[id] then return false,"locomotion id" end
local group=animateGroupName(animation,char)
if group then
if isEmoteGroup(group) then return true,"Animate emote group '"..group.."'" end
return false,"Animate group '"..group.."'"
end
if isGameOwned(animation,char) then return false,"game-owned animation" end
if id and emoteIds[id] then return true,"known avatar emote id" end
if not TREAT_UNKNOWN_AS_EMOTE then return false,"unknown animation" end
if not track.Looped then
local length=track.Length
if length>0 and length<MIN_UNKNOWN_LENGTH then
return false,"short one-shot action"
end
end
return true,"unknown engine-created animation"
end
local function describeTrack(track)
local animation=track.Animation
local where="nil"
if animation and animation.Parent then where=animation:GetFullName() end
return string.format(
"track=%s anim=%s id=%s parent=%s priority=%s looped=%s length=%.2f",
tostring(track.Name),
animation and tostring(animation.Name) or "nil",
animation and tostring(animation.AnimationId) or "nil",
where,tostring(track.Priority),tostring(track.Looped),track.Length
)
end
local function readIsPlaying(track)
return track.IsPlaying
end
local function trackPlaying(track)
local ok,playing=pcall(readIsPlaying,track)
return ok and playing==true
end
local function dropTrack(track)
active[track]=nil
local conn=stoppedConns[track]
if conn then
stoppedConns[track]=nil
pcall(function() conn:Disconnect() end)
end
graceUntil=os.clock()+GRACE
end
local function clearEmotes()
for track,conn in pairs(stoppedConns) do
stoppedConns[track]=nil
pcall(function() conn:Disconnect() end)
end
table.clear(active)
graceUntil=0
end
local function emoteActive()
for track in pairs(active) do
if trackPlaying(track) then return true end
dropTrack(track)
end
return os.clock()<graceUntil
end
local partCache={}
local function forgetCharacter(character)
local record=partCache[character]
if not record then return end
partCache[character]=nil
for _,conn in ipairs(record.conns) do pcall(function() conn:Disconnect() end) end
end
local function forgetAllCharacters()
for character in pairs(partCache) do forgetCharacter(character) end
end
local function cachedParts(character)
local record=partCache[character]
if record then return record.parts end
record={parts={},conns={}}
partCache[character]=record
for _,part in ipairs(character:GetDescendants()) do
if part:IsA("BasePart") then record.parts[part]=true end
end
record.conns[1]=character.DescendantAdded:Connect(function(part)
if part:IsA("BasePart") then record.parts[part]=true end
end)
record.conns[2]=character.DescendantRemoving:Connect(function(part)
record.parts[part]=nil
-- (one that leaves the character, like a thrown bomb, gets its collision back)
if changed[part] then changed[part]=nil;task.defer(function() if part.Parent then pcall(function() part.CanCollide=true end) end end) end
end)
record.conns[3]=character.AncestryChanged:Connect(function(_,parent)
if not parent then forgetCharacter(character) end
end)
return record.parts
end
local function applyStep()
local current={}
for _,other in ipairs(Players:GetPlayers()) do
if other~=player then
local character=other.Character
if character then
current[character]=true
for part in pairs(cachedParts(character)) do
if part.CanCollide then
changed[part]=true
part.CanCollide=false
end
end
end
end
end
for character in pairs(partCache) do
if not current[character] then forgetCharacter(character) end
end
end
local function setCollidable(part)
part.CanCollide=true
end
local function restoreCollisions()
local count=0
for part in pairs(changed) do
changed[part]=nil
count=count+1
if part.Parent then pcall(setCollidable,part) end
end
return count
end
local function stopProtection()
local wasRunning=stepConn~=nil
if stepConn then
local conn=stepConn
stepConn=nil
pcall(function() conn:Disconnect() end)
end
forgetAllCharacters()
local restored=restoreCollisions()
if wasRunning or restored>0 then
dprint("anti-fling OFF, restored",restored,"parts")
end
end
local function onStepped()
if not noInterruptionEmote or not emoteActive() then
stopProtection()
return
end
applyStep()
end
local function ensureProtection()
if not noInterruptionEmote or stepConn then return end
stepConn=RunService.Stepped:Connect(onStepped)
dprint("anti-fling ON")
applyStep()
end
local function handleTrack(track)
if not noInterruptionEmote or not track or active[track] then return end
local verdict=verdicts[track]
if verdict==nil then
local ok,isEmote,reason=pcall(judgeTrack,track,boundChar)
if ok then
verdict=isEmote==true
else
verdict=false
reason=tostring(isEmote)
end
verdicts[track]=verdict
if DEBUG then
local okInfo,info=pcall(describeTrack,track)
dprint(verdict and "EMOTE" or "ignore","|",reason,"|",okInfo and info or "?")
end
end
if not verdict then return end
active[track]=true
local okConn,conn=pcall(function()
return track.Stopped:Connect(function()
dropTrack(track)
end)
end)
if okConn and conn then stoppedConns[track]=conn end
ensureProtection()
end
local function scanPlaying(animator)
local ok,tracks=pcall(function()
return animator:GetPlayingAnimationTracks()
end)
if ok and type(tracks)=="table" then
for _,track in ipairs(tracks) do handleTrack(track) end
end
end
local function bindAnimator(animator)
disconnectAll(animatorConns)
boundAnimator=animator
if not animator then return end
pcall(function()
table.insert(animatorConns,animator.AnimationPlayed:Connect(handleTrack))
end)
scanPlaying(animator)
end
local function bindHumanoid(humanoid)
disconnectAll(humanoidConns)
bindAnimator(nil)
boundHumanoid=humanoid
if not humanoid then return end
pcall(function()
table.insert(humanoidConns,humanoid.AnimationPlayed:Connect(handleTrack))
end)
pcall(function()
table.insert(humanoidConns,humanoid.ChildAdded:Connect(function(child)
if child:IsA("Animator") and boundChar then
task.defer(resolveBindings,boundChar)
end
end))
end)
pcall(function()
table.insert(humanoidConns,humanoid.ApplyDescriptionFinished:Connect(function()
task.defer(refreshCatalog,boundChar,humanoid)
end))
end)
task.spawn(refreshCatalog,boundChar,humanoid)
end
resolveBindings=function(char)
if not char or boundChar~=char then return end
local humanoid=char:FindFirstChildOfClass("Humanoid")
if humanoid~=boundHumanoid then
bindHumanoid(humanoid)
end
local animator=nil
if humanoid then animator=humanoid:FindFirstChildOfClass("Animator") end
if animator~=boundAnimator then
bindAnimator(animator)
end
end
local function teardown()
session=session+1
disconnectAll(charConns)
disconnectAll(humanoidConns)
disconnectAll(animatorConns)
clearEmotes()
boundChar,boundHumanoid,boundAnimator=nil,nil,nil
stopProtection()
end
setupAutomaticEmoteProtection=function(char)
teardown()
if not noInterruptionEmote or not char then return end
local mySession=session
boundChar=char
local function alive()
return noInterruptionEmote
and session==mySession
and boundChar==char
and char.Parent~=nil
and player.Character==char
end
pcall(function()
table.insert(charConns,player.CharacterRemoving:Connect(function(removing)
if removing==char and session==mySession then
clearEmotes()
stopProtection()
end
end))
end)
pcall(function()
table.insert(charConns,player.CharacterAppearanceLoaded:Connect(function(loaded)
if loaded==char and alive() then
task.spawn(refreshCatalog,char,boundHumanoid)
end
end))
end)
pcall(function()
table.insert(charConns,char.ChildAdded:Connect(function(child)
if not alive() then return end
if child:IsA("Humanoid") then
task.defer(resolveBindings,char)
elseif child:IsA("LuaSourceContainer") then
task.defer(refreshCatalog,char,boundHumanoid)
end
end))
end)
task.spawn(function()
while alive() do
resolveBindings(char)
if boundAnimator then scanPlaying(boundAnimator) end
if not stepConn and emoteActive() then ensureProtection() end
task.wait(WATCHDOG)
end
if session==mySession then
clearEmotes()
stopProtection()
end
end)
end
local noInterruptionToggle=addToggle(
antisSection or mainTab:AddSection("Antis","Utilities"),
"No interruption on emoting",
noInterruptionEmote,
function(state)
noInterruptionEmote=state
SetCfg("noInterruptionEmote",state)
if state then
setupAutomaticEmoteProtection(player.Character)
else
teardown()
end
end
)
if noInterruptionEmote and player.Character then
task.defer(function()
setupAutomaticEmoteProtection(player.Character)
end)
end
env.WorldV2Runtime.RegisterReset(function()
noInterruptionToggle:Set(false)
noInterruptionEmote=false
teardown()
end)
end,"Part at line 4164")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local runtime=env.WorldV2Runtime
local GRADIENT=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.new(0.0784314,0.0784314,0.0784314)),
ColorSequenceKeypoint.new(0.75,Color3.new(0.0784314,0.0784314,0.54902)),
ColorSequenceKeypoint.new(1,Color3.new(0.470588,0.156863,0.470588)),
})
local style={
enabled=C("vv2BigButtonGradientEnabled",false)==true,
colors={
C("vv2BigButtonGradient1",Color3.fromRGB(20,20,20)),
C("vv2BigButtonGradient2",Color3.fromRGB(20,20,140)),
C("vv2BigButtonGradient3",Color3.fromRGB(120,40,120)),
},
tracked=setmetatable({}, {__mode="k"}),
}
for index,color in ipairs(style.colors) do
if typeof(color)~="Color3" then style.colors[index]=GRADIENT.Keypoints[math.min(index,#GRADIENT.Keypoints)].Value end
end
function style.Custom()
return ColorSequence.new({
ColorSequenceKeypoint.new(0,style.colors[1]),
ColorSequenceKeypoint.new(0.5,style.colors[2]),
ColorSequenceKeypoint.new(1,style.colors[3]),
})
end
style.settings={gradient=nil,name=nil}
style.listeners={}
local THEME_FOLDERS={"Ixry Shizuka/customs/ui_customizations","Ixry Shizuka/customs/ui-customizations",
"Ixry Shizuka/customs/ui customizations","Ixry Shizuka/customs/UI Customizations","Ixry Shizuka/customs/UI_Customizations"}
local themePlace={folder=nil,root="Ixry Shizuka",scannedAt=-math.huge}
local HttpService=game:GetService("HttpService")
local function hexColor(value)
if type(value)~="string" then return nil end
local hex=value:match("^%s*#?(%x%x%x%x%x%x)%s*$")
if not hex then return nil end
return Color3.fromRGB(tonumber(hex:sub(1,2),16),tonumber(hex:sub(3,4),16),tonumber(hex:sub(5,6),16)),hex:upper()
end
local function hexOf(color)
return string.format("%02X%02X%02X",math.floor(color.R*255+0.5),math.floor(color.G*255+0.5),math.floor(color.B*255+0.5))
end
local function orderedColors(group)
if type(group)~="table" then return nil end
local list={}
for key,value in pairs(group) do
local color=hexColor(value)
if color then
local index=tonumber(tostring(key):match("^%s*#?%s*(%d+)")) or 99
list[#list+1]={index=index,key=tostring(key),color=color}
end
end
if #list<2 then return nil end
table.sort(list,function(a,b) if a.index~=b.index then return a.index<b.index end return a.key<b.key end)
local colors={}
for index,entry in ipairs(list) do colors[index]=entry.color end
return colors
end
local function sequenceOf(colors)
if not colors or #colors<2 then return nil end
local template=GRADIENT.Keypoints
local points={}
for index,color in ipairs(colors) do
local time=#colors==#template and template[index].Time or (index-1)/(#colors-1)
points[#points+1]=ColorSequenceKeypoint.new(time,color)
end
return ColorSequence.new(points)
end
local function colorSet(source)
local set,count={},0
local list=source
if typeof(source)=="ColorSequence" then
list={}
for _,point in ipairs(source.Keypoints) do list[#list+1]=point.Value end
end
for _,color in ipairs(list or {}) do
local hex=hexOf(color)
if not set[hex] then set[hex]=true;count=count+1 end
end
return {set=set,count=count}
end
local function sameColors(a,b)
if not a or not b or a.count<1 or b.count<1 then return false end
if a.count==1 or b.count==1 then
if a.count~=b.count then return false end
return b.set[next(a.set)]==true
end
local common=0
for hex in pairs(a.set) do if b.set[hex] then common=common+1 end end
return common>=math.min(a.count,b.count)
end
local function bare(colors)
if not colors or colors.count~=1 then return false end
local hex=next(colors.set)
return hex=="FFFFFF" or hex=="000000"
end
local TEMPLATE_SET=colorSet(GRADIENT)
local GOLD_SET=colorSet({Color3.fromRGB(255,215,0),Color3.fromRGB(255,140,0),Color3.fromRGB(184,134,11)})
local function groupNamed(data,wanted)
for key,value in pairs(data) do
if type(key)=="string" and key:lower():gsub("[^%a]","")==wanted then return value end
end
end
local function fileApi()
local listFiles=type(listfiles)=="function" and listfiles or env.listfiles
local readFile=type(readfile)=="function" and readfile or env.readfile
local isFolder=type(isfolder)=="function" and isfolder or env.isfolder
return listFiles,readFile,isFolder
end
local function plainName(text) return (tostring(text or ""):lower():gsub("[^%a]","")) end
local function lastPart(path) return (tostring(path):gsub("[/\\]+$","")):match("([^/\\]+)$") or tostring(path) end
local function jsonFiles(folder)
local listFiles=fileApi()
if type(listFiles)~="function" then return {} end
local ok,entries=pcall(listFiles,folder)
if not ok or type(entries)~="table" then return {} end
local list={}
for _,path in ipairs(entries) do
if type(path)=="string" and path:lower():sub(-5)==".json" then list[#list+1]=path end
end
return list
end
local function subfolders(folder)
local listFiles,_,isFolder=fileApi()
if type(listFiles)~="function" then return {} end
local ok,entries=pcall(listFiles,folder)
if not ok or type(entries)~="table" then return {} end
local base=(folder:gsub("\\","/"):gsub("/+$",""))
local list,seen={},{}
local function add(path)
local key=path:lower()
if not seen[key] then seen[key]=true;list[#list+1]=path end
end
for index,entry in ipairs(entries) do
if index>400 then break end
if type(entry)=="string" then
local path=entry:gsub("\\","/")
local inside=base=="" or path:lower():sub(1,#base+1)==base:lower().."/"
local rest=inside and (base=="" and path or path:sub(#base+2)) or nil
local first=rest and rest:match("^([^/]+)/")
if first then add((base~="" and base.."/" or "")..first)
elseif type(isFolder)=="function" then
local okFolder,folderLike=pcall(isFolder,entry)
if okFolder and folderLike==true then add(entry) end
end
end
end
return list
end
local function usualThemeFolder()
for _,folder in ipairs(THEME_FOLDERS) do
if #jsonFiles(folder)>0 then return folder,"Ixry Shizuka" end
end
end
local function scanThemeFolder()
local roots={"Ixry Shizuka"}
for _,top in ipairs(subfolders("")) do
if plainName(lastPart(top)):find("shizuka",1,true) and top~="Ixry Shizuka" then roots[#roots+1]=top end
end
for _,root in ipairs(roots) do
for _,customs in ipairs(subfolders(root)) do
if plainName(lastPart(customs)):find("custom",1,true) then
for _,folder in ipairs(subfolders(customs)) do
if plainName(lastPart(folder)):find("uicustom",1,true) and #jsonFiles(folder)>0 then return folder,root end
end
end
end
end
return nil
end
local function readThemes()
local list={}
local _,readFile=fileApi()
if type(readFile)~="function" then return list end
local files=themePlace.folder and jsonFiles(themePlace.folder) or {}
if #files==0 then
local folder,root=usualThemeFolder()
if not folder and os.clock()-themePlace.scannedAt>=15 then
themePlace.scannedAt=os.clock()
folder,root=scanThemeFolder()
end
if folder then themePlace.folder,themePlace.root=folder,root;files=jsonFiles(folder) end
end
style.themeFolder=themePlace.folder
for _,path in ipairs(files) do
if type(path)=="string" and path:lower():sub(-5)==".json" then
local okRead,text=pcall(readFile,path)
if okRead and type(text)=="string" and #text<200000 then
local okJson,data=pcall(function() return HttpService:JSONDecode(text) end)
if okJson and type(data)=="table" then
local entry={name=path:match("([^/\\]+)%.[Jj][Ss][Oo][Nn]$") or path,data=data,colors={}}
entry.secondary=orderedColors(groupNamed(data,"secondary"))
entry.variant=orderedColors(groupNamed(data,"secondaryvariant"))
entry.gradient=entry.variant or entry.secondary
entry.gradientSet=colorSet(entry.gradient)
entry.secondarySet=colorSet(entry.secondary)
entry.variantSet=colorSet(entry.variant)
for _,group in pairs(data) do
if type(group)=="table" then
for _,value in pairs(group) do
local _,hex=hexColor(value)
if hex then entry.colors[hex]=true end
end
end
end
if entry.gradient then list[#list+1]=entry end
end
end
end
end
return list
end
local OUR_PREFIXES={"visualsv2","vv2_","vv2 ","worldv2","w2_","w2 "}
local function ours(name)
name=name:lower()
for _,prefix in ipairs(OUR_PREFIXES) do if name:sub(1,#prefix)==prefix then return true end end
return false
end
local ROBLOX_GUIS={RobloxGui=true,RobloxPromptGui=true,RobloxLoadingGUI=true,RobloxNetworkPauseNotification=true,
TopBarApp=true,InGameMenu=true,PlayerList=true,ExperienceChat=true,BubbleChat=true,PurchasePromptApp=true,
DevConsoleMaster=true,CoreScriptLocalization=true,FoundationOverlay=true,ThemeProvider=true,TeleportGui=true,
HeadsetDisconnectedDialog=true,Chat=true,TouchGui=true,BubbleChatContainer=true}
local function guiRoots()
local roots={}
local function add(root)
if typeof(root)~="Instance" then return end
for _,existing in ipairs(roots) do if existing==root then return end end
roots[#roots+1]=root
end
local hidden=type(gethui)=="function" and gethui or env.gethui
if type(hidden)=="function" then local ok,root=pcall(hidden);if ok then add(root) end end
pcall(function() add(game:GetService("CoreGui")) end)
add(LocalPlayer:FindFirstChildOfClass("PlayerGui"))
return roots
end
local bigButtonsSeen=setmetatable({}, {__mode="k"})
local function looksBig(button)
if not button:IsA("GuiButton") or ours(button.Name) then return false end
local transparency=button.BackgroundTransparency
if transparency<0.8 or transparency>0.97 then return false end
local stroke=button:FindFirstChildOfClass("UIStroke")
if not stroke or stroke.Thickness<0.8 or stroke.Thickness>3 then return false end
return stroke:FindFirstChildOfClass("UIGradient")~=nil
end
local function menuColors()
local seen,found,gradients={},false,{}
local walked={}
local total=15000
local function add(color) if typeof(color)=="Color3" then seen[hexOf(color)]=true end end
local sinceRest=0
local function walk(object,budget)
local stack={object}
while #stack>0 and budget>0 and total>0 do
local current=table.remove(stack)
budget=budget-1;total=total-1
sinceRest=sinceRest+1
if sinceRest>=400 then sinceRest=0;task.wait() end
if walked[current] or (current~=object and ours(current.Name)) then
else
walked[current]=true
if current:IsA("GuiObject") then
found=true
if current:IsA("GuiButton") and looksBig(current) then bigButtonsSeen[current]=true end
add(current.BackgroundColor3)
if current:IsA("ImageLabel") or current:IsA("ImageButton") then add(current.ImageColor3) end
elseif current:IsA("UIStroke") then add(current.Color)
elseif current:IsA("UIGradient") then
for _,point in ipairs(current.Color.Keypoints) do add(point.Value) end
if #gradients<400 then gradients[#gradients+1]=colorSet(current.Color) end
end
for _,child in ipairs(current:GetChildren()) do stack[#stack+1]=child end
end
end
end
for _,root in ipairs(guiRoots()) do
local okChildren,children=pcall(function() return root:GetChildren() end)
local gameGui=root:IsA("PlayerGui")
for _,gui in ipairs(okChildren and children or {}) do
pcall(function()
if ours(gui.Name) or ROBLOX_GUIS[gui.Name] or gui.Name:sub(1,6)=="Roblox" then return end
if gameGui and gui.Name:sub(1,1)~="@" then return end
if gui:IsA("LayerCollector") or gui:IsA("Folder") then walk(gui,6000) end
end)
if total<=0 then break end
end
end
return seen,found,gradients
end
local function odhButtonGradients()
local list={}
local buttons={}
for _,root in ipairs(guiRoots()) do
pcall(function()
local storageGui=root:FindFirstChild("@BBStorage")
if not storageGui then return end
for _,button in ipairs(storageGui:GetChildren()) do
if not ours(button.Name) and button:IsA("GuiButton") then buttons[button]=true end
end
end)
end
for button in pairs(bigButtonsSeen) do
if button.Parent then buttons[button]=true else bigButtonsSeen[button]=nil end
end
for button in pairs(buttons) do
pcall(function()
local stroke=button:FindFirstChildOfClass("UIStroke")
local gradient=stroke and stroke:FindFirstChildOfClass("UIGradient") or button:FindFirstChildOfClass("UIGradient")
if gradient then
local colors=colorSet(gradient.Color)
if colors.count>=1 and not sameColors(colors,TEMPLATE_SET) and not sameColors(colors,GOLD_SET) then
list[#list+1]={sequence=gradient.Color,colors=colors}
end
end
end)
end
return list
end
local saved={at=-math.huge,pick=nil}
local function savedPick(themes)
if os.clock()-saved.at<15 then
for _,theme in ipairs(themes) do if theme.name==saved.pick then return theme end end
return nil
end
saved.at=os.clock();saved.pick=nil
local listFiles=type(listfiles)=="function" and listfiles or env.listfiles
local readFile=type(readfile)=="function" and readfile or env.readfile
local isFolder=type(isfolder)=="function" and isfolder or env.isfolder
if type(listFiles)~="function" or type(readFile)~="function" then return nil end
local found,checked={},0
local function look(folder,depth)
local ok,files=pcall(listFiles,folder)
if not ok or type(files)~="table" then return end
for _,path in ipairs(files) do
checked=checked+1
if checked>200 then return end
local lower=type(path)=="string" and path:lower() or ""
local okFolder,folderLike=false,false
if type(isFolder)=="function" then okFolder,folderLike=pcall(isFolder,path) end
if plainName(path):find("uicustomization",1,true) and lower:match("%.json$") then
elseif okFolder and folderLike==true then
if depth<3 then look(path,depth+1) end
elseif lower:match("%.json$") or lower:match("%.txt$") or lower:match("%.cfg$") or lower:match("%.ini$") or not lower:match("%.%w+$") then
local okRead,text=pcall(readFile,path)
if okRead and type(text)=="string" and #text<100000 then
for _,theme in ipairs(themes) do
local name=theme.name
if text==name or text:find('"'..name..'"',1,true) or text:find("'"..name.."'",1,true)
or text:find(name..".json",1,true) then
found[theme]=true
end
end
end
end
end
end
look(themePlace.root or "Ixry Shizuka",0)
local pick,count=nil,0
for theme in pairs(found) do pick=theme;count=count+1 end
if count==1 then saved.pick=pick.name;return pick end
return nil
end
style.themeDiagnostics={}
local function shows(colors,theme) return sameColors(colors,theme.variantSet) or sameColors(colors,theme.secondarySet) end
local function pickTheme(themes)
style.themeDiagnostics={themes=#themes,scores={}}
if #themes==0 then
if next(bigButtonsSeen)==nil and os.clock()-(style.lookedAt or -math.huge)>15 then
style.lookedAt=os.clock()
menuColors()
end
return nil
end
local function only(matches)
local pick,count=nil,0
for theme in pairs(matches) do pick=theme;count=count+1 end
return count==1 and pick or nil
end
local fromButtons={}
for _,candidate in ipairs(odhButtonGradients()) do
for _,theme in ipairs(themes) do
if shows(candidate.colors,theme) then fromButtons[theme]=true end
end
end
local pick=only(fromButtons)
if pick then style.themeDiagnostics.by="odh buttons";return pick end
local seen,found,gradients=menuColors()
style.themeDiagnostics.menuFound=found
local best,bestHits,tied=nil,0,false
for _,theme in ipairs(themes) do
local count=0
for _,colors in ipairs(gradients) do if not bare(colors) and shows(colors,theme) then count=count+1 end end
if count>bestHits then best,bestHits,tied=theme,count,false elseif count==bestHits and count>0 then tied=true end
end
if best and not tied then style.themeDiagnostics.by="menu gradients";return best end
local shared={}
for _,theme in ipairs(themes) do
for hex in pairs(theme.colors) do shared[hex]=(shared[hex] or 0)+1 end
end
local tie=false
best,bestHits=nil,0
for _,theme in ipairs(themes) do
local score=0
for hex in pairs(theme.colors) do
if seen[hex] and shared[hex]==1 and hex~="000000" and hex~="FFFFFF" then score=score+1 end
end
style.themeDiagnostics.scores[theme.name]=score
if score>bestHits then best,bestHits,tie=theme,score,false
elseif score==bestHits and score>0 then tie=true end
end
if best and bestHits>=2 and not tie then style.themeDiagnostics.by="menu";return best end
local fromFile=savedPick(themes)
if fromFile then style.themeDiagnostics.by="settings file";return fromFile end
if (tie or tied) and style.settings.name then
for _,theme in ipairs(themes) do if theme.name==style.settings.name then return theme end end
end
if not found and #themes==1 then style.themeDiagnostics.by="only one";return themes[1] end
return nil
end
local function restyleAll()
for gradient,default in pairs(style.tracked) do
if gradient.Parent then pcall(function() gradient.Color=style.Sequence(default) end) else style.tracked[gradient]=nil end
end
for _,listener in ipairs(style.listeners) do pcall(listener) end
end
local function sequenceKey(sequence)
if typeof(sequence)~="ColorSequence" then return "" end
local parts={}
for _,point in ipairs(sequence.Keypoints) do parts[#parts+1]=string.format("%.3f:%s",point.Time,hexOf(point.Value)) end
return table.concat(parts,",")
end
local theme=nil
local function apply()
local mirrored=nil
local candidates=odhButtonGradients()
for _,candidate in ipairs(candidates) do
if theme and sameColors(candidate.colors,theme.gradientSet) then mirrored=candidate.sequence;break end
end
if not mirrored and not theme then
for _,candidate in ipairs(candidates) do
if not bare(candidate.colors) then mirrored=candidate.sequence;break end
end
end
local gradient=mirrored or (theme and sequenceOf(theme.gradient)) or nil
local signature=sequenceKey(gradient).."|"..tostring(theme and theme.name)
if signature==style.settings.signature then return end
style.settings={gradient=gradient,name=theme and theme.name or nil,mirrored=mirrored~=nil,signature=signature}
restyleAll()
end
local function refreshTheme()
local ok,themes=pcall(readThemes)
if not ok then style.themeDiagnostics={error=tostring(themes)};return end
theme=pickTheme(themes)
end
task.spawn(function()
task.wait(1)
local last=-math.huge
while runtimeAlive do
if os.clock()-last>=3 then last=os.clock();pcall(refreshTheme) end
pcall(apply)
task.wait(1)
end
end)
function style.Sequence(default)
if style.enabled then return style.Custom() end
return style.settings.gradient or default or GRADIENT
end
function style.Dim(sequence)
if typeof(sequence)~="ColorSequence" then return nil end
local points={}
for _,point in ipairs(sequence.Keypoints) do
local color=point.Value
points[#points+1]=ColorSequenceKeypoint.new(point.Time,Color3.new(color.R*0.6,color.G*0.6,color.B*0.6))
end
return ColorSequence.new(points)
end
function style.BindSequence(active,default)
local main=style.enabled and style.Custom() or style.settings.gradient
if active then return main or default end
return style.Dim(main) or default
end
function style.OnChange(listener) if type(listener)=="function" then style.listeners[#style.listeners+1]=listener end end
function style.Track(gradient,default)
style.tracked[gradient]=default or GRADIENT
pcall(function() gradient.Color=style.Sequence(default) end)
end
local function restyle() restyleAll() end
function style.SetEnabled(value)
style.enabled=value==true;SetCfg("vv2BigButtonGradientEnabled",style.enabled);restyle()
end
function style.SetColor(index,color)
if typeof(color)~="Color3" or not style.colors[index] then return end
style.colors[index]=color;SetCfg("vv2BigButtonGradient"..index,color);restyle()
end
function style.Reset()
style.enabled=false
style.colors={Color3.fromRGB(20,20,20),Color3.fromRGB(20,20,140),Color3.fromRGB(120,40,120)}
restyle()
end
runtime.BigButtonStyle=style
local textHidden={}
local textApplied=setmetatable({}, {__mode="k"})
local function applyText(button,hidden)
local alpha=hidden and 1 or 0
pcall(function()
if button:IsA("TextButton") or button:IsA("TextLabel") then button.TextTransparency=alpha end
local label=button:FindFirstChild("@Text")
if label and label:IsA("TextLabel") then label.TextTransparency=alpha end
end)
end
local function applyAllText()
local roots={}
local hidden=type(gethui)=="function" and gethui or env.gethui
if type(hidden)=="function" then local ok,root=pcall(hidden);if ok and typeof(root)=="Instance" then roots[#roots+1]=root end end
pcall(function() roots[#roots+1]=game:GetService("CoreGui") end)
roots[#roots+1]=LocalPlayer:FindFirstChildOfClass("PlayerGui")
for _,root in ipairs(roots) do
pcall(function()
for _,container in ipairs(root:GetChildren()) do
if container.Name=="@BBStorage" or container.Name=="@bindstorage" then
for _,button in ipairs(container:GetChildren()) do
local wanted=textHidden[button.Name]
if wanted~=nil and textApplied[button]~=wanted then
textApplied[button]=wanted
applyText(button,wanted)
end
end
end
end
end)
end
end
runtime.ButtonText={
SetHidden=function(ids,hidden)
for _,id in ipairs(ids) do textHidden[id]=hidden==true end
applyAllText()
end,
IsHidden=function(id) return textHidden[id]==true end,
}
task.spawn(function()
while runtimeAlive do
task.wait(0.3)
if next(textHidden) then pcall(applyAllText) end
end
end)
local screenRef=nil
local function wholeScreen()
if not (screenRef and screenRef.Parent) then
screenRef=nil
local playerGui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
if not playerGui then return nil end
local found=playerGui:FindFirstChild("WorldV2_ScreenSpot")
local gui=found and found:IsA("ScreenGui") and found or Instance.new("ScreenGui")
gui.Name="WorldV2_ScreenSpot"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
pcall(function() gui.ScreenInsets=Enum.ScreenInsets.None end)
gui.Parent=playerGui
screenRef=gui
end
local size=screenRef.AbsoluteSize
if size.X<=1 or size.Y<=1 then return nil end
return screenRef.AbsolutePosition,size
end
local function spotOf(gui)
local origin,size=wholeScreen()
if not origin or gui.AbsoluteSize.X<=0 then return nil end
local point=gui.AbsolutePosition+gui.AbsoluteSize*gui.AnchorPoint-origin
return UDim2.new(point.X/size.X,0,point.Y/size.Y,0)
end
local function containerPosition(gui,spot)
local origin,size=wholeScreen()
local parent=gui.Parent
if not origin or not parent or not parent:IsA("GuiBase2d") then return nil end
local box=parent.AbsoluteSize
if box.X<=1 or box.Y<=1 then return nil end
local point=origin+Vector2.new(spot.X.Scale*size.X+spot.X.Offset,spot.Y.Scale*size.Y+spot.Y.Offset)-parent.AbsolutePosition
return UDim2.new(point.X/box.X,0,point.Y/box.Y,0)
end
local function place(gui,spot)
local exact=containerPosition(gui,spot)
gui.Position=exact or spot
if exact then return end
local provisional=gui.Position
task.spawn(function()
for _=1,300 do
task.wait()
if not gui.Parent or gui.Position~=provisional then return end
local later=containerPosition(gui,spot)
if later then gui.Position=later;return end
end
end)
end
runtime.ScreenSpot={Of=spotOf,Place=place}
local STORAGE="@BBStorage"
local buttons={}
local spinner
local function roots()
local list={}
local function add(root)
if typeof(root)~="Instance" then return end
for _,existing in ipairs(list) do if existing==root then return end end
list[#list+1]=root
end
local hidden=type(gethui)=="function" and gethui or env.gethui
if type(hidden)=="function" then local ok,root=pcall(hidden);if ok then add(root) end end
pcall(function() add(game:GetService("CoreGui")) end)
add(LocalPlayer:FindFirstChildOfClass("PlayerGui"))
return list
end
local function storage()
local list=roots()
local parent=list[1]
if parent then
local ok,existing=pcall(function() return parent:FindFirstChild(STORAGE) end)
if ok and typeof(existing)=="Instance" and existing:IsA("LayerCollector") then return existing end
end
local gui=Instance.new("ScreenGui")
gui.Name=STORAGE
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
pcall(function() gui.ScreenInsets=Enum.ScreenInsets.None end)
if not (parent and pcall(function() gui.Parent=parent end) and gui.Parent) then
gui.Parent=LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
end
return gui
end
local function removeStale(id,keep)
for _,root in ipairs(roots()) do
pcall(function()
for _,container in ipairs(root:GetChildren()) do
if container.Name==STORAGE then
for _,child in ipairs(container:GetChildren()) do
if child.Name==id and child~=keep then child:Destroy() end
end
end
end
end)
end
end
local function spin()
if spinner then return end
spinner=RunService.RenderStepped:Connect(function()
if not runtimeAlive then spinner:Disconnect();spinner=nil;return end
for _,record in pairs(buttons) do
local gradient=record.gradient
if gradient and record.button.Visible then gradient.Rotation=(gradient.Rotation+1)%360 end
end
end)
end
local function readPosition(key,fallback)
local saved=key and C(key,nil)
if type(saved)=="table" then
local function n(value,default)
value=tonumber(value)
return value and value==value and value~=math.huge and value~=-math.huge and value or default
end
return UDim2.new(n(saved.xs or saved.XS,fallback.X.Scale),n(saved.xo or saved.XO,fallback.X.Offset),
n(saved.ys or saved.YS,fallback.Y.Scale),n(saved.yo or saved.YO,fallback.Y.Offset))
end
return fallback
end
local function savePosition(key,position)
if key then SetCfg(key,{xs=position.X.Scale,xo=position.X.Offset,ys=position.Y.Scale,yo=position.Y.Offset}) end
end
local function sizeOf(width,height)
width=math.clamp(tonumber(width) or 140,50,300)
height=tonumber(height) and math.clamp(tonumber(height),20,165) or width*0.375
return UDim2.fromOffset(width,height),math.max(9,math.floor(math.min(24*width/200,height*0.55)+0.5))
end
runtime.BigButtons={}
function runtime.BigButtons.Create(id,options)
local old=buttons[id]
if old then old.Destroy() end
local record={connections={},default=options.default or UDim2.new(0.5,0,0.5,0),positionKey=options.positionKey}
local button=Instance.new("TextButton")
button.Name=id
button.AnchorPoint=Vector2.new(0.5,0.5)
button.Position=readPosition(options.positionKey,record.default)
button.BackgroundColor3=Color3.fromRGB(255,255,255)
button.BackgroundTransparency=0.9
button.BorderSizePixel=0
button.Font=Enum.Font.Jura
button.Text=tostring(options.text or "")
button.TextColor3=Color3.fromRGB(255,255,255)
button.TextWrapped=true
button.ClipsDescendants=true
button.AutoButtonColor=false
button.ZIndex=5
record.button=button
record.width=math.clamp(tonumber(options.size) or 140,50,300)
record.height=tonumber(options.height)
button.Size,button.TextSize=sizeOf(record.width,record.height)
Instance.new("UICorner",button).CornerRadius=UDim.new(0,5)
local stroke=Instance.new("UIStroke")
stroke.Color=Color3.fromRGB(255,255,255)
stroke.Thickness=1.5
stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
stroke.Parent=button
local gradient=Instance.new("UIGradient")
gradient.Parent=stroke
style.Track(gradient,GRADIENT)
record.gradient=gradient
local ripple=Instance.new("Frame")
ripple.Name="@ripple"
ripple.BackgroundColor3=Color3.fromRGB(0,155,255)
ripple.BackgroundTransparency=0.5
ripple.ZIndex=4
ripple.Size=UDim2.fromOffset(0,0)
ripple.AnchorPoint=Vector2.new(0.5,0.5)
ripple.Visible=false
ripple.Parent=button
Instance.new("UICorner",ripple).CornerRadius=UDim.new(1,0)
local sound=Instance.new("Sound")
sound.SoundId="rbxassetid://3868133279"
ButtonAudio:Register(sound,0.5)
sound.Parent=button
local tweenInfo=TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local pressInput,dragInput,dragStart,startPosition
local moved=false
local function locked() return type(options.isLocked)=="function" and options.isLocked()==true end
local function sameInput(input)
if not pressInput then return false end
if input==pressInput then return true end
return pressInput.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1
end
table.insert(record.connections,button.InputBegan:Connect(function(input)
if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
if pressInput then return end
pressInput=input;moved=false;dragStart=input.Position;startPosition=button.Position
local size,textSize=sizeOf(record.width*1.1,record.height and record.height*1.1)
TweenService:Create(button,tweenInfo,{Size=size,TextSize=textSize}):Play()
local corner=button.AbsolutePosition
ripple.Position=UDim2.fromOffset(input.Position.X-corner.X,input.Position.Y-corner.Y)
ripple.Size=UDim2.fromOffset(0,0);ripple.BackgroundTransparency=0.5;ripple.Visible=true
pcall(function() sound:Play() end)
TweenService:Create(ripple,TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),
{Size=UDim2.fromOffset(300,300),BackgroundTransparency=1}):Play()
end))
table.insert(record.connections,button.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end))
table.insert(record.connections,UserInputService.InputChanged:Connect(function(input)
if not pressInput or (input~=dragInput and input~=pressInput) or locked() then return end
local delta=input.Position-dragStart
if delta.Magnitude>7 then moved=true end
if moved then
button.Position=UDim2.new(startPosition.X.Scale,startPosition.X.Offset+delta.X,startPosition.Y.Scale,startPosition.Y.Offset+delta.Y)
end
end))
table.insert(record.connections,UserInputService.InputEnded:Connect(function(input)
if not sameInput(input) then return end
pressInput=nil
local size,textSize=sizeOf(record.width,record.height)
TweenService:Create(button,tweenInfo,{Size=size,TextSize=textSize}):Play()
if moved and not locked() then
savePosition(record.positionKey,spotOf(button) or button.Position)
elseif not moved and button.Visible and type(options.onClick)=="function" then
task.spawn(function()
local ok,err=pcall(options.onClick)
if not ok then warn("[World V2] "..id..": "..tostring(err)) end
end)
end
end))
button.Parent=storage()
place(button,button.Position)
removeStale(id,button)
function record.SetText(text) button.Text=tostring(text or "") end
function record.SetSize(width)
record.width=math.clamp(tonumber(width) or record.width,50,300)
if not pressInput then button.Size,button.TextSize=sizeOf(record.width,record.height) end
end
function record.SetHeight(height)
record.height=tonumber(height)
if not pressInput then button.Size,button.TextSize=sizeOf(record.width,record.height) end
end
function record.SetPosition(position) place(button,position);savePosition(record.positionKey,position) end
function record.SetTextHidden(value) button.TextTransparency=value and 1 or 0 end
function record.SetVisible(value) button.Visible=value==true;if not button.Visible then pressInput=nil end end
function record.ResetPosition()
place(button,record.default)
savePosition(record.positionKey,record.default)
end
function record.Alive() return button.Parent~=nil and buttons[id]==record end
function record.Destroy()
for _,connection in ipairs(record.connections) do pcall(function() connection:Disconnect() end) end
table.clear(record.connections)
pcall(function() button:Destroy() end)
if buttons[id]==record then buttons[id]=nil end
end
buttons[id]=record
spin()
return record
end
runtime.RegisterReset(function()
if runtimeAlive then return end
for _,record in pairs(buttons) do pcall(record.Destroy) end
end)
end,"Part at line 5460")
local lockBigButtonPos,lockBindButtonPos,speedButton,BIG_BUTTON_DEFAULT,BIND_BUTTON_DEFAULT,loadStoredPosition,saveStoredPosition,BindableButtons,setupSpeedButtons
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local speedSection = mainTab:AddSection("Speed Glitch", "Utilities")
speedSection:AddParagraph(
"Speed Glitch",
"Only works while Shift Lock is active. Using very high speeds for a fairly long period of time may cause the game to kick you."
)
local speedEnabled = C("speedGlitchEnabled", false)
local speedValue = C("speedValue", 50)
local speedButtonVisible = C("speedButtonVisible", false)
local speedHideText = C("speedHideText", false)==true
local speedButtonWidth = math.clamp(tonumber(C("speedBigButtonSize", 140)) or 140, 50, 300)
local speedBindButtonVisible = C("speedBindButtonVisible", false)
local speedBindButtonSize = math.clamp(tonumber(C("speedBindButtonScale", 11)) or 11, 5, 25)
lockBigButtonPos = C("lockBigButtonPos", false)
lockBindButtonPos = C("lockBindButtonPos", false)
local speedGui, speedToggle
BIG_BUTTON_DEFAULT = UDim2.new(0.5, 0, 0.5, 0)
BIND_BUTTON_DEFAULT = UDim2.new(0.10, 0, 0.90, 0)
function loadStoredPosition(key, fallback)
local data = C(key, nil)
if type(data) ~= "table" then
SetCfg(key, {
xs = fallback.X.Scale,
xo = fallback.X.Offset,
ys = fallback.Y.Scale,
yo = fallback.Y.Offset,
})
return fallback
end
return UDim2.new(
tonumber(data.xs or data.XS) or fallback.X.Scale,
tonumber(data.xo or data.XO) or fallback.X.Offset,
tonumber(data.ys or data.YS) or fallback.Y.Scale,
tonumber(data.yo or data.YO) or fallback.Y.Offset
)
end
function saveStoredPosition(key, pos)
SetCfg(key, {
xs = pos.X.Scale,
xo = pos.X.Offset,
ys = pos.Y.Scale,
yo = pos.Y.Offset,
})
end
BindableButtons = (function()
local buttons = {Buttons={}, Maids={}, Locked={}, Callbacks={}, Count=0}
local shapes = {
[0] = "rbxassetid://86221076925479",
[1] = "rbxassetid://96242665417546",
[2] = "rbxassetid://97129189935336",
[3] = "rbxassetid://76165862027868",
[4] = "rbxassetid://125868092127496",
}
local normalColor = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.new(0.133333, 0.827451, 0.494118)),
ColorSequenceKeypoint.new(0.6, Color3.new(0.231373, 0.509804, 0.498039)),
ColorSequenceKeypoint.new(1, Color3.new(0.501961, 0.501961, 0.501961)),
})
local toggledColor = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.new(0.0784314, 0.0784314, 0.0784314)),
ColorSequenceKeypoint.new(0.75, Color3.new(0.0784314, 0.0784314, 0.54902)),
ColorSequenceKeypoint.new(1, Color3.new(0.470588, 0.156863, 0.470588)),
})
local function bindColor(state)
local default=state and toggledColor or normalColor
local buttonStyle=env.WorldV2Runtime.BigButtonStyle
if buttonStyle and type(buttonStyle.BindSequence)=="function" then
local ok,sequence=pcall(buttonStyle.BindSequence,state==true,default)
if ok and typeof(sequence)=="ColorSequence" then return sequence end
end
return default
end
local function storage()
local roots={}
if type(gethui)=="function" then
local ok,result=pcall(gethui)
if ok and typeof(result)=="Instance" then table.insert(roots,result) end
end
local okCore,core=pcall(function() return game:GetService("CoreGui") end)
if okCore and typeof(core)=="Instance" then table.insert(roots,core) end
local pg=player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")
table.insert(roots,pg)
for _,root in ipairs(roots) do
local ok,existing=pcall(function() return root:FindFirstChild("@bindstorage") end)
if ok and typeof(existing)=="Instance" and existing:IsA("ScreenGui") then return existing end
end
local sg=Instance.new("ScreenGui")
sg.Name="@bindstorage"
sg.ResetOnSpawn=false
sg.IgnoreGuiInset=true
pcall(function() sg.ScreenInsets=Enum.ScreenInsets.None end)
sg.Parent=pg
return sg
end
function buttons:DeleteBButton(id)
local maid=self.Maids[id]
if maid then
for _,item in ipairs(maid) do
if typeof(item)=="RBXScriptConnection" then pcall(function() item:Disconnect() end)
elseif typeof(item)=="Instance" then pcall(function() item:Destroy() end) end
end
end
local b=self.Buttons[id]
if b then pcall(function() b:Destroy() end) end
self.Buttons[id],self.Maids[id],self.Locked[id],self.Callbacks[id]=nil,nil,nil,nil
end
function buttons:SetShape(id,shape)
local b=self.Buttons[id]
if b and shapes[shape] then b.Image=shapes[shape] end
end
function buttons:SetLocked(id,state) self.Locked[id]=not not state end
function buttons:SetVisible(id,state) local b=self.Buttons[id]; if b then b.Visible=not not state end end
function buttons:SetText(id,text) local b=self.Buttons[id]; local l=b and b:FindFirstChild("@Text"); if l then l.Text=tostring(text or "") end end
function buttons:SetPosition(id,pos)
local b=self.Buttons[id]; if not b then return end
local spots=env.WorldV2Runtime.ScreenSpot
if spots then spots.Place(b,pos) else b.Position=pos end
end
function buttons:GetPosition(id)
local b=self.Buttons[id]; if not b then return nil end
local spots=env.WorldV2Runtime.ScreenSpot
return spots and spots.Of(b) or b.Position
end
function buttons:SetSize(id,level)
local b=self.Buttons[id]; if not b then return end
level=math.clamp(tonumber(level) or 2,1,10)
local px=14+((level-1)*4)
b.Size=UDim2.fromOffset(px,px)
local label=b:FindFirstChild("@Text")
if label and label:IsA("TextLabel") then
label.TextSize=math.clamp(math.floor(px*0.34),6,10)
end
end
function buttons:SetValue(id,state,runCallback)
local b=self.Buttons[id]; if not b then return end
local value=b:FindFirstChild("BindValue")
if not value then return end
state=not not state
if value.Value~=state then
value.Value=state
if runCallback then
local callbacks=self.Callbacks[id]
if callbacks then
if state then pcall(callbacks[1]) else pcall(callbacks[2]) end
end
end
end
local stroke=b:FindFirstChild("@Stroke")
if stroke and stroke:IsA("UIGradient") then stroke.Color=bindColor(state) end
end
function buttons.AddBButton(id,text,onFunc,offFunc,onMoved)
buttons:DeleteBButton(id)
local root=storage()
local old=root:FindFirstChild(id)
if old then old:Destroy() end
local cameraNow=workspace.CurrentCamera
local screen=cameraNow and cameraNow.ViewportSize or Vector2.new(1920,1080)
local buttonSizeY=0.11
local widthScale=buttonSizeY*(screen.Y/math.max(1,screen.X))
local xPos=0.1+((buttons.Count%8)*(widthScale+0.005))
local yPos=0.9-(math.floor(buttons.Count/8)*(buttonSizeY+0.015))
local b=Instance.new("ImageButton")
b.Name=id
b.Size=UDim2.new(widthScale,0,buttonSizeY,0)
b.Position=UDim2.new(xPos,0,yPos,0)
b.AnchorPoint=Vector2.new(0.5,0.5)
b.Image=shapes[0]
b.BackgroundTransparency=1
b.BorderSizePixel=0
b.ClipsDescendants=false
b.AutoButtonColor=false
b.Parent=root
local value=Instance.new("BoolValue")
value.Name="BindValue"
value.Parent=b
local label=Instance.new("TextLabel")
label.Name="@Text"
label.Size=UDim2.fromScale(0.8,0.8)
label.Position=UDim2.fromScale(0.5,0.5)
label.AnchorPoint=Vector2.new(0.5,0.5)
label.BackgroundTransparency=1
label.Font=Enum.Font.Jura
label.Text=tostring(text or "")
label.TextColor3=Color3.new(1,1,1)
label.TextSize=10
label.TextWrapped=true
label.ZIndex=3
label.Parent=b
local aspect=Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio=1
aspect.AspectType=Enum.AspectType.ScaleWithParentSize
aspect.Parent=b
local stroke=Instance.new("UIGradient")
stroke.Name="@Stroke"
stroke.Color=bindColor(false)
stroke.Parent=b
local ripple=Instance.new("Frame")
ripple.Name="@ripple"
ripple.BackgroundColor3=Color3.fromRGB(0,155,255)
ripple.BackgroundTransparency=0.5
ripple.Size=UDim2.fromOffset(0,0)
ripple.AnchorPoint=Vector2.new(0.5,0.5)
ripple.Visible=false
ripple.ZIndex=2
ripple.Parent=b
Instance.new("UICorner",ripple).CornerRadius=UDim.new(1,0)
local sound=Instance.new("Sound")
sound.SoundId="rbxassetid://3868133279"
ButtonAudio:Register(sound,0.5)
sound.Parent=b
buttons.Buttons[id]=b
buttons.Maids[id]={}
buttons.Locked[id]=false
buttons.Callbacks[id]={onFunc,offFunc}
buttons.Count=buttons.Count+1
local dragging=false
local dragInput,dragStart,startPos,pressInput
local moved=false
local debounce=false
local conns=buttons.Maids[id]
local function click()
if debounce then return end
debounce=true
local fadeOut=TweenService:Create(b,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{ImageTransparency=1})
fadeOut:Play(); fadeOut.Completed:Wait()
value.Value=not value.Value
stroke.Color=bindColor(value.Value)
if value.Value then pcall(onFunc) else pcall(offFunc) end
local baseAlpha=tonumber(b:GetAttribute("VisualsV2BaseImageTransparency")) or 0
local fadeIn=TweenService:Create(b,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{ImageTransparency=baseAlpha})
fadeIn:Play(); fadeIn.Completed:Wait()
debounce=false
end
table.insert(conns,b.InputBegan:Connect(function(input)
if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
if dragging then return end
dragging=true; moved=false; dragStart=input.Position; startPos=b.Position; pressInput=input
pcall(function() sound:Play() end)
local abs=b.AbsolutePosition
ripple.Position=UDim2.fromOffset(input.Position.X-abs.X,input.Position.Y-abs.Y)
ripple.Size=UDim2.fromOffset(0,0); ripple.BackgroundTransparency=0.5; ripple.Visible=true
TweenService:Create(ripple,TweenInfo.new(0.4,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(45,45),BackgroundTransparency=1}):Play()
end))
table.insert(conns,b.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end))
table.insert(conns,UserInputService.InputChanged:Connect(function(input)
if input~=dragInput or not dragging or buttons.Locked[id] then return end
local delta=input.Position-dragStart
if delta.Magnitude>7 then moved=true end
if not moved then return end
local parentSize=b.Parent.AbsoluteSize
if parentSize.X>0 and parentSize.Y>0 then
b.Position=UDim2.new(startPos.X.Scale+(delta.X/parentSize.X),0,startPos.Y.Scale+(delta.Y/parentSize.Y),0)
end
end))
table.insert(conns,UserInputService.InputEnded:Connect(function(input)
if not dragging then return end
if input~=pressInput and not (input.UserInputType==Enum.UserInputType.MouseButton1
and pressInput and pressInput.UserInputType==Enum.UserInputType.MouseButton1) then return end
dragging=false;pressInput=nil
if moved and not buttons.Locked[id] then
if onMoved then local spots=env.WorldV2Runtime.ScreenSpot;pcall(onMoved,spots and spots.Of(b) or b.Position) end
elseif not moved then
task.spawn(click)
end
end))
table.insert(conns,RunService.RenderStepped:Connect(function() stroke.Rotation=(stroke.Rotation+1)%360 end))
return value
end
local buttonStyle=env.WorldV2Runtime.BigButtonStyle
if buttonStyle and type(buttonStyle.OnChange)=="function" then
buttonStyle.OnChange(function()
for _,b in pairs(buttons.Buttons) do
local stroke=b:FindFirstChild("@Stroke")
local value=b:FindFirstChild("BindValue")
if stroke and stroke:IsA("UIGradient") then stroke.Color=bindColor(value and value.Value) end
end
end)
end
return buttons
end)()
local function updateSpeedButtonStyle()
if speedGui then
speedGui.SetSize(speedButtonWidth)
speedGui.SetText("Speed Glitch\n"..(speedEnabled and "On" or "Off"))
pcall(speedGui.SetTextHidden,speedHideText)
speedGui.SetVisible(speedButtonVisible)
end
local id="VisualsV2_SpeedBind"
BindableButtons:SetVisible(id,speedBindButtonVisible)
BindableButtons:SetLocked(id,lockBindButtonPos)
local b=BindableButtons.Buttons[id]
if b then
local camera=workspace.CurrentCamera
local screen=camera and camera.ViewportSize or Vector2.new(1920,1080)
if screen.X<=1 or screen.Y<=1 then screen=Vector2.new(1920,1080) end
local size=speedBindButtonSize/100
b.Size=UDim2.new(size*(screen.Y/screen.X),0,size,0)
end
BindableButtons:SetText(id,"SG")
BindableButtons:SetValue(id,speedEnabled,false)
end
local speedChangeSource=nil
local speedMenuOffAt=-math.huge
local function setSpeedState(state,source)
if state and source~="menu" and os.clock()-speedMenuOffAt<0.6 then return end
speedChangeSource=source or "button"
if speedToggle then speedToggle:Set(state) end
speedChangeSource=nil
end
function setupSpeedButtons()
if speedGui and speedGui.Alive() and BindableButtons.Buttons["VisualsV2_SpeedBind"]
and BindableButtons.Buttons["VisualsV2_SpeedBind"].Parent then
updateSpeedButtonStyle()
return
end
if speedGui then speedGui.Destroy() end
speedGui=env.WorldV2Runtime.BigButtons.Create("VisualsV2_SpeedGlitchBig",{
text="Speed Glitch",
size=speedButtonWidth,
positionKey="speedButtonPosition",
default=BIG_BUTTON_DEFAULT,
isLocked=function() return lockBigButtonPos end,
onClick=function() setSpeedState(not speedEnabled,"big") end,
})
speedButton=speedGui.button
pcall(function()
local old=player:FindFirstChildOfClass("PlayerGui"):FindFirstChild("VisualsV2_SpeedGlitchUI")
if old then old:Destroy() end
end)
BindableButtons:DeleteBButton("VisualsV2_SpeedBind")
BindableButtons.AddBButton(
"VisualsV2_SpeedBind",
"SG",
function() setSpeedState(true,"bind") end,
function() setSpeedState(false,"bind") end,
function(pos) saveStoredPosition("speedBindButtonPosition",pos) end
)
BindableButtons:SetPosition("VisualsV2_SpeedBind",loadStoredPosition("speedBindButtonPosition",BIND_BUTTON_DEFAULT))
updateSpeedButtonStyle()
end
speedToggle=addToggle(speedSection,"Enable Speed Glitch",speedEnabled,function(state)
if not speedChangeSource and not state then speedMenuOffAt=os.clock() end
speedEnabled=state
SetCfg("speedGlitchEnabled",state)
updateSpeedButtonStyle()
end)
speedSection:AddSlider("Speed",1,300,speedValue,function(value)
speedValue=value
SetCfg("speedValue",value)
end)
local speedKeyName=tostring(C("speedGlitchKeybind","G"))
local speedKeyCode
pcall(function() speedKeyCode=Enum.KeyCode[speedKeyName] end)
if not speedKeyCode or speedKeyCode==Enum.KeyCode.Unknown then
speedKeyName="G"
speedKeyCode=Enum.KeyCode.G
SetCfg("speedGlitchKeybind",speedKeyName)
end
local speedKeybindOn=C("speedGlitchKeybindEnabled",true)==true
local speedKeyConnection
addToggle(speedSection,"Enable Speed Glitch Keybind",speedKeybindOn,function(state)
speedKeybindOn=state;SetCfg("speedGlitchKeybindEnabled",state)
end)
speedSection:AddKeybind("Speed Glitch Keybind",speedKeyName,function()
if runtimeAlive and speedKeybindOn then setSpeedState(not speedEnabled,"key") end
end)
addToggle(speedSection,"Show Big Button",speedButtonVisible,function(state)
speedButtonVisible=state; SetCfg("speedButtonVisible",state); updateSpeedButtonStyle()
end)
local speedHideToggle=addToggle(speedSection,"Hide Button Text",speedHideText,function(state)
speedHideText=state; SetCfg("speedHideText",state); updateSpeedButtonStyle()
end)
addToggle(speedSection,"Show Bindable Button",speedBindButtonVisible,function(state)
speedBindButtonVisible=state; SetCfg("speedBindButtonVisible",state); updateSpeedButtonStyle()
end)
speedSection:AddSlider("Big Button Size",50,300,speedButtonWidth,function(value)
speedButtonWidth=math.clamp(tonumber(value) or 140,50,300)
SetCfg("speedBigButtonSize",speedButtonWidth)
updateSpeedButtonStyle()
end)
speedSection:AddSlider("Bind Button Size",5,25,speedBindButtonSize,function(value)
speedBindButtonSize=math.clamp(tonumber(value) or 11,5,25)
SetCfg("speedBindButtonScale",speedBindButtonSize)
updateSpeedButtonStyle()
end)
speedSection:AddButton("Reset Bind Button Position",function()
saveStoredPosition("speedBindButtonPosition",BIND_BUTTON_DEFAULT)
BindableButtons:SetPosition("VisualsV2_SpeedBind",BIND_BUTTON_DEFAULT)
end)
speedSection:AddButton("Reset Big Button Position",function()
if speedGui and speedGui.Alive() then speedGui.ResetPosition()
else SetCfg("speedButtonPosition",{xs=BIG_BUTTON_DEFAULT.X.Scale,xo=BIG_BUTTON_DEFAULT.X.Offset,ys=BIG_BUTTON_DEFAULT.Y.Scale,yo=BIG_BUTTON_DEFAULT.Y.Offset}) end
end)
setupSpeedButtons()
local function shiftLockActive()
return UserInputService.MouseBehavior==Enum.MouseBehavior.LockCenter
end
local speedLoop
speedLoop=RunService.Heartbeat:Connect(function()
if not runtimeAlive then speedLoop:Disconnect();return end
if not speedEnabled then return end
local char=player.Character
local humanoid=char and char:FindFirstChildOfClass("Humanoid")
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if speedEnabled and shiftLockActive() and humanoid and hrp and humanoid.FloorMaterial==Enum.Material.Air then
local moveDir=humanoid.MoveDirection
if moveDir.Magnitude>0 then
local vel=hrp.AssemblyLinearVelocity
hrp.AssemblyLinearVelocity=Vector3.new(moveDir.X*speedValue,vel.Y,moveDir.Z*speedValue)
end
end
end)
env.WorldV2Runtime.RegisterReset(function()
if speedKeyConnection then speedKeyConnection:Disconnect(); speedKeyConnection=nil end
speedToggle:Set(false)
speedEnabled=false
speedButtonVisible=false
speedBindButtonVisible=false
speedHideToggle:Set(false)
speedHideText=false
lockBigButtonPos=false
lockBindButtonPos=false
speedButtonWidth=140
speedBindButtonSize=11
if speedGui and runtimeAlive then speedGui.ResetPosition();speedGui.SetVisible(false) end
BindableButtons:SetPosition("VisualsV2_SpeedBind",BIND_BUTTON_DEFAULT)
BindableButtons:SetVisible("VisualsV2_SpeedBind",false)
BindableButtons:SetLocked("VisualsV2_SpeedBind",false)
updateSpeedButtonStyle()
end)
end,"Section \"Speed Glitch\"")
;w2Section(function()
if not inMurderMystery then return end
local runtime=env.WorldV2Runtime
local section=mainTab:AddSection("Fake Haste","Utilities")
-- Fake Haste: with your knife out, your walk speed goes 2 above your normal speed (16 to 18), 3 with
-- Blatant on (19). Only the murderer has a knife in Classic, and everyone does in Assassin, so it works
-- in both. It's added on top of whatever speed the game gives you, so a speed that isn't exactly 16
-- still gets it; a frozen or slowed speed (under 10, like at the start of a round) is left alone, and
-- your own speed comes back as soon as the knife is put away or it's turned off.
local HASTE_BOOST,BLATANT_BOOST,LOWEST=2,3,10
local state={
on=C("fakeHasteEnabled",false)==true,
blatant=C("fakeHasteBlatantEnabled",false)==true,
applied=nil,base=nil,humanoid=nil,watch=nil,toolWatch={},
}
local function wanted()
if state.blatant then return BLATANT_BOOST end
if state.on then return HASTE_BOOST end
return nil
end
-- (speeds are kept slightly rounded, so they're compared with a little room)
local function near(a,b) return a~=nil and b~=nil and math.abs(a-b)<0.01 end
-- (the knife counts as out only while it's in your hand: its handle attached to your hand, the way
-- Roblox holds a tool. A knife that's on your character but not held, like one carried on your back,
-- doesn't count)
local function isKnife(tool)
if tool.Name=="Knife" or tool.Name:lower():find("knife",1,true) or tool:GetAttribute("IsKnife")==true then return true end
local kinds=runtime.ClientWeaponSkins
if kinds and type(kinds.GetKind)=="function" then
local ok,kind=pcall(kinds.GetKind,tool)
if ok and kind=="Knife" then return true end
end
return false
end
local function joins(container,a,b)
for _,item in ipairs(container:GetChildren()) do
if item:IsA("JointInstance") or item:IsA("WeldConstraint") then
local ok,p0,p1=pcall(function() return item.Part0,item.Part1 end)
if ok and ((p0==a and p1==b) or (p0==b and p1==a)) then return true end
end
end
return false
end
local function inHand(character,tool)
local handle=tool:FindFirstChild("Handle")
if not handle or not handle:IsA("BasePart") then return true end
for _,name in ipairs({"RightHand","Right Arm","LeftHand","Left Arm"}) do
local hand=character:FindFirstChild(name)
if hand and (joins(hand,hand,handle) or joins(handle,hand,handle)) then return true end
end
return false
end
local function knifeEquipped()
local character=LocalPlayer.Character
if not character then return false end
for _,tool in ipairs(character:GetChildren()) do
if tool:IsA("Tool") and isKnife(tool) and inHand(character,tool) then return true end
end
return false
end
-- Haste's own look, as the game shows the Haste perk: a light blue trail down your back from the
-- neck to the waist, fading out over half a second. Shown on your screen only, while Fake Haste
-- has your speed up. The game keeps its own HasteTrail on your character even when you run another
-- perk (switched off), so that one is switched on for you; it's only left alone when the game itself
-- has it on (you really have Haste). Without one, a copy of it is made.
local function gameTrail(character)
for _,item in ipairs(character:GetDescendants()) do
if item.Name=="HasteTrail" and item:IsA("Trail") then return item end
end
return nil
end
local function removeTrail()
if state.trail then pcall(function() state.trail:Destroy() end) end
for _,attachment in ipairs(state.trailAttachments or {}) do pcall(function() attachment:Destroy() end) end
state.trail,state.trailAttachments=nil,nil
if state.litGame then
local lit=state.litGame
state.litGame=nil
pcall(function() lit.Enabled=false end)
end
end
local function showTrail()
local character=LocalPlayer.Character
local torso=character and (character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
if not torso then removeTrail();return end
local theirs=gameTrail(character)
if theirs then
if state.litGame==theirs then
if not theirs.Enabled then pcall(function() theirs.Enabled=true end) end
return
end
if state.trail then pcall(function() state.trail:Destroy() end) end
for _,attachment in ipairs(state.trailAttachments or {}) do pcall(function() attachment:Destroy() end) end
state.trail,state.trailAttachments=nil,nil
-- (already on by the game: your real Haste, nothing to add)
if theirs.Enabled then return end
pcall(function() theirs.Enabled=true end)
if theirs.Enabled then state.litGame=theirs;return end
end
if state.trail and state.trail.Parent==torso then return end
removeTrail()
local made={}
local function point(names,offset)
for _,name in ipairs(names) do
local found=torso:FindFirstChild(name)
if found and found:IsA("Attachment") then return found end
end
local attachment=Instance.new("Attachment")
attachment.Name="W2_FakeHasteAttachment";attachment.Position=offset;attachment.Parent=torso
made[#made+1]=attachment
return attachment
end
local trail=Instance.new("Trail")
trail.Name="W2_FakeHasteTrail"
trail.Attachment0=point({"NeckAttachment"},Vector3.new(0,1,0))
trail.Attachment1=point({"WaistRigAttachment","WaistCenterAttachment"},Vector3.new(0,-1,0))
trail.Color=ColorSequence.new(Color3.new(0.7254902,0.9411765,1))
trail.Transparency=NumberSequence.new(0.5,1)
trail.WidthScale=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5017,0.74375),NumberSequenceKeypoint.new(1,0.2375)})
trail.Lifetime=0.5;trail.MinLength=0.1;trail.MaxLength=0
trail.FaceCamera=false;trail.LightEmission=0;trail.LightInfluence=1
trail.TextureLength=1;trail.TextureMode=Enum.TextureMode.Stretch
pcall(function() trail.Brightness=1 end)
trail.Enabled=true
trail.Parent=torso
state.trail,state.trailAttachments=trail,made
end
local function update()
local humanoid=state.humanoid
if not humanoid or not humanoid.Parent or humanoid.Health<=0 then state.applied=nil;removeTrail();return end
local boost=wanted()
local current=humanoid.WalkSpeed
local function set(speed)
pcall(function() humanoid.WalkSpeed=speed end)
state.applied=humanoid.WalkSpeed
end
if boost and runtimeAlive and knifeEquipped() then
if state.applied and near(current,state.applied) then
-- (still ours: only changed when Blatant is switched)
if state.base and not near(state.base+boost,state.applied) then set(state.base+boost) end
elseif current>=LOWEST then
-- (the game set your speed: haste goes on top of it)
state.base=current
set(current+boost)
else
state.applied,state.base=nil,nil
end
elseif state.applied then
if near(current,state.applied) and state.base then pcall(function() humanoid.WalkSpeed=state.base end) end
state.applied,state.base=nil,nil
end
if state.applied and near(humanoid.WalkSpeed,state.applied) then pcall(showTrail) else removeTrail() end
end
local function bind(character)
if state.watch then state.watch:Disconnect();state.watch=nil end
for _,connection in ipairs(state.toolWatch) do connection:Disconnect() end
table.clear(state.toolWatch)
state.humanoid,state.applied,state.base=nil,nil,nil
removeTrail()
local humanoid=character and (character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid",10))
if not humanoid or LocalPlayer.Character~=character then return end
state.humanoid=humanoid
state.watch=humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function() task.defer(update) end)
-- (the knife going in or out of your hand switches it at once)
local function toolChanged(child) if child:IsA("Tool") then task.defer(update) end end
state.toolWatch[1]=character.ChildAdded:Connect(toolChanged)
state.toolWatch[2]=character.ChildRemoved:Connect(toolChanged)
-- (and the grip in your hand being made or removed)
for _,name in ipairs({"RightHand","Right Arm","LeftHand","Left Arm"}) do
local hand=character:FindFirstChild(name)
if hand then
local function gripChanged(child) if child:IsA("JointInstance") or child:IsA("WeldConstraint") then task.defer(update) end end
state.toolWatch[#state.toolWatch+1]=hand.ChildAdded:Connect(gripChanged)
state.toolWatch[#state.toolWatch+1]=hand.ChildRemoved:Connect(gripChanged)
end
end
update()
end
local spawned=LocalPlayer.CharacterAdded:Connect(function(character) task.spawn(bind,character) end)
if LocalPlayer.Character then task.spawn(bind,LocalPlayer.Character) end
-- (roles change without the speed changing: looked at a few times a second)
task.spawn(function()
while runtimeAlive do
if wanted() or state.applied then pcall(update) end
task.wait(0.25)
end
end)
local hasteToggle=addToggle(section,"Enable Fake Haste",state.on,function(on)
state.on=on;SetCfg("fakeHasteEnabled",on);update()
end)
local blatantToggle=addToggle(section,"Enable Fake Haste (Blatant)",state.blatant,function(on)
state.blatant=on;SetCfg("fakeHasteBlatantEnabled",on);update()
end)
runtime.RegisterReset(function()
hasteToggle:Set(false);blatantToggle:Set(false)
state.on,state.blatant=false,false
pcall(update)
removeTrail()
if not runtimeAlive then
spawned:Disconnect()
if state.watch then state.watch:Disconnect();state.watch=nil end
for _,connection in ipairs(state.toolWatch) do connection:Disconnect() end
table.clear(state.toolWatch)
end
end)
end,"Section \"Fake Haste\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local userWantsEnabled = C("aaEnabled",false)
local enabled = false
local velocityConnection = nil
local hadKnifeLastFrame = false
local ignoreListEnabled = C("aaIgnoreListEnabled",true)
local slot1Player = nil
local slot2Player = nil
local slot3Player = nil
local aaSection = mainTab:AddSection("Anti-Aim Extension", "Utilities")
aaSection:AddParagraph("Anti-Aim","Breaks other silent aims whilst keeping your game performance the same.\n\nThis is a blatant feature and will show other players random movement from time to time.")
local slot1Name=tostring(C("aaIgnorePlayer1","None"))
local slot2Name=tostring(C("aaIgnorePlayer2","None"))
local slot3Name=tostring(C("aaIgnorePlayer3","None"))
local dropdownRefreshing=false
local function getPlayerList()
local list = {"None"}
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer then
table.insert(list, p.Name)
end
end
return list
end
local function findPlayerByName(name)
if not name or name == "None" then return nil end
for _, p in ipairs(Players:GetPlayers()) do
if p.Name == name then
return p
end
end
return nil
end
slot1Player=findPlayerByName(slot1Name)
slot2Player=findPlayerByName(slot2Name)
slot3Player=findPlayerByName(slot3Name)
local function hasKnife()
local backpack = LocalPlayer:FindFirstChild("Backpack")
local character = LocalPlayer.Character
if backpack and backpack:FindFirstChild("Knife") then
return true
end
if character and character:FindFirstChild("Knife") then
return true
end
return false
end
local function isPlayerNearby(hrp)
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
local otherHrp = player.Character.HumanoidRootPart
if (otherHrp.Position - hrp.Position).Magnitude <= 6 then
return true
end
end
end
return false
end
local function isInWater(humanoid)
local state = humanoid:GetState()
return state == Enum.HumanoidStateType.Swimming or humanoid.FloorMaterial == Enum.Material.Water
end
local function isIgnoredPlayerArmed()
if not ignoreListEnabled then
return false
end
local targets = {slot1Player, slot2Player, slot3Player}
for _, player in ipairs(targets) do
if player and player.Parent then
local backpack = player:FindFirstChild("Backpack")
local character = player.Character
if backpack then
for _, item in ipairs(backpack:GetChildren()) do
if item:IsA("Tool") then
return true
end
end
end
if character then
for _, item in ipairs(character:GetChildren()) do
if item:IsA("Tool") then
return true
end
end
end
end
end
return false
end
local function performRoleStep(humanoid)
task.spawn(function()
local randomX = math.random() > 0.5 and 1 or -1
local randomZ = math.random() > 0.5 and 1 or -1
local moveDir = Vector3.new(randomX, 0, randomZ).Unit
local startTime = tick()
while tick() - startTime < 0.15 do
if humanoid and humanoid.Parent then
humanoid:Move(moveDir, false)
end
RunService.RenderStepped:Wait()
end
end)
end
local function stopAntiAim()
if velocityConnection then
velocityConnection:Disconnect()
velocityConnection = nil
end
end
local function startAntiAim()
if velocityConnection then return end
velocityConnection = RunService.Heartbeat:Connect(function()
if isIgnoredPlayerArmed() then
if enabled then
enabled = false
end
return
else
if userWantsEnabled and not enabled then
enabled = true
end
end
local character = LocalPlayer.Character
if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
local humanoid = character.Humanoid
if humanoid.Health > 0 then
local hrp = character.HumanoidRootPart
local currentlyHasKnife = hasKnife()
if currentlyHasKnife and not hadKnifeLastFrame then
performRoleStep(humanoid)
end
hadKnifeLastFrame = currentlyHasKnife
if currentlyHasKnife and not isPlayerNearby(hrp) and not isInWater(humanoid) then
local oldVelocity = hrp.AssemblyLinearVelocity
local state = humanoid:GetState()
local isJumping = (state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall)
local isStopped = (humanoid.MoveDirection.Magnitude == 0)
local multiplier = math.random(1, 2) == 1 and 320 or -320
if isJumping then
local jumpMultY = math.random(1, 2) == 1 and 250 or -250
hrp.AssemblyLinearVelocity = Vector3.new(multiplier, jumpMultY, multiplier)
elseif isStopped then
local stopMult = math.random(1, 2) == 1 and 400 or -400
hrp.AssemblyLinearVelocity = Vector3.new(stopMult, 0, stopMult)
else
hrp.AssemblyLinearVelocity = Vector3.new(multiplier, 0, multiplier)
end
RunService.RenderStepped:Wait()
hrp.AssemblyLinearVelocity = oldVelocity
end
end
else
hadKnifeLastFrame = false
end
end)
end
local antiAimToggle=addToggle(aaSection,"Enable Anti-Aim",userWantsEnabled,function(bool)
SetCfg("aaEnabled",bool)
userWantsEnabled = bool
enabled = bool
if bool then
startAntiAim()
else
stopAntiAim()
end
end)
local ignoreToggle=addToggle(aaSection,"Enable Ignore List",ignoreListEnabled,function(bool)
SetCfg("aaIgnoreListEnabled",bool)
ignoreListEnabled = bool
end)
local drop1, drop2, drop3
local function updateDropdowns()
local list = getPlayerList()
dropdownRefreshing=true
local function refresh(drop,name)
if not drop then return end
if type(drop.ChangeItems)=="function" then
pcall(function() drop:ChangeItems(list) end)
elseif type(drop.Change)=="function" then
pcall(function() drop.Change(list) end)
end
if type(drop.Select)=="function" then
local displayed=findPlayerByName(name) and name or "None"
local ok=pcall(drop.Select,displayed)
if not ok then pcall(function() drop:Select(displayed) end) end
end
end
refresh(drop1,slot1Name)
refresh(drop2,slot2Name)
refresh(drop3,slot3Name)
dropdownRefreshing=false
end
local function ignoreAddedMessage(selected)
local player=findPlayerByName(selected)
if not player then return end
local slots=0
for _,name in ipairs({slot1Name,slot2Name,slot3Name}) do
if name==selected then slots=slots+1 end
end
if slots==1 then return player.Name.." added to the Anti-Aim ignore list" end
end
drop1 = addDropdown(aaSection,"Ignore Player 1",getPlayerList(),slot1Name,function(selected)
if dropdownRefreshing then return end
slot1Name=tostring(selected or "None")
SetCfg("aaIgnorePlayer1",slot1Name)
slot1Player = findPlayerByName(selected)
end,ignoreAddedMessage)
drop2 = addDropdown(aaSection,"Ignore Player 2",getPlayerList(),slot2Name,function(selected)
if dropdownRefreshing then return end
slot2Name=tostring(selected or "None")
SetCfg("aaIgnorePlayer2",slot2Name)
slot2Player = findPlayerByName(selected)
end,ignoreAddedMessage)
drop3 = addDropdown(aaSection,"Ignore Player 3",getPlayerList(),slot3Name,function(selected)
if dropdownRefreshing then return end
slot3Name=tostring(selected or "None")
SetCfg("aaIgnorePlayer3",slot3Name)
slot3Player = findPlayerByName(selected)
end,ignoreAddedMessage)
local playerAddedConnection=Players.PlayerAdded:Connect(function()
slot1Player=findPlayerByName(slot1Name)
slot2Player=findPlayerByName(slot2Name)
slot3Player=findPlayerByName(slot3Name)
updateDropdowns()
end)
local playerRemovingConnection=Players.PlayerRemoving:Connect(function(player)
if slot1Player == player then slot1Player = nil end
if slot2Player == player then slot2Player = nil end
if slot3Player == player then slot3Player = nil end
updateDropdowns()
end)
env.WorldV2Runtime.RegisterReset(function()
antiAimToggle:Set(false)
ignoreToggle:Set(false)
userWantsEnabled=false
enabled=false
hadKnifeLastFrame=false
stopAntiAim()
playerAddedConnection:Disconnect()
playerRemovingConnection:Disconnect()
end)
end,"Section \"Anti-Aim Extension\"")
;w2Section(function()
if not inMurderMystery then return end
local section=mainTab:AddSection("Shoot Murderer Button","Utilities")
local customEnabled=C("shootCustomizationEnabled",false)
local buttonWidth=C("shootButtonWidth",100)
local buttonHeight=C("shootButtonHeight",40)
local keepGun=C("shootKeepGunEnabled",false)
local allowDrag=C("shootDragEnabled",false)
local hideText=C("shootHideText",false)
local button,scale,textObject,oldText,originalSize,originalPosition,originalAnchorPoint
local conns={}
local gunConn,gunTask
local dragging=false
local dragInput,dragStart,startPos
local DEFAULT_POS=UDim2.new(0.5,0,0.5,0)
local buttonPos=loadStoredPosition("shootMurdButtonPosition",DEFAULT_POS)
local resetShootMurdererPosition
local ourClickCallbacks=setmetatable({}, {__mode="k"})
local function normalize(value) return tostring(value or ""):lower():gsub("%s+","") end
local function roots()
local result,seen={},{}
local function add(root)
if typeof(root)=="Instance" and not seen[root] then seen[root]=true; table.insert(result,root) end
end
pcall(function() add(game:GetService("CoreGui")) end)
if type(gethui)=="function" then local ok,r=pcall(gethui); if ok then add(r) end end
pcall(function() add(player:FindFirstChildOfClass("PlayerGui")) end)
return result
end
local function ownControlText(text)
local value=normalize(text)
for _,word in ipairs({"after","button","position","keybind","toggle","size"}) do
if value:find(word,1,true) then return true end
end
for _,prefix in ipairs({"vv2","reset","enable","auto","hide","lock","allow"}) do
if value:sub(1,#prefix)==prefix then return true end
end
return false
end
local function inMenuList(item)
local current=item.Parent
while current and current~=game do
if current:IsA("ScrollingFrame") then return true end
current=current.Parent
end
return false
end
local function onScreen(item)
local current=item
while current and current~=game do
if current:IsA("GuiObject") and not current.Visible then return false end
if current:IsA("LayerCollector") and not current.Enabled then return false end
current=current.Parent
end
return item.AbsoluteSize.Magnitude>0
end
local function isTarget(item)
if not item or not item:IsA("TextButton") then return false end
local matched=item:GetAttribute("ShootMurderButton")==true
if not matched then
local text=normalize(item.Text)
matched=text:find("shootmurderer",1,true)~=nil and not ownControlText(text)
end
if not matched then
local label=item:FindFirstChildWhichIsA("TextLabel",true)
if label then
local labelText=normalize(label.Text)
matched=labelText:find("shootmurderer",1,true)~=nil and not ownControlText(labelText)
end
end
return matched and not inMenuList(item)
end
local function findButton()
for _,root in ipairs(roots()) do
local ok,desc=pcall(function() return root:GetDescendants() end)
if ok then
for _,item in ipairs(desc) do
if isTarget(item) then item:SetAttribute("ShootMurderButton",true); return item end
end
end
end
end
local function getTextTarget(btn)
if not btn then return nil,nil end
if tostring(btn.Text or "")~="" then return btn,btn.Text end
local label=btn:FindFirstChildWhichIsA("TextLabel",true)
if label then return label,label.Text end
return btn,"Shoot Murderer"
end
local function stopKeeper()
if gunConn then gunConn:Disconnect(); gunConn=nil end
if gunTask then pcall(task.cancel,gunTask); gunTask=nil end
end
local function keepEquipped()
if not keepGun then return end
local char=player.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")
local backpack=player:FindFirstChildOfClass("Backpack")
if not hum or not backpack then return end
local gun
for _,container in ipairs({char,backpack}) do
if container then
for _,item in ipairs(container:GetChildren()) do
if item:IsA("Tool") and item.Name:lower():find("gun",1,true) then gun=item; break end
end
end
if gun then break end
end
if not gun then return end
stopKeeper()
gunConn=gun.AncestryChanged:Connect(function(_,parent)
if keepGun and parent==backpack then
task.defer(function() if hum.Parent and gun.Parent then pcall(function() hum:EquipTool(gun) end) end end)
end
end)
gunTask=task.delay(0.3,stopKeeper)
end
local function animate()
if not scale then return end
scale.Scale=0.91
TweenService:Create(scale,TweenInfo.new(0.65,Enum.EasingStyle.Elastic,Enum.EasingDirection.Out),{Scale=1}):Play()
end
local function restoreOriginal()
if not button then return end
if originalSize then button.Size=originalSize end
if originalPosition then button.Position=originalPosition end
if originalAnchorPoint then button.AnchorPoint=originalAnchorPoint end
if textObject and textObject.Parent and oldText~=nil then textObject.Text=oldText end
end
local function update()
if not button or not customEnabled then return end
button.Size=UDim2.new(0,buttonWidth,0,buttonHeight)
button.AnchorPoint=Vector2.new(0.5,0.5)
button.Position=buttonPos
button.Active=true
button.Modal=false
button.Selectable=false
if textObject and textObject.Parent then
textObject.Text=hideText and "" or ((oldText and oldText~="") and oldText or "Shoot Murderer")
end
end
local function clearConnections()
for _,conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
table.clear(conns)
if scale then pcall(function() scale:Destroy() end); scale=nil end
end
local function bind(newButton)
if not newButton or button==newButton then return end
clearConnections()
button=newButton
button:SetAttribute("ShootMurderButton",true)
textObject,oldText=getTextTarget(button)
originalSize=button.Size
originalPosition=button.Position
originalAnchorPoint=button.AnchorPoint
button.AutoButtonColor=false
button.Active=true
button.Modal=false
button.Selectable=false
scale=Instance.new("UIScale")
scale.Parent=button
update()
table.insert(conns,button.InputBegan:Connect(function(input)
if not customEnabled or not allowDrag then return end
if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
dragging=true
dragInput=input
dragStart=input.Position
startPos=button.Position
end))
local customClick=function()
if not customEnabled or allowDrag then return end
keepEquipped()
animate()
end
ourClickCallbacks[customClick]=true
table.insert(conns,button.MouseButton1Click:Connect(customClick))
table.insert(conns,UserInputService.InputChanged:Connect(function(input)
if not dragging or not customEnabled or not allowDrag or not button then return end
if input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch then return end
if dragInput and dragInput.UserInputType==Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.Touch then return end
local delta=input.Position-dragStart
button.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
end))
table.insert(conns,UserInputService.InputEnded:Connect(function(input)
if not dragging then return end
if input==dragInput or input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
dragging=false; dragInput=nil
if button then buttonPos=button.Position; saveStoredPosition("shootMurdButtonPosition",buttonPos) end
end
end))
table.insert(conns,button:GetPropertyChangedSignal("Size"):Connect(function()
if not customEnabled or not button then return end
local wanted=UDim2.new(0,buttonWidth,0,buttonHeight)
if button.Size~=wanted then button.Size=wanted end
end))
table.insert(conns,button.AncestryChanged:Connect(function()
if button and not button:IsDescendantOf(game) then
button=nil
task.defer(function() local replacement=findButton(); if replacement then bind(replacement) end end)
end
end))
end
resetShootMurdererPosition=function()
local centered=UDim2.new(0.5,0,0.5,0)
buttonPos=centered
PositionData["shootMurdButtonPosition"]=nil
saveConfig()
local target=button
if not target or not target.Parent then
target=findButton()
if target then bind(target) end
end
if target then
target.AnchorPoint=Vector2.new(0.5,0.5)
target.Position=centered
end
end
env.WorldV2ResetShootMurdererPosition=resetShootMurdererPosition
local odhShootAnchor
local SHOOT_PREFIXES={"shootmurderer","flickshoot","silentshoot"}
local function shootRank(value)
local text=normalize(value)
if text=="" or ownControlText(text) then return nil end
for index,prefix in ipairs(SHOOT_PREFIXES) do
if text:sub(1,#prefix)==prefix then return index end
end
return nil
end
local function buttonRank(item)
if not item or not item:IsA("GuiButton") or inMenuList(item) then return nil end
local rank=item:IsA("TextButton") and shootRank(item.Text)
if not rank then
local label=item:FindFirstChildWhichIsA("TextLabel",true)
rank=label and shootRank(label.Text)
end
if not rank and item:GetAttribute("ShootMurderButton")==true then rank=1 end
return rank
end
local function pressTarget(label)
local current=label
while current and current:IsA("GuiObject") do
if current:IsA("GuiButton") then return current end
current=current.Parent
end
current=label
while current and current:IsA("GuiObject") do
if current.Active then return current end
current=current.Parent
end
return label
end
local function isShootButton(item) return buttonRank(item)~=nil end
local function sliceYield(state)
state.count=state.count+1
if state.count%100==0 and os.clock()-state.started>=0.003 then task.wait();state.started=os.clock() end
end
local function getOdhGui(sliced)
local cached=odhShootAnchor
if cached and cached.Parent and cached.Parent.Parent and cached.Parent.Parent.Parent then
local imageLabel=cached.Parent
local canvasGroup=imageLabel.Parent
local screenGui=canvasGroup.Parent
if imageLabel:IsA("ImageLabel") and canvasGroup:IsA("CanvasGroup") and screenGui:IsA("ScreenGui") then
return screenGui
end
end
odhShootAnchor=nil
local slice=sliced and {count=0,started=os.clock()}
for _,root in ipairs(roots()) do
local ok,descendants=pcall(function() return root:GetDescendants() end)
if ok then
for _,item in ipairs(descendants) do
if slice then sliceYield(slice) end
if item.Parent and item.Name=="Identity" and item:IsA("CanvasGroup") then
local imageLabel=item.Parent
local canvasGroup=imageLabel and imageLabel.Parent
local screenGui=canvasGroup and canvasGroup.Parent
if imageLabel and imageLabel:IsA("ImageLabel") and canvasGroup
and canvasGroup:IsA("CanvasGroup") and screenGui and screenGui:IsA("ScreenGui") then
odhShootAnchor=item
return screenGui
end
end
end
end
end
return nil
end
local function shootCandidates(sliced)
local found,seen={},{}
local labelRanks={}
local slice=sliced and {count=0,started=os.clock()}
local function scan(root)
if typeof(root)~="Instance" then return end
local ok,descendants=pcall(function() return root:GetDescendants() end)
if not ok then return end
for _,item in ipairs(descendants) do
if slice then sliceYield(slice) end
if not item.Parent then
elseif not seen[item] and isShootButton(item) then
seen[item]=true
found[#found+1]=item
elseif item:IsA("TextLabel") and shootRank(item.Text) and not inMenuList(item) then
local target=pressTarget(item)
if not seen[target] then
seen[target]=true
found[#found+1]=target
labelRanks[target]=shootRank(item.Text)
end
end
end
end
local odh=getOdhGui(sliced)
if odh then scan(odh) end
if #found==0 then
for _,root in ipairs(roots()) do scan(root) end
end
local ranks={}
for _,item in ipairs(found) do
ranks[item]=(buttonRank(item) or labelRanks[item] or 9)+(onScreen(item) and 0 or 10)
end
table.sort(found,function(a,b) return ranks[a]<ranks[b] end)
return found
end
local virtualInput
pcall(function() virtualInput=game:GetService("VirtualInputManager") end)
local guiService=game:GetService("GuiService")
local function touchDevice()
if not UserInputService.TouchEnabled then return false end
if not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then return true end
local ok,last=pcall(function() return UserInputService:GetLastInputType() end)
return ok and last==Enum.UserInputType.Touch
end
local function restoreTouchControls()
if not UserInputService.TouchEnabled then return end
task.spawn(function()
local inspect=getconnections or env.getconnections
if type(inspect)=="function" then
local ok,list=pcall(inspect,UserInputService.LastInputTypeChanged)
if ok and type(list)=="table" then
for _,connection in ipairs(list) do
pcall(function()
local callback=connection.Function
if type(callback)=="function" then task.spawn(callback,Enum.UserInputType.Touch)
elseif type(connection.Fire)=="function" then connection:Fire(Enum.UserInputType.Touch) end
end)
end
end
end
pcall(function()
local scripts=LocalPlayer:FindFirstChild("PlayerScripts")
local module=scripts and scripts:FindFirstChild("PlayerModule")
if not module or not module:IsA("ModuleScript") then return end
local playerModule=require(module)
if type(playerModule)~="table" or type(playerModule.GetControls)~="function" then return end
local controls=playerModule:GetControls()
if type(controls)=="table" and type(controls.OnLastInputTypeChanged)=="function" then
controls:OnLastInputTypeChanged(Enum.UserInputType.Touch)
end
end)
end)
end
env.WorldV2Runtime.TouchControls={IsTouch=touchDevice,Restore=restoreTouchControls}
local touchTapId=0
local function tapButton(target,mode)
if not virtualInput or not onScreen(target) then return false end
local layer=target:FindFirstAncestorWhichIsA("LayerCollector")
local inset=Vector2.zero
if layer and layer:IsA("ScreenGui") and not layer.IgnoreGuiInset then
local ok,value=pcall(function() return guiService:GetGuiInset() end)
if ok and typeof(value)=="Vector2" then inset=value end
end
local center=target.AbsolutePosition+target.AbsoluteSize/2+inset
local camera=workspace.CurrentCamera
local viewport=camera and camera.ViewportSize or Vector2.new(1e5,1e5)
if center.X<0 or center.Y<0 or center.X>viewport.X or center.Y>viewport.Y then return false end
local wasTouch=touchDevice()
local arrived=false
local watch=target.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
arrived=true
end
end)
local globalWatch=UserInputService.InputBegan:Connect(function(input,processed)
if processed and (input.UserInputType==Enum.UserInputType.MouseButton1
or input.UserInputType==Enum.UserInputType.Touch) then arrived=true end
end)
local sent
if mode=="touch" then
touchTapId=touchTapId%30+1
local id=7000+touchTapId
sent=pcall(function()
virtualInput:SendTouchEvent(id,0,center.X,center.Y)
task.wait()
virtualInput:SendTouchEvent(id,2,center.X,center.Y)
end)
else
sent=pcall(function()
virtualInput:SendMouseButtonEvent(center.X,center.Y,0,true,game,1)
task.wait()
virtualInput:SendMouseButtonEvent(center.X,center.Y,0,false,game,1)
end)
if wasTouch then restoreTouchControls() end
end
if not arrived then task.wait() end
watch:Disconnect()
globalWatch:Disconnect()
return sent and arrived
end
local function activateButton(target)
local touch=touchDevice()
if tapButton(target,touch and "touch" or "mouse") then return true end
local inspect=getconnections or env.getconnections
if type(inspect)=="function" then
local center=target.AbsolutePosition+target.AbsoluteSize/2
local signals={
{target.MouseButton1Click,{}},
{target.Activated,{{UserInputType=Enum.UserInputType.MouseButton1,UserInputState=Enum.UserInputState.End,
Position=Vector3.new(center.X,center.Y,0),KeyCode=Enum.KeyCode.Unknown},1}},
{target.MouseButton1Down,{center.X,center.Y}},
{target.MouseButton1Up,{center.X,center.Y}},
}
for _,pair in ipairs(signals) do
local fired=false
local ok,callbacks=pcall(inspect,pair[1])
if ok and type(callbacks)=="table" then
for _,connection in ipairs(callbacks) do
local readable,callback,enabled=pcall(function() return connection.Function,connection.Enabled end)
if readable and enabled~=false and not (type(callback)=="function" and ourClickCallbacks[callback]) then
if type(callback)=="function" then
task.spawn(callback,table.unpack(pair[2]))
fired=true
elseif type(connection.Fire)=="function" then
fired=pcall(connection.Fire,connection,table.unpack(pair[2])) or fired
end
end
end
end
if fired then return true end
end
end
local fire=firesignal or env.firesignal
if type(fire)=="function" and type(inspect)~="function" then
for _,signal in ipairs({target.MouseButton1Click,target.Activated}) do
if pcall(fire,signal) then return true end
end
end
if touch and tapButton(target,"mouse") then return true end
return false
end
local cachedCandidates,cachedAt=nil,-math.huge
local function cacheValid()
if not cachedCandidates or #cachedCandidates==0 then return false end
for _,item in ipairs(cachedCandidates) do
if not item.Parent then return false end
end
return onScreen(cachedCandidates[1]) or not cachedCandidates.wasOnScreen
end
local function remember(candidates)
candidates.wasOnScreen=candidates[1]~=nil and onScreen(candidates[1])
cachedCandidates,cachedAt=candidates,os.clock()
end
local function currentCandidates(refresh)
if not refresh and cacheValid() then return cachedCandidates end
local candidates=shootCandidates()
if #candidates==0 then
local legacy=button and button.Parent and button or findButton()
if legacy then candidates[1]=legacy end
end
remember(candidates)
return candidates
end
local warming=false
local lastEmptyWarm=-math.huge
env.WorldV2Runtime.ODHShootWarm=function()
if warming or not runtimeAlive then return end
if cacheValid() and os.clock()-cachedAt<60 then return end
if not cacheValid() and os.clock()-lastEmptyWarm<15 then return end
warming=true
task.spawn(function()
local ok,candidates=pcall(shootCandidates,true)
warming=false
if not ok or type(candidates)~="table" or not runtimeAlive then return end
if #candidates==0 then lastEmptyWarm=os.clock();return end
remember(candidates)
end)
end
env.WorldV2Runtime.ODHShootPrepare=function() currentCandidates(false) end
env.WorldV2Runtime.ODHShootMurderer=function()
local taps=env.WorldV2Runtime.GunTaps
if taps then pcall(taps.Allow) end
local candidates=currentCandidates(false)
if #candidates==0 then return false,"Could not find ODH's shoot button (enable it in ODH first)" end
local inspect=getconnections or env.getconnections
local fire=firesignal or env.firesignal
if not virtualInput and type(inspect)~="function" and type(fire)~="function" then
return false,"This executor cannot activate ODH's shoot button"
end
for _,target in ipairs(candidates) do
if activateButton(target) then return true end
end
return false,"ODH's shoot button did not respond"
end
env.WorldV2Runtime.ODHShootButtonAt=function(position)
for _,item in ipairs(cachedCandidates or {}) do
if item.Parent and onScreen(item) then
local at,size=item.AbsolutePosition,item.AbsoluteSize
if position.X>=at.X-4 and position.X<=at.X+size.X+4 and position.Y>=at.Y-4 and position.Y<=at.Y+size.Y+4 then return true end
end
end
return false
end
local customToggle=addToggle(section,"Enable Button Customization",customEnabled,function(v)
customEnabled=v; SetCfg("shootCustomizationEnabled",v)
if v then update() else restoreOriginal(); dragging=false; dragInput=nil; stopKeeper() end
end)
section:AddSlider("Button Width",40,300,buttonWidth,function(v) buttonWidth=v; SetCfg("shootButtonWidth",v); update() end)
section:AddSlider("Button Height",20,150,buttonHeight,function(v) buttonHeight=v; SetCfg("shootButtonHeight",v); update() end)
local keepToggle=addToggle(section,"Keep Gun Equipped",keepGun,function(v) keepGun=v; SetCfg("shootKeepGunEnabled",v); if not v then stopKeeper() end end)
local dragToggle=addToggle(section,"Allow Drag",allowDrag,function(v) allowDrag=v; SetCfg("shootDragEnabled",v); dragging=false; dragInput=nil end)
local textToggle=addToggle(section,"Hide Button Text",hideText,function(v)
hideText=v
SetCfg("shootHideText",v)
update()
end)
section:AddButton("Reset Shoot Murderer Button Position",resetShootMurdererPosition)
-- (its listeners are removed when World V2 unloads, so a reload doesn't leave old ones running)
local listeners={}
task.defer(function()
task.wait(0.5)
if not runtimeAlive then return end
local found=findButton(); if found then bind(found) end
for _,root in ipairs(roots()) do
pcall(function()
listeners[#listeners+1]=root.DescendantAdded:Connect(function(item)
if not runtimeAlive then return end
local runtime=env.WorldV2Runtime
local trade=runtime and runtime.Trade
if trade and trade.active then return end
if isTarget(item) then task.defer(function() bind(item) end) end
end)
end)
end
end)
env.WorldV2Runtime.RegisterReset(function()
customToggle:Set(false); keepToggle:Set(false); dragToggle:Set(false); textToggle:Set(false)
customEnabled=false; keepGun=false; allowDrag=false; hideText=false
buttonWidth=100; buttonHeight=40; buttonPos=UDim2.new(0.5,0,0.5,0)
stopKeeper(); restoreOriginal()
if not runtimeAlive then
for _,connection in ipairs(listeners) do pcall(function() connection:Disconnect() end) end
table.clear(listeners)
end
end)
end,"Section \"Shoot Murderer Button\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE))
if not inMurderMystery then return end
local runtime=env.WorldV2Runtime
local section=mainTab:AddSection("Trick Shoot","Utilities")
local RELOAD_TIME=2.7
local THROW_RELOAD=1.5
local MAX_THROW=300
local TYPES={"Flick Shoot","360 Shoot"}
local METHODS={"Instant","Smooth"}
local THROW_TARGETS={"Nearest Player","Closest To Aim","Sheriff First"}
local function pick(list,value,default)
for _,item in ipairs(list) do if item==value then return value end end
return default
end
local state={
visible=C("trickShootButtonVisible",false)==true,
kind=pick(TYPES,C("trickShootType","Flick Shoot"),"Flick Shoot"),
method=pick(METHODS,C("trickShootMethod","Smooth"),"Smooth"),
instantTime=0,
flickSpeed=math.clamp(tonumber(C("trickShootFlickSpeed",C("trickShootSmoothSpeed",10))) or 10,1,30),
spinSpeed=math.clamp(tonumber(C("trickShoot360Speed",C("trickShootSmoothSpeed",10))) or 10,1,30),
throwSpeed=math.clamp(tonumber(C("trickThrowSpeed",C("trickShootSmoothSpeed",10))) or 10,1,30),
wallCheck=C("trickShootWallCheck",false)==true,
size=math.clamp(tonumber(C("trickShootButtonSize",140)) or 140,50,300),
throwOn=C("trickThrowEnabled",false)==true,
throwTarget=pick(THROW_TARGETS,C("trickThrowTarget","Nearest Player"),"Nearest Player"),
knifeSpeed=math.clamp(tonumber(C("trickThrowKnifeSpeed",96)) or 96,30,600),
}
local DEFAULT_POS=UDim2.new(1,-170,1,-240)
local busy,reloadingUntil=false,0
local button
local messageToken=0
local flashUntil=0
local function myKnife()
local character=LocalPlayer.Character
local backpack=LocalPlayer:FindFirstChildOfClass("Backpack")
local skins=runtime.ClientWeaponSkins
for _,container in ipairs({character or false,backpack or false}) do
if container then
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and (tool.Name=="Knife" or tool:GetAttribute("IsKnife")==true
or (skins and type(skins.GetKind)=="function" and skins.GetKind(tool)=="Knife")) then
return tool,container==character
end
end
end
end
end
local function throwing() return state.throwOn and myKnife()~=nil end
local keys={shoot=C("trickShootOwnShootKey",nil)}
local virtualInput
pcall(function() virtualInput=game:GetService("VirtualInputManager") end)
local function pressOwnKey(name)
local code
pcall(function() code=Enum.KeyCode[name] end)
if not code or code==Enum.KeyCode.Unknown or not virtualInput then return false end
local touch=env.WorldV2Runtime.TouchControls
local wasTouch=touch and touch.IsTouch()
local ok=pcall(function()
virtualInput:SendKeyEvent(true,code,false,game)
task.wait(0.03)
virtualInput:SendKeyEvent(false,code,false,game)
end)
if wasTouch then pcall(touch.Restore) end
return ok
end
local function trickSpeed()
if throwing() then return state.throwSpeed end
return state.kind=="360 Shoot" and state.spinSpeed or state.flickSpeed
end
local function label()
if os.clock()<reloadingUntil then return string.format("Wait %.1fs",math.max(0,reloadingUntil-os.clock())) end
local spin=state.kind=="360 Shoot"
if throwing() then return spin and "360 Throw" or "Flick Throw" end
return spin and "360 Shoot" or "Flick Shoot"
end
local function refreshText() if button then button.SetText(label()) end end
local function flash(text)
messageToken=messageToken+1
local token=messageToken
flashUntil=os.clock()+1
if button then button.SetText(text) end
task.delay(1,function() if token==messageToken then refreshText() end end)
end
local function hasKnife(plr)
for _,container in ipairs({plr.Character,plr:FindFirstChildOfClass("Backpack")}) do
if container and (container:FindFirstChild("Knife") or container:FindFirstChild("Knife_Local")) then return true end
end
return false
end
local function isMurderer(plr)
if not plr or plr==LocalPlayer then return false end
local roles=env.WorldV2Runtime.Roles
if roles and type(roles.RoleOf)=="function" then
local ok,role=pcall(roles.RoleOf,plr)
if ok and role then return role=="Murderer" end
end
for _,name in ipairs({"Role","CurrentRole"}) do
local value=plr:GetAttribute(name)
if type(value)=="string" and value:lower()=="murderer" then return true end
end
return hasKnife(plr)
end
local function clearShot(target)
if not state.wallCheck then return true end
local mine=LocalPlayer.Character
local root=mine and mine:FindFirstChild("HumanoidRootPart")
local other=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
if not root or not other then return false end
local params=RaycastParams.new()
params.FilterType=Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances={mine,target.Character}
return workspace:Raycast(root.Position,other.Position-root.Position,params)==nil
end
local function findMurderer()
for _,plr in ipairs(Players:GetPlayers()) do
if isMurderer(plr) then
local character=plr.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if root and humanoid and humanoid.Health>0 and clearShot(plr) then return plr end
end
end
end
local function smoothstep(alpha) return alpha*alpha*(3-2*alpha) end
local function flatUnit(vector)
local flat=Vector3.new(vector.X,0,vector.Z)
return flat.Magnitude>0.01 and flat.Unit or nil
end
local function yawOf(look) return math.atan2(-look.X,-look.Z) end
local function facing(position,yaw) return CFrame.new(position)*CFrame.Angles(0,yaw,0) end
local turnSteps=0
local function holdTurn(turn)
turnSteps=turnSteps+1
local name="VisualsV2_TrickTurn"..turnSteps
turn.renderName=name
local function apply()
local root=turn.root
if turn.yaw and root.Parent then root.CFrame=facing(root.Position,turn.yaw) end
end
pcall(function() RunService:BindToRenderStep(name,Enum.RenderPriority.Last.Value,apply) end)
turn.connections={RunService.Stepped:Connect(apply),RunService.Heartbeat:Connect(apply)}
turn.apply=apply
end
local function releaseTurn(turn)
if turn.renderName then pcall(function() RunService:UnbindFromRenderStep(turn.renderName) end);turn.renderName=nil end
for _,connection in ipairs(turn.connections or {}) do pcall(function() connection:Disconnect() end) end
turn.connections=nil
end
local function turnTo(turn,yaw)
if not turn.root.Parent then return end
turn.yaw=yaw
if turn.apply then turn.apply() end
end
local function targetYaw(turn,target)
local look=flatUnit(target.Position-turn.root.Position)
return look and yawOf(look) or nil
end
local function frame(turn)
RunService.RenderStepped:Wait()
end
local function flick(turn,target)
local root=turn.root
if not targetYaw(turn,target) then return end
if state.method=="Instant" then
local started=os.clock()
repeat
if not root.Parent or not target.Parent then return end
local yaw=targetYaw(turn,target)
if yaw then turnTo(turn,yaw) end
frame(turn)
until os.clock()-started>=state.instantTime
return
end
local duration=math.clamp(0.28/trickSpeed()*10,0.08,0.35)
local fromYaw=yawOf(flatUnit(root.CFrame.LookVector) or Vector3.new(0,0,-1))
local started=os.clock()
repeat
if not root.Parent or not target.Parent then return end
local goal=targetYaw(turn,target) or fromYaw
local delta=(goal-fromYaw+math.pi)%(2*math.pi)-math.pi
local alpha=smoothstep(math.clamp((os.clock()-started)/duration,0,1))
turnTo(turn,fromYaw+delta*alpha)
frame(turn)
until os.clock()-started>=duration
local yaw=targetYaw(turn,target)
if yaw then turnTo(turn,yaw) end
end
local function spin360(turn,target)
local root=turn.root
local duration=math.clamp(1.1/trickSpeed(),0.08,1.1)
if state.method=="Instant" then duration=math.clamp(state.instantTime,0.08,1.1) end
local fromYaw=yawOf(flatUnit(root.CFrame.LookVector) or Vector3.new(0,0,-1))
local started=os.clock()
repeat
if not root.Parent or not target.Parent then return end
local alpha=math.clamp((os.clock()-started)/duration,0,1)
local goal=targetYaw(turn,target) or fromYaw
local delta=(goal-fromYaw)%(2*math.pi)
turnTo(turn,fromYaw+(delta+2*math.pi)*alpha)
frame(turn)
until os.clock()-started>=duration
local yaw=targetYaw(turn,target)
if yaw then turnTo(turn,yaw) end
end
local function withTurn(character,humanoid,root,target,action)
local originalLook=root.CFrame.LookVector
local letGo=env.WorldV2Runtime.HoldRotation(humanoid)
local turn={root=root}
holdTurn(turn)
local ok,err=pcall(function()
if state.kind=="360 Shoot" then spin360(turn,target) else flick(turn,target) end
end)
local done,reason=false,nil
if not ok then reason=tostring(err) end
if ok and LocalPlayer.Character==character then
local fine,result,why=pcall(action)
if fine then done,reason=result,why else reason=tostring(result) end
end
task.wait(0.15)
if root.Parent then
local flat=Vector3.new(originalLook.X,0,originalLook.Z)
if flat.Magnitude>0.01 then
turnTo(turn,yawOf(flat.Unit))
for _=1,2 do RunService.RenderStepped:Wait() end
end
end
releaseTurn(turn)
letGo()
return done,reason
end
local function reloadFor(seconds)
reloadingUntil=os.clock()+seconds
task.spawn(function()
while runtimeAlive and os.clock()<reloadingUntil do refreshText();task.wait(0.1) end
refreshText()
end)
end
local THROW_ANIMATIONS={["1957618848"]=true,["15478370930"]=true}
local function animationNumber(id) return type(id)=="string" and id:match("(%d+)%s*$") or nil end
local function raisedToThrow(character,knife)
local ids=table.clone(THROW_ANIMATIONS)
for _,item in ipairs(knife:GetDescendants()) do
if item:IsA("Animation") then
local name=item.Name:lower()
local number=animationNumber(item.AnimationId)
-- (the knife's own ThrowCharge and ThrowHold, by name: MM2 and MMV name them the same, with their own IDs)
if number and (name:find("throwcharge",1,true) or name:find("throwhold",1,true)) then ids[number]=true end
end
end
local humanoid=character:FindFirstChildOfClass("Humanoid")
local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")
for _,owner in ipairs({animator or false,humanoid or false}) do
if owner then
local ok,tracks=pcall(function() return owner:GetPlayingAnimationTracks() end)
if ok and type(tracks)=="table" then
for _,track in ipairs(tracks) do
local name,number="",nil
pcall(function() name=tostring(track.Name):lower() end)
pcall(function() number=track.Animation and animationNumber(track.Animation.AnimationId) end)
if name:find("throwcharge",1,true) or name:find("throwhold",1,true) or (number and ids[number]) then return true end
end
end
end
end
return false
end
local function knifeRemote(knife)
local events=knife:FindFirstChild("Events")
local remote=events and events:FindFirstChild("KnifeThrown")
if remote and remote:IsA("RemoteEvent") then return remote end
for _,item in ipairs(knife:GetDescendants()) do
if item:IsA("RemoteEvent") and item.Name:lower():find("throw",1,true) then return item end
end
end
local function sheriffLike(plr)
for _,name in ipairs({"Role","CurrentRole"}) do
local value=plr:GetAttribute(name)
if type(value)=="string" and (value:lower()=="sheriff" or value:lower()=="hero") then return true end
end
for _,container in ipairs({plr.Character,plr:FindFirstChildOfClass("Backpack")}) do
if container and container:FindFirstChild("Gun") then return true end
end
return false
end
local function throwTarget(root)
local camera=workspace.CurrentCamera
local look=camera and camera.CFrame.LookVector or root.CFrame.LookVector
local best,bestScore=nil,math.huge
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer then
local character=plr.Character
local other=character and character:FindFirstChild("HumanoidRootPart")
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local offset=other and other.Position-root.Position
if other and humanoid and humanoid.Health>0 and offset.Magnitude<=MAX_THROW and offset.Magnitude>0.1
and clearShot(plr) then
local score=offset.Magnitude
if state.throwTarget=="Closest To Aim" then
score=math.acos(math.clamp(look:Dot(offset.Unit),-1,1))
elseif state.throwTarget=="Sheriff First" and sheriffLike(plr) then
score=score-100000
end
if score<bestScore then best,bestScore=plr,score end
end
end
end
return best
end
local function aimAt(target,from)
local position=target.Position
local velocity=Vector3.zero
pcall(function() velocity=target.AssemblyLinearVelocity end)
local flatVelocity=Vector3.new(velocity.X,0,velocity.Z)
local lead=flatVelocity*((position-from).Magnitude/state.knifeSpeed)
if lead.Magnitude>8 then lead=lead.Unit*8 end
return position+lead
end
local HttpService=game:GetService("HttpService")
local throwFormat=nil
do
local saved=C("trickThrowFormat",nil)
if type(saved)=="string" and saved~="" then
local ok,decoded=pcall(function() return HttpService:JSONDecode(saved) end)
if ok and type(decoded)=="table" and type(decoded.kinds)=="table" and tonumber(decoded.n) then throwFormat=decoded end
end
end
local KEEPS={number=true,string=true,boolean=true}
local function learnThrow(args)
local root=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local kinds,keep,spots={}, {}, {}
for index=1,args.n do
local value=args[index]
local kind=typeof(value)
kinds[index]=kind
if kind=="Vector3" or kind=="CFrame" then
local position=kind=="CFrame" and value.Position or value
spots[#spots+1]={index=index,position=position,unit=kind=="Vector3" and math.abs(value.Magnitude-1)<0.01}
elseif KEEPS[kind] then keep[tostring(index)]=value end
end
if #spots==0 then return end
local format={n=args.n,kinds=kinds,keep=keep}
if #spots==1 then
format.target=spots[1].index;format.unit=spots[1].unit
else
local function away(spot) return root and not spot.unit and (spot.position-root.Position).Magnitude or math.huge end
local from,to=spots[1],spots[2]
local nearest,farthest=nil,nil
for _,spot in ipairs(spots) do
if not nearest or away(spot)<away(nearest) then nearest=spot end
end
for _,spot in ipairs(spots) do
if spot~=nearest and (not farthest or away(spot)>away(farthest)) then farthest=spot end
end
if nearest and away(nearest)<=10 and farthest then from,to=nearest,farthest end
format.origin=from.index;format.target=to.index;format.unit=to.unit
end
throwFormat=format
local ok,encoded=pcall(function() return HttpService:JSONEncode(format) end)
if ok then SetCfg("trickThrowFormat",encoded) end
end
local function throwArgs(hand,to)
local from=hand.Position
local direction=to-from
direction=direction.Magnitude>0.01 and direction.Unit or Vector3.new(0,0,-1)
local format=throwFormat
if not format then return {hand,CFrame.new(to)},2 end
local args={}
for index=1,format.n do
local kind=format.kinds[index]
if index==format.origin then
args[index]=kind=="CFrame" and hand or from
elseif index==format.target then
if kind=="CFrame" then args[index]=CFrame.new(to)
elseif format.unit then args[index]=direction
else args[index]=to end
else
args[index]=format.keep and format.keep[tostring(index)]
end
end
return args,format.n
end
local watch={on=false,ours=false,hooked=false}
local hookMeta=hookmetamethod or env.hookmetamethod
local namecallMethod=getnamecallmethod or env.getnamecallmethod
local makeClosure=newcclosure or env.newcclosure
local fromExecutor=checkcaller or env.checkcaller
local function watchThrows()
if watch.hooked or type(hookMeta)~="function" or type(namecallMethod)~="function" then return end
watch.hooked=true
local previous
local wrapper=function(self,...)
if watch.on and not watch.ours and previous then
local mine=type(fromExecutor)=="function" and fromExecutor()
if not mine and namecallMethod()=="FireServer" and typeof(self)=="Instance" and self.Name=="KnifeThrown" then
task.defer(learnThrow,table.pack(...))
end
end
return previous(self,...)
end
if type(makeClosure)=="function" then wrapper=makeClosure(wrapper) end
local ok,original=pcall(hookMeta,game,"__namecall",wrapper)
if ok and type(original)=="function" then previous=original else watch.hooked=false end
end
local function measureKnife(from)
local found=nil
local connection=workspace.DescendantAdded:Connect(function(object)
if found or not object:IsA("BasePart") then return end
local name=object.Name:lower()
local parentName=object.Parent and object.Parent.Name:lower() or ""
if name=="knifevisual" or name=="throwingknife" or parentName=="throwingknife" then found=object end
end)
local deadline=os.clock()+1
while not found and os.clock()<deadline do task.wait(0.03) end
connection:Disconnect()
if not found or not found.Parent then return end
local given=tonumber(found:GetAttribute("ThrowSpeed"))
if given and given>=30 and given<=600 then
state.knifeSpeed=given;SetCfg("trickThrowKnifeSpeed",given)
return
end
local first,firstAt=found.Position,os.clock()
task.wait(0.12)
if not found.Parent then return end
local speed=(found.Position-first).Magnitude/math.max(os.clock()-firstAt,0.01)
if speed>=30 and speed<=600 and (first-from).Magnitude<15 then
state.knifeSpeed=math.clamp(state.knifeSpeed*0.5+speed*0.5,30,600)
SetCfg("trickThrowKnifeSpeed",state.knifeSpeed)
end
end
local function trickThrow(character,humanoid,root)
local knife,inHand=myKnife()
if not knife then flash("No Knife Found");return end
if not inHand then flash("Equip Your Knife");return end
if not raisedToThrow(character,knife) then flash("Hold To Throw");return end
local remote=knifeRemote(knife)
if not remote then flash("No Knife Throw");return end
local victim=throwTarget(root)
if not victim then flash(state.wallCheck and "No Clear Target" or "No Target Found");return end
local target=victim.Character and victim.Character:FindFirstChild("HumanoidRootPart")
if not target then return end
busy=true
local thrown,reason=withTurn(character,humanoid,root,target,function()
if knife.Parent~=character then return false,"the knife left your hand" end
local handle=knife:FindFirstChild("Handle")
local hand=(handle and handle:IsA("BasePart") and handle.CFrame) or CFrame.new(root.Position+Vector3.new(0,1.5,0))
local from=hand.Position
local to=aimAt(target,from)
local args,count=throwArgs(hand,to)
watch.ours=true
local ok,err=pcall(function() remote:FireServer(table.unpack(args,1,count)) end)
watch.ours=false
if not ok then return false,tostring(err) end
task.spawn(measureKnife,from)
return true
end)
busy=false
if thrown then reloadFor(THROW_RELOAD)
else
flash("Not Thrown")
pcall(shared.Notify,"Trick Throw: "..tostring(reason or "the knife wasn't thrown"),1)
end
end
runtime.KnifeThrowAt=function(knife,target)
local character=LocalPlayer.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
if not knife or knife.Parent~=character or not root then return false,"the knife isn't in your hand" end
local remote=knifeRemote(knife)
if not remote then return false,"no knife throw" end
local handle=knife:FindFirstChild("Handle")
local hand=(handle and handle:IsA("BasePart") and handle.CFrame) or CFrame.new(root.Position+Vector3.new(0,1.5,0))
local to=aimAt(target,hand.Position)
local args,count=throwArgs(hand,to)
watch.ours=true
local ok,err=pcall(function() remote:FireServer(table.unpack(args,1,count)) end)
watch.ours=false
if not ok then return false,tostring(err) end
return true
end
local function trickShoot()
if busy or os.clock()<reloadingUntil or not runtimeAlive then return end
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local root=character and character:FindFirstChild("HumanoidRootPart")
if not humanoid or not root or humanoid.Health<=0 then return end
if throwing() then return trickThrow(character,humanoid,root) end
local murderer=findMurderer()
if not murderer then flash(state.wallCheck and "No Clear Target" or "No Murderer Found");return end
local target=murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart")
if not target then return end
local backpack=LocalPlayer:FindFirstChildOfClass("Backpack")
local gun=character:FindFirstChild("Gun") or backpack and backpack:FindFirstChild("Gun")
local skins=runtime.ClientWeaponSkins
if not gun and skins then
for _,container in ipairs({character,backpack}) do
for _,tool in ipairs(container and container:GetChildren() or {}) do
if tool:IsA("Tool") and skins.GetKind(tool)=="Gun" then gun=tool;break end
end
if gun then break end
end
end
if not gun then flash("No Gun Found");return end
busy=true
if gun.Parent~=character then pcall(function() humanoid:EquipTool(gun) end) end
local shot,reason=withTurn(character,humanoid,root,target,function()
if keys.shoot then
local pressed=pressOwnKey(keys.shoot)
if pressed then return true end
end
local shoot=runtime.ShootMurdererNow
if type(shoot)~="function" then return false,"the shooting helper is not ready" end
return shoot(character)
end)
busy=false
if shot then reloadFor(RELOAD_TIME)
else
flash("Not Shot")
pcall(shared.Notify,"Trick Shoot: "..tostring(reason or "the shot didn't go off"),1)
end
end
runtime.TrickShoot={Fire=trickShoot}
local function makeButton()
if button and button.Alive() then return end
button=runtime.BigButtons.Create("VisualsV2_TrickShootBig",{
text=label(),size=state.size,positionKey="trickShootButtonPosition",default=DEFAULT_POS,
isLocked=function() return lockBigButtonPos end,onClick=trickShoot,
})
button.SetVisible(state.visible)
end
runtime.TrickShoot.ResetPosition=function() if button then button.ResetPosition() end end
makeButton()
task.spawn(function()
while runtimeAlive do
task.wait(0.5)
if button and state.visible and not busy and os.clock()>flashUntil and os.clock()>=reloadingUntil then pcall(refreshText) end
end
end)
local visibleToggle=addToggle(section,"Show Trick Shoot Button",state.visible,function(value)
state.visible=value;SetCfg("trickShootButtonVisible",value)
makeButton();button.SetVisible(value)
end)
local hideText=C("trickShootHideText",false)==true
if button then pcall(button.SetTextHidden,hideText) end
local hideTextToggle=addToggle(section,"Hide Button Text",hideText,function(value)
hideText=value;SetCfg("trickShootHideText",value)
if button then pcall(button.SetTextHidden,value) end
end)
section:AddSlider("Trick Shoot Button Size",50,300,state.size,function(value)
state.size=math.clamp(tonumber(value) or 140,50,300);SetCfg("trickShootButtonSize",state.size)
if button then button.SetSize(state.size) end
end)
section:AddButton("Reset Trick Shoot Button Position",function()
if button then button.ResetPosition() end
end)
local typeDropdown=addDropdown(section,"Trick Shot Type",TYPES,state.kind,function(value)
if type(value)=="table" then value=value[1] end
if not table.find(TYPES,value) then return false end
state.kind=value;SetCfg("trickShootType",value);refreshText()
end)
local methodDropdown=addDropdown(section,"Trickshot Method",METHODS,state.method,function(value)
if type(value)=="table" then value=value[1] end
if not table.find(METHODS,value) then return false end
state.method=value;SetCfg("trickShootMethod",value)
end)
section:AddSlider("Flick Shoot Speed (Sheriff)",1,30,state.flickSpeed,function(value)
state.flickSpeed=math.clamp(tonumber(value) or 10,1,30);SetCfg("trickShootFlickSpeed",state.flickSpeed)
end)
section:AddSlider("360 Shoot Speed (Sheriff)",1,30,state.spinSpeed,function(value)
state.spinSpeed=math.clamp(tonumber(value) or 10,1,30);SetCfg("trickShoot360Speed",state.spinSpeed)
end)
section:AddSlider("Trick Throw Speed (Murderer)",1,30,state.throwSpeed,function(value)
state.throwSpeed=math.clamp(tonumber(value) or 10,1,30);SetCfg("trickThrowSpeed",state.throwSpeed)
end)
local wallToggle=addToggle(section,"Flick Wall Check",state.wallCheck,function(value)
state.wallCheck=value;SetCfg("trickShootWallCheck",value)
end)
local throwToggle=addToggle(section,"Trick Throw As Murderer",state.throwOn,function(value)
state.throwOn=value;SetCfg("trickThrowEnabled",value)
watch.on=value
if value then watchThrows() end
refreshText()
end)
local throwTargetDropdown=addDropdown(section,"Trick Throw Target",THROW_TARGETS,state.throwTarget,function(value)
if type(value)=="table" then value=value[1] end
if not table.find(THROW_TARGETS,value) then return false end
state.throwTarget=value;SetCfg("trickThrowTarget",value)
end)
section:AddLabel("Trick Shoot Keybind Config")
section:AddLabel("For Keyboard, enable both toggles and input your Keybind for shoot murdurer as well as the Keybind for Trick shooting.")
local keybindOn=C("trickShootKeybindEnabled",false)==true
addToggle(section,"Enable Trick Shoot Keybind",keybindOn,function(value)
keybindOn=value;SetCfg("trickShootKeybindEnabled",value)
end)
section:AddKeybind("Trick Shoot Function Keybind","Q",function()
if runtimeAlive and keybindOn then task.spawn(trickShoot) end
end)
-- (your ODH shoot key, typed in so ODH doesn't refuse it; left empty, ODH's Shoot Murderer button is
-- pressed instead)
section:AddTextBox("My Shoot Key (type it, e.g. E)",function(text)
local name=env.WorldV2Runtime.KeyFromText(text)
-- (the saved key being filled back in when the script runs: nothing to say)
if name==keys.shoot then return end
if tostring(text or ""):gsub("%s","")=="" then
keys.shoot=nil;SetCfg("trickShootOwnShootKey",nil)
pcall(shared.Notify,"Trick Shoot: no shoot key, ODH's Shoot Murderer button is used",3)
elseif name then
keys.shoot=name;SetCfg("trickShootOwnShootKey",name)
pcall(shared.Notify,"Trick Shoot: your shoot key is "..name,2)
else
pcall(shared.Notify,"Trick Shoot: "..tostring(text).." isn't a key",0)
end
end)
task.spawn(function()
for _=1,100 do
if not runtimeAlive then return end
local followup=runtime.JumpGunFollowup
if followup and followup.Watch then pcall(followup.Watch,"TrickShoot",function() return state.visible end);return end
task.wait(0.2)
end
end)
runtime.RegisterReset(function()
visibleToggle:Set(false);wallToggle:Set(false);throwToggle:Set(false);hideTextToggle:Set(false)
state.visible=false;state.wallCheck=false;state.throwOn=false;watch.on=false
state.kind="Flick Shoot";state.method="Smooth";state.flickSpeed,state.spinSpeed,state.throwSpeed=10,10,10;state.size=140
state.throwTarget="Nearest Player"
pcall(function() typeDropdown:Select("Flick Shoot") end)
pcall(function() methodDropdown:Select("Smooth") end)
pcall(function() throwTargetDropdown:Select("Nearest Player") end)
if button then
if runtimeAlive then button.ResetPosition();button.SetSize(140);button.SetVisible(false);refreshText()
else button.Destroy() end
end
end)
end,"Section \"Trick Shoot\"")
;w2Section(function()
local runtime=env.WorldV2Runtime
local section=mainTab:AddSection("Wall Hop","Utilities")
-- Wallhop by @leeozyeb: jumping next to a wall turns you away from it (towards where the camera
-- looks, up to Cam Angle), jumps, then turns you back to face the wall.
-- (Debounce is a share of 1.5 seconds: the default 10% is the original 0.15 s)
local DEBOUNCE_FULL=1.5
local DEFAULTS={distance=2.5,debounce=10,angle=45}
local settings={
enabled=C("vv2WallhopEnabled",false)==true,
distance=math.clamp(tonumber(C("w2WallhopDetectDistance",DEFAULTS.distance)) or DEFAULTS.distance,0.5,5),
debounce=math.clamp(tonumber(C("w2WallhopDebouncePercent",DEFAULTS.debounce)) or DEFAULTS.debounce,0,100),
angle=math.clamp(tonumber(C("w2WallhopCamAngle",DEFAULTS.angle)) or DEFAULTS.angle,0,180),
}
local canWallJump=true
local wallRaycastParams=RaycastParams.new()
wallRaycastParams.FilterType=Enum.RaycastFilterType.Exclude
local function wallHit(character,root)
wallRaycastParams.FilterDescendantsInstances={character}
local rootCF=root.CFrame
local closest,nearest=nil,settings.distance+1
for _,direction in ipairs({rootCF.LookVector,-rootCF.LookVector,rootCF.RightVector,-rootCF.RightVector}) do
local hit=workspace:Raycast(root.Position,direction*settings.distance,wallRaycastParams)
if hit and hit.Instance and hit.Distance<nearest then closest,nearest=hit,hit.Distance end
end
return closest
end
local function flat(vector)
local level=Vector3.new(vector.X,0,vector.Z)
return level.Magnitude>=0.1 and level.Unit or nil
end
local function performWallhop()
if not canWallJump then return end
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local root=character and character:FindFirstChild("HumanoidRootPart")
local camera=workspace.CurrentCamera
if not (humanoid and root and camera) or humanoid:GetState()==Enum.HumanoidStateType.Dead then return end
local hit=wallHit(character,root)
if not hit then return end
canWallJump=false
env.WorldV2Runtime.WallHopAt=os.clock()
local away=flat(hit.Normal) or (flat(root.CFrame.LookVector) and -flat(root.CFrame.LookVector)) or Vector3.new(0,0,1)
local cameraLook=flat(camera.CFrame.LookVector) or away
local angleBetween=math.acos(math.clamp(away:Dot(cameraLook),-1,1))
local sign=math.sign(away:Cross(cameraLook).Y)
if sign==0 then angleBetween=0 end
local turn=math.min(angleBetween,math.rad(settings.angle))
local look=CFrame.Angles(0,turn*sign,0)*away
-- (with shift lock on, the character is turned to the camera every frame, which would undo the
-- flick before the jump; so the camera is flicked as well, and put back the frame after the jump)
local shiftLock=UserInputService.MouseBehavior==Enum.MouseBehavior.LockCenter
local savedLook=camera.CFrame.LookVector
local function face(direction)
root.CFrame=CFrame.lookAt(root.Position,root.Position+direction)
if not shiftLock then return end
pcall(function()
local view=camera.CFrame
local from=flat(view.LookVector)
if not from then return end
local yaw=math.atan2(from.Z*direction.X-from.X*direction.Z,from:Dot(direction))
camera.CFrame=CFrame.lookAt(view.Position,view.Position+CFrame.Angles(0,yaw,0):VectorToWorldSpace(view.LookVector))
end)
end
face(look)
RunService.Heartbeat:Wait()
if root.Parent and humanoid:GetState()~=Enum.HumanoidStateType.Dead then
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
face(-away)
end
if shiftLock then
RunService.Heartbeat:Wait()
pcall(function()
local view=camera.CFrame
camera.CFrame=CFrame.lookAt(view.Position,view.Position+savedLook)
end)
end
task.delay(settings.debounce/100*DEBOUNCE_FULL,function() canWallJump=true end)
end
local enableToggle=addToggle(section,"Enable W2 Wallhop",settings.enabled,function(on)
settings.enabled=on;SetCfg("vv2WallhopEnabled",on)
end)
local distanceSlider=section:AddSlider("Detect Distance (studs)",0.5,5,settings.distance,function(value)
settings.distance=math.clamp(math.floor((tonumber(value) or DEFAULTS.distance)*10+0.5)/10,0.5,5);SetCfg("w2WallhopDetectDistance",settings.distance)
end)
local debounceSlider=section:AddSlider("Debounce (%)",0,100,settings.debounce,function(value)
settings.debounce=math.clamp(math.floor((tonumber(value) or DEFAULTS.debounce)+0.5),0,100);SetCfg("w2WallhopDebouncePercent",settings.debounce)
end)
local angleSlider=section:AddSlider("Cam Angle (degrees)",0,180,settings.angle,function(value)
settings.angle=math.clamp(math.floor((tonumber(value) or DEFAULTS.angle)+0.5),0,180);SetCfg("w2WallhopCamAngle",settings.angle)
end)
local jumpConnection=UserInputService.JumpRequest:Connect(function()
if runtimeAlive and settings.enabled then task.spawn(performWallhop) end
end)
-- (holding jump keeps hopping: the jump button, Space or a controller holds Humanoid.Jump on, and
-- each time the debounce allows it hops off the nearest wall again)
local holding=false
local holdConnection=RunService.Heartbeat:Connect(function()
if not runtimeAlive or not settings.enabled or not canWallJump or holding then return end
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if humanoid and humanoid.Jump and humanoid.Health>0 then
holding=true
task.spawn(function()
pcall(performWallhop)
holding=false
end)
end
end)
runtime.RegisterReset(function()
enableToggle:Set(false)
settings.enabled=false
settings.distance,settings.debounce,settings.angle=DEFAULTS.distance,DEFAULTS.debounce,DEFAULTS.angle
pcall(function() distanceSlider:SetValue(DEFAULTS.distance) end)
pcall(function() debounceSlider:SetValue(DEFAULTS.debounce) end)
pcall(function() angleSlider:SetValue(DEFAULTS.angle) end)
canWallJump=true
if not runtimeAlive then jumpConnection:Disconnect();holdConnection:Disconnect() end
end)
end,"Section \"Wall Hop\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local runtime=env.WorldV2Runtime
local section=mainTab:AddSection("Wall Glitch","Utilities")
-- How it works, step by step:
-- 1. a wall is found: straight ahead of you, touching you, upright, solid, not a player, and thin (2
--    studs or less), you're on the ground (not climbing, jumping or wall hopping), and you're walking into
--    it (Auto, strictly: stopped by it for 0.3 s; standing
--    against it doesn't count)
-- 2. you turn round so your back is to the wall (in 0.065 s), with the camera looking at the wall
-- 3. the WALL HACK emote (MM2 WALL HACK, 114537898785444, "/e clip") plays on your character, so
--    everyone sees it: as your own emote if it's in your emotes, otherwise from its animation
-- 4. 0.1 s after it starts: shiftlock goes on and you walk forward, both at once, for 0.2 s (shiftlock
--    turns you to the camera, so you snap back round to the wall as you walk into it)
-- 5. shiftlock is put back how it was, the emote ends, and you keep walking ahead for 0.5 s out the
--    other side; it's ready again 2 s later
local EMOTE_ID=114537898785444
local EMOTE_NAME="WALL HACK💀"
-- (all of it twice as fast as the last version; after the glitch you keep walking forward on your own
-- for WALK_AHEAD, out the other side of the wall)
local GLITCH_DELAY=0.1
local WALK_TIME=0.2
local WALK_AHEAD=0.5
local COOLDOWN=2
local WINDOW=3
-- (Auto is strict so it never goes by accident: right up against the wall, facing it and walking almost
-- straight into it, actually stopped by it, for 0.3 s. The keybind and button are easy: near the wall,
-- roughly facing it and walking into it, and they go at once)
local STRICT={reach=1.5,facing=0.85,walking=0.7}
local EASY={reach=2.4,facing=0.7,walking=0.3}
local THIN=3
-- (how far through a wall is measured, for the "too thick" message)
local MEASURE=20
-- (Auto goes after 0.2 s of walking into the wall; the keybind and button go as soon as you walk into
-- it; standing against a wall never counts)
local RAM_TIME=0.3
-- (never during wall hopping: not in the air, not within 1.5 s of a Wall Hop, and only a moment after
-- landing: 0.5 s for Auto, 0.3 s for the keybind and button)
local HOP_GAP=1.5
local LAND_GAP={auto=0.5,key=0.3}
local BIND_ID="WorldV2_WallGlitch"
local BIND_DEFAULT=UDim2.new(0.28,0,0.78,0)
local settings={
auto=C("w2WallGlitchAuto",false)==true,
keyOn=C("w2WallGlitchKeybindEnabled",false)==true,
size=math.clamp(tonumber(C("w2WallGlitchButtonSize",11)) or 11,5,25)/100,
}
local state={busy=false,readyAt=0,armedUntil=0,animationId=nil,loading=false,tracks=setmetatable({}, {__mode="k"}),bind=false}
local alive=true
local function notify(text,kind) pcall(shared.Notify,"Wall Glitch: "..text,kind or 3) end
local function lit(value) if state.bind then pcall(function() BindableButtons:SetValue(BIND_ID,value,false) end) end end
-- (the emote's animation is read from the emote itself, once, so it plays whether you own it or not)
local function loadAnimation()
if state.animationId or state.loading then return state.animationId end
state.loading=true
task.spawn(function()
local ok,objects=pcall(runtime.GetObjects,"rbxassetid://"..EMOTE_ID)
if ok and type(objects)=="table" then
for _,object in ipairs(objects) do
local found=object:IsA("Animation") and object or object:FindFirstChildWhichIsA("Animation",true)
if found and found.AnimationId~="" then state.animationId=found.AnimationId;break end
end
end
state.loading=false
end)
return nil
end
-- (the emote's name in your own emotes, if you have it equipped: then it's played as the real emote)
local function ownedEmoteName(humanoid)
local ok,description=pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not description then return nil end
local okList,emotes=pcall(function() return description:GetEmotes() end)
if not okList or type(emotes)~="table" then return nil end
for name,ids in pairs(emotes) do
if type(ids)=="table" then
for _,id in ipairs(ids) do if tonumber(id)==EMOTE_ID then return name end end
end
end
return nil
end
local function playEmote(humanoid)
local owned=ownedEmoteName(humanoid)
if owned then
local ok,played=pcall(function() return humanoid:PlayEmote(owned) end)
if ok and played then return true end
end
local animator=humanoid:FindFirstChildOfClass("Animator")
if state.animationId and animator then
local track=state.tracks[animator]
if not track then
local animation=Instance.new("Animation")
animation.AnimationId=state.animationId
local ok,loaded=pcall(function() return animator:LoadAnimation(animation) end)
if ok and loaded then
pcall(function() loaded.Priority=Enum.AnimationPriority.Action4 end)
pcall(function() loaded.Looped=false end)
track=loaded
state.tracks[animator]=track
end
end
if track then pcall(function() track:Play(0.1) end);return track end
end
local ok,played=pcall(function() return humanoid:PlayEmote(EMOTE_NAME) end)
return (ok and played) and true or nil
end
local rayParams=RaycastParams.new()
rayParams.FilterType=Enum.RaycastFilterType.Exclude
local thinParams=RaycastParams.new()
thinParams.FilterType=Enum.RaycastFilterType.Include
local function characters()
local list={}
for _,plr in ipairs(Players:GetPlayers()) do if plr.Character then list[#list+1]=plr.Character end end
local camera=workspace.CurrentCamera
if camera then list[#list+1]=camera end
return list
end
-- (the wall in front of you that you're touching, if it's thin enough to get through: its face's normal)
local function wallAhead(root,rules)
local look=root.CFrame.LookVector
local forward=Vector3.new(look.X,0,look.Z)
if forward.Magnitude<0.1 then return nil end
forward=forward.Unit
rayParams.FilterDescendantsInstances=characters()
for _,height in ipairs({0,1.2,-0.8}) do
local from=root.Position+Vector3.new(0,height,0)
local hit=workspace:Raycast(from,forward*rules.reach,rayParams)
if hit and hit.Instance and hit.Instance.CanCollide and math.abs(hit.Normal.Y)<0.3 then
local normal=Vector3.new(hit.Normal.X,0,hit.Normal.Z).Unit
if forward:Dot(-normal)>rules.facing then
thinParams.FilterDescendantsInstances={hit.Instance}
local back=hit.Position-normal*MEASURE
local through=workspace:Raycast(back,normal*MEASURE,thinParams)
local thickness=through and (through.Position-hit.Position).Magnitude or nil
if thickness and thickness<=THIN+0.05 then return normal,hit.Instance end
return nil,hit.Instance,true,thickness
end
end
end
return nil
end
local function shiftlocked() return UserInputService.MouseBehavior==Enum.MouseBehavior.LockCenter end
local function pressShift()
pcall(function()
local input=game:GetService("VirtualInputManager")
input:SendKeyEvent(true,Enum.KeyCode.LeftShift,false,game)
task.wait()
input:SendKeyEvent(false,Enum.KeyCode.LeftShift,false,game)
end)
end
-- (turns you round so your back is to the wall, smoothly, in TURN_TIME; the camera is put looking at
-- the wall, so shiftlock will turn you back to it)
local TURN_TIME=0.065
local function aimCamera(position,normal)
local camera=workspace.CurrentCamera
if not camera then return end
pcall(function()
local offset=camera.CFrame.Position-position
local flat=Vector3.new(offset.X,0,offset.Z).Magnitude
camera.CFrame=CFrame.lookAt(position+normal*math.max(flat,4)+Vector3.new(0,offset.Y,0),position-normal*4+Vector3.new(0,offset.Y*0.3,0))
end)
end
local function turnAway(root,normal)
local look=root.CFrame.LookVector
local from=math.atan2(-look.X,-look.Z)
local to=math.atan2(-normal.X,-normal.Z)
local diff=(to-from+math.pi)%(2*math.pi)-math.pi
local started=os.clock()
repeat
local t=math.min((os.clock()-started)/TURN_TIME,1)
local yaw=from+diff*t
pcall(function() root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,yaw,0) end)
aimCamera(root.Position,normal)
if t>=1 then break end
task.wait()
until false
end
local function faceWall(root,normal)
local position=root.Position
pcall(function() root.CFrame=CFrame.lookAt(position,position-normal) end)
local camera=workspace.CurrentCamera
if camera then
pcall(function()
local offset=camera.CFrame.Position-position
local flat=Vector3.new(offset.X,0,offset.Z).Magnitude
camera.CFrame=CFrame.lookAt(position+normal*math.max(flat,4)+Vector3.new(0,offset.Y,0),position-normal*4+Vector3.new(0,offset.Y*0.3,0))
end)
end
end
-- (a very slight noclip, so a 1 to 3 stud wall always lets you through: while you walk into it, only the
-- wall parts straight ahead of you, up to 4.5 studs, lose their collision, on your screen only, and get
-- it back straight after. Your own character keeps its collision, so floors and everything else stay)
local function wallParts(root,normal)
local forward=-normal
local found,ignore={},characters()
local params=RaycastParams.new()
params.FilterType=Enum.RaycastFilterType.Exclude
for _,height in ipairs({0,1.2,-0.8}) do
for _=1,4 do
params.FilterDescendantsInstances=ignore
local hit=workspace:Raycast(root.Position+Vector3.new(0,height,0),forward*(THIN+1.5),params)
if not hit or not hit.Instance or math.abs(hit.Normal.Y)>=0.3 then break end
local part=hit.Instance
ignore[#ignore+1]=part
if part.CanCollide and not table.find(found,part) and #found<4 then found[#found+1]=part end
end
end
return found
end
local function ghost(parts)
local saved={}
for _,part in ipairs(parts) do
saved[part]=part.CanCollide
pcall(function() part.CanCollide=false end)
end
return function()
for part,value in pairs(saved) do
if part.Parent then pcall(function() part.CanCollide=value end) end
end
end
end
local RENDER_NAME="W2_WallGlitchWalk"
local function wallGlitch(root,humanoid,normal)
state.busy=true
state.armedUntil=0
lit(false)
task.spawn(function()
local unghost=nil
local ok,err=pcall(function()
humanoid.AutoRotate=false
turnAway(root,normal)
local track=playEmote(humanoid)
if not track then notify("the WALL HACK emote couldn't be played",0) end
task.wait(GLITCH_DELAY)
if LocalPlayer.Character~=humanoid.Parent or humanoid.Health<=0 then return end
-- (shiftlock and walking forward, at the same moment)
local wasLocked=shiftlocked()
local forward=-normal
faceWall(root,normal)
unghost=ghost(wallParts(root,normal))
if not wasLocked then pressShift() end
local walkUntil=os.clock()+WALK_TIME+WALK_AHEAD
pcall(function()
RunService:BindToRenderStep(RENDER_NAME,Enum.RenderPriority.Character.Value+1,function()
if os.clock()<walkUntil and humanoid.Parent then humanoid:Move(forward,false) end
end)
end)
task.wait(WALK_TIME)
-- (shiftlock goes back how it was, and you keep walking ahead, out the other side)
if not wasLocked and shiftlocked() then pressShift() end
pcall(function() humanoid.AutoRotate=true end)
if typeof(track)=="Instance" then task.delay(0.1,function() pcall(function() track:Stop(0.2) end) end) end
task.wait(WALK_AHEAD)
pcall(function() RunService:UnbindFromRenderStep(RENDER_NAME) end)
pcall(function() humanoid:Move(Vector3.zero,false) end)
if unghost then unghost();unghost=nil end
end)
if unghost then pcall(unghost) end
pcall(function() RunService:UnbindFromRenderStep(RENDER_NAME) end)
pcall(function() humanoid.AutoRotate=true end)
if not ok then notify(tostring(err),0) end
state.readyAt=os.clock()+COOLDOWN
state.busy=false
end)
end
local function step()
if not alive or not runtimeAlive or state.busy then return end
local armed=os.clock()<state.armedUntil
if not settings.auto and not armed then
if state.armedUntil>0 then
state.armedUntil=0
lit(false)
notify("no wall found in 3 seconds",3)
end
return
end
if os.clock()<state.readyAt then return end
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local root=character and character:FindFirstChild("HumanoidRootPart")
if not humanoid or not root or humanoid.Health<=0 or humanoid.Sit then return end
-- (never while climbing, jumping or falling, or just after a jump or a Wall Hop)
local okState,current=pcall(function() return humanoid:GetState() end)
if okState and current==Enum.HumanoidStateType.Climbing then state.rammingSince=nil;return end
local airborne=humanoid.FloorMaterial==Enum.Material.Air
or (okState and (current==Enum.HumanoidStateType.Jumping or current==Enum.HumanoidStateType.Freefall))
if airborne then state.airAt=os.clock();state.rammingSince=nil;return end
if os.clock()-(state.airAt or -math.huge)<(armed and LAND_GAP.key or LAND_GAP.auto) then state.rammingSince=nil;return end
if os.clock()-(runtime.WallHopAt or -math.huge)<HOP_GAP then state.rammingSince=nil;return end
loadAnimation()
local rules=armed and EASY or STRICT
local normal,wall,thick,thickness=wallAhead(root,rules)
if not normal then
state.rammingSince=nil
-- (a wall you're at but that's too thick to get through: said once in a while, so you know why)
if thick and wall and (state.thickWall~=wall or os.clock()-(state.thickAt or 0)>6) then
state.thickWall,state.thickAt=wall,os.clock()
notify(thickness and ("that wall is %.1f studs thick, too thick to glitch through (%d max)"):format(thickness,THIN)
or ("that wall is over %d studs thick, too thick to glitch through (%d max)"):format(MEASURE,THIN),3)
end
return
end
local move=humanoid.MoveDirection
local ramming=move.Magnitude>=0.1 and Vector3.new(move.X,0,move.Z).Unit:Dot(-normal)>=rules.walking
-- (Auto: the wall has to actually be stopping you, almost no speed left going into it)
if ramming and not armed then
local velocity=root.AssemblyLinearVelocity
if Vector3.new(velocity.X,0,velocity.Z):Dot(-normal)>4 then ramming=false end
end
if not ramming then state.rammingSince=nil;return end
-- (Auto waits for 0.3 s of that; the keybind and button go at once)
if not armed then
state.rammingSince=state.rammingSince or os.clock()
if os.clock()-state.rammingSince<RAM_TIME then return end
end
state.rammingSince=nil
wallGlitch(root,humanoid,normal)
end
local checkedAt=0
local heartbeat=RunService.Heartbeat:Connect(function()
local now=os.clock()
if now-checkedAt<0.05 then return end
checkedAt=now
pcall(step)
end)
local function arm()
if not alive or not runtimeAlive then return end
if state.busy then return end
if os.clock()<state.armedUntil then
state.armedUntil=0;lit(false);notify("cancelled",3);return
end
loadAnimation()
state.armedUntil=os.clock()+WINDOW
lit(true)
notify("get to a wall (3 s)",2)
end
local controls={}
local function toggle(name,key,callback)
local controller=addToggle(section,name,C(key,false),function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
toggle("Auto Wall Glitch","w2WallGlitchAuto",function(value)
settings.auto=value
if value then loadAnimation() end
end)
toggle("Enable Wall Glitch Keybind","w2WallGlitchKeybindEnabled",function(value) settings.keyOn=value end)
section:AddKeybind("Wall Glitch Keybind","L",function()
if settings.keyOn then arm() end
end)
local function bindSize()
local b=BindableButtons.Buttons[BIND_ID]
if not b then return end
local camera=workspace.CurrentCamera
local screen=camera and camera.ViewportSize or Vector2.new(1920,1080)
if screen.X<=1 or screen.Y<=1 then screen=Vector2.new(1920,1080) end
b.Size=UDim2.new(settings.size*(screen.Y/screen.X),0,settings.size,0)
end
local function createBind()
BindableButtons.AddBButton(BIND_ID,"WG",function() if os.clock()>=state.armedUntil then arm() end end,function()
if os.clock()<state.armedUntil then state.armedUntil=0;notify("cancelled",3) end
end,function(position)
saveStoredPosition("w2WallGlitchButtonPosition",position)
end)
BindableButtons:SetPosition(BIND_ID,loadStoredPosition("w2WallGlitchButtonPosition",BIND_DEFAULT))
BindableButtons:SetLocked(BIND_ID,lockBindButtonPos)
bindSize()
end
toggle("Enable WG Button","w2WallGlitchButtonEnabled",function(value)
state.bind=value
if value then createBind() else BindableButtons:DeleteBButton(BIND_ID) end
end)
section:AddSlider("WG Button Size",5,25,settings.size*100,function(value)
settings.size=math.clamp(tonumber(value) or 11,5,25)/100
SetCfg("w2WallGlitchButtonSize",settings.size*100)
bindSize()
end)
section:AddButton("Reset WG Button Position",function()
saveStoredPosition("w2WallGlitchButtonPosition",BIND_DEFAULT)
BindableButtons:SetPosition(BIND_ID,BIND_DEFAULT)
end)
runtime.RegisterReset(function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
settings.auto,settings.keyOn=false,false
state.armedUntil=0
BindableButtons:DeleteBButton(BIND_ID)
state.bind=false
pcall(function() RunService:UnbindFromRenderStep(RENDER_NAME) end)
if not runtimeAlive then
alive=false
heartbeat:Disconnect()
end
end)
end,"Section \"Wall Glitch\"")
;w2Section(function()
local runtime=env.WorldV2Runtime
local section=mainTab:AddSection("Reset Character","Utilities")
local BIND_ID="VV2_Reset_Bind"
local state={
bindVisible=C("resetBindButtonVisible",false)==true,
keybindOn=C("resetKeybindEnabled",false)==true,
}
local lastReset=-math.huge
local resets=0
local function resetCharacter()
if not runtimeAlive or os.clock()-lastReset<1 then return false end
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if not humanoid or humanoid.Health<=0 then return false end
lastReset=os.clock()
resets=resets+1
pcall(function() humanoid.Health=0 end)
pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Dead) end)
return true
end
runtime.ResetCharacter={Reset=resetCharacter,}
local function removeOldBind()
local roots={}
local hidden=type(gethui)=="function" and gethui or env.gethui
if type(hidden)=="function" then local ok,root=pcall(hidden);if ok and typeof(root)=="Instance" then roots[#roots+1]=root end end
pcall(function() roots[#roots+1]=game:GetService("CoreGui") end)
roots[#roots+1]=LocalPlayer:FindFirstChildOfClass("PlayerGui")
for _,root in ipairs(roots) do
pcall(function()
for _,container in ipairs(root:GetChildren()) do
local old=container:FindFirstChild("VisualsV2_ResetBind")
if old then old:Destroy() end
end
end)
end
end
pcall(removeOldBind)
task.delay(3,function() if runtimeAlive then pcall(removeOldBind) end end)
local function setBindWanted(value)
local function apply()
local bind=runtime.ResetBindButton
if bind and type(bind.SetWanted)=="function" then pcall(bind.SetWanted,value);return true end
return false
end
if apply() then return end
task.spawn(function()
for _=1,100 do
task.wait(0.2)
if not runtimeAlive or state.bindVisible~=value then return end
if apply() then return end
end
end)
end
local bindToggle=addToggle(section,"Show Reset Bindable Button",state.bindVisible,function(value)
state.bindVisible=value;SetCfg("resetBindButtonVisible",value)
setBindWanted(value)
end)
local bindSize=math.clamp(tonumber(C("resetBindButtonSize",tonumber(C("vv2BombJump_BJBindButtonSize",11)) or 11)) or 11,5,25)
section:AddSlider("Reset Bind Button Size",5,25,bindSize,function(value)
bindSize=math.clamp(tonumber(value) or 11,5,25)
SetCfg("resetBindButtonSize",bindSize)
local bind=runtime.ResetBindButton
if bind and type(bind.SetSize)=="function" then pcall(bind.SetSize,bindSize) end
end)
task.spawn(function()
for _=1,50 do
if not runtimeAlive then return end
local text=runtime.ButtonText
if text and type(text.SetHidden)=="function" then pcall(text.SetHidden,{BIND_ID},false);return end
task.wait(0.2)
end
end)
section:AddButton("Reset Bind Button Position",function()
local bind=runtime.ResetBindButton
if bind and type(bind.ResetPosition)=="function" then pcall(bind.ResetPosition) end
end)
local keybindToggle=addToggle(section,"Enable Reset Character Keybind",state.keybindOn,function(value)
state.keybindOn=value;SetCfg("resetKeybindEnabled",value)
end)
section:AddKeybind("Reset Character Keybind","R",function()
if runtimeAlive and state.keybindOn then task.spawn(resetCharacter) end
end)
runtime.RegisterReset(function()
bindToggle:Set(false);keybindToggle:Set(false)
state.bindVisible=false;state.keybindOn=false
setBindWanted(false)
end)
end,"Section \"Reset Character\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE))
if not inMurderMystery then return end
local section=mainTab:AddSection("Shift Lock & Throwables","Utilities")
local GuiService=game:GetService("GuiService")
local mouse=player:GetMouse()
local alive=true
local aimEnabled=C("vv2ThrowableCentreAim",false)
local frameBound=false
local activeAim=nil
local nativeCameras=nil
local aimToggle
local FRAME="VisualsV2_ShiftLockFrame"
local castParams=RaycastParams.new()
castParams.FilterType=Enum.RaycastFilterType.Exclude
castParams.IgnoreWater=true
local namecallMethod=getnamecallmethod or env.getnamecallmethod
local restoreNamecallMethod=setnamecallmethod or env.setnamecallmethod
local hookMeta=hookmetamethod or env.hookmetamethod
local hookFunction=hookfunction or env.hookfunction
local makeClosure=newcclosure or env.newcclosure
local callbackValue=getcallbackvalue or env.getcallbackvalue
local callbackRecords={}
local hookReady=false
local refresh
local positionPairTools={snowballtoy2020=true,waterballoon2024=true}
local instanceIsA=game.IsA
local instanceDescendant=game.IsDescendantOf
local instanceFindChild=game.FindFirstChild
local instanceFindClass=game.FindFirstChildOfClass
local nativeFocusedTextBox=UserInputService.GetFocusedTextBox
local function notify(message,kind)
if alive and runtimeAlive then pcall(function() shared.Notify(message,kind or 3) end) end
end
local function compact(value) return type(value)=="string" and value:lower():gsub("[^%w]","") or "" end
local function throwable(tool)
if not tool or not tool:IsA("Tool") then return false end
local name=compact(tool.Name)
if name=="knife" or name=="gun" then return false end
return tool:GetAttribute("Throwable")==true or tool:GetAttribute("IsThrowable")==true
or name:find("bomb",1,true)~=nil or name:find("grenade",1,true)~=nil
or name:find("snowball",1,true)~=nil or name:find("dynamite",1,true)~=nil
or name:find("beachball",1,true)~=nil or name:find("basketball",1,true)~=nil
or name:find("football",1,true)~=nil or name:find("soccerball",1,true)~=nil
or name:find("volleyball",1,true)~=nil
or name:find("tennisball",1,true)~=nil or name:find("bouncyball",1,true)~=nil
or name:find("superball",1,true)~=nil or name:find("waterballoon",1,true)~=nil
or name:find("throwable",1,true)~=nil or name=="fakec4" or name=="c4"
end
local function equippedThrowable(character)
if character then
for _,tool in ipairs(character:GetChildren()) do if throwable(tool) then return tool end end
end
end
local function nativeCrosshair()
local gui=instanceFindClass(player,"PlayerGui")
local topbar=gui and instanceFindChild(gui,"GameTopbar")
local crosshair=topbar and instanceFindChild(topbar,"Crosshair")
if not crosshair or not instanceIsA(crosshair,"GuiObject") then return nil,false end
local current=crosshair
while current and current~=gui do
if instanceIsA(current,"GuiObject") and not current.Visible then return crosshair,false end
if instanceIsA(current,"ScreenGui") and not current.Enabled then return crosshair,false end
current=current.Parent
end
return crosshair,true
end
local lockFlags,lockFlagsAt,lockFlagsCharacter={},-math.huge,nil
local LOCK_KEYS={"ShiftLocked","ShiftLock","IsShiftLocked","MouseLocked"}
local function shiftLockFlags()
local character=player.Character
if os.clock()-lockFlagsAt<3 and lockFlagsCharacter==character then return lockFlags end
lockFlagsAt=os.clock();lockFlagsCharacter=character
lockFlags={}
for _,object in pairs({player,character,player:FindFirstChildOfClass("PlayerGui")}) do
for _,key in ipairs(LOCK_KEYS) do
local flag=object:FindFirstChild(key,true)
if flag and flag:IsA("BoolValue") then lockFlags[#lockFlags+1]=flag end
end
end
return lockFlags
end
local function nativeLocked()
local crosshair,visible=nativeCrosshair()
if crosshair then return visible end
if nativeCameras then
for _,key in ipairs({"activeMouseLockController","activeCameraController"}) do
local controller=nativeCameras[key]
if type(controller)=="table" and type(controller.GetIsMouseLocked)=="function" then
local ok,value=pcall(controller.GetIsMouseLocked,controller)
if ok and value==true then return true end
end
end
end
for _,object in pairs({player,player.Character,player:FindFirstChildOfClass("PlayerGui")}) do
for _,key in ipairs(LOCK_KEYS) do
if object:GetAttribute(key)==true then return true end
end
end
for _,flag in ipairs(shiftLockFlags()) do
if flag.Parent and flag.Value then return true end
end
return UserInputService.MouseBehavior==Enum.MouseBehavior.LockCenter
end
local function allowedCamera(character,humanoid,cam)
if not character or not humanoid or humanoid.Health<=0 or not cam
or cam.CameraType==Enum.CameraType.Scriptable or UserInputService:GetFocusedTextBox()
or GuiService.MenuIsOpen then return false end
local subject=cam.CameraSubject
return subject==humanoid or (subject and subject:IsDescendantOf(character)) or false
end
local function centreAim(cam,character,tool)
local size=cam.ViewportSize
if size.X<=0 or size.Y<=0 then return nil end
local ok,inset=pcall(function() return GuiService:GetGuiInset() end)
if not ok or typeof(inset)~="Vector2" then inset=Vector2.new(0,0) end
local x,y=size.X/2,size.Y/2
local guiX,guiY=x-inset.X,y-inset.Y
local crosshair,visible=nativeCrosshair()
if visible then
local position,extent=crosshair.AbsolutePosition,crosshair.AbsoluteSize
if typeof(position)=="Vector2" and typeof(extent)=="Vector2" and extent.X>0 and extent.Y>0 then
local candidateX,candidateY=position.X+extent.X/2,position.Y+extent.Y/2
local viewportX,viewportY=candidateX+inset.X,candidateY+inset.Y
if viewportX>=0 and viewportX<=size.X and viewportY>=0 and viewportY<=size.Y then
guiX,guiY=candidateX,candidateY
x,y=viewportX,viewportY
end
end
end
local ray=cam:ViewportPointToRay(x,y,0)
local ignore={character,cam}
local targetFilter=mouse.TargetFilter
if targetFilter then ignore[#ignore+1]=targetFilter end
castParams.FilterDescendantsInstances=ignore
local result=workspace:Raycast(ray.Origin,ray.Direction*1000,castParams)
local position=result and result.Position or ray.Origin+ray.Direction*1000
local handle=tool:FindFirstChild("Handle")
local root=character:FindFirstChild("HumanoidRootPart")
local origin=(handle and handle:IsA("BasePart") and handle.Position) or (root and root.Position) or ray.Origin
local name=compact(tool.Name)
local pointTarget=name:find("beachball",1,true) or name:find("waterballoon",1,true)
or name:find("volleyball",1,true)
return {tool=tool,camera=cam,ray=ray,position=position,
hit=CFrame.new(position)*cam.CFrame.Rotation,target=result and result.Instance or nil,
origin=origin,direction=ray.Direction,
targetMode=pointTarget and "Position" or "LaunchRay",
positionPair=positionPairTools[name]==true,
x=x,y=y,mouseX=guiX,mouseY=guiY,screenX=x,screenY=y}
end
local function sampleAim()
if not alive or not runtimeAlive or not aimEnabled then return nil end
local character=player.Character
local tool=equippedThrowable(character)
if not tool or not nativeLocked() then return nil end
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local cam=workspace.CurrentCamera
if not allowedCamera(character,humanoid,cam) then return nil end
return centreAim(cam,character,tool)
end
local function currentAim()
local aim=activeAim
if not alive or not runtimeAlive or not aimEnabled or not aim
or aim.tool.Parent~=player.Character or aim.camera~=workspace.CurrentCamera
or aim.camera.CameraType==Enum.CameraType.Scriptable or GuiService.MenuIsOpen
or nativeFocusedTextBox(UserInputService) then return nil end
local character=player.Character
local humanoid=character and instanceFindClass(character,"Humanoid")
if not humanoid or humanoid.Health<=0 then return nil end
local subject=aim.camera.CameraSubject
if subject~=humanoid and (not subject or not instanceDescendant(subject,character)) then return nil end
local crosshair,visible=nativeCrosshair()
if crosshair and not visible then return nil end
return aim
end
local function targetValue(value,aim,direction,launchOrigin)
local kind=typeof(value)
local origin=launchOrigin or aim.origin
if kind=="Vector2" then return Vector2.new(aim.mouseX,aim.mouseY) end
local function centredDirection(from)
if aim.targetMode=="Position" then
local delta=aim.position-from
if delta.Magnitude>0.001 then return delta.Unit end
end
return aim.ray.Direction
end
if kind=="Vector3" and direction then return centredDirection(origin)*value.Magnitude end
if kind=="Ray" then return Ray.new(value.Origin,centredDirection(value.Origin)*value.Direction.Magnitude) end
local position=kind=="CFrame" and value.Position or (kind=="Vector3" and value)
if not position then return value end
if aim.targetMode=="Position" then return kind=="CFrame" and aim.hit or aim.position end
local distance=(position-origin).Magnitude
if distance<0.001 or distance~=distance or distance==math.huge then return value end
local centred=origin+aim.ray.Direction*distance
if kind=="CFrame" then return CFrame.lookAt(centred,centred+aim.ray.Direction,aim.camera.CFrame.UpVector) end
return centred
end
local function toolBoundRemote(remote,args,tool)
if instanceDescendant(remote,tool) then return true end
local name=compact(tool.Name)
for i=1,args.n do
local value=args[i]
if value==tool then return true end
if i==1 and type(value)=="string" and compact(value)==name then return true end
if typeof(value)=="table" then
for _,key in ipairs({"Tool","tool","Toy","toy","ToolName","toolName","ToyName","toyName"}) do
local bound=rawget(value,key)
if bound==tool or (type(bound)=="string" and compact(bound)==name) then return true end
end
end
end
return false
end
local function rewritePayload(payload,aim)
if type(payload)~="table" then return nil end
local result=nil
local positions={position=true,targetposition=true,targetpos=true,mouseposition=true,mousepos=true,
mouselocation=true,mousehit=true,mousetarget=true,mouse=true,hit=true,target=true,destination=true}
local origin=payload.Origin or payload.origin or payload.LaunchOrigin or payload.launchOrigin
if typeof(origin)=="CFrame" then origin=origin.Position end
if typeof(origin)~="Vector3" then origin=nil end
for key,value in pairs(payload) do
local name=compact(key)
local valueType=typeof(value)
if (positions[name] or name=="direction" or name=="throwdirection")
and (valueType=="Vector2" or valueType=="Vector3" or valueType=="CFrame" or valueType=="Ray") then
if not result then result=table.clone(payload) end
result[key]=name=="mouselocation" and valueType=="Vector2" and Vector2.new(aim.screenX,aim.screenY)
or targetValue(value,aim,name=="direction" or name=="throwdirection",origin)
end
end
return result
end
local function rewriteArguments(remote,args,aim)
local toolLocal=toolBoundRemote(remote,args,aim.tool)
local name=compact(remote.Name)
local command=type(args[1])=="string" and compact(args[1]) or ""
if command==compact(aim.tool.Name) then command="" end
local function aimOperation(value)
return value:find("throw",1,true)~=nil or value:find("toss",1,true)~=nil
or value:find("launch",1,true)~=nil or value:find("mousepos",1,true)~=nil
or value:find("mouseloc",1,true)~=nil or value:find("mousehit",1,true)~=nil
or value:find("mousetarget",1,true)~=nil or value=="aim" or value=="settarget"
or value=="fire" or value=="shoot" or value=="onclick" or value=="updateaim"
or value=="plantbomb" or value=="leftdown" or value=="leftclick"
or value=="button1down" or value=="mouseclick" or value=="click"
or value=="activated" or value=="activate"
end
local operation=aimOperation(name) or aimOperation(command)
if not toolLocal then return nil end
if not operation and command~="" then return nil end
if not operation then
for _,excluded in ipairs({"explode","equip","purchase","cooldown","sound","reload","texture","color"}) do
if name:find(excluded,1,true) then return nil end
end
end
local output=nil
local candidates={}
for index=1,args.n do
local value=args[index]
local valueType=typeof(value)
if valueType=="table" then
local payload=rewritePayload(value,aim)
if payload then
output=output or table.clone(args)
output[index]=payload
end
elseif valueType=="Vector2" or valueType=="Vector3" or valueType=="CFrame" or valueType=="Ray" then
candidates[#candidates+1]=index
end
end
local pointPair=aim.positionPair and name=="remote" and args.n==2
and typeof(args[1])=="Vector3" and typeof(args[2])=="Vector3"
and remote.Parent==aim.tool and instanceIsA(remote,"RemoteEvent")
if #candidates==1 then
local index=candidates[1]
output=output or table.clone(args)
local value=args[index]
local direction=name:find("direction",1,true)~=nil or command:find("direction",1,true)~=nil
or (operation and typeof(value)=="Vector3" and math.abs(value.Magnitude-1)<=0.001)
if typeof(value)=="Vector2" and (name:find("mouseloc",1,true) or command:find("mouseloc",1,true)) then
output[index]=Vector2.new(aim.screenX,aim.screenY)
else output[index]=targetValue(value,aim,direction) end
elseif #candidates==2 and (operation or pointPair) then
local first,second=args[candidates[1]],args[candidates[2]]
local origin=typeof(first)=="Vector3" and first or (typeof(first)=="CFrame" and first.Position)
if origin and (origin-aim.origin).Magnitude<=8 then
output=output or table.clone(args)
local isDirection=typeof(second)=="Vector3" and second.Magnitude<=1.01
output[candidates[2]]=pointPair and aim.targetMode=="Position" and aim.position
or targetValue(second,aim,isDirection,origin)
end
end
return output
end
local bridge=env.WorldV2ThrowableAimBridge
if type(bridge)~="table" or bridge.version~=3 then
if type(bridge)=="table" then bridge.handler=nil end
bridge={version=3,dispatchers=setmetatable({}, {__mode="k"})}
env.WorldV2ThrowableAimBridge=bridge
end
local handler={}
handler.Enabled=function() return alive and runtimeAlive and aimEnabled end
handler.Remote=function(object,method,args)
if not handler.Enabled() or typeof(object)~="Instance" then return nil end
local aim=currentAim()
if not aim or not toolBoundRemote(object,args,aim.tool) then return nil end
if (method=="FireServer" and instanceIsA(object,"RemoteEvent"))
or (method=="InvokeServer" and instanceIsA(object,"RemoteFunction")) then
local rewritten=rewriteArguments(object,args,aim)
if rewritten then return "args",rewritten end
end
end
handler.Index=function() return false end
handler.Namecall=function(object,method,args)
if method=="FireServer" or method=="InvokeServer" then
return handler.Remote(object,method,args)
end
end
bridge.handler=nil
bridge.callbackLog={}
bridge.remoteMethods=bridge.remoteMethods or {}
local function tradeTransportObject(object)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if typeof(object) ~= "Instance" then return false end
local class = object.ClassName
if class ~= "RemoteEvent" and class ~= "RemoteFunction" then return false end
local at = object
while at do
local name = at.Name
if type(name) == "string" and string.find(string.lower(name), "trade", 1, true) then return true end
at = at.Parent
end
return false
end
local function installNativeRemoteMethods()
if type(hookFunction)~="function" then return false end
for _,spec in ipairs({{"FireServer","RemoteEvent"},{"InvokeServer","RemoteFunction"}}) do
local method,class=spec[1],spec[2]
local record=bridge.remoteMethods[method]
if not record then record={calls=0}; bridge.remoteMethods[method]=record end
if not record.ready then
local temporary=Instance.new(class)
local ok,native=pcall(function() return temporary[method] end)
temporary:Destroy()
if ok and type(native)=="function" then
local previous
local wrapper=function(object,...)
local current=bridge.handler
local thread=coroutine.running() or bridge
if previous and current and current.Enabled() and not bridge.dispatchers[thread] and not tradeTransportObject(object) then
record.calls=record.calls+1
local savedMethod
if type(restoreNamecallMethod)=="function" and type(namecallMethod)=="function" then
local success,value=pcall(namecallMethod)
if success and type(value)=="string" then savedMethod=value end
end
bridge.dispatchers[thread]=true
local success,action,args=pcall(current.Remote,object,method,table.pack(...))
bridge.dispatchers[thread]=nil
if savedMethod then pcall(restoreNamecallMethod,savedMethod) end
if success and action=="args" then return previous(object,table.unpack(args,1,args.n)) end
end
return previous(object,...)
end
if type(makeClosure)=="function" then wrapper=makeClosure(wrapper) end
local success,original=pcall(hookFunction,native,wrapper)
if success and type(original)=="function" then
previous=original; record.ready=true; record.error=nil
else record.error=tostring(original) end
else record.error=tostring(native) end
end
end
local event=bridge.remoteMethods.FireServer
return event and event.ready==true or false
end
local function installHooks()
local nativeReady=installNativeRemoteMethods()
if bridge.namecallReady then return true end
if type(namecallMethod)~="function" then return nativeReady end
local hook=hookMeta
if type(hook)~="function" then
local rawMeta=getrawmetatable or env.getrawmetatable
local readOnly=setreadonly or env.setreadonly
local isReadOnly=isreadonly or env.isreadonly
if type(rawMeta)~="function" or type(readOnly)~="function" then return nativeReady end
hook=function(object,key,replacement)
local mt=rawMeta(object)
local old=mt[key]
local previous=true
if type(isReadOnly)=="function" then previous=isReadOnly(mt) end
readOnly(mt,false)
mt[key]=replacement
readOnly(mt,previous)
return old
end
end
if not bridge.namecallReady then
local previous
-- (the cheap checks come first: every method call in the game passes through here)
local wrapper=function(object,...)
local current=bridge.handler
if not current then return previous(object,...) end
local method=namecallMethod()
if method~="FireServer" and method~="InvokeServer" then return previous(object,...) end
if tradeTransportObject(object) then return previous(object,...) end
local thread=coroutine.running() or bridge
if current.Enabled() and not bridge.dispatchers[thread] then
bridge.namecallRequests=(bridge.namecallRequests or 0)+1
bridge.dispatchers[thread]=true
local ok,action,value=pcall(current.Namecall,object,method,table.pack(...))
bridge.dispatchers[thread]=nil
if type(restoreNamecallMethod)=="function" and type(method)=="string" then
pcall(restoreNamecallMethod,method)
end
if ok and action=="value" then return value end
if ok and action=="args" then return previous(object,table.unpack(value,1,value.n)) end
end
return previous(object,...)
end
if type(makeClosure)=="function" then wrapper=makeClosure(wrapper) end
local ok,original=pcall(hook,game,"__namecall",wrapper)
if not ok or type(original)~="function" then return nativeReady end
previous=original
bridge.namecallReady=true
end
return true
end
local function readCallback(remote)
if type(callbackValue)=="function" then
local ok,value=pcall(callbackValue,remote,"OnClientInvoke")
if ok and type(value)=="function" then return value end
end
local ok,value=pcall(function() return remote.OnClientInvoke end)
return ok and type(value)=="function" and value or nil
end
local function releaseCallback(remote,record)
record.active=false
if readCallback(remote)==record.wrapper then
pcall(function() remote.OnClientInvoke=record.original end)
end
callbackRecords[remote]=nil
end
local function wrapCallback(remote,tool)
local original=readCallback(remote)
if not original then return end
local existing=callbackRecords[remote]
if existing and original==existing.wrapper then return end
if existing then releaseCallback(remote,existing) end
local record={original=original,tool=tool,active=true}
record.wrapper=function(...)
local args=table.pack(...)
local results=table.pack(original(...))
if not record.active then return table.unpack(results,1,results.n) end
local mode=args[1]
if type(mode)=="table" then mode=mode.Mode or mode.mode or mode.Action or mode.action end
local name=compact(mode)
if #bridge.callbackLog>=8 then table.remove(bridge.callbackLog,1) end
local audit={tool=tool,remote=remote,mode=tostring(mode),
originalType=typeof(results[1]),count=results.n,original=table.clone(results)}
bridge.callbackLog[#bridge.callbackLog+1]=audit
local position=name=="mouseposition" or name=="getmouseposition" or name=="targetposition"
local hit=name=="mousehit" or name=="getmousehit" or name=="getmouse" or name=="mouse"
local location=name=="mouselocation" or name=="getmouselocation"
local ray=name=="unitray" or name=="mouseunitray"
if position or hit or location or ray then
local aim=currentAim()
if aim and aim.tool==tool then
local kind=typeof(results[1])
if kind=="Vector2" then
results[1]=location and Vector2.new(aim.screenX,aim.screenY)
or Vector2.new(aim.mouseX,aim.mouseY)
elseif kind=="Vector3" or kind=="CFrame" or kind=="Ray" then
results[1]=targetValue(results[1],aim,false)
elseif results[1]==nil then
results[1]=hit and aim.hit or (ray and aim.ray)
or (location and Vector2.new(aim.screenX,aim.screenY)) or aim.position
results.n=math.max(results.n,1)
end
end
end
audit.forwarded=table.clone(results)
return table.unpack(results,1,results.n)
end
local ok=pcall(function() remote.OnClientInvoke=record.wrapper end)
if ok then callbackRecords[remote]=record end
end
local function refreshCallbacks()
local seen={}
if aimEnabled and alive and runtimeAlive then
for _,container in pairs({player.Character,player:FindFirstChildOfClass("Backpack")}) do
for _,tool in ipairs(container:GetChildren()) do
if throwable(tool) then
for _,remote in ipairs(tool:GetDescendants()) do
if remote:IsA("RemoteFunction") then seen[remote]=true; wrapCallback(remote,tool) end
end
end
end
end
end
for remote,record in pairs(callbackRecords) do
if not seen[remote] then releaseCallback(remote,record) end
end
end
local elapsed=0
refresh=function()
activeAim=nil
if bridge.handler==handler then bridge.handler=nil end
refreshCallbacks()
if not alive or not runtimeAlive or not aimEnabled then
if frameBound then RunService:UnbindFromRenderStep(FRAME); frameBound=false end
return
end
if hookReady then bridge.handler=handler end
if not frameBound then
RunService:BindToRenderStep(FRAME,Enum.RenderPriority.Camera.Value+1,function(dt)
local ok,aim=pcall(sampleAim)
activeAim=ok and aim or nil
elapsed=elapsed+(tonumber(dt) or 0.016)
if elapsed>=0.25 then elapsed=0; pcall(refreshCallbacks) end
end)
frameBound=true
end
end
aimToggle=addToggle(section,"Centre Aim for Throwable Toys",aimEnabled,function(value)
if value then hookReady=installHooks() end
if value and not hookReady and type(callbackValue)~="function" then
aimEnabled=false
SetCfg("vv2ThrowableCentreAim",false)
task.defer(function() if aimToggle then aimToggle:Set(false) end end)
notify("Shift Lock & Throwables: this executor can't redirect the throwable aim, so Centre Aim stays off",1)
else aimEnabled=value; SetCfg("vv2ThrowableCentreAim",value) end
refresh()
end)
env.WorldV2Runtime.RegisterReset(function()
aimEnabled=false; activeAim=nil
aimToggle:Set(false)
refresh()
if not runtimeAlive then
alive=false
if bridge.handler==handler then bridge.handler=nil end
end
end)
task.spawn(function()
local scripts=player:FindFirstChild("PlayerScripts")
local module=scripts and scripts:FindFirstChild("PlayerModule")
if module and module:IsA("ModuleScript") then
local ok,result=pcall(require,module)
if ok and type(result)=="table" and type(result.GetCameras)=="function" then
local cameraOk,cameras=pcall(result.GetCameras,result)
if cameraOk and type(cameras)=="table" and alive and runtimeAlive then nativeCameras=cameras end
end
end
end)
if aimEnabled then
hookReady=installHooks()
if not hookReady and type(callbackValue)~="function" then
aimEnabled=false; SetCfg("vv2ThrowableCentreAim",false)
end
end
refresh()
end,"Section \"Shift Lock & Throwables\"")
;w2Section(function()
if not inMurderMystery then return end
local pending={}
local runtime=env.WorldV2Runtime
local stats={equips=0,shots=0}
local function reportFailure(reason)
stats.error=reason
pcall(function() shared.Notify("Shoot after clutch: "..tostring(reason),1) end)
end
local SHOOT_AT=0.2
local watchers={}
local function delayGroup(key)
key=tostring(key)
return key:find("BombJump",1,true) and "BombJump" or key
end
local function findGun(character)
local backpack=LocalPlayer:FindFirstChildOfClass("Backpack")
for _,container in pairs({character,backpack}) do
if container then
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and runtime.ClientWeaponSkins.GetKind(tool)=="Gun" then return tool end
end
end
end
end
-- (keyboard players: a feature can be given your own ODH shoot key, which is then pressed instead of
-- looking for ODH's on-screen shoot button, which only exists on mobile)
local ownKeys={}
local keyInput=nil
pcall(function() keyInput=game:GetService("VirtualInputManager") end)
local function pressShootKey(name)
local code
pcall(function() code=Enum.KeyCode[name] end)
if not code or code==Enum.KeyCode.Unknown or not keyInput then return false,"your shoot key couldn't be pressed" end
local ok=pcall(function()
keyInput:SendKeyEvent(true,code,false,game)
task.wait(0.03)
keyInput:SendKeyEvent(false,code,false,game)
end)
return ok,ok and nil or "your shoot key couldn't be pressed"
end
local function shootNow(key)
local own=ownKeys[delayGroup(key)]
if own then return pressShootKey(own) end
return runtime.ODHShootMurderer()
end
runtime.JumpGunFollowup={Queue=function(key,character,options,equipDelay)
local token={};pending[key]=token
local jumpedAt=os.clock()
local group=delayGroup(key)
if not equipDelay then
equipDelay=group=="BombJump" and 0.05 or 0.02
end
local timing={key=tostring(key)}
stats.last=timing
task.defer(function()
if pending[key]==token and runtime.ODHShootPrepare then pcall(runtime.ODHShootPrepare) end
end)
task.delay(equipDelay,function()
local function current()
return runtimeAlive and pending[key]==token and LocalPlayer.Character==character
end
if not current() then return end
local equip,shoot=options()
if not equip and not shoot then return end
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if not humanoid or humanoid.Health<=0 then return end
local gun=findGun(character)
if not gun then stats.error="No gun in your character or backpack";return end
if gun.Parent~=character then
local ok=pcall(function() humanoid:EquipTool(gun) end)
if not ok then stats.error="The gun could not be equipped";return end
end
timing.equip=os.clock()-jumpedAt
stats.equips=stats.equips+1
if not shoot then stats.error=nil;return end
local deadline=os.clock()+0.6
while gun.Parent~=character and os.clock()<deadline do
task.wait()
if not current() or humanoid.Health<=0 then return end
end
if gun.Parent~=character then reportFailure("the gun never reached your hand");return end
timing.inHand=os.clock()-jumpedAt
task.wait()
local hold=SHOOT_AT-(os.clock()-jumpedAt)
if hold>0 then task.wait(hold) end
local lastReason
for _=1,5 do
if not current() or humanoid.Health<=0 or gun.Parent~=character then return end
local _,stillShoot=options()
if not stillShoot then return end
local pressedAt=os.clock()-jumpedAt
local fired,reason=shootNow(key)
if fired then timing.pressed=pressedAt;stats.shots=stats.shots+1;stats.error=nil;return end
lastReason=reason
task.wait(0.05)
end
reportFailure(lastReason or "ODH's shoot button did not respond")
end)
end,Watch=function(key,wantsShot)
watchers[key]=wantsShot
end,GetLastTiming=function() return stats.last end,
SetOwnKey=function(key,name) ownKeys[delayGroup(key)]=name end,
}
runtime.ShootMurdererNow=function(character)
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if not humanoid or humanoid.Health<=0 then return false,"you are not alive" end
local gun=findGun(character)
if not gun then return false,"No gun in your character or backpack" end
if gun.Parent~=character then
if not pcall(function() humanoid:EquipTool(gun) end) then return false,"The gun could not be equipped" end
end
local deadline=os.clock()+0.6
while gun.Parent~=character and os.clock()<deadline do
task.wait()
if LocalPlayer.Character~=character or humanoid.Health<=0 then return false,"you died" end
end
if gun.Parent~=character then return false,"the gun never reached your hand" end
task.wait()
local lastReason
for _=1,5 do
if LocalPlayer.Character~=character or humanoid.Health<=0 or gun.Parent~=character then return false,"the gun left your hand" end
local fired,reason=runtime.ODHShootMurderer()
if fired then stats.shots=stats.shots+1;return true end
lastReason=reason
task.wait(0.05)
end
return false,lastReason or "ODH's shoot button did not respond"
end
task.spawn(function()
while runtimeAlive do
task.wait(2)
local wanted=false
for _,wantsShot in pairs(watchers) do
local ok,value=pcall(wantsShot)
if ok and value then wanted=true;break end
end
if wanted and runtime.ODHShootWarm then pcall(runtime.ODHShootWarm) end
end
end)
runtime.RegisterReset(function() table.clear(pending) end)
end,"Part at line 17983")
local autofarmSection,coinAuraControls
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local section=mainTab:AddSection("Auto-farm Helper","Utilities")
autofarmSection=section
local enabled=C("coinAuraEnabled",false)
local savedRadius=tonumber(C("coinAuraRadius",8)) or 8
local radius=math.clamp(savedRadius,1,8)
if radius~=savedRadius then SetCfg("coinAuraRadius",radius) end
local conn=nil
local addedConn,removingConn
local coins,coinIndices,nextTouch={},{},{}
local cursor=1
local elapsed=0
local STEP_INTERVAL=0.1
local RETOUCH_DELAY=0.25
local MAX_CHECKS=256
local MAX_TOUCHES=8
local function hasFireTouchInterest()
return type(firetouchinterest)=="function"
end
local function fireTouch(a,b)
if type(firetouchinterest)~="function" then return false end
local ok0=pcall(function() firetouchinterest(a,b,0) end)
local ok1=pcall(function() firetouchinterest(a,b,1) end)
return ok0 or ok1
end
local function isCoinPart(part)
if not part or not part:IsA("BasePart") or not part:FindFirstChild("TouchInterest") then return false end
local ancestor=part.Parent
while ancestor and ancestor~=workspace do
if ancestor.Name=="CoinContainer" then return true end
ancestor=ancestor.Parent
end
return false
end
local function removeCoin(part)
local index=coinIndices[part]
if not index then return end
local last=coins[#coins]
coins[index]=last
coins[#coins]=nil
coinIndices[part]=nil
nextTouch[part]=nil
if last~=part then coinIndices[last]=index end
if cursor>#coins then cursor=1 end
end
local function addCoin(part)
if coinIndices[part] or not isCoinPart(part) then return end
coins[#coins+1]=part
coinIndices[part]=#coins
end
local function discover(item)
if item:IsA("BasePart") then
addCoin(item)
elseif item.Name=="TouchInterest" and item.Parent then
addCoin(item.Parent)
end
end
local function collect(dt)
if not enabled then return end
elapsed=elapsed+(tonumber(dt) or STEP_INTERVAL)
if elapsed<STEP_INTERVAL then return end
elapsed=elapsed%STEP_INTERVAL
local char=player.Character
local root=char and char:FindFirstChild("HumanoidRootPart")
if not root then return end
local rootPos=root.Position
local radiusSquared=radius*radius
local now=os.clock()
local checked,touched=0,0
local total=#coins
while #coins>0 and checked<total and checked<MAX_CHECKS and touched<MAX_TOUCHES do
if cursor>#coins then cursor=1 end
local part=coins[cursor]
cursor=cursor+1
checked=checked+1
if part.Parent and part:FindFirstChild("TouchInterest") then
if now>=(nextTouch[part] or 0) then
local delta=part.Position-rootPos
local distanceSquared=delta.X*delta.X+delta.Y*delta.Y+delta.Z*delta.Z
if distanceSquared<=radiusSquared then
nextTouch[part]=now+RETOUCH_DELAY
if fireTouch(root,part) then touched=touched+1 end
end
end
else
removeCoin(part)
end
end
end
local function refresh()
if conn then conn:Disconnect(); conn=nil end
if addedConn then addedConn:Disconnect(); addedConn=nil end
if removingConn then removingConn:Disconnect(); removingConn=nil end
table.clear(coins); table.clear(coinIndices); table.clear(nextTouch)
cursor=1; elapsed=0
if not enabled then return end
addedConn=workspace.DescendantAdded:Connect(discover)
removingConn=workspace.DescendantRemoving:Connect(function(item)
if coinIndices[item] then
removeCoin(item)
elseif item.Name=="TouchInterest" and item.Parent then
removeCoin(item.Parent)
end
end)
for _,item in ipairs(workspace:GetDescendants()) do discover(item) end
conn=RunService.Heartbeat:Connect(collect)
end
local toggle
coinAuraControls=function()
toggle=addToggle(section,"Coin Aura",enabled,function(v)
enabled=v
SetCfg("coinAuraEnabled",v)
if v and not hasFireTouchInterest() then
pcall(function()
shared.Notify("Coin Aura: this executor has no firetouchinterest, so coins can't be picked up",1)
end)
end
refresh()
end)
section:AddSlider("Coin Aura Radius",1,8,radius,function(v)
radius=math.clamp(tonumber(v) or 8,1,8)
SetCfg("coinAuraRadius",radius)
end)
end
env.WorldV2Runtime.RegisterReset(function() if toggle then toggle:Set(false) end; enabled=false; refresh() end)
if enabled then refresh() end
end,"Section \"Coin Aura\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local runtime=env.WorldV2Runtime
local roles=runtime.Roles
local section=autofarmSection or mainTab:AddSection("Auto-farm Helper","Utilities")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local alive=true
local state={vote=false,render=true,killAll=false,shoot=false,resetMurd=false,flingMurd=false,resetSheriff=false,flingSheriff=false,resetAll=false,grab=false,
hide=false,hidePlatform=nil,executedLife=nil,resetMurdLife=nil,flingMurdLife=nil,shootThread=nil,blackScreen=nil,noclipConn=nil,noclipped={},connections={}}
local function notify(text,kind) pcall(shared.Notify,text,kind or 3) end
local function whitelisted(plr) return (env.WorldV2Runtime.Whitelist~=nil and env.WorldV2Runtime.Whitelist.Has(plr)) end
local function myRole()
if roles and type(roles.RoleOf)=="function" then
local ok,role=pcall(roles.RoleOf,LocalPlayer)
if ok and role then return role end
end
local info=roles and roles.Data()
local mine=type(info)=="table" and info[LocalPlayer.Name]
if type(mine)=="table" and mine.Role then return mine.Role end
return nil
end
-- (your Knife or Gun, by name or, for a skinned or MMV one with another name, by what kind of weapon it is)
local function tool(name)
local character=LocalPlayer.Character
local backpack=LocalPlayer:FindFirstChildOfClass("Backpack")
local found=(character and character:FindFirstChild(name)) or (backpack and backpack:FindFirstChild(name))
if found then return found end
local skins=runtime.ClientWeaponSkins
if (name=="Knife" or name=="Gun") and skins and type(skins.GetKind)=="function" then
for _,container in ipairs({character or false,backpack or false}) do
if container then
for _,item in ipairs(container:GetChildren()) do
if item:IsA("Tool") then
local ok,kind=pcall(skins.GetKind,item)
if ok and kind==name then return item end
end
end
end
end
end
return nil
end
local function amMurderer() return myRole()=="Murderer" or tool("Knife")~=nil end
local function murderer(skipWhitelisted)
return roles and roles.Murderer(skipWhitelisted and whitelisted or nil)
end
local function sheriff() return roles and roles.Sheriff(whitelisted) end
local function living(plr)
local character=plr and plr.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
return humanoid~=nil and humanoid.Health>0
end
-- (Bomb Fling's own fling, from the Bomb Fling section)
local function bombFling(plr)
local fling=runtime.BombFling
if not fling or type(fling.Fling)~="function" or not living(plr) or whitelisted(plr) then return end
pcall(fling.Fling,plr)
end
local function reset(plr,attempts)
local resetter=runtime.ResetPlayer
if not resetter or type(resetter.Reset)~="function" then return end
for _=1,attempts or 3 do
if not alive or not living(plr) or whitelisted(plr) then return end
resetter.Reset(plr)
task.wait(0.15)
end
end
local function touch(a,b)
pcall(function() firetouchinterest(a,b,0);firetouchinterest(a,b,1) end)
end
local ORDER={"Manor","House 2","Office 3","Hospital 3","Bank 2","Vampire's Castle","Mansion 2","WorkPlace","Hotel 2",
"Farm House","Police Station","Factory","Bio Lab","Research Facility","Mil Base"}
local PAD_NAMES={"VotePad1","VotePad2","VotePad3"}
local OFFSET=Vector3.new(0,1,0)
local function normalize(text) return (tostring(text):lower():gsub("-"," "):gsub("%s+"," "):match("^%s*(.-)%s*$")) end
local function stripParen(text) local at=text:find(" (",1,true);return at and text:sub(1,at-1) or text end
local RANK,BASE,SHORT={},{},{}
for index,name in ipairs(ORDER) do
local full=normalize(name)
local base=stripParen(full)
RANK[full]=index
if not RANK[base] then RANK[base]=index+0.05 end
BASE[index]=base
SHORT[index]=base:match("^(.-)%s+%d+$") or base
end
local rankCache={}
local function rank(raw)
local cached=rankCache[raw]
if cached then return cached end
local low=normalize(raw)
local result=#ORDER*2+1
if low~="" then
if RANK[low] then result=RANK[low]
else
local clean=stripParen(low)
for index=1,#ORDER do if clean==BASE[index] then result=index+0.1;break end end
if result>#ORDER*2 then
for index=1,#ORDER do
local base=BASE[index]
local after=clean:sub(#base+1,#base+1)
if clean:sub(1,#base)==base and (after=="" or after==" ") then result=index+0.2;break end
end
end
if result>#ORDER*2 then
for index=1,#ORDER do if clean==SHORT[index] then result=index+0.3;break end end
end
if result>#ORDER*2 then result=#ORDER+1 end
end
end
rankCache[raw]=result
return result
end
local function openPads()
local open={}
local lobby=workspace:FindFirstChild("Lobby")
local folder=lobby and lobby:FindFirstChild("VotePads")
if not folder then return open end
for _,name in ipairs(PAD_NAMES) do
local pad=folder:FindFirstChild(name)
local trigger=pad and pad:FindFirstChild("Pad")
local gui=pad and pad:FindFirstChild("VoteInfoGui")
local container=gui and gui:FindFirstChild("Container")
local label=container and container:FindFirstChild("MapName")
if trigger and label and gui.Enabled then open[#open+1]={trigger=trigger,gui=gui,map=label.Text} end
end
return open
end
local function smallest(open)
local best,bestRank=nil,math.huge
for _,pad in ipairs(open) do
local value=rank(pad.map)
if value<bestRank then best,bestRank=pad,value end
end
return best
end
local function inside(trigger,position)
local inPad=trigger.CFrame:PointToObjectSpace(position)
local half=trigger.Size*0.5
return math.abs(inPad.X)<=half.X and math.abs(inPad.Y)<=half.Y and math.abs(inPad.Z)<=half.Z
end
local function wanted() return math.clamp(math.floor(#Players:GetPlayers()/2)+2,1,20) end
local vote={votes=0,votedCharacter=nil,wasOpen=false,resetAt=0,readyCharacter=nil,readyAt=0,target=nil,announced=false}
local function voteStep()
if not state.vote then return 0.1 end
local open=openPads()
if #open==0 then vote.wasOpen,vote.target=false,nil;return 0.05 end
if not vote.wasOpen then
vote.wasOpen,vote.votes,vote.votedCharacter,vote.announced=true,0,nil,false
end
local target=vote.target
if not (target and target.gui.Enabled and target.trigger.Parent) then
target=smallest(open);vote.target=target
end
local goal=wanted()
local character=LocalPlayer.Character
if vote.votes>=goal then
if not vote.announced then
vote.announced=true
notify(("Auto Vote Smallest Map: voted %d times for %s"):format(vote.votes,tostring(target and target.map)),2)
end
return 0.2
end
if not character then return 0.05 end
local now=os.clock()
if character==vote.votedCharacter then
local humanoid=character:FindFirstChildOfClass("Humanoid")
if humanoid and now-vote.resetAt>=0.15 then
vote.resetAt=now
pcall(function()
humanoid:ChangeState(Enum.HumanoidStateType.Running)
humanoid:ChangeState(Enum.HumanoidStateType.Dead)
humanoid.Health=0
end)
end
return 0.05
end
if character~=vote.readyCharacter then vote.readyCharacter,vote.readyAt=character,now end
if now-vote.readyAt<0.15 then return vote.readyAt+0.15-now end
local humanoid=character:FindFirstChildOfClass("Humanoid")
local root=humanoid and humanoid.RootPart
if not root or humanoid.Health<=0 then return 0.05 end
local trigger=target.trigger
if not inside(trigger,root.Position) then
root.CFrame=CFrame.new(trigger.Position+OFFSET)*root.CFrame.Rotation
root.AssemblyLinearVelocity=Vector3.zero
end
touch(root,trigger)
task.wait(0.12)
if not state.vote or not target.gui.Enabled or not trigger.Parent then return 0 end
if humanoid.Health>0 and inside(trigger,root.Position) then
touch(root,trigger)
vote.votedCharacter=character
vote.votes=vote.votes+1
vote.resetAt=os.clock()
if vote.votes<wanted() then
pcall(function()
humanoid:ChangeState(Enum.HumanoidStateType.Dead)
humanoid.Health=0
end)
end
end
return 0
end
task.spawn(function()
while alive and runtimeAlive do
local ok,delay=pcall(voteStep)
task.wait(ok and delay or 0.5)
end
end)
local function setRendering(on)
state.render=on
pcall(function() RunService:Set3dRenderingEnabled(on) end)
if on then
if state.blackScreen then state.blackScreen:Destroy();state.blackScreen=nil end
elseif not state.blackScreen then
local gui=Instance.new("ScreenGui")
gui.Name="WorldV2_NoRender"
gui.DisplayOrder=-99999
gui.IgnoreGuiInset=true
gui.ResetOnSpawn=false
local frame=Instance.new("Frame")
frame.Size=UDim2.fromScale(1,1)
frame.BackgroundColor3=Color3.new(0,0,0)
frame.BorderSizePixel=0
frame.Parent=gui
gui.Parent=LocalPlayer:FindFirstChildOfClass("PlayerGui")
state.blackScreen=gui
end
end
local function setNoclip(on)
if state.noclipConn then state.noclipConn:Disconnect();state.noclipConn=nil end
if on then
state.noclipConn=RunService.Stepped:Connect(function()
local character=LocalPlayer.Character
if not character then return end
for _,part in ipairs(character:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
if state.noclipped[part]==nil then state.noclipped[part]=true end
part.CanCollide=false
end
end
end)
return
end
for part in pairs(state.noclipped) do
if part.Parent then pcall(function() part.CanCollide=true end) end
end
table.clear(state.noclipped)
end
local function updateNoclip() setNoclip(state.resetMurd or state.resetSheriff or state.resetAll) end
local function knifeEvent()
local knife=tool("Knife")
local events=knife and knife:FindFirstChild("Events")
return events and events:FindFirstChild("HandleTouched")
end
local function targets()
local list={}
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and plr.Character and not whitelisted(plr) then
local body=plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("Torso")
if body then list[#list+1]=body end
end
end
return list
end
local function killAll()
local event=knifeEvent()
if not event then return end
for _,body in ipairs(targets()) do pcall(function() event:FireServer(body) end) end
end
local function killAllButOne()
local event=knifeEvent()
local list=targets()
if not event or #list<1 then return false end
local survivor=list[math.random(1,#list)]
for _,body in ipairs(list) do
if body~=survivor then pcall(function() event:FireServer(body) end);task.wait(0.05) end
end
return true
end
local function onceThisLife()
local character=LocalPlayer.Character
if not character or state.executedLife==character then return false end
state.executedLife=character
return true
end
local function clickCentre()
local camera=workspace.CurrentCamera
if not camera then return end
local x,y=camera.ViewportSize.X/2,camera.ViewportSize.Y/2
pcall(function()
if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
local virtualUser=game:GetService("VirtualUser")
virtualUser:Button1Down(Vector2.new(x,y),camera.CFrame)
task.wait(0.1)
virtualUser:Button1Up(Vector2.new(x,y),camera.CFrame)
else
local virtualInput=game:GetService("VirtualInputManager")
virtualInput:SendMouseButtonEvent(x,y,0,true,game,0)
task.wait(0.1)
virtualInput:SendMouseButtonEvent(x,y,0,false,game,0)
end
end)
end
local function shootOnce()
local character=LocalPlayer.Character
local shoot=runtime.ShootMurdererNow
if character and type(shoot)=="function" then
local ok,fired=pcall(shoot,character)
if ok and fired then return end
end
local gun=tool("Gun")
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if gun and humanoid and gun.Parent~=character then pcall(function() humanoid:EquipTool(gun) end);task.wait(0.2) end
local taps=runtime.GunTaps
if taps then pcall(taps.Allow,0.5) end
clickCentre()
end
local function startShooting()
if state.shootThread then pcall(task.cancel,state.shootThread) end
state.shootThread=task.spawn(function()
local deadline=os.clock()+30
while alive and state.shoot and os.clock()<deadline do
if not tool("Gun") then task.wait(0.5)
else
local target=murderer(true)
if not target or not living(target) then break end
shootOnce()
task.wait(0.5)
end
end
state.shootThread=nil
end)
end
pcall(function()
task.spawn(function()
local remotes=ReplicatedStorage:WaitForChild("Remotes",30)
local gameplay=remotes and remotes:WaitForChild("Gameplay",30)
local collected=gameplay and gameplay:WaitForChild("CoinCollected",30)
if not collected or not alive then return end
state.connections[#state.connections+1]=collected.OnClientEvent:Connect(function(_,current,maximum)
if not alive or not runtimeAlive or tonumber(current)==nil or tonumber(maximum)==nil or current<maximum then return end
if amMurderer() then
if state.killAll then
task.spawn(function()
local deadline=os.clock()+15
while os.clock()<deadline and not tool("Knife") do task.wait(0.1) end
for round=1,3 do
if not state.killAll or not tool("Knife") then return end
killAll()
if round<3 then task.wait(2.5) end
end
end)
end
return
end
if state.shoot then startShooting() end
if state.resetMurd and not (state.shoot and tool("Gun")) then
task.spawn(function()
task.wait(0.5)
local target=murderer(true)
if target then reset(target,3) end
end)
end
if state.flingMurd and not (state.shoot and tool("Gun")) then
task.spawn(function()
task.wait(0.5)
local target=murderer(true)
if target then bombFling(target) end
end)
end
end)
end)
end)
local loops={}
local function startLoop(key,body)
local token={}
loops[key]=token
task.spawn(function()
while loops[key]==token and alive and runtimeAlive do
local ok,problem=pcall(body)
if not ok then warn("[World V2] Auto-farm Helper: "..tostring(problem));task.wait(1) end
end
end)
end
local function stopLoop(key) loops[key]=nil end
local function resetMurdererThisLife()
local character=LocalPlayer.Character
if not state.resetMurd or not character or state.resetMurdLife==character or amMurderer() then return end
if state.shoot and tool("Gun") then return end
local target=murderer(true)
if target then
state.resetMurdLife=character
task.wait(0.5)
reset(target,3)
end
end
local function flingMurdererThisLife()
local character=LocalPlayer.Character
if not state.flingMurd or not character or state.flingMurdLife==character or amMurderer() then return end
if state.shoot and tool("Gun") then return end
local target=murderer(true)
if target then
state.flingMurdLife=character
task.wait(0.5)
bombFling(target)
end
end
-- Hide Character Under Lobby: while you're in the lobby (or dead, back in the lobby), you're kept
-- on a hidden platform 50 studs under the lobby's spawn. It lets go the moment you're on a round's
-- map, and waits while voting for a map or while Reset Player is resetting someone.
local function lobbySpawn()
local lobby=workspace:FindFirstChild("RegularLobby") or workspace:FindFirstChild("Lobby")
local spawns=lobby and (lobby:FindFirstChild("Spawns") or lobby:FindFirstChild("LobbySpawns"))
local spawn=spawns and (spawns:FindFirstChild("Spawn") or spawns:FindFirstChild("SpawnLocation"))
return spawn and spawn.CFrame or nil
end
local function removeHidePlatform()
if state.hidePlatform then pcall(function() state.hidePlatform:Destroy() end);state.hidePlatform=nil end
end
local function hideStep()
if not state.hide then removeHidePlatform();return end
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local root=character and character:FindFirstChild("HumanoidRootPart")
if not root or not humanoid or humanoid.Health<=0 then return end
local round=runtime.Round
if round and type(round.Has)=="function" and round.Has(LocalPlayer) then return end
if state.vote and #openPads()>0 and vote.votes<wanted() then return end
local resetter=runtime.ResetPlayer
if resetter and type(resetter.GetState)=="function" then
local ok,info=pcall(resetter.GetState)
if ok and type(info)=="table" and info.resetting then return end
end
local spawn=lobbySpawn()
if not spawn then return end
local at=Vector3.new(spawn.X,spawn.Y-50,spawn.Z)
-- (only from the lobby: a round's map is far from it, so the hold never pulls you off a map)
if (root.Position-at).Magnitude>300 then return end
if not (state.hidePlatform and state.hidePlatform.Parent) then
local platform=Instance.new("Part")
platform.Name="W2_UnderLobby"
platform.Size=Vector3.new(30,1,30)
platform.Anchored=true
platform.CanCollide=true
platform.Transparency=1
platform.Parent=workspace
state.hidePlatform=platform
end
state.hidePlatform.CFrame=CFrame.new(at)
local stand=CFrame.new(at+Vector3.new(0,3.5,0))
if (root.Position-stand.Position).Magnitude>6 then
root.CFrame=stand
root.AssemblyLinearVelocity=Vector3.zero
end
end
task.spawn(function()
while alive and runtimeAlive do
pcall(hideStep)
task.wait(0.1)
end
removeHidePlatform()
end)
state.connections[#state.connections+1]=LocalPlayer.CharacterAdded:Connect(function()
if not state.render then task.delay(0.5,function() if not state.render and alive then setRendering(false) end end) end
task.wait(1.5)
if alive and runtimeAlive then pcall(resetMurdererThisLife);pcall(flingMurdererThisLife) end
end)
local controls={}
local function toggle(name,key,callback)
local controller=addToggle(section,name,C(key,false),function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
section:AddParagraph("Auto-farm Helper","Made to go with Overdrive Hub's Auto-farm.\n\nRequired: in ODH's Autofarm tab, set it to return to the lobby, and in its Autofarm section switch on only the Autofarm toggle, nothing else. (Except the Left Tab of Autofarm).\n\nAuto-Shoot Murderer needs Piercer Bullet on in ODH's Combat tab. Exclusive wall check must be off aswell.\n\nSwitch on an anti fling in Antis (W2 Enable IY Anti Fling, or Low-End Device Anti-Fling) while you auto-farm, so nobody can fling you. For long AFK farms also switch on True Anti AFK and True Anti Void.")
toggle("Disable 3D Rendering","w2FarmNoRender",function(value) setRendering(not value) end)
toggle("Auto Vote Smallest Map","w2AutoVoteSmallest",function(value)
state.vote=value
vote.wasOpen,vote.target=false,nil
end)
toggle("Hide Character Under Lobby","w2FarmHideUnderLobby",function(value)
state.hide=value
if not value then removeHidePlatform() end
end)
toggle("Auto-Kill All","w2FarmKillAll",function(value)
state.killAll=value
if not value then stopLoop("killAll");return end
startLoop("killAll",function()
if tool("Knife") and onceThisLife() then
task.wait(1)
killAllButOne()
end
task.wait(0.1)
end)
end)
local shootToggle
shootToggle=toggle("Auto-Shoot Murderer","w2FarmShoot",function(value)
state.shoot=value
if not value and state.shootThread then pcall(task.cancel,state.shootThread);state.shootThread=nil end
end)
-- (Auto-Reset Murderer and Bomb Fling Murderer: one or the other, so they never get in each
-- other's way; turning one on turns the other off)
-- (both saved on from before: only one is kept)
if C("w2FarmResetMurd",false)==true and C("w2FarmFlingMurd",false)==true then SetCfg("w2FarmFlingMurd",false) end
local resetMurdToggle,flingMurdToggle
resetMurdToggle=toggle("Auto-Reset Murderer","w2FarmResetMurd",function(value)
state.resetMurd=value
updateNoclip()
if value then
if flingMurdToggle and state.flingMurd then task.defer(function() flingMurdToggle:Set(false) end) end
task.spawn(resetMurdererThisLife)
end
end)
flingMurdToggle=toggle("Bomb Fling Murderer","w2FarmFlingMurd",function(value)
state.flingMurd=value
if value then
if resetMurdToggle and state.resetMurd then task.defer(function() resetMurdToggle:Set(false) end) end
task.spawn(flingMurdererThisLife)
end
end)
-- (Auto-Reset Sheriff and Bomb Fling Sheriff: one or the other, like the murderer pair)
if C("w2FarmResetSheriff",false)==true and C("w2FarmFlingSheriff",false)==true then SetCfg("w2FarmFlingSheriff",false) end
local resetSheriffToggle,flingSheriffToggle
resetSheriffToggle=toggle("Auto-Reset Sheriff","w2FarmResetSheriff",function(value)
state.resetSheriff=value
updateNoclip()
if value and flingSheriffToggle and state.flingSheriff then task.defer(function() flingSheriffToggle:Set(false) end) end
if not value then stopLoop("sheriff");return end
startLoop("sheriff",function()
if not amMurderer() then
local target=sheriff()
if target then
reset(target,3)
while state.resetSheriff and sheriff() and not amMurderer() do task.wait(0.5) end
end
end
task.wait(0.3)
end)
end)
-- Bomb Fling Sheriff: at the start of each round you're in (not as the murderer, and without the
-- gun yourself), the sheriff is bomb-flung so the gun drops early for you to grab. Up to 3 tries,
-- 4 s apart, while the sheriff is still alive with the gun.
flingSheriffToggle=toggle("Bomb Fling Sheriff","w2FarmFlingSheriff",function(value)
state.flingSheriff=value
if value and resetSheriffToggle and state.resetSheriff then task.defer(function() resetSheriffToggle:Set(false) end) end
if not value then stopLoop("flingSheriff");return end
local doneRound=nil
startLoop("flingSheriff",function()
local round=runtime.Round
local key=round and type(round.Key)=="function" and round.Key() or nil
if key and key~=doneRound and type(round.Has)=="function" and round.Has(LocalPlayer)
and not amMurderer() and not tool("Gun") then
local target=sheriff()
if target then
doneRound=key
for try=1,3 do
if not state.flingSheriff or not living(target) or tool("Gun") then break end
local holds=roles and roles.Holds
if try>1 and type(holds)=="function" and not holds(target,"Gun") then break end
bombFling(target)
task.wait(4)
end
end
end
task.wait(0.3)
end)
end)
toggle("Auto-Reset All","w2FarmResetAll",function(value)
state.resetAll=value
updateNoclip()
if not value then stopLoop("all");return end
local done=false
startLoop("all",function()
if amMurderer() then
if not done and tool("Knife") and onceThisLife() then
task.wait(1)
killAllButOne()
done=true
elseif done and not tool("Knife") then done=false end
else
local target=murderer(false)
if not done and target then
for _,plr in ipairs(Players:GetPlayers()) do
if not state.resetAll then break end
if plr~=LocalPlayer and plr~=target and not whitelisted(plr) and living(plr) then
reset(plr,1)
task.wait(0.2)
end
end
done=true
elseif done and not target then done=false end
end
task.wait(0.1)
end)
end)
toggle("Auto-Grab Gun","w2FarmGrabGun",function(value)
state.grab=value
if not value then stopLoop("grab");return end
startLoop("grab",function()
local finder=runtime.GunDrop
local drop=finder and finder.Find() or workspace:FindFirstChild("GunDrop",true)
local character=LocalPlayer.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
if drop and drop:IsA("BasePart") and root and not tool("Gun") then
touch(root,drop)
task.wait(0.5)
end
task.wait(0.5)
end)
end)
if coinAuraControls then coinAuraControls() end
runtime.RegisterReset(function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
table.clear(loops)
state.vote=false
state.hide=false;state.flingMurd=false;state.resetMurd=false;state.flingSheriff=false
removeHidePlatform()
setRendering(true)
setNoclip(false)
if state.shootThread then pcall(task.cancel,state.shootThread);state.shootThread=nil end
if not runtimeAlive then
alive=false
for _,connection in ipairs(state.connections) do pcall(function() connection:Disconnect() end) end
table.clear(state.connections)
end
end)
end,"Section \"Auto-farm Helper\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local alive=true
local pending={}
local vv2Features={}
local runtime=env.WorldV2Runtime
local resetHooks={}
local function vv2Spawn(callback)
local record={}
pending[record]=true
record.thread=task.spawn(function()
if alive and runtimeAlive then callback() end
pending[record]=nil
end)
return record.thread
end
local table_insert = table.insert
local Maid = {}
Maid.__index = Maid
function Maid.new()
return setmetatable({_tasks = {}, _destroyed = false}, Maid)
end
function Maid:GiveTask(task)
if self._destroyed then
self:_cleanupTask(task)
return
end
table_insert(self._tasks, task)
return task
end
function Maid:GiveTasks(...)
for _, task in ipairs({...}) do
self:GiveTask(task)
end
end
function Maid:_cleanupTask(task)
local taskType = typeof(task)
if taskType == "RBXScriptConnection" then
task:Disconnect()
elseif taskType == "Instance" then
task:Destroy()
elseif taskType == "function" then
task()
elseif taskType == "table" and type(task.Destroy) == "function" then
task:Destroy()
end
end
function Maid:DoCleaning()
if self._destroyed then return end
self._destroyed = true
for _, task in ipairs(self._tasks) do
pcall(function() self:_cleanupTask(task) end)
end
self._tasks = {}
end
function Maid:Destroy()
self:DoCleaning()
end
local RootMaid = Maid.new()
local shared = odh_shared_plugins
local Services = {
Players = game:GetService("Players"),
ReplicatedStorage = game:GetService("ReplicatedStorage"),
RunService = game:GetService("RunService"),
UserInputService = game:GetService("UserInputService"),
StarterGui = game:GetService("StarterGui"),
Workspace = game:GetService("Workspace"),
TweenService = game:GetService("TweenService"),
SoundService = game:GetService("SoundService")
}
local LocalPlayer = Services.Players.LocalPlayer
local __PCLR = Color3.new
local __RGB = Color3.fromRGB
local __UD2 = UDim2.new
local __UD = UDim.new
local __V2 = Vector2.new
local function getfserv(s)
local ok, svc = pcall(function() return game:GetService(s) end)
if ok and svc then return svc end
ok, svc = pcall(function() return game:FindService(s) end)
if ok and svc then return svc end
return game[s]
end
local __RS = getfserv("RunService")
local __UIS = getfserv("UserInputService")
local __TS = getfserv("TweenService")
local POSITIONS_KEY="vv2BombJumpButtonPositions"
local LEGACY_POSITION_FILE="VisualsV2_BombJump_positions.json"
local function savePositions(data)
SetCfg(POSITIONS_KEY,table.clone(data))
end
local function loadPositions()
local saved=C(POSITIONS_KEY,nil)
if type(saved)=="table" then return table.clone(saved) end
local ok,result=pcall(function()
if type(read)=="function" and (type(exists)~="function" or exists(LEGACY_POSITION_FILE)) then
return HttpService:JSONDecode(read(LEGACY_POSITION_FILE))
end
end)
local positions={}
if ok and type(result)=="table" then
for _,id in ipairs({"VV2_BombJump_Big","VV2_BombJump_Bind","VV2_GoldBombJump_Big","VV2_GoldBombJump_Bind"}) do
if type(result[id])=="table" then positions[id]=result[id] end
end
end
savePositions(positions)
return positions
end
local savedPositions = loadPositions()
local BBSystem = {Buttons = {}, Connections = {}, Maids = {}}
local BindableButtons = {Buttons = {}, Maids = {}, Count = 0}
local function spotOf(gui)
local spots = env.WorldV2Runtime.ScreenSpot
return spots and spots.Of(gui) or gui.Position
end
local function placeAt(gui, spot)
local spots = env.WorldV2Runtime.ScreenSpot
if spots then spots.Place(gui, spot) else gui.Position = spot end
end
local BIG_STORAGE = "@BBStorage"
local BIND_STORAGE = "@bindstorage"
local LEGACY_STORAGES = {VV2_BombJump_BigStorage = true, VV2_BombJump_BindStorage = true, VV2_BombJump_HiddenGui = true}
local function guiRoots()
local roots = {}
local function add(root)
if typeof(root) ~= "Instance" then return end
for _, existing in ipairs(roots) do if existing == root then return end end
roots[#roots + 1] = root
end
if type(gethui) == "function" then
local ok, result = pcall(gethui)
if ok then add(result) end
end
pcall(function() add(getfserv("CoreGui")) end)
add(LocalPlayer:FindFirstChildOfClass("PlayerGui"))
return roots
end
local function getStorage(name)
local roots = guiRoots()
local parent = roots[1]
if parent then
local ok, existing = pcall(function() return parent:FindFirstChild(name) end)
if ok and typeof(existing) == "Instance" and existing:IsA("LayerCollector") then return existing end
end
local sg = Instance.new("ScreenGui")
sg.Name = name
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
pcall(function() sg.ScreenInsets = Enum.ScreenInsets.None end)
local placed = parent and pcall(function() sg.Parent = parent end) and sg.Parent ~= nil
if not placed then
sg.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
end
return sg
end
local function removeStaleCopies(id, keep)
for _, root in ipairs(guiRoots()) do
pcall(function()
for _, container in ipairs(root:GetChildren()) do
local name = container.Name
if name == BIG_STORAGE or name == BIND_STORAGE or LEGACY_STORAGES[name] then
for _, child in ipairs(container:GetChildren()) do
if child.Name == id and child ~= keep then pcall(function() child:Destroy() end) end
end
if LEGACY_STORAGES[name] and #container:GetChildren() == 0 then
pcall(function() container:Destroy() end)
end
end
end
end)
end
end
local function bb_safecallback(callback)
if not callback then return end
local ok, err = xpcall(callback, function(e) return debug.traceback(e) end)
if not ok then warn("[BB ERROR] " .. tostring(err)) end
end
local __BB_GRAD_SEQ = ColorSequence.new({
ColorSequenceKeypoint.new(0, __PCLR(0.0784314, 0.0784314, 0.0784314)),
ColorSequenceKeypoint.new(0.75, __PCLR(0.0784314, 0.0784314, 0.54902)),
ColorSequenceKeypoint.new(1, __PCLR(0.470588, 0.156863, 0.470588))
})
local function BB_MakeDraggable(gui, maid, func, ripple, sound)
local dragging, dragInput, dragStart, startPos
local hasMoved = false
local tInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local normalSize,normalTxtSize,bigSize,bigTxtSize
maid:GiveTask(gui.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
normalSize,normalTxtSize=gui.Size,gui.TextSize
bigSize=__UD2(normalSize.X.Scale*1.1,normalSize.X.Offset*1.1,
normalSize.Y.Scale*1.1,normalSize.Y.Offset*1.1)
bigTxtSize=normalTxtSize*1.1
dragging = true
hasMoved = false
dragStart = input.Position
startPos = gui.Position
__TS:Create(gui, tInfo, {Size = bigSize, TextSize = bigTxtSize}):Play()
local absPos = gui.AbsolutePosition
ripple.Position = __UD2(0, input.Position.X - absPos.X, 0, input.Position.Y - absPos.Y)
ripple.Size = __UD2(0, 0, 0, 0)
ripple.BackgroundTransparency = 0.5
ripple.Visible = true
sound:Play()
__TS:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
Size = __UD2(0, 300, 0, 300),
BackgroundTransparency = 1
}):Play()
local rel
rel = maid:GiveTask(__UIS.InputEnded:Connect(function(endInput)
if endInput.UserInputType == input.UserInputType then
dragging = false
rel:Disconnect()
__TS:Create(gui, tInfo, {Size = normalSize, TextSize = normalTxtSize}):Play()
if not hasMoved then bb_safecallback(func) end
if hasMoved and not lockBigButtonPos then
local spot = spotOf(gui)
savedPositions[gui.Name] = {
xs = spot.X.Scale, xo = spot.X.Offset,
ys = spot.Y.Scale, yo = spot.Y.Offset
}
savePositions(savedPositions)
end
end
end))
end
end))
maid:GiveTask(gui.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end))
maid:GiveTask(__UIS.InputChanged:Connect(function(input)
if input == dragInput and dragging then
if lockBigButtonPos then return end
local delta = input.Position - dragStart
if delta.Magnitude > 7 then hasMoved = true end
if not hasMoved then return end
gui.Position = __UD2(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end))
end
local function AddBigButton(id, text, func, isGold)
if BBSystem.Buttons[id] then return BBSystem.Buttons[id] end
local storage = getStorage(BIG_STORAGE)
local buttonMaid=Maid.new()
local bb = Instance.new("TextButton")
bb.Name = id
bb.Size = __UD2(0, 200, 0, 75)
local sp = savedPositions[id]
local function finite(value) return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge end
if type(sp) == "table" and finite(sp.xs) and finite(sp.xo) and finite(sp.ys) and finite(sp.yo) then
bb.Position = __UD2(sp.xs, sp.xo, sp.ys, sp.yo)
else
bb.Position = __UD2(0.5, 0, 0.5, 0)
end
bb.AnchorPoint = __V2(0.5, 0.5)
bb.BackgroundColor3 = __RGB(255, 255, 255)
bb.BackgroundTransparency = 0.9
bb.BorderSizePixel = 0
bb.Font = Enum.Font.Jura
bb.Text = text
bb.TextSize = 24
bb.TextColor3 = __RGB(255, 255, 255)
bb.TextWrapped = true
bb.ClipsDescendants = true
bb.AutoButtonColor = false
bb.ZIndex = 5
Instance.new("UICorner", bb).CornerRadius = __UD(0, 5)
local stroke = Instance.new("UIStroke")
stroke.Color = __RGB(255, 255, 255)
stroke.Thickness = 1.5
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = bb
local gradient = Instance.new("UIGradient")
local defaultGradient = __BB_GRAD_SEQ
if isGold then
defaultGradient = ColorSequence.new({
ColorSequenceKeypoint.new(0, __RGB(255, 215, 0)),
ColorSequenceKeypoint.new(0.5, __RGB(255, 140, 0)),
ColorSequenceKeypoint.new(1, __RGB(184, 134, 11))
})
end
gradient.Color = defaultGradient
gradient.Parent = stroke
local buttonStyle = env.WorldV2Runtime.BigButtonStyle
if buttonStyle then buttonStyle.Track(gradient, defaultGradient) end
local ripple = Instance.new("Frame")
ripple.Name = "@ripple"
ripple.BackgroundColor3 = isGold and __RGB(255, 215, 0) or __RGB(0, 155, 255)
ripple.BackgroundTransparency = 0.5
ripple.ZIndex = 4
ripple.Size = __UD2(0, 0, 0, 0)
ripple.AnchorPoint = __V2(0.5, 0.5)
ripple.Visible = false
ripple.Parent = bb
Instance.new("UICorner", ripple).CornerRadius = __UD(1, 0)
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://3868133279"
ButtonAudio:Register(sound,0.5)
sound.Parent = bb
buttonMaid:GiveTask(bb)
BB_MakeDraggable(bb, buttonMaid, func, ripple, sound)
BBSystem.Connections[id] = buttonMaid:GiveTask(__RS.RenderStepped:Connect(function()
gradient.Rotation = (gradient.Rotation + 1) % 360
end))
bb.Parent = storage
placeAt(bb, bb.Position)
BBSystem.Maids[id]=buttonMaid
BBSystem.Buttons[id] = bb
return bb
end
local function DeleteBigButton(id)
if BBSystem.Connections[id] then
pcall(function() BBSystem.Connections[id]:Disconnect() end)
BBSystem.Connections[id] = nil
end
if BBSystem.Maids[id] then BBSystem.Maids[id]:Destroy();BBSystem.Maids[id]=nil end
if BBSystem.Buttons[id] then pcall(function() BBSystem.Buttons[id]:Destroy() end) end
BBSystem.Buttons[id] = nil
end
local __SHAPES = {
[0] = "rbxassetid://86221076925479",
[1] = "rbxassetid://96242665417546",
[2] = "rbxassetid://97129189935336",
[3] = "rbxassetid://76165862027868",
[4] = "rbxassetid://125868092127496"
}
local __NORMAL_COLOR = ColorSequence.new({
ColorSequenceKeypoint.new(0, __PCLR(0.133333, 0.827451, 0.494118)),
ColorSequenceKeypoint.new(0.6, __PCLR(0.231373, 0.509804, 0.498039)),
ColorSequenceKeypoint.new(1, __PCLR(0.501961, 0.501961, 0.501961))
})
local __WAIT_COLOR = ColorSequence.new({
ColorSequenceKeypoint.new(0, __PCLR(0.827451, 0.133333, 0.133333)),
ColorSequenceKeypoint.new(0.6, __PCLR(0.509804, 0.231373, 0.231373)),
ColorSequenceKeypoint.new(1, __PCLR(0.501961, 0.501961, 0.501961))
})
local __GOLD_NORMAL_COLOR = ColorSequence.new({
ColorSequenceKeypoint.new(0, __RGB(255, 215, 0)),
ColorSequenceKeypoint.new(0.6, __RGB(255, 140, 0)),
ColorSequenceKeypoint.new(1, __RGB(184, 134, 11))
})
local __GOLD_WAIT_COLOR = ColorSequence.new({
ColorSequenceKeypoint.new(0, __RGB(255, 69, 0)),
ColorSequenceKeypoint.new(0.6, __RGB(139, 69, 19)),
ColorSequenceKeypoint.new(1, __RGB(160, 82, 45))
})
local function __BIND_READY(isGold)
local default = isGold and __GOLD_NORMAL_COLOR or __NORMAL_COLOR
local buttonStyle = env.WorldV2Runtime.BigButtonStyle
if buttonStyle and type(buttonStyle.BindSequence) == "function" then
local ok, sequence = pcall(buttonStyle.BindSequence, true, default)
if ok and typeof(sequence) == "ColorSequence" then return sequence end
end
return default
end
local function bind_safecallback(callback)
if not callback then return end
local ok, err = xpcall(callback, function(e) return debug.traceback(e) end)
if not ok then warn("[BIND ERROR] " .. tostring(err)) end
end
local function Bind_MakeDraggable(gui, maid, ripple, sound, clickFunc)
local dragging, dragInput, dragStart, startPos
local hasMoved = false
maid:GiveTask(gui.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging, dragStart, startPos = true, input.Position, gui.Position
hasMoved = false
sound:Play()
local absPos = gui.AbsolutePosition
ripple.Position = __UD2(0, input.Position.X - absPos.X, 0, input.Position.Y - absPos.Y)
ripple.Size = __UD2(0, 0, 0, 0)
ripple.BackgroundTransparency = 0.5
ripple.Visible = true
__TS:Create(ripple, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
Size = __UD2(0, 45, 0, 45),
BackgroundTransparency = 1
}):Play()
local rel
rel = maid:GiveTask(__UIS.InputEnded:Connect(function(endInput)
if endInput.UserInputType == input.UserInputType then
dragging = false
rel:Disconnect()
if not hasMoved then
bind_safecallback(clickFunc)
end
local spot = spotOf(gui)
local px, py = spot.X.Scale, spot.Y.Scale
local sane = px == px and py == py and math.abs(px) < 10 and math.abs(py) < 10
if hasMoved and not lockBindButtonPos and sane then
savedPositions[gui.Name] = {
xs = px, xo = spot.X.Offset,
ys = py, yo = spot.Y.Offset
}
savePositions(savedPositions)
end
end
end))
end
end))
maid:GiveTask(gui.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end))
maid:GiveTask(__UIS.InputChanged:Connect(function(input)
if input == dragInput and dragging then
if lockBindButtonPos then return end
local delta = input.Position - dragStart
if delta.Magnitude > 7 then hasMoved = true end
if not hasMoved then return end
local screen = gui.Parent and gui.Parent:IsA("GuiBase2d") and gui.Parent.AbsoluteSize
if not screen or screen.X <= 1 or screen.Y <= 1 then return end
gui.Position = __UD2(startPos.X.Scale + (delta.X / screen.X), 0, startPos.Y.Scale + (delta.Y / screen.Y), 0)
end
end))
end
function BindableButtons.AddBButton(id, text, clickFunc, isGold)
if BindableButtons.Buttons[id] then return BindableButtons.Buttons[id] end
local storage = getStorage(BIND_STORAGE)
local buttonMaid = Maid.new()
local camera = workspace.CurrentCamera
local screen = camera and camera.ViewportSize or __V2(1920, 1080)
if screen.X <= 1 or screen.Y <= 1 then screen = __V2(1920, 1080) end
local buttonSizeY = 0.11
local widthScale = buttonSizeY * (screen.Y / screen.X)
local sp = savedPositions[id]
local function finite(value) return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge end
local xPos, yPos
if type(sp) == "table" and finite(sp.xs) and finite(sp.ys) then
xPos = math.clamp(sp.xs, 0, 1)
yPos = math.clamp(sp.ys, 0, 1)
else
xPos = 0.1 + ((BindableButtons.Count % 8) * (widthScale + 0.005))
yPos = 0.9 - (math.floor(BindableButtons.Count / 8) * (buttonSizeY + 0.015))
end
local ImageButton = Instance.new("ImageButton")
ImageButton.Name = id
ImageButton.Size = __UD2(widthScale, 0, buttonSizeY, 0)
ImageButton.Position = __UD2(xPos, 0, yPos, 0)
ImageButton.AnchorPoint = __V2(0.5, 0.5)
ImageButton.Image = __SHAPES[0]
ImageButton.BackgroundTransparency = 1
ImageButton.BorderSizePixel = 0
ImageButton.ClipsDescendants = false
ImageButton.AutoButtonColor = false
buttonMaid:GiveTask(ImageButton)
local TextLabel = Instance.new("TextLabel", ImageButton)
TextLabel.Name = "@Text"
TextLabel.Size = __UD2(0.8, 0, 0.8, 0)
TextLabel.Position = __UD2(0.5, 0, 0.5, 0)
TextLabel.AnchorPoint = __V2(0.5, 0.5)
TextLabel.BackgroundTransparency = 1
TextLabel.Font = Enum.Font.Jura
TextLabel.Text = text
TextLabel.TextColor3 = __PCLR(1, 1, 1)
TextLabel.TextSize = 10
TextLabel.TextWrapped = true
TextLabel.ZIndex = 3
local Aspect = Instance.new("UIAspectRatioConstraint", ImageButton)
Aspect.AspectRatio = 1
Aspect.AspectType = Enum.AspectType.ScaleWithParentSize
local Stroke = Instance.new("UIGradient", ImageButton)
Stroke.Name = "@Stroke"
ImageButton:SetAttribute("VV2Gold", isGold == true)
Stroke.Color = __BIND_READY(isGold)
local ripple = Instance.new("Frame")
ripple.Name = "@ripple"
ripple.BackgroundColor3 = isGold and __RGB(255, 215, 0) or __RGB(0, 155, 255)
ripple.BackgroundTransparency = 0.5
ripple.Size = __UD2(0, 0, 0, 0)
ripple.AnchorPoint = __V2(0.5, 0.5)
ripple.Visible = false
ripple.ZIndex = 2
ripple.Parent = ImageButton
Instance.new("UICorner", ripple).CornerRadius = __UD(1, 0)
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://3868133279"
ButtonAudio:Register(sound,0.5)
sound.Parent = ImageButton
Bind_MakeDraggable(ImageButton, buttonMaid, ripple, sound, clickFunc)
buttonMaid:GiveTask(__RS.RenderStepped:Connect(function()
Stroke.Rotation = (Stroke.Rotation + 1) % 360
end))
ImageButton.Parent = storage
placeAt(ImageButton, ImageButton.Position)
BindableButtons.Buttons[id] = ImageButton
BindableButtons.Maids[id] = buttonMaid
BindableButtons.Count = BindableButtons.Count + 1
return ImageButton
end
function BindableButtons.DeleteBButton(id)
if BindableButtons.Maids[id] then
BindableButtons.Maids[id]:Destroy()
BindableButtons.Maids[id] = nil
end
if BindableButtons.Buttons[id] then pcall(function() BindableButtons.Buttons[id]:Destroy() end) end
BindableButtons.Buttons[id] = nil
end
function BindableButtons.UpdateBButtonText(id, text, isWaiting, isGold)
local btn = BindableButtons.Buttons[id]
if not btn then return end
local textLabel = btn:FindFirstChild("@Text")
if textLabel then
textLabel.Text = text
end
local stroke = btn:FindFirstChild("@Stroke")
btn:SetAttribute("VV2Waiting", isWaiting == true)
if stroke then
if isWaiting then
stroke.Color = isGold and __GOLD_WAIT_COLOR or __WAIT_COLOR
else
stroke.Color = __BIND_READY(isGold)
end
end
end
do
local buttonStyle = env.WorldV2Runtime.BigButtonStyle
if buttonStyle and type(buttonStyle.OnChange) == "function" then
buttonStyle.OnChange(function()
for _, btn in pairs(BindableButtons.Buttons) do
local stroke = btn:FindFirstChild("@Stroke")
if stroke and not btn:GetAttribute("VV2Waiting") then stroke.Color = __BIND_READY(btn:GetAttribute("VV2Gold") == true) end
end
end)
end
end
local buttonSpecs = {}
local function currentButton(id)
local spec = buttonSpecs[id]
if not spec then return nil end
if spec.kind == "bind" then return BindableButtons.Buttons[id] end
return BBSystem.Buttons[id]
end
local function liveButton(id)
local button = currentButton(id)
if not button then return nil end
local ok, live = pcall(function()
local storage = button.Parent
return storage ~= nil and storage.Parent ~= nil
end)
if ok and live then return button end
return nil
end
local function removeButton(id)
local spec = buttonSpecs[id]
if spec and spec.kind == "bind" then BindableButtons.DeleteBButton(id) else DeleteBigButton(id) end
end
local function ensureButton(id)
local spec = buttonSpecs[id]
if not spec then return end
if not (alive and runtimeAlive and spec.wanted) then
if currentButton(id) then removeButton(id) end
return
end
local button = liveButton(id)
if not button then
removeButton(id)
local ok, result = pcall(function()
if spec.kind == "bind" then
return BindableButtons.AddBButton(id, spec.text, spec.click, spec.gold)
end
return AddBigButton(id, spec.text, spec.click, spec.gold)
end)
if not ok or typeof(result) ~= "Instance" then
spec.error = tostring(result)
return
end
button = result
spec.error = nil
spec.built = (spec.built or 0) + 1
removeStaleCopies(id, button)
end
if spec.style then pcall(spec.style, button) end
end
local function setButtonWanted(id, wanted)
local spec = buttonSpecs[id]
if not spec then return end
spec.wanted = wanted == true
ensureButton(id)
end
local function styleButton(id)
local button = currentButton(id)
local spec = buttonSpecs[id]
if button and spec and spec.style then pcall(spec.style, button) end
end
local section=inMurderMystery and mainTab:AddSection("Bomb Jump Clutch","Utilities")
or setmetatable({},{__index=function() return function() end end})
local vv2Controls={}
local function settingKey(label)
return "vv2BombJump_"..label:gsub("[^%w]","")
end
local function savedToggle(label,legacyLabel)
return C(settingKey(legacyLabel or label),false)==true
end
local function controlLabel(label)
if label:sub(1,3)=="W2 " then return label end
return "W2 "..label
end
local proxy={}
function proxy:AddLabel(label)
return section:AddLabel(controlLabel(label))
end
function proxy:AddToggle(label,callback,legacyLabel,startsOn)
local key=settingKey(legacyLabel or label)
local controller=addToggle(section,controlLabel(label),C(key,startsOn==true)==true,function(value)
SetCfg(key,value)
callback(value)
end)
vv2Controls[#vv2Controls+1]=controller
return controller
end
function proxy:AddSlider(label,min,max,default,callback)
local key=settingKey(label)
local saved=math.clamp(tonumber(C(key,default)) or default,min,max)
section:AddSlider(controlLabel(label),min,max,saved,function(value)
SetCfg(key,value)
callback(value)
end)
callback(saved)
end
function proxy:AddTextBox(label,callback)
return section:AddTextBox(controlLabel(label),function(...)
if alive and runtimeAlive then callback(...) end
end)
end
function proxy:AddButton(label,callback)
return section:AddButton(controlLabel(label),function()
if alive and runtimeAlive then callback() end
end)
end
function proxy:AddKeybind(label,defaultKey,callback)
local saved=C(settingKey(label),defaultKey)
local controller=section:AddKeybind(controlLabel(label),saved,function(...)
if alive and runtimeAlive then callback(...) end
end)
if type(controller)=="table" then
for _,name in ipairs({"Destroy","Disconnect"}) do
if type(controller[name])=="function" then
RootMaid:GiveTask(function() pcall(controller[name],controller) end)
break
end
end
end
return controller
end
local BombJump={AddSection=function(_,title)
if title=="Gold Bomb Jump+" then proxy:AddLabel("Gold Bomb Jump Options") end
return proxy
end}
local _game = (game.GameId==10413186812 or game.GameId==10769671266) and "Murder Mystery Modded"
or game.GameId==66654135 and "Murder Mystery 2" or shared.game_name
local lastJumpAt, lastNotice = nil, 0
local function failure(reason, notify)
if notify and os.clock() - lastNotice > 3 then
lastNotice = os.clock()
pcall(function() shared.Notify("Bomb Jump: " .. tostring(reason), 1) end)
end
end
if _game == "Murder Mystery 2" or _game == "Murder Mystery Modded" then
local section = BombJump:AddSection("Bomb Jump Clutch", "MM2/MMV")
local CONFIG = {
CooldownTime = 22.0,
LaunchPower = 58,
MinSize = 50,
MaxSize = 300,
DefaultSize = 90
}
local equipGunAfterJump=savedToggle("Equip Gun After Bomb Jump")
local shootAfterJump=savedToggle("Shoot Murderer After Bomb Jump","Shoot Murderer After Bomb Jump (ODH)")
local bombJumpEnabled = savedToggle("Enable Auto Bomb Jump")
local autoGetBomb = savedToggle("Auto-Get Fake Bomb")
local cooldownUntil = 0
local cooldownToken = 0
local busy = false
local busyUntil = 0
local respawnedAt = -math.huge
local bigButtonSize = CONFIG.DefaultSize
local bindButtonSize = 0.11
local BOMB_NAMES = {"FakeBomb"}
local BombJumpMaid = Maid.new()
RootMaid:GiveTask(BombJumpMaid)
local Sounds = {
Click = Instance.new("Sound"),
Cooldown = Instance.new("Sound")
}
Sounds.Click.SoundId = "rbxassetid://6895079853"
ButtonAudio:Register(Sounds.Click,1.0)
Sounds.Cooldown.SoundId = "rbxassetid://138090596"
ButtonAudio:Register(Sounds.Cooldown,1.0)
RootMaid:GiveTasks(Sounds.Click,Sounds.Cooldown)
local function PlaySound(snd)
pcall(function()
if snd then
Services.SoundService:PlayLocalSound(snd)
end
end)
end
local function IsPlayerInAir()
local character = LocalPlayer.Character
if not character then return false end
local humanoid = character:FindFirstChild("Humanoid")
if not humanoid then return false end
local rootPart = character:FindFirstChild("HumanoidRootPart")
if not rootPart then return false end
local state = humanoid:GetState()
if state == Enum.HumanoidStateType.Jumping or
state == Enum.HumanoidStateType.FallingDown or
state == Enum.HumanoidStateType.Freefall then
return true
end
local velocityY = rootPart.Velocity.Y
return math.abs(velocityY) > 0.5
end
local function onCooldown()
return os.clock() < cooldownUntil
end
local function showBombJumpText(text, waiting)
local bigBtn = BBSystem.Buttons["VV2_BombJump_Big"]
if bigBtn then bigBtn.Text = text == "BJ" and "Bomb Jump" or text end
BindableButtons.UpdateBButtonText("VV2_BombJump_Bind", text, waiting, false)
end
local function ResetCooldown()
cooldownUntil = 0
cooldownToken = cooldownToken + 1
showBombJumpText("BJ", false)
end
local function StartCooldown(endsAt)
cooldownUntil = endsAt or os.clock() + CONFIG.CooldownTime
cooldownToken = cooldownToken + 1
local token = cooldownToken
showBombJumpText("Wait", true)
vv2Spawn(function()
while token == cooldownToken and alive and runtimeAlive do
local left = math.ceil(cooldownUntil - os.clock() - 0.05)
if left <= 0 then break end
showBombJumpText(tostring(left), true)
task.wait(math.clamp(cooldownUntil - os.clock() - (left - 1), 0.05, 1))
end
if token == cooldownToken then ResetCooldown() end
end)
end
local function GetCenterPosition()
local character = LocalPlayer.Character
if character and character:FindFirstChild("HumanoidRootPart") then
local camera = Services.Workspace.CurrentCamera
local lookDir = camera.CFrame.LookVector
return character.HumanoidRootPart.Position + (lookDir * 5)
end
return nil
end
local function MakeCharacterJump()
local character = LocalPlayer.Character
if character then
local humanoid = character:FindFirstChild("Humanoid")
if humanoid then
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end
end
local function UnequipBomb()
vv2Spawn(function()
local expectedCharacter=LocalPlayer.Character
task.wait(0.5)
if not alive or not runtimeAlive or LocalPlayer.Character~=expectedCharacter then return end
local character = LocalPlayer.Character
if character then
for _, bombName in ipairs(BOMB_NAMES) do
local bomb = character:FindFirstChild(bombName)
if bomb then
bomb.Parent = LocalPlayer:FindFirstChildOfClass("Backpack") or character
break
end
end
end
end)
end
local function GetAnyBomb()
local character = LocalPlayer.Character
if not character then return false, nil end
for _, bombName in ipairs(BOMB_NAMES) do
local bomb = character:FindFirstChild(bombName)
if bomb then return true, bomb end
end
local backpack = LocalPlayer:FindFirstChild("Backpack")
if backpack then
for _, bombName in ipairs(BOMB_NAMES) do
local bomb = backpack:FindFirstChild(bombName)
if bomb then
bomb.Parent = character
return true, bomb
end
end
end
pcall(function()
Services.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("FakeBomb")
end)
backpack = LocalPlayer:FindFirstChild("Backpack")
for _ = 1, 5 do
for _, bombName in ipairs(BOMB_NAMES) do
local bomb = character:FindFirstChild(bombName)
if bomb then return true, bomb end
if backpack then
bomb = backpack:FindFirstChild(bombName)
if bomb then
bomb.Parent = character
return true, bomb
end
end
end
task.wait(0.05)
end
return false, nil
end
local flingWarnedAt = nil
local function FastBombJump()
if not alive or not runtimeAlive then return end
-- (the Fake Bomb Bomb Fling is flinging with can't be thrown for a clutch at the same time)
local fling = runtime.BombFling
local busyFlinging = false
if fling and type(fling.IsBusy) == "function" then
local ok, busy = pcall(fling.IsBusy)
busyFlinging = ok and busy == true
elseif fling and type(fling.GetDiagnostics) == "function" then
local ok, diagnosis = pcall(fling.GetDiagnostics)
busyFlinging = ok and type(diagnosis) == "table" and (diagnosis.flinging == true or (tonumber(diagnosis.queue) or 0) > 0)
end
if busyFlinging then
if os.clock() - (flingWarnedAt or -math.huge) > 2 then
flingWarnedAt = os.clock()
pcall(function() shared.Notify("Bomb Jump: the bomb can't be used for clutches while it's being used to fling", 0) end)
end
return
end
if not IsPlayerInAir() then return end
if onCooldown() then return end
if busy or os.clock() < busyUntil then return end
if os.clock() - respawnedAt < 1 then return end
busy = true
busyUntil = os.clock() + 0.5
local actionCharacter=LocalPlayer.Character
local ok, err = pcall(function()
local success, bomb = GetAnyBomb()
if not alive or not runtimeAlive or LocalPlayer.Character~=actionCharacter then return end
if not (success and bomb) then
failure("couldn't get a Fake Bomb", true)
return
end
local position = GetCenterPosition()
if not position then failure("your character isn't loaded", false); return end
local remote = bomb:FindFirstChild("Remote")
if remote then
PlaySound(Sounds.Click)
pcall(function()
remote:FireServer(CFrame.new(position), 50)
end)
else
failure("the Fake Bomb has no Remote", true)
end
local char = LocalPlayer.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if root then
local currentVelocity = root.AssemblyLinearVelocity
root.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, CONFIG.LaunchPower, currentVelocity.Z)
end
MakeCharacterJump()
UnequipBomb()
lastJumpAt = os.clock()
pcall(function()
runtime.JumpGunFollowup.Queue("BombJump",actionCharacter,function()
if not alive then return false,false end
return equipGunAfterJump,shootAfterJump
end)
end)
vv2Spawn(function()
task.wait(0.1)
StartCooldown()
end)
end)
busy = false
if not ok then failure(tostring(err), true) end
end
-- (Bomb Jump Keybind: on the ground it jumps for you first, then does the bomb clutch once you're off the
-- ground, the way Firefly Clutch jumps for you; already in the air, it's the normal Bomb Jump)
local jumpClutching = false
-- (Bomb Jump Keybind: with your feet on the ground it jumps for you first and waits for the top of that
-- jump, then bomb jumps; already off the ground, it bomb jumps straight away. "On the ground" is where
-- your feet are, not how fast you're moving, so walking over bumps doesn't count as being in the air)
local function JumpThenBombJump()
if not alive or not runtimeAlive then return end
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local root = character and character:FindFirstChild("HumanoidRootPart")
if not humanoid or not root or humanoid.Health <= 0 or humanoid.Sit then return end
if humanoid.FloorMaterial == Enum.Material.Air then FastBombJump(); return end
if jumpClutching or onCooldown() or busy or os.clock() < busyUntil or os.clock() - respawnedAt < 1 then return end
jumpClutching = true
vv2Spawn(function()
pcall(function()
humanoid.Jump = true
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)
-- (up off the ground, then near the top of the jump: rising slower than 4 studs/s, or 0.7 s at most)
local started = os.clock()
local rose = false
while os.clock() - started < 0.7 and LocalPlayer.Character == character and humanoid.Health > 0 do
local rise = root.AssemblyLinearVelocity.Y
if rise > 8 then rose = true end
if rose and rise < 4 then break end
task.wait()
end
if LocalPlayer.Character == character and humanoid.Health > 0 and humanoid.FloorMaterial == Enum.Material.Air then
FastBombJump()
end
jumpClutching = false
end)
end
local function IsHoldingBomb()
local character = LocalPlayer.Character
if not character then return false end
for _, bombName in ipairs(BOMB_NAMES) do
if character:FindFirstChild(bombName) then
return true
end
end
return false
end
local activeTouches = {}
local TAP_MOVEMENT_THRESHOLD = 10
local TAP_TIME_THRESHOLD = 0.3
BombJumpMaid:GiveTasks(
Services.UserInputService.InputBegan:Connect(function(input, gp)
if gp then return end
if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
activeTouches[input] = {startPosition = input.Position, startTime = tick(), moved = false}
end
end),
Services.UserInputService.InputChanged:Connect(function(input)
local data = activeTouches[input]
if data and (input.Position - data.startPosition).Magnitude > TAP_MOVEMENT_THRESHOLD then
data.moved = true
end
end),
Services.UserInputService.InputEnded:Connect(function(input, gp)
if gp then activeTouches[input] = nil return end
local data = activeTouches[input]
if data and not data.moved and tick() - data.startTime <= TAP_TIME_THRESHOLD then
if bombJumpEnabled and not onCooldown() and not busy then
if IsHoldingBomb() and IsPlayerInAir() then
FastBombJump()
end
end
end
activeTouches[input] = nil
end),
LocalPlayer.CharacterAdded:Connect(function(character)
ResetCooldown()
activeTouches = {}
respawnedAt = os.clock()
task.wait(1.2)
if not alive or not runtimeAlive or LocalPlayer.Character~=character then return end
if autoGetBomb then
pcall(function() Services.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("FakeBomb") end)
end
end)
)
local function bindSize(size)
local camera = Services.Workspace.CurrentCamera
local screen = camera and camera.ViewportSize or Vector2.new(1920, 1080)
if screen.X <= 1 or screen.Y <= 1 then screen = Vector2.new(1920, 1080) end
return __UD2(size * (screen.Y / screen.X), 0, size, 0)
end
buttonSpecs["VV2_BombJump_Big"] = {kind = "big", text = "Bomb Jump", click = FastBombJump, gold = false,
wanted = savedToggle("Enable BJ Big Button"),
style = function(button)
button.Size = __UD2(0, bigButtonSize, 0, bigButtonSize * 0.375)
local left = math.ceil(cooldownUntil - os.clock() - 0.05)
button.Text = left > 0 and tostring(left) or "Bomb Jump"
end}
buttonSpecs["VV2_BombJump_Bind"] = {kind = "bind", text = "BJ", click = FastBombJump, gold = false,
wanted = savedToggle("Enable BJ Bind Button"),
style = function(button)
button.Size = bindSize(bindButtonSize)
local left = math.ceil(cooldownUntil - os.clock() - 0.05)
BindableButtons.UpdateBButtonText("VV2_BombJump_Bind", left > 0 and tostring(left) or "BJ", left > 0, false)
end}
local resetBindSize = math.clamp(tonumber(C("resetBindButtonSize", 11)) or 11, 5, 25) / 100
buttonSpecs["VV2_Reset_Bind"] = {kind = "bind", text = "R", gold = false,
click = function()
local reset = runtime.ResetCharacter
if reset and type(reset.Reset) == "function" then task.spawn(reset.Reset) end
end,
wanted = C("resetBindButtonVisible", false) == true,
style = function(button)
button.Size = bindSize(resetBindSize)
BindableButtons.UpdateBButtonText("VV2_Reset_Bind", "R", false, false)
end}
runtime.ResetBindButton = {
SetWanted = function(value) setButtonWanted("VV2_Reset_Bind", value) end,
SetSize = function(value)
resetBindSize = math.clamp(tonumber(value) or 11, 5, 25) / 100
styleButton("VV2_Reset_Bind")
end,
ResetPosition = function()
savedPositions["VV2_Reset_Bind"] = nil
savePositions(savedPositions)
local btn = BindableButtons.Buttons["VV2_Reset_Bind"]
if btn then placeAt(btn, __UD2(0.1, 0, 0.9, 0)) end
end,
}
section:AddLabel("Bomb Jump Options")
section:AddToggle("Enable Auto Bomb Jump", function(bool) bombJumpEnabled = bool end)
section:AddToggle("Equip Gun After Bomb Jump",function(value) equipGunAfterJump=value end)
section:AddToggle("Shoot Murderer After Bomb Jump",function(value) shootAfterJump=value end,"Shoot Murderer After Bomb Jump (ODH)")
pcall(runtime.JumpGunFollowup.Watch,"BombJump",function() return alive and shootAfterJump end)
-- (keyboard: your own ODH shoot key is pressed instead of ODH's mobile shoot button; also for Gold Bomb Jump)
do
local useOwnKey=savedToggle("Use My Shoot Key (Keyboard)")
local ownKey=C("w2BombJumpOwnShootKey",nil)
local function applyOwnKey()
pcall(runtime.JumpGunFollowup.SetOwnKey,"BombJump",useOwnKey and ownKey or nil)
end
section:AddToggle("Use My Shoot Key (Keyboard)",function(value) useOwnKey=value;applyOwnKey() end)
section:AddTextBox("My Shoot Key (type it, e.g. E)",function(text)
local name=runtime.KeyFromText(text)
if name==ownKey then return end
if tostring(text or ""):gsub("%s","")=="" then
ownKey=nil;SetCfg("w2BombJumpOwnShootKey",nil)
pcall(shared.Notify,"Bomb Jump: no shoot key, ODH's shoot button is used",3)
elseif name then
ownKey=name;SetCfg("w2BombJumpOwnShootKey",name)
pcall(shared.Notify,"Bomb Jump: your shoot key is "..name,2)
else
pcall(shared.Notify,"Bomb Jump: "..tostring(text).." isn't a key",0)
end
applyOwnKey()
end)
applyOwnKey()
end
section:AddToggle("Auto-Get Fake Bomb", function(bool)
autoGetBomb = bool
if bool then
task.spawn(function() pcall(function() Services.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("FakeBomb") end) end)
end
end)
section:AddToggle("Enable BJ Big Button", function(e)
setButtonWanted("VV2_BombJump_Big", e)
end)
section:AddToggle("Hide Button Text", function(e)
local buttonText = env.WorldV2Runtime.ButtonText
if buttonText then buttonText.SetHidden({"VV2_BombJump_Big"}, e) end
end, "Hide BJ Button Text")
section:AddSlider("BJ Big Button Size", 50, 300, CONFIG.DefaultSize, function(value)
bigButtonSize = value
styleButton("VV2_BombJump_Big")
end)
section:AddButton("Reset BJ Big Button Position", function()
savedPositions["VV2_BombJump_Big"] = nil
savePositions(savedPositions)
local btn = BBSystem.Buttons["VV2_BombJump_Big"]
if btn then
placeAt(btn, __UD2(0.5, 0, 0.5, 0))
end
shared.Notify("Bomb Jump Clutch: BJ big button moved back to its default spot", 2)
end)
section:AddToggle("Enable BJ Bind Button", function(e)
setButtonWanted("VV2_BombJump_Bind", e)
end)
section:AddSlider("BJ Bind Button Size", 5, 25, 11, function(value)
bindButtonSize = value / 100
styleButton("VV2_BombJump_Bind")
end)
section:AddButton("Reset BJ Bind Button Position", function()
savedPositions["VV2_BombJump_Bind"] = nil
savePositions(savedPositions)
local btn = BindableButtons.Buttons["VV2_BombJump_Bind"]
if btn then
placeAt(btn, __UD2(0.1, 0, 0.9, 0))
end
shared.Notify("Bomb Jump Clutch: BJ bind button moved back to its default spot", 2)
end)
local bombJumpKeybindOn = C(settingKey("Enable Bomb Jump Keybind"), true) == true
section:AddToggle("Enable Bomb Jump Keybind", function(value) bombJumpKeybindOn = value end, nil, true)
section:AddKeybind("Bomb Jump Keybind", "E", function() if bombJumpKeybindOn then JumpThenBombJump() end end)
resetHooks[#resetHooks+1]=function()
equipGunAfterJump=false; shootAfterJump=false; bombJumpEnabled=false; autoGetBomb=false
ResetCooldown()
end
vv2Features.SinceJump=function()
if busy then return 0 end
return lastJumpAt and os.clock()-lastJumpAt or math.huge
end
vv2Features.State=function()
return {cooldownLeft=math.max(0,cooldownUntil-os.clock())}
end
-- (Bomb Fling throws the same Fake Bomb, with the same 22 s wait: its throws count down on the BJ and
-- Bomb Jump buttons too, so they show when the bomb can be thrown again)
vv2Features.BombThrown=function(at)
local endsAt=(tonumber(at) or os.clock())+CONFIG.CooldownTime
if endsAt>cooldownUntil+0.05 and endsAt>os.clock() then StartCooldown(endsAt) end
end
if _game == "Murder Mystery Modded" then
local gbjSection = BombJump:AddSection("Gold Bomb Jump+", "MMV")
local equipGunAfterGoldJump=savedToggle("Equip Gun After Gold Bomb Jump")
local shootAfterGoldJump=savedToggle("Shoot Murderer After Gold Bomb Jump","Shoot Murderer After Gold Bomb Jump (ODH)")
gbjSection:AddToggle("Equip Gun After Gold Bomb Jump",function(value) equipGunAfterGoldJump=value end)
gbjSection:AddToggle("Shoot Murderer After Gold Bomb Jump",function(value) shootAfterGoldJump=value end,"Shoot Murderer After Gold Bomb Jump (ODH)")
pcall(runtime.JumpGunFollowup.Watch,"GoldBombJump",function() return alive and shootAfterGoldJump end)
local gbjCooldownUntil = 0
local gbjCooldownToken = 0
local goldBombJumpEnabled = savedToggle("Enable Auto Gold Bomb Jump")
local gbjBusy = false
local gbjBusyUntil = 0
local autoGetGoldBomb = savedToggle("Auto-Get Gold Bomb")
local gbjRespawnedAt = -math.huge
local gbjBigButtonSize = 200
local gbjBindButtonSize = 0.11
local GOLD_BOMB_NAME = "GoldBomb"
local GoldBombJumpMaid = Maid.new()
RootMaid:GiveTask(GoldBombJumpMaid)
local function gbjOnCooldown()
return os.clock() < gbjCooldownUntil
end
local function showGoldText(text, waiting)
local bigBtn = BBSystem.Buttons["VV2_GoldBombJump_Big"]
if bigBtn then bigBtn.Text = text == "GBJ" and "Gold Bomb Jump" or text end
BindableButtons.UpdateBButtonText("VV2_GoldBombJump_Bind", text, waiting, true)
end
local function GBJResetCooldown()
gbjCooldownUntil = 0
gbjCooldownToken = gbjCooldownToken + 1
showGoldText("GBJ", false)
end
local function GBJStartCooldown()
gbjCooldownUntil = os.clock() + 4
gbjCooldownToken = gbjCooldownToken + 1
local token = gbjCooldownToken
showGoldText("Wait", true)
vv2Spawn(function()
while token == gbjCooldownToken and alive and runtimeAlive do
local left = math.ceil(gbjCooldownUntil - os.clock() - 0.05)
if left <= 0 then break end
showGoldText(tostring(left), true)
task.wait(math.clamp(gbjCooldownUntil - os.clock() - (left - 1), 0.05, 1))
end
if token == gbjCooldownToken then GBJResetCooldown() end
end)
end
local function GBJGetCenterPosition()
local character = LocalPlayer.Character
if character and character:FindFirstChild("HumanoidRootPart") then
local camera = Services.Workspace.CurrentCamera
local lookDir = camera.CFrame.LookVector
return character.HumanoidRootPart.Position + (lookDir * 5)
end
return nil
end
local function GBJMakeCharacterJump()
local character = LocalPlayer.Character
if character then
local humanoid = character:FindFirstChild("Humanoid")
if humanoid then
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end
end
local function UnequipGoldBomb()
vv2Spawn(function()
local expectedCharacter=LocalPlayer.Character
task.wait(0.5)
if not alive or not runtimeAlive or LocalPlayer.Character~=expectedCharacter then return end
local character = LocalPlayer.Character
if character then
local bomb = character:FindFirstChild(GOLD_BOMB_NAME)
if bomb then
bomb.Parent = LocalPlayer:FindFirstChildOfClass("Backpack") or character
end
end
end)
end
local function GetAnyGoldBomb()
local character = LocalPlayer.Character
if not character then return false, nil end
local bomb = character:FindFirstChild(GOLD_BOMB_NAME)
if bomb then return true, bomb end
local backpack = LocalPlayer:FindFirstChild("Backpack")
if backpack then
bomb = backpack:FindFirstChild(GOLD_BOMB_NAME)
if bomb then
bomb.Parent = character
return true, bomb
end
end
local success = pcall(function()
Services.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("GoldBomb")
end)
if success then
backpack = LocalPlayer:FindFirstChild("Backpack")
for _ = 1, 5 do
bomb = character:FindFirstChild(GOLD_BOMB_NAME)
if bomb then return true, bomb end
if backpack then
bomb = backpack:FindFirstChild(GOLD_BOMB_NAME)
if bomb then
bomb.Parent = character
return true, bomb
end
end
task.wait(0.05)
end
end
return false, nil
end
local function FastGoldBombJump()
if not alive or not runtimeAlive then return end
local protection = runtime.FireflyProtection
if protection and type(protection.UsesGoldBomb) == "function" and protection.UsesGoldBomb() then
failure("it's off while Firefly Protection uses the Gold Bomb as a particle helper", true)
return
end
if not IsPlayerInAir() then return end
if gbjOnCooldown() then return end
if gbjBusy or os.clock() < gbjBusyUntil then return end
if os.clock() - gbjRespawnedAt < 1 then return end
gbjBusy = true
gbjBusyUntil = os.clock() + 0.5
local actionCharacter=LocalPlayer.Character
local ok, err = pcall(function()
local success, bomb = GetAnyGoldBomb()
if not alive or not runtimeAlive or LocalPlayer.Character~=actionCharacter then return end
if not (success and bomb) then
failure("couldn't get a Gold Bomb", true)
return
end
local position = GBJGetCenterPosition()
if not position then failure("your character isn't loaded", false); return end
local remote = bomb:FindFirstChild("Remote")
if remote then
PlaySound(Sounds.Click)
pcall(function()
remote:FireServer(CFrame.new(position), 50)
end)
else
failure("the Gold Bomb has no Remote", true)
end
local char = LocalPlayer.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if root then
local currentVelocity = root.AssemblyLinearVelocity
root.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, CONFIG.LaunchPower, currentVelocity.Z)
end
GBJMakeCharacterJump()
UnequipGoldBomb()
lastJumpAt = os.clock()
pcall(function()
runtime.JumpGunFollowup.Queue("GoldBombJump",actionCharacter,function()
if not alive then return false,false end
return equipGunAfterGoldJump,shootAfterGoldJump
end)
end)
vv2Spawn(function()
task.wait(0.1)
GBJStartCooldown()
end)
end)
gbjBusy = false
if not ok then failure(tostring(err), true) end
end
local function IsHoldingGoldBomb()
local character = LocalPlayer.Character
if not character then return false end
return character:FindFirstChild(GOLD_BOMB_NAME) ~= nil
end
local gbjActiveTouches = {}
GoldBombJumpMaid:GiveTasks(
Services.UserInputService.InputBegan:Connect(function(input, gp)
if gp then return end
if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
gbjActiveTouches[input] = {startPosition = input.Position, startTime = tick(), moved = false}
end
end),
Services.UserInputService.InputChanged:Connect(function(input)
local data = gbjActiveTouches[input]
if data and (input.Position - data.startPosition).Magnitude > TAP_MOVEMENT_THRESHOLD then
data.moved = true
end
end),
Services.UserInputService.InputEnded:Connect(function(input, gp)
if gp then gbjActiveTouches[input] = nil return end
local data = gbjActiveTouches[input]
if data and not data.moved and tick() - data.startTime <= TAP_TIME_THRESHOLD then
if goldBombJumpEnabled and not gbjOnCooldown() and not gbjBusy then
if IsHoldingGoldBomb() and IsPlayerInAir() then
FastGoldBombJump()
end
end
end
gbjActiveTouches[input] = nil
end),
LocalPlayer.CharacterAdded:Connect(function(character)
GBJResetCooldown()
gbjActiveTouches = {}
gbjRespawnedAt = os.clock()
task.wait(1.2)
if not alive or not runtimeAlive or LocalPlayer.Character~=character then return end
if autoGetGoldBomb then
pcall(function() Services.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("GoldBomb") end)
end
end)
)
buttonSpecs["VV2_GoldBombJump_Big"] = {kind = "big", text = "Gold Bomb Jump", click = FastGoldBombJump, gold = true,
wanted = savedToggle("Enable GBJ Big Button"),
style = function(button)
button.Size = __UD2(0, gbjBigButtonSize, 0, gbjBigButtonSize * 0.375)
local left = math.ceil(gbjCooldownUntil - os.clock() - 0.05)
button.Text = left > 0 and tostring(left) or "Gold Bomb Jump"
end}
buttonSpecs["VV2_GoldBombJump_Bind"] = {kind = "bind", text = "GBJ", click = FastGoldBombJump, gold = true,
wanted = savedToggle("Enable GBJ Bind Button"),
style = function(button)
button.Size = bindSize(gbjBindButtonSize)
local left = math.ceil(gbjCooldownUntil - os.clock() - 0.05)
BindableButtons.UpdateBButtonText("VV2_GoldBombJump_Bind", left > 0 and tostring(left) or "GBJ", left > 0, true)
end}
gbjSection:AddToggle("Enable Auto Gold Bomb Jump", function(bool) goldBombJumpEnabled = bool end)
gbjSection:AddToggle("Auto-Get Gold Bomb", function(bool)
autoGetGoldBomb = bool
if bool then
task.spawn(function() pcall(function() Services.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("GoldBomb") end) end)
end
end)
gbjSection:AddToggle("Enable GBJ Big Button", function(e)
setButtonWanted("VV2_GoldBombJump_Big", e)
end)
gbjSection:AddToggle("Hide GBJ Button Text", function(e)
local buttonText = env.WorldV2Runtime.ButtonText
if buttonText then buttonText.SetHidden({"VV2_GoldBombJump_Big", "VV2_GoldBombJump_Bind"}, e) end
end)
gbjSection:AddSlider("GBJ Big Button Size", 50, 300, 200, function(value)
gbjBigButtonSize = value
styleButton("VV2_GoldBombJump_Big")
end)
gbjSection:AddButton("Reset GBJ Big Button Position", function()
savedPositions["VV2_GoldBombJump_Big"] = nil
savePositions(savedPositions)
local btn = BBSystem.Buttons["VV2_GoldBombJump_Big"]
if btn then
placeAt(btn, __UD2(0.5, 0, 0.5, 0))
end
shared.Notify("Gold Bomb Jump+: GBJ big button moved back to its default spot", 2)
end)
gbjSection:AddToggle("Enable GBJ Bind Button", function(e)
setButtonWanted("VV2_GoldBombJump_Bind", e)
end)
gbjSection:AddSlider("GBJ Bind Button Size", 5, 25, 11, function(value)
gbjBindButtonSize = value / 100
styleButton("VV2_GoldBombJump_Bind")
end)
gbjSection:AddButton("Reset GBJ Bind Button Position", function()
savedPositions["VV2_GoldBombJump_Bind"] = nil
savePositions(savedPositions)
local btn = BindableButtons.Buttons["VV2_GoldBombJump_Bind"]
if btn then
placeAt(btn, __UD2(0.1, 0, 0.9, 0))
end
shared.Notify("Gold Bomb Jump+: GBJ bind button moved back to its default spot", 2)
end)
local goldBombJumpKeybindOn = C(settingKey("Enable Gold Bomb Jump Keybind"), true) == true
gbjSection:AddToggle("Enable Gold Bomb Jump Keybind", function(value) goldBombJumpKeybindOn = value end, nil, true)
gbjSection:AddKeybind("Gold Bomb Jump Keybind", "G", function() if goldBombJumpKeybindOn then FastGoldBombJump() end end)
resetHooks[#resetHooks+1]=function()
equipGunAfterGoldJump=false; shootAfterGoldJump=false; goldBombJumpEnabled=false; autoGetGoldBomb=false
GBJResetCooldown()
end
end
end
vv2Spawn(function()
for id in pairs(buttonSpecs) do pcall(ensureButton,id) end
while alive and runtimeAlive do
task.wait(1)
for id in pairs(buttonSpecs) do pcall(ensureButton,id) end
end
end)
vv2Features.Close=function()
if not alive then return end
alive=false
for record in pairs(pending) do
if record.thread and type(task.cancel)=="function" then pcall(task.cancel,record.thread) end
pending[record]=nil
end
for _,controller in ipairs(vv2Controls) do pcall(function() controller:Set(false) end) end
for id in pairs(buttonSpecs) do pcall(removeButton,id) end
for id in pairs(BBSystem.Buttons) do pcall(DeleteBigButton,id) end
for id in pairs(BindableButtons.Buttons) do pcall(BindableButtons.DeleteBButton,id) end
pcall(function() RootMaid:Destroy() end)
end
runtime.VV2BombJump=vv2Features
runtime.RegisterReset(function()
if runtimeAlive then
for _,controller in ipairs(vv2Controls) do pcall(function() controller:Set(false) end) end
for id,spec in pairs(buttonSpecs) do spec.wanted=false; pcall(removeButton,id) end
for _,hook in ipairs(resetHooks) do pcall(hook) end
table.clear(savedPositions)
return
end
vv2Features.Close()
end)
end,"Section \"Bomb Jump Clutch / Gold Bomb Jump+\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local runtime=env.WorldV2Runtime
local ReplicatedStorage=game:GetService("ReplicatedStorage")
if not inMurderMystery then return end
local section=mainTab:AddSection("Bomb Fling","Utilities")
local POWER=50000
local MIN_DURATION,MAX_DURATION=1,6
local settings={
duration=math.clamp(tonumber(C("bombFlingDuration",MIN_DURATION)) or MIN_DURATION,MIN_DURATION,MAX_DURATION),
auraDistance=math.clamp(tonumber(C("bombFlingAuraStuds",15)) or 15,5,50),
loopDelay=math.clamp(tonumber(C("bombFlingLoopDelay",3)) or 3,0,6),
hideInBody=C("bombHideInBody",false)==true,
}
local selectedPlayers={}
-- (Bomb Ragdoll: same bomb, much weaker push that only knocks people over; its own settings, players and
-- whitelist, and a fling always goes before a ragdoll)
local ragdollSettings={
loopDelay=math.clamp(tonumber(C("bombRagdollLoopDelay",3)) or 3,0,6),
auraDistance=math.clamp(tonumber(C("bombRagdollAuraStuds",15)) or 15,5,50),
}
local ragdollSelected={}
local loops={}
local alive=true
local stats={deploys=0,deployFailures=0,flings=0,hits=0,lastError=nil}
local function notify(text,kind) pcall(shared.Notify,text,kind or 3) end






local function receiveAge(part)
local ok,age=pcall(function() return part.ReceiveAge end)
return ok and tonumber(age) or -1
end
local function isWhitelisted(plr) return (env.WorldV2Runtime.Whitelist~=nil and env.WorldV2Runtime.Whitelist.Has(plr)) end
local ragdollSpared=isWhitelisted
local function rootOf(plr)
local character=plr and plr.Character
return character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("Head"))
end
local function aliveCharacter(plr)
local character=plr and plr.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
return humanoid and humanoid.Health>0 and character or nil
end
local roleData,roleFetchedAt,roleFetching=nil,-math.huge,false
local function refreshRoles()
if roleFetching or os.clock()-roleFetchedAt<3 then return end
roleFetching=true
task.spawn(function()
local ok,result=pcall(function()
local remote=ReplicatedStorage:FindFirstChild("GetPlayerData",true)
if remote and remote:IsA("RemoteFunction") then return remote:InvokeServer() end
end)
if ok and type(result)=="table" then roleData=result end
roleFetchedAt=os.clock();roleFetching=false
end)
end
local function hasTool(plr,word)
for _,container in ipairs({plr.Character,plr:FindFirstChildOfClass("Backpack")}) do
if container then
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and tool.Name:lower():find(word,1,true) then return true end
end
end
end
return false
end
local function byRole(roles,word)
local shared=runtime.Roles
if shared then
local ok,found=pcall(roles.Murderer and shared.Murderer or shared.Sheriff,isWhitelisted)
if ok and found and aliveCharacter(found) then return found end
end
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and not isWhitelisted(plr) and aliveCharacter(plr) and hasTool(plr,word) then return plr end
end
refreshRoles()
if type(roleData)=="table" then
for name,info in pairs(roleData) do
if type(info)=="table" and roles[info.Role] and not info.Killed and not info.Dead then
local plr=Players:FindFirstChild(tostring(name))
if plr and plr~=LocalPlayer and not isWhitelisted(plr) and aliveCharacter(plr) then return plr end
end
end
end
end
local function findMurderer() return byRole({Murderer=true},"knife") end
local function findSheriff() return byRole({Sheriff=true,Hero=true},"gun") end
local bombs={}
local ownBomb=nil
local lastDeploy={at=-math.huge,position=nil}
local function inCharacterOrTool(object)
local current=object.Parent
for _=1,8 do
if not current or current==workspace then return false end
if current:IsA("Tool") or current:IsA("Accessory") or current:FindFirstChildOfClass("Humanoid") then return true end
current=current.Parent
end
return false
end
local function bombLike(part)
if not part:IsA("BasePart") or part.Anchored then return false end
local name=part.Name:lower()
local parent=part.Parent
local parentName=parent and parent.Name:lower() or ""
if not (name:find("fakebomb",1,true) or parentName:find("fakebomb",1,true) or name=="bomb" or parentName=="bomb"
or name=="handle") then return false end
return not inCharacterOrTool(part)
end
local function fallLimit()
local ok,limit=pcall(function() return workspace.FallenPartsDestroyHeight end)
if not ok or type(limit)~="number" or limit~=limit or math.abs(limit)==math.huge then return nil end
return limit
end
local function unusableWhy(part)
if not part or not part.Parent then return "it was removed" end
if not part:IsDescendantOf(workspace) then return "it was moved out of the map" end
if part.Anchored then return "it's anchored" end
local ok,y=pcall(function() return part.Position.Y end)
if not ok or y~=y then return "its position can't be read" end
local limit=fallLimit()
if limit and y<=limit+2 then return ("it's at the map's fall limit (height %d, limit %d)"):format(math.floor(y),math.floor(limit)) end
return nil
end
local function usable(part)
return unusableWhy(part)==nil
end
local function owned(part)
local ok,age=pcall(function() return part.ReceiveAge end)
return not ok or age==0
end
local function consider(part)
if bombs[part] or not bombLike(part) then return end
bombs[part]=os.clock()
if lastDeploy.position and os.clock()-lastDeploy.at<2.5 and (not ownBomb or not usable(ownBomb)) then
local ok,distance=pcall(function() return (part.Position-lastDeploy.position).Magnitude end)
if ok and distance<45 then ownBomb=part end
end
end
local watch=workspace.DescendantAdded:Connect(function(object)
if alive and object:IsA("BasePart") then task.defer(consider,object) end
end)
local unwatch=workspace.DescendantRemoving:Connect(function(object)
if bombs[object] then bombs[object]=nil end
if object==ownBomb then
ownBomb=nil

end
end)
task.spawn(function()
local ok,list=pcall(workspace.GetDescendants,workspace)
if not ok then return end
local started=os.clock()
for index,object in ipairs(list) do
if not alive then return end
if object:IsA("BasePart") then consider(object) end
if index%300==0 and os.clock()-started>0.003 then task.wait();started=os.clock() end
end
end)
local recentParts={}
local recentWatch=workspace.DescendantAdded:Connect(function(object)
if alive and object:IsA("BasePart") then recentParts[object]=os.clock() end
end)
local function bombSignature(tool)
local signature={names={},size=nil}
local handle=tool and tool:FindFirstChild("Handle")
if handle and handle:IsA("BasePart") then
signature.size=handle.Size
for _,child in ipairs(handle:GetChildren()) do signature.names[child.Name]=true end
end
return signature
end
local function bombScore(part,signature)
local score=0
pcall(function()
local name=part.Name:lower()
local parentName=part.Parent and part.Parent~=workspace and part.Parent.Name:lower() or ""
if name:find("bomb",1,true) or parentName:find("bomb",1,true) then score=score+2 end
if name=="handle" then score=score+1 end
if signature and signature.size and (part.Size-signature.size).Magnitude<0.2 then score=score+3 end
local shared=0
for _,child in ipairs(part:GetChildren()) do
if signature and signature.names[child.Name] then shared=shared+1 end
end
if shared>=2 then score=score+3 end
if part:FindFirstChild("Fuse") or part:FindFirstChild("Beep") then score=score+2 end
if not part.Anchored then score=score+1 end
end)
return score
end
local function describePart(part,score)
local ok,text=pcall(function()
local size=part.Size
return ("%s %.1fx%.1fx%.1f%s (%d)"):format(part.Name,size.X,size.Y,size.Z,part.Anchored and " fixed" or "",score)
end)
return ok and text or "?"
end
local ThrownBomb={lastSeen=nil}
function ThrownBomb.Begin(tool,from)
local before={}
for _,child in ipairs(workspace:GetChildren()) do before[child]=true end
for part in pairs(recentParts) do if os.clock()-recentParts[part]>5 then recentParts[part]=nil end end
return {before=before,signature=bombSignature(tool),from=from,at=os.clock()}
end
function ThrownBomb.Find(watch,radius)
radius=radius or 35
local mine=rootOf(LocalPlayer)
local best,bestScore=nil,2
local seen={}
local function look(part)
if seen[part] or (watch.skip and watch.skip[part]) or not part.Parent or not part:IsDescendantOf(workspace) or inCharacterOrTool(part) then return end
seen[part]=true
local ok,position=pcall(function() return part.Position end)
if not ok then return end
local near=(watch.from and (position-watch.from).Magnitude<radius) or (mine and (position-mine.Position).Magnitude<radius)
if not near then return end
local score=bombScore(part,watch.signature)
watch.seen=watch.seen or {}
if score>=1 and #watch.seen<4 then watch.seen[#watch.seen+1]=describePart(part,score) end
if score>bestScore then best,bestScore=part,score end
end
for part,at in pairs(recentParts) do
if at>=watch.at-0.05 then look(part) end
end
for _,child in ipairs(workspace:GetChildren()) do
if not watch.before[child] then
if child:IsA("BasePart") then look(child)
elseif child:IsA("Model") or child:IsA("Folder") or child:IsA("Tool") then
for _,inner in ipairs(child:GetDescendants()) do if inner:IsA("BasePart") then look(inner) end end
end
end
end
ThrownBomb.lastSeen=watch.seen and table.concat(watch.seen,", ") or "nothing new near you"
return best
end
ThrownBomb.Score=bombScore
ThrownBomb.Signature=bombSignature
-- (the bombs Bomb Fling threw itself: the only ones it ever picks up, never another player's)
local ourBombs=setmetatable({}, {__mode="k"})
-- (bombs kept under you, with the collision they had, to give back when they're set down; and when
-- Bomb Fling was last used)
local parked=setmetatable({}, {__mode="k"})
local lastUse=-math.huge
local function nearestOwnedBomb(anyOwner,within,signature,since)
local root=rootOf(LocalPlayer)
if not root then return nil end
local best,bestDistance=nil,within or 60
for part,seen in pairs(bombs) do
if usable(part) and (anyOwner or owned(part)) and (not signature or bombScore(part,signature)>=3)
and (not since or seen>=since) then
local distance=(part.Position-root.Position).Magnitude
if distance<bestDistance then best,bestDistance=part,distance end
elseif not part.Parent then bombs[part]=nil end
end
return best
end
local function findBombTool()
for _,container in ipairs({LocalPlayer.Character,LocalPlayer:FindFirstChildOfClass("Backpack")}) do
if container then
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and tool.Name:lower():gsub("%s","")=="fakebomb" then return tool end
end
end
end
end
local function toyRemote()
local remotes=ReplicatedStorage:FindFirstChild("Remotes")
local extras=remotes and remotes:FindFirstChild("Extras")
local remote=extras and extras:FindFirstChild("ReplicateToy")
return remote and remote:IsA("RemoteFunction") and remote or nil
end
local THROW_COOLDOWN=22
local throwReadyAt=0
local function cooldownLeft()
local left=throwReadyAt-os.clock()
local bombJump=runtime.VV2BombJump
if bombJump and type(bombJump.State)=="function" then
local ok,state=pcall(bombJump.State)
if ok and type(state)=="table" and tonumber(state.cooldownLeft) then left=math.max(left,tonumber(state.cooldownLeft)) end
end
return math.max(0,left)
end
local deploying=false
local backoffUntil,failures=0,0
local function failDeploy(reason)
failures=failures+1
stats.deployFailures=stats.deployFailures+1
stats.lastError=reason
backoffUntil=os.clock()+math.min(8,0.75*2^(failures-1))

return nil,reason
end
local function nearestOther(position)
local nearest=math.huge
for _,plr in ipairs(Players:GetPlayers()) do
local root=plr~=LocalPlayer and rootOf(plr)
if root then nearest=math.min(nearest,(root.Position-position).Magnitude) end
end
return nearest
end
local THROW_REACH=22
local function throwWay(from)
local params=RaycastParams.new()
params.FilterType=Enum.RaycastFilterType.Exclude
local ignore={}
for _,plr in ipairs(Players:GetPlayers()) do
if plr.Character then ignore[#ignore+1]=plr.Character end
end
params.FilterDescendantsInstances=ignore
local best,bestScore=Vector3.new(0,0,-1),-math.huge
for step=0,7 do
local angle=step*math.pi/4
local way=Vector3.new(math.cos(angle),0,math.sin(angle))
local reach=THROW_REACH
local ok,hit=pcall(function() return workspace:Raycast(from,way*reach,params) end)
if ok and hit then reach=math.max(0,(hit.Position-from).Magnitude-1) end
local score=math.min(nearestOther(from+way*reach),200)-reach
if score>bestScore then best,bestScore=way,score end
end
return best
end
local function deployBomb()
if deploying then
local deadline=os.clock()+3
while deploying and os.clock()<deadline do task.wait(0.05) end
if ownBomb and usable(ownBomb) then return ownBomb end
return nil,stats.lastError or "the bomb is still being deployed"
end
if os.clock()<backoffUntil then return nil,stats.lastError or "waiting before trying again" end
local waitLeft=cooldownLeft()
if waitLeft>0.05 then
return nil,("the Fake Bomb can be thrown again in %d s, or now if you reset your character"):format(math.ceil(waitLeft))
end
local character=aliveCharacter(LocalPlayer)
local root=rootOf(LocalPlayer)
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if not character or not root or not humanoid then return nil,"you are not alive" end
deploying=true
local result,reason
local ok,err=pcall(function()
local tool=findBombTool()
if not tool then
local remote=toyRemote()
if remote then pcall(function() remote:InvokeServer("FakeBomb") end) end
local deadline=os.clock()+1.5
repeat task.wait(0.05);tool=findBombTool() until tool or os.clock()>deadline
end
if not tool then result,reason=failDeploy("you don't have the Fake Bomb toy");return end
local throw=tool:FindFirstChild("Remote")
if not (throw and throw:IsA("RemoteEvent")) then throw=tool:FindFirstChildWhichIsA("RemoteEvent",true) end
if not throw then result,reason=failDeploy("the Fake Bomb has no Remote");return end
local backpack=LocalPlayer:FindFirstChildOfClass("Backpack")
local held=character:FindFirstChildOfClass("Tool")
if held==tool then held=nil end
local way=throwWay(root.Position)
local position=root.Position+way*4-Vector3.new(0,3,0)
lastDeploy.at,lastDeploy.position=os.clock(),position
stats.deploys=stats.deploys+1

local thrownWatch=ThrownBomb.Begin(tool,position)
local facing=root.CFrame-root.CFrame.Position
local letGo=runtime.HoldRotation(humanoid)
pcall(function()
root.CFrame=CFrame.lookAt(root.Position,root.Position+way)
end)
pcall(function() tool.Parent=character end)
task.wait(0.1)
pcall(function() throw:FireServer(CFrame.lookAt(position,position+way),50) end)
local inHand=os.clock()+0.5
repeat task.wait(0.03) until (ownBomb and usable(ownBomb)) or os.clock()>inHand
pcall(function()
if root.Parent then root.CFrame=CFrame.new(root.Position)*facing end
end)
letGo()
pcall(function() if tool.Parent==character then tool.Parent=backpack or tool.Parent end end)
if held and held.Parent and held.Parent~=character then pcall(function() humanoid:EquipTool(held) end) end
local tools=runtime.AutoGetTools
if tools and type(tools.RequestOrder)=="function" then pcall(tools.RequestOrder) end
local deadline=os.clock()+3
local passedOver=nil
repeat
if not (ownBomb and usable(ownBomb)) then
local found=ThrownBomb.Find(thrownWatch)
if found and usable(found) then ownBomb=found;bombs[found]=bombs[found] or os.clock()
elseif found then passedOver=describePart(found,bombScore(found,thrownWatch.signature)).." was passed over: "..tostring(unusableWhy(found)) end
end
if ownBomb and usable(ownBomb) then break end
task.wait(0.05)
until os.clock()>deadline
if not (ownBomb and usable(ownBomb)) then
local found=nearestOwnedBomb(false,nil,nil,lastDeploy.at-0.05)
if found then ownBomb=found end
end
if not (ownBomb and usable(ownBomb)) then
stats.lastSeen=tostring(ThrownBomb.lastSeen)..(passedOver and ("; "..passedOver) or "")
result,reason=failDeploy("the throw put out no bomb (the Fake Bomb may still be on its 22 s cooldown)");return
end
throwReadyAt=lastDeploy.at+THROW_COOLDOWN
failures=0
ourBombs[ownBomb]=true
local bombJump=runtime.VV2BombJump
if bombJump and type(bombJump.BombThrown)=="function" then pcall(bombJump.BombThrown,lastDeploy.at) end

result=ownBomb
end)
deploying=false
if not ok then return failDeploy(tostring(err)) end
return result,reason
end
local function getBomb()
if ownBomb and ourBombs[ownBomb] and usable(ownBomb) then return ownBomb end
-- (one it threw before, still out and still yours, e.g. from before a respawn; otherwise a new throw)
local best,bestAt=nil,-math.huge
for part in pairs(ourBombs) do
local seen=bombs[part] or 0
if usable(part) and owned(part) and seen>bestAt then best,bestAt=part,seen end
end
if best then ownBomb=best;return best end
return deployBomb()
end
local flingQueue={}
local ragdollQueue={}
local flinging=false
local lastMissingNotice,lastMissingKey=-math.huge,nil
local TOUCH_DELAY=0.2
local TOUCH_REACH=4
local FAR_TOUCH=150
local setHidden=sethiddenproperty or env.sethiddenproperty
local reachAt=-math.huge
local function askForReach()
if type(setHidden)~="function" or os.clock()-reachAt<1 then return end
reachAt=os.clock()
pcall(setHidden,LocalPlayer,"SimulationRadius",1e9)
pcall(setHidden,LocalPlayer,"MaximumSimulationRadius",1e9)
end
local touchInterest=firetouchinterest or env.firetouchinterest
local function touch(a,b)
if type(touchInterest)~="function" or not (a and b) then return end
pcall(touchInterest,a,b,0)
pcall(touchInterest,a,b,1)
end
local function measure(track,position,now)
track[#track+1]={at=now,position=position}
while #track>2 and now-track[2].at>=0.25 do table.remove(track,1) end
local first=track[1]
return now-first.at>=0.05 and (position-first.position)/(now-first.at) or Vector3.zero
end
local PATH_TIME=1
local ARC_LIMIT=2.2
local MOTION_TIME=1.5
local motion={}
local born={}
local tracker=RunService.Heartbeat:Connect(function()
if not alive or not runtimeAlive then return end
local now=os.clock()
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer then
local root=rootOf(plr)
if root and (not born[plr] or born[plr].root~=root) then born[plr]={root=root,at=now} end
local list=motion[plr]
if root and root.Parent then
if not list or list.root~=root then list={root=root};motion[plr]=list end
local position,velocity=root.Position,root.AssemblyLinearVelocity
local rise=velocity.Y
if math.abs(rise)<1 then
for index=#list,1,-1 do
local entry=list[index]
if now-entry.at>=0.1 then rise=(position.Y-entry.position.Y)/(now-entry.at);break end
end
end
list[#list+1]={at=now,position=position,velocity=Vector3.new(velocity.X,0,velocity.Z),rise=rise}
while #list>1 and now-list[1].at>MOTION_TIME do table.remove(list,1) end
elseif list then
motion[plr]=nil
end
end
end
end)
local REST_MISSES=2
local REST_TIME=45
local stillMisses,restingUntil={},{}
local leaving=Players.PlayerRemoving:Connect(function(plr)
motion[plr]=nil;born[plr]=nil;stillMisses[plr]=nil;restingUntil[plr]=nil
end)
local function movedVelocity(history,now)
local last=history and history[#history]
if not last or now-last.at>0.1 then return Vector3.zero end
for index=#history-1,1,-1 do
local entry=history[index]
if last.at-entry.at>=0.15 then return (last.position-entry.position)/(last.at-entry.at) end
end
return Vector3.zero
end
local function flying(velocity)
return velocity.Y<-80
end
local HOP_RISE=20
local HOP_SWEEP=1
local HOP_RAISE=0.5
local function hopping(history,now)
local count,below=0,false
for _,entry in ipairs(history) do
if now-entry.at<=1.5 then
if entry.rise>=HOP_RISE then
if below then count=count+1 end
below=false
else
below=true
end
end
end
return count>=2
end
local function headingOf(velocity) return math.atan2(velocity.Z,velocity.X) end
local function wrapAngle(angle) return (angle+math.pi)%(2*math.pi)-math.pi end
local function turnBetween(path,from,to)
local net,first,last,previous=0,nil,nil,nil
for index=from,to do
local entry=path[index]
if entry.velocity.Magnitude>=2 then
if previous then net=net+wrapAngle(headingOf(entry.velocity)-headingOf(previous.velocity)) end
previous=entry
first=first or entry
last=entry
end
end
if not first or last.at-first.at<0.15 then return nil end
return net/(last.at-first.at)
end
local function steadyTurn(path,now)
local start=nil
for index=#path,1,-1 do
if now-path[index].at<=0.6 then start=index else break end
end
if not start or #path-start<8 or now-path[start].at<0.48 then return nil end
local middle=math.floor((start+#path)/2)
local early,late=turnBetween(path,start,middle),turnBetween(path,middle,#path)
if not early or not late or early*late<=0 then return nil end
local small,big=math.min(math.abs(early),math.abs(late)),math.max(math.abs(early),math.abs(late))
if big<0.5 or small<0.4*big then return nil end
return (early+late)/2
end
local function weaving(path,now)
local turns,run,previous={},0,nil
for _,entry in ipairs(path) do
if now-entry.at<=PATH_TIME and entry.velocity.Magnitude>=2 then
if previous then
local change=wrapAngle(headingOf(entry.velocity)-headingOf(previous.velocity))
if math.abs(change)>1e-4 then
if run==0 or (change>0)==(run>0) then
run=run+change
else
if math.abs(run)>=0.4 then turns[#turns+1]=run end
run=change
end
end
end
previous=entry
end
end
if math.abs(run)>=0.4 then turns[#turns+1]=run end
for index=2,#turns do
if (turns[index]>0)~=(turns[index-1]>0) then return true end
end
return false
end
local function middleAhead(path,now,current,lead)
local sumX,sumZ,count,first,last=0,0,0,nil,nil
for _,entry in ipairs(path) do
if now-entry.at<=0.8 then
sumX,sumZ,count=sumX+entry.position.X,sumZ+entry.position.Z,count+1
first=first or entry
last=entry
end
end
if count<3 or last.at-first.at<0.2 then return nil end
local span=last.at-first.at
local reach=lead+span/2
return Vector3.new(sumX/count+(last.position.X-first.position.X)/span*reach,current.Y,
sumZ/count+(last.position.Z-first.position.Z)/span*reach)
end
local function wayAhead(horizontal,turn,seconds)
local angle=turn*seconds
if math.abs(angle)<0.05 then return horizontal*seconds end
local heading=math.atan2(horizontal.Z,horizontal.X)+angle/2
local chord=2*horizontal.Magnitude/math.abs(turn)*math.sin(math.abs(angle)/2)
return Vector3.new(math.cos(heading),0,math.sin(heading))*chord
end
local function predictAhead(path,now,current,horizontal,lead)
local turn=steadyTurn(path,now)
if turn then
turn=math.clamp(turn,-ARC_LIMIT/lead,ARC_LIMIT/lead)
return current+wayAhead(horizontal,turn,lead),"turn",turn
end
local straight=current+horizontal*lead
if weaving(path,now) then
local middle=middleAhead(path,now,current,lead)
if middle then return (straight+middle)/2,"weave",0 end
end
return straight,"straight",0
end
local FLUNG_SPEED=140
local function flungNow(targetRoot,startY,measured)
return targetRoot.AssemblyLinearVelocity.Magnitude>FLUNG_SPEED or Vector3.new(measured.X,0,measured.Z).Magnitude>45
or measured.Magnitude>100 or math.abs(targetRoot.Position.Y-startY)>25
end
local function flatRotation(bomb)
local ok,size=pcall(function() return bomb.Size end)
if not ok or typeof(size)~="Vector3" then return CFrame.identity,1 end
if size.X<=size.Y and size.X<=size.Z then return CFrame.Angles(0,0,math.pi/2),size.X end
if size.Z<=size.X and size.Z<=size.Y then return CFrame.Angles(math.pi/2,0,0),size.Z end
return CFrame.identity,size.Y
end
local function bodySpan(character,targetRoot)
local top,bottom=nil,nil
for _,part in ipairs(character:GetChildren()) do
if part:IsA("BasePart") then
local ok,y,half=pcall(function() return part.Position.Y-targetRoot.Position.Y,part.Size.Y/2 end)
if ok then
top=math.max(top or -math.huge,y+half)
bottom=math.min(bottom or math.huge,y-half)
end
end
end
return top or 2.5,bottom or -3
end
local PASS_TIME=0.5
local LEAD_BASE=0.48
local MOVING_TIME=1.5
local HOP_TIME=8
local function pingSeconds()
local ok,value=pcall(function() return LocalPlayer:GetNetworkPing() end)
return ok and tonumber(value) or 0.1
end
local function baseLead() return LEAD_BASE+math.clamp(pingSeconds(),0,0.4)/2 end
local function floorBelow(position,ignore)
local params=RaycastParams.new()
params.FilterType=Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances=ignore
local ok,result=pcall(function() return workspace:Raycast(position+Vector3.new(0,2,0),Vector3.new(0,-60,0),params) end)
return ok and result and result.Position.Y or nil
end
local CARRY_DEPTH=5
-- (where the bomb is kept while it isn't flinging. Under the ground: CARRY_BELOW studs under whatever
-- you stand on (ground, a crate, a platform), at least CARRY_DEPTH under you. In your body: inside your
-- torso, its big flat side facing front and back, where it's seen least. It goes in your body while
-- you're in the air (a jump shows it), on a platform with room under it (people below would see it),
-- when other players are within NEAR studs (so you're always nearest it and it stays yours), or always
-- with Keep Bomb In Your Body on)
local carrySpot=(function()
local CARRY_BELOW,NEAR=4,14
local FLAT=CFrame.Angles(math.pi/2,0,0)
local ray=RaycastParams.new()
ray.FilterType=Enum.RaycastFilterType.Exclude
local cache={at=-math.huge,body=false,depth=CARRY_DEPTH}
local function decide(mine,bomb)
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if settings.hideInBody then return true end
local airborne=false
pcall(function() airborne=humanoid.FloorMaterial==Enum.Material.Air end)
if airborne then return true end
local floor=nil
pcall(function()
ray.FilterDescendantsInstances={character,bomb}
floor=workspace:Raycast(mine.Position,Vector3.new(0,-12,0),ray)
end)
if floor then
local under=nil
pcall(function() under=workspace:Raycast(floor.Position-Vector3.new(0,0.05,0),Vector3.new(0,-40,0),ray) end)
if under and floor.Position.Y-under.Position.Y>5 then return true end
cache.depth=math.max(CARRY_DEPTH,mine.Position.Y-floor.Position.Y+CARRY_BELOW)
else
cache.depth=CARRY_DEPTH
end
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer then
local root=rootOf(plr)
if root and (root.Position-mine.Position).Magnitude<NEAR then return true end
end
end
return false
end
return function(mine,bomb)
local now=os.clock()
if now-cache.at>0.2 then cache.at=now;cache.body=decide(mine,bomb) end
if cache.body then
local character=LocalPlayer.Character
local torso=character and (character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
-- (hidden from raycasts too: your character's floor and climb checks found it inside you and walked
-- or climbed on it, pushing you around)
if not bomb.CanCollide and bomb.CanQuery then bomb.CanQuery=false end
return (torso or mine).CFrame*FLAT
end
return mine.CFrame*CFrame.new(0,-cache.depth,0)
end
end)()
local verified=nil
local CARRY_CHECK=1.5
local carryTest,nextCarryTest,carryFails=nil,0,0
local function pushYours(bomb)
local ok,before=pcall(function() return bomb.CFrame end)
if not ok then return false end
local function rises(from)
pcall(function() bomb.AssemblyLinearVelocity=Vector3.new(0,30,0) end)
for _=1,3 do RunService.Heartbeat:Wait() end
if not usable(bomb) then return false end
return bomb.Position.Y-from.Position.Y>0.3 and receiveAge(bomb)<=0.03
end
local yours=rises(before)
local restore=before
local mine=rootOf(LocalPlayer)
if not yours and usable(bomb) and receiveAge(bomb)<=0.03 and mine then
local clear=mine.CFrame*CFrame.new(0,6,0)
pcall(function() bomb.CFrame=clear;bomb.AssemblyLinearVelocity=Vector3.zero end)
RunService.Heartbeat:Wait()
yours=rises(clear)
if yours then restore=clear end
end
pcall(function()
bomb.CFrame=restore
bomb.AssemblyLinearVelocity=Vector3.zero;bomb.AssemblyAngularVelocity=Vector3.zero
end)
return yours
end
local function watchYours(bomb,seconds)
local started,quiet=os.clock(),0
repeat
if not usable(bomb) then return false end
if receiveAge(bomb)>0.03 then quiet=0 else quiet=quiet+1 end
if quiet>=6 then
local ok,speed=pcall(function() return bomb.AssemblyLinearVelocity.Magnitude end)
if ok and speed>1 then return true end
return pushYours(bomb)
end
RunService.Heartbeat:Wait()
until os.clock()-started>seconds
return false
end
local function takeOutAnother()
if cooldownLeft()>0.05 then return nil end
local previous=ownBomb
ownBomb=nil
local fresh=deployBomb()
if not fresh then ownBomb=previous end
return fresh
end
-- (a ragdoll counts only when they're really down: their humanoid is in FallingDown, Ragdoll or Physics
-- (these states reach other players; a knocked-over humanoid lies flat in FallingDown for 3 s and can't
-- walk), or they lie flat (tipped past 70 degrees) for 0.4 s. Being pushed or tilted a bit isn't a ragdoll)
local knockedOver=(function()
local DOWN={FallingDown=true,Ragdoll=true,Physics=true}
return function(target,targetRoot)
local character=target.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local ok,state=pcall(function() return humanoid:GetState().Name end)
if ok and DOWN[state] then return "state" end
local flat,up=pcall(function() return targetRoot.CFrame.UpVector.Y end)
if flat and up<0.35 then return "flat" end
return nil
end
end)()
-- (ragdoll strength: 25, a flat spin of 7500 like the fling, a sideways tip of half that, and a push of
-- 625: back against the way they're moving, or away from you when they stand still. Tested on real
-- players' recorded movement: down in 0.42 s (median), where 17 pushing away from you took 1.1 s)
local RAGDOLL_STRENGTH=25
-- (a ragdoll keeps going until they're on the ground; after 7 s without that it stops and says it failed)
local RAGDOLL_TIMEOUT=7
local ragdollFailNoticeAt=setmetatable({}, {__mode="k"})
local RAGDOLL_SPEED=25
local RAGDOLL_SPIN=300
local function pushWay(targetRoot)
local moving=targetRoot.AssemblyLinearVelocity
moving=Vector3.new(moving.X,0,moving.Z)
if moving.Magnitude>2 then return -moving.Unit end
local mine=rootOf(LocalPlayer)
local offset=mine and (targetRoot.Position-mine.Position) or Vector3.zero
local flat=Vector3.new(offset.X,0,offset.Z)
if flat.Magnitude<0.5 then
local look=targetRoot.CFrame.LookVector
flat=Vector3.new(look.X,0,look.Z)
end
if flat.Magnitude<0.01 then return Vector3.new(1,0,0) end
return flat.Unit
end
-- (aiming at moving players. Several ways of placing the bomb are tried in turn, each for AIM_SLOT s:
-- "intentsweep" runs the bomb from them to 1.5x the lead ahead along where they're steering, "intent"
-- leads along where they're steering, "sweep" runs it along their velocity, "attach" ties the bomb to
-- their body like Reset Player does (its position is sent relative to their root), and "lead" is the
-- old prediction. Which way flings or ragdolls each player is remembered (per player, and per kind
-- overall, saved), and the best way goes first next time. Fling and Ragdoll are tracked the same way:
-- a fling counts most when it gets them out (dead or off the map within 5 s), a ragdoll only when
-- they're really down (see knockedOver).)
local aim=(function()
local SLOT=0.75
-- (order before anything is learned, from recorded movement of real players in public servers:
-- sweeping along where they're steering (their MoveDirection, which reaches other players) covered 84%
-- of moving moments, sweeping along their velocity 63%, a point on their MoveDirection 59%, the old
-- velocity x lead 36%)
local MODES={
{name="intentsweep",sweep=true,intent=true},
{name="intent",lead=1,intent=true},
{name="sweep",sweep=true},
{name="attach",lead=0,attach=true},
{name="lead",lead=1},
}
local byName={}
for index,mode in ipairs(MODES) do mode.index=index;byName[mode.name]=mode end
local SAVE_KEY="bombAimLearning"
local overall={fling={},ragdoll={}}
local totals={fling={tries=0,hits=0,movingTries=0,movingHits=0,time=0,movingTime=0,outs=0,outTime=0},
ragdoll={tries=0,hits=0,movingTries=0,movingHits=0,time=0,movingTime=0,outs=0,outTime=0}}
local perPlayer=setmetatable({},{__mode="k"})
local recent={}
-- (fling results for each way of placing the bomb on them, "head" or "sweep", see out.Place)
local placeStats={}
pcall(function()
local text=C(SAVE_KEY,"")
if type(text)~="string" then return end
for kind,name,hits,tries,outs in text:gmatch("(%a+)%.(%a+)=(%d+)/(%d+)/?(%d*)") do
if overall[kind] and byName[name] then
tries=tonumber(tries);hits=math.min(tonumber(hits),tries)
overall[kind][name]={hits=hits,tries=tries,outs=math.min(tonumber(outs) or 0,hits)}
end
end
end)
local function save()
local parts={}
for kind,list in pairs(overall) do
for name,entry in pairs(list) do parts[#parts+1]=("%s.%s=%d/%d/%d"):format(kind,name,entry.hits,entry.tries,entry.outs or 0) end
end
table.sort(parts)
pcall(SetCfg,SAVE_KEY,table.concat(parts,","))
end
local function entryOf(list,name)
local entry=list[name]
if not entry then entry={hits=0,tries=0,outs=0};list[name]=entry end
return entry
end
local function playerList(plr,kind)
local lists=perPlayer[plr]
if not lists then lists={fling={},ragdoll={}};perPlayer[plr]=lists end
return lists[kind]
end
-- (overall results count at most 20 tries' worth, so old results never freeze the order; this player's
-- own results count double. For a fling, getting them out is worth 1 and a fling that didn't 0.35)
local function worth(kind,entry)
if kind=="fling" then return (entry.outs or 0)+0.35*(entry.hits-(entry.outs or 0)) end
return entry.hits
end
local function score(kind,plr,mode)
local all=overall[kind][mode.name] or {hits=0,tries=0,outs=0}
local own=perPlayer[plr] and perPlayer[plr][kind][mode.name] or {hits=0,tries=0,outs=0}
local weight=math.min(all.tries,20)
local allWorth=all.tries>0 and worth(kind,all)/all.tries*weight or 0
return (worth(kind,own)*2+allWorth+1)/(own.tries*2+weight+2)
end
local function record(attempt,name,hit)
local all=entryOf(overall[attempt.kind],name)
local own=entryOf(playerList(attempt.target,attempt.kind),name)
all.tries,own.tries=all.tries+1,own.tries+1
if hit then all.hits,own.hits=all.hits+1,own.hits+1 end
-- (overall counts are halved past 200 tries so newer results matter more)
if all.tries>200 then all.tries=math.floor(all.tries/2);all.hits=math.floor(all.hits/2);all.outs=math.floor((all.outs or 0)/2) end
end
local function recordOut(attempt,name)
for _,list in ipairs({overall[attempt.kind],playerList(attempt.target,attempt.kind)}) do
local entry=entryOf(list,name)
entry.outs=math.min((entry.outs or 0)+1,entry.hits)
end
end
local api={SLOT=SLOT}
-- (after a fling lands, the bomb stays tied to them (like "attach") on top of their body for FOLLOW s,
-- pushing them on down, so they leave the map sooner)
api.FOLLOW=0
api.Follow={name="follow",lead=0,attach=true}
function api.Begin(target,ragdoll)
local kind=ragdoll and "ragdoll" or "fling"
local order={}
for _,mode in ipairs(MODES) do order[#order+1]=mode end
local scores={}
for _,mode in ipairs(order) do scores[mode]=score(kind,target,mode) end
table.sort(order,function(a,b)
if math.abs(scores[a]-scores[b])>1e-6 then return scores[a]>scores[b] end
return a.index<b.index
end)
local own=perPlayer[target] and perPlayer[target][kind][order[1].name]
return {target=target,kind=kind,order=order,slot=1,slotTime=0,last=nil,segments={},character=target.Character,
started=os.clock(),movingTime=0,attached=nil,known=own~=nil and own.hits>0}
end
-- (how long a moving player is given: one full round of every way, shorter once a way is known to work
-- on them)
function api.MovingTime(attempt)
return attempt.known and SLOT*3 or SLOT*#MODES
end
function api.Step(attempt,now,active)
local step=attempt.last and math.min(now-attempt.last,0.1) or 0
attempt.last=now
local mode=nil
if active then
attempt.movingTime=attempt.movingTime+step
attempt.slotTime=attempt.slotTime+step
if attempt.slotTime>=SLOT then
attempt.slotTime=0
attempt.slot=attempt.slot%#attempt.order+1
end
mode=attempt.order[attempt.slot]
end
local name=mode and mode.name or "still"
local segments=attempt.segments
if not segments[1] or segments[#segments].name~=name then segments[#segments+1]={name=name,at=now} end
return mode
end
-- (lead scale for a way: the sweep goes from 0 to 1.5 times the lead and back every 0.3 s)
function api.Lead(mode,now)
if mode.sweep then
local t=(now%0.3)/0.3
return 1.5*(t<0.5 and t*2 or 2-t*2)
end
return mode.lead
end
-- (where they're steering: their MoveDirection at their speed (at least 16), or nothing when they let
-- go of the controls)
function api.Intent(target,horizontal)
local humanoid=target.Character and target.Character:FindFirstChildOfClass("Humanoid")
local ok,steer=pcall(function() return humanoid.MoveDirection end)
if not ok or typeof(steer)~="Vector3" then return horizontal end
steer=Vector3.new(steer.X,0,steer.Z)
if steer.Magnitude<0.1 then return Vector3.zero end
return steer.Unit*math.max(horizontal.Magnitude,16)
end
function api.Attach(attempt,bomb,targetRoot)
if type(setHidden)~="function" then return end
attempt.attached=bomb
pcall(function() setHidden(bomb,"PhysicsRepRootRef",InstanceHandle.new(targetRoot)) end)
pcall(setHidden,bomb,"PhysicsRepRootPart",targetRoot)
end
function api.Detach(attempt)
local bomb=attempt.attached
if not bomb then return end
attempt.attached=nil
pcall(setHidden,bomb,"PhysicsRepRootRef",nil)
pcall(setHidden,bomb,"PhysicsRepRootPart",nil)
end
-- (results: the way that was in use a moment before the hit gets it, since a hit is seen here a little
-- after it happened; every other way that ran at least 0.3 s before that counts as a miss)
function api.Finish(attempt,hit,now,cancelled)
api.Detach(attempt)
if cancelled then return end
local ping=0.1
pcall(function() ping=tonumber(LocalPlayer:GetNetworkPing()) or 0.1 end)
local hitAt=now-math.clamp(ping*1.5+0.15,0.15,0.6)
local segments=attempt.segments
local credited=nil
for index,segment in ipairs(segments) do
local ends=segments[index+1] and segments[index+1].at or now
if segment.name~="still" then
if hit and not credited and (hitAt<ends or index==#segments) then
credited=segment.name
record(attempt,segment.name,true)
elseif ends-segment.at>=0.3 and (not hit or ends<=hitAt) then
record(attempt,segment.name,false)
end
end
if hit and credited then break end
end
if hit and not credited then credited="still" end
local total=totals[attempt.kind]
local took=now-attempt.started
local moving=attempt.movingTime>0.3
total.tries=total.tries+1
if moving then total.movingTries=total.movingTries+1 end
if hit then
total.hits=total.hits+1;total.time=total.time+took
if moving then total.movingHits=total.movingHits+1;total.movingTime=total.movingTime+took end
end
if attempt.place then
local place=placeStats[attempt.place] or {tries=0,hits=0,outs=0}
placeStats[attempt.place]=place
place.tries=place.tries+1
if hit then place.hits=place.hits+1 end
end
local entry={name=attempt.target.Name,kind=attempt.kind,hit=hit,took=took,way=credited or "-",moving=moving,place=attempt.place}
table.insert(recent,1,entry)
while #recent>15 do table.remove(recent) end
save()
-- (after a fling: are they out within 5 s? dead, respawned, or fallen far below where they were)
if hit and attempt.kind=="fling" then
local character=attempt.character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local root=character and character:FindFirstChild("HumanoidRootPart")
local fromY=root and root.Position.Y or 0
task.spawn(function()
local deadline=os.clock()+5
while os.clock()<deadline do
local out=attempt.target.Parent==nil or attempt.target.Character~=character or not (root and root.Parent)
or (humanoid~=nil and humanoid.Health<=0) or root.Position.Y<fromY-200
if out then
entry.out=true;entry.outTime=os.clock()-attempt.started
total.outs=total.outs+1;total.outTime=total.outTime+entry.outTime
if attempt.place and placeStats[attempt.place] then placeStats[attempt.place].outs=placeStats[attempt.place].outs+1 end
if credited and credited~="still" then recordOut(attempt,credited) end
save()
return
end
task.wait(0.1)
end
end)
end
end
function api.Summary()
local lines={}
for _,kind in ipairs({"fling","ragdoll"}) do
local total=totals[kind]
local ways={}
for _,mode in ipairs(MODES) do
local entry=overall[kind][mode.name]
if entry and entry.tries>0 then
ways[#ways+1]=kind=="fling" and ("%s %d/%d out %d"):format(mode.name,entry.hits,entry.tries,entry.outs or 0)
or ("%s %d/%d"):format(mode.name,entry.hits,entry.tries)
end
end
local outs=kind=="fling" and (", out %d (avg %.1f s to out)"):format(total.outs,total.outs>0 and total.outTime/total.outs or 0) or ""
lines[#lines+1]=("%s: %d/%d %s%s (moving %d/%d), avg %.1f s (moving %.1f s). Ways: %s"):format(
kind=="fling" and "Fling" or "Ragdoll",total.hits,total.tries,kind=="fling" and "flung" or "down",outs,
total.movingHits,total.movingTries,
total.hits>0 and total.time/total.hits or 0,total.movingHits>0 and total.movingTime/total.movingHits or 0,
#ways>0 and table.concat(ways,", ") or "none yet")
end
for _,name in ipairs({"head","sweep"}) do
local place=placeStats[name]
if place then lines[#lines+1]=("Placement %s: %d/%d flung, %d out of the map"):format(name,place.hits,place.tries,place.outs) end
end
return lines
end
function api.Recent() return recent end
function api.Data() return {overall=overall,totals=totals,recent=recent} end
function api.Clear()
overall.fling,overall.ragdoll={},{}
for key in pairs(perPlayer) do perPlayer[key]=nil end
table.clear(recent)
for _,total in pairs(totals) do for key in pairs(total) do total[key]=0 end end
save()
end
return api
end)()
-- (a fling counts only when it throws them down, on their way out of the map (falling faster than
-- DOWN_SPEED, or 25 studs below where they stood). Knocked around inside the map, or ragdolled, isn't a
-- fling: the bomb keeps at them, sat on top of them pushing down. After every fling they're watched: one
-- that wasn't thrown out (not touched, only knocked around, or thrown down but stuck in the map) is
-- flung again straight away and you're told why, up to MAX_AGAIN times in a row)
local out=(function()
-- (the bomb's push: straight down with no spin (a spinning bomb throws people sideways, across the
-- map, more often), swept through their body. Resting it on top of them (TOP_STILL/TOP_MOVING) worked on
-- a test account but not on real players in public servers: it sat on their heads and didn't move them)
local api={DOWN_SPEED=80,KNOCK_TIME=3,WATCH_TIME=5,MAX_AGAIN=3,SPIN=0,TOP_STILL=false,TOP_MOVING=false}
-- (the bomb is only yours while it's not far from you for too long: kept more than FAR studs from you
-- for a few seconds, the game gives it to a player near it. So after FAR_BUDGET s away it's brought back
-- under you for REST s, then the fling carries on. Tested 100 studs away: 2.5 s away / 0.6 s back lost
-- it on hard targets, 1.5 s / 1.5 s kept it)
api.FAR,api.FAR_BUDGET,api.REST=50,1.5,1.5
api.PIN={name="pin",lead=0}
local exposure,exposedAt,lastEnd=0,nil,-math.huge
function api.Expose(bomb,now)
local mine=rootOf(LocalPlayer)
local ok,far=pcall(function() return (bomb.Position-mine.Position).Magnitude>api.FAR end)
local step=exposedAt and math.min(now-exposedAt,0.1) or 0
exposedAt=now
if ok and far then exposure=exposure+step end
return exposure>=api.FAR_BUDGET
end
function api.Ended() exposedAt,lastEnd=nil,os.clock() end
function api.Rest(bomb)
exposedAt=nil
local idle=os.clock()-lastEnd
if idle>=api.REST then exposure=0;return end
if exposure<api.FAR_BUDGET then return end
while os.clock()-lastEnd<api.REST and alive and runtimeAlive and usable(bomb) do
local mine=rootOf(LocalPlayer)
if mine then pcall(function()
bomb.CFrame=carrySpot(mine,bomb)
bomb.AssemblyLinearVelocity=Vector3.zero;bomb.AssemblyAngularVelocity=Vector3.zero
end) end
RunService.Heartbeat:Wait()
end
exposure=0
end
local again=setmetatable({},{__mode="k"})
local stuckAt=setmetatable({},{__mode="k"})
-- (switching a Bomb Fling loop, auto, aura, bind button, keybind or click mode off calls Cancel: the fling
-- going on stops and nobody started before is flung again)
api.gen=0
function api.Cancel() api.gen=api.gen+1;table.clear(again) end
-- (where the bomb goes on them: "head", circling inside their head (tiny avatars included: the circle
-- shrinks with their head), or "sweep", from the top of their body to their feet and back. nil takes
-- turns, to compare them. Sweep is used: in a public server, 548 tries, sweep flung 86% and threw 71%
-- out of the map, head 83% and 65%)
api.PLACE="sweep"
local turn=false
function api.Place()
if api.PLACE then return api.PLACE end
turn=not turn
return turn and "head" or "sweep"
end
function api.Head(target,base,current,spin,fallback)
local head=target.Character and target.Character:FindFirstChild("Head")
if not (head and head:IsA("BasePart")) then return fallback end
local ok,offset,size=pcall(function() return head.Position.Y-current.Y,math.min(head.Size.X,head.Size.Z) end)
if not ok then return fallback end
local radius=math.min(0.5,size*0.4)
return base+Vector3.new(math.cos(spin)*radius,offset,math.sin(spin)*radius)
end
local told=setmetatable({},{__mode="k"})
function api.Down(targetRoot,startY,measured)
local ok,fall,y=pcall(function() return targetRoot.AssemblyLinearVelocity.Y,targetRoot.Position.Y end)
if not ok then return false end
return fall<-api.DOWN_SPEED or measured.Y<-api.DOWN_SPEED or y<startY-25
end
local function say(target,text)
if not text then return end
if os.clock()-(told[target] or -math.huge)<3 then return end
told[target]=os.clock()
notify(("Bomb Fling: %s %s"):format(target.DisplayName,text),0)
end
function api.Again(target,why)
if not target.Parent or not aliveCharacter(target) then again[target]=nil;return end
local entry=again[target]
if not entry or os.clock()-entry.at>20 then entry={count=0};again[target]=entry end
entry.at=os.clock()
-- (a loop keeps flinging them anyway, so it isn't counted toward giving up)
if next(loops)==nil then
if entry.count>=api.MAX_AGAIN then
again[target]=nil
say(target,why and why..", gave up after "..(entry.count+1).." tries")
return
end
entry.count=entry.count+1
end
say(target,why and why..", flinging again")
if api.Requeue then api.Requeue(target) end
return true
end
function api.Watch(target,info)
local gen=api.gen
task.spawn(function()
local started,stopped=os.clock(),0
while os.clock()-started<api.WATCH_TIME and alive and runtimeAlive do
if api.gen~=gen then return end
task.wait(0.1)
local root=rootOf(target)
if not root or not root.Parent or not aliveCharacter(target) then again[target]=nil;return end
local ok,y,fall=pcall(function() return root.Position.Y,root.AssemblyLinearVelocity.Y end)
if not ok then return end
if y<info.startY-200 then again[target]=nil;return end
if fall>-15 then stopped=stopped+1 else stopped=0 end
if stopped>=5 then break end
end
if os.clock()-started>=api.WATCH_TIME then again[target]=nil;return end
stuckAt[target]=os.clock()
api.Again(target,"was thrown down but got stuck in the map")
end)
end
-- (on some ground, like a thick map base with nothing under it, pushing straight down only bounces them
-- back up, and some players aren't moved at all by it. Someone who was thrown down but got stuck, or
-- who couldn't be touched, is for STUCK_TIME s pushed the old way instead: a spinning bomb, which
-- throws them sideways off it)
api.STUCK_TIME=20
function api.Sideways(target)
local at=target and stuckAt[target]
return at~=nil and os.clock()-at<api.STUCK_TIME
end
function api.Spin(target)
if api.Sideways(target) then return 1 end
return api.SPIN
end
function api.Top(moving,target)
if api.Sideways(target) then return false end
if moving then return api.TOP_MOVING end
return api.TOP_STILL
end
function api.Missed(target,info)
if info.cancelled then return false end
if info.tired then return api.Again(target,nil) end
-- (not even touched: the next tries on them use the spinning push too)
if not info.knocked then stuckAt[target]=os.clock() end
return api.Again(target,info.knocked and "was only knocked around in the map, not thrown out" or "couldn't be touched")
end
return api
end)()
local function runFling(target,ragdoll)
local targetRoot=rootOf(target)
if not targetRoot or not aliveCharacter(target) then return false,"no target" end
if not rootOf(LocalPlayer) then return false,"you are not alive" end
askForReach()

do
local away=(targetRoot.Position-rootOf(LocalPlayer).Position).Magnitude
local velocity,seen=targetRoot.AssemblyLinearVelocity,movedVelocity(motion[target],os.clock())
if flying(velocity) or flying(seen) then

return false,"already flung"
end
end
local bomb,reason=getBomb()
if bomb and bomb==verified and not pushYours(bomb) then

verified=nil
end
if bomb and bomb~=verified then
local yours=watchYours(bomb,os.clock()-lastDeploy.at<3 and 1.2 or 0.4)

if yours then
verified=bomb
else
local another=takeOutAnother()
local anotherYours=another~=nil and watchYours(another,1.2)

if anotherYours then
bomb,verified=another,another
else
bomb=nil
local wait=cooldownLeft()
reason="the bomb was given to another player (it's nearer them)"
..(wait>0.05 and (", a new one can be taken out in %d s, or now if you reset your character"):format(math.ceil(wait)) or "")
end
end
end
if not bomb then
local key=tostring(reason):gsub("%d+ s",""):gsub("[,.].*$","")
if key~=lastMissingKey or os.clock()-lastMissingNotice>30 then
lastMissingKey,lastMissingNotice=key,os.clock()
notify((ragdoll and "Bomb Ragdoll: " or "Bomb Fling: ")..tostring(reason),0)
end

return false,reason
end
out.Rest(bomb)
stats.flings=stats.flings+1
lastMissingKey=nil
local previousLimit=nil
pcall(function() previousLimit=workspace.FallenPartsDestroyHeight;workspace.FallenPartsDestroyHeight=0/0 end)
local started=os.clock()
local mineNow=rootOf(LocalPlayer)
local far=mineNow~=nil and (targetRoot.Position-mineNow.Position).Magnitude>FAR_TOUCH
-- (a ragdoll touches them straight away, so it happens as fast as it can)
local touchFrom=(far or ragdoll) and started or started+TOUCH_DELAY
askForReach()

local startY=targetRoot.Position.Y
local hit=false
local rotation,thickness=flatRotation(bomb)
local top,bottom=bodySpan(target.Character,targetRoot)
local passStarted=os.clock()
local spin=math.random()*math.pi*2
local track={}
local limit=ragdoll and RAGDOLL_TIMEOUT or settings.duration
local preempted=false
local push=ragdoll and pushWay(targetRoot) or nil
local attempt=aim.Begin(target,ragdoll)
local gen=out.gen
if not ragdoll then attempt.place=out.Place() end

local stillFrames,frames=0,0
local downSince=nil
local followUntil=nil
local knocked=false
local pinned=false
local tired=false
local ok,err=pcall(function()
while os.clock()-started<limit and alive and runtimeAlive do
-- (a fling asked for while ragdolling goes first: ragdolling is cancelled)
if ragdoll and #flingQueue>0 then preempted=true;break end
if out.gen~=gen then preempted=true;break end
askForReach()
if not usable(bomb) then

aim.Detach(attempt)
local another=takeOutAnother()
if not (another and watchYours(another,1.2)) then break end
bomb,verified=another,another
rotation,thickness=flatRotation(bomb)
touchFrom=(far or ragdoll) and os.clock() or os.clock()+TOUCH_DELAY
limit=math.max(limit,os.clock()-started+MOVING_TIME)
end
if not targetRoot.Parent or not aliveCharacter(target) then break end
RunService.Heartbeat:Wait()
if targetRoot.Parent and usable(bomb) then
local now=os.clock()
if out.Expose(bomb,now) then tired=true;break end
local current=targetRoot.Position
local measured=measure(track,current,now)
local down=knockedOver(target,targetRoot)
if down and ragdoll then downSince=downSince or now else downSince=nil end
pinned=not ragdoll and (down~=nil or Vector3.new(measured.X,0,measured.Z).Magnitude>45)
if not ragdoll and not knocked and (pinned or flungNow(targetRoot,startY,measured)) then
knocked=true;limit=math.max(limit,now-started+out.KNOCK_TIME)
end
if followUntil==nil and ((not ragdoll and out.Down(targetRoot,startY,measured))
or (downSince~=nil and now-downSince>=(down=="state" and 0.1 or 0.4))) then
hit=true
if ragdoll or aim.FOLLOW<=0 then break end
followUntil=now+aim.FOLLOW
end
if followUntil and now>=followUntil then break end
local progress=(now-passStarted)/PASS_TIME
if progress>=1 then
passStarted=now;progress=0
if target.Character then top,bottom=bodySpan(target.Character,targetRoot) end
end
local velocity=targetRoot.AssemblyLinearVelocity
local horizontal=Vector3.new(velocity.X,0,velocity.Z)
local measuredHorizontal=Vector3.new(measured.X,0,measured.Z)
if horizontal.Magnitude<1 and measuredHorizontal.Magnitude>3 then horizontal=measuredHorizontal end
if horizontal.Magnitude>80 then horizontal=horizontal.Unit*80 end
local verticalSpeed=velocity.Y
if math.abs(verticalSpeed)<1 and math.abs(measured.Y)>3 then verticalSpeed=measured.Y end
local moving=horizontal.Magnitude>2
if moving then limit=math.max(limit,MOVING_TIME,aim.MovingTime(attempt)) end
frames=frames+1
if not moving then stillFrames=stillFrames+1 end
local history=motion[target] or {}
local hop=hopping(history,now)
if hop and not ragdoll then limit=math.max(limit,HOP_TIME) end
local lead=baseLead()
local way=followUntil and aim.Follow or pinned and out.PIN or aim.Step(attempt,now,moving or hop)
if way then
lead=lead*aim.Lead(way,now)
if way.intent then horizontal=aim.Intent(target,horizontal) end
if way.attach then aim.Attach(attempt,bomb,targetRoot) else aim.Detach(attempt) end
end
local predicted,how,turn=current,"still",0
if lead<=0.01 then
how="attach"
elseif way and way.intent then
predicted,how=current+horizontal*lead,"intent"
elseif moving and hop then
predicted,how=current+horizontal*lead,"straight"
elseif moving then
predicted,how,turn=predictAhead(history,now,current,horizontal,lead)
end
local ignore={bomb}
if target.Character then ignore[#ignore+1]=target.Character end
if LocalPlayer.Character then ignore[#ignore+1]=LocalPlayer.Character end
if not hop and lead>0.01 and math.abs(verticalSpeed)>2 then
local rise=math.clamp(verticalSpeed*lead-0.5*workspace.Gravity*lead*lead,-25,25)
local lowest=nil
local floorY=floorBelow(predicted,ignore)
if floorY then lowest=floorY-bottom end
predicted=predicted+Vector3.new(0,rise,0)
if lowest and predicted.Y<lowest then predicted=Vector3.new(predicted.X,lowest,predicted.Z) end
end
-- (never more than 40 studs ahead: a teleport (e.g. round start) looks like a huge speed and would
-- send the bomb far away, where it's lost)
if (predicted-current).Magnitude>40 then predicted=current+(predicted-current).Unit*40 end
spin=spin+0.9
local around=hop and Vector3.zero or Vector3.new(math.cos(spin)*0.5,0,math.sin(spin)*0.5)
local height=hop and HOP_RAISE+HOP_SWEEP*(1-2*progress) or (top+thickness/2)+((bottom+thickness/2)-(top+thickness/2))*progress
local position=predicted+around+Vector3.new(0,height,0)
if not ragdoll and not hop and out.Top(moving,target) then position=predicted+around+Vector3.new(0,top+thickness/2,0) end
if followUntil then position=current+Vector3.new(0,top+thickness/2,0) end
if pinned and not followUntil then position=current+around+Vector3.new(0,height,0) end
if attempt.place=="head" then position=out.Head(target,pinned and current or predicted,current,spin,position) end
if ragdoll then
-- (ragdoll: the bomb goes exactly where Bomb Fling puts it, aim, prediction and all, but with far
-- gentler forces: the fling's flat spin, a sideways tip and a push, at strength 25)
local speed=RAGDOLL_SPEED*RAGDOLL_STRENGTH
local whirl=RAGDOLL_SPIN*RAGDOLL_STRENGTH
pcall(function()
bomb.CFrame=CFrame.new(position)*rotation
bomb.AssemblyLinearVelocity=push*speed
bomb.AssemblyAngularVelocity=Vector3.new(0,whirl,0)+Vector3.new(push.Z,0,-push.X)*(whirl*0.5)
end)
else
pcall(function()
bomb.CFrame=CFrame.new(position)*rotation
bomb.AssemblyLinearVelocity=Vector3.new(0,-POWER,0)
bomb.AssemblyAngularVelocity=Vector3.new(0,POWER*out.Spin(target),0)
end)
end
local head=target.Character and target.Character:FindFirstChild("Head")
if now>=touchFrom and (position-current).Magnitude<=TOUCH_REACH then
for _=1,5 do
touch(bomb,targetRoot)
if head then touch(bomb,head) end
end
end

end
end
end)
local endedAt=os.clock()
out.Ended()
aim.Finish(attempt,hit,endedAt,preempted or not ok or tired)
if ragdoll and not hit and not preempted and ok and aliveCharacter(target) and endedAt-started>=limit-0.1
and os.clock()-(ragdollFailNoticeAt[target] or -math.huge)>10 then
ragdollFailNoticeAt[target]=os.clock()
notify(("Bomb Ragdoll: couldn't ragdoll %s in %d s"):format(target.DisplayName,RAGDOLL_TIMEOUT),0)
end

if not ragdoll and not hit and ok and endedAt-started>=limit-0.1 and frames>0 and stillFrames>=frames*0.6 then
stillMisses[target]=(stillMisses[target] or 0)+1
if stillMisses[target]>=REST_MISSES then
stillMisses[target]=nil
restingUntil[target]=os.clock()+REST_TIME

end
else
stillMisses[target]=nil
end

if bomb and usable(bomb) then pcall(function()
local mine=rootOf(LocalPlayer)
if mine then
if parked[bomb]==nil then parked[bomb]=bomb.CanCollide end
if bomb.CanCollide then bomb.CanCollide=false end
bomb.CFrame=carrySpot(mine,bomb)
end
bomb.AssemblyLinearVelocity=Vector3.zero;bomb.AssemblyAngularVelocity=Vector3.zero
end) end
carryTest,nextCarryTest=nil,os.clock()+0.5
if previousLimit~=nil then
pcall(function()
local current=workspace.FallenPartsDestroyHeight
if current~=current then workspace.FallenPartsDestroyHeight=previousLimit end
end)
end
if not ok then stats.lastError=tostring(err) end
if hit then stats.hits=stats.hits+1 end
return hit,preempted,{knocked=knocked,startY=startY,tired=tired,cancelled=out.gen~=gen}
end
-- (the bomb is kept under you only while Bomb Fling is in use: a fling, a loop, the aura or an auto
-- fling, or 20 s after your last fling; then it's set back down beside you. During a Bomb Jump or Gold
-- Bomb Jump, and for 4 s after, it isn't touched at all, and it's only kept again after your next fling)
local PARK_TIME,JUMP_TIME=20,4
local function parkWanted()
if flinging or #flingQueue>0 or #ragdollQueue>0 or next(loops)~=nil then return true end
return os.clock()-lastUse<PARK_TIME
end
local function jumpedRecently()
local bombJump=runtime.VV2BombJump
if not bombJump or type(bombJump.SinceJump)~="function" then return false end
local ok,since=pcall(bombJump.SinceJump)
return ok and tonumber(since)~=nil and tonumber(since)<JUMP_TIME
end
local function setDown(bomb)
local original=parked[bomb]
parked[bomb]=nil
if original==nil or not usable(bomb) then return end
local mine=rootOf(LocalPlayer)
pcall(function()
if mine then
local params=RaycastParams.new()
params.FilterType=Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances={LocalPlayer.Character,bomb}
local spot=mine.Position+mine.CFrame.RightVector*3
local hit=workspace:Raycast(spot+Vector3.new(0,3,0),Vector3.new(0,-60,0),params)
local y=hit and hit.Position.Y+bomb.Size.Y/2+0.1 or mine.Position.Y
bomb.CFrame=CFrame.new(spot.X,y,spot.Z)
end
bomb.CanCollide=original
bomb.CanQuery=true
bomb.AssemblyLinearVelocity=Vector3.zero
bomb.AssemblyAngularVelocity=Vector3.zero
end)
end
local carry=RunService.Heartbeat:Connect(function()
local bomb=verified
if flinging or not alive or not runtimeAlive or not bomb or bomb~=ownBomb then carryTest=nil;return end
if not usable(bomb) then verified,carryTest=nil,nil;return end
if jumpedRecently() then
-- (its collision is given back where it is, so the bomb the jump threw doesn't fall through the floor)
-- (one still kept under you, in the ground or in your body, is set down beside you first)
local mine=rootOf(LocalPlayer)
local ok,below=pcall(function() return mine and mine.Position.Y-bomb.Position.Y end)
if ok and below and parked[bomb]~=nil then
setDown(bomb)
else
local original=parked[bomb]
parked[bomb]=nil
if original~=nil then pcall(function() bomb.CanCollide=original;bomb.CanQuery=true end) end
end
verified,carryTest,lastUse=nil,nil,-math.huge
return
end
if not parkWanted() then carryTest=nil;setDown(bomb);return end
local protection=runtime.FireflyProtection
if protection and type(protection.CurrentBomb)=="function" then
local ok,held=pcall(protection.CurrentBomb)
if ok and held==bomb then carryTest=nil;return end
end
local mine=rootOf(LocalPlayer)
if not mine then return end
local now=os.clock()
if carryTest then
carryTest.frames=carryTest.frames+1
if carryTest.frames<3 then return end
local ok,rose=pcall(function() return bomb.Position.Y-carryTest.from.Y end)
carryTest=nil
if ok and rose>0.3 and receiveAge(bomb)<=0.03 then
carryFails=0
else
carryFails=carryFails+1

if carryFails>=2 then
verified,carryFails=nil,0
pcall(function() bomb.AssemblyLinearVelocity=Vector3.zero end)

return
end
end
elseif now>=nextCarryTest then
nextCarryTest=now+CARRY_CHECK
local ok,from=pcall(function() return bomb.Position end)
if ok then
carryTest={from=from,frames=0}
pcall(function() bomb.AssemblyLinearVelocity=Vector3.new(0,30,0) end)
return
end
end
pcall(function()
if parked[bomb]==nil then parked[bomb]=bomb.CanCollide end
if bomb.CanCollide then bomb.CanCollide=false end
bomb.CFrame=carrySpot(mine,bomb)
bomb.AssemblyLinearVelocity=Vector3.zero
bomb.AssemblyAngularVelocity=Vector3.zero
end)
end)
local everyone=env.WorldV2Runtime.EveryoneNotices("Bomb Fling","fling","flung")
local everyoneRagdoll=env.WorldV2Runtime.EveryoneNotices("Bomb Ragdoll","ragdoll","ragdolled")
local passOf,ragdollPassOf={},{}
local function pump()
if flinging then return end
flinging=true
task.spawn(function()
while (#flingQueue>0 or #ragdollQueue>0) and alive and runtimeAlive do
if #flingQueue==0 then
local target=table.remove(ragdollQueue,1)
local hit=false
if target and target.Parent and target~=LocalPlayer and not ragdollSpared(target) then
local wasInRound=everyoneRagdoll.InRound(target)
local ok,result,preempted=pcall(runFling,target,true)
if not ok then stats.lastError=tostring(result) end
hit=ok and result==true
if hit then everyoneRagdoll.Flung(target,ragdollSpared,wasInRound) end
-- (a fling asked for mid-ragdoll cancels ragdolling completely: this one and any waiting are dropped,
-- not picked up again after)
if ok and preempted and not hit then
local dropped={target}
for _,queued in ipairs(ragdollQueue) do dropped[#dropped+1]=queued end
table.clear(ragdollQueue)
for _,plr in ipairs(dropped) do
local waiting=ragdollPassOf[plr]
ragdollPassOf[plr]=nil
for _,report in ipairs(waiting or {}) do pcall(report,false,true) end
end
target=nil
end
end
local waiting=target and ragdollPassOf[target]
if waiting then
ragdollPassOf[target]=nil
for _,report in ipairs(waiting) do pcall(report,hit) end
end
else
local first=1
for index,queued in ipairs(flingQueue) do
if knockedOver(queued,rootOf(queued)) then first=index;break end
end
local target=table.remove(flingQueue,first)
local hit=false
local again=false
if target and target.Parent and target~=LocalPlayer and not isWhitelisted(target) then
local wasInRound=everyone.InRound(target)
local ok,result,_,info=pcall(runFling,target)
if not ok then stats.lastError=tostring(result) end
hit=ok and result==true
if hit then everyone.Flung(target,isWhitelisted,wasInRound) end
if ok and type(info)=="table" then
if hit then out.Watch(target,info) else again=out.Missed(target,info)==true end
end
end
local waiting=target and not again and passOf[target]
if waiting then
passOf[target]=nil
for _,report in ipairs(waiting) do pcall(report,hit) end
end
end
end
flinging=false
end)
end
out.Requeue=function(target)
for _,queued in ipairs(flingQueue) do if queued==target then return end end
table.insert(flingQueue,1,target)
pump()
end
local function fling(target)
if not target or target==LocalPlayer or isWhitelisted(target) then return false end
lastUse=os.clock()
for _,queued in ipairs(flingQueue) do if queued==target then return true end end
if #flingQueue>=12 then return false end
flingQueue[#flingQueue+1]=target
pump()
return true
end
local function ragdoll(target)
if not target or target==LocalPlayer or ragdollSpared(target) then return false end
lastUse=os.clock()
for _,queued in ipairs(ragdollQueue) do if queued==target then return true end end
for _,queued in ipairs(flingQueue) do if queued==target then return true end end
if #ragdollQueue>=12 then return false end
ragdollQueue[#ragdollQueue+1]=target
pump()
return true
end
local function ragdollAll(list,pass)
if not pass then
for _,plr in ipairs(list) do ragdoll(plr) end
return
end
local pending=#list
if pending==0 then pass.Close();return end
local function report(hit)
pass.Result(hit)
pending=pending-1
if pending==0 then pass.Close() end
end
for _,plr in ipairs(list) do
local waiting=ragdollPassOf[plr] or {}
ragdollPassOf[plr]=waiting
waiting[#waiting+1]=report
if not ragdoll(plr) then
for index=#waiting,1,-1 do if waiting[index]==report then table.remove(waiting,index);break end end
if #waiting==0 then ragdollPassOf[plr]=nil end
report(false)
end
end
end
local function flingAll(list,pass)
if not pass then
for _,plr in ipairs(list) do fling(plr) end
return
end
local pending=#list
if pending==0 then pass.Close();return end
local function report(hit)
pass.Result(hit)
pending=pending-1
if pending==0 then pass.Close() end
end
for _,plr in ipairs(list) do
local waiting=passOf[plr] or {}
passOf[plr]=waiting
waiting[#waiting+1]=report
if not fling(plr) then
for index=#waiting,1,-1 do if waiting[index]==report then table.remove(waiting,index);break end end
if #waiting==0 then passOf[plr]=nil end
report(false)
end
end
end
local function others()
local list={}
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and not isWhitelisted(plr) and aliveCharacter(plr) then list[#list+1]=plr end
end
return list
end
local function startLoop(key,body,delayOf)
if loops[key] then loops[key]=nil end
local token={}
loops[key]=token
task.spawn(function()
while loops[key]==token and alive and runtimeAlive do
local ok,err=pcall(body)
if not ok then stats.lastError=tostring(err) end
while flinging and loops[key]==token do task.wait() end
local delay=delayOf and delayOf() or settings.loopDelay
if delay>0 then task.wait(delay) else task.wait() end
end
end)
end
-- (switching a loop, auto, aura, bind button, keybind or click mode off stops its flinging straight
-- away: what's queued is dropped, the fling going on is cut short and nobody is flung again after)
local function stopLoop(key)
loops[key]=nil
local dropped={}
for _,plr in ipairs(flingQueue) do dropped[#dropped+1]=plr end
table.clear(flingQueue)
for _,plr in ipairs(dropped) do
local waiting=passOf[plr];passOf[plr]=nil
for _,report in ipairs(waiting or {}) do pcall(report,false) end
end
table.clear(dropped)
for _,plr in ipairs(ragdollQueue) do dropped[#dropped+1]=plr end
table.clear(ragdollQueue)
for _,plr in ipairs(dropped) do
local waiting=ragdollPassOf[plr];ragdollPassOf[plr]=nil
for _,report in ipairs(waiting or {}) do pcall(report,false,true) end
end
out.Cancel()
end
runtime.ThrownBomb=ThrownBomb
runtime.BombFling={Fling=fling,Ragdoll=ragdoll,GetBomb=getBomb,
OwnBomb=function() return ownBomb and usable(ownBomb) and ownBomb or nil end,
MyBomb=function() return ownBomb end,
IsBomb=function(part) return bombs[part]~=nil or part==ownBomb end,
NearestOwnedBomb=function(within) return nearestOwnedBomb(false,within,bombSignature(findBombTool())) end,
GetDiagnostics=function()
local count=0
for _ in pairs(bombs) do count=count+1 end
local copy=table.clone(stats);copy.tracked=count;copy.ownBomb=ownBomb and ownBomb:GetFullName() or nil
copy.queue=#flingQueue+#ragdollQueue;copy.flinging=flinging;copy.reportLines=0;copy.verified=verified~=nil and verified==ownBomb
copy.aim=aim.Summary();copy.aimData=aim.Data()
return copy
end}
-- (the Bomb Fling and Bomb Ragdoll menus are built in a function of their own: their locals then don't
-- count toward this section's, which keeps it well inside Luau's limit of 200 locals per function)
local resetMenus=(function()
local controls={}
local function toggle(name,key,callback)
local controller=addToggle(section,name,C(key,false),function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
section:AddButton("Bomb Fling Sheriff",function()
local target=findSheriff()
if target then fling(target) else notify("Bomb Fling: no sheriff found this round",0) end
end)
section:AddButton("Bomb Fling Murderer",function()
local target=findMurderer()
if target then fling(target) else notify("Bomb Fling: no murderer found this round",0) end
end)
-- Bomb Fling All: during a round it keeps going over everyone in the round, again and again, until
-- every one of them is dead or off the map (players in the lobby are left alone). It stops when the
-- round ends, after 3 minutes, when you're dead for a few seconds, or when it's pressed again. With
-- no round on, everyone alive is flung once, as before.
local untilOut=nil
section:AddButton("Bomb Fling All",function()
local round=runtime.Round
if not round or not round.Key() then flingAll(others(),everyone.Pass());return end
if untilOut then
untilOut=nil
notify("Bomb Fling All: stopped",3)
return
end
local token={}
untilOut=token
local key=round.Key()
notify("Bomb Fling All: flinging everyone in the round until they're out (press again to stop)",2)
task.spawn(function()
local started,deadSince=os.clock(),nil
local result="stopped"
while untilOut==token and alive and runtimeAlive do
if round.Key()~=key then result="round over";break end
local left=round.Players(isWhitelisted)
if #left==0 then result="done";break end
if os.clock()-started>180 then result="time";break end
if aliveCharacter(LocalPlayer) then deadSince=nil
else
deadSince=deadSince or os.clock()
if os.clock()-deadSince>3 then result="dead";break end
end
lastUse=os.clock()
if deadSince==nil and not flinging then flingAll(left,nil) end
while flinging and untilOut==token do task.wait(0.1) end
task.wait(0.2)
end
if untilOut~=token then return end
untilOut=nil
if result=="done" then
if not everyone.told then notify("Bomb Fling All: everyone in the round is out",2) end
elseif result=="time" then
notify(("Bomb Fling All: stopped after 3 minutes, %d still in the round"):format(#round.Players(isWhitelisted)),3)
elseif result=="dead" then
notify("Bomb Fling All: stopped, you died",3)
end
end)
end)
toggle("Loop Bomb Fling All","bombFlingLoopAll",function(value)
if value then
local pass=everyone.Pass()
startLoop("all",function()
local list={}
for _,plr in ipairs(others()) do
if not restingUntil[plr] or os.clock()>=restingUntil[plr] then list[#list+1]=plr end
end
flingAll(list,pass);pass=nil
end)
else
stopLoop("all")
end
end)
section:AddPlayerDropdown("Select Players",function(plr)
if typeof(plr)=="Instance" and plr~=LocalPlayer and not table.find(selectedPlayers,plr) then
selectedPlayers[#selectedPlayers+1]=plr
notify("Bomb Fling: "..plr.DisplayName.." added to the fling list",2)
end
end)
section:AddButton("Clear Selected Players",function() table.clear(selectedPlayers) end)
local function flingSelected()
for _,plr in ipairs(selectedPlayers) do
if plr.Parent and aliveCharacter(plr) then fling(plr) end
end
end
toggle("Loop Bomb Fling Player(s)","bombFlingLoopSelected",function(value)
if value then startLoop("selected",flingSelected) else stopLoop("selected") end
end)
-- (0: the next fling starts as soon as the last one ends, so the bomb keeps going at them)
section:AddSlider("Loop Bomb Fling Delay (seconds)",0,6,settings.loopDelay,function(value)
settings.loopDelay=math.clamp(tonumber(value) or 3,0,6);SetCfg("bombFlingLoopDelay",settings.loopDelay)
end)
section:AddSlider("Bomb Fling Duration",MIN_DURATION,MAX_DURATION,settings.duration,function(value)
settings.duration=math.clamp(tonumber(value) or MIN_DURATION,MIN_DURATION,MAX_DURATION);SetCfg("bombFlingDuration",settings.duration)
end)
toggle("Keep Bomb In Your Body","bombHideInBody",function(value) settings.hideInBody=value end)
section:AddLabel(("Tougher players are given up to %d s to get flung"):format(HOP_TIME))
-- (what has worked so far, for Bomb Fling and Bomb Ragdoll: hits, time to fling and each aiming way;
-- the last attempts are printed to the console, F9)
section:AddButton("Show Bomb Fling / Ragdoll Stats",function()
local lines=aim.Summary()
notify(table.concat(lines,"\n"),3)
print("[World V2] Bomb Fling / Ragdoll stats")
for _,line in ipairs(lines) do print("  "..line) end
for _,entry in ipairs(aim.Recent()) do
print(("  %s %s: %s in %.1f s, way %s%s"):format(entry.kind,entry.name,entry.hit and "hit" or "missed",entry.took,entry.way,entry.moving and " (moving)" or "")..(entry.place and (", "..entry.place) or "")..(entry.out and ", out of the map" or ""))
end
end)
local function autoFling(name,key,finder)
local recent={}
toggle("Auto Bomb Fling "..name,key,function(value)
if not value then stopLoop(key);return end
startLoop(key,function()
local target=finder()
if target and (not recent[target] or os.clock()-recent[target]>=settings.loopDelay) then
recent[target]=os.clock()
fling(target)
end
end)
end)
end
autoFling("Sheriff","bombFlingAutoSheriff",findSheriff)
autoFling("Murderer","bombFlingAutoMurderer",findMurderer)
local clickConnections={}
local ragdollClickConnections={}
local function playerFromPart(part)
local current=part
while current and current~=workspace do
if current:IsA("Model") then
local plr=Players:GetPlayerFromCharacter(current)
if plr then return plr end
end
current=current.Parent
end
end
local function buttonAt(x,y)
local containers={LocalPlayer:FindFirstChildOfClass("PlayerGui")}
pcall(function() containers[#containers+1]=game:GetService("CoreGui") end)
for _,container in ipairs(containers) do
local ok,objects=pcall(function() return container:GetGuiObjectsAtPosition(x,y) end)
if ok and type(objects)=="table" then
for _,object in ipairs(objects) do
if object.Visible and (object:IsA("GuiButton") or object:IsA("TextBox")) then return true end
end
end
end
return false
end
local function playerAt(x,y,viewportSpace)
local camera=workspace.CurrentCamera
if not camera then return nil end
local ray=viewportSpace and camera:ViewportPointToRay(x,y) or camera:ScreenPointToRay(x,y)
local ignore={}
if LocalPlayer.Character then ignore[#ignore+1]=LocalPlayer.Character end
if ownBomb then ignore[#ignore+1]=ownBomb end
local params=RaycastParams.new()
params.FilterType=Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances=ignore
local ok,result=pcall(function() return workspace:Raycast(ray.Origin,ray.Direction*2000,params) end)
local hitPlayer=ok and result and playerFromPart(result.Instance)
if hitPlayer and hitPlayer~=LocalPlayer then return hitPlayer end
local tap=Vector2.new(x,y)
local best,bestDistance=nil,math.clamp(camera.ViewportSize.Y*0.08,40,100)
for _,plr in ipairs(others()) do
for _,name in ipairs({"HumanoidRootPart","Head","Torso","UpperTorso"}) do
local part=plr.Character and plr.Character:FindFirstChild(name)
if part and part:IsA("BasePart") then
local point,visible
if viewportSpace then point,visible=camera:WorldToViewportPoint(part.Position)
else point,visible=camera:WorldToScreenPoint(part.Position) end
local distance=(Vector2.new(point.X,point.Y)-tap).Magnitude
if visible and distance<bestDistance then best,bestDistance=plr,distance end
end
end
end
return best
end
toggle("Click Bomb Fling","bombFlingClick",function(value)
for _,connection in ipairs(clickConnections) do connection:Disconnect() end
table.clear(clickConnections)
if not value then stopLoop("click");return end
local function chosen(plr)
if plr and plr~=LocalPlayer and not isWhitelisted(plr) then
notify("Bomb Fling: flinging "..plr.DisplayName,3)
fling(plr)
end
end
clickConnections[#clickConnections+1]=UserInputService.InputBegan:Connect(function(input,processed)
if processed or input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
local location=UserInputService:GetMouseLocation()
chosen(playerAt(location.X,location.Y,true))
end)
clickConnections[#clickConnections+1]=UserInputService.TouchTap:Connect(function(positions,processed)
local position=type(positions)=="table" and positions[1]
if not position then return end
if processed and buttonAt(position.X,position.Y) then return end
chosen(playerAt(position.X,position.Y,false))
end)
end)
toggle("Bomb Fling Aura","bombFlingAura",function(value)
if not value then stopLoop("aura");return end
startLoop("aura",function()
local mine=rootOf(LocalPlayer)
if not mine then return end
for _,plr in ipairs(others()) do
local root=rootOf(plr)
if root and (root.Position-mine.Position).Magnitude<=settings.auraDistance then fling(plr) end
end
end)
end)
section:AddSlider("Bomb Fling Aura Studs",5,50,settings.auraDistance,function(value)
settings.auraDistance=math.clamp(tonumber(value) or 15,5,50);SetCfg("bombFlingAuraStuds",settings.auraDistance)
end)

local BIND_KEYS={
{id="VisualsV2_BombFlingSheriff",text="BFS",key="bombFlingBFS",label="BFS",find=function() local t=findSheriff();return t and {t} or {} end,default=UDim2.new(0.10,0,0.78,0)},
{id="VisualsV2_BombFlingMurderer",text="BFM",key="bombFlingBFM",label="BFM",find=function() local t=findMurderer();return t and {t} or {} end,default=UDim2.new(0.16,0,0.78,0)},
{id="VisualsV2_BombFlingSelected",text="BSP",key="bombFlingBFSP",label="BSP",find=function() return selectedPlayers end,default=UDim2.new(0.22,0,0.78,0)},
}
local function bindSize(id,size)
local b=BindableButtons.Buttons[id]
if not b then return end
local camera=workspace.CurrentCamera
local screen=camera and camera.ViewportSize or Vector2.new(1920,1080)
if screen.X<=1 or screen.Y<=1 then screen=Vector2.new(1920,1080) end
b.Size=UDim2.new(size*(screen.Y/screen.X),0,size,0)
end
for _,spec in ipairs(BIND_KEYS) do
local size=math.clamp(tonumber(C(spec.key.."Size",11)) or 11,5,25)/100
local function create()
BindableButtons.AddBButton(spec.id,spec.text,function()
if spec.label=="BSP" and #selectedPlayers==0 then
notify("Bomb Fling: no players selected for BSP (pick them in Select Players)",0)
task.defer(function() BindableButtons:SetValue(spec.id,false,false) end)
return
end
startLoop(spec.id,function() for _,plr in ipairs(spec.find()) do fling(plr) end end)
end,function() stopLoop(spec.id) end,function(position)
saveStoredPosition(spec.key.."ButtonPosition",position)
end)
BindableButtons:SetPosition(spec.id,loadStoredPosition(spec.key.."ButtonPosition",spec.default))
BindableButtons:SetLocked(spec.id,lockBindButtonPos)
bindSize(spec.id,size)
end
toggle("Enable "..spec.label.." Button",spec.key.."Enabled",function(value)
if value then create() else stopLoop(spec.id);BindableButtons:DeleteBButton(spec.id) end
end)
section:AddSlider(spec.label.." Button Size",5,25,size*100,function(value)
size=math.clamp(tonumber(value) or 11,5,25)/100
SetCfg(spec.key.."Size",size*100)
bindSize(spec.id,size)
end)
section:AddButton("Reset "..spec.label.." Button Position",function()
saveStoredPosition(spec.key.."ButtonPosition",spec.default)
BindableButtons:SetPosition(spec.id,spec.default)
end)
end
-- (keybinds: each one turns the same loop as its bind button on or off, BFM, BFS and BSP, and says
-- which; Player flings the players picked in Select Players, like BSP)
local keysOn=C("bombFlingKeybindsEnabled",false)==true
toggle("Enable Bomb Fling Keybinds","bombFlingKeybindsEnabled",function(value) keysOn=value end)
local function keyToggle(spec,title)
if not (alive and runtimeAlive and keysOn) then return end
local lit=function(value) pcall(function() BindableButtons:SetValue(spec.id,value,false) end) end
if loops[spec.id] then
stopLoop(spec.id);lit(false)
notify("Bomb Fling: "..title.." disabled",3)
return
end
if spec.label=="BSP" and #selectedPlayers==0 then notify("Bomb Fling: no players picked (use Select Players)",0);return end
startLoop(spec.id,function() for _,plr in ipairs(spec.find()) do fling(plr) end end)
lit(true)
notify("Bomb Fling: "..title.." enabled",2)
end
section:AddKeybind("Bomb Fling Murderer Keybind","B",function() keyToggle(BIND_KEYS[2],"Murderer") end)
section:AddKeybind("Bomb Fling Sheriff Keybind","N",function() keyToggle(BIND_KEYS[1],"Sheriff") end)
section:AddKeybind("Bomb Fling Player Keybind","H",function() keyToggle(BIND_KEYS[3],"Player") end)
-- Bomb Ragdoll: laid out like Bomb Fling, with the same Fake Bomb, but only knocks people over
local rsection=mainTab:AddSection("Bomb Ragdoll","Utilities")
local function rtoggle(name,key,callback)
local controller=addToggle(rsection,name,C(key,false),function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
local function ragdollDelay() return ragdollSettings.loopDelay end
local function ragdollOthers()
local list={}
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and not ragdollSpared(plr) and aliveCharacter(plr) then list[#list+1]=plr end
end
return list
end
local function findRagdollMurderer()
local target=findMurderer()
return target and not ragdollSpared(target) and target or nil
end
local function findRagdollSheriff()
local target=findSheriff()
return target and not ragdollSpared(target) and target or nil
end
rsection:AddButton("Bomb Ragdoll Sheriff",function()
local target=findRagdollSheriff()
if target then ragdoll(target) else notify("Bomb Ragdoll: no sheriff found this round",0) end
end)
rsection:AddButton("Bomb Ragdoll Murderer",function()
local target=findRagdollMurderer()
if target then ragdoll(target) else notify("Bomb Ragdoll: no murderer found this round",0) end
end)
rsection:AddButton("Bomb Ragdoll All",function()
local round=runtime.Round
local list=(round and round.Key()) and round.Players(ragdollSpared) or ragdollOthers()
ragdollAll(list,everyoneRagdoll.Pass())
end)
rtoggle("Loop Bomb Ragdoll All","bombRagdollLoopAll",function(value)
if value then
local pass=everyoneRagdoll.Pass()
startLoop("ragdollAll",function() ragdollAll(ragdollOthers(),pass);pass=nil end,ragdollDelay)
else
stopLoop("ragdollAll")
end
end)
rsection:AddPlayerDropdown("Select Players",function(plr)
if typeof(plr)=="Instance" and plr~=LocalPlayer and not table.find(ragdollSelected,plr) then
ragdollSelected[#ragdollSelected+1]=plr
notify("Bomb Ragdoll: "..plr.DisplayName.." added to the ragdoll list",2)
end
end)
rsection:AddButton("Clear Selected Players",function() table.clear(ragdollSelected) end)
local function ragdollPicked()
for _,plr in ipairs(ragdollSelected) do
if plr.Parent and aliveCharacter(plr) then ragdoll(plr) end
end
end
rtoggle("Loop Bomb Ragdoll Player(s)","bombRagdollLoopSelected",function(value)
if value then startLoop("ragdollSelected",ragdollPicked,ragdollDelay) else stopLoop("ragdollSelected") end
end)
rsection:AddSlider("Loop Bomb Ragdoll Delay (seconds)",0,6,ragdollSettings.loopDelay,function(value)
ragdollSettings.loopDelay=math.clamp(tonumber(value) or 3,0,6);SetCfg("bombRagdollLoopDelay",ragdollSettings.loopDelay)
end)
local function autoRagdoll(name,key,finder)
local recent={}
rtoggle("Auto Bomb Ragdoll "..name,key,function(value)
if not value then stopLoop(key);return end
startLoop(key,function()
local target=finder()
if target and (not recent[target] or os.clock()-recent[target]>=ragdollSettings.loopDelay) then
recent[target]=os.clock()
ragdoll(target)
end
end,ragdollDelay)
end)
end
autoRagdoll("Sheriff","bombRagdollAutoSheriff",findRagdollSheriff)
autoRagdoll("Murderer","bombRagdollAutoMurderer",findRagdollMurderer)
rtoggle("Click Bomb Ragdoll","bombRagdollClick",function(value)
for _,connection in ipairs(ragdollClickConnections) do connection:Disconnect() end
table.clear(ragdollClickConnections)
if not value then stopLoop("ragdollClick");return end
local function chosen(plr)
if plr and plr~=LocalPlayer and not ragdollSpared(plr) then
notify("Bomb Ragdoll: ragdolling "..plr.DisplayName,3)
ragdoll(plr)
end
end
ragdollClickConnections[#ragdollClickConnections+1]=UserInputService.InputBegan:Connect(function(input,processed)
if processed or input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
local location=UserInputService:GetMouseLocation()
chosen(playerAt(location.X,location.Y,true))
end)
ragdollClickConnections[#ragdollClickConnections+1]=UserInputService.TouchTap:Connect(function(positions,processed)
local position=type(positions)=="table" and positions[1]
if not position then return end
if processed and buttonAt(position.X,position.Y) then return end
chosen(playerAt(position.X,position.Y,false))
end)
end)
rtoggle("Bomb Ragdoll Aura","bombRagdollAura",function(value)
if not value then stopLoop("ragdollAura");return end
startLoop("ragdollAura",function()
local mine=rootOf(LocalPlayer)
if not mine then return end
for _,plr in ipairs(ragdollOthers()) do
local root=rootOf(plr)
if root and (root.Position-mine.Position).Magnitude<=ragdollSettings.auraDistance then ragdoll(plr) end
end
end,ragdollDelay)
end)
rsection:AddSlider("Bomb Ragdoll Aura Studs",5,50,ragdollSettings.auraDistance,function(value)
ragdollSettings.auraDistance=math.clamp(tonumber(value) or 15,5,50);SetCfg("bombRagdollAuraStuds",ragdollSettings.auraDistance)
end)
local RAGDOLL_BIND_KEYS={
{id="VisualsV2_BombRagdollSheriff",text="BRS",key="bombRagdollBRS",label="BRS",find=function() local t=findRagdollSheriff();return t and {t} or {} end,default=UDim2.new(0.10,0,0.70,0)},
{id="VisualsV2_BombRagdollMurderer",text="BRM",key="bombRagdollBRM",label="BRM",find=function() local t=findRagdollMurderer();return t and {t} or {} end,default=UDim2.new(0.16,0,0.70,0)},
{id="VisualsV2_BombRagdollSelected",text="BRP",key="bombRagdollBRP",label="BRP",find=function() return ragdollSelected end,default=UDim2.new(0.22,0,0.70,0)},
}
-- (BRS, BRM, BRP and their keybinds: one go, not a loop. Each target gets one ragdoll, which lasts until
-- they're on the ground (or 7 s, then it says it failed), then it's done and the button goes off.
-- Pressing again while it's going cancels it, and so does a Bomb Fling)
local ragdollRuns={}
local function ragdollLit(spec,value) pcall(function() BindableButtons:SetValue(spec.id,value,false) end) end
local function cancelRagdollRun(spec)
local run=ragdollRuns[spec.id]
if not run then return false end
ragdollRuns[spec.id]=nil
for _,plr in ipairs(run.targets) do
local index=table.find(ragdollQueue,plr)
if index then table.remove(ragdollQueue,index) end
end
ragdollLit(spec,false)
return true
end
local function ragdollOnce(spec,title)
if cancelRagdollRun(spec) then stopLoop(spec.id);notify("Bomb Ragdoll: "..title.." cancelled",3);return end
local list={}
for _,plr in ipairs(spec.find()) do
if plr.Parent and aliveCharacter(plr) and not ragdollSpared(plr) and not table.find(list,plr) then list[#list+1]=plr end
end
if #list==0 then
notify(spec.label=="BRP" and "Bomb Ragdoll: no players picked (use Select Players)" or "Bomb Ragdoll: no "..title:lower().." found this round",0)
task.defer(ragdollLit,spec,false)
return
end
local run={targets=list,pending=#list,downed=0}
ragdollRuns[spec.id]=run
ragdollLit(spec,true)
local function finish(hit,cancelled)
run.pending=run.pending-1
if hit then run.downed=run.downed+1 end
if cancelled then run.cancelled=true end
if run.pending>0 or ragdollRuns[spec.id]~=run then return end
ragdollRuns[spec.id]=nil
ragdollLit(spec,false)
-- (a failed one has already said so)
if run.cancelled and run.downed==0 then notify("Bomb Ragdoll: "..title.." cancelled for a Bomb Fling",3)
elseif run.downed==#list then notify("Bomb Ragdoll: "..title.." ragdolled",2)
elseif run.downed>0 then notify(("Bomb Ragdoll: %d of %d ragdolled"):format(run.downed,#list),3) end
end
for _,plr in ipairs(list) do
local started=os.clock()
local function try()
if ragdollRuns[spec.id]~=run then return end
if not aliveCharacter(plr) or ragdollSpared(plr) or os.clock()-started>15 then finish(false);return end
local waiting=ragdollPassOf[plr] or {}
ragdollPassOf[plr]=waiting
local function report(hit,cancelled)
if ragdollRuns[spec.id]~=run then return end
finish(hit,cancelled)
end
waiting[#waiting+1]=report
if not ragdoll(plr) then
for index=#waiting,1,-1 do if waiting[index]==report then table.remove(waiting,index);break end end
finish(false)
end
end
try()
end
end
for _,spec in ipairs(RAGDOLL_BIND_KEYS) do
local size=math.clamp(tonumber(C(spec.key.."Size",11)) or 11,5,25)/100
local title=spec.label=="BRS" and "Sheriff" or spec.label=="BRM" and "Murderer" or "Player"
local function create()
BindableButtons.AddBButton(spec.id,spec.text,function()
if not ragdollRuns[spec.id] then ragdollOnce(spec,title) end
end,function()
if cancelRagdollRun(spec) then stopLoop(spec.id);notify("Bomb Ragdoll: "..title.." cancelled",3) end
end,function(position)
saveStoredPosition(spec.key.."ButtonPosition",position)
end)
BindableButtons:SetPosition(spec.id,loadStoredPosition(spec.key.."ButtonPosition",spec.default))
BindableButtons:SetLocked(spec.id,lockBindButtonPos)
bindSize(spec.id,size)
end
rtoggle("Enable "..spec.label.." Button",spec.key.."Enabled",function(value)
if value then create() else cancelRagdollRun(spec);stopLoop(spec.id);BindableButtons:DeleteBButton(spec.id) end
end)
rsection:AddSlider(spec.label.." Button Size",5,25,size*100,function(value)
size=math.clamp(tonumber(value) or 11,5,25)/100
SetCfg(spec.key.."Size",size*100)
bindSize(spec.id,size)
end)
rsection:AddButton("Reset "..spec.label.." Button Position",function()
saveStoredPosition(spec.key.."ButtonPosition",spec.default)
BindableButtons:SetPosition(spec.id,spec.default)
end)
end
local ragdollKeysOn=C("bombRagdollKeybindsEnabled",false)==true
rtoggle("Enable Bomb Ragdoll Keybinds","bombRagdollKeybindsEnabled",function(value) ragdollKeysOn=value end)
local function ragdollKey(spec,title)
if not (alive and runtimeAlive and ragdollKeysOn) then return end
ragdollOnce(spec,title)
end
rsection:AddKeybind("Bomb Ragdoll Murderer Keybind","C",function() ragdollKey(RAGDOLL_BIND_KEYS[2],"Murderer") end)
rsection:AddKeybind("Bomb Ragdoll Sheriff Keybind","M",function() ragdollKey(RAGDOLL_BIND_KEYS[1],"Sheriff") end)
rsection:AddKeybind("Bomb Ragdoll Player Keybind","P",function() ragdollKey(RAGDOLL_BIND_KEYS[3],"Player") end)
return function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
untilOut=nil
for _,connection in ipairs(clickConnections) do connection:Disconnect() end
table.clear(clickConnections)
for _,connection in ipairs(ragdollClickConnections) do connection:Disconnect() end
table.clear(ragdollClickConnections)
for _,spec in ipairs(BIND_KEYS) do BindableButtons:DeleteBButton(spec.id) end
for _,spec in ipairs(RAGDOLL_BIND_KEYS) do BindableButtons:DeleteBButton(spec.id) end
end
end)()
local respawn=LocalPlayer.CharacterAdded:Connect(function()
ownBomb,verified=nil,nil
table.clear(flingQueue);table.clear(ragdollQueue)
throwReadyAt,backoffUntil,failures=0,0,0

end)
runtime.RegisterReset(function()
pcall(resetMenus)
table.clear(loops);table.clear(flingQueue);table.clear(selectedPlayers)
table.clear(ragdollQueue);table.clear(ragdollSelected)
settings.duration,settings.auraDistance=MIN_DURATION,15
ragdollSettings.loopDelay,ragdollSettings.auraDistance=3,15
if not runtimeAlive then
alive=false
watch:Disconnect();unwatch:Disconnect();respawn:Disconnect();recentWatch:Disconnect();carry:Disconnect()
tracker:Disconnect();leaving:Disconnect();table.clear(motion);table.clear(born)
table.clear(stillMisses);table.clear(restingUntil)
table.clear(recentParts)
end
end)
end,"Section \"W2 Bomb Fling\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local runtime=env.WorldV2Runtime
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local section=mainTab:AddSection("W2 Give Gun","Utilities")
local BIND_ID="VisualsV2_GiveGun"
local BIND_DEFAULT=UDim2.new(0.28,0,0.78,0)
local settings={
distance=math.clamp(tonumber(C("giveGunDistance",5)) or 5,1,20),
size=math.clamp(tonumber(C("giveGunButtonSize",11)) or 11,5,25)/100,
}
local state={selected=nil,friends=false,tracking=false,auto=false,keybindOn=false,giving=false,bind=false}
local connections={noclip=nil,tracking=nil}
local alive=true
local function notify(text,kind) pcall(shared.Notify,text,kind or 3) end
local function rootOf(plr)
local character=plr and plr.Character
return character and character:FindFirstChild("HumanoidRootPart") or nil
end
local function living(plr)
local character=plr and plr.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
return humanoid and humanoid.Health>0 and rootOf(plr)~=nil
end
local function holds(plr,word)
for _,container in ipairs({plr.Character,plr:FindFirstChildOfClass("Backpack")}) do
if container then
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and (tool.Name:lower():find(word,1,true)
or (word=="gun" and tool:FindFirstChild("Handle") and tool.Handle:FindFirstChild("Gun"))) then return true end
end
end
end
return false
end
local function hasGun() return holds(LocalPlayer,"gun") end
local roles={data=nil,at=-math.huge,fetching=false}
local function refreshRoles()
if roles.fetching or os.clock()-roles.at<(runtime.Roles and 1 or 3) then return end
roles.fetching=true
task.spawn(function()
local ok,result=pcall(function()
-- (asks the shared role lookup, which answers at once and asks the server once for every section)
local lookup=runtime.Roles
if lookup and type(lookup.Data)=="function" then return lookup.Data() end
local remote=ReplicatedStorage:FindFirstChild("GetPlayerData",true)
if remote and remote:IsA("RemoteFunction") then return remote:InvokeServer() end
end)
if ok and type(result)=="table" then roles.data=result end
roles.at=os.clock();roles.fetching=false
end)
end
local friendCache=setmetatable({}, {__mode="k"})
local function checkFriend(plr,wait)
if plr==LocalPlayer then return false end
local cached=friendCache[plr]
if cached and (cached.checking or os.clock()-cached.at<120) then
if cached.checking and wait then
for _=1,20 do if not cached.checking then break end;task.wait(0.1) end
end
return cached.value==true
end
local entry={value=cached and cached.value or false,at=os.clock(),checking=true}
friendCache[plr]=entry
local function ask()
local ok,result=pcall(function() return LocalPlayer:IsFriendsWith(plr.UserId) end)
entry.value=ok and result==true;entry.at=os.clock();entry.checking=false
end
if wait then ask() else task.spawn(ask) end
return entry.value==true
end
local function primeFriends() for _,plr in ipairs(Players:GetPlayers()) do checkFriend(plr,false) end end
local function nearestFriend(wait)
refreshRoles()
local mine=rootOf(LocalPlayer)
local best,bestDistance=nil,math.huge
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and living(plr) and checkFriend(plr,wait) and not holds(plr,"knife") then
local info=type(roles.data)=="table" and roles.data[plr.Name] or nil
local inRound=type(roles.data)~="table" or (type(info)=="table" and not info.Dead and not info.Killed and info.Role~="Murderer")
if inRound then
local distance=mine and (rootOf(plr).Position-mine.Position).Magnitude or 0
if distance<bestDistance then best,bestDistance=plr,distance end
end
end
end
return best
end
-- (with Give Gun To Friends on, your nearest friend in the round comes first; with no friend to give
-- it to, it goes to your selected player)
local function target(wait)
if state.friends then
local friend=nearestFriend(wait)
if friend then return friend end
end
local plr=state.selected
if plr and plr.Parent and plr~=LocalPlayer then return plr end
return nil
end
local changed={}
local function noclip(on)
if connections.noclip then connections.noclip:Disconnect();connections.noclip=nil end
if on then
connections.noclip=RunService.Stepped:Connect(function()
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and plr.Character then
for _,part in ipairs(plr.Character:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
if changed[part]==nil then changed[part]=true end
part.CanCollide=false
end
end
end
end
end)
return
end
for part in pairs(changed) do
if part.Parent then pcall(function() part.CanCollide=true end) end
end
table.clear(changed)
end
local function spotNear(plr)
local root=rootOf(plr)
if not root then return nil end
local humanoid=plr.Character:FindFirstChildOfClass("Humanoid")
local direction=humanoid and humanoid.MoveDirection or Vector3.zero
if direction.Magnitude>0.1 then
return root.CFrame+direction.Unit*settings.distance+Vector3.new(0,3,0)
end
return root.CFrame+Vector3.new(0,3,0)
end
local function stopTracking()
if connections.tracking then connections.tracking:Disconnect();connections.tracking=nil end
end
local function give(plr)
if state.giving or not runtimeAlive then return end
if not plr then
notify(state.friends and "W2 Give Gun: no friend in the round and no player selected" or "W2 Give Gun: no player selected",0)
return
end
if not hasGun() then notify("W2 Give Gun: you don't have the gun",0);return end
local character=LocalPlayer.Character
local root=rootOf(LocalPlayer)
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health<=0 then notify("W2 Give Gun: your character isn't loaded",0);return end
local spot=spotNear(plr)
if not spot or not living(plr) then notify("W2 Give Gun: "..plr.DisplayName.." isn't alive",0);return end
state.giving=true
notify("W2 Give Gun: giving the gun to "..plr.DisplayName.."...",3)
noclip(true)
root.CFrame=spot
if state.tracking then
connections.tracking=RunService.Stepped:Connect(function()
local nowSpot=root.Parent and spotNear(plr)
if nowSpot then root.CFrame=nowSpot end
end)
task.wait(0.5)
else
task.wait(0.3)
end
if character.Parent then
pcall(function() character:BreakJoints() end)
pcall(function() humanoid.Health=0 end)
end
stopTracking()
task.delay(2,function() noclip(false) end)
state.giving=false
end
local function press() task.spawn(function() give(target(true)) end) end
local controls={}
local function toggle(name,key,callback)
local controller=addToggle(section,name,C(key,false),function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
section:AddPlayerDropdown("W2 Select Player",function(plr)
if typeof(plr)=="Instance" and plr:IsA("Player") and plr~=LocalPlayer then state.selected=plr else state.selected=nil end
end)
toggle("W2 Give Gun To Friends In Server","giveGunFriends",function(value)
state.friends=value
if value then primeFriends();refreshRoles() end
end)
section:AddSlider("W2 Teleport Distance (Studs)",1,20,settings.distance,function(value)
settings.distance=math.clamp(tonumber(value) or 5,1,20);SetCfg("giveGunDistance",settings.distance)
end)
toggle("W2 Dynamic Tracking (Stay In Front)","giveGunTracking",function(value) state.tracking=value end)
toggle("W2 Auto Give Gun","giveGunAuto",function(value)
state.auto=value
if not value then return end
task.spawn(function()
while state.auto and alive and runtimeAlive do
if not state.giving and hasGun() then
local plr=target(true)
if plr then give(plr) end
end
task.wait(2)
end
end)
end)
section:AddButton("W2 Give Gun",press)
local function bindSize()
local b=BindableButtons.Buttons[BIND_ID]
if not b then return end
local camera=workspace.CurrentCamera
local screen=camera and camera.ViewportSize or Vector2.new(1920,1080)
if screen.X<=1 or screen.Y<=1 then screen=Vector2.new(1920,1080) end
b.Size=UDim2.new(settings.size*(screen.Y/screen.X),0,settings.size,0)
end
local function createBind()
BindableButtons.AddBButton(BIND_ID,"Give Gun",press,press,function(position)
saveStoredPosition("giveGunButtonPosition",position)
end)
BindableButtons:SetPosition(BIND_ID,loadStoredPosition("giveGunButtonPosition",BIND_DEFAULT))
BindableButtons:SetLocked(BIND_ID,lockBindButtonPos)
bindSize()
end
toggle("W2 Enable Give Gun Button","giveGunButtonEnabled",function(value)
state.bind=value
if value then createBind() else BindableButtons:DeleteBButton(BIND_ID) end
end)
section:AddSlider("W2 Give Gun Button Size",5,25,settings.size*100,function(value)
settings.size=math.clamp(tonumber(value) or 11,5,25)/100
SetCfg("giveGunButtonSize",settings.size*100)
bindSize()
end)
section:AddButton("W2 Reset Give Gun Button Position",function()
saveStoredPosition("giveGunButtonPosition",BIND_DEFAULT)
BindableButtons:SetPosition(BIND_ID,BIND_DEFAULT)
end)
toggle("W2 Enable Give Gun Keybind","giveGunKeybindEnabled",function(value) state.keybindOn=value end)
section:AddKeybind("W2 Give Gun Keybind","G",function()
if runtimeAlive and state.keybindOn then press() end
end)
section:AddParagraph("W2 Auto Give Gun","Only gives the gun while you have it, so pick it up first (an auto grab gun does this for you).")
task.spawn(function()
while alive and runtimeAlive do
task.wait(0.5)
if state.bind and BindableButtons.Buttons[BIND_ID] then
local ready=not state.giving and hasGun() and target(false)~=nil
pcall(function() BindableButtons:SetValue(BIND_ID,ready,false) end)
end
end
end)
local joined=Players.PlayerAdded:Connect(function(plr) if state.friends then checkFriend(plr,false) end end)
local respawn=LocalPlayer.CharacterAdded:Connect(function()
stopTracking();noclip(false);state.giving=false
end)
runtime.GiveGun={Give=press,}
runtime.RegisterReset(function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
stopTracking();noclip(false)
BindableButtons:DeleteBButton(BIND_ID)
state.selected=nil;state.giving=false
settings.distance,settings.size=5,0.11
if not runtimeAlive then
alive=false
joined:Disconnect();respawn:Disconnect()
end
end)
end,"Section \"W2 Give Gun\"")
;w2Section(function()
if not inMurderMystery then return end
local runtime=env.WorldV2Runtime
local section=mainTab:AddSection("Auto Grab Gun","Utilities")
local state={on=false,run=0,grabs=0,tries=0,warned=false}
local function touch(a,b)
firetouchinterest(a,b,0)
firetouchinterest(a,b,1)
end
-- (works in MM2 and MMV: your gun counts by name or by what kind of weapon it is, so a skinned or
-- renamed one does too; the dropped gun is found as a part or a model called GunDrop or DroppedGun, or a
-- gun lying on the map, and the part of it that picks it up is the one touched)
local function gunKind(tool)
if tool.Name=="Gun" or tool:GetAttribute("IsGun")==true then return true end
local skins=runtime.ClientWeaponSkins
if skins and type(skins.GetKind)=="function" then
local ok,kind=pcall(skins.GetKind,tool)
return ok and kind=="Gun"
end
return false
end
local function hasGun()
for _,container in ipairs({LocalPlayer.Character or false,LocalPlayer:FindFirstChildOfClass("Backpack") or false}) do
if container then
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and gunKind(tool) then return true end
end
end
end
return false
end
local function heldBySomeone(item)
local current=item.Parent
while current and current~=workspace do
if current:FindFirstChildOfClass("Humanoid") then return true end
current=current.Parent
end
return false
end
local function touchPart(item)
if item:IsA("BasePart") then return item end
local best=nil
for _,part in ipairs(item:GetDescendants()) do
if part:IsA("BasePart") then
if part:FindFirstChildOfClass("TouchTransmitter") then return part end
best=best or part
end
end
if item:IsA("Model") and item.PrimaryPart then return item.PrimaryPart end
return best
end
local DROP_NAMES={gundrop=true,droppedgun=true,gundropped=true}
local drops=setmetatable({}, {__mode="k"})
local function consider(item)
local name=item.Name:lower()
if DROP_NAMES[name] or (item:IsA("Tool") and gunKind(item)) then drops[item]=true end
end
local dropWatch=workspace.DescendantAdded:Connect(function(item) pcall(consider,item) end)
local function gunDrop()
for item in pairs(drops) do
if item.Parent and item:IsDescendantOf(workspace) and not heldBySomeone(item) then
local part=touchPart(item)
if part then return part end
else
drops[item]=nil
end
end
for _,name in ipairs({"GunDrop","DroppedGun"}) do
local item=workspace:FindFirstChild(name,true)
if item and not heldBySomeone(item) then
local part=touchPart(item)
if part then return part end
end
end
return nil
end
runtime.GunDrop={Find=gunDrop,Has=hasGun}
local function grab()
local character=LocalPlayer.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local drop=gunDrop()
if not root or not drop or not humanoid or humanoid.Health<=0 or hasGun() then return false end
if type(firetouchinterest)~="function" then
if not state.warned then
state.warned=true
pcall(shared.Notify,"Auto Grab Gun: this executor has no firetouchinterest, so the gun can't be picked up",1)
end
return false
end
state.tries=state.tries+1
pcall(touch,root,drop)
task.wait(0.5)
if hasGun() then state.grabs=state.grabs+1;return true end
return false
end
local function apply(value)
state.on=value
state.run=state.run+1
if not value then return end
local run=state.run
task.spawn(function()
while state.on and state.run==run and runtimeAlive do
pcall(grab)
task.wait(0.5)
end
end)
end
local toggle=addToggle(section,"Enable Auto Grab Gun",C("w2AutoGrabGun",false),function(value)
SetCfg("w2AutoGrabGun",value)
apply(value)
end)
runtime.RegisterReset(function()
pcall(function() toggle:Set(false) end)
apply(false)
if not runtimeAlive then dropWatch:Disconnect() end
end)
end,"Section \"W2 Auto Grab Gun\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local runtime=env.WorldV2Runtime
local roles=runtime.Roles
local section=mainTab:AddSection("Fling","Utilities")
local everyone=runtime.EveryoneNotices("Fling","fling","flung")
local alive=true
local state={bindTarget=nil,selected={},flinging=false,oldPosition=nil,flung=0}
local settings={auraStuds=math.clamp(tonumber(C("w2FlingAuraStuds",15)) or 15,5,50)}
local loops={}
local clickConnections={}
local function notify(text,kind) pcall(shared.Notify,text,kind or 3) end
local function whitelisted(plr) return (env.WorldV2Runtime.Whitelist~=nil and env.WorldV2Runtime.Whitelist.Has(plr)) end
local function playerOf(value)
if type(value)=="table" then value=value[1] or value.Value or value.value end
if typeof(value)=="Instance" and value:IsA("Player") then return value end
return nil
end
local function present(plr) return plr and plr.Parent==Players and plr~=LocalPlayer end
local STILL={
{0,1.5,0,true},{0,-1.5,0,true},{2.25,1.5,-2.25,true},{-2.25,-1.5,2.25,true},{0,1.5,0,false},{0,-1.5,0,false},
}
local function skid(target,duration)
if not present(target) then return false end
if whitelisted(target) then notify("Fling: "..target.DisplayName.." is whitelisted, so not flung",0);return false end
local waited=os.clock()
while state.flinging and os.clock()-waited<8 do task.wait(0.05) end
if not alive or not runtimeAlive or state.flinging or not present(target) then return false end
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local root=humanoid and humanoid.RootPart
local theirs=target.Character
if not (character and humanoid and root and theirs) or humanoid.Health<=0 then return false end
local theirHumanoid=theirs:FindFirstChildOfClass("Humanoid")
local theirRoot=theirHumanoid and theirHumanoid.RootPart
local theirHead=theirs:FindFirstChild("Head")
local accessory=theirs:FindFirstChildOfClass("Accessory")
local handle=accessory and accessory:FindFirstChild("Handle")
if not theirs:FindFirstChildWhichIsA("BasePart") then return false end
state.flinging=true
local wasInRound=everyone.InRound(target)
if root.AssemblyLinearVelocity.Magnitude<50 then state.oldPosition=root.CFrame end
local camera=workspace.CurrentCamera
pcall(function()
if theirHead then camera.CameraSubject=theirHead
elseif handle then camera.CameraSubject=handle
elseif theirHumanoid and theirRoot then camera.CameraSubject=theirHumanoid end
end)
local previousHeight=workspace.FallenPartsDestroyHeight
local velocity
local launched=false
local function place(part,offset,angle)
local at=CFrame.new(part.Position)*offset*angle
root.CFrame=at
pcall(function() character:SetPrimaryPartCFrame(at) end)
root.Velocity=Vector3.new(9e7,9e7*10,9e7)
root.RotVelocity=Vector3.new(9e8,9e8,9e8)
end
local function sweep(part)
local started=os.clock()
local limit=duration or 2
local angle=0
local function ahead() return theirRoot and theirRoot.Velocity.Magnitude/1.25 or theirHumanoid.WalkSpeed end
repeat
if not (root.Parent and theirHumanoid and theirHumanoid.Parent) then break end
if part.Velocity.Magnitude<50 then
angle=angle+100
local spin=CFrame.Angles(math.rad(angle),0,0)
for _,step in ipairs(STILL) do
local move=theirHumanoid.MoveDirection
local lead=step[4] and move*part.Velocity.Magnitude/1.25 or move
place(part,CFrame.new(step[1],step[2],step[3])+lead,spin)
task.wait()
end
else
local walk=theirHumanoid.WalkSpeed
place(part,CFrame.new(0,1.5,walk),CFrame.Angles(math.rad(90),0,0));task.wait()
place(part,CFrame.new(0,-1.5,-walk),CFrame.Angles(0,0,0));task.wait()
place(part,CFrame.new(0,1.5,walk),CFrame.Angles(math.rad(90),0,0));task.wait()
place(part,CFrame.new(0,1.5,ahead()),CFrame.Angles(math.rad(90),0,0));task.wait()
place(part,CFrame.new(0,-1.5,-ahead()),CFrame.Angles(0,0,0));task.wait()
place(part,CFrame.new(0,1.5,ahead()),CFrame.Angles(math.rad(90),0,0));task.wait()
place(part,CFrame.new(0,-1.5,0),CFrame.Angles(math.rad(90),0,0));task.wait()
place(part,CFrame.new(0,-1.5,0),CFrame.Angles(0,0,0));task.wait()
place(part,CFrame.new(0,-1.5,0),CFrame.Angles(math.rad(-90),0,0));task.wait()
place(part,CFrame.new(0,-1.5,0),CFrame.Angles(0,0,0));task.wait()
end
until not alive or not runtimeAlive or part.Velocity.Magnitude>500 or part.Parent~=target.Character
or target.Parent~=Players or target.Character~=theirs or theirHumanoid.Sit or os.clock()>started+limit
launched=target.Parent==Players and (part.Velocity.Magnitude>500 or part.Parent~=target.Character
or target.Character~=theirs or theirHumanoid.Health<=0)
end
local ok,problem=pcall(function()
workspace.FallenPartsDestroyHeight=0/0
velocity=Instance.new("BodyVelocity")
velocity.Name="WorldV2_FlingVelocity"
velocity.Velocity=Vector3.new(9e8,9e8,9e8)
velocity.MaxForce=Vector3.new(1/0,1/0,1/0)
velocity.Parent=root
humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
if theirRoot and theirHead then
if (theirRoot.Position-theirHead.Position).Magnitude>5 then sweep(theirHead) else sweep(theirRoot) end
elseif theirRoot then sweep(theirRoot)
elseif theirHead then sweep(theirHead)
elseif handle then sweep(handle) end
end)
if velocity then pcall(function() velocity:Destroy() end) end
pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true) end)
pcall(function() camera.CameraSubject=humanoid end)
local deadline=os.clock()+3
repeat
local back=state.oldPosition
if root.Parent and back then
local at=back*CFrame.new(0,0.5,0)
pcall(function()
root.CFrame=at
character:SetPrimaryPartCFrame(at)
humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end)
for _,part in ipairs(character:GetChildren()) do
if part:IsA("BasePart") then pcall(function() part.Velocity,part.RotVelocity=Vector3.zero,Vector3.zero end) end
end
end
task.wait()
until not alive or not root.Parent or not state.oldPosition or (root.Position-state.oldPosition.Position).Magnitude<25 or os.clock()>deadline
pcall(function() workspace.FallenPartsDestroyHeight=previousHeight end)
state.flinging=false
if not ok then warn("[World V2] Fling: "..tostring(problem)) end
state.flung=state.flung+1
if ok and launched then everyone.Flung(target,whitelisted,wasInRound) end
return ok,ok and launched
end
runtime.Fling={Fling=skid,}
local controls={}
local function toggle(name,key,callback)
local controller=addToggle(section,name,C(key,false),function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
local function startLoop(key,body)
local token={}
loops[key]=token
task.spawn(function()
while loops[key]==token and alive and runtimeAlive do
local ok,problem=pcall(body,function() return loops[key]==token and alive and runtimeAlive end)
if not ok then warn("[World V2] Fling: "..tostring(problem));task.wait(1) end
end
end)
end
local function stopLoop(key) loops[key]=nil end
local function noneFound(name)
if name=="Sheriff" and roles and roles.IsMine("Sheriff") then notify("Fling: you are the sheriff",0)
elseif name=="Murderer" and roles and roles.IsMine("Murderer") then notify("Fling: you are the murderer",0)
elseif name=="Player" then notify("Fling: pick a player in W2 Select Bind Button Player first",0)
else notify("Fling: no "..name:lower().." found this round",0) end
end
local function sheriff() return roles and roles.Sheriff(whitelisted) end
local function murderer() return roles and roles.Murderer(whitelisted) end
local function bindTarget() return present(state.bindTarget) and state.bindTarget or nil end
if inMurderMystery then
section:AddButton("Fling Sheriff",function()
task.spawn(function() local target=sheriff();if target then skid(target,2) else noneFound("Sheriff") end end)
end)
section:AddButton("Fling Murderer",function()
task.spawn(function() local target=murderer();if target then skid(target,2) else noneFound("Murderer") end end)
end)
end
section:AddButton("Fling All",function()
task.spawn(function()
local pass=everyone.Pass()
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and not whitelisted(plr) then
local _,hit=skid(plr,2)
pass.Result(hit)
task.wait(0.5)
end
end
pass.Close()
end)
end)
section:AddPlayerDropdown("Fling Player",function(value)
local plr=playerOf(value)
if present(plr) then task.spawn(skid,plr,2) end
end)
section:AddPlayerDropdown("W2 Select Bind Button Player",function(value)
local plr=playerOf(value)
state.bindTarget=present(plr) and plr or nil
if state.bindTarget then notify("Fling: the FP button now flings "..state.bindTarget.DisplayName,2) end
end)
section:AddPlayerDropdown("Select Players",function(value)
local plr=playerOf(value)
if not present(plr) then return end
for _,selected in ipairs(state.selected) do
if selected==plr then notify("Fling: "..plr.DisplayName.." is already on the fling list",3);return end
end
state.selected[#state.selected+1]=plr
notify("Fling: "..plr.DisplayName.." added to the fling list",2)
end)
section:AddButton("Clear Selected Players",function()
table.clear(state.selected)
notify("Fling: selected players cleared",2)
end)
toggle("Loop Fling Player(s)","w2FlingLoopPlayers",function(value)
if not value then stopLoop("players");return end
startLoop("players",function(running)
for _,plr in ipairs(table.clone(state.selected)) do
if not running() then return end
if present(plr) and not whitelisted(plr) then skid(plr,2);task.wait(0.5) end
end
task.wait(1)
end)
end)
for _,auto in ipairs(inMurderMystery and {{name="Sheriff",find=sheriff},{name="Murderer",find=murderer}} or {}) do
toggle("Auto Fling "..auto.name,"w2FlingAuto"..auto.name,function(value)
if not value then stopLoop("auto"..auto.name);return end
startLoop("auto"..auto.name,function(running)
task.wait(1)
local target=running() and auto.find()
if target then skid(target,2);task.wait(3) end
end)
end)
end
local confirm={on=C("w2FlingDoubleTap",false)==true,asked={}}
local CONFIRM_TIME=3
local function confirmed(spec)
if not confirm.on then return true end
local now=os.clock()
local asked=confirm.asked[spec.id]
if asked and now-asked<=CONFIRM_TIME then confirm.asked[spec.id]=nil;return true end
confirm.asked[spec.id]=now
local target=spec.find()
local who=spec.name=="Player" and (target and target.DisplayName or "your bind button player") or ("the "..spec.name:lower())
notify("Fling: tap "..spec.text.." again within 3 seconds to fling "..who,0)
return false
end
local BUTTONS={
{id="WorldV2_FlingSheriff",text="FS",name="Sheriff",key="w2FlingFS",find=sheriff,default=UDim2.new(0.34,0,0.78,0)},
{id="WorldV2_FlingMurderer",text="FM",name="Murderer",key="w2FlingFM",find=murderer,default=UDim2.new(0.40,0,0.78,0)},
{id="WorldV2_FlingPlayer",text="FP",name="Player",key="w2FlingFP",find=bindTarget,default=UDim2.new(0.46,0,0.78,0)},
}
if not inMurderMystery then table.remove(BUTTONS,1);table.remove(BUTTONS,1) end
local function bindSize(id,size)
local b=BindableButtons.Buttons[id]
if not b then return end
local camera=workspace.CurrentCamera
local screen=camera and camera.ViewportSize or Vector2.new(1920,1080)
if screen.X<=1 or screen.Y<=1 then screen=Vector2.new(1920,1080) end
b.Size=UDim2.new(size*(screen.Y/screen.X),0,size,0)
end
for _,spec in ipairs(BUTTONS) do
local size=math.clamp(tonumber(C(spec.key.."Size",11)) or 11,5,25)/100
local function press()
if not confirmed(spec) then
pcall(function() BindableButtons:SetValue(spec.id,false,false) end)
return
end
task.spawn(function()
local target=spec.find()
if target then
notify("Fling: flinging "..target.DisplayName,3)
skid(target,2)
else
noneFound(spec.name)
end
pcall(function() BindableButtons:SetValue(spec.id,false,false) end)
end)
end
local function create()
BindableButtons.AddBButton(spec.id,spec.text,press,function() end,function(position)
saveStoredPosition(spec.key.."ButtonPosition",position)
end)
BindableButtons:SetPosition(spec.id,loadStoredPosition(spec.key.."ButtonPosition",spec.default))
BindableButtons:SetLocked(spec.id,lockBindButtonPos)
bindSize(spec.id,size)
end
toggle("W2 Enable "..spec.text.." Button",spec.key.."Enabled",function(value)
if value then create() else BindableButtons:DeleteBButton(spec.id) end
end)
section:AddSlider("W2 "..spec.name.." Button Size",5,25,size*100,function(value)
size=math.clamp(tonumber(value) or 11,5,25)/100
SetCfg(spec.key.."Size",size*100)
bindSize(spec.id,size)
end)
end
section:AddButton("W2 Reset Fling Button Positions",function()
for _,spec in ipairs(BUTTONS) do
saveStoredPosition(spec.key.."ButtonPosition",spec.default)
BindableButtons:SetPosition(spec.id,spec.default)
end
end)
toggle("Loop Fling All","w2FlingLoopAll",function(value)
if not value then stopLoop("all");return end
local pass=everyone.Pass()
startLoop("all",function(running)
for _,plr in ipairs(Players:GetPlayers()) do
if not running() then return end
if plr~=LocalPlayer and not whitelisted(plr) then
local _,hit=skid(plr,2)
if pass then pass.Result(hit) end
task.wait(0.5)
end
end
if pass and running() then pass.Close();pass=nil end
task.wait(3)
end)
end)
local function clickedPlayer(input)
local camera=workspace.CurrentCamera
local params=RaycastParams.new()
params.FilterType=Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances={LocalPlayer.Character or workspace.Terrain}
local hit
pcall(function()
local ray=camera:ScreenPointToRay(input.Position.X,input.Position.Y)
local result=workspace:Raycast(ray.Origin,ray.Direction*1000,params)
hit=result and result.Instance
end)
if not hit then pcall(function() hit=LocalPlayer:GetMouse().Target end) end
local model=hit and hit:FindFirstAncestorWhichIsA("Model")
return model and Players:GetPlayerFromCharacter(model) or nil
end
toggle("Click Fling","w2FlingClick",function(value)
for _,connection in ipairs(clickConnections) do connection:Disconnect() end
table.clear(clickConnections)
if not value then return end
clickConnections[1]=UserInputService.InputBegan:Connect(function(input,processed)
if processed or not runtimeAlive then return end
if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
local plr=clickedPlayer(input)
if not present(plr) then return end
if whitelisted(plr) then notify("Click Fling: "..plr.DisplayName.." is whitelisted, so not flung",0);return end
notify("Click Fling: flinging "..plr.DisplayName,3)
task.spawn(skid,plr,2)
end)
end)
toggle("Fling Aura","w2FlingAura",function(value)
if not value then stopLoop("aura");return end
startLoop("aura",function(running)
task.wait(0.5)
local character=LocalPlayer.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
if not root then return end
for _,plr in ipairs(Players:GetPlayers()) do
if not running() then return end
if plr~=LocalPlayer and not whitelisted(plr) then
local theirRoot=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
if theirRoot and root.Parent and (root.Position-theirRoot.Position).Magnitude<=settings.auraStuds then skid(plr,1) end
end
end
end)
end)
section:AddSlider("Fling Aura Studs",5,50,settings.auraStuds,function(value)
settings.auraStuds=math.clamp(tonumber(value) or 15,5,50)
SetCfg("w2FlingAuraStuds",settings.auraStuds)
end)
toggle("Double tap to confirm","w2FlingDoubleTap",function(value) confirm.on=value;table.clear(confirm.asked) end)
runtime.RegisterReset(function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
table.clear(loops);table.clear(state.selected)
for _,connection in ipairs(clickConnections) do connection:Disconnect() end
table.clear(clickConnections)
for _,spec in ipairs(BUTTONS) do BindableButtons:DeleteBButton(spec.id) end
state.bindTarget=nil
settings.auraStuds=15
if not runtimeAlive then alive=false end
end)
end,"Section \"W2 Fling\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local runtime=env.WorldV2Runtime
local roles=runtime.Roles
local section=mainTab:AddSection("Reset Player","Utilities")
local everyone=runtime.EveryoneNotices("Reset Player","reset","reset")
local alive=true
local state={bindTarget=nil,selected={},resets=0,lastAttempt=-math.huge,resetting=false}
local settings={
duration=math.clamp(tonumber(C("w2ResetDuration",1)) or 1,0.1,5),
startStuds=math.clamp(tonumber(C("w2ResetStartStuds",5)) or 5,-5,20),
loopDelay=math.clamp(tonumber(C("w2ResetLoopDelay",1)) or 1,0,10),
auraStuds=math.clamp(tonumber(C("w2ResetAuraStuds",15)) or 15,5,50),
}
local COOLDOWN=0.4
local loops={}
local clickConnections={}
local function notify(text,kind) pcall(shared.Notify,text,kind or 3) end
local function whitelisted(plr) return (env.WorldV2Runtime.Whitelist~=nil and env.WorldV2Runtime.Whitelist.Has(plr)) end
local function playerOf(value)
if type(value)=="table" then value=value[1] or value.Value or value.value end
if typeof(value)=="Instance" and value:IsA("Player") then return value end
return nil
end
local function present(plr) return plr and plr.Parent==Players and plr~=LocalPlayer end
local function setRootReference(root,target)
pcall(function()
sethiddenproperty(root,"PhysicsRepRootRef",InstanceHandle.new(target))
sethiddenproperty(root,"PhysicsRepRootPart",target)
end)
end
local function clearRootReference(root)
pcall(function()
sethiddenproperty(root,"PhysicsRepRootRef",nil)
sethiddenproperty(root,"PhysicsRepRootPart",nil)
end)
end
local function touch(a,b)
pcall(function()
firetouchinterest(a,b,0)
firetouchinterest(a,b,1)
end)
end
local function resetPlayer(target)
if not present(target) or whitelisted(target) then return false end
local waited=os.clock()
while (state.resetting or os.clock()-state.lastAttempt<COOLDOWN) and os.clock()-waited<settings.duration+2 do task.wait(0.05) end
if state.resetting or os.clock()-state.lastAttempt<COOLDOWN or not alive or not runtimeAlive
or not present(target) or whitelisted(target) then return false end
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local root=humanoid and humanoid.RootPart
local theirs=target.Character
local theirRoot=theirs and theirs:FindFirstChild("HumanoidRootPart")
local theirHead=theirs and theirs:FindFirstChild("Head")
if not (character and humanoid and root and theirRoot) or humanoid.Health<=0 then return false end
state.lastAttempt=os.clock()
state.resetting=true
local wasInRound=everyone.InRound(target)
local theirHumanoid=theirs:FindFirstChildOfClass("Humanoid")
local saved={cframe=root.CFrame,collide={}}
for _,part in ipairs(character:GetDescendants()) do
if part:IsA("BasePart") then saved.collide[part]=part.CanCollide end
end
local previousHeight=workspace.FallenPartsDestroyHeight
local push,gyro
local function finish()
pcall(function() workspace.FallenPartsDestroyHeight=previousHeight end)
if push then pcall(function() push:Destroy() end) end
if gyro then pcall(function() gyro:Destroy() end) end
clearRootReference(root)
pcall(function()
humanoid.PlatformStand=false
for _,track in ipairs(humanoid:GetPlayingAnimationTracks()) do track:Stop() end
root.AssemblyLinearVelocity=Vector3.zero
root.AssemblyAngularVelocity=Vector3.zero
root.CFrame=saved.cframe
humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end)
for part,value in pairs(saved.collide) do
if part.Parent then pcall(function() part.CanCollide=value end) end
end
end
local ok,problem=pcall(function()
humanoid.PlatformStand=true
push=Instance.new("BodyVelocity")
push.Name="WorldV2_ResetVelocity"
push.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
push.Velocity=Vector3.new(0,-50000,0)
push.Parent=root
gyro=Instance.new("BodyGyro")
gyro.Name="WorldV2_ResetGyro"
gyro.MaxTorque=Vector3.new(math.huge,math.huge,math.huge)
gyro.P=1000000
gyro.Parent=root
workspace.FallenPartsDestroyHeight=0/0
local started=os.clock()
local duration=math.max(settings.duration,0.1)
local done=false
local step
step=RunService.Heartbeat:Connect(function()
if done then return end
if os.clock()-started>duration or not alive or not runtimeAlive or target.Character~=theirs
or not theirRoot.Parent or not root.Parent then
done=true
step:Disconnect()
return
end
local at=theirHead and theirHead.Parent and theirHead.Position or (theirRoot.Position+Vector3.new(0,settings.startStuds,0))
root.CFrame=CFrame.new(at)*CFrame.Angles(math.pi/2,0,0)
root.AssemblyLinearVelocity=Vector3.new(0,-50000,0)
root.AssemblyAngularVelocity=Vector3.new(7500,7500,7500)
for _=1,5 do
touch(root,theirRoot)
if theirHead then touch(root,theirHead) end
end
setRootReference(root,theirRoot)
end)
while not done and target.Parent do task.wait(0.05) end
if not done then done=true;step:Disconnect() end
end)
finish()
state.resetting=false
state.resets=state.resets+1
if not ok then warn("[World V2] Reset Player: "..tostring(problem)) end
local function gone()
return target.Parent==Players and (target.Character~=theirs or not theirRoot.Parent
or (theirHumanoid~=nil and theirHumanoid.Health<=0))
end
local reset=false
if ok then
local deadline=os.clock()+0.6
reset=gone()
while not reset and os.clock()<deadline and target.Parent==Players do task.wait(0.05);reset=gone() end
end
if reset then everyone.Flung(target,whitelisted,wasInRound) end
return ok,reset
end
runtime.ResetPlayer={Reset=resetPlayer,GetState=function()
return {resetting=state.resetting,resets=state.resets,bindTarget=state.bindTarget and state.bindTarget.Name}
end}
local controls={}
local function toggle(name,key,callback)
local controller=addToggle(section,name,C(key,false),function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
local function slider(name,key,min,max,field)
section:AddSlider(name,min,max,settings[field],function(value)
settings[field]=math.clamp(tonumber(value) or settings[field],min,max)
SetCfg(key,settings[field])
end)
end
local function startLoop(key,body)
local token={}
loops[key]=token
task.spawn(function()
while loops[key]==token and alive and runtimeAlive do
local ok,problem=pcall(body,function() return loops[key]==token and alive and runtimeAlive end)
if not ok then warn("[World V2] Reset Player: "..tostring(problem));task.wait(1) end
end
end)
end
local function stopLoop(key) loops[key]=nil end
local function noneFound(name)
if name=="Sheriff" and roles and roles.IsMine("Sheriff") then notify("Reset Player: you are the sheriff",0)
elseif name=="Murderer" and roles and roles.IsMine("Murderer") then notify("Reset Player: you are the murderer",0)
elseif name=="Player" then notify("Reset Player: pick a player in Select Bind Button Player first",0)
else notify("Reset Player: no "..name:lower().." found this round",0) end
end
local function sheriff() return roles and roles.Sheriff(whitelisted) end
local function murderer() return roles and roles.Murderer(whitelisted) end
local function bindTarget() return present(state.bindTarget) and state.bindTarget or nil end
if inMurderMystery then
section:AddButton("Reset Sheriff",function()
task.spawn(function() local target=sheriff();if target then resetPlayer(target) else noneFound("Sheriff") end end)
end)
section:AddButton("Reset Murderer",function()
task.spawn(function() local target=murderer();if target then resetPlayer(target) else noneFound("Murderer") end end)
end)
end
local resettingAll=false
section:AddButton("Reset All",function()
if resettingAll then return end
resettingAll=true
task.spawn(function()
local pass=everyone.Pass()
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and not whitelisted(plr) then
local _,reset=resetPlayer(plr)
pass.Result(reset)
task.wait(0.1)
end
end
pass.Close()
resettingAll=false
end)
end)
section:AddPlayerDropdown("Reset Player",function(value)
local plr=playerOf(value)
if present(plr) then task.spawn(resetPlayer,plr) end
end)
section:AddPlayerDropdown("Select Bind Button Player",function(value)
local plr=playerOf(value)
state.bindTarget=present(plr) and plr or nil
if state.bindTarget then notify("Reset Player: the RP button now resets "..state.bindTarget.DisplayName,2) end
end)
section:AddPlayerDropdown("Select Players",function(value)
local plr=playerOf(value)
if not present(plr) then return end
for _,selected in ipairs(state.selected) do if selected==plr then return end end
state.selected[#state.selected+1]=plr
notify("Reset Player: "..plr.DisplayName.." added to the reset list",2)
end)
section:AddButton("Clear Selected Players",function()
table.clear(state.selected)
notify("Reset Player: selected players cleared",2)
end)
toggle("Loop Reset Player(s)","w2ResetLoopPlayers",function(value)
if not value then stopLoop("players");return end
startLoop("players",function(running)
for _,plr in ipairs(table.clone(state.selected)) do
if not running() then return end
if present(plr) and not whitelisted(plr) then resetPlayer(plr);task.wait(0.2) end
end
task.wait(math.max(settings.loopDelay,0.1))
end)
end)
slider("Reset Player Duration","w2ResetDuration",0.1,5,"duration")
slider("Reset Start Studs","w2ResetStartStuds",-5,20,"startStuds")
slider("Loop Reset Delay","w2ResetLoopDelay",0,10,"loopDelay")
for _,auto in ipairs(inMurderMystery and {{name="Sheriff",find=sheriff},{name="Murderer",find=murderer}} or {}) do
local done={}
toggle("Auto Reset "..auto.name,"w2ResetAuto"..auto.name,function(value)
table.clear(done)
if not value then stopLoop("auto"..auto.name);return end
startLoop("auto"..auto.name,function(running)
task.wait(1)
local target=running() and auto.find()
local character=target and target.Character
if character and done[target]~=character then
resetPlayer(target)
done[target]=character
task.wait(3)
end
end)
end)
end
local confirm={on=C("w2ResetDoubleTap",false)==true,asked={}}
local CONFIRM_TIME=3
local function confirmed(spec)
if not confirm.on then return true end
local now=os.clock()
local asked=confirm.asked[spec.id]
if asked and now-asked<=CONFIRM_TIME then confirm.asked[spec.id]=nil;return true end
confirm.asked[spec.id]=now
local target=spec.find()
local who=spec.name=="Player" and (target and target.DisplayName or "your bind button player") or ("the "..spec.name:lower())
notify("Reset Player: tap "..spec.text.." again within 3 seconds to reset "..who,0)
return false
end
local BUTTONS={
{id="WorldV2_ResetSheriff",text="RS",name="Sheriff",key="w2ResetRS",find=sheriff,default=UDim2.new(0.10,0,0.66,0)},
{id="WorldV2_ResetMurderer",text="RM",name="Murderer",key="w2ResetRM",find=murderer,default=UDim2.new(0.16,0,0.66,0)},
{id="WorldV2_ResetPlayer",text="RP",name="Player",key="w2ResetRP",find=bindTarget,default=UDim2.new(0.22,0,0.66,0)},
}
if not inMurderMystery then table.remove(BUTTONS,1);table.remove(BUTTONS,1) end
local function bindSize(id,size)
local b=BindableButtons.Buttons[id]
if not b then return end
local camera=workspace.CurrentCamera
local screen=camera and camera.ViewportSize or Vector2.new(1920,1080)
if screen.X<=1 or screen.Y<=1 then screen=Vector2.new(1920,1080) end
b.Size=UDim2.new(size*(screen.Y/screen.X),0,size,0)
end
for _,spec in ipairs(BUTTONS) do
local size=math.clamp(tonumber(C(spec.key.."Size",11)) or 11,5,25)/100
local function press()
if not confirmed(spec) then
pcall(function() BindableButtons:SetValue(spec.id,false,false) end)
return
end
task.spawn(function()
local target=spec.find()
if target then
if whitelisted(target) then notify("Reset Player: "..target.DisplayName.." is whitelisted, so not reset",0)
else resetPlayer(target) end
else
noneFound(spec.name)
end
pcall(function() BindableButtons:SetValue(spec.id,false,false) end)
end)
end
local function create()
BindableButtons.AddBButton(spec.id,spec.text,press,function() end,function(position)
saveStoredPosition(spec.key.."ButtonPosition",position)
end)
BindableButtons:SetPosition(spec.id,loadStoredPosition(spec.key.."ButtonPosition",spec.default))
BindableButtons:SetLocked(spec.id,lockBindButtonPos)
bindSize(spec.id,size)
end
toggle("Enable "..spec.text.." Button",spec.key.."Enabled",function(value)
if value then create() else BindableButtons:DeleteBButton(spec.id) end
end)
section:AddSlider(spec.name.." Reset Button Size",5,25,size*100,function(value)
size=math.clamp(tonumber(value) or 11,5,25)/100
SetCfg(spec.key.."Size",size*100)
bindSize(spec.id,size)
end)
section:AddButton("Reset "..spec.text.." Button Position",function()
saveStoredPosition(spec.key.."ButtonPosition",spec.default)
BindableButtons:SetPosition(spec.id,spec.default)
end)
end
-- (keybinds: one press resets once, like the RS, RM and RP buttons, whitelist included; Player is your
-- Select Bind Button Player, the same one RP resets)
local KEY_DEFAULTS={Murderer="J",Sheriff="U",Player="Y"}
local keysOn=C("w2ResetKeybindsEnabled",false)==true
toggle("Enable Reset Keybinds","w2ResetKeybindsEnabled",function(value) keysOn=value end)
for _,spec in ipairs(BUTTONS) do
section:AddKeybind("Reset "..spec.name.." Keybind",KEY_DEFAULTS[spec.name] or "Y",function()
if not (keysOn and runtimeAlive) then return end
task.spawn(function()
local target=spec.find()
if target then
if whitelisted(target) then notify("Reset Player: "..target.DisplayName.." is whitelisted, so not reset",0)
else resetPlayer(target) end
else
noneFound(spec.name)
end
end)
end)
end
toggle("Loop Reset All","w2ResetLoopAll",function(value)
if not value then stopLoop("all");return end
local pass=everyone.Pass()
startLoop("all",function(running)
for _,plr in ipairs(Players:GetPlayers()) do
if not running() then return end
if plr~=LocalPlayer and not whitelisted(plr) then
local _,reset=resetPlayer(plr)
if pass then pass.Result(reset) end
task.wait(0.2)
end
end
if pass and running() then pass.Close();pass=nil end
task.wait(math.max(settings.loopDelay,0.1))
end)
end)
local function pointedPlayer(position)
local camera=workspace.CurrentCamera
local params=RaycastParams.new()
params.FilterType=Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances={LocalPlayer.Character or workspace.Terrain}
local hit
pcall(function()
local ray=camera:ScreenPointToRay(position.X,position.Y)
local result=workspace:Raycast(ray.Origin,ray.Direction*1000,params)
hit=result and result.Instance
end)
if not hit then pcall(function() hit=LocalPlayer:GetMouse().Target end) end
local model=hit and hit:FindFirstAncestorWhichIsA("Model")
return model and Players:GetPlayerFromCharacter(model) or nil
end
toggle("Click Reset","w2ResetClick",function(value)
for _,connection in ipairs(clickConnections) do connection:Disconnect() end
table.clear(clickConnections)
if not value then return end
clickConnections[1]=UserInputService.InputBegan:Connect(function(input,processed)
if processed or not runtimeAlive then return end
if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
local plr=pointedPlayer(input.Position)
if present(plr) and not whitelisted(plr) then task.spawn(resetPlayer,plr) end
end)
end)
toggle("Reset Aura","w2ResetAura",function(value)
if not value then stopLoop("aura");return end
startLoop("aura",function(running)
task.wait(0.5)
local character=LocalPlayer.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
if not root then return end
for _,plr in ipairs(Players:GetPlayers()) do
if not running() then return end
if plr~=LocalPlayer and not whitelisted(plr) then
local theirRoot=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
if theirRoot and root.Parent and (root.Position-theirRoot.Position).Magnitude<=settings.auraStuds then resetPlayer(plr) end
end
end
end)
end)
slider("Reset Aura Studs","w2ResetAuraStuds",5,50,"auraStuds")
toggle("Double tap to confirm","w2ResetDoubleTap",function(value) confirm.on=value;table.clear(confirm.asked) end)
runtime.RegisterReset(function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
table.clear(loops);table.clear(state.selected)
for _,connection in ipairs(clickConnections) do connection:Disconnect() end
table.clear(clickConnections)
for _,spec in ipairs(BUTTONS) do BindableButtons:DeleteBButton(spec.id) end
state.bindTarget=nil
settings.duration,settings.startStuds,settings.loopDelay,settings.auraStuds=1,5,1,15
if not runtimeAlive then alive=false end
end)
end,"Section \"W2 Reset Player\"")
;w2Section(function()
if not inMurderMystery then return end
local runtime=env.WorldV2Runtime
local section=mainTab:AddSection("Vote Map","Utilities")
local BIND_ID="WorldV2_VoteMap"
local BIND_DEFAULT=UDim2.new(0.28,0,0.66,0)
local alive=true
local settings={
votes=math.clamp(math.floor(tonumber(C("w2VoteMapVotes",12)) or 12),1,20),
byServer=C("w2VoteMapByServer",false)==true,
size=math.clamp(tonumber(C("w2VoteMapButtonSize",11)) or 11,5,25)/100,
keyOn=C("w2VoteMapKeybindEnabled",false)==true,
}
local state={voting=false,stopping=false,run=0,cast=0,lastTotal=0,lastError=nil,bind=false}
local function notify(text,kind) pcall(shared.Notify,"Vote Map: "..text,kind or 3) end
local function pingSeconds()
local ok,value=pcall(function() return LocalPlayer:GetNetworkPing() end)
return ok and tonumber(value) or 0.1
end
local function wanted()
if settings.byServer then return math.clamp(math.floor(#Players:GetPlayers()/2)+2,1,20) end
return settings.votes
end
local function holdTime() return math.clamp(0.12+pingSeconds()*1.5,0.18,0.5) end
local function aliveCharacter()
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local root=character and character:FindFirstChild("HumanoidRootPart")
if humanoid and root and humanoid.Health>0 then return character,humanoid,root end
end
local function setLit(value)
if state.bind then pcall(function() BindableButtons:SetValue(BIND_ID,value,false) end) end
end
local function padAt(position)
local lobby=workspace:FindFirstChild("Lobby")
local folder=lobby and lobby:FindFirstChild("VotePads")
if not folder then return nil end
for _,pad in ipairs(folder:GetChildren()) do
local trigger=pad:FindFirstChild("Pad")
if trigger and trigger:IsA("BasePart") then
local inPad=trigger.CFrame:PointToObjectSpace(position)
local half=trigger.Size*0.5
if math.abs(inPad.X)<=half.X+1 and math.abs(inPad.Y)<=half.Y+4 and math.abs(inPad.Z)<=half.Z+1 then return trigger end
end
end
end
local function touchPad(root,trigger)
if not trigger then return end
pcall(function() firetouchinterest(root,trigger,0);firetouchinterest(root,trigger,1) end)
end
local function hold(root,spot,duration,run)
local function put()
if root.Parent then
root.CFrame=spot
root.AssemblyLinearVelocity=Vector3.zero
root.AssemblyAngularVelocity=Vector3.zero
end
end
put()
local found,trigger=pcall(padAt,spot.Position)
if not found then trigger=nil end
touchPad(root,trigger)
local stepped=RunService.Stepped:Connect(put)
local frame=RunService.Heartbeat:Connect(put)
local deadline=os.clock()+duration
local touchedAgain=false
while os.clock()<deadline and root.Parent and state.run==run do
task.wait()
if not touchedAgain and os.clock()>deadline-duration/2 then touchedAgain=true;touchPad(root,trigger) end
end
stepped:Disconnect();frame:Disconnect()
end
local function stop()
if state.voting then state.stopping=true end
end
local function abort()
if not state.voting then return end
state.voting,state.stopping=false,false
state.run=state.run+1
setLit(false)
end
local function vote()
if state.voting then stop();return end
local character,humanoid,root=aliveCharacter()
if not root then notify("your character isn't loaded",0);setLit(false);return end
state.voting,state.stopping=true,false
state.run=state.run+1
local run=state.run
local spot=root.CFrame
local displayedTotal=wanted()
local total=displayedTotal+1
state.cast=0;state.lastTotal=total;state.lastError=nil
setLit(true)
notify(("voting %d times..."):format(displayedTotal),3)
local nextCharacter=nil
local added=LocalPlayer.CharacterAdded:Connect(function(new) nextCharacter=new end)
local ok,problem=pcall(function()
while state.run==run and alive and runtimeAlive do
hold(root,spot,holdTime(),run)
if state.run~=run then return end
state.cast=state.cast+1
if state.cast>=total or state.stopping then return end
nextCharacter=nil
pcall(function() humanoid.Health=0 end)
local deadline=os.clock()+8
while not nextCharacter and os.clock()<deadline and state.run==run do task.wait() end
if state.run~=run then return end
if not nextCharacter then state.lastError="you didn't respawn";return end
character=nextCharacter
root=character:WaitForChild("HumanoidRootPart",5)
humanoid=character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid",5)
if not root or not humanoid then state.lastError="your new character didn't load";return end
end
end)
added:Disconnect()
if not ok then state.lastError=tostring(problem) end
if state.run~=run then return end
local stopped=state.stopping
state.voting,state.stopping=false,false
setLit(false)
local displayedCast=math.min(state.cast,displayedTotal)
if state.lastError then notify(("stopped after %d of %d votes: %s"):format(displayedCast,displayedTotal,state.lastError),1)
elseif stopped then notify(("stopped after %d of %d votes"):format(displayedCast,displayedTotal),0)
else notify(("done: %d votes cast"):format(displayedTotal),2) end
end
local controls={}
local function toggle(name,key,callback)
local controller=addToggle(section,name,C(key,false),function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
section:AddSlider("Votes Amount",1,20,settings.votes,function(value)
settings.votes=math.clamp(math.floor(tonumber(value) or 12),1,20)
SetCfg("w2VoteMapVotes",settings.votes)
end)
toggle("Vote Amount Based Off Server Count","w2VoteMapByServer",function(value)
settings.byServer=value
end)
local function bindSize()
local b=BindableButtons.Buttons[BIND_ID]
if not b then return end
local camera=workspace.CurrentCamera
local screen=camera and camera.ViewportSize or Vector2.new(1920,1080)
if screen.X<=1 or screen.Y<=1 then screen=Vector2.new(1920,1080) end
b.Size=UDim2.new(settings.size*(screen.Y/screen.X),0,settings.size,0)
end
-- (with Double tap to confirm on, the VM button only votes when it's tapped twice within 3 seconds)
local confirm={on=C("w2VoteMapDoubleTap",false)==true,askedAt=-math.huge}
local CONFIRM_TIME=3
local function confirmed()
if not confirm.on then return true end
local now=os.clock()
if now-confirm.askedAt<=CONFIRM_TIME then confirm.askedAt=-math.huge;return true end
confirm.askedAt=now
notify("tap VM again within 3 seconds to vote",0)
return false
end
local function createBind()
BindableButtons.AddBButton(BIND_ID,"VM",function()
if state.voting then return end
if not confirmed() then
pcall(function() BindableButtons:SetValue(BIND_ID,false,false) end)
return
end
task.spawn(vote)
end,function()
stop()
end,function(position)
saveStoredPosition("w2VoteMapButtonPosition",position)
end)
BindableButtons:SetPosition(BIND_ID,loadStoredPosition("w2VoteMapButtonPosition",BIND_DEFAULT))
BindableButtons:SetLocked(BIND_ID,lockBindButtonPos)
bindSize()
setLit(state.voting)
end
toggle("W2 Enable VM Button","w2VoteMapButtonEnabled",function(value)
state.bind=value
if value then createBind() else BindableButtons:DeleteBButton(BIND_ID) end
end)
toggle("Double tap to confirm","w2VoteMapDoubleTap",function(value) confirm.on=value;confirm.askedAt=-math.huge end)
section:AddSlider("W2 VM Button Size",5,25,settings.size*100,function(value)
settings.size=math.clamp(tonumber(value) or 11,5,25)/100
SetCfg("w2VoteMapButtonSize",settings.size*100)
bindSize()
end)
section:AddButton("Reset VM Button Position",function()
saveStoredPosition("w2VoteMapButtonPosition",BIND_DEFAULT)
BindableButtons:SetPosition(BIND_ID,BIND_DEFAULT)
end)
toggle("Enable Vote Map Keybind","w2VoteMapKeybindEnabled",function(value) settings.keyOn=value end)
section:AddKeybind("Vote Map Keybind","V",function()
if alive and runtimeAlive and settings.keyOn then task.spawn(vote) end
end)
runtime.RegisterReset(function()
abort()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
BindableButtons:DeleteBButton(BIND_ID)
state.bind=false
settings.votes,settings.byServer,settings.size,settings.keyOn=12,false,0.11,false
if not runtimeAlive then alive=false end
end)
end,"Section \"W2 Vote Map\"")
;w2Section(function()
local isMMV=game.GameId==10413186812 or game.GameId==10769671266 or game.PlaceId==93017634738276
or game.PlaceId==81374640397860 or (type(shared)=="table" and shared.game_name=="Murder Mystery Modded")
if not isMMV then return end
local runtime=env.WorldV2Runtime
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local section=mainTab:AddSection("W2 Auto Commands","Utilities")
-- (the original four, then every map from Auto Vote Smallest Map, written the way /map takes them: no
-- spaces or apostrophes; one already listed isn't added twice)
local MAPS={"Milbase","IceCastle","Factory","Farm"}
do
local have={}
for _,name in ipairs(MAPS) do have[name:lower()]=true end
for _,name in ipairs({"Manor","House 2","Office 3","Hospital 3","Bank 2","Vampire's Castle","Mansion 2","WorkPlace",
"Hotel 2","Farm House","Police Station","Factory","Bio Lab","Research Facility","Mil Base"}) do
local command=name:gsub("[%s']","")
if not have[command:lower()] then have[command:lower()]=true;MAPS[#MAPS+1]=command end
end
end
local NONE="None"
local settings={
delay=math.clamp(tonumber(C("w2AutoCommandsDelay",2)) or 2,0.3,5),
map=tostring(C("w2AutoCommandsMap","")),
sheriff=tostring(C("w2AutoCommandsSheriff","")),
murderer=tostring(C("w2AutoCommandsMurderer","")),
}
local loops={}
local alive=true
local function sendChatCommand(command)
pcall(function()
if TextChatService.ChatVersion==Enum.ChatVersion.TextChatService then
local channels=TextChatService:FindFirstChild("TextChannels")
local channel=channels and channels:FindFirstChild("RBXGeneral")
if channel then channel:SendAsync(command) end
else
local events=ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
local request=events and events:FindFirstChild("SayMessageRequest")
if request then request:FireServer(command,"All") end
end
end)
end
local WORDS={"intermission","voting","victory","defeat","game over","koniec","remis"}
local lastLook,lastAnswer=-math.huge,false
local function roundOverOrLobby()
if os.clock()-lastLook<1 then return lastAnswer end
lastLook=os.clock()
local ok,result=pcall(function()
local playerGui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
if not playerGui then return false end
for _,gui in ipairs(playerGui:GetDescendants()) do
if gui:IsA("TextLabel") or gui:IsA("TextButton") then
local text=string.lower(gui.Text)
for _,word in ipairs(WORDS) do
if text:find(word,1,true) then return true end
end
end
end
return false
end)
lastAnswer=ok and result==true
return lastAnswer
end
local function startLoop(key,command,target)
local token={}
loops[key]=token
task.spawn(function()
local sentThisRound=false
while loops[key]==token and alive and runtimeAlive do
if not sentThisRound or roundOverOrLobby() then
local name=target()
if name~="" then
sendChatCommand(command.." "..name)
sentThisRound=true
end
end
task.wait(settings.delay)
end
end)
end
local function stopLoop(key) loops[key]=nil end
local controls={}
local function toggle(name,key,callback)
local controller=addToggle(section,name,C(key,false),function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
local function usernames()
local list={NONE}
for _,plr in ipairs(Players:GetPlayers()) do list[#list+1]=plr.Name end
return list
end
section:AddSlider("W2 Command Delay (seconds)",0.3,5,settings.delay,function(value)
settings.delay=math.clamp(math.floor((tonumber(value) or 2)*10+0.5)/10,0.3,5)
SetCfg("w2AutoCommandsDelay",settings.delay)
end)
addDropdown(section,"W2 Select Update Map",MAPS,table.find(MAPS,settings.map) and settings.map or nil,function(value)
if not table.find(MAPS,value) then return false end
settings.map=value
SetCfg("w2AutoCommandsMap",value)
end)
section:AddTextBox("W2 OR Custom Map Name",function(text)
settings.map=tostring(text or "")
SetCfg("w2AutoCommandsMap",settings.map)
end)
toggle("W2 Auto Send /map (Every Round)","w2AutoCommandsMapOn",function(value)
if value then startLoop("map","/map",function() return settings.map end) else stopLoop("map") end
end)
local sheriffDropdown=addDropdown(section,"W2 Select Sheriff",usernames(),settings.sheriff~="" and settings.sheriff or NONE,function(value)
settings.sheriff=(value==nil or value==NONE) and "" or tostring(value)
SetCfg("w2AutoCommandsSheriff",settings.sheriff)
end,false)
toggle("W2 Auto Send /sheriff (Every Round)","w2AutoCommandsSheriffOn",function(value)
if value then startLoop("sheriff","/sheriff",function() return settings.sheriff end) else stopLoop("sheriff") end
end)
local murdererDropdown=addDropdown(section,"W2 Select Murderer",usernames(),settings.murderer~="" and settings.murderer or NONE,function(value)
settings.murderer=(value==nil or value==NONE) and "" or tostring(value)
SetCfg("w2AutoCommandsMurderer",settings.murderer)
end,false)
toggle("W2 Auto Send /murderer (Every Round)","w2AutoCommandsMurdererOn",function(value)
if value then startLoop("murderer","/murderer",function() return settings.murderer end) else stopLoop("murderer") end
end)
local function refreshList(dropdown,picked)
if type(dropdown)~="table" then return end
local list=usernames()
if picked~="" and not table.find(list,picked) then list[#list+1]=picked end
if type(dropdown.ChangeItems)=="function" then pcall(dropdown.ChangeItems,list)
elseif type(dropdown.Change)=="function" then pcall(dropdown.Change,list) end
if type(dropdown.Select)=="function" then pcall(dropdown.Select,picked~="" and picked or NONE) end
end
section:AddButton("W2 Refresh Usernames",function()
refreshList(sheriffDropdown,settings.sheriff)
refreshList(murdererDropdown,settings.murderer)
pcall(shared.Notify,("W2 Auto Commands: usernames refreshed (%d in the server)"):format(#Players:GetPlayers()),2)
end)
runtime.RegisterReset(function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
table.clear(loops)
settings.delay,settings.map,settings.sheriff,settings.murderer=2,"","",""
if not runtimeAlive then alive=false end
end)
end,"Section \"W2 Auto Commands\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local runtime=env.WorldV2Runtime
local section=mainTab:AddSection("Auto Strafe","Utilities")
local BIND_ID="WorldV2_AutoStrafe"
local BIND_DEFAULT=UDim2.new(0.34,0,0.66,0)
local settings={
speed=math.clamp(tonumber(C("w2StrafeSpeed",25)) or 25,1,100),
distance=math.clamp(tonumber(C("w2StrafeDistance",6)) or 6,1,30),
size=math.clamp(tonumber(C("w2StrafeButtonSize",11)) or 11,5,25)/100,
keyOn=C("w2StrafeKeybindEnabled",false)==true,
}
local state={on=false,side=1,travelled=0,connection=nil,bind=false,strafing=false}
local function notify(text,kind) pcall(shared.Notify,text,kind or 3) end
local function restart() state.side,state.travelled,state.strafing=1,settings.distance/2,false end
local strafeRayParams=RaycastParams.new()
strafeRayParams.FilterType=Enum.RaycastFilterType.Exclude
local strafeRayCharacter=nil
local function step(dt)
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local root=character and character:FindFirstChild("HumanoidRootPart")
state.strafing=false
-- (works on the ground and in the air alike)
if not humanoid or not root or humanoid.Health<=0 or humanoid.Sit then return end
local walk=humanoid.MoveDirection
walk=Vector3.new(walk.X,0,walk.Z)
local moving=walk.Magnitude>0.1
local forward=moving and walk or Vector3.new(root.CFrame.LookVector.X,0,root.CFrame.LookVector.Z)
if forward.Magnitude<0.01 then return end
forward=forward.Unit
local right=Vector3.new(-forward.Z,0,forward.X)
local move=math.min(settings.speed*dt,settings.distance)
local way=right*state.side
if strafeRayCharacter~=character then
strafeRayCharacter=character
strafeRayParams.FilterDescendantsInstances={character}
end
if workspace:Raycast(root.Position,way*(move+1.2),strafeRayParams) then
state.side=-state.side;state.travelled=0
return
end
root.CFrame=root.CFrame+way*move
state.strafing=true
state.travelled=state.travelled+move
if state.travelled>=settings.distance then state.side=-state.side;state.travelled=0 end
end
local strafeToggle
local function apply(value)
state.on=value
if state.connection then state.connection:Disconnect();state.connection=nil end
if not value then
strafeRayCharacter=nil
strafeRayParams.FilterDescendantsInstances={}
end
restart()
if value then
state.connection=RunService.Heartbeat:Connect(function(dt)
if runtimeAlive then pcall(step,math.min(tonumber(dt) or 0,0.1)) end
end)
end
if state.bind then pcall(function() BindableButtons:SetValue(BIND_ID,value,false) end) end
end
local function setOn(value)
if strafeToggle then strafeToggle:Set(value) else apply(value) end
end
local controls={}
local function toggle(name,key,callback)
local controller=addToggle(section,name,C(key,false),function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
strafeToggle=toggle("Enable Auto Strafe","w2StrafeEnabled",apply)
section:AddSlider("Strafe Speed",1,100,settings.speed,function(value)
settings.speed=math.clamp(tonumber(value) or 25,1,100)
SetCfg("w2StrafeSpeed",settings.speed)
end)
section:AddSlider("Strafe Distance",1,30,settings.distance,function(value)
settings.distance=math.clamp(tonumber(value) or 6,1,30)
SetCfg("w2StrafeDistance",settings.distance)
state.travelled=math.min(state.travelled,settings.distance)
end)
toggle("Enable Auto Strafe Keybind","w2StrafeKeybindEnabled",function(value) settings.keyOn=value end)
section:AddKeybind("Auto Strafe Keybind","X",function()
if not runtimeAlive or not settings.keyOn then return end
setOn(not state.on)
notify("Auto Strafe "..(state.on and "on" or "off"),state.on and 2 or 3)
end)
local function bindSize()
local b=BindableButtons.Buttons[BIND_ID]
if not b then return end
local camera=workspace.CurrentCamera
local screen=camera and camera.ViewportSize or Vector2.new(1920,1080)
if screen.X<=1 or screen.Y<=1 then screen=Vector2.new(1920,1080) end
b.Size=UDim2.new(settings.size*(screen.Y/screen.X),0,settings.size,0)
end
local function createBind()
BindableButtons.AddBButton(BIND_ID,"AS",function() setOn(true) end,function() setOn(false) end,function(position)
saveStoredPosition("w2StrafeButtonPosition",position)
end)
BindableButtons:SetPosition(BIND_ID,loadStoredPosition("w2StrafeButtonPosition",BIND_DEFAULT))
BindableButtons:SetLocked(BIND_ID,lockBindButtonPos)
bindSize()
pcall(function() BindableButtons:SetValue(BIND_ID,state.on,false) end)
end
toggle("Enable AS Button","w2StrafeButtonEnabled",function(value)
state.bind=value
if value then createBind() else BindableButtons:DeleteBButton(BIND_ID) end
end)
section:AddSlider("AS Button Size",5,25,settings.size*100,function(value)
settings.size=math.clamp(tonumber(value) or 11,5,25)/100
SetCfg("w2StrafeButtonSize",settings.size*100)
bindSize()
end)
section:AddButton("Reset AS Button Position",function()
saveStoredPosition("w2StrafeButtonPosition",BIND_DEFAULT)
BindableButtons:SetPosition(BIND_ID,BIND_DEFAULT)
end)
runtime.RegisterReset(function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
apply(false)
BindableButtons:DeleteBButton(BIND_ID)
state.bind=false
settings.speed,settings.distance,settings.size,settings.keyOn=25,6,0.11,false
end)
end,"Section \"W2 Auto Strafe\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local runtime=env.WorldV2Runtime
local section=mainTab:AddSection("Auto Draw/Throw Knife","Utilities")
local RELOAD=0.85
local THROW_ANIMATIONS={["1957618848"]=true,["15478370930"]=true}
local DRAW_BIND_ID="WorldV2_AutoDraw"
local DRAW_BIND_DEFAULT=UDim2.new(0.44,0,0.78,0)
local BIND_ID="WorldV2_AutoThrow"
local BIND_DEFAULT=UDim2.new(0.52,0,0.78,0)
local settings={keyOn=C("w2AutoThrowKeybindEnabled",false)==true,
toggleKeyOn=C("w2AutoThrowToggleKeybindEnabled",false)==true,
drawSize=math.clamp(tonumber(C("w2AutoDrawButtonSize",11)) or 11,5,25)/100,
size=math.clamp(tonumber(C("w2AutoThrowButtonSize",11)) or 11,5,25)/100,
autoTap=C("w2AutoThrowAutoTap",false)==true,
range=math.clamp(tonumber(C("w2AutoThrowAutoTapRange",40)) or 40,5,200),
wallCheck=C("w2AutoThrowWallCheck",false)==true,
stab=C("w2AutoStabEnabled",false)==true,
stabRange=math.clamp(tonumber(C("w2AutoStabRange",7)) or 7,2,15)}
local state={stabAt=0,on=false,knife=nil,holding=nil,inHand=false,readyAt=0,raiseAt=0,tries=0,noRaise=false,
gaveUp=false,run=0,throws=0,raises=0,button=nil,scannedAt=-math.huge,lastInput=nil,connections={}}
local ContextActionService=game:GetService("ContextActionService")
local function notify(text,kind) pcall(shared.Notify,text,kind or 3) end
local function myKnife()
local character=LocalPlayer.Character
local backpack=LocalPlayer:FindFirstChildOfClass("Backpack")
local skins=runtime.ClientWeaponSkins
for _,container in ipairs({character or false,backpack or false}) do
if container then
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and (tool.Name=="Knife" or tool:GetAttribute("IsKnife")==true
or (skins and type(skins.GetKind)=="function" and skins.GetKind(tool)=="Knife")) then
return tool,container==character
end
end
end
end
end
local function animationNumber(id) return type(id)=="string" and id:match("(%d+)%s*$") or nil end
local ourTracks=setmetatable({},{__mode="k"})
local knifeIds=setmetatable({},{__mode="k"})
local function raised(character,knife)
local ids=knifeIds[knife]
if not ids then
ids=table.clone(THROW_ANIMATIONS)
for _,item in ipairs(knife:GetDescendants()) do
if item:IsA("Animation") then
local name=item.Name:lower()
local number=animationNumber(item.AnimationId)
-- (the knife's own ThrowCharge and ThrowHold, by name: MM2 and MMV name them the same, with their own IDs)
if number and (name:find("throwcharge",1,true) or name:find("throwhold",1,true)) then ids[number]=true end
end
end
knifeIds[knife]=ids
end
local humanoid=character:FindFirstChildOfClass("Humanoid")
local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")
for _,owner in ipairs({animator or false,humanoid or false}) do
if owner then
local ok,tracks=pcall(function() return owner:GetPlayingAnimationTracks() end)
if ok and type(tracks)=="table" then
for _,track in ipairs(tracks) do
if not ourTracks[track] then
local name,number="",nil
pcall(function() name=tostring(track.Name):lower() end)
pcall(function() number=track.Animation and animationNumber(track.Animation.AnimationId) end)
if name:find("throwcharge",1,true) or name:find("throwhold",1,true) or (number and ids[number]) then return true end
end
end
end
end
end
return false
end
local function throwAction()
local ok,actions=pcall(function() return ContextActionService:GetAllBoundActionInfo() end)
if not ok or type(actions)~="table" then return nil end
for name in pairs(actions) do
if type(name)=="string" and name:lower():find("throw",1,true) then return name end
end
return nil
end
local function saysThrow(item)
if item.Name:lower():find("throw",1,true) then return true end
local ok,text=pcall(function() return item.Text end)
return ok and type(text)=="string" and text:lower():find("throw",1,true)~=nil
end
local function throwButton()
local gui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
if not gui then return nil end
local button=state.button
if button and button.Parent and button:IsDescendantOf(gui) then return button end
if os.clock()-state.scannedAt<3 then return nil end
state.scannedAt=os.clock()
state.button=nil
for _,item in ipairs(gui:GetDescendants()) do
if item:IsA("GuiButton") and saysThrow(item) then state.button=item;break end
if item:IsA("TextLabel") and saysThrow(item) and item.Parent and item.Parent:IsA("GuiButton") then state.button=item.Parent;break end
end
return state.button
end
local function connected(signal)
if type(getconnections)~="function" then return nil end
local ok,list=pcall(getconnections,signal)
if ok and type(list)=="table" and #list>0 then return list end
return nil
end
local function runHandlers(list)
for _,connection in ipairs(list) do
pcall(function()
if connection.Fire then connection:Fire() else connection.Function() end
end)
end
end
-- (drawing only presses and holds the game's throw control, which keeps the knife up; letting go
-- of it is what throws, so that's only done by a throw, and putting the knife away cancels instead)
local function raise()
local action=throwAction()
if action then
local input=state.lastInput
if pcall(function() ContextActionService:CallFunction(action,Enum.UserInputState.Begin,input) end) then
state.casHold={action=action,input=input}
return true
end
end
local button=throwButton()
local down=button and connected(button.MouseButton1Down)
if down then
runHandlers(down)
state.buttonHeld=button
return true
end
return false
end
local function letGoOfHold(throwIt)
local hold,button=state.casHold,state.buttonHeld
state.casHold,state.buttonHeld=nil,nil
if hold then
pcall(function() ContextActionService:CallFunction(hold.action,throwIt and Enum.UserInputState.End or Enum.UserInputState.Cancel,hold.input) end)
end
if button and throwIt then
for _,name in ipairs({"MouseButton1Up","Activated","MouseButton1Click"}) do
local list=connected(button[name])
if list then runHandlers(list);break end
end
end
return hold~=nil or (button~=nil and throwIt)
end
local wallParams=RaycastParams.new()
wallParams.FilterType=Enum.RaycastFilterType.Exclude
wallParams.IgnoreWater=true
local wallIgnore={}
local function throwOrigin(character)
local knife=state.knife
local handle=knife and knife.Parent==character and knife:FindFirstChild("Handle")
if handle and handle:IsA("BasePart") then return handle.Position end
local eye=character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
return eye and eye.Position
end
-- Wall check: walks the ray past other players and see-through/non-solid parts, fails on the first real wall.
local function clearPath(character,from,other,part)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
table.clear(wallIgnore)
wallIgnore[1]=character
local goal=part.Position
for _=1,8 do
wallParams.FilterDescendantsInstances=wallIgnore
local hit=workspace:Raycast(from,goal-from,wallParams)
if not hit then return true end
local blocker=hit.Instance
if blocker:IsDescendantOf(other) then return true end
local model=blocker:FindFirstAncestorOfClass("Model")
if model and Players:GetPlayerFromCharacter(model) then wallIgnore[#wallIgnore+1]=model
elseif not blocker.CanCollide or blocker.Transparency>=0.9 then wallIgnore[#wallIgnore+1]=blocker
else return false end
end
return false
end
local function clearShot(character,plr)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local other=plr and plr.Character
local root=other and other:FindFirstChild("HumanoidRootPart")
local from=character and throwOrigin(character)
if not root or not from then return false end
return clearPath(character,from,other,root)
end
local function spared(plr)
local list=runtime.Whitelist
return list~=nil and list.Has(plr)
end
local function aimTarget()
local camera=workspace.CurrentCamera
local character=LocalPlayer.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
if not root then return nil end
local look=(camera and camera.CFrame and camera.CFrame.LookVector) or root.CFrame.LookVector
local best,bestAngle=nil,math.rad(60)
for _,plr in ipairs(Players:GetPlayers()) do
local other=plr~=LocalPlayer and plr.Character
local otherRoot=other and other:FindFirstChild("HumanoidRootPart")
local humanoid=other and other:FindFirstChildOfClass("Humanoid")
if otherRoot and humanoid and humanoid.Health>0 and not spared(plr) then
local offset=otherRoot.Position-root.Position
if offset.Magnitude>0.1 and offset.Magnitude<=300 then
local angle=math.acos(math.clamp(look:Dot(offset.Unit),-1,1))
if angle<bestAngle and (not settings.wallCheck or clearShot(character,plr)) then best,bestAngle=plr,angle end
end
end
end
return best
end
local WINDUP_TIME=0.56
local loadedTracks=setmetatable({},{__mode="k"})
local function ownTrack(character,knife,name,fallback,priority)
local humanoid=character:FindFirstChildOfClass("Humanoid")
local animator=humanoid and (humanoid:FindFirstChildOfClass("Animator") or humanoid)
if not animator then return nil end
local id=fallback
for _,item in ipairs(knife:GetDescendants()) do
if item:IsA("Animation") and item.Name:lower():find(name,1,true) and item.AnimationId~="" then id=item.AnimationId;break end
end
local tracks=loadedTracks[animator] or {}
loadedTracks[animator]=tracks
if not tracks[id] then
local animation=Instance.new("Animation")
animation.AnimationId=id
local ok,track=pcall(function() return animator:LoadAnimation(animation) end)
if not ok or not track then return nil end
pcall(function() track.Priority=priority end)
ourTracks[track]=true
tracks[id]=track
end
return tracks[id]
end
local function windUp(character,knife)
local track=ownTrack(character,knife,"throwcharge","rbxassetid://1957618848",Enum.AnimationPriority.Action)
if track then pcall(function() track:Play(0.05,1,1) end) end
return track
end
local function unhookTaps()
for _,connection in ipairs(state.paused or {}) do pcall(function() connection:Enable() end) end
state.paused=nil
if state.tapConnection then state.tapConnection:Disconnect();state.tapConnection=nil end
state.tapKnife=nil
end
local throw
local function onTap()
if state.on then task.spawn(throw) end
end
local function hookTaps(knife)
if state.tapKnife==knife and os.clock()<(state.tapCheckAt or 0) then return end
if state.tapKnife~=knife then unhookTaps() end
state.tapKnife,state.tapCheckAt=knife,os.clock()+0.5
if type(getconnections)~="function" then return end
local ok,list=pcall(getconnections,knife.Activated)
if not ok or type(list)~="table" then return end
local fresh={}
for _,connection in ipairs(list) do
local mine=false
pcall(function() mine=connection.Function==onTap end)
if not mine and not table.find(state.paused or {},connection) then
if type(connection.Disable)~="function" or type(connection.Enable)~="function" then return end
fresh[#fresh+1]=connection
end
end
state.paused=state.paused or {}
for _,connection in ipairs(fresh) do
if pcall(function() connection:Disable() end) then state.paused[#state.paused+1]=connection end
end
if not state.tapConnection then state.tapConnection=knife.Activated:Connect(onTap) end
end
local function holdUp(character,knife)
hookTaps(knife)
if state.held then
local ok,playing=pcall(function() return state.held.IsPlaying end)
if ok and playing then return end
state.held=nil
end
if not state.charging then
local charge=windUp(character,knife)
if not charge then return end
state.charging,state.heldAt=charge,os.clock()+WINDUP_TIME
return
end
if os.clock()<state.heldAt then return end
local track=ownTrack(character,knife,"throwhold","rbxassetid://15478370930",Enum.AnimationPriority.Action2)
if not track then return end
pcall(function() track.Looped=true;track:Play(0.1) end)
local charge=state.charging
state.charging=nil
pcall(function() charge:Stop(0.1) end)
state.held=track
end
local function lowerHold()
local track,charge=state.held,state.charging
state.held,state.charging=nil,nil
if track then pcall(function() track:Stop(0.1) end) end
if charge then pcall(function() charge:Stop(0.1) end) end
end
local function putAway()
lowerHold()
unhookTaps()
end
throw=function(victim)
local character=LocalPlayer.Character
local knife=state.knife
if not knife or not character or knife.Parent~=character or os.clock()<state.readyAt then return false end
if settings.wallCheck then
victim=victim or aimTarget()
if not victim or not clearShot(character,victim) then return false end
end
-- (the knife is always seen fully drawn before it's thrown: a draw that's only just started, the game's
-- or Auto Draw's, is waited out first, so a throw never skips the draw)
if raised(character,knife) then
local since=state.upSince or os.clock()
local left=WINDUP_TIME-(os.clock()-since)
if left>0 then
state.winding=true
task.wait(left)
state.winding=false
if knife.Parent~=character then return false end
end
if not letGoOfHold(true) then
local ok=pcall(function() knife:Activate() end)
if not ok then return false end
end
else
local send=runtime.KnifeThrowAt
victim=victim or aimTarget()
local victimRoot=victim and victim.Character and victim.Character:FindFirstChild("HumanoidRootPart")
if type(send)~="function" or not victimRoot or state.winding then return false end
state.winding=true
local ok,done=pcall(function()
local track=nil
if state.held then lowerHold()
elseif state.charging then
local left=(state.heldAt or 0)-os.clock()
if left>0 then task.wait(left) end
lowerHold()
else track=windUp(character,knife) end
if track then task.wait(WINDUP_TIME) end
local function lower() if track then pcall(function() track:Stop(0.15) end) end end
if knife.Parent~=character or not (state.on or settings.autoTap or settings.keyOn) then lower();return false end
local sent,result=pcall(send,knife,victimRoot)
task.delay(0.1,lower)
return sent and result
end)
state.winding=false
if not ok or not done then return false end
end
state.holding=nil
state.throws=state.throws+1
state.readyAt=os.clock()+RELOAD
state.raiseAt=state.readyAt
return true
end
local function isSheriff(plr)
local roles=runtime.Roles
if not roles then return false end
local ok,yes=pcall(function()
if type(roles.Holds)=="function" and roles.Holds(plr,"Gun") then return true end
return type(roles.RoleOf)=="function" and roles.RoleOf(plr)=="Sheriff"
end)
return ok and yes==true
end
local function playerInSight(character)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local from=throwOrigin(character)
if not from then return nil end
local best,bestDistance,sheriff,sheriffDistance=nil,math.huge,nil,math.huge
for _,plr in ipairs(Players:GetPlayers()) do
local other=plr~=LocalPlayer and plr.Character
local root=other and other:FindFirstChild("HumanoidRootPart")
local humanoid=other and other:FindFirstChildOfClass("Humanoid")
if root and humanoid and humanoid.Health>0 and not spared(plr) then
local distance=(root.Position-from).Magnitude
if distance<=settings.range and (distance<bestDistance or (distance<sheriffDistance and isSheriff(plr))) then
if clearPath(character,from,other,root) then
if distance<bestDistance then best,bestDistance=plr,distance end
if distance<sheriffDistance and isSheriff(plr) then sheriff,sheriffDistance=plr,distance end
end
end
end
end
return sheriff or best
end
-- Auto Stab: with the knife in your hand and someone alive within Auto Stab Range, Auto Draw and Auto
-- Throw stand down (a knife raised by them is lowered, not thrown) and the knife is swung at them; once
-- nobody is that close, they pick up again. A knife you're holding up yourself isn't swung (that would
-- throw it). You're turned toward them smoothly, sideways only and no faster than a quick turn by hand,
-- and the swing comes once you're roughly facing them (or after 0.4 s anyway)
local STAB_GAP=0.5
local TURN_STEP=math.rad(22)
local FACING=math.rad(35)
local function turnToward(character,target)
local root=character:FindFirstChild("HumanoidRootPart")
local other=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
if not root or not other then return true end
local offset=other.Position-root.Position
if Vector3.new(offset.X,0,offset.Z).Magnitude<0.5 then return true end
local look=root.CFrame.LookVector
local current=math.atan2(-look.X,-look.Z)
local wanted=math.atan2(-offset.X,-offset.Z)
local diff=(wanted-current+math.pi)%(2*math.pi)-math.pi
if math.abs(diff)<=FACING then return true end
local step=math.clamp(diff,-TURN_STEP,TURN_STEP)
pcall(function() root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,current+step,0) end)
return math.abs(diff-step)<=FACING
end
local function closeBy(character)
local root=character:FindFirstChild("HumanoidRootPart")
if not root then return nil end
local best,bestDistance=nil,settings.stabRange
for _,plr in ipairs(Players:GetPlayers()) do
local other=plr~=LocalPlayer and plr.Character
local otherRoot=other and other:FindFirstChild("HumanoidRootPart")
local humanoid=other and other:FindFirstChildOfClass("Humanoid")
if otherRoot and humanoid and humanoid.Health>0 and not spared(plr) then
local distance=(otherRoot.Position-root.Position).Magnitude
if distance<=bestDistance then best,bestDistance=plr,distance end
end
end
return best
end
local function tick()
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local knife,inHand=myKnife()
if not knife or not humanoid or humanoid.Health<=0 then
putAway()
letGoOfHold(false)
state.knife,state.holding,state.inHand=nil,nil,false
else
if knife~=state.knife then putAway();letGoOfHold(false);state.knife,state.inHand=knife,false end
if not inHand then
putAway()
letGoOfHold(false)
state.holding,state.inHand=nil,false
else
if not state.inHand then
state.inHand,state.tries,state.noRaise,state.pressThrows=true,0,state.gaveUp,nil
state.raiseAt=math.max(state.raiseAt,os.clock()+0.2)
end
local near=settings.stab and not state.winding and closeBy(character)
if near then
local ours=state.held~=nil or state.charging~=nil or state.casHold~=nil or state.buttonHeld~=nil
putAway()
letGoOfHold(false)
state.holding=nil
state.raiseAt=math.max(state.raiseAt,os.clock()+0.4)
-- (a knife the game still shows raised: ours is given a moment to come down, yours is left alone)
if ours then state.stabAt=math.max(state.stabAt,os.clock()+0.15) end
if state.stabTarget~=near then state.stabTarget,state.stabSince=near,os.clock() end
local facing=turnToward(character,near) or os.clock()-state.stabSince>=0.4
if facing and os.clock()>=state.stabAt and not raised(character,knife) then
state.stabAt=os.clock()+STAB_GAP
pcall(function() knife:Activate() end)
end
return
end
local up=raised(character,knife)
-- (when the knife went up, so a throw can wait for the draw to finish)
if up then state.upSince=state.upSince or os.clock() else state.upSince=nil end
if up then
putAway()
state.holding,state.tries,state.pressThrows="game",0,nil
elseif state.on then
state.holding=nil
if not state.noRaise and os.clock()>=state.raiseAt then
if state.pressThrows==state.throws then state.tries=state.tries+1 end
if state.tries>=2 then
state.noRaise,state.gaveUp=true,true
else
if raise() then state.raises=state.raises+1 end
state.pressedAt,state.pressThrows=os.clock(),state.throws
state.raiseAt=os.clock()+0.6
end
end
else
putAway()
state.holding=nil
end
if state.on and not up and os.clock()>=state.readyAt and not state.winding then holdUp(character,knife) end
local pressing=state.on and not up and not state.noRaise and os.clock()<(state.pressedAt or 0)+0.35
-- (Auto Throw throws whenever your knife is in your hand and someone's in sight: a raised knife, by you
-- or by Auto Draw, is let go the game's way; otherwise it winds up and throws itself)
if settings.autoTap and os.clock()>=state.readyAt and not state.winding and not pressing then
local ok,target=pcall(playerInSight,character)
-- (a throw that didn't go is tried again after half a second, not every frame)
if ok and target and not throw(target) then state.readyAt=math.max(state.readyAt,os.clock()+0.5) end
end
end
end
end
local function loop(run)
while (state.on or settings.autoTap or settings.stab) and state.run==run and runtimeAlive do
if not pcall(tick) then state.winding=false end
task.wait(0.05)
end
end
local function stopAll()
putAway()
letGoOfHold(false)
for _,connection in ipairs(state.connections) do connection:Disconnect() end
table.clear(state.connections)
state.knife,state.holding,state.inHand=nil,nil,false
end
local function refreshLoop()
local active=state.on or settings.autoTap or settings.stab
state.run=state.run+1
stopAll()
if not active then return end
state.connections[1]=UserInputService.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then state.lastInput=input end
end)
task.spawn(loop,state.run)
end
local function apply(value)
state.on=value
if not value then putAway();letGoOfHold(false) end
refreshLoop()
end
local controls={}
local function toggle(name,key,callback)
local controller=addToggle(section,name,C(key,false),function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
local setDrawLit,setLit
local enableToggle=toggle("Enable Auto Draw Knife","w2AutoThrowEnabled",function(value)
apply(value)
if setDrawLit then setDrawLit(value) end
end)
local autoThrowToggle=toggle("Enable Auto Throw Knife","w2AutoThrowAutoTap",function(value)
settings.autoTap=value
refreshLoop()
if setLit then setLit(value) end
end)
toggle("Enable Wall Check","w2AutoThrowWallCheck",function(value) settings.wallCheck=value end)
section:AddSlider("Auto Throw Knife Range (Studs)",5,200,settings.range,function(value)
settings.range=math.clamp(tonumber(value) or 40,5,200)
SetCfg("w2AutoThrowAutoTapRange",settings.range)
end)
toggle("Enable Auto Stab","w2AutoStabEnabled",function(value)
settings.stab=value
refreshLoop()
end)
section:AddSlider("Auto Stab Range (Studs)",2,15,settings.stabRange,function(value)
settings.stabRange=math.clamp(tonumber(value) or 7,2,15)
SetCfg("w2AutoStabRange",settings.stabRange)
end)
local function drawBindSize()
local b=BindableButtons.Buttons[DRAW_BIND_ID]
if not b then return end
local camera=workspace.CurrentCamera
local screen=camera and camera.ViewportSize or Vector2.new(1920,1080)
if screen.X<=1 or screen.Y<=1 then screen=Vector2.new(1920,1080) end
b.Size=UDim2.new(settings.drawSize*(screen.Y/screen.X),0,settings.drawSize,0)
end
setDrawLit=function(value)
if BindableButtons.Buttons[DRAW_BIND_ID] then pcall(function() BindableButtons:SetValue(DRAW_BIND_ID,value==true,false) end) end
end
local function setDrawOn(value)
enableToggle:Set(value)
notify("Auto Draw Knife "..(value and "on" or "off"),value and 2 or 3)
end
local function createDrawBind()
BindableButtons.AddBButton(DRAW_BIND_ID,"AD",function() setDrawOn(true) end,function() setDrawOn(false) end,function(position)
saveStoredPosition("w2AutoDrawButtonPosition",position)
end)
BindableButtons:SetPosition(DRAW_BIND_ID,loadStoredPosition("w2AutoDrawButtonPosition",DRAW_BIND_DEFAULT))
BindableButtons:SetLocked(DRAW_BIND_ID,lockBindButtonPos)
drawBindSize()
setDrawLit(state.on)
end
toggle("Enable Bind AD Button","w2AutoDrawButtonEnabled",function(value)
if value then createDrawBind() else BindableButtons:DeleteBButton(DRAW_BIND_ID) end
end)
section:AddSlider("AD Bind Button Size",5,25,settings.drawSize*100,function(value)
settings.drawSize=math.clamp(tonumber(value) or 11,5,25)/100
SetCfg("w2AutoDrawButtonSize",settings.drawSize*100)
drawBindSize()
end)
section:AddButton("Reset AD Bind Button Position",function()
saveStoredPosition("w2AutoDrawButtonPosition",DRAW_BIND_DEFAULT)
BindableButtons:SetPosition(DRAW_BIND_ID,DRAW_BIND_DEFAULT)
end)
local function bindSize()
local b=BindableButtons.Buttons[BIND_ID]
if not b then return end
local camera=workspace.CurrentCamera
local screen=camera and camera.ViewportSize or Vector2.new(1920,1080)
if screen.X<=1 or screen.Y<=1 then screen=Vector2.new(1920,1080) end
b.Size=UDim2.new(settings.size*(screen.Y/screen.X),0,settings.size,0)
end
setLit=function(value)
if BindableButtons.Buttons[BIND_ID] then pcall(function() BindableButtons:SetValue(BIND_ID,value==true,false) end) end
end
local function setThrowOn(value)
autoThrowToggle:Set(value)
notify("Auto Throw Knife "..(value and "on" or "off"),value and 2 or 3)
end
local function createBind()
BindableButtons.AddBButton(BIND_ID,"AT",function() setThrowOn(true) end,function() setThrowOn(false) end,function(position)
saveStoredPosition("w2AutoThrowButtonPosition",position)
end)
BindableButtons:SetPosition(BIND_ID,loadStoredPosition("w2AutoThrowButtonPosition",BIND_DEFAULT))
BindableButtons:SetLocked(BIND_ID,lockBindButtonPos)
bindSize()
setLit(settings.autoTap)
end
toggle("Enable Bind AT Button","w2AutoThrowButtonEnabled",function(value)
if value then createBind() else BindableButtons:DeleteBButton(BIND_ID) end
end)
section:AddSlider("AT Bind Button Size",5,25,settings.size*100,function(value)
settings.size=math.clamp(tonumber(value) or 11,5,25)/100
SetCfg("w2AutoThrowButtonSize",settings.size*100)
bindSize()
end)
section:AddButton("Reset AT Bind Button Position",function()
saveStoredPosition("w2AutoThrowButtonPosition",BIND_DEFAULT)
BindableButtons:SetPosition(BIND_ID,BIND_DEFAULT)
end)
toggle("Enable AD Keybind","w2AutoThrowToggleKeybindEnabled",function(value) settings.toggleKeyOn=value end)
section:AddKeybind("Auto Draw Knife Keybind:","K",function()
if runtimeAlive and settings.toggleKeyOn then setDrawOn(not state.on) end
end)
toggle("Enable AT Keybind","w2AutoThrowKeybindEnabled",function(value) settings.keyOn=value end)
section:AddKeybind("Auto Throw Knife Keybind:","T",function()
if runtimeAlive and state.on and settings.keyOn then task.spawn(throw) end
end)
runtime.RegisterReset(function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
apply(false)
BindableButtons:DeleteBButton(DRAW_BIND_ID)
BindableButtons:DeleteBButton(BIND_ID)
settings.keyOn,settings.toggleKeyOn,settings.drawSize,settings.size,settings.autoTap,settings.range,settings.wallCheck=false,false,0.11,0.11,false,40,false
settings.stab,settings.stabRange=false,7
end)
end,"Section \"W2 Auto Draw/Throw Knife\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local runtime=env.WorldV2Runtime
local section=mainTab:AddSection("Shiftlock Shoot","Utilities")
local roles=runtime.Roles
local virtualInput
pcall(function() virtualInput=game:GetService("VirtualInputManager") end)
local LOCK_TIMES={0.08,0.15,0.22,0.3,0.4}
local HOLD_AFTER=0.15
local lockSpeed=math.clamp(math.floor(tonumber(C("w2SlmLockTime",2)) or 2),1,5)
local busy=false
local wallCheck=C("w2SlmWallCheck",false)==true
local enabled=C("w2SlmEnabled",false)==true
local lastError,lastErrorAt="",-math.huge
local function showError(text,kind)
text="Shiftlock Shoot: "..tostring(text)
if text==lastError and os.clock()-lastErrorAt<2 then return end
lastError,lastErrorAt=text,os.clock()
pcall(shared.Notify,text,kind or 0)
end
local function aliveRoot(plr)
local character=plr and plr.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if root and humanoid and humanoid.Health>0 then return root end
end
local function murderer()
local plr=roles and roles.Murderer and roles.Murderer()
if plr==LocalPlayer then return nil end
return plr
end
local function findGun(character)
local skins=runtime.ClientWeaponSkins
for _,container in ipairs({character or false,LocalPlayer:FindFirstChildOfClass("Backpack") or false}) do
if container then
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") then
if tool.Name=="Gun" or tool:GetAttribute("IsGun")==true then return tool end
if skins and type(skins.GetKind)=="function" then
local ok,kind=pcall(skins.GetKind,tool)
if ok and kind=="Gun" then return tool end
end
end
end
end
end
return nil
end
local function hasGun()
if roles and type(roles.Holds)=="function" then
local ok,holds=pcall(roles.Holds,LocalPlayer,"Gun")
if ok and holds then return true end
end
for _,container in ipairs({LocalPlayer.Character or false,LocalPlayer:FindFirstChildOfClass("Backpack") or false}) do
if container then
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and (tool.Name=="Gun" or tool:GetAttribute("IsGun")==true) then return true end
end
end
end
return false
end
local function touchScreen()
local touch=runtime.TouchControls
if touch and type(touch.IsTouch)=="function" then
local ok,value=pcall(touch.IsTouch)
if ok then return value==true end
end
return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end
local function touchControlsBack()
local touch=runtime.TouchControls
if touch and type(touch.Restore)=="function" then pcall(touch.Restore) end
end
local LOCK_NAME="WorldV2_ShiftlockMurderer"
local function lockOn(targetRoot,touch)
local camera=workspace.CurrentCamera
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local root=character and character:FindFirstChild("HumanoidRootPart")
if not camera or not humanoid or not root then return nil end
local saved={look=camera.CFrame.LookVector,mouse=UserInputService.MouseBehavior,touch=touch}
local letGo=runtime.HoldRotation(humanoid)
if not touch then pcall(function() UserInputService.MouseBehavior=Enum.MouseBehavior.LockCenter end) end
local function face()
if not targetRoot.Parent or not root.Parent then return end
local from=camera.CFrame.Position
camera.CFrame=CFrame.lookAt(from,targetRoot.Position)
local flat=Vector3.new(targetRoot.Position.X-root.Position.X,0,targetRoot.Position.Z-root.Position.Z)
if flat.Magnitude>0.05 then root.CFrame=CFrame.lookAt(root.Position,root.Position+flat) end
end
pcall(function() RunService:BindToRenderStep(LOCK_NAME,Enum.RenderPriority.Camera.Value+1,face) end)
face()
return {saved=saved,humanoid=humanoid,camera=camera,face=face,letGo=letGo}
end
local function unlock(lock,snapBack)
if not lock then return end
pcall(function() RunService:UnbindFromRenderStep(LOCK_NAME) end)
if snapBack and lock.camera then
local camera=lock.camera
pcall(function() camera.CFrame=CFrame.lookAt(camera.CFrame.Position,camera.CFrame.Position+lock.saved.look) end)
end
lock.letGo()
if lock.saved.touch then touchControlsBack()
else pcall(function() UserInputService.MouseBehavior=lock.saved.mouse end) end
end
local function pressKey(keyName)
local keyCode
pcall(function() keyCode=Enum.KeyCode[keyName] end)
if not keyCode or keyCode==Enum.KeyCode.Unknown then return false,"your keybind isn't set (press it once after setting it)" end
if not virtualInput then return false,"this executor can't press keys" end
local ok=pcall(function()
virtualInput:SendKeyEvent(true,keyCode,false,game)
task.wait(0.03)
virtualInput:SendKeyEvent(false,keyCode,false,game)
end)
if not ok then return false,"your keybind couldn't be pressed" end
return true
end
local function odhShoot()
local shoot=runtime.ODHShootMurderer
if type(shoot)~="function" then return false,"couldn't find ODH's Shoot Murderer button on the screen" end
local ok,done,why=pcall(shoot)
if ok and done then return true end
return false,"couldn't find ODH's Shoot Murderer button on the screen"..(why and (" ("..tostring(why)..")") or "")
end
local sightParams=RaycastParams.new()
sightParams.FilterType=Enum.RaycastFilterType.Exclude
sightParams.IgnoreWater=true
local function inSight(target)
local character=LocalPlayer.Character
local eye=character and (character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart"))
local other=target.Character
if not eye or not other then return false end
sightParams.FilterDescendantsInstances={character}
for _,name in ipairs({"Head","HumanoidRootPart"}) do
local part=other:FindFirstChild(name)
if part then
local hit=workspace:Raycast(eye.Position,part.Position-eye.Position,sightParams)
local blocker=hit and hit.Instance
if not hit or blocker:IsDescendantOf(other) or not blocker.CanCollide or blocker.Transparency>=0.9 then return true end
end
end
return false
end
local settings={
keyOn=C("w2SlmLockKeybindEnabled",false)==true,
ownKey=C("w2SlmLockOwnKey",nil),
}
local function shootNow(character,touch)
if type(settings.ownKey)=="string" and not touch then return pressKey(settings.ownKey) end
local shoot=runtime.ShootMurdererNow
if type(shoot)~="function" then return odhShoot() end
local fine,done,why=pcall(shoot,character)
if not fine then return false,tostring(done) end
if done then return true end
return false,"couldn't shoot: "..tostring(why or "ODH's shoot button did not respond")
end
local function run()
if busy or not runtimeAlive or not enabled then return end
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if not humanoid or humanoid.Health<=0 then return end
local gun=findGun(character)
if not gun and not hasGun() then return end
local target=murderer()
if not target then showError("no murderer found");return end
local targetRoot=aliveRoot(target)
if not targetRoot then showError("the target isn't alive");return end
if wallCheck and not inSight(target) then return end
busy=true
if gun and gun.Parent~=character then pcall(function() humanoid:EquipTool(gun) end) end
task.spawn(function()
local touch=touchScreen()
local lock=lockOn(targetRoot,touch)
if not lock then busy=false;showError("your character isn't loaded");return end
local released=false
local function release()
if released then return end
released=true
unlock(lock,false)
end
task.delay((LOCK_TIMES[lockSpeed] or 0.15)+HOLD_AFTER+2,release)
task.wait(LOCK_TIMES[lockSpeed] or 0.15)
local ok,why=shootNow(character,touch)
if touch then touchControlsBack() end
task.wait(HOLD_AFTER)
release()
busy=false
if not ok then showError(why,1) end
end)
end
task.spawn(function()
for _=1,100 do
if not runtimeAlive then return end
local followup=runtime.JumpGunFollowup
if followup and followup.Watch then pcall(followup.Watch,"ShiftlockShoot",function() return enabled end);return end
task.wait(0.2)
end
end)
local controls={}
local function toggle(name,key,callback)
local controller=addToggle(section,name,C(key,false),function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
local DEFAULT_POSITION=UDim2.new(0.58,0,0.78,0)
local POSITION_KEY="w2SlmLockBigPosition"
local big={
on=C("w2SlmLockButtonEnabled",false)==true,
width=math.clamp(tonumber(C("w2SlmLockBigWidth",140)) or 140,50,300),
height=math.clamp(tonumber(C("w2SlmLockBigHeight",52)) or 52,20,150),
hideText=C("w2SlmLockBigHideText",false)==true,
}
local record
local function shown() return record and record.Alive() end
local function removeBig()
if record then pcall(record.Destroy);record=nil end
end
local function showBig()
if not (big.on and enabled) then removeBig();return end
if shown() then return end
local factory=runtime.BigButtons
if not factory or type(factory.Create)~="function" then return end
record=factory.Create("WorldV2_SlmBiglock",{
text="Shiftlock Shoot",onClick=run,
isLocked=function() return lockBigButtonPos==true end,
positionKey=POSITION_KEY,default=DEFAULT_POSITION,size=big.width,height=big.height,
})
pcall(record.SetTextHidden,big.hideText)
end
section:AddParagraph("Shiftlock Shoot","Momentarily shifts your camera and character into a locked position onto the user for legit shooting practice.")
toggle("Enable Shiftlock Shoot","w2SlmEnabled",function(value) enabled=value;showBig() end)
toggle("Wall Check","w2SlmWallCheck",function(value) wallCheck=value end)
section:AddSlider("Shiftlock Shoot Speed",1,5,lockSpeed,function(value)
lockSpeed=math.clamp(math.floor((tonumber(value) or 2)+0.5),1,5);SetCfg("w2SlmLockTime",lockSpeed)
end)
toggle("Enable Keybind","w2SlmLockKeybindEnabled",function(value) settings.keyOn=value end)
section:AddKeybind("Shiftlock Shoot Keybind","Z",function()
if settings.keyOn then run() end
end)
-- (your ODH shoot key, typed in so ODH doesn't refuse it; left empty, ODH's Shoot Murderer button is
-- pressed instead)
section:AddTextBox("My Shoot Key (type it, e.g. E)",function(text)
local name=env.WorldV2Runtime.KeyFromText(text)
-- (the saved key being filled back in when the script runs: nothing to say)
if name==settings.ownKey then return end
if tostring(text or ""):gsub("%s","")=="" then
settings.ownKey=nil;SetCfg("w2SlmLockOwnKey",nil)
pcall(shared.Notify,"Shiftlock Shoot: no shoot key, ODH's Shoot Murderer button is used",3)
elseif name then
settings.ownKey=name;SetCfg("w2SlmLockOwnKey",name)
pcall(shared.Notify,"Shiftlock Shoot: your shoot key is "..name,2)
else
pcall(shared.Notify,"Shiftlock Shoot: "..tostring(text).." isn't a key",0)
end
end)
toggle("Enable Big Button","w2SlmLockButtonEnabled",function(value) big.on=value;showBig() end)
toggle("Hide Button Text","w2SlmLockBigHideText",function(value)
big.hideText=value
if shown() then pcall(record.SetTextHidden,value) end
end)
section:AddSlider("Big Button Width",50,300,big.width,function(value)
big.width=math.clamp(tonumber(value) or 140,50,300);SetCfg("w2SlmLockBigWidth",big.width)
if shown() then record.SetSize(big.width) end
end)
section:AddSlider("Big Button Height",20,150,big.height,function(value)
big.height=math.clamp(tonumber(value) or 52,20,150);SetCfg("w2SlmLockBigHeight",big.height)
if shown() then record.SetHeight(big.height) end
end)
section:AddButton("Reset Big Button Position",function()
if shown() then record.ResetPosition()
else SetCfg(POSITION_KEY,{xs=DEFAULT_POSITION.X.Scale,xo=0,ys=DEFAULT_POSITION.Y.Scale,yo=0}) end
end)
runtime.RegisterReset(function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
pcall(function() RunService:UnbindFromRenderStep(LOCK_NAME) end)
removeBig()
settings.keyOn=false
lockSpeed=2
busy=false
end)
end,"Section \"W2 Shiftlock Murderer\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local runtime=env.WorldV2Runtime
local ALLOW_TIME=0.6
local guarded=setmetatable({},{__mode="k"})
local watched=setmetatable({},{__mode="k"})
local connections={}
local allowedUntil=0
local function touchOnly() return UserInputService.TouchEnabled and not UserInputService.MouseEnabled end
local function isGun(tool)
if tool.Name=="Gun" or tool:GetAttribute("IsGun")==true then return true end
local skins=runtime.ClientWeaponSkins
if skins and type(skins.GetKind)=="function" then
local ok,kind=pcall(skins.GetKind,tool)
if ok and kind=="Gun" then return true end
end
return false
end
local function apply(tool)
local blocked=os.clock()>=allowedUntil
if tool.ManualActivationOnly~=blocked then pcall(function() tool.ManualActivationOnly=blocked end) end
end
local function applyAll()
for tool in pairs(guarded) do if tool.Parent then apply(tool) end end
end
local function guard(tool)
if not runtimeAlive or not touchOnly() or not tool:IsA("Tool") or not isGun(tool) then return end
if guarded[tool]==nil then
guarded[tool]=tool.ManualActivationOnly
connections[#connections+1]=tool:GetPropertyChangedSignal("ManualActivationOnly"):Connect(function()
if runtimeAlive then apply(tool) end
end)
if type(runtime.ODHShootWarm)=="function" then pcall(runtime.ODHShootWarm) end
end
apply(tool)
end
local function allow(seconds)
seconds=tonumber(seconds) or ALLOW_TIME
allowedUntil=math.max(allowedUntil,os.clock()+seconds)
applyAll()
task.delay(seconds+0.05,applyAll)
end
local function watch(container)
if not container or watched[container] then return end
watched[container]=true
for _,child in ipairs(container:GetChildren()) do guard(child) end
connections[#connections+1]=container.ChildAdded:Connect(guard)
end
watch(LocalPlayer:FindFirstChildOfClass("Backpack"))
watch(LocalPlayer.Character)
connections[#connections+1]=LocalPlayer.CharacterAdded:Connect(watch)
connections[#connections+1]=LocalPlayer.ChildAdded:Connect(function(child)
if child:IsA("Backpack") then watch(child) end
end)
local function pressedOnShootButton(input)
if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
if not next(guarded) then return end
local at=runtime.ODHShootButtonAt
if type(at)~="function" then return end
local ok,on=pcall(at,input.Position)
if ok and on then allow() end
end
connections[#connections+1]=UserInputService.InputBegan:Connect(pressedOnShootButton)
connections[#connections+1]=UserInputService.InputEnded:Connect(pressedOnShootButton)
runtime.GunTaps={Allow=allow,Guarded=function(tool) return guarded[tool]~=nil end}
runtime.RegisterReset(function()
if runtimeAlive then return end
for _,connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
table.clear(connections)
for tool,original in pairs(guarded) do pcall(function() tool.ManualActivationOnly=original end) end
end)
end,"Section \"Gun Taps\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local section=mainTab:AddSection("Firefly Clutch","Utilities")
local equipGunAfterClutch=C("fireflyEquipGun",false)
local shootAfterClutch=C("fireflyShootMurderer",false)
local autoClutch=C("fireflyAutoClutch",false)
local timerEnabled=C("fireflyTimerEnabled",false)
local timerColors=C("fireflyTimerColors",true)
-- (sizes 1 to 3 are smaller than the old smallest; 4 to 13 are the old 1 to 10, carried over)
local SMALL_SIZES={0.4,0.6,0.8}
local timerSize=tonumber(C("fireflyTimerSizeLevel",nil))
if not timerSize then
timerSize=math.clamp(tonumber(C("fireflyTimerSize",10)) or 10,1,10)+#SMALL_SIZES
SetCfg("fireflyTimerSizeLevel",timerSize)
end
timerSize=math.clamp(timerSize,1,10+#SMALL_SIZES)
local timerLocked=C("fireflyTimerLocked",false)
local COUNTDOWN=3.0
local COOLDOWN=16
local TRIGGER_POINT=0.24
local JUMP_GAP=0.40
local TIMER_GREEN=Color3.fromRGB(0,255,0)
local TIMER_YELLOW=Color3.fromRGB(255,200,0)
local TIMER_RED=Color3.fromRGB(255,0,0)
local TIMER_BLACK=Color3.fromRGB(0,0,0)
local DEFAULT_POS=UDim2.new(0.5,0,0.05,0)
local function timerCountdownColor(remaining,total)
total=math.max(tonumber(total) or 1,0.001)
local ratio=math.clamp((tonumber(remaining) or 0)/total,0,1)
if ratio>=(2/3) then return TIMER_GREEN end
if ratio>=(1/3) then return TIMER_YELLOW end
return TIMER_RED
end
local gui,timerLabel
local timerDragConnections={}
local countdownConnection,cooldownConnection,blockConnection
local watchConnections={}
local hookedTools=setmetatable({}, {__mode="k"})
local scanToken=0
local isOnCooldown=false
local cooldownGateReady=false
local jumpTriggered=false
local cycleToken=0
local cycleStartedAt=nil
local countdownRemaining=nil
local cooldownEndsAt=nil
local function updateTimerDisplay()
if not timerLabel then return end
timerLabel.Visible=timerEnabled
if not timerEnabled then return end
local protection=env.WorldV2Runtime.FireflyProtection
if protection and type(protection.BlocksClutch)=="function" and protection.BlocksClutch() then
timerLabel.Text="DISABLED"
timerLabel.TextColor3=timerColors and TIMER_RED or TIMER_BLACK
return
end
local now=os.clock()
local remaining,total
if countdownRemaining and countdownRemaining>0 then
remaining,total=countdownRemaining,COUNTDOWN
elseif cooldownEndsAt and now<cooldownEndsAt then
remaining,total=cooldownEndsAt-now,COOLDOWN
end
if remaining then
timerLabel.Text=string.format("%.1fCD",math.max(0,remaining))
timerLabel.TextColor3=timerColors and timerCountdownColor(remaining,total) or TIMER_BLACK
else
timerLabel.Text="Ready"
timerLabel.TextColor3=TIMER_BLACK
end
end
local function disconnect(conn)
if conn then pcall(function() conn:Disconnect() end) end
end
local function ownsFireflyTool(tool)
local backpack=player:FindFirstChildOfClass("Backpack")
return (player.Character and tool.Parent==player.Character)
or (backpack and tool.Parent==backpack) or false
end
local function blockToolActivation(tool,state)
if not autoClutch or not isOnCooldown or not cooldownGateReady or not ownsFireflyTool(tool) then return end
state.blocked=true
if tool.Enabled then pcall(function() tool.Enabled=false end) end
end
local function blockFireflyTools()
for tool,state in pairs(hookedTools) do blockToolActivation(tool,state) end
end
local function releaseToolBlocks()
cooldownGateReady=false
for tool,state in pairs(hookedTools) do
if state.blocked then
state.blocked=false
pcall(function()
if not tool.Enabled then tool.Enabled=state.originalEnabled end
end)
end
end
end
local function clearTimerGuis()
local pg=player:FindFirstChildOfClass("PlayerGui")
if not pg then return end
for _,name in ipairs({"VisualsV2_FireflyTimer","FireflyTimerGui","FireflyCooldownGui"}) do
local old=pg:FindFirstChild(name)
if old and old~=gui then pcall(function() old:Destroy() end) end
end
end
local function applyTimerSize()
if not timerLabel then return end
local small=SMALL_SIZES[timerSize]
local level=math.max(timerSize-#SMALL_SIZES,1)
local width=small and math.floor(72*small) or 72+((level-1)*8)
local height=small and math.floor(24*small) or 24+((level-1)*2)
timerLabel.Size=UDim2.fromOffset(width,height)
timerLabel.TextSize=small and math.max(6,math.floor(height*0.65)) or math.max(12,math.floor(height*0.65))
end
local function buildTimer()
if gui and gui.Parent and timerLabel then return end
clearTimerGuis()
gui=Instance.new("ScreenGui")
gui.Name="VisualsV2_FireflyTimer"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.Parent=player:WaitForChild("PlayerGui")
timerLabel=Instance.new("TextLabel")
timerLabel.Name="FireflyTimer"
timerLabel.AnchorPoint=Vector2.new(0.5,0.5)
timerLabel.Position=loadStoredPosition("fireflyTimerPosition",DEFAULT_POS)
timerLabel.BackgroundTransparency=1
timerLabel.BorderSizePixel=0
timerLabel.TextColor3=Color3.new(0,0,0)
timerLabel.TextStrokeTransparency=1
timerLabel.Font=Enum.Font.SourceSans
timerLabel.Text="Ready"
timerLabel.Visible=timerEnabled
timerLabel.Active=true
timerLabel.Parent=gui
applyTimerSize()
updateTimerDisplay()
local dragging=false
local moved=false
local dragInput,dragStart,startPos
timerLabel.InputBegan:Connect(function(input)
if timerLocked then return end
if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
dragging=true
moved=false
dragStart=input.Position
startPos=timerLabel.Position
end)
timerLabel.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end)
table.insert(timerDragConnections,UserInputService.InputChanged:Connect(function(input)
if not dragging or timerLocked or not timerEnabled or not timerLabel or input~=dragInput then return end
local delta=input.Position-dragStart
if delta.Magnitude>7 then moved=true end
timerLabel.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
end))
table.insert(timerDragConnections,UserInputService.InputEnded:Connect(function(input)
if not dragging then return end
if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
dragging=false
if moved and timerLabel then saveStoredPosition("fireflyTimerPosition",timerLabel.Position) end
end))
end
local function fireJump()
local char=player.Character
local humanoid=char and char:FindFirstChildOfClass("Humanoid")
if not humanoid or humanoid.Health<=0 then return end
humanoid.Jump=true
pcall(function()
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)
end
local function startTwoJumpSequence(myCycle)
local character=player.Character
fireJump()
task.delay(JUMP_GAP,function()
if autoClutch and myCycle==cycleToken and player.Character==character then
fireJump()
env.WorldV2Runtime.JumpGunFollowup.Queue("FireflyClutch",character,function()
if not autoClutch or myCycle~=cycleToken then return false,false end
return equipGunAfterClutch,shootAfterClutch
end)
end
end)
end
local function stopCycle()
disconnect(countdownConnection)
disconnect(cooldownConnection)
disconnect(blockConnection)
countdownConnection=nil
cooldownConnection=nil
blockConnection=nil
cycleToken=cycleToken+1
isOnCooldown=false
releaseToolBlocks()
jumpTriggered=false
cycleStartedAt=nil
countdownRemaining=nil
cooldownEndsAt=nil
updateTimerDisplay()
end
local function startCountdown()
if not autoClutch then return end
buildTimer()
disconnect(countdownConnection)
countdownConnection=nil
jumpTriggered=false
local myCycle=cycleToken
updateTimerDisplay()
countdownConnection=RunService.Heartbeat:Connect(function(dt)
if not autoClutch or myCycle~=cycleToken or not countdownRemaining then return end
countdownRemaining=math.max(0,countdownRemaining-dt)
if not jumpTriggered and countdownRemaining<=TRIGGER_POINT then
jumpTriggered=true
startTwoJumpSequence(myCycle)
end
updateTimerDisplay()
if countdownRemaining<=0 then
disconnect(countdownConnection)
countdownConnection=nil
end
end)
end
local function startCooldownPanel()
buildTimer()
disconnect(cooldownConnection)
cooldownConnection=nil
cooldownConnection=RunService.Heartbeat:Connect(function()
if not cycleStartedAt or not cooldownEndsAt then return end
local now=os.clock()
if countdownRemaining and countdownRemaining>0 then return end
local remaining=cooldownEndsAt-now
if remaining<=0 then
updateTimerDisplay()
disconnect(cooldownConnection)
cooldownConnection=nil
return
end
updateTimerDisplay()
end)
end
local function startBlockTimer()
isOnCooldown=true
local myCycle=cycleToken
task.defer(function()
if autoClutch and isOnCooldown and myCycle==cycleToken then
cooldownGateReady=true
blockFireflyTools()
end
end)
disconnect(blockConnection)
blockConnection=nil
blockConnection=RunService.Heartbeat:Connect(function()
if cooldownEndsAt and os.clock()>=cooldownEndsAt then
isOnCooldown=false
releaseToolBlocks()
disconnect(blockConnection)
blockConnection=nil
elseif cooldownGateReady then
blockFireflyTools()
end
end)
end
local function startOriginalCycle()
if not autoClutch or isOnCooldown then return end
buildTimer()
cycleToken=cycleToken+1
cycleStartedAt=os.clock()
countdownRemaining=COUNTDOWN
cooldownEndsAt=cycleStartedAt+COOLDOWN
startCountdown()
startCooldownPanel()
startBlockTimer()
end
local function connectToTool(tool)
if not tool or not tool:IsA("Tool") or tool.Name~="Fireflies" then return end
if hookedTools[tool] then
blockToolActivation(tool,hookedTools[tool])
return
end
local state={originalEnabled=tool.Enabled,blocked=false}
hookedTools[tool]=state
table.insert(watchConnections,tool:GetPropertyChangedSignal("Enabled"):Connect(function()
if autoClutch and isOnCooldown then
if tool.Enabled then state.originalEnabled=true end
blockToolActivation(tool,state)
elseif not state.blocked then
state.originalEnabled=tool.Enabled
end
end))
table.insert(watchConnections,tool.Activated:Connect(function()
if not autoClutch or isOnCooldown then return end
if not ownsFireflyTool(tool) then return end
if os.clock()-(env.WorldV2Runtime.FireflyAutoUseAt or -math.huge)<3 then return end
local protection=env.WorldV2Runtime.FireflyProtection
if protection and type(protection.BlocksClutch)=="function" and protection.BlocksClutch() then return end
state.originalEnabled=true
startOriginalCycle()
end))
blockToolActivation(tool,state)
end
local function scanForFireflies()
local backpack=player:FindFirstChildOfClass("Backpack")
local character=player.Character
local function scanContainer(container)
if container then
for _,child in ipairs(container:GetChildren()) do
if child:IsA("Tool") and child.Name=="Fireflies" then
connectToTool(child)
end
end
end
end
scanContainer(backpack)
scanContainer(character)
end
local function hookTool()
scanToken=scanToken+1
local myScan=scanToken
local function watchContainer(container)
if not container then return end
pcall(scanForFireflies)
table.insert(watchConnections,container.ChildAdded:Connect(function(child)
if child:IsA("Tool") and child.Name=="Fireflies" then
connectToTool(child)
end
end))
end
watchContainer(player:FindFirstChildOfClass("Backpack"))
watchContainer(player.Character)
table.insert(watchConnections,player.ChildAdded:Connect(function(child)
if child:IsA("Backpack") then
watchContainer(child)
task.defer(scanForFireflies)
end
end))
table.insert(watchConnections,player.CharacterAdded:Connect(function(char)
watchContainer(char)
task.defer(function()
if autoClutch and myScan==scanToken then
buildTimer()
scanForFireflies()
end
end)
end))
scanForFireflies()
task.spawn(function()
for _=1,12 do
if not autoClutch or myScan~=scanToken then return end
pcall(scanForFireflies)
task.wait(0.05)
end
while autoClutch and myScan==scanToken do
pcall(scanForFireflies)
task.wait(0.5)
end
end)
end
local function unhookTool()
scanToken=scanToken+1
stopCycle()
for _,conn in ipairs(watchConnections) do
disconnect(conn)
end
table.clear(watchConnections)
table.clear(hookedTools)
end
local autoToggle=addToggle(section,"Auto Firefly Clutch",autoClutch,function(state)
autoClutch=state
SetCfg("fireflyAutoClutch",state)
if state then
buildTimer()
unhookTool()
autoClutch=true
hookTool()
else
unhookTool()
end
end)
env.WorldV2Runtime.FireflyClutch={Enabled=function() return autoClutch end,Disable=function() autoToggle:Set(false) end,
Busy=function() return autoClutch and cycleStartedAt~=nil and os.clock()-cycleStartedAt<COUNTDOWN+1.5 end,
RefreshTimer=function() pcall(updateTimerDisplay) end}
local equipGunToggle=addToggle(section,"Equip Gun After Firefly Clutch",equipGunAfterClutch,function(value)
equipGunAfterClutch=value;SetCfg("fireflyEquipGun",value)
end)
local shootToggle=addToggle(section,"Shoot Murderer After Firefly Clutch",shootAfterClutch,function(value)
shootAfterClutch=value;SetCfg("fireflyShootMurderer",value)
end)
pcall(env.WorldV2Runtime.JumpGunFollowup.Watch,"FireflyClutch",function() return autoClutch and shootAfterClutch end)
-- (keyboard: your own ODH shoot key is pressed instead of ODH's mobile shoot button)
local useOwnShootKey=C("fireflyUseOwnShootKey",false)==true
local ownShootKey=C("fireflyOwnShootKey",nil)
local function applyOwnShootKey()
pcall(env.WorldV2Runtime.JumpGunFollowup.SetOwnKey,"FireflyClutch",useOwnShootKey and ownShootKey or nil)
end
local ownKeyToggle=addToggle(section,"Use My Shoot Key (Keyboard)",useOwnShootKey,function(value)
useOwnShootKey=value;SetCfg("fireflyUseOwnShootKey",value);applyOwnShootKey()
end)
section:AddTextBox("My Shoot Key (type it, e.g. E)",function(text)
local name=env.WorldV2Runtime.KeyFromText(text)
if name==ownShootKey then return end
if tostring(text or ""):gsub("%s","")=="" then
ownShootKey=nil;SetCfg("fireflyOwnShootKey",nil)
pcall(shared.Notify,"Firefly Clutch: no shoot key, ODH's shoot button is used",3)
elseif name then
ownShootKey=name;SetCfg("fireflyOwnShootKey",name)
pcall(shared.Notify,"Firefly Clutch: your shoot key is "..name,2)
else
pcall(shared.Notify,"Firefly Clutch: "..tostring(text).." isn't a key",0)
end
applyOwnShootKey()
end)
applyOwnShootKey()
local timerToggle=addToggle(section,"Enable Firefly Timer",timerEnabled,function(state)
timerEnabled=state
SetCfg("fireflyTimerEnabled",state)
buildTimer()
updateTimerDisplay()
end)
local timerColorToggle=addToggle(section,"Enable Statistic Colors",timerColors,function(state)
timerColors=state
SetCfg("fireflyTimerColors",state)
updateTimerDisplay()
end)
section:AddSlider("Firefly Timer Size",1,10+#SMALL_SIZES,timerSize,function(value)
timerSize=math.clamp(math.floor(tonumber(value) or 8),1,10+#SMALL_SIZES)
SetCfg("fireflyTimerSizeLevel",timerSize)
applyTimerSize()
end)
local fireflyLockToggle=addToggle(section,"Lock Firefly Timer Position",timerLocked,function(state)
timerLocked=state
SetCfg("fireflyTimerLocked",state)
end)
section:AddButton("Reset Firefly Timer Position",function()
saveStoredPosition("fireflyTimerPosition",DEFAULT_POS)
if timerLabel then timerLabel.Position=DEFAULT_POS end
end)
local fireflyRemovingConnection=player.CharacterRemoving:Connect(function()
stopCycle()
end)
local fireflyRespawnConnection=player.CharacterAdded:Connect(function()
stopCycle()
end)
env.WorldV2Runtime.RegisterReset(function()
autoToggle:Set(false)
equipGunToggle:Set(false)
shootToggle:Set(false)
timerToggle:Set(false)
timerColorToggle:Set(false)
fireflyLockToggle:Set(false)
autoClutch=false
timerEnabled=false
timerColors=false
timerLocked=false
unhookTool()
disconnect(fireflyRemovingConnection)
disconnect(fireflyRespawnConnection)
for _,connection in ipairs(timerDragConnections) do disconnect(connection) end
table.clear(timerDragConnections)
if gui then gui:Destroy(); gui=nil; timerLabel=nil end
end)
buildTimer()
if autoClutch then
hookTool()
end
end,"Section \"Firefly Clutch\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local scope13011={}
if not inMurderMystery then return end
scope13011.runtime=env.WorldV2Runtime
scope13011.isMMV=game.GameId==10413186812 or game.GameId==10769671266 or game.PlaceId==93017634738276 or game.PlaceId==81374640397860
-- (MMV has Firefly Symbols only; MM2 has Firefly Protection and Firefly Symbols)
scope13011.UserInput=game:GetService("UserInputService")
scope13011.section=mainTab:AddSection("Firefly Protection","Utilities")
scope13011.status=nil
pcall(function() scope13011.status=scope13011.section:AddParagraph("Status","Off",true) end)
scope13011.INTERCEPT_STUDS=14
scope13011.INTERCEPT_STOP,scope13011.INTERCEPT_AREA=10,6
scope13011.settings={
shield=not scope13011.isMMV and C("fireflyProtectShield",false)==true,
intercept=not scope13011.isMMV and C("fireflyProtectIntercept",false)==true,
sky=not scope13011.isMMV and C("fireflyProtectHidden",false)==true,
ring=not scope13011.isMMV and C("fireflyProtectRing",C("fireflyProtectShuffle",false)==true)==true,
mouse=not scope13011.isMMV and C("fireflyProtectMouse",false)==true,
autoJar=C("fireflyProtectAutoJar",false)==true,
distance=math.clamp(tonumber(C("fireflyProtectDistance",2.2)) or 2.2,1,4),
interceptArea=scope13011.INTERCEPT_AREA,
interceptStop=scope13011.INTERCEPT_STOP,
blockScale=2,
mm2RingSpeed=math.clamp(tonumber(C("fireflyMM2RingSpeed",2)) or 2,1,5),
symbols=C("fireflySymbolsEnabled",false)==true,
symbol=tostring(C("fireflySymbol","?")),
}
scope13011.SYMBOL_NAMES={"?","!","Line & Dots","()",":3",":)",":]",":[",":D",";)",";[",":/",":|","<3","Star"}
if not table.find(scope13011.SYMBOL_NAMES,scope13011.settings.symbol) then scope13011.settings.symbol="?" end
for _,key in ipairs({"fireflyProtectUserIntercept","fireflyProtectUserShield","fireflyProtectUser",
"fireflyInterceptArea","fireflyInterceptStop","fireflyInterceptAreaShow","fireflyInterceptAreaColor",
"fireflyInterceptAreaAlpha"}) do SetCfg(key,nil) end
scope13011.JAR_COOLDOWN=16
scope13011.FOLLOW=20
scope13011.MAX_FIREFLIES=90
scope13011.NEAR=40
scope13011.RANGE=200
scope13011.MOUSE_RANGE=50
scope13011.LIFT=Vector3.new(0,0.6,0)
scope13011.MARK="VisualsV2_Firefly"
scope13011.fireflies={}
scope13011.list={}
scope13011.loop,scope13011.placeLoop,scope13011.watchAdded,scope13011.watchRemoved,scope13011.autoLoop=nil
scope13011.knives={}
scope13011.smoothDirection=nil
scope13011.murdererNotice=-math.huge
scope13011.diagnostics={fireflies=0,owned=0,threat="none",mode="idle",active=false,intercepts=0,jarUses=0,jarAttempts=0,skippedSlots=0,knivesDone=0}
scope13011.protecting=function() return scope13011.settings.shield or scope13011.settings.intercept or scope13011.settings.sky or scope13011.settings.ring or scope13011.settings.symbols or scope13011.settings.mouse end
scope13011.active=function() return scope13011.protecting() or scope13011.settings.autoJar end
scope13011.owned=function(part)
local ok,age=pcall(function() return part.ReceiveAge end)
return not ok or age==0
end
scope13011.myRoot=function()
local character=LocalPlayer.Character
return character and character:FindFirstChild("HumanoidRootPart"),character
end
scope13011.hasTool=function(plr,word)
for _,container in ipairs({plr.Character,plr:FindFirstChildOfClass("Backpack")}) do
if container then
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and tool.Name:lower():find(word,1,true) then return true end
end
end
end
return false
end
scope13011.role=function(plr)
for _,name in ipairs({"Role","CurrentRole"}) do
local value=plr:GetAttribute(name)
if type(value)=="string" then return value:lower() end
end
end
scope13011.aliveRoot=function(plr)
local character=plr.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local root=character and character:FindFirstChild("HumanoidRootPart")
if root and humanoid and humanoid.Health>0 then return root,character end
end
scope13011.ReplicatedStorage=game:GetService("ReplicatedStorage")
scope13011.roundMurderer,scope13011.roundCheckedAt,scope13011.roundChecking=false,-math.huge,false
scope13011.roundData=nil
local function refreshRound()
if scope13011.isMMV or scope13011.roundChecking or os.clock()-scope13011.roundCheckedAt<(scope13011.runtime.Roles and 1 or 3) then return end
scope13011.roundChecking=true
task.spawn(function()
local ok,data=pcall(function()
-- (asks the shared role lookup, which answers at once and asks the server once for every section)
local lookup=scope13011.runtime.Roles
if lookup and type(lookup.Data)=="function" then return lookup.Data() end
local remote=scope13011.ReplicatedStorage:FindFirstChild("GetPlayerData",true)
if remote and remote:IsA("RemoteFunction") then return remote:InvokeServer() end
end)
if ok and type(data)=="table" then
scope13011.roundData=data
local mine=data[LocalPlayer.Name]
scope13011.roundMurderer=type(mine)=="table" and mine.Role=="Murderer" and not mine.Dead and not mine.Killed or false
end
scope13011.roundCheckedAt=os.clock();scope13011.roundChecking=false
end)
end
local function iHaveKnife() return scope13011.role(LocalPlayer)=="murderer" or scope13011.hasTool(LocalPlayer,"knife") or scope13011.roundMurderer end
local function roundOn()
if scope13011.isMMV then return false end
if scope13011.roundMurderer then return true end
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and (scope13011.role(plr)=="murderer" or scope13011.hasTool(plr,"knife")) then return true end
end
return false
end
local function attackers(root,except)
local found={}
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and plr~=except then
local other=scope13011.aliveRoot(plr)
if other then
local threat
threat=scope13011.role(plr)=="murderer" or scope13011.hasTool(plr,"knife")
if threat then found[#found+1]={player=plr,root=other,distance=(other.Position-root.Position).Magnitude} end
end
end
end
table.sort(found,function(a,b) return a.distance<b.distance end)
return found
end
local function clutchBusy()
local clutch=scope13011.runtime.FireflyClutch
if not clutch or type(clutch.Busy)~="function" then return false end
local ok,busy=pcall(clutch.Busy)
return ok and busy==true
end
local jar={usedAt=-math.huge,spawnedAt=-math.huge,busy=false,waitingEnabled=false,enabledBack=false,hooked=setmetatable({}, {__mode="k"}),
respawnAt=-math.huge,seenAt=setmetatable({}, {__mode="k"}),loadedAt=os.clock(),worked=false}
-- (running the script isn't a respawn: it doesn't start the "just spawned" protection that uses the jar
-- straight away, so the jar is only used once something actually needs it)
local function inCharacterOrTool(object)
local current=object.Parent
for _=1,8 do
if not current or current==workspace then return false end
if current:IsA("Tool") or current:IsA("Accessory") or current:FindFirstChildOfClass("Humanoid") then return true end
local name=current.Name:lower()
if name=="weapondisplays" or name=="throwingknife" or name:sub(1,9)=="visualsv2" then return true end
current=current.Parent
end
return false
end
local MOVERS={BodyPosition="MaxForce",BodyVelocity="MaxForce",BodyGyro="MaxTorque",BodyAngularVelocity="MaxTorque",
BodyForce="Force",BodyThrust="Force"}
local CONSTRAINT_MOVERS={AlignPosition=true,AlignOrientation=true,LinearVelocity=true,AngularVelocity=true,VectorForce=true}
local function calm(part)
local saved=scope13011.fireflies[part]
if not saved then return end
saved.movers=saved.movers or {}
for _,child in ipairs(part:GetChildren()) do
if not saved.movers[child] then
local property=MOVERS[child.ClassName]
if property then
local ok,value=pcall(function() return child[property] end)
if ok and value~=nil then
saved.movers[child]={property,value}
pcall(function() child[property]=Vector3.zero end)
end
elseif CONSTRAINT_MOVERS[child.ClassName] then
local ok,value=pcall(function() return child.Enabled end)
if ok then saved.movers[child]={"Enabled",value};pcall(function() child.Enabled=false end) end
end
end
end
end
local function uncalm(part)
local saved=scope13011.fireflies[part]
if not saved or not saved.movers then return end
for mover,value in pairs(saved.movers) do
pcall(function() if mover.Parent then mover[value[1]]=value[2] end end)
end
saved.movers=nil
end
local function track(part)
if scope13011.fireflies[part] or #scope13011.list>=scope13011.MAX_FIREFLIES or not part.Parent then return end
scope13011.fireflies[part]={collide=part.CanCollide,anchored=part.Anchored}
scope13011.list[#scope13011.list+1]=part
jar.spawnedAt=os.clock()
pcall(function() part:SetAttribute(scope13011.MARK,true);part.CanCollide=false end)
pcall(function() scope13011.fireflies[part].massless=part.Massless;part.Massless=true end)
end
local offsets=setmetatable({}, {__mode="k"})
local blocking=setmetatable({}, {__mode="k"})
local offsetAnchor=setmetatable({}, {__mode="k"})
local pinned=setmetatable({}, {__mode="k"})
local function forget(part)
local saved=scope13011.fireflies[part]
if not saved then return end
uncalm(part)
scope13011.fireflies[part]=nil
offsets[part]=nil;offsetAnchor[part]=nil;pinned[part]=nil
local index=table.find(scope13011.list,part)
if index then table.remove(scope13011.list,index) end
if part.Parent then pcall(function() part.CanCollide=saved.collide;part:SetAttribute(scope13011.MARK,nil) end) end
if part.Parent and saved.massless~=nil then pcall(function() part.Massless=saved.massless end) end
end
local NOT_FIREFLY={"coin","bullet","knife","shell","bomb","handle","gun","toy","balloon","pet","visualsv2"}
local function notFirefly(part)
local named=part.Name:lower():find("firefl",1,true)~=nil
local current=part
for _=1,5 do
if not current or current==workspace then break end
local name=current.Name:lower()
if named then
if name:find("bomb",1,true) then return true end
else
for _,word in ipairs(NOT_FIREFLY) do if name:find(word,1,true) then return true end end
end
current=current.Parent
end
local bombFling=scope13011.runtime.BombFling
if bombFling and type(bombFling.IsBomb)=="function" then
local ok,bomb=pcall(bombFling.IsBomb,part)
if ok and bomb then return true end
end
return false
end
local BODY_PARTS={}
for _,name in ipairs({"head","torso","uppertorso","lowertorso","humanoidrootpart","lefthand","righthand","leftfoot","rightfoot",
"leftlowerarm","rightlowerarm","leftupperarm","rightupperarm","leftlowerleg","rightlowerleg","leftupperleg","rightupperleg",
"left arm","right arm","left leg","right leg"}) do BODY_PARTS[name]=true end
local function onItsOwn(part)
if BODY_PARTS[part.Name:lower()] then return false end
for _,plr in ipairs(Players:GetPlayers()) do
local character=plr.Character
if character and part:IsDescendantOf(character) then return false end
end
local okAssembly,assembly=pcall(function() return part.AssemblyRootPart end)
if okAssembly and assembly and assembly~=part then return false end
local okJoints,jointed=pcall(function()
local mine=LocalPlayer.Character
for _,joint in ipairs(part:GetJoints()) do
local other=nil
if joint:IsA("JointInstance") or joint:IsA("WeldConstraint") or joint:IsA("RigidConstraint") then
other=joint.Part0==part and joint.Part1 or joint.Part0
elseif joint:IsA("HingeConstraint") or joint:IsA("BallSocketConstraint") or joint:IsA("RopeConstraint")
or joint:IsA("RodConstraint") or joint:IsA("SpringConstraint") or joint:IsA("PrismaticConstraint")
or joint:IsA("CylindricalConstraint") or joint:IsA("PlaneConstraint") or joint:IsA("UniversalConstraint") then
local a,b=joint.Attachment0,joint.Attachment1
local pa,pb=a and a.Parent,b and b.Parent
other=(pa==part and pb) or (pb==part and pa) or nil
end
if other and other~=part and other:IsA("BasePart") and other:IsDescendantOf(workspace)
and not (mine and other:IsDescendantOf(mine)) then return true end
end
return false
end)
if okJoints and jointed then return false end
local okModel,inBig=pcall(function()
local model=part:FindFirstAncestorOfClass("Model")
if not model or model==workspace then return false end
if model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("Humanoid",true) then return true end
local pieces=0
for _,child in ipairs(model:GetDescendants()) do
if child:IsA("BasePart") and child~=part then
pieces=pieces+1
local size=child.Size
if pieces>60 or math.max(size.X,size.Y,size.Z)>2.5 then return true end
end
end
return false
end)
if okModel and inBig then return false end
return true
end
local function consider(part)
if not part:IsA("BasePart") or scope13011.fireflies[part] then return end
local name=part.Name:lower()
local named=name:find("firefl",1,true)~=nil
if not named and not scope13011.isMMV then return end
if notFirefly(part) then return end
local root=scope13011.myRoot()
if not root then return end
local recent=os.clock()-jar.usedAt<(scope13011.isMMV and 14 or 12)
if not named and not recent then return end
if part.Anchored or inCharacterOrTool(part) then return end
local size=part.Size
if math.max(size.X,size.Y,size.Z)>(named and 2.5 or 1.2) or math.min(size.X,size.Y,size.Z)<0.02 then return end
if not onItsOwn(part) then return end
if not named then
local model=part:FindFirstAncestorOfClass("Model")
if model and model~=workspace and (model:FindFirstChildOfClass("Humanoid") or (model.PrimaryPart and model.PrimaryPart~=part)) then return end
for _,child in ipairs(part:GetChildren()) do
if child:IsA("DataModelMesh") and not part:IsA("MeshPart") and child:IsA("SpecialMesh") and child.MeshId~="" then return end
if child:IsA("JointInstance") or child:IsA("WeldConstraint") or child:IsA("TouchTransmitter") then return end
end
end
local ok,distance=pcall(function() return (part.Position-root.Position).Magnitude end)
if not ok or distance>(named and 30 or 40) then return end
if named and not recent and not scope13011.owned(part) then return end
track(part)
end
local caps={}
local CAP_NAMES={handle2=true,lid=true,jarlid=true,jarcap=true,cap=true,cork=true}
local function considerCap(part)
if caps[part] or scope13011.fireflies[part] or not part:IsA("BasePart") or not CAP_NAMES[part.Name:lower()] then return end
if os.clock()-jar.usedAt>3 then return end
if inCharacterOrTool(part) or not onItsOwn(part) then return end
local size=part.Size
if math.max(size.X,size.Y,size.Z)>1.5 then return end
local bombFling=scope13011.runtime.BombFling
if bombFling and type(bombFling.IsBomb)=="function" then
local okBomb,bomb=pcall(bombFling.IsBomb,part)
if okBomb and bomb then return end
end
local root=scope13011.myRoot()
local ok,distance=pcall(function() return (part.Position-root.Position).Magnitude end)
if not ok or distance>8 then return end
local count=0
for _ in pairs(caps) do count=count+1 end
if count>=2 then return end
caps[part]={collide=part.CanCollide}
pcall(function() part.CanCollide=false;part.LocalTransparencyModifier=0 end)
end
local function forgetCap(part)
local saved=caps[part]
if not saved then return end
caps[part]=nil
if part.Parent then pcall(function() part.CanCollide=saved.collide end) end
end
local function hookJar(tool)
if not tool:IsA("Tool") or tool.Name~="Fireflies" or jar.hooked[tool] then return end
jar.hooked[tool]=true
jar.seenAt[tool]=os.clock()
tool.Activated:Connect(function()
if jar.busy then return end
jar.usedAt=os.clock();jar.waitingEnabled=true;jar.enabledBack=false
end)
tool.Equipped:Connect(function() if not jar.busy then jar.userAt=os.clock() end end)
tool:GetPropertyChangedSignal("Enabled"):Connect(function()
if tool.Enabled and jar.waitingEnabled then jar.enabledBack=true end
end)
end
local function jarTool()
for _,container in ipairs({LocalPlayer.Character,LocalPlayer:FindFirstChildOfClass("Backpack")}) do
local tool=container and container:FindFirstChild("Fireflies")
if tool and tool:IsA("Tool") then hookJar(tool);return tool end
end
end
local function jarReady(tool)
if not tool or tool.Enabled==false then return false end
if os.clock()<(jar.retryAt or 0) then return false end
if jar.enabledBack then return true end
return os.clock()-jar.usedAt>=(jar.cooldown or scope13011.JAR_COOLDOWN)
end
local HOLD=4.5
local function useJar()
if jar.busy then return end
local root,character=scope13011.myRoot()
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local backpack=LocalPlayer:FindFirstChildOfClass("Backpack")
local tool=jarTool()
if not root or not humanoid or humanoid.Health<=0 or not backpack or not jarReady(tool) then return end
if tool.Parent~=backpack or os.clock()-(jar.userAt or -math.huge)<6 then return end
jar.busy=true
scope13011.diagnostics.jarAttempts=scope13011.diagnostics.jarAttempts+1
task.spawn(function()
scope13011.runtime.FireflyAutoUseAt=os.clock()
local held=nil
for _,child in ipairs(character:GetChildren()) do
if child:IsA("Tool") and child~=tool then held=child;break end
end
local opened=false
local lastOpen,openedAt=nil,nil
local animator=humanoid:FindFirstChildOfClass("Animator")
local jarAnimation=tool:FindFirstChildWhichIsA("Animation")
local function jarTrack(trackObject)
local animation=trackObject.Animation
return animation and jarAnimation and animation.AnimationId==jarAnimation.AnimationId
end
local function markOpened()
if not opened then opened=true;openedAt=lastOpen or os.clock() end
end
local function still(trackObject)
if jarTrack(trackObject) then markOpened() end
end
local watcher=animator and animator.AnimationPlayed:Connect(still)
local disabled=tool:GetPropertyChangedSignal("Enabled"):Connect(function() if not tool.Enabled then markOpened() end end)
local before=jar.spawnedAt
local function out() return jar.spawnedAt>before end
local switched=false
local switchWatch=character.ChildAdded:Connect(function(child)
if child:IsA("Tool") and child~=tool and child~=held and child.Name~=tool.Name then switched=true end
end)
local function jarInHand()
if tool.Parent==character then return tool end
local other=character:FindFirstChild(tool.Name)
if other and other:IsA("Tool") then return other end
return nil
end
local function putBack()
if switched then return end
local inHand=jarInHand()
if held and held.Parent==character then
if inHand then pcall(function() inHand.Parent=backpack end) end
elseif held and held.Parent==backpack then pcall(function() humanoid:EquipTool(held) end)
elseif inHand then pcall(function() humanoid:UnequipTools() end) end
inHand=jarInHand()
if inHand then pcall(function() inHand.Parent=backpack end) end
end
pcall(function() humanoid:EquipTool(tool) end)
local deadline=os.clock()+0.6
while tool.Parent~=character and os.clock()<deadline and not switched do task.wait() end
if tool.Parent==character and not switched then
-- (until the jar has worked once since loading, it's given a moment in your hand first: right after
-- joining, the game's own jar script can take a little while to be ready, and a click before that
-- does nothing)
task.wait(jar.worked and 0.05 or 0.2)
local first=os.clock()
local clicks=0
local function open()
lastOpen=os.clock()
clicks=clicks+1
jar.usedAt=lastOpen;jar.waitingEnabled=true;jar.enabledBack=false
pcall(function() tool:Activate() end)
end
open()
-- (at most 3 clicks per try, half a second apart)
while tool.Parent==character and not out() and os.clock()-first<HOLD and not switched do
if not opened then
if os.clock()-first>(scope13011.isMMV and 2.4 or 1.5) then break end
if clicks<3 and os.clock()-lastOpen>=0.5 then open() end
end
task.wait(0.03)
end
if out() or opened then
if out() then scope13011.diagnostics.jarUses=scope13011.diagnostics.jarUses+1 end
local openedTime=openedAt or lastOpen or os.clock()
if jar.lastSuccessAt and (jar.failures or 0)>0 then
jar.cooldown=math.clamp(openedTime-jar.lastSuccessAt-0.15,4,20)
end
jar.lastSuccessAt=openedTime
scope13011.diagnostics.jarCooldown=jar.cooldown or scope13011.JAR_COOLDOWN
jar.failures=0;jar.retryAt=nil
jar.usedAt=openedTime
jar.worked=true
if out() then task.wait(0.25) end
else
jar.failures=(jar.failures or 0)+1
-- (a try that didn't work is tried again soon, at most 3 s later: right after executing the jar can just
-- still be cooling down from you using it. It's only given up on for the round after 3 in a row, and
-- never in the first 30 s after World V2 loads)
jar.retryAt=os.clock()+math.min(3,0.5*2^(jar.failures-1))
jar.usedAt=-math.huge
if not scope13011.isMMV and jar.failures>=3 and os.clock()-jar.loadedAt>30 and roundOn() and not jar.roundBlocked then
jar.roundBlocked=true;jar.roundBlockedAt=os.clock()
end
end
putBack()
local tools=scope13011.runtime.AutoGetTools
if tools and type(tools.RequestOrder)=="function" then pcall(tools.RequestOrder) end
else
local late=os.clock()+1
while not jarInHand() and os.clock()<late and not switched do task.wait() end
if jarInHand() then putBack() end
end
if watcher then watcher:Disconnect() end
disabled:Disconnect()
switchWatch:Disconnect()
jar.busy=false
local finishedAt=os.clock()
task.delay(0.8,function()
if switched or jar.busy or (jar.userAt or -math.huge)>finishedAt then return end
if LocalPlayer.Character~=character then return end
local inHand=jarInHand()
if inHand then
if held and held.Parent==backpack then pcall(function() humanoid:EquipTool(held) end) end
if inHand.Parent==character then pcall(function() inHand.Parent=backpack end) end
end
end)
end)
end
local rayParams=RaycastParams.new()
rayParams.FilterType=Enum.RaycastFilterType.Exclude
local filterKey,filterAt="",-math.huge
local function refreshFilter()
local ignore={}
local key={}
for _,plr in ipairs(Players:GetPlayers()) do
if plr.Character then ignore[#ignore+1]=plr.Character;key[#key+1]=tostring(plr.Character) end
end
key[#key+1]=tostring(#scope13011.list);key[#key+1]=tostring(scope13011.list[#scope13011.list])
for part in pairs(caps) do key[#key+1]=tostring(part) end
key=table.concat(key,"|")
if key==filterKey and os.clock()-filterAt<1 then return end
filterKey,filterAt=key,os.clock()
for _,part in ipairs(scope13011.list) do ignore[#ignore+1]=part end
for part in pairs(caps) do ignore[#ignore+1]=part end
local camera=workspace.CurrentCamera
if camera then ignore[#ignore+1]=camera end
rayParams.FilterDescendantsInstances=ignore
end
local function clear(from,to)
local direction=to-from
if direction.Magnitude<0.01 then return true end
return workspace:Raycast(from,direction,rayParams)==nil
end
local function inFront(from,point)
local direction=point-from
if direction.Magnitude<0.01 then return point end
local hit=workspace:Raycast(from,direction,rayParams)
return hit and hit.Position-direction.Unit*0.4 or point
end
local function flat(vector)
local v=Vector3.new(vector.X,0,vector.Z)
return v.Magnitude>0.05 and v.Unit or nil
end
local function frameFacing(center,facing)
local right=facing:Cross(Vector3.yAxis)
right=right.Magnitude>0.01 and right.Unit or Vector3.xAxis
return CFrame.fromMatrix(center,right,right:Cross(facing).Unit)
end
local function knifePart(object)
if object:IsA("BasePart") then return object end
return object:FindFirstChild("KnifeVisual",true) or object:FindFirstChildWhichIsA("BasePart",true)
end
local function considerKnife(object)
if scope13011.knives[object] or not object.Parent then return end
local name=object.Name:lower()
if name:sub(1,9)=="visualsv2" then return end
if name~="throwingknife" and name~="knifevisual" and not (object.Parent==workspace and name:find("knife",1,true)) then return end
if object.Parent and object.Parent.Name:lower()=="throwingknife" then object=object.Parent end
if scope13011.knives[object] or inCharacterOrTool(object) then return end
local part=knifePart(object)
if not part then return end
local now=os.clock()
scope13011.knives[object]={part=part,last=part.Position,at=now,lastMove=now}
end
local function riding(part,position)
local ok,attached=pcall(function()
local assembly=part.AssemblyRootPart
if assembly and assembly~=part and scope13011.fireflies[assembly] then return true end
for _,joint in ipairs(part:GetJoints()) do
local other=joint.Part0==part and joint.Part1 or joint.Part0
if other and scope13011.fireflies[other] then return true end
end
return false
end)
if ok and attached then return true end
for _,firefly in ipairs(scope13011.list) do
if not blocking[firefly] and (firefly.Position-position).Magnitude<1 then return "near" end
end
return false
end
local function updateKnives(dt)
for _,record in pairs(scope13011.knives) do record.flying=false end
local now=os.clock()
for object,record in pairs(scope13011.knives) do
local part=record.part
if not object.Parent or not part.Parent then scope13011.knives[object]=nil
else
local position=part.Position
local measured=dt>0 and (position-record.last)/math.max(dt,1/240) or Vector3.zero
local reported=Vector3.zero
pcall(function() if not part.Anchored then reported=part.AssemblyLinearVelocity end end)
record.last=position
local moving=measured.Magnitude>5
if moving then record.lastMove=now end
local raw=nil
if moving and reported.Magnitude>5 then
raw=reported.Unit:Dot(measured.Unit)>0.7 and reported.Unit or measured.Unit
elseif moving then raw=measured.Unit
elseif reported.Magnitude>5 then raw=reported.Unit end
local given=nil
pcall(function()
local value=part:GetAttribute("Direction")
if typeof(value)=="Vector3" and value.Magnitude>0.5 then given=value.Unit end
end)
if given then
if not record.heading or record.heading:Dot(given)<0.999 then record.length=nil end
record.heading=given;record.headingAt=now;record.exact=true
elseif raw then
if record.heading and record.heading:Dot(raw)>0.9 then
local blended=record.heading:Lerp(raw,0.35)
record.heading=blended.Magnitude>0.01 and blended.Unit or raw
else
record.heading=raw;record.length=nil
end
record.headingAt=now
end
local speed=math.max(measured.Magnitude,reported.Magnitude)
local onFirefly=riding(part,position)
if onFirefly then record.ridingSince=record.ridingSince or now else record.ridingSince=nil end
local stuck=onFirefly==true or (record.ridingSince~=nil and now-record.ridingSince>0.2)
local stillFor=now-record.lastMove
local againstOne=false
if reported.Magnitude>5 and stillFor>0.3 then
for _,firefly in ipairs(scope13011.list) do
if blocking[firefly] and (firefly.Position-position).Magnitude<1.2 then againstOne=true;break end
end
end
if record.done then
if moving and speed>40 and not onFirefly and now-record.done>0.2 then
record.done=nil;record.at=now;record.lastMove=now;record.length=nil;record.origin=position
end
elseif stuck or stillFor>((reported.Magnitude>5 and not againstOne) and 0.6 or 0.3) or now-record.at>2.5 then
record.done=now
scope13011.diagnostics.knivesDone=scope13011.diagnostics.knivesDone+1
end
record.flying=not record.done and speed>5
record.position=position
record.origin=record.origin or position
record.direction=speed>5 and record.heading or nil
if record.thrower==nil then
record.thrower=false
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer then
local other=scope13011.aliveRoot(plr)
if other and (other.Position-position).Magnitude<7 then record.thrower=other.Position;break end
end
end
end
end
end
end
local THROW_POSE={["1957618848"]=true,["15478370930"]=true}
local function aimingToThrow(plr)
local character=plr and plr.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if not humanoid then return false end
local animator=humanoid:FindFirstChildOfClass("Animator")
local ok,tracks=pcall(function() return (animator or humanoid):GetPlayingAnimationTracks() end)
if not ok or type(tracks)~="table" then return false end
for _,track in ipairs(tracks) do
local name,id="",nil
pcall(function() name=tostring(track.Name):lower() end)
if name:find("throwcharge",1,true) or name:find("throwhold",1,true) then return true end
pcall(function() id=track.Animation and tostring(track.Animation.AnimationId):match("(%d+)%s*$") end)
if id and THROW_POSE[id] then return true end
end
return false
end
local function throwOrigin(threat)
local character=threat.player.Character
local held=character and character:FindFirstChildOfClass("Tool")
local handle=held and held.Name:lower():find("knife",1,true) and held:FindFirstChild("Handle")
if handle and handle:IsA("BasePart") and (handle.Position-threat.root.Position).Magnitude<6 then return handle.Position end
return threat.root.Position+Vector3.new(0,1.5,0)
end
local function knifeInHand(plr)
local character=plr and plr.Character
local held=character and character:FindFirstChildOfClass("Tool")
return held~=nil and held.Name:lower():find("knife",1,true)~=nil
end
local KNIFE_SPEED=110
local ping={at=-math.huge,value=nil}
local function reactTime()
local now=os.clock()
if now-ping.at>0.5 then
ping.at=now
local ok,value=pcall(function() return LocalPlayer:GetNetworkPing() end)
if ok and type(value)=="number" and value>0 and value<5 then
ping.value=ping.value and ping.value+(value-ping.value)*0.5 or value
end
end
return math.clamp(ping.value or 0.15,0.02,1.5)*1.2+0.06
end
local function pingText() return ("%d ms"):format(math.floor((ping.value or 0.15)*1000+0.5)) end
local function knifeThreats(root,reach,guessAim)
if guessAim==nil then guessAim=true end
local farthest=math.clamp(60*(reach or 1),60,300)
local center=root.Position+scope13011.LIFT
local threats={}
local now=os.clock()
for object,record in pairs(scope13011.knives) do
local part=record.part
local position=record.position
if not record.done and position and object.Parent and part.Parent then
local fromHand=guessAim and not record.exact and record.thrower and (record.thrower-center).Magnitude<25
local direction
if record.heading and now-(record.headingAt or 0)<0.3 then direction=record.heading
elseif fromHand and now-record.at<0.2 and (center-position).Magnitude>0.5 then direction=(center-position).Unit
else direction=part.CFrame.LookVector end
local toMe=center-position
local distance=toMe.Magnitude
if distance<=farthest and distance>0.5 then
local along=toMe:Dot(direction)
local heading=along/distance
if along>0 and heading>0.55 then
local closest=position+direction*along
if (center-closest).Magnitude<6 then
threats[#threats+1]={position=position,closest=closest,direction=direction,along=along,record=record,root=root}
end
end
end
end
end
table.sort(threats,function(a,b) return a.along<b.along end)
return threats
end
local function areaThreats(me,radius,reach)
local byRecord={}
for _,threat in ipairs(knifeThreats(me,reach,true)) do byRecord[threat.record]=threat end
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and scope13011.role(plr)~="murderer" and not scope13011.hasTool(plr,"knife") then
local other=scope13011.aliveRoot(plr)
if other and (other.Position-me.Position).Magnitude<=radius then
for _,threat in ipairs(knifeThreats(other,reach,false)) do
threat.player=plr
local first=byRecord[threat.record]
if not first or threat.along<first.along then byRecord[threat.record]=threat end
end
end
end
end
local list={}
for _,threat in pairs(byRecord) do list[#list+1]=threat end
table.sort(list,function(a,b) return a.along<b.along end)
return list
end
local function threatReach() return scope13011.settings.interceptStop end
local function interceptReach() return math.max(scope13011.settings.interceptStop,scope13011.INTERCEPT_STUDS)/scope13011.INTERCEPT_STUDS end
local function gridOffsets(count,width,height)
local cells={}
local columns=math.max(1,math.ceil(math.sqrt(count*width/height)))
local rows=math.max(1,math.ceil(count/columns))
local stepX=columns>1 and width/(columns-1) or 0
local stepY=rows>1 and height/(rows-1) or 0
for row=0,rows-1 do
for column=0,columns-1 do
cells[#cells+1]=Vector3.new(-width/2+column*stepX,-height/2+row*stepY+0.4,0)
end
end
table.sort(cells,function(a,b) return a.Magnitude<b.Magnitude end)
return cells
end
local function wallSpots(count,width,height)
local spots={}
for index,cell in ipairs(gridOffsets(count,width,height)) do
if index>count then break end
spots[#spots+1]=cell
end
for _,cell in ipairs(gridOffsets(count+10,width+1.2,height+1.2)) do
local taken=false
for index=1,count do if spots[index] and (spots[index]-cell).Magnitude<0.35 then taken=true;break end end
if not taken then spots[#spots+1]=cell end
end
return spots
end
local function orbitSpots(count,radius,speed,time)
local spots={}
for index=1,count do
local angle=(index/math.max(count,1))*math.pi*2+time*speed
local height=math.sin(time*speed*1.25+index)*1.2
spots[#spots+1]=Vector3.new(math.cos(angle)*radius,height,math.sin(angle)*radius)
end
return spots
end
-- Firefly Symbols: the shapes, drawn in a box 1 stud high (x across, y up), as strokes the
-- fireflies are spread along and dots that get a firefly (or a few) each
scope13011.SYMBOLS=(function()
local function arc(cx,cy,radius,from,to,steps)
local points={}
for index=0,steps do
local angle=math.rad(from+(to-from)*index/steps)
points[#points+1]=Vector2.new(cx+math.cos(angle)*radius,cy+math.sin(angle)*radius)
end
return points
end
local hook=arc(0,0.72,0.24,160,-90,25)
hook[#hook+1]=Vector2.new(0,0.3)
return {
["?"]={strokes={hook},dots={Vector2.new(0,0.06)}},
["!"]={strokes={{Vector2.new(0,1),Vector2.new(0,0.4)}},dots={Vector2.new(0,0.04)}},
["Line & Dots"]={strokes={{Vector2.new(0,1),Vector2.new(0,0.52)}},dots={Vector2.new(-0.2,0.2),Vector2.new(0.2,0.2)},dotMin=2},
-- (the "()" drawn as an outer ( ) with a smaller ( ) inside it, a gap left at the top and bottom
-- of each pair; the halves are filled as mirrored pairs, and an odd firefly sits in the middle)
["()"]={strokes={arc(0.42,0.5,0.8,140,220,12),arc(-0.42,0.5,0.8,40,-40,12),arc(0.1,0.5,0.25,128,232,10),arc(-0.1,0.5,0.25,52,-52,10)},
dots={},paired=true,centered=true,minHeight=2.4,weights={1,1,1.7,1.7}},
-- (faces stand upright like an emoji: two eyes on top, the mouth under them)
[":3"]={strokes={{Vector2.new(-0.32,0.44),Vector2.new(-0.16,0.2),Vector2.new(0,0.4),Vector2.new(0.16,0.2),Vector2.new(0.32,0.44)}},dots={Vector2.new(-0.22,0.78),Vector2.new(0.22,0.78)},minHeight=1.8},
[":)"]={strokes={arc(0,0.55,0.35,205,335,12)},dots={Vector2.new(-0.22,0.8),Vector2.new(0.22,0.8)},minHeight=1.8},
[":]"]={strokes={{Vector2.new(-0.3,0.42),Vector2.new(-0.3,0.2),Vector2.new(0.3,0.2),Vector2.new(0.3,0.42)}},
dots={Vector2.new(-0.22,0.8),Vector2.new(0.22,0.8)},minHeight=1.8},
[":D"]={strokes={(function()
local mouth={Vector2.new(0,0.45),Vector2.new(0.32,0.45)}
for _,point in ipairs(arc(0,0.45,0.32,0,-180,14)) do mouth[#mouth+1]=point end
mouth[#mouth+1]=Vector2.new(0,0.45)
return mouth
end)()},dots={Vector2.new(-0.22,0.82),Vector2.new(0.22,0.82)},closed=true,minHeight=1.8},
[";)"]={strokes={arc(-0.22,0.7,0.12,160,20,6),arc(0,0.55,0.35,205,335,12)},dots={Vector2.new(0.22,0.8)},minHeight=1.8},
-- (the frowning bracket mouth is the :] one turned over, the corners pointing down)
[":["]={strokes={{Vector2.new(-0.3,0.2),Vector2.new(-0.3,0.42),Vector2.new(0.3,0.42),Vector2.new(0.3,0.2)}},
dots={Vector2.new(-0.22,0.8),Vector2.new(0.22,0.8)},minHeight=1.8},
[";["]={strokes={arc(-0.22,0.7,0.12,160,20,6),{Vector2.new(-0.3,0.2),Vector2.new(-0.3,0.42),Vector2.new(0.3,0.42),Vector2.new(0.3,0.2)}},
dots={Vector2.new(0.22,0.8)},minHeight=1.8},
[":/"]={strokes={{Vector2.new(-0.3,0.22),Vector2.new(0.3,0.46)}},dots={Vector2.new(-0.22,0.8),Vector2.new(0.22,0.8)},minHeight=1.8},
[":|"]={strokes={{Vector2.new(-0.3,0.34),Vector2.new(0.3,0.34)}},dots={Vector2.new(-0.22,0.8),Vector2.new(0.22,0.8)},minHeight=1.8},
-- (a heart outline, and a five-pointed star, both started at the top so they come out even)
["<3"]={strokes={(function()
local heart={}
for index=0,40 do
local t=index/40*2*math.pi
local x=16*math.sin(t)^3
local y=13*math.cos(t)-5*math.cos(2*t)-2*math.cos(3*t)-math.cos(4*t)
heart[#heart+1]=Vector2.new(x/34,(y+17)/30)
end
return heart
end)()},dots={},closed=true,minHeight=1.6},
["Star"]={strokes={(function()
local star={}
for index=0,10 do
local radius=index%2==0 and 0.5 or 0.2
local angle=math.rad(90+index*36)
star[#star+1]=Vector2.new(math.cos(angle)*radius,0.5+math.sin(angle)*radius)
end
return star
end)()},dots={},closed=true,minHeight=1.8},
}
end)()
-- (the chosen symbol over your head, facing your camera, sized so the fireflies there (7 to 14
-- usually) sit close together, about 0.42 studs apart along its lines)
function scope13011.symbolSpots(count,time)
local spots={}
if count<=0 then return spots end
local shape=scope13011.SYMBOLS[scope13011.settings.symbol] or scope13011.SYMBOLS["?"]
local dotsEach=#shape.dots>0 and math.clamp(math.floor(count/12),shape.dotMin or 1,3) or 0
local onDots=math.min(#shape.dots*dotsEach,count)
local onLines=count-onDots
local lengths,total={},0
for index,stroke in ipairs(shape.strokes) do
local length=0
for point=2,#stroke do length=length+(stroke[point]-stroke[point-1]).Magnitude end
lengths[index]=length;total=total+length
end
local height=math.clamp(onLines*0.42/math.max(total,0.1),shape.minHeight or 1.3,3.2)
local camera=workspace.CurrentCamera
local look=camera and Vector3.new(camera.CFrame.LookVector.X,0,camera.CFrame.LookVector.Z) or Vector3.zero
if look.Magnitude<0.05 then look=Vector3.new(0,0,-1) end
look=look.Unit
local right=Vector3.new(-look.Z,0,look.X)
local base=Vector3.new(0,3+math.sin(time*2)*0.12,0)
local function place(point) return base+right*(point.X*height)+Vector3.new(0,point.Y*height,0) end
local function along(stroke,distance)
for point=2,#stroke do
local piece=(stroke[point]-stroke[point-1]).Magnitude
if distance<=piece or point==#stroke then
return stroke[point-1]:Lerp(stroke[point],piece>0 and math.clamp(distance/piece,0,1) or 0)
end
distance=distance-piece
end
return stroke[#stroke]
end
-- (each stroke gets its share of the fireflies, spread from one end to the other; mirrored
-- strokes get the same share, with an odd one left over put in the middle)
local shares={}
local left=onLines
if shape.paired then
if left%2==1 then spots[#spots+1]=place(Vector2.new(0,0.5));left=left-1 end
local pairsLeft=left/2
-- (a stroke's weight gives it more than its length's share, so the small inner ( ) still curves)
local weighted=0
for index=1,#shape.strokes do weighted=weighted+lengths[index]*(shape.weights and shape.weights[index] or 1) end
local pairCount=pairsLeft
for index=1,#shape.strokes,2 do
local weight=shape.weights and shape.weights[index] or 1
local share=index+1>=#shape.strokes and pairsLeft or math.min(pairsLeft,math.floor(pairCount*lengths[index]*2*weight/math.max(weighted,0.1)+0.5))
pairsLeft=pairsLeft-share
shares[index],shares[index+1]=share,share
end
else
for index=1,#shape.strokes do
local share=index==#shape.strokes and left or math.min(left,math.floor(onLines*lengths[index]/math.max(total,0.1)+0.5))
left=left-share
shares[index]=share
end
end
for index,stroke in ipairs(shape.strokes) do
local share=shares[index] or 0
for point=1,share do
local at=shape.closed and (point-1)/share*lengths[index]
or shape.centered and (point-0.5)/share*lengths[index]
or share==1 and lengths[index]/2 or (point-1)/(share-1)*lengths[index]
spots[#spots+1]=place(along(stroke,at))
end
end
for _,dot in ipairs(shape.dots) do
for point=1,dotsEach do
if #spots>=count then break end
-- (a dot with more than one firefly: a small cluster 0.13 studs out from the middle, a pair
-- stacked one over the other so two dots side by side don't read as a line)
local angle=point*2*math.pi/dotsEach+math.pi/2
local offset=dotsEach>1 and Vector2.new(math.cos(angle),math.sin(angle))*(0.13/height) or Vector2.zero
spots[#spots+1]=place(dot+offset)
end
end
return spots
end
local function ringSpots(count,radius,heights,spin,lookYaw,gap)
gap=gap or 0
local spots={}
local perRing=math.max(1,math.ceil(count/#heights))
local arc=2*math.pi-2*gap
for ringIndex,height in ipairs(heights) do
for index=1,perRing do
local around
if gap>0 then
around=arc*((index-0.5)/perRing)+math.sin(spin+ringIndex*0.7)*(arc/perRing)*0.45
else
around=arc*((index-0.5)/perRing)+spin+ringIndex*0.7
end
local yaw=lookYaw+gap+around
spots[#spots+1]=Vector3.new(-math.sin(yaw)*radius,height,-math.cos(yaw)*radius)
end
end
return spots
end
local pointer={touches={},mouseDown=false,lastAt=-math.huge,lastWorld=nil,pendingTap=nil,connections={}}
do
local LINGER=4
local TAP_MOVE=12
local HOLD_STILL=0.35
local TAP_TIME=0.45
local function onTouchControls(position)
local ok,inside=pcall(function()
local playerGui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
local touchGui=playerGui and playerGui:FindFirstChild("TouchGui")
if not touchGui then return false end
for _,name in ipairs({"DynamicThumbstickFrame","ThumbstickFrame","JumpButton"}) do
local frame=touchGui:FindFirstChild(name,true)
if frame and frame:IsA("GuiObject") and frame.Visible then
local at,size=frame.AbsolutePosition,frame.AbsoluteSize
if position.X>=at.X and position.X<=at.X+size.X and position.Y>=at.Y and position.Y<=at.Y+size.Y then return true end
end
end
return false
end)
return ok and inside==true
end
local function watchPointer()
if #pointer.connections>0 then return end
local touchType,mouseType=Enum.UserInputType.Touch,Enum.UserInputType.MouseButton1
pointer.connections[1]=scope13011.UserInput.InputBegan:Connect(function(input,processed)
if input.UserInputType==touchType then
local position=Vector2.new(input.Position.X,input.Position.Y)
if processed or onTouchControls(position) then return end
pointer.touches[input]={start=position,position=position,at=os.clock(),drag=false,held=false}
elseif input.UserInputType==mouseType and not processed then
pointer.mouseDown=true;pointer.lastAt=os.clock()
end
end)
pointer.connections[2]=scope13011.UserInput.InputChanged:Connect(function(input)
local touch=pointer.touches[input]
if not touch then return end
touch.position=Vector2.new(input.Position.X,input.Position.Y)
if not touch.held and (touch.position-touch.start).Magnitude>TAP_MOVE then touch.drag=true end
end)
pointer.connections[3]=scope13011.UserInput.InputEnded:Connect(function(input)
local touch=pointer.touches[input]
if touch then
pointer.touches[input]=nil
if not touch.drag then
if touch.held then pointer.lastAt=os.clock()
elseif os.clock()-touch.at<=TAP_TIME then pointer.pendingTap={position=touch.position,at=os.clock()} end
end
elseif input.UserInputType==mouseType and pointer.mouseDown then
pointer.mouseDown=false;pointer.lastAt=os.clock()
end
end)
end
local function cancelPointer()
pointer.lastWorld=nil;pointer.pendingTap=nil;pointer.lastAt=-math.huge
end
local function unwatchPointer()
for _,connection in ipairs(pointer.connections) do pcall(function() connection:Disconnect() end) end
table.clear(pointer.connections);table.clear(pointer.touches)
pointer.mouseDown=false;pointer.pendingTap=nil
end
local function pointerScreen()
local newest=nil
for _,touch in pairs(pointer.touches) do
if not touch.drag and (touch.held or os.clock()-touch.at>=HOLD_STILL) then
touch.held=true
if not newest or touch.at>newest.at then newest=touch end
end
end
if newest then return newest.position,false end
if pointer.mouseDown then
local ok,location=pcall(function() return scope13011.UserInput:GetMouseLocation() end)
if ok and typeof(location)=="Vector2" then return location,true end
end
local tap=pointer.pendingTap
if tap then
pointer.pendingTap=nil
if os.clock()-tap.at<LINGER then return tap.position,false end
end
end
local function pointerWorld(center)
local screen,viewport=pointerScreen()
local point=nil
if screen then
pcall(function()
local camera=workspace.CurrentCamera
local ray=viewport and camera:ViewportPointToRay(screen.X,screen.Y) or camera:ScreenPointToRay(screen.X,screen.Y)
local hit=workspace:Raycast(ray.Origin,ray.Direction.Unit*400,rayParams)
point=hit and (hit.Position+(hit.Normal or Vector3.yAxis)*1.2) or (ray.Origin+ray.Direction.Unit*40)
end)
if typeof(point)=="Vector3" then pointer.lastWorld=point;pointer.lastAt=os.clock() else point=nil end
end
if not point and pointer.lastWorld and os.clock()-pointer.lastAt<LINGER then point=pointer.lastWorld end
if not point then return nil end
local offset=point-center
if offset.Magnitude>scope13011.MOUSE_RANGE then point=center+offset.Unit*scope13011.MOUSE_RANGE end
return point
end
pointer.watch,pointer.unwatch,pointer.cancel,pointer.world=watchPointer,unwatchPointer,cancelPointer,pointerWorld
end
local function swarmSpots(count,point,center,time)
local spots={}
for index=1,count do
local angle=(index/math.max(count,1))*math.pi*2+time*2.2
local radius=0.6+0.35*math.sin(time*2.6+index)
local height=math.sin(time*1.7+index*1.3)*0.7
spots[#spots+1]=point+Vector3.new(math.cos(angle)*radius,height,math.sin(angle)*radius)-center
end
return spots
end
local function usable(center,spots,need)
need=need or #spots
local result={}
local skipped=0
for _,spot in ipairs(spots) do
if clear(center,spot) then result[#result+1]=spot else skipped=skipped+1 end
if #result>=need then break end
end
scope13011.diagnostics.skippedSlots=skipped
if #result==0 then
for _,spot in ipairs(spots) do
result[#result+1]=inFront(center,spot)
if #result>=need then break end
end
end
return result
end
local clock=0
local slotOf=setmetatable({}, {__mode="k"})
local slotKey=nil
local function assignSlots(parts,points,key)
local valid=key==slotKey
if valid then
for _,part in ipairs(parts) do if not slotOf[part] then valid=false;break end end
end
if valid then return slotOf end
slotKey=key
table.clear(slotOf)
local taken={}
local spotCount=#points
for index,part in ipairs(parts) do
if index>spotCount then slotOf[part]=index
else
local best,bestDistance=nil,math.huge
local position=part.Position
for slot=1,spotCount do
if not taken[slot] then
local distance=(points[slot]-position).Magnitude
if distance<bestDistance then best,bestDistance=slot,distance end
end
end
best=best or index
taken[best]=true
slotOf[part]=best
end
end
return slotOf
end
local function setBlocking(part,value)
if (blocking[part]==true)==value then return end
blocking[part]=value or nil
pcall(function() part.CanCollide=value end)
end
local shuffleOrder,shuffleAt={},0
local function shuffled(count)
for index=#shuffleOrder+1,count do shuffleOrder[index]=index end
for index=#shuffleOrder,count+1,-1 do shuffleOrder[index]=nil end
local seen={}
for index=1,count do
local value=shuffleOrder[index]
if type(value)~="number" or value<1 or value>count or seen[value] then
for reset=1,count do shuffleOrder[reset]=reset end
break
end
seen[value]=true
end
if os.clock()-shuffleAt>=0.25 and count>1 then
shuffleAt=os.clock()
for _=1,math.max(1,math.floor(count/3)) do
local a,b=math.random(1,count),math.random(1,count)
shuffleOrder[a],shuffleOrder[b]=shuffleOrder[b],shuffleOrder[a]
end
end
return shuffleOrder
end
local GOLDEN=math.pi*(3-math.sqrt(5))
local own={margin=1,me=Vector3.zero,others={}}
function own.refresh(me,except)
own.me=me.Position
table.clear(own.others)
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LocalPlayer and plr~=except then
local character=plr.Character
local other=character and character:FindFirstChild("HumanoidRootPart")
if other then own.others[#own.others+1]=other.Position end
end
end
end
function own.mine(point)
local mine=(point-own.me).Magnitude
for _,position in ipairs(own.others) do
if (point-position).Magnitude<mine+own.margin then return false end
end
return true
end
local skyCells={}
local function scatter(n)
local x=math.sin(n*12.9898+78.233)*43758.5453
return x-math.floor(x)
end
local function skySpots(count,time)
for index=#skyCells+1,count do
local angle=scatter(index*5+1)*math.pi*2
local out=3+scatter(index*5+2)*9
skyCells[index]={offset=Vector3.new(math.cos(angle)*out,20+scatter(index*5+3)*10,math.sin(angle)*out),
phase=scatter(index*5+4)*math.pi*2,speed=0.25+scatter(index*5+5)*0.35}
end
local spots={}
for index=1,count do
local cell=skyCells[index]
local t=time*cell.speed+cell.phase
spots[index]=cell.offset+Vector3.new(math.sin(t)*2.2,math.sin(t*1.3+1)*1.2,math.cos(t*0.9)*2.2)
end
return spots
end
local CROSS={Vector2.new(0,0),Vector2.new(0.45,0),Vector2.new(-0.45,0),Vector2.new(0,0.45),Vector2.new(0,-0.45)}
local function interceptPoints(threat,count,studs,fixedAt)
local direction=threat.direction
local side=direction:Cross(Vector3.yAxis)
side=side.Magnitude>0.01 and side.Unit or Vector3.xAxis
local up=side:Cross(direction)
up=up.Magnitude>0.01 and up.Unit or Vector3.yAxis
local record=threat.record
local from=fixedAt or 2.2*scope13011.settings.blockScale
local length
if fixedAt then
length=math.clamp(threat.along-from,0.5,2.6)
else
local far=math.max(math.min(studs,threat.along-0.3),0.5)
from=math.min(from,far)
length=far-from
if record then
if not record.length or record.lengthStuds~=studs or record.lengthRoot~=threat.root or record.lengthScale~=scope13011.settings.blockScale then
record.length=length;record.lengthFrom=from;record.lengthStuds=studs;record.lengthRoot=threat.root;record.lengthScale=scope13011.settings.blockScale
end
length,from=record.length,record.lengthFrom
end
end
local perRow=math.min(#CROSS,math.max(count,1))
local rows=math.max(1,math.ceil(count/perRow))
local points={}
for n=1,count do
local row=math.floor((n-1)/perRow)
local lane=CROSS[(n-1)%perRow+1]
local out=fixedAt and from+row*(length/rows) or from+(rows>1 and row*length/(rows-1) or 0)
points[#points+1]=threat.closest-direction*out+side*lane.X+up*lane.Y
end
return points
end
local function clusterSpots(threat,center,count)
local direction=threat.direction
local miss=(center-threat.closest).Magnitude
local body=1.6*scope13011.settings.blockScale
local depth=math.sqrt(math.max(0,body*body-miss*miss))
local impact=threat.closest-direction*(depth+0.8*scope13011.settings.blockScale)
local side=direction:Cross(Vector3.yAxis)
side=side.Magnitude>0.01 and side.Unit or Vector3.xAxis
local up=side:Cross(direction).Unit
local spots={}
local onLine=math.min(count,count>=6 and 2 or 1)
for k=1,onLine do spots[#spots+1]=impact-direction*((k-1)*0.7) end
local rest=count-onLine
local radius=math.clamp(0.65+0.2*math.sqrt(count),1.2,1.9)
local perLayer=math.max(1,math.min(rest,30))
for index=1,rest do
local layer=math.floor((index-1)/perLayer)
local i=(index-1)%perLayer
local inLayer=math.min(perLayer,rest-layer*perLayer)
local r=radius*math.sqrt((i+0.5)/inLayer)
local angle=i*GOLDEN+layer*0.9
spots[#spots+1]=impact-direction*(layer*0.6)+side*math.cos(angle)*r+up*math.sin(angle)*r
end
return spots,impact
end
local blocksClutch=false
-- (in Assassin everyone has a knife, so having one doesn't make you the murderer: protection keeps
-- going, and there's no "paused while you are the murderer" notice)
local function assassinNow()
local roles=scope13011.runtime.Roles
if not roles or type(roles.Assassin)~="function" then return false end
local ok,yes=pcall(roles.Assassin)
return ok and yes==true
end
local function murdererMe(root)
if scope13011.isMMV or not iHaveKnife() or assassinNow() then return false end
return not root or #attackers(root)<2
end
local function computeBlocksClutch(root)
if not scope13011.protecting() then return false end
-- (Firefly Symbols keep the fireflies from Firefly Clutch too, even as the murderer)
if scope13011.settings.symbols then return true end
if not scope13011.isMMV and iHaveKnife() and not assassinNow() then return false end
return true
end
local holding=false
local function letGo()
table.clear(offsets);table.clear(offsetAnchor);table.clear(pinned)
for part in pairs(blocking) do setBlocking(part,false) end
if holding then
holding=false
for _,part in ipairs(scope13011.list) do uncalm(part) end
end
end
local roundArea={}
do
local roundMap={at=-math.huge,box=nil}
function roundMap.get()
if os.clock()-roundMap.at<2 then return roundMap.box end
roundMap.at=os.clock();roundMap.box=nil
for _,top in ipairs(workspace:GetChildren()) do
local holder,container=top,top:FindFirstChild("CoinContainer")
if not container then
for _,child in ipairs(top:GetChildren()) do
container=child:FindFirstChild("CoinContainer")
if container then holder=child;break end
end
end
if container then
local ok,cframe,size=pcall(function() return holder:GetBoundingBox() end)
if ok and typeof(cframe)=="CFrame" and typeof(size)=="Vector3" then roundMap.box={cframe=cframe,size=size} end
break
end
end
return roundMap.box
end
local function inMap(position)
local box=roundMap.get()
if not box then return false end
local at=box.cframe:PointToObjectSpace(position)
local half=box.size/2+Vector3.new(40,80,40)
return math.abs(at.X)<=half.X and math.abs(at.Y)<=half.Y and math.abs(at.Z)<=half.Z
end
roundArea.inMap=inMap
end
local calmAt=0
local upvals14946={KNIFE_SPEED=KNIFE_SPEED,LocalPlayer=LocalPlayer,Players=Players,aimingToThrow=aimingToThrow,areaThreats=areaThreats,assignSlots=assignSlots,attackers=attackers,calm=calm,caps=caps,clear=clear,clusterSpots=clusterSpots,clutchBusy=clutchBusy,flat=flat,forget=forget,forgetCap=forgetCap,frameFacing=frameFacing,iHaveKnife=iHaveKnife,inCharacterOrTool=inCharacterOrTool,inFront=inFront,interceptPoints=interceptPoints,interceptReach=interceptReach,knifeInHand=knifeInHand,knifeThreats=knifeThreats,letGo=letGo,murdererMe=murdererMe,notFirefly=notFirefly,offsetAnchor=offsetAnchor,offsets=offsets,onItsOwn=onItsOwn,orbitSpots=orbitSpots,own=own,ping=ping,pingText=pingText,pinned=pinned,pointer=pointer,reactTime=reactTime,refreshFilter=refreshFilter,refreshRound=refreshRound,ringSpots=ringSpots,roundArea=roundArea,scope13011=scope13011,setBlocking=setBlocking,shared=shared,shuffled=shuffled,skySpots=skySpots,swarmSpots=swarmSpots,threatReach=threatReach,throwOrigin=throwOrigin,updateKnives=updateKnives,usable=usable,wallSpots=wallSpots}
local function step(dt)
clock=clock+dt
local me,character=upvals14946.scope13011.myRoot()
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
for index=#upvals14946.scope13011.list,1,-1 do
local part=upvals14946.scope13011.list[index]
if not part.Parent or not part:IsDescendantOf(workspace) or upvals14946.notFirefly(part) then upvals14946.forget(part) end
end
for part in pairs(upvals14946.caps) do
if not part.Parent or not part:IsDescendantOf(workspace) or upvals14946.inCharacterOrTool(part) then upvals14946.forgetCap(part) end
end
upvals14946.scope13011.diagnostics.fireflies=#upvals14946.scope13011.list
upvals14946.scope13011.diagnostics.active=false
if not me or not humanoid then upvals14946.scope13011.diagnostics.threat="no character";upvals14946.letGo();return end
upvals14946.refreshRound()
if upvals14946.murdererMe(me) and not upvals14946.scope13011.settings.symbols then
upvals14946.scope13011.diagnostics.threat="you are the murderer (paused)";upvals14946.scope13011.diagnostics.mode="paused"
upvals14946.letGo()
if os.clock()-upvals14946.scope13011.murdererNotice>60 then
upvals14946.scope13011.murdererNotice=os.clock()
pcall(upvals14946.shared.Notify,"Firefly Protection is paused while you are the murderer",3)
end
return
end
if upvals14946.clutchBusy() and not upvals14946.scope13011.settings.symbols then upvals14946.scope13011.diagnostics.threat="Firefly Clutch is using them";upvals14946.scope13011.diagnostics.mode="clutch";upvals14946.letGo();return end
local selfMode={shield=upvals14946.scope13011.settings.shield,intercept=upvals14946.scope13011.settings.intercept,sky=upvals14946.scope13011.settings.sky}
upvals14946.own.refresh(me)
upvals14946.refreshFilter()
local ownedCount=0
for _,part in ipairs(upvals14946.scope13011.list) do if upvals14946.scope13011.owned(part) then ownedCount=ownedCount+1 end end
upvals14946.scope13011.diagnostics.owned=ownedCount
if upvals14946.scope13011.protecting() then upvals14946.updateKnives(dt) end
if #upvals14946.scope13011.list==0 then upvals14946.scope13011.diagnostics.threat=upvals14946.scope13011.settings.autoJar and "waiting for the jar" or "no fireflies (use your jar)";upvals14946.letGo();return end
if not holding or os.clock()-calmAt>0.5 then
holding=true;calmAt=os.clock()
for index=#upvals14946.scope13011.list,1,-1 do
local part=upvals14946.scope13011.list[index]
if upvals14946.onItsOwn(part) then upvals14946.calm(part) else upvals14946.forget(part) end
end
for part in pairs(upvals14946.caps) do if not upvals14946.onItsOwn(part) then upvals14946.forgetCap(part) end end
end
local function nearOf(body,except)
local found={}
local from=body.Position+upvals14946.scope13011.LIFT
for _,threat in ipairs(upvals14946.attackers(body,except)) do
if threat.distance<=upvals14946.scope13011.RANGE then
threat.seen=upvals14946.clear(from,threat.root.Position+Vector3.new(0,1,0))
found[#found+1]=threat
end
end
return found
end
local function knivesAt(body,way,threats)
if not (way.shield or way.intercept or way.sky) or #threats==0 then return {} end
if way.intercept then return upvals14946.areaThreats(body,upvals14946.scope13011.settings.interceptArea,upvals14946.interceptReach()) end
return upvals14946.knifeThreats(body,1)
end
local near=nearOf(me)
local root,mode=me,selfMode
local knivesComing=knivesAt(root,mode,near)
local mineKnife=upvals14946.iHaveKnife()
local center=root.Position+upvals14946.scope13011.LIFT
local targets={}
local anchorOf={}
local solid={}
local free={}
for _,part in ipairs(upvals14946.scope13011.list) do free[#free+1]=part end
for part in pairs(upvals14946.caps) do free[#free+1]=part end
local lookYaw=math.atan2(-root.CFrame.LookVector.X,-root.CFrame.LookVector.Z)
local function take(point)
local best,bestIndex,bestDistance=nil,nil,math.huge
for index,part in ipairs(free) do
local distance=(part.Position-point).Magnitude
if distance<bestDistance then best,bestIndex,bestDistance=part,index,distance end
end
if best then targets[best]=point;solid[best]=true;table.remove(free,bestIndex) end
return best
end
local close={}
for _,threat in ipairs(near) do
if threat.seen or threat.distance<=upvals14946.scope13011.NEAR then close[#close+1]=threat end
end
local needed=#close>0
local kind=nil
local active=false
-- (with Firefly Symbols on, Knife Shield and Knife Interception (hidden or not) still take the
-- fireflies while a knife is coming at you, and they go back into the symbol after; as the
-- murderer, where symbols keep going, nothing is thrown at you so they stay in the symbol)
local watchKnives=(mode.shield or mode.intercept or mode.sky) and #near>0
and not (upvals14946.scope13011.settings.symbols and upvals14946.murdererMe(me))
if watchKnives and #knivesComing>0 then
local threat=knivesComing[1]
do
local spots,impact=nil,nil
local threatCenter=threat.root and threat.root.Position+upvals14946.scope13011.LIFT or center
if mode.shield then spots,impact=upvals14946.clusterSpots(threat,threatCenter,#free) end
if spots then
for _,point in ipairs(spots) do if #free==0 then break end;take(point) end
upvals14946.scope13011.diagnostics.lastImpact=impact
kind="blocking a knife"
else
local studs=upvals14946.threatReach(threat)
local fixedAt=mode.sky and upvals14946.scope13011.settings.distance*upvals14946.scope13011.settings.blockScale or nil
local count=#free
local rows=upvals14946.interceptPoints(threat,count,studs,fixedAt)
for _,point in ipairs(rows) do take(point) end
kind=mode.shield and "blocking a knife" or (threat.player and ("intercepting a knife at "..threat.player.Name) or "intercepting a knife")
end
end
if kind then
active=true
upvals14946.scope13011.diagnostics.intercepts=upvals14946.scope13011.diagnostics.intercepts+1
end
end
local aimer=nil
if not active and (mode.shield or mode.intercept) and not mode.sky and not mineKnife then
for _,threat in ipairs(near) do
if threat.seen and threat.distance<=80 and upvals14946.aimingToThrow(threat.player) then
local look=upvals14946.flat(threat.root.CFrame.LookVector)
local toward=upvals14946.flat(center-threat.root.Position)
if look and toward and look:Dot(toward)>0.5 then aimer=threat;break end
end
end
end
local tooClose=false
if not aimer and not active and (mode.shield or mode.intercept) and not mineKnife then
local need=upvals14946.reactTime()
local blockAt=(mode.shield and 2.4 or 2.2)*upvals14946.scope13011.settings.blockScale
upvals14946.scope13011.diagnostics.readyRange=blockAt+need*upvals14946.KNIFE_SPEED
for _,threat in ipairs(near) do
if threat.seen and upvals14946.knifeInHand(threat.player) then
local from=upvals14946.throwOrigin(threat)
if ((center-from).Magnitude-blockAt)/upvals14946.KNIFE_SPEED<need then aimer=threat;tooClose=true;break end
end
end
end
upvals14946.scope13011.diagnostics.ping=upvals14946.ping.value
upvals14946.scope13011.diagnostics.aimer=aimer and aimer.player.Name or nil
local function readyLabel()
if tooClose then return "ready for "..aimer.player.Name.." (too close to react at "..upvals14946.pingText().." ping)" end
return "ready for a throw from "..aimer.player.Name
end
local virtualThrow=nil
local function readyFor(threat)
if virtualThrow==nil then
virtualThrow=false
local from=upvals14946.throwOrigin(threat)
local toward=center-from
if toward.Magnitude>0.5 then
virtualThrow={position=from,direction=toward.Unit,along=toward.Magnitude,closest=center,root=root}
end
end
return virtualThrow or nil
end
local defending=watchKnives and #knivesComing>0
defending=defending or ((mode.shield or mode.intercept) and #close>0)
upvals14946.scope13011.diagnostics.defending=defending
local guarded=(mode.shield or mode.intercept or mode.sky) and #near>0
local pointAt=nil
-- (Hidden Knife Interception with Follow Taps/Mouse on: the fireflies keep following until a knife is
-- actually coming, instead of waiting up high whenever the murderer is near)
local hiddenFollow=mode.sky and not mode.shield and not mode.intercept and upvals14946.scope13011.settings.mouse
if defending or (guarded and not hiddenFollow) then upvals14946.pointer.cancel()
elseif upvals14946.scope13011.settings.mouse and not upvals14946.scope13011.settings.symbols then pointAt=upvals14946.pointer.world(center) end
local spots=nil
local grid=false
local count=#free
local orbit=false
local swarm=false
local sky=false
local ready=false
local function idle(radius,speed,label)
if pointAt then
swarm=true
kind=kind or "following the mouse"
return upvals14946.swarmSpots(count,pointAt,center,clock)
end
orbit=true
if upvals14946.scope13011.settings.symbols then
kind=kind or ("firefly symbol "..upvals14946.scope13011.settings.symbol)
return upvals14946.scope13011.symbolSpots(count,clock)
end
kind=kind or label
return upvals14946.orbitSpots(count,radius,speed,clock)
end
local function rest(radius,speed,label)
local standby=guarded
if standby and type(upvals14946.scope13011.roundData)=="table" then
local mine=upvals14946.scope13011.roundData[upvals14946.LocalPlayer.Name]
if type(mine)=="table" and (mine.Dead==true or mine.Killed==true) and not upvals14946.roundArea.inMap(me.Position) then standby=false end
end
if pointAt or upvals14946.scope13011.settings.ring or upvals14946.scope13011.settings.symbols or standby then return idle(radius,speed,label) end
sky=true
kind=kind or "waiting up high"
return upvals14946.skySpots(count,clock)
end
local function roundYou()
kind=kind or "behind a wall (far, all round you)"
return upvals14946.ringSpots(count+8,upvals14946.scope13011.settings.distance,{1.2,0,-1},clock*1.6,lookYaw)
end
if count>0 and upvals14946.scope13011.settings.symbols then
orbit=true
kind="firefly symbol "..upvals14946.scope13011.settings.symbol
spots=upvals14946.scope13011.symbolSpots(count,clock)
elseif count>0 then
if mode.shield and #near>0 and (needed or not pointAt) then
local murderer=near[1]
active=true
if mineKnife then
spots=upvals14946.ringSpots(count+8,upvals14946.scope13011.settings.distance,{1.5,0.3,-1.2},clock*1.8,lookYaw,math.rad(55))
kind=kind or "assassin (front open)"
elseif #near>=2 then
spots=upvals14946.ringSpots(count+8,upvals14946.scope13011.settings.distance,{1.5,0.3,-1.2},clock*1.8,lookYaw)
kind=kind or (#near.." knives (all round you)")
elseif aimer and readyFor(aimer) then
local virtual=readyFor(aimer)
spots={}
for _,point in ipairs((upvals14946.clusterSpots(virtual,center,count))) do spots[#spots+1]=point-center end
ready=true
kind=kind or readyLabel()
else
local aim=murderer.root.Position+Vector3.new(0,1,0)
if murderer.seen or murderer.distance<=upvals14946.scope13011.NEAR then
local direction=(aim-center)
local horizontal=upvals14946.flat(direction) or root.CFrame.LookVector
local pitch=math.clamp(math.atan2(direction.Y,Vector3.new(direction.X,0,direction.Z).Magnitude),math.rad(-60),math.rad(60))
local facing=(horizontal*math.cos(pitch)+Vector3.new(0,math.sin(pitch),0)).Unit
upvals14946.scope13011.smoothDirection=upvals14946.scope13011.smoothDirection and upvals14946.scope13011.smoothDirection:Lerp(facing,math.clamp(upvals14946.scope13011.FOLLOW*dt,0,1)) or facing
if upvals14946.scope13011.smoothDirection.Magnitude<0.01 then upvals14946.scope13011.smoothDirection=facing end
local frame=upvals14946.frameFacing(center,upvals14946.scope13011.smoothDirection.Unit)
spots={}
local away=direction.Magnitude
local wallAt=upvals14946.scope13011.settings.distance*upvals14946.scope13011.settings.blockScale
local out=upvals14946.scope13011.smoothDirection.Unit
if not upvals14946.own.mine(center+out*wallAt) then
while wallAt>0.8 and not upvals14946.own.mine(center+out*wallAt) do wallAt=wallAt-0.2 end
wallAt=math.max(wallAt,0.8)
end
local scale=math.clamp((away-wallAt)/math.max(away,0.1),0.45,1)
for _,cell in ipairs(upvals14946.wallSpots(count,3.2*scale,5*scale)) do
spots[#spots+1]=frame:PointToWorldSpace(Vector3.new(cell.X,cell.Y,-wallAt))-center
end
grid=true
kind=kind or (murderer.seen and "in sight" or "behind a wall (near)")
else
spots=roundYou()
end
end
elseif aimer and not mode.shield then
local virtual=readyFor(aimer)
if virtual then
local studs=upvals14946.scope13011.settings.interceptStop
local wanted=count
spots={}
for _,point in ipairs(upvals14946.interceptPoints(virtual,wanted,studs)) do spots[#spots+1]=point-center end
ready=true
active=true
kind=kind or readyLabel()
else
spots=rest(upvals14946.scope13011.settings.distance,upvals14946.scope13011.settings.mm2RingSpeed*0.8,"idle")
end
elseif mode.sky and not pointAt then
spots=upvals14946.skySpots(count,clock)
sky=true
kind=kind or "hidden up high"
else
spots=rest(upvals14946.scope13011.settings.distance,upvals14946.scope13011.settings.mm2RingSpeed*0.8,"idle")
end
end
kind=kind or "idle"
if not grid then upvals14946.scope13011.smoothDirection=nil end
upvals14946.scope13011.diagnostics.threat=kind;upvals14946.scope13011.diagnostics.mode=kind;upvals14946.scope13011.diagnostics.active=active
if spots then
local points={}
for _,offset in ipairs(spots) do points[#points+1]=center+offset end
if not swarm then
for index,point in ipairs(points) do
if not upvals14946.own.mine(point) then
local toward=point-center
local fixed=nil
if sky then
local flatOut=Vector3.new(toward.X,0,toward.Z)
for _,keep in ipairs({0.6,0.25,0}) do
local candidate=center+Vector3.new(0,toward.Y,0)+flatOut*keep
if upvals14946.own.mine(candidate) then fixed=candidate;break end
end
fixed=fixed or point
end
if not fixed then
local share=1
while share>0.3 and not upvals14946.own.mine(center+toward*share) do share=share-0.15 end
fixed=center+toward*math.max(share,0.3)
end
points[index]=fixed
end
end
end
if orbit then
for index,point in ipairs(points) do
if not upvals14946.clear(center,point) then points[index]=upvals14946.inFront(center,point) end
end
elseif not swarm and not sky then
points=upvals14946.usable(center,points,count)
end
local order=grid and upvals14946.scope13011.settings.ring and upvals14946.shuffled(#free) or nil
local key=(grid and "g" or orbit and "o" or swarm and "s" or sky and "k" or ready and "a" or "r")..#points..":"..#free
local stable=not order and upvals14946.assignSlots(free,points,key)
for index,part in ipairs(free) do
local slot=order and order[index] or stable and stable[part] or index
local point=points[(slot-1)%#points+1]
if point then
if slot>#points then point=point+Vector3.new(0,0.35*math.floor((slot-1)/#points),0) end
targets[part]=point
end
end
end
for _,part in ipairs(upvals14946.scope13011.list) do upvals14946.setBlocking(part,solid[part]==true) end
local alpha=math.clamp(1-math.exp(-dt*18),0,1)
for part,target in pairs(targets) do
pcall(function()
local anchor=anchorOf[part] or root
local base=anchor.Position+upvals14946.scope13011.LIFT
local wanted=target-base
local current=upvals14946.offsets[part]
if upvals14946.offsetAnchor[part]~=anchor or not current then current=part.Position-base end
local snap=solid[part] and not anchorOf[part]
if snap or (wanted-current).Magnitude>14 then current=wanted
else current=current:Lerp(wanted,alpha) end
upvals14946.offsets[part]=current;upvals14946.offsetAnchor[part]=anchor
upvals14946.pinned[part]=snap or nil
part.CFrame=CFrame.new(base+current)
part.AssemblyLinearVelocity=snap and Vector3.zero or anchor.AssemblyLinearVelocity
part.AssemblyAngularVelocity=Vector3.zero
end)
end
for part in pairs(upvals14946.offsets) do
if not targets[part] then upvals14946.offsets[part]=nil;upvals14946.offsetAnchor[part]=nil;upvals14946.pinned[part]=nil end
end
end
local function holdInPlace()
for part,offset in pairs(offsets) do
if not pinned[part] and (scope13011.fireflies[part] or caps[part]) then
local anchor=offsetAnchor[part]
if anchor and anchor.Parent then
pcall(function() part.CFrame=CFrame.new(anchor.Position+scope13011.LIFT+offset) end)
end
end
end
end
local statusAt=0
local sweepAt=0
local sweepParams=OverlapParams.new()
sweepParams.FilterType=Enum.RaycastFilterType.Exclude
local function sweep()
local busy=os.clock()-math.max(jar.usedAt,jar.spawnedAt)<12
if os.clock()-sweepAt<(busy and (scope13011.isMMV and 0.5 or 0.25) or 3) then return end
sweepAt=os.clock()
local root,character=scope13011.myRoot()
if not root then return end
sweepParams.FilterDescendantsInstances={character}
local radius=busy and 30 or 20
local ok,parts=pcall(function() return workspace:GetPartBoundsInRadius(root.Position,radius,sweepParams) end)
if not ok or type(parts)~="table" then return end
for _,part in ipairs(parts) do
if not scope13011.fireflies[part] then pcall(consider,part);pcall(considerCap,part) end
end
end
local function refreshClutchTimer()
local root=scope13011.myRoot()
local now=computeBlocksClutch(root)
if now==blocksClutch then return end
blocksClutch=now
local clutch=scope13011.runtime.FireflyClutch
if clutch and type(clutch.RefreshTimer)=="function" then pcall(clutch.RefreshTimer) end
end
local function statusText()
if not scope13011.active() then return "Off" end
local text=string.format("Fireflies: %d | %s",scope13011.diagnostics.fireflies,scope13011.diagnostics.active and "Active" or "Idle")
local problem=scope13011.diagnostics.error
if problem then text=text.." | Error: "..(tostring(problem):gsub("^[^\n:]*:(%d+): ","line %1: ")):sub(1,140) end
return text
end
local function stopWatching()
if scope13011.loop then scope13011.loop:Disconnect();scope13011.loop=nil end
if scope13011.placeLoop then scope13011.placeLoop:Disconnect();scope13011.placeLoop=nil end
end
local function watch()
if scope13011.watchAdded then return end
for _,object in ipairs(workspace:GetChildren()) do considerKnife(object) end
scope13011.watchAdded=workspace.DescendantAdded:Connect(function(object)
if object:IsA("BasePart") then
task.delay(0.05,function() if object.Parent then consider(object);considerCap(object) end end)
end
local name=object.Name:lower()
if name=="throwingknife" or name=="knifevisual" or (object.Parent==workspace and name:find("knife",1,true)) then
task.defer(considerKnife,object)
end
end)
scope13011.watchRemoved=workspace.DescendantRemoving:Connect(function(object)
if scope13011.fireflies[object] then forget(object) end
if caps[object] then forgetCap(object) end
if scope13011.knives[object] then scope13011.knives[object]=nil end
end)
end
local function start()
if scope13011.loop then return end
watch()
for _,part in ipairs(scope13011.list) do pcall(function() part.CanCollide=false end) end
local root=scope13011.myRoot()
if root then
local params=OverlapParams.new()
params.FilterType=Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances={LocalPlayer.Character}
local ok,parts=pcall(function() return workspace:GetPartBoundsInRadius(root.Position,30,params) end)
if ok then for _,part in ipairs(parts) do consider(part) end end
end
jarTool()
scope13011.loop=RunService.Heartbeat:Connect(function(dt)
if not runtimeAlive then return end
pcall(sweep)
local ok,err=pcall(step,tonumber(dt) or 1/60)
scope13011.diagnostics.error=not ok and tostring(err) or nil
if os.clock()-statusAt>0.5 then pcall(refreshClutchTimer) end
if scope13011.status and os.clock()-statusAt>0.5 then
statusAt=os.clock()
pcall(function() scope13011.status:SetValue(statusText()) end)
end
end)
pointer.watch()
scope13011.placeLoop=RunService.RenderStepped:Connect(function()
if runtimeAlive then holdInPlace() end
end)
end
local function stop()
stopWatching()
pointer.unwatch()
letGo()
for _,part in ipairs(scope13011.list) do
local saved=scope13011.fireflies[part]
if saved and part.Parent then pcall(function() part.CanCollide=saved.collide end) end
end
scope13011.smoothDirection=nil
for part in pairs(caps) do forgetCap(part) end
if scope13011.status then pcall(function() scope13011.status:SetValue("Off") end) end
end
local function jarNeeded(root)
if #scope13011.list>=scope13011.MAX_FIREFLIES then return false end
if scope13011.settings.ring or scope13011.settings.mouse or scope13011.settings.symbols then return true end
local sinceChange=os.clock()-math.max(jar.respawnAt or -math.huge,jar.teleportAt or -math.huge)
if sinceChange<20 and scope13011.protecting() then return true end
for _,threat in ipairs(attackers(root)) do
if threat.distance<=scope13011.RANGE then return true end
end
return false
end
local function autoStep()
local settings=scope13011.settings
if not settings.autoJar or not runtimeAlive or jar.busy then return end
if not (settings.shield or settings.intercept or settings.sky or settings.symbols) then return end
local root,character=scope13011.myRoot()
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health<=0 then return end
local now=os.clock()
if jar.lastRootPosition and (root.Position-jar.lastRootPosition).Magnitude>50 then jar.teleportAt=now end
jar.lastRootPosition=root.Position
if jar.roundBlocked then
local moved=math.max(jar.respawnAt or -math.huge,jar.teleportAt or -math.huge)>(jar.roundBlockedAt or 0)
if moved or not roundOn() then
jar.roundBlocked=false;jar.failures=0;jar.retryAt=nil
else
scope13011.diagnostics.jarRound=true
return
end
end
scope13011.diagnostics.jarRound=false
local tool=jarTool()
if not tool then
-- (no jar on you: it's fetched the way Auto Get Tools fetches toys, then Auto Get Tools is asked
-- to put your hotbar back in its chosen order)
local tools=scope13011.runtime.AutoGetTools
local busy=false
if tools and type(tools.Busy)=="function" then
local ok,value=pcall(tools.Busy)
busy=ok and value==true
end
local trade=scope13011.runtime.Trade
if busy or jar.fetching or now<(jar.fetchAt or 0) or (trade and trade.active) then return end
jar.fetching=true;jar.fetchAt=now+3
task.spawn(function()
pcall(function()
local remotes=scope13011.ReplicatedStorage:FindFirstChild("Remotes")
local extras=remotes and remotes:FindFirstChild("Extras")
local remote=extras and extras:FindFirstChild("ReplicateToy")
if remote and remote:IsA("RemoteFunction") then remote:InvokeServer("Fireflies") end
end)
jar.fetching=false
if tools and type(tools.RequestOrder)=="function" then pcall(tools.RequestOrder) end
end)
return
end
if not jarReady(tool) then return end
refreshRound()
if murdererMe(root) and not scope13011.settings.symbols then return end
if clutchBusy() and not scope13011.settings.symbols then return end
local sinceChange=now-math.max(jar.respawnAt or -math.huge,jar.teleportAt or -math.huge)
if sinceChange<0.3 then return end
-- (a jar that just reached your backpack is left a moment first, longer until one has worked since
-- World V2 loaded: on a fresh join the game itself isn't ready for it straight away)
if not jar.worked then
local loaded=true
pcall(function() loaded=game:IsLoaded() end)
if not loaded or now-jar.loadedAt<2 or sinceChange<1 then return end
end
if now-(jar.seenAt[tool] or now)<(jar.worked and 0.3 or 0.5) then return end
local tools=scope13011.runtime.AutoGetTools
if tools and type(tools.Busy)=="function" then
local ok,busy=pcall(tools.Busy)
if ok and busy then
jar.toolsBusySince=jar.toolsBusySince or now
jar.toolsBusyAt=now
if now-jar.toolsBusySince<12 then return end
else
jar.toolsBusySince=nil
end
end
if now-(jar.toolsBusyAt or -math.huge)<0.1 and not jar.toolsBusySince then return end
if not jarNeeded(root) then scope13011.diagnostics.jarIdle=true;return end
scope13011.diagnostics.jarIdle=false
useJar()
end
local function refresh()
if scope13011.active() then start() else stop() end
pcall(refreshClutchTimer)
if scope13011.settings.autoJar and not scope13011.autoLoop then
local elapsed=0
scope13011.autoLoop=RunService.Heartbeat:Connect(function(dt)
elapsed=elapsed+dt
if elapsed<0.05 then return end
elapsed=0
pcall(autoStep)
end)
elseif not scope13011.settings.autoJar and scope13011.autoLoop then
scope13011.autoLoop:Disconnect();scope13011.autoLoop=nil
end
end
local controls={}
local KEYS={shield="fireflyProtectShield",intercept="fireflyProtectIntercept",sky="fireflyProtectHidden",
ring="fireflyProtectRing",mouse="fireflyProtectMouse",autoJar="fireflyProtectAutoJar",symbols="fireflySymbolsEnabled"}
local GROUPS={{"shield","intercept","sky"}}
local function groupOf(field)
for _,group in ipairs(GROUPS) do if table.find(group,field) then return group end end
end
for _,group in ipairs(GROUPS) do
local seen=false
for _,field in ipairs(group) do
if scope13011.settings[field] then
if seen then scope13011.settings[field]=false;SetCfg(KEYS[field],false) end
seen=true
end
end
end
local RETRIES={0,0.15,0.4,0.8,1.5,2.5,4}
local function switchOff(other)
local controller=controls[other]
if controller and not scope13011.settings[other] then pcall(function() controller:Set(false) end) end
end
local function add(name,field,after)
controls[field]=addToggle(scope13011.section,name,scope13011.settings[field],function(value)
scope13011.settings[field]=value;SetCfg(KEYS[field],value)
if after then pcall(after,value) end
if value then
for _,other in ipairs(groupOf(field) or {}) do
if other~=field then
scope13011.settings[other]=false;SetCfg(KEYS[other],false)
for _,delay in ipairs(RETRIES) do
if delay==0 then task.defer(switchOff,other) else task.delay(delay,switchOff,other) end
end
end
end
end
refresh()
end)
end
if scope13011.isMMV then
-- (MMV: Firefly Symbols only, with the jar used for you if you want)
pcall(function()
scope13011.section:AddParagraph("Firefly Symbols","The fireflies from your Firefly Jar form the chosen symbol over your head.")
end)
add("Auto Use Firefly Jar","autoJar")
else
add("Knife Shield (for yourself)","shield")
add("Knife Interception","intercept")
add("Hidden Knife Interception (Least effective)","sky")
pcall(function()
scope13011.section:AddParagraph("Only One At A Time","You can only use one of three functions at a time. Turning one on will disable the previously enabled function.")
end)
pcall(function() scope13011.section:AddLabel("Firefly Options") end)
add("Firefly Ring Aura","ring")
add("Follow Taps/Mouse","mouse")
add("Auto Use Firefly Jar","autoJar")
scope13011.section:AddSlider("Firefly Ring/Shield Distance",1.01,4,scope13011.settings.distance,function(value)
scope13011.settings.distance=math.clamp(tonumber(value) or 2.2,1,4);SetCfg("fireflyProtectDistance",scope13011.settings.distance)
end)
scope13011.section:AddSlider("Firefly Ring Speed",1,5,scope13011.settings.mm2RingSpeed,function(value)
scope13011.settings.mm2RingSpeed=math.clamp(tonumber(value) or 2,1,5);SetCfg("fireflyMM2RingSpeed",scope13011.settings.mm2RingSpeed)
end)
pcall(function()
scope13011.section:AddParagraph("Firefly Symbols","When enabled, the fireflies always stay in the symbol over your head, in the lobby and in rounds (even as the murderer): it replaces the Firefly Ring Aura. Knife Shield and Knife Interception (hidden or not) still take the fireflies while a knife is coming at you, then they go back into the symbol.")
end)
end
add("Enable Firefly Symbols","symbols")
scope13011.symbolDropdown=addDropdown(scope13011.section,"Firefly Symbol",scope13011.SYMBOL_NAMES,scope13011.settings.symbol,function(value)
if not table.find(scope13011.SYMBOL_NAMES,value) then return false end
scope13011.settings.symbol=value;SetCfg("fireflySymbol",value)
end)
scope13011.runtime.FireflyProtection={
Active=scope13011.active,
DisableAll=function()
for _,field in ipairs({"shield","intercept","sky","ring","symbols","mouse","autoJar"}) do
if controls[field] then controls[field]:Set(false) end
scope13011.settings[field]=false
end
refresh()
end,
UseJar=useJar,
-- (no bombs are used by Firefly Protection any more)
UsesFakeBomb=function() return false end,
UsesGoldBomb=function() return false end,
CurrentBomb=function() return nil end,
BlocksClutch=function() return computeBlocksClutch(scope13011.myRoot()) end,
}
local respawn=LocalPlayer.CharacterAdded:Connect(function()
for _,part in ipairs(table.clone(scope13011.list)) do forget(part) end
scope13011.smoothDirection=nil
jar.busy=false
jar.respawnAt=os.clock()
end)
scope13011.runtime.RegisterReset(function()
for _,controller in pairs(controls) do pcall(function() controller:Set(false) end) end
scope13011.settings.shield,scope13011.settings.intercept,scope13011.settings.autoJar,scope13011.settings.ring,scope13011.settings.mouse=false,false,false,false,false
scope13011.settings.sky=false
scope13011.settings.symbols,scope13011.settings.symbol=false,"?"
if runtimeAlive and scope13011.symbolDropdown then pcall(function() scope13011.symbolDropdown:Select("?") end) end
scope13011.settings.distance=2.2
scope13011.settings.mm2RingSpeed=2
if scope13011.autoLoop then scope13011.autoLoop:Disconnect();scope13011.autoLoop=nil end
stop()
for _,part in ipairs(table.clone(scope13011.list)) do forget(part) end
table.clear(scope13011.knives)
if not runtimeAlive then
respawn:Disconnect()
if scope13011.watchAdded then scope13011.watchAdded:Disconnect();scope13011.watchAdded=nil end
if scope13011.watchRemoved then scope13011.watchRemoved:Disconnect();scope13011.watchRemoved=nil end
end
end)
if scope13011.active() then task.defer(refresh) end
end,"Section \"Firefly Protection\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local section=mainTab:AddSection("GGsign Glide","Utilities")
local DEFAULTS={spin=65,force=50}
local DETECTION=6
local HANG=1.1
local WALL_GAP=1.6
local spinSpeed=math.clamp(tonumber(C("ggsignSpinSpeed",DEFAULTS.spin)) or DEFAULTS.spin,0,150)
local moveForce=math.clamp(tonumber(C("ggsignMoveForce",DEFAULTS.force)) or DEFAULTS.force,10,100)
local connection
local angle=0
local gliding=false
local heading=0
local focus,savedSubject
local rayParams=RaycastParams.new()
rayParams.FilterType=Enum.RaycastFilterType.Exclude
local FRAME="VisualsV2_GGsignGlide"
local function turnsPerSecond() return spinSpeed/20 end
local function cameraFollow(root)
local camera=workspace.CurrentCamera
if not camera then return end
if not focus or not focus.Parent then
focus=Instance.new("Part")
focus.Name="VisualsV2_GlideCameraFocus"
focus.Anchored=true;focus.CanCollide=false;focus.CanQuery=false;focus.CanTouch=false
focus.Transparency=1;focus.Size=Vector3.new(0.2,0.2,0.2)
focus.CFrame=CFrame.new(root.Position+Vector3.new(0,1.5,0))
focus.Parent=workspace.CurrentCamera
end
if camera.CameraSubject~=focus then
savedSubject=camera.CameraSubject
camera.CameraSubject=focus
end
end
local function cameraRelease()
local camera=workspace.CurrentCamera
if camera and focus and camera.CameraSubject==focus then
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
camera.CameraSubject=(savedSubject and savedSubject.Parent and savedSubject) or humanoid or camera.CameraSubject
end
savedSubject=nil
if focus then focus:Destroy();focus=nil end
end
local function release(humanoid)
angle=0
if not gliding then return end
gliding=false
cameraRelease()
if humanoid and humanoid:GetState()==Enum.HumanoidStateType.Physics then
humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end
end
local function stop()
if connection then connection:Disconnect();connection=nil end
pcall(function() RunService:UnbindFromRenderStep(FRAME) end)
local character=LocalPlayer.Character
release(character and character:FindFirstChildOfClass("Humanoid"))
end
local function step(deltaTime)
if not runtimeAlive then stop();return end
local character=LocalPlayer.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health<=0 then if gliding then release(humanoid) end;return end
local tool=character:FindFirstChildOfClass("Tool")
local hit=nil
if tool and tool.Name=="GGSign" then
rayParams.FilterDescendantsInstances={character}
hit=workspace:Raycast(root.Position,Vector3.new(0,DETECTION+HANG,0),rayParams)
if hit and not gliding and hit.Distance>DETECTION then hit=nil end
end
if not hit then
if gliding then release(humanoid) end
return
end
if not gliding then
gliding=true
local look=workspace.CurrentCamera and workspace.CurrentCamera.CFrame.LookVector or root.CFrame.LookVector
heading=math.atan2(-look.X,-look.Z)
end
local camera=workspace.CurrentCamera
if camera then
local look=camera.CFrame.LookVector
if Vector3.new(look.X,0,look.Z).Magnitude>0.1 then heading=math.atan2(-look.X,-look.Z) end
end
local move=humanoid.MoveDirection
local horizontal=Vector3.new(move.X,0,move.Z)
if horizontal.Magnitude>1 then horizontal=horizontal.Unit end
local velocity=horizontal*moveForce
local delta=velocity*deltaTime
if delta.Magnitude>0 then
local function blocked(way)
local ignore={character}
for _=1,4 do
rayParams.FilterDescendantsInstances=ignore
local wall=workspace:Raycast(root.Position,way.Unit*(way.Magnitude+WALL_GAP),rayParams)
if not wall then return nil end
if wall.Instance.CanCollide then return wall end
ignore[#ignore+1]=wall.Instance
end
return nil
end
local wall=blocked(delta)
if wall then
local normal=Vector3.new(wall.Normal.X,0,wall.Normal.Z)
if normal.Magnitude>0.01 then
normal=normal.Unit
delta=delta-normal*delta:Dot(normal)
velocity=velocity-normal*velocity:Dot(normal)
end
if delta.Magnitude<0.001 or blocked(delta) then delta=Vector3.zero;velocity=Vector3.zero end
end
rayParams.FilterDescendantsInstances={character}
end
local goalY=hit.Position.Y-HANG
local position=root.Position+delta
local y=position.Y+(goalY-position.Y)*math.clamp(deltaTime*12,0,1)
angle=(angle+turnsPerSecond()*360*deltaTime)%360
root.CFrame=CFrame.new(position.X,y,position.Z)*CFrame.Angles(0,heading,0)
*CFrame.Angles(math.rad(90),0,math.rad(angle))
root.AssemblyLinearVelocity=Vector3.new(velocity.X,0,velocity.Z)
root.AssemblyAngularVelocity=Vector3.zero
if humanoid:GetState()~=Enum.HumanoidStateType.Physics then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
cameraFollow(root)
if focus then
local target=root.Position+Vector3.new(0,1.5,0)
focus.CFrame=CFrame.new(focus.Position:Lerp(target,math.clamp(deltaTime*20,0,1)))
end
end
local function start()
if connection then return end
local ok=pcall(function()
RunService:BindToRenderStep(FRAME,Enum.RenderPriority.Camera.Value-1,function(deltaTime)
pcall(step,deltaTime)
end)
end)
connection=ok and {Disconnect=function() pcall(function() RunService:UnbindFromRenderStep(FRAME) end) end}
or RunService.RenderStepped:Connect(step)
end
local glideToggle=addToggle(section,"GGsign Glide",C("ggsignGlideEnabled",false),function(state)
SetCfg("ggsignGlideEnabled",state)
if state then start() else stop() end
end)
local sliders={}
sliders.spin=section:AddSlider("Spin Speed",0,150,spinSpeed,function(value)
spinSpeed=math.clamp(tonumber(value) or DEFAULTS.spin,0,150)
SetCfg("ggsignSpinSpeed",spinSpeed)
end)
sliders.force=section:AddSlider("Move Force",10,100,moveForce,function(value)
moveForce=math.clamp(tonumber(value) or DEFAULTS.force,10,100)
SetCfg("ggsignMoveForce",moveForce)
end)
local function setSlider(slider,value)
if type(slider)~="table" then return false end
for _,name in ipairs({"SetValue","Set","Update"}) do
if type(slider[name])=="function" and pcall(slider[name],slider,value) then return true end
end
return false
end
local removing=LocalPlayer.CharacterRemoving:Connect(function() angle=0;gliding=false;cameraRelease() end)
env.WorldV2Runtime.RegisterReset(function()
glideToggle:Set(false)
stop()
if not runtimeAlive then removing:Disconnect();return end
spinSpeed,moveForce=DEFAULTS.spin,DEFAULTS.force
setSlider(sliders.spin,spinSpeed);setSlider(sliders.force,moveForce)
end)
end,"Section \"GGsign Glide\"")
;w2Section(function()
-- (kept outside the obfuscation VM: finding the hotbar walks every function in memory, far too slow
-- inside the VM, and the debug library has to see these functions as they are)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local section=mainTab:AddSection("Increase Inventory","Utilities")
section:AddParagraph(
"Increase Inventory",
"Increases the number of tools you can carry, up to 10."
)
local inventoryEnabled=C("inventoryUnlimiterEnabled",false)
local inventoryLimit=math.clamp(tonumber(C("inventoryMaxItems",10)) or 10,3,10)
local autoGetTools=C("autoGetTools",false)
local TOY_SLOTS=6
local selectedToys={
C("autoToySlot1","None"), C("autoToySlot2","None"),
C("autoToySlot3","None"), C("autoToySlot4","None"),
C("autoToySlot5","None"), C("autoToySlot6","None"),
}
if tonumber(C("autoToySelectionVersion",0))<1 then
if selectedToys[1]=="RCCar26" and selectedToys[2]=="RCCar26" then
selectedToys[2]="SprayPaint"
SetCfg("autoToySlot2","SprayPaint")
end
SetCfg("autoToySelectionVersion",1)
end
local alive=true
local recoveryToken=0
local recoveryRunning=false
local recoveryCharacter=nil
local removingCharacter=nil
local recoveryDeadline=0
local rescanRequested=false
local toyAttempts={}
local activeToyRequest=nil
local toyOrderDirty=true
local orderingBackpack=false
local observedBackpack=nil
local backpackConnections={}
local characterConnections={}
local toyConnections={}
local guiConnections={}
local lifecycleConnections={}
local dropdowns={}
local refreshingDropdowns=false
local guiRefreshToken=0
local requestRecovery,refreshToyDropdowns
local function disconnectAll(connections)
for _,connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
table.clear(connections)
end
local function trading()
local trade=env.WorldV2Runtime.Trade
return trade~=nil and trade.active==true
end
local function weaponKind(tool)
local kinds=env.WorldV2Runtime.ClientWeaponSkins
if kinds and type(kinds.GetKind)=="function" then
local ok,kind=pcall(kinds.GetKind,tool)
if ok and kind then return kind end
end
return nil
end
-- Increase Inventory: the game's hotbar keeps how many slots it shows (3, or 10) as a number inside its
-- own functions. Those functions are found in memory (by their names, or by the hotbar words they use)
-- and that number is set to Max Items; it's looked for again after every respawn and whenever the
-- game's screens are rebuilt, and checked every 2 seconds so it never drops back.
local getgc=getgc or env.getgc
local getupvalues=(debug and debug.getupvalues) or getupvalues or env.getupvalues
local setupvalue=(debug and debug.setupvalue) or setupvalue or env.setupvalue
local getinfo=(debug and debug.getinfo) or getinfo or env.getinfo
local getconstants=(debug and debug.getconstants) or getconstants or env.getconstants
local iscclosure=iscclosure or env.iscclosure
local debugInfo=debug and debug.info
local patched=setmetatable({}, {__mode="k"})
local hotbar={scanning=false,lastScan=-math.huge,found=0}
local function isHotbarFunction(f)
if type(iscclosure)=="function" then
local ok,native=pcall(iscclosure,f)
if ok and native then return false end
end
local name=nil
if type(debugInfo)=="function" then
local ok,found=pcall(debugInfo,f,"n")
if ok then name=found end
end
if name==nil and type(getinfo)=="function" then
local ok,info=pcall(getinfo,f)
if ok and type(info)=="table" then name=info.name end
end
if name=="updateItemFrame" or name=="onItemEquipped" then return true end
if type(getconstants)~="function" then return false end
local ok,constants=pcall(getconstants,f)
if not ok or type(constants)~="table" then return false end
local touch,equip=false,false
for _,value in pairs(constants) do
if value=="TouchBinding" then touch=true elseif value=="EquipButton" then equip=true end
end
return touch and equip
end
local function patchFunction(f,limit)
local ok,upvalues=pcall(getupvalues,f)
if not ok or type(upvalues)~="table" then return 0 end
local records=patched[f]
local count=0
for index,value in pairs(upvalues) do
if type(index)=="number" and type(value)=="number" then
local record=records and records[index]
if value==3 or value==10 or (record and value==record.applied) then
if not records then records={};patched[f]=records end
if not record then record={original=value};records[index]=record end
if value==limit or pcall(setupvalue,f,index,limit) then
local checked,current=pcall(function() return getupvalues(f)[index] end)
if checked and current==limit then record.applied=limit;count=count+1 end
end
end
end
end
return count
end
local function repatchKnown()
local count=0
for f in pairs(patched) do count=count+patchFunction(f,inventoryLimit) end
hotbar.found=count
return count
end
local function restoreLimits()
for f,records in pairs(patched) do
local ok,upvalues=pcall(getupvalues,f)
if ok and type(upvalues)=="table" then
for index,record in pairs(records) do
if record.applied~=nil and upvalues[index]==record.applied and record.applied~=record.original then
pcall(setupvalue,f,index,record.original)
end
end
end
end
table.clear(patched)
hotbar.found=0
end
-- (a toy taken out and put back makes the hotbar redraw at its new size straight away. Only the newest
-- tool is used, so it stays last and the order doesn't change; when that's the Spray Paint (taking it
-- out restarts its spray screen) or a weapon, it's left for the next tool you get to redraw it)
local addedIndex=setmetatable({}, {__mode="k"})
local addCount=0
local function noteAdded(tool,again)
if again or addedIndex[tool]==nil then addCount=addCount+1;addedIndex[tool]=addCount end
end
local function refreshHotbar()
local backpack=player:FindFirstChildOfClass("Backpack")
if not backpack then return end
local candidate,newest=nil,-1
for _,tool in ipairs(backpack:GetChildren()) do
if tool:IsA("Tool") then
local at=addedIndex[tool] or 0
if at>=newest then candidate,newest=tool,at end
end
end
if not candidate or candidate.Name=="SprayPaint" or weaponKind(candidate) then return end
orderingBackpack=true
pcall(function() candidate.Parent=nil;candidate.Parent=backpack end)
noteAdded(candidate,true)
orderingBackpack=false
end
local function scanHotbar()
if hotbar.scanning or not inventoryEnabled or not alive or not runtimeAlive then return end
if type(getgc)~="function" or type(getupvalues)~="function" or type(setupvalue)~="function" then return end
hotbar.scanning=true
hotbar.lastScan=os.clock()
local newly=0
local ok,objects=pcall(getgc)
if ok and type(objects)=="table" then
local slice=os.clock()
local checked=0
for _,f in pairs(objects) do
if not alive or not runtimeAlive or not inventoryEnabled then break end
if type(f)=="function" and not patched[f] and isHotbarFunction(f) then newly=newly+patchFunction(f,inventoryLimit) end
checked=checked+1
if checked%64==0 and os.clock()-slice>=bootBudget(0.004) then task.wait();slice=os.clock() end
end
end
hotbar.scanning=false
repatchKnown()
if newly>0 then task.defer(refreshHotbar) end
return newly
end
-- (the memory scan is heavy, so it's only done until the hotbar is found: after a respawn or a rebuilt
-- game screen, and then every 10 s while it hasn't been found; once found it's just kept patched)
local function scanSoon(delays)
for _,delay in ipairs(delays) do
task.delay(delay,function()
if alive and runtimeAlive and inventoryEnabled and not trading() and hotbar.found==0 then scanHotbar() end
end)
end
end
task.spawn(function()
while alive and runtimeAlive do
if inventoryEnabled and player.Character and not trading() then
local known=repatchKnown()
if known==0 and os.clock()-hotbar.lastScan>=10 then scanHotbar() end
end
task.wait(2)
end
end)

local function getBackpack()
if observedBackpack and observedBackpack.Parent==player then return observedBackpack end
return player:FindFirstChildOfClass("Backpack")
end
local function findToyFolder()
local backpack=getBackpack()
return backpack and backpack:FindFirstChild("Toys") or nil
end
local function getToyNames()
local names={"None"}
local folder=findToyFolder()
if folder then
for _,toy in ipairs(folder:GetChildren()) do
if not table.find(names,toy.Name) then names[#names+1]=toy.Name end
end
end
table.sort(names,function(a,b)
if a==b then return false end
if a=="None" then return true end
if b=="None" then return false end
return a:lower()<b:lower()
end)
return names
end
local function hasSelectedTool(name,char,backpack)
local inCharacter=char and char:FindFirstChild(name)
local inBackpack=backpack and backpack:FindFirstChild(name)
return (inCharacter and inCharacter:IsA("Tool")) or (inBackpack and inBackpack:IsA("Tool")) or false
end
local function toyRemote()
local rs=game:GetService("ReplicatedStorage")
local remotes=rs:FindFirstChild("Remotes")
local extras=remotes and remotes:FindFirstChild("Extras")
local remote=extras and extras:FindFirstChild("ReplicateToy")
if remote and remote:IsA("RemoteFunction") then return remote end
end
-- Toy order: the hotbar puts a tool that comes back into the first free slot, which is the slot it just
-- left, so taking toys out and back one at a time can't move them. So, once every chosen toy you can
-- get is in your backpack, all of them are taken out together and then put back one by one in slot
-- order, and they fill the free slots in that order (keys included). Done once per life, and again
-- when you change the slots. A toy in your hand, and the Spray Paint (taking it out restarts its spray
-- screen and loses your images), stay where they are.
local TOY_MAX_ATTEMPTS=8
local orderedFor=nil
local function orderSelectedTools(char,backpack,token)
if not backpack or player.Character~=char or token~=recoveryToken then return false end
if orderedFor==char then return true end
local folder=findToyFolder()
local wanted,seen={},{}
for slot=1,TOY_SLOTS do
local name=selectedToys[slot]
if name and name~="None" and not seen[name] then
seen[name]=true
local tool=char:FindFirstChild(name) or backpack:FindFirstChild(name)
if tool and tool:IsA("Tool") then
wanted[#wanted+1]=tool
else
-- (still being fetched: wait for it; one you don't own or the game won't give is left out)
local attempt=toyAttempts[name]
local gettable=folder and folder:FindFirstChild(name) and not (attempt and not attempt.inFlight and attempt.count>=TOY_MAX_ATTEMPTS)
if gettable then return false end
end
end
end
orderedFor=char
local moving={}
for _,tool in ipairs(wanted) do
if tool.Parent==backpack and tool.Name~="SprayPaint" then moving[#moving+1]=tool end
end
if #moving<2 then return true end
orderingBackpack=true
for _,tool in ipairs(moving) do pcall(function() tool.Parent=nil end) end
task.wait()
for _,tool in ipairs(moving) do
if player.Character~=char or token~=recoveryToken then break end
pcall(function() tool.Parent=backpack end)
noteAdded(tool,true)
task.wait()
end
-- (any left out by a respawn halfway go back in all the same)
for _,tool in ipairs(moving) do
if tool.Parent==nil then pcall(function() tool.Parent=backpack end) end
end
task.wait()
orderingBackpack=false
return true
end
local function cancelToyRequests()
for _,attempt in pairs(toyAttempts) do
if attempt.thread and type(task.cancel)=="function" then pcall(task.cancel,attempt.thread) end
end
table.clear(toyAttempts)
activeToyRequest=nil
end
local function cancelRecovery()
recoveryToken=recoveryToken+1
recoveryRunning=false
recoveryCharacter=nil
recoveryDeadline=0
rescanRequested=false
toyOrderDirty=true
cancelToyRequests()
end
local TOY_RETRY={0.5,0.6,0.9,1.3,2,2.5,3,3}
local TOY_INTERVAL=0.5
local function isCurrentRecovery(token,char)
return alive and runtimeAlive and token==recoveryToken
and player.Character==char and char~=removingCharacter
and (inventoryEnabled or autoGetTools)
end
requestRecovery=function(forceScan)
if not alive or not runtimeAlive or not (inventoryEnabled or autoGetTools) then return end
local char=player.Character
if not char or char==removingCharacter then return end
if recoveryCharacter~=char then
cancelRecovery()
recoveryCharacter=char
end
if forceScan then rescanRequested=true end
recoveryDeadline=math.max(recoveryDeadline,os.clock()+20)
if recoveryRunning then return end
recoveryRunning=true
local token=recoveryToken
task.spawn(function()
local startedAt=os.clock()
local nextToyRequest=0
while isCurrentRecovery(token,char) and os.clock()<recoveryDeadline do
local now=os.clock()
if inventoryEnabled then recoveryDeadline=math.max(recoveryDeadline,now+20) end
local humanoid=char:FindFirstChildOfClass("Humanoid")
if humanoid and humanoid.Health>0 then
if autoGetTools then
local backpack=getBackpack()
if toyOrderDirty and backpack and orderSelectedTools(char,backpack,token) then
toyOrderDirty=false
end
end
if autoGetTools and not activeToyRequest and now>=nextToyRequest then
local backpack=getBackpack()
local folder=findToyFolder()
local remote=toyRemote()
if backpack and folder and remote then
-- (strictly in slot order: a toy is only asked for once every toy before it is in your backpack, so
-- they're added, and numbered on the hotbar, in the order of the slots; one you don't own or that
-- the game keeps turning down is skipped)
local seen={}
for slot=1,TOY_SLOTS do
local name=selectedToys[slot]
if name and name~="None" and not seen[name] then
seen[name]=true
local attempt=toyAttempts[name]
if hasSelectedTool(name,char,backpack) then
if attempt and not attempt.inFlight then toyAttempts[name]=nil end
elseif folder:FindFirstChild(name) and not (attempt and not attempt.inFlight and attempt.count>=TOY_MAX_ATTEMPTS) then
if activeToyRequest then break end
if not attempt then
attempt={count=0,nextAt=0,inFlight=false}
toyAttempts[name]=attempt
end
if not attempt.inFlight and now>=attempt.nextAt then
attempt.count=attempt.count+1
attempt.inFlight=true
local request={name=name}
activeToyRequest=request
attempt.thread=task.spawn(function()
local sent=false
if isCurrentRecovery(token,char) and autoGetTools
and not hasSelectedTool(name,char,getBackpack()) then
sent=true
pcall(function() remote:InvokeServer(name) end)
end
attempt.inFlight=false
attempt.thread=nil
attempt.nextAt=os.clock()+(TOY_RETRY[attempt.count] or 3)
if activeToyRequest==request then activeToyRequest=nil end
if sent then nextToyRequest=os.clock()+TOY_INTERVAL end
if isCurrentRecovery(token,char) and autoGetTools then requestRecovery(false) end
end)
end
-- (waiting for this one before any toy after it)
break
end
end
end
end
end
end
task.wait(os.clock()-startedAt<8 and 0.1 or 0.2)
end
if token==recoveryToken then recoveryRunning=false end
end)
end
refreshToyDropdowns=function()
local names=getToyNames()
refreshingDropdowns=true
local saved=table.clone(selectedToys)
for slot,dropdown in ipairs(dropdowns) do
local selection=saved[slot]
if dropdown then
if type(dropdown.Change)=="function" then
pcall(dropdown.Change,names)
elseif type(dropdown.ChangeItems)=="function" then
pcall(function() dropdown:ChangeItems(names) end)
end
if type(dropdown.Select)=="function" then
local ok=pcall(dropdown.Select,selection)
if not ok then pcall(function() dropdown:Select(selection) end) end
end
end
end
refreshingDropdowns=false
end
local function watchToyFolder(folder)
disconnectAll(toyConnections)
if not folder then return end
local function changed()
refreshToyDropdowns()
requestRecovery(false)
end
toyConnections[#toyConnections+1]=folder.ChildAdded:Connect(changed)
toyConnections[#toyConnections+1]=folder.ChildRemoved:Connect(changed)
end
local function watchBackpack(backpack)
disconnectAll(backpackConnections)
disconnectAll(toyConnections)
observedBackpack=backpack
toyOrderDirty=true
if not backpack then return end
for _,item in ipairs(backpack:GetChildren()) do if item:IsA("Tool") then noteAdded(item) end end
watchToyFolder(backpack:FindFirstChild("Toys"))
backpackConnections[#backpackConnections+1]=backpack.ChildAdded:Connect(function(child)
if child:IsA("Tool") then noteAdded(child) end
if child.Name=="Toys" then
watchToyFolder(child)
refreshToyDropdowns()
requestRecovery(false)
elseif child:IsA("Tool") and not orderingBackpack then
toyOrderDirty=true
requestRecovery(false)
end
end)
backpackConnections[#backpackConnections+1]=backpack.ChildRemoved:Connect(function(child)
if child.Name=="Toys" then watchToyFolder(nil)
elseif child:IsA("Tool") and not orderingBackpack then
toyOrderDirty=true
requestRecovery(false)
end
end)
refreshToyDropdowns()
end
local function watchCharacter(char)
disconnectAll(characterConnections)
if not char then return end
local function changed(child)
if child:IsA("Tool") then
toyOrderDirty=true
requestRecovery(false)
end
end
characterConnections[1]=char.ChildAdded:Connect(changed)
characterConnections[2]=char.ChildRemoved:Connect(changed)
end
local guiForceScan=false
local function queueGuiRecovery(invalidate)
if invalidate then
guiForceScan=true
-- (a rebuilt game screen has a new hotbar: it's found again)
table.clear(patched);hotbar.found=0
if inventoryEnabled then scanSoon({1,3}) end
end
guiRefreshToken=guiRefreshToken+1
local token=guiRefreshToken
task.delay(0.35,function()
if alive and token==guiRefreshToken then
local force=guiForceScan
guiForceScan=false
requestRecovery(force)
end
end)
end
local function watchPlayerGui(gui)
disconnectAll(guiConnections)
if not gui then return end
guiConnections[#guiConnections+1]=gui.ChildAdded:Connect(function(child)
if child.Name=="MainGUI" then queueGuiRecovery(true) end
end)
end
do
local trade=env.WorldV2Runtime.Trade
if trade then
trade.OnChanged(function(active)
if active or not alive or not runtimeAlive then return end
requestRecovery(false)
end)
end
end
env.WorldV2Runtime.AutoGetTools={Busy=function()
if not autoGetTools or not alive or not runtimeAlive then return false end
if activeToyRequest~=nil or toyOrderDirty then return true end
local char=player.Character
local backpack=getBackpack()
if not char or not backpack then return true end
for slot=1,TOY_SLOTS do
local name=selectedToys[slot]
if name and name~="None" and not hasSelectedTool(name,char,backpack) then
local attempt=toyAttempts[name]
if not attempt or attempt.count<TOY_MAX_ATTEMPTS then return true end
end
end
return false
end,
RequestOrder=function()
if not autoGetTools or not alive or not runtimeAlive then return end
toyOrderDirty=true
pcall(requestRecovery,false)
end,
CanOrder=function() return true end,
}
task.spawn(function()
local lastKick=-math.huge
while alive and runtimeAlive do
task.wait(0.2)
if autoGetTools then
pcall(function()
local trade=env.WorldV2Runtime.Trade
if trade and trade.active then return end
if toyOrderDirty and not recoveryRunning and os.clock()-lastKick>2 then
lastKick=os.clock()
requestRecovery(false)
end
end)
end
end
end)
local inventoryToggle=addToggle(section,"Increase Inventory",inventoryEnabled,function(state)
inventoryEnabled=state
SetCfg("inventoryUnlimiterEnabled",state)
if state then
task.spawn(scanHotbar)
requestRecovery(false)
else
restoreLimits()
task.defer(refreshHotbar)
if not autoGetTools then cancelRecovery() end
end
end)
section:AddSlider("Max Items",3,10,inventoryLimit,function(value)
inventoryLimit=math.clamp(math.floor(tonumber(value) or 10),3,10)
SetCfg("inventoryMaxItems",inventoryLimit)
if inventoryEnabled then
if repatchKnown()>0 then task.defer(refreshHotbar) else task.spawn(scanHotbar) end
end
end)
local autoToggle=addToggle(section,"Auto Get Tools",autoGetTools,function(state)
local wasEnabled=autoGetTools
autoGetTools=state
toyOrderDirty=true
SetCfg("autoGetTools",state)
if state then
if not wasEnabled then cancelToyRequests() end
requestRecovery(false)
else
cancelToyRequests()
if not inventoryEnabled then cancelRecovery() end
end
end)
local toyNames=getToyNames()
refreshingDropdowns=true
for index=1,TOY_SLOTS do
local slot=index
dropdowns[slot]=addDropdown(section,"Select Toy Slot "..slot,toyNames,selectedToys[slot],function(selected)
if refreshingDropdowns then return end
if type(selected)=="table" then selected=selected[1] or selected.Value or selected.value end
if type(selected)~="string" or not table.find(getToyNames(),selected) then return false end
selectedToys[slot]=selected
SetCfg("autoToySlot"..slot,selected)
toyOrderDirty=true
orderedFor=nil
if autoGetTools then
local previous=toyAttempts[selected]
if not previous or not previous.inFlight then toyAttempts[selected]=nil end
requestRecovery(false)
end
end)
end
refreshingDropdowns=false
section:AddButton("Refresh Toy List",function() refreshToyDropdowns() end)
lifecycleConnections[#lifecycleConnections+1]=player.CharacterRemoving:Connect(function(char)
removingCharacter=char
disconnectAll(characterConnections)
cancelRecovery()
end)
lifecycleConnections[#lifecycleConnections+1]=player.CharacterAdded:Connect(function(char)
table.clear(patched)
hotbar.found=0
if inventoryEnabled then scanSoon({1,3,6}) end
removingCharacter=nil
watchCharacter(char)
watchBackpack(player:FindFirstChildOfClass("Backpack"))
requestRecovery(false)
for _,delay in ipairs({1.5,4}) do
task.delay(delay,function()
if alive and runtimeAlive and player.Character==char and autoGetTools then
toyOrderDirty=true
requestRecovery(false)
end
end)
end
end)
lifecycleConnections[#lifecycleConnections+1]=player.ChildAdded:Connect(function(child)
if child:IsA("Backpack") then
watchBackpack(child)
requestRecovery(false)
elseif child:IsA("PlayerGui") then
if inventoryEnabled then scanSoon({1,3}) end
watchPlayerGui(child)
requestRecovery(true)
end
end)
local replicatedStorage=game:GetService("ReplicatedStorage")
lifecycleConnections[#lifecycleConnections+1]=replicatedStorage.DescendantAdded:Connect(function(child)
if child.Name=="Remotes" or child.Name=="Extras" or child.Name=="ReplicateToy" then requestRecovery(false) end
end)
watchBackpack(player:FindFirstChildOfClass("Backpack"))
watchCharacter(player.Character)
watchPlayerGui(player:FindFirstChildOfClass("PlayerGui"))
if inventoryEnabled then scanSoon({0.5,3}) end
if inventoryEnabled or autoGetTools then task.defer(function() requestRecovery(false) end) end
env.WorldV2Runtime.RegisterReset(function()
guiRefreshToken=guiRefreshToken+1
cancelRecovery()
inventoryToggle:Set(false)
autoToggle:Set(false)
inventoryEnabled=false
autoGetTools=false
restoreLimits()
if runtimeAlive then return end
alive=false
disconnectAll(lifecycleConnections)
disconnectAll(backpackConnections)
disconnectAll(characterConnections)
disconnectAll(toyConnections)
disconnectAll(guiConnections)
end)
end,"Section \"Increase Inventory\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local runtime=env.WorldV2Runtime
local section=mainTab:AddSection("Auto Paste","Utilities")
section:AddParagraph("Auto Paste","Puts the image IDs below into your Spray Paint for you whenever you have the Spray Paint toy, so they're ready to spray. Turn on the ones you want; the IDs stay saved.")
-- Each turned-on image is put in the spray screen's Add box and its Add button is pressed, just like
-- adding it by hand, so it's ready to spray straight away; that's done once per Spray Paint you get (so
-- again after a respawn). Without the spray screen or its button, the image is sent to the game the way
-- the Add box sends it, and pressed in properly as soon as the spray screen shows up. One the game
-- turns down is tried 3 times. With Randomize on, every time you take the Spray Paint out again one of
-- the turned-on images is picked at random (never the same one twice in a row) and added again, so it's
-- the one you spray next; the game sprays the image added last.
local SLOTS=5
local images={}
for slot=1,SLOTS do
images[slot]={id=tostring(C("autoPasteId"..slot,"")),on=C("autoPasteOn"..slot,false)==true}
end
local randomOrder=C("autoPasteRandom",false)==true
local alive=true
local running=false
local runningSince=0
local pastedFor=nil
local pasted,tries,told,nextTry={},{},{},{}
local freshAt=-math.huge
local function notify(text,kind) pcall(shared.Notify,"Auto Paste: "..text,kind or 3) end
local function cleanId(text) return tostring(text or ""):match("%d+") or "" end
local function sprayTool()
local character=LocalPlayer.Character
local tool=character and character:FindFirstChild("SprayPaint")
if tool and tool:IsA("Tool") then return tool end
local backpack=LocalPlayer:FindFirstChildOfClass("Backpack")
tool=backpack and backpack:FindFirstChild("SprayPaint")
if tool and tool:IsA("Tool") then return tool end
return nil
end
local function approveRemote(tool)
local client=tool:FindFirstChild("SprayClient")
local remote=client and client:FindFirstChild("GetAssetApproved")
if not remote then remote=tool:FindFirstChild("GetAssetApproved",true) end
return remote and remote:IsA("RemoteFunction") and remote or nil
end
-- (the newest spray screen, when an old one from before is still there)
local function sprayGui()
local gui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
if not gui then return nil end
local found=nil
for _,child in ipairs(gui:GetChildren()) do
if child.Name=="SprayGui" then found=child end
end
return found
end
local function addBox()
local current=sprayGui()
for _,name in ipairs({"Main","Container","Add","Frame","Container","TextBox"}) do
current=current and current:FindFirstChild(name)
end
return current and current:IsA("TextBox") and current or nil
end
-- (the Add panel's own button: the one that says add, or the only other button in the panel)
local SKIP={close=true,x=true,cancel=true,back=true,exit=true}
local function addButton()
local spray=sprayGui()
local main=spray and spray:FindFirstChild("Main")
local container=main and main:FindFirstChild("Container")
local panel=container and container:FindFirstChild("Add")
if not panel then return nil end
local best,others=nil,{}
for _,item in ipairs(panel:GetDescendants()) do
if item:IsA("GuiButton") then
local name=item.Name:lower()
local ok,text=pcall(function() return item.Text end)
text=ok and type(text)=="string" and text:lower() or ""
local label=item:FindFirstChildWhichIsA("TextLabel",true)
local labelText=label and label.Text:lower() or ""
if not SKIP[name] and not SKIP[text] then
if name:find("add",1,true) or name:find("confirm",1,true) or text:find("add",1,true) or labelText:find("add",1,true)
or text=="+" or labelText=="+" then best=best or item else others[#others+1]=item end
end
end
end
return best or (#others==1 and others[1]) or nil
end
-- (runs what the game does when the button is pressed: getconnections, or firesignal where that's what
-- the executor has)
local function fire(signal,...)
if type(getconnections)=="function" then
local ok,list=pcall(getconnections,signal)
if ok and type(list)=="table" and #list>0 then
local args=table.pack(...)
for _,connection in ipairs(list) do
pcall(function()
if connection.Function then connection.Function(table.unpack(args,1,args.n)) else connection:Fire(table.unpack(args,1,args.n)) end
end)
end
return true
end
end
local trigger=firesignal or env.firesignal
if type(trigger)=="function" then return (pcall(trigger,signal,...)) end
return false
end
local function press(button)
for _,name in ipairs({"Activated","MouseButton1Click","MouseButton1Up","MouseButton1Down"}) do
local ok,signal=pcall(function() return button[name] end)
if ok and signal and fire(signal) then return true end
end
return false
end
-- (true when the image is in the spray list on screen, nil when the spray screen isn't there to look at)
local function onScreen(id)
local spray=sprayGui()
if not spray then return nil end
for _,item in ipairs(spray:GetDescendants()) do
if (item:IsA("ImageLabel") or item:IsA("ImageButton")) and item.Image:find(id,1,true) then return true end
end
return false
end
local function wanted()
local list={}
for slot=1,SLOTS do
local id=cleanId(images[slot].id)
if images[slot].on and id~="" and not table.find(list,id) then list[#list+1]=id end
end
if randomOrder then
for index=#list,2,-1 do
local other=math.random(index)
list[index],list[other]=list[other],list[index]
end
end
return list
end
-- (puts one image in: typed into the Add box and its button pressed, or, when the spray screen or its
-- button can't be used, sent to the game the way the box sends it; gives back how it went in, or nil)
local function pasteOne(tool,id)
local remote=approveRemote(tool)
if not remote then return nil end
local box=addBox()
local button=box and addButton()
local pressed=false
if box then
pcall(function() box.Text=id end)
if button then pressed=press(button) end
if not pressed then pressed=fire(box.FocusLost,true) end
end
if pressed then
local deadline=os.clock()+3
repeat task.wait(0.2) until onScreen(id)~=false or os.clock()>deadline or not alive or not runtimeAlive
if onScreen(id)~=false then return "screen" end
end
-- (the game's answer is waited on for 6 s at most: one that never comes, like when the Spray Paint
-- goes away mid-way, doesn't hold up the next paste)
local answer=nil
local waiting=task.spawn(function()
local ok,result=pcall(function() return remote:InvokeServer(tonumber(id) or id) end)
answer={ok,result}
end)
local deadline=os.clock()+6
while not answer and os.clock()<deadline and alive and runtimeAlive do task.wait(0.1) end
if not answer then pcall(task.cancel,waiting);return nil end
if answer[1] and answer[2]~=false then return "game" end
return nil
end
-- (marks a paste as going on; one that's been going for over 20 s is taken as stuck and let go)
local function busy()
return running and os.clock()-runningSince<20
end
local function start(work)
running,runningSince=true,os.clock()
local mine=runningSince
task.spawn(function()
pcall(work)
if runningSince==mine then running=false end
end)
end
local lastRandom=nil
local function pasteAll()
if busy() or not alive or not runtimeAlive then return end
local tool=sprayTool()
if not tool then return end
local trade=runtime.Trade
if trade and trade.active then return end
-- (a new Spray Paint, after a respawn: everything is pasted again once it's had 1.5 s to get ready,
-- without trusting what's on the spray screen, which can still be the one from before you died)
local now=os.clock()
if tool~=pastedFor then
pastedFor=tool;freshAt=now
table.clear(pasted);table.clear(tries);table.clear(nextTry)
end
if now-freshAt<1.5 then return end
local todo={}
for _,id in ipairs(wanted()) do
-- (one that's no longer in the spray list, like when the game resets it, goes in again)
if pasted[id] and onScreen(id)==false then pasted[id]=nil end
if not pasted[id] and (tries[id] or 0)<3 and now>=(nextTry[id] or 0) then todo[#todo+1]=id end
end
if #todo==0 then return end
start(function()
for _,id in ipairs(todo) do
if not alive or not runtimeAlive or sprayTool()~=tool then break end
if not approveRemote(tool) then break end
tries[id]=(tries[id] or 0)+1
nextTry[id]=os.clock()+tries[id]
local result=pasteOne(tool,id)
if result then
pasted[id]=result;lastRandom=id
-- (seen in the spray list: it can go in again later if the list is reset)
if result=="screen" then tries[id],nextTry[id]=nil,nil end
elseif tries[id]>=3 and not told[id] then
told[id]=true
notify("image "..id.." wasn't accepted, check the ID",0)
end
task.wait(0.3)
end
end)
end
local controls={}
local function changed(slot)
local id=images[slot] and cleanId(images[slot].id)
if id and id~="" then pasted[id]=nil;tries[id]=nil;told[id]=nil;nextTry[id]=nil end
task.defer(pasteAll)
end
for index=1,SLOTS do
local slot=index
section:AddTextBox("Image "..slot.." ID",function(text)
local id=cleanId(text)
-- (the saved ID being filled back in when the script runs is the same one: nothing to say or redo)
if id==cleanId(images[slot].id) then return end
images[slot].id=id
SetCfg("autoPasteId"..slot,id)
if id~="" then notify(("image %d set to %s"):format(slot,id),2) else notify(("image %d cleared"):format(slot),3) end
changed(slot)
end)
controls[#controls+1]=addToggle(section,"Paste Image "..slot,images[slot].on,function(value)
images[slot].on=value
SetCfg("autoPasteOn"..slot,value)
if value and cleanId(images[slot].id)=="" then notify(("type an ID into Image %d first"):format(slot),0) end
changed(slot)
end)
end
controls[#controls+1]=addToggle(section,"Randomize (Each Equip)",randomOrder,function(value)
randomOrder=value
SetCfg("autoPasteRandom",value)
end)
-- (taking the Spray Paint out again, with Randomize on: a random turned-on image is added again; right
-- after a respawn the normal paste already goes in a random order, so nothing extra is added then)
local function equipped(tool)
if not randomOrder or not alive or not runtimeAlive or busy() then return end
if tool~=pastedFor or os.clock()-freshAt<1.5 then return end
local list=wanted()
for _,id in ipairs(list) do if not pasted[id] then return end end
if #list==0 then return end
local id=list[1]
if #list>1 and id==lastRandom then id=list[2] end
start(function()
local result=pasteOne(tool,id)
if result then lastRandom=id end
end)
end
local equipWatch=nil
local function watchCharacter(character)
if equipWatch then equipWatch:Disconnect();equipWatch=nil end
if not character then return end
equipWatch=character.ChildAdded:Connect(function(child)
if child.Name=="SprayPaint" and child:IsA("Tool") then task.defer(equipped,child) end
end)
end
local spawnWatch=LocalPlayer.CharacterAdded:Connect(watchCharacter)
watchCharacter(LocalPlayer.Character)
task.spawn(function()
while alive and runtimeAlive do
pcall(pasteAll)
task.wait(1)
end
end)
runtime.RegisterReset(function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
for slot=1,SLOTS do images[slot].id,images[slot].on="",false end
randomOrder=false
table.clear(pasted);table.clear(tries);table.clear(told);table.clear(nextTry)
lastRandom=nil
if not runtimeAlive then
alive=false
spawnWatch:Disconnect()
if equipWatch then equipWatch:Disconnect();equipWatch=nil end
end
end)
end,"Section \"Auto Paste\"")
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local runtime=env.WorldV2Runtime
local section=mainTab:AddSection("Hide Delta","Utilities")
section:AddParagraph("Hide Delta","Hides Delta's floating button so it isn't on your screen or in recordings. Turn it off or type /e unhide in chat to bring it back; /e hide hides it again.")
-- Delta's button: an ImageButton with a UIStroke, in a ScreenGui, in a Folder right under CoreGui.
-- World V2's and Visuals V2's own buttons are never counted.
local CoreGui=game:GetService("CoreGui")
local settings={hidden=C("w2HideDelta",false)==true}
local alive=true
local found=setmetatable({}, {__mode="k"})
local lastScan=-math.huge
local function ours(gui,button)
local guiName,buttonName=gui.Name,button.Name
if guiName=="@bindstorage" or guiName:sub(1,9)=="VisualsV2" or guiName:sub(1,7)=="WorldV2" or guiName:sub(1,3)=="W2_" then return true end
return buttonName:sub(1,9)=="VisualsV2" or buttonName:sub(1,4)=="VV2_" or buttonName:sub(1,7)=="WorldV2"
end
local function deltaButtons()
if os.clock()-lastScan<5 and next(found)~=nil then return found end
lastScan=os.clock()
local ok,list=pcall(function() return CoreGui:GetDescendants() end)
if not ok or type(list)~="table" then return found end
for _,item in ipairs(list) do
if item:IsA("UIStroke") then
local button=item.Parent
local gui=button and button.Parent
local folder=gui and gui.Parent
if button and button:IsA("ImageButton") and gui and gui:IsA("ScreenGui") and folder and folder:IsA("Folder")
and folder.Parent==CoreGui and not ours(gui,button) then
found[button]=true
end
end
end
return found
end
local function apply(visible)
for button in pairs(deltaButtons()) do
if button.Parent then pcall(function() button.Visible=visible end) else found[button]=nil end
end
end
local controls={}
local hideToggle
hideToggle=addToggle(section,"Hide Delta Button",settings.hidden,function(value)
settings.hidden=value
SetCfg("w2HideDelta",value)
lastScan=-math.huge
apply(not value)
end)
controls[#controls+1]=hideToggle
-- (while it's hidden it's hidden again every second, in case Delta puts its button back)
task.spawn(function()
while alive and runtimeAlive do
if settings.hidden then apply(false) end
task.wait(1)
end
end)
local chatted=LocalPlayer.Chatted:Connect(function(message)
message=tostring(message):lower()
if message=="/e hide" then hideToggle:Set(true)
elseif message=="/e unhide" then hideToggle:Set(false) end
end)
runtime.RegisterReset(function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
settings.hidden=false
apply(true)
if not runtimeAlive then
alive=false
chatted:Disconnect()
end
end)
end,"Section \"Hide Delta\"")
;w2Section(function()
local miscSection=mainTab:AddSection("Miscellaneous","Settings")
local muteToggle=addToggle(miscSection,"Mute Button SFX",ButtonAudio.muted,function(value)
ButtonAudio:SetMuted(value)
end)
env.WorldV2Runtime.RegisterReset(function()
if runtimeAlive then muteToggle:Set(false);ButtonAudio:SetMuted(false) end
end)
miscSection:AddButton("Reset Big/Bind Button Position",function()
saveStoredPosition("speedButtonPosition",BIG_BUTTON_DEFAULT)
saveStoredPosition("speedBindButtonPosition",BIND_BUTTON_DEFAULT)
if speedButton then speedButton.Position=BIG_BUTTON_DEFAULT end
BindableButtons:SetPosition("VisualsV2_SpeedBind",BIND_BUTTON_DEFAULT)
local trick=env.WorldV2Runtime.TrickShoot
if trick and trick.ResetPosition then trick.ResetPosition() end
end)
addToggle(miscSection,"Lock Big Button POS",lockBigButtonPos,function(state)
lockBigButtonPos=state
SetCfg("lockBigButtonPos",state)
end)
addToggle(miscSection,"Lock Bind Button POS",lockBindButtonPos,function(state)
lockBindButtonPos=state
SetCfg("lockBindButtonPos",state)
for id in pairs(BindableButtons.Buttons) do BindableButtons:SetLocked(id,state) end
end)
do
local buttonStyle=env.WorldV2Runtime.BigButtonStyle
if buttonStyle then
local gradientToggle=addToggle(miscSection,"Custom Button Gradient",buttonStyle.enabled,function(value)
buttonStyle.SetEnabled(value)
end)
for index=1,3 do
miscSection:AddColorpicker("Button Gradient Color "..index,buttonStyle.colors[index],function(color)
buttonStyle.SetColor(index,color)
end)
end
env.WorldV2Runtime.RegisterReset(function()
if runtimeAlive then gradientToggle:Set(false) end
buttonStyle.Reset()
end)
end
end
local restoreAskedAt=-math.huge
miscSection:AddButton("Restore Defaults",function()
if not runtimeAlive or type(env.WorldV2Runtime.RestoreDefaults)~="function" then return end
if os.clock()-restoreAskedAt>5 then
restoreAskedAt=os.clock()
pcall(shared.Notify,"Restore Defaults: press it again within 5 seconds to reset all of World V2",0)
return
end
restoreAskedAt=-math.huge
env.WorldV2Runtime.RestoreDefaults()
pcall(shared.Notify,"Restore Defaults: World V2 is back to its defaults (settings file deleted). Re-execute it to start fresh.",2)
end)
-- Whitelist (at the very bottom, under its own heading): the main dropdown, then the permanent names with
-- their own on/off
do
local list=env.WorldV2Runtime.Whitelist
miscSection:AddLabel("Whitelist")
miscSection:AddPlayerDropdown("Main Whitelist (All Features)",function(plr)
if typeof(plr)=="Instance" and plr~=LocalPlayer and list then
list.Add(plr)
pcall(shared.Notify,"Main Whitelist: "..plr.DisplayName.." whitelisted (until you leave)",2)
end
end)
miscSection:AddButton("Clear Temporary Whitelist",function()
if list then list.Clear() end
pcall(shared.Notify,"Main Whitelist: cleared (the permanent ones stay)",2)
end)
addToggle(miscSection,"Enable Permanent Whitelist",list==nil or list.PermanentOn(),function(value)
SetCfg("w2PermWhitelistEnabled",value)
if list then list.SetPermanentOn(value) end
end)
for slot=1,3 do
miscSection:AddTextBox("Permanent Whitelist "..slot,function(text)
if not list then return end
local value=list.Clean(text)
-- (the saved name being filled back in when the script runs: nothing to say)
if value==list.Permanent(slot) then return end
list.SetPermanent(slot,value)
SetCfg("w2PermWhitelist"..slot,value)
if value=="" then pcall(shared.Notify,"Permanent Whitelist "..slot..": cleared",3)
else pcall(shared.Notify,"Permanent Whitelist "..slot..": "..value.." is always whitelisted",2) end
end)
end
end
end,"Section \"Miscellaneous\"")
local function onCharacterAdded(char)
task.delay(0.15,function()
if player.Character~=char then return end
if noInterruptionEmote and type(setupAutomaticEmoteProtection)=="function" then
local ok,problem=pcall(setupAutomaticEmoteProtection,char)
if not ok then pcall(warn,"[World V2] "..tostring(problem)) end
end
end)
if type(setupSpeedButtons)=="function" then task.delay(0.5,setupSpeedButtons) end
end
if player.Character then task.defer(function() onCharacterAdded(player.Character) end) end
player.CharacterAdded:Connect(onCharacterAdded)
saveConfig()
local performanceTab=mainTab
;w2Section(function()
-- Keep repeated handlers and their local helpers outside the obfuscation VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local section=performanceTab:AddSection("FPS, Plyr, & Ping","Performance")
local Stats=game:GetService("Stats")
local enabled=C("vv2FpsPingEnabled",false)
local colors=C("vv2FpsPingColors",true)
local showFps=C("vv2FpsPingShowFps",true)
local showPing=C("vv2FpsPingShowPing",true)
local showPlayers=C("vv2FpsPingShowPlayers",true)
local legacyMonitorSize=tonumber(ConfigData["vv2FpsPingSize"])
local legacyMonitorScale=legacyMonitorSize and math.clamp(legacyMonitorSize,1,10)/5 or 1
if tonumber(ConfigData["vv2FpsPingSizeScaleVersion"])~=2 then
ConfigData["vv2FpsPingSize"]=legacyMonitorSize
and math.clamp(math.floor((legacyMonitorScale-0.5)*4+0.5),1,10) or 2
ConfigData["vv2FpsPingSizeScaleVersion"]=2
end
local monitorSize=math.clamp(tonumber(C("vv2FpsPingSize",2)) or 2,1,10)
local locked=C("vv2FpsPingLocked",false)
local gui,holder,fps,ping,playersLabel,monitorScale,renderConn
local lastFps=0
local dragConnections={}
local POSITION_KEY="vv2FpsPingMonitorPosition"
local DEFAULT_POS=UDim2.new(0.5,0,0.05,0)
if tonumber(ConfigData["vv2FpsPingAnchorVersion"])~=2 then
local saved=PositionData[POSITION_KEY]
if type(saved)=="table" then
local visibleCount=(showFps and 1 or 0)+(showPing and 1 or 0)+(showPlayers and 1 or 0)
saved.xo=(tonumber(saved.xo or saved.XO) or 0)+(120*legacyMonitorScale/2)
saved.yo=(tonumber(saved.yo or saved.YO) or 0)+(math.max(1,visibleCount*28-3)*legacyMonitorScale/2)
end
ConfigData["vv2FpsPingAnchorVersion"]=2
end
local BLACK=Color3.fromRGB(0,0,0)
local GREEN=Color3.fromRGB(0,255,0)
local YELLOW=Color3.fromRGB(255,200,0)
local RED=Color3.fromRGB(255,0,0)
local monitorToggle,fpsToggle,pingToggle,playersToggle
local function ensureMonitorStatistic()
if configResetting or not enabled or showFps or showPing or showPlayers then return end
showFps=true
SetCfg("vv2FpsPingShowFps",true)
pcall(function()
shared.Notify("FPS, Plyr, & Ping: turn on at least one statistic, or turn off Monitor UI. FPS was turned back on.",0)
end)
task.defer(function()
if showFps and fpsToggle then fpsToggle:Set(true) end
end)
end
local function root()
if type(gethui)=="function" then
local ok,r=pcall(gethui)
if ok and typeof(r)=="Instance" then return r end
end
return player:WaitForChild("PlayerGui")
end
local function disconnectDragConnections()
for _,connection in ipairs(dragConnections) do
pcall(function() connection:Disconnect() end)
end
table.clear(dragConnections)
end
local function decodeSavedPosition(fallback)
return loadStoredPosition(POSITION_KEY,fallback)
end
local function saveMonitorPosition(position)
saveStoredPosition(POSITION_KEY,position)
end
local function setMonitorPosition(position,saveIt)
if holder then holder.Position=position end
if saveIt then saveMonitorPosition(position) end
end
local function fpsColor(value,cap)
if not colors then return BLACK end
cap=math.max(tonumber(cap) or 60,1)
if value>=cap*.85 then return GREEN end
if value>=cap*.5 then return YELLOW end
return RED
end
local function pingColor(value)
if not colors then return BLACK end
if value<=80 then return GREEN end
if value<=150 then return YELLOW end
return RED
end
local function playerCountColor(value)
if not colors then return BLACK end
value=math.clamp(tonumber(value) or 1,1,12)
if value>=9 then return GREEN end
if value>=5 then return YELLOW end
return RED
end
local function makeLabel(name,y)
local label=Instance.new("TextLabel")
label.Name=name
label.BackgroundTransparency=1
label.Size=UDim2.new(1,0,0,25)
label.Position=UDim2.fromOffset(0,y)
label.Font=Enum.Font.SourceSansLight
label.TextScaled=true
label.TextColor3=BLACK
label.TextStrokeTransparency=1
label.Active=false
label.Parent=holder
return label
end
local function applyMonitorLayout()
if not holder then return end
local visible={showFps,showPing,showPlayers}
local y=0
for i,label in ipairs({fps,ping,playersLabel}) do
label.Visible=visible[i]
if visible[i] then
label.Position=UDim2.fromOffset(0,y)
y=y+28
end
end
holder.Size=UDim2.fromOffset(120,math.max(1,y-3))
holder.Visible=showFps or showPing or showPlayers
if monitorScale then monitorScale.Scale=0.4+((monitorSize-1)*(2.6/9)) end
end
local function updateMonitorStats(value)
if not fps or not fps.Parent then return end
if value~=nil then lastFps=value end
local cap=workspace:GetAttribute("FPSCap") or 60
fps.Text=tostring(lastFps)
fps.TextColor3=fpsColor(lastFps,cap)
local p=0
pcall(function()
p=tonumber(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString():match("%-?%d+")) or 0
end)
ping.Text=tostring(p)
ping.TextColor3=pingColor(p)
local count=#Players:GetPlayers()
playersLabel.Text=tostring(count)
playersLabel.TextColor3=playerCountColor(count)
end
local function setupDragging()
disconnectDragConnections()
if not holder then return end
local dragging=false
local dragInput,dragStart,startPos
local function beginDrag(input)
if locked then return end
if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
dragging=true
dragInput=input
dragStart=input.Position
startPos=holder.Position
end
table.insert(dragConnections,holder.InputBegan:Connect(beginDrag))
for _,label in ipairs({fps,ping,playersLabel}) do
table.insert(dragConnections,label.InputBegan:Connect(beginDrag))
end
table.insert(dragConnections,UserInputService.InputChanged:Connect(function(input)
if not dragging or locked then return end
local matches=(input==dragInput)
or (dragInput and dragInput.UserInputType==Enum.UserInputType.Touch and input.UserInputType==Enum.UserInputType.Touch)
or (dragInput and dragInput.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseMovement)
if not matches then return end
local delta=input.Position-dragStart
holder.Position=UDim2.new(
startPos.X.Scale,startPos.X.Offset+delta.X,
startPos.Y.Scale,startPos.Y.Offset+delta.Y
)
end))
table.insert(dragConnections,UserInputService.InputEnded:Connect(function(input)
if not dragging then return end
if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
dragging=false
if holder then saveMonitorPosition(holder.Position) end
end))
end
local function destroy()
if renderConn then renderConn:Disconnect(); renderConn=nil end
disconnectDragConnections()
if gui then gui:Destroy(); gui=nil end
holder=nil; fps=nil; ping=nil; playersLabel=nil; monitorScale=nil
end
local function create()
ensureMonitorStatistic()
destroy()
gui=Instance.new("ScreenGui")
gui.Name="VisualsV2_FpsPingMonitor"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.Parent=root()
holder=Instance.new("Frame")
holder.Name="VisualsV2_StatsHolder"
holder.BackgroundTransparency=1
holder.Size=UDim2.fromOffset(120,81)
holder.AnchorPoint=Vector2.new(0.5,0.5)
holder.Active=true
holder.Position=decodeSavedPosition(DEFAULT_POS)
holder.Parent=gui
monitorScale=Instance.new("UIScale")
monitorScale.Name="VisualsV2_MonitorScale"
monitorScale.Parent=holder
fps=makeLabel("VisualsV2_FPS",0)
ping=makeLabel("VisualsV2_Ping",28)
playersLabel=makeLabel("VisualsV2_Players",56)
applyMonitorLayout()
lastFps=0
updateMonitorStats()
setupDragging()
local elapsed,frameCount=0,0
renderConn=RunService.RenderStepped:Connect(function(dt)
if not fps or not fps.Parent then return end
elapsed=elapsed+(math.max(dt,0))
frameCount=frameCount+1
if elapsed>=.5 then
local averageFps=math.floor(frameCount/math.max(elapsed,1/1000)+.5)
elapsed,frameCount=0,0
updateMonitorStats(averageFps)
end
end)
end
monitorToggle=addToggle(section,"W2 Enable Monitor UI",enabled,function(v)
enabled=v
SetCfg("vv2FpsPingEnabled",v)
if v then create() else destroy() end
end)
local colorToggle=addToggle(section,"W2 Enable Statistic Colors",colors,function(v)
colors=v
SetCfg("vv2FpsPingColors",v)
updateMonitorStats()
end)
fpsToggle=addToggle(section,"Show FPS",showFps,function(v)
showFps=v
SetCfg("vv2FpsPingShowFps",v)
ensureMonitorStatistic()
applyMonitorLayout()
end)
pingToggle=addToggle(section,"Show Ping",showPing,function(v)
showPing=v
SetCfg("vv2FpsPingShowPing",v)
ensureMonitorStatistic()
applyMonitorLayout()
end)
playersToggle=addToggle(section,"Show Player Count",showPlayers,function(v)
showPlayers=v
SetCfg("vv2FpsPingShowPlayers",v)
ensureMonitorStatistic()
applyMonitorLayout()
end)
section:AddSlider("Monitor Size",1,10,monitorSize,function(value)
monitorSize=math.clamp(tonumber(value) or 2,1,10)
SetCfg("vv2FpsPingSize",monitorSize)
applyMonitorLayout()
end)
local lockToggle=addToggle(section,"Lock Monitor Position",locked,function(v)
locked=v
SetCfg("vv2FpsPingLocked",v)
end)
section:AddButton("Reset Monitor Position",function()
SetCfg("vv2FpsPingPosition","Top Center")
setMonitorPosition(DEFAULT_POS,true)
end)
env.WorldV2Runtime.RegisterReset(function()
monitorToggle:Set(false)
colorToggle:Set(false)
fpsToggle:Set(false)
pingToggle:Set(false)
playersToggle:Set(false)
lockToggle:Set(false)
enabled=false
colors=false
showFps=false
showPing=false
showPlayers=false
locked=false
destroy()
end)
if enabled then task.defer(create) end
end,"Section \"FPS, Plyr, & Ping\"")
;w2Section(function()
local sawSettingsFile=false
local function resetEverything()
ConfigData={}
PositionData={}
configResetting=true
for _,resetter in ipairs(env.WorldV2Runtime.Resetters or {}) do
pcall(resetter)
end
configResetting=false
end
local remove=type(delfile)=="function" and delfile or env.delfile
or type(deletefile)=="function" and deletefile or env.deletefile
env.WorldV2Runtime.RestoreDefaults=function()
if not runtimeAlive then return false end
resetEverything()
local gone=false
if type(remove)=="function" and pcall(remove,CFG_FILE) then
gone=true
if type(exists)=="function" then
local checked,present=pcall(exists,CFG_FILE)
if checked and present then gone=false end
end
end
if not gone and type(write)=="function" then
pcall(function() write(CFG_FILE,HttpService:JSONEncode({version=2,settings={},positions={}})) end)
end
sawSettingsFile=false
return true
end
if type(exists)~="function" then return end
env.WorldV2ConfigWatchToken=(tonumber(env.WorldV2ConfigWatchToken) or 0)+1
local myWatchToken=env.WorldV2ConfigWatchToken
local ok,present=pcall(exists,CFG_FILE)
if ok and present then sawSettingsFile=true end
task.spawn(function()
while runtimeAlive and env.WorldV2ConfigWatchToken==myWatchToken do
local checkOk,filePresent=pcall(exists,CFG_FILE)
if checkOk and filePresent then
sawSettingsFile=true
elseif checkOk and sawSettingsFile then
sawSettingsFile=false
resetEverything()
if type(write)=="function" then
pcall(function()
write(CFG_FILE,HttpService:JSONEncode({
version=2,
settings={},
positions={},
}))
end)
sawSettingsFile=true
end
pcall(function()
shared.Notify("World V2: settings reset to their defaults",2)
end)
end
task.wait(1)
end
end)
end,"Part at line 27508")
;w2Section(function()
local creditsSection=mainTab:AddSection("Credits","")
creditsSection:AddLabel("Founder - Belfor (1306953439238164551)")
creditsSection:AddLabel("Founder - Penguin, __ludexioso (201120712361115653)")
creditsSection:AddLabel("Developer - Gato (1333631679570645082)")
creditsSection:AddLabel("Contributor - mrdaniel307228 (1446948400707801180)")
creditsSection:AddLabel("Contributor - NICOLAS (1163360113092997120)")
creditsSection:AddLabel("Contributor - b6o6s, A (718910264942002277)")
creditsSection:AddLabel("Contributor - lzzzx, 187 (586568393801596928)")
creditsSection:AddLabel("Contributor - arkineku (1418738338508308691)")
creditsSection:AddLabel("Contributor - anya_bts (1067515726677684324)")
end,"Section \"Credits\"")
saveConfig()
task.defer(function()
while restoreRunning and runtimeAlive do task.wait() end
task.defer(function() controlsReady=true;local loading=env.WorldV2Runtime.LoadingScreen;if loading then loading.Finish() end end)
end)
