function S = optimCSTR_BD(K)

global FBD0 FTG0  FDG0  FMG0  FGL0 

%Otimiza��o de CSTRs
%Configura��o dos par�metros de resolu��o das equa��es
options = optimset(@fsolve);
options.MaxIter = 1e3;  %M�ximo de itera��es
options.MaxFunEvals = 1e3;  %M�ximo de evaluations por itera��o


%Defini��o do volume a partir da vari�vel auxiliar de otimiza��o "K1"
V(1)=K(1)^2;
%Defini��o da vaz�o de entrada de Metanol a partir  da vari�vel auxiliar de
%otimiza��o "K2" -> nao deveria ser 6 vezes a vazao de entrada do TG?
FA0 = K(2)^2;

%Chute inicial
x0 = [0.9*FA0 0.1*FA0 0.1*FTG0 0 0 0.9*FTG0];

%Resolu��o das equa��es do CSTR
f = fsolve(@CSTR_BD, x0, options, FA0, V(1), FTG0, FBD0, FDG0, FMG0, FGL0);
%Valores finais das vaz�es ap�s resolu��o das equa��es
FBD = f(1);
FA = f(2);
FTG = f(3);
FDG = f(4);
FMG = f(5);
FGL = f(6);

%%Outras fun��es objetivo poss�veis (convers�o, seletividade, m�dia...)
%S = ( FBD/(FMG + FDG + FBD))*(1-FTG./FTG0);
%C�lculo da fun��o objetivo conversao:
%S = (1-FTG./FTG0);
%S = (( FBD/(FMG + FDG + FBD))+(1-FTG./FTG0))/2;
S = ( FBD./(FMG + FDG + FBD));
S = -S;  %Invers�o da fun��o objetivo, para que seja _minimizada_
%Calculando a vazao de entrada de TG em L/min
QTG0 = FTG0*872.6/924;
%Calculando uma vaz�o de entrada de Metanol de 6 mols pra 1 de TG em L/min:
QA0 = FTG0*6*32/791.8;
%Considerando o tempo de resid�ncia para esta rea��o
% de 60 minutos em batelada
Vmax = (QTG0+QA0)*60; 
%Se ultrapassar o Vmax estipulado, explode fun��o objetivo

if V(1) > Vmax
    S = inf;
end
end