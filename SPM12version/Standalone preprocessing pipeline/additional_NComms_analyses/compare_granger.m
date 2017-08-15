datapathstem = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/extractedsources/';

load([datapathstem 'groups.mat']);
datapathstem = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/extractedsources_tf/'; %For spoken baseline
%datapathstem = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/extractedsources_tf_newbaseline/'; %For written baseline

start_times = 32;
end_times = 944;

% datapathstem = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/extractedsources_tf_null/'; %For null baseline
% 
% start_times = -968;
% end_times = -56;

all_granger_data = zeros(2,2,1,36,6,length(group));
all_congruency_contrasts = zeros(2,2,1,36,length(group));
all_clarity_contrasts = zeros(2,2,1,36,length(group));
all_controls_granger_data = [];
all_patients_granger_data = [];
all_controls_congruency_contrasts = [];
all_patients_congruency_contrasts = [];
all_controls_clarity_contrasts = [];
all_patients_clarity_contrasts = [];

demeaned_all_granger_data = zeros(2,2,1,36,6,length(group));
demeaned_all_congruency_contrasts = zeros(2,2,1,36,length(group));
demeaned_all_clarity_contrasts = zeros(2,2,1,36,length(group));
demeaned_all_controls_granger_data = [];
demeaned_all_patients_granger_data = [];
demeaned_all_controls_congruency_contrasts = [];
demeaned_all_patients_congruency_contrasts = [];
demeaned_all_controls_clarity_contrasts = [];
demeaned_all_patients_clarity_contrasts = [];

for s = 1:length(group)
    %load([datapathstem 's' num2str(s) '_evoked_grangerdata_' num2str(start_times) '_' num2str(end_times) '_overall']); %For evoked data
    load([datapathstem 's' num2str(s) '_grangerdata_' num2str(start_times) '_' num2str(end_times) '_overall']); %For timeseries data
    if rejecteeg{s} == 1 %Biases analysis
        continue
    end
    all_granger_data(:,:,:,:,:,s) = granger_data(:,:,:,:,:,101);
    demeaned_all_granger_data(:,:,:,:,:,s) = granger_data(:,:,:,:,:,101) / mean(mean(mean(nanmean(granger_data(:,:,:,:,:,101)))));
    all_congruency_contrasts(:,:,:,:,s) = mean((granger_data(:,:,:,:,[1,3,5],101)-granger_data(:,:,:,:,[2,4,6],101))/3,5);
    demeaned_all_congruency_contrasts(:,:,:,:,s) = mean((granger_data(:,:,:,:,[1,3,5],101)-granger_data(:,:,:,:,[2,4,6],101))/3,5) / mean(mean(mean(nanmean(granger_data(:,:,:,:,:,101)))));
    all_clarity_contrasts(:,:,:,:,s) = mean((granger_data(:,:,:,:,[5,6],101)-granger_data(:,:,:,:,[1,2],101))/2,5);
    demeaned_all_clarity_contrasts(:,:,:,:,s) = mean((granger_data(:,:,:,:,[5,6],101)-granger_data(:,:,:,:,[1,2],101))/2,5) / mean(mean(mean(nanmean(granger_data(:,:,:,:,:,101)))));
    if group(s) == 1
        all_controls_granger_data(:,:,:,:,:,end+1) = granger_data(:,:,:,:,:,101);
        demeaned_all_controls_granger_data(:,:,:,:,:,end+1) = granger_data(:,:,:,:,:,101)/ mean(mean(mean(nanmean(granger_data(:,:,:,:,:,101)))));
        all_controls_congruency_contrasts(:,:,:,:,end+1) = mean((granger_data(:,:,:,:,[1,3,5],101)-granger_data(:,:,:,:,[2,4,6],101))/3,5);
        demeaned_all_controls_congruency_contrasts(:,:,:,:,end+1) = mean((granger_data(:,:,:,:,[1,3,5],101)-granger_data(:,:,:,:,[2,4,6],101))/3,5)/ mean(mean(mean(nanmean(granger_data(:,:,:,:,:,101)))));
        all_controls_clarity_contrasts(:,:,:,:,end+1) = mean((granger_data(:,:,:,:,[5,6],101)-granger_data(:,:,:,:,[1,2],101))/2,5);
        demeaned_all_controls_clarity_contrasts(:,:,:,:,end+1) = mean((granger_data(:,:,:,:,[5,6],101)-granger_data(:,:,:,:,[1,2],101))/2,5)/ mean(mean(mean(nanmean(granger_data(:,:,:,:,:,101)))));
    elseif group(s) == 2
        all_patients_granger_data(:,:,:,:,:,end+1) = granger_data(:,:,:,:,:,101);
        demeaned_all_patients_granger_data(:,:,:,:,:,end+1) = granger_data(:,:,:,:,:,101)/ mean(mean(mean(nanmean(granger_data(:,:,:,:,:,101)))));
        all_patients_congruency_contrasts(:,:,:,:,end+1) = mean((granger_data(:,:,:,:,[1,3,5],101)-granger_data(:,:,:,:,[2,4,6],101))/3,5);
        demeaned_all_patients_congruency_contrasts(:,:,:,:,end+1) = mean((granger_data(:,:,:,:,[1,3,5],101)-granger_data(:,:,:,:,[2,4,6],101))/3,5)/ mean(mean(mean(nanmean(granger_data(:,:,:,:,:,101)))));
        all_patients_clarity_contrasts(:,:,:,:,end+1) = mean((granger_data(:,:,:,:,[5,6],101)-granger_data(:,:,:,:,[1,2],101))/2,5);
        demeaned_all_patients_clarity_contrasts(:,:,:,:,end+1) = mean((granger_data(:,:,:,:,[5,6],101)-granger_data(:,:,:,:,[1,2],101))/2,5)/ mean(mean(mean(nanmean(granger_data(:,:,:,:,:,101)))));
    end
    
end

figure
plot(foi,squeeze(mean(mean(all_granger_data(2,1,:,:,:,:),5),6)),'g')
hold on
plot(foi,squeeze(mean(mean(all_granger_data(1,2,:,:,:,:),5),6)),'b')
title('All Granger')
legend({'temp-front','front-temp'})
figure
plot(foi,squeeze(mean(mean(demeaned_all_granger_data(2,1,:,:,:,:),5),6)),'g')
hold on
plot(foi,squeeze(mean(mean(demeaned_all_granger_data(1,2,:,:,:,:),5),6)),'b')
title('All demeaned Granger')
legend({'temp-front','front-temp'})
% figure
% plot(foi,squeeze(mean(mean(demeaned_all_granger_data(2,1,:,:,:,:),5),6))'.*foi,'g')
% hold on
% plot(foi,squeeze(mean(mean(demeaned_all_granger_data(1,2,:,:,:,:),5),6))'.*foi,'b')
% title('All demeaned Granger - 1/f corrected')
% legend({'temp-front','front-temp'})
figure
hold on
plot(foi,squeeze(mean(mean(demeaned_all_controls_granger_data(2,1,:,:,:,:),5),6)),'g:')
plot(foi,squeeze(mean(mean(demeaned_all_patients_granger_data(2,1,:,:,:,:),5),6)),'g--')
plot(foi,squeeze(mean(mean(demeaned_all_controls_granger_data(1,2,:,:,:,:),5),6)),'b:')
plot(foi,squeeze(mean(mean(demeaned_all_patients_granger_data(1,2,:,:,:,:),5),6)),'b--')
legend({'temp-front control','temp-front patient','front-temp control','front-temp patient'})
title('By group demeaned Granger')
for i = 1:36 %Rough initial parametric stats - better to use permutation
    [h_tf(i) p_tf(i)] = ttest2(demeaned_all_controls_granger_data(2,1,:,i,:),demeaned_all_patients_granger_data(2,1,:,i,:));
    [h_ft(i) p_ft(i)] = ttest2(demeaned_all_controls_granger_data(1,2,:,i,:),demeaned_all_patients_granger_data(1,2,:,i,:));
    if h_tf(i) == 1
        plot(foi(i),0,'g*')
    end
    if h_ft(i) == 1
        plot(foi(i),0.1,'b*')
    end
end
figure
hold on
plot(foi,squeeze(mean(mean(demeaned_all_congruency_contrasts(2,1,:,:,:,:),5),6)),'g')
plot(foi,squeeze(mean(mean(demeaned_all_congruency_contrasts(1,2,:,:,:,:),5),6)),'b')
title('All demeaned Mismatch-Match')
legend({'temp-front','front-temp'})
for i = 1:36 %Rough initial parametric stats - better to use permutation
    [h_tf(i) p_tf(i)] = ttest(demeaned_all_congruency_contrasts(2,1,:,i,:,:));
    [h_ft(i) p_ft(i)] = ttest(demeaned_all_congruency_contrasts(1,2,:,i,:,:));
    if h_tf(i) == 1
        plot(foi(i),0,'g*')
    end
    if h_ft(i) == 1
        plot(foi(i),0.1,'b*')
    end
end
figure
hold on
plot(foi,squeeze(mean(mean(demeaned_all_clarity_contrasts(2,1,:,:,:,:),5),6)),'g')
plot(foi,squeeze(mean(mean(demeaned_all_clarity_contrasts(1,2,:,:,:,:),5),6)),'b')
title('All demeaned Clear-Unclear')
legend({'temp-front','front-temp'})
for i = 1:36 %Rough initial parametric stats - better to use permutation
    [h_tf(i) p_tf(i)] = ttest(demeaned_all_clarity_contrasts(2,1,:,i,:,:));
    [h_ft(i) p_ft(i)] = ttest(demeaned_all_clarity_contrasts(1,2,:,i,:,:));
    if h_tf(i) == 1
        plot(foi(i),0,'g*')
    end
    if h_ft(i) == 1
        plot(foi(i),0.1,'b*')
    end
end
figure
hold on
plot(foi,squeeze(mean(mean(demeaned_all_controls_congruency_contrasts(2,1,:,:,:,:),5),6)),'g:')
plot(foi,squeeze(mean(mean(demeaned_all_patients_congruency_contrasts(2,1,:,:,:,:),5),6)),'g--')
plot(foi,squeeze(mean(mean(demeaned_all_controls_congruency_contrasts(1,2,:,:,:,:),5),6)),'b:')
plot(foi,squeeze(mean(mean(demeaned_all_patients_congruency_contrasts(1,2,:,:,:,:),5),6)),'b--')
title('By group demeaned Mismatch-Match')
legend({'temp-front control','temp-front patient','front-temp control','front-temp patient'})
for i = 1:36 %Rough initial parametric stats - better to use permutation
    [h_tf(i) p_tf(i)] = ttest2(demeaned_all_patients_congruency_contrasts(2,1,:,i,:),demeaned_all_controls_congruency_contrasts(2,1,:,i,:));
    [h_ft(i) p_ft(i)] = ttest2(demeaned_all_patients_congruency_contrasts(1,2,:,i,:),demeaned_all_controls_congruency_contrasts(1,2,:,i,:));
    if h_tf(i) == 1
        plot(foi(i),0,'g*')
    end
    if h_ft(i) == 1
        plot(foi(i),0.1,'b*')
    end
end

