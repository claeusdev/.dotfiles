local M = {}

local function package_json_root(startpath)
  local base = startpath
  if not base or base == "" then
    base = vim.fn.getcwd()
  end

  local search_path = base
  if vim.fn.isdirectory(base) == 0 then
    search_path = vim.fs.dirname(base)
  end

  local found = vim.fs.find("package.json", {
    upward = true,
    path = search_path,
    stop = vim.loop.os_homedir(),
  })[1]

  return found and vim.fs.dirname(found) or nil
end

local function detect_package_manager(root)
  local markers = {
    { "pnpm-lock.yaml", "pnpm" },
    { "yarn.lock", "yarn" },
    { "bun.lockb", "bun" },
    { "bun.lock", "bun" },
    { "package-lock.json", "npm" },
  }

  for _, marker in ipairs(markers) do
    local path = root .. "/" .. marker[1]
    if vim.fn.filereadable(path) == 1 then
      return marker[2]
    end
  end

  return "npm"
end

local function build_command(package_manager, script)
  if package_manager == "yarn" then
    return { "yarn", script }
  elseif package_manager == "bun" then
    return { "bun", "run", script }
  end

  return { package_manager, "run", script }
end

function M.find_package_root(startpath)
  return package_json_root(startpath)
end

function M.detect_package_manager(root)
  return detect_package_manager(root)
end

function M.package_script_command(script, startpath)
  local root = package_json_root(startpath)
  if not root then
    return nil, nil
  end

  local package_manager = detect_package_manager(root)
  return build_command(package_manager, script), root
end

function M.get_package_scripts(startpath)
  local root = package_json_root(startpath or vim.api.nvim_buf_get_name(0))
  if not root then
    return nil, nil, nil
  end

  local package_json = root .. "/package.json"
  local lines = vim.fn.readfile(package_json)
  if vim.tbl_isempty(lines) then
    return root, detect_package_manager(root), {}
  end

  local ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not ok or type(decoded) ~= "table" then
    return root, detect_package_manager(root), {}
  end

  local scripts = {}
  for name, command in pairs(decoded.scripts or {}) do
    scripts[#scripts + 1] = {
      name = name,
      command = command,
    }
  end
  table.sort(scripts, function(a, b)
    return a.name < b.name
  end)

  return root, detect_package_manager(root), scripts
end

function M.run_package_script()
  local root, package_manager, scripts = M.get_package_scripts()
  if not root then
    vim.notify("No package.json found in the current project", vim.log.levels.WARN)
    return
  end

  if vim.tbl_isempty(scripts) then
    vim.notify("No package scripts found in package.json", vim.log.levels.WARN)
    return
  end

  vim.ui.select(scripts, {
    prompt = "Run package script",
    format_item = function(item)
      return string.format("%s: %s", item.name, item.command)
    end,
  }, function(choice)
    if not choice then
      return
    end

    local overseer = require("overseer")
    local task = overseer.new_task({
      name = string.format("%s: %s", package_manager, choice.name),
      cmd = build_command(package_manager, choice.name),
      cwd = root,
      components = {
        { "open_output", direction = "bottom", focus = false, on_start = true },
        "default",
      },
    })
    task:start()
    overseer.open({ enter = false })
  end)
end

return M
