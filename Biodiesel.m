%Rotina para cálculo dos volumes ótimos dos reatores e e da vazão ótima
%de metanol na entrada para a produção de Biodiesel. A vazão de entrada de
%todos os sistemas é de 1,479 mol/h de óleo de soja.
%Casos considerados:
clear all
clc
%Definição das variáveis globais utilizadas
global  Vpfr Vpfrboth VetorDefinidor Ordem


% %Resolução p/ 1 CSTR - CONFIGURACAO 1
% VetorDefinidor = [0 0 1 0];
% Ordem = 1;
% [K, S] = fminsearch(@Otimizador_Central_BD, [8 1]);
% C1VCSTR =K(2)^2;  %Volume do CSTR
% C1A = K(1)^2;  %Vazão de entrada de Metanol
% C1Obj = -S;  %Valor da função objetivo
% 
% 
% %Resolução p/ 1 PFR - CONFIGURACAO 2
% VetorDefinidor = [0 0 0 1];
% Ordem = -1;
% [F, S] = fminsearch(@Otimizador_Central_BD, 50);
% C2VPFR= Vpfr;  %Volume do PFR 
% C2A = F;  %Vazão de entrada de Metanol
% C2Obj = -S;  %Valor da função objetivo
% 
% 
% %Resolução p/  CSTR - CSTR - CONFIGURACAO 3
% VetorDefinidor = [0 0 2 0];
% Ordem = [1 1];
% [K, S] = fminsearch(@Otimizador_Central_BD, [8 1 1]);
% V2CSTR(1) = K(2)^2;  %Volume do 1o CSTR
% V2CSTR(2) = K(3)^2;  %Volume do 2o CSTR
% FA02CSTR = K(1)^2;  %Vazão de entrada de Metanol
% Obj2CSTR = -S;  %Valor da função objetivo
% 
% 
% %Resolução p/ CSTR - PFR  - CONFIGURACAO 4
% VetorDefinidor = [0 0 1 1]; %vai funcionar por enquanto, pois na rotina do otimizador, CSTR está antes do PFR, mas e depois para fazer ao contrário?
% Ordem = [1 -1]; %define ordem, onde -1 é PFR, 1 é CSR , e misturador e separador?
% [K, S] = fminsearch(@Otimizador_Central_BD, [8 1]);
% VBothCSTR = K(2)^2;  %Volume do CSTR
% VBothPFR = Vpfrboth;  %Volume do PFR
% FA0Both = K(1)^2;  %Vazão de entrada de Metanol
% ObjBoth = -S;  %Valor da função objetivo
% 
% 
% %Resolução p/ PFR - CSTR  - CONFIGURACAO 5
% VetorDefinidor = [0 0 1 1]; 
% Ordem = [-1 1]; %define ordem, onde -1 é PFR, 1 é CSTR , e misturador e separador?
% [K, S] = fminsearch(@Otimizador_Central_BD, [8 1]);
% VBothCSTR = K(2)^2;  %Volume do CSTR
% VBothPFR = Vpfrboth;  %Volume do PFR
% FA0Both = K(1)^2;  %Vazão de entrada de Metanol
% ObjBoth = -S;  %Valor da função objetivo

%Resolução p/ (CSTR) - (CSTR)  - CONFIGURACAO 6
VetorDefinidor = [1 1 2 0]; %separador,misturador,cstr e pfr
Ordem = [15 1 1 25]; %define ordem, onde -1 é PFR, 1 é CSR , 20 ou 25 misturador 10 ou 15 separador?
[K, S] = fminsearch(@Otimizador_Central_BD, [8 1 1]);
V2CSTR(1) = K(2)^2;  %Volume do 1o CSTR
V2CSTR(2) = K(3)^2;  %Volume do 2o CSTR
FA02CSTR = 2*K(1)^2;  %Vazão de entrada de Metanol
Obj2CSTR = -S;  %Valor da função objetivo









clc
%Exibição dos valores obtidos na Command Window
disp('Os valores de volumes (L), vazão ótima de metanol  na entrada (mol/h) função objetivo otimizados dos reatores,')
disp(' foram calculados, para a produção de Biodiesel, com vazão inicial de 1,479 mols/h de óleo. ')
disp(' ')
disp(' ')
disp('Para 1 reator CSTR, o volume ótimo é de:')
disp(C1VCSTR)
disp('a vazão de metanol ótima é:')
disp(C1A)
disp('e a função objetivo vale:')
disp(C1Obj)
disp('-------------------------------------------------------------------------------------')
