local function map(func, coll)
  local lcoll = #coll
  local out = {}
  for i = 1, lcoll do
    table.insert(out, func(coll[i]))
  end
  return out
end
local function write_palette(file_name, palette)
  local f = assert(io.open(file_name, "w"))
  local function write_line(colour)
    local _0_ = colour
    local r = _0_[1]
    local g = _0_[2]
    local b = _0_[3]
    local ir = math.floor((255 * r))
    local ig = math.floor((255 * g))
    local ib = math.floor((255 * b))
    return f:write(("\n" .. ir .. " " .. ig .. " " .. ib))
  end
  f:write("JASC-PAL\n0100\n256")
  map(write_line, palette)
  return f:close()
end
local function generate_greys()
  local pal = {}
  for i = 0, 255 do
    local v = (i / 255)
    table.insert(pal, {v, v, v})
  end
  return pal
end
do
  local pal = generate_greys()
  return write_palette("greys.pal", pal)
end
