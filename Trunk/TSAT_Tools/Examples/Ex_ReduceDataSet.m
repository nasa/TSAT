% Ex_ReduceDataSet.m ==================================================%

% Written By: Jonathan Kratz
% Date: January 2, 2018
% Description: This script illustrates the usage of the "ReduceDataSet.m"
% function.This is a general-use tool. It is useful when dealing with 
% oversized data structures. For instance, if time-dependent data is 
% being used to drive a TSAT simulation (or other simulation for that 
% matter) and the data is supplied at a frequency that is unnecessary large
% (very small time-step) then the "ReduceDataSet.m" function can be used to
% reduce the data set to be more constitent with a prescribed time-step.
% Reducing the size of the data structure may be necessary or could help to
% improve simulation time. To illustrate this a set of data (t,y) will be
% created to resemble a sine functon being sampled at time intervals of
% 0.001sec. Then the data set will be reduced by the function to time
% intervals of approximately 0.1sec.

close all
clear all
clc

% create high sample frequency data (t,y)
t = [0:0.001:2*pi];
y = sin(8*t);

% reduce the data set
[T,Y] = ReduceDataSet( t,y,0.1 );

% plot results
plot(t,y,'-b','LineWidth',2)
hold on
plot(T,Y,'--r','LineWidth',2)
hold off
xlabel('Time [sec]')
ylabel('y')
legend('Original Data','Reduced Data',0)
xlim([t(1),t(end)])

% number of data points
fprintf('Number of original data points: %-5.0i\n',length(y))
fprintf('Number of data points in the reduced data set: %-5.0i\n',length(Y))