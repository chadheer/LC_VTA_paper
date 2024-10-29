Distinct catecholaminergic pathways projecting to hippocampal CA1 transmit contrasting signals during navigation in familiar and novel environments
DOI: https://doi.org/10.7554/eLife.95213.4
Chad Heer, Mark Sheffield
The Department of Neurobiology, The University of Chicago, Chicago, United States

All code used in the above publication is contained here. 

INSTRUCTIONS:
Behavioral data was first aligned to imaging data using load_beh_shef_withImagesynccorrected.m. 'Good' and 'bad' running periods were determined using 'remove_bad_behavior_ver2_withoutvelocity.m'. 
It was then divided into the appropriate number of planes to match the imaging planes using splitplanes.m. 

Fluorescent data extracted using ImageJ was then converted into deltaF/F using read_and_analysis_ROI.m. If there were not 3 imaging planes, the data was integrated using int_F_data.m to match the frame rate when 3 imaging planes were used.

Once these preprocessing steps were completed, data was added to LC_VTA_analysis.m and processed and analyzed using the provided templates. 
