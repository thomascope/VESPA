function output = search_subfunction_control_threshold(x)

global vocode_report_4_control vocode_report_8_control vocode_report_16_control connum mu_input_match mu_input_mismatch mu_pred meansarray

    sigma_input = 100/vocode_report_4_control(connum);
    mu_input = mu_input_match;
    %mu_pred_ovr = (sigma_input^2/(x(1)^2+sigma_input^2))*mu_pred + (x(1)^2/(x(1)^2+sigma_input^2))*mu_input;
    sigma_pred_ovr = (max(0,(1-abs(mu_input - mu_pred))/x(1)^2) + 1/sigma_input^2)^-0.5; % In reality, the numerator in (1-abs(mu_input_match - mu_pred))/x(1)^2 is likely to be 1 - some function of the mean difference over the sum of the variances of prediction and sensory input, but for simplicity we assume that things are far enough apart.
    Pred_total = ((1/(sigma_pred_ovr*sqrt(2*pi))));    
    YMax_match4=Pred_total;
    
    sigma_input = 100/vocode_report_8_control(connum);
    mu_input = mu_input_match;
    mu_pred_ovr = (sigma_input^2/(x(1)^2+sigma_input^2))*mu_pred + (x(1)^2/(x(1)^2+sigma_input^2))*mu_input;
    sigma_pred_ovr = (max(0,(1-abs(mu_input - mu_pred))/x(1)^2) + 1/sigma_input^2)^-0.5;
    Pred_total = ((1/(sigma_pred_ovr*sqrt(2*pi))));    
    YMax_match8=Pred_total;
    
    sigma_input = 100/vocode_report_16_control(connum);
    mu_input = mu_input_match;
    mu_pred_ovr = (sigma_input^2/(x(1)^2+sigma_input^2))*mu_pred + (x(1)^2/(x(1)^2+sigma_input^2))*mu_input;
    sigma_pred_ovr = (max(0,(1-abs(mu_input - mu_pred))/x(1)^2) + 1/sigma_input^2)^-0.5;
    Pred_total = ((1/(sigma_pred_ovr*sqrt(2*pi))));    
    YMax_match16=Pred_total;
    
    sigma_input = 100/vocode_report_4_control(connum);
    mu_input = mu_input_mismatch;
    mu_pred_ovr = (sigma_input^2/(x(1)^2+sigma_input^2))*mu_pred + (x(1)^2/(x(1)^2+sigma_input^2))*mu_input;
    sigma_pred_ovr = (max(0,(1-abs(mu_input - mu_pred))/x(1)^2) + 1/sigma_input^2)^-0.5;
    Pred_total = ((1/(sigma_pred_ovr*sqrt(2*pi))));    
    YMax_mismatch4=Pred_total;
    
    sigma_input = 100/vocode_report_8_control(connum);
    mu_input = mu_input_mismatch;
    mu_pred_ovr = (sigma_input^2/(x(1)^2+sigma_input^2))*mu_pred + (x(1)^2/(x(1)^2+sigma_input^2))*mu_input;
    sigma_pred_ovr = (max(0,(1-abs(mu_input - mu_pred))/x(1)^2) + 1/sigma_input^2)^-0.5;
    Pred_total = ((1/(sigma_pred_ovr*sqrt(2*pi))));    
    YMax_mismatch8=Pred_total;
    
    sigma_input = 100/vocode_report_16_control(connum);
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
    minVec = min(model_meansarray(:));
    maxVec_R = max(meansarray(:));
    minVec_R = min(meansarray(:));
    
    %# normalize to 1-4 rating scale
    normalised_model_meansarray = ((model_meansarray-minVec)./(maxVec-minVec)).*3+1;
    meansarray_R = ((meansarray-minVec_R)./(maxVec_R-minVec_R)).*3+1;
    
    differences = abs(normalised_model_meansarray - meansarray_R);
    
    output = sum(differences(:));