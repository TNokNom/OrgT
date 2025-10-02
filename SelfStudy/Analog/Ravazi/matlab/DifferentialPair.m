% Differential Pair Waveform Simulation
clear; clc; close all;

% Parameters
t = linspace(0, 4*pi, 1000);    % time
Vin_CM = 0;                     % common mode input voltage
Vout_CM = 1;                    % common mode output voltage
VDD = 2;                        % supply voltage
Ain = 0.5;                      % input amplitude
Aout = 0.8;                     % output swing

% Differential inputs
Vin1 = Vin_CM + Ain * sin(t);
Vin2 = Vin_CM - Ain * sin(t);

% Case 1: Linear differential output (no cutoff)
Vout1_lin = Vout_CM - Aout * sin(t);
Vout2_lin = Vout_CM + Aout * sin(t);

% Case 2: With cutoff (transistor turns off)
Vout1_cut = Vout1_lin;
Vout2_cut = Vout2_lin;

% Impose cutoff at limits (simulate transistor off)
Vout1_cut(Vout1_cut > VDD) = VDD;
Vout2_cut(Vout2_cut > VDD) = VDD;
Vout1_cut(Vout1_cut < 0)   = 0;
Vout2_cut(Vout2_cut < 0)   = 0;

% ---- Plotting ----
figure;

% Inputs
subplot(2,2,1);
plot(t, Vin1, 'k-', 'LineWidth', 1.5); hold on;
plot(t, Vin2, 'k--', 'LineWidth', 1.5);
yline(Vin_CM, ':');
title('Inputs: V_{in1}, V_{in2}');
xlabel('t'); ylabel('Voltage');

% Outputs (linear)
subplot(2,2,2);
plot(t, Vout1_lin, 'k-', 'LineWidth', 1.5); hold on;
plot(t, Vout2_lin, 'k--', 'LineWidth', 1.5);
yline(Vout_CM, ':'); yline(VDD, '--');
title('Outputs (Linear)');
xlabel('t'); ylabel('Voltage');

% Inputs (with cutoff regions marked)
subplot(2,2,3);
plot(t, Vin1, 'k-', 'LineWidth', 1.5); hold on;
plot(t, Vin2, 'k--', 'LineWidth', 1.5);
yline(Vin_CM, ':');
% mark transistor cutoff
plot([pi, pi], ylim, 'r:'); % M2 off region
plot([2*pi, 2*pi], ylim, 'b:'); % M1 off region
title('Inputs with Cutoff');
xlabel('t'); ylabel('Voltage');

% Outputs (with cutoff)
subplot(2,2,4);
plot(t, Vout1_cut, 'k-', 'LineWidth', 1.5); hold on;
plot(t, Vout2_cut, 'k--', 'LineWidth', 1.5);
yline(Vout_CM, ':'); yline(VDD, '--');
title('Outputs (with cutoff)');
xlabel('t'); ylabel('Voltage');
