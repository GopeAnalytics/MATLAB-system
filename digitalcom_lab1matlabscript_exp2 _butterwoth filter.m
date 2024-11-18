tot = 1;
td = 0.002;
t = 0:td:tot;
x = sin(2*pi*t) - sin(6*pi*t);

ts = 0.02;
Nfactor = round(ts/td);

% Anti-aliasing filter before downsampling
cutoff_freq = 1/(2*ts); % Nyquist frequency after downsampling
[b, a] = butter(4, cutoff_freq/(1/(2*td)), 'low'); % Butterworth filter design
x_filtered = filter(b, a, x);
xsm = downsample(x_filtered, Nfactor);

% Interpolation-based upsampling
xsmu = interp1(1:length(xsm), xsm, linspace(1, length(xsm), length(x)));

Lffu = 2^nextpow2(length(xsmu));
fmaxu = 1/(2*td);
Faxisu = linspace(-fmaxu, fmaxu, Lffu);
Xfftu = fftshift(fft(xsmu, Lffu));

figure(1);
plot(Faxisu, abs(Xfftu));
xlabel('Frequency');
ylabel('Amplitude');
title('Spectrum of Sampled Signal');
grid on;

% Butterworth LPF design (replace ideal LPF)
BW = 10;
[b, a] = butter(4, BW/fmaxu, 'low'); % Butterworth filter design
[h, w] = freqz(b, a, Lffu); % Frequency response
H_lpf = h;

figure(2);
plot(Faxisu(Lffu/2+1:end), abs(H_lpf(Lffu/2+1:end)));
xlabel('Frequency');
ylabel('Amplitude');
title('Transfer function of LPF');
grid on;

x_recv = Xfftu .* H_lpf; % Filtering (No Nfactor scaling)

figure(3);
plot(Faxisu, abs(x_recv));
xlabel('Frequency');
ylabel('Amplitude');
title('Spectrum of LPF Output');
grid on;

x_recv1 = real(ifft(ifftshift(x_recv)));
x_recv2 = x_recv1(1:length(t));

figure(4);
plot(t, x, 'r', t, x_recv2, 'b--', 'LineWidth', 2);
xlabel('Time');
ylabel('Amplitude');
title('Original vs Reconstructed Signal');
grid on;