function allpowers = extract_power_from_images(imagepaths,imagename,freqwin,timewin)

allpowers = zeros(1,length(imagepaths));
for i = 1:length(imagepaths)
    thisscan = spm_read_vols(spm_vol([imagepaths{i}, imagename]));
    thisscaninfo = spm_vol([imagepaths{i}, imagename]);
    xregion = [round((timewin(1)-thisscaninfo.mat(2,4))/thisscaninfo.mat(2,2)), round((timewin(2)-thisscaninfo.mat(2,4))/thisscaninfo.mat(2,2))];
    yregion = [round((freqwin(1)-thisscaninfo.mat(1,4))/thisscaninfo.mat(1,1)), round((freqwin(2)-thisscaninfo.mat(1,4))/thisscaninfo.mat(1,1))];
    allpowers(i) = mean(mean(thisscan(yregion(1):yregion(2),xregion(1):xregion(2))));
end