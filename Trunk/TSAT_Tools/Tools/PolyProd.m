function [ Poly ] = PolyProd( p1,p2 )

%This function take two polynomial p1 and p2 represented by a vector of
%their coefficients and multiplys them to find the product polynomial Poly.

%Ex: p1 = s^2 + 2*s + 3 --> p1 = [1 2 3]

order = length(p1) + length(p2) - 2;

P = zeros(length(p1),order+1);
for i = 1:length(p1)
    P(i,i:i+length(p2)-1) = p1(i)*p2;
end
Poly = zeros(1,order+1);
for i = 1:order+1
    Poly(i) = sum(P(:,i));
end

end

