function possivel = bloom_filter(sintomas_utilizador, doenca_suspeita, dataset_path)
   
    bloom_size = 50000; 
    hash_count = 3;

   
    data = readcell(dataset_path);
    headers = data(1, :);
    data = data(2:end, :);
    lista_sintomas = headers(2:end-3);
    sintomas = cell2mat(data(:, 2:end-3));

    filtro_bloom = zeros(1, bloom_size);

    
    for i = 1:size(data, 1)
        sintomas_ativos = sintomas(i, :) == 1;
        doenca = data{i, end-1};
        for j = 1:length(sintomas_ativos)
            if sintomas_ativos(j)
                sintoma_ativo = lista_sintomas{j};
                combinacao_string = strcat(sintoma_ativo, doenca);
                filtro_bloom = add_bloom(filtro_bloom, combinacao_string, bloom_size, hash_count);
            end
        end
    end

    
    possivel = false;
    for i = 1:length(sintomas_utilizador)
        sintoma_utilizador = sintomas_utilizador{i};
        combinacao_string = strcat(sintoma_utilizador, doenca_suspeita);
        esta_presente =  in_bloom(filtro_bloom, combinacao_string, bloom_size, hash_count);
        if esta_presente
            possivel = true;
            break;
        end
    end
end

function filtro_bloom = add_bloom(filtro_bloom, item, bloom_size, hash_count)
    hashes = string2hash_V2(item, hash_count);
    for i = 1:hash_count
        indice = mod(abs(hashes(i)), bloom_size) + 1;
        filtro_bloom(indice) = 1;
    end
end

function esta_presente = in_bloom(filtro_bloom, item, bloom_size, hash_count)
    esta_presente = true;
    hashes = string2hash_V2(item, hash_count);
    for i = 1:hash_count
        indice = mod(abs(hashes(i)), bloom_size) + 1;
        if filtro_bloom(indice) == 0
            esta_presente = false;
            break;
        end
    end
end
