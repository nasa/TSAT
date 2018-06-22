% run_PipeHeatX.m =====================================================%

% Written By: Jonathan Kratz (NASA GRC)
% Date: 12/15/2017
% Description: This script populates the workspace for the
%   RadBtwPlatesEx.slx model to run, executes the model, and displays the 
%   results. The results are shown in the form of a generated movie.

close all
clear all
clc

% Define workspace variables ---------------------------------------------%

% simulation props
dt = 5; %time-step [sec]
tsim = 86400/2; %simulation time [sec]

% radiation with earth
Tsink_earth = 464.4; %sink temperature of Earth
eps_earth = 0.5; %emissivity of earth

% radiation with space
Tsink_space = 4.9; %sink temperature if space [R]
eps_space = 1; %emissivty of space

% structure properties
x1 = linspace(0,0.25/12,20);
x2 = x1;
To1 = 500*ones(length(x1),1)'; %initial temperature [R]
To2 = 500*ones(length(x2),1)'; %initial temperature [R]
k = 0.0328*ones(length(x1),1)'; %Thermal Conductivity [Btu/(sec-ft-R)]
Cp = 6.92*ones(length(x1),1)'; %Heat Capcity [Btu/(slug-R)]
rho = 5.238864896*ones(length(x1),1)'; %Density [slug/ft^3]
eps = 0.07; %emissivity

% Run Model --------------------------------------------------------------%

sim('RadBtwPlatesEx.slx')

% Plot Results -----------------------------------------------------------%

%Temperature Profile Movie
fig1 = figure();
vidObj = VideoWriter('TempProfile.mp4','MPEG-4');
vidObj.FrameRate = 20;
open(vidObj);
j = 1;
for i = 1:length(T1.Time)
    if i == 1 || T1.Time(i) > 480*j
    %Plot
    plot(x1*12,T1.Data(1,:,i),'-b','LineWidth',2);
    hold on
    plot(x2*12,T2.Data(1,:,i),'-r','LineWidth',2);
    hold off
    title('Temperature Profile')
    xlabel('x [in]')
    ylabel('T [^oR]')
    axis([x1(1)*12 x1(end)*12 0 550]);
    legend('Plate 1','Plate 2',2)
    grid on
    %Add Time as text
    Time = [num2str(T1.Time(i)),'sec'];
    TT = text(0.05,50,['Time: ',Time]);
    TT.FontSize = 14;
    %Get frame and write to movie
    currFrame = getframe(fig1);
    writeVideo(vidObj,currFrame)
    j = j + 1;
    end
end
close(vidObj);