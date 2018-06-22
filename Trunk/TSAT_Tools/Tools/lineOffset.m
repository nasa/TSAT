function [ X,Y ] = lineOffset( x,y,t,offsetDir )
%lineOffset summary
%   This function offsets a line define by numeric data (x,y) by at given
%   thickness t(x). The thickness can be a function of x. The line can be
%   offset above, below, or int both directions.
%
%Inputs:
%   x - x data points [1 x n]
%   y - y data points [1 x n]
%   t - thickness (distance of the offset) [1 x n]
%   offsetDir - offset direction option
%       'above' - offset the line above it's current position
%       'below' - offset the line below it's currnet position
%       'both' - offset in both direction with the current position being the center      
%
%Outputs:
%   X - x data points of the offset line. [1 x n] if the 'above' or 'below'
%       offsetDir option is chosen and [2 x n] if the 'both' option is
%       chosen.
%   Y - y data points of the offset line. [1 x n] if the 'above' or 'below'
%       offsetDir option is chosen and [2 x n] if the 'both' option is
%       chosen.

%Fit the data to a cubic spline
c = CubicSpline(x,y,[]);

%Find the slope at each point (derivative)
m0 = CubicSplineInterp(x,c,x,1);

%Find the constants for the linear lines normal to line at each data point
m1 = -1./m0;
b1 = y - m1'.*x;

%Offset the line defined by x and y
ang = abs(atan(m1));

if strcmp(offsetDir,'below')
    for i = 1:length(ang)
        if abs(ang(i) - pi/2) < 10^-8
            X(i) = x(i);
            Y(i) = y(i) - t(i);
        else
            dx(i) = t(i)*cos(ang(i));
            if m1(i) > 0
                X(i) = x(i) - dx(i);
            else
                X(i) = x(i) + dx(i);
            end
            Y(i) = m1(i)*X(i) + b1(i);
        end
    end
elseif strcmp(offsetDir,'above')
    for i = 1:length(ang)
        if abs(ang(i) - pi/2) < 10^-8
            X(i) = x(i);
            Y(i) = y(i) + t(i);
        else
            dx(i) = t(i)*cos(ang(i));
            if m1(i) > 0
                X(i) = x(i) + dx(i);
            else
                X(i) = x(i) - dx(i);
            end
            Y(i) = m1(i)*X(i) + b1(i);
        end
    end
elseif strcmp(offsetDir,'both')
    for i = 1:length(ang)
        if abs(ang(i) - pi/2) < 10^-8
            X1(i) = x(i);
            Y1(i) = y(i) - t(i)/2;
            X2(i) = x(i);
            Y2(i) = y(i) + t(i)/2;
        else
            dx(i) = t(i)*cos(ang(i));
            if m1(i) > 0
                X1(i) = x(i) - dx(i)/2;
                X2(i) = x(i) + dx(i)/2;
            else
                X1(i) = x(i) + dx(i)/2;
                X2(i) = x(i) - dx(i)/2;
            end
            Y1(i) = m1(i)*X1(i) + b1(i);
            Y2(i) = m1(i)*X2(i) + b1(i);
        end
    end
    if Y2(1) > Y1(1)
        X = [X2; X1];
        Y = [Y2; Y1];
    else
        X = [X1; X2];
        Y = [Y1; Y2];
    end
else
    X = [];
    Y = [];
    disp('Error in lineOffset.m: offsetDir must be set to ''above'', ''below'', or ''both''')
end

%Plot
figure()
plot(x,y,'xk')
hold on
axis('equal')
xlabel('x')
ylabel('y')
xs = linspace(x(1),x(end),20*length(x));
ys = CubicSplineInterp(x,c,xs,0);
plot(xs,ys,'-b')
if strcmp(offsetDir,'above') || strcmp(offsetDir,'below')
    plot(X,Y,'sk')
    a = CubicSpline(X,Y,[]);
    Xs = linspace(X(1),X(end),20*length(X));
    Ys = CubicSplineInterp(X,a,Xs,0);
    plot(Xs,Ys,'-r')
    legend('original data','spline through original data','offset data','offset spline','Location','best')
elseif offsetDir == 'both'
    plot(X1,Y1,'sk')
    d1 = CubicSpline(X1,Y1,[]);
    X1s = linspace(X1(1),X1(end),20*length(X1));
    Y1s = CubicSplineInterp(X1,d1,X1s,0);
    plot(X1s,Y1s,'-r')
    plot(X2,Y2,'vk')
    d2 = CubicSpline(X2,Y2,[]);
    X2s = linspace(X2(1),X2(end),20*length(X2));
    Y2s = CubicSplineInterp(X2,d2,X2s,0);
    plot(X2s,Y2s,'-m')
    legend('original data','spline through original data','offset data 1','offset spline 1','offset data 2','offset spline 2','Location','best')
end

end

