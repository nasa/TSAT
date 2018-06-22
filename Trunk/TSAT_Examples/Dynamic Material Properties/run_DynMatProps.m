% run_DynMatProps.m ======================================================%

% Written By: Jonathan Kratz (NASA GRC)
% Date: 12/21/2017
% Description: This script populates the workspace for the
%   DynMatProps.slx model to run, executes the models, and displays the 
%   results. The results are shown in the form of a generated movie of the
%   temperature profile. The modeled problem is conduction into an infinite
%   planar object with a square cross-section of length 12in.

close all
clear all
clc

% Define workspace variables ---------------------------------------------%

% Simulation Time-Step
dt = 1; %Time-step [sec]
tsim = 250; %Simulation time [sec]

% Boundary Conditions
hb = 0.05; %convective heat transfer coefficient on bottom surface [Btu/(sec-ft^2-R)]
Tb = 1000; %temperature of fluid on the bottom surface [R]
ht = 0.05; %convective heat transfer coefficient on top surface [Btu/(sec-ft^2-R)]
Tt = 1000; %temperature of fluid on the top surface [R]
hl = 0.05; %convective heat transfer coefficient on left surface [Btu/(sec-ft^2-R)]
Tl = 1000; %temperature of fluid on the left surface [R]
hr = 0.05; %convective heat transfer coefficient on right surface [Btu/(sec-ft^2-R)]
Tr = 1000; %temperature of fluid on the right surface [R]

% Materal Properties (Aluminum 7075)
Tk_data = [259.7 359.7 559.7 659.7 859.7 1059.7 1259.7];
k_data = [0.013888889 0.016388889 0.020277778 0.022222222 0.027777778 0.029166667 0.027777778]; %thermal conductivity [Btu/(sec-ft-R)]
TCp_data = [259.7 359.7 559.7 659.7 859.7 1059.7 1259.7];
Cp_data = [4.8261 5.46958 6.4348 6.981758 7.56089 8.0435 8.68698]; %heat capacity [Btu/(sec-ft-R)]
rho = 15.2; %density [slug/ft^3]
k = 0.02; %thermal conductivity for constant prop ex. [Btu/(sec-ft-R)]
Cp = 6.43; %heat capacity for constant prop ex. [Btu/(slug-R)]

% 1-D vars
y0 = linspace(0,12/12,20); %discretization in the y-direction
m = length(y0); %number of rows of nodes
k1d = k*ones(length(y0),1)'; %Thermal Conductivity [Btu/(sec-ft-R)]
Cp1d = Cp*ones(length(y0),1)'; %Heat Capcity [Btu/(slug-R)]
rho1d = rho*ones(length(y0),1)'; %Density [slug/ft^3]
T01d = 260*ones(length(y0),1)'; %Initial Temperature [R]

% 2-D vars
x  = linspace(0,12/12,20);% + 1/12; %discretization of flat plate along it's length [ft]
n = length(x); %number of elements in x
y = [];
for i = 1:length(x)
    y = [y y0']; %fill in y-matrix to define the discretization of the rectangular cross-section
end
k2d = k*ones(length(y0),length(x)); %Thermal Conductivity [Btu/(sec-ft-R)]
Cp2d = Cp*ones(length(y0),length(x)); %Heat Capcity [Btu/(slug-R)]
rho2d = rho*ones(length(y0),length(x)); %Density [slug/ft^3]
T02d = [];
for j = 1:length(x)
    T02d = [T02d T01d']; %Initial Temperature [R]
end

% Run Model --------------------------------------------------------------%

sim('DynMatProps.slx')

% Plot Results -----------------------------------------------------------%

%x matrix for contour plotting
X = [];
for i = 1:length(y0)
    X = [X; x];
end

%Max and min temperatures for setting colormap scales
Tmin = min(min(min(T2d_dyn.Data)));
Tmax = max(max(max(T2d_dyn.Data)));
kmin = min(min(min(k_dyn.Data)));
kmax = max(max(max(k_dyn.Data)));
Cpmin = min(min(min(Cp_dyn.Data)));
Cpmax = max(max(max(Cp_dyn.Data)));

%Temperature Profile Movie
fig1 = figure('Position',[100 100 1200 500]);
vidObj = VideoWriter('DynMatPropsMovie.mp4','MPEG-4');
vidObj.FrameRate = 5;
open(vidObj);
j = 1;
for i = 1:length(T2d_dyn.Time)
    if i == 1 || T2d_dyn.Time(i) > 5*j
    %Plot
    subplot(1,3,1)
    [C,h] = contourf(X*12,y*12,k_dyn.Data(:,:,i),100);
    set(h,'LineColor','none')
    title('Thermal Conductivity [Btu/(sec-ft-^oR)]')
    xlabel('x [in]')
    ylabel('y [in]')
    colormap('jet')
    colorbar
    caxis([kmin kmax])
    axis([min(x)*12 max(x)*12 min(min(y))*12 max(max(y))*12]);
    subplot(1,3,2)
    [C,h] = contourf(X*12,y*12,Cp_dyn.Data(:,:,i),100);
    set(h,'LineColor','none')
    title('Heat Capacity [Btu/(slug-^oR)]')
    xlabel('x [in]')
    ylabel('y [in]')
    colormap('jet')
    colorbar
    caxis([Cpmin Cpmax])
    axis([min(x)*12 max(x)*12 min(min(y))*12 max(max(y))*12]);
    subplot(1,3,3)
    [C,h] = contourf(X*12,y*12,T2d_dyn.Data(:,:,i),100);
    set(h,'LineColor','none')
    title('Temperature Profile [^oR]')
    xlabel('x [in]')
    ylabel('y [in]')
    colormap('jet')
    colorbar
    caxis([Tmin Tmax])
    axis([min(x)*12 max(x)*12 min(min(y))*12 max(max(y))*12]);
    %Add Time as text
    Time = [num2str(T2d_dyn.Time(i)),'sec'];
    TT = text(x(end)*12/5,y0(end)*12/5,['Time: ',Time]);
    TT.FontSize = 14;
    %Get frame and write to movie
    currFrame = getframe(fig1);
    writeVideo(vidObj,currFrame)
    j = j + 1;
    end
end
close(vidObj);