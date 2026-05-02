local M = {}

local function normalize_startpath(startpath)
  local base = startpath
  if not base or base == "" then
    base = vim.api.nvim_buf_get_name(0)
  end
  if not base or base == "" then
    base = vim.fn.getcwd()
  end

  if vim.fn.isdirectory(base) == 1 then
    return base
  end

  return vim.fs.dirname(base)
end

local function search_root(markers, startpath)
  local search_path = normalize_startpath(startpath)
  local found = vim.fs.find(markers, {
    upward = true,
    path = search_path,
    stop = vim.loop.os_homedir(),
  })[1]

  return found and vim.fs.dirname(found) or nil
end

local function search_ancestor(startpath, predicate)
  local dir = normalize_startpath(startpath)
  local home = vim.loop.os_homedir()

  while dir and dir ~= "" do
    if predicate(dir) then
      return dir
    end

    if dir == home then
      break
    end

    local parent = vim.fs.dirname(dir)
    if not parent or parent == dir then
      break
    end
    dir = parent
  end

  return nil
end

local function path_exists(path)
  return vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1
end

local function is_executable_file(path)
  local stat = vim.uv.fs_stat(path)
  if not stat or stat.type ~= "file" then
    return false
  end

  return bit.band(stat.mode, 73) ~= 0
end

local function directory_contains(root, names)
  for _, name in ipairs(names) do
    if path_exists(root .. "/" .. name) then
      return true
    end
  end

  return false
end

local function directory_has_glob(root, pattern)
  return #vim.fn.globpath(root, pattern, false, true) > 0
end

local function project_file_contents(root, filename)
  local path = root .. "/" .. filename
  if vim.fn.filereadable(path) == 0 then
    return ""
  end

  return table.concat(vim.fn.readfile(path), "\n")
end

local function project_file_json(root, filename)
  local contents = project_file_contents(root, filename)
  if contents == "" then
    return nil
  end

  local ok, decoded = pcall(vim.json.decode, contents)
  if not ok or type(decoded) ~= "table" then
    return nil
  end

  return decoded
end

local function build_shell_command(script)
  return { "sh", "-lc", script }
end

local function build_package_command(package_manager, script)
  if package_manager == "yarn" then
    return { "yarn", script }
  elseif package_manager == "bun" then
    return { "bun", "run", script }
  end

  return { package_manager, "run", script }
end

local function build_task(task)
  return vim.tbl_deep_extend("force", {
    components = {
      { "open_output", direction = "bottom", focus = false, on_start = true },
      "default",
    },
  }, task)
end

local function unique_paths(paths)
  local seen = {}
  local unique = {}

  for _, path in ipairs(paths) do
    if path and path ~= "" and not seen[path] then
      seen[path] = true
      unique[#unique + 1] = path
    end
  end

  return unique
end

local function package_json_root(startpath)
  return search_root({ "package.json" }, startpath)
end

local function local_package_binary(root, binary)
  if not root then
    return nil
  end

  local dir = root
  local home = vim.loop.os_homedir()

  while dir and dir ~= "" do
    local candidate = dir .. "/node_modules/.bin/" .. binary
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end

    if dir == home then
      break
    end
    local parent = vim.fs.dirname(dir)
    if not parent or parent == dir then
      break
    end
    dir = parent
  end

  return nil
end

local function package_json_has_key(root, key)
  local package_json = project_file_json(root, "package.json")
  return package_json and package_json[key] ~= nil
end

local function package_has_dependency(root, names)
  local package_json = project_file_json(root, "package.json")
  if not package_json then
    return false
  end

  for _, section in ipairs({ "dependencies", "devDependencies", "peerDependencies", "optionalDependencies" }) do
    local deps = package_json[section]
    if type(deps) == "table" then
      for _, name in ipairs(names) do
        if deps[name] ~= nil then
          return true
        end
      end
    end
  end

  return false
end

local function prettier_config_root(startpath)
  local config_root = search_root({
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.json5",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.mjs",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
    "prettier.config.mjs",
    "prettier.config.ts",
  }, startpath)
  if config_root then
    return config_root
  end

  local root = package_json_root(startpath)
  if root and package_json_has_key(root, "prettier") then
    return root
  end

  return nil
end

local function biome_config_root(startpath)
  local root = search_root({ "biome.json", "biome.jsonc" }, startpath)
  if root and local_package_binary(root, "biome") then
    return root
  end

  return nil
end

local function eslint_config_root(startpath)
  local root = search_root({
    "eslint.config.js",
    "eslint.config.cjs",
    "eslint.config.mjs",
    "eslint.config.ts",
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.json",
  }, startpath)
  if root then
    return root
  end

  local package_root = package_json_root(startpath)
  if package_root and package_json_has_key(package_root, "eslintConfig") then
    return package_root
  end

  return nil
end

local function python_project_root(startpath)
  return search_root({
    "pyproject.toml",
    "uv.lock",
    "pytest.ini",
    "manage.py",
    "requirements.txt",
    ".venv",
    "setup.py",
    ".git",
  }, startpath)
end

local function cpp_project_root(startpath)
  return search_ancestor(startpath, function(dir)
    return directory_contains(dir, {
      "CMakeLists.txt",
      "Makefile",
      "compile_commands.json",
      "meson.build",
      ".git",
    })
  end)
end

local function ocaml_project_root(startpath)
  return search_ancestor(startpath, function(dir)
    return directory_contains(dir, {
      "dune-project",
      "dune-workspace",
      "dune",
      ".git",
    }) or directory_has_glob(dir, "*.opam")
  end)
end

local function rescript_project_root(startpath)
  return search_ancestor(startpath, function(dir)
    return directory_contains(dir, {
      "rescript.json",
      "bsconfig.json",
      "package.json",
      ".git",
    })
  end)
end

local function haskell_project_root(startpath)
  return search_ancestor(startpath, function(dir)
    return directory_contains(dir, {
      "cabal.project",
      "stack.yaml",
      "package.yaml",
      ".git",
    }) or directory_has_glob(dir, "*.cabal")
  end)
end

local function python_context_root(startpath)
  return python_project_root(startpath) or normalize_startpath(startpath)
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

local function detect_python_runner(root)
  if not root then
    return "python"
  end

  local pyproject = project_file_contents(root, "pyproject.toml")
  if vim.fn.filereadable(root .. "/uv.lock") == 1 or pyproject:find("%[tool%.uv", 1, false) then
    return "uv"
  end

  return "python"
end

local function find_python_executable(root)
  local prefixes = {
    vim.env.VIRTUAL_ENV,
    vim.env.CONDA_PREFIX,
    root and (root .. "/.venv") or nil,
    root and (root .. "/venv") or nil,
    root and (root .. "/.env") or nil,
    root and (root .. "/env") or nil,
  }

  for _, prefix in ipairs(prefixes) do
    if prefix and prefix ~= "" then
      local candidate = prefix .. "/bin/python"
      if vim.fn.executable(candidate) == 1 then
        return candidate
      end
    end
  end

  return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3")
    or vim.fn.exepath("python") ~= "" and vim.fn.exepath("python")
    or "python3"
end

local function detect_python_test_runner(root)
  if not root then
    return "unittest"
  end

  local pyproject = project_file_contents(root, "pyproject.toml")
  if vim.fn.filereadable(root .. "/pytest.ini") == 1
    or vim.fn.filereadable(root .. "/conftest.py") == 1
    or vim.fn.filereadable(root .. "/manage.py") == 1
    or pyproject:find("%[tool%.pytest", 1, false)
  then
    return "pytest"
  end

  return "unittest"
end

local function current_python_test_target(startpath)
  local filepath = startpath
  if not filepath or filepath == "" or vim.fn.isdirectory(filepath) == 1 then
    filepath = vim.api.nvim_buf_get_name(0)
  end

  local filename = vim.fs.basename(filepath)
  if filename:match("^test_.*%.py$") or filename:match(".*_test%.py$") then
    return filepath
  end

  return nil
end

local function build_python_command(args, startpath)
  local root = python_project_root(startpath)
  if detect_python_runner(root) == "uv" and vim.fn.exepath("uv") ~= "" then
    local cmd = { "uv", "run" }
    vim.list_extend(cmd, args)
    return cmd, root
  end

  local cmd = { find_python_executable(root) }
  vim.list_extend(cmd, args)
  return cmd, root
end

local function current_filetype(startpath)
  if not startpath or startpath == "" or startpath == vim.api.nvim_buf_get_name(0) then
    return vim.bo.filetype
  end

  return vim.filetype.match({ filename = startpath }) or vim.bo.filetype
end

local function detect_cpp_build_system(root)
  if not root then
    return nil
  end
  if path_exists(root .. "/CMakeLists.txt") or path_exists(root .. "/compile_commands.json") then
    return "cmake"
  end
  if path_exists(root .. "/meson.build") then
    return "meson"
  end
  if path_exists(root .. "/Makefile") then
    return "make"
  end
  return nil
end

local function detect_ocaml_build_system(root)
  if not root then
    return nil
  end
  if path_exists(root .. "/rescript.json") or path_exists(root .. "/bsconfig.json") then
    return "rescript"
  end
  if path_exists(root .. "/dune-project") or path_exists(root .. "/dune-workspace") or path_exists(root .. "/dune") or directory_has_glob(root, "*.opam") then
    return "dune"
  end
  return nil
end

local function detect_haskell_build_system(root)
  if not root then
    return nil
  end
  if path_exists(root .. "/stack.yaml") then
    return "stack"
  end
  if path_exists(root .. "/cabal.project") or path_exists(root .. "/package.yaml") or directory_has_glob(root, "*.cabal") then
    return "cabal"
  end
  return nil
end

local function get_package_scripts(startpath)
  local root = package_json_root(startpath)
  if not root then
    return nil, nil, {}
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

local function package_script_task(script, startpath, name)
  local root = package_json_root(startpath)
  if not root then
    return nil, "No package.json found in the current project"
  end

  local package_manager = detect_package_manager(root)
  return build_task({
    name = name or string.format("%s: %s", package_manager, script),
    cmd = build_package_command(package_manager, script),
    cwd = root,
  })
end

local function package_has_script(root, script)
  if not root then
    return false
  end

  local package_json = project_file_json(root, "package.json")
  return package_json
    and type(package_json.scripts) == "table"
    and type(package_json.scripts[script]) == "string"
end

local function package_script_task_if_present(script, startpath, name)
  local root = package_json_root(startpath)
  if not root then
    return nil, "No package.json found in the current project"
  end

  if not package_has_script(root, script) then
    return nil, string.format("No package script named '%s' found", script)
  end

  return package_script_task(script, startpath, name)
end

local function detect_project_target(startpath)
  local ft = current_filetype(startpath)

  if vim.tbl_contains({ "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" }, ft) then
    return "node", package_json_root(startpath)
  end
  if vim.tbl_contains({ "c", "cpp", "objc", "objcpp", "cuda" }, ft) then
    return "cpp", cpp_project_root(startpath)
  end
  if vim.tbl_contains({ "ocaml", "ocaml.interface", "ocaml.menhir", "ocaml.ocamllex", "ocaml.ocamlyacc", "reason" }, ft) then
    return "ocaml", ocaml_project_root(startpath)
  end
  if ft == "rescript" then
    return "rescript", rescript_project_root(startpath)
  end
  if vim.tbl_contains({ "haskell", "lhaskell", "cabal" }, ft) then
    return "haskell", haskell_project_root(startpath)
  end

  local root = cpp_project_root(startpath)
  if root then
    return "cpp", root
  end
  root = rescript_project_root(startpath)
  if root then
    return "rescript", root
  end
  root = ocaml_project_root(startpath)
  if root then
    return "ocaml", root
  end
  root = haskell_project_root(startpath)
  if root then
    return "haskell", root
  end
  root = package_json_root(startpath)
  if root then
    return "node", root
  end

  return nil, nil
end

local function run_task(task)
  local overseer = require("overseer")
  local task_instance = overseer.new_task(task)
  task_instance:start()
  overseer.open({ enter = false })
end

function M.find_package_root(startpath)
  return package_json_root(startpath)
end

function M.find_python_root(startpath)
  return python_project_root(startpath)
end

function M.find_cpp_root(startpath)
  return cpp_project_root(startpath)
end

function M.find_ocaml_root(startpath)
  return ocaml_project_root(startpath)
end

function M.find_rescript_root(startpath)
  return rescript_project_root(startpath)
end

function M.find_haskell_root(startpath)
  return haskell_project_root(startpath)
end

function M.detect_package_manager(root)
  return detect_package_manager(root)
end

function M.local_package_binary(binary, startpath)
  local root = package_json_root(startpath)
  return local_package_binary(root, binary), root
end

function M.prettier_config_root(startpath)
  local root = prettier_config_root(startpath)
  if root and local_package_binary(root, "prettier") then
    return root
  end

  return nil
end

function M.biome_config_root(startpath)
  return biome_config_root(startpath)
end

function M.eslint_config_root(startpath)
  local root = eslint_config_root(startpath)
  if root and (local_package_binary(root, "eslint") or package_has_dependency(root, { "eslint" })) then
    return root
  end

  return nil
end

function M.detect_python_runner(startpath)
  return detect_python_runner(python_project_root(startpath))
end

function M.detect_python_test_runner(startpath)
  return detect_python_test_runner(python_project_root(startpath))
end

function M.package_script_command(script, startpath)
  local root = package_json_root(startpath)
  if not root then
    return nil, nil
  end

  if not package_has_script(root, script) then
    return nil, root
  end

  local package_manager = detect_package_manager(root)
  return build_package_command(package_manager, script), root
end

function M.has_package_script(script, startpath)
  return package_has_script(package_json_root(startpath), script)
end

function M.python_executable(startpath)
  return find_python_executable(python_context_root(startpath))
end

function M.python_command(args, startpath)
  return build_python_command(args, startpath)
end

function M.python_runner_command(startpath)
  local root = python_project_root(startpath)
  if detect_python_runner(root) == "uv" and vim.fn.exepath("uv") ~= "" then
    return { "uv", "run", "python" }
  end

  return find_python_executable(python_context_root(startpath))
end

function M.get_package_scripts(startpath)
  return get_package_scripts(startpath or vim.api.nvim_buf_get_name(0))
end

function M.run_package_script()
  local root, package_manager, scripts = get_package_scripts(vim.api.nvim_buf_get_name(0))
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

    run_task(build_task({
      name = string.format("%s: %s", package_manager, choice.name),
      cmd = build_package_command(package_manager, choice.name),
      cwd = root,
    }))
  end)
end

function M.run_named_package_script(script, startpath)
  local task, err = package_script_task_if_present(script, startpath or vim.api.nvim_buf_get_name(0))
  if not task then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  run_task(task)
end

function M.run_python_file(startpath)
  local filepath = startpath or vim.api.nvim_buf_get_name(0)
  if filepath == "" or vim.fn.filereadable(filepath) == 0 then
    vim.notify("Current buffer is not a file on disk", vim.log.levels.WARN)
    return
  end

  local cmd, root = build_python_command({ filepath }, filepath)
  run_task(build_task({
    name = "python: run file",
    cmd = cmd,
    cwd = root or vim.fn.getcwd(),
  }))
end

function M.run_python_tests(startpath)
  local filepath = startpath or vim.api.nvim_buf_get_name(0)
  local root = python_project_root(filepath)
  if not root then
    vim.notify("No Python project root found", vim.log.levels.WARN)
    return
  end

  local runner = detect_python_test_runner(root)
  local args
  local name

  if runner == "pytest" then
    args = { "-m", "pytest" }
    local test_target = current_python_test_target(filepath)
    if test_target then
      args[#args + 1] = test_target
      name = "python: pytest file"
    else
      name = "python: pytest"
    end
  else
    args = { "-m", "unittest", "discover" }
    name = "python: unittest"
  end

  local cmd = build_python_command(args, root)
  run_task(build_task({
    name = name,
    cmd = cmd,
    cwd = root,
  }))
end

function M.project_build_command(startpath)
  local kind, root = detect_project_target(startpath)
  if not kind or not root then
    return nil, "No supported project root found"
  end

  if kind == "node" then
    for _, script in ipairs({ "build", "compile" }) do
      local task = package_script_task_if_present(script, startpath, "node: " .. script)
      if task then
        return task
      end
    end
    return nil, "No package build script found"
  elseif kind == "cpp" then
    local build_system = detect_cpp_build_system(root)
    if build_system == "cmake" then
      local build_dir = root .. "/build"
      if vim.fn.isdirectory(build_dir) == 1 then
        return build_task({
          name = "cpp: cmake build",
          cmd = { "cmake", "--build", "build" },
          cwd = root,
        })
      end
      return build_task({
        name = "cpp: cmake configure+build",
        cmd = build_shell_command("cmake -S . -B build && cmake --build build"),
        cwd = root,
      })
    end
    if build_system == "meson" then
      local build_dir = root .. "/build"
      if vim.fn.isdirectory(build_dir) == 1 then
        return build_task({
          name = "cpp: meson compile",
          cmd = { "meson", "compile", "-C", "build" },
          cwd = root,
        })
      end
      return build_task({
        name = "cpp: meson setup+compile",
        cmd = build_shell_command("meson setup build && meson compile -C build"),
        cwd = root,
      })
    end
    if build_system == "make" then
      return build_task({
        name = "cpp: make",
        cmd = { "make" },
        cwd = root,
      })
    end
  elseif kind == "ocaml" then
    return build_task({
      name = "ocaml: dune build",
      cmd = { "dune", "build" },
      cwd = root,
    })
  elseif kind == "rescript" then
    if vim.fn.exepath("rescript") ~= "" then
      return build_task({
        name = "rescript: build",
        cmd = { "rescript", "build" },
        cwd = root,
      })
    end
    local task = package_script_task("build", startpath, "rescript: build")
    if task then
      return task
    end
  elseif kind == "haskell" then
    local build_system = detect_haskell_build_system(root)
    if build_system == "stack" then
      return build_task({
        name = "haskell: stack build",
        cmd = { "stack", "build" },
        cwd = root,
      })
    end
    if build_system == "cabal" then
      return build_task({
        name = "haskell: cabal build",
        cmd = { "cabal", "build" },
        cwd = root,
      })
    end
  end

  return nil, "No supported build command found"
end

function M.project_test_command(startpath)
  local kind, root = detect_project_target(startpath)
  if not kind or not root then
    return nil, "No supported project root found"
  end

  if kind == "node" then
    for _, script in ipairs({ "test", "test:unit", "vitest", "jest" }) do
      local task = package_script_task_if_present(script, startpath, "node: " .. script)
      if task then
        return task
      end
    end
    return nil, "No package test script found"
  elseif kind == "cpp" then
    local build_system = detect_cpp_build_system(root)
    if build_system == "cmake" then
      if vim.fn.isdirectory(root .. "/build") == 0 then
        return nil, "No CMake build directory found; run project build first"
      end
      return build_task({
        name = "cpp: ctest",
        cmd = { "ctest", "--test-dir", "build", "--output-on-failure" },
        cwd = root,
      })
    end
    if build_system == "meson" then
      if vim.fn.isdirectory(root .. "/build") == 0 then
        return nil, "No Meson build directory found; run project build first"
      end
      return build_task({
        name = "cpp: meson test",
        cmd = { "meson", "test", "-C", "build" },
        cwd = root,
      })
    end
    if build_system == "make" then
      return build_task({
        name = "cpp: make test",
        cmd = { "make", "test" },
        cwd = root,
      })
    end
  elseif kind == "ocaml" then
    return build_task({
      name = "ocaml: dune runtest",
      cmd = { "dune", "runtest" },
      cwd = root,
    })
  elseif kind == "rescript" then
    local task = package_script_task("test", startpath, "rescript: test")
    if task then
      return task
    end
  elseif kind == "haskell" then
    local build_system = detect_haskell_build_system(root)
    if build_system == "stack" then
      return build_task({
        name = "haskell: stack test",
        cmd = { "stack", "test" },
        cwd = root,
      })
    end
    if build_system == "cabal" then
      return build_task({
        name = "haskell: cabal test",
        cmd = { "cabal", "test" },
        cwd = root,
      })
    end
  end

  return nil, "No supported test command found"
end

function M.c_family_compile_command(startpath)
  local filepath = startpath or vim.api.nvim_buf_get_name(0)
  if filepath == "" or vim.fn.filereadable(filepath) == 0 then
    return nil, "Current buffer is not a file on disk"
  end

  local ft = current_filetype(filepath)
  if ft ~= "c" and ft ~= "cpp" then
    return nil, "Current buffer is not a C/C++ file"
  end

  local compiler
  local std_flag
  if ft == "cpp" then
    compiler = vim.fn.exepath("clang++") ~= "" and "clang++" or "g++"
    std_flag = "-std=c++20"
  else
    compiler = vim.fn.exepath("clang") ~= "" and "clang" or "gcc"
    std_flag = "-std=c17"
  end

  local output = vim.fs.dirname(filepath) .. "/" .. vim.fn.fnamemodify(filepath, ":t:r") .. ".out"
  return build_task({
    name = ft .. ": compile file",
    cmd = { compiler, std_flag, "-g", "-O0", filepath, "-o", output },
    cwd = vim.fs.dirname(filepath),
  })
end

function M.c_family_executable_candidates(startpath)
  local filepath = startpath or vim.api.nvim_buf_get_name(0)
  local ft = current_filetype(filepath)
  if ft ~= "c" and ft ~= "cpp" then
    return {}
  end

  local root = cpp_project_root(filepath) or vim.fs.dirname(filepath)
  local stem = vim.fn.fnamemodify(filepath, ":t:r")
  local candidates = {
    vim.fs.dirname(filepath) .. "/" .. stem .. ".out",
    root .. "/build/" .. stem,
    root .. "/build/" .. stem .. ".out",
    root .. "/bin/" .. stem,
    root .. "/" .. stem,
  }

  for _, dir in ipairs({ root .. "/build", root .. "/bin", root .. "/build/debug", root .. "/build/Debug", root .. "/build/Release" }) do
    if vim.fn.isdirectory(dir) == 1 then
      for entry, entry_type in vim.fs.dir(dir) do
        local path = dir .. "/" .. entry
        if entry_type == "file" and is_executable_file(path) then
          candidates[#candidates + 1] = path
        end
      end
    end
  end

  local filtered = {}
  for _, path in ipairs(unique_paths(candidates)) do
    if is_executable_file(path) then
      filtered[#filtered + 1] = path
    end
  end

  return filtered
end

function M.c_family_debug_program(startpath)
  local filepath = startpath or vim.api.nvim_buf_get_name(0)
  local candidates = M.c_family_executable_candidates(filepath)

  if #candidates == 1 then
    return candidates[1]
  end

  if #candidates > 1 then
    local choices = { "Select executable:" }
    for index, candidate in ipairs(candidates) do
      choices[#choices + 1] = string.format("%d. %s", index, candidate)
    end

    local selection = vim.fn.inputlist(choices)
    if selection >= 1 and selection <= #candidates then
      return candidates[selection]
    end
  end

  local root = cpp_project_root(filepath) or vim.fn.getcwd()
  return vim.fn.input("Path to executable: ", root .. "/", "file")
end

function M.prompt_program_args()
  local input = vim.fn.input("Program arguments: ")
  if input == "" then
    return {}
  end

  return vim.split(vim.fn.expand(input), "%s+", { trimempty = true })
end

function M.run_project_build(startpath)
  local task, err = M.project_build_command(startpath)
  if not task then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  run_task(task)
end

function M.run_project_tests(startpath)
  local task, err = M.project_test_command(startpath)
  if not task then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  run_task(task)
end

function M.compile_c_family_file(startpath)
  local task, err = M.c_family_compile_command(startpath)
  if not task then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  run_task(task)
end

return M
