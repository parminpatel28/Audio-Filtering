load handel.mat

numberOfSyllables("Speech.wav")
pause(7)

clf
numberOfBeats("Drum.wav")
pause(7)

clf
silentRegionBirds("Birds.wav")
pause(7)

function numOfSyllables = numberOfSyllables(filename)

    [y, Fs] = audioread("Speech.wav");
    
    %filter signal
    windowSize = 3;
    y = medfilt1(y, windowSize);
    
    %Breaking the sound into frames
    N = length(y);
    frameDuration = 0.045;
    lengthOfFrame = frameDuration*Fs; 
    totalFrames = floor(N/lengthOfFrame); %Round to integer value

    numOfSyllables = 0;
    isSyllable = false;

    %Go through all frames within signal and determine the amplitude in that
    %region
    for i=1:totalFrames
        
        %Every time we go through the loop, we extract the values from each
        %frame in the signal
        startingPoint = (i-1)*lengthOfFrame + 1;
        endingPoint = lengthOfFrame * i;

        frame = abs(y(startingPoint: endingPoint)); %
        meanAmplitude = mean(frame);
        
        %We want the average amplitude of the frame to be higher than the
        %minimum threshold amplitude to be considered a syllable
        if meanAmplitude > 0.015
            %

            %We only want new syllables to be added. Thus, if the previous
            %frame is not a syllable then we know it's a new one
            if isSyllable == false
                numOfSyllables = numOfSyllables + 1;
                isSyllable = true; 
            end
        
        else
            isSyllable = false;
        end
    end
    
    disp("The number of Syllables for Speech.wav is: " + numOfSyllables);
end

function numberOfBeats(filename)
    [y, Fs] = audioread(filename);
    windowSize = 3;

    %filter data
    y = medfilt1(y, windowSize);
    N = length(y); % N is the number of samples

    %The beats correspond to the number of syllables in the drum.wav file
    beats = numberOfSyllables("Drum.wav");
    
    %Determining the beats per second in the signal
    time_len = N/Fs;
    beatsPerSecond = beats/time_len;
    
    %Converting from beats per second to beats per minute
    bpm = beatsPerSecond * 60;

    disp( "The beats per min for Drum.wav is: " + bpm);
end



function silentRegionBirds()

    %disp(meanFilter("Birds.wav"));
    [y, Fs] = meanFilter("Birds.wav"); 
    original_signal = y;
    y = abs(y);
    frame_duration = 0.07;
    frame_len = frame_duration*Fs;
    N = length(y);
    num_frames = floor(N/frame_len);

    SilentSignal = zeros(N,1);
    count =0;

for k =1 : num_frames

    frame = y((k-1)*frame_len+1 : frame_len*k);

    mean_value = max(frame);

    % this frame is not silent
if (mean_value < 0.03)
    SilentSignal((k -1)* frame_len+1: frame_len * k) = 0.02;
    
else 
    count = count +1;
    SilentSignal((k -1)*frame_len+1: frame_len * k) = 0; 
    
end
end  

    % Plotting
    figure(3)
    dt = 1/Fs;
    time=(0:dt:(N*dt)-dt);  % Time vector on x-axis 
    plot(time,y);
    
    plot(original_signal, "r");xlabel('Time (seconds)');ylabel('Amplitude (dB)');title("Silent Region on Birds");
    hold on 
    
    positiveArea = area(SilentSignal);
    positiveArea.FaceColor = 'Blue';
    negativeArea = area (-SilentSignal);
    negativeArea.FaceColor = 'Blue';
    
    plot(SilentSignal, "b")
    legend(["Original Signal", " Silent Region"])
end 