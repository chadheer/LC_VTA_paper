%%combine and analyze novel aligned data
%Chad Heer

%INPUTS
%Analysis_out = output of axon_analysis for all sessions
%above_SNR_thresh = ids of axons above threshold 
%SNR_thresh = SNR threshold 

%OUTPUTS

function[normalized_novel_aligned_F_smooth, combined_novel_aligned_Fc, combined_novel_aligned_F_good_beh, combined_novel_aligned_F2_good_beh, combined_novel_aligned_velocity, combined_novel_aligned_pupil, combined_id, normalized_dark_aligned_F, combined_dark_aligned_Fc, combined_dark_aligned_F_goodbeh, combined_dark_aligned_F2_goodbeh, dark_id, combined_novel_aligned_F_badbeh, combined_novel_aligned_F2_badbeh] = axon_novel_analysis(analysis_out, above_SNR_thresh, SNR_thresh)
session_names = fieldnames(analysis_out);


%%
%intialize variables
combined_novel_aligned_F = [];
combined_familiar_aligned_F = [];
combined_novel_aligned_Fc = [];
combined_novel_aligned_F_good_beh = [];
combined_novel_aligned_F2_good_beh = [];
combined_tonic_F = [];
combined_id = {};
session_names = fieldnames(analysis_out);
combined_dark_aligned_Fc = [];
combined_dark_aligned_F_goodbeh = [];
combined_dark_aligned_F = [];
combined_dark_aligned_F2_goodbeh = [];
dark_id = {};
combined_novel_aligned_F_badbeh = [];
combined_novel_aligned_F2_badbeh = [];
%for each session grab aligned data
for session = 1: length(session_names)
    above_SNR_thresh.(session_names{session}) = find(analysis_out.(session_names{session}).SNR >= SNR_thresh & ~ismember(1:length(analysis_out.(session_names{session}).SNR),analysis_out.(session_names{session}).tonic_rois));
    tonic_activity_rois.(session_names{session}) = find(analysis_out.(session_names{session}).SNR >= SNR_thresh & ismember(1:length(analysis_out.(session_names{session}).SNR),analysis_out.(session_names{session}).tonic_rois));

    combined_novel_aligned_F = [combined_novel_aligned_F analysis_out.(session_names{session}).novel_aligned_F(:,above_SNR_thresh.(session_names{session}))];
    combined_familiar_aligned_F = [combined_familiar_aligned_F analysis_out.(session_names{session}).familiar_aligned_F(:,above_SNR_thresh.(session_names{session}))];
    combined_novel_aligned_velocity(session,:)  = analysis_out.(session_names{session}).novel_aligned_velocity;
    combined_novel_aligned_pupil(session,:)  = analysis_out.(session_names{session}).novel_aligned_pupil;
    
    if any(~isnan(analysis_out.(session_names{session}).dark_aligned_F));
        combined_dark_aligned_F = [combined_dark_aligned_F analysis_out.(session_names{session}).dark_aligned_F(:,above_SNR_thresh.(session_names{session}))];
        combined_dark_aligned_Fc = [combined_dark_aligned_Fc analysis_out.(session_names{session}).dark_aligned_Fc(:,above_SNR_thresh.(session_names{session}))];
        combined_dark_aligned_F_goodbeh = [combined_dark_aligned_F_goodbeh analysis_out.(session_names{session}).dark_aligned_F_goodbeh(:,above_SNR_thresh.(session_names{session}))];
        combined_dark_aligned_F2_goodbeh = [combined_dark_aligned_F2_goodbeh analysis_out.(session_names{session}).dark_aligned_F2_goodbeh(:,above_SNR_thresh.(session_names{session}))];

        for i =1: size(above_SNR_thresh.(session_names{session}),2);
            dark_id = [dark_id; session_names{session}];
        end
    end

    combined_novel_aligned_Fc = [combined_novel_aligned_Fc analysis_out.(session_names{session}).novel_aligned_Fc(:,above_SNR_thresh.(session_names{session}))];
    combined_novel_aligned_F_good_beh = [combined_novel_aligned_F_good_beh analysis_out.(session_names{session}).novel_aligned_F_goodbeh(:,above_SNR_thresh.(session_names{session}))];
    combined_novel_aligned_F2_good_beh = [combined_novel_aligned_F2_good_beh analysis_out.(session_names{session}).novel_aligned_F2_goodbeh(:,above_SNR_thresh.(session_names{session}))];

    combined_novel_aligned_F_badbeh = [combined_novel_aligned_F_badbeh analysis_out.(session_names{session}).novel_aligned_F_badbeh(:,above_SNR_thresh.(session_names{session}))];
    combined_novel_aligned_F2_badbeh = [combined_novel_aligned_F2_badbeh analysis_out.(session_names{session}).novel_aligned_F2_badbeh(:,above_SNR_thresh.(session_names{session}))];
    combined_tonic_F = [combined_tonic_F analysis_out.(session_names{session}).novel_aligned_F(:,tonic_activity_rois.(session_names{session}))];

    %grab ids for all axons above SNR thresh
    for i =1: size(above_SNR_thresh.(session_names{session}),2);
        combined_id = [combined_id; session_names{session}];
    end
end


%make 0 values NaN
combined_novel_aligned_F(combined_novel_aligned_F == 0) = NaN;
combined_novel_aligned_F = combined_novel_aligned_F';
combined_novel_aligned_Fc(combined_novel_aligned_Fc == 0) = NaN;
combined_novel_aligned_F_good_beh(combined_novel_aligned_F_good_beh == 0) = NaN;
combined_novel_aligned_F2_good_beh(combined_novel_aligned_F2_good_beh == 0) = NaN;
combined_novel_aligned_F_badbeh(combined_novel_aligned_F_badbeh == 0) = NaN;
combined_novel_aligned_F2_badbeh(combined_novel_aligned_F2_badbeh == 0) = NaN;

combined_dark_aligned_F(combined_dark_aligned_F == 0) = NaN;
combined_dark_aligned_F = combined_dark_aligned_F';
combined_dark_aligned_Fc(combined_dark_aligned_Fc == 0) = NaN;
combined_dark_aligned_F_goodbeh(combined_dark_aligned_F_goodbeh == 0) = NaN;
combined_dark_aligned_F2_goodbeh(combined_dark_aligned_F2_goodbeh == 0) = NaN;

%noramlize data to mean of each axon
normalized_novel_aligned_F_smooth = combined_novel_aligned_F./nanmean(combined_novel_aligned_F(:,:)')';
normalized_novel_aligned_F_smooth(normalized_novel_aligned_F_smooth == 0) = NaN; 
combined_novel_aligned_F_good_beh = (combined_novel_aligned_F_good_beh./nanmean(combined_novel_aligned_F_good_beh))';
combined_novel_aligned_F_badbeh = (combined_novel_aligned_F_badbeh./nanmean(combined_novel_aligned_F_badbeh))';

normalized_dark_aligned_F = combined_dark_aligned_F./nanmean(combined_dark_aligned_F(:,:)')';
normalized_dark_aligned_F(normalized_dark_aligned_F == 0) = NaN; 
combined_dark_aligned_F_goodbeh = (combined_dark_aligned_F_goodbeh./nanmean(combined_dark_aligned_F_goodbeh))';




end