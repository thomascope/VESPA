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

function plot_betas_overall(modality,varargin)
hold on
pathstem = ['/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/stats_2sm_/combined_-100_900_' modality];


data{1} = spm_eeg_load('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/meg14_0072_vc1/controls_weighted_grandmean.mat');
data{2} = spm_eeg_load('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/meg14_0085_vp1/patients_weighted_grandmean.mat');

controltoplot = rms(data{1}(data{1}.selectchannels(modality),:,1));

figure

plot(-500:4:1500,controltoplot,'g','LineWidth',4)

hold on

patienttoplot = rms(data{2}(data{2}.selectchannels(modality),:,1));


plot(-500:4:1500,patienttoplot,'r','LineWidth',4)

plot(-500:4:1500,zeros(1,length([-500:4:1500])),'k')
xlim([-100 900])

xlabel('ms','fontsize',20)
if strcmp(modality,'MEGCOMB') || strcmp(modality,'MEGPLANAR')
    ylabel('fT/mm','fontsize',20)
elseif strcmp(modality,'MEGMAG')
    ylabel('fT','fontsize',20)
elseif strcmp(modality,'EEG')
    ylabel('uV','fontsize',20)
end
set(gca,'fontsize',20)

title(['Root Mean Square Overall Sensor Power'],'fontsize',20)
legend({'Controls','Patients'})

contrastnumber = 1; %For Overall Power

for i = 1:length(varargin)
H(varargin{i}(1)+500:varargin{i}(2)+500) = 1;
end
H = downsample(H,4);
jbfill(-500:4:1500,patienttoplot,zeros(1,length(patienttoplot)),H,'k','k',[],0.3);

save_string = ['./Significant_peaks/Overall RMS Sensor power for ' modality '.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])


%timewindow = input('\nPlease input a two element vector of milliseconds to plot the topographies for each group\n');

figHandles = findobj('Type','axes');
for i = 1:length(varargin)
    fieldtrip_topoplot_highlight(varargin{i},contrastnumber,[],modality)
    scales(:,i) = caxis;
end

figHandles2 = findobj('Type','axes');
newfigHandles = setdiff(figHandles2,figHandles);
for i = 1:length(newfigHandles)
    caxis(newfigHandles(i),[min(min(scales)) max(max(scales))])
end