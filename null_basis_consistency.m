H1 = [1, 0; 0, 1; 1, 1];
H2 = [H1; 1, 0.5];

disp('Calculating null space with SVD:')
disp("null(H1.'). =")
disp(null(H1.').')
disp("null(H2.'). =")
disp(null(H2.').')

disp("Calculating null space as in Algorithm 1:")
disp("null(H1.'). =")
HV = H1(1:2, :);
HA = H1(3:end, :);
disp([-HA * inv(HV), eye(1)])
disp("null(H2.'). =")
HV = H2(1:2, :);
HA = H2(3:end, :);
disp([-HA * inv(HV), eye(2)])
