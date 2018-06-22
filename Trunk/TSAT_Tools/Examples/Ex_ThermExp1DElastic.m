% Ex_ThermExp1DElastic.m ==================================================%

% Written By: Jonathan Kratz
% Date: January 2, 2018
% Description: This script illustrates the usage of the 
% "ThermExp1DElastic.m" function. It performs the same task as the "Thermal
% Expansion 1D Elastic" block. In the example, Inconel 718 will be
% considered.

clear all
close all
clc

% thermal expansion coefficient data
T_data = [659.7, 859.7, 1059.7, 1359.7, 1459.7, 1659.7, 1859.7]; %temperature [R]
alpha_data = [0.0000071, 0.0000075, 0.0000077, 0.0000079, 0.000008, 0.0000084, 0.0000089]; %thermal expansion coefficient [1/R]
To = 700; %initial temperature [R]
Tf = 1800; %final temperature [R]
Lo = 1; %initial length of the object [ft]

% execute function
[ L ] = ThermExp1DElastic( T_data, alpha_data, To, Tf, Lo );

% display results
fprintf('Initial Length @ %-5.4fR: %-5.4fin\n',To,Lo*12)
fprintf('Final Length @ %-5.4fR: %-5.4fin\n',Tf,L*12)