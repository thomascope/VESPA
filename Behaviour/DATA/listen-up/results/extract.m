% names = ls('short_ListenAndSee_*.csv');
% tokeep = [];
% threshold = zeros(1,size(names,1))
% subjects = cell(1,size(names,1))
% for i = 1:size(names,1)
%     thisthresh = xlsread(names(i,:),1,'F5:F5')
%     if length(thisthresh) == 1
%         wdwdthreshold(i) = xlsread(names(i,:),1,'F5:F5');
%         nonwdthreshold(i) = xlsread(names(i,:),1,'F6:F6');
%         tokeep= [tokeep, i];
%         [rubbish subjects{i}] = xlsread(names(i,:),1,'B2:B2');
%     end
% end
% clear rubbish thisthresh
% for i = 1:length(tokeep)
%     allthresh.subjects{i}=subjects{tokeep(i)};
%     allthresh.wdwdthresholds(i)=wdwdthreshold(tokeep(i));
%     allthresh.nonwdthresholds(i)=nonwdthreshold(tokeep(i));
% end

patientfilenames = ls([pwd '\patients\short_ListenAndSee_*.csv']);
tokeep = [];
wdwdthreshold = zeros(1,size(patientfilenames,1));
nonwdthreshold = zeros(1,size(patientfilenames,1));
thresholddifference = zeros(1,size(patientfilenames,1));
subjects = cell(1,size(patientfilenames,1));
for i = 1:size(patientfilenames,1)
    thisthresh = xlsread([pwd '\patients\' patientfilenames(i,:)],1,'F5:F6');
    if length(thisthresh) == 2
        wdwdthreshold(i) = thisthresh(1);
        nonwdthreshold(i) = thisthresh(2);
        tokeep= [tokeep, i];
        [rubbish subjects{i}] = xlsread([pwd '\patients\' patientfilenames(i,:)],1,'B2:B2');
        thresholddifference(i) = nonwdthreshold(i)-wdwdthreshold(i);
    end
end
clear rubbish thisthresh
for i = 1:length(tokeep)
    allthresh.patientsubjects{i}=subjects{tokeep(i)};
    allthresh.patientwdwdthresholds(i)=wdwdthreshold(tokeep(i));
    allthresh.patientnonwdthresholds(i)=nonwdthreshold(tokeep(i));
    allthresh.patientthresholddifferences(i) = thresholddifference(i);
end

controlfilenames = ls([pwd '\controls\short_ListenAndSee_*.csv']);
tokeep = [];
wdwdthreshold = zeros(1,size(controlfilenames,1));
nonwdthreshold = zeros(1,size(controlfilenames,1));
thresholddifference = zeros(1,size(controlfilenames,1));
subjects = cell(1,size(controlfilenames,1));
for i = 1:size(controlfilenames,1)
    thisthresh = xlsread([pwd '\controls\' controlfilenames(i,:)],1,'F5:F6');
    if length(thisthresh) == 2
        wdwdthreshold(i) = thisthresh(1);
        nonwdthreshold(i) = thisthresh(2);
        tokeep= [tokeep, i];
        [rubbish subjects{i}] = xlsread([pwd '\controls\' controlfilenames(i,:)],1,'B2:B2');
        thresholddifference(i) = nonwdthreshold(i)-wdwdthreshold(i);
    end
end
clear rubbish thisthresh
for i = 1:length(tokeep)
    allthresh.controlsubjects{i}=subjects{tokeep(i)};
    allthresh.controlwdwdthresholds(i)=wdwdthreshold(tokeep(i));
    allthresh.controlnonwdthresholds(i)=nonwdthreshold(tokeep(i));
    allthresh.controlthresholddifferences(i) = thresholddifference(i);
end
dataforplotting = [allthresh.patientwdwdthresholds'; allthresh.controlwdwdthresholds'; allthresh.patientnonwdthresholds'; allthresh.controlnonwdthresholds'; allthresh.patientnonwdthresholds'; allthresh.controlnonwdthresholds'];
boxplot([allthresh.patientwdwdthresholds'; allthresh.controlwdwdthresholds'; allthresh.patientnonwdthresholds'; allthresh.controlnonwdthresholds'; allthresh.patientnonwdthresholds'; allthresh.controlnonwdthresholds'])
