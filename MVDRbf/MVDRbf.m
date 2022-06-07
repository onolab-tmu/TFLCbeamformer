function [y, w] = MVDRbf(x, D, varargin)
%%
%% MVDRbf: Minimum Variance Distrotionless Response beamformer
%%
%% coded by K. Yamaoka (yamaoka@mmlab.cs.tsukuba.ac.jp) on 28 Oct. 2018
%%
%% [syntax]
%%     [y, w] = MVDRbf(x, D)
%%     [y, w] = MVDRbf(x, D, NOISE)
%%     [y, w] = MVDRbf(x, TGT)
%%     [y, w] = MVDRbf(x, TGT, NOISE)
%%
%% [input]
%%         x: STFT domain observed signal (channel, time frame, freq. bin)
%%         D: relative transfer function (channel, frequency bin)
%%       TGT: STFT domain target signal for training (channel, time frame, freq. bin)
%%     NOISE: STFT domain noise signal for training (channel, time frame, freq. bin)
%%
%% [output]
%%     y: STFT domain enahnced signal (1, time frame, freq. bin)
%%     w: MVDR filter (channel, 1, freq. bin)
%%
%% [note]
%%    This computes a time-invariant spatial filter.
%%    y = w^h x
%%

%% check errors and set default values
if nargin < 2
    error('Too few input arguments.');
elseif nargin > 3
    error('Too many input arguments');
elseif nargin == 2
    NOISE = x;
elseif nargin == 3
    NOISE = varargin{1};
end

if size(D, 3) ~= 1
    D = calcRTF(D);
end
[n_ch, n_frame, n_freq] = size(x);

%% main
% calc Phi
R = calcSCM(NOISE, 1e-10);

% calc filter
w = calcMVDRfilter(D, R);

% filter(ch, 1, f)
y = zeros(1, n_frame, n_freq);
for f = 1:n_freq
    y(1, :, f) = w(:,:,f)' * x(:,:,f);
end

end
