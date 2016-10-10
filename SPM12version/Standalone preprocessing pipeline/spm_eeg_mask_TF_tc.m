function spm_eeg_mask_TF_tc(S)
% function to create image mask. adapted from spm_eeg_mask to deal with TF
% data by Ed Sohoglu. Updated for SPM12 by T Cope

V = spm_vol(S.image);
Y = spm_read_vols(V);
Y = ~isnan(Y) & (Y~=0);

Nt = size(Y, 2);

begsample = inv(V.mat)*[0 S.timewin(1) 0 1]';
begsample = begsample(2);

endsample = inv(V.mat)*[0 S.timewin(2) 0 1]';
endsample = endsample(2);

if any([begsample endsample] < 0) || ...
        any([begsample endsample] > Nt)
    error('The window is out of limits for the image.');
end

[junk begsample] = min(abs(begsample-[1:Nt]));
[junk endsample] = min(abs(endsample-[1:Nt]));

if begsample > 1
    Y(: , 1:(begsample-1) , :)   = 0;
end

if endsample<size(Y, 2)
    Y(: , (endsample+1):end , :) = 0;
end

V.fname = S.outfile;

spm_write_vol(V, Y);