%%Plots and calculates the mean bin value of all laps for data in each given task
%Chad Heer; Sheffield Lab

function [mean_lap_pupil, h, j] = plot_binned_data(lap_pupil, tasks, x_units)

%lap_pupil = pupil or fluorescence data organized in this format {task}(laps, mean pupil area in each bin)
%tasks = string array listing the order of the tasks

%mean_lap_pupil = the mean of each lap_pupil across the lap dimension 
bins = size(lap_pupil{1},2);
color_seq = ["b" "r" "g" "c" "m" "y" "k" "b" "r" "g" "c" "m" "y" "k" "b" "r" "g" "c" "m" "y" "k" "b" "r" "g" "c" "m" "y" "k"];
figure;
hold on
legend('Location','best')
for task = 1: size(tasks,2)
    lap_pupil{task}(lap_pupil{task} == 0) = NaN;
    mean_lap_pupil{task}(:) = nanmean(lap_pupil{task}(:,:),1);
    SEM_lap_pupil{task}(:) = nanstd(lap_pupil{task}(:,:),0,1)./(sqrt(sum(~isnan(lap_pupil{task}(:,:)))));
    
    
    if exist('x_units', 'var')
        h = plot(x_units,mean_lap_pupil{task}(:),color_seq(task), 'LineWidth',2, 'DisplayName',tasks(task))
        j = patch([x_units fliplr(x_units)], [(mean_lap_pupil{task}(:)'+SEM_lap_pupil{task}(:)') fliplr(mean_lap_pupil{task}(:)'-SEM_lap_pupil{task}(:)')],color_seq(task))
        alpha(0.3)
    else
        h = plot([1:size(lap_pupil{task},2)],mean_lap_pupil{task}(:),color_seq(task), 'LineWidth',2, 'DisplayName',tasks(task))
        j = patch([[1:size(lap_pupil{task},2)] fliplr([1:size(lap_pupil{task},2)])], [(mean_lap_pupil{task}(:)'+SEM_lap_pupil{task}(:)') fliplr(mean_lap_pupil{task}(:)'-SEM_lap_pupil{task}(:)')],color_seq(task))
        alpha(0.3)
    end
end
end