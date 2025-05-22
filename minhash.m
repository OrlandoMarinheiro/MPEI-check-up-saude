function paciente_similar = minhash(dataset_path, sintomas_usuario)
   
    k = 1000;       
    threshold = 0.9; 

  
    data = readcell(dataset_path);
    headers = data(1, :);
    data = data(2:end, :);

  
    ids_pacientes = data(:, 1);
    sintomas = cell2mat(data(:, 2:end-3)); 
    lista_sintomas = headers(2:end-3); 
    doencas = data(:, end-1); 
    precaucoes = data(:, end); 
    contagiosa = cell2mat(data(:, end-2));  

    [N, num_sintomas] = size(sintomas);


    assinaturas = inf(N, k);
    for i = 1:N
        for j = 1:num_sintomas
            if sintomas(i, j) == 1
                hash_values = string2hash_V2(j, k);
                assinaturas(i, :) = min(assinaturas(i, :), hash_values);
            end
        end
    end


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
        paciente_similar = [];  
        return;
    end

    nova_assinatura = inf(1, k);
    for j = 1:num_sintomas
        if novo_paciente(j) == 1
            hash_values = string2hash_V2(j, k);
            nova_assinatura = min(nova_assinatura, hash_values);
        end
    end

  
    distancias = zeros(N, 1);
    for i = 1:N
        distancias(i) = sum(assinaturas(i, :) ~= nova_assinatura) / k;
    end

    
    [distancia_min, idx_min] = min(distancias);

    if distancia_min <= threshold
       
        paciente_similar = struct();
        paciente_similar.id_paciente = ids_pacientes{idx_min};
        paciente_similar.doenca = doencas{idx_min};
        paciente_similar.contagiosa = contagiosa(idx_min);
        paciente_similar.precaucoes = precaucoes{idx_min};

    else
        paciente_similar = [];  
    end
end
