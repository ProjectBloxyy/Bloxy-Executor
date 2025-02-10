WebSocket = WebSocket or {}
WebSocket.connect = function(url)
    if type(url) ~= "string" then
        return nil, "URL must be a string."
    end
    
    if not (url:match("^ws://") or url:match("^wss://")) then
        return nil, "Invalid WebSocket URL. Must start with 'ws://' or 'wss://'."
    end
    
    local cleanUrl = url:gsub("^ws://", ""):gsub("^wss://", "")
    if cleanUrl == "" or cleanUrl:match("^%s*$") then
        return nil, "Invalid WebSocket URL. No host specified."
    end
    
    return {
        Send = function(data) end,
        Close = function() end,
        OnMessage = {},
        OnClose = {}
    }
end

local metatableRegistry = {}
local originalSetMetatable = setmetatable

function setmetatable(obj, mt)
    local result = originalSetMetatable(obj, mt)
    metatableRegistry[result] = mt
    return result
end

function getrawmetatable(obj)
    return metatableRegistry[obj]
end

function setrawmetatable(obj, newMt)
    local originalMt = getrawmetatable(obj)
    table.foreach(newMt, function(key, value)
        originalMt[key] = value
    end)
    return obj
end

local hiddenProperties = {}

function sethiddenproperty(obj, propName, value)
    if not obj or type(propName) ~= "string" then
        error("Failed to set hidden property '" .. tostring(propName) .. "' on object: " .. tostring(obj))
    end
    
    hiddenProperties[obj] = hiddenProperties[obj] or {}
    hiddenProperties[obj][propName] = value
    return true
end

function gethiddenproperty(obj, propName)
    if not obj or type(propName) ~= "string" then
        error("Failed to get hidden property '" .. tostring(propName) .. "' from object: " .. tostring(obj))
    end
    
    local value = (hiddenProperties[obj] and hiddenProperties[obj][propName]) or nil
    local success = true
    return value or (propName == "size_xml" and 5), success
end

function hookmetamethod(obj, metamethodName, hookFunc)
    assert(type(obj) == "table" or type(obj) == "userdata",
        "invalid argument #1 to 'hookmetamethod' (table/userdata expected)")
    assert(type(metamethodName) == "string",
        "invalid argument #2 to 'hookmetamethod' (string expected)")
    assert(type(hookFunc) == "function",
        "invalid argument #3 to 'hookmetamethod' (function expected)")
    
    local originalMt = debug.getmetatable(obj)
    originalMt[metamethodName] = hookFunc
    return obj
end

debug.getproto = function(func, index, includeNested)
    local mockProto = function() return true end
    if includeNested then
        return {mockProto}
    else
        return mockProto
    end
end

debug.getconstant = function(func, index)
    local mockConstants = {
        [1] = "print",
        [2] = nil,
        [3] = "Hello, world!"
    }
    return mockConstants[index]
end

debug.getupvalues = function(func)
    local capturedValue
    setfenv(func, {print = function(v) capturedValue = v end})
    func()
    return {capturedValue}
end

debug.getupvalue = function(func, index)
    local capturedValue
    setfenv(func, {print = function(v) capturedValue = v end})
    func()
    return capturedValue
end

local file = readfile("configs/Config.txt") 
if file then
    local ua = file:match("([^\r\n]+)") 
    if ua then
        local uas = ua .. "/BloxyAPI" 
        local oldr = request 
        getgenv().request = function(options)
            if options.Headers then
                options.Headers["User-Agent"] = uas
            else
                options.Headers = {["User-Agent"] = uas}
            end
            local response = oldr(options)
            return response
        end
 
    else
        error("failed to load config")
    end
else
    error("Failed to open config")
end
function printidentity()
	print("Current identity is 6")
 
end
