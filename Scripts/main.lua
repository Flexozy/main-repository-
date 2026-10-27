local url = "https://raw.githubusercontent.com/ชื่อผู้ใช้/ชื่อ-repo/main/Scripts/main.lua"

local success, source = pcall(function()
    return game:HttpGet(url)
end)

if success and source and #source > 0 then
    loadstring(source)()
else
    warn("โหลดโค้ดจาก GitHub ไม่สำเร็จ")
end
