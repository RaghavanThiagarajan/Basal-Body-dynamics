%% Section 1
% Raghavan Thiagarajan, reNEW, Univ. of Copenhagen, September 2023.

% This script plots the step distance, instantaneous speed and the differences between the consecutive x and y coordinates / steps. These computations / plots are the same as what is done in the
% 'Gradients_BB_int_normalization_by_cortex_Traj_after_filtering.m'. Here it is done again for 2 reasons: (1) to double check that the plotting is correct in 'Gradients_BB_int_normalization_by_cortex_Traj_after_filtering.m' and;
% (2) to plot these parameters for all trajectories as one vector instead of plotting using loop. Then I verified that plots from (1) and (2) are not very different. Importantly this script plots the differences in
% steps of x and y coordinates. These values are plotted as a distribution. Finally the saved .mat file from this script is used for fetching the values for generating the cumulative / average plots from all the cells
% and tracks.

clc;
clear all;
close all;

% loading parameters from the workspace of other scripts; Trajectory_data is the cell array where all the trajectory related details like trajectory number, frame number and x & y coordinates are stored
load('workspace_interim', 'Time_interval', 'pixelwidth', 'Image_dime', 'Trajectory_data', 'no_of_trajectories', 'timestep', 'traj_filter_duration');

BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General');  % location where the plots will be saved

% finding the sizes to make preassignments
[cell_row_size, ~] = size(Trajectory_data); % cell_row_size is nothing but the total number of trajectories (without any kind of filtering)
len_of_longest_cell_array = max(cellfun(@length,Trajectory_data(:,1))); % finding the length of the longest cell array; this is nothing but the longest trajectory

% preassigning the arrays with nans
distance = nan(cell_row_size, len_of_longest_cell_array);
timeforspeed = nan(cell_row_size, len_of_longest_cell_array);
speed = nan(cell_row_size, len_of_longest_cell_array);
x_distance = nan(cell_row_size, len_of_longest_cell_array);
y_distance = nan(cell_row_size, len_of_longest_cell_array);

% this for loop goes through all the trajectories one-by-one and then
% obtains the step distance, instantaneous speed, and the difference in x &
% y steps. 
for trajno = 1:no_of_trajectories
    kend = length(Trajectory_data{trajno,1}); % this gives the trajectory length
    % this if loop is to make sure that only those trajectories that are longer than "traj_filter_duration" (in no of frames) are taken for analysis - smaller trajectories are not plotted
    if kend <= traj_filter_duration % "traj_filter_duration" corresponds to the time (in frames) chosen based on the tracking plugin output. For more information, check the "value_for_filter.txt".
        % check the description in the first few lines of the "Gradients_BB_int_normalization_by_cortex_Traj_after_filtering.m" script where this value "traj_filter_duration" is obtained as input.        
        continue
    else        
        for k = 1: (kend-1)                           
            distance(trajno,k) = (sqrt((Trajectory_data{trajno,3}(k+1,1) - Trajectory_data{trajno,3}(k,1))^2 + (Trajectory_data{trajno,4}(k+1,1) - Trajectory_data{trajno,4}(k,1))^2)) * pixelwidth;            
            timeforspeed(trajno,k) = (Trajectory_data{trajno,2}(k+1,1) - Trajectory_data{trajno,2}(k,1)) * Time_interval;            
            speed(trajno,k) =  distance(trajno,k) / timeforspeed(trajno,k);   
            x_distance(trajno,k) = (Trajectory_data{trajno,3}(k+1,1) - Trajectory_data{trajno,3}(k,1)) * pixelwidth;
            y_distance(trajno,k) = (Trajectory_data{trajno,4}(k+1,1) - Trajectory_data{trajno,4}(k,1)) * pixelwidth;
        end        
%         figure(1); histogram(distance(trajno,:), 'FaceColor', 'r', 'FaceAlpha', 0.05, 'EdgeColor', 'none'); hold on; 
%         figure(2); histogram(speed(trajno,:), 'FaceColor', 'b', 'FaceAlpha', 0.05, 'EdgeColor', 'none'); hold on; 
        figure(3); histogram(x_distance(trajno,:), 'FaceColor', 'g', 'FaceAlpha', 0.05, 'EdgeColor', 'none'); hold on; 
        figure(4); histogram(y_distance(trajno,:), 'FaceColor', 'g', 'FaceAlpha', 0.05, 'EdgeColor', 'none'); hold on;
        
        figure(5); histogram(x_distance(trajno,:), 'FaceColor', 'g', 'FaceAlpha', 0.05, 'EdgeColor', 'none'); hold on; 
        figure(5); histogram(y_distance(trajno,:), 'FaceColor', 'g', 'FaceAlpha', 0.05, 'EdgeColor', 'none'); hold on; 
        
    end    
end

%figure(1); xlabel('Step distance [\mum]'); ylabel('Counts'); title('Step distance of BB trajectories in apical domain'); set(gca,'fontsize',12);
% saveas(gcf, fullfile(BB_apical, 'Step_distance_of_BB_trajectories_apicaldomain_histogram_2'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Step_distance_of_BB_trajectories_apicaldomain_histogram_2'), 'tif');

%figure(2); xlabel('speed [\mum / min]'); ylabel('Counts'); title('Instantaneous speed of BBs in apical domain'); set(gca,'fontsize',12);
% saveas(gcf, fullfile(BB_apical, 'Instantaneous_speed_of_BBs_apicaldomain_histogram_2'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Instantaneous_speed_of_BBs_apicaldomain_histogram_2'), 'tif');

figure(3); xlabel('x step [\mum]'); ylabel('Counts'); title('Difference in "x" steps of BB trajectories in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Difference_in_x_steps_of_BB_trajectories'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Difference_in_x_steps_of_BB_trajectories'), 'tif');

figure(4); xlabel('y step [\mum]'); ylabel('Counts'); title('Difference in "y" steps of BB trajectories in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Difference_in_y_steps_of_BB_trajectories'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Difference_in_y_steps_of_BB_trajectories'), 'tif');

figure(5); xlabel('x & y steps [\mum]'); ylabel('Counts'); title('Difference in "x & y" steps - combined'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Difference_in_x_y_steps_combined'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Difference_in_x_y_steps_combined'), 'tif');

close all;

% plotting the same parameters after pooling them into one vector instead of plotting them using a loop as did above 
distance_mod = distance(:);
speed_mod = speed(:);
x_distance_mod = x_distance(:);
y_distance_mod = y_distance(:);
x_y_distance_mod = vertcat(x_distance_mod, y_distance_mod);

% BB step distance
parameter = distance_mod; Xlabel = 'Step distance [\mum]'; Ylabel = 'Counts'; Plot_title = {'Step distance', '[plotted as pooled single vector instead of looping]'}; save_title = 'Step_distance_(no_looping)';
hist_dist_plot(parameter, Xlabel, Ylabel, Plot_title, BB_apical, save_title);
% BB instantaneous speed
parameter = speed_mod; Xlabel = 'speed [\mum / min]'; Ylabel = 'Counts'; Plot_title = {'Instantaneous speed', '[plotted as pooled single vector instead of looping]'}; save_title = 'Instantaneous_speed_(no_looping)';
hist_dist_plot(parameter, Xlabel, Ylabel, Plot_title, BB_apical, save_title);
% BB difference in x coordinate steps
parameter = x_distance_mod; Xlabel = 'x step [\mum]'; Ylabel = 'Counts'; Plot_title = {'Difference in "x" steps', '[plotted as pooled single vector instead of looping]'}; save_title = 'Difference_in_x_steps_(no_looping)';
hist_dist_plot(parameter, Xlabel, Ylabel, Plot_title, BB_apical, save_title);
% BB difference in y coordinate steps
parameter = y_distance_mod; Xlabel = 'y step [\mum]'; Ylabel = 'Counts'; Plot_title = {'Difference in "y" steps', '[plotted as pooled single vector instead of looping]'}; save_title = 'Difference_in_y_steps_(no_looping)';
hist_dist_plot(parameter, Xlabel, Ylabel, Plot_title, BB_apical, save_title);
% BB difference in x & y coordinate steps pooled together
parameter = x_y_distance_mod; Xlabel = 'x & y steps [\mum]'; Ylabel = 'Counts'; Plot_title = {'Difference in "x & y" steps', '[plotted as pooled single vector instead of looping]'}; save_title = 'Difference_in_x_y_steps_(no_looping)';
hist_dist_plot(parameter, Xlabel, Ylabel, Plot_title, BB_apical, save_title);

%%
% saving workspace
save('workspace_BB_step_distance_speed');

%%
% Saving the figures as montage
montage_fig = '../Plots/montage';
fig3 = fullfile(BB_apical, 'Difference_in_x_steps_of_BB_trajectories.tif');
fig4 = fullfile(BB_apical, 'Difference_in_y_steps_of_BB_trajectories.tif');
fig5 = fullfile(BB_apical, 'Difference_in_x_y_steps_combined.tif');
fig6 = fullfile(BB_apical, 'Step_distance_(no_looping).tif');
fig7 = fullfile(BB_apical, 'Instantaneous_speed_(no_looping).tif');
fig8 = fullfile(BB_apical, 'Difference_in_x_steps_(no_looping).tif');
fig9 = fullfile(BB_apical, 'Difference_in_y_steps_(no_looping).tif');
fig10 = fullfile(BB_apical, 'Difference_in_x_y_steps_(no_looping).tif');
montage({fig3, fig4, fig5, fig6, fig7, fig8, fig9, fig10});
saveas(gcf, fullfile(montage_fig,'slide_21_step_distance_speed'), 'tif');

close all;

%% Section 2
% Raghavan Thiagarajan, 03rd September 2024, reNEW, Copenhagen
% This script splits the area into different ranges based on actual area value (0-150µm2; 150µm2-final area) and percentages (25%, 50%, 75%, 100%). 
% Then we find the contour and end-to-end distances between these area ranges and also toruosity.

%%
close all;
clear all;
clc;

%%
% Checking if the analysis is running on control or alphaActininMO. This analysis is only for control data and not for alphaActininMO data. Because, the idea is look at the changes in contour & end-to-end distances between the early & late phase of expansion. This kind of
% transition is only found in control. And this cannot be found in alphaActininMO or any other perturbation where full area expansion is not achieved at the native rate of expansion. This script runs only if we are analysing ctrl data. If any folder with 
% the letters 'MO' are analysed, then this script aborts the analysis.
pwd_check = pwd;
if contains(pwd_check, 'MO')
    disp('Exiting script - this analysis is not performed for alphaActininMO condition !');
    return    
end

%% Splitting the absolute value of area (similar to percentages)

% The below logic is to create a table that contains, apical domain areas (in the 2nd column) with an increase of 'increment_area_value' µm2.  Here, the starting area is taken as such. Then, the second (row) area will 
% be the one that is closest to the 'increment_area_value' µm2. From then on, we increment by 'increment_area_value' µm2 and take the value closest to it until the final area. It will be more clear if you look at the second and third columns of 
% the table (table_saving_area_increment_actualvalue) / array (area_increment_actualvalue). The first column is the indices of all these areas obtained from the Area_apicaldomain.

load('workspace_interim.mat', 'Area_apicaldomain', 'MaxAreaINdex'); % loading only the time interval and area of apical domain
maximum_area = Area_apicaldomain(MaxAreaINdex); % getting the max of area

increment_area_value = 50; % in µm2; This increment value is chosen because the idea is to increment the area value by 50µm2. This way we can set a threshold of 100/150/200µm2 (in 'area_split_value') which are between 100µm2-200µm2 (this is the area range at which change in trend occurs in BB transition time & Actin intensity CDFs). 
area_split_value = 150; % Here the threshold value can be either set to 100 / 150 / 200 µm2. In general, any value can be chosen here. however, '150' is chosen as a suffix for the variable names simply because it is the midvalue between 100 & 200 µm2. But these variable names will reflect the threshold value entered here.

% preassignments
pch = 1; % intitiation value
increment_index_area(pch,1) = pch; % starting index value
increment_index_area(pch,2) = Area_apicaldomain(pch); % starting Area apical domain
increment_index_area(pch,3) = NaN; % assigning 'NaN' as starting value for the area increment value; Actually, '0' should be the starting value. But because using zero leads to issues for other processes in the script (while removing rows with zeros); A the end of the script, this NaN will be again changed to zero. 
curr_area = Area_apicaldomain(pch); % getting the first area
increment_area = increment_area_value; % reassigning the 'increment_area_value'

% This while loop goes through the "Area_apicaldomain" array and only gets those area values with an incrementation of 'increment_area_value' µm2 starting from the second value. Then it gets the corresponding index and the actual area.
% To understand better what this loop does, look at the 'table_saving_area_increment_actualvalue' table in the workspace - note - this table is not saved.
while curr_area < maximum_area    
    curr_area = increment_area;
    [c, incre_area_index] = min(abs(Area_apicaldomain - curr_area)); % getting the area value closest to one of the increment area lists (50,75,100,150,200,250,300,350 etc.). Note - not all these areas are listed. only some of them. For example: (50,100,150,200 etc.) or (75,150,225,300 etc.)
    pch = incre_area_index;        
    increment_index_area(pch,1) = incre_area_index; % assigning the index of this area value
    increment_index_area(pch,2) = Area_apicaldomain(pch); % getting the actual area value corresponding to the increment value
    increment_index_area(pch,3) = curr_area; % area increment value
    increment_area = increment_area + increment_area_value;    
end

% Here we remove all the zeros to get only those values that are incremented by 'increment_area_value' µm2 - this we do by removing all rows with zeros and then again reshaping the matrix so that it is of the same form as original matrix but without zeros.
no_of_non_zero_rows = sum(~(all(increment_index_area==0,3))); % getting the total no of non zero rows for using to reshape the matrix
nonzero_increment_index_area = nonzeros(increment_index_area); % getting the column vector that are nonzero for using to reshape the matrix
increment_index_area_final = reshape(nonzero_increment_index_area, no_of_non_zero_rows(1,1), 3); % reshaping the matrix
increment_index_area_final(1,3) = 0; % Initially a 'NaN' was assigned to this position - look at the 'preassignments' in the beginning of this section 'increment_index_area(pch,3)'. Now this value is changed to zero.
% Here the data is saved as a table for future reference.
table_saving_area_increment_actualvalue = table(increment_index_area_final(:,1), increment_index_area_final(:,2), increment_index_area_final(:,3), 'VariableNames', {'Index_from_Area_apicaldomain', 'Actual_area_from_Area_apicaldomain', 'Area increment value'});
area_increment_actualvalue = table2array(table_saving_area_increment_actualvalue); % converting table to array for using later

clearvars -except table_saving_area_increment_actualvalue area_increment_actualvalue increment_area_value area_split_value

%% Getting the area percentages

% The below logic to create a table (.csv file) that contains, apical domain areas (in the 2nd column) with a 'increment_percent' increase between areas.  Meaning, starting from the first
% area (or the first frame), the areas are incremented by 'increment_percent' and only these areas are included in this table. It will be more clear if you look at the third column where the
% starting value is the percentage of area (w.ro.to the maximum area the apical domain reaches). Then starting from this first value, subsequent areas with 25 % increase are found and listed.
% The first column is the indices of all these areas obtained from the Area_apicaldomain and area_percent. The second column is the areas in micrometer squared. Fourth column is 
% the actual area percent.

load('workspace_interim.mat', 'Framelist', 'Timelist', 'Area_apicaldomain'); % loading only the time interval and area of apical domain
area_percent = round((Area_apicaldomain(:,1) * 100) / max(Area_apicaldomain)); % calculating the area percent starting from the first area (or first frame) w.r.to the maximum area of the apical domain.

increment_percent = 25; % change this number if you want to increment by a different percentage value; Any change here should be reflected in the 'strt_frame_actualvalue_number' & 'end_frame_actualvalue_number'. Right now we use '4' 'strt_frame_actualvalue_number' & 'end_frame_actualvalue_number', because we have four percentages
% (25, 50, 75, 100). If the value here is changed to '50', then the number of 'strt_frame_actualvalue_number' & 'end_frame_actualvalue_number' will be reduced to '2' because we will have only 2 percentages (50, 100).
% Also make changes accordingly for 'increment_index_area_final(1:5,4)' down the script.

pch = 1; % intitiation value
increment_index_area(pch,1) = pch; % starting index value
increment_index_area(pch,2) = Area_apicaldomain(pch); % starting Area apical domain
increment_index_area(pch,3) = area_percent(pch); % starting caclulated area percent
increment_index_area(pch,4) = 0; % starting actual area percent
curr_area = area_percent(pch);

% This while loop goes through the "area_percent" array and only gets the area_percent with an incrementation of 'increment_percent' starting from the first value. Then it gets the corresponding index, 
% actual area, and the actual area_percent.
while curr_area <= 100     % Here 100 is in percentage
    curr_area = increment_index_area(pch,3) + increment_percent; 
    [c, incre_area_index] = min(abs(area_percent - curr_area));  % getting the area percentage closest to one of the increment area lists (25%, 50%, 75%, 100% etc.). 
    pch = incre_area_index;
    increment_index_area(pch,1) = incre_area_index; % assigning the index of this area value
    increment_index_area(pch,2) = Area_apicaldomain(pch); % getting the area percentage corresponding to the increment value
    increment_index_area(pch,3) = area_percent(pch); % area increment percentage
    increment_index_area(pch,4) = curr_area;
end

% Here we remove all the zeros to get only those values that are incremented by 'increment_percent'
increment_index_area(1,4) = NaN; % reassigning '0' as NaN so that an operation to remove zero values can be performed. subsequently, the NaN will be replaced with '0'
no_of_non_zero_rows = sum(~(all(increment_index_area==0,4))); % getting the total no of non zero rows for using to reshape the matrix
nonzero_increment_index_area = nonzeros(increment_index_area); % getting the column vector that are nonzero for using to reshape the matrix
increment_index_area_final = reshape(nonzero_increment_index_area, no_of_non_zero_rows(1,1), 4); % reshaping the matrix
increment_index_area_final(1:5,4) = [0, increment_percent, increment_percent*2, increment_percent*3 , increment_percent*4]; % Here we just manually include the percentages.
% Here the data is saved as a table for future reference.
table_saving_area_increment_percent = table(increment_index_area_final(:,1), increment_index_area_final(:,2), increment_index_area_final(:,3), increment_index_area_final(:,4), 'VariableNames', {'Index_from_Area_apicaldomain', 'Actual_area_from_Area_apicaldomain','Calculated_area_percent', 'Actual_area_percent'});
area_increment_percent = table2array(table_saving_area_increment_percent); % converting table to array for using later

clearvars -except table_saving_area_increment_actualvalue area_increment_actualvalue increment_area_value area_split_value table_saving_area_increment_percent area_increment_percent

%% Below we get those indices/framenumbers for both actual value of area & area percentages and then get the contour & end-to-end distances between them.
 
% First we are getting the indices of frame numbers between which the distances are to be calculated for both the actual area value ('area_increment_actualvalue') & the area percentage ('area_increment_percent')
% for 'area_increment_actualvalue'
strt_idx_actualvalue_1 = 1;
end_idx_actualvalue_1 = find(area_increment_actualvalue(:,3)==area_split_value); % Here the frame number close to the area threshold value (i.e. area_split_value) is obtained
end_idx_actualvalue_2 = size(area_increment_actualvalue,1); % the other way of fetching this value is: area_increment_actualvalue(end,1);
% for 'area_increment_percent'
strt_idx_percent_1 = 1;
end_idx_percent_1 = 2;
end_idx_percent_2 = 3;
end_idx_percent_3 = 4;
end_idx_percent_4 = 5;

% Second, we get the framenumbers for the indices obtained above
% for 'area_increment_actualvalue'
strt_frame_actualvalue_1 = area_increment_actualvalue(strt_idx_actualvalue_1,1);
end_frame_actualvalue_1 = area_increment_actualvalue(end_idx_actualvalue_1, 1);
strt_frame_actualvalue_2 = end_frame_actualvalue_1;
end_frame_actualvalue_2 = area_increment_actualvalue(end_idx_actualvalue_2,1);
% for 'area_increment_percent'
strt_frame_percent_1 = area_increment_percent(strt_idx_percent_1,1);
end_frame_percent_1 = area_increment_percent(end_idx_percent_1,1);
strt_frame_percent_2 = end_frame_percent_1;
end_frame_percent_2 = area_increment_percent(end_idx_percent_2,1);
strt_frame_percent_3 = end_frame_percent_2;
end_frame_percent_3 = area_increment_percent(end_idx_percent_3,1);
strt_frame_percent_4 = end_frame_percent_3;
end_frame_percent_4 = area_increment_percent(end_idx_percent_4,1);

% Third, we get the trajectory data and start calculating the distances between those frame numbers obtained above
load('workspace_interim', 'Time_interval', 'pixelwidth', 'Area_apicaldomain', 'Trajectory_data', 'no_of_trajectories', 'traj_filter_duration');
BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General');

k = 0; % initial value
for trajno = 1:no_of_trajectories
    kend = length(Trajectory_data{trajno,1}); % this gives the trajectory length
    % this if loop is to make sure that only those trajectories that are longer than "traj_filter_duration" (in no of frames) are taken for analysis - smaller trajectories are not plotted    
    if kend <= traj_filter_duration % "traj_filter_duration" corresponds to the time (in frames) chosen based on the tracking plugin output. For more information, check the "value_for_filter.txt".
        % check the description in the first few lines of the "Gradients_BB_int_normalization_by_cortex_Traj_after_filtering.m" script where this value "traj_filter_duration" is obtained as input.       
        k = k + 1; % this value is used in the next few lines to get the "traj_no_updated". "traj_no_updated" is the updated incrementer that accounts for the skipped values due to the "if condition".
        continue
    else 
        trajno_updated = trajno - k; % updated incrementer instead of "trajno"; note that "trajno_updated" is only used for saving and not for fetching. In other words, arrays on the left hand side will used "trajno_updated" but
        % arrays on the right hand side will use "trajno"

        xcrdns = Trajectory_data{trajno,3}(:,1); ycrdns = Trajectory_data{trajno,4}(:,1); % getting the x & y coordinates

        % In the matrices that are obtained below as output from the function 'fetching_distances', the row numbers correspond to Trajectory numbers and each of the columns correspond to: 
        % column 1 - trajectory number; column 2 - starting frame number; column 3 - ending frame number; column 4 - starting apical area; column 5 - ending apical area; column 6 - contour distance; column 7 - end_to_end_distance

        % Distance during 1 - to - 150µm2 area ('area_increment_actualvalue')
        [dist_actualAreaVal_1_to_150um2(trajno_updated,1:7)] = fetching_distances(strt_frame_actualvalue_1, end_frame_actualvalue_1, strt_idx_actualvalue_1, end_idx_actualvalue_1, xcrdns, ycrdns, trajno, area_increment_actualvalue, pixelwidth);
        % Distance during 150µm2 - to - final area ('area_increment_actualvalue')        
        [dist_actualAreaVal_150um2_to_finalarea(trajno_updated,1:7)] = fetching_distances(strt_frame_actualvalue_2, end_frame_actualvalue_2, end_idx_actualvalue_1, end_idx_actualvalue_2, xcrdns, ycrdns, trajno, area_increment_actualvalue, pixelwidth);
        % Distance during 1 - to - 25% area ('area_increment_percent')        
        [dist_areaPercent_1_to_25pct(trajno_updated,1:7)] = fetching_distances(strt_frame_percent_1, end_frame_percent_1, strt_idx_percent_1, end_idx_percent_1, xcrdns, ycrdns, trajno, area_increment_percent, pixelwidth);
        % Distance during 25% - to - 50% area ('area_increment_percent')        
        [dist_areaPercent_25pct_to_50pct(trajno_updated,1:7)] = fetching_distances(strt_frame_percent_2, end_frame_percent_2, end_idx_percent_1, end_idx_percent_2, xcrdns, ycrdns, trajno, area_increment_percent, pixelwidth);
        % Distance during 50% - to - 75% area ('area_increment_percent')        
        [dist_areaPercent_50pct_to_75pct(trajno_updated,1:7)] = fetching_distances(strt_frame_percent_3, end_frame_percent_3, end_idx_percent_2, end_idx_percent_3, xcrdns, ycrdns, trajno, area_increment_percent, pixelwidth);
        % Distance during 75% - to - 100% area ('area_increment_percent')        
        [dist_areaPercent_75pct_to_100pct(trajno_updated,1:7)] = fetching_distances(strt_frame_percent_4, end_frame_percent_4, end_idx_percent_3, end_idx_percent_4, xcrdns, ycrdns, trajno, area_increment_percent, pixelwidth);
        clear xcrdns ycrdns
    end    
end

% below we get the maximum of distances for both contour & end-to-end distance separately for the actual area value and area percentage so that
% it can be used to normalise the distances (only these normalised distances are plotted both here & also in the average plot)
max_length_of_all_AreaVal = max([dist_actualAreaVal_1_to_150um2(:,6); dist_actualAreaVal_150um2_to_finalarea(:,6); dist_actualAreaVal_1_to_150um2(:,7); dist_actualAreaVal_150um2_to_finalarea(:,7)]); % max of contour & end-to-end distance for the actual area value split
max_length_of_all_AreaPercent = max([dist_areaPercent_1_to_25pct(:,6); dist_areaPercent_25pct_to_50pct(:,6); dist_areaPercent_50pct_to_75pct(:,6); dist_areaPercent_75pct_to_100pct(:,6); dist_areaPercent_1_to_25pct(:,7); dist_areaPercent_25pct_to_50pct(:,7); dist_areaPercent_50pct_to_75pct(:,7); dist_areaPercent_75pct_to_100pct(:,7)]); % max of contour & end-to-end distance for the area percentage

% compiling all the distance values obtained as different matrices in the loop above into one single matrix
% Also in this matrix, the distances are normalised to the longest (maximum) distance of both contour & end-to-end distances.
% In the matrices below, the row numbers correspond to the trajectories and columns correspond to the distances at different area ranges: column 1: 1µm2 - 150µm2; column 2: 150µm2 - final area; column 3: 1 - 25pct; column 4: 25pct - 50pct; 
% column 5: 50pct - 75pct; column 6: 75pct - 100pct; contour distance matrix
contourDist_actualAreaVal_areapercent_all = [dist_actualAreaVal_1_to_150um2(:,6), dist_actualAreaVal_150um2_to_finalarea(:,6), dist_areaPercent_1_to_25pct(:,6), dist_areaPercent_25pct_to_50pct(:,6), dist_areaPercent_50pct_to_75pct(:,6), dist_areaPercent_75pct_to_100pct(:,6)];
contourDist_actualAreaVal_areapercent_all_norm(:,1:2) = contourDist_actualAreaVal_areapercent_all(:,1:2) / max_length_of_all_AreaVal; % max_contourdist_actualAreaValue;
contourDist_actualAreaVal_areapercent_all_norm(:,3:6) = contourDist_actualAreaVal_areapercent_all(:,3:6) / max_length_of_all_AreaPercent; % max_contourdist_AreaPercent;
% End-to-End distance matrix
EndToEndDist_actualAreaVal_areapercent_all = [dist_actualAreaVal_1_to_150um2(:,7), dist_actualAreaVal_150um2_to_finalarea(:,7), dist_areaPercent_1_to_25pct(:,7), dist_areaPercent_25pct_to_50pct(:,7), dist_areaPercent_50pct_to_75pct(:,7), dist_areaPercent_75pct_to_100pct(:,7)];
EndToEndDist_actualAreaVal_areapercent_all_norm(:,1:2) = EndToEndDist_actualAreaVal_areapercent_all(:,1:2) / max_length_of_all_AreaVal; % max_End2enddist_actualAreaValue;
EndToEndDist_actualAreaVal_areapercent_all_norm(:,3:6) = EndToEndDist_actualAreaVal_areapercent_all(:,3:6) / max_length_of_all_AreaPercent; % max_End2enddist_AreaPercent;

% Tortuosity for actual area Value splits
% Early phase of area expansion (0-150µm2)
tortuosity_early_expansion_AreaVal = contourDist_actualAreaVal_areapercent_all_norm(:,1) ./ EndToEndDist_actualAreaVal_areapercent_all_norm(:,1); tortuosity_early_expansion_AreaVal(tortuosity_early_expansion_AreaVal==Inf) = NaN;
% Late phase expansion (150µm2-final area)
tortuosity_late_expansion_AreaVal = contourDist_actualAreaVal_areapercent_all_norm(:,2) ./ EndToEndDist_actualAreaVal_areapercent_all_norm(:,2); tortuosity_late_expansion_AreaVal(tortuosity_late_expansion_AreaVal==Inf) = NaN;

% Tortuosity for Area percentage splits
% 0 - 25%
tortuosity_25_PercentArea = contourDist_actualAreaVal_areapercent_all_norm(:,3) ./ EndToEndDist_actualAreaVal_areapercent_all_norm(:,3); tortuosity_25_PercentArea(tortuosity_25_PercentArea==Inf) = NaN;
% 25% -50%
tortuosity_50_PercentArea = contourDist_actualAreaVal_areapercent_all_norm(:,4) ./ EndToEndDist_actualAreaVal_areapercent_all_norm(:,4); tortuosity_50_PercentArea(tortuosity_50_PercentArea==Inf) = NaN;
% 50% - 75%
tortuosity_75_PercentArea = contourDist_actualAreaVal_areapercent_all_norm(:,5) ./ EndToEndDist_actualAreaVal_areapercent_all_norm(:,5); tortuosity_75_PercentArea(tortuosity_75_PercentArea==Inf) = NaN;
% 75% - 100%
tortuosity_100_PercentArea = contourDist_actualAreaVal_areapercent_all_norm(:,6) ./ EndToEndDist_actualAreaVal_areapercent_all_norm(:,6); tortuosity_100_PercentArea(tortuosity_100_PercentArea==Inf) = NaN;

% plotting all the distances
legnd_list_1 = {'Early expansion phase', 'Late expansion phase'}; legnd_list_2 = {'0-25%', '25%-50%', '50%-75%', '75%-100%'}; linecolors = ['b' 'k' 'm' 'r'];

% contour distance: comparing 1µm2-150µm2 & 150µm2-final area ('area_increment_actualvalue') 
prm = contourDist_actualAreaVal_areapercent_all(:,1:2); prm_mean = mean(prm, "omitnan"); 
box_plots(prm, prm_mean, 'Contour distance [\mum]', {'Comparing the contour distances between', strcat('(0-', sprintf('%01d', area_split_value), 'µm2) & (', sprintf('%01d', area_split_value), 'µm2-max value) area ranges')}, strcat('contour_dist_ActualArea_', sprintf('%01d', area_split_value),'um2'), BB_apical, legnd_list_1, linecolors);
clear prm prm_mean

% End-to-End distance: comparing 1µm2-150µm2 & 150µm2-final area ('area_increment_actualvalue') 
prm = EndToEndDist_actualAreaVal_areapercent_all(:,1:2); prm_mean = mean(prm, "omitnan"); 
box_plots(prm, prm_mean, 'End-to-End distance [\mum]', {'Comparing the End-to-end distances between', strcat('(0-', sprintf('%01d', area_split_value), 'µm2) & (', sprintf('%01d', area_split_value), 'µm2-max value) area ranges')}, strcat('endtoend_dist_ActualArea_', sprintf('%01d', area_split_value),'um2'), BB_apical, legnd_list_1, linecolors);
clear prm prm_mean

% contour distance: comparing area percentages (0-25%; 25%-50%; 50%-75%; 75%-100%) ('area_increment_percent') 
prm = contourDist_actualAreaVal_areapercent_all(:,3:6); prm_mean = mean(prm, "omitnan"); 
box_plots(prm, prm_mean, 'Contour distance [\mum]', {'Comparing the contour distances between', 'different area percentages'}, 'contour_dist_PercentArea', BB_apical, legnd_list_2, linecolors);
clear prm prm_mean

% End-to-End distance: comparing area percentages (0-25%; 25%-50%; 50%-75%; 75%-100%) ('area_increment_percent') 
prm = EndToEndDist_actualAreaVal_areapercent_all(:,3:6); prm_mean = mean(prm, "omitnan"); 
box_plots(prm, prm_mean, 'End-to-End distance [\mum]', {'Comparing the End-to-end distances between', 'different area percentages'}, 'endtoend_dist_PercentArea', BB_apical, legnd_list_2, linecolors);
clear prm prm_mean

% Totuosity comparison: Actual area value
prm = [tortuosity_early_expansion_AreaVal, tortuosity_late_expansion_AreaVal]; prm_mean = mean(prm, "omitnan"); 
box_plots(prm, prm_mean, 'Tortuosity', {'Tortuosity comparison between', strcat('(0-', sprintf('%01d', area_split_value), 'µm2) & (', sprintf('%01d', area_split_value), 'µm2-max value) area ranges')}, strcat('tortuosity_ActualArea_', sprintf('%01d', area_split_value), 'um2'), BB_apical, legnd_list_1, linecolors);
clear prm prm_mean
% Totuosity comparison: Area percentage
prm = [tortuosity_25_PercentArea, tortuosity_50_PercentArea, tortuosity_75_PercentArea, tortuosity_100_PercentArea]; prm_mean = mean(prm, "omitnan"); 
box_plots(prm, prm_mean, 'Tortuosity', {'Tortuosity comparison between', 'different percentages of expansion'}, 'tortuosity_PercentArea', BB_apical, legnd_list_2, linecolors);
clear prm prm_mean

%%
% saving workspace
workspace_name = strcat('workspace_dist_early_late_expansion_', sprintf('%01d', area_split_value), 'um2');
save(workspace_name);

%%
% Saving the figures as montage
montage_fig = '../Plots/montage';
fig1 = fullfile(BB_apical, strcat('contour_dist_ActualArea_', sprintf('%01d', area_split_value),'um2.tif'));
fig2 = fullfile(BB_apical, strcat('endtoend_dist_ActualArea_', sprintf('%01d', area_split_value),'um2.tif')); 
fig3 = fullfile(BB_apical, 'contour_dist_PercentArea.tif');
fig4 = fullfile(BB_apical, 'endtoend_dist_PercentArea.tif');
fig5= fullfile(BB_apical, strcat('tortuosity_ActualArea_', sprintf('%01d', area_split_value), 'um2.tif'));
fig6 = fullfile(BB_apical, 'tortuosity_PercentArea.tif');
montage({fig1, fig2, fig3, fig4, fig5, fig6});
montage_fig_name = strcat('slide_21_dist_early_late_expansion_', sprintf('%01d', area_split_value), 'um2');
saveas(gcf, fullfile(montage_fig, montage_fig_name), 'tif');

close all;
disp('Finished !');

%% Function 1 (section 1)
% This function plots the histogram and bar plots for the 'x' & 'y' distances
function hist_dist_plot(parameter, Xlabel, Ylabel, Plot_title, BB_apical, save_title)
% Binning the data
figure(100);
binparameter = parameter(~isnan(parameter));
binrange = min(binparameter):0.025:max(binparameter); % setting the bin range based on the input data which is the distances
[N, ~] = histcounts(binparameter, binrange); % here 'N' corresponds to the counts or the repeats of the data; and edges is same as the binrange defined above.
binrange1 = binrange(1:end-1); % changing the binrange length to match the length of N so that they can be plotted together.
barplot = bar(binrange1, N); barplot.FaceColor = 'r'; barplot.EdgeColor = 'b';
xlabel(Xlabel);  ylabel(Ylabel); title(Plot_title);  set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, save_title), 'fig'); saveas(gcf, fullfile(BB_apical, save_title), 'tif');
close (figure(100));
clear parameter xLabel yLabel plot_Title BB_apical save_title
end

%% Function 2 (section 2)
% This function gets the starting & ending frame numbers and uses them to find the distance of the trajectory between these frame numbers and stores them in a matrix.
function [dist_matrix] = fetching_distances(first_frame, last_frame, idx_1, idx_2, xcrdns, ycrdns, trajno, area_val, pixelwidth)
last_frame = min(last_frame, size(xcrdns,1)); % sometimes the last_frame can be more than the total trajectory length itself. Meaning, the trajectory may not be present at this frame number. Therefore, we choose the smallest between the 
% the last frame of the trajectory & last_frame which is obtained based on either the actual area value or area percentage
if  (last_frame - first_frame) > 10 % the distances are calculated only if the two area values (both for actual area & percentage) are 10 frames apart; otherwise the distance is taken as a 'NaN'
    
    xcds = xcrdns(first_frame:last_frame, 1) * pixelwidth; % getting the x coordinates
    ycds = ycrdns(first_frame:last_frame, 1) * pixelwidth; % getting the y coordinates

    % contour distance
    dx = diff(xcds); dy = diff(ycds); % getting the difference in x & y coordinates for the whole trajectory
    stp_distances = sqrt(dx.^2 + dy.^2); % getting all the distnaces between subsequent steps for the whole trajectory
    contour_distance = sum(stp_distances, 'omitnan'); % summing all the distances to get the contour distance in micrometers

    % End-to-end distance
    edx = xcds(end, 1) - xcds(1,1); % getting the difference between first & last x coordinate
    edy = ycds(end, 1) - ycds(1,1); % getting the difference between first & last y coordinate
    end_to_end_dist = sqrt(edx^2 + edy^2); % getting the end-to-end distance for the trajectory
    % the if condition below makes sure that the end-to-end distance is never zero. Sometimes, the first and last points of the trajctory can be same and in that case, the end-to-end distance will become zero. So to avoid 
    % issues while obtaining Tortuosity or in those sitatuions where the end-to-end distance is used in the denominator, we substitute the zero with a low value '0.01'.
    if end_to_end_dist == 0
        end_to_end_dist = 0.01;
    end
    
    dist_matrix(1,1) = trajno; % trajectory number
    dist_matrix(1,2) = first_frame; % starting frame number
    dist_matrix(1,3) = last_frame; % last frame number
    dist_matrix(1,4) = area_val(idx_1, 3); % starting apical area; If you want the actual area, then use '2' instead of '3'; Because 2nd column of 'area_increment_actualvalue' contains the actual apical areas
    dist_matrix(1,5) = area_val(idx_2, 3); % ending apical area; If you want the actual area, then use '2' instead of '3'; Because 2nd of 'area_increment_actualvalue' column contains the actual apical areas
    dist_matrix(1,6) = contour_distance; % contour distance for this trajectory for this particular apical domain area range
    dist_matrix(1,7) = end_to_end_dist; % end-to-end distance for this trajectory for this particular apical domain area range
else
    dist_matrix(1,1) = trajno; % trajectory number
    dist_matrix(1,2) = first_frame; % starting frame number
    dist_matrix(1,3) = last_frame; % last frame number
    dist_matrix(1,4) = area_val(idx_1, 3); % starting apical area; If you want the actual area, then use '2' instead of '3'; Because 2nd column of 'area_increment_actualvalue' contains the actual apical areas
    dist_matrix(1,5) = area_val(idx_2, 3); % ending apical area; If you want the actual area, then use '2' instead of '3'; Because 2nd column of 'area_increment_actualvalue' contains the actual apical areas
    dist_matrix(1,6) = NaN; % since the distance will not be calculated, it is registered as NaN
    dist_matrix(1,7) = NaN; % since the distance will not be calculated, it is registered as NaN
end
end

%% Function 3 (section 2)
% This function plots the box plots
function box_plots(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical, legnd_list, linecolors)
edge_alphavalue = 1; % 0.5
size_data = 15; % 12
fig200 = figure(200);
% creating a swarm plot which is an alternative to scatter plot
grp1 = repmat(1:size(prm,2), size(prm,1), 1);
swarmchart(grp1(:), prm(:), 'o', 'r', 'MarkerFaceAlpha', 0, 'MarkerEdgeAlpha', edge_alphavalue, 'SizeData', size_data);
hold on;
% creating a box plot
grp2 = repmat(1:size(prm,2), 1, 1);
bxp1 = boxplot(prm, grp2, 'labels', legnd_list, 'BoxStyle', 'outline', 'Colors', linecolors, 'Symbol',''); %  in order to plot the outliers, add some symbols like '.', 'o'etc to 'symbol'. Right now, the outliers are disabled by leaving the space empty.
set(bxp1, 'LineWidth', 1);
hold on;
% plotting the mean
plot(prm_mean, 'x-m', 'LineWidth', 2); % plotting the mean value
ylabel(Ylabel); title(Plot_title);  set(gca,'fontsize',12);
saveas(fig200, fullfile(BB_apical, save_title), 'fig'); saveas(fig200, fullfile(BB_apical, save_title), 'tif');
%pause;
close(figure(200));
end

%%






































