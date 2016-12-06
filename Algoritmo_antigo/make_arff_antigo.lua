local bag_of_words_pos = {}
local bag_of_words_neg = {}
local top_words = {}
local reviews = {}
local notas = {}

function remove_repetidos()
	for key,value in pairs(bag_of_words_pos) do
		if bag_of_words_neg[key] ~= nil then
			bag_of_words_neg[key] = nil
			bag_of_words_pos[key] = nil
		end
	end
end

function remove_poucas_aparicoes()
	for key,value in pairs(bag_of_words_pos) do
		if value < 1000 then
			bag_of_words_pos[key] = nil
		end
	end
	for key,value in pairs(bag_of_words_neg) do
		if value < 1000 then
			bag_of_words_neg[key] = nil
		end
	end
end

function complete_top_words()
	local max_key
	local max_value = 0
	local qnt_total = 25
	
	for i = 1, qnt_total do
		for key,value in pairs(bag_of_words_pos) do
			if (value >= max_value) and (top_words[key] == nil) then
				max_value = value
				max_key = key
			end
		end
		top_words[max_key] = max_value
		max_value = 0
	end
	for i = 1, qnt_total do
		for key,value in pairs(bag_of_words_neg) do
			if (value >= max_value) and (top_words[key] == nil) then
				max_value = value
				max_key = key
			end
		end
		top_words[max_key] = max_value
		max_value = 0
	end
	
end

function read_file()
	local file = io.open("reviews.txt", "r")
	local content = file:read("*line")
	while content ~= nil do
		
		content = string.sub(content, 2)
		local divisao = string.find(content, "\"")
		local text =  string.sub(content, 1, divisao-1)
		local nota = string.sub(content, -1)
		table.insert(reviews, text)
		table.insert(notas, nota)
		for word in string.gmatch(text, "%a+") do
			if nota == 'p' then
				if bag_of_words_pos[word] == nil then
					bag_of_words_pos[word] = 1
				else
					bag_of_words_pos[word] = bag_of_words_pos[word] + 1
				end
			elseif nota == 'n' then
				if bag_of_words_neg[word] == nil then
					bag_of_words_neg[word] = 1
				else
					bag_of_words_neg[word] = bag_of_words_neg[word] + 1
				end
			end
		end

		content = file:read("*line")
		--content = nil
	end

	file:close()
end

function write_arff()
	local file = io.open("final.arff", "w")
	file:write("@RELATION reviews\n\n")
	for key,value in pairs(top_words) do
		file:write("@ATTRIBUTE " .. key .. "  NUMERIC\n")
	end
	file:write("@ATTRIBUTE class        {p,n}\n\n")
	file:write("@DATA\n")
	
	for i,frase in pairs(reviews) do
		local qnt = 0
		for key,_ in pairs(top_words) do
			for word in string.gmatch(frase, "%a+") do
				if word == key then
					qnt = qnt + 1
				end
			end
			file:write(qnt .. ",")
			qnt = 0
		end
		file:write(notas[i] .. "\n")
	end
	
	file:close()
end


read_file()
remove_poucas_aparicoes()
remove_repetidos()
complete_top_words()
write_arff()

for key,value in pairs(top_words) do print(key,value) end




















