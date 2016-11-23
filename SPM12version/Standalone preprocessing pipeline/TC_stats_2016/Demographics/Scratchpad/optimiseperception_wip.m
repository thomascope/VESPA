function optimiseperception
%Must run 'Readdemographics.m' first to get the right inputs

global headings patientdata controldata mu_pred sigma_pred mu_input sigma_input

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
sigma_pred = 2;
% mu_input = 10;
% sigma_input = 100/vocode_report_4_patient(1);

Prior_function = @(x) ((1/(sigma_pred*sqrt(2*pi)))*exp(-(x-mu_pred).^2./(2*sigma_pred^2)));
Input_function = @(x) ((1/(sigma_input*sqrt(2*pi)))*exp(-(x-mu_input).^2./(2*sigma_input^2)));

% Prior_function = @(x) ((1/(sigma_pred*sqrt(2*pi)))*exp(-(x-mu_pred).^2./(2*sigma_pred^2)));
% Input_function = @(x) ((1/(sigma_input*sqrt(2*pi)))*exp(-(x-mu_input).^2./(2*sigma_input^2)));

% mu_pred_ovr = (sigma_pred/(sigma_pred+sigma_input))*mu_pred + (sigma_input/(sigma_pred+sigma_input))*mu_input;
% sigma_pred_ovr = (1/sigma_pred + 1/sigma_input)^-1;
% Pred_total = @(x) ((1/(sigma_pred_ovr*sqrt(2*pi)))*exp(-(x-mu_pred_ovr).^2./(2*sigma_pred_ovr^2)));

Pred_total = @(x) ((1/(((1/sigma_pred + 1/sigma_input)^-1)*sqrt(2*pi)))*exp(-(x-((sigma_pred/(sigma_pred+sigma_input))*mu_pred + (sigma_input/(sigma_pred+sigma_input))*mu_input)).^2./(2*((1/sigma_pred + 1/sigma_input)^-1)^2)));


% for patnum = 1:size(patientdata,1)
sigma_pred = 2;
for patnum = 1
    predictionsgraphs = tight_subplot(3,3,[0 0],[.05 .1],[.05 .05]);
    axes(predictionsgraphs(1));
    sigma_input = 100/vocode_report_4_patient(patnum);
    mu_input = 10;
    hold on
    fplot(Prior_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'k');
    fplot(Input_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)]);
    fplot(Pred_total,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'r');
    
    axes(predictionsgraphs(2));
    sigma_input = 100/vocode_report_8_patient(patnum);
    mu_input = 10;
    hold on
    fplot(Prior_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'k');
    fplot(Input_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)]);
    fplot(Pred_total,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'r');
    
    axes(predictionsgraphs(3));
    sigma_input = 100/vocode_report_16_patient(patnum);
    mu_input = 10;
    hold on
    fplot(Prior_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'k');
    fplot(Input_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)]);
    fplot(Pred_total,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'r');
    
    axes(predictionsgraphs(4));
    sigma_input = 100/vocode_report_4_patient(patnum);
    mu_input = 20;
    hold on
    fplot(Prior_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'k');
    fplot(Input_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)]);
    fplot(Pred_total,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'r');
    
    axes(predictionsgraphs(5));
    sigma_input = 100/vocode_report_8_patient(patnum);
    mu_input = 20;
    hold on
    fplot(Prior_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'k');
    fplot(Input_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)]);
    fplot(Pred_total,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'r');
    
    axes(predictionsgraphs(6));
    sigma_input = 100/vocode_report_16_patient(patnum);
    mu_input = 20;
    hold on
    fplot(Prior_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'k');
    fplot(Input_function,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)]);
    fplot(Pred_total,[min([mu_pred, mu_input])-2*abs(mu_pred),max([mu_pred, mu_input])+2*abs(mu_pred)],'r');
    
end
    
