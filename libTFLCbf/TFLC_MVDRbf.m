function [y, w] = TFLC_MVDRbf(x, a, R, w, use_u)

[n_ch, ~, n_freq, K, ~] = size(R);

% compute w
for i = 1:K
    conv_MVDR = calcMVDRfilter(a, R(:, :, :, i, i));

    % RTFLC
    if ~use_u
        w(:, i, :) = conv_MVDR;
        for f = 1:n_freq
            y(i, :, f) = w(:, i, f)' * x(:, :, f);
        end
        continue
    end

    % TFLC
    tmp = zeros(n_ch, 1, n_freq);
    u = zeros(n_ch, 1, n_freq);
    coef = zeros(n_freq, 1);
    for f = 1:n_freq
        % sum_{j=1, j~=i}^{K} R_{ij} w_j
        for j = 1:K
            if j ~= i
                tmp(:, :, f) = tmp(:, :, f) + R(:, :, f, i, j) * w(:, j, f);
            end
        end

        % u = R_{ii}^{-1} tmp
        u(:, :, f) = R(:, :, f, i, i) \ tmp(:, :, f);

        % w_i = (1 + a^H u) * conv_MVDR - u
        w(:, i, f) = (1 + a(:, f)' * u(:, :, f)) * conv_MVDR(:, :, f) - u(:, :, f);

        % y = w^H x
        y(i, :, f) = w(:, i, f)' * x(:, :, f);
    end
end
