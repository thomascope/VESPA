function dat = analysebehaviour(SesIn);

DIRS = getdirs_psych;
fpath = DIRS.data;

Mfilename = '_All'; %for concatenated runs the name will be: ['SubjInitials' 'Mfilename']

if nargin == 0,
    analysismode = input('Do you want to process by type (1) or by subject (2)?');
    if analysismode == 1
        Patfiles = ls([pwd '\PNFAdata\*.mat']);
        Confiles = ls([pwd '\controldata\*.mat']);
        Patinits = unique(Patfiles(:,1:4),'rows'); %ASSUMES 2-3 LETTER INITIALS AND 2 DIGIT AGE!!
        for i = 1:size(Patinits,1)
            if Patinits(i,4) == '.'
                Patinits(i,4) = [' '];
            end
        end
        disp('The following patients found: ');
        Patinits
        Coninits = unique(Confiles(:,1:4),'rows');
        for i = 1:size(Coninits,1)
            if Coninits(i,4) == '.'
                Coninits(i,4) = [' '];
            end
        end
        disp('The following controls found: ');
        Coninits
        for I = 1:size(Patfiles,1)
            PatSes{I} = ['\PNFAdata\' Patfiles(I,:)];
        end
        for I = 1:size(Confiles,1)
            ConSes{I} = ['\controldata\' Confiles(I,:)];
        end
        
    elseif analysismode == 2
        SInit = input('Multifile mode, enter subj initials : ','s');
        % Get all files that match initials
        if nargin == 0,
            disp('The following Files found: ');
            Files = ls(['*.mat']);
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
        disp(['Working on patient file: ' pwd PatSes{S}]);
        fname = [pwd PatSes{S}];
        
        dgz = load(deblank(fname));
        
        patdat.trialarray = dgz.dataarray(13:end,:);
        
        if patdat.trialarray(1,3) > 4
            patdat.trialarray(:,3) = patdat.trialarray(:,3)-4;
        end
        
        patdat.match4=[];
        patdat.match8 = [];
        patdat.match16 = [];
        patdat.mismatch4 = [];
        patdat.mismatch8 = [];
        patdat.mismatch16 = [];
        for i = 1:size(patdat.trialarray,1)
            if patdat.trialarray(i,1)==1 && patdat.trialarray(i,2)==4
                patdat.match4=[patdat.match4, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==2 && patdat.trialarray(i,2)==4
                patdat.mismatch4=[patdat.mismatch4, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==1 && patdat.trialarray(i,2)==8
                patdat.match8=[patdat.match8, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==2 && patdat.trialarray(i,2)==8
                patdat.mismatch8=[patdat.mismatch8, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==1 && patdat.trialarray(i,2)==16
                patdat.match16=[patdat.match16, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==2 && patdat.trialarray(i,2)==16
                patdat.mismatch16=[patdat.mismatch16, patdat.trialarray(i,3)];
            end
        end
        
        meansarray = [mean(patdat.match4),mean(patdat.mismatch4);mean(patdat.match8),mean(patdat.mismatch8);mean(patdat.match16),mean(patdat.mismatch16)];
        stdsarray = [std(patdat.match4),std(patdat.mismatch4);std(patdat.match8),std(patdat.mismatch8);std(patdat.match16),std(patdat.mismatch16)];
        stesarray = stdsarray./sqrt(size(patdat.match4,2));   %Assumes equal number of trials in every condition
        figure
        set(gcf,'position',[100,100,1200,800])
        barweb(meansarray,stesarray,[],{'4 channels';'8 channels';'16 channels'},['Clarity Ratings by Prime Type and Vocoder Channels for Patient ' Patinits(S,:)],[],'Mean Clarity Rating',[],[],{'Match','Mismatch'}) ;
        legend('Match','Mismatch','location','NorthWest');
        
        %save individual "patdat" structures and figures
        save([fpath 'beh_' PatSes{S}(11:end)],'patdat');
        saveas(gcf,[DIRS.dataFigs 'MEG Rating Patient ' Patinits(S,:) '.jpeg'])
        
    end
    for S = 1:size(ConSes,2),
        disp(['Working on patient file: ' pwd ConSes{S}]);
        fname = [pwd ConSes{S}];
        
        dgz = load(deblank(fname));
        
        condat.trialarray = dgz.dataarray(13:end,:);
        
        if condat.trialarray(1,3) > 4
            condat.trialarray(:,3) = condat.trialarray(:,3)-4;
        end
        
        condat.match4 = [];
        condat.match8 = [];
        condat.match16 = [];
        condat.mismatch4 = [];
        condat.mismatch8 = [];
        condat.mismatch16 = [];
        for i = 1:size(condat.trialarray,1)
            if condat.trialarray(i,1)==1 && condat.trialarray(i,2)==4
                condat.match4=[condat.match4, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==2 && condat.trialarray(i,2)==4
                condat.mismatch4=[condat.mismatch4, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==1 && condat.trialarray(i,2)==8
                condat.match8=[condat.match8, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==2 && condat.trialarray(i,2)==8
                condat.mismatch8=[condat.mismatch8, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==1 && condat.trialarray(i,2)==16
                condat.match16=[condat.match16, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==2 && condat.trialarray(i,2)==16
                condat.mismatch16=[condat.mismatch16, condat.trialarray(i,3)];
            end
        end
        
        meansarray = [mean(condat.match4),mean(condat.mismatch4);mean(condat.match8),mean(condat.mismatch8);mean(condat.match16),mean(condat.mismatch16)];
        stdsarray = [std(condat.match4),std(condat.mismatch4);std(condat.match8),std(condat.mismatch8);std(condat.match16),std(condat.mismatch16)];
        stesarray = stdsarray./sqrt(size(condat.match4,2));   %Assumes equal number of trials in every condition
        figure
        set(gcf,'position',[100,100,1200,800])
        barweb(meansarray,stesarray,[],{'4 channels';'8 channels';'16 channels'},['Clarity Ratings by Prime Type and Vocoder Channels for Control ' Coninits(S,:)],[],'Mean Clarity Rating',[],[],{'Match','Mismatch'}) ;
        legend('Match','Mismatch','location','NorthWest');
       
        %save individual "Condat" structures
        save([fpath 'beh_' ConSes{S}(14:end)],'condat');
        saveas(gcf,[DIRS.dataFigs 'MEG Rating Control ' Coninits(S,:) '.jpeg'])
       
    end
end