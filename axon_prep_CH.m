%%
function [behplane,data] = axon_prep(data, behplane, plane, track_length, nov_environment, pupil, dark, goodbeh, blebs) 
%day2
%plane 3 by hand like Losonczy analysis
load(data);
load(behplane);

load('C:\Users\Sheffield_lab\Documents\analysis\NETcre\spline_basis30_int.mat')


%determine if any ROIs should be combined

plane_coef = corrcoef(data.F);
coef_thresh = 0.6; 
corr_rois = {};

for roi = 1: length(plane_coef)
    if any(find([corr_rois{:}] == roi))
        
    elseif any(ismember(find(plane_coef(roi,:)>coef_thresh),[corr_rois{:}]))
        above_thresh = find(plane_coef(roi,:)>coef_thresh);
        logic_index = ismember(above_thresh,[corr_rois{:}]);
        combine_with = above_thresh(logic_index);
        cell2combine = cellfun(@(c) any(ismember(c, combine_with)), corr_rois, 'uniform', false);
        corr_rois{1,find([cell2combine{:}] == 1,1)} = [corr_rois{1,find([cell2combine{:}] == 1,1)},roi];
    else
        corr_rois{end+1} = find(plane_coef(roi,:)>coef_thresh);
        
    end
end

% find Fc using a large sliding window
data.F2 = FtoFc(data.F, 2000);

%determine the lap for each time point
bins = 100;
%bin position and obtain bin indexes
bin_edges = [0:max(behplane{plane}.ybinned)/bins:max(behplane{plane}.ybinned)]; 
bin_indexes = discretize(behplane{plane}.ybinned, bin_edges);

behplane{plane}.lap = zeros(1,length(behplane{plane}.ybinned));
%find lap number 
BW = ones(size(bin_indexes));
BW(find(diff(bin_indexes)<-1)) = 0;

for frame = 1: length(BW)-1;
    if BW(frame) == 0 & BW(frame + 1) == 0;
        BW(frame) = 1;
    end
end

behplane{plane}.lap = bwlabel(BW); 
behplane{plane}.lap(behplane{plane}.lap == 0) = behplane{plane}.lap(find(behplane{plane}.lap == 0) - 1);

%discretize reward and licking variables
behplane{plane}.reward(behplane{plane}.reward < (nanmean(behplane{plane}.reward) + 2 * std(behplane{plane}.reward))) = 0;
behplane{plane}.lick(behplane{plane}.lick < (nanmean(behplane{plane}.lick) + 2 * std(behplane{plane}.lick))) = 0;


%rescale ybinned and velocity to cm and cm/s
behplane{plane}.ybinned = rescale(behplane{plane}.ybinned, 0, track_length);
dt = behplane{plane}.t(2)-behplane{plane}.t(1);
velocity(2:length(behplane{plane}.ybinned)) = diff(behplane{plane}.ybinned)/dt;
velocity(1) = 0;
velocity(velocity < 0) = 0; 
vel = behplane{plane}.velocity;
% vel = vel - median(vel);
p = polyfit(vel, velocity,1);
velfit = polyval(p, vel);
velfit(velfit < 0) = 0;

%smooth velocity
behplane{plane}.velocity = smooth(velocity,7,'sgolay',5)';


behplane{plane}.lick(behplane{plane}.lick > 0.1) = 1;

%define moving periods
behplane{plane}.moving = behplane{plane}.velocity >= 10; 


%load in good behavior data
if exist('goodbeh', 'var')
    if ~isempty(goodbeh)
        load(goodbeh);
        behplane{plane}.good_beh = good_behavior;
    end
end

%load in bleb data and convert Fc for long period
if exist('blebs', 'var')
    bleb = load(blebs);
    data.blebs = bleb.data;
    data.blebs.F2 = FtoFc(data.blebs.F, 2000);
end

