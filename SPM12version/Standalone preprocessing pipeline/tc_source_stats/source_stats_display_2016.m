%%
%% Display source reconstructions and bar charts for each group and condition

cfg.plots = [1];
cfg.symmetricity = 'symmetrical';
% cfg.normalise = 1;
% cfg.threshold = [5 40];
cfg.inflate = 10;

addpath([pwd '/ojwoodford-export_fig-216b30e'])

windows = [90 130; 180 240; 270 420; 450 700; 750 900; 90 150; 200 280; 290 440; 450 700; 710 860];

cfg.normalise = 0;
cfg.threshold = [1.65 3.15]; %p=0.05

for i = 1:length(windows)
  
    jp_spm8_surfacerender2_version_tc(['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/' num2str(windows(i,1)) '_' num2str(windows(i,2)) '/spmT_0003.nii'],'jet',cfg)
    savepath = ['./Source_Reconstructions/Controls_2016_SPM_' num2str(i)];
    eval(['export_fig ' savepath '.png -transparent -m2.5'])
    
    jp_spm8_surfacerender2_version_tc(['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/' num2str(windows(i,1)) '_' num2str(windows(i,2)) '/spmT_0004.nii'],'jet',cfg)
    savepath = ['./Source_Reconstructions/Patients_2016_SPM_' num2str(i)];
    eval(['export_fig ' savepath '.png -transparent -m2.5'])
    
    filename = ['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/' num2str(windows(i,1)) '_' num2str(windows(i,2)) '/SPM.mat'];
    groupdifference_here(filename,[-50 12 20], 11, 9); %Pre-defined OPIFG region
    savepath = ['./Source_Reconstructions/Bars_OPIFG_2016_SPM_' num2str(i)];
    eval(['export_fig ' savepath '.png -transparent'])
    eval(['export_fig ' savepath '.pdf -transparent'])
    groupdifference_here(filename,[-56 -34 12], 11, 9); %Pre-defined OPIFG region
    savepath = ['./Source_Reconstructions/Bars_STG_2016_SPM_' num2str(i)];
    eval(['export_fig ' savepath '.png -transparent'])
    eval(['export_fig ' savepath '.pdf -transparent'])
    groupdifference_here(filename,[-46 2 28], 11, 9); %Pre-defined OPIFG region
    savepath = ['./Source_Reconstructions/Bars_frontal_2016_SPM_' num2str(i)];
    eval(['export_fig ' savepath '.png -transparent'])
    eval(['export_fig ' savepath '.pdf -transparent'])
        
end

cfg.normalise = 0;
cfg.threshold = [1.65 3.15]; %p=0.05
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/spmT_0002.nii','jet',cfg)
export_fig ./Source_Reconstructions/Combined_2016_SPM_Overall_1.png -transparent -m2.5


jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/spmT_0003.nii','jet',cfg)
export_fig ./Source_Reconstructions/Controls_2016_SPM_Overall_1.png -transparent -m2.5 


jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/spmT_0004.nii','jet',cfg)
export_fig ./Source_Reconstructions/Patients_2016_SPM_Overall_1.png -transparent -m2.5


filename = ['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/SPM.mat'];
groupdifference_here(filename,[-50 12 20], 11, 9); %Pre-defined OPIFG region
savepath = ['./Source_Reconstructions/Bars_OPIFG_2016_SPM_overall.png'];
eval(['export_fig ' savepath '.png -transparent'])
eval(['export_fig ' savepath '.pdf -transparent'])
groupdifference_here(filename,[-56 -34 12], 11, 9); %Pre-defined OPIFG region
savepath = ['./Source_Reconstructions/Bars_STG_2016_SPM_overall.png'];
eval(['export_fig ' savepath '.png -transparent'])
eval(['export_fig ' savepath '.pdf -transparent'])
filename = ['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/SPM.mat'];
groupdifference_here(filename,[-46 2 28], 11, 9); %Max frontal group difference 
savepath = ['./Source_Reconstructions/Bars_frontal_2016_SPM_overall.png'];
eval(['export_fig ' savepath '.png -transparent'])
eval(['export_fig ' savepath '.pdf -transparent'])

% Now Create Composite Image
figure
[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_1.png');
imagearray = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 3));

imagearray_alphas = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 1));
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1:size(image_alphas,2),1) = image_alphas;

for imagenumber = 2:4
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Controls_2016_SPM_' num2str(imagenumber) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1+(imagenumber-1)*size(image_alphas,2):imagenumber*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 6:9
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Patients_2016_SPM_' num2str(imagenumber-5) '.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1+(imagenumber-6)*size(image_to_add,2):(imagenumber-5)*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),1+(imagenumber-6)*size(image_alphas,2):(imagenumber-5)*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 1:4
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_OPIFG_2016_SPM_' num2str(imagenumber) '.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_' num2str(imagenumber) '.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = image_alphas;
    
end
for imagenumber = 5
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_OPIFG_2016_SPM_overall.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_overall.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
end

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_Overall_1.png');
imagearray(1:size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),end+1-size(image_alphas,2):end,1) = image_alphas;

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Patients_2016_SPM_Overall_1.png');
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),end+1-size(image_to_add,2):end,:) = image_alphas;



f = imshow(imagearray);
set(f, 'AlphaData', imagearray_alphas);

savepath = ['./Source_Reconstructions/thresholded_2016_SPM_total.png'];
imwrite(imagearray,savepath,'png','Alpha',imagearray_alphas)

imagearray_3d = zeros(size(imagearray_alphas,1),size(imagearray_alphas,2),3);
imagearray_3d = logical(imagearray_3d);
for i = 1:3
    imagearray_3d(:,:,i)=imagearray_alphas==0;
end

imagearray(imagearray_3d)=255;
savepath = ['./Source_Reconstructions/thresholded_2016_SPM_total_white.png'];
imwrite(imagearray,savepath,'png')

% Now Create Composite Image for new timewindows
figure
[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_6.png');
imagearray = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 3));

imagearray_alphas = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 1));
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1:size(image_alphas,2),1) = image_alphas;

for imagenumber = 2:4
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Controls_2016_SPM_' num2str(imagenumber+5) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1+(imagenumber-1)*size(image_alphas,2):imagenumber*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 6:9
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Patients_2016_SPM_' num2str(imagenumber+5-5) '.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1+(imagenumber-6)*size(image_to_add,2):(imagenumber-5)*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),1+(imagenumber-6)*size(image_alphas,2):(imagenumber-5)*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 1:4
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_OPIFG_2016_SPM_' num2str(imagenumber+5) '.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_' num2str(imagenumber+5) '.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = image_alphas;
    
end
for imagenumber = 5
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_OPIFG_2016_SPM_overall.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_overall.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
end

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_Overall_1.png');
imagearray(1:size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),end+1-size(image_alphas,2):end,1) = image_alphas;

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Patients_2016_SPM_Overall_1.png');
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),end+1-size(image_to_add,2):end,:) = image_alphas;



f = imshow(imagearray);
set(f, 'AlphaData', imagearray_alphas);

savepath = ['./Source_Reconstructions/thresholded_2016_SPM_newtimewindows_total.png'];
imwrite(imagearray,savepath,'png','Alpha',imagearray_alphas)

imagearray_3d = zeros(size(imagearray_alphas,1),size(imagearray_alphas,2),3);
imagearray_3d = logical(imagearray_3d);
for i = 1:3
    imagearray_3d(:,:,i)=imagearray_alphas==0;
end

imagearray(imagearray_3d)=255;
savepath = ['./Source_Reconstructions/thresholded_2016_SPM_newtimewindows_total_white.png'];
imwrite(imagearray,savepath,'png')


% Now Create Composite Image with frontal region
figure
[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_1.png');
imagearray = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 3));

imagearray_alphas = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 1));
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1:size(image_alphas,2),1) = image_alphas;

for imagenumber = 2:4
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Controls_2016_SPM_' num2str(imagenumber) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1+(imagenumber-1)*size(image_alphas,2):imagenumber*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 6:9
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Patients_2016_SPM_' num2str(imagenumber-5) '.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1+(imagenumber-6)*size(image_to_add,2):(imagenumber-5)*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),1+(imagenumber-6)*size(image_alphas,2):(imagenumber-5)*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 1:4
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_frontal_2016_SPM_' num2str(imagenumber) '.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_' num2str(imagenumber) '.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = image_alphas;
    
end
for imagenumber = 5
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_frontal_2016_SPM_overall.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_overall.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
end

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_Overall_1.png');
imagearray(1:size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),end+1-size(image_alphas,2):end,1) = image_alphas;

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Patients_2016_SPM_Overall_1.png');
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),end+1-size(image_to_add,2):end,:) = image_alphas;



f = imshow(imagearray);
set(f, 'AlphaData', imagearray_alphas);

savepath = ['./Source_Reconstructions/thresholded_2016_frontal_SPM_total.png'];
imwrite(imagearray,savepath,'png','Alpha',imagearray_alphas)

imagearray_3d = zeros(size(imagearray_alphas,1),size(imagearray_alphas,2),3);
imagearray_3d = logical(imagearray_3d);
for i = 1:3
    imagearray_3d(:,:,i)=imagearray_alphas==0;
end

imagearray(imagearray_3d)=255;
savepath = ['./Source_Reconstructions/thresholded_2016_frontal_SPM_total_white.png'];
imwrite(imagearray,savepath,'png')

% Now Create Composite Image for new timewindows
figure
[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_6.png');
imagearray = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 3));

imagearray_alphas = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 1));
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1:size(image_alphas,2),1) = image_alphas;

for imagenumber = 2:4
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Controls_2016_SPM_' num2str(imagenumber+5) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1+(imagenumber-1)*size(image_alphas,2):imagenumber*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 6:9
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Patients_2016_SPM_' num2str(imagenumber+5-5) '.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1+(imagenumber-6)*size(image_to_add,2):(imagenumber-5)*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),1+(imagenumber-6)*size(image_alphas,2):(imagenumber-5)*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 1:4
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_frontal_2016_SPM_' num2str(imagenumber+5) '.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_' num2str(imagenumber+5) '.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = image_alphas;
    
end
for imagenumber = 5
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_frontal_2016_SPM_overall.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_overall.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
end

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_Overall_1.png');
imagearray(1:size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),end+1-size(image_alphas,2):end,1) = image_alphas;

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Patients_2016_SPM_Overall_1.png');
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),end+1-size(image_to_add,2):end,:) = image_alphas;



f = imshow(imagearray);
set(f, 'AlphaData', imagearray_alphas);

savepath = ['./Source_Reconstructions/thresholded_2016_SPM_frontal_newtimewindows_total.png'];
imwrite(imagearray,savepath,'png','Alpha',imagearray_alphas)

imagearray_3d = zeros(size(imagearray_alphas,1),size(imagearray_alphas,2),3);
imagearray_3d = logical(imagearray_3d);
for i = 1:3
    imagearray_3d(:,:,i)=imagearray_alphas==0;
end

imagearray(imagearray_3d)=255;
savepath = ['./Source_Reconstructions/thresholded_2016_SPM_frontal_newtimewindows_total_white.png'];
imwrite(imagearray,savepath,'png')

%% Now do the same but with same yscale on bar graphs


for i = 1:length(windows)
  
    filename = ['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/' num2str(windows(i,1)) '_' num2str(windows(i,2)) '/SPM.mat'];
    groupdifference_here_scaled(filename,[-50 12 20], 11, 9, [0.05 0.1]); %Pre-defined OPIFG region
    savepath = ['./Source_Reconstructions/Bars_OPIFG_2016_SPM_' num2str(i) '_scaled'];
    eval(['export_fig ' savepath '.png -transparent'])
    eval(['export_fig ' savepath '.pdf -transparent'])
    groupdifference_here_scaled(filename,[-56 -34 12], 11, 9, [0.1 0.25]); %Pre-defined STG region
    savepath = ['./Source_Reconstructions/Bars_STG_2016_SPM_' num2str(i) '_scaled'];
    eval(['export_fig ' savepath '.png -transparent'])
    eval(['export_fig ' savepath '.pdf -transparent'])
    groupdifference_here_scaled(filename,[-46 2 28], 11, 9, [0.05 0.1]); %Max frontal group difference 
    savepath = ['./Source_Reconstructions/Bars_frontal_2016_SPM_' num2str(i) '_scaled'];
    eval(['export_fig ' savepath '.png -transparent'])
    eval(['export_fig ' savepath '.pdf -transparent'])
        
end

filename = ['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/SPM.mat'];
groupdifference_here_scaled(filename,[-50 12 20], 11, 9, [0.05 0.1]); %Pre-defined OPIFG region
savepath = ['./Source_Reconstructions/Bars_OPIFG_2016_SPM_overall_scaled'];
eval(['export_fig ' savepath '.png -transparent'])
eval(['export_fig ' savepath '.pdf -transparent'])
groupdifference_here_scaled(filename,[-56 -34 12], 11, 9, [0.1 0.25]); %Pre-defined STG region
savepath = ['./Source_Reconstructions/Bars_STG_2016_SPM_overall_scaled'];
eval(['export_fig ' savepath '.png -transparent'])
eval(['export_fig ' savepath '.pdf -transparent'])
filename = ['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/SPM.mat'];
groupdifference_here_scaled(filename,[-46 2 28], 11, 9, [0.05 0.1]); %Max frontal group difference 
savepath = ['./Source_Reconstructions/Bars_frontal_2016_SPM_overall_scaled'];
eval(['export_fig ' savepath '.png -transparent'])
eval(['export_fig ' savepath '.pdf -transparent'])

% Now Create Composite Image
figure
[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_1.png');
imagearray = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 3));

imagearray_alphas = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 1));
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1:size(image_alphas,2),1) = image_alphas;

for imagenumber = 2:4
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Controls_2016_SPM_' num2str(imagenumber) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1+(imagenumber-1)*size(image_alphas,2):imagenumber*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 6:9
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Patients_2016_SPM_' num2str(imagenumber-5) '.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1+(imagenumber-6)*size(image_to_add,2):(imagenumber-5)*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),1+(imagenumber-6)*size(image_alphas,2):(imagenumber-5)*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 1:4
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_OPIFG_2016_SPM_' num2str(imagenumber) '_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_' num2str(imagenumber) '_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = image_alphas;
    
end
for imagenumber = 5
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_OPIFG_2016_SPM_overall_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_overall_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
end

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_Overall_1.png');
imagearray(1:size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),end+1-size(image_alphas,2):end,1) = image_alphas;

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Patients_2016_SPM_Overall_1.png');
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),end+1-size(image_to_add,2):end,:) = image_alphas;



f = imshow(imagearray);
set(f, 'AlphaData', imagearray_alphas);

savepath = ['./Source_Reconstructions/thresholded_scaled_2016_SPM_total.png'];
imwrite(imagearray,savepath,'png','Alpha',imagearray_alphas)

imagearray_3d = zeros(size(imagearray_alphas,1),size(imagearray_alphas,2),3);
imagearray_3d = logical(imagearray_3d);
for i = 1:3
    imagearray_3d(:,:,i)=imagearray_alphas==0;
end

imagearray(imagearray_3d)=255;
savepath = ['./Source_Reconstructions/thresholded_scaled_2016_SPM_total_white.png'];
imwrite(imagearray,savepath,'png')

% Now Create Composite Image for new timewindows
figure
[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_6.png');
imagearray = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 3));

imagearray_alphas = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 1));
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1:size(image_alphas,2),1) = image_alphas;

for imagenumber = 2:4
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Controls_2016_SPM_' num2str(imagenumber+5) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1+(imagenumber-1)*size(image_alphas,2):imagenumber*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 6:9
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Patients_2016_SPM_' num2str(imagenumber+5-5) '.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1+(imagenumber-6)*size(image_to_add,2):(imagenumber-5)*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),1+(imagenumber-6)*size(image_alphas,2):(imagenumber-5)*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 1:4
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_OPIFG_2016_SPM_' num2str(imagenumber+5) '_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_' num2str(imagenumber+5) '_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = image_alphas;
    
end
for imagenumber = 5
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_OPIFG_2016_SPM_overall_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_overall_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
end

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_Overall_1.png');
imagearray(1:size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),end+1-size(image_alphas,2):end,1) = image_alphas;

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Patients_2016_SPM_Overall_1.png');
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),end+1-size(image_to_add,2):end,:) = image_alphas;



f = imshow(imagearray);
set(f, 'AlphaData', imagearray_alphas);

savepath = ['./Source_Reconstructions/thresholded_scaled_2016_SPM_newtimewindows_total.png'];
imwrite(imagearray,savepath,'png','Alpha',imagearray_alphas)

imagearray_3d = zeros(size(imagearray_alphas,1),size(imagearray_alphas,2),3);
imagearray_3d = logical(imagearray_3d);
for i = 1:3
    imagearray_3d(:,:,i)=imagearray_alphas==0;
end

imagearray(imagearray_3d)=255;
savepath = ['./Source_Reconstructions/thresholded_scaled_2016_SPM_newtimewindows_total_white.png'];
imwrite(imagearray,savepath,'png')


% Now Create Composite Image with frontal region
figure
[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_1.png');
imagearray = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 3));

imagearray_alphas = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 1));
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1:size(image_alphas,2),1) = image_alphas;

for imagenumber = 2:4
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Controls_2016_SPM_' num2str(imagenumber) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1+(imagenumber-1)*size(image_alphas,2):imagenumber*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 6:9
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Patients_2016_SPM_' num2str(imagenumber-5) '.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1+(imagenumber-6)*size(image_to_add,2):(imagenumber-5)*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),1+(imagenumber-6)*size(image_alphas,2):(imagenumber-5)*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 1:4
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_frontal_2016_SPM_' num2str(imagenumber) '_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_' num2str(imagenumber) '_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = image_alphas;
    
end
for imagenumber = 5
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_frontal_2016_SPM_overall_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_overall_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
end

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_Overall_1.png');
imagearray(1:size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),end+1-size(image_alphas,2):end,1) = image_alphas;

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Patients_2016_SPM_Overall_1.png');
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),end+1-size(image_to_add,2):end,:) = image_alphas;



f = imshow(imagearray);
set(f, 'AlphaData', imagearray_alphas);

savepath = ['./Source_Reconstructions/thresholded_scaled_2016_frontal_SPM_total.png'];
imwrite(imagearray,savepath,'png','Alpha',imagearray_alphas)

imagearray_3d = zeros(size(imagearray_alphas,1),size(imagearray_alphas,2),3);
imagearray_3d = logical(imagearray_3d);
for i = 1:3
    imagearray_3d(:,:,i)=imagearray_alphas==0;
end

imagearray(imagearray_3d)=255;
savepath = ['./Source_Reconstructions/thresholded_scaled_2016_frontal_SPM_total_white.png'];
imwrite(imagearray,savepath,'png')

% Now Create Composite Image for new timewindows
figure
[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_6.png');
imagearray = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 3));

imagearray_alphas = uint8(zeros((size(image_to_add,1)*2)+400, ceil(size(image_to_add,2)*5.3), 1));
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1:size(image_alphas,2),1) = image_alphas;

for imagenumber = 2:4
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Controls_2016_SPM_' num2str(imagenumber+5) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),1+(imagenumber-1)*size(image_alphas,2):imagenumber*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 6:9
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Patients_2016_SPM_' num2str(imagenumber+5-5) '.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1+(imagenumber-6)*size(image_to_add,2):(imagenumber-5)*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),1+(imagenumber-6)*size(image_alphas,2):(imagenumber-5)*size(image_alphas,2),1) = image_alphas;
end
for imagenumber = 1:4
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_frontal_2016_SPM_' num2str(imagenumber+5) '_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+(imagenumber-1)*size(image_to_add,2):size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_' num2str(imagenumber+5) '_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+(imagenumber-1)*size(image_to_add,2):500+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = image_alphas;
    
end
for imagenumber = 5
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_frontal_2016_SPM_overall_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,1+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
    [graph_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Bars_STG_2016_SPM_overall_scaled.png']);
    imagearray(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),:) = graph_to_add;
    imagearray_alphas(end+1-size(graph_to_add,1):end,501+ceil(size(image_to_add,2)*0.3)+(imagenumber-1)*size(image_to_add,2):500+ceil(size(image_to_add,2)*0.3)+size(graph_to_add,2)+(imagenumber-1)*size(image_to_add,2),1) = image_alphas;
    
end

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_Overall_1.png');
imagearray(1:size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),end+1-size(image_alphas,2):end,1) = image_alphas;

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Patients_2016_SPM_Overall_1.png');
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),end+1-size(image_to_add,2):end,:) = image_alphas;



f = imshow(imagearray);
set(f, 'AlphaData', imagearray_alphas);

savepath = ['./Source_Reconstructions/thresholded_scaled_2016_SPM_frontal_newtimewindows_total.png'];
imwrite(imagearray,savepath,'png','Alpha',imagearray_alphas)

imagearray_3d = zeros(size(imagearray_alphas,1),size(imagearray_alphas,2),3);
imagearray_3d = logical(imagearray_3d);
for i = 1:3
    imagearray_3d(:,:,i)=imagearray_alphas==0;
end

imagearray(imagearray_3d)=255;
savepath = ['./Source_Reconstructions/thresholded_scaled_2016_SPM_frontal_newtimewindows_total_white.png'];
imwrite(imagearray,savepath,'png')





% jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/90_130/spmT_0003.nii','jet',cfg)
% export_fig ./Source_Reconstructions/Controls_2016_SPM_1.png -transparent -m2.5
% jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/180_240/spmT_0003.nii','jet',cfg)
% export_fig ./Source_Reconstructions/Controls_2016_SPM_2.png -transparent -m2.5
% jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/270_420/spmT_0003.nii','jet',cfg)
% export_fig ./Source_Reconstructions/Controls_2016_SPM_3.png -transparent -m2.5
% jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/450_700/spmT_0003.nii','jet',cfg)
% export_fig ./Source_Reconstructions/Controls_2016_SPM_4.png -transparent -m2.5
% jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/750_900/spmT_0003.nii','jet',cfg)
% export_fig ./Source_Reconstructions/Controls_2016_SPM_5.png -transparent -m2.5
% 
% jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/90_130/spmT_0004.nii','jet',cfg)
% export_fig ./Source_Reconstructions/Patients_2016_SPM_1.png -transparent -m2.5
% jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/180_240/spmT_0004.nii','jet',cfg)
% export_fig ./Source_Reconstructions/Patients_2016_SPM_2.png -transparent -m2.5
% jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/270_420/spmT_0004.nii','jet',cfg)
% export_fig ./Source_Reconstructions/Patients_2016_SPM_3.png -transparent -m2.5
% jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/450_700/spmT_0004.nii','jet',cfg)
% export_fig ./Source_Reconstructions/Patients_2016_SPM_4.png -transparent -m2.5
% jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/750_900/spmT_0004.nii','jet',cfg)
% export_fig ./Source_Reconstructions/Patients_2016_SPM_5.png -transparent -m2.5
% 
cfg.normalise = 0;
cfg.threshold = [1.65 3.15]; %p=0.05

for i = 1:length(windows)
  
    jp_spm8_surfacerender2_version_tc(['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/' num2str(windows(i,1)) '_' num2str(windows(i,2)) '/spmT_0007.nii'],'jet',cfg)
    savepath = ['./Source_Reconstructions/Combined_2016_SPM_16-4_' num2str(i)];
    eval(['export_fig ' savepath '.png -transparent -m2.5'])
%     
%     jp_spm8_surfacerender2_version_tc(['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/' num2str(windows(i,1)) '_' num2str(windows(i,2)) '/spmT_0008.nii'],'jet',cfg)
%     savepath = ['./Source_Reconstructions/Controls_2016_SPM_16-4_' num2str(i)];
%     eval(['export_fig ' savepath '.png -transparent -m2.5'])
%     
%     jp_spm8_surfacerender2_version_tc(['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/' num2str(windows(i,1)) '_' num2str(windows(i,2)) '/spmT_0009.nii'],'jet',cfg)
%     savepath = ['./Source_Reconstructions/Patients_2016_SPM_16-4_' num2str(i)];
%     eval(['export_fig ' savepath '.png -transparent -m2.5'])

end


cfg.normalise = 0;
cfg.threshold = [1.65 3.15]; %p=0.05
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/spmT_0007.nii','jet',cfg)
export_fig ./Source_Reconstructions/Combined_2016_SPM_16-4_Overall_1.png -transparent -m2.5


jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/spmT_0008.nii','jet',cfg)
export_fig ./Source_Reconstructions/Controls_2016_SPM_16-4_Overall_1.png -transparent -m2.5 


jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/spmT_0009.nii','jet',cfg)
export_fig ./Source_Reconstructions/Patients_2016_SPM_16-4_Overall_1.png -transparent -m2.5

% 
%% Now Main Effect of Clarity

figure
image_to_add = imread('./Source_Reconstructions/Controls_2016_SPM_16-4_1.png');
%Assume that all images are the same size
imagearray = uint8(zeros(size(image_to_add,1)*2, ceil(size(image_to_add,2)*5.3), 3));
imagearray = imagearray+204;
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;

for imagenumber = 2:4
image_to_add = imread(['./Source_Reconstructions/Controls_2016_SPM_16-4_' num2str(imagenumber) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
end
for imagenumber = 6:9
image_to_add = imread(['./Source_Reconstructions/Patients_2016_SPM_16-4_' num2str(imagenumber-5) '.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1+(imagenumber-6)*size(image_to_add,2):(imagenumber-5)*size(image_to_add,2),:) = image_to_add;
end

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_16-4_Overall_1.png');
imagearray(1:size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),end+1-size(image_alphas,2):end,1) = image_alphas;

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Patients_2016_SPM_16-4_Overall_1.png');
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),end+1-size(image_to_add,2):end,:) = image_alphas;

imagearray_alphas = imagearray_alphas(1:size(imagearray,1),1:size(imagearray,2));

f = imshow(imagearray);
set(f, 'AlphaData', imagearray_alphas);

savepath = ['./Source_Reconstructions/thresholded_2016_SPM_16-4_total.png'];
imwrite(imagearray,savepath,'png','Alpha',imagearray_alphas)

imagearray_3d = zeros(size(imagearray_alphas,1),size(imagearray_alphas,2),3);
imagearray_3d = logical(imagearray_3d);
for i = 1:3
    imagearray_3d(:,:,i)=imagearray_alphas==0;
end

imagearray(imagearray_3d)=255;
savepath = ['./Source_Reconstructions/thresholded_2016_SPM_16-4_total_white.png'];
imwrite(imagearray,savepath,'png')


figure
image_to_add = imread('./Source_Reconstructions/Controls_2016_SPM_16-4_6.png');
%Assume that all images are the same size
imagearray = uint8(zeros(size(image_to_add,1)*2, ceil(size(image_to_add,2)*5.3), 3));
imagearray = imagearray+204;
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;

for imagenumber = 2:4
image_to_add = imread(['./Source_Reconstructions/Controls_2016_SPM_16-4_' num2str(imagenumber+5) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
end
for imagenumber = 6:9
image_to_add = imread(['./Source_Reconstructions/Patients_2016_SPM_16-4_' num2str(imagenumber) '.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1+(imagenumber-6)*size(image_to_add,2):(imagenumber-5)*size(image_to_add,2),:) = image_to_add;
end

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Controls_2016_SPM_16-4_Overall_1.png');
imagearray(1:size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),end+1-size(image_alphas,2):end,1) = image_alphas;

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Patients_2016_SPM_16-4_Overall_1.png');
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(size(image_alphas,1)+1:2*size(image_alphas,1),end+1-size(image_to_add,2):end,:) = image_alphas;

imagearray_alphas = imagearray_alphas(1:size(imagearray,1),1:size(imagearray,2));

f = imshow(imagearray);
set(f, 'AlphaData', imagearray_alphas);

savepath = ['./Source_Reconstructions/thresholded_2016_SPM_newtimewindows_16-4_total.png'];
imwrite(imagearray,savepath,'png','Alpha',imagearray_alphas)

imagearray_3d = zeros(size(imagearray_alphas,1),size(imagearray_alphas,2),3);
imagearray_3d = logical(imagearray_3d);
for i = 1:3
    imagearray_3d(:,:,i)=imagearray_alphas==0;
end

imagearray(imagearray_3d)=255;
savepath = ['./Source_Reconstructions/thresholded_2016_SPM_newtimewindows_16-4_total_white.png'];
imwrite(imagearray,savepath,'png')

cfg.normalise = 0;
cfg.threshold = [1.65 3.15]; %p=0.05

for i = 1:length(windows)
  
    jp_spm8_surfacerender2_version_tc(['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/' num2str(windows(i,1)) '_' num2str(windows(i,2)) '/spmT_0008.nii'],'jet',cfg)
    savepath = ['./Source_Reconstructions/Controls_2016_SPM_16-4_' num2str(i)];
    eval(['export_fig ' savepath '.png -transparent -m2.5'])
    
    jp_spm8_surfacerender2_version_tc(['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/' num2str(windows(i,1)) '_' num2str(windows(i,2)) '/spmT_0009.nii'],'jet',cfg)
    savepath = ['./Source_Reconstructions/Patients_2016_SPM_16-4_' num2str(i)];
    eval(['export_fig ' savepath '.png -transparent -m2.5'])

end

%% Now Main Effect of Clarity Combined

figure
[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Combined_2016_SPM_16-4_1.png');
%Assume that all images are the same size
imagearray = uint8(zeros(size(image_to_add,1), ceil(size(image_to_add,2)*5.3), 3));
imagearray_alphas = uint8(zeros(size(image_to_add,1), ceil(size(image_to_add,2)*5.3), 1));
imagearray = imagearray+204;
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_alphas;

for imagenumber = 2:4
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Combined_2016_SPM_16-4_' num2str(imagenumber) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),1) = image_alphas;
end

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Combined_2016_SPM_16-4_Overall_1.png');
imagearray(1:size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),end+1-size(image_alphas,2):end,1) = image_alphas;

f = imshow(imagearray);
set(f, 'AlphaData', imagearray_alphas);

savepath = ['./Source_Reconstructions/thresholded_2016_SPM_combined_16-4_total.png'];
imwrite(imagearray,savepath,'png','Alpha',imagearray_alphas)

imagearray_3d = zeros(size(imagearray_alphas,1),size(imagearray_alphas,2),3);
imagearray_3d = logical(imagearray_3d);
for i = 1:3
    imagearray_3d(:,:,i)=imagearray_alphas==0;
end

imagearray(imagearray_3d)=255;
savepath = ['./Source_Reconstructions/thresholded_2016_SPM_combined_16-4_total_white.png'];
imwrite(imagearray,savepath,'png')


figure
[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Combined_2016_SPM_16-4_6.png');
%Assume that all images are the same size
imagearray = uint8(zeros(size(image_to_add,1), ceil(size(image_to_add,2)*5.3), 3));
imagearray_alphas = uint8(zeros(size(image_to_add,1), ceil(size(image_to_add,2)*5.3), 1));
imagearray = imagearray+204;
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_alphas;

for imagenumber = 2:4
[image_to_add, ~, image_alphas] = imread(['./Source_Reconstructions/Combined_2016_SPM_16-4_' num2str(imagenumber+5) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
imagearray_alphas(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),1) = image_alphas;
end

[image_to_add, ~, image_alphas] = imread('./Source_Reconstructions/Combined_2016_SPM_16-4_Overall_1.png');
imagearray(1:size(image_to_add,1),end+1-size(image_to_add,2):end,:) = image_to_add;
imagearray_alphas(1:size(image_alphas,1),end+1-size(image_alphas,2):end,1) = image_alphas;

imagearray_alphas = imagearray_alphas(1:size(imagearray,1),1:size(imagearray,2));

f = imshow(imagearray);
set(f, 'AlphaData', imagearray_alphas);

savepath = ['./Source_Reconstructions/thresholded_2016_SPM_combined_newtimewindows_16-4_total.png'];
imwrite(imagearray,savepath,'png','Alpha',imagearray_alphas)

imagearray_3d = zeros(size(imagearray_alphas,1),size(imagearray_alphas,2),3);
imagearray_3d = logical(imagearray_3d);
for i = 1:3
    imagearray_3d(:,:,i)=imagearray_alphas==0;
end

imagearray(imagearray_3d)=255;
savepath = ['./Source_Reconstructions/thresholded_2016_SPM_combined_newtimewindows_16-4_total_white.png'];
imwrite(imagearray,savepath,'png')







cfg.normalise = 0;
cfg.threshold = [1.65 3.15]; %p=0.05
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/spmT_0007.nii','jet',cfg)
export_fig ./Source_Reconstructions/Combined_2016_SPM_16-4_Overall_1.png -transparent -m2.5


jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/spmT_0008.nii','jet',cfg)
export_fig ./Source_Reconstructions/Controls_2016_SPM_16-4_Overall_1.png -transparent -m2.5 


jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_5/reconstruction_5/stats/spmT_0009.nii','jet',cfg)
export_fig ./Source_Reconstructions/Patients_2016_SPM_16-4_Overall_1.png -transparent -m2.5

% 
%% Now Beamformed time frequency

cfg.plots = [1];
cfg.symmetricity = 'symmetrical';
% cfg.normalise = 1;
% cfg.threshold = [5 40];
cfg.inflate = 10;

addpath([pwd '/ojwoodford-export_fig-216b30e'])
cfg.normalise = 0;
cfg.threshold = [3.18 4.61]; %p=0.001
bf_windows = {'early','mid','late'};
for i = bf_windows
  
    jp_spm8_surfacerender2_version_tc(['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/stats/' char(i) '/spmT_0005.nii'],'jet',cfg)
    savepath = ['./Source_Reconstructions/BF_contrast_2016_' char(i)];
    eval(['export_fig ' savepath '.png -transparent -m2.5'])
    
end

cfg.plots = [1];
cfg.symmetricity = 'symmetrical';
% cfg.normalise = 1;
% cfg.threshold = [5 40];
cfg.inflate = 10;

addpath([pwd '/ojwoodford-export_fig-216b30e'])
cfg.normalise = 0;
cfg.threshold = [3.18 4.61]; %p=0.001
bf_windows = {'early','mid','late'};
for i = bf_windows
  
    jp_spm8_surfacerender2_version_tc(['/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/stats/' char(i) '/spmT_0005.nii'],'jet',cfg)
    savepath = ['./Source_Reconstructions/BF_eLORETA_contrast_2016_' char(i)];
    eval(['export_fig ' savepath '.png -transparent -m2.5'])
    
end


