-- date_util.lua: Single responsibility for date operations
local DateUtil = {}

function DateUtil.getDateWithOffset(offset)
  return os.date("%%Y-%%b-%%d", os.time() + offset * 24 * 60 * 60)
end

return DateUtil
