function [ L ] = ThermExp1DElastic( T_data, alpha_data, To, Tf, Lo )
%This function mimics the operation of the TSAT Thermal Expansion 1D
%Elastic block

n = 20;
T = linspace(To,Tf,n);
alpha = zeros(1,n);
for i = 1:n
    if T(i) <= T_data(1)
        alpha(i) = alpha_data(1);
    elseif T(i) >= T_data(end)
        alpha(i) = alpha_data(end);
    else
        alpha(i) = interp1(T_data,alpha_data,T(i),'linear');
    end
end

Int_alphadT = trapz(T,alpha);
dL = Lo*Int_alphadT;

L = Lo + dL;

end

