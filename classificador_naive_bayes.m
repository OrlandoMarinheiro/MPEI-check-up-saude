function resultado_contagiosa = classificador_naive_bayes(sintomas_usuario, dataset_path)
    data = readcell(dataset_path);
    headers = data(1, :);
    data = data(2:end, :);

    sintomas = headers(2:end-3);
    X = cell2mat(data(:, 2:end-3));
    Y = cell2mat(data(:, end-2));

    classes_contagiosa = unique(Y);
    prob_contagiosa = zeros(1, length(classes_contagiosa));

    for i = 1:length(classes_contagiosa)
        prob_contagiosa(i) = sum(Y == classes_contagiosa(i)) / length(Y);
    end

    prob_sintoma_dado_contagiosa = zeros(length(sintomas), length(classes_contagiosa));
    for i = 1:length(classes_contagiosa)
        classe = classes_contagiosa(i);
        X_classe = X(Y == classe, :);
        for j = 1:length(sintomas)
            prob_sintoma_dado_contagiosa(j, i) = sum(X_classe(:, j) == 1) / size(X_classe, 1);
        end
    end

    novo_paciente = zeros(1, length(sintomas));
    for i = 1:length(sintomas_usuario)
        idx = find(strcmpi(sintomas, sintomas_usuario{i}));
        if ~isempty(idx)
            novo_paciente(idx) = 1;
        end
    end

    prob_usuario = prob_contagiosa;
    for i = 1:length(classes_contagiosa)
        for j = 1:length(sintomas)
            if novo_paciente(j) == 1
                prob_usuario(i) = prob_usuario(i) * prob_sintoma_dado_contagiosa(j, i);
            else
                prob_usuario(i) = prob_usuario(i) * (1 - prob_sintoma_dado_contagiosa(j, i));
            end
        end
    end
    prob_usuario = prob_usuario / sum(prob_usuario);
    prob_sorted = sortrows([prob_usuario(:), classes_contagiosa(:)], -1);
    resultado_contagiosa = prob_sorted(1, 2);
end
