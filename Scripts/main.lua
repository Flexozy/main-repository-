local HttpService = game:GetService("HttpService")

local REPO = "Flexozy/main-repository-"
local BRANCH = "main"
local TARGET_NAME = "MM2"

local function run()
    local api = "https://api.github.com/repos/"
        .. REPO .. "/git/trees/" .. BRANCH .. "?recursive=1"

    local ok, response = pcall(function()
        return game:HttpGet(api)
    end)
    if not ok then
        warn("[Flexozy] GitHub connection failed")
        return
    end

    local parsed, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    if not parsed or type(data.tree) ~= "table" then
        warn("[Flexozy] Failed to read repository")
        return
    end

    local target

    for _, item in ipairs(data.tree) do
        if item.type == "blob" then
            local filename = item.path:match("([^/]+)$") or ""
            local basename = filename:match("^(.*)%.[^%.]+$") or filename

            if basename:lower() == TARGET_NAME:lower() then
                target = item.path
                break
            end
        end
    end

    if not target then
        warn("[Flexozy] File not found: " .. TARGET_NAME)
        return
    end

    local raw = "https://raw.githubusercontent.com/"
        .. REPO .. "/" .. BRANCH .. "/" .. target

    local fetched, source = pcall(function()
        return game:HttpGet(raw)
    end)
    if not fetched or type(source) ~= "string" or source == "" then
        warn("[Flexozy] Failed to fetch script")
        return
    end

    local compiled, fn = pcall(loadstring, source)
    if not compiled or type(fn) ~= "function" then
        warn("[Flexozy] Script compilation failed")
        return
    end

    local success, err = pcall(fn)
    if not success then
        warn("[Flexozy] Script execution failed:", err)
    end
end

run()
