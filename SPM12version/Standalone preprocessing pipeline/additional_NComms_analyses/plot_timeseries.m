datapathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/extractedsources/';
thispath = pwd;
cd(datapathstem)
%load([datapathstem 'groups.mat']);

this_con = 0;
this_pat = 0;
All_Ds = [];
All_conDs = [];
All_patDs = [];

for s = 1:21
    D = spm_eeg_load(['timeseries_for_coherence_evoked_s' num2str(s) '.mat']);
    
%     %Filter below 40Hz
%     fc = 40;
%     Wn = (2/D.fsample)*fc;
%     b = fir1(20,Wn,'low',kaiser(21,3));
%     D_filt = filter(b,1,D(:,:,:));

    D_filt = D(:,:,:); %Filtering didn't work - unclear why
%     
    All_Ds(s,:,:,:) = D_filt(:,:,:);
    All_Ds_demeaned(s,:,:,:) = D_filt(:,:,:) / mean(mean(mean(abs(D_filt(:,:,:)),2),3),1);
    if group(s)==1
        All_conDs(end+1,:,:,:) = D_filt(:,:,:);
        All_conDs_demeaned(s,:,:,:) = D_filt(:,:,:) / mean(mean(mean(abs(D_filt(:,:,:)),2),3),1);
    elseif group(s)==2
        All_patDs(end+1,:,:,:) = D_filt(:,:,:);
        All_patDs_demeaned(s,:,:,:) = D_filt(:,:,:) / mean(mean(mean(abs(D_filt(:,:,:)),2),3),1);
    end
end
% 
% figure
% plot(D.time,squeeze(mean(mean(All_Ds(:,1,:,[1,3,5]),4),1)),'r--')
% hold on
% plot(D.time,squeeze(mean(mean(All_Ds(:,1,:,[2,4,6]),4),1)),'r:')
% plot(D.time,squeeze(mean(mean(All_Ds(:,2,:,[1,3,5]),4),1)),'b--')
% plot(D.time,squeeze(mean(mean(All_Ds(:,2,:,[2,4,6]),4),1)),'b:')
% 
% figure
% plot(D.time,squeeze(mean(mean(abs(All_Ds(:,1,:,[1,3,5])),4),1)),'r--')
% hold on
% plot(D.time,squeeze(mean(mean(abs(All_Ds(:,1,:,[2,4,6])),4),1)),'r:')
% plot(D.time,squeeze(mean(mean(abs(All_Ds(:,2,:,[1,3,5])),4),1)),'b--')
% plot(D.time,squeeze(mean(mean(abs(All_Ds(:,2,:,[2,4,6])),4),1)),'b:')
% 
% figure
% plot(D.time,squeeze(mean(mean(abs(All_conDs(:,1,:,[1,3,5])),4),1)),'r--')
% hold on
% plot(D.time,squeeze(mean(mean(abs(All_conDs(:,1,:,[2,4,6])),4),1)),'r:')
% plot(D.time,squeeze(mean(mean(abs(All_conDs(:,2,:,[1,3,5])),4),1)),'b--')
% plot(D.time,squeeze(mean(mean(abs(All_conDs(:,2,:,[2,4,6])),4),1)),'b:')
% 
% figure
% plot(D.time,squeeze(mean(mean(abs(All_patDs(:,1,:,[1,3,5])),4),1)),'r--')
% hold on
% plot(D.time,squeeze(mean(mean(abs(All_patDs(:,1,:,[2,4,6])),4),1)),'r:')
% plot(D.time,squeeze(mean(mean(abs(All_patDs(:,2,:,[1,3,5])),4),1)),'b--')
% plot(D.time,squeeze(mean(mean(abs(All_patDs(:,2,:,[2,4,6])),4),1)),'b:')
% 

figure
plot(D.time,squeeze(mean(mean(abs(All_Ds_demeaned(:,1,:,[1,3,5])),4),1)),'r--')
hold on
plot(D.time,squeeze(mean(mean(abs(All_Ds_demeaned(:,1,:,[2,4,6])),4),1)),'r')
plot(D.time,squeeze(mean(mean(abs(All_Ds_demeaned(:,2,:,[1,3,5])),4),1)),'b--')
plot(D.time,squeeze(mean(mean(abs(All_Ds_demeaned(:,2,:,[2,4,6])),4),1)),'b')
ylim([0 1.6]);
title('Overall power by source and condition');
legend({'MisMatch Frontal';'Match Frontal';'MisMatch Temporal';'Match Temporal'});

figure
plot(D.time,squeeze(mean(mean(abs(All_conDs_demeaned(:,1,:,[1,3,5])),4),1)),'r--')
hold on
plot(D.time,squeeze(mean(mean(abs(All_conDs_demeaned(:,1,:,[2,4,6])),4),1)),'r')
plot(D.time,squeeze(mean(mean(abs(All_conDs_demeaned(:,2,:,[1,3,5])),4),1)),'b--')
plot(D.time,squeeze(mean(mean(abs(All_conDs_demeaned(:,2,:,[2,4,6])),4),1)),'b')
ylim([0 1.6]);
title('Control power by source and condition');
legend({'MisMatch Frontal';'Match Frontal';'MisMatch Temporal';'Match Temporal'});

figure
plot(D.time,squeeze(mean(mean(abs(All_patDs_demeaned(:,1,:,[1,3,5])),4),1)),'r--')
hold on
plot(D.time,squeeze(mean(mean(abs(All_patDs_demeaned(:,1,:,[2,4,6])),4),1)),'r')
plot(D.time,squeeze(mean(mean(abs(All_patDs_demeaned(:,2,:,[1,3,5])),4),1)),'b--')
plot(D.time,squeeze(mean(mean(abs(All_patDs_demeaned(:,2,:,[2,4,6])),4),1)),'b')
ylim([0 1.6]);
title('Patient power by source and condition');
legend({'MisMatch Frontal';'Match Frontal';'MisMatch Temporal';'Match Temporal'});

figure
plot(D.time,squeeze(mean(mean(abs(All_conDs_demeaned(:,1,:,:)),4),1)),'r--')
hold on
plot(D.time,squeeze(mean(mean(abs(All_patDs_demeaned(:,1,:,:)),4),1)),'b--')
plot(D.time,squeeze(mean(mean(abs(All_conDs_demeaned(:,2,:,:)),4),1)),'r')
plot(D.time,squeeze(mean(mean(abs(All_patDs_demeaned(:,2,:,:)),4),1)),'b')
title('By group overall power by source');
legend({'Controls Frontal';'Patients Frontal';'Controls Temporal';'Patients Temporal'});

figure
plot(D.time,squeeze(mean(mean(abs(All_conDs_demeaned(:,1,:,[1,3,5])),4),1))-squeeze(mean(mean(abs(All_conDs_demeaned(:,1,:,[2,4,6])),4),1)),'r--')
hold on
plot(D.time,squeeze(mean(mean(abs(All_patDs_demeaned(:,1,:,[1,3,5])),4),1))-squeeze(mean(mean(abs(All_patDs_demeaned(:,1,:,[2,4,6])),4),1)),'b--')
plot(D.time,squeeze(mean(mean(abs(All_conDs_demeaned(:,2,:,[1,3,5])),4),1))-squeeze(mean(mean(abs(All_conDs_demeaned(:,2,:,[2,4,6])),4),1)),'r')
plot(D.time,squeeze(mean(mean(abs(All_patDs_demeaned(:,2,:,[1,3,5])),4),1))-squeeze(mean(mean(abs(All_patDs_demeaned(:,2,:,[2,4,6])),4),1)),'b')
plot(D.time,zeros(size(D.time)),'k--')
title('By group congruency contrast by source');
legend({'Controls Frontal';'Patients Frontal';'Controls Temporal';'Patients Temporal'});

cd(thispath)
