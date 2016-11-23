clear all
% controldata = csvread('Controls.csv');
% patientdata = csvread('Patients.csv');
% [num_data headings] = xlsread('Headings.csv');
% for i = 1:length(num_data) % Assumes that headings ends with audiogram frequencies
%     headings{end+1} = num2str(num_data(i));
% end
% clear num_data i
load('MEG_Demographics.mat');
BDAEfigure = figure;
% moveint = 0.03; % to ensure that overlapping values are displayed
moveint = 0
patientdataforplot(:,:) = patientdata(:,:)-moveint*0.5*size(patientdata,1);
for i = 1:size(patientdata,1)
    patientdataforplot(i,:)= patientdataforplot(i,:)+moveint*i;
end
hold on
for i = 1:size(patientdata,1)
    if patientdata(i,20) <= 1.5
        plot(patientdataforplot(i,14:19),'r','LineWidth',3)        
    elseif patientdata(i,20) <= 2.5
        plot(patientdataforplot(i,14:19),'m','LineWidth',3)        
    elseif patientdata(i,20) <= 3.5
        plot(patientdataforplot(i,14:19),'y','LineWidth',3)
    elseif patientdata(i,20) <= 4.5
        plot(patientdataforplot(i,14:19),'b','LineWidth',3)
    elseif patientdata(i,20) > 4.5
        plot(patientdataforplot(i,14:19),'g','LineWidth',3)
    end
end
% plot(patientdataforplot(:,14:20)','LineWidth',3)
set(gca,'XTick',1:1:6)
set(gca,'YTick',1:1:7)
set(gca,'YLim',[1 7])
set(gca,'XTickLabel',headings(14:20))
set(gca,'Color',[0.9 0.9 0.9]);
hold on
plot([7,7,7,7,7,4],'--k','LineWidth',4) %normal values
%plot([7,7,7,7,7,4,5],'--k','LineWidth',4) %normal values
view([90,90]) % to rotate to preferred plot orientation

%% Calculate and plot differences in Likert scales
patientlikerts=patientdata(:,29:33);
patientlikerts=patientlikerts(max(patientlikerts~=0,[],2),:); %delete zero value rows
controllikerts=controldata(:,29:33);
controllikerts=controllikerts(max(controllikerts~=0,[],2),:); %delete zero value rows
controllikertmeans = mean(controllikerts);
patientlikertmeans = mean(patientlikerts);
likertfigure = figure;
for i = 1:5
    [likertsigs(i),likertps(i)] = ttest2(patientlikerts(:,i),controllikerts(:,i),0.05,1,'unequal');
end
plot(controllikertmeans,'b','LineWidth',3)
errorbar(controllikertmeans,std(controllikerts)/sqrt(size(controllikerts,1)),'b','LineWidth',3)
hold on
plot(patientlikertmeans,'m','LineWidth',3)
errorbar(patientlikertmeans,std(patientlikerts)/sqrt(size(patientlikerts,1)),'m','LineWidth',3)
set(gca,'XTick',1:1:5)
set(gca,'YTick',0:1:10)
set(gca,'YLim',[0 10])
set(gca,'XLim',[0 6])
%set(gca,'XTickLabel',headings(29:33))
set(gca,'XTickLabel',{'Speech in quiet','Sound direction','Speech in restaurant','Station announcements','TV Volume'});
ytitle = ylabel('Difficulty');
set(ytitle,'fontsize',16)
for i = 1:5
    if likertsigs(i) == 1
        plot(i,7.5,'r*','MarkerSize',20)
    end
end
title('Likert scales','Fontsize',18)
figure
plot(patientlikerts','LineWidth',3)
set(gca,'XTick',1:1:5)
set(gca,'YTick',0:1:10)
set(gca,'YLim',[0 10])
set(gca,'XLim',[0 6])
set(gca,'XTickLabel',headings(29:33))
set(gca,'XTickLabel',{'Speech in quiet','Sound direction','Speech in restaurant','Station announcements','TV Volume'});
ytitle = ylabel('Difficulty');
set(ytitle,'fontsize',16)
title('Patient likert scales','Fontsize',18)

figure
plot(controllikerts','LineWidth',3)
set(gca,'XTick',1:1:5)
set(gca,'YTick',0:1:10)
set(gca,'YLim',[0 10])
set(gca,'XLim',[0 6])
set(gca,'XTickLabel',headings(29:33))
set(gca,'XTickLabel',{'Speech in quiet','Sound direction','Speech in restaurant','Station announcements','TV Volume'});
ytitle = ylabel('Difficulty');
set(ytitle,'fontsize',16)
title('Control likert scales','Fontsize',18)
%% Plot audiograms
figure
patientaudiograms=patientdata(:,36:45);
patientaudiograms=patientaudiograms(max(patientaudiograms~=0,[],2),:); %delete zero value rows
controlaudiograms=controldata(:,36:45);
patientaudiogramplots = tight_subplot(round(sqrt(size(patientaudiograms,1))),ceil(sqrt(size(patientaudiograms,1))),[0 0],[.05 .1],[.05 .05]);
for i = 1:size(patientaudiograms,1)
    axes(patientaudiogramplots(i));
    plot(-patientaudiograms(i,1:5), 'bx-', 'LineWidth',2,'MarkerSize',15);
    hold on
    plot(-patientaudiograms(i,6:10), 'ro-', 'LineWidth',2,'MarkerSize',15);
    grid on
    normrange=area([0 7 7 0],[-20 -20 20 20]);
    normrangeprops=get(normrange,'children');
    set(normrangeprops,'FaceAlpha',0.2); % Shades the normal range
    zeroline = line([0 7], [0 0]);
    set(zeroline, 'color', 'k', 'linestyle', '-');
    bottomline = line([0 7], [-20 -20]);
    set(bottomline, 'color', 'k', 'linestyle', '--');
    set(gca,'Xlim', [0 7], 'Ytick', [-110:10:20], 'Ylim', [-110 20],'LineWidth', 2, 'Xtick', [1 2 3 4 5 6], 'XTickLabel',[250, 500, 1000, 2000, 4000, 8000],'Fontsize',[14],'FontName','Tahoma')
    Subtitle = {['Patient ' num2str(i)]};
    text(2.5,15.5,Subtitle, 'Fontsize',[14],'FontName','Tahoma');
end
figure
controlaudiogramplots = tight_subplot(round(sqrt(size(controlaudiograms,1))),ceil(sqrt(size(controlaudiograms,1))),[0 0],[.05 .1],[.05 .05]);
for i = 1:size(controlaudiograms,1)
    axes(controlaudiogramplots(i));
    plot(-controlaudiograms(i,1:5), 'bx-', 'LineWidth',2,'MarkerSize',15);
    hold on
    plot(-controlaudiograms(i,6:10), 'ro-', 'LineWidth',2,'MarkerSize',15);
    grid on
    normrange=area([0 7 7 0],[-20 -20 20 20]);
    normrangeprops=get(normrange,'children');
    set(normrangeprops,'FaceAlpha',0.2); % Shades the normal range
    zeroline = line([0 7], [0 0]);
    set(zeroline, 'color', 'k', 'linestyle', '-');
    bottomline = line([0 7], [-20 -20]);
    set(bottomline, 'color', 'k', 'linestyle', '--');
    set(gca,'Xlim', [0 7], 'Ytick', [-110:10:20], 'Ylim', [-110 20],'LineWidth', 2, 'Xtick', [1 2 3 4 5 6], 'XTickLabel',[250, 500, 1000, 2000, 4000, 8000],'Fontsize',[14],'FontName','Tahoma')
    Subtitle = {['Control ' num2str(i)]};
    text(2.5,15.5,Subtitle, 'Fontsize',[14],'FontName','Tahoma');
end

% Create filler variables to add an extra column to things
patient_zeros_col = zeros(size(patientdata,1),1);
control_zeros_col = zeros(size(controldata,1),1);

% Load in Vocode Report data (Cell array of structs)
vocode_report_patdat = load('vocode_report/beh_patient_All.mat','patdatA');
vocode_report_condat = load('vocode_report/beh_control_All.mat','condatA');

% Load in MEG clarity rating data (Cell array of structs)
MEG_clarity_patdat = load('MEG_data/beh_patient_All.mat','patdatA');
MEG_clarity_condat = load('MEG_data/beh_control_All.mat','condatA');

% Calculate some metrics from the MEG clarity data
patient_match_gradient = patient_zeros_col;
patient_match_zenith = patient_zeros_col;
patient_mismatch_gradient = patient_zeros_col;
patient_mismatch_zenith = patient_zeros_col;
patient_MEG_clarity_difference = patient_zeros_col;
patient_gradient_difference = patient_zeros_col;
patient_zenith_difference = patient_zeros_col;

patient_match4_rating = patient_zeros_col;
patient_match8_rating = patient_zeros_col;
patient_match16_rating = patient_zeros_col;
patient_mismatch4_rating = patient_zeros_col;
patient_mismatch8_rating = patient_zeros_col;
patient_mismatch16_rating = patient_zeros_col;
for i = 1:size(patientdata,1)
    [a] = polyfit([2,1,0],(MEG_clarity_patdat.patdatA{1,i}.meansarray(:,1))',1);
    patient_match_gradient(i) = a(1);
    patient_match_zenith(i) = a(2);
    [a] = polyfit([2,1,0],(MEG_clarity_patdat.patdatA{1,i}.meansarray(:,2))',1);
    patient_mismatch_gradient(i) = a(1);
    patient_mismatch_zenith(i) = a(2);
    patient_gradient_difference(i) = patient_match_gradient(i) - patient_mismatch_gradient(i);
    patient_zenith_difference(i) = patient_match_zenith(i) - patient_mismatch_zenith(i);
    patient_MEG_clarity_difference(i) = mean(MEG_clarity_patdat.patdatA{1,i}.meansarray(:,1)) - mean(MEG_clarity_patdat.patdatA{1,i}.meansarray(:,2));
    
    patient_match4_rating(i) = mean(MEG_clarity_patdat.patdatA{1,i}.match4(:));
    patient_match8_rating(i) = mean(MEG_clarity_patdat.patdatA{1,i}.match8(:));
    patient_match16_rating(i) = mean(MEG_clarity_patdat.patdatA{1,i}.match16(:));
    patient_mismatch4_rating(i) = mean(MEG_clarity_patdat.patdatA{1,i}.mismatch4(:));
    patient_mismatch8_rating(i) = mean(MEG_clarity_patdat.patdatA{1,i}.mismatch8(:));
    patient_mismatch16_rating(i) = mean(MEG_clarity_patdat.patdatA{1,i}.mismatch16(:));
end

control_match_gradient = control_zeros_col;
control_match_zenith = control_zeros_col;
control_mismatch_gradient = control_zeros_col;
control_mismatch_zenith = control_zeros_col;
control_MEG_clarity_difference = control_zeros_col;
control_gradient_difference = control_zeros_col;
control_zenith_difference = control_zeros_col;

control_match4_rating = control_zeros_col;
control_match8_rating = control_zeros_col;
control_match16_rating = control_zeros_col;
control_mismatch4_rating = control_zeros_col;
control_mismatch8_rating = control_zeros_col;
control_mismatch16_rating = control_zeros_col;
for i = 1:size(controldata,1)
    [a] = polyfit([2,1,0],(MEG_clarity_condat.condatA{1,i}.meansarray(:,1))',1);
    control_match_gradient(i) = a(1);
    control_match_zenith(i) = a(2);
    [a] = polyfit([2,1,0],(MEG_clarity_condat.condatA{1,i}.meansarray(:,2))',1);
    control_mismatch_gradient(i) = a(1);
    control_mismatch_zenith(i) = a(2);
    control_gradient_difference(i) = control_match_gradient(i) - control_mismatch_gradient(i);
    control_zenith_difference(i) = control_match_zenith(i) - control_mismatch_zenith(i);
    control_MEG_clarity_difference(i) = mean(MEG_clarity_condat.condatA{1,i}.meansarray(:,1)) - mean(MEG_clarity_condat.condatA{1,i}.meansarray(:,2));
        
    control_match4_rating(i) = mean(MEG_clarity_condat.condatA{1,i}.match4(:));
    control_match8_rating(i) = mean(MEG_clarity_condat.condatA{1,i}.match8(:));
    control_match16_rating(i) = mean(MEG_clarity_condat.condatA{1,i}.match16(:));
    control_mismatch4_rating(i) = mean(MEG_clarity_condat.condatA{1,i}.mismatch4(:));
    control_mismatch8_rating(i) = mean(MEG_clarity_condat.condatA{1,i}.mismatch8(:));
    control_mismatch16_rating(i) = mean(MEG_clarity_condat.condatA{1,i}.mismatch16(:));
end

% Load in neutral clarity rating data (Cell array of structs)
neutral_clarity_patdat = load('neutral_data/beh_patient_All.mat','patdatA');
neutral_clarity_condat = load('neutral_data/beh_control_All.mat','condatA');

% Calculate some metrics from the neutral clarity data
patient_neutral_match_gradient = patient_zeros_col;
patient_neutral_match_zenith = patient_zeros_col;
patient_neutral_mismatch_gradient = patient_zeros_col;
patient_neutral_mismatch_zenith = patient_zeros_col;
patient_neutral_gradient = patient_zeros_col;
patient_neutral_zenith = patient_zeros_col;
patient_neutral_clarity_difference = patient_zeros_col;
patient_neutral_gradient_difference = patient_zeros_col;
patient_neutral_zenith_difference = patient_zeros_col;

patient_neutral4_rating = patient_zeros_col;
patient_neutral8_rating = patient_zeros_col;
patient_neutral16_rating = patient_zeros_col;
for i = 1:size(patientdata,1)
    [a] = polyfit([2,1,0],(neutral_clarity_patdat.patdatA{1,i}.meansarray(:,1))',1);
    patient_neutral_match_gradient(i) = a(1);
    patient_neutral_match_zenith(i) = a(2);
    [a] = polyfit([2,1,0],(neutral_clarity_patdat.patdatA{1,i}.meansarray(:,2))',1);
    patient_neutral_mismatch_gradient(i) = a(1);
    patient_neutral_mismatch_zenith(i) = a(2);
    [a] = polyfit([2,1,0],(neutral_clarity_patdat.patdatA{1,i}.meansarray(:,3))',1);
    patient_neutral_gradient(i) = a(1);
    patient_neutral_zenith(i) = a(2);
    patient_neutral_gradient_difference(i) = patient_neutral_gradient(i) - patient_neutral_mismatch_gradient(i);
    patient_neutral_zenith_difference(i) = patient_neutral_zenith(i) - patient_neutral_mismatch_zenith(i);
    patient_neutral_clarity_difference(i) = mean(neutral_clarity_patdat.patdatA{1,i}.meansarray(:,3)) - mean(neutral_clarity_patdat.patdatA{1,i}.meansarray(:,2));
    patient_neutral4_rating(i) = mean(neutral_clarity_patdat.patdatA{1,i}.neutral4(:));
    patient_neutral8_rating(i) = mean(neutral_clarity_patdat.patdatA{1,i}.neutral8(:));
    patient_neutral16_rating(i) = mean(neutral_clarity_patdat.patdatA{1,i}.neutral16(:));
end

control_neutral_match_gradient = control_zeros_col;
control_neutral_match_zenith = control_zeros_col;
control_neutral_mismatch_gradient = control_zeros_col;
control_neutral_mismatch_zenith = control_zeros_col;
control_neutral_gradient = control_zeros_col;
control_neutral_zenith = control_zeros_col;
control_neutral_clarity_difference = control_zeros_col;
control_neutral_gradient_difference = control_zeros_col;
control_neutral_zenith_difference = control_zeros_col;

control_neutral4_rating = control_zeros_col;
control_neutral8_rating = control_zeros_col;
control_neutral16_rating = control_zeros_col;
for i = 1:size(controldata,1)
    [a] = polyfit([2,1,0],(neutral_clarity_condat.condatA{1,i}.meansarray(:,1))',1);
    control_neutral_match_gradient(i) = a(1);
    control_neutral_match_zenith(i) = a(2);
    [a] = polyfit([2,1,0],(neutral_clarity_condat.condatA{1,i}.meansarray(:,2))',1);
    control_neutral_mismatch_gradient(i) = a(1);
    control_neutral_mismatch_zenith(i) = a(2);
    [a] = polyfit([2,1,0],(neutral_clarity_condat.condatA{1,i}.meansarray(:,3))',1);
    control_neutral_gradient(i) = a(1);
    control_neutral_zenith(i) = a(2);
    control_neutral_gradient_difference(i) = control_neutral_gradient(i) - control_neutral_mismatch_gradient(i);
    control_neutral_zenith_difference(i) = control_neutral_zenith(i) - control_neutral_mismatch_zenith(i);
    control_neutral_clarity_difference(i) = mean(neutral_clarity_condat.condatA{1,i}.meansarray(:,3)) - mean(neutral_clarity_condat.condatA{1,i}.meansarray(:,2));
    
    control_neutral4_rating(i) = mean(neutral_clarity_condat.condatA{1,i}.neutral4(:));
    control_neutral8_rating(i) = mean(neutral_clarity_condat.condatA{1,i}.neutral8(:));
    control_neutral16_rating(i) = mean(neutral_clarity_condat.condatA{1,i}.neutral16(:));
end

% Load in auditory processing data (Individual variable vectors, ordered by
% participant id
load('auditory_processing/patient_auditory_processing.mat')
load('auditory_processing/control_auditory_processing.mat')

% Load in listen up data - two structs with subject key
% (patientsubjects/controlsubjects) and vectors of thresholds
load('listen_up/vp_threshes.mat')
load('listen_up/vc_threshes.mat')

%create large matrices with all relevant data
headings{end+1} = 'Vocode Report 4 Channels';
patientdata(:,end+1)=patient_zeros_col;
for i = 1:size(patientdata,1)
    patientdata(i,end) = mean(vocode_report_patdat.patdatA{1,i}.meansarray(1,:));
end
controldata(:,end+1)=control_zeros_col;
for i = 1:size(controldata,1)
    controldata(i,end) = mean(vocode_report_condat.condatA{1,i}.meansarray(1,:));
end

headings{end+1} = 'Vocode Report 8 Channels';
patientdata(:,end+1)=patient_zeros_col;
for i = 1:size(patientdata,1)
    patientdata(i,end) = mean(vocode_report_patdat.patdatA{1,i}.meansarray(2,:));
end
controldata(:,end+1)=control_zeros_col;
for i = 1:size(controldata,1)
    controldata(i,end) = mean(vocode_report_condat.condatA{1,i}.meansarray(2,:));
end

headings{end+1} = 'Vocode Report 16 Channels';
patientdata(:,end+1)=patient_zeros_col;
for i = 1:size(patientdata,1)
    patientdata(i,end) = mean(vocode_report_patdat.patdatA{1,i}.meansarray(3,:));
end
controldata(:,end+1)=control_zeros_col;
for i = 1:size(controldata,1)
    controldata(i,end) = mean(vocode_report_condat.condatA{1,i}.meansarray(3,:));
end

headings{end+1} = 'Vocode Report Overall';
patientdata(:,end+1)=patient_zeros_col;
for i = 1:size(patientdata,1)
    patientdata(i,end) = mean(mean(vocode_report_patdat.patdatA{1,i}.meansarray(:,:)));
end
controldata(:,end+1)=control_zeros_col;
for i = 1:size(controldata,1)
    controldata(i,end) = mean(mean(vocode_report_condat.condatA{1,i}.meansarray(:,:)));
end

headings{end+1} = 'Mean MEG clarity difference';
patientdata(:,end+1) = patient_MEG_clarity_difference;
controldata(:,end+1) = control_MEG_clarity_difference;

headings{end+1} = 'MEG Gradient difference';
patientdata(:,end+1) = patient_gradient_difference;
controldata(:,end+1) = control_gradient_difference;

headings{end+1} = 'MEG Zenith difference';
patientdata(:,end+1) = patient_zenith_difference;
controldata(:,end+1) = control_zenith_difference;

headings{end+1} = 'MEG Match4 Rating';
patientdata(:,end+1) = patient_match4_rating;
controldata(:,end+1) = control_match4_rating;

headings{end+1} = 'MEG Match8 Rating';
patientdata(:,end+1) = patient_match8_rating;
controldata(:,end+1) = control_match8_rating;

headings{end+1} = 'MEG Match16 Rating';
patientdata(:,end+1) = patient_match16_rating;
controldata(:,end+1) = control_match16_rating;

headings{end+1} = 'MEG Mismatch4 Rating';
patientdata(:,end+1) = patient_mismatch4_rating;
controldata(:,end+1) = control_mismatch4_rating;

headings{end+1} = 'MEG Mismatch8 Rating';
patientdata(:,end+1) = patient_mismatch8_rating;
controldata(:,end+1) = control_mismatch8_rating;

headings{end+1} = 'MEG Mismatch16 Rating';
patientdata(:,end+1) = patient_mismatch16_rating;
controldata(:,end+1) = control_mismatch16_rating;

headings{end+1} = 'MEG Neutral4 Rating';
patientdata(:,end+1) = patient_neutral4_rating;
controldata(:,end+1) = control_neutral4_rating;

headings{end+1} = 'MEG Neutral8 Rating';
patientdata(:,end+1) = patient_neutral8_rating;
controldata(:,end+1) = control_neutral8_rating;

headings{end+1} = 'MEG Neutral16 Rating';
patientdata(:,end+1) = patient_neutral16_rating;
controldata(:,end+1) = control_neutral16_rating;

headings{end+1} = 'Mean Neutral - Mismatch clarity difference';
patientdata(:,end+1) = patient_neutral_clarity_difference;
controldata(:,end+1) = control_neutral_clarity_difference;

headings{end+1} = 'Neutral - Mismatch Gradient difference';
patientdata(:,end+1) = patient_neutral_gradient_difference;
controldata(:,end+1) = control_neutral_gradient_difference;

headings{end+1} = 'Neutral - Mismatch Zenith difference';
patientdata(:,end+1) = patient_neutral_zenith_difference;
controldata(:,end+1) = control_neutral_zenith_difference;

headings{end+1} = 'Normalised Pitch Discrimination';
patientdata(:,end+1) = patlogpitch';
controldata(:,end+1) = conlogpitch';

headings{end+1} = 'Normalised 2Hz FM Discrimination';
patientdata(:,end+1) = patlogFM2';
controldata(:,end+1) = conlogFM2';

headings{end+1} = 'Normalised 40Hz FM Discrimination';
patientdata(:,end+1) = patlogFM40';
controldata(:,end+1) = conlogFM40';

headings{end+1} = 'Normalised Dynamic Ripple Discrimination';
patientdata(:,end+1) = patlogDM';
controldata(:,end+1) = conlogDM';

headings{end+1} = 'Listen-up Word-Word Discrimination';
patientdata(:,end+1) = vp_threshes.patientwdwdthresholds';
controldata(:,end+1) = vc_threshes.controlwdwdthresholds';

headings{end+1} = 'Listen-up NonWord-Word Discrimination';
patientdata(:,end+1) = vp_threshes.patientnonwdthresholds';
controldata(:,end+1) = vc_threshes.controlnonwdthresholds';

headings{end+1} = 'Listen-up Word-Word benefit';
patientdata(:,end+1) = vp_threshes.patientthresholddifferences';
controldata(:,end+1) = vc_threshes.controlthresholddifferences';

global patientdata
global controldata
global headings

[patients_sigma_pred,controls_sigma_pred,patients_threshold,controls_threshold] = optimiseperception_threshold;

headings{end+1} = 'Standard Deviation of Prior';
patientdata(:,end+1) = patients_sigma_pred';
controldata(:,end+1) = controls_sigma_pred';

headings{end+1} = 'Threshold for clarity perception';
patientdata(:,end+1) = patients_threshold';
controldata(:,end+1) = controls_threshold';
