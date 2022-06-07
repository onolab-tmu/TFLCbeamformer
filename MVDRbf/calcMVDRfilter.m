function w = calcMVDRfilter(D, R)
%%
%% calcMVDRfilter: design time-invariant spatial filter of MVDR beamformer
%%
%% coded by K. Yamaoka (yamaoka@mmlab.cs.tsukuba.ac.jp) on 28 Oct. 2018
%%
%% [inputs]
%%     D: relative transfer function (channel, frequency bin)
%%     R: covariance matrix (channel, channel, frequency bin)
%%
%% [output]
%%     w: MVDR filter (channel, 1, frequency bin)
%%
%% [notes]
%%    retrun a time-invariant spatial filter
%%    y = w^h x
%%

%% check errors and set default values
if (nargin ~= 2)
    error('The number of input arguments must be two.');
end
[n_ch, n_frame, n_freq] = size(R);

% regularization parameters
threshold = 0.01;
eps = 0.01;

%% main
w = zeros(n_ch, 1, n_freq);
denominator = zeros(n_freq, 1);
for f = 1:n_freq
    % if rank deficient, do regularization
    if rcond(R(:,:,f)) < 1e-10
        fprintf('rank(R(%f)) deficient\n', f)
        R(:,:,f) = R(:,:,f) + 1e-10 * eye(n_ch);
    end

    denominator(f) = D(:,f)' / R(:,:,f) * D(:,f);

    % regularization
    if abs(denominator(f)) < threshold
        fprintf('denominator(%f) = %G\n is regularized\n', f, denominator(f))
        denominator(f) = (abs(denominator(f)) + eps) * exp(1j * angle(denominator(f)));
    end
    w(:,:,f) = R(:,:,f) \ D(:,f) / denominator(f);
end
