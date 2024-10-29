function[ids] = subsample(above_SNR_thresh, n_samples, n_reps)





session = fieldnames(above_SNR_thresh);


for n = 1:n_reps

    ids(n,:,1) = randperm(length(session), n_samples);

    for i = 1: n_samples

        x = length(above_SNR_thresh.(session{ids(n,i,1)}));

        ids(n,i,2) = randperm(x,1);

    end

end
    