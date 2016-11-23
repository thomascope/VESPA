function output = search_subfunction_patient_threshold(x)
%
% sigma_pred_ovr = (max(0,(1-abs(mu_input_match - mu_pred))/x(1)^2) + 1/sigma_input^2)^-0.5;
% mu_pred_ovr = (sigma_input^2/(x(1)^2+sigma_input^2))*mu_pred + (x(1)^2/(x(1)^2+sigma_input^2))*mu_input;
% Pred_total = ((1/(sigma_pred_ovr*sqrt(2*pi))));

% maxVec = max([(1/(((max(0,(1-abs(mu_input_match - mu_pred))/x(1)^2) + 1/(100/vocode_report_4_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((max(0,(1-abs(mu_input_match - mu_pred))/x(1)^2) + 1/(100/vocode_report_4_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((max(0,(1-abs(mu_input_match - mu_pred))/x(1)^2) + 1/(100/vocode_report_8_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((max(0,(1-abs(mu_input_match - mu_pred))/x(1)^2) + 1/(100/vocode_report_8_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((max(0,(1-abs(mu_input_match - mu_pred))/x(1)^2) + 1/(100/vocode_report_16_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((max(0,(1-abs(mu_input_match - mu_pred))/x(1)^2) + 1/(100/vocode_report_16_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))]);
% minVec = min([(1/(((max(0,(1-abs(mu_input_match - mu_pred))/x(1)^2) + 1/(100/vocode_report_4_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((max(0,(1-abs(mu_input_match - mu_pred))/x(1)^2) + 1/(100/vocode_report_4_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((max(0,(1-abs(mu_input_match - mu_pred))/x(1)^2) + 1/(100/vocode_report_8_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((max(0,(1-abs(mu_input_match - mu_pred))/x(1)^2) + 1/(100/vocode_report_8_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((max(0,(1-abs(mu_input_match - mu_pred))/x(1)^2) + 1/(100/vocode_report_16_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((max(0,(1-abs(mu_input_match - mu_pred))/x(1)^2) + 1/(100/vocode_report_16_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))]);
% search_function = @(x) (abs(denormed_meansarray(1,1)-(((1/(((1/x(1)^2) + 1/(100/vocode_report_4_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi)))-minVec)./(maxVec-minVec))+abs(denormed_meansarray(1,2)-(((1/(((1/x(1)^2) + 1/(100/vocode_report_4_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))-minVec)./(maxVec-minVec))+abs(denormed_meansarray(2,1)-(((1/(((1/x(1)^2) + 1/(100/vocode_report_8_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi)))-minVec)./(maxVec-minVec))+abs(denormed_meansarray(2,2)-(((1/(((1/x(1)^2) + 1/(100/vocode_report_8_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))-minVec)./(maxVec-minVec))+abs(denormed_meansarray(3,1)-(((1/(((1/x(1)^2) + 1/(100/vocode_report_16_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi)))-minVec)./(maxVec-minVec))+abs(denormed_meansarray(3,2)-(((1/(((1/x(1)^2) + 1/(100/vocode_report_16_patient(patnum))^2)^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))-minVec)./(maxVec-minVec)));

global vocode_report_4_patient vocode_report_8_patient vocode_report_16_patient patnum mu_input_match mu_input_mismatch mu_pred meansarray

sigma_input = 100/vocode_report_4_patient(patnum);
mu_input = mu_input_match;
%mu_pred_ovr = (sigma_input^2/(x(1)^2+sigma_input^2))*mu_pred + (x(1)^2/(x(1)^2+sigma_input^2))*mu_input;
sigma_pred_ovr = (max(0,(1-abs(mu_input - mu_pred))/x(1)^2) + 1/sigma_input^2)^-0.5;
Pred_total = ((1/(sigma_pred_ovr*sqrt(2*pi))));
YMax_match4=Pred_total;

sigma_input = 100/vocode_report_8_patient(patnum);
mu_input = mu_input_match;
mu_pred_ovr = (sigma_input^2/(x(1)^2+sigma_input^2))*mu_pred + (x(1)^2/(x(1)^2+sigma_input^2))*mu_input;
sigma_pred_ovr = (max(0,(1-abs(mu_input - mu_pred))/x(1)^2) + 1/sigma_input^2)^-0.5;
Pred_total = ((1/(sigma_pred_ovr*sqrt(2*pi))));
YMax_match8=Pred_total;

sigma_input = 100/vocode_report_16_patient(patnum);
mu_input = mu_input_match;
mu_pred_ovr = (sigma_input^2/(x(1)^2+sigma_input^2))*mu_pred + (x(1)^2/(x(1)^2+sigma_input^2))*mu_input;
sigma_pred_ovr = (max(0,(1-abs(mu_input - mu_pred))/x(1)^2) + 1/sigma_input^2)^-0.5;
Pred_total = ((1/(sigma_pred_ovr*sqrt(2*pi))));
YMax_match16=Pred_total;

sigma_input = 100/vocode_report_4_patient(patnum);
mu_input = mu_input_mismatch;
mu_pred_ovr = (sigma_input^2/(x(1)^2+sigma_input^2))*mu_pred + (x(1)^2/(x(1)^2+sigma_input^2))*mu_input;
sigma_pred_ovr = (max(0,(1-abs(mu_input - mu_pred))/x(1)^2) + 1/sigma_input^2)^-0.5;
Pred_total = ((1/(sigma_pred_ovr*sqrt(2*pi))));
YMax_mismatch4=Pred_total;

sigma_input = 100/vocode_report_8_patient(patnum);
mu_input = mu_input_mismatch;
mu_pred_ovr = (sigma_input^2/(x(1)^2+sigma_input^2))*mu_pred + (x(1)^2/(x(1)^2+sigma_input^2))*mu_input;
sigma_pred_ovr = (max(0,(1-abs(mu_input - mu_pred))/x(1)^2) + 1/sigma_input^2)^-0.5;
Pred_total = ((1/(sigma_pred_ovr*sqrt(2*pi))));
YMax_mismatch8=Pred_total;

sigma_input = 100/vocode_report_16_patient(patnum);
mu_input = mu_input_mismatch;
mu_pred_ovr = (sigma_input^2/(x(1)^2+sigma_input^2))*mu_pred + (x(1)^2/(x(1)^2+sigma_input^2))*mu_input;
sigma_pred_ovr = (max(0,(1-abs(mu_input - mu_pred))/x(1)^2) + 1/sigma_input^2)^-0.5;
Pred_total = ((1/(sigma_pred_ovr*sqrt(2*pi))));
YMax_mismatch16=Pred_total;

%Now model MEG Clarity ratings
clarity_threshold = x(2);
model_meansarray = [YMax_match4, YMax_mismatch4; YMax_match8, YMax_mismatch8; YMax_match16, YMax_mismatch16] - clarity_threshold;
model_meansarray = max(model_meansarray,0);
stesarray = zeros(size(model_meansarray)); %Dummy stes for now.
%# get max and min of meansarray
maxVec = max(model_meansarray(:));
minVec = 0;
maxVec_R = max(meansarray(:));
minVec_R = min(meansarray(:));

%# normalize to 1-4 rating scale
normalised_model_meansarray = zeros(size(model_meansarray));
for i = 1:size(model_meansarray,1)
    for j = 1:size(model_meansarray,2)
        normalised_model_meansarray(i,j) = (max((model_meansarray(i,j)-minVec),0)./(maxVec-minVec)).*3+1;
    end
end
meansarray_R = ((meansarray-minVec_R)./(maxVec_R-minVec_R)).*3+1;

differences = abs(normalised_model_meansarray - meansarray_R);

output = sum(differences(:));