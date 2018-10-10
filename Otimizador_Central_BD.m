function S = Otimizador_Central_BD(K)
%Otimizador de todas as configuracoes escolhidas - superestrutura

%Definição das variáveis globais utilizadas
global Vpfrboth Vpfr VetorDefinidor Ordem

%Vetor que Define quais nós da superestrutura passará
%VetorDefinidor = [Separador,Misturador,CSTR,PFR] (aumentar ao incrementar complexidade das estruturas)


%------------- Parâmetros de entrada do sistema
% mudar pra permitir variacoes nos calculos destes valores (ver na minha rotina principal)

FBD0 = 0;  %Não há alimentação de Biodiesel
FTG0 = 1.479;%Alimentação de Óleo de Soja
FDG0 = 0;  %Não há alimentação de diglicerídeos
FMG0 = 0;  %Não há alimentação de monoglicerídeos
FGL0 = 0;  %Não há alimentação de glicerol


for ordem = Ordem
    
    switch ordem
        %--------------------------------Separador
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
                x=0.333; %fracao que vai para corrente superior
                y=0.333; %fracao que vai para corrente do meio
                
                FS=x*F;
                FM=y*F;
                FI=F-FM-FS;
                
                FF= [FS,FM,FI,Xbd,Xa,Xtg,Xdg,Xmg,Xgli];
            end
            
            %--------------------------------Misturador
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
            
            %--------------------------------CSTR
            
        case 1
            
            if VetorDefinidor(3)
                
                %Configuração dos parâmetros de resolução das equações do CSTR
                options = optimset(@fsolve);
                options.MaxIter = 1e3;  %Máximo de iterações
                options.MaxFunEvals = 1e3;  %Máximo de evaluations por iteração
                
                %Definição do volume a partir da variável auxiliar de otimização "K"
                V(1) = K(2)^2;
                
                if VetorDefinidor(3)>1
                    
                    V(2)= K(3)^2;
                end
                if VetorDefinidor(3)>2
                    
                    V(3)= K(4)^2;
                end
                
                
                
                %Definição da vazão de entrada de Metanol a partir  da variável auxiliar de otimização "K"
                FA0 = K(1)^2;
                %Chute inicial
                x0 = [0.9*FA0 0.1*FA0 0.1*FTG0 0 0 0.9*FTG0];
                %Resolução das equações do CSTR
                f = fsolve(@CSTR_BD, x0, options, FA0, V(1), FTG0, FBD0, FDG0, FMG0, FGL0);
                %Valores das vazões após resolução das equações do CSTR
                FBD = f(1);
                FA = f(2);
                FTG = f(3);
                FDG = f(4);
                FMG = f(5);
                FGL = f(6);
                
                if VetorDefinidor(3)>1
                    
                    %Resolução das equações do segundo CSTR
                    f = fsolve(@CSTR_BD, x0, options, FA, V(2), FTG, FBD, FDG, FMG, FGL);
                    %Valores finais das vazões após resolução dos dois reatores
                    FBD = f(1);
                    FA = f(2);
                    FTG = f(3);
                    FDG = f(4);
                    FMG = f(5);
                    FGL = f(6);
                    
                    
                end
                
                
                
            end
            
            %--------------------------------PFR
            
            
        case -1
            
            if VetorDefinidor(4)
                
                if Ordem(1)==-1 % se só tiver PFR
                    FA0=K(1);  %se botar ao quadrado nao converge o PFR sozinho
                    
                end
                
                %Vazão volumétrica total (L/min)
                Q =FA0*32/791.8 + FTG0*872.6/925;
                %Vazao de entrada de TG em L/min
                QTG0 = FTG0*872.6/924;
                %Vazão de entrada de Metanol de 6:1 mols de TG em L/min:
                QA0 = FTG0*6*32/791.8;
                %Considerando o tempo de residência para esta reação
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
                
                
                
                %Concentrações
                CBD0 = FBD0/Q;
                CA0 = FA0/Q;
                CTG0 = FTG0/Q;
                CDG0 = FDG0/Q;
                CMG0 = FMG0/Q;
                CGL0 = FGL0/Q;
                %Considerando que o volume máximo do reator PFR é um quarto
                % do reator CSTR operando em batelada
                Vmaxpfr = Vmax/4;
                
                if Ordem(1)==1
                    %Redefinindo o VmaxPFR a partir do volume já encontrado para o CSTR
                    Vmaxpfr = Vmaxpfr - V(1)/4;
                    %Redefine caso ultrapasse o limite inferior estipulado (0.1)
                    if Vmaxpfr < 0.1
                        Vmaxpfr = 0.1;
                    end
                end
                
                
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
                
                
                
                
            end
            
    end
    end
    %---------------------------------------------------------Funcao Objetivo Final
    
    %%Outras funções objetivo possíveis (conversão, seletividade, média...)
    %S = ( FBD./(FMG + FDG + FBD)).*(1-FTG./FTG0);
    %S = (( FBD./(FMG + FDG + FBD))+(1-FTG./FTG0))./2;
    %S = (1-FTG./FTG0);
    %Cálculo da função objetivo
    S = ( FBD./(FMG + FDG + FBD));
    
    
    %--------------------------------------Obj BOTH
    if (VetorDefinidor(3) && VetorDefinidor(4))
        
        if Ordem(1)==1 %CSTR antes de PFR
        
        
        %Obtenção do máximo valor da função objetivo
        [Smax, I] = max(S);
        %Valor final do PFR
        Vpfrboth = V(I);
        S = -Smax;  %Inversão da função objetivo, para que seja _minimizada
        
        
        %Soma dos volumes obtidos
        Vtotal = K(2)^2+ Vpfrboth;
        %Se ultrapassar o Vmax estipulado, explode função objetivo
        if Vtotal> Vmax || K(1)^2 > 1.025429326973434e+002
            S = inf;
        end
        
        
        elseif Ordem(1)==-1 %PFR antes de CSTR
            
        
           
        %Calculando a vazao de entrada de TG em L/min
        QTG0 = FTG0*872.6/924;
        %Calculando uma vazão de entrada de Metanol de 6 mols pra 1 de TG em L/min:
        QA0 = FTG0*6*32/791.8;
        %Considerando o tempo de residência para esta reação
        % de 60 minutos em batelada
        Vmax = (QTG0+QA0)*60;
               
         %Obtenção do máximo valor da função objetivo
        [Smax, I] = max(S);
        Vpfr = V(I);  %Volume em que ocorre o máximo da função objetivo
        S = -Smax;  %Inversão da função objetivo, para que seja _minimizada
        
        
         Vtotal = V(1) + Vpfr;
        
         %Se ultrapassar o Vmax estipulado, explode função objetivo
        if Vtotal > Vmax
            S = inf;
        end
        
        %Se ultrapassar o limite estipulado, explode função objetivo
        if FA0 > 1.025429326973434e+002
            S = inf;
        end
                
        end
    end
    
    
    
    
    %-----------------------------------------Obj PFR
    
    if VetorDefinidor(4) && VetorDefinidor(3)==0
        
        %Obtenção do máximo valor da função objetivo
        [Smax, I] = max(S);
        Vpfr = V(I);  %Volume em que ocorre o máximo da função objetivo
        S = -Smax;  %Inversão da função objetivo, para que seja _minimizada
        
        
        %Se ultrapassar o limite estipulado, explode função objetivo
        if FA0 > 1.025429326973434e+002
            S = inf;
        end
    end
    %-----------------------------------------Obj CSTR
    
    if VetorDefinidor(3) && VetorDefinidor(4)==0
        S = -S;  %Inversão da função objetivo, para que seja _minimizada_
        %Calculando a vazao de entrada de TG em L/min
        QTG0 = FTG0*872.6/924;
        %Calculando uma vazão de entrada de Metanol de 6 mols pra 1 de TG em L/min:
        QA0 = FTG0*6*32/791.8;
        %Considerando o tempo de residência para esta reação
        % de 60 minutos em batelada
        Vmax = (QTG0+QA0)*60;
        %Se ultrapassar o Vmax estipulado, explode função objetivo
        
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