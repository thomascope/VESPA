function outdata = es_combineplanar3(indata)
% Version 3- handles data with frequency (optional), time, and condition dimensions

% Combines two channels (e.g. planar gradiometers) by taking RMS.
% This version replicates RMS for each channel in pair and so does not need to
% combine channel labels/positions e.g. input = MEG1, MEG2 output = MEG1+2

% Inputs...
% 'indata' = channel X (frequency) X time X condition data matrix (consecutive channels of 2 will be combined).

% Outputs...
% 'outdata' = combined data (with same dimensions as indata since RMS is stored in each channel of pair)

nchannels = size(indata,1);

for c=1:2:nchannels
    
    if ndims(indata) < 4 % if fewer than 3 dimensions (i.e. timedomain data)
  
        outdata(c,:,:) = sqrt((indata(c,:,:).^2 + indata(c+1,:,:).^2)/2);
        outdata(c+1,:,:) = outdata(c,:,:);
        
    else % time-frequency data
        
        outdata(c,:,:,:) = sqrt((indata(c,:,:,:).^2 + indata(c+1,:,:,:).^2)/2);
        outdata(c+1,:,:,:) = outdata(c,:,:,:);
      
    end
    
end