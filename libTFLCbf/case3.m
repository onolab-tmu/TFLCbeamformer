function m = case3(ABC)
%% case3: compute the point closest to the origin inside the given triangle
%% ABC: (y1, y2, y3);
%% m: (m_1, m_2, m_3) soft mask

m = zeros(3, 1);

% convert coordinates from complex plane to xy plane
vertex = zeros(2, 3);
vertex(1, :) = real(ABC);
vertex(2, :) = imag(ABC);

% for the sake of conciseness
x1 = vertex(1, 1);
y1 = vertex(2, 1);
x2 = vertex(1, 2);
y2 = vertex(2, 2);
x3 = vertex(1, 3);
y3 = vertex(2, 3);

% check whether the origin is inside of the triangle
origin_is_inside = is_in_triangle(vertex, [0; 0]);

% check whether the three points on the same straight line
is_line = abs(((x3 - x1) * (y2 - y1)) - ((x2 - x1) * (y3 - y1))) < 1e-10;

if origin_is_inside && not(is_line)
    % compute the coefficients of the line AO and BC
    a1 = y1 / x1;
    a2 = (y2 - y3) / (x2 - x3);
    b2 = -1 * a2 * x2 + y2;

    % compute the point of intersection of AO and BC
    xp = b2 / (a1 - a2);
    yp = a1 * xp;

    % compute the ratio of internally dividing point
    s = norm([xp; yp] - [x2; y2]) / norm([x3; y3] - [x2; y2]);
    t = norm([0; 0] - [x1; y1]) / norm([xp; yp] - [x1; y1]);

    % compute the ratio
    m(1) = 1 - t;
    m(2) = (1 - s) * t;
    m(3) = s * t;
else
    [m12, d12] = case2([ABC(1), ABC(2)]);
    [m23, d23] = case2([ABC(2), ABC(3)]);
    [m13, d13] = case2([ABC(1), ABC(3)]);

    [~, min_idx] = min([d12, d23, d13]);
    if min_idx == 1
        m(1:2) = m12;
    elseif min_idx == 2
        m(2:3) = m23;
    else
        m(1:2:3) = m13;
    end
end

