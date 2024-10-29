%% Converts excel spreadsheet extracted ROIs from ImageJ into mat files and calculates Fc and Fc3
%Chad Heer and Can Dong; Sheffield lab

clear all;

%% parameters
measurements=1;
scalewindow=300; %#of frames should be setted differently according to the data



%%get data
[ROI_filepaths, temp]=uigetfile('*.csv', 'Chose cellsort files to load:','MultiSelect','on');
temp_data=xlsread([temp ROI_filepaths]);
temp_data(:,1)=[];
F=temp_data(:,1:measurements:size(temp_data,2));

%calculate F and Fc
Fc = FtoFc(F,scalewindow);
Fc3 = FctoFc3(Fc,upperbase(Fc,true));


data.F = F;
data.Fc = Fc;
% data.Fc_smoothed = Fc_smoothed;
data.Fc3 = Fc3;
% data.Fc3_smoothed = Fc3_smoothed;
% data.segments = segments;

%save data
if exist([temp ROI_filepaths(1:end-4) '.mat'], 'file')==2
newname= uiputfile('*.mat','Already name already exists. Please select new filename for data file',[PathName FileName(1:end-4) '_handROIs']);
save([temp newname],'data');
else
save([temp ROI_filepaths(1:end-4) '_ROIs.mat'],'data'); 
end