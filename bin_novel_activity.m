%%bin novel aligned activity 
%Chad Heer

%INPUTS
%novel_activity = novel aligned activity
%bin_size - size of each bin
%ids = id of each roi

%OUTPUTS
%out = if each roi is above baseline or not

function [out] = bin_novel_activity(novel_activity, bin_size, ids)

%generate bins
number_bins = length(novel_activity)/bin_size;
bin_edges = [1:bin_size:length(novel_activity)+1];
bin_mean = NaN(size(novel_activity,1),number_bins);

%find mean activity for each bin
for bin_edge = 1: number_bins
    bin_mean(:, bin_edge) = nanmean(novel_activity(:,bin_edges(bin_edge):bin_edges(bin_edge + 1) - 1), 2);
end

%bootstrap binned data to generate baseline activity
x_units = (bin_edges(1:end-1)-(20000-bin_size/2))/(30.98/3);
out = baseline_bootstrap(bin_mean, ids, 1000, x_units);
yyaxis left
xlim([-100 200]);



end

