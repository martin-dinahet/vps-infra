#!/usr/bin/env lua

local command = dofile("scripts/helpers/command.lua")
local fs = dofile("scripts/helpers/fs.lua")
local paths = dofile("scripts/helpers/paths.lua")
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
