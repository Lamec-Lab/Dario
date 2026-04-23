% Matrix routine for Rocket Beam natural frequencies.
% Receives beam data from Regula Falsi routine [falsaposicao.m].
% 
% Rocket Structure:
%     Stepped Euler-Bernoulli ( n steps ) [works for traditional BC].
%     torsional spring on both ends [works for traditional BC].
%     linear spring on both ends [works for traditional BC].
%     axial load distribution ( segment constant ) [not working].
% 
% Output: matrix determinant, returns to [falsaposicao.m].
% By h4lfling

function [determinante] = func(omega,L0,R1,R2,T1,T2,EI,RhoA,Li,a)

% { R1 R2 T1 T2 L0 omega } are constant numbers
% { EI RhoA Li a         } are vectorial

n = length(EI); % quant. of segments

matriz = zeros(4*n,4*n);

lambda_seg = zeros(1,n);
lambX1 = lambda_seg; lambX2 = lambda_seg;

S = zeros(1,n); C = S; SH = S; CH = S;
EIR = zeros(1,n-1);
for i=1:(n-1)
    EIR(i) = EI(i+1)/EI(i);
end
for i=1:n
    lambda_seg(i) = ( RhoA(i)*L0^4*omega^2/EI(i) )^(1/4);
    lambX1(i) = ( 0.5 * ( (a(i)^2+4*lambda_seg(i)^4)^(1/2) - a(i) ) )^(1/2);
    lambX2(i) = ( 0.5 * ( (a(i)^2+4*lambda_seg(i)^4)^(1/2) + a(i) ) )^(1/2);
    S(i) = sin( lambX2(i) * Li(i) );
    C(i) = cos( lambX2(i) * Li(i) );
    SH(i) = sinh( lambX1(i) * Li(i) );
    CH(i) = cosh( lambX1(i) * Li(i) );
end

%--------------------- BOUNDARY CONDITIONS ---------------------%
flexao_0 = L0 * [   lambX2(1);
                    (lambX2(1)^2 + a(1))*R1;
                    lambX1(1);
                  - (lambX1(1)^2 - a(1))*R1    ]';
            
cort_0 = [ -(lambX2(1)^3 + lambX2(1)*a(1))*T1;
            1;
           -(lambX1(1)*a(1) - lambX1(1)^3)*T1;
            1                                  ]';

flexao_n = -L0*[ -R2*S(n)*( lambX2(n)^2  + a(n) ) - lambX2(n)*C(n);
                -R2*C(n)*( lambX2(n)^2  + a(n) ) + lambX2(n)*S(n);
                 R2*SH(n)*( lambX1(n)^2 - a(n) ) - lambX1(n)*CH(n);
                 R2*CH(n)*( lambX1(n)^2 - a(n) ) - lambX1(n)*SH(n) ]';
             
cort_n = [ -T2* C(n)*( lambX2(n)^3 + a(n)*lambX2(n) ) +  S(n);
            T2* S(n)*( lambX2(n)^3 + a(n)*lambX2(n) ) +  C(n);
            T2*CH(n)*( lambX1(n)^3 - a(n)*lambX1(n) ) + SH(n);
            T2*SH(n)*( lambX1(n)^3 - a(n)*lambX1(n) ) + CH(n) ]';
        
matriz([1,2],1:4) = [flexao_0; cort_0];
matriz([3,4],(4*n-3):(4*n)) = [flexao_n; cort_n];
%---------------------------------------------------------------%

%------------------- COMPATIBILITY CONDITIONS ------------------%
for i=1:(n-1)
    
    compt1 = [ S(i) C(i) SH(i) CH(i) 0 -1 0 -1 ];
    
    % poderia ser (i) de 4 a 8?
    compt2 = L0*[  lambX2(i)*C(i);
                  -lambX2(i)*S(i);
                   lambX1(i)*CH(i);
                   lambX1(i)*SH(i);
                  -lambX2(i+1);
                   0;
                  -lambX1(i+1);
                   0 ]';

    compt3 = L0^2*[ - S(i) *( lambX2(i)^2 + a(i) );
                    - C(i) *( lambX2(i)^2 + a(i) );
                      SH(i)*( lambX1(i)^2 - a(i) );
                      CH(i)*( lambX1(i)^2 - a(i) );
                      0;
                      EIR(i)*(  lambX2(i+1)^2 + a(i+1) );
                      0;
                      EIR(i)*( -lambX1(i+1)^2 + a(i+1) ) ]';
                  
    compt4 = L0^3*[ - C(i) *( lambX2(i)^3 + a(i)*lambX2(i) );
                      S(i) *( lambX2(i)^3 + a(i)*lambX2(i) );
                      CH(i)*( lambX1(i)^3 - a(i)*lambX1(i) );
                      SH(i)*( lambX1(i)^3 - a(i)*lambX1(i) );
                      EIR(i)*( lambX2(i+1)^3 - a(i+1)*lambX2(i+1) );
                      0;
                    - EIR(i)*( lambX1(i+1)^3 + a(i+1)*lambX1(i+1) );
                      0 ]';
    matriz([1+4*i,2+4*i,3+4*i,4+4*i],(1+4*(i-1)):(8+4*(i-1))) = [compt1; compt2; compt3; compt4];
end
%---------------------------------------------------------------%

determinante = det(matriz);

end
