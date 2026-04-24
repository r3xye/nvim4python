local M = {}

local color_patterns = {
  { kind = "hex8", pattern = "#%x%x%x%x%x%x%x%x" },
  { kind = "hex6", pattern = "#%x%x%x%x%x%x" },
  { kind = "hex3", pattern = "#%x%x%x" },
  { kind = "rgba", pattern = "rgba%s*%b()" },
  { kind = "rgb", pattern = "rgb%s*%b()" },
}

local function clamp(value, min_value, max_value)
  return math.min(math.max(value, min_value), max_value)
end

local function component_to_hex(value)
  return string.format("%02x", clamp(math.floor(value + 0.5), 0, 255))
end

local function rgb_to_hex(rgb)
  return "#" .. component_to_hex(rgb.r) .. component_to_hex(rgb.g) .. component_to_hex(rgb.b)
end

local function parse_hex_color(text)
  if #text == 4 then
    local r = tonumber(text:sub(2, 2) .. text:sub(2, 2), 16)
    local g = tonumber(text:sub(3, 3) .. text:sub(3, 3), 16)
    local b = tonumber(text:sub(4, 4) .. text:sub(4, 4), 16)
    return { r = r, g = g, b = b }
  end

  if #text == 7 or #text == 9 then
    local r = tonumber(text:sub(2, 3), 16)
    local g = tonumber(text:sub(4, 5), 16)
    local b = tonumber(text:sub(6, 7), 16)
    return { r = r, g = g, b = b }
  end

  return nil
end

local function parse_rgb_color(text)
  local values = {}
  for number in text:gmatch("[%d%.]+") do
    values[#values + 1] = tonumber(number)
  end

  if #values < 3 then
    return nil
  end

  return {
    r = clamp(values[1], 0, 255),
    g = clamp(values[2], 0, 255),
    b = clamp(values[3], 0, 255),
    a = values[4],
  }
end

local function parse_color_token(token)
  if token.kind:match("^hex") then
    return parse_hex_color(token.text)
  end

  if token.kind == "rgb" or token.kind == "rgba" then
    return parse_rgb_color(token.text)
  end

  return nil
end

local function find_color_token(line, col)
  for _, entry in ipairs(color_patterns) do
    local start_col = 1
    while true do
      local s, e = line:find(entry.pattern, start_col)
      if not s then
        break
      end

      if col >= s and col <= e then
        return {
          kind = entry.kind,
          start_col = s,
          end_col = e,
          text = line:sub(s, e),
        }
      end

      start_col = s + 1
    end
  end

  return false
end

local function get_color_token_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  return line, find_color_token(line, col)
end

local function can_edit_current_buffer()
  return vim.bo.modifiable and not vim.bo.readonly
end

local function format_like_original(token, rgb)
  if token.kind == "rgb" then
    return string.format("rgb(%d, %d, %d)", rgb.r, rgb.g, rgb.b)
  end

  if token.kind == "rgba" then
    local alpha = token.text:match("rgba%s*%([^,]+,[^,]+,[^,]+,%s*([%d%.]+)%s*%)")
    if alpha then
      return string.format("rgba(%d, %d, %d, %s)", rgb.r, rgb.g, rgb.b, alpha)
    end
  end

  return rgb_to_hex(rgb)
end

function M.setup()
  local ok, ccc = pcall(require, "ccc")
  if not ok then
    vim.notify("ccc.nvim is unavailable", vim.log.levels.WARN)
    return
  end

  ccc.setup({
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
    inputs = {
      ccc.input.rgb,
      ccc.input.hsl,
    },
    outputs = {
      ccc.output.hex,
      ccc.output.css_rgb,
    },
    pickers = {
      ccc.picker.hex,
      ccc.picker.css_rgb,
    },
    recognize = {
      input = false,
      output = false,
      pattern = {
        [ccc.picker.hex] = { ccc.input.rgb, ccc.output.hex },
        [ccc.picker.css_rgb] = { ccc.input.rgb, ccc.output.css_rgb },
      },
    },
  })

  local ok_highlighter, highlighter = pcall(require, "ccc.highlighter")
  if ok_highlighter then
    vim.schedule(function()
      highlighter:enable(0)
    end)
  end
end

function M.pick_under_cursor()
  if not can_edit_current_buffer() then
    return
  end

  local line, token = get_color_token_under_cursor()
  if not token then
    vim.notify("No color under cursor", vim.log.levels.WARN)
    return
  end

  local current_rgb = parse_color_token(token)
  if not current_rgb then
    vim.notify("Unsupported color format under cursor", vim.log.levels.WARN)
    return
  end

  local before = vim.api.nvim_get_current_line()
  vim.cmd("CccPick")
  vim.defer_fn(function()
    local after = vim.api.nvim_get_current_line()
    if after ~= before then
      local new_token = find_color_token(after, token.start_col)
      if not new_token then
        return
      end

      local picked_rgb = parse_color_token(new_token)
      if not picked_rgb then
        return
      end

      local replacement = format_like_original(token, picked_rgb)
      local updated = after:sub(1, new_token.start_col - 1) .. replacement .. after:sub(new_token.end_col + 1)
      vim.api.nvim_set_current_line(updated)
    end
  end, 50)
end

function M.click_or_pick_color()
  local mouse = vim.fn.getmousepos()

  if mouse.winid and mouse.winid ~= 0 and vim.api.nvim_win_is_valid(mouse.winid) then
    vim.api.nvim_set_current_win(mouse.winid)
  end

  if mouse.line and mouse.line > 0 then
    local line = math.max(mouse.line, 1)
    local col = math.max((mouse.column or 1) - 1, 0)
    pcall(vim.api.nvim_win_set_cursor, 0, { line, col })
  end

  local _, token = get_color_token_under_cursor()
  if token and can_edit_current_buffer() then
    vim.schedule(M.pick_under_cursor)
  end
end

vim.keymap.set("n", "<leader>c", M.pick_under_cursor, { desc = "Pick color under cursor" })
vim.keymap.set("n", "<LeftMouse>", M.click_or_pick_color, { desc = "Pick color on click" })

return M
