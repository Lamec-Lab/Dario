%{
    Rotina da Falsa Posição.
    By slepton, h4lfling.

    Adaptado para estrutura de foguete:
        Recebe parâmetros da simulação de [viga.m]
        Passa parâmetros para rotina da matriz [func.m]

    Modificado Março/2023:
        - raiz = 'a funçao nao apresenta mais raizes' torna-se raiz = ''.
        - Valor inicial modificado de [a = 0] para [a = 0.01].
    Modificado Jan/2025:
        - Precisão modificada de 0.000001 (1e-6) para 1e-5.
        - Valor inicial modificado de [a=0.01] para [a=0.1].
	Modificado Abr/2025:
		- Valor inicial mudado para 'a=1'.
        - Passo mudado para 'passo=1'.
    Bugs identificados:
        - Possível duplicação do cálculo de raíz ao redor de x=0.
%}

function [raiz] = falsaposicao(quantmax,L0,R1,R2,T1,T2,EI,RhoA,Li,A)

clear c;

%dados iniciais
quant = 0; %contador para a quantidade de raizes
a = 1; %primeiro ponto da funçao
passo = 1; %aumentar a divisao para que pegue resultados menores
b = passo; %segundo ponto
raiz = zeros(1,quantmax);
%laço para repetir o programa ate achar todas as raizes pedidas

while quant < quantmax
    tol = 1e-4;  % tolerância de erro
    %funçoes de a e b
    fa = func(a,L0,R1,R2,T1,T2,EI,RhoA,Li,A);
    fb = func(b,L0,R1,R2,T1,T2,EI,RhoA,Li,A);
    teste = bolzano(fa,fb,1); %uso de bolzano de fa, fb e o contador de tentativas
    if teste == 0 %contagem maior que 10000
        raiz = 'a funçao nao apresenta mais raizes';
        break %programa acaba
    elseif teste == 1
        raiz(quant) = falsa(a,b,tol); % faixa de erro
        % raiz(quant) = falsa(...
    end
end

%algoritimo da falsa posiçao
    function [x] = falsa(a2,b2,erro)
        fa2 = func(a2,L0,R1,R2,T1,T2,EI,RhoA,Li,A);
        fb2 = func(b2,L0,R1,R2,T1,T2,EI,RhoA,Li,A); %calculo das funçoes
        
        x = (a2-(b2-a2)*fa2/(fb2-fa2));
        %laço que se repetira ate ser menor que o erro
        while abs(x - a2) >= erro
            a2 = x; %aplicando o novo a, pois b é fixo
            fa2 = func(a2,L0,R1,R2,T1,T2,EI,RhoA,Li,A);
            
            % Calculo da falsa posiçao
            x = (a2-(b2-a2)*fa2/(fb2-fa2));
            if fb2 == 0 %caso a raiz esteja exatamente em b
                x = b2;
            end
        end
        quant = quant + 1;
        a = b + passo; %a aumenta para o intervalo maximo sempre ser igual ao passo
        b = b + 2*passo; %aumentando b para testar novamente
    end

%funçao de bolzano
    function [resultado] = bolzano(fa, fb, contmax) %contmax é o numero de tentativas
        
        while fa*fb > 0
            
            a = b; %a aumenta para o intervalo maximo sempre ser igual ao passo
            b = b + passo; %aumentando b para testar novamente
            fa = func(a,L0,R1,R2,T1,T2,EI,RhoA,Li,A); %calculando a nova funcao de a para o teste do while
            fb = func(b,L0,R1,R2,T1,T2,EI,RhoA,Li,A); %calculando a nova funcao de b para o teste do while
            
            contmax = contmax+1; %laço de que segue ate o maximo
            
            if contmax == 1e20
                break
            end
        end
        
        if contmax == 1e20 %maximo de vezes que o computador vai tentar
            
            resultado = 0;
        else
            
            resultado = 1;
        end
        contmax = 0;
    end
end
