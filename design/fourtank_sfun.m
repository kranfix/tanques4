function [sys,x0,str,ts] = fourtank_sfun(t,x,u,flag,h0)
%
% Solves the differential equation modeling
% one tank
% The state is the height in the tank
%
% Use this as an sfun function in a simulink diagram
%
% 22 March 2016
% Josmell Córdova

% process condition:
%    valve opening(Gamma) = [0.7;0.6];
%    voltage (V) = [3;3];
%    xs = hs = ?;
%    x0 = [x1i;x2i;x3i;x4i] = [h1i;h2i;h3i;h4i] = initial condition;

switch flag
    
    case 0 % initialization;
        
        sizes = simsizes;
        sizes.NumContStates = 4;
        sizes.NumDiscStates = 0;
        sizes.NumOutputs    = 4;
        sizes.NumInputs     = 2;
        sizes.DirFeedthrough = 0;
        sizes.NumSampleTimes = 1;
        sys = simsizes(sizes);
        
        str = [];
        ts = [0 0];
        x0 = h0 ;
        
    case 1 % derivatives;
        
        % it is convenient to use common notation for states
        
        h1 = x(1);
        h2 = x(2);
        h3 = x(3);
        h4 = x(4);
        
        % also, the inputs are
        
        v1 = u(1);
        v2 = u(2);
        
        % parameter values
        
        A1 = 15.52; A2 = 15.52;A3 = 15.52; A4 = 15.52;                  % cm2
        a1 = 0.178; a2 = 0.178; a3 = 0.178; a4 = 0.178;     % cm2
        gamma1 = 0.65; gamma2 = 0.6;     
        k1 = 3.3; k2 = 3.3;                               % cm2/vs                               
        %kc = 0.5;                                           % v/cm
        g = 981;                                            % cm/s2
        
        % state derivatives
        
        dh1dt = -a1/A1*sqrt(2*g*h1)+a3/A1*sqrt(2*g*h3)+gamma1*k1*v1/A1;
        dh2dt = -a2/A2*sqrt(2*g*h2)+a4/A2*sqrt(2*g*h4)+gamma2*k2*v2/A2;
        dh3dt = -a3/A3*sqrt(2*g*h3)+(1-gamma2)*k2*v2/A3;
        dh4dt = -a4/A4*sqrt(2*g*h4)+(1-gamma1)*k1*v1/A4;
        
        sys = [dh1dt;dh2dt;dh3dt;dh4dt];
        
    case 3 % outputs;
        
        sys = [x(1);x(2);x(3);x(4)];
        
    case {2, 4, 9}
        sys = [];
        
    otherwise
        error(['unhandled flag = ',num2str(flag)]);
        
end