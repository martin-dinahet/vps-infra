local command = dofile("scripts/helpers/command.lua")
local paths = dofile("scripts/helpers/paths.lua")

local M = {}

function M.ensure_password(app_name)
  local password_file = paths.secrets .. "/" .. app_name .. "_postgres_password"

  if not command.exists(string.format("test -f %q", password_file)) then
    command.run(string.format("sudo sh -c 'umask 077 && openssl rand -hex 32 > %q'", password_file))
  end

  return password_file
end

function M.app_sql(db_name, db_user, db_password)
  return string.format([[
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '%s') THEN
    CREATE ROLE %s LOGIN PASSWORD '%s';
  ELSE
    ALTER ROLE %s WITH PASSWORD '%s';
  END IF;
END
$$;

SELECT 'CREATE DATABASE %s OWNER %s'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '%s')\gexec

GRANT ALL PRIVILEGES ON DATABASE %s TO %s;
]], db_user, db_user, db_password, db_user, db_password, db_name, db_user, db_name, db_name, db_user)
end

return M

