title = "buffer-closer"
project = "buffer-closer"
description = "Automatically close buffers that are retired after a certain amount of time."
format="discount"
dir="docs"
readme="README.md"
sort=true
file="./lua/"
sort_modules=true

local upat = "http://www.buffer-closer.org/docs/%s/%s.%s.html"
custom_see_handler('^([%w_]+)%((%d)%)$',function(name,section)
    local url = upat:format(section,name,section)
    local name = name .. '(' ..section..')'
    return name, url
end)


