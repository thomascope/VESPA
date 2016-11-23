%A scratchpad to think about modelling decision data.
% 
% % Simple linear model
% matchcongruence = 1;
% neutralcongruence = -0.2;
% mismatchcongruence = -0.5;
% numchans = [4,8,16,20,24];
% 
% sensoryinformation = numchans/40;
% 
% predictionweightingsrange = (0:0.1:1);
% 
% ratingsgraphs = tight_subplot(round(sqrt(length(predictionweightingsrange))),ceil(sqrt(length(predictionweightingsrange))),[0 0],[.05 .1],[.05 .05]);
% for i = 1:length(predictionweightingsrange)
%     axes(ratingsgraphs(i));
%     matchratings=predictionweightingsrange(i)*matchcongruence+(1-predictionweightingsrange(i))*sensoryinformation;
%     mismatchratings=predictionweightingsrange(i)*mismatchcongruence+(1-predictionweightingsrange(i))*sensoryinformation;
%     neutralratings=0*neutralcongruence+(1)*sensoryinformation;
%     plot(numchans,matchratings)
%     hold on
%     plot(numchans,mismatchratings)
%     plot(numchans,neutralratings)
% end
    
% Model as sum of normal distributions

predictionweightingsrange = (0.01:0.0995:1);

% mu_pred1 = 10;
% mu_pred2 = 15;
% mu_pred3 = 40;
% 
% sigma_pred1 = 3;
% sigma_pred2 = 10;
% sigma_pred3 = 15;
% 
% weight_pred1 = 0.4;
% % weight_pred2 = 0.2;
% % weight_pred3 = 0.4;
% 
% predictionsgraphs = tight_subplot(round(sqrt(length(predictionweightingsrange))),ceil(sqrt(length(predictionweightingsrange))),[0 0],[.05 .1],[.05 .05]);
% figure
% for i = 1:length(predictionweightingsrange)
%     axes(predictionsgraphs(i));
%     weight_pred2 = predictionweightingsrange(i);
%     weight_pred3 = 1- predictionweightingsrange(i);
% %     pred1 = @(x) weight_pred1.*((1/(sigma_pred1*sqrt(2*pi)))*exp(-(x-mu_pred1).^2./(2*sigma_pred1^2)));
%     pred2 = @(x) weight_pred2.*((1/(sigma_pred2*sqrt(2*pi)))*exp(-(x-mu_pred2).^2./(2*sigma_pred2^2)));
%     pred3 = @(x) weight_pred3.*((1/(sigma_pred3*sqrt(2*pi)))*exp(-(x-mu_pred3).^2./(2*sigma_pred3^2)));
% 
% %     predtotal = @(x) (pred1(x)+pred2(x)+pred3(x));
%     predtotal = @(x) (pred2(x)+pred3(x));
% %     fplot(pred1,[min([mu_pred1, mu_pred2, mu_pred3])-3*max([sigma_pred1,sigma_pred2,sigma_pred3]), max([mu_pred1, mu_pred2, mu_pred3])+3*max([sigma_pred1,sigma_pred2,sigma_pred3])]);
%     hold on
%     fplot(pred2,[min([mu_pred1, mu_pred2, mu_pred3])-3*max([sigma_pred1,sigma_pred2,sigma_pred3]), max([mu_pred1, mu_pred2, mu_pred3])+3*max([sigma_pred1,sigma_pred2,sigma_pred3])]);
%     fplot(pred3,[min([mu_pred1, mu_pred2, mu_pred3])-3*max([sigma_pred1,sigma_pred2,sigma_pred3]), max([mu_pred1, mu_pred2, mu_pred3])+3*max([sigma_pred1,sigma_pred2,sigma_pred3])]);
%     fplot(predtotal,[min([mu_pred1, mu_pred2, mu_pred3])-3*max([sigma_pred1,sigma_pred2,sigma_pred3]), max([mu_pred1, mu_pred2, mu_pred3])+3*max([sigma_pred1,sigma_pred2,sigma_pred3])],'r');
% end

mu_pred2 = 15;
mu_pred3 = 40;

all_sigmas_pred2 = 5./predictionweightingsrange;
all_sigmas_pred3 = 10*ones(1,length(all_sigmas_pred2));

predictionsgraphs = tight_subplot(round(sqrt(length(predictionweightingsrange))),ceil(sqrt(length(predictionweightingsrange))),[0 0],[.05 .1],[.05 .05]);
figure
for i = 1:length(predictionweightingsrange)
    axes(predictionsgraphs(i));
    sigma_pred2 = all_sigmas_pred2(i);
    sigma_pred3 = all_sigmas_pred3(i);
    weight_pred3 = 1- predictionweightingsrange(i);
    pred2 = @(x) ((1/(sigma_pred2*sqrt(2*pi)))*exp(-(x-mu_pred2).^2./(2*sigma_pred2^2)));
    pred3 = @(x) ((1/(sigma_pred3*sqrt(2*pi)))*exp(-(x-mu_pred3).^2./(2*sigma_pred3^2)));

    mu_pred_ovr = (sigma_pred2/(sigma_pred2+sigma_pred3))*mu_pred3 + (sigma_pred3/(sigma_pred2+sigma_pred3))*mu_pred2;
    sigma_pred_ovr = (1/sigma_pred2 + 1/sigma_pred3)^-1;
    
    predtotal = @(x) ((1/(sigma_pred_ovr*sqrt(2*pi)))*exp(-(x-mu_pred_ovr).^2./(2*sigma_pred_ovr^2)));

%     fplot(pred1,[min([mu_pred1, mu_pred2, mu_pred3])-3*max([sigma_pred1,sigma_pred2,sigma_pred3]), max([mu_pred1, mu_pred2, mu_pred3])+3*max([sigma_pred1,sigma_pred2,sigma_pred3])]);
    hold on
    fplot(pred2,[min([mu_pred2, mu_pred3])-3*abs(mu_pred2-mu_pred3),max([mu_pred2, mu_pred3])+3*abs(mu_pred2-mu_pred3)]);
    fplot(pred3,[min([mu_pred2, mu_pred3])-3*abs(mu_pred2-mu_pred3),max([mu_pred2, mu_pred3])+3*abs(mu_pred2-mu_pred3)]);
    fplot(predtotal,[min([mu_pred2, mu_pred3])-3*abs(mu_pred2-mu_pred3),max([mu_pred2, mu_pred3])+3*abs(mu_pred2-mu_pred3)],'r');
%     set(gca,'Ylim', [0 0.05])
    set(gca,'XTickLabelMode','auto','YTickLabelMode','auto')
%     set(gca,'Xlim', [0 7], 'Ytick', [-110:10:20], 'Ylim', [-110 20],'LineWidth', 2, 'Xtick', [1 2 3 4 5 6], 'XTickLabel',[250, 500, 1000, 2000, 4000, 8000],'Fontsize',[14],'FontName','Tahoma')
end


% 
% %Multivariate normal distributions
% 
% mu = [0 0];
% Sigma = [.25 .3; .3 .35];
% x1 = -3:.2:3; x2 = -3:.2:3;
% [X1,X2] = meshgrid(x1,x2);
% F = mvnpdf([X1(:) X2(:)],mu,Sigma);
% F = reshape(F,length(x2),length(x1));
% surf(x1,x2,F);
% caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
% axis([-3 3 -3 3 0 .4])
% xlabel('x1'); ylabel('x2'); zlabel('Probability Density');
