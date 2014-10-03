function main1()

    load('permutedSounds.mat', 'permutationUsed', 'shuffledSounds','permute_every_X_seconds','Fs_rate');
    audioSamplesInWindow = permute_every_X_seconds * Fs_rate;
    
    reversedPermutation = reversePermutation(permutationUsed);
    correctSounds = shuffleSounds(shuffledSounds, permute_every_X_seconds * Fs_rate, reversedPermutation);


    [correctingPerm, matching_costs] = calcDistanceBetweenWindows(correctSounds, audioSamplesInWindow);
    [correctingPerm2, matching_costs2] = calcDistanceBetweenWindows(shuffledSounds, audioSamplesInWindow);
    
    correctSounds_permuted = shuffleSounds(correctSounds, permute_every_X_seconds * Fs_rate, correctingPerm);
end


function [correctingPerm, matching_costs] = calcDistanceBetweenWindows(soundsWithEqualSize, shuffleWindowSize)

    [numberOfSounds, numberOfAudioSamples] = size(soundsWithEqualSize);
    number_of_windows = numberOfAudioSamples / shuffleWindowSize;
    
    matching_costs = nan(number_of_windows,1);
    correctingPerm = nan(numberOfSounds, number_of_windows);
    
    samplesIncurrentWindow = soundsWithEqualSize(:, 1:shuffleWindowSize);
    correctingPerm(:,1) = 1:numberOfSounds;
    start_index = 1 + shuffleWindowSize;
    end_index = 2* shuffleWindowSize;
        
    for i = 2:number_of_windows
        samplesInPreviousWindow = samplesIncurrentWindow;
        samplesInCurrentWindow = soundsWithEqualSize(:, start_index:end_index);

        distanceBetweenWindows =  calcDistanceBetweenVectors(samplesInCurrentWindow, samplesInPreviousWindow);
        
        [Matching,Cost] = Hungarian(distanceBetweenWindows);
        matching_costs(i) = Cost;
        [correctingPerm(:,i), ~] = find(Matching);
        
%         imagesc(Matching);
%         colormap(hot);
%         colorbar();
        
        calcDistanceBetweenVectors(samplesInCurrentWindow, samplesInPreviousWindow);
        start_index = start_index + shuffleWindowSize;
        end_index = min(end_index + shuffleWindowSize, numberOfAudioSamples);
        printPercentCounter(i, number_of_windows);
    end
    
end

function distanceBetweenVectors = calcDistanceBetweenVectors(audio_vectors_current_step, audio_vectors_previous_step)
    distanceBetweenVectors = pdist2(audio_vectors_current_step, audio_vectors_previous_step,'euclidean');
    
end