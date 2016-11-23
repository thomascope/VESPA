clear all
controldata = csvread('Controls_ALL.csv');
PNFAdata = csvread('PNFA_ALL.csv');
strokedata = csvread('stroke_ALL.csv');
[num_data headings] = xlsread('Headings_ALL.csv');
for i = 1:length(num_data) % Assumes that headings ends with audiogram frequencies
    headings{end+1} = num2str(num_data(i));
end
clear num_data i
BDAEfigure = figure;
% moveint = 0.03; % to ensure that overlapping values are displayed
moveint = 0;
PNFAdataforplot(:,:) = PNFAdata(:,:)-moveint*0.5*size(PNFAdata,1);
for i = 1:size(PNFAdata,1)
    PNFAdataforplot(i,:)= PNFAdataforplot(i,:)+moveint*i;
end
hold on
% DATA HEADINGS 14-20 MUST BE BDAE OVERALL SCORES
for i = 1:size(PNFAdata,1)
    if PNFAdata(i,20) <= 1.5
        plot(PNFAdataforplot(i,14:19),'r','LineWidth',3)        
    elseif PNFAdata(i,20) <= 2.5
        plot(PNFAdataforplot(i,14:19),'m','LineWidth',3)        
    elseif PNFAdata(i,20) <= 3.5
        plot(PNFAdataforplot(i,14:19),'y','LineWidth',3)
    elseif PNFAdata(i,20) <= 4.5
        plot(PNFAdataforplot(i,14:19),'b','LineWidth',3)
    elseif PNFAdata(i,20) > 4.5
        plot(PNFAdataforplot(i,14:19),'g','LineWidth',3)
    end
end
% plot(PNFAdataforplot(:,14:20)','LineWidth',3)
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
PNFAlikerts=PNFAdata(:,29:33);
PNFAlikerts=PNFAlikerts(max(PNFAlikerts~=0,[],2),:); %delete zero value rows
controllikerts=controldata(:,29:33);
controllikerts=controllikerts(max(controllikerts~=0,[],2),:); %delete zero value rows
controllikertmeans = mean(controllikerts);
PNFAlikertmeans = mean(PNFAlikerts);
likertfigure = figure;
for i = 1:5
    [likertsigs(i),likertps(i)] = ttest2(PNFAlikerts(:,i),controllikerts(:,i),0.05,1,'unequal');
end
plot(controllikertmeans,'b','LineWidth',3)
errorbar(controllikertmeans,std(controllikerts)/sqrt(size(controllikerts,1)),'b','LineWidth',3)
hold on
plot(PNFAlikertmeans,'m','LineWidth',3)
errorbar(PNFAlikertmeans,std(PNFAlikerts)/sqrt(size(PNFAlikerts,1)),'m','LineWidth',3)
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
plot(PNFAlikerts','LineWidth',3)
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
PNFAaudiograms=PNFAdata(:,36:45);
PNFAaudiograms=PNFAaudiograms(max(PNFAaudiograms~=0,[],2),:); %delete zero value rows
controlaudiograms=controldata(:,36:45);
PNFAaudiogramplots = tight_subplot(round(sqrt(size(PNFAaudiograms,1))),ceil(sqrt(size(PNFAaudiograms,1))),[0 0],[.05 .1],[.05 .05]);
for i = 1:size(PNFAaudiograms,1)
    axes(PNFAaudiogramplots(i));
    plot(-PNFAaudiograms(i,1:5), 'bx-', 'LineWidth',2,'MarkerSize',15);
    hold on
    plot(-PNFAaudiograms(i,6:10), 'ro-', 'LineWidth',2,'MarkerSize',15);
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
PNFA_zeros_col = zeros(size(PNFAdata,1),1);
control_zeros_col = zeros(size(controldata,1),1);

% Load in Vocode Report data (Cell array of structs)
vocode_report_patdat = load('vocode_report/beh_PNFA_All.mat','patdatA');
vocode_report_condat = load('vocode_report/beh_control_All.mat','condatA');

% Load in MEG clarity rating data (Cell array of structs)
MEG_clarity_patdat = load('MEG_data/beh_PNFA_All.mat','patdatA');
MEG_clarity_condat = load('MEG_data/beh_control_All.mat','condatA');

% Calculate some metrics from the MEG clarity data
PNFA_match_gradient = PNFA_zeros_col;
PNFA_match_zenith = PNFA_zeros_col;
PNFA_mismatch_gradient = PNFA_zeros_col;
PNFA_mismatch_zenith = PNFA_zeros_col;
PNFA_MEG_clarity_difference = PNFA_zeros_col;
PNFA_gradient_difference = PNFA_zeros_col;
PNFA_zenith_difference = PNFA_zeros_col;

PNFA_match4_rating = PNFA_zeros_col;
PNFA_match8_rating = PNFA_zeros_col;
PNFA_match16_rating = PNFA_zeros_col;
PNFA_mismatch4_rating = PNFA_zeros_col;
PNFA_mismatch8_rating = PNFA_zeros_col;
PNFA_mismatch16_rating = PNFA_zeros_col;
for i = 1:size(PNFAdata,1)
    [a] = polyfit([2,1,0],(MEG_clarity_patdat.patdatA{1,i}.meansarray(:,1))',1);
    PNFA_match_gradient(i) = a(1);
    PNFA_match_zenith(i) = a(2);
    [a] = polyfit([2,1,0],(MEG_clarity_patdat.patdatA{1,i}.meansarray(:,2))',1);
    PNFA_mismatch_gradient(i) = a(1);
    PNFA_mismatch_zenith(i) = a(2);
    PNFA_gradient_difference(i) = PNFA_match_gradient(i) - PNFA_mismatch_gradient(i);
    PNFA_zenith_difference(i) = PNFA_match_zenith(i) - PNFA_mismatch_zenith(i);
    PNFA_MEG_clarity_difference(i) = mean(MEG_clarity_patdat.patdatA{1,i}.meansarray(:,1)) - mean(MEG_clarity_patdat.patdatA{1,i}.meansarray(:,2));
    
    PNFA_match4_rating(i) = mean(MEG_clarity_patdat.patdatA{1,i}.match4(:));
    PNFA_match8_rating(i) = mean(MEG_clarity_patdat.patdatA{1,i}.match8(:));
    PNFA_match16_rating(i) = mean(MEG_clarity_patdat.patdatA{1,i}.match16(:));
    PNFA_mismatch4_rating(i) = mean(MEG_clarity_patdat.patdatA{1,i}.mismatch4(:));
    PNFA_mismatch8_rating(i) = mean(MEG_clarity_patdat.patdatA{1,i}.mismatch8(:));
    PNFA_mismatch16_rating(i) = mean(MEG_clarity_patdat.patdatA{1,i}.mismatch16(:));
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
neutral_clarity_patdat = load('neutral_data/beh_PNFA_All.mat','patdatA');
neutral_clarity_condat = load('neutral_data/beh_control_All.mat','condatA');

% Calculate some metrics from the neutral clarity data
PNFA_neutral_match_gradient = PNFA_zeros_col;
PNFA_neutral_match_zenith = PNFA_zeros_col;
PNFA_neutral_mismatch_gradient = PNFA_zeros_col;
PNFA_neutral_mismatch_zenith = PNFA_zeros_col;
PNFA_neutral_gradient = PNFA_zeros_col;
PNFA_neutral_zenith = PNFA_zeros_col;
PNFA_neutral_clarity_difference = PNFA_zeros_col;
PNFA_neutral_gradient_difference = PNFA_zeros_col;
PNFA_neutral_zenith_difference = PNFA_zeros_col;

PNFA_neutral4_rating = PNFA_zeros_col;
PNFA_neutral8_rating = PNFA_zeros_col;
PNFA_neutral16_rating = PNFA_zeros_col;
for i = 1:size(PNFAdata,1)
    [a] = polyfit([2,1,0],(neutral_clarity_patdat.patdatA{1,i}.meansarray(:,1))',1);
    PNFA_neutral_match_gradient(i) = a(1);
    PNFA_neutral_match_zenith(i) = a(2);
    [a] = polyfit([2,1,0],(neutral_clarity_patdat.patdatA{1,i}.meansarray(:,2))',1);
    PNFA_neutral_mismatch_gradient(i) = a(1);
    PNFA_neutral_mismatch_zenith(i) = a(2);
    [a] = polyfit([2,1,0],(neutral_clarity_patdat.patdatA{1,i}.meansarray(:,3))',1);
    PNFA_neutral_gradient(i) = a(1);
    PNFA_neutral_zenith(i) = a(2);
    PNFA_neutral_gradient_difference(i) = PNFA_neutral_gradient(i) - PNFA_neutral_mismatch_gradient(i);
    PNFA_neutral_zenith_difference(i) = PNFA_neutral_zenith(i) - PNFA_neutral_mismatch_zenith(i);
    PNFA_neutral_clarity_difference(i) = mean(neutral_clarity_patdat.patdatA{1,i}.meansarray(:,3)) - mean(neutral_clarity_patdat.patdatA{1,i}.meansarray(:,2));
    PNFA_neutral4_rating(i) = mean(neutral_clarity_patdat.patdatA{1,i}.neutral4(:));
    PNFA_neutral8_rating(i) = mean(neutral_clarity_patdat.patdatA{1,i}.neutral8(:));
    PNFA_neutral16_rating(i) = mean(neutral_clarity_patdat.patdatA{1,i}.neutral16(:));
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
load('auditory_processing/PNFA_auditory_processing.mat')
load('auditory_processing/control_auditory_processing.mat')

% Load in listen up data - two structs with subject key
% (PNFAsubjects/controlsubjects) and vectors of thresholds
load('listen_up/vp_threshes.mat')
load('listen_up/vc_threshes.mat')

%create large matrices with all relevant data
headings{end+1} = 'Vocode Report 4 Channels';
PNFAdata(:,end+1)=PNFA_zeros_col;
for i = 1:size(PNFAdata,1)
    PNFAdata(i,end) = mean(vocode_report_patdat.patdatA{1,i}.meansarray(1,:));
end
controldata(:,end+1)=control_zeros_col;
for i = 1:size(controldata,1)
    controldata(i,end) = mean(vocode_report_condat.condatA{1,i}.meansarray(1,:));
end

headings{end+1} = 'Vocode Report 8 Channels';
PNFAdata(:,end+1)=PNFA_zeros_col;
for i = 1:size(PNFAdata,1)
    PNFAdata(i,end) = mean(vocode_report_patdat.patdatA{1,i}.meansarray(2,:));
end
controldata(:,end+1)=control_zeros_col;
for i = 1:size(controldata,1)
    controldata(i,end) = mean(vocode_report_condat.condatA{1,i}.meansarray(2,:));
end

headings{end+1} = 'Vocode Report 16 Channels';
PNFAdata(:,end+1)=PNFA_zeros_col;
for i = 1:size(PNFAdata,1)
    PNFAdata(i,end) = mean(vocode_report_patdat.patdatA{1,i}.meansarray(3,:));
end
controldata(:,end+1)=control_zeros_col;
for i = 1:size(controldata,1)
    controldata(i,end) = mean(vocode_report_condat.condatA{1,i}.meansarray(3,:));
end

headings{end+1} = 'Vocode Report Overall';
PNFAdata(:,end+1)=PNFA_zeros_col;
for i = 1:size(PNFAdata,1)
    PNFAdata(i,end) = mean(mean(vocode_report_patdat.patdatA{1,i}.meansarray(:,:)));
end
controldata(:,end+1)=control_zeros_col;
for i = 1:size(controldata,1)
    controldata(i,end) = mean(mean(vocode_report_condat.condatA{1,i}.meansarray(:,:)));
end

headings{end+1} = 'Mean MEG clarity difference';
PNFAdata(:,end+1) = PNFA_MEG_clarity_difference;
controldata(:,end+1) = control_MEG_clarity_difference;

headings{end+1} = 'MEG Gradient difference';
PNFAdata(:,end+1) = PNFA_gradient_difference;
controldata(:,end+1) = control_gradient_difference;

headings{end+1} = 'MEG Zenith difference';
PNFAdata(:,end+1) = PNFA_zenith_difference;
controldata(:,end+1) = control_zenith_difference;

headings{end+1} = 'MEG Match4 Rating';
PNFAdata(:,end+1) = PNFA_match4_rating;
controldata(:,end+1) = control_match4_rating;

headings{end+1} = 'MEG Match8 Rating';
PNFAdata(:,end+1) = PNFA_match8_rating;
controldata(:,end+1) = control_match8_rating;

headings{end+1} = 'MEG Match16 Rating';
PNFAdata(:,end+1) = PNFA_match16_rating;
controldata(:,end+1) = control_match16_rating;

headings{end+1} = 'MEG Mismatch4 Rating';
PNFAdata(:,end+1) = PNFA_mismatch4_rating;
controldata(:,end+1) = control_mismatch4_rating;

headings{end+1} = 'MEG Mismatch8 Rating';
PNFAdata(:,end+1) = PNFA_mismatch8_rating;
controldata(:,end+1) = control_mismatch8_rating;

headings{end+1} = 'MEG Mismatch16 Rating';
PNFAdata(:,end+1) = PNFA_mismatch16_rating;
controldata(:,end+1) = control_mismatch16_rating;

headings{end+1} = 'MEG Neutral4 Rating';
PNFAdata(:,end+1) = PNFA_neutral4_rating;
controldata(:,end+1) = control_neutral4_rating;

headings{end+1} = 'MEG Neutral8 Rating';
PNFAdata(:,end+1) = PNFA_neutral8_rating;
controldata(:,end+1) = control_neutral8_rating;

headings{end+1} = 'MEG Neutral16 Rating';
PNFAdata(:,end+1) = PNFA_neutral16_rating;
controldata(:,end+1) = control_neutral16_rating;

headings{end+1} = 'Mean Neutral - Mismatch clarity difference';
PNFAdata(:,end+1) = PNFA_neutral_clarity_difference;
controldata(:,end+1) = control_neutral_clarity_difference;

headings{end+1} = 'Neutral - Mismatch Gradient difference';
PNFAdata(:,end+1) = PNFA_neutral_gradient_difference;
controldata(:,end+1) = control_neutral_gradient_difference;

headings{end+1} = 'Neutral - Mismatch Zenith difference';
PNFAdata(:,end+1) = PNFA_neutral_zenith_difference;
controldata(:,end+1) = control_neutral_zenith_difference;

headings{end+1} = 'Normalised Pitch Discrimination';
PNFAdata(:,end+1) = patlogpitch';
controldata(:,end+1) = conlogpitch';

headings{end+1} = 'Normalised 2Hz FM Discrimination';
PNFAdata(:,end+1) = patlogFM2';
controldata(:,end+1) = conlogFM2';

headings{end+1} = 'Normalised 40Hz FM Discrimination';
PNFAdata(:,end+1) = patlogFM40';
controldata(:,end+1) = conlogFM40';

headings{end+1} = 'Normalised Dynamic Ripple Discrimination';
PNFAdata(:,end+1) = patlogDM';
controldata(:,end+1) = conlogDM';

headings{end+1} = 'Listen-up Word-Word Discrimination';
PNFAdata(:,end+1) = vp_threshes.PNFAwdwdthresholds';
controldata(:,end+1) = vc_threshes.controlwdwdthresholds';

headings{end+1} = 'Listen-up NonWord-Word Discrimination';
PNFAdata(:,end+1) = vp_threshes.PNFAnonwdthresholds';
controldata(:,end+1) = vc_threshes.controlnonwdthresholds';

headings{end+1} = 'Listen-up Word-Word benefit';
PNFAdata(:,end+1) = vp_threshes.PNFAthresholddifferences';
controldata(:,end+1) = vc_threshes.controlthresholddifferences';

global PNFAdata
global controldata
global headings

[PNFAs_sigma_pred,controls_sigma_pred,PNFAs_threshold,controls_threshold] = optimiseperception_threshold;

headings{end+1} = 'Standard Deviation of Prior';
PNFAdata(:,end+1) = PNFAs_sigma_pred';
controldata(:,end+1) = controls_sigma_pred';

headings{end+1} = 'Threshold for clarity perception';
PNFAdata(:,end+1) = PNFAs_threshold';
controldata(:,end+1) = controls_threshold';
