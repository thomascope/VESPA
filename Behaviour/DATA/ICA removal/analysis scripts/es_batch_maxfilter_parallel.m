%based on script by Jason Taylor (es edit- downsampling turned off)

es_batch_init;

%% The rest should not need editing

% es edit- Assemble info needed to locate files for each subject
for s=1:length(subjects)
    subject{s} = { subjects{s} dates{s} };
end

nr_sbj = length(subject);

try do_subjects,    % if do_subjects not defined, do all subjects
catch
    do_subjects = [1:nr_sbj];
end;

% Check file names and paths
checkflag = 0;
for subj = do_subjects,
    nr_bls = length( blocksin{subj} );
    if length(blocksin{subj}) ~= length(blocksout{subj}),
        checkflag = 1;
        fprintf(1, 'Different number of input and output names for subject %d (%s, %s)\n', subj, subject{subj}{1}, subject{subj}{2});
    end;
    for bb = 1:nr_bls,        
        rawpath = fullfile( rawpathstem, subject{subj}{1}, subject{subj}{2} );
        rawfname = fullfile( rawpath, [blocksin{subj}{bb} '_raw.fif'] );
        outpath = fullfile( pathstem, subject{subj}{1} );
        if ~exist( outpath, 'dir' ),
            success = mkdir( outpath );
            if ~success,
                checkflag = 1;
                fprintf(1, 'Could not create directory %s\n', outpath);
            end;
        end;
        if ~exist( rawfname, 'file' ),
            checkflag = 1;
            fprintf(1, '%s does not exist\n', rawfname);
        end;        
    end;
end;
if checkflag,
    fprintf(1, 'You''ve got some explaining to do.\n');
    return;
end;


parfor subj = do_subjects,
    nr_bls = length( blocksin{subj} );
    
    for bb = 1:nr_bls,
 
        rawpath = fullfile( rawpathstem, subject{subj}{1}, subject{subj}{2} );
        rawfname = fullfile( rawpath, [blocksin{subj}{bb} '_raw.fif'] );
        
        outpath = fullfile( pathstem, subject{subj}{1} );
        
        outfname1 = fullfile( outpath, [blocksout{subj}{bb} '_raw_tmp.fif'] );    % files after bad channel check
        logfname1 = fullfile( outpath, [blocksout{subj}{bb} '_raw_tmp.log'] );

        outfname2 = fullfile( outpath, [blocksout{subj}{bb} '_raw_sss.fif'] );    % files after SSS+ST
        logfname2 = fullfile( outpath, [blocksout{subj}{bb} '_raw_sss.log'] );
        
        outfname3 = fullfile( outpath, [blocksout{subj}{bb} '_raw_ssst.fif'] );   % files after interpolation to first specified session
        logfname3 = fullfile( outpath, [blocksout{subj}{bb} '_raw_ssst.log'] );                

        posfname = fullfile( outpath, [blocksout{subj}{bb} '_raw_hpi.pos'] );     % HPI info

        badfname = fullfile( outpath, [blocksout{subj}{bb} '_raw_bad.txt'] );     % bad channel info

        markbadfname = fullfile( outpath, [blocksout{subj}{bb} '_raw_markbad.fif'] );
        
        fprintf(1, '\n Now processing %s with %d pre-specified bad channels.\n', rawfname, length( badchannels{subj, bb} ) );

        transparent_maxfilter(badchannels,subj,bb,rawpath,rawfname,outpath,outfname1,logfname1,outfname2,logfname2,outfname3,logfname3,posfname,badfname,markbadfname)

    end;    % blocks
    
end;    % subjects