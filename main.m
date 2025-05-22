function main()
   
    dataset_path = 'dataset.csv'; 

    
    fig = uifigure('Name', 'Escolha uma opção', 'Position', [400 300 400 250]);

 
    lbl_title = uilabel(fig, 'Text', 'Check-up de saúde', ...
        'Position', [100 200 300 50], 'FontSize', 20, 'FontWeight', 'bold');

    btn_naive = uibutton(fig, 'Text', 'Verificar contagiosidade de sintomas', ...
        'Position', [50 140 300 40], ...
        'ButtonPushedFcn', @(btn, event) naive_bayes_interface(dataset_path, fig));

    btn_bloom = uibutton(fig, 'Text', 'Verificar se sintomas pertencem a uma doença', ...
        'Position', [50 80 300 40], ...
        'ButtonPushedFcn', @(btn, event) bloom_filter_interface(dataset_path, fig));

    btn_minhash = uibutton(fig, 'Text', 'Encontrar paciente mais similar', ...
        'Position', [50 20 300 40], ...
        'ButtonPushedFcn', @(btn, event) minhash_interface(dataset_path, fig));
end

function naive_bayes_interface(dataset_path, fig)
    
    if isvalid(fig)
        close(fig);
    end

    data = readcell(dataset_path);
    headers = data(1, :);
    sintomas = headers(2:end-3);

    fig = uifigure('Name', 'Verificar contagiosidade de sintomas', 'Position', [400 200 400 500]);
    lbl_sintomas = uilabel(fig, ...
        'Text', 'Selecione os sintomas:', ...
        'Position', [20 440 150 20], ...
        'FontSize', 12, ...
        'FontWeight', 'bold');

    scroll_panel = uipanel(fig, 'Position', [20 100 360 300], 'Scrollable', 'on');
    num_sintomas = length(sintomas);
    checkboxes = gobjects(1, num_sintomas);
    checkbox_height = 30;
    for i = 1:num_sintomas
        y_position = 10 + (num_sintomas - i) * checkbox_height;
        checkboxes(i) = uicheckbox(scroll_panel, ...
            'Text', sintomas{i}, ...
            'Position', [10 y_position 300 20]);
    end

  
    btn_voltar = uibutton(fig, 'Text', 'Voltar', ...
        'Position', [20 20 100 40], ...
        'ButtonPushedFcn', @(btn, event) close_current_window(fig));
    btn_classificar = uibutton(fig, 'Text', 'Verificar sintomas', ...
        'Position', [150 20 100 40], ...
        'ButtonPushedFcn', @(btn, event) classificar_naive_callback(checkboxes, sintomas, dataset_path));
    btn_terminar = uibutton(fig, 'Text', 'Terminar Diagnóstico', ...
        'Position', [280 20 100 40], ...
        'ButtonPushedFcn', @(btn, event) terminar_diagnostico(fig));
end

function bloom_filter_interface(dataset_path, fig)
   
    if isvalid(fig)
        close(fig);
    end

    data = readcell(dataset_path);
    headers = data(1, :);
    sintomas = headers(2:end-3);
    doencas = data(2:end, end-1); 
    doencas = unique(doencas(~cellfun('isempty', doencas)));

    fig = uifigure('Name', 'Verificar se sintomas pertencem a uma doença', 'Position',   [100 100 400 600]);

    lbl_sintomas = uilabel(fig, ...
        'Text', 'Selecione os sintomas:', ...
        'Position', [20 560 360 20], ...
        'FontSize', 12, ...
        'FontWeight', 'bold');

    scroll_panel_sintomas = uipanel(fig, 'Position', [20 300 360 250], 'Scrollable', 'on');
    num_sintomas = length(sintomas);
    checkboxes_sintomas = gobjects(1, num_sintomas);
    checkbox_height = 30;
    for i = 1:num_sintomas
        y_position = 10 + (num_sintomas - i) * checkbox_height;
        checkboxes_sintomas(i) = uicheckbox(scroll_panel_sintomas, ...
            'Text', sintomas{i}, ...
            'Position', [10 y_position 300 20]);
    end

    lbl_doencas = uilabel(fig, ...
        'Text', 'Selecione as doenças:', ...
        'Position', [20 260 360 20], ...
        'FontSize', 12, ...
        'FontWeight', 'bold');


    scroll_panel_doencas = uipanel(fig, 'Position', [20 100 360 150], 'Scrollable', 'on');
    num_doencas = length(doencas);
    checkboxes_doencas = gobjects(1, num_doencas);
    for i = 1:num_doencas
        y_position = 10 + (num_doencas - i) * checkbox_height;
        checkboxes_doencas(i) = uicheckbox(scroll_panel_doencas, ...
            'Text', doencas{i}, ...
            'Position', [10 y_position 300 20]);
    end


    btn_voltar = uibutton(fig, 'Text', 'Voltar', ...
        'Position', [20 20 100 40], ...
        'ButtonPushedFcn', @(btn, event) close_current_window(fig));
    btn_classificar = uibutton(fig, 'Text', 'Verificar sintomas e doença', ...
        'Position', [150 20 100 40], ...
        'ButtonPushedFcn', @(btn, event) verificar_bloom_callback(checkboxes_sintomas, sintomas, checkboxes_doencas, doencas, dataset_path));
    btn_terminar = uibutton(fig, 'Text', 'Terminar Diagnóstico', ...
        'Position', [280 20 100 40], ...
        'ButtonPushedFcn', @(btn, event) terminar_diagnostico(fig));
end

function minhash_interface(dataset_path, fig)
   
    if isvalid(fig)
        close(fig);
    end
    fig = uifigure('Name', 'Encontrar paciente mais similar', 'Position', [400 200 400 500]);
    lbl_sintomas = uilabel(fig, ...
        'Text', 'Selecione os sintomas:', ...
        'Position', [20 440 150 20], ...
        'FontSize', 12, ...
        'FontWeight', 'bold');




    data = readcell(dataset_path);
    headers = data(1, :);
    sintomas = headers(2:end-3);  % Sintomas disponíveis

    scroll_panel = uipanel(fig, 'Position', [20 100 360 300], 'Scrollable', 'on');
    num_sintomas = length(sintomas);
    checkboxes = gobjects(1, num_sintomas);
    checkbox_height = 30;

    for i = 1:num_sintomas
        y_position = 10 + (num_sintomas - i) * checkbox_height; % Posicionar em ordem
        checkboxes(i) = uicheckbox(scroll_panel, ...
            'Text', sintomas{i}, ...
            'Position', [10 y_position 300 20]);
    end

    btn_voltar = uibutton(fig, 'Text', 'Voltar', ...
        'Position', [20 20 100 40], ...
        'ButtonPushedFcn', @(btn, event) close_current_window(fig));
    btn_classificar = uibutton(fig, 'Text', 'Encontrar', ...
        'Position', [150 20 100 40], ...
        'ButtonPushedFcn', @(btn, event) verificar_minhash_callback(checkboxes, sintomas, dataset_path));
    btn_terminar = uibutton(fig, 'Text', 'Terminar Diagnóstico', ...
        'Position', [280 20 100 40], ...
        'ButtonPushedFcn', @(btn, event) terminar_diagnostico(fig));
end

function close_current_window(fig)
    close(fig);
    main();
end

function terminar_diagnostico(fig)
    close(fig);
    msgbox('Diagnóstico concluído!', 'Informação');
end

function verificar_minhash_callback(checkboxes, sintomas, dataset_path)
   
    sintomas_usuario = get_selected_sintomas(checkboxes, sintomas);

    
    if isempty(sintomas_usuario)
        msgbox('Nenhum sintoma selecionado. Por favor, selecione ao menos um sintoma.', 'Erro');
        return;
    end

  
    
  
    paciente_similar = minhash(dataset_path, sintomas_usuario);

    if ~isempty(paciente_similar)
        

        if paciente_similar.contagiosa == 1
            contagiosa_status = 'Sim';
        else
            contagiosa_status = 'Não';
        end
     
        msgbox(sprintf('Paciente mais similar encontrado: \nID do Paciente: %d\nDoença: %s\nContagiosa: %s\nPrecauções: %s', ...
            paciente_similar.id_paciente, paciente_similar.doenca, contagiosa_status, paciente_similar.precaucoes), 'Diagnóstico');
    else
        
        msgbox('Nenhum paciente suficientemente similar encontrado.', 'Diagnóstico');
    end
    
   
end

function verificar_bloom_callback( checkboxes_sintomas, sintomas, checkboxes_doencas, doencas, dataset_path)

    sintomas_usuario = get_selected_sintomas(checkboxes_sintomas, sintomas);

  
    doenca_selecionada = get_selected_doenca(checkboxes_doencas, doencas);


    if isempty(sintomas_usuario)
        msgbox('Por favor, selecione ao menos um sintoma.', 'Erro');
        return;
    end

  
    if isempty(doenca_selecionada)
        msgbox('Por favor, selecione uma doença.', 'Erro');
        return;
    end
    
    
 

    resultado = bloom_filter(sintomas_usuario, doenca_selecionada, dataset_path);
 

    if resultado == true
       
        msgbox(sprintf('Sintoma/s possíveis para a doença "%s" encontrado/s!', doenca_selecionada),'Diagnóstico');
    else
      
        msgbox(sprintf('Nenhum dos sintomas selecionados possíveis para a doença "%s".', doenca_selecionada),'Diagnóstico');
    end
   
end
function classificar_naive_callback(checkboxes, sintomas, dataset_path)
    sintomas_usuario = get_selected_sintomas(checkboxes, sintomas);

    if isempty(sintomas_usuario)
        msgbox('Por favor, selecione ao menos um sintoma.', 'Erro');
        return;
    end

  

    resultado = classificador_naive_bayes(sintomas_usuario, dataset_path);
    
    if resultado == 1
         
        
         msgbox('Os sintomas apresentados podem significar uma doença que é contagiosa.', 'Diagnóstico');
    else
       
        msgbox('Os sintomas apresentados podem significar uma doença que não é contagiosa.', 'Diagnóstico');
    end
  
end

function sintomas_usuario = get_selected_sintomas(checkboxes, sintomas)
 
    sintomas_usuario = {};
    for i = 1:length(checkboxes)
        if checkboxes(i).Value
            sintomas_usuario{end+1} = sintomas{i}; %#ok<AGROW>
        end
    end
end

function doenca_selecionada = get_selected_doenca(checkboxes, doencas)

    doenca_selecionada = '';
    for i = 1:length(checkboxes)
        if checkboxes(i).Value
            doenca_selecionada = doencas{i};
            break;
        end
    end
end
