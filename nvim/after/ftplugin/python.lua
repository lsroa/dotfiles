local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<Leader>tt', function()
  local file_name = vim.fn.expand("%:p:t"):gsub(".py", "")
  local file_path = vim.fn.expand("%:.")
  local module_name = file_path:match("src/([^/]+)/.*$")
  local module_python = file_path:gsub("src/" .. module_name .. "/", "src/" .. module_name .. "/tests/")
  module_python = module_python:gsub(file_name, "test_" .. file_name)

  if vim.fn.winwidth(0) < 150 then
    vim.cmd("split " .. module_python)
  else
    vim.cmd("vsplit " .. module_python)
  end
end, opts)

vim.keymap.set('n', '<Leader>di', function()
  vim.cmd("tag " .. vim.fn.expand("<cword>"))
end, opts)

vim.keymap.set('n', '<Leader>y', function()
  local file = vim.fn.expand("%:."):gsub(".py", ".yaml")
  local module_name = vim.fn.expand("%:."):match("src/([^/]+)/.*$")
  local module_yaml = file:gsub("src/" .. module_name .. "/", "src/" .. module_name .. "/_dependency_injection/")

  if vim.fn.filereadable(module_yaml) == 1 then
    vim.cmd("edit " .. module_yaml)
  else
    local width = vim.fn.winwidth(0) < 150 and 0.5 or 0.45
    local file_name = vim.fn.expand("%:t"):gsub(".py", ".yaml")
    print(file_name)

    require('telescope.builtin').find_files(require('telescope.themes').get_dropdown {
      previewer = false,
      layout_config = {
        width = width,
      },
      path_display = { "filename_first" },
      default_text = file_name,
    })
  end
end, opts)


vim.api.nvim_create_user_command('TestContext', function(opts)
  local file_path = vim.fn.expand("%:.")
  local module_name = file_path:match("src/([^/]+)/.*$")
  vim.cmd("tabnew TestContext")
  vim.cmd("terminal " ..
    "docker compose run --rm -e FEVER2_STRICT_PYTHON_WARNINGS=True api python src/manage.py test --tag=unit --settings=config.settings --noinput src/" ..
    module_name .. " -v 3 --parallel")
end, {})

vim.keymap.set('n', '<Leader>x', function()
  local file = vim.fn.expand("%:."):gsub(".py", "")
  file = file:gsub("/", ".")


  if vim.fn.winwidth(0) < 150 then
    vim.cmd("split")
  else
    vim.cmd("vsplit")
  end


  vim.cmd("terminal " ..
    "docker compose run --rm -e FEVER2_STRICT_PYTHON_WARNINGS=True api python src/manage.py test --nomigrations --noinput -v 3 --settings=config.settings " ..
    file)
end, opts)
