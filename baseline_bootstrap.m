%% booststrap shuffled novel aligned activity to generate baseline activity
%Chad Heer

%INPUTS
%novel_data = novel aligned data
%ids = ids of each roi
%n_reps = number of times to repeat bootstrap
%x_units = time from novel exposure for each frame

%OUTPUTS 
%out = binary for if individual roi was above baseline or not

function [out] = baseline_bootstrap(novel_data, ids, n_reps, x_units)

n_shuffles = 1000;
n_reps = 1000;

%initialize shuffles 
shuffled_data = NaN(size(novel_data,1), n_shuffles, length(novel_data));

for roi = 1: size(novel_data,1)

    idx = find(~isnan(novel_data(roi,:)));

    %shuffle each roi n times
    for shuffle = 1: n_shuffles

        shuffled_ids{roi}(shuffle,:) = idx(randperm(length(idx)));

        shuffled_data(roi, shuffle,idx) = novel_data(roi, shuffled_ids{roi}(shuffle,:));

    end

end

sessions = unique(ids);

b = cellfun(@(x) sum(ismember(ids,x)), sessions, 'un', 0);

% proportions = round(n_reps * cell2mat(b)/ sum(cell2mat(b)));


%bootstrap shuffles down to population size n times keeping sampling
%statistics similar to actual data
for rep = 1: n_reps

    n = 1;

    for i = 1: length(b)
    
        rois = find(strcmp(ids, sessions(i)));
    
        subsamples(n: n + length(rois) - 1,:) = [randi([min(rois) max(rois)], b{i},1), randi(n_shuffles, b{i},1)];

        n = n + length(rois);
         
    end

    for i = 1: size(subsamples,1)

        sub_data(i,:) = shuffled_data(subsamples(i,1), subsamples(i,2),:);
    
    end
    
    mean_sub_data(rep,:) = nanmean(sub_data,1);
end


%calculate 95% CI
p = prctile(mean_sub_data, [2.5, 97.5]);
SEM = std(mean_sub_data);               % Standard Error
ts = tinv([0.025  0.975],size(mean_sub_data,1)-1);      % T-Score
CI = nanmean(mean_sub_data) + ts'.*SEM;

% Plot mean novel aligned data with bootstrapped data
figure; hold on
task = 1
h = plot(x_units, nanmean(mean_sub_data),'red', 'LineWidth',2, 'DisplayName', 'shuffled baseline')
j = patch([x_units fliplr(x_units)], [CI(1,:) fliplr(CI(2,:))],'r', 'DisplayName', '95% CI')
alpha(0.3)
legend('Location','southeast')
xlabel('frame number')
ylabel('normalized F')
plot(x_units, nanmean(novel_data,1), 'blue', 'LineWidth', 2, 'DisplayName', 'LC')
above_CI = nanmean(novel_data,1) > CI(2,:);
yyaxis right
plot(x_units, above_CI)

if size(novel_data,1) == 1;
    out = any(novel_data(200:209) > CI(2,200:209))
else
    out = [];
end

end
% 
% 

