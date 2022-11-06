local M = {}

local function writingLayout(termApp, editorApp, pdfReaderApp, termFrame, editorFrame, pdfFrame)
  func = function()
    hs.application.launchOrFocus(termApp)
    hs.application.launchOrFocus(editorApp)
    hs.application.launchOrFocus(pdfReaderApp)

    termApplication = hs.appfinder.appFromName(termApp)
    if termApplication ~= nil then
      termWindows = termApplication:allWindows()
      termWindow = termWindows[1]
      termWindow:setFrame(termFrame)
    end

    editorApplication = hs.appfinder.appFromName(editorApp)
    if editorApplication ~= nil then
      editorWindows = editorApplication:allWindows()
      if #editorWindows >= 1 then
        editor = editorWindows[1]
        editor:setFrame(editorFrame)
      end
    end
    
    pdfApplication = hs.appfinder.appFromName(pdfReaderApp)
    if pdfApplication ~= nil then
      pdfApplicationWindows = pdfApplication:allWindows()
      if #pdfApplicationWindows >= 1 then
        pdf = pdfApplicationWindows[1]
        pdf:setFrame(pdfFrame)
      end
    end
  end

  return func
end
M.writingLayout = writingLayout


local function reloadConfig()
  hs.reload()
end
M.reloadConfig = reloadConfig

local function setupLaunchAndLayout(layout, music, mail, chat, tasks, calendar, notes, playlist)
  func = function()
    hs.application.launchOrFocus(music)
    hs.application.launchOrFocus(chat)
    hs.application.launchOrFocus(tasks)
    hs.application.launchOrFocus(notes)
    hs.application.launchOrFocus(mail)
    hs.application.launchOrFocus(calendar)

    hs.timer.doAfter(3, function () hs.layout.apply(layout) end)
  end

  return func
end
M.setupLaunchAndLayout = setupLaunchAndLayout

local function setMCWindow()
  mcWin=hs.appfinder.windowFromWindowTitlePattern("Minecraft.*")
  mcWin:setFrame(hs.geometry.rect(1495.0,44.0,2217.0,1319.0))
end
M.setMCWindow = setMCWindow

return M
