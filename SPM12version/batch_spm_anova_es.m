function [X]=batch_spm_anova_es(S);

% Edited slightly from original by ES
% Changed how the input images are specified (since file strings of ES's image files have different lengths):
% imgfiles{1}{1}{1} = 'mydir/grp1_sub1_con1.nii';
% imgfiles{1}{1}{2} = 'mydir/grp1_sub1_con2.nii';
% imgfiles{1}{2}{1} = 'mydir/grp1_sub2_con1.nii';
% imgfiles{1}{2}{2} = 'mydir/grp1_sub2_con2.nii';

% A general function for N-way mixed (within+between subjects) ANOVAs in SPM5/SPM8
% (though assumes same number of conditions per group)
%                                                                R Henson Oct 2006
%
% Two required arguments in S are:
%    imgfiles    - cell array of cell arrays of image filenames for each group and subject
%
% Optional arguments in S are:
%    outdir      - output directory for SPM analysis files
%    maskimg     - image for SPM analysis mask (ie, voxels with 0 value ignored)
%    nsph_flag   - whether nonsphericity correction should be applied
%    sub_effects - whether subject effects included (yes by default)
%    contrasts   - cell array of contrast structures, with fields c
%                  (matrix), type ('F' or 'T') and name (optional)
%    user_regs   - additional user-specified regressors per group, each such 
%                  regressor having a value for each condition and subject
%    uUFp        - uncorrected p-value threshold for mask for nonsphericity
%
% The only complicated bit is organising imgfiles correctly, so here's an example:
%
%  imgfiles{1}{1} = ['mydir/grp1_sub1_con1.nii'; 'mydir/grp1_sub1_con2.nii'];
%  imgfiles{1}{2} = ['mydir/grp1_sub2_con1.nii'; 'mydir/grp1_sub2_con2.nii'];
%  imgfiles{2}{1} = ['mydir/grp2_sub1_con1.nii'; 'mydir/grp2_sub1_con2.nii'];
%  imgfiles{2}{2} = ['mydir/grp2_sub2_con1.nii'; 'mydir/grp2_sub2_con2.nii'];
%
% Actually, the organisation of the later-added user_regs is also a bit complex:
%
%  user_regs{1} = [[1:4]' rand(4,1)];       % 2 regressors for group 1 
%  user_regs{2} = [[1:4]' rand(4,1)];       % 2 regressors for group 2
%
% where each group has 2 subjects with 2 conditions (ie 4 values), continuing above example
% (currently must be same number of regressors per group)

try 
    imgfiles = S.imgfiles;
catch
    error('Must provide image filenames in S.imgfiles')
end

try 
    outdir = S.outdir;
catch
    outdir = pwd;
end

try 
    maskimg = S.maskimg;
catch
    maskimg = [];
end

if ~isempty(maskimg)
   try
     maskimg = spm_vol(maskimg);
   catch
     error('Cannot open specified mask image');
   end
end

try 
    nsph_flag = S.nsph_flag;
catch
    nsph_flag = -9;  % Nonsphericity to be determined by design (below)
end

try 
    sub_effects = S.sub_effects;
catch
    sub_effects = 1;
end

try 
    contrasts = S.contrasts;
catch
    contrasts = [];
end

try
    user_regs = S.user_regs;    % user_regs{grp}{con} must be Num_Subs x Num_Regs 
catch
    user_regs = cell(1,length(imgfiles));
end

try
    uUFp = S.uUFp;              
catch
    uUFp = 0.001;
end

ngrp = length(imgfiles);

P={}; cname={};
np=0; nc=0;
for g=1:ngrp
    nsub(g) = length(imgfiles{g});
    %ncon    = size(imgfiles{g}{1},1);   % Assumes same ncon for all subjects
    ncon    = size(imgfiles{g}{1},2);    % ES edit
    for n=1:ncon
        for s=1:nsub(g)
            np=np+1;
     	    %P{np} = imgfiles{g}{s}(n,:);
            P{np} = imgfiles{g}{s}{n}; % ES edit
        end
        nc=nc+1;
        cname{nc} = sprintf('grp %d, con %d, mean',g,n);
        for r=1:length(user_regs{g})
            nc=nc+1;
            cname{nc} = sprintf('grp %d, con %d, reg %d',g,n,r);            
        end
    end 
end

spm_defaults; global defaults;
try   defaults.modality;
catch defaults.modality = 'EEG';
end
eval(sprintf('defaults.stats.%s.ufp = %f;',lower(defaults.modality),uUFp));

pflag = 0;   %whether you want figures of design matrix/nonsphericity before estimating

%-----------------------------------------------------------------
% Contrast name and numbers (for each condition/basis function)

totsub = sum(nsub);           % (total number of subjects)
nscan  = sum(ncon.*nsub);     % number of rows in X

try eval(sprintf('!mkdir %s',outdir)); end
cd(outdir);

if sub_effects
  for s=1:totsub                  % add subject effects
    cname{end+1} = sprintf('subject %d',s);
  end
end

%-Assemble SPM structure
%=======================================================================

SPM.nscan = nscan;
SPM.xY.P  = P;
for i=1:SPM.nscan
    SPM.xY.VY(i) = spm_vol(SPM.xY.P{i});
end

% Build design matrix (X), Indices (Ind) and NONSPHERICITY (vi) (inelegant, but gets there...!)

X=[]; Ind=[]; vi={};
nv=0; z=zeros(nscan,nscan); os=0;

for g=1:ngrp
    ns = nsub(g);
    nr = ncon*ns;
    id = [1:ns]';
    nreg = size(user_regs{g},2);    
    
    tmp = kron(eye(ncon),ones(ns,1));
    if ~isempty(user_regs{g});
        tmp = [tmp user_regs{g}];   % user_regs must be (ns x ncon) by nreg 
    end
        
    tmpX = [zeros(nr,(ncon+nreg)*(g-1)),...  % assumes same number of user_regs per group
            tmp,...
            zeros(nr,(ncon+nreg)*(ngrp-g))];
    
    % could add constants for group effects if wish
    
    if ncon>1 & sub_effects
      tmpX = [tmpX zeros(size(tmpX,1),sum(nsub(1:(g-1)))) kron(ones(ncon,1),eye(ns))];
    end
    
    if g>1
      if ncon>1 & sub_effects
         X = [X zeros(size(X,1),ns); tmpX];
      else
	     X = [X; tmpX];
      end
    else
      X = tmpX;
    end
    
    % Indices for effects (unnecessary really?)
    Ind = [Ind; ones(nr,1),...                  %kron(ones(ncon,1),id),...
                kron([1:ncon]',ones(ns,1)),...
                kron(ones(ncon,1),id),...      
                ones(nr,1)*g];
    
 % Nonsphericity
    
    if nsph_flag ~= 0      % ie, unless user turns off...

    % unequal covariances (within conditions; independent between groups)
     if nsph_flag==1 | (ncon>2 & ns>1)
      nsph_flag = 1;
      for c1 = 1:ncon
        for c2 = (c1+1):ncon
            nv = nv+1;
            v = z;
            v( os + (c1-1)*ns + id, os + (c2-1)*ns + id )=eye(ns);
            v( os + (c2-1)*ns + id, os + (c1-1)*ns + id )=eye(ns);
            vi{nv} = sparse(v);   
        end
      end
     end

    % unequal variances (need if unequal covariances)
%     if ngrp>1 & all(nsub>1)   % This won't work (need unequal vars too)
     if nsph_flag==1 | (ngrp>1 & ns>1)
      nsph_flag = 1;
      for c1 = 1:ncon
        nv = nv+1;
        v = z;
        v(os + (c1-1)*ns + id, os + (c1-1)*ns + id)=eye(ns);
        vi{nv} = sparse(v);
      end
     end
    
      os = os + ncon*ns;
    end
end

if nsph_flag<0; nsph_flag=0; end

if pflag
 figure,imagesc(X),colormap('gray')
 figure,hold on,colormap('gray')
 for pp=1:length(vi)
  subplot(1,length(vi),pp)
  imagesc(vi{pp})
 end
end

nH = (ncon+nreg)*ngrp; % Columns of interest

%Ind = [ones(nscan,1) kron((1:ncon)',ones(totsub,1)) kron(ones(ncon,1),(1:totsub)') ones(nscan,1)];
SPM.xX = struct(...
        'X',X,...
        'iH',[1:nH],'iC',zeros(1,0),'iB',[(nH+1):size(X,2)],'iG',zeros(1,0),...
        'name',{cname},'I',Ind,...
        'sF',{{'repl'  'col'  'dummy'  'grp'}});
SPM.xC  = [];	
SPM.xGX = struct(...
        'iGXcalc',1,    'sGXcalc','omit',                               'rg',[],...
        'iGMsca',9,     'sGMsca','<no grand Mean scaling>',...
        'GM',0,         'gSF',ones(nscan,1),...
        'iGC',  12,     'sGC',  '(redundant: not doing AnCova)',        'gc',[],...
        'iGloNorm',9,   'sGloNorm','<no global normalisation>');

if nsph_flag
 SPM.xVi = struct('iid',0,'I',SPM.xX.I,'Vi',{vi} );       
else
 SPM.xVi = struct('iid',1,'V',speye(nscan) );       
end

Mdes    = struct(...	
        'Analysis_threshold',   {'None (-Inf)'},...
        'Implicit_masking',     {'Yes: NaNs treated as missing'},...
        'Explicit_masking',     {'No'});
SPM.xM  = struct(...
        'T',-Inf,'TH',ones(nscan,1)*-Inf,'I',1,'VM',maskimg,'xs',Mdes);
Pdes    = {{sprintf('%d condition, +0 covariate, +0 block, +0 nuisance',ncon); sprintf('%d total, having %d degrees of freedom',ncon,ncon); sprintf('leaving %d degrees of freedom from %d images',nscan-ncon,nscan)}};
SPM.xsDes = struct(...
        'Design',               {'1-way ANOVA'},...
        'Global_calculation',   {'omit'},...
        'Grand_mean_scaling',   {'<no grand Mean scaling>'},...
        'Global_normalisation', {'<no global normalisation>'},...
        'Parameters',           Pdes);
save SPM SPM

%return

% Estimate parameters
%===========================================================================
SPM = spm_spm(SPM);


% Always Effects of interest contrast
%===========================================================================
SPM = rmfield(SPM,'xCon'); cn=0;

cn = cn+1;
c              = eye(nH);
if size(c,1)>1,  c=detrend(c,0); end
c              = [c zeros(size(c,1),size(SPM.xX.X,2)-nH)];
cname          = 'Unwhitened effects of interest';
SPM.xCon(cn)   = spm_FcUtil('Set',cname,'F','c',c',SPM.xX.xKXs);

% Addition user contrasts
%===========================================================================
% Only F-contrasts at moment!

if ~isempty(contrasts)
 for n=1:length(contrasts)
    cn = cn+1;
    c  = contrasts{n}.c;
    if size(c,2) ~= nH
      error(sprintf('Contrast %d supplied does not have %d columns',n,nH))
    else
     c            = [c zeros(size(c,1),size(SPM.xX.X,2)-nH)];
     
     if ~isfield(contrasts{n},'name')
       cname        = sprintf('User Con %d',n);
     else
       cname        = contrasts{n}.name;
     end
     
     SPM.xCon(cn) = spm_FcUtil('Set',cname,contrasts{n}.type,'c',c',SPM.xX.xKXs);
    end
 end
end

spm_contrasts(SPM);

