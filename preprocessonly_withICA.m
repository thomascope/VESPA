parfor cnt = 1:size(subjects,2)
    
%     es_preprocess_parallel('definetrials','maxfilter',p,pathstem,subjects{cnt},cnt);
%      es_preprocess_parallel('convert+epoch','maxfilter',p,pathstem,subjects{cnt},dates,blocksin,blocksout,rawpathstem,badeeg,cnt);
   es_preprocess_parallel('convert','maxfilter',p,pathstem,subjects{cnt},dates,blocksin,blocksout,rawpathstem,badeeg,cnt);
   es_preprocess_parallel('ICA_artifacts','convert',p,pathstem,subjects{cnt},cnt);
   es_preprocess_parallel('definetrials','maxfilter',p,pathstem,subjects{cnt},cnt);
   es_preprocess_parallel('epoch','ICA_artifacts',p,pathstem,subjects{cnt},dates,blocksin,blocksout,rawpathstem,badeeg,cnt);
    es_preprocess_parallel('downsample','epoch',p,pathstem,subjects{cnt},cnt);
    es_preprocess_parallel('rereference','downsample',p,pathstem,subjects{cnt},cnt);
    es_preprocess_parallel('baseline','rereference',p,pathstem,subjects{cnt},cnt);
    es_preprocess_parallel('filter','baseline',p,pathstem,subjects{cnt},cnt);
    es_preprocess_parallel('merge','filter',p,pathstem,subjects{cnt},cnt);
    es_preprocess_parallel('sort','merge',p,pathstem,subjects{cnt},cnt);
    es_preprocess_parallel('average','merge',p,pathstem,subjects{cnt},cnt);
    es_preprocess_parallel('filter','average',p,pathstem,subjects{cnt},cnt);
    
    es_preprocess_parallel('combineplanar','fm*.mat',p,pathstem,subjects{cnt},cnt);
    es_preprocess_parallel('grand_average','pcfm*.mat',p,pathstem,subjects{cnt},cnt);
    
    %es_preprocess_parallel('weight','pcfm*.mat',p,pathstem,subjects{cnt},cnt);
    %es_preprocess_parallel('grand_average','wpcfm*.mat',p,pathstem,subjects{cnt},cnt);
    
    %es_preprocess_parallel('image','cfm*.mat',p,pathstem,subjects{cnt},cnt);
    %es_preprocess_parallel('image','wpcfm*.mat',p,pathstem,subjects{cnt},cnt);
    %es_preprocess_parallel('smooth','image',p,pathstem,subjects{cnt},cnt);
    %es_preprocess_parallel('firstlevel','smooth',p,pathstem,subjects{cnt},cnt);
    
    %es_preprocess_parallel('mask','image',p,pathstem,subjects{cnt},cnt);
    
    %% Other preprocessing steps
    %es_preprocess_parallel('artefact','baseline',p,pathstem,subjects{cnt},cnt);
    %es_preprocess_parallel('sort','average',p,pathstem,subjects{cnt},cnt);
    %es_preprocess_parallel('erase','',p,pathstem,subjects{cnt},cnt);
    %p.outputstem = '/imaging/es03/P6E1/preprocess_TF/'; % for copying files
    %es_preprocess_parallel('copy','rereference',p,pathstem,subjects{cnt},cnt);
    
end