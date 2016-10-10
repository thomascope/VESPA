controldata = csvread('Controls.csv')
%patientdata = csvread('Patients.csv')
patientdata = csvread('Patientsfull.csv')
[num_data headings] = xlsread('Headings.csv');
for i = 1:length(num_data) % Assumes that headings ends with audiogram frequencies
    headings{end+1} = num2str(num_data(i));
end
clear num_data i
BDAEfigure = figure;
moveint = 0.03; % to ensure that overlapping values are displayed
patientdataforplot(:,:) = patientdata(:,:)-moveint*0.5*size(patientdata,1);
for i = 1:size(patientdata,1)
    patientdataforplot(i,:)= patientdataforplot(i,:)+moveint*i;
end
hold on
for i = 1:size(patientdata,1)
    if patientdata(i,20) == 1
        plot(patientdataforplot(i,14:19),'r','LineWidth',3)        
    elseif patientdata(i,20) == 2
        plot(patientdataforplot(i,14:19),'m','LineWidth',3)        
    elseif patientdata(i,20) == 3
        plot(patientdataforplot(i,14:19),'y','LineWidth',3)
    elseif patientdata(i,20) == 4
        plot(patientdataforplot(i,14:19),'b','LineWidth',3)
    elseif patientdata(i,20) == 5
        plot(patientdataforplot(i,14:19),'g','LineWidth',3)
    end
end
% plot(patientdataforplot(:,14:20)','LineWidth',3)
set(gca,'XTick',1:1:6)
set(gca,'YTick',1:1:7)
set(gca,'YLim',[1 7])
set(gca,'XTickLabel',headings(14:20))
set(gca,'Color',[0.9 0.9 0.9]);
hold on
plot([7,7,7,7,7,4],'--k','LineWidth',4) %normal values
%plot([7,7,7,7,7,4,5],'--k','LineWidth',4) %normal values
view([90,90]) % to rotate to preferred plot orientation

%% Calculate and plot differences in Likert scales
patientlikerts=patientdata(:,29:33);
patientlikerts=patientlikerts(max(patientlikerts~=0,[],2),:); %delete zero value rows
controllikerts=controldata(:,29:33);
controllikerts=controllikerts(max(controllikerts~=0,[],2),:); %delete zero value rows
controllikertmeans = mean(controllikerts);
patientlikertmeans = mean(patientlikerts);
likertfigure = figure;
for i = 1:5
    [likertsigs(i),likertps(i)] = ttest2(patientlikerts(:,i),controllikerts(:,i),0.05,1,'unequal');
end
plot(controllikertmeans,'b','LineWidth',3)
errorbar(controllikertmeans,std(controllikerts)/sqrt(size(controllikerts,1)),'b','LineWidth',3)
hold on
plot(patientlikertmeans,'m','LineWidth',3)
errorbar(patientlikertmeans,std(patientlikerts)/sqrt(size(patientlikerts,1)),'m','LineWidth',3)
set(gca,'XTick',1:1:5)
set(gca,'YTick',0:1:10)
set(gca,'YLim',[0 10])
set(gca,'XLim',[0 6])
%set(gca,'XTickLabel',headings(29:33))
set(gca,'XTickLabel',{'Speech in quiet','Sound direction','Speech in restaurant','Station announcements','TV Volume'});
ytitle = ylabel('Difficulty');
set(ytitle,'fontsize',16)
for i = 1:5
    if likertsigs(i) == 1
        plot(i,7.5,'r*','MarkerSize',20)
    end
end
title('Likert scales','Fontsize',18)
figure
plot(patientlikerts','LineWidth',3)
set(gca,'XTick',1:1:5)
set(gca,'YTick',0:1:10)
set(gca,'YLim',[0 10])
set(gca,'XLim',[0 6])
set(gca,'XTickLabel',headings(29:33))
set(gca,'XTickLabel',{'Speech in quiet','Sound direction','Speech in restaurant','Station announcements','TV Volume'});
ytitle = ylabel('Difficulty');
set(ytitle,'fontsize',16)
title('Patient likert scales','Fontsize',18)

figure
plot(controllikerts','LineWidth',3)
set(gca,'XTick',1:1:5)
set(gca,'YTick',0:1:10)
set(gca,'YLim',[0 10])
set(gca,'XLim',[0 6])
set(gca,'XTickLabel',headings(29:33))
set(gca,'XTickLabel',{'Speech in quiet','Sound direction','Speech in restaurant','Station announcements','TV Volume'});
ytitle = ylabel('Difficulty');
set(ytitle,'fontsize',16)
title('Control likert scales','Fontsize',18)
%% Plot audiograms
figure
patientaudiograms=patientdata(:,36:45);
patientaudiograms=patientaudiograms(max(patientaudiograms~=0,[],2),:); %delete zero value rows
controlaudiograms=controldata(:,36:45);
patientaudiogramplots = tight_subplot(round(sqrt(size(patientaudiograms,1))),ceil(sqrt(size(patientaudiograms,1))),[0 0],[.05 .1],[.05 .05]);
for i = 1:size(patientaudiograms,1)
    axes(patientaudiogramplots(i));
    plot(-patientaudiograms(i,1:5), 'bx-', 'LineWidth',2,'MarkerSize',15);
    hold on
    plot(-patientaudiograms(i,6:10), 'ro-', 'LineWidth',2,'MarkerSize',15);
    grid on
    normrange=area([0 7 7 0],[-20 -20 20 20]);
    normrangeprops=get(normrange,'children');
    set(normrangeprops,'FaceAlpha',0.2); % Shades the normal range
    zeroline = line([0 7], [0 0]);
    set(zeroline, 'color', 'k', 'linestyle', '-');
    bottomline = line([0 7], [-20 -20]);
    set(bottomline, 'color', 'k', 'linestyle', '--');
    set(gca,'Xlim', [0 7], 'Ytick', [-110:10:20], 'Ylim', [-110 20],'LineWidth', 2, 'Xtick', [1 2 3 4 5 6], 'XTickLabel',[250, 500, 1000, 2000, 4000, 8000],'Fontsize',[14],'FontName','Tahoma')
    Subtitle = {['Patient ' num2str(i)]};
    text(2.5,15.5,Subtitle, 'Fontsize',[14],'FontName','Tahoma');
end
figure
controlaudiogramplots = tight_subplot(round(sqrt(size(controlaudiograms,1))),ceil(sqrt(size(controlaudiograms,1))),[0 0],[.05 .1],[.05 .05]);
for i = 1:size(controlaudiograms,1)
    axes(controlaudiogramplots(i));
    plot(-controlaudiograms(i,1:5), 'bx-', 'LineWidth',2,'MarkerSize',15);
    hold on
    plot(-controlaudiograms(i,6:10), 'ro-', 'LineWidth',2,'MarkerSize',15);
    grid on
    normrange=area([0 7 7 0],[-20 -20 20 20]);
    normrangeprops=get(normrange,'children');
    set(normrangeprops,'FaceAlpha',0.2); % Shades the normal range
    zeroline = line([0 7], [0 0]);
    set(zeroline, 'color', 'k', 'linestyle', '-');
    bottomline = line([0 7], [-20 -20]);
    set(bottomline, 'color', 'k', 'linestyle', '--');
    set(gca,'Xlim', [0 7], 'Ytick', [-110:10:20], 'Ylim', [-110 20],'LineWidth', 2, 'Xtick', [1 2 3 4 5 6], 'XTickLabel',[250, 500, 1000, 2000, 4000, 8000],'Fontsize',[14],'FontName','Tahoma')
    Subtitle = {['Control ' num2str(i)]};
    text(2.5,15.5,Subtitle, 'Fontsize',[14],'FontName','Tahoma');
end
