% run_HeatX2DRect.m ======================================================%

% Written By: Jonathan Kratz (NASA GRC)
% Date: 12/21/2017
% Description: This script populates the workspace for the
%   HeatX2DRect_ADI.slx and HeatX2DRect_Implicit.slx models to run, 
%   executes the models, and displays the results. The results are shown in
%   the form of execution times to illustrate the difference in 
%   computational efficiency in the 2 methods and a generated movie of the
%   temperature profile. The modeled problem is conduction into an infinite
%   planar object with a square cross-section of length 12in. The entire
%   domain is at an initial temperature of 550R and is heated by a source
%   at 850R with a heat transfer coefficient of 0.05Btu/(sec-ft^2-R) on all
%   sides. The structure is made of aluminum and all material properties
%   are assumed to be constant.

close all
clear all
clc

% Define workspace variables ---------------------------------------------%

% Simulation Time-Step
dt = 1; %Time-step [sec]
tsim = 250; %Simulation time [sec]

% Boundary Conditions
hb = 0.05; %convective heat transfer coefficient on bottom surface [Btu/(sec-ft^2-R)]
Tb = 850; %temperature of fluid on the bottom surface [R]
ht = 0.05; %convective heat transfer coefficient on top surface [Btu/(sec-ft^2-R)]
Tt = 850; %temperature of fluid on the top surface [R]
hl = 0.05; %convective heat transfer coefficient on left surface [Btu/(sec-ft^2-R)]
Tl = 850; %temperature of fluid on the left surface [R]
hr = 0.05; %convective heat transfer coefficient on right surface [Btu/(sec-ft^2-R)]
Tr = 850; %temperature of fluid on the right surface [R]
k = 0.0328; %thermal conductivity [Btu/(sec-ft-R)]
Cp = 6.92; %heat capacity [Btu/(sec-ft-R)]
rho = 5.238864896; %density [slug/ft^3]

% 1-D vars
y0 = linspace(0,12/12,20); %discretization in the y-direction
m = length(y0); %number of rows of nodes
k1d = k*ones(length(y0),1)'; %Thermal Conductivity [Btu/(sec-ft-R)]
Cp1d = Cp*ones(length(y0),1)'; %Heat Capcity [Btu/(slug-R)]
rho1d = rho*ones(length(y0),1)'; %Density [slug/ft^3]
T01d = 550*ones(length(y0),1)'; %Initial Temperature [R]

% 2-D vars
x  = linspace(0,12/12,20);% + 1/12; %discretization of flat plate along it's length [ft]
n = length(x); %number of elements in x
y = [];
for i = 1:length(x)
    y = [y y0']; %fill in y-matrix to define the discretization of the rectangular cross-section for contour plot
end
k2d = k*ones(length(y0),length(x)); %Thermal Conductivity [Btu/(sec-ft-R)]
Cp2d = Cp*ones(length(y0),length(x)); %Heat Capcity [Btu/(slug-R)]
rho2d = rho*ones(length(y0),length(x)); %Density [slug/ft^3]
T02d = [];
for j = 1:length(x)
    T02d = [T02d T01d']; %Initial Temperature [R]
end

% Run Model --------------------------------------------------------------%

tic
sim('HeatX2DRect_ADI.slx')
exec_time_adi = toc;

tic
sim('HeatX2DRect_Implicit.slx')
exec_time_implicit = toc;

% Plot Results -----------------------------------------------------------%

%execution time comparison
disp('Model Execution Time (includes initialization time)')
fprintf('ADI method: %-5.4fsec\n',exec_time_adi)
fprintf('Implicit method: %-5.4fsec\n',exec_time_implicit)

%x matrix for contour plotting
X = [];
for i = 1:length(y0)
    X = [X; x];
end

%Max and min temperatures for setting colormap scales
Tmin = min([min(min(min(T2d_adi.Data))) min(min(min(T2d_imp.Data)))]);
Tmax = max([max(max(max(T2d_adi.Data))) max(max(max(T2d_imp.Data)))]);

%Temperature Profile Movie
fig1 = figure('Position',[100 100 1200 500]);
vidObj = VideoWriter('HeatX2DRectMovie.mp4','MPEG-4');
vidObj.FrameRate = 5;
open(vidObj);
j = 1;
for i = 1:length(T2d_adi.Time)
    if i == 1 || T2d_adi.Time(i) > 5*j
    %Plot
    subplot(1,2,1)
    [C,h] = contourf(X*12,y*12,T2d_adi.Data(:,:,i),100);
    set(h,'LineColor','none')
    title('Temperature Profile [^oR] (ADI)')
    xlabel('x [in]')
    ylabel('y [in]')
    colormap('jet')
    colorbar
    caxis([Tmin Tmax])
    axis([min(x)*12 max(x)*12 min(min(y))*12 max(max(y))*12]);
    subplot(1,2,2)
    [C,h] = contourf(X*12,y*12,T2d_imp.Data(:,:,i),100);
    set(h,'LineColor','none')
    title('Temperature Profile [^oR] (Implicit)')
    xlabel('x [in]')
    ylabel('y [in]')
    colormap('jet')
    colorbar
    caxis([Tmin Tmax])
    axis([min(x)*12 max(x)*12 min(min(y))*12 max(max(y))*12]);
    %Add Time as text
    Time = [num2str(T2d_adi.Time(i)),'sec'];
    TT = text(x(end)*12/5,y0(end)*12/5,['Time: ',Time]);
    TT.FontSize = 14;
    %Get frame and write to movie
    currFrame = getframe(fig1);
    writeVideo(vidObj,currFrame)
    j = j + 1;
    end
end
close(vidObj);