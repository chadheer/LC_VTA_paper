
function[out] = fit_measure_rois(measure, range, above_SNR_thresh_VTA, above_SNR_thresh, VTA_analysis_out, LC_analysis_out, x_units, grab_laps,range2)

if exist("range2", "var")
    LC_range = range2;
    LC_x = x_units;
    x_units = x_units(21:60);
else
    LC_range = range;
    LC_x = x_units;
end


if measure == 'lap_activity';
    [VTA VTAlap, VTA_id] = grab_lap_activity(VTA_analysis_out, above_SNR_thresh_VTA, measure,grab_laps, 1);
    [LC_all, LClap, LC_id] = grab_lap_activity(LC_analysis_out, above_SNR_thresh, measure,grab_laps, 1);
else
    [VTA VTAlap, VTA_initiation_id, VTA_id] = grab_samples(VTA_analysis_out, above_SNR_thresh_VTA, measure,grab_laps, range);
    [LC_all LClap, initiation_id, LC_id] = grab_samples(LC_analysis_out, above_SNR_thresh, measure,grab_laps, LC_range);
end

%normalize activity
color_seq = {[230, 159, 0]/255,[86, 180, 233]/255,[0, 158, 115]/255,[240, 228, 66]/255,[0, 114, 178]/255,[213, 94, 0]/255,[204, 121, 167]/255};
tasks = fieldnames(VTA)


for task = 1: length(tasks)


    
    for roi = 1: size(VTA.(tasks{task}), 2)
        lm = fitlm(x_units(range), VTA.(tasks{task})(range,roi)');
        VTA_r2{task}(roi) = lm.Rsquared.Ordinary;
        VTA_fit{task}(roi,:) = lm.Coefficients.Estimate;
        VTA_p{task}(roi) = lm.ModelFitVsNullModel.Pvalue;

    end

    for roi = 1: size(LC_all.(tasks{task}),2)
        LC_lm = fitlm(LC_x(LC_range), LC_all.(tasks{task})(LC_range,roi)');
        LC_r2{task}(roi) = LC_lm.Rsquared.Ordinary;
        LC_fit{task}(roi,:) = LC_lm.Coefficients.Estimate;
        LC_p{task}(roi) = LC_lm.ModelFitVsNullModel.Pvalue;

    end
    
    figure;
    a = scatter(LC_fit{task}(LC_p{task} > 0.05,2), LC_r2{task}(LC_p{task} > 0.05),[],[0.6 0.6 0.6])
    a.SizeData = 60;
    a.LineWidth = 1;
    hold on
    b = scatter(LC_fit{task}(LC_p{task} <= 0.05,2), LC_r2{task}(LC_p{task} <= 0.05),[],[color_seq{2}])
    b.SizeData = 60;
    b.LineWidth = 1;


    c = scatter(VTA_fit{task}(VTA_p{task} > 0.05,2), VTA_r2{task}(VTA_p{task} > 0.05),[],[0.7 0.7 0.7], "diamond", "filled")
    c.SizeData = 80;
    c.LineWidth = 2;

    d = scatter(VTA_fit{task}(VTA_p{task} <= 0.05,2), VTA_r2{task}(VTA_p{task} <= 0.05),[], color_seq{1}, "diamond", "filled")
        d.SizeData = 80;
    d.LineWidth = 2;

    legend('Location','best')

    maxV(1) =max(VTA_fit{task}(:,2));
    maxV(2) = max(LC_fit{task}(:,2));
    maxV(3) = abs(min(VTA_fit{task}(:,2)));
    maxV(4) = abs(min(LC_fit{task}(:,2)));
    lim = max(maxV);
    xlim([-lim lim]);
    title(tasks{task})

    sum(VTA_fit{task}(:,2) > 0 & (VTA_p{task} <= 0.05)')
    sum(VTA_fit{task}(:,2) < 0 & (VTA_p{task} <= 0.05)')

    VTA_pos = length(unique(VTA_id.(tasks{task})(VTA_fit{task}(:,2) > 0 & (VTA_p{task} <= 0.05)')));
    VTA_neg = length(unique(VTA_id.(tasks{task})(VTA_fit{task}(:,2) < 0 & (VTA_p{task} <= 0.05)')));

    sum(LC_fit{task}(:,2) > 0 & (LC_p{task} <= 0.05)')
    sum(LC_fit{task}(:,2) < 0 & (LC_p{task} <= 0.05)')

    LC_sessions = fieldnames(LC_analysis_out);
    LC_pos = LC_sessions(unique(LC_id.(tasks{task})(LC_fit{task}(:,2) > 0 & (LC_p{task} <= 0.05)')));
    LC_neg = LC_sessions(unique(LC_id.(tasks{task})(LC_fit{task}(:,2) < 0 & (LC_p{task} <= 0.05)')));

    out.(tasks{task}).VTA_fit = VTA_fit{task};
    out.(tasks{task}).VTA_r2 = VTA_r2{task};
    out.(tasks{task}).LC_fit = LC_fit{task};
    out.(tasks{task}).LC_r2 = LC_r2{task};
    out.(tasks{task}).LC_p = LC_p{task};
    out.(tasks{task}).VTA_p = VTA_p{task};
end
           



end
