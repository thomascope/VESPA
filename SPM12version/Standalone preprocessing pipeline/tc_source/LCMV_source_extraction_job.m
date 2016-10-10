%-----------------------------------------------------------------------
% Job saved on 29-Jan-2015 12:00:48 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.tools.beamforming.output.BF = '<UNDEFINED>';
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.method = 'max';
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(1).label = 'Left IFG - Sohoglu';
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(1).pos = [-54 18 20];
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(1).radius = 12;
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(2).label = 'Left STG - Sohoglu';
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(2).pos = [-56 -24 4];
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(2).radius = 12;
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(3).label = 'Left SMG - early P+C, C';
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(3).pos = [-38 -40 34];
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(3).radius = 12;
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(4).label = 'Right COp - early P+C';
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(4).pos = [52 -2 4];
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(4).radius = 12;
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(5).label = 'Left SFG - early P+C';
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(5).pos = [-14 44 40];
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(5).radius = 12;
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(6).label = 'Left TMP - early C-P';
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(6).pos = [-54 14 -12];
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(6).radius = 12;
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(7).label = 'Left AnG - Mid P+C, P, C';
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(7).pos = [-50 -54 48];
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(7).radius = 12;
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(8).label = 'Left AnG - Late C';
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(8).pos = [-36 -54 40];
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(8).radius = 12;
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(9).label = 'Left PoG/PrG - Late P-C';
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(9).pos = [-46 -16 36];
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(9).radius = 12;
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(10).label = 'Right PoG - Late C REVERSE';
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(10).pos = [48 -10 36];
matlabbatch{1}.spm.tools.beamforming.output.plugin.montage.voidef(10).radius = 12;
matlabbatch{2}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{2}.spm.tools.beamforming.write.plugin.spmeeg.mode = 'write';
matlabbatch{2}.spm.tools.beamforming.write.plugin.spmeeg.modality = 'MEG';
matlabbatch{2}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.none = 0;
matlabbatch{2}.spm.tools.beamforming.write.plugin.spmeeg.prefix = 'B';
