#!/usr/bin/env lua

local command = dofile("scripts/helpers/command.lua")
local paths = dofile("scripts/helpers/paths.lua")
local stack_name = arg[1]

if not stack_name then
  io.stderr:write("Usage: deploy-stack.lua <stack_name>\n")
  os.exit(1)
end

local stack_dir = paths.stacks .. "/" .. stack_name

if not command.exists(string.format("test -d %q", stack_dir)) then
  io.stderr:write("Stack directory not found: " .. stack_dir .. "\n")
  os.exit(1)
end

command.run(string.format("cd %q && docker compose pull", stack_dir))
command.run(string.format("cd %q && docker compose up -d --remove-orphans", stack_dir))
command.run("docker image prune -f")
