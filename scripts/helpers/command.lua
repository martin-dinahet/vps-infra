local M = {}

function M.run(command, options)
  options = options or {}

  if options.print ~= false then
    print(command)
  end

  local ok = os.execute(command)
  if ok ~= true and ok ~= 0 then
    os.exit(1)
  end
end

function M.exists(command)
  local ok = os.execute(command .. " >/dev/null 2>&1")
  return ok == true or ok == 0
end

function M.capture(command)
  local handle = io.popen(command)
  if not handle then
    os.exit(1)
  end

  local output = handle:read("*l")
  handle:close()

  return output
end

return M

