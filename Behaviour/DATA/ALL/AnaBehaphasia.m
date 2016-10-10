%Usage: Provide name of file or nothing if you want to find the file
%yourself
function dat = AnaBeh(SesIn);

DIRS = getdirs_psych;
fpath = DIRS.data;

Mfilename = '_All'; %for concatenated runs the name will be: ['SubjInitials' 'Mfilename']

if nargin > 0, Ses{1} = SesIn; end
if nargin == 0,
    analysismode = input('Do you want to process by type (1) or by subject (2)?');
    if analysismode == 1
        Patfiles = ls([fpath 'patients\*_Recursive*']);
        Confiles = ls([fpath 'controls\*_Recursive*']);
        Patinits = unique(Patfiles(:,1:4),'rows');
        for i = 1:size(Patinits,1)
            if Patinits(i,3) == '_'
                Patinits(i,3) = ['*'];
                Patinits(i,4) = ['*'];
            elseif Patinits(i,4) == '_'
                Patinits(i,4) = ['*'];
            end
        end
        disp('The following patients found: ');
        Patinits
        Coninits = unique(Confiles(:,1:3),'rows');
        for i = 1:size(Coninits,1)
            if Coninits(i,3) == '_'
                Coninits(i,3) = ['*'];
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
        try
            dgz = load(deblank(fname));
            dgz = dgz.dat;
            fMRIpatdat = 0;
        catch
            load(deblank(fname));
            dgz = DAT.beh;
            fMRIpatdat = 1;
        end
        
        patdat = [];
        patdat.Expt  = dgz.Expt;
        patdat.filename  = fname;
        
        % now sort by stimulus number and put in "patdat." structure
        patdat.nstim     = length(dgz.stimStr);
        patdat.stimOrder = dgz.stim;
        patdat.conds     = dgz.cond;
        patdat.condLabels= dgz.condStr;
        
        
        %recode correct in case there was a coding error
        dgz.correct = zeros(size(dgz.cond));
        dgz.correct(sum([dgz.resp==1;dgz.cond==1]) ==1) = 0;
        dgz.correct(sum([dgz.resp==1;dgz.cond==1]) ~=1) = 1;
        
        
        % Compute portion correct over last 10 runs - New to ALL aphasia study
        if exist('nsmooth','var') == 0
            %nsmooth = input('Over how many trials would you like to smooth? ');
            nsmooth = 15;
        end
        for i = 1:(length(dgz.correct))
            if i < nsmooth
                dgz.prop(i) = (sum(dgz.correct(1:i))./i);
            elseif i >= nsmooth
                dgz.prop(i) = (sum(dgz.correct((i-(nsmooth-1)):i))./nsmooth);
            end
        end
        patdat.prop = dgz.prop;
        
        for J = 1: patdat.nstim,
            StimIdx = find(patdat.stimOrder == J);
            if ~any(StimIdx),
                patdat.condNum(J) = -1; %flag empty stimulus and go on to next
                patdat.condStr{J} = [];
                patdat.stimStr{J} = [];
                patdat.resp{J} = [];
                patdat.respRT{J} = [];
                patdat.correct{J} = [];
                continue;
            end
            
            patdat.condStr{J} = dgz.condStr{unique(dgz.cond(StimIdx))};
            patdat.stimStr{J} = dgz.stimStr{J};
            
            patdat.condNum(J) = unique(dgz.cond(StimIdx));
            
            %%fix for FMRI_KB_1,
            %dgz.resp = [dgz.resp,0 0 0 0 0];
            %dgz.T.respRT_ms = dgz.T.respTR_ms;
            
            patdat.resp{J}    = dgz.resp(StimIdx);
            patdat.respRT{J}  = dgz.T.respRT_ms(StimIdx);
            patdat.correct{J} = dgz.correct(StimIdx);
            
            %compute percent correct
            patdat.pc{J} = sum(patdat.correct{J}(find(patdat.correct{J} > -1)))/length(find(patdat.correct{J} > -1));
            if fMRIpatdat,
                patdat.miss_percent{J} =  abs(sum(patdat.correct{J}(find(patdat.correct{J} == -1))))/length(patdat.correct{J});
            end
        end
        patdat.conds = unique(patdat.condNum);
        
        %save individual "patdat" structures
        save([fpath 'beh_' PatSes{S}(10:end)],'patdat');
        
        %concatenate runs
        if multi,
            if S == 1,
                patdatA = patdat;
                patdatA.filename = [];
                patdatA.filename{1} = patdat.filename;
            else
                patdatA.filename{S} = patdat.filename;
                patdatA.stimOrder = [patdatA.stimOrder patdat.stimOrder];
                for K = 1:patdat.nstim,
                    if patdat.nstim ~= patdatA.nstim, error('Number of stimuli across files don''t match!'); end
                    
                    if isempty(patdatA.condStr{K}), patdatA.condStr{K} = patdat.condStr{K}; end
                    if isempty(patdatA.stimStr{K}), patdatA.stimStr{K} = patdat.stimStr{K}; end
                    if patdatA.condNum(K) == -1, patdatA.condNum(K) = patdat.condNum(K); end
                    
                    patdatA.respRT{K} = [patdatA.respRT{K} patdat.respRT{K}];
                    patdatA.resp{K}  = [patdatA.resp{K} patdat.resp{K}];
                    patdatA.correct{K} = [patdatA.correct{K} patdat.correct{K}];
                end
                for i = 1:length(patdat.prop)
                    patdatA.prop = [patdatA.prop patdat.prop(i)];
                end
            end
        end
    end
    for S = 1:size(ConSes,2),
        disp(['Working on control file: ' fpath ConSes{S}]);
        fname = [fpath ConSes{S}];
        try
            dgz = load(deblank(fname));
            dgz = dgz.dat;
            fMRIcondat = 0;
        catch
            load(deblank(fname));
            dgz = DAT.beh;
            fMRIcondat = 1;
        end
        
        condat = [];
        condat.Expt  = dgz.Expt;
        condat.filename  = fname;
        
        % now sort by stimulus number and put in "condat." structure
        condat.nstim     = length(dgz.stimStr);
        condat.stimOrder = dgz.stim;
        condat.conds     = dgz.cond;
        condat.condLabels= dgz.condStr;
        
        
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
        condat.prop = dgz.prop;
        
        for J = 1: condat.nstim,
            StimIdx = find(condat.stimOrder == J);
            if ~any(StimIdx),
                condat.condNum(J) = -1; %flag empty stimulus and go on to next
                condat.condStr{J} = [];
                condat.stimStr{J} = [];
                condat.resp{J} = [];
                condat.respRT{J} = [];
                condat.correct{J} = [];
                continue;
            end
            
            condat.condStr{J} = dgz.condStr{unique(dgz.cond(StimIdx))};
            condat.stimStr{J} = dgz.stimStr{J};
            
            condat.condNum(J) = unique(dgz.cond(StimIdx));
            
            %%fix for FMRI_KB_1,
            %dgz.resp = [dgz.resp,0 0 0 0 0];
            %dgz.T.respRT_ms = dgz.T.respTR_ms;
            
            condat.resp{J}    = dgz.resp(StimIdx);
            condat.respRT{J}  = dgz.T.respRT_ms(StimIdx);
            condat.correct{J} = dgz.correct(StimIdx);
            
            %compute percent correct
            condat.pc{J} = sum(condat.correct{J}(find(condat.correct{J} > -1)))/length(find(condat.correct{J} > -1));
            if fMRIcondat,
                condat.miss_percent{J} =  abs(sum(condat.correct{J}(find(condat.correct{J} == -1))))/length(condat.correct{J});
            end
        end
        condat.conds = unique(condat.condNum);
        
        %save individual "condat" structures
        save([fpath 'beh_' ConSes{S}(10:end)],'condat');
        
        %concatenate runs
        if multi,
            if S == 1,
                condatA = condat;
                condatA.filename = [];
                condatA.filename{1} = condat.filename;
            else
                condatA.filename{S} = condat.filename;
                condatA.stimOrder = [condatA.stimOrder condat.stimOrder];
                for K = 1:condat.nstim,
                    if condat.nstim ~= condatA.nstim, error('Number of stimuli across files don''t match!'); end
                    
                    if isempty(condatA.condStr{K}), condatA.condStr{K} = condat.condStr{K}; end
                    if isempty(condatA.stimStr{K}), condatA.stimStr{K} = condat.stimStr{K}; end
                    if condatA.condNum(K) == -1, condatA.condNum(K) = condat.condNum(K); end
                    
                    condatA.respRT{K} = [condatA.respRT{K} condat.respRT{K}];
                    condatA.resp{K}  = [condatA.resp{K} condat.resp{K}];
                    condatA.correct{K} = [condatA.correct{K} condat.correct{K}];
                end
                for i = 1:length(condat.prop)
                    condatA.prop = [condatA.prop condat.prop(i)];
                end
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
        disp('now running AnaBehDisplay for patients ...');
        AnaBehDisplayAphasiawithindividuals(['beh_patient' Mfilename]);
        disp(['Saving concatenated control runs as: beh_control' Mfilename]);
        save([fpath 'beh_control' Mfilename],'condat');
        disp('now running AnaBehDisplay for controls ...');
        AnaBehDisplayAphasiawithindividuals(['beh_control' Mfilename]);
    elseif analysismode == 2
        disp(['Saving concatenated runs as: ' SInit Mfilename]);
        save([fpath 'beh_' SInit Mfilename],'dat');
        disp('now running AnaBehDisplay...');
        AnaBehDisplayAphasia(['beh_' SInit Mfilename]);
    end

else
    disp('now running AnaBehDisplay...');
    AnaBehDisplay(['beh_' Ses{S}]);
end