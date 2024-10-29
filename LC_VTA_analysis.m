%% LC_VTA_analysis





%% 1. 440 day2
clear all
close all

%set length of track and number of frames in novel early period
track_length = 300;
early_length = 500;

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('440\day2\440day2plane3_int_10Hz.mat', ...
    'C:\Users\Sheffield_lab\Documents\analysis\NETcre\440\day2\440_fov2_3planes_splitbeh.mat', 2, track_length, 11315:16667, [], [1:197], ...
    'C:\Users\Sheffield_lab\Documents\analysis\NETcre\440\day2\440_fov2_3planes_splitbeh_good_behavior.mat', ...
    'C:\Users\Sheffield_lab\Documents\analysis\NETcre\440\day2\blebs_int_10Hz.mat');

%designate frames for each task
fam_laps = [7153:11314]; % has reward no reward data
novel_laps = [11315:16667];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %novel late
no_reward = [1992:6570];
rereward = [198:1990];
plane = 2;
id = ["440_day2_byhand"];

%run analysis on axons
[LC_analysis_out.day2_440] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, no_reward, rereward);

%% 27. 212 day 1

%run Fluorescence and behavioral data through glm prep function
[behplane, data] = axon_prep_CH('212\212_day1_int_10Hz.mat',...
    '212\212_day1_3planes_splitbeh.mat', 2, track_length, [7315:11667], [] ,[], ...
    '212\212_day1_3planes_splitbeh_good_behavior.mat');

fam_laps = [3559:7314];
novel_laps = [7315:11667];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
no_reward = [1652:3350];
rereward = [1:1650];
plane = 2;
id = ["212_day1_byhand"];

[LC_analysis_out.day1_212] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, no_reward, rereward);



%save('NET_all_summary')

%% 27. 208 day 1

%run Fluorescence and behavioral data through glm prep function
[behplane, data] = axon_prep_CH('208\208_day1_int_10Hz.mat',...
    '208\208_day1_3planes_splitbeh.mat', 2, track_length, [5463:11666], [] ,[], ...
    '208\208_day1_3planes_splitbeh_good_behavior.mat');

fam_laps = [3407:5461];
novel_laps = [5463:11666];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
no_reward = [1402:3390];
rereward = [1:1400];
plane = 2;
id = ["208_day1_byhand"];

[LC_analysis_out.day1_208] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, no_reward, rereward);




%% 2. 440 fov 2 need to fix up for current analysis (none of the rois pass the SNR test) 
%run Fluorescence and behavioral data through glm prep function

[behplane] = axon_prep_CH('440\fov2\byhandROIs\440fov2_ROIs.mat', ...
    '440\fov2\440_fov2_splitbeh.mat', 3, track_length, 2120:4000, [], [], ...
    'C:\Users\Sheffield_lab\Documents\analysis\NETcre\440\fov2\440_fov2_splitbeh_good_behavior.mat', ...
    'C:\Users\Sheffield_lab\Documents\analysis\NETcre\440\fov2\byhandrois\blebs.mat');


fam_laps = [1:2129];
novel_laps = [2120:4000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
plane = 3;
id = ["440_fov2_byhand"];

% [LC_analysis_out.fov2_440] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id);
%% 3. 440 FOV 3 

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('440\fov3\byhandROIs\440fov3plain1_combinedROIs_ROIs.mat', ...
    '440\fov3\440_fov3_splitbeh.mat', 1, track_length, 6871:10002, [], [], ...
    '440\fov3\440_fov3_splitbeh_good_behavior.mat', ...
    '440\fov3\blebs');


fam_laps = [3840:6870]; %has reward no reward first
novel_laps = [6871:10002];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
no_reward = [1360:3820];
rereward = [1:1359];
plane = 1;
id = ["440_fov3_byhand"];

[LC_analysis_out.fov3_440] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id,no_reward, rereward);


%% 4. 440 Multiplane day plane 1

%run Fluorescence and behavioral data through glm prep function
[behplane, data] = axon_prep_CH('440\multiplane\byhandROIs\440multiplane1_combined.mat', ...
    '440\multiplane\440_multiplane_splitbeh.mat', 1,track_length,  6828:10000, [], [], ...
    '440\multiplane\440_multiplane1_splitbeh_good_behavior.mat', ...
    '440\multiplane\plain2\blebs.mat');


fam_laps = [5020:6827]; %has reward no reward first
novel_laps = [6828:10000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
no_reward = [1890:4990];
rereward = [1:1889];
plane = 1;
id = ["440_plane1_byhand"];

[LC_analysis_out.plane1_440] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id,no_reward,rereward);
%% 4. 440 Multiplane day plane 2

%run Fluorescence and behavioral data through glm prep function
[behplane, data] = axon_prep_CH('440\multiplane\byhandROIs\440multiplane2_combined_300fr_ROIs.mat', ...
    '440\multiplane\440_multiplane_splitbeh.mat', 2, track_length, 6828:10000, [], [], ...
    '440\multiplane\440_multiplane2_splitbeh_good_behavior.mat', ...
    '440\multiplane\plain2\blebs.mat');


fam_laps = [5014:6827]; % has reward no reward first
novel_laps = [6828:10000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
no_reward = [1890:4990];
rereward = [1:1889];
plane = 2;
id = ["440_plane2_byhand"];

[LC_analysis_out.plane2_440] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, no_reward, rereward);


%% 5. 474 fov 1 

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('474\474_fov1_int_10Hz', ...
    '474\474fov1_3planes_splitbeh.mat', 2, track_length, 10016:13334, [], [1:359], ...
    '474\474fov1_3planes_splitbeh_good_behavior.mat', ...
    '474\blebs_int_10Hz.mat');


fam_laps = [7324:10015]; %has reward no reward first
novel_laps = [10016:13334];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
no_reward = [2012:7300];
rereward = [360:2010];
plane = 2;
id = ["474fov1_byhand"];

[LC_analysis_out.fov1_474] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, no_reward, rereward);


%% 6. 474 fov 2 

%run Fluorescence and behavioral data through glm prep function
[behplane, data] = axon_prep_CH('474\fov2\474_fov2_int_10Hz.mat', ...
    '474\fov2\474fov2_3planes_splitbeh.mat', 2, track_length, 4561:7000, [], 11650:13334, ...
    '474\fov2\474fov2_3planes_splitbeh_good_behavior.mat', ...
    '474\fov2\blebs_int_10Hz.mat');


fam_laps = [5142:7601];% has reward no reward 
novel_laps = [7603:11650];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
no_reward = [1635:5125];
rereward = [1:1634];

plane = 2;
id = ["474_fov2_byhand"];

[LC_analysis_out.fov2_474] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id,no_reward, rereward);




%% 8. 528 pupil day 

%run Fluorescence and behavioral data through glm prep function
[behplane, data] = axon_prep_CH('528\528pupilday\plane2_combined_300fr_ROIs.mat', ...
    '528\528pupilday\528_pupil_splitbeh.mat', 2, track_length, 3410:6000, '528\528pupilday\528_pupilday_proc.mat', 1:275, ...
    '528\528pupilday\528_pupil_splitbeh_good_behavior.mat', ...
    '528\528pupilday\blebs.mat');


fam_laps = [276:3409];
novel_laps = [3410:6000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["528_pupilday_byhand"];


[LC_analysis_out.pupilday_528] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id);




%% 9. 530 day 1  

%run Fluorescence and behavioral data through glm prep function
[behplane, data] = axon_prep_CH('530\530day1\530_plane2_ROIs.mat', ...
    '530\530day1\530_day1_splitbeh.mat', 2, track_length, 7876:12000, [], [1:353], ...
    '530\530day1\530_day1_splitbeh_good_behavior.mat', ...
    '530\530day1\blebs.mat');

fam_laps = [354:7875];
novel_laps = [7876:12000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["530_day1_byhand"];



[LC_analysis_out.day1_530] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id);


%% 10. 530 pupil day

%run Fluorescence and behavioral data through glm prep function
[behplane, data] = axon_prep_CH('530\530_pupilday\plane2_combined_300fr_ROIs.mat', ...
    '530\530_pupilday\530_pupilday_splitbeh.mat', 2, track_length, 3555:6000, [], [1:166], ...
    '530\530_pupilday\530_pupilday_splitbeh_good_behavior.mat', ...
    '530\530_pupilday\blebs.mat');


fam_laps = [167:3354];
novel_laps = [3355:6000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["530_pupilday_byhand"];

[LC_analysis_out.pupilday_530] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id);


%% 10. 735 day 2 

%run Fluorescence and behavioral data through glm prep function
[behplane, data] = axon_prep_CH('735\day2\735_day2_ROIs.mat', ...
    '735\day2\735_day2_splitbeh.mat', 2, track_length, 6289:14000, '735\day2\735_day2_pupil_proc.mat', [1:738], ...
     '735\day2\735_day2_splitbeh_good_behavior.mat', '735\day2\blebs_ROIs.mat');

dark = 1:738;
fam_laps = [738:6288];
novel_laps = [6289:14000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["735_day2_byhand"];



[LC_analysis_out.pupilday_735] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, [], [], dark);


%% 11. 784 day 1 

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('784\784_byhand_300fr_ROIs.mat', ...
    '784\784_split_beh.mat', 2, track_length, 4492:8333, '784\784_pupilimages_proc.mat', 1:840, ...
    '784\784_split_beh_good_behavior.mat', ...
    '784\blebs.mat');

dark = [1:840];
fam_laps = [840:4491];
novel_laps = [4492:8333];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["784_day1_byhand"];



[LC_analysis_out.day1_784] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, [], [], dark);


%% 12. 784 day 2

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('784\day2\784_day2_plane2_300fr_ROIs.mat', ...
    '784\day2\784_day2_splitbeh.mat', 2, track_length, 4492:13000, '784\day2\784_pupil_day2_proc.mat', 1:818, ...
    '784\day2\784_day2_splitbeh_good_behavior.mat', ...
    '784\day2\blebs.mat');

dark = 1:818;
fam_laps = [818:4491];
novel_laps = [4492:13000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["784_day2_byhand"];


[LC_analysis_out.day2_784] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, [], [], dark);



%% 13. 784 Day 3

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('784\day3\784_day3_300fr_ROIs.mat', ...
    '784\day3\784_day3_splitbeh.mat', 2, track_length, 4000:9000, '784\day3\784_day3_pupil_proc.mat', 1:833, ...
    '784\day3\784_day3_splitbeh_good_behavior.mat', ...
    '784\day3\blebs.mat');

dark = [1:833];
fam_laps = [834:3999];
novel_laps = [4000:9000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["784_day3_byhand"];



[LC_analysis_out.day3_784] = axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, [], [], dark);


%% 14. 813 day1

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('813\813_day1_plane2_300fr_ROIs.mat',...
    '813\813_split_beh.mat', 2, track_length, [10865:21000], '813\813_day1_pupil_proc.mat',[1:1668], ...
    '813\813_splitbeh_good_behavior.mat', ...
    '813\blebs.mat');

dark = [1:1668];
fam_laps = [1669:10864];
novel_laps = [10865:21000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["813_day1_byhand"];

[LC_analysis_out.day1_813] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps,novel_early, novel_late, plane,id, [], [], dark);


%% 15. 813 Day 2 has some z drift

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('813\day2\813_day2_byhand_300fr_ROIs.mat',...
    '813\day2\813_day2_splitbeh.mat', 2, track_length, [11673:20000], '813\day2\813_day2pupil_proc.mat',[1:1672], ...
    '813\day2\813_day2_splitbeh_good_behavior.mat', ...
    '813\day2\blebs.mat');

dark = [1:1672];
fam_laps = [1673:11672];
novel_laps = [11673:20000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["813_day2_byhand"];

[LC_analysis_out.day2_813] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps,novel_early, novel_late, plane,id, [], [], dark);


%% 16. 817

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('817\plane2_300fr_ROIs.mat',...
    '817\817_split_beh.mat', 2, track_length, [13333:23000], [NaN],[1:1672], ...
    '817\817_split_beh_good_behavior.mat', ...
    '817\blebs.mat');

fam_laps = [1673:13332];
novel_laps = [13333:23000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["817_byhand"];

[LC_analysis_out.day1_817] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps,novel_early, novel_late, plane,id);




%% 18. 861 day 2 

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('861\012921\plane2_combined_300fr_ROIs.mat',...
    '861\012921\861_012921_split_beh.mat', 2, track_length, [7370:14285], '861\012921\861_012921pupil_proc.mat' ,[1:1667,14286:16000], ...
    '861\012921\861_012921_split_beh_good_behavior.mat', ...
    '861\012921\blebs.mat');

dark = [1:1667];
fam_laps = [1668:7369];
novel_laps = [7370:14285];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["861_day2_byhand"];

[LC_analysis_out.day2_861] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, [], [], dark);



%% 20. 862 day 2 

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('862\013021\862_013021_plane2_ROIs.mat',...
    '862\013021\862_013021_splitbeh.mat', 2, track_length, [7485:12230], '862\013021\862_013021_pupil_proc.mat',[1:1668, 12231:14000], ...
    '862\013021\862_013021_splitbeh_good_behavior.mat', ...
    '862\013021\blebs.mat');

dark = [1:1668];
fam_laps = [1669:7484];
novel_laps = [7485:12230];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["862_day2_byhand"];

[LC_analysis_out.day2_862] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, [], [], dark);


%% 21. 1941 day 1 

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('1941\050721\1941_0507_plane2_300fr_ROIs.mat',...
    '1941\050721\1941_splitbeh.mat', 2, track_length, [7505:13334], '1941\050721\1941_0507_proc.mat',[1:1670], ...
    '1941\050721\1941_splitbeh_good_behavior.mat', ...
    '1941\050721\blebs.mat');

dark = [1:1670];
fam_laps = [1671:7504];
novel_laps = [7505:13334];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
plane = 2;
id = ["1941_day1_byhand"];

[LC_analysis_out.day1_1941] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, [], [], dark);


%% 22. 1941 day 2 

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('1941\051021\1941_0510_plane2_combined_300fr_ROIs.mat',...
    '1941\051021\1941_0510_splitbeh.mat', 2, track_length, [7505:16334], '1941\051021\1941_0510_pupil_proc.mat',[1:1670], ...
    '1941\051021\1941_0510_splitbeh_good_behavior.mat', ...
    '1941\051021\blebs.mat');

%designate good rois for GLM analysis
dark = [1:1670];
good_rois = [1:15];
fam_laps = [1671:7504];
novel_laps = [7505:16334];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["1941_day2_byhand"];

[LC_analysis_out.day2_1941] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, [], [], dark);

%% 23. 1942 day 1


%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('1942\050721\1942_0507_plane2_300fr_ROIs.mat',...
    '1942\050721\1942_0507_splitbeh.mat', 2, track_length, [7502:13334], '1942\050721\1942_0507_pupil_proc.mat',[1:1670], ...
    '1942\050721\1942_0507_splitbeh_good_behavior.mat', ...
    '1942\050721\blebs.mat');

dark = [1:1670];
fam_laps = [1671:7501];
novel_laps = [7502:13334];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["1942_day1_byhand"];

[LC_analysis_out.day1_1942] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, [], [], dark);


%% 24. 1942 day 2

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('1942\051121\1942_0511_plane2_300fr_ROIs.mat',...
    '1942\051121\1942_0511_splitbeh.mat', 2, track_length, [8000:14000], '1942\051121\1942_0511_pupil_proc.mat',[1:1670], ...
    '1942\051121\1942_0511_splitbeh_good_behavior.mat', ...
    '1942\051121\blebs.mat');

dark = [1:1670]
fam_laps = [1671:7999];
novel_laps = [8000:14000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["1942_day2_byhand"];

[LC_analysis_out.day2_1942] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, [], [], dark);



%% 25. 1448

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('1448\06172022\by_hand_300fr_ROIs.mat',...
    '1448\06172022\06172022_split_beh.mat', 2, track_length, [6000:13667], '1448\06172022\06172022_proc.mat',[1:1671], ...
    '1448\06172022\06172022_split_beh_good_behavior.mat', ...
    '1448\06172022\blebs');

dark = [1:1671];
fam_laps = [1671:8338];
novel_laps = [8339:13667];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["1448_byhand"];

[LC_analysis_out.day1_1448] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, [], [], dark);


%% 26. 1452

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('1452\06172022\byhand_combined_300fr_ROIs.mat',...
    '1452\06172022\06172022_splitbeh.mat', 2, track_length, [7670:14000], '1452\06172022\06172022_proc.mat',[1:1668], ...
    '1452\06172022\06172022_splitbeh_good_behavior.mat', ...
    '1452\06172022\blebs.mat');

dark = [1:1668];
fam_laps = [1669:7669];
novel_laps = [7670:14000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["1452_byhand"];

[LC_analysis_out.day1_1452] = axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, [], [], dark);

%% 27. 1452 day 2

%run Fluorescence and behavioral data through glm prep function
[behplane, data] = axon_prep_CH('1452\06232022\byhand_combined_300fr_ROIs.mat',...
    '1452\06232022\06232022_splitbeh.mat', 2, track_length, [7672:14000], '1452\06232022\06232022_proc.mat',[1:1672], ...
    '1452\06232022\06232022_splitbeh_good_behavior.mat', ...
    '1452\06232022\blebs.mat');

fam_laps = [1673:7671];
novel_laps = [7672:14000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["1452_day2_byhand"];

[LC_analysis_out.day2_1452] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id);



%% VTA analysis

track_length = 200;

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('C:\Users\Sheffield_lab\Documents\analysis\DATcre\113\reward_noreward\plane2_ROIs_ROIs.mat', ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\113\reward_noreward\113_splitbeh.mat', 2, track_length, 12498:17333, ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\113\reward_noreward\113_pupilimages_proc.mat', [], ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\113\reward_noreward\113_good_behavior.mat',...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\113\blebs_ROIs.mat');

fam_laps = [19:3314];
novel_laps = [12498:17333];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
%no_reward = [3426:8411];
no_reward = [4748:8218]; %low reward expectation
rereward = [8483:12290];  %RR frames

plane = 2;
id = ["113"];
data.F = data.F(:,5);
data.Fc = data.Fc(:,5);
data.Fc3 = data.Fc3(:,5);

[VTA_analysis_out.mouse_113] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, no_reward, rereward);


%% 115

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('C:\Users\Sheffield_lab\Documents\analysis\DATcre\115\115_plane2_ROIs.mat', ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\115\115_splitbeh.mat', 2, track_length, 16020:21000, ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\115\115_pupilimages_proc.mat', [], ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\115\115_good_behavior.mat', ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\115\blebs_ROIs.mat');

fam_laps = [69:3998];
novel_laps = [16020:21000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
%no_reward = [4040:12350];
no_reward = [7600:11824]; % low reward expectation
rereward = [12371:15979];

plane = 2;
id = ["115"];

[VTA_analysis_out.mouse_115] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, no_reward, rereward);


%% 265

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('C:\Users\Sheffield_lab\Documents\analysis\DATcre\265\265_int_ROIs.mat', ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\265\265_beh_3planes.mat', 2, track_length, [4176:6667], [], [], ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\265\265_beh_3planes_good_behavior.mat');

fam_laps = [1:1060];
novel_laps = [4176:6667];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
%no_reward = [1064:2829];
no_reward = [1063:2694]; %low reward expectation
rereward = [2695:4175];

plane = 2;
id = ["265"];

[VTA_analysis_out.mouse_265] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, no_reward, rereward);

%% 253

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('C:\Users\Sheffield_lab\Documents\analysis\DATcre\253\253_combined_ROIs.mat', ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\253\253_092821_splitbeh.mat', 2, track_length, 13036:18000, ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\253\253_pupilimages_proc.mat', [], ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\253\253_good_behavior.mat',...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\253\blebs_ROIs.mat');

fam_laps = [5:3950];
novel_laps = [13036:18000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
%no_reward = [3956:9016];
no_reward = [4760:8828]; % low reward expectation
rereward = [9125:12990];


plane = 2;
id = ["253"];

[VTA_analysis_out.mouse_253] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, no_reward, rereward);


%% 255

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('C:\Users\Sheffield_lab\Documents\analysis\DATcre\255\093021\255_combinedROI_ROIs.mat', ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\255\093021\255_093021_splitbeh.mat', 2, track_length, 12055:16000, ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\255\093021\255_pupilimages_proc.mat', [], ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\255\093021\255_good_behavior.mat',...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\255\093021\blebs_ROIs.mat');


fam_laps = [125:3936];
novel_laps = [12055:16000];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
%no_reward = [4093:8312];
no_reward = [5020:8076]; %low reward expectation
rereward = [8330:11860];

plane = 2;
id = ["255"];


[VTA_analysis_out.mouse_255] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id,no_reward, rereward);


%% 406 velocity encoding VTA axon

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('C:\Users\Sheffield_lab\Documents\analysis\DATcre\406\experiment_day\406_experiment_day_int_ROIs.mat', ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\406\experiment_day\406_experiment_day_beh_3planes.mat', 2, track_length, 8648:9999, [], [1:40],...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\406\experiment_day\406_experiment_day_beh_3planes_good_behavior.mat');

fam_laps = [40:921];
novel_laps = [8648:9999];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped
%no_reward = [936:3823];
no_reward = [1159:3823]; %low reward expectation
rereward = [3831:8647];
plane = 2;
id = ["406"];

[VTA_analysis_out.mouse_406] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id, no_reward, rereward);

%% 433 velocity encoding VTA axon

%run Fluorescence and behavioral data through glm prep function
[behplane,data] = axon_prep_CH('C:\Users\Sheffield_lab\Documents\analysis\DATcre\433\day2\433_day2_int_ROIs.mat', ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\433\day2\433_day2_beh_3planes.mat', 2, track_length, 10281:16667, [], [1:281], ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\433\day2\433_day2_beh_3planes_good_behavior.mat',...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\433\day2\blebs_int_ROIs.mat');

fam_laps = [281:6571];
novel_laps = [10281:16667];
novel_early = [novel_laps(1):novel_laps(1) + early_length]; %elevated activity novel laps
novel_late = [novel_early(end) + 1:novel_laps(end)]; %laps after elevated activity has dropped

plane = 2;
id = ["433"];


[VTA_analysis_out.mouse_433] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id);

%% 4. 223 analysis

[behplane,data] = axon_prep_CH('C:\Users\Sheffield_lab\Documents\analysis\DATcre\223\223_int_ROIs', ...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\223\223_beh_3planes', 2, track_length, [], [], [],...
    'C:\Users\Sheffield_lab\Documents\analysis\DATcre\223\223_3planes_good_behavior.mat')


fam_laps = [1:1229];
novel_laps = [];
novel_early = []; %elevated activity novel laps
novel_late = []; %laps after elevated activity has dropped
plane = 2;
id = ["223"];

[VTA_analysis_out.mouse_233] =  axon_analysis(data, behplane, track_length, fam_laps, novel_laps, novel_early, novel_late, plane,id);


%% save processed data
save('LC_VTA_summary.mat', '-v7.3')


%% Use blebs SNR to define a threshold below which axons are excluded from analysis
session_names = fieldnames(LC_analysis_out);

idx = 1;
idx_SNR = 1;
idx_bleb = 1;
%grab SNR for all blebs
for session = 1: length(session_names)
    tasks = fieldnames(LC_analysis_out.(session_names{session}).binnedA);
    for task = 1: length(tasks)
        if isfield(LC_analysis_out.(session_names{session}), 'blebs')
            num_blebs = size(LC_analysis_out.(session_names{session}).blebs.F,2);
            blebs_SNR(:,idx_bleb:idx_bleb + num_blebs - 1) = LC_analysis_out.(session_names{session}).blebs.SNR;
        end
    end
    idx_bleb = idx_bleb + num_blebs;
end

%define SNR ratio
SNR_thresh = nanmean(blebs_SNR) + 1*nanstd(blebs_SNR);
tonic_rois = 0;
n_rois = 0;

%find all axons above SNR thresh that do not have large shifts in baseline
%activity
for session = 1: length(session_names)
    above_SNR_thresh.(session_names{session}) = find(LC_analysis_out.(session_names{session}).SNR >= SNR_thresh & ~ismember(1:length(LC_analysis_out.(session_names{session}).SNR),LC_analysis_out.(session_names{session}).tonic_rois));
    tonic_rois = tonic_rois + sum(LC_analysis_out.(session_names{session}).tonic_rois ~= 0);
    n_rois = n_rois + size(above_SNR_thresh.(session_names{session}),2);
    
end
%% SNR thresh VTA axons
session_names = fieldnames(VTA_analysis_out);

idx = 1;
idx_SNR = 1;
idx_bleb = 1;

%grab SNR for all blebs
for session = 1: length(session_names)
    tasks = fieldnames(VTA_analysis_out.(session_names{session}).binnedA);
    for task = 1: length(tasks)
        if isfield(VTA_analysis_out.(session_names{session}), 'blebs')
            num_blebs = size(VTA_analysis_out.(session_names{session}).blebs.F,2);
            blebs_SNR(:,idx_bleb:idx_bleb + num_blebs - 1) = VTA_analysis_out.(session_names{session}).blebs.SNR;
        end
    end
    idx_bleb = idx_bleb + num_blebs;
end

%define SNR ratio
VTA_SNR_thresh = nanmean(blebs_SNR) + 1*nanstd(blebs_SNR);

%find all axons above SNR thresh that do not have large shifts in baseline
%activity
for session = 1: length(session_names)
    above_SNR_thresh_VTA.(session_names{session}) = find(VTA_analysis_out.(session_names{session}).SNR >= VTA_SNR_thresh & ~ismember(1:length(VTA_analysis_out.(session_names{session}).SNR),VTA_analysis_out.(session_names{session}).tonic_rois));
end


%% run analysis on novelty responses in LC and VTA axons
[LC_novel_aligned, LC_novel_aligned_Fc, combined_novel_aligned_F_good_beh_, combined_novel_aligned_F_good_beh_f2, novel_vel, novel_pup, LC_ids, LC_dark_aligned, LC_dark_aligned_Fc, combined_dark_aligned_F_good_beh_, combined_dark_aligned_F_good_beh_f2, LC_dark_id, combined_novel_aligned_F_badbeh, combined_novel_aligned_badbeh_f2] = axon_novel_analysis(LC_analysis_out, above_SNR_thresh, SNR_thresh);

[VTA_novel_aligned, VTA_novel_aligned_Fc, VTAcombined_novel_aligned_F_good_beh_, VTAcombined_novel_aligned_F_good_beh_f2, VTA_vel, VTA_pup, VTA_ids] = axon_novel_analysis(VTA_analysis_out, above_SNR_thresh_VTA, VTA_SNR_thresh);


%bootstrap data to generate baseline activity +- 95% CI
%fig 3b lower
x_units = ([1:40000] -20000)/(30.9/3);
baseline_bootstrap(LC_novel_aligned, LC_ids, 1000, x_units)
xlim([x_units(19000) x_units(21000)]);
yyaxis left
ylim([0.9 1.2])


%supp fig 5a 
x_units = ([1:40000] -20000)/(30.9/3);
baseline_bootstrap (LC_dark_aligned, LC_dark_id, 1000, x_units)
xlim([x_units(19000) x_units(21000)]);
yyaxis left
ylim([0.9 1.2])

%Fig 3b upper
baseline_bootstrap(VTA_novel_aligned, VTA_ids, 1000, x_units)
xlim([x_units(19000) x_units(21000)]);

%Fig 4c 
baseline_bootstrap(combined_novel_aligned_F_good_beh_, LC_ids, 1000, x_units)
xlim([x_units(19000) x_units(21000)]);

%supp fig 5b
baseline_bootstrap(combined_novel_aligned_F_badbeh, LC_ids, 1000, x_units)
xlim([x_units(19000) x_units(21000)]);
%%
% mean_data.F = nanmean(LC_novel_aligned,1)';
% LC_data = find_norm_psdx(mean_data, 1, 15000:25000)
% plot(LC_data.freq,pow2db(LC_data.normalized_psdx))
% grid on
% title("Periodogram Using FFT")
% xlabel("Frequency (Hz)")
% ylabel("Power/Frequency (dB/Hz)")
% 
% filtered(15000:25000) = bandpass(mean_data.F(15000:25000), [0.02 0.5], 30.98/3);
% 
% figure;
% hold on
% plot(filtered)
% plot(mean_data.F - 1)
% beh.mean_vel = nanmean(novel_vel./nanmean(novel_vel,2),1);
% plot(beh.mean_vel - 1)

%%
%Fig_3d right
bin_novel_activity(LC_novel_aligned, 100, LC_ids)
yyaxis left

%Fig 4e 
bin_novel_activity(combined_novel_aligned_F_good_beh_, 100, LC_ids)
yyaxis left
ylim([0.95 1.12])

%Fig_5a ii 
bin_novel_activity(combined_dark_aligned_F_good_beh_, 100, LC_dark_id)
yyaxis left

%Fig 4e 
bin_novel_activity(combined_novel_aligned_F_badbeh, 100, LC_ids)
yyaxis left
ylim([0.95 1.12])
xlim([-100 100])
% Fig 3aiii, Fig 3d left and Fig 4d
axon_lap_binned(LC_analysis_out, above_SNR_thresh, LC_ids)

% Fig 3aiii
axon_lap_binned(VTA_analysis_out, above_SNR_thresh_VTA, VTA_ids)


%run through each axon and determine if its has novel activity above
%baseline
count = 1;

for roi = 1:size(LC_novel_aligned,1)
    [out(roi)]= bin_novel_activity(LC_novel_aligned(roi,:), 100, {LC_ids{roi}});
    if out(roi) == 1;
        novel_session{count} = LC_ids{roi};
        count = count +1;
    end

end


%figure 4b;
figure;
var = [combined_novel_aligned_F_good_beh_f2(:,out)'; combined_novel_aligned_F_good_beh_f2(:,~out)'];
var = var./max(var')';
c = imagesc(var)
colormap('jet')
c.XData = (c.XData - 20000)/10.33;
xlim([-60 60]);
clim([-1 1])

%figure 3 c top
figure;
var = VTA_novel_aligned_Fc';
var = var./max(var')';
h = imagesc(var)
colormap('jet')
h.XData = (h.XData - 20000)/10.33;
xlim([-80 80]);
clim([-1 1])

%figure 3c bottom
figure;
var = [LC_novel_aligned_Fc(:,out)'; LC_novel_aligned_Fc(:,~out)'];
var = var./max(var')';
h = imagesc(var)
colormap('jet')
h.XData = (h.XData - 20000)/10.33;
xlim([-80 80]);
clim([-1 1])






%%
% no_novel_activity_pupil = [];
% for session = 1: length(no_novel_activity_sessions)
%     no_novel_activity_pupil = [no_novel_activity_pupil LC_analysis_out.(no_novel_activity_sessions{session}).novel_algined_pupil];
% end
% 
% 
% no_novel_activity_pupil(no_novel_activity_pupil == 0) = NaN;
% no_novel_activity_pupil = no_novel_activity_pupil';
% no_novel_pupil_smooth = NaN(size(no_novel_activity_pupil));
% 
% for i = 1: size(no_novel_activity_pupil,1)
%     no_novel_pupil_smooth(i,:) = smooth(no_novel_activity_pupil(i,:),21,'sgolay',7);
% end
% 
% no_novel_pupil_smooth(isnan(no_novel_activity_pupil)) = NaN;
% 
% normalized_no_novel_pupil_smooth = no_novel_pupil_smooth./max(no_novel_pupil_smooth')';
% normalized_no_novel_pupil_smooth(normalized_no_novel_pupil_smooth == 0) = NaN; 
% 
% 
% novel_aligned_pupil_cell{1} = no_novel_pupil_smooth(:,:)./max(no_novel_pupil_smooth(:,:)')';
% % plot((novel_aligned_F_smooth./nanmean(novel_aligned_F_smooth,2))', 'Color', [0.8 0.8 0.8])
% plot_pupil_means(novel_aligned_pupil_cell,['f'])
% plot_laps_with_mean([1:40000], novel_aligned_pupil_cell, ['f'], [-0.5 1.5])
% 
% figure;
% imagesc(normalized_no_novel_pupil_smooth)
% 
% novel_vs_fam{1} = normalized_no_novel_pupil_smooth(:,19000:19999);
% novel_vs_fam{2} = normalized_no_novel_pupil_smooth(:,20001:21000);
% 
% plot_pupil_means(novel_vs_fam, ["familiar","novel"]);





%% Fig 1e, 2bi, 2ci, 4f
x_units = linspace(0,300, 60);
bootstrap_measure("pos_binned_F", [3:59], above_SNR_thresh_VTA, above_SNR_thresh, VTA_analysis_out, LC_analysis_out, x_units,1)

fits.pos = fit_measure_rois("pos_binned_F", [3:59], above_SNR_thresh_VTA, above_SNR_thresh, VTA_analysis_out, LC_analysis_out, x_units,1)



%% Fig 1e, 2bi, 2ci, 4f
x_units = -flip(linspace(0,300, 60));
bootstrap_measure("pos_bin_F_a", [3:39], above_SNR_thresh_VTA, above_SNR_thresh, VTA_analysis_out, LC_analysis_out, x_units,1, [3:59]);


fits.pos = fit_measure_rois("pos_bin_F_a", [3:39], above_SNR_thresh_VTA, above_SNR_thresh, VTA_analysis_out, LC_analysis_out, x_units,1, [23:59])
%% Fig 1f, 2bii, 2cii, 4g

x_units = 1:1:60;
bootstrap_measure("lap_binnedV", [1:14], above_SNR_thresh_VTA, above_SNR_thresh, VTA_analysis_out, LC_analysis_out, x_units,1)

fits.vel = fit_measure_rois("lap_binnedV", [1:14], above_SNR_thresh_VTA, above_SNR_thresh, VTA_analysis_out, LC_analysis_out, x_units,0)


%% fig 1g, 2biii, 2ciii, 4h 
x_units = linspace(-20/10.33,84/10.33,105);
bootstrap_measure("initiationF", [1:25], above_SNR_thresh_VTA, above_SNR_thresh, VTA_analysis_out, LC_analysis_out, x_units,1)

fits.motion = fit_measure_rois("initiationF", [1:25], above_SNR_thresh_VTA, above_SNR_thresh, VTA_analysis_out, LC_analysis_out, x_units,0)

%% fig 1g, 2biii, 2ciii, 4h 
x_units = [-1000:100]/10.33;
bootstrap_measure("lap_activity", [950:1000], above_SNR_thresh_VTA, above_SNR_thresh, VTA_analysis_out, LC_analysis_out, x_units,1)

fits.motion = fit_measure_rois("lap_activity", [950:1000], above_SNR_thresh_VTA, above_SNR_thresh, VTA_analysis_out, LC_analysis_out, x_units,0)
  
%% fig 1g, 2biii, 2ciii, 4h 
x_units = linspace(-10,2,60);

bootstrap_measure("time_binned_F", [10:50], above_SNR_thresh_VTA, above_SNR_thresh, VTA_analysis_out, LC_analysis_out, x_units,1)

fits.motion = fit_measure_rois("initiationF", [1:25], above_SNR_thresh_VTA, above_SNR_thresh, VTA_analysis_out, LC_analysis_out, x_units,0)

%% comparing gcamps
GCamp6s = {'mouse_265', 'mouse_233', 'mouse_406', 'mouse_433'};

GCamp7b = {'mouse_113', 'mouse_115', 'mouse_253', 'mouse_255'};
combined = {};

roi = 1;
for session = 1:length(GCamp6s)
    good_rois = above_SNR_thresh_VTA.(GCamp6s{session});
    num_rois = length(good_rois);
    combined{1}(roi:roi + num_rois -1, :) = squeeze(nanmean(VTA_analysis_out.(GCamp6s{session}).pos_binned_F.fam(:,:,good_rois),1))';
    roi = roi + num_rois;
    GCaMP6s_rois.(GCamp6s{session}) = above_SNR_thresh_VTA.(GCamp6s{session}); 
    GCaMP6s_data.(GCamp6s{session}) = VTA_analysis_out.(GCamp6s{session});
end
roi = 1;

for session = 1:length(GCamp7b)
    good_rois = above_SNR_thresh_VTA.(GCamp7b{session});
    num_rois = length(good_rois);
    combined{2}(roi:roi + num_rois -1, :) = squeeze(nanmean(VTA_analysis_out.(GCamp7b{session}).pos_binned_F.fam(:,:,good_rois),1))';
    roi = roi + num_rois;
    GCaMP7b_rois.(GCamp7b{session}) = above_SNR_thresh_VTA.(GCamp7b{session}); 
    GCaMP7b_data.(GCamp7b{session}) = VTA_analysis_out.(GCamp7b{session});
end


x_units = linspace(0,200, 60);

plot_with_errorbars(combined, ["6s", "7b"], [3:59], x_units)

%%
combined = {};

roi = 1;
for session = 1:length(GCamp6s)
    good_rois = above_SNR_thresh_VTA.(GCamp6s{session});
    num_rois = length(good_rois);
    combined{1}(roi:roi + num_rois -1, :) = squeeze(nanmean(VTA_analysis_out.(GCamp6s{session}).lap_binnedV.fam(:,:,good_rois),1))';
    roi = roi + num_rois;
    GCaMP6s_rois.(GCamp6s{session}) = above_SNR_thresh_VTA.(GCamp6s{session}); 
    GCaMP6s_data.(GCamp6s{session}) = VTA_analysis_out.(GCamp6s{session});
end
roi = 1;

for session = 1:length(GCamp7b)
    good_rois = above_SNR_thresh_VTA.(GCamp7b{session});
    num_rois = length(good_rois);
    combined{2}(roi:roi + num_rois -1, :) = squeeze(nanmean(VTA_analysis_out.(GCamp7b{session}).lap_binnedV.fam(:,:,good_rois),1))';
    roi = roi + num_rois;
    GCaMP7b_rois.(GCamp7b{session}) = above_SNR_thresh_VTA.(GCamp7b{session}); 
    GCaMP7b_data.(GCamp7b{session}) = VTA_analysis_out.(GCamp7b{session});
end


x_units = 1:1:60;

plot_with_errorbars(combined, ["6s", "7b"], [1:14], x_units)

%%
combined = {};
roi = 1;
for session = 1:length(GCamp6s)
    good_rois = above_SNR_thresh_VTA.(GCamp6s{session});
    num_rois = length(good_rois);
    combined{1}(roi:roi + num_rois -1, :) = squeeze(nanmean(VTA_analysis_out.(GCamp6s{session}).initiationF.fam(:,:,good_rois),1))';
    roi = roi + num_rois;
    GCaMP6s_rois.(GCamp6s{session}) = above_SNR_thresh_VTA.(GCamp6s{session}); 
    GCaMP6s_data.(GCamp6s{session}) = VTA_analysis_out.(GCamp6s{session});
end
roi = 1;

for session = 1:length(GCamp7b)
    good_rois = above_SNR_thresh_VTA.(GCamp7b{session});
    num_rois = length(good_rois);
    combined{2}(roi:roi + num_rois -1, :) = squeeze(nanmean(VTA_analysis_out.(GCamp7b{session}).initiationF.fam(:,:,good_rois),1))';
    roi = roi + num_rois;
    GCaMP7b_rois.(GCamp7b{session}) = above_SNR_thresh_VTA.(GCamp7b{session}); 
    GCaMP7b_data.(GCamp7b{session}) = VTA_analysis_out.(GCamp7b{session});
end


x_units = linspace(-20/10.33,84/10.33,105);

plot_with_errorbars(combined, ["6s", "7b"], [1:25], x_units)
%% Fig 1e, 2bi, 2ci, 4f
x_units = linspace(0,300, 60);
bootstrap_measure("pos_binned_F", [3:59], GCaMP6s_rois, above_SNR_thresh, GCaMP6s_data, LC_analysis_out, x_units,1)

fits.pos = fit_measure_rois("pos_binned_F", [3:59], GCaMP6s_rois, above_SNR_thresh, GCaMP6s_data, LC_analysis_out, x_units,1)

%% Fig 1f, 2bii, 2cii, 4g

x_units = 1:1:60;
bootstrap_measure("lap_binnedV", [1:14],  GCaMP6s_rois, above_SNR_thresh, GCaMP6s_data, LC_analysis_out, x_units,1)

fits.vel = fit_measure_rois("lap_binnedV", [1:14], GCaMP6s_rois, above_SNR_thresh, GCaMP6s_data, LC_analysis_out, x_units,0)


%% fig 1g, 2biii, 2ciii, 4h 
x_units = linspace(-20/10.33,84/10.33,105);
bootstrap_measure("initiationF", [1:25],  GCaMP6s_rois, above_SNR_thresh, GCaMP6s_data, LC_analysis_out, x_units,1)

fits.motion = fit_measure_rois("initiationF", [1:25], GCaMP6s_rois, above_SNR_thresh, GCaMP6s_data, LC_analysis_out, x_units,0)



%% fig 4aii
example_roi = LC_analysis_out.fov3_440;
good_behavior = example_roi.behavior.good_beh.good_runs_index;
[z, novel_switch] = min(abs(good_behavior-6870));
good_y = example_roi.behavior.ybinned(good_behavior);
good_vel = example_roi.behavior.velocity(good_behavior);
good_reward = example_roi.behavior.velocity(good_behavior);
frames = [(novel_switch - 1500):(novel_switch+1500)];
good_t = ((1:length(good_behavior))-novel_switch)/10.3;
good_lick = example_roi.behavior.lick(good_behavior);
good_f = example_roi.F2(good_behavior,2);

%% fig 1d right 
% frames = [3840:length(example_roi.behavior.t)];
plotFvpos(good_f, good_y, good_reward, good_vel, good_lick, good_t, 1, frames, 21)
xlim([-100 100])

%% fig 1d left 
example_roi = VTA_analysis_out.mouse_265;

frames = [1:1000];
plotFvpos(example_roi.Fc, example_roi.behavior.ybinned, example_roi.behavior.reward, example_roi.behavior.velocity, example_roi.behavior.lick, example_roi.behavior.t, 1, frames, 21)

