clear
close all
clc
%% Constantes del proceso
a = 15.52;      % Seccion transversal de los tanques (cm^2)
b = 0.178;      % Seccion transversal de los agujero (cm^2)
g = 981;                % Aceleracion de la gravedad (cm/s^2)

%h1b = 15; h2b = 15; h3b = 15; h4b = 15;    % Alturas hi de linealizacion
kc = 1;     % Ganancias de los sensores
kp = 3.3;   % Constantes de las bombas (cm^3/sV)

gamma1 = 0.65; gamma2 = 0.6;

%% Determinacion del punto de equilibrio
h2b = 10;%input('Ingrese el punto de trabajo en h2:');
h4b = 10;%input('Ingrese el punto de trabajo en h4:');
% Primera opcion
M = b*sqrt(2*g);
Ab = [ -M    0      0        (1-gamma2)*kp 
        M    0   gamma1*kp         0
        0   -M  (1-gamma1)*kp      0
        0    M      0         gamma2*kp ];
bb = [0; M*sqrt(h2b); 0; M*sqrt(h4b)];

xb = Ab\bb;    % x = [sqrt(h1b); sqrt(h2b); v1; v2]

h1b = xb(1)^2;
h3b = xb(2)^2;
v1b = xb(3);
v2b = xb(4);
% Segunda opcion
% Abb = [  gamma1*kp    (1-gamma2)*kp
%        (1-gamma1)*kp     gamma2*kp  ];
% bbb = [b*sqrt(2*g*h2b); b*sqrt(2*g*h4b)];
% xbb = Abb\bbb;
    
%% Matrices de estado
T1 = (a/b)*sqrt(2*h1b/g); T2 = (a/b)*sqrt(2*h2b/g);
T3 = (a/b)*sqrt(2*h3b/g); T4 = (a/b)*sqrt(2*h4b/g);
A = [ -1/T1      0      0      0
      -1/T1  -1/T2     0      0 
        0        0    -1/T3    0
        0        0    -1/T3 -1/T4 ];
    
B = [       0         (1-gamma2)*kp/a
       gamma1*kp/a           0
     (1-gamma1)*kp/a         0
            0            gamma2*kp/a  ];
       
C = [ 0   kc  0   0
      0   0   0   kc];
  
D = [ 0  0
      0  0 ];

sys = ss(A,B,C,D);
step(sys)

%% Funcion de transferencia del sistema MIMO
s = tf('s');
I = eye(4);
G = C*inv(s*I-A)*B;

% G11 = kp*kc*gamma1/(a*(s+1/T2));
% G12 = -kp*kc*(1-gamma2)/(a*T1*(s+1/T1)*(s+1/T2));
% G21 = -kp*kc*(1-gamma1)/(a*T3*(s+1/T3)*(s+1/T4));
% G22 = kp*kc*gamma2/(a*(s+1/T4));

% Verificacion fase minimo/no minima
rlocus(G(1,1)*G(2,2)-G(2,1)*G(1,2))
zpk(G(1,1)*G(2,2)-G(2,1)*G(1,2))

%% Aplicacion de metodo de Bristol para determinar la matriz de ganancias relativas
% Se hace s = 0 y se obtiene kij
k11 = G(1,1).num{1}(end)/G(1,1).den{1}(end); k12 = G(1,2).num{1}(end)/G(1,2).den{1}(end);
k21 = G(2,1).num{1}(end)/G(2,1).den{1}(end); k22 = G(2,2).num{1}(end)/G(2,2).den{1}(end);
lamda11 = k11*k22/(k11*k22-k12*k21); lamda12 = k12*k21/(k12*k21-k11*k22);
lamda21 = k12*k21/(k12*k21-k11*k22); lamda22 = k11*k22/(k11*k22-k12*k21);
M = [ lamda11  lamda12 
      lamda21  lamda22 ];
%% Matriz de desacople simplicado
d11 = 1;
d12 = -G(1,2)/G(1,1);
d21 = -G(2,1)/G(2,2);
d22 = 1;
D = [ d11  d12
      d21  d22 ];
Q = G*D

%% Nuevas plantas
q11 = 0.13821*(s+0.3713)*(s+0.08287)/((s+0.2869)*(s+0.1673)*(s+0.08032));
q22 = 0.12758*(s+0.3713)*(s+0.08287)/((s+0.2869)*(s+0.1673)*(s+0.08032));