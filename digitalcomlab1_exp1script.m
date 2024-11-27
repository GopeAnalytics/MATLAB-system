%clear all;
%close all;
%clc;

tot=1;
td=0.002;
t=0:td:tot;
x=sin(2*pi*t)-sin(6*pi*t);

figure;
plot(t,x,'LineWidth',2);
xlabel('Time (s)'); 
ylabel('Amplitude'); 
title('Input Message Signal'); 
grid on;

L=length(x);
Lfft=2^nextpow2(L);
fmax=1/(2*td);
Faxis=linspace(-fmax,fmax,Lfft);
Xfft=fftshift(fft(x,Lfft));

figure;
plot(Faxis,abs(Xfft));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Spectrum of Input Message Signal');
grid on;

ts=0.02;
n=0:ts:tot;
x_sampled=sin(2*pi*n)-sin(6*pi*n);

figure;
stem(n,x_sampled, 'LineWidth',2);
xlabel('Time(S)');
ylabel('Amplitude');
title('Sampled Signal');
grid on;

x_sampled_upsampled=upsample(x_sampled,round(ts/td));
Lffu=2^nextpow2(length(x_sampled_upsampled));
fmaxu=1/(2*ts);
Faxisu=linspace(-fmaxu,fmaxu,Lffu);
Xfftu=fftshift(fft(x_sampled_upsampled,Lffu));

figure;
plot(Faxisu,abs(Xfftu));
xlabel('Frequency(Hz)');
ylabel('Magnitude');
title('Spectrum of Sampled Signal');
grid on;

%Define quantization levels
levels=16;
x_min=min(x_sampled);
x_max=max(x_sampled);
step=(x_max-x_min)/levels;

%Quantize the sampled signal
x_quantized=step*round((x_sampled-x_min)/step)+x_min;

%Plot Quantized vs. sampled signal
figure;
stem(n,x_sampled,'r','LineWidth',1.5);hold on;
stem(n,x_quantized,'b--','LineWidth',1.5);
xlabel('Time(s)');
ylabel('Amplitude');
title('Sampled Signal vs. Quantized Signal');
legend('Sampled signal','Quantized Signal');
grid on;

%Quantization error
quantization_error=x_sampled-x_quantized;
figure;
stem(n,quantization_error,'LineWidth',1.5);
xlabel('Time(s)');
ylabel('Error');
title('Quantization Error');
grid on;
