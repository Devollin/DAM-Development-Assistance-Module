--// Development Support Library 0.5.0 / Coded by Devollin / Started 12.19.18

local DSL = {}
local TS = game:GetService('TweenService')

--// Setup

for Index, Child in pairs(script:GetChildren()) do
	for FuncName, Func in pairs(require(Child)) do
		DSL[FuncName] = Func
	end
end

--// Synth 1.2.0 / Edited 2.10.20
function Recursive(Obj, Properties)
	local Parent, Children = Properties.Parent or nil, Properties.Children or {}
	Properties.Parent, Properties.Children = nil, nil
	Obj = (typeof(Obj) == 'Instance' and Obj) or Instance.new(Obj)
	for Index, Prop in pairs(Properties) do
		Obj[Index] = Prop
	end
	for Index, Child in pairs(Children) do
		Child[2].Name = Child[2].Name or Index
		Child[2].Parent = Obj
		DSL.Synth(Child[1], Child[2])
	end
	if Obj.Parent ~= game then
		Obj.Parent = Parent or Obj.Parent
	end
	return Obj
end

function DSL.Synth(Obj, Properties)
	assert(Obj and Properties, 'No parameters were filled!')
	if typeof(Obj) == 'table' then
		local Objects = {}
		for Index, Ob in pairs(Obj) do
			Recursive(Ob, Properties)
		end
		return Objects
	else
		return Recursive(Obj, Properties)
	end
end

--// Weld 1.0.3 / Edited 3.24.20
function DSL.Weld(Model, CorePart, Ignore)
	for Ind, Child in pairs(Model:GetDescendants()) do
		if Child ~= Ignore and Child ~= CorePart then
			if Child:IsA("BasePart") then
				DSL.Synth('WeldConstraint', {Part0 = CorePart, Part1 = Child, Name = Child.Name, Parent = CorePart})
				Child.Anchored = false
			end
		end
	end
end

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

--// Magnitude 1.0.0 / Edited 8.31.19
function DSL.Magnitude(Start, End)
	return math.sqrt((End.X - Start.X) ^ 2 + (End.Y - Start.Y) ^ 2 + (End.Z - Start.Z) ^ 2)
end

--// Round 1.0.2 / Edited 6.3.20
function DSL.Round(Number, Place)
	local Adjust = 10 ^ (Place or 0)
	return math.ceil((Number * Adjust) - 0.5) / Adjust
end

--// Center 1.0.0 / Edited 2.10.20
function DSL.Center(Gui, Mouse)
	return Vector2.new(Mouse.X - (Gui.AbsoluteSize.X / 2), Mouse.Y - (Gui.AbsoluteSize.Y / 2))
end

--// Pythagorean 1.0.1 / Edited 5.29.20
function DSL.Pythagorean(A, B)
	return math.sqrt((A ^ 2) + (B ^ 2))
end

--// Shorthand 1.0.3 / Edited 6.3.20 / By Algoritimi
function DSL.Shorthand(Number)
	local Index = math.clamp(math.floor(math.log10(Number) / 3), 0, 4)
	local Shorthand = {
		[0] = '',
		[1] = "k",
		[2] = "m",
		[3] = "b",
		[4] = 't'
	}
	local Place = Index == 0 and 0 or 1
	return Shorthand[Index] and tostring(DSL.Round(Number / (1000 ^ Index), Place)) .. Shorthand[Index] or Number
end

--// GetLengthOfDictionary 1.0.0 / Edited 5.29.20
function DSL.GetLengthOfDictionary(Dictionary)
	local Length = 0
	for Index, Item in pairs(Dictionary) do
		Length = Length + 1
	end
	return Length
end

return DSL
