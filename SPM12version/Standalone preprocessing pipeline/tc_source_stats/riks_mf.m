
% Just trans def existing trans first files

clear all % May not want/need to!
clc

dat_wd = '/megdata/cbu/ftd/';
%dat_wd2_1 = '/megdata/cbu/no_name/';
%cbu_code2_1 = 'meg15_0161';
bas_wd1 = '/imaging/rowe/archive/users/hp02/pnfa_mmn/maxfilter/ftd'; % <-- change to yours
bas_wd2 = '/imaging/rowe/archive/users/hp02/pnfa_mmn/maxfilter/pca'; % <-- change to yours

%groups = {
%    'CamCAN'
%    };
%%
                % FTDs below:
%  cbu_codes = {'meg11_0179'; 'meg11_0249'; 'meg11_0270';'meg11_0238';...
%     'meg12_0072';'meg12_0060';'meg12_0092';'meg12_0161';...
%     'meg12_0389';'meg12_0366';'meg12_0504';'meg12_0228';...
%     'meg12_0496';'meg13_0162';'meg13_0016';'meg12_0519';...
%     'meg13_0279';'meg13_0315';'meg12_0314';'meg13_0410';... 
%     'meg14_0315';'meg14_0559';'meg13_0454'; 'meg14_0143';...
%     'meg15_0061';... 
%     'meg13_0220';'meg13_0225';'meg13_0236';'meg13_0277';...
%     'meg13_0284';'meg13_0300';'meg13_0303';'meg13_0324';...%
%     'meg13_0356';'meg13_0437';'meg13_0526';'meg14_0061';...
%     'meg14_0199';'meg14_0287';'meg14_0327';'meg14_0333'};

 cbu_codes = {'meg12_0228';'meg12_0519';'meg13_0016';...
     'meg13_0410'; 'meg13_0454';'meg14_0143';'meg13_0277';};
     


% Run labels per experiment (not actually needed with new filenames from Pilot2 onwards)
runs = {'ftd'};

r=1;

ftd_pats = {
{'ftd_0228_mmn2_raw.fif'}; % still having problems with the deliminator :(
{'ftd_mmn_0519_raw.fif'}; 
{'ftd_mmn_1_2_raw.fif'}; 
{'ftd_13_0410_mmn_raw.fif'}; % Done
{'ftd_0454_mmn_raw.fif'}; 
{'ftd_0143_mmn_raw.fif'}}; 

% ftd_pats = {{'ftd_mmn_0179_raw.fif'};
% {'ftd_mmn_1_2_3_0249_raw.fif'};
% {'ftd_mmn_0270_raw.fif'};
% {'ftd_mmn_1_0238_raw.fif','ftd_mmn_2_0238_raw.fif'};
% {'ftd_0072_mmn_raw.fif'};
% {'ftd_0060_mmn_raw.fif'};
% {'ftd_0092_mmn_raw.fif'};
% {'ftd_mmn_0161_raw.fif'};
% {'ftd_0228_mmn1_raw.fif','ftd_0228_mmn2_raw.fif'}; 
% {'ftd_mmn_0389_raw.fif'};
% {'ftd_mmn_0366_raw.fif','ftd_mmn3_0366_raw.fif'};
% {'ftd_mmn_0504_raw.fif'};
% {'ftd_mmn_first_try_raw.fif','ftd_mmn_1_raw.fif'};
% {'ftd_mmn_0519_raw.fif'}; 
% {'ftd_mmn_1_2_raw.fif'}; % Some thing went wrong, go back later
% {'ftd_mmn_0162_raw.fif'};
% {'ftd_0279_mmn_raw.fif'};
% {'ftd_mmn_0315_raw.fif'};
% {'ftd_13_0410_mmn_raw.fif'}; 
% {'ftd_0314_mmn_raw.fif'};
% {'ftd_0454_mmn_raw.fif'}; 
% {'ftd_0143_mmn_raw.fif'}; 
% {'ftd_14_0315_mmn_raw.fif'}; 
% {'140559_mmn_raw.fif'};
% {'ftd_15_0061_mmn_raw.fif'}}; 
num_ftd = length(ftd_pats);

% pca_pats = [{'ftd_mmn_0220_raw.fif'};
% {'ftd_0225_mmn_raw.fif'};
% {'ftd_0236_mmn_raw.fif'}; 
% {'ftd_0277_mmn_raw.fif'};
% {'ftd_0284_mmn_raw.fif'};
% {'ftd_0300_mmn_raw.fif'};
% {'ftd_303_mmn_raw.fif'};
% {'ftd_0324_mmn_raw.fif'}; 
% {'ftd_0356_mmn_raw.fif'}; 
% {'ftd_0437_mmn_raw.fif'}; 
% {'ftd_0526_mmn_raw.fif'}; 
% {'ftd_0061_mmn_raw.fif'}; 
% {'ftd_0199_mmn_raw.fif'}; 
% {'ftd_0287_mmn_raw.fif'}; 
% {'0327_mmn_raw.fif'}; 
% {'ftd_meg14_0333_MMN_raw.fif'}]; 

pca_pats = [{'ftd_0277_mmn_raw.fif'};];
    

%%%Error using dlmread (line 139)
%%%Badly formed format string.
%%%Error in riks_mf (line 256)
%%%%%%%%tmp=dlmread(badfile,' '); Nbuf = size(tmp,1);

%trans_run = [2 2 1];  % Which run WITHIN an experiment to trans too (1 for rest if only one rest run)
%trans_run = [0 0 0];   % If want to skip this step, eg trans default only

%% Bad runs:
badrun = zeros(1,length(cbu_codes{1}),1,1);  % Assume all runs ok, unless indicated next

%subid = find(strcmp(cbu_codes{2},'meg14_0024'));
%badrun(2,subid,1,2) = 1; % meg14_0024, object, run 2 cannot be maxfiltered "The origin is only 4 cm from nearest coil!"
%badrun(2,subid,2,1) = 1; % meg14_0024, scene,  run 1 cannot be maxfiltered "The origin is only 4 cm from nearest coil!"


% Set up directory structures (only needs to be done once)
%for e=1:length(expts)
%    eval(sprintf('!mkdir %s',fullfile(bas_wd,expts{e})));
%    for g=1:length(groups)
%        eval(sprintf('!mkdir %s',fullfile(bas_wd,expts{e},groups{g})));

% COMMENT BACK IN WHEN WANT TO MAKE FOLDERS
for s = 1:length(cbu_codes)
    %            eval(sprintf('!mkdir %s',fullfile(bas_wd,expts{e},groups{g},sprintf('Sub%02d',s))));
    if s<=num_ftd
        %eval(sprintf('!mkdir %s',fullfile(bas_wd1,cbu_codes{s})));
    else
       % eval(sprintf('!mkdir %s',fullfile(bas_wd2,cbu_codes{s})));
    end
end
%    end
%end

% Any use bad channels? (This option not implemented yet)
% user_bad{1}{3} = [1218 1278];

basestr = ' -ctc /neuro/databases/ctc/ct_sparse.fif -cal /neuro/databases/sss/sss_cal.dat';
basestr = [basestr ' -linefreq 50 -hpisubt amp'];
basestr = [basestr ' -force'];
%maxfstr = '!/neuro/bin/util/x86_64-pc-linux-gnu/maxfilter-2.2 '
maxfstr = '!/neuro/bin/util/maxfilter-2.2';

addpath(genpath('/imaging/local/meg_misc'))
addpath(genpath('/neuro/meg_pd_1.2/'))
addpath(genpath('/imaging/rowe/archive/users/hp02/mmn_08/analysis_spm/new_spm_functions'))

% files where MF2.2 fails when mvcomp included (for some reason) - so turned off below
%mvcomp_fail = zeros(5,50,3,2);
%mvcomp_fail(1,1,1,2) = 1; % Pilot1 object second run
%mvcomp_fail(1,1,2,2) = 1; % Pilot1 scene second run
mvcomp_fail = ones(1,length(cbu_codes),1,1);  % group, subject, experiment, run, Turn off all mvcomp, since seems to fail randomly!

movfile = 'trans_move.txt'; % This file will record translations between runs

%ParType = 0;  % Fun on Login machines (not generally advised!)
%ParType = 1;   % Run maxfilter call on Compute machines using spmd (faster)
ParType = 2;   % Run on multiple Compute machines using parfar (best, but less feedback if crashes)

%% open matlabpool if required
% if ParType
%     if matlabpool('size')==0;
%         %MaxNsubs = 1;
%         %if ParType == 2
%         %    for g=1:length(cbu_codes)
%         %        MaxNsubs = max([MaxNsubs length(cbu_codes{g})]);
%         %    end
%         %end
%         P = cbupool(length(cbu_codes));
%         matlabpool(P);
%     end
% end


%% Main loop (can comment/uncomment lines below if want to parallelise over expts rather than subjects)
%for g = 2:length(groups)
%fprintf('\n\n%s\n\n',groups{g})
if ParType == 2 % parfor loop
    for s = 1%4:length(cbu_codes)
        ss = s;
        raw_wd    = dir(fullfile(dat_wd,cbu_codes{s},'1*'));  % Just to get date directory (assuming between 20*1*0 and 20*1*9Q!)
        raw_wd    = raw_wd.name;
        
        %        parfor e = 1:length(expts)  % If doing a single subject (note: cannot embed parfor loops unfortunately)
        %for e = 1:length(expts)
        
        orig = []; rad=[]; fit=[]; transtr = {}; raw_stem = {};
        
        % Output directory
        %if s == length(cbu_codes)-1
        %    raw_wd = '140320'
        %    sub_wd = fullfile(bas_wd, cbu_codes{s}, raw_wd);
        %elseif s == length(cbu_codes)
        %    raw_wd = '140506'
        %    sub_wd = fullfile(bas_wd, cbu_codes{s}, raw_wd);
        %else
        if s<=num_ftd
            sub_wd = fullfile(bas_wd1, cbu_codes{s}, raw_wd);
        else
            sub_wd = fullfile(bas_wd2, cbu_codes{s}, raw_wd);
        end
            
        %end
        
        if ~exist(sub_wd)
        mkdir(sub_wd)
        end
        cd(sub_wd)
        
        %try eval(sprintf('!mkdir %s',sub_wd)); end  % Try not allowed n parfor, so make directories in advance above
        
        if s<=num_ftd
            rs = length(ftd_pats{ss});
        else
            rs = 1;
        end
        
        for r = 1:rs%:-1:1
%         if s == 1 
%             raw_file = dir(fullfile(dat_wd,cbu_codes{s},raw_wd,sprintf('blk%d_raw.fif', r)));
%         elseif s == 2 && r == 1
%             raw_file = dir(fullfile(dat_wd2_1,cbu_code2_1,raw_wd,sprintf('HollyData_FTBlk%d_raw.fif', r)));
%         elseif s == 2 
%             raw_file = dir(fullfile(dat_wd,cbu_codes{s},raw_wd,sprintf('ft_blk%d_raw.fif', r)));
%         elseif s == 8
%             raw_file = dir(fullfile(dat_wd,cbu_codes{s},raw_wd,sprintf('FTD_blk%d_raw.fif', r)));
%         else
            if s<=num_ftd
                raw_file = dir(fullfile(dat_wd,cbu_codes{s},raw_wd,ftd_pats{ss}{r}));  % Get raw FIF file
            else
                raw_file = dir(fullfile(dat_wd,cbu_codes{s},raw_wd,pca_pats{ss-num_ftd}));  % Get raw FIF file
            end
%         end
        


         if isempty(raw_file)
             error('Could not find file')
%          elseif s == 2 && r ==1
%              raw_stem = raw_file.name(1:(end-4));
%              raw_file = fullfile(dat_wd2_1,cbu_code2_1,raw_wd,raw_file.name);
%          
         else
             raw_stem = raw_file.name(1:(end-4));
            raw_file = fullfile(dat_wd,cbu_codes{s},raw_wd,raw_file.name);
         end
         

        % Fit sphere (since better than MaxFilter does)
        if r == 1% fit sphere doesn't change with run!
            incEEG = 0;
            if exist(fullfile(sub_wd,'fittmp.txt')); delete(fullfile(sub_wd,'fittmp.txt')); end
            if exist(fullfile(sub_wd,sprintf('run_%02d_hpi.txt',r))); delete(fullfile(sub_wd,sprintf('run_%02d_hpi.txt',r)));  end
            [orig,rad,fit] = meg_fit_sphere(raw_file,sub_wd,sprintf('%s_hpi.txt',raw_stem),incEEG);
            delete(fullfile(sub_wd,'fittmp.txt'));
        end
        origstr = sprintf(' -origin %d %d %d -frame head',orig(1),orig(2),orig(3))
        badstr  = sprintf(' -autobad %d -badlimit %d',900,7); % 900s is 15mins - ie enough for whole recording!
 
        outfile = fullfile(sub_wd,sprintf('%s_trans1st',raw_stem))
        
        % 1. Bad channel detection (this email says important if doing tSSS later https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=NEUROMEG;d3f363f3.1205)
        
        outfile = fullfile(sub_wd,sprintf('%s_bad',raw_stem));
        filestr = sprintf(' -f %s -o %s.fif',raw_file,outfile);
        
        % Write out movements too...
        posfile = fullfile(sub_wd,sprintf('%s_headpos.txt',raw_stem));
        compstr = sprintf(' -headpos -hpistep 10 -hp %s',posfile);
        
        finstr = [maxfstr filestr origstr basestr badstr compstr sprintf(' -v | tee %s.log',outfile)]


       rik_eval(finstr);

       
               delete(sprintf('%s.fif',outfile));
        
        % Pull out bad channels from logfile:
        badfile = sprintf('%s.txt',outfile); delete(badfile);
        rik_eval(sprintf('!cat %s.log | sed -n -e ''/Detected/p'' -e ''/Static/p'' | cut -f 5- -d '' '' > %s',outfile,badfile));
        %if s ==1
        %    tmp=dlmread(badfile); Nbuf = size(tmp,1);
        %else
        tmp=dlmread(badfile,' '); Nbuf = size(tmp,1);
        %end
        tmp=reshape(tmp,1,prod(size(tmp)));
        tmp=tmp(tmp>0); % Omit zeros (padded by dlmread):
        
        % Get frequencies (number of buffers in which chan was bad):
        [frq,allbad] = hist(tmp,unique(tmp));
        
        % Mark bad based on threshold (currently ~5% of buffers (assuming 500 buffers)):
        badchans = allbad(frq>0.05*Nbuf);
        if isempty(badchans)
            badstr = '';
        else
            badstr = sprintf(' -bad %s',num2str(badchans))
        end
        
        
        %% 2. tSSS and trans to first file (ie, align within subject if multiple runs)
        
        tSSSstr = ' -st 10 -corr 0.98'; %'tSSSstr = '';
        
        if mvcomp_fail(1,s,1,1) == 1
            compstr = '';
        else
            compstr = sprintf(' -movecomp inter');
        end
        
        outfile = fullfile(sub_wd,sprintf('%s_trans1st',raw_stem))
        if length(runs{1})>1 && r>1
            transtr = sprintf(' -trans %s ',transfstfile)
        else
            transfstfile = [outfile '.fif'];
            transtr = '';
        end
        
        dsstr = ' -ds 4';   % downsample to 250Hz
        
        filestr = sprintf(' -f %s -o %s.fif',raw_file,outfile);
        finstr = [maxfstr filestr basestr badstr tSSSstr compstr origstr transtr dsstr sprintf(' -v | tee %s.log',outfile)]
        rik_eval(finstr);
        
        rik_eval(sprintf('!echo ''Trans 1st...'' >> %s',movfile));
        rik_eval(sprintf('!cat %s.log | sed -n ''/Position change/p'' | cut -f 7- -d '' '' >> %s',outfile,movfile));
        
        
        %% 3. trans to default helmet space (align across subjects)
        
        transfile = fullfile(sub_wd,sprintf('%s_trans1stdef',raw_stem))
        transtr = sprintf(' -trans default -origin %d %d %d -frame head -force',orig+[0 -13 6])
        filestr = sprintf(' -f %s.fif -o %s.fif',outfile,transfile);
        finstr = [maxfstr filestr transtr sprintf(' -v | tee %s.log',outfile)]
        rik_eval(finstr);
        
        rik_eval(sprintf('!echo ''Trans def...'' >> %s',movfile));
        rik_eval(sprintf('!cat %s.log | sed -n ''/Position change/p'' | cut -f 7- -d '' '' >> %s',outfile,movfile));
        
        end
    end
end


if ParType
    matlabpool close force CBU_Cluster
end

