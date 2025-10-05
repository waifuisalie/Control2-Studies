step_time = 1;
initial_value = 0;
final_value = 1;

d1_step_time = 0;
d1_initial_value = 0;
d1_final_value = 0;

d2_step_time = 0;
d2_initial_value = 0;
d2_final_value = 0;
   

s = tf('s');
M = 1 / ((s+1)*(0.4*s+1)*((0.4^2)*s+1)*((0.4^3)*s+1));
M.InputDelay = 1;

% fi = 1.1
% Ts = 6
% portanto T = 6/4 = 3/2
atraso_pade = (1-(1.1/2)*s)/(1+(1.1/2)*s);
G = 1 /(((3/2)*s) + 1);
G1_atraso = G * atraso_pade;

%Modelo Toolbox 1º Ordem
GTB1 = tf1_ordem;

%Modelo Toolbox 2º Ordem
GTB2 = tf2_ordem;

simout = sim("lab2_malha_aberta.slx"); 

figure; 
hold on; 
plot(simout.U.Time, simout.U.Data, 'DisplayName', 'Entrada Degrau (U)'); %Sinal Degrau
plot(simout.Y.Time, simout.Y.Data, 'DisplayName', 'Saída Original M (out.Y)'); % Sinal Original M 
plot(simout.G1_atraso.Time, simout.G1_atraso.Data, 'DisplayName', 'Saída G 1ª Ordem Atrasada'); 
hold off; 
legend show; 
xlabel('Tempo'); 
ylabel('Dados');
title('Comparação das Saídas da Simulação entre M (out.Y) e G 1ª Ordem com Atraso');

figure; 
hold on; 
plot(simout.U.Time, simout.U.Data, 'DisplayName', 'Entrada Degrau (U)'); 
plot(simout.Y.Time, simout.Y.Data, 'DisplayName', 'Sinal Original M (out.Y)'); 
plot(simout.GTB1.Time, simout.GTB1.Data, 'DisplayName', 'Saída do Modelo 1ª Ordem (GTB1)'); 
hold off; 
legend show; 
xlabel('Tempo'); 
ylabel('Dados');
title('Saídas da Simulação do ToolBox de 1ª Ordem com U e Y originais');

figure; 
hold on; 
plot(simout.U.Time, simout.U.Data, 'DisplayName', 'Entrada Degrau (U)'); 
plot(simout.Y.Time, simout.Y.Data, 'DisplayName', 'Sinal Original M (out.Y)'); 
plot(simout.GTB2.Time, simout.GTB2.Data, 'DisplayName', 'Saída do Modelo 2º Ordem (GTB2)'); 
hold off; 
legend show;
xlabel('Tempo'); 
ylabel('Dados');
title('Saídas da Simulação do ToolBox de 2ª Ordem com U e Y originais');

% Calculando o Erro Médio Quadrático (RMSE)
erro = simout.Y.Data - simout.G1_atraso.Data; % Calcula o erro
rmse= sqrt(mean(erro.^2)); % Calcula o RMSE
disp(['RMSE para G1_atraso: ', num2str(rmse)]);

erro = simout.Y.Data - simout.GTB1.Data;
rmse = sqrt(mean(erro.^2)); 
disp(['RMSE para GTB1: ', num2str(rmse)]);

erro = simout.Y.Data - simout.GTB2.Data; 
rmse = sqrt(mean(erro.^2)); 
disp(['RMSE para GTB2: ', num2str(rmse)]);

%Calculando o IAE 
iae = trapz(simout.U.Time, abs(simout.Y.Data - simout.G1_atraso.Data)); % Calcula o IAE
disp(['IAE para G1_atraso: ', num2str(iae)]);

iae = trapz(simout.U.Time, abs(simout.Y.Data - simout.GTB1.Data)); 
disp(['IAE para GTB1: ', num2str(iae)]);

iae = trapz(simout.U.Time, abs(simout.Y.Data - simout.GTB2.Data)); 
disp(['IAE para GTB2: ', num2str(iae)]);


% Calculando a Variação Total
total_variation_G1_atraso = sum(abs(diff(simout.G1_atraso.Data))); % Calcula a variação total para G1_atraso
disp(['Variação Total para G1_atraso: ', num2str(total_variation_G1_atraso)]);

total_variation_GTB1 = sum(abs(diff(simout.GTB1.Data))); % Calcula a variação total para GTB1
disp(['Variação Total para GTB1: ', num2str(total_variation_GTB1)]);

total_variation_GTB2 = sum(abs(diff(simout.GTB2.Data))); % Calcula a variação total para GTB2
disp(['Variação Total para GTB2: ', num2str(total_variation_GTB2)]);
