 subjfolder = sprintf('/imaging/tc02/vespa/preprocess/%s/MMN+Rest',subjects{ss});
    cd(subjfolder)
    
    
    efile = {};
    nr_sess = length( blocksin{ss} );
    
    %clear S D;
    
    swd = fullfile(bwd,subjects{ss});
    fprintf(1, 'Subject: %s\n', swd);
%     try
%         eval(sprintf('!mkdir %s',swd))
%     end

    mkdir(swd)
    cd(swd)
    
    % Loop over blocks:
    for ses = 1:nr_sess
        %clear refs
        
        % Find Maxfiltered files:
        rawfile  = fullfile(rawpathstem,subjects{ss},sprintf('/MMN+Rest/%s_raw_ssst.fif',blocksin{ss}{ses}));
        
        fprintf(1, 'Processing %s\n', rawfile);
                
        S = [];
        S.dataset  = rawfile;
        S.outfile  = fullfile(bwd,subjects{ss},blkout{ss}{ses})
        
        tmp = load(chanfile);
        S.channels = tmp.montage.labelorg;
    end