% run_PolyfitEx.m ========================================================%

% Written By: Jonathan Kratz (NASA GRC)
% Date: 12/13/2017
% Description: This script populates the workspace for the
%   Polyfit.slx model to run, executes the model, and plot display the 
%   results. The results are shown in the form of a generated movie which
%   shows how the polynomial fit changes over time. Also given is a plot
%   that shows how the polynomial coefficents change with time. The example
%   demonstrates a 6th degree polynomial fit to dynamically changing data.

close all
clear all
clc

% Define workspace variables ---------------------------------------------%

%
x  = [0 1 2   3 5   6 7 8 9 10];
y0 = [1 2 2.5 3 3.5 5 7 6 7 8];
X =  [0:0.1:10];

% Run Model --------------------------------------------------------------%

sim('PolyfitEx.slx')

% Plot Results -----------------------------------------------------------%

a.Data = permute(a.Data,[3,2,1]);

% Polynomial Coefficients
figure()
for i = 1:size(a.Data,2)
    LEG{i} = ['a',num2str(i-1)];
    plot(a.Time,a.Data(:,i,1),'LineWidth',2)
    hold on
end
hold off
xlabel('Time')
ylabel('Polynomial Coefficients, a')
legend(LEG,0)
grid on

% Polynomial Fit
fig1 = figure();
vidObj = VideoWriter('PolyfitExMovie.mp4','MPEG-4');
vidObj.FrameRate = 20;
open(vidObj);
for i = 1:length(y.Time)
    %Plot
    plot(x,ydata.Data(i,:),'xk','LineWidth',2);
    hold on
    plot(X,y.Data(i,:),'-b','LineWidth',2);
    hold off
    title('Polynomial Fit')
    xlabel('x')
    ylabel('y')
    axis([0 10 0 10]);
    grid on
    %Add Time as text
    Time = [num2str(y.Time(i)),'sec'];
    a = text(0.5,8,['Time: ',Time]);
    a.FontSize = 14;
    %Get frame and write to movie
    currFrame = getframe(fig1);
    writeVideo(vidObj,currFrame)
end
close(vidObj);