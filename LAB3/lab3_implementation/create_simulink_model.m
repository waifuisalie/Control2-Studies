%% Create Simulink Model for LAB3 Closed-Loop Testing
% This script creates a Simulink model similar to novo.slx
% for testing PID controllers with M1 and M2

function create_simulink_model()

    % Load the PID controllers
    load('LAB3_Part2_controllers.mat');

    % Create model for M1
    create_model_M1(G1, C_ZN_M1, C_AMIGO_M1, C_SIMC_M1);

    % Create model for M2
    create_model_M2(G2, C_ZN_M2, C_AMIGO_M2, C_SIMC_M2);

    fprintf('Simulink models created successfully!\n');
    fprintf('  - LAB3_M1_ClosedLoop.slx\n');
    fprintf('  - LAB3_M2_ClosedLoop.slx\n');
end

function create_model_M1(G, C_ZN, C_AMIGO, C_SIMC)
    % Create new Simulink model for M1
    modelName = 'LAB3_M1_ClosedLoop';

    % Close if already open
    close_system(modelName, 0);

    % Create new model
    new_system(modelName);
    open_system(modelName);

    % Add blocks - Reference input
    add_block('simulink/Sources/Step', [modelName '/Setpoint'], ...
        'Position', [50, 100, 80, 130], ...
        'Time', '1', 'Before', '0', 'After', '1');

    % Y positions for parallel controllers
    y_pos = [150, 250, 350];
    methods = {'ZN', 'AMIGO', 'SIMC'};
    controllers = {C_ZN, C_AMIGO, C_SIMC};

    for i = 1:3
        method = methods{i};
        C = controllers{i};
        y = y_pos(i);

        % Sum block (error)
        add_block('simulink/Math Operations/Sum', ...
            [modelName '/Sum_' method], ...
            'Position', [150, y, 180, y+30], ...
            'Inputs', '+-');

        % PID Controller
        add_block('simulink/Continuous/PID Controller', ...
            [modelName '/PID_' method], ...
            'Position', [230, y, 290, y+30], ...
            'Controller', 'PID', ...
            'P', num2str(C.Kp), ...
            'I', num2str(C.Ki), ...
            'D', num2str(C.Kd));

        % Plant (LTI System)
        add_block('cstblocks/LTI System', ...
            [modelName '/Plant_' method], ...
            'Position', [340, y, 450, y+30], ...
            'sys', 'G');

        % To Workspace
        add_block('simulink/Sinks/To Workspace', ...
            [modelName '/Output_' method], ...
            'Position', [500, y, 600, y+30], ...
            'VariableName', ['Y_' method '_M1'], ...
            'SaveFormat', 'Timeseries');

        % Connect blocks
        add_line(modelName, 'Setpoint/1', ['Sum_' method '/1']);
        add_line(modelName, ['Sum_' method '/1'], ['PID_' method '/1']);
        add_line(modelName, ['PID_' method '/1'], ['Plant_' method '/1']);
        add_line(modelName, ['Plant_' method '/1'], ['Output_' method '/1']);

        % Feedback line
        add_line(modelName, ['Plant_' method '/1'], ['Sum_' method '/2'], ...
            'autorouting', 'on');
    end

    % Save model
    save_system(modelName);
    fprintf('Created %s.slx\n', modelName);
end

function create_model_M2(G, C_ZN, C_AMIGO, C_SIMC)
    % Create new Simulink model for M2
    modelName = 'LAB3_M2_ClosedLoop';

    close_system(modelName, 0);
    new_system(modelName);
    open_system(modelName);

    % Add blocks - similar structure as M1
    add_block('simulink/Sources/Step', [modelName '/Setpoint'], ...
        'Position', [50, 100, 80, 130], ...
        'Time', '1', 'Before', '0', 'After', '1');

    y_pos = [150, 250, 350];
    methods = {'ZN', 'AMIGO', 'SIMC'};
    controllers = {C_ZN, C_AMIGO, C_SIMC};

    for i = 1:3
        method = methods{i};
        C = controllers{i};
        y = y_pos(i);

        add_block('simulink/Math Operations/Sum', ...
            [modelName '/Sum_' method], ...
            'Position', [150, y, 180, y+30], ...
            'Inputs', '+-');

        add_block('simulink/Continuous/PID Controller', ...
            [modelName '/PID_' method], ...
            'Position', [230, y, 290, y+30], ...
            'Controller', 'PID', ...
            'P', num2str(C.Kp), ...
            'I', num2str(C.Ki), ...
            'D', num2str(C.Kd));

        add_block('cstblocks/LTI System', ...
            [modelName '/Plant_' method], ...
            'Position', [340, y, 450, y+30], ...
            'sys', 'G');

        add_block('simulink/Sinks/To Workspace', ...
            [modelName '/Output_' method], ...
            'Position', [500, y, 600, y+30], ...
            'VariableName', ['Y_' method '_M2'], ...
            'SaveFormat', 'Timeseries');

        add_line(modelName, 'Setpoint/1', ['Sum_' method '/1']);
        add_line(modelName, ['Sum_' method '/1'], ['PID_' method '/1']);
        add_line(modelName, ['PID_' method '/1'], ['Plant_' method '/1']);
        add_line(modelName, ['Plant_' method '/1'], ['Output_' method '/1']);
        add_line(modelName, ['Plant_' method '/1'], ['Sum_' method '/2'], ...
            'autorouting', 'on');
    end

    save_system(modelName);
    fprintf('Created %s.slx\n', modelName);
end
