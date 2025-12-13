local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<Leader>tt', function()
  local file_path = vim.fn.expand("%:p:h")
  local file_name = string.gsub(string.gsub(tostring(vim.fn.expand("%:t")), ".ts$", ""), ".tsx$", "")
  for _, path in ipairs {
    file_path .. '/__test__/' .. file_name .. ".test.ts",
    file_path .. '/__test__/' .. file_name .. ".test.tsx",
    file_path .. '/__tests__/' .. file_name .. ".test.ts",
    file_path .. '/__tests__/' .. file_name .. ".test.tsx",
    file_path .. '/' .. file_name .. ".test.ts",
    file_path .. '/' .. file_name .. ".test.tsx",
    file_path .. '/' .. file_name .. ".spec.ts",
    file_path .. '/__test__/' .. file_name .. ".spec.tsx",
    file_path .. '/__test__/' .. file_name .. ".spec.ts",
  } do
    print(path)
    if vim.fn.filereadable(path) == 1 then
      if vim.fn.winwidth(0) < 150 then
        vim.cmd("split " .. path)
      else
        vim.cmd("vsplit " .. path)
      end
    end
  end
end, opts)

local run_npm_script = function()
  local cmd = {
    "jq", "-r", ".scripts| to_entries | map(.key)", "package.json"
  }
  local obj = vim.system(cmd, { text = true }):wait()

  ---@type  string[]
  local entries = vim.json.decode(obj.stdout)

  vim.ui.select(entries, {
    prompt = 'Run package.json script:',
    format_item = function(item)
      return item
    end
  }, function(choice)
    if (choice == nil) then
      return
    end

    local file_path = tostring(vim.fn.expand("%:p"))
    local direction = vim.fn.winwidth(0) > 150 and "right" or "down"
    local npm_script = { "zellij", "run", "--name", choice, "--direction", direction, "--",
      "npm", "run", choice, file_path
    }
    vim.system(npm_script)
  end)
end

vim.keymap.set('n', '<Leader>x', run_npm_script, opts)
