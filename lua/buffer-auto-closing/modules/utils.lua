local M = {}

M.is_excluded_ft = function(excluded_fts, filetype)
  return vim.tbl_contains(excluded_fts, filetype)
end

M.is_excluded_bt = function(excluded_bts, buftype)
  return vim.tbl_contains(excluded_bts, buftype)
end

M.is_excluded_bn = function(excluded_bns, bufname)
  return vim.tbl_contains(excluded_bns, bufname)
end

return M
