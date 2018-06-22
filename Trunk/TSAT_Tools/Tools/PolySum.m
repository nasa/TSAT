function [ Poly ] = PolySum( p1,p2 )

%Sums the 2 polynomials given their coefficients
if length(p1) == length(p2)
    Poly = p1 + p2;
elseif length(p1) > length(p2)
    P2 = zeros(1,length(p1));
    k = length(p2);
    for i = length(p1):-1:length(p1)-length(p2)+1
        P2(i) = p2(k);
        k = k -1;
    end
    Poly = p1 + P2;
elseif length(p1) < length(p2)
    P1 = zeros(1,length(p2));
    k = length(p1);
    for i = length(p2):-1:length(p2)-length(p1)+1
        P1(i) = p1(k);
        k = k -1;
    end
    Poly = p2 + P1;
end

end

