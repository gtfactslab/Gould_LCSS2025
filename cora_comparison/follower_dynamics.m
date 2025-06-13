function dx = follower_dynamics(leader_x, follower_x)
    k_p = 5;
    k_d = 5;
    r = 0.5;

    offset = r * leader_x(3:4) ./ (sqrt(leader_x(3)^2 + leader_x(4)^2));
    u_pd = k_p * (leader_x(1:2) - follower_x(1:2) - offset)...
        + k_d * (leader_x(3:4) - follower_x(3:4));
    dx = [follower_x(3); follower_x(4); u_pd(1); u_pd(2)];
end