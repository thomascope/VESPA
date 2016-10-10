Fs = 250;                   % Sampling frequency
T = 1/Fs;                     % Sample time
L = 103707;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(D(1,:,:),NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')