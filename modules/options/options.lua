Options = {}

-- private variables
local options
local fpsEnabled = false
local vsyncEnabled = false

function getConfig(name, default)
  if Configs.exists(name) then
    local val = string.trim(Configs.get(name))
    if val == 'true' or val == 'false' then
      return toboolean(val)
    else
      return val
    end
  else
    if default ~= nil then
      Configs.set(name, default)
      return default
    else
      return nil
    end
  end
end

function setConfig(name, value)
  Configs.set(name, tostring(value))
end

-- private functions
function Options.enableVsync(on)
  vsyncEnabled = on
  setVerticalSync(on)
  setConfig('vsync', on)
end

function Options.enableFps(on)
  fpsEnabled = on
  local frameCounter = UI.root:recursiveGetChildById('frameCounter')
  frameCounter:setVisible(on)
  setConfig('showfps', on)
end

-- public functions
function Options.create()
  options = UI.loadAndDisplayLocked("/options/options.otui")

  local fpsBox = options:getChildById('fpsCheckBox')
  local vsyncBox = options:getChildById('vsyncCheckBox')

  fpsBox:setChecked(fpsEnabled)
  vsyncBox:setChecked(vsyncEnabled)

  fpsBox.onCheckChange = function(self, checked) Options.enableFps(checked) end
  vsyncBox.onCheckChange = function(self, checked) Options.enableVsync(checked) end
end

function Options.load()
  Options.enableVsync(getConfig('vsync', true))
  Options.enableFps(getConfig('showfps', true))
end

function Options.destroy()
  options:destroy()
  options = nil
end

function Options.openWebpage()
  displayErrorBox("Error", "Not implemented yet")
end

addEvent(Options.load)