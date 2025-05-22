%% Minhash test 
fprintf("TESTE MINHASH\n");
 data = readcell('dataset.csv');
 headers = data(1, :);
 data = data(2:end, :);

    % Extrair informações do dataset
  ids_pacientes = data(:, 1);
  sintomas = cell2mat(data(:, 2:end-3));  % Sintomas dos pacientes
  lista_sintomas = headers(2:end-3);  % Lista de sintomas disponíveis
 %%%% Apenas para testar %%%%%
 fprintf('Lista de sintomas disponíveis:\n');
 for i = 1:length(lista_sintomas)
    fprintf('%d. %s\n', i, lista_sintomas{i});
 end
 %%% INSERIR MANUALMENTE SINTOMAS DA LISTA DE SINTOMAS DISPONIVEIS %%% 
 disp('Digite os nomes dos sintomas que você possui, separados por vírgulas.');
 entrada_usuario = input('Exemplo: itching, skin_rash\n', 's');
 sintomas_usuario = split(strtrim(entrada_usuario), ',');
 sintomas_usuario = strtrim(sintomas_usuario);
 %%%% Apenas para testar %%%%%
paciente_similar_real = minhash_test('dataset.csv', sintomas_usuario);
fprintf("Paciente mais similar usando distância real\n");
fprintf('ID do Paciente: %d\n', paciente_similar_real.id_paciente);
if paciente_similar_real.contagiosa == 1
           fprintf('Contagiosa: Sim\n');
else
           fprintf('Contagiosa: Não\n');
end
fprintf('Doença: %s\n', paciente_similar_real.doenca);
fprintf('Precauções: %s\n', paciente_similar_real.precaucoes);

fprintf("\n")
 
paciente_similar_minhash = minhash('dataset.csv', sintomas_usuario);



fprintf("Paciente mais similar usando minhash\n");
fprintf('ID do Paciente: %d\n', paciente_similar_minhash.id_paciente);
if paciente_similar_minhash.contagiosa == 1
       fprintf('Contagiosa: Sim\n');
else
       fprintf('Contagiosa: Não\n');
end
fprintf('Doença: %s\n', paciente_similar_minhash.doenca);
fprintf('Precauções: %s\n', paciente_similar_minhash.precaucoes);

%% Teste Classificador Naive-Bayes
fprintf("\n")
fprintf("TESTE CLASSIFICADOR")
fprintf("\n")
[precisao, recall, f1]= classificador_naive_bayes_test("dataset.csv");
fprintf('Precisão: %.4f\n', precisao);
fprintf('Recall: %.4f\n', recall);
fprintf('F1-score: %.4f\n', f1);

%% Teste Filtro de Bloom
fprintf("\n");
fprintf("TESTE FILTRO DE BLOOM\n");
test_bloom_filter("dataset.csv");