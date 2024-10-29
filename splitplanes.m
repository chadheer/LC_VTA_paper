%%Used to divide behavior into different planes for each imaging plane 
% Chad Heer; Sheffield lab 


function [] = splitplanes(behavior_file, sbxframes, nplanes, outfilename)

%behavior = unsplit behavior data (output of loadbehshef)
%sbxframes = vector with the number of frames for each sbx file
%nplanes = number of planes for recording session
%outfilename = file name to save as

%saves behplane which is organized as behplane{plane}.behavior

%determine the imaging plane each frame belongs to 
planeID = []
for j=1:size(sbxframes,2);
    plane = repmat(1:nplanes,1,sbxframes(j));
    planeID = [planeID plane(1:sbxframes(j))];
end

session = load(behavior_file);
behavior = session.session.beh_data;

%calculate acceleration
behavior.acceleration = -(gradient(behavior.lick)/(behavior.t(1)-behavior.t(2)));

%smooth and set a threshold on reward delivery data 
reward = smooth(behavior.reward, 5); 
reward(reward >0.5) = 1;

%smooth and set threshold for licking activity
lick = smooth(behavior.airpuff, 5);
lick(lick >0.5) = 1;

%divide behaviors into the planes they belong to 
for i=1:nplanes
    behplane{i}.ybinned = behavior.Y_pos(planeID == i)';
    behplane{i}.lick = behavior.airpuff(planeID == i)';
    behplane{i}.reward= reward(planeID == i)';
    behplane{i}.velocity = behavior.lick(planeID == i)';
    behplane{i}.acceleration = behavior.acceleration(planeID == i)';
    behplane{i}.t = behavior.t(planeID == i);
    behplane{i}.fr = behavior.fr;
end

save(outfilename, 'behplane');


