function [good_behavior] = remove_bad_behavior_ver2_withoutvelocity(behavior, behavior_filepaths, lick_stop_flag)

close all
if lick_stop_flag==0
    lick_stop_frame = 1;
end
runs = behavior.ybinned;
sm_runs = smooth(behavior.ybinned);
diff_runs = [diff(sm_runs); 0];
time = behavior.t;

good_runs = [];
good_runs_index = [];
good_runs_time = [];

bad_runs = [];
bad_runs_index = [];
bad_runs_time = [];

thresh_min = 0.01;
thresh_max = 0.6;

count1 = 1;
count2 = 1;
count3 = 1;
i = 1;
end_lap = 1;

% Find starting point
if runs(1) > thresh_min
    while round(runs(i), 2) ~= thresh_min
        i = i + 1;
    end
end
start_point = i;
while i < size(runs, 2)
    % If velocity is positive and animal is at track position
    if diff_runs(i) > 0.0003
        %if it is end of lap, skip until beginning of lap
        if runs(i) > thresh_max
            while round(runs(i), 2) ~= thresh_min && diff_runs(i) > 0.0003
                i = i + 1;
                end_lap = i;
            end
        end
        if i > size(runs, 2)
            break;
        end
        good_runs_index(count1) = i;
        good_runs_time(count1) = time(i);
        good_runs(count1) = runs(i);
        count1 = count1+1;
    else
        bad_runs_index(count2) = i;
        bad_runs_time(count2) = time(i);
        bad_runs(count2) = runs(i);
        count2 = count2 + 1;
    end
    i = i +1;
end


figure;
subplot(4, 1, 1); plot(runs)
subplot(4, 1, 2); hold on; plot(runs); plot(good_runs_index, good_runs, '.'); hold off;
subplot(4, 1, 3); hold on; plot(runs); plot(bad_runs_index, bad_runs, '.'); hold off;
subplot(4, 1, 4); hold on; plot(good_runs);

good_behavior.good_runs = good_runs;
good_behavior.good_runs_index = good_runs_index;
good_behavior.freezing = bad_runs;
good_behavior.freezing_index = bad_runs_index;

% Save good behavior
if lick_stop_flag
    save([behavior_filepaths(1:end-4), '_good_behavior_after_lick_stops.mat'], 'good_behavior')
else
    save([behavior_filepaths(1:end-4), '_good_behavior.mat'], 'good_behavior')
end
end
