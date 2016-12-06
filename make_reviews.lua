local function read_file(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end


local reviews_pos = {}
local reviews_neg = {}

local i = 0
local j = 5
while i < 12500 do
	local path = "C:\\Users\\e1312013\\Documents\\T3_IA\\movie_review_dataset\\part1\\pos\\" .. i .. "_" .. j .. ".txt"
	print(path)
	local fileContent = read_file(path);
	if fileContent == nil then
		j = j + 1
	else
		fileContent = string.gsub(fileContent,"\"","")
		fileContent = string.gsub(fileContent,"<br />","")
		fileContent = string.lower(fileContent)
		table.insert(reviews_pos,fileContent);
		i = i + 1
		j = 5
	end
end
local i = 0
local j = 5
while i < 12500 do
	local path = "C:\\Users\\e1312013\\Documents\\T3_IA\\movie_review_dataset\\part2\\pos\\" .. i .. "_" .. j .. ".txt"
	print(path)
	local fileContent = read_file(path);
	if fileContent == nil then
		j = j + 1
	else
		fileContent = string.gsub(fileContent,"\"","")
		fileContent = string.gsub(fileContent,"<br />","")
		fileContent = string.lower(fileContent)
		table.insert(reviews_pos,fileContent);
		i = i + 1
		j = 5
	end
end
local i = 0
local j = 1
while i < 12500 do
	local path = "C:\\Users\\e1312013\\Documents\\T3_IA\\movie_review_dataset\\part1\\neg\\" .. i .. "_" .. j .. ".txt"
	print(path)
	local fileContent = read_file(path);
	if fileContent == nil then
		j = j + 1
	else
		fileContent = string.gsub(fileContent,"\"","")
		fileContent = string.gsub(fileContent,"<br />","")
		fileContent = string.lower(fileContent)
		table.insert(reviews_neg,fileContent);
		i = i + 1
		j = 1
	end
end
local i = 0
local j = 1
while i < 12500 do
	local path = "C:\\Users\\e1312013\\Documents\\T3_IA\\movie_review_dataset\\part2\\neg\\" .. i .. "_" .. j .. ".txt"
	print(path)
	local fileContent = read_file(path);
	if fileContent == nil then
		j = j + 1
	else
		fileContent = string.gsub(fileContent,"\"","")
		fileContent = string.gsub(fileContent,"<br />","")
		fileContent = string.lower(fileContent)
		table.insert(reviews_neg,fileContent);
		i = i + 1
		j = 1
	end
end

local file = io.open("reviews.txt", "w")
for _,value in pairs(reviews_pos) do
	file:write("\"" .. value .. "\",p\n")
end
for _,value in pairs(reviews_neg) do
	file:write("\"" .. value .. "\",n\n")
end
file:close()
