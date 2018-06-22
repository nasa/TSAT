% run_FluidEnergyBalEx.m =================================================%

% Written By: Jonathan Kratz (NASA GRC)
% Date: 12/22/2017
% Description: This script populates the workspace for the
%   FluidEnergyBalEx.slx model to run, executes the models, and displays 
%   the results. The modeled problem is heat addition into a flowing fluid
%   as a result of the hot surfaces it contacts. The high heat transfer
%   rate and relatively low mass flow rate of the fluid leads to
%   significant temperature rise in the fluid. See the
%   "FluidEnergyBalEx.slx" model for more description on the problem.

close all
clear all
clc

% Define workspace variables ---------------------------------------------%

% Dimension quantities
L = 5; %length of the flow path [ft]
N = 500; %number of discrete points
x = linspace(0,L,N); %discrete point in the flow path
dx = mean(diff(x)); %distance between discrete points

% Inlet flow props
mdot_in = 0.1; %mass flow rate [slug/sec]
T_in = 550; %temperature [R]

% Bleed flow props
x_bld = [1.5 3.5]; %location of the bleeds [ft]
mdot_bld = [0.02 -0.05]; %mass flow rates of the bleeds [slug/sec]
T_bld = [550 550]; %temperature of the bleeds [R]

% Surface propertes
Rc = linspace(0.625,1.15,N); %radius of the inner surface [ft]
Rd = 1.25*ones(1,N); %radius of the outer surface [ft]
Ac = 2*pi*Rc*dx; %area of the inner surface [ft^2]
Ad = 2*pi*Rd*dx; %area of the outer surface [ft^2]
Tc = linspace(650,1200,N); %temperature of the inner surface [R]
Td = linspace(600,750,N); %temperature of the outer surface [R]

hc = 10*ones(1,N); %heat transfer coefficient on inner surface [ft-lbf/(sec-ft^2-R)]
hd = 10*ones(1,N); %heat transfer coefficient on outer surface [ft-lbf/(sec-ft^2-R)]

% Initial temperature to initiate the block
T0 = 550*ones(1,N); %[R]

% Heat capacity of the fluid (air)
load('CpvTDataAir.mat'); %TData, CpData [R, Btu/(slug-R)]
CpData_M = CpData_M*778.169; %[ft-lbf/(slug-R)]

% Run Model --------------------------------------------------------------%

% Simulation
sim('FluidEnergyBalEx.slx')
TT = zeros(1,N);
for i = 1:N
    TT(i) = T(1,i,end);
end

% Plot Results -----------------------------------------------------------%

%Plots
figure()
plot(x,TT,'LineWidth',2);
xlabel('x [ft]')
ylabel('T [^oR]')
grid on