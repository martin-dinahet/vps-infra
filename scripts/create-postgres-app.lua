#!/usr/bin/env lua

local command = dofile("scripts/helpers/command.lua")
local fs = dofile("scripts/helpers/fs.lua")
local postgres = dofile("scripts/helpers/postgres.lua")
local validators = dofile("scripts/helpers/validators.lua")

local app_name = arg[1]
local db_name = arg[2]
local db_user = arg[3]

validators.require_args({ app_name, db_name, db_user }, "Usage: create-postgres-app.lua <app_name> <db_name> <db_user>")
validators.identifier(app_name, "app_name")
validators.identifier(db_name, "db_name")
validators.identifier(db_user, "db_user")

local password_file = postgres.ensure_password(app_name)
local db_password = command.capture(string.format("sudo cat %q", password_file))
local sql_file = fs.temp_file()

fs.write_file(sql_file, postgres.app_sql(db_name, db_user, db_password))
command.run(string.format("docker exec -i postgres psql -U postgres < %q", sql_file))
os.remove(sql_file)

print("Database ready.")
print("DB_NAME=" .. db_name)
print("DB_USER=" .. db_user)
print("DB_PASSWORD_FILE=" .. password_file)
