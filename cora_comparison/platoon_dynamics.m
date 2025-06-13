function dx = platoon_dynamics(x, u)
    dx = leader_dynamics(x, u); 

    for i = 0:(numel(x)/4)-2
        leader_x = x(4*i+1:4*(i+1));
        follower_x = x(4*(i+1)+1:4*(i+2));
        follower_dx = follower_dynamics(leader_x, follower_x);
        dx = [dx; follower_dx];
    end
end