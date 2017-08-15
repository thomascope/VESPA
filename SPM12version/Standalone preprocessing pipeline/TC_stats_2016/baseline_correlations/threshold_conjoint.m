spm_read_vols(spm_vol('spmT_0003.nii'))
image = ans(:,101:376)
thresholded_image = image
thresholded_image(abs(thresholded_image)<3.58) = 0 %Threshold at 0.001 - cluster is significant
figure
imagesc(flipud(thresholded_image),[-9 9])