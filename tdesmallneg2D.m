function [maxncc, tde] = tdesmallneg2D(largedata, smalldata, prev_tde, stepsize)
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

%     smalldata = [zeros(1,padding), smalldata, zeros(1,padding)];
%     [ncc, lags] = xcorr(largedata, smalldata, padding, 'none');
%     lags = lags - padding;
    
%     divlargedata = movsum(largedata .^ 2, [smallsize-1 0]);
%     ncc = ncc / sqrt(sum(smalldata .^ 2)) ./ sqrt(divlargedata(smallsize:end)); %normalizing

    cc = xcorr2(largedata,smalldata);
    cc = cc(smallsize:end-smallsize+1,width);
    divlargedata = sum(movsum(largedata.^2,[smallsize-1 0]),2);
    divlargedata = sqrt(divlargedata(smallsize:end));

    displacement = smallsize-largesize:0;
    ncc = cc / sqrt(sum(smalldata(:) .^ 2)) ./ divlargedata; %normalizing
    
    %Difference from tdefull starts from here
    recenter = length(ncc) + prev_tde;
    if (recenter + stepsize) >  length(ncc)
        searchidx = recenter - stepsize : recenter;
    elseif (recenter - stepsize) <= 0
        searchidx = recenter; %: recenter + stepsize ;
    else
        searchidx = recenter - stepsize : recenter; % + stepsize;
    end

%     nccrange = ncc(searchidx);
%     maxncc = max(nccrange);
%     idxs = find( nccrange == maxncc );    
%     lagrange = lags(searchidx);
%     tde = lagrange(idxs(end));
    nccrange = ncc(searchidx);
    maxncc = max(nccrange);
    idxs = find( nccrange == maxncc );    
    disprange = displacement(searchidx);
    tde = disprange(idxs(end));
end