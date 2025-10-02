# Save part 1: Filter design and frequency response plot (MATLAB-compatible code)
fs = 1000;              % Sampling frequency (Hz)
order = 2;
fc = 50;                            % cutoff frequency
wc = 2*pi*fc;                       % angular cutoff frequency

% Analog Butterworth filter design
[b_analog, a_analog] = butter(order, wc, 's');
[H, w] = freqs(b_analog, a_analog, 1000);

% Plot frequency response
figure;
semilogx(w/(2*pi), 20*log10(abs(H)));
title('Analog Butterworth Filter Frequency Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;


# Save part 2: ECG signal simulation and filtering (MATLAB-compatible code)
matlab_code_part2 = """
% Part 2: ECG Signal + Noise Simulation and Filtering

fs = 1000;              % Sampling frequency (Hz)
t = 0:1/fs:1-1/fs;      % Time vector
f_ecg = 1;              % ECG frequency (Hz)
f_noise = 100;          % Noise frequency (Hz)

% Create noisy ECG signal
ecg = 1.2 * sin(2*pi*f_ecg*t);
noise = 0.5 * sin(2*pi*f_noise*t);
signal = ecg + noise;

order = 2;
fc = 50;
wc = 2*pi*fc;
[b_analog, a_analog] = butter(order, wc, 's');

[bd, ad] = bilinear(b_analog, a_analog, fs);

filtered = filter(bd, ad, signal);

figure;
plot(t, signal, 'r--', 'DisplayName', 'Noisy ECG');
hold on;
plot(t, filtered, 'b', 'DisplayName', 'Filtered ECG');
title('ECG Signal Before and After Filtering');
xlabel('Time (s)');
ylabel('Amplitude');
legend;
grid on;
