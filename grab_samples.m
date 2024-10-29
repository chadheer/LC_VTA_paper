function[region, region_lap, initiation_id, cell_id] = grab_samples(analysis_out, samples, measure, grab_lap, range)

session_names = fieldnames(samples);

initiation_id = {};
region_lap = {}; 
norm_region_lap = {};
idx = 1;
id = [];


for session = 1: length(session_names)

    num_rois = length(samples.(session_names{session}));
    
    if isstruct(analysis_out.(session_names{session}).(measure))

        tasks = fieldnames(analysis_out.(session_names{session}).(measure));

        for task = 1: length(tasks)


            if measure == "reward_psth";
               analysis_out.(session_names{session}).(measure).(tasks{task}) = analysis_out.(session_names{session}).(measure).(tasks{task}).F';
            end

            analysis_out.(session_names{session}).(measure).(tasks{task})(analysis_out.(session_names{session}).(measure).(tasks{task}) == 0) = NaN; 

            dim = size(analysis_out.(session_names{session}).(measure).(tasks{task}));
            
            if isempty(analysis_out.(session_names{session}).(measure).(tasks{task}))

                region.(tasks{task})(:,idx:idx + num_rois - 1) = NaN(size(region.(tasks{1}),1), num_rois);

               if grab_lap == 1;
                   region_lap.(tasks{task})(1,:,idx:idx + num_rois -1) = NaN(1,size(region.(tasks{1}),1),num_rois);
               end

            
            elseif dim(end) ~= size(analysis_out.(session_names{session}).F,2) | ndims(analysis_out.(session_names{session}).(measure).(tasks{task})) == 3;

                region.(tasks{task})(:,idx:idx + num_rois - 1) = nanmean(analysis_out.(session_names{session}).(measure).(tasks{task})(:,:,samples.(session_names{session})),1);

                cell_id.(tasks{task})(idx:idx + num_rois - 1) = session;
                
                if grab_lap == 1;

                    for lap = 1: size(analysis_out.(session_names{session}).(measure).(tasks{task}),1)
                        
                        region_lap.(tasks{task})(lap,:, idx:idx + num_rois -1) =  analysis_out.(session_names{session}).(measure).(tasks{task})(lap,:,samples.(session_names{session}));

                        if measure == "initiationF"

                            initiation_id{task}(lap,:,idx:idx + num_rois -1) = repmat(squeeze(analysis_out.(session_names{session}).initiation_id.(tasks{task})(lap,:))', 1,num_rois); 
                        end
    
                    end
                    
                end
            
            else

                region{task}(:,idx:idx + num_rois - 1) = analysis_out.(session_names{session}).(measure).(tasks{task})(:,samples.(session_names{session}));
                cell_id{task}(:,idx:idx + num_rois - 1) = session;

            end
        end

    else

        region(:,idx:idx + num_rois -1) = analysis_out.(session_names{session}).(measure)(:,samples.(session_names{session}));
    
    end

    idx = idx + num_rois;

    if grab_lap == 1;
        region_lap.(tasks{task})(region_lap.(tasks{task}) == 0) = NaN;
    end


end

%%normalize data using max and min values in fam
maxF = max(region.(tasks{1})(:,:));
minF = min(region.(tasks{1})(:,:));

for task = 1: length(tasks)
    if grab_lap == 1;
        region_lap.(tasks{task})(region_lap.(tasks{task}) == 0) = NaN;
        if measure == "initiationF"
            initiation_id{task}(initiation_id{task} == 0) = NaN;
        end
    end
    norm_region.(tasks{task}) = (region.(tasks{task}))./(maxF);
    if grab_lap == 1
        for lap = 1:size(region_lap.(tasks{task}),1)
            norm_region_lap.(tasks{task})(lap,:,:) = (squeeze(region_lap.(tasks{task})(lap,:,:)))./ (maxF);
        end
    end
    
end
