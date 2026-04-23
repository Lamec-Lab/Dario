%{
Beam data main file

Analised Beam Structure: Euler-Bernoulli stepped beam.
Torsional springs on ends (testing) linear springs on ends. (testing)
Axial load distribution. (seg const / not working)
Dynamic analysis: changes in segment mass distribution. (prototype)

Supported Boundary Conditions: FF, CC, PP, CF, CP, CS, (validated)
                               EF : Elastic-Free (testing).

Gives beam data to Regula Falsi routine [falsaposicao.m].

Output:
Frequencies: dimentional [rad/s], non-dimentional [-],
             cyclic frequencies [Hz].

Recommendations:
- Recalculate system matrix using a dimentional approach, instead of 
  non-dimentional. Then, axial load should work.
- Otherwise check non-dimentionalization of axial load for matrix issues.
- Switching to struct-based input could be useful but code performance has
  to be assessed.

By h4lfling.
%}

close all; clear;
tic;
format short;

% %{
%-------------------------- PRISMATIC BEAM DATA --------------------------%
% Number of modeshapes
modos = 8;

% Case validation switch
validacao = 0;
simcompi = 1;

% Validation 1: Back-check against paper
if validacao==1
    % for r=cat(2,0.1:0.1:1,1.5:.5:2),viga,end
    d1 = 0.05;
    %{
    r = 0.8; diameter = [d1 d1*r];
    %}
    % %{
    n_seg = 3;
    % beam.n_step = 3;
    diameter = [d1*r d1 d1*r];
    % beam.d = [d1*r d1 d1*r]; % <<<<<<<<<<<<<<<<<
    di = diameter;
    % %}
    % .0217    0.7522    2.1984

% Periodic Beam Analysis -------------------------------------------------
elseif simcompi==1
    % Param. de periodicidade
    alpha_artigo = 1-(4/8);
    LS2 = (alpha_artigo/2);
    LS1 = 1-2*LS2;

    % Param. gerais
    n_c = 10; L0 = 1; n_seg = 3*n_c;

    % Caso: Bimaterial || Bigeometria
    bimat = 0;
    
    if bimat==0  % Caso: Bigeometria
        % Prop. material
        rho_c = [7850 7850 7850];  % kg/m^3
        Ec = [205e9 205e9 205e9];  % Pa = N/m^2
    
        % Prop. geomÃ©tricas
        d1 = 0.01*ones(1,3);          % Altura [m]
        d2 = [0.0250 0.0375 0.0250];  % Base   [m]
         
    else % Caso: Bimaterial
        % Prop. material
        rho_c = [2700 7850 2700];  % kg/m^3
        Ec = [69e9 205e9 69e9];   % Pa = N/m^2
    
        % Prop. geomÃ©tricas
        d1 = 0.01*ones(1,3);    % Altura [m]
        d2 = 0.0250*ones(1,3);  % Base   [m]
    end
    Lc = [LS2, LS1, LS2] * L0/n_c; % Comp. CÃ©lula

% Other case -------------------------------------------------------------
elseif validacao==0
    n_seg = 9;
    diameter = ones(1,n_seg) * 0.05; % [m]
    % Total beam legnth
    L0 = 2; % 321.22/1000;     % [m]
    % Segment length
    L = ones(1,n_seg)*L0/n_seg;        % [m]   ( per step )
    rho = 2710.3; %7850;           % kg/m^3
    E = 6.873e+10; %2.068e+11; % ; % Pa = N/m^2

    % beam.d = ones(1,n_seg) * 0.05; % [m] % <<<<<<<<<<<<<<<<<
    % diameter = [ 0.005 0.006 0.009 ];
    % diameter = [14.996/1000 20.005/1000];
    % diameter = [14.967/1000 20.007/1000];
    % diameter = [ 9.941/1000 14.976/1000 20.008/1000 ];
    % diameter = [ diam diam/(2^(1/4)) ];
end

% Geometric and Material Properties --------------------------------------
if simcompi==1
    Area = repmat(d1.*d2, 1, n_c);    % m^2
    I = repmat(d1.*d2.^3/12, 1, n_c); % m^4
    E = repmat(Ec, 1, n_c);           % m^4
    rho = repmat(rho_c, 1, n_c);      % m^4
    EI = E .* I;                      % N.m^2
    RhoA = rho .* Area;
    L = repmat(Lc, 1, n_c);           % m
else
    I = (pi/64).*diameter.^4;         % m^4
    Area = pi .* (diameter/2).^2;     % m^2
    EI = E .* I;                      % N.m^2
    RhoA = rho .* Area;               % kg/m
end

test = 0; % test switch for BC

Li = L./L0;          % non-dimentional relative segment length (=l_i/L0)
a = zeros(1,n_seg);  % non-dimentional axial force (keep at 0)
%-------------------------------------------------------------------------%

%------------------------- BOUNDARY CONDITIONS --------------------------%
% Boundary Condition selection according to options below
% 
% 1 = [FF] | 2 = [CC] | 3 = [PP] | 4 = [CF] | 5 = [CP] | 6 = [CS]
% 7 = [elastic-F]
% 
BC = 3;
boundaryConditions();
%-------------------------------------------------------------------------%

%-------------------------- SINGLE FREQUENCY ----------------------------%
getFrequencies();
%-------------------------------------------------------------------------%

%------------------------ DYNAMIC MODAL ANALYSIS ------------------------%
% dynamicAnalysis();
%-------------------------------------------------------------------------%
toc;
