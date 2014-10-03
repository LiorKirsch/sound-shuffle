function [shuffledSounds, permutationToUse] = shuffleSounds(oneMinuteSounds, shuffleWindowSize, permutationToUse)

    [numberOfSounds, numberOfAudioSamples] = size(oneMinuteSounds);
    number_of_windows = numberOfAudioSamples / shuffleWindowSize;
    
    if ~exist('permutationToUse','var')
        permutationToUse = nan(numberOfSounds, number_of_windows);
        for i = 1:number_of_windows
            permutationToUse(:,i) = randperm(numberOfSounds);
        end
    end
    
    shuffledSounds = nan(size(oneMinuteSounds));
    start_index = 1;
    end_index = shuffleWindowSize;
    for i = 1:number_of_windows
        shuffle = permutationToUse(:,i);
        shuffledSounds(:, start_index:end_index) = oneMinuteSounds(shuffle, start_index:end_index);
        start_index = start_index + shuffleWindowSize;
        end_index = min(end_index + shuffleWindowSize, numberOfAudioSamples);
    end
end