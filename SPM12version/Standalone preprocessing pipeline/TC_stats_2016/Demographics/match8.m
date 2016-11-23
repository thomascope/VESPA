    sigma_input = 100/vocode_report_8_patient(patnum);
    mu_input = mu_input_match;
    hold on
    Prior_function = @(x) ((1/(sigma_pred*sqrt(2*pi)))*exp(-(x-mu_pred).^2./(2*sigma_pred^2)));
    Input_function = @(x) ((1/(sigma_input*sqrt(2*pi)))*exp(-(x-mu_input).^2./(2*sigma_input^2)));
    mu_pred_ovr = (sigma_input^2/(sigma_pred^2+sigma_input^2))*mu_pred + (sigma_pred^2/(sigma_pred^2+sigma_input^2))*mu_input;
    sigma_pred_ovr = (1/sigma_pred^2 + 1/sigma_input^2)^-0.5+weightfactor*abs(mu_pred-mu_input);
    Pred_total = @(x) ((1/(sigma_pred_ovr*sqrt(2*pi)))*exp(-(x-mu_pred_ovr).^2./(2*sigma_pred_ovr^2)));
    fplot(Prior_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'k');
    fplot(Input_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)]);
    fplot(Pred_total,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'r');
    YMax_match8=max(Pred_total([min([mu_pred, mu_input])-2*abs(mu_pred):0.1:max([mu_pred, mu_input])+2*abs(mu_pred)]));
    set(gca,'Ylim', [0 YMax_match16]);
    set(gca,'XTickLabelMode','auto','YTickLabelMode','auto')