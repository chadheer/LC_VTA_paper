%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Align F data to motion initiation and termination
%Chad Heer

%INPUTS
%data = struct with Fc from axon analysis
%beh = struct with all behavioral variables
%nplanes = number of planes imaged
%frames = matrix with the frame numbers for each task
%tasks = task ids

%OUTPUTS
%data = data struct with motion intiation data appended

function [data] = align_to_motion(data, beh, nplanes, frames, tasks)



for task = 1: size(frames,2)

    %grab behavior for given task
    behavior = beh;
    fields = fieldnames(behavior);
    for field = 1: length(fields);
        if fields{field} == "fr"
            continue
        elseif fields{field} == "good_beh"
            continue
        end
        behavior.(fields{field}) = behavior.(fields{field})(:,frames{task});
    end
%%
    %remove laps that are shorter than 50 frames
    edges = unique(behavior.lap);
    counts = histc(behavior.lap, edges);
    short_laps = edges(counts <= 50);
    for i = 1: length(short_laps)   
        behavior.lap(behavior.lap == short_laps(i)) = NaN;
    end
    behavior.lap = behavior.lap - min(behavior.lap) + 1;


    F = data.Fc(frames{task}, :);
    dt= 30.98/nplanes;                                 %frame rate
    velocity= behavior.velocity;
    smoothV = velocity';  %smooth velocity
    Vsmooth = velocity';
    Vsmooth(smoothV<=5) = 0;                 %make all velocities below set value equal to zero
    
    moving = bwlabel (Vsmooth);                  %label each moving epoch
    moving(1) = 0;
    moving = bwlabel(moving);
    transitions = diff([0; moving == 0; 0]);
    runstarts = find(transitions == -1);
    runends = find(transitions == 1);
    
    for bin = 1: max(moving);                   %remove any moving epoch's that are less than 30 bins
        if length(moving(moving==bin))<= 3 *dt
            moving(moving==bin) = 0;
        elseif runstarts(bin) - runends(bin) < 1.5 * dt
            moving(moving  == bin) = 0; 
        end
    end
    
    moving = bwlabel(moving);               %relabel each moving epoch
    
    initiationF = [];
    initiationV = [];
    initiation_id = [];
    initiationPupil = [];

    %grab F and velocity for each motion initiation period
    for moving_period = 1:max(moving)
        if moving_period <= max(moving)
            initiation(moving_period) = find(moving==moving_period, 1);
            if initiation(moving_period)-(round(dt*2)) >= 1 & initiation(moving_period)+(round(dt*8)) <= length(frames{task});
                initiationF(moving_period,:,:)= F(initiation(moving_period)-(round(dt*2)):initiation(moving_period)+(round(dt*8)),:);       %grab F and Fc within 5s of movement initiation
                initiation_id(moving_period, :) = [initiation(moving_period), behavior.ybinned(initiation(moving_period)), behavior.lap(initiation(moving_period))];
                initiationV(moving_period,:) = Vsmooth(initiation(moving_period)-(round(dt*2)):initiation(moving_period)+(round(dt*8)));
            end
        end
    end

    %find periods where mouse is not moving

    resting = zeros(length(velocity),1);        
    resting(Vsmooth==0)=1;
    resting = bwlabel(resting);   %label each resting epoch
    
    for bin = 1: max(resting);                  %remove any resting epoch's < 30 bins
        if length(resting(resting==bin)) <=1*dt;
            resting(resting==bin) = 0;
        end
    end
    
    resting = bwlabel(resting);             %relabel each resting epoch
       
    terminationF = [];
    terminationV = [];
    terminationPupil = [];

    %find F and V aligned to motion termination
    for bin =1:max(resting);
        if bin <= max(resting);
            termination(bin) = find(resting==bin, 1);
            if termination(bin)-(round(dt*8)) >= 1 & termination(bin)+(round(dt*2)) <= length(frames{task});
                terminationF(bin,:,:)= F(termination(bin)-(round(dt*8)):termination(bin)+(round(dt*2)),:);
                terminationV(bin,:) = Vsmooth(termination(bin)-(round(dt*8)):termination(bin)+(round(dt*2)));
            end
        end
    end
    
    
    
    %append intiation and termination data to data struct
    data.initiationF.(tasks{task}) = initiationF;
    data.initiationV.(tasks{task}) = initiationV;
    data.initiation_id.(tasks{task}) = initiation_id;
    data.terminationF.(tasks{task}) = terminationF;
    data.terminationV.(tasks{task}) = terminationV;
end

end




