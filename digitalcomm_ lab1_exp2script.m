tot=1;
td=0.002;
t=0:td:tot;%time vector
x=sin(2*pi*t)-sin(6*pi*t);%signal:sum of two signals

ts=0.02;
Nfactor=round(ts/td); % Downsampling factor(doensamples the signal x by a factor of 10 i.e keeping only the the 10th sample)
xsm=downsample(x,Nfactor); %Downsample x
xsmu=upsample(xsm,Nfactor); %upsample xsm(upsamples the downsampled signal xsm to the original legth by inserting zeros btn samples)

Lffu=2^nextpow2(length(xsmu));% Next power of 2 for FFT(Fast Fourier Transform)
fmaxu=1/(2*td);%maximum frequency
Faxisu=linspace(-fmaxu,fmaxu,Lffu);% Frequency axis
Xfftu=fftshift(fft(xsmu,Lffu)); % FFT and frequency shifting-moves the zero-frequency component to the center of the spectrum

figure(1);
plot(Faxisu,abs(Xfftu));
xlabel('Frequency');
ylabel('Amplitude');
title('Spectrum of Sampled Signal');
grid;
%Ideal Low-Pass filter
BW=10;
H_lpf=zeros(1,Lffu);
H_lpf(Lffu/2-BW:Lffu/2+BW-1)=1;

figure(2);
plot(Faxisu,H_lpf);
xlabel('Frequency');
ylabel('Amplitude');
title('Transfer function of LPF');
grid;

x_recv=Nfactor*((Xfftu)).*H_lpf;% Filtering in frequency domain 

figure(3)
plot(Faxisu,abs(x_recv));
xlabel('Frequency');
ylabel('Amplitude');
title('Spectrum of LPF Output');
grid;

x_recv1=real(ifft(ifftshift(x_recv)));
x_recv2=x_recv1(1:length(t));

figure(4)
plot(t,x,'r',t,x_recv2,'b--','LineWidth',2);
xlabel('Time');
ylabel('Amplitude');
title('Original vs Reconstructed Signal');
grid;
