function [D,L,R,Ic,Nd,Nc,SX] = group_lead_field(D,Nmod,i,modalities)

fprintf('Checking lead fields for subject %i\n',i)
[L,D{i}] = spm_eeg_lgainmat(D{i});

for m = 1:Nmod
    
    % Check gain or lead-field matrices
    %------------------------------------------------------------------
    Ic{i,m}  = indchantype(D{i}, modalities{m}, 'GOOD');
    Nd(i)    = size(L,2);
    Nc(i,m)  = length(Ic{i,m});
    
    if isempty(Ic{i,m})
        errordlg(['Modality ' modalities{m} 'is missing from file ' D{i}.fname]);
        return
    end
    
    if any(diff(Nd))
        errordlg('Please ensure subjects have the same number of dipoles')
        return
    end
    
    % Check for null space over sensors (SX) and remove it
    %------------------------------------------------------------------
    try
        SX     = D{i}.sconfounds{m};
        R{i,m} = speye(Nc(i,m),Nc(i,m)) - SX*spm_pinv(SX);
    catch
        R{i,m} = speye(Nc(i,m),Nc(i,m));
    end
end