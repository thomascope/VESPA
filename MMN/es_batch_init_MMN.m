%% Set up global variables

clear all

% make sure EEG modality of SPM software is selected
spm('defaults','EEG');

% add required paths
addpath('/group/language/data/thomascope/vespa/');
addpath('/group/language/data/thomascope/vespa/MMN/');
addpath('/group/language/data/ediz.sohoglu/matlab/utilities/');
addpath('/opt/neuromag/meg_pd_1.2/');

% define paths
rawpathstem = '/imaging/tc02/vespa/preprocess/';
bwd = '/imaging/tc02/vespa/preprocess/MMN/'; % your path to where you want files to be saved

% define subjects and blocks
cnt = 0;

% cnt = cnt + 1;
% subjects{cnt} = 'meg14_0057_v01';
% dates{cnt} = '140214';
% blocksin = {'run1' 'run2'};
% blocksin{cnt} = {'run1' 'run2'};
% badchannels{cnt, 1} = {}; badchannels{cnt, 2} = {}; badchannels{cnt, 3} = {}; badchannels{cnt, 4} = {}; badchannels{cnt, 5} = {}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
% badeeg{cnt} = {};
% group(cnt) = 1;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0072_vc1';
dates{cnt} = '140224';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'2141', '1731', '1412', '0813', '1611'}; badchannels{cnt, 2} = {'2141', '1731', '1412', '0813', '1611'}; badchannels{cnt, 3} = {'2141', '1731', '1412', '0813', '1611'}; badchannels{cnt, 4} = {'2141', '1731', '1412', '0813', '1611'}; badchannels{cnt, 5} = {'2141', '1731', '1412', '0813', '1611'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'8', '29'};
group(cnt) = 1;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0085_vp1';
dates{cnt} = '140228';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'0933', '1721', '1731', '1412', '0813'}; badchannels{cnt, 2} = {'0933', '1721', '1731', '1412', '0813'}; badchannels{cnt, 3} = {'0933', '1721', '1731', '1412', '0813'}; badchannels{cnt, 4} = {'0933', '1721', '1731', '1412', '0813'}; badchannels{cnt, 5} = {}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'8'};
group(cnt) = 2;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0087_vp2';
dates{cnt} = '140303';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'0933', '1731', '0813'}; badchannels{cnt, 2} = {'0933', '1731', '0813'}; badchannels{cnt, 3} = {'0933', '1731', '0813'}; badchannels{cnt, 4} = {'0933', '1731', '0813'}; badchannels{cnt, 5} = {'0933', '1731', '0813'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'7','17','39'};
group(cnt) = 2;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0093_vc2';
dates{cnt} = '140306';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'1731', '2342', '0813', '0932'}; badchannels{cnt, 2} = {'1731', '2342', '0813', '0932'}; badchannels{cnt, 3} = {'1731', '2342', '0813', '0932'}; badchannels{cnt, 4} = {'1731', '2342', '0813', '0932'}; badchannels{cnt, 5} = {'1731', '2342', '0813', '0932'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'73', '29'};
group(cnt) = 1;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0096_vc3';
dates{cnt} = '140307';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'0813'}; badchannels{cnt, 2} = {'0813'}; badchannels{cnt, 3} = {'0813'}; badchannels{cnt, 4} = {'0813'}; badchannels{cnt, 5} = {'0813'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'8','25','36', '65'};
group(cnt) = 1;

% %I think that we should reject this patient - wrong diagnosis in my opinion
% cnt = cnt + 1;
% subjects{cnt} = 'meg14_0104_vp3';
% dates{cnt} = '140310';
% blkout{cnt} = {'mmn_resp'};
% blocksin{cnt} = {'mmn'};
% badchannels{cnt, 1} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 2} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 3} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 4} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 5} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
% badeeg{cnt} = {'9','36','39'};
% group(cnt) = 2;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0114_vc4';
dates{cnt} = '140314';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'0813','1211','2323','1731'}; badchannels{cnt, 2} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 3} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 4} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 5} = {'0813','1222','1223','0521','0342','2141','1731','2143'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'29','31','32','43'};
group(cnt) = 1;

% VP4 only did REST

cnt = cnt + 1;
subjects{cnt} = 'meg14_0121_vp5';
dates{cnt} = '140318';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'2013','1731','1412'}; badchannels{cnt, 2} = {'2013','1731','1412'}; badchannels{cnt, 3} = {'2013','1731','1412'}; badchannels{cnt, 4} = {'2013','1731','1412'}; badchannels{cnt, 5} = {'2013','1731','1412'}; badchannels{cnt, 6} = {'2013','1731','1412'}; badchannels{cnt, 7} = {'2013','1731','1412'}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'27','39'};
group(cnt) = 2;

%THIS IS VC5, ERROR IN SAVING MEANS no_name!!!
cnt = cnt + 1;
subjects{cnt} = 'meg14_0320_vc5';
dates{cnt} = '140320';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'2142','1731','0813'}; badchannels{cnt, 2} = {'2142','1731','0813'}; badchannels{cnt, 3} = {'2142','1731','0813'}; badchannels{cnt, 4} = {'2142','1731','0813'}; badchannels{cnt, 5} = {'2142','1731','0813'}; badchannels{cnt, 6} = {'2142','1731','0813'}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'45'};
group(cnt) = 1;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0130_vp6';
dates{cnt} = '140324';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'1211','1731'}; badchannels{cnt, 2} = {'1211','1731'}; badchannels{cnt, 3} = {'1211','1731'}; badchannels{cnt, 4} = {'1211','1731'}; badchannels{cnt, 5} = {'1211','1731'}; badchannels{cnt, 6} = {'1211','1731'}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'21','55','65','73'};
group(cnt) = 2;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0135_vp7';
dates{cnt} = '140325';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'0813','1731','1412','1921'}; badchannels{cnt, 2} = {'0813','1731','1412','1921'}; badchannels{cnt, 3} = {'0813','1731','1412','1921'}; badchannels{cnt, 4} = {'0813','1731','1412','1921'}; badchannels{cnt, 5} = {'0813','1731','1412','1921'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'40','30'};
group(cnt) = 2;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0140_vc6';
dates{cnt} = '140327';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'0813','1731','0343'}; badchannels{cnt, 2} = {'0813','1731','0343'}; badchannels{cnt, 3} = {'0813','1731','0343'}; badchannels{cnt, 4} = {'0813','1731','0343'}; badchannels{cnt, 5} = {'0813','1731','0343'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {};
group(cnt) = 1;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0434_vc7';
dates{cnt} = '140331';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'0813','1731'}; badchannels{cnt, 2} = {'0813','1731'}; badchannels{cnt, 3} = {'0813','1731'}; badchannels{cnt, 4} = {'0813','1731'}; badchannels{cnt, 5} = {'0813','1731'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {};
group(cnt) = 1;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0150_vp8';
dates{cnt} = '140403';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'0813','1731','0933'}; badchannels{cnt, 2} = {'0813','1731','0933'}; badchannels{cnt, 3} = {'0813','1731','0933'}; badchannels{cnt, 4} = {'0813','1731','0933'}; badchannels{cnt, 5} = {'0813','1731','0933'}; badchannels{cnt, 6} = {}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'7'};
group(cnt) = 2;


cnt = cnt + 1;
subjects{cnt} = 'meg14_0184_vp9';
dates{cnt} = '140424';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'0813','1731','1141','2211','1143','1142','2213','2212'}; badchannels{cnt, 2} = {'0813','1141','2211','1731','1143','1142','2213','2212'}; badchannels{cnt, 3} = {'0813','1141','2211','1731','1143','1142','2213','2212'}; badchannels{cnt, 4} = {'0813','1141','2211','1731','1143','1142','2213','2212'}; badchannels{cnt, 5} = {'0813','1141','2211','1731','1143','1142','2213','2212'}; badchannels{cnt, 6} = {'0813','1141','2211','1731','1143','1142','2213','2212'}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'39'};
group(cnt) = 2;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0205_vp10';
dates{cnt} = '140502';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'0813','1731','1812'}; badchannels{cnt, 2} = {'0813','1731','1812'}; badchannels{cnt, 3} = {'0813','1731','1812'}; badchannels{cnt, 4} = {'0813','1731','1812'}; badchannels{cnt, 5} = {'0813','1731','1812'}; badchannels{cnt, 6} = {'0813','1731','1812'}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'5', '42'};
group(cnt) = 2;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0506_vp12';
dates{cnt} = '140506';
blkout{cnt} = {'mmn_resp'};
blocksin{cnt} = {'mmn'};
badchannels{cnt, 1} = {'0813','1731','0631'}; badchannels{cnt, 2} = {'0813','1731','0631'}; badchannels{cnt, 3} = {'0813','1731','0631'}; badchannels{cnt, 4} = {'0813','1731','0631'}; badchannels{cnt, 5} = {'0813','1731','0631'}; badchannels{cnt, 6} = {'0813','1731','0631'}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'30', '40'};
group(cnt) = 2;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0209_vc8';
dates{cnt} = '140508';
blocksin{cnt} = {'mmn'};
blkout{cnt} = {'mmn_resp'};
badchannels{cnt, 1} = {'0813','1731','1412'}; badchannels{cnt, 2} = {'0813','1731','1412'}; badchannels{cnt, 3} = {'0813','1731','1412'}; badchannels{cnt, 4} = {'0813','1731','1412'}; badchannels{cnt, 5} = {'0813','1731','1412'}; badchannels{cnt, 6} = {'0813','1731','1412'}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'29', '39'};
group(cnt) = 1;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0218_vc9';
dates{cnt} = '140512';
blocksin{cnt} = {'mmn'};
blkout{cnt} = {'mmn_resp'};
badchannels{cnt, 1} = {'0813','1731','0932'}; badchannels{cnt, 2} = {'0813','1731','0932'}; badchannels{cnt, 3} = {'0813','1731','0932'}; badchannels{cnt, 4} = {'0813','1731','0932'}; badchannels{cnt, 5} = {'0813','1731','0932'}; badchannels{cnt, 6} = {'0813','1731','0932'}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'39'};
group(cnt) = 1;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0222_vp11';
dates{cnt} = '140513';
blocksin{cnt} = {'mmn'};
blkout{cnt} = {'mmn_resp'};
badchannels{cnt, 1} = {'0813','1731','0922','2343'}; badchannels{cnt, 2} = {'0813','1731','0922','2343'}; badchannels{cnt, 3} = {'0813','1731','0922','2343'}; badchannels{cnt, 4} = {'0813','1731','0922','2343'}; badchannels{cnt, 5} = {'0813','1731','0922','2343'}; badchannels{cnt, 6} = {'0813','1731','0922','2343'}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'34', '41','60','65','48','51','52'};
group(cnt) = 2;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0234_vc10';
dates{cnt} = '140519';
blocksin{cnt} = {'mmn'};
blkout{cnt} = {'mmn_resp'};
badchannels{cnt, 1} = {'0813','1731','1312'}; badchannels{cnt, 2} = {'0813','1731','1312'}; badchannels{cnt, 3} = {'0813','1731','1312'}; badchannels{cnt, 4} = {'0813','1731','1312'}; badchannels{cnt, 5} = {'0813','1731','1312'}; badchannels{cnt, 6} = {'0813','1731','1312'}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32'};
group(cnt) = 1;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0242_vc11';
dates{cnt} = '140522';
blocksin{cnt} = {'mmn'}; 
blkout{cnt} = {'mmn_resp'};
badchannels{cnt, 1} = {'0813','1731'}; badchannels{cnt, 2} = {'0813','1731'}; badchannels{cnt, 3} = {'0813','1731'}; badchannels{cnt, 4} = {'0813','1731'}; badchannels{cnt, 5} = {'0813','1731'}; badchannels{cnt, 6} = {'0813','1731'}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'29','39','69','71'};
group(cnt) = 1;

cnt = cnt + 1;
subjects{cnt} = 'meg14_0253_vc12';
dates{cnt} = '140529';
blocksin{cnt} = {'mmn'}; 
blkout{cnt} = {'mmn_resp'};
badchannels{cnt, 1} = {'0813','1731'}; badchannels{cnt, 2} = {'0813','1731'}; badchannels{cnt, 3} = {'0813','1731'}; badchannels{cnt, 4} = {'0813','1731'}; badchannels{cnt, 5} = {'0813','1731'}; badchannels{cnt, 6} = {'0813','1731'}; badchannels{cnt, 7} = {}; % define bad MEG (not EEG) channels here (if there are any)
badeeg{cnt} = {'30','40'};
group(cnt) = 1;

