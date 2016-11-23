    mu_pred_ovr = (sigma_input^2/(sigma_pred^2+sigma_input^2))*mu_pred + (sigma_pred^2/(sigma_pred^2+sigma_input^2))*mu_input;
    sigma_pred_ovr = (1/sigma_pred^2 + 1/sigma_input^2)^-0.5+weightfactor*abs(mu_pred-mu_input);
Pred_total = @(x) ((1/(sigma_pred_ovr*sqrt(2*pi))));

Pred_total = @(x) ((1/(((1/sigma_pred^2 + 1/sigma_input^2)^-1+weightfactor*abs(mu_pred-mu_input))*sqrt(2*pi))));
Pred_total = @(x) ((1/(((1/x(1) + 1/sigma_input)^-1+x(2)*abs(mu_pred-mu_input))*sqrt(2*pi))));


Pred_total = @(x) ((1/(((1/x(1) + 1/sigma_input)^-1+x(2)*abs(mu_pred-mu_input))*sqrt(2*pi)))*exp(-(x-((sigma_input/(x(1)+sigma_input))*mu_pred + (x(1)/(x(1)+sigma_input))*mu_input)).^2./(2*((1/x(1) + 1/sigma_input)^-1+x(2)*abs(mu_pred-mu_input))^2)));


1/sigma_pred^2 + 1/sigma_input^2)^-1+weightfactor*abs(mu_pred-mu_input))
1/sigma_pred^2 + 1/sigma_input^2)^-1+weightfactor*abs(mu_pred-mu_input))

1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))))/max([(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))]))