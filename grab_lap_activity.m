function[mean_aligned_activity, aligned_activity, cell_id] = grab_lap_activity(analysis_out, samples, measure, grab_lap, range)


session_names = fieldnames(samples);

initiation_id = {};
region_lap = {}; 
norm_region_lap = {};
idx = 1;
id = [];
        
roi = 1;

frame_count = -1000:100;
for session = 1: length(session_names)

    num_rois = length(samples.(session_names{session}));
    
    if isstruct(analysis_out.(session_names{session}).(measure))

        tasks = fieldnames(analysis_out.(session_names{session}).(measure));

    end

    for task = 1: length(tasks)
        for axon = 1: num_rois

            frames = analysis_out.(session_names{session}).fr_from_reward.(tasks{task})(:,:,samples.(session_names{session})(axon));
            activity = analysis_out.(session_names{session}).lap_activity.(tasks{task})(:,:,samples.(session_names{session})(axon));
            
           for lap = 1: size(frames,1);
                aligned_activity.(tasks{task})(lap,:) = NaN(1,length(frame_count));
                idx = find(ismember(frame_count, frames(lap,:)));
                aligned_activity.(tasks{task})(lap,idx) = activity(lap,1:length(idx));
    
            end
            aligned_activity.(tasks{task})(aligned_activity.(tasks{task}) == 0) = NaN;
            mean_aligned_activity.(tasks{task})(:,roi+axon-1) = squeeze(nanmean(aligned_activity.(tasks{task}),1));
            cell_id.(tasks{task})(roi+axon-1) = session;
        end
    end
    roi = roi + num_rois;
end
end