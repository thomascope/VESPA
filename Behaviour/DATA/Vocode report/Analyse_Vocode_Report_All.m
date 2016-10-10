%Usage: Provide name of file or nothing if you want to find the file
%yourself
function dat = Analyse_Vocode_Report(SesIn);

DIRS = getdirs_psych;
fpath = DIRS.data;

Mfilename = '_All'; %for concatenated runs the name will be: ['SubjInitials' 'Mfilename']

if nargin > 0, Ses{1} = SesIn; end
if nargin == 0,
    analysismode = input('Do you want to process by type (1) or by subject (2)?');
    if analysismode == 1
        Patfiles = ls([fpath 'patients\Vocode*']);
        Confiles = ls([fpath 'controls\Vocode*']);
        Patinits = unique(Patfiles(:,11:14),'rows'); %ASSUMES 2-3 LETTER INITIALS AND 2 DIGIT AGE!!
        for i = 1:size(Patinits,1)
            if Patinits(i,4) == '_'
                Patinits(i,4) = [' '];
            end
        end
        disp('The following patients found: ');
        Patinits
        Coninits = unique(Confiles(:,11:14),'rows');
        for i = 1:size(Coninits,1)
            if Coninits(i,4) == '_'
                Coninits(i,4) = [' '];
            end
        end
        disp('The following controls found: ');
        Coninits
        for I = 1:size(Patfiles,1)
            PatSes{I} = ['patients\' Patfiles(I,:)];
        end
        for I = 1:size(Confiles,1)
            ConSes{I} = ['controls\' Confiles(I,:)];
        end
        
    elseif analysismode == 2
        SInit = input('Multifile mode, enter subj initials : ','s');
        % Get all files that match initials
        if nargin == 0,
            disp('The following Files found: ');
            Files = ls([fpath SInit '_*']);
            if find(SInit == '_');
                Files
            else
                Files = [Files;Files];
                for n = 2:2:(size(Files,1)/2)
                    Files(n,:) = Files(((ceil(size(Files,1)*3/4))+(n/2)),:);
                end
                for n = 1:2:(size(Files,1)/2)
                    Files(n,:) = Files(((ceil(size(Files,1)*0.5))+ceil(n/2)),:);
                end
                Files((size(Files,1)/2+1):end,:) = [],
            end
            for I = 1:size(Files,1)
                Ses{I} = Files(I,:);
            end
        end
    end
    
    man = input('Process these? [1] or get files manually [0] : ');
    if ~man,
        S = 1; Ses = [];
        while S
            F = uigetfile('*.mat','Open Each File - Cancel to Quit');
            if F == 0, break; end
            Ses{S}  = F;
            S = S+1;
        end
    end
end
if analysismode == 1
    multi = 1;
elseif analysismode == 2
    if size(Ses,2) > 1, multi = 1; else multi = 0; end
end

if analysismode == 1
    for S = 1:size(PatSes,2),
        disp(['Working on patient file: ' fpath PatSes{S}]);
        fname = [fpath PatSes{S}];
        
        dgz = load(deblank(fname));
               
        patdat = [];
        patdat.dat  = dgz.dat;
        patdat.filename  = fname;
        
        patdat.target_list = dgz.target_list;
        patdat.difficulty_list = dgz.difficulty_list; %NB: 1 is hardest difficulty, 3 easiest
        patdat.correct = patdat.dat.T.correct;
        patdat.target_types = dgz.target_types;
        patdat.vocode_channels = dgz.vocode_channels;
        
        patdat.trialarray = zeros(90,3); % array of correct, target, difficulty
        patdat.trialarray(:,1) = patdat.correct;
        patdat.trialarray(:,2) = patdat.target_list; %{'base','onset_switch','offset_switch','mismatch';}
        patdat.trialarray(:,3) = patdat.difficulty_list;
        
        base4 = [];
        onset4 = [];
        offset4 = [];
        mismatch4 = [];
        base8 = [];
        onset8 = [];
        offset8 = [];
        mismatch8 = [];
        base16 = [];
        onset16 = [];
        offset16 = [];
        mismatch16 = [];
        
        for i = 1:size(patdat.trialarray,1)
            if patdat.trialarray(i,2)==2 && patdat.trialarray(i,3)==1
                base4 =[base4, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==1 && patdat.trialarray(i,3)==1
                onset4 =[onset4, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==3 && patdat.trialarray(i,3)==1
                offset4 =[offset4, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==4 && patdat.trialarray(i,3)==1
                mismatch4 =[mismatch4, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==2 && patdat.trialarray(i,3)==2
                base8 =[base8, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==1 && patdat.trialarray(i,3)==2
                onset8 =[onset8, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==3 && patdat.trialarray(i,3)==2
                offset8 =[offset8, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==4 && patdat.trialarray(i,3)==2
                mismatch8 =[mismatch8, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==2 && patdat.trialarray(i,3)==3
                base16 =[base16, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==1 && patdat.trialarray(i,3)==3
                onset16 =[onset16, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==3 && patdat.trialarray(i,3)==3
                offset16 =[offset16, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==4 && patdat.trialarray(i,3)==3
                mismatch16 =[mismatch16, patdat.trialarray(i,1)];
            end
        end
        
        meansarray = [mean(base4),mean(onset4),mean(offset4),mean(mismatch4);mean(base8),mean(onset8),mean(offset8),mean(mismatch8);mean(base16),mean(onset16),mean(offset16),mean(mismatch16)];
        meansarray = meansarray.*100;
        errorsarray = zeros(size(meansarray)); %errors to be added!
        figure
        set(gcf,'position',[100,100,1200,800])
        barweb(meansarray,errorsarray,[],patdat.vocode_channels,['Vocode Report Percent Correct for Patient:' Patinits(S,:)],[],'Percent Correct',[],[],{'Base','Onset','Offset','Mismatch'}) ;
        legend('2 neighbours','Offset neighbour','Onset neighbour','No neighbours','location','NorthWest');
                
        %save individual "patdat" structures
        save([fpath 'beh_' PatSes{S}(20:end)],'patdat');
        saveas(gcf,[DIRS.dataFigs 'Vocode Report Patient ' Patinits(S,:) '.jpeg'])
        
        %concatenate runs
        if multi,
            if S == 1,
                patdatA{1} = patdat;
                patdatA{1}.filename = [];
                patdatA{1}.filename = patdat.filename;
            else
                patdatA{S}.filename = patdat.filename;
                patdatA{S} = patdat;
            end
        end
    end
    for S = 1:size(ConSes,2),
        disp(['Working on Conient file: ' fpath ConSes{S}]);
        fname = [fpath ConSes{S}];
        
        dgz = load(deblank(fname));
               
        condat = [];
        condat.dat  = dgz.dat;
        condat.filename  = fname;
        
        condat.target_list = dgz.target_list;
        condat.difficulty_list = dgz.difficulty_list; %NB: 1 is hardest difficulty, 3 easiest
        condat.correct = condat.dat.T.correct;
        condat.target_types = dgz.target_types;
        condat.vocode_channels = dgz.vocode_channels;
        
        condat.trialarray = zeros(90,3); % array of correct, target, difficulty
        condat.trialarray(:,1) = condat.correct;
        condat.trialarray(:,2) = condat.target_list; %{'base','onset_switch','offset_switch','mismatch';}
        condat.trialarray(:,3) = condat.difficulty_list;
        
        base4 = [];
        onset4 = [];
        offset4 = [];
        mismatch4 = [];
        base8 = [];
        onset8 = [];
        offset8 = [];
        mismatch8 = [];
        base16 = [];
        onset16 = [];
        offset16 = [];
        mismatch16 = [];
        
        for i = 1:size(condat.trialarray,1)
            if condat.trialarray(i,2)==2 && condat.trialarray(i,3)==1
                base4 =[base4, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==1 && condat.trialarray(i,3)==1
                onset4 =[onset4, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==3 && condat.trialarray(i,3)==1
                offset4 =[offset4, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==4 && condat.trialarray(i,3)==1
                mismatch4 =[mismatch4, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==2 && condat.trialarray(i,3)==2
                base8 =[base8, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==1 && condat.trialarray(i,3)==2
                onset8 =[onset8, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==3 && condat.trialarray(i,3)==2
                offset8 =[offset8, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==4 && condat.trialarray(i,3)==2
                mismatch8 =[mismatch8, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==2 && condat.trialarray(i,3)==3
                base16 =[base16, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==1 && condat.trialarray(i,3)==3
                onset16 =[onset16, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==3 && condat.trialarray(i,3)==3
                offset16 =[offset16, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==4 && condat.trialarray(i,3)==3
                mismatch16 =[mismatch16, condat.trialarray(i,1)];
            end
        end
        
        meansarray = [mean(base4),mean(onset4),mean(offset4),mean(mismatch4);mean(base8),mean(onset8),mean(offset8),mean(mismatch8);mean(base16),mean(onset16),mean(offset16),mean(mismatch16)];
        meansarray = meansarray.*100;
        errorsarray = zeros(size(meansarray)); %errors to be added!
        figure
        set(gcf,'position',[100,100,1200,800])
        barweb(meansarray,errorsarray,[],condat.vocode_channels,['Vocode Report Percent Correct for Control: ' Coninits(S,:)],[],'Percent Correct',[],[],{'Base','Onset','Offset','Mismatch'}) ;
        legend('2 neighbours','Offset neighbour','Onset neighbour','No neighbours','location','NorthWest');
                
        %save individual "condat" structures
        save([fpath 'beh_' ConSes{S}(20:end)],'condat');
        saveas(gcf,[DIRS.dataFigs 'Vocode Report Control ' Coninits(S,:) '.jpeg'])
        
        %concatenate runs
        if multi,
            if S == 1,
                condatA{1} = condat;
                condatA{1}.filename = [];
                condatA{1}.filename = condat.filename;
            else
                condatA{S}.filename = condat.filename;
                condatA{S} = condat;
            end
        end
    end
    
elseif analysismode == 2
    for S = 1:size(Ses,2),
        disp(['Working on file: ' fpath '\' Ses{S}]);
        if multi,
            fname = [fpath Ses{S}];
        else
            fname = [fpath Ses{1}];
        end
        try
            dgz = load(deblank(fname));
            dgz = dgz.dat;
            fMRIdat = 0;
        catch
            load(deblank(fname));
            dgz = DAT.beh;
            fMRIdat = 1;
        end
        
        dat = [];
        dat.Expt  = dgz.Expt;
        dat.filename  = fname;
        
        % now sort by stimulus number and put in "dat." structure
        dat.nstim     = length(dgz.stimStr);
        dat.stimOrder = dgz.stim;
        dat.conds     = dgz.cond;
        dat.condLabels= dgz.condStr;
        
        
        %recode correct in case there was a coding error
        dgz.correct = zeros(size(dgz.cond));
        dgz.correct(sum([dgz.resp==1;dgz.cond==1]) ==1) = 0;
        dgz.correct(sum([dgz.resp==1;dgz.cond==1]) ~=1) = 1;
        
        
        % Compute portion correct over last 10 runs - New to ALL aphasia study
        if exist('nsmooth','var') == 0
            nsmooth = input('Over how many trials would you like to smooth? ');
        end
        for i = 1:(length(dgz.correct))
            if i < nsmooth
                dgz.prop(i) = (sum(dgz.correct(1:i))./i);
            elseif i >= nsmooth
                dgz.prop(i) = (sum(dgz.correct((i-(nsmooth-1)):i))./nsmooth);
            end
        end
        dat.prop = dgz.prop;
        
        for J = 1: dat.nstim,
            StimIdx = find(dat.stimOrder == J);
            if ~any(StimIdx),
                dat.condNum(J) = -1; %flag empty stimulus and go on to next
                dat.condStr{J} = [];
                dat.stimStr{J} = [];
                dat.resp{J} = [];
                dat.respRT{J} = [];
                dat.correct{J} = [];
                continue;
            end
            
            dat.condStr{J} = dgz.condStr{unique(dgz.cond(StimIdx))};
            dat.stimStr{J} = dgz.stimStr{J};
            
            dat.condNum(J) = unique(dgz.cond(StimIdx));
            
            %%fix for FMRI_KB_1,
            %dgz.resp = [dgz.resp,0 0 0 0 0];
            %dgz.T.respRT_ms = dgz.T.respTR_ms;
            
            dat.resp{J}    = dgz.resp(StimIdx);
            dat.respRT{J}  = dgz.T.respRT_ms(StimIdx);
            dat.correct{J} = dgz.correct(StimIdx);
            
            %compute percent correct
            dat.pc{J} = sum(dat.correct{J}(find(dat.correct{J} > -1)))/length(find(dat.correct{J} > -1));
            if fMRIdat,
                dat.miss_percent{J} =  abs(sum(dat.correct{J}(find(dat.correct{J} == -1))))/length(dat.correct{J});
            end
        end
        dat.conds = unique(dat.condNum);
        
        %save individual "dat" structures
        save([fpath 'beh_' Ses{S}],'dat');
        
        %concatenate runs
        if multi,
            if S == 1,
                datA = dat;
                datA.filename = [];
                datA.filename{1} = dat.filename;
            else
                datA.filename{S} = dat.filename;
                datA.stimOrder = [datA.stimOrder dat.stimOrder];
                for K = 1:dat.nstim,
                    if dat.nstim ~= datA.nstim, error('Number of stimuli across files don''t match!'); end
                    
                    if isempty(datA.condStr{K}), datA.condStr{K} = dat.condStr{K}; end
                    if isempty(datA.stimStr{K}), datA.stimStr{K} = dat.stimStr{K}; end
                    if datA.condNum(K) == -1, datA.condNum(K) = dat.condNum(K); end
                    
                    datA.respRT{K} = [datA.respRT{K} dat.respRT{K}];
                    datA.resp{K}  = [datA.resp{K} dat.resp{K}];
                    datA.correct{K} = [datA.correct{K} dat.correct{K}];
                end
                for i = 1:length(dat.prop)
                    datA.prop = [datA.prop dat.prop(i)];
                end
            end
        end
    end
end

if multi,
    if analysismode == 1
        patdat.target_list = [];
        patdat.difficulty_list = [];
        patdat.correct = [];
        patdat.target_types = [];
        patdat.vocode_channels = [];
        for i = 1:length(patdatA)
            patdat.target_list = [patdat.target_list, patdatA{i}.target_list];
            patdat.difficulty_list = [patdat.difficulty_list, patdatA{i}.difficulty_list];
            patdat.correct = [patdat.correct, patdatA{i}.correct];
            patdat.target_types = [patdat.target_types, patdatA{i}.target_types];
            patdat.vocode_channels = [patdat.vocode_channels, patdatA{i}.vocode_channels];
        end
        
        patdat.trialarray = zeros(90*length(patdatA),3); % array of correct, target, difficulty
        patdat.trialarray(:,1) = patdat.correct;
        patdat.trialarray(:,2) = patdat.target_list; %{'base','onset_switch','offset_switch','mismatch';}
        patdat.trialarray(:,3) = patdat.difficulty_list;
        
        base4 = [];
        onset4 = [];
        offset4 = [];
        mismatch4 = [];
        base8 = [];
        onset8 = [];
        offset8 = [];
        mismatch8 = [];
        base16 = [];
        onset16 = [];
        offset16 = [];
        mismatch16 = [];
        
        for i = 1:size(patdat.trialarray,1)
            if patdat.trialarray(i,2)==2 && patdat.trialarray(i,3)==1
                base4 =[base4, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==1 && patdat.trialarray(i,3)==1
                onset4 =[onset4, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==3 && patdat.trialarray(i,3)==1
                offset4 =[offset4, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==4 && patdat.trialarray(i,3)==1
                mismatch4 =[mismatch4, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==2 && patdat.trialarray(i,3)==2
                base8 =[base8, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==1 && patdat.trialarray(i,3)==2
                onset8 =[onset8, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==3 && patdat.trialarray(i,3)==2
                offset8 =[offset8, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==4 && patdat.trialarray(i,3)==2
                mismatch8 =[mismatch8, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==2 && patdat.trialarray(i,3)==3
                base16 =[base16, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==1 && patdat.trialarray(i,3)==3
                onset16 =[onset16, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==3 && patdat.trialarray(i,3)==3
                offset16 =[offset16, patdat.trialarray(i,1)];
            elseif patdat.trialarray(i,2)==4 && patdat.trialarray(i,3)==3
                mismatch16 =[mismatch16, patdat.trialarray(i,1)];
            end
        end
        
        meansarray = [mean(base4),mean(onset4),mean(offset4),mean(mismatch4);mean(base8),mean(onset8),mean(offset8),mean(mismatch8);mean(base16),mean(onset16),mean(offset16),mean(mismatch16)];
        meansarray = meansarray.*100;
        %errorsarray = zeros(size(meansarray)); %errors to be added!
        stdsarray = [std(base4),std(onset4),std(offset4),std(mismatch4);std(base8),std(onset8),std(offset8),std(mismatch8);std(base16),std(onset16),std(offset16),std(mismatch16)].*100;
        stesarray = stdsarray./sqrt(length(patdatA));
        figure
        set(gcf,'position',[100,100,1200,800])
        %barweb(meansarray,errorsarray,[],patdat.vocode_channels,['Vocode Report Percent Correct for All Patients'],[],'Percent Correct',[],[],{'Base','Onset','Offset','Mismatch'}) ;
        barweb(meansarray,stesarray,[],patdat.vocode_channels,['Vocode Report Percent Correct for All Patients'],[],'Percent Correct',[],[],{'Base','Onset','Offset','Mismatch'}) ;
        legend('2 neighbours','Offset neighbour','Onset neighbour','No neighbours','location','NorthWest');
                
        %save individual "patdat" structures
        save([fpath 'beh_all'],'patdat');
        saveas(gcf,[DIRS.dataFigs 'Vocode Report All Patients.jpeg'])
        
        condat.target_list = [];
        condat.difficulty_list = [];
        condat.correct = [];
        condat.target_types = [];
        condat.vocode_channels = [];
        for i = 1:length(condatA)
            condat.target_list = [condat.target_list, condatA{i}.target_list];
            condat.difficulty_list = [condat.difficulty_list, condatA{i}.difficulty_list];
            condat.correct = [condat.correct, condatA{i}.correct];
            condat.target_types = [condat.target_types, condatA{i}.target_types];
            condat.vocode_channels = [condat.vocode_channels, condatA{i}.vocode_channels];
        end
        
        condat.trialarray = zeros(90*length(condatA),3); % array of correct, target, difficulty
        condat.trialarray(:,1) = condat.correct;
        condat.trialarray(:,2) = condat.target_list; %{'base','onset_switch','offset_switch','mismatch';}
        condat.trialarray(:,3) = condat.difficulty_list;
        
        base4 = [];
        onset4 = [];
        offset4 = [];
        mismatch4 = [];
        base8 = [];
        onset8 = [];
        offset8 = [];
        mismatch8 = [];
        base16 = [];
        onset16 = [];
        offset16 = [];
        mismatch16 = [];
        
        for i = 1:size(condat.trialarray,1)
            if condat.trialarray(i,2)==2 && condat.trialarray(i,3)==1
                base4 =[base4, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==1 && condat.trialarray(i,3)==1
                onset4 =[onset4, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==3 && condat.trialarray(i,3)==1
                offset4 =[offset4, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==4 && condat.trialarray(i,3)==1
                mismatch4 =[mismatch4, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==2 && condat.trialarray(i,3)==2
                base8 =[base8, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==1 && condat.trialarray(i,3)==2
                onset8 =[onset8, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==3 && condat.trialarray(i,3)==2
                offset8 =[offset8, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==4 && condat.trialarray(i,3)==2
                mismatch8 =[mismatch8, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==2 && condat.trialarray(i,3)==3
                base16 =[base16, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==1 && condat.trialarray(i,3)==3
                onset16 =[onset16, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==3 && condat.trialarray(i,3)==3
                offset16 =[offset16, condat.trialarray(i,1)];
            elseif condat.trialarray(i,2)==4 && condat.trialarray(i,3)==3
                mismatch16 =[mismatch16, condat.trialarray(i,1)];
            end
        end
        
        meansarray = [mean(base4),mean(onset4),mean(offset4),mean(mismatch4);mean(base8),mean(onset8),mean(offset8),mean(mismatch8);mean(base16),mean(onset16),mean(offset16),mean(mismatch16)];
        meansarray = meansarray.*100;
        %errorsarray = zeros(size(meansarray)); %errors to be added!
        stdsarray = [std(base4),std(onset4),std(offset4),std(mismatch4);std(base8),std(onset8),std(offset8),std(mismatch8);std(base16),std(onset16),std(offset16),std(mismatch16)].*100;
        stesarray = stdsarray./sqrt(length(condatA));
        figure
        set(gcf,'position',[100,100,1200,800])
        %barweb(meansarray,errorsarray,[],condat.vocode_channels,['Vocode Report Percent Correct for All Controls'],[],'Percent Correct',[],[],{'Base','Onset','Offset','Mismatch'}) ;
        barweb(meansarray,stesarray,[],condat.vocode_channels,['Vocode Report Percent Correct for All Controls'],[],'Percent Correct',[],[],{'Base','Onset','Offset','Mismatch'}) ;
        legend('2 neighbours','Offset neighbour','Onset neighbour','No neighbours','location','NorthWest');
                
        %save individual "condat" structures
        save([fpath 'beh_all'],'condat');
        saveas(gcf,[DIRS.dataFigs 'Vocode Report All Controls.jpeg'])

    elseif analysismode == 2
        dat = datA;
        %re-compute percent correct
        dat.pc = [];
        for J = 1:dat.nstim,
            if any(dat.resp{J}),
                dat.pc{J} = sum(dat.correct{J}(find(dat.correct{J} > -1)))/length(find(dat.correct{J} > -1));
                if fMRIdat,
                    dat.miss_percent{J} =  sum(dat.correct{J}(find(dat.correct{J} == -1)))/length(dat.correct{J});
                end
            else
                dat.pc{J} = 1 - sum(dat.correct{J} > -1)/length(find(dat.correct{J} > -1));
                if fMRIdat,
                    dat.miss_percent{J} =  1 - sum(dat.correct{J}(find(dat.correct{J} == -1)))/length(dat.correct{J});
                end
            end
        end
    end

    %save multiple runs by subject's initials
    if analysismode == 1
        disp(['Saving concatenated patient runs as: beh_patient' Mfilename]);
        save([fpath 'beh_patient' Mfilename],'patdat');
        disp(['Saving concatenated control runs as: beh_control' Mfilename]);
        save([fpath 'beh_control' Mfilename],'condat');
    elseif analysismode == 2
        disp(['Saving concatenated runs as: ' SInit Mfilename]);
        save([fpath 'beh_' SInit Mfilename],'dat');
    end
end
