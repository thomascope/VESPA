figure

imagearray = uint8(zeros(414*2+20, 500*3, 3));
imagearray = imagearray+204;

image = imread('control_alpha_early.tif');
imcropped = image(34:368,94:428,:);

imagearray(40:39+size(imcropped,1),380:379+size(imcropped,2),:) = imcropped;

image = imread('control_alpha_mid.tif');
imcropped = image(34:368,94:428,:);

imagearray(40:39+size(imcropped,1),400+size(imcropped,2):399+2*size(imcropped,2),:) = imcropped;

image = imread('control_alpha_late.tif');
imcropped = image(34:368,94:428,:);

imagearray(40:39+size(imcropped,1),420+2*size(imcropped,2):419+3*size(imcropped,2),:) = imcropped;

image = imread('patient_alpha_early.tif');
imcropped = image(34:368,94:428,:);

imagearray(119+size(imcropped,2):118+2*size(imcropped,2),380:379+size(imcropped,2),:) = imcropped;

image = imread('patient_alpha_mid.tif');
imcropped = image(34:368,94:428,:);

imagearray(119+size(imcropped,2):118+2*size(imcropped,2),400+size(imcropped,2):399+2*size(imcropped,2),:) = imcropped;

image = imread('patient_alpha_late.tif');
imcropped = image(34:368,94:428,:);

imagearray(119+size(imcropped,2):118+2*size(imcropped,2),420+2*size(imcropped,2):419+3*size(imcropped,2),:) = imcropped;

% 
% image = imread('Match-Mismatchformagnetometer.tif');
% imagearray(40:39+size(image,1),420+2*size(imcropped,2)+size(image,2):419+2*size(imcropped,2)+2*size(image,2),:) = image;

for i = 1:size(imagearray,1)
    for j = 1:size(imagearray,2)
        if sum(imagearray(i,j,:) == [204]) == 3
            imagearray(i,j,:) = 255;
        end
    end
end

imshow(imagearray)

text(440+50,15,'468ms','FontSize',128)
text(440+70+size(imcropped,1),15,'600ms','FontSize',128)
text(440+90+2*size(imcropped,2),15,'868ms','FontSize',128)
% text(480+2*size(imcropped,2)+size(image,2),15,'Overall Power Across Sensors','FontSize',128)
text(200,50+size(imcropped,1)/2,'Controls','FontSize',128)
% text(100,70+size(imcropped,1)/2,'400ms','FontSize',128)
text(200,129+size(imcropped,1)*3/2,'Patients','FontSize',128)
% text(100,149+size(imcropped,1)*3/2,'468ms','FontSize',128)
% text(100,188+size(imcropped,1)*5/2,'EEG','FontSize',128)
% text(100,228+size(imcropped,1)*5/2,'640ms','FontSize',128)
text(200,150+2*size(imcropped,2),'ANOVA:','FontSize',128)
text(350+50,150+2*size(imcropped,2),'Cluster FWE <0.001','FontSize',128)
text(350+70+size(imcropped,1),150+2*size(imcropped,2),'Uncorrected p >0.05','FontSize',128)
text(350+90+2*size(imcropped,2),150+2*size(imcropped,2),'Cluster FWE <0.001','FontSize',128)

% %%
% figure
% 
% imagearray = uint8(zeros(414*3+40, 553*4, 3));
% imagearray = imagearray+204;
% 
% image = imread('ConMagnetClear-Unclear.tif');
% imcropped = image(34:368,94:428,:);
% 
% imagearray(40:39+size(imcropped,1),380:379+size(imcropped,2),:) = imcropped;
% 
% image = imread('PatMagnetClear-Unclear.tif');
% imcropped = image(34:368,94:428,:);
% 
% imagearray(40:39+size(imcropped,1),400+size(imcropped,2):399+2*size(imcropped,2),:) = imcropped;
% 
% image = imread('Significantmagnetometersensor_clarity.tif');
% imagearray(40:39+size(image,1),420+2*size(imcropped,2):419+2*size(imcropped,2)+size(image,2),:) = image;
% 
% image = imread('Clarityformagnetometer.tif');
% imagearray(40:39+size(image,1),420+2*size(imcropped,2)+size(image,2):419+2*size(imcropped,2)+2*size(image,2),:) = image;
% 
% image = imread('ConPlanarClear-Unclear.tif');
% imcropped = image(34:368,94:428,:);
% 
% imagearray(119+size(imcropped,2):118+2*size(imcropped,2),380:379+size(imcropped,2),:) = imcropped;
% 
% image = imread('PatPlanarClear-Unclear.tif');
% imcropped = image(34:368,94:428,:);
% 
% imagearray(119+size(imcropped,2):118+2*size(imcropped,2),400+size(imcropped,2):399+2*size(imcropped,2),:) = imcropped;
% 
% image = imread('Significantplanarsensor_clarity.tif');
% imagearray(119+size(imcropped,1):118+size(image,1)+size(imcropped,2),420+2*size(imcropped,2):419+2*size(imcropped,2)+size(image,2),:) = image;
% 
% image = imread('Clarityforplanar.tif');
% imagearray(119+size(imcropped,1):118+size(image,1)+size(imcropped,2),420+2*size(imcropped,2)+size(image,2):419+2*size(imcropped,2)+2*size(image,2),:) = image;
% 
% % 
% % image = imread('ConEEGClear-Unclear.tif');
% % imcropped = image(34:368,94:428,:);
% % 
% % imagearray(198+2*size(imcropped,2):197+3*size(imcropped,2),380:379+size(imcropped,2),:) = imcropped;
% % 
% % image = imread('PatEEGClear-Unclear.tif');
% % imcropped = image(34:368,94:428,:);
% % 
% % imagearray(198+2*size(imcropped,2):197+3*size(imcropped,2),400+size(imcropped,2):399+2*size(imcropped,2),:) = imcropped;
% 
% for i = 1:size(imagearray,1)
%     for j = 1:size(imagearray,2)
%         if sum(imagearray(i,j,:) == [204]) == 3
%             imagearray(i,j,:) = 255;
%         end
%     end
% end
% 
% imshow(imagearray)
% 
% text(440+30,15,'Controls','FontSize',128)
% text(440+60+size(imcropped,1),15,'Patients','FontSize',128)
% text(440+2*size(imcropped,2),15,'Response at Most Significant Sensor','FontSize',128)
% text(480+2*size(imcropped,2)+size(image,2),15,'Overall Power Across Sensors','FontSize',128)
% text(100+2*size(imcropped,2),420+2*size(imcropped,2),'There is No Significant EEG Sensor','FontSize',128)
% text(100,30+size(imcropped,1)/2,'Magnetometers','FontSize',128)
% text(100,70+size(imcropped,1)/2,'176ms','FontSize',128)
% text(100,109+size(imcropped,1)*3/2,'Gradiometers','FontSize',128)
% text(100,149+size(imcropped,1)*3/2,'96ms','FontSize',128)
% %text(100,188+size(imcropped,1)*5/2,'EEG','FontSize',128)
% 
% 
