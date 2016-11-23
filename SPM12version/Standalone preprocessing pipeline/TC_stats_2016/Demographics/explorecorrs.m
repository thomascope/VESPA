siglevel = input('\nWhat p-value threshold would you like?\n');
bonferroni = input('\nWould you like Bonferroni correction?, y or n (default yes):\n');
[controlRHO,controlPVAL] = corr(controldata);
[patientRHO,patientPVAL] = corr(patientdata);
numcontrolcorrs = size(controlPVAL,1)-length(find(isnan(controlPVAL(1,:))));
numpatientcorrs = size(patientPVAL,1)-length(find(isnan(patientPVAL(1,:))));
patientPVAL(1:size(patientPVAL,2)+1:end)=NaN;
controlPVAL(1:size(controlPVAL,2)+1:end)=NaN;
if bonferroni == 'n'
    patsiglevel = siglevel;
    consiglevel = siglevel;
else
    patsiglevel = siglevel/numpatientcorrs;
    consiglevel = siglevel/numcontrolcorrs;
end
[controlcols,controlrows] = find(controlPVAL<(consiglevel));
[patientcols,patientrows] = find(patientPVAL<(patsiglevel));
for i = 1:length(controlcols)
    fprintf('\nFor controls, %s correlates significantly with %s\n',char(headings(controlrows(i))),char(headings(controlcols(i))))
%     if controlcols(i)<controlrows(i)
%         fprintf('\nFor controls, %s correlates significantly with %s\n',char(headings(controlcols(i))),char(headings(controlrows(i))))
%     end
end

for i = 1:length(patientcols)
    fprintf('\nFor patients, %s correlates significantly with %s\n',char(headings(patientrows(i))),char(headings(patientcols(i))))
%     if patientcols(i)<patientrows(i)
%         fprintf('\nFor patients, %s correlates significantly with %s\n',char(headings(patientcols(i))),char(headings(patientrows(i))))
%     end
end

if length(controlcols) + length(patientcols) > 50
    input(['\n Warning, you are about to produce ' num2str(length(controlcols) + length(patientcols)) ' figures. Do you wish to continue or ctrl+c? \n '])
end

plotdemographiccorrs(controlcols,controlrows)
plotdemographiccorrs(patientcols,patientrows)