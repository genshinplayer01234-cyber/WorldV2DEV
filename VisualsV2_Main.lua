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

local shared = odh_shared_plugins
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
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
local CFG_FILE = "VisualsV2_settings.json"
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
local function vv2Section(build,label)
local ok,problem=xpcall(build,function(message)
local traced=nil
pcall(function() traced=debug.traceback(tostring(message),2) end)
return traced or tostring(message)
end)
if ok then return end
pcall(warn,"[Visuals V2] "..tostring(label).." couldn't load; the rest still works.\n"..tostring(problem))
pcall(function() shared.Notify("Visuals V2: "..tostring(label).." couldn't load. The rest still works (details in the console).",1) end)
end
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE))
local bridge=env.VisualsV2ControlAudioBridge
if type(bridge)~="table" then bridge={methods={}};env.VisualsV2ControlAudioBridge=bridge end
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
-- Visuals V2 still loads)
local made,tab=pcall(shared.CreateTab,"Visuals V2","/genshinplayer01234-cyber/WorldV2DEV/refs/heads/visuals/icon")
if not made or tab==nil then made,tab=pcall(shared.CreateTab,"Visuals V2") end
if not made then error(tab,0) end
mainTab=tab
end
local previousThrowableBridge=env.VisualsV2ThrowableAimBridge
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
local function loadConfig()
LPH_ATTRIBUTES(PRESET(FAST))
if type(read) ~= "function" then return end
local found = true
if type(exists) == "function" then
local ok, result = pcall(exists, CFG_FILE)
found = ok and result
end
if not found then return end
local ok, decoded = pcall(function()
return HttpService:JSONDecode(read(CFG_FILE))
end)
if not ok or type(decoded) ~= "table" then return end
if type(decoded.settings) == "table" then
ConfigData = decoded.settings
end
if type(decoded.positions) == "table" then
PositionData = decoded.positions
end
end
local function saveConfig()
if not runtimeAlive or type(write) ~= "function" then return false end
local payload = {
version = 2,
settings = ConfigData,
positions = PositionData,
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
local controller = {}
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
message=name:gsub("^VV2 ","")..": "..tostring(selected)
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
;vv2Section(function()
local previousBridge=LocalPlayer:FindFirstChild("VisualsV2_RuntimeBridge")
if previousBridge and previousBridge:IsA("BindableFunction") and previousBridge:GetAttribute("VisualsV2_RuntimeBridge") then
pcall(function() previousBridge:Invoke("Cleanup") end)
pcall(function() previousBridge:Destroy() end)
end
end,"Part at line 355")
local previousRuntime = env.VisualsV2Runtime
if type(previousRuntime) == "table" and type(previousRuntime.Cleanup) == "function" then
pcall(previousRuntime.Cleanup)
end
loadConfig()
if next(ConfigData)==nil and next(PositionData)==nil then freshInstall=true end
env.VisualsV2Runtime = {Resetters = {}, Build = "2026-10-25-v2-1"}
-- (Visual Weapons/Effects are locked behind a password; only its SHA-256 is kept here)
do
local UNLOCK_HASH="b053aa1653e122c9a1e96570539f522cc70058be6d8c089f6bab1efb38ed3b1e"
local K={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
local function sha256(message)
local band,bxor,bnot,rrotate,rshift=bit32.band,bit32.bxor,bit32.bnot,bit32.rrotate,bit32.rshift
local h={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
local bytes={string.byte(message,1,-1)}
local length=#bytes
bytes[#bytes+1]=0x80
while #bytes%64~=56 do bytes[#bytes+1]=0 end
for i=7,0,-1 do bytes[#bytes+1]=math.floor(length*8/2^(i*8))%256 end
local w={}
for chunk=1,#bytes,64 do
for i=0,15 do
local at=chunk+i*4
w[i]=((bytes[at]*256+bytes[at+1])*256+bytes[at+2])*256+bytes[at+3]
end
for i=16,63 do
local x,y=w[i-15],w[i-2]
w[i]=(w[i-16]+bxor(rrotate(x,7),rrotate(x,18),rshift(x,3))+w[i-7]+bxor(rrotate(y,17),rrotate(y,19),rshift(y,10)))%2^32
end
local a,b,c,d,e,f,g,j=h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]
for i=0,63 do
local t1=(j+bxor(rrotate(e,6),rrotate(e,11),rrotate(e,25))+bxor(band(e,f),band(bnot(e),g))+K[i+1]+w[i])%2^32
local t2=(bxor(rrotate(a,2),rrotate(a,13),rrotate(a,22))+bxor(band(a,b),band(a,c),band(b,c)))%2^32
j,g,f,e,d,c,b,a=g,f,e,(d+t1)%2^32,c,b,a,(t1+t2)%2^32
end
h[1],h[2],h[3],h[4]=(h[1]+a)%2^32,(h[2]+b)%2^32,(h[3]+c)%2^32,(h[4]+d)%2^32
h[5],h[6],h[7],h[8]=(h[5]+e)%2^32,(h[6]+f)%2^32,(h[7]+g)%2^32,(h[8]+j)%2^32
end
return string.format(string.rep("%08x",8),h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8])
end
local unlocked=nil
env.VisualsV2Runtime.WeaponsUnlocked = function(entry)
if entry==nil then
if unlocked==nil then
local saved=C("vv2WeaponUnlock","")
unlocked=type(saved)=="string" and saved~="" and sha256(saved)==UNLOCK_HASH
end
return unlocked
end
return type(entry)=="string" and entry~="" and sha256(entry)==UNLOCK_HASH
end
end
env.VisualsV2Runtime.MakeBatcher = function(handler, budget, limit)
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
env.VisualsV2Runtime.GetObjects = function(url)
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
env.VisualsV2Runtime.DownloadsBusy = function() return busy or queued > 0 end
end
env.VisualsV2Runtime.RegisterReset = function(callback)
if type(callback) == "function" then table.insert(env.VisualsV2Runtime.Resetters, callback) end
end
env.VisualsV2Runtime.Cleanup = function()
if not runtimeAlive then return end
saveConfig()
runtimeAlive = false
configResetting = true
for _, resetter in ipairs(env.VisualsV2Runtime.Resetters or {}) do pcall(resetter) end
configResetting = false
end
;vv2Section(function()
local runtime=env.VisualsV2Runtime
local STARS={
{x=0.4207,y=0.4964,w=0.5367,h=0.5654,offset=0,rect={0,0,150,158}},
{x=0.6591,y=0.7061,w=0.3022,h=0.3102,offset=0.33,rect={152,0,92,94}},
{x=0.6998,y=0.3218,w=0.2544,h=0.2656,offset=0.66,rect={246,0,79,82}},
}
local ICON_SIZE=80
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
pcall(function() local old=parent:FindFirstChild("VisualsV2_Loading");if old then old:Destroy() end end)
local gui=Instance.new("ScreenGui")
gui.Name="VisualsV2_Loading"
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
loadingScreens.VisualsV2=card
local SIDE=-1
local cardOffset=nil
local function placeCard(dt)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local other=loadingScreens.WorldV2
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
text.Text="Visuals V2 is loading"
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
local STEPS=18
local function drawStar(holder)
local pieces={}
for step=1,STEPS do
local s=step/(STEPS+1)
local piece=Instance.new("Frame")
piece.Name="Piece"..step
piece.AnchorPoint=Vector2.new(0.5,0.5)
piece.Position=UDim2.fromScale(0.5,0.5)
piece.Size=UDim2.fromScale(s*s,(1-s)*(1-s))
piece.BackgroundColor3=Color3.fromRGB(255,255,255)
piece.BorderSizePixel=0
piece.Parent=holder
pieces[#pieces+1]=piece
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
image.Size=UDim2.fromScale(1,1)
image.BackgroundTransparency=1
image.Image=asset
showPart(image,star)
image.ScaleType=Enum.ScaleType.Fit
image.Parent=holder
sparkle.image=image
else
sparkle.pieces=drawStar(holder)
end
sparkles[index]=sparkle
end
gui.Parent=parent
local function useDrawn(sparkle)
if not sparkle.image then return end
pcall(function() sparkle.image:Destroy() end)
sparkle.image=nil
sparkle.pieces=drawStar(sparkle.holder)
end
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
if state:find("Failure",1,true) or state:find("TimedOut",1,true) then useDrawn(sparkle) end
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
if sparkle.image then sparkle.image.ImageTransparency=value
else for _,piece in ipairs(sparkle.pieces) do piece.BackgroundTransparency=value end end
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
local skins=runtime.ClientWeaponSkins
if skins and type(skins.GetDiagnostics)=="function" then
local ok,report=pcall(skins.GetDiagnostics)
if ok and type(report)=="table" then
for _,item in pairs(report.weapons or {}) do
if type(item)=="table" and item.loading then return "weapons" end
end
end
end
local inventory=runtime.VisualWeaponInventory
if inventory and type(inventory.GetDiagnostics)=="function" then
local ok,report=pcall(inventory.GetDiagnostics)
if ok and type(report)=="table" then
if report.preloading then return "pictures" end
for _,record in ipairs(report.inventories or {}) do
if record.building or (report.anyEnabled and record.dirty and not record.trading) then return "inventory" end
end
end
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
if loadingScreens.VisualsV2==card then loadingScreens.VisualsV2=nil end
end)
end
runtime.LoadingScreen={Finish=finish,Gui=gui,StillLoading=stillLoading}
task.delay(30,finish)
runtime.RegisterReset(function() if not runtimeAlive then animation:Disconnect();pcall(function() gui:Destroy() end) end end)
end,"Part at line 454")
;vv2Section(function()
local runtime=env.VisualsV2Runtime
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
;vv2Section(function()
local runtime=env.VisualsV2Runtime
local bridge=Instance.new("BindableFunction")
bridge.Name="VisualsV2_RuntimeBridge"
bridge:SetAttribute("VisualsV2_RuntimeBridge",true)
bridge.OnInvoke=function(operation)
if operation=="Cleanup" then runtime.Cleanup();return true end
if not runtimeAlive then return nil,"Visuals V2 is no longer running" end
return nil,"Unknown diagnostic operation"
end
bridge.Parent=LocalPlayer
runtime.RegisterReset(function()
if not runtimeAlive then bridge:Destroy() end
end)
end,"Part at line 778")
;vv2Section(function()
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local runtime=env.VisualsV2Runtime
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
local SETTLE=3
local lastOpenAt=-math.huge
-- (after the game sends a trade update, the trade counts as open for 30 s unless a trade window is
-- found and is closed, so nothing reconnects in the middle of a trade it didn't recognise)
local remoteAt=-math.huge
local function windowClosed()
if #trade.roots==0 then return false end
for _,root in ipairs(trade.roots) do
if root.Parent and shown(root,gui) then return false end
end
return true
end
local function scan()
gui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
table.clear(trade.roots)
table.clear(rootSet)
if not gui then return end
local pending={{gui,0}}
local inspected=0
while #pending>0 and inspected<4000 do
local entry=table.remove(pending)
for _,child in ipairs(entry[1]:GetChildren()) do
inspected=inspected+1
if isRoot(child) then
trade.roots[#trade.roots+1]=child;rootSet[child]=true
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
elseif trade.active and (os.clock()-lastOpenAt<SETTLE or (os.clock()-remoteAt<30 and not windowClosed())) then return end
if active==trade.active then return end
trade.active=active
if active then
for _,listener in ipairs(trade.listeners) do pcall(listener,true) end
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
function trade.InWindow(object)
if typeof(object)~="Instance" then return false end
-- Dynamic/nested trade inventories must be excluded before the next periodic scan.
local current=object
while current and current~=gui do
if rootSet[current] or isRoot(current) then return true end
current=current.Parent
end
return false
end

function trade.IsActive() return trade.active end
-- (a trade window being shown, or the game starting/updating a trade, is acted on at once rather
-- than at the next check, so nothing of this add-on is still in the inventory when trading begins)
local rootWatch=setmetatable({}, {__mode="k"})
local function opened()
if not runtimeAlive then return end
lastOpenAt=os.clock();remoteAt=os.clock()
if not trade.active then
trade.active=true
for _,listener in ipairs(trade.listeners) do pcall(listener,true) end
end
end
local function watchRoot(root)
if rootWatch[root] then return end
local property=root:IsA("LayerCollector") and "Enabled" or "Visible"
local ok,connection=pcall(function()
return root:GetPropertyChangedSignal(property):Connect(function()
if runtimeAlive then pcall(update) end
end)
end)
if ok then rootWatch[root]=connection end
end
local remoteWatch={}
local function watchRemotes()
local folder=game:GetService("ReplicatedStorage"):FindFirstChild("Trade")
if not folder then return end
for _,name in ipairs({"StartTrade","UpdateTrade"}) do
local remote=folder:FindFirstChild(name)
if remote and remote:IsA("RemoteEvent") and not remoteWatch[remote] then
remoteWatch[remote]=remote.OnClientEvent:Connect(function() opened() end)
end
end
end
local nextScan,elapsed=0,0
local connection
connection=RunService.Heartbeat:Connect(function(dt)
if not runtimeAlive then connection:Disconnect();trade.active=false;return end
elapsed=elapsed+dt
if elapsed<0.15 then return end
elapsed=0
local now=os.clock()
if now>=nextScan then
nextScan=now+2;pcall(scan)
for _,root in ipairs(trade.roots) do watchRoot(root) end
pcall(watchRemotes)
end
pcall(update)
end)
local watchedGui,guiWatch
local function watchGui()
local playerGui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
if not playerGui or playerGui==watchedGui or trade.active then return end
watchedGui=playerGui
if guiWatch then guiWatch:Disconnect() end
guiWatch=playerGui.DescendantAdded:Connect(function(object)
if trade.active or not runtimeAlive then return end
local ok,name=pcall(function() return object.Name end)
if ok and type(name)=="string" and name:find("[Tt][Rr][Aa][Dd]") and isRoot(object) then
nextScan=0;elapsed=1
pcall(watchRoot,object)
end
end)
end
pcall(watchGui)
LocalPlayer.ChildAdded:Connect(function(child) if child:IsA("PlayerGui") then pcall(watchGui) end end)
-- (while a trade is open the game rebuilds thousands of GUI objects; nothing of this add-on listens
-- to every one of them then, and the listeners come back when the trade ends)
trade.OnChanged(function(active)
if active then
if guiWatch then guiWatch:Disconnect();guiWatch=nil end
watchedGui=nil
else pcall(watchGui) end
end)
pcall(scan)
for _,root in ipairs(trade.roots) do watchRoot(root) end
pcall(watchRemotes)
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
local player = LocalPlayer
local camera = workspace.CurrentCamera
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local hatSection = mainTab:AddSection("Chinese Hat", "Cosmetic")
local hatEnabled = C("hatEnabled", false)
local legacyHatTransparency = tonumber(ConfigData["hatTransparency"])
local hatTransparency = tonumber(C("hatTransparencyLevel", nil))
if hatTransparency == nil then
if legacyHatTransparency ~= nil then
hatTransparency = math.clamp(math.floor((legacyHatTransparency * 4) + 1.5), 1, 5)
else
hatTransparency = 2
end
end
hatTransparency = math.clamp(math.floor(hatTransparency + 0.5), 1, 5)
local hatRainbow = C("hatRainbow", false)
local hatDualColor = C("hatDualColor", false)
local hatColor = C("hatColor",Color3.fromRGB(38,38,38))
local hatColor1 = C("hatColor1",Color3.fromRGB(38,38,38))
local hatColor2 = C("hatColor2",Color3.fromRGB(38,38,38))
local hatSize = math.clamp(tonumber(C("hatSize", 1)) or 1, 1, 3)
local hatHeight = C("hatHeight", 1.1)
local hatPart = nil
local hatConnection = nil
local characterConnection = nil
local function removeHat()
if hatPart then
pcall(function()
hatPart:Destroy()
end)
hatPart = nil
end
local char = player.Character
if char then
local existing = char:FindFirstChild("VisualsV2_ChineseHat")
if existing then
existing:Destroy()
end
end
end
local function currentHatColor()
if hatDualColor then
local t = (math.sin(tick() * 2) + 1) / 2
return hatColor1:Lerp(hatColor2, t)
elseif hatRainbow then
return Color3.fromHSV((tick() % 5) / 5, 1, 1)
end
return hatColor
end
local function updateHat()
if not hatPart or not hatPart.Parent then return end
hatPart.Transparency = ((math.clamp(tonumber(hatTransparency) or 2, 1, 5) - 1) / 4) * 0.8
hatPart.Color = currentHatColor()
local mesh = hatPart:FindFirstChildOfClass("SpecialMesh")
if mesh then
mesh.Scale = Vector3.new(
2.4 * (tonumber(hatSize) or 1),
1.6 * (tonumber(hatSize) or 1),
2.4 * (tonumber(hatSize) or 1)
)
end
local char = player.Character
local head = char and char:FindFirstChild("Head")
if head then
hatPart.CFrame = head.CFrame * CFrame.new(0, tonumber(hatHeight) or 1.1, 0)
end
end
local function addHat(char)
if not hatEnabled or not char then return end
local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
if not head then return end
removeHat()
local hat = Instance.new("Part")
hat.Name = "VisualsV2_ChineseHat"
hat.Size = Vector3.new(1, 1, 1)
hat.Transparency = ((math.clamp(tonumber(hatTransparency) or 2, 1, 5) - 1) / 4) * 0.8
hat.Color = currentHatColor()
hat.Material = Enum.Material.Neon
hat.Anchored = false
hat.CanCollide = false
hat.CanTouch = false
hat.CanQuery = false
hat.CastShadow = false
hat.Massless = true
hat.CFrame = head.CFrame * CFrame.new(0, tonumber(hatHeight) or 1.1, 0)
hat.Parent = char
local mesh = Instance.new("SpecialMesh")
mesh.MeshId = "rbxassetid://1033714"
mesh.Scale = Vector3.new(
2.4 * (tonumber(hatSize) or 1),
1.6 * (tonumber(hatSize) or 1),
2.4 * (tonumber(hatSize) or 1)
)
mesh.Parent = hat
local weld = Instance.new("WeldConstraint")
weld.Name = "VisualsV2_ChineseHatWeld"
weld.Part0 = head
weld.Part1 = hat
weld.Parent = hat
hatPart = hat
updateHat()
end
local function refreshHatConnection()
if hatConnection then
hatConnection:Disconnect()
hatConnection = nil
end
if hatEnabled then
hatConnection = RunService.Heartbeat:Connect(function()
if hatEnabled then
updateHat()
end
end)
end
end
local enableToggle = addToggle(hatSection, "Enable Chinese Hat", hatEnabled, function(state)
hatEnabled = state
SetCfg("hatEnabled", state)
if state then
addHat(player.Character)
else
removeHat()
end
refreshHatConnection()
end)
local rainbowToggle = addToggle(hatSection, "Rainbow Hat", hatRainbow, function(state)
hatRainbow = state
SetCfg("hatRainbow", state)
updateHat()
end)
local dualColorToggle = addToggle(hatSection, "Dual Color Hat", hatDualColor, function(state)
hatDualColor = state
SetCfg("hatDualColor", state)
updateHat()
end)
hatSection:AddSlider("Transparency", 1, 5, hatTransparency, function(value)
hatTransparency = math.clamp(math.floor((tonumber(value) or 2) + 0.5), 1, 5)
SetCfg("hatTransparencyLevel", hatTransparency)
updateHat()
end)
hatSection:AddColorpicker("Base Color", hatColor, function(color)
hatColor = color
SetCfg("hatColor", color)
updateHat()
end)
hatSection:AddColorpicker("Color 1", hatColor1, function(color)
hatColor1 = color
SetCfg("hatColor1", color)
updateHat()
end)
hatSection:AddColorpicker("Color 2", hatColor2, function(color)
hatColor2 = color
SetCfg("hatColor2", color)
updateHat()
end)
hatSection:AddSlider("Hat Size", 1, 3, hatSize, function(value)
hatSize = tonumber(value) or 1
SetCfg("hatSize", hatSize)
if hatEnabled then
addHat(player.Character)
end
end)
hatSection:AddSlider("Hat Height", 0.5, 3, hatHeight, function(value)
hatHeight = tonumber(value) or 1.1
SetCfg("hatHeight", hatHeight)
if hatEnabled then
addHat(player.Character)
end
end)
characterConnection = player.CharacterAdded:Connect(function(char)
if not hatEnabled then return end
task.wait(1)
if hatEnabled then
addHat(char)
refreshHatConnection()
end
end)
env.VisualsV2Runtime.RegisterReset(function()
enableToggle:Set(false)
rainbowToggle:Set(false)
dualColorToggle:Set(false)
hatEnabled = false
hatRainbow = false
hatDualColor = false
hatTransparency = 2
hatColor = Color3.fromRGB(255, 255, 255)
hatColor1 = Color3.fromRGB(255, 255, 255)
hatColor2 = Color3.fromRGB(0, 0, 0)
hatSize = 1
hatHeight = 1.1
if hatConnection then
hatConnection:Disconnect()
hatConnection = nil
end
removeHat()
end)
if hatEnabled and player.Character then
task.defer(function()
task.wait(0.5)
if hatEnabled then
addHat(player.Character)
refreshHatConnection()
end
end)
end
end,"Section \"Chinese Hat\"")
;vv2Section(function()
local section=mainTab:AddSection("Multi Hat Giver","Cosmetic")
local enabled=C("multiHatEnabled",false)
local names={"None","Dominus Astra","Valkyrie","Clockwork","Extreme Headphones","Fiery Horns","Frozen Horns","Poisoned Horns","Custom"}
local ids={["None"]=0,["Dominus Astra"]=162067148,["Valkyrie"]=1365767,["Clockwork"]=1235488,["Extreme Headphones"]=96079043,["Fiery Horns"]=215718515,["Frozen Horns"]=74891470,["Poisoned Horns"]=1744060292,["Custom"]=0}
local selected={C("multiHatSlot1","None"),C("multiHatSlot2","None"),C("multiHatSlot3","None")}
local custom={tonumber(C("multiHatCustom1",0)) or 0,tonumber(C("multiHatCustom2",0)) or 0,tonumber(C("multiHatCustom3",0)) or 0}
local active={}
local applyTokens={}
local hatModels={}
local hatDownloads={}
local function hatCopy(id)
while hatDownloads[id] do task.wait(0.05) end
local model=hatModels[id]
if not model then
hatDownloads[id]=true
local download=env.VisualsV2Runtime.GetObjects
local ok,objects=pcall(function()
if type(download)=="function" then return download("rbxassetid://"..id) end
return game:GetObjects("rbxassetid://"..id)
end)
hatDownloads[id]=nil
if not ok or type(objects)~="table" or not objects[1] then return nil end
model=objects[1]
for index=2,#objects do pcall(function() objects[index]:Destroy() end) end
hatModels[id]=model
end
local ok,copy=pcall(function() return model:Clone() end)
if ok and copy then return copy end
hatModels[id]=nil
return model
end
local function clear(i)
local accessory=active[i]
active[i]=nil
if accessory then pcall(function() accessory:Destroy() end) end
-- Older releases kept this addon's welds under Head instead of the accessory.
local character=player.Character
for _,joint in ipairs(character and character:GetDescendants() or {}) do
if joint.Name=="VisualsV2_MultiHatWeld" and joint:IsA("JointInstance") then
local handle=joint.Part1
if not handle or not handle.Parent or (accessory and handle:IsDescendantOf(accessory)) then joint:Destroy() end
end
end
end
local function findAttachment(root,name)
for _,object in ipairs(root:GetDescendants()) do
if object:IsA("Attachment") and object.Name==name and object.Parent:IsA("BasePart") then return object end
end
end
local function hatTarget(character)
local target=env.VisualsV2Runtime.VisualAvatarHatTarget
if type(target)=="function" then
local ok,parent,head=pcall(target,character)
if ok and parent and head and head:IsA("BasePart") and head.Parent then return parent,head end
end
return character,character and character:FindFirstChild("Head")
end
local function mount(accessory,character,parent,head)
if not character or player.Character~=character or not parent or not head or not head.Parent then return false end
local handle=accessory:FindFirstChild("Handle")
if not handle or not handle:IsA("BasePart") then return false end
for _,object in ipairs(accessory:GetDescendants()) do
if object:IsA("BasePart") then
object.Anchored=false;object.CanCollide=false;object.CanTouch=false;object.CanQuery=false;object.Massless=true
end
end
for _,joint in ipairs(handle:GetChildren()) do
if (joint.Name=="AccessoryWeld" or joint.Name=="VisualsV2_MultiHatWeld")
and (joint:IsA("JointInstance") or joint:IsA("WeldConstraint") or joint:IsA("RigidConstraint")) then joint:Destroy() end
end
local attachment=handle:FindFirstChildOfClass("Attachment")
local matching=attachment and findAttachment(head,attachment.Name)
if attachment and not matching then
for _,part in ipairs(head.Parent:GetChildren()) do
if part:IsA("BasePart") and part~=head then
matching=findAttachment(part,attachment.Name)
if matching then break end
end
end
end
local weld=Instance.new("Weld")
weld.Name="VisualsV2_MultiHatWeld"
weld.Part0=matching and matching.Parent or head
weld.Part1=handle
if matching then
weld.C0=matching.CFrame;weld.C1=attachment.CFrame
else
weld.C0=CFrame.new(0,0.5,0)
weld.C1=accessory:IsA("Accoutrement") and accessory.AttachmentPoint or CFrame.new()
end
handle.CFrame=weld.Part0.CFrame*weld.C0*weld.C1:Inverse()
weld.Parent=handle
accessory.Parent=parent
local track=env.VisualsV2Runtime.TrackVisualAvatarHat
if type(track)=="function" then pcall(track,accessory) end
return true
end
local function apply(i)
local token=(applyTokens[i] or 0)+1
applyTokens[i]=token
clear(i)
if not enabled or not runtimeAlive then return end
local id=(selected[i]=="Custom") and custom[i] or (ids[selected[i]] or 0)
if id==0 then return end
local character=player.Character
local parent,head=hatTarget(character)
if not head then return end
local accessory=hatCopy(id)
if not accessory then return end
local currentParent,currentHead=hatTarget(character)
if applyTokens[i]~=token or not enabled or not runtimeAlive or player.Character~=character
or currentParent~=parent or currentHead~=head or not head.Parent then
pcall(function() accessory:Destroy() end)
return
end
accessory.Name="VisualsV2_MultiHat_Slot"..i
if mount(accessory,character,parent,head) then active[i]=accessory
else pcall(function() accessory:Destroy() end) end
end
local function refresh() for i=1,3 do apply(i) end end
local function rebindVisualHats()
if not enabled or not runtimeAlive then return end
local character=player.Character
local parent,head=hatTarget(character)
for i=1,3 do
local accessory=active[i]
if accessory and accessory.Parent and head and mount(accessory,character,parent,head) then
-- Reuse the same accessory, including its original particle/effect objects.
else
clear(i)
task.defer(apply,i)
end
end
end
env.VisualsV2Runtime.RefreshVisualHats=rebindVisualHats
local toggle=addToggle(section,"VV2 Enable Hat Giver",enabled,function(v)
enabled=v; SetCfg("multiHatEnabled",v)
if v then refresh() else for i=1,3 do clear(i) end end
end)
for i=1,3 do
addDropdown(section,"VV2 Hat Slot "..i,names,selected[i],function(v)
selected[i]=v; SetCfg("multiHatSlot"..i,v); if enabled then apply(i) end
end)
section:AddTextBox("VV2 Custom ID Slot "..i,function(v)
local n=tonumber(v); if not n then return end
custom[i]=n; SetCfg("multiHatCustom"..i,n)
if enabled and selected[i]=="Custom" then apply(i) end
end)
end
player.CharacterAdded:Connect(function() task.wait(1.5); if enabled then refresh() end end)
env.VisualsV2Runtime.RegisterReset(function()
toggle:Set(false); enabled=false; for i=1,3 do clear(i) end
if not runtimeAlive then
for id,model in pairs(hatModels) do pcall(function() model:Destroy() end);hatModels[id]=nil end
end
end)
if enabled then task.defer(refresh) end
end,"Section \"Multi Hat Giver\"")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
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
self:_cleanupTask(task)
end
self._tasks = {}
end
function Maid:Destroy()
self:DoCleaning()
end
local RootMaid = Maid.new()
local alive = true
local resetSection
env.VisualsV2Runtime.RegisterReset(function()
if not runtimeAlive then
alive = false
RootMaid:DoCleaning()
elseif resetSection then
resetSection()
end
end)
local loaderCheck = task.spawn(function()
local CoreGui = game:GetService("CoreGui")
local target
while alive and runtimeAlive and not target do
target = CoreGui:FindFirstChild("@bubbles.elia", true)
if not target then task.wait(0.1) end
end
if not alive or not runtimeAlive or not target or not target.Parent then return end
local version = target.Parent:FindFirstChild("Version", true)
while alive and runtimeAlive do
if version and (version.Text:find("v3.2", 1, true) or version.Text:find("v3.5", 1, true)) then
shared.kick("Malicious Loader Detected.\n\nUse the official script only available in discord.gg/overdrivehub")
break
end
task.wait(0.1)
end
end)
RootMaid:GiveTask(function() pcall(task.cancel, loaderCheck) end)
local feAnimSection = mainTab:AddSection("FE Animations", "Cosmetic")
local animPresets = {
["Default"] = nil,
["OG Rthro Run"] = {run = "http://www.roblox.com/asset/?id=9801814462"},
["Vampire"] = {
idle1 = "http://www.roblox.com/asset/?id=1083445855",
idle2 = "http://www.roblox.com/asset/?id=1083450166",
walk = "http://www.roblox.com/asset/?id=1083473930",
run = "http://www.roblox.com/asset/?id=1083462077",
jump = "http://www.roblox.com/asset/?id=1083455352",
climb = "http://www.roblox.com/asset/?id=1083439238",
fall = "http://www.roblox.com/asset/?id=1083443587"
},
["Hero"] = {
idle1 = "http://www.roblox.com/asset/?id=616111295",
idle2 = "http://www.roblox.com/asset/?id=616113536",
walk = "http://www.roblox.com/asset/?id=616122287",
run = "http://www.roblox.com/asset/?id=616117076",
jump = "http://www.roblox.com/asset/?id=616115533",
climb = "http://www.roblox.com/asset/?id=616104706",
fall = "http://www.roblox.com/asset/?id=616108001"
},
["Zombie Classic"] = {
idle1 = "http://www.roblox.com/asset/?id=616158929",
idle2 = "http://www.roblox.com/asset/?id=616160636",
walk = "http://www.roblox.com/asset/?id=616168032",
run = "http://www.roblox.com/asset/?id=616163682",
jump = "http://www.roblox.com/asset/?id=616161997",
climb = "http://www.roblox.com/asset/?id=616156119",
fall = "http://www.roblox.com/asset/?id=616157476"
},
["Mage"] = {
idle1 = "http://www.roblox.com/asset/?id=707742142",
idle2 = "http://www.roblox.com/asset/?id=707855907",
walk = "http://www.roblox.com/asset/?id=707897309",
run = "http://www.roblox.com/asset/?id=707861613",
jump = "http://www.roblox.com/asset/?id=707853694",
climb = "http://www.roblox.com/asset/?id=707826056",
fall = "http://www.roblox.com/asset/?id=707829716"
},
["Ghost"] = {
idle1 = "http://www.roblox.com/asset/?id=616006778",
idle2 = "http://www.roblox.com/asset/?id=616008087",
walk = "http://www.roblox.com/asset/?id=616010382",
run = "http://www.roblox.com/asset/?id=616013216",
jump = "http://www.roblox.com/asset/?id=616008936",
climb = "http://www.roblox.com/asset/?id=616003713",
fall = "http://www.roblox.com/asset/?id=616005863"
},
["Elder"] = {
idle1 = "http://www.roblox.com/asset/?id=845397899",
idle2 = "http://www.roblox.com/asset/?id=845400520",
walk = "http://www.roblox.com/asset/?id=845403856",
run = "http://www.roblox.com/asset/?id=845386501",
jump = "http://www.roblox.com/asset/?id=845398858",
climb = "http://www.roblox.com/asset/?id=845392038",
fall = "http://www.roblox.com/asset/?id=845396048"
},
["Levitation"] = {
idle1 = "http://www.roblox.com/asset/?id=616006778",
idle2 = "http://www.roblox.com/asset/?id=616008087",
walk = "http://www.roblox.com/asset/?id=616013216",
run = "http://www.roblox.com/asset/?id=616010382",
jump = "http://www.roblox.com/asset/?id=616008936",
climb = "http://www.roblox.com/asset/?id=616003713",
fall = "http://www.roblox.com/asset/?id=616005863"
},
["Astronaut"] = {
idle1 = "http://www.roblox.com/asset/?id=891621366",
idle2 = "http://www.roblox.com/asset/?id=891633237",
walk = "http://www.roblox.com/asset/?id=891667138",
run = "http://www.roblox.com/asset/?id=891636393",
jump = "http://www.roblox.com/asset/?id=891627522",
climb = "http://www.roblox.com/asset/?id=891609353",
fall = "http://www.roblox.com/asset/?id=891617961"
},
["Ninja"] = {
idle1 = "http://www.roblox.com/asset/?id=656117400",
idle2 = "http://www.roblox.com/asset/?id=656118341",
walk = "http://www.roblox.com/asset/?id=656121766",
run = "http://www.roblox.com/asset/?id=656118852",
jump = "http://www.roblox.com/asset/?id=656117878",
climb = "http://www.roblox.com/asset/?id=656114359",
fall = "http://www.roblox.com/asset/?id=656115606"
},
["Werewolf"] = {
idle1 = "http://www.roblox.com/asset/?id=1083195517",
idle2 = "http://www.roblox.com/asset/?id=1083214717",
walk = "http://www.roblox.com/asset/?id=1083178339",
run = "http://www.roblox.com/asset/?id=1083216690",
jump = "http://www.roblox.com/asset/?id=1083218792",
climb = "http://www.roblox.com/asset/?id=1083182000",
fall = "http://www.roblox.com/asset/?id=1083189019"
},
["Cartoon"] = {
idle1 = "http://www.roblox.com/asset/?id=742637544",
idle2 = "http://www.roblox.com/asset/?id=742638445",
walk = "http://www.roblox.com/asset/?id=742640026",
run = "http://www.roblox.com/asset/?id=742638842",
jump = "http://www.roblox.com/asset/?id=742637942",
climb = "http://www.roblox.com/asset/?id=742636889",
fall = "http://www.roblox.com/asset/?id=742637151"
},
["Pirate"] = {
idle1 = "http://www.roblox.com/asset/?id=750781874",
idle2 = "http://www.roblox.com/asset/?id=750782770",
walk = "http://www.roblox.com/asset/?id=750785693",
run = "http://www.roblox.com/asset/?id=750783738",
jump = "http://www.roblox.com/asset/?id=750782230",
climb = "http://www.roblox.com/asset/?id=750779899",
fall = "http://www.roblox.com/asset/?id=750780242"
},
["Sneaky"] = {
idle1 = "http://www.roblox.com/asset/?id=1132473842",
idle2 = "http://www.roblox.com/asset/?id=1132477671",
walk = "http://www.roblox.com/asset/?id=1132510133",
run = "http://www.roblox.com/asset/?id=1132494274",
jump = "http://www.roblox.com/asset/?id=1132489853",
climb = "http://www.roblox.com/asset/?id=1132461372",
fall = "http://www.roblox.com/asset/?id=1132469004"
},
["Toy"] = {
idle1 = "http://www.roblox.com/asset/?id=782841498",
idle2 = "http://www.roblox.com/asset/?id=782845736",
walk = "http://www.roblox.com/asset/?id=782843345",
run = "http://www.roblox.com/asset/?id=782842708",
jump = "http://www.roblox.com/asset/?id=782847020",
climb = "http://www.roblox.com/asset/?id=782843869",
fall = "http://www.roblox.com/asset/?id=782846423"
},
["Knight"] = {
idle1 = "http://www.roblox.com/asset/?id=657595757",
idle2 = "http://www.roblox.com/asset/?id=657568135",
walk = "http://www.roblox.com/asset/?id=657552124",
run = "http://www.roblox.com/asset/?id=657564596",
jump = "http://www.roblox.com/asset/?id=658409194",
climb = "http://www.roblox.com/asset/?id=658360781",
fall = "http://www.roblox.com/asset/?id=657600338"
},
["Confident"] = {
idle1 = "http://www.roblox.com/asset/?id=1069977950",
idle2 = "http://www.roblox.com/asset/?id=1069987858",
walk = "http://www.roblox.com/asset/?id=1070017263",
run = "http://www.roblox.com/asset/?id=1070001516",
jump = "http://www.roblox.com/asset/?id=1069984524",
climb = "http://www.roblox.com/asset/?id=1069946257",
fall = "http://www.roblox.com/asset/?id=1069973677"
},
["Popstar"] = {
idle1 = "http://www.roblox.com/asset/?id=1212900985",
idle2 = "http://www.roblox.com/asset/?id=1212900985",
walk = "http://www.roblox.com/asset/?id=1212980338",
run = "http://www.roblox.com/asset/?id=1212980348",
jump = "http://www.roblox.com/asset/?id=1212954642",
climb = "http://www.roblox.com/asset/?id=1213044953",
fall = "http://www.roblox.com/asset/?id=1212900995"
},
["Princess"] = {
idle1 = "http://www.roblox.com/asset/?id=941003647",
idle2 = "http://www.roblox.com/asset/?id=941013098",
walk = "http://www.roblox.com/asset/?id=941028902",
run = "http://www.roblox.com/asset/?id=941015281",
jump = "http://www.roblox.com/asset/?id=941008832",
climb = "http://www.roblox.com/asset/?id=940996062",
fall = "http://www.roblox.com/asset/?id=941000007"
},
["Cowboy"] = {
idle1 = "http://www.roblox.com/asset/?id=1014390418",
idle2 = "http://www.roblox.com/asset/?id=1014398616",
walk = "http://www.roblox.com/asset/?id=1014421541",
run = "http://www.roblox.com/asset/?id=1014401683",
jump = "http://www.roblox.com/asset/?id=1014394726",
climb = "http://www.roblox.com/asset/?id=1014380606",
fall = "http://www.roblox.com/asset/?id=1014384571"
},
["Patrol"] = {
idle1 = "http://www.roblox.com/asset/?id=1149612882",
idle2 = "http://www.roblox.com/asset/?id=1150842221",
walk = "http://www.roblox.com/asset/?id=1151231493",
run = "http://www.roblox.com/asset/?id=1150967949",
jump = "http://www.roblox.com/asset/?id=1150944216",
climb = "http://www.roblox.com/asset/?id=1148811837",
fall = "http://www.roblox.com/asset/?id=1148863382"
},
["Zombie FE"] = {
idle1 = "http://www.roblox.com/asset/?id=3489171152",
idle2 = "http://www.roblox.com/asset/?id=3489171152",
walk = "http://www.roblox.com/asset/?id=3489174223",
run = "http://www.roblox.com/asset/?id=3489173414",
jump = "http://www.roblox.com/asset/?id=616161997",
climb = "http://www.roblox.com/asset/?id=616156119",
fall = "http://www.roblox.com/asset/?id=616157476"
},
["Catwalk Glam"] = {
idle1 = "http://www.roblox.com/asset/?id=133806214992291",
idle2 = "http://www.roblox.com/asset/?id=133806214992291",
walk = "http://www.roblox.com/asset/?id=109168724482748",
run = "http://www.roblox.com/asset/?id=81024476153754",
jump = "http://www.roblox.com/asset/?id=116936326516985",
climb = "http://www.roblox.com/asset/?id=119377220967554",
fall = "http://www.roblox.com/asset/?id=92294537340807"
},
["Amazon Unboxed"] = {
idle1 = "http://www.roblox.com/asset/?id=98281136301627",
idle2 = "http://www.roblox.com/asset/?id=98281136301627",
walk = "http://www.roblox.com/asset/?id=90478085024465",
run = "http://www.roblox.com/asset/?id=134824450619865",
jump = "http://www.roblox.com/asset/?id=121454505477205",
climb = "http://www.roblox.com/asset/?id=121145883950231",
fall = "http://www.roblox.com/asset/?id=94788218468396"
},
["Glow Motion"] = {
idle1 = "https://www.roblox.com/asset/?id=137764781910579",
idle2 = "https://www.roblox.com/asset/?id=137764781910579",
walk = "http://www.roblox.com/asset/?id=85809016093530",
run = "http://www.roblox.com/asset/?id=101925097435036",
jump = "http://www.roblox.com/asset/?id=74159004634379",
climb = "http://www.roblox.com/asset/?id=108236155509584",
fall = "https://www.roblox.com/asset/?id=98070939608691"
},
["Bubbly"] = {
idle1 = "https://www.roblox.com/asset/?id=10921054344",
idle2 = "https://www.roblox.com/asset/?id=10921054344",
walk = "http://www.roblox.com/asset/?id=10980888364",
run = "http://www.roblox.com/asset/?id=10921057244",
jump = "http://www.roblox.com/asset/?id=10921062673",
climb = "http://www.roblox.com/asset/?id=10921053544",
fall = "https://www.roblox.com/asset/?id=10921061530"
},
["Adidas Comm"] = {
idle1 = "https://www.roblox.com/asset/?id=122257458498464",
idle2 = "https://www.roblox.com/asset/?id=122257458498464",
walk = "http://www.roblox.com/asset/?id=122150855457006",
run = "http://www.roblox.com/asset/?id=82598234841035",
jump = "http://www.roblox.com/asset/?id=75290611992385",
climb = "http://www.roblox.com/asset/?id=88763136693023",
fall = "https://www.roblox.com/asset/?id=98600215928904"
},
["KATSEYE"] = {
idle1 = "https://www.roblox.com/asset/?id=108187809145790",
idle2 = "https://www.roblox.com/asset/?id=108187809145790",
walk = "http://www.roblox.com/asset/?id=99182913548783",
run = "http://www.roblox.com/asset/?id=73117360545482",
jump = "http://www.roblox.com/asset/?id=103632305262747",
climb = "http://www.roblox.com/asset/?id=106213237973858",
fall = "https://www.roblox.com/asset/?id=127802717128367"
},
["Wicked Popular"] = {
idle1 = "https://www.roblox.com/asset/?id=118832222982049",
idle2 = "https://www.roblox.com/asset/?id=118832222982049",
walk = "http://www.roblox.com/asset/?id=92072849924640",
run = "http://www.roblox.com/asset/?id=72301599441680",
jump = "http://www.roblox.com/asset/?id=104325245285198",
climb = "http://www.roblox.com/asset/?id=131326830509784",
fall = "https://www.roblox.com/asset/?id=121152442762481"
},
["Dizzy"] = {
idle1 = "http://www.roblox.com/asset/?id=132806359718468",
idle2 = "http://www.roblox.com/asset/?id=132806359718468",
walk = "http://www.roblox.com/asset/?id=110106034100313",
run = "http://www.roblox.com/asset/?id=138305342272849",
jump = "http://www.roblox.com/asset/?id=108564434408211",
climb = "http://www.roblox.com/asset/?id=93550710314258",
fall = "http://www.roblox.com/asset/?id=138967706335414"
},
["WDTL"] = {
idle1 = "http://www.roblox.com/asset/?id=92849173543269",
idle2 = "http://www.roblox.com/asset/?id=92849173543269",
walk = "http://www.roblox.com/asset/?id=73718308412641",
run = "http://www.roblox.com/asset/?id=135515454877967",
jump = "http://www.roblox.com/asset/?id=78508480717326",
climb = "http://www.roblox.com/asset/?id=129447497744818",
fall = "http://www.roblox.com/asset/?id=78147885297412"
},
["Billie Eilish"] = {
idle1 = "http://www.roblox.com/asset/?id=102934602884410",
idle2 = "http://www.roblox.com/asset/?id=102934602884410",
walk = "http://www.roblox.com/asset/?id=81877886552514",
run = "http://www.roblox.com/asset/?id=100920560634123",
jump = "http://www.roblox.com/asset/?id=117602630922781",
climb = "http://www.roblox.com/asset/?id=117873469361430",
fall = "http://www.roblox.com/asset/?id=81072141180299"
},
["Cute Bouncy"] = {
idle1 = "http://www.roblox.com/asset/?id=88464649697812",
idle2 = "http://www.roblox.com/asset/?id=88464649697812",
walk = "http://www.roblox.com/asset/?id=98713727778027",
run = "http://www.roblox.com/asset/?id=133955346539948",
jump = "http://www.roblox.com/asset/?id=124147147418885",
climb = "http://www.roblox.com/asset/?id=95542189442725",
fall = "http://www.roblox.com/asset/?id=128620818122982"
},
["Cute"] = {
idle1 = "http://www.roblox.com/asset/?id=85735421117197",
idle2 = "http://www.roblox.com/asset/?id=85735421117197",
walk = "http://www.roblox.com/asset/?id=140409718187215",
run = "http://www.roblox.com/asset/?id=118375157537412",
jump = "http://www.roblox.com/asset/?id=132381016103721",
climb = "http://www.roblox.com/asset/?id=86318575131600",
fall = "http://www.roblox.com/asset/?id=77496925287217"
},
["Jolly"] = {
idle1 = "http://www.roblox.com/asset/?id=136145727878709",
idle2 = "http://www.roblox.com/asset/?id=136145727878709",
walk = "http://www.roblox.com/asset/?id=83277136078444",
run = "http://www.roblox.com/asset/?id=124419804298310",
jump = "http://www.roblox.com/asset/?id=122115816220842",
climb = "http://www.roblox.com/asset/?id=107190574095036",
fall = "http://www.roblox.com/asset/?id=85263802503331"
},
["Cute Kawaii"] = {
idle1 = "http://www.roblox.com/asset/?id=72311682331639",
idle2 = "http://www.roblox.com/asset/?id=72311682331639",
walk = "http://www.roblox.com/asset/?id=107212872423561",
run = "http://www.roblox.com/asset/?id=118582510545072",
jump = "http://www.roblox.com/asset/?id=112952548321695",
climb = "http://www.roblox.com/asset/?id=126383408493776",
fall = "http://www.roblox.com/asset/?id=83307333809322"
},
["Doll 3.0"] = {
idle1 = "http://www.roblox.com/asset/?id=83032187271383",
idle2 = "http://www.roblox.com/asset/?id=83032187271383",
walk = "http://www.roblox.com/asset/?id=78434960966537",
run = "http://www.roblox.com/asset/?id=129768396663808",
jump = "http://www.roblox.com/asset/?id=75369057994828",
climb = "http://www.roblox.com/asset/?id=112371892133970",
fall = "http://www.roblox.com/asset/?id=81027444073311"
},
["Victoria Model"] = {
idle1 = "http://www.roblox.com/asset/?id=132069965396465",
idle2 = "http://www.roblox.com/asset/?id=132069965396465",
walk = "http://www.roblox.com/asset/?id=84814915379579",
run = "http://www.roblox.com/asset/?id=84814915379579",
jump = "http://www.roblox.com/asset/?id=78163261581163",
climb = "http://www.roblox.com/asset/?id=87772134905508",
fall = "http://www.roblox.com/asset/?id=110073924253388"
},
["Bike/Bicyclist"] = {
idle1 = "http://www.roblox.com/asset/?id=126390120399173",
idle2 = "http://www.roblox.com/asset/?id=136791517336633",
walk = "http://www.roblox.com/asset/?id=98707881660541",
run = "http://www.roblox.com/asset/?id=102775737211919",
jump = "http://www.roblox.com/asset/?id=129144847881258",
climb = "http://www.roblox.com/asset/?id=88267082364595",
fall = "http://www.roblox.com/asset/?id=110684787086498"
},
["Animal"] = {
idle1 = "http://www.roblox.com/asset/?id=128838183008466",
idle2 = "http://www.roblox.com/asset/?id=99689776099970",
walk = "http://www.roblox.com/asset/?id=112238064449133",
run = "http://www.roblox.com/asset/?id=97412731442167",
jump = "http://www.roblox.com/asset/?id=123565665274439",
climb = "http://www.roblox.com/asset/?id=75085836535654",
fall = "http://www.roblox.com/asset/?id=124705831982259"
},
["It-Girl Essential Model"] = {
idle1 = "http://www.roblox.com/asset/?id=132232079260125",
idle2 = "http://www.roblox.com/asset/?id=102440789796215",
walk = "http://www.roblox.com/asset/?id=86579666661215",
run = "http://www.roblox.com/asset/?id=83336349930143",
jump = "http://www.roblox.com/asset/?id=103382156539106",
climb = "http://www.roblox.com/asset/?id=77385815954046",
fall = "http://www.roblox.com/asset/?id=127262648208409"
},
["Oldschool"] = {
idle1 = "http://www.roblox.com/asset/?id=10921230744",
idle2 = "http://www.roblox.com/asset/?id=10921232093",
walk = "http://www.roblox.com/asset/?id=10921244891",
run = "http://www.roblox.com/asset/?id=10921240218",
jump = "http://www.roblox.com/asset/?id=10921242013",
climb = "http://www.roblox.com/asset/?id=10921229866",
fall = "http://www.roblox.com/asset/?id=10921241244"
},
["Spider"] = {
idle1 = "http://www.roblox.com/asset/?id=112316814377814",
idle2 = "http://www.roblox.com/asset/?id=103439018552145",
walk = "http://www.roblox.com/asset/?id=109976439277879",
run = "http://www.roblox.com/asset/?id=119985832593347",
jump = "http://www.roblox.com/asset/?id=87979233462906",
climb = "http://www.roblox.com/asset/?id=119278342251995",
fall = "http://www.roblox.com/asset/?id=71112238570777"
},
["Joy"] = {
idle1 = "http://www.roblox.com/asset/?id=119957475250242",
idle2 = "http://www.roblox.com/asset/?id=101200477339169",
walk = "http://www.roblox.com/asset/?id=112597572150963",
run = "http://www.roblox.com/asset/?id=96521659811743",
jump = "http://www.roblox.com/asset/?id=82500357520736",
climb = "http://www.roblox.com/asset/?id=110061716873830",
fall = "http://www.roblox.com/asset/?id=132095139090357"
},
["Flying Aura"] = {
idle1 = "http://www.roblox.com/asset/?id=122426844584505",
idle2 = "http://www.roblox.com/asset/?id=122426844584505",
walk = "http://www.roblox.com/asset/?id=83077254246622",
run = "http://www.roblox.com/asset/?id=77053251062908",
jump = "http://www.roblox.com/asset/?id=125422018244301",
climb = "http://www.roblox.com/asset/?id=95973965948476",
fall = "http://www.roblox.com/asset/?id=109790195947848"
},
["FHA V2"] = {
idle1 = "http://www.roblox.com/asset/?id=77320840005481",
idle2 = "http://www.roblox.com/asset/?id=77320840005481",
walk = "http://www.roblox.com/asset/?id=134493251445479",
run = "http://www.roblox.com/asset/?id=122214533401932",
jump = "http://www.roblox.com/asset/?id=80078165493816",
climb = "http://www.roblox.com/asset/?id=114562994724647",
fall = "http://www.roblox.com/asset/?id=98383265864436"
},
["Silent Nurse"] = {
idle1 = "http://www.roblox.com/asset/?id=111047244862844",
idle2 = "http://www.roblox.com/asset/?id=111047244862844",
walk = "http://www.roblox.com/asset/?id=94196382152901",
run = "http://www.roblox.com/asset/?id=94196382152901",
jump = "http://www.roblox.com/asset/?id=106098057235980",
climb = "http://www.roblox.com/asset/?id=108985375609705",
fall = "http://www.roblox.com/asset/?id=131579609334755"
},
["Supermodel"] = {
idle1 = "http://www.roblox.com/asset/?id=91917730726110",
idle2 = "http://www.roblox.com/asset/?id=91917730726110",
walk = "http://www.roblox.com/asset/?id=90320132970213",
run = "http://www.roblox.com/asset/?id=112051258179255",
jump = "http://www.roblox.com/asset/?id=91931403363860",
climb = "http://www.roblox.com/asset/?id=82728029306069",
fall = "http://www.roblox.com/asset/?id=119173466228299"
},
["Enchanted Fairy"] = {
idle1 = "http://www.roblox.com/asset/?id=73650178233095",
idle2 = "http://www.roblox.com/asset/?id=73650178233095",
walk = "http://www.roblox.com/asset/?id=94547195663763",
run = "http://www.roblox.com/asset/?id=76909584337943",
jump = "http://www.roblox.com/asset/?id=120533712803667",
climb = "http://www.roblox.com/asset/?id=140663406485180",
fall = "http://www.roblox.com/asset/?id=100947971756348"
},
["Furry"] = {
idle1 = "http://www.roblox.com/asset/?id=111821292044705",
idle2 = "http://www.roblox.com/asset/?id=111821292044705",
walk = "http://www.roblox.com/asset/?id=104011441852459",
run = "http://www.roblox.com/asset/?id=87770060317862",
jump = "http://www.roblox.com/asset/?id=102635582722041",
climb = "http://www.roblox.com/asset/?id=76660530164497",
fall = "http://www.roblox.com/asset/?id=137079985547592"
},
["Vlada Model"] = {
idle1 = "http://www.roblox.com/asset/?id=100139116433530",
idle2 = "http://www.roblox.com/asset/?id=100139116433530",
walk = "http://www.roblox.com/asset/?id=77983757225444",
run = "http://www.roblox.com/asset/?id=116717848244930",
jump = "http://www.roblox.com/asset/?id=120751055172567",
climb = "http://www.roblox.com/asset/?id=70966616077778",
fall = "http://www.roblox.com/asset/?id=136118518255777"
},
["R6 Converter"] = {
idle1 = "http://www.roblox.com/asset/?id=90040240627854",
idle2 = "http://www.roblox.com/asset/?id=90040240627854",
walk = "http://www.roblox.com/asset/?id=92149852708428",
run = "http://www.roblox.com/asset/?id=72259383092959",
jump = "http://www.roblox.com/asset/?id=130519980521511",
climb = "http://www.roblox.com/asset/?id=80369171706383",
fall = "http://www.roblox.com/asset/?id=130011792193300"
},
["R6 Gear Hold"] = {
idle1 = "rbxassetid://92453281924797",
idle2 = "rbxassetid://89893748940721",
walk = "rbxassetid://114884344098450",
run = "rbxassetid://131634789076585",
jump = "rbxassetid://137659653949709",
fall = "rbxassetid://75834860496519",
climb = "rbxassetid://125215321499925",
swim = "rbxassetid://113534064176043",
swimidle = "rbxassetid://140107830121953",
},
["Slow Meteorite"] = {
idle1 = "rbxassetid://109728654207229",
idle2 = "rbxassetid://109728654207229",
walk = "rbxassetid://85798896931465",
run = "rbxassetid://88972469424227",
jump = "rbxassetid://95665537150740",
fall = "rbxassetid://84215536747783",
climb = "rbxassetid://79108282829680",
swim = "rbxassetid://79948476132419",
swimidle = "rbxassetid://79948476132419",
},
["Modern R6 Pack"] = {
idle1 = "rbxassetid://104406060298008",
idle2 = "rbxassetid://104406060298008",
walk = "rbxassetid://124988819613327",
run = "rbxassetid://99901926147031",
jump = "rbxassetid://116343198036897",
fall = "rbxassetid://129580654694779",
climb = "rbxassetid://110907985002120",
swim = "rbxassetid://99928806802401",
swimidle = "rbxassetid://99928806802401",
},
["Advanced R6 Pack"] = {
idle1 = "rbxassetid://77830269690286",
idle2 = "rbxassetid://77830269690286",
walk = "rbxassetid://111575206467256",
run = "rbxassetid://100171713967372",
jump = "rbxassetid://80552820935195",
fall = "rbxassetid://137219919980602",
climb = "rbxassetid://122523661081372",
swim = "rbxassetid://109642087798136",
swimidle = "rbxassetid://109642087798136",
},
["No Animations Pack"] = {
idle1 = "rbxassetid://125181193511446",
idle2 = "rbxassetid://125181193511446",
walk = "rbxassetid://98277462212808",
run = "rbxassetid://114909951212740",
jump = "rbxassetid://84385111200080",
fall = "rbxassetid://123565201644193",
climb = "rbxassetid://128704251886648",
swim = "rbxassetid://104642998429173",
swimidle = "rbxassetid://104642998429173",
},
}
local allAnimOptions = {
"Default", "Vampire", "Hero", "Zombie Classic", "Mage", "Ghost",
"Elder", "Levitation", "Astronaut", "Ninja", "Werewolf", "Cartoon",
"Pirate", "Sneaky", "Toy", "Knight", "Confident", "Popstar",
"Princess", "Cowboy", "Patrol", "Zombie FE", "Catwalk Glam", "Amazon Unboxed",
"Glow Motion", "Bubbly", "Adidas Comm", "KATSEYE", "Wicked Popular",
"Dizzy", "WDTL", "Billie Eilish", "Cute Bouncy", "Cute",
"Jolly", "Cute Kawaii", "Doll 3.0", "Victoria Model",
"Bike/Bicyclist", "Animal", "It-Girl Essential Model",
"Oldschool", "Spider", "Joy", "Flying Aura", "FHA V2", "Silent Nurse", "Supermodel", "Enchanted Fairy", "Furry", "Vlada Model", "R6 Converter", "R6 Gear Hold",
"Slow Meteorite", "Modern R6 Pack", "Advanced R6 Pack", "No Animations Pack"
}
local runAnimOptions = {
"Default", "OG Rthro Run", "Vampire", "Hero", "Zombie Classic", "Mage", "Ghost",
"Elder", "Levitation", "Astronaut", "Ninja", "Werewolf", "Cartoon",
"Pirate", "Sneaky", "Toy", "Knight", "Confident", "Popstar",
"Princess", "Cowboy", "Patrol", "Zombie FE", "Catwalk Glam", "Amazon Unboxed",
"Glow Motion", "Bubbly", "Adidas Comm", "KATSEYE", "Wicked Popular",
"Dizzy", "WDTL", "Billie Eilish", "Cute Bouncy", "Cute",
"Jolly", "Cute Kawaii", "Doll 3.0", "Victoria Model",
"Bike/Bicyclist", "Animal", "It-Girl Essential Model",
"Oldschool", "Spider", "Joy", "Flying Aura", "FHA V2", "Silent Nurse", "Supermodel", "Enchanted Fairy", "Furry", "Vlada Model", "R6 Converter", "R6 Gear Hold",
"Slow Meteorite", "Modern R6 Pack", "Advanced R6 Pack", "No Animations Pack"
}
local swimAnimOptions = {"Default", "R6 Gear Hold", "Slow Meteorite", "Modern R6 Pack", "Advanced R6 Pack", "No Animations Pack"}
local presetKeys = {
all = "feAnimPresetAll", idle = "feAnimPresetIdle", idle2 = "feAnimPresetIdle2", walk = "feAnimPresetWalk",
run = "feAnimPresetRun", jump = "feAnimPresetJump", climb = "feAnimPresetClimb", fall = "feAnimPresetFall",
swim = "feAnimPresetSwim",
}
local customSlots = {
{key = "idle", label = "Idle 1", config = "feAnimCustomIdle"},
{key = "idle2", label = "Idle 2", config = "feAnimCustomIdle2"},
{key = "walk", label = "Walk", config = "feAnimCustomWalk"},
{key = "run", label = "Run", config = "feAnimCustomRun"},
{key = "jump", label = "Jump", config = "feAnimCustomJump"},
{key = "climb", label = "Climb", config = "feAnimCustomClimb"},
{key = "fall", label = "Fall", config = "feAnimCustomFall"},
{key = "swim", label = "Swim", config = "feAnimCustomSwim"},
}
local function cleanAnimationId(value)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local text = tostring(value or ""):match("^%s*(.-)%s*$")
if text == "" then return "" end
local id = text:match("^(%d+)$") or text:match("^rbxassetid://(%d+)$")
or text:match("^https?://[^/]*roblox%.com/.*[?&]id=(%d+)")
or text:match("^https?://[^/]*roblox%.com/catalog/(%d+)")
or text:match("^https?://[^/]*roblox%.com/library/(%d+)")
return id and id:gsub("^0+", "") or nil
end
local catalogAnimationIds = {}
for _, name in ipairs({"Slow Meteorite", "Modern R6 Pack", "Advanced R6 Pack", "No Animations Pack"}) do
for _, value in pairs(animPresets[name] or {}) do
local id = cleanAnimationId(value)
if id then catalogAnimationIds[id] = true end
end
end
local animState, customAnims = {}, {}
if ConfigData.feAnimPresetIdle == nil and ConfigData.feAnimPresetIdle1 ~= nil then
ConfigData.feAnimPresetIdle = ConfigData.feAnimPresetIdle1
end
ConfigData.feAnimPresetIdle1 = nil
local legacyEnabled = C("feAnimEnabled", false) == true
local hadCustom, hadPreset = false, false
for animType, key in pairs(presetKeys) do
local selected = C(key, "Default")
if selected == "Custom" then hadCustom = true; selected = "Default" end
if type(selected) ~= "string" or (selected ~= "Default" and not animPresets[selected])
or (selected == "OG Rthro Run" and animType ~= "run") then selected = "Default" end
if selected ~= "Default" then hadPreset = true end
animState[animType] = selected
ConfigData[key] = selected
end
if ConfigData.feAnimCustomIdle == nil then
ConfigData.feAnimCustomIdle = cleanAnimationId(ConfigData.feAnimCustomIdle1) or ""
end
ConfigData.feAnimCustomIdle1 = nil
for _, slot in ipairs(customSlots) do
customAnims[slot.key] = cleanAnimationId(C(slot.config, "")) or ""
ConfigData[slot.config] = customAnims[slot.key]
end
local presetsEnabled = C("feAnimPresetsEnabled", legacyEnabled and (hadPreset or not hadCustom)) == true
local customEnabled = C("feAnimCustomEnabled", legacyEnabled and hadCustom) == true
ConfigData.feAnimEnabled = presetsEnabled or customEnabled
local avatarOverride = nil
local function enabled() LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS))); return presetsEnabled or customEnabled or avatarOverride ~= nil end
local assetRedirects = {
["103766334307435"] = "92453281924797",
["122068681350601"] = "114884344098450",
["101475660523078"] = "131634789076585",
["90924872939548"] = "137659653949709",
["126408720389134"] = "75834860496519",
["103902117192422"] = "125215321499925",
["103415879046292"] = "113534064176043",
}
local assetCache = env.VisualsV2FEAnimationAssets
if type(assetCache) ~= "table" then assetCache = {}; env.VisualsV2FEAnimationAssets = assetCache end
local ANIMATION_CACHE_FILE = "VisualsV2_AnimationCache.json"
pcall(function()
if type(exists) == "function" and exists(ANIMATION_CACHE_FILE) and type(read) == "function" then
local saved = HttpService:JSONDecode(read(ANIMATION_CACHE_FILE))
if type(saved) == "table" then
for key, value in pairs(saved) do
if type(key) == "string" and type(value) == "string" and assetCache[key] == nil then assetCache[key] = value end
end
end
end
end)
local animationCacheQueued = false
local function saveAnimationCache()
if animationCacheQueued or type(write) ~= "function" then return end
animationCacheQueued = true
task.delay(1, function()
animationCacheQueued = false
local copy = {}
for key, value in pairs(assetCache) do
if type(key) == "string" and type(value) == "string" then copy[key] = value end
end
pcall(function() write(ANIMATION_CACHE_FILE, HttpService:JSONEncode(copy)) end)
end)
end
local aliases = {
idle = "idle", idle1 = "idle", idle2 = "idle", animation1 = "idle", animation2 = "idle",
walk = "walk", walkanim = "walk", run = "run", runanim = "run", jump = "jump", jumpanim = "jump",
climb = "climb", climbanim = "climb", fall = "fall", fallanim = "fall",
swim = "swim", swimanim = "swim", swimidle = "swimidle", swimidleanim = "swimidle",
}
local emoteGroups = {wave = true, point = true, dance = true, dance2 = true, dance3 = true, laugh = true, cheer = true,
sit = true, sitting = true, emote = true, emotes = true}
local toolGroups = {toolnone = true, toolslash = true, toollunge = true}
local toolAnimationIds = {
["507768375"] = true, ["522635514"] = true, ["522638767"] = true,
["182393478"] = true, ["129967390"] = true, ["129967478"] = true,
}
local defaultEmoteIds = {
["14464306525"] = true,
["14464313439"] = true,
["14464317963"] = true,
["14464323623"] = true,
["14464329833"] = true,
["14464334046"] = true,
["14464337819"] = true,
["14464342477"] = true,
["14464349970"] = true,
["14465000536"] = true,
["14465017457"] = true,
["14465059355"] = true,
["14474226936"] = true,
["507770239"] = true,
["507770453"] = true,
["507770677"] = true,
["507770818"] = true,
["507771019"] = true,
["507771955"] = true,
["507772104"] = true,
["507776043"] = true,
["507776720"] = true,
["507776879"] = true,
["507777268"] = true,
["507777451"] = true,
["507777623"] = true,
}
local defaultMoves = {
["507766666"] = "idle", ["507766951"] = "idle", ["507766388"] = "idle",
["507777826"] = "walk", ["507767714"] = "run", ["507765000"] = "jump",
["507765644"] = "climb", ["507767968"] = "fall",
["507784897"] = "swim", ["507785072"] = "swimidle",
["180435571"] = "idle", ["180435792"] = "idle", ["180426354"] = "walk",
["125750702"] = "jump", ["180436148"] = "fall", ["180436334"] = "climb",
["913402848"] = "walk", ["913376220"] = "run",
["913384386"] = "swim", ["913389285"] = "swimidle",
}
local session, generation = nil, 0
local updateMotion, refreshRuntime
local function valid(s)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
return alive and runtimeAlive and enabled() and session == s and s.token == generation
and LocalPlayer.Character == s.character and s.character.Parent ~= nil
end
local function stopTrack(track, fade)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if track then pcall(function() track:Stop(fade or 0.12) end) end
end
local function restoreWeights(s)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
for track, weight in pairs(s.weights or {}) do
s.weights[track] = nil
pcall(function() track:AdjustWeight(weight, 0.12) end)
end
end
local function dropRecord(s, kind)
local record = s.tracks[kind]
if not record then return end
s.tracks[kind] = nil; record.disposed = true
if record.loopConnection then record.loopConnection:Disconnect(); record.loopConnection = nil end
if s.current == record then s.current = nil; restoreWeights(s) end
if record.track then
s.ownTracks[record.track] = nil
stopTrack(record.track)
pcall(function() record.track:Destroy() end)
end
if record.animation then pcall(function() record.animation:Destroy() end) end
end
local function closeSession()
generation = generation + 1
local old = session; session = nil
if not old then return end
for _, connection in ipairs(old.connections) do pcall(function() connection:Disconnect() end) end
restoreWeights(old)
for kind in pairs(old.tracks) do dropRecord(old, kind) end
if old.references then pcall(function() old.references:Destroy() end) end
end
local function animationGroup(animation, character)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local node = animation
if not node or not node:IsDescendantOf(character) then return nil end
while node.Parent and node.Parent ~= character do
if node.Parent:IsA("LuaSourceContainer") then
local name = node.Parent.Name:lower()
if name == "animate" or name == "r15anim" or name == "r6anim" then return node.Name:lower() end
return nil
end
node = node.Parent
end
end
local function movementGroup(group)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if group == "animation1" or group == "animation2" then return nil end
return group and aliases[group]
end
local function nativeKind(s, track)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if s.ownTracks[track] then return nil end
local animation = track.Animation
if not animation or animation:FindFirstAncestorOfClass("Tool") then return nil end
local group = animationGroup(animation, s.character)
if group and (emoteGroups[group] or group:find("emote", 1, true)) then return nil end
local id = cleanAnimationId(animation.AnimationId)
if id and (s.emoteIds[id] or defaultEmoteIds[id]) then return nil end
local kind = movementGroup(group)
if kind then return kind end
if id and s.nativeIds[id] then return s.nativeIds[id] end
if id and defaultMoves[id] then return defaultMoves[id] end
-- Animate can retain its Animation outside the character after loading it.
-- Only canonical Core locomotion names are eligible for this fallback.
if track.Priority == Enum.AnimationPriority.Core and not (id and toolAnimationIds[id]) then
local animationName = tostring(animation.Name or ""):lower()
local trackName = tostring(track.Name or ""):lower()
local named = movementGroup(animationName) or movementGroup(trackName)
if not named and (animationName == "animation1" or animationName == "animation2"
or trackName == "animation1" or trackName == "animation2") then named = "idle" end
if named then return named end
end
return nil
end
local function isToolTrack(s, track)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local animation = track.Animation
if not animation then return false end
if animation:FindFirstAncestorOfClass("Tool") then return true end
local group = animationGroup(animation, s.character)
if group and toolGroups[group] then return true end
local id = cleanAnimationId(animation.AnimationId)
if id and toolAnimationIds[id] then return true end
local name = (tostring(track.Name or "") .. " " .. tostring(animation.Name or "")):lower():gsub("[%s_]", "")
return name:find("toolnone", 1, true) ~= nil or name:find("toolhold", 1, true) ~= nil
or name:find("customhold", 1, true) ~= nil or name:find("scopehold", 1, true) ~= nil
or name:find("gunshoot", 1, true) ~= nil or name:find("reload", 1, true) ~= nil
end
local function isEmote(s, track)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if s.ownTracks[track] or nativeKind(s, track) or isToolTrack(s, track) then return false end
local animation = track.Animation
if not animation then return false end
local group = animationGroup(animation, s.character)
if group and (emoteGroups[group] or group:find("emote", 1, true)) then return true end
local id = cleanAnimationId(animation.AnimationId)
if id and (s.emoteIds[id] or defaultEmoteIds[id]) then return true end
local name = tostring(animation.Name or ""):lower()
local trackName = tostring(track.Name or ""):lower()
return emoteGroups[name] == true or emoteGroups[trackName] == true
end
local function collectNativeIds(s)
for _, child in ipairs(s.character:GetChildren()) do
if child ~= s.references and child:IsA("LuaSourceContainer") then
for _, animation in ipairs(child:GetDescendants()) do
if animation:IsA("Animation") then
local group = animationGroup(animation, s.character)
local kind = movementGroup(group)
local id = cleanAnimationId(animation.AnimationId)
if id and kind then s.nativeIds[id] = kind end
end
end
end
end
end
local function playbackTargets()
local result = {}
-- The avatar supplies the baseline. Explicit FE choices override only the
-- selected movement kinds, so toggling either feature does not mask the other.
for kind, id in pairs(avatarOverride or {}) do result[kind] = assetRedirects[id] or id end
local function selectedPreset(kind)
if not presetsEnabled then return nil end
local selected = animState[kind]
if kind == "idle2" and selected == "Default" then selected = animState.idle end
if selected == "Default" then selected = animState.all end
return animPresets[selected]
end
local idleSelection, swimSelection = false, false
for _, slot in ipairs(customSlots) do
local kind, id = slot.key, nil
local preset = selectedPreset(kind)
if preset then id = cleanAnimationId(preset[kind == "idle" and "idle1" or kind]) end
if customEnabled and customAnims[kind] ~= "" then id = customAnims[kind] end
if id and id ~= "" then
result[kind] = assetRedirects[id] or id
if kind == "idle" then idleSelection = true end
if kind == "swim" then swimSelection = true end
elseif kind == "idle2" and idleSelection then
-- An explicitly selected one-idle FE set must not alternate into the avatar's
-- second idle. Other unselected movement kinds keep their avatar baseline.
result.idle2 = nil
end
end
if customEnabled and customAnims.idle ~= "" and customAnims.idle2 == ""
and (not presetsEnabled or animState.idle2 == "Default") then result.idle2 = nil end
if result.idle2 == result.idle and not catalogAnimationIds[result.idle] then result.idle2 = nil end
local swimPreset = selectedPreset("swim")
if customEnabled and customAnims.swim ~= "" then
result.swimidle = customAnims.swim == "103415879046292" and "140107830121953" or result.swim
elseif swimPreset then
local id = cleanAnimationId(swimPreset.swimidle)
if id and id ~= "" then result.swimidle = assetRedirects[id] or id
elseif swimSelection and result.swim then result.swimidle = result.swim end
end
return result
end
local catalogLookups = {}
local catalogKinds = {"idle", "idle2", "walk", "run", "jump", "fall", "climb", "swim", "swimidle"}
local function resolveCatalog(id, kind)
local key = id .. ":" .. kind
if assetCache[key] then return assetCache[key] end
local waitedSince = os.clock()
while catalogLookups[id] and os.clock() - waitedSince < 15 do task.wait(0.05) end
if assetCache[key] then return assetCache[key] end
catalogLookups[id] = true
local ok, objects = pcall(function() return game:GetObjects("rbxassetid://" .. id) end)
catalogLookups[id] = nil
if not ok or type(objects) ~= "table" then return id end
local best = {}
local function inspect(animation)
if not animation:IsA("Animation") then return end
local candidate = cleanAnimationId(animation.AnimationId)
if not candidate or candidate == "" then return end
local name = animation.Name:lower()
local parent = animation.Parent and animation.Parent.Name:lower() or ""
for _, wanted in ipairs(catalogKinds) do
local group = wanted == "idle2" and "idle" or wanted
local match = aliases[name] == group and 2 or aliases[parent] == group and 1 or 0
if name == wanted or (wanted == "idle" and (name == "animation1" or name == "idle1"))
or (wanted == "idle2" and name == "animation2") then match = 3 end
if not best[wanted] or match > best[wanted].score then best[wanted] = {id = candidate, score = match} end
end
end
for _, object in ipairs(objects) do
inspect(object)
for _, child in ipairs(object:GetDescendants()) do inspect(child) end
pcall(function() object:Destroy() end)
end
local resolved = best[kind] and best[kind].id
if alive and runtimeAlive then
if resolved then assetCache[key] = resolved end
for wanted, found in pairs(best) do
if wanted ~= kind and found.score > 0 then assetCache[id .. ":" .. wanted] = found.id end
end
if resolved then saveAnimationCache() end
end
return resolved or id
end
local function prefetchCatalog(s)
local wanted = {}
for _, kind in ipairs(catalogKinds) do
local id = s.targets and s.targets[kind]
if id and catalogAnimationIds[id] and not assetCache[id .. ":" .. kind] then wanted[#wanted + 1] = kind end
end
if #wanted == 0 then return end
-- (each different animation ID is looked up at the same time; states that share an ID take
-- turns on the one lookup, so it's only downloaded once)
local byId, order = {}, {}
for _, kind in ipairs(wanted) do
local id = s.targets[kind]
if not byId[id] then byId[id] = {}; order[#order + 1] = id end
table.insert(byId[id], kind)
end
for _, id in ipairs(order) do
task.spawn(function()
for _, kind in ipairs(byId[id]) do
if not valid(s) then return end
if s.targets[kind] == id and catalogAnimationIds[id] then resolveCatalog(id, kind) end
end
end)
end
end
local function reportLoadError(s, record)
if not valid(s) or record.disposed or record.notified or s.told[record.rawId] then return end
record.notified = true
s.told[record.rawId] = true
shared.Notify("FE Animations: couldn't load the " .. record.kind .. " animation (" .. record.rawId .. "). Check the ID and that the animation can be used.", 1)
end
local function loadRecord(s, kind)
local id = s.targets[kind]
if not id then return nil end
local old = s.tracks[kind]
if old and old.rawId == id then return old end
dropRecord(s, kind)
local record = {rawId = id, kind = kind, pending = true}
s.tracks[kind] = record
local function stillCurrent() return valid(s) and not record.disposed and s.tracks[kind] == record end
local function install(playbackId)
if not stillCurrent() then return false end
if record.loopConnection then record.loopConnection:Disconnect(); record.loopConnection = nil end
if record.track then
s.ownTracks[record.track] = nil; stopTrack(record.track)
pcall(function() record.track:Destroy() end)
record.track = nil
end
if record.animation then record.animation:Destroy() end
local animation = Instance.new("Animation")
animation.Name = "VisualsV2_FE_" .. kind
animation.AnimationId = "rbxassetid://" .. playbackId
animation.Parent = s.references
record.animation = animation
local ok, track = pcall(function() return s.animator:LoadAnimation(animation) end)
if not stillCurrent() then
if ok and track then pcall(function() track:Destroy() end) end
animation:Destroy(); return false
end
if not ok or not track then return false end
record.track = track; s.ownTracks[track] = true
track.Priority = Enum.AnimationPriority.Movement
track.Looped = kind ~= "jump"
if kind == "idle" or kind == "idle2" then
record.loopConnection = track.DidLoop:Connect(function()
if stillCurrent() and s.current == record and s.targets.idle and s.targets.idle2 then
s.idleVariant = kind == "idle" and "idle2" or "idle"
updateMotion(s)
end
end)
end
record.pending = false
if s.current == record then s.current = nil end
updateMotion(s)
return true
end
task.spawn(function()
local firstId = assetCache[id .. ":" .. kind]
if not firstId then
firstId = catalogAnimationIds[id] and stillCurrent() and resolveCatalog(id, kind) or id
end
local loaded = install(firstId)
if not loaded and stillCurrent() then
local resolved = resolveCatalog(id, kind)
loaded = resolved ~= firstId and install(resolved)
end
if not loaded then
record.pending = false; record.failed = true
reportLoadError(s, record); return
end
task.wait(2)
if not stillCurrent() or not record.track or record.track.Length > 0 then return end
local resolved = resolveCatalog(id, kind)
if not stillCurrent() then return end
if resolved ~= firstId then install(resolved) end
task.wait(6)
if stillCurrent() and record.track and record.track.Length == 0 then
record.failed = true
stopTrack(record.track)
if s.current == record then s.current = nil; restoreWeights(s) end
reportLoadError(s, record)
end
end)
return record
end
local function desiredMotion(s)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local humanoid = s.humanoid
local state = humanoid:GetState()
if humanoid.Health <= 0 or humanoid.Sit or state == Enum.HumanoidStateType.Dead
or state == Enum.HumanoidStateType.Seated or state == Enum.HumanoidStateType.PlatformStanding
or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll then return nil, 1 end
if state == Enum.HumanoidStateType.Swimming then
if (s.swimSpeed or 0) < 0.5 and humanoid.MoveDirection.Magnitude < 0.01 and s.targets.swimidle then
return "swimidle", 1
end
return "swim", math.clamp((s.swimSpeed or 0) / 10, 0.1, 3)
end
if state == Enum.HumanoidStateType.Climbing then return "climb", math.clamp((s.climbSpeed or 0) / 12, -3, 3) end
if state == Enum.HumanoidStateType.Jumping then return "jump", 1 end
if state == Enum.HumanoidStateType.Freefall then
if s.targets.jump and os.clock() - s.jumpedAt < 0.3 then return "jump", 1 end
return "fall", 1
end
local speed = s.runSpeed or 0
local moving = humanoid.MoveDirection.Magnitude > 0.01 or speed > 0.5
if not moving then
if s.targets.idle2 and (s.idleVariant == "idle2" or not s.targets.idle) then return "idle2", 1 end
return "idle", 1
end
if speed <= 0.5 then speed = humanoid.MoveDirection.Magnitude * humanoid.WalkSpeed end
local kind = speed >= math.max(humanoid.WalkSpeed * 0.75, 1) and "run" or "walk"
if not s.targets[kind] then kind = kind == "run" and "walk" or "run" end
return kind, math.clamp(speed / (kind == "walk" and 8 or 16), 0.1, 3)
end
local function sameMovement(native, active)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if active == "idle2" then return native == "idle" end
if active == "swim" or active == "swimidle" then return native == "swim" or native == "swimidle" end
if active == "walk" or active == "run" then return native == "walk" or native == "run" end
if active == "fall" then return native == "fall" or native == "jump" end
return native == active
end
-- Another animation layered over the body that isn't locomotion (a tool's hold or draw, a game
-- emote): one with keyframes, not the empty mood track.
local function overlayTrack(s, track)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local animation = track.Animation
if not animation or (tonumber(track.Length) or 0) <= 0 then return false end
local group = animationGroup(animation, s.character)
return group ~= "mood"
end
local function motionStep(s)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not valid(s) or not s.ready then return end
local playing = s.animator:GetPlayingAnimationTracks()
local kind, speed = desiredMotion(s)
-- Replacements play the way Animate plays an owned animation pack while anything else is on the
-- body: at Core priority, so a tool's hold/draw and emotes layer over them (the arm comes up),
-- and not at all while Animate plays an emote (it stops its own locomotion for one).
local layered = s.character:FindFirstChildOfClass("Tool") ~= nil
local foreign, nativeMoving = false, false
-- (in the air, a fall or jump the game plays from an animation FE Animations doesn't recognise is
-- the one being replaced, not something layered over it)
local airborne, airTracks = kind == "fall" or kind == "jump", nil
for _, track in ipairs(playing) do
if track.IsPlaying and not s.ownTracks[track] then
local weight = math.max(tonumber(track.WeightTarget) or 0, tonumber(track.WeightCurrent) or 0)
local priority = track.Priority
if nativeKind(s, track) then nativeMoving = true
elseif airborne and (priority == Enum.AnimationPriority.Core or priority == Enum.AnimationPriority.Movement
or priority == Enum.AnimationPriority.Idle) and not isToolTrack(s, track) and not isEmote(s, track) then
nativeMoving = true; airTracks = airTracks or {}; airTracks[track] = true
elseif weight > 0.001 then
if isEmote(s, track) then kind = nil; break end
if isToolTrack(s, track) then layered = true
elseif overlayTrack(s, track) then layered = true; foreign = true end
end
end
end
if nativeMoving then s.sawNative = true
elseif kind and foreign and s.sawNative then kind = nil end
if kind ~= "idle" and kind ~= "idle2" then s.idleVariant = nil end
if not kind or not s.targets[kind] then
if s.current then stopTrack(s.current.track); s.current = nil end
restoreWeights(s); return
end
if s.current and s.current.kind ~= kind then
stopTrack(s.current.track); s.current = nil; restoreWeights(s)
end
local record = loadRecord(s, kind)
if not record or not record.track or record.pending or record.failed then return end
if s.current ~= record then
if s.current then stopTrack(s.current.track) end
restoreWeights(s)
s.current = record
record.lastJump = nil
end
local track = record.track
local priority = layered and Enum.AnimationPriority.Core or Enum.AnimationPriority.Movement
if track.Priority ~= priority then pcall(function() track.Priority = priority end) end
if not track.IsPlaying and (kind ~= "jump" or record.lastJump ~= s.jumpCount) then
local ok = pcall(function() track:Play(0.12, 1, speed) end)
if not ok then
record.failed = true; stopTrack(track)
s.current = nil; restoreWeights(s); reportLoadError(s, record); return
end
if kind == "jump" then record.lastJump = s.jumpCount end
else
track:AdjustSpeed(speed)
end
if not track.IsPlaying or track.Length <= 0 then restoreWeights(s); return end
local suppressed = {}
for _, native in ipairs(playing) do
local nativeMotion = nativeKind(s, native)
if native.IsPlaying and ((nativeMotion and sameMovement(nativeMotion, kind)) or (airTracks and airTracks[native])) then
local weight = native.WeightTarget
if s.weights[native] == nil then s.weights[native] = weight end
if weight > 0 then s.weights[native] = weight end
native:AdjustWeight(0, 0.12)
suppressed[native] = true
end
end
for native, weight in pairs(s.weights) do
if not suppressed[native] then
s.weights[native] = nil
pcall(function() native:AdjustWeight(weight, 0.12) end)
end
end
end
updateMotion = function(s)
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not valid(s) or s.updating then return end
s.updating = true
local ok = pcall(motionStep, s)
s.updating = false
if not ok then
if s.current then stopTrack(s.current.track); s.current = nil end
restoreWeights(s)
end
end
local function refreshTargets(s)
if not valid(s) or not s.ready then return end
local targets = playbackTargets()
local oldTargets = s.targets or {}
if targets.idle ~= oldTargets.idle or targets.idle2 ~= oldTargets.idle2 then s.idleVariant = nil end
for kind, record in pairs(s.tracks) do
if targets[kind] ~= record.rawId then dropRecord(s, kind) end
end
s.targets = targets
prefetchCatalog(s)
updateMotion(s)
end
local function bindCharacter(character)
closeSession()
if not alive or not runtimeAlive or not enabled() or LocalPlayer.Character ~= character then return end
local s = {character = character, token = generation, binding = true, connections = {}, tracks = {}, weights = {},
ownTracks = setmetatable({}, {__mode = "k"}), nativeIds = {}, emoteIds = {}, jumpCount = 0, jumpedAt = -math.huge,
startedAt = os.clock(), retries = {}, told = {}}
session = s
table.insert(s.connections, character.DescendantAdded:Connect(function(child)
if not valid(s) then return end
if (child:IsA("Animator") or child:IsA("Humanoid")) and not s.binding then
if not s.ready or (child:IsA("Animator") and child ~= s.animator) then
task.defer(function() if valid(s) then bindCharacter(character) end end)
end
end
end))
task.spawn(function()
local waitedSince = os.clock()
while character.Parent == nil and session == s and s.token == generation
and LocalPlayer.Character == character and os.clock() - waitedSince < 10 do
task.wait()
end
local humanoid = character:WaitForChild("Humanoid", 10)
if not humanoid or not valid(s) then s.binding = false; return end
local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator", 10)
if not animator or not valid(s) then s.binding = false; return end
s.humanoid, s.animator = humanoid, animator
s.references = Instance.new("LocalScript")
s.references.Name = "VisualsV2_FEAnimationReferences"; s.references.Disabled = true
s.references.Parent = character
collectNativeIds(s)
s.ready, s.binding = true, false
if humanoid:GetState() == Enum.HumanoidStateType.Jumping then s.jumpedAt = os.clock(); s.jumpCount = 1 end
local function connect(event, callback) table.insert(s.connections, event:Connect(callback)) end
connect(humanoid.Running, function(speed) s.runSpeed = speed; updateMotion(s) end)
connect(humanoid.Climbing, function(speed) s.climbSpeed = speed; updateMotion(s) end)
connect(humanoid.Swimming, function(speed) s.swimSpeed = speed; updateMotion(s) end)
connect(humanoid.StateChanged, function(_, state)
if state == Enum.HumanoidStateType.Jumping then s.jumpedAt = os.clock(); s.jumpCount = s.jumpCount + 1 end
updateMotion(s)
end)
connect(humanoid.Died, function() if session == s then closeSession() end end)
connect(animator.AnimationPlayed, function(track)
if s.ownTracks[track] then return end
if track.Priority == Enum.AnimationPriority.Core and not nativeKind(s, track) then collectNativeIds(s) end
updateMotion(s)
task.defer(function() if valid(s) then updateMotion(s) end end)
end)
connect(character.DescendantAdded, function(child)
if child:IsA("Animation") and not child:IsDescendantOf(s.references) then
local group = animationGroup(child, character)
local id = cleanAnimationId(child.AnimationId)
local kind = movementGroup(group)
if kind and id then s.nativeIds[id] = kind end
end
end)
local elapsed = 0
connect(RunService.Heartbeat, function(dt)
elapsed = elapsed + dt
if elapsed < 0.1 then return end
elapsed = 0
updateMotion(s)
end)
refreshTargets(s)
for kind in pairs(s.targets or {}) do
if not valid(s) then break end
pcall(loadRecord, s, kind)
end
task.spawn(function()
local ok, description = pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not description or not valid(s) then return end
local success, emotes = pcall(function() return description:GetEmotes() end)
if success and type(emotes) == "table" then
for _, ids in pairs(emotes) do
if type(ids) == "table" then
for _, id in ipairs(ids) do local value = cleanAnimationId(id); if value then s.emoteIds[value] = true end end
end
end
end
end)
end)
end
refreshRuntime = function()
if not alive or not runtimeAlive then return end
if not enabled() then closeSession(); return end
local character = LocalPlayer.Character
if not character then return end
if session and session.character == character and (session.ready or session.binding) then
refreshTargets(session)
else
bindCharacter(character)
end
end
RootMaid:GiveTask(LocalPlayer.CharacterAdded:Connect(function(character)
if alive and runtimeAlive and enabled() then bindCharacter(character) end
end))
local function checkSession(s)
if not valid(s) or not s.ready then return end
local now = os.clock()
if not s.references or s.references.Parent ~= s.character then
if now - s.startedAt > 5 then bindCharacter(s.character) end
return
end
local again = {}
for kind, record in pairs(s.tracks) do
if not record.pending then
if record.failed and not record.failedAt then record.failedAt = now end
if record.failed then
if (s.retries[kind] or 0) < 3 and now - record.failedAt > 10 then
s.retries[kind] = (s.retries[kind] or 0) + 1
again[#again + 1] = kind
end
elseif record.animation and record.animation.Parent ~= s.references then
again[#again + 1] = kind
end
end
end
for _, kind in ipairs(again) do
dropRecord(s, kind)
loadRecord(s, kind)
end
end
local lastCheck = 0
local watchdog = task.spawn(function()
while alive and runtimeAlive do
task.wait(0.2)
if enabled() then
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if character and character.Parent and (not humanoid or humanoid.Health > 0)
and (not session or session.character ~= character
or (not session.ready and not session.binding)) then
pcall(bindCharacter, character)
elseif session and os.clock() - lastCheck >= 1 then
lastCheck = os.clock()
pcall(checkSession, session)
end
end
end
end)
RootMaid:GiveTask(function() pcall(task.cancel, watchdog) end)
RootMaid:GiveTask(LocalPlayer.CharacterRemoving:Connect(function(character)
if session and session.character == character then closeSession() end
end))
env.VisualsV2Runtime.SetAnimationOverride = function(map)
if map ~= nil and type(map) ~= "table" then return end
local cleaned = nil
for kind, id in pairs(map or {}) do
local value = cleanAnimationId(id)
if value and value ~= "" then cleaned = cleaned or {}; cleaned[kind] = value end
end
avatarOverride = cleaned
refreshRuntime()
end
env.VisualsV2Runtime.HasAnimationOverride = function() return avatarOverride ~= nil end
env.VisualsV2Runtime.ResolveAnimationAsset = function(id, kind)
local value = cleanAnimationId(id)
if not value or value == "" or value == "0" or not table.find(catalogKinds, kind) then return nil end
return resolveCatalog(value, kind)
end
RootMaid:GiveTask(closeSession)
local presetToggle = addToggle(feAnimSection, "Enable Preset Animations", presetsEnabled, function(value)
if not alive or not runtimeAlive then return end
presetsEnabled = value
SetCfg("feAnimPresetsEnabled", value); SetCfg("feAnimEnabled", enabled())
refreshRuntime()
end)
local presetControllers = {}
local function addAnimationDropdown(label, kind, options)
presetControllers[kind] = addDropdown(feAnimSection, label, options, animState[kind], function(selected)
if not alive or not runtimeAlive or type(selected) ~= "string" then return end
if selected ~= "Default" and not animPresets[selected] then return end
if selected == "OG Rthro Run" and kind ~= "run" then return end
animState[kind] = selected; SetCfg(presetKeys[kind], selected)
refreshRuntime()
end)
end
addAnimationDropdown("All Animations", "all", allAnimOptions)
for _, slot in ipairs(customSlots) do
local options = slot.key == "run" and runAnimOptions or slot.key == "swim" and swimAnimOptions or allAnimOptions
addAnimationDropdown(slot.label .. " Animation", slot.key, options)
end
local customToggle = addToggle(feAnimSection, "Enable Custom Animations", customEnabled, function(value)
if not alive or not runtimeAlive then return end
customEnabled = value
SetCfg("feAnimCustomEnabled", value); SetCfg("feAnimEnabled", enabled())
refreshRuntime()
end)
for _, slot in ipairs(customSlots) do
feAnimSection:AddTextBox("Custom " .. slot.label .. " Animation ID", function(value)
if not alive or not runtimeAlive then return end
local id = cleanAnimationId(value)
if id == nil then shared.Notify("FE Animations: enter an animation ID or asset URL (leave it empty to clear it)", 0); return end
customAnims[slot.key] = id; SetCfg(slot.config, id)
refreshRuntime()
end)
end
resetSection = function()
presetToggle:Set(false); customToggle:Set(false)
presetsEnabled, customEnabled = false, false
closeSession()
for kind in pairs(presetKeys) do
animState[kind] = "Default"
local control = presetControllers[kind]
if control and type(control.Select) == "function" then
local ok = pcall(function() control:Select("Default") end)
if not ok then pcall(control.Select, "Default") end
end
end
for _, slot in ipairs(customSlots) do customAnims[slot.key] = "" end
end
if enabled() then task.defer(refreshRuntime) end
end,"Section \"FE Animations\"")
local trailEnabled,createTrail
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local trailSection = mainTab:AddSection("Trail", "Cosmetic")
trailEnabled = C("trailEnabled", false)
local trailIsGradient = C("trailIsGradient", false)
local trailRainbow = C("trailRainbow", false)
local trailColorStatic = C("trailColorStatic",Color3.fromRGB(38,38,38))
local trailGradient1 = C("trailGradient1",Color3.fromRGB(38,38,38))
local trailGradient2 = C("trailGradient2",Color3.fromRGB(38,38,38))
local trailLifetime = math.max(0.2, tonumber(C("trailLifetime", 0.5)) or 0.5)
local trailTransparencyStart = math.clamp(tonumber(C("trailTransparency", 1)) or 1, 1, 4)
local trailObject = nil
local trailConnection = nil
local function removeTrail()
if trailObject then
trailObject:Destroy()
trailObject = nil
end
local char = player.Character
if char then
local hrp = char:FindFirstChild("HumanoidRootPart")
if hrp then
local a0 = hrp:FindFirstChild("LV_TrailAttach0")
local a1 = hrp:FindFirstChild("LV_TrailAttach1")
if a0 then a0:Destroy() end
if a1 then a1:Destroy() end
end
end
end
local function trailAlpha(value)
value = math.clamp(tonumber(value) or 1, 1, 4)
return 0.05 + ((value - 1) / 3) * 0.75
end
local function updateTrailColor()
if not trailObject then return end
if trailIsGradient then
trailObject.Color = ColorSequence.new(trailGradient1, trailGradient2)
elseif trailRainbow then
trailObject.Color = ColorSequence.new(Color3.fromHSV((tick() % 5) / 5, 1, 1))
else
trailObject.Color = ColorSequence.new(trailColorStatic)
end
end
local function updateTrail()
if not trailObject then return end
trailObject.Lifetime = math.max(0.2, tonumber(trailLifetime) or 0.5)
trailObject.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, trailAlpha(trailTransparencyStart)),
NumberSequenceKeypoint.new(1, 1),
})
updateTrailColor()
end
local function refreshTrailConnection()
if trailConnection then trailConnection:Disconnect(); trailConnection = nil end
if trailEnabled and trailRainbow and not trailIsGradient then
trailConnection = RunService.Heartbeat:Connect(updateTrailColor)
end
end
function createTrail()
removeTrail()
local char = player.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local a0 = Instance.new("Attachment")
a0.Name = "LV_TrailAttach0"
a0.Position = Vector3.new(0, 2, 0)
a0.Parent = hrp
local a1 = Instance.new("Attachment")
a1.Name = "LV_TrailAttach1"
a1.Position = Vector3.new(0, -2, 0)
a1.Parent = hrp
local trail = Instance.new("Trail")
trail.Name = "LV_Trail"
trail.Attachment0 = a0
trail.Attachment1 = a1
trail.LightEmission = 0.2
trail.Parent = char
trailObject = trail
updateTrail()
end
local trailEnableToggle = addToggle(trailSection, "Enable Trail", trailEnabled, function(state)
trailEnabled = state
SetCfg("trailEnabled", state)
if state then
createTrail()
else
removeTrail()
end
refreshTrailConnection()
end)
local trailGradientToggle = addToggle(trailSection, "Use Gradient", trailIsGradient, function(state)
trailIsGradient = state
SetCfg("trailIsGradient", state)
updateTrail()
refreshTrailConnection()
end)
local trailRainbowToggle = addToggle(trailSection, "Rainbow", trailRainbow, function(state)
trailRainbow = state
SetCfg("trailRainbow", state)
updateTrail()
refreshTrailConnection()
end)
trailSection:AddColorpicker("Static Color", trailColorStatic, function(color)
trailColorStatic = color
SetCfg("trailColorStatic", color)
updateTrail()
end)
trailSection:AddColorpicker("Gradient Color 1", trailGradient1, function(color)
trailGradient1 = color
SetCfg("trailGradient1", color)
updateTrail()
end)
trailSection:AddColorpicker("Gradient Color 2", trailGradient2, function(color)
trailGradient2 = color
SetCfg("trailGradient2", color)
updateTrail()
end)
trailSection:AddSlider("Trail Lifetime", 0.2, 3, trailLifetime, function(value)
trailLifetime = math.max(0.2, tonumber(value) or 0.5)
SetCfg("trailLifetime", trailLifetime)
updateTrail()
end)
trailSection:AddSlider("Trail Transparency", 1, 4, trailTransparencyStart, function(value)
trailTransparencyStart = math.clamp(math.floor((tonumber(value) or 1) + 0.5), 1, 4)
SetCfg("trailTransparency", trailTransparencyStart)
updateTrail()
end)
env.VisualsV2Runtime.RegisterReset(function()
trailEnableToggle:Set(false)
trailGradientToggle:Set(false)
trailRainbowToggle:Set(false)
trailEnabled = false
trailIsGradient = false
trailRainbow = false
trailLifetime = 0.5
trailTransparencyStart = 1
trailColorStatic = Color3.fromRGB(255,255,255)
trailGradient1 = Color3.fromRGB(255,255,255)
trailGradient2 = Color3.fromRGB(0,0,0)
if trailConnection then trailConnection:Disconnect(); trailConnection = nil end
removeTrail()
end)
end,"Section \"Trail\"")
local ffEnabled,skinTrailEnabled,applyForceField,refreshForceFieldConnection,applySkinTrail,refreshSkinTrailRainbowConnection
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local skinSection = mainTab:AddSection("Skin", "Cosmetic")
ffEnabled = C("ffEnabled", false)
local ffRainbow = C("ffRainbow", false)
local ffColor = C("ffColor",Color3.fromRGB(38,38,38))
skinTrailEnabled = C("skinTrailEnabled", false)
local skinTrailRainbow = C("skinTrailRainbow", false)
local skinTrailColor = C("skinTrailColor",Color3.fromRGB(38,38,38))
local skinTrailLife = math.max(0.2, tonumber(C("skinTrailLife", 0.5)) or 0.5)
local skinTrailTransparency = math.clamp(tonumber(C("skinTrailTransparency", 0.0)) or 0, 0, 3)
local ffConnection = nil
local skinTrailRainbowConnection = nil
local FF_MATERIAL_ATTR = "VisualsV2_OriginalMaterial"
local FF_COLOR_ATTR = "VisualsV2_OriginalColor"
local function rememberForceFieldPart(part)
if not part:IsA("BasePart") then return end
if part:GetAttribute(FF_MATERIAL_ATTR) == nil then
part:SetAttribute(FF_MATERIAL_ATTR, part.Material.Name)
end
if part:GetAttribute(FF_COLOR_ATTR) == nil then
part:SetAttribute(FF_COLOR_ATTR, part.Color)
end
end
local ffParts,ffCharacter,ffDirty={},nil,true
local ffConnections={}
local ffRemembered=setmetatable({}, {__mode="k"})
local function forceFieldParts(char)
if char~=ffCharacter then
for _,connection in ipairs(ffConnections) do connection:Disconnect() end
table.clear(ffConnections)
ffCharacter,ffDirty=char,true
local function changed(object) if object:IsA("BasePart") then ffDirty=true end end
ffConnections[1]=char.DescendantAdded:Connect(changed)
ffConnections[2]=char.DescendantRemoving:Connect(changed)
end
if ffDirty then
ffDirty=false
ffParts={}
for _,part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then ffParts[#ffParts+1]=part end
end
end
return ffParts
end
local function forgetForceFieldParts()
for _,connection in ipairs(ffConnections) do connection:Disconnect() end
table.clear(ffConnections)
ffParts,ffCharacter,ffDirty={},nil,true
end
local function restoreForceFieldPart(part)
if not part:IsA("BasePart") then return end
ffRemembered[part]=nil
local materialName = part:GetAttribute(FF_MATERIAL_ATTR)
local oldColor = part:GetAttribute(FF_COLOR_ATTR)
if materialName then
local ok, material = pcall(function()
return Enum.Material[materialName]
end)
if ok and material then part.Material = material end
end
if typeof(oldColor) == "Color3" then part.Color = oldColor end
part:SetAttribute(FF_MATERIAL_ATTR, nil)
part:SetAttribute(FF_COLOR_ATTR, nil)
end
function applyForceField()
local char = player.Character
if not char then return end
local color = ffRainbow and Color3.fromHSV((os.clock() % 5) / 5, 1, 1) or ffColor
for _, part in ipairs(forceFieldParts(char)) do
if part.Parent then
if not ffRemembered[part] then rememberForceFieldPart(part); ffRemembered[part] = true end
if part.Material ~= Enum.Material.ForceField then part.Material = Enum.Material.ForceField end
part.Color = color
end
end
end
local function removeForceField()
if ffConnection then
ffConnection:Disconnect()
ffConnection = nil
end
forgetForceFieldParts()
local char = player.Character
if not char then return end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then restoreForceFieldPart(part) end
end
end
function refreshForceFieldConnection()
if ffConnection then
ffConnection:Disconnect()
ffConnection = nil
end
if ffEnabled and ffRainbow then
ffConnection = RunService.Heartbeat:Connect(applyForceField)
end
end
local skinTrails = {}
local function clearSkinTrail()
table.clear(skinTrails)
local char = player.Character
if not char then return end
for _, obj in ipairs(char:GetDescendants()) do
if obj.Name == "LV_SkinTrail" or obj.Name == "LV_SkinPointer1" or obj.Name == "LV_SkinPointer2" then
obj:Destroy()
end
end
end
local function currentSkinTrailColor()
return skinTrailRainbow and Color3.fromHSV((os.clock() % 5) / 5, 1, 1) or skinTrailColor
end
local function currentSkinTrailTransparency()
return math.clamp((tonumber(skinTrailTransparency) or 0) / 4, 0, 0.75)
end
function applySkinTrail()
clearSkinTrail()
local char = player.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not char or not hrp then return end
for _, part in ipairs(char:GetChildren()) do
if part:IsA("BasePart") and part ~= hrp then
local a0 = Instance.new("Attachment")
a0.Name = "LV_SkinPointer1"
a0.Parent = part
local a1 = Instance.new("Attachment")
a1.Name = "LV_SkinPointer2"
a1.Parent = hrp
local trail = Instance.new("Trail")
trail.Name = "LV_SkinTrail"
trail.Texture = "rbxassetid://1390780157"
trail.Attachment0 = a0
trail.Attachment1 = a1
trail.Color = ColorSequence.new(currentSkinTrailColor())
trail.Transparency = NumberSequence.new(currentSkinTrailTransparency())
trail.Lifetime = skinTrailLife
trail.Parent = part
skinTrails[#skinTrails + 1] = trail
end
end
end
local function updateSkinTrail()
local char = player.Character
if not char then return end
local color = ColorSequence.new(currentSkinTrailColor())
local transparency = NumberSequence.new(currentSkinTrailTransparency())
for _, obj in ipairs(char:GetDescendants()) do
if obj:IsA("Trail") and obj.Name == "LV_SkinTrail" then
obj.Color = color
obj.Transparency = transparency
obj.Lifetime = skinTrailLife
end
end
end
local function updateSkinTrailColor()
local sequence = ColorSequence.new(currentSkinTrailColor())
for _, trail in ipairs(skinTrails) do
if trail.Parent then trail.Color = sequence end
end
end
function refreshSkinTrailRainbowConnection()
if skinTrailRainbowConnection then
skinTrailRainbowConnection:Disconnect()
skinTrailRainbowConnection = nil
end
if skinTrailEnabled and skinTrailRainbow then
skinTrailRainbowConnection = RunService.Heartbeat:Connect(updateSkinTrailColor)
end
end
local forceFieldToggle = addToggle(skinSection, "Enable ForceField", ffEnabled, function(state)
ffEnabled = state
SetCfg("ffEnabled", state)
if state then
applyForceField()
refreshForceFieldConnection()
else
removeForceField()
end
end)
local rainbowForceFieldToggle = addToggle(skinSection, "Rainbow ForceField", ffRainbow, function(state)
ffRainbow = state
SetCfg("ffRainbow", state)
if ffEnabled then
applyForceField()
refreshForceFieldConnection()
end
end)
skinSection:AddColorpicker("ForceField Color", ffColor, function(color)
ffColor = color
SetCfg("ffColor", color)
if ffEnabled and not ffRainbow then applyForceField() end
end)
local skinTrailToggle = addToggle(skinSection, "Enable Skin Trail", skinTrailEnabled, function(state)
skinTrailEnabled = state
SetCfg("skinTrailEnabled", state)
if state then applySkinTrail() else clearSkinTrail() end
refreshSkinTrailRainbowConnection()
end)
local rainbowSkinTrailToggle = addToggle(skinSection, "Rainbow Skin Trail", skinTrailRainbow, function(state)
skinTrailRainbow = state
SetCfg("skinTrailRainbow", state)
if skinTrailEnabled then updateSkinTrail() end
refreshSkinTrailRainbowConnection()
end)
skinSection:AddColorpicker("Skin Trail Color", skinTrailColor, function(color)
skinTrailColor = color
SetCfg("skinTrailColor", color)
if skinTrailEnabled and not skinTrailRainbow then updateSkinTrail() end
end)
skinSection:AddSlider("Skin Trail Lifetime", 0.2, 3.0, skinTrailLife, function(value)
skinTrailLife = math.max(0.2, tonumber(value) or 0.5)
SetCfg("skinTrailLife", skinTrailLife)
if skinTrailEnabled then updateSkinTrail() end
end)
skinSection:AddSlider("Skin Transparency", 0.0, 3.0, skinTrailTransparency, function(value)
skinTrailTransparency = value
SetCfg("skinTrailTransparency", value)
if skinTrailEnabled then updateSkinTrail() end
end)
env.VisualsV2Runtime.RegisterReset(function()
forceFieldToggle:Set(false)
rainbowForceFieldToggle:Set(false)
skinTrailToggle:Set(false)
rainbowSkinTrailToggle:Set(false)
removeForceField()
clearSkinTrail()
end)
end,"Section \"Skin\"")
local auraEnabled,applyAura
;vv2Section(function()
local auraSection = mainTab:AddSection("Auras", "Cosmetic")
auraEnabled = C("auraEnabled", false)
local auraType = C("auraType", "Godly")
local currentAuraModel = nil
local auraEffects = {}
local AuraModels = {
Godly = "rbxassetid://16699750981",
["Super Sayien"] = "rbxassetid://116109508364297",
["North Star"] = "rbxassetid://83945069652732",
["Blue Lord"] = "rbxassetid://10974316799",
["Pink Aura"] = "rbxassetid://115980859615239",
["Angel Wing"] = "rbxassetid://90022969696073",
["Sweet Heart"] = "rbxassetid://91724768175470",
["Ethereal Aura"] = "rbxassetid://97041568674250",
}
local function clearAura()
for _, obj in ipairs(auraEffects) do
if obj and obj.Parent then obj:Destroy() end
end
auraEffects = {}
end
local function loadAuraModel()
currentAuraModel = nil
local id = AuraModels[auraType]
if not id then return end
local ok, model = pcall(function()
return game:GetObjects(id)[1]
end)
if ok and model then currentAuraModel = model end
end
local function originalNexiumAuraClone(char)
local tempModel = currentAuraModel:Clone()
for _, obj in pairs(tempModel:GetDescendants()) do
if not obj:IsA("BasePart") then
local clone = obj:Clone()
local parentName = obj.Parent and obj.Parent.Name
local target = char:FindFirstChild(parentName) or char:FindFirstChildWhichIsA("BasePart")
if target and not target:FindFirstChild(clone.Name) then
clone.Parent = target
table.insert(auraEffects, clone)
end
end
end
tempModel:Destroy()
end
local AURA_VISUALS={"Attachment","ParticleEmitter","Beam","Trail","PointLight","SpotLight","SurfaceLight","Fire","Smoke","Sparkles"}
local BODY_ALIASES={
Torso={"UpperTorso","LowerTorso"},UpperTorso={"Torso"},LowerTorso={"Torso"},
["Left Arm"]={"LeftUpperArm","LeftLowerArm"},["Right Arm"]={"RightUpperArm","RightLowerArm"},
["Left Leg"]={"LeftUpperLeg","LeftLowerLeg"},["Right Leg"]={"RightUpperLeg","RightLowerLeg"},
LeftUpperArm={"Left Arm"},LeftLowerArm={"Left Arm"},LeftHand={"Left Arm"},
RightUpperArm={"Right Arm"},RightLowerArm={"Right Arm"},RightHand={"Right Arm"},
LeftUpperLeg={"Left Leg"},LeftLowerLeg={"Left Leg"},LeftFoot={"Left Leg"},
RightUpperLeg={"Right Leg"},RightLowerLeg={"Right Leg"},RightFoot={"Right Leg"},
}
local function isAuraVisual(obj)
for _,class in ipairs(AURA_VISUALS) do
if obj:IsA(class) then return true end
end
return false
end
local function bodyPartFor(char,name)
local part=name and char:FindFirstChild(name)
if part and part:IsA("BasePart") then return part end
for _,alias in ipairs(name and BODY_ALIASES[name] or {}) do
part=char:FindFirstChild(alias)
if part and part:IsA("BasePart") then return part end
end
return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
end
local function auraClone(char)
local tempModel = currentAuraModel:Clone()
local moves = {}
for _, obj in ipairs(tempModel:GetDescendants()) do
if isAuraVisual(obj) then
local holder = obj.Parent
local inside = false
while holder and holder ~= tempModel and not holder:IsA("BasePart") do
if isAuraVisual(holder) then inside = true break end
holder = holder.Parent
end
local partName = holder and holder ~= tempModel and holder.Name or nil
local skip = inside
or (auraType == "Angel Wing" and partName and partName:lower():find("wing", 1, true))
if not skip then table.insert(moves, {obj, partName}) end
end
end
for _, move in ipairs(moves) do
local obj, target = move[1], bodyPartFor(char, move[2])
if target then
if target:FindFirstChild(obj.Name) then obj.Name = "VisualsV2_Aura" .. obj.Name end
obj.Parent = target
table.insert(auraEffects, obj)
end
end
tempModel:Destroy()
end
function applyAura()
clearAura()
local char = player.Character
if not char then return end
if not currentAuraModel then loadAuraModel() end
if not currentAuraModel then return end
if auraType == "Pink Aura" then
originalNexiumAuraClone(char)
else
auraClone(char)
end
end
local auraToggle = addToggle(auraSection, "Enable Local Aura", auraEnabled, function(state)
auraEnabled = state
SetCfg("auraEnabled", state)
if state then applyAura() else clearAura() end
end)
local auraItems = {}
for name in pairs(AuraModels) do table.insert(auraItems, name) end
table.sort(auraItems)
addDropdown(auraSection, "Aura Type", auraItems, auraType, function(selected)
auraType = selected
SetCfg("auraType", selected)
loadAuraModel()
if auraEnabled then applyAura() end
end)
env.VisualsV2Runtime.RegisterReset(function()
auraToggle:Set(false)
clearAura()
end)
end,"Section \"Auras\"")
;vv2Section(function()
if not inMurderMystery then return end
local section=mainTab:AddSection("Dual Effect","Cosmetic")
section:AddLabel("Must Own Dual Effect + Selected Effect")
local effects={"Vampiric2024","SynthEffect2025","Sunbeams2024","Snowstorm2024","Retro2025","Radioactive","Musical","Heatwave2025","Heartify","Gifts2024","Ghosts2024","Ghostify","FlamingoEffect2025","Burn","Cursed2024","Coal2025","Starry2024","Bats2024","Aquatic2025","Treats2025","Confetti2025","Bokeh2025","Lights2025","Jellyfish2024","Hearts26","XmasGlow2025","Cats2025","Carrots2025","BlueFire","Rainbows2025","Nightsky2025","Frost2025","Elitify","Electric","Dual","Abduction2025","SweetEffect26","UFOs2025","Strawberries26","Snowballs2025","Nightlife26","Leaves2025"}
local enabled=C("dualEffectEnabled",false)
local selected=C("dualEffectSelected","Electric")
local conn=nil
local token=0
local function stop() token=token+1; if conn then conn:Disconnect(); conn=nil end end
local function hook()
stop(); if not enabled then return end
local remotes=game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
local gameplay=remotes and remotes:FindFirstChild("Gameplay")
local roleSelect=gameplay and gameplay:FindFirstChild("RoleSelect")
local inventory=remotes and remotes:FindFirstChild("Inventory")
local equip=inventory and inventory:FindFirstChild("Equip")
if not roleSelect or not equip then return end
local mine=token
conn=roleSelect.OnClientEvent:Connect(function(role)
if not enabled or role~="Murderer" then return end
pcall(function() equip:FireServer("Dual","Effects") end)
task.delay(15,function()
if enabled and mine==token then pcall(function() equip:FireServer(selected,"Effects") end) end
end)
end)
end
addDropdown(section,"VV2 Select Second Effect",effects,selected,function(v) selected=v; SetCfg("dualEffectSelected",v) end)
local toggle=addToggle(section,"VV2 Auto Equip Dual Effect",enabled,function(v) enabled=v; SetCfg("dualEffectEnabled",v); hook() end)
env.VisualsV2Runtime.RegisterReset(function() toggle:Set(false); enabled=false; stop() end)
if enabled then hook() end
end,"Section \"Dual Effect\"")
local setupJumpCircles,jumpCirclesSection
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local jumpSection = mainTab:AddSection("Jump Circles & Effects", "Cosmetic")
jumpCirclesSection = jumpSection
local jumpCirclesEnabled = C("jumpCirclesEnabled", false)
local jumpCircleRainbow = C("jumpCircleRainbow", false)
local jumpCircleSize = C("jumpCircleSize", 5)
local jumpCircleTransparency = math.clamp(tonumber(C("jumpCircleTransparency", 1)) or 1, 0, 4)
local jumpCircleLifetime = math.max(0.2, tonumber(C("jumpCircleLifetime", 0.8)) or 0.8)
local jumpCircleColor = C("jumpCircleColor",Color3.fromRGB(38,38,38))
local function jumpAlpha(value)
value = math.clamp(tonumber(value) or 1, 0, 4)
return (value / 4) * 0.8
end
local function createJumpCircle(position)
local ring = Instance.new("Part")
ring.Name = "LV_JumpCircle"
ring.Anchored = true
ring.CanCollide = false
ring.CanTouch = false
ring.CanQuery = false
ring.CastShadow = false
ring.Material = Enum.Material.Neon
ring.Transparency = jumpAlpha(jumpCircleTransparency)
ring.Color = jumpCircleRainbow and Color3.fromHSV((tick() % 5) / 5, 1, 1) or jumpCircleColor
ring.Size = Vector3.new(1, 1, 1)
ring.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(90), 0, 0)
ring.Parent = workspace
local mesh = Instance.new("SpecialMesh")
mesh.MeshType = Enum.MeshType.FileMesh
mesh.MeshId = "rbxassetid://3270017"
mesh.Scale = Vector3.new(jumpCircleSize, jumpCircleSize, 0.15)
mesh.Parent = ring
local life = math.max(0.2, tonumber(jumpCircleLifetime) or 0.8)
TweenService:Create(mesh, TweenInfo.new(life, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Scale = Vector3.new(jumpCircleSize + 4, jumpCircleSize + 4, 0.15),
}):Play()
TweenService:Create(ring, TweenInfo.new(life), {Transparency = 1}):Play()
task.delay(life, function()
if ring and ring.Parent then ring:Destroy() end
end)
end
function setupJumpCircles(char)
task.spawn(function()
local humanoid = char:WaitForChild("Humanoid", 5)
local hrp = char:WaitForChild("HumanoidRootPart", 5)
if not humanoid or not hrp then return end
local wasInAir = false
local debounce = false
while runtimeAlive and char.Parent do
if not jumpCirclesEnabled then task.wait(0.25) else RunService.RenderStepped:Wait() end
if jumpCirclesEnabled and humanoid.Health > 0 then
local state = humanoid:GetState()
if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then
wasInAir = true
end
if wasInAir and humanoid.FloorMaterial ~= Enum.Material.Air and not debounce then
debounce = true
wasInAir = false
createJumpCircle(hrp.Position - Vector3.new(0, 2.8, 0))
task.delay(0.15, function() debounce = false end)
end
end
end
end)
end
local jumpEnableToggle = addToggle(jumpSection, "Enable Jump Circles", jumpCirclesEnabled, function(state)
jumpCirclesEnabled = state
SetCfg("jumpCirclesEnabled", state)
end)
local jumpRainbowToggle = addToggle(jumpSection, "Rainbow", jumpCircleRainbow, function(state)
jumpCircleRainbow = state
SetCfg("jumpCircleRainbow", state)
end)
jumpSection:AddSlider("Circle Size", 2, 15, jumpCircleSize, function(value)
jumpCircleSize = value
SetCfg("jumpCircleSize", value)
end)
jumpSection:AddSlider("Transparency", 0, 4, jumpCircleTransparency, function(value)
jumpCircleTransparency = math.clamp(tonumber(value) or 1, 0, 4)
SetCfg("jumpCircleTransparency", jumpCircleTransparency)
end)
jumpSection:AddSlider("Lifetime", 0.2, 5, jumpCircleLifetime, function(value)
jumpCircleLifetime = math.max(0.2, tonumber(value) or 0.8)
SetCfg("jumpCircleLifetime", jumpCircleLifetime)
end)
jumpSection:AddColorpicker("Circle Color", jumpCircleColor, function(color)
jumpCircleColor = color
SetCfg("jumpCircleColor", color)
end)
env.VisualsV2Runtime.RegisterReset(function()
jumpEnableToggle:Set(false)
jumpRainbowToggle:Set(false)
jumpCirclesEnabled = false
jumpCircleRainbow = false
jumpCircleSize = 5
jumpCircleTransparency = 1
jumpCircleLifetime = 0.8
jumpCircleColor = Color3.fromRGB(255,255,255)
end)
end,"Section \"Jump Circles\"")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local fxConnections={}
local _time = os.clock()
local tweenservice = game:GetService("TweenService")
local runservice = game:GetService("RunService")
local players = game:GetService("Players")
local lp = players.LocalPlayer
local world = workspace
local cam = world.CurrentCamera
local newinst = Instance.new
local cfnew = CFrame.new
local cfang = CFrame.fromEulerAnglesXYZ
local v3 = Vector3.new
local c3 = Color3.new
local rgb = Color3.fromRGB
local sin = math.sin
local cos = math.cos
local rad = math.rad
local floor = math.floor
local mmin = math.min
local mmax = math.max
local clamp = math.clamp
local random = math.random
local tcreate = table.create
local tclear = table.clear
local tau = 6.283185307179586
local halfpi = 1.5707963267948966
local turn90 = cfang(0, halfpi, 0)
local flat90 = cfang(0, 0, halfpi)
local white = c3(1, 1, 1)
local matneon = Enum.Material.Neon
local shapeball = Enum.PartType.Ball
local shapecyl = Enum.PartType.Cylinder
local easequint = Enum.EasingStyle.Quint
local easequad = Enum.EasingStyle.Quad
local dirout = Enum.EasingDirection.Out
local dirin = Enum.EasingDirection.In
local api = {}
local cfg = {}
local visuals = {}
local hub = odh_shared_plugins
local bulkmode
do
local ok, value = pcall(function()
return Enum.BulkMoveMode.AvoidAllEvents
end)
if ok then
bulkmode = value
end
end
local function moveparts(list, frames)
if bulkmode then
world:BulkMoveTo(list, frames, bulkmode)
return
end
for i = 1, #list do
list[i].CFrame = frames[i]
end
end
local function lighten(color, amount)
return c3(
mmin(color.R + amount, 1),
mmin(color.G + amount, 1),
mmin(color.B + amount, 1))
end
fxConnections[#fxConnections+1]=world:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
cam = world.CurrentCamera
end)
local isphone, maxfx, quality, qualitylock
do
local userinput = game:GetService("UserInputService")
local touch = userinput.TouchEnabled
local keyboard = userinput.KeyboardEnabled
local category
if userinput.GamepadEnabled and not keyboard then
category = "Console"
elseif touch and not keyboard then
category = "Mobile"
else
category = "Desktop"
end
isphone = category == "Mobile"
maxfx = isphone and 220 or 400
local ok, value = pcall(lp.GetAttribute, lp, "QualityOverride")
if ok and value then
qualitylock = value
quality = value
end
if not quality then
local view = cam and cam.ViewportSize or Vector2.new(1920, 1080)
local pixels = view.X * view.Y
if category == "Mobile" then
quality = pixels < 1300000 and 0.5 or 0.75
elseif category == "Console" then
quality = 0.85
else
quality = 1
end
end
end
local function quantity(count, minimum)
return mmax(minimum or 1, floor(count * quality + 0.5))
end
local jobs = {}
local jobset = {}
local jobsdirty = false
local hbconn
local fpssum = 0
local fpscount = 0
local step
local function addjob(fn)
if jobset[fn] then
return
end
jobset[fn] = true
local slot = 0
for i = 1, #jobs do
if not jobs[i] then
slot = i
break
end
end
if slot > 0 then
jobs[slot] = fn
else
jobs[#jobs + 1] = fn
end
if not hbconn then
hbconn = runservice.Heartbeat:Connect(step)
end
end
local function removejob(fn)
if not jobset[fn] then
return
end
jobset[fn] = nil
for i = 1, #jobs do
if jobs[i] == fn then
jobs[i] = false
jobsdirty = true
break
end
end
end
step = function(dt)
if dt > 0 then
fpssum=fpssum+dt
fpscount=fpscount+1
if fpscount >= 60 then
if not qualitylock then
local fps = fpscount / fpssum
if fps < 30 then
quality = mmax(0.4, quality - 0.1)
elseif fps > 55 then
quality = mmin(1, quality + 0.05)
end
end
fpssum = 0
fpscount = 0
end
end
local total = #jobs
for i = 1, total do
local fn = jobs[i]
if fn then
fn(dt)
end
end
if jobsdirty then
jobsdirty = false
local write = 0
for i = 1, #jobs do
local fn = jobs[i]
if fn then
write=write+1
jobs[write] = fn
end
end
for i = #jobs, write + 1, -1 do
jobs[i] = nil
end
if write == 0 and hbconn then
hbconn:Disconnect()
hbconn = nil
end
end
end
local tinfo
do
local cache = {}
tinfo = function(duration, style, direction)
local bystyle = cache[style]
if not bystyle then
bystyle = {}
cache[style] = bystyle
end
local bydir = bystyle[direction]
if not bydir then
bydir = {}
bystyle[direction] = bydir
end
local info = bydir[duration]
if not info then
info = TweenInfo.new(duration, style, direction)
bydir[duration] = info
end
return info
end
end
local fxfolder
local advfolder
local fxcount = 0
local function getfolder()
if fxfolder and fxfolder.Parent then
return fxfolder
end
fxfolder = newinst("Folder")
fxfolder.Name = "VisualsV2_Effects"
fxfolder.Parent = world
return fxfolder
end
local function getadvfolder()
if advfolder and advfolder.Parent then
return advfolder
end
advfolder = newinst("Folder")
advfolder.Name = "VisualsV2_AdvancedFX"
advfolder.Parent = world
return advfolder
end
getfolder()
local killMotion={}
local launchkillpart
local acquire, release
do
local partpool = tcreate(64)
local wedgepool = tcreate(16)
local pooled = setmetatable({}, { __mode = "k" })
local smooth = Enum.SurfaceType.Smooth
local block = Enum.PartType.Block
acquire = function(class)
local pool = class == "WedgePart" and wedgepool or partpool
local count = #pool
if count > 0 then
local part = pool[count]
pool[count] = nil
pooled[part] = nil
return part
end
local part = newinst(class or "Part")
part.CanCollide = false
part.CanQuery = false
part.CanTouch = false
part.CastShadow = false
part.Massless = true
part.Locked = true
part.TopSurface = smooth
part.BottomSurface = smooth
return part
end
release = function(part)
killMotion[part]=nil
if pooled[part] then
return
end
local class = part.ClassName
part:ClearAllChildren()
part.Parent = nil
part.Anchored = true
part.Transparency = 1
part.Name = class
if class == "Part" then
part.Shape = block
end
local pool = class == "WedgePart" and wedgepool or partpool
if #pool >= 320 then
part:Destroy()
return
end
pooled[part] = true
pool[#pool + 1] = part
end
api.ispooled = function(part)
return pooled[part] == true
end
end
local function releasefx(part)
if api.ispooled(part) then
return
end
fxcount=fxcount-1
release(part)
end
local function releaselist(list)
for i = 1, #list do
releasefx(list[i])
end
tclear(list)
end
local function recycle(folder)
if not folder then
return
end
for _, child in folder:GetChildren() do
if child:IsA("BasePart") then
release(child)
else
child:Destroy()
end
end
folder:Destroy()
end
local function newneon(size, color, class)
local part = acquire(class)
part.Size = size
part.Color = color
part.Material = matneon
part.Anchored = false
part.Transparency = 0
return part
end
local function weldto(base, part, c0)
local weld = newinst("Weld")
weld.Part0 = base
weld.Part1 = part
weld.C0 = c0
weld.Parent = part
return weld
end
local function killlight(parent, name)
if not parent then
return
end
local light = parent:FindFirstChild(name)
if light then
light:Destroy()
end
end
local function makelight(parent, name, color, brightness, range)
if not parent then
return
end
killlight(parent, name)
local light = newinst("PointLight")
light.Name = name
light.Color = color
light.Brightness = brightness
light.Range = range
light.Shadows = false
light.Parent = parent
return light
end
local vis = {
jump = {
enabled = false,
style = "Swirl",
color = rgb(120, 190, 255),
size = 7,
duration = 0.7,
flash = true,
sparks = true,
},
wings = {
enabled = false,
style = "Angel",
color = rgb(150, 200, 255),
scale = 1,
droop = 0,
flap = true,
glow = true,
},
halo = {
enabled = false,
style = "Ring",
color = rgb(255, 225, 130),
speed = 1,
glow = true,
},
hat = {
enabled = false,
style = "Layered",
color = rgb(255, 120, 90),
size = 1,
spin = 0.6,
glow = true,
},
}
visuals.jumpstyles = {
"Swirl", "Ring", "Vortex", "Triple", "Nova",
"Ripple", "Comet", "Shockwave", "Petals",
}
visuals.wingstyles = { "Angel", "Demon", "Phantom", "Simple", "Crystal" }
visuals.halostyles = { "Ring", "Double", "Orbs", "Tilted" }
visuals.hatstyles = { "Layered", "Cone", "Rings", "Spikes", "Classic" }
local character, humanoid, root, torso, head
local jumpconn, stateconn
local groundparams = RaycastParams.new()
groundparams.FilterType = Enum.RaycastFilterType.Exclude
groundparams.IgnoreWater = true
local function groundat(position, drop)
local ignore = { getfolder() }
if advfolder then
ignore[#ignore + 1] = advfolder
end
for _, player in players:GetPlayers() do
if player.Character then
ignore[#ignore + 1] = player.Character
end
end
local direction = v3(0, -(drop or 8), 0)
for _ = 1, 6 do
groundparams.FilterDescendantsInstances = ignore
local ok, hit = pcall(world.Raycast, world, position, direction, groundparams)
if not ok or not hit then
return nil
end
local part = hit.Instance
local body = part:FindFirstAncestorOfClass("Model")
local owner = body and body:FindFirstChild("PlayerName")
local corpse = body and (body:FindFirstChildOfClass("Humanoid")
    or (owner and owner:IsA("StringValue")))
if corpse then
ignore[#ignore + 1] = body
elseif part.CanCollide and part.Transparency < 1 then
return hit.Position
else
ignore[#ignore + 1] = part
end
end
return nil
end
do
local function spawnflash(origin, diameter, color, duration)
local part = acquire()
part.Shape = shapecyl
part.Size = v3(0.08, diameter * 0.45, diameter * 0.45)
part.CFrame = cfnew(origin) * flat90
part.Anchored = true
part.Material = matneon
part.Color = lighten(color, 0.45)
part.Transparency = 0.25
part.Parent = getfolder()
fxcount=fxcount+1
tweenservice:Create(part, tinfo(duration * 0.55, easequint, dirout), {
Size = v3(0.02, diameter * 1.5, diameter * 1.5),
Transparency = 1,
}):Play()
task.delay(duration + 0.1, releasefx, part)
end
local function spawndisc(origin, diameter, thickness, color, duration, expand)
local part = acquire()
part.Shape = shapecyl
part.Size = v3(thickness, diameter, diameter)
part.CFrame = cfnew(origin + v3(0, thickness * 0.5, 0)) * flat90
part.Anchored = true
part.Material = matneon
part.Color = color
part.Transparency = 0.15
part.Parent = getfolder()
fxcount=fxcount+1
tweenservice:Create(part, tinfo(duration, easequint, dirout), {
Size = v3(thickness * 0.4, diameter * expand, diameter * expand),
Transparency = 1,
}):Play()
task.delay(duration + 0.15, releasefx, part)
end
local function spawnarc(origin, opts)
local segments = quantity(opts.segments or 26, 8)
local sweep = opts.sweep or tau
local start = opts.start or 0
local radius0 = opts.radius0 or 1.2
local radius1 = opts.radius1 or 8
local thickness = opts.thickness or 0.22
local duration = opts.duration or 0.7
local spin = opts.spin or 0
local fade = opts.fade or 0
local color = opts.color or white
local tipcolor = lighten(color, 0.5)
local startsize = v3(thickness, thickness, (sweep * radius0 / segments) * 1.08)
local endsize = v3(thickness * 0.32, thickness * 0.32, (sweep * radius1 / segments) * 1.08)
local info = tinfo(duration, easequint, dirout)
local tilt = opts.tilt or 0
local lift = mmax(radius0, radius1) * math.abs(sin(tilt)) + thickness * 0.5
local base = cfnew(origin + v3(0, lift, 0)) * cfang(tilt, 0, 0)
local inner = cfnew(0, 0, -radius0) * turn90
local outer = cfnew(0, opts.rise or 0, -radius1) * turn90
local folder = getfolder()
local made = tcreate(segments)
for index = 1, segments do
local ratio = (index - 1) / segments
local angle = start + ratio * sweep
local piece = acquire()
piece.Size = startsize
piece.CFrame = base * cfang(0, angle, 0) * inner
piece.Anchored = true
piece.Material = matneon
piece.Color = color:Lerp(tipcolor, ratio)
piece.Transparency = clamp(fade * ratio, 0, 0.9)
piece.Parent = folder
tweenservice:Create(piece, info, {
CFrame = base * cfang(0, angle + spin, 0) * outer,
Size = endsize,
Transparency = 1,
}):Play()
made[index] = piece
end
fxcount=fxcount+segments
task.delay(duration + 0.2, releaselist, made)
end
local function spawnshard(origin, angle, color, duration)
local shard = newneon(v3(0.18, 1.1, 0.18), color)
shard.Anchored = true
shard.Transparency = 0.1
local pivot = cfnew(origin) * cfang(0, angle, 0)
shard.CFrame = pivot * cfnew(0, 0.6, -1)
shard.Parent = getfolder()
fxcount=fxcount+1
tweenservice:Create(shard, tinfo(duration, easequint, dirout), {
CFrame = pivot * cfnew(0, 2.2, -4.5),
Size = v3(0.05, 0.3, 0.05),
Transparency = 1,
}):Play()
task.delay(duration + 0.15, releasefx, shard)
end
local function spawnsparks(origin, color, duration, count, radius)
if not vis.jump.sparks then
return
end
local folder = getfolder()
local total = quantity(count or 10, 4)
local tint = lighten(color, 0.3)
local size = v3(0.16, 0.16, 0.16)
local endsize = v3(0.03, 0.03, 0.03)
local info = tinfo(duration, easequad, dirout)
for index = 1, total do
local angle = (index / total) * tau + random() * 0.4
local spark = newneon(size, tint)
spark.Shape = shapeball
spark.Anchored = true
spark.Transparency = 0.1
local pivot = cfnew(origin) * cfang(0, angle, 0)
spark.CFrame = pivot * cfnew(0, 0.2, -0.6)
spark.Parent = folder
tweenservice:Create(spark, info, {
CFrame = pivot * cfnew(0,
1.4 + random() * 2.2,
-((radius or 4) * (0.6 + random() * 0.7))),
Size = endsize,
Transparency = 1,
}):Play()
task.delay(duration + 0.15, releasefx, spark)
end
fxcount=fxcount+total
end
local styles = {}
styles.Ring = function(origin, color, duration, size)
spawnarc(origin, {
color = color, duration = duration, segments = 30,
radius0 = size * 0.16, radius1 = size, thickness = size * 0.035,
fade = 0.15, rise = 0.25,
})
spawnsparks(origin, color, duration, 8, size * 0.5)
end
styles.Vortex = function(origin, color, duration, size)
for layer = 1, 3 do
task.delay((layer - 1) * 0.07, spawnarc, origin, {
color = color, duration = duration, segments = 22,
sweep = rad(300), start = layer * 2.1,
radius0 = size * (0.12 + layer * 0.05),
radius1 = size * (0.75 + layer * 0.2),
thickness = size * (0.045 - layer * 0.008),
spin = (layer % 2 == 0) and -0.9 or 0.9,
tilt = rad(layer * 4), rise = 0.35 * layer, fade = 0.75,
})
end
end
styles.Triple = function(origin, color, duration, size)
for index = 1, 3 do
task.delay((index - 1) * 0.11, spawnarc, origin, {
color = color, duration = duration, segments = 24,
radius0 = size * 0.14, radius1 = size * (0.6 + index * 0.22),
thickness = size * 0.03, fade = 0.2, rise = 0.15 * index,
})
end
end
styles.Nova = function(origin, color, duration, size)
spawnarc(origin, {
color = color, duration = duration, segments = 28,
radius0 = size * 0.15, radius1 = size * 0.95,
thickness = size * 0.04, fade = 0.1,
})
local shards = quantity(8, 4)
for index = 1, shards do
spawnshard(origin, (index / 8) * tau, color, duration * 0.9)
end
spawnsparks(origin, color, duration, 12, size * 0.6)
end
styles.Ripple = function(origin, color, duration, size)
for index = 1, 3 do
task.delay((index - 1) * 0.13, spawndisc, origin,
size * (0.4 + index * 0.1), 0.14, color, duration, 2.1)
end
end
styles.Comet = function(origin, color, duration, size)
spawnarc(origin, {
color = color, duration = duration * 1.1, segments = 24,
sweep = rad(150), start = random() * tau,
radius0 = size * 0.12, radius1 = size * 1.15,
thickness = size * 0.05, spin = 1.6, tilt = rad(8),
rise = 0.8, fade = 0.95,
})
spawnsparks(origin, color, duration, 8, size * 0.4)
end
styles.Shockwave = function(origin, color, duration, size)
spawndisc(origin, size * 0.5, 0.18, color, duration, 2.6)
spawnarc(origin, {
color = color, duration = duration * 0.9, segments = 34,
radius0 = size * 0.3, radius1 = size * 1.3,
thickness = size * 0.025, fade = 0.05,
})
end
styles.Petals = function(origin, color, duration, size)
local petals = quantity(6, 3)
for index = 1, petals do
spawnarc(origin, {
color = color, duration = duration, segments = 10,
sweep = rad(52), start = (index / 6) * tau,
radius0 = size * 0.2, radius1 = size * 0.9,
thickness = size * 0.05, tilt = rad(14), rise = 0.5, fade = 0.5,
})
end
end
styles.Swirl = function(origin, color, duration, size)
spawnarc(origin, {
color = color, duration = duration, segments = 28,
sweep = rad(310), start = 0,
radius0 = size * 0.15, radius1 = size,
thickness = size * 0.045, spin = 0.7, rise = 0.4, fade = 0.85,
})
spawnarc(origin, {
color = color, duration = duration * 1.15, segments = 22,
sweep = rad(265), start = math.pi,
radius0 = size * 0.1, radius1 = size * 0.78,
thickness = size * 0.03, spin = -0.5, tilt = rad(6),
rise = 0.2, fade = 0.7,
})
spawnsparks(origin, color, duration, 6, size * 0.45)
end
local function spawnoutline(origin, points, color, duration, size0, size1, thickness, spin)
local total = #points
local folder = getfolder()
local info = tinfo(duration, easequint, dirout)
local lift = v3(0, thickness * 0.5, 0)
local turn = spin or 0
local made = tcreate(total)
local function edge(index, scale, angle)
local a = points[index]
local b = points[index % total + 1]
local rotate = cfang(0, angle, 0)
local from = origin + lift + rotate:VectorToWorldSpace(v3(a[1] * scale, 0, a[2] * scale))
local to = origin + lift + rotate:VectorToWorldSpace(v3(b[1] * scale, 0, b[2] * scale))
local length = (to - from).Magnitude
return CFrame.lookAt((from + to) * 0.5, to), length
end
for index = 1, total do
local piece = acquire()
local startcf, startlength = edge(index, size0, 0)
local endcf, endlength = edge(index, size1, turn)
piece.Size = v3(thickness, thickness, startlength * 1.1 + 0.01)
piece.CFrame = startcf
piece.Anchored = true
piece.Material = matneon
piece.Color = color:Lerp(lighten(color, 0.5), index / total)
piece.Transparency = 0.1
piece.Parent = folder
tweenservice:Create(piece, info, {
CFrame = endcf,
Size = v3(thickness * 0.4, thickness * 0.4, endlength * 1.1 + 0.01),
Transparency = 1,
}):Play()
made[index] = piece
end
fxcount=fxcount+total
task.delay(duration + 0.2, releaselist, made)
end
local heartpoints, starpoints = {}, {}
do
local count = 20
for index = 0, count - 1 do
local t = index / count * tau
local x = 16 * sin(t) ^ 3
local y = 13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t)
heartpoints[#heartpoints + 1] = { x / 34, -(y + 2) / 34 }
end
for index = 0, 9 do
local t = index / 10 * tau
local radius = index % 2 == 0 and 0.5 or 0.22
starpoints[#starpoints + 1] = { sin(t) * radius, -cos(t) * radius }
end
end
visuals.heartpoints, visuals.starpoints = heartpoints, starpoints
local AURA = {
Godly = { rgb(255, 214, 90), rgb(255, 248, 220) },
["Super Saiyan"] = { rgb(255, 226, 60), rgb(255, 150, 20) },
["North Star"] = { rgb(170, 225, 255), rgb(255, 255, 255) },
["Blue Lord"] = { rgb(40, 90, 255), rgb(90, 230, 255) },
["Pink Aura"] = { rgb(255, 105, 200), rgb(255, 190, 235) },
["Angel Wing"] = { rgb(255, 255, 255), rgb(255, 228, 150) },
["Sweet Heart"] = { rgb(255, 70, 130), rgb(255, 170, 200) },
Ethereal = { rgb(170, 120, 255), rgb(110, 255, 225) },
}
visuals.aurapalettes = AURA
styles.Godly = function(origin, _, duration, size)
local gold, light = AURA.Godly[1], AURA.Godly[2]
spawndisc(origin, size * 0.45, 0.12, gold, duration, 2.4)
spawnarc(origin, {
color = light, duration = duration, segments = 30,
radius0 = size * 0.2, radius1 = size * 1.1, thickness = size * 0.03, fade = 0.1,
})
for index = 1, quantity(6, 3) do
spawnshard(origin, (index / 6) * tau, gold, duration * 0.9)
end
spawnsparks(origin, gold, duration, 10, size * 0.6)
end
styles["Super Saiyan"] = function(origin, _, duration, size)
local yellow, orange = AURA["Super Saiyan"][1], AURA["Super Saiyan"][2]
for index = 1, quantity(12, 6) do
spawnshard(origin, (index / 12) * tau + random() * 0.2, index % 2 == 0 and orange or yellow, duration * 0.8)
end
spawnarc(origin, {
color = yellow, duration = duration, segments = 26,
radius0 = size * 0.15, radius1 = size * 0.9, thickness = size * 0.04,
spin = 0.5, rise = 0.3, fade = 0.4,
})
spawnsparks(origin, orange, duration, 12, size * 0.55)
end
styles["North Star"] = function(origin, _, duration, size)
local ice, light = AURA["North Star"][1], AURA["North Star"][2]
spawnoutline(origin, starpoints, ice, duration, size * 0.3, size * 1.6, mmax(0.12, size * 0.03), rad(36))
spawnarc(origin, {
color = light, duration = duration * 0.9, segments = 26,
radius0 = size * 0.15, radius1 = size * 0.75, thickness = size * 0.025, fade = 0.2,
})
spawnsparks(origin, light, duration, 8, size * 0.5)
end
styles["Blue Lord"] = function(origin, _, duration, size)
local deep, cyan = AURA["Blue Lord"][1], AURA["Blue Lord"][2]
for layer = 1, 3 do
task.delay((layer - 1) * 0.07, spawnarc, origin, {
color = layer == 2 and cyan or deep, duration = duration, segments = 22,
sweep = rad(300), start = layer * 2.1,
radius0 = size * (0.12 + layer * 0.05),
radius1 = size * (0.75 + layer * 0.2),
thickness = size * (0.045 - layer * 0.008),
spin = (layer % 2 == 0) and -0.9 or 0.9, rise = 0.3 * layer, fade = 0.7,
})
end
spawnsparks(origin, cyan, duration, 8, size * 0.5)
end
styles["Pink Aura"] = function(origin, _, duration, size)
local pink, light = AURA["Pink Aura"][1], AURA["Pink Aura"][2]
spawnarc(origin, {
color = pink, duration = duration, segments = 28,
sweep = rad(310), radius0 = size * 0.15, radius1 = size,
thickness = size * 0.045, spin = 0.7, rise = 0.4, fade = 0.8,
})
for index = 1, quantity(5, 3) do
spawnarc(origin, {
color = light, duration = duration, segments = 8,
sweep = rad(48), start = (index / 5) * tau,
radius0 = size * 0.2, radius1 = size * 0.8,
thickness = size * 0.045, rise = 0.4, fade = 0.5,
})
end
spawnsparks(origin, light, duration, 8, size * 0.45)
end
styles["Angel Wing"] = function(origin, _, duration, size)
local white2, gold = AURA["Angel Wing"][1], AURA["Angel Wing"][2]
for side = -1, 1, 2 do
for feather = 1, 3 do
spawnarc(origin, {
color = feather == 2 and gold or white2, duration = duration, segments = 10,
sweep = rad(40), start = side * rad(90) + side * rad(feather * 22) - rad(20),
radius0 = size * 0.2, radius1 = size * (0.7 + feather * 0.12),
thickness = size * 0.04, rise = 0.6, fade = 0.5,
})
end
end
spawndisc(origin, size * 0.35, 0.1, gold, duration * 0.8, 2)
spawnsparks(origin, white2, duration, 10, size * 0.5)
end
styles["Sweet Heart"] = function(origin, _, duration, size)
local red, pink = AURA["Sweet Heart"][1], AURA["Sweet Heart"][2]
spawnoutline(origin, heartpoints, red, duration, size * 0.3, size * 1.7, mmax(0.12, size * 0.03))
task.delay(0.1, spawnoutline, origin, heartpoints, pink, duration, size * 0.2, size * 1.1, mmax(0.1, size * 0.025))
spawnsparks(origin, pink, duration, 8, size * 0.5)
end
styles.Ethereal = function(origin, _, duration, size)
local purple, teal = AURA.Ethereal[1], AURA.Ethereal[2]
for index = 1, 3 do
task.delay((index - 1) * 0.11, spawnarc, origin, {
color = index % 2 == 0 and teal or purple, duration = duration, segments = 24,
radius0 = size * 0.14, radius1 = size * (0.6 + index * 0.22),
thickness = size * 0.03, fade = 0.3, rise = 0.15 * index,
spin = (index % 2 == 0) and 0.4 or -0.4,
})
end
spawnsparks(origin, teal, duration, 10, size * 0.55)
end
for _, name in ipairs({ "Godly", "Super Saiyan", "North Star", "Blue Lord", "Pink Aura", "Angel Wing", "Sweet Heart", "Ethereal" }) do
visuals.jumpstyles[#visuals.jumpstyles + 1] = name
end
local lastjump = 0
api.playjump = function()
local jump = vis.jump
if not jump.enabled or not root or not root.Parent then
return
end
local now = os.clock()
if now - lastjump < 0.15 or fxcount > maxfx then
return
end
lastjump = now
local ground = groundat(root.Position, 8)
local origin = ground and ground + v3(0, 0.05, 0) or root.Position - v3(0, 2.55, 0)
local palette = AURA[jump.style]
local color = palette and palette[1] or jump.color
local duration = jump.duration
local size = jump.size
if jump.flash then
spawnflash(origin, size * 0.5, color, duration)
end
local handler = styles[jump.style] or styles.Swirl
handler(origin, color, duration, size)
end
end
local wingparts, haloparts, hatparts = {}, {}, {}
do
local wingsfolder, halofolder, hatfolder
local halohasbob = false
local animclock = 0
local flapaccum = 0
local flapreset = false
local animrunning = false
local wingbase, winglight
local pending = { wings = false, halo = false, hat = false }
local function addtrail(part, color, lifetime, width)
local front = newinst("Attachment")
front.Position = v3(0, part.Size.Y * 0.5, -part.Size.Z * 0.5)
front.Parent = part
local back = newinst("Attachment")
back.Position = v3(0, part.Size.Y * 0.5, part.Size.Z * 0.5)
back.Parent = part
local trail = newinst("Trail")
trail.Attachment0 = front
trail.Attachment1 = back
trail.Color = ColorSequence.new(color)
trail.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.35),
NumberSequenceKeypoint.new(1, 1),
})
trail.Lifetime = lifetime or 0.35
trail.WidthScale = NumberSequence.new({
NumberSequenceKeypoint.new(0, width or 1),
NumberSequenceKeypoint.new(1, 0),
})
trail.LightEmission = 1
trail.LightInfluence = 0
trail.FaceCamera = true
trail.Parent = part
return trail
end
local function addfeather(side, opts)
local shade = opts.shade or 0
local feather = newneon(v3(opts.thickness, opts.length, opts.width),
wingbase:Lerp(winglight, shade))
feather.Transparency = opts.transparency or 0.1
feather.Parent = wingsfolder
local spread = opts.spread + rad(vis.wings.droop or 0)
local origin = cfnew(side * opts.originx, opts.originy, opts.originz)
* cfang(opts.pitch or 0, side * opts.sweep, -side * spread)
local offset = cfnew(0, opts.length * 0.5, 0)
wingparts[#wingparts + 1] = {
weld = weldto(torso, feather, origin * offset),
origin = origin,
offset = offset,
rest = origin * offset,
phase = opts.phase or 0,
amp = opts.amp or 0.12,
part = feather,
shade = shade,
}
if opts.tip then
local tiplength = opts.length * 0.32
local tip = newneon(v3(opts.thickness, opts.width * 0.95, tiplength),
winglight, "WedgePart")
tip.Transparency = clamp((opts.transparency or 0.1) + 0.12, 0, 0.95)
tip.Parent = wingsfolder
local tipoffset = cfnew(0, opts.length + tiplength * 0.5, 0)
* cfang(-halfpi, 0, 0)
wingparts[#wingparts + 1] = {
weld = weldto(torso, tip, origin * tipoffset),
origin = origin,
offset = tipoffset,
rest = origin * tipoffset,
phase = opts.phase or 0,
amp = opts.amp or 0.12,
part = tip,
shade = 1,
}
end
return feather
end
local rows = {
{ count = 7, long = 4, short = 2.2, from = 56, to = 124,
width = 0.48, thick = 0.1, z = 0.68, y = 0.3, x = 0.4,
alpha = 0.06, amp = 0.16, tip = true, pitch = -12 },
{ count = 5, long = 2.7, short = 1.6, from = 62, to = 116,
width = 0.4, thick = 0.09, z = 0.56, y = 0.24, x = 0.36,
alpha = 0.2, amp = 0.12, tip = true, pitch = -8 },
{ count = 4, long = 1.4, short = 0.85, from = 70, to = 106,
width = 0.32, thick = 0.08, z = 0.46, y = 0.2, x = 0.32,
alpha = 0.4, amp = 0.08, tip = false, pitch = -5 },
}
local builders = {}
builders.Demon = function(side, scale)
local bones = quantity(5, 4)
for index = 1, bones do
local ratio = (index - 1) / (bones - 1)
local length = (4.3 - ratio * 1.6) * scale
local spread = rad(58 + ratio * 62)
addfeather(side, {
length = length, width = 0.16 * scale, thickness = 0.15 * scale,
spread = spread, sweep = rad(30), pitch = rad(-10 - ratio * 8),
originx = 0.5 * scale, originy = 0.15 * scale, originz = 0.68 * scale,
shade = ratio * 0.5, transparency = 0.05,
phase = index * 0.3, amp = 0.08 + ratio * 0.1, tip = true,
})
if index < bones then
local nextratio = index / (bones - 1)
addfeather(side, {
length = length * 0.82, width = (1.2 - ratio * 0.25) * scale,
thickness = 0.05 * scale,
spread = spread + rad(10 + nextratio * 5),
sweep = rad(30), pitch = rad(-10 - ratio * 8),
originx = 0.5 * scale, originy = 0.15 * scale, originz = 0.66 * scale,
shade = 0, transparency = 0.6,
phase = index * 0.3 + 0.08, amp = 0.08 + ratio * 0.1,
})
end
end
end
builders.Simple = function(side, scale)
local total = quantity(4, 3)
for index = 1, total do
local ratio = (index - 1) / 3
addfeather(side, {
length = (2.9 - ratio * 0.9) * scale,
width = (0.62 - ratio * 0.14) * scale, thickness = 0.09 * scale,
spread = rad(62 + ratio * 46), sweep = rad(20), pitch = rad(-8),
originx = 0.42 * scale, originy = 0.25 * scale, originz = 0.6 * scale,
shade = ratio, transparency = 0.18,
phase = index * 0.35, amp = 0.1 + ratio * 0.06, tip = true,
})
end
end
builders.Phantom = function(side, scale)
local total = quantity(6, 4)
for index = 1, total do
local ratio = (index - 1) / 5
local blade = addfeather(side, {
length = (4.8 - ratio * 2.2) * scale,
width = (0.34 - ratio * 0.1) * scale, thickness = 0.06 * scale,
spread = rad(54 + ratio * 70), sweep = rad(26),
pitch = rad(-12 - ratio * 10),
originx = 0.36 * scale, originy = 0.3 * scale, originz = 0.6 * scale,
shade = ratio, transparency = 0.5 + ratio * 0.18,
phase = index * 0.42, amp = 0.16 + ratio * 0.12, tip = true,
})
if index <= 3 then
addtrail(blade, wingbase:Lerp(winglight, ratio), 0.5, 1.2)
end
end
end
builders.Crystal = function(side, scale)
for index = 1, 3 do
local ratio = (index - 1) / 2
local shard = addfeather(side, {
length = (4.2 - ratio * 1.4) * scale,
width = (0.95 - ratio * 0.25) * scale, thickness = 0.07 * scale,
spread = rad(60 + ratio * 40), sweep = rad(24), pitch = rad(-14),
originx = 0.34 * scale, originy = 0.3 * scale, originz = 0.62 * scale,
shade = ratio * 0.7, transparency = 0.35,
phase = index * 0.5, amp = 0.1, tip = true,
})
if index == 1 then
addtrail(shard, winglight, 0.45, 1.6)
end
end
end
builders.Angel = function(side, scale)
for rowindex = 1, 3 do
local row = rows[rowindex]
local count = quantity(row.count, 3)
for index = 1, count do
local ratio = count > 1 and (index - 1) / (count - 1) or 0
local feather = addfeather(side, {
length = (row.long - ratio * (row.long - row.short)) * scale,
width = row.width * scale,
thickness = row.thick * scale,
spread = rad(row.from + ratio * (row.to - row.from)),
sweep = rad(24 - rowindex * 3),
pitch = rad(row.pitch),
originx = row.x * scale,
originy = row.y * scale,
originz = row.z * scale,
shade = ratio * 0.85,
transparency = row.alpha,
phase = index * 0.26 + rowindex * 0.5,
amp = row.amp,
tip = row.tip,
})
if rowindex == 1 and index <= 2 and not isphone then
addtrail(feather, winglight, 0.4, 1.1)
end
end
end
end
local function clearwings()
recycle(wingsfolder)
wingsfolder = nil
tclear(wingparts)
killlight(torso, "VisualsV2_WingGlow")
end
local function buildwings()
clearwings()
if not vis.wings.enabled or not torso or not torso.Parent then
return
end
wingsfolder = newinst("Folder")
wingsfolder.Name = "VisualsV2_Wings"
wingsfolder.Parent = character
wingbase = vis.wings.color
winglight = lighten(wingbase, 0.4)
local scale = vis.wings.scale
local builder = builders[vis.wings.style] or builders.Angel
builder(-1, scale)
builder(1, scale)
if vis.wings.glow then
makelight(torso, "VisualsV2_WingGlow", wingbase, 2.4, 14)
end
end
local function clearhalo()
recycle(halofolder)
halofolder = nil
tclear(haloparts)
halohasbob = false
killlight(head, "VisualsV2_HaloGlow")
end
local function buildhalo()
clearhalo()
if not vis.halo.enabled or not head or not head.Parent then
return
end
halofolder = newinst("Folder")
halofolder.Name = "VisualsV2_Halo"
halofolder.Parent = character
local color = vis.halo.color
local style = vis.halo.style
local function ring(radius, height, segments, tilt, direction, thickness)
segments = quantity(segments, 8)
local size = v3(thickness, thickness, (tau * radius / segments) * 1.08)
local basecf = cfnew(0, height, 0)
local tailcf = cfnew(0, 0, -radius) * turn90
for index = 1, segments do
local angle = (index / segments) * tau
local piece = newneon(size, color)
piece.Parent = halofolder
haloparts[#haloparts + 1] = {
weld = weldto(head, piece, basecf * cfang(tilt, angle, 0) * tailcf),
angle = angle,
tilt = tilt,
dir = direction,
height = height,
base = basecf,
tail = tailcf,
part = piece,
}
end
end
if style == "Double" then
ring(0.85, 1.55, 16, 0, 1, 0.1)
ring(0.6, 1.75, 12, rad(28), -1, 0.08)
elseif style == "Orbs" then
halohasbob = true
local size = v3(0.22, 0.22, 0.22)
local basecf = cfnew(0, 1.6, 0)
local tailcf = cfnew(0, 0, -0.9) * turn90
for index = 1, 6 do
local orb = newneon(size, color)
orb.Shape = shapeball
orb.Parent = halofolder
haloparts[#haloparts + 1] = {
weld = weldto(head, orb, basecf),
angle = (index / 6) * tau,
tilt = 0,
dir = 1,
height = 1.6,
base = basecf,
tail = tailcf,
bob = index * 0.5,
part = orb,
}
end
elseif style == "Tilted" then
ring(0.9, 1.6, 18, rad(22), 1, 0.1)
else
ring(0.85, 1.6, 18, 0, 1, 0.1)
end
if vis.halo.glow then
makelight(head, "VisualsV2_HaloGlow", color, 1.6, 9)
end
end
local function clearhat()
recycle(hatfolder)
hatfolder = nil
tclear(hatparts)
killlight(head, "VisualsV2_HatGlow")
end
local function buildhat()
clearhat()
if not vis.hat.enabled or not head or not head.Parent then
return
end
hatfolder = newinst("Folder")
hatfolder.Name = "VisualsV2_ChinaHat"
hatfolder.Parent = character
local color = vis.hat.color
local light = lighten(color, 0.35)
local size = clamp(vis.hat.size or 1, 0.4, 3)
local style = vis.hat.style
if style == "Classic" then
local hat = acquire()
hat.Name = "ChineseHat"
hat.Size = v3(2, 0.2, 2)
hat.Transparency = 0.3
hat.Color = color
hat.Material = matneon
hat.Anchored = false
local mesh = newinst("SpecialMesh")
mesh.MeshId = "rbxassetid://1033714"
mesh.Scale = v3(2.4 * size, 1.6 * size, 2.4 * size)
mesh.Parent = hat
hat.Parent = hatfolder
local basecf = cfnew(0, 1.1 * size, 0)
hatparts[#hatparts + 1] = {
kind = "classic",
weld = weldto(head, hat, basecf),
base = basecf,
part = hat,
shade = 0,
}
if vis.hat.glow then
makelight(head, "VisualsV2_HatGlow", color, 1.8, 11)
end
return
end
local function disc(radius, height, thickness, transparency, shade)
local part = newneon(v3(thickness, radius * 2, radius * 2),
color:Lerp(light, shade))
part.Shape = shapecyl
part.Transparency = transparency or 0.2
part.Parent = hatfolder
local basecf = cfnew(0, height, 0)
hatparts[#hatparts + 1] = {
kind = "disc",
weld = weldto(head, part, basecf * flat90),
base = basecf,
part = part,
shade = shade,
}
end
local function segring(radius, height, segments, thickness, tilt, transparency)
segments = quantity(segments, 6)
local partsize = v3(thickness, thickness, (tau * radius / segments) * 1.08)
local basecf = cfnew(0, height, 0)
local tailcf = cfnew(0, 0, -radius) * turn90
tilt = tilt or 0
for index = 1, segments do
local angle = (index / segments) * tau
local piece = newneon(partsize, color)
piece.Transparency = transparency or 0.1
piece.Parent = hatfolder
hatparts[#hatparts + 1] = {
kind = "seg",
weld = weldto(head, piece, basecf * cfang(tilt, angle, 0) * tailcf),
angle = angle,
tilt = tilt,
base = basecf,
tail = tailcf,
part = piece,
shade = 0,
}
end
end
local function spikes(count, radius, height, length)
count = quantity(count, 4)
local partsize = v3(0.09 * size, 0.09 * size, length)
local basecf = cfnew(0, height, 0)
local tailcf = cfnew(0, 0, -(radius + length * 0.45))
for index = 1, count do
local angle = (index / count) * tau
local piece = newneon(partsize, light)
piece.Transparency = 0.05
piece.Parent = hatfolder
hatparts[#hatparts + 1] = {
kind = "spike",
weld = weldto(head, piece, basecf * cfang(0, angle, 0) * tailcf),
angle = angle,
base = basecf,
tail = tailcf,
part = piece,
shade = 1,
}
end
end
if style == "Cone" then
local steps = quantity(12, 6)
for index = 1, steps do
local ratio = (index - 1) / (steps - 1)
disc((2.5 - ratio * 2.25) * size, (1.75 + ratio * 1.5) * size,
0.14 * size, 0.18, ratio)
end
segring(2.55 * size, 1.72 * size, 26, 0.08 * size, 0, 0)
elseif style == "Rings" then
segring(2.5 * size, 1.8 * size, 26, 0.1 * size, 0, 0)
segring(1.7 * size, 2.25 * size, 20, 0.09 * size, 0, 0.05)
segring(0.9 * size, 2.7 * size, 14, 0.08 * size, 0, 0.1)
disc(0.28 * size, 3.05 * size, 0.5 * size, 0.05, 1)
elseif style == "Spikes" then
for index = 1, 4 do
local ratio = (index - 1) / 3
disc((2.4 - ratio * 1.9) * size, (1.8 + ratio * 1.1) * size,
0.16 * size, 0.2, ratio)
end
spikes(10, 2.45 * size, 1.82 * size, 0.75 * size)
segring(2.5 * size, 1.78 * size, 24, 0.08 * size, 0, 0)
else
for index = 1, 5 do
local ratio = (index - 1) / 4
local radius = (2.6 - ratio * 2) * size
local height = (1.78 + ratio * 1.35) * size
disc(radius, height, 0.18 * size, 0.22, ratio)
segring(radius + 0.03 * size, height, 22 - index * 2, 0.06 * size, 0, 0)
end
disc(0.22 * size, 3.25 * size, 0.42 * size, 0.05, 1)
end
if vis.hat.glow then
makelight(head, "VisualsV2_HatGlow", color, 1.8, 11)
end
end
local function stepanim(dt)
animclock=animclock+dt
local nwing = #wingparts
if nwing > 0 then
flapaccum=flapaccum+dt
if flapaccum >= 0.0333333 then
flapaccum = 0
if vis.wings.flap then
flapreset = false
local phase = animclock * 2.6
for i = 1, nwing do
local item = wingparts[i]
item.weld.C0 = item.origin
* cfang(0, 0, sin(phase + item.phase) * item.amp)
* item.offset
end
elseif not flapreset then
flapreset = true
for i = 1, nwing do
local item = wingparts[i]
item.weld.C0 = item.rest
end
end
end
end
local nhalo = #haloparts
if nhalo > 0 then
local speed = vis.halo.speed
if speed ~= 0 or halohasbob then
local spin = animclock * speed
local bobclock = animclock * 2
for i = 1, nhalo do
local item = haloparts[i]
local bob = item.bob
local angle = item.angle + spin * item.dir
if bob then
item.weld.C0 =
cfnew(0, item.height + sin(bobclock + bob) * 0.08, 0)
* cfang(item.tilt, angle, 0) * item.tail
else
item.weld.C0 = item.base * cfang(item.tilt, angle, 0) * item.tail
end
end
end
end
local nhat = #hatparts
if nhat > 0 then
local rate = vis.hat.spin or 0
if rate ~= 0 then
local spin = animclock * rate
for i = 1, nhat do
local item = hatparts[i]
local kind = item.kind
if kind == "disc" then
item.weld.C0 = item.base * cfang(0, spin, 0) * flat90
elseif kind == "classic" then
item.weld.C0 = item.base * cfang(0, spin, 0)
elseif kind == "spike" then
item.weld.C0 = item.base
* cfang(0, item.angle + spin, 0) * item.tail
else
item.weld.C0 = item.base
* cfang(item.tilt, item.angle + spin, 0) * item.tail
end
end
end
end
end
local function refresh()
local needed = #wingparts > 0 or #haloparts > 0 or #hatparts > 0
if needed and not animrunning then
animrunning = true
addjob(stepanim)
elseif not needed and animrunning then
animrunning = false
removejob(stepanim)
end
end
local function schedule(key, enabled, builder)
if not enabled() or pending[key] then
return
end
pending[key] = true
task.delay(0.15, function()
pending[key] = false
if enabled() then
builder()
end
refresh()
end)
end
local function wingson() return vis.wings.enabled end
local function haloon() return vis.halo.enabled end
local function haton() return vis.hat.enabled end
api.refreshanim = refresh
api.buildall = function()
buildwings()
buildhalo()
buildhat()
refresh()
end
api.clearall = function()
clearwings()
clearhalo()
clearhat()
refresh()
end
visuals.setjump = function(enabled)
vis.jump.enabled = enabled and true or false
end
visuals.setwings = function(enabled)
vis.wings.enabled = enabled and true or false
if vis.wings.enabled then
buildwings()
else
clearwings()
end
refresh()
end
visuals.sethalo = function(enabled)
vis.halo.enabled = enabled and true or false
if vis.halo.enabled then
buildhalo()
else
clearhalo()
end
refresh()
end
visuals.sethat = function(enabled)
vis.hat.enabled = enabled and true or false
if vis.hat.enabled then
buildhat()
else
clearhat()
end
refresh()
end
visuals.rebuildwings = function()
schedule("wings", wingson, buildwings)
end
visuals.rebuildhalo = function()
schedule("halo", haloon, buildhalo)
end
visuals.rebuildhat = function()
schedule("hat", haton, buildhat)
end
visuals.recolorwings = function()
local count = #wingparts
if count == 0 then
return
end
wingbase = vis.wings.color
winglight = lighten(wingbase, 0.4)
for i = 1, count do
local item = wingparts[i]
item.part.Color = wingbase:Lerp(winglight, item.shade)
end
local glow = torso and torso:FindFirstChild("VisualsV2_WingGlow")
if glow then
glow.Color = wingbase
end
end
visuals.recolorhalo = function()
local color = vis.halo.color
for i = 1, #haloparts do
haloparts[i].part.Color = color
end
local glow = head and head:FindFirstChild("VisualsV2_HaloGlow")
if glow then
glow.Color = color
end
end
visuals.recolorhat = function()
local count = #hatparts
if count == 0 then
return
end
local color = vis.hat.color
local light = lighten(color, 0.35)
for i = 1, count do
local item = hatparts[i]
item.part.Color = color:Lerp(light, item.shade)
end
local glow = head and head:FindFirstChild("VisualsV2_HatGlow")
if glow then
glow.Color = color
end
end
end
-- Cosmetic debris has no collisions. Move it locally so external physics cannot
-- relocate an unanchored burst away from its victim after the first frame.
do
local function stepKillMotion(dt)
local gravity=v3(0,-world.Gravity,0)
for part,state in pairs(killMotion) do
if part.Parent~=state.parent or api.ispooled(part) then
killMotion[part]=nil
else
state.offset=state.offset+state.velocity*dt+gravity*(0.5*dt*dt)
state.velocity=state.velocity+gravity*dt
part.CFrame=state.frame+state.offset
end
end
if next(killMotion)==nil then removejob(stepKillMotion) end
end
launchkillpart=function(part)
killMotion[part]={frame=part.CFrame,offset=v3(0,0,0),velocity=part.AssemblyLinearVelocity,parent=part.Parent}
addjob(stepKillMotion)
end
end
cfg.kill = {
enabled = false,
style = "Explosion",
color = rgb(255, 60, 60),
size = 1,
}
visuals.killstyles = { "Explosion", "Shards", "Hearts", "Stars", "Sparkle", "Ghost", "Blood" }
do
local settings = cfg.kill
local effects = {}
effects.Explosion = function(position, color, size, folder)
local base = cfnew(position) * flat90
for ring = 1, 3 do
local part = acquire()
part.Shape = shapecyl
part.Size = v3(0.1, 0.1, 0.1)
part.CFrame = base
part.Anchored = true
part.Material = matneon
part.Color = color
part.Transparency = 0.2
part.Parent = folder
fxcount=fxcount+1
local target = (4 + ring * 2) * size
tweenservice:Create(part, tinfo(0.5 + ring * 0.1, easequint, dirout), {
Size = v3(0.05, target, target),
Transparency = 1,
}):Play()
task.delay(0.8, releasefx, part)
end
end
effects.Shards = function(position, color, size, folder)
local total = floor(12 * size)
local partsize = v3(0.15, 0.6, 0.15) * size
local base = cfnew(position)
local info = tinfo(0.8, easequad, dirin)
for _ = 1, total do
local shard = acquire()
shard.Size = partsize
shard.CFrame = base
shard.Anchored = true
shard.Material = matneon
shard.Color = color
shard.Transparency = 0.1
shard.Parent = folder
shard.AssemblyLinearVelocity =
v3(random(-10, 10), random(8, 18), random(-10, 10)) * size
launchkillpart(shard)
fxcount=fxcount+1
tweenservice:Create(shard, info, { Transparency = 1 }):Play()
task.delay(0.9, releasefx, shard)
end
end
local function billboards(position, color, size, folder, assetid)
local total = floor(8 * size)
local base = cfnew(position)
local rise = v3(0, 4 * size, 0)
local moveinfo = tinfo(1.2, easequad, dirout)
local fadeinfo = tinfo(1.2, easequad, dirin)
local dimension = UDim2.fromOffset(40 * size, 40 * size)
local full = UDim2.fromScale(1, 1)
for _ = 1, total do
local part = acquire()
part.Size = v3(0.1, 0.1, 0.1)
part.CFrame = base
part.Anchored = true
part.Transparency = 1
part.Parent = folder
fxcount=fxcount+1
local billboard = newinst("BillboardGui")
billboard.Size = dimension
billboard.StudsOffset =
v3(random(-3, 3), random(0, 4), random(-3, 3)) * size
billboard.AlwaysOnTop = true
billboard.ResetOnSpawn = false
billboard.Adornee = part
local image = newinst("ImageLabel")
image.Size = full
image.BackgroundTransparency = 1
image.Image = assetid
image.ImageColor3 = color
image.Parent = billboard
billboard.Parent = part
tweenservice:Create(part, moveinfo, { CFrame = base + rise }):Play()
tweenservice:Create(image, fadeinfo, { ImageTransparency = 1 }):Play()
task.delay(1.3, releasefx, part)
end
end
effects.Hearts = function(position, color, size, folder)
billboards(position, color, size, folder, "rbxassetid://11754490336")
end
effects.Stars = function(position, color, size, folder)
billboards(position, color, size, folder, "rbxassetid://11716557686")
end
effects.Sparkle = function(position, color, size, folder)
local total = floor(20 * size)
local partsize = v3(0.2, 0.2, 0.2) * size
local endsize = v3(0.05, 0.05, 0.05)
local info = tinfo(0.7, easequad, dirout)
for _ = 1, total do
local spark = acquire()
spark.Shape = shapeball
spark.Size = partsize
spark.CFrame = cfnew(position
+ v3(random(-2, 2), random(0, 2), random(-2, 2)))
spark.Anchored = true
spark.Material = matneon
spark.Color = color
spark.Transparency = 0
spark.Parent = folder
spark.AssemblyLinearVelocity =
v3(random(-6, 6), random(4, 12), random(-6, 6)) * size
launchkillpart(spark)
fxcount=fxcount+1
tweenservice:Create(spark, info, {
Transparency = 1,
Size = endsize,
}):Play()
task.delay(0.8, releasefx, spark)
end
end
effects.Blood = function(position, color, size, folder)
local bloodcolor = rgb(180, 0, 0)
local darkblood = rgb(100, 0, 0)
local flash = acquire()
flash.Shape = shapeball
flash.Size = v3(0.6, 0.6, 0.6) * size
flash.CFrame = cfnew(position)
flash.Anchored = true
flash.Material = matneon
flash.Color = rgb(220, 0, 0)
flash.Transparency = 0.1
flash.Parent = folder
fxcount=fxcount+1
tweenservice:Create(flash, tinfo(0.18, easequint, dirout), {
Size = v3(2.5, 2.5, 2.5) * size,
Transparency = 1,
}):Play()
task.delay(0.3, releasefx, flash)
local dropcount = floor(28 * size)
local smallsize = v3(0.12, 0.12, 0.12) * size
local endsize = v3(0.04, 0.04, 0.04)
local info = tinfo(0.9, easequad, dirin)
for i = 1, dropcount do
local drop = acquire()
drop.Shape = shapeball
drop.Size = smallsize
drop.CFrame = cfnew(position + v3(
(random() - 0.5) * 0.4,
(random() - 0.5) * 0.4,
(random() - 0.5) * 0.4))
drop.Anchored = true
drop.Material = Enum.Material.SmoothPlastic
drop.Color = random() > 0.4 and bloodcolor or darkblood
drop.Transparency = 0
drop.Parent = folder
drop.AssemblyLinearVelocity = v3(
(random() - 0.5) * 28 * size,
random(4, 18) * size,
(random() - 0.5) * 28 * size)
launchkillpart(drop)
fxcount=fxcount+1
tweenservice:Create(drop, info, {
Transparency = 1,
Size = endsize,
}):Play()
task.delay(1.0, releasefx, drop)
end
local streakcount = floor(10 * size)
local streakinfo = tinfo(0.7, easequad, dirin)
for i = 1, streakcount do
local streak = acquire()
streak.Size = v3(0.08, 0.08, 0.5 * size)
streak.CFrame = cfnew(position) * cfang(
rad(random(-60, 60)),
(i / streakcount) * tau,
0)
streak.Anchored = true
streak.Material = Enum.Material.SmoothPlastic
streak.Color = bloodcolor
streak.Transparency = 0.1
streak.Parent = folder
streak.AssemblyLinearVelocity = v3(
(random() - 0.5) * 22 * size,
random(2, 14) * size,
(random() - 0.5) * 22 * size)
launchkillpart(streak)
fxcount=fxcount+1
tweenservice:Create(streak, streakinfo, {
Transparency = 1,
Size = v3(0.02, 0.02, 0.1),
}):Play()
task.delay(0.8, releasefx, streak)
end
local pool = acquire()
pool.Shape = shapecyl
pool.Size = v3(0.08, 0.3, 0.3)
local ground = groundat(position, 8)
pool.CFrame = cfnew(ground and ground + v3(0, 0.05, 0) or position - v3(0, 2.5, 0)) * flat90
pool.Anchored = true
pool.Material = Enum.Material.SmoothPlastic
pool.Color = darkblood
pool.Transparency = 0.15
pool.Parent = folder
fxcount=fxcount+1
tweenservice:Create(pool, tinfo(1.8, easequint, dirout), {
Size = v3(0.04, 3.5 * size, 3.5 * size),
Transparency = 0.35,
}):Play()
task.delay(4.5, function()
tweenservice:Create(pool, tinfo(1.2, easequad, dirout), {
Transparency = 1,
}):Play()
task.delay(1.3, releasefx, pool)
end)
end
effects.Ghost = function(position, color, size, folder)
local ghost = acquire()
ghost.Shape = shapeball
ghost.Size = v3(2, 2, 2) * size
ghost.CFrame = cfnew(position)
ghost.Anchored = true
ghost.Material = matneon
ghost.Color = color
ghost.Transparency = 0.4
ghost.Parent = folder
fxcount=fxcount+1
tweenservice:Create(ghost, tinfo(1.5, Enum.EasingStyle.Sine, dirout), {
Size = v3(6, 6, 6) * size,
Transparency = 1,
CFrame = ghost.CFrame + v3(0, 5 * size, 0),
}):Play()
task.delay(1.6, releasefx, ghost)
end
local function auracolors(name)
local palette = visuals.aurapalettes and visuals.aurapalettes[name]
if palette then
return palette[1], palette[2]
end
return settings.color, lighten(settings.color, 0.5)
end
local function both(first, second)
return function(position, _, size, folder)
local name = settings.style
local main, light = auracolors(name)
first(position, main, size, folder)
second(position, light, size, folder)
end
end
effects.Godly = both(effects.Explosion, effects.Sparkle)
effects["Super Saiyan"] = both(effects.Shards, effects.Explosion)
effects["North Star"] = both(effects.Stars, effects.Sparkle)
effects["Blue Lord"] = both(effects.Explosion, effects.Shards)
effects["Pink Aura"] = both(effects.Sparkle, effects.Explosion)
effects["Angel Wing"] = both(effects.Ghost, effects.Sparkle)
effects["Sweet Heart"] = both(effects.Hearts, effects.Explosion)
effects.Ethereal = both(effects.Ghost, effects.Sparkle)
for _, name in ipairs({ "Godly", "Super Saiyan", "North Star", "Blue Lord", "Pink Aura", "Angel Wing", "Sweet Heart", "Ethereal" }) do
visuals.killstyles[#visuals.killstyles + 1] = name
end
local conns = {}
local watched = setmetatable({}, { __mode = "k" })
local watching = false
local watchGeneration = 0
local function spawnkill(position)
if fxcount > maxfx then
return
end
local handler = effects[settings.style]
if handler then
handler(position, settings.color, settings.size, getfolder())
end
end
local function bodyPosition(char)
for _, name in ipairs({"HumanoidRootPart", "UpperTorso", "Torso", "Head"}) do
local part = char:FindFirstChild(name)
if part and part:IsA("BasePart") then return part.Position end
end
end
local function capturePosition(char, record)
if record.humanoid.Health > 0 and char.Parent then
local position = bodyPosition(char)
if position then record.position = position end
end
end
local function emitDeath(char, record, generation)
if not settings.enabled or not watching or generation ~= watchGeneration
or watched[char] ~= record or record.fired or char == lp.Character then return end
record.fired = true
-- The game can move/remove the dying root before Died listeners run. Keep the
-- last living victim position; never substitute the shooter's root or world origin.
local position = record.position or bodyPosition(char)
if position then spawnkill(position) end
end
local function watchcharacter(char, owner, generation)
if not watching or generation ~= watchGeneration or not char or watched[char] or char == lp.Character then
return
end
local human = char:FindFirstChildOfClass("Humanoid")
or char:WaitForChild("Humanoid", 5)
if not human or not watching or generation ~= watchGeneration
or (owner and owner.Character ~= char) or char == lp.Character then return end
local record = {humanoid = human, fired = false}
watched[char] = record
capturePosition(char, record)
record.connection = human.Died:Connect(function()
emitDeath(char, record, generation)
end)
conns[#conns + 1] = record.connection
end
local function hookplayer(player, generation)
if player == lp then return end
if player.Character then task.spawn(watchcharacter, player.Character, player, generation) end
conns[#conns + 1] = player.CharacterAdded:Connect(function(char)
task.spawn(watchcharacter, char, player, generation)
end)
conns[#conns + 1] = player.CharacterRemoving:Connect(function(char)
local record = watched[char]
if record then
-- Round cleanup may remove a dead character before a deferred Died callback.
-- A living character replacement is not a death and must not create an effect.
if record.humanoid.Health <= 0 then emitDeath(char, record, generation) end
watched[char] = nil
if record.connection then record.connection:Disconnect() end
end
end)
end
api.setkillfx = function(enabled)
settings.enabled = enabled and true or false
if settings.enabled then
if watching then return end
watching = true
watchGeneration = watchGeneration + 1
local generation = watchGeneration
-- One shared sampler while the feature is enabled; no per-character frame loops.
conns[#conns + 1] = runservice.Heartbeat:Connect(function()
if not watching or generation ~= watchGeneration then return end
for char, record in pairs(watched) do capturePosition(char, record) end
end)
for _, player in players:GetPlayers() do hookplayer(player, generation) end
conns[#conns + 1] = players.PlayerAdded:Connect(function(player) hookplayer(player, generation) end)
conns[#conns + 1] = players.PlayerRemoving:Connect(function(player)
local char = player.Character
local record = char and watched[char]
if record then
watched[char] = nil
if record.connection then record.connection:Disconnect() end
end
end)
else
if not watching then return end
watching = false
watchGeneration = watchGeneration + 1
for i = 1, #conns do
local conn = conns[i]
if conn then conn:Disconnect() end
end
tclear(conns)
tclear(watched)
end
end
end
cfg.foot = {
enabled = false,
color = rgb(0, 255, 255),
lifetime = 2,
stepdistance = 3,
footoffset = 0.7,
mode = "Fade",
}
visuals.footmodes = { "Fade", "Dissolve", "Float Up", "Shrink" }
do
local settings = cfg.foot
local lastpos
local leftfoot = true
local dissolving = {}
local dissolveaccum = 0
local dissolverunning = false
local freefall = Enum.HumanoidStateType.Freefall
local easeback = Enum.EasingStyle.Back
local stepdissolve
local stepfoot
stepdissolve = function(dt)
dissolveaccum=dissolveaccum+dt
if dissolveaccum < 0.05 then
return
end
local delta = dissolveaccum
dissolveaccum = 0
local count = #dissolving
local write = 0
for i = 1, count do
local entry = dissolving[i]
entry.clock=entry.clock+delta
local progress = entry.clock / entry.life
local part = entry.part
if progress >= 1 or not part.Parent then
releasefx(part)
else
part.Size = entry.size * (1 - progress)
part.Position = entry.origin + v3(
(random() - 0.5) * progress * 0.5, 0,
(random() - 0.5) * progress * 0.5)
part.Transparency = 0.2 + progress * 0.8
local light = entry.light
if light and light.Parent then
light.Brightness = mmax(0, 1.5 * (1 - progress))
end
write=write+1
dissolving[write] = entry
end
end
for i = count, write + 1, -1 do
dissolving[i] = nil
end
if write == 0 and dissolverunning then
dissolverunning = false
removejob(stepdissolve)
end
end
local FOOT_AURA = {
Godly = { "Star", rgb(255, 214, 90) },
["Super Saiyan"] = { "Spark", rgb(255, 226, 60) },
["North Star"] = { "Star", rgb(170, 225, 255) },
["Blue Lord"] = { "Orb", rgb(40, 90, 255) },
["Pink Aura"] = { "Orb", rgb(255, 105, 200) },
["Angel Wing"] = { "Feather", rgb(255, 255, 255) },
["Sweet Heart"] = { "Heart", rgb(255, 70, 130) },
Ethereal = { "Orb", rgb(170, 120, 255) },
}
visuals.footstyles = { "Classic", "Orb", "Heart", "Star", "Spark", "Feather" }
for _, name in ipairs({ "Godly", "Super Saiyan", "North Star", "Blue Lord", "Pink Aura", "Angel Wing", "Sweet Heart", "Ethereal" }) do
visuals.footstyles[#visuals.footstyles + 1] = name
end
settings.style = settings.style or "Classic"
local function piece(base, size, offset, color, ball)
local part = acquire()
part.Name = "VisualsV2_Footprint"
if ball then
part.Shape = shapecyl
part.Size = v3(0.1, size.X, size.Z)
part.CFrame = base * offset * flat90
else
part.Size = size
part.CFrame = base * offset
end
part.Anchored = true
part.Material = matneon
part.Color = color
part.Transparency = 0.2
part.Parent = getfolder()
fxcount=fxcount+1
return part
end
local function shape(name, base, color)
if name == "Orb" then
return { piece(base, v3(0.8, 0.1, 0.8), cfnew(), color, true) }
elseif name == "Heart" then
return {
piece(base, v3(0.42, 0.1, 0.42), cfnew(-0.15, 0, -0.12), color, true),
piece(base, v3(0.42, 0.1, 0.42), cfnew(0.15, 0, -0.12), color, true),
piece(base, v3(0.42, 0.1, 0.42), cfnew(0, 0, 0.06) * cfang(0, rad(45), 0), color),
}
elseif name == "Star" or name == "Spark" then
local list = {}
local rays = name == "Star" and 5 or 4
for index = 1, rays do
list[index] = piece(base, v3(0.14, 0.1, name == "Star" and 0.5 or 0.75),
cfang(0, (index / rays) * tau, 0) * cfnew(0, 0, -0.18), color)
end
return list
elseif name == "Feather" then
return {
piece(base, v3(0.08, 0.1, 1), cfnew(), color),
piece(base, v3(0.36, 0.1, 0.55), cfnew(-0.16, 0, 0.05) * cfang(0, rad(-12), 0), color),
piece(base, v3(0.36, 0.1, 0.55), cfnew(0.16, 0, 0.05) * cfang(0, rad(12), 0), color),
}
end
return { piece(base, v3(0.6, 0.1, 1), cfnew(), color) }
end
local function create(position, look)
if fxcount > maxfx then
return
end
local preset = FOOT_AURA[settings.style]
local color = preset and preset[2] or settings.color
local base = CFrame.lookAt(position, position + look) + v3(0, 0.06, 0)
local parts = shape(preset and preset[1] or settings.style, base, color)
local light = newinst("PointLight")
light.Color = color
light.Range = 4
light.Brightness = 1.5
light.Shadows = false
light.Parent = parts[1]
local life = settings.lifetime
local mode = settings.mode
if mode == "Dissolve" then
for index, part in ipairs(parts) do
dissolving[#dissolving + 1] = {
part = part,
light = index == 1 and light or nil,
size = part.Size,
origin = part.Position,
clock = 0,
life = life,
}
end
if not dissolverunning then
dissolverunning = true
addjob(stepdissolve)
end
return
end
for _, part in ipairs(parts) do
if mode == "Float Up" then
tweenservice:Create(part, tinfo(life, easequad, dirout), {
CFrame = part.CFrame + v3(0, 4, 0),
Transparency = 1,
}):Play()
elseif mode == "Shrink" then
tweenservice:Create(part, tinfo(life, easeback, dirin), {
Size = v3(0.01, 0.01, 0.01),
Transparency = 1,
}):Play()
else
tweenservice:Create(part, tinfo(life, easequad, dirout), {
Transparency = 1,
}):Play()
end
task.delay(life + 0.1, releasefx, part)
end
tweenservice:Create(light, tinfo(life, easequad, dirout), {
Brightness = 0,
}):Play()
end
stepfoot = function()
local hum = humanoid
local hrp = root
if not hum or not hrp or not hrp.Parent then
return
end
local position = hrp.Position
if not lastpos then
lastpos = position
return
end
if hum.MoveDirection.Magnitude <= 0 or hum:GetState() == freefall then
lastpos = position
return
end
local dx = position.X - lastpos.X
local dy = position.Y - lastpos.Y
local dz = position.Z - lastpos.Z
local threshold = settings.stepdistance
if dx * dx + dy * dy + dz * dz >= threshold * threshold then
local frame = hrp.CFrame
local offset = settings.footoffset
local look = v3(frame.LookVector.X, 0, frame.LookVector.Z)
local foot = groundat(position + frame.RightVector * (leftfoot and -offset or offset), 7)
if foot and look.Magnitude > 0.01 then
create(foot, look.Unit)
end
leftfoot = not leftfoot
lastpos = position
end
end
api.footreset = function()
lastpos = nil
end
api.setfootprints = function(enabled)
settings.enabled = enabled == true
if settings.enabled then
lastpos = nil
addjob(stepfoot)
else
removejob(stepfoot)
end
end
end
local advfx = {
orbit = {
enabled = false,
color = rgb(180, 120, 255),
count = 5,
radius = 3.2,
speed = 1.8,
size = 0.22,
},
impact = {
enabled = false,
color = rgb(255, 210, 100),
size = 8,
duration = 0.55,
},
pulse = {
enabled = false,
color = rgb(100, 220, 255),
interval = 1.4,
size = 6,
},
outline = {
enabled = false,
color = rgb(120, 200, 255),
fill = 1,
edge = 0,
},
fov = {
enabled = false,
base = 70,
boost = 10,
smoothness = 8,
},
}
cfg.advanced = advfx
do
local settings = advfx.orbit
local orbs = {}
local frames = {}
local clock = 0
local built = 0
local dirty = true
local steporbit
local function clear()
for i = 1, #orbs do
local orb = orbs[i]
if orb then
orb:Destroy()
end
end
tclear(orbs)
tclear(frames)
built = 0
end
local function build(count)
clear()
local size = v3(settings.size, settings.size, settings.size)
local folder = getadvfolder()
local origin = cfnew(0, 0, 0)
for i = 1, count do
local orb = newinst("Part")
orb.Name = "VisualsV2_Orb"
orb.Shape = shapeball
orb.Size = size
orb.Anchored = true
orb.CanCollide = false
orb.CanQuery = false
orb.CanTouch = false
orb.CastShadow = false
orb.Locked = true
orb.Material = matneon
orb.Color = settings.color
orb.Transparency = 0.05
orb.Parent = folder
local light = newinst("PointLight")
light.Color = settings.color
light.Range = mmax(3, settings.size * 12)
light.Brightness = 1.5
light.Shadows = false
light.Parent = orb
orbs[i] = orb
frames[i] = origin
end
built = count
dirty = false
end
steporbit = function(dt)
local hrp = root
if not hrp or not hrp.Parent then
return
end
local count = clamp(floor(settings.count), 1, 12)
if count ~= built or dirty then
build(count)
end
clock=clock+(dt * settings.speed)
local position = hrp.Position
local px = position.X
local py = position.Y + 1.5
local pz = position.Z
local radius = settings.radius
local bobclock = clock * 2
for i = 1, count do
local angle = clock + ((i - 1) / count) * tau
frames[i] = cfnew(
px + cos(angle) * radius,
py + sin(bobclock + i) * 0.35,
pz + sin(angle) * radius)
end
moveparts(orbs, frames)
end
api.orbitdirty = function()
dirty = true
end
api.orbitrecolor = function(color)
for i = 1, #orbs do
local orb = orbs[i]
orb.Color = color
local light = orb:FindFirstChildOfClass("PointLight")
if light then
light.Color = color
end
end
end
api.clearorbs = clear
api.setorbit = function(enabled)
settings.enabled = enabled == true
if settings.enabled then
dirty = true
addjob(steporbit)
else
removejob(steporbit)
clear()
end
end
end
do
local impact = advfx.impact
local pulse = advfx.pulse
local clock = 0
local steppulse
api.onlanded = function()
if not impact.enabled or not root or fxcount > maxfx then
return
end
local ring = acquire()
ring.Name = "VisualsV2_Impact"
ring.Shape = shapecyl
ring.Size = v3(0.12, 1, 1)
local ground = groundat(root.Position, 8)
ring.CFrame = cfnew(ground and ground + v3(0, 0.07, 0) or root.Position - v3(0, 2.6, 0)) * flat90
ring.Anchored = true
ring.Material = matneon
ring.Color = impact.color
ring.Transparency = 0.15
ring.Parent = getadvfolder()
fxcount=fxcount+1
local light = newinst("PointLight")
light.Color = impact.color
light.Range = 8
light.Brightness = 2
light.Shadows = false
light.Parent = ring
local duration = impact.duration
tweenservice:Create(ring, tinfo(duration, easequint, dirout), {
Size = v3(0.12, impact.size, impact.size),
Transparency = 1,
}):Play()
tweenservice:Create(light, tinfo(duration, easequad, dirout), {
Brightness = 0,
}):Play()
task.delay(duration + 0.1, releasefx, ring)
end
steppulse = function(dt)
clock=clock+dt
if clock < mmax(0.2, pulse.interval) then
return
end
clock = 0
if not root or fxcount > maxfx then
return
end
local orb = acquire()
orb.Name = "VisualsV2_Pulse"
orb.Shape = shapeball
orb.Size = v3(0.5, 0.5, 0.5)
orb.CFrame = cfnew(root.Position)
orb.Anchored = true
orb.Material = matneon
orb.Color = pulse.color
orb.Transparency = 0.25
orb.Parent = getadvfolder()
fxcount=fxcount+1
tweenservice:Create(orb, tinfo(0.75, Enum.EasingStyle.Quart, dirout), {
Size = v3(pulse.size, pulse.size, pulse.size),
Transparency = 1,
}):Play()
task.delay(0.85, releasefx, orb)
end
api.setpulse = function(enabled)
pulse.enabled = enabled == true
if pulse.enabled then
clock = 0
addjob(steppulse)
else
removejob(steppulse)
end
end
end
do
local settings = advfx.outline
local highlight
local depthtop = Enum.HighlightDepthMode.AlwaysOnTop
api.setoutline = function(enabled)
settings.enabled = enabled == true
if highlight then
highlight:Destroy()
highlight = nil
end
if not settings.enabled then
return
end
local char = lp.Character
if not char then
return
end
highlight = newinst("Highlight")
highlight.Name = "VisualsV2_Outline"
highlight.Adornee = char
highlight.DepthMode = depthtop
highlight.FillColor = settings.color
highlight.OutlineColor = settings.color
highlight.FillTransparency = settings.fill
highlight.OutlineTransparency = settings.edge
highlight.Parent = char
end
api.updateoutline = function()
if not settings.enabled then
return
end
if not highlight or not highlight.Parent then
api.setoutline(true)
return
end
highlight.FillColor = settings.color
highlight.OutlineColor = settings.color
highlight.FillTransparency = settings.fill
highlight.OutlineTransparency = settings.edge
end
end
do
local settings = advfx.fov
local function stepfov(dt)
local camera = cam
local hum = humanoid
if not camera or not hum then
return
end
local current = camera.FieldOfView
local diff = settings.base + hum.MoveDirection.Magnitude * settings.boost - current
if diff > -0.01 and diff < 0.01 then
return
end
camera.FieldOfView = current + diff * clamp(dt * settings.smoothness, 0, 1)
end
api.setfov = function(enabled)
settings.enabled = enabled == true
if settings.enabled then
addjob(stepfov)
else
removejob(stepfov)
end
end
end
local function bindcharacter(char)
character = char
humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10)
local rig = humanoid and humanoid.RigType
if rig == Enum.HumanoidRigType.R6 then
torso = char:FindFirstChild("Torso") or char:WaitForChild("Torso", 3)
else
torso = char:FindFirstChild("UpperTorso") or char:WaitForChild("UpperTorso", 3)
end
root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
torso = torso or root
head = char:FindFirstChild("Head") or char:WaitForChild("Head", 3) or torso
tclear(wingparts)
tclear(haloparts)
tclear(hatparts)
if jumpconn then
jumpconn:Disconnect()
jumpconn = nil
end
if stateconn then
stateconn:Disconnect()
stateconn = nil
end
if humanoid then
local landed = Enum.HumanoidStateType.Landed
jumpconn = humanoid.Jumping:Connect(function(active)
if active then
api.playjump()
end
end)
stateconn = humanoid.StateChanged:Connect(function(_, newstate)
if newstate == landed then
api.onlanded()
end
end)
end
api.buildall()
end
fxConnections[#fxConnections+1]=lp.CharacterAdded:Connect(function(char)
task.wait(0.35)
if not runtimeAlive or lp.Character~=char then return end
bindcharacter(char)
if cfg.foot.enabled then api.footreset() end
if advfx.outline.enabled then api.setoutline(true) end
if advfx.orbit.enabled then api.orbitdirty() end
end)
fxConnections[#fxConnections+1]=lp.CharacterRemoving:Connect(function()
humanoid=nil
root=nil
api.footreset()
end)
if lp.Character then task.spawn(bindcharacter,lp.Character) end
do
local setfov=api.setfov
local savedFov=nil
api.setfov=function(enabled)
if enabled and not advfx.fov.enabled then
local camera=world.CurrentCamera
savedFov=camera and camera.FieldOfView or nil
end
setfov(enabled)
if not enabled and savedFov then
local camera=world.CurrentCamera
if camera then pcall(function() camera.FieldOfView=savedFov end) end
savedFov=nil
end
end
end
local othersOutline={enabled=false,highlights={},connections={}}
local function outlineOther(plr)
local old=othersOutline.highlights[plr]
if old then pcall(function() old:Destroy() end);othersOutline.highlights[plr]=nil end
local char=othersOutline.enabled and plr.Character
if not char then return end
local outline=advfx.outline
local highlight=newinst("Highlight")
highlight.Name="VisualsV2_OutlineOther"
highlight.Adornee=char
highlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
highlight.FillColor=outline.color
highlight.OutlineColor=outline.color
highlight.FillTransparency=outline.fill
highlight.OutlineTransparency=outline.edge
highlight.Parent=char
othersOutline.highlights[plr]=highlight
end
local function recolorOthers()
for _,highlight in pairs(othersOutline.highlights) do
pcall(function()
highlight.FillColor=advfx.outline.color
highlight.OutlineColor=advfx.outline.color
end)
end
end
local function setOutlineOthers(enabled)
othersOutline.enabled=enabled==true
for _,connection in ipairs(othersOutline.connections) do connection:Disconnect() end
table.clear(othersOutline.connections)
for _,highlight in pairs(othersOutline.highlights) do pcall(function() highlight:Destroy() end) end
table.clear(othersOutline.highlights)
if not othersOutline.enabled then return end
local connections=othersOutline.connections
local function watch(plr)
if plr==lp then return end
connections[#connections+1]=plr.CharacterAdded:Connect(function()
task.wait(0.2)
if othersOutline.enabled and runtimeAlive then outlineOther(plr) end
end)
outlineOther(plr)
end
for _,plr in ipairs(players:GetPlayers()) do watch(plr) end
connections[#connections+1]=players.PlayerAdded:Connect(watch)
connections[#connections+1]=players.PlayerRemoving:Connect(function(plr)
local highlight=othersOutline.highlights[plr]
if highlight then pcall(function() highlight:Destroy() end) end
othersOutline.highlights[plr]=nil
end)
end
local controls={}
local function toggle(section,name,key,startsOn,callback)
if startsOn then defaultOnControls[key]=true end
local controller=addToggle(section,name,C(key,startsOn==true)==true,function(value)
SetCfg(key,value);callback(value)
end)
controls[#controls+1]=controller
return controller
end
local function slider(section,name,key,min,max,default,callback)
local value=math.clamp(tonumber(C(key,default)) or default,min,max)
callback(value)
section:AddSlider(name,min,max,value,function(new)
new=math.clamp(tonumber(new) or default,min,max)
SetCfg(key,new);callback(new)
end)
end
local function pick(section,name,key,list,default,callback)
local value=C(key,default)
if not table.find(list,value) then value=default end
callback(value)
addDropdown(section,name,list,value,function(new)
if type(new)=="table" then new=new[1] end
if not table.find(list,new) then return false end
SetCfg(key,new);callback(new)
end)
end
local function color(section,name,key,default,callback)
local value=C(key,default)
if typeof(value)~="Color3" then value=default end
callback(value)
section:AddColorpicker(name,value,function(new)
SetCfg(key,new);callback(new)
end)
end
local jumpSection=jumpCirclesSection or mainTab:AddSection("Jump Effects","Cosmetic")
jumpSection:AddLabel("Jump Effects")
toggle(jumpSection,"Enable Jump Effects","vv2fxJump",false,function(value) visuals.setjump(value) end)
pick(jumpSection,"Jump Effect Style","vv2fxJumpStyle",visuals.jumpstyles,"Swirl",function(value) vis.jump.style=value end)
color(jumpSection,"Jump Effect Color","vv2fxJumpColor",vis.jump.color,function(value) vis.jump.color=value end)
slider(jumpSection,"Jump Effect Size","vv2fxJumpSize",3,20,7,function(value) vis.jump.size=value end)
slider(jumpSection,"Jump Effect Duration x10","vv2fxJumpDuration",3,20,7,function(value) vis.jump.duration=value/10 end)
toggle(jumpSection,"Jump Ground Flash","vv2fxJumpFlash",true,function(value) vis.jump.flash=value end)
toggle(jumpSection,"Jump Sparks","vv2fxJumpSparks",true,function(value) vis.jump.sparks=value end)
toggle(jumpSection,"Landing Impact","vv2fxImpact",false,function(value) advfx.impact.enabled=value end)
color(jumpSection,"Landing Impact Color","vv2fxImpactColor",advfx.impact.color,function(value) advfx.impact.color=value end)
slider(jumpSection,"Landing Impact Size","vv2fxImpactSize",3,20,8,function(value) advfx.impact.size=value end)
local footSection=mainTab:AddSection("Footprints","Cosmetic")
toggle(footSection,"Enable Footprints","vv2fxFoot",false,function(value) api.setfootprints(value) end)
pick(footSection,"Footprint Style","vv2fxFootStyle",visuals.footstyles,"Classic",function(value) cfg.foot.style=value end)
pick(footSection,"Footprint Mode","vv2fxFootMode",visuals.footmodes,"Fade",function(value) cfg.foot.mode=value end)
color(footSection,"Footprint Color","vv2fxFootColor",cfg.foot.color,function(value) cfg.foot.color=value end)
slider(footSection,"Footprint Lifetime x10","vv2fxFootLife",5,50,20,function(value) cfg.foot.lifetime=value/10 end)
slider(footSection,"Step Distance x10","vv2fxFootStep",10,60,30,function(value) cfg.foot.stepdistance=value/10 end)
slider(footSection,"Foot Offset x10","vv2fxFootOffset",0,15,7,function(value) cfg.foot.footoffset=value/10 end)
local killSection=mainTab:AddSection("Kill Effects","Cosmetic")
toggle(killSection,"Enable Kill Effects","vv2fxKill",false,function(value) api.setkillfx(value) end)
pick(killSection,"Kill Effect Style","vv2fxKillStyle",visuals.killstyles,"Blood",function(value) cfg.kill.style=value end)
color(killSection,"Kill Effect Color","vv2fxKillColor",cfg.kill.color,function(value) cfg.kill.color=value end)
slider(killSection,"Kill Effect Size x10","vv2fxKillSize",5,30,10,function(value) cfg.kill.size=value/10 end)
killSection:AddParagraph("Kill Effects","Blood and the aura styles (Godly to Ethereal) keep their own colours; every other style takes the colour above.")
local advancedSection=mainTab:AddSection("Advanced FX","Cosmetic")
toggle(advancedSection,"Orbit Energy","vv2fxOrbit",false,function(value) api.setorbit(value) end)
color(advancedSection,"Orbit Color","vv2fxOrbitColor",advfx.orbit.color,function(value) advfx.orbit.color=value;api.orbitrecolor(value) end)
slider(advancedSection,"Orbit Count","vv2fxOrbitCount",1,12,5,function(value) advfx.orbit.count=value end)
slider(advancedSection,"Orbit Radius x10","vv2fxOrbitRadius",10,80,32,function(value) advfx.orbit.radius=value/10 end)
slider(advancedSection,"Orbit Speed x10","vv2fxOrbitSpeed",1,50,18,function(value) advfx.orbit.speed=value/10 end)
toggle(advancedSection,"Player Outline","vv2fxOutline",false,function(value) api.setoutline(value) end)
toggle(advancedSection,"Outline Others","vv2fxOutlineOthers",false,function(value) setOutlineOthers(value) end)
color(advancedSection,"Outline Color","vv2fxOutlineColor",advfx.outline.color,function(value) advfx.outline.color=value;api.updateoutline();recolorOthers() end)
toggle(advancedSection,"Dynamic FOV","vv2fxFov",false,function(value) api.setfov(value) end)
slider(advancedSection,"Base FOV","vv2fxFovBase",50,100,70,function(value) advfx.fov.base=value end)
slider(advancedSection,"FOV Boost","vv2fxFovBoost",0,25,10,function(value) advfx.fov.boost=value end)
env.VisualsV2Runtime.RegisterReset(function()
for _,controller in ipairs(controls) do pcall(function() controller:Set(false) end) end
visuals.setjump(false);visuals.setwings(false);visuals.sethalo(false)
advfx.impact.enabled=false
for _,off in ipairs({api.setkillfx,api.setfootprints,api.setorbit,api.setpulse,api.setoutline,api.setfov,setOutlineOthers}) do
pcall(off,false)
end
if runtimeAlive then return end
api.clearall()
for _,connection in ipairs(fxConnections) do pcall(function() connection:Disconnect() end) end
table.clear(fxConnections)
if jumpconn then jumpconn:Disconnect();jumpconn=nil end
if stateconn then stateconn:Disconnect();stateconn=nil end
if hbconn then hbconn:Disconnect();hbconn=nil end
table.clear(killMotion)
if fxfolder then fxfolder:Destroy();fxfolder=nil end
if advfolder then advfolder:Destroy();advfolder=nil end
end)
end,"Section \"Visual Effects\"")
local characterSection,headlessEnabled,characterOriginal,applyCharacterVisuals,headlessToggle,KorbloxSystem
;vv2Section(function()
characterSection = mainTab:AddSection("Character", "Cosmetic")
headlessEnabled = C("headlessEnabled", false)
characterOriginal = setmetatable({}, {__mode = "k"})
characterSection:AddParagraph(
"Character Appearance",
"Headless and Korblox are client sided. Korblox works for R15 only."
)
local function rememberCharacterObject(obj)
if not obj or characterOriginal[obj] then return end
if obj:IsA("BasePart") then
characterOriginal[obj] = {
Transparency = obj.Transparency,
LocalTransparencyModifier = obj.LocalTransparencyModifier,
}
elseif obj:IsA("Decal") then
characterOriginal[obj] = {Transparency = obj.Transparency}
end
end
local function restoreCharacterObject(obj)
local data = characterOriginal[obj]
if not obj or not data then return end
if obj:IsA("BasePart") then
pcall(function() obj.Transparency = data.Transparency end)
pcall(function() obj.LocalTransparencyModifier = data.LocalTransparencyModifier end)
elseif obj:IsA("Decal") then
pcall(function() obj.Transparency = data.Transparency end)
end
end
function applyCharacterVisuals()
local char = player.Character
if not char then return end
local head = char:FindFirstChild("Head")
if head then
rememberCharacterObject(head)
if headlessEnabled then
head.Transparency = 1
head.LocalTransparencyModifier = 1
else
restoreCharacterObject(head)
end
for _, obj in ipairs(head:GetChildren()) do
if obj:IsA("Decal") then
rememberCharacterObject(obj)
if headlessEnabled then
obj.Transparency = 1
else
restoreCharacterObject(obj)
end
end
end
end
end
headlessToggle = addToggle(characterSection, "Headless", headlessEnabled, function(state)
headlessEnabled = state
SetCfg("headlessEnabled", state)
applyCharacterVisuals()
end)
KorbloxSystem={
RightEnabled=C("korbloxEnabled",false),
LeftEnabled=C("korbloxLeftEnabled",false),
RightToggle=nil,
LeftToggle=nil,
}
end,"Section \"Character\"")
;vv2Section(function()
local PlayersService=game:GetService("Players")
local RIGHT_ASSET=139607718
local LEFT_ASSET=139607673
local KORBLOX_MARKER="VisualsV2KorbloxSide"
local SIDE_NAMES={
Right={"RightUpperLeg","RightLowerLeg","RightFoot"},
Left={"LeftUpperLeg","LeftLowerLeg","LeftFoot"},
}
local SIDE_ENUMS={
Right={
Enum.BodyPartR15.RightUpperLeg,
Enum.BodyPartR15.RightLowerLeg,
Enum.BodyPartR15.RightFoot,
},
Left={
Enum.BodyPartR15.LeftUpperLeg,
Enum.BodyPartR15.LeftLowerLeg,
Enum.BodyPartR15.LeftFoot,
},
}
local currentState=nil
local stateGeneration=0
local templateParts=nil
local templateBuilding=false
local templateBuildGeneration=0
local function sideEnabled(side)
if side=="Right" then return KorbloxSystem.RightEnabled end
return KorbloxSystem.LeftEnabled
end
local function disconnect(connection)
if connection then
pcall(function() connection:Disconnect() end)
end
end
local function destroyMotorChildren(root)
if not root then return end
for _,obj in ipairs(root:GetDescendants()) do
if obj:IsA("Motor6D") then
pcall(function() obj:Destroy() end)
end
end
end
local function cloneBodyPart(part)
if not part or not part:IsA("BasePart") then return nil end
local originalArchivable=part.Archivable
if not originalArchivable then
pcall(function() part.Archivable=true end)
end
local ok,clone=pcall(function()
return part:Clone()
end)
if not originalArchivable then
pcall(function() part.Archivable=false end)
end
if not ok or not clone then return nil end
destroyMotorChildren(clone)
clone.Parent=nil
return clone
end
local function clearStateConnections(state)
if not state then return end
for _,connection in ipairs(state.Connections or {}) do
disconnect(connection)
end
state.Connections={}
for _,side in ipairs({"Left","Right"}) do
for _,connection in ipairs((state.PartConnections and state.PartConnections[side]) or {}) do
disconnect(connection)
end
if state.PartConnections then state.PartConnections[side]={} end
end
end
local function getHumanoid(char)
if not char then return nil end
return char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid",2)
end
local function getSideParts(char,side)
local names=SIDE_NAMES[side]
if not char or not names then return nil end
local parts={}
for index,name in ipairs(names) do
local part=char:FindFirstChild(name)
if not part or not part:IsA("BasePart") then
return nil
end
parts[index]=part
end
return parts
end
local function waitForSideParts(char,side,timeout)
local deadline=os.clock()+(timeout or 2.5)
repeat
if player.Character~=char then return nil end
local parts=getSideParts(char,side)
if parts then return parts end
task.wait(0.05)
until os.clock()>=deadline
return getSideParts(char,side)
end
local function captureBaselineDescription(state)
if not state or not state.Humanoid then return end
local ok,desc=pcall(function()
return state.Humanoid:GetAppliedDescription()
end)
if ok and desc then
state.BaselineDescription=desc
state.BaselineLegIds={
Left=desc.LeftLeg,
Right=desc.RightLeg,
}
end
end
local function beginCharacterState(char)
if currentState and currentState.Character==char then
return currentState
end
stateGeneration=stateGeneration+1
clearStateConnections(currentState)
local humanoid=getHumanoid(char)
currentState={
Character=char,
Humanoid=humanoid,
Generation=stateGeneration,
Connections={},
PartConnections={Left={},Right={}},
Originals={Left={},Right={}},
RepairTokens={Left=0,Right=0},
Applying={Left=false,Right=false},
SuppressAppearanceUntil=0,
BaselineDescription=nil,
BaselineLegIds={Left=0,Right=0},
}
captureBaselineDescription(currentState)
return currentState
end
local function captureOriginalPart(state,side,index,part,overwrite)
if not state or not part or not part:IsA("BasePart") then return end
local marked=part:GetAttribute(KORBLOX_MARKER)
if marked==side then return end
if state.Originals[side][index] and not overwrite then return end
local clone=cloneBodyPart(part)
if clone then
clone:SetAttribute(KORBLOX_MARKER,nil)
state.Originals[side][index]=clone
end
end
local function captureOriginalSide(state,side,overwrite)
local parts=getSideParts(state.Character,side)
if not parts then return false end
for index,part in ipairs(parts) do
captureOriginalPart(state,side,index,part,overwrite)
end
return true
end
local function extractTemplates(model)
if not model then return nil end
local result={Left={},Right={}}
for _,side in ipairs({"Left","Right"}) do
for index,name in ipairs(SIDE_NAMES[side]) do
local source=model:FindFirstChild(name)
local clone=cloneBodyPart(source)
if not clone then return nil end
clone.Name=name
result[side][index]=clone
end
end
return result
end
local function buildTemplateParts()
if templateParts then return true end
if templateBuilding then
local deadline=os.clock()+4
repeat
if templateParts then return true end
if not templateBuilding then break end
task.wait(0.05)
until os.clock()>=deadline
return templateParts~=nil
end
templateBuilding=true
templateBuildGeneration=templateBuildGeneration+1
local buildGeneration=templateBuildGeneration
local description=Instance.new("HumanoidDescription")
description.LeftLeg=LEFT_ASSET
description.RightLeg=RIGHT_ASSET
local model=nil
local ok=pcall(function()
model=PlayersService:CreateHumanoidModelFromDescriptionAsync(
description,
Enum.HumanoidRigType.R15
)
end)
if (not ok or not model) then
ok=pcall(function()
model=PlayersService:CreateHumanoidModelFromDescription(
description,
Enum.HumanoidRigType.R15
)
end)
end
local extracted=nil
if ok and model then
extracted=extractTemplates(model)
end
pcall(function() description:Destroy() end)
if model then pcall(function() model:Destroy() end) end
if buildGeneration==templateBuildGeneration and extracted then
templateParts=extracted
end
templateBuilding=false
return templateParts~=nil
end
local function replaceOnePart(state,side,index,source)
if not state or not state.Humanoid or not source then return false end
if player.Character~=state.Character then return false end
local clone=cloneBodyPart(source)
if not clone then return false end
clone.Name=SIDE_NAMES[side][index]
clone:SetAttribute(KORBLOX_MARKER,side)
local ok,result=pcall(function()
return state.Humanoid:ReplaceBodyPartR15(SIDE_ENUMS[side][index],clone)
end)
if not ok or result==false then
pcall(function() clone:Destroy() end)
return false
end
return true
end
local function applyDescriptionFallback(state)
if not state or not state.Humanoid or player.Character~=state.Character then
return false
end
local description=nil
local ok=pcall(function()
description=state.Humanoid:GetAppliedDescription()
end)
if not ok or not description then
if state.BaselineDescription then
description=state.BaselineDescription:Clone()
else
return false
end
end
description.LeftLeg=KorbloxSystem.LeftEnabled and LEFT_ASSET or (state.BaselineLegIds.Left or 0)
description.RightLeg=KorbloxSystem.RightEnabled and RIGHT_ASSET or (state.BaselineLegIds.Right or 0)
state.SuppressAppearanceUntil=os.clock()+1.0
local applied=pcall(function()
if state.Humanoid.ApplyDescriptionResetAsync then
state.Humanoid:ApplyDescriptionResetAsync(description)
elseif state.Humanoid.ApplyDescriptionAsync then
state.Humanoid:ApplyDescriptionAsync(description)
else
state.Humanoid:ApplyDescription(description)
end
end)
pcall(function() description:Destroy() end)
if applied and player.Character==state.Character then
for _,side in ipairs({"Left","Right"}) do
local parts=getSideParts(state.Character,side)
if parts then
for _,part in ipairs(parts) do
if sideEnabled(side) then
pcall(function() part:SetAttribute(KORBLOX_MARKER,side) end)
else
pcall(function() part:SetAttribute(KORBLOX_MARKER,nil) end)
end
end
end
end
end
return applied
end
local hookCurrentSideParts
local function applySideNow(state,side)
if not state or not sideEnabled(side) then return false end
if player.Character~=state.Character then return false end
local parts=waitForSideParts(state.Character,side,2.5)
if not parts then return false end
captureOriginalSide(state,side,false)
if not buildTemplateParts() then
return applyDescriptionFallback(state)
end
state.Applying[side]=true
local success=true
for index=1,3 do
if not replaceOnePart(state,side,index,templateParts[side][index]) then
success=false
break
end
end
state.Applying[side]=false
if not success then
local fallbackApplied=applyDescriptionFallback(state)
if fallbackApplied then hookCurrentSideParts(state,side) end
return fallbackApplied
end
hookCurrentSideParts(state,side)
return true
end
local function restoreSideNow(state,side)
if not state or player.Character~=state.Character then return false end
local originals=state.Originals[side]
local complete=true
for index=1,3 do
if not originals[index] then complete=false break end
end
if not complete then
return applyDescriptionFallback(state)
end
state.Applying[side]=true
local success=true
for index=1,3 do
local clone=cloneBodyPart(originals[index])
if not clone then
success=false
break
end
clone.Name=SIDE_NAMES[side][index]
clone:SetAttribute(KORBLOX_MARKER,nil)
local ok,result=pcall(function()
return state.Humanoid:ReplaceBodyPartR15(SIDE_ENUMS[side][index],clone)
end)
if not ok or result==false then
pcall(function() clone:Destroy() end)
success=false
break
end
end
state.Applying[side]=false
for _,connection in ipairs((state.PartConnections and state.PartConnections[side]) or {}) do
disconnect(connection)
end
if state.PartConnections then state.PartConnections[side]={} end
if not success then
return applyDescriptionFallback(state)
end
return true
end
local scheduleSide
hookCurrentSideParts=function(state,side)
if not state or not state.PartConnections then return end
for _,connection in ipairs(state.PartConnections[side] or {}) do
disconnect(connection)
end
state.PartConnections[side]={}
local parts=getSideParts(state.Character,side)
if not parts then return end
for _,part in ipairs(parts) do
if part:IsA("MeshPart") then
local function changed()
if currentState~=state or player.Character~=state.Character then return end
if state.Applying[side] or not sideEnabled(side) then return end
if os.clock()<state.SuppressAppearanceUntil then return end
scheduleSide(state,side,0.06)
end
local okMesh,meshConnection=pcall(function()
return part:GetPropertyChangedSignal("MeshId"):Connect(changed)
end)
if okMesh and meshConnection then
table.insert(state.PartConnections[side],meshConnection)
end
local okTexture,textureConnection=pcall(function()
return part:GetPropertyChangedSignal("TextureID"):Connect(changed)
end)
if okTexture and textureConnection then
table.insert(state.PartConnections[side],textureConnection)
end
end
end
end
scheduleSide=function(state,side,delayTime)
if not state then return end
state.RepairTokens[side]=state.RepairTokens[side]+1
local token=state.RepairTokens[side]
local generation=state.Generation
task.delay(delayTime or 0,function()
if currentState~=state then return end
if state.Generation~=generation then return end
if state.RepairTokens[side]~=token then return end
if player.Character~=state.Character then return end
if not sideEnabled(side) then return end
applySideNow(state,side)
task.delay(0.22,function()
if currentState~=state or state.Generation~=generation then return end
if not sideEnabled(side) or player.Character~=state.Character then return end
local parts=getSideParts(state.Character,side)
local good=parts~=nil
if good then
for _,part in ipairs(parts) do
if part:GetAttribute(KORBLOX_MARKER)~=side then
good=false
break
end
end
end
if not good then
state.RepairTokens[side]=state.RepairTokens[side]+1
local verifyToken=state.RepairTokens[side]
task.delay(0.18,function()
if currentState==state
and state.Generation==generation
and state.RepairTokens[side]==verifyToken
and player.Character==state.Character
and sideEnabled(side) then
applySideNow(state,side)
end
end)
end
end)
end)
end
local function hookCharacterState(state)
if not state or not state.Character then return end
local char=state.Character
local humanoid=state.Humanoid
if not humanoid then return end
local nameToSide={}
for _,name in ipairs(SIDE_NAMES.Left) do nameToSide[name]="Left" end
for _,name in ipairs(SIDE_NAMES.Right) do nameToSide[name]="Right" end
table.insert(state.Connections,char.ChildAdded:Connect(function(child)
local side=nameToSide[child.Name]
if not side or not child:IsA("BasePart") then return end
if currentState~=state or player.Character~=char then return end
if state.Applying[side] then return end
if os.clock()<state.SuppressAppearanceUntil then return end
local marker=child:GetAttribute(KORBLOX_MARKER)
if marker==side then return end
captureOriginalPart(state,side,table.find(SIDE_NAMES[side],child.Name),child,true)
if sideEnabled(side) then
scheduleSide(state,side,0.08)
end
end))
local ok,connection=pcall(function()
return humanoid.ApplyDescriptionFinished:Connect(function()
if currentState~=state or player.Character~=char then return end
if os.clock()<state.SuppressAppearanceUntil then return end
captureBaselineDescription(state)
if KorbloxSystem.LeftEnabled then
captureOriginalSide(state,"Left",true)
scheduleSide(state,"Left",0.08)
end
if KorbloxSystem.RightEnabled then
captureOriginalSide(state,"Right",true)
scheduleSide(state,"Right",0.08)
end
end)
end)
if ok and connection then table.insert(state.Connections,connection) end
local appearanceConnection
local okAppearance=pcall(function()
appearanceConnection=player.CharacterAppearanceLoaded:Connect(function(loadedChar)
if loadedChar~=char or currentState~=state then return end
if KorbloxSystem.LeftEnabled then scheduleSide(state,"Left",0.06) end
if KorbloxSystem.RightEnabled then scheduleSide(state,"Right",0.06) end
end)
end)
if okAppearance and appearanceConnection then
table.insert(state.Connections,appearanceConnection)
end
end
local function ensureCharacterState(char)
if not char then return nil end
local state=beginCharacterState(char)
if state and #(state.Connections or {})==0 then
hookCharacterState(state)
end
return state
end
local function applyRight(char)
local state=ensureCharacterState(char or player.Character)
if not state or not KorbloxSystem.RightEnabled then return false end
return applySideNow(state,"Right")
end
local function applyLeft(char)
local state=ensureCharacterState(char or player.Character)
if not state or not KorbloxSystem.LeftEnabled then return false end
return applySideNow(state,"Left")
end
local function removeRight()
local state=currentState
if not state then return end
state.RepairTokens.Right=state.RepairTokens.Right+1
restoreSideNow(state,"Right")
end
local function removeLeft()
local state=currentState
if not state then return end
state.RepairTokens.Left=state.RepairTokens.Left+1
restoreSideNow(state,"Left")
end
local function scheduleRight(char)
local state=ensureCharacterState(char or player.Character)
if state and KorbloxSystem.RightEnabled then
scheduleSide(state,"Right",0)
end
end
local function scheduleLeft(char)
local state=ensureCharacterState(char or player.Character)
if state and KorbloxSystem.LeftEnabled then
scheduleSide(state,"Left",0)
end
end
KorbloxSystem.ApplyRight=applyRight
KorbloxSystem.RemoveRight=removeRight
KorbloxSystem.ApplyLeft=applyLeft
KorbloxSystem.RemoveLeft=removeLeft
KorbloxSystem.ScheduleRight=scheduleRight
KorbloxSystem.ScheduleLeft=scheduleLeft
KorbloxSystem.Schedule=function(char)
local state=ensureCharacterState(char)
if not state then return end
if KorbloxSystem.RightEnabled then scheduleSide(state,"Right",0) end
if KorbloxSystem.LeftEnabled then scheduleSide(state,"Left",0) end
end
KorbloxSystem.Reset=function()
local state=currentState
if state then
state.RepairTokens.Left=state.RepairTokens.Left+1
state.RepairTokens.Right=state.RepairTokens.Right+1
if KorbloxSystem.LeftEnabled then restoreSideNow(state,"Left") end
if KorbloxSystem.RightEnabled then restoreSideNow(state,"Right") end
clearStateConnections(state)
end
currentState=nil
stateGeneration=stateGeneration+1
KorbloxSystem.RightEnabled=false
KorbloxSystem.LeftEnabled=false
end
KorbloxSystem.RightToggle=addToggle(
characterSection,
"Korblox Right Leg",
KorbloxSystem.RightEnabled,
function(state)
KorbloxSystem.RightEnabled=state
SetCfg("korbloxEnabled",state)
if state then
scheduleRight(player.Character)
else
removeRight()
end
end
)
KorbloxSystem.LeftToggle=addToggle(
characterSection,
"Korblox Left Leg",
KorbloxSystem.LeftEnabled,
function(state)
KorbloxSystem.LeftEnabled=state
SetCfg("korbloxLeftEnabled",state)
if state then
scheduleLeft(player.Character)
else
removeLeft()
end
end
)
end,"Part at line 3499")
;vv2Section(function()
env.VisualsV2Runtime.RegisterReset(function()
headlessToggle:Set(false)
headlessEnabled=false
applyCharacterVisuals()
if KorbloxSystem.RightToggle then KorbloxSystem.RightToggle:Set(false) end
if KorbloxSystem.LeftToggle then KorbloxSystem.LeftToggle:Set(false) end
KorbloxSystem.Reset()
end)
end,"Part at line 4164")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local runtime=env.VisualsV2Runtime
local section=mainTab:AddSection("Visual Avatar","Cosmetic")
section:AddParagraph("Visual Avatar","Type a username or user ID, then switch it on. Only you see the avatar (its animations play for everyone, like any animation of yours).")
local target=tostring(C("vv2VisualAvatarTarget",""))
local enabled=C("vv2VisualAvatarEnabled",false)==true
local MARK="VisualsV2_VisualAvatar"
local STEP="VisualsV2_VisualAvatarFollow"
local templates={}
local current=nil
local function refreshVisualHats()
local refresh=runtime.RefreshVisualHats
if type(refresh)=="function" then pcall(refresh) end
end
runtime.VisualAvatarHatTarget=function(character)
local state=current
if not state or state.character~=character or not state.puppet.Parent then return end
local head=state.puppet:FindFirstChild("Head")
if not head or not head:IsA("BasePart") then return end
return state.firstPerson and state.hatFolder or state.puppet,head
end
runtime.TrackVisualAvatarHat=function(accessory)
local state=current
if not state or (accessory.Parent~=state.puppet and accessory.Parent~=state.hatFolder) then return end
for _,object in ipairs(accessory:GetDescendants()) do
if object:IsA("BasePart") or object:IsA("Decal") then
-- This owned hat has moved off the hidden real character onto the displayed rig.
state.hidden[object]=nil
object.LocalTransparencyModifier=0
end
end
end
local token=0
local stats={applied=0,lastError=nil,accessoriesLoaded=0}
local function notify(text,kind) pcall(shared.Notify,"Visual Avatar: "..text,kind or 3) end
local resolved={}
local function resolve(text)
text=tostring(text or ""):gsub("^%s+",""):gsub("%s+$","")
if text=="" then return nil,"type a username or user ID first" end
local id=tonumber(text)
if id and id>0 and math.floor(id)==id then return id end
if resolved[text:lower()] then return resolved[text:lower()] end
local ok,result=pcall(function() return Players:GetUserIdFromNameAsync(text) end)
if ok and tonumber(result) then resolved[text:lower()]=tonumber(result);return tonumber(result) end
return nil,"no account called "..text
end
local function description(userId)
for _,method in ipairs({"GetHumanoidDescriptionFromUserIdAsync","GetHumanoidDescriptionFromUserId"}) do
local ok,result=pcall(function() return Players[method](Players,userId) end)
if ok and typeof(result)=="Instance" then return result end
end
end
local function clone(object)
local archivable=object.Archivable
if not archivable then pcall(function() object.Archivable=true end) end
local ok,copy=pcall(function() return object:Clone() end)
if not archivable then pcall(function() object.Archivable=false end) end
return ok and copy or nil
end
local function cleanId(value)
local text=tostring(value or "")
return text:match("^%s*(%d+)%s*$") or text:match("[?&]id=(%d+)") or text:match("rbxassetid://(%d+)")
end
local function attach(model,humanoid,accessory)
accessory.Parent=model
local handle=accessory:FindFirstChild("Handle")
if not handle then return end
local function welded()
for _,object in ipairs(handle:GetChildren()) do
if (object:IsA("Weld") or object:IsA("WeldConstraint") or object:IsA("RigidConstraint")) then return true end
end
return false
end
if humanoid and not welded() then pcall(function() humanoid:AddAccessory(accessory) end) end
if welded() then return end
local mine=handle:FindFirstChildWhichIsA("Attachment")
if not mine then return end
for _,part in ipairs(model:GetChildren()) do
if part:IsA("BasePart") then
local theirs=part:FindFirstChild(mine.Name)
if theirs and theirs:IsA("Attachment") then
local weld=Instance.new("Weld")
weld.Name="AccessoryWeld"
weld.Part0=handle;weld.Part1=part
weld.C0=mine.CFrame;weld.C1=theirs.CFrame
weld.Parent=handle
return
end
end
end
end
local function accessoryIds(desc)
local ids={}
local seen={}
local function add(id)
id=cleanId(id)
if id and id~="0" and not seen[id] then seen[id]=true;ids[#ids+1]=id end
end
pcall(function()
for _,entry in ipairs(desc:GetAccessories(true)) do add(entry.AssetId) end
end)
for _,field in ipairs({"HatAccessory","HairAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory",
"FrontAccessory","BackAccessory","WaistAccessory"}) do
local ok,value=pcall(function() return desc[field] end)
if ok and type(value)=="string" then for id in value:gmatch("%d+") do add(id) end end
end
return ids
end
local ANIMATIONS={
{"idle","idle","Animation1"},{"idle2","idle","Animation2"},{"walk","walk","WalkAnim"},{"run","run","RunAnim"},
{"jump","jump","JumpAnim"},{"fall","fall","FallAnim"},{"climb","climb","ClimbAnim"},
{"swim","swim","Swim"},{"swimidle","swimidle","SwimIdle"},
}
-- Verified from Roblox Studio's shipped humanoidR15/R6AnimateChildren assets.
local DEFAULT_AVATAR_ANIMATIONS={
R15={idle="507766388",idle2="507766666",walk="913402848",run="913376220",
jump="507765000",fall="507767968",climb="507765644",swim="913384386",swimidle="913389285"},
R6={idle="180435571",idle2="180435792",walk="180426354",run="180426354",
jump="125750702",fall="180436148",climb="180436334"},
}
local function animationsOf(model,desc,ticket,rigType)
local animate=model:FindFirstChild("Animate") or model:FindFirstChild("R15Anim") or model:FindFirstChild("R6Anim")
local humanoid=model:FindFirstChildOfClass("Humanoid")
local rig=rigType or (humanoid and humanoid.RigType)
local defaults=rig==Enum.HumanoidRigType.R6 and DEFAULT_AVATAR_ANIMATIONS.R6 or DEFAULT_AVATAR_ANIMATIONS.R15
local properties={idle="IdleAnimation",idle2="IdleAnimation",walk="WalkAnimation",run="RunAnimation",
jump="JumpAnimation",fall="FallAnimation",climb="ClimbAnimation",swim="SwimAnimation",swimidle="SwimAnimation"}
local found={}
for _,spec in ipairs(ANIMATIONS) do
if ticket and (ticket~=token or not enabled or not runtimeAlive) then return nil end
local folder=animate and animate:FindFirstChild(spec[2])
local animation=folder and (folder:FindFirstChild(spec[3]) or folder:FindFirstChildWhichIsA("Animation"))
local id=animation and animation:IsA("Animation") and cleanId(animation.AnimationId)
if id and id~="0" then found[spec[1]]=id end
-- Generated appearance models can lack a populated Animate script. Equipped
-- HumanoidDescription properties are the authoritative catalog animation IDs.
local ok,value=pcall(function() return desc and desc[properties[spec[1]]] end)
local asset=ok and cleanId(value)
if asset and asset~="0" then
local playback=asset
local resolveAsset=runtime.ResolveAnimationAsset
if type(resolveAsset)=="function" then
local loaded,result=pcall(resolveAsset,asset,spec[1])
if loaded then playback=cleanId(result) or asset end
end
found[spec[1]]=playback
elseif not found[spec[1]] then
-- A zero description ID means the target uses Roblox's rig default for this
-- state, not the local player's equipped animation pack.
found[spec[1]]=defaults[spec[1]]
end
end
if found.idle2==found.idle then found.idle2=nil end
return next(found) and found or nil
end
local function buildTemplate(userId,rigType,ticket)
local key=userId..":"..tostring(rigType)
local cached=templates[key]
if cached and cached.model:FindFirstChildOfClass("Humanoid") then return cached end
local desc=description(userId)
if not desc then return nil,"couldn't load that account's avatar" end
local model
for _,method in ipairs({"CreateHumanoidModelFromDescriptionAsync","CreateHumanoidModelFromDescription"}) do
local ok,result=pcall(function() return Players[method](Players,desc,rigType) end)
if ok and typeof(result)=="Instance" then model=result;break end
end
if not model then pcall(function() desc:Destroy() end);return nil,"couldn't build that avatar" end
model.Parent=nil
local humanoid=model:FindFirstChildOfClass("Humanoid")
local have={}
local count=0
for _,object in ipairs(model:GetChildren()) do
if object:IsA("Accessory") then have[object.Name:lower()]=true;count=count+1 end
end
local wanted=accessoryIds(desc)
if count<#wanted and type(game.GetObjects)=="function" then
-- (up to 4 accessories download at the same time, then they're put on in order)
local results,nextIndex,running={},1,0
local function download()
while nextIndex<=#wanted do
local index=nextIndex;nextIndex=nextIndex+1
local ok,objects=pcall(function() return game:GetObjects("rbxassetid://"..wanted[index]) end)
results[index]=ok and type(objects)=="table" and objects or false
end
running=running-1
end
for _=1,math.min(4,#wanted) do running=running+1;task.spawn(download) end
local waitedSince=os.clock()
while running>0 and os.clock()-waitedSince<20 do task.wait(0.05) end
for index=1,#wanted do
local objects=results[index]
if objects then
for _,object in ipairs(objects) do
if typeof(object)=="Instance" and object:IsA("Accessory") and not have[object.Name:lower()] then
have[object.Name:lower()]=true
attach(model,humanoid,object)
stats.accessoriesLoaded=stats.accessoriesLoaded+1
elseif typeof(object)=="Instance" and not object.Parent then
pcall(function() object:Destroy() end)
end
end
end
end
end
local animationMap=animationsOf(model,desc,ticket,rigType)
pcall(function() desc:Destroy() end)
if ticket and (ticket~=token or not enabled or not runtimeAlive) then
pcall(function() model:Destroy() end)
return nil,"avatar request superseded"
end
local template={model=model,animations=animationMap}
templates[key]=template
return template
end
local BODY={Head=true,UpperTorso=true,LowerTorso=true,Torso=true,
LeftUpperArm=true,LeftLowerArm=true,LeftHand=true,RightUpperArm=true,RightLowerArm=true,RightHand=true,
LeftUpperLeg=true,LeftLowerLeg=true,LeftFoot=true,RightUpperLeg=true,RightLowerLeg=true,RightFoot=true,
["Left Arm"]=true,["Right Arm"]=true,["Left Leg"]=true,["Right Leg"]=true}
local RIGHT_LEG={RightUpperLeg=true,RightLowerLeg=true,RightFoot=true}
local LEFT_LEG={LeftUpperLeg=true,LeftLowerLeg=true,LeftFoot=true}
local function korbloxSide(name)
if RIGHT_LEG[name] and KorbloxSystem.RightEnabled then return true end
if LEFT_LEG[name] and KorbloxSystem.LeftEnabled then return true end
return false
end
local function shouldHide(object,character)
if object:IsA("BasePart") then
if object.Parent==character then return BODY[object.Name]==true and not korbloxSide(object.Name) end
local accessory=object:FindFirstAncestorWhichIsA("Accessory")
return accessory~=nil and accessory.Parent==character
end
if object:IsA("Decal") then
local head=character:FindFirstChild("Head")
return head~=nil and object.Parent==head
end
return false
end
local function hide(state,object)
if state.hidden[object]~=nil or not shouldHide(object,state.character) then return end
state.hidden[object]=object.LocalTransparencyModifier
pcall(function() object.LocalTransparencyModifier=1 end)
end
local function restore(keepAnimations)
local state=current
current=nil
pcall(function() RunService:UnbindFromRenderStep(STEP) end)
if not state then
if not keepAnimations and type(runtime.SetAnimationOverride)=="function" then pcall(runtime.SetAnimationOverride,nil) end
return
end
for _,connection in ipairs(state.connections) do pcall(function() connection:Disconnect() end) end
if state.dropTool then for tool in pairs(state.tools or {}) do pcall(state.dropTool,tool) end end
for display,entry in pairs(state.weapons or {}) do
pcall(function() if display.Parent then display.LocalTransparencyModifier=entry.hidden or 0 end end)
end
refreshVisualHats()
if state.hatFolder then state.hatFolder:Destroy() end
pcall(function() state.puppet:Destroy() end)
for object,value in pairs(state.hidden) do
pcall(function() object.LocalTransparencyModifier=value end)
end
if not keepAnimations and type(runtime.SetAnimationOverride)=="function" then pcall(runtime.SetAnimationOverride,nil) end
end
local IDENTITY=CFrame.new()
local HAND_TWIN={RightHand="Right Arm",["Right Arm"]="RightHand",LeftHand="Left Arm",["Left Arm"]="LeftHand"}
local function jointEnds(joint)
if joint:IsA("JointInstance") then
local p0,p1=joint.Part0,joint.Part1
if p0 and p1 then return p0,p1,joint.C0 or IDENTITY,joint.C1 or IDENTITY end
elseif joint:IsA("AnimationConstraint") or joint:IsA("RigidConstraint") then
local a0,a1=joint.Attachment0,joint.Attachment1
local p0,p1=a0 and a0.Parent,a1 and a1.Parent
if p0 and p1 and p0:IsA("BasePart") and p1:IsA("BasePart") then return p0,p1,a0.CFrame or IDENTITY,a1.CFrame or IDENTITY end
elseif joint:IsA("WeldConstraint") then
local p0,p1=joint.Part0,joint.Part1
if p0 and p1 then return p0,p1,p0.CFrame:ToObjectSpace(p1.CFrame),IDENTITY end
end
end
local function animated(joint) return joint:IsA("Motor6D") or joint:IsA("AnimationConstraint") end
local function posedJoints(character)
local found={}
for _,joint in ipairs(character:GetDescendants()) do
if animated(joint) then
local ok,p0,p1=pcall(jointEnds,joint)
if ok and p0 and p1 then found[p0.Name.."|"..p1.Name]=joint end
end
end
return found
end
local function apply(template,label)
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local root=character and character:FindFirstChild("HumanoidRootPart")
if not humanoid or not root or humanoid.Health<=0 then return false,"your character isn't loaded" end
restore(true)
local puppet=clone(template.model)
if not puppet and type(runtime.SetAnimationOverride)=="function" then pcall(runtime.SetAnimationOverride,nil) end
if not puppet then return false,"couldn't copy that avatar" end
puppet.Name=MARK
local theirHumanoid=puppet:FindFirstChildOfClass("Humanoid")
local theirRoot=puppet:FindFirstChild("HumanoidRootPart")
if not theirHumanoid or not theirRoot then
pcall(function() puppet:Destroy() end)
if type(runtime.SetAnimationOverride)=="function" then pcall(runtime.SetAnimationOverride,nil) end
return false,"that avatar has no body"
end
for _,object in ipairs(puppet:GetDescendants()) do
if object:IsA("LuaSourceContainer") or object:IsA("Animator") then
object:Destroy()
elseif object:IsA("BasePart") then
object.CanCollide=false;object.CanTouch=false;object.CanQuery=false;object.Massless=true
end
end
theirRoot.Transparency=1
pcall(function()
theirHumanoid.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
theirHumanoid.HealthDisplayType=Enum.HumanoidHealthDisplayType.AlwaysOff
theirHumanoid.NameDisplayDistance=0
theirHumanoid.RequiresNeck=false
theirHumanoid.BreakJointsOnDeath=false
theirHumanoid.PlatformStand=true
end)
pcall(function()
for _,stateType in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
if stateType~=Enum.HumanoidStateType.Physics and stateType~=Enum.HumanoidStateType.None then
theirHumanoid:SetStateEnabled(stateType,false)
end
end
theirHumanoid:ChangeState(Enum.HumanoidStateType.Physics)
end)
pcall(function() theirHumanoid.EvaluateStateMachine=false end)
local links,joints={},{}
for _,joint in ipairs(puppet:GetDescendants()) do
local ok,p0,p1,c0,c1=pcall(jointEnds,joint)
if ok and p0 and p1 and p0~=p1 and p0:IsDescendantOf(puppet) and p1:IsDescendantOf(puppet) then
local entry={joint=joint,p0=p0,p1=p1,c0=c0,c1=c1,c0Inverse=c0:Inverse(),c1Inverse=c1:Inverse(),
posed=animated(joint),key=p0.Name.."|"..p1.Name}
joints[#joints+1]=entry
links[p0]=links[p0] or {};table.insert(links[p0],entry)
links[p1]=links[p1] or {};table.insert(links[p1],entry)
end
end
local steps,placed={},{[theirRoot]=true}
local function spread(from)
local queue,head={from},1
while head<=#queue do
local part=queue[head];head=head+1
for _,entry in ipairs(links[part] or {}) do
local other=entry.p0==part and entry.p1 or entry.p0
if not placed[other] then
placed[other]=true
steps[#steps+1]={part=other,from=part,forward=entry.p0==part,entry=entry}
queue[#queue+1]=other
end
end
end
end
spread(theirRoot)
local loose={}
for _,object in ipairs(puppet:GetDescendants()) do
if object:IsA("BasePart") and not placed[object] then loose[#loose+1]=object end
end
table.sort(loose,function(a,b) return #(links[a] or {})>#(links[b] or {}) end)
for _,part in ipairs(loose) do
if not placed[part] then
placed[part]=true
steps[#steps+1]={part=part,from=theirRoot,fixed=theirRoot.CFrame:ToObjectSpace(part.CFrame)}
spread(part)
end
end
for _,entry in ipairs(joints) do pcall(function() entry.joint:Destroy() end) end
for _,object in ipairs(puppet:GetDescendants()) do
if object:IsA("BasePart") then object.Anchored=true end
end
if headlessEnabled then
local head=puppet:FindFirstChild("Head")
if head then
head.Transparency=1
for _,object in ipairs(head:GetChildren()) do if object:IsA("Decal") then object.Transparency=1 end end
end
end
for name in pairs(BODY) do
local part=puppet:FindFirstChild(name)
if part and part:IsA("BasePart") and korbloxSide(name) then part.Transparency=1 end
end
local mine=posedJoints(character)
local matched=0
for _,step in ipairs(steps) do if step.entry and step.entry.posed and mine[step.entry.key] then matched=matched+1 end end
local offset=0
if humanoid.RigType==Enum.HumanoidRigType.R15 then
offset=((tonumber(theirHumanoid.HipHeight) or 2)+theirRoot.Size.Y/2)-((tonumber(humanoid.HipHeight) or 2)+root.Size.Y/2)
end
local state={character=character,humanoid=humanoid,root=root,puppet=puppet,theirRoot=theirRoot,
steps=steps,mine=mine,matched=matched,offset=offset,hidden={},connections={},firstPerson=false,parts={}}
state.hatFolder=Instance.new("Folder")
state.hatFolder.Name=MARK.."_HiddenVisualHats"
for _,object in ipairs(puppet:GetDescendants()) do
if object:IsA("BasePart") and object~=theirRoot then state.parts[#state.parts+1]=object end
end
state.solid={theirRoot}
for _,part in ipairs(state.parts) do state.solid[#state.solid+1]=part end
table.insert(state.connections,RunService.Stepped:Connect(function()
if current~=state then return end
for _,part in ipairs(state.solid) do
if part.CanCollide then part.CanCollide=false end
if part.CanTouch then part.CanTouch=false end
end
end))
current=state
for _,object in ipairs(character:GetDescendants()) do hide(state,object) end
table.insert(state.connections,character.DescendantAdded:Connect(function(object)
if animated(object) then state.jointsDirty=true end
task.defer(function() if current==state and object.Parent then hide(state,object) end end)
end))
table.insert(state.connections,humanoid.Died:Connect(function() if current==state then restore(enabled) end end))
theirRoot.CFrame=root.CFrame*CFrame.new(0,offset,0)
puppet.Parent=workspace.CurrentCamera or workspace
refreshVisualHats()
state.weapons={}
local function attachedToMe(display)
for _,object in ipairs(display:GetDescendants()) do
if object:IsA("Constraint") or object:IsA("JointInstance") or object:IsA("WeldConstraint") then
local ends={}
pcall(function() ends={object.Attachment0 and object.Attachment0.Parent,object.Attachment1 and object.Attachment1.Parent} end)
pcall(function() ends[#ends+1]=object.Part0;ends[#ends+1]=object.Part1 end)
for _,part in ipairs(ends) do
if typeof(part)=="Instance" and part:IsA("BasePart") and part:IsDescendantOf(character) then return part end
end
end
end
end
local function displayKind(display)
local name=display.Name:lower()
if name:find("knife",1,true) then return "Knife" end
if name:find("gun",1,true) then return "Gun" end
end
local function replacement(kind)
local skins=kind and runtime.ClientWeaponSkins
if not skins or type(skins.GetHolster)~="function" then return nil end
local ok,model=pcall(skins.GetHolster,kind)
if ok and typeof(model)=="Instance" and model.Parent then return model end
end
state.holsters={}
local function refreshWeapons()
local folder=workspace:FindFirstChild("WeaponDisplays")
local seen={}
for _,display in ipairs(folder and folder:GetChildren() or {}) do
if display:IsA("BasePart") then
local body=attachedToMe(display)
if body then
seen[display]=true
local replaced=replacement(displayKind(display))~=nil
local entry=state.weapons[display]
local hidden=entry and entry.hidden
if entry and entry.replaced~=replaced then
if entry.copy then pcall(function() entry.copy:Destroy() end) end
state.weapons[display]=nil;entry=nil
end
if not entry then
local copy=nil
if not replaced then
copy=clone(display)
if copy then
for _,object in ipairs(copy:GetDescendants()) do
if object:IsA("Constraint") or object:IsA("JointInstance") or object:IsA("WeldConstraint")
or object:IsA("LuaSourceContainer") then object:Destroy() end
end
copy.Anchored=true;copy.CanCollide=false;copy.CanTouch=false;copy.CanQuery=false;copy.Massless=true
copy.Parent=puppet
end
end
if copy or replaced then
if hidden==nil then hidden=display.LocalTransparencyModifier end
entry={copy=copy,body=body,hidden=hidden,replaced=replaced}
state.weapons[display]=entry
end
end
if entry then entry.body=body end
end
end
end
for display,entry in pairs(state.weapons) do
if not seen[display] then
if entry.copy then pcall(function() entry.copy:Destroy() end) end
pcall(function() if display.Parent then display.LocalTransparencyModifier=entry.hidden or 0 end end)
state.weapons[display]=nil
end
end
for _,kind in ipairs({"Knife","Gun"}) do
local source=replacement(kind)
local entry=state.holsters[kind]
if entry and entry.source~=source then
pcall(function() entry.copy:Destroy() end)
state.holsters[kind]=nil;entry=nil
end
if source and not entry then
local copy=clone(source)
if copy then
local pairsList={}
local from,to=source:GetDescendants(),copy:GetDescendants()
for index,object in ipairs(from) do
local twin=to[index]
if twin and twin.ClassName==object.ClassName then
if object:IsA("BasePart") then pairsList[#pairsList+1]={object,twin,"part"}
elseif object:IsA("SpecialMesh") then pairsList[#pairsList+1]={object,twin,"mesh"}
elseif object:IsA("Decal") then pairsList[#pairsList+1]={object,twin,"decal"} end
end
end
for _,object in ipairs(copy:GetDescendants()) do
if object:IsA("Constraint") or object:IsA("JointInstance") or object:IsA("WeldConstraint")
or object:IsA("LuaSourceContainer") then object:Destroy()
elseif object:IsA("BasePart") then
object.Anchored=true;object.CanCollide=false;object.CanTouch=false;object.CanQuery=false;object.Massless=true
end
end
copy.Name=MARK..kind
copy.Parent=puppet
state.holsters[kind]={source=source,copy=copy,pairs=pairsList}
end
end
end
end
state.refreshWeapons=refreshWeapons
pcall(refreshWeapons)
-- A held tool (toys, the knife, the gun) is shown in the avatar's own hand: a copy follows the
-- avatar's hand the way the real tool sits in your real hand, and the real one is hidden.
state.tools={}
local function gripHand(tool)
local handle=tool:FindFirstChild("Handle")
if not handle or not handle:IsA("BasePart") then return nil end
for _,joint in ipairs(character:GetDescendants()) do
if joint:IsA("JointInstance") and not joint:IsDescendantOf(tool) then
local other=(joint.Part1==handle and joint.Part0) or (joint.Part0==handle and joint.Part1) or nil
if other and other:IsDescendantOf(character) and not other:IsDescendantOf(tool) then return other end
end
end
end
local function dropTool(tool)
local entry=state.tools[tool]
if not entry then return end
state.tools[tool]=nil
for _,connection in ipairs(entry.connections) do pcall(function() connection:Disconnect() end) end
pcall(function() entry.copy:Destroy() end)
for original,value in pairs(entry.hidden) do
pcall(function() if original.Parent then original.LocalTransparencyModifier=value end end)
end
end
local function holdTool(tool)
if state.tools[tool] or not tool:IsA("Tool") or tool.Parent~=character then return end
local hand=gripHand(tool)
if not hand then return end
local copy=clone(tool)
if not copy then return end
local pairsList,hidden={},{}
local from,to=tool:GetDescendants(),copy:GetDescendants()
for index,object in ipairs(from) do
local twin=to[index]
if twin and twin.ClassName==object.ClassName and object:IsA("BasePart") then
pairsList[#pairsList+1]={object,twin}
hidden[object]=object.LocalTransparencyModifier
end
end
for _,object in ipairs(copy:GetDescendants()) do
if object:IsA("Constraint") or object:IsA("JointInstance") or object:IsA("WeldConstraint")
or object:IsA("LuaSourceContainer") or object:IsA("Sound") then object:Destroy()
elseif object:IsA("BasePart") then
object.Anchored=true;object.CanCollide=false;object.CanTouch=false;object.CanQuery=false;object.Massless=true
elseif object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam") or object:IsA("Light")
or object:IsA("Fire") or object:IsA("Smoke") or object:IsA("Sparkles") then
pcall(function() object.Enabled=false end)
end
end
local model=Instance.new("Model")
model.Name=MARK.."_HeldTool"
for _,child in ipairs(copy:GetChildren()) do child.Parent=model end
pcall(function() copy:Destroy() end)
model.Parent=puppet
local entry={copy=model,hand=hand,pairs=pairsList,hidden=hidden,connections={}}
state.tools[tool]=entry
local function rebuild() task.defer(function() if current==state and state.tools[tool]==entry then dropTool(tool);holdTool(tool) end end) end
table.insert(entry.connections,tool.DescendantAdded:Connect(function(object) if object:IsA("BasePart") then rebuild() end end))
table.insert(entry.connections,tool.DescendantRemoving:Connect(function(object) if object:IsA("BasePart") then rebuild() end end))
end
state.dropTool,state.holdTool=dropTool,holdTool
for _,child in ipairs(character:GetChildren()) do pcall(holdTool,child) end
table.insert(state.connections,character.ChildAdded:Connect(function(child)
if child:IsA("Tool") then task.defer(function() if current==state then pcall(holdTool,child) end end) end
end))
table.insert(state.connections,character.ChildRemoved:Connect(function(child)
if state.tools[child] then dropTool(child) end
end))
pcall(function()
local skins=runtime.ClientWeaponSkins
if skins and typeof(skins.Changed)=="RBXScriptSignal" then
table.insert(state.connections,skins.Changed:Connect(function() state.weaponsAt=0 end))
end
end)
local function follow()
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if current~=state then return end
if not root.Parent or not character.Parent or LocalPlayer.Character~=character then restore();return end
if not puppet.Parent then puppet.Parent=workspace.CurrentCamera or workspace end
theirRoot.CFrame=root.CFrame*CFrame.new(0,state.offset,0)
if state.jointsDirty then
state.jointsDirty=false
local ok,fresh=pcall(posedJoints,character)
if ok then state.mine=fresh end
end
local poses=state.mine
for _,step in ipairs(state.steps) do
local at
if step.fixed then
at=step.from.CFrame*step.fixed
else
local entry=step.entry
local pose=IDENTITY
if entry.posed then
local yours=poses[entry.key]
if yours then pose=yours.Transform or IDENTITY end
end
if step.forward then at=step.from.CFrame*entry.c0*pose*entry.c1Inverse
else at=step.from.CFrame*entry.c1*pose:Inverse()*entry.c0Inverse end
end
step.part.CFrame=at
end
if os.clock()-(state.weaponsAt or 0)>1 then
state.weaponsAt=os.clock();pcall(state.refreshWeapons)
local ok,fresh=pcall(posedJoints,character)
if ok then state.mine=fresh end
end
for display,entry in pairs(state.weapons) do
if display.Parent and entry.body.Parent then
if entry.copy then
local theirBody=puppet:FindFirstChild(entry.body.Name)
local base=theirBody and theirBody:IsA("BasePart") and theirBody or theirRoot
local mine=theirBody and entry.body or root
entry.copy.CFrame=base.CFrame*mine.CFrame:ToObjectSpace(display.CFrame)
end
if display.LocalTransparencyModifier~=1 then display.LocalTransparencyModifier=1 end
end
end
for tool,entry in pairs(state.tools) do
local hand=entry.hand
local theirHand=hand.Parent and (puppet:FindFirstChild(hand.Name) or puppet:FindFirstChild(HAND_TWIN[hand.Name] or ""))
if not (theirHand and theirHand:IsA("BasePart")) then theirHand=nil end
if tool.Parent==character and not theirHand then
-- (no matching hand on the avatar: the real tool stays as it is)
if entry.copy.Parent then entry.copy.Parent=nil end
for original,value in pairs(entry.hidden) do
if original.Parent and original.LocalTransparencyModifier~=value then original.LocalTransparencyModifier=value end
end
elseif tool.Parent==character then
if entry.copy.Parent~=puppet then entry.copy.Parent=puppet end
local alpha=state.firstPerson and 1 or 0
for _,pair in ipairs(entry.pairs) do
local original,twin=pair[1],pair[2]
if original.Parent then
twin.CFrame=theirHand.CFrame*hand.CFrame:ToObjectSpace(original.CFrame)
if twin.Transparency~=original.Transparency then twin.Transparency=original.Transparency end
if twin.LocalTransparencyModifier~=alpha then twin.LocalTransparencyModifier=alpha end
local want=state.firstPerson and (entry.hidden[original] or 0) or 1
if original.LocalTransparencyModifier~=want then original.LocalTransparencyModifier=want end
end
end
end
end
if next(state.holsters) then
local torso=character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
local theirTorso=torso and puppet:FindFirstChild(torso.Name)
local base=theirTorso and theirTorso:IsA("BasePart") and theirTorso or theirRoot
local mine=theirTorso and torso or root
local alpha=state.firstPerson and 1 or 0
for _,entry in pairs(state.holsters) do
if entry.source.Parent then
for _,pair in ipairs(entry.pairs) do
local original,copy,kind=pair[1],pair[2],pair[3]
if original.Parent then
if kind=="part" then
copy.CFrame=base.CFrame*mine.CFrame:ToObjectSpace(original.CFrame)
if copy.Color~=original.Color then copy.Color=original.Color end
if copy.LocalTransparencyModifier~=alpha then copy.LocalTransparencyModifier=alpha end
elseif kind=="mesh" then
if copy.VertexColor~=original.VertexColor then copy.VertexColor=original.VertexColor end
elseif copy.Color3~=original.Color3 then copy.Color3=original.Color3 end
end
end
end
end
end
for object in pairs(state.hidden) do
if object.Parent and object.LocalTransparencyModifier~=1 then object.LocalTransparencyModifier=1 end
end
local camera=workspace.CurrentCamera
local head=character:FindFirstChild("Head")
local close=camera and head and (camera.CFrame.Position-head.Position).Magnitude<1.5 or false
if close~=state.firstPerson then
state.firstPerson=close
for _,part in ipairs(state.parts) do pcall(function() part.LocalTransparencyModifier=close and 1 or 0 end) end
-- Moving the whole owned hat outside the DataModel hides meshes and effects
-- together, without changing emitter Enabled values or other performance state.
refreshVisualHats()
end
end
local bound=pcall(function() RunService:BindToRenderStep(STEP,Enum.RenderPriority.Camera.Value+5,function() pcall(follow) end) end)
if not bound then table.insert(state.connections,RunService.RenderStepped:Connect(function() pcall(follow) end)) end
follow()
if type(runtime.SetAnimationOverride)=="function" then
pcall(runtime.SetAnimationOverride,template.animations and table.clone(template.animations) or nil)
end
if template.animations then
task.spawn(function()
while current==state and enabled and runtimeAlive do
task.wait(1)
local has=runtime.HasAnimationOverride
if current==state and enabled and type(has)=="function" and not has()
and type(runtime.SetAnimationOverride)=="function" then
pcall(runtime.SetAnimationOverride,table.clone(template.animations))
end
end
end)
end
stats.applied=stats.applied+1
return true
end
local copy={on=env.VisualsV2Runtime.WeaponsUnlocked() and C("vv2VisualAvatarCopyItems",false)==true,userId=nil,saved={},applied={},told={},run=0,
roles=nil,rolesAt=-math.huge,
mmv=game.GameId==10413186812 or game.GameId==10769671266 or game.PlaceId==93017634738276 or game.PlaceId==81374640397860}
local COPY_KINDS={
{kind="Knife",word="knife",label="Knives"},
{kind="Gun",word="gun",label="Guns"},
{kind="Effects",word="effect",label="Effects"},
{kind="Pets",word="pet",label="Pets"},
}
function copy.visuals(kind)
if copy.mmv and kind~="Gun" then return nil end
if kind=="Effects" then
local effects=runtime.ClientKnifeEffects
return effects and {get=effects.GetState,select=effects.Select,catalog=effects.Catalog or {}}
elseif kind=="Pets" then
local pets=runtime.ClientPets
return pets and {get=pets.GetState,select=pets.Select,catalog=pets.Catalog or {}}
end
local skins=runtime.ClientWeaponSkins
return skins and {get=function() return skins.GetState(kind) end,select=function(id) return skins.Select(kind,id) end,
catalog=skins.Catalog and skins.Catalog[kind] or {}}
end
function copy.name(kind,id)
local visuals=copy.visuals(kind)
local entry=visuals and visuals.catalog[id]
return type(entry)=="table" and tostring(entry.name or entry.label or id) or tostring(id)
end
function copy.tools(plr)
local list={}
for _,container in ipairs({plr.Character,plr:FindFirstChildOfClass("Backpack")}) do
if container then
for _,tool in ipairs(container:GetChildren()) do if tool:IsA("Tool") then list[#list+1]=tool end end
end
end
return list
end
function copy.toolKind(tool)
local name=tool.Name:lower()
local item=tostring(tool:GetAttribute("ItemType") or ""):lower()
if name:find("knife",1,true) or item=="knife" then return "Knife" end
if name:find("gun",1,true) or name:find("scope",1,true) or item=="gun" then return "Gun" end
end
function copy.display(plr,kind)
local character=plr.Character
if not character then return nil end
local reference=character:FindFirstChild("DisplayRef"..kind)
if reference and reference:IsA("ObjectValue") and reference.Value and reference.Value.Parent then return reference.Value end
for _,name in ipairs({kind.."Display",kind.."Holster"}) do
local object=character:FindFirstChild(name)
if object and not object:IsA("Tool") then return object end
end
local folder=workspace:FindFirstChild("WeaponDisplays")
for _,display in ipairs(folder and folder:GetChildren() or {}) do
if display.Name:lower():find(kind:lower(),1,true) then
local objects={display}
for _,object in ipairs(display:GetDescendants()) do objects[#objects+1]=object end
for _,object in ipairs(objects) do
local ends={}
pcall(function() ends={object.Part0,object.Part1} end)
pcall(function() ends[#ends+1]=object.Attachment0 and object.Attachment0.Parent;ends[#ends+1]=object.Attachment1 and object.Attachment1.Parent end)
for _,part in pairs(ends) do
if typeof(part)=="Instance" and part:IsDescendantOf(character) then return display end
end
end
end
end
end
function copy.gameData(plr)
if os.clock()-copy.rolesAt>4 then
copy.rolesAt=os.clock()
local ok,result=pcall(function()
local remote=game:GetService("ReplicatedStorage"):FindFirstChild("GetPlayerData",true)
if remote and remote:IsA("RemoteFunction") then return remote:InvokeServer() end
end)
if ok and type(result)=="table" then copy.roles=result end
end
local info=type(copy.roles)=="table" and copy.roles[plr.Name]
return type(info)=="table" and info or nil
end
function copy.identify(kind,object)
if typeof(object)~="Instance" then return nil end
local visuals=copy.visuals(kind)
if not visuals then return nil end
for _,target in ipairs({object,object.Parent}) do
if typeof(target)=="Instance" then
for _,name in ipairs({"ItemID","WeaponID","ItemName"}) do
local value=target:GetAttribute(name)
if value~=nil and visuals.catalog[tostring(value)] then return tostring(value) end
end
end
end
local originals=runtime.OriginalVisuals
if originals and type(originals.Identify)=="function" then
local ok,id=pcall(originals.Identify,kind,object)
if ok and id and visuals.catalog[id] then return id end
end
end
function copy.detect(plr)
local found={}
local info=copy.gameData(plr)
if info then
for key,value in pairs(info) do
local name=type(key)=="string" and key:lower() or ""
local kind=(name=="effect" or name=="knifeeffect") and "Effects" or name=="pet" and "Pets"
or name=="knife" and "Knife" or name=="gun" and "Gun" or nil
local visuals=kind and copy.visuals(kind)
if visuals and type(value)=="string" and visuals.catalog[value] then found[kind]=value end
end
end
local knives={}
for _,tool in ipairs(copy.tools(plr)) do
local kind=copy.toolKind(tool)
if kind=="Knife" then knives[#knives+1]=tool end
if kind and not found[kind] then found[kind]=copy.identify(kind,tool) end
end
for _,kind in ipairs({"Knife","Gun"}) do
if not found[kind] then found[kind]=copy.identify(kind,copy.display(plr,kind)) end
end
if not found.Effects then
for _,tool in ipairs(knives) do
found.Effects=copy.identify("Effects",tool)
if found.Effects then break end
end
if not found.Effects then found.Effects=copy.identify("Effects",copy.display(plr,"Knife")) end
end
if not found.Pets then found.Pets=copy.identify("Pets",plr.Character and plr.Character:FindFirstChild("Pet")) end
return found
end
function copy.restore()
for kind,id in pairs(copy.saved) do
local visuals=copy.visuals(kind)
if visuals then
local ok,_,selected=pcall(visuals.get)
if ok and selected==copy.applied[kind] then pcall(visuals.select,id) end
end
end
table.clear(copy.saved);table.clear(copy.applied);table.clear(copy.told)
end
function copy.stop()
copy.run=copy.run+1
copy.userId=nil
copy.restore()
end
function copy.step(run,userId)
local plr=Players:GetPlayerByUserId(userId)
if not plr then
if not copy.told.absent then
copy.told.absent=true
notify("that account isn't in this server, so its weapons, effect and pet can't be copied",0)
end
return
end
copy.told.absent=nil
local found=copy.detect(plr)
if run~=copy.run then return end
local copied,needed,words={},{},{}
for _,spec in ipairs(COPY_KINDS) do
local id=found[spec.kind]
local visuals=id and copy.visuals(spec.kind)
if visuals then
local ok,on,selected=pcall(visuals.get)
if ok and not on then
if copy.told[spec.kind]~=id then
copy.told[spec.kind]=id
needed[#needed+1]=(copy.mmv and spec.kind=="Gun") and "Matrixscope / Voidscope" or spec.label
words[#words+1]=spec.word
end
elseif ok and copy.applied[spec.kind]~=id then
if copy.saved[spec.kind]==nil then copy.saved[spec.kind]=selected or "None" end
local selectedOk,accepted=pcall(visuals.select,id)
if selectedOk and accepted~=false then
copy.applied[spec.kind]=id;copy.told[spec.kind]=nil
copied[#copied+1]=spec.word.." ("..copy.name(spec.kind,id)..")"
end
end
end
end
if #copied>0 then notify("copied "..plr.DisplayName.."'s "..table.concat(copied,", "),2) end
if #needed>0 then
notify("turn on "..table.concat(needed,", ").." in Visual Weapons/Effects to copy "..plr.DisplayName.."'s "..table.concat(words,", "),0)
end
end
function copy.start(userId)
if not copy.on or not enabled or not userId then copy.stop();return end
if copy.userId==userId then return end
copy.stop()
copy.userId=userId
local run=copy.run
task.spawn(function()
while copy.run==run and copy.on and enabled and runtimeAlive do
local ok,problem=pcall(copy.step,run,userId)
if not ok then stats.lastError=tostring(problem) end
task.wait(2)
end
end)
end
local function load(reason)
token=token+1
local mine=token
if not enabled then restore();copy.stop();return end
task.spawn(function()
local userId,why=resolve(target)
if mine~=token then return end
if not userId then notify(why,1);return end
copy.start(userId)
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if not humanoid then return end
local template,problem=buildTemplate(userId,humanoid.RigType,mine)
if mine~=token or not enabled then return end
if not template then stats.lastError=problem;notify(problem,1);return end
local label=target..(tostring(userId)~=target and " ("..userId..")" or "")
local ok,applied,err=pcall(apply,template,label)
if not ok or applied==false then
stats.lastError=tostring(ok and err or applied);notify(stats.lastError,1)
elseif reason=="user" then notify("showing "..label,2) end
end)
end
section:AddTextBox("Username/user ID",function(text)
text=tostring(text or ""):gsub("^%s+",""):gsub("%s+$","")
if text=="" or text==target then return end
target=text
SetCfg("vv2VisualAvatarTarget",target)
if enabled then load("user") end
end)
local toggle=addToggle(section,"Visual Avatar",enabled,function(value)
enabled=value
SetCfg("vv2VisualAvatarEnabled",value)
load(value and "user" or nil)
end)
local copyToggle
if env.VisualsV2Runtime.WeaponsUnlocked() then
copyToggle=addToggle(section,"Copy Their Weapons, Effect & Pet",copy.on,function(value)
copy.on=value
SetCfg("vv2VisualAvatarCopyItems",value)
if not value or not enabled then copy.stop();return end
task.spawn(function()
local userId=resolve(target)
if userId and copy.on and enabled then copy.start(userId) end
end)
end)
section:AddParagraph("Copy Their Weapons, Effect & Pet","While they're in the server with you, their knife, gun, knife effect and pet are picked for you in Visual Weapons/Effects. Each one needs its toggle there on.")
end
local respawn=LocalPlayer.CharacterAdded:Connect(function(character)
restore(enabled)
if not enabled then return end
local deadline=os.clock()+10
while enabled and LocalPlayer.Character==character and os.clock()<deadline do
local humanoid=character:FindFirstChildOfClass("Humanoid")
if character.Parent and humanoid and humanoid.Health>0 and character:FindFirstChild("HumanoidRootPart") then break end
task.wait()
end
if enabled and LocalPlayer.Character==character then load() end
end)
runtime.RegisterReset(function()
toggle:Set(false);if copyToggle then copyToggle:Set(false) end
enabled=false;copy.on=false
token=token+1
restore()
copy.stop()
target=""
if not runtimeAlive then
respawn:Disconnect()
for _,template in pairs(templates) do pcall(function() template.model:Destroy() end) end
table.clear(templates)
end
end)
end,"Section \"Visual Avatar\"")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local espSection = mainTab:AddSection("Distance ESP", "Utilities")
local distanceEspEnabled = C("distanceEspEnabled", false)
local distanceRenderDistance = C("distanceRenderDistance", 200)
local distanceColor = C("distanceColor",Color3.fromRGB(0,0,0))
local distanceTextSize = C("distanceTextSize", 12)
local distancePosition = C("distancePosition", "Bottom")
local distanceObjects = {}
local function distanceOffset()
if distancePosition == "Top" then return Vector3.new(0, 3.25, 0) end
if distancePosition == "Middle" then return Vector3.new(0, 0, 0) end
return Vector3.new(0, -3.0, 0)
end
local function removeDistanceObject(plr)
local gui = distanceObjects[plr]
if gui then gui:Destroy() end
distanceObjects[plr] = nil
end
local function ensureDistanceObject(plr)
if plr == player then return nil end
local char = plr.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if not root then removeDistanceObject(plr); return nil end
local gui = distanceObjects[plr]
if not gui or not gui.Parent then
gui = Instance.new("BillboardGui")
gui.Name = "VisualsV2_DistanceESP"
gui.Size = UDim2.new(0, 100, 0, 26)
gui.StudsOffset = distanceOffset()
gui.AlwaysOnTop = true
gui.Adornee = root
gui.Parent = root
local label = Instance.new("TextLabel")
label.Name = "Distance"
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Font = Enum.Font.Code
label.TextStrokeTransparency = 1
label.TextXAlignment = Enum.TextXAlignment.Center
label.TextYAlignment = Enum.TextYAlignment.Center
label.Parent = gui
distanceObjects[plr] = gui
else
if gui.Adornee ~= root then gui.Adornee = root end
local offset = distanceOffset()
if gui.StudsOffset ~= offset then gui.StudsOffset = offset end
if not gui.AlwaysOnTop then gui.AlwaysOnTop = true end
if gui.Parent ~= root then gui.Parent = root end
end
return gui
end
local function clearDistanceEsp()
for plr in pairs(distanceObjects) do removeDistanceObject(plr) end
end
local distanceToggle = addToggle(espSection, "Enable Distance ESP", distanceEspEnabled, function(state)
distanceEspEnabled = state
SetCfg("distanceEspEnabled", state)
if not state then clearDistanceEsp() end
end)
espSection:AddSlider("Render Distance", 50, 2000, distanceRenderDistance, function(value)
distanceRenderDistance = value
SetCfg("distanceRenderDistance", value)
end)
espSection:AddColorpicker("Distance Color", distanceColor, function(color)
distanceColor = color
SetCfg("distanceColor", color)
end)
espSection:AddSlider("Text Size", 8, 30, distanceTextSize, function(value)
distanceTextSize = value
SetCfg("distanceTextSize", value)
end)
addDropdown(espSection, "Position", {"Top", "Middle", "Bottom"}, distancePosition, function(selected)
distancePosition = selected
SetCfg("distancePosition", selected)
for _, gui in pairs(distanceObjects) do if gui and gui.Parent then gui.StudsOffset = distanceOffset() end end
end)
local distanceLoop
local distanceElapsed = 0
distanceLoop=RunService.RenderStepped:Connect(function(dt)
if not runtimeAlive then distanceLoop:Disconnect();return end
if not distanceEspEnabled then return end
distanceElapsed = distanceElapsed + (tonumber(dt) or 0)
if distanceElapsed < 0.1 then return end
distanceElapsed = 0
local myChar = player.Character
local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
if not myRoot then return end
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= player then
local char = plr.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local humanoid = char and char:FindFirstChildOfClass("Humanoid")
if root and humanoid and humanoid.Health > 0 then
local distance = (root.Position - myRoot.Position).Magnitude
if distance <= distanceRenderDistance then
local gui = ensureDistanceObject(plr)
if gui then
if not gui.Enabled then gui.Enabled = true end
local label = gui:FindFirstChild("Distance")
if label then
local text = "[" .. tostring(math.floor(distance + 0.5)) .. "]"
if label.Text ~= text then label.Text = text end
if label.TextColor3 ~= distanceColor then label.TextColor3 = distanceColor end
if label.TextSize ~= distanceTextSize then label.TextSize = distanceTextSize end
end
end
else
local gui = distanceObjects[plr]
if gui and gui.Enabled then gui.Enabled = false end
end
else
removeDistanceObject(plr)
end
end
end
end)
Players.PlayerRemoving:Connect(removeDistanceObject)
env.VisualsV2Runtime.RegisterReset(function()
distanceToggle:Set(false)
distanceEspEnabled=false
distanceRenderDistance=200
distanceColor=Color3.fromRGB(0,0,0)
distanceTextSize=12
distancePosition="Bottom"
clearDistanceEsp()
end)
end,"Section \"Distance ESP\"")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local runtime=env.VisualsV2Runtime
local Workspace,LocalPlayer=workspace,player
local presets={"ForceField","Flat","Chromatic"}
local groups,states,owners={},{},{}
local heartbeatConnection,renderBound
local chrom_view,chrom_world,chrom_camera,chrom_host
local CHROM_ALPHA=0.025
local FRAME="VisualsV2_ChamsRender"
local BOMB_FORCEFIELD_TEXTURE="rbxassetid://104516981"
local ownedSurfaces=setmetatable({}, {__mode="k"})
local resetting=false
local function chrom_ensure()
if chrom_world and chrom_world.Parent then return end
local host=Instance.new("ScreenGui")
host.Name="VisualsV2_ChamsViewport"
host.Enabled=true
host.ResetOnSpawn=false
host.IgnoreGuiInset=true
host.DisplayOrder=100
pcall(function() host.ScreenInsets=Enum.ScreenInsets.None;host.ClipToDeviceSafeArea=false end)
local gui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
if gui then host.Parent=gui
else pcall(function() host.Parent=gethui and gethui() or game:GetService("CoreGui") end) end
chrom_host=host
chrom_view=Instance.new("ViewportFrame")
chrom_view.Size=UDim2.fromScale(1,1)
chrom_view.Position=UDim2.fromScale(0,0)
chrom_view.BackgroundTransparency=1
chrom_view.Active=false
pcall(function() chrom_view.Interactable=false end)
chrom_view.BorderSizePixel=0
chrom_view.Ambient=Color3.new(1,1,1)
chrom_view.LightColor=Color3.new(1,1,1)
chrom_view.LightDirection=Vector3.new(-1,-1,-1)
chrom_view.ZIndex=999
chrom_view.Visible=true
chrom_view.Parent=host
chrom_camera=Instance.new("Camera")
chrom_camera.Name="ToolChamsCamera"
chrom_camera.Parent=chrom_view
chrom_view.CurrentCamera=chrom_camera
local sky=game:GetService("Lighting"):FindFirstChildOfClass("Sky")
if sky then pcall(function() sky:Clone().Parent=chrom_view end) end
chrom_world=Instance.new("WorldModel")
chrom_world.Parent=chrom_view
end
local function deformable(part)
if part:FindFirstChildWhichIsA("WrapLayer") or part:FindFirstChildWhichIsA("Bone") then return true end
local ok,value=pcall(function() return part.HasSkinnedMesh end)
return ok and value==true
end
local function shell(source)
local archivable=source.Archivable
if not archivable and not pcall(function() source.Archivable=true end) then return end
local ok,clone=pcall(function() return source:Clone() end)
if not archivable then pcall(function() source.Archivable=archivable end) end
if not ok or not clone then return end
for _,child in ipairs(clone:GetChildren()) do
if not child:IsA("DataModelMesh") then child:Destroy() end
end
clone.Anchored=true
clone.CanCollide=false;clone.CanQuery=false;clone.CanTouch=false
clone.Massless=true;clone.CastShadow=false
clone.LocalTransparencyModifier=0
clone.Material=Enum.Material.Foil
clone.MaterialVariant=""
clone.Reflectance=0.12
pcall(function() clone.TextureID="" end)
local mesh=clone:FindFirstChildWhichIsA("DataModelMesh")
if mesh then
pcall(function() mesh.TextureId="";mesh.VertexColor=Vector3.new(1,1,1) end)
end
return clone
end
local function restore_hidden(entry)
if entry.connection then entry.connection:Disconnect();entry.connection=nil end
if entry.hidden then
entry.writing=true
pcall(function() entry.source.LocalTransparencyModifier=entry.nativeAlpha end)
entry.writing=false;entry.hidden=false
end
end
local function hide_source(entry)
local source=entry.source
if entry.hidden then
if source.LocalTransparencyModifier~=1 then
entry.nativeAlpha=source.LocalTransparencyModifier
entry.writing=true;source.LocalTransparencyModifier=1;entry.writing=false
end
return
end
entry.nativeAlpha=source.LocalTransparencyModifier
entry.hidden=true
entry.connection=source:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
if entry.writing or not entry.hidden then return end
local alpha=source.LocalTransparencyModifier
if alpha==1 then return end
entry.nativeAlpha=alpha
entry.writing=true;source.LocalTransparencyModifier=1;entry.writing=false
end)
entry.writing=true;source.LocalTransparencyModifier=1;entry.writing=false
end
local function chrom_clear(state)
for _,entry in ipairs(state.entries or {}) do restore_hidden(entry) end
if state.model then state.model:Destroy() end
state.model,state.entries=nil,nil
end
local WHITE=Vector3.new(1,1,1)
local function same(a,b)
if a==b then return true end
if typeof(a)=="Color3" and typeof(b)=="Color3" then
return math.abs(a.R-b.R)<0.0025 and math.abs(a.G-b.G)<0.0025 and math.abs(a.B-b.B)<0.0025
end
return false
end
local function set(object,property,value)
if not same(object[property],value) then object[property]=value end
end
local function copyMesh(mesh,other)
set(other,"Scale",mesh.Scale);set(other,"Offset",mesh.Offset)
end
local function copyFieldOfViewMode(camera)
set(chrom_camera,"FieldOfViewMode",camera.FieldOfViewMode)
end
local function chrom_sync(state)
local ready=chrom_host and chrom_host.Parent and chrom_host.Enabled
and chrom_view and chrom_view.Visible and chrom_world and chrom_world.Parent
and Workspace.CurrentCamera~=nil
for _,entry in ipairs(state.entries or {}) do
local source,clone=entry.source,entry.clone
if ready and source.Parent and clone.Parent then
clone.CFrame=source.CFrame
set(clone,"Size",source.Size)
local mesh,other=entry.mesh,entry.otherMesh
if mesh and other and mesh.Parent==source then pcall(copyMesh,mesh,other) end
hide_source(entry)
local alpha=1-(1-source.Transparency)*(1-entry.nativeAlpha)
set(clone,"Transparency",1-(1-CHROM_ALPHA)*(1-alpha))
else
set(clone,"Transparency",1)
restore_hidden(entry)
end
end
end
local function chrom_apply(state,color)
if not state.chrom.model or not state.chrom.model.Parent or not chrom_world or not chrom_world.Parent then
chrom_clear(state.chrom)
chrom_ensure()
local model=Instance.new("Model")
model.Name="VisualsV2_ChromaticTool"
local entries={}
for _,source in ipairs(state.parts) do
local clone=not deformable(source) and shell(source) or nil
if clone then
clone.Color=color;clone.CFrame=source.CFrame
clone.Transparency=1
clone.Parent=model
entries[#entries+1]={source=source,clone=clone,
mesh=source:FindFirstChildWhichIsA("DataModelMesh") or false,
otherMesh=clone:FindFirstChildWhichIsA("DataModelMesh") or false}
end
end
model.Parent=chrom_world
state.chrom.model,state.chrom.entries=model,entries
end
for _,entry in ipairs(state.chrom.entries) do set(entry.clone,"Color",color) end
chrom_sync(state.chrom)
end
local function appearance_restore(state)
for part,data in pairs(state.cache) do
pcall(function()
local keepSkin=state.owner==LocalPlayer and runtimeAlive and not configResetting and C("ffEnabled",false)
if not keepSkin then part.Material=data.material;part.Color=data.color
else
local saved=part:GetAttribute("VisualsV2_OriginalMaterial")
if saved=="ForceField" and data.material~=Enum.Material.ForceField then
part:SetAttribute("VisualsV2_OriginalMaterial",data.material.Name)
end
end
part.MaterialVariant=data.variant
part.Reflectance=data.reflectance
if data.texture~=nil then part.TextureID=data.texture end
if data.pinnedPhysics and part.CustomPhysicalProperties==data.pinnedPhysics then
part.CustomPhysicalProperties=data.customPhysics
end
end)
end
for mesh,data in pairs(state.meshCache) do
pcall(function() if data.texture~=nil then mesh.TextureId=data.texture end end)
pcall(function() if data.color~=nil then mesh.VertexColor=data.color end end)
end
for decal,alpha in pairs(state.decalCache) do pcall(function() decal.Transparency=alpha end) end
for surface,parent in pairs(state.surf) do
pcall(function() surface.Parent=parent end)
ownedSurfaces[surface]=nil
end
state.cache,state.meshCache,state.decalCache,state.surf={},{},{},{}
end
local function apply_decal(state,decal)
if state.decalCache[decal]==nil then state.decalCache[decal]=decal.Transparency end
set(decal,"Transparency",1)
end
local function apply_mesh(state,mesh)
local preset=state.preset
local data=state.meshCache[mesh]
if not data then
data={}
pcall(function() data.texture=mesh.TextureId end)
pcall(function() data.color=mesh.VertexColor end)
state.meshCache[mesh]=data
end
if preset~="ForceField" or state.bombMask then
pcall(set,mesh,"TextureId",preset=="ForceField" and BOMB_FORCEFIELD_TEXTURE or "")
end
if preset~="ForceField" or state.teddy then
pcall(set,mesh,"VertexColor",WHITE)
end
end
local function apply_part(state,part)
local preset,color=state.preset,state.color
local data=state.cache[part]
if not data then
data={material=part.Material,color=part.Color,reflectance=part.Reflectance,variant=part.MaterialVariant}
local saved=part:GetAttribute("VisualsV2_OriginalMaterial")
if state.owner==LocalPlayer and saved and Enum.Material[saved] then data.material=Enum.Material[saved] end
pcall(function() data.texture=part.TextureID end)
local ok,physics=pcall(function() return part.CurrentPhysicalProperties end)
if ok and typeof(physics)=="PhysicalProperties" and part.CustomPhysicalProperties==nil then
data.customPhysics=part.CustomPhysicalProperties
if pcall(function() part.CustomPhysicalProperties=physics end) then data.pinnedPhysics=physics end
end
state.cache[part]=data
end
set(part,"Color",color);set(part,"MaterialVariant","")
if preset=="ForceField" then
set(part,"Material",Enum.Material.ForceField)
if state.bombMask then
set(part,"Reflectance",0)
if data.texture~=nil then set(part,"TextureID",BOMB_FORCEFIELD_TEXTURE) end
end
else
set(part,"Material",preset=="Flat" and Enum.Material.SmoothPlastic or Enum.Material.Foil)
set(part,"Reflectance",preset=="Flat" and 0 or 0.12)
if data.texture~=nil then set(part,"TextureID","") end
end
end
local function appearance_apply(state,color)
state.color=color
for _,surface in ipairs(state.surfaces) do
if surface.Parent and not state.surf[surface] then
state.surf[surface]=surface.Parent;ownedSurfaces[surface]=true;surface.Parent=nil
end
end
for _,decal in ipairs(state.decals) do apply_decal(state,decal) end
for _,mesh in ipairs(state.meshes) do apply_mesh(state,mesh) end
for _,part in ipairs(state.parts) do apply_part(state,part) end
end
local watchedProperties={Color=true,Material=true,MaterialVariant=true,Reflectance=true,TextureID=true,
TextureId=true,VertexColor=true,Transparency=true}
local function watchState(state)
local function bind(object,applier)
state.connections[#state.connections+1]=object.Changed:Connect(function(property)
if state.cleared or resetting or not watchedProperties[property] then return end
if property=="Color" and applier==apply_part and same(object.Color,state.color) then return end
pcall(applier,state,object)
end)
end
for _,part in ipairs(state.parts) do bind(part,apply_part) end
for _,mesh in ipairs(state.meshes) do bind(mesh,apply_mesh) end
for _,decal in ipairs(state.decals) do bind(decal,apply_decal) end
end
local function flat_apply(state,color)
if not state.flat.highlight then
local hl=Instance.new("Highlight")
hl.Name="VisualsV2_FlatTool"
hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
hl.OutlineTransparency=1
hl.FillTransparency=0
hl.Adornee=state.tool
hl.Parent=Workspace
state.flat.highlight=hl
end
set(state.flat.highlight,"FillColor",color)
end
local function recolor(state,color)
state.color=color
for _,part in ipairs(state.parts) do set(part,"Color",color) end
if state.flat.highlight then set(state.flat.highlight,"FillColor",color) end
for _,entry in ipairs(state.chrom.entries or {}) do set(entry.clone,"Color",color) end
end
local function clear_state(state)
state.cleared=true
for _,connection in ipairs(state.connections) do connection:Disconnect() end
table.clear(state.connections)
if state.flat.highlight then state.flat.highlight:Destroy();state.flat.highlight=nil end
chrom_clear(state.chrom)
appearance_restore(state)
end
local function presetName(value)
if type(value)=="table" then value=value[1] end
for _,preset in ipairs(presets) do if value==preset then return value end end
return "ForceField"
end
local function groupFor(tool,other)
if not tool or not tool:IsA("Tool") then return nil end
for _,group in ipairs(groups) do
local enabled=other and group.othersEnabled or (not other and group.enabled)
if enabled and not group.collect and group.matches(tool) then return group end
end
end
local function clear_owner(owner)
for tool,state in pairs(states) do
if state.owner==owner then clear_state(state);states[tool]=nil end
end
end
local function active()
for _,group in ipairs(groups) do if group.enabled or group.othersEnabled then return true end end
return false
end
local function clear_viewport()
for _,state in pairs(states) do chrom_clear(state.chrom) end
if chrom_host then chrom_host:Destroy() end
chrom_host,chrom_view,chrom_world,chrom_camera=nil,nil,nil,nil
end
local playerConnections={}
local scanDue,nextScan=true,0
local renderChromatic=false
local function stopWatching()
if heartbeatConnection then heartbeatConnection:Disconnect();heartbeatConnection=nil end
if renderBound then RunService:UnbindFromRenderStep(FRAME);renderBound=false end
for _,connection in ipairs(playerConnections) do connection:Disconnect() end
table.clear(playerConnections)
renderChromatic=false
for tool,state in pairs(states) do clear_state(state);states[tool]=nil end
for owner,record in pairs(owners) do
for _,connection in ipairs(record.connections) do connection:Disconnect() end
owners[owner]=nil
end
clear_viewport()
end
local function bind_owner(owner)
local char=owner.Character
local record=owners[owner]
if not record or record.char~=char then
clear_owner(owner)
if record then for _,connection in ipairs(record.connections) do connection:Disconnect() end end
record={char=char,dirty=true,connections={}}
owners[owner]=record
if char then
local function changed(object)
if record.dirty then return end
local tool=object:IsA("Tool")
if not tool and not object:FindFirstAncestorWhichIsA("Tool") then return end
if tool or object:IsA("BasePart") or object:IsA("DataModelMesh")
or object:IsA("Bone") or object:IsA("WrapLayer") or object:IsA("Decal")
or (object:IsA("SurfaceAppearance") and not ownedSurfaces[object]) then record.dirty=true end
end
record.connections[1]=char.DescendantAdded:Connect(changed)
record.connections[2]=char.DescendantRemoving:Connect(changed)
end
end
return record
end
local function update()
if resetting or not runtimeAlive then return end
if not active() then stopWatching();return end
local seenOwners,seenTools={},{}
local list={LocalPlayer}
local needsOthers=false
for _,group in ipairs(groups) do if group.othersEnabled then needsOthers=true;break end end
if needsOthers then
for _,owner in ipairs(Players:GetPlayers()) do if owner~=LocalPlayer then list[#list+1]=owner end end
end
for _,owner in ipairs(list) do
if owner.Parent then
seenOwners[owner]=true
local record=bind_owner(owner)
if record.dirty then clear_owner(owner);record.dirty=false end
if record.char then
local candidates={}
for _,tool in ipairs(record.char:GetChildren()) do
local group=groupFor(tool,owner~=LocalPlayer)
if group then candidates[#candidates+1]={tool,group} end
end
for _,group in ipairs(groups) do
if group.collect and (owner==LocalPlayer and group.enabled or owner~=LocalPlayer and group.othersEnabled) then
local found,objects=pcall(group.collect,owner,record.char)
if found and type(objects)=="table" then
for _,object in ipairs(objects) do
if typeof(object)=="Instance" and object.Parent then candidates[#candidates+1]={object,group} end
end
end
end
end
for _,candidate in ipairs(candidates) do
local tool,group=candidate[1],candidate[2]
if group then
seenTools[tool]=true
local state=states[tool]
if state and (state.group~=group or state.preset~=group.preset) then
clear_state(state);states[tool]=nil;state=nil
end
if not state then
local name=tool.Name:lower():gsub("[^%w]","")
local teddy=name:find("teddy",1,true)~=nil
state={tool=tool,owner=owner,group=group,preset=group.preset,flat={},chrom={},cache={},
surf={},meshCache={},decalCache={},parts={},surfaces={},meshes={},decals={},connections={},
teddy=teddy,bombMask=teddy or name:find("spray",1,true)~=nil or name:find("graffiti",1,true)~=nil}
local objects=tool:GetDescendants()
if tool:IsA("BasePart") then table.insert(objects,1,tool) end
for _,object in ipairs(objects) do
if object:IsA("BasePart") then state.parts[#state.parts+1]=object
elseif object:IsA("SurfaceAppearance") then state.surfaces[#state.surfaces+1]=object
elseif object:IsA("DataModelMesh") then state.meshes[#state.meshes+1]=object
elseif object:IsA("Decal") then state.decals[#state.decals+1]=object end
end
states[tool]=state
end
if #state.parts>0 then
local color=group.color()
appearance_apply(state,color)
if group.preset=="Flat" then flat_apply(state,color)
elseif group.preset=="Chromatic" then chrom_apply(state,color) end
if not state.watching then state.watching=true;watchState(state) end
end
end
end
end
end
end
for tool,state in pairs(states) do if not seenTools[tool] then clear_state(state);states[tool]=nil end end
for owner,record in pairs(owners) do
if not seenOwners[owner] then
for _,connection in ipairs(record.connections) do connection:Disconnect() end
owners[owner]=nil
end
end
local hasChromatic=false
for _,state in pairs(states) do if state.chrom.model then hasChromatic=true;break end end
renderChromatic=hasChromatic
if not hasChromatic then clear_viewport() end
end
local function step()
if resetting or not runtimeAlive then return end
if not scanDue then
for owner,record in pairs(owners) do
if record.dirty or owner.Character~=record.char then scanDue=true;break end
end
end
local now=os.clock()
if scanDue or now>=nextScan then
scanDue,nextScan=false,now+0.5
update()
return
end
for _,state in pairs(states) do
if state.group.rainbow and not state.cleared then recolor(state,state.group.color()) end
end
end
local function refresh()
if resetting or not runtimeAlive then return end
for _,record in pairs(owners) do record.dirty=true end
if active() and not heartbeatConnection then
heartbeatConnection=RunService.Heartbeat:Connect(step)
playerConnections[1]=Players.PlayerAdded:Connect(function() scanDue=true end)
playerConnections[2]=Players.PlayerRemoving:Connect(function() scanDue=true end)
RunService:BindToRenderStep(FRAME,Enum.RenderPriority.Last.Value+1,function()
if not renderChromatic then return end
local camera=Workspace.CurrentCamera
if camera and chrom_camera then
chrom_camera.CFrame=camera.CFrame
set(chrom_camera,"FieldOfView",camera.FieldOfView)
pcall(copyFieldOfViewMode,camera)
end
for _,state in pairs(states) do
if state.chrom.entries then chrom_sync(state.chrom) end
end
end)
renderBound=true
end
update()
scanDue,nextScan=false,os.clock()+0.5
if type(runtime.RefreshToolTint)=="function" then runtime.RefreshToolTint() end
end
runtime.ToolForceFieldActive=function(tool)
local group=groupFor(tool,false)
return group and group.key=="toolChams" and group.preset=="ForceField" or false
end
runtime.ToolChamsActive=function(tool)
local group=groupFor(tool,false)
return group and group.key=="toolChams" or false
end
runtime.RegisterChamsFeature=function(section,key,label,matches,collect)
local group={key=key,matches=matches,collect=collect,enabled=C(key.."Enabled",false),
othersEnabled=C(key.."OthersEnabled",false),preset=presetName(C(key.."Preset","ForceField")),
colorValue=C(key.."Color",Color3.fromRGB(255,200,0)),rainbow=C(key.."Rainbow",false),
rainbowSpeed=math.clamp(tonumber(C(key.."RainbowSpeed",3)) or 3,1,10)}
group.color=function()
if group.rainbow then return Color3.fromHSV((os.clock()*(group.rainbowSpeed*0.1))%1,1,1) end
return group.colorValue
end
groups[#groups+1]=group
group.toggle=addToggle(section,label.." Chams",group.enabled,function(value)
group.enabled=value;SetCfg(key.."Enabled",value);refresh()
end)
group.othersToggle=addToggle(section,label.." Chams Others",group.othersEnabled,function(value)
group.othersEnabled=value;SetCfg(key.."OthersEnabled",value);refresh()
end)
group.dropdown=addDropdown(section,label.." Chams Preset",presets,group.preset,function(value)
group.preset=presetName(value);SetCfg(key.."Preset",group.preset);refresh()
end)
section:AddColorpicker(label.." Chams Color",group.colorValue,function(color)
group.colorValue=color;SetCfg(key.."Color",color);update()
end)
group.rainbowToggle=addToggle(section,"Rainbow "..label.." Chams",group.rainbow,function(value)
group.rainbow=value;SetCfg(key.."Rainbow",value);update()
end)
section:AddSlider(label.." Chams Rainbow Speed",1,10,group.rainbowSpeed,function(value)
group.rainbowSpeed=math.clamp(tonumber(value) or 3,1,10)
SetCfg(key.."RainbowSpeed",group.rainbowSpeed);update()
end)
if group.enabled or group.othersEnabled then refresh() end
end
runtime.RegisterReset(function()
resetting=true
for _,group in ipairs(groups) do
group.enabled=false;group.othersEnabled=false;group.rainbow=false
group.toggle:Set(false);group.othersToggle:Set(false);group.rainbowToggle:Set(false)
end
stopWatching()
resetting=false
end)
end,"Part at line 8546")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local runtime=env.VisualsV2Runtime
local groups={}
local states={}
local renderBound=false
local scanConnection
local NAME="VisualsV2_ToolOutline"
local FRAME="VisualsV2_ToolOutlineRender"
local PUSH=1.5
local function visibleNow(part)
return part.Parent~=nil and part.Transparency<1 and part.LocalTransparencyModifier<1
end
local function clearState(state)
if state.model then pcall(function() state.model:Destroy() end) end
state.model=nil;state.entries=nil
end
local function deformable(part)
if part:FindFirstChildWhichIsA("WrapLayer") or part:FindFirstChildWhichIsA("Bone") then return true end
local ok,value=pcall(function() return part.HasSkinnedMesh end)
return ok and value==true
end
local function buildState(state)
clearState(state)
local model=Instance.new("Model")
model.Name=NAME
local entries={}
local sources={}
if state.object:IsA("BasePart") then sources[1]=state.object end
for _,part in ipairs(state.object:GetDescendants()) do
if part:IsA("BasePart") and not part:GetAttribute("VisualsV2_ToolOutlineShell") then sources[#sources+1]=part end
end
for _,source in ipairs(sources) do
if not deformable(source) then
local archivable=source.Archivable
if not archivable then pcall(function() source.Archivable=true end) end
local ok,copy=pcall(function() return source:Clone() end)
if not archivable then pcall(function() source.Archivable=archivable end) end
if ok and copy then
for _,child in ipairs(copy:GetChildren()) do
if not child:IsA("DataModelMesh") then child:Destroy() end
end
copy:SetAttribute("VisualsV2_ToolOutlineShell",true)
copy.Anchored=true;copy.CanCollide=false;copy.CanQuery=false;copy.CanTouch=false
copy.Massless=true;copy.CastShadow=false;copy.LocalTransparencyModifier=0
copy.Material=Enum.Material.SmoothPlastic;copy.Reflectance=0
pcall(function() copy.MaterialVariant="" end)
pcall(function() copy.TextureID="" end)
local mesh=copy:FindFirstChildWhichIsA("DataModelMesh")
if mesh then pcall(function() mesh.TextureId="";mesh.VertexColor=Vector3.new(1,1,1) end) end
copy.Parent=model
entries[#entries+1]={source=source,shell=copy,mesh=mesh,
fileMesh=mesh and mesh:IsA("SpecialMesh") and mesh.MeshType==Enum.MeshType.FileMesh,
scale=mesh and mesh.Scale or nil,offset=mesh and mesh.Offset or nil,lastK=nil}
end
end
end
local highlight=Instance.new("Highlight")
highlight.Name="VisualsV2_ToolOutlineFill"
highlight.DepthMode=Enum.HighlightDepthMode.Occluded
highlight.FillTransparency=0
highlight.OutlineTransparency=0
highlight.Adornee=model
highlight.Parent=model
model.Parent=workspace
state.model,state.entries,state.highlight=model,entries,highlight
state.count=#sources
end
local function render()
local camera=workspace.CurrentCamera
if not camera then return end
local eye=camera.CFrame.Position
for object,state in pairs(states) do
if state.model and state.entries then
local group=state.group
local color=group.color
local thickness=group.thickness
local pivot
local ok=pcall(function() pivot=object:IsA("BasePart") and object.Position or object:GetPivot().Position end)
local distance=ok and pivot and math.max((pivot-eye).Magnitude,0.5) or 10
local k=(distance+PUSH)/distance
if state.highlight.FillColor~=color then state.highlight.FillColor=color;state.highlight.OutlineColor=color end
for _,entry in ipairs(state.entries) do
local source,shell=entry.source,entry.shell
if visibleNow(source) then
local position=eye+(source.Position-eye)*k
shell.CFrame=CFrame.new(position)*source.CFrame.Rotation
local size=source.Size
local grown=size*k+Vector3.new(2,2,2)*thickness*k
if not entry.lastK or math.abs(entry.lastK-k)>0.002 or entry.lastT~=thickness or entry.lastSize~=size then
entry.lastK,entry.lastT,entry.lastSize=k,thickness,size
if entry.fileMesh then
local factor=Vector3.new(grown.X/math.max(size.X,0.001),grown.Y/math.max(size.Y,0.001),grown.Z/math.max(size.Z,0.001))
pcall(function() entry.mesh.Scale=entry.scale*factor;entry.mesh.Offset=entry.offset*k end)
else
shell.Size=grown
end
end
if shell.Color~=color then shell.Color=color end
if shell.Transparency~=0 then shell.Transparency=0 end
elseif shell.Transparency~=1 then
shell.Transparency=1
end
end
end
end
end
local function active()
for _,group in ipairs(groups) do if group.enabled or group.othersEnabled then return true end end
return false
end
local function groupFor(tool,other)
for _,group in ipairs(groups) do
if (other and group.othersEnabled or not other and group.enabled) and group.matches(tool) then return group end
end
end
local function scan()
if not runtimeAlive then return end
local seen={}
local owners={LocalPlayer}
local others=false
for _,group in ipairs(groups) do if group.othersEnabled then others=true end end
if others then
for _,plr in ipairs(Players:GetPlayers()) do if plr~=LocalPlayer then owners[#owners+1]=plr end end
end
for _,owner in ipairs(owners) do
local character=owner.Character
if character then
for _,tool in ipairs(character:GetChildren()) do
if tool:IsA("Tool") then
local group=groupFor(tool,owner~=LocalPlayer)
if group then
seen[tool]=true
local state=states[tool]
if not state then state={object=tool,group=group};states[tool]=state end
state.group=group
local count=0
for _,part in ipairs(tool:GetDescendants()) do if part:IsA("BasePart") then count=count+1 end end
if not state.model or not state.model.Parent or state.count~=count then buildState(state) end
end
end
end
end
end
for object,state in pairs(states) do
if not seen[object] then clearState(state);states[object]=nil end
end
end
local function refresh()
if active() and runtimeAlive then
if not renderBound then
RunService:BindToRenderStep(FRAME,Enum.RenderPriority.Camera.Value+2,function()
pcall(render)
end)
renderBound=true
end
if not scanConnection then
local elapsed=0
scanConnection=RunService.Heartbeat:Connect(function(dt)
elapsed=elapsed+dt
if elapsed<0.25 then return end
elapsed=0
pcall(scan)
end)
end
pcall(scan)
else
if renderBound then RunService:UnbindFromRenderStep(FRAME);renderBound=false end
if scanConnection then scanConnection:Disconnect();scanConnection=nil end
for object,state in pairs(states) do clearState(state);states[object]=nil end
end
end
runtime.RegisterOutlineFeature=function(section,key,label,matches)
local group={key=key,matches=matches,enabled=C(key.."Enabled",false)==true,othersEnabled=C(key.."OthersEnabled",false)==true,
color=C(key.."Color",Color3.fromRGB(255,200,0)),
thickness=math.clamp(tonumber(C(key.."Thickness",3)) or 3,1,10)*0.025}
groups[#groups+1]=group
group.toggle=addToggle(section,label.." Outline",group.enabled,function(value)
group.enabled=value;SetCfg(key.."Enabled",value);refresh()
end)
group.othersToggle=addToggle(section,label.." Outline Others",group.othersEnabled,function(value)
group.othersEnabled=value;SetCfg(key.."OthersEnabled",value);refresh()
end)
section:AddColorpicker(label.." Outline Color",group.color,function(color)
group.color=color;SetCfg(key.."Color",color)
end)
section:AddSlider(label.." Outline Thickness",1,10,group.thickness/0.025,function(value)
local level=math.clamp(tonumber(value) or 3,1,10)
group.thickness=level*0.025;SetCfg(key.."Thickness",level)
end)
if group.enabled or group.othersEnabled then task.defer(refresh) end
return group
end
runtime.RegisterReset(function()
for _,group in ipairs(groups) do
group.enabled=false;group.othersEnabled=false
pcall(function() group.toggle:Set(false);group.othersToggle:Set(false) end)
end
refresh()
end)
end,"Part at line 9131")
;vv2Section(function()
-- Batch/initialization work retains virtualization with the documented fast preset.
LPH_ATTRIBUTES(PRESET(FAST))
if not inMurderMystery then return end
local scopeOnly=game.GameId==10413186812 or game.GameId==10769671266 or game.PlaceId==93017634738276 or game.PlaceId==81374640397860
local data={weapons={Gun={},Knife={}},effects={},effectInfo={},pets={},deathEffects={},metadata={Gun={},Knife={},Effects={},Pets={}},gunBehavior={}}
local raw={}
local scopeMeshes={["15374602183"]=true,["15374679651"]=true,["79692502167966"]=true}
local nativeIcons={Gun={"196751820"},Knife={"196750384"}}
local scopeHoldAnimations={["MM2"]="rbxassetid://15666234025",["MMV"]="rbxassetid://134818020160275"}
local DATA_VERSION="14c6d8946038"
local DATA_FILE="VisualsV2_Data.txt"
local DATA_URL=type(env.VisualsV2DataUrl)=="string" and env.VisualsV2DataUrl
or "https://raw.githubusercontent.com/genshinplayer01234-cyber/WorldV2DEV/refs/heads/visuals/VisualsV2Data.txt"
;(function()
-- (the weapon, effect and pet data is only read or downloaded once the unlock password is in)
if scopeOnly or not env.VisualsV2Runtime.WeaponsUnlocked() then return end
local function parse(text)
if type(text)~="string" or #text<64 then return nil end
local header=text:sub(1,(text:find("\n",1,true) or 1)-1)
local format,version,count=header:match("^VV2DATA\t(%d+)\t([%w%-]+)\t(%d+)\r?$")
count=tonumber(count)
if format~="1" or not count then return nil end
if tonumber(text:sub(-48):match("\nEND\t(%d+)\r?\n?$"))~=count then return nil end
local records={}
for path,id,json in text:gmatch("\n([%w%.]+)\t([^\t\r\n]+)\t([^\r\n]+)") do
records[#records+1]={path,id,json}
end
if #records~=count then return nil end
return records,version
end
local function download(url)
local ok,body=pcall(function() return game:HttpGet(url) end)
if ok and type(body)=="string" and #body>0 then return body end
local send=env.request or env.http_request or (type(env.syn)=="table" and env.syn.request)
if type(send)=="function" then
local sent,response=pcall(send,{Url=url,Method="GET"})
if sent and type(response)=="table" and type(response.Body)=="string" and #response.Body>0
and (response.StatusCode==nil or response.StatusCode==200) then return response.Body end
end
end
local saved,savedVersion
local readOk,text=pcall(function() return isfile(DATA_FILE) and readfile(DATA_FILE) or nil end)
if readOk and text then saved,savedVersion=parse(text) end
text=nil
local records,version,source
if saved and savedVersion==DATA_VERSION then
records,version,source=saved,savedVersion,"saved copy"
else
pcall(shared.Notify,saved and "Visuals V2: updating its weapon models..."
or "Visuals V2: downloading its weapon models (only the first time)...",3)
local body=download(DATA_URL.."?v="..DATA_VERSION)
local fresh,freshVersion
if body then fresh,freshVersion=parse(body) end
if fresh then
pcall(writefile,DATA_FILE,body)
records,version,source=fresh,freshVersion,"downloaded"
elseif saved then
records,version,source=saved,savedVersion,"older saved copy"
end
end
if not records then
task.delay(4,function()
if runtimeAlive then
pcall(shared.Notify,"Visuals V2: couldn't download its weapon, effect and pet models. Check your connection and execute again.",0)
end
end)
return
end
for _,record in ipairs(records) do
local path,id,json=record[1],record[2],record[3]
local group,kind=path:match("^(%w+)%.?(%w*)$")
local target=data[group]
if kind~="" and type(target)=="table" then target=target[kind] end
if type(target)=="table" then
if group=="weapons" or group=="effects" or group=="pets" or group=="deathEffects" then
target[id]=function() return HttpService:JSONDecode(json) end
if group~="deathEffects" then raw[path]=raw[path] or {};raw[path][id]=json end
else
local ok,value=pcall(HttpService.JSONDecode,HttpService,json)
if ok and type(value)=="table" then target[id]=value end
end
end
end
end)()
;(function()
data.weapons.Gun["Matrixscope"]=function() local record={["nodes"]={{["nodeId"]=0,["class"]="Tool",["name"]="Gun",["properties"]={["Enabled"]=true,["CanBeDropped"]=false,["RequiresHandle"]=true,["Grip"]={["type"]="CFrame",["v"]={0.0103258,-0.87381929,-1.2e-07,-2.086e-05,0.681961,0.73138851,8.23e-06,0.73138857,-0.681961,-0.99999994,-8.23e-06,-2.086e-05}},["TextureId"]="http://www.roblox.com/asset/?id=120253087642585"},["attributes"]={["ItemName"]="Matrixscope",["ItemType"]="Gun",["Event"]="Halloween",["IsWeapon"]=true,["Image"]="http://www.roblox.com/asset/?id=120253087642585",["ItemID"]="Matrixscope",["Year"]="2025",["Rarity"]="Secret",["FX"]=true,["IsGun"]=true}},{["nodeId"]=1,["parentId"]=0,["class"]="Animation",["name"]="CustomHold",["properties"]={["AnimationId"]="rbxassetid://134818020160275"}},{["nodeId"]=2,["parentId"]=0,["class"]="MeshPart",["name"]="Handle",["properties"]={["Reflectance"]=0,["TextureID"]="rbxassetid://115264692533866",["MeshId"]="rbxassetid://79692502167966",["Size"]={["type"]="Vector3",["v"]={3.16730452,3.31923461,0.3006956}},["CFrame"]={["type"]="CFrame",["v"]={0,0,0,1,0,0,0,1,0,0,0,1}},["Transparency"]=0,["Color"]={["type"]="Color3",["v"]={0.97254902,0.97254902,0.97254902}},["MeshSize"]={["type"]="Vector3",["v"]={3.84698772,4.03152084,0.36522293}},["Material"]="Enum.Material.Brick"}},{["nodeId"]=6,["parentId"]=0,["class"]="Folder",["name"]="Sounds",["properties"]={}},{["nodeId"]=7,["parentId"]=0,["class"]="Folder",["name"]="Animations",["properties"]={}},{["nodeId"]=8,["parentId"]=2,["class"]="Sound",["name"]="AltSound",["properties"]={["RollOffMinDistance"]=9.17886162,["RollOffMode"]="Enum.RollOffMode.Inverse",["Looped"]=false,["PlaybackSpeed"]=1,["RollOffMaxDistance"]=9178.86230469,["Volume"]=0.5,["SoundId"]="rbxassetid://130113322"}},{["nodeId"]=9,["parentId"]=2,["class"]="Sound",["name"]="CustomReload",["properties"]={["RollOffMinDistance"]=9.17886162,["RollOffMode"]="Enum.RollOffMode.Inverse",["Looped"]=false,["PlaybackSpeed"]=0.80000001,["RollOffMaxDistance"]=9178.86230469,["Volume"]=0.5,["SoundId"]="rbxassetid://130113370"}},{["nodeId"]=10,["parentId"]=2,["class"]="Attachment",["name"]="CustomAttachment",["properties"]={["CFrame"]={["type"]="CFrame",["v"]={0.10695,0,0.06175,0,-1,0,0,0,-1,1,0,0}}}},{["nodeId"]=11,["parentId"]=2,["class"]="Beam",["name"]="CustomBeam",["properties"]={["Enabled"]=true,["FaceCamera"]=false,["Color"]={["type"]="ColorSequence",["points"]={{["value"]={["type"]="Color3",["v"]={0,1,0}},["time"]=0},{["value"]={["type"]="Color3",["v"]={0,1,0}},["time"]=1}}},["Width0"]=0.2,["Transparency"]={["type"]="NumberSequence",["points"]={{["value"]=0,["time"]=0,["envelope"]=0},{["value"]=0,["time"]=1,["envelope"]=0}}},["Segments"]=10,["Width1"]=0.2,["LightEmission"]=0.5,["CurveSize0"]=0,["CurveSize1"]=0,["Texture"]=""}},{["nodeId"]=12,["parentId"]=2,["class"]="Sound",["name"]="Gunshot",["properties"]={["RollOffMinDistance"]=10,["RollOffMode"]="Enum.RollOffMode.Inverse",["Looped"]=false,["PlaybackSpeed"]=1,["RollOffMaxDistance"]=10000,["Volume"]=0.69999999,["SoundId"]="http://www.roblox.com/asset/?id=10209803"}},{["nodeId"]=13,["parentId"]=2,["class"]="Sound",["name"]="Reload",["properties"]={["RollOffMinDistance"]=10,["RollOffMode"]="Enum.RollOffMode.Inverse",["Looped"]=false,["PlaybackSpeed"]=1,["RollOffMaxDistance"]=10000,["Volume"]=1,["SoundId"]="rbxassetid://4753414199"}},{["nodeId"]=16,["parentId"]=7,["class"]="Animation",["name"]="Shoot",["properties"]={["AnimationId"]="rbxassetid://124281955370937"}},{["nodeId"]=17,["parentId"]=7,["class"]="Animation",["name"]="Reload",["properties"]={["AnimationId"]="rbxassetid://127786188145385"}},{["nodeId"]=18,["parentId"]=8,["class"]="EqualizerSoundEffect",["name"]="EqualizerSoundEffect",["properties"]={["Enabled"]=true,["LowGain"]=-5,["HighGain"]=0,["MidGain"]=0,["Priority"]=0}},{["nodeId"]=19,["parentId"]=9,["class"]="EqualizerSoundEffect",["name"]="EqualizerSoundEffect",["properties"]={["Enabled"]=true,["LowGain"]=-5,["HighGain"]=0,["MidGain"]=0,["Priority"]=0}}},["anchor"]=2}; if not scopeOnly then for _,node in ipairs(record.nodes) do if node.class=="Animation" and node.name=="CustomHold" then node.properties.AnimationId=scopeHoldAnimations.MM2 end end end; return record end
end)()
;(function()
data.weapons.Gun["Voidscope"]=function() local record={["nodes"]={{["nodeId"]=0,["class"]="Tool",["name"]="Gun",["properties"]={["Enabled"]=true,["CanBeDropped"]=false,["RequiresHandle"]=true,["TextureId"]="http://www.roblox.com/asset/?id=80649487175462",["Grip"]={["v"]={0.0103258,-0.87381929,-1.2e-07,-2.086e-05,0.681961,0.73138851,8.23e-06,0.73138857,-0.681961,-0.99999994,-8.23e-06,-2.086e-05},["type"]="CFrame"}},["attributes"]={["ItemName"]="Voidscope",["ItemType"]="Gun",["FX"]=true,["IsWeapon"]=true,["Image"]="http://www.roblox.com/asset/?id=80649487175462",["ItemID"]="Voidscope",["Season"]=1,["Rarity"]="Secret",["IsGun"]=true}},{["nodeId"]=1,["parentId"]=0,["class"]="Animation",["name"]="CustomHold",["properties"]={["AnimationId"]="rbxassetid://134818020160275"}},{["nodeId"]=2,["parentId"]=0,["class"]="MeshPart",["name"]="Handle",["properties"]={["Reflectance"]=0,["TextureID"]="rbxassetid://125806303939871",["CFrame"]={["v"]={0,0,0,1,0,0,0,1,0,0,0,1},["type"]="CFrame"},["MeshId"]="rbxassetid://79692502167966",["Transparency"]=0,["Color"]={["v"]={0.97254902,0.97254902,0.97254902},["type"]="Color3"},["MeshSize"]={["v"]={3.84698772,4.03152084,0.36522293},["type"]="Vector3"},["Material"]="Enum.Material.Brick",["Size"]={["v"]={3.16730452,3.31923461,0.3006956},["type"]="Vector3"}}},{["nodeId"]=6,["parentId"]=0,["class"]="Folder",["name"]="Sounds",["properties"]={}},{["nodeId"]=7,["parentId"]=0,["class"]="Folder",["name"]="Animations",["properties"]={}},{["nodeId"]=8,["parentId"]=2,["class"]="Sound",["name"]="AltSound",["properties"]={["RollOffMode"]="Enum.RollOffMode.Inverse",["Looped"]=false,["PlaybackSpeed"]=0.80000001,["RollOffMaxDistance"]=9178.86230469,["Volume"]=0.5,["SoundId"]="rbxassetid://130113322",["RollOffMinDistance"]=9.17886162}},{["nodeId"]=9,["parentId"]=2,["class"]="Sound",["name"]="CustomReload",["properties"]={["RollOffMode"]="Enum.RollOffMode.Inverse",["Looped"]=false,["PlaybackSpeed"]=0.64999998,["RollOffMaxDistance"]=9178.86230469,["Volume"]=0.5,["SoundId"]="rbxassetid://130113370",["RollOffMinDistance"]=9.17886162}},{["nodeId"]=10,["parentId"]=2,["class"]="Attachment",["name"]="CustomAttachment",["properties"]={["CFrame"]={["v"]={0.10695174,1.84e-06,0.06175069,0,-1,0,0,0,-1,1,0,0},["type"]="CFrame"}}},{["nodeId"]=11,["parentId"]=2,["class"]="Beam",["name"]="CustomBeam",["properties"]={["Enabled"]=true,["FaceCamera"]=false,["Color"]={["points"]={{["value"]={["v"]={1,1,1},["type"]="Color3"},["time"]=0},{["value"]={["v"]={1,1,1},["type"]="Color3"},["time"]=1}},["type"]="ColorSequence"},["Segments"]=10,["Transparency"]={["points"]={{["value"]=0,["time"]=0,["envelope"]=0},{["value"]=0,["time"]=1,["envelope"]=0}},["type"]="NumberSequence"},["Width0"]=0.2,["Width1"]=0.2,["LightEmission"]=0.5,["CurveSize1"]=0,["CurveSize0"]=0,["Texture"]=""}},{["nodeId"]=12,["parentId"]=2,["class"]="Sound",["name"]="Gunshot",["properties"]={["RollOffMode"]="Enum.RollOffMode.Inverse",["Looped"]=false,["PlaybackSpeed"]=1,["RollOffMaxDistance"]=10000,["Volume"]=0.69999999,["SoundId"]="http://www.roblox.com/asset/?id=10209803",["RollOffMinDistance"]=10}},{["nodeId"]=13,["parentId"]=2,["class"]="Sound",["name"]="Reload",["properties"]={["RollOffMode"]="Enum.RollOffMode.Inverse",["Looped"]=false,["PlaybackSpeed"]=1,["RollOffMaxDistance"]=10000,["Volume"]=1,["SoundId"]="rbxassetid://4753414199",["RollOffMinDistance"]=10}},{["nodeId"]=16,["parentId"]=7,["class"]="Animation",["name"]="Shoot",["properties"]={["AnimationId"]="rbxassetid://124281955370937"}},{["nodeId"]=17,["parentId"]=7,["class"]="Animation",["name"]="Reload",["properties"]={["AnimationId"]="rbxassetid://127786188145385"}},{["nodeId"]=18,["parentId"]=8,["class"]="EqualizerSoundEffect",["name"]="EqualizerSoundEffect",["properties"]={["Enabled"]=true,["LowGain"]=-5,["HighGain"]=0,["MidGain"]=0,["Priority"]=0}},{["nodeId"]=19,["parentId"]=9,["class"]="EqualizerSoundEffect",["name"]="EqualizerSoundEffect",["properties"]={["Enabled"]=true,["LowGain"]=-5,["HighGain"]=0,["MidGain"]=0,["Priority"]=0}}},["anchor"]=2}; if not scopeOnly then for _,node in ipairs(record.nodes) do if node.class=="Animation" and node.name=="CustomHold" then node.properties.AnimationId=scopeHoldAnimations.MM2 end end end; return record end
end)()
;(function()
data.gunBehavior["Matrixscope"]=scopeOnly and {["shoot"]={["RollOffMode"]="Enum.RollOffMode.Inverse",["PlaybackSpeed"]=0.80000001,["RollOffMaxDistance"]=9178.86230469,["Volume"]=0.5,["SoundId"]="rbxassetid://130113322",["RollOffMinDistance"]=9.17886162,["equalizer"]={["Enabled"]=true,["LowGain"]=-5,["HighGain"]=0,["MidGain"]=0,["Priority"]=0}},["reload"]={["RollOffMode"]="Enum.RollOffMode.Inverse",["PlaybackSpeed"]=0.64999998,["RollOffMaxDistance"]=9178.86230469,["Volume"]=0.5,["SoundId"]="rbxassetid://130113370",["RollOffMinDistance"]=9.17886162,["equalizer"]={["Enabled"]=true,["LowGain"]=-5,["HighGain"]=0,["MidGain"]=0,["Priority"]=0}},["beam"]={["Enabled"]=true,["FaceCamera"]=false,["Color"]={["type"]="ColorSequence",["points"]={{["value"]={["type"]="Color3",["v"]={0,1,0}},["time"]=0},{["value"]={["type"]="Color3",["v"]={0,1,0}},["time"]=1}}},["Width0"]=0.2,["Transparency"]={["type"]="NumberSequence",["points"]={{["value"]=0,["time"]=0,["envelope"]=0},{["value"]=0,["time"]=1,["envelope"]=0}}},["Segments"]=10,["Width1"]=0.2,["LightEmission"]=0.5,["CurveSize0"]=0,["CurveSize1"]=0,["Texture"]=""},["hold"]="rbxassetid://134818020160275",["animations"]={["CustomHold"]="rbxassetid://134818020160275",["Shoot"]="rbxassetid://124281955370937",["Reload"]="rbxassetid://127786188145385"}} or {["shoot"]={["RollOffMode"]="Enum.RollOffMode.Inverse",["PlaybackSpeed"]=0.80000001,["RollOffMaxDistance"]=9178.86230469,["Volume"]=0.5,["SoundId"]="rbxassetid://130113322",["RollOffMinDistance"]=9.17886162,["equalizer"]={["Enabled"]=true,["LowGain"]=-5,["HighGain"]=0,["MidGain"]=0,["Priority"]=0}},["reload"]={["RollOffMode"]="Enum.RollOffMode.Inverse",["PlaybackSpeed"]=0.64999998,["RollOffMaxDistance"]=9178.86230469,["Volume"]=0.5,["SoundId"]="rbxassetid://130113370",["RollOffMinDistance"]=9.17886162,["equalizer"]={["Enabled"]=true,["LowGain"]=-5,["HighGain"]=0,["MidGain"]=0,["Priority"]=0}},["beam"]={["Enabled"]=true,["FaceCamera"]=false,["Color"]={["type"]="ColorSequence",["points"]={{["value"]={["type"]="Color3",["v"]={0,1,0}},["time"]=0},{["value"]={["type"]="Color3",["v"]={0,1,0}},["time"]=1}}},["Width0"]=0.2,["Transparency"]={["type"]="NumberSequence",["points"]={{["value"]=0,["time"]=0,["envelope"]=0},{["value"]=0,["time"]=1,["envelope"]=0}}},["Segments"]=10,["Width1"]=0.2,["LightEmission"]=0.5,["CurveSize0"]=0,["CurveSize1"]=0,["Texture"]=""},["hold"]="rbxassetid://15666234025",["animations"]={["CustomHold"]="rbxassetid://15666234025",["Shoot"]="rbxassetid://124281955370937",["Reload"]="rbxassetid://127786188145385"}}
end)()
;(function()
data.gunBehavior["Voidscope"]=scopeOnly and {["shoot"]={["RollOffMinDistance"]=9.17886162,["RollOffMode"]="Enum.RollOffMode.Inverse",["PlaybackSpeed"]=1,["RollOffMaxDistance"]=9178.86230469,["Volume"]=0.5,["SoundId"]="rbxassetid://130113322",["equalizer"]={["Enabled"]=true,["LowGain"]=-5,["HighGain"]=0,["MidGain"]=0,["Priority"]=0}},["reload"]={["RollOffMinDistance"]=9.17886162,["RollOffMode"]="Enum.RollOffMode.Inverse",["PlaybackSpeed"]=0.80000001,["RollOffMaxDistance"]=9178.86230469,["Volume"]=0.5,["SoundId"]="rbxassetid://130113370",["equalizer"]={["Enabled"]=true,["LowGain"]=-5,["HighGain"]=0,["MidGain"]=0,["Priority"]=0}},["beam"]={["Enabled"]=true,["FaceCamera"]=false,["Color"]={["points"]={{["value"]={["v"]={1,1,1},["type"]="Color3"},["time"]=0},{["value"]={["v"]={1,1,1},["type"]="Color3"},["time"]=1}},["type"]="ColorSequence"},["Segments"]=10,["Transparency"]={["points"]={{["value"]=0,["time"]=0,["envelope"]=0},{["value"]=0,["time"]=1,["envelope"]=0}},["type"]="NumberSequence"},["Width0"]=0.2,["Width1"]=0.2,["LightEmission"]=0.5,["CurveSize1"]=0,["CurveSize0"]=0,["Texture"]=""},["hold"]="rbxassetid://134818020160275",["animations"]={["CustomHold"]="rbxassetid://134818020160275",["Shoot"]="rbxassetid://124281955370937",["Reload"]="rbxassetid://127786188145385"},["flicker"]={["interval"]=0.01666667,["colors"]={{["type"]="ColorSequence",["points"]={{["time"]=0,["value"]={["type"]="Color3",["v"]={1,1,1}}},{["time"]=1,["value"]={["type"]="Color3",["v"]={1,1,1}}}}},{["type"]="ColorSequence",["points"]={{["time"]=0,["value"]={["type"]="Color3",["v"]={0,0,0}}},{["time"]=1,["value"]={["type"]="Color3",["v"]={0,0,0}}}}}}}} or {["shoot"]={["RollOffMinDistance"]=9.17886162,["RollOffMode"]="Enum.RollOffMode.Inverse",["PlaybackSpeed"]=1,["RollOffMaxDistance"]=9178.86230469,["Volume"]=0.5,["SoundId"]="rbxassetid://130113322",["equalizer"]={["Enabled"]=true,["LowGain"]=-5,["HighGain"]=0,["MidGain"]=0,["Priority"]=0}},["reload"]={["RollOffMinDistance"]=9.17886162,["RollOffMode"]="Enum.RollOffMode.Inverse",["PlaybackSpeed"]=0.80000001,["RollOffMaxDistance"]=9178.86230469,["Volume"]=0.5,["SoundId"]="rbxassetid://130113370",["equalizer"]={["Enabled"]=true,["LowGain"]=-5,["HighGain"]=0,["MidGain"]=0,["Priority"]=0}},["beam"]={["Enabled"]=true,["FaceCamera"]=false,["Color"]={["points"]={{["value"]={["v"]={1,1,1},["type"]="Color3"},["time"]=0},{["value"]={["v"]={1,1,1},["type"]="Color3"},["time"]=1}},["type"]="ColorSequence"},["Segments"]=10,["Transparency"]={["points"]={{["value"]=0,["time"]=0,["envelope"]=0},{["value"]=0,["time"]=1,["envelope"]=0}},["type"]="NumberSequence"},["Width0"]=0.2,["Width1"]=0.2,["LightEmission"]=0.5,["CurveSize1"]=0,["CurveSize0"]=0,["Texture"]=""},["hold"]="rbxassetid://15666234025",["animations"]={["CustomHold"]="rbxassetid://15666234025",["Shoot"]="rbxassetid://124281955370937",["Reload"]="rbxassetid://127786188145385"},["flicker"]={["interval"]=0.01666667,["colors"]={{["type"]="ColorSequence",["points"]={{["time"]=0,["value"]={["type"]="Color3",["v"]={1,1,1}}},{["time"]=1,["value"]={["type"]="Color3",["v"]={1,1,1}}}}},{["type"]="ColorSequence",["points"]={{["time"]=0,["value"]={["type"]="Color3",["v"]={0,0,0}}},{["time"]=1,["value"]={["type"]="Color3",["v"]={0,0,0}}}}}}}}
end)()
;(function()
local families={"snowcannon","raygun","icepiercer","harvester","gingerscope"}
for id,behavior in pairs(data.gunBehavior) do
if type(id)=="string" and type(behavior)=="table" and behavior.reload==nil then
local lower=id:lower()
for _,family in ipairs(families) do
if lower:find(family,1,true) then
behavior.reload={["SoundId"]="rbxassetid://4753414199",["Volume"]=1,["PlaybackSpeed"]=1,
["RollOffMode"]="Enum.RollOffMode.Inverse",["RollOffMinDistance"]=10,["RollOffMaxDistance"]=10000}
break
end
end
end
end
end)()
;(function()
data.metadata.Gun["Matrixscope"]={["itemid"]=117266088063706,["itemname"]="Matrixscope",["fx"]=true,["year"]="2025",["rarity"]="Secret",["event"]="Halloween",["image"]="http://www.roblox.com/asset/?id=120253087642585"}
end)()
;(function()
data.metadata.Gun["Voidscope"]={["event"]="Halloween",["year"]="2025",["image"]="http://www.roblox.com/asset/?id=80649487175462",["itemid"]=84264267520629,["fx"]=true,["rarity"]="Secret",["season"]=1,["itemname"]="Voidscope"}
end)()
local cache=Instance.new("Folder")
cache.Name="VisualsV2_OriginalVisuals"
local alive=true
local built={}
local failures={}
local recordLoads=0
local weaponUse={}
local useTick=0
local function trimWeapons(keep)
local count=0
for _ in pairs(weaponUse) do count=count+1 end
if count<=12 then return end
local pinned={[keep]=true}
local skins=env.VisualsV2Runtime.ClientWeaponSkins
if skins then
for _,kind in ipairs({"Gun","Knife"}) do
local on,id=skins.GetState(kind)
if on then pinned[kind..":"..id]=true end
end
end
local oldest,time=nil,math.huge
for key,tick in pairs(weaponUse) do
if not pinned[key] and tick<time then oldest,time=key,tick end
end
if oldest then built[oldest]:Destroy();built[oldest]=nil;weaponUse[oldest]=nil end
end
local allowed={Part=true,MeshPart=true,WedgePart=true,CornerWedgePart=true,SpecialMesh=true,BlockMesh=true,
CylinderMesh=true,Decal=true,Texture=true,Attachment=true,Model=true,Folder=true,Tool=true,
Animation=true,Sound=true,EqualizerSoundEffect=true,SurfaceAppearance=true,ParticleEmitter=true,
Trail=true,Beam=true,Fire=true,Smoke=true,Sparkles=true,PointLight=true,SpotLight=true,
SurfaceLight=true,BillboardGui=true,ImageLabel=true}
local function decode(value,objects)
if type(value)=="string" then
if value=="inf" then return math.huge end
if value=="-inf" then return -math.huge end
local group,name=value:match("^Enum%.(%w+)%.(%w+)$")
if group then return Enum[group][name] end
return value
end
if type(value)~="table" then return value end
local kind,v=value.type,value.v
if kind=="Vector3" then return Vector3.new(v[1],v[2],v[3]) end
if kind=="Vector2" then return Vector2.new(v[1],v[2]) end
if kind=="Color3" then return Color3.new(v[1],v[2],v[3]) end
if kind=="CFrame" then return CFrame.new(table.unpack(v)) end
if kind=="UDim" then return UDim.new(v[1],v[2]) end
if kind=="UDim2" then
if value.x and value.y then return UDim2.new(value.x[1],value.x[2],value.y[1],value.y[2]) end
return UDim2.new(v[1],v[2],v[3],v[4])
end
if kind=="Rect" then return Rect.new(table.unpack(v)) end
if kind=="NumberRange" then return NumberRange.new(value.min,value.max) end
if kind=="NumberSequence" then
local points={}
for _,p in ipairs(value.points) do points[#points+1]=NumberSequenceKeypoint.new(p.time,p.value,p.envelope or 0) end
return NumberSequence.new(points)
end
if kind=="ColorSequence" then
local points={}
for _,p in ipairs(value.points) do points[#points+1]=ColorSequenceKeypoint.new(p.time,decode(p.value,objects)) end
return ColorSequence.new(points)
end
if kind=="Instance" then return objects and objects[value.nodeId] end
error("Unsupported captured visual type: "..tostring(kind))
end
if not scopeOnly then
for id,behavior in pairs(data.gunBehavior) do
if id:find("Harvester",1,true) then behavior.shoot={["RollOffMinDistance"]=10,["RollOffMode"]="Enum.RollOffMode.Inverse",["PlaybackSpeed"]=1.39999998,["RollOffMaxDistance"]=10000,["Volume"]=1,["SoundId"]="rbxassetid://7808472682"} end
end
for id,behavior in pairs(data.gunBehavior) do
if id:find("Snowcannon",1,true) then behavior.shoot={["RollOffMinDistance"]=10,["RollOffMode"]="Enum.RollOffMode.Inverse",["PlaybackSpeed"]=1.39999998,["RollOffMaxDistance"]=10000,["Volume"]=0.5,["SoundId"]="rbxassetid://76834305559381"} end
end
for id,behavior in pairs(data.gunBehavior) do
if id:find("Raygun",1,true) then behavior.shoot={["RollOffMinDistance"]=10,["RollOffMode"]="Enum.RollOffMode.Inverse",["PlaybackSpeed"]=1.39999998,["RollOffMaxDistance"]=10000,["Volume"]=1,["SoundId"]="rbxassetid://127697544541654",["equalizer"]={["Enabled"]=true,["LowGain"]=-5,["HighGain"]=0,["MidGain"]=0,["Priority"]=0}} end
end
end
local gripSources={Gun={
BlueHarvester="Harvester",BronzeHarvester="Harvester",SilverHarvester="Harvester",GoldHarvester="Harvester",
ElderwoodGunBlue="ElderwoodGun",ElderwoodGunBronze="ElderwoodGun",ElderwoodGunSilver="ElderwoodGun",ElderwoodGunGold="ElderwoodGun",
IcepiercerBronze="Icepiercer",IcepiercerSilver="Icepiercer",IcepiercerGold="Icepiercer",IcepiercerRed="Icepiercer",
RaygunBronze="Raygun",RaygunSilver="Raygun",RaygunGold="Raygun",RaygunRed="Raygun",RaygunChroma="Raygun",
Snowcannon="SnowcannonChroma",SnowcannonBronze="SnowcannonChroma",SnowcannonSilver="SnowcannonChroma",
SnowcannonGold="SnowcannonChroma",SnowcannonRed="SnowcannonChroma",
},Knife={BlueCandy="Candy",BronzeCandy="Candy",SilverCandy="Candy",GoldCandy="Candy",
EmberscytheChroma="Emberscythe"}}
local inheritedGrips={}
local function weaponGrip(category,id,record)
if category=="Gun" and (id:find("Harvester",1,true) or id:lower():find("emberbow",1,true)) then
return {type="CFrame",v={0,-0.5109372138977051,0.34054040908813477,1,0,0,0,1,0,0,0,1}}
end
if record.grip then return record.grip end
for _,node in ipairs(record.nodes) do
if node.class=="Tool" and node.properties.Grip then return node.properties.Grip end
end
for _,node in ipairs(record.nodes) do
local offset=type(node.attributes)=="table" and node.attributes.GripOffset
if type(offset)=="table" and offset.type=="CFrame" then return offset,true end
end
local source=gripSources[category] and gripSources[category][id]
if not source then return nil end
local key=category..":"..source
if not inheritedGrips[key] then
local factory=data.weapons[category][source]
local captured=type(factory)=="function" and factory() or factory
if captured then
local grip,recorded=weaponGrip(category,source,captured)
if grip then inheritedGrips[key]={grip=grip,recorded=recorded} end
end
end
local inherited=inheritedGrips[key]
if inherited then return inherited.grip,inherited.recorded end
return nil
end
local function assign(object,key,value,objects) object[key]=decode(value,objects) end
local function setAttribute(object,key,value,objects) object:SetAttribute(key,decode(value,objects)) end
local function create(record,id,category)
local model=Instance.new("Model")
model.Name="VisualsV2_Original_"..id
local objects={}
local weapon=category=="Gun" or category=="Knife"
local grip,recordedGrip=nil,false
if weapon then grip,recordedGrip=weaponGrip(category,id,record) end
grip=grip or record.grip
if grip then model:SetAttribute("VisualsV2_CapturedGrip",decode(grip)) end
if recordedGrip then model:SetAttribute("VisualsV2_RecordedGripOffset",true) end
for _,node in ipairs(record.nodes) do
local unnecessary=weapon and (node.class=="Sound" or node.class=="EqualizerSoundEffect"
or node.class=="Animation" or node.class=="BillboardGui" or node.class=="ImageLabel"
or node.class=="SurfaceAppearance")
if allowed[node.class] and not unnecessary then
local made,object=pcall(Instance.new,node.class=="MeshPart" and "Part" or node.class=="Tool" and "Folder" or node.class)
if made and object then
object.Name=node.name
objects[node.nodeId]=object
object.Parent=model
end
end
end
for _,node in ipairs(record.nodes) do
local object=objects[node.nodeId]
if object then
object.Parent=objects[node.parentId] or model
for key,value in pairs(node.properties or {}) do
if not (node.class=="MeshPart" and (key=="MeshId" or key=="TextureID" or key=="MeshSize"))
and not (node.class=="Tool") and key~="Adornee" and key~="PrimaryPart" then
pcall(assign,object,key,value,objects)
end
end
for key,value in pairs(node.attributes or {}) do pcall(setAttribute,object,key,value,objects) end
if node.class=="Tool" and node.properties.Grip then
model:SetAttribute("VisualsV2_CapturedGrip",decode(node.properties.Grip))
end
if node.class=="MeshPart" then
local mesh=Instance.new("SpecialMesh")
mesh.Name="VisualsV2_CapturedMesh"
mesh.MeshType=Enum.MeshType.FileMesh
mesh.MeshId=node.properties.MeshId or ""
local textureId=node.properties.TextureID or ""
for _,candidate in ipairs(record.nodes) do
if candidate.class=="SurfaceAppearance" and candidate.parentId==node.nodeId
and candidate.properties and type(candidate.properties.ColorMap)=="string"
and candidate.properties.ColorMap~="" then
textureId=candidate.properties.ColorMap;break
end
end
mesh.TextureId=textureId
local size=node.properties.Size and decode(node.properties.Size) or Vector3.new(1,1,1)
local bounds=node.properties.MeshSize and decode(node.properties.MeshSize) or size
if bounds.X<=0 or bounds.Y<=0 or bounds.Z<=0 then bounds=size end
mesh.Scale=Vector3.new(size.X/math.max(bounds.X,0.000001),size.Y/math.max(bounds.Y,0.000001),size.Z/math.max(bounds.Z,0.000001))
mesh.Parent=object
end
if object:IsA("BasePart") then
object.Anchored=true;object.CanCollide=false;object.CanTouch=false;object.CanQuery=false
object.Massless=true;object.LocalTransparencyModifier=0
elseif object:IsA("Sound") then object.PlayOnRemove=false end
end
end
local root=objects[record.anchor]
if not root or not root:IsA("BasePart") then root=model:FindFirstChildWhichIsA("BasePart",true) end
if root then model.PrimaryPart=root end
model:SetAttribute("VisualsV2_OriginalSource","Captured original: "..id)
return model
end
local function get(category,id,record)
if not alive or not runtimeAlive or not record then return nil end
local key=category..":"..id
if failures[key] then return nil end
if not built[key] then
local ok,object=pcall(function()
if type(record)=="function" then record=record();recordLoads=recordLoads+1 end
return create(record,id,category)
end)
if not ok then failures[key]=tostring(object);return nil end
object.Parent=cache;built[key]=object
end
if category=="Gun" or category=="Knife" then
useTick=useTick+1;weaponUse[key]=useTick
trimWeapons(key)
end
return built[key]
end
local identify={lists={},making={}}
function identify.asset(value)
local last=nil
for digits in tostring(value or ""):gmatch("%d%d%d%d+") do last=digits end
return last
end
function identify.hex(color)
return string.format("%02X%02X%02X",math.floor(color.R*255+0.5),math.floor(color.G*255+0.5),math.floor(color.B*255+0.5))
end
local IDENTIFY_FIELDS={MeshId=true,TextureId=true,TextureID=true,Texture=true,ColorMap=true}
function identify.recordFeatures(path,json)
local features,count={},0
if path=="effects" then
local ok,record=pcall(HttpService.JSONDecode,HttpService,json)
for _,node in ipairs(ok and type(record)=="table" and record.nodes or {}) do
local properties=node.properties or {}
local key
if node.class=="ParticleEmitter" or node.class=="Beam" or node.class=="Trail" then
key=identify.asset(properties.Texture)
if key and not features[key] then features[key]=true;count=count+1 end
local sequence=properties.Color
local first=type(sequence)=="table" and sequence.points and sequence.points[1]
local value=first and first.value and first.value.v
if type(value)=="table" and #value>=3 then
key="c"..identify.hex(Color3.new(value[1],value[2],value[3]))
if not features[key] then features[key]=true;count=count+1 end
end
elseif node.class=="Fire" then
local value=type(properties.Color)=="table" and properties.Color.v
if type(value)=="table" and #value>=3 then
key="f"..identify.hex(Color3.new(value[1],value[2],value[3]))
if not features[key] then features[key]=true;count=count+1 end
end
elseif node.class=="ImageLabel" then
key=identify.asset(properties.Image)
if key and not features[key] then features[key]=true;count=count+1 end
end
end
return features,count,false
end
local class=nil
for field,value in json:gmatch('"(%w+)":"([^"]*)"') do
if field=="class" then class=value
elseif IDENTIFY_FIELDS[field] and class~="Tool" then
local key=identify.asset(value)
if key and not features[key] then features[key]=true;count=count+1 end
end
end
return features,count,json:find('"name":"Chroma"',1,true)~=nil
end
function identify.list(path)
local list=identify.lists[path]
if list then return list end
if identify.making[path] then
for _=1,100 do task.wait(0.05);if identify.lists[path] then return identify.lists[path] end end
return nil
end
identify.making[path]=true
list={}
local done=0
for id,json in pairs(raw[path] or {}) do
local features,count,chroma=identify.recordFeatures(path,json)
if count>0 then list[#list+1]={id=id,features=features,count=count,chroma=chroma} end
done=done+1
if done%80==0 then task.wait() end
end
table.sort(list,function(a,b) return a.id<b.id end)
identify.lists[path]=list
identify.making[path]=nil
return list
end
function identify.observed(root,effectOnly)
local features,count,chroma={},0,false
local objects={root}
for _,object in ipairs(root:GetDescendants()) do objects[#objects+1]=object end
local function add(key)
if key and not features[key] then features[key]=true;count=count+1 end
end
for _,object in ipairs(objects) do
pcall(function()
if object.Name=="Chroma" then chroma=true end
if effectOnly then
if object:IsA("ParticleEmitter") or object:IsA("Beam") or object:IsA("Trail") then
add(identify.asset(object.Texture))
local sequence=object.Color
if typeof(sequence)=="ColorSequence" then add("c"..identify.hex(sequence.Keypoints[1].Value)) end
elseif object:IsA("Fire") then add("f"..identify.hex(object.Color))
elseif object:IsA("ImageLabel") then add(identify.asset(object.Image)) end
elseif object:IsA("MeshPart") then add(identify.asset(object.MeshId));add(identify.asset(object.TextureID))
elseif object:IsA("SpecialMesh") or object:IsA("FileMesh") then add(identify.asset(object.MeshId));add(identify.asset(object.TextureId))
elseif object:IsA("Decal") or object:IsA("Texture") then add(identify.asset(object.Texture))
elseif object:IsA("ParticleEmitter") or object:IsA("Beam") or object:IsA("Trail") then add(identify.asset(object.Texture))
elseif object:IsA("SurfaceAppearance") then add(identify.asset(object.ColorMap)) end
end)
end
return features,count,chroma
end
function identify.match(kind,object)
local path=kind=="Gun" and "weapons.Gun" or kind=="Knife" and "weapons.Knife"
or kind=="Effects" and "effects" or kind=="Pets" and "pets" or nil
if not path or typeof(object)~="Instance" then return nil end
local effect=path=="effects"
local seen,seenCount,chroma=identify.observed(object,effect)
if seenCount==0 then return nil end
local list=identify.list(path)
if not list then return nil end
local best,bestScore,bestHits=nil,0,0
for _,entry in ipairs(list) do
local hits=0
for key in pairs(entry.features) do if seen[key] then hits=hits+1 end end
if hits>0 then
local score=effect and hits/(entry.count+seenCount-hits) or hits/entry.count
local better=score>bestScore+1e-6 or (math.abs(score-bestScore)<=1e-6 and (hits>bestHits
or hits==bestHits and best and entry.chroma==chroma and best.chroma~=chroma))
if better then best,bestScore,bestHits=entry,score,hits end
end
end
if not best or bestScore<(effect and 0.4 or 0.66) then return nil end
return best.id,bestScore
end
env.VisualsV2Runtime.OriginalVisuals={
ScopeMeshes=scopeMeshes,
Identify=function(kind,object) return identify.match(kind,object) end,
NativeIcons=nativeIcons,
GetWeapon=function(kind,id) return get(kind,id,data.weapons[kind] and data.weapons[kind][id]) end,
GetEffect=function(id) return get("Effect",id,data.effects[id]) end,
GetPet=function(id) return get("Pet",id,data.pets[id]) end,
GetDeathEffect=function(id) return get("Death",id,data.deathEffects[id]) end,
HasDeathEffect=function(id) return data.deathEffects[id]~=nil end,
HasWeapon=function(kind,id) return data.weapons[kind] and data.weapons[kind][id]~=nil end,
HasEffect=function(id) return data.effects[id]~=nil end,
GetEffectInfo=function(id) return data.effectInfo[id] end,
GetGunBehavior=function(id)
local behavior=data.gunBehavior[id]
if behavior==nil and type(id)=="string" and id:lower():find("emberbow",1,true) then behavior=data.gunBehavior.Emberbow end
return behavior
end,
ScopeHoldAnimations=scopeHoldAnimations,
Decode=decode,
Metadata=data.metadata,
}
env.VisualsV2Runtime.RegisterReset(function()
if not runtimeAlive then alive=false;cache:Destroy();table.clear(built);table.clear(weaponUse) end
end)
end,"Part at line 9344")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local mmv=game.GameId==10413186812 or game.GameId==10769671266 or game.PlaceId==93017634738276 or game.PlaceId==81374640397860
local MARKER="VisualsV2_ClientWeaponSkin"
local NONE="None"
local alive=true
local catalog={Gun={},Knife={}}
local connections={}
local toolStates={}
local changes=Instance.new("BindableEvent")
local skinStats={clones=0,reuses=0,refreshes=0}
local heartbeat=nil
local hideFrame=nil
local refreshTools,updateWatching
local thrown,clearThrown={},nil
local knifeHeld
local kinds={
Gun={enabled=env.VisualsV2Runtime.WeaponsUnlocked() and C(mmv and "clientScopeEnabled" or "clientGunEnabled",false),selected=tostring(C(mmv and "clientScopeSkin" or "clientGunSkin",NONE)),key=mmv and "clientScope" or "clientGun"},
Knife={enabled=not mmv and env.VisualsV2Runtime.WeaponsUnlocked() and C("clientKnifeEnabled",false),selected=tostring(C("clientKnifeSkin",NONE)),key="clientKnife"},
}
local function notify(message,kind)
if alive and runtimeAlive then pcall(function() shared.Notify(message,kind or 3) end) end
end
local recentErrors={}
local errorSeen={}
local function objectPath(object)
if not object then return nil end
local ok,path=pcall(function() return object:GetFullName() end)
return ok and path or object.Name
end
local function recordError(context,reason)
reason=tostring(reason)
local key=context..":"..reason
if errorSeen[key] then return end
errorSeen[key]=true
recentErrors[#recentErrors+1]={context=context,error=reason,time=os.clock()}
if #recentErrors>24 then table.remove(recentErrors,1) end
if type(warn)=="function" then warn("[VisualsV2 Weapons] "..context..": "..reason) end
end
local function guarded(context,callback,...)
local function trace(reason)
return type(debug)=="table" and type(debug.traceback)=="function" and debug.traceback(tostring(reason),2) or tostring(reason)
end
local ok,result=xpcall(callback,trace,...)
if not ok then recordError(context,result) end
return ok,result
end
local function compact(value)
return type(value)=="string" and value:lower():gsub("[^%w]","") or ""
end
local function weaponKind(value)
local name=compact(value)
if name=="gun" or name=="guns" or name=="pistol" or name=="revolver"
or name=="firearm" or name=="gunskins" then return "Gun" end
if name=="knife" or name=="knives" or name=="melee" or name=="sword"
or name=="knifeskins" then return "Knife" end
end
local function properties(data)
local result={}
if type(data)=="table" then
for key,value in pairs(data) do
if type(key)=="string" then result[compact(key)]=value end
end
end
return result
end
local function isDefault(id,data)
if data.isdefault==true or data.default==true then return true end
local key=compact(id)
if key=="default" or key=="defaultgun" or key=="defaultknife"
or key=="gun" or key=="knife" then return true end
local name=compact(data.itemname or data.displayname or data.name)
return name=="defaultgun" or name=="defaultknife" or name=="default"
end
local function register(kind,id,data,source)
if not kind or id==nil then return end
id=tostring(id)
if id=="" or isDefault(id,data) then return end
local originals=env.VisualsV2Runtime.OriginalVisuals
if originals and originals.HasWeapon and not originals.HasWeapon(kind,id) then return end
local recorded=originals and originals.Metadata and originals.Metadata[kind] and originals.Metadata[kind][id]
if recorded then
local merged=table.clone(data)
for key,value in pairs(recorded) do merged[key]=value end
data=merged
end
local entry=catalog[kind][id]
if not entry then
entry={id=id,kind=kind,data={},revision=0}
catalog[kind][id]=entry
end
local changed=false
for key,value in pairs(data) do
if entry.data[key]~=value then entry.data[key]=value; changed=true end
end
if source and entry.source~=source then entry.source=source; changed=true end
entry.name=tostring(entry.data.itemname or entry.data.displayname or entry.data.name or id)
if entry.data.chroma==true and not entry.name:lower():find("chroma",1,true) then
entry.name="Chroma "..entry.name
end
if changed then entry.revision=entry.revision+1 end
return entry
end
local staticMM2={
{"Gun","Ace",{["itemid"]=238546577,["itemname"]="Ace",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","AduriteGun",{["itemid"]=196752289,["itemname"]="Adurite",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Aid",{["itemid"]=203807397,["itemname"]="Juice",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Aliens_G_2021",{["itemid"]=7800250906,["itemname"]="Aliens",["itemtype"]="Gun",["rarity"]="Common",["year"]="2021"}},
{"Gun","AmericaGun",{["itemid"]=196751752,["itemname"]="America",["itemtype"]="Gun",["rarity"]="Classic"}},
{"Gun","Amerilaser",{["itemid"]=446050753,["itemname"]="Amerilaser",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Apoc_G_2022",{["itemid"]=11255501940,["itemname"]="Apocalypse",["itemtype"]="Gun",["rarity"]="Common",["year"]="2022"}},
{"Gun","Aquarium_G_2025",{["itemid"]=129460052425837,["itemname"]="Aquarium",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2025"}},
{"Gun","Arctic_G_2022",{["itemid"]=11834443783,["itemname"]="Arctic",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2022"}},
{"Gun","Asteroid",{["itemid"]=476599365,["itemname"]="Asteroid",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Aurora_G_2019",{["itemid"]=4534875165,["itemname"]="Aurora",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2019"}},
{"Gun","Aurora_G_2021",{["itemid"]=8304766165,["itemname"]="Aurora",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2021"}},
{"Gun","AuroraGun",{["itemid"]=108635848059846,["itemname"]="Borealis",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2024"}},
{"Gun","Bacon",{["itemid"]=238546467,["itemname"]="Bacon",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Bats_G_2024",{["itemid"]=71258273720666,["itemname"]="Bats",["itemtype"]="Gun",["rarity"]="Common",["year"]="2024"}},
{"Gun","BatsG",{["itemid"]=2513741174,["itemname"]="Bats",["itemtype"]="Gun",["rarity"]="Common",["year"]="2018"}},
{"Gun","Bauble",{["itemid"]=84481559639371,["itemname"]="Bauble",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2024"}},
{"Gun","BaubleChroma",{["chroma"]=true,["itemid"]=84481559639371,["itemname"]="Bauble",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2024"}},
{"Gun","BigKill",{["itemid"]=196752330,["itemname"]="Big Kill",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Biogun",{["itemid"]=4659627458,["itemname"]="Biogun",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Bit",{["itemid"]=238549030,["itemname"]="Bit",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Blaster",{["itemid"]=386277381,["itemname"]="Blaster",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Bleed",{["itemid"]=315100702,["itemname"]="Rupture",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2015"}},
{"Gun","Blizzard",{["itemid"]=88928894807422,["itemname"]="Blizzard",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2025"}},
{"Gun","BlizzardChroma",{["chroma"]=true,["itemid"]=88928894807422,["itemname"]="Blizzard",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2025"}},
{"Gun","Blossom_G",{["itemid"]=12339377105,["itemname"]="Blossom",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","BlueHarvester",{["itemid"]=8194219645,["itemname"]="Blue Harvester",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2021"}},
{"Gun","BluesteelGun",{["itemid"]=196752379,["itemname"]="Bluesteel",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","BlueSugar",{["itemid"]=3215262120,["itemname"]="Blue Sugar",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2018"}},
{"Gun","Bombs_G_2026",{["itemid"]=87044885626913,["itemname"]="Bombs",["itemtype"]="Gun",["rarity"]="Common",["year"]="2026"}},
{"Gun","Bones2019",{["itemid"]=4210926347,["itemname"]="Bones",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2019"}},
{"Gun","Brains_G_2022",{["itemid"]=11284145298,["itemname"]="Brains",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2022"}},
{"Gun","Bramble_G_2026",{["itemid"]=100301080549948,["itemname"]="Bramble",["itemtype"]="Gun",["rarity"]="Common",["year"]="2026"}},
{"Gun","BronzeHarvester",{["itemid"]=8194221072,["itemname"]="Bronze Harvester",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2021"}},
{"Gun","BronzeIceblaster",{["itemid"]=6404167442,["itemname"]="Bronze Iceblaster",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2020"}},
{"Gun","BronzeSugar",{["itemid"]=3215261913,["itemname"]="Bronze Sugar",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2018"}},
{"Gun","Butterflies_G_2025",{["itemid"]=135662872427976,["itemname"]="Butterflies",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Camo",{["itemid"]=196752456,["itemname"]="Camo",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Candied_G_2022",{["itemid"]=11834435627,["itemname"]="Candied",["itemtype"]="Gun",["rarity"]="Common",["year"]="2022"}},
{"Gun","Candleflame_G_2024",{["itemid"]=90595111293037,["itemname"]="Candleflame",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2024"}},
{"Gun","CandyCorn_G_2020",{["itemid"]=5866454590,["itemname"]="Candy Corn",["itemtype"]="Gun",["rarity"]="Common",["year"]="2020"}},
{"Gun","CandyCorn_G_2022",{["itemid"]=11255558166,["itemname"]="Candy Corn",["itemtype"]="Gun",["rarity"]="Common",["year"]="2022"}},
{"Gun","CandyCorn_G_2024",{["itemid"]=117473869340749,["itemname"]="Candy Corn",["itemtype"]="Gun",["rarity"]="Common",["year"]="2024"}},
{"Gun","CandyCorn_G_2025",{["itemid"]=129781304866793,["itemname"]="Candy Corn",["itemtype"]="Gun",["rarity"]="Common",["year"]="2025"}},
{"Gun","CandyCorn_G_2026",{["itemid"]=129860191945341,["itemname"]="CandyCorn",["itemtype"]="Gun",["rarity"]="Common",["year"]="2026"}},
{"Gun","CandySwirl_G_2019",{["itemid"]=4534874602,["itemname"]="Candy Swirl",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2019"}},
{"Gun","Cane_G_2018",{["itemid"]=2669785546,["itemname"]="Cane",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2018"}},
{"Gun","Cane_G_2021",{["itemid"]=8304768700,["itemname"]="Cane",["itemtype"]="Gun",["rarity"]="Common",["year"]="2021"}},
{"Gun","CaneGun",{["itemid"]=332497187,["itemname"]="Cane",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2015"}},
{"Gun","Canes_G_2023",{["itemid"]=15635558982,["itemname"]="Canes",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2023"}},
{"Gun","Carrot_G_2024",{["itemid"]=16960082652,["itemname"]="Carrot",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Carved_G_2020",{["itemid"]=5866457985,["itemname"]="Carved",["itemtype"]="Gun",["rarity"]="Common",["year"]="2020"}},
{"Gun","Cat_G_2021",{["itemid"]=7800253444,["itemname"]="Cat",["itemtype"]="Gun",["rarity"]="Common",["year"]="2021"}},
{"Gun","Catseye_G_2026",{["itemid"]=76987905535653,["itemname"]="Catseye",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2026"}},
{"Gun","Caution",{["itemid"]=238546422,["itemname"]="Caution",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Cavern_G_2019",{["itemid"]=4534875511,["itemname"]="Cavern",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2019"}},
{"Gun","Cheddar",{["itemid"]=203808317,["itemname"]="Cheddar",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Cherries_G_2026",{["itemid"]=96164363513384,["itemname"]="Cherries",["itemtype"]="Gun",["rarity"]="Common",["year"]="2026"}},
{"Gun","ChromaDarkbringer",{["chroma"]=true,["itemid"]=4751501078,["itemname"]="Darkbringer",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","ChromaLightbringer",{["chroma"]=true,["itemid"]=4751500761,["itemname"]="Lightbringer",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Chromatic_G_2023",{["itemid"]=12965339774,["itemname"]="Chromatic",["itemtype"]="Gun",["rarity"]="Legendary"}},
{"Gun","Clown_G",{["itemid"]=4659627976,["itemname"]="Clown",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Clown_G_2024",{["itemid"]=71982363966070,["itemname"]="Clown",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2024"}},
{"Gun","Clownfish_G_2024",{["itemid"]=18322197952,["itemname"]="Clownfish",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Coal_G_2018",{["itemid"]=2669784920,["itemname"]="Coal",["itemtype"]="Gun",["rarity"]="Common",["year"]="2018"}},
{"Gun","Coal_G_2021",{["itemid"]=8304769409,["itemname"]="Coal",["itemtype"]="Gun",["rarity"]="Common",["year"]="2021"}},
{"Gun","Coal_G_2022",{["itemid"]=11834434264,["itemname"]="Coal",["itemtype"]="Gun",["rarity"]="Common",["year"]="2022"}},
{"Gun","Cola",{["itemid"]=238546400,["itemname"]="Soda",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Cold",{["itemid"]=196752499,["itemname"]="Cold",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Constellation",{["itemid"]=114197436469014,["itemname"]="Constellation",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2024"}},
{"Gun","Constellation_Bronze",{["itemid"]=112811587103866,["itemname"]="Bronze Constellation",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2024"}},
{"Gun","Constellation_G_2024",{["itemid"]=94311965719769,["itemname"]="Nightsky",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2024"}},
{"Gun","Constellation_Gold",{["itemid"]=132975248521820,["itemname"]="Gold Constellation",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2024"}},
{"Gun","Constellation_Red",{["itemid"]=85766514163212,["itemname"]="Red Constellation",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2024"}},
{"Gun","Constellation_Silver",{["itemid"]=100747436297625,["itemname"]="Silver Constellation",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2024"}},
{"Gun","ConstellationChroma",{["chroma"]=true,["itemid"]=114197436469014,["itemname"]="Constellation",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2024"}},
{"Gun","Cookie_G_2021",{["itemid"]=8304771148,["itemname"]="Cookie",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2021"}},
{"Gun","Cracks_G_2021",{["itemid"]=7800254737,["itemname"]="Cracks",["itemtype"]="Gun",["rarity"]="Common",["year"]="2021"}},
{"Gun","Cursed_G_2024",{["itemid"]=122855768693454,["itemname"]="Cursed",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2024"}},
{"Gun","Dark_G_2023",{["itemid"]=15091406343,["itemname"]="Darkgun",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2023"}},
{"Gun","Darkbringer",{["itemid"]=4749071819,["itemname"]="Darkbringer",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Darkness_G_2022",{["itemid"]=11255507374,["itemname"]="Darkness",["itemtype"]="Gun",["rarity"]="Common",["year"]="2022"}},
{"Gun","Darkshot",{["itemid"]=15080280688,["itemname"]="Darkshot",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2023"}},
{"Gun","Dartbringer",{["itemid"]=8626617523,["itemname"]="Dartbringer",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2021"}},
{"Gun","Disint",{["itemid"]=196751943,["itemname"]="Laser",["itemtype"]="Gun",["rarity"]="Classic"}},
{"Gun","Drool_G_2026",{["itemid"]=127882805300276,["itemname"]="Drool",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2026"}},
{"Gun","Duckies_G_2026",{["itemid"]=124567820488562,["itemname"]="Duckies",["itemtype"]="Gun",["rarity"]="Common",["year"]="2026"}},
{"Gun","ElderwoodGun",{["itemid"]=4211142894,["itemname"]="Elderwood Revolver",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2019"}},
{"Gun","ElderwoodGunBlue",{["itemid"]=4468574885,["itemname"]="Blue Elderwood",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2019"}},
{"Gun","ElderwoodGunBronze",{["itemid"]=4468585407,["itemname"]="Bronze Elderwood",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2019"}},
{"Gun","ElderwoodGunGold",{["itemid"]=4468584345,["itemname"]="Gold Elderwood",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2019"}},
{"Gun","ElderwoodGunSilver",{["itemid"]=4468583758,["itemname"]="Silver Elderwood",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2019"}},
{"Gun","Elf_G_2023",{["itemid"]=15635569893,["itemname"]="Elf",["itemtype"]="Gun",["rarity"]="Common",["year"]="2023"}},
{"Gun","ElfGun",{["itemid"]=332767999,["itemname"]="Elf",["itemtype"]="Gun",["rarity"]="Common",["year"]="2015"}},
{"Gun","Emberbow",{["itemid"]=109700223945658,["itemname"]="Emberbow",["itemtype"]="Gun",["rarity"]="Ancient",["year"]="2026"}},
{"Gun","EmberbowChroma",{["itemid"]=109700223945658,["itemname"]="Emberbow",["itemtype"]="Gun",["rarity"]="Ancient",["year"]="2026",["chroma"]=true}},
{"Gun","Embergun_G_2026",{["itemid"]=112181366049612,["itemname"]="Embergun",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2026"}},
{"Gun","Emptybringer",{["itemid"]=4749071819,["itemname"]="???",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","EmptybringerChroma",{["chroma"]=true,["itemid"]=4749071819,["itemname"]="???",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Energized_G_2025",{["itemid"]=114403390530326,["itemname"]="Energized",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2025"}},
{"Gun","Engraved",{["itemid"]=203807690,["itemname"]="Engraved",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Eyes_G_2020",{["itemid"]=5866459380,["itemname"]="Watcher",["itemtype"]="Gun",["rarity"]="Common",["year"]="2020"}},
{"Gun","Eyes_G_2025",{["itemid"]=90751163516480,["itemname"]="Eyes",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2025"}},
{"Gun","Fall_G_2025",{["itemid"]=78153346812503,["itemname"]="Fall",["itemtype"]="Gun",["rarity"]="Common",["year"]="2025"}},
{"Gun","FallCamo_G_2021",{["itemid"]=7800257544,["itemname"]="Fall Camo",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2021"}},
{"Gun","Fallout",{["itemid"]=196752601,["itemname"]="Fallout",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Floatie_G_2024",{["itemid"]=18322194067,["itemname"]="Floatie",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Flora",{["itemid"]=138204709945147,["itemname"]="Flora",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Floral_G_2024",{["itemid"]=18323751219,["itemname"]="Floral",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Floral_G_2026",{["itemid"]=107508982214346,["itemname"]="Floral",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2026"}},
{"Gun","FlowerwoodGun",{["itemid"]=16963894455,["itemname"]="Flowerwood Gun",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Forest_G_2024",{["itemid"]=78199422065424,["itemname"]="Forest",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2024"}},
{"Gun","Fragile_G_2023",{["itemid"]=12965349193,["itemname"]="Fragile",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Frosted_G_2019",{["itemid"]=4534866678,["itemname"]="Frosted",["itemtype"]="Gun",["rarity"]="Common",["year"]="2019"}},
{"Gun","Frostfade_G_2023",{["itemid"]=15635577623,["itemname"]="Frostfade",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2023"}},
{"Gun","Frostflame_G_2024",{["itemid"]=114781759936576,["itemname"]="Frostflame",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2024"}},
{"Gun","Frozen_G_2019",{["itemid"]=4534873956,["itemname"]="Frozen",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2019"}},
{"Gun","Frozen_G_2022",{["itemid"]=11834445016,["itemname"]="Frozen",["itemtype"]="Gun",["rarity"]="Common",["year"]="2022"}},
{"Gun","Frozen_G_2023",{["itemid"]=15635571468,["itemname"]="Frozen",["itemtype"]="Gun",["rarity"]="Common",["year"]="2023"}},
{"Gun","Frozen_G_2025",{["itemid"]=90622014285727,["itemname"]="Frozen",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2025"}},
{"Gun","Galactic",{["itemid"]=196752683,["itemname"]="Galactic",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Ghastly_G_2023",{["itemid"]=15091342564,["itemname"]="Ghastly",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2023"}},
{"Gun","Ghost_G_2026",{["itemid"]=120512330305244,["itemname"]="Ghost",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Ghostfire_G_2022",{["itemid"]=11284140034,["itemname"]="Ghostfire",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2022"}},
{"Gun","GhostG2018",{["itemid"]=2513741407,["itemname"]="Ghost",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2018"}},
{"Gun","Ghosts_G_2020",{["itemid"]=5866465099,["itemname"]="Ghosts",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2020"}},
{"Gun","Ghosts_G_2021",{["itemid"]=7800251557,["itemname"]="Wraiths",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2021"}},
{"Gun","Gift_G_2020",{["itemid"]=6121867603,["itemname"]="Wrap",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2020"}},
{"Gun","Giftbag_G_2020",{["itemid"]=6121864813,["itemname"]="Gift Bag",["itemtype"]="Gun",["rarity"]="Common",["year"]="2020"}},
{"Gun","Gifts_G_2019",{["itemid"]=4534867381,["itemname"]="Gifts",["itemtype"]="Gun",["rarity"]="Common",["year"]="2019"}},
{"Gun","Ginger_G_2018",{["itemid"]=2669785821,["itemname"]="Ginger",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2018"}},
{"Gun","Gingerbread_G_2019",{["itemid"]=4534872116,["itemname"]="Gingerbread",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2019"}},
{"Gun","Gingerbread_G_2020",{["itemid"]=6121860619,["itemname"]="Gingerbread",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2020"}},
{"Gun","Gingerbread_G_2021",{["itemid"]=8304772140,["itemname"]="Gingerbread",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2021"}},
{"Gun","Gingerbread_G_2022",{["itemid"]=11834442414,["itemname"]="Gingerbread",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2022"}},
{"Gun","Gingerbread_G_2025",{["itemid"]=74908113882525,["itemname"]="Gingerbread",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2025"}},
{"Gun","Gingercookie_G_2025",{["itemid"]=99160839686845,["itemname"]="Gingercookie",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2025"}},
{"Gun","GingerGun",{["itemid"]=332497038,["itemname"]="Ginger",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2015"}},
{"Gun","GingerLuger",{["itemid"]=2674983099,["itemname"]="Ginger Luger",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2018"}},
{"Gun","Gingermint_G",{["itemid"]=11872179646,["itemname"]="Gingermint",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2022"}},
{"Gun","Gingerscope",{["itemid"]=15666469505,["itemname"]="Gingerscope",["itemtype"]="Gun",["rarity"]="Ancient",["year"]="2023"}},
{"Gun","Gingerscope_Blue",{["itemid"]=16964462231,["itemname"]="Blue Gingerscope",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2023"}},
{"Gun","Gingerscope_Bronze",{["itemid"]=16964465320,["itemname"]="Bronze Gingerscope",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2023"}},
{"Gun","Gingerscope_Gold",{["itemid"]=16964471890,["itemname"]="Gold Gingerscope",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2023"}},
{"Gun","Gingerscope_Silver",{["itemid"]=16964468980,["itemname"]="Silver Gingerscope",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2023"}},
{"Gun","Glow_G_2026",{["itemid"]=103256722738134,["itemname"]="Glow",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2026"}},
{"Gun","GoldenGun",{["itemid"]=196751989,["itemname"]="Golden",["itemtype"]="Gun",["rarity"]="Classic"}},
{"Gun","GoldHarvester",{["itemid"]=8194222523,["itemname"]="Gold Harvester",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2021"}},
{"Gun","GoldIceblaster",{["itemid"]=6404165933,["itemname"]="Gold Iceblaster",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2020"}},
{"Gun","GoldSugar",{["itemid"]=3215260149,["itemname"]="Gold Sugar",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2018"}},
{"Gun","Gothic_G_2021",{["itemid"]=7800253970,["itemname"]="Gothic",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2021"}},
{"Gun","GraveG",{["itemid"]=2513731746,["itemname"]="Grave",["itemtype"]="Gun",["rarity"]="Common",["year"]="2018"}},
{"Gun","GreenLuger",{["itemid"]=332044679,["itemname"]="Green Luger",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2015"}},
{"Gun","Gun1",{["itemid"]=196752052,["itemname"]="Cowboy",["itemtype"]="Gun",["rarity"]="Classic"}},
{"Gun","Hacker",{["itemid"]=203819271,["itemname"]="Hacker",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Hallowgun",{["itemid"]=5878721461,["itemname"]="Hallowgun",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2020"}},
{"Gun","Harvester",{["itemid"]=7800847534,["itemname"]="Harvester",["itemtype"]="Gun",["rarity"]="Ancient",["year"]="2021"}},
{"Gun","HauntedG",{["itemid"]=2513741901,["itemname"]="Haunted",["itemtype"]="Gun",["rarity"]="Common",["year"]="2018"}},
{"Gun","Hazard_G_2022",{["itemid"]=11255505449,["itemname"]="Hazard",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2022"}},
{"Gun","Heartbreak_G_2026",{["itemid"]=79235438948261,["itemname"]="Heartbreak",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2026"}},
{"Gun","HL2",{["itemid"]=238546100,["itemname"]="HL2",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Holly_G_2018",{["itemid"]=2669786261,["itemname"]="Holly",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2018"}},
{"Gun","Hologram_G_2025",{["itemid"]=108751717527377,["itemname"]="Hologram",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2025"}},
{"Gun","Icebeam",{["itemid"]=8311005531,["itemname"]="Icebeam",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2021"}},
{"Gun","Iceblaster",{["itemid"]=6125814417,["itemname"]="Iceblaster",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2020"}},
{"Gun","IceCamo_G_2021",{["itemid"]=8304767724,["itemname"]="Ice Camo",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2021"}},
{"Gun","Icedriller_G_2020",{["itemid"]=6121866490,["itemname"]="Icedriller",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2020"}},
{"Gun","Icepiercer",{["itemid"]=11874071041,["itemname"]="Icepiercer",["itemtype"]="Gun",["rarity"]="Ancient",["year"]="2022"}},
{"Gun","IcepiercerBronze",{["itemid"]=12226920195,["itemname"]="Bronze Icepiercer",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2022"}},
{"Gun","IcepiercerGold",{["itemid"]=12226688172,["itemname"]="Gold Icepiercer",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2022"}},
{"Gun","IcepiercerRed",{["itemid"]=12227133450,["itemname"]="Red Icepiercer",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2022"}},
{"Gun","IcepiercerSilver",{["itemid"]=12226843957,["itemname"]="Silver Icepiercer",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2022"}},
{"Gun","Icicles_G_2018",{["itemid"]=2669786044,["itemname"]="Icicles",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2018"}},
{"Gun","Igloo_G_2024",{["itemid"]=95517099886712,["itemname"]="Igloo",["itemtype"]="Gun",["rarity"]="Common",["year"]="2024"}},
{"Gun","Imbued",{["itemid"]=196752718,["itemname"]="Imbued",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Immortal",{["itemid"]=112675577042738,["itemname"]="Immortal",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2026"}},
{"Gun","ImmortalChroma",{["itemid"]=112675577042738,["itemname"]="Immortal",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2026",["chroma"]=true}},
{"Gun","Infected_G_2022",{["itemid"]=11255502768,["itemname"]="Infected",["itemtype"]="Gun",["rarity"]="Common",["year"]="2022"}},
{"Gun","Infiltrator",{["itemid"]=203806022,["itemname"]="Infiltrator",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","iRevolver",{["itemid"]=203809168,["itemname"]="iRevolver",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Iron",{["itemid"]=196752812,["itemname"]="Iron",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Jinglegun",{["itemid"]=6125742758,["itemname"]="Jinglegun",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2020"}},
{"Gun","Laser",{["itemid"]=238546983,["itemname"]="Laser",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","LaserChroma",{["chroma"]=true,["itemid"]=3187395952,["itemname"]="Laser",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Latte_G_2023",{["itemid"]=15413116029,["itemname"]="Latte",["itemtype"]="Gun",["rarity"]="Legendary"}},
{"Gun","Lava_G_2025",{["itemid"]=90170220549489,["itemname"]="Lava",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2025"}},
{"Gun","Leaves_G_2024",{["itemid"]=129970927613267,["itemname"]="Leaves",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2024"}},
{"Gun","Lightbringer",{["itemid"]=4749070432,["itemname"]="Lightbringer",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Lights_G_2019",{["itemid"]=4534872673,["itemname"]="Lights",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2019"}},
{"Gun","Lights_G_2025",{["itemid"]=104258636970738,["itemname"]="Lights",["itemtype"]="Gun",["rarity"]="Common",["year"]="2025"}},
{"Gun","LoveGun",{["itemid"]=203867650,["itemname"]="Love",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Luger",{["itemid"]=198042673,["itemname"]="Luger",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Lugercane",{["itemid"]=4535482609,["itemname"]="Lugercane",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2019"}},
{"Gun","LugerChroma",{["chroma"]=true,["itemid"]=3187395551,["itemname"]="Luger",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Magma_G_2021",{["itemid"]=7800252572,["itemname"]="Magma",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2021"}},
{"Gun","Makeshift",{["itemid"]=11229837140,["itemname"]="Makeshift",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2022"}},
{"Gun","Marina",{["itemid"]=203808190,["itemname"]="Marina",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Meadow_G_2025",{["itemid"]=107321881182350,["itemname"]="Meadow",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Melon_G_2023",{["itemid"]=13944153861,["itemname"]="Melon",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Minty",{["itemid"]=4535408229,["itemname"]="Minty",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2019"}},
{"Gun","MintyBlue",{["itemid"]=4753347062,["itemname"]="Blue Minty",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2019"}},
{"Gun","MintyBronze",{["itemid"]=4753348263,["itemname"]="Bronze Minty",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2019"}},
{"Gun","MintyGold",{["itemid"]=4753347636,["itemname"]="Gold Minty",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2019"}},
{"Gun","MintySilver",{["itemid"]=4753346087,["itemname"]="Silver Minty",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2019"}},
{"Gun","Mistletoe_G_2022",{["itemid"]=11834438982,["itemname"]="Mistletoe",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2022"}},
{"Gun","Molten",{["itemid"]=203869308,["itemname"]="Molten",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Monster",{["itemid"]=4210941474,["itemname"]="Monster",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2019"}},
{"Gun","Moonlight_G_2022",{["itemid"]=11284143055,["itemname"]="Moonlight",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2022"}},
{"Gun","Mummy",{["itemid"]=315155591,["itemname"]="Mummy",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2015"}},
{"Gun","Mummy_G_2020",{["itemid"]=5866463755,["itemname"]="Mummy",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2020"}},
{"Gun","MummyG2018",{["itemid"]=2513741663,["itemname"]="Mummy",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2018"}},
{"Gun","Neon_G_2023",{["itemid"]=15635560825,["itemname"]="Neon",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2023"}},
{"Gun","Neon_G_2025",{["itemid"]=134429631587448,["itemname"]="Neon",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2025"}},
{"Gun","News",{["itemid"]=238546032,["itemname"]="News",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Night",{["itemid"]=197829003,["itemname"]="Night",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Nightfire",{["itemid"]=4659626966,["itemname"]="Nightfire",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Nuke_G_2023",{["itemid"]=12965335931,["itemname"]="Nuke",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Nutcracker",{["itemid"]=332497657,["itemname"]="Nutcracker",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2015"}},
{"Gun","Ocean_G",{["itemid"]=13945898892,["itemname"]="Ocean",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Ornament1Gun",{["itemid"]=332497144,["itemname"]="Ornament1",["itemtype"]="Gun",["rarity"]="Common",["year"]="2015"}},
{"Gun","Ornament2Gun",{["itemid"]=332497550,["itemname"]="Ornament2",["itemtype"]="Gun",["rarity"]="Common",["year"]="2015"}},
{"Gun","Ornaments_G_2020",{["itemid"]=6121863515,["itemname"]="Ornaments",["itemtype"]="Gun",["rarity"]="Common",["year"]="2020"}},
{"Gun","Overseer",{["itemid"]=197830043,["itemname"]="Overseer",["itemtype"]="Gun",["rarity"]="Legendary"}},
{"Gun","Painted_G_2023",{["itemid"]=12965344675,["itemname"]="Painted",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Palms_G_2024",{["itemid"]=18322192817,["itemname"]="Palms",["itemtype"]="Gun",["rarity"]="Legendary"}},
{"Gun","Paws_G_2026",{["itemid"]=120089556380493,["itemname"]="Paws",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2026"}},
{"Gun","Pea",{["itemid"]=238545971,["itemname"]="Pea",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Pearl_G",{["itemid"]=18322646152,["itemname"]="Pearlshine",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Peppermint_G_2025",{["itemid"]=73148873488539,["itemname"]="Peppermint",["itemtype"]="Gun",["rarity"]="Common",["year"]="2025"}},
{"Gun","Phaser",{["itemid"]=196752144,["itemname"]="Phaser",["itemtype"]="Gun",["rarity"]="Classic"}},
{"Gun","Pine_G_2019",{["itemid"]=4534871260,["itemname"]="Pine",["itemtype"]="Gun",["rarity"]="Common",["year"]="2019"}},
{"Gun","Pirate",{["itemid"]=3183639867,["itemname"]="Pirate",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Plaid_G_2026",{["itemid"]=121681210724670,["itemname"]="Plaid",["itemtype"]="Gun",["rarity"]="Common",["year"]="2026"}},
{"Gun","Plasmabeam",{["itemid"]=10014717343,["itemname"]="Plasmabeam",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","PopArt_G_2025",{["itemid"]=90526048501163,["itemname"]="Pop Art",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2025"}},
{"Gun","Popsicle_G_2024",{["itemid"]=18322191060,["itemname"]="Popsicle",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Portal_G_2020",{["itemid"]=5866461926,["itemname"]="Portal",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2020"}},
{"Gun","PotionG2018",{["itemid"]=2513742133,["itemname"]="Potion",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2018"}},
{"Gun","Predator",{["itemid"]=203810176,["itemname"]="Predator",["itemtype"]="Gun",["rarity"]="Legendary"}},
{"Gun","Prince_G_2026",{["itemid"]=87296563281923,["itemname"]="Prince",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Pumpkin_G_2023",{["itemid"]=15091327743,["itemname"]="Pumpkin",["itemtype"]="Gun",["rarity"]="Common",["year"]="2023"}},
{"Gun","PumpkinPatch_G_2025",{["itemid"]=117088166092009,["itemname"]="Pumpkin Patch",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2025"}},
{"Gun","Rainbow_G",{["itemid"]=12966354606,["itemname"]="Rainbow Gun",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","RainbowGun",{["itemid"]=3183640145,["itemname"]="Rainbow",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Raygun",{["itemid"]=139431943195380,["itemname"]="Raygun",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2025"}},
{"Gun","RaygunBronze",{["itemid"]=138881346504998,["itemname"]="Bronze Raygun",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2025"}},
{"Gun","RaygunChroma",{["chroma"]=true,["itemid"]=139431943195380,["itemname"]="Raygun",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2025"}},
{"Gun","RaygunGold",{["itemid"]=76250851065456,["itemname"]="Gold Raygun",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2025"}},
{"Gun","RaygunRed",{["itemid"]=132354489228618,["itemname"]="Red Raygun",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2025"}},
{"Gun","RaygunSilver",{["itemid"]=71511736314707,["itemname"]="Silver Raygun",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2025"}},
{"Gun","RedIceblaster",{["itemid"]=6404168049,["itemname"]="Red Iceblaster",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2020"}},
{"Gun","RedLuger",{["itemid"]=332044583,["itemname"]="Red Luger",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2015"}},
{"Gun","RIP",{["itemid"]=4210947993,["itemname"]="RIP",["itemtype"]="Gun",["rarity"]="Common",["year"]="2019"}},
{"Gun","Ripper_G_2020",{["itemid"]=5866460591,["itemname"]="Ripper",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2020"}},
{"Gun","Ritual_G_2024",{["itemid"]=122021199074749,["itemname"]="Ritual",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2024"}},
{"Gun","Sands",{["itemid"]=119213058412452,["itemname"]="Sands",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2026"}},
{"Gun","SandsChroma",{["chroma"]=true,["itemid"]=119213058412452,["itemname"]="Sands",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2026"}},
{"Gun","Sandy_G_2024",{["itemid"]=18323752709,["itemname"]="Sandy",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Santa_G_2018",{["itemid"]=2669785184,["itemname"]="Elf",["itemtype"]="Gun",["rarity"]="Common",["year"]="2018"}},
{"Gun","Santa_G_2023",{["itemid"]=15635550625,["itemname"]="Santa",["itemtype"]="Gun",["rarity"]="Common",["year"]="2023"}},
{"Gun","SantaGun",{["itemid"]=332496861,["itemname"]="Santa",["itemtype"]="Gun",["rarity"]="Common",["year"]="2015"}},
{"Gun","Shadow_G_2026",{["itemid"]=131289807674112,["itemname"]="Shadow",["itemtype"]="Gun",["rarity"]="Legendary"}},
{"Gun","Shark",{["itemid"]=203858533,["itemname"]="Shark",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","SharkChroma",{["chroma"]=true,["itemid"]=3187395738,["itemname"]="Shark",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","SharkSeeker",{["itemid"]=6967771328,["itemname"]="SharkSeeker",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2021"}},
{"Gun","SilentNight_G_2020",{["itemid"]=6121862034,["itemname"]="Silent Night",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2020"}},
{"Gun","SilverHarvester",{["itemid"]=8194217388,["itemname"]="Silver Harvester",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2021"}},
{"Gun","SilverIceblaster",{["itemid"]=6404166698,["itemname"]="Silver Iceblaster",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2020"}},
{"Gun","SilverSugar",{["itemid"]=3215261680,["itemname"]="Silver Sugar",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2018"}},
{"Gun","Sketch",{["itemid"]=203808108,["itemname"]="Sketch",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","SlimeG",{["itemid"]=2513742319,["itemname"]="Slime",["itemtype"]="Gun",["rarity"]="Common",["year"]="2018"}},
{"Gun","SlouseClownGun",{["itemid"]=4659627976,["itemname"]="Clown",["itemtype"]="Gun",["rarity"]="Unique",["year"]=""}},
{"Gun","SnakebiteG",{["itemid"]=4210925026,["itemname"]="Snakebite",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2019"}},
{"Gun","Snowball_G_2025",{["itemid"]=104416405402940,["itemname"]="Snowball",["itemtype"]="Gun",["rarity"]="Common",["year"]="2025"}},
{"Gun","Snowcannon",{["itemid"]=129186939023729,["itemname"]="Snowcannon",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2025"}},
{"Gun","SnowcannonBronze",{["itemid"]=84743767811732,["itemname"]="Bronze Snowcannon",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2025"}},
{"Gun","SnowcannonChroma",{["chroma"]=true,["itemid"]=129186939023729,["itemname"]="Snowcannon",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2025"}},
{"Gun","SnowcannonGold",{["itemid"]=115609046800090,["itemname"]="Gold Snowcannon",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2025"}},
{"Gun","SnowcannonRed",{["itemid"]=110812086479763,["itemname"]="Red Snowcannon",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2025"}},
{"Gun","SnowcannonSilver",{["itemid"]=83838802472095,["itemname"]="Silver Snowcannon",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2025"}},
{"Gun","Snowflake_G_2018",{["itemid"]=2669786515,["itemname"]="Snowflake",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2018"}},
{"Gun","Snowflake_G_2022",{["itemid"]=11834437796,["itemname"]="Snowflake",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2022"}},
{"Gun","Snowflake_G_2023",{["itemid"]=15635575718,["itemname"]="Snowflake",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2023"}},
{"Gun","Snowflakes_G_2019",{["itemid"]=4534866065,["itemname"]="Snowflakes",["itemtype"]="Gun",["rarity"]="Common",["year"]="2019"}},
{"Gun","Snowman_G_2018",{["itemid"]=2669786846,["itemname"]="Snowman",["itemtype"]="Gun",["rarity"]="Common",["year"]="2018"}},
{"Gun","Snowman_G_2021",{["itemid"]=8304766932,["itemname"]="Snowman",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2021"}},
{"Gun","Snowman_G_2022",{["itemid"]=11834436620,["itemname"]="Snowman",["itemtype"]="Gun",["rarity"]="Common",["year"]="2022"}},
{"Gun","Snowman_G_2023",{["itemid"]=15635572427,["itemname"]="Snowman",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2023"}},
{"Gun","SnowmanGun",{["itemid"]=332497603,["itemname"]="Snowman",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2015"}},
{"Gun","Soda_G_2025",{["itemid"]=132525981806780,["itemname"]="Soda",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2025"}},
{"Gun","Sparkle",{["itemid"]=203869110,["itemname"]="Sparkle",["itemtype"]="Gun",["rarity"]="Legendary"}},
{"Gun","Spearmint_G_2025",{["itemid"]=81352860339620,["itemname"]="Spearmint",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2025"}},
{"Gun","Spectral_G_2021",{["itemid"]=7800255531,["itemname"]="Spectral",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2021"}},
{"Gun","Spectre2022",{["itemid"]=11229779932,["itemname"]="Spectre",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2022"}},
{"Gun","Spitfire",{["itemid"]=197829561,["itemname"]="Spitfire",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Splash_G",{["itemid"]=4659626370,["itemname"]="Splash",["itemtype"]="Gun",["rarity"]="Legendary"}},
{"Gun","Splat",{["itemid"]=3183639522,["itemname"]="Splat",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Star",{["itemid"]=203807904,["itemname"]="Star",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Starfish_G_2024",{["itemid"]=18322189584,["itemname"]="Starfish",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Starry_G_2020",{["itemid"]=5930731295,["itemname"]="Starry",["itemtype"]="Gun",["rarity"]="Common",["year"]="2020"}},
{"Gun","Starry_G_2021",{["itemid"]=8304772774,["itemname"]="Starry",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2021"}},
{"Gun","Stars_G_2023",{["itemid"]=15635574031,["itemname"]="Stars",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2023"}},
{"Gun","Steel_G_2023",{["itemid"]=15091341552,["itemname"]="Steel",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2023"}},
{"Gun","Stickers_G_2021",{["itemid"]=7800257010,["itemname"]="Stickers",["itemtype"]="Gun",["rarity"]="Common",["year"]="2021"}},
{"Gun","Stickers_G_2024",{["itemid"]=108122054293502,["itemname"]="Stickers",["itemtype"]="Gun",["rarity"]="Common",["year"]="2024"}},
{"Gun","Stickers_G_2025",{["itemid"]=75123474631661,["itemname"]="Stickers",["itemtype"]="Gun",["rarity"]="Common",["year"]="2025"}},
{"Gun","Stickers_X_G_2024",{["itemid"]=91224254479440,["itemname"]="Stickers",["itemtype"]="Gun",["rarity"]="Common",["year"]="2024"}},
{"Gun","StickersX_G_2022",{["itemid"]=11834432971,["itemname"]="Stickers",["itemtype"]="Gun",["rarity"]="Common",["year"]="2022"}},
{"Gun","StickersX_G_2025",{["itemid"]=127489830827583,["itemname"]="Stickers",["itemtype"]="Gun",["rarity"]="Common",["year"]="2025"}},
{"Gun","Stockings_G_2022",{["itemid"]=11834440319,["itemname"]="Stockings",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2022"}},
{"Gun","Stockings_G_2024",{["itemid"]=76288270695961,["itemname"]="Stockings",["itemtype"]="Gun",["rarity"]="Common",["year"]="2024"}},
{"Gun","Strawberries_G_2026",{["itemid"]=128646835922561,["itemname"]="Strawberries",["itemtype"]="Gun",["rarity"]="Common",["year"]="2026"}},
{"Gun","Striped_G_2025",{["itemid"]=118530164125152,["itemname"]="Striped",["itemtype"]="Gun",["rarity"]="Common",["year"]="2025"}},
{"Gun","Sugar",{["itemid"]=332848695,["itemname"]="Sugar",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2015"}},
{"Gun","Summer_Stickers_G_2023",{["itemid"]=13944151514,["itemname"]="Stickers",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Sunny_G_2025",{["itemid"]=93906279038399,["itemname"]="Sunny",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Sunset_G_2023",{["itemid"]=13944155639,["itemname"]="Sun",["itemtype"]="Gun",["rarity"]="Rare"}},
{"Gun","Sunset_G_2026",{["itemid"]=120907601916735,["itemname"]="Sunset",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2026"}},
{"Gun","SunsetGun",{["itemid"]=129480661108374,["itemname"]="Sunrise",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2025"}},
{"Gun","SunsetGunChroma",{["chroma"]=true,["itemid"]=129480661108374,["itemname"]="Sunrise",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2025"}},
{"Gun","Sweater_G_2018",{["itemid"]=2669787088,["itemname"]="Sweater",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2018"}},
{"Gun","Sweater_G_2025",{["itemid"]=118557229750245,["itemname"]="Sweater",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2025"}},
{"Gun","SwirlyGun",{["itemid"]=8305264097,["itemname"]="Swirly Gun",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2021"}},
{"Gun","SwirlyGunBlue",{["itemid"]=9552060741,["itemname"]="Blue Swirly",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2021"}},
{"Gun","SwirlyGunBronze",{["itemid"]=9552063524,["itemname"]="Bronze Swirly",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2021"}},
{"Gun","SwirlyGunChroma",{["chroma"]=true,["itemid"]=8311393414,["itemname"]="Swirly Gun",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2021"}},
{"Gun","SwirlyGunGold",{["itemid"]=9552065167,["itemname"]="Gold Swirly",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2021"}},
{"Gun","SwirlyGunSilver",{["itemid"]=9552064240,["itemname"]="Silver Swirly",["itemtype"]="Gun",["rarity"]="Unique",["year"]="2021"}},
{"Gun","ToxicG",{["itemid"]=2513742519,["itemname"]="Toxic",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2018"}},
{"Gun","Toy_G_2023",{["itemid"]=13944152795,["itemname"]="Toy",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Traveler_G_2023",{["itemid"]=15091344462,["itemname"]="Traveler",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2023"}},
{"Gun","TravelerGun",{["itemid"]=15091442039,["itemname"]="Traveler's Gun",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2023"}},
{"Gun","TravelerGunChroma",{["chroma"]=true,["itemid"]=15097897227,["itemname"]="Traveler's Gun",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2023"}},
{"Gun","Treat",{["itemid"]=131626924640663,["itemname"]="Treat",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2026"}},
{"Gun","TreatChroma",{["chroma"]=true,["itemid"]=131626924640663,["itemname"]="Treat",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2026"}},
{"Gun","Treats_G_2025",{["itemid"]=76537883908961,["itemname"]="Treats",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2025"}},
{"Gun","Tree_G_2022",{["itemid"]=11834441321,["itemname"]="Tree",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2022"}},
{"Gun","TreeGun",{["itemid"]=332497688,["itemname"]="Tree",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2015"}},
{"Gun","TreeGun2023",{["itemid"]=15682703596,["itemname"]="Evergun",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2023"}},
{"Gun","TreeGun2023Chroma",{["chroma"]=true,["itemid"]=15682703596,["itemname"]="Evergun",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2023"}},
{"Gun","UFOs_G_2025",{["itemid"]=84030107970606,["itemname"]="UFOs",["itemtype"]="Gun",["rarity"]="Common",["year"]="2025"}},
{"Gun","Universe",{["itemid"]=238546660,["itemname"]="Universe",["itemtype"]="Gun",["rarity"]="Legendary"}},
{"Gun","Vampire_G_2022",{["itemid"]=11255503583,["itemname"]="Vampire",["itemtype"]="Gun",["rarity"]="Legendary",["year"]="2022"}},
{"Gun","VampireG2018",{["itemid"]=2513742751,["itemname"]="Vampire",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2018"}},
{"Gun","VampireGun",{["itemid"]=90274872705656,["itemname"]="Vampire's Gun",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2024"}},
{"Gun","VampireGunChroma",{["chroma"]=true,["itemid"]=90274872705656,["itemname"]="Vampire's Gun",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2024"}},
{"Gun","Vines_G_2023",{["itemid"]=15091402817,["itemname"]="Vines",["itemtype"]="Gun",["rarity"]="Common",["year"]="2023"}},
{"Gun","Viper",{["itemid"]=196752926,["itemname"]="Viper",["itemtype"]="Gun",["rarity"]="Legendary"}},
{"Gun","Watcher_G_2021",{["itemid"]=7800256309,["itemname"]="Watcher",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2021"}},
{"Gun","WaterBalloons_G_2024",{["itemid"]=18323751962,["itemname"]="Balloons",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","Watergun",{["itemid"]=18351388416,["itemname"]="Watergun",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","WatergunChroma",{["chroma"]=true,["itemid"]=18351401528,["itemname"]="Watergun",["itemtype"]="Gun",["rarity"]="Godly"}},
{"Gun","Wavy_G_2024",{["itemid"]=16960077712,["itemname"]="Wavy",["itemtype"]="Gun",["rarity"]="Common"}},
{"Gun","WebbedG",{["itemid"]=4210936652,["itemname"]="Webbed",["itemtype"]="Gun",["rarity"]="Common",["year"]="2019"}},
{"Gun","Webs_G_2022",{["itemid"]=11284147880,["itemname"]="Webs",["itemtype"]="Gun",["rarity"]="Common",["year"]="2022"}},
{"Gun","Wolf_G_2026",{["itemid"]=137524176709656,["itemname"]="Wolf",["itemtype"]="Gun",["rarity"]="Common",["year"]="2026"}},
{"Gun","Wooden",{["itemid"]=238546356,["itemname"]="Wooden",["itemtype"]="Gun",["rarity"]="Uncommon"}},
{"Gun","Wraith_G_2022",{["itemid"]=11255504462,["itemname"]="Wraith",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2022"}},
{"Gun","WraithGun",{["itemid"]=75233248021696,["itemname"]="Soul",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2024"}},
{"Gun","Wrapped_G_2018",{["itemid"]=2669787533,["itemname"]="Wrapped",["itemtype"]="Gun",["rarity"]="Common",["year"]="2018"}},
{"Gun","Wrapped_G_2024",{["itemid"]=109929760056853,["itemname"]="Wrapped",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2024"}},
{"Gun","WrappedGun",{["itemid"]=332497103,["itemname"]="Wrapped",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2015"}},
{"Gun","Xeno_G_2025",{["itemid"]=139755862211442,["itemname"]="Xeno",["itemtype"]="Gun",["rarity"]="Rare",["year"]="2025"}},
{"Gun","XenoGun",{["itemid"]=79722325448464,["itemname"]="Xenoshot",["itemtype"]="Gun",["rarity"]="Godly",["year"]="2025"}},
{"Gun","XmasStickers_G_2021",{["itemid"]=8304770115,["itemname"]="Stickers",["itemtype"]="Gun",["rarity"]="Common",["year"]="2021"}},
{"Gun","ZombieG2018",{["itemid"]=2513743298,["itemname"]="Zombie",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2018"}},
{"Gun","ZombifiedG",{["itemid"]=4210944924,["itemname"]="Zombified",["itemtype"]="Gun",["rarity"]="Uncommon",["year"]="2019"}},
{"Knife","2015",{["itemid"]=199026945,["itemname"]="2015",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","8bit",{["itemid"]=198438554,["itemname"]="8bit",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Abduction_K_2025",{["itemid"]=107510647616718,["itemname"]="Abduction",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2025"}},
{"Knife","Abstract",{["itemid"]=365569428,["itemname"]="Abstract",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Adurite",{["itemid"]=196749885,["itemname"]="Adurite",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Alex",{["itemid"]=546159020,["itemname"]="Alex",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","AmericaSword",{["itemid"]=473570051,["itemname"]="Old Glory",["itemtype"]="Knife",["offset"]={["X"]=-0.1,["Y"]=0,["Z"]=0.55},["rarity"]="Godly"}},
{"Knife","Apoc_K_2022",{["itemid"]=11254172968,["itemname"]="Apocalypse",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","Aqua",{["itemid"]=315501208,["itemname"]="Aqua",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Aquarium_K_2025",{["itemid"]=80900354672590,["itemname"]="Aquarium",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2025"}},
{"Knife","Arctic_K_2022",{["itemid"]=11834401547,["itemname"]="Arctic",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2022"}},
{"Knife","Aurora_K_2019",{["itemid"]=4534860689,["itemname"]="Aurora",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2019"}},
{"Knife","Aurora_K_2021",{["itemid"]=8304750877,["itemname"]="Aurora",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2021"}},
{"Knife","AuroraKnife",{["itemid"]=101343256002049,["itemname"]="Australis",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2024"}},
{"Knife","Bats",{["itemid"]=531873625,["itemname"]="Bats",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2016"}},
{"Knife","Bats_K_2020",{["itemid"]=5930729222,["itemname"]="Bats",["itemtype"]="Knife",["rarity"]="Common",["year"]="2020"}},
{"Knife","Bats_K_2024",{["itemid"]=104747488009018,["itemname"]="Bats",["itemtype"]="Knife",["rarity"]="Common",["year"]="2024"}},
{"Knife","Bats_K_2025",{["itemid"]=140366567839959,["itemname"]="Cats",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","Bats_K_2026",{["itemid"]=97796748868270,["itemname"]="Bats",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2026"}},
{"Knife","BatsK",{["itemid"]=2513732731,["itemname"]="Bats",["itemtype"]="Knife",["rarity"]="Common",["year"]="2018"}},
{"Knife","BattleAxe",{["itemid"]=1133237368,["itemname"]="BattleAxe",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2017"}},
{"Knife","BattleAxe2",{["itemid"]=2513535503,["itemname"]="BattleAxe II",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2018"}},
{"Knife","Batwing",{["itemid"]=196751515,["itemname"]="Glitch1",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","BaubleKnife",{["itemid"]=111092946728824,["itemname"]="Ornament",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2025"}},
{"Knife","BaubleKnifeChroma",{["chroma"]=true,["itemid"]=111092946728824,["itemname"]="Ornament",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2025"}},
{"Knife","Beach_K_2023",{["itemid"]=13944135892,["itemname"]="Beach",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Beachy",{["itemid"]=120888453565511,["itemname"]="Beachy",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2026"}},
{"Knife","BeachyChroma",{["chroma"]=true,["itemid"]=120888453565511,["itemname"]="Beachy",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2026"}},
{"Knife","Bells_K_2023",{["itemid"]=15635570486,["itemname"]="Bells",["itemtype"]="Knife",["rarity"]="Common",["year"]="2023"}},
{"Knife","Bio_K_2023",{["itemid"]=12965298174,["itemname"]="Bio",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Bioblade",{["itemid"]=4751539262,["itemname"]="Bioblade",["itemtype"]="Knife",["offset"]={["X"]=-0.1,["Y"]=-0.2,["Z"]=0.6},["rarity"]="Godly"}},
{"Knife","Bleached",{["itemid"]=315500879,["itemname"]="Bleached",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","BloodKnife",{["itemid"]=473573464,["itemname"]="Blood",["itemtype"]="Knife",["rarity"]="Classic"}},
{"Knife","Bloom",{["itemid"]=128553215441980,["itemname"]="Bloom",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Blossom",{["itemid"]=363150561,["itemname"]="Blossom",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Blossom_K_2026",{["itemid"]=110160120309916,["itemname"]="Blossom",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2026"}},
{"Knife","BlueCamo_K_2022",{["itemid"]=11254146743,["itemname"]="Survivor Camo",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","BlueCandy",{["itemid"]=1489495701,["itemname"]="Blue Candy",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2017"}},
{"Knife","BlueSeer",{["itemid"]=3184125087,["itemname"]="Blue Seer",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Bluesteel",{["itemid"]=196750197,["itemname"]="Bluesteel",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","BlueVampiresEdge",{["itemid"]=6084854835,["itemname"]="Blue Vamp's Edge",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2020"}},
{"Knife","Boneblade",{["itemid"]=2513505477,["itemname"]="Boneblade",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2018"}},
{"Knife","BonebladeChroma",{["chroma"]=true,["itemid"]=2513598419,["itemname"]="Boneblade",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2018"}},
{"Knife","Bones",{["itemid"]=531873816,["itemname"]="Bones",["itemtype"]="Knife",["rarity"]="Common",["year"]="2016"}},
{"Knife","Bones_K_2020",{["itemid"]=5872492951,["itemname"]="Bones",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2020"}},
{"Knife","Bones_K_2022",{["itemid"]=11254152435,["itemname"]="Boney",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","Bones_K_2024",{["itemid"]=76461209737867,["itemname"]="Bones",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2024"}},
{"Knife","Borders",{["itemid"]=198434881,["itemname"]="Borders",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Brains",{["itemid"]=531873956,["itemname"]="Brains",["itemtype"]="Knife",["rarity"]="Common",["year"]="2016"}},
{"Knife","Brains2019",{["itemid"]=4210929184,["itemname"]="Brains",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2019"}},
{"Knife","Branches",{["itemid"]=4210943691,["itemname"]="Branches",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2019"}},
{"Knife","Brew_K_2026",{["itemid"]=122819917596476,["itemname"]="Brew",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2026"}},
{"Knife","Broken_K_2023",{["itemid"]=12339323856,["itemname"]="Broken",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","BronzeCandy",{["itemid"]=1520189487,["itemname"]="Bronze Candy",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2017"}},
{"Knife","BronzeHallow",{["itemid"]=2511342846,["itemname"]="Bronze Hallow",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2018"}},
{"Knife","BronzeIcebreaker",{["itemid"]=6404127119,["itemname"]="Bronze Icebreaker",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2020"}},
{"Knife","BronzeVampiresEdge",{["itemid"]=6084842077,["itemname"]="Bronze Vamp's Edge",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2020"}},
{"Knife","Brush",{["itemid"]=365568602,["itemname"]="Brush",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Bubbles_K_2026",{["itemid"]=138388933477235,["itemname"]="Bubbles",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2026"}},
{"Knife","Bullets_K_2026",{["itemid"]=135993253228227,["itemname"]="Bullets",["itemtype"]="Knife",["rarity"]="Common",["year"]="2026"}},
{"Knife","Bunnies_K_2025",{["itemid"]=90549252812333,["itemname"]="Bunnies",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Bunny",{["itemid"]=387874365,["itemname"]="Bunny",["itemtype"]="Knife",["rarity"]="Common",["year"]="2016"}},
{"Knife","CamoKnife",{["itemid"]=3183606225,["itemname"]="Camo",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Candied_K_2022",{["itemid"]=11834384755,["itemname"]="Candied",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","Candle_K_2020",{["itemid"]=5872491708,["itemname"]="Candle",["itemtype"]="Knife",["rarity"]="Common",["year"]="2020"}},
{"Knife","Candleflame",{["itemid"]=7805833970,["itemname"]="Candleflame",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2021"}},
{"Knife","CandleflameChroma",{["chroma"]=true,["itemid"]=7806121918,["itemname"]="Candleflame",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2021"}},
{"Knife","Candles_K_2024",{["itemid"]=133654810681274,["itemname"]="Candles",["itemtype"]="Knife",["rarity"]="Common",["year"]="2024"}},
{"Knife","Candy",{["itemid"]=332021011,["itemname"]="Candy",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2015"}},
{"Knife","CandyCorn",{["itemid"]=1133337797,["itemname"]="CandyCorn",["itemtype"]="Knife",["rarity"]="Common",["year"]="2017"}},
{"Knife","CandyCorn2019",{["itemid"]=4210934082,["itemname"]="Candy Corn",["itemtype"]="Knife",["rarity"]="Common",["year"]="2019"}},
{"Knife","CandyCorn_K_2020",{["itemid"]=5866435364,["itemname"]="Candy Corn",["itemtype"]="Knife",["rarity"]="Common",["year"]="2020"}},
{"Knife","CandyCorn_K_2022",{["itemid"]=11254057417,["itemname"]="Candy Corn",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","CandyCorn_K_2024",{["itemid"]=115093067149752,["itemname"]="Candy Corn",["itemtype"]="Knife",["rarity"]="Common",["year"]="2024"}},
{"Knife","CandyCorn_K_2025",{["itemid"]=86405207895194,["itemname"]="Candy Corn",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","CandyCorn_K_2026",{["itemid"]=76239234099948,["itemname"]="Candy Corn",["itemtype"]="Knife",["rarity"]="Common",["year"]="2026"}},
{"Knife","CandySwirl_K_2019",{["itemid"]=4534860226,["itemname"]="Candy Swirl",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2019"}},
{"Knife","Cane",{["itemid"]=331140746,["itemname"]="Cane",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2015"}},
{"Knife","Cane_K_2018",{["itemid"]=2669638508,["itemname"]="Cane",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2018"}},
{"Knife","Cane_K_2021",{["itemid"]=8304750295,["itemname"]="Cane",["itemtype"]="Knife",["rarity"]="Common",["year"]="2021"}},
{"Knife","Canes_K_2023",{["itemid"]=15635574962,["itemname"]="Canes",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2023"}},
{"Knife","Cardboard",{["itemid"]=235366729,["itemname"]="Cardboard",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Carrot",{["itemid"]=387874071,["itemname"]="Carrot",["itemtype"]="Knife",["rarity"]="Common",["year"]="2016"}},
{"Knife","Carrot_K_2023",{["itemid"]=12965307410,["itemname"]="Carrot",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Carrot_K_2024",{["itemid"]=16959771850,["itemname"]="Carrot",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Carrots_K_2025",{["itemid"]=76914260444878,["itemname"]="Carrots",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Carved_K_2020",{["itemid"]=5866436906,["itemname"]="Carved",["itemtype"]="Knife",["rarity"]="Common",["year"]="2020"}},
{"Knife","Catseye_K_2026",{["itemid"]=139022213069738,["itemname"]="Catseye",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2026"}},
{"Knife","Cavern_K_2019",{["itemid"]=4534861110,["itemname"]="Cavern",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2019"}},
{"Knife","Celestial",{["itemid"]=136673966529736,["itemname"]="Celestial",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2024"}},
{"Knife","Celestial_Bronze",{["itemid"]=119399643874968,["itemname"]="Bronze Celestial",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2024"}},
{"Knife","Celestial_Gold",{["itemid"]=104229967982042,["itemname"]="Gold Celestial",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2024"}},
{"Knife","Celestial_Red",{["itemid"]=119157529694972,["itemname"]="Red Celestial",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2024"}},
{"Knife","Celestial_Silver",{["itemid"]=90241292303974,["itemname"]="Silver Celestial",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2024"}},
{"Knife","Checker",{["itemid"]=198443382,["itemname"]="Checker",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Cheesy",{["itemid"]=198440101,["itemname"]="Cheesy",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Cherry",{["itemid"]=6711852603,["itemname"]="Cherry",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Chick_K_2025",{["itemid"]=116361515042274,["itemname"]="Chick",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Chill",{["itemid"]=332022166,["itemname"]="Chill",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2015"}},
{"Knife","Chips",{["itemid"]=473626317,["itemname"]="Blue",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Choco",{["itemid"]=387874991,["itemname"]="Choco",["itemtype"]="Knife",["rarity"]="Common",["year"]="2016"}},
{"Knife","Chromatic_K_2023",{["itemid"]=12965304445,["itemname"]="Chromatic",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Circuit",{["itemid"]=235366945,["itemname"]="Circuit",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Clan",{["itemid"]=235366460,["itemname"]="Clan",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Clockwork",{["itemid"]=473570519,["itemname"]="Clockwork",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Clown",{["itemid"]=315501118,["itemname"]="Clown",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Clownfish_K_2024",{["itemid"]=18322183619,["itemname"]="Clownfish",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Coal",{["itemid"]=1268699677,["itemname"]="Coal",["itemtype"]="Knife",["rarity"]="Common",["year"]="2017"}},
{"Knife","Coal_K_2018",{["itemid"]=2669638285,["itemname"]="Coal",["itemtype"]="Knife",["rarity"]="Common",["year"]="2018"}},
{"Knife","Coal_K_2021",{["itemid"]=8304751659,["itemname"]="Coal",["itemtype"]="Knife",["rarity"]="Common",["year"]="2021"}},
{"Knife","Coal_K_2022",{["itemid"]=11834390120,["itemname"]="Coal",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","Coconut_K_2025",{["itemid"]=75237025203058,["itemname"]="Coconut",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","Combat",{["itemid"]=3183604570,["itemname"]="Combat",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Combat2",{["itemid"]=4972196241,["itemname"]="Combat II",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Constellation_K_2024",{["itemid"]=113979322866878,["itemname"]="Nightstar",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2024"}},
{"Knife","Cookie_K_2021",{["itemid"]=8304752586,["itemname"]="Cookie",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2021"}},
{"Knife","Cookieblade",{["itemid"]=6125733703,["itemname"]="Cookieblade",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2020"}},
{"Knife","Copper",{["itemid"]=3183605392,["itemname"]="Copper",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Corl",{["itemid"]=546161858,["itemname"]="Corl",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","CottonCandy",{["itemid"]=435933179,["itemname"]="Cotton Candy",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Cowboy_K_2026",{["itemid"]=137905346768007,["itemname"]="Cowboy",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Cracks_K_2021",{["itemid"]=7800224981,["itemname"]="Cracks",["itemtype"]="Knife",["rarity"]="Common",["year"]="2021"}},
{"Knife","Cupid_K_2026",{["itemid"]=123955324398353,["itemname"]="Cupid",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2026"}},
{"Knife","Cursed_K_2024",{["itemid"]=132565936309463,["itemname"]="Cursed",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2024"}},
{"Knife","Damp",{["itemid"]=198443956,["itemname"]="Damp",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Dark_K_2023",{["itemid"]=15091343579,["itemname"]="Darkknife",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2023"}},
{"Knife","Darkness_K_2022",{["itemid"]=11254081561,["itemname"]="Darkness",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","Darksword",{["itemid"]=15080267070,["itemname"]="Darksword",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2023"}},
{"Knife","Deathshard",{["itemid"]=196750305,["itemname"]="Deathshard",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","DeathshardChroma",{["chroma"]=true,["itemid"]=3187390667,["itemname"]="Deathshard",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Decorated_K_2025",{["itemid"]=124860763249593,["itemname"]="Decorated",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","DeepSea",{["itemid"]=4659634072,["itemname"]="Deep Sea",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Denis",{["itemid"]=546161062,["itemname"]="Denis",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Dew",{["itemid"]=473626646,["itemname"]="Black",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Doge",{["itemid"]=235371276,["itemname"]="Doge",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Dolphins_K_2025",{["itemid"]=133219566412887,["itemname"]="Dolphins",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","Donut",{["itemid"]=235366815,["itemname"]="Donut",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Doritos",{["itemid"]=473626740,["itemname"]="Purple",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Drool_K_2026",{["itemid"]=98538217869001,["itemname"]="Drool",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2026"}},
{"Knife","Dungeon",{["itemid"]=4210920512,["itemname"]="Dungeon",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2019"}},
{"Knife","Eclipse_K_2023",{["itemid"]=15091404278,["itemname"]="Eclipse",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2023"}},
{"Knife","Eco",{["itemid"]=365567889,["itemname"]="Eco",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Ecto",{["itemid"]=1133331679,["itemname"]="Ecto",["itemtype"]="Knife",["rarity"]="Common",["year"]="2017"}},
{"Knife","Eggblade",{["itemid"]=6607277825,["itemname"]="Eggblade",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Eggs",{["itemid"]=387875405,["itemname"]="Egg",["itemtype"]="Knife",["rarity"]="Common",["year"]="2016"}},
{"Knife","ElderwoodKnife",{["itemid"]=11262771067,["itemname"]="Elderwood Blade",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2022"}},
{"Knife","ElderwoodKnifeBlue",{["itemid"]=11505913287,["itemname"]="Blue Elderwood",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2022"}},
{"Knife","ElderwoodKnifeBronze",{["itemid"]=11505914752,["itemname"]="Bronze Elderwood",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2022"}},
{"Knife","ElderwoodKnifeChroma",{["chroma"]=true,["itemid"]=11254975176,["itemname"]="Elderwood Blade",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2022"}},
{"Knife","ElderwoodKnifeGold",{["itemid"]=11505917850,["itemname"]="Gold Elderwood",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2022"}},
{"Knife","ElderwoodKnifeSilver",{["itemid"]=11505916486,["itemname"]="Silver Elderwood",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2022"}},
{"Knife","ElderwoodScythe",{["itemid"]=4211148191,["itemname"]="Elderwood Scythe",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2019"}},
{"Knife","Elf",{["itemid"]=331746317,["itemname"]="Elf",["itemtype"]="Knife",["rarity"]="Common",["year"]="2015"}},
{"Knife","Elf2017",{["itemid"]=1268703023,["itemname"]="Elf",["itemtype"]="Knife",["rarity"]="Common",["year"]="2017"}},
{"Knife","Elite",{["itemid"]=241095344,["itemname"]="Elite",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","EliteBlue",{["itemid"]=1269374321,["itemname"]="Blue Elite",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2017"}},
{"Knife","EliteGreen",{["itemid"]=332731156,["itemname"]="Green Elite",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2015"}},
{"Knife","Emberknife_K_2026",{["itemid"]=112982010307079,["itemname"]="Emberknife",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2026"}},
{"Knife","Emberscythe",{["itemid"]=113246722870618,["itemname"]="Emberscythe",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2026"}},
{"Knife","EmberscytheChroma",{["itemid"]=113246722870618,["itemname"]="Emberscythe",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2026",["chroma"]=true}},
{"Knife","Embersickle",{["itemid"]=113946366917108,["itemname"]="Embersickle",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2026"}},
{"Knife","Emerald",{["itemid"]=198444909,["itemname"]="Emerald",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Energized_K_2025",{["itemid"]=86258299490709,["itemname"]="Energized",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2025"}},
{"Knife","Eternal",{["itemid"]=619605312,["itemname"]="Eternal",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Eternal2",{["itemid"]=2545253030,["itemname"]="Eternal II",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Eternal3",{["itemid"]=3279011390,["itemname"]="Eternal III",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Eternal4",{["itemid"]=4999958740,["itemname"]="Eternal IV",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","EternalCane",{["itemid"]=4488391411,["itemname"]="Eternalcane",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2019"}},
{"Knife","Euro",{["itemid"]=305504173,["itemname"]="Euro",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Eyeball_K_2022",{["itemid"]=11254065007,["itemname"]="Eyeball",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","Eyes_K_2020",{["itemid"]=5866438542,["itemname"]="Watcher",["itemtype"]="Knife",["rarity"]="Common",["year"]="2020"}},
{"Knife","Fade",{["itemid"]=315501640,["itemname"]="Fade",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Fang",{["itemid"]=198442811,["itemname"]="Fang",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","FangChroma",{["chroma"]=true,["itemid"]=3187392501,["itemname"]="Fang",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Fanta",{["itemid"]=473626025,["itemname"]="Orange",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Fireplace_K_2023",{["itemid"]=15635558021,["itemname"]="Fireplace",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2023"}},
{"Knife","Flames",{["itemid"]=585873746,["itemname"]="Flames",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Floral_K_2023",{["itemid"]=13944134705,["itemname"]="Floral",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","FlowerwoodKnife",{["itemid"]=16963860501,["itemname"]="Flowerwood",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Fragile_K_2023",{["itemid"]=12965294432,["itemname"]="Fragile",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Frostbite",{["itemid"]=4528484880,["itemname"]="Frostbite",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2019"}},
{"Knife","Frosted_K_2019",{["itemid"]=4534853444,["itemname"]="Frosted",["itemtype"]="Knife",["rarity"]="Common",["year"]="2019"}},
{"Knife","Frostfade_K_2023",{["itemid"]=15635565488,["itemname"]="Frostfade",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2023"}},
{"Knife","Frostflame_K_2024",{["itemid"]=104988218477551,["itemname"]="Frostflame",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2024"}},
{"Knife","Frostsaber",{["itemid"]=1269580035,["itemname"]="Frostsaber",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2017"}},
{"Knife","Frosty",{["itemid"]=1268704507,["itemname"]="Frosty",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2017"}},
{"Knife","Frozen_K_2019",{["itemid"]=4534857523,["itemname"]="Frozen",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2019"}},
{"Knife","Frozen_K_2022",{["itemid"]=11834404402,["itemname"]="Frozen",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","Frozen_K_2023",{["itemid"]=15635556891,["itemname"]="Frozen",["itemtype"]="Knife",["rarity"]="Common",["year"]="2023"}},
{"Knife","Frozen_K_2025",{["itemid"]=108996627787763,["itemname"]="Frozen",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2025"}},
{"Knife","Fusion",{["itemid"]=365569686,["itemname"]="Fusion",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Future",{["itemid"]=197638833,["itemname"]="Future",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Galaxy",{["itemid"]=196750422,["itemname"]="Galaxy",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Gemstone",{["itemid"]=3183598040,["itemname"]="Gemstone",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","GemstoneChroma",{["chroma"]=true,["itemid"]=3183597816,["itemname"]="Gemstone",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Ghastly_K_2023",{["itemid"]=15091407068,["itemname"]="Ghastly",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2023"}},
{"Knife","Ghostblade",{["itemid"]=4221789003,["itemname"]="Ghostblade",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2019"}},
{"Knife","GhostK2018",{["itemid"]=2513732969,["itemname"]="Ghost",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2018"}},
{"Knife","GhostKnife",{["itemid"]=473574401,["itemname"]="Ghost",["itemtype"]="Knife",["rarity"]="Classic"}},
{"Knife","GhostRbx_K_2022",{["itemid"]=11117375743,["itemname"]="Ghostly",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2022"}},
{"Knife","Ghosts_K_2020",{["itemid"]=5866442790,["itemname"]="Ghosts",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2020"}},
{"Knife","Ghosts_K_2021",{["itemid"]=7808362279,["itemname"]="Wraiths",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2021"}},
{"Knife","Ghosts_K_2023",{["itemid"]=15091326116,["itemname"]="Ghosts",["itemtype"]="Knife",["rarity"]="Common",["year"]="2023"}},
{"Knife","Ghosts_K_2024",{["itemid"]=134681523511387,["itemname"]="Ghosts",["itemtype"]="Knife",["rarity"]="Common",["year"]="2024"}},
{"Knife","Ghosty",{["itemid"]=531873080,["itemname"]="Ghosty",["itemtype"]="Knife",["rarity"]="Common",["year"]="2016"}},
{"Knife","Gift_K_2020",{["itemid"]=6121854816,["itemname"]="Wrap",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2020"}},
{"Knife","Giftbag_K_2020",{["itemid"]=6121847170,["itemname"]="Gift Bag",["itemtype"]="Knife",["rarity"]="Common",["year"]="2020"}},
{"Knife","Gifted",{["itemid"]=197626358,["itemname"]="Gifted",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Gifts_K_2019",{["itemid"]=4534856285,["itemname"]="Gifts",["itemtype"]="Knife",["rarity"]="Common",["year"]="2019"}},
{"Knife","Gifts_K_2024",{["itemid"]=129290011017110,["itemname"]="Gifts",["itemtype"]="Knife",["rarity"]="Common",["year"]="2024"}},
{"Knife","Giftwrap_K_2021",{["itemid"]=8304754179,["itemname"]="Giftwrap",["itemtype"]="Knife",["rarity"]="Common",["year"]="2021"}},
{"Knife","Ginger",{["itemid"]=331744703,["itemname"]="Ginger",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2015"}},
{"Knife","Ginger_K_2018",{["itemid"]=2669638742,["itemname"]="Ginger",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2018"}},
{"Knife","Gingerblade",{["itemid"]=2669336659,["itemname"]="Gingerblade",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2018"}},
{"Knife","GingerbladeChroma",{["chroma"]=true,["itemid"]=2672349340,["itemname"]="Gingerblade",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2018"}},
{"Knife","Gingerbread2017",{["itemid"]=1268705527,["itemname"]="Gingerbread",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2017"}},
{"Knife","Gingerbread_K_2019",{["itemid"]=4534856940,["itemname"]="Gingerbread",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2019"}},
{"Knife","Gingerbread_K_2020",{["itemid"]=6121850031,["itemname"]="Gingerbread",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2020"}},
{"Knife","Gingerbread_K_2022",{["itemid"]=11834399071,["itemname"]="Gingerbread",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2022"}},
{"Knife","Gingerbread_K_2025",{["itemid"]=134478959354477,["itemname"]="Gingerbread",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2025"}},
{"Knife","Gingercookie_K_2025",{["itemid"]=111408683823094,["itemname"]="Gingercookie",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2025"}},
{"Knife","Gingerheart_K_2024",{["itemid"]=115273559455814,["itemname"]="Gingerheart",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2024"}},
{"Knife","Gingermint_K",{["itemid"]=11855306927,["itemname"]="Cookiecane",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2022"}},
{"Knife","Gingermint_KChroma",{["chroma"]=true,["itemid"]=11873640255,["itemname"]="Cookiecane",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2022"}},
{"Knife","Gingerscythe",{["itemid"]=15683138101,["itemname"]="Gingerscythe",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2023",["evoindex"]=1}},
{"Knife","Gingerscythe_Ancient",{["itemid"]=15683188776,["itemname"]="Gingerscythe",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2023",["evoindex"]=4}},
{"Knife","Gingerscythe_Blue",{["itemid"]=16964448042,["itemname"]="Blue Gingerscythe",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2023"}},
{"Knife","Gingerscythe_Bronze",{["itemid"]=16964449392,["itemname"]="Bronze Gingerscythe",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2023"}},
{"Knife","Gingerscythe_Godly",{["itemid"]=15683175970,["itemname"]="Gingerscythe",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2023",["evoindex"]=3}},
{"Knife","Gingerscythe_Gold",{["itemid"]=16964452491,["itemname"]="Gold Gingerscythe",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2023"}},
{"Knife","Gingerscythe_Legendary",{["itemid"]=15683140564,["itemname"]="Gingerscythe",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2023",["evoindex"]=2}},
{"Knife","Gingerscythe_Silver",{["itemid"]=16964450895,["itemname"]="Silver Gingerscythe",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2023"}},
{"Knife","Glowy_K_2023",{["itemid"]=15091403551,["itemname"]="Glowy",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2023"}},
{"Knife","GoldCandy",{["itemid"]=1520188792,["itemname"]="Gold Candy",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2017"}},
{"Knife","Golden_K_2026",{["itemid"]=117280525154459,["itemname"]="Golden",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","GoldHallow",{["itemid"]=2511340308,["itemname"]="Gold Hallow",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2018"}},
{"Knife","GoldIcebreaker",{["itemid"]=6404115112,["itemname"]="Gold Icebreaker",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2020"}},
{"Knife","GoldVampiresEdge",{["itemid"]=6084838617,["itemname"]="Gold Vamp's Edge",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2020"}},
{"Knife","Goo",{["itemid"]=237336076,["itemname"]="Goo",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Gothic_K_2021",{["itemid"]=7800221141,["itemname"]="Gothic",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2021"}},
{"Knife","Graffiti",{["itemid"]=4659634630,["itemname"]="Graffiti",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","GraveK",{["itemid"]=2513728474,["itemname"]="Grave",["itemtype"]="Knife",["rarity"]="Common",["year"]="2018"}},
{"Knife","GreenCamo_K_2022",{["itemid"]=11254145154,["itemname"]="Zombie Camo",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","GreenFire",{["itemid"]=1268706374,["itemname"]="Green Fire",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2017"}},
{"Knife","GreenMarble",{["itemid"]=1133366830,["itemname"]="Green Marble",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2017"}},
{"Knife","Grind",{["itemid"]=305503942,["itemname"]="Grind",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Hallow",{["itemid"]=531878205,["itemname"]="Hallow's Edge",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2016"}},
{"Knife","HallowsBlade",{["itemid"]=1132775323,["itemname"]="Hallow's Blade",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2017"}},
{"Knife","Hallowscythe",{["itemid"]=5877016863,["itemname"]="Hallowscythe",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2020"}},
{"Knife","Handsaw",{["itemid"]=473572138,["itemname"]="Handsaw",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2015"}},
{"Knife","Hardened",{["itemid"]=3183605810,["itemname"]="Hardened",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Haunted_K_2021",{["itemid"]=7800222135,["itemname"]="Haunted",["itemtype"]="Knife",["rarity"]="Common",["year"]="2021"}},
{"Knife","HauntedHouse_K_2025",{["itemid"]=90194465176219,["itemname"]="Haunted",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","HauntedHouse_K_2026",{["itemid"]=88703397021163,["itemname"]="Haunted House",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2026"}},
{"Knife","HauntedK",{["itemid"]=2513733741,["itemname"]="Haunted",["itemtype"]="Knife",["rarity"]="Common",["year"]="2018"}},
{"Knife","Hazard_K_2022",{["itemid"]=11254083234,["itemname"]="Hazard",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2022"}},
{"Knife","Hazmat",{["itemid"]=315501297,["itemname"]="Hazmat",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Heart_K_2023",{["itemid"]=12339327069,["itemname"]="Heart",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Heartblade",{["itemid"]=6413145922,["itemname"]="Heartblade",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Hearts",{["itemid"]=363352211,["itemname"]="Hearts",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Hearts_K_2026",{["itemid"]=99939659856909,["itemname"]="Hearts",["itemtype"]="Knife",["rarity"]="Common",["year"]="2026"}},
{"Knife","HeartWand",{["itemid"]=118334707962654,["itemname"]="Heart Wand",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2026"}},
{"Knife","HeartWandChroma",{["chroma"]=true,["itemid"]=78479059410850,["itemname"]="Heart Wand",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2026"}},
{"Knife","Heat",{["itemid"]=201238541,["itemname"]="Heat",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","HeatChroma",{["chroma"]=true,["itemid"]=3187395238,["itemname"]="Heat",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","HighTech",{["itemid"]=4659635055,["itemname"]="High Tech",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Hive",{["itemid"]=315501434,["itemname"]="Hive",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Holly_K_2018",{["itemid"]=2669638990,["itemname"]="Holly",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2018"}},
{"Knife","Hologram_K_2025",{["itemid"]=77773918675860,["itemname"]="Hologram",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2025"}},
{"Knife","HotChocolate_K_2024",{["itemid"]=133307062463653,["itemname"]="Hot Chocolate",["itemtype"]="Knife",["rarity"]="Common",["year"]="2024"}},
{"Knife","Hunter_K_2022",{["itemid"]=11254154978,["itemname"]="Hunter",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","Ice",{["itemid"]=196750668,["itemname"]="Ice",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Icebreaker",{["itemid"]=6125729383,["itemname"]="Icebreaker",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2020"}},
{"Knife","Icecracker_K_2020",{["itemid"]=6121848805,["itemname"]="Icecracker",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2020"}},
{"Knife","Icecream",{["itemid"]=87189663191639,["itemname"]="Icecream",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2026"}},
{"Knife","IcecreamChroma",{["chroma"]=true,["itemid"]=87189663191639,["itemname"]="Icecream",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2026"}},
{"Knife","IceDragon",{["itemid"]=585872642,["itemname"]="Ice Dragon",["itemtype"]="Knife",["offset"]={["X"]=0,["Y"]=0,["Z"]=0.55},["rarity"]="Godly",["year"]="2016"}},
{"Knife","Iceflake",{["itemid"]=8304818186,["itemname"]="Iceflake",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2021"}},
{"Knife","IceHammer",{["itemid"]=11855360152,["itemname"]="Icecrusher",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2022",["evoindex"]=1}},
{"Knife","IceHammer_Ancient",{["itemid"]=11855274019,["itemname"]="Icecrusher",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2022",["evoindex"]=4}},
{"Knife","IceHammer_Godly",{["itemid"]=11855282546,["itemname"]="Icecrusher",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2022",["evoindex"]=3}},
{"Knife","IceHammer_Legendary",{["itemid"]=11855361567,["itemname"]="Icecrusher",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2022",["evoindex"]=2}},
{"Knife","IceHammerBronze",{["itemid"]=12227148356,["itemname"]="Bronze Icecrusher",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2022"}},
{"Knife","IceHammerGold",{["itemid"]=12227137860,["itemname"]="Gold Icecrusher",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2022"}},
{"Knife","IceHammerRed",{["itemid"]=12227186408,["itemname"]="Red Icecrusher",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2022"}},
{"Knife","IceHammerSilver",{["itemid"]=12227142478,["itemname"]="Silver Icecrusher",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2022"}},
{"Knife","IceShard",{["itemid"]=1268710824,["itemname"]="Ice Shard",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2017"}},
{"Knife","Icewing",{["itemid"]=3183085102,["itemname"]="Icewing",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2018"}},
{"Knife","Icicles_K_2018",{["itemid"]=2669639638,["itemname"]="Icicles",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2018"}},
{"Knife","Igloo_K_2024",{["itemid"]=73203940450745,["itemname"]="Igloo",["itemtype"]="Knife",["rarity"]="Common",["year"]="2024"}},
{"Knife","Indy",{["itemid"]=305506951,["itemname"]="Indy",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Infected",{["itemid"]=200953094,["itemname"]="Infected",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Infected_K_2022",{["itemid"]=11254175272,["itemname"]="Infected",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","Jack",{["itemid"]=315099010,["itemname"]="Jack",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2015"}},
{"Knife","Jack_K_2022",{["itemid"]=11254093910,["itemname"]="Lantern",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2022"}},
{"Knife","JD",{["itemid"]=566867312,["itemname"]="JD",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Jellyfish_K_2024",{["itemid"]=18322181701,["itemname"]="Jellyfish",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Jigsaw",{["itemid"]=365569126,["itemname"]="Jigsaw",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Knife1",{["itemid"]=473574001,["itemname"]="Splitter",["itemtype"]="Knife",["rarity"]="Classic"}},
{"Knife","Kool",{["itemid"]=473625906,["itemname"]="Yellow",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Korblox",{["itemid"]=315501501,["itemname"]="Korblox",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Kraken_K_2024",{["itemid"]=116059045830205,["itemname"]="Kraken",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2024"}},
{"Knife","Krypto",{["itemid"]=198440414,["itemname"]="Krypto",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Laser_K_2026",{["itemid"]=76785021563290,["itemname"]="Laser",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Latte_K_2023",{["itemid"]=15413114703,["itemname"]="Latte",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Lava_K_2025",{["itemid"]=131417913843701,["itemname"]="Lava",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2025"}},
{"Knife","Leaf",{["itemid"]=4659636452,["itemname"]="Leaf",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Leaves_K_2023",{["itemid"]=15091400883,["itemname"]="Leaves",["itemtype"]="Knife",["rarity"]="Common",["year"]="2023"}},
{"Knife","Leaves_K_2025",{["itemid"]=73486056426142,["itemname"]="Leaves",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","Lights_K_2019",{["itemid"]=4534858185,["itemname"]="Lights",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2019"}},
{"Knife","Lights_K_2025",{["itemid"]=71228862432065,["itemname"]="Lights",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","Linked",{["itemid"]=198433893,["itemname"]="Linked",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","LMFAO",{["itemid"]=473626473,["itemname"]="Pink",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Log",{["itemid"]=365567962,["itemname"]="Log",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Logchopper",{["itemid"]=4535644282,["itemname"]="Logchopper",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2019"}},
{"Knife","LogchopperBlue",{["itemid"]=4753353471,["itemname"]="Blue Logchopper",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2019"}},
{"Knife","LogchopperBronze",{["itemid"]=4753354123,["itemname"]="Bronze Logchopper",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2019"}},
{"Knife","LogchopperGold",{["itemid"]=4753354638,["itemname"]="Gold Logchopper",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2019"}},
{"Knife","LogchopperSilver",{["itemid"]=4753352581,["itemname"]="Silver Logchopper",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2019"}},
{"Knife","Logcutter_K_2024",{["itemid"]=71088901904009,["itemname"]="Logcutter",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2024"}},
{"Knife","Love",{["itemid"]=196750845,["itemname"]="Love",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Love_K_2023",{["itemid"]=12339328595,["itemname"]="Love",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Lovely",{["itemid"]=4659635584,["itemname"]="Lovely",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Lucky",{["itemid"]=365569265,["itemname"]="Lucky",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Magma_K_2021",{["itemid"]=7800225996,["itemname"]="Magma",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2021"}},
{"Knife","MagmaK",{["itemid"]=1133317890,["itemname"]="Magma",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2017"}},
{"Knife","Marble_K_2023",{["itemid"]=12965302237,["itemname"]="Marble",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Marley",{["itemid"]=473625785,["itemname"]="Green",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Melon",{["itemid"]=315501369,["itemname"]="Melon",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Meltdown_K_2023",{["itemid"]=15091340751,["itemname"]="Meltdown",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2023"}},
{"Knife","Midnight",{["itemid"]=197663897,["itemname"]="Midnight",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Missing",{["itemid"]=198439692,["itemname"]="Missing",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Mistletoe_K_2022",{["itemid"]=11834394793,["itemname"]="Mistletoe",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2022"}},
{"Knife","MLG",{["itemid"]=473626979,["itemname"]="Shiny",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","molten",{["itemid"]=11254158802,["itemname"]="TestItem",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","MoltenKnife",{["itemid"]=235371809,["itemname"]="Molten",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Monster_K_2024",{["itemid"]=109292073070223,["itemname"]="Monster",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2024"}},
{"Knife","Moon_K_2021",{["itemid"]=7800224197,["itemname"]="Moon",["itemtype"]="Knife",["rarity"]="Common",["year"]="2021"}},
{"Knife","Moons",{["itemid"]=531873154,["itemname"]="Moons",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2016"}},
{"Knife","Moons_K_2024",{["itemid"]=91446990047399,["itemname"]="Moons",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2024"}},
{"Knife","Mortal",{["itemid"]=72199828838672,["itemname"]="Mortal",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2026"}},
{"Knife","MortalChroma",{["itemid"]=72199828838672,["itemname"]="Mortal",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2026",["chroma"]=true}},
{"Knife","Mummified",{["itemid"]=4210946577,["itemname"]="Mummified",["itemtype"]="Knife",["rarity"]="Common",["year"]="2019"}},
{"Knife","Mummy_K_2020",{["itemid"]=5866447521,["itemname"]="Mummy",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2020"}},
{"Knife","MummyK",{["itemid"]=1133352032,["itemname"]="Mummy",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2017"}},
{"Knife","MummyK2018",{["itemid"]=2513733542,["itemname"]="Mummy",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2018"}},
{"Knife","Musical",{["itemid"]=365569566,["itemname"]="Musical",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Nebula",{["itemid"]=6598123521,["itemname"]="Nebula",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Neon",{["itemid"]=198566885,["itemname"]="Neon",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Neopolitan_K_2026",{["itemid"]=73980008491741,["itemname"]="Neopolitan",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2026"}},
{"Knife","Nether",{["itemid"]=197656593,["itemname"]="Nether",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Nightblade",{["itemid"]=475478854,["itemname"]="Nightblade",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","NikKnife",{["itemid"]=2533351841,["itemname"]="Nik's Scythe",["itemtype"]="Knife",["rarity"]="Ancient"}},
{"Knife","Noodle_K_2023",{["itemid"]=13944132845,["itemname"]="Pool Noodle",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Nova",{["itemid"]=235371686,["itemname"]="Nova",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Oily",{["itemid"]=315501170,["itemname"]="Oily",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Ollie",{["itemid"]=305504399,["itemname"]="Ollie",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","OrangeMarble",{["itemid"]=531873011,["itemname"]="Orange Marble",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2016"}},
{"Knife","OrangeSeer",{["itemid"]=3184124504,["itemname"]="Orange Seer",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Ornament1",{["itemid"]=331745428,["itemname"]="Ornament",["itemtype"]="Knife",["rarity"]="Common",["year"]="2015"}},
{"Knife","Ornament2",{["itemid"]=331745341,["itemname"]="Ornament2",["itemtype"]="Knife",["rarity"]="Common",["year"]="2015"}},
{"Knife","Ornaments_K_2020",{["itemid"]=6121853160,["itemname"]="Ornaments",["itemtype"]="Knife",["rarity"]="Common",["year"]="2020"}},
{"Knife","Ornaments_K_2025",{["itemid"]=132504094164819,["itemname"]="Ornaments",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2025"}},
{"Knife","OverseerKnife",{["itemid"]=198441413,["itemname"]="Overseer",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Painted_K_2023",{["itemid"]=12965311567,["itemname"]="Painted",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Palms_K_2024",{["itemid"]=18322137551,["itemname"]="Palms",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Paper",{["itemid"]=235366870,["itemname"]="Paper",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Passion",{["itemid"]=363150334,["itemname"]="Passion",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Patrick",{["itemid"]=383476085,["itemname"]="Patrick",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Pearl_K",{["itemid"]=18322621319,["itemname"]="Pearl",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Penguin_K_2025",{["itemid"]=93320180084418,["itemname"]="Penguin",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","Pepper",{["itemid"]=473625645,["itemname"]="Brown",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Peppermint",{["itemid"]=6085035357,["itemname"]="Peppermint",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2020"}},
{"Knife","Peppermint_K_2025",{["itemid"]=84605926178412,["itemname"]="Peppermint",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","Phantom",{["itemid"]=1133332075,["itemname"]="Phantom",["itemtype"]="Knife",["rarity"]="Common",["year"]="2017"}},
{"Knife","Phantom2022",{["itemid"]=11229732037,["itemname"]="Phantom",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2022"}},
{"Knife","Phaser_K_2026",{["itemid"]=88433569053641,["itemname"]="Phaser",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Pier_K_2026",{["itemid"]=127570773123670,["itemname"]="Pier",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2026"}},
{"Knife","Pine_K_2019",{["itemid"]=4534855710,["itemname"]="Pine",["itemtype"]="Knife",["rarity"]="Common",["year"]="2019"}},
{"Knife","Pixel",{["itemid"]=473573054,["itemname"]="Pixel",["itemtype"]="Knife",["offset"]={["X"]=0,["Y"]=0.2,["Z"]=0.5},["rarity"]="Godly"}},
{"Knife","Plasmablade",{["itemid"]=10014680882,["itemname"]="Plasmablade",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Plasmite",{["itemid"]=196750899,["itemname"]="Plasmite",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","PolarBear_K_2025",{["itemid"]=120422092957504,["itemname"]="Polar Bear",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2025"}},
{"Knife","Pool_K_2025",{["itemid"]=112511843095202,["itemname"]="Pool",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2025"}},
{"Knife","PopArt_K_2025",{["itemid"]=123269723073737,["itemname"]="Pop Art",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2025"}},
{"Knife","Popsicle_K_2023",{["itemid"]=13944131195,["itemname"]="Popsicle",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Portal_K_2020",{["itemid"]=5866444722,["itemname"]="Portal",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2020"}},
{"Knife","Potion",{["itemid"]=1133366632,["itemname"]="Potion",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2017"}},
{"Knife","PotionK2018",{["itemid"]=2513733987,["itemname"]="Potion",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2018"}},
{"Knife","PredatorKnife",{["itemid"]=235372015,["itemname"]="Predator",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Present",{["itemid"]=1268699212,["itemname"]="Present",["itemtype"]="Knife",["rarity"]="Common",["year"]="2017"}},
{"Knife","Present_K_2023",{["itemid"]=15635553149,["itemname"]="Present",["itemtype"]="Knife",["rarity"]="Common",["year"]="2023"}},
{"Knife","Prism",{["itemid"]=306046703,["itemname"]="Prism",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Prismatic",{["itemid"]=5360359935,["itemname"]="Prismatic",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Pumpkin_K_2020",{["itemid"]=5872490600,["itemname"]="Pumpkin",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2020"}},
{"Knife","Pumpking",{["itemid"]=1138143590,["itemname"]="Pumpking",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2017"}},
{"Knife","PumpkinPatch",{["itemid"]=4210931354,["itemname"]="Pumpkin",["itemtype"]="Knife",["rarity"]="Common",["year"]="2019"}},
{"Knife","PumpkinPatch_K_2025",{["itemid"]=119626042140839,["itemname"]="Pumpkin",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2025"}},
{"Knife","PumpkinPie_K_2023",{["itemid"]=15413117611,["itemname"]="Pumpkin Pie",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","PurpleSeer",{["itemid"]=3184125244,["itemname"]="Purple Seer",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Rainbow",{["itemid"]=196750963,["itemname"]="Rainbow",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Rainbow_K",{["itemid"]=12966184630,["itemname"]="Rainbow",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","RandLuger",{["itemid"]=196751515,["itemname"]="Glitch2",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Raven_K_2026",{["itemid"]=118998301681341,["itemname"]="Raven",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2026"}},
{"Knife","RBKnife",{["itemid"]=5984754897,["itemname"]="RB Knife",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","RbxScary_K_2023",{["itemid"]=14967668214,["itemname"]="Ghoulish",["itemtype"]="Knife",["rarity"]="Common",["year"]="2023"}},
{"Knife","Reaver",{["itemid"]=7791484774,["itemname"]="Reaver",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2021",["evoindex"]=1}},
{"Knife","Reaver_Ancient",{["itemid"]=7791640819,["itemname"]="Reaver",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2021",["evoindex"]=4}},
{"Knife","Reaver_Godly",{["itemid"]=7791511648,["itemname"]="Reaver",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2021",["evoindex"]=3}},
{"Knife","Reaver_Legendary",{["itemid"]=7791485669,["itemname"]="Reaver",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2021",["evoindex"]=2}},
{"Knife","RedFire",{["itemid"]=1269256860,["itemname"]="Red Fire",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2017"}},
{"Knife","RedHallow",{["itemid"]=2511343130,["itemname"]="Red Hallow",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2018"}},
{"Knife","RedIcebreaker",{["itemid"]=6404129111,["itemname"]="Red Icebreaker",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2020"}},
{"Knife","RedSeer",{["itemid"]=3184122829,["itemname"]="Red Seer",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Reindeer_K_2024",{["itemid"]=109101361674956,["itemname"]="Reindeer",["itemtype"]="Knife",["rarity"]="Common",["year"]="2024"}},
{"Knife","Reindeer_K_2025",{["itemid"]=122078592955794,["itemname"]="Reindeer",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","Reptile",{["itemid"]=197499641,["itemname"]="Reptile",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Retro_K_2025",{["itemid"]=85299848190695,["itemname"]="Retro",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2025"}},
{"Knife","Ribbon_K_2023",{["itemid"]=15635552019,["itemname"]="Ribbon",["itemtype"]="Knife",["rarity"]="Common",["year"]="2023"}},
{"Knife","Ribbons_K_2021",{["itemid"]=8304754882,["itemname"]="Ribbons",["itemtype"]="Knife",["rarity"]="Common",["year"]="2021"}},
{"Knife","Ripper_K_2020",{["itemid"]=5866441301,["itemname"]="Ripper",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2020"}},
{"Knife","Robot_K_2024",{["itemid"]=16959778188,["itemname"]="Robot",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Rose_K_2023",{["itemid"]=12339325736,["itemname"]="Rose",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Roses",{["itemid"]=363352002,["itemname"]="Roses",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Rune",{["itemid"]=3183607894,["itemname"]="Rune",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Runic_K_2022",{["itemid"]=11254123390,["itemname"]="Curse",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2022"}},
{"Knife","Sakura_K",{["itemid"]=12339366064,["itemname"]="Sakura",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Sand_K_2026",{["itemid"]=138109619662236,["itemname"]="Sand",["itemtype"]="Knife",["rarity"]="Common",["year"]="2026"}},
{"Knife","Sandy",{["itemid"]=365568056,["itemname"]="Sandy",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Santa",{["itemid"]=331746096,["itemname"]="Santa",["itemtype"]="Knife",["rarity"]="Common",["year"]="2015"}},
{"Knife","Santa2017",{["itemid"]=1268703618,["itemname"]="Santa",["itemtype"]="Knife",["rarity"]="Common",["year"]="2017"}},
{"Knife","Santa_K_2018",{["itemid"]=2669637780,["itemname"]="Santa",["itemtype"]="Knife",["rarity"]="Common",["year"]="2018"}},
{"Knife","SantasMagic",{["itemid"]=4535483042,["itemname"]="Santa's Magic",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2019"}},
{"Knife","SantasSpirit",{["itemid"]=6123357775,["itemname"]="Santa's Spirit",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2020"}},
{"Knife","Saw",{["itemid"]=235381341,["itemname"]="Saw",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","SawChroma",{["chroma"]=true,["itemid"]=3187392992,["itemname"]="Saw",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Scarf_K_2023",{["itemid"]=15415482999,["itemname"]="Scarf",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Scarytree_K_2026",{["itemid"]=111565010485529,["itemname"]="Scarytree",["itemtype"]="Knife",["rarity"]="Common",["year"]="2026"}},
{"Knife","Scratch",{["itemid"]=531873371,["itemname"]="Scratch",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2016"}},
{"Knife","ScratchBlue",{["itemid"]=1133316381,["itemname"]="Scratch",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2017"}},
{"Knife","Scythe",{["itemid"]=2511791893,["itemname"]="Batwing",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2018"}},
{"Knife","Season1TestKnife",{["itemid"]=196751515,["itemname"]="S1 Test Knife",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","SeerChroma",{["chroma"]=true,["itemid"]=3184125538,["itemname"]="Seer",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Serpent_K_2026",{["itemid"]=134945464741168,["itemname"]="Serpent",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2026"}},
{"Knife","Shaded",{["itemid"]=4659636085,["itemname"]="Shaded",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","ShadowKnife",{["itemid"]=474030882,["itemname"]="Shadow",["itemtype"]="Knife",["rarity"]="Classic"}},
{"Knife","Sharky_K_2024",{["itemid"]=18322179563,["itemname"]="Sharky",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Sidewinder",{["itemid"]=305503783,["itemname"]="Sidewinder",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","SilentNight_K_2020",{["itemid"]=6121851313,["itemname"]="Silent Night",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2020"}},
{"Knife","SilverCandy",{["itemid"]=1520190188,["itemname"]="Silver Candy",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2017"}},
{"Knife","SilverHallow",{["itemid"]=2511341094,["itemname"]="Silver Hallow",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2018"}},
{"Knife","SilverIcebreaker",{["itemid"]=6404126280,["itemname"]="Silver Icebreaker",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2020"}},
{"Knife","SilverVampiresEdge",{["itemid"]=6084840560,["itemname"]="Silver Vamp's Edge",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2020"}},
{"Knife","Skelly_K_2026",{["itemid"]=138633100901651,["itemname"]="Skelly",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2026"}},
{"Knife","SketchYT",{["itemid"]=546161470,["itemname"]="Sketchy",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Skool",{["itemid"]=295269977,["itemname"]="Skool",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Skull_K_2023",{["itemid"]=15091321393,["itemname"]="Etched",["itemtype"]="Knife",["rarity"]="Common",["year"]="2023"}},
{"Knife","Skulls",{["itemid"]=4210915060,["itemname"]="Skulls",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2019"}},
{"Knife","Skulls_K_2021",{["itemid"]=7800220325,["itemname"]="Skulls",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2021"}},
{"Knife","Skulls_K_2026",{["itemid"]=81097195353289,["itemname"]="Skulls",["itemtype"]="Knife",["rarity"]="Common",["year"]="2026"}},
{"Knife","Skyline_K_2025",{["itemid"]=75608370390005,["itemname"]="Skyline",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","Slashed_K_2020",{["itemid"]=5929317433,["itemname"]="Slashed",["itemtype"]="Knife",["rarity"]="Common",["year"]="2020"}},
{"Knife","Slasher",{["itemid"]=315506122,["itemname"]="Slasher",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","SlasherChroma",{["chroma"]=true,["itemid"]=3187393285,["itemname"]="Slasher",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Slate",{["itemid"]=198434520,["itemname"]="Slate",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Sleigh_K_2024",{["itemid"]=74917318027165,["itemname"]="Sleigh",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2024"}},
{"Knife","SlimeK",{["itemid"]=2513734227,["itemname"]="Slime",["itemtype"]="Knife",["rarity"]="Common",["year"]="2018"}},
{"Knife","SlimyK",{["itemid"]=4210932676,["itemname"]="Slimy",["itemtype"]="Knife",["rarity"]="Common",["year"]="2019"}},
{"Knife","SlouseClown",{["itemid"]=315501118,["itemname"]="Clown",["itemtype"]="Knife",["rarity"]="Unique",["year"]=""}},
{"Knife","SnakebiteK",{["itemid"]=4210939388,["itemname"]="Snakebite",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2019"}},
{"Knife","Snoop",{["itemid"]=473626150,["itemname"]="Red",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Snowball_K_2025",{["itemid"]=119914093248842,["itemname"]="Snowball",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","SnowDagger",{["itemid"]=95328449981238,["itemname"]="Snow Dagger",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2025"}},
{"Knife","SnowDaggerBronze",{["itemid"]=134312132943601,["itemname"]="Bronze Snow Dagger",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2025"}},
{"Knife","SnowDaggerChroma",{["chroma"]=true,["itemid"]=95328449981238,["itemname"]="Snow Dagger",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2025"}},
{"Knife","SnowDaggerGold",{["itemid"]=70701057041846,["itemname"]="Gold Snow Dagger",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2025"}},
{"Knife","SnowDaggerRed",{["itemid"]=87617250559234,["itemname"]="Red Snow Dagger",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2025"}},
{"Knife","SnowDaggerSilver",{["itemid"]=128427983277729,["itemname"]="Silver Snow Dagger",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2025"}},
{"Knife","Snowfall_K_2023",{["itemid"]=15635568751,["itemname"]="Snowfall",["itemtype"]="Knife",["rarity"]="Common",["year"]="2023"}},
{"Knife","Snowflake",{["itemid"]=1268932977,["itemname"]="Snowflake",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2017"}},
{"Knife","Snowflake_K_2018",{["itemid"]=2669639913,["itemname"]="Snowflake",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2018"}},
{"Knife","Snowflake_K_2022",{["itemid"]=11834397133,["itemname"]="Snowflake",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2022"}},
{"Knife","Snowflakes_K_2019",{["itemid"]=4534855045,["itemname"]="Snowflakes",["itemtype"]="Knife",["rarity"]="Common",["year"]="2019"}},
{"Knife","Snowflakes_K_2020",{["itemid"]=6123338102,["itemname"]="Snowflakes",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2020"}},
{"Knife","Snowglobe_K_2023",{["itemid"]=15635576863,["itemname"]="Snowglobe",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2023"}},
{"Knife","Snowman",{["itemid"]=331745799,["itemname"]="Snowman",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2015"}},
{"Knife","Snowman_K_2018",{["itemid"]=2669640152,["itemname"]="Snowman",["itemtype"]="Knife",["rarity"]="Common",["year"]="2018"}},
{"Knife","Snowman_K_2021",{["itemid"]=8304753468,["itemname"]="Snowman",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2021"}},
{"Knife","Snowman_K_2022",{["itemid"]=11834391469,["itemname"]="Snowman",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","Snowman_K_2024",{["itemid"]=85751270338066,["itemname"]="Snowman",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2024"}},
{"Knife","Snowstorm",{["itemid"]=70973050894155,["itemname"]="Snowstorm",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2025"}},
{"Knife","SnowstormChroma",{["chroma"]=true,["itemid"]=70973050894155,["itemname"]="Snowstorm",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2025"}},
{"Knife","Snowy",{["itemid"]=332011125,["itemname"]="Snowy",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2015"}},
{"Knife","Snowy2017",{["itemid"]=1268705947,["itemname"]="Snowy",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2017"}},
{"Knife","Soda_K_2025",{["itemid"]=89899263078420,["itemname"]="Soda",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2025"}},
{"Knife","Sorry",{["itemid"]=197879343,["itemname"]="Corrupt",["itemtype"]="Knife",["rarity"]="Unique"}},
{"Knife","Space",{["itemid"]=3183607442,["itemname"]="Space",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Sparkle1",{["itemid"]=310709709,["itemname"]="Sparkle1",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Sparkle10",{["itemid"]=310715768,["itemname"]="Sparkle10",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Sparkle2",{["itemid"]=310710191,["itemname"]="Sparkle2",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Sparkle3",{["itemid"]=310710694,["itemname"]="Sparkle3",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Sparkle4",{["itemid"]=310712788,["itemname"]="Sparkle4",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Sparkle5",{["itemid"]=310713235,["itemname"]="Sparkle5",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Sparkle6",{["itemid"]=310713648,["itemname"]="Sparkle6",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Sparkle7",{["itemid"]=310714089,["itemname"]="Sparkle7",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Sparkle8",{["itemid"]=310714407,["itemname"]="Sparkle8",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Sparkle9",{["itemid"]=310715104,["itemname"]="Sparkle9",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Spearmint_K_2025",{["itemid"]=98506456649552,["itemname"]="Spearmint",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2025"}},
{"Knife","Spectral_K_2021",{["itemid"]=7800226793,["itemname"]="Spectral",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2021"}},
{"Knife","Spectrum",{["itemid"]=198441038,["itemname"]="Spectrum",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Spider",{["itemid"]=473571549,["itemname"]="Spider",["itemtype"]="Knife",["offset"]={["X"]=0,["Y"]=0,["Z"]=0.55},["rarity"]="Godly",["year"]="2015"}},
{"Knife","Spider_K_2023",{["itemid"]=15091399982,["itemname"]="Spider",["itemtype"]="Knife",["rarity"]="Common",["year"]="2023"}},
{"Knife","Splash",{["itemid"]=235371439,["itemname"]="Splash",["itemtype"]="Knife",["rarity"]="Legendary"}},
{"Knife","Splatter",{["itemid"]=16964346058,["itemname"]="Splatter",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Spring_K_2024",{["itemid"]=16959775902,["itemname"]="Spring",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Squire",{["itemid"]=315501560,["itemname"]="Squire",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Stainless",{["itemid"]=235366771,["itemname"]="Stainless",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Stalker",{["itemid"]=198439107,["itemname"]="Stalker",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Starfish_K_2024",{["itemid"]=18322176343,["itemname"]="Starfish",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Starry_K_2021",{["itemid"]=8304757707,["itemname"]="Starry",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2021"}},
{"Knife","Starry_K_2026",{["itemid"]=130537925107449,["itemname"]="Starry",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2026"}},
{"Knife","Stars_K_2023",{["itemid"]=15635559978,["itemname"]="Stars",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2023"}},
{"Knife","Static",{["itemid"]=365568163,["itemname"]="Static",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Steel_K_2023",{["itemid"]=15091405483,["itemname"]="Steel",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2023"}},
{"Knife","Stickers_K_2021",{["itemid"]=7800229084,["itemname"]="Stickers",["itemtype"]="Knife",["rarity"]="Common",["year"]="2021"}},
{"Knife","Stickers_K_2022",{["itemid"]=11254067158,["itemname"]="Stickers",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","Stickers_K_2024",{["itemid"]=120248733900674,["itemname"]="Stickers",["itemtype"]="Knife",["rarity"]="Common",["year"]="2024"}},
{"Knife","Stickers_K_2025",{["itemid"]=98868784444742,["itemname"]="Stickers",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","Stickers_X_K_2024",{["itemid"]=83843575465564,["itemname"]="Stickers",["itemtype"]="Knife",["rarity"]="Common",["year"]="2024"}},
{"Knife","StickersH_K_2025",{["itemid"]=100461386281007,["itemname"]="Stickers",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","StickersT2025",{["itemid"]=115280072896190,["itemname"]="Stickers",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","StickersX25",{["itemid"]=115280072896190,["itemname"]="Stickers",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","StickersX_K_2022",{["itemid"]=11834387858,["itemname"]="Stickers",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","StickersX_K_2025",{["itemid"]=102283625659356,["itemname"]="Stickers",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","Stockings_K_2020",{["itemid"]=6123335682,["itemname"]="Stockings",["itemtype"]="Knife",["rarity"]="Common",["year"]="2020"}},
{"Knife","Stockings_K_2022",{["itemid"]=11834392930,["itemname"]="Stockings",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2022"}},
{"Knife","Storm_K_2024",{["itemid"]=97369825731567,["itemname"]="Storm",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2024"}},
{"Knife","Strawberries_K_2026",{["itemid"]=73897192147749,["itemname"]="Strawberries",["itemtype"]="Knife",["rarity"]="Common",["year"]="2026"}},
{"Knife","Striped_K_2025",{["itemid"]=136747578920542,["itemname"]="Striped",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","Sub",{["itemid"]=546159250,["itemname"]="Sub",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Summer_Stickers_K_2023",{["itemid"]=13944129596,["itemname"]="Stickers",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","SunsetKnife",{["itemid"]=103526268515240,["itemname"]="Sunset",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2025"}},
{"Knife","SunsetKnifeChroma",{["chroma"]=true,["itemid"]=103526268515240,["itemname"]="Sunset",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2025"}},
{"Knife","Survivors_K_2022",{["itemid"]=11254180750,["itemname"]="Makeshift",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2022"}},
{"Knife","Sweater",{["itemid"]=1268704902,["itemname"]="Sweater",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2017"}},
{"Knife","Sweater_K_2018",{["itemid"]=2669640567,["itemname"]="Sweater",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2018"}},
{"Knife","Sweater_K_2025",{["itemid"]=102130993592804,["itemname"]="Sweater",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2025"}},
{"Knife","Sweet",{["itemid"]=126937716954396,["itemname"]="Sweet",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2026"}},
{"Knife","Sweet_K_2026",{["itemid"]=113677688954146,["itemname"]="Yummy",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2026"}},
{"Knife","SweetChroma",{["chroma"]=true,["itemid"]=126937716954396,["itemname"]="Sweet",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2026"}},
{"Knife","Sweetheart",{["itemid"]=363150761,["itemname"]="Sweetheart",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Swirl_K_2021",{["itemid"]=8304757110,["itemname"]="Swirl",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2021"}},
{"Knife","SwirlyAxe",{["itemid"]=8304801000,["itemname"]="Swirly Axe",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2021"}},
{"Knife","SwirlyAxeBlue",{["itemid"]=9552048857,["itemname"]="Blue Swirly",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2021"}},
{"Knife","SwirlyAxeBronze",{["itemid"]=9552050165,["itemname"]="Bronze Swirly",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2021"}},
{"Knife","SwirlyAxeGold",{["itemid"]=9552054920,["itemname"]="Gold Swirly",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2021"}},
{"Knife","SwirlyAxeSilver",{["itemid"]=9552051805,["itemname"]="Silver Swirly",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2021"}},
{"Knife","SwirlyBlade",{["itemid"]=8304805693,["itemname"]="Swirly Blade",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2021"}},
{"Knife","Synthwave",{["itemid"]=84935740002917,["itemname"]="Synthwave",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2025",["evoindex"]=1}},
{"Knife","Synthwave_Ancient",{["itemid"]=133828016595037,["itemname"]="Synthwave",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2025",["evoindex"]=4}},
{"Knife","Synthwave_Blue",{["itemid"]=122762984016505,["itemname"]="Blue Synthwave",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2025"}},
{"Knife","Synthwave_Bronze",{["itemid"]=72230744607038,["itemname"]="Bronze Synthwave",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2025"}},
{"Knife","Synthwave_Godly",{["itemid"]=15683175970,["itemname"]="Synthwave",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2025",["evoindex"]=3}},
{"Knife","Synthwave_Gold",{["itemid"]=138834911796124,["itemname"]="Gold Synthwave",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2025"}},
{"Knife","Synthwave_Legendary",{["itemid"]=132040985617451,["itemname"]="Synthwave",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2025",["evoindex"]=2}},
{"Knife","Synthwave_Silver",{["itemid"]=103455022994358,["itemname"]="Silver Synthwave",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2025"}},
{"Knife","Tailslide",{["itemid"]=305506822,["itemname"]="Tailslide",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","TheSeer",{["itemid"]=198441783,["itemname"]="Seer",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Tides",{["itemid"]=473569625,["itemname"]="Tides",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","TidesChroma",{["chroma"]=true,["itemid"]=3187394934,["itemname"]="Tides",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Tiger",{["itemid"]=3183606579,["itemname"]="Tiger",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","TimeKnife",{["itemid"]=473575049,["itemname"]="Prince",["itemtype"]="Knife",["rarity"]="Classic"}},
{"Knife","TNL",{["itemid"]=201542790,["itemname"]="TNL",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Tourist_K_2026",{["itemid"]=135606903872678,["itemname"]="Tourist",["itemtype"]="Knife",["rarity"]="Common",["year"]="2026"}},
{"Knife","ToxicK",{["itemid"]=2513734535,["itemname"]="Toxic",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2018"}},
{"Knife","Toy_K_2023",{["itemid"]=13944127959,["itemname"]="Toy",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Traveler_K_2023",{["itemid"]=15091407901,["itemname"]="Traveler",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2023"}},
{"Knife","TravelerAxe",{["itemid"]=15070870271,["itemname"]="Traveler's Axe",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2023"}},
{"Knife","TravelerAxeBronze",{["itemid"]=15695407020,["itemname"]="Bronze Traveler's",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2023"}},
{"Knife","TravelerAxeGold",{["itemid"]=15695408631,["itemname"]="Gold Traveler's",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2023"}},
{"Knife","TravelerAxeRed",{["itemid"]=15695405379,["itemname"]="Red Traveler's",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2023"}},
{"Knife","TravelerAxeSilver",{["itemid"]=15695407742,["itemname"]="Silver Traveler's",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2023"}},
{"Knife","Treats_K_2025",{["itemid"]=115298865715727,["itemname"]="Treats",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2025"}},
{"Knife","Tree",{["itemid"]=331745577,["itemname"]="Tree",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2015"}},
{"Knife","Tree2017",{["itemid"]=1268704124,["itemname"]="Tree",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2017"}},
{"Knife","Tree_K_2021",{["itemid"]=8304756423,["itemname"]="Tree",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2021"}},
{"Knife","Tree_K_2022",{["itemid"]=11834400185,["itemname"]="Tree",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2022"}},
{"Knife","Tree_K_2023",{["itemid"]=15635563249,["itemname"]="Tree",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2023"}},
{"Knife","TreeKnife2023",{["itemid"]=15667157715,["itemname"]="Evergreen",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2023"}},
{"Knife","TreeKnife2023Chroma",{["chroma"]=true,["itemid"]=15694110573,["itemname"]="Evergreen",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2023"}},
{"Knife","Trees_K_2020",{["itemid"]=6123336879,["itemname"]="Trees",["itemtype"]="Knife",["rarity"]="Common",["year"]="2020"}},
{"Knife","Tropical_K_2025",{["itemid"]=111291962899457,["itemname"]="Tropical",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2025"}},
{"Knife","Tulip",{["itemid"]=387874661,["itemname"]="Tulip",["itemtype"]="Knife",["rarity"]="Common",["year"]="2016"}},
{"Knife","Turkey2023",{["itemid"]=15413149176,["itemname"]="Turkey",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Turtle_K_2024",{["itemid"]=18322166908,["itemname"]="Turtle",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Turtles_K_2026",{["itemid"]=77271917200992,["itemname"]="Turtles",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2026"}},
{"Knife","UFOKnife",{["itemid"]=77607127867154,["itemname"]="Alienbeam",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2025"}},
{"Knife","UFOKnifeChroma",{["chroma"]=true,["itemid"]=77607127867154,["itemname"]="Alienbeam",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2025"}},
{"Knife","UFOs_K_2025",{["itemid"]=97641024072972,["itemname"]="UFOs",["itemtype"]="Knife",["rarity"]="Common",["year"]="2025"}},
{"Knife","Valentine",{["itemid"]=363150149,["itemname"]="Valentine",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Vampire",{["itemid"]=531873248,["itemname"]="Vampire",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2016"}},
{"Knife","Vampire_K_2022",{["itemid"]=11254125546,["itemname"]="Vampire",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2022"}},
{"Knife","VampireAxe",{["itemid"]=130837676383567,["itemname"]="Vampire's Axe",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2024"}},
{"Knife","VampireAxe_Bronze",{["itemid"]=130837676383567,["itemname"]="Vampire's Axe",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2024"}},
{"Knife","VampireAxe_Gold",{["itemid"]=130837676383567,["itemname"]="Vampire's Axe",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2024"}},
{"Knife","VampireAxe_Purple",{["itemid"]=130837676383567,["itemname"]="Vampire's Axe",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2024"}},
{"Knife","VampireAxe_Silver",{["itemid"]=130837676383567,["itemname"]="Vampire's Axe",["itemtype"]="Knife",["rarity"]="Unique",["year"]="2024"}},
{"Knife","VampireK2018",{["itemid"]=2513734708,["itemname"]="Vampire",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2018"}},
{"Knife","VampiresEdge",{["itemid"]=5873256998,["itemname"]="Vampire's Edge",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2020"}},
{"Knife","Vines_K_2023",{["itemid"]=15091325210,["itemname"]="Vines",["itemtype"]="Knife",["rarity"]="Common",["year"]="2023"}},
{"Knife","Virtual",{["itemid"]=386276987,["itemname"]="Virtual",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","VoidRbx",{["itemid"]=11548082732,["itemname"]="Void",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Vortex",{["itemid"]=235371508,["itemname"]="Vortex",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Wanwood",{["itemid"]=196751441,["itemname"]="Wanwood",["itemtype"]="Knife",["rarity"]="Uncommon"}},
{"Knife","Watcher_K_2021",{["itemid"]=7800227475,["itemname"]="Watcher",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2021"}},
{"Knife","Waves_K",{["itemid"]=13945892398,["itemname"]="Waves",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Waves_K_2024",{["itemid"]=18322178053,["itemname"]="Waves",["itemtype"]="Knife",["rarity"]="Rare"}},
{"Knife","Wavy_K_2024",{["itemid"]=16959755393,["itemname"]="Wavy",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Web",{["itemid"]=315104004,["itemname"]="Web",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2015"}},
{"Knife","WebbedK",{["itemid"]=4210949599,["itemname"]="Webbed",["itemtype"]="Knife",["rarity"]="Common",["year"]="2019"}},
{"Knife","Webs",{["itemid"]=1133325465,["itemname"]="Webs",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2017"}},
{"Knife","Whiteout",{["itemid"]=196751515,["itemname"]="Whiteout",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","WintersEdge",{["itemid"]=1268708987,["itemname"]="Winter's Edge",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2017"}},
{"Knife","Witch",{["itemid"]=531873553,["itemname"]="Witch",["itemtype"]="Knife",["rarity"]="Common",["year"]="2016"}},
{"Knife","Witch_K_2022",{["itemid"]=11254115609,["itemname"]="Witchbrew",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2022"}},
{"Knife","WitchBrew_K_2024",{["itemid"]=108331177567412,["itemname"]="Witch's Brew",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2024"}},
{"Knife","Witched",{["itemid"]=4210938270,["itemname"]="Witched",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2019"}},
{"Knife","Wolf",{["itemid"]=531873487,["itemname"]="Wolf",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2016"}},
{"Knife","Wood_K_2023",{["itemid"]=15091401811,["itemname"]="Wood",["itemtype"]="Knife",["rarity"]="Common",["year"]="2023"}},
{"Knife","Wraith_K_2022",{["itemid"]=11254118399,["itemname"]="Wraith",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2022"}},
{"Knife","WraithKnife",{["itemid"]=107190526940939,["itemname"]="Spirit",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2024"}},
{"Knife","Wrapped",{["itemid"]=331745500,["itemname"]="Wrapped",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2015"}},
{"Knife","Wrapped_K_2018",{["itemid"]=2669640357,["itemname"]="Wrapped",["itemtype"]="Knife",["rarity"]="Common",["year"]="2018"}},
{"Knife","Wrapped_K_2022",{["itemid"]=11834403282,["itemname"]="Wrapped",["itemtype"]="Knife",["rarity"]="Common",["year"]="2022"}},
{"Knife","Wrapped_K_2024",{["itemid"]=72638846676083,["itemname"]="Wrapped",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2024"}},
{"Knife","Wreaths_K_2024",{["itemid"]=78432760615312,["itemname"]="Wreaths",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2024"}},
{"Knife","Xbox",{["itemid"]=439325100,["itemname"]="Xbox",["itemtype"]="Knife",["rarity"]="Common"}},
{"Knife","Xeno_K_2025",{["itemid"]=80492487454400,["itemname"]="Xeno",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2025"}},
{"Knife","XenoKnife",{["itemid"]=100576599313371,["itemname"]="Xenoknife",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2025"}},
{"Knife","Xmas",{["itemid"]=473572568,["itemname"]="Xmas",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2015"}},
{"Knife","XmasStickers_K_2021",{["itemid"]=8304755417,["itemname"]="Stickers",["itemtype"]="Knife",["rarity"]="Common",["year"]="2021"}},
{"Knife","YellowSeer",{["itemid"]=3184124768,["itemname"]="Yellow Seer",["itemtype"]="Knife",["rarity"]="Godly"}},
{"Knife","Zombie",{["itemid"]=1133331885,["itemname"]="Zombie",["itemtype"]="Knife",["rarity"]="Common",["year"]="2017"}},
{"Knife","Zombie_K_2021",{["itemid"]=7800222975,["itemname"]="Zombie",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2021"}},
{"Knife","Zombie_K_2023",{["itemid"]=15091339932,["itemname"]="Zombie",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2023"}},
{"Knife","ZombieBat",{["itemid"]=11229814357,["itemname"]="Bat",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2022"}},
{"Knife","ZombieK2018",{["itemid"]=2513734908,["itemname"]="Zombie",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2018"}},
{"Knife","Zombified_K_2022",{["itemid"]=11254182560,["itemname"]="Zombified",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2022"}},
{"Knife","ZombifiedK",{["itemid"]=4210928053,["itemname"]="Zombified",["itemtype"]="Knife",["rarity"]="Uncommon",["year"]="2019"}},
-- (added from the MMV captures)
{"Knife","EmbersickleChroma",{["itemid"]=113946366917108,["itemname"]="Embersickle",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2026",["chroma"]=true}},
{"Knife","Hexed_K_2026",{["itemid"]=131817568341292,["itemname"]="Hexed",["itemtype"]="Knife",["rarity"]="Common",["year"]="2026"}},
{"Knife","SorryChroma",{["itemid"]=117030448148725,["itemname"]="Corrupt",["itemtype"]="Knife",["rarity"]="Secret",["chroma"]=true}},
{"Knife","SynthwaveChroma",{["itemid"]=118450052060226,["itemname"]="Synthwave",["itemtype"]="Knife",["rarity"]="Rare",["year"]="2025",["chroma"]=true}},
{"Knife","Synthwave_AncientChroma",{["itemid"]=89788665167182,["itemname"]="Synthwave",["itemtype"]="Knife",["rarity"]="Ancient",["year"]="2025",["chroma"]=true}},
{"Knife","Synthwave_GodlyChroma",{["itemid"]=128721134858931,["itemname"]="Synthwave",["itemtype"]="Knife",["rarity"]="Godly",["year"]="2025",["chroma"]=true}},
{"Knife","Synthwave_LegendaryChroma",{["itemid"]=72251222696100,["itemname"]="Synthwave",["itemtype"]="Knife",["rarity"]="Legendary",["year"]="2025",["chroma"]=true}},
}
local sharedScopes={
{"Gun","Matrixscope",{["itemid"]=117266088063706,["itemname"]="Matrixscope",["itemtype"]="Gun",["rarity"]="Secret",["year"]="2025"}},
{"Gun","Voidscope",{["itemid"]=84264267520629,["itemname"]="Voidscope",["itemtype"]="Gun",["rarity"]="Secret"}},
}
if not mmv then
for _,row in ipairs(staticMM2) do register(row[1],row[2],row[3]) end
end
for _,row in ipairs(sharedScopes) do
local entry=register(row[1],row[2],row[3])
if entry then
entry.originalModelId=string.format("%.0f",row[3].itemid)
entry.games={"MM2","MMV"}
end
end
local MMV_SCOPE_HOLD="134818020160275"
local recordedScopeHolds=env.VisualsV2Runtime.OriginalVisuals.ScopeHoldAnimations or {}
local ORIGINAL_SCOPE_HOLD=tostring(recordedScopeHolds[mmv and "MMV" or "MM2"] or ""):match("(%d+)") or MMV_SCOPE_HOLD
local scopeHoldWarnings={}
local nativeScopeHolds={}
local function isScope(entry)
if not entry or entry.kind~="Gun" then return false end
-- (every scope gets the scope hold: in MM2 all of them (Gingerscopes, Bunnyscope, Gemscope, Matrixscope,
-- Voidscope); in MMV only Matrixscope and Voidscope can be picked)
local name=compact(entry.id)..compact(entry.name)
return name:find("scope",1,true)~=nil
end
local function visualRoot(object)
if object:IsA("BasePart") then return object end
local function eligible(part)
local current=part
while current and current~=object do
if current:GetAttribute(MARKER) then return false end
current=current.Parent
end
return current==object
end
local handle=object:FindFirstChild("Handle")
if handle and handle:IsA("BasePart") and eligible(handle) then return handle end
if handle and handle:IsA("Model") and handle.PrimaryPart and eligible(handle.PrimaryPart) then return handle.PrimaryPart end
if object:IsA("Model") and object.PrimaryPart and eligible(object.PrimaryPart) then return object.PrimaryPart end
local queue={object}
local index=1
while queue[index] do
local current=queue[index];index=index+1
for _,child in ipairs(current:GetChildren()) do
if not child:GetAttribute(MARKER) then
if child:IsA("BasePart") then return child end
if child:IsA("Model") or child:IsA("Folder") or child:IsA("Tool") then queue[#queue+1]=child end
end
end
end
end
local function gripAttachment(handle)
local attachment=handle:FindFirstChild("CustomAttachment") or handle:FindFirstChild("RightGripAttachment")
return attachment and attachment:IsA("Attachment") and attachment or nil
end
local GRIP_GROUPS={
{rel=CFrame.new(0,0,0,1,0,0,0,0.642767,-0.766069,0,0.766069,0.642767),offset=Vector3.new(0.0000,0.0317,0.4175)},
{rel=CFrame.new(0,0,0,1,0,0,0,0.207891,-0.978154,0,0.978154,0.207891),offset=Vector3.new(-0.0476,-0.1683,0.4494)},
{rel=CFrame.new(0,0,0,1,0,0,0,0.707134,-0.707084,0,0.707084,0.707134),offset=Vector3.new(-0.1299,-0.4000,0.8250)},
{rel=CFrame.new(0,0,0,2.33013e-05,1,-5.96407e-05,-0.499996,-4.19615e-05,-0.866023,-0.866023,4.73202e-05,0.499996),offset=Vector3.new(-0.1299,-0.5109,0.2655)},
{rel=CFrame.new(0,0,0,1,0,0,0,0,-1,0,1,0),offset=Vector3.new(-0.1500,-0.2443,0.1668)},
{rel=CFrame.new(0,0,0,1,-8.11207e-06,-1.15843e-05,-8.11207e-06,0.173612,-0.984819,1.15843e-05,0.984819,0.173612),offset=Vector3.new(-0.1000,-0.3337,0.4030)},
}
-- (grips recorded from the weapon in hand in MMV rounds: by mesh, then by the part's size (and the mesh's
-- scale); a weapon whose mesh and size match one of these is held exactly like the original)
local RECORDED_GRIPS={
["Gun:101086719"]={{size=Vector3.new(0.2,1,1.9),scale=Vector3.new(0.5,0.5,0.5),grip=CFrame.new(-0.09999996,0.5370181,0.8515217,-1,0,0,0,-1,0,0,0,1)}},
["Gun:104658283027428"]={{size=Vector3.new(0.4099,1.3663,1.9086),grip=CFrame.new(0,-0.2098507,0.4692078,1,0,0,0,1,0,0,0,1)}},
["Gun:107813118898769"]={{size=Vector3.new(0.5488,1.5589,2.3643),grip=CFrame.new(0,-0.3551227,0.7032528,1,0,0,0,1,0,0,0,1)}},
["Gun:108253816085047"]={{size=Vector3.new(0.5891,1.5671,2.2852),grip=CFrame.new(0,-0.217888,0.6603775,1,0,0,0,1,0,0,0,1)}},
["Gun:109742397574153"]={{size=Vector3.new(0.459,1.355,2.346),scale=Vector3.new(0.0458,0.0458,0.0458),grip=CFrame.new(0,-0.3123981,0.5989532,1,0,0,0,1,0,0,0,1)}},
["Gun:11158364935"]={{size=Vector3.new(0.5883,1.25,2.7314),grip=CFrame.new(7.629395e-06,-0.1279793,0.994688,1,0,0,0,1,0,0,0,1)}},
["Gun:11165536294"]={{size=Vector3.new(0.3326,0.9761,2.5981),grip=CFrame.new(-9.536743e-07,-0.4000015,0.8500099,1,0,0,0,1,0,0,0,1)}},
["Gun:115447220952926"]={{size=Vector3.new(0.6902,1.643,2.3554),grip=CFrame.new(2.861023e-06,-0.3249056,0.5049858,1,0,0,0,1,0,0,0,1)}},
["Gun:116657254"]={{size=Vector3.new(0.6,1,1.8),scale=Vector3.new(0.7,0.7,0.7),grip=CFrame.new(0.05482196,-0.3662616,0.8150629,1,0,0,0,1,0,0,0,1)}},
["Gun:118269783"]={{size=Vector3.new(0.2,1.03,1.83),scale=Vector3.new(0.3,0.43,0.4),grip=CFrame.new(0,-0.5,0.33,1,0,0,0,1,0,0,0,1)}},
["Gun:11866444071"]={{size=Vector3.new(0.3979,1.028,2.3776),grip=CFrame.new(5.193288e-07,-0.2500006,0.7000084,1,0,0,0,1,0,0,0,1)}},
["Gun:11868991644"]={{size=Vector3.new(2.4694,0.7526,2.7384),grip=CFrame.new(0,-0.5335871,0.3055697,1,0,0,0,1,0,0,0,1)}},
["Gun:12322809632"]={{size=Vector3.new(0.4442,0.9976,2.1883),grip=CFrame.new(4.768372e-07,-0.3130239,0.6312084,1,0,0,0,1,0,0,0,1)}},
["Gun:124598402927958"]={{size=Vector3.new(0.5372,1.583,2.3671),grip=CFrame.new(0,-0.3551227,0.7032528,1,0,0,0,1,0,0,0,1)}},
["Gun:126591885289479"]={{size=Vector3.new(0.4225,1.2927,2.4127),grip=CFrame.new(0,-0.3551227,0.7032528,1,0,0,0,1,0,0,0,1)}},
["Gun:12921221200"]={{size=Vector3.new(0.4284,1.2199,2.5946),grip=CFrame.new(4.768372e-07,-0.3130249,0.7242851,1,0,0,0,1,0,0,0,1)}},
["Gun:130099641"]={{size=Vector3.new(0.38,1.34,1.88),scale=Vector3.new(0.5,0.5,0.5),grip=CFrame.new(0,-0.1,0.75,1,0,0,0,1,0,0,0,1)}},
["Gun:135790480817772"]={{size=Vector3.new(0.4485,1.3444,1.8995),grip=CFrame.new(0,-0.217681,0.5108109,1,0,0,0,1,0,0,0,1)}},
["Gun:13928587755"]={{size=Vector3.new(0.3978,1.6715,2.4457),grip=CFrame.new(4.768372e-07,-0.3130249,0.7242851,1,0,0,0,1,0,0,0,1)}},
["Gun:15027451531"]={{size=Vector3.new(0.4554,1.23,2.3694),grip=CFrame.new(0,-0.2892561,0.4918117,1,0,0,0,1,0,0,0,1)}},
["Gun:15090814396"]={{size=Vector3.new(0.4816,1.2632,2.4551),grip=CFrame.new(0,-0.3274078,0.6617203,1,0,0,0,1,0,0,0,1)}},
["Gun:15374602183"]={{size=Vector3.new(0.2697,1.2582,4.2087),grip=CFrame.new(0,-0.3999987,0.8999996,1,0,0,0,1,0,0,0,1)}},
["Gun:15408863676"]={{size=Vector3.new(0.8334,1.3837,2.5195),grip=CFrame.new(0,-0.3999987,0.7000008,1,0,0,0,1,0,0,0,1)}},
["Gun:16070198638"]={{size=Vector3.new(0.4591,1.3549,2.3463),grip=CFrame.new(0,-0.217888,0.6603775,1,0,0,0,1,0,0,0,1)}},
["Gun:16895099893"]={{size=Vector3.new(0.6652,1.54,2.5945),grip=CFrame.new(0,-0.2999983,0.7000008,1,0,0,0,1,0,0,0,1)}},
["Gun:18265627"]={{size=Vector3.new(0.4,1.4,0.8),scale=Vector3.new(1,1,1),grip=CFrame.new(0,-0.65,-0.3,1,0,0,0,0,-1,0,1,0)}},
["Gun:18280804203"]={{size=Vector3.new(0.5685,1.3816,2.1548),grip=CFrame.new(0,-0.2454224,0.6221809,1,0,0,0,1,0,0,0,1)}},
["Gun:18280999342"]={{size=Vector3.new(0.4478,1.3652,2),grip=CFrame.new(0,-0.1448564,0.6609917,1,0,0,0,1,0,0,0,1)}},
["Gun:2514719081"]={{size=Vector3.new(0.3654,1.9756,1.0149),grip=CFrame.new(0,-0.7,-0.3,1,0,0,0,0,-1,0,1,0)}},
["Gun:25298496"]={{size=Vector3.new(0.4,1.4,0.8),scale=Vector3.new(1.5,1.5,1.5),grip=CFrame.new(0,-0.65,-0.3,1,0,0,0,0,-1,0,1,0)}},
["Gun:4210029922"]={{size=Vector3.new(1.49,1.132,0.3587),grip=CFrame.new(-0.6329081,-0.2355192,-1.748457e-08,0,0,-1,0,1,0,1,0,0)}},
["Gun:4528424409"]={{size=Vector3.new(0.3335,1.3504,1.88),grip=CFrame.new(0.01774173,0.2826146,0.7700032,-1,0,0,0,-1,0,0,0,1)}},
["Gun:4730813852"]={{size=Vector3.new(0.398,1.62,1.964),scale=Vector3.new(0.039,0.039,0.039),grip=CFrame.new(-3.586151e-06,-0.606,0.7,1,0,0,0,1,0,0,0,1)}},
["Gun:5841866437"]={{size=Vector3.new(2.04,1.0799,0.3719),grip=CFrame.new(-0.75,-0.4500005,-0.04999733,0,0,-1,0,1,0,1,0,0)}},
["Gun:6125843704"]={{size=Vector3.new(0.7515,1.799,1.1753),grip=CFrame.new(1.907349e-06,-0.5499997,-0.6000012,1,0,0,0,0,-1,0,1,0)}},
["Gun:69486593"]={{size=Vector3.new(0.4,1.4,0.8),scale=Vector3.new(0.8,0.8,0.8),grip=CFrame.new(0,-0.65,-0.3,1,0,0,0,0,-1,0,1,0)}},
["Gun:77235373292363"]={{size=Vector3.new(0.4367,1.4888,2.1494),grip=CFrame.new(0,-0.180945,0.4893417,1,0,0,0,1,0,0,0,1)}},
["Gun:7775027413"]={{size=Vector3.new(2.2448,0.6549,2.88),grip=CFrame.new(0,-0.5109372,0.3405404,1,0,0,0,1,0,0,0,1)}},
["Gun:78349467382122"]={{size=Vector3.new(2.0511,1.2179,2.9059),grip=CFrame.new(0.02289391,-0.5151997,0.3696651,1,0,0,0,1,0,0,0,1)}},
["Gun:79401392"]={{size=Vector3.new(0.2,1.83,1.03),scale=Vector3.new(1.6,1.6,1.6),grip=CFrame.new(0,-0.7,-0.3,1,0,0,0,0,-1,0,1,0)}},
["Gun:79527507796407"]={{size=Vector3.new(0.4552,1.3727,2.2193),grip=CFrame.new(0,-0.2551221,0.6032524,1,0,0,0,1,0,0,0,1)}},
["Gun:8310908064"]={{size=Vector3.new(0.328,2.199,1.0898),grip=CFrame.new(0.02974701,-0.5999785,-0.3426466,1,0,0,0,0,-1,0,1,0)}},
["Gun:8310911339"]={{size=Vector3.new(0.469,2.539,1.1515),grip=CFrame.new(0,-0.7,-0.3,1,0,0,0,0,-1,0,1,0)}},
["Gun:92656610"]={{size=Vector3.new(0.2,1,1.9),scale=Vector3.new(0.4,0.45,0.5),grip=CFrame.new(0,-0.4184679,0.6580073,1,0,0,0,1,0,0,0,1)}},
["Gun:95356090"]={{size=Vector3.new(0.51,1.18,1.35),scale=Vector3.new(1.8,1.8,1.8),grip=CFrame.new(0,-0.206,0.5,1,0,0,0,1,0,0,0,1)}},
["Gun:96613044791092"]={{size=Vector3.new(0.8811,1.5086,2.2671),grip=CFrame.new(9.536743e-06,-0.2696847,0.4133134,1,0,0,0,1,0,0,0,1)}},
["Gun:96867436912658"]={{size=Vector3.new(0.2816,1.3183,2.6675),grip=CFrame.new(2.384186e-06,-0.01239812,0.76688,1,0,0,0,1,0,0,0,1)}},
["Gun:9702755186"]={{size=Vector3.new(0.3648,1.0832,2.1769),grip=CFrame.new(4.768372e-07,-0.3666368,0.6886454,1,0,0,0,0.9993919,0.0348688,0,-0.0348688,0.9993919)}},
["Gun:99836890880541"]={{size=Vector3.new(0.5586,1.3549,2.4996),grip=CFrame.new(0,-0.06318772,0.533081,1,0,0,0,1,0,0,0,1)}},
["Knife:"]={{size=Vector3.new(0.4572,3.2,0.6571),grip=CFrame.new(0,-1,0.0695633,1,0,0,0,1,0,0,0,1)}},
["Knife:103838505"]={{size=Vector3.new(0.2,3.1,0.6),scale=Vector3.new(0.7,0.45,0.5),grip=CFrame.new(0.02343607,-1.248868,0.06000001,1,0,0,0,1,0,0,0,1)}},
["Knife:104705566620551"]={{size=Vector3.new(0.8048,3.7577,3.5897),grip=CFrame.new(0,-0.4274286,0.4374054,1,0,0,0,1,0,0,0,1)}},
["Knife:105329941"]={{size=Vector3.new(0.4,2.9,0.7),scale=Vector3.new(0.5,0.5,0.5),grip=CFrame.new(0,-0.9,0,1,0,0,0,1,0,0,0,1)}},
["Knife:105333894"]={{size=Vector3.new(0.4,2.9,0.8),scale=Vector3.new(0.3,0.3,0.3),grip=CFrame.new(0,-1.2,0.1,1,0,0,0,1,0,0,0,1)}},
["Knife:1084767698"]={{size=Vector3.new(0.4,3,0.8),scale=Vector3.new(0.55,0.55,0.555),grip=CFrame.new(0.01774025,-0.7136774,0.07000351,1,0,0,0,1,0,0,0,1)}},
["Knife:11158775938"]={{size=Vector3.new(0.2571,3.4485,1.2326),grip=CFrame.new(0,-1,-0.1,1,0,0,0,1,0,0,0,1)}},
["Knife:11182796403"]={{size=Vector3.new(0.782,3.7031,0.7837),grip=CFrame.new(0,-1.350002,-0.04999542,1,0,0,0,1,0,0,0,1)}},
["Knife:11238166013"]={{size=Vector3.new(0.2757,3.5313,1.041),grip=CFrame.new(0,-1.399999,0,1,0,0,0,1,0,0,0,1)}},
["Knife:112444333460928"]={{size=Vector3.new(0.2256,3.5684,0.9525),grip=CFrame.new(0,-1.096777,0.01281357,1,0,0,0,1,0,0,0,1)}},
["Knife:116508096109443"]={{size=Vector3.new(0.4929,3.6559,0.83),grip=CFrame.new(0,-1.300004,0,1,0,0,0,1,0,0,0,1)}},
["Knife:117500241"]={{size=Vector3.new(0.94,3.09,0.75),scale=Vector3.new(0.4,0.37,0.37),grip=CFrame.new(0,-0.75,0,0,0,-1,0,1,0,1,0,0)}},
["Knife:11837984324"]={{size=Vector3.new(0.2892,3.3208,0.9866),grip=CFrame.new(0.006988525,-1.250007,-0.04975128,0.9975616,0,-0.06979193,0,1,0,0.06979193,0,0.9975616)}},
["Knife:1192795322"]={{size=Vector3.new(0.3,0.85,3.05),scale=Vector3.new(0.55,0.55,0.6),grip=CFrame.new(-0.04850674,-0.1402466,1.326052,-0.9982475,-6.519258e-07,-0.05918177,0.05918177,-2.217293e-05,-0.9982474,-6.519258e-07,-1,2.18749e-05)}},
["Knife:12307707430"]={{size=Vector3.new(0.5299,3.7059,0.5218),grip=CFrame.new(0.006988525,-1.250007,-0.04975128,0.9975616,0,-0.06979193,0,1,0,0.06979193,0,0.9975616)}},
["Knife:128484002922643"]={{size=Vector3.new(0.6996,3.8717,1.3676),grip=CFrame.new(-1.907349e-06,-1.140868,-0.2113926,1,0,0,0,1,0,0,0,1)}},
["Knife:12921240966"]={{size=Vector3.new(0.2614,3.2611,1.0089),grip=CFrame.new(0,-1.18239,-0.03774262,1,0,0,0,1,0,0,0,1)}},
["Knife:130101214"]={{size=Vector3.new(0.4,3,0.8),scale=Vector3.new(0.6,0.6,0.7),grip=CFrame.new(0,-1.350752,0.05,1,0,0,0,1,0,0,0,1)}},
["Knife:136619680236977"]={{size=Vector3.new(0.2041,3.9191,0.7431),grip=CFrame.new(0,-1.100001,0,1,0,0,0,1,0,0,0,1)}},
["Knife:137082284051764"]={{size=Vector3.new(0.2361,3.866,1.1836),scale=Vector3.new(0.0739,0.0739,0.0739),grip=CFrame.new(0,-1.199813,-0.03794479,1,0,0,0,1,0,0,0,1)}},
["Knife:13916938702"]={{size=Vector3.new(0.3045,3.962,1.2656),grip=CFrame.new(0,-1.18239,-0.03774262,1,0,0,0,1,0,0,0,1)}},
["Knife:139203710266613"]={{size=Vector3.new(0.6727,3.3301,1.6073),grip=CFrame.new(0,-1,-0.1,1,0,0,0,1,0,0,0,1)}},
["Knife:140633396635861"]={{size=Vector3.new(0.3604,2.9901,0.7138),grip=CFrame.new(0,-0.8116234,-0.09255981,1,0,0,0,1,0,0,0,1)}},
["Knife:15020899066"]={{size=Vector3.new(0.1672,3.48,0.8619),grip=CFrame.new(0,-1.182294,-0.03774262,1,0,0,0,1,0,0,0,1)}},
["Knife:15057341638"]={{size=Vector3.new(0.6044,3.406,2.1874),grip=CFrame.new(0,-1.062534,0.2099762,1,0,0,0,1,0,0,0,1)}},
["Knife:15320557481"]={{size=Vector3.new(1.099,2.812,1.072),scale=Vector3.new(0.056,0.056,0.056),grip=CFrame.new(0,-0.8692979,-0.008329391,0.2927297,0,-0.9561952,0,1,0,0.9561952,0,0.2927297)}},
["Knife:15408280573"]={{size=Vector3.new(0.4143,4.1435,1.0211),scale=Vector3.new(0.0046,0.0046,0.0046),grip=CFrame.new(0,-1.782394,-0.03774262,1,0,0,0,1,0,0,0,1)}},
["Knife:156092238"]={{size=Vector3.new(0.5,3.1,1),scale=Vector3.new(0.7,0.91,1),grip=CFrame.new(0.061,-1,0.2,1,0,0,0,1,0,0,0,1)}},
["Knife:16025287191"]={{size=Vector3.new(0.2299,3.766,1.1534),grip=CFrame.new(0,-1.199811,-0.1047363,1,0,0,0,1,0,0,0,1)}},
["Knife:1626714161"]={{size=Vector3.new(0.4,3.15,0.8),scale=Vector3.new(25,25,25),grip=CFrame.new(0.01774025,-1.217385,0.07000351,1,0,0,0,1,0,0,0,1)}},
["Knife:165708869"]={{size=Vector3.new(0.35,0.72,2.98),scale=Vector3.new(0.5,0.5,0.5),grip=CFrame.new(0.04635715,0.07951774,1.346006,1,0,0,0,0,1,0,-1,0)}},
["Knife:168119698"]={{size=Vector3.new(0.5,3,0.8),scale=Vector3.new(0.5,0.5,0.55),grip=CFrame.new(-0.1,-1.1,0.2,1,0,0,0,1,0,0,0,1)}},
["Knife:16883629972"]={{size=Vector3.new(0.4445,3.9582,1.0733),grip=CFrame.new(0,-1.300007,0,1,0,0,0,1,0,0,0,1)}},
["Knife:179155055"]={{size=Vector3.new(0.4,3,0.8),scale=Vector3.new(0.55,0.55,0.555),grip=CFrame.new(0.01774025,-1.217385,0.07000351,1,0,0,0,1,0,0,0,1)}},
["Knife:18276861801"]={{size=Vector3.new(0.2201,3.486,0.8077),grip=CFrame.new(0,-1.089372,0,1,0,0,0,1,0,0,0,1)}},
["Knife:1857106669"]={{size=Vector3.new(0.3376,3.0309,1.191),grip=CFrame.new(0,-1.061407,-0.04439497,1,0,0,0,1,0,0,0,1)}},
["Knife:187852667"]={{size=Vector3.new(0.4,0.8,3),scale=Vector3.new(0.6,0.6,0.6),grip=CFrame.new(0,0,1.371632,1,0,0,0,0,1,0,-1,0)}},
["Knife:188539751"]={{size=Vector3.new(0.4,0.7,3),scale=Vector3.new(1,1,1),grip=CFrame.new(0.04070019,0.1331247,1.129551,1,0,0,0,0,1,0,-1,0)}},
["Knife:19040337"]={{size=Vector3.new(0.4,3,0.6),scale=Vector3.new(1.1,1.4,1.1),grip=CFrame.new(0.07706958,0.7942894,0,-4.982948e-05,1.044944e-06,1,-0.04186349,-0.9991233,-1.044944e-06,0.9991233,-0.04186349,4.988909e-05)}},
["Knife:22771612"]={{size=Vector3.new(0.6,0.4,2.4),scale=Vector3.new(0.15,0.15,0.15),grip=CFrame.new(0,0,-0.9,0,0,1,1,0,0,0,1,0)}},
["Knife:238314098"]={{size=Vector3.new(0.25,0.7,2.85),scale=Vector3.new(0.6,0.8,0.73),grip=CFrame.new(0.02497023,0.1396951,1.339233,1,0,0,0,0,1,0,-1,0)}},
["Knife:238314382"]={{size=Vector3.new(0.45,0.7,3.05),scale=Vector3.new(0.7,0.9,0.7),grip=CFrame.new(-0.001290083,-0.02078067,1.271812,1,0,0,0,0,1,0,-1,0)}},
["Knife:2397016406"]={{size=Vector3.new(0.3788,3.6555,1.6701),grip=CFrame.new(0,-1.027305,0,1,0,0,0,1,0,0,0,1)}},
["Knife:2514683594"]={{size=Vector3.new(0.3551,2.9998,0.7679),grip=CFrame.new(0,-1,-0.1,1,0,0,0,1,0,0,0,1)}},
["Knife:262027449"]={{size=Vector3.new(0.25,0.6,3.05),scale=Vector3.new(0.6,0.6,0.6),grip=CFrame.new(0.05482196,0.1795591,1.245935,1,0,0,0,0,1,0,-1,0)}},
["Knife:283709822"]={{size=Vector3.new(0.4,3,0.7),scale=Vector3.new(0.45,0.45,0.45),grip=CFrame.new(0,-1.1,0,1,0,0,0,1,0,0,0,1)}},
["Knife:302165984"]={{size=Vector3.new(0.4,0.7,3),scale=Vector3.new(0.55,0.57,0.52),grip=CFrame.new(0.025,0,1.23,1,0,0,0,0,1,0,-1,0)}},
["Knife:3132923779"]={{size=Vector3.new(0.4,3.15,0.8),scale=Vector3.new(0.95,0.95,0.95),grip=CFrame.new(0.01774025,-1.217385,0.07000351,1,0,0,0,1,0,0,0,1)}},
["Knife:3183449780"]={{size=Vector3.new(0.4,4.05,1.8),scale=Vector3.new(0.085,0.085,0.085),grip=CFrame.new(0.09629186,-0.6563115,0.1809627,0.9995168,-0.004343763,-0.03077915,-0.0060457,0.944113,-0.3295666,0.03049056,0.3295934,0.9436305)}},
["Knife:352571495"]={{size=Vector3.new(0.4,0.65,3),scale=Vector3.new(1.1,1.6,1.2),grip=CFrame.new(8.742274e-09,-0.01206059,1.136867,-1,0,0,0,0,-1,0,-1,0)}},
["Knife:361629844"]={{size=Vector3.new(0.25,0.75,3),scale=Vector3.new(2,3,3),grip=CFrame.new(0.04096317,0.02286224,1.105362,1,0,0,0,0,1,0,-1,0)}},
["Knife:4217523241"]={{size=Vector3.new(0.2881,3.8218,2.6153),grip=CFrame.new(0.07979243,-0.9189947,0.5778611,1,0,0,0,0.9947594,0.1022437,0,-0.1022437,0.9947594)}},
["Knife:4217554208"]={{size=Vector3.new(0.3543,2.6727,0.6283),grip=CFrame.new(0.0146688,-1.021769,0.2100292,0.982585,0,0.1858139,0,1,0,-0.1858139,0,0.982585)}},
["Knife:4528435571"]={{size=Vector3.new(0.2219,3.0097,0.795),grip=CFrame.new(0.005896781,-1.124661,0.1999999,0.999957,-0.006560402,-0.006560402,0.006560402,0.9999785,-2.15199e-05,0.006560402,-2.15199e-05,0.9999785)}},
["Knife:4535643726"]={{size=Vector3.new(0.4855,3.3064,1.552),grip=CFrame.new(0.005894645,-0.8246614,0.3499999,0.999957,-0.006560402,0.006560402,0.006560402,0.9999785,2.15199e-05,-0.006560402,2.15199e-05,0.9999785)}},
["Knife:4662600017"]={{size=Vector3.new(0.3106,3.421,1.0878),grip=CFrame.new(0,-1.17,0.06999995,1,0,0,0,1,0,0,0,1)}},
["Knife:51682254"]={{size=Vector3.new(0.6,0.4,2.4),scale=Vector3.new(0.5,0.5,0.3),grip=CFrame.new(0,-0.1272139,-0.9,1,0,0,0,0,-1,0,1,0)}},
["Knife:532155954"]={{size=Vector3.new(0.35,2.9,0.8),scale=Vector3.new(0.5,0.5,0.5),grip=CFrame.new(0.05007743,-1.27523,0.05,1,0,0,0,1,0,0,0,1)}},
["Knife:5355753728"]={{size=Vector3.new(0.2199,3.2733,0.9641),grip=CFrame.new(-1.411699e-06,-1.2,-1.490116e-08,1,0,0,0,1,0,0,0,1)}},
["Knife:54430772"]={{size=Vector3.new(0.44,0.7,2.99),scale=Vector3.new(0.4,0.6,0.53),grip=CFrame.new(0,0.1047163,-0.7275791,-1,0,0,0,0,1,0,1,0)}},
["Knife:582120569"]={{size=Vector3.new(0.3,2.95,0.65),scale=Vector3.new(0.3,0.5,0.5),grip=CFrame.new(-0.04850674,-1.326052,-0.1402465,-0.998247,0,-0.05919095,0,1,0,0.05919095,0,-0.998247)}},
["Knife:5841877975"]={{size=Vector3.new(0.3924,3.5416,2.9425),grip=CFrame.new(0.07979202,-0.8957058,0.6765652,1,0,0,0,0.9998846,0.01519224,0,-0.01519224,0.9998846)}},
["Knife:5841895234"]={{size=Vector3.new(0.3955,3.3514,1.0144),grip=CFrame.new(0.01774025,-1.317385,0.07000351,1,0,0,0,1,0,0,0,1)}},
["Knife:6085025295"]={{size=Vector3.new(0.257,2.964,1.104),grip=CFrame.new(2.384186e-07,-1.25,0,1,0,0,0,1,0,0,0,1)}},
["Knife:6123168377"]={{size=Vector3.new(0.297,3.3753,1.0364),grip=CFrame.new(0,-1.35,-9.536743e-07,1,0,0,0,1,0,0,0,1)}},
["Knife:6124173614"]={{size=Vector3.new(0.4106,3.0743,1.9554),grip=CFrame.new(0,-0.9500002,0,1,0,0,0,1,0,0,0,1)}},
["Knife:62275962"]={{size=Vector3.new(0.55,2.39,0.2),scale=Vector3.new(0.75,0.75,0.75),grip=CFrame.new(0,-1,0,0,0,-1,0,1,0,1,0,0)}},
["Knife:6404140078"]={{size=Vector3.new(0.2795,3.29,1.1465),grip=CFrame.new(0.01774025,-1.417393,0.02000237,1,0,0,0,1,0,0,0,1)}},
["Knife:64131019"]={{size=Vector3.new(0.6,0.4,2.4),scale=Vector3.new(3,2,2),grip=CFrame.new(0,0.09764481,-0.9,-1,0,0,0,0,1,0,1,0)}},
["Knife:6596834762"]={{size=Vector3.new(0.7214,3.4319,0.9119),grip=CFrame.new(2.384186e-07,-1.45,-0.05000019,1,0,0,0,1,0,0,0,1)}},
["Knife:6596839942"]={{size=Vector3.new(0.3169,3.4062,1.1591),grip=CFrame.new(9.536743e-07,-1.55,0,-1,0,0,0,1,0,0,0,-1)}},
["Knife:6600901997"]={{size=Vector3.new(0.4,3,0.7),scale=Vector3.new(1,1,1),grip=CFrame.new(0,-1,-0.1,1,0,0,0,1,0,0,0,1)}},
["Knife:6769675268"]={{size=Vector3.new(0.355,2.9997,0.768),grip=CFrame.new(0,-1,-0.1,1,0,0,0,1,0,0,0,1)}},
["Knife:70990583"]={{size=Vector3.new(0.6,0.4,2.4),scale=Vector3.new(0.5,0.8,0.6),grip=CFrame.new(0,0,-0.9,0,0,1,1,0,0,0,1,0)}},
["Knife:73266355643345"]={{size=Vector3.new(0.4614,3.7,1.0385),grip=CFrame.new(0,-1.199812,-0.02326202,1,0,0,0,1,0,0,0,1)}},
["Knife:7791364860"]={{size=Vector3.new(0.4498,3.3376,1.1087),grip=CFrame.new(0,-1.378842,-0.1282768,1,0,0,0,1,0,0,0,1)}},
["Knife:8231045240"]={{size=Vector3.new(0.1845,3.3769,0.8258),grip=CFrame.new(0,-1.378842,-0.1282768,1,0,0,0,1,0,0,0,1)}},
["Knife:8293463844"]={{size=Vector3.new(0.5135,2.8965,2.66),grip=CFrame.new(0,-1.378842,-0.1282768,1,0,0,0,1,0,0,0,1)}},
["Knife:8302964090"]={{size=Vector3.new(0.4691,3.347,0.8558),grip=CFrame.new(0,-1.378842,-0.1282768,1,0,0,0,1,0,0,0,1)}},
["Knife:86297695"]={{size=Vector3.new(0.6,0.4,2.4),scale=Vector3.new(0.4,0.2,0.25),grip=CFrame.new(0,0,-0.9,0,0,1,1,0,0,0,1,0)}},
["Knife:86649405964534"]={{size=Vector3.new(0.9329,3.7912,1.0541),grip=CFrame.new(0,-1.339994,-0.04851341,1,0,0,0,1,0,0,0,1)}},
["Knife:86944837615327"]={{size=Vector3.new(0.26,3.852,0.958),grip=CFrame.new(0,-1.246643,-0.2089701,1,0,0,0,1,0,0,0,1)}},
["Knife:93108071"]={{size=Vector3.new(0.66,3,0.38),scale=Vector3.new(0.45,0.45,0.45),grip=CFrame.new(0.1304829,-1.225311,-0.04850674,-0.05916047,0,0.9982485,0,1,0,-0.9982485,0,-0.05916047)}},
["Knife:94840342"]={{size=Vector3.new(0.46,3.24,0.64),scale=Vector3.new(0.45,0.45,0.45),grip=CFrame.new(0,-1.48171,0.04484844,1,0,0,0,1,0,0,0,1)}},
["Knife:957726558"]={{size=Vector3.new(0.4,3,0.7),scale=Vector3.new(1,1,1),grip=CFrame.new(0,-1,-0.1,1,0,0,0,1,0,0,0,1)}},
["Knife:9702732853"]={{size=Vector3.new(0.3381,3.6228,0.8484),grip=CFrame.new(0.002614975,-1.250002,0.04993081,0.9986318,0,0.05229325,0,1,0,-0.05229325,0,0.9986318)}},
}
local function recordedGrip(kind,meshId,root,mesh)
local list=RECORDED_GRIPS[kind..":"..meshId]
if not list then return nil end
local function near(a,b) return math.abs(a.X-b.X)<=math.abs(b.X)*0.03+0.005 and math.abs(a.Y-b.Y)<=math.abs(b.Y)*0.03+0.005
and math.abs(a.Z-b.Z)<=math.abs(b.Z)*0.03+0.005 end
for _,variant in ipairs(list) do
if near(root.Size,variant.size) and (not variant.scale or (mesh and near(mesh.Scale,variant.scale))) then return variant.grip end
end
end
local KNOWN_GRIPS={
["6600918074"]={kind="Gun",size=Vector3.new(1.83,0.95,0.325),
grip=CFrame.new(0.6997261,-0.3059801,0.0010891,0,0,1,0,1,0,-1,0,0)},
["305826272"]={kind="Knife",size=Vector3.new(0.25,2.9,1.6),meshSize=Vector3.new(0.25,2.9,1.6),
grip=CFrame.new(0,-0.8515663,0.3104025)},
["77738838473091"]={kind="Knife",size=Vector3.new(0.4327235,3.3586948,1.9186603),
meshSize=Vector3.new(5.53668928,42.97441483,24.54920006),
grip=CFrame.new(0,-0.8397148,0)},
["92263601594064"]={kind="Knife",size=Vector3.new(0.3119834,3.6274931,1.9227760),
meshSize=Vector3.new(4.30026054,50,26.50281334),
grip=CFrame.new(0,-0.6625369,0.2304325)},
["88250692342609"]={kind="Knife",size=Vector3.new(0.4038950,3.4534402,1.0080675),
meshSize=Vector3.new(5.84771681,50,14.59511662),
grip=CFrame.new(0,-1.0000004,-0.0851784)},
["121944778"]={kind="Knife",size=Vector3.new(0.4,3,0.7),meshSize=Vector3.new(0.4,3,0.7),
grip=CFrame.new(0,-1,-0.1)},
["109711282082830"]={kind="Knife",size=Vector3.new(0.3976223,2.6648693,2.3640010),
meshSize=Vector3.new(7.4604459,50,44.3549271),
grip=CFrame.new(0,-0.0444214,0.2383194)},
}
local function snapAxis(v)
local ax,ay,az=math.abs(v.X),math.abs(v.Y),math.abs(v.Z)
if ax>=ay and ax>=az then return Vector3.new(v.X>0 and 1 or -1,0,0) end
if ay>=az then return Vector3.new(0,v.Y>0 and 1 or -1,0) end
return Vector3.new(0,0,v.Z>0 and 1 or -1)
end
local function axisError(frame)
local total=0
for _,value in ipairs({select(4,frame:GetComponents())}) do
local magnitude=math.abs(value)
total=total+math.min(magnitude,math.abs(1-magnitude))
end
return total
end
local function estimateHandGrip(holster)
local best,bestError
for _,group in ipairs(GRIP_GROUPS) do
local err=axisError(holster.Rotation*group.rel)
if not bestError or err<bestError then best,bestError=group,err end
end
if not best or bestError>0.5 then return nil end
local rotated=holster.Rotation*best.rel
local x=snapAxis(rotated.XVector)
local y=snapAxis(rotated.YVector)
if y.Y<-0.5 then y=-y end
if math.abs(x:Dot(y))>0.01 then return nil end
local z=x:Cross(y)
local basis=CFrame.fromMatrix(Vector3.zero,x,y,z)
return CFrame.fromMatrix(holster.Position+basis:VectorToWorldSpace(best.offset),x,y,z)
end
local function cloneObject(source)
local previous=source.Archivable
pcall(function() source.Archivable=true end)
local ok,clone=pcall(function() return source:Clone() end)
pcall(function() source.Archivable=previous end)
return ok and clone or nil
end
local function assetId(value)
if type(value)=="number" and value>0 then return string.format("%.0f",math.floor(value)) end
if type(value)=="string" then
return value:match("^%s*(%d+)%s*$") or value:match("rbxassetid://(%d+)")
or value:match("[?&]id=(%d+)")
end
end
local function originalHold(container)
if not container then return nil end
for _,object in ipairs(container:GetDescendants()) do
if object:IsA("Animation") then
local name=compact(object.Name)
if name=="customhold" or name=="scopehold" or name=="gingerscopehold" or name=="hold2" then
local marked=false
local ancestor=object
while ancestor and ancestor~=container do
if ancestor:GetAttribute(MARKER) then marked=true; break end
ancestor=ancestor.Parent
end
local id=not marked and assetId(object.AnimationId)
if id then return id end
end
end
end
end
local function vector(value,fallback)
if typeof(value)=="Vector3" then return value end
if type(value)=="table" then
local x,y,z=tonumber(value.X or value.x or value[1]),tonumber(value.Y or value.y or value[2]),tonumber(value.Z or value.z or value[3])
if x and y and z then return Vector3.new(x,y,z) end
end
return fallback
end
local function resolveModel(path)
if type(path)~="table" then return nil end
local current=game
for _,name in ipairs(path) do
if name~="game" then current=current and current:FindFirstChild(tostring(name)) end
if not current then return nil end
end
return current
end
local function wanted(entry)
local settings=kinds[entry.kind]
return alive and runtimeAlive and settings and settings.enabled and settings.selected==entry.id
end
local function replicatedModel(entry)
local storage=game:GetService("ReplicatedStorage")
local names={[entry.id]=true,[entry.name]=true}
local id=assetId(entry.data.modelid or entry.data.itemid)
if id then names[id]=true end
local function candidate(object)
if not object or object:GetAttribute(MARKER) or not visualRoot(object) then return nil end
local ancestor=object
while ancestor and ancestor~=storage do
if ancestor:GetAttribute(MARKER) then return nil end
ancestor=ancestor.Parent
end
return object
end
for name in pairs(names) do
local object=candidate(storage:FindFirstChild(name,true))
if object then return object end
end
local queue={storage}
local index=1
local target=compact(entry.id)
local inspected=0
local batchTime=os.clock()
while queue[index] and inspected<12000 do
if not wanted(entry) then return nil end
local container=queue[index];index=index+1
for _,object in ipairs(container:GetChildren()) do
inspected=inspected+1
if not object:GetAttribute(MARKER) then
if object:IsA("Model") or object:IsA("Tool") or object:IsA("BasePart") or object:IsA("Folder") then
local item=object:GetAttribute("ItemID") or object:GetAttribute("WeaponID")
if compact(object.Name)==target or (item and (tostring(item)==entry.id or (id and assetId(item)==id))) then
local found=candidate(object)
if found then return found end
end
end
queue[#queue+1]=object
end
if inspected%64==0 or os.clock()-batchTime>=bootBudget(0.003) then
task.wait()
batchTime=os.clock()
if not wanted(entry) then return nil end
end
if inspected>=12000 then break end
end
end
end
local function buildTemplate(entry)
local data=entry.data
local modelData=type(data.model)=="table" and properties(data.model) or data
local originals=env.VisualsV2Runtime.OriginalVisuals
local source=originals and originals.GetWeapon(entry.kind,entry.id)
or resolveModel(data.sourcepath) or replicatedModel(entry)
if not wanted(entry) then return nil,{cancelled=true} end
local loaded={}
local attempts={}
local sourceName=source and (source:GetAttribute("VisualsV2_OriginalSource") or objectPath(source))
local clone=source and cloneObject(source) or nil
if not clone then
local primaryId=assetId(data.modelid) or assetId(data.assetid) or assetId(data.weaponasset)
or assetId(data.model) or assetId(data.itemid)
local ids={}
if primaryId then ids[#ids+1]=primaryId end
if entry.originalModelId and entry.originalModelId~=primaryId then ids[#ids+1]=entry.originalModelId end
for _,id in ipairs(ids) do
local download=env.VisualsV2Runtime.GetObjects
local ok,objects=pcall(function()
if type(download)=="function" then return download("rbxassetid://"..id) end
return game:GetObjects("rbxassetid://"..id)
end)
attempts[#attempts+1]={assetId=id,ok=ok,returned=typeof(objects),
count=ok and type(objects)=="table" and #objects or 0,error=not ok and tostring(objects) or nil}
if ok and type(objects)=="table" then
for _,object in ipairs(objects) do
loaded[#loaded+1]=object
if not clone and visualRoot(object) then clone=object;sourceName="asset:"..id end
end
end
if clone then break end
end
end
if not clone then
local meshId=assetId(modelData.meshid or data.meshid or modelData.mesh)
if meshId then
local part=Instance.new("Part")
part.Name="Handle"
part.Size=vector(modelData.size or data.size,Vector3.new(1,1,1))
local mesh=Instance.new("SpecialMesh")
mesh.MeshType=Enum.MeshType.FileMesh
mesh.MeshId="rbxassetid://"..meshId
local texture=assetId(modelData.textureid or modelData.texture or data.textureid or data.texture)
mesh.TextureId=texture and "rbxassetid://"..texture or ""
mesh.Scale=vector(modelData.meshscale or modelData.scale or data.meshscale,Vector3.new(1,1,1))
mesh.Offset=vector(modelData.offset,Vector3.new())
mesh.Parent=part
if typeof(modelData.color or data.color)=="Color3" then part.Color=modelData.color or data.color end
clone=part
end
end
for _,object in ipairs(loaded) do if object~=clone then pcall(function() object:Destroy() end) end end
if not clone then
return nil,{message="No original model is available for "..entry.name,attempts=attempts,source=sourceName}
end
local root=visualRoot(clone)
if not root then clone:Destroy(); return nil,"No weapon mesh was found for "..entry.name end
local attachment=gripAttachment(root)
local attachmentGrip=attachment and attachment.CFrame
if entry.kind=="Knife" and attachmentGrip and attachmentGrip.Position.Magnitude<0.6 then
local _,angle=attachmentGrip:ToAxisAngle()
if math.abs(angle)<=math.rad(15) then attachmentGrip=nil end
end
local holsterAttachment=attachment or root:FindFirstChild("Attachment")
local holsterGrip=holsterAttachment and holsterAttachment:IsA("Attachment") and holsterAttachment.CFrame or CFrame.new()
local texture=assetId(modelData.textureid or modelData.texture or data.textureid or data.texture)
if texture then
local mesh=root:FindFirstChildWhichIsA("SpecialMesh")
if mesh then mesh.TextureId="rbxassetid://"..texture end
if root:IsA("MeshPart") then root.TextureID="rbxassetid://"..texture end
end
local capturedGrip=clone:GetAttribute("VisualsV2_CapturedGrip")
local grip=typeof(capturedGrip)=="CFrame" and capturedGrip or typeof(data.grip)=="CFrame" and data.grip or nil
local useToolGrip=typeof(capturedGrip)=="CFrame"
local behavior=originals and originals.GetGunBehavior(entry.id)
local scopeHold=isScope(entry) and (behavior and assetId(behavior.hold) or originalHold(clone)) or nil
if clone:IsA("Tool") then grip=clone.Grip;useToolGrip=true end
local ancestor=root.Parent
while ancestor and ancestor~=clone do
if ancestor:IsA("Tool") then grip=ancestor.Grip; break end
ancestor=ancestor.Parent
end
if not useToolGrip then
local meshId,mesh
if root:IsA("MeshPart") then meshId=assetId(root.MeshId)
else
mesh=root:FindFirstChildWhichIsA("SpecialMesh")
meshId=mesh and assetId(mesh.MeshId)
end
-- (scythes and Synthwave knives keep the grip they had before: their recorded grips held them wrong)
local recorded=meshId and not (entry.kind=="Knife" and (compact(entry.id)..compact(entry.name)):find("scythe",1,true))
and not compact(entry.id):find("synthwave",1,true) and recordedGrip(entry.kind,meshId,root,mesh)
if recorded then
grip=recorded;useToolGrip=true
clone:SetAttribute("VisualsV2_RecordedGripOffset",true)
end
local known=not recorded and meshId and KNOWN_GRIPS[meshId]
if known and known.kind==entry.kind then
local size=root.Size
if mesh and known.meshSize then size=mesh.Scale*known.meshSize end
local matches=math.abs(size.X-known.size.X)<=known.size.X*0.06+0.01
and math.abs(size.Y-known.size.Y)<=known.size.Y*0.06+0.01
and math.abs(size.Z-known.size.Z)<=known.size.Z*0.06+0.01
if matches then grip=known.grip;useToolGrip=true end
end
end
if entry.kind=="Knife" then
local key=compact(entry.id)..compact(entry.name)
if (key:find("scythe",1,true) or compact(entry.id)=="icewing") and not clone:GetAttribute("VisualsV2_RecordedGripOffset") then
grip=KNOWN_GRIPS["305826272"].grip;useToolGrip=true
end
end
if entry.kind=="Gun" and not useToolGrip and attachment and attachment.Name=="CustomAttachment" and attachmentGrip then
local estimated=estimateHandGrip(attachmentGrip)
if estimated then grip=estimated;useToolGrip=true end
elseif entry.kind=="Gun" and not useToolGrip and not attachment then
local size=root.Size
if size.Y>=size.X and size.Y>=size.Z then
grip=CFrame.new(0,-0.7*size.Y/1.83,-0.3*size.Z/1.03,1,0,0,0,0,-1,0,1,0);useToolGrip=true
elseif size.Z>=size.X then
grip=CFrame.new(0,-0.2*size.Y,0.21*size.Z);useToolGrip=true
end
end
local allowed={Model=true,Folder=true,Attachment=true,Bone=true,SurfaceAppearance=true,
Tool=true,WrapLayer=true,WrapTarget=true,ParticleEmitter=true,Trail=true,Beam=true,Fire=true,
Smoke=true,Sparkles=true,PointLight=true,SpotLight=true,SurfaceLight=true}
for _,object in ipairs(clone:GetDescendants()) do
if not object:IsA("BasePart") and not object:IsA("DataModelMesh")
and not object:IsA("Decal") and not allowed[object.ClassName] then object:Destroy() end
end
for _,object in ipairs(clone:GetDescendants()) do
if object:IsA("Tool") then
local parent=object.Parent
for _,child in ipairs(object:GetChildren()) do child.Parent=parent end
object:Destroy()
end
end
local model=Instance.new("Model")
model.Name="VisualsV2_ClientWeaponTemplate"
model:SetAttribute(MARKER,true)
if clone:IsA("BasePart") then clone.Parent=model
else
for _,object in ipairs(clone:GetChildren()) do object.Parent=model end
clone:Destroy()
end
if not root:IsDescendantOf(model) then model:Destroy(); return nil,"The weapon Handle is unavailable" end
model.PrimaryPart=root
local totalRate=0
local emitters={}
for _,object in ipairs(model:GetDescendants()) do
if object:IsA("ParticleEmitter") and object.Enabled then
emitters[#emitters+1]=object;totalRate=totalRate+object.Rate
end
end
if totalRate>80 then
for _,emitter in ipairs(emitters) do emitter.Rate=emitter.Rate*(80/totalRate) end
end
if entry.kind=="Gun" then
local muzzle
for _,object in ipairs(model:GetDescendants()) do
local name=compact(object.Name)
if object:IsA("Attachment") and (name=="muzzle" or name=="muzzleattachment"
or name=="barreltip" or name=="barrelattachment") then muzzle=object;break end
end
if muzzle then muzzle.Name="VisualsV2_Muzzle"
else
muzzle=Instance.new("Attachment");muzzle.Name="VisualsV2_Muzzle"
local forward=(grip or attachmentGrip or CFrame.new()).LookVector
local half=root.Size*0.5
local distance=math.huge
for _,axis in ipairs({"X","Y","Z"}) do
if math.abs(forward[axis])>0.001 then distance=math.min(distance,half[axis]/math.abs(forward[axis])) end
end
muzzle.Position=forward*(distance<math.huge and distance or 0)
muzzle.Parent=root
end
muzzle:SetAttribute("VisualsV2_GunCosmetic",true)
end
return {model=model,root=root,grip=grip,attachmentGrip=attachmentGrip,holsterGrip=holsterGrip,useToolGrip=useToolGrip,scopeHold=scopeHold,chroma=data.chroma==true,
revision=entry.revision,lastUsed=os.clock(),source=sourceName,attempts=attempts}
end
local cache={}
local loading={}
local failed={}
local warned={}
local function cacheKey(entry) return entry.kind..":"..entry.id end
local function templateFor(entry)
local key=cacheKey(entry)
local cached=cache[key]
if cached and cached.revision==entry.revision then cached.lastUsed=os.clock(); return cached end
if cached then cached.model:Destroy(); cache[key]=nil end
local failure=failed[key]
if loading[key] or (failure and failure.revision==entry.revision) then return nil end
if failure and failure.revision~=entry.revision then warned[key]=nil end
loading[key]=true
local startedRevision=entry.revision
task.spawn(function()
local ok,result,reason=pcall(buildTemplate,entry)
loading[key]=nil
if not alive or not runtimeAlive then
if ok and result then result.model:Destroy() end
return
end
if entry.revision~=startedRevision then
if ok and result then result.model:Destroy() end
task.defer(refreshTools)
return
end
if ok and not result and type(reason)=="table" and reason.cancelled then return end
if ok and result then
failed[key]=nil
warned[key]=nil
cache[key]=result
local count=0
for _ in pairs(cache) do count=count+1 end
if count>6 then
local oldestKey,oldestTime=nil,math.huge
for candidate,value in pairs(cache) do
local selected=false
for _,state in pairs(kinds) do
local kind=state==kinds.Gun and "Gun" or "Knife"
if candidate==kind..":"..state.selected then selected=true end
end
if not selected and value.lastUsed<oldestTime then oldestKey,oldestTime=candidate,value.lastUsed end
end
if oldestKey then cache[oldestKey].model:Destroy(); cache[oldestKey]=nil end
end
task.defer(refreshTools)
else
local failure=type(reason)=="table" and reason or {}
failure.reason=not ok and tostring(result) or failure.message or tostring(reason or "Weapon model loading failed")
failure.revision=entry.revision
failed[key]=failure
recordError("Load "..entry.id,failure.reason)
local state=kinds[entry.kind]
if state.enabled and state.selected==entry.id and not warned[key] then
warned[key]=true
notify("Visual Weapons/Effects: "..failure.reason..".",1)
end
task.defer(refreshTools)
end
end)
return cache[key]
end
local function owned(object,tool)
while object and object~=tool do
if object:GetAttribute(MARKER) then return true end
object=object.Parent
end
return false
end
local function stopScopeHold(state)
state.holdGeneration=(state.holdGeneration or 0)+1
state.holdPending=nil
local hold=state.hold
state.hold=nil
if not hold then return end
if hold.died then hold.died:Disconnect() end
if hold.played then hold.played:Disconnect() end
if hold.poseConnection then hold.poseConnection:Disconnect() end
for motor,transform in pairs(hold.motors or {}) do
pcall(function() motor.Transform=transform end)
end
for track,weight in pairs(hold.suppressed or {}) do
pcall(function() if track.IsPlaying then track:AdjustWeight(weight,0.12) end end)
end
if not hold.owned and hold.track and hold.nativePriority then
pcall(function()
hold.track.Priority=hold.nativePriority;hold.track.Looped=hold.nativeLooped
if hold.nativeWeight then hold.track:AdjustWeight(hold.nativeWeight,0.12) end
end)
end
if hold.owned then
pcall(function() hold.track:Stop(0.12) end)
pcall(function() hold.track:Destroy() end)
end
if hold.animation then hold.animation:Destroy() end
end
local function playingTracks(animator)
local ok,tracks=pcall(function() return animator:GetPlayingAnimationTracks() end)
return ok and tracks or {}
end
local function suppressToolHold(tool,hold)
local ids={}
local nativeId=originalHold(tool)
if nativeId then ids[nativeId]=true end
local animate=player.Character and player.Character:FindFirstChild("Animate")
local toolNone=animate and animate:FindFirstChild("toolnone")
if toolNone then
for _,animation in ipairs(toolNone:GetDescendants()) do
if animation:IsA("Animation") then
local id=assetId(animation.AnimationId)
if id then ids[id]=true end
end
end
end
for _,track in ipairs(playingTracks(hold.animator)) do
local animation=track.Animation
if track~=hold.track and animation and ids[assetId(animation.AnimationId)] then
if hold.suppressed[track]==nil then
hold.suppressed[track]=tonumber(track.WeightTarget) or tonumber(track.WeightCurrent) or 1
end
pcall(function() track:AdjustWeight(0,0.08) end)
end
end
end
local scopeMeshes=nil
local rejectedScopeHolds={}
local nativeHoldCache=setmetatable({}, {__mode="k"})
local lastNativeScopeScan=0
local storageScopeScanned=false
local function nativeScopeId(tool,humanoid)
if not tool or tool:GetAttribute(MARKER) then return nil end
local previous=nativeHoldCache[tool]
if previous and previous.Parent==tool.Parent and previous.untilTime>os.clock() then return previous.id end
local item=tostring(tool:GetAttribute("ItemID") or tool:GetAttribute("WeaponID") or tool:GetAttribute("ItemName") or "")
local entry=catalog.Gun[item]
local itemName=compact(item)
local confirmed=entry and isScope(entry) or itemName:find("scope",1,true)
if not confirmed then
local presentation=env.VisualsV2Runtime.WeaponPresentation
local nativeIcon=presentation and presentation.GetNativeIcon(tool) or tool.TextureId
local function iconId(value)
value=tostring(value or ""):lower()
return value:match("rbxassetid://(%d+)") or value:match("[?&]assetid=(%d+)")
or value:match("[?&]id=(%d+)") or value:match("^(%d+)$")
end
local sourceIcon=iconId(nativeIcon)
if sourceIcon then
for _,candidate in pairs(catalog.Gun) do
if isScope(candidate) and iconId(candidate.data.image or candidate.data.itemid)==sourceIcon then
confirmed=true;break
end
end
end
end
if not confirmed then
local root=visualRoot(tool)
local mesh=root and (root:IsA("MeshPart") and assetId(root.MeshId)
or root:FindFirstChildWhichIsA("SpecialMesh") and assetId(root:FindFirstChildWhichIsA("SpecialMesh").MeshId))
if mesh then
local originals=env.VisualsV2Runtime.OriginalVisuals
scopeMeshes=scopeMeshes or originals and originals.ScopeMeshes or {}
confirmed=scopeMeshes[mesh]
end
end
if not confirmed then return nil end
local id=originalHold(tool)
if not id and humanoid and tool.Parent==humanoid.Parent then
local animator=humanoid:FindFirstChildOfClass("Animator")
local candidate
for _,track in ipairs(animator and playingTracks(animator) or {}) do
local name=track.Animation and compact(track.Animation.Name) or ""
local holdName=name=="customhold" or name=="scopehold" or name=="gingerscopehold" or name=="hold2"
if track.IsPlaying and track.Looped and track.Animation
and (track.Priority==Enum.AnimationPriority.Action2 or holdName and track.Priority==Enum.AnimationPriority.Action) then
local value=assetId(track.Animation.AnimationId)
if value and candidate and candidate~=value then return nil end
candidate=value or candidate
end
end
id=candidate
end
if id then nativeHoldCache[tool]={Parent=tool.Parent,id=id,untilTime=os.clock()+1} end
return id
end
local function scopeCacheKey(rig)
return "nativeScopeHold_"..tostring(game.GameId).."_"..rig
end
local function resolveScopeHold(tool,humanoid,rig,templateHold)
local rejected=rejectedScopeHolds[rig] or {}
rejectedScopeHolds[rig]=rejected
local native=nativeScopeId(tool,humanoid)
if native and (not rejected[native] or rejected[native]<=os.clock()) then return native end
if humanoid.RigType==Enum.HumanoidRigType.R15 and templateHold
and (not rejected[templateHold] or rejected[templateHold]<=os.clock()) then return templateHold end
if not mmv and humanoid.RigType==Enum.HumanoidRigType.R15
and (not rejected[ORIGINAL_SCOPE_HOLD] or rejected[ORIGINAL_SCOPE_HOLD]<=os.clock()) then return ORIGINAL_SCOPE_HOLD end
if nativeScopeHolds[rig] and (mmv or nativeScopeHolds[rig]~=MMV_SCOPE_HOLD) and (not rejected[nativeScopeHolds[rig]] or rejected[nativeScopeHolds[rig]]<=os.clock()) then return nativeScopeHolds[rig] end
local saved=assetId(C(scopeCacheKey(rig),nil))
if saved and (mmv or saved~=MMV_SCOPE_HOLD) and (not rejected[saved] or rejected[saved]<=os.clock()) then nativeScopeHolds[rig]=saved;return saved end
if os.clock()-lastNativeScopeScan>=1 then
lastNativeScopeScan=os.clock()
for _,owner in ipairs(game:GetService("Players"):GetPlayers()) do
local character=owner.Character
local otherHumanoid=character and character:FindFirstChildOfClass("Humanoid")
if otherHumanoid and tostring(otherHumanoid.RigType)==rig then
local backpack=owner:FindFirstChildOfClass("Backpack")
for _,container in pairs({character,backpack}) do
for _,candidate in ipairs(container:GetChildren()) do
if candidate:IsA("Tool") then
local id=nativeScopeId(candidate,otherHumanoid)
if id and (not rejected[id] or rejected[id]<=os.clock()) then nativeScopeHolds[rig]=id;return id end
end
end
end
end
end
local storage=game:GetService("ReplicatedStorage")
if not storageScopeScanned then
storageScopeScanned=true
for _,object in ipairs(storage:GetDescendants()) do
if object:IsA("Animation") and not owned(object,storage) then
local name=compact(object.Name)
local context=object.Parent
local scopeContext=false
for _=1,4 do
if not context or context==storage then break end
local parentName=compact(context.Name)
if parentName:find("gingerscope",1,true) or parentName:find("voidscope",1,true) or parentName:find("matrixscope",1,true) then scopeContext=true;break end
context=context.Parent
end
if name:find("scopehold",1,true) or scopeContext and (name=="customhold" or name=="hold2" or name=="gingerscopehold") then
local id=assetId(object.AnimationId)
if id and (not rejected[id] or rejected[id]<=os.clock()) then nativeScopeHolds[rig]=id;return id end
end
end
end
end
end
if humanoid.RigType==Enum.HumanoidRigType.R15 and (not rejected[ORIGINAL_SCOPE_HOLD] or rejected[ORIGINAL_SCOPE_HOLD]<=os.clock()) then return ORIGINAL_SCOPE_HOLD end
end
local function r6ScopeHold(tool,state,humanoid)
local character=humanoid.Parent
local hold=state.hold
if hold and hold.pose and hold.character==character then return end
stopScopeHold(state)
local torso=character:FindFirstChild("Torso")
local right=torso and torso:FindFirstChild("Right Shoulder")
local left=torso and torso:FindFirstChild("Left Shoulder")
if not right or not left or not right:IsA("Motor6D") or not left:IsA("Motor6D") then
state.holdError="Waiting for the R6 shoulder joints"
return
end
hold={pose=true,character=character,motors={[right]=right.Transform,[left]=left.Transform},suppressed={}}
state.hold=hold;state.holdError=nil
local rightRotation=CFrame.Angles(math.rad(90),math.rad(-8),math.rad(-6))
local leftRotation=CFrame.Angles(math.rad(80),math.rad(32),math.rad(12))
local rotations={[right]=rightRotation,[left]=leftRotation}
local function pose()
if state.hold~=hold or tool.Parent~=character or humanoid.Health<=0 then return end
for motor,rotation in pairs(rotations) do
if motor.Parent then
motor.Transform=motor.C0:Inverse()*CFrame.new(motor.C0.Position)*rotation*motor.C1.Rotation
end
end
end
hold.poseConnection=RunService.PreSimulation:Connect(pose)
hold.died=humanoid.Died:Connect(function() if state.hold==hold then stopScopeHold(state) end end)
pose()
end
local function updateScopeHold(tool,state,entry)
local character=player.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")
if not isScope(entry) or tool.Parent~=character or not state.model or not animator or humanoid.Health<=0 then
if state.hold or state.holdPending then stopScopeHold(state) end
return
end
local existing=state.hold
if existing and not existing.pose and existing.animator==animator and existing.skinSignature==state.applied
and existing.track and existing.track.IsPlaying then return end
local rig=tostring(humanoid.RigType)
if humanoid.RigType==Enum.HumanoidRigType.R6 then
r6ScopeHold(tool,state,humanoid)
return
end
local id=resolveScopeHold(tool,humanoid,rig,state.scopeTemplateHold)
if not id then
state.holdError=state.holdError or "The original scope animation has not been found in this game."
if state.hold or state.holdPending then stopScopeHold(state) end
return
end
local signature=state.applied..":"..id
local hold=state.hold
if hold and hold.animator==animator and hold.signature==signature and hold.track.IsPlaying then
return
end
local pending=state.holdPending
if pending and pending.animator==animator and pending.signature==signature then return end
if state.holdRetry and state.holdRetry.signature==signature and state.holdRetry.untilTime>os.clock() then return end
stopScopeHold(state)
local generation=state.holdGeneration
local model=state.model
pending={animator=animator,signature=signature}
state.holdPending=pending
local function current()
return alive and runtimeAlive and toolStates[tool]==state and state.holdGeneration==generation
and state.holdPending==pending and state.model==model and tool.Parent==character
and player.Character==character and humanoid.Health>0
and humanoid:FindFirstChildOfClass("Animator")==animator
end
task.spawn(function()
local track,animation,loadError
local ownsTrack=false
for _,candidate in ipairs(playingTracks(animator)) do
if candidate.IsPlaying and candidate.Animation and assetId(candidate.Animation.AnimationId)==id then
track=candidate;break
end
end
if not track then
ownsTrack=true
local source
for _,object in ipairs(tool:GetDescendants()) do
if object:IsA("Animation") and not owned(object,tool) and assetId(object.AnimationId)==id then source=object;break end
end
if not source then
animation=Instance.new("Animation")
animation.Name="VisualsV2ScopeHold"
animation:SetAttribute(MARKER,true)
animation.AnimationId="rbxassetid://"..id
animation.Parent=model
source=animation
end
local ok,result=pcall(function() return animator:LoadAnimation(source) end)
if ok then track=result else loadError=tostring(result) end
if track and current() then
local played,err=pcall(function()
track.Priority=Enum.AnimationPriority.Action2
track.Looped=true
track:Play(0.12,1,1)
end)
if not played then loadError=tostring(err) end
local deadline=os.clock()+20
while not loadError and current() and track.Length<=0 and os.clock()<deadline do task.wait(0.1) end
if not loadError and track.Length<=0 then loadError="Animation data was still unavailable after 20 seconds" end
end
end
local function discard()
if ownsTrack and track then
pcall(function() track:Stop(0) end)
pcall(function() track:Destroy() end)
end
if animation then animation:Destroy() end
end
if not current() then discard();return end
if not track or loadError or not track.IsPlaying then
discard()
state.holdPending=nil
rejectedScopeHolds[rig]=rejectedScopeHolds[rig] or {}
rejectedScopeHolds[rig][id]=os.clock()+30
if nativeScopeHolds[rig]==id then nativeScopeHolds[rig]=nil end
state.holdError="Original animation "..id.." ("..rig.."): "..(loadError or "The animation did not start")
state.holdRetry={signature=signature,untilTime=os.clock()+30}
local warning=rig..":"..id
if not scopeHoldWarnings[warning] then
scopeHoldWarnings[warning]=true
notify("Visual Weapons/Effects: the original scope hold couldn't load ("..id.."); trying again",0)
end
return
end
state.holdPending=nil
state.holdRetry=nil
state.holdError=nil
nativeScopeHolds[rig]=id
SetCfg(scopeCacheKey(rig),id)
local priority,looped,weight=track.Priority,track.Looped,track.WeightTarget
pcall(function()
track.Priority=Enum.AnimationPriority.Action2;track.Looped=true;track:AdjustWeight(1,0.12)
end)
hold={track=track,animation=animation,animator=animator,signature=signature,skinSignature=state.applied,
owned=ownsTrack,nativePriority=not ownsTrack and priority or nil,nativeLooped=looped,nativeWeight=weight,suppressed={}}
state.hold=hold
model:SetAttribute("ScopeHoldAnimationID",id)
hold.died=humanoid.Died:Connect(function()
if state.hold==hold then stopScopeHold(state) end
end)
hold.played=animator.AnimationPlayed:Connect(function(track)
if state.hold==hold and track~=hold.track then suppressToolHold(tool,hold) end
end)
suppressToolHold(tool,hold)
end)
end
local function restoreOriginals(state)
for object,record in pairs(state.originals) do
if record.connection then record.connection:Disconnect() end
pcall(function()
local value=record.value
local effects=env.VisualsV2Runtime.ClientKnifeEffects
if record.property=="Enabled" and effects and effects.IsSuppressed(object) then value=false end
object[record.property]=value
end)
end
table.clear(state.originals)
state.nativeDirty=true
end
local function parkVisuals(state)
if not state.model or state.model.Parent==nil then return end
stopScopeHold(state)
state.model.Parent=nil
restoreOriginals(state)
end
local function restoreVisuals(state)
for beam,saved in pairs(state.nativeBeams or {}) do
if beam.Parent then for key,value in pairs(saved) do pcall(function() beam[key]=value end) end end
end
state.nativeBeams=nil
stopScopeHold(state)
state.holdRetry=nil
state.scopeTemplateHold=nil
if state.model then state.model:Destroy(); state.model=nil end
restoreOriginals(state)
if state.nativeConnection then state.nativeConnection:Disconnect();state.nativeConnection=nil end
state.applied=nil
state.handle=nil
state.appliedGrip=nil
state.chromaTargets=nil
state.parts=nil
state.welds=nil
end
local function chromaTargets(model,root)
local targets={}
for _,part in ipairs(model:GetDescendants()) do
if part:IsA("Decal") and (part:GetAttribute("Chroma")==true or compact(part.Name)=="chroma") then
targets[#targets+1]=part
elseif part:IsA("BasePart") then
local marked=part:GetAttribute("Chroma")==true or compact(part.Name):find("chroma",1,true)~=nil
for _,child in ipairs(part:GetChildren()) do
if child:IsA("DataModelMesh") and compact(child.Name):find("chroma",1,true) then marked=true end
end
if marked then targets[#targets+1]=part end
end
end
-- (parts the game tags ChromaPart are marked Chroma in the data: like the game, only their own color
-- cycles (a textured part shows it where its texture is see-through, e.g. Evergreen's ribbons). A weapon
-- with nothing marked falls back to tinting its whole body. LightParts (Evergreen's lights) blink
-- through the game's five light colors)
local tagged=#targets>0
if not tagged then targets[1]=root end
for index,part in ipairs(targets) do
local decal=part:IsA("Decal")
targets[index]={object=part,decal=decal,tagged=tagged,original=decal and part.Color3 or part.Color,
mesh=not tagged and not decal and part:FindFirstChildWhichIsA("SpecialMesh") or nil}
end
local light=0
for _,part in ipairs(model:GetDescendants()) do
if part:IsA("BasePart") and part.Name=="LightPart" then
targets[#targets+1]={object=part,light=light,original=part.Color};light=light+1
end
end
return targets
end
local LIGHT_COLORS={Color3.new(0,0.74,0.70),Color3.new(0.92,0,0),Color3.new(0.94,0.87,0),Color3.new(0.86,0,0.86),Color3.new(0.11,0.9,0)}
local WHITE=Color3.new(1,1,1)
-- (the game's /chromatoggle turns chroma colors on and off for real chroma weapons (its ChromaScript gets a
-- ToggleChromas event); the visual chroma weapons follow the same switch: off, they show their plain
-- colors)
do
local runtime=env.VisualsV2Runtime
if runtime.ChromaToggleConnection then pcall(function() runtime.ChromaToggleConnection:Disconnect() end) end
runtime.ChromaOff=runtime.ChromaOff==true
task.spawn(function()
local scripts=LocalPlayer:WaitForChild("PlayerScripts",30)
local visuals=scripts and scripts:WaitForChild("WeaponVisuals",30)
local chroma=visuals and visuals:WaitForChild("ChromaScript",30)
local toggle=chroma and chroma:WaitForChild("ToggleChromas",30)
if not (toggle and toggle:IsA("BindableEvent")) or not runtimeAlive then return end
runtime.ChromaToggleConnection=toggle.Event:Connect(function() runtime.ChromaOff=not runtime.ChromaOff end)
RootMaid:GiveTask(function() pcall(function() runtime.ChromaToggleConnection:Disconnect() end) end)
end)
end
local function updateChroma(state)
if not state.chromaTargets then return end
local off=env.VisualsV2Runtime.ChromaOff
local color=Color3.fromHSV((os.clock()*0.15)%1,1,1)
local step=math.floor(os.clock()/0.5)
local vertex
for _,target in ipairs(state.chromaTargets) do
local part,mesh=target.object,target.mesh
if off then
-- (/chromatoggle off: every chroma part shows its own plain color again)
if target.decal then part.Color3=target.original else part.Color=target.original end
if mesh then mesh.VertexColor=Vector3.new(1,1,1) end
elseif target.light then part.Color=LIGHT_COLORS[(step+target.light)%#LIGHT_COLORS+1]
elseif target.decal then part.Color3=color
elseif mesh then
if part.Color~=WHITE then part.Color=WHITE end
vertex=vertex or Vector3.new(color.R,color.G,color.B)
mesh.VertexColor=vertex
else part.Color=color end
end
end
local function hideObject(object,state,property,value,original)
local record=state.originals[object]
if not record then
record={property=property,value=original==nil and object[property] or original}
state.originals[object]=record
record.connection=object:GetPropertyChangedSignal(property):Connect(function()
if not record.writing and state.model and state.model.Parent and object[property]~=value then
record.writing=true;object[property]=value;record.writing=false
end
end)
end
if object[property]~=value then
record.writing=true;object[property]=value;record.writing=false
end
end
local PLAIN_SHOT={Color=ColorSequence.new(Color3.new(1,1,1)),Texture="",LightEmission=0.5,TextureLength=1,
TextureMode=Enum.TextureMode.Stretch,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.202,0.95),NumberSequenceKeypoint.new(1,0.6)})}
local function plainShot(beam,state)
state.nativeBeams=state.nativeBeams or {}
if not state.nativeBeams[beam] then
local saved={}
for key in pairs(PLAIN_SHOT) do saved[key]=beam[key] end
state.nativeBeams[beam]=saved
end
for key,value in pairs(PLAIN_SHOT) do pcall(function() beam[key]=value end) end
end
local function hideOriginals(tool,state)
if state.nativeDirty==false then return end
state.nativeDirty=false
for _,object in ipairs(tool:GetDescendants()) do
if not owned(object,tool) then
local property,value=nil,nil
if object:IsA("BasePart") then property,value="LocalTransparencyModifier",1
elseif object:IsA("Decal") then property,value="Transparency",1
elseif object:IsA("Beam") and object.Name=="CustomBeam" then
-- (a gun's CustomBeam is what the game draws its shots with: hidden, the shot vanished. It's kept on;
-- with a visual gun that has no shot of its own it's made the plain white shot every other gun fires)
local behavior=env.VisualsV2Runtime.OriginalVisuals.GetGunBehavior(state.entryId)
if not (behavior and behavior.beam) then plainShot(object,state) end
elseif object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam")
or object:IsA("Fire") or object:IsA("Smoke") or object:IsA("Sparkles")
or object:IsA("Light") or (object:IsA("BillboardGui") and object.Name=="CantShoot") then property,value="Enabled",false end
if property then
local original
if not state.originals[object] then
original=object[property]
local effects=env.VisualsV2Runtime.ClientKnifeEffects
if property=="Enabled" and effects then
local value=effects.GetOriginalEnabled(object)
if value~=nil then original=value end
end
end
hideObject(object,state,property,value,original)
end
end
end
end
local function localTool(tool)
return tool.Parent==player.Character or tool.Parent==player:FindFirstChildOfClass("Backpack")
end
local function actualKind(tool)
local kind=weaponKind(tool.Name) or weaponKind(tool:GetAttribute("WeaponType") or tool:GetAttribute("ItemType"))
if kind then return kind end
for _,candidate in ipairs({"Gun","Knife"}) do
local ok,tagged=pcall(function() return tool:HasTag("Weapon_"..candidate) end)
if ok and tagged then return candidate end
local id=tool:GetAttribute("ItemID") or tool:GetAttribute("WeaponID") or tool.Name
if catalog[candidate][tostring(id)] then return candidate end
end
end
local function equippedGrip(tool,handle,state)
local joint=state.gripJoint
if not joint or not joint.Parent or joint.Part1~=handle then
joint=nil
local character=player.Character
local hand=character and (character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm"))
for _,container in pairs({hand,handle}) do
for _,candidate in ipairs(container:GetChildren()) do
if candidate:IsA("JointInstance") and candidate.Name=="RightGrip" and candidate.Part1==handle then
joint=candidate;break
end
end
if joint then break end
end
if state.gripConnection then state.gripConnection:Disconnect();state.gripConnection=nil end
state.gripJoint=joint
if joint and state.onChanged then state.gripConnection=joint:GetPropertyChangedSignal("C1"):Connect(state.onChanged) end
end
return joint and joint.C1 or tool.Grip
end
local function apply(tool,state)
local kind=actualKind(tool)
local settings=kind and kinds[kind]
local entry=settings and catalog[kind][settings.selected]
if not settings or not settings.enabled or not entry or not localTool(tool) then
if state.model or state.hold or state.holdPending then restoreVisuals(state) end
return
end
if tool.Parent~=player.Character then parkVisuals(state);return end
local handle=visualRoot(tool)
if not handle or not handle:IsA("BasePart") then state.blocked="No usable weapon handle";restoreVisuals(state);return end
local nativeAttachment=gripAttachment(handle)
local nativeGrip=state.useToolGrip and equippedGrip(tool,handle,state) or nativeAttachment and nativeAttachment.CFrame or tool.Grip
local signature=cacheKey(entry)..":"..entry.revision
state.entryId=entry.id
if state.applied==signature and state.handle==handle and state.model then
if state.appliedGrip~=nativeGrip then
local delta=nativeGrip*state.appliedGrip:Inverse()
for _,weld in ipairs(state.welds or {}) do weld.C0=delta*weld.C0 end
state.appliedGrip=nativeGrip
end
if state.model.Parent~=player.Character then
state.model.Parent=player.Character
state.nativeDirty=true
hideOriginals(tool,state)
skinStats.reuses=skinStats.reuses+1
end
updateScopeHold(tool,state,entry)
return
end
local template=templateFor(entry)
if not template then
if loading[cacheKey(entry)] and state.model and state.handle==handle then
state.blocked="Loading "..entry.name
if state.model.Parent~=player.Character then state.model.Parent=player.Character;state.nativeDirty=true end
hideOriginals(tool,state)
return
end
state.blocked="Waiting for the original model"
if state.model then restoreVisuals(state) end
return
end
state.blocked=nil
local model=cloneObject(template.model)
if not model then return end
skinStats.clones=skinStats.clones+1
local root=model.PrimaryPart or visualRoot(model)
if not root then model:Destroy(); return end
local origin=root.CFrame
nativeGrip=template.useToolGrip and equippedGrip(tool,handle,state) or nativeAttachment and nativeAttachment.CFrame or tool.Grip
local targetGrip=template.useToolGrip and template.grip or template.attachmentGrip or template.grip
local offset=targetGrip and nativeGrip*targetGrip:Inverse() or CFrame.new()
local partCount=0
local parts={}
local welds={}
for _,part in ipairs(model:GetDescendants()) do
if part:IsA("BasePart") then
local relative=offset*origin:ToObjectSpace(part.CFrame)
part.Anchored=false; part.CanCollide=false; part.CanTouch=false; part.CanQuery=false
part.Massless=true; part.CastShadow=false; part.LocalTransparencyModifier=0
part.CFrame=handle.CFrame*relative
local weld=Instance.new("Weld")
weld.Name="VisualsV2_ClientSkinWeld"
weld.Part0=handle; weld.Part1=part; weld.C0=relative; weld.C1=CFrame.new()
weld.Parent=part
welds[#welds+1]=weld
partCount=partCount+1;parts[#parts+1]=part
end
end
if partCount==0 then model:Destroy(); return end
restoreVisuals(state)
model.Name="VisualsV2_Client"..kind.."Skin"
model:SetAttribute("WeaponID",entry.id)
state.model=model; state.handle=handle; state.applied=signature
state.parts=parts
state.welds=welds
state.appliedGrip=nativeGrip
state.useToolGrip=template.useToolGrip
state.scopeTemplateHold=template.scopeHold
state.chromaTargets=template.chroma and chromaTargets(model,root) or nil
model.Parent=player.Character
updateChroma(state)
hideOriginals(tool,state)
updateScopeHold(tool,state,entry)
end
local function forgetTool(tool)
local state=toolStates[tool]
if not state then return end
toolStates[tool]=nil
if state.gripConnection then state.gripConnection:Disconnect() end
for _,connection in ipairs(state.connections) do connection:Disconnect() end
restoreVisuals(state)
end
local function trackTool(tool)
if not tool:IsA("Tool") or not actualKind(tool) then return end
local state=toolStates[tool]
if not state then
state={originals={},connections={},queued=false}
toolStates[tool]=state
local function changed(object)
if object and owned(object,tool) then return end
state.nativeDirty=true
if state.queued then return end
state.queued=true
task.defer(function()
state.queued=false
if alive and runtimeAlive and toolStates[tool]==state then
if localTool(tool) then
if state.model and state.model.Parent then hideOriginals(tool,state) end
guarded("Apply "..tool.Name,apply,tool,state)
else forgetTool(tool) end
end
end)
end
state.onChanged=changed
state.connections[1]=tool.DescendantAdded:Connect(changed)
state.connections[2]=tool.DescendantRemoving:Connect(changed)
state.connections[3]=tool.AncestryChanged:Connect(function() changed() end)
state.connections[4]=tool:GetPropertyChangedSignal("Grip"):Connect(function() changed() end)
end
guarded("Apply "..tool.Name,apply,tool,state)
end
local holsters={}
local function nativeHolster(character,kind)
if not character then return nil end
local reference=character:FindFirstChild("DisplayRef"..kind)
if reference and reference:IsA("ObjectValue") then
local object=reference.Value
if object and object.Parent and not object:IsA("Tool") and not object:GetAttribute(MARKER)
and visualRoot(object) then return object end
end
for _,name in ipairs({kind,kind.."Display",kind.."Holster"}) do
local object=character:FindFirstChild(name)
if object and not object:IsA("Tool") and not object:GetAttribute(MARKER) and visualRoot(object) then
return object
end
end
end
local function clearHolster(kind)
local state=holsters[kind]
if not state then return end
holsters[kind]=nil
restoreVisuals(state)
end
local function hideHolsterOriginal(state)
local original=state.original
if not original then return end
hideOriginals(original,state)
if original:IsA("BasePart") then
hideObject(original,state,"LocalTransparencyModifier",1)
end
end
local function nativeHolsterGrip(object)
local root=object and visualRoot(object)
if not root then return CFrame.new() end
local attachment=gripAttachment(root) or root:FindFirstChild("Attachment")
return attachment and attachment:IsA("Attachment") and attachment.CFrame or CFrame.new()
end
local function refreshHolsters()
local character=player.Character
local body=character and (character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
or character:FindFirstChild("LowerTorso"))
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
for kind,settings in pairs(kinds) do
local entry=settings.enabled and catalog[kind][settings.selected]
local equipped=false
if character then
for _,tool in ipairs(character:GetChildren()) do
if tool:IsA("Tool") and actualKind(tool)==kind then equipped=true;break end
end
end
if not alive or not runtimeAlive or equipped or not entry or not body or not body:IsA("BasePart")
or not humanoid or humanoid.Health<=0 then
clearHolster(kind)
else
local original=nativeHolster(character,kind)
local state=holsters[kind]
local nativeMount=nativeHolsterGrip(original)
local signature=cacheKey(entry)..":"..entry.revision
local placed=state and state.character==character and state.body==body and state.original==original
and state.model and state.model.Parent==character
local current=placed and state.applied==signature and state.nativeMount==nativeMount
local template=not current and templateFor(entry) or nil
if current then
hideHolsterOriginal(state)
updateChroma(state)
elseif placed and not template and loading[cacheKey(entry)] then
hideHolsterOriginal(state)
else
clearHolster(kind)
local model=template and cloneObject(template.model)
local root=model and (model.PrimaryPart or visualRoot(model))
if model and not root then model:Destroy();model=nil end
if model then
local originalRoot=original and visualRoot(original)
local belt=character:FindFirstChild(kind.."Belt",true)
if belt and (not belt:IsA("Attachment") or not belt.Parent or not belt.Parent:IsA("BasePart")) then belt=nil end
local anchor=originalRoot or belt and belt.Parent or body
local side=kind=="Gun" and 1 or -1
local base=originalRoot and originalRoot.CFrame*nativeMount*template.holsterGrip:Inverse()
or belt and belt.Parent.CFrame*belt.CFrame*template.holsterGrip:Inverse() or body.CFrame
*CFrame.new(side*(body.Size.X*0.5+0.15),-body.Size.Y*0.4,0.15)
*CFrame.Angles(0,0,math.rad(side*35))*template.holsterGrip:Inverse()
local origin=root.CFrame
local parts={}
for _,part in ipairs(model:GetDescendants()) do
if part:IsA("BasePart") then
local position=base*origin:ToObjectSpace(part.CFrame)
part.Anchored=false;part.CanCollide=false;part.CanTouch=false;part.CanQuery=false
part.Massless=true;part.CastShadow=false;part.LocalTransparencyModifier=0
part.CFrame=position
local weld=Instance.new("Weld")
weld.Name="VisualsV2_HolsterWeld"
weld.Part0=anchor;weld.Part1=part
weld.C0=anchor.CFrame:ToObjectSpace(position);weld.C1=CFrame.new()
weld.Parent=part
parts[#parts+1]=part
end
end
for _,object in ipairs(model:GetDescendants()) do
if object:IsA("ParticleEmitter") then object.Rate=object.Rate*0.35
elseif object:IsA("Light") then object.Enabled=false end
end
model.Name="VisualsV2_Client"..kind.."Holster"
model:SetAttribute(MARKER,true)
model:SetAttribute("WeaponID",entry.id)
model:SetAttribute("WeaponType",kind)
state={model=model,body=body,original=original,originals={},applied=signature,
character=character,parts=parts,nativeMount=nativeMount,chromaTargets=template.chroma and chromaTargets(model,root) or nil}
holsters[kind]=state
if original then
state.nativeConnection=original.DescendantAdded:Connect(function() state.nativeDirty=true end)
end
model.Parent=character
hideHolsterOriginal(state)
updateChroma(state)
end
end
end
end
end
refreshTools=function()
if not alive or not runtimeAlive then return end
skinStats.refreshes=skinStats.refreshes+1
if knifeHeld then knifeHeld() end
guarded("Refresh holsters",refreshHolsters)
if not kinds.Gun.enabled and not kinds.Knife.enabled then
for tool in pairs(toolStates) do forgetTool(tool) end
return
end
local seen={}
local function scan(container)
if container then
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and actualKind(tool) then seen[tool]=true;trackTool(tool) end
end
end
end
scan(player.Character)
scan(player:FindFirstChildOfClass("Backpack"))
for tool in pairs(toolStates) do if not seen[tool] then forgetTool(tool) end end
end
updateWatching=function()
if heartbeat then heartbeat:Disconnect(); heartbeat=nil end
if hideFrame then hideFrame:Disconnect(); hideFrame=nil end
refreshTools()
if not alive or not runtimeAlive or (not kinds.Gun.enabled and not kinds.Knife.enabled) then
for tool in pairs(toolStates) do forgetTool(tool) end
for object in pairs(thrown) do clearThrown(object) end
return
end
local elapsed=0
heartbeat=RunService.Heartbeat:Connect(function(dt)
elapsed=elapsed+math.max(tonumber(dt) or 0,0)
if elapsed>=0.75 then elapsed=0; refreshTools() end
end)
local colorAt=0
hideFrame=RunService.RenderStepped:Connect(function()
local now=os.clock()
if now-colorAt<1/30 then return end
colorAt=now
local colorDue=true
for _,state in pairs(holsters) do
if state.model then
if colorDue then updateChroma(state) end
local alpha=state.body.LocalTransparencyModifier
if state.alpha~=alpha then
state.alpha=alpha
for _,part in ipairs(state.parts or {}) do
if part.Parent and part.LocalTransparencyModifier~=alpha then part.LocalTransparencyModifier=alpha end
end
end
end
end
for object,state in pairs(thrown) do
if not object.Parent or not kinds.Knife.enabled then clearThrown(object)
elseif colorDue then updateChroma(state) end
end
for tool,state in pairs(toolStates) do
if state.model and tool.Parent==player.Character then
if colorDue then updateChroma(state) end
for _,part in ipairs(state.parts or {}) do
if part.Parent and part.LocalTransparencyModifier~=0 then part.LocalTransparencyModifier=0 end
end
end
end
end)
end
local nameOverrides={Emptybringer="Emptybringer",EmptybringerChroma="Chroma Emptybringer",molten="Molten"}
local trophyColours={"Bronze","Silver","Gold","Blue","Red","Purple"}
local function displayName(entry,evo)
local name=nameOverrides[entry.id] or entry.name
if entry.data.rarity=="Unique" then
for _,colour in ipairs(trophyColours) do
if entry.id:find(colour,1,true) then
if not name:find(colour,1,true) then name=colour.." "..name end
break
end
end
if entry.id:find("ElderwoodGun",1,true) then name=name:gsub("Elderwood$","Elderwood Revolver") end
if entry.id:find("ElderwoodKnife",1,true) then name=name:gsub("Elderwood$","Elderwood Blade") end
if entry.id:find("SwirlyGun",1,true) then name=name:gsub("Swirly$","Swirly Gun") end
if entry.id:find("SwirlyAxe",1,true) then name=name:gsub("Swirly$","Swirly Axe") end
if entry.id:find("TravelerAxe",1,true) then name=name:gsub("Traveler's$","Traveler's Axe") end
end
local year=tostring(entry.data.year or entry.id:match("(20%d%d)") or "")
local details={}
if year:match("^20%d%d$") then details[#details+1]=year end
if evo then details[#details+1]=tostring(entry.data.rarity) end
if entry.games then details[#details+1]=table.concat(entry.games," & ") end
if #details>0 then name=name.." ("..table.concat(details,", ")..")" end
return name
end
local function category(entry)
if entry.games then return "Scopes (MM2 & MMV)" end
if entry.data.chroma==true then return "Chroma" end
if entry.data.rarity=="Classic" then return "Vintage" end
return entry.data.rarity or "Other"
end
for kind,entries in pairs(catalog) do
for _,entry in pairs(entries) do
entry.label=displayName(entry,tonumber(entry.data.evoindex)~=nil)
entry.category=category(entry)
end
if kinds[kind].selected~=NONE and not entries[kinds[kind].selected] then kinds[kind].selected=NONE end
end
local containerConnections={}
local function scheduleTools()
if not alive or not runtimeAlive or containerConnections.queued then return end
containerConnections.queued=true
task.defer(function()
containerConnections.queued=false
if alive and runtimeAlive then refreshTools() end
end)
end
local function bindContainers()
for key,connection in pairs(containerConnections) do
if key~="queued" then connection:Disconnect();containerConnections[key]=nil end
end
for _,container in pairs({player.Character,player:FindFirstChildOfClass("Backpack")}) do
containerConnections[#containerConnections+1]=container.ChildAdded:Connect(function(object)
if object:IsA("Tool") or object.Name:find("Display",1,true) then scheduleTools() end
end)
containerConnections[#containerConnections+1]=container.ChildRemoved:Connect(function(object)
if object:IsA("Tool") or object.Name:find("Display",1,true) then scheduleTools() end
end)
if container==player.Character then
containerConnections[#containerConnections+1]=container.DescendantAdded:Connect(function(object)
if object.Name=="RightGrip" or object:IsA("Humanoid") or object:IsA("Animator") then scheduleTools() end
end)
end
end
scheduleTools()
end
connections[#connections+1]=player.CharacterAdded:Connect(bindContainers)
connections[#connections+1]=player.ChildAdded:Connect(function(child)
if child:IsA("Backpack") then bindContainers() end
end)
local lastKnife
local lastHeldAt=-math.huge
local function knifeTool()
for _,container in ipairs({player.Character or false,player:FindFirstChildOfClass("Backpack") or false}) do
if container then
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and actualKind(tool)=="Knife" then
lastKnife=tool
if container==player.Character then lastHeldAt=os.clock() end
return tool
end
end
end
end
end
knifeHeld=knifeTool
local function meshesOf(root)
local found,count={},0
local objects=root:GetDescendants()
table.insert(objects,1,root)
for index,object in ipairs(objects) do
if index>80 then break end
if not owned(object,root) and (object:IsA("MeshPart") or object:IsA("SpecialMesh")) then
local id=assetId(object.MeshId)
if id then found[id]=true;count=count+1 end
end
end
return found,count
end
clearThrown=function(object)
local state=thrown[object]
if not state then return end
thrown[object]=nil
if state.removed then state.removed:Disconnect() end
restoreVisuals(state)
end
local function skinThrown(object)
local entry=kinds.Knife.enabled and catalog.Knife[kinds.Knife.selected]
if not entry or not alive or not runtimeAlive or thrown[object] or not object.Parent or object:GetAttribute(MARKER) then return end
local character=player.Character
local body=character and character:FindFirstChild("HumanoidRootPart")
if not body then return end
local handle=visualRoot(object)
if not handle or not handle:IsA("BasePart") or (handle.Position-body.Position).Magnitude>20 then return end
local tool=knifeTool() or (lastKnife and lastKnife.Parent and lastKnife) or nil
if not tool or tool.Parent~=character and os.clock()-lastHeldAt>3 then return end
for _,other in ipairs(Players:GetPlayers()) do
if other.Character and object:IsDescendantOf(other.Character) then return end
end
local displays=workspace:FindFirstChild("WeaponDisplays")
if displays and object:IsDescendantOf(displays) then return end
if object~=tool then
local native=meshesOf(tool)
local found,count=meshesOf(object)
if count==0 then return end
for id in pairs(found) do if not native[id] then return end end
end
local template=templateFor(entry)
if not template then return end
local model=cloneObject(template.model)
local root=model and (model.PrimaryPart or visualRoot(model))
if not root then if model then model:Destroy() end;return end
local held=toolStates[tool]
local nativeHandle=visualRoot(tool)
local nativeAttachment=nativeHandle and nativeHandle:IsA("BasePart") and gripAttachment(nativeHandle) or gripAttachment(handle)
local nativeGrip=held and held.appliedGrip or template.useToolGrip and tool.Grip or nativeAttachment and nativeAttachment.CFrame or tool.Grip
local targetGrip=template.useToolGrip and template.grip or template.attachmentGrip or template.grip
local offset=targetGrip and nativeGrip*targetGrip:Inverse() or CFrame.new()
local origin=root.CFrame
local parts={}
for _,part in ipairs(model:GetDescendants()) do
if part:IsA("BasePart") then
local relative=offset*origin:ToObjectSpace(part.CFrame)
part.Anchored=false;part.CanCollide=false;part.CanTouch=false;part.CanQuery=false
part.Massless=true;part.CastShadow=false;part.LocalTransparencyModifier=0
part.CFrame=handle.CFrame*relative
local weld=Instance.new("Weld")
weld.Name="VisualsV2_ClientSkinWeld"
weld.Part0=handle;weld.Part1=part;weld.C0=relative;weld.C1=CFrame.new()
weld.Parent=part
parts[#parts+1]=part
end
end
if #parts==0 then model:Destroy();return end
model.Name="VisualsV2_ClientThrownKnife"
model:SetAttribute("WeaponID",entry.id)
local state={originals={},connections={},model=model,parts=parts,handle=handle,
chromaTargets=template.chroma and chromaTargets(model,root) or nil}
thrown[object]=state
model.Parent=handle
updateChroma(state)
hideOriginals(object,state)
for _,record in pairs(state.originals) do
if record.property=="LocalTransparencyModifier" then record.value=0 end
end
state.removed=object.AncestryChanged:Connect(function(_,parent)
local backpack=player:FindFirstChildOfClass("Backpack")
if parent==nil or player.Character and object:IsDescendantOf(player.Character)
or backpack and object:IsDescendantOf(backpack) then clearThrown(object) end
end)
skinStats.thrown=(skinStats.thrown or 0)+1
end
connections[#connections+1]=workspace.DescendantAdded:Connect(function(object)
if not kinds.Knife.enabled or not (object:IsA("BasePart") or object:IsA("Model") or object:IsA("Tool")) then return end
local parent=object.Parent
if not (parent==workspace or parent==workspace.CurrentCamera or parent and parent:IsA("Folder")) then return end
task.defer(function()
local ok,reason=pcall(skinThrown,object)
if not ok then recordError("Thrown knife",reason) end
end)
end)
local replicatedStorage=game:GetService("ReplicatedStorage")
-- (the game adds the item to ReplicatedStorage when you add it to a trade, and a listener on all of
-- ReplicatedStorage froze the game then: it's only connected while a skin is chosen, never during a trade)
local storageWatch=nil
local function storageWatched(object)
if object:IsA("Animation") then storageScopeScanned=false end
local wantedGun=kinds.Gun.enabled and catalog.Gun[kinds.Gun.selected]
local wantedKnife=kinds.Knife.enabled and catalog.Knife[kinds.Knife.selected]
if not wantedGun and not wantedKnife then return end
local ancestor=object
while ancestor and ancestor~=replicatedStorage do
if ancestor:GetAttribute(MARKER) then return end
local name=ancestor.Name
local plain=compact(name)
local item=ancestor:GetAttribute("ItemID") or ancestor:GetAttribute("WeaponID")
for _,entry in ipairs({wantedGun or false,wantedKnife or false}) do
if entry and (plain==compact(entry.id) or name==entry.name
or name==assetId(entry.data.itemid) or (item and tostring(item)==entry.id)) then
failed[cacheKey(entry)]=nil
task.defer(function() if alive and runtimeAlive then refreshTools() end end)
return
end
end
ancestor=ancestor.Parent
end
end
local function syncStorageWatch()
local trade=env.VisualsV2Runtime.Trade
local wanted=alive and runtimeAlive and not (trade and trade.active)
and ((kinds.Gun.enabled and catalog.Gun[kinds.Gun.selected]) or (kinds.Knife.enabled and catalog.Knife[kinds.Knife.selected])) and true or false
if wanted and not storageWatch then
storageWatch=replicatedStorage.DescendantAdded:Connect(storageWatched)
elseif not wanted and storageWatch then
storageWatch:Disconnect();storageWatch=nil
end
end
do
local trade=env.VisualsV2Runtime.Trade
if trade and type(trade.OnChanged)=="function" then trade.OnChanged(function() pcall(syncStorageWatch) end) end
end
syncStorageWatch()
env.VisualsV2Runtime.ClientWeaponSkins={
Catalog=catalog,
Changed=changes.Event,
GetKind=actualKind,
GetVisualRoot=visualRoot,
GetModel=function(tool)
local state=toolStates[tool]
return state and state.model
end,
GetMuzzle=function(tool)
local state=toolStates[tool]
local model=state and state.model
return model and model.Parent and model:FindFirstChild("VisualsV2_Muzzle",true) or nil
end,
GetNativeHolster=function(kind) return nativeHolster(player.Character,kind) end,
GetDiagnostics=function()
local report={build="2026-10-25-v2-1",stats=table.clone(skinStats),errors=table.clone(recentErrors),weapons={}}
for kind,settings in pairs(kinds) do
local entry=catalog[kind][settings.selected]
local key=entry and cacheKey(entry)
local cached=key and cache[key]
local failure=key and failed[key]
local item={enabled=settings.enabled,selected=settings.selected,assetId=entry and entry.data.itemid,
loading=key and loading[key] or false,templateReady=cached~=nil,
source=cached and cached.source,error=failure and failure.reason,
attempts=failure and failure.attempts or cached and cached.attempts or {},tools={}}
for tool,value in pairs(toolStates) do
if actualKind(tool)==kind then
item.tools[#item.tools+1]={path=objectPath(tool),name=tool.Name,
equipped=tool.Parent==player.Character,rendered=value.model and value.model.Parent~=nil or false,
handle=objectPath(visualRoot(tool)),blocked=value.blocked,holdError=value.holdError,
holdAnimation=value.hold and (value.hold.pose and "R6 scope pose"
or value.hold.track and value.hold.track.Animation and value.hold.track.Animation.AnimationId) or nil}
end
end
local holster=holsters[kind]
item.holster=holster and {path=objectPath(holster.model),body=objectPath(holster.body),
original=objectPath(holster.original),parts=#(holster.parts or {})} or nil
report.weapons[kind]=item
end
return report
end,
GetHolster=function(kind)
local state=holsters[kind]
return state and state.model
end,
SetEnabled=function(kind,value)
local state=kinds[kind]
if not state then return false end
state.enabled=value==true and (not mmv or kind=="Gun")
SetCfg(state.key.."Enabled",state.enabled)
updateWatching()
syncStorageWatch()
changes:Fire(kind)
return true
end,
Select=function(kind,id)
local state=kinds[kind]
if not state or (id~=NONE and not catalog[kind][id]) then return false end
state.selected=id
local entry=catalog[kind][id]
if entry then failed[cacheKey(entry)]=nil end
SetCfg(state.key.."Skin",id)
refreshTools()
syncStorageWatch()
changes:Fire(kind)
return true
end,
GetState=function(kind)
local state=kinds[kind]
if state then return state.enabled,state.selected end
end,
Refresh=function() refreshTools() end,
GetOriginalEnabled=function(object)
for _,states in ipairs({toolStates,holsters}) do
for _,state in pairs(states) do
local record=state.originals[object]
if record and record.property=="Enabled" then return record.value end
end
end
end,
IsHidden=function(object)
for _,states in ipairs({toolStates,holsters}) do
for _,state in pairs(states) do
local record=state.originals[object]
if state.model and record and record.property=="Enabled" then return true end
end
end
return false
end,
GetCounts=function()
local counts={Gun=0,Knife=0}
for kind,entries in pairs(catalog) do for _ in pairs(entries) do counts[kind]=counts[kind]+1 end end
return counts
end,
}
env.VisualsV2Runtime.RegisterReset(function()
for _,state in pairs(kinds) do
state.enabled=false; state.selected=NONE
SetCfg(state.key.."Enabled",false)
SetCfg(state.key.."Skin",NONE)
end
updateWatching()
syncStorageWatch()
if not runtimeAlive then
alive=false
for key,connection in pairs(containerConnections) do if key~="queued" then connection:Disconnect() end end
changes:Destroy()
for _,connection in ipairs(connections) do connection:Disconnect() end
for kind in pairs(holsters) do clearHolster(kind) end
for object in pairs(thrown) do clearThrown(object) end
for _,template in pairs(cache) do template.model:Destroy() end
table.clear(cache)
table.clear(nativeScopeHolds)
end
end)
bindContainers()
updateWatching()
end,"Part at line 9860")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local effectList={
{id="Abduction2025",name="Abduction",label="Abduction (2025)"},
{id="Aquatic2025",name="Aquatic",label="Aquatic (2025)"},
{id="Arctic2022",name="Arctic",label="Arctic (2022)"},
{id="Aurora2021",name="Aurora",label="Aurora (2021)"},
{id="Aurora2024",name="Aurora Lights",label="Aurora Lights (2024)"},
{id="Bats",name="Bats",label="Bats"},
{id="Bats2020",name="Batswarm",label="Batswarm (2020)"},
{id="Bats2024",name="Bat Swarm",label="Bat Swarm (2024)"},
{id="Bitsplosion",name="Bitsplosion",label="Bitsplosion"},
{id="Blizzard",name="Blizzard",label="Blizzard"},
{id="Bloom2025",name="Bloom",label="Bloom (2025)"},
{id="BlueFire",name="Blue Flaming Knife",label="Blue Flaming Knife"},
{id="Bokeh2025",name="Bokeh",label="Bokeh (2025)"},
{id="Bubbly26",name="Bubbly",label="Bubbly (2026)"},
{id="Burn",name="Flaming Knife",label="Flaming Knife"},
{id="Candies",name="Candies",label="Candies (2019)"},
{id="CandyCane",name="Candy Cane",label="Candy Cane"},
{id="CandyEffect2022",name="Candies",label="Candies (2022)"},
{id="CandyEffect2023",name="Candies",label="Candies (2023)"},
{id="Carrots2025",name="Carrots",label="Carrots (2025)"},
{id="Cats2025",name="Cat Eyes",label="Cat Eyes (2025)"},
{id="Chilly2022",name="Chilly",label="Chilly (2022)"},
{id="Coal2025",name="Coal",label="Coal (2025)"},
{id="CommonOrnamentEffect",name="Common Ornament",label="Common Ornament (2018)"},
{id="Confetti2025",name="Confetti",label="Confetti (2025)"},
{id="Cursed2024",name="Cursed",label="Cursed (2024)"},
{id="Darkfire",name="Darkfire",label="Darkfire"},
{id="Darkswirl",name="Darkswirl",label="Darkswirl (2023)"},
{id="Doge",name="Doge",label="Doge"},
{id="EasterGlow2023",name="Easter Glow",label="Easter Glow (2023)"},
{id="Electric",name="Electric Knife",label="Electric Knife"},
{id="Elitify",name="Elite-ify",label="Elite-ify"},
{id="Ethereal",name="Ethereal",label="Ethereal"},
{id="Fireworks2023",name="Fireworks",label="Fireworks (2023)"},
{id="FlamingoEffect2025",name="Flamingo",label="Flamingo (2025)"},
{id="Floral2023",name="Floral",label="Floral (2023)"},
{id="Flowers2024",name="Flowers",label="Flowers (2024)"},
{id="Flowerwood",name="Flowerwood",label="Flowerwood"},
{id="Frost2025",name="Frost",label="Frost (2025)"},
{id="FrostbiteEffect",name="Frostbite",label="Frostbite"},
{id="Frostfire2020",name="Frostfire",label="Frostfire (2020)"},
{id="GearStorm",name="Gear Storm",label="Gear Storm"},
{id="Ghostify",name="Ghostify",label="Ghostify"},
{id="Ghosts2020",name="Ghosts",label="Ghosts (2020)"},
{id="Ghosts2023",name="Ghosts",label="Ghosts (2023)"},
{id="Ghosts2024",name="Ghosts",label="Ghosts (2024)"},
{id="Gifts2024",name="Gifts",label="Gifts (2024)"},
{id="GingerbreadEffect",name="Gingerbread",label="Gingerbread"},
{id="Glisten2024",name="Glisten",label="Glisten (2024)"},
{id="Glowy2023",name="Glowy",label="Glowy (2023)"},
{id="GreenFire",name="Green Flaming Knife",label="Green Flaming Knife"},
{id="HallowsBlaze",name="Hallow's Blaze",label="Hallow's Blaze"},
{id="Heartify",name="Heartify",label="Heartify"},
{id="Hearts26",name="Hearts",label="Hearts (2026)"},
{id="Heatwave2025",name="Heatwave",label="Heatwave (2025)"},
{id="IceMagic",name="Ice Magic",label="Ice Magic"},
{id="Jellyfish2024",name="Jellyfish",label="Jellyfish (2024)"},
{id="Jingle2020",name="Jingle",label="Jingle (2020)"},
{id="Knifeception",name="Knifeception",label="Knifeception"},
{id="Leaves2025",name="Leaves",label="Leaves (2025)"},
{id="LegendaryOrnamentEffect",name="Legendary Ornament",label="Legendary Ornament (2018)"},
{id="Lights2025",name="Lights",label="Lights (2025)"},
{id="Matrix2024",name="Matrix",label="Matrix (2024)"},
{id="Minty2022",name="Minty",label="Minty (2022)"},
{id="Money",name="Monify",label="Monify"},
{id="Musical",name="Musical",label="Musical"},
{id="Nightlife26",name="Nightlife",label="Nightlife (2026)"},
{id="Nightsky2025",name="Nightsky",label="Nightsky (2025)"},
{id="NorthernLights",name="Northern Lights",label="Northern Lights (2018)"},
{id="Petals",name="Petals",label="Petals"},
{id="Phantom",name="Phantom",label="Phantom"},
{id="PhantomEffect2022",name="Ghostly",label="Ghostly (2022)"},
{id="PinkFire",name="Pink Flaming Knife",label="Pink Flaming Knife"},
{id="PlasmaEffect",name="Plasma",label="Plasma"},
{id="Poison",name="Poison",label="Poison"},
{id="Pumpkin",name="Pumpkin",label="Pumpkin"},
{id="Pumpkin2022",name="Pumpkin",label="Pumpkin (2022)"},
{id="Radioactive",name="Radioactive",label="Radioactive"},
{id="Rainbow",name="Rainbow Fire",label="Rainbow Fire"},
{id="RainbowEffect",name="Rainbow",label="Rainbow"},
{id="Rainbows2025",name="Rainbows",label="Rainbows (2025)"},
{id="RareOrnamentEffect",name="Rare Ornament",label="Rare Ornament (2018)"},
{id="Retro2025",name="Retro",label="Retro (2025)"},
{id="Snowballs2025",name="Snowballs",label="Snowballs (2025)"},
{id="Snowfall2020",name="Snowfall",label="Snowfall (2020)"},
{id="Snowflake2021",name="Snowflake",label="Snowflake (2021)"},
{id="Snowflakes",name="Snowflakes",label="Snowflakes"},
{id="Snowflakes2",name="Snowflakes 2017",label="Snowflakes 2017"},
{id="Snowstorm2024",name="Snowy",label="Snowy (2024)"},
{id="Snowstorm2025",name="Snowstorm",label="Snowstorm (2025)"},
{id="Starry2021",name="Starry",label="Starry (2021)"},
{id="Starry2024",name="Celestial",label="Celestial (2024)"},
{id="Stars2023",name="Stars",label="Stars (2023)"},
{id="StickersX2022",name="Stickers",label="Stickers (2022)"},
{id="Strawberries26",name="Strawberries",label="Strawberries (2026)"},
{id="Sunbeams2024",name="Sunbeams",label="Sunbeams (2024)"},
{id="SweetEffect26",name="Pixie Dust",label="Pixie Dust (2026)"},
{id="Swirls2023",name="Swirls",label="Swirls (2023)"},
{id="SynthEffect2025",name="Synthwave",label="Synthwave (2025)"},
{id="Toxic2022",name="Toxic",label="Toxic (2022)"},
{id="Traveler2023",name="Traveler's Flame",label="Traveler's Flame (2023)"},
{id="Treats2025",name="Treats",label="Treats (2025)"},
{id="UFOs2025",name="UFOs",label="UFOs (2025)"},
{id="UncommonOrnamentEffect",name="Uncommon Ornament",label="Uncommon Ornament (2018)"},
{id="Vampire2020",name="Vampire",label="Vampire (2020)"},
{id="Vampiric2024",name="Vampiric",label="Vampiric (2024)"},
{id="VersusEffect2022",name="Versus",label="Versus (2022)"},
{id="VoidRbxEffect",name="Void",label="Void"},
{id="Water2023",name="Flow",label="Flow (2023)"},
{id="Wraith2024",name="Wraith",label="Wraith (2024)"},
{id="Wraithfire",name="Wraithfire",label="Wraithfire"},
{id="Wrapper",name="Knife Wrapper",label="Knife Wrapper"},
{id="XenoEffect",name="Xeno",label="Xeno (2025)"},
{id="XmasGlow2025",name="Christmas Glow",label="Christmas Glow (2025)"},
{id="CauldronEffect26",name="Cauldron",label="Cauldron (2026)"},
{id="Darkwave26",name="Darkwave",label="Darkwave (2026)"},
{id="Flameburst26",name="Flameburst",label="Flameburst (2026)"},
{id="Jack26",name="Jack",label="Jack (2026)"},
{id="Pumpkins26",name="Pumpkins",label="Pumpkins (2026)"},
{id="Smolder2026",name="Smolder",label="Smolder (2026)"},
{id="Zombie26",name="Zombie",label="Zombie (2026)"},
{id="Ghostly26",name="Ghostly",label="Ghostly (2026)"},
{id="Ocean26",name="Ocean",label="Ocean (2026)"},
}
-- (discarded, so they're never offered: Dual (excluded by request); the death effects of Heartify and
-- Monify, which MMV doesn't play so they couldn't be captured (their knife effects are kept); and the
-- Balloons, Feathers and Pink Flowerwood effects, which no account owned so they couldn't be captured)
local mmv=game.GameId==10413186812 or game.GameId==10769671266 or game.PlaceId==93017634738276 or game.PlaceId==81374640397860
local enabled=not mmv and env.VisualsV2Runtime.WeaponsUnlocked() and C("vv2KnifeEffectsEnabled",false)
local selected=tostring(C("vv2KnifeEffect","None"))
local alive=true
local heartbeat=nil
local storageConnection=nil
local states={}
local warned={}
local nextAttempt=0
local lastError=nil
local errorSeen={}
local template=nil
local templateId=nil
local MARKER="VisualsV2_ClientKnifeEffect"
local SKIN_MARKER="VisualsV2_ClientWeaponSkin"
local storage=game:GetService("ReplicatedStorage")
local byId={}
local visuals={ParticleEmitter=true,Trail=true,Beam=true,Fire=true,Smoke=true,Sparkles=true,
PointLight=true,SpotLight=true,SurfaceLight=true,BillboardGui=true}
local originals=env.VisualsV2Runtime.OriginalVisuals
for _,entry in ipairs(effectList) do
if entry.id~="Dual" and originals and originals.HasEffect(entry.id) then
entry.data=originals.Metadata.Effects[entry.id] or {}
entry.name=entry.data.name or entry.name
byId[entry.id]=entry
end
end
if selected~="None" and not byId[selected] then selected="None" end
local function own(object,tool)
while object and object~=tool do
if object:GetAttribute(MARKER) then return true end
object=object.Parent
end
return false
end
local function mark(object)
object:SetAttribute(MARKER,true)
object:SetAttribute(SKIN_MARKER,true)
end
local function clear(tool)
local state=states[tool]
if not state then return end
states[tool]=nil
for _,object in ipairs(state.outputs) do pcall(function() object:Destroy() end) end
local skins=env.VisualsV2Runtime.ClientWeaponSkins
for object,value in pairs(state.textures or {}) do
pcall(function() object[value.property]=value.value end)
end
for object,value in pairs(state.originals) do
if not skins or not skins.IsHidden or not skins.IsHidden(object) then
pcall(function() object.Enabled=value end)
end
end
end
local function clearAll()
for tool in pairs(states) do clear(tool) end
end
local function blade(tool)
if tool:IsA("Model") and tool.PrimaryPart then return tool.PrimaryPart end
if tool:IsA("BasePart") then return tool end
local skins=env.VisualsV2Runtime.ClientWeaponSkins
local skin=skins and skins.GetModel and skins.GetModel(tool) or tool:FindFirstChild("VisualsV2_ClientKnifeSkin")
if skin and skin:IsA("Model") and skin.PrimaryPart then return skin.PrimaryPart end
local skins=env.VisualsV2Runtime.ClientWeaponSkins
if skins and skins.GetVisualRoot then return skins.GetVisualRoot(tool) end
local handle=tool:FindFirstChild("Handle",true)
return handle and handle:IsA("BasePart") and handle or nil
end
local function hasVisuals(object)
if visuals[object.ClassName] then return true end
for _,child in ipairs(object:GetDescendants()) do if visuals[child.ClassName] then return true end end
return false
end
local function findTemplate()
if templateId==selected and template and template.Parent then return template end
if os.clock()<nextAttempt then return nil end
nextAttempt=math.huge
local entry=byId[selected]
if not entry then return nil end
local originals=env.VisualsV2Runtime.OriginalVisuals
local captured=originals and originals.GetEffect(selected)
if captured then template=captured;templateId=selected;return template end
local candidates={}
local function candidate(object)
if object and not own(object,storage) and hasVisuals(object) then candidates[#candidates+1]=object end
end
for _,containerName in ipairs({"Effects","KnifeEffects","WeaponEffects","EffectModels","KnifeFX"}) do
local container=storage:FindFirstChild(containerName,true)
if container then
candidate(container:FindFirstChild(entry.id,true))
candidate(container:FindFirstChild(entry.name,true))
end
end
candidate(storage:FindFirstChild(entry.id,true))
if candidates[1] then template=candidates[1];templateId=selected;return template end
return nil
end
local function cloneVisuals(source,handle)
local archivable=source.Archivable
pcall(function() source.Archivable=true end)
local ok,clone=pcall(function() return source:Clone() end)
pcall(function() source.Archivable=archivable end)
if not ok or not clone then return nil end
local sourcePart=clone:IsA("BasePart") and clone or clone:FindFirstChildWhichIsA("BasePart",true)
local origin=sourcePart and sourcePart.CFrame or CFrame.new()
local outputs={}
local count=0
local function mount(object,offset)
if object:IsA("BasePart") then
local relative=origin:ToObjectSpace(object.CFrame)
for _,child in ipairs(object:GetChildren()) do mount(child,relative) end
object:Destroy()
elseif object:IsA("Attachment") then
object.CFrame=offset*object.CFrame
for _,child in ipairs(object:GetDescendants()) do
if visuals[child.ClassName] then
child.Enabled=true
count=count+1
elseif not child:IsA("Attachment") and not child:IsA("GuiObject") then child:Destroy() end
end
mark(object)
object.Parent=handle
outputs[#outputs+1]=object
elseif visuals[object.ClassName] then
if not object:IsA("BillboardGui") then
for _,child in ipairs(object:GetChildren()) do child:Destroy() end
end
mark(object)
object.Enabled=true
if object:IsA("ParticleEmitter") and offset~=CFrame.new() then
local attachment=Instance.new("Attachment")
attachment.Name="VisualsV2_KnifeEffectOffset"
attachment.CFrame=offset
mark(attachment)
object.Parent=attachment
attachment.Parent=handle
outputs[#outputs+1]=attachment
else
object.Parent=handle
outputs[#outputs+1]=object
end
count=count+1
else
for _,child in ipairs(object:GetChildren()) do
if object:IsA("Model") or object:IsA("Folder") or object:IsA("ModuleScript") then
mount(child,offset)
else child:Destroy() end
end
object:Destroy()
end
end
local mounted=pcall(mount,clone,CFrame.new())
count=0
for _,object in ipairs(outputs) do
if visuals[object.ClassName] then count=count+1 end
for _,child in ipairs(object:GetDescendants()) do
if visuals[child.ClassName] then count=count+1 end
end
end
if not mounted or count==0 then
for _,object in ipairs(outputs) do pcall(function() object:Destroy() end) end
pcall(function() clone:Destroy() end)
return nil
end
return outputs
end
local function hideNative(tool,state)
for _,object in ipairs(tool:GetDescendants()) do
if visuals[object.ClassName] and not own(object,tool) then
if state.originals[object]==nil then
local original=object.Enabled
local skins=env.VisualsV2Runtime.ClientWeaponSkins
if skins and skins.GetOriginalEnabled then
local value=skins.GetOriginalEnabled(object)
if value~=nil then original=value end
end
state.originals[object]=original
end
if object.Enabled then object.Enabled=false end
end
end
end
local function attached(state)
for _,object in ipairs(state.outputs) do
if not object.Parent or not object:IsDescendantOf(state.handle) then return false end
end
return true
end
local function update()
if not alive or not runtimeAlive or not enabled or selected=="None" then clearAll();return end
local character=LocalPlayer.Character
if not character then clearAll();return end
local humanoid=character:FindFirstChildOfClass("Humanoid")
if humanoid and humanoid.Health<=0 then clearAll();return end
local targets={}
local skins=env.VisualsV2Runtime.ClientWeaponSkins
for _,tool in ipairs(character:GetChildren()) do
if tool:IsA("Tool") then
local kind=skins and skins.GetKind and skins.GetKind(tool)
if kind=="Knife" or tool.Name:lower()=="knife" then targets[#targets+1]=tool end
end
end
local holster=skins and skins.GetHolster and skins.GetHolster("Knife")
if #targets==0 and not holster and skins and skins.GetNativeHolster then holster=skins.GetNativeHolster("Knife") end
if #targets==0 and not holster then
for _,name in ipairs({"Knife","KnifeDisplay","KnifeHolster"}) do
local object=character:FindFirstChild(name)
if object and not object:IsA("Tool") then holster=object;break end
end
end
if holster and holster.Parent then targets[#targets+1]=holster end
local seen={}
for _,tool in ipairs(targets) do seen[tool]=true end
for tool,state in pairs(states) do
if not seen[tool] or state.handle~=blade(tool) or state.id~=selected or not attached(state) then clear(tool) end
end
for _,tool in ipairs(targets) do
if tool.Parent and seen[tool] then
local handle=blade(tool)
if handle then
local state=states[tool]
if not state then
local source=findTemplate()
local outputs=source and cloneVisuals(source,handle)
local info=originals and originals.GetEffectInfo(selected)
if not outputs and info and info.texture then outputs={} end
if outputs then
state={id=selected,handle=handle,outputs=outputs,originals={},textures={}}
-- (Rainbow Fire: the game cycles its fire through the whole rainbow, about once every 6 s, with a black
-- secondary color; the recorded copy is one frozen color, so it's cycled here)
if selected=="Rainbow" then
state.rainbow={}
for _,output in ipairs(outputs) do
local objects={output}
for _,object in ipairs(output:GetDescendants()) do objects[#objects+1]=object end
for _,object in ipairs(objects) do
if object:IsA("Fire") then state.rainbow[#state.rainbow+1]=object end
end
end
end
if info and info.texture then
local target=handle.Parent and handle.Parent:GetAttribute(SKIN_MARKER) and handle.Parent or handle
local objects={target}
for _,object in ipairs(target:GetDescendants()) do objects[#objects+1]=object end
for _,object in ipairs(objects) do
local property=object:IsA("MeshPart") and "TextureID" or object:IsA("SpecialMesh") and "TextureId"
if property then
state.textures[object]={property=property,value=object[property]}
object[property]=info.texture
end
end
end
states[tool]=state
lastError=nil
elseif not warned[selected] then
warned[selected]=true
lastError="No usable original effect template is available for "..byId[selected].label
pcall(shared.Notify,"Visual Weapons/Effects: "..lastError..".",1)
if type(warn)=="function" then warn("[VisualsV2 Effects] "..lastError) end
end
end
if state then hideNative(tool,state) end
end
end
end
end
local function safeUpdate()
local ok,reason=xpcall(update,function(value)
return type(debug)=="table" and type(debug.traceback)=="function" and debug.traceback(tostring(value),2) or tostring(value)
end)
if not ok then
lastError=tostring(reason)
if not errorSeen[lastError] then
errorSeen[lastError]=true
if type(warn)=="function" then warn("[VisualsV2 Effects] "..lastError) end
end
end
end
local function storageWatched(object)
if not alive or not runtimeAlive or not enabled or selected=="None" then return end
local entry=byId[selected]
local ancestor=object
while ancestor and ancestor~=storage do
if ancestor:GetAttribute(MARKER) or ancestor:GetAttribute(SKIN_MARKER) then return end
if ancestor.Name==entry.id or ancestor.Name==entry.name then
nextAttempt=0
task.defer(function() if alive and runtimeAlive and enabled then safeUpdate() end end)
return
end
ancestor=ancestor.Parent
end
end
-- (only connected while an effect is chosen, and never during a trade: see the weapon skins)
local function syncStorageWatch()
local trade=env.VisualsV2Runtime.Trade
local wanted=alive and runtimeAlive and enabled and selected~="None" and not (trade and trade.active)
if wanted and not storageConnection then
storageConnection=storage.DescendantAdded:Connect(storageWatched)
elseif not wanted and storageConnection then
storageConnection:Disconnect();storageConnection=nil
end
end
do
local trade=env.VisualsV2Runtime.Trade
if trade and type(trade.OnChanged)=="function" then trade.OnChanged(function() pcall(syncStorageWatch) end) end
end
local function refresh()
if heartbeat then heartbeat:Disconnect();heartbeat=nil end
clearAll()
syncStorageWatch()
if not alive or not runtimeAlive or not enabled or selected=="None" then return end
nextAttempt=0
safeUpdate()
local elapsed=0
heartbeat=RunService.Heartbeat:Connect(function(dt)
elapsed=elapsed+dt
if elapsed>=0.25 then elapsed=0;safeUpdate() end
local hue=(os.clock()/6)%1
for _,state in pairs(states) do
if state.rainbow then
local color=Color3.fromHSV(hue,1,1)
for _,fire in ipairs(state.rainbow) do
if fire.Parent then fire.Color=color;fire.SecondaryColor=Color3.new(0,0,0) end
end
end
end
end)
end
env.VisualsV2Runtime.ClientKnifeEffects={
Catalog=byId,
SetEnabled=function(value)
enabled=value==true and not mmv
SetCfg("vv2KnifeEffectsEnabled",enabled)
refresh()
return true
end,
Select=function(id)
if id~="None" and not byId[id] then return false end
selected=id
lastError=nil
warned[id]=nil
SetCfg("vv2KnifeEffect",id)
template=nil;templateId=nil;nextAttempt=0
refresh()
return true
end,
GetState=function() return enabled,selected end,
Refresh=function() refresh() end,
GetOriginalEnabled=function(object)
for _,state in pairs(states) do
if state.originals[object]~=nil then return state.originals[object] end
end
end,
IsSuppressed=function(object)
for _,state in pairs(states) do if state.originals[object]~=nil then return true end end
return false
end,
}
env.VisualsV2Runtime.RegisterReset(function()
enabled=false
selected="None"
SetCfg("vv2KnifeEffectsEnabled",false)
SetCfg("vv2KnifeEffect","None")
refresh()
if not runtimeAlive then
alive=false
if storageConnection then storageConnection:Disconnect();storageConnection=nil end
end
end)
refresh()
end,"Part at line 12632")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local runtime=env.VisualsV2Runtime
local effects=runtime.ClientKnifeEffects
local originals=runtime.OriginalVisuals
local MARK="VisualsV2_DeathEffect"
local BODY={HumanoidRootPart=true,Head=true,UpperTorso=true,LowerTorso=true,Torso=true,
LeftUpperArm=true,LeftLowerArm=true,LeftHand=true,RightUpperArm=true,RightLowerArm=true,RightHand=true,
LeftUpperLeg=true,LeftLowerLeg=true,LeftFoot=true,RightUpperLeg=true,RightLowerLeg=true,RightFoot=true,
["Left Arm"]=true,["Right Arm"]=true,["Left Leg"]=true,["Right Leg"]=true}
local FX={ParticleEmitter=true,Fire=true,Smoke=true,Sparkles=true,Sound=true,Beam=true,Trail=true,PointLight=true,SpotLight=true}
local CHARACTER_SOUNDS={Climbing=true,Died=true,FreeFalling=true,GettingUp=true,Jumping=true,Landing=true,Running=true,Splash=true,Swimming=true}
local enabled=true
local alive=true
local deaths={}
local playerConnections={}
local connections={}
local function chosen()
if not enabled or not effects or not originals or type(originals.GetDeathEffect)~="function" then return nil end
local on,id=effects.GetState()
if not on or not id or id=="None" then return nil end
if type(originals.HasDeathEffect)=="function" and not originals.HasDeathEffect(id) then return nil end
return id
end
local function killerOf(character)
for _,name in ipairs({"Creator2","creator","Creator","Killer","KilledBy"}) do
local tag=character:FindFirstChild(name,true)
if tag and tag:IsA("ObjectValue") then return tag.Value end
end
end
local function suppressNative(model)
for _,part in ipairs(model:GetChildren()) do
if part:IsA("BasePart") and BODY[part.Name] then
for _,object in ipairs(part:GetChildren()) do
local list={object}
if object:IsA("Attachment") then list=object:GetChildren() end
for _,item in ipairs(list) do
if FX[item.ClassName] and not item:GetAttribute(MARK)
and not (item:IsA("Sound") and (part.Name=="HumanoidRootPart" or CHARACTER_SOUNDS[item.Name])) then
pcall(function()
if item:IsA("Sound") then item.Volume=0;item:Stop() else item.Enabled=false end
end)
end
end
end
end
end
end
local function copy(object)
local archivable=object.Archivable
if not archivable then object.Archivable=true end
local ok,result=pcall(function() return object:Clone() end)
if not archivable then object.Archivable=archivable end
return ok and result or nil
end
local function mark(object)
object:SetAttribute(MARK,true)
for _,child in ipairs(object:GetDescendants()) do child:SetAttribute(MARK,true) end
end
local function apply(model,id,colors)
local template=originals.GetDeathEffect(id)
local root=template and template:FindFirstChild("DeathEffect")
if not root then return false end
suppressNative(model)
local color=root:GetAttribute("Color")
local material=root:GetAttribute("Material")
local hide=root:GetAttribute("HideBody")==true
for _,part in ipairs(model:GetChildren()) do
if part:IsA("BasePart") and BODY[part.Name] and part.Name~="HumanoidRootPart" then
pcall(function()
if typeof(color)=="Color3" then part.Color=color
elseif colors and colors[part.Name] then part.Color=colors[part.Name] end
if type(material)=="string" then
local name=material:match("([%w]+)$")
if name and Enum.Material[name] then part.Material=Enum.Material[name] end
end
if hide then part.LocalTransparencyModifier=1 end
end)
end
end
for _,folder in ipairs(root:GetChildren()) do
local target=BODY[folder.Name] and model:FindFirstChild(folder.Name)
if target and target:IsA("BasePart") then
for _,object in ipairs(folder:GetChildren()) do
local clone=copy(object)
if clone then
mark(clone)
clone.Parent=target
local items=clone:GetDescendants()
table.insert(items,1,clone)
for _,item in ipairs(items) do
if item:IsA("Sound") then pcall(function() item:Play() end)
elseif item:IsA("ParticleEmitter") then pcall(function() item.Enabled=true;item:Emit(math.clamp(math.floor(item.Rate/4),2,20)) end) end
end
end
end
end
end
local hat=root:FindFirstChild("Hat")
local head=model:FindFirstChild("Head")
local handle=hat and hat:FindFirstChildWhichIsA("BasePart")
if handle and head and head:IsA("BasePart") then
local clone=copy(handle)
if clone then
mark(clone)
clone.Anchored=false;clone.CanCollide=false;clone.CanQuery=false;clone.CanTouch=false;clone.Massless=true
local attachment=clone:FindFirstChildWhichIsA("Attachment")
local slot=attachment and head:FindFirstChild(attachment.Name)
local offset=(slot and slot:IsA("Attachment") and slot.CFrame or CFrame.new(0,head.Size.Y/2,0))
*(attachment and attachment.CFrame:Inverse() or CFrame.new())
clone.CFrame=head.CFrame*offset
local weld=Instance.new("Weld")
weld.Part0=head;weld.Part1=clone;weld.C0=offset;weld.Parent=clone
clone.Parent=model
end
end
local scatter=root:FindFirstChild("Scatter")
local center=model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso") or model:FindFirstChild("HumanoidRootPart")
if scatter and center then
local pieces=scatter:GetChildren()
local count=hide and 28 or 10
for index=1,count do
local source=pieces[(index-1)%#pieces+1]
local clone=source and source:IsA("BasePart") and copy(source)
if clone then
mark(clone)
clone.Anchored=false;clone.CanCollide=true;clone.CanQuery=false;clone.CanTouch=false;clone.Massless=false
clone.CFrame=center.CFrame*CFrame.new((math.random()-0.5)*2,(math.random()-0.5)*2,(math.random()-0.5)*1)
*CFrame.Angles(math.random()*6.28,math.random()*6.28,math.random()*6.28)
clone.Parent=workspace
pcall(function()
clone.AssemblyLinearVelocity=Vector3.new((math.random()-0.5)*40,18+math.random()*22,(math.random()-0.5)*40)
clone.AssemblyAngularVelocity=Vector3.new(math.random()*10,math.random()*10,math.random()*10)
end)
task.delay(4+math.random()*2,function() pcall(function() clone:Destroy() end) end)
end
end
end
return true
end
local function onDied(plr,character)
if not alive or not runtimeAlive then return end
local id=chosen()
if not id then return end
local killer=killerOf(character)
if killer~=LocalPlayer then return end
local root=character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
if not root then return end
local colors={}
for _,part in ipairs(character:GetChildren()) do
if part:IsA("BasePart") and BODY[part.Name] then colors[part.Name]=part.Color end
end
local death={id=id,position=root.Position,at=os.clock(),colors=colors,done={}}
deaths[#deaths+1]=death
for _,delay in ipairs({0.05,0.35}) do
task.delay(delay,function()
if character.Parent and not death.done[character] then
death.done[character]=true
local ok,err=pcall(apply,character,id,colors)
end
end)
end
task.delay(4,function()
local index=table.find(deaths,death)
if index then table.remove(deaths,index) end
end)
end
local function ragdollAdded(model)
if #deaths==0 or not model:IsA("Model") then return end
local name=model.Name:lower()
if not (name:find("rag",1,true) or name:find("corpse",1,true)) then return end
task.defer(function()
local part=model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("UpperTorso") or model:FindFirstChildWhichIsA("BasePart")
if not part then return end
for _,death in ipairs(deaths) do
if not death.done[model] and os.clock()-death.at<4 and (part.Position-death.position).Magnitude<25 then
death.done[model]=true
for _,delay in ipairs({0,0.3}) do
task.delay(delay,function()
if model.Parent then
local ok,err=pcall(apply,model,death.id,death.colors)
end
end)
end
break
end
end
end)
end
local function watchCharacter(plr,character)
local humanoid=character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid",5)
if not humanoid then return end
local list=playerConnections[plr]
if not list then list={};playerConnections[plr]=list end
list[#list+1]=humanoid.Died:Connect(function() onDied(plr,character) end)
end
local function watchPlayer(plr)
if plr==LocalPlayer then return end
local list={}
playerConnections[plr]=list
list[#list+1]=plr.CharacterAdded:Connect(function(character) task.spawn(watchCharacter,plr,character) end)
if plr.Character then task.spawn(watchCharacter,plr,plr.Character) end
end
for _,plr in ipairs(Players:GetPlayers()) do watchPlayer(plr) end
connections[#connections+1]=Players.PlayerAdded:Connect(watchPlayer)
connections[#connections+1]=Players.PlayerRemoving:Connect(function(plr)
for _,connection in ipairs(playerConnections[plr] or {}) do connection:Disconnect() end
playerConnections[plr]=nil
end)
connections[#connections+1]=workspace.DescendantAdded:Connect(function(object)
if #deaths>0 and object:IsA("Model") then ragdollAdded(object) end
end)
runtime.RegisterReset(function()
table.clear(deaths)
if not runtimeAlive then
alive=false
for _,connection in ipairs(connections) do connection:Disconnect() end
for _,list in pairs(playerConnections) do for _,connection in ipairs(list) do connection:Disconnect() end end
table.clear(playerConnections)
end
end)
end,"Part at line 13128")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local effects=env.VisualsV2Runtime.ClientKnifeEffects
local originals=env.VisualsV2Runtime.OriginalVisuals
local players=game:GetService("Players")
local alive=true
local pending={}
local corpses=setmetatable({},{__mode="k"})
local changed={}
local connections={}
local characterConnections={}
local bodyNames={Head=true,Torso=true,UpperTorso=true,LowerTorso=true,["Left Arm"]=true,["Right Arm"]=true,
["Left Leg"]=true,["Right Leg"]=true,LeftUpperArm=true,LeftLowerArm=true,LeftHand=true,RightUpperArm=true,
RightLowerArm=true,RightHand=true,LeftUpperLeg=true,LeftLowerLeg=true,LeftFoot=true,
RightUpperLeg=true,RightLowerLeg=true,RightFoot=true}
local function active()
local enabled,id=effects.GetState()
return alive and runtimeAlive and enabled and id=="Money"
end
local function restore()
for object,record in pairs(changed) do pcall(function() object[record.property]=record.value end) end
table.clear(changed)
table.clear(pending)
end
local function tagged(character)
if not character then return false end
for _,name in ipairs({"Creator2"}) do
local tag=character:FindFirstChild(name,true)
if tag and tag:IsA("ObjectValue") and tag.Value==LocalPlayer then return true end
end
return false
end
local function applyBody(model)
local info=originals.GetEffectInfo("Money")
if not info then return end
for _,part in ipairs(model:GetChildren()) do
if part:IsA("BasePart") and bodyNames[part.Name] then
local objects={part}
for _,child in ipairs(part:GetChildren()) do objects[#objects+1]=child end
for _,object in ipairs(objects) do
local property=object:IsA("MeshPart") and "TextureID" or object:IsA("SpecialMesh") and "TextureId"
if property and not changed[object] then
changed[object]={property=property,value=object[property]}
object[property]=info.deathTexture
end
end
end
end
end
local function consider(model)
if not active() or not model or not model:IsA("Model") then return end
local playerName=model:FindFirstChild("PlayerName")
if not playerName or not playerName:IsA("StringValue") then return end
corpses[model]=true
local confirmation=pending[playerName.Value]
if confirmation and confirmation>os.clock() then applyBody(model) end
end
local function confirm(player,character)
if not active() or player==LocalPlayer or not tagged(character) then return end
pending[player.Name]=os.clock()+20
applyBody(character)
for model in pairs(corpses) do
if model.Parent then consider(model) else corpses[model]=nil end
end
end
local function bindCharacter(player,character)
local previous=characterConnections[player]
if previous then for _,connection in ipairs(previous) do connection:Disconnect() end end
local list={};characterConnections[player]=list
if not character or player==LocalPlayer then return end
local humanoid=character:FindFirstChildOfClass("Humanoid")
local boundHumanoid=nil
local function died()
confirm(player,character)
for _,delayTime in ipairs({0.1,0.5}) do task.delay(delayTime,function() confirm(player,character) end) end
end
local function bindHumanoid(object)
if object and object~=boundHumanoid then boundHumanoid=object;list[#list+1]=object.Died:Connect(died) end
end
bindHumanoid(humanoid)
list[#list+1]=character.DescendantAdded:Connect(function(object)
if object:IsA("Humanoid") then bindHumanoid(object) end
if object.Name=="Creator2" then
task.defer(function()
local current=character:FindFirstChildOfClass("Humanoid")
if current and current.Health<=0 then confirm(player,character) end
end)
end
end)
end
local function bindPlayer(player)
connections[#connections+1]=player.CharacterAdded:Connect(function(character) bindCharacter(player,character) end)
bindCharacter(player,player.Character)
end
for _,player in ipairs(players:GetPlayers()) do bindPlayer(player) end
connections[#connections+1]=players.PlayerAdded:Connect(bindPlayer)
connections[#connections+1]=players.PlayerRemoving:Connect(function(player)
local list=characterConnections[player]
if list then for _,connection in ipairs(list) do connection:Disconnect() end end
characterConnections[player]=nil;pending[player.Name]=nil
end)
local workspaceConnection=nil
local function watchWorkspace(on)
if workspaceConnection then workspaceConnection:Disconnect();workspaceConnection=nil end
if not on then return end
workspaceConnection=workspace.DescendantAdded:Connect(function(object)
if not active() then return end
if object.Name=="PlayerName" and object:IsA("StringValue") then task.defer(function() consider(object.Parent) end)
elseif object.Name=="Raggy" and object:IsA("Model") then task.defer(function() consider(object) end)
elseif object:IsA("BasePart") and bodyNames[object.Name] then task.defer(function() consider(object.Parent) end) end
end)
end
local prior=false
local elapsed=0
connections[#connections+1]=RunService.Heartbeat:Connect(function(dt)
elapsed=elapsed+dt
if elapsed<0.25 then return end
elapsed=0
local current=active()
if current and not prior then
watchWorkspace(true)
for _,object in ipairs(workspace:GetDescendants()) do
if object.Name=="PlayerName" and object:IsA("StringValue") then consider(object.Parent) end
end
elseif prior and not current then watchWorkspace(false);restore() end
prior=current
for object in pairs(changed) do if not object.Parent then changed[object]=nil end end
end)
env.VisualsV2Runtime.RegisterReset(function()
restore();prior=false;watchWorkspace(false)
if not runtimeAlive then
alive=false
for _,connection in ipairs(connections) do connection:Disconnect() end
for _,list in pairs(characterConnections) do for _,connection in ipairs(list) do connection:Disconnect() end end
end
end)
end,"Part at line 13376")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local mmv=game.GameId==10413186812 or game.GameId==10769671266 or game.PlaceId==93017634738276 or game.PlaceId==81374640397860
local originals=env.VisualsV2Runtime.OriginalVisuals
local enabled=not mmv and env.VisualsV2Runtime.WeaponsUnlocked() and C("vv2PetsEnabled",false)
local selected=tostring(C("vv2Pet","None"))
local alive=true
local catalog={}
local model,root,parts,follow
local velocity=Vector3.new()
local character=nil
local hidden={}
local heartbeat=nil
local connections={}
local lastError=nil
local nativeAnchor=nil
local petHalfHeight=.5
for id,data in pairs(originals.Metadata.Pets) do catalog[id]={id=id,name=data.name or id,data=data} end
if not catalog[selected] then selected="None" end
local function restoreNative()
for object,record in pairs(hidden) do pcall(function() object[record.property]=record.value end) end
table.clear(hidden)
end
local function nativePet()
local pet=character and character:FindFirstChild("Pet")
local body=pet and (pet:IsA("BasePart") and pet or pet:FindFirstChild("Body",true) or pet:FindFirstChildWhichIsA("BasePart",true))
if body and body:IsA("BasePart") then return pet,body end
end
local hideList,hideListPet,hideListAt=nil,nil,0
local function hideNative(pet)
if not pet then return end
local now=os.clock()
if pet~=hideListPet or now-hideListAt>0.5 then
hideList,hideListPet,hideListAt={},pet,now
local objects={pet}
for _,object in ipairs(pet:GetDescendants()) do objects[#objects+1]=object end
for _,object in ipairs(objects) do
local property=object:IsA("BasePart") and "LocalTransparencyModifier" or object:IsA("BillboardGui") and "Enabled"
if property then hideList[#hideList+1]={object,property,property~="Enabled" and 1 or false} end
end
end
for _,item in ipairs(hideList) do
local object,property,value=item[1],item[2],item[3]
if not hidden[object] then hidden[object]={property=property,value=object[property]} end
if object[property]~=value then object[property]=value end
end
end
local rayParams,rayFilter=nil,{}
local function clear()
if model then model:Destroy() end
model=nil;root=nil;parts=nil;follow=nil;nativeAnchor=nil
velocity=Vector3.new()
hideList,hideListPet=nil,nil
restoreNative()
end
local function spawnModel()
local source=originals.GetPet(selected)
if not source then lastError="Original pet template unavailable";return false end
model=source:Clone();model.Name="VisualsV2_ClientPet"
model:SetAttribute("VisualsV2_ClientPet",true);model:SetAttribute("VisualsV2_ClientWeaponSkin",true)
root=model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart",true)
if not root then clear();lastError="Original pet has no body";return false end
local origin=root.CFrame
local bottom=0
parts={}
for _,part in ipairs(model:GetDescendants()) do
if part:IsA("BasePart") then
part.Anchored=true;part.CanCollide=false;part.CanTouch=false;part.CanQuery=false
part.Massless=true;part.LocalTransparencyModifier=0
local relative=origin:ToObjectSpace(part.CFrame)
parts[#parts+1]={part=part,relative=relative}
bottom=math.min(bottom,relative.Position.Y-part.Size.Y*.5)
end
end
petHalfHeight=math.max(.15,-bottom);lastError=nil
return true
end
local function useNativeMotion(pet,body)
if nativeAnchor~=body then
for _,record in ipairs(parts) do
if record.weld then record.weld:Destroy() end
record.part.CFrame=body.CFrame*record.relative
record.part.Anchored=false
local weld=Instance.new("Weld")
weld.Name="VisualsV2_PetMotionWeld";weld.Part0=body;weld.Part1=record.part
weld.C0=record.relative;weld.C1=CFrame.new();weld.Parent=record.part
record.weld=weld
end
nativeAnchor=body
end
hideNative(pet)
end
local function groundHit(origin,pet)
if not rayParams then
rayParams=RaycastParams.new();rayParams.FilterType=Enum.RaycastFilterType.Exclude
rayFilter={}
end
if rayFilter[1]~=character or rayFilter[2]~=model or rayFilter[3]~=pet then
rayFilter={character,model,pet}
local filters={character,model}
if pet then filters[#filters+1]=pet end
rayParams.FilterDescendantsInstances=filters
end
return workspace:Raycast(origin,Vector3.new(0,-30,0),rayParams)
end
local function springGoal(body,floating,dt,pet)
-- (the spot the pet follows is behind you and to your right, turning with you, not a fixed
-- world offset (with a fixed one it ended up beside, in front of or behind you depending on where you
-- faced))
local flat=Vector3.new(body.CFrame.LookVector.X,0,body.CFrame.LookVector.Z)
if flat.Magnitude<0.01 then flat=Vector3.new(0,0,-1) end
flat=flat.Unit
local right=Vector3.new(-flat.Z,0,flat.X)
local offset=right*2.5-flat*2.5
local position=body.Position or body.CFrame.Position
local target=position+offset+Vector3.new(0,floating and 1.1+math.sin(os.clock()*2.5)*.25 or -2,0)
if not floating then
local ok,hit=pcall(groundHit,target+Vector3.new(0,8,0),pet)
if ok and hit then target=Vector3.new(target.X,hit.Position.Y+petHalfHeight,target.Z) end
end
local current=follow and follow.Position or target
local distance=(target-current).Magnitude
if distance>60 then current=target;velocity=Vector3.new() end
local steps=math.max(1,math.min(12,math.ceil(math.max(dt,0)*60)))
local h=math.min(math.max(dt,0),.2)/steps
for _=1,steps do
local acceleration=(target-current)*25-velocity*10
velocity=velocity+acceleration*h
current=current+velocity*h
end
local direction=Vector3.new(velocity.X,0,velocity.Z)
if direction.Magnitude<.1 then direction=flat end
if direction.Magnitude<.001 then direction=Vector3.new(0,0,-1) end
local goal=CFrame.lookAt(current,current+direction.Unit)
if not floating then goal=goal*CFrame.new(0,math.sin(os.clock()*8)*math.min(velocity.Magnitude/14,1)*.08,0) end
return goal
end
local function update(dt)
if character~=LocalPlayer.Character then clear();character=LocalPlayer.Character end
local body=character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
if not enabled or not catalog[selected] or not body then clear();return end
local pet,petBody=nativePet()
local nativeId=pet and pet:IsA("StringValue") and pet.Value
if nativeId==selected or selected=="<3" and nativeId=="HeartBalloon" then
clear();return
end
local nativeData=nativeId and catalog[nativeId] and catalog[nativeId].data
local compatible=petBody and nativeData and nativeData.type==catalog[selected].data.type
if not model and not spawnModel() then return end
if compatible then useNativeMotion(pet,petBody)
else
if nativeAnchor then
for _,record in ipairs(parts) do
if record.weld then record.weld:Destroy();record.weld=nil end
record.part.Anchored=true
end
nativeAnchor=nil
end
follow=springGoal(body,catalog[selected].data.type~="Walking",dt,pet)
for _,record in ipairs(parts) do record.part.CFrame=follow*record.relative end
hideNative(pet)
end
if not model.Parent then model.Parent=workspace end
end
local function refresh()
if heartbeat then heartbeat:Disconnect();heartbeat=nil end
clear();character=LocalPlayer.Character
if not alive or not runtimeAlive or not enabled or selected=="None" then return end
update(0)
heartbeat=RunService.Heartbeat:Connect(function(dt) if alive and runtimeAlive then update(dt) end end)
end
connections[#connections+1]=LocalPlayer.CharacterAdded:Connect(function() task.defer(refresh) end)
env.VisualsV2Runtime.ClientPets={
Catalog=catalog,
Select=function(id)
if id~="None" and not catalog[id] then return false end
selected=id;SetCfg("vv2Pet",id);refresh();return true
end,
SetEnabled=function(value)
enabled=value==true and not mmv;SetCfg("vv2PetsEnabled",enabled);refresh();return true
end,
GetState=function() return enabled,selected end,
Refresh=refresh,
}
env.VisualsV2Runtime.RegisterReset(function()
enabled=false;selected="None";SetCfg("vv2PetsEnabled",false);SetCfg("vv2Pet","None");refresh()
if not runtimeAlive then alive=false;for _,connection in ipairs(connections) do connection:Disconnect() end end
end)
refresh()
end,"Part at line 13516")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE))
if not inMurderMystery then return end
local skins=env.VisualsV2Runtime.ClientWeaponSkins
local originals=env.VisualsV2Runtime.OriginalVisuals
local alive=true
local weaponSoundsEnabled=env.VisualsV2Runtime.WeaponsUnlocked() and C("vv2WeaponSoundsEnabled",true)
local SHOT_GAP=0.4
local states={}
local connections={}
local liveBeams={}
local nativeSounds=setmetatable({}, {__mode="k"})
local shotRemotes=setmetatable({}, {__mode="k"})
local nativeAssets={Shot={},Reload={}}
local vanillaAssets={Shot="10209803",Reload="4753414199"}
local audioTransport
local soundService=game:GetService("SoundService")
local sharedShotRemotes=setmetatable({}, {__mode="k"})
local shotVisual
local soundProperties={"SoundId","Volume","PlaybackSpeed","RollOffMinDistance","RollOffMaxDistance","RollOffMode"}
local beamProperties={"Color","Texture","Width0","Width1","LightEmission","LightInfluence","Transparency",
"TextureLength","TextureMode","TextureSpeed","Segments","CurveSize0","CurveSize1"}
local shotNames={gunshot=true,altsound=true,shoot=true,shotsound=true,shootsound=true}
local reloadNames={reload=true,customreload=true,reloadsound=true}
local function assetId(value)
return tostring(value or ""):match("(%d+)")
end
for id in pairs(originals.Metadata.Gun or {}) do
local behavior=originals.GetGunBehavior(id)
if behavior then
for kind,key in pairs({Shot="shoot",Reload="reload"}) do
local id=behavior[key] and assetId(behavior[key].SoundId)
if id then nativeAssets[kind][id]=true end
end
end
end
local function owned(object,tool)
while object and object~=tool do
if object:GetAttribute("VisualsV2_ClientWeaponSkin") or object:GetAttribute("VisualsV2_GunCosmetic") then return true end
object=object.Parent
end
return false
end
local function write(state,object,key,value)
if value==nil then return end
pcall(function()
local saved=state.saved[object]
if not saved then saved={};state.saved[object]=saved end
if not saved[key] then saved[key]={value=object[key]} end
object[key]=originals.Decode(value)
end)
end
local function restoreNativeAudio(record)
record.writing=true
for key,value in pairs(record.saved or {}) do
pcall(function() if record.sound[key]==record.applied[key] then record.sound[key]=value end end)
end
record.saved={};record.applied={}
record.writing=false
end
local defaultAudio={
Shot={SoundId="rbxassetid://10209803",Volume=0.7,PlaybackSpeed=1},
Reload={SoundId="rbxassetid://4753414199",Volume=1,PlaybackSpeed=1},
}
local function routeNativeAudio(record)
if record.writing then return end
local sound,state=record.sound,record.state
local muted=state.audioEnabled and (record.kind=="Shot" or state.suppressReload)
if muted then
record.writing=true
if record.saved.Volume==nil then record.saved.Volume=sound.Volume end
sound.Volume=0;record.applied.Volume=0
record.writing=false
return
end
if state.audioEnabled then return end
local id=assetId(sound.SoundId)
local native=id and (id==vanillaAssets[record.kind] or nativeAssets[record.kind][id]
or id==assetId(record.applied.SoundId))
if not native then restoreNativeAudio(record);return end
record.writing=true
for key,value in pairs(defaultAudio[record.kind]) do
if record.saved[key]==nil then record.saved[key]=sound[key] end
sound[key]=value;record.applied[key]=value
end
record.writing=false
end
local function retireAudio(host,preserve)
if not host then return end
local pending={}
if preserve then
for _,sound in ipairs(host:GetChildren()) do
if sound:IsA("Sound") and sound.IsPlaying then pending[sound]=true end
end
end
if not next(pending) then host:Destroy();return end
local ended={}
local done=false
local function dispose()
if done then return end
done=true
for _,connection in ipairs(ended) do connection:Disconnect() end
host:Destroy()
end
for sound in pairs(pending) do
ended[#ended+1]=sound.Ended:Connect(function()
pending[sound]=nil
if not next(pending) then dispose() end
end)
end
task.delay(30,dispose)
end
local function clear(tool,preserveAudio)
local state=states[tool]
if not state then return end
states[tool]=nil
for _,connection in ipairs(state.connections) do connection:Disconnect() end
for sound,record in pairs(state.sounds) do nativeSounds[sound]=nil;restoreNativeAudio(record) end
for remote in pairs(state.remotes) do shotRemotes[remote]=nil end
for object,values in pairs(state.saved) do
liveBeams[object]=nil
for key,record in pairs(values) do pcall(function() object[key]=record.value end) end
end
for _,object in ipairs(state.created) do pcall(function() object:Destroy() end) end
retireAudio(state.audioHost,preserveAudio)
if audioTransport and not next(states) then audioTransport.handler=nil end
end
local function makeSound(state,kind,settings)
if not state.audioEnabled or not settings then return end
local sound=Instance.new("Sound")
sound.Name="VisualsV2_"..kind.."Overlay"
sound:SetAttribute("VisualsV2_GunCosmetic",true)
for _,key in ipairs(soundProperties) do
if settings[key]~=nil then pcall(function() sound[key]=originals.Decode(settings[key]) end) end
end
if settings.equalizer then
local eq=Instance.new("EqualizerSoundEffect")
for key,value in pairs(settings.equalizer) do pcall(function() eq[key]=value end) end
eq.Parent=sound
end
if not state.audioHost then
state.audioHost=Instance.new("Folder")
state.audioHost.Name="VisualsV2_GunAudio"
state.audioHost:SetAttribute("VisualsV2_GunCosmetic",true)
state.audioHost.Parent=soundService
end
sound.Parent=state.audioHost
state.overlays[kind]=sound
task.spawn(function()
if states[state.tool]~=state or not sound.Parent then return end
local ok,reason=pcall(function() game:GetService("ContentProvider"):PreloadAsync({sound}) end)
if states[state.tool]==state and (not ok or not sound.IsLoaded) then
state.soundError=kind.." "..sound.SoundId..": "..tostring(ok and "Asset was not loaded" or reason)
end
end)
end
local function audible(state,kind)
if state.tool.Parent==LocalPlayer.Character then return true end
return kind=="Reload" and state.backpack and state.tool.Parent==state.backpack
and os.clock()-(state.shotAt or -math.huge)<6
end
local function confirmed(state,kind,source,authorized)
if states[state.tool]~=state or (not authorized and not audible(state,kind)) then return end
local now=os.clock()
if kind=="Shot" then
if now-math.max(state.shotAt or -math.huge,state.remoteAt or -math.huge)>SHOT_GAP then
state.shotCycle=(state.shotCycle or 0)+1
end
state.shotAt=now
end
if not state.audioEnabled then return end
local settings=kind=="Shot" and state.behavior.shoot or state.behavior.reload
if not settings or now-(state.lastPlay[kind] or -math.huge)<SHOT_GAP then return end
if kind=="Reload" and state.reloadCycle==(state.shotCycle or 0)
and now-(state.reloadDispatchedAt or -math.huge)<6 then return end
if state.pending[kind] then return end
local token={}
state.pending[kind]=token
local function dispatch()
if states[state.tool]~=state or not state.audioEnabled or state.pending[kind]~=token then return end
state.pending[kind]=nil
local at=os.clock()
if at-(state.lastPlay[kind] or -math.huge)<SHOT_GAP then return end
state.lastPlay[kind]=at
if kind=="Reload" then
state.reloadCycle=state.shotCycle or 0;state.reloadDispatchedAt=at
end
local sound=state.overlays[kind]
if sound and sound.Parent then
local ok,err=pcall(function() sound.TimePosition=0;sound:Play() end)
if ok then state.plays[kind]=state.plays[kind]+1 else state.soundError=tostring(err) end
end
end
if source==nil then task.delay(0.04,dispatch) else task.defer(dispatch) end
end
local function configureObject(tool,state,object)
if owned(object,tool) then return end
if object:IsA("Sound") and not state.sounds[object] then
local name=object.Name:lower():gsub("[^%w]","")
local kind=shotNames[name] and "Shot" or reloadNames[name] and "Reload"
if kind then
local record={sound=object,state=state,kind=kind,saved={},applied={},nativeId=assetId(object.SoundId)}
state.sounds[object]=record;nativeSounds[object]=record
routeNativeAudio(record)
state.connections[#state.connections+1]=object.Played:Connect(function()
if states[tool]~=state or not audible(state,kind) then return end
if state.audioEnabled and (kind=="Shot" or state.suppressReload) then
pcall(function() object:Stop() end)
confirmed(state,kind,false)
end
end)
state.connections[#state.connections+1]=object:GetPropertyChangedSignal("SoundId"):Connect(function()
if states[tool]==state then routeNativeAudio(record) end
end)
do
state.connections[#state.connections+1]=object:GetPropertyChangedSignal("Volume"):Connect(function()
if states[tool]==state then routeNativeAudio(record) end
end)
end
end
elseif object:IsA("RemoteEvent") and (object.Name=="Shoot" or object.Name=="ShootGun") then
shotRemotes[object]=state;state.remotes[object]=true
elseif object:IsA("Beam") and object.Name=="CustomBeam" and state.behavior.beam then
for _,key in ipairs(beamProperties) do write(state,object,key,state.behavior.beam[key]) end
end
end
local function tradeTransportObject(object)
LPH_ATTRIBUTES(VM(NONE))
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
local function installAudioTransport()
local bridge=env.VisualsV2GunAudioBridge
if type(bridge)~="table" or bridge.version~=3 then
if type(bridge)=="table" then bridge.handler=nil end
bridge={version=3,dispatchers=setmetatable({}, {__mode="k"}),methods={}}
env.VisualsV2GunAudioBridge=bridge
end
audioTransport=bridge
local callingScript=getcallingscript or env.getcallingscript
bridge.handler=function(object,method,first,...)
if not alive or not runtimeAlive then return end
if method=="FireServer" then
local state=shotRemotes[object]
if not state and sharedShotRemotes[object] then
for tool,candidate in pairs(states) do
if tool.Parent==LocalPlayer.Character then state=candidate;break end
end
end
if state and state.tool.Parent==LocalPlayer.Character then
state.remoteShots=(state.remoteShots or 0)+1
if os.clock()-(state.remoteAt or -math.huge)>SHOT_GAP then state.shotCycle=(state.shotCycle or 0)+1 end
state.remoteAt=os.clock()
confirmed(state,"Shot")
if shotVisual then shotVisual(state,object,first,...) end
end
return
end
local sound=method=="PlayLocalSound" and object==soundService and first or method=="Play" and object
local record=sound and nativeSounds[sound]
if not record and sound and type(callingScript)=="function" then
local ok,script=pcall(callingScript)
if ok and script then
local current=script
local state
while current do
state=states[current]
if state then break end
current=current.Parent
end
if state and typeof(sound)=="Instance" and sound.ClassName=="Sound" then
local name=sound.Name:lower():gsub("[^%w]","")
local kind=shotNames[name] and "Shot" or reloadNames[name] and "Reload"
if kind then record={sound=sound,state=state,kind=kind} end
end
end
end
if not record or not audible(record.state,record.kind) then return end
local state,kind=record.state,record.kind
state.nativeCalls[kind]=state.nativeCalls[kind]+1
if not state.audioEnabled then return end
if kind=="Reload" and not state.suppressReload then return end
if kind=="Reload" then state.suppressedReloads=(state.suppressedReloads or 0)+1 end
confirmed(state,kind,false)
return "skip"
end
local functionHook=hookfunction or env.hookfunction
local closure=newcclosure or env.newcclosure
if type(functionHook)=="function" and not bridge.methodsAttempted then
bridge.methodsAttempted=true
local sample=Instance.new("Sound")
for _,method in ipairs({"Play","PlayLocalSound"}) do
local target=method=="Play" and sample.Play or soundService.PlayLocalSound
local previousMethod
local wrapper=function(object,...)
local handler=bridge.handler
if not handler then return previousMethod(object,...) end
local thread=coroutine.running() or bridge
if bridge.dispatchers[thread] then return previousMethod(object,...) end
bridge.dispatchers[thread]=true
local ok,action=pcall(handler,object,method,...)
bridge.dispatchers[thread]=nil
if not ok then bridge.error=tostring(action) end
if ok and action=="skip" then return end
return previousMethod(object,...)
end
if type(closure)=="function" then wrapper=closure(wrapper) end
local ok,result=pcall(functionHook,target,wrapper)
if ok and type(result)=="function" then previousMethod=result;bridge.methods[method]=true end
end
sample:Destroy()
end
if bridge.ready then return end
local namecall=getnamecallmethod or env.getnamecallmethod
local restoreMethod=setnamecallmethod or env.setnamecallmethod
local hook=hookmetamethod or env.hookmetamethod
if type(namecall)~="function" then bridge.error="getnamecallmethod is unavailable";return end
if type(hook)~="function" then
local rawMeta=getrawmetatable or env.getrawmetatable
local readOnly=setreadonly or env.setreadonly
if type(rawMeta)~="function" or type(readOnly)~="function" then bridge.error="Native audio observation is unavailable";return end
hook=function(object,key,replacement)
local mt=rawMeta(object)
local previous=mt[key]
local isReadOnly=isreadonly or env.isreadonly
local wasReadOnly=true
if type(isReadOnly)=="function" then wasReadOnly=isReadOnly(mt) end
readOnly(mt,false);mt[key]=replacement;readOnly(mt,wasReadOnly)
return previous
end
end
local previous
-- (the cheap checks come first: every method call in the game passes through here, so anything
-- that isn't FireServer or a sound play leaves straight away)
local wrapper=function(object,...)
local handler=bridge.handler
if not handler then return previous(object,...) end
local method=namecall()
if method~="FireServer" and method~="PlayLocalSound" and method~="Play" then return previous(object,...) end
if tradeTransportObject(object) then return previous(object,...) end
local thread=coroutine.running() or bridge
if bridge.dispatchers[thread] then return previous(object,...) end
bridge.dispatchers[thread]=true
local ok,action,value=pcall(handler,object,method,...)
bridge.dispatchers[thread]=nil
if not ok then bridge.error=tostring(action) end
if type(restoreMethod)=="function" then pcall(restoreMethod,method) end
if ok and action=="self" then return previous(value,...) end
if ok and action=="sound" then return previous(object,value,select(2,...)) end
if ok and action=="skip" then return end
return previous(object,...)
end
if type(closure)=="function" then wrapper=closure(wrapper) end
local ok,result=pcall(hook,game,"__namecall",wrapper)
if ok and type(result)=="function" then previous=result;bridge.ready=true;bridge.error=nil
else bridge.error=tostring(result) end
end
local function bindAnimator(state)
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")
if state.animator==animator then return end
if state.animationConnection then state.animationConnection:Disconnect() end
state.animator=animator
if not animator then return end
state.animationConnection=animator.AnimationPlayed:Connect(function(track)
if state.tool.Parent~=LocalPlayer.Character or not track.Animation then return end
local id=assetId(track.Animation.AnimationId)
local animations=state.tool:FindFirstChild("Animations")
for _,pair in ipairs({{"Shoot","Shot"},{"Reload","Reload"}}) do
local native=animations and animations:FindFirstChild(pair[1])
local expected=native and assetId(native.AnimationId)
or state.behavior.animations and assetId(state.behavior.animations[pair[1]])
if id and id==expected then confirmed(state,pair[2]);return end
end
end)
state.connections[#state.connections+1]=state.animationConnection
end
local function update()
local enabled,id=skins.GetState("Gun")
local behavior=enabled and originals.GetGunBehavior(id)
if not behavior and next(states)==nil then return end
local current={}
local backpack=LocalPlayer:FindFirstChildOfClass("Backpack")
for _,container in pairs({LocalPlayer.Character,backpack}) do
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and skins.GetKind(tool)=="Gun" and behavior then current[tool]=true end
end
end
for tool,state in pairs(states) do
if not current[tool] or state.id~=id or state.handle~=tool:FindFirstChild("Handle",true) or state.audioEnabled~=weaponSoundsEnabled then
clear(tool,enabled and state.id==id and state.audioEnabled==weaponSoundsEnabled)
end
end
for tool in pairs(current) do
local state=states[tool]
if not state then
local handle=tool:FindFirstChild("Handle",true)
if handle and handle:IsA("BasePart") then
local scope=id:lower():find("scope",1,true)~=nil
state={id=id,tool=tool,handle=handle,behavior=behavior,audioEnabled=weaponSoundsEnabled,
suppressReload=weaponSoundsEnabled and (scope or behavior.reload~=nil),
saved={},created={},connections={},
sounds=setmetatable({}, {__mode="k"}),remotes={},overlays={},pending={},evidence={},lastPlay={},
plays={Shot=0,Reload=0},nativeCalls={Shot=0,Reload=0}}
states[tool]=state
makeSound(state,"Shot",behavior.shoot)
makeSound(state,"Reload",behavior.reload)
for _,object in ipairs(tool:GetDescendants()) do configureObject(tool,state,object) end
if behavior.beam and not handle:FindFirstChild("CustomBeam") then
local beam=Instance.new("Beam");beam.Name="CustomBeam"
beam:SetAttribute("VisualsV2_GunCosmetic",true)
for _,key in ipairs(beamProperties) do
if behavior.beam[key]~=nil then beam[key]=originals.Decode(behavior.beam[key]) end
end
beam.Parent=handle;state.created[#state.created+1]=beam
end
state.connections[#state.connections+1]=tool.DescendantAdded:Connect(function(object)
if states[tool]==state then configureObject(tool,state,object) end
end)
state.connections[#state.connections+1]=tool.Activated:Connect(function()
if tool.Parent==LocalPlayer.Character then state.inputAt=os.clock();state.inputs=(state.inputs or 0)+1 end
end)
installAudioTransport()
end
end
if state then
state.backpack=backpack
local muzzle=state.handle:FindFirstChild("GunRaycastAttachment",true)
or state.handle:FindFirstChild("CustomAttachment",true)
state.muzzle=muzzle and muzzle:IsA("Attachment") and muzzle or nil
bindAnimator(state)
for object in pairs(state.saved) do if not object.Parent then state.saved[object]=nil;liveBeams[object]=nil end end
end
end
end
local function distanceToShot(beam,handle)
local a,b=beam.Attachment0,beam.Attachment1
if not a or not b then return nil end
local origin=handle.Position
local muzzle=handle:FindFirstChild("GunRaycastAttachment",true)
if muzzle and muzzle:IsA("Attachment") then origin=muzzle.WorldPosition end
return math.min((a.WorldPosition-origin).Magnitude,(b.WorldPosition-origin).Magnitude)
end
local function matchShot(beam)
local now=os.clock()
for tool,state in pairs(states) do
if tool.Parent==LocalPlayer.Character and state.behavior.beam and not beam:IsDescendantOf(tool) then
local a,b=beam.Attachment0,beam.Attachment1
local direct=a and a:IsDescendantOf(tool) or b and b:IsDescendantOf(tool)
if direct then return state end
if now-math.max(state.inputAt or -math.huge,state.shotAt or -math.huge)<=0.4 then
local distance=distanceToShot(beam,state.handle)
if distance and distance<=6 then
local ambiguous=false
for _,owner in ipairs(Players:GetPlayers()) do
if owner~=LocalPlayer and owner.Character then
local peer=owner.Character:FindFirstChild("Gun")
local handle=peer and peer:IsA("Tool") and peer:FindFirstChild("Handle",true)
if handle and handle:IsA("BasePart") then
local other=distanceToShot(beam,handle)
if other and other<=distance+1 then ambiguous=true;break end
end
end
end
if not ambiguous then return state end
end
end
end
end
end
local function visualMuzzle(state)
local muzzle=skins.GetMuzzle and skins.GetMuzzle(state.tool)
if muzzle and muzzle:IsA("Attachment") then return muzzle end
return state.muzzle
end
local function reanchorShot(beam,state)
local muzzle=visualMuzzle(state)
if not muzzle or not beam.Attachment0 or not beam.Attachment1 then return end
local origin=state.fireOrigin and os.clock()-(state.fireAt or -math.huge)<0.4 and state.fireOrigin or muzzle.WorldPosition
local native=state.muzzle and state.muzzle.WorldPosition or state.handle.Position
local first=(beam.Attachment0.WorldPosition-native).Magnitude<=(beam.Attachment1.WorldPosition-native).Magnitude
local carrier=Instance.new("Part")
carrier.Name="VisualsV2_BarrelOrigin";carrier:SetAttribute("VisualsV2_GunCosmetic",true)
carrier.Size=Vector3.new(0.01,0.01,0.01);carrier.Transparency=1;carrier.Anchored=true
carrier.CanCollide=false;carrier.CanTouch=false;carrier.CanQuery=false;carrier.CastShadow=false
carrier.CFrame=CFrame.new(origin)
local attachment=Instance.new("Attachment");attachment.Parent=carrier
carrier.Parent=workspace
write(state,beam,first and "Attachment0" or "Attachment1",attachment)
game:GetService("Debris"):AddItem(carrier,0.5)
end
local function applyShot(beam)
if not beam.Parent or liveBeams[beam] then return liveBeams[beam]~=nil end
local state=matchShot(beam)
if not state then return false end
reanchorShot(beam,state)
for _,key in ipairs(beamProperties) do write(state,beam,key,state.behavior.beam[key]) end
write(state,beam,"Enabled",true)
write(state,beam,"FaceCamera",true)
write(state,beam,"LocalTransparencyModifier",0)
local flicker=state.behavior.flicker
local colors={}
for _,color in ipairs(flicker and flicker.colors or {}) do colors[#colors+1]=originals.Decode(color) end
liveBeams[beam]={state=state,colors=colors,interval=flicker and flicker.interval or 1,elapsed=0,index=1}
state.tracers=(state.tracers or 0)+1
state.tracerAt=os.clock()
if state.fallbackBeam and state.fallbackBeam~=beam then
state.fallbackBeam.Parent:Destroy();state.fallbackBeam=nil
end
confirmed(state,"Shot")
return true
end
local function shotTarget(remote,...)
local first,second=...
if remote.Name=="ShootGun" and type(first)=="number" and typeof(second)=="Vector3" then return second end
if typeof(first)=="Vector3" then return first end
if typeof(first)=="CFrame" then return first.Position end
end
shotVisual=function(state,remote,...)
if not state.behavior.beam then return end
local target=shotTarget(remote,...)
if not target then return end
local stamp=os.clock()
local muzzle=visualMuzzle(state)
local origin=muzzle and muzzle.WorldPosition or state.handle.Position
state.fireOrigin=origin;state.fireAt=stamp
if (target-origin).Magnitude<0.01 then return end
task.delay(0.025,function()
if not alive or not runtimeAlive or states[state.tool]~=state or state.fireAt~=stamp
or (state.tracerAt or -math.huge)>=stamp then return end
local carrier=Instance.new("Part")
carrier.Name="VisualsV2_ShotTrace"
carrier:SetAttribute("VisualsV2_GunCosmetic",true)
carrier.Size=Vector3.new(0.05,0.05,0.05)
carrier.Anchored=true;carrier.Transparency=1;carrier.CanCollide=false
carrier.CanTouch=false;carrier.CanQuery=false;carrier.CastShadow=false
carrier.CFrame=CFrame.new(origin)
local a=Instance.new("Attachment");a.Name="Start";a.Parent=carrier
local b=Instance.new("Attachment");b.Name="End";b.Position=target-origin;b.Parent=carrier
local beam=Instance.new("Beam");beam.Name="VisualsV2_ShotBeam"
beam:SetAttribute("VisualsV2_GunCosmetic",true)
for _,key in ipairs(beamProperties) do
if state.behavior.beam[key]~=nil then beam[key]=originals.Decode(state.behavior.beam[key]) end
end
beam.FaceCamera=true;beam.Enabled=true;beam.LocalTransparencyModifier=0
beam.Attachment0=a;beam.Attachment1=b;beam.Parent=carrier
carrier.Parent=workspace
local colors={}
for _,color in ipairs(state.behavior.flicker and state.behavior.flicker.colors or {}) do
colors[#colors+1]=originals.Decode(color)
end
liveBeams[beam]={state=state,colors=colors,interval=state.behavior.flicker and state.behavior.flicker.interval or 1,elapsed=0,index=1}
state.fallbackBeam=beam;state.visualShots=(state.visualShots or 0)+1
task.delay(0.18,function()
liveBeams[beam]=nil
if state.fallbackBeam==beam then state.fallbackBeam=nil end
carrier:Destroy()
end)
end)
end
local function watchSharedRemote(object)
if object:IsA("RemoteEvent") and (object.Name=="ShootGun" or object.Name=="Shoot") then
sharedShotRemotes[object]=true
end
end
local storage=game:GetService("ReplicatedStorage")
local function watchRemoteRoot(root)
if root.Name~="Remotes" then return end
for _,object in ipairs(root:GetDescendants()) do watchSharedRemote(object) end
connections[#connections+1]=root.DescendantAdded:Connect(watchSharedRemote)
end
for _,root in ipairs(storage:GetChildren()) do watchRemoteRoot(root) end
connections[#connections+1]=storage.ChildAdded:Connect(watchRemoteRoot)
local audioContainerConnections={}
local audioQueued=false
local function scheduleAudio()
if audioQueued or not alive or not runtimeAlive then return end
audioQueued=true
task.defer(function() audioQueued=false;if alive and runtimeAlive then update() end end)
end
local function bindAudioContainers()
for _,connection in ipairs(audioContainerConnections) do connection:Disconnect() end
table.clear(audioContainerConnections)
for _,container in pairs({LocalPlayer.Character,LocalPlayer:FindFirstChildOfClass("Backpack")}) do
audioContainerConnections[#audioContainerConnections+1]=container.ChildAdded:Connect(scheduleAudio)
audioContainerConnections[#audioContainerConnections+1]=container.ChildRemoved:Connect(scheduleAudio)
audioContainerConnections[#audioContainerConnections+1]=container.DescendantAdded:Connect(function(object)
if object.Name=="Handle" or object:IsA("Animator") then scheduleAudio() end
end)
end
scheduleAudio()
end
connections[#connections+1]=skins.Changed:Connect(scheduleAudio)
connections[#connections+1]=LocalPlayer.CharacterAdded:Connect(bindAudioContainers)
connections[#connections+1]=LocalPlayer.ChildAdded:Connect(function(object)
if object:IsA("Backpack") then bindAudioContainers() end
end)
bindAudioContainers()
connections[#connections+1]=workspace.DescendantAdded:Connect(function(object)
if not alive or not runtimeAlive or next(states)==nil or not object:IsA("Beam") then return end
if object.Name=="VisualsV2_ShotBeam" then return end
local active=false
for tool,state in pairs(states) do
if tool.Parent==LocalPlayer.Character and state.behavior.beam and not object:IsDescendantOf(tool) then active=true;break end
end
if not active then return end
task.defer(function()
if not alive or not runtimeAlive or not object.Parent or applyShot(object) then return end
if object.Attachment0 and object.Attachment1 then return end
local waiting={}
local function disconnect()
for _,connection in ipairs(waiting) do connection:Disconnect() end
table.clear(waiting)
end
local function changed() if not object.Parent or applyShot(object) then disconnect() end end
for _,key in ipairs({"Attachment0","Attachment1"}) do
waiting[#waiting+1]=object:GetPropertyChangedSignal(key):Connect(changed)
end
task.delay(0.4,disconnect)
end)
end)
local elapsed=0
connections[#connections+1]=RunService.Heartbeat:Connect(function(dt)
if not alive or not runtimeAlive then return end
for beam,record in pairs(liveBeams) do
if not beam.Parent or states[record.state.tool]~=record.state then
record.state.saved[beam]=nil;liveBeams[beam]=nil
if beam.Name=="VisualsV2_ShotBeam" and beam.Parent then beam.Parent:Destroy() end
elseif #record.colors>1 then
record.elapsed=record.elapsed+dt
if record.elapsed>=record.interval then
local steps=math.floor(record.elapsed/record.interval)
record.elapsed=record.elapsed%record.interval
record.index=(record.index-1+steps)%#record.colors+1
beam.Color=record.colors[record.index]
end
end
end
elapsed=elapsed+dt
if elapsed>=0.75 then elapsed=0;update() end
end)
env.VisualsV2Runtime.GunCosmetics={Refresh=update,
SetSoundsEnabled=function(value)
weaponSoundsEnabled=value==true
SetCfg("vv2WeaponSoundsEnabled",weaponSoundsEnabled)
update()
end,
GetSoundsEnabled=function() return weaponSoundsEnabled end,
GetAudioSource=function(tool,kind)
local state=states[tool]
return state and state.overlays[kind]
end,}
env.VisualsV2Runtime.RegisterReset(function()
for tool in pairs(states) do clear(tool) end
if not runtimeAlive then
alive=false
if audioTransport then audioTransport.handler=nil end
for _,connection in ipairs(connections) do connection:Disconnect() end
for _,connection in ipairs(audioContainerConnections) do connection:Disconnect() end
end
end)
update()
end,"Part at line 13710")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local skins=env.VisualsV2Runtime.ClientWeaponSkins
local originals=env.VisualsV2Runtime.OriginalVisuals
local alive=true
local tools={}
local images={}
local guiConnections={}
local connections={}
local playerGui
local hudRoots={}
local queued=false
local imageKinds={}
local refresh,schedule
local function imageKey(value)
value=tostring(value or ""):lower()
return value:match("rbxassetid://(%d+)") or value:match("[?&]assetid=(%d+)")
or value:match("[?&]id=(%d+)") or value:match("^%s*(%d+)%s*$") or value
end
local function icon(value)
if type(value)=="number" or type(value)=="string" and value:match("^%d+$") then
return "rbxthumb://type=Asset&w=150&h=150&id="..tostring(value)
end
return type(value)=="string" and value or ""
end
local function chosen(kind)
local on,id=skins.GetState(kind)
if not on then return nil end
local data=originals.Metadata[kind] and originals.Metadata[kind][id]
return data and icon(data.image or data.itemid)
end
local function indexImage(value,kind)
local key=imageKey(value)
if key=="" then return end
if imageKinds[key] and imageKinds[key]~=kind then imageKinds[key]=false
elseif imageKinds[key]~=false then imageKinds[key]=kind end
end
for _,kind in ipairs({"Gun","Knife"}) do
for _,data in pairs(originals.Metadata[kind] or {}) do indexImage(data.image or data.itemid,kind) end
for _,value in ipairs(originals.NativeIcons and originals.NativeIcons[kind] or {}) do indexImage(value,kind) end
end
pcall(function()
local database=game:GetService("ReplicatedStorage"):FindFirstChild("Database")
local sync=database and database:FindFirstChild("Sync")
local module=sync and sync:FindFirstChild("Item")
local data=module and module:IsA("ModuleScript") and require(module)
if not data and sync and sync:IsA("ModuleScript") then
local all=require(sync);data=type(all)=="table" and (all.Item or all.Weapons)
end
for _,entry in pairs(type(data)=="table" and data or {}) do
if type(entry)=="table" and (entry.ItemType=="Gun" or entry.ItemType=="Knife") then
indexImage(entry.Image or entry.Icon or entry.ItemID,entry.ItemType)
end
end
end)
local function disconnect(list)
for _,connection in ipairs(list) do connection:Disconnect() end
table.clear(list)
end
local function restoreTool(tool,record)
if record.connection then record.connection:Disconnect() end
pcall(function() if tool.TextureId==record.applied then tool.TextureId=record.native end end)
tools[tool]=nil
end
local function restoreImage(object,record)
record.writing=true
pcall(function() if object.Image==record.applied then
object.Image=record.native end end)
record.writing=false
record.applied=nil
end
local hudNames={equip=true,equipbutton=true,touchbinding=true,touchbindings=true,backpack=true,inventory=true,inventory2=true,
hotbar=true,toolbar=true,toolslots=true,itembar=true,tools=true,mobile=true,phone=true,touch=true}
local excluded={shop=true,trade=true,trading=true,spectate=true,
spectating=true,roundend=true,endround=true,roundresults=true,victory=true,results=true,
emotesmenu=true,emotes=true,emote=true,emoteslist=true,emotewheel=true,playerlist=true,
settingsshield=true,ingamemenu=true,topbarapp=true,experiencechat=true,bubblechat=true}
local nameCache=setmetatable({}, {__mode="k"})
local function compactName(object)
local name=object.Name
local cached=nameCache[object]
if cached and cached[1]==name then return cached[2] end
local value=name:lower():gsub("[^%w]","")
nameCache[object]={name,value}
return value
end
local function excludedName(name)
return excluded[name] or name:find("trade",1,true)~=nil or name:find("emote",1,true)~=nil
end
local referenceMemo=setmetatable({}, {__mode="k"})
local referenceFrame=0
connections[#connections+1]=RunService.Heartbeat:Connect(function() referenceFrame=referenceFrame+1 end)
local function referenceKind(current)
local memo=referenceMemo[current]
if memo and memo.frame==referenceFrame then return memo.kind,memo.ambiguous end
local candidate,ambiguous
local references=current:GetChildren()
local refs=current:FindFirstChild("Values") or current:FindFirstChild("Data")
if refs then for _,reference in ipairs(refs:GetChildren()) do references[#references+1]=reference end end
for _,reference in ipairs(references) do
if reference:IsA("ObjectValue") and reference.Value and reference.Value:IsA("Tool") then
local kind=skins.GetKind(reference.Value)
if candidate and kind and candidate~=kind then ambiguous=true;break end
candidate=kind or candidate
end
end
referenceMemo[current]={frame=referenceFrame,kind=candidate,ambiguous=ambiguous}
return candidate,ambiguous
end
local excludedSet=setmetatable({}, {__mode="k"})
local function excludedAncestor(object)
if excludedSet[object] then return true end
if object:GetAttribute("VisualsV2_InventoryVisual") then return true end
local name=compactName(object)
if excludedName(name) then excludedSet[object]=true;return true end
if name=="inventory" or name=="inventory2" then
local main=object:FindFirstChild("Main") or object
if main:FindFirstChild("Weapons") or main:FindFirstChild("Effects") or main:FindFirstChild("Pets") then
excludedSet[object]=true;return true
end
end
return false
end
local function context(object)
local probe=object
while probe and not hudRoots[probe] do
if excludedAncestor(probe) then return nil end
probe=probe.Parent
end
if not probe then return nil end
local current=object
local allowed=false
local fixed
while current and not hudRoots[current] do
if current:GetAttribute("VisualsV2_InventoryVisual") then return nil end
local name=compactName(current)
if name=="inventory" or name=="inventory2" then
local main=current:FindFirstChild("Main") or current
if main:FindFirstChild("Weapons") or main:FindFirstChild("Effects") or main:FindFirstChild("Pets") then return nil end
end
if hudNames[name] or name:find("equip",1,true) or name:find("touch",1,true)
or name:find("backpack",1,true) or name:find("hotbar",1,true) or name:find("toolbar",1,true) then allowed=true end
if not fixed and (name=="gun" or name=="knife") then fixed=name=="gun" and "Gun" or "Knife" end
if not fixed then
local candidate,ambiguous=referenceKind(current)
if not ambiguous then fixed=candidate;if candidate then allowed=true end end
end
current=current.Parent
end
return current and hudRoots[current] and allowed, fixed
end
local tradeState=env.VisualsV2Runtime.Trade
local function excludeTradeImage(object,record)
-- A queued callback from an earlier observation must never restore another record's icon.
if record and images[object]~=record then
if record.connection then record.connection:Disconnect() end
return true
end
if not tradeState or type(tradeState.InWindow)~="function" or not tradeState.InWindow(object) then return false end
if record then
-- Undo this addon's last icon only; disconnect before native trade updates continue.
if record.connection then record.connection:Disconnect() end
images[object]=nil
restoreImage(object,record)
end
return true
end
local function updateImage(object,record)
if excludeTradeImage(object,record) then return end
local allowed,fixed=context(object)
if not allowed then restoreImage(object,record);return end
record.fixed=fixed
local kind=record.fixed or imageKinds[imageKey(record.native)]
local desired=kind and chosen(kind)
if desired and imageKey(record.native)==imageKey(desired) then
for _,toolRecord in pairs(tools) do
if toolRecord.kind==kind and toolRecord.native and imageKey(toolRecord.native)~=imageKey(desired) then
record.native=toolRecord.native
break
end
end
end
if desired and desired~="" then
if object.Image~=desired then
record.writing=true;object.Image=desired;record.writing=false
end
record.applied=desired
else restoreImage(object,record) end
end
local function consider(object)
if excludeTradeImage(object,images[object]) then return end
if images[object] or not (object:IsA("ImageLabel") or object:IsA("ImageButton")) then return end
local allowed,fixed=context(object)
if not allowed then return end
local record={native=object.Image,fixed=fixed,writing=false}
images[object]=record
record.connection=object:GetPropertyChangedSignal("Image"):Connect(function()
if excludeTradeImage(object,record) then return end
if not record.writing then
if object.Image~=record.applied then record.native=object.Image end
if schedule then schedule() end
end
end)
updateImage(object,record)
end
local active=false
refresh=function()
if not alive or not runtimeAlive or not active then return end
local seen={}
local character=LocalPlayer.Character
local backpack=LocalPlayer:FindFirstChildOfClass("Backpack")
for _,container in pairs({character,backpack}) do
for _,tool in ipairs(container:GetChildren()) do
local kind=tool:IsA("Tool") and skins.GetKind(tool)
local desired=kind and chosen(kind)
if desired and desired~="" then
seen[tool]=true
local record=tools[tool]
if not record then
record={native=tool.TextureId,writing=false,kind=kind}
tools[tool]=record
indexImage(record.native,kind)
record.connection=tool:GetPropertyChangedSignal("TextureId"):Connect(function()
if not record.writing then
if tool.TextureId~=record.applied then
record.native=tool.TextureId;indexImage(record.native,kind)
end
if schedule then schedule() end
end
end)
end
if tool.TextureId~=desired then
record.writing=true;tool.TextureId=desired;record.writing=false
end
record.applied=desired
end
end
end
for tool,record in pairs(tools) do if not seen[tool] then restoreTool(tool,record) end end
for object,record in pairs(images) do
local inRoot=false
for root in pairs(hudRoots) do if object:IsDescendantOf(root) then inRoot=true;break end end
if not object.Parent or not inRoot then
record.connection:Disconnect();images[object]=nil
else updateImage(object,record) end
end
end
schedule=function()
if queued or not alive or not runtimeAlive then return end
queued=true
task.defer(function() queued=false;if alive and runtimeAlive then refresh() end end)
end
local imageBatch=env.VisualsV2Runtime.MakeBatcher(function(object)
if not alive or not runtimeAlive or not object.Parent then return end
if object:GetAttribute("VisualsV2_Card") then return end
if tradeState and type(tradeState.InWindow)=="function" and tradeState.InWindow(object) then return end
consider(object)
end,0.002,200)
local imageClasses={ImageLabel=true,ImageButton=true}
local function queueImage(object)
if imageClasses[object.ClassName] then imageBatch.Push(object) end
end
if tradeState then
tradeState.OnChanged(function(trading)
if trading then
imageBatch.Clear()
for object,record in pairs(images) do excludeTradeImage(object,record) end
return
end
if not active or not alive or not runtimeAlive or not playerGui then return end
local gui=playerGui
local ok,objects=pcall(function() return gui:GetDescendants() end)
if ok then
local started=os.clock()
for index,object in ipairs(objects) do
if not active or not alive or not runtimeAlive or playerGui~=gui or tradeState.active then break end
queueImage(object)
if index%200==0 and os.clock()-started>=bootBudget(0.002) then task.wait();started=os.clock() end
end
end
if schedule then schedule() end
end)
end
local function bindGui()
disconnect(guiConnections)
imageBatch.Clear()
for object,record in pairs(images) do restoreImage(object,record);record.connection:Disconnect() end
table.clear(images)
table.clear(hudRoots)
playerGui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
if playerGui then hudRoots[playerGui]=true end
pcall(function() hudRoots[game:GetService("CoreGui")]=true end)
local getUI=gethui or env.gethui
if type(getUI)=="function" then
local ok,root=pcall(getUI)
if ok and typeof(root)=="Instance" then hudRoots[root]=true end
end
for root in pairs(hudRoots) do
local ok,objects=pcall(function() return root:GetDescendants() end)
if ok then
task.spawn(function()
local started=os.clock()
for index,object in ipairs(objects) do
if not active or not alive or not runtimeAlive or not hudRoots[root] then return end
queueImage(object)
if index%200==0 and os.clock()-started>=bootBudget(0.002) then task.wait();started=os.clock() end
end
end)
local connected,connection=pcall(function() return root.DescendantAdded:Connect(function(object)
if not active or not alive or not runtimeAlive then return end
if tradeState and (tradeState.active or tradeState.InWindow(object)) then return end
queueImage(object)
if object:IsA("ObjectValue") and object.Parent then
referenceMemo[object.Parent]=nil
task.defer(function()
if not alive or not runtimeAlive or not object.Parent then return end
for _,image in ipairs(object.Parent:GetDescendants()) do queueImage(image) end
schedule()
end)
end
end) end)
if connected then guiConnections[#guiConnections+1]=connection end
else hudRoots[root]=nil end
end
schedule()
end
local function sleep()
disconnect(guiConnections)
imageBatch.Clear()
for object,record in pairs(images) do restoreImage(object,record);record.connection:Disconnect() end
table.clear(images)
table.clear(hudRoots)
for tool,record in pairs(tools) do restoreTool(tool,record) end
end
local function updateActive()
local gun,knife=chosen("Gun"),chosen("Knife")
local wanted=(type(gun)=="string" and gun~="") or (type(knife)=="string" and knife~="")
if wanted==active then return end
active=wanted
if active then bindGui() else sleep() end
end
connections[#connections+1]=LocalPlayer.ChildAdded:Connect(function(object)
if not active then return end
if object:IsA("PlayerGui") then bindGui() else schedule() end
end)
connections[#connections+1]=LocalPlayer.ChildRemoved:Connect(function(object)
if active and object==playerGui then bindGui() end
end)
connections[#connections+1]=LocalPlayer.CharacterAdded:Connect(schedule)
connections[#connections+1]=skins.Changed:Connect(function()
if alive and runtimeAlive then updateActive();schedule() end
end)
local elapsed=0
connections[#connections+1]=RunService.Heartbeat:Connect(function(dt)
elapsed=elapsed+dt
if elapsed>=0.25 then elapsed=0;updateActive();refresh() end
end)
env.VisualsV2Runtime.WeaponPresentation={Refresh=refresh,GetNativeIcon=function(tool)
local record=tools[tool]
return record and record.native or tool.TextureId
end,}
env.VisualsV2Runtime.RegisterReset(function()
for tool,record in pairs(tools) do restoreTool(tool,record) end
for object,record in pairs(images) do restoreImage(object,record) end
if not runtimeAlive then
alive=false;disconnect(connections);disconnect(guiConnections)
for _,record in pairs(images) do record.connection:Disconnect() end
table.clear(images)
end
end)
updateActive()
end,"Part at line 14387")
;vv2Section(function()
-- Batch/initialization work retains virtualization with the documented fast preset.
LPH_ATTRIBUTES(PRESET(FAST))
if not inMurderMystery then return end
if not env.VisualsV2Runtime.WeaponsUnlocked() then
local section=mainTab:AddSection("[CONTENT LOCKED]","Restricted")
section:AddParagraph("Restricted Access","This section is locked and is not available for public access.\n\nIf you've been given an access key, enter it below and re-execute Visuals V2 to load it.")
section:AddTextBox("Access Key",function(text)
text=(tostring(text or ""):gsub("^%s+",""):gsub("%s+$",""))
if env.VisualsV2Runtime.WeaponsUnlocked(text) then
SetCfg("vv2WeaponUnlock",text)
pcall(shared.Notify,"Access granted, re-execute Visuals V2 to load it",2)
elseif text~="" then
pcall(shared.Notify,"Access denied: invalid key",0)
end
end)
return
end
local section=mainTab:AddSection("Visual Weapons/Effects","Cosmetic")
local skins=env.VisualsV2Runtime.ClientWeaponSkins
local effects=env.VisualsV2Runtime.ClientKnifeEffects
local pets=env.VisualsV2Runtime.ClientPets
local storage=game:GetService("ReplicatedStorage")
local mmv=game.GameId==10413186812 or game.GameId==10769671266 or game.PlaceId==93017634738276 or game.PlaceId==81374640397860
section:AddParagraph("Client-Sided Visuals","Weapons / Knife Effects / Pets\n\nOnce enabled, please check your mm2/mmv inventory.")
local gunAudio=env.VisualsV2Runtime.GunCosmetics
addToggle(section,"Use Weapon Shoot Sounds",gunAudio.GetSoundsEnabled(),function(value)
gunAudio.SetSoundsEnabled(value)
end)
local MARKER="VisualsV2_InventoryVisual"
local alive=true
local records={}
local connections={}
local guiConnections={}
local nativeButtons={}
local playerGui=nil
local queued=false
local inventoryObserversOn=false
local nativeDataReady=false
local refresh,schedule,visible
local tradeRoots={}
local sortRanks={}
local sortReady=false
local discoveryDirty=true
local nativeData={}
local infoCache={}
local ownedCache={}
local inventoryModule=nil
local profile=nil
local controls={}
local stats={filterRuns=0,builds=0,cardsCreated=0,cardsRemoved=0,uiPolls=0,discoveries=0,publishYields=0,imagesLoaded=0}
local loadVisibleImages
local definitions={
Gun={label=mmv and "Matrixscope / Voidscope" or "Guns",key=mmv and "clientScopeEnabled" or "clientGunEnabled",entries=skins.Catalog.Gun},
Knife={label="Knives",key="clientKnifeEnabled",entries=skins.Catalog.Knife},
Effects={label="Effects",key="vv2KnifeEffectsEnabled",entries=effects.Catalog},
Pets={label="Pets",key="vv2PetsEnabled",entries=pets.Catalog},
}
local rarityColours={Unique=Color3.fromRGB(255,140,0),Ancient=Color3.fromRGB(105,40,180),
Secret=Color3.fromRGB(140,55,220),Godly=Color3.fromRGB(255,0,255),Classic=Color3.fromRGB(255,220,0),
Legendary=Color3.fromRGB(255,0,0),Rare=Color3.fromRGB(0,110,255),Uncommon=Color3.fromRGB(0,170,85),
Common=Color3.fromRGB(95,95,95)}
local function disconnect(items)
for _,connection in ipairs(items) do pcall(function() connection:Disconnect() end) end
table.clear(items)
end
local inventoryNames=setmetatable({}, {__mode="k"})
local function inventoryName(object)
local name=object.Name
local cached=inventoryNames[object]
if cached and cached[1]==name then return cached[2] end
local value=name:lower():gsub("[^%w]","")
inventoryNames[object]={name,value}
return value
end
local function excludedInventory(object)
local current=object
while current and current~=playerGui do
local name=inventoryName(current)
if name:find("trade",1,true) or name:find("trading",1,true) or name=="shop"
or name=="spectate" or name=="inspectinventory" or name=="viewinventory" then return true end
current=current.Parent
end
return current~=playerGui
end
local function tradeRoot(object)
if not object.Name:find("[Tt][Rr][Aa][Dd]") then return false end
if not (object:IsA("GuiObject") or object:IsA("ScreenGui")) or object:IsA("GuiButton") then return false end
local name=inventoryName(object)
return name=="trade" or name=="trading" or name=="tradegui" or name=="tradinggui"
or name=="tradeframe" or name=="tradewindow" or name=="tradescreen"
end
local function inTrade()
local sharedTrade=env.VisualsV2Runtime.Trade
if sharedTrade and sharedTrade.active then return true end
for object in pairs(tradeRoots) do
if not object.Parent then tradeRoots[object]=nil
elseif visible(object) then return true end
end
return false
end

local function own(object)
while object and object~=playerGui do
if object:GetAttribute(MARKER) then return true end
object=object.Parent
end
return false
end
local function state(kind)
if kind=="Effects" then return effects.GetState() end
if kind=="Pets" then return pets.GetState() end
return skins.GetState(kind)
end
local function enabled(kind)
local on=state(kind)
return on and (not mmv or kind=="Gun")
end
local preloadQueue={}
local imageQueued={}
local imageLoaded={}
local preloading=false
local providerOk,contentProvider=pcall(function() return game:GetService("ContentProvider") end)
local function preloadImage(value)
if not providerOk or type(value)~="string" or value=="" or imageQueued[value] or imageLoaded[value] then return end
imageQueued[value]=true;preloadQueue[#preloadQueue+1]=value
if preloading then return end
preloading=true
task.defer(function()
while alive and runtimeAlive and #preloadQueue>0 do
local batch={}
for _=1,math.min(32,#preloadQueue) do batch[#batch+1]=table.remove(preloadQueue,1) end
local ok=pcall(function() contentProvider:PreloadAsync(batch) end)
for _,asset in ipairs(batch) do imageQueued[asset]=nil;if ok then imageLoaded[asset]=true end end
task.wait()
end
preloading=false
end)
end
local function selectItem(kind,id)
if kind=="Effects" then return effects.Select(id) end
if kind=="Pets" then return pets.Select(id) end
return skins.Select(kind,id)
end
local function requireKnown(parent,name)
local object=parent and parent:FindFirstChild(name)
if not object or not object:IsA("ModuleScript") then return nil end
local ok,result=pcall(require,object)
return ok and type(result)=="table" and result or nil
end
local function readNativeData()
local database=storage:FindFirstChild("Database")
local sync=database and database:FindFirstChild("Sync")
local data=requireKnown(database,"Sync")
nativeData.Weapons=requireKnown(sync,"Item") or data and (data.Item or data.Weapons) or {}
nativeData.Effects=requireKnown(sync,"Effects") or data and data.Effects or {}
nativeData.Pets=requireKnown(sync,"Pets") or data and data.Pets or {}
nativeData.Rarity=data and (data.Rarities or data.Rarity) or {}
local modules=storage:FindFirstChild("Modules")
inventoryModule=requireKnown(modules,"InventoryModule")
profile=requireKnown(modules,"ProfileData")
local remotes=storage:FindFirstChild("Remotes")
local inventory=remotes and remotes:FindFirstChild("Inventory")
for _,name in ipairs({"InventoryDataChanged","ProfileDataChanged"}) do
local event=inventory and inventory:FindFirstChild(name)
if event and event:IsA("BindableEvent") then
connections[#connections+1]=event.Event:Connect(function()
for _,record in pairs(records) do record.dirty=true;record.dirtyOwned=true end
if schedule then schedule() end
end)
end
end
end
local function holiday(value)
if type(value)~="string" then return nil end
local name=value:lower()
if name=="christmas" or name=="xmas" then return "Christmas" end
if name=="halloween" then return "Halloween" end
end
local function inventoryClass(entry,data)
if entry.id=="Matrixscope" or entry.id=="Voidscope" then return "Halloween" end
local event=holiday(data.Event)
if event then return event end
if data.Season~=nil and data.Season~=false then
local season=tonumber(data.Season) or tonumber(tostring(data.Season):match("%d+"))
return season and season>0 and "Current" or "Classic"
end
if data.Chroma then
local baseId=entry.id:gsub("Chroma","")
local base=baseId~=entry.id and nativeData.Weapons[baseId]
local saved=baseId~=entry.id and (skins.Catalog.Gun[baseId] or skins.Catalog.Knife[baseId])
if base or saved then
base=base or saved.data
return inventoryClass({id=baseId},{Event=base.Event or base.event,Season=base.Season or base.season,
Year=base.Year or base.year,Rarity=base.Rarity or base.rarity})
end
end
local year=tonumber(data.Year) or tonumber(entry.id:match("(20%d%d)"))
return year and year>=2019 and "Current" or "Classic"
end
local function info(kind,entry)
local key=kind..":"..entry.id
if infoCache[key] then return infoCache[key] end
local group=(kind=="Effects" or kind=="Pets") and kind or "Weapons"
local original=nativeData[group] and nativeData[group][entry.id]
local data={}
if type(original)=="table" then for key,value in pairs(original) do data[key]=value end end
local saved=entry.data or {}
data.ItemName=data.ItemName or data.Name or saved.itemname or saved.name or entry.name or entry.id
data.ItemType=kind=="Effects" and "Effect" or kind=="Pets" and "Pet" or kind
data.Rarity=data.Rarity or saved.rarity or "Common"
data.Image=data.Image or data.Icon or saved.image or saved.itemid
data.Event=data.Event or saved.event
data.Year=data.Year or saved.year
data.Season=data.Season or saved.season
data.Chroma=data.Chroma or saved.chroma
if data.FX==nil then data.FX=saved.fx==true end
if entry.games then
data.ItemName=entry.id;data.FX=true;data.ScopeStyle=true
end
if entry.id=="Matrixscope" or entry.id=="Voidscope" then data.Season=nil;data.Event="Halloween";data.Year="2025" end
data.InventoryClass=(kind=="Effects" or kind=="Pets") and "Current" or inventoryClass(entry,data)
infoCache[key]=data
return data
end
local function rarityColour(data)
local value=nativeData.Rarity and nativeData.Rarity[data.Rarity]
if typeof(value)=="Color3" then return value end
local color=type(value)=="table" and value.Color
if typeof(color)=="Color3" then return color end
if type(color)=="table" and color.r and color.g and color.b then return Color3.fromRGB(color.r,color.g,color.b) end
return rarityColours[data.Rarity] or rarityColours.Common
end
local function image(value)
if type(value)=="number" or (type(value)=="string" and value:match("^%d+$")) then
return "rbxthumb://type=Asset&w=150&h=150&id="..tostring(value)
end
return type(value)=="string" and value or ""
end
local function child(object,name)
return object and object:FindFirstChild(name)
end
local function categoryFor(main,kind)
local names=kind=="Effects" and {"Effects","WeaponEffects","KnifeEffects","Effect"} or kind=="Pets" and {"Pets","Pet"} or {"Weapons"}
for _,name in ipairs(names) do
local object=child(main,name)
if object then return object end
end
local gui=inventoryModule and inventoryModule.GUI
local object=type(gui)=="table" and gui[(kind=="Effects" or kind=="Pets") and kind or "Weapons"]
if typeof(object)=="Instance" and object:IsDescendantOf(main) then return object end
end
local function itemsFor(main,kind)
local category=categoryFor(main,kind)
return child(category,"Items") or child(category,"ItemList") or category
end
local function fill(frame,data,lazyImage)
local title=child(frame,"ItemName")
local label=child(title,"Label")
local coloured=child(title,"ColoredName")
local container=child(frame,"Container")
local icon=child(container,"Icon")
local amount=child(container,"Amount")
if label then label.Text=data.ItemName end
if coloured then coloured.Text=data.ItemName end
if title and title:IsA("GuiObject") then
title.BackgroundColor3=data.ScopeStyle and Color3.fromRGB(45,45,45) or rarityColour(data)
end
if data.ScopeStyle then
if label then label.Visible=true;label.TextColor3=Color3.new(1,1,1) end
if coloured then coloured.Visible=false end
end
if icon then
icon.Image=lazyImage and "" or image(data.Image)
if not lazyImage then preloadImage(icon.Image) end
end
if amount then amount.Text="" end
local tags=child(frame,"Tags")
if tags then
for _,tag in ipairs(tags:GetChildren()) do
if tag:IsA("GuiObject") then
tag.Visible=(tag.Name=="Chroma" and data.Chroma==true)
or (tag.Name=="FX" and data.FX==true)
local year=child(tag,"Year")
if year then year.Text=tostring(data.Year or "") end
end
end
end
end
local function cloneFrame(source,clean)
if not source then return nil end
local original=source.Archivable
pcall(function() source.Archivable=true end)
local ok,clone=pcall(function() return source:Clone() end)
pcall(function() source.Archivable=original end)
if not ok or not clone then return nil end
clone:SetAttribute(MARKER,true)
if not clean then
for _,object in ipairs(clone:GetDescendants()) do
if object:IsA("LuaSourceContainer") then object:Destroy() end
end
end
return clone
end
local function templateFor(main,kind)
local services=storage:FindFirstChild("ClientServices")
local source=child(child(services,"ItemService"),"ItemFrame")
local items=itemsFor(main,kind)
if items and (items:IsA("ScrollingFrame") or child(items,"ItemList")) and source then return source end
local legacy=child(storage:FindFirstChild("Modules"),"InventoryModule")
local old=child(legacy,"NewItem")
if old then return old end
if source then return source end
if items then
for _,frame in ipairs(items:GetDescendants()) do
if not own(frame) and child(child(frame,"Container"),"ActionButton")
and child(child(frame,"ItemName"),"Label") then return frame end
end
end
end
local function targetFor(main,kind,data)
local items=itemsFor(main,kind)
if not items then return nil end
if items:IsA("ScrollingFrame") then return items end
local modern=child(items,"ItemList")
if modern then return modern end
local container=child(items,"Container") or items
if container:IsA("ScrollingFrame") then return container end
local class=data.InventoryClass or "Current"
local target=child(container,class)
if class=="Current" then target=target or child(container,"Season1") or child(container,"Season 1") end
if not target then target=child(child(child(container,"Holiday"),"Container"),class) end
if target then return child(target,"Container") or target end
if kind=="Effects" or kind=="Pets" then
return container:FindFirstChildWhichIsA("ScrollingFrame",true)
or (container:FindFirstChildWhichIsA("UIGridLayout") and container)
end
end
-- (the order the game's own inventory uses: its rarity Sort numbers (Database.Sync.Rarities), then the
-- item's name, then its item id (so "ChromaDarkbringer" comes before "Darkbringer", "Deathshard" before
-- "DeathshardChroma"))
local rarityOrder={Secret=65,Unique=70,Ancient=75,Godly=80,Legendary=85,Rare=90,Uncommon=95,Common=100,
Halloween=104,Christmas=105,Classic=110,Vintage=110}
local iconEntries={}
local function imageKey(value)
value=tostring(value or ""):lower()
return value:match("rbxassetid://(%d+)") or value:match("[?&]assetid=(%d+)")
or value:match("[?&]id=(%d+)") or value:match("^(%d+)$") or value
end
local function prepareSort()
if sortReady then return end
sortReady=true
local entries={}
for kind,definition in pairs(definitions) do
definition.sorted={}
for _,entry in pairs(definition.entries) do
local data=info(kind,entry)
local item={entry=entry,kind=kind,data=data}
entries[#entries+1]=item
local key=imageKey(image(data.Image))
local candidates=iconEntries[key] or {};iconEntries[key]=candidates;candidates[#candidates+1]=item
end
end
for _,item in ipairs(entries) do
item.rank=rarityOrder[item.data.Rarity] or 108
item.chroma=item.data.Chroma==true
item.name=item.data.ItemName:lower()
end
table.sort(entries,function(a,b)
if a.rank~=b.rank then return a.rank<b.rank end
if a.name~=b.name then return a.name<b.name end
if a.entry.id~=b.entry.id then return a.entry.id<b.entry.id end
return a.kind<b.kind
end)
for rank,item in ipairs(entries) do
sortRanks[item.kind..":"..item.entry.id]=rank
local sorted=definitions[item.kind].sorted;sorted[#sorted+1]=item.entry
end
end
local function restoreNativeOrders(record)
for frame,saved in pairs(record.nativeOrders) do
if frame.Parent and frame.LayoutOrder==saved.applied then frame.LayoutOrder=saved.value end
end
table.clear(record.nativeOrders)
for layout,value in pairs(record.layouts) do
if layout.Parent and layout.SortOrder==Enum.SortOrder.LayoutOrder then layout.SortOrder=value end
end
table.clear(record.layouts)
end
local function sortNativeCards(record)
prepareSort()
local function arrange(frame,kind,id)
if typeof(frame)~="Instance" or not frame:IsA("GuiObject") or own(frame)
or not frame:IsDescendantOf(record.main) or excludedInventory(frame) then return end
local rank=sortRanks[kind..":"..tostring(id)]
if not rank then return end
local saved=record.nativeOrders[frame]
if not saved then saved={value=frame.LayoutOrder};record.nativeOrders[frame]=saved
elseif frame.LayoutOrder~=saved.applied then saved.value=frame.LayoutOrder end
saved.applied=rank;frame.LayoutOrder=rank
end
local inventory=inventoryModule and inventoryModule.MyInventory and inventoryModule.MyInventory.Data
if type(inventory)=="table" then
for _,group in ipairs({"Weapons","Effects","Pets"}) do
for _,tab in pairs(inventory[group] or {}) do
if type(tab)=="table" then
for key,entry in pairs(tab) do
if type(entry)=="table" and entry.Frame then
local id=entry.ItemID or entry.ID or entry.Id or entry.ItemId or key
local kind=(group=="Effects" or group=="Pets") and group or entry.ItemType
if definitions[kind] then arrange(entry.Frame,kind,id) end
end
end
end
end
end
end
local seen={}
for _,kind in ipairs({"Gun","Knife","Effects","Pets"}) do
for _,entry in ipairs(definitions[kind].sorted or {}) do
local target=targetFor(record.main,kind,info(kind,entry))
if target and not seen[target] then
seen[target]=true
local layout=target:FindFirstChildOfClass("UIGridLayout") or target:FindFirstChildOfClass("UIListLayout")
if layout then
if record.layouts[layout]==nil then record.layouts[layout]=layout.SortOrder end
layout.SortOrder=Enum.SortOrder.LayoutOrder
end
for _,frame in ipairs(target:GetChildren()) do
if frame:IsA("GuiObject") and not own(frame) then
local id=frame:GetAttribute("ItemID") or frame:GetAttribute("WeaponID") or frame.Name
local group=(kind=="Effects" or kind=="Pets") and {kind} or {"Gun","Knife"}
local matched=false
for _,candidate in ipairs(group) do
if definitions[candidate].entries[id] then arrange(frame,candidate,id);matched=true;break end
end
if not matched then
local icon=child(child(frame,"Container"),"Icon")
local label=child(child(frame,"ItemName"),"Label")
local choices=icon and iconEntries[imageKey(icon.Image)] or {}
for _,item in ipairs(choices) do
if table.find(group,item.kind) and (not label or label.Text==item.data.ItemName) then
arrange(frame,item.kind,item.entry.id);break
end
end
end
end
end
end
end
end
end
local function removePreview(record,kind)
local preview=record.previews[kind]
if not preview then return end
record.previews[kind]=nil
disconnect(preview.connections)
pcall(function() preview.frame:Destroy() end)
if preview.original.Parent and preview.original.Visible==false then preview.original.Visible=preview.visible end
end
local function watchImages(record,target)
local viewport=target
while viewport and viewport~=record.main and not viewport:IsA("ScrollingFrame") do viewport=viewport.Parent end
if not viewport or not viewport:IsA("ScrollingFrame") then return nil end
if not record.imageWatches[viewport] then
record.imageWatches[viewport]=true
local function changed()
if record.imageQueued or record.allImagesLoaded then return end
record.imageQueued=true
task.delay(0.04,function()
record.imageQueued=false
if alive and runtimeAlive and records[record.main]==record and loadVisibleImages then loadVisibleImages(record) end
end)
end
for _,property in ipairs({"CanvasPosition","AbsoluteSize"}) do
record.imageConnections[#record.imageConnections+1]=viewport:GetPropertyChangedSignal(property):Connect(changed)
end
end
return viewport
end
local function watchCanvas(record,target)
if not target:IsA("ScrollingFrame") then return nil end
local automatic=target.AutomaticCanvasSize
if automatic==Enum.AutomaticSize.Y or automatic==Enum.AutomaticSize.XY then return nil end
local layout=target:FindFirstChildWhichIsA("UIGridLayout") or target:FindFirstChildWhichIsA("UIListLayout")
if not layout then return nil end
local canvas=record.canvases[target]
if canvas then canvas.count=canvas.count+1;return canvas end
canvas={target=target,count=1,native=target.CanvasSize,connections={},writing=false,queued=false,suspended=record.trading==true}
record.canvases[target]=canvas
local function resize()
if not alive or not runtimeAlive or not target.Parent or canvas.count<=0
or record.canvases[target]~=canvas or canvas.suspended or record.trading
or inTrade() or excludedInventory(target) then return end
if target.AutomaticCanvasSize==Enum.AutomaticSize.Y or target.AutomaticCanvasSize==Enum.AutomaticSize.XY then return end
local x=canvas.native.X
local size=UDim2.new(x.Scale,x.Offset,0,layout.AbsoluteContentSize.Y+8)
if target.CanvasSize~=size then
canvas.applied=size;canvas.writing=true
target.CanvasSize=size
canvas.writing=false
end
end
local function queueResize()
if canvas.queued or canvas.suspended or record.trading then return end
canvas.queued=true
task.defer(function() canvas.queued=false;resize() end)
end
canvas.queueResize=queueResize
canvas.connections[1]=layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(queueResize)
canvas.connections[2]=target:GetPropertyChangedSignal("CanvasSize"):Connect(function()
if record.canvases[target]~=canvas then return end
-- Native inventory/trade code owns its own writes. Never answer one by writing back.
if target.CanvasSize~=canvas.applied then canvas.native=target.CanvasSize end
end)
queueResize()
return canvas
end

local function releaseCanvas(record,canvas)
if not canvas then return end
canvas.count=canvas.count-1
if canvas.count>0 then return end
disconnect(canvas.connections)
record.canvases[canvas.target]=nil
if canvas.target.Parent and canvas.target.CanvasSize==canvas.applied then canvas.target.CanvasSize=canvas.native end
end
local function suspendCanvases(record)
for target,canvas in pairs(record.canvases) do
canvas.suspended=true
if target.Parent and target.CanvasSize==canvas.applied then target.CanvasSize=canvas.native end
end
end
local function resumeCanvases(record)
for target,canvas in pairs(record.canvases) do
if target.Parent and target.CanvasSize~=canvas.applied then canvas.native=target.CanvasSize end
canvas.suspended=false
if canvas.queueResize then canvas.queueResize() end
end
end
local function removeCard(record,key)
local card=record.cards[key]
if not card then return end
record.cards[key]=nil
stats.cardsRemoved=stats.cardsRemoved+1
disconnect(card.connections)
pcall(function() card.frame:Destroy() end)
releaseCanvas(record,card.canvas)
end
local function release(record)
record.generation=record.generation+1
record.building=false
restoreNativeOrders(record)
for kind in pairs(record.previews) do removePreview(record,kind) end
for key in pairs(record.cards) do removeCard(record,key) end
end
local function equippedSlot(main,kind)
local category=categoryFor(main,kind)
local container=child(child(category,"Equipped"),"Container")
if not container then return nil end
local slot=child(container,(kind=="Effects" or kind=="Pets") and "Item1" or kind)
if slot and slot:IsA("GuiObject") then return slot end
local candidates={}
for _,object in ipairs(container:GetChildren()) do
if not own(object) and child(object,"ItemFrame") then candidates[#candidates+1]=object end
end
if kind=="Effects" or kind=="Pets" then return candidates[1] end
return candidates[kind=="Knife" and 1 or 2]
end
local function updatePreview(record,kind)
local _,id=state(kind)
local entry=definitions[kind].entries[id]
if not enabled(kind) or not entry then removePreview(record,kind);return end
local original=equippedSlot(record.main,kind)
local previous=record.previews[kind]
if previous and previous.id==id and previous.original==original and previous.frame.Parent then
local content=child(previous.frame,"ItemFrame") or child(previous.frame,"Container")
if content and content:IsA("GuiObject") then content.Visible=true end
return
end
removePreview(record,kind)
if not original then return end
local frame=cloneFrame(original)
if not frame then return end
frame.Name="VisualsV2_Equipped"..kind
local itemFrame=child(frame,"ItemFrame") or child(frame,"Container") or frame
fill(itemFrame,info(kind,entry))
if itemFrame:IsA("GuiObject") then itemFrame.Visible=true end
frame.Visible=true
local preview={id=id,frame=frame,original=original,visible=original.Visible,connections={},writing=false}
record.previews[kind]=preview
local function hideOriginal()
if original.Visible then
preview.visible=true;preview.writing=true
original.Visible=false
preview.writing=false
end
end
preview.connections[#preview.connections+1]=original:GetPropertyChangedSignal("Visible"):Connect(function()
if not preview.writing and original.Visible then preview.visible=true;hideOriginal() end
end)
hideOriginal()
local function clearSelection()
if not alive or not runtimeAlive then return end
selectItem(kind,"None")
refresh()
end
for _,button in ipairs(frame:GetDescendants()) do
if button:IsA("GuiButton") then preview.connections[#preview.connections+1]=button.Activated:Connect(clearSelection) end
end
frame.Parent=original.Parent
end
visible=function(object)
if not object or not object.Parent then return false end
local current=object
while current and current~=playerGui do
if current:IsA("GuiObject") and not current.Visible then return false end
if current:IsA("ScreenGui") and not current.Enabled then return false end
current=current.Parent
end
return current==playerGui
end
local function categoryOpen(record,kind)
return visible(categoryFor(record.main,kind))
end
local loadAllImages
loadVisibleImages=function(record)
if record.trading or record.allImagesLoaded or inTrade() or not record.open then return end
local open={}
for _,card in pairs(record.cards) do
if open[card.kind]==nil and not card.imageLoaded then open[card.kind]=categoryOpen(record,card.kind) end
if not card.imageLoaded and open[card.kind] and card.frame.Parent==card.target and card.frame.Visible then
local viewport=card.viewport
local within=true
if viewport then
local p,size=card.frame.AbsolutePosition,card.frame.AbsoluteSize
local origin,bounds=viewport.AbsolutePosition,viewport.AbsoluteSize
local margin=math.max(size.Y,64)
within=size.Y>0 and p.Y+size.Y>=origin.Y-margin and p.Y<=origin.Y+bounds.Y+margin
and p.X+size.X>=origin.X-margin and p.X<=origin.X+bounds.X+margin
end
if within and card.icon then
card.icon.Image=image(card.data.Image)
card.imageLoaded=true;stats.imagesLoaded=stats.imagesLoaded+1
end
end
end
end
-- Every card's image fetched in the background once the cards are built (a batch at a time,
-- downloaded before it's shown), so scrolling the inventory never waits on an image.
loadAllImages=function(record)
if record.imageLoading or record.allImagesLoaded or record.trading or inTrade() then return end
record.imageLoading=true
local generation=record.generation
task.spawn(function()
local pending={}
for _,card in pairs(record.cards) do
if not card.imageLoaded and card.icon then pending[#pending+1]=card end
end
table.sort(pending,function(a,b) return (sortRanks[a.kind..":"..a.id] or 100000)<(sortRanks[b.kind..":"..b.id] or 100000) end)
local index=1
local stopped=false
while index<=#pending do
if not alive or not runtimeAlive or record.generation~=generation or record.trading or inTrade() then stopped=true;break end
local cards,batch,picked={},{},{}
while index<=#pending and #cards<24 do
local card=pending[index];index=index+1
if not card.imageLoaded and card.icon and card.frame.Parent then
local value=image(card.data.Image)
cards[#cards+1]=card
if value~="" and not imageLoaded[value] and not picked[value] then picked[value]=true;batch[#batch+1]=value end
end
end
if #batch>0 and providerOk then
local ok=pcall(function() contentProvider:PreloadAsync(batch) end)
if ok then for _,value in ipairs(batch) do imageLoaded[value]=true end end
end
if record.generation~=generation or record.trading then stopped=true;break end
for _,card in ipairs(cards) do
if not card.imageLoaded and card.icon then
card.icon.Image=image(card.data.Image)
card.imageLoaded=true;stats.imagesLoaded=stats.imagesLoaded+1
end
end
task.wait()
end
record.imageLoading=false
if not stopped and record.generation==generation then
local all=true
for _,card in pairs(record.cards) do if not card.imageLoaded and card.icon then all=false;break end end
record.allImagesLoaded=all
end
end)
end
local function updatePreviews(record)
for kind in pairs(definitions) do
if categoryOpen(record,kind) then updatePreview(record,kind) else removePreview(record,kind) end
end
end
local function cacheFilters(record)
if record.filterConnections then disconnect(record.filterConnections) end
record.filterConnections={}
record.filterRefs={}
local function changed()
record.filterDirty=true;record.dirty=true
if schedule then schedule() end
end
for _,name in ipairs({"Weapons","Effects","Pets"}) do
local category=categoryFor(record.main,(name=="Effects" or name=="Pets") and name or "Gun")
local items=itemsFor(record.main,(name=="Effects" or name=="Pets") and name or "Gun")
local tabs=child(items,"Tabs") or child(category,"Tabs") or child(category,"TitleBar")
local search=tabs and tabs:FindFirstChild("SearchText",true)
local refs={search=search,modern=items and (items:IsA("ScrollingFrame") or child(items,"ItemList")~=nil),borders={}}
record.filterRefs[name]=refs
if search then record.filterConnections[#record.filterConnections+1]=search:GetPropertyChangedSignal("Text"):Connect(changed) end
for _,tabName in ipairs({"Current","Classic","Event"}) do
local tab=child(tabs,tabName)
if tabName=="Current" then tab=tab or child(tabs,"Season1") or child(tabs,"Season 1") end
if tabName=="Event" then tab=tab or child(tabs,"Holiday") or child(tabs,"Holidays") end
local border=child(tab,"ViewBorder")
refs.borders[tabName]=border
if border then record.filterConnections[#record.filterConnections+1]=border:GetPropertyChangedSignal("Visible"):Connect(changed) end
end
if category then
record.filterConnections[#record.filterConnections+1]=category:GetPropertyChangedSignal("Visible"):Connect(function()
record.dirty=true
if schedule then schedule() end
end)
end
end
record.filterDirty=true
end
local function readFilters(record)
if not record.filterRefs then cacheFilters(record) end
record.filters={}
for name,refs in pairs(record.filterRefs) do
local filter={query=refs.search and refs.search.Text:lower() or "",modern=refs.modern}
for _,tabName in ipairs({"Current","Classic","Event"}) do
if refs.borders[tabName] and refs.borders[tabName].Visible then filter.class=tabName;break end
end
record.filters[name]=filter
end
end
local function matchesFilter(record,kind,data)
local filter=record.filters and record.filters[(kind=="Effects" or kind=="Pets") and kind or "Weapons"]
if not filter then return true end
local query=filter.query
local show=query=="" or data.ItemName:lower():find(query,1,true)~=nil
if filter.modern and kind~="Effects" and kind~="Pets" and query=="" and filter.class then
local class=data.InventoryClass
if class=="Christmas" or class=="Halloween" then class="Event" end
show=class==filter.class
end
return show
end
local function applyCardFilter(record,card)
local show=matchesFilter(record,card.kind,card.data)
if card.frame.Visible~=show then card.settingVisible=true;card.frame.Visible=show;card.settingVisible=false end
end
local function filterCards(record)
stats.filterRuns=stats.filterRuns+1
readFilters(record)
for _,card in pairs(record.cards) do applyCardFilter(record,card) end
record.filterDirty=false
updatePreviews(record)
loadVisibleImages(record)
end
local function addCard(record,kind,entry)
if inTrade() or excludedInventory(record.main) then return end
local key=kind..":"..entry.id
if record.cards[key] then return end
local data=info(kind,entry)
local target=targetFor(record.main,kind,data)
if not target then record.waiting[kind]="Inventory list unavailable";return end
local template=record.templates[kind]
if not template then
template=cloneFrame(templateFor(record.main,kind))
record.templates[kind]=template
if template then
for _,object in ipairs(template:GetDescendants()) do pcall(object.SetAttribute,object,"VisualsV2_Card",true) end
end
end
local frame=cloneFrame(template,true)
if not frame then record.waiting[kind]="Item template unavailable";return end
pcall(function() frame.Archivable=false end)
frame.Name="VisualsV2_"..kind.."_"..entry.id
frame:SetAttribute("WeaponID",entry.id)
frame:SetAttribute("VisualKind",kind)
fill(frame,data,true)
frame.LayoutOrder=sortRanks[kind..":"..entry.id] or 100000
local button=child(child(frame,"Container"),"ActionButton")
if not button or not button:IsA("GuiButton") then frame:Destroy();record.waiting[kind]="Item button unavailable";return end
local card={kind=kind,id=entry.id,frame=frame,data=data,target=target,connections={},canvas=watchCanvas(record,target),
viewport=watchImages(record,target),icon=child(child(frame,"Container"),"Icon")}
record.cards[key]=card
record.allImagesLoaded=false
stats.cardsCreated=stats.cardsCreated+1
card.connections[1]=button.Activated:Connect(function()
if not alive or not runtimeAlive or not enabled(kind) or inTrade() or excludedInventory(frame) then return end
if selectItem(kind,entry.id) then
for _,other in pairs(records) do updatePreviews(other) end
pcall(shared.Notify,"Visual Weapons/Effects: "..data.ItemName.." selected",2)
end
end)
applyCardFilter(record,card)
frame.Parent=record.staging
end
local tradeState=env.VisualsV2Runtime.Trade
local function trading()
return (tradeState and tradeState.active) or inTrade()
end
local nativeOwnedImages,nativeOwnedSource=nil,nil
local function plainName(value)
return type(value)=="string" and (value:lower():gsub("[^%w]","")) or nil
end
local function nativeEntryId(frame,kind,hint)
local entries=definitions[kind] and definitions[kind].entries
if not entries or typeof(frame)~="Instance" then return nil end
for _,value in ipairs({hint or false,frame:GetAttribute("ItemID") or false,frame:GetAttribute("WeaponID") or false,frame.Name}) do
if value and entries[tostring(value)] then return tostring(value) end
end
prepareSort()
local icon=child(child(frame,"Container"),"Icon")
if not icon then return nil end
local title=child(frame,"ItemName")
local label=child(title,"Label") or child(title,"ColoredName")
local text=label and label:IsA("TextLabel") and plainName(label.Text) or nil
if text=="" then text=nil end
local tag=child(child(frame,"Tags"),"Chroma")
local chroma=nil
if tag and tag:IsA("GuiObject") then chroma=tag.Visible end
local found=nil
for _,item in ipairs(iconEntries[imageKey(icon.Image)] or {}) do
local name=plainName(item.data.ItemName)
local named=not text or text==name or text==plainName(item.entry.name) or text=="chroma"..tostring(name)
if item.kind==kind and named and (chroma==nil or (item.data.Chroma==true)==chroma) then
if found and found~=item.entry.id then return nil end
found=item.entry.id
end
end
return found
end
local function observeNativeButtons(record)
if trading() then return end
local function bind(frame,kind,hint)
local button=child(child(frame,"Container"),"ActionButton")
if not button or nativeButtons[button] or not definitions[kind] or own(button)
or not button:IsDescendantOf(record.main) then return end
local lastClick=0
local function nativeSelected()
if not alive or not runtimeAlive or trading() or excludedInventory(button) then return end
if os.clock()-lastClick<0.2 then return end
lastClick=os.clock()
local id=(kind=="Gun" or kind=="Knife") and enabled(kind) and nativeEntryId(frame,kind,hint) or nil
if id and selectItem(kind,id) then
for _,other in pairs(records) do updatePreviews(other) end
else
selectItem(kind,"None")
end
task.defer(refresh)
end
local list={button.Activated:Connect(nativeSelected)}
list[#list+1]=button.MouseButton1Click:Connect(nativeSelected)
nativeButtons[button]=list
end
local data=inventoryModule and inventoryModule.MyInventory and inventoryModule.MyInventory.Data
if type(data)=="table" then
for _,group in ipairs({"Weapons","Effects","Pets"}) do
for _,tab in pairs(data[group] or {}) do
if type(tab)=="table" then
for key,entry in pairs(tab) do
if type(entry)=="table" and entry.Frame then
local id=entry.ItemID or entry.ID or entry.Id or entry.ItemId or key
bind(entry.Frame,(group=="Effects" or group=="Pets") and group or entry.ItemType,id)
end
end
end
end
end
end
local owned=profile and profile.Weapons and profile.Weapons.Owned or {}
local byImage=nativeOwnedSource==owned and nativeOwnedImages or nil
if not byImage or record.dirtyOwned then
byImage={}
for key,value in pairs(owned) do
local id=type(key)=="string" and key or value
local metadata=nativeData.Weapons[id]
if type(metadata)=="table" and (metadata.ItemType=="Gun" or metadata.ItemType=="Knife") then
local image=imageKey(metadata.Image or metadata.Icon or metadata.ItemID)
if byImage[image] and byImage[image]~=metadata.ItemType then byImage[image]=false
elseif byImage[image]~=false then byImage[image]=metadata.ItemType end
end
end
nativeOwnedImages,nativeOwnedSource=byImage,owned
record.dirtyOwned=false
end
for _,group in ipairs({"Weapons","Effects","Pets"}) do
local items=child(child(record.main,group),"Items")
local list=child(items,"ItemList")
if list then
for _,frame in ipairs(list:GetChildren()) do
if not own(frame) then
local icon=child(child(frame,"Container"),"Icon")
bind(frame,(group=="Effects" or group=="Pets") and group or icon and byImage[imageKey(icon.Image)])
end
end
end
end
end
local function nativeOwns(kind,id)
local name=(kind=="Effects" or kind=="Pets") and kind or "Weapons"
local cached=ownedCache[name]
if not cached then
cached={};ownedCache[name]=cached
local group=profile and profile[name]
for key,value in pairs(group and group.Owned or {}) do
if type(key)=="string" and type(value)=="number" and value>0 then cached[key]=true
elseif type(value)=="string" then cached[value]=true end
end
end
return cached[id]==true
end
local function suspendRecord(record)
if record.trading then return end
record.trading=true;record.generation=record.generation+1
record.building=false;record.dirty=true
suspendCanvases(record)
for kind in pairs(record.previews) do removePreview(record,kind) end
restoreNativeOrders(record)
-- (all at once: the native trade code must never see some of them still in the list)
for _,card in pairs(record.cards) do
if card.frame.Parent==card.target then pcall(function() card.frame.Parent=record.staging end) end
end
end
local function updateRecord(record)
if trading() or excludedInventory(record.main) then
record.tradeEndedAt=nil
suspendRecord(record);return
end
if record.trading then
local now=os.clock()
record.tradeEndedAt=record.tradeEndedAt or now
if now-record.tradeEndedAt<1 then return end
record.tradeEndedAt=nil
record.trading=false;record.dirty=true;record.filterDirty=true
resumeCanvases(record)
end
local isOpen=visible(record.main)
if record.open~=isOpen then record.filterDirty=true end
record.open=isOpen
if record.dirty then
table.clear(ownedCache)
for key,card in pairs(record.cards) do
if not enabled(card.kind) or not card.frame.Parent or not card.target.Parent
or nativeOwns(card.kind,card.id) then removeCard(record,key) end
end
observeNativeButtons(record)
end
if record.filterDirty then filterCards(record) end
if isOpen then loadVisibleImages(record)
else for kind in pairs(record.previews) do removePreview(record,kind) end end
if record.building or not record.dirty then return end
local settle=3-(os.clock()-bootStarted)
if settle>0 then
if not record.buildDelayed then
record.buildDelayed=true
task.delay(settle,function() record.buildDelayed=false;if schedule then schedule() end end)
end
return
end
prepareSort()
record.dirty=false;record.building=true;record.waiting={}
stats.builds=stats.builds+1
local generation=record.generation
task.spawn(function()
local count=0
local started=os.clock()
for _,kind in ipairs({"Gun","Knife","Effects","Pets"}) do
local definition=definitions[kind]
if enabled(kind) then
for _,entry in ipairs(definition.sorted) do
if not alive or not runtimeAlive or generation~=record.generation or not record.main.Parent then return end
if inTrade() then suspendRecord(record);return end
if not enabled(kind) then break end
if not nativeOwns(kind,entry.id) and not record.cards[kind..":"..entry.id] then
addCard(record,kind,entry);count=count+1
end
if count>=48 or os.clock()-started>=bootBudget(0.003) then
count=0;task.wait();started=os.clock()
end
end
end
end
if generation~=record.generation or not alive or not runtimeAlive then return end
if inTrade() then suspendRecord(record);return end
filterCards(record)
sortNativeCards(record)
local moved=0
for key,card in pairs(record.cards) do
if generation~=record.generation or not alive or not runtimeAlive then return end
if not enabled(card.kind) or not card.target.Parent or nativeOwns(card.kind,card.id) then removeCard(record,key)
elseif card.frame.Parent==record.staging and not excludedInventory(card.target) then
card.frame.Parent=card.target
moved=moved+1
local chunk=visible(record.main) and 150 or (os.clock()-bootStarted<10 and 20 or 40)
if moved>=chunk then
moved=0
task.wait()
if generation~=record.generation or not alive or not runtimeAlive then return end
if inTrade() then suspendRecord(record);return end
end
end
end
record.building=false
loadVisibleImages(record)
loadAllImages(record)
if record.dirty and schedule then schedule() end
end)
end
local function forgetRecord(record)
release(record)
if record.staging then record.staging:Destroy() end
disconnect(record.filterConnections or {})
disconnect(record.visibilityConnections or {})
disconnect(record.contentConnections or {})
disconnect(record.imageConnections or {})
for kind,template in pairs(record.templates) do template:Destroy();record.templates[kind]=nil end
end
local discovering=false
local function inventorySkipped(object)
if object:GetAttribute(MARKER) then return true end
local name=inventoryName(object)
return name:find("trade",1,true)~=nil or name:find("trading",1,true)~=nil or name=="shop"
or name=="spectate" or name=="inspectinventory" or name=="viewinventory"
end
local function discover()
if not playerGui then return end
if discovering then discoveryDirty=true;return end
discovering=true
stats.discoveries=stats.discoveries+1
local pending={playerGui}
local started=os.clock()
while #pending>0 do
if not alive or not runtimeAlive then break end
local object=table.remove(pending)
if tradeRoot(object) then tradeRoots[object]=true end
if object==playerGui or (object.Parent and not inventorySkipped(object)) then
local registered=false
if object.Name=="Inventory" or object.Name=="Inventory2" then
local main=child(object,"Main")
if main and child(main,"Weapons") then registered=true end
if main and child(main,"Weapons") and not records[main] then
local record={main=main,cards={},previews={},canvases={},templates={},waiting={},generation=0,
building=false,dirty=true,open=false,filterDirty=true,visibilityConnections={},imageWatches={},imageConnections={},
nativeOrders=setmetatable({}, {__mode="k"}),layouts=setmetatable({}, {__mode="k"}),contentConnections={}}
record.staging=Instance.new("Folder");record.staging.Name="VisualsV2_InventoryBuild"
records[main]=record
record.contentConnections[1]=main.DescendantRemoving:Connect(function(removed)
if record.trading or record.building then return end
if removed:GetAttribute(MARKER) and removed:GetAttribute("WeaponID") then
local key=tostring(removed:GetAttribute("VisualKind"))..":"..tostring(removed:GetAttribute("WeaponID"))
local card=record.cards[key]
if card and card.frame==removed and not record.trading and not record.building then
task.defer(function()
if records[main]==record and card.frame.Parent~=record.staging
and card.frame.Parent~=card.target then record.dirty=true;schedule() end
end)
end
end
end)
local ancestor=main
while ancestor and ancestor~=playerGui do
local property=ancestor:IsA("GuiObject") and "Visible" or ancestor:IsA("ScreenGui") and "Enabled"
if property then
record.visibilityConnections[#record.visibilityConnections+1]=ancestor:GetPropertyChangedSignal(property):Connect(function()
if schedule then schedule() end
end)
end
ancestor=ancestor.Parent
end
cacheFilters(record)
end
end
if not registered then
for _,item in ipairs(object:GetChildren()) do pending[#pending+1]=item end
end
end
if os.clock()-started>=bootBudget(0.002) then task.wait();started=os.clock() end
end
discovering=false
if discoveryDirty and alive and runtimeAlive and schedule then schedule() end
end
refresh=function()
if not alive or not runtimeAlive then return end
local active=enabled("Gun") or enabled("Knife") or enabled("Effects") or enabled("Pets")
if active and discoveryDirty then discoveryDirty=false;discover() end
for main,record in pairs(records) do
if not playerGui or not main:IsDescendantOf(playerGui) or not active then
forgetRecord(record);records[main]=nil
else updateRecord(record) end
end
end
schedule=function()
if not inventoryObserversOn or queued or not alive or not runtimeAlive then return end
queued=true
task.defer(function()
queued=false
if alive and runtimeAlive then
refresh()
end
end)
end
local bindGui
if tradeState and type(tradeState.OnChanged)=="function" then
tradeState.OnChanged(function(active)
if not alive or not runtimeAlive then return end
if active then
-- (the game rebuilds the whole inventory during a trade: nothing here listens to that)
for _,record in pairs(records) do
suspendRecord(record)
disconnect(record.contentConnections);disconnect(record.visibilityConnections)
end
disconnect(guiConnections)
elseif inventoryObserversOn then
for main,record in pairs(records) do forgetRecord(record);records[main]=nil end
bindGui()
end
end)
end
local interestingNames={Inventory=true,Inventory2=true,Main=true,Weapons=true,Effects=true,Pets=true,Items=true,
ItemList=true,WeaponEffects=true,ActionButton=true}
bindGui=function()
if not inventoryObserversOn then return end
discoveryDirty=true
table.clear(tradeRoots)
disconnect(guiConnections)
playerGui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
if playerGui then
local function watchTrade(object)
if not tradeRoot(object) or tradeRoots[object] then return end
tradeRoots[object]=true
local property=object:IsA("ScreenGui") and "Enabled" or "Visible"
guiConnections[#guiConnections+1]=object:GetPropertyChangedSignal(property):Connect(function()
if visible(object) then for _,record in pairs(records) do suspendRecord(record) end end
schedule()
end)
end
task.spawn(function()
local gui,started=playerGui,os.clock()
for index,object in ipairs(gui:GetDescendants()) do
if playerGui~=gui or not alive then return end
watchTrade(object)
if index%100==0 and os.clock()-started>=bootBudget(0.002) then task.wait();started=os.clock() end
end
end)
local added=function(object)
watchTrade(object)
if tradeRoots[object] and visible(object) then
for _,record in pairs(records) do suspendRecord(record) end
schedule()
end
local marked=object:GetAttribute(MARKER)
if not marked and not interestingNames[object.Name] then return end
if not marked and not (enabled("Gun") or enabled("Knife") or enabled("Effects") or enabled("Pets")) then return end
if not marked and tradeState and type(tradeState.InWindow)=="function" and tradeState.InWindow(object) then return end
if next(tradeRoots) and inTrade() and not marked then return end
if own(object) then
if object:GetAttribute(MARKER) and excludedInventory(object) then
if object:IsA("GuiObject") then object.Visible=false end
task.defer(function() if object.Parent and excludedInventory(object) then object:Destroy() end end)
end
return
end
if excludedInventory(object) then return end
if object.Name=="Inventory" or object.Name=="Inventory2" or object.Name=="Main"
or object.Name=="Weapons" or object.Name=="Effects" or object.Name=="Pets" or object.Name=="Items"
or object.Name=="ItemList" or object.Name=="WeaponEffects" or object.Name=="ActionButton" then
if not next(records) or object.Name=="Inventory" or object.Name=="Inventory2" or object.Name=="Main" then discoveryDirty=true end
for _,record in pairs(records) do record.dirty=true end
schedule()
end
end
guiConnections[#guiConnections+1]=playerGui.DescendantAdded:Connect(function(object)
if tradeState and tradeState.active and not object:GetAttribute(MARKER) then return end
added(object)
end)
end
schedule()
end
local function syncInventoryObservers()
local wanted=enabled("Gun") or enabled("Knife") or enabled("Effects") or enabled("Pets")
if wanted==inventoryObserversOn then return end
inventoryObserversOn=wanted
if wanted then
if not nativeDataReady then readNativeData();nativeDataReady=true end
bindGui()
else
-- No disabled feature keeps observing the game's native item rebuilds.
disconnect(guiConnections)
for main,record in pairs(records) do forgetRecord(record);records[main]=nil end
for button,list in pairs(nativeButtons) do disconnect(list);nativeButtons[button]=nil end
table.clear(tradeRoots)
nativeOwnedImages,nativeOwnedSource=nil,nil
playerGui=nil
discoveryDirty=true
end
end
for _,kind in ipairs({"Gun","Knife","Effects","Pets"}) do
local definition=definitions[kind]
if not mmv or kind=="Gun" then
controls[kind]=addToggle(section,definition.label,C(definition.key,false),function(value)
if kind=="Effects" then effects.SetEnabled(value) elseif kind=="Pets" then pets.SetEnabled(value) else skins.SetEnabled(kind,value) end
syncInventoryObservers()
for _,record in pairs(records) do record.dirty=true end
refresh()
end)
end
end
connections[#connections+1]=LocalPlayer.ChildAdded:Connect(function(object)
if inventoryObserversOn and object:IsA("PlayerGui") then bindGui() end
end)
connections[#connections+1]=LocalPlayer.ChildRemoved:Connect(function(object)
if object==playerGui then bindGui() end
end)
connections[#connections+1]=LocalPlayer.CharacterAdded:Connect(function()
task.defer(function()
if inventoryObserversOn and alive and runtimeAlive then skins.Refresh();effects.Refresh();pets.Refresh();refresh() end
end)
end)
local elapsed=0
connections[#connections+1]=RunService.Heartbeat:Connect(function(dt)
elapsed=elapsed+math.max(tonumber(dt) or 0,0)
if elapsed<0.4 then return end
elapsed=0
if not alive or not runtimeAlive then return end
syncInventoryObservers()
if not inventoryObserversOn then return end
stats.uiPolls=stats.uiPolls+1
for main,record in pairs(records) do
if playerGui and main:IsDescendantOf(playerGui) then
if record.dirty or record.filterDirty or record.trading or record.open~=visible(main) or inTrade() then updateRecord(record) end
else schedule() end
end
for button,list in pairs(nativeButtons) do
if not playerGui or not button:IsDescendantOf(playerGui) then disconnect(list);nativeButtons[button]=nil end
end
end)
env.VisualsV2Runtime.VisualWeaponInventory={
GetDiagnostics=function()
local report={observing=inventoryObserversOn,nativeDataLoaded=nativeDataReady,stats=table.clone(stats),inventories={},preloading=preloading or #preloadQueue>0,anyEnabled=false,recordCount=0,tradingRecords=0,buildingRecords=0,publishedCards=0,nativeButtonObservers=0}
for _ in pairs(nativeButtons) do report.nativeButtonObservers=report.nativeButtonObservers+1 end
for _,kind in ipairs({"Gun","Knife","Effects","Pets"}) do if enabled(kind) then report.anyEnabled=true end end
for _,record in pairs(records) do
report.recordCount=report.recordCount+1
if record.trading then report.tradingRecords=report.tradingRecords+1 end
if record.building then report.buildingRecords=report.buildingRecords+1 end
local count=0
for _,card in pairs(record.cards) do count=count+1;if card.frame.Parent==card.target then report.publishedCards=report.publishedCards+1 end end
report.inventories[#report.inventories+1]={name=record.main.Parent and record.main.Parent.Name,
open=record.open,cards=count,building=record.building,dirty=record.dirty==true,trading=record.trading==true,waiting=table.clone(record.waiting)}
end
return report
end,
}
env.VisualsV2Runtime.RegisterReset(function()
for _,control in pairs(controls) do control:Set(false) end
for main,record in pairs(records) do forgetRecord(record);records[main]=nil end
for button,list in pairs(nativeButtons) do disconnect(list);nativeButtons[button]=nil end
if not runtimeAlive then alive=false;disconnect(connections);disconnect(guiConnections) end
end)
syncInventoryObservers()
end,"Section \"Visual Weapons/Effects\"")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local section=mainTab:AddSection("Custom Knife/Gun","Visuals")
local legacyEnabled=C("gunsVisualEnabled",false)
local legacyColor=C("gunsTintColor",Color3.fromRGB(38,38,38))
local legacyRainbow=C("gunsRainbow",false)
local legacySpeed=C("gunsRainbowSpeed",3)
local tints={}
local highlighted=setmetatable({}, {__mode="k"})
local watched=setmetatable({}, {__mode="k"})
local watchConnections={}
local rainbowConnection
local HIGHLIGHT_NAME="VisualsV2_GunsKnivesHighlight"
local function allTools()
local result={}
local function scan(container)
if not container then return end
for _,tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") then
local name=tool.Name:lower()
if name=="knife" or name=="gun" then result[#result+1]=tool end
end
end
end
scan(player.Character)
scan(player:FindFirstChildOfClass("Backpack"))
return result
end
local function removeHighlight(tool)
local highlight=tool and tool:FindFirstChild(HIGHLIGHT_NAME)
if highlight then highlight:Destroy() end
highlighted[tool]=nil
end
local function colorNow(tint)
if tint.rainbow then
return Color3.fromHSV((os.clock()*(tint.speed*0.1))%1,1,1)
end
return tint.color
end
local highlightOf=setmetatable({}, {__mode="k"})
local tintOf=setmetatable({}, {__mode="k"})
local function applyTool(tool)
if not tool or not tool:IsA("Tool") then return end
local tint=tints[tool.Name:lower()]
if not tint then return end
if not tint.enabled then removeHighlight(tool); return end
local highlight=tool:FindFirstChild(HIGHLIGHT_NAME)
if not highlight then
highlight=Instance.new("Highlight")
highlight.Name=HIGHLIGHT_NAME
highlight.Adornee=tool
highlight.DepthMode=Enum.HighlightDepthMode.Occluded
highlight.FillTransparency=0.5
highlight.OutlineTransparency=1
highlight.Parent=tool
end
highlight.FillColor=colorNow(tint)
highlighted[tool]=true
highlightOf[tool],tintOf[tool]=highlight,tint
end
local function applyAll()
if not runtimeAlive then return end
for _,tool in ipairs(allTools()) do applyTool(tool) end
end
local nextFullPass=0
local function rainbowStep()
if not runtimeAlive then return end
local now=os.clock()
if now>=nextFullPass then nextFullPass=now+0.5;applyAll();return end
for _,tint in pairs(tints) do tint.now=tint.enabled and tint.rainbow and colorNow(tint) or nil end
for tool,highlight in pairs(highlightOf) do
local tint=tintOf[tool]
if tint and tint.now and highlight.Parent==tool then highlight.FillColor=tint.now end
end
end
local function refresh()
if rainbowConnection then rainbowConnection:Disconnect(); rainbowConnection=nil end
if not runtimeAlive then return end
applyAll()
for _,tint in pairs(tints) do
if tint.enabled and tint.rainbow then
nextFullPass=os.clock()+0.5
rainbowConnection=RunService.RenderStepped:Connect(rainbowStep)
break
end
end
end
local function watch(container)
if not container or watched[container] then return end
watched[container]=true
watchConnections[#watchConnections+1]=container.ChildAdded:Connect(function(tool)
if tool:IsA("Tool") then
task.defer(function() if runtimeAlive then applyTool(tool) end end)
end
end)
end
watch(player.Character)
watch(player:FindFirstChildOfClass("Backpack"))
watchConnections[#watchConnections+1]=player.CharacterAdded:Connect(function(character)
watch(character)
task.defer(applyAll)
end)
watchConnections[#watchConnections+1]=player.ChildAdded:Connect(function(child)
if child:IsA("Backpack") then watch(child); task.defer(applyAll) end
end)
local function addTint(key,label,name)
local tint={
enabled=C(key.."Enabled",legacyEnabled),
color=C(key.."Color",legacyColor),
rainbow=C(key.."Rainbow",legacyRainbow),
speed=math.clamp(tonumber(C(key.."RainbowSpeed",legacySpeed)) or 3,1,10),
}
tints[name]=tint
section:AddParagraph(label.." Tint","Tint controls affect only your "..name..". Chams have separate colour and rainbow controls.")
tint.toggle=addToggle(section,"Enable "..label.." Tint",tint.enabled,function(value)
tint.enabled=value
SetCfg(key.."Enabled",value)
refresh()
end)
section:AddColorpicker(label.." Tint Color",tint.color,function(color)
tint.color=color
SetCfg(key.."Color",color)
applyAll()
end)
tint.rainbowToggle=addToggle(section,"Rainbow "..label.." Tint",tint.rainbow,function(value)
tint.rainbow=value
SetCfg(key.."Rainbow",value)
refresh()
end)
section:AddSlider(label.." Tint Rainbow Speed",1,10,tint.speed,function(value)
tint.speed=math.clamp(tonumber(value) or 3,1,10)
SetCfg(key.."RainbowSpeed",tint.speed)
applyAll()
end)
end
addTint("knifeTint","Knife","knife")
env.VisualsV2Runtime.RegisterChamsFeature(section,"knifeChams","Knife",function(tool) return tool.Name:lower()=="knife" end)
addTint("gunTint","Gun","gun")
env.VisualsV2Runtime.RegisterChamsFeature(section,"gunChams","Gun",function(tool) return tool.Name:lower()=="gun" end)
env.VisualsV2Runtime.RegisterChamsFeature(section,"holsterChams","Holstered Weapon",function() return false end,function(owner,character)
local found={}
if not character then return found end
for _,kind in ipairs({"Knife","Gun"}) do
local object=character:FindFirstChild("VisualsV2_Client"..kind.."Holster")
if not object then
local reference=character:FindFirstChild("DisplayRef"..kind)
object=reference and reference:IsA("ObjectValue") and reference.Value or nil
if not object then object=character:FindFirstChild(kind.."Display") or character:FindFirstChild(kind.."Holster") end
end
if object and object.Parent and not object:IsA("Tool") then found[#found+1]=object end
end
return found
end)
env.VisualsV2Runtime.RegisterOutlineFeature(section,"knifeOutline","Knife",function(tool) return tool.Name:lower()=="knife" end)
env.VisualsV2Runtime.RegisterOutlineFeature(section,"gunOutline","Gun",function(tool) return tool.Name:lower()=="gun" end)
env.VisualsV2Runtime.RegisterReset(function()
for _,tint in pairs(tints) do
tint.enabled=false; tint.rainbow=false
tint.toggle:Set(false); tint.rainbowToggle:Set(false)
tint.color=Color3.fromRGB(38,38,38); tint.speed=3
end
if rainbowConnection then rainbowConnection:Disconnect(); rainbowConnection=nil end
for _,tool in ipairs(allTools()) do removeHighlight(tool) end
for tool in pairs(highlighted) do removeHighlight(tool) end
if not runtimeAlive then
for _,connection in ipairs(watchConnections) do connection:Disconnect() end
table.clear(watchConnections)
table.clear(watched)
end
end)
task.defer(refresh)
end,"Section \"Custom Knife/Gun\"")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local section=mainTab:AddSection("Gun+","Utilities")
local blockAnimations=C("gunPlusBlockAnimations",false)
local equipSound=C("gunPlusEquipSound",false)
local equipVolume=math.clamp(tonumber(C("gunPlusEquipVolume",1)) or 1,1,5)
local dropForceField=C("gunPlusDropForceField",false)
local dropFireColorEnabled=C("gunPlusDropFireColorEnabled",false)
local forceFieldColor=C("gunPlusForceFieldColor",Color3.fromRGB(38,38,38))
local dropFireColor=C("gunPlusDropFireColor",Color3.fromRGB(38,38,38))
local SOUND_ID="rbxassetid://7158356564"
local START_OFFSET=0.3
local BLOCKED={
["123606547020560"]=true,["134826825394657"]=true,
["124281955370937"]=true,["127786188145385"]=true,
}
local animConn
local seenGuns=setmetatable({}, {__mode="k"})
local sounds=setmetatable({}, {__mode="k"})
local dropWatchConn
local fireOriginals=setmetatable({}, {__mode="k"})
local FORCE_FIELD_NAME="VisualsV2_GunDropForceField"
local function playSound()
local char=player.Character
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local old=sounds[char]
if old then pcall(function() old:Stop(); old:Destroy() end) end
local sound=Instance.new("Sound")
sound.SoundId=SOUND_ID; sound.Volume=equipVolume; sound.Parent=hrp
pcall(function() sound.TimePosition=START_OFFSET end)
sound:Play(); sounds[char]=sound
sound.Ended:Once(function()
if sounds[char]==sound then sounds[char]=nil end
if sound.Parent then sound:Destroy() end
end)
end
local function hookGun(tool)
if not tool or not tool:IsA("Tool") or tool.Name~="Gun" or seenGuns[tool] then return end
seenGuns[tool]=true
tool.Equipped:Connect(function() if equipSound then playSound() end end)
tool.Unequipped:Connect(function() if equipSound then playSound() end end)
end
local function scanGuns(container)
if not container then return end
for _,obj in ipairs(container:GetChildren()) do if obj:IsA("Tool") then hookGun(obj) end end
end
local backpack=player:FindFirstChildOfClass("Backpack")
if backpack then
scanGuns(backpack)
backpack.ChildAdded:Connect(function(obj) if obj:IsA("Tool") then hookGun(obj) end end)
end
local function watchCharacter(char)
scanGuns(char)
char.ChildAdded:Connect(function(obj) if obj:IsA("Tool") then hookGun(obj) end end)
end
if player.Character then watchCharacter(player.Character) end
player.CharacterAdded:Connect(watchCharacter)
local mutedTracks=setmetatable({}, {__mode="k"})
local function restoreAnimationWeights()
for track,weight in pairs(mutedTracks) do
pcall(function()
if track.IsPlaying and track.WeightTarget==0 then track:AdjustWeight(weight,0.1) end
end)
end
table.clear(mutedTracks)
end
local function refreshAnimationLoop()
if animConn then animConn:Disconnect();animConn=nil end
restoreAnimationWeights()
if not blockAnimations then return end
animConn=RunService.RenderStepped:Connect(function()
local char=player.Character
local gun=char and char:FindFirstChild("Gun")
local hum=char and char:FindFirstChildOfClass("Humanoid")
if not hum or not gun or not gun:IsA("Tool") then restoreAnimationWeights();return end
for _,track in ipairs(hum:GetPlayingAnimationTracks()) do
local anim=track.Animation
local id=anim and anim.AnimationId and anim.AnimationId:match("%d+")
if id and BLOCKED[id] then
if mutedTracks[track]==nil then mutedTracks[track]=track.WeightTarget end
if track.WeightTarget~=0 then track:AdjustWeight(0,0) end
end
end
end)
end
local function findForceField(drop)
return drop and drop:FindFirstChild(FORCE_FIELD_NAME)
end
local function applyForceField(drop)
if not dropForceField or not drop or drop.Name~="GunDrop" or not drop:IsA("BasePart") then return end
local sphere=findForceField(drop)
if not sphere then
sphere=Instance.new("Part")
sphere.Name=FORCE_FIELD_NAME
sphere.Shape=Enum.PartType.Ball
sphere.Size=Vector3.new(3.5,3.5,3.5)
sphere.Material=Enum.Material.ForceField
sphere.Transparency=0.3
sphere.CanCollide=false; sphere.CanTouch=false; sphere.CanQuery=false; sphere.CastShadow=false; sphere.Massless=true
sphere.CFrame=drop.CFrame
sphere.Parent=drop
local weld=Instance.new("WeldConstraint")
weld.Name="VisualsV2_GunDropForceFieldWeld"
weld.Part0=drop; weld.Part1=sphere; weld.Parent=sphere
end
sphere.Color=forceFieldColor
end
local function removeForceFields()
for _,obj in ipairs(workspace:GetDescendants()) do
if obj:IsA("BasePart") and obj.Name=="GunDrop" then
local sphere=findForceField(obj); if sphere then sphere:Destroy() end
end
end
end
local function applyFire(fire)
if not dropFireColorEnabled or not fire or not fire:IsA("Fire") then return end
local parent=fire.Parent
if not parent or parent.Name~="GunDrop" then return end
if not fireOriginals[fire] then fireOriginals[fire]={Color=fire.Color,SecondaryColor=fire.SecondaryColor} end
fire.Color=dropFireColor; fire.SecondaryColor=dropFireColor
end
local function applyDrop(drop)
if not drop or drop.Name~="GunDrop" or not drop:IsA("BasePart") then return end
applyForceField(drop)
local fire=drop:FindFirstChildOfClass("Fire"); if fire then applyFire(fire) end
end
local function restoreFireColors()
for fire,data in pairs(fireOriginals) do
if fire and fire.Parent then pcall(function() fire.Color=data.Color; fire.SecondaryColor=data.SecondaryColor end) end
end
fireOriginals=setmetatable({}, {__mode="k"})
end
local function applyExistingDrops()
for _,obj in ipairs(workspace:GetDescendants()) do
if obj:IsA("BasePart") and obj.Name=="GunDrop" then applyDrop(obj)
elseif obj:IsA("Fire") and obj.Parent and obj.Parent.Name=="GunDrop" then applyFire(obj) end
end
end
local function refreshDropWatcher()
if dropWatchConn then dropWatchConn:Disconnect(); dropWatchConn=nil end
if not dropForceField and not dropFireColorEnabled then return end
dropWatchConn=workspace.DescendantAdded:Connect(function(obj)
if obj:IsA("BasePart") and obj.Name=="GunDrop" then task.defer(function() applyDrop(obj) end)
elseif obj:IsA("Fire") and obj.Parent and obj.Parent.Name=="GunDrop" then task.defer(function() applyFire(obj) end) end
end)
applyExistingDrops()
end
local blockToggle=addToggle(section,"Disable Gun Animations",blockAnimations,function(v)
blockAnimations=v; SetCfg("gunPlusBlockAnimations",v); refreshAnimationLoop()
end)
local soundToggle=addToggle(section,"Equip/Unequip Gun Sound",equipSound,function(v)
equipSound=v; SetCfg("gunPlusEquipSound",v)
if not v then
for char,sound in pairs(sounds) do pcall(function() sound:Stop(); sound:Destroy() end); sounds[char]=nil end
end
end)
-- (1 is the sound's normal volume, up to 5 times as loud)
local volumeSlider=section:AddSlider("Equip/Unequip Sound Volume",1,5,equipVolume,function(value)
equipVolume=math.clamp(tonumber(value) or 1,1,5); SetCfg("gunPlusEquipVolume",equipVolume)
for _,sound in pairs(sounds) do pcall(function() sound.Volume=equipVolume end) end
end)
local ffToggle=addToggle(section,"Dropped Gun Force Field Color",dropForceField,function(v)
dropForceField=v; SetCfg("gunPlusDropForceField",v)
if v then refreshDropWatcher() else removeForceFields(); refreshDropWatcher() end
end)
section:AddColorpicker("Force Field Color",forceFieldColor,function(color)
forceFieldColor=color; SetCfg("gunPlusForceFieldColor",color)
for _,obj in ipairs(workspace:GetDescendants()) do
if obj:IsA("BasePart") and obj.Name=="GunDrop" then local sphere=findForceField(obj); if sphere then sphere.Color=color end end
end
end)
local fireToggle=addToggle(section,"Dropped Gun Fire Color",dropFireColorEnabled,function(v)
dropFireColorEnabled=v; SetCfg("gunPlusDropFireColorEnabled",v)
if v then refreshDropWatcher() else restoreFireColors(); refreshDropWatcher() end
end)
section:AddColorpicker("Dropped Gun Fire Color",dropFireColor,function(color)
dropFireColor=color; SetCfg("gunPlusDropFireColor",color)
if dropFireColorEnabled then applyExistingDrops() end
end)
refreshAnimationLoop(); refreshDropWatcher()
env.VisualsV2Runtime.RegisterReset(function()
blockToggle:Set(false); soundToggle:Set(false); ffToggle:Set(false); fireToggle:Set(false)
blockAnimations=false; equipSound=false; dropForceField=false; dropFireColorEnabled=false
equipVolume=1; pcall(function() volumeSlider:SetValue(1) end)
if animConn then animConn:Disconnect(); animConn=nil end
restoreAnimationWeights()
if dropWatchConn then dropWatchConn:Disconnect(); dropWatchConn=nil end
removeForceFields(); restoreFireColors()
for char,sound in pairs(sounds) do pcall(function() sound:Stop(); sound:Destroy() end); sounds[char]=nil end
end)
end,"Section \"Gun+\"")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local section=mainTab:AddSection("Estimated Server Pos","Visuals")
local enabled=C("serverPosEnabled",false)
local markerColor=C("serverPosColor",Color3.fromRGB(38,38,38))
local transparency=math.clamp(tonumber(C("serverPosTransparency",2.5)) or 2.5,1,4)
local marker,root,humanoid,heartbeat,healthConn,charConn
local history={}
local function alpha()
local v=math.clamp(tonumber(transparency) or 2.5,1,4)
return 0.1+((v-1)/3)*0.75
end
local function destroyMarker()
if heartbeat then heartbeat:Disconnect(); heartbeat=nil end
if healthConn then healthConn:Disconnect(); healthConn=nil end
if marker then marker:Destroy(); marker=nil end
table.clear(history)
end
local function ping()
local ok,value=pcall(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
return ok and math.clamp(value,10,1000) or 10
end
local function createMarker(char)
destroyMarker()
root=char:WaitForChild("HumanoidRootPart")
humanoid=char:WaitForChild("Humanoid")
marker=Instance.new("Part")
marker.Name="VisualsV2_ServerPosition"
marker.Size=Vector3.new(2,2,1)
marker.Color=markerColor
marker.Material=Enum.Material.Plastic
marker.Transparency=alpha()
marker.Anchored=true; marker.CanCollide=false; marker.CanTouch=false; marker.CanQuery=false; marker.CastShadow=false
marker.Parent=workspace
healthConn=humanoid.HealthChanged:Connect(function(health) if health<=0 then destroyMarker() end end)
heartbeat=RunService.Heartbeat:Connect(function()
if not marker or not marker.Parent or not root or not root.Parent then return end
table.insert(history,{position=root.Position,rotation=root.CFrame-root.Position,time=tick()})
while #history>120 do table.remove(history,1) end
local target=tick()-ping()/1000
local closest=history[1]
if not closest then return end
for _,entry in ipairs(history) do if math.abs(entry.time-target)<math.abs(closest.time-target) then closest=entry end end
marker.CFrame=CFrame.new(closest.position)*closest.rotation
end)
end
local function enable()
if not charConn then charConn=player.CharacterAdded:Connect(function(char) task.wait(); if enabled then createMarker(char) end end) end
if player.Character then createMarker(player.Character) end
end
local function disable()
if charConn then charConn:Disconnect(); charConn=nil end
destroyMarker()
end
local enableToggle=addToggle(section,"Show Server Pos",enabled,function(v)
enabled=v; SetCfg("serverPosEnabled",v); if v then enable() else disable() end
end)
section:AddSlider("Marker Transparency",1,4,transparency,function(v)
transparency=math.clamp(tonumber(v) or 2.5,1,4); SetCfg("serverPosTransparency",transparency)
if marker then marker.Transparency=alpha() end
end)
section:AddColorpicker("Marker Color",markerColor,function(color)
markerColor=color; SetCfg("serverPosColor",color); if marker then marker.Color=color end
end)
env.VisualsV2Runtime.RegisterReset(function()
enableToggle:Set(false); enabled=false; transparency=2.5; markerColor=Color3.fromRGB(255,255,255); disable()
end)
end,"Section \"Estimated Server Pos\"")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local section=mainTab:AddSection("Custom Tool","Visuals")
section:AddParagraph("Tool Tint","Applies a configurable highlight tint to tools other than Gun and Knife.")
local enabled=C("toolTintEnabled",false)
local tintColor=C("toolTintColor",Color3.fromRGB(38,38,38))
local rainbow=C("toolTintRainbow",false)
local rainbowSpeed=C("toolTintRainbowSpeed",3)
local transparency=C("toolTintTransparency",5)
local rainbowConn
local HIGHLIGHT_NAME="VisualsV2_ToolTint"
local tintHighlights={}
local tintConnections={}
local function isGunKnife(tool)
if not tool or not tool:IsA("Tool") then return false end
local name=tool.Name:lower()
return name=="gun" or name=="knife"
end
local function allTools()
local result={}
local function scan(container)
if container then
for _,obj in ipairs(container:GetChildren()) do
if obj:IsA("Tool") and not isGunKnife(obj) then result[#result+1]=obj end
end
end
end
scan(player.Character)
scan(player:FindFirstChildOfClass("Backpack"))
return result
end
local function colorNow()
if rainbow then return Color3.fromHSV((os.clock()*((tonumber(rainbowSpeed) or 3)*0.1))%1,1,1) end
return tintColor
end
local function fillAlpha()
local v=math.clamp(tonumber(transparency) or 5,1,10)
return 0.05+((v-1)/9)*0.85
end
local function removeHighlight(tool)
if not tool then return end
local h=tintHighlights[tool]
if h then h:Destroy(); tintHighlights[tool]=nil end
local legacy=tool:FindFirstChild(HIGHLIGHT_NAME)
if legacy then legacy:Destroy() end
end
local function apply(tool)
if not enabled or not tool or not tool:IsA("Tool") then return end
local forceField=env.VisualsV2Runtime.ToolChamsActive or env.VisualsV2Runtime.ToolForceFieldActive
if isGunKnife(tool) or (type(forceField)=="function" and forceField(tool)) then
removeHighlight(tool); return
end
local legacy=tool:FindFirstChild(HIGHLIGHT_NAME)
if legacy then legacy:Destroy() end
local h=tintHighlights[tool]
if not h then
h=Instance.new("Highlight")
h.Name=HIGHLIGHT_NAME
h.Adornee=tool
h.DepthMode=Enum.HighlightDepthMode.Occluded
h.OutlineTransparency=1
h.Parent=workspace
tintHighlights[tool]=h
end
h.FillColor=colorNow()
h.FillTransparency=fillAlpha()
end
local function applyAll()
local seen={}
for _,tool in ipairs(allTools()) do seen[tool]=true; apply(tool) end
for tool in pairs(tintHighlights) do if not seen[tool] then removeHighlight(tool) end end
end
local function restoreAll()
if rainbowConn then rainbowConn:Disconnect(); rainbowConn=nil end
for tool,h in pairs(tintHighlights) do h:Destroy(); tintHighlights[tool]=nil end
for _,tool in ipairs(allTools()) do removeHighlight(tool) end
end
local nextFullPass=0
local function rainbowStep()
if not enabled or not rainbow or not runtimeAlive then return end
local now=os.clock()
if now>=nextFullPass then nextFullPass=now+0.5;applyAll();return end
local color=colorNow()
for _,h in pairs(tintHighlights) do
if h.Parent then h.FillColor=color end
end
end
local function refreshAll()
restoreAll()
if enabled then applyAll() end
if enabled and rainbow then nextFullPass=os.clock()+0.5;rainbowConn=RunService.RenderStepped:Connect(rainbowStep) end
end
local function watch(container)
if not container then return end
local function changed(obj)
if obj:IsA("Tool") and enabled and runtimeAlive then
task.defer(function() if enabled and runtimeAlive then applyAll() end end)
end
end
tintConnections[#tintConnections+1]=container.ChildAdded:Connect(changed)
tintConnections[#tintConnections+1]=container.ChildRemoved:Connect(changed)
end
watch(player:FindFirstChildOfClass("Backpack")); watch(player.Character)
tintConnections[#tintConnections+1]=player.CharacterAdded:Connect(function(char)
if not runtimeAlive then return end
watch(char)
if enabled then task.defer(function() if enabled and runtimeAlive then applyAll() end end) end
end)
tintConnections[#tintConnections+1]=player.ChildAdded:Connect(function(child)
if not runtimeAlive or not child:IsA("Backpack") then return end
watch(child)
if enabled then task.defer(function() if enabled and runtimeAlive then applyAll() end end) end
end)
env.VisualsV2Runtime.RefreshToolTint=refreshAll
local enabledToggle=addToggle(section,"Enable Tool Tint",enabled,function(v)
enabled=v
SetCfg("toolTintEnabled",v)
if v then refreshAll() else restoreAll() end
end)
section:AddColorpicker("Tool Tint Color",tintColor,function(color)
tintColor=color; SetCfg("toolTintColor",color); if enabled and not rainbow then applyAll() end
end)
local rainbowToggle=addToggle(section,"Rainbow Tool Tint",rainbow,function(v)
rainbow=v
SetCfg("toolTintRainbow",v)
refreshAll()
end)
section:AddSlider("Rainbow Speed",1,10,rainbowSpeed,function(v)
rainbowSpeed=math.clamp(tonumber(v) or 3,1,10); SetCfg("toolTintRainbowSpeed",rainbowSpeed)
end)
section:AddSlider("Tint Transparency",1,10,transparency,function(v)
transparency=math.clamp(tonumber(v) or 5,1,10); SetCfg("toolTintTransparency",transparency); if enabled then applyAll() end
end)
env.VisualsV2Runtime.RegisterChamsFeature(section,"toolChams","Tool",function(tool) return not isGunKnife(tool) end)
env.VisualsV2Runtime.RegisterOutlineFeature(section,"toolOutline","Tool",function(tool) return not isGunKnife(tool) end)
env.VisualsV2Runtime.RegisterReset(function()
enabledToggle:Set(false); rainbowToggle:Set(false)
enabled=false; rainbow=false; tintColor=Color3.fromRGB(255,255,255); rainbowSpeed=3; transparency=5
restoreAll()
if not runtimeAlive then
for _,connection in ipairs(tintConnections) do connection:Disconnect() end
table.clear(tintConnections)
end
end)
end,"Section \"Custom Tool\"")
;vv2Section(function()
local section=mainTab:AddSection("Custom Chat","Visuals")
local enabled=C("chatColorEnabled",false)
local bubbleColor=C("chatBubbleColor",Color3.fromRGB(0,0,0))
local textColor=C("chatTextColor",Color3.fromRGB(255,255,255))
local originalBubble,originalText
local childConn
local function getConfig()
return TextChatService:FindFirstChildOfClass("BubbleChatConfiguration") or TextChatService:FindFirstChild("BubbleChatConfiguration")
end
local function apply()
local config=getConfig(); if not config then return end
if originalBubble==nil then originalBubble=config.BackgroundColor3; originalText=config.TextColor3 end
config.BackgroundColor3=bubbleColor; config.TextColor3=textColor
end
local function restore()
local config=getConfig(); if not config then return end
if originalBubble~=nil then config.BackgroundColor3=originalBubble end
if originalText~=nil then config.TextColor3=originalText end
end
local function refreshWatcher()
if childConn then childConn:Disconnect(); childConn=nil end
if enabled then
childConn=TextChatService.ChildAdded:Connect(function(child)
if child:IsA("BubbleChatConfiguration") or child.Name=="BubbleChatConfiguration" then task.defer(apply) end
end)
apply()
end
end
local enableToggle=addToggle(section,"Custom Chat Colors",enabled,function(v)
enabled=v; SetCfg("chatColorEnabled",v); if v then refreshWatcher() else if childConn then childConn:Disconnect(); childConn=nil end; restore() end
end)
section:AddColorpicker("Chat Bubble Color",bubbleColor,function(color)
bubbleColor=color; SetCfg("chatBubbleColor",color); if enabled then apply() end
end)
section:AddColorpicker("Chat Text Color",textColor,function(color)
textColor=color; SetCfg("chatTextColor",color); if enabled then apply() end
end)
env.VisualsV2Runtime.RegisterReset(function()
enableToggle:Set(false); enabled=false
if childConn then childConn:Disconnect(); childConn=nil end
restore()
end)
end,"Section \"Custom Chat\"")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local fontSection=mainTab:AddSection("Text Fonts","Visuals")
local privacySection=mainTab:AddSection("Streamer Mode","Privacy")
local fonts={
["SourceSansBold (Original)"]=Enum.Font.SourceSansBold,
["Gotham"]=Enum.Font.Gotham,
["Arcade"]=Enum.Font.Arcade,
["Arial"]=Enum.Font.Arial,
["ArialBold"]=Enum.Font.ArialBold,
["Cartoon"]=Enum.Font.Cartoon,
["Fantasy"]=Enum.Font.Fantasy,
["Highway"]=Enum.Font.Highway,
["Code"]=Enum.Font.Code,
["Legacy"]=Enum.Font.Legacy,
["Starborn"]=true,
}
local fontNames={"SourceSansBold (Original)","Gotham","Arcade","Arial","ArialBold","Cartoon","Fantasy","Highway","Code","Legacy","Starborn"}
for _,entry in ipairs({
{"Bangers","Bangers"},{"Creepster","Creepster"},{"Fredoka One","FredokaOne"},
{"Luckiest Guy","LuckiestGuy"},{"Permanent Marker","PermanentMarker"},
{"Special Elite","SpecialElite"},{"Sarpanch","Sarpanch"},{"Jura","Jura"},
{"Oswald","Oswald"},{"Nunito","Nunito"},{"Indie Flower","IndieFlower"},
{"Titillium Web","TitilliumWeb"},{"Sci-Fi","SciFi"},{"Antique","Antique"},
{"Grenze Gotisch","GrenzeGotisch"},{"Amatic SC","AmaticSC"},{"Denk One","DenkOne"},
{"Patrick Hand","PatrickHand"},{"Roboto Mono","RobotoMono"},
}) do
local okFont,value=pcall(function() return Enum.Font[entry[2]] end)
if okFont and value and not fonts[entry[1]] then
fonts[entry[1]]=value
fontNames[#fontNames+1]=entry[1]
end
end
local starbornFace=nil
local function loadStarborn()
if starbornFace then return starbornFace end
local ok,result=pcall(function() return Font.fromEnum(Enum.Font.Michroma) end)
if not ok or not result then
ok,result=pcall(function()
return Font.new("rbxasset://fonts/families/Michroma.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
end)
end
if ok and result then starbornFace=result end
return starbornFace
end
local FONT_SCALE={Starborn=0.85,Legacy=0.6}
local selectedFont=C("vv2TextFont","SourceSansBold (Original)")
if not fonts[selectedFont] then selectedFont="SourceSansBold (Original)" end
local fontsEnabled=C("vv2TextFontsEnabled",false)
local hideNames=C("vv2StreamerHideUsername",false)
local hideAvatar=C("vv2StreamerHideAvatar",false)
local alive=true
local resetting=false
local tradeQuiet=false
local roots={}
local rootConnections={}
local lifecycleConnections={}
local records={}
local refresh
local transparentImage="rbxasset://textures/transparent.png"
local function disconnectAll(connections)
for _,connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
table.clear(connections)
end
local function readFont(object)
local result={font=object.Font,size=object.TextSize}
pcall(function() result.face=object.FontFace end)
return result
end
local function writeProperty(object,record,property,value)
record.writing=record.writing+1
local ok=pcall(function() if object[property]~=value then object[property]=value end end)
record.writing=record.writing-1
return ok
end
local function restoreFont(object,record)
if not record.font then return end
record.writing=record.writing+1
local restored=false
if record.font.face then restored=pcall(function() object.FontFace=record.font.face end) end
if not restored then pcall(function() object.Font=record.font.font end) end
record.writing=record.writing-1
if record.appliedSize and object.TextSize==record.appliedSize then
writeProperty(object,record,"TextSize",record.font.size)
end
if record.sizeConstraint then
if record.ownsConstraint then record.sizeConstraint:Destroy()
elseif record.constraintMax then record.sizeConstraint.MaxTextSize=record.constraintMax end
record.sizeConstraint=nil;record.ownsConstraint=nil;record.constraintMax=nil
end
record.appliedSize=nil
record.font=nil
record.appliedFont=nil
end
local function release(object)
local record=records[object]
if not record then return end
disconnectAll(record.connections)
restoreFont(object,record)
if record.text~=nil then writeProperty(object,record,"Text",record.text) end
if record.image~=nil then writeProperty(object,record,"Image",record.image) end
records[object]=nil
end
local function inRoots(object)
for _,root in ipairs(roots) do
local ok,inside=pcall(object.IsDescendantOf,object,root)
if ok and inside then return true end
end
return false
end

local function isOwnAvatar(value)
if type(value)~="string" then return false end
local lower=value:lower()
local id=lower:match("[?&]userid=(%d+)") or lower:match("[?&]user_id=(%d+)")
or lower:match("/users/(%d+)/")
if not id and lower:find("type=avatar",1,true) then id=lower:match("[?&]id=(%d+)") end
return id~=nil and id==tostring(LocalPlayer.UserId)
end
local function avatarLike(value)
if type(value)~="string" or value=="" then return true end
local lower=value:lower()
return lower:find("avatar",1,true)~=nil or lower:find("headshot",1,true)~=nil or lower:find("userid",1,true)~=nil
or lower:find("user_id",1,true)~=nil or lower:find("/users/",1,true)~=nil
end
local function isIconFont(object,font)
local family=font.face and tostring(font.face.Family):lower() or ""
if family:find("icon",1,true) or family:find("symbol",1,true)
or family:find("awesome",1,true) or family:find("131287805200037",1,true) then return true end
local value=object.Text
if type(value)=="string" and type(utf8)=="table" then
local ok,private=pcall(function()
for _,code in utf8.codes(value) do
if (code>=0xE000 and code<=0xF8FF) or (code>=0xF0000 and code<=0x10FFFD) then return true end
end
return false
end)
if ok and private then return true end
end
return false
end
local function applyFont(object,record)
local original=record.font or readFont(object)
if fontsEnabled and not isIconFont(object,original) then
if not record.font then record.font=original end
local scale=FONT_SCALE[selectedFont]
if selectedFont=="Starborn" then
local face=loadStarborn()
if not face then restoreFont(object,record);return end
writeProperty(object,record,"FontFace",face)
else
if record.appliedSize or record.sizeConstraint then
local native=record.font
restoreFont(object,record);record.font=native
end
writeProperty(object,record,"Font",fonts[selectedFont])
end
if scale then
local size=math.clamp(math.floor((record.font.size or 14)*scale+0.5),9,48)
writeProperty(object,record,"TextSize",size)
record.appliedSize=size
if object.TextScaled then
local constraint=record.sizeConstraint or object:FindFirstChildOfClass("UITextSizeConstraint")
if not constraint then
constraint=Instance.new("UITextSizeConstraint")
constraint.Name="VisualsV2_FontSize";constraint.MinTextSize=8
constraint.Parent=object;record.ownsConstraint=true
elseif not record.sizeConstraint then record.constraintMax=constraint.MaxTextSize end
record.sizeConstraint=constraint
local maximum=math.clamp(math.floor(math.max(size,object.AbsoluteSize.Y*0.76*scale)),11,36)
constraint.MaxTextSize=math.max(constraint.MinTextSize,math.min(record.constraintMax or maximum,maximum))
end
end
record.appliedFont=readFont(object)
else
restoreFont(object,record)
end
end
local function applyImage(object,record)
if hideAvatar then
if record.image==nil then record.image=object.Image end
record.appliedImage=isOwnAvatar(record.image) and transparentImage or record.image
writeProperty(object,record,"Image",record.appliedImage)
elseif record.image~=nil then
writeProperty(object,record,"Image",record.image)
record.image=nil
record.appliedImage=nil
end
end
local function connectProperty(object,record,property,callback)
local ok,connection=pcall(function()
return object:GetPropertyChangedSignal(property):Connect(function()
if alive and runtimeAlive and not resetting and record.writing==0 and records[object]==record then
local now=os.clock()
if now-(record.burstAt or 0)>1 then record.burstAt=now;record.burst=0 end
record.burst=(record.burst or 0)+1
if record.burst>8 then return end
pcall(callback)
end
end)
end)
if ok then record.connections[#record.connections+1]=connection end
end
local function process(object)
if not alive or not runtimeAlive or resetting then return end
local className=object.ClassName
local text=className=="TextLabel" or className=="TextButton" or className=="TextBox"
local nameLabel=text and className~="TextBox"
local image=className=="ImageLabel" or className=="ImageButton"
if not ((text and fontsEnabled) or (image and hideAvatar)) then
release(object)
return
end
local record=records[object]
if not record then
record={connections={},writing=0}
records[object]=record
record.card=object:GetAttribute("VisualsV2_Card")==true
record.listed=object:FindFirstAncestorWhichIsA("ScrollingFrame")~=nil
if text and not record.listed then
local function fontChanged()
if not fontsEnabled then return end
local current=readFont(object)
if record.appliedFont and current.font==record.appliedFont.font and current.face==record.appliedFont.face then return end
if record.font and record.appliedSize and current.size==record.appliedSize then current.size=record.font.size end
record.font=current
applyFont(object,record)
end
connectProperty(object,record,"Font",fontChanged)
connectProperty(object,record,"FontFace",fontChanged)
connectProperty(object,record,"TextSize",function()
if record.font and object.TextSize~=record.appliedSize then
record.font.size=object.TextSize
if FONT_SCALE[selectedFont] then applyFont(object,record) end
end
end)
end
if image and (not record.listed or avatarLike(object.Image)) then
connectProperty(object,record,"Image",function()
if not hideAvatar or object.Image==record.appliedImage then return end
record.image=object.Image
applyImage(object,record)
end)
end
end
if nameLabel and not record.textWatched and not record.listed then
record.textWatched=true
connectProperty(object,record,"Text",function()
if fontsEnabled then applyFont(object,record) end
end)
end
if text then applyFont(object,record) end
if image then applyImage(object,record) end
end
local function refreshObject(object)
if inRoots(object) then pcall(process,object) else release(object) end
end
local relevantClasses={TextLabel=true,TextButton=true,TextBox=true,ImageLabel=true,ImageButton=true}
local function guiRelevant(object)
return relevantClasses[object.ClassName]==true
end
local scanToken=0
local fontBatch=env.VisualsV2Runtime.MakeBatcher(function(object)
if alive and runtimeAlive and not resetting then refreshObject(object) end
end,0.003,160)
local cardBatch=env.VisualsV2Runtime.MakeBatcher(function(object)
local record=records[object]
if record and object.Parent==nil then
disconnectAll(record.connections)
records[object]=nil
end
end,0.002)
refresh=function()
if resetting then return end
disconnectAll(rootConnections)
table.clear(roots)
if alive and runtimeAlive and (fontsEnabled or hideAvatar) then
local function addRoot(root)
if typeof(root)~="Instance" then return end
for _,existing in ipairs(roots) do if root==existing then return end end
roots[#roots+1]=root
end
addRoot(LocalPlayer:FindFirstChildOfClass("PlayerGui"))
pcall(function() addRoot(game:GetService("CoreGui")) end)
local hiddenRoot=type(gethui)=="function" and gethui or env.gethui
if type(hiddenRoot)=="function" then
local ok,root=pcall(hiddenRoot)
if ok then addRoot(root) end
end
for _,root in ipairs(tradeQuiet and {} or roots) do
pcall(function()
rootConnections[#rootConnections+1]=root.DescendantAdded:Connect(function(object)
if guiRelevant(object) then fontBatch.Push(object) end
end)
end)
end
scanToken=scanToken+1
local token=scanToken
local list=table.clone(roots)
task.spawn(function()
local started=os.clock()
for _,root in ipairs(list) do
local ok,objects=pcall(root.GetDescendants,root)
if ok then
for index,object in ipairs(objects) do
if token~=scanToken or not alive or not runtimeAlive then return end
if guiRelevant(object) then fontBatch.Push(object) end
if index%200==0 and os.clock()-started>=bootBudget(0.002) then task.wait();started=os.clock() end
end
end
end
end)
end
if #roots==0 or not runtimeAlive then
fontBatch.Clear()
for object in pairs(records) do refreshObject(object) end
else
for object in pairs(records) do fontBatch.Push(object) end
end
end
task.spawn(function()
while alive and runtimeAlive do
task.wait(10)
if not resetting then
-- (removed objects are let go here, not on every removal)
for object,record in pairs(records) do
if record.card then cardBatch.Push(object) elseif object.Parent==nil then fontBatch.Push(object) end
end
end
end
end)
-- Hide My Username: same behaviour as Better ODH "Hide My Username" (any TextLabel/TextButton whose
-- text contains your name becomes "Hidden", and new GUI elements are caught on DescendantAdded),
-- extended to watch Text changes and CoreGui so recycled/new TextChatService chat lines stay hidden.
local nameConnections={}
local nameWatched=setmetatable({},{__mode="k"})
local nameOriginals=setmetatable({},{__mode="k"})
local nameToken=0
local function ownsName(value)
if type(value)~="string" or value=="" or value=="Hidden" then return false end
for _,name in ipairs({LocalPlayer.Name,LocalPlayer.DisplayName}) do
if type(name)=="string" and name~="" and value:find(name,1,true) then return true end
end
return false
end
local function hideNameText(obj)
if not hideNames or not alive or not runtimeAlive then return end
local ok,value=pcall(function() return obj.Text end)
if ok and ownsName(value) then
nameOriginals[obj]=value
pcall(function() obj.Text="Hidden" end)
end
end
local function watchNameText(obj)
if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return false end
if not nameWatched[obj] then
local ok,connection=pcall(function()
return obj:GetPropertyChangedSignal("Text"):Connect(function() hideNameText(obj) end)
end)
if ok then nameWatched[obj]=connection end
end
return true
end
local function stopNameHider(restoreText)
nameToken=nameToken+1
disconnectAll(nameConnections)
for _,connection in pairs(nameWatched) do pcall(function() connection:Disconnect() end) end
table.clear(nameWatched)
if restoreText then
for obj,value in pairs(nameOriginals) do
pcall(function() if obj.Text=="Hidden" then obj.Text=value end end)
end
table.clear(nameOriginals)
end
end
local function startNameHider()
if tradeQuiet then return end
stopNameHider(false)
if not hideNames or not alive or not runtimeAlive then return end
local guiRoots={}
local playerGui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
if playerGui then guiRoots[#guiRoots+1]=playerGui end
pcall(function() guiRoots[#guiRoots+1]=game:GetService("CoreGui") end)
for _,root in ipairs(guiRoots) do
pcall(function()
nameConnections[#nameConnections+1]=root.DescendantAdded:Connect(function(obj)
if watchNameText(obj) then task.defer(hideNameText,obj) end
end)
end)
end
local token=nameToken
task.spawn(function()
local started=os.clock()
for _,root in ipairs(guiRoots) do
local ok,objects=pcall(root.GetDescendants,root)
if ok then
for index,obj in ipairs(objects) do
if token~=nameToken then return end
if watchNameText(obj) then hideNameText(obj) end
if index%200==0 and os.clock()-started>=bootBudget(0.002) then task.wait();started=os.clock() end
end
end
end
end)
end
-- While a trade is open: the GUI-wide listeners above are off (the game rebuilds thousands of objects
-- then), and the trade window is swept once a second instead, a few objects at a time.
local function tradeSweep()
task.spawn(function()
while tradeQuiet and alive and runtimeAlive do
local trade=env.VisualsV2Runtime.Trade
local started=os.clock()
for _,root in ipairs(trade and trade.roots or {}) do
local ok,objects=pcall(root.GetDescendants,root)
if ok then
for index,object in ipairs(objects) do
if not tradeQuiet or not alive or not runtimeAlive then return end
if (fontsEnabled or hideAvatar) and not records[object] and guiRelevant(object) then fontBatch.Push(object) end
if hideNames and (object:IsA("TextLabel") or object:IsA("TextButton")) then hideNameText(object) end
if index%100==0 and os.clock()-started>=0.002 then task.wait();started=os.clock() end
end
end
end
task.wait(1)
end
end)
end
do
local trade=env.VisualsV2Runtime.Trade
if trade and type(trade.OnChanged)=="function" then
trade.OnChanged(function(active)
if not alive or not runtimeAlive or active==tradeQuiet then return end
tradeQuiet=active
if active then
disconnectAll(rootConnections)
disconnectAll(nameConnections)
tradeSweep()
else
refresh()
if hideNames then startNameHider() end
end
end)
end
end
local fontToggle=addToggle(fontSection,"Enable Custom Fonts",fontsEnabled,function(value)
fontsEnabled=value
SetCfg("vv2TextFontsEnabled",value)
refresh()
end)
local fontDropdown=addDropdown(fontSection,"Select Font",fontNames,selectedFont,function(value)
if not fonts[value] then return false end
selectedFont=value
SetCfg("vv2TextFont",value)
refresh()
end)
local nameToggle=addToggle(privacySection,"Hide My Username",hideNames,function(value)
hideNames=value
SetCfg("vv2StreamerHideUsername",value)
if value then startNameHider() else stopNameHider(true) end
end)
local avatarToggle=addToggle(privacySection,"Hide My Avatar",hideAvatar,function(value)
hideAvatar=value
SetCfg("vv2StreamerHideAvatar",value)
refresh()
end)
local function playerGuiChanged(child)
if child:IsA("PlayerGui") then task.defer(function() if alive and runtimeAlive then refresh();if hideNames then startNameHider() end end end) end
end
lifecycleConnections[#lifecycleConnections+1]=LocalPlayer.ChildAdded:Connect(playerGuiChanged)
lifecycleConnections[#lifecycleConnections+1]=LocalPlayer.ChildRemoved:Connect(playerGuiChanged)
pcall(function()
lifecycleConnections[#lifecycleConnections+1]=LocalPlayer:GetPropertyChangedSignal("DisplayName"):Connect(function()
if hideNames then startNameHider() end
end)
end)
env.VisualsV2Runtime.RegisterReset(function()
resetting=true
fontsEnabled=false
hideNames=false
hideAvatar=false
fontToggle:Set(false)
nameToggle:Set(false)
avatarToggle:Set(false)
selectedFont="SourceSansBold (Original)"
if fontDropdown and type(fontDropdown.Select)=="function" then
pcall(fontDropdown.Select,selectedFont)
end
resetting=false
stopNameHider(true)
if not runtimeAlive then alive=false;disconnectAll(lifecycleConnections) end
refresh()
end)
refresh()
end,"Section \"Text Fonts / Streamer Mode\"")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local section=mainTab:AddSection("Customization","Visuals")
local pg=player:WaitForChild("PlayerGui")
local motion=C("vv2MotionBlur",false)
local blurStrength=math.clamp(tonumber(C("vv2BlurStrength",8)) or 8,1,24)
local jumpResize=C("vv2JumpResize",false)
local jumpSize=math.clamp(tonumber(C("vv2JumpSize",100)) or 100,50,125)
local toolTrans=C("vv2ToolTransparency",false)
local toolLevel=math.clamp(tonumber(C("vv2ToolTransparencyLevel",5)) or 5,0,10)
local hideControls=C("vv2HideTouchControls",false)
local blur=Lighting:FindFirstChild("VisualsV2_MotionBlur") or Instance.new("BlurEffect")
blur.Name="VisualsV2_MotionBlur"; blur.Parent=Lighting; if not motion then blur.Size=0 end
blur.Enabled=motion==true
local lastCFrame=nil
local blurLoop
blurLoop=RunService.RenderStepped:Connect(function(dt)
if not runtimeAlive then blurLoop:Disconnect();return end
if not motion then lastCFrame=nil;return end
local cam=workspace.CurrentCamera; if not cam then return end
local c=cam.CFrame
lastCFrame=lastCFrame or c
local d=math.abs(c.X-lastCFrame.X)+math.abs(c.Y-lastCFrame.Y)+math.abs(c.Z-lastCFrame.Z)
local r=(c.LookVector-lastCFrame.LookVector).Magnitude
local target=(d+r)*60
blur.Size=math.clamp(math.lerp(blur.Size,target*4,dt*20),0,blurStrength)
if blur.Size>0.1 then blur.Size=math.clamp(blur.Size-(0.5*(dt*60)),0,blurStrength) end
lastCFrame=c
end)
local motionToggle=addToggle(section,"VV2 Enable Motion Blur",motion,function(v) motion=v; SetCfg("vv2MotionBlur",v); blur.Enabled=v==true; if not v then blur.Size=0 end end)
section:AddSlider("VV2 Blur Strength",1,24,blurStrength,function(v) blurStrength=v; SetCfg("vv2BlurStrength",v) end)
local jumpButton
local function findJump()
if jumpButton and jumpButton.Parent then return jumpButton end
jumpButton=nil
local tg=pg:FindFirstChild("TouchGui"); if not tg then return end
local tcf=tg:FindFirstChild("TouchControlFrame")
local jb=tcf and tcf:FindFirstChild("JumpButton",true)
if jb then jumpButton=jb;return jb end
for _,d in ipairs(tg:GetDescendants()) do if d.Name=="JumpButton" and d:IsA("GuiButton") then jumpButton=d;return d end end
end
local function applyJump()
if not jumpResize or not UserInputService.TouchEnabled then return end
local jb=findJump(); local cam=workspace.CurrentCamera; if not jb or not cam then return end
local maxSize=math.min(cam.ViewportSize.X,cam.ViewportSize.Y)*0.25
local size=math.clamp(jumpSize,50,maxSize)
local wantedSize,wantedPosition=UDim2.new(0,size,0,size),UDim2.new(1,-size-20,1,-size-20)
if jb.Size~=wantedSize then jb.Size=wantedSize end
if jb.Position~=wantedPosition then jb.Position=wantedPosition end
end
local jumpLoop
jumpLoop=RunService.RenderStepped:Connect(function()
if not runtimeAlive then jumpLoop:Disconnect();return end
applyJump()
end)
local jumpToggle=addToggle(section,"VV2 Jump Button Size Changer (Mobile & Tablet)",jumpResize,function(v) jumpResize=v; SetCfg("vv2JumpResize",v) end)
section:AddSlider("VV2 Jump Button Size",50,125,jumpSize,function(v) jumpSize=v; SetCfg("vv2JumpSize",v); applyJump() end)
local originals=setmetatable({}, {__mode="k"})
local written=setmetatable({}, {__mode="k"})
local function fade(p)
if not (p:IsA("BasePart") or p:IsA("Decal") or p:IsA("Texture")) then return end
if originals[p]==nil or (written[p]~=nil and p.Transparency~=written[p]) then originals[p]=p.Transparency end
local wanted=math.max(originals[p],toolLevel/10)
if p.Transparency~=wanted then p.Transparency=wanted end
written[p]=p.Transparency
end
local function applyTool(t)
if not t or not t:IsA("Tool") then return end
for _,p in ipairs(t:GetDescendants()) do fade(p) end
end
local function allTools()
for _,c in ipairs({player.Character or false,player:FindFirstChildOfClass("Backpack") or false}) do
if c then for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then applyTool(t) end end end
end
end
local function restoreTools()
for p,v in pairs(originals) do if p and p.Parent then pcall(function() p.Transparency=v end) end end
originals=setmetatable({}, {__mode="k"})
written=setmetatable({}, {__mode="k"})
end
local toolTick=0
local toolLoop
toolLoop=RunService.Heartbeat:Connect(function(dt)
if not runtimeAlive then toolLoop:Disconnect();return end
if not toolTrans then return end
toolTick=toolTick+dt
if toolTick<0.2 then return end
toolTick=0
pcall(allTools)
end)
local toolToggle=addToggle(section,"VV2 Tool Transparency",toolTrans,function(v) toolTrans=v; SetCfg("vv2ToolTransparency",v); if v then allTools() else restoreTools() end end)
section:AddSlider("VV2 Tool Transparency Level",0,10,toolLevel,function(v)
toolLevel=math.clamp(tonumber(v) or 5,0,10); SetCfg("vv2ToolTransparencyLevel",toolLevel)
if toolTrans then allTools() end
end)
local hideToken=0
local function invisible(o)
if not o:IsA("GuiObject") then return end
if o.BackgroundTransparency~=1 then o.BackgroundTransparency=1 end
if (o:IsA("ImageLabel") or o:IsA("ImageButton")) and o.ImageTransparency~=1 then o.ImageTransparency=1 end
if (o:IsA("TextLabel") or o:IsA("TextButton")) and o.TextTransparency~=1 then o.TextTransparency=1 end
end
local function hideLoop()
hideToken=hideToken+1; local tok=hideToken
if not hideControls then return end
task.spawn(function()
while hideControls and tok==hideToken do
local tg=pg:FindFirstChild("TouchGui")
if tg then for _,o in ipairs(tg:GetDescendants()) do invisible(o) end end
task.wait(0.1)
end
end)
end
local hideToggle=addToggle(section,"VV2 Hide Joystick & Jump Button",hideControls,function(v) hideControls=v; SetCfg("vv2HideTouchControls",v); hideLoop() end)
env.VisualsV2Runtime.RegisterReset(function()
motionToggle:Set(false); jumpToggle:Set(false); toolToggle:Set(false); hideToggle:Set(false)
motion=false; jumpResize=false; toolTrans=false; hideControls=false; hideToken=hideToken+1; blur.Size=0; blur.Enabled=false; restoreTools()
end)
if toolTrans then task.defer(allTools) end
if hideControls then hideLoop() end
end,"Section \"Customization\"")
;vv2Section(function()
if not inMurderMystery then return end
local section=mainTab:AddSection("Visual Stat Spoofer","Visuals")
local pg=player:WaitForChild("PlayerGui")
local enabled=C("visualStatSpooferEnabled",false)
local v1=tostring(C("visualStat1","0")); local v2=tostring(C("visualStat2","0")); local v3=tostring(C("visualStat3","0"))
local alive=true
local toggle=addToggle(section,"VV2 Enable Visual Stat Spoofer",enabled,function(v) enabled=v; SetCfg("visualStatSpooferEnabled",v) end)
section:AddTextBox("VV2 Stat 1 (Murderer / Eliminations)",function(v) v1=tostring(v or "0"); SetCfg("visualStat1",v1) end)
section:AddTextBox("VV2 Stat 2 (Sheriff / Saves)",function(v) v2=tostring(v or "0"); SetCfg("visualStat2",v2) end)
section:AddTextBox("VV2 Stat 3 (Innocent / Survivals)",function(v) v3=tostring(v or "0"); SetCfg("visualStat3",v3) end)
task.spawn(function()
local cache={}; local last=0
while alive do
task.wait(0.5)
if enabled then pcall(function()
local stale=#cache==0
for _,r in ipairs(cache) do
if (r.e and not r.e.Parent) or (r.s and not r.s.Parent) or (r.u and not r.u.Parent) then stale=true;break end
end
local trade=env.VisualsV2Runtime.Trade
if stale and #cache==0 and tick()-last<5 then stale=false end
if (stale or tick()-last>6) and not (trade and trade.active) and os.clock()-bootStarted>=3 then
last=tick(); table.clear(cache)
local mg=pg:FindFirstChild("MainGUI")
if mg then
local started=os.clock()
for index,d in ipairs(mg:GetDescendants()) do
if index%250==0 and os.clock()-started>=bootBudget(0.002) then
task.wait();started=os.clock()
if not alive or not enabled then return end
end
local name=d.Name
if name=="Season1Stats" or name=="Stats" or name=="Container" then
local e=d:FindFirstChild("Eliminations"); local s=d:FindFirstChild("Saves"); local u=d:FindFirstChild("Survivals")
local row={}
if e and e:FindFirstChild("Amount") then row.e=e.Amount end
if s and s:FindFirstChild("Amount") then row.s=s.Amount end
if u and u:FindFirstChild("Amount") then row.u=u.Amount end
if row.e or row.s or row.u then table.insert(cache,row) end
end
end
end
end
for _,r in ipairs(cache) do
if r.e and r.e.Parent and r.e.Text~=v1 then r.e.Text=v1 end
if r.s and r.s.Parent and r.s.Text~=v2 then r.s.Text=v2 end
if r.u and r.u.Parent and r.u.Text~=v3 then r.u.Text=v3 end
end
end) else table.clear(cache) end
end
end)
env.VisualsV2Runtime.RegisterReset(function() toggle:Set(false); enabled=false; alive=false end)
end,"Section \"Visual Stat Spoofer\"")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
if not inMurderMystery then return end
local section=mainTab:AddSection("Coins","Utilities")
local esp={master=C("coinEspEnabled",false)==true,all=C("coinEspAll",true)==true,nearest=C("coinEspNearest",false)==true,
custom=C("coinCustomColorEnabled",false)==true,color=C("coinCustomColor",Color3.fromRGB(255,255,255))}
local highlights,originalColors={},{}
local espThread,colorConnection
local function coinParts()
local list={}
for _,top in ipairs(workspace:GetChildren()) do
local container=top:FindFirstChild("CoinContainer")
if not container then
for _,child in ipairs(top:GetChildren()) do
container=child:FindFirstChild("CoinContainer")
if container then break end
end
end
if container then
for _,coin in ipairs(container:GetChildren()) do
if coin.Name=="Coin_Server" and coin:IsA("BasePart") then list[#list+1]=coin end
end
end
end
return list
end
local function visualOf(coin)
local visual=coin:FindFirstChild("CoinVisual")
return visual and visual:IsA("BasePart") and visual or nil
end
local function darker(color) return Color3.new(math.max(color.R-0.25,0),math.max(color.G-0.25,0),math.max(color.B-0.25,0)) end
local function paint(coin)
local visual=visualOf(coin)
if not visual then return end
if originalColors[coin]==nil then originalColors[coin]=visual.Color end
if visual.Color~=esp.color then visual.Color=esp.color end
local highlight=highlights[coin]
if highlight and highlight.Parent then highlight.FillColor=esp.color;highlight.OutlineColor=darker(esp.color) end
end
local function unpaint(coin)
local original=originalColors[coin]
originalColors[coin]=nil
local visual=original and visualOf(coin)
if visual then visual.Color=original end
local highlight=highlights[coin]
if highlight and highlight.Parent and original then highlight.FillColor=original;highlight.OutlineColor=darker(original) end
end
local function unmark(coin)
local highlight=highlights[coin]
highlights[coin]=nil
if highlight then pcall(function() highlight:Destroy() end) end
end
local function mark(coin)
if highlights[coin] then return end
local visual=visualOf(coin) or coin
local highlight=Instance.new("Highlight")
highlight.Name="VisualsV2_CoinESP"
highlight.Adornee=visual
highlight.FillColor=visual.Color
highlight.FillTransparency=0.4
highlight.OutlineColor=darker(visual.Color)
highlight.OutlineTransparency=0
highlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
highlight.Parent=visual
highlights[coin]=highlight
end
local function espTick()
local coins=coinParts()
local wanted={}
if esp.nearest then
local character=player.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
local best,bestDistance=nil,math.huge
if root then
for _,coin in ipairs(coins) do
local distance=(coin.Position-root.Position).Magnitude
if distance<bestDistance then best,bestDistance=coin,distance end
end
end
if best then wanted[best]=true end
elseif esp.all or not esp.nearest then
for _,coin in ipairs(coins) do wanted[coin]=true end
end
for coin in pairs(wanted) do mark(coin) end
for coin in pairs(highlights) do if not wanted[coin] or not coin.Parent then unmark(coin) end end
if esp.custom then for _,coin in ipairs(coins) do paint(coin) end end
for coin in pairs(originalColors) do if not coin.Parent then originalColors[coin]=nil end end
end
local function refreshEsp()
if esp.master and runtimeAlive then
if not espThread then
espThread=task.spawn(function()
while esp.master and runtimeAlive do
pcall(espTick)
task.wait(0.5)
end
espThread=nil
end)
end
else
esp.master=false
for coin in pairs(highlights) do unmark(coin) end
end
end
local function refreshColor()
if colorConnection then colorConnection:Disconnect();colorConnection=nil end
if esp.custom and runtimeAlive then
colorConnection=workspace.DescendantAdded:Connect(function(object)
if object.Name=="Coin_Server" and object:IsA("BasePart") then
task.spawn(function()
local visual=object:FindFirstChild("CoinVisual") or object:WaitForChild("CoinVisual",5)
if visual and esp.custom and object.Parent then paint(object) end
end)
end
end)
for _,coin in ipairs(coinParts()) do paint(coin) end
else
for coin in pairs(originalColors) do if coin.Parent then unpaint(coin) else originalColors[coin]=nil end end
end
end
local espToggle=addToggle(section,"Coin ESP",esp.master,function(value)
esp.master=value;SetCfg("coinEspEnabled",value);refreshEsp()
end)
local allToggle=addToggle(section,"ESP All Coins",esp.all,function(value)
esp.all=value;SetCfg("coinEspAll",value)
end)
local nearestToggle=addToggle(section,"ESP Nearest Coin Only",esp.nearest,function(value)
esp.nearest=value;SetCfg("coinEspNearest",value)
end)
local colorToggle=addToggle(section,"Custom Coin Color",esp.custom,function(value)
esp.custom=value;SetCfg("coinCustomColorEnabled",value);refreshColor()
end)
section:AddColorpicker("Coin Color",esp.color,function(color)
esp.color=color;SetCfg("coinCustomColor",color)
if esp.custom then for _,coin in ipairs(coinParts()) do paint(coin) end end
end)
env.VisualsV2Runtime.RegisterReset(function()
espToggle:Set(false);allToggle:Set(false);nearestToggle:Set(false);colorToggle:Set(false)
esp.master,esp.all,esp.nearest,esp.custom=false,false,false,false
esp.color=Color3.fromRGB(255,255,255)
refreshEsp();refreshColor()
end)
end,"Section \"Coins\"")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local screenSection = mainTab:AddSection("Screen", "Visuals")
local stretchScreenEnabled = C("stretchScreenEnabled", false)
local STRETCH_FACTOR = 0.65
local stretchToggle = addToggle(screenSection, "Stretch Screen", stretchScreenEnabled, function(state)
stretchScreenEnabled = state
SetCfg("stretchScreenEnabled", state)
end)
local stretchLoop
stretchLoop=RunService.RenderStepped:Connect(function()
if not runtimeAlive then stretchLoop:Disconnect();return end
camera = workspace.CurrentCamera
if camera and stretchScreenEnabled then
camera.CFrame = camera.CFrame * CFrame.new(
0, 0, 0,
1, 0, 0,
0, STRETCH_FACTOR, 0,
0, 0, 1
)
end
end)
env.VisualsV2Runtime.RegisterReset(function()
stretchToggle:Set(false)
stretchScreenEnabled = false
end)
end,"Section \"Screen\"")
;vv2Section(function()
-- Keep frame callbacks and their local helper chains in the host VM.
LPH_ATTRIBUTES(VM(NONE), TRANSFORM(CONTROL_FLOW, EXTRACT(CONSTANTS)))
local worldSection=mainTab:AddSection("Environment","World")
if type(env.VisualsV2OriginalFog)~="table" then
env.VisualsV2OriginalFog={Lighting.FogStart,Lighting.FogEnd,Lighting.FogColor}
end
local savedFogStart=env.VisualsV2OriginalFog[1]
local savedFogEnd=env.VisualsV2OriginalFog[2]
local savedFogColor=env.VisualsV2OriginalFog[3]
local fullbrightEnabled=C("fullbrightEnabled",false)
local ambientColor=C("ambientColor",Lighting.Ambient)
local exposure=C("exposure",Lighting.ExposureCompensation)
local fogEnabled=false
local applyFog=nil
local savedClockTime=Lighting.ClockTime
local function applyFullbright()
Lighting.Brightness=2
Lighting.ClockTime=14
Lighting.FogEnd=100000
Lighting.GlobalShadows=false
Lighting.Ambient=Color3.fromRGB(255,255,255)
Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
end
local function disableFullbright()
Lighting.Brightness=1
Lighting.GlobalShadows=true
Lighting.FogEnd=savedFogEnd
Lighting.Ambient=ambientColor
Lighting.OutdoorAmbient=ambientColor
Lighting.ExposureCompensation=exposure
Lighting.ClockTime=savedClockTime
end
local fullbrightToggle=addToggle(worldSection,"Fullbright",fullbrightEnabled,function(state)
fullbrightEnabled=state
SetCfg("fullbrightEnabled",state)
if state then
applyFullbright()
else
disableFullbright()
if fogEnabled and applyFog then applyFog() end
end
end)
worldSection:AddColorpicker("Ambient Color",ambientColor,function(color)
ambientColor=color
SetCfg("ambientColor",color)
if not fullbrightEnabled then
Lighting.Ambient=color
Lighting.OutdoorAmbient=color
end
end)
worldSection:AddSlider("Exposure",-2,5,exposure,function(value)
exposure=value
SetCfg("exposure",value)
Lighting.ExposureCompensation=value
end)
if fullbrightEnabled then applyFullbright() else disableFullbright() end
local fogSection=mainTab:AddSection("Fog","World")
fogEnabled=C("fogEnabled",false)
local fogRainbow=C("fogRainbow",false)
local fogColor=C("fogColor",Color3.fromRGB(200,200,255))
local fogStart=math.max(0,tonumber(C("fogStart",0)) or 0)
local fogEnd=math.max(50,tonumber(C("fogEnd",100)) or 100)
applyFog=function()
Lighting.FogStart=fogStart
Lighting.FogEnd=math.max(fogStart+1,fogEnd)
Lighting.FogColor=fogRainbow and Color3.fromHSV((os.clock()%5)/5,1,1) or fogColor
end
-- (Roblox switches this fog off while an Atmosphere is in Lighting, so Custom Time of Day leaves
-- its Atmosphere out while the fog is on)
env.VisualsV2Runtime.FogOn=function() return fogEnabled end
local fogToggle=addToggle(fogSection,"Enable Beautiful Fog",fogEnabled,function(state)
fogEnabled=state
SetCfg("fogEnabled",state)
local refreshTime=env.VisualsV2Runtime.RefreshTimeOfDay
if type(refreshTime)=="function" then pcall(refreshTime) end
if state then
if not fullbrightEnabled then applyFog() end
else
Lighting.FogStart=savedFogStart
Lighting.FogEnd=savedFogEnd
Lighting.FogColor=savedFogColor
end
end)
local rainbowFogToggle=addToggle(fogSection,"Rainbow Fog",fogRainbow,function(state)
fogRainbow=state
SetCfg("fogRainbow",state)
if fogEnabled and not fullbrightEnabled then applyFog() end
end)
fogSection:AddSlider("Fog Distance",50,2000,fogEnd,function(value)
fogEnd=value
SetCfg("fogEnd",value)
if fogEnabled and not fullbrightEnabled then applyFog() end
end)
fogSection:AddSlider("Fog Start",0,500,fogStart,function(value)
fogStart=value
SetCfg("fogStart",value)
if fogEnabled and not fullbrightEnabled then applyFog() end
end)
fogSection:AddColorpicker("Fog Color",fogColor,function(color)
fogColor=color
SetCfg("fogColor",color)
if fogEnabled and not fogRainbow and not fullbrightEnabled then applyFog() end
end)
local fogLoop
fogLoop=RunService.RenderStepped:Connect(function()
if not runtimeAlive then fogLoop:Disconnect();return end
if fogEnabled and fogRainbow and not fullbrightEnabled then
Lighting.FogColor=Color3.fromHSV((os.clock()%5)/5,1,1)
end
end)
local skyboxSection=mainTab:AddSection("Skyboxes","Visuals")
local currentSky=Lighting:FindFirstChildOfClass("Sky")
env.VisualsV2OriginalSky=currentSky and currentSky:Clone() or false
local originalSky=env.VisualsV2OriginalSky
local selectedSkybox=C("selectedSkybox","Default")
local SKYBOX_PRESETS={
["Orange Skybox"]="627302570",
["FPS+ Skybox"]="582303304",
["Space Skybox"]="15619750970",
["Green Skybox"]="348361280",
["Blue Skybox"]="130093177270069",
["Purple Skybox"]="83555979203508",
["Red Skybox"]="401666131",
["HD Skybox"]="16823410580",
["Night Skybox"]="12064636",
["Galactic Skybox"]="10542194896",
["Winter Skybox"]="96628448286151",
["Saturn Skybox"]="1898754079",
["Outrun Skybox"]="3441770362",
["Cyan Space Skybox"]="367149630",
["City Skybox"]="117205995214134",
["Green Skybox 2.0"]="16823294549",
["Obama Skybox (Joke)"]="2362934358",
["SpongeBob Skybox"]="16054383681",
["Purple Nebula Skybox"]="230057997",
["Bart Skybox"]="119891349513795",
["Sunless Blue Sky"]="591067775",
["Weirdcore Eye Skybox"]="11372740893",
["Minecraft Skybox"]="5087871978",
["Frutiger Aero Skybox"]="97046110924083",
["Cyberpunk Skybox"]="13689001090",
["Dark Red Castle Skybox"]="15832476802",
["Cartoon Skybox"]="528506487",
["Error Skybox"]="13710730784",
["Abyssal Blues Skybox"]="16269853692",
["Earth Skybox"]="266878339",
["Black & White Fade Skybox"]="6213224205",
["Purple Skybox 2"]="8107887936",
["Green Nebula Space"]="89018019804256",
["HD Rainbow Skybox"]="18915196644",
["Meadow Skybox"]="848241313",
["Pink Sky Skybox"]="107689530722174",
["Venus Skybox V2"]="110450592899174",
["Classic Roblox Sky"]="339406852",
["2006 Roblox Sky"]="49258585",
["Sunset With Sun"]="5186800496",
["Orange Sunset Skybox"]="11681668931",
["Sunset Dawn Skybox"]="325545295",
["Snow Skybox"]="4604073339",
["Fog On The Water"]="15876671760",
["Anime Island Skybox"]="14753835117",
["Hills Skybox"]="10194211410",
["Forest Skybox"]="16455358066",
["Clouds Skybox"]="3146864089",
["Rainy Day Skybox"]="246481636",
["Realistic Skybox"]="8238531417",
["Rainbow Skybox"]="16573649975",
["One Piece Skybox"]="158518054",
["Deep Space Skybox"]="196277044",
["Realistic Space Skybox"]="136402262",
["Red Night Skybox"]="5834531764",
["Grimm Night Skybox"]="332466267",
["Realistic Sky"]={"144933338","144931530","144933262","144933244","144933299","144931564"},
["Purple Nighty #1"]={"159454299","159454296","159454293","159454286","159454300","159454288"},
["Purple Nighty #2"]={"14543264135","14543358958","14543257810","14543275895","14543280890","14543371676"},
["Sunset"]={"15502525195","15502522797","15502524520","15502522129","15502523711","15502526102"},
["Nighty Sky"]={"168387023","168387089","168387054","168534432","168387190","168387135"},
["Sunset Sky"]={"458016711","458016826","458016532","458016655","458016782","458016792"},
["Night Fog"]={"1370717244","1370717336","1370717438","1370717567","1370717698","1370717782"},
["Blood Moon"]={"401664839","401664862","401664960","401664881","401664901","401664936"},
["Pink Blossom"]={"271042516","271077243","271042556","271042310","271042467","271077958"},
["Purple Sunset"]={"264908339","264907909","264909420","264909758","264908886","264907379"},
["Void Sky"]={"16262356578","16262358026","16262360469","16262362003","16262363873","16262366016"},
["Purple Night"]={"5084575798","5084575916","5103949679","5103948542","5103948784","5084576400"},
["Realistic Moon"]={"2670643994","2670643365","2670643214","2670643070","2670644173","2670644331"},
["Half-Life 2 Sky"]={"9000922368","9000922033","9000921543","9000920853","9000920563","9000920353"},
["Unity Skybox"]={"6444884337","6444884785","6444884337","6444884337","6444884337","6412503613"},
["Half-Life 2 Sky 2"]={"8991308822","8991308505","8991308320","8991308038","8991307660","8991307329"},
["Dark Sky Sunset"]={"17359299523","17359302440","17359305344","17359309400","17359311050","17359315951"},
["City Skybox 2"]={"9134792889","9134791975","9134793457","9134791234","9134790419","9134791633"},
["Binary Skybox"]={"123467543898066","113252732","123467543898066","123467543898066","123467543898066","119357062270720"},
["Dark City Skybox"]={"163897885","163898013","163899342","163897886","163897887","163898013"},
["Peaceful Pink Skybox"]={"12635309703","12635311686","12635312870","12635313718","12635315817","12635316856"},
["Sonic Skybox"]={"21645985","13228981","21645985","21645985","21645985","42797182"},
["Realistic Sky 2"]={"150335574","150335585","150335628","150335620","150335610","150335642"},
["Aurora Sky"]={"123322468493829","72328364720362","82669890261624","79073157167029","98897208171169","110573759236511"},
["Purple Planets Skybox"]={"15983968922","15983966825","15983965025","15983967420","15983966246","15983964246"},
["Minecraft [DAY]"]={"8735166756","8735166707","8735231668","8735166755","8735166751","8735166729"},
["Minecraft [END]"]={"9003053409","9003053409","9003053409","9003053409","9003053409","9003053409"},
["Night City Sky"]={"96980784585741","126576283428135","84691952680539","128829859532871","77183579766890","119866834070072"},
["Tick... Tock..."]={"80453038503552","70583031756749","126635708280387","107023487794625","73372776851796","102605311448017"},
["Dark Sunset"]={"169210090","169210108","169210121","169210133","169210143","169210149"},
["Night Mountains"]={"12064107","12064152","12064121","12063984","12064115","12064131"},
["Blue Space"]={"16876760844","16876762818","16876765234","16876767659","16876769447","16876771721"},
["Frutiger Aero Skybox 2"]={"120267326588329","17423929525","120267326588329","120267326588329","120267326588329","17423929525"},
["Retro Skybox"]={"18164881924","18166113875","18164870251","18164877945","18164873920","18164890128"},
["Space Skybox 2"]={"15146674442","15146673704","15146672849","15146672013","15146671172","15146670489"},
["Nyan Cat"]={"7737559336","7737559336","7737559336","7737559336","7737559336","7737559336"},
["Sunset Realistic"]={"246894245","246893155","246894274","246894229","246892987","246894296"},
["Desert Sunset"]={"248158002","248157859","248158032","248157792","248157954","248158064"},
["Baldi's Basics Sunset"]={"17355877310","17355877198","17355877118","17355876971","17355876879","17355876754"},
["Purple Sunset 2"]={"2673288163","2673288535","2673288917","2673288326","2673288727","2673288003"},
["Green Aurora"]={"1189342197","1189344004","1189343142","1189342397","1189341941","1189343376"},
["Starry Night"]={"5260808177","5260653793","5260817288","5260800833","5260811073","5260824661"},
["Purple Galaxy"]={"99468191699832","121098906941255","106290292308760","102557334804626","97361097874537","138727520721658"},
["Green Northern Lights"]={"5952660779","5952669635","5952660779","5952660779","5952660779","5952674952"},
}
if selectedSkybox~="Default" and SKYBOX_PRESETS[selectedSkybox]==nil then
selectedSkybox="Default"
ConfigData["selectedSkybox"]="Default"
end
local SKYBOX_NAMES={
"Default",
"Orange Skybox","FPS+ Skybox","Space Skybox","Green Skybox","Blue Skybox",
"Purple Skybox","Red Skybox","HD Skybox","Night Skybox","Galactic Skybox",
"Winter Skybox","Saturn Skybox","Outrun Skybox","Cyan Space Skybox","City Skybox",
"Green Skybox 2.0","Obama Skybox (Joke)","SpongeBob Skybox","Purple Nebula Skybox",
"Bart Skybox","Sunless Blue Sky","Weirdcore Eye Skybox","Minecraft Skybox",
"Frutiger Aero Skybox","Cyberpunk Skybox","Dark Red Castle Skybox","Cartoon Skybox",
"Error Skybox","Abyssal Blues Skybox","Earth Skybox",
"Black & White Fade Skybox","Purple Skybox 2","Green Nebula Space","HD Rainbow Skybox",
"Meadow Skybox","Pink Sky Skybox","Venus Skybox V2",
"Realistic Sky","Purple Nighty #1","Purple Nighty #2","Sunset","Nighty Sky",
"Sunset Sky","Night Fog","Blood Moon","Pink Blossom","Purple Sunset",
"Void Sky","Purple Night","Realistic Moon",
"Classic Roblox Sky","2006 Roblox Sky","Sunset With Sun","Orange Sunset Skybox","Sunset Dawn Skybox",
"Snow Skybox","Fog On The Water","Anime Island Skybox","Hills Skybox","Forest Skybox",
"Clouds Skybox","Rainy Day Skybox","Realistic Skybox","Rainbow Skybox","One Piece Skybox",
"Deep Space Skybox","Realistic Space Skybox","Red Night Skybox","Grimm Night Skybox","Half-Life 2 Sky",
"Unity Skybox","Half-Life 2 Sky 2","Dark Sky Sunset","City Skybox 2","Binary Skybox",
"Dark City Skybox","Peaceful Pink Skybox","Sonic Skybox","Realistic Sky 2","Aurora Sky",
"Purple Planets Skybox","Minecraft [DAY]","Minecraft [END]","Night City Sky","Tick... Tock...",
"Dark Sunset","Night Mountains","Blue Space","Frutiger Aero Skybox 2","Retro Skybox",
"Space Skybox 2","Nyan Cat","Sunset Realistic","Desert Sunset","Baldi's Basics Sunset",
"Purple Sunset 2","Green Aurora","Starry Night","Purple Galaxy","Green Northern Lights",
}
local sky={current=nil,name=nil,parked={},cache={},loading={},connections={},token=0,budget=0,budgetAt=-math.huge,
atmospheres={},clouds=nil,clock=nil}
local function skyTag(object)
local tag
pcall(function() tag=object:GetAttribute("VisualsV2SkyboxPreset") end)
return tag
end
local function allowed()
local now=os.clock()
if now-sky.budgetAt>=1 then sky.budgetAt=now;sky.budget=0 end
sky.budget=sky.budget+1
return sky.budget<=5
end
local function parkSky(object)
if object==sky.current then return end
if skyTag(object)~=nil then pcall(function() object:Destroy() end);return end
if not table.find(sky.parked,object) then sky.parked[#sky.parked+1]=object end
pcall(function() object.Parent=nil end)
end
local function parkOthers()
for _,child in ipairs(Lighting:GetChildren()) do
if child:IsA("Sky") and child~=sky.current then parkSky(child) end
end
end
local function unpark()
local back=nil
for index=#sky.parked,1,-1 do
local object=sky.parked[index]
local name=""
pcall(function() name=object.Name end)
if not back and name:sub(1,10)~="VisualsV2_" then
if pcall(function() object.Parent=Lighting end) and object.Parent==Lighting then back=object end
end
end
table.clear(sky.parked)
return back
end
local function stopWatching()
for _,connection in ipairs(sky.connections) do connection:Disconnect() end
table.clear(sky.connections)
end
local function parkAtmosphere(object)
local name=""
pcall(function() name=object.Name end)
if name:sub(1,10)=="VisualsV2_" then return end
if not table.find(sky.atmospheres,object) then sky.atmospheres[#sky.atmospheres+1]=object end
pcall(function() object.Parent=nil end)
end
local SKY_CLOCK=14
local function ownTime()
local active=env.VisualsV2Runtime.TimeOfDayActive
return Lighting:FindFirstChild("VisualsV2_TimeAtmosphere")~=nil or (type(active)=="function" and active()==true)
end
local function daylight()
if ownTime() or Lighting.ClockTime==SKY_CLOCK then return end
sky.clock=Lighting.ClockTime
pcall(function() Lighting.ClockTime=SKY_CLOCK end)
end
local function restoreClock()
local back=sky.clock
sky.clock=nil
if back and Lighting.ClockTime==SKY_CLOCK and not ownTime() then
pcall(function() Lighting.ClockTime=back end)
end
end
local function hideHaze()
daylight()
for _,child in ipairs(Lighting:GetChildren()) do
if child:IsA("Atmosphere") then parkAtmosphere(child) end
end
local terrain=workspace:FindFirstChildOfClass("Terrain")
local clouds=terrain and terrain:FindFirstChildOfClass("Clouds")
if clouds and clouds.Enabled then
sky.clouds=clouds
pcall(function() clouds.Enabled=false end)
end
end
local function showHaze()
local last=sky.atmospheres[#sky.atmospheres]
if last and not Lighting:FindFirstChildOfClass("Atmosphere") then
pcall(function() last.Parent=Lighting end)
end
table.clear(sky.atmospheres)
if sky.clouds then pcall(function() sky.clouds.Enabled=true end) end
sky.clouds=nil
restoreClock()
end
local function setFaces(object,ids)
object.SkyboxBk="rbxassetid://"..ids[1]
object.SkyboxDn="rbxassetid://"..ids[2]
object.SkyboxFt="rbxassetid://"..ids[3]
object.SkyboxLf="rbxassetid://"..ids[4]
object.SkyboxRt="rbxassetid://"..ids[5]
object.SkyboxUp="rbxassetid://"..ids[6]
end
local function presetSky(name)
local cached=sky.cache[name]
if cached then return cached end
if sky.loading[name] then
local started=os.clock()
while sky.loading[name] and os.clock()-started<20 do task.wait(0.1) end
if sky.cache[name] then return sky.cache[name] end
end
local data=SKYBOX_PRESETS[name]
local made
if type(data)=="table" then
made=Instance.new("Sky")
setFaces(made,data)
else
sky.loading[name]=true
local ok,asset=pcall(function() return game:GetObjects("rbxassetid://"..tostring(data))[1] end)
local why=not ok and tostring(asset) or (typeof(asset)~="Instance" and "nothing came back" or nil)
if not ok or typeof(asset)~="Instance" then
ok,asset=pcall(function()
local download=env.VisualsV2Runtime.GetObjects
return type(download)=="function" and download("rbxassetid://"..tostring(data))[1] or nil
end)
end
sky.loading[name]=nil
if ok and typeof(asset)=="Instance" then
pcall(function() asset.Archivable=true end)
if asset:IsA("Sky") then made=asset
else
local nested=asset:FindFirstChildWhichIsA("Sky",true)
if nested then pcall(function() nested.Archivable=true end);made=nested:Clone()
else why="the download had no sky in it ("..asset.ClassName..")" end
pcall(function() asset:Destroy() end)
end
end
if not made then return nil,why or "it couldn't be downloaded" end
end
pcall(function() made:SetAttribute("VisualsV2SkyboxPreset",name) end)
sky.cache[name]=made
return made
end
local function putBack()
local current=sky.current
if not current or current.Parent==Lighting then return end
if pcall(function() current.Parent=Lighting end) and current.Parent==Lighting then return end
local template=sky.cache[sky.name] or sky.template
if template then
local fresh=template:Clone()
sky.current=fresh
parkOthers()
fresh.Parent=Lighting
end
end
local function recheckLater()
if sky.recheck then return end
sky.recheck=true
task.delay(1,function()
sky.recheck=false
if not sky.current or sky.name~=selectedSkybox or not runtimeAlive then return end
if not allowed() then recheckLater();return end
putBack()
parkOthers()
end)
end
local function watch()
stopWatching()
sky.connections[1]=Lighting.ChildAdded:Connect(function(child)
if child:IsA("Atmosphere") then
task.defer(function()
if sky.current and child.Parent==Lighting then parkAtmosphere(child) end
end)
return
end
if not child:IsA("Sky") or child==sky.current then return end
task.defer(function()
if not sky.current or child.Parent~=Lighting or child==sky.current then return end
if allowed() then parkSky(child) else recheckLater() end
end)
end)
sky.connections[3]=Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
task.defer(function()
if sky.current and Lighting.ClockTime~=SKY_CLOCK and not ownTime() and allowed() then daylight() end
end)
end)
sky.connections[2]=Lighting.ChildRemoved:Connect(function(child)
if child~=sky.current then return end
task.defer(function()
if selectedSkybox=="Default" or sky.name~=selectedSkybox or sky.current~=child then return end
if allowed() then putBack() else recheckLater() end
end)
end)
end
local function applySelectedSkybox()
sky.token=sky.token+1
local token=sky.token
if selectedSkybox=="Default" or SKYBOX_PRESETS[selectedSkybox]==nil then
stopWatching()
local old=sky.current
sky.current,sky.name=nil,nil
if old then pcall(function() old:Destroy() end) end
for _,child in ipairs(Lighting:GetChildren()) do
if child:IsA("Sky") and skyTag(child)~=nil then pcall(function() child:Destroy() end) end
end
showHaze()
local back=unpark()
if not back and not Lighting:FindFirstChildOfClass("Sky") and typeof(originalSky)=="Instance" then
pcall(function() originalSky:Clone().Parent=Lighting end)
end
return
end
local name=selectedSkybox
local template,why=presetSky(name)
if token~=sky.token or not runtimeAlive then return end
if not template then return nil,why end
local old=sky.current
pcall(function() template.Archivable=true end)
local fresh=template:Clone() or template
sky.current,sky.name,sky.template=fresh,name,template
if old and old~=fresh then pcall(function() old:Destroy() end) end
parkOthers()
hideHaze()
fresh.Parent=Lighting
watch()
return fresh
end
local skyDropdown
local function applyPicked()
local name=selectedSkybox
local ok,result,why=pcall(applySelectedSkybox)
if not ok then why=result end
if (not ok or (result==nil and why)) and selectedSkybox==name then
pcall(shared.Notify,"Skybox: "..name.." couldn't be put on ("..tostring(why)..")",1)
end
end
skyDropdown=addDropdown(skyboxSection,"Skybox",SKYBOX_NAMES,selectedSkybox,function(value)
if type(value)=="table" then value=value[1] or value.Value or value.value end
if value~="Default" and SKYBOX_PRESETS[value]==nil then return false end
selectedSkybox=value
SetCfg("selectedSkybox",value)
task.spawn(applyPicked)
end,false)
task.defer(applySelectedSkybox)
if fogEnabled and not fullbrightEnabled then applyFog() end
env.VisualsV2Runtime.RegisterReset(function()
fullbrightToggle:Set(false)
fogToggle:Set(false)
rainbowFogToggle:Set(false)
fullbrightEnabled=false
fogEnabled=false
fogRainbow=false
selectedSkybox="Default"
if runtimeAlive and type(skyDropdown)=="table" and type(skyDropdown.Select)=="function" then
pcall(skyDropdown.Select,"Default")
end
applySelectedSkybox()
fullbrightEnabled=false
disableFullbright()
end)
end,"Section \"Environment / Fog / Skyboxes\"")
;vv2Section(function()
local Minecraftizer=mainTab:AddSection("Minecraftizer","World")
local materialTextures = {
[Enum.Material.Asphalt] = "rbxassetid://10777285622",
[Enum.Material.Basalt] = "rbxassetid://10777285622",
[Enum.Material.Brick] = "rbxassetid://10777285622",
[Enum.Material.Carpet] = "rbxassetid://18699165714",
[Enum.Material.Fabric] = "rbxassetid://18699165714",
[Enum.Material.CeramicTiles] = "rbxassetid://82688463827095",
[Enum.Material.Cobblestone] = "rbxassetid://112006332656762",
[Enum.Material.Concrete] = "rbxassetid://76434845888896",
[Enum.Material.CrackedLava] = "rbxassetid://6072514670",
[Enum.Material.DiamondPlate] = "rbxassetid://121527765592383",
[Enum.Material.Glacier] = "rbxassetid://138703197443219",
[Enum.Material.Glass] = "rbxassetid://11384458772",
[Enum.Material.Granite] = "rbxassetid://84691298982406",
[Enum.Material.Grass] = "rbxassetid://129412557796389",
[Enum.Material.LeafyGrass] = "rbxassetid://129412557796389",
[Enum.Material.Ground] = "rbxassetid://114241584338245",
[Enum.Material.Ice] = "rbxassetid://11413423466",
[Enum.Material.Marble] = "rbxassetid://71371694781487",
[Enum.Material.Metal] = "rbxassetid://8677286748",
[Enum.Material.Mud] = "rbxassetid://5104022863",
[Enum.Material.Pavement] = "rbxassetid://76838016906118",
[Enum.Material.Rock] = "rbxassetid://92531008905854",
[Enum.Material.Salt] = "rbxassetid://112438351210604",
[Enum.Material.Sand] = "rbxassetid://9277770677",
[Enum.Material.Sandstone] = "rbxassetid://120884186339230",
[Enum.Material.Slate] = "rbxassetid://92531008905854",
[Enum.Material.Snow] = "rbxassetid://11108881974",
[Enum.Material.Wood] = "rbxassetid://8676581022",
[Enum.Material.WoodPlanks] = "rbxassetid://8676581022",
}
local CONCRETE = "rbxassetid://76434845888896"
local otherTextures = {
Plastic = CONCRETE, SmoothPlastic = CONCRETE, Neon = CONCRETE, Plaster = CONCRETE, Rubber = CONCRETE,
Foil = "rbxassetid://8677286748", CorrodedMetal = "rbxassetid://8677286748",
Limestone = "rbxassetid://120884186339230", Pebble = "rbxassetid://112006332656762",
Cardboard = "rbxassetid://8676581022", Leather = "rbxassetid://18699165714", Clay = "rbxassetid://114241584338245",
}
local SKIPPED = {ForceField = true}
local faces = Enum.NormalId:GetEnumItems()
local enabled = false
local connection = nil
local made = setmetatable({}, {__mode = "k"})
local hidden = setmetatable({}, {__mode = "k"})
local texturesByName = {}
for material, id in pairs(materialTextures) do texturesByName[material.Name] = id end
local replaced = {}
local function textureFor(part)
local name = part.Material.Name
if SKIPPED[name] then return nil end
local id = texturesByName[name] or otherTextures[name] or CONCRETE
return replaced[id] or id
end
local function keepsOwnLook(part)
if part:IsA("MeshPart") and part.TextureID ~= "" then return true end
if part:FindFirstChildWhichIsA("SurfaceAppearance") or part:FindFirstChildWhichIsA("Decal") then return true end
return false
end
local WEAPON_WORDS = {"knife", "gun", "weapon", "throw", "projectile", "display"}
local function partOfMap(part)
if not part.Anchored then return false end
local node = part
while node and node ~= workspace do
if node:IsA("Tool") or node:IsA("Accessory") or node:FindFirstChildOfClass("Humanoid") then return false end
if node:GetAttribute("VisualsV2_ClientWeaponSkin") or node.Name:sub(1, 9) == "VisualsV2" then return false end
if node.Parent == workspace or node.Parent == workspace.CurrentCamera then
local name = node.Name:lower()
for _, word in ipairs(WEAPON_WORDS) do if name:find(word, 1, true) then return false end end
end
node = node.Parent
end
return true
end
local function applyTexture(part)
if not enabled or not part.Parent or not part:IsA("BasePart") then return end
if part.Transparency >= 0.99 then hidden[part] = true;return end
hidden[part] = nil
if part:FindFirstChild("MCTexture") or not partOfMap(part) then return end
if not texturesByName[part.Material.Name] and keepsOwnLook(part) then return end
local id = textureFor(part)
if not id then return end
for _, face in ipairs(faces) do
local texture = Instance.new("Texture")
texture.Name = "MCTexture"
texture.Texture = id
texture.Face = face
texture.StudsPerTileU = 4
texture.StudsPerTileV = 4
texture.Color3 = part.Color
texture.Parent = part
made[texture] = true
end
end
local batch = env.VisualsV2Runtime.MakeBatcher(applyTexture, 0.002, 100)
local checked = false
local function checkTextures()
if checked then return end
checked = true
task.spawn(function()
local list, seen = {}, {}
for _, id in pairs(texturesByName) do if not seen[id] then seen[id] = true;list[#list + 1] = id end end
for _, id in pairs(otherTextures) do if not seen[id] then seen[id] = true;list[#list + 1] = id end end
local failed = {}
pcall(function()
game:GetService("ContentProvider"):PreloadAsync(list, function(contentId, status)
local state = tostring(status)
if state:find("Failure", 1, true) or state:find("TimedOut", 1, true) then
local digits = tostring(contentId):match("%d+")
if digits then failed["rbxassetid://" .. digits] = true end
end
end)
end)
if not runtimeAlive or not next(failed) then return end
local working
for _, id in ipairs({CONCRETE, "rbxassetid://112006332656762", "rbxassetid://92531008905854"}) do
if not failed[id] then working = id;break end
end
if not working then for _, id in ipairs(list) do if not failed[id] then working = id;break end end end
if not working then return end
for id in pairs(failed) do replaced[id] = working end
for texture in pairs(made) do
local swap = replaced[texture.Texture]
if swap then texture.Texture = swap end
end
end)
end
local function removeTextures()
for texture in pairs(made) do
made[texture] = nil
pcall(texture.Destroy, texture)
end
for _, obj in ipairs(workspace:GetDescendants()) do
if obj:IsA("Texture") and obj.Name == "MCTexture" then obj:Destroy() end
end
end
local sweep
local function start()
enabled = true
checkTextures()
for _, part in ipairs(workspace:GetDescendants()) do
if part:IsA("BasePart") then batch.Push(part) end
end
if not connection then
connection = workspace.DescendantAdded:Connect(function(part)
if enabled and part:IsA("BasePart") then batch.Push(part) end
end)
end
if not sweep then
sweep = task.spawn(function()
while enabled and runtimeAlive do
task.wait(3)
for part in pairs(hidden) do
if part.Parent and part.Transparency < 0.99 then batch.Push(part) end
end
end
sweep = nil
end)
end
end
local function stop()
enabled = false
batch.Clear()
table.clear(hidden)
if connection then
connection:Disconnect()
connection = nil
end
if sweep then pcall(task.cancel, sweep);sweep = nil end
removeTextures()
end
local toggle = addToggle(Minecraftizer, "Minecraftizer", C("vv2MinecraftizerEnabled", false), function(state)
SetCfg("vv2MinecraftizerEnabled", state)
if state then
start()
else
stop()
end
end)
env.VisualsV2Runtime.RegisterReset(function()
toggle:Set(false)
stop()
end)
end,"Section \"Minecraftizer\"")
;vv2Section(function()
local miscSection=mainTab:AddSection("Miscellaneous","Settings")
local restoreAskedAt=-math.huge
miscSection:AddButton("Restore Defaults",function()
if not runtimeAlive or type(env.VisualsV2Runtime.RestoreDefaults)~="function" then return end
if os.clock()-restoreAskedAt>5 then
restoreAskedAt=os.clock()
pcall(shared.Notify,"Restore Defaults: press it again within 5 seconds to reset all of Visuals V2",0)
return
end
restoreAskedAt=-math.huge
env.VisualsV2Runtime.RestoreDefaults()
pcall(shared.Notify,"Restore Defaults: Visuals V2 is back to its defaults (settings file deleted). Re-execute it to start fresh.",2)
end)
end,"Section \"Miscellaneous\"")
local function onCharacterAdded(char)
characterOriginal=setmetatable({}, {__mode="k"})
if headlessEnabled then
task.spawn(function()
char:WaitForChild("Head",2)
if player.Character==char and headlessEnabled and applyCharacterVisuals then
applyCharacterVisuals()
end
end)
end
if KorbloxSystem and (KorbloxSystem.RightEnabled or KorbloxSystem.LeftEnabled) then
KorbloxSystem.Schedule(char)
end
task.delay(0.15,function()
if player.Character~=char then return end
local function again(callback,...)
if type(callback)~="function" then return end
local ok,problem=pcall(callback,...)
if not ok then pcall(warn,"[Visuals V2] "..tostring(problem)) end
end
if trailEnabled then again(createTrail) end
if ffEnabled then again(applyForceField); again(refreshForceFieldConnection) end
if skinTrailEnabled then again(applySkinTrail); again(refreshSkinTrailRainbowConnection) end
if auraEnabled then again(applyAura) end
again(setupJumpCircles,char)
end)
end
if player.Character then task.defer(function() onCharacterAdded(player.Character) end) end
player.CharacterAdded:Connect(onCharacterAdded)
saveConfig()
local performanceTab=mainTab
;vv2Section(function()
-- Batch/initialization work retains virtualization with the documented fast preset.
LPH_ATTRIBUTES(PRESET(FAST))
local section=performanceTab:AddSection("Performance & Optimization","Performance")
local P=game:GetService("Players")
local originalMat,originalPart,originalTex,originalAcc,originalSky={},{},{},{},{}
local conns={}; local frameConn=nil
local state={
smooth=C("perfSmooth",false), shadows=C("perfShadows",false), particles=C("perfParticles",false),
meshes=C("perfMeshes",false), textures=C("perfTextures",false), accessories=C("perfAccessories",false),
gray=C("perfGray",false), frame=C("perfFrame",false),
weaponDisplays=C("perfWeaponDisplays",false)
}
local originalShadows=Lighting.GlobalShadows
local function isPlayer(o) for _,p in ipairs(P:GetPlayers()) do if p.Character and o:IsDescendantOf(p.Character) then return true end end return false end
local passTokens={}
local function mapPass(key,fn)
local token={}
passTokens[key]=token
task.spawn(function()
local list=workspace:GetDescendants()
local started=os.clock()
for _,o in ipairs(list) do
if passTokens[key]~=token or not runtimeAlive then return end
pcall(fn,o)
if os.clock()-started>=bootBudget(0.003) then task.wait();started=os.clock() end
end
if passTokens[key]==token then passTokens[key]=nil end
end)
end
local function stopPass(key) passTokens[key]=nil end
local function smoothOne(o) if o:IsA("BasePart") and not isPlayer(o) then if originalMat[o]==nil then originalMat[o]=o.Material end; o.Material=Enum.Material.SmoothPlastic end end
local function setSmooth(on)
if conns.s then conns.s:Disconnect(); conns.s=nil end
stopPass("s")
if on then
mapPass("s",smoothOne)
conns.s=workspace.DescendantAdded:Connect(smoothOne)
else for o,v in pairs(originalMat) do if o and o.Parent then pcall(function() o.Material=v end) end end; originalMat={} end
end
local function setParticles(on)
if conns.p then conns.p:Disconnect(); conns.p=nil end
local function one(o) if o:IsA("ParticleEmitter") or o:IsA("Trail") then if originalPart[o]==nil then originalPart[o]=o.Enabled end; o.Enabled=false end end
stopPass("p")
if on then mapPass("p",one); conns.p=workspace.DescendantAdded:Connect(one)
else for o,v in pairs(originalPart) do if o and o.Parent then pcall(function() o.Enabled=v end) end end; originalPart={} end
end
local function setMeshes(on)
if conns.m then conns.m:Disconnect(); conns.m=nil end
local function one(o)
if isPlayer(o) then return end
local p=(o:IsA("MeshPart") and o) or ((o:IsA("SpecialMesh") or o:IsA("BlockMesh") or o:IsA("CylinderMesh")) and o.Parent)
if p and p:IsA("BasePart") and not isPlayer(p) then if originalPart[p]==nil then originalPart[p]=p.Transparency end; p.Transparency=1 end
end
stopPass("m")
if on then mapPass("m",one); conns.m=workspace.DescendantAdded:Connect(one)
else for o,v in pairs(originalPart) do if o and o.Parent and o:IsA("BasePart") then pcall(function() o.Transparency=v end) end end end
end
local function setTextures(on)
if conns.t then conns.t:Disconnect(); conns.t=nil end
local function one(o) if o:IsA("Decal") or o:IsA("Texture") then if originalTex[o]==nil then originalTex[o]=o.Texture end; o.Texture="" end end
stopPass("t")
if on then mapPass("t",one); conns.t=workspace.DescendantAdded:Connect(one)
else for o,v in pairs(originalTex) do if o and o.Parent then pcall(function() o.Texture=v end) end end; originalTex={} end
end
local function setAccessories(on)
if on then
for _,p in ipairs(P:GetPlayers()) do if p.Character then for _,a in ipairs(p.Character:GetChildren()) do if a:IsA("Accessory") then originalAcc[a]=p; a.Parent=nil end end end end
else for a,p in pairs(originalAcc) do if a and p and p.Character and not a.Parent then pcall(function() a.Parent=p.Character end) end end; originalAcc={} end
end
local function setGray(on)
if on then
for _,s in ipairs(Lighting:GetChildren()) do if s:IsA("Sky") and s.Name~="VisualsV2_GraySky" then originalSky[s]=s.Parent; s.Parent=nil end end
local sky=Instance.new("Sky"); sky.Name="VisualsV2_GraySky"; local id="rbxassetid://99742693890881"; sky.SkyboxBk=id; sky.SkyboxDn=id; sky.SkyboxFt=id; sky.SkyboxLf=id; sky.SkyboxRt=id; sky.SkyboxUp=id; sky.Parent=Lighting
else
local s=Lighting:FindFirstChild("VisualsV2_GraySky"); if s then s:Destroy() end
for sky,parent in pairs(originalSky) do if sky then sky.Parent=parent end end; originalSky={}
end
end
local function setFrame(on)
if frameConn then frameConn:Disconnect(); frameConn=nil end
stopPass("f")
local function degrade(o)
if o:IsA("BasePart") then o.CastShadow=false; pcall(function() o.RenderFidelity=Enum.RenderFidelity.Disabled end)
elseif o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Smoke") or o:IsA("Fire") or o:IsA("Sparkles") or o:IsA("PointLight") or o:IsA("SpotLight") or o:IsA("SurfaceLight") then o.Enabled=false end
end
if on then
Lighting.GlobalShadows=false; Lighting.Brightness=1; Lighting.ClockTime=14
pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01; settings().Rendering.MeshPartDetailLevel=Enum.MeshPartDetailLevel.Disabled end)
pcall(function() workspace.Terrain.Decoration=false end)
mapPass("f",degrade); frameConn=workspace.DescendantAdded:Connect(degrade)
else
pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Automatic; settings().Rendering.MeshPartDetailLevel=Enum.MeshPartDetailLevel.Full end)
pcall(function() workspace.Terrain.Decoration=true end)
end
end
local toggles={}
local function add(key,label,fn)
local toggle=addToggle(section,label,state[key],function(v) state[key]=v; SetCfg("perf"..key:sub(1,1):upper()..key:sub(2),v); fn(v) end)
toggles[#toggles+1]=toggle
return toggle
end
add("smooth","VV2 No Textures (SmoothPlastic)",setSmooth)
add("shadows","VV2 Disable Shadows",function(v) Lighting.GlobalShadows=v and false or originalShadows end)
add("particles","VV2 Disable Particles/Trails",setParticles)
add("meshes","VV2 Hide Meshes (world only)",setMeshes)
add("textures","VV2 Remove Textures/Decals",setTextures)
add("accessories","VV2 Remove Accessories",setAccessories)
add("gray","VV2 Gray Skybox",setGray)
add("frame","VV2 Enable Frame Enhancement",setFrame)
local hiddenWeaponDisplays={}
local weaponDisplayRevision=0
local weaponDisplayToggle
local function forgetWeaponDisplay(object)
local record=hiddenWeaponDisplays[object]
if record and record.destroying then record.destroying:Disconnect() end
hiddenWeaponDisplays[object]=nil
end
local function hideWeaponDisplay(object)
if not runtimeAlive or object.Name~="WeaponDisplays" or object.Parent~=workspace then return end
if not hiddenWeaponDisplays[object] then
local record={parent=object.Parent}
hiddenWeaponDisplays[object]=record
record.destroying=object.Destroying:Connect(function() forgetWeaponDisplay(object) end)
end
if not pcall(function() object.Parent=nil end) then forgetWeaponDisplay(object) end
end
local function restoreWeaponDisplays()
for object,record in pairs(hiddenWeaponDisplays) do
forgetWeaponDisplay(object)
if object.Parent==nil then pcall(function() object.Parent=record.parent end) end
end
end
local function removeWeaponDisplays()
if not runtimeAlive then return end
for _,object in ipairs(workspace:GetChildren()) do hideWeaponDisplay(object) end
end
local function setWeaponDisplays(on)
weaponDisplayRevision=weaponDisplayRevision+1
if conns.weaponDisplays then conns.weaponDisplays:Disconnect();conns.weaponDisplays=nil end
if not on then restoreWeaponDisplays();return end
if not runtimeAlive then return end
local revision=weaponDisplayRevision
conns.weaponDisplays=workspace.ChildAdded:Connect(function(object)
if object.Name=="WeaponDisplays" then
task.defer(function()
if runtimeAlive and state.weaponDisplays and weaponDisplayRevision==revision then
hideWeaponDisplay(object)
end
end)
end
end)
removeWeaponDisplays()
task.spawn(function()
while runtimeAlive and state.weaponDisplays and weaponDisplayRevision==revision do
task.wait(1)
if runtimeAlive and state.weaponDisplays and weaponDisplayRevision==revision then removeWeaponDisplays() end
end
end)
end
section:AddButton("VV2 Remove Weapon Displays",removeWeaponDisplays)
section:AddButton("VV2 Reapply Weapon Displays",function()
if not runtimeAlive then return end
weaponDisplayToggle:Set(false)
state.weaponDisplays=false
SetCfg("perfWeaponDisplays",false)
setWeaponDisplays(false)
end)
weaponDisplayToggle=add("weaponDisplays","VV2 Auto Remove Weapon Displays",setWeaponDisplays)
env.VisualsV2Runtime.RegisterReset(function() for _,t in ipairs(toggles) do t:Set(false) end; setSmooth(false); setParticles(false); setMeshes(false); setTextures(false); setAccessories(false); setGray(false); setFrame(false); setWeaponDisplays(false) end)
end,"Section \"Performance & Optimization\"")
;vv2Section(function()
local section=performanceTab:AddSection("RTX & Graphics","Visuals")
local Terrain=workspace:FindFirstChildOfClass("Terrain")
local rtx=C("rtxEnabled",false); local timeOn=C("rtxTimeEnabled",false); local custom=C("rtxCustomEnabled",false)
local mode=C("rtxTimeMode","Default (Original Game Time)")
local br=tonumber(C("rtxBrightness",20)) or 20; local sat=tonumber(C("rtxSaturation",35)) or 35; local con=tonumber(C("rtxContrast",30)) or 30
local bloom=(tonumber(C("rtxBloom",45)) or 45)/100; local sun=(tonumber(C("rtxSunRays",35)) or 35)/100; local refl=(tonumber(C("rtxReflections",25)) or 25)/10
local d={Technology=Lighting.Technology,GlobalShadows=Lighting.GlobalShadows,Brightness=Lighting.Brightness,Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient,Bottom=Lighting.ColorShift_Bottom,Top=Lighting.ColorShift_Top,Diffuse=Lighting.EnvironmentDiffuseScale,Specular=Lighting.EnvironmentSpecularScale,Soft=Lighting.ShadowSoftness,Lat=Lighting.GeographicLatitude,Exposure=Lighting.ExposureCompensation,Clock=Lighting.ClockTime,WaterT=Terrain and Terrain.WaterTransparency or .3,WaterR=Terrain and Terrain.WaterReflectance or 0}
local rtxObjs={}; local atmo,timeSky,cc,bl,ray
local function clearList() for _,o in ipairs(rtxObjs) do if o and o.Parent then o:Destroy() end end; table.clear(rtxObjs) end
local function clearTime() if atmo then atmo:Destroy(); atmo=nil end; if timeSky then timeSky:Destroy(); timeSky=nil end end
local function restoreTime()
clearTime(); Lighting.ClockTime=d.Clock; Lighting.GeographicLatitude=d.Lat; Lighting.Brightness=d.Brightness; Lighting.Ambient=d.Ambient; Lighting.OutdoorAmbient=d.OutdoorAmbient; Lighting.ColorShift_Bottom=d.Bottom; Lighting.ColorShift_Top=d.Top; Lighting.ExposureCompensation=d.Exposure
end
local presets={
["Morning (Clean Golden)"]={7,3.2,{55,50,45},{190,160,130},{20,15,10},{255,235,205},.3,-25,{255,225,185},{110,85,65},.3,.2,.4,2,false},
["Midday (Vibrant Sun)"]={13,4,{60,65,80},{180,200,230},{20,30,50},{255,255,245},.35,10,{200,220,255},{90,120,160},.2,0,.4,1,false},
["Afternoon (Golden Hour)"]={16.5,3.6,{70,45,35},{220,140,70},{70,30,15},{255,180,90},.38,-15,{255,150,60},{110,50,25},.35,.4,.7,3,false},
["Sunset (Natural Warmth)"]={18.2,3.4,{65,45,40},{210,130,85},{50,20,20},{255,170,110},.35,-50,{255,160,100},{90,50,40},.3,.4,.6,3,false},
["Night (Cool Moonlight)"]={0,2,{25,35,60},{40,70,120},{10,20,45},{130,190,255},.5,45,{30,50,90},{15,25,50},.4,0,.3,2,true},
["Midnight (Pitch Black & Stars)"]={1.5,1.2,{10,12,20},{15,25,45},{5,8,15},{80,120,200},.2,90,{10,20,40},{5,10,20},.6,0,.2,6,true}}
local function applyTime()
if not timeOn then return end; clearTime()
if mode=="Default (Original Game Time)" then restoreTime(); return end
local p=presets[mode]; if not p then return end
local function rgb(x) return Color3.fromRGB(x[1],x[2],x[3]) end
Lighting.ClockTime=p[1]; Lighting.Brightness=p[2]; Lighting.Ambient=rgb(p[3]); Lighting.OutdoorAmbient=rgb(p[4]); Lighting.ColorShift_Bottom=rgb(p[5]); Lighting.ColorShift_Top=rgb(p[6]); Lighting.ExposureCompensation=p[7]; Lighting.GeographicLatitude=p[8]
local fogOn=env.VisualsV2Runtime.FogOn
if not (type(fogOn)=="function" and fogOn()) then
atmo=Instance.new("Atmosphere"); atmo.Name="VisualsV2_TimeAtmosphere"; atmo.Color=rgb(p[9]); atmo.Decay=rgb(p[10]); atmo.Density=p[11]; atmo.Offset=p[12]; atmo.Glare=p[13]; atmo.Haze=p[14]; atmo.Parent=Lighting
end
if p[15] then timeSky=Instance.new("Sky"); timeSky.Name="VisualsV2_TimeSky"; timeSky.SkyboxBk="rbxassetid://826027103"; timeSky.SkyboxDn="rbxassetid://826027117"; timeSky.SkyboxFt="rbxassetid://826027137"; timeSky.SkyboxLf="rbxassetid://826027161"; timeSky.SkyboxRt="rbxassetid://826027189"; timeSky.SkyboxUp="rbxassetid://826027228"; timeSky.Parent=Lighting end
end
local function applyRTX()
if not rtx then return end; clearList(); Lighting.Technology=Enum.Technology.Future; Lighting.GlobalShadows=true; Lighting.ShadowSoftness=.02; Lighting.EnvironmentDiffuseScale=1; Lighting.EnvironmentSpecularScale=refl
if Terrain then Terrain.WaterTransparency=.01; Terrain.WaterReflectance=1; Terrain.WaterWaveSize=.25; Terrain.WaterWaveSpeed=16 end
pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level21 end)
local o=Instance.new("BloomEffect"); o.Name="VisualsV2_RTX_Bloom"; o.Intensity=.4; o.Size=3500; o.Threshold=.65; o.Parent=Lighting; table.insert(rtxObjs,o)
o=Instance.new("ColorCorrectionEffect"); o.Name="VisualsV2_RTX_Color"; o.Brightness=.15; o.Contrast=.45; o.Saturation=.35; o.TintColor=Color3.fromRGB(255,245,230); o.Parent=Lighting; table.insert(rtxObjs,o)
o=Instance.new("DepthOfFieldEffect"); o.Name="VisualsV2_RTX_DOF"; o.FarIntensity=.08; o.FocusDistance=28; o.InFocusRadius=20; o.NearIntensity=.15; o.Parent=Lighting; table.insert(rtxObjs,o)
o=Instance.new("SunRaysEffect"); o.Name="VisualsV2_RTX_Sun"; o.Intensity=.35; o.Spread=.85; o.Parent=Lighting; table.insert(rtxObjs,o)
end
local function stopRTX()
clearList(); Lighting.Technology=d.Technology; Lighting.GlobalShadows=d.GlobalShadows; Lighting.Brightness=d.Brightness; Lighting.Ambient=d.Ambient; Lighting.OutdoorAmbient=d.OutdoorAmbient; Lighting.ColorShift_Bottom=d.Bottom; Lighting.ColorShift_Top=d.Top; Lighting.EnvironmentDiffuseScale=d.Diffuse; Lighting.EnvironmentSpecularScale=d.Specular; Lighting.ShadowSoftness=d.Soft; Lighting.GeographicLatitude=d.Lat; Lighting.ExposureCompensation=d.Exposure; Lighting.ClockTime=d.Clock
if Terrain then Terrain.WaterTransparency=d.WaterT; Terrain.WaterReflectance=d.WaterR end
end
local function clearCustom() if cc then cc:Destroy(); cc=nil end; if bl then bl:Destroy(); bl=nil end; if ray then ray:Destroy(); ray=nil end end
local function applyCustom()
if not custom then return end; Lighting.Brightness=br/10; Lighting.EnvironmentSpecularScale=refl
if not cc or not cc.Parent then cc=Instance.new("ColorCorrectionEffect"); cc.Name="VisualsV2_CustomGraphics_Color"; cc.Parent=Lighting end; cc.Saturation=sat/100; cc.Contrast=con/100
if not bl or not bl.Parent then bl=Instance.new("BloomEffect"); bl.Name="VisualsV2_CustomGraphics_Bloom"; bl.Parent=Lighting end; bl.Intensity=bloom; bl.Size=3500
if not ray or not ray.Parent then ray=Instance.new("SunRaysEffect"); ray.Name="VisualsV2_CustomGraphics_Sun"; ray.Parent=Lighting end; ray.Intensity=sun; ray.Spread=.85
end
local rt=addToggle(section,"VV2 Enable RTX (Ultra Realistic)",rtx,function(v) rtx=v; SetCfg("rtxEnabled",v); if v then applyRTX() else stopRTX() end end)
env.VisualsV2Runtime.RefreshTimeOfDay=function() if timeOn then applyTime() end end
env.VisualsV2Runtime.TimeOfDayActive=function() return timeOn and mode~="Default (Original Game Time)" end
local tt=addToggle(section,"VV2 Enable Custom Time of Day",timeOn,function(v) timeOn=v; SetCfg("rtxTimeEnabled",v); if v then applyTime() else restoreTime() end end)
addDropdown(section,"VV2 Time of Day Preset",{"Default (Original Game Time)","Morning (Clean Golden)","Midday (Vibrant Sun)","Afternoon (Golden Hour)","Sunset (Natural Warmth)","Night (Cool Moonlight)","Midnight (Pitch Black & Stars)"},mode,function(v) mode=v; SetCfg("rtxTimeMode",v); if timeOn then applyTime() end end)
local ct=addToggle(section,"VV2 Enable Custom Graphics",custom,function(v) custom=v; SetCfg("rtxCustomEnabled",v); if v then applyCustom() else clearCustom() end end)
section:AddSlider("VV2 Custom Brightness",5,40,br,function(v) br=v; SetCfg("rtxBrightness",v); if custom then applyCustom() end end)
section:AddSlider("VV2 Custom Saturation",0,100,sat,function(v) sat=v; SetCfg("rtxSaturation",v); if custom then applyCustom() end end)
section:AddSlider("VV2 Custom Contrast",0,100,con,function(v) con=v; SetCfg("rtxContrast",v); if custom then applyCustom() end end)
section:AddSlider("VV2 Bloom Intensity",0,100,math.floor(bloom*100),function(v) bloom=v/100; SetCfg("rtxBloom",v); if custom then applyCustom() end end)
section:AddSlider("VV2 SunRays Intensity",0,100,math.floor(sun*100),function(v) sun=v/100; SetCfg("rtxSunRays",v); if custom then applyCustom() end end)
section:AddSlider("VV2 Reflections Intensity",0,50,math.floor(refl*10),function(v) refl=v/10; SetCfg("rtxReflections",v); if custom or rtx then Lighting.EnvironmentSpecularScale=refl end end)
env.VisualsV2Runtime.RegisterReset(function() rt:Set(false); tt:Set(false); ct:Set(false); rtx=false; timeOn=false; custom=false; clearTime(); clearCustom(); stopRTX() end)
if rtx then task.defer(applyRTX) end; if timeOn then task.defer(applyTime) end; if custom then task.defer(applyCustom) end
end,"Section \"RTX & Graphics\"")
;vv2Section(function()
local sawSettingsFile=false
local function resetEverything()
ConfigData={}
PositionData={}
configResetting=true
for _,resetter in ipairs(env.VisualsV2Runtime.Resetters or {}) do
pcall(resetter)
end
configResetting=false
end
local remove=type(delfile)=="function" and delfile or env.delfile
or type(deletefile)=="function" and deletefile or env.deletefile
env.VisualsV2Runtime.RestoreDefaults=function()
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
env.VisualsV2ConfigWatchToken=(tonumber(env.VisualsV2ConfigWatchToken) or 0)+1
local myWatchToken=env.VisualsV2ConfigWatchToken
local ok,present=pcall(exists,CFG_FILE)
if ok and present then sawSettingsFile=true end
task.spawn(function()
while runtimeAlive and env.VisualsV2ConfigWatchToken==myWatchToken do
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
shared.Notify("Visuals V2: settings reset to their defaults",2)
end)
end
task.wait(1)
end
end)
end,"Part at line 27508")
;vv2Section(function()
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
task.defer(function() controlsReady=true;local loading=env.VisualsV2Runtime.LoadingScreen;if loading then loading.Finish() end end)
end)
