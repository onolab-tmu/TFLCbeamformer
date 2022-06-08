function m = case_general(y_k)
%% case3: compute the point closest to the origin inside the convex hull
%% y: (y1, ..., yK)
%% m: (m1, ..., mK)

K = length(y_k);
m = zeros(K, 1);
O = [0; 0];

% convert coordinates from complex plane to xy plane
[real_part, imag_part] = im2xy(y_k);

if is_line(y_k)
    [val, idx] = min(abs(y_k));
    m(idx) = 1;
    return
else
% compute convex hull
    try
        vertexes = convhull(real_part, imag_part);
    catch
        y_k
        figure(1)
        plot([real_part; real_part(1)], [imag_part; imag_part(1)], 'o-')
        savefig(gcf, 'error.fig')
        m(:) = inf;
        return
    end
end

origin_is_inside = inpolygon(O(1), O(2), real_part(vertexes), imag_part(vertexes));

if origin_is_inside
    % triangle
    coordinates = combnk(1:length(y_k), 3);
    d = abs(y_k);
    norm = sum(d(coordinates), 2);
    [snorm, idx] = sort(norm);
    for i = 1:length(coordinates)
        triangle = coordinates(idx(i), :);
        a_r = real_part(triangle(1));
        b_r = real_part(triangle(2));
        c_r = real_part(triangle(3));
        a_i = imag_part(triangle(1));
        b_i = imag_part(triangle(2));
        c_i = imag_part(triangle(3));
        ABC = [a_r, b_r, c_r; a_i, b_i, c_i];
        if is_in_triangle(ABC, O);
            tmp = case3(xy2im(ABC));
            m(triangle(1)) = tmp(1);
            m(triangle(2)) = tmp(2);
            m(triangle(3)) = tmp(3);
            return
        end
    end
    msg = "origin is inside; triangle is not found";
else
    % edge
    p = [mean(real_part(vertexes)), mean(imag_part(vertexes))];
    for i = 1:length(vertexes) - 1
        a = [real_part(vertexes(i)); imag_part(vertexes(i))];
        b = [real_part(vertexes(i + 1)); imag_part(vertexes(i + 1))];
        if is_intersected(a, b, O, p)
            tmp = case2([xy2im(a), xy2im(b)]);
            m(vertexes(i)) = tmp(1);
            m(vertexes(i + 1)) = tmp(2);
            return
        end
    end
    msg = "origin is outside; intersection is not found";
end
msg

m(:) = inf;

function retval = is_intersected(a, b, c, d)
ta = (c(1) - d(1)) * (a(2) - c(2)) + (c(2) - d(2)) * (c(1) - a(1));
tb = (c(1) - d(1)) * (b(2) - c(2)) + (c(2) - d(2)) * (c(1) - b(1));
tc = (a(1) - b(1)) * (c(2) - a(2)) + (a(2) - b(2)) * (a(1) - c(1));
td = (a(1) - b(1)) * (d(2) - a(2)) + (a(2) - b(2)) * (a(1) - d(1));

retval = tc * td < 0 && ta * tb < 0;


function [x, y] = im2xy(im)
x = real(im);
y = imag(im);

function im = xy2im(xy)
im = xy(1, :) + 1j * xy(2, :);


function retval = is_line(y_k)
retval = 1;
x1 = real(y_k(1));
y1 = imag(y_k(1));
x2 = real(y_k(2));
y2 = imag(y_k(2));
for i = 3:length(y_k)
    x3 = real(y_k(i));
    y3 = imag(y_k(i));
    retval = retval && (abs(((x3 - x1) * (y2 - y1)) - ((x2 - x1) * (y3 - y1))) < 1e-14);
end
