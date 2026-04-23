%{
Frequency Routine
- Calculates single case frequency.
by h4lfling.
%}

if validacao==1
    format compact
    freq_dim = falsaposicao(modos,L0,R1,R2,T1,T2,EI,RhoA,Li,a); % [rad/s]
    freq_adim = ( L0^4 * freq_dim.^2 * RhoA(1) / EI(1) ).^(1/4); % [-]

%     disp([sprintf('%.3f',r),'    ',sprintf('%.4f',freq_adim(1)^2)])

    %{
    disp([sprintf('%s','  d1'),...
        sprintf('%s',' |  d2')...
        sprintf('%s',' |  d3')...
        sprintf('%s',' |  freq1')]);

%         sprintf('%.3f',diameter(3)),'|',...
    %}
%     disp(freq_adim)
    disp([sprintf('%.3f',r),'|',...
        sprintf('%.3f',diameter(1)),'|',...
        sprintf('%.3f',diameter(2)),'|',...
        sprintf('%.4f',freq_adim(1)^2)]);
%     %}
    
elseif validacao==2
    format compact
    freq_dim = falsaposicao(modos,L0,R1,R2,T1,T2,EI,RhoA,Li,a); % [rad/s]
    freq_adim = ( L0^4 * freq_dim.^2 * RhoA(1) / EI(1) ).^(1/4); % [-]

%     disp([sprintf('%.3f',r),'    ',sprintf('%.4f',freq_adim(1)^2)])

    %{
    disp([sprintf('%s',' k1 '),'|',...
        sprintf('%s',' freq1 ')]);
    %}
    disp([sprintf('%.3f',k1),' | ',...
        sprintf('%.4f',freq_adim(1)^2)]);

elseif test==1
    format compact
    freq_dim = falsaposicao(modos,L0,R1,R2,T1,T2,EI,RhoA,Li,a); % [rad/s]
    freq_adim = ( L0^4 * freq_dim.^2 * RhoA(1) / EI(1) ).^(1/4); % [-]

%     disp([sprintf('%.3f',r),'    ',sprintf('%.4f',freq_adim(1)^2)])

    %{
    disp([sprintf('%s','  d1'),...
        sprintf('%s',' |  d2')...
        sprintf('%s',' |  d3')...
        sprintf('%s',' |  massa')...
        sprintf('%s',' |  freq1')]);
    %}
    disp([sprintf('%.3f',diameter(1)),'|',...
        sprintf('%.3f',diameter(2)),'|',...
        sprintf('%.3f',diameter(3)),'|',...
        sprintf('%.4f',massa),'    ',...
        sprintf('%.4f',freq_adim(1))]);
%     %}

else
    format short;disp("Working...");
    freq_dim = falsaposicao(modos,...
        L0,R1,R2,T1,T2,EI,RhoA,Li,a); % [rad/s]
    freq_hz = freq_dim/(2*pi);
    
    % Assuming EI(1) and RhoA(1) as reference segment
    B_ = sqrt((RhoA(1) * L0^4) / EI(1));
    % Calculate normalized eigenvalues (equivalent to FEM's 'b')
    b_normalized = (freq_dim * B_).^2;
    % Dispersion relation parameter
    freq_adim = (L0^4 * freq_dim.^2 * RhoA(1) / EI(1)).^(1/4);
    
    disp("=== Frequency Comparison ===");
    disp("Natural frequencies [rad/s]:");
    fprintf('%.4f, %.4f\n',freq_dim);
    disp("Natural frequencies [Hz]:");
    fprintf('%.4f, %.4f\n',freq_hz);
    disp("Dispersion parameter Î²:");
    fprintf('%.4f, %.4f\n',freq_adim);
end
