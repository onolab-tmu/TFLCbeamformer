function [y, w_k, m_k] = TFLCbf(x, a, ref_x, n_iter, K, tfs_name)
%%
%% TFLCbf: Time-Frequency-bin-wise Linear combination beamformer
%%
%% coded by K. Yamaoka (yamaoka-kouei@ed.tmu.ac.jp) on 28 Oct. 2018
%%
%% [inputs]
%%         x: Observed signal in STFT domain (channel, time frame, freq. bin)
%%         a: Relative transfer funciton from target source (channel, freq. bin)
%%     ref_x: reference signals in STFT domain for training (channel, time frame, freq. bin)
%%    n_iter: # of iterations
%%         K: # of beamformers
%%  tfs_name: Name of TFLC variants
%%
%% [outputs]
%%     y: Enhanced signal in STFT domain (1, time, frequency)
%%   w_k: multiple spatial filters
%%   m_k: beamformer combination mask
%%
%% [notes]
%%   If ref_x is composed of only noise signals, w_k are MVDR beamformers,
%%   and otherwise, they are MPDR beamformers.
%%   w_k are initialized randomly.
%%

%% check errors and set default values
    [n_ch, n_frame, n_freq] = size(x);
    [~, n_ref_frame, ~] = size(ref_x);

    if strcmp(tfs_name, 'TFS') == 1
        is_binary = 1;
        use_u = 0;
    elseif strcmp(tfs_name, 'TFLC') == 1
        is_binary = 0;
        use_u = 1;
    elseif strcmp(tfs_name, 'RTFLC') == 1
        is_binary = 0;
        use_u = 0;
    else
        error('tfs_name = {TFS, TFLC, RTFLC}')
    end

    % Initialization
    R = zeros(n_ch, n_ch, n_freq, K, K);
    iter = 0;

    %% main
    %% initialization step
    % Randomly initialize w_k
    w_k = 2 * rand(n_ch, K, n_freq) - 1 + 1j * (2 * rand(n_ch, K, n_freq) - 1);

    % y = w^H x
    y_k = zeros(K, n_frame, n_freq);
    ref_y_k = zeros(K, n_ref_frame, n_freq);
    for k = 1:K
        for f = 1:n_freq
            y_k(k, :, f) = w_k(:, k, f)' * x(:, :, f);
            ref_y_k(k, :, f) = w_k(:, k, f)' * ref_x(:, :, f);
        end
    end

    % initialize m_k
    m_k = MPS(y_k, is_binary);
    ref_m_k = MPS(ref_y_k, is_binary);

    %% update
    fprintf('Iteration: ');
    for iter = 1:n_iter
        fprintf('%d ', iter);

        % compute x_k
        for k = 1:K
            x_k(:, :, :, k) = x .* repmat(m_k(k, :, :), [n_ch, 1, 1]);
            ref_x_k(:, :, :, k) = ref_x .* repmat(ref_m_k(k, :, :), [n_ch, 1, 1]);
        end

        % compute covariance matrices
        for i = 1:K
            for j = 1:K
                R(:, :, :, i, j) = calcSCM(x_k(:, :, :, i), x_k(:, :, :, j), 1e-10);
                ref_R(:, :, :, i, j) = calcSCM(ref_x_k(:, :, :, i), ref_x_k(:, :, :, j), 1e-10);
            end
        end

        % Update w_k
        [y_k, w_k] = TFLC_MVDRbf(x, a, ref_R, w_k, use_u);

        % apply w_k to the reference signal
        for k = 1:K
            for f = 1:n_freq
                ref_y_k(k, :, f) = w_k(:, k, f)' * ref_x(:, :, f);
            end
        end

        % avoid use of invalid time-frequency bin
        y_k(isnan(y_k) == 1) = Inf;
        y_k(isinf(y_k) == 1) = Inf;
        ref_y_k(isnan(ref_y_k) == 1) = Inf;
        ref_y_k(isinf(ref_y_k) == 1) = Inf;

        % Update m_k
        m_k = calcBFM(y_k, is_binary);
        ref_m_k = calcBFM(ref_y_k, is_binary);

        % perform signal enhancement
        y = sum(y_k .* m_k, 1);

    end
    % update ends here
    fprintf('\n')
end
