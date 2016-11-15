%A function for plotting two spm files against each other over time
%(assumes a -500 to 1500ms window, with 250Hz sampling)

function test_plot(spm1,spm2,location)

Y1=spm_read_vols(spm_vol(['spm' spm1 '.img']));
Y2=spm_read_vols(spm_vol(['spm' spm2 '.img']));

Y1_data = spm_vol(spm_vol(['spm' spm1 '.hdr']));
Y2_data = spm_vol(spm_vol(['spm' spm2 '.hdr']));

x_loc = round((location(1)-Y1_data.mat(1,4))/Y1_data.mat(1,1));
y_loc = round((location(2)-Y1_data.mat(2,4))/Y1_data.mat(2,2));

figure
plot(-500:4:1500,squeeze(squeeze(Y1(x_loc,y_loc,:))),'g')
hold on
plot(-500:4:1500,squeeze(squeeze(Y2(x_loc,y_loc,:))),'r')