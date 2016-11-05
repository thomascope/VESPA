%First plot significant contrasts for Match-Mismatch

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-47,8],'MEGCOMB')

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-38,34],'EEG')

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-26,14],'EEG')

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-42,29],'MEGMAG')

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[42,34],'MEGMAG')

plot_betas([1:6],[-1 1 -1 1 -1 1],{'T_0017','T_0018'},22,[-38,-41],'MEGMAG')

%Then plot total activity
figure
plot_betas_nonewplot([1:6],[1 0 1 0 1 0],{'T_0017','T_0018'},22,[-47,8],'MEGCOMB',1)

plot_betas_nonewplot([1:6],[0 1 0 1 0 1],{'T_0017','T_0018'},22,[-47,8],'MEGCOMB',2)

figure
plot_betas_nonewplot([1:6],[1 0 1 0 1 0],{'T_0017','T_0018'},22,[-38,34],'EEG',1)

plot_betas_nonewplot([1:6],[0 1 0 1 0 1],{'T_0017','T_0018'},22,[-38,34],'EEG',2)

figure
plot_betas_nonewplot([1:6],[1 0 1 0 1 0],{'T_0017','T_0018'},22,[-42,29],'MEGMAG',1)

plot_betas_nonewplot([1:6],[0 1 0 1 0 1],{'T_0017','T_0018'},22,[-42,29],'MEGMAG',2)



%Now for clear minus unclear

plot_betas([1:6],[-1 -1 0 0 1 1],{'T_0019','T_0020'},22,[-47,2],'MEGCOMB',[96 96])




%Total activity
figure
plot_betas_nonewplot([1:6],[1 1 0 0 0 0],{'T_0019','T_0020'},22,[-47,2],'MEGCOMB',1)

plot_betas_nonewplot([1:6],[0 0 0 0 1 1],{'T_0019','T_0020'},22,[-47,2],'MEGCOMB',2)

figure
plot_betas_nonewplot([1:6],[1 1 0 0 0 0],{'T_0019','T_0020'},22,[38,-30],'MEGCOMB',1)

plot_betas_nonewplot([1:6],[0 0 0 0 1 1],{'T_0019','T_0020'},22,[38,-30],'MEGCOMB',2)