function m_k = calcBFM(y_k, is_binary)
%%
%% calcBFM: compute beamformer selection mask with the minimum power criterion
%%
%% [inputs]
%%       y_k: Enhanced signals in STFT domain (# of filters, frame, freq. bin)
%% is_binary: Whether the selection mask is binary or soft
%%            1 corresponds to the TFS and 0 corresponds to the TFLC beamformer
%%
%% [outputs]
%%   m_k: beamformer selection mask
%%

[K, n_frame, n_freq] = size(y_k);
m_k = zeros(size(y_k));

if is_binary
    [~, idx] = min(abs(y_k), [], 1);
    m_k = zeros(size(y_k));

    for k = 1:K
        m_k(k, :, :) = idx == k;
    end
else
    % Merge indices of time frame and freq. bin
    n_tf = n_frame * n_freq;
    y_k = reshape(y_k, K, n_tf);
    m_k = reshape(m_k, K, n_tf);

    % Check whether sound exists or not
    [sound_exists, min_idx] = min(abs(y_k), [], 1);

    % Main
    if K == 1
        % Do nothing
        m_k(:, :) = 1;
    elseif K == 2
        for tf = 1:n_tf
            if not(sound_exists(tf))
                m_k(min_idx(tf), tf) = 1;
            else
                m_k(:, tf) = case2(y_k(:, tf));
            end
        end
    elseif K == 3
        for tf = 1:n_tf
            if not(sound_exists(tf))
                m_k(min_idx(tf), tf) = 1;
            else
                m_k(:, tf) = case3(y_k(:, tf));
            end
        end
    else
        for tf = 1:n_tf
            if not(sound_exists(tf))
                m_k(min_idx(tf), tf) = 1;
            else
                m_k(:, tf) = case_general(y_k(:, tf));
            end
        end
    end

    % Separate indices of time frame and freq. bin
    m_k = reshape(m_k, K, n_frame, n_freq);
end
