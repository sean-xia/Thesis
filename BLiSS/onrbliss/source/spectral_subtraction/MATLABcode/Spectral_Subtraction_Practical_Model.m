% Spectral Subtraction Practical Model
% 6/12/2011
% Robert Over
% USNA BliSS Project
% Professor Alexander Wyglinski
% Professor Chris Anderson

% Desired Signal
F = 9e3;   % Frequency of 4kHz
T = 1/F;    % Period of 1/4000
t = T/2:T/2:1;    % Signal Caclulated over a time peroid t

x = randi([-1,1], length(t),1);    % X is a signal of a lenght 4000

% Part 1: Pheasability of different types of Fourier Transforms

% Xf = fft(x);        % Fourier Transform of x
% x_2 = ifft(Xf);     % Signal converted bach into time domain
% 
% % Error sumation
% numER = 0;
% for i=1:length(t)
%     numER = numER + abs(x_2(i)) - abs(x(i));
% end
% Total_Error = numER         % This will display the total error
%     
% % The total error for all the data is 1.2346 x 10^-12
% 
% % In order to find a more accurate system another form of the Fourier
% % Transform will be implemented
% 
% Xf = dftmtx(length(x))*x;   % Frequency spectrum of x(t) = X(f)
% 
% Fh = conj(dftmtx(length(x)))/length(x);     % Inverse dftmtx to convert X(f)
%                                             % Back into time domain
% 
% x_2 = Fh*Xf;    % signal back in time domain
% 
% % Error sumation
% numER = 0;
% for i=1:length(t)
%     numER = numER + abs(x_2(i)) - abs(x(i));
% end
% Error = numER   % This will display the total error
% 
% % Total error is 8.5837e-012
% % Error for fft(x) is less
% 
% figure(1),
% subplot(3,1,1),
% plot(x),
% subplot(3,1,2),
% plot(abs(Xf)),
% subplot(3,1,3),
% plot(x,'b'),
% hold on,
% plot(x,'r');

% Part 2: Simple Signal Transmision

% In this section of the model the signal will be combined with a pulse shape
% using a Square Root Raised Cosine pulse. The sigal will also be modulated
% up to a frequency of 4kHz. Noise will be added using the awgn() function.
% The noise will then be filtered out leaving the original signal.

fo = 4e3;
Beta = .5;
fdelta = Beta/fo;

srrctfs = 2*fo*sin(2*pi*fo*t)./(2*pi*fo*t);
srrctfc = cos(2*pi*fdelta*t)./1-(4*fdelta*t).^2;
pulse = srrctfs.*srrctfc;
pulse = pulse/sqrt(sum(pulse.^2));

x_mod = conv(x, pulse);

x_noise = awgn(x_mod, .2);

NoiseEST = .8*awgn(randi([-1,1], length(x_mod),1),.2)';

NoiseEST_freq = abs(fft(NoiseEST));
x_noise_freq = abs(fft(x_noise));

for i =1:length(NoiseEST_freq)
    if NoiseEST_freq(i) > x_noise_freq(i)
        NoiseEST_freq(i) = x_noise_freq(i);
    elseif x_noise_freq(i)<1000
            NoiseEST_freq(i)=x_noise_freq(i);
    end
end
    
SNR = abs(fft(NoiseEST))./abs(fft(x_noise));

% num_errors = 10e6;
% 
% for AlphaN = 10:100
%     for BetaN = 10:100

AlphaN=.5;
BetaN=.5;

J = 1/(AlphaN+BetaN)-(SNR).^2;

Gainfcn = zeros(1,length(x_noise));

for i=1:length(x_noise)
    if J(i)>=0
        Gainfcn(i) = sqrt(1-AlphaN*(SNR(i))^2);
    else
        Gainfcn(i) = sqrt(BetaN*(SNR(i))^2);
    end
end

x_noNoise_fft = fft(x_noise).*Gainfcn;

x_filtout = deconv(ifft(x_noNoise_fft), pulse);

% x_Errors = abs(sum(abs(x_filtout)-abs(x')));
% 
% if x_Errors<num_errors
%     best_Beta = BetaN;
%     best_Alpha = AlphaN;
% end
% 
%     end
% end

% best_Beta
% best_Alpha
% 
figure(1)
subplot(3,1,1)
plot(x)
subplot(3,1,2)
plot(abs(fft(x_mod)))
subplot(3,1,3)
plot(abs(fft(x_noise)))

figure(2)
subplot(3,1,1)
plot(SNR)
subplot(3,1,2)
plot(Gainfcn)
subplot(3,1,3)
plot(x_filtout)


% x_int = 2*randi([0,1], length(x), 1);
% 
% fo2 = 4e3+1000;
% Beta = .5;
% fdelta2 = Beta/fo2;
% 
% srrctfs2 = 2*fo*sin(2*pi*fo2*t)./(2*pi*fo2*t);
% srrctfc2 = cos(2*pi*fdelta2*t)./1-(4*fdelta2*t).^2;
% pulse2 = srrctfs2.*srrctfc2;
% pulse2 = pulse2/sqrt(sum(pulse2.^2));
% 
% x_mod2 = conv(x_int,pulse2);
% 
% x_interfering = x_mod + x_mod2;