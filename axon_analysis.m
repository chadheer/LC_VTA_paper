%%Initial analysis of individual axon recording sessions
%Chad Heer

%INPUTS
%data = data struct containing F, Fc, and Fc3
%behplane = cell array containing structs of each behavioral variable
%fam_laps = frames in familiar environment
%novel_laps = frames in novel environment
%novel_early = frames of initial laps in novel
%novel_late = frames late in novel environment
%plane = plane number to be analyzed
%id = id of recording session
%no_reward = frames where no reward was present
%rereward = frames where reward was reintroduced

%OUTPUT
%data = data struct with appended analysis 

function[data] = axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane, id, no_reward, rereward, dark)

data.behavior = behplane{plane};

% perform fft and find SNR by taking calcium transient frequencies/ non
% calcium transient frequencies 
data = find_axon_norm_psdx(data, size(behplane,2), 1:length(data.F));
data.fam = find_axon_norm_psdx(data, size(behplane,2), fam_laps);
if ~isempty(novel_laps)
    data.nov = find_axon_norm_psdx(data, size(behplane,2), novel_laps);
end

data.SNR = [];

for roi=1:size(data.F,2)
    data.SNR(:,end+1) = max(data.normalized_psdx(data.freq>0.05, roi));
end

%normalize data using max and min where max and min are 1st and 99th
%quantiles
data.Fc = (data.Fc - quantile(data.Fc, 0.01))./ (quantile(data.Fc, 0.99)- quantile(data.Fc, 0.01));

%find SNR for blebs
if isfield(data, 'blebs')
    data.blebs = find_axon_norm_psdx(data.blebs, size(behplane,2), 1:length(data.blebs.F))
    data.blebs.SNR = max(data.blebs.normalized_psdx(data.blebs.freq>0.05, :));
end


%detect ROIs with large changes in baseline
[sig_events, data.tonic_rois, tonic_start] = detect_axon_tonic_activity(data);

%initialize variables
data.novel_aligned_F = NaN(40000,size(data.F,2));
data.novel_aligned_Fc = data.novel_aligned_F;
data.novel_aligned_F_goodbeh = data.novel_aligned_F;
data.novel_aligned_F2_goodbeh = data.novel_aligned_F;
data.novel_aligned_F_goodbeh_idxed = data.novel_aligned_F;
data.novel_aligned_F_badbeh = data.novel_aligned_F;
data.novel_aligned_F2_badbeh = data.novel_aligned_F;
data.novel_aligned_F_badbeh_idxed = data.novel_aligned_F;

data.dark_aligned_F = NaN(40000,size(data.F,2));
data.dark_aligned_Fc = data.novel_aligned_F;
data.dark_aligned_F_goodbeh = data.novel_aligned_F;
data.dark_aligned_F2_goodbeh = data.novel_aligned_F;
data.dark_aligned_F_goodbeh_idxed = data.novel_aligned_F;

novel_activity_id = {};
combined_tonic_start = {};
data.novel_aligned_pupil = NaN(40000, 1);
data.novel_aligned_velocity = NaN(40000,1); 
data.familiar_aligned_F = NaN(15000,size(data.F,2));
behplane{plane}.time_in_env = NaN(1,length(data.F));
behplane{plane}.time_in_env(fam_laps) = 1:length(fam_laps);

%find absolute value of acceleration
behplane{plane}.acceleration = abs(behplane{plane}.acceleration);

%% grab f and align it to switch from dark to novel
if exist("dark", "var")
    
    data.dark_aligned_F(20000-length(dark):19999,:) = data.F(dark,:);
    data.dark_aligned_F(20000:19999 +length(fam_laps),:) = data.F([fam_laps],:);

    data.dark_aligned_Fc(20000-length(dark):19999,:) = data.Fc(dark,:);
    data.dark_aligned_Fc(20000:19999 + length(fam_laps),:) = data.Fc([fam_laps],:);

    dark_laps_goodbeh = dark(ismember(dark, behplane{plane}.good_beh.good_runs_index));
    fam_laps_goodbeh = fam_laps(ismember(fam_laps, behplane{plane}.good_beh.good_runs_index));
    data.dark_aligned_F_goodbeh(20000-length(dark_laps_goodbeh):19999,:) = data.F([dark_laps_goodbeh], :);
    data.dark_aligned_F_goodbeh(20000:19999 + length(fam_laps_goodbeh), :) = data.F([fam_laps_goodbeh], :);
    
    data.dark_aligned_F2_goodbeh(20000-length(dark_laps_goodbeh):19999,:) = data.F2([dark_laps_goodbeh],:);
    data.dark_aligned_F2_goodbeh(20000:19999 + length(fam_laps_goodbeh), :) = data.F2([fam_laps_goodbeh], :);
    
    data.dark_aligned_F_goodbeh_idxed([19999 - dark(end) + dark_laps_goodbeh],:) = data.F2([dark_laps_goodbeh], :);
    data.dark_aligned_F_goodbeh_idxed([20000 + fam_laps_goodbeh - fam_laps(1)],:) = data.F2([fam_laps_goodbeh], :);
end
%% grab F activity and velocity and align it to the switch to the novel environment
novel_activity_rois = [1:size(data.F,2)];

if ~isempty(novel_laps)
    for i=1: size(novel_activity_rois,2);
    
    %     combined_tonic_start{i} = tonic_start(i) - (fam_laps(end)-3000);
        if length(fam_laps) < 20000 & length(novel_laps) < 20000;
            data.novel_aligned_F(20000-length(fam_laps):19999,i) = data.F([fam_laps],novel_activity_rois(i));
            data.novel_aligned_F(20000:19999 + length(novel_laps),i) = data.F([novel_laps],novel_activity_rois(i));
            data.novel_aligned_Fc(20000-length(fam_laps):19999,i) = data.F2([fam_laps],novel_activity_rois(i));
            data.novel_aligned_Fc(20000:19999 + length(novel_laps),i) = data.F2([novel_laps],novel_activity_rois(i));
    
            fam_laps_goodbeh = fam_laps(ismember(fam_laps, behplane{plane}.good_beh.good_runs_index));
            novel_laps_goodbeh = novel_laps(ismember(novel_laps, behplane{plane}.good_beh.good_runs_index));
            
            data.novel_aligned_F_goodbeh(20000-length(fam_laps_goodbeh):19999,i) = data.F([fam_laps_goodbeh], novel_activity_rois(i));
            data.novel_aligned_F_goodbeh(20000:19999 + length(novel_laps_goodbeh), i) = data.F([novel_laps_goodbeh], novel_activity_rois(i));
    
            data.novel_aligned_F2_goodbeh(20000-length(fam_laps_goodbeh):19999,i) = data.F2([fam_laps_goodbeh], novel_activity_rois(i));
            data.novel_aligned_F2_goodbeh(20000:19999 + length(novel_laps_goodbeh), i) = data.F2([novel_laps_goodbeh], novel_activity_rois(i));
           
            fam_laps_badbeh = fam_laps(ismember(fam_laps, behplane{plane}.good_beh.freezing_index));
            novel_laps_badbeh = novel_laps(ismember(novel_laps, behplane{plane}.good_beh.freezing_index));
            
            data.novel_aligned_F_badbeh(20000-length(fam_laps_badbeh):19999,i) = data.F([fam_laps_badbeh], novel_activity_rois(i));
            data.novel_aligned_F_badbeh(20000:19999 + length(novel_laps_badbeh), i) = data.F([novel_laps_badbeh], novel_activity_rois(i));
    
            data.novel_aligned_F2_badbeh(20000-length(fam_laps_badbeh):19999,i) = data.F2([fam_laps_badbeh], novel_activity_rois(i));
            data.novel_aligned_F2_badbeh(20000:19999 + length(novel_laps_badbeh), i) = data.F2([novel_laps_badbeh], novel_activity_rois(i));
            
            data.novel_aligned_F_badbeh_idxed([19999 - fam_laps(end) + fam_laps_badbeh],i) = data.F2([fam_laps_badbeh], novel_activity_rois(i));
            data.novel_aligned_F_badbeh_idxed([20000 + novel_laps_badbeh - novel_laps(1)],i) = data.F2([novel_laps_badbeh], novel_activity_rois(i));
    


            data.novel_aligned_F_goodbeh_idxed([19999 - fam_laps(end) + fam_laps_goodbeh],i) = data.F2([fam_laps_goodbeh], novel_activity_rois(i));
            data.novel_aligned_F_goodbeh_idxed([20000 + novel_laps_goodbeh - novel_laps(1)],i) = data.F2([novel_laps_goodbeh], novel_activity_rois(i));
    
        end;
        novel_activity_id{i} = id;
        data.familiar_aligned_F(1:length(fam_laps),i) = data.F(fam_laps(1):fam_laps(end));
    end
    
    data.novel_aligned_velocity(20000-length(fam_laps):19999 + length(novel_laps)) = behplane{plane}.velocity(1,[fam_laps novel_laps]);
end

%find the mean lap F for familiar and novel laps 
familiar_laps = behplane{plane}.lap(fam_laps);
nov_laps = behplane{plane}.lap(novel_laps);

for roi = 1: size(data.F,2)
    fam_lap = 1;
    nov_lap = 1;
    for lap = 1: max(behplane{plane}.lap)
        lap_frames = find(behplane{plane}.lap == lap);
        lap_good_frames = lap_frames(ismember(lap_frames, behplane{plane}.good_beh.good_runs_index));
        lap_bad_frames = lap_frames(ismember(lap_frames, behplane{plane}.good_beh.freezing_index));

        if ismember(lap, familiar_laps)
            data.fam_lap_mean(fam_lap,roi) = nanmean(data.F(behplane{plane}.lap == lap,roi))/nanmean(data.F(:,roi));
            data.fam_lap_mean2(fam_lap,roi) = nanmean(data.F2(behplane{plane}.lap == lap,roi));

            data.fam_lap_v(fam_lap,roi) = nanmean(behplane{plane}.velocity(lap_good_frames));

            data.fam_lap_goodbeh(fam_lap,roi) = nanmean(data.F(lap_good_frames, roi))/nanmean(data.F(:,roi));
            data.fam_lap_goodbeh_F2(fam_lap,roi) = nanmean(data.F2(lap_good_frames, roi));

            data.fam_lap_badbeh(fam_lap,roi) = nanmean(data.F2(lap_bad_frames, roi));

            fam_lap = fam_lap +1;
            
           
        elseif ismember(lap, nov_laps)
            data.nov_lap_mean(nov_lap,roi) = nanmean(data.F(behplane{plane}.lap == lap,roi))/nanmean(data.F(:,roi));
            data.nov_lap_mean2(nov_lap,roi) = nanmean(data.F2(behplane{plane}.lap == lap,roi));

            data.nov_lap_v(nov_lap,roi) = nanmean(behplane{plane}.velocity(lap_good_frames));


            data.nov_lap_goodbeh(nov_lap,roi) = nanmean(data.F(lap_good_frames, roi))/nanmean(data.F(:,roi));
            data.nov_lap_goodbeh_F2(nov_lap,roi) = nanmean(data.F2(lap_good_frames, roi));

            data.nov_lap_badbeh(nov_lap,roi) = nanmean(data.F2(lap_bad_frames, roi));

            nov_lap = nov_lap + 1;
        end

    end
end

%loop through each task and find freezing ratio and position and time
%binned data for good_behavior
if ~isempty(novel_laps)
    tasks = {fam_laps, novel_laps, novel_early, novel_late}
    task_name = ["fam","novel", "nov_early", "nov_late"];
else
    tasks = {fam_laps};
    task_name = ["fam"];
end

if isfield(behplane{plane}, 'good_beh')
    for task =1: size(tasks,2)
        data.freezing_ratio.(task_name(task)) = sum(ismember(behplane{plane}.good_beh.freezing_index, tasks{task}))/length(tasks{task});
%         [data.good_beh_pos_binned_F.(task_name(task)), data.good_pos_binned_F_a.(task_name(task)), data.good_beh_time_binned_F.(task_name(task)), data.good_lap_activity.(task_name(task)), data.good_fr_from_reward.(task_name(task))] = bin_by_position(data.Fc, behplane{plane},300, tasks{task}(ismember(tasks{task}, behplane{plane}.good_beh.good_runs_index)),1);
    end

end

%bin F by velocity, acceleration and position, and align F to motion
%initiation and termination
if ~exist("rewarded", "var")
    rereward = [];
end
if ~exist("no_reward", "var")
    no_reward = [];
end

if ~isempty(rereward)
    data = bin_velocity(data, behplane{plane}, 300, {fam_laps, novel_laps, novel_early, novel_late, no_reward, rereward}, ["fam","novel", "novel_early", "novel_late", "no_reward", "rereward"]);
    data = align_to_motion(data, behplane{plane}, size(behplane,2),{fam_laps, novel_laps, novel_early, novel_late, no_reward, rereward}, ["fam","novel", "novel_early", "novel_late", "no_reward", "rereward"]);
    [data.pos_binned_F.no_reward, data.pos_bin_F_a.no_reward, data.time_binned_F.no_reward, data.lap_activity.no_reward, data.fr_from_reward.no_reward] = bin_by_position(data.Fc, behplane{plane},track_length, no_reward,1);
    [data.pos_binned_F.rereward, data.pos_bin_F_a.rereward, data.time_binned_F.rereward, data.lap_activity.rereward, data.fr_from_reward.rereward] = bin_by_position(data.Fc, behplane{plane},track_length, rereward,1);

elseif ~isempty(no_reward)
    data = bin_velocity(data, behplane{plane}, 300, {fam_laps, novel_laps, novel_early, novel_late, no_reward}, ["fam","novel", "novel_early", "novel_late", "no_reward"]);
    data = align_to_motion(data, behplane{plane}, size(behplane,2),{fam_laps, novel_laps, novel_early, novel_late, no_reward}, ["fam","novel", "novel_early", "novel_late", "no_reward"]);
    [data.pos_binned_F.no_reward, data.pos_bin_F_a.no_reward, data.time_binned_F.no_reward, data.lap_activity.no_reward, data.fr_from_reward.no_reward] = bin_by_position(data.Fc, behplane{plane},track_length, no_reward,1);

else
    data = bin_velocity(data, behplane{plane}, 300, tasks, task_name);
    data = align_to_motion(data, behplane{plane}, size(behplane,2),{fam_laps}, ["fam"]);

end

if ~isempty(novel_laps)
    [data.pos_binned_F.nov, data.pos_bin_F_a.nov, data.time_binned_F.nov, data.lap_activity.nov, data.fr_from_reward.nov] = bin_by_position(data.Fc, behplane{plane}, track_length, novel_laps,1);
    [data.pos_binned_F.nov_early, data.pos_bin_F_a.nov_early, data.time_binned_F.nov_early, data.lap_activity.nov_early, data.fr_from_reward.nov_early] = bin_by_position(data.Fc, behplane{plane}, track_length, novel_early,1);
    [data.pos_binned_F.nov_late, data.pos_bin_F_a.nov_late, data.time_binned_F.nov_late, data.lap_activity.nov_late, data.fr_from_reward.nov_late] = bin_by_position(data.Fc, behplane{plane}, track_length, novel_late,1);
%     [data.pos_binned_V.nov, data.time_binned_V.nov] = bin_by_position(behplane{plane}.velocity', behplane{plane}, track_length, novel_laps,0);
%     [data.pos_binned_V.nov_late, data.time_binned_V.nov_late] = bin_by_position(behplane{plane}.velocity', behplane{plane}, track_length, novel_late,0);
%     [data.pos_binned_V.nov_early, data.time_binned_V.nov_early] = bin_by_position(behplane{plane}.velocity', behplane{plane}, track_length, novel_early,0);
end

[data.pos_binned_F.fam, data.pos_bin_F_a.fam, data.time_binned_F.fam, data.lap_activity.fam, data.fr_from_reward.fam] = bin_by_position(data.Fc, behplane{plane},track_length, fam_laps,1);

[data.pos_binned_V.fam,data.pos_bin_V_a.fam, data.time_binned_V.fam, data.lap_velocity.fam, data.velocity_from_reward.fam] = bin_by_position(behplane{plane}.velocity',behplane{plane},track_length, fam_laps,0);



end