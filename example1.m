% parameters and variables
Fs = 100; % we will construct a signal sampled at 100 Hz (samples/second)
L = 512; % we will have 512 samples of the signal
f1 = 20; % the signal will consist of sinusoids with 20 Hz and 7 Hz
f2 = 7;
t = (0:L-1) * (1/Fs);  % the time interval of the signal
f = ((0:(L-1))/L) * Fs; % the frequencies of the signal
half = (1:(L/2));  % half of the interval for plotting the spectra

% now we construct a sinusoidal signal sampled at 100 Hz
x1 = cos(2*pi*f1*t);  % 20 Hz sinusoid
x2 = cos(2*pi*f2*t); % 7 Hz sinusoid
% now we calculate the sum of both signals (for a smaller part of the signal)
y = x1 + x2;

% we shall plot only the first 64 samples of the signal (1 second) of all three signals
part=1:64;
figure; plot(t(part),x1(part)); title('x1');
figure; plot(t(part),x2(part)); title('x2');
figure; plot(t(part),y(part)); title('y=x1+x2');

% we shall calculate the Fourier transform of the combined signal
Y = fft(y); % we calculate the sum of the combined signal

% and plot the real part, imaginary part, and the amplitude, phase, and power spectrum
figure; plot(f,real(Y)); title('real(Y)');
figure; plot(f,imag(Y)); title('imag(Y)'); 
figure; plot(f,abs(Y)); title('abs(Y)');
figure; plot(f,angle(Y)); title('angle(Y)');
figure; plot(f,1/L*abs(Y./L).^2); title('Power spectrum');
% plot(f,1/L*Y.*conj(Y));

pause
