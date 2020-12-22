function [maxncc, tde] = tdefullneg2D(largedata, smalldata)
    %inputs must samples x 3 ; so like column vectors
    largedata(~largedata) = 0.00001; %replacing zeros by small numbers
    smalldata(~smalldata) = 0.00001;
    largesize = size(largedata,1);
    smallsize = size(smalldata,1);
    width = size(smalldata,2);
    padding = (largesize - smallsize)/2;

    if mod(padding*2,2) == 1
        disp(['Padding not allowed: ', num2str(padding), '! [Input data (both large and small) must have odd length.]'])
        return
    end
    
%     smalldata = [zeros(padding,width); smalldata; zeros(padding,width)];

%     [ncc, lags] = xcorr(largedata, smalldata, padding, 'coeff'); % 'coeff'
%     lags = lags - padding;
%     ncc %this gives uncorrect peak, cross correlation doesn't give peak,
%     normalized cross correlation does
    
%     [ncc, lags] = xcorr(largedata, smalldata, padding, 'none'); % 'coeff'
%     lags = lags - padding;
    
%     for i = 1:length(ncc)
%         ncc(i) = ncc(i) / sqrt(sum(smalldata .^ 2) * sum(largedata((end-smallsize+1 : end)+lags(i)).^2));
%     end

    cc = xcorr2(largedata,smalldata);
    cc = cc(smallsize:end-smallsize+1,width);
    divlargedata = sum(movsum(largedata.^2,[smallsize-1 0]),2);
    divlargedata = sqrt(divlargedata(smallsize:end));
    
    displacement = smallsize-largesize:0;
    ncc = cc / sqrt(sum(smalldata(:) .^ 2)) ./ divlargedata; %normalizing
    
    maxncc = max(ncc);
    idxs = find( ncc == maxncc );
    tde = displacement(idxs(end));
    
% 	divlargedata = movsum(largedata .^ 2, [smallsize-1 0]);
%     ncc = ncc / sqrt(sum(smalldata .^ 2)) ./ sqrt(divlargedata(smallsize:end)); %normalizing

    %ncc
%     maxncc = max(ncc);
%     idxs = find( ncc == maxncc );
%     tde = lags(idxs(end));
%     maxncc = maxncc / sqrt(sum(smalldata .^ 2) * sum(largedata((end-smallsize+1 : end)+tde).^2));   
    %rightmost index is zero and as we move to left index/displacement
    %decreases by 1 so index are like [-3 -2 -1 0] index of first element
    %of smalldata in large data from right side
    %if there are two indices with same max, max gives the leftmost one
    %we consider shifts and indices from the right not the center, indices
    %starting from zero
end