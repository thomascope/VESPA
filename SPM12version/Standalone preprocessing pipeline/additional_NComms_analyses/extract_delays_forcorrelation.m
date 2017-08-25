addpath('/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/');
addpath(['/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source_stats/ojwoodford-export_fig-216b30e'])
subjects_and_parameters

pathstem = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_prestimcorrected_fixedICA/';
imagetype = '/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst';
imagetype_split = '/MEGPLANARrmtf_ceffbMdMrun1_1_raw_ssst';
fnames = char('sm_condition_Match_4.nii','sm_condition_Match_8.nii','sm_condition_Match_16.nii','sm_condition_Mismatch_4.nii','sm_condition_Mismatch_8.nii','sm_condition_Mismatch_16.nii');

thisdir = pwd;

thiscon = 0;
thispat = 0;
consfig = figure;
patsfig = figure;
for s = 1:length(subjects)
    try
        cd([pathstem subjects{s} imagetype])
    catch
        cd([pathstem subjects{s} imagetype_split])
    end
    congruency_contrast = spm_imcalc(fnames,'congruency_contrast.nii','(i4+i5+i6)-(i1+i2+i3)');
    iptsetpref('ImshowAxesVisible','on')
    if group(s) == 1
        thiscon = thiscon+1;
        C{thiscon} = spm_read_vols(spm_vol('congruency_contrast.nii'));
        figure(consfig)
        subplot(3,4,thiscon);
        [rows, ~, ~] = size(C{thiscon});
        newHeight = [1 3 * rows];
        %imshow(-flipud(C{thiscon}), 'YData', newHeight);
        imagesc(-flipud(C{thiscon}),[-1.2 1.2])
        colormap('jet')
        %Find max contrast and the index of where within 80% of max contrast
        all_maxs = max((C{thiscon}));
        abs_max = max(all_maxs);
        all_times = find(all_maxs>(abs_max*0.8));
        con_times(thiscon) = min(all_times)*congruency_contrast.mat(2,2)+congruency_contrast.mat(2,4);
        set(gca,'xtick',[min(all_times)],'xticklabel',num2str(con_times(thiscon)))
        set(gca,'ytick',[1 39],'yticklabel',[80 2])
        set(gcf,'color','w');
    elseif group(s) == 2
        thispat = thispat+1;
        P{thispat} = spm_read_vols(spm_vol('congruency_contrast.nii'));
        figure(patsfig)
        subplot(3,4,thispat);
        [rows, ~, ~] = size(P{thispat});
        newHeight = [1 3 * rows];
        %imshow(flipud(P{thispat}), 'YData', newHeight);
        imagesc(-flipud(P{thispat}),[-1.2 1.2])
        colormap('jet')
        %Find max contrast and the index of where within 80% of max contrast
        all_maxs = max((P{thispat}));
        abs_max = max(all_maxs);
        all_times = find(all_maxs>(abs_max*0.8));
        pat_times(thispat) = min(all_times)*congruency_contrast.mat(2,2)+congruency_contrast.mat(2,4);
        set(gca,'xtick',[min(all_times)],'xticklabel',num2str(pat_times(thispat)))
        set(gca,'ytick',[1 39],'yticklabel',[80 2])
        set(gcf,'color','w');
    end
end

cd(thisdir)

figure(consfig)
export_fig 'All_control_TFs.pdf' -transparent
figure(patsfig)
export_fig 'All_patient_TFs.pdf' -transparent


controlpriorsd = [
    1.4079
    1.2169
    2.1994
    1.6734
    0.5518
    2.4551
    2.3795
    2.3784
    1.9396
    1.6079
    1.6246];

% %New Bayesian model outputs
% controlpriorsd = [
%     1.2558
%     1.2136
%     1.9481
%     1.5141
%     0.5518
%     2.2488
%     1.5996
%     1.8240
%     1.6211
%     1.6079
%     1.4622];

patientpriorsd = [    0.2085
    0.0773
    2.2592
    1.2197
    1.3367
    0.1130
    0.3311
    0.5099
    0.1870
    1.5687];


patientpriorsd = [    0.2085
    0.0773
    2.2592
    1.2197
    1.3367
    0.1130
    0.3311
    0.5099
    1.5687
    0.1870
    ];

%
% %New Bayesian model outputs
% patientpriorsd = [
%     0.1850
%     0.0773
%     1.7831
%     1.2197
%     1.3367
%     0.0983
%     0.2766
%     0.5099
%     0.1681
%     1.5509];

[PearsonsR, p] = corr([con_times,pat_times]',[controlpriorsd;patientpriorsd])
[SpearmansR, p_s] = corr([con_times,pat_times]',[controlpriorsd;patientpriorsd],'type','Spearman')

