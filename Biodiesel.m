%Rotina para c�lculo dos volumes �timos dos reatores e e da vaz�o �tima
%de metanol na entrada para a produ��o de Biodiesel. A vaz�o de entrada de
%todos os sistemas � de 1,479 mol/h de �leo de soja.
%Casos considerados:
clear all
clc
%Defini��o das vari�veis globais utilizadas
global  Vpfr Vpfrboth VetorDefinidor Ordem


% %Resolu��o p/ 1 CSTR - CONFIGURACAO 1
% VetorDefinidor = [0 0 1 0];
% Ordem = 1;
% [K, S] = fminsearch(@Otimizador_Central_BD, [8 1]);
% C1VCSTR =K(2)^2;  %Volume do CSTR
% C1A = K(1)^2;  %Vaz�o de entrada de Metanol
% C1Obj = -S;  %Valor da fun��o objetivo
% 
% 
% %Resolu��o p/ 1 PFR - CONFIGURACAO 2
% VetorDefinidor = [0 0 0 1];
% Ordem = -1;
% [F, S] = fminsearch(@Otimizador_Central_BD, 50);
% C2VPFR= Vpfr;  %Volume do PFR 
% C2A = F;  %Vaz�o de entrada de Metanol
% C2Obj = -S;  %Valor da fun��o objetivo
% 
% 
% %Resolu��o p/  CSTR - CSTR - CONFIGURACAO 3
% VetorDefinidor = [0 0 2 0];
% Ordem = [1 1];
% [K, S] = fminsearch(@Otimizador_Central_BD, [8 1 1]);
% V2CSTR(1) = K(2)^2;  %Volume do 1o CSTR
% V2CSTR(2) = K(3)^2;  %Volume do 2o CSTR
% FA02CSTR = K(1)^2;  %Vaz�o de entrada de Metanol
% Obj2CSTR = -S;  %Valor da fun��o objetivo
% 
% 
% %Resolu��o p/ CSTR - PFR  - CONFIGURACAO 4
% VetorDefinidor = [0 0 1 1]; %vai funcionar por enquanto, pois na rotina do otimizador, CSTR est� antes do PFR, mas e depois para fazer ao contr�rio?
% Ordem = [1 -1]; %define ordem, onde -1 � PFR, 1 � CSR , e misturador e separador?
% [K, S] = fminsearch(@Otimizador_Central_BD, [8 1]);
% VBothCSTR = K(2)^2;  %Volume do CSTR
% VBothPFR = Vpfrboth;  %Volume do PFR
% FA0Both = K(1)^2;  %Vaz�o de entrada de Metanol
% ObjBoth = -S;  %Valor da fun��o objetivo
% 
% 
% %Resolu��o p/ PFR - CSTR  - CONFIGURACAO 5
% VetorDefinidor = [0 0 1 1]; 
% Ordem = [-1 1]; %define ordem, onde -1 � PFR, 1 � CSTR , e misturador e separador?
% [K, S] = fminsearch(@Otimizador_Central_BD, [8 1]);
% VBothCSTR = K(2)^2;  %Volume do CSTR
% VBothPFR = Vpfrboth;  %Volume do PFR
% FA0Both = K(1)^2;  %Vaz�o de entrada de Metanol
% ObjBoth = -S;  %Valor da fun��o objetivo

%Resolu��o p/ (CSTR) - (CSTR)  - CONFIGURACAO 6
VetorDefinidor = [1 1 2 0]; %separador,misturador,cstr e pfr
Ordem = [15 1 1 25]; %define ordem, onde -1 � PFR, 1 � CSR , 20 ou 25 misturador 10 ou 15 separador?
[K, S] = fminsearch(@Otimizador_Central_BD, [8 1 1]);
V2CSTR(1) = K(2)^2;  %Volume do 1o CSTR
V2CSTR(2) = K(3)^2;  %Volume do 2o CSTR
FA02CSTR = 2*K(1)^2;  %Vaz�o de entrada de Metanol
Obj2CSTR = -S;  %Valor da fun��o objetivo









clc
%Exibi��o dos valores obtidos na Command Window
disp('Os valores de volumes (L), vaz�o �tima de metanol  na entrada (mol/h) fun��o objetivo otimizados dos reatores,')
disp(' foram calculados, para a produ��o de Biodiesel, com vaz�o inicial de 1,479 mols/h de �leo. ')
disp(' ')
disp(' ')
disp('Para 1 reator CSTR, o volume �timo � de:')
disp(C1VCSTR)
disp('a vaz�o de metanol �tima �:')
disp(C1A)
disp('e a fun��o objetivo vale:')
disp(C1Obj)
disp('-------------------------------------------------------------------------------------')
