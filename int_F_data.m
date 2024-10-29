function [] = int_F_data(data, sbxframes,plane, numplanes, outfile) 

load(data);

int_data = [];
vid_start = 1;
new_vid_start  = 1;

for j=1:size(sbxframes,2);
    old_length = length([plane:numplanes:sbxframes(j)]);
    new_length = length([2:3:sbxframes(j)]);

    for roi = 1: size(data.F,2)

        int_F(new_vid_start:(new_length + new_vid_start -1), roi) = interp1([plane:numplanes:sbxframes(j)], data.F([vid_start:vid_start + old_length-1],roi), [2:3:sbxframes(j)], 'linear','extrap');
        int_Fc(new_vid_start:(new_length + new_vid_start -1), roi) = interp1([plane:numplanes:sbxframes(j)], data.Fc([vid_start:vid_start + old_length-1],roi), [2:3:sbxframes(j)], 'linear','extrap');
        int_Fc3(new_vid_start:(new_length + new_vid_start -1), roi) = interp1([plane:numplanes:sbxframes(j)], data.Fc3([vid_start:vid_start + old_length-1],roi), [2:3:sbxframes(j)], 'linear','extrap');

            
    end
    
    vid_start = old_length + vid_start;
    new_vid_start = new_length + new_vid_start;

   
end


data.F = int_F;
data.Fc = int_Fc;
data.Fc3 = int_Fc3;

save(outfile, 'data');
