local has_nvim_tree_api, nvim_tree_api = pcall(require, "nvim-tree.api")
if not has_nvim_tree_api then
  return
end

local Event = nvim_tree_api.events.Event
local has_nvim_tree_view, nvim_tree_view = pcall(require, "nvim-tree.view")
if not has_nvim_tree_view then
  return
end

local has_bufferline_api, bufferline_api = pcall(require, "bufferline.api")
if not has_bufferline_api then
  return
end


local function get_tree_size()
  return nvim_tree_view.View.width
end

nvim_tree_api.events.subscribe(Event.TreeOpen, function()
  -- bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_api.events.subscribe(Event.Resize, function()
  -- bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_api.events.subscribe(Event.TreeClose, function()
  -- bufferline_api.set_offset(0)
end)
