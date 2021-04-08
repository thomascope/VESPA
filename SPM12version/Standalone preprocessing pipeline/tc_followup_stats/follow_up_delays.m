clear all

addpath('/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/');
addpath(['/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source_stats/ojwoodford-export_fig-216b30e'])
subjects_and_parameters_follow_up_onlyboth
%subjects_and_parameters_follow_up

pathstem = '/imaging/mlr/users/tc02/vespa_followup/preprocess/SPM12_fullpipeline_tf/';
imagetype = '/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst';
imagetype_split = '/MEGPLANARrmtf_ceffbMdMrun1_1_raw_ssst';
% imagetype = '/EEGrmtf_ceffbMdMrun1_raw_ssst';
% imagetype_split = '/EEGrmtf_ceffbMdMrun1_1_raw_ssst';
% imagetype = '/MEGrmtf_ceffbMdMrun1_raw_ssst';
% imagetype_split = '/MEGrmtf_ceffbMdMrun1_1_raw_ssst';
%fnames = char('sm_condition_Match_4.nii','sm_condition_Match_8.nii','sm_condition_Match_16.nii','sm_condition_Mismatch_4.nii','sm_condition_Mismatch_8.nii','sm_condition_Mismatch_16.nii');
fnames = char('condition_Match_4.nii','condition_Match_8.nii','condition_Match_16.nii','condition_Mismatch_4.nii','condition_Mismatch_8.nii','condition_Mismatch_16.nii');

thisdir = [pwd '/ss_tf'];

thiscon = 0;
thispat = 0;
thiscon_fup = 0;
thispat_fup = 0;
consfig = figure;
patsfig = figure;
consfig_fup = figure;
patsfig_fup = figure;
conscomb = figure('pos',[350 100 400 800]);
patscomb = figure('pos',[350 100 400 800]);
for s = 1:length(subjects)
    try
        cd([pathstem subjects{s} imagetype])
    catch
        cd([pathstem subjects{s} imagetype_split])
    end
    congruency_contrast = spm_imcalc(fnames,'congruency_contrast.nii','(i4+i5+i6)-(i1+i2+i3)');
    iptsetpref('ImshowAxesVisible','on')
    dims = spm_vol('congruency_contrast.nii');
    start_vox = -(dims.mat(2,4)+100)/dims.mat(2,2);
    
    if group(s) == 1
        thiscon = thiscon+1;
        C{thiscon} = spm_read_vols(spm_vol('congruency_contrast.nii'));
        C{thiscon}(:,1:start_vox-1) = 0;
        figure(consfig)
        subplot(3,4,thiscon);
        [rows, ~, ~] = size(C{thiscon});
        newHeight = [1 3 * rows];
        %imshow(-flipud(C{thiscon}), 'YData', newHeight);
        imagesc(-flipud(C{thiscon}),[-1.2 1.2])
        colormap('jet')
        %Find max contrast and the index of where within 80% of max contrast
        all_maxs = max((C{thiscon}(1:13,:)));
        abs_max = max(all_maxs);
        all_times = find(all_maxs>(abs_max*0.8));
        con_times(thiscon) = min(all_times)*congruency_contrast.mat(2,2)+congruency_contrast.mat(2,4);
        set(gca,'xtick',[min(all_times)],'xticklabel',num2str(con_times(thiscon)))
        set(gca,'ytick',[1 39],'yticklabel',[80 2])
        set(gcf,'color','w');
        xlim([start_vox size(C{thiscon},2)])
        %Now re-plot side by side
        figure(conscomb)
        subplot(9,2,2*(thiscon-1)+1);
        [rows, ~, ~] = size(C{thiscon});
        newHeight = [1 3 * rows];
        %imshow(-flipud(C{thiscon}), 'YData', newHeight);
        imagesc(-flipud(C{thiscon}),[-1.2 1.2])
        colormap('jet')
        %Find max contrast and the index of where within 80% of max contrast
        all_maxs = max((C{thiscon}(1:13,:)));
        abs_max = max(all_maxs);
        all_times = find(all_maxs>(abs_max*0.8));
        con_times(thiscon) = min(all_times)*congruency_contrast.mat(2,2)+congruency_contrast.mat(2,4);
        set(gca,'xtick',[min(all_times)],'xticklabel',num2str(con_times(thiscon)))
        set(gca,'ytick',[1 39],'yticklabel',[80 2])
        set(gcf,'color','w');
        xlim([start_vox size(C{thiscon},2)])
    elseif group(s) == 2
        thispat = thispat+1;
        P{thispat} = spm_read_vols(spm_vol('congruency_contrast.nii'));
        P{thispat}(:,1:start_vox-1) = 0;
        figure(patsfig)
        subplot(3,4,thispat);
        [rows, ~, ~] = size(P{thispat});
        newHeight = [1 3 * rows];
        %imshow(flipud(P{thispat}), 'YData', newHeight);
        imagesc(-flipud(P{thispat}),[-1.2 1.2])
        colormap('jet')
        %Find max contrast and the index of where within 80% of max contrast
        all_maxs = max((P{thispat}(1:13,:)));
        abs_max = max(all_maxs);
        all_times = find(all_maxs>(abs_max*0.8));
        pat_times(thispat) = min(all_times)*congruency_contrast.mat(2,2)+congruency_contrast.mat(2,4);
        set(gca,'xtick',[min(all_times)],'xticklabel',num2str(pat_times(thispat)))
        set(gca,'ytick',[1 39],'yticklabel',[80 2])
        set(gcf,'color','w');
        xlim([start_vox size(P{thispat},2)])
        %Now re-plot side by side
        figure(patscomb)
        subplot(9,2,2*(thispat-1)+1);
        [rows, ~, ~] = size(P{thispat});
        newHeight = [1 3 * rows];
        %imshow(flipud(P{thispat}), 'YData', newHeight);
        imagesc(-flipud(P{thispat}),[-1.2 1.2])
        colormap('jet')
        %Find max contrast and the index of where within 80% of max contrast
        all_maxs = max((P{thispat}(1:13,:)));
        abs_max = max(all_maxs);
        all_times = find(all_maxs>(abs_max*0.8));
        pat_times(thispat) = min(all_times)*congruency_contrast.mat(2,2)+congruency_contrast.mat(2,4);
        set(gca,'xtick',[min(all_times)],'xticklabel',num2str(pat_times(thispat)))
        set(gca,'ytick',[1 39],'yticklabel',[80 2])
        set(gcf,'color','w');
        xlim([start_vox size(P{thispat},2)])
        
        
    elseif group(s) == 3
        thiscon_fup = thiscon_fup+1;
        C_fup{thiscon_fup} = spm_read_vols(spm_vol('congruency_contrast.nii'));
        figure(consfig_fup)
        subplot(3,4,thiscon_fup);
        [rows, ~, ~] = size(C_fup{thiscon_fup});
        newHeight = [1 3 * rows];
        %imshow(flipud(C_fup{thispat}), 'YData', newHeight);
        imagesc(-flipud(C_fup{thiscon_fup}),[-1.2 1.2])
        colormap('jet')
        %Find max contrast and the index of where within 80% of max contrast
        all_maxs = max((C_fup{thiscon_fup}(1:13,:)));
        abs_max = max(all_maxs);
        all_times = find(all_maxs>(abs_max*0.8));
        con_times_fup(thiscon_fup) = min(all_times)*congruency_contrast.mat(2,2)+congruency_contrast.mat(2,4);
        set(gca,'xtick',[min(all_times)],'xticklabel',num2str(con_times_fup(thiscon_fup)))
        set(gca,'ytick',[1 39],'yticklabel',[80 2])
        set(gcf,'color','w');
        xlim([start_vox size(C_fup{thiscon_fup},2)])
        %Now re-plot side by side
        figure(conscomb)
        subplot(9,2,2*(thiscon_fup-1)+2);
        [rows, ~, ~] = size(C_fup{thiscon_fup});
        newHeight = [1 3 * rows];
        %imshow(flipud(C_fup{thispat}), 'YData', newHeight);
        imagesc(-flipud(C_fup{thiscon_fup}),[-1.2 1.2])
        colormap('jet')
        %Find max contrast and the index of where within 80% of max contrast
        all_maxs = max((C_fup{thiscon_fup}(1:13,:)));
        abs_max = max(all_maxs);
        all_times = find(all_maxs>(abs_max*0.8));
        con_times_fup(thiscon_fup) = min(all_times)*congruency_contrast.mat(2,2)+congruency_contrast.mat(2,4);
        set(gca,'xtick',[min(all_times)],'xticklabel',num2str(con_times_fup(thiscon_fup)))
        set(gca,'ytick',[1 39],'yticklabel',[80 2])
        set(gcf,'color','w');
        xlim([start_vox size(C_fup{thiscon_fup},2)])
    elseif group(s) == 4
        thispat_fup = thispat_fup+1;
        P_fup{thispat_fup} = spm_read_vols(spm_vol('congruency_contrast.nii'));
        figure(patsfig_fup)
        subplot(3,4,thispat_fup);
        [rows, ~, ~] = size(P_fup{thispat_fup});
        newHeight = [1 3 * rows];
        %imshow(flipud(P_fup{thispat}), 'YData', newHeight);
        imagesc(-flipud(P_fup{thispat_fup}),[-1.2 1.2])
        colormap('jet')
        %Find max contrast and the index of where within 80% of max contrast at <=28Hz
        all_maxs = max((P_fup{thispat_fup}(1:13,:)));
        abs_max = max(all_maxs);
        all_times = find(all_maxs>(abs_max*0.8));
        pat_times_fup(thispat_fup) = min(all_times)*congruency_contrast.mat(2,2)+congruency_contrast.mat(2,4);
        set(gca,'xtick',[min(all_times)],'xticklabel',num2str(pat_times_fup(thispat_fup)))
        set(gca,'ytick',[1 39],'yticklabel',[80 2])
        set(gcf,'color','w');
        xlim([start_vox size(P_fup{thispat_fup},2)])
        %Now re-plot side by side
        figure(patscomb)
        subplot(9,2,2*(thispat_fup-1)+2);
        [rows, ~, ~] = size(P_fup{thispat_fup});
        newHeight = [1 3 * rows];
        %imshow(flipud(P_fup{thispat}), 'YData', newHeight);
        imagesc(-flipud(P_fup{thispat_fup}),[-1.2 1.2])
        colormap('jet')
        %Find max contrast and the index of where within 80% of max contrast
        all_maxs = max((P_fup{thispat_fup}(1:13,:)));
        abs_max = max(all_maxs);
        all_times = find(all_maxs>(abs_max*0.8));
        pat_times_fup(thispat_fup) = min(all_times)*congruency_contrast.mat(2,2)+congruency_contrast.mat(2,4);
        set(gca,'xtick',[min(all_times)],'xticklabel',num2str(pat_times_fup(thispat_fup)))
        set(gca,'ytick',[1 39],'yticklabel',[80 2])
        set(gcf,'color','w');
        xlim([start_vox size(P_fup{thispat_fup},2)])
    end
    
    
    
end

cd(thisdir)

% figure(consfig)
% export_fig 'All_control_baseline_TFs.pdf' -transparent
% figure(patsfig)
% export_fig 'All_patient_baseline_TFs.pdf' -transparent
% figure(consfig)
% export_fig 'All_control_fup_TFs.pdf' -transparent
% figure(patsfig)
% export_fig 'All_patient_fup_TFs.pdf' -transparent
figure(conscomb)
export_fig 'Compared_control_fup_TFs.pdf' -transparent
figure(patscomb)
export_fig 'Compared_patient_fup_TFs.pdf' -transparent

cd ..

% controlpriorsd = [
%     1.4079
%     1.2169
%     2.1994
%     1.6734
%     0.5518
%     2.4551
%     2.3795
%     2.3784
%     1.9396
%     1.6079
%     1.6246];
%
% % %New Bayesian model outputs
% % controlpriorsd = [
% %     1.2558
% %     1.2136
% %     1.9481
% %     1.5141
% %     0.5518
% %     2.2488
% %     1.5996
% %     1.8240
% %     1.6211
% %     1.6079
% %     1.4622];
%
% patientpriorsd = [    0.2085
%     0.0773
%     2.2592
%     1.2197
%     1.3367
%     0.1130
%     0.3311
%     0.5099
%     0.1870
%     1.5687];
%
%
% patientpriorsd = [    0.2085
%     0.0773
%     2.2592
%     1.2197
%     1.3367
%     0.1130
%     0.3311
%     0.5099
%     1.5687
%     0.1870
%     ];
%
% %
% % %New Bayesian model outputs
% % patientpriorsd = [
% %     0.1850
% %     0.0773
% %     1.7831
% %     1.2197
% %     1.3367
% %     0.0983
% %     0.2766
% %     0.5099
% %     0.1681
% %     1.5509];
%
% [PearsonsR, p] = corr([con_times,pat_times]',[controlpriorsd;patientpriorsd])
% [SpearmansR, p_s] = corr([con_times,pat_times]',[controlpriorsd;patientpriorsd],'type','Spearman')

