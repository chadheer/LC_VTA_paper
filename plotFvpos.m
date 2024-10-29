% plot fluorescent data with the animals position for the roi's given
% Chad Heer; Sheffield Lab

function [] = plotFvpos(Fdata, Yposdata, reward, velocity, lick, time, roi, frames, smoothby)

% Fdata = fluorescent data loaded in, should be just F, Fc or Fc3
% yposdata = Y_position data 
% reward = reward delivery data
% lick = mouse licking data
% time = time of each data point
% roi = specify which rois to plot F 
% smoothby = specify the span to smooth by

if ~exist('roi', 'var');
    roi = 1;
end

if ~exist('smoothby', 'var');
    smoothby = 0
end

if smoothby == 0;
    for i=1:length(roi)
        figure;
        hold on
        plot(Fdata(:,roi(i))/max(Fdata(:,roi(i))))
        plot(Yposdata/max(Yposdata))
        title(num2str(roi(i)))
    end
    
else
    for i=1:length(roi)
        figure;
        hold on
        subplot(4,1,3)
        plot(time(frames),smooth(Fdata(frames,roi(i)), smoothby, 'sgolay',5))
        xlim([-100 100])

        subplot(4,1,2)
        plot(time(frames),Yposdata(frames)/max(Yposdata(frames))-1)
        xlim([-100 100])

        subplot(4,1,1)
        plot(time(frames), reward(frames))
        xlim([-100 100])

%         plot(time(frames),lick(frames)/max(lick(frames))-3)
        subplot(4,1,4)
        plot(time(frames),velocity(frames)) 
        xlim([-100 100])

    end
end


        