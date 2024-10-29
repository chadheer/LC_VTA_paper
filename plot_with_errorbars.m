%%Plots and calculates the mean bin value of all laps for data in each given task
%Chad Heer; Sheffield Lab

function [mean_lap_pupil, h, j] = plot_with_errorbars(lap_pupil, tasks, range, x_units)

%lap_pupil = pupil or fluorescence data organized in this format {task}(laps, mean pupil area in each bin)
%tasks = string array listing the order of the tasks

%mean_lap_pupil = the mean of each lap_pupil across the lap dimension 
bins = size(lap_pupil{1},2);
color_seq = {[86, 180, 233]/255,[213, 94, 0]/255,[0, 114, 178]/255,[0, 158, 115]/255, [204, 121, 167]/255,[240, 228, 66]/255,[230, 159, 0]/255};

combined_Fc = cell2mat(lap_pupil')';
x = repmat(x_units(range)', size(combined_Fc,2),1);
idx = 1;
lap_id = [];
for task = 1:size(lap_pupil,2)
    lap_id(idx:idx + size(lap_pupil{task},1) - 1) = task;
    idx = idx + size(lap_pupil{task},1);
end
lap_id = lap_id';
%  check = ceil([1:size(combined_Fc,2)]/size(lap_pupil{1},1))';
lap_id = categorical(repmat(lap_id',size(range,2),1));
lap_id = lap_id(:);
combined_Fc = combined_Fc(range,:);
combined_Fc = combined_Fc(:);
for_fit = table(combined_Fc, x, lap_id);
for_fit.lap_id = categorical(for_fit.lap_id);
fit = fitlm(for_fit, 'interactions', 'ResponseVar','combined_Fc', 'PredictorVars',{'x', 'lap_id'}, 'CategoricalVars','lap_id');
% a_result = anova1(fit);
% [h, atab, ctab, stats] = aoctool(x, combined_Fc, lap_id)
% figure;
% p = multcompare(stats, 0.05, 'on', '', 's')


figure;
% subplot(3,1,1)
hold on
legend('Location','best')
for task = 1: size(tasks,2)
    lap_pupil{task}(lap_pupil{task} == 0) = NaN;
    mean_lap_pupil{task}(:) = nanmean(lap_pupil{task}(:,:),1);
    SEM_lap_pupil{task}(:) = nanstd(lap_pupil{task}(:,:),0,1)./(sqrt(sum(~isnan(lap_pupil{task}(:,:)))));
    

    h = errorbar(x_units(1:length(mean_lap_pupil{task})), mean_lap_pupil{task}(:), SEM_lap_pupil{task}(:));
    title(tasks{task})
    h.Marker = 'o';
    h.MarkerSize = 5;
    h.CapSize = 5;
    h.Color = color_seq{task};
    h.DisplayName = tasks(task);
    h.LineStyle = "none";

    x = repmat(x_units(range), 1, size(lap_pupil{task},1));
    y = reshape(squeeze(lap_pupil{task}(:,range))', 1, []);
    lm = fitlm(x, y);
    coefs = lm.Coefficients.Estimate;
    rsquared = lm.Rsquared.Adjusted;
%     i = line(x_units(range), feval(fit, x_units(range),num2str(task)))
    g = plot(x_units(range), coefs(1) + coefs(2)*x_units(range))

    g.Color = color_seq{task}
    g.LineWidth = 2;
    g.DisplayName = num2str(lm.ModelFitVsNullModel.Pvalue);
    xlim([x_units(range(1)) x_units(range(end))]);
    
end
end