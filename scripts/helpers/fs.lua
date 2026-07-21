local command = dofile("scripts/helpers/command.lua")

local M = {}

function M.mkdir(path, sudo)
  local prefix = sudo and "sudo " or ""
  command.run(string.format("%smkdir -p %q", prefix, path))
end

function M.write_file(path, content)
  local file = assert(io.open(path, "w"))
  file:write(content)
  file:close()
end

function M.temp_dir()
  return command.capture("mktemp -d")
end

function M.temp_file()
  return command.capture("mktemp")
end

function M.remove(path)
  command.run(string.format("rm -rf %q", path), { print = false })
end

return M

