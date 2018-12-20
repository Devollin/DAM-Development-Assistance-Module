-- Development Support Library 0.1.0 / Coded by Devollin / Started 12.19.18

-- Synthesize 1.0.0 / Edited 12.19.18
local function Synthesize(Obj, Properties)
  assert(Obj and Properties, 'No parameters were filled!')
  local Parent = Properties.Parent or nil
  Properties.Parent = nil
  Obj = (typeof(Obj) == 'Instance' and Obj) or Instance.new(Obj)
  for Index, Prop in pairs(Properties) do
    Obj[Index] = Prop
  end
  Obj.Parent = Parent or Obj.Parent
  return Obj
end

return Synthesize
