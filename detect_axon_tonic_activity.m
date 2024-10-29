%% Detect rois that have large shift in baseline using cusum
% Chad Heer

%INPUT
%data = must be struct with field F data from axon analysis

%OUTPUT
%sig_events = events where baseline significantly shifts
%tonic_activity_roi = ID of axon with tonic activity
%tonic_start = frame where shift in baseline occurs

function[sig_events, tonic_activity_roi, tonic_start] = detect_axon_tonic_activity(data)

% initialize variables
tonic_activity_roi = [];
tonic_start = [];
F_mean = zeros(length(data.F),1);
F_std = F_mean;
F_thresh = zeros(size(data.F,2),length(F_mean));
sig_events = zeros(size(data.F,2),length(data.F));

%set parametersr for cusum
tmean = nanmean(data.F(1:1000,:),1);
tstd = std(data.F(1:1000,:),1);
thresh = 100


for axon = 1:size(data.F,2)
    %run cusum 
    [iupper, ilower, uppersum, lowersum] = cusum(data.F(:,axon),thresh,5,tmean(axon),tstd(axon));

    uppersum(uppersum >= tmean(axon) + thresh * tstd(axon));
    
    %label events where activity is above threshold 
    sig_events = bwlabel(uppersum);

    for i = 1: max(sig_events)
        event_length(axon,i) = sum(sig_events == i);
    end
    
    if max(sig_events) == 0;
        event_length(axon,1) = 0;
    end
    
    %if eventlength is longer than 2000 or at least 500 frames and is still
    %elevated at the end of session classify this axon as tonic
    
    if any(event_length(axon,:) >= 2000)
        tonic_activity_roi = [tonic_activity_roi, axon];
%         [M,I] = max(event_length(axon,:));
%         tonic_start =[tonic_start, find(events(axon,:) == I,1)];
    elseif event_length(axon, end) >= 500 & find(sig_events == length(event_length),1, 'last') == length(uppersum)
         tonic_activity_roi = [tonic_activity_roi, axon];
    end
    
end 



