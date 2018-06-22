% run_HeatX2DShapeOpts.m =================================================%

% Written By: Jonathan Kratz (NASA GRC)
% Date: 12/21/2017
% Description: This script populates the workspace for the
%   HeatX2DShapeOpts model to run, executes the models, and displays the 
%   results. The results are shown in the form of a movie that compares
%   the temperature solution for the same cross-section with the 3 
%   different shape options. The modeled problem is conduction into the
%   object with a square cross-section of length 12in. The entire
%   domain is at an initial temperature of 550R and is heated by a source
%   at 850R with a heat transfer coefficient of 0.05Btu/(sec-ft^2-R) on all
%   sides. The structure is made of aluminum and all material properties
%   are assumed to be constant. The 3 considered options are:
%       (1) planar in both directions
%       (2) axi-symmetric in x-dir, planar in y-dir (revolved about x-axis)
%       (3) planar in x-dir, axi-symmetric in y-dir (revolved about y-axis) 

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
y0 = linspace(0,12/12,20)+6/12; %discretization in the y-direction
    %Note the offset of 6in in the y variable.
m = length(y0); %number of rows of nodes
k1d = k*ones(length(y0),1)'; %Thermal Conductivity [Btu/(sec-ft-R)]
Cp1d = Cp*ones(length(y0),1)'; %Heat Capcity [Btu/(slug-R)]
rho1d = rho*ones(length(y0),1)'; %Density [slug/ft^3]
T01d = 550*ones(length(y0),1)'; %Initial Temperature [R]

% 2-D vars
x  = linspace(0,12/12,20)+6/12;% + 1/12; %discretization of flat plate along it's length [ft]
    %Note the offset of 6in in the x variable.
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

sim('HeatX2DShapeOpts.slx')

% Plot Results -----------------------------------------------------------%

%x matrix for contour plotting
X = [];
for i = 1:length(y0)
    X = [X; x];
end

%Max and min temperatures for setting colormap scales
Tmin = min([min(min(min(T2d_planar.Data))) min(min(min(T2d_axiy.Data))) min(min(min(T2d_axix.Data)))]);
Tmax = max([max(max(max(T2d_planar.Data))) max(max(max(T2d_axiy.Data))) max(max(max(T2d_axix.Data)))]);

%Temperature Profile Movie
fig1 = figure('Position',[100 100 1600 500]);
vidObj = VideoWriter('HeatX2DShapeOptsMovie.mp4','MPEG-4');
vidObj.FrameRate = 5;
open(vidObj);
j = 1;
for i = 1:length(T2d_planar.Time)
    if i == 1 || T2d_planar.Time(i) > 5*j
    %Plot
    subplot(1,3,1)
    [C,h] = contourf(X*12,y*12,T2d_planar.Data(:,:,i),100);
    set(h,'LineColor','none')
    title('Temperature Profile [^oR] (Planar)')
    xlabel('x [in]')
    ylabel('y [in]')
    colormap('jet')
    colorbar
    caxis([Tmin Tmax])
    axis([min(x)*12 max(x)*12 min(min(y))*12 max(max(y))*12]);
    subplot(1,3,2)
    [C,h] = contourf(X*12,y*12,T2d_axix.Data(:,:,i),100);
    set(h,'LineColor','none')
    title('Temperature Profile [^oR] (Revolved about x-axis)')
    xlabel('x [in]')
    ylabel('y [in]')
    colormap('jet')
    colorbar
    caxis([Tmin Tmax])
    axis([min(x)*12 max(x)*12 min(min(y))*12 max(max(y))*12]);
    subplot(1,3,3)
    [C,h] = contourf(X*12,y*12,T2d_axiy.Data(:,:,i),100);
    set(h,'LineColor','none')
    title('Temperature Profile [^oR] (Revolved about y-axis)')
    xlabel('x [in]')
    ylabel('y [in]')
    colormap('jet')
    colorbar
    caxis([Tmin Tmax])
    axis([min(x)*12 max(x)*12 min(min(y))*12 max(max(y))*12]);
    %Add Time as text
    Time = [num2str(T2d_planar.Time(i)),'sec'];
    TT = text(8,8,['Time: ',Time]);
    TT.FontSize = 14;
    %Get frame and write to movie
    currFrame = getframe(fig1);
    writeVideo(vidObj,currFrame)
    j = j + 1;
    end
end
close(vidObj);