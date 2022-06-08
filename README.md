# Time-frequency-bin-wise linear combination (TFLC) beamformer for distortionless signal enhancement
This repository contains the codes for the TFLC beamformer and its variants.

Please cite the reference below if you use these codes for publication.

## Author
[Kouei Yamaoka](https://k-yamaoka.net/en/)

## Dependencies
The sample code uses reverberant signals obtained from the SiSEC UND task.

This repository does not contain codes for STFT.
In the sample code, I use [audioSignalProcessTools](https://github.com/d-kitamura/audioSignalProcessTools) for the STFT.

## Codes
- libTFLCbf/TFLCbf: TFLC beamformer and its variants (main)
- MVDRbf/*.m: codes for MVDR beamformer

### Sample code
- sample\_TFLCbf: sample code for the TFLC beamformer
  - TFS, TFLC, and RTFLC beamformers are included.

#### Parameters
The parameters (frlen, n_iter, and K) were experimentally analized in the reference.
- frlen: Frame length for STFT analysis
- frsft: Frame shift length for STFT analysis
- win: Name of the window function
- n_iter: The number of iterations for the TFLC beamformer and its variants
- K: The number of beamformers for the TFLC beamformers and its variants

### Test codes
- libTFLCbf/case*.m: Codes for computing beamformer selection mask
- libTFLCbf/test_case*.m: Codes for verifying the behavior of the above codes.

## References
- Kouei Yamaoka, Nobutaka Ono, and Shoji Makino, "Time-Frequency-Bin-Wise Linear Combination of Beamformers for Distortionless Signal Enhancement," IEEE/ACM Trans. Audio, Speech and Language Processing, vol.29, pp. 3461-3475, Nov. 2021. [[open access]](https://ieeexplore.ieee.org/document/9611020)
