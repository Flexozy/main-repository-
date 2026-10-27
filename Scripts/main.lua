local HttpService = game:GetService("HttpService")

local REPO = "Flexozy/main-repository-"
local BRANCH = "main"
local MAP_ID = "142823291"

local function run()
    local apiUrl = "https://api.github.com/repos/" .. REPO
        .. "/git/trees/" .. BRANCH .. "?recursive=1"

    local ok, response = pcall(function()
        return game:HttpGet(apiUrl)
    end)
    if not ok then return end

    local parsed, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    if not parsed or type(data.tree) ~= "table" then return end

    local target

    for _, item in ipairs(data.tree) do
        if item.type == "blob" then
            local name = item.path:match("([^/]+)$")
            local id = name and name:match("(%d+)")

            if id == MAP_ID then
                target = item.path
                break
            end
        end
    end

    if not target then return end

    local url = "https://raw.githubusercontent.com/"
        .. REPO .. "/" .. BRANCH .. "/" .. target

    local fetched, source = pcall(function()
        return game:HttpGet(url)
    end)

    if not fetched or type(source) ~= "string" or source == "" then
        return
    end

    local compiled, fn = pcall(loadstring, source)
    if not compiled or type(fn) ~= "function" then return end

    pcall(fn)
end

run()
