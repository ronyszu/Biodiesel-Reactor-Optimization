function df= PFR_BD(V,F)
%Equações do PFR aplicadas à cinética do Biodiesel
%Variáveis (funções) do sistema de EDOs
CBD = F(1);
CA = F(2);
CTG = F(3);
CDG = F(4);
CMG = F(5);
CGL = F(6);
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
rTG = -k1*CTG*CA + k2*CDG*CBD - k7*CTG*CA^3 + k8*CGL*CBD^3; %Triglicerídeos
rDG = k1*CTG*CA - k2*CDG*CBD - k3*CDG*CA + k4*CMG*CBD;  %Diglicerídeos
rMG  =  k3*CDG*CA  -  k4*CMG*CBD  -  k5*CMG*CA  +  k6*CGL*CBD; 
%Monoglicerídeos
rGL = k5*CMG*CA - k6*CGL*CBD + k7*CTG*CA^3 - k8*CGL*CBD^3;  %Glicerol
%Biodiesel:
rBD  =  k1*CTG*CA  -  k2*CDG*CBD  +  k3*CDG*CA  -  k4*CMG*CBD  +  k5*CMG*CA  - k6*CGL*CBD + 3*k7*CTG*CA^3 - 3*k8*CGL*CBD^3;
rA = -rBD;  %Álcool (Metanol)
%Formulação das equações diferenciais
df(1,:) = rBD;
df(2,:) = rA;
df(3,:) = rTG;
df(4,:) = rDG;
df(5,:) = rMG;
df(6,:) = rGL;
end