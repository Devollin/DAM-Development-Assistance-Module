-- Development Support Library 0.1.0 / Coded by Devollin / Started 12.19.18

local DSL = {}

-- Synth 1.1.0 / Edited 2.22.19
function DSL.Synth(Obj, Properties)
  assert(Obj and Properties, 'No parameters were filled!')
  local Parent, Children = Properties.Parent or nil, Properties.Children or {}
  Properties.Parent, Properties.Children = nil, nil
  Obj = (typeof(Obj) == 'Instance' and Obj) or Instance.new(Obj)
  for Index, Prop in pairs(Properties) do
    Obj[Index] = Prop
  end
  for Index, Child in pairs(Children) do
    Child[2].Name = Child[2].Name or Index
    Child[2].Parent = Obj
    Synthesize(Child[1], Child[2])
  end
  Obj.Parent = Parent or Obj.Parent
  return Obj
end

return DSL
