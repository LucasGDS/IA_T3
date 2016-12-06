-- Temos uma bag of words para as palavras que aparecem nas avaliacoes positivas e uma para as palavras que aparecem nas negativas
-- O indice é a palavra e o conteudo é a quanitdade de aparicoes
local bag_of_words_pos = {}
local bag_of_words_neg = {}

-- Tabela que contem as 25 palavras positivas que mais aparecem e as 25 negativas que mais aparecem
-- O indice é a palavra e o conteudo é a quanitdade de aparicoes
local top_words = {}

-- Tabelas que contém os textos das analises e se são positivas ou negativas (p ou n)
local reviews = {}
local notas = {}

--
function remove_repetidos()

	-- Para todas as palavras que aparecem tanto nas avaliacoes positivas e negativas:
	for key,value in pairs(bag_of_words_pos) do
		if bag_of_words_neg[key] ~= nil then

			-- Se aparecer 2 vezes mais em uma tabela do que em outra, removemos na que aparece menos
			if bag_of_words_pos[key] > 2*bag_of_words_neg[key] then

				bag_of_words_neg[key] = nil

			elseif bag_of_words_neg[key] > 2*bag_of_words_pos[key] then

				bag_of_words_pos[key] = nil

			-- Se a diferenca for menor do que o dobro, consideramos que são são muito próximas e descartamos das duas tabelas
			else

				bag_of_words_neg[key] = nil
				bag_of_words_pos[key] = nil

			end
		end
	end
end

-- Funcao que remove as palavras que apareceram poucas vezes nas analises, para agilizar o processamento
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

-- Funcao que preenche a tabela top_words
function complete_top_words()
	local max_key
	local max_value = 0
	local qnt_total = 25

	-- Percorre a tabela das palavras positivas, busca as 25 mais usadas e passa para a top_words
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

	-- Percorre a tabela das palavras negativas, busca as 25 mais usadas e passa para a top_words
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

-- Funcao que le o arquivo pre formatado reviews.txt e completa as tabelas com as informacoes
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

		-- Itera cada palavra da avaliacao
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

		-- Passa para a proxima linha
		content = file:read("*line")
	end

	file:close()
end

-- Funcao que escreve o arquivo ARFF no formato correto
function write_arff()
	local file = io.open("final.arff", "w")

	-- Escreve o cabecalho
	file:write("@RELATION reviews\n\n")
	for key,value in pairs(top_words) do
		file:write("@ATTRIBUTE " .. key .. "  NUMERIC\n")
	end
	file:write("@ATTRIBUTE class        {p,n}\n\n")

	-- Escreve o corpo dos dados
	file:write("@DATA\n")

	for i,frase in pairs(reviews) do
		local qnt = 0

		-- Para cada palavra do top_words, conta quantas vezes elas aparecem na analise
		for key,_ in pairs(top_words) do
			for word in string.gmatch(frase, "%a+") do
				if word == key then
					qnt = qnt + 1
				end
			end
			file:write(qnt .. ",")
			qnt = 0
		end
		-- Escreve se é p ou n
		file:write(notas[i] .. "\n")
	end

	file:close()
end

-- Chamada das funcoes
read_file()
remove_poucas_aparicoes()
remove_repetidos()
complete_top_words()
write_arff()

-- Print para debug
--for key,value in pairs(top_words) do print(key,value) end




















