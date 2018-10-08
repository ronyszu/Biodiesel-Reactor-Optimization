function fcns = CSTR_BD(z, FA0, V, FTG0, FBD0, FDG0, FMG0, FGL0)
%Equações do CSTR aplicadas à cinética do Biodiesel
%Variáveis (funções) do sistema de equações
FBD = z(1);
FA = z(2);
FTG = z(3);
FDG = z(4);
FMG = z(5);
FGL = z(6);
F = FA0*32/791.8 + FTG0*872.6/925;  %Vazão em L/min considerando que o V
% não varia com a reação
%Concentrações
CBD = FBD/F;
CA = FA/F;
CTG = FTG/F;
CDG = FDG/F;
CMG = FMG/F;
CGL = FGL/F;
%Constantes das reações
k1 = 0.049; 
k2 = 0.102; 
k3 = 0.218; 
k4 = 1.280;
k5 = 0.239;
k6 = 0.007;
k7 = 7.84e-5;
k8 = 1.58e-5;
%Taxas de reação
rTG  =  -  k1*CTG*CA  +  k2*CDG*CBD  -  k7*CTG*CA^3  +  k8*CGL*CBD^3; 
%Triglicerídeos
rDG = k1*CTG*CA - k2*CDG*CBD - k3*CDG*CA + k4*CMG*CBD;  %Diglicerídeos
rMG  =  k3*CDG*CA  -  k4*CMG*CBD  -  k5*CMG*CA  +  k6*CGL*CBD; 
%Monoglicerídeos
rGL = k5*CMG*CA - k6*CGL*CBD + k7*CTG*CA^3 - k8*CGL*CBD^3;  %Glicerol
%Biodiesel:
rBD  =  k1*CTG*CA  -  k2*CDG*CBD  +  k3*CDG*CA  -  k4*CMG*CBD  +  k5*CMG*CA  - k6*CGL*CBD + 3*k7*CTG*CA^3 - 3*k8*CGL*CBD^3;
rA = -rBD;  %Álcool (Metanol)
%Formulação das equações algébricas
fcns(1) = FBD - FBD0 - V*rBD;
fcns(2) = FTG - FTG0 - V*rTG; 
fcns(3) = FDG - FDG0 - V*rDG;
fcns(4) = FMG - FMG0 - V*rMG;
fcns(5) = FGL - FGL0 - V*rGL;
fcns(6) = FA - FA0 - V*rA;
end