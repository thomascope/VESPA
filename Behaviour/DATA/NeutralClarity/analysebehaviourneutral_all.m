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
        patdat.filename = fname;                                                  
        
        patdat.trialarray = dgz.dataarray(1:end,:);
        
        if patdat.trialarray(1,3) > 4
            patdat.trialarray(:,3) = patdat.trialarray(:,3)-4;
        end
        
        patdat.match4=[];
        patdat.match8 = [];
        patdat.match16 = [];
        patdat.mismatch4 = [];
        patdat.mismatch8 = [];
        patdat.mismatch16 = [];
        patdat.neutral4 = [];
        patdat.neutral8 = [];
        patdat.neutral16 = [];
        for i = 1:size(patdat.trialarray,1)
            if patdat.trialarray(i,1)==1 && patdat.trialarray(i,2)==4
                patdat.match4=[patdat.match4, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==2 && patdat.trialarray(i,2)==4
                patdat.mismatch4=[patdat.mismatch4, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==3 && patdat.trialarray(i,2)==4
                patdat.neutral4=[patdat.neutral4, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==1 && patdat.trialarray(i,2)==8
                patdat.match8=[patdat.match8, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==2 && patdat.trialarray(i,2)==8
                patdat.mismatch8=[patdat.mismatch8, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==3 && patdat.trialarray(i,2)==8
                patdat.neutral8=[patdat.neutral8, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==1 && patdat.trialarray(i,2)==16
                patdat.match16=[patdat.match16, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==2 && patdat.trialarray(i,2)==16
                patdat.mismatch16=[patdat.mismatch16, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==3 && patdat.trialarray(i,2)==16
                patdat.neutral16=[patdat.neutral16, patdat.trialarray(i,3)];
            end
        end
        
        meansarray = [mean(patdat.match4),mean(patdat.mismatch4),mean(patdat.neutral4);mean(patdat.match8),mean(patdat.mismatch8),mean(patdat.neutral8);mean(patdat.match16),mean(patdat.mismatch16),mean(patdat.neutral16)];
        stdsarray = [std(patdat.match4),std(patdat.mismatch4),std(patdat.neutral4);std(patdat.match8),std(patdat.mismatch8),std(patdat.neutral8);std(patdat.match16),std(patdat.mismatch16),std(patdat.neutral16)];
        stesarray = stdsarray./sqrt(size(patdat.match4,2));   %Assumes equal number of trials in every condition
        figure
        set(gcf,'position',[100,100,1200,800])
        barweb(meansarray,stesarray,[],{'4 channels';'8 channels';'16 channels'},['Clarity Ratings by Prime Type and Vocoder Channels for Patient ' Patinits(S,:)],[],'Mean Clarity Rating',[],[],{'Match','Mismatch','Neutral'}) ;
        legend('Match','Mismatch','Neutral','location','NorthWest');
        set(gca,'ylim',[1,4])
        
        %save individual "patdat" structures and figures
        save([fpath 'beh_' PatSes{S}(11:end)],'patdat');
        saveas(gcf,[DIRS.dataFigs 'Neutral Rating Patient ' Patinits(S,:) '.jpeg'])
        
        %create concatenated datafile
        if S == 1,
            patdatA{1} = patdat;
            patdatA{1}.filename = [];
            patdatA{1}.filename = patdat.filename;
        else
            patdatA{S}.filename = patdat.filename;
            patdatA{S} = patdat;
        end

    end
    for S = 1:size(ConSes,2),
        disp(['Working on patient file: ' pwd ConSes{S}]);
        fname = [pwd ConSes{S}];
        
        dgz = load(deblank(fname));
        condat.filename = fname; 
        
        condat.trialarray = dgz.dataarray(1:end,:);
           
        if condat.trialarray(1,3) > 4
            condat.trialarray(:,3) = condat.trialarray(:,3)-4;
        end
        
        condat.match4=[];
        condat.match8 = [];
        condat.match16 = [];
        condat.mismatch4 = [];
        condat.mismatch8 = [];
        condat.mismatch16 = [];
        condat.neutral4 = [];
        condat.neutral8 = [];
        condat.neutral16 = [];
        for i = 1:size(condat.trialarray,1)
            if condat.trialarray(i,1)==1 && condat.trialarray(i,2)==4
                condat.match4=[condat.match4, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==2 && condat.trialarray(i,2)==4
                condat.mismatch4=[condat.mismatch4, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==3 && condat.trialarray(i,2)==4
                condat.neutral4=[condat.neutral4, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==1 && condat.trialarray(i,2)==8
                condat.match8=[condat.match8, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==2 && condat.trialarray(i,2)==8
                condat.mismatch8=[condat.mismatch8, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==3 && condat.trialarray(i,2)==8
                condat.neutral8=[condat.neutral8, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==1 && condat.trialarray(i,2)==16
                condat.match16=[condat.match16, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==2 && condat.trialarray(i,2)==16
                condat.mismatch16=[condat.mismatch16, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==3 && condat.trialarray(i,2)==16
                condat.neutral16=[condat.neutral16, condat.trialarray(i,3)];
            end
        end
        
        meansarray = [mean(condat.match4),mean(condat.mismatch4),mean(condat.neutral4);mean(condat.match8),mean(condat.mismatch8),mean(condat.neutral8);mean(condat.match16),mean(condat.mismatch16),mean(condat.neutral16)];
        stdsarray = [std(condat.match4),std(condat.mismatch4),std(condat.neutral4);std(condat.match8),std(condat.mismatch8),std(condat.neutral8);std(condat.match16),std(condat.mismatch16),std(condat.neutral16)];
        stesarray = stdsarray./sqrt(size(condat.match4,2));   %Assumes equal number of trials in every condition
        figure
        set(gcf,'position',[100,100,1200,800])
        barweb(meansarray,stesarray,[],{'4 channels';'8 channels';'16 channels'},['Clarity Ratings by Prime Type and Vocoder Channels for Control ' Coninits(S,:)],[],'Mean Clarity Rating',[],[],{'Match','Mismatch','Neutral'}) ;
        legend('Match','Mismatch','Neutral','location','NorthWest');
        set(gca,'ylim',[1,4])
        
        %save individual "Condat" structures
        save([fpath 'beh_' ConSes{S}(14:end)],'condat');
        saveas(gcf,[DIRS.dataFigs 'Neutral Rating Control ' Coninits(S,:) '.jpeg'])
        
        
        
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


if multi,
    if analysismode == 1
        
        patdat.trialarray = [];
        for i = 1:length(patdatA)
            patdat.trialarray = [patdat.trialarray; patdatA{i}.trialarray];
        end
               
        if patdat.trialarray(1,3) > 4
            patdat.trialarray(:,3) = patdat.trialarray(:,3)-4;
        end
        
        patdat.match4=[];
        patdat.match8 = [];
        patdat.match16 = [];
        patdat.mismatch4 = [];
        patdat.mismatch8 = [];
        patdat.mismatch16 = [];
        patdat.neutral4 = [];
        patdat.neutral8 = [];
        patdat.neutral16 = [];
        for i = 1:size(patdat.trialarray,1)
            if patdat.trialarray(i,1)==1 && patdat.trialarray(i,2)==4
                patdat.match4=[patdat.match4, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==2 && patdat.trialarray(i,2)==4
                patdat.mismatch4=[patdat.mismatch4, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==3 && patdat.trialarray(i,2)==4
                patdat.neutral4=[patdat.neutral4, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==1 && patdat.trialarray(i,2)==8
                patdat.match8=[patdat.match8, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==2 && patdat.trialarray(i,2)==8
                patdat.mismatch8=[patdat.mismatch8, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==3 && patdat.trialarray(i,2)==8
                patdat.neutral8=[patdat.neutral8, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==1 && patdat.trialarray(i,2)==16
                patdat.match16=[patdat.match16, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==2 && patdat.trialarray(i,2)==16
                patdat.mismatch16=[patdat.mismatch16, patdat.trialarray(i,3)];
            elseif patdat.trialarray(i,1)==3 && patdat.trialarray(i,2)==16
                patdat.neutral16=[patdat.neutral16, patdat.trialarray(i,3)];
            end
        end
        
        meansarray = [mean(patdat.match4),mean(patdat.mismatch4),mean(patdat.neutral4);mean(patdat.match8),mean(patdat.mismatch8),mean(patdat.neutral8);mean(patdat.match16),mean(patdat.mismatch16),mean(patdat.neutral16)];
        stdsarray = [std(patdat.match4),std(patdat.mismatch4),std(patdat.neutral4);std(patdat.match8),std(patdat.mismatch8),std(patdat.neutral8);std(patdat.match16),std(patdat.mismatch16),std(patdat.neutral16)];
        stesarray = stdsarray./sqrt(length(patdatA));   %Assumes equal number of trials in every condition
        figure
        set(gcf,'position',[100,100,1200,800])
        barweb(meansarray,stesarray,[],{'4 channels';'8 channels';'16 channels'},['Clarity Ratings by Prime Type and Vocoder Channels for All Patients '],[],'Mean Clarity Rating',[],[],{'Match','Mismatch','Neutral'}) ;
        legend('Match','Mismatch','Neutral','location','NorthWest');
        set(gca,'ylim',[1,4])
        
        patdat.meansarray = meansarray;
        patdat.stdsarray = stdsarray;
        patdat.stesarray = stesarray;
        
        %save individual "patdat" structures
        save([fpath 'beh_all'],'patdat');
        saveas(gcf,[DIRS.dataFigs 'Neutral Rating All Patients.jpeg'])
        
        condat.trialarray = [];
        for i = 1:length(condatA)
            condat.trialarray = [condat.trialarray; condatA{i}.trialarray];
        end
        
        
        if condat.trialarray(1,3) > 4
            condat.trialarray(:,3) = condat.trialarray(:,3)-4;
        end
                
        condat.match4=[];
        condat.match8 = [];
        condat.match16 = [];
        condat.mismatch4 = [];
        condat.mismatch8 = [];
        condat.mismatch16 = [];
        condat.neutral4 = [];
        condat.neutral8 = [];
        condat.neutral16 = [];
        for i = 1:size(condat.trialarray,1)
            if condat.trialarray(i,1)==1 && condat.trialarray(i,2)==4
                condat.match4=[condat.match4, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==2 && condat.trialarray(i,2)==4
                condat.mismatch4=[condat.mismatch4, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==3 && condat.trialarray(i,2)==4
                condat.neutral4=[condat.neutral4, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==1 && condat.trialarray(i,2)==8
                condat.match8=[condat.match8, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==2 && condat.trialarray(i,2)==8
                condat.mismatch8=[condat.mismatch8, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==3 && condat.trialarray(i,2)==8
                condat.neutral8=[condat.neutral8, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==1 && condat.trialarray(i,2)==16
                condat.match16=[condat.match16, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==2 && condat.trialarray(i,2)==16
                condat.mismatch16=[condat.mismatch16, condat.trialarray(i,3)];
            elseif condat.trialarray(i,1)==3 && condat.trialarray(i,2)==16
                condat.neutral16=[condat.neutral16, condat.trialarray(i,3)];
            end
        end
        
        meansarray = [mean(condat.match4),mean(condat.mismatch4),mean(condat.neutral4);mean(condat.match8),mean(condat.mismatch8),mean(condat.neutral8);mean(condat.match16),mean(condat.mismatch16),mean(condat.neutral16)];
        stdsarray = [std(condat.match4),std(condat.mismatch4),std(condat.neutral4);std(condat.match8),std(condat.mismatch8),std(condat.neutral8);std(condat.match16),std(condat.mismatch16),std(condat.neutral16)];
        stesarray = stdsarray./sqrt(length(condatA));   %Assumes equal number of trials in every condition
        figure
        set(gcf,'position',[100,100,1200,800])
        barweb(meansarray,stesarray,[],{'4 channels';'8 channels';'16 channels'},['Clarity Ratings by Prime Type and Vocoder Channels for All Controls '],[],'Mean Clarity Rating',[],[],{'Match','Mismatch','Neutral'}) ;
        legend('Match','Mismatch','Neutral','location','NorthWest');
        set(gca,'ylim',[1,4])
            
        condat.meansarray = meansarray;
        condat.stdsarray = stdsarray;
        condat.stesarray = stesarray;
       
        %save individual "condat" structures
        save([fpath 'beh_all'],'condat');
        saveas(gcf,[DIRS.dataFigs 'Neutral Rating All Controls.jpeg'])
        
        %compare group means
        allmeansarray = zeros(size(patdat.meansarray,1),size(patdat.meansarray,2)+size(condat.meansarray,2));
        allstesarray = zeros(size(patdat.stesarray,1),size(patdat.stesarray,2)+size(condat.stesarray,2));
        for i = 1:size(allmeansarray,1)
            allmeansarray(i,:) = [condat.meansarray(i,1), patdat.meansarray(i,1), condat.meansarray(i,2), patdat.meansarray(i,2), condat.meansarray(i,3), patdat.meansarray(i,3)];
            allstesarray(i,:) = [condat.stesarray(i,1), patdat.stesarray(i,1), condat.stesarray(i,2), patdat.stesarray(i,2), condat.stesarray(i,3), patdat.stesarray(i,3)];
        end
        
        figure
        set(gcf,'position',[100,100,1200,800])
        barweb(allmeansarray,allstesarray,[],{'4 channels';'8 channels';'16 channels'},['Clarity Ratings by Prime Type and Vocoder Channels for All Subjects '],[],'Mean Clarity Rating',[],[],{'ControlMatch','PatientMatch','ControlMismatch','PatientMismatch','ControlNeutral','PatientNeutral'}) ;
        set(gca,'ylim',[1,4])
        legend('ControlMatch','PatientMatch','ControlMismatch','PatientMismatch','ControlNeutral','PatientNeutral','location','NorthWest');
        saveas(gcf,[DIRS.dataFigs 'Neutral Rating All subjects.jpeg'])
        
        figure
        set(gcf,'position',[100,100,1200,800])
        lineplot = tight_subplot(1,2,[0 0],[.1 .1],[.1 .1]);
        axes(lineplot(1));
        errorbar(allmeansarray(:,1),allstesarray(:,1),'r','linewidth',3);
        hold on
        set(gca,'ylim',[1,4],'LineWidth', 2, 'Xtick', [1 2 3], 'XTickLabel',[4,8,16],'Fontsize',[14],'FontName','Tahoma')
        errorbar(allmeansarray(:,3),allstesarray(:,3),'k','linewidth',3);
        errorbar(allmeansarray(:,5),allstesarray(:,5),'b','linewidth',3);
        firstlegend = legend('Match','Mismatch','Neutral','location','NorthWest');
        set(firstlegend,'FontSize',18);
        title('Controls','Color','k','fontsize',20)
        ylabel('Clarity Rating')
        xlabel('Vocode Channels')
        
        axes(lineplot(2));
        set(gca,'ylim',[1,4])
        errorbar(allmeansarray(:,2),allstesarray(:,2),'r','linewidth',3);
        hold on
        errorbar(allmeansarray(:,4),allstesarray(:,4),'k','linewidth',3);
        errorbar(allmeansarray(:,6),allstesarray(:,6),'b','linewidth',3);
        set(gca,'ylim',[1,4],'LineWidth', 2, 'Xtick', [1 2 3], 'XTickLabel',[4,8,16],'Fontsize',[14],'FontName','Tahoma','YAxisLocation','right')
        secondlegend = legend('Match','Mismatch','Neutral','location','NorthWest');
        set(secondlegend,'FontSize',18);
        title('Patients','Color','k','fontsize',20)
        ylabel('Clarity Rating')
        xlabel('Vocode Channels')
        img = getframe(gcf);
        imwrite(img.cdata, [DIRS.dataFigs 'Neutral Rating Linegraphs.jpeg']);

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