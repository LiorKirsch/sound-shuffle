function mainCreateShuffleSounds()

    s = RandStream('mcg16807','Seed',0);
    RandStream.setDefaultStream(s);

    
    Fs_rate = 44100;
    one_minute = Fs_rate * 60;
    permute_every_X_seconds = 0.04;
    
    soundsWithEqualSize = loadSoundsWithEqualSize('wav', one_minute);

    [shuffledSounds, permutationUsed] = shuffleSounds(soundsWithEqualSize, permute_every_X_seconds * Fs_rate);

    
    reversedPermutation = reversePermutation(permutationUsed);
    correctSounds = shuffleSounds(shuffledSounds, permute_every_X_seconds * Fs_rate, reversedPermutation);
    save('permutedSounds.mat', 'permutationUsed', 'shuffledSounds','permute_every_X_seconds','Fs_rate');
    saveSounds(shuffledSounds, Fs_rate, 'shuffled_wav');

end

function soundsWithEqualSize =  loadSoundsWithEqualSize(loadDir, numberOfSamplesToLoad)
    allfiles = dir(loadDir);
    numberOfFiles = length(allfiles);
    
    isFile=false(numberOfFiles,1);
    soundsWithEqualSize = nan(numberOfFiles,numberOfSamplesToLoad);
    for i = 1:length(allfiles)
       curr_file = allfiles(i).name; 

       if ~ismember(curr_file,{'.','..'} ) && ~allfiles(i).isdir 
           [y,Fs] = wavread(fullfile('wav',curr_file),numberOfSamplesToLoad);
           soundsWithEqualSize(i,:) = y(:,1); % only first channel
           isFile(i) = true;
       end

    end
    
    soundsWithEqualSize = soundsWithEqualSize(isFile,:);
end

function saveSounds(shuffledSounds, Fs_rate, saveDir)

     for i = 1:size(shuffledSounds,1)
       curr_file = sprintf('%s/%d.wav' , saveDir,i);
       wavwrite(shuffledSounds(i,:),Fs_rate,curr_file);
    end
end
