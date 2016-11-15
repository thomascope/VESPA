contrast1 = load('Overall_Frontal_M-MM_contrast_48_0_26.mat');
contrast2 = load('Overall_Temporal_MM-M_contrast_-50_-26_14.mat');

IFGbars = [mean(contrast1.contrast.contrast(1:2:6)),mean(contrast1.contrast.contrast(2:2:6)),mean(contrast1.contrast.contrast(7:2:12)),mean(contrast1.contrast.contrast(8:2:12))];
IFGerrors = [mean(contrast1.contrast.standarderror(1:2:6)),mean(contrast1.contrast.standarderror(2:2:6)),mean(contrast1.contrast.standarderror(7:2:12)),mean(contrast1.contrast.standarderror(8:2:12))];
figure
hold on
bar(1:4,IFGbars)
errorbar(1:4,IFGbars,IFGerrors,'.')
title('Contrast Estimate and 90% CI for -48 0 26')

STGerrors = [mean(contrast2.contrast.standarderror(1:2:6)),mean(contrast2.contrast.standarderror(2:2:6)),mean(contrast2.contrast.standarderror(7:2:12)),mean(contrast2.contrast.standarderror(8:2:12))];
STGbars = [mean(contrast2.contrast.contrast(1:2:6)),mean(contrast2.contrast.contrast(2:2:6)),mean(contrast2.contrast.contrast(7:2:12)),mean(contrast2.contrast.contrast(8:2:12))];
figure
hold on
bar(1:4,STGbars)
errorbar(1:4,STGbars,STGerrors,'.')
title('Contrast Estimate and 90% CI for -50 -26 14')