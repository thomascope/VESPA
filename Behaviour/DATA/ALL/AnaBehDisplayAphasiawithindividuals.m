% HumBehDisplay
%
% Usage: AnaBehDisplay(Ses);
%
% IF YOU CALL ONLY AnaBehDisplay, it will run through the LIST defined below.
%
% -cip
function AnaBehDisplayAphasiawithindividuals(Ses);

DIRS = getdirs_psych;
fpath = DIRS.data;
FigDir = DIRS.dataFigs;

if ~exist(FigDir,'dir'),
    mkdir(FigDir);
end

numreps = 4; %the number of decisions made about each stimulus in a run. Vital that this is changed if the paradigm changes to more/fewer repetitions.

List ={'beh_control_All.mat'};
%List = {'CIP1';'CIP4'};

SHOWEACH = 1;
PRINT = 1;

if nargin == 0, Ses = ''; end
if strcmp(Ses,'')
    for k=1:length(List)
        fprintf('%s      ',List{k});
        if rem(k,4)==0
            fprintf('\n');
        end
    end
    fprintf('\n');
    cd(gg);
    return
elseif strcmp(Ses,'all'),
    disp('Processing all...');
    ToDo = List;
else %single
    ToDo{1} = Ses;
end

col  = 'bgrcm';
simb = '-----';
plotFA = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
for I = 1:length(ToDo),
    clear dat
    Session = ToDo{I};
    load([fpath Session]);
    disp(['Working on: ' Session]);
    
    if exist('dat','var')
    elseif exist('patdat','var')
        dat = patdat;
    elseif exist('condat','var')
        dat = condat;
    end
    
    % divide into types
    
    toneseqs = [];
    nonwdseqs = [];
    oddballseqs = [];
    for i = 1:length(dat.filename)
        tonefind = strfind(dat.filename{i}, 'tone');
        nonwdfind = strfind(dat.filename{i}, 'nonwds_learning');
        oddballfind = strfind(dat.filename{i}, 'nonwds_oddball');
        if tonefind > 0
            toneseqs = [toneseqs, i];
        elseif nonwdfind > 0
            nonwdseqs = [nonwdseqs, i];
        elseif oddballfind > 0
            oddballseqs = [oddballseqs, i];
        end
    end
    
    firstseqs = [];
    secondseqs = [];
    thirdseqs = [];
    for i = 1:length(dat.filename)
        firstfind = strfind(dat.filename{i}, '1.mat');
        secondfind = strfind(dat.filename{i}, '2.mat');
        thirdfind = strfind(dat.filename{i}, '3.mat');
        if firstfind > 0
            firstseqs = [firstseqs, i];
        elseif secondfind > 0
            secondseqs = [secondseqs, i];
        elseif thirdfind > 0
            thirdseqs = [thirdseqs, i];
        end
    end
    
    firsttones = intersect(toneseqs,firstseqs);
    secondtones = intersect(toneseqs,secondseqs);
    thirdtones = intersect(toneseqs,thirdseqs);
    firstnonwd = intersect(nonwdseqs,firstseqs);
    secondnonwd = intersect(nonwdseqs,secondseqs);
    thirdnonwd = intersect(nonwdseqs,thirdseqs);
    
    Sets       = {'GramVsUngram'};
    SetNums{1} = [1:2];
    leg = {'Gram';'Ugram'};
    col  = 'bgcbgc';
    simb = '---:::';
    
    switch dat.Expt
        case {'run_wordTest_Saff_AllRules'},
            x{1} = [1:4]; % Gram
            x{2} = [5:8];% Ungram
        case {'run_Test_patient.m'},
            x{1} = [1:4]; % Gram
            x{2} = [5:12];% Ungram
        case {'run_test_patient.m'},
            x{1} = [1:6]; % Gram
            x{2} = [7:12];% Ungram
        otherwise
            x{1} = [1:6]; % Gram
            x{2} = [7:18];% Ungram
            dat.condNum(5:6) = 1;
    end
    
    %% Create figures for nonwords
    
    for I = 1:size(Sets),
        F1 = figure;
        F2 = figure;
        conds = SetNums{I};
        D = []; sIdx = []; y = []; yerr = [];
        for J = 1:length(conds),
            sIdx{J} = find(dat.condNum == conds(J));
            for i = 1:size(sIdx{J},2)
                allcorr = [];
                for i2 = 1:length(nonwdseqs)
                    allcorr = [allcorr dat.correct{(i+(J-1)*size(sIdx{(J)},2))}(1+4*(nonwdseqs(i2)-1):4*nonwdseqs(i2))]; %NB: ASSUMES EQUAL NUMBER OF CORRECT AND INCORRECT.
                end
                individualcorrs=zeros((length(allcorr)/12),12);
                for i2 = 1:(length(allcorr)/12)
                    individualcorrs(i2,:) = allcorr((i2-1)*12+1:(i2-1)*12+12);
                    indD(J,i,i2) = mean(individualcorrs(i2,:));
                end
                D(J,i) = mean(allcorr);
            end
            y(J) = mean(D(J,:));
            yerr(J) = sqrt((y(J)*(1-y(J)))/(24*length(nonwdseqs)));  %for 4 repeats of 6 conditions
        end
        %         figure(F1);%average across stim
        %         error_bar(y,yerr,col(conds));
        %         legend(leg);
        %         y(J)
        %         yerr(J)
        
        figure(F1) %new graph, by subject!
        idx = [sIdx{:}];
        numsubjects = length(nonwdseqs)/3; %Assumes that all subjects did 3 runs of nonwds
        if size(indD,3) ~= numsubjects
            error('Something went wrong, number of subjects mismatch!')
        end
        nonwdgraphs = tight_subplot(round(sqrt(numsubjects)),ceil(sqrt(numsubjects)),[0 0],[.05 .1],[.05 .05]);
        set(gcf,'position',[100,100,1400,1000])
        for count = 1:numsubjects
            y1 = [indD(1,:,count), indD(2,:,count)];
            for J = 1:12
                yerr1(J) = sqrt((y1(J)*(1-y1(J)))/12); % for 4 repeats of each condition
            end
            hold on
            axes(nonwdgraphs(count))
            error_bar(y1,yerr1,col(dat.condNum(idx)))
            set(gca,'XTickLabel',int2str(idx'));
            set(gca,'XTick',[x{1},x{2}])
            set(gca,'YTickLabel',[0:10:100]);
            set(gca,'YTick',[0:0.1:1])
            set(gca,'YLim',[0 1])
            ylabel('Percent Correct');
            xlabel('Stim Number');
            ylabh = get(gca,'YLabel');
            set(ylabh,'Position',get(ylabh,'Position') + [0.4 0 0]);
            if exist('condat','var')
                Subtitle = {['Control ' num2str(count)]};
            elseif exist('patdat','var')
                Subtitle = {['Patient ' num2str(count)]};
            end
            text(2.5,15.5,Subtitle, 'Fontsize',[14],'FontName','Tahoma');
        end
        axes;
        ylabel('Percent Correct');
        xlabel('Stim Number');
        if exist('condat','var')
            h = title(['Control Nonwds: ' Sets{I} ' By Individual'], 'Fontsize',[20],'FontWeight', 'bold','FontName','Tahoma');
        elseif exist('patdat','var')
            h = title(['Patient Nonwds: ' Sets{I} ' By Individual'], 'Fontsize',[20],'FontWeight', 'bold','FontName','Tahoma');
        end
        set(gca,'Visible','off');
        set(h,'Visible','on');
        
        figure(F2);%by stim
        idx = [sIdx{:}];
        y2 = [D(1,:), D(2,:)];
        for J = 1:12
            yerr2(J) = sqrt((y2(J)*(1-y2(J)))/(4*length(nonwdseqs))); % for 4 repeats of each condition
        end
        
        error_bar(y2,yerr2,col(dat.condNum(idx)));
        hh = gca;
        set(hh,'XTickLabel',int2str(idx'));
        set(gca,'XTick',[x{1},x{2}])
        
    end
    %     figure(F1);
    %     Session(strfind(Session,'_')) = '-';
    %     title([Session 'Nonwds:' Sets{I}]);
    %     ylabel('Percent Correct');
    %     xlabel('Gram [1]; Ungram [2]');
    %     set(gca,'XTick',[1:2]);
    if PRINT, sub_print(F1,FigDir,Session,[Sets{I} 'nonwds']); end
    
    figure(F2);
    title(['Nonwds: ' Sets{I} ' ByStimulus']);
    ylabel('Percent Correct');
    xlabel('Stim Number');
    if PRINT, sub_print(F2,FigDir,Session,[Sets{I} 'nonwds_byStim']); end
    
    
    %% Create figures for tones
    indD = [];
    for I = 1:size(Sets),
        F3 = figure;
        F4 = figure;
        conds = SetNums{I};
        D = []; sIdx = []; y = []; yerr = [];
        for J = 1:length(conds),
            sIdx{J} = find(dat.condNum == conds(J));
            for i = 1:size(sIdx{J},2)
                allcorr = [];
                for i2 = 1:length(toneseqs)
                    allcorr = [allcorr dat.correct{(i+(J-1)*size(sIdx{(J)},2))}(1+4*(toneseqs(i2)-1):4*toneseqs(i2))]; %NB: ASSUMES EQUAL NUMBER OF CORRECT AND INCORRECT.
                end
                individualcorrs=zeros((length(allcorr)/12),12);
                for i2 = 1:(length(allcorr)/12)
                    individualcorrs(i2,:) = allcorr((i2-1)*12+1:(i2-1)*12+12);
                    indD(J,i,i2) = mean(individualcorrs(i2,:));
                end
                D(J,i) = mean(allcorr);
            end
            y(J) = mean(D(J,:));
            yerr(J) = sqrt((y(J)*(1-y(J)))/(24*length(toneseqs)));  %for 4 repeats of 6 conditions
        end
        %         figure(F3);%average across stim
        %         error_bar(y,yerr,col(conds));
        %         legend(leg);
        %         y(J)
        %         yerr(J)
        figure(F3) %new graph, by subject!
        idx = [sIdx{:}];
        numsubjects = length(nonwdseqs)/3; %Assumes that all subjects did 3 runs of nonwds
        if size(indD,3) ~= numsubjects
            error('Something went wrong, number of subjects mismatch!')
        end
        nonwdgraphs = tight_subplot(round(sqrt(numsubjects)),ceil(sqrt(numsubjects)),[0 0],[.05 .1],[.05 .05]);
        set(gcf,'position',[100,100,1400,1000])
        for count = 1:numsubjects
            y1 = [indD(1,:,count), indD(2,:,count)];
            for J = 1:12
                yerr1(J) = sqrt((y1(J)*(1-y1(J)))/12); % for 4 repeats of each condition
            end
            hold on
            axes(nonwdgraphs(count))
            error_bar(y1,yerr1,col(dat.condNum(idx)))
            set(gca,'XTickLabel',int2str(idx'));
            set(gca,'XTick',[x{1},x{2}])
            set(gca,'YTickLabel',[0:10:100]);
            set(gca,'YTick',[0:0.1:1])
            set(gca,'YLim',[0 1])
            ylabel('Percent Correct');
            xlabel('Stim Number');
            ylabh = get(gca,'YLabel');
            set(ylabh,'Position',get(ylabh,'Position') + [0.4 0 0]);
            if exist('condat','var')
                Subtitle = {['Control ' num2str(count)]};
            elseif exist('patdat','var')
                Subtitle = {['Patient ' num2str(count)]};
            end
            text(2.5,15.5,Subtitle, 'Fontsize',[14],'FontName','Tahoma');
        end
        axes;
        set(gca,'Visible','off');
        if exist('condat','var')
            h = title(['Control Tones: ' Sets{I} ' By Individual'], 'Fontsize',[20],'FontWeight', 'bold','FontName','Tahoma');
        elseif exist('patdat','var')
            h = title(['Patient Tones: ' Sets{I} ' By Individual'], 'Fontsize',[20],'FontWeight', 'bold','FontName','Tahoma');
        end
        set(h,'Visible','on');
        
        figure(F4);%by stim
        idx = [sIdx{:}];
        y2 = [D(1,:), D(2,:)];
        for J = 1:12
            yerr2(J) = sqrt((y2(J)*(1-y2(J)))/(4*length(toneseqs))); % for 4 repeats of each condition
        end
        
        error_bar(y2,yerr2,col(dat.condNum(idx)));
        hh = gca;
        set(hh,'XTickLabel',int2str(idx'));
        set(gca,'XTick',[x{1},x{2}])
        
    end
    %     figure(F3);
    %     Session(strfind(Session,'_')) = '-';
    %     title([Session 'tones:' Sets{I}]);
    %     ylabel('Percent Correct');
    %     xlabel('Gram [1]; Ungram [2]');
    %     set(gca,'XTick',[1:2]);
    if PRINT, sub_print(F3,FigDir,Session,[Sets{I} 'tones']); end
    
    figure(F4);
    title(['Tones: ' Sets{I} ' ByStimulus']);
    ylabel('Percent Correct');
    xlabel('Stim Number');
    if PRINT, sub_print(F4,FigDir,Session,[Sets{I} 'tones_byStim']); end
    
    %% Create figures for oddball
    indD = [];
    for I = 1:size(Sets),
        F5 = figure;
        F6 = figure;
        conds = SetNums{I};
        D = []; sIdx = []; y = []; yerr = [];
        for J = 1:length(conds),
            sIdx{J} = find(dat.condNum == conds(J));
            for i = 1:size(sIdx{J},2)
                allcorr = [];
                for i2 = 1:length(oddballseqs)
                    allcorr = [allcorr dat.correct{(i+(J-1)*size(sIdx{(J)},2))}(1+4*(oddballseqs(i2)-1):4*oddballseqs(i2))]; %NB: ASSUMES EQUAL NUMBER OF CORRECT AND INCORRECT.
                end
                individualcorrs=zeros((length(allcorr)/4),4);
                for i2 = 1:(length(allcorr)/4)
                    individualcorrs(i2,:) = allcorr((i2-1)*4+1:(i2-1)*4+4);
                    indD(J,i,i2) = mean(individualcorrs(i2,:));
                end
                D(J,i) = mean(allcorr);
            end
            y(J) = mean(D(J,:));
            yerr(J) = sqrt((y(J)*(1-y(J)))/(24*length(oddballseqs)));  %for 4 repeats of 6 conditions
        end
        %         figure(F5);%average across stim
        %         error_bar(y,yerr,col(conds));
        %         legend(leg);
        %         y(J)
        %         yerr(J)
        
        figure(F5) %new graph, by subject!
        idx = [sIdx{:}];
        numsubjects = length(nonwdseqs)/3; %Assumes that all subjects did 3 runs of nonwds
        if size(indD,3) ~= numsubjects
            error('Something went wrong, number of subjects mismatch!')
        end
        nonwdgraphs = tight_subplot(round(sqrt(numsubjects)),ceil(sqrt(numsubjects)),[0 0],[.05 .1],[.05 .05]);
        set(gcf,'position',[100,100,1400,1000])
        for count = 1:numsubjects
            y1 = [indD(1,:,count), indD(2,:,count)];
            for J = 1:12
                yerr1(J) = sqrt((y1(J)*(1-y1(J)))/4); % for 4 repeats of each condition
            end
            hold on
            axes(nonwdgraphs(count))
            error_bar(y1,yerr1,col(dat.condNum(idx)))
            set(gca,'XTickLabel',int2str(idx'));
            set(gca,'XTick',[x{1},x{2}])
            set(gca,'YTickLabel',[0:10:100]);
            set(gca,'YTick',[0:0.1:1])
            set(gca,'YLim',[0 1])
            ylabel('Percent Correct');
            xlabel('Stim Number');
            ylabh = get(gca,'YLabel');
            set(ylabh,'Position',get(ylabh,'Position') + [0.4 0 0]);
            if exist('condat','var')
                Subtitle = {['Control ' num2str(count)]};
            elseif exist('patdat','var')
                Subtitle = {['Patient ' num2str(count)]};
            end
            text(2.5,15.5,Subtitle, 'Fontsize',[14],'FontName','Tahoma');
        end
        axes;
        ylabel('Percent Correct');
        xlabel('Stim Number');
        if exist('condat','var')
            h = title(['Control Oddball: ' Sets{I} ' By Individual'], 'Fontsize',[20],'FontWeight', 'bold','FontName','Tahoma');
        elseif exist('patdat','var')
            h = title(['Patient Oddball: ' Sets{I} ' By Individual'], 'Fontsize',[20],'FontWeight', 'bold','FontName','Tahoma');
        end
        set(gca,'Visible','off');
        set(h,'Visible','on');
        
        figure(F6);%by stim
        idx = [sIdx{:}];
        y2 = [D(1,:), D(2,:)];
        for J = 1:12
            yerr2(J) = sqrt((y2(J)*(1-y2(J)))/(4*length(oddballseqs))); % for 4 repeats of each condition
        end
        
        error_bar(y2,yerr2,col(dat.condNum(idx)));
        hh = gca;
        set(hh,'XTickLabel',int2str(idx'));
        set(gca,'XTick',[x{1},x{2}])
        
    end
    %     figure(F5);
    %     Session(strfind(Session,'_')) = '-';
    %     title([Session 'oddballs:' Sets{I}]);
    %     ylabel('Percent Correct');
    %     xlabel('Gram [1]; Ungram [2]');
    %     set(gca,'XTick',[1:2]);
    if PRINT, sub_print(F5,FigDir,Session,[Sets{I} 'oddball']); end
    
    figure(F6);
    title(['Oddball: ' Sets{I} ' ByStimulus']);
    ylabel('Percent Correct');
    xlabel('Stim Number');
    if PRINT, sub_print(F6,FigDir,Session,[Sets{I} 'oddball_byStim']); end
    
%     %% Create figures for first run of nonwords
%     
%     for I = 1:size(Sets),
%         F7 = figure;
%         F8 = figure;
%         conds = SetNums{I};
%         D = []; sIdx = []; y = []; yerr = [];
%         for J = 1:length(conds),
%             sIdx{J} = find(dat.condNum == conds(J));
%             for i = 1:size(sIdx{J},2)
%                 allcorr = [];
%                 for i2 = 1:length(firstnonwd)
%                     allcorr = [allcorr dat.correct{(i+(J-1)*size(sIdx{(J)},2))}(1+4*(firstnonwd(i2)-1):4*firstnonwd(i2))]; %NB: ASSUMES EQUAL NUMBER OF CORRECT AND INCORRECT.
%                 end
%                 D(J,i) = mean(allcorr);
%             end
%             y(J) = mean(D(J,:));
%             yerr(J) = sqrt((y(J)*(1-y(J)))/(24*length(firstnonwd)));  %for 4 repeats of 6 conditions
%         end
%         figure(F7);%average across stim
%         error_bar(y,yerr,col(conds));
%         legend(leg);
%         y(J)
%         yerr(J)
%         
%         figure(F8);%by stim
%         idx = [sIdx{:}];
%         y2 = [D(1,:), D(2,:)];
%         for J = 1:12
%             yerr2(J) = sqrt((y2(J)*(1-y2(J)))/(4*length(firstnonwd))); % for 4 repeats of each condition
%         end
%         
%         error_bar(y2,yerr2,col(dat.condNum(idx)));
%         hh = gca;
%         set(hh,'XTickLabel',int2str(idx'));
%         set(gca,'XTick',[x{1},x{2}])
%         
%     end
%     figure(F7);
%     Session(strfind(Session,'_')) = '-';
%     title([Session 'Nonwds run 1:' Sets{I}]);
%     ylabel('Percent Correct');
%     xlabel('Gram [1]; Ungram [2]');
%     set(gca,'XTick',[1:2]);
%     if PRINT, sub_print(F7,FigDir,Session,Sets{I}); end
%     
%     figure(F8);
%     title([Session 'Nonwds run 1:' Sets{I} ' ByStimulus']);
%     ylabel('Percent Correct');
%     xlabel('Stim Number');
%     if PRINT, sub_print(F8,FigDir,Session,[Sets{I} 'nonwdsrun1_byStim']); end
%     
%     %% Create figures for second run of nonwords
%     
%     for I = 1:size(Sets),
%         F9 = figure;
%         F10 = figure;
%         conds = SetNums{I};
%         D = []; sIdx = []; y = []; yerr = [];
%         for J = 1:length(conds),
%             sIdx{J} = find(dat.condNum == conds(J));
%             for i = 1:size(sIdx{J},2)
%                 allcorr = [];
%                 for i2 = 1:length(secondnonwd)
%                     allcorr = [allcorr dat.correct{(i+(J-1)*size(sIdx{(J)},2))}(1+4*(secondnonwd(i2)-1):4*secondnonwd(i2))]; %NB: ASSUMES EQUAL NUMBER OF CORRECT AND INCORRECT.
%                 end
%                 D(J,i) = mean(allcorr);
%             end
%             y(J) = mean(D(J,:));
%             yerr(J) = sqrt((y(J)*(1-y(J)))/(24*length(secondnonwd)));  %for 4 repeats of 6 conditions
%         end
%         figure(F9);%average across stim
%         error_bar(y,yerr,col(conds));
%         legend(leg);
%         y(J)
%         yerr(J)
%         
%         figure(F10);%by stim
%         idx = [sIdx{:}];
%         y2 = [D(1,:), D(2,:)];
%         for J = 1:12
%             yerr2(J) = sqrt((y2(J)*(1-y2(J)))/(4*length(secondnonwd))); % for 4 repeats of each condition
%         end
%         
%         error_bar(y2,yerr2,col(dat.condNum(idx)));
%         hh = gca;
%         set(hh,'XTickLabel',int2str(idx'));
%         set(gca,'XTick',[x{1},x{2}])
%         
%     end
%     figure(F9);
%     Session(strfind(Session,'_')) = '-';
%     title([Session 'Nonwds run 2:' Sets{I}]);
%     ylabel('Percent Correct');
%     xlabel('Gram [1]; Ungram [2]');
%     set(gca,'XTick',[1:2]);
%     if PRINT, sub_print(F9,FigDir,Session,Sets{I}); end
%     
%     figure(F10);
%     title([Session 'Nonwds run 2:' Sets{I} ' ByStimulus']);
%     ylabel('Percent Correct');
%     xlabel('Stim Number');
%     if PRINT, sub_print(F10,FigDir,Session,[Sets{I} 'nonwdsrun2_byStim']); end
%     
%     %% Create figures for third run of nonwords
%     
%     for I = 1:size(Sets),
%         F11 = figure;
%         F12 = figure;
%         conds = SetNums{I};
%         D = []; sIdx = []; y = []; yerr = [];
%         for J = 1:length(conds),
%             sIdx{J} = find(dat.condNum == conds(J));
%             for i = 1:size(sIdx{J},2)
%                 allcorr = [];
%                 for i2 = 1:length(thirdnonwd)
%                     allcorr = [allcorr dat.correct{(i+(J-1)*size(sIdx{(J)},2))}(1+4*(thirdnonwd(i2)-1):4*thirdnonwd(i2))]; %NB: ASSUMES EQUAL NUMBER OF CORRECT AND INCORRECT.
%                 end
%                 D(J,i) = mean(allcorr);
%             end
%             y(J) = mean(D(J,:));
%             yerr(J) = sqrt((y(J)*(1-y(J)))/(24*length(thirdnonwd)));  %for 4 repeats of 6 conditions
%         end
%         figure(F11);%average across stim
%         error_bar(y,yerr,col(conds));
%         legend(leg);
%         y(J)
%         yerr(J)
%         
%         figure(F12);%by stim
%         idx = [sIdx{:}];
%         y2 = [D(1,:), D(2,:)];
%         for J = 1:12
%             yerr2(J) = sqrt((y2(J)*(1-y2(J)))/(4*length(thirdnonwd))); % for 4 repeats of each condition
%         end
%         
%         error_bar(y2,yerr2,col(dat.condNum(idx)));
%         hh = gca;
%         set(hh,'XTickLabel',int2str(idx'));
%         set(gca,'XTick',[x{1},x{2}])
%         
%     end
%     figure(F11);
%     Session(strfind(Session,'_')) = '-';
%     title([Session 'Nonwds run 3:' Sets{I}]);
%     ylabel('Percent Correct');
%     xlabel('Gram [1]; Ungram [2]');
%     set(gca,'XTick',[1:2]);
%     if PRINT, sub_print(F11,FigDir,Session,Sets{I}); end
%     
%     figure(F12);
%     title([Session 'Nonwds run 3:' Sets{I} ' ByStimulus']);
%     ylabel('Percent Correct');
%     xlabel('Stim Number');
%     if PRINT, sub_print(F12,FigDir,Session,[Sets{I} 'nonwdsrun3_byStim']); end
%     
%     %% Create figures for first run of tones
%     
%     for I = 1:size(Sets),
%         F13 = figure;
%         F14 = figure;
%         conds = SetNums{I};
%         D = []; sIdx = []; y = []; yerr = [];
%         for J = 1:length(conds),
%             sIdx{J} = find(dat.condNum == conds(J));
%             for i = 1:size(sIdx{J},2)
%                 allcorr = [];
%                 for i2 = 1:length(firsttones)
%                     allcorr = [allcorr dat.correct{(i+(J-1)*size(sIdx{(J)},2))}(1+4*(firsttones(i2)-1):4*firsttones(i2))]; %NB: ASSUMES EQUAL NUMBER OF CORRECT AND INCORRECT.
%                 end
%                 D(J,i) = mean(allcorr);
%             end
%             y(J) = mean(D(J,:));
%             yerr(J) = sqrt((y(J)*(1-y(J)))/(24*length(firsttones)));  %for 4 repeats of 6 conditions
%         end
%         figure(F13);%average across stim
%         error_bar(y,yerr,col(conds));
%         legend(leg);
%         y(J)
%         yerr(J)
%         
%         figure(F14);%by stim
%         idx = [sIdx{:}];
%         y2 = [D(1,:), D(2,:)];
%         for J = 1:12
%             yerr2(J) = sqrt((y2(J)*(1-y2(J)))/(4*length(firsttones))); % for 4 repeats of each condition
%         end
%         
%         error_bar(y2,yerr2,col(dat.condNum(idx)));
%         hh = gca;
%         set(hh,'XTickLabel',int2str(idx'));
%         set(gca,'XTick',[x{1},x{2}])
%         
%     end
%     figure(F13);
%     Session(strfind(Session,'_')) = '-';
%     title([Session 'toness run 1:' Sets{I}]);
%     ylabel('Percent Correct');
%     xlabel('Gram [1]; Ungram [2]');
%     set(gca,'XTick',[1:2]);
%     if PRINT, sub_print(F13,FigDir,Session,Sets{I}); end
%     
%     figure(F14);
%     title([Session 'toness run 1:' Sets{I} ' ByStimulus']);
%     ylabel('Percent Correct');
%     xlabel('Stim Number');
%     if PRINT, sub_print(F14,FigDir,Session,[Sets{I} 'tonessrun1_byStim']); end
%     
%     %% Create figures for second run of tones
%     
%     for I = 1:size(Sets),
%         F15 = figure;
%         F16 = figure;
%         conds = SetNums{I};
%         D = []; sIdx = []; y = []; yerr = [];
%         for J = 1:length(conds),
%             sIdx{J} = find(dat.condNum == conds(J));
%             for i = 1:size(sIdx{J},2)
%                 allcorr = [];
%                 for i2 = 1:length(secondtones)
%                     allcorr = [allcorr dat.correct{(i+(J-1)*size(sIdx{(J)},2))}(1+4*(secondtones(i2)-1):4*secondtones(i2))]; %NB: ASSUMES EQUAL NUMBER OF CORRECT AND INCORRECT.
%                 end
%                 D(J,i) = mean(allcorr);
%             end
%             y(J) = mean(D(J,:));
%             yerr(J) = sqrt((y(J)*(1-y(J)))/(24*length(secondtones)));  %for 4 repeats of 6 conditions
%         end
%         figure(F15);%average across stim
%         error_bar(y,yerr,col(conds));
%         legend(leg);
%         y(J)
%         yerr(J)
%         
%         figure(F16);%by stim
%         idx = [sIdx{:}];
%         y2 = [D(1,:), D(2,:)];
%         for J = 1:12
%             yerr2(J) = sqrt((y2(J)*(1-y2(J)))/(4*length(secondtones))); % for 4 repeats of each condition
%         end
%         
%         error_bar(y2,yerr2,col(dat.condNum(idx)));
%         hh = gca;
%         set(hh,'XTickLabel',int2str(idx'));
%         set(gca,'XTick',[x{1},x{2}])
%         
%     end
%     figure(F15);
%     Session(strfind(Session,'_')) = '-';
%     title([Session 'toness run 2:' Sets{I}]);
%     ylabel('Percent Correct');
%     xlabel('Gram [1]; Ungram [2]');
%     set(gca,'XTick',[1:2]);
%     if PRINT, sub_print(F15,FigDir,Session,Sets{I}); end
%     
%     figure(F16);
%     title([Session 'toness run 2:' Sets{I} ' ByStimulus']);
%     ylabel('Percent Correct');
%     xlabel('Stim Number');
%     if PRINT, sub_print(F16,FigDir,Session,[Sets{I} 'tonessrun2_byStim']); end
%     
%     %% Create figures for third run of tones
%     
%     for I = 1:size(Sets),
%         F17 = figure;
%         F18 = figure;
%         conds = SetNums{I};
%         D = []; sIdx = []; y = []; yerr = [];
%         for J = 1:length(conds),
%             sIdx{J} = find(dat.condNum == conds(J));
%             for i = 1:size(sIdx{J},2)
%                 allcorr = [];
%                 for i2 = 1:length(thirdtones)
%                     allcorr = [allcorr dat.correct{(i+(J-1)*size(sIdx{(J)},2))}(1+4*(thirdtones(i2)-1):4*thirdtones(i2))]; %NB: ASSUMES EQUAL NUMBER OF CORRECT AND INCORRECT.
%                 end
%                 D(J,i) = mean(allcorr);
%             end
%             y(J) = mean(D(J,:));
%             yerr(J) = sqrt((y(J)*(1-y(J)))/(24*length(thirdtones)));  %for 4 repeats of 6 conditions
%         end
%         figure(F17);%average across stim
%         error_bar(y,yerr,col(conds));
%         legend(leg);
%         y(J)
%         yerr(J)
%         
%         figure(F18);%by stim
%         idx = [sIdx{:}];
%         y2 = [D(1,:), D(2,:)];
%         for J = 1:12
%             yerr2(J) = sqrt((y2(J)*(1-y2(J)))/(4*length(thirdtones))); % for 4 repeats of each condition
%         end
%         
%         error_bar(y2,yerr2,col(dat.condNum(idx)));
%         hh = gca;
%         set(hh,'XTickLabel',int2str(idx'));
%         set(gca,'XTick',[x{1},x{2}])
%         
%     end
%     figure(F17);
%     Session(strfind(Session,'_')) = '-';
%     title([Session 'toness run 3:' Sets{I}]);
%     ylabel('Percent Correct');
%     xlabel('Gram [1]; Ungram [2]');
%     set(gca,'XTick',[1:2]);
%     if PRINT, sub_print(F17,FigDir,Session,Sets{I}); end
%     
%     figure(F18);
%     title([Session 'toness run 3:' Sets{I} ' ByStimulus']);
%     ylabel('Percent Correct');
%     xlabel('Stim Number');
%     if PRINT, sub_print(F18,FigDir,Session,[Sets{I} 'tonessrun3_byStim']); end
%     
%     
end

%%Group analysis needs to be written
%yerr = std(y)/sqrt(size(y));
%y = mean(y);
%H = errorbar(t,y,yerr,col(N));



%%%%%%%%%%%%%%%%%%%%%%%%%%
function sub_print(H,FigDir,Session,Condition);

figure(H);
pname = sprintf('%s%s_%s.eps',FigDir,Session,Condition);
print('-depsc2',pname);
pname = sprintf('%s%s_%s.emf',FigDir,Session,Condition);
print('-dmeta',pname);




