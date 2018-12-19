-- Development Assistance Module 0.1.0 / Coded by Devollin / Started 12.19.18

-- Synthesize 1.0.0 / Edited 12.19.18
local function Synthesize(Obj, Data)
  assert(Obj and Data, 'No parameters were filled!')
  Obj = (typeof(Obj) == 'Instance' and Obj) or Instance.new(Obj)
  for Index, Prop in pairs(Data) do
    if Index ~= 'Parent' then
      Obj[Index] = Prop
    end
  end
  if Data.Parent then
    Obj.Parent = Data.Parent
  end
  return Obj
end

return Synthesize
