function [remove,weights,TraMat,ICs,datacor,varexpl] = remove_ICA_artefacts(d,refs,PCA_dim,Nperm,CorThr,VarThr,FiltPars);
%function varargout = remove_ICA_artefacts(d,refs,PCA_dim,Nperm,CorThr,VarThr,FiltPars);

% Version 1.0 of ICA artifact detection for SPM8/12 using boot-strapped distribution of Pearson's correlations
% (by phase-shuffling of Fourier transform) with recorded artifact channels (eg VEOG, HEOG, ECG)
%
% Needs EEGLAB on Matlab path to perform ICA
% Needs Fieldtrip on Matlab path to perform any filtering (though could be replaced by Matlab filtfilt)
%
% Rik.Henson@mrc-cbu.cam.ac.uk, March 2013, with thanks to Nitin Williams and Jason Taylor
%
% Inputs:
%
% d       = Channel (Sensor) X Time matrix of EEG/MEG data to be corrected
% refs    = Channel X Time matrix of recorded artifacts (eg EOG)
% PCA_dim = number of PCs for data reduction priot to ICA (eg 60)
% Nperm   = number of permutations to create null distribution of Pearson (eg 1000)
% CorThr  = upper percentile for defining artifactual IC (eg 95 for one data channel, or 99 for Bonferonni corrected number of channels) (DEFAULT possible)
% VarThr  = percentage of variance required to be an important artifactual IC (eg 1/PCA_dim, or could be 0) (DEFAULT possible)
% FiltPars = 1x2 or 1x3 matrix for low- or band- pass filtering before calculating correlation ([]=none=default), where third element is Sampling Rate
%
% Outputs:
% remove   = IC indices that thought to be artifacts
% weigths  = ICA weight matrix
% TraMat   = SPM8/12 (FieldTrip) Trajectory Matrix for projecting out IC artifacts (those indexed in "remove")
% activations = unfiltered independent components (PCA_dim X Time) (EEGLAB terminology!)
% datacor  = distribution of correlations
% varexpl  = variance explained
%
% Future improvements - use topographic information (weights), eg from blink templates

if nargin < 7
    FiltPars = [];
    if nargin < 6
        VarThr = 100/PCA_dim;
        if nargin < 5
            CorPval = .05/(2*PCA_dim);  % Kind of 2-tailed Bonferonni?
            CorThr  = 100*(1-CorPval); 
            if nargin < 4
                Nperm = round((4*sqrt(CorPval)/CorPval)^2);  % http://www.epibiostat.ucsf.edu/biostat/sen/statgen/permutation.html#_how_many_permutations_do_we_need
            end
        end
    end
end

Nrefs = size(refs,1);
Nsamp = size(d,2);

if rem(Nsamp,2)==0  % Must be odd number of samples for fft below
    d     = d(:,2:Nsamp);
    refs  = refs(:,2:Nsamp);
    Nsamp = Nsamp-1;
end

[weights,sphere,compvars,bias,signs,lrates,activations] = runica(d,'pca',PCA_dim,'extended',1,'maxsteps',800);
%[weights,sphere,compvars,bias,signs,lrates,activations] = rik_runica(d,'pca',PCA_dim,'extended',1,'maxsteps',800,'rseed',1);  % If want reproducibility

if length(FiltPars) == 3
    fprintf('Bandpass filtering from %d to %d Hz (warning - can fail)\n',FiltPars(1), FiltPars(2));
    try
        refs = ft_preproc_bandpassfilter(refs, FiltPars(3), FiltPars(1:2),  [], 'but','twopass','reduce')';
        ICs  = ft_preproc_bandpassfilter(activations,  FiltPars(3), FiltPars(1:2),  [], 'but','twopass','reduce')';
    catch
        refs = ft_preproc_bandpassfilter(refs, FiltPars(3), FiltPars(1:2),  [], 'but','twopass')';
        ICs  = ft_preproc_bandpassfilter(activations,  FiltPars(3), FiltPars(1:2),  [], 'but','twopass')';
    end
elseif length(FiltPars) == 2
    fprintf('Lowpass filtering to %d Hz\n',FiltPars(1));
    try % Only the new fieldtrip allows for automatic error reduction. Old version errors with 'too many input arguments'
        refs = ft_preproc_lowpassfilter(refs, FiltPars(2), FiltPars(1),  4, 'but','twopass','reduce')';
        ICs  = ft_preproc_lowpassfilter(activations,  FiltPars(2), FiltPars(1),  4, 'but','twopass','reduce')';
    catch
        try
            refs = ft_preproc_lowpassfilter(refs, FiltPars(2), FiltPars(1),  4, 'but','twopass')';
            ICs = ft_preproc_lowpassfilter(activations,  FiltPars(2), FiltPars(1),  4, 'but','twopass')';
        catch
            refs = ft_preproc_lowpassfilter(refs, FiltPars(2), FiltPars(1),  3, 'but','twopass')';
            ICs  = ft_preproc_lowpassfilter(activations,  FiltPars(2), FiltPars(1),  3, 'but','twopass')';
        end
    end
else
    ICs  = activations'; % Faster if pre-transpose once (check tic;toc)
    refs = refs';
end

% figure; for i=1:size(refs,2); plot(refs(:,i)); title(i); pause; end
% figure; for i=1:PCA_dim; plot(ICs(:,i)); title(i); pause; end
% figure; for i=1:PCA_dim; plot(ICs(30000:40000,i)); title(i); pause; end

varexpl = 100*compvars/sum(compvars);

datacor = zeros(Nrefs,PCA_dim);
remove  = cell(1,Nrefs);

for r = 1:Nrefs
%parfor r = 1:Nrefs        % If want to parallelise (could parallelise Nperm loop below instead)
%    datacor = zeros(r,PCA_dim);

    permcor = zeros(1,PCA_dim);
    maxcor  = zeros(Nperm,1);

    for k = 1:PCA_dim
        datacor(r,k) = corr(refs(:,r),ICs(:,k));
%        figure,hist(datacor)
    end
    
    ff = fft(refs(:,r),Nsamp);                 
    mf = abs(ff);                             
    wf = angle(ff);                           
    hf = floor((length(ff)-1)/2);
    rf = mf;  
    
    for l = 1:Nperm
        btdata = zeros(size(ff));
        rf(2:hf+1)=mf(2:hf+1).*exp((0+1i)*wf(randperm(hf)));    % randomising phases (preserve mean, ie rf(1))
        rf((hf+2):length(ff))=conj(rf((hf+1):-1:2));            % taking complex conjugate
        btdata = ifft(rf,Nsamp);                                % Inverse Fourier transform
        
        for k = 1:PCA_dim
            permcor(k) = corr(btdata,ICs(:,k));
        end
        maxcor(l) = max(abs(permcor));
        fprintf('.');
    end
    fprintf('\n')
    %                figure,hist(maxcor)
    
    thresh = prctile(maxcor,CorThr);
    
    remove{r} = find(abs(datacor(r,:)) > thresh & varexpl > VarThr);
end
remove = unique(cat(2,remove{:}));

%figure,hist(datacor')

% figure; for i=remove; plot(ICs(30000:40000,i)); title(i); pause; end

if ~isempty(remove)
    finalics  = setdiff([1:PCA_dim],remove);
    iweights  = pinv(weights);
    TraMat    = iweights(:,finalics) * weights(finalics,:);
else
    TraMat    = eye(size(d,1));
end
