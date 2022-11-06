local funcs = require("lib.funcs")

hs.application.enableSpotlightForNameSearches(true)

local mail = "Airmail"
local mailLayoutName = "Airmail"
local chat = "Slack"
local tasks = "OmniFocus"
local music = "Spotify"
local calendar = "BusyCal"
local notes = "Bear"

local terminal = "iTerm2"
local editor = "Sublime Text"
local reader = "Preview"

local desktopTermFrame = hs.geometry.rect(766.0,23.0,990.0,1151.0)
local desktopEditorFrame = hs.geometry.rect(1757.0,25.0,1431.0,1340.0)
local desktopPdfFrame = hs.geometry.rect(3192.0,25.0,1148.0,1379.0)

local laptopTermFrame = hs.geometry.rect(0.0,23.0,640.0,707.0)
local laptopEditorFrame = hs.geometry.rect(410.0,23.0,1030.0,818.0)
local laptopPdfFrame = hs.geometry.rect(164.0,23.0,1111.0,877.0)

local defaultAppsLayout = {
  {chat,            nil, nil, nil, nil, hs.geometry.rect(1515.0,23.0,1381.0,1133.0)},
  {tasks,           nil, nil, nil, nil, hs.geometry.rect(2897.0,23.0,1452.0,1133.0)},
  {music,           nil, nil, nil, nil, hs.geometry.rect(0.0,23.0,1514.0,1133.0)}
}

local laptopAppsLayout = {
  {chat,            nil, nil, hs.geometry.unitrect(0,     0,    0.90, 1.0), nil, nil},
  {tasks,           nil, nil, hs.geometry.unitrect(0.10,  0,    0.90, 1.0), nil, nil},
}

desktopLayout = funcs.setupLaunchAndLayout(defaultAppsLayout, music, mail, chat, tasks, calendar, notes)
laptopLayout  = funcs.setupLaunchAndLayout(laptopAppsLayout, music, mail, chat, tasks, calendar, notes)
desktopWritingLayout = funcs.writingLayout(terminal, editor, reader, desktopTermFrame, desktopEditorFrame, desktopPdfFrame)
laptopWritingLayout = funcs.writingLayout(terminal, editor, reader, laptopTermFrame, laptopEditorFrame, laptopPdfFrame)

hs.hotkey.bind({"ctrl", "cmd"}, "R", funcs.reloadConfig)

hs.hotkey.bind({"alt"}, "1", desktopLayout)

hs.hotkey.bind({"alt"}, "2", desktopWritingLayout)

hs.hotkey.bind({"alt"}, "3", laptopLayout)

hs.hotkey.bind({"alt"}, "4", laptopWritingLayout)

hs.hotkey.bind({"alt"}, "5", function () hs.layout.apply(defaultAppsLayout) end )

hs.hotkey.bind({"alt"}, "6", funcs.setMCWindow)

hs.urlevent.bind("desktopWriting", function(eventName, params)
    desktopWritingLayout()
end)
