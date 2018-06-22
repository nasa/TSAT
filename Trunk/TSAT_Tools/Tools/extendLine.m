function [ X,Y ] = extendLine( x,y,xext,method,plotOpt )
%extendLine summary
%   This function extends a line given by it's x and y coordinates. It will
%   extend the line to the x-location 'xext' using 1 of 2 methods
%   determined by the variable 'method'. It will either extapolate with a
%   cubic spline or a linear line that is tangent with the line at it's
%   closest data point.
%
%Inputs:
%   x - x data points [1 x n]
%   y - y data points [1 x n]
%   xext - location to which the line is to be extended on the x-axis [1 x 1]
%   method - method of extrapolation
%       'spline' - natural cubic spline
%       'linear' - linear line that is tangent with the line at the closest
%                  end point.
%
%Outputs:
%   X - x data points of the trimmed line [1 x n] 
%   Y - y data points of the trimmed line [1 x n]

%Error checks
if xext >= x(1) && xext <= x(end)
    disp('Error in extend.m: xext must be < x(1) or > x(end)')
end
if min(diff(x)) <= 0
    disp('Error in extend.m: x must be monotonically increasing')
end

%Cubic spline coefficients
c = CubicSpline(x,y,[]);

if xext < x(1)
    if strcmp(method,'spline')
        yext = c(1,1)*xext^3 + c(1,2)*xext^2 + c(1,3)*xext + c(1,4);
        X = [xext x];
        Y = [yext y]; 
    elseif strcmp(method,'linear')
        m = CubicSplineInterp(x,c,x(1),1);
        b = y(1) - m*x(1);
        yext = m*xext + b;
        X = [xext x];
        Y = [yext y];
    else
        X = [];
        Y = [];
    end
elseif xext > x(end)
    if strcmp(method,'spline')
        yext = c(end,1)*xext^3 + c(end,2)*xext^2 + c(end,3)*xext + c(end,4);
        X = [x xext];
        Y = [y yext];
    elseif strcmp(method,'linear')
        m = CubicSplineInterp(x,c,x(end),1);
        b = y(end) - m*x(end);
        yext = m*xext + b;
        X = [x xext];
        Y = [y yext]; 
    else
        X = [];
        Y = [];
    end
else
    X = [];
    Y = [];
end

if strcmp('plotOpt','y')
    %Plot and compare extended line and the original
    xp = linspace(x(1),x(end),20*length(x));
    yp = CubicSplineInterp(x,c,xp,0);
    C = CubicSpline(X,Y,[]);
    Xp = linspace(X(1),X(end),20*length(X));
    Yp = CubicSplineInterp(X,C,Xp,0);
    figure()
    plot(X,Y,'xk')
    hold on
    plot(Xp,Yp,'-b')
    plot(x,y,'ok')
    plot(xp,yp,'--r')
    hold off
    xlabel('x')
    ylabel('y')
    legend('extened data','extended spline','original data','original spline')
end

end

