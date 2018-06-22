% run_ModularStruct.m ====================================================%

% Written By: Jonathan Kratz (NASA GRC)
% Date: 12/21/2017
% Description: This script populates the workspace for the
%   ModularStruct.slx models to run, executes the models, and displays the 
%   results. The results are shown in the form of a generated movie of the
%   temperature profile. The example illustrates a modular modeling 
%   technique that can be used with the TSAT tools to model heat 
%   transfer into a large complex structure by modeling and coupling
%   smaller parts together.

close all
clear all
clc

% Define workspace variables ---------------------------------------------%

% Simulation Time-Step
dt = 0.25; %Time-step [sec]
tsim = 250; %Simulation time [sec]

% Material Properties
k = 0.0328; %thermal conductivity [Btu/(sec-ft-R)]
Cp = 6.92; %heat capacity [Btu/(sec-ft-R)]
rho = 5.238864896; %density [slug/ft^3]

% Top part of the "T"
m_top = 8;
n_top = 22;
% -- 1d vars
y0_top = linspace(0,4/12,m_top); %discretization in the y-direction
k1d = k*ones(length(y0_top),1)'; %Thermal Conductivity [Btu/(sec-ft-R)]
Cp1d = Cp*ones(length(y0_top),1)'; %Heat Capcity [Btu/(slug-R)]
rho1d = rho*ones(length(y0_top),1)'; %Density [slug/ft^3]
T01d = 550*ones(length(y0_top),1)'; %Initial Temperature [R]
% -- 2d vars
x_top  = linspace(-7.5/12,7.5/12,n_top);% + 1/12; %discretization of flat plate along it's length [ft]
y_top = [];
for i = 1:length(x_top)
    y_top = [y_top y0_top']; %fill in y-matrix to define the discretization of the rectangular cross-section
end
k2d_top = k*ones(length(y0_top),length(x_top)); %Thermal Conductivity [Btu/(sec-ft-R)]
Cp2d_top = Cp*ones(length(y0_top),length(x_top)); %Heat Capcity [Btu/(slug-R)]
rho2d_top = rho*ones(length(y0_top),length(x_top)); %Density [slug/ft^3]
T02d_top = [];
for j = 1:length(x_top)
    T02d_top = [T02d_top T01d']; %Initial Temperature [R]
end

%Bottom Part of the "T"
m_bot = 20;
n_bot = 8;
% -- 1d vars
y0_bot = linspace(-11/12,0,m_bot); %discretization in the y-direction
k1d = k*ones(length(y0_bot),1)'; %Thermal Conductivity [Btu/(sec-ft-R)]
Cp1d = Cp*ones(length(y0_bot),1)'; %Heat Capcity [Btu/(slug-R)]
rho1d = rho*ones(length(y0_bot),1)'; %Density [slug/ft^3]
T01d = 550*ones(length(y0_bot),1)'; %Initial Temperature [R]
% -- 2d vars
x_bot  = linspace(-2.5/12,2.5/12,n_bot);% + 1/12; %discretization of flat plate along it's length [ft]
y_bot = [];
for i = 1:length(x_bot)
    y_bot = [y_bot y0_bot']; %fill in y-matrix to define the discretization of the rectangular cross-section
end
k2d_bot = k*ones(length(y0_bot),length(x_bot)); %Thermal Conductivity [Btu/(sec-ft-R)]
Cp2d_bot = Cp*ones(length(y0_bot),length(x_bot)); %Heat Capcity [Btu/(slug-R)]
rho2d_bot = rho*ones(length(y0_bot),length(x_bot)); %Density [slug/ft^3]
T02d_bot = [];
for j = 1:length(x_bot)
    T02d_bot = [T02d_bot T01d']; %Initial Temperature [R]
end

% Boundary Conditions
% -- top part
hb_top = 0.05; %convective heat transfer coefficient on bottom surface [Btu/(sec-ft^2-R)]
Tb_top = 850; %temperature of fluid on the bottom surface [R]
ht_top = 0.05; %convective heat transfer coefficient on top surface [Btu/(sec-ft^2-R)]
Tt_top = 850; %temperature of fluid on the top surface [R]
hl_top = 0.05; %convective heat transfer coefficient on left surface [Btu/(sec-ft^2-R)]
Tl_top = 850; %temperature of fluid on the left surface [R]
hr_top = 0.05; %convective heat transfer coefficient on right surface [Btu/(sec-ft^2-R)]
Tr_top = 850; %temperature of fluid on the right surface [R]
% -- bottom part
hb_bot = 0.05; %convective heat transfer coefficient on bottom surface [Btu/(sec-ft^2-R)]
Tb_bot = 850; %temperature of fluid on the bottom surface [R]
ht_bot = 0.05; %convective heat transfer coefficient on top surface [Btu/(sec-ft^2-R)]
Tt_bot = 850; %temperature of fluid on the top surface [R]
hl_bot = 0.05; %convective heat transfer coefficient on left surface [Btu/(sec-ft^2-R)]
Tl_bot = 850; %temperature of fluid on the left surface [R]
hr_bot = 0.05; %convective heat transfer coefficient on right surface [Btu/(sec-ft^2-R)]
Tr_bot = 850; %temperature of fluid on the right surface [R]
%-- BC variables
Conv_top_L = [Tl_top*ones(m_top,1) hl_top*ones(m_top,1)];
Conv_top_R = [Tr_top*ones(m_top,1) hr_top*ones(m_top,1)];
Conv_top_T = [Tt_top*ones(n_top,1) ht_top*ones(n_top,1)];
Conv_top_B = [Tb_top*ones(n_top,1) [hb_top*ones(7,1); zeros(8,1); hb_top*ones(7,1)]];
Cond_top_B_IC = [(10^-9)*ones(n_top,1) zeros(n_top,1)];
Conv_bot_L = [Tl_bot*ones(m_bot,1) hl_bot*ones(m_bot,1)];
Conv_bot_R = [Tr_bot*ones(m_bot,1) hr_bot*ones(m_bot,1)];
Conv_bot_B = [Tb_bot*ones(n_bot,1) hb_top*ones(n_bot,1)];
Cond_bot_T_IC = [(10^-9)*ones(n_bot,1) zeros(n_bot,1)];

% Run Model --------------------------------------------------------------%

sim('ModularStruct.slx')

% Plot Results -----------------------------------------------------------%

%x matrix for contour plotting
Xtop = [];
for i = 1:size(y_top,1)
    Xtop = [Xtop; x_top];
end
Xbot = [];
for i = 1:size(y_bot,1)
    Xbot = [Xbot; x_bot];
end

%Max and min temperatures for setting colormap scales
Tmin = min([min(min(min(T2d_top.Data))) min(min(min(T2d_bot.Data)))]);
Tmax = max([max(max(max(T2d_top.Data))) max(max(max(T2d_bot.Data)))]);

%Temperature Profile Movie
fig1 = figure('Position',[100 100 1200 500]);
vidObj = VideoWriter('ModularStuctMovie.mp4','MPEG-4');
vidObj.FrameRate = 5;
open(vidObj);
j = 1;
for i = 1:length(T2d_top.Time)
    if i == 1 || T2d_top.Time(i) > 5*j
    %Plot
    [C,h] = contourf(Xtop*12,y_top*12,T2d_top.Data(:,:,i),100);
    set(h,'LineColor','none')
    colormap('jet')
    hold on
    [C,h] = contourf(Xbot*12,y_bot*12,T2d_bot.Data(:,:,i),100);
    set(h,'LineColor','none')
    title('Temperature Profile [^oR]')
    xlabel('x [in]')
    ylabel('y [in]')
    colormap('jet')
    colorbar
    caxis([Tmin Tmax])
    axis([min(x_top)*12 max(x_top)*12 min(min(y_bot))*12 max(max(y_top))*12]);
    %Add Time as text
    Time = [num2str(T2d_top.Time(i)),'sec'];
    TT = text(3,1,['Time: ',Time]);
    TT.FontSize = 14;
    %Get frame and write to movie
    currFrame = getframe(fig1);
    writeVideo(vidObj,currFrame)
    j = j + 1;
    end
end
close(vidObj);