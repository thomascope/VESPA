%A function for plotting two spm files against each other over time, with a
%t contrast for thresholding
%(assumes a -500 to 1500ms window, with 250Hz sampling)
%Suggested inputs:
%plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-47,8],'MEGCOMB')
%Plot the activity at the point of maximum group activity in combined
%gradiometers for Match-Mismatch
%plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-38,34],'EEG')
%Point of maximum combined in EEG (anterior)
%plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-26,14],'EEG')
%EEG (posterior)
%plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-42,29],'MEGMAG')
%MEGMAG (left anterior)
%plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[42,34],'MEGMAG')
%MEGMAG (right anterior)
%plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-38,-41],'MEGMAG')
%MEGMAG (left posterior)

function plot_betas_thresholded(plot_threshold,whichbetas,contrast,statspm,nsubj,location,modality,varargin)

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

if ischar(statspm)
    Y3{1}=spm_read_vols(spm_vol([pathstem '/' 'spm' statspm '.img']));
    Y3_data{1} = spm_vol(spm_vol([pathstem '/' 'spm' statspm '.img']));
else
    for i = 1:size(statspm,2)
        Y3{i}=spm_read_vols(spm_vol([pathstem '/' 'spm' statspm{i} '.img']));
        Y3_data{i} = spm_vol(spm_vol([pathstem '/' 'spm' statspm{i} '.img']));
    end
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
plot(-500:4:1500,zeros(1,length([-500:4:1500])),'k-')
xlim([-100 900])

threshold=tinv(0.95,(nsubj-2));
allsigs = zeros(size(squeeze(squeeze(Y3{1}(x_loc,y_loc,:)))));
for i = 1:size(Y3,2)
    H{i} = squeeze(squeeze(Y3{i}(x_loc,y_loc,:)))>threshold;
    allsigs = allsigs+H{i};

end

titlestr = strsplit(Y3_data{1}.descrip,'X');

xlabel('ms','fontsize',20)
if strcmp(modality,'MEGCOMB')
    ylabel('fT/mm','fontsize',20)
elseif strcmp(modality,'MEGMAG')
    ylabel('fT','fontsize',20)
elseif strcmp(modality,'EEG')
    ylabel('uV','fontsize',20)
end
set(gca,'fontsize',20)

title([titlestr{2}(2:end) ' for ' modality ' at ' num2str(location)],'fontsize',20)
legend({'Controls','Patients'})

pv = [allsigs' 0];
sv = [0 pv(1:(end-1))];
ev = [pv(2:end) 0];
starting = find( pv - sv >= 1 );
ending = find( pv - ev >= 1 );
times=[-500:4:1500];

figHandles = findobj('Type','axes');
if isequal(contrast,[-1 1 -1 1 -1 1])
    contrastnumber = 2; %For Match-Mismatch]
elseif isequal(contrast,[-1 -1 0 0 1 1])
    contrastnumber = 3; %For Clear-Unclear
elseif isequal(contrast,[0 1 0 1 0 1]) || isequal(contrast,[1 0 1 0 1 0]) || isequal(contrast,[1 1 0 0 0 0]) || isequal(contrast,[0 0 0 0 1 1])
    contrastnumber = 1; %For Overall Power
end
    
    scales = zeros(2,length(starting));
i = 1;
for j = 1:length(starting)
    if ending(i)-starting(i) >= 7 %Account for smoothing - crude cluster correction by deletings 'significance' less than 25ms duration.
        
        i = i+1;
    else
        allsigs(starting(i):ending(i)) = 0;
        starting(i) = [];
        ending(i) = [];
    end
end
jbfill(-500:4:1500,controltoplot,patienttoplot,allsigs','r','none',[],0.5);

save_string = ['./Significant_peaks/' titlestr{2}(2:end) ', contrast ' num2str(contrast) ' for ' modality ' at ' num2str(location) '.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

for i = 1:length(starting)
    timewindow = [times(starting(i)) times(ending(i))];
    thisscale = fieldtrip_topoplot_nosave(timewindow,contrastnumber,location,modality);
    scales(i) = max(max(abs(thisscale)));
    fieldtrip_topoplot_thresholded(timewindow,contrastnumber,[-scales(i), scales(i)],modality)
end
figHandles2 = findobj('Type','axes');
newfigHandles = setdiff(figHandles2,figHandles);

%timewindow = input('\nPlease input a two element vector of milliseconds to plot the topographies for each group\n');

if isempty(varargin)
    varargin{1} = [400 700];
end
for i = 1:length(varargin)
    fieldtrip_topoplot_thresholded(varargin{i},contrastnumber,plot_threshold,modality)
end