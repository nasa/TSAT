% run_PipeHeatX.m =====================================================%

% Written By: Jonathan Kratz (NASA GRC)
% Date: 12/15/2017
% Description: This script populates the workspace for the
%   PipeHeatX.slx model to run, executes the model, and displays the 
%   results. The results are shown in the form of a generated movies and
%   plots.

close all
clear all
clc

% Define workspace variables ---------------------------------------------%

% simulation props
dt = 0.02; %time-step [sec]
tsim = 50; %simulation time [sec]

% Inner Fluid (Water)
Tin = 654; %temperature [R]
rhoin = 1.94; %density [slug/ft^3]
Cpin = 32.3*778.169; %heat capcity [lbf-ft/(slug-R)]
muin = 1.86*10^-5; %viscosity [slug/(ft-sec)]
kin = 0.0001076*778.169; %thermal conductivity [lbf-ft/(sec-ft-R)]
velin = 1; %velocity [ft/sec]

% Outer Fluid (Air)
Tout = 460; %temperature [R]
rhoout = 0.00237; %density [slug/ft^3]
velout = 50; %velocity [ft/sec]

% structure properties
r = linspace(1/12,1.5/12,20);
Din = r(1)*2;
Dout = r(end)*2;
To = 550*ones(length(r),1)'; %initial temperature [R]
k = 0.0328*ones(length(r),1)'; %Thermal Conductivity [Btu/(sec-ft-R)]
Cp = 6.92*ones(length(r),1)'; %Heat Capcity [Btu/(slug-R)]
rho = 5.238864896*ones(length(r),1)'; %Density [slug/ft^3]

% Run Model --------------------------------------------------------------%

sim('PipeHeatX.slx')

% Plot Results -----------------------------------------------------------%

%Temperature Profile Movie
fig1 = figure();
vidObj = VideoWriter('TempProfile.mp4','MPEG-4');
vidObj.FrameRate = 20;
open(vidObj);
j = 1;
for i = 1:length(T.Time)
    if i == 1 || T.Time(i) > 1*j
    %Plot
    plot(r*12,T.Data(1,:,i),'-b','LineWidth',2);
    title('Temperature Profile')
    xlabel('r [in]')
    ylabel('T [^oR]')
    axis([r(1)*12 r(end)*12 450 700]);
    grid on
    %Add Time as text
    Time = [num2str(T.Time(i)),'sec'];
    TT = text(1.05,500,['Time: ',Time]);
    TT.FontSize = 14;
    %Get frame and write to movie
    currFrame = getframe(fig1);
    writeVideo(vidObj,currFrame)
    j = j + 1;
    end
end
close(vidObj);