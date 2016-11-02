%A function for plotting two spm files against each other over time, with a
%t contrast for thresholding
%(assumes a -500 to 1500ms window, with 250Hz sampling)

function test_plot(spm1,spm2,statspm,nsubj,location,modality)

pathstem = ['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/stats_2sm_/combined_-100_900_' modality];

if strncmp(spm1,'con',3)
    Y1=spm_read_vols(spm_vol([pathstem '/' spm1 '.img']));
    Y2=spm_read_vols(spm_vol([pathstem '/' spm2 '.img']));
    Y3=spm_read_vols(spm_vol([pathstem '/' 'spm' statspm '.img']));
    
    Y1_data = spm_vol(spm_vol([pathstem '/' spm1 '.hdr']));
    Y2_data = spm_vol(spm_vol([pathstem '/' spm2 '.hdr']));
    Y3_data = spm_vol(spm_vol([pathstem '/' 'spm' statspm '.img']));

else
    Y1=spm_read_vols(spm_vol([pathstem '/' 'spm' spm1 '.img']));
    Y2=spm_read_vols(spm_vol([pathstem '/' 'spm' spm2 '.img']));
    Y3=spm_read_vols(spm_vol([pathstem '/' 'spm' statspm '.img']));
    
    Y1_data = spm_vol(spm_vol([pathstem '/' 'spm' spm1 '.hdr']));
    Y2_data = spm_vol(spm_vol([pathstem '/' 'spm' spm2 '.hdr']));
    Y3_data = spm_vol(spm_vol([pathstem '/' 'spm' statspm '.img']));

end
x_loc = round((location(1)-Y1_data.mat(1,4))/Y1_data.mat(1,1));
y_loc = round((location(2)-Y1_data.mat(2,4))/Y1_data.mat(2,2));

figure
plot(-500:4:1500,squeeze(squeeze(Y1(x_loc,y_loc,:))),'g','LineWidth',4)
hold on
plot(-500:4:1500,squeeze(squeeze(Y2(x_loc,y_loc,:))),'r','LineWidth',4)

threshold=tinv(0.95,(nsubj-2));
H = squeeze(squeeze(Y3(x_loc,y_loc,:)))>threshold;

jbfill(-500:4:1500,squeeze(Y1(x_loc,y_loc,:))',squeeze(Y2(x_loc,y_loc,:))',H','r','k',[],0.5);

titlestr = strsplit(Y3_data.descrip,':');
title([titlestr{2}(2:end) ' for ' modality ' at ' num2str(location)])

xlabel('ms')
if strcmp(modality,'MEGCOMB')
    ylabel('fT/mm')
elseif strcmp(modality,'MEGMAG')
    ylabel('fT')
elseif strcmp(modality,'EEG')
    ylabel('uV')
end