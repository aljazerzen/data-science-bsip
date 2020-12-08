pkg load signal
clear all;
close all;

a = [1 0 0 0 -1];
b = [1 -1];
figure; zplane(b,a);
pause

clear all;
[x,y] = meshgrid([-1:0.01:1]);
z = x+j*y;
H = (1 - z.^4) ./ (1 - z);
figure; surf(x,y,abs(H));

figure; 
% limit maximum value of the scale to 3.0
imagesc(x(1,:),y(:,1),abs(H),[0,3]); hold on;
xlabel('real'); ylabel('imag'); title('|H(z)|');
colormap('hot'); colorbar;

% and plot a black circle with r=1
x=[-1:.01:1]; y=[sqrt(1-x.^2);-sqrt(1-x.^2)];
plot(x,y,'k'); axis square;

%{
h = @(z) 1/(1+1/6*z^-1-1/18*z^-2);
x = -1:0.01:1;
y = (-1:0.01:1);

for n = 1:length(y)
    for m = 1:length(x)
        H(n,m)=h( x(m) + j*y(n) );
    end
end

Ha = abs(H);
figure; surf(x,y,Ha,gradient(Ha));
% add labels to axis
xlabel('Real');
ylabel('Imaginary');
zlabel('Amplitude');
%}