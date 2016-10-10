function transparent_maxfilter(badchannels,subj,bb,rawpath,rawfname,outpath,outfname1,logfname1,outfname2,logfname2,outfname3,logfname3,posfname,badfname,markbadfname)


%% (2) Convert data

skipint = '0 20';
%         mfcmd2=[
%         '/neuro/bin/util/maxfilter-2.2 -f ' [rawfname] ' -o ' [outfname1],...
%         ' -autobad 20 -skip ' [skipint] ' -v | tee ' [logfname1]
%         ];
%       Skipping removed, because errors, because file does not start at
%       zero for some reason.
mfcmd2=[
    '/neuro/bin/util/maxfilter-2.2 -f ' [rawfname] ' -o ' [outfname1],...
    ' -autobad 20 -v | tee ' [logfname1]
    ];

fprintf(1, '\n\n%s\n\n', mfcmd2);
eval([' ! ' mfcmd2])
delete( outfname1 );

%% Get bad channels
% Get bad channels from log file, store in file:
badcmd=[
    'cat ' [logfname1] ' | sed -n ''/Static/p'' | cut -f 5- -d '' '' > ' [badfname]
    ];
fprintf(1, 'Looking for bad channels\n');
fprintf(1, '\n%s\n', badcmd);
eval([' ! ' badcmd]);


% Read bad channels in to matlab variable:
fprintf(1, '\nReading bad channel information\n');
checkempty = dir(badfname);
if checkempty.bytes ==0
    x = [0];
else
    x=dlmread([badfname],' ');
end
x=reshape(x,1,prod(size(x)));
x=x(x>0); % Omit zeros (padded by dlmread):


% Get frequencies (number of buffers in which chan was bad):
[frq,allbad] = hist(x,unique(x));


% Mark bad based on threshold (currently 5 buffers):
bads=allbad(frq>5);
badstxt = sprintf('%s%s%s',num2str(bads))
if sum(badstxt)>0
    dlmwrite([markbadfname],badstxt,'delimiter',' ');
else
    eval(['! touch ' [markbadfname] ])
end

% If extra bad channels defined, append them here
if ~isempty( badchannels{subj,bb} ),
    for i=1:length(badchannels{subj,bb}),
        badstxt = [badstxt ' ' badchannels{subj,bb}{i}];
    end;
end;
fprintf(1, '\nThe following channels are marked as bad: %s\n\n', badstxt);

%% (3) Maxfilter incl. ST and Movecomp
% -- MAXFILTER ARGUMENTS --:

% ORIGIN and FRAME:
orgcmd=sprintf('  -frame head -origin 0 0 45');


% BAD CHANNELS:
if length(badstxt)>0
    badcmd=['  -bad ', badstxt];
else
    badcmd='';
end


% HPI ESTIMATION/MOVEMENT COMPENSATION:
hpistep=200;hpisubt='amp';
hpicmd=sprintf('  -hpistep %d -hpisubt %s -movecomp -hp %s',hpistep,hpisubt,posfname);

% SSS with ST:
stwin=4;
stcorr=0.980;
stcmd=sprintf('  -st %d -corr %g',stwin,stcorr);

% Downsampling (es edit- downsampling turned off)
%         dsval = 4;
%         dscmd=sprintf('  -ds %d', dsval');


% -- MAXFILTER COMMAND --

if exist(outfname2),
    fprintf(1, 'Deleting %s\n', outfname2);
    delete( outfname2 );
end;

mfcmd3=[
    ' /neuro/bin/util/maxfilter -f ' [rawfname] ' -o ' [outfname2],...
    '  -ctc /neuro/databases/ctc/ct_sparse.fif' ' ',...
    '  -cal /neuro/databases/sss/sss_cal.dat' ' ',...
    '  -autobad off ',...
    stcmd,...       % temporal SSS
    badcmd,...      % bad channels
    orgcmd,...      % head frame and origin
    hpicmd,...      % movement compensation
    '  -format short ',...
    '  -v | tee ' [logfname2]
    ];

% removed: dscmd,...       % downsampling
% removed: '  -skip 0 20 ',...  Errors because doesn't start at zero for
% some reason

fprintf(1, '\nMaxfiltering... (SSS+ST)\n');
fprintf(1, '\n\n%s\n\n', mfcmd3);
eval([' ! ' mfcmd3 ]);


% (4) %%%%%%%%%%%%%%%%%%%%%%%%%


% TRANSFORMATION (all but first file, block 1):
if bb>1
    
    trcmd=sprintf(' -trans %s -frame head -origin 0 0 45',b1file);
    
    mfcmd4=[
        '/neuro/bin/util/maxfilter -f ' [outfname2] ' -o ' [outfname3],...
        '  -autobad off ', trcmd, ' -force -v | tee ' logfname3
        ];
    fprintf(1, '\nMaxfiltering... -trans\n');
    fprintf(1, '%s\n', mfcmd4);
    eval([' ! ' mfcmd4 ])
    
else,
    
    b1file = outfname2;     % file used for future "trans"
    copyfile( outfname2, outfname3 );
    
end;    % if bb>1
