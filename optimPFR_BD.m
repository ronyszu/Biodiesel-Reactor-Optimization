function S = optimPFR_BD(FA0)
%Otimização de PFRs

%Definição das variáveis globais utilizadas
global FBD0 FTG0  FDG0  FMG0  FGL0 Vpfr

%Vazão volumétrica total (L/min)
Q =FA0*32/791.8 + FTG0*872.6/925;
%Concentrações
CBD0 = FBD0/Q;
CA0 = FA0/Q;
CTG0 = FTG0/Q;
CDG0 = FDG0/Q;
CMG0 = FMG0/Q;
CGL0 = FGL0/Q;
%Vazao de entrada de TG em L/min
QTG0 = FTG0*872.6/924;
%Vazão de entrada de Metanol de 6:1 mols de TG em L/min:
QA0 = FTG0*6*32/791.8;
%Considerando o tempo de residência para esta reação
% de 60 minutos em batelada
Vmax = (QTG0+QA0)*60;
%Considerando que o volume máximo do reator PFR é um quarto
% do reator CSTR operando em batelada
Vmaxpfr = Vmax/4;
Vspan=[0 Vmaxpfr];  %Span de resolução das EDOs
ic = [CBD0; CA0; CTG0; CDG0; CMG0; CGL0];  %Cond. iniciais
%Configuração dos parâmetros de resolução das equações
options2 = odeset('MaxStep', 0.1);
%Resolução das equações diferenciais do PFR
[V,C] = ode45('PFR_BD',Vspan,ic, options2); 
%Valores finais das vazões após solução das equações
FBD = C(:,1).*Q;
FA = C(:,2).*Q;
FTG = C(:,3).*Q;
FDG = C(:,4).*Q;
FMG = C(:,5).*Q;
FGL = C(:,6).*Q; 

%%Outras funções objetivo possíveis (conversão, seletividade, média...)
%S = ( FBD./(FMG + FDG + FBD)).*(1-FTG./FTG0);
%S = (( FBD./(FMG + FDG + FBD))+(1-FTG./FTG0))./2;
%S = (1-FTG./FTG0);
%Cálculo da função objetivo
S = ( FBD./(FMG + FDG + FBD));
%Obtenção do máximo valor da função objetivo
[Smax, I] = max(S);
Vpfr = V(I);  %Volume em que ocorre o máximo da função objetivo
S = -Smax;  %Inversão da função objetivo, para que seja _minimizada_
%Se ultrapassar o limite estipulado, explode funçãoobjetivo
if FA0 > 1.025429326973434e+002
    S = inf; 
end
end