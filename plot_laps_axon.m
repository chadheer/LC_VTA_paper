%%Plots binned data for each lap in grey and the mean data in black
%Chad Heer; Sheffiel Lab

function [] = plot_laps_axon(position, bin_mean_activity,tasks,ylims)
%position = position for each bin
%bin_mean_activity = {task} (lap x binned mean activity)
%tasks = string array listing the order of the tasks
%ylims = y limits 
 
for task = 1: length(tasks)
    bin_mean_activity{task}(bin_mean_activity{task} == 0) = NaN;
    %set figure parameters
    figure;
    hold on
    box off
    set(gca,'TickLength',[0 0])
    set(gca,'TickLength',[0 0])
%     yticks([min(ylims),mean(ylims),max(ylims)])
%     xticks([0,100,200])
    xlabel('Track position(cm)')
    ylabel('Normalized Velocity')
    legend('Location','best')

    laps = size(bin_mean_activity{task},1);
    red = [0, 1, 0];
    pink = [0.6, 0.6, 0.6];
    color_l = [linspace(red(1), pink(1), laps)', linspace(red(2), pink(2), laps)', linspace(red(3), pink(3), laps)'];
    
    %plot binned data for each lap in grey
    for lap =1:size(bin_mean_activity{task},1)
        plot1 = plot(position, bin_mean_activity{task}(lap,:),'Color',color_l(lap,:), 'LineWidth', 2);
        plot1.Color(4) = 0.5;
        
    end
%     xlim([-2 2])
%     %plot mean of binned datat in black
%     plot(position,nanmean(bin_mean_activity{task}(:,:)), 'k', 'LineWidth', 3)
%     title(tasks(task))
%     if ~isempty(ylims)
%         ylim(ylims)
%     end
end
