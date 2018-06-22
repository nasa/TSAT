% run_MatTransEx.m ======================================================%

% Written By: Jonathan Kratz (NASA GRC)
% Date: 12/15/2017
% Description: This script populates the workspace for the
%   MatTransEx.slx model to run, executes the model, and displays the 
%   results. The results are shown in the form of a generated movies that
%   shows how the temperature varies with time for both a 1-D and 2-D 
%   example with a material transition exemplified. The example shows the
%   use of a 1-D and 2-D heat transfer block, each modeling a structure
%   made of 2 different materials. Open the MatTransEx.slx model for a
%   description of the model problems.

close all
clear all
clc

% Define workspace variables ---------------------------------------------%

% Simulation Time-Step
dt = 2.5; %Time-step [sec]
tsim = 1000; %simulation time [sec]

% Boundary Conditions
hb = 0.05; %convective heat transfer coefficient on bottom surface [Btu/(sec-ft^2-R)]
Tb = 650; %temperature of fluid on the bottom surface [R]
ht = 0.05; %convective heat transfer coefficient on top surface [Btu/(sec-ft^2-R)]
Tt = 550; %temperature of fluid on the top surface [R]
hl = 0.05; %convective heat transfer coefficient on left surface [Btu/(sec-ft^2-R)]
Tl = 650; %temperature of fluid on the left surface [R]
hr = 0.05; %convective heat transfer coefficient on right surface [Btu/(sec-ft^2-R)]
Tr = 550; %temperature of fluid on the right surface [R]

% Material Properties
% -- material 1
k1 = 0.0328; %thermal conductivity [Btu/(sec-ft-R)]
Cp1 = 6.92; %heat capacity [Btu/(sec-ft-R)]
rho1 = 5.238864896; %density [slug/ft^3]
% -- material 2
k2 = 0.0013; %thermal conductivity [Btu/(sec-ft-R)]
Cp2 = 4; %heat capacity [Btu/(sec-ft-R)]
rho2 = 8.6; %density [slug/ft^3]

% 1-D vars
y0 = linspace(0,8/12,20); %discretization in the y-direction
m = length(y0);
k1d = k1*ones(length(y0),1)'; %Thermal Conductivity [Btu/(sec-ft-R)]
k1d(1:10) = k2*ones(10,1)';
Cp1d = Cp1*ones(length(y0),1)'; %Heat Capcity [Btu/(slug-R)]
Cp1d(1:10) = Cp2*ones(10,1)';
rho1d = rho1*ones(length(y0),1)'; %Density [slug/ft^3]
rho1d(1:10) = rho2*ones(10,1)';
T01d = 550*ones(length(y0),1)'; %Initial Temperature [R]

% 2-D vars
x  = linspace(0,8/12,20); %discretization of flat plate along it's length [ft]
n = length(x); %number of elements in x
y = [];
for i = 1:length(x)
    y = [y y0'];
end
k2d = k1*ones(length(y0),length(x)); %Thermal Conductivity [Btu/(sec-ft-R)]
k2d(1:10,1:10) = k2*ones(10,10);
Cp2d = Cp1*ones(length(y0),length(x)); %Heat Capcity [Btu/(slug-R)]
Cp2d(1:10,1:10) = Cp2*ones(10,10);
rho2d = rho1*ones(length(y0),length(x)); %Density [slug/ft^3]
rho2d(1:10,1:10) = rho2*ones(10,10);
T02d = [];
for j = 1:length(x)
    T02d = [T02d T01d']; %Initial Temperature [R]
end

% Run Model --------------------------------------------------------------%

sim('MatTransEx.slx')

% Plot Results -----------------------------------------------------------%

%Temperature Profile Movie 1D
fig1 = figure();
vidObj = VideoWriter('MatTrans1D.mp4','MPEG-4');
vidObj.FrameRate = 10;
open(vidObj);
j = 1;
for i = 1:length(T1d.Time)
    if i == 1 || T1d.Time(i) > 5*j
    %Plot
    plot(y0*12,T1d.Data(1,:,i),'-b','LineWidth',2)
    title('Temperature Profile')
    xlabel('y [in]')
    ylabel('T [^oR]')
    axis([0 y0(end)*12 500 850]);
    grid on
    %Add Time as text
    Time = [num2str(T1d.Time(i)),'sec'];
    TT = text(y0(end)*12/5,800,['Time: ',Time]);
    TT.FontSize = 14;
    %Get frame and write to movie
    currFrame = getframe(fig1);
    writeVideo(vidObj,currFrame)
    j = j + 1;
    end
end
close(vidObj);

X = [];
for i = 1:length(y0)
    X = [X; x];
end

Tmin = min(min(min(T2d.Data)));
Tmax = max(max(max(T2d.Data)));

%Temperature Profile Movie 2D
fig2 = figure();
vidObj = VideoWriter('MatTrans2D.mp4','MPEG-4');
vidObj.FrameRate = 10;
open(vidObj);
j = 1;
for i = 1:1:length(T2d.Time)
    if i == 1 || T2d.Time(i) >= 5*j
    %Plot
    [C,h] = contourf(X*12,y*12,T2d.Data(:,:,i),100);
    set(h,'LineColor','none')
    title('Temperature Profile [^oR]')
    xlabel('x [in]')
    ylabel('y [in]')
    colormap('jet')
    colorbar
    caxis([Tmin Tmax])
    axis([min(x)*12 max(x)*12 min(min(y))*12 max(max(y))*12]);
    %Add Time as text
    Time = [num2str(T2d.Time(i)),'sec'];
    TT = text(x(end)*12/5,y0(end)*12/5,['Time: ',Time]);
    TT.FontSize = 14;
    %Get frame and write to movie
    currFrame = getframe(fig2);
    writeVideo(vidObj,currFrame)
    j = j + 1;
    end
end
close(vidObj);