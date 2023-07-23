local M = {}

M.is_excluded_ft = function(excluded_fts, filetype)
  for _, ft in ipairs(excluded_fts) do
    if filetype == ft then
      return true
    end
  end
  return false
end

M.is_excluded_bt = function(excluded_bts, buftype)
  for _, bt in ipairs(excluded_bts) do
    if buftype == bt then
      return true
    end
  end
  return false
end

M.is_excluded_bn = function(excluded_bns, bufname)
  for _, bn in ipairs(excluded_bns) do
    if bufname == bn then
      return true
    end
  end
  return false
end

return M
