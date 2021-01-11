--!strict
--// Development Support Library 0.6.0 / Coded by Devollin / Started 12.19.18
local DSL = {}

--// Synth 1.4.0 / Edited 1.11.21
function recursive(object: any, properties: any, modifiers: any)
	local final = (typeof(object) == "Instance" and object) or Instance.new(object)
	for name, property in pairs(properties) do
		if final[name] ~= nil and name ~= "Parent" then
			final[name] = property
		end
	end
	for class, data in pairs(modifiers.children) do
		if not final:FindFirstChild(class) then
			data.properties.Name = class
		end
		data.properties.Parent = final
		DSL.Synth(class, data.properties, data.modifiers)
	end
	for name, event in pairs(modifiers.callbacks) do
		final[name]:Connect(function(...)
			event(final, ...)
		end)
	end
	if final.Parent and final.Parent ~= game then
		final.Parent = properties.Parent or final.Parent
	end
	return final
end

function DSL.Synth(class: string, properties: any, modifiers: any)
	assert(class, "No parameters were filled!", debug.traceback())
	assert(properties, "No properties were provided!", debug.traceback())
	if typeof(class) == "string" and typeof(properties) == "table" then
		modifiers = modifiers or {callbacks = {}, children = {}}
		return recursive(class, properties, modifiers)
	else
		error("Invalid setup!")
	end
end

--// Weld 1.1.0 / Edited 1.11.21
function DSL.Weld(model: Model, corePart: BasePart, ignore: any)
	local ignoreList = {}
	if ignore and typeof(ignore) == "Instance" then
		if ignore:IsA("Model") then
			for _, ignored in pairs(ignore:GetDescendants()) do
				if ignored:IsA("BasePart") then
					table.insert(ignoreList, ignored)
				end
			end
		elseif ignore:IsA("BasePart") then
			table.insert(ignoreList, ignore)
		end
	elseif ignore and typeof(ignore) == "table" then
		for _, ignored in pairs(ignore) do
			if ignored:IsA("Model") then
				for _, ignoring in pairs(ignore:GetDescendants()) do
					if ignoring:IsA("BasePart") then
						table.insert(ignoreList, ignoring)
					end
				end
			elseif ignored:IsA("BasePart") then
				table.insert(ignoreList, ignored)
			end
		end
	end
	for _, child in pairs(model:GetDescendants()) do
		if child:IsA("BasePart") and (not table.find(ignore or {}, child)) and child ~= corePart then
			DSL.Synth("WeldConstraint", {Part0 = corePart, Part1 = child, Name = child.Name, Parent = corePart}, nil)
			child.Anchored = false
		end
	end
end

--// Magnitude 1.0.1 / Edited 1.11.21
function DSL.Magnitude(a: Vector3, b: Vector3)
	return math.sqrt((b.X - a.X) ^ 2 + (b.Y - a.Y) ^ 2 + (b.Z - a.Z) ^ 2)
end

--// Round 1.0.3 / Edited 1.11.21
function DSL.Round(number: number, place: number)
	local adjust = 10 ^ (place or 0)
	return math.ceil((number * adjust) - 0.5) / adjust
end

--// Center 1.0.1 / Edited 1.11.21
function DSL.Center(absoluteSize: Vector2)
	local mouse = game:GetService("Players").LocalPlayer:GetMouse()
	return Vector2.new(mouse.X - (absoluteSize.X / 2), mouse.Y - (absoluteSize.Y / 2))
end

--// Pythagorean 1.0.2 / Edited 1.11.21
function DSL.Pythagorean(a: number, b: number)
	return math.sqrt((a ^ 2) + (b ^ 2))
end

--// Shorthand 1.0.4 / Edited 1.11.21 / By Algoritimi
function DSL.Shorthand(number: number)
	local index, shorthand = math.clamp(math.floor(math.log10(number) / 3), 0, 4), {"", "k", "m", "b", "t"}
	return shorthand[index + 1] and tostring(DSL.Round(number / (1000 ^ index), (index == 0 and 0 or 1))) .. shorthand[index + 1] or number
end

--// GetDictionaryLength 1.0.1 / Edited 1.11.21
function DSL.GetDictionaryLength(dictionary: any)
	local length = 0
	for _, _ in pairs(dictionary) do
		length += 1
	end
	return length
end

--// TableMerge 1.0.0 / Edited 1.11.21
function DSL.TableMerge(a: any, b: any)
	local c = {}
	for index, value in pairs(a) do
		if type(value) == "table" then
			if c[index] == nil then
				c[index] = DSL.TableMerge({}, value)
			else
				c[index] = DSL.TableMerge(c[index], value)
			end
		else
			c[index] = value
		end
	end
	for index, value in pairs(b) do
		if type(value) == "table" then
			if c[index] == nil then
				c[index] = DSL.TableMerge({}, value)
			else
				c[index] = DSL.TableMerge(c[index], value)
			end
		else
			c[index] = value
		end
	end
	return c
end


--// Setup
for _, child in pairs(script:GetChildren()) do
	DSL[child.Name] = require(child)
end

return DSL
