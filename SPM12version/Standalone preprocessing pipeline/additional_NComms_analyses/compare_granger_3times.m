datapathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/extractedsources/';

load([datapathstem 'groups.mat']);

all_granger_data = zeros(2,2,1,36,6,length(group),3);
all_congruency_contrasts = zeros(2,2,1,36,length(group),3);
all_clarity_contrasts = zeros(2,2,1,36,length(group),3);
all_controls_granger_data = [];
all_patients_granger_data = [];
all_controls_congruency_contrasts = [];
all_patients_congruency_contrasts = [];
all_controls_clarity_contrasts = [];
all_patients_clarity_contrasts = [];

demeaned_all_granger_data = zeros(2,2,1,36,6,length(group),3);
demeaned_all_congruency_contrasts = zeros(2,2,1,36,length(group),3);
demeaned_all_clarity_contrasts = zeros(2,2,1,36,length(group),3);
demeaned_all_controls_granger_data = [];
demeaned_all_patients_granger_data = [];
demeaned_all_controls_congruency_contrasts = [];
demeaned_all_patients_congruency_contrasts = [];
demeaned_all_controls_clarity_contrasts = [];
demeaned_all_patients_clarity_contrasts = [];

for t = 1:3
    thispat = 0;
    thiscon = 0;
    start_times = 32;
    end_times = 944;
    
    if t==3
        datapathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/extractedsources_tf/'; %For spoken baseline
    elseif t==2
        datapathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/extractedsources_tf_newbaseline/'; %For written baseline
%     elseif t==1 %For debug - compare to original SPM method
%         datapathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/extractedsources_tf_back/';
    else
        datapathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/extractedsources_tf_null/'; %For null baseline
        
        start_times = -968;
        end_times = -56;
    end
%     if t==3
%         datapathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/extractedsources_tf_icoh/'; %For spoken baseline
%     elseif t==2
%         datapathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/extractedsources_tf_newbaseline_icoh/'; %For written baseline
%     else
%         datapathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/extractedsources_tf_null_icoh/'; %For null baseline
%         
%         start_times = -968;
%         end_times = -56;
%     end
%     

    
    for s = 1:length(group)
        load([datapathstem 's' num2str(s) '_grangerdata_evokedfilter_' num2str(start_times) '_' num2str(end_times) '_overall']); %For evoked data
        %load([datapathstem 's' num2str(s) '_grangerdata_' num2str(start_times) '_' num2str(end_times) '_overall']); %For timeseries data
        if rejecteeg{s} == 1 %Biases analysis
            granger_data = nan(size(granger_data));
        end
        all_granger_data(:,:,:,:,:,s,t) = granger_data(:,:,:,:,:,101);
        demeaned_all_granger_data(:,:,:,:,:,s,t) = granger_data(:,:,:,:,:,101) / mean(mean(mean(abs(nanmean(granger_data(:,:,:,:,:,101))))));
        all_congruency_contrasts(:,:,:,:,s,t) = mean((granger_data(:,:,:,:,[1,3,5],101)-granger_data(:,:,:,:,[2,4,6],101))/3,5);
        demeaned_all_congruency_contrasts(:,:,:,:,s,t) = mean((granger_data(:,:,:,:,[1,3,5],101)-granger_data(:,:,:,:,[2,4,6],101))/3,5) / mean(mean(mean(abs(nanmean(granger_data(:,:,:,:,:,101))))));
        all_clarity_contrasts(:,:,:,:,s,t) = mean((granger_data(:,:,:,:,[5,6],101)-granger_data(:,:,:,:,[1,2],101))/2,5);
        demeaned_all_clarity_contrasts(:,:,:,:,s,t) = mean((granger_data(:,:,:,:,[5,6],101)-granger_data(:,:,:,:,[1,2],101))/2,5) / mean(mean(mean(abs(nanmean(granger_data(:,:,:,:,:,101))))));
        if group(s) == 1
            thiscon = thiscon+1;
            all_controls_granger_data(:,:,:,:,:,thiscon,t) = granger_data(:,:,:,:,:,101);
            demeaned_all_controls_granger_data(:,:,:,:,:,thiscon,t) = granger_data(:,:,:,:,:,101)/ mean(mean(mean(abs(nanmean(granger_data(:,:,:,:,:,101))))));
            all_controls_congruency_contrasts(:,:,:,:,thiscon,t) = mean((granger_data(:,:,:,:,[1,3,5],101)-granger_data(:,:,:,:,[2,4,6],101))/3,5);
            demeaned_all_controls_congruency_contrasts(:,:,:,:,thiscon,t) = mean((granger_data(:,:,:,:,[1,3,5],101)-granger_data(:,:,:,:,[2,4,6],101))/3,5)/ mean(mean(mean(abs(nanmean(granger_data(:,:,:,:,:,101))))));
            all_controls_clarity_contrasts(:,:,:,:,thiscon,t) = mean((granger_data(:,:,:,:,[5,6],101)-granger_data(:,:,:,:,[1,2],101))/2,5);
            demeaned_all_controls_clarity_contrasts(:,:,:,:,thiscon,t) = mean((granger_data(:,:,:,:,[5,6],101)-granger_data(:,:,:,:,[1,2],101))/2,5)/ mean(mean(mean(abs(nanmean(granger_data(:,:,:,:,:,101))))));
        elseif group(s) == 2
            thispat = thispat+1;
            all_patients_granger_data(:,:,:,:,:,thispat,t) = granger_data(:,:,:,:,:,101);
            demeaned_all_patients_granger_data(:,:,:,:,:,thispat,t) = granger_data(:,:,:,:,:,101)/ mean(mean(mean(abs(nanmean(granger_data(:,:,:,:,:,101))))));
            all_patients_congruency_contrasts(:,:,:,:,thispat,t) = mean((granger_data(:,:,:,:,[1,3,5],101)-granger_data(:,:,:,:,[2,4,6],101))/3,5);
            demeaned_all_patients_congruency_contrasts(:,:,:,:,thispat,t) = mean((granger_data(:,:,:,:,[1,3,5],101)-granger_data(:,:,:,:,[2,4,6],101))/3,5)/ mean(mean(mean(abs(nanmean(granger_data(:,:,:,:,:,101))))));
            all_patients_clarity_contrasts(:,:,:,:,thispat,t) = mean((granger_data(:,:,:,:,[5,6],101)-granger_data(:,:,:,:,[1,2],101))/2,5);
            demeaned_all_patients_clarity_contrasts(:,:,:,:,thispat,t) = mean((granger_data(:,:,:,:,[5,6],101)-granger_data(:,:,:,:,[1,2],101))/2,5)/ mean(mean(mean(abs(nanmean(granger_data(:,:,:,:,:,101))))));
        end
        
    end
    
end

figure
plot(foi,squeeze(nanmean(nanmean(all_granger_data(2,1,:,:,:,:,1),5),6)),'g')
hold on
plot(foi,squeeze(nanmean(nanmean(all_controls_granger_data(2,1,:,:,:,:,1),5),6)),'g:')
plot(foi,squeeze(nanmean(nanmean(all_patients_granger_data(2,1,:,:,:,:,1),5),6)),'g--')
plot(foi,squeeze(nanmean(nanmean(all_granger_data(1,2,:,:,:,:,1),5),6)),'b')
plot(foi,squeeze(nanmean(nanmean(all_controls_granger_data(1,2,:,:,:,:,1),5),6)),'b:')
plot(foi,squeeze(nanmean(nanmean(all_patients_granger_data(1,2,:,:,:,:,1),5),6)),'b--')
title('All Null iCoh')
legend({'temp-front','front-temp'})


figure
plot(foi,squeeze(nanmean(nanmean(all_granger_data(2,1,:,:,:,:,2),5),6)),'g')
hold on
plot(foi,squeeze(nanmean(nanmean(all_controls_granger_data(2,1,:,:,:,:,2),5),6)),'g:')
plot(foi,squeeze(nanmean(nanmean(all_patients_granger_data(2,1,:,:,:,:,2),5),6)),'g--')
plot(foi,squeeze(nanmean(nanmean(all_granger_data(1,2,:,:,:,:,2),5),6)),'b')
plot(foi,squeeze(nanmean(nanmean(all_controls_granger_data(1,2,:,:,:,:,2),5),6)),'b:')
plot(foi,squeeze(nanmean(nanmean(all_patients_granger_data(1,2,:,:,:,:,2),5),6)),'b--')
title('All Written iCoh')
legend({'temp-front','front-temp'})


figure
plot(foi,squeeze(nanmean(nanmean(all_granger_data(2,1,:,:,:,:,3),5),6)),'g')
hold on
plot(foi,squeeze(nanmean(nanmean(all_controls_granger_data(2,1,:,:,:,:,3),5),6)),'g:')
plot(foi,squeeze(nanmean(nanmean(all_patients_granger_data(2,1,:,:,:,:,3),5),6)),'g--')
plot(foi,squeeze(nanmean(nanmean(all_granger_data(1,2,:,:,:,:,3),5),6)),'b')
plot(foi,squeeze(nanmean(nanmean(all_controls_granger_data(1,2,:,:,:,:,3),5),6)),'b:')
plot(foi,squeeze(nanmean(nanmean(all_patients_granger_data(1,2,:,:,:,:,3),5),6)),'b--')
title('All Spoken iCoh')
legend({'temp-front','front-temp'})


figure
plot(foi,squeeze(nanmean(nanmean(all_granger_data(2,1,:,:,:,:,2),5),6))-squeeze(nanmean(nanmean(all_granger_data(2,1,:,:,:,:,1),5),6)),'g')
hold on
plot(foi,squeeze(nanmean(nanmean(all_granger_data(1,2,:,:,:,:,2),5),6))-squeeze(nanmean(nanmean(all_granger_data(1,2,:,:,:,:,1),5),6)),'b')
title('All Written iCoh - null')
legend({'temp-front','front-temp'})
for i = 1:36 %Rough initial parametric stats - better to use permutation
    [h_tf(i) p_tf(i)] = ttest2(squeeze(nanmean(all_granger_data(2,1,:,i,:,:,2),5)),squeeze(nanmean(all_granger_data(2,1,:,i,:,:,1),5)));
    [h_ft(i) p_ft(i)] = ttest2(squeeze(nanmean(all_granger_data(1,2,:,i,:,:,2),5)),squeeze(nanmean(all_granger_data(1,2,:,i,:,:,1),5)));
    if h_tf(i) == 1
        plot(foi(i),0,'g*')
    end
    if h_ft(i) == 1
        plot(foi(i),0.1,'b*')
    end
end

figure
plot(foi,squeeze(nanmean(nanmean(all_granger_data(2,1,:,:,:,:,3),5),6))-squeeze(nanmean(nanmean(all_granger_data(2,1,:,:,:,:,1),5),6)),'g')
hold on
plot(foi,squeeze(nanmean(nanmean(all_granger_data(1,2,:,:,:,:,3),5),6))-squeeze(nanmean(nanmean(all_granger_data(1,2,:,:,:,:,1),5),6)),'b')
title('All Spoken iCoh - null')
legend({'temp-front','front-temp'})
for i = 1:36 %Rough initial parametric stats - better to use permutation
    [h_tf(i) p_tf(i)] = ttest2(squeeze(nanmean(all_granger_data(2,1,:,i,:,:,3),5)),squeeze(nanmean(all_granger_data(2,1,:,i,:,:,1),5)));
    [h_ft(i) p_ft(i)] = ttest2(squeeze(nanmean(all_granger_data(1,2,:,i,:,:,3),5)),squeeze(nanmean(all_granger_data(1,2,:,i,:,:,1),5)));
    if h_tf(i) == 1
        plot(foi(i),0,'g*')
    end
    if h_ft(i) == 1
        plot(foi(i),0.1,'b*')
    end
end

figure
plot(foi,squeeze(nanmean(nanmean(demeaned_all_granger_data(2,1,:,:,:,:,2),5),6))-squeeze(nanmean(nanmean(demeaned_all_granger_data(2,1,:,:,:,:,1),5),6)),'g')
hold on
plot(foi,squeeze(nanmean(nanmean(demeaned_all_granger_data(1,2,:,:,:,:,2),5),6))-squeeze(nanmean(nanmean(demeaned_all_granger_data(1,2,:,:,:,:,1),5),6)),'b')
title('All Written Demeaned Granger')
legend({'temp-front','front-temp'})
for i = 1:36 %Rough initial parametric stats - better to use permutation
    [h_tf(i) p_tf(i)] = ttest2(squeeze(nanmean(demeaned_all_granger_data(2,1,:,i,:,:,2),5)),squeeze(nanmean(demeaned_all_granger_data(2,1,:,i,:,:,1),5)));
    [h_ft(i) p_ft(i)] = ttest2(squeeze(nanmean(demeaned_all_granger_data(1,2,:,i,:,:,2),5)),squeeze(nanmean(demeaned_all_granger_data(1,2,:,i,:,:,1),5)));
    if h_tf(i) == 1
        plot(foi(i),0,'g*')
    end
    if h_ft(i) == 1
        plot(foi(i),0.1,'b*')
    end
end

figure
plot(foi,squeeze(nanmean(nanmean(demeaned_all_granger_data(2,1,:,:,:,:,3),5),6))-squeeze(nanmean(nanmean(demeaned_all_granger_data(2,1,:,:,:,:,1),5),6)),'g')
hold on
plot(foi,squeeze(nanmean(nanmean(demeaned_all_granger_data(1,2,:,:,:,:,3),5),6))-squeeze(nanmean(nanmean(demeaned_all_granger_data(1,2,:,:,:,:,1),5),6)),'b')
title('All Spoken Demeaned Granger')
legend({'temp-front','front-temp'})
for i = 1:36 %Rough initial parametric stats - better to use permutation
    [h_tf(i) p_tf(i)] = ttest2(squeeze(nanmean(demeaned_all_granger_data(2,1,:,i,:,:,3),5)),squeeze(nanmean(demeaned_all_granger_data(2,1,:,i,:,:,1),5)));
    [h_ft(i) p_ft(i)] = ttest2(squeeze(nanmean(demeaned_all_granger_data(1,2,:,i,:,:,3),5)),squeeze(nanmean(demeaned_all_granger_data(1,2,:,i,:,:,1),5)));
    if h_tf(i) == 1
        plot(foi(i),0,'g*')
    end
    if h_ft(i) == 1
        plot(foi(i),0.1,'b*')
    end
end


for t = 1:3
    figure
    hold on
    plot(foi,squeeze(nanmean(nanmean(demeaned_all_controls_granger_data(2,1,:,:,:,:,t),5),6)),'g:')
    plot(foi,squeeze(nanmean(nanmean(demeaned_all_patients_granger_data(2,1,:,:,:,:,t),5),6)),'g--')
    plot(foi,squeeze(nanmean(nanmean(demeaned_all_controls_granger_data(1,2,:,:,:,:,t),5),6)),'b:')
    plot(foi,squeeze(nanmean(nanmean(demeaned_all_patients_granger_data(1,2,:,:,:,:,t),5),6)),'b--')
    legend({'temp-front control','temp-front patient','front-temp control','front-temp patient'})
    title(['By group demeaned Granger timewin ' num2str(t) ])
    for i = 1:36 %Rough initial parametric stats - better to use permutation
        [h_tf(i) p_tf(i)] = ttest2(mean(demeaned_all_controls_granger_data(2,1,:,i,:,:,t),5),mean(demeaned_all_patients_granger_data(2,1,:,i,:,:,t),5));
        [h_ft(i) p_ft(i)] = ttest2(mean(demeaned_all_controls_granger_data(1,2,:,i,:,:,t),5),mean(demeaned_all_patients_granger_data(1,2,:,i,:,:,t),5));
        if h_tf(i) == 1
            plot(foi(i),0,'g*')
        end
        if h_ft(i) == 1
            plot(foi(i),0.1,'b*')
        end
    end
    figure
    hold on
    plot(foi,squeeze(nanmean(nanmean(demeaned_all_congruency_contrasts(2,1,:,:,:,t),5),6)),'g')
    plot(foi,squeeze(nanmean(nanmean(demeaned_all_congruency_contrasts(1,2,:,:,:,t),5),6)),'b')
    title(['All demeaned Mismatch-Match' num2str(t) ])
    legend({'temp-front','front-temp'})
    for i = 1:36 %Rough initial parametric stats - better to use permutation
        [h_tf(i) p_tf(i)] = ttest(demeaned_all_congruency_contrasts(2,1,:,i,:,t));
        [h_ft(i) p_ft(i)] = ttest(demeaned_all_congruency_contrasts(1,2,:,i,:,t));
        if h_tf(i) == 1
            plot(foi(i),0,'g*')
        end
        if h_ft(i) == 1
            plot(foi(i),0.1,'b*')
        end
    end
    figure
    hold on
    plot(foi,squeeze(nanmean(nanmean(demeaned_all_clarity_contrasts(2,1,:,:,:,t),5),6)),'g')
    plot(foi,squeeze(nanmean(nanmean(demeaned_all_clarity_contrasts(1,2,:,:,:,t),5),6)),'b')
    title(['All demeaned Clear-Unclear' num2str(t) ])
    legend({'temp-front','front-temp'})
    for i = 1:36 %Rough initial parametric stats - better to use permutation
        [h_tf(i) p_tf(i)] = ttest(demeaned_all_clarity_contrasts(2,1,:,i,:,t));
        [h_ft(i) p_ft(i)] = ttest(demeaned_all_clarity_contrasts(1,2,:,i,:,t));
        if h_tf(i) == 1
            plot(foi(i),0,'g*')
        end
        if h_ft(i) == 1
            plot(foi(i),0.1,'b*')
        end
    end
    figure
    hold on
    plot(foi,squeeze(nanmean(nanmean(demeaned_all_controls_congruency_contrasts(2,1,:,:,:,t),5),6)),'g:')
    plot(foi,squeeze(nanmean(nanmean(demeaned_all_patients_congruency_contrasts(2,1,:,:,:,t),5),6)),'g--')
    plot(foi,squeeze(nanmean(nanmean(demeaned_all_controls_congruency_contrasts(1,2,:,:,:,t),5),6)),'b:')
    plot(foi,squeeze(nanmean(nanmean(demeaned_all_patients_congruency_contrasts(1,2,:,:,:,t),5),6)),'b--')
    title(['By group demeaned Mismatch-Match' num2str(t) ])
    legend({'temp-front control','temp-front patient','front-temp control','front-temp patient'})
    for i = 1:36 %Rough initial parametric stats - better to use permutation
        [h_tf(i) p_tf(i)] = ttest2(demeaned_all_patients_congruency_contrasts(2,1,:,i,:,t),demeaned_all_controls_congruency_contrasts(2,1,:,i,:,t));
        [h_ft(i) p_ft(i)] = ttest2(demeaned_all_patients_congruency_contrasts(1,2,:,i,:,t),demeaned_all_controls_congruency_contrasts(1,2,:,i,:,t));
        if h_tf(i) == 1
            plot(foi(i),0,'g*')
        end
        if h_ft(i) == 1
            plot(foi(i),0.1,'b*')
        end
    end
end
