% run_InterpolationEx.m ==================================================%

% Written By: Jonathan Kratz (NASA GRC)
% Date: 12/13/2017
% Description: This script populates the workspace for the
%   Interpolation.slx model to run, executes the model, and plots the
%   results. The 2-D and 3-D interpolation results are presented using a
%   surface plot. To visualize the results it may be necessary to use the 
%   "Rotate 3D" tool to change the perspective of the plot. The 3-D
%   interpolation results are demonstrated on a surface plot as a function
%   of x, and y only. The data is plotted at a constant z value consistent
%   with the value of z at the interpolated point. 

close all
clear all
clc

% Define workspace variables ---------------------------------------------%

% 1-D interpolation example: y = f(x)
xdata_1 = [0:0.1:10]; %x data
ydata_1 = sin(xdata_1) + 0.5*xdata_1; %y data
xint_1 = 5; %x interpolation point

% 2-D interpolation example: z = f(x,y)
xdata_2 = [0:0.1:10]; %x data
ydata_2 = [0:0.1:10]; %y data
for i = 1:length(xdata_2)
    for j = 1:length(ydata_2)
        zdata_2(i,j) = sin(xdata_2(i)) + sin(ydata_2(j)); %z data
    end
end
xint_2 = 5; %x interpolation point
yint_2 = 8; %y interpolation point

% 3-D interpolation example: v = f(x,y,z)
xdata_3 = [0:0.1:10]; %x data
ydata_3 = [0:0.1:10]; %y data
zdata_3 = [0:0.1:10]; %z data
for i = 1:length(xdata_3)
    for j = 1:length(ydata_3)
        for k = 1:length(zdata_3)
            vdata_3(i,j,k) = xdata_3(i) + ydata_3(j)^2 + zdata_3(i); %v data
        end
    end
end
xint_3 = 4; %x interpolation point
yint_3 = 5; %y interpolation point
ind = 71;
zint_3 = zdata_3(ind); %z interpolation point

% Run Model --------------------------------------------------------------%

sim('InterpolationEx.slx')

% Plot Results -----------------------------------------------------------%

% 1-D results
figure()
plot(xdata_1,ydata_1,'-b','LineWidth',2)
hold on
plot(xint_1,out1D.Data,'xk','LineWidth',2,'MarkerSize',10)
hold off
title('1-D Interpolation Results')
xlabel('x')
ylabel('y')
legend('Data','Interpolated Value',0)
grid on

% 2-D results
figure()
surface(xdata_2,ydata_2,zdata_2)
hold on
plot3(xint_2,yint_2,out2D.Data,'ok','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k')
hold off
title('2-D Interpolation Results')
xlabel('x')
ylabel('y')
zlabel('z')
legend('Data','Interpolated Value',0)
grid on

% 3-D results
figure()
surface(xdata_3,ydata_3,vdata_3(:,:,ind))
hold on
plot3(xint_3,yint_3,out3D.Data,'ok','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k')
hold off
title('3-D Interpolation Results')
xlabel('x')
ylabel('y')
zlabel(['v(x,y,',num2str(zdata_3(ind)),')'])
legend(['Data (v = f(x,y,',num2str(zdata_3(ind)),'))'],'Interpolated Value',0)
grid on