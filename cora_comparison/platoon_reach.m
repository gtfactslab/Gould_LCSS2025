clear; 
ff_control = load("ff_control.mat");
num_followers = 5;

t0 = ff_control.t(1);
dt = (ff_control.t(2) - ff_control.t(1)) / 5;
tf = ff_control.t(end) + 5 * dt;
u_interp = interp1(ff_control.t, ff_control.u, linspace(t0, tf, 300)).';

tf = 2.95;
u_interp = u_interp(:, 1:295);

%% Reachability Calculation

sys = nonlinearSys(@platoon_dynamics, 4*(num_followers+1), 2);

x0_leader = [8; 7; -sqrt(3); -1];
x0_followers = repmat(x0_leader, [num_followers, 1]);
for i = 0:num_followers-1
    x0_followers(4*i + 1) = x0_followers(4*i + 1) + 0.2 * sqrt(3) * (i+1);
    x0_followers(4*i + 2) = x0_followers(4*i + 2) + 0.2 * (i+1);
end
x0 = [x0_leader; x0_followers];

params.tStart = t0;
params.tFinal = tf;
params.R0 = interval(x0, x0);
params.u = u_interp; 
params.U = interval([-0.01; -0.01], [0.01; 0.01]); % admissible inputs

options.alg = 'lin';
options.timeStep = dt; 
options.tensorOrder = 2;
options.zonotopeOrder = 20; % caps number of generators in zonotope representation
options.taylorTerms = 5; 

R = reach(sys, params, options);

r = @() reach(sys, params, options);
t = timeit(r);
fprintf("Running with %d followers, time is %f\n", num_followers, t);

%% Plotting and Verification

hold on;
plot(R, [4 * num_followers + 1, 4 * num_followers + 2], "DisplayName", "Reachable Set");
plot(params.R0, [4 * num_followers + 1, 4 * num_followers + 2], "LineWidth", 2, "Color", "green", "DisplayName", "Initial Set");

legend("Location", "southwest");
title("Platoon Reachable Sets")
xlabel("x [m]");
ylabel("y [m]");
