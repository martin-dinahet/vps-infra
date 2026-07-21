local command = dofile("scripts/helpers/command.lua")

local M = {}

function M.ensure_network(name)
  if not command.exists(string.format("docker network inspect %q", name)) then
    command.run(string.format("docker network create %q", name))
  end
end

function M.compose_config(compose_file)
  command.run(string.format("docker compose -f %q config >/dev/null", compose_file), { print = false })
end

return M

