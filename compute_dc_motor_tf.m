s = tf('s');

% Exact 2nd-order model
G_exact = kt / ((Ra + La*s)*(J*s + Bm) + ke*kt);
disp('Exact 2nd-order Transfer Function (omega/V):');
G_exact

%% Step response of exact system
figure;
step(G_exact);
title('Step Response: Exact 2nd-order DC Motor');
grid on;

%% Compute exact system parameters directly
[~, den_e] = tfdata(G_exact, 'v');

% Extract denominator coefficients safely
if length(den_e) == 3
    a2 = den_e(1); a1 = den_e(2); a0 = den_e(3);
else
    a2 = den_e(end-2); a1 = den_e(end-1); a0 = den_e(end);
end

omega_n   = sqrt(a0/a2);
zeta      = a1/(2*sqrt(a0*a2));
tau_exact = 1/(zeta*omega_n);
K_exact   = dcgain(G_exact);

fprintf('\nExact 2nd-order system:\n');
fprintf('Steady-state gain K_exact = %.4f rad/s per V\n', K_exact);
fprintf('Dominant time constant tau_exact = %.4f s\n', tau_exact);

clear den_e a2 a1 a0   % prevent clutter

%% Simplified 1st-order model (neglect La)
G_simple = kt / (Ra*(J*s + Bm) + ke*kt);
disp('Simplified 1st-order Transfer Function (omega/V):');
G_simple

%% Gain and time constant for simplified system
K_simple = dcgain(G_simple);
[~, den_s] = tfdata(G_simple, 'v');
tau_simple = den_s(end-1)/den_s(end);

fprintf('\nSimplified 1st-order system:\n');
fprintf('Steady-state gain K_simple = %.4f rad/s per V\n', K_simple);
fprintf('Time constant tau_simple = %.4f s\n', tau_simple);

clear den_s   % prevent clutter

%% Step response comparison: exact vs simplified
figure;
step(G_exact, 'r', G_simple, 'b--');
legend('Exact 2nd-order', 'Simplified 1st-order');
title('Step Response: Exact vs Simplified DC Motor');
grid on;