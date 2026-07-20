#!/usr/bin/env lua

local infra = dofile("scripts/helpers/init.lua")
local command = infra.command
local docker = infra.docker
local fs = infra.fs

local temp_secrets_dir = fs.temp_dir()

fs.write(temp_secrets_dir .. "/postgres.env", table.concat({
  "POSTGRES_USER=postgres",
  "POSTGRES_PASSWORD=dummy",
  "POSTGRES_DB=postgres",
  "",
}, "\n"))

local find_handle = io.popen("find stacks -mindepth 2 -maxdepth 2 -name compose.yml | sort")
if not find_handle then
  os.exit(1)
end

for compose_file in find_handle:lines() do
  local tmp_file = fs.temp_file()

  command.run(string.format("sed 's#/opt/secrets#%s#g' %q > %q", temp_secrets_dir, compose_file, tmp_file), { print = false })
  docker.compose_config(tmp_file)
  os.remove(tmp_file)
  print("OK " .. compose_file)
end

find_handle:close()
fs.remove(temp_secrets_dir)
