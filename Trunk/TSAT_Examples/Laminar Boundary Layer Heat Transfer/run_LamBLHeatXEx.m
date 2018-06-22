% run_LamBLHeatXEx.m =====================================================%

% Written By: Jonathan Kratz (NASA GRC)
% Date: 12/15/2017
% Description: This script populates the workspace for the
%   LamBLHeatXEx.slx model to run, executes the model, and displays the 
%   results. The results are shown in the form of a generated movies and
%   plots. Results include the polynomial fit for the Tw-Te profile, the
%   boundary layer profile, and heat transfer related quantities including
%   the Nusselt number, heat transfer coefficient, and wall temperature.

close all
clear all
clc

% Define workspace variables ---------------------------------------------%

% Simulation Time-Step
dt = 5; %Time-step [sec]

% Boundary Layer Variables
Pr = 0.72; %Prantl Number
beta = 0; %Pressure Gradient Variable (Blasius - zero pressure gradient)
x_Uknown = 1; %location of known velocity [ft]
xBL = linspace(0.05,3,50); %locations along the surface to comput the boundary 
                        %layer [ft]
n = 10; %number of element to show in the boundary layer going out from the
        %surface
Te = 550; %temperature of the air at the edge of the boundary layer
rho_air = 0.00237; %denisty of air [slug/ft^3]
Uknown = 15; %speed of the air flowing over the plate [ft/sec]
N = 4; %polynomial degree for approximating Tw-Te

% Flat Plate Variables
x  = linspace(0,3,30); %discretization of flat plate along it's length [ft]
% -- y discretization
y0 = linspace(0,0.125/12,10)'; %discretization of the plate along thickness [ft]
y = [];
for i = 1:length(x)
    y = [y y0];
end
% -- Initial Temperature
T0vec = 800 - 20*x.^2;
T0 = [];
for j = 1:length(y0)
    T0 = [T0; T0vec];
end
% -- Material Properties (Aluminum)
k = 0.0328*ones(length(y0),length(x)); %Thermal Conductivity [Btu/(sec-ft-R)]
Cp = 6.92*ones(length(y0),length(x)); %Heat Capcity [Btu/(slug-R)]
rho = 5.238864896*ones(length(y0),length(x)); %Density [slug/ft^3]

% Run Model --------------------------------------------------------------%

sim('LamBLHeatXEx.slx')

% Plot Results -----------------------------------------------------------%

a.Data = permute(a.Data,[3,2,1]);

% Polynomial Coefficients
figure()
for i = 1:size(a.Data,2)
    LEG{i} = ['a',num2str(i-1)];
    plot(a.Time,a.Data(:,i,1),'LineWidth',2)
    hold on
end
hold off
xlabel('Time')
ylabel('Polynomial Coefficients, a')
legend(LEG,0)
grid on

X = linspace(x(1),x(end),100);
for i = 1:length(a.Time)
    TwmTeCalc(i,:) = a.Data(i,1) + a.Data(i,2)*X + a.Data(i,3)*X.^2 + a.Data(i,4)*X.^3 + a.Data(i,5)*X.^4;
end

% Polynomial Fit
fig1 = figure();
vidObj = VideoWriter('PolyfitMovie.mp4','MPEG-4');
vidObj.FrameRate = 20;
open(vidObj);
j = 0;
for i = 1:length(TwmTe.Time)
    if TwmTe.Time(i) > j
    %Plot
    plot(xBL,TwmTe.Data(i,:),'xk','LineWidth',2);
    hold on
    plot(X,TwmTeCalc(i,:),'-b','LineWidth',2);
    hold off
    title('Polynomial Fit')
    xlabel('x [ft]')
    ylabel('T_w-T_e [^oR]')
    axis([0 3 0 300]);
    grid on
    %Add Time as text
    Time = [num2str(TwmTe.Time(i)),'sec'];
    TT = text(0.5,25,['Time: ',Time]);
    TT.FontSize = 14;
    %Get frame and write to movie
    currFrame = getframe(fig1);
    writeVideo(vidObj,currFrame)
    j = j + 1;
    end
end
close(vidObj);

%Display Results at Final Time Step
fprintf('G: %-5.4f\n',G.Data(end,1));

%Velocity and Thermal Boundary Layer Thickness
figure()
plot(xBL,del.Data(1,:,end),'-b','LineWidth',2)
xlabel('x [ft]')
ylabel('\delta [ft]')
 
%Non-Dimensional Velocity Profile
figure()
plot(u.Data(:,end,end)/Uknown,Y.Data(:,end,end)/del.Data(:,end,end),'-b','LineWidth',2)
title('u(y)/Ue @ last x and t')
xlabel('u/Ue')
ylabel('y/\delta')

%Velocity Contour
xout = [];
for i = 1:n
    xout = [xout; xBL];
end
figure()
[cv,ch] = contourf(xout,Y.Data(:,:,end),u.Data(:,:,end),100);
set(ch,'edgecolor','none');
colormap('jet')
title('Velocity [ft/sec]')
xlabel('x [ft]')
ylabel('y [ft]')
caxis([min(min(u.Data(:,:,end))) max(max(u.Data(:,:,end)))])
colorbar

%Nusselt Number, HeatX Coeff., and Plate Surface Temp. Movie
axesPosition = [250 50 400 370];  %# Axes position, in pixels
yWidth = 60;                      %# y axes spacing, in pixels
xLimit = [min(x) max(x)];         %# Range of x values
xOffset = -yWidth*diff(xLimit)/axesPosition(3);
fig2 = figure('Units','pixels','Position',[200 200 700 460]);
h1 = axes('Units','pixels','Position',axesPosition,...
          'Color','w','XColor','k','YColor','r',...
          'XLim',xLimit,'YLim',[-300 300],'NextPlot','add');
h2 = axes('Units','pixels','Position',axesPosition+yWidth.*[-1 0 1 0],...
          'Color','none','XColor','k','YColor','m',...
          'XLim',xLimit+[xOffset 0],'YLim',[-5 20]*10^-4,...
          'XTick',[],'XTickLabel',[],'NextPlot','add');
h3 = axes('Units','pixels','Position',axesPosition+yWidth.*[-2 0 2 0],...
          'Color','none','XColor','k','YColor','b',...
          'XLim',xLimit+[2*xOffset 0],'YLim',[500 800],...
          'XTick',[],'XTickLabel',[],'NextPlot','add');
h4 = axes('Units','pixels','Position',axesPosition+yWidth.*[-3 0 3 0],...
          'Color','none','XColor','k','YColor','g',...
          'XLim',xLimit+[3*xOffset 0],'YLim',[0 300],...
          'XTick',[],'XTickLabel',[],'NextPlot','add');
xlabel(h1,'Location Along Plate [ft]');
ylabel(h1,'Nusselt Number, Nu');
ylabel(h2,'Heat Transfer Coefficient, h [Btu/(sec-ft^2-^oR)]');
ylabel(h3,'Wall Temperature, T_w [^oR]');
ylabel(h4,'Temperature Difference, T_w - T_e [^oR]');
vidObj = VideoWriter('LamBLheatXMovie.mp4','MPEG-4');
vidObj.FrameRate = 20;
open(vidObj);
j = 0;
for i = 1:length(TwmTe.Time)
    %Plot
    plot(h1,xBL,Nu.Data(1,:,i),'r');
    plot(h2,xBL,h.Data(1,:,i),'m');
    plot(h3,x,Tplate.Data(1,:,i),'b');
    plot(h4,xBL,TwmTe.Data(i,:),'g');
    %Add Time as text
    Time = [num2str(TwmTe.Time(i)),'sec'];
    TT = text(0.5,25,['Time: ',Time]);
    TT.FontSize = 14;
    %Get frame and write to movie
    currFrame = getframe(fig2);
    writeVideo(vidObj,currFrame)
    cla(h4)
    cla(h3)
    cla(h2)
    cla(h1)
end
close(vidObj);