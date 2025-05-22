function test_bloom_filter(dataset_path)
   
    bloom_size = 50000;

    max_hash_count = 7;

    
    data = readcell(dataset_path);
    headers = data(1, :);
    data = data(2:end, :);
    lista_sintomas = headers(2:end-3);
    sintomas = cell2mat(data(:, 2:end-3));
    doencas = data(:, end-1); 

    melhor_hash_count = 0;
    menor_falsos_positivos = inf;
    
    for hash_count = 1:max_hash_count
        filtro_bloom = zeros(1, bloom_size);
        total_colisoes = 0;
        falso_positivo_count = 0;

        for i = 1:size(data, 1)
            sintomas_ativos = sintomas(i, :) == 1;
            doenca = data{i, end-1};
            for j = 1:length(sintomas_ativos)
                if sintomas_ativos(j)
                    sintoma_ativo = lista_sintomas{j};
                    combinacao_string = strcat(sintoma_ativo, doenca);
                    [filtro_bloom, colisao] = add_bloom(filtro_bloom, combinacao_string, bloom_size, hash_count);
                    total_colisoes = total_colisoes + colisao;
                end
            end
        end
        
        todas_doencas = unique(doencas);
        todos_sintomas = lista_sintomas;
        for i = 1:length(todos_sintomas)
            for j = 1:length(todas_doencas)
                sintoma_index = strcmpi(headers, todos_sintomas{i});
                presente_no_dataset = false;
                
                if any(cell2mat(data(:, sintoma_index))) 
                    for k = 1:size(data, 1)
                        if data{k, sintoma_index} == 1 
                            combinacao_string = strcat(todos_sintomas{i}, todas_doencas{j});
                            if strcmpi(data{k, end-1}, todas_doencas{j})
                                presente_no_dataset = true;
                            break;
                            end
                        end
                    end
                end
                
                if ~presente_no_dataset && in_bloom(filtro_bloom, combinacao_string, bloom_size, hash_count)
                    falso_positivo_count = falso_positivo_count + 1;
                end
            end
        end

        total_combinacoes = length(todos_sintomas) * length(todas_doencas);
        percent_falsos_positivos = (falso_positivo_count / total_combinacoes) * 100;

        fprintf('Hash Count: %d, Falsos Positivos: %d, Percentagem de Falsos Positivos: %.2f%%, Colisões: %d\n', ...
                hash_count, falso_positivo_count, percent_falsos_positivos, total_colisoes);

        if falso_positivo_count < menor_falsos_positivos
            melhor_hash_count = hash_count;
            menor_falsos_positivos = falso_positivo_count;
        end
    end

    fprintf('\nMelhor configuração encontrada:\n');
    fprintf('Número de funções de hash: %d\n', melhor_hash_count);
end


function [filtro_bloom, colisao] = add_bloom(filtro_bloom, item, bloom_size, hash_count)
    colisao = 0;
    hashes = string2hash_V2(item, hash_count);
    for i = 1:hash_count
        indice = mod(abs(hashes(i)), bloom_size) + 1;
        if filtro_bloom(indice) == 1
            colisao = colisao + 1;
        end
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
