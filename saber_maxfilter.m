
addpath /neuro/meg_pd_1.2;
ccid_1={'meg14_0072_vc1/140224'}; % fill indices of subject here

% ICA denoising of VEOG activity
% Initialise:

addpath /imaging/local/linux/mne_2.6.0/mne/matlab/toolbox;
addpath /neuro/meg_pd_1.2/       % FIFACCESS toolbox if use some meg_misc functions below
fxnpath='/imaging/local/spm_eeglab/';
eeglabpath='/imaging/local/eeglab/';
addpath(fxnpath);
addpath(eeglabpath);
eeglab


%open matlabpool
%if matlabpool('size')==0;
%P=parcluster(parallel.importProfile('/hpc-software/matlab/cbu/CBU_Cluster.settings'));
%P.NumWorkers=16;
%P.SubmitArguments='-l walltime=400:00';
%matlabpool(P)
%end



for i=1:1,                      % final index should be number of subjects
    
    %% Applying MaxFilter 2.2
    
    infname = ['/megdata/cbu/vespa/' ccid_1{i} '/rest_raw.fif']; % e.g. specifying input filename for Thomas
    outfstem = ['/imaging/mlr/users/tc02/vespa/preprocess/' ccid_1{i} '_rest']; % specifying output filestem
    [p fstem ext] = fileparts(infname);
    posfname = [outfstem '_headposition.pos']; % specifying head position filename
    hptxtfname = [outfstem '_headpoints.txt']; % specifying head points text file
    
    % Obtaining HPI points
    
    if exist(hptxtfname,'file')~=2
        [co ki] = hpipoints(sprintf('%s',infname)); % HPI points
        headpoints = co(:,ki>1);  % don't include the fiducial points
        headpoints = headpoints(~(headpoints(:,2)>0 & headpoints(:,3)<0),:); % Remove nose points:
        save(hptxtfname,'-ASCII','headpoints');
    end
    
    sphtxtfname = [outfstem '_sphere_fit.txt'];
    
    % Fitting sphere to HPI points
    
    if exist(sphtxtfname,'file')~=2
        cmd_fit = ['/neuro/bin/util/fit_sphere_to_points ' hptxtfname];
        [status spherefit] = unix(cmd_fit);
        if status ~= 0 || length(spherefit)<1
            error('Spherefit failed!')
        end
        %fit = str2double(spherefit)*1000; % m to mm;
        %--hack: str2double wasn't working in one go :(
        ind = [1 findstr(' ',spherefit)];
        if ind(end)<length(spherefit)
            ind(end+1) = length(spherefit);
        end
        fit = [];
        for si=1:length(ind)-1
            fit(si) = str2double(spherefit(ind(si):ind(si+1)))*1000;
        end
        %--end hack
        dlmwrite(sphtxtfname,fit,'\t');
    else
        fit = dlmread(sphtxtfname,'\t');
    end
    
    % Initialise
    orgcmd = '';
    hpicmd = '';
    stcmd  = '';
    trcmd_def = '';
    
    % Origin and frame
    orgcmd = sprintf(' -frame head -origin %g %g %g',fit(1),fit(2),fit(3)');
    
    % SSS with ST:
    stwin    = 10;
    stcorr   = 0.980;
    stcmd    = sprintf(' -st %d -corr %g ',stwin,stcorr);
    
    % HPI estimation and movement compensation
    hpistep = 10; hpisubt='amp';
    hpicmd = sprintf(' -linefreq 50 -hpistep %d -hpisubt %s -movecomp inter -hp %s',hpistep,hpisubt,posfname);
    
    % Transformation
    trpfx_def = 'transdef_';
    trcmd_def = sprintf(' -trans default -frame head -origin %g %g %g',fit(1),fit(2)-13,fit(3)+6);
    
    % Preparing names of output and log files
    outpfx    = trpfx_def;
    outfname  = sprintf('%s%s.fif',outfstem,outpfx);
    logfname  = sprintf('%s%s.log',outfstem,outpfx);
    
    % Assembling MF command
    mfcmd_rest=[
        '! /neuro/bin/util/maxfilter-2.2 -f ' infname ' -o ' outfname,...
        '      -ctc /neuro/databases/ctc/ct_sparse.fif' ' ',...
        '      -cal /neuro/databases/sss/sss_cal.dat' ' ',...
        '      -autobad on ', orgcmd, stcmd, hpicmd, trcmd_def ' -v | tee ' logfname
        ];
    
    curdir=pwd;
    
    % Executing MF
    eval(mfcmd_rest);
end
