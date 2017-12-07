%Requires at least Matlab 2015a with stats toolbox
%Get a group difference from the currently loaded SPM or a filename
%eg [h p anovatbl] = groupdifference_here(SPM,[-56 -34 12], 11, 9) For
%STG significant region or 
% [h p anovatbl] = groupdifference_here(filename,[-50 12 20], 11, 9) for
% IFG significant region inputting current SPM or the path to SPM
% For nature comms stats navigate to :
%And run:
%timewins = {'90_150','200_280','290_440','450_700','710_860'}
% for i = 1:5
% [h p anovatbl] = groupdifference_here(['./' timewins{i} '/SPM.mat'],[-56 -34 12], 11, 9)
%pause
% [h p anovatbl] = groupdifference_here(['./' timewins{i} '/SPM.mat'],[-46 2 28], 11, 9)
%pause
% end

function [h,p,anovatbl] = groupdifference_here(SPM, location, ngroup1, ngroup2)

if strcmp(class(SPM),'char');
    load(SPM);
end
[x_this,y_this,z_this]= get_3d_location(location);
y=spm_get_data(SPM.xY.VY,[x_this y_this z_this]');
dat{1} = y(1:ngroup1*6);
dat{2} = y([1:ngroup2*6] + ngroup1*6);
group1data = reshape(dat{1},ngroup1,6)
group2data = reshape(dat{2},ngroup2,6)
m{1} = mean(group1data,2);
m{2} = mean(group2data,2);
m{:}
[h,p]=ttest2(m{1},m{2},'vartype','unequal');

data = array2table([[ones(ngroup1,1); 2*ones(ngroup2,1)],[group1data;group2data]],'VariableNames',{'Group','MisMatch4','Match4','MisMatch8','Match8','MisMatch16','Match16'});
congruent = {'Mismatch', 'Match','Mismatch', 'Match','Mismatch', 'Match'};
clarity = {'4','4','8','8','16','16'};
withinfactors = table(clarity',congruent','VariableNames',{'Clarity','Congruency'});
rm = fitrm(data,'MisMatch4-Match16 ~ Group','WithinDesign',withinfactors);
anovatbl = ranova(rm,'WithinModel','Clarity*Congruency');
thisfig = figure;
%Extract MM-M contrast
group1datacongruency = [mean(group1data(:,2:2:6),2),mean(group1data(:,1:2:6),2)];
group2datacongruency = [mean(group2data(:,2:2:6),2),mean(group2data(:,1:2:6),2)];
errorbar([0.855,1.145,1.855,2.145],[mean(group1datacongruency),mean(group2datacongruency)],[std(group1datacongruency)./sqrt(size(group1datacongruency,1)),std(group2datacongruency)./sqrt(size(group1datacongruency,2))],'k.');
currentylim = ylim;
b = bar([mean(group1datacongruency);mean(group2datacongruency)]);
hold on
ylim(currentylim);
errorbar([0.855,1.145,1.855,2.145],[mean(group1datacongruency),mean(group2datacongruency)],[std(group1datacongruency)./sqrt(size(group1datacongruency,1)),std(group2datacongruency)./sqrt(size(group1datacongruency,2))],'k.');
%legend({'Congruent','Incongruent'},'Location','NorthWest')
b(2).FaceColor = [200,55,55]/255;
b(1).FaceColor = [0 0 125]/255;
ylabel('A.U.')
set(gca,'xticklabel',({'Controls','nfvPPA'}))
set(gca, 'Color', 'None')
set(gca, 'box', 'off')

%ylim([currentylim(1),currentylim(1)+(1.5*(currentylim(2)-currentylim(1)))]);

if anovatbl{'Group:Congruency','pValue'} < 0.05
    tc_sigstar({[1,2]},anovatbl{'Group:Congruency','pValue'},0.145,1)
end


if anovatbl{'Group','pValue'} < 0.05
    tc_sigstar({[1,2]},anovatbl{'Group','pValue'},0.145,0)
end

%pause




