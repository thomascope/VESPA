% %% Make image from the grandmeans postweighted
% D = spm_eeg_load('wcontrols_grandmean.mat');
% bothsets{1} = D;
% D = spm_eeg_load('wpatients_grandmean.mat');
% bothsets{2} = D;
% addpath(['/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source_stats/ojwoodford-export_fig-216b30e'])
% for i = 1:2
%     figure
%     imagesc(bothsets{i}.time(26:314),bothsets{i}.frequencies(3:end),squeeze(mean(bothsets{i}(bothsets{i}.indchantype('MEG'),3:39,26:314),1)),[-1.3, 0.5])
%     set(gca,'YDir','normal')
%     set(gca,'Fontsize',20)
%     hold on
%     p1 = [0,80];
%     p2 = [0,6];
%     plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',3)
%     p1 = [-0.30,15];
%     p2 = [0.95,15];
%     plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',3)
%     p1 = [-0.30,31];
%     p2 = [0.95,31];
%     plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',3)
%     p1 = [0.468,80];
%     p2 = [0.468,6];
%     plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',5)
%     p1 = [0.6,80];
%     p2 = [0.6,6];
%     plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',5)
%     p1 = [0.868,80];
%     p2 = [0.868,6];
%     plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',5)
%     text(-0.19,11,'Alpha','Fontsize',22)
%     text(-0.19,23,'Beta','Fontsize',22)
%     xlabel('Time (ms)','Fontsize',24,'FontWeight','bold')
%     ylabel('Frequency (Hz)','Fontsize',24,'FontWeight','bold')
%     if i == 1
%         export_fig './TF_sensorspace/Annotated_match-mismatch_TF_plot_controls.png' -transparent
%         export_fig './TF_sensorspace/Annotated_match-mismatch_TF_plot_controls.tif'
%     elseif i == 2
%         export_fig './TF_sensorspace/Annotated_match-mismatch_TF_plot_patients.png' -transparent
%         export_fig './TF_sensorspace/Annotated_match-mismatch_TF_plot_patients.tif'
%     end
% 
% end

%% Make image from the weighted grandmeans file (should be pretty much the same as above)
D = spm_eeg_load('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0072_vc1/controls_weighted_grandmean.mat');
bothsets{1} = D;
D = spm_eeg_load('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0085_vp1/patients_weighted_grandmean.mat');
bothsets{2} = D;
addpath(['/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source_stats/ojwoodford-export_fig-216b30e'])
for i = 1:2
    figure
    imagesc(bothsets{i}.time(76:364),bothsets{i}.frequencies(3:end),squeeze(mean(bothsets{i}(bothsets{i}.indchantype('MEGPLANAR'),3:39,76:364,2),1)),[-1.3, 0.5])
    set(gca,'YDir','normal')
    set(gca,'Fontsize',20)
    hold on
    p1 = [0,80];
    p2 = [0,6];
    plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',3)
    p1 = [-0.30,15];
    p2 = [0.95,15];
    plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',3)
    p1 = [-0.30,31];
    p2 = [0.95,31];
    plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',3)
    p1 = [0.364,80];
    p2 = [0.364,6];
    plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',5)
    p1 = [0.6,80];
    p2 = [0.6,6];
    plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',5)
    p1 = [0.868,80];
    p2 = [0.868,6];
    plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',5)
    text(-0.15,11,'\alpha','Fontsize',24,'FontWeight','bold')
    text(-0.15,23,'\beta','Fontsize',24,'FontWeight','bold')
    xlabel('Time (ms)','Fontsize',24,'FontWeight','bold')
    ylabel('Frequency (Hz)','Fontsize',24,'FontWeight','bold')
    colorbar
    if i == 1
        export_fig './TF_sensorspace/Annotated_match-mismatch_TF_plot_controls.png' -transparent
        export_fig './TF_sensorspace/Annotated_match-mismatch_TF_plot_controls.tif'
        export_fig './TF_sensorspace/Annotated_match-mismatch_TF_plot_controls.pdf' -transparent
    elseif i == 2
        export_fig './TF_sensorspace/Annotated_match-mismatch_TF_plot_patients.png' -transparent
        export_fig './TF_sensorspace/Annotated_match-mismatch_TF_plot_patients.tif'
        export_fig './TF_sensorspace/Annotated_match-mismatch_TF_plot_patients.pdf' -transparent
    end

end

%% Make total image from the weighted grandmeans file
D = spm_eeg_load('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0072_vc1/controls_weighted_grandmean.mat');
bothsets{1} = D;
D = spm_eeg_load('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0085_vp1/patients_weighted_grandmean.mat');
bothsets{2} = D;
addpath(['/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source_stats/ojwoodford-export_fig-216b30e'])
for i = 1:2
    figure
    %imagesc(bothsets{i}.time(26:314),bothsets{i}.frequencies(3:end),squeeze(mean(bothsets{i}(bothsets{i}.indchantype('MEG'),3:39,26:314,1),1)),[-1.3, 0.5])
    imagesc(bothsets{i}.time(76:364),bothsets{i}.frequencies(3:end),squeeze(mean(bothsets{i}(bothsets{i}.indchantype('MEGPLANAR'),3:39,76:364,1),1)),[-20,8])
    set(gca,'YDir','normal')
    set(gca,'Fontsize',20)
    hold on
%     p1 = [0,80];
%     p2 = [0,6];
%     plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',3)
%     p1 = [-0.30,15];
%     p2 = [0.95,15];
%     plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',3)
%     p1 = [-0.30,31];
%     p2 = [0.95,31];
%     plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',3)
%     p1 = [0.468,80];
%     p2 = [0.468,6];
%     plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',5)
%     p1 = [0.6,80];
%     p2 = [0.6,6];
%     plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',5)
%     p1 = [0.868,80];
%     p2 = [0.868,6];
%     plot([p1(1),p2(1)],[p1(2),p2(2)],'k--','LineWidth',5)
%     text(-0.25,11,'Alpha','Fontsize',24,'FontWeight','bold')
%     text(-0.25,23,'Beta','Fontsize',24,'FontWeight','bold')
    xlabel('Time (ms)','Fontsize',24,'FontWeight','bold')
    ylabel('Frequency (Hz)','Fontsize',24,'FontWeight','bold')
    colorbar
    if i == 1
        export_fig './TF_sensorspace/Annotated_overall_TF_plot_controls.png' -transparent
        export_fig './TF_sensorspace/Annotated_overall_TF_plot_controls.tif'
        export_fig './TF_sensorspace/Annotated_overall_TF_plot_controls.pdf' -transparent
    elseif i == 2
        export_fig './TF_sensorspace/Annotated_overall_TF_plot_patients.png' -transparent
        export_fig './TF_sensorspace/Annotated_overall_TF_plot_patients.tif'
        export_fig './TF_sensorspace/Annotated_overall_TF_plot_patients.pdf' -transparent
    end

end