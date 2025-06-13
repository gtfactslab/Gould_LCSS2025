function dx = leader_dynamics(x, u)
    u_lim = [5; 5];
    u = softmax_tan(u, u_lim);
    dx = [x(3); x(4); u(1); u(2)];
end
