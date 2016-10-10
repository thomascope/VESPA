load('/imaging/tc02/vespa/preprocess/patients_mni')
corrected_patientsmni = patientsmni;
for i = 1:length(controlsmni)
    corrected_controlsmni{i}{2}(2,3) = controlsmni{i}{2}(2,3) - 5;
    corrected_controlsmni{i}{2}(3,3) = controlsmni{i}{2}(3,3) - 5;
end
save('/imaging/tc02/vespa/preprocess/controls_mni','controlsmni','corrected_controlsmni')

load('/imaging/tc02/vespa/preprocess/patients_mni')
corrected_patientsmni = patientsmni;
for i = 1:length(patientsmni)
    corrected_patientsmni{i}{2}(2,3) = patientsmni{i}{2}(2,3) - 5;
    corrected_patientsmni{i}{2}(3,3) = patientsmni{i}{2}(3,3) - 5;
end
save('/imaging/tc02/vespa/preprocess/patients_mni','patientsmni','corrected_patientsmni')