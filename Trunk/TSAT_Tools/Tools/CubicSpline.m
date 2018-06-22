function [ d ] = CubicSpline( x,y,derivs )
%CubicSpline.m Summary
%   This function fits a natural cubic spline to data points (x,y) where y
%   is a function of x. It returns a matrix of the coefficients of the
%   cubic polynomials that make up the spline where the rows correspond to
%   each cubic polynomial in the spline and the columns correspond to the
%   terms in the cubic polynomial. The first row corresponds to the first
%   cubic spline segment between x(1) and x(2) and the last corresponds to
%   the final cubic segments between x(n-1) and x(n). The first column
%   corresponds to the cubic term and the last column corresponds to the
%   constant term. This function has the option to set the first derivative
%   at the first and last point.
%
%   Inputs:
%       x - independent variable data array [nx1]
%       y - dependent variable data array [nx1]
%       derivs - derivatives at the first and last data points [y'(x(1)),
%       y'(x(end))]. If you do not wish to enforce the derivatives at the
%       boundary then derivs should be and empty array. Otherwise it should
%       have 2 elements.

%verify size of data arrays
if length(x) ~= length(y)
    fprintf('Error in CubicSpline.m: x and y must be the same length.\n')
end
%verify x is monotonicallly increasing
if min(diff(x)) <= 0
    fprintf('Error in CubicSpline.m: x must be monotonically increasing.\n')
end
%verify derivs is empty or length 2
if isempty(derivs) ~= 1 && length(derivs) ~= 2
    fprintf('Error in CubicSpline.m: derivs must be empty or have a length of 2.\n')
end

%number of data points
if isempty(derivs) == 1
    n = length(x);
else
    n = length(x) + 4; %add 2 points before and after the polynomial
    %add a distant point (x1,y1) to the data set which lies on a straight
    %line with (x(1),y(1)) with slope of deriv(1)
    m1 = derivs(1); %slope at the first point
    x1 = x(1)-10*(x(2)-x(1)); %x-location of a distant point forward of x(1)
    b1 = y(1) - m1*x(1); %constant in line equation connecting (x1,y1) to (x(1),y(1))
    y1 = m1*x1 + b1; %y-location of a distant point forward of x(1)
    %add a distant point (xn,yn) to the data set which lies on a straight
    %line with (x(end),y(end)) with slope of deriv(2)
    mn = derivs(2);
    xn = x(end)+10*(x(end)-x(end-1));
    bn = y(end) - mn*x(end);
    yn = mn*xn + bn;
    %add a data point (x1c,y1c) that is close to (x(1),y(1)) and lies on
    %the straight line between (x1,y1) and (x(1),y(1))
    dx1 = (10^-6)*(x(2)-x(1));
    x1c = (x(1)-dx1);
    y1c = m1*x1c + b1;
    %add a data point (xnc,ync) that is close to (x(end),y(end)) and lies on
    %the straight line between (xn,yn) and (x(end),y(end))
    dxn = (10^-6)*(x(end)-x(end-1));
    xnc = (x(end)+dxn);
    ync = mn*xnc + bn;
    %add the points to the arrays
    x = [x1 x1c x xnc xn];
    y = [y1 y1c y ync yn];
end

%values of h
for i = 1:n-1
    h(i) = x(i+1) - x(i);
end

%solve for coefficients, a
A = zeros(n-2,n-2);
B = zeros(n-2,1);
a = zeros(n,1);
for i = 1:n-2
    for j = 1:n-2
        if j < i-1
            A(i,j) = 0;
        elseif j > i+1
            A(i,j) = 0;
        elseif j == i - 1;
            A(i,j) = h(i);
        elseif j == i;
            A(i,j) = 2*(h(i)+h(i+1));
        elseif j == i + 1;
            A(i,j) = h(i+1);
        end
    end
    B(i) = 6*((y(i+2)-y(i+1))/h(i+1) - (y(i+1)-y(i))/h(i));
end
a(2:n-1) = (A\B)';

%define coefficients for the polynomial in the form:
%   y = b1*(x(i+1)-x)^3 + b2*(x-x(i))^3 + b3*(x(i+1)-x) + b4*(x-x(i))
b = zeros(n-1,4);
for i = 1:n-1
    b(i,1) = a(i)/(6*h(i)); %Coefficient on (x(i+1) - x)^3
    b(i,2) = a(i+1)/(6*h(i)); %Coefficient on (x - x(i))^3
    b(i,3) = y(i)/h(i) - a(i)*h(i)/6; %Coefficient on (x(i+1) - x)
    b(i,4) = y(i+1)/h(i) - a(i+1)*h(i)/6; %Coefficient on (x - x(i))
end

%express as a typical polynomial form (y = c1*x^3 + c2*x^2 + c3*x + c4)
c = zeros(n-1,4);
for i = 1:n-1
    Term1 = b(i,1)*PolyProd(PolyProd([-1 x(i+1)],[-1 x(i+1)]),[-1 x(i+1)]);
    Term2 = b(i,2)*PolyProd(PolyProd([1 -x(i)],[1 -x(i)]),[1 -x(i)]);
    Term3 = b(i,3)*[-1 x(i+1)];
    Term4 = b(i,4)*[1 -x(i)];
    c(i,:) = PolySum(PolySum(PolySum(Term1,Term2),Term3),Term4);
end

if isempty(derivs) == 1
    d = c;
else
    d = c(3:size(c)-2,:);
end



