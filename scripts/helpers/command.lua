local command = {}

function command.run(value, options)
  options = options or {}

  if options.print ~= false then
    print(value)
  end

  local ok = os.execute(value)
  if ok ~= true and ok ~= 0 then
    os.exit(1)
  end
end

function command.exists(value)
  local ok = os.execute(value .. " >/dev/null 2>&1")
  return ok == true or ok == 0
end

function command.capture(value)
  local handle = io.popen(value)
  if not handle then
    os.exit(1)
  end

  local output = handle:read("*l")
  handle:close()

  return output
end

return command

