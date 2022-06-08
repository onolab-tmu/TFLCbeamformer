clear

% make test data
% test: {'inside', 'outside', 'random_inside', 'random_outside'}
test = 'random_outside';
N = 8;
if strcmp(test, 'outside') == 1
    y(1) = 2.2 + 3.7j;
    y(2) = 3 + 1.5j;
    y(3) = 1 + 3j;
    y(4) = 2 + 5j;
    y(5) = 5 + 5j;
    y(6) = 3.5 + 4.2j;
    y = y.';
    xrange = [0 6];
    yrange = [0 6];
elseif strcmp(test, 'inside') == 1
    y(1) = 2.2 + 3.7j;
    y(2) = 3 + 1.5j;
    y(3) = 1 + 3j;
    y(4) = 2 + 5j;
    y(5) = 5 + 5j;
    y(6) = 3.5 + 4.2j;
    y = y - (2 + 3j);
    y = y.';
    xrange = [-2 4];
    yrange = [-2 4];
elseif strcmp(test, 'random_outside') == 1
    y = rand(N, 1) + 1j * rand(N, 1);
    xrange = [0 1];
    yrange = [0 1];
elseif strcmp(test, 'random_inside') == 1
    y = rand(N, 1) + 1j * rand(N, 1);
    y = y - (0.5 + 0.5j);
    xrange = [-0.5 0.5];
    yrange = [-0.5 0.5];
end

% plot axis
figure(1)
plot(xrange, [0 0], 'k:')
hold on
plot([0 0], yrange, 'k:')
xlim(xrange)
ylim(yrange)
h(1) = plot(y, 'ok');
pbaspect([1, 1, 1])

% main
K = length(y);
m = zeros(K, 1);

% convert coordinates from complex plane to xy plane
real_part = real(y);
imag_part = imag(y);
vertexes = convhull(real_part, imag_part);
h(2) = plot(real_part(vertexes), imag_part(vertexes), 'r');

% test case_general()
m = case_general(y)
O = [0, 0];
origin_is_inside = inpolygon(O(1), O(2), real_part(vertexes), imag_part(vertexes));

% plot
if origin_is_inside
    h(3) = plot(O(1), O(2), 'bd');
    idx = (m ~= 0);
    ABC = y(idx);
    h(4) = plot([real(ABC(1)), real(ABC(2))], [imag(ABC(1)), imag(ABC(2))], 'bo-');
    plot([real(ABC(2)), real(ABC(3))], [imag(ABC(2)), imag(ABC(3))], 'bo-')
    plot([real(ABC(3)), real(ABC(1))], [imag(ABC(3)), imag(ABC(1))], 'bo-')
    legend(h, {'Given points', 'Convex hull', 'Closest point', 'Selected triangle'});
else
    intersection = m' * y;
    h(3) = plot([O(1) real(intersection)], [O(2) imag(intersection)], 'bd');
    plot([O(1) real(intersection)], [O(2) imag(intersection)], 'bd:')
    legend(h, {'Given points', 'Convex hull', 'Closest point'});
end
hold off
