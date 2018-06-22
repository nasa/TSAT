function [ X,Y ] = trimLine( x,y,xtrim,side,plotOpt )
%trimLine summary
%   This function trims a line given by it's x and y coordinates. It will
%   trim the line at location xtrim and remove the portion of the line
%   indicated by the variable 'side'. The function uses a natural cubic
%   spline fit to define the line at all data points and to interpolate the
%   value at the trim location.
%
%Inputs:
%   x - x data points [1 x n]
%   y - y data points [1 x n]
%   xtrim - location of the trim on the x-axis [1 x 1]
%   side - indicates the sided to be trimmed/cut off
%       'left' - trim the left side off
%       'right' - trim the right side off   
%   plotOpt - display plot option
%       'y' - yes
%       'n' - no
%
%Outputs:
%   X - x data points of the trimmed line [1 x n] 
%   Y - y data points of the trimmed line [1 x n]

%Error checks
if xtrim < x(1) || xtrim > x(end)
    disp('Error in trim.m: xtrim must be > x(1) and < x(end)')
end
if min(diff(x)) <= 0
    disp('Error in trim.m: x must be monotonically increasing')
end

%Cubic spline coefficients
c = CubicSpline(x,y,[]);

%Find the index of the points the strattle the trim location
for i = 1:length(x)-1
    if xtrim >= x(i) && xtrim <= x(i+1)
        itrim = i;
        if xtrim == x(i+1) && strcmp(side,'left')
            xtrim = [];
        end
        break
    end
end

%Create the new (trimmed) data arrays
if strcmp(side,'left')
    X = [xtrim x(itrim+1:end)];
    Y = CubicSplineInterp(x,c,X,0);
elseif strcmp(side,'right')
    X = [x(1:itrim) xtrim];
    Y = CubicSplineInterp(x,c,X,0);
else
    X = [];
    Y = [];
    disp('Error in trim.m: side must be set to ''left'' or ''right''');
end

if strcmp(plotOpt,'y') == 1
    %Plot and compare trimmed line and the original
    xp = linspace(x(1),x(end),20*length(x));
    yp = CubicSplineInterp(x,c,xp,0);
    C = CubicSpline(X,Y,[]);
    Xp = linspace(X(1),X(end),20*length(X));
    Yp = CubicSplineInterp(X,C,Xp,0);
    figure()
    plot(x,y,'xk')
    hold on
    plot(xp,yp,'-b')
    plot(X,Y,'ok')
    plot(Xp,Yp,'--r')
    hold off
    xlabel('x')
    ylabel('y')
    legend('original data','original spline','trimmed data','trimmed spline')
end

end

