function dat = pnfaauditoryprocessingzscores(SesIn);

% Creates a graph of the ZScores of the patients' auditory processing
% abilities compared to a control group - TEC 3/4/14

DIRS = getdirs_psych;
fpath = DIRS.data;

Mfilename = '_All'; %for concatenated runs the name will be: ['SubjInitials' 'Mfilename']

analysismode = 1;
multi = 1;
if analysismode == 1
    Patpitch = ls([fpath 'PNFA\pitch_diflim*.mat']);
    Conpitch = ls([fpath 'Controls\pitch_diflim*.mat']);
    PatFM = ls([fpath 'PNFA\timbre_1_*.mat']);
    ConFM = ls([fpath 'Controls\timbre_1*.mat']);
    PatDMDiscrim = ls([fpath 'PNFA\timbre_4*.mat']);
    ConDMDiscrim = ls([fpath 'Controls\timbre_4*.mat']);
    Patinits = unique(Patpitch(:,19:22),'rows'); %ASSUMES every subject did all three tasks
    for i = 1:size(Patinits,1)
        if Patinits(i,4) == '_'
            Patinits(i,4) = [' '];
        end
    end
    for i = 1:size(Patpitch,1)
        Patages(i,:) = [(str2num(Patpitch(i,16:17))),i];
    end
    Patages = sortrows(Patages)
    disp('The following patients found: ');
    Patinits
    Coninits = unique(Conpitch(:,19:22),'rows');
    for i = 1:size(Coninits,1)
        if Coninits(i,4) == '_'
            Coninits(i,4) = [' '];
        end
    end
    disp('The following controls found: ');
    Coninits
    for I = 1:size(Patpitch,1)
        PatSes.pitch{I} = ['PNFA\' Patpitch(I,:)];
        PatSes.FM{I} = ['PNFA\' PatFM(I,:)];
        PatSes.DMDiscrim{I} = ['PNFA\' PatDMDiscrim(I,:)];
    end
    for I = 1:size(Conpitch,1)
        ConSes.pitch{I} = ['Controls\' Conpitch(I,:)];
        ConSes.FM{I} = ['Controls\' ConFM(I,:)];
        ConSes.DMDiscrim{I} = ['Controls\' ConDMDiscrim(I,:)];
    end
end

for S = 1:size(PatSes.pitch,2),
    disp(['Working on patient file: ' fpath PatSes.pitch{S}]);
    fname = [fpath PatSes.pitch{S}];
    dgz.pitch = load(deblank(fname));
    Patpitchthreshold(S) = dgz.pitch.thr_semit;
    Patpitchstd(S) = dgz.pitch.std_semit;
    disp(['Working on patient file: ' fpath PatSes.FM{S}]);
    fname = [fpath PatSes.FM{S}];
    dgz.FM = load(deblank(fname));
    PatFM2threshold(S) = dgz.FM.thrs_fmi(1);
    PatFM2std(S) = dgz.FM.stds_fmi(1);
    PatFM40threshold(S) = dgz.FM.thrs_fmi(2);
    PatFM40std(S) = dgz.FM.stds_fmi(2);
    disp(['Working on patient file: ' fpath PatSes.DMDiscrim{S}]);
    fname = [fpath PatSes.DMDiscrim{S}];
    dgz.DMDiscrim = load(deblank(fname));
    PatDMDiscrimthreshold(S) = dgz.DMDiscrim.thr_sd;
    PatDMDiscrimstd(S) = dgz.DMDiscrim.std_sd;
end

for S = 1:size(ConSes.pitch,2),
    disp(['Working on control file: ' fpath ConSes.pitch{S}]);
    fname = [fpath ConSes.pitch{S}];
    dgz.pitch = load(deblank(fname));
    Conpitchthreshold(S) = dgz.pitch.thr_semit;
    Conpitchstd(S) = dgz.pitch.std_semit;
    disp(['Working on control file: ' fpath ConSes.FM{S}]);
    fname = [fpath ConSes.FM{S}];
    dgz.FM = load(deblank(fname));
    ConFM2threshold(S) = dgz.FM.thrs_fmi(1);
    ConFM2std(S) = dgz.FM.stds_fmi(1);
    ConFM40threshold(S) = dgz.FM.thrs_fmi(2);
    ConFM40std(S) = dgz.FM.stds_fmi(2);
    disp(['Working on control file: ' fpath ConSes.DMDiscrim{S}]);
    fname = [fpath ConSes.DMDiscrim{S}];
    dgz.DMDiscrim = load(deblank(fname));
    ConDMDiscrimthreshold(S) = dgz.DMDiscrim.thr_sd;
    ConDMDiscrimstd(S) = dgz.DMDiscrim.std_sd;
end

Conpitchgroupmean = mean(Conpitchthreshold);
Conpitchgroupstd = std(Conpitchthreshold);
ConFM2groupmean = mean(ConFM2threshold);
ConFM2groupstd = std(ConFM2threshold);
ConFM40groupmean = mean(ConFM40threshold);
ConFM40groupstd = std(ConFM40threshold);
ConDMDiscrimgroupmean = mean(ConDMDiscrimthreshold);
ConDMDiscrimgroupstd = std(ConDMDiscrimthreshold);

Patpitchgroupmean = mean(Patpitchthreshold);
Patpitchgroupstd = std(Patpitchthreshold);
PatFM2groupmean = mean(PatFM2threshold);
PatFM2groupstd = std(PatFM2threshold);
PatFM40groupmean = mean(PatFM40threshold);
PatFM40groupstd = std(PatFM40threshold);
PatDMDiscrimgroupmean = mean(PatDMDiscrimthreshold);
PatDMDiscrimgroupstd = std(PatDMDiscrimthreshold);

figure
errorbar([Patpitchgroupmean, PatFM2groupmean, PatFM40groupmean, PatDMDiscrimgroupmean],[Patpitchgroupstd, PatFM2groupstd, PatFM40groupstd, PatDMDiscrimgroupstd],'r')
hold on
errorbar([Conpitchgroupmean, ConFM2groupmean, ConFM40groupmean, ConDMDiscrimgroupmean],[Conpitchgroupstd, ConFM2groupstd, ConFM40groupstd, ConDMDiscrimgroupstd],'k')

PatPitchZScores = zeros(size(PatSes.pitch,2),1);
for i = 1:size(PatSes.pitch,2)
    PatPitchZScores(i) = (Patpitchthreshold(i) - Conpitchgroupmean)/Conpitchgroupstd;
end
PatFM2ZScores = zeros(size(PatSes.pitch,2),1);
for i = 1:size(PatSes.pitch,2)
    PatFM2ZScores(i) = (PatFM2threshold(i) - ConFM2groupmean)/ConFM2groupstd;
end
PatFM40ZScores = zeros(size(PatSes.pitch,2),1);
for i = 1:size(PatSes.pitch,2)
    PatFM40ZScores(i) = (PatFM40threshold(i) - ConFM40groupmean)/ConFM40groupstd;
end
PatDMDiscrimZScores = zeros(size(PatSes.pitch,2),1);
for i = 1:size(PatSes.pitch,2)
    PatDMDiscrimZScores(i) = (PatDMDiscrimthreshold(i) - ConDMDiscrimgroupmean)/ConDMDiscrimgroupstd;
end
AllPatZScores = [PatPitchZScores, PatFM2ZScores, PatFM40ZScores, PatDMDiscrimZScores];

figure
zgraphs = tight_subplot(round(sqrt(size(PatSes.pitch,2))),ceil(sqrt(size(PatSes.pitch,2))),[0 0],[.05 .1],[.05 .05]);
for i = 1:size(PatSes.pitch,2)
    hold on
    axes(zgraphs(find(Patages(:,2) == i)));
    plot(AllPatZScores(i,1:4)', 'r', 'LineWidth',3);
    topline = line([0 7], [1.96 1.96,]);
    bottomline = line([0 7], [-1.96 -1.96]);
    set(topline, 'color', 'k', 'linestyle', '--');
    set(bottomline, 'color', 'k', 'linestyle', '--');
    set(gca,'Xlim', [0 5], 'Ytick', [], 'Ylim', [-2 20],'LineWidth', 2, 'Xtick', [1 2 3 4], 'XTickLabel',{'Pitch' 'FM2' 'FM40' 'DMDiscrim'},'Fontsize',[14],'FontName','Tahoma')
    if strcmp(PatSes.pitch{i}(24:26),PatSes.FM{i}(20:22)) && strcmp(PatSes.FM{i}(20:22),PatSes.DMDiscrim{i}(20:22))
    else
        error('THE SUBJECT NUMBERS DONT MATCH BETWEEN FILES!')
    end
    Subtitle = {['Patient ' PatSes.pitch{i}(24:27) ' Aged ' num2str(Patages(find(Patages(:,2) == i),1))]};
    text(1.5,15.5,Subtitle, 'Fontsize',[14],'FontName','Tahoma');
end
for i = size(PatSes.pitch,2)+1:(ceil(sqrt(size(PatSes.pitch,2)))*round(sqrt(size(PatSes.pitch,2))))
    axes(zgraphs(i));
    axis off
end
for i = 1:ceil(sqrt(size(PatSes.pitch,2))):size(PatSes.pitch,2)
    set(get(zgraphs(i),'YLabel'),'String','Z-score','Fontsize',[16],'FontName','Tahoma','FontWeight', 'bold');
    set(zgraphs(i),'Ytick', [-2 0 2 4 6 8 10 12 14 16 18]);
end
for i = size(PatSes.pitch,2)+1:((ceil(sqrt(size(PatSes.pitch,2)))*round(sqrt(size(PatSes.pitch,2))))-(size(PatSes.pitch,2)))
    set(get(zgraphs(i),'XLabel'),'String','Test','Fontsize',[14],'FontName','Tahoma','FontWeight', 'bold');
end
set(gcf,'NextPlot','add');
axes;
h = title('Individual Z-scores of patients with PNFA', 'Fontsize',[20],'FontWeight', 'bold','FontName','Tahoma');
set(gca,'Visible','off');
set(h,'Visible','on');
