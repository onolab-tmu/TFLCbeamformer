function is = is_in_triangle(ABC, P)
%% check whether the point is inside of the triangle
%% ABC: vector of (x, y) coordinates of the triangle ABC (n_dim=2, n_vec=3)
%% P: point

% convert 2D vector to 3D
ABC(3, :) = 0;
P(3, 1) = 0;

% vectors
AB = ABC(:, 2) - ABC(:, 1);
BC = ABC(:, 3) - ABC(:, 2);
CA = ABC(:, 1) - ABC(:, 3);
AP = P - ABC(:, 1);
BP = P - ABC(:, 2);
CP = P - ABC(:, 3);

% sign of vector product
tmp = cross(AB, BP);
s1 = tmp(3) > 0;
tmp = cross(BC, CP);
s2 = tmp(3) > 0;
tmp = cross(CA, AP);
s3 = tmp(3) > 0;

is = (s1 == s2) && (s2 == s3);

