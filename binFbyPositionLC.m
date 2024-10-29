%% Bins fluorescent data into time and position bins, calculates Area under curve (AUC) for binned data, and finds the number of licks per lap
%Chad Heer; Sheffield lab

%INPUTS
%data = fluorescent data (either F or Fc) of single ROI to be binned
%behavior = single plane behavior data 
%trackLength = length of track in cms
%frames = frame numbers to be binned
%good behavior = single plane output of remove bad behavior script

%OUTPUTS
%lap_binmean_pos = position binned fluorescent data organized as lap x positional bin
%TbinMean = time binned fluorescent data organized as lap x time bin x roi
%lap_max_F = the max fluorescence x position on the track
%AUC = Area under curve of each laps fluorescent data
%time2reward = the time from start of the lap to reward delivery for laps
%postrewardtime = time from reward delivery to teleportation for each lap
%numlicks = number of licks for each lap

function[lap_binmean_pos, TbinMean] = binFbyPositionLC(data,behavior,trackLength, frames, normalize, good_behavior)

%calculate dt and acc and divide track into 5cm bins
F = data(frames,:)';
dt = behavior.t(2)-behavior.t(1);
acc = zeros(1,length(frames));
numbins = round(trackLength/5);

fields = fieldnames(behavior);
for field = 1: length(fields);
    if fields{field} == "fr"
        continue
    elseif fields{field} == "good_beh"
        continue
    end
    behavior.(fields{field}) = behavior.(fields{field})(:,frames);
end


reward = behavior.reward;

%remove laps < 50 frames
edges = unique(behavior.lap);
counts = histc(behavior.lap, edges);
short_laps = edges(counts <= 50);
for i = 1: length(short_laps)   
    behavior.ybinned(behavior.lap == short_laps(i)) = NaN;
end

%renumber laps

%bin position and obtain bin indexes
bin_edges = [0:max(behavior.ybinned)/numbins:max(behavior.ybinned)]; 
bin_indexes = discretize(behavior.ybinned, bin_edges);


behavior.lap = zeros(1,length(behavior.ybinned));
%find lap number 
BW = ones(size(bin_indexes));
BW(find(diff(bin_indexes)<-1)) = 0;
behavior.lap= bwlabel(BW);

behavior.lap(:,1) = 1;
for frame = 1: length(BW);
    if behavior.lap(frame) == 0;
        behavior.lap(frame) = behavior.lap(frame-1);
    end
end

behavior.lap(:,1) = 1;
behavior.lap(isnan(behavior.ybinned)) = NaN;

%initialize variables
ypos_lap = NaN(max(behavior.lap),3000);
F_lap = NaN(max(behavior.lap),3000);
trackstart=min(behavior.ybinned)+0.005; 
trackend=max(behavior.ybinned)-0.005; 
Pos_bin_edges = linspace(trackstart,trackend, numbins + 1); 
track_bins = linspace(0,trackLength, numbins+1);
binMean = zeros(max(behavior.lap),numbins,size(F,1));
lapreward = zeros(1,max(behavior.lap));



%%
for roi = 1:size(F,1)

    for i=1:max(behavior.lap)
        %find start, reward delivery, and end time for each lap, find the time taken to complete each lap and divide into equal time bins
        starttime(i) = behavior.t(find(behavior.lap(1:length(F)) == i, 1));
        endtime(i) = behavior.t(find(behavior.lap(1:length(F)) == i, 1, 'last'));
        TbinEdges = linspace(starttime(i), endtime(i), numbins + 1);

        laptime(roi,i) = endtime(i)-starttime(i);
        rewardtime = behavior.t(find((behavior.t >= starttime(i)) & (behavior.t < endtime(i)) & (reward == 1),1));
        
        %if there was no reward delivered on a given lap, equally divide
        %based off time of lap
       
        if ~isempty(rewardtime)
            time2reward(roi,i) = rewardtime-starttime(i);
            postrewardtime(roi,i) = endtime(i) - rewardtime;
            prereward = linspace(starttime(i), rewardtime, numbins -6);
            postreward = linspace(rewardtime, endtime(i), 8);
            TbinEdges = [prereward postreward(2:end)];
            
            num_licks(i) = sum(behavior.lick(find(behavior.t == starttime(i)):find(behavior.t == rewardtime)) >= 1);
        
        %if there is a reward delivery, divide the time to reward into 35
        %equal bins and the time after into 5 equal bins
        else
            TbinEdges = linspace(starttime(i), endtime(i), numbins + 1);
            time2reward(roi,i) = TbinEdges(numbins-6) - TbinEdges(1);
            postrewardtime(roi,i) = TbinEdges(numbins) - TbinEdges(numbins-6);
            
            rewardframe(i) = find(behavior.ybinned(behavior.lap == i) >= behavior.ybinned(find(behavior.t == endtime(i))),1); 
            num_licks(i) = sum(behavior.lick(find(behavior.t == starttime(i)):rewardframe(i)) >= 1);
        end
        
        %calculate the mean fluorescence for each time bin
        for j=1:numbins
            binmembers = (find((behavior.t >= TbinEdges(j)) & (behavior.t < TbinEdges(j+1))));
            binT = F(roi,binmembers);
            TbinMean(i,j,roi) = nanmean(binT);
            
            if (rewardtime >= TbinEdges(j)) & (rewardtime < TbinEdges(j+1));
                lapreward(i) = j;
            end
            
        end
    end
    
    %if good behavior variable exists, separate out good behavior
    if exist('good_behavior', 'var')
        behavior.lap((good_behavior.freezing_index(good_behavior.freezing_index >= frames(1) & good_behavior.freezing_index <= frames(end)))-frames(1)+1) = NaN;
        behavior.ybinned((good_behavior.freezing_index(good_behavior.freezing_index >= frames(1) & good_behavior.freezing_index <= frames(end)))-frames(1)+1) = NaN;
        F((good_behavior.freezing_index(good_behavior.freezing_index >= frames(1) & good_behavior.freezing_index <= frames(end)))-frames(1)+1) = NaN;
    end
    
    %find the mean fluorescencefor each positional bin, max fluorescence, and AUC for each lap
    for lap=1:max(behavior.lap)
        for bin=1:numbins
            %bin position
            binmembers = find((behavior.ybinned >= Pos_bin_edges(bin)) & (behavior.ybinned < Pos_bin_edges(bin+1)) & behavior.lap == lap);
            bin_pos = F(roi,binmembers);
            lap_binmean_pos(lap,bin,roi) = nanmean(bin_pos);
        end
        [lap_max_F(1,lap), idx] = max(F(roi,behavior.lap == lap)-min(F(roi,behavior.lap == lap)));
        lap_max_F(2,lap) = behavior.ybinned(idx);
        AUC(lap) = trapz(F(roi,behavior.lap == lap)-min(F(roi,behavior.lap == lap)));
    end
    
    for bin=1:numbins
        pos_SEM(bin) = nanstd(lap_binmean_pos(:,bin,roi))/sqrt(length(lap_binmean_pos(:,bin,roi)));
    end
   
    if normalize ==1;
        binmean_pos = nanmean(lap_binmean_pos(:,:,roi),1);
        
        norm_binmean_pos(:,roi) = binmean_pos/max(binmean_pos);
    
        binmean_time = nanmean(TbinMean(:,:,roi),1);
    
        norm_binmean_time(:,roi) = binmean_time/max(binmean_time);
    else

       norm_binmean_pos(:,roi) = nanmean(lap_binmean_pos,1);
       norm_binmean_time(:,roi) = nanmean(TbinMean(:,:,roi),1);

    end


    
end

end

    

    