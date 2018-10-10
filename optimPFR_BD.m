function S = optimPFR_BD(FA0)
%Otimiza��o de PFRs

%Defini��o das vari�veis globais utilizadas
global FBD0 FTG0  FDG0  FMG0  FGL0 Vpfr

%Vaz�o volum�trica total (L/min)
Q =FA0*32/791.8 + FTG0*872.6/925;
%Concentra��es
CBD0 = FBD0/Q;
CA0 = FA0/Q;
CTG0 = FTG0/Q;
CDG0 = FDG0/Q;
CMG0 = FMG0/Q;
CGL0 = FGL0/Q;
%Vazao de entrada de TG em L/min
QTG0 = FTG0*872.6/924;
%Vaz�o de entrada de Metanol de 6:1 mols de TG em L/min:
QA0 = FTG0*6*32/791.8;
%Considerando o tempo de resid�ncia para esta rea��o
% de 60 minutos em batelada
Vmax = (QTG0+QA0)*60;
%Considerando que o volume m�ximo do reator PFR � um quarto
% do reator CSTR operando em batelada
Vmaxpfr = Vmax/4;
Vspan=[0 Vmaxpfr];  %Span de resolu��o das EDOs
ic = [CBD0; CA0; CTG0; CDG0; CMG0; CGL0];  %Cond. iniciais
%Configura��o dos par�metros de resolu��o das equa��es
options2 = odeset('MaxStep', 0.1);
%Resolu��o das equa��es diferenciais do PFR
[V,C] = ode45('PFR_BD',Vspan,ic, options2); 
%Valores finais das vaz�es ap�s solu��o das equa��es
FBD = C(:,1).*Q;
FA = C(:,2).*Q;
FTG = C(:,3).*Q;
FDG = C(:,4).*Q;
FMG = C(:,5).*Q;
FGL = C(:,6).*Q; 

%%Outras fun��es objetivo poss�veis (convers�o, seletividade, m�dia...)
%S = ( FBD./(FMG + FDG + FBD)).*(1-FTG./FTG0);
%S = (( FBD./(FMG + FDG + FBD))+(1-FTG./FTG0))./2;
%S = (1-FTG./FTG0);
%C�lculo da fun��o objetivo
S = ( FBD./(FMG + FDG + FBD));
%Obten��o do m�ximo valor da fun��o objetivo
[Smax, I] = max(S);
Vpfr = V(I);  %Volume em que ocorre o m�ximo da fun��o objetivo
S = -Smax;  %Invers�o da fun��o objetivo, para que seja _minimizada_
%Se ultrapassar o limite estipulado, explode fun��oobjetivo
if FA0 > 1.025429326973434e+002
    S = inf; 
end
end