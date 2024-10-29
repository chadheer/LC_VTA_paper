%function converts python outputs of suite2p into mat files for any number
%of planes

function [] = suite2p2mat(mousefolder, nplanes)

% mousefolder = the directory where the suite2p folder is found
% nplanes     = the number of planes in the suite2p folder

for i=1:nplanes;
    d = [mousefolder '\suite2p\plane' num2str(i-1) '\'] %set directory

    iscell = readNPY([d 'iscell.npy']);                 %grab id's of rois that are cells

    Fall = load([d 'Fall.mat']);                        %load the mat file saved by suite2p

% frame = load_tiffs_fast_shef_Chad('SCH1_MotCor_converted_non_rigid.tif','start_ind',1,'end_ind',2);

    data.stat = Fall.stat(iscell==1);                   %grab the data for all of the rois that are cells
    data.F = double(Fall.F(iscell==1,:)');  
    data.Fneu = Fall.Fneu(iscell==1,:);
    data.spks = Fall.spks(iscell==1,:);
    data.iscell = Fall.iscell(iscell==1,:);
    
    data.Fc = [];  
    scale = [];

    data.Fc = FtoFc(data.F, 300)                       %generate Fc for all rois
%%
    ub = upperbase(data.Fc,'getinput',false);           %generate Fc3 for all rois
    data.Fc3 = FctoFc3(data.Fc,ub);



% 
% for roi=1:size(data.F,2)
%     scale(roi) = quantile(data.F(:,roi),0.08);
%     data.Fc(:,roi) = data.F(:,roi)/scale(roi);
%     center(roi) = median(data.Fc(:,roi));
%     data.Fc(:,roi) = bsxfun(@minus,data.Fc(:,roi),center(roi));
% end


    save(['plane' num2str(i) 'F'],'data','-v7.3')       %save a file for the current plane
end