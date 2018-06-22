% run_HeatXTest2D.m ======================================================%

% Written By: Jonathan Kratz (NASA GRC)
% Date: 12/15/2017
% Description: This script populates the workspace for the
%   HeatXTest2D.slx model to run, executes the model, and displays the 
%   results. The results are shown in the form of a generated movie that
%   shows how the temperature along the thickness of a wall varies with
%   time. The 2-D solution is compared against the 1-D solution to verify
%   accurate transient and steady-state operation of the 2-D block. 

close all
clear all
clc

% Define workspace variables ---------------------------------------------%

% Simulation Time-Step
dt = 1; %Time-step [sec]
tsim = 800; %simulation time [sec]

% Boundary Conditions
hb = 0.03; %convective heat transfer coefficient on bottom surface [Btu/(sec-ft^2-R)]
Tb = 800; %temperature of fluid on the bottom surface [R]
ht = 0.03; %convective heat transfer coefficient on top surface [Btu/(sec-ft^2-R)]
Tt = 650; %temperature of fluid on the top surface [R]
k = 0.0328; %thermal conductivity [Btu/(sec-ft-R)]
Cp = 6.92; %heat capacity [Btu/(sec-ft-R)]
rho = 5.238864896; %density [slug/ft^3]

% 1-D vars
y0 = linspace(0,3/12,10); %discretization in the y-direction
k1d = k*ones(length(y0),1)'; %Thermal Conductivity [Btu/(sec-ft-R)]
Cp1d = Cp*ones(length(y0),1)'; %Heat Capcity [Btu/(slug-R)]
rho1d = rho*ones(length(y0),1)'; %Density [slug/ft^3]
T01d = 550*ones(length(y0),1)'; %Initial Temperature [R]

% 2-D vars
x  = linspace(0,2,30); %discretization of flat plate along it's length [ft]
n = length(x); %number of elements in x
y = [];
for i = 1:length(x)
    y = [y y0'];
end
k2d = k*ones(length(y0),length(x)); %Thermal Conductivity [Btu/(sec-ft-R)]
Cp2d = Cp*ones(length(y0),length(x)); %Heat Capcity [Btu/(slug-R)]
rho2d = rho*ones(length(y0),length(x)); %Density [slug/ft^3]
T02d = [];
for j = 1:length(x)
    T02d = [T02d T01d']; %Initial Temperature [R]
end

% Run Model --------------------------------------------------------------%

sim('HeatXTest2D.slx')

% Plot Results -----------------------------------------------------------%

%Temperature Profile Movie
fig1 = figure();
vidObj = VideoWriter('TempProfile.mp4','MPEG-4');
vidObj.FrameRate = 20;
open(vidObj);
j = 1;
for i = 1:length(T1d.Time)
    if i == 1 || T1d.Time(i) > 1*j
    %Plot
    plot(y0*12,T1d.Data(1,:,i),'-b','LineWidth',2);
    hold on
    plot(y0*12,T2d.Data(:,round(n/2),i),'--r','LineWidth',2);
    hold off
    title('Temperature Profile')
    xlabel('y [in]')
    ylabel('T [^oR]')
    legend('1-D','2-D',0)
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