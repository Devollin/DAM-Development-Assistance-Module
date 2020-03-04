--// Tween 1.1.2 / Edited 2.13.20
local T = {}
T.__index = T

local function Pure(Obj, Prop, Dat)
	return TS:Create(Obj, TweenInfo.new(Dat.T, Dat.ES, Dat.ED, Dat.RC, Dat.R, Dat.DT), Prop)
end

function T.new(Data)
	return setmetatable({Data = Data, Completed = Data[1].Completed}, T)
end
function T:Cancel()
	for Index, TN in pairs(self.Data) do TN:Cancel() end
end
function T:Pause() 
	for Index, TN in pairs(self.Data) do TN:Pause() end
end
function T:Play()
	for Index, TN in pairs(self.Data) do TN:Play() end
end

local Info = {
	['Instance'] = function(Object, Properties, Data)
		return Pure(Object, Properties, Data)
	end,
	['table'] = function(Objects, Properties, Data)
		local Tweens = {}
		for Index, Object in pairs(Objects) do
			table.insert(Tweens, 1, Pure(Object, Properties, Data))
		end
		return T.new(Tweens)
	end,
	[true] = function(Tween) Tween:Play() end,
	[false] = function(Tween) Tween:Cancel() end
}

function DSL.Tween(Object, Properties, Data)
	 local Success, Ret = pcall(function()
		assert(Object and Properties and typeof(Properties) == "table", "Insufficient values, cancelling Tween!")
		local Data, Tween = Data or {}, nil
		Data.T = Data.T or .25 -- Time
		Data.ES = Data.ES and Enum.EasingStyle[Data.ES] or Enum.EasingStyle.Quart -- EasingStyle
		Data.ED = Data.ED and Enum.EasingDirection[Data.ED] or Enum.EasingDirection.Out -- EasingDirection
		Data.RC = Data.RC or 0 -- RepeatCount
		Data.R = Data.R or false -- Repeat
		Data.DT = Data.DT or 0 -- DelayTime
		Data.AP = Data.AP or true -- AutoPlay
		Data.CB = Data.CB or false -- Callback
		local Set = Info[typeof(Object)](Object, Properties, Data)
		Info[Data.AP](Set)
		return Set
	end)
	if Success then
		return Ret
	end
	warn('Tween failed:'..Ret)
end
