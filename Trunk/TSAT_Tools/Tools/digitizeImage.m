function [ x,y ] = digitizeImage( imageFile )
%digitizeImage summary
%   This function plots an image provided by a .jpg file. Points from the
%   image can be extracted and scaled appropiately. If desired the selected
%   points can be connected via a cubic spline. This function is useful for
%   extracting data from images and approximating complex shapes from
%   images.
%
%Inputs:
%   imageFile - name of the image file as a string (Ex. 'image.jpg')
%Outpus:
%   x - scaled x-coordinates of the selected points
%   y - scaled y-coordinates of the selected points

%load and plot picture
imageData = imread(imageFile);
imagesc(imageData);
axis equal
xlabel('pixels in x-direction')
ylabel('pixels in y-direction')
hold on
imageData = imageData(:,:,1); %reduse the RGB into just any one component for digitization

%Origin
fprintf('Indicate the pixel position on the picture that corresponds to the origin: ');
[x0 y0] = ginput(1);
fprintf('[%-5.4f %-5.4f]\n',x0,y0);

%Digitize the picture
fprintf('Indicate a pixel position on the picture (not on the x or y-axis) that corresponds to known coordinate values:');
[x1 y1] = ginput(1);
fprintf('[%-5.4f %-5.4f]\n',x1,y1);
val = input('Coordinates of the selected pixel (ex. [1 2]): ');
xratio = val(1)/(x1-x0);
yratio = val(2)/-(y1-y0);

%Select Points
splineOpt = input('Do you wish to connect your selected data points with a spline (y/n)? ','s');
disp('Select the points you wish to extract and press enter when finished.')
XD = [];
YD = [];
iter = 1;
w = 0;
while w == 0
    if w == 0
        [X Y] = ginput(1);
        plot(X,Y,'xk')
        XD = [XD X];
        YD = [YD Y];
        if iter > 1
            [XD,ind] = sort(XD,2,'ascend');
            YDtemp = zeros(1,length(ind));
            for i = 1:length(ind)
                YDtemp(i) = YD(ind(i));
            end
            YD = YDtemp;
            if splineOpt == 'y'
                if iter > 2
                    children = get(gca, 'children');
                    delete(children(2));
                end
                c = CubicSpline( XD, YD, [] );
                XDspline = linspace(XD(1),XD(end),20*length(XD));
                YDspline = CubicSplineInterp ( XD,c,XDspline,0 );
                plot(XDspline,YDspline,'-b');
            end
        end
        iter = iter + 1;
        w = waitforbuttonpress;
    end
end

%Scale the coordinates of the selected points
x = (XD-x0)*xratio;
y = -(YD-y0)*yratio;