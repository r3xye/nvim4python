local function ensure_dashboard_new_file_command()
  if vim.fn.exists(":DashboardNewFile") == 2 then
    return
  end

  vim.api.nvim_create_user_command("DashboardNewFile", function()
    local choices = {
      { label = "Python (.py)", ext = "py", ft = "python" },
      { label = "C++ (.cpp)", ext = "cpp", ft = "cpp" },
      { label = "Typst (.typ)", ext = "typ", ft = "typst" },
    }

    vim.ui.select(choices, {
      prompt = "Create new file:",
      format_item = function(item)
        return item.label
      end,
    }, function(item)
      if not item then
        return
      end
      local stamp = os.date("%Y%m%d-%H%M%S")
      local name = ("untitled-%s.%s"):format(stamp, item.ext)
      vim.cmd("enew")
      vim.cmd("file " .. vim.fn.fnameescape(name))
      vim.bo.filetype = item.ft
    end)
  end, {})
end

local function setup_dashboard_highlights()
  vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#fabd2f", bold = true })
  vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = "#ebdbb2" })
  vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#fe8019" })
  vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = "#fb4934", bold = true })
  vim.api.nvim_set_hl(0, "SnacksDashboardSpecial", { fg = "#83a598", italic = true })
  vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = "#8ec07c", italic = true })
end

ensure_dashboard_new_file_command()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_dashboard_highlights,
})
setup_dashboard_highlights()

local normalize_dir

local function dashboard_refresh()
  vim.cmd("redrawstatus")
  local ok, snacks = pcall(require, "snacks")
  if ok then
    snacks.dashboard.update()
  end
end

local function navigate_to_dir(dir)
  local target = normalize_dir(dir)
  vim.cmd("cd " .. vim.fn.fnameescape(target))
  dashboard_refresh()
end

local header = [[
██████╗ ██╗   ██╗██████╗  █████╗ ███╗   ███╗██╗   ██╗██████╗  █████╗
██╔══██╗██║   ██║██╔══██╗██╔══██╗████╗ ████║██║   ██║██╔══██╗██╔══██╗
██║  ██║██║   ██║██║  ██║██║  ██║██╔████╔██║██║   ██║██║  ██║██║  ██║
██████╔╝██║   ██║██████╔╝███████║██║╚██╔╝██║██║   ██║██████╔╝███████║
██╔═══╝ ██║   ██║██╔═══╝ ██╔══██║██║ ╚═╝ ██║██║   ██║██╔═══╝ ██╔══██║
██║     ██║   ██║██║     ██║  ██║██║     ██║██║   ██║██║     ██║  ██║
██║     ╚██████╔╝██║     ██║  ██║██║     ██║╚██████╔╝██║     ██║  ██║
╚═╝      ╚═════╝ ╚═╝     ╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝
]]

local function cava_installed()
  return vim.fn.executable("cava") == 1
end

local function cmatrix_installed()
  return vim.fn.executable("cmatrix") == 1
end

local function in_git_repo()
  local ok, snacks = pcall(require, "snacks")
  return ok and snacks.git.get_root() ~= nil
end

local function discover_repo_dirs()
  local home = vim.loop.os_homedir()
  local roots = {
    home .. "/GitHub",
    home .. "/projects",
    home .. "/work",
    home .. "/code",
    home .. "/dev",
    home .. "/src",
  }

  local seen = {}
  local repos = {}
  for _, root in ipairs(roots) do
    if vim.fn.isdirectory(root) == 1 then
      local cmd = string.format(
        "find %q -mindepth 1 -maxdepth 5 -type d -name .git -prune 2>/dev/null | sed 's#/.git##'",
        root
      )
      local lines = vim.fn.systemlist({ "sh", "-c", cmd })
      for _, dir in ipairs(lines) do
        if dir ~= ""
            and not dir:match("/%.cache/")
            and not dir:match("/%.local/")
            and not dir:match("/node_modules/")
            and not seen[dir]
        then
          seen[dir] = true
          table.insert(repos, dir)
        end
      end
    end
  end

  return repos
end

normalize_dir = function(dir)
  return (vim.fn.fnamemodify(dir, ":p"):gsub("/+$", ""))
end

local function repo_last_commit_ts(dir)
  local out = vim.fn.systemlist({ "git", "-C", dir, "log", "-1", "--format=%ct" })
  local ts = tonumber(out[1] or "")
  return ts or 0
end

local function oldfiles_repo_rank()
  local rank = {}
  local ok, snacks = pcall(require, "snacks")
  if not ok then
    return rank
  end

  local score = 1000000
  for file in snacks.dashboard.oldfiles() do
    local root = snacks.git.get_root(file)
    if root then
      local key = normalize_dir(root)
      if not rank[key] then
        rank[key] = score
        score = score - 1
      end
    end
  end
  return rank
end

local function featured_repos(limit)
  local repos = discover_repo_dirs()
  local opened_rank = oldfiles_repo_rank()

  table.sort(repos, function(a, b)
    local na, nb = normalize_dir(a), normalize_dir(b)
    local oa, ob = opened_rank[na] or 0, opened_rank[nb] or 0
    if oa ~= ob then
      return oa > ob
    end

    local ta, tb = repo_last_commit_ts(a), repo_last_commit_ts(b)
    if ta ~= tb then
      return ta > tb
    end

    return na < nb
  end)

  return vim.list_slice(repos, 1, limit)
end

local current_featured_repos = featured_repos(5)

local function repository_dashboard_items()
  local keys = { "!", "@", "#", "$", "%" }
  local labels = { "Shift+1", "Shift+2", "Shift+3", "Shift+4", "Shift+5" }
  local dirs = vim.list_slice(current_featured_repos, 1, #keys)
  local items = {}

  for i, dir in ipairs(dirs) do
    local key = keys[i]
    items[#items + 1] = {
      file = dir,
      icon = " ",
      key = key,
      label = labels[i],
      autokey = false,
      action = function()
        navigate_to_dir(dir)
      end,
    }
  end

  return vim.list_extend({
    pane = 2,
    icon = " ",
    title = "Git Repos",
    enabled = function()
      return not in_git_repo()
    end,
    indent = 2,
    padding = 1,
  }, items)
end

local function recent_files_dashboard_items(limit)
  local max_items = limit or 10
  return function()
    local items = {}
    local seen = {}

    local function add_file(path)
      if not path or path == "" then
        return false
      end
      local normalized = normalize_dir(path)
      if normalized == "" or seen[normalized] then
        return false
      end
      seen[normalized] = true
      items[#items + 1] = {
        file = normalized,
        icon = "file",
        action = function()
          local dir = normalize_dir(vim.fn.fnamemodify(normalized, ":h"))
          vim.cmd("cd " .. vim.fn.fnameescape(dir))
          vim.cmd("e " .. vim.fn.fnameescape(normalized))
          vim.cmd("redrawstatus")
        end,
        autokey = true,
      }
      return #items >= max_items
    end

    local ok, snacks = pcall(require, "snacks")
    if ok then
      for file in snacks.dashboard.oldfiles() do
        if add_file(file) then
          break
        end
      end
    end

    if #items == 0 then
      for _, file in ipairs(vim.v.oldfiles or {}) do
        if add_file(file) then
          break
        end
      end
    end

    return vim.list_extend({
      icon = " ",
      title = "Recent files",
      indent = 2,
      padding = 1,
    }, items)
  end
end

return {
  animate = { enabled = true },
  dashboard = {
    enabled = true,
    width = 64,
    pane_gap = 4,
    autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
    preset = {
      header = header,
      keys = {
        { icon = " ", key = "e", desc = "New file", action = ":DashboardNewFile" },
        { icon = " ", key = "f", desc = "Find file", action = ":Telescope find_files" },
        { icon = " ", key = "g", desc = "Find text", action = ":Telescope live_grep" },
        { icon = " ", key = "r", desc = "Recent files", action = ":Telescope oldfiles" },
        { icon = " ", key = "n", desc = "File tree", action = ":Neotree toggle" },
        { icon = " ", key = "s", desc = "Settings", action = ":e $MYVIMRC" },
        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      recent_files_dashboard_items(5),
      { section = "startup", padding = 1 },
      {
        pane = 2,
        icon = "󰘦 ",
        title = "Matrix flow",
        section = "terminal",
        enabled = cmatrix_installed,
        cmd = "cmatrix -abs -u 3",
        width = 60,
        height = 12,
        padding = 1,
      },
      {
        pane = 2,
        icon = " ",
        title = "Matrix flow",
        section = "terminal",
        enabled = function()
          return not cmatrix_installed()
        end,
        cmd = "printf 'Install cmatrix:\\n  sudo pacman -S cmatrix\\n'",
        height = 4,
        padding = 1,
      },
      {
        pane = 2,
        icon = "󰺢 ",
        title = "Audio visualizer",
        section = "terminal",
        enabled = cava_installed,
        cmd = "cava -p ~/.config/cava/nvim-gruvbox.conf",
        indent = 2,
        width = 60,
        height = 12,
        padding = 1,
      },
      {
        pane = 2,
        icon = " ",
        title = "Audio visualizer",
        section = "terminal",
        enabled = function()
          return not cava_installed()
        end,
        cmd = "printf 'Install cava to enable visualizer:\\n  sudo pacman -S cava\\n'",
        height = 4,
        padding = 1,
      },
      {
        pane = 2,
        icon = "󰜘 ",
        title = "Commit stats",
        section = "terminal",
        enabled = in_git_repo,
        cmd = [[sh -c '
name="$(git config user.name)"
total="$(git rev-list --count HEAD 2>/dev/null || echo 0)"
repo_today="$(git rev-list --count --since="00:00" HEAD 2>/dev/null || echo 0)"
if [ -n "$name" ]; then
  you_total="$(git rev-list --count --author="$name" HEAD 2>/dev/null || echo 0)"
  you_today="$(git rev-list --count --since="00:00" --author="$name" HEAD 2>/dev/null || echo 0)"
  printf "Repo total: %s\n" "$total"
  printf "Repo today: %s\n" "$repo_today"
  printf "You total:  %s\n" "$you_total"
  printf "You today:  %s\n" "$you_today"
else
  printf "Repo total: %s\n" "$total"
  printf "Repo today: %s\n" "$repo_today"
  printf "\nSet git user.name for personal stats."
fi
' ]],
        height = 7,
        padding = 1,
        ttl = 180,
      },
      repository_dashboard_items(),
    },
  },
  scroll = { enabled = true },
}
