function [m, d] = case2(AB)
%% AB: (y1, y2)
%% m: (m_1, m_2) soft mask
%% d: distance

m = zeros(2, 1);

% convert coordinates from complex plane to xy plane
vertex = zeros(2, 2);
vertex(1, :) = real(AB);
vertex(2, :) = imag(AB);

% compute vectors
vec_ab = vertex(:, 2) - vertex(:, 1);
vec_ao = - vertex(:, 1);
norm_ab = norm(vec_ab);

% exception; if A == B
if norm_ab == 0
    if norm(vertex(:, 1)) < norm(vertex(:, 2))
        m(1) = 1;
        d = norm(vertex(:, 1));
    else
        m(2) = 1;
        d = norm(vertex(:, 2));
    end
    return
end

% projection
distance = vec_ab' * vec_ao / norm_ab;

if distance >= norm_ab;
    % use B
    m(2) = 1;
    d = norm(vertex(:, 2));
elseif distance <= 0
    % use A
    m(1) = 1;
    d = norm(vertex(:, 1));
else
    % use internally dividing point
    m(2) = distance / norm_ab;
    m(1) = 1 - m(2);
    d = -1 * vec_ao + m(2) * vec_ab;;
    d = norm(d);
end

