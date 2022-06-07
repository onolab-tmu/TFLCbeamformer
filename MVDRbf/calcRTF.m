function D = calcRTF(X)
%%
%% calcRTF: calclate relative transfer function via eigenvalue decomposition
%%
%% coded by K. Yamaoka (yamaoka@mmlab.cs.tsukuba.ac.jp) on 28 Oct. 2018
%%
%% [input]
%%     X: STFT domain signal (channel, time frame, frequency bin)
%%
%% [output]
%%     D: relative transfer function (channel, frequency bin)
%%
%% [notes]
%%     D(1,:) = 1
%%

%% check errors and set default values
if (nargin ~= 1)
    error('The number of input arguments must be one.');
end

[n_ch, n_frame, n_freq] = size(X);

%% main
% compute spatial covariance matrix
R = calcSCM(X);

% estimate transfer function
D = zeros(n_ch, n_freq);
vec = zeros(n_ch, n_ch, n_freq);
val = vec;
for f = 1:n_freq
    [vec(:, :, f), val(:, :, f)] = eig(R(:, :, f));
    [~, idx] = max(diag(val(:, :, f)));
    D(:, f) = vec(:, idx, f);
end

% relative transfer fucntion
D = D / max(max(abs(D)));
tmp = D(1, :);
tmp(tmp == 0) = 0.001;
for ch = 1:n_ch
    D(ch, :) = D(ch, :) ./ tmp;
end
D(1, :) = 1;

