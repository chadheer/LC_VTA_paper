%%bootstrap and plot lap binned novel data. 
%Chad Heer

%INPUTS
%analysis_out = output of axon_analysis for all rois
%above_SNR_thresh = ids of rois above threshhold
%ids = ids of rois

%OUTPUTS 
%axons above bootstrapped baseline


function [out2] = axon_lap_binned(analysis_out, above_SNR_thresh, ids)

%%
session_names = fieldnames(above_SNR_thresh);

%find number of fam and novel laps
for session = 1: length(session_names)
    if isfield(analysis_out.(session_names{session}), "nov_lap_mean")
        num_fam_laps(session) = size(analysis_out.(session_names{session}).fam_lap_mean,1);
        num_nov_laps(session) = size(analysis_out.(session_names{session}).nov_lap_mean,1);
    end
end


%grab novel aligned lap binned data for each roi
idx = 1;
for session = 1: length(session_names)
    if size(fieldnames(analysis_out.(session_names{session}).lap_freezing),1) > 1
        num_rois = size(above_SNR_thresh.(session_names{session}),2);
    
        novel_aligned_lap_means(max(num_fam_laps) - num_fam_laps(session) + 1:max(num_fam_laps), idx:idx + num_rois - 1) = analysis_out.(session_names{session}).fam_lap_mean(:,above_SNR_thresh.(session_names{session}));
        novel_aligned_lap_means(max(num_fam_laps) + 1:max(num_fam_laps) + num_nov_laps(session), idx:idx + num_rois - 1) = analysis_out.(session_names{session}).nov_lap_mean(:,above_SNR_thresh.(session_names{session}));
    
    
        novel_aligned_lap_means2(max(num_fam_laps) - num_fam_laps(session) + 1:max(num_fam_laps), idx:idx + num_rois - 1) = analysis_out.(session_names{session}).fam_lap_mean2(:,above_SNR_thresh.(session_names{session}));
        novel_aligned_lap_means2(max(num_fam_laps) + 1:max(num_fam_laps) + num_nov_laps(session), idx:idx + num_rois - 1) = analysis_out.(session_names{session}).nov_lap_mean2(:,above_SNR_thresh.(session_names{session}));
    
        novel_aligned_lap_means_good(max(num_fam_laps) - num_fam_laps(session) + 1:max(num_fam_laps), idx:idx + num_rois - 1) = analysis_out.(session_names{session}).fam_lap_goodbeh(:,above_SNR_thresh.(session_names{session}));
        novel_aligned_lap_means_good(max(num_fam_laps) + 1:max(num_fam_laps) + num_nov_laps(session), idx:idx + num_rois - 1) = analysis_out.(session_names{session}).nov_lap_goodbeh(:,above_SNR_thresh.(session_names{session}));
    
        novel_aligned_lap_means_good_F2(max(num_fam_laps) - num_fam_laps(session) + 1:max(num_fam_laps), idx:idx + num_rois - 1) = analysis_out.(session_names{session}).fam_lap_goodbeh_F2(:,above_SNR_thresh.(session_names{session}));
        novel_aligned_lap_means_good_F2(max(num_fam_laps) + 1:max(num_fam_laps) + num_nov_laps(session), idx:idx + num_rois - 1) = analysis_out.(session_names{session}).nov_lap_goodbeh_F2(:,above_SNR_thresh.(session_names{session}));
    
        novel_aligned_lap_v(max(num_fam_laps) - num_fam_laps(session) + 1:max(num_fam_laps), session) = analysis_out.(session_names{session}).fam_lap_v(:,1);
        novel_aligned_lap_v(max(num_fam_laps) + 1:max(num_fam_laps) + num_nov_laps(session), session) = analysis_out.(session_names{session}).nov_lap_v(:,1);
        
        novel_aligned_freezing(max(num_fam_laps) - length(analysis_out.(session_names{session}).lap_freezing.fam) + 1:max(num_fam_laps), session) = analysis_out.(session_names{session}).lap_freezing.fam;
        novel_aligned_freezing(max(num_fam_laps) + 1:max(num_fam_laps) + length(analysis_out.(session_names{session}).lap_freezing.novel), session) = analysis_out.(session_names{session}).lap_freezing.novel;
        
    
        novel_aligned_lap_means_bad(max(num_fam_laps) - num_fam_laps(session) + 1:max(num_fam_laps), idx:idx + num_rois - 1) = analysis_out.(session_names{session}).fam_lap_badbeh(:,above_SNR_thresh.(session_names{session}));
        novel_aligned_lap_means_bad(max(num_fam_laps) + 1:max(num_fam_laps) + num_nov_laps(session), idx:idx + num_rois - 1) = analysis_out.(session_names{session}).nov_lap_badbeh(:,above_SNR_thresh.(session_names{session}));
    
    
        idx = idx + num_rois;

    else
        hi = 1
    end


end

%set data ==0 to NaN
novel_aligned_lap_means(novel_aligned_lap_means == 0) = NaN; 
novel_aligned_lap_means2(novel_aligned_lap_means2 == 0) = NaN; 
novel_aligned_lap_means_good(novel_aligned_lap_means_good == 0) = NaN; 
novel_aligned_lap_means_good_F2(novel_aligned_lap_means_good_F2 == 0) = NaN; 
novel_aligned_lap_means_bad(novel_aligned_lap_means_bad == 0) = NaN; 
novel_aligned_lap_v(novel_aligned_lap_v == 0) = NaN

% fig 3aiii
range = [max(num_fam_laps)-1 max(num_fam_laps)+1:max(num_fam_laps) + 10];
x_units = -max(num_fam_laps)+1:(max(num_nov_laps));
novel_aligned_lap_v_cell{1} = novel_aligned_lap_v(range,:)';
make_boxplot(novel_aligned_lap_v(range,:)');
range = [max(num_fam_laps)-9:max(num_fam_laps)-1  max(num_fam_laps)+1:max(num_fam_laps) + 10];
novel_aligned_lap_v_cell{1} = novel_aligned_lap_v(range,:)';
plot_with_errorbars(novel_aligned_lap_v_cell, ["velocity"], 1:length(range), x_units)
ylim([0 45])

range = [max(num_fam_laps)-1 max(num_fam_laps)+1:max(num_fam_laps) + 10];
x_units = -max(num_fam_laps)+1:(max(num_nov_laps));
novel_aligned_freezing(novel_aligned_freezing == 0) = NaN
novel_aligned_freezing_cell{1} = novel_aligned_freezing(range,:)';
make_boxplot(novel_aligned_freezing(range,:)');
range = [max(num_fam_laps)-9:max(num_fam_laps)-1  max(num_fam_laps)+1:max(num_fam_laps) + 10];
novel_aligned_freezing_cell{1} = novel_aligned_freezing(range,:)';
plot_with_errorbars(novel_aligned_freezing_cell, ["freezing_ratio"], 1:length(range), x_units)
ylim([0 .7])

%fig 3d left
x_units = -max(num_fam_laps)+1:(max(num_nov_laps));
[out] = baseline_bootstrap(novel_aligned_lap_means', ids, 1000, x_units)
xlim([-5 10])

%fig 4 d
[out2] = baseline_bootstrap(novel_aligned_lap_means_good', ids, 1000, x_units)
xlim([-5 10])


