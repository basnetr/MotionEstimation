clc; clear all; close all

%RESULT OF TDE FULL ON BOTH SIDES - ALLOWING DISPLACEMENT ON NEG SIDES

load 'Im1.mat' %Pre compressed 1700x508
load 'Im2.mat' %Post compressed 1700x508
load 'Axial.mat' % 1620 x 478 % the disp. of the first 40 and last 40 samples and first 10 and last 10 A-lines is not calculated

smallWindow = 41; %41 is best
largeWindow = 3*smallWindow;
upScale = 4; stepSize = upScale;
k = 300;
tdeall = zeros(1700,1);
tdpeall = zeros(1700,1);
tic
tde = 0;
tdpe = 0;
prevtdpe = 0;


for i = largeWindow:1700
    data1 = Im1((i-smallWindow+1):i,k-4:k+4);
    data2 = Im2((i-largeWindow+1):i,k-4:k+4);
    data1 = resample(data1, upScale, 1); %1x510
    data2 = resample(data2, upScale, 1); %1x1010
   
    if i == largeWindow
        [maxncc, tde] = tdefullneg2D(data2,data1);
        tdpe = tde;
        maxnccp = maxncc;
        prevtdpe = tdpe;
    else
        [maxncc, tde] = tdefullneg2D(data2,data1);
        [maxnccp, tdpe] =  tdesmallneg2D(data2, data1, tdpe, round(2*stepSize));
    end
    
    if abs(tdpe - prevtdpe) > stepSize
        tdpe = round((3*tdpe + prevtdpe) / 4);
    end
    
    %if maxnccp < 0.9        % METHOD FAILS
    %	[maxnccp, tdpe] = tdefullneg(data2,data1);
    %end
    tdeall(i) = tde;
    tdpeall(i) = tdpe;
    prevtdpe = tdpe;
    disp(['i-Value: ', num2str(i), ' Max NCC = ', num2str(maxncc), ' Displacement = ' , num2str(tdpe/upScale)])
end
toc
plot(tdeall/upScale)  
hold on
plot(tdpeall/upScale) 
groundtruth = [zeros(40,1); Axial(:,k-10); zeros(40,1)];
hold on
plot(groundtruth)
