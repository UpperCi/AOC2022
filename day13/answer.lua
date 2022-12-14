local datafile = io.open("packets.txt")
local data = datafile:read("a")

function dump(o)
	if type(o) == 'table' then
	local s = '{  '
	for k,v in pairs(o) do
		if type(k) ~= 'number' then k = '"'..k..'"' end
		s = s .. dump(v) .. ' '
	end
	return s .. ' } '
	else
		return tostring(o)
	end
end

function parse_tbl(str)
	str = str:sub(2, #str - 1)
	local t = {}
	local current_t = t
	local parents = {}
	local num = ""
	for i = 1, #str do
		local c = str:sub(i, i)
		if c == '[' then
			table.insert(current_t, {})
			table.insert(parents, current_t)
			current_t = current_t[#current_t]
		elseif c == ']' then
			if num ~= "" then
				table.insert(current_t, tonumber(num))
				num = ""
			end
			current_t = parents[#parents]
			table.remove(parents, #parents)
		elseif c == ',' then
			table.insert(current_t, tonumber(num))
			num = ""
		else
			num = num .. c
		end
	end
	if num ~= "" then
		table.insert(current_t, tonumber(num))
	end
	return t
end

function compare_packets(p1, p2)
	if type(p1) == "number" then
		if type(p2) == "number" then
			if p1 == p2 then return 0
			elseif p1 < p2 then return 1 end
			return -1
		end
		return compare_packets({p1}, p2)
	end
	if type(p2) == "number" then
		return compare_packets(p1, {p2})
	end
	for i = 1, #p2 do
		if #p1 < i then
			return 1
		end
		local comp = compare_packets(p1[i], p2[i])
		if comp ~= 0 then
			return comp
		end
	end
	if #p1 > #p2 then
		return -1
	end
	return 0
end

local packet = {}
local pi = 1
local total = 0
local packets = {{2}, {6}}
for str in data:gmatch("[^\r\n]+") do
	table.insert(packets, parse_tbl(str))
	table.insert(packet, parse_tbl(str))
	if #packet >= 2 then
		if compare_packets(packet[1], packet[2]) == 1 then
			total = total + pi
		end
		pi = pi + 1
		packet = {}
	end
end

print(total)

function sort_packets(p1, p2)
	return compare_packets(p1, p2) == 1
end

table.sort(packets, sort_packets)

local dc1 = 0
local dc2 = 0
for i = 1, #packets do
	local p = packets[i]
	if p ~= nil then
		if p[1] == 2 then dc1 = i end
		if p[1] == 6 then dc2 = i end
	end
end

print(dc1 * dc2)
