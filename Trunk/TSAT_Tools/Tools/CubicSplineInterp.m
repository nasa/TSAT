function [ yint ] = CubicSplineInterp( x,c,xint,deriv )
%CubicSplineInterp.m Summary
%   This function interpolates based on a natural cubic spline whose cubic
%   functions have been determined using the function CubicSpline.m. This
%   function will determine which cubic function to used based on the value
%   of the indepentent variable, x. It also has the ability to return the
%   interpolated values of the first, second, and third derivatives of the
%   cubic spline at each point of interest.
%
%   Inputs:
%   x - independent variable data (same array that is used by CubicSpline.m
%   c - matrix of the coefficients of the cubic polynomials that make up
%       the spline where the rows correspond to each cubic polynomial in 
%       the spline and the columns correspond to the terms in the cubic 
%       polynomial. Fpr example, the first row corresponds to the first
%       cubic spline segment between x(1) and x(2) and the last 
%       corresponds to the final cubic segments between x(n-1) and x(n). 
%       The first column corresponds to the cubic term and the last column 
%       corresponds to the constant term. This matrix is the output of
%       CubicSpline.m
%   xint - scalar or 1-D array of the values of x for which an interpolated
%       value should be returned. All values in xint should be between x(1)
%       and x(end)
%   deriv - array with values determining the outputs:
%         ---> 0 - straight interpolation
%         ---> 1 - first derivative
%         ---> 2 - second derivative
%         ---> 3 - third derivative

%verify size of x
if length(x)-1 ~= size(c,1)
    fprintf('Error in CubicSplineInterp.m: x must have 1 more element than c has rows.\n')
end
%verify size of c
if size(c,2) ~= 4
    fprintf('Error in CubicSplineInterp.m: c must have 4 columns, 1 for each of the terms in the cubic polynomial.\n')
end
%verify x is monotonicallly increasing
if min(diff(x)) <= 0
    fprintf('Error in CubicSplineInterp.m: x must be monotonically increasing.\n')
end
%verify deriv is no more than 4 elements
if length(deriv) > 4
    fprintf('Error in CubicSplineInterp.m: deriv may have not more than 4 elements.\n')
end
%verify deriv has integer values between 0 and 3
for i = 1:length(deriv)
    if rem(deriv(i),1) ~= 0 || (deriv(i) < 0 || deriv(i) > 3)
        fprintf('Error in CubicSplineInterp.m: elements of deriv must be 0, 1, 2, or 3.\n')
    end
end

yint = zeros(length(xint),length(deriv));
%Interpolate
for i = 1:length(xint)
    if xint(i) < x(1) %xint < x(1) - extapolate with first cubic
        fprintf('Error in CubicSplineInterp.m: xint(%-1.0i) should be greater than x(end). The returned value yint(%-1.0i) could be erroneous.\n',i,i);
        j1 = 1;
    elseif xint(i) > x(end) %xint > x(end) - extapolate with last cubic
        fprintf('Error in CubicSplineInterp.m: xint(%-1.0i) should be less than x(end). The returned value yint(%-1.0i) could be erroneous.\n',i,i);
        j1 = size(c,1);
    else %interpolate using cubic on the interval that xint is on
        %determine interval xint is on by use of the bisection root method
        j1 = 1;
        j2 = length(x);
        while (j2-j1) > 1
            Xs = round((j1+j2)/2);
            FXs = x(Xs) - xint(i);
            if FXs > 0 %solution is on the interval [j1,Xs]
                j2 = Xs;
                if j2 == j1
                    j2 = j1 + 1;
                end
            elseif FXs < 0 %solution is on interval [Xs,j2]
                j1 = Xs;
                if j1 == j2
                    j1 = j2 - 1;
                end
            elseif FXs == 0 %exact solution found
                j1 = Xs;
                j2 = Xs + 1;
            end
        end
    end
    %interplote function and derivatives
    for k = 1:length(deriv)
        if deriv(k) == 0 %straight interpoloation
            yint(i,k) = c(j1,1)*xint(i)^3 + c(j1,2)*xint(i)^2 + c(j1,3)*xint(i) + c(j1,4);
        elseif deriv(k) == 1 %first derivative
            yint(i,k) = 3*c(j1,1)*xint(i)^2 + 2*c(j1,2)*xint(i) + c(j1,3);
        elseif deriv(k) == 2 %second derivative
            yint(i,k) = 6*c(j1,1)*xint(i) + 2*c(j1,2);
        elseif deriv(k) == 3 %third derviative
            yint(i,k) = 6*c(j1,1);
        end
    end
end

end


