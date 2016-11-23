function plotdemographiccorrs(indepvar,depvar)
%plot scatter graph, with regression line, p value and rsquared
% Takes either an numerical index from headings, or a heading title string
global headings patientdata controldata

depvardescription = {};
indepvardescription = {};
if isnumeric(depvar)
    if size(depvar,1)==1
        depvardescription{1} = headings{depvar};
    else        
        for i = 1:size(depvar,1)
            depvardescription{end+1} = headings{depvar(i)};
        end
    end
else
    depvardescription = {depvar};
    depvar = find(strcmp(headings,depvardescription{1}));
end
if isnumeric(indepvar)
    if size(indepvar,1)==1
        indepvardescription{1} = headings{indepvar};
    else        
        for i = 1:size(indepvar,1)
            indepvardescription{end+1} = headings{indepvar(i)};
        end
    end
else
    indepvardescription = {indepvar};
    indepvar = find(strcmp(headings,indepvardescription{1}));
end

for i = 1:size(indepvar,1)
    [RHO,PVAL] = corr(patientdata(:,depvar(i)),patientdata(:,indepvar(i)));
    Rsquared = RHO^2;
    figure
    set(gcf,'Units','normalized');
    set(gcf,'Position',[0.2 0.2 0.6 0.6]);
    scatterplot = scatter(patientdata(:,indepvar(i)),patientdata(:,depvar(i)));
    lsline
    xlabel(indepvardescription{i})
    ylabel(depvardescription{i})
    title(['A plot for patients of ' depvardescription{i} ' against ' indepvardescription{i} '. Rsquared ' num2str(Rsquared,3) ', P = ' num2str(PVAL,3)]);
    
    
    [RHO,PVAL] = corr(controldata(:,depvar(i)),controldata(:,indepvar(i)));
    Rsquared = RHO^2;
    
    if isnan(PVAL)
    else
        figure
        set(gcf,'Units','normalized');
        set(gcf,'Position',[0.2 0.2 0.6 0.6]);
        scatterplot = scatter(controldata(:,indepvar(i)),controldata(:,depvar(i)));
        lsline
        xlabel(indepvardescription{i})
        ylabel(depvardescription{i})
        title(['A plot for controls of ' depvardescription{i} ' against ' indepvardescription{i} '. Rsquared ' num2str(Rsquared,3) ', P = ' num2str(PVAL,3)]);
    end
end