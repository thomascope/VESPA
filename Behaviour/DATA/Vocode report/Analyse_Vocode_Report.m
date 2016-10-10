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
               
        Condat = [];
        Condat.dat  = dgz.dat;
        Condat.filename  = fname;
        
        Condat.target_list = dgz.target_list;
        Condat.difficulty_list = dgz.difficulty_list; %NB: 1 is hardest difficulty, 3 easiest
        Condat.correct = Condat.dat.T.correct;
        Condat.target_types = dgz.target_types;
        Condat.vocode_channels = dgz.vocode_channels;
        
        Condat.trialarray = zeros(90,3); % array of correct, target, difficulty
        Condat.trialarray(:,1) = Condat.correct;
        Condat.trialarray(:,2) = Condat.target_list; %{'base','onset_switch','offset_switch','mismatch';}
        Condat.trialarray(:,3) = Condat.difficulty_list;
        
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
        
        for i = 1:size(Condat.trialarray,1)
            if Condat.trialarray(i,2)==2 && Condat.trialarray(i,3)==1
                base4 =[base4, Condat.trialarray(i,1)];
            elseif Condat.trialarray(i,2)==1 && Condat.trialarray(i,3)==1
                onset4 =[onset4, Condat.trialarray(i,1)];
            elseif Condat.trialarray(i,2)==3 && Condat.trialarray(i,3)==1
                offset4 =[offset4, Condat.trialarray(i,1)];
            elseif Condat.trialarray(i,2)==4 && Condat.trialarray(i,3)==1
                mismatch4 =[mismatch4, Condat.trialarray(i,1)];
            elseif Condat.trialarray(i,2)==2 && Condat.trialarray(i,3)==2
                base8 =[base8, Condat.trialarray(i,1)];
            elseif Condat.trialarray(i,2)==1 && Condat.trialarray(i,3)==2
                onset8 =[onset8, Condat.trialarray(i,1)];
            elseif Condat.trialarray(i,2)==3 && Condat.trialarray(i,3)==2
                offset8 =[offset8, Condat.trialarray(i,1)];
            elseif Condat.trialarray(i,2)==4 && Condat.trialarray(i,3)==2
                mismatch8 =[mismatch8, Condat.trialarray(i,1)];
            elseif Condat.trialarray(i,2)==2 && Condat.trialarray(i,3)==3
                base16 =[base16, Condat.trialarray(i,1)];
            elseif Condat.trialarray(i,2)==1 && Condat.trialarray(i,3)==3
                onset16 =[onset16, Condat.trialarray(i,1)];
            elseif Condat.trialarray(i,2)==3 && Condat.trialarray(i,3)==3
                offset16 =[offset16, Condat.trialarray(i,1)];
            elseif Condat.trialarray(i,2)==4 && Condat.trialarray(i,3)==3
                mismatch16 =[mismatch16, Condat.trialarray(i,1)];
            end
        end
        
        meansarray = [mean(base4),mean(onset4),mean(offset4),mean(mismatch4);mean(base8),mean(onset8),mean(offset8),mean(mismatch8);mean(base16),mean(onset16),mean(offset16),mean(mismatch16)];
        meansarray = meansarray.*100;
        errorsarray = zeros(size(meansarray)); %errors to be added!
        figure
        set(gcf,'position',[100,100,1200,800])
        barweb(meansarray,errorsarray,[],Condat.vocode_channels,['Vocode Report Percent Correct for Control: ' Coninits(S,:)],[],'Percent Correct',[],[],{'Base','Onset','Offset','Mismatch'}) ;
        legend('2 neighbours','Offset neighbour','Onset neighbour','No neighbours','location','NorthWest');
                
        %save individual "Condat" structures
        save([fpath 'beh_' ConSes{S}(20:end)],'Condat');
        saveas(gcf,[DIRS.dataFigs 'Vocode Report Control ' Coninits(S,:) '.jpeg'])
        
        %concatenate runs
        if multi,
            if S == 1,
                CondatA{1} = Condat;
                CondatA{1}.filename = [];
                CondatA{1}.filename = Condat.filename;
            else
                CondatA{S}.filename = Condat.filename;
                CondatA{S} = Condat;
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
        patdat = patdatA;
        %re-compute percent correct
        patdat.pc = [];
        for J = 1:patdat.nstim,
            if any(patdat.resp{J}),
                patdat.pc{J} = sum(patdat.correct{J}(find(patdat.correct{J} > -1)))/length(find(patdat.correct{J} > -1));
                if fMRIpatdat,
                    patdat.miss_percent{J} =  sum(patdat.correct{J}(find(patdat.correct{J} == -1)))/length(patdat.correct{J});
                end
            else
                patdat.pc{J} = 1 - sum(patdat.correct{J} > -1)/length(find(patdat.correct{J} > -1));
                if fMRIpatdat,
                    patdat.miss_percent{J} =  1 - sum(patdat.correct{J}(find(patdat.correct{J} == -1)))/length(patdat.correct{J});
                end
            end
        end
        condat = condatA;
        %re-compute percent correct
        condat.pc = [];
        for J = 1:condat.nstim,
            if any(condat.resp{J}),
                condat.pc{J} = sum(condat.correct{J}(find(condat.correct{J} > -1)))/length(find(condat.correct{J} > -1));
                if fMRIcondat,
                    condat.miss_percent{J} =  sum(condat.correct{J}(find(condat.correct{J} == -1)))/length(condat.correct{J});
                end
            else
                condat.pc{J} = 1 - sum(condat.correct{J} > -1)/length(find(condat.correct{J} > -1));
                if fMRIcondat,
                    condat.miss_percent{J} =  1 - sum(condat.correct{J}(find(condat.correct{J} == -1)))/length(condat.correct{J});
                end
            end
        end
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
        save([fpath 'beh_control' Mfilename],'Condat');
    elseif analysismode == 2
        disp(['Saving concatenated runs as: ' SInit Mfilename]);
        save([fpath 'beh_' SInit Mfilename],'dat');
    end
end
