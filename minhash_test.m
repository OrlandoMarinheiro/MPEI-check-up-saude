function paciente_similar_real = minhash_test(dataset_path, sintomas_usuario)
    data = readcell(dataset_path);
    headers = data(1, :);
    data = data(2:end, :);
    threshold = 0.9;
    ids_pacientes = data(:, 1);
    sintomas = cell2mat(data(:, 2:end-3));
    lista_sintomas = headers(2:end-3);
    doencas = data(:, end-1);
    precaucoes = data(:, end);
    contagiosa = cell2mat(data(:, end-2));
    
    [N, num_sintomas] = size(sintomas);
    
    novo_paciente = zeros(1, num_sintomas);
    erro_detectado = false;
    for i = 1:length(sintomas_usuario)
        idx = find(strcmpi(lista_sintomas, sintomas_usuario{i}));
        if ~isempty(idx)
            novo_paciente(idx) = 1;
        else
            fprintf('Sintoma "%s" não encontrado na lista.\n', sintomas_usuario{i});
            erro_detectado = true;
            break;
        end
    end
    
    if erro_detectado
        disp('Erro: Um ou mais sintomas não são válidos. Tente novamente.');
        paciente_similar_real = [];
        return;
    end
    
    distancias = zeros(N, 1);
    for i = 1:N
        intersecao = sum(novo_paciente & sintomas(i, :));
        uniao = sum(novo_paciente | sintomas(i, :));
        distancias(i) = 1 - (intersecao / uniao);
    end
    
    [distancia_min, idx_min] = min(distancias);
    
    if distancia_min <= threshold
        paciente_similar_real = struct();
        paciente_similar_real.id_paciente = ids_pacientes{idx_min};
        paciente_similar_real.doenca = doencas{idx_min};
        paciente_similar_real.contagiosa = contagiosa(idx_min);
        paciente_similar_real.precaucoes = precaucoes{idx_min};
    else
        paciente_similar_real = [];
    end

end