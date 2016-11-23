function optimiseperception
%Must run 'Readdemographics.m' first to get the right inputs

global headings patientdata controldata mu_pred sigma_pred mu_input sigma_input weightfactor

% Read in the clarity of input based on vocode report task
vocode_report_4_patient = patientdata(:,(~cellfun('isempty',strfind(headings,'Vocode Report 4'))));
vocode_report_8_patient = patientdata(:,(~cellfun('isempty',strfind(headings,'Vocode Report 8'))));
vocode_report_16_patient = patientdata(:,(~cellfun('isempty',strfind(headings,'Vocode Report 16'))));


vocode_report_4_control = controldata(:,(~cellfun('isempty',strfind(headings,'Vocode Report 4'))));
vocode_report_8_control = controldata(:,(~cellfun('isempty',strfind(headings,'Vocode Report 8'))));
vocode_report_16_control = controldata(:,(~cellfun('isempty',strfind(headings,'Vocode Report 16'))));

% Read in the clarity ratings from the MEG task (and neutral task, in case
% I analyse this later)

match_rating_4_chan_patient = patientdata(:,(~cellfun('isempty',strfind(headings,'MEG Match4'))));
match_rating_8_chan_patient = patientdata(:,(~cellfun('isempty',strfind(headings,'MEG Match8'))));
match_rating_16_chan_patient = patientdata(:,(~cellfun('isempty',strfind(headings,'MEG Match16'))));

mismatch_rating_4_chan_patient = patientdata(:,(~cellfun('isempty',strfind(headings,'MEG Mismatch4'))));
mismatch_rating_8_chan_patient = patientdata(:,(~cellfun('isempty',strfind(headings,'MEG Mismatch8'))));
mismatch_rating_16_chan_patient = patientdata(:,(~cellfun('isempty',strfind(headings,'MEG Mismatch16'))));

neutral_rating_4_chan_patient = patientdata(:,(~cellfun('isempty',strfind(headings,'MEG Neutral4'))));
neutral_rating_8_chan_patient = patientdata(:,(~cellfun('isempty',strfind(headings,'MEG Neutral8'))));
neutral_rating_16_chan_patient = patientdata(:,(~cellfun('isempty',strfind(headings,'MEG Neutral16'))));


match_rating_4_chan_control = controldata(:,(~cellfun('isempty',strfind(headings,'MEG Match4'))));
match_rating_8_chan_control = controldata(:,(~cellfun('isempty',strfind(headings,'MEG Match8'))));
match_rating_16_chan_control = controldata(:,(~cellfun('isempty',strfind(headings,'MEG Match16'))));

mismatch_rating_4_chan_control = controldata(:,(~cellfun('isempty',strfind(headings,'MEG Mismatch4'))));
mismatch_rating_8_chan_control = controldata(:,(~cellfun('isempty',strfind(headings,'MEG Mismatch8'))));
mismatch_rating_16_chan_control = controldata(:,(~cellfun('isempty',strfind(headings,'MEG Mismatch16'))));

neutral_rating_4_chan_control = controldata(:,(~cellfun('isempty',strfind(headings,'MEG Neutral4'))));
neutral_rating_8_chan_control = controldata(:,(~cellfun('isempty',strfind(headings,'MEG Neutral8'))));
neutral_rating_16_chan_control = controldata(:,(~cellfun('isempty',strfind(headings,'MEG Neutral16'))));

% Work out the priors
mu_pred = 10; %Arbitrarily place prediction and input on x-scale. When 'match', mu_input will be the same, when mismatch, mu_input will be different
% sigma_pred = 2;
% weightfactor = 0.08;

% mu_input = 10;
% sigma_input = 100/vocode_report_4_patient(1);

% Prior_function = @(x) ((1/(sigma_pred*sqrt(2*pi)))*exp(-(x-mu_pred).^2./(2*sigma_pred^2)));
% Input_function = @(x) ((1/(sigma_input*sqrt(2*pi)))*exp(-(x-mu_input).^2./(2*sigma_input^2)));

% Prior_function = @(x) ((1/(sigma_pred*sqrt(2*pi)))*exp(-(x-mu_pred).^2./(2*sigma_pred^2)));
% Input_function = @(x) ((1/(sigma_input*sqrt(2*pi)))*exp(-(x-mu_input).^2./(2*sigma_input^2)));

% mu_pred_ovr = (sigma_input/(sigma_pred+sigma_input))*mu_pred + (sigma_pred/(sigma_pred+sigma_input))*mu_input;
% sigma_pred_ovr = (1/sigma_pred + 1/sigma_input)^-1+abs(mu_pred-mu_input);
% Pred_total = @(x) ((1/(sigma_pred_ovr*sqrt(2*pi)))*exp(-(x-mu_pred_ovr).^2./(2*sigma_pred_ovr^2)));
%
% Pred_total = @(x) ((1/(((1/sigma_pred + 1/sigma_input)^-1)*sqrt(2*pi)))*exp(-(x-((sigma_input/(sigma_pred+sigma_input))*mu_pred + (sigma_pred/(sigma_pred+sigma_input))*mu_input)).^2./(2*((1/sigma_pred + 1/sigma_input)^-1)^2)));

% for patnum = 1:size(patientdata,1)
for patnum = 11
    % First find optimal fit arguments
    meansarray = [match_rating_4_chan_patient(patnum), mismatch_rating_4_chan_patient(patnum); match_rating_8_chan_patient(patnum), mismatch_rating_8_chan_patient(patnum); match_rating_16_chan_patient(patnum), mismatch_rating_16_chan_patient(patnum)];
    denormed_meansarray = (meansarray-1)./3; %De-normalise
    mu_input_match = 10;
    mu_input_mismatch = 20;
    %search_function = @(x) (abs(denormed_meansarray(1,1)-((1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi)))))+abs(denormed_meansarray(1,2)-((1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))))+abs(denormed_meansarray(2,1)-((1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi)))))+abs(denormed_meansarray(2,2)-((1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))))+abs(denormed_meansarray(3,1)-((1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi)))))+abs(denormed_meansarray(3,2)-((1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))))));
    %max([(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))])
    search_function = @(x) abs(denormed_meansarray(1,1)-(((1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))))/max([(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))]))+abs(denormed_meansarray(1,2)-(((1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))))/max([(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))]))+abs(denormed_meansarray(2,1)-(((1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))))/max([(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))]))+abs(denormed_meansarray(2,2)-(((1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))))/max([(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))]))+abs(denormed_meansarray(3,1)-(((1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))))/max([(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))]))+abs(denormed_meansarray(3,2)-(((1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))))/max([(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_4_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_8_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_match))*sqrt(2*pi))),(1/(((1/x(1) + 1/(100/vocode_report_16_patient(patnum)))^-1+x(2)*abs(mu_pred-mu_input_mismatch))*sqrt(2*pi)))]))))))));
    [model_arguments, fval] = fminsearch(search_function,[2,0]);
    sigma_pred = model_arguments(1);
    weightfactor = model_arguments(2);

    
    %Then plot the graphs to inspect the data (I know that the code is
    %unnecessarily repetitive and verbose)
    figure
    predictionsgraphs = tight_subplot(3,3,[0 0],[.05 .1],[.05 .05]);
    
    axes(predictionsgraphs(3)); % DO this one first to define YMax
    sigma_input = 100/vocode_report_16_patient(patnum);
    mu_input = mu_input_match;
    hold on
    Prior_function = @(x) ((1/(sigma_pred*sqrt(2*pi)))*exp(-(x-mu_pred).^2./(2*sigma_pred^2)));
    Input_function = @(x) ((1/(sigma_input*sqrt(2*pi)))*exp(-(x-mu_input).^2./(2*sigma_input^2)));
    %     Pred_total = @(x) ((1/(((1/sigma_pred + 1/sigma_input)^-1)*sqrt(2*pi)))*exp(-(x-((sigma_input/(sigma_pred+sigma_input))*mu_pred + (sigma_pred/(sigma_pred+sigma_input))*mu_input)).^2./(2*((1/sigma_pred + 1/sigma_input)^-1)^2)));
    mu_pred_ovr = (sigma_input/(sigma_pred+sigma_input))*mu_pred + (sigma_pred/(sigma_pred+sigma_input))*mu_input;
    sigma_pred_ovr = (1/sigma_pred + 1/sigma_input)^-1+weightfactor*abs(mu_pred-mu_input);
    Pred_total = @(x) ((1/(sigma_pred_ovr*sqrt(2*pi)))*exp(-(x-mu_pred_ovr).^2./(2*sigma_pred_ovr^2)));
    
    fplot(Prior_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'k');
    fplot(Input_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)]);
    fplot(Pred_total,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'r');
    YMax_match16=max(Pred_total([min([mu_pred, mu_input])-2*abs(mu_pred):0.1:max([mu_pred, mu_input])+2*abs(mu_pred)]));
    set(gca,'Ylim', [0 YMax_match16]);
    set(gca,'XTickLabelMode','auto','YTickLabelMode','auto')
    
    axes(predictionsgraphs(1));
    sigma_input = 100/vocode_report_4_patient(patnum);
    mu_input = mu_input_match;
    hold on
    Prior_function = @(x) ((1/(sigma_pred*sqrt(2*pi)))*exp(-(x-mu_pred).^2./(2*sigma_pred^2)));
    Input_function = @(x) ((1/(sigma_input*sqrt(2*pi)))*exp(-(x-mu_input).^2./(2*sigma_input^2)));
    mu_pred_ovr = (sigma_input/(sigma_pred+sigma_input))*mu_pred + (sigma_pred/(sigma_pred+sigma_input))*mu_input;     sigma_pred_ovr = (1/sigma_pred + 1/sigma_input)^-1+weightfactor*abs(mu_pred-mu_input);     Pred_total = @(x) ((1/(sigma_pred_ovr*sqrt(2*pi)))*exp(-(x-mu_pred_ovr).^2./(2*sigma_pred_ovr^2)));
    fplot(Prior_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'k');
    fplot(Input_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)]);
    fplot(Pred_total,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'r');
    YMax_match4=max(Pred_total([min([mu_pred, mu_input])-2*abs(mu_pred):0.1:max([mu_pred, mu_input])+2*abs(mu_pred)]));
    set(gca,'Ylim', [0 YMax_match16]);
    set(gca,'XTickLabelMode','auto','YTickLabelMode','auto')
    
    axes(predictionsgraphs(2));
    sigma_input = 100/vocode_report_8_patient(patnum);
    mu_input = mu_input_match;
    hold on
    Prior_function = @(x) ((1/(sigma_pred*sqrt(2*pi)))*exp(-(x-mu_pred).^2./(2*sigma_pred^2)));
    Input_function = @(x) ((1/(sigma_input*sqrt(2*pi)))*exp(-(x-mu_input).^2./(2*sigma_input^2)));
    mu_pred_ovr = (sigma_input/(sigma_pred+sigma_input))*mu_pred + (sigma_pred/(sigma_pred+sigma_input))*mu_input;     sigma_pred_ovr = (1/sigma_pred + 1/sigma_input)^-1+weightfactor*abs(mu_pred-mu_input);     Pred_total = @(x) ((1/(sigma_pred_ovr*sqrt(2*pi)))*exp(-(x-mu_pred_ovr).^2./(2*sigma_pred_ovr^2)));
    fplot(Prior_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'k');
    fplot(Input_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)]);
    fplot(Pred_total,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'r');
    YMax_match8=max(Pred_total([min([mu_pred, mu_input])-2*abs(mu_pred):0.1:max([mu_pred, mu_input])+2*abs(mu_pred)]));
    set(gca,'Ylim', [0 YMax_match16]);
    set(gca,'XTickLabelMode','auto','YTickLabelMode','auto')
    
    
    axes(predictionsgraphs(4));
    sigma_input = 100/vocode_report_4_patient(patnum);
    mu_input = mu_input_mismatch;
    hold on
    Prior_function = @(x) ((1/(sigma_pred*sqrt(2*pi)))*exp(-(x-mu_pred).^2./(2*sigma_pred^2)));
    Input_function = @(x) ((1/(sigma_input*sqrt(2*pi)))*exp(-(x-mu_input).^2./(2*sigma_input^2)));
    mu_pred_ovr = (sigma_input/(sigma_pred+sigma_input))*mu_pred + (sigma_pred/(sigma_pred+sigma_input))*mu_input;     sigma_pred_ovr = (1/sigma_pred + 1/sigma_input)^-1+weightfactor*abs(mu_pred-mu_input);     Pred_total = @(x) ((1/(sigma_pred_ovr*sqrt(2*pi)))*exp(-(x-mu_pred_ovr).^2./(2*sigma_pred_ovr^2)));
    fplot(Prior_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'k');
    fplot(Input_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)]);
    fplot(Pred_total,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'r');
    YMax_mismatch4=max(Pred_total([min([mu_pred, mu_input])-2*abs(mu_pred):0.1:max([mu_pred, mu_input])+2*abs(mu_pred)]));
    set(gca,'Ylim', [0 YMax_match16]);
    set(gca,'XTickLabelMode','auto','YTickLabelMode','auto')
    
    axes(predictionsgraphs(5));
    sigma_input = 100/vocode_report_8_patient(patnum);
    mu_input = mu_input_mismatch;
    hold on
    Prior_function = @(x) ((1/(sigma_pred*sqrt(2*pi)))*exp(-(x-mu_pred).^2./(2*sigma_pred^2)));
    Input_function = @(x) ((1/(sigma_input*sqrt(2*pi)))*exp(-(x-mu_input).^2./(2*sigma_input^2)));
    mu_pred_ovr = (sigma_input/(sigma_pred+sigma_input))*mu_pred + (sigma_pred/(sigma_pred+sigma_input))*mu_input;     sigma_pred_ovr = (1/sigma_pred + 1/sigma_input)^-1+weightfactor*abs(mu_pred-mu_input);     Pred_total = @(x) ((1/(sigma_pred_ovr*sqrt(2*pi)))*exp(-(x-mu_pred_ovr).^2./(2*sigma_pred_ovr^2)));
    fplot(Prior_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'k');
    fplot(Input_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)]);
    fplot(Pred_total,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'r');
    YMax_mismatch8=max(Pred_total([min([mu_pred, mu_input])-2*abs(mu_pred):0.1:max([mu_pred, mu_input])+2*abs(mu_pred)]));
    set(gca,'Ylim', [0 YMax_match16]);
    set(gca,'XTickLabelMode','auto','YTickLabelMode','auto')
    
    axes(predictionsgraphs(6));
    sigma_input = 100/vocode_report_16_patient(patnum);
    mu_input = mu_input_mismatch;
    hold on
    Prior_function = @(x) ((1/(sigma_pred*sqrt(2*pi)))*exp(-(x-mu_pred).^2./(2*sigma_pred^2)));
    Input_function = @(x) ((1/(sigma_input*sqrt(2*pi)))*exp(-(x-mu_input).^2./(2*sigma_input^2)));
    mu_pred_ovr = (sigma_input/(sigma_pred+sigma_input))*mu_pred + (sigma_pred/(sigma_pred+sigma_input))*mu_input;     sigma_pred_ovr = (1/sigma_pred + 1/sigma_input)^-1+weightfactor*abs(mu_pred-mu_input);     Pred_total = @(x) ((1/(sigma_pred_ovr*sqrt(2*pi)))*exp(-(x-mu_pred_ovr).^2./(2*sigma_pred_ovr^2)));
    fplot(Prior_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'k');
    fplot(Input_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)]);
    fplot(Pred_total,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'r');
    YMax_mismatch16=max(Pred_total([min([mu_pred, mu_input])-2*abs(mu_pred):0.1:max([mu_pred, mu_input])+2*abs(mu_pred)]));
    set(gca,'Ylim', [0 YMax_match16]);
    set(gca,'XTickLabelMode','auto','YTickLabelMode','auto')
    
    
    
    %Now model MEG Clarity ratings
    clarity_threshold = YMax_mismatch4;
    model_meansarray = [YMax_match4, YMax_mismatch4; YMax_match8, YMax_mismatch8; YMax_match16, YMax_mismatch16] - clarity_threshold;
    stesarray = zeros(size(model_meansarray)); %Dummy stes for now.
    %# get max and min of meansarray
    maxVec = max(model_meansarray(:));
    minVec = min(model_meansarray(:));
    
    %# normalize to 1-4 rating scale
    normalised_model_meansarray = ((model_meansarray-minVec)./(maxVec-minVec)).*3+1;
    
    %Plot figure
    %     figure
    %     set(gcf,'position',[100,100,1200,800])
    %     barweb(normalised_model_meansarray,stesarray,[],{'4 channels';'8 channels';'16 channels'},['Modelled Clarity Ratings by Prime Type and Vocoder Channels for Patient VP' num2str(patnum)],[],'Mean Clarity Rating',[],[],{'Match','Mismatch'}) ;
    %     legend('Match','Mismatch','location','NorthWest');
    %     set(gca,'ylim',[1,4]);
    
    %Plot real MEG Clarity ratings for comparison
%     meansarray = [match_rating_4_chan_patient(patnum), mismatch_rating_4_chan_patient(patnum); match_rating_8_chan_patient(patnum), mismatch_rating_8_chan_patient(patnum); match_rating_16_chan_patient(patnum), mismatch_rating_16_chan_patient(patnum)];
    %     figure
    %     set(gcf,'position',[100,100,1200,800])
    %     barweb(meansarray,stesarray,[],{'4 channels';'8 channels';'16 channels'},['Actual Clarity Ratings by Prime Type and Vocoder Channels for Patient VP' num2str(patnum)],[],'Mean Clarity Rating',[],[],{'Match','Mismatch'}) ;
    %     legend('Match','Mismatch','location','NorthWest');
    %     set(gca,'ylim',[1,4]);
    
    %Plot figure for comparison
    all_meansarray = [normalised_model_meansarray,meansarray];
    stesarray = zeros(size(all_meansarray)); %Dummy stes for now.
    %     figure
    %     set(gcf,'position',[100,100,1200,800])
    %     barweb(all_meansarray,stesarray,[],{'4 channels';'8 channels';'16 channels'},['Compared Clarity Ratings by Prime Type and Vocoder Channels for Patient VP' num2str(patnum)],[],'Mean Clarity Rating',[],[],{'Model_Match','Model_Mismatch','Actual_Match','Actual_Mismatch'}) ;
    %     legend('Model Match','Model Mismatch','Actual Match','Actual Mismatch','location','NorthWest');
    %     set(gca,'ylim',[1,4]);
    
    axes(predictionsgraphs(7));
%     barweb(all_meansarray,stesarray,[],{'4 channels';'8 channels';'16 channels'},['Compared Clarity Ratings by Prime Type and Vocoder Channels for Patient VP' num2str(patnum)],[],'Mean Clarity Rating',[],[],{'Model_Match','Model_Mismatch','Actual_Match','Actual_Mismatch'}) ;
    barweb(all_meansarray,stesarray,[],{'4 channels';'8 channels';'16 channels'},['Compared Clarity Ratings by Prime Type and Vocoder Channels for Patient VP' num2str(patnum)],[],'Mean Clarity Rating',[],[],{}) ;
    %legend('Model Match','Model Mismatch','Actual Match','Actual Mismatch','location','NorthWest');
    set(gca,'ylim',[1,4]);
end

