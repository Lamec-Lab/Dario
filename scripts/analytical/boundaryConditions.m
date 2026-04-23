%{
Boundary Conditions configuration file. Validated against Wu, 2013.

OBS: {R1 R2 T1 T2} are NOT spring constants. they equal EI/K, where K is
the spring constant.

By h4fling.
%}

% Supported Boundary Conditions: FF, CC, PP, CF, CP, CS, EF (testing).
% 1 = [FF] | 2 = [CC] | 3 = [PP] | 4 = [CF] | 5 = [CP] | 6 = [CS]
% 7 = [elastic-F]
% when BC=7, define spring parameter k1 beforehand

if BC==1                % Free-Free
    % n_seg momentum parameter
    R1 = 1e9*L(1);        % N.m/rad
    R2 = 1e9*L(n_seg);    % N.m/rad
    % n_seg sheer stress
    T1 = 1e9*L(1)^3;      % N/m
    T2 = 1e9*L(n_seg)^3;  % N/m
    
elseif BC==2            % Clamped-Clamped
    % n_seg momentum parameter
    R1 = 1e-8*L(1);       % N.m/rad
    R2 = 1e-8*L(n_seg);   % N.m/rad
    % n_seg sheer stress
    T1 = 1e-8*L(1)^3;     % N/m
    T2 = 1e-8*L(n_seg)^3; % N/m
    
elseif BC==3            % Pinned-Pinned
    if simcompi==0
        R1 = 1e8*L(1);        % N.m/rad 
        R2 = 1e8*L(n_seg);    % N.m/rad
    elseif bimat=1
        R1 = 1e6*L(1);        % N.m/rad 
        R2 = 1e6*L(n_seg);    % N.m/rad
    elseif bimat=0
        R1 = 1e4*L(1);        % N.m/rad 
        R2 = 1e4*L(n_seg);    % N.m/rad
    end
    % n_seg sheer stress
    T1 = 1e-8*L(1)^3;     % N/m
    T2 = 1e-8*L(n_seg)^3; % N/m
    
elseif BC==4            % Clamped-Free
    R1 = 1e-8*L(1);       % N.m/rad
    R2 = 1e8*L(n_seg);    % N.m/rad
    % n_seg sheer stress
    T1 = 1e-8*L(1)^3;     % N/m
    T2 = 1e8*L(n_seg)^3;  % N/m
    
elseif BC==5            % Clamped-Pinned
    R1 = 1e-8*L(1);       % N.m/rad
    R2 = 1e8*L(n_seg);    % N.m/rad
    % n_seg sheer stress
    T1 = 1e-8*L(1)^3;     % N/m
    T2 = 1e-8*L(n_seg)^3; % N/m
    
elseif BC==6            % Campled-Sliding
    % n_seg momentum parameter
    R1 = 1e-8*L(1);        % N.m/rad
    R2 = 1e-8*L(n_seg);    % N.m/rad
    % n_seg sheer stress
    T1 = 1e-8*L(1)^3;     % N/m
    T2 = 1e8*L(n_seg)^3;  % N/m

elseif BC==7            % Elastic-Free
    R1 = k1*L(1);         % N.m/rad
    R2 = 1e9*L(n_seg);    % N.m/rad
    % n_seg sheer stress
    T1 = k1*L(n_seg)^3;   % N/m
    T2 = 1e9*L(n_seg)^3;  % N/m
end
