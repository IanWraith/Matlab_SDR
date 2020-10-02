% This file reads in a WAV file containing I/Q data with a AM broadcast
% station in the centre and demodulates it.
% Ian Wraith (i.wraith@sheffield.ac.uk) 2nd October 2020

% Time the programs start time
tic;
% Raw IQ input file name
recordingFilename = '17570000Hz_20201001_091200_100KHz_wide_single.wav';
% Audio output file name
audioOutFilename = 'demodulated_audio.wav';
% Output volume setting
volume = 10;
% Read the input file
% rawSamples is the I and Q data in a matrix 
% sampleRate is the I/Q data sample rate
[rawSamples,sampleRate] = audioread(recordingFilename);
% Display the sample rate of the input file
fprintf ("\nThe sample rate of the input file is %d Hz",sampleRate);
% How many samples are in the matrix
[samples , channels] = size(rawSamples);
fprintf ("\nIt contains %d samples and %d channels\n",samples,channels);
% Preallocate an array which will hold the AM demodulated waveform.
amDemod = zeros(1, samples);
% Now we need to AM demodulate all of this by running through each raw
% sample using a for/next loop.
for i=1 : samples
    % rawSamples(i,1) is the I data
    % rawSamples(i,2) is the Q data
    % AM demodulate by finding the square root of I squared + Q squared
    amDemod(i) = sqrt((rawSamples(i,1)^2) + (rawSamples(i,2)^2));
    % Multiply by the volume to make this louder
    amDemod(i) = amDemod(i)*volume;
end
% Filter the demodulated samples through a 10.0 KHz low pass filter this
% removes noise and interference. 
filteredDemod = lowpass(amDemod,10000,sampleRate);
% No we need to change the sample rate down to 22050 Hz which is a commonly
% supported audio rate. It would be nice to sample down to 11025 Hz or even 
% 8000 Hz but the resample function won't allow that.
filteredAudio = resample(filteredDemod,22050,sampleRate);
% Write the demodulated , filtered and resampled data to a WAV file
audiowrite(audioOutFilename,filteredAudio,22050);
% Show how long the program took to execute
toc;