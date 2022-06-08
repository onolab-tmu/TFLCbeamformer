%% Test code for case2()

% prepare figure
figure(1)
range = [-7 7];
plot(range, [0 0], 'k-')
hold on
plot([0 0], range, 'k-')
xlim(range);
ylim(range);
pbaspect([1 1 1])

% m = 0 1
A = -1.5 + 6j;
B = 0 + 3j;
m = case2([A, B]);
fprintf("Test 1\nTrue m = [0, 1]: Result m = [%f, %f]\n\n", m(1), m(2))

% m = 1 0
m = case2([B, A]);
fprintf("Test 2\nTrue m = [1, 0]: Result m = [%f, %f]\n\n", m(1), m(2))

% m = 1 0
A = 2 +  -1j;
B = 4.5 +  -6j;
m = case2([A, B]);
fprintf("Test 3\nTrue m = [1, 0]: Result m = [%f, %f]\n\n", m(1), m(2))

% m = 0 1
m = case2([B, A]);
fprintf("Test 4\nTrue m = [0, 1]: Result m = [%f, %f]\n\n", m(1), m(2))

% m = 0.5, 0.5
A = 1/5 + 13/5j;
B = 11/5 - 7/5j;
m = case2([A, B]);
fprintf("Test 5\nTrue m = [0.5, 0.5]: Result m = [%f, %f]\n\n", m(1), m(2))

% m = 0.75, 0.25
A = 1/5 + 13/5j;
B = 21/5 - 27/5j;
m = case2([A, B]);
fprintf("Test 6\nTrue m = [0.75, 0.25]: Result m = [%f, %f]\n\n", m(1), m(2))

% plot the result of test 6
plot(real(A), imag(A), 'ko')
plot(real(B), imag(B), 'ko')
plot([real(A) real(B)], [imag(A) imag(B)], 'k')

% point closest to the origin
mid = m(1) * A + m(2) * B;
plot(real(mid), imag(mid), 'ks')

hold off
