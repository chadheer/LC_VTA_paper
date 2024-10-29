%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Bins F data by velocity.
%Chad Heer

%INPUTS
%data = struct with Fc data from axon analysis
%beh = struct with all behavioral variables 
%trackLength = length of track
%frames = matrix with frame numbers for each task
%tasks = task ids

%OUTPUTS
%data = data struct with appended binned data

function [data] = bin_velocity(data,beh,trackLength,frames,tasks)

%loop through different tasks
for task = 1: size(frames,2)
    fr = 30.98/3;
    %grab behavior for given task
    behavior = beh;
    fields = fieldnames(behavior);
    for field = 1: length(fields);
        if fields{field} == "fr"
            continue
        elseif fields{field} == "good_beh"
            behavior.good_beh.freezing_index = behavior.good_beh.freezing_index(find(behavior.good_beh.freezing_index >= frames{task}(1) & behavior.good_beh.freezing_index <= frames{task}(end))) - frames{task}(1) + 1;
            behavior.good_beh.good_runs_index = behavior.good_beh.good_runs_index(find(behavior.good_beh.good_runs_index >= frames{task}(1) & behavior.good_beh.good_runs_index <= frames{task}(end))) -frames{task}(1) + 1;

        else
            behavior.(fields{field}) = behavior.(fields{field})(:,frames{task});
        end
    end
    
    
    %remove laps that are shorter than 50 frames
    edges = unique(behavior.lap);
    counts = histc(behavior.lap, edges);
    short_laps = edges(counts <= 50);
    for i = 1: length(short_laps)   
        behavior.lap(behavior.lap == short_laps(i)) = NaN;
    end
   


    %initialize variables
    F = data.Fc(frames{task}, :)'; %normalize data to mean 
    dt = behavior.t(2)-behavior.t(1);
    acc = zeros(1,length(F));
    numbins = round(trackLength/5);
    binV = {};
    binA = {};
    bleb_binA = {};
    bleb_binV = {};
    lap_binnedV = [];
    VbinEdges = linspace(0, 60, numbins +1);
    reward = double_thresh(behavior.reward,1,10);
    
    
    %initialize variables
    ypos_lap = NaN(max(behavior.lap),3000);
    F_lap = NaN(max(behavior.lap),3000);
    trackstart=min(behavior.ybinned)+0.005; 
    trackend=max(behavior.ybinned)-0.005; 
    Pos_bin_edges = linspace(trackstart,trackend, numbins + 1); 
    track_bins = linspace(0,trackLength, numbins+1);
    binMean = zeros(max(behavior.lap),numbins,size(F,1));
    lapreward = zeros(1,max(behavior.lap));
    
    norm_binmean_pupil = NaN(1,numbins);
    Fvspupil_corr = NaN(2,2);
    
    %calculate acceleration

    acc = diff(behavior.velocity)/dt; 
    acc(length(F)) = 0;
  
%     
    %create bin edges for acceleration
    AbinEdges = linspace(-90, 90, numbins+1);
    
    %if it exists, find pupil bin edges

    %%
    cross_corr = [];
    for roi = 1:size(F,1)

        for i = 1:numbins
            %bin velocity 
            binmembers = find((behavior.velocity >= VbinEdges(i)) & (behavior.velocity < VbinEdges(i+1)));
            binV{i,roi}(:) = F(roi,binmembers);
            binmeanV(i) = nanmean(binV{i,roi}(:),1);
            VSEM(i) = std(binV{i,roi}(:))/sqrt(length(binV{i,roi}(:)));
            
            laps = [min(behavior.lap):max(behavior.lap)];

            for lap = 1:length(laps)
                binmembers = find((behavior.velocity >= VbinEdges(i)) & (behavior.velocity < VbinEdges(i+1) & behavior.lap == laps(lap)));;
               
                lap_binnedV(lap,i,roi) = nanmean(F(roi,binmembers));

            end

            %bin acceleration
            binmembers = find((acc >= AbinEdges(i)) & (acc < AbinEdges(i+1)));
            binA{i,roi}(:)= F(roi,binmembers);
            binmeanA(i) = nanmean(binA{i,roi}(:),1);
            ASEM(i) = std(binA{i,roi}(:))/sqrt(length(binA{i,roi}(:)));
               
        end
        
        i = 1;

        %normalize binned data
                
        norm_binmeanV = binmeanV/nanmean(binmeanV);
        
        norm_binmeanA = binmeanA/nanmean(binmeanA);
        

    end
    
    for lap = 1: length(laps);
        n_freeze = sum(ismember(behavior.good_beh.freezing_index, find(behavior.lap == laps(lap))));
        n_frames = sum(behavior.lap == laps(lap));
        freezing_ratio(lap) = n_freeze/n_frames;
    end

    %combine binned data for all rois
    max_n = max(cellfun(@max,(cellfun(@size,binA,'uni',false))), [], "all");
    binnedA = NaN(max_n, numbins, size(F,1));
    binnedV = binnedA;
    
    for i = 1:size(binV,1)
        for roi = 1:size(binV,2)
            binnedA(1:length(binA{i,roi}),i,roi) = binA{i,roi}(:);
            binnedV(1:length(binV{i,roi}),i,roi) = binV{i,roi}(:);
        end
    end
    
    %change bins == 0 to NaN
    binnedV(binnedV == 0) = NaN;
    binnedA(binnedA == 0) = NaN;
    lap_binnedV(lap_binnedV ==0) = NaN;
    
    %append binned data to data struct
    data.binnedA.(tasks{task}) = binnedA;
    data.binnedV.(tasks{task}) = binnedV;
    data.lap_binnedV.(tasks{task}) = lap_binnedV;
    data.lap_freezing.(tasks{task}) = freezing_ratio;
    
end
end
               

