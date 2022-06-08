clear

%% test 1
A = [6; 6];
B = [4; 2];
C = [2; 4];
xrange = [-1 7];
yrange = [-1 7];

% plot triangle
figure(1)
plot([A(1) B(1)], [A(2) B(2)], 'k-')
hold on
plot([B(1) C(1)], [B(2) C(2)], 'k-')
plot([C(1) A(1)], [C(2) A(2)], 'k-')
plot(xrange, [0 0], 'k-')
plot([0 0], yrange, 'k-')
xlim(xrange)
ylim(yrange)
pbaspect([1 1 1])

% test case3()
vertex = zeros(2, 3);
vertex(:, 1) = A;
vertex(:, 2) = B;
vertex(:, 3) = C;

y = zeros(3, 1);
y(1) = A(1) + 1j * A(2);
y(2) = B(1) + 1j * B(2);
y(3) = C(1) + 1j * C(2);
m = case3(y)

% plot the point closest to the origin
Q = m(1) * A + m(2) * B + m(3) * C;
plot(Q(1), Q(2), 'bo')

hold off

%% test 2
clear
A = [-5; 2];
B = [1; -1];
C = [2; 5];
xrange = [-7 7];
yrange = [-7 7];

% plot triangle
figure(2)
plot([A(1) B(1)], [A(2) B(2)], 'k-')
hold on
plot([B(1) C(1)], [B(2) C(2)], 'k-')
plot([C(1) A(1)], [C(2) A(2)], 'k-')

plot(xrange, [0 0], 'k-')
plot([0 0], yrange, 'k-')
xlim(xrange)
ylim(yrange)
pbaspect([1 1 1])

% test case3()
vertex = zeros(2, 3);
vertex(:, 1) = A;
vertex(:, 2) = B;
vertex(:, 3) = C;

y = zeros(3, 1);
y(1) = A(1) + 1j * A(2);
y(2) = B(1) + 1j * B(2);
y(3) = C(1) + 1j * C(2);
m = case3(y)

% plot the point closest to the origin
Q = m(1) * A + m(2) * B + m(3) * C;
plot(Q(1), Q(2), 'bo')

hold off
