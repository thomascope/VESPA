addpath(['/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source_stats/ojwoodford-export_fig-216b30e']);

%First plot significant contrasts for Match-Mismatch

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-47,8],'MEGCOMB')
%export_fig './Significant_peaks/Peak_MEGCOMB.png' -transparent

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-38,34],'EEG')

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[26,-14],'EEG')

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-26,2],'EEG') %Post hoc SPM

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-47,-62],'EEG') %Post hoc SPM

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-17,61],'EEG') % Position of maximum activity for patients

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-34,-3],'EEG',[180 240]) %An attempt to look for significant frontal sensors at early time windows

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-42,24],'MEGMAG',[180 240]) %An attempt to look for significant frontal sensors at early time windows

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-42,29],'MEGMAG')

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[42,34],'MEGMAG')

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-38,-41],'MEGMAG')

%Then plot total activity
figure
plot_betas_nonewplot([1:6],[1 0 1 0 1 0],{'T_0017','T_0018'},22,[-47,8],'MEGCOMB',1)

plot_betas_nonewplot([1:6],[0 1 0 1 0 1],{'T_0017','T_0018'},22,[-47,8],'MEGCOMB',2)
save_string = ['./Significant_peaks/Overall power in planar gradiometers at -47 8.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_nonewplot([1:6],[1 0 1 0 1 0],{'T_0017','T_0018'},22,[-38,34],'EEG',1)

plot_betas_nonewplot([1:6],[0 1 0 1 0 1],{'T_0017','T_0018'},22,[-38,34],'EEG',2)
save_string = ['./Significant_peaks/Overall power in EEG  at -38 34.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_nonewplot([1:6],[1 0 1 0 1 0],{'T_0017','T_0018'},22,[-26,2],'EEG',1)

plot_betas_nonewplot([1:6],[0 1 0 1 0 1],{'T_0017','T_0018'},22,[-26,2],'EEG',2)
save_string = ['./Significant_peaks/Overall power in EEG  at -26 2.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_nonewplot([1:6],[1 0 1 0 1 0],{'T_0017','T_0018'},22,[-47,-62],'EEG',1)

plot_betas_nonewplot([1:6],[0 1 0 1 0 1],{'T_0017','T_0018'},22,[-47,-62],'EEG',2)
save_string = ['./Significant_peaks/Overall power in EEG  at -47 -62.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_nonewplot([1:6],[1 0 1 0 1 0],{'T_0017','T_0018'},22,[-17,61],'EEG',1) % Position of maximum activity for patients

plot_betas_nonewplot([1:6],[0 1 0 1 0 1],{'T_0017','T_0018'},22,[-17,61],'EEG',2)
save_string = ['./Significant_peaks/Overall power in EEG  at -17 61.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_nonewplot([1:6],[1 0 1 0 1 0],{'T_0017','T_0018'},22,[26,-14],'EEG',1)

plot_betas_nonewplot([1:6],[0 1 0 1 0 1],{'T_0017','T_0018'},22,[26,-14],'EEG',2)
save_string = ['./Significant_peaks/Overall power in EEG  at -26 14.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_nonewplot([1:6],[1 0 1 0 1 0],{'T_0017','T_0018'},22,[-42,29],'MEGMAG',1)

plot_betas_nonewplot([1:6],[0 1 0 1 0 1],{'T_0017','T_0018'},22,[-42,29],'MEGMAG',2)
save_string = ['./Significant_peaks/Overall power in Magnetometers at -42 29.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

%Now for clear minus unclear

plot_betas([1:6],[-1 -1 0 0 1 1],{'T_0019','T_0020'},22,[-47,2],'MEGCOMB',[96 96])

plot_betas([1:6],[-1 -1 0 0 1 1],{'T_0019','T_0020'},22,[47,-9],'MEGCOMB',[80 80])

plot_betas([1:6],[-1 -1 0 0 1 1],{'T_0019','T_0020'},22,[34,-30],'MEGCOMB',[552 552])

plot_betas([1:6],[-1 -1 0 0 1 1],{'T_0019','T_0020'},22,[-26, -14],'MEGMAG',[188 188])

plot_betas([1:6],[-1 -1 0 0 1 1],{'T_0019','T_0020'},22,[30, -9],'MEGMAG',[380 380])

plot_betas([1:6],[-1 -1 0 0 1 1],{'T_0019','T_0020'},22,[-17, -3],'EEG',[660 900])

plot_betas([1:6],[-1 -1 0 0 1 1],{'T_0019','T_0020'},22,[34, -62],'EEG',[332 440])

%Total activity
figure
plot_betas_nonewplot([1:6],[1 1 0 0 0 0],{'T_0019','T_0020'},22,[-47,2],'MEGCOMB',1)

plot_betas_nonewplot([1:6],[0 0 0 0 1 1],{'T_0019','T_0020'},22,[-47,2],'MEGCOMB',2)
save_string = ['./Significant_peaks/Overall power in planar gradiometers at -47 2.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_nonewplot([1:6],[1 1 0 0 0 0],{'T_0017','T_0018'},22,[47,-9],'MEGCOMB',1)

plot_betas_nonewplot([1:6],[0 0 0 0 1 1],{'T_0017','T_0018'},22,[47,-9],'MEGCOMB',2)
save_string = ['./Significant_peaks/Overall power in planar gradiometers at 47 -9.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_nonewplot([1:6],[1 1 0 0 0 0],{'T_0019','T_0020'},22,[38,-30],'MEGCOMB',1)

plot_betas_nonewplot([1:6],[0 0 0 0 1 1],{'T_0019','T_0020'},22,[38,-30],'MEGCOMB',2)
save_string = ['./Significant_peaks/Overall power in planar gradiometers at 38 -30.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_nonewplot([1:6],[1 1 0 0 0 0],{'T_0019','T_0020'},22,[34,-30],'MEGCOMB',1)

plot_betas_nonewplot([1:6],[0 0 0 0 1 1],{'T_0019','T_0020'},22,[34,-30],'MEGCOMB',2)
save_string = ['./Significant_peaks/Overall power in planar gradiometers at 38 -30.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_nonewplot([1:6],[1 1 0 0 0 0],{'T_0019','T_0020'},22,[-26, -14],'MEGMAG',1)

plot_betas_nonewplot([1:6],[0 0 0 0 1 1],{'T_0019','T_0020'},22,[-26, -14],'MEGMAG',2)
save_string = ['./Significant_peaks/Overall power in magnetometers at -26 -14.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_nonewplot([1:6],[1 1 0 0 0 0],{'T_0019','T_0020'},22,[30, -9],'MEGMAG',1)

plot_betas_nonewplot([1:6],[0 0 0 0 1 1],{'T_0019','T_0020'},22,[30, -9],'MEGMAG',2)
save_string = ['./Significant_peaks/Overall power in magnetometers at 30 -9.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_nonewplot([1:6],[1 1 0 0 0 0],{'T_0019','T_0020'},22,[-17, -3],'EEG',1)

plot_betas_nonewplot([1:6],[0 0 0 0 1 1],{'T_0019','T_0020'},22,[-17, -3],'EEG',2)
save_string = ['./Significant_peaks/Overall power in EEG at -17 -3.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_nonewplot([1:6],[1 1 0 0 0 0],{'T_0019','T_0020'},22,[34, -62],'EEG',1)

plot_betas_nonewplot([1:6],[0 0 0 0 1 1],{'T_0019','T_0020'},22,[34, -62],'EEG',2)
save_string = ['./Significant_peaks/Overall power in EEG at 34 -62.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

% Now time frequency

plot_betas_tf([1:6],[-1 1 -1 1 -1 1],{'T_0018','T_0019'},22,[12 26],'MEGPLANAR',[472 600]); %The defined time window is where there is no difference in activity.

plot_betas_tf([1:6],[-1 1 -1 1 -1 1],{'T_0018','T_0019'},22,[12 26],'MEG',[456 600]); %The defined time window is where there is no difference in activity.

plot_betas_tf([1:6],[-1 1 -1 1 -1 1],{'T_0018','T_0019'},22,[12 26],'EEG',[472 600]); %The defined time window is where there is no difference in activity.

%Total activity
figure
plot_betas_tf_nonewplot([1:6],[1 0 1 0 1 0],{'T_0018','T_0019'},22,[12 26],'MEGPLANAR',1)

plot_betas_tf_nonewplot([1:6],[0 1 0 1 0 1],{'T_0018','T_0019'},22,[12 26],'MEGPLANAR',2)
save_string = ['./Significant_peaks/Overall power in planar gradiometers 12 to 26 Hz.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_tf_nonewplot([1:6],[1 0 1 0 1 0],{'T_0018','T_0019'},22,[12 26],'EEG',1)

plot_betas_tf_nonewplot([1:6],[0 1 0 1 0 1],{'T_0018','T_0019'},22,[12 26],'EEG',2)
save_string = ['./Significant_peaks/Overall power in EEG 12 to 26 Hz.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_tf_nonewplot([1:6],[1 0 1 0 1 0],{'T_0018','T_0019'},22,[12 26],'MEG',1)

plot_betas_tf_nonewplot([1:6],[0 1 0 1 0 1],{'T_0018','T_0019'},22,[12 26],'MEG',2)
save_string = ['./Significant_peaks/Overall power in Magnetometers 12 to 26 Hz.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

% Now time frequency alpha band

plot_betas_tf([1:6],[-1 1 -1 1 -1 1],{'T_0018','T_0019'},22,[8 13],'MEGPLANAR',[472 600]); %The defined time window is where there is no difference in activity.

plot_betas_tf([1:6],[-1 1 -1 1 -1 1],{'T_0018','T_0019'},22,[8 13],'MEG',[456 600]); %The defined time window is where there is no difference in activity.

plot_betas_tf([1:6],[-1 1 -1 1 -1 1],{'T_0018','T_0019'},22,[8 13],'EEG',[472 600]); %The defined time window is where there is no difference in activity.

%Total activity
figure
plot_betas_tf_nonewplot([1:6],[1 0 1 0 1 0],{'T_0018','T_0019'},22,[8 14],'MEGPLANAR',1)

plot_betas_tf_nonewplot([1:6],[0 1 0 1 0 1],{'T_0018','T_0019'},22,[8 14],'MEGPLANAR',2)
save_string = ['./Significant_peaks/Overall power in planar gradiometers 8 to 14 Hz.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_tf_nonewplot([1:6],[1 0 1 0 1 0],{'T_0018','T_0019'},22,[8 14],'EEG',1)

plot_betas_tf_nonewplot([1:6],[0 1 0 1 0 1],{'T_0018','T_0019'},22,[8 14],'EEG',2)
save_string = ['./Significant_peaks/Overall power in EEG 8 to 14 Hz.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_tf_nonewplot([1:6],[1 0 1 0 1 0],{'T_0018','T_0019'},22,[8 14],'MEG',1)

plot_betas_tf_nonewplot([1:6],[0 1 0 1 0 1],{'T_0018','T_0019'},22,[8 14],'MEG',2)
save_string = ['./Significant_peaks/Overall power in Magnetometers 8 to 14 Hz.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

% Now time frequency beta band

plot_betas_tf([1:6],[-1 1 -1 1 -1 1],{'T_0018','T_0019'},22,[14 30],'MEGPLANAR',[472 600]); %The defined time window is where there is no difference in activity.


plot_betas_tf([1:6],[-1 1 -1 1 -1 1],{'T_0018','T_0019'},22,[14 30],'MEG',[456 600]); %The defined time window is where there is no difference in activity.

plot_betas_tf([1:6],[-1 1 -1 1 -1 1],{'T_0018','T_0019'},22,[14 30],'EEG',[472 600]); %The defined time window is where there is no difference in activity.

%Total activity
figure
plot_betas_tf_nonewplot([1:6],[1 0 1 0 1 0],{'T_0018','T_0019'},22,[14 30],'MEGPLANAR',1)

plot_betas_tf_nonewplot([1:6],[0 1 0 1 0 1],{'T_0018','T_0019'},22,[14 30],'MEGPLANAR',2)
save_string = ['./Significant_peaks/Overall power in planar gradiometers 14 to 30 Hz.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_tf_nonewplot([1:6],[1 0 1 0 1 0],{'T_0018','T_0019'},22,[14 30],'EEG',1)

plot_betas_tf_nonewplot([1:6],[0 1 0 1 0 1],{'T_0018','T_0019'},22,[14 30],'EEG',2)
save_string = ['./Significant_peaks/Overall power in EEG 14 to 30 Hz.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

figure
plot_betas_tf_nonewplot([1:6],[1 0 1 0 1 0],{'T_0018','T_0019'},22,[14 30],'MEG',1)

plot_betas_tf_nonewplot([1:6],[0 1 0 1 0 1],{'T_0018','T_0019'},22,[14 30],'MEG',2)
save_string = ['./Significant_peaks/Overall power in Magnetometers 14 to 30 Hz.pdf'];
eval(['export_fig ''' save_string ''' -transparent'])

% make line graphs for the overall RMS and topoplots for  windows of interest

% plot_betas_overall('MEGPLANAR',[90,130],[180 240], [270 420], [450 700])
% plot_betas_overall('MEG',[90,130],[180 240], [270 420], [450 700])
% plot_betas_overall('EEG',[90,130],[180 240], [270 420], [450 700])

plot_betas_overall_thresholded([0, 29.1], 'MEGPLANAR',1,[90,130],[180 240], [270 420], [450 700]) %peaks
plot_betas_overall_thresholded([-863, 1090], 'MEG',1,[90,130],[180 240], [270 420], [450 700])
plot_betas_overall_thresholded([-25, 36],'EEG',1,[90,130],[180 240], [270 420], [450 700])

plot_betas_overall_thresholded([-29.1, 29.1], 'MEGPLANAR',1,[90,130],[180 240], [270 420], [450 700]) %symmetrical
plot_betas_overall_thresholded([-1090, 1090], 'MEG',1,[90,130],[180 240], [270 420], [450 700])
plot_betas_overall_thresholded([-36, 36],'EEG',1,[90,130],[180 240], [270 420], [450 700])

plot_betas_overall_thresholded([0, 29.1], 'MEGPLANAR',2)
plot_betas_overall_thresholded([-863, 1090], 'MEG',2)
plot_betas_overall_thresholded([-25, 36],'EEG',2)

plot_betas_overall_thresholded([0, 29.1], 'MEGPLANAR',3)
plot_betas_overall_thresholded([-863, 1090], 'MEG',3)
plot_betas_overall_thresholded([-25, 36],'EEG',3)

% make line graphs for the overall RMS and topoplots for new windows of interest

% plot_betas_overall('MEGPLANAR',[90,150],[200 280], [290 440], [450 700])
% plot_betas_overall('MEG',[90,150],[200 280], [290 440], [450 700])
% plot_betas_overall('EEG',[90,150],[200 280], [290 440], [450 700])
% 
% plot_betas_overall_thresholded([0, 28.4], 'MEGPLANAR',1,[90,150],[200 280], [290 440], [450 700]) %peaks
% plot_betas_overall_thresholded([-794, 1120], 'MEG',1,[90,150],[200 280], [290 440], [450 700])
% plot_betas_overall_thresholded([-22.2, 35.8],'EEG',1,[90,130],[180 240], [270 420], [450 700])

plot_betas_overall_thresholded([-29.1, 29.1], 'MEGPLANAR',1,[90,150],[200 280], [290 440], [450 700]) %symmetrical
plot_betas_overall_thresholded([-1120, 1120], 'MEG',1,[90,150],[200 280], [290 440], [450 700])
plot_betas_overall_thresholded([-35.8, 35.8],'EEG',1,[90,150],[200 280], [290 440], [450 700])


% Finally Finally redo topoplots with symmetrical colorbars

plot_betas_thresholded([-3.9 3.9],[1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-47,8],'MEGCOMB')
%export_fig './Significant_peaks/Peak_MEGCOMB.png' -transparent

plot_betas_thresholded([-5.5,5.5],[1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-38,34],'EEG')

plot_betas_thresholded([-5.5,5.5],[1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[26,-14],'EEG')

plot_betas_thresholded([-5.5,5.5],[1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-26,2],'EEG')

plot_betas_thresholded([-246,246],[1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-42,29],'MEGMAG')

plot_betas_tf_thresholded([-1.9 1.9], [1:6],[-1 1 -1 1 -1 1],{'T_0018','T_0019'},22,[14 30],'MEGPLANAR',[364 364], [472 600], [868 868]); %The defined time window is where there is no difference in activity.

plot_betas_tf_thresholded([-2.3 2.3], [1:6],[-1 1 -1 1 -1 1],{'T_0018','T_0019'},22,[8 14],'MEGPLANAR',[364 364], [472 600], [868 868]); %The defined time window is where there is no difference in activity.

windows = [90 130; 180 240; 270 420; 450 700; 750 900; 90 150; 200 280; 290 440; 450 700; 710 860];

%Now threshold clarity rating

plot_betas_thresholded([-2.65 2.65],[1:6],[-1 -1 0 0 1 1],{'T_0019','T_0020'},22,[-47,2],'MEGCOMB',[80 96])

plot_betas_thresholded([-2.65 2.65],[1:6],[-1 -1 0 0 1 1],{'T_0019','T_0020'},22,[47,-9],'MEGCOMB',[80 96])

plot_betas_thresholded([-1.11 1.11],[1:6],[-1 -1 0 0 1 1],{'T_0019','T_0020'},22,[34,-30],'MEGCOMB',[552 552])

plot_betas_thresholded([-78.5 78.5],[1:6],[-1 -1 0 0 1 1],{'T_0019','T_0020'},22,[30, -9],'MEGMAG',[312 550])

plot_betas_thresholded([-2.64 2.64],[1:6],[-1 -1 0 0 1 1],{'T_0019','T_0020'},22,[38, -68],'EEG',[350 500])


%Now look in with the TF baseline corrected to written word

plot_betas_tf_taper_newbaseline([1:6],[1 1 1 1 1 1],{'T_0024','T_0025'},22,[68 90],'MEGPLANAR',[440 740]); %The defined time window is where there is no difference in activity.
