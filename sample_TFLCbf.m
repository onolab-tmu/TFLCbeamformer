%% Sample program for TFLC beamformers
%%
%% coded by K. Yamaoka (yamaoka-kouei@ed.tmu.ac.jp)
%%
%% Ref: Kouei Yamaoka, Nobutaka Ono, and Shoji Makino,
%%      "Time-Frequency-Bin-Wise Linear Combination of
%%      Beamformers for Distortionless Signal Enhancement,"
%%      IEEE/ACM Trans. Audio, Speech and Language Processing,
%%      vol.29, pp. 3461–3475, Nov. 2021.
%%

% initialize
clear
addpath('audioSignalProcessTools')
addpath('MVDRbf')
addpath('libTFLCbf')

% parameters
frlen = 2048;                           % Frame length for STFT analysis
frsft = frlen / 2;                      % Frame shift length
win = 'hamming';                        % Name of the window function

% parameters for TFLC beamformers
n_iter = 10;                            % The number of iterations for the TFLC beamformers
K = 3;                                  % The number of beamformers for the TFLC beamformers

% load sources
[s1, fs] = audioread('data/dev1_female4_liverec_130ms_5cm_sim_1.wav');
s2 = audioread('data/dev1_female4_liverec_130ms_5cm_sim_2.wav');
s3 = audioread('data/dev1_female4_liverec_130ms_5cm_sim_3.wav');
s4 = audioread('data/dev1_female4_liverec_130ms_5cm_sim_4.wav');
siglen = length(s1);
hsiglen = siglen / 2;

% separate them into training and test data
s1_1 = s1(1:hsiglen, :);
s2_1 = s2(1:hsiglen, :);
s3_1 = s3(1:hsiglen, :);
s4_1 = s4(1:hsiglen, :);
s1_2 = s1(hsiglen + 1:end, :);
s2_2 = s2(hsiglen + 1:end, :);
s3_2 = s3(hsiglen + 1:end, :);
s4_2 = s4(hsiglen + 1:end, :);

% mix
x = s1 + s2 + s3 + s4;
x_1 = x(1:hsiglen, :);
x_2 = x(hsiglen + 1:end, :);

% STFT
[S1_1, awin, ~] = STFT(s1_1, frlen, frsft, win);
S2_1 = STFT(s2_1, frlen, frsft, win);
S3_1 = STFT(s3_1, frlen, frsft, win);
S4_1 = STFT(s4_1, frlen, frsft, win);
X_1 = STFT(x_1, frlen, frsft, win);

S1_2 = STFT(s1_2, frlen, frsft, win);
S2_2 = STFT(s2_2, frlen, frsft, win);
S3_2 = STFT(s3_2, frlen, frsft, win);
S4_2 = STFT(s4_2, frlen, frsft, win);
X_2 = STFT(x_2, frlen, frsft, win);

% permutation
S1_1 = permute(S1_1, [3, 2, 1]);
S2_1 = permute(S2_1, [3, 2, 1]);
S3_1 = permute(S3_1, [3, 2, 1]);
S4_1 = permute(S4_1, [3, 2, 1]);
X_1  = permute(X_1, [3, 2, 1]);

S1_2 = permute(S1_2, [3, 2, 1]);
S2_2 = permute(S2_2, [3, 2, 1]);
S3_2 = permute(S3_2, [3, 2, 1]);
S4_2 = permute(S4_2, [3, 2, 1]);
X_2  = permute(X_2, [3, 2, 1]);

%% enhancement section
% linear beamformings
% MVDR
target = S1_1;
interfs = S2_1 + S3_1 + S4_1;
mix = X_2;
Y_MVDR = MVDRbf(mix, target, interfs);

% MPDR
target = S1_1;
mix = X_2;
Y_MPDR = MVDRbf(mix, target);

% TFLC beamformers
target = S1_1;
interfs = S2_1 + S3_1 + S4_1;           % TFLC of MVDR beamformer
% interfs = X_1;                        % TFLC of MPDR beamformer
mix = X_2;
RTF = calcRTF(target);                  % relative transfer function
Y_TFS = TFLCbf(mix, RTF, interfs, n_iter, K, 'TFS');
Y_TFLC = TFLCbf(mix, RTF, interfs, n_iter, K, 'TFLC');
Y_RTFLC = TFLCbf(mix, RTF, interfs, n_iter, K, 'RTFLC');

%% output section
% permutation
Y_MVDR = permute(Y_MVDR, [3, 2, 1]);
Y_MPDR = permute(Y_MPDR, [3, 2, 1]);
Y_TFS = permute(Y_TFS, [3, 2, 1]);
Y_TFLC = permute(Y_TFLC, [3, 2, 1]);
Y_RTFLC = permute(Y_RTFLC, [3, 2, 1]);

% inverse STFT
y_mvdr = ISTFT(Y_MVDR, frsft, awin, hsiglen);
y_mpdr = ISTFT(Y_MPDR, frsft, awin, hsiglen);
y_tfs = ISTFT(Y_TFS, frsft, awin, hsiglen);
y_tflc = ISTFT(Y_TFLC, frsft, awin, hsiglen);
y_rtflc = ISTFT(Y_RTFLC, frsft, awin, hsiglen);

% save
audiowrite('y_mvdr.wav', y_mvdr, fs);
audiowrite('y_mpdr.wav', y_mpdr, fs);
audiowrite('y_tfs.wav', y_tfs, fs);
audiowrite('y_tflc.wav', y_tflc, fs);
audiowrite('y_rtflc.wav', y_rtflc, fs);

