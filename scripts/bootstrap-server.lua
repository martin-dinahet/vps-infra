#!/usr/bin/env lua

local infra = dofile("scripts/helpers/init.lua")
local command = infra.command
local fs = infra.fs
local paths = infra.paths
local user = os.getenv("USER") or "root"

local directories = {
  paths.infra,
  paths.stacks,
  paths.stacks .. "/caddy",
  paths.stacks .. "/postgres",
  paths.data,
  paths.data .. "/caddy",
  paths.data .. "/caddy/data",
  paths.data .. "/caddy/config",
  paths.data .. "/postgres",
  paths.backups,
  paths.backups .. "/postgres",
  paths.scripts,
  paths.secrets,
}

for _, directory in ipairs(directories) do
  fs.mkdir(directory, true)
end

command.run(string.format("sudo chown -R %q:%q %q %q %q %q %q", user, user, paths.infra, paths.stacks, paths.data, paths.backups, paths.scripts))
command.run(string.format("sudo chmod 700 %q", paths.secrets))

print("Server directories are ready.")
