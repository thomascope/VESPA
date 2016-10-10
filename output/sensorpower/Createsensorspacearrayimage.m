figure

imagearray = uint8(zeros(414*3+40, 553*3, 3));
imagearray = imagearray+204;

image = imread('ConMagnetMisMatch-Match.tif');
imcropped = image(34:368,94:428,:);

imagearray(40:39+size(imcropped,1),380:379+size(imcropped,2),:) = imcropped;

image = imread('PatMagnetMatch-MisMatch.tif');
imcropped = image(34:368,94:428,:);

imagearray(40:39+size(imcropped,1),400+size(imcropped,2):399+2*size(imcropped,2),:) = imcropped;

image = imread('Significantmagnetometersensor.tif');
imagearray(40:39+size(image,1),420+2*size(imcropped,2):419+2*size(imcropped,2)+size(image,2),:) = image;

image = imread('ConPlanarMisMatch-Match.tif');
imcropped = image(34:368,94:428,:);

imagearray(119+size(imcropped,2):118+2*size(imcropped,2),380:379+size(imcropped,2),:) = imcropped;

image = imread('PatPlanarMisMatch-Match.tif');
imcropped = image(34:368,94:428,:);

imagearray(119+size(imcropped,2):118+2*size(imcropped,2),400+size(imcropped,2):399+2*size(imcropped,2),:) = imcropped;

image = imread('Significantplanarsensor.tif');
imagearray(119+size(imcropped,1):118+size(image,1)+size(imcropped,2),420+2*size(imcropped,2):419+2*size(imcropped,2)+size(image,2),:) = image;

image = imread('ConEEGMatch-MisMatch.tif');
imcropped = image(34:368,94:428,:);

imagearray(198+2*size(imcropped,2):197+3*size(imcropped,2),380:379+size(imcropped,2),:) = imcropped;

image = imread('PatEEGMatch-MisMatch.tif');
imcropped = image(34:368,94:428,:);

imagearray(198+2*size(imcropped,2):197+3*size(imcropped,2),400+size(imcropped,2):399+2*size(imcropped,2),:) = imcropped;

image = imread('SignificantEEGsensor.tif');
imagearray(198+2*size(imcropped,1):197+size(image,1)+2*size(imcropped,1),420+2*size(imcropped,2):419+2*size(imcropped,2)+size(image,2),:) = image;

for i = 1:size(imagearray,1)
    for j = 1:size(imagearray,2)
        if sum(imagearray(i,j,:) == [204]) == 3
            imagearray(i,j,:) = 255;
        end
    end
end

imshow(imagearray)

text(440+30,15,'Controls','FontSize',128)
text(440+60+size(imcropped,1),15,'Patients','FontSize',128)
text(440+2*size(imcropped,2),15,'Response at Most Significant Sensor','FontSize',128)
text(100,30+size(imcropped,1)/2,'Magnetometers','FontSize',128)
text(100,70+size(imcropped,1)/2,'400ms','FontSize',128)
text(100,109+size(imcropped,1)*3/2,'Gradiometers','FontSize',128)
text(100,149+size(imcropped,1)*3/2,'468ms','FontSize',128)
text(100,188+size(imcropped,1)*5/2,'EEG','FontSize',128)
text(100,228+size(imcropped,1)*5/2,'640ms','FontSize',128)

figure

imagearray = uint8(zeros(414*3+40, 553*3, 3));
imagearray = imagearray+204;

image = imread('ConMagnetClear-Unclear.tif');
imcropped = image(34:368,94:428,:);

imagearray(40:39+size(imcropped,1),380:379+size(imcropped,2),:) = imcropped;

image = imread('PatMagnetClear-Unclear.tif');
imcropped = image(34:368,94:428,:);

imagearray(40:39+size(imcropped,1),400+size(imcropped,2):399+2*size(imcropped,2),:) = imcropped;

image = imread('Significantmagnetometersensor_clarity.tif');
imagearray(40:39+size(image,1),420+2*size(imcropped,2):419+2*size(imcropped,2)+size(image,2),:) = image;

image = imread('ConPlanarClear-Unclear.tif');
imcropped = image(34:368,94:428,:);

imagearray(119+size(imcropped,2):118+2*size(imcropped,2),380:379+size(imcropped,2),:) = imcropped;

image = imread('PatPlanarClear-Unclear.tif');
imcropped = image(34:368,94:428,:);

imagearray(119+size(imcropped,2):118+2*size(imcropped,2),400+size(imcropped,2):399+2*size(imcropped,2),:) = imcropped;

image = imread('Significantplanarsensor_clarity.tif');
imagearray(119+size(imcropped,1):118+size(image,1)+size(imcropped,2),420+2*size(imcropped,2):419+2*size(imcropped,2)+size(image,2),:) = image;
% 
% image = imread('ConEEGClear-Unclear.tif');
% imcropped = image(34:368,94:428,:);
% 
% imagearray(198+2*size(imcropped,2):197+3*size(imcropped,2),380:379+size(imcropped,2),:) = imcropped;
% 
% image = imread('PatEEGClear-Unclear.tif');
% imcropped = image(34:368,94:428,:);
% 
% imagearray(198+2*size(imcropped,2):197+3*size(imcropped,2),400+size(imcropped,2):399+2*size(imcropped,2),:) = imcropped;

for i = 1:size(imagearray,1)
    for j = 1:size(imagearray,2)
        if sum(imagearray(i,j,:) == [204]) == 3
            imagearray(i,j,:) = 255;
        end
    end
end

imshow(imagearray)

text(440+30,15,'Controls','FontSize',128)
text(440+60+size(imcropped,1),15,'Patients','FontSize',128)
text(440+2*size(imcropped,2),15,'Response at Most Significant Sensor','FontSize',128)
text(100+2*size(imcropped,2),420+2*size(imcropped,2),'There is No Significant EEG Sensor','FontSize',128)
text(100,30+size(imcropped,1)/2,'Magnetometers','FontSize',128)
text(100,70+size(imcropped,1)/2,'176ms','FontSize',128)
text(100,109+size(imcropped,1)*3/2,'Gradiometers','FontSize',128)
text(100,149+size(imcropped,1)*3/2,'96ms','FontSize',128)
%text(100,188+size(imcropped,1)*5/2,'EEG','FontSize',128)


