
load('s20011m_ucil.mat')

sig1 = val(1, :);
sig2 = val(2, :);




Fs = 100; % we will construct a signal sampled at 100 Hz (samples/second)
L = 1250; % we will have 512 samples of the signal
f = ((0:(L-1))/L) * Fs; % the frequencies of the signal

showSpecs(sig1, 250);

pause