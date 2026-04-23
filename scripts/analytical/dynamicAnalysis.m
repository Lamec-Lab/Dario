%{
Dynamic Analysis Routine

- Gives beam data to Natural Frequency Routine.
- Changes mass distribution 'RhoA' and appends new frequencies to array.
- Plots the graphic with in-flight frequency variation.
Note: mass axis has to be adimentional and reversed (from 0 to 1, not from m_i>m_f to m_f).

by h4lfling.
%}

format compact;

p = 20/100;            % porcentagem de variação
varM = ones(1,n_seg);  % depleção uniforme de massa

%---------------------
% ex. depleção não-uniforme:
% varM = [.25 .5 .75 1]
% 
% PROTÓTIPO PARA DEPLEÇÃO NÃO UNIFORME: (similar ao artigo)
% min_dep = .1;                         % depleção limite de 10% da máxima
% varM = [1:-(1-min_dep)/(n_seg-1):min_dep]; % variação linear da depleção
%---------------------

dRhoA = p*varM.*RhoA;  % variação de massa
mt = [];               % massa em função do tempo [kg]
freq_adim_t = [];      % freq. adimensionais em função do tempo

% %{
while ~any(RhoA<=1.1*dRhoA)
%{
      Condição: distribuição de massa não diminui a valores desprezíveis
      É necessário usar Md somente para analisar cenários de depleção não
      uniforme de massa, ex: [10 10 10] >> [8 9 9.5]
%}
    mt = [mt sum(RhoA.*L)]; % salva massa total
    try
        freq_dim = falsaposicao(modos,L0,R1,R2,T1,T2,EI,RhoA,Li,a);
        % [rad/s]
        freq_adim_t = [freq_adim_t;
            ( L0^4 * freq_dim.^2 * RhoA(1) / EI(1) ).^(1/4)]; % [-]
        %freq_cic = freq_dim/(2*pi);
        %   [Hz]
    catch
        freq_dim = zeros(1,modos);freq_adim_t = freq_dim;
        freq_cic = freq_dim;
    end
    
    RhoA = RhoA - dRhoA;    % recalcula as distribuições de massa
    %a = a; % forças axiais calculadas para RhoA ( em implementação )
end
% %}

%--------------------- DISPLAY MASS STATISTICS
% RhoA
% mt(1) % kg
% disp('kg')
% mt(length(mt))*1000 % g
% disp('g')
%---------------------

% %{
%--------------------- PLOTTING
plot_separate = 0;
% [1] for plotting modes separate
try
    % colunas de freq_adim_t mostram variação de cada freq. adim. no tempo
    if plot_separate == 0
        plot(mt,freq_adim_t,'LineWidth',1.5)   % i-ésima frequência em função da massa
        set(gca, 'xdir', 'reverse') % invertendo eixo das massas
        xlabel('Massa [kg]')
        ylabel('Frequência Adimensional [-]')
        title('Modos de vibração ao longo do voo')
    else
        for i=1:modos
            figure
            plot(mt,freq_adim_t(:,i),'LineWidth',1.5)
            set(gca, 'xdir', 'reverse')
            xlabel('Massa [kg]')
            ylabel('Frequência Adimensional [-]')
            title([num2str(i),'º Modo de vibração ao longo do voo'])
        end
    end
catch
    disp('Erro na plotagem.');
end
%---------------------
% %}

format loose;
