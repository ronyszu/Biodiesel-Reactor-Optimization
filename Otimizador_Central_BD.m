function S = Otimizador_Central_BD(K)
%Otimizador de todas as configuracoes escolhidas - superestrutura

%Defini��o das vari�veis globais utilizadas
global Vpfrboth Vpfr VetorDefinidor Ordem

%Vetor que Define quais n�s da superestrutura passar�
%VetorDefinidor = [Separador,Misturador,CSTR,PFR] (aumentar ao incrementar complexidade das estruturas)


%------------- Par�metros de entrada do sistema
% mudar pra permitir variacoes nos calculos destes valores (ver na minha rotina principal)

FBD0 = 0;  %N�o h� alimenta��o de Biodiesel
FTG0 = 1.479;%Alimenta��o de �leo de Soja
FDG0 = 0;  %N�o h� alimenta��o de diglicer�deos
FMG0 = 0;  %N�o h� alimenta��o de monoglicer�deos
FGL0 = 0;  %N�o h� alimenta��o de glicerol


for ordem = Ordem
    
    switch ordem
        %--------------------------------Separador de 3 correntes
        case 10 %definir separador na Ordem depois
            if VetorDefinidor(1)
                F = FBD0+FTG0+FDG0+FMG0+FGL0;
                
                %composicoes da mistura inicial
                Xbd= FBD0/F;
                Xa= FA0/F;
                Xtg= FTG0/F;
                Xdg= FDG0/F;
                Xmg= FMG0/F;
                Xgli= FGL0/F;
                
                %divisao das correntes
                %dois graus de liberdade a serem determinados:
                x=0.333333; %fracao que vai para corrente superior
                y=0.333333; %fracao que vai para corrente do meio
                
                FS=x*F;
                FM=y*F;
                FI=F-FM-FS;
                
                FBD0 = 0.333333*FBD0;  
                FTG0 = 0.333333*FTG0;
                FDG0 = 0.333333*FDG0; 
                FMG0 = 0.333333*FMG0;  
                FGL0 = 0.333333*FGL0;  
                
                FF3= [FBD0,FTG0,FMG0,FDG0,FGL0,Xbd,Xa,Xtg,Xdg,Xmg,Xgli];
                %FF3= [FS,FM,FI,Xbd,Xa,Xtg,Xdg,Xmg,Xgli];
            end
             %--------------------------------Separador de 2 correntes
        case 15 %definir separador na Ordem depois
            if VetorDefinidor(1)
                F = FBD0+FTG0+FDG0+FMG0+FGL0;
                
                %composicoes da mistura inicial
                Xbd= FBD0/F;
               % Xa= FA0/F;
                Xtg= FTG0/F;
                Xdg= FDG0/F;
                Xmg= FMG0/F;
                Xgli= FGL0/F;
                
                %divisao das correntes
                %um grau de liberdade a ser determinado:
                x=0.5; %fracao que vai para corrente superior
                
                FS=x*F;
                FI=F-FS;
                
                FBD0 = 0.5*FBD0;  
                FTG0 = 0.5*FTG0;
                FDG0 = 0.5*FDG0; 
                FMG0 = 0.5*FMG0;  
                FGL0 = 0.5*FGL0; 
                
                FF2= [FBD0,FTG0,FMG0,FDG0,FGL0,Xbd,Xtg,Xdg,Xmg,Xgli];
                %FF2= [FS,FI,Xbd,Xa,Xtg,Xdg,Xmg,Xgli];
            end
            
            %--------------------------------Misturador de 3 correntes
        case 20 %definir misturador na Ordem depois
            
            if VetorDefinidor(2)
                %Entrada
                FS= FBDs+FAs+FTGs+FDGs+FMGs+FGLs;
                FM= FBDm+FAm+FTGm+FDGm+FMGm+FGLm;
                FI= FBDi+FAi+FTGi+FDGi+FMGi+FGLi;
                
                %BMG
                F = FS+FM+FI;
                
                Xbds= FBDs/FS;
                Xas= FAs/FS;
                Xtgs= FTGs/FS;
                Xdgs= FDGs/FS;
                Xmgs= FMGs/FS;
                Xglis= FGLs/FS;
                %--------------
                Xbdm= FBDm/FM;
                Xam= FAm/FM;
                Xtgm= FTGm/FM;
                Xdgm= FDGm/FM;
                Xmgm= FMGm/FM;
                Xglim= FGLm/FM;
                %--------------
                Xbdi= FBDi/FI;
                Xai= FAi/FI;
                Xtgi= FTGi/FI;
                Xdgi= FDGi/FI;
                Xmgi= FMGi/FI;
                Xglii= FGLi/FI;
                
                %BMCs
                Xbd= (FS*Xbds + FM*Xbdm + FI*Xbdi)/F;
                Xa= (FS*Xas + FM*Xam + FI*Xai)/F;
                Xtg= (FS*Xtgs + FM*Xtgm + FI*Xtgi)/F;
                Xdg= (FS*Xdgs + FM*Xdgm + FI*Xdgi)/F;
                Xmg= (FS*Xmgs + FM*Xmgm + FI*Xmgi)/F;
                Xgli= (FS*Xglis + FM*Xglim + FI*Xglii)/F;
                
                %Saida
                FF=[F*Xbd,F*Xa,F*Xtg,F*Xdg,F*Xmg,F*Xgli];
            end
               %--------------------------------Misturador de 2 correntes
        case 25 %definir misturador na Ordem depois
            
            if VetorDefinidor(2)
                %Entrada
                F1= FBD1+FA1+FTG1+FDG1+FMG1+FGL1;
                F2= FBD2+FA2+FTG2+FDG2+FMG2+FGL2;
                
                %BMG
                F = F1+F2;
                
                Xbd1= FBD1/F1;
                Xa1= FA1/F1;
                Xtg1= FTG1/F1;
                Xdg1= FDG1/F1;
                Xmg1= FMG1/F1;
                Xgli1= FGL1/F1;
                %--------------
                Xbd2= FBD2/F2;
                Xa2= FA2/F2;
                Xtg2= FTG2/F2;
                Xdg2= FDG2/F2;
                Xmg2= FMG2/F2;
                Xgli2= FGL2/F2;
                
                %BMCs
                Xbd= (F1*Xbd1 + FI*Xbd2)/F;
                Xa= (F1*Xa1  + FI*Xa2)/F;
                Xtg= (F1*Xtg1 + FI*Xtg2)/F;
                Xdg= (F1*Xdg1 + FI*Xdg2)/F;
                Xmg= (F1*Xmg1 + FI*Xmg2)/F;
                Xgli= (F1*Xgli1 + FI*Xgli2)/F;
                
                %Saida
                FF=[F*Xbd,F*Xa,F*Xtg,F*Xdg,F*Xmg,F*Xgli];
            end
            %--------------------------------CSTR
            
        case 1
            
            if VetorDefinidor(3)
                
                %Configura��o dos par�metros de resolu��o das equa��es do CSTR
                options = optimset(@fsolve);
                options.MaxIter = 1e3;  %M�ximo de itera��es
                options.MaxFunEvals = 1e3;  %M�ximo de evaluations por itera��o
                
                %Defini��o do volume a partir da vari�vel auxiliar de otimiza��o "K"
                V(1) = K(2)^2;
                
                if VetorDefinidor(3)>1
                    
                    V(2)= K(3)^2;
                end
                if VetorDefinidor(3)>2
                    
                    V(3)= K(4)^2;
                end
                
                
                
                %Defini��o da vaz�o de entrada de Metanol a partir  da vari�vel auxiliar de otimiza��o "K"
                FA0 = K(1)^2;
                %Chute inicial
                x0 = [0.9*FA0 0.1*FA0 0.1*FTG0 0 0 0.9*FTG0];
                %Resolu��o das equa��es do CSTR
                f = fsolve(@CSTR_BD, x0, options, FA0, V(1), FTG0, FBD0, FDG0, FMG0, FGL0);
                %Valores das vaz�es ap�s resolu��o das equa��es do CSTR
                FBD = f(1);
                FA = f(2);
                FTG = f(3);
                FDG = f(4);
                FMG = f(5);
                FGL = f(6);
                
                if VetorDefinidor(3)>1 && Ordem(1) ~=15
                    
                    %Resolu��o das equa��es do segundo CSTR em serie
                    f = fsolve(@CSTR_BD, x0, options, FA, V(2), FTG, FBD, FDG, FMG, FGL);
                    %Valores finais das vaz�es ap�s resolu��o dos dois reatores
                    FBD = f(1);
                    FA = f(2);
                    FTG = f(3);
                    FDG = f(4);
                    FMG = f(5);
                    FGL = f(6);
                    
                    
                end
                
                
                if Ordem(1)==15 && Ordem(2)==1
                    %Salva resultado para futuro
                    FBD1 = FBD;
                    FA1 = FA;
                    FTG1 = FTG;
                    FDG1 = FDG;
                    FMG1 = FMG;
                    FGL1 = FGL;
                                   
                    Ordem(2) = 99;
                    
                end
                
                if Ordem(1)==15 && Ordem(2) ~= 1  && Ordem(3)==1
                    
                    FBD2 = FBD;
                    FA2 = FA;
                    FTG2 = FTG;
                    FDG2 = FDG;
                    FMG2 = FMG;
                    FGL2 = FGL;
                    
                    Ordem(2) = 1;
                end
                
            end
            
            %--------------------------------PFR
            
            
        case -1
            
            if VetorDefinidor(4)
                
                if Ordem(1)==-1 % se s� tiver PFR
                    FA0=K(1);  %se botar ao quadrado nao converge o PFR sozinho
                    
                end
                
                %Vaz�o volum�trica total (L/min)
                Q =FA0*32/791.8 + FTG0*872.6/925;
                %Vazao de entrada de TG em L/min
                QTG0 = FTG0*872.6/924;
                %Vaz�o de entrada de Metanol de 6:1 mols de TG em L/min:
                QA0 = FTG0*6*32/791.8;
                %Considerando o tempo de resid�ncia para esta rea��o
                % de 60 minutos em batelada
                Vmax = (QTG0+QA0)*60;
                
                
                
                if Ordem(1)==1
                    FBD0=FBD;
                    FA0=FA;
                    FTG0=FTG;
                    FDG0=FDG;
                    FMG0=FMG;
                    FGL0=FGL;
                    
                end
                
                
                
                %Concentra��es
                CBD0 = FBD0/Q;
                CA0 = FA0/Q;
                CTG0 = FTG0/Q;
                CDG0 = FDG0/Q;
                CMG0 = FMG0/Q;
                CGL0 = FGL0/Q;
                %Considerando que o volume m�ximo do reator PFR � um quarto
                % do reator CSTR operando em batelada
                Vmaxpfr = Vmax/4;
                
                if Ordem(1)==1
                    %Redefinindo o VmaxPFR a partir do volume j� encontrado para o CSTR
                    Vmaxpfr = Vmaxpfr - V(1)/4;
                    %Redefine caso ultrapasse o limite inferior estipulado (0.1)
                    if Vmaxpfr < 0.1
                        Vmaxpfr = 0.1;
                    end
                end
                
                
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
                
                
                
                
            end
            
    end
end
%---------------------------------------------------------Funcao Objetivo Final

%%Outras fun��es objetivo poss�veis (convers�o, seletividade, m�dia...)
%S = ( FBD./(FMG + FDG + FBD)).*(1-FTG./FTG0);
%S = (( FBD./(FMG + FDG + FBD))+(1-FTG./FTG0))./2;
%S = (1-FTG./FTG0);


if Ordem(1)==15 || Ordem(1)==10

   FBD=FF(1);
   FMG=FF(3);
   FDG=FF(4);
    
end
%C�lculo da fun��o objetivo
S = ( FBD./(FMG + FDG + FBD));


%--------------------------------------Obj BOTH
if (VetorDefinidor(3) && VetorDefinidor(4))
    
    if Ordem(1)==1 %CSTR antes de PFR
        
        
        %Obten��o do m�ximo valor da fun��o objetivo
        [Smax, I] = max(S);
        %Valor final do PFR
        Vpfrboth = V(I);
        S = -Smax;  %Invers�o da fun��o objetivo, para que seja _minimizada
        
        
        %Soma dos volumes obtidos
        Vtotal = K(2)^2+ Vpfrboth;
        %Se ultrapassar o Vmax estipulado, explode fun��o objetivo
        if Vtotal> Vmax || K(1)^2 > 1.025429326973434e+002
            S = inf;
        end
        
        
    elseif Ordem(1)==-1 %PFR antes de CSTR
        
        
        
        %Calculando a vazao de entrada de TG em L/min
        QTG0 = FTG0*872.6/924;
        %Calculando uma vaz�o de entrada de Metanol de 6 mols pra 1 de TG em L/min:
        QA0 = FTG0*6*32/791.8;
        %Considerando o tempo de resid�ncia para esta rea��o
        % de 60 minutos em batelada
        Vmax = (QTG0+QA0)*60;
        
        %Obten��o do m�ximo valor da fun��o objetivo
        [Smax, I] = max(S);
        Vpfr = V(I);  %Volume em que ocorre o m�ximo da fun��o objetivo
        S = -Smax;  %Invers�o da fun��o objetivo, para que seja _minimizada
        
        
        Vtotal = V(1) + Vpfr;
        
        %Se ultrapassar o Vmax estipulado, explode fun��o objetivo
        if Vtotal > Vmax
            S = inf;
        end
        
        %Se ultrapassar o limite estipulado, explode fun��o objetivo
        if FA0 > 1.025429326973434e+002
            S = inf;
        end
        
    end
end




%-----------------------------------------Obj PFR

if VetorDefinidor(4) && VetorDefinidor(3)==0
    
    %Obten��o do m�ximo valor da fun��o objetivo
    [Smax, I] = max(S);
    Vpfr = V(I);  %Volume em que ocorre o m�ximo da fun��o objetivo
    S = -Smax;  %Invers�o da fun��o objetivo, para que seja _minimizada
    
    
    %Se ultrapassar o limite estipulado, explode fun��o objetivo
    if FA0 > 1.025429326973434e+002
        S = inf;
    end
end
%-----------------------------------------Obj CSTR

if VetorDefinidor(3) && VetorDefinidor(4)==0
    S = -S;  %Invers�o da fun��o objetivo, para que seja _minimizada_
    %Calculando a vazao de entrada de TG em L/min
    
    if Ordem(1)==15 
       FTG0 = 2*FTG0; 
    end
    
    QTG0 = FTG0*872.6/924;
    %Calculando uma vaz�o de entrada de Metanol de 6 mols pra 1 de TG em L/min:
    QA0 = FTG0*6*32/791.8;
    %Considerando o tempo de resid�ncia para esta rea��o
    % de 60 minutos em batelada
    Vmax = (QTG0+QA0)*60;
    %Se ultrapassar o Vmax estipulado, explode fun��o objetivo
    
    Vtotal = V(1);
    
    if VetorDefinidor(3)==2
        Vtotal = V(1)+V(2);
    end
    
    if VetorDefinidor(3)==3
        Vtotal = V(1)+V(2)+V(3);
    end
    
    
    if Vtotal > Vmax
        S = inf;
    end
    
end



end