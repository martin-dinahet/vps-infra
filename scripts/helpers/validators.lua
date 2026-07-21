local M = {}

function M.require_args(values, usage)
  for _, value in ipairs(values) do
    if not value then
      io.stderr:write(usage .. "\n")
      os.exit(1)
    end
  end
end

function M.identifier(value, label)
  if value and value:match("^[A-Za-z_][A-Za-z0-9_]*$") then
    return
  end

  io.stderr:write(label .. " must contain only letters, numbers and underscores, and must not start with a number.\n")
  os.exit(1)
end

return M

