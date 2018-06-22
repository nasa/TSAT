% Ex_LineManip_2DObjMesh.m ==================================================%

% Written By: Jonathan Kratz
% Date: January 2, 2018
% Description: This script illustrates the usage of the following
% functions for line creation and manipulation:
%   CubicSpline.m
%   CubicSplineInterp.m
%   lineOffset.m
%   extendLine.m
%   trimLine.m
% In this example, a sine function with discrete points is used to create 
% a line via the CubicSpline.m function. Furthermore interpolation and 
% derivative functionality of the CubicSplineInterp.m function is 
% illustrated. Next a 2-D object is created by off-setting the line in both
% directions by a non-uniform thickness and added vertical endlines to 
% connect the 2 off-set lines. The extendLine.m and trimLine.m function are
% used to appropriately modify the 2 offset lines to get the intended 
% shape. Finally the 2-D object is discretized as it might be for modeling
% heat conduction.
%
% NOTE: The current 2-D Conduction blocks are not meant to address complex 
% geometries such as this. However, the tools illustrated here may be useful 
% in generating geometries and meshes for modeling conduction of various 2D 
% structures if that capability were to be added. These tools also have
% general utility and may be applied in various other ways.

close all
clear all
clc

% load line data points (x,y)
x = linspace(-2*pi,2*pi,50);
y = sin(x);

% Create Cubic Spline Line & Evaluate Derivatives
[ d ] = CubicSpline( x,y,[] );
xint = linspace(x(1),x(end),100);
yint = CubicSplineInterp( x,d,xint,0 );
dydx = CubicSplineInterp( x,d,xint,1 );
d2ydx2 = CubicSplineInterp( x,d,xint,2 );
d3ydx3 = CubicSplineInterp( x,d,xint,3 );
% Plot the results
figure()
plot(xint,yint,'-b')
hold on
plot(xint,dydx,'-r')
plot(xint,d2ydx2,'-g')
plot(xint,d3ydx3,'-m')
hold off
xlabel('x')
ylabel('value')
legend('y','dy/dx','d^2y/dx^2','d^3y/dx^3')
xlim([x(1) x(end)])

% Create the 2-D Object
% -- Offest line in both directions by specified thickness
t = 0.5 + 0.5*abs(sin(x)); %thickness
[X,Y] = lineOffset( x,y,t,'both' ); %<-- offsets line and produces plot of 
%                                        the result
% -- Extract coordinates for the top and bottom lines
xbot = X(2,:);
ybot = Y(2,:);
xtop = X(1,:);
ytop = Y(1,:);
% -- Trim left end of top line and right end of bottom line
[ xtop,ytop ] = trimLine( xtop,ytop,x(1),'left','n' );
[ xbot,ybot ] = trimLine( xbot,ybot,x(end),'right','n' );
% -- Extend right end of top line and left end of bottom line
[ xtop,ytop ] = extendLine( xtop,ytop',x(end),'spline','n' );
[ xbot,ybot ] = extendLine( xbot,ybot',x(1),'spline','n' );
% -- Create left and right lines
xleft = [x(1) x(1)];
yleft = [ybot(1) ytop(1)];
xright = [x(end) x(end)];
yright = [ybot(end) ytop(end)];
% Plot Results
figure()
plot(xbot,ybot,'-k')
hold on
plot(xtop,ytop,'-k')
plot(xleft,yleft,'-k')
plot(xright,yright,'-k')
hold off
title('2D Object')
xlabel('x')
ylabel('y')
xlim([x(1) x(end)])

% Discretize the 2-D Object
%   Note: xd and yd would be the dimensional parameters to be input into a
%   2-D conduction block. Obtaining these quantities is the goal of this
%   portion of the example.
xd = linspace(x(1),x(end),41); %discrete x's
% y-value of top and bottom surfaces
dtop = CubicSpline( xtop,ytop,[] );
yint_top = CubicSplineInterp( xtop,dtop,xd,0 );
dbot = CubicSpline( xbot,ybot,[] );
yint_bot = CubicSplineInterp( xbot,dbot,xd,0 );
% build yd assuming equal spacing in the y-direction at each x-value. Also
% builds xd_plot which is strictly for plotting to visualize the 2-D
% discretization.
yd = [];
xd_plot = [];
for j = 1:length(xd)
    ydj = linspace(yint_bot(j),yint_top(j),11)';
    yd = [yd ydj];
    xdj = xd(j)*ones(11,1);
    xd_plot = [xd_plot xdj];
end
% Plot results
figure()
plot(xbot,ybot,'-k')
hold on
plot(xtop,ytop,'-k')
plot(xleft,yleft,'-k')
plot(xright,yright,'-k')
plot(xd_plot,yd,'xk')
hold off
title('2D Object Mesh')
xlabel('x')
ylabel('y')
xlim([x(1) x(end)])