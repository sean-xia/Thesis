% Spectral Subtraction Test

% This program is a simple example of how to use Spectral Subtraction of
% power spectral density (or PSD)in order to remove a signal from the 
% frequency domain

F1 = 50;     %Frequency for the desired signal
T = 1/F1;      %period
t = -10:T:10;   %time

% x1 is the desired signal
x1 = abs(30*sinc(2*pi*t).*exp(1i*pi*t));

% x2 is the interferance
x2 = abs(30*sinc(2*pi*t).*cos(t*35).*exp(1i*pi*t));

% y is the sum of all the signals
y = awgn(x1+x2,.1);

% Added white gausian noise
% y = awgn(sum,.2);

figure(1)
plot(abs(fft(x1)),'r');
hold on
D = abs(fft(y)-fft(x2));
plot(D,'b');




% 
% 
% 
% % PSD Representations Using pwelch
% % psdY is the PSD equation of the interfered with signals x1 and x2 and 
% % psdX2 is the PSD equation of the interfering signal
% % psdX1 is the PSD equation of the original signal
% psdY = pwelch(y,[],[],[],F1,'twosided');
% psdX2 = pwelch(x2,[],[],[],F1,'twosided');
% psdXorg = pwelch(x1,[],[],[],F1,'twosided');
% 
% % Here the subraction of the unwanted signal, X2, takes
% % place 
% % The reslting psdZ is the PSD of the subtraceted represetnation of x1
% psdZ = psdY-psdX2;
% 
% % Time Domain Pepresentations of PSD Signals
% % x1rec is the time domain representation of the recieved subtracted
% % signal
% % x1org is the original signal modeled in the same way as the recieved
% % signal
% x1rec = ifft(sqrt(psdZ));
% x1org = ifft(sqrt(psdXorg));
% 
% % This graph shows the frequency domain represtentations of the original 
% % signal in red, the interfered with signal in green and the subtracted 
% % signal in blue
% figure(1),
% plot(abs(fft(x1rec)),'b');
% hold on
% plot(abs(fft(x1org)),'r');
% plot(abs(sqrt(psdY)),'g');
% title('Frequency Plot');