#!/usr/bin/env lua

local infra = dofile("scripts/helpers/init.lua")
local command = infra.command
local fs = infra.fs
local paths = infra.paths

local retention_days = os.getenv("RETENTION_DAYS") or "14"
local backup_dir = paths.backups .. "/postgres"
local date = command.capture("date +%Y-%m-%d_%H-%M-%S")

local backup_file = backup_dir .. "/postgres_" .. date .. ".sql.gz"

fs.mkdir(backup_dir)
command.run(string.format("docker exec postgres pg_dumpall -U postgres | gzip > %q", backup_file))
command.run(string.format("find %q -type f -name 'postgres_*.sql.gz' -mtime +%q -delete", backup_dir, retention_days))

print("PostgreSQL backup complete: " .. backup_file)
