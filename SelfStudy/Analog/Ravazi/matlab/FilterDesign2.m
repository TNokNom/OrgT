fs = 1000;              % Sampling frequency (Hz)
t = 0:1/fs:1-1/fs;      % Time vector
f_ecg = 1;              % ECG frequency (Hz)
f_noise = 100;          % Noise frequency (Hz)

% ECG Signal
ecg = 1.2 * sin(2*pi*f_ecg*t);
noise = 0.5 * sin(2*pi*f_noise*t);
signal = ecg + noise;

order = 2;
fc = 50;
wc = 2*pi*fc;
[b_analog, a_analog] = butter(order, wc, 's');

% Convert to digital using bilinear transform
[bd, ad] = bilinear(b_analog, a_analog, fs);

% Apply digital filter to signal
filtered = filter(bd, ad, signal);

% Plot signals
figure;
plot(t, signal, 'r--', 'DisplayName', 'Noisy ECG');
hold on;
plot(t, filtered, 'b', 'DisplayName', 'Filtered ECG');
title('ECG Signal Before and After Filtering');
xlabel('Time (s)');
ylabel('Amplitude');
legend;
grid on;
