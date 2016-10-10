%% Set up global variables

clear all

% make sure EEG modality of SPM software is selected
spm('defaults','EEG');

% add required paths
addpath('/group/language/data/thomascope/vespa/');
addpath('/group/language/data/ediz.sohoglu/matlab/utilities/');
addpath('/opt/neuromag/meg_pd_1.2/');

% define paths
rawpathstem = '/megdata/cbu/vespa/';
pathstem = '/imaging/tc02/vespa/preprocess/';

% define conditions
conditions = {'Mismatch_4' 'Match_4' 'Mismatch_8' 'Match_8' 'Mismatch_16' 'Match_16'};

contrast_labels = {};
contrast_weights = [];    

% define subjects and blocks
cnt = 0;

% % cnt = cnt + 1;
% % subjects{cnt} = 'meg14_0057_v01';
% % dates{cnt} = '140214';
% % blocksin{cnt} = {'run1' 'run2'};
% % blocksout{cnt} = {'run1' 'run2'};
% % badchannels{cnt, 1} = {}; badchannels{cnt, 2} = {}; badchannels{cnt, 3} = {}; badchannels{cnt, 4} = {}; badchannels{cnt, 5} = {}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
% % badeeg{cnt} = {};
% % group(cnt) = 1;
% 
% cnt = cnt + 1;
% subjects{cnt} = 'meg14_0072_vc1';
% dates{cnt} = '140224';
% blocksin{cnt} = {'vespa_first', 'vespa_second', 'vespa_third'};
% blocksout{cnt} = {'run1', 'run2', 'run3'};
% badchannels{cnt, 1} = {'2141', '1731', '1412', '0813', '1611'}; badchannels{cnt, 2} = {'2141', '1731', '1412', '0813', '1611'}; badchannels{cnt, 3} = {'2141', '1731', '1412', '0813', '1611'}; badchannels{cnt, 4} = {'2141', '1731', '1412', '0813', '1611'}; badchannels{cnt, 5} = {'2141', '1731', '1412', '0813', '1611'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
% badeeg{cnt} = {'8', '29'};
% group(cnt) = 1;
% 
% cnt = cnt + 1;
% subjects{cnt} = 'meg14_0085_vp1';
% dates{cnt} = '140228';
% blocksin{cnt} = {'vespa_first', 'vespa_second'};
% blocksout{cnt} = {'run1', 'run2'};
% badchannels{cnt, 1} = {'0933', '1721', '1731', '1412', '0813'}; badchannels{cnt, 2} = {'0933', '1721', '1731', '1412', '0813'}; badchannels{cnt, 3} = {'0933', '1721', '1731', '1412', '0813'}; badchannels{cnt, 4} = {'0933', '1721', '1731', '1412', '0813'}; badchannels{cnt, 5} = {}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
% badeeg{cnt} = {'8'};
% group(cnt) = 2;
% 
% cnt = cnt + 1;
% subjects{cnt} = 'meg14_0087_vp2';
% dates{cnt} = '140303';
% blocksin{cnt} = {'vespa_first', 'vespa_second', 'vespa_third'};
% blocksout{cnt} = {'run1', 'run2', 'run3'};
% badchannels{cnt, 1} = {'0933', '1731', '0813'}; badchannels{cnt, 2} = {'0933', '1731', '0813'}; badchannels{cnt, 3} = {'0933', '1731', '0813'}; badchannels{cnt, 4} = {'0933', '1731', '0813'}; badchannels{cnt, 5} = {'0933', '1731', '0813'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
% badeeg{cnt} = {'7','17','39'};
% group(cnt) = 2;
% 
% cnt = cnt + 1;
% subjects{cnt} = 'meg14_0093_vc2';
% dates{cnt} = '140306';
% blocksin{cnt} = {'vespa_first', 'vespa_second', 'vespa_third'};
% blocksout{cnt} = {'run1', 'run2', 'run3'};
% badchannels{cnt, 1} = {'1731', '2342', '0813', '0932'}; badchannels{cnt, 2} = {'1731', '2342', '0813', '0932'}; badchannels{cnt, 3} = {'1731', '2342', '0813', '0932'}; badchannels{cnt, 4} = {'1731', '2342', '0813', '0932'}; badchannels{cnt, 5} = {'1731', '2342', '0813', '0932'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
% badeeg{cnt} = {'73', '29'};
% group(cnt) = 1;
% 
% cnt = cnt + 1;
% subjects{cnt} = 'meg14_0096_vc3';
% dates{cnt} = '140307';
% blocksin{cnt} = {'vespa_first', 'vespa_second', 'vespa_third'};
% blocksout{cnt} = {'run1', 'run2', 'run3'};
% badchannels{cnt, 1} = {'0813'}; badchannels{cnt, 2} = {'0813'}; badchannels{cnt, 3} = {'0813'}; badchannels{cnt, 4} = {'0813'}; badchannels{cnt, 5} = {'0813'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
% badeeg{cnt} = {'8','25','36', '65'};
% group(cnt) = 1;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0104_vp3';
dates{cnt} = '140310';
blocksin{cnt} = {'vespa_first', 'vespa_second', 'vespa_third'};
blocksout{cnt} = {'run1', 'run2', 'run3'};
badchannels{cnt, 1} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 2} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 3} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 4} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 5} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'9','36','39'};
group(cnt) = 2;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0114_vc4';
dates{cnt} = '140314';
blocksin{cnt} = {'vespa_first', 'vespa_second', 'vespa_third'};
blocksout{cnt} = {'run1', 'run2', 'run3'};
badchannels{cnt, 1} = {'0813','1211','2323','1731'}; badchannels{cnt, 2} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 3} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 4} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 5} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'29','31','32','43'};
group(cnt) = 1;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0121_vp5';
dates{cnt} = '140318';
blocksin{cnt} = {'vespa_first','vespa_first2', 'vespa_second','vespa_second2', 'vespa_third'};
blocksout{cnt} = {'run1', 'run1_1', 'run2', 'run2_1', 'run3'};
badchannels{cnt, 1} = {'2013','1731','1412'}; badchannels{cnt, 2} = {'2013','1731','1412'}; badchannels{cnt, 3} = {'2013','1731','1412'}; badchannels{cnt, 4} = {}; badchannels{cnt, 5} = {}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'27','39'};
group(cnt) = 2;

cnt = cnt + 1;
subjects{cnt} = 'no_name';
dates{cnt} = '140320';
blocksin{cnt} = {'vespa_first', 'vespa_second','vespa_second2', 'vespa_third'};
blocksout{cnt} = {'run1', 'run2', 'run2_1', 'run3'};
badchannels{cnt, 1} = {'2142','1731','0813'}; badchannels{cnt, 2} = {'2142','1731','0813'}; badchannels{cnt, 3} = {'2142','1731','0813'}; badchannels{cnt, 4} = {'2142','1731','0813'}; badchannels{cnt, 5} = {'2142','1731','0813'}; badchannels{cnt, 6} = {'2142','1731','0813'}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'45'};
group(cnt) = 1;