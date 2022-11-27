load handel.mat

% this is sampling rate for part 1

sound_preperation('Speech.wav');
sound_preperation('Drum.wav');
sound_preperation('Birds.wav');


function sound_preperation(filename)
    [y,Fs] = audioread(filename);
    % 1.1: finding the sampling rate
    disp("The sampling rate for " + filename + " is: " + Fs);

% 1.2: If sound is stereo (n > 1), it will convert it to mono
[m, n] = size(y);
if n > 1
    y = sum(y, 2) / size(y, 2);
end

    %1.3 Play the sound from the sound files
    sound(y,Fs);

    %1.4 
    audiowrite("new" + filename,y,Fs);

    %1.5 
    [newY, newFs] = audioread("new" + filename);

    N = length(newY); % N is the number of samples
    dt = 1/newFs;
    time=(0:dt:(N*dt)-dt);  % Time vector on x-axis 
    plot(time,newY);xlabel('Sample Number (n)');ylabel('x(n)');title("Waveform of " + filename + " plotted against Sampling Number");

    %1.6 % downsample to 16KHz
    
    new_sample = resample(newY, 16000, Fs); 
    sound(new_sample);
    pause(4);
end