load handel.mat

meanFilter("Birds.wav")
clf
pause(7)
meanFilter("Speech.wav")
clf 
pause(7)
meanFilter("Drum.wav")
clf
pause(7)

clf 
gaussianFilter("Birds.wav")
clf
pause(7)
gaussianFilter("Speech.wav")
clf 
pause(7)
gaussianFilter("Drum.wav")
clf
pause(7)

clf 
medianFilter("Birds.wav")
clf
pause(7)
medianFilter("Speech.wav")
clf 
pause(7)
medianFilter("Drum.wav")
clf
pause(7)

function [data, Fs1] = meanFilter(filename)
    [y,Fs] = audioread(filename);
    sound(y, Fs);
    [m, n] = size(y);

% convert to Mono if its stero
if n > 1
    y = sum(y, 2) / size(y, 2);
end

% get the correct window size for the file inputted
if filename == "Birds.wav"
    windowSize = 3;
elseif filename == "Speech.wav"
    windowSize = 25;
else 
    windowSize = 3;
end 
    %Filtering using convolution
    meanFilteredSignal = conv(y, ones(1,windowSize)/windowSize, 'full');

    %Plotting
    N = length(y); % N is the number of samples
    dt = 1/Fs;
    time=(0:dt:(N*dt)-dt);  % Time vector on x-axis 
    plot(time,y);xlabel('Time');ylabel('Sampling Number');title( "Mean Filter on: " +filename);

    % we will have a if statement here to have different windowsize for
    % diff files 
    figure(1)
    plot(y, "r")
    hold on;
    plot(meanFilteredSignal, "b")
    legend(["Original Signal", " Mean Filtered Signal"]);
    pause(10);
    sound(meanFilteredSignal, Fs);

    % return the values
    data = meanFilteredSignal;
    Fs1 = Fs;
end 


function [data, Fs1] = gaussianFilter(filename)

    [y,Fs] = audioread(filename);
    sound(y, Fs)

   % Convert to mono  
    [m, n] = size(y);
if n > 1
    y = sum(y, 2) / size(y, 2);
end

%Window Size configuration
if filename == "Birds.wav"
    windowSize = 40;
elseif filename == "Speech.wav"
    windowSize = 20;
else 
    windowSize = 4;
end 
    %Filtering
    weight = gausswin(windowSize, 1);
    weight = weight/sum(weight);
    gaussianFiltered = filter(weight, 1, y);

    % Plotting
    N = length(y); % N is the number of samples
    dt = 1/Fs;
    time=(0:dt:(N*dt)-dt);  % Time vector on x-axis 
    plot(time,y);xlabel('Time');ylabel('Sampling Number');title( "Gaussian Filter on: " + filename);
    
    plot(y, "r")
    hold on;
    plot(gaussianFiltered, "b")
    legend(["Original Signal", " Gaussian Filtered Signal"])
    pause(5)
    sound(gaussianFiltered, Fs)
    
    % return values
    data = gaussianFiltered;
    Fs1 = Fs;
end 



function [data, Fs1] = medianFilter(filename) 
    [y,Fs] = audioread(filename);
    sound(y, Fs);

% Convert to mono
    [m, n] = size(y);
if n > 1
    y = sum(y, 2) / size(y, 2);
end

% Window Size configuration
if filename == "Birds.wav"

    windowSize = 2;
elseif filename == "Speech.wav"

    windowSize = 3;

else 
    windowSize = 3;
end 
    
    % Applying median filter
    medianFilteredSignal = medfilt1(y,windowSize);

    % Plotting
    N = length(y); % N is the number of samples
    dt = 1/Fs;
    time=(0:dt:(N*dt)-dt);  % Time vector on x-axis 
    plot(time,y);xlabel('Time');ylabel('Sampling Number');title("Median Filter on: " + filename);

    plot(y, "r");
    hold on;
    plot(medianFilteredSignal, "b");
    legend(["Original Signal", " Median Filtered Signal"]);
    pause(5);
    sound(medianFilteredSignal, Fs);

    % Return values
    data = medianFilteredSignal;
    Fs1 = Fs;
end 