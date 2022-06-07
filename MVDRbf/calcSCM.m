function R = calcSCM(X, varargin)
%%
%% calcPhi: calculate spatial covariance matrix
%%
%% coded by K. Yamaoka (yamaoka@mmlab.cs.tsukuba.ac.jp) on 28 Oct. 2018
%%
%% [input]
%%   X: STFT domain signal (channel, time frame, freq. bin)
%%
%% [optional]
%%         Y: STFT domain signal (channel, time frame, freq. bin)
%%   epsilon: weignt of regularizaion (default: 0)
%%
%% [output]
%%   R: covariance matrix (channel, channel, freqency bin)
%%

%% check errors and set default values
epsilon = 0;
if nargin < 1
    error('Too few input arguments');
elseif nargin > 3
    error('Too many input arguments');
elseif nargin == 1
    Y = X;
elseif nargin == 2
    if isscalar(varargin{1})
        epsilon = varargin{1};
        Y = X;
    else
        Y = varargin{1};
    end
else
    if isscalar(varargin{1})
        epsilon = varargin{1};
        Y = varargin{2};
    else
        epsilon = varargin{2};
        Y = varargin{1};
    end
end
if sum(size(X) == size(Y)) ~= 3
    error('The size of X and Y must be equal.')
end

%% main
[n_ch, n_frame, n_freq] = size(X);
R = zeros(n_ch, n_ch, n_freq);
for f = 1:n_freq
    R(:, :, f) = X(:, :, f) * Y(:, :, f)' / n_freq + epsilon * eye(n_ch);
end
