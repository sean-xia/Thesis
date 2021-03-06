% More Complicated Spectral Subtraction Test for Bit Error Rate

Fs = 3000;
Ts = 1/Fs;
t = 0:Ts:1;

% Signal to transmit
n = randi([-1 1],length(t),1);
for s=1:length(t)
    if n(s)==0
        n(s)=1;
    end
end
x1 = n';
% x2 = x1.*cos(2*pi*30*t);
x2 = 30*sinc(2*pi*t).*cos(t*35);

y = x1+x2;  % awgn(x1+x2, .1);

omega = unwrap(angle(fft(y)));
omega2 = unwrap(angle(fft(x2)));
% 
% Sx1=ones(1,length(t));
% Sx2=ones(1,length(t));
% Sy=ones(1,length(t));
% 
% IntS1=ones(1,length(t));
% IntS2=ones(1,length(t));
% IntSy=ones(1,length(t));
% 

% for f=1:length(t)
%     for tau = 1:length(t)
%         IntS1(tau) = x1(tau)*exp(1i*tau*f);
%         IntS2(tau) = x2(tau)*exp(1i*tau*f);
%         IntSy(tau) = y(tau)*exp(1i*tau*f);
%     end
%     Sx1(f) = trapz(IntS1,x);    %PSD for x1 at frequency f
%     Sx2(f) = trapz(IntS2,x);    %PSD for x2
%     Sy(f) = trapz(IntSy,x);     %PSD for y
% end

% x = t;    %time Tau you are integrating over
% f=1:length(t);
% 
% Intpsde = exp(-1i*2*pi*x);
% psdy = trapz(Intpsde,x).^f.*trapz(y,x);
% psdx2 = trapz(Intpsde,x).^f.*trapz(x2,x);

psdy = fft(xcorr(y,y,1500));
psdx2 = fft(xcorr(x2,x2,1500));

% Perform Spectral Subtraction
Sx1_subd = psdy-psdx2;

x1_subd = ifft(sqrt(Sx1_subd).*exp(1i*omega));

fl=100; 
ff=[0 .1 .2 1];                 % BPF center frequency at .4
fa=[1 1 0 0];                   % which is twice f_0
h=firpm(fl,ff,fa);              % BPF design via firpm
n_subd=filter(h,1,x1_subd);  % filter to give preprocessed r

for s=1:length(n)
    if n_subd(s)>0
        n_subd(s)=1;
    else
        n_subd(s)=-1;
    end
end

numError=0;
for s=1:length(n)
    if n_subd(s) ~= n(s)
        numError = numError+1;
    end
end

numError

%Sx2(s)=quad(y(x)*exp(1i*2*pi*x),1,length(t))^(s);

figure(1),
subplot(4,1,1),
plot(-1500:1500, abs(fft(x1))),
title('Orriginal Modulated Signal'),
subplot(4,1,2),
plot(-1500:1500, abs(fft(y))),
title('Interfering Signal'),
subplot(4,1,3),
plot(-1500:1500, abs(fft(x1_subd))),
title('Subtracted Signal'),
subplot(4,1,4),
plot(-1500:1500, abs(fft(n_subd))),
title('Signal Filtered');
