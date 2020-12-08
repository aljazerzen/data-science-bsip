function Y = showSpecsN(signal, n)

  f = (((0:n-1))/n); 
  
  % Fourier transform
  Y = fft(signal, n);

  half = (1:n/2);
  
%  figure; % real part of Fourier transform 
%  plot(f,real(Y));
  
%  figure; % complex part of Fourier transform
%  plot(f,imag(Y));
  
 % amplitude spectrum
 figure('position', [100 100 800 600]);
 subplot(2, 2, 1);
 plot(f(half), abs(Y(half))); 
 title('amplitude spectrum');
 
 % power spectrum
 subplot(2, 2, 2);
 plot(f(half), (1/n)*(abs(Y(half))./n).^2);
 title('power spectrum');

 % phase spectrum
 subplot(2, 2, 3);
 plot(f(half), angle(Y(half)));
 title('phase spectrum');
 
end





