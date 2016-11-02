%A function for plotting two spm files against each other over time, with a
%t contrast for thresholding
%(assumes a -500 to 1500ms window, with 250Hz sampling)

function test_plot_betas(whichbetas,contrast,statspm,nsubj,location,modality)

pathstem = ['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/stats_2sm_/combined_-100_900_' modality];

Y = cell(1,length(whichbetas));
for i = 1:length(whichbetas)
    if whichbetas(i) <10
        Y{i} = spm_read_vols(spm_vol([pathstem '/' 'beta_000' num2str(whichbetas(i)) '.img']));
    else
        Y{i} = spm_read_vols(spm_vol([pathstem '/' 'beta_00' num2str(whichbetas(i)) '.img']));
    end
end
if whichbetas(i) <10
    Y1_data = spm_vol(spm_vol([pathstem '/' 'beta_000' num2str(whichbetas(i)) '.img']));
else
    Y1_data = spm_vol(spm_vol([pathstem '/' 'beta_00' num2str(whichbetas(i)) '.img']));
end

Y3=spm_read_vols(spm_vol([pathstem '/' 'spm' statspm '.img']));
Y3_data = spm_vol(spm_vol([pathstem '/' 'spm' statspm '.img']));

x_loc = round((location(1)-Y1_data.mat(1,4))/Y1_data.mat(1,1));
y_loc = round((location(2)-Y1_data.mat(2,4))/Y1_data.mat(2,2));

toplot = zeros(1,size(Y{1},3));
for i = 1:length(contrast)
    Y{i} = Y{i}*contrast(i);
end

datatoplot = zeros(length(contrast),size(Y{1},3));
for i = 1:size(Y{1},3)
    
    for j = 1:length(contrast)
        datatoplot(j,i) = Y{j}(x_loc,y_loc,i);
    end
    
end

controltoplot = mean(datatoplot,1);
figure
plot(-500:4:1500,controltoplot,'g','LineWidth',4)
hold on

whichbetas = whichbetas+6;


Y = cell(1,length(whichbetas));
for i = 1:length(whichbetas)
    if whichbetas(i) <10
        Y{i} = spm_read_vols(spm_vol([pathstem '/' 'beta_000' num2str(whichbetas(i)) '.img']));
    else
        Y{i} = spm_read_vols(spm_vol([pathstem '/' 'beta_00' num2str(whichbetas(i)) '.img']));
    end
end
if whichbetas(i) <10
    Y1_data = spm_vol(spm_vol([pathstem '/' 'beta_000' num2str(whichbetas(i)) '.img']));
else
    Y1_data = spm_vol(spm_vol([pathstem '/' 'beta_00' num2str(whichbetas(i)) '.img']));
end

x_loc = round((location(1)-Y1_data.mat(1,4))/Y1_data.mat(1,1));
y_loc = round((location(2)-Y1_data.mat(2,4))/Y1_data.mat(2,2));

toplot = zeros(1,size(Y{1},3));
for i = 1:length(contrast)
    Y{i} = Y{i}*contrast(i);
end

datatoplot = zeros(length(contrast),size(Y{1},3));
for i = 1:size(Y{1},3)
    
    for j = 1:length(contrast)
        datatoplot(j,i) = Y{j}(x_loc,y_loc,i);
    end
    
end

patienttoplot = mean(datatoplot,1);

plot(-500:4:1500,patienttoplot,'r','LineWidth',4)
plot(-500:4:1500,0,'k-')
xlim([-100 900])

threshold=tinv(0.95,(nsubj-2));
H = squeeze(squeeze(Y3(x_loc,y_loc,:)))>threshold;

jbfill(-500:4:1500,controltoplot,patienttoplot,H','r','none',[],0.5);

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
