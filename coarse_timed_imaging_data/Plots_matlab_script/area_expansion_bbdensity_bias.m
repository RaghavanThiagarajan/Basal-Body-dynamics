%% Raghavan Thiagarajan, reNEW Copenhagen, June 2024

% This script is to run the quadrant analysis where the apical area of the cell is split into 4 quadrants and different parameters like quadrant areas, BB density, BB appearance count, actin intensity etc are obtained for each quadrant. 
% The motivation for this analysis is to discretize the apical area into local regions and check how the BB and actin characteristics change locally. 

% The code works like this: First we fetch the area periphery values (with or without the cortex), the centroid values, BB coordinates (of both existing & newly appearing). Then for obtained periphery coordinates, we get the theta and 
% then split into four parts: [0, pi/2]; [pi/2, pi]; [-pi, -pi/2]; [-pi/2, 0] each corresponding to a quadrant. Then we obtain the information about area, number of BBs, actin intensity etc for each of these quadrants. The actin 
% intensities are fetched through a separate Fiji script that uses the quadrant peripheries to define the different areas. We do the same by splitting the apical area into 2 halves (each for left-right & top-bottom; so technically 4 halves) 
% and get all the parameters. Finally, we create the area, BB density, mean intensity of actin & total intensity of actin as color coded images and all parameters as plots for all quadrants (& halves). For enabling the comparison of values 
% across cells/experiments, we sort the quadrants (& halves) in increasing BB density i.e. the quadrant (or half) with the lowest BB density becomes the 1st quadrant (or half) by default and the quadrant (or half) with the highest BB density 
% becomes the last quadrant (or half) by default. 

%%
tic
clc
close all
clear all

%% User prompt
disp('Run the macro "apical_domain_periphery_coordinates.ijm". Then press a key !')
pause;

%% Initialising folders, savelinks, and importing data

mkdir '../Plots/bb_density_distribution_expansion_bias'
mkdir '../Plots/bb_density_distribution_expansion_bias/parameter_plots'
mkdir '../Plots/bb_density_distribution_expansion_bias/area_bb_quad'
mkdir '../Plots/bb_density_distribution_expansion_bias/area_bb_topbottom_half'
mkdir '../Plots/bb_density_distribution_expansion_bias/area_bb_leftright_half'
mkdir '../Plots/bb_density_distribution_expansion_bias/bb_density_quad'
mkdir '../Plots/bb_density_distribution_expansion_bias/bb_density_topbottom_half'
mkdir '../Plots/bb_density_distribution_expansion_bias/bb_density_leftright_half'
mkdir '../Plots/bb_density_distribution_expansion_bias/actin_meanint_quad'
mkdir '../Plots/bb_density_distribution_expansion_bias/actin_meanint_topbottom_half'
mkdir '../Plots/bb_density_distribution_expansion_bias/actin_meanint_leftright_half'
mkdir '../Plots/bb_density_distribution_expansion_bias/actin_totalint_quad'
mkdir '../Plots/bb_density_distribution_expansion_bias/actin_totalint_topbottom_half'
mkdir '../Plots/bb_density_distribution_expansion_bias/actin_totalint_leftright_half'
save_link_main_folder = '../Plots/bb_density_distribution_expansion_bias'; % location where the .csv file containing the quadrant & half periphery coordinates will be saved for use by ImageJ
savelink_parameter_plots = '../Plots/bb_density_distribution_expansion_bias/parameter_plots'; % location where the parameter plots will be saved
savelink_area_bb_quad = '../Plots/bb_density_distribution_expansion_bias/area_bb_quad'; % location where the plot figs of quadrant areas and BBs will be saved from the parfor loop
savelink_topbottom_half = '../Plots/bb_density_distribution_expansion_bias/area_bb_topbottom_half'; % location where the plot figs of areas and BBs from Top-Bottom halves will be saved from the parfor loop
savelink_leftright_half = '../Plots/bb_density_distribution_expansion_bias/area_bb_leftright_half'; % location where the plot figs of areas and BBs from Left-Right halves will be saved from the parfor loop
savelink_bb_density_quad = '../Plots/bb_density_distribution_expansion_bias/bb_density_quad'; % location where the color coded BB density for all four quadrants will be saved from the parfor loop
savelink_bb_density_topbottom_half = '../Plots/bb_density_distribution_expansion_bias/bb_density_topbottom_half'; % location where the color coded BB density for Top-Bottom halves will be saved from the parfor loop
savelink_bb_density_leftright_half = '../Plots/bb_density_distribution_expansion_bias/bb_density_leftright_half'; % location where the color coded BB density for Left-Right halves will be saved from the parfor loop
savelink_actinMeanint_quad = '../Plots/bb_density_distribution_expansion_bias/actin_meanint_quad'; % location where the color coded mean intensity of actin for all four quadrants will be saved from the parfor loop
savelink_actinMeanint_topbottom_half = '../Plots/bb_density_distribution_expansion_bias/actin_meanint_topbottom_half'; % location where the color coded mean intensity of actin for all the top-bottom halves will be saved from the parfor loop
savelink_actinMeanint_leftright_half = '../Plots/bb_density_distribution_expansion_bias/actin_meanint_leftright_half'; % location where the color coded mean intensity of actin for all the left-right halves will be saved from the parfor loop
savelink_actinTotalint_quad = '../Plots/bb_density_distribution_expansion_bias/actin_totalint_quad'; % location where the color coded total intensity of actin for all four quadrants will be saved from the parfor loop
savelink_actinTotalint_topbottom_half = '../Plots/bb_density_distribution_expansion_bias/actin_totalint_topbottom_half'; % location where the color coded total intensity of actin for all the top-bottom halves will be saved from the parfor loop
savelink_actinTotalint_leftright_half = '../Plots/bb_density_distribution_expansion_bias/actin_totalint_leftright_half'; % location where the color coded total intensity of actin for all the left-right halves will be saved from the parfor loop

load('workspace_interim.mat', 'Image_dime', 'pixelwidth', 'Time_interval', 'No_of_timepoints', 'area_rate_time_interval', 'area_rate_frame_interval', 'whole_area_rate', 'area_rate', 'no_of_trajectories', 'MeanIntensity_apicaldomain', 'TotalIntensity_apicaldomain', 'cortex_meanint', 'cortex_totalint');
% fetching the area periphery values with cortex
Area_Periphery = readtable('../data/Apical_domain_periphery_cords_with_cortex.csv');
Area_Periphery_Matrix_px = table2array(Area_Periphery);
Area_Periphery_Matrix_um = Area_Periphery_Matrix_px * pixelwidth;
area_periphery_coord = Area_Periphery_Matrix_um;

% fetching the area periphery values without cortex for actin intensity measurements
Area_Periphery_wtout_cortex = readtable('../data/Apical_domain_periphery_cords_without_cortex.csv');
Area_Periphery_Matrix_wtout_cortex_px = table2array(Area_Periphery_wtout_cortex);
Area_Periphery_Matrix_wtout_cortex_um = Area_Periphery_Matrix_wtout_cortex_px * pixelwidth;
area_periphery_coord_wtout_cortex = Area_Periphery_Matrix_wtout_cortex_um;

% fetching the centroid values
load('workspace_BB_distance_consequent_frames.mat', 'Whole_roi_measure_all_data');
centroid_coord(:,1) = Whole_roi_measure_all_data(:,8); % centroid values are already in micrometers
centroid_coord(:,2) = Whole_roi_measure_all_data(:,9); % centroid values are already in micrometers
clear Whole_roi_measure_all_data table_bb_coordinates

% fetching the coordinates of newly appearing BBs
load('workspace_with_t0_data_all.mat', 'TrajecInitPos', 'frm_nmb_modified', 'basalbody_count_modified'); % fetching the newly appearing BBs without filtering the trajectories
[table_bb_coordinates] = new_BB_without_filter(TrajecInitPos, Time_interval, frm_nmb_modified, basalbody_count_modified);
% % The line below will be used (i.e uncommented) if only those BBs (or trajectories) after filtering from 'traj_filter_duration' are to be plotted; In this case, the lines above concerning 'table_bb_coordinates' should be commented
% load('workspace_BB_distance_consequent_frames.mat', 'table_bb_coordinates');
new_bb_crds = table2array(table_bb_coordinates); % In this array, 1st frame is the frame number in which the BB appears; 2nd frame is the no.of newly appearing BBs; and the subsequent frames are the BB coordinates of the newly appearing BBs
clear TrajecInitPos frm_nmb_modified basalbody_count_modified table_bb_coordinates
new_bb_crds(new_bb_crds==0) = NaN;
new_bb_crds(:,3:end) = new_bb_crds(:,3:end) * pixelwidth;
% modifying the matrix 'new_bb_crds' in a way that the missing frames are filled with NaNs - in other words, those frames that do not get a new BB are filled with NaNs.
full_range = (1:No_of_timepoints)';
new_bb_crds_full = NaN(length(full_range), size(new_bb_crds, 2));
[~, idx] = ismember(new_bb_crds(:,1), full_range);
new_bb_crds_full(idx, :) = new_bb_crds; % this is the matrix where we have the coordinates of newly appearing BBs; in those frames where there are no new BBs, these rows are filled with NaNs

% fetching BB coordinates
load('workspace_BB_distance_same_frame.mat', 'Trajectory_data', 'Area_apicaldomain', 'No_of_BB', 'Filtered_frame_wise_data_final');
% The following lines will be used (i.e uncommented) if all BBs (or trajectories) without any filtering from 'traj_filter_duration' are to be plotted; In this case, the lines below concerning 'Filtered_frame_wise_data_um' should be commented
[frame_wise_data_final] = frame_wise_BB_matrix_construction(Trajectory_data, Area_apicaldomain, No_of_BB); % calling the function that constructs the BB data into a matrix of framewise manner
frame_wise_data_um = frame_wise_data_final; % reassigning the BB data
frame_wise_data_um(:, 5:end) = frame_wise_data_um(:, 5:end) * pixelwidth; % converting the BB coordinates to micrometer values
frame_wise_BB_matrix = frame_wise_data_um;
% % The following lines will be used (i.e uncommented) if only those BBs (or trajectories) after filtering from 'traj_filter_duration' are to be plotted; In this case, the lines above concerning 'frame_wise_data_um' should be commented
% Filtered_frame_wise_data_um = Filtered_frame_wise_data_final; % reassigning the BB data
% Filtered_frame_wise_data_um(:, 5:end) = Filtered_frame_wise_data_um(:, 5:end) * pixelwidth; % converting the BB coordinates to micrometer values
% frame_wise_BB_matrix = Filtered_frame_wise_data_um;
clear Trajectory_data Filtered_frame_wise_data_final

%% Defining the Quadrants, Top-Bottom halves, Left-Right halves and plotting them
[coordnates_length, ~] = size(area_periphery_coord); % fetching the no of corrdinates for the periphery coordinates with cortex
[coordnates_length_wtout_cortex, tmepoints] = size(area_periphery_coord_wtout_cortex); % fetching the no of corrdinates for the periphery coordinates without cortex
tmepoints = tmepoints/ 2 ;

% assigning the quadrant details as a cell array
area_quad_wtout_cortex = cell(length(Area_apicaldomain), 8); % Area periphery coordinates without cortex and without adjusting the centroid to (0,0); Here '8' is used because we have 4 cells for 4 quadrants and another 4 cells for 2 top-bottom halves and 2 left-right halves. Each cell contains two vectors corresponding to the x & y coordinates of the
% area periphery coordinates of quadrants & halves. Each row corresponds to a time point. (cell 1, 2, 3 & 4) correspond to the area periphery coordinates of 1st, 2nd, 3rd & 4th quadrants respectively. (cell 5, 6, 7 & 8) correspond to the two halves of top-bottom & two halves of left-right respectively.
area_quadrant_bb_details = cell(length(Area_apicaldomain), 10); % The area periphery coordinates in this cell array include the cortex and will be adjusted so that the centroid is (0,0); '10' is used because we have 1 cell for area periphery coordinates, 4 cells for 4 quadrants respectively, 6th cell for BB coordinates, 7th & 8th cell for the top & bottom halves respectively,
% 9th & 10th cells for the left & right halves respectively. In these cell arrays, the rows correspond to the number of timepoints. (cell1) correspond to full area periphery coordinates; (cell 2, 3, 4, 5) correspond to the area periphery coordinates of 1st, 2nd, 3rd & 4th quadrants respectively; (cell6) corresponds to the coordinates of BBs;
% (cell 7, 8, 9, 10) correspond to the periphery coordinates of the two halves of top-bottom and two halves of left-right sides respectively;
% Within each cell array, there are two columns where they correspond to 'x' & 'y' coordinates respectively
quad_Indx = cell(tmepoints, 4); % data with cortex; % '4' corresponds to the no of quadrants; In total there will be 'tmepoints' no of rows and '4' columns in this cell array. Each row corresponds to a timepoint. Each cell contains a vector that corresponds to the indices of area periphery coordinates for
% that quadrant, of that timepoint. These indices are sorted based on theta (thats why they correspond to a specific quadrant)
quad_pogn = cell(tmepoints, 4); % data with cortex; % '4' corresponds to the no of quadrants; In total there will be 'tmepoints' no of rows and '4' columns in this cell array. Each row corresponds to a timepoint. Each cell contains two vectors that correspond to the x & y coordinates of the area
% periphery coordinates for that quadrant, of that timepoint. These coordinates are obtained from the polyshape function.
half_Indx = cell(tmepoints, 4); % data with cortex; % '4' corresponds to the total no of halves: top/bottom/left/right halves, respectively. In total there will be 'tmepoints' no of rows and '4' columns in this cell array. Each row corresponds to a timepoint. Each cell contains a vector that corresponds to the indices
% of area periphery coordinates for that half, of that timepoint. These indices are sorted based on theta (thats why they correspond to a specific half)

% assigning the theta vector
theta = nan(coordnates_length, tmepoints); % preallocating for obtaining theta for the periphery coordinates that include cortex
theta_wtout_cortex = nan(coordnates_length_wtout_cortex, tmepoints); % preallocating for obtaining theta for the periphery coordinates without cortex
% Data organisation in 'quadrant_area' & 'quadrant_BBs' matrices below (in the explanation below, data refers to either area or BB count)
% col 1 = Frame number / Time; col 2 = Apical area; % col 3 = data of quadrant 1 (0 -to- pi/2); col 4 = data of quadrant 2 (pi/2 -to- pi); col 5 = data of quadrant 3 (-pi -to- -pi/2); col 6 = data of quadrant 4 (-pi/2 -to- 0); col 7 = data of top-bottom half 1 (pi/2 -to- -pi/2);
% col 8 = data of top-bottom half 2 (-pi/2 -to- pi/2); col 9 = data of left-right half 1 (0 -to- pi); col 10 = data of left-right half 2 (-pi -to- 0);
% assigning quadrant area from the periphery coordinates that include cortex
quadrant_area = nan(tmepoints, 10);
quadrant_area(:,1) = (1:No_of_timepoints) * Time_interval;
quadrant_area(:,2) = Area_apicaldomain;
% Predefining a matrix so that the BB details can be assigned to the respective quadrants
quadrant_BBs = nan(tmepoints, 10);
quadrant_BBs(:,1) = (1:No_of_timepoints) * Time_interval;
quadrant_BBs(:,2) = Area_apicaldomain;
% Predefining a matrix so that the newly appearing BB details can be assigned to the respective quadrants
quadrant_new_BBs(:,1) = new_bb_crds_full(:,1) * Time_interval;
new_BB_area = Area_apicaldomain; new_BB_area(isnan(new_bb_crds_full(:,1))) = NaN;
quadrant_new_BBs(:,2) = new_BB_area;

xcord = 1; ycord = 2;
for i = 1 : tmepoints
    % Getting Centroid coordinates
    curr_centroid_x = centroid_coord(i, 1);
    curr_centroid_y = centroid_coord(i, 2);
    % Fetching (all) BB coordinates 
    if ~ismember(i, frame_wise_BB_matrix(:,1))
        curr_bb_coord_x = NaN; 
        curr_bb_coord_y = NaN;
        area_quadrant_bb_details{i,6}(:,1) = curr_bb_coord_x;
        area_quadrant_bb_details{i,6}(:,2) = curr_bb_coord_y;        
    else
        bb_fram_idx = find(frame_wise_BB_matrix(:,1) == i);
        curr_bb_crd_x = frame_wise_BB_matrix(bb_fram_idx, 5:2:end-1);
        curr_bb_coord_x = curr_bb_crd_x - curr_centroid_x;
        curr_bb_crd_y = frame_wise_BB_matrix(bb_fram_idx, 6:2:end);
        curr_bb_coord_y = curr_bb_crd_y - curr_centroid_y;
        area_quadrant_bb_details{i,6}(:,1) = curr_bb_coord_x;
        area_quadrant_bb_details{i,6}(:,2) = curr_bb_coord_y;        
    end
    % Fetching newly appearing BB coordinates 
    if ~ismember(i, new_bb_crds_full(:,1))
        curr_Newbb_coord_x = NaN; % assigning new BB coordinates
        curr_Newbb_coord_y = NaN; % assigning new BB coordinates
    else
        Newbb_fram_idx = find(new_bb_crds_full(:,1) == i); % for assigning the new BB coordinates
        curr_Newbb_crd_x = new_bb_crds_full(Newbb_fram_idx, 3:2:end-1); % assigning new BB coordinates
        curr_Newbb_coord_x = curr_Newbb_crd_x - curr_centroid_x; % adjusting for centroid
        curr_Newbb_crd_y = new_bb_crds_full(Newbb_fram_idx, 4:2:end); % assigning new BB coordinates
        curr_Newbb_coord_y = curr_Newbb_crd_y - curr_centroid_y; % adjusting for centroid
    end

    % Getting area coordinates (that includes cortex), quadrant areas, BB density in quadrants
    curr_area_coord_x = area_periphery_coord(:, xcord); curr_area_coord_x = curr_area_coord_x(~isnan(curr_area_coord_x));
    curr_area_coord_y = area_periphery_coord(:, ycord); curr_area_coord_y = curr_area_coord_y(~isnan(curr_area_coord_y));
    curr_area_coord_x = curr_area_coord_x - curr_centroid_x; curr_area_coord_y = curr_area_coord_y - curr_centroid_y;
    area_quadrant_bb_details{i,1}(:,1) = curr_area_coord_x; area_quadrant_bb_details{i,1}(:,2) = curr_area_coord_y; % filling the details of area periphery coordinates

    % Getting area coordinates (without cortex) in quadrants
    curr_area_coord_x_wtout_cortex = area_periphery_coord_wtout_cortex(:, xcord); curr_area_coord_x_wtout_cortex = curr_area_coord_x_wtout_cortex(~isnan(curr_area_coord_x_wtout_cortex));
    curr_area_coord_y_wtout_cortex = area_periphery_coord_wtout_cortex(:, ycord); curr_area_coord_y_wtout_cortex = curr_area_coord_y_wtout_cortex(~isnan(curr_area_coord_y_wtout_cortex));
    % curr_area_coord_x_wtout_cortex = curr_area_coord_x_wtout_cortex - curr_centroid_x; curr_area_coord_y_wtout_cortex = curr_area_coord_y_wtout_cortex - curr_centroid_y;
    curr_area_coord_x_wtout_cortex_TempCentroidAdjust = curr_area_coord_x_wtout_cortex - curr_centroid_x; curr_area_coord_y_wtout_cortex_TempCentroidAdjust = curr_area_coord_y_wtout_cortex - curr_centroid_y;

    % getting the theta for the periphery coordinates
    theta((1:length(curr_area_coord_x)),i) = atan2(curr_area_coord_y, curr_area_coord_x); % coordinates that includes cortex
    % theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) = atan2(curr_area_coord_y_wtout_cortex, curr_area_coord_x_wtout_cortex); % coordinates without cortex
    theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex_TempCentroidAdjust)),i) = atan2(curr_area_coord_y_wtout_cortex_TempCentroidAdjust, curr_area_coord_x_wtout_cortex_TempCentroidAdjust); % coordinates without cortex   

    %---------------------------------------- Quadrant plots ---------------------------------------------%

    % ------------- Defining quadrant_1 (0 -to- pi/2) ------------- %
    quad_limits = [0, pi/2];

    % quadrant angles and related details for the periphery coordinates that includes cortex
    quad_1_idx = (theta((1:length(curr_area_coord_x)),i) >= 0) & (theta((1:length(curr_area_coord_x)),i) <= pi/2);
    quad_1_theta = theta(quad_1_idx, i); sortorder = 'descend'; quad_idx = quad_1_idx; quad_theta = quad_1_theta;
    [quad_area_vec_x, quad_area_vec_y, quad_area_pgon_1, quad_area, quad_no_of_BB, quad_no_of_NewBB] = finding_quadrant_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x, curr_area_coord_y, quad_idx, quad_theta, quad_limits, curr_bb_coord_x, curr_bb_coord_y, curr_Newbb_coord_x, curr_Newbb_coord_y, 'with_cortex'); % calling the function that defines and gets the quadrant area
    area_quadrant_bb_details{i,2}(:,1) = quad_area_vec_x; area_quadrant_bb_details{i,2}(:,2) = quad_area_vec_y; % filling the coordinates (that include cortex) of quadrant 1 that are centroid adjusted (i.e. centroid is (0,0))
    quadrant_area(i, 3) = quad_area; % getting the area of quadrant 1 from the coordinates that include cortex
    quadrant_BBs(i, 3) = quad_no_of_BB; % getting the no of BBs in quadrant 1
    quad_Indx{i,1} = quad_1_idx; % saving indices of area periphery coordinates that are sorted based on theta for quadrant 1
    quad_pogn{i,1} = quad_area_pgon_1; % saving the x & y cordinates (centroid adjusted to (0,0)) of the quadrant 1 obtained from polyshape function
    quadrant_new_BBs(i, 3) = quad_no_of_NewBB; % getting the no of newly appearing BBs in quadrant 1

    % quadrant angles and related details for the periphery coordinates without cortex
    quad_1_idx_wtout_cortex = (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) >= 0) & (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) <= pi/2);
    quad_1_theta_wtout_cortex = theta_wtout_cortex(quad_1_idx_wtout_cortex, i); sortorder = 'descend'; quad_idx_wtout_cortex = quad_1_idx_wtout_cortex; quad_theta_wtout_cortex = quad_1_theta_wtout_cortex;
    [quad_area_vec_x_wtout_cortex, quad_area_vec_y_wtout_cortex, ~, ~, ~] = finding_quadrant_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x_wtout_cortex, curr_area_coord_y_wtout_cortex, quad_idx_wtout_cortex, quad_theta_wtout_cortex, quad_limits, curr_bb_coord_x, curr_bb_coord_y, curr_Newbb_coord_x, curr_Newbb_coord_y, 'without_cortex'); % calling the function that defines and gets the quadrant area
    area_quad_wtout_cortex{i,1}(:,1) = quad_area_vec_x_wtout_cortex; area_quad_wtout_cortex{i,1}(:,2) = quad_area_vec_y_wtout_cortex; % filling the coordinates (without cortex) of quadrant 1 that retain the original centroid
    clear quad_limits quad_idx quad_theta quad_idx_wtout_cortex quad_theta_wtout_cortex quad_area_vec_x quad_area_vec_y quad_area_vec_x_wtout_cortex quad_area_vec_y_wtout_cortex

    % ------------- Defining quadrant_2 (pi/2 -to- pi) ------------- %
    quad_limits = [pi/2, pi];

    % quadrant angles and related details for the periphery coordinates that includes cortex
    quad_2_idx = (theta((1:length(curr_area_coord_x)),i) >= pi/2) & (theta((1:length(curr_area_coord_x)),i) <= pi);
    quad_2_theta = theta(quad_2_idx, i); sortorder = 'descend'; quad_idx = quad_2_idx; quad_theta = quad_2_theta;
    [quad_area_vec_x, quad_area_vec_y, quad_area_pgon_2, quad_area, quad_no_of_BB, quad_no_of_NewBB] = finding_quadrant_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x, curr_area_coord_y, quad_idx, quad_theta, quad_limits, curr_bb_coord_x, curr_bb_coord_y, curr_Newbb_coord_x, curr_Newbb_coord_y, 'with_cortex'); % calling the function that defines and gets the quadrant area
    area_quadrant_bb_details{i,3}(:,1) = quad_area_vec_x; area_quadrant_bb_details{i,3}(:,2) = quad_area_vec_y; % filling the coordinates of quadrant 2 that are centroid adjusted (i.e. centroid is (0,0))
    quadrant_area(i, 4) = quad_area; % getting the area of quadrant 2 from the coordinates that include cortex
    quadrant_BBs(i, 4) = quad_no_of_BB; % getting the no of BBs in quadrant 2
    quad_Indx{i,2} = quad_2_idx; % saving indices of area periphery coordinates that are sorted based on theta for quadrant 2
    quad_pogn{i,2} = quad_area_pgon_2; % saving the x & y cordinates (centroid adjusted to (0,0)) of the quadrant 2 obtained from polyshape function
    quadrant_new_BBs(i, 4) = quad_no_of_NewBB; % getting the no of newly appearing BBs in quadrant 2

    % quadrant angles and related details for the periphery coordinates without cortex
    quad_2_idx_wtout_cortex = (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) >= pi/2) & (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) <= pi);
    quad_2_theta_wtout_cortex = theta_wtout_cortex(quad_2_idx_wtout_cortex, i); sortorder = 'descend'; quad_idx_wtout_cortex = quad_2_idx_wtout_cortex; quad_theta_wtout_cortex = quad_2_theta_wtout_cortex;
    [quad_area_vec_x_wtout_cortex, quad_area_vec_y_wtout_cortex, ~, ~, ~] = finding_quadrant_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x_wtout_cortex, curr_area_coord_y_wtout_cortex, quad_idx_wtout_cortex, quad_theta_wtout_cortex, quad_limits, curr_bb_coord_x, curr_bb_coord_y, curr_Newbb_coord_x, curr_Newbb_coord_y, 'without_cortex'); % calling the function that defines and gets the quadrant area
    area_quad_wtout_cortex{i,2}(:,1) = quad_area_vec_x_wtout_cortex; area_quad_wtout_cortex{i,2}(:,2) = quad_area_vec_y_wtout_cortex; % filling the coordinates (without cortex) of quadrant 2 that retain the original centroid
    clear quad_limits quad_idx quad_theta quad_idx_wtout_cortex quad_theta_wtout_cortex quad_area_vec_x quad_area_vec_y quad_area_vec_x_wtout_cortex quad_area_vec_y_wtout_cortex

    % ------------- Defining quadrant_3 (-pi -to- -pi/2) ------------- %
    quad_limits = [-pi, -pi/2];

    % quadrant angles and related details for the periphery coordinates that includes cortex
    quad_3_idx = (theta((1:length(curr_area_coord_x)),i) >= -pi) & (theta((1:length(curr_area_coord_x)),i) <= -pi/2);
    quad_3_theta = theta(quad_3_idx, i); sortorder = 'ascend'; quad_idx = quad_3_idx; quad_theta = quad_3_theta;
    [quad_area_vec_x, quad_area_vec_y, quad_area_pgon_3, quad_area, quad_no_of_BB, quad_no_of_NewBB] = finding_quadrant_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x, curr_area_coord_y, quad_idx, quad_theta, quad_limits, curr_bb_coord_x, curr_bb_coord_y, curr_Newbb_coord_x, curr_Newbb_coord_y, 'with_cortex'); % calling the function that defines and gets the quadrant area
    area_quadrant_bb_details{i,4}(:,1) = quad_area_vec_x; area_quadrant_bb_details{i,4}(:,2) = quad_area_vec_y; % filling the coordinates of quadrant 3 that are centroid adjusted (i.e. centroid is (0,0))
    quadrant_area(i, 5) = quad_area; % getting the area of quadrant 3 from the coordinates that include cortex
    quadrant_BBs(i, 5) = quad_no_of_BB; % getting the no of BBs in quadrant 3
    quad_Indx{i,3} = quad_3_idx; % saving indices of area periphery coordinates that are sorted based on theta for quadrant 3
    quad_pogn{i,3} = quad_area_pgon_3; % saving the x & y cordinates (centroid adjusted to (0,0)) of the quadrant 3 obtained from polyshape function
    quadrant_new_BBs(i, 5) = quad_no_of_NewBB; % getting the no of newly appearing BBs in quadrant 3

    % quadrant angles and related details for the periphery coordinates that includes cortex
    quad_3_idx_wtout_cortex = (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) >= -pi) & (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) <= -pi/2);
    quad_3_theta_wtout_cortex = theta_wtout_cortex(quad_3_idx_wtout_cortex, i); sortorder = 'ascend'; quad_idx_wtout_cortex = quad_3_idx_wtout_cortex; quad_theta_wtout_cortex = quad_3_theta_wtout_cortex;
    [quad_area_vec_x_wtout_cortex, quad_area_vec_y_wtout_cortex, ~, ~, ~] = finding_quadrant_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x_wtout_cortex, curr_area_coord_y_wtout_cortex, quad_idx_wtout_cortex, quad_theta_wtout_cortex, quad_limits, curr_bb_coord_x, curr_bb_coord_y, curr_Newbb_coord_x, curr_Newbb_coord_y, 'without_cortex'); % calling the function that defines and gets the quadrant area
    area_quad_wtout_cortex{i,3}(:,1) = quad_area_vec_x_wtout_cortex; area_quad_wtout_cortex{i,3}(:,2) = quad_area_vec_y_wtout_cortex; % filling the coordinates (without cortex) of quadrant 3 that retain the original centroid
    clear quad_limits quad_idx quad_theta quad_idx_wtout_cortex quad_theta_wtout_cortex quad_area_vec_x quad_area_vec_y quad_area_vec_x_wtout_cortex quad_area_vec_y_wtout_cortex

    % ------------- Defining quadrant_4 (-pi/2 -to- 0) ------------- %
    quad_limits = [-pi/2, 0];

    % quadrant angles and related details for the periphery coordinates that includes cortex
    quad_4_idx = (theta((1:length(curr_area_coord_x)),i) >= -pi/2) & (theta((1:length(curr_area_coord_x)),i) <= 0);
    quad_4_theta = theta(quad_4_idx, i); sortorder = 'ascend'; quad_idx = quad_4_idx; quad_theta = quad_4_theta;
    [quad_area_vec_x, quad_area_vec_y, quad_area_pgon_4, quad_area, quad_no_of_BB, quad_no_of_NewBB] = finding_quadrant_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x, curr_area_coord_y, quad_idx, quad_theta, quad_limits, curr_bb_coord_x, curr_bb_coord_y, curr_Newbb_coord_x, curr_Newbb_coord_y, 'with_cortex'); % calling the function that defines and gets the quadrant area
    area_quadrant_bb_details{i,5}(:,1) = quad_area_vec_x; area_quadrant_bb_details{i,5}(:,2) = quad_area_vec_y; % filling the coordinates of quadrant 4 that are centroid adjusted (i.e. centroid is (0,0))
    quadrant_area(i, 6) = quad_area; % getting the area of quadrant 4 from the coordinates that include cortex
    quadrant_BBs(i, 6) = quad_no_of_BB; % getting the no of BBs in quadrant 4
    quad_Indx{i,4} = quad_4_idx; % saving indices of area periphery coordinates that are sorted based on theta for quadrant 4
    quad_pogn{i,4} = quad_area_pgon_4; % saving the x & y cordinates (centroid adjusted to (0,0)) of the quadrant 4 obtained from polyshape function
    quadrant_new_BBs(i, 6) = quad_no_of_NewBB; % getting the no of newly appearing BBs in quadrant 4

    % quadrant angles and related details for the periphery coordinates that includes cortex
    quad_4_idx_wtout_cortex = (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) >= -pi/2) & (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) <= 0);
    quad_4_theta_wtout_cortex = theta_wtout_cortex(quad_4_idx_wtout_cortex, i); sortorder = 'ascend'; quad_idx_wtout_cortex = quad_4_idx_wtout_cortex; quad_theta_wtout_cortex = quad_4_theta_wtout_cortex;
    [quad_area_vec_x_wtout_cortex, quad_area_vec_y_wtout_cortex, ~, ~, ~] = finding_quadrant_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x_wtout_cortex, curr_area_coord_y_wtout_cortex, quad_idx_wtout_cortex, quad_theta_wtout_cortex, quad_limits, curr_bb_coord_x, curr_bb_coord_y, curr_Newbb_coord_x, curr_Newbb_coord_y, 'without_cortex'); % calling the function that defines and gets the quadrant area
    area_quad_wtout_cortex{i,4}(:,1) = quad_area_vec_x_wtout_cortex; area_quad_wtout_cortex{i,4}(:,2) = quad_area_vec_y_wtout_cortex; % filling the coordinates of quadrant 4 that retain the original centroid
    clear quad_limits quad_idx quad_theta quad_idx_wtout_cortex quad_theta_wtout_cortex quad_area_vec_x quad_area_vec_y quad_area_vec_x_wtout_cortex quad_area_vec_y_wtout_cortex

    clear quad_1_idx quad_2_idx quad_3_idx quad_4_idx quad_1_theta quad_2_theta quad_3_theta quad_4_theta quad_area_pgon_1 quad_area_pgon_2 quad_area_pgon_3 quad_area_pgon_4...
        quad_1_idx_wtout_cortex quad_2_idx_wtout_cortex quad_3_idx_wtout_cortex quad_4_idx_wtout_cortex quad_1_theta_wtout_cortex quad_2_theta_wtout_cortex quad_3_theta_wtout_cortex quad_4_theta_wtout_cortex

    %---------------------------------------- Top Bottom half plots ---------------------------------------------%

    % ------------- Defining half_1 (0 -to- pi) (Bottom half) ------------- %
    % Although the angles (0 -to- pi) of half_1 correspond to the top half in the axis system of matlab, while visualising, this half becomes the bottom half because we apply YDir reverse while plotting.
    % This YDir reverse is to match the yaxis format of imageJ (since the area periphery coordinates are obtaiend from imageJ and they follow the imageJ coordinate system)
    half_limits = [0, pi];

    % angles defining the first top-bottom half and related details for the periphery coordinates that includes cortex
    half_1_idx = (theta((1:length(curr_area_coord_x)),i) >= 0) & (theta((1:length(curr_area_coord_x)),i) <= pi);
    half_1_theta = theta(half_1_idx, i); sortorder = 'ascend'; half_idx = half_1_idx; half_theta = half_1_theta;
    [half_area_vec_x_1, half_area_vec_y_1] = finding_half_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x, curr_area_coord_y, half_idx, half_theta, half_limits, 'with_cortex'); % calling the function that defines and gets the half area
    area_quadrant_bb_details{i,8}(:,1) = half_area_vec_x_1; area_quadrant_bb_details{i,8}(:,2) = half_area_vec_y_1; % filling the coordinates (that includes cortex) of first half and are centroid adjusted (i.e. centroid is (0,0))
    half_Indx{i,2} = half_1_idx;

    % angles defining the first top-bottom half and related details for the periphery coordinates without the cortex
    half_1_idx_wtout_cortex = (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) >= 0) & (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) <= pi);
    half_1_theta_wtout_cortex = theta_wtout_cortex(half_1_idx_wtout_cortex, i); sortorder = 'ascend'; half_idx_wtout_cortex = half_1_idx_wtout_cortex; half_theta_wtout_cortex = half_1_theta_wtout_cortex;
    [half_area_vec_x_wtout_cortex_1, half_area_vec_y_wtout_cortex_1] = finding_half_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x_wtout_cortex, curr_area_coord_y_wtout_cortex, half_idx_wtout_cortex, half_theta_wtout_cortex, half_limits, 'without_cortex'); % calling the function that defines and gets the half area
    area_quad_wtout_cortex{i,6}(:,1) = half_area_vec_x_wtout_cortex_1; area_quad_wtout_cortex{i,6}(:,2) = half_area_vec_y_wtout_cortex_1; % filling the coordinates (without cortex) of first half that retain the original centroid
    clear half_limits half_idx half_theta half_idx_wtout_cortex half_theta_wtout_cortex

    % ------------- Defining half_2 (-pi -to- 0) (Top half) ------------- %
    half_limits = [-pi, 0];
    % Although the angles (0 -to- pi) of half_2 correspond to the bottom half in the axis system of matlab, while visualising, this half becomes the top half because we apply YDir reverse while plotting.
    % This YDir reverse is to match the yaxis format of imageJ (since the area periphery coordinates are obtaiend from imageJ and they follow the imageJ coordinate system)

    % angles defining second top-bottom half and related details for the periphery coordinates that includes cortex
    half_2_idx = (theta((1:length(curr_area_coord_x)),i) >= -pi) & (theta((1:length(curr_area_coord_x)),i) <= 0);
    half_2_theta = theta(half_2_idx, i); sortorder = 'ascend'; half_idx = half_2_idx; half_theta = half_2_theta;
    [half_area_vec_x_2, half_area_vec_y_2] = finding_half_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x, curr_area_coord_y, half_idx, half_theta, half_limits, 'with_cortex'); % calling the function that defines and gets the half area
    area_quadrant_bb_details{i,7}(:,1) = half_area_vec_x_2; area_quadrant_bb_details{i,7}(:,2) = half_area_vec_y_2; % filling the coordinates (that includes cortex) of second half and are centroid adjusted (i.e. centroid is (0,0))
    half_Indx{i,1} = half_2_idx;

    % angles defining second top-bottom half and related details for the periphery coordinates without the cortex
    half_2_idx_wtout_cortex = (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) >= -pi) & (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) <= 0);
    half_2_theta_wtout_cortex = theta_wtout_cortex(half_2_idx_wtout_cortex, i); sortorder = 'ascend'; half_idx_wtout_cortex = half_2_idx_wtout_cortex; half_theta_wtout_cortex = half_2_theta_wtout_cortex;
    [half_area_vec_x_wtout_cortex_2, half_area_vec_y_wtout_cortex_2] = finding_half_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x_wtout_cortex, curr_area_coord_y_wtout_cortex, half_idx_wtout_cortex, half_theta_wtout_cortex, half_limits, 'without_cortex'); % calling the function that defines and gets the half area
    area_quad_wtout_cortex{i,5}(:,1) = half_area_vec_x_wtout_cortex_2; area_quad_wtout_cortex{i,5}(:,2) = half_area_vec_y_wtout_cortex_2; % filling the coordinates (without cortex) of second half that retain the original centroid
    clear half_limits half_idx half_theta half_idx_wtout_cortex half_theta_wtout_cortex

    clear half_1_idx half_2_idx half_1_theta half_2_theta half_area_vec_x_1 half_area_vec_y_1 half_area_vec_x_2 half_area_vec_y_2 ...
        half_1_idx_wtout_cortex half_2_idx_wtout_cortex half_1_theta_wtout_cortex half_2_theta_wtout_cortex half_area_vec_x_wtout_cortex_1 half_area_vec_y_wtout_cortex_1 half_area_vec_x_wtout_cortex_2 half_area_vec_y_wtout_cortex_2

    %---------------------------------------- Left Right half plots ---------------------------------------------%

    % ------------- Defining half_1 (-pi/2 -to- pi/2) (Right half) ------------- %
    half_limits = [-pi/2, pi/2];

    % angles defining first left-right half and related details for the periphery coordinates that includes cortex
    half_1_idx = (theta((1:length(curr_area_coord_x)),i) >= -pi/2) & (theta((1:length(curr_area_coord_x)),i) <= pi/2);
    half_1_theta = theta(half_1_idx, i); sortorder = 'ascend'; half_idx = half_1_idx; half_theta = half_1_theta;
    [half_area_vec_x_1, half_area_vec_y_1] = finding_half_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x, curr_area_coord_y, half_idx, half_theta, half_limits, 'with_cortex'); % calling the function that defines and gets the half area
    area_quadrant_bb_details{i,10}(:,1) = half_area_vec_x_1; area_quadrant_bb_details{i,10}(:,2) = half_area_vec_y_1; % filling the coordinates (that includes cortex) of first half and are centroid adjusted (i.e. centroid is (0,0))
    half_Indx{i,4} = half_1_idx;

    % angles defining first left-right half and related details for the periphery coordinates without the cortex
    half_1_idx_wtout_cortex = (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) >= -pi/2) & (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) <= pi/2);
    half_1_theta_wtout_cortex = theta_wtout_cortex(half_1_idx_wtout_cortex, i); sortorder = 'ascend'; half_idx_wtout_cortex = half_1_idx_wtout_cortex; half_theta_wtout_cortex = half_1_theta_wtout_cortex;
    [half_area_vec_x_wtout_cortex_1, half_area_vec_y_wtout_cortex_1] = finding_half_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x_wtout_cortex, curr_area_coord_y_wtout_cortex, half_idx_wtout_cortex, half_theta_wtout_cortex, half_limits, 'without_cortex'); % calling the function that defines and gets the half area
    area_quad_wtout_cortex{i,8}(:,1) = half_area_vec_x_wtout_cortex_1; area_quad_wtout_cortex{i,8}(:,2) = half_area_vec_y_wtout_cortex_1; % filling the coordinates (without cortex) of first half that retain the original centroid
    clear half_limits half_idx half_theta half_idx_wtout_cortex half_theta_wtout_cortex

    % ------ Defining quarter_1 of half_2 (pi/2 -to- pi) (1st quarter of Left half) ------ %
    half_limits = [pi/2, pi];

    % angles defining the first quarter of second left-right half and related details for the periphery coordinates that includes cortex
    half_2_idx = (theta((1:length(curr_area_coord_x)),i) >= pi/2) & (theta((1:length(curr_area_coord_x)),i) <= pi);
    half_2_theta = theta(half_2_idx, i); sortorder = 'ascend'; half_idx = half_2_idx; half_theta = half_2_theta;
    [half_area_vec_x_2, half_area_vec_y_2] = finding_half_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x, curr_area_coord_y, half_idx, half_theta, half_limits, 'with_cortex'); % calling the function that defines and gets the half area

    % angles defining the first quarter of second left-right half and related details for the periphery coordinates without the cortex
    half_2_idx_wtout_cortex = (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) >= pi/2) & (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) <= pi);
    half_2_theta_wtout_cortex = theta_wtout_cortex(half_2_idx_wtout_cortex, i); sortorder = 'ascend'; half_idx_wtout_cortex = half_2_idx_wtout_cortex; half_theta_wtout_cortex = half_2_theta_wtout_cortex;
    [half_area_vec_x_wtout_cortex_2, half_area_vec_y_wtout_cortex_2] = finding_half_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x_wtout_cortex, curr_area_coord_y_wtout_cortex, half_idx_wtout_cortex, half_theta_wtout_cortex, half_limits, 'without_cortex'); % calling the function that defines and gets the half area
    clear half_limits half_idx half_theta half_idx_wtout_cortex half_theta_wtout_cortex

    % ------ Defining quarter_2 of half_2 (-pi -to- -pi/2) (2nd quarter of Left half) ------ %
    half_limits = [-pi, -pi/2];

    % angles defining the second quarter of second left-right half and related details for the periphery coordinates that includes cortex
    half_3_idx = (theta((1:length(curr_area_coord_x)),i) >= -pi) & (theta((1:length(curr_area_coord_x)),i) <= -pi/2);
    half_3_theta = theta(half_3_idx, i); sortorder = 'ascend'; half_idx = half_3_idx; half_theta = half_3_theta;
    [half_area_vec_x_3, half_area_vec_y_3] = finding_half_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x, curr_area_coord_y, half_idx, half_theta, half_limits, 'with_cortex'); % calling the function that defines and gets the half area

    % angles defining the second quarter of second left-right half and related details for the periphery coordinates without the cortex
    half_3_idx_wtout_cortex = (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) >= -pi) & (theta_wtout_cortex((1:length(curr_area_coord_x_wtout_cortex)),i) <= -pi/2);
    half_3_theta_wtout_cortex = theta_wtout_cortex(half_3_idx_wtout_cortex, i); sortorder = 'ascend'; half_idx_wtout_cortex = half_3_idx_wtout_cortex; half_theta_wtout_cortex = half_3_theta_wtout_cortex;
    [half_area_vec_x_wtout_cortex_3, half_area_vec_y_wtout_cortex_3] = finding_half_area(sortorder, curr_centroid_x, curr_centroid_y, curr_area_coord_x_wtout_cortex, curr_area_coord_y_wtout_cortex, half_idx_wtout_cortex, half_theta_wtout_cortex, half_limits, 'without_cortex'); % calling the function that defines and gets the half area
    clear half_limits half_idx half_theta half_idx_wtout_cortex half_theta_wtout_cortex

    % constructing the vector 'half_Indx' for the left half from the vectors 'half_2_idx' & 'half_3_idx' of the two quarters of the left half
    temp_idx_1 = find(half_2_idx==1); temp_idx_2 = find(half_3_idx==1); temp_idx = [temp_idx_1;temp_idx_2]; temp_zeros = zeros(length(half_2_idx),1); temp_zeros(temp_idx) = 1; half_idx_2_3_combined = logical(temp_zeros);
    half_Indx{i,3} = half_idx_2_3_combined;

    % constructing area periphery coordinate (that includes cortex) (centroid adjusted i.e. (0,0)) of the left half from the two quarters of the left half
    area_quadrant_bb_details{i,9}(:,1) = [half_area_vec_x_2; half_area_vec_x_3; half_area_vec_x_2(1,1)];
    area_quadrant_bb_details{i,9}(:,2) = [half_area_vec_y_2; half_area_vec_y_3; half_area_vec_y_2(1,1)];
    % constructing the area periphery coordinate (without the cortex) (with the original centroid) of the left half from the two quarters of the left half
    area_quad_wtout_cortex{i,7}(:,1) = [half_area_vec_x_wtout_cortex_2; half_area_vec_x_wtout_cortex_3; half_area_vec_x_wtout_cortex_2(1,1)];
    area_quad_wtout_cortex{i,7}(:,2) = [half_area_vec_y_wtout_cortex_2; half_area_vec_y_wtout_cortex_3; half_area_vec_y_wtout_cortex_2(1,1)];

    clear half_1_idx half_2_idx half_3_idx half_1_theta half_2_theta half_3_theta half_area_vec_x_1 half_area_vec_y_1 half_area_vec_x_2 half_area_vec_y_2 half_area_vec_x_3 half_area_vec_y_3...
        half_1_idx_wtout_cortex half_2_idx_wtout_cortex half_3_idx_wtout_cortex half_1_theta_wtout_cortex half_2_theta_wtout_cortex half_3_theta_wtout_cortex half_area_vec_x_wtout_cortex_1 half_area_vec_y_wtout_cortex_1 half_area_vec_x_wtout_cortex_2 half_area_vec_y_wtout_cortex_2 half_area_vec_x_wtout_cortex_3 half_area_vec_y_wtout_cortex_3

    %--------------------------------------------------------------------------------------------------------%
    xcord = xcord + 2;
    ycord = ycord + 2;
    clear curr_bb_coord_x curr_bb_coord_y curr_centroid_x curr_centroid_y curr_area_coord_x curr_area_coord_y curr_area_coord_x_wtout_cortex curr_area_coord_y_wtout_cortex curr_Newbb_coord_x curr_Newbb_coord_y
end
% saving the 'area_quad_wtout_cortex' cell array for use with ImageJ for obtaining the actin intensities only in the area within the cortex
area_quad_temp = {}; % Initializing a list to save the transformed vectors
% The loop below extracts and concatenates the vectors in the desired order
for row = 1:size(area_quad_wtout_cortex, 1)
    for col = 1:size(area_quad_wtout_cortex, 2)
        % Append the vectors from the current cell to the list
        area_quad_temp{1,end+1} = area_quad_wtout_cortex{row, col}(:,1);  % 1st vector of the current cell
        area_quad_temp{1,end+1} = area_quad_wtout_cortex{row, col}(:,2);  % 2nd vector of the current cell
    end
end
max_len = max(cellfun(@length, area_quad_temp)); % fetching the maximum length of the vectors in the temporary cell array 'area_quad_temp'
area_quad_wtout_cortex_mat_00 = cell2mat(cellfun(@(x) [x; nan(max_len - length(x), 1)], area_quad_temp, 'UniformOutput', false)); % Pad vectors with NaNs and concatenate them into the final matrix and then convert them to standard matrix format
area_quad_wtout_cortex_mat_0 = round(area_quad_wtout_cortex_mat_00 / pixelwidth); % converting the pixel coordinates in micrometers to pixel numbers so that they can be used for plotting in imageJ
area_quad_wtout_cortex_mat = num2cell(area_quad_wtout_cortex_mat_0); % converting the standard matrix to a cell array where the individual elements of the standard matrix become individual 'cells' so that the NaNs can be replaced by empty spaces
area_quad_wtout_cortex_mat(cellfun(@isnan,area_quad_wtout_cortex_mat)) = {''}; % converting all the NaNs in the individual cells to empty spaces
% savng the matrix 'area_quad_wtout_cortex_mat' as a '.csv' file
% In the resulting table, the data will be organised as follows:
% (1) each row corresponds to one periphery coordinate
% (2) the first 8 column correspond to the first time point; the next 8 columns correspond to the next time point and so on...
% (3) the 8 columns are: first 4 columns correspond to the periphery coordinates of 4 quadrants; the next 4 columns correspond to the periphery coordinates of the two halves of top-bottom & two halves of the left-right sides respectively.
table_area_quad_half_coordinates = cell2table(area_quad_wtout_cortex_mat); % converting 'area_quad_wtout_cortex_mat' into table format
loctn = fullfile('../data', 'quad_half_coordinates_orig_centroid.csv');
writetable(table_area_quad_half_coordinates, loctn, 'Delimiter', 'comma');
clear area_quad_temp
% changing all those rows in which there are no new BBs, to NaNs. This is to avoid issues arising from zeros that get recorded for the new BB count for those frames where there are no new BBs.
quadrant_new_BBs(isnan(quadrant_new_BBs(:,1)),:) = NaN;

%% Fetching & assigning Actin intensities of the quadrants & halves
% User prompt
disp('Run the macro "quadrants_halves_actin_intensity.ijm". Then press a key !')
pause;
% fetching the actin intensity measurements of the quadrants & halves
ActinInt_quad_halves = readtable('../data/quad_half_actin_intensity.csv');
ActinInt_quad_halves_ary = table2array(ActinInt_quad_halves);
% assigning actin intensities of the quadrants & halves
quad_halves_meanint = ActinInt_quad_halves_ary(:,1:2:end);
quad_halves_totalint = ActinInt_quad_halves_ary(:,2:2:end);
quad_halves_meanint_norm(:, 1:2) = quadrant_area(:, 1:2);
quad_halves_meanint_norm(:, 3:10) = quad_halves_meanint ./ (cell2mat(cortex_meanint))';
quad_halves_totalint_norm(:, 1:2) = quadrant_area(:, 1:2);
quad_halves_totalint_norm(:, 3:10) = quad_halves_totalint ./ (cell2mat(cortex_totalint))';

%% Plotting color coded intensities of actin for all the quadrants, top-bottom halves & left-right halves
% -------- Mean intensity -------- %
plot_parameter = quad_halves_meanint_norm; plot_save_name = 'quad_actin_meanint_'; ylabl = 'Mean actin intensity';
% Quadrant plots
plot_title = 'Mean actin intensity in the quadrants'; col_no = [3,4,5,6]; % column numbers corresponding to the four quadrants in the matrix 'quad_halves_meanint_norm'
% plot_parameter = plot_parameter / max(max(plot_parameter(:,col_no(1):col_no(4))));
actinInt_bbdensity_quad_half_imgs('quad', area_quadrant_bb_details, plot_parameter, col_no, ylabl, plot_title, tmepoints, Image_dime, pixelwidth, plot_save_name, savelink_actinMeanint_quad);
%%
% Top-Bottom half BB mean intensity
plot_title = 'Mean actin intensity in Top-Bottom halves'; col_no = [7,8]; % column numbers corresponding to the top & bottom halves in the matrices 'area_quadrant_bb_details' & 'quad_halves_meanint_norm'
actinInt_bbdensity_quad_half_imgs('top-bottom', area_quadrant_bb_details, plot_parameter, col_no, ylabl, plot_title, tmepoints, Image_dime, pixelwidth, plot_save_name, savelink_actinMeanint_topbottom_half);
% Left-Right half BB mean intensity
plot_title = 'Mean actin intensity in Left-Right halves'; col_no = [9,10]; % column numbers corresponding to the left & right halves in the matrices 'area_quadrant_bb_details' & 'quad_halves_meanint_norm'
actinInt_bbdensity_quad_half_imgs('left-right', area_quadrant_bb_details, plot_parameter, col_no, ylabl, plot_title, tmepoints, Image_dime, pixelwidth, plot_save_name, savelink_actinMeanint_leftright_half);
clear plot_parameter
% -------- Total intensity -------- %
plot_parameter = quad_halves_totalint_norm; plot_save_name = 'quad_actin_totalint_'; ylabl = 'Total actin intensity';
% Quadrant plots
plot_title = 'Total actin intensity in the quadrants'; col_no = [3,4,5,6]; % column numbers corresponding to the four quadrants in the matrix 'quad_halves_meanint_norm'
actinInt_bbdensity_quad_half_imgs('quad', area_quadrant_bb_details, plot_parameter, col_no, ylabl, plot_title, tmepoints, Image_dime, pixelwidth, plot_save_name, savelink_actinTotalint_quad);
% Top-Bottom half BB total intensity
plot_title = 'Total actin intensity in Top-Bottom halves'; col_no = [7,8]; % column numbers corresponding to the top & bottom halves in the matrices 'area_quadrant_bb_details' & 'quad_halves_totalint_norm'
actinInt_bbdensity_quad_half_imgs('top-bottom', area_quadrant_bb_details, plot_parameter, col_no, ylabl, plot_title, tmepoints, Image_dime, pixelwidth, plot_save_name, savelink_actinTotalint_topbottom_half);
% Left-Right half BB total intensity
plot_title = 'Total actin intensity in Left-Right halves'; col_no = [9,10]; % column numbers corresponding to the left & right halves in the matrices 'area_quadrant_bb_details' & 'quad_halves_totalint_norm'
actinInt_bbdensity_quad_half_imgs('left-right', area_quadrant_bb_details, plot_parameter, col_no, ylabl, plot_title, tmepoints, Image_dime, pixelwidth, plot_save_name, savelink_actinTotalint_leftright_half);
clear plot_parameter

%% Plotting areas and BBs for all the four Quadrants, Top-Bottom & Left-Right halves
plot_save_name = 'quad_area_BB_';
% Quadrant plots
quad_plot_imgs(tmepoints, Image_dime, pixelwidth, area_quadrant_bb_details, quad_pogn, quad_Indx, plot_save_name, savelink_area_bb_quad);
%%
% Top-Bottom plots
half_type = 'top_bottom'; col_no_1 = [7,8]; col_no_2 = [1,2]; clrs = ['k' 'm'];
half_plots(half_type, col_no_1, col_no_2, tmepoints, Image_dime, pixelwidth, area_quadrant_bb_details, half_Indx, clrs, plot_save_name, savelink_topbottom_half)
% Left-Right plots
half_type = 'left_right'; col_no_1 = [9,10]; col_no_2 = [3,4]; clrs = ['b' 'r'];
half_plots(half_type, col_no_1, col_no_2, tmepoints, Image_dime, pixelwidth, area_quadrant_bb_details, half_Indx, clrs, plot_save_name, savelink_leftright_half)

%% Getting the area, area rate, BB count & BB density values of quadrants, Top-Bottom & Left-Right halves

% getting the area of top/bottom and left/right quadrants
top_quadrant_area = quadrant_area(:,5) + quadrant_area(:,6); bottom_quadrant_area = quadrant_area(:,3) + quadrant_area(:,4);
quadrant_area(:, 7:8) = [top_quadrant_area, bottom_quadrant_area];
left_quadrant_area = quadrant_area(:,4) + quadrant_area(:,5); right_quadrant_area = quadrant_area(:,3) + quadrant_area(:,6);
quadrant_area(:, 9:10) = [left_quadrant_area, right_quadrant_area];

% getting rate of increase for all quadrants and top/bottom & left/right quadrant areas
columnlength = length(quadrant_area(:,1)) - (area_rate_frame_interval-1);
quad_area_rate(1:columnlength, 1:2) = quadrant_area(area_rate_frame_interval:1:end, 1:2);
quad_area_rate(1:columnlength, 3:6) = abs([(quadrant_area(area_rate_frame_interval:1:end, 3) - quadrant_area(1:1:end-(area_rate_frame_interval-1), 3)) / area_rate_time_interval, ...
    (quadrant_area(area_rate_frame_interval:1:end, 4) - quadrant_area(1:1:end-(area_rate_frame_interval-1), 4)) / area_rate_time_interval, ...
    (quadrant_area(area_rate_frame_interval:1:end, 5) - quadrant_area(1:1:end-(area_rate_frame_interval-1), 5)) / area_rate_time_interval, ...
    (quadrant_area(area_rate_frame_interval:1:end, 6) - quadrant_area(1:1:end-(area_rate_frame_interval-1), 6)) / area_rate_time_interval]);
% Below, first we define the top and bottom quadrants; Then in the following line, the first term on the RHS that fills column 7 corresponds to the rate of increase of the areas of 3rd & 4th quadrants combined
% (top quadrants in the plot / images); the second term on the RHS that fills column 8 corresponds to the rate of increase of the areas of 1st & 2nd quadrants combined (bottom quadrants in the plot / images);
quad_area_rate(1:columnlength, 7:8) = abs([(top_quadrant_area(area_rate_frame_interval:1:end, 1) - top_quadrant_area(1:1:end-(area_rate_frame_interval-1), 1)) / area_rate_time_interval,...
    (bottom_quadrant_area(area_rate_frame_interval:1:end, 1) - bottom_quadrant_area(1:1:end-(area_rate_frame_interval-1), 1)) / area_rate_time_interval]);
% Below, first we define the left and right quadrants; Then in the following line, the first term on the RHS that fills column 9 corresponds to the rate of increase of the areas of 2nd & 3rd quadrants (left
% quadrants in the plot / images); the second term on the RHS that fills column 10 corresponds to the rate of increase of the areas of 1st & 4th quadrants (right quadrants in the plot / images);
quad_area_rate(1:columnlength, 9:10) = abs([(left_quadrant_area(area_rate_frame_interval:1:end, 1) - left_quadrant_area(1:1:end-(area_rate_frame_interval-1), 1)) / area_rate_time_interval,...
    (right_quadrant_area(area_rate_frame_interval:1:end, 1) - right_quadrant_area(1:1:end-(area_rate_frame_interval-1), 1)) / area_rate_time_interval]);

% getting the BB counts of top/bottom and left/right quadrants
top_quadrant_bb_count = quadrant_BBs(:,5) + quadrant_BBs(:,6); bottom_quadrant_bb_count = quadrant_BBs(:,3) + quadrant_BBs(:,4);
quadrant_BBs(:, 7:8) = [top_quadrant_bb_count, bottom_quadrant_bb_count];
left_quadrant_bb_count = quadrant_BBs(:,4) + quadrant_BBs(:,5); right_quadrant_bb_count = quadrant_BBs(:,3) + quadrant_BBs(:,6);
quadrant_BBs(:, 9:10) = [left_quadrant_bb_count, right_quadrant_bb_count];

% getting BB density & normalised BB density for plotting 
% For the BB density below, we perform a normalisation (No.ofBB/(area-initialarea)) that allows for proper plotting of BB density (for normalised BB density, check the 'bb_density_norm' matrix in 'bb_mean_inter_distance.m').
% In the matrix, 'quadrant_bb_density', (col 1 & 2) correspond to time (in min) and apical area (in um2); (col 3, 4, 5 & 6) correspond to four quadrants respectively; (col 7, 8, 9 & 10) correspond to the two halves of top-bottom sides and left-right sides respectively.
quadrant_bb_density(:, 1:2) = quadrant_area(:, 1:2); 
quadrant_bb_density_for_plot = quadrant_area(:, 1:2); 
quadrant_bb_density(:, 3:6) = quadrant_BBs(:, 3:6) ./ quadrant_area(:, 3:6);
quadrant_bb_density_for_plot(:, 3:6) = quadrant_BBs(:, 3:6) ./ abs(quadrant_area(:, 3:6) - quadrant_area(1, 3:6));
% Below the first term on the RHS that fills column 7 is the BB density in the 3rd & 4th quadrants combined (top quadrants in the plot / images); the second term on the RHS that fills column 8 is the BB density in the
% 1st & 2nd quadrants combined (bottom quadrants in the plot / images)
quadrant_bb_density(:, 7:8) = [top_quadrant_bb_count ./ top_quadrant_area, bottom_quadrant_bb_count ./ bottom_quadrant_area];
quadrant_bb_density_for_plot(:, 7:8) = [top_quadrant_bb_count ./ abs(top_quadrant_area - top_quadrant_area(1,1)), bottom_quadrant_bb_count ./ abs(bottom_quadrant_area - bottom_quadrant_area(1,1))];
% Below the first term on the RHS that fills column 9 is the BB density in the 2nd & 3rd quadrants combined (left quadrants in the plot / images); the second term on the RHS that fills column 10 is the BB density in the
% 1st & 4th quadrants combined (right quadrants in the plot / images)
quadrant_bb_density(:, 9:10) = [left_quadrant_bb_count ./ left_quadrant_area, right_quadrant_bb_count ./ right_quadrant_area];
quadrant_bb_density_for_plot(:, 9:10) = [left_quadrant_bb_count ./ abs(left_quadrant_area - left_quadrant_area(1,1)), right_quadrant_bb_count ./ abs(right_quadrant_area - right_quadrant_area(1,1))];
quadrant_bb_density_for_plot(quadrant_bb_density_for_plot==Inf) = NaN; % There is a possibility of dividing by zero while obtaining "_for_plot" matrices, because while dividing by the difference in area, the first element will be zero. So we are chaning all 'Inf' to 'NaN'.

% getting the newly appearing BB counts of top/bottom and left/right quadrants
top_quadrant_Newbb_count = quadrant_new_BBs(:,5) + quadrant_new_BBs(:,6); bottom_quadrant_Newbb_count = quadrant_new_BBs(:,3) + quadrant_new_BBs(:,4);
quadrant_new_BBs(:, 7:8) = [top_quadrant_Newbb_count, bottom_quadrant_Newbb_count];
left_quadrant_Newbb_count = quadrant_new_BBs(:,4) + quadrant_new_BBs(:,5); right_quadrant_Newbb_count = quadrant_new_BBs(:,3) + quadrant_new_BBs(:,6);
quadrant_new_BBs(:, 9:10) = [left_quadrant_Newbb_count, right_quadrant_Newbb_count];

%% Plotting the color coded BB density for all the quadrants, top-bottom halves & left-right halves
plot_parameter = quadrant_bb_density; plot_save_name = 'quad_BB_density_'; ylabl = 'BB density [\mum^{-2}]';
% quadrant BB density
plot_title = 'BB density in the quadrants'; col_no = [3,4,5,6]; % column numbers corresponding to the four quadrants in the matrix 'quadrant_bb_density'
% plot_parameter = plot_parameter / max(max(plot_parameter(:,col_no(1):col_no(4))));
actinInt_bbdensity_quad_half_imgs('quad', area_quadrant_bb_details, plot_parameter, col_no, ylabl, plot_title, tmepoints, Image_dime, pixelwidth, plot_save_name, savelink_bb_density_quad);
%%
% Top-Bottom half BB density
plot_title = 'BB density in Top-Bottom halves'; col_no = [7,8]; % column numbers corresponding to the top & bottom halves in the matrices 'area_quadrant_bb_details' & 'quadrant_bb_density'
actinInt_bbdensity_quad_half_imgs('top-bottom', area_quadrant_bb_details, plot_parameter, col_no, ylabl, plot_title, tmepoints, Image_dime, pixelwidth, plot_save_name, savelink_bb_density_topbottom_half);
% Left-Right half BB density
plot_title = 'BB density in Left-Right halves'; col_no = [9,10]; % column numbers corresponding to the left & right halves in the matrices 'area_quadrant_bb_details' & 'quadrant_bb_density'
actinInt_bbdensity_quad_half_imgs('left-right', area_quadrant_bb_details, plot_parameter, col_no, ylabl, plot_title, tmepoints, Image_dime, pixelwidth, plot_save_name, savelink_bb_density_leftright_half);
clear plot_parameter

%% Reordering matrices: from smaller BB density to largest BB density (of quadrant & halves)
% Reordering matrices (of all parameters) so that when the quadrants are plotted, quadrant 1 always refers to the quadrant with the lower BB density and quadrant 4 always refers to the quadrant with the highest BB density.
% Similarly, the halves (i.e. columns 7-10) are reordered in a way that half 1 always refers to the smaller BB density and half 4 always refers to the highest BB density (we consider 4 halfs because we take into account both top/bottom & left/right half)
[~, time_threshold_idx] = min(abs(quadrant_area(:,1) - 150), [], 1); % here we get the row index of the 'quadrant_area(:,1)' matrix that corresponds to '150' minutes (i.e. 2.5 h). This is because, we are interested only in the time range of 2.5 h (to have similar experimental time lines for control & MO). So th idea is to use this index and search within range in the 'quadrant_area(:,2)' matrix for max(area) and use that area as the maximum area
[~, max_area_idx] = max(quadrant_area(1:time_threshold_idx, 2)); % getting the index of maximum area in the 'quadrant_area' matrix
concerned_cols(1:4,1) = [3;4;5;6]; concerned_cols(1:4,2) = [7;8;9;10]; sorted_col_order = [];
% Reordering the quadrants (columns 3 -to- 6) of different parameters based on quadrant BB density i.e. 'quadrant_bb_density' matrix at the index where the area is maximum in the 'quadrant_area' matrix
quadrant_bb_density_reordered = quadrant_bb_density; quadrant_bb_density_for_plot_reordered = quadrant_bb_density_for_plot; quadrant_area_reordered = quadrant_area; quadrant_BBs_reordered = quadrant_BBs; quad_area_rate_reordered = quad_area_rate; quadrant_new_BBs_reordered = quadrant_new_BBs; quad_halves_meanint_norm_reordered = quad_halves_meanint_norm; quad_halves_totalint_norm_reordered = quad_halves_totalint_norm;
for r = 1:2
    [quadrant_bb_density_reordered, sorted_quadrants_based_on_quadrant_bb_density] = reordering_matrices(max_area_idx, quadrant_bb_density_reordered, concerned_cols(:,r), sorted_col_order); % function that sorts the quadrants (i.e. the quadrant columns) in the 'quadrant_bb_density' matrix in an ascending manner i.e 1st quadrant column is the one with smallest BB density and the last quadrant column is the one with largest BB density
    sorted_col_order = abs(sorted_quadrants_based_on_quadrant_bb_density(:,1));
    [quadrant_bb_density_for_plot_reordered, ~] = reordering_matrices(max_area_idx, quadrant_bb_density_for_plot_reordered, concerned_cols(:,r), sorted_col_order); % Reordering the BB density (normalised for plotting) in quadrants (columns 3 -to- 6) in the 'quadrant_bb_density_for_plot_reordered' matrix based on increasing order of quadrant BB density (without normalization)
    [quadrant_area_reordered, ~] = reordering_matrices(max_area_idx, quadrant_area_reordered, concerned_cols(:,r), sorted_col_order); % Reordering the area in quadrants (columns 3 -to- 6) in the 'quadrant_area' matrix based on increasing order of quadrant BB density
    [quadrant_BBs_reordered, ~] = reordering_matrices(max_area_idx, quadrant_BBs_reordered, concerned_cols(:,r), sorted_col_order); % Reordering the BB counts in quadrants (columns 3 -to- 6) in the 'quadrant_BBs' matrix based on increasing order of quadrant BB density
    [quad_area_rate_reordered, ~] = reordering_matrices(max_area_idx, quad_area_rate_reordered, concerned_cols(:,r), sorted_col_order); % Reordering the individual quadrant expansion rates (columns 3 -to- 6) in the 'quad_area_rate' matrix based on increasing order of quadrant BB density
    [quadrant_new_BBs_reordered, ~] = reordering_matrices(max_area_idx, quadrant_new_BBs_reordered, concerned_cols(:,r), sorted_col_order); % Reordering the newly appearing BB counts in quadrants (columns 3 -to- 6) in the 'quadrant_new_BBs_reordered' matrix based on increasing order of quadrant BB density
    [quad_halves_meanint_norm_reordered, ~] = reordering_matrices(max_area_idx, quad_halves_meanint_norm_reordered, concerned_cols(:,r), sorted_col_order); % Reordering the individual quadrant mean actin intensities (columns 3 -to- 6) in the 'quad_halves_meanint_norm_reordered' matrix based on increasing order of quadrant BB density
    [quad_halves_totalint_norm_reordered, ~] = reordering_matrices(max_area_idx, quad_halves_totalint_norm_reordered, concerned_cols(:,r), sorted_col_order); % Reordering the individual quadrant total actin intensities (columns 3 -to- 6) in the 'quad_halves_totalint_norm_reordered' matrix based on increasing order of quadrant BB density
    sort_order(:,r) = sorted_col_order;
    sorted_col_order = [];
end
% Below we get the order in which the quadrants & halves are arranged
ref_order = {3,4,5,6,7,8,9,10; 'q1','q2','q3','q4','T','B','L','R'}'; % this is the order in which the columns of quadrants and halves are arranged; here q1-quadrant1; q2-quadrant2; q3-quadrant3; q4-quadrant4; T-Top half; B-Bottom half; L-Left half; R-Right half;
[~, idx_sort_order] = ismember(sort_order(:), [ref_order{:,1}]); % here we compare with the newly sorted order - based on what was obtained from the above for loop - based on BB density at max area time point
final_sort_order(:,1) = ref_order(idx_sort_order,1); % here we store the final sort order which will be used in the legends of the plots
final_sort_order(:,2) = ref_order(idx_sort_order,2);

%% Fetching area, BB count, area rate, BB density, mean & total actin intensities at the largest apical domain area time point
% Quadrants: 
quadrant_areas_at_max_apical_area(1,:) = quadrant_area_reordered(max_area_idx, 3:6); % 1st quadrant is the quadrant with the lowest BB density & 4th quadrant is the quadrant with the largest BB density
quadrant_areas_at_max_apical_area_norm(1,:) = quadrant_area_reordered(max_area_idx, 3:6) / Area_apicaldomain(max_area_idx); % Normalised area at max area
quadrant_BB_count_at_max_apical_area(1,:) = quadrant_BBs_reordered(max_area_idx, 3:6); % 1st quadrant is the quadrant with the lowest BB density & 4th quadrant is the quadrant with the largest BB density
quadrant_BB_count_at_max_apical_area_norm(1,:) = quadrant_BBs_reordered(max_area_idx, 3:6) / No_of_BB(max_area_idx); % Normalised BB count at max area
whole_quadrant_area_rates_at_max_apical_area(1,:) = (quadrant_area_reordered(max_area_idx, 3:6) - quadrant_area_reordered(1, 3:6)) / quadrant_area_reordered(max_area_idx, 1); % Fetching whole expansion rate of all quadrants; 1st quadrant is the quadrant with the lowest BB density & 4th quadrant is the quadrant with the largest BB density
whole_quadrant_area_rates_at_max_apical_area_norm(1,:) = ((quadrant_area_reordered(max_area_idx, 3:6) - quadrant_area_reordered(1, 3:6)) / quadrant_area_reordered(max_area_idx, 1)) / whole_area_rate; % Normalised area rate at max area
load('workspace_bb_mean_inter_distance_density.mat', 'bb_density', 'bb_density_norm');
quad_BB_density_at_max_apical_area(1,:) = quadrant_bb_density_reordered(max_area_idx, 3:6); % 1st quadrant is the quadrant with the lowest BB density & 4th quadrant is the quadrant with the largest BB density
quad_BB_density_at_max_apical_area_norm(1,:) = quadrant_bb_density_reordered(max_area_idx, 3:6) / bb_density(max_area_idx,1); % Normalised bb density at max area
quad_actinMeanIntnorm_at_max_apical_area(1,:) = quad_halves_meanint_norm_reordered(max_area_idx, 3:6); % Mean actin intensity at max area
quad_actinTotalIntnorm_at_max_apical_area(1,:) = quad_halves_totalint_norm_reordered(max_area_idx, 3:6); % Total actin intensity at max area
quadrant_total_NewBB_count(1,:) = sum(quadrant_new_BBs_reordered(:, 3:6), 'omitnan'); % Quadrants: Total no. of newly appearing BBs in each quadrant; % 1st quadrant is the quadrant with the lowest BB density & 4th quadrant is the quadrant with the largest BB density
quadrant_total_NewBB_count_norm(1,:) = sum(quadrant_new_BBs_reordered(:, 3:6), 'omitnan') / sum(new_bb_crds_full(:,2), 'omitnan'); % Normalized count of newly appearing BBs
% Halves: 
half_areas_at_max_apical_area(1,:) = quadrant_area_reordered(max_area_idx, 7:10); % The two different types of halves (Left/Right & Top/Bottom) are sorted based on low and high BB density, 1st half is the half with low BB density & 4th half is the half with the highest BB density
half_areas_at_max_apical_area_norm(1,:) = quadrant_area_reordered(max_area_idx, 7:10) / Area_apicaldomain(max_area_idx); % Normalised area at max area
half_BB_count_at_max_apical_area(1,:) = quadrant_BBs_reordered(max_area_idx, 7:10); % The two different types of halves (Left/Right & Top/Bottom) are sorted based on low and high BB density, 1st half is the half with low BB density & 4th half is the half with the highest BB density
half_BB_count_at_max_apical_area_norm(1,:) = quadrant_BBs_reordered(max_area_idx, 7:10) / No_of_BB(max_area_idx); % Normalised BB count at max area
whole_half_area_rates_at_max_apical_area(1,:) = (quadrant_area_reordered(max_area_idx, 7:10) - quadrant_area_reordered(1, 7:10)) / quadrant_area_reordered(max_area_idx, 1); % Fetching whole expansion rate of all halves; The two different types of halves (Left/Right & Top/Bottom) are sorted based on low and high BB density, 1st half is the half with low BB density & 4th half is the half with the highest BB density
whole_half_area_rates_at_max_apical_area_norm(1,:) = ((quadrant_area_reordered(max_area_idx, 7:10) - quadrant_area_reordered(1, 7:10)) / quadrant_area_reordered(max_area_idx, 1)) / whole_area_rate; % Normalised area rate at max area
half_BB_density_at_max_apical_area(1,:) = quadrant_bb_density_reordered(max_area_idx, 7:10); % The two different types of halves (Left/Right & Top/Bottom) are sorted based on low and high BB density, 1st half is the half with low BB density & 4th half is the half with the highest BB density
half_BB_density_at_max_apical_area_norm(1,:) = quadrant_bb_density_reordered(max_area_idx, 7:10) / bb_density(max_area_idx,1); % Normalised bb density at max area
half_actinMeanIntnorm_at_max_apical_area(1,:) = quad_halves_meanint_norm_reordered(max_area_idx, 7:10); % Mean actin intensity at max area
half_actinTotalIntnorm_at_max_apical_area(1,:) = quad_halves_totalint_norm_reordered(max_area_idx, 7:10); % Total actin intensity at max area
half_total_NewBB_count(1,:) = sum(quadrant_new_BBs_reordered(:, 7:10), 'omitnan'); % The two different types of halves (Left/Right & Top/Bottom) are sorted based on low and high BB density, 1st half is the half with low BB density & 4th half is the half with the highest BB density
half_total_NewBB_count_norm(1,:) = sum(quadrant_new_BBs_reordered(:, 7:10), 'omitnan') / sum(new_bb_crds_full(:,2), 'omitnan'); % Normalised BB count at max area

%% clumping factor
% Getting the clumping factor for Quadrant area
clumpingfactor_area(:,1) = mean((quadrant_area(:,3:6).^2), 2) ./ (mean(quadrant_area(:,3:6), 2) .^ 2);
% Fetching the clumping factor (area) for the largest area
clumpingfactor_area_max_apical_area = clumpingfactor_area(max_area_idx, 1);

% Getting the clumping factor for Quadrant Rate of expansion
clumpingfactor_arearate(:,1) = mean((quad_area_rate(:,3:6).^2), 2) ./ (mean(quad_area_rate(:,3:6), 2) .^ 2);
% Fetching the clumping factor (Rate of expansion) for the largest area
clumpingfactor_arearate_max_apical_area = clumpingfactor_arearate(max_area_idx, 1);

% Getting the clumping factor for Quadrant BB count
clumpingfactor_bbcount(:,1) = mean((quadrant_BBs(:,3:6).^2), 2) ./ (mean(quadrant_BBs(:,3:6), 2) .^ 2);
% Fetching the clumping factor (BB count) for the largest area
clumpingfactor_bbcount_max_apical_area = clumpingfactor_bbcount(max_area_idx, 1);

% Getting the clumping factor for Quadrant BB density
clumpingfactor_bbddensity(:,1) = mean((quadrant_bb_density(:,3:6).^2), 2) ./ (mean(quadrant_bb_density(:,3:6), 2) .^ 2);
% Fetching the clumping factor (Area) for the largest area
clumpingfactor_bbddensity_max_apical_area = clumpingfactor_bbddensity(max_area_idx, 1);

% Getting the clumping factor for Quadrant Mean Actin Intensity
clumpingfactor_meanint(:,1) = mean((quad_halves_meanint_norm(:,3:6).^2), 2) ./ (mean(quad_halves_meanint_norm(:,3:6), 2) .^ 2);
% Fetching the clumping factor (Mean Actin Intensity) for the largest area
clumpingfactor_meanint_max_apical_area = clumpingfactor_meanint(max_area_idx, 1);

% Getting the clumping factor for Quadrant Total Actin Intensity
clumpingfactor_totalint(:,1) = mean((quad_halves_totalint_norm(:,3:6).^2), 2) ./ (mean(quad_halves_totalint_norm(:,3:6), 2) .^ 2);
% Fetching the clumping factor (Total Actin Intensity) for the largest area
clumpingfactor_totalint_max_apical_area = clumpingfactor_totalint(max_area_idx, 1);

% Getting the clumping factor for Quadrant Total Actin Intensity
clumpingfactor_newBBcount(:,1) = mean((quadrant_new_BBs(:,3:6).^2), 2) ./ (mean(quadrant_new_BBs(:,3:6), 2) .^ 2);
% Fetching the clumping factor (New BB count) for the largest area
clumpingfactor_newBBcount_max_apical_area = clumpingfactor_newBBcount(max_area_idx, 1);

%% Plotting Quadrant parameters

% Quadrant areas plotted against time and apical domain area
quadrant_area_reordered_norm = quadrant_area_reordered; % reassignment
quadrant_area_reordered_norm(:, 3:10) = quadrant_area_reordered_norm(:, 3:10) ./ quadrant_area_reordered_norm(:, 2); % normalising w.r.to the corresponding total apical area
plot_function(quadrant_area_reordered(:, 1), quadrant_area_reordered(:, 3:6), 'Time [min]', 'Quadrant area [\mum^2]', 'Quadrant area (absolute) vs Time', 'quad_area_absolute_vs_time', savelink_parameter_plots, '4', final_sort_order);
plot_function(quadrant_area_reordered_norm(:, 1), quadrant_area_reordered_norm(:, 3:6), 'Time [min]', 'Quadrant area (normalised)', 'Quadrant area (normalised) vs Time', 'quad_area_normalised_vs_time', savelink_parameter_plots, '4', final_sort_order);
plot_function(quadrant_area_reordered(:, 2), quadrant_area_reordered(:, 3:6), 'Apical domain area [\mum^2]', 'Quadrant area [\mum^2]', {'Quadrant area (absolute) vs', 'apical domain area'}, 'quad_area_absolute_vs_area', savelink_parameter_plots, '4', final_sort_order);
plot_function(quadrant_area_reordered_norm(:, 2), quadrant_area_reordered_norm(:, 3:6), 'Apical domain area [\mum^2]', 'Quadrant area (normalised)', {'Quadrant area (normalised) vs', 'apical domain area'}, 'quad_area_normalised_vs_area', savelink_parameter_plots, '4', final_sort_order);

% Quadrant area rate plotted against time and apical domain area
quad_area_rate_reordered_norm = quad_area_rate_reordered;
quad_area_rate_reordered_norm(:, 3:10) = quad_area_rate_reordered_norm(:, 3:10) ./ area_rate; % normalising w.r.to the corresponding whole apical area rate
plot_function(quad_area_rate_reordered(:, 1), quad_area_rate_reordered(:, 3:6), 'Time [min]', 'Quadrant rate of expansion [\mum^2 min^{-1}]', 'Quadrant expansion rate (absolute) vs Time', 'quad_arearate_absolute_vs_time', savelink_parameter_plots, '4', final_sort_order);
plot_function(quad_area_rate_reordered_norm(:, 1), quad_area_rate_reordered_norm(:, 3:6), 'Time [min]', 'Quadrant rate of expansion (normalised)', {'Quadrant expansion rate', '(normalised) vs Time'}, 'quad_arearate_normalised_vs_time', savelink_parameter_plots, '4', final_sort_order);
plot_function(quad_area_rate_reordered(:, 2), quad_area_rate_reordered(:, 3:6), 'Apical domain area [\mum^2]', 'Quadrant rate of expansion [\mum^2 min^{-1}]', {'Quadrant expansion rate (absolute)', 'vs apical domain area'}, 'quad_arearate_absolute_vs_area', savelink_parameter_plots, '4', final_sort_order);
plot_function(quad_area_rate_reordered_norm(:, 2), quad_area_rate_reordered_norm(:, 3:6), 'Apical domain area [\mum^2]', 'Quadrant rate of expansion (normalised)', {'Quadrant expansion rate (normalised)', 'vs apical domain area'}, 'quad_arearate_normalised_vs_area', savelink_parameter_plots, '4', final_sort_order);
% plot_function(area_rate(:, 1), quad_area_rate_reordered(:, 3:6), 'Rate of expansion of whole apical area [\mum^2 min^{-1}]', 'Quadrant rate of expansion [\mum^2 min^{-1}]', {'Expansion rate (quadrants) vs', 'Expansion rate (Apical area)'}, 'quad_arearate_vs_apicalarea_rate', savelink_parameter_plots, '4', final_sort_order);

% BB count plotted against time, apical domain area and Apical area BB count
quadrant_BBs_reordered_norm = quadrant_BBs_reordered;
quadrant_BBs_reordered_norm(:, 3:10) = quadrant_BBs_reordered_norm(:, 3:10) ./ No_of_BB; % normalising w.r.to the corresponding total no of BBs
plot_function(quadrant_BBs_reordered(:, 1), quadrant_BBs_reordered(:, 3:6), 'Time [min]', 'BB count', 'BB count (absolute) vs Time', 'quad_bbcount_absolute_vs_time', savelink_parameter_plots, '4', final_sort_order);
plot_function(quadrant_BBs_reordered_norm(:, 1), quadrant_BBs_reordered_norm(:, 3:6), 'Time [min]', 'BB count (normalised)', 'BB count (normalised) vs Time', 'quad_bbcount_normalised_vs_time', savelink_parameter_plots, '4', final_sort_order);
plot_function(quadrant_BBs_reordered(:, 2), quadrant_BBs_reordered(:, 3:6), 'Apical domain area [\mum^2]', 'BB count', 'BB count vs Area', 'quad_bbcount_absolute_vs_area', savelink_parameter_plots, '4', final_sort_order);
plot_function(quadrant_BBs_reordered_norm(:, 2), quadrant_BBs_reordered_norm(:, 3:6), 'Apical domain area [\mum^2]', 'BB count (normalised)', 'BB count (normalised) vs Area', 'quad_bbcount_normalised_vs_area', savelink_parameter_plots, '4', final_sort_order);
plot_function(No_of_BB(:, 1), quadrant_BBs_reordered(:, 3:6), 'BB count (Apical area)', 'Quadrant BB count', 'BB count (quadrants) vs BB count (Apical area)', 'quad_bbcount_vs_apicalarea_bbcount', savelink_parameter_plots, '4', final_sort_order);

% BB density (normalised for plotting) plotted against time and apical domain area
quadrant_bb_density_for_plot_reordered_norm = quadrant_bb_density_for_plot_reordered;
quadrant_bb_density_for_plot_reordered_norm(:, 3:10) = quadrant_bb_density_for_plot_reordered_norm(:, 3:10) ./ bb_density_norm;
plot_function(quadrant_bb_density_for_plot_reordered(:, 1), quadrant_bb_density_for_plot_reordered(:, 3:6), 'Time [min]', 'BB density (quadrants) [\mum^{-2}]', {'BB density (normalised for plotting)', '(absolute) vs Time'}, 'quad_bbdensity_absolute_vs_time', savelink_parameter_plots, '4', final_sort_order);
plot_function(quadrant_bb_density_for_plot_reordered_norm(:, 1), quadrant_bb_density_for_plot_reordered_norm(:, 3:6), 'Time [min]', 'BB density (quadrants) (normalised)', {'BB density (normalised for plotting)', '(normalised to whole area BB density) vs Time'}, 'quad_bbdensity_normalised_vs_time', savelink_parameter_plots, '4', final_sort_order);
plot_function(quadrant_bb_density_for_plot_reordered(:, 2), quadrant_bb_density_for_plot_reordered(:, 3:6), 'Apical domain area [\mum^2]', 'BB density (quadrants) [\mum^{-2}]', {'BB density (normalised for plotting)', '(absolute) vs Area'}, 'quad_bbdensity_absolute_vs_area', savelink_parameter_plots, '4', final_sort_order);
plot_function(quadrant_bb_density_for_plot_reordered_norm(:, 2), quadrant_bb_density_for_plot_reordered_norm(:, 3:6), 'Apical domain area [\mum^2]', 'BB density (quadrants) (normalised)', {'BB density (normalised for plotting)', '(normalised to whole area BB density) vs Area'}, 'quad_bbdensity_normalised_vs_area', savelink_parameter_plots, '4', final_sort_order);
plot_function(bb_density_norm, quadrant_bb_density_for_plot_reordered(:, 3:6), 'BB density (apical area) [\mum^{-2}]', 'BB density (quadrants) [\mum^{-2}]', {'BB density (normalised for plotting) (apical area)', 'vs BB density (normalised for plotting) (quadrants)'}, 'quad_bbdensity_vs_apicalarea_bbdensity', savelink_parameter_plots, '4', final_sort_order);

% Mean actin intensity plotted against time and apical domain area
plot_function(quad_halves_meanint_norm_reordered(:, 1), quad_halves_meanint_norm_reordered(:, 3:6), 'Time [min]', 'Mean actin Intensity', 'Quad Mean actin Intensity vs Time', 'quad_mean_actin_intensity_vs_time', savelink_parameter_plots, '4', final_sort_order);
plot_function(quad_halves_meanint_norm_reordered(:, 2), quad_halves_meanint_norm_reordered(:, 3:6), 'Apical domain area [\mum^2]', 'Mean actin Intensity', 'Quad Mean actin Intensity vs Area', 'quad_mean_actin_intensity_vs_area', savelink_parameter_plots, '4', final_sort_order);
plot_function(MeanIntensity_apicaldomain, quad_halves_meanint_norm_reordered(:, 3:6), 'Mean Actin Int. (apical area)', 'Mean Actin Int. (quadrants) [\mum^{-2}]', {'Mean Actin Int. (apical area)', 'vs Mean Actin Int. (quadrants)'}, 'quad_mean_actin_int_vs_apicalarea_mean_actin_int', savelink_parameter_plots, '4', final_sort_order);

% Total actin intensity plotted against time and apical domain area
plot_function(quad_halves_totalint_norm_reordered(:, 1), quad_halves_totalint_norm_reordered(:, 3:6), 'Time [min]', 'Total actin Intensity', 'Quad Total actin Intensity vs Time', 'quad_total_actin_intensity_vs_time', savelink_parameter_plots, '4', final_sort_order);
plot_function(quad_halves_totalint_norm_reordered(:, 2), quad_halves_totalint_norm_reordered(:, 3:6), 'Apical domain area [\mum^2]', 'Total actin Intensity', 'Quad Total actin Intensity vs Area', 'quad_total_actin_intensity_vs_area', savelink_parameter_plots, '4', final_sort_order);
plot_function(TotalIntensity_apicaldomain, quad_halves_totalint_norm_reordered(:, 3:6), 'Total Actin Int. (apical area)', 'Total Actin Int. (quadrants) [\mum^{-2}]', {'Total Actin Int. (apical area)', 'vs Total Actin Int. (quadrants)'}, 'quad_total_actin_int_vs_apicalarea_total_actin_int', savelink_parameter_plots, '4', final_sort_order);

% Quadrant area vs Quadrant BB count
plot_function(quadrant_area_reordered(:, 3:6), quadrant_BBs_reordered(:, 3:6), 'Quadrant area [\mum^2]', 'Quadrant BB count', 'Quadrant BB count vs Quadrant area', 'quad_bbcount_vs_quadrant_area', savelink_parameter_plots, '4', final_sort_order);

% Newly appearing BB count plotted against time, apical domain area and Apical area BB count
quadrant_new_BBs_reordered_norm = quadrant_new_BBs_reordered;
quadrant_new_BBs_reordered_norm(:, 3:10) = quadrant_new_BBs_reordered_norm(:, 3:10) ./ new_bb_crds_full(:,2); % normalising w.r.to the corresponding count of newly appearing BBs
plot_function(quadrant_new_BBs_reordered(:, 1), quadrant_new_BBs_reordered(:, 3:6), 'Time [min]', 'New BB count', 'Quad New BB count (absolute) vs Time', 'quad_Newbbcount_absolute_vs_time', savelink_parameter_plots, '4', final_sort_order);
plot_function(quadrant_new_BBs_reordered_norm(:, 1), quadrant_new_BBs_reordered_norm(:, 3:6), 'Time [min]', 'New BB count (normalised)', 'Quad New BB count (normalised) vs Time', 'quad_Newbbcount_normalised_vs_time', savelink_parameter_plots, '4', final_sort_order);
plot_function(quadrant_new_BBs_reordered(:, 2), quadrant_new_BBs_reordered(:, 3:6), 'Apical domain area [\mum^2]', 'New BB count', 'Quad New BB count (absolute) vs Area', 'quad_Newbbcount_absolute_vs_area', savelink_parameter_plots, '4', final_sort_order);
plot_function(quadrant_new_BBs_reordered_norm(:, 2), quadrant_new_BBs_reordered_norm(:, 3:6), 'Apical domain area [\mum^2]', 'New BB count (normalised)', 'Quad New BB count (normalised) vs Area', 'quad_Newbbcount_normalised_vs_area', savelink_parameter_plots, '4', final_sort_order);
plot_function(new_bb_crds_full(:,2), quadrant_new_BBs_reordered(:, 3:6), 'New BB count (Apical area)', 'Quadrant New BB count', {'Quad New BB count vs', 'Apical area New BB count'}', 'quad_Newbbcount_vs_apicalarea_Newbbcount', savelink_parameter_plots, '4', final_sort_order);

%% Plotting parameters for the halves
% Area & BB density bias in the Top/Bottom direction
% Area of top/bottom sides plotted against apical domain area and time
plot_function(quadrant_area_reordered(:, 1), quadrant_area_reordered(:, 7:10), 'Time [min]', 'Half area [\mum^2]', {'Half area (absolute) vs', 'Time'}, 'half_area_absolute_vs_time', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quadrant_area_reordered_norm(:, 1), quadrant_area_reordered_norm(:, 7:10), 'Time [min]', 'Half area (normalised)', {'Half area (normalised) vs', 'Time'}, 'half_area_normalised_vs_time', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quadrant_area_reordered(:, 2), quadrant_area_reordered(:, 7:10), 'Apical domain area [\mum^2]', 'Half area [\mum^2]', {'Half area (absolute) vs', 'apical domain area'}, 'half_area_absolute_vs_area', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quadrant_area_reordered_norm(:, 2), quadrant_area_reordered_norm(:, 7:10), 'Apical domain area [\mum^2]', 'Half area (normalised)', {'Half area (normalised) vs', 'apical domain area'}, 'half_area_normalised_vs_area', savelink_parameter_plots, 'half', final_sort_order);

% Area rate of top/bottom sides plotted against apical domain area and time
plot_function(quad_area_rate_reordered(:, 1), quad_area_rate_reordered(:, 7:10), 'Time [min]', 'Area rate [\mum^2 min^{-1}]', {'Half area expansion rate', '(absolute) vs Time'}, 'half_arearate_absolute_vs_time', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quad_area_rate_reordered_norm(:, 1), quad_area_rate_reordered_norm(:, 7:10), 'Time [min]', 'Area rate (normalised)', {'Half area expansion rate', '(normalised) vs Time'}, 'half_arearate_normalised_vs_time', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quad_area_rate_reordered(:, 2), quad_area_rate_reordered(:, 7:10), 'Apical domain area [\mum^2]', 'Area rate [\mum^2 min^{-1}]', {'Half area expansion rate', '(absolute) vs apical domain area'}, 'half_arearate_absolute_vs_area', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quad_area_rate_reordered_norm(:, 2), quad_area_rate_reordered_norm(:, 7:10), 'Apical domain area [\mum^2]', 'Area rate (normalised)', {'Half area expansion rate', '(normalised) vs apical domain area'}, 'half_arearate_normalised_vs_area', savelink_parameter_plots, 'half', final_sort_order);
% plot_function(area_rate(:, 1), quad_area_rate_reordered(:, 7:10), 'Apical domain area rate [\mum^2 min^{-1}]', 'Area rate of halves [\mum^2 min^{-1}]', {'Half area expansion rate', 'vs apical domain area expansion rate'}, 'half_arearate_vs_apicalarea_arearate', savelink_parameter_plots, 'half', final_sort_order);

% BB count of top/bottom sides plotted against apical domain area and time
plot_function(quadrant_BBs_reordered(:, 1), quadrant_BBs_reordered(:, 7:10), 'Time [min]', 'BB count', {'Half BB count', '(absolute) vs Time'}, 'half_BBcount_absolute_vs_time', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quadrant_BBs_reordered_norm(:, 1), quadrant_BBs_reordered_norm(:, 7:10), 'Time [min]', 'BB count', {'Half BB count', '(normalised) vs Time'}, 'half_BBcount_normalised_vs_time', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quadrant_BBs_reordered(:, 2), quadrant_BBs_reordered(:, 7:10), 'Apical domain area [\mum^2]', 'BB count', {'Half BB count', '(absolute) vs apical domain area'}, 'half_BBcount_absolute_vs_area', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quadrant_BBs_reordered_norm(:, 2), quadrant_BBs_reordered_norm(:, 7:10), 'Apical domain area [\mum^2]', 'BB count (normalised)', {'Half BB count', '(normalised) vs apical domain area'}, 'half_BBcount_normalised_vs_area', savelink_parameter_plots, 'half', final_sort_order);
plot_function(No_of_BB(:, 1), quadrant_BBs_reordered(:, 7:10), 'BB count (apical domain area)', {'BB count of halves', '(normalised)'}, {'Half BB count', 'vs apical domain area BB count'}, 'half_bbcount_vs_apicalarea_bbcount', savelink_parameter_plots, 'half', final_sort_order);

% BB density of top/bottom sides plotted against apical domain area and time
plot_function(quadrant_bb_density_for_plot_reordered(:, 1), quadrant_bb_density_for_plot_reordered(:, 7:10), 'Time [min]', 'BB density [\mum^{-2}]', {'Half BB density (normalised for plotting)', '(absolute) vs Time'}, 'half_BBdensity_absolute_vs_time', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quadrant_bb_density_for_plot_reordered_norm(:, 1), quadrant_bb_density_for_plot_reordered_norm(:, 7:10), 'Time [min]', 'BB density (normalised) [\mum^{-2}]', {'Half BB density (normalised for plotting)', '(normalised to whole area BB density) vs Time'}, 'half_BBdensity_normalised_vs_time', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quadrant_bb_density_for_plot_reordered(:, 2), quadrant_bb_density_for_plot_reordered(:, 7:10), 'Apical domain area [\mum^2]', 'BB density [\mum^{-2}]', {'Half BB density (normalised for plotting)', '(absolute) vs apical domain area'}, 'half_BBdensity_absolute_vs_area', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quadrant_bb_density_for_plot_reordered_norm(:, 2), quadrant_bb_density_for_plot_reordered_norm(:, 7:10), 'Apical domain area [\mum^2]', 'BB density (normalised)', {'Half BB density (normalised for plotting)', '(normalised to whole area BB density) vs apical domain area'}, 'half_BBdensity_normalised_vs_area', savelink_parameter_plots, 'half', final_sort_order);
plot_function(bb_density_norm, quadrant_bb_density_for_plot_reordered(:, 7:10), 'Apical domain BB density [\mum^{-2}]', 'BB density of halves [\mum^{-2}]', {'Half BB density (normalised for plotting)', 'vs apical domain BB density (normalised for plotting)'}, 'half_bbdensity_vs_apicalarea_bbdensity', savelink_parameter_plots, 'half', final_sort_order);

% Mean actin intensity of top/bottom sides plotted against time and apical domain area
plot_function(quad_halves_meanint_norm_reordered(:, 1), quad_halves_meanint_norm_reordered(:, 7:10), 'Time [min]', 'Mean actin intensity', 'Half mean actin Int. vs Time', 'half_mean_actin_intensity_vs_time', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quad_halves_meanint_norm_reordered(:, 2), quad_halves_meanint_norm_reordered(:, 7:10), 'Apical domain area [\mum^2]', 'Mean actin intensity', {'Half mean actin Int.', 'vs apical domain area'}, 'half_mean_actin_intensity_vs_area', savelink_parameter_plots, 'half', final_sort_order);
plot_function(MeanIntensity_apicaldomain, quad_halves_meanint_norm_reordered(:, 7:10), 'Apical domain mean actin Int.', 'Mean actin Int. of halves', {'Half mean actin int vs apical', 'domain mean actin int.'}, 'half_mean_actin_int_vs_apicalarea_mean_actin_int', savelink_parameter_plots, 'half', final_sort_order);

% Total actin intensity of top/bottom sides plotted against time and apical domain area
plot_function(quad_halves_totalint_norm_reordered(:, 1), quad_halves_totalint_norm_reordered(:, 7:10), 'Time [min]', 'Total actin intensity', 'Half total actin Int. vs Time', 'half_total_actin_intensity_vs_time', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quad_halves_totalint_norm_reordered(:, 2), quad_halves_totalint_norm_reordered(:, 7:10), 'Apical domain area [\mum^2]', 'Total actin intensity', {'Half total actin Int. ', 'vs apical domain area'}, 'half_total_actin_intensity_vs_area', savelink_parameter_plots, 'half', final_sort_order);
plot_function(TotalIntensity_apicaldomain, quad_halves_totalint_norm_reordered(:, 7:10), 'Apical domain total actin Int.', 'Total actin Int. of halves', {'Half total actin int vs apical', 'domain total actin int.'}, 'half_total_actin_int_vs_apicalarea_total_actin_int', savelink_parameter_plots, 'half', final_sort_order);

% area vs BB count
plot_function(quadrant_area_reordered(:,7:10), quadrant_BBs_reordered(:, 7:10), 'Half area [\mum^2]', 'Half BB count', 'Half area vs Half BB count', 'half_area_vs_half_bb_count', savelink_parameter_plots, 'half', final_sort_order);

% Count of Newly appearing BB in the top/bottom sides plotted against apical domain area and time
plot_function(quadrant_new_BBs_reordered(:, 1), quadrant_new_BBs_reordered(:, 7:10), 'Time [min]', 'New BB count', {'Half New BB count', '(absolute) vs Time'}, 'half_Newbbcount_absolute_vs_time', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quadrant_new_BBs_reordered_norm(:, 1), quadrant_new_BBs_reordered_norm(:, 7:10), 'Time [min]', 'New BB count', {'Half New BB count', '(normalised) vs Time'}, 'half_Newbbcount_normalised_vs_time', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quadrant_new_BBs_reordered(:, 2), quadrant_new_BBs_reordered(:, 7:10), 'Apical domain area [\mum^2]', 'New BB count', {'Half New BB count', '(absolute) vs apical domain area'}, 'half_Newbbcount_absolute_vs_area', savelink_parameter_plots, 'half', final_sort_order);
plot_function(quadrant_new_BBs_reordered_norm(:, 2), quadrant_new_BBs_reordered_norm(:, 7:10), 'Apical domain area [\mum^2]', 'New BB count (normalised)', {'Half New BB count', '(normalised) vs apical domain area'}, 'half_Newbbcount_normalised_vs_area', savelink_parameter_plots, 'half', final_sort_order);
plot_function(new_bb_crds_full(:,2), quadrant_new_BBs_reordered(:, 7:10), 'New BB count (apical domain area)', {'New BB count halves', '(normalised)'}, {'Half New BB count', 'vs apical domain area New BB count'}, 'half_Newbbcount_vs_apicalarea_Newbbcount', savelink_parameter_plots, 'half', final_sort_order);

% Clumping factor (Quadrant area) plotted against time and apical domain area
plot_function(quadrant_area(:, 2), clumpingfactor_area(:,1), 'Apical area [\mum^2]', 'Clumping factor (Quadrant Area)', 'Clumping factor (Quadrant Area) vs Apical area', 'ClumpingFactor_area_vs_apical_area', savelink_parameter_plots, 'NaN', final_sort_order);
plot_function(quadrant_area(:, 1), clumpingfactor_area(:,1), 'Time [min]', 'Clumping factor (Quadrant Area)', 'Clumping factor (Quadrant Area) vs Time', 'ClumpingFactor_area_vs_time', savelink_parameter_plots, 'NaN', final_sort_order);

% Clumping factor (Quadrant area rate) plotted against time and apical domain area
plot_function(quad_area_rate(:, 2), clumpingfactor_arearate(:,1), 'Apical area [\mum^2]', 'Clumping factor (Quadrant Rate of expansion)', 'Clumping factor (Quadrant Rate of expansion) vs Apical area', 'ClumpingFactor_arearate_vs_apical_area', savelink_parameter_plots, 'NaN', final_sort_order);
plot_function(quad_area_rate(:, 1), clumpingfactor_arearate(:,1), 'Time [min]', 'Clumping factor (Quadrant Rate of expansion)', 'Clumping factor (Quadrant Rate of expansion) vs Time', 'ClumpingFactor_arearate_vs_time', savelink_parameter_plots, 'NaN', final_sort_order);

% Clumping factor (Quadrant BB count) plotted against time and apical domain area
plot_function(quadrant_BBs(:, 2), clumpingfactor_bbcount(:,1), 'Apical area [\mum^2]', 'Clumping factor (Quadrant BB count)', 'Clumping factor (Quadrant BB count) vs Apical area', 'ClumpingFactor_bbcount_vs_apical_area', savelink_parameter_plots, 'NaN', final_sort_order);
plot_function(quadrant_BBs(:, 1), clumpingfactor_bbcount(:,1), 'Time [min]', 'Clumping factor (Quadrant BB count)', 'Clumping factor (Quadrant BB count) vs Time', 'ClumpingFactor_bbcount_vs_time', savelink_parameter_plots, 'NaN', final_sort_order);

% Clumping factor (Quadrant BB density) plotted against time and apical domain area
plot_function(quadrant_bb_density(:, 2), clumpingfactor_bbddensity(:,1), 'Apical area [\mum^2]', 'Clumping factor (Quadrant BB density)', 'Clumping factor (Quadrant BB density) vs Apical area', 'ClumpingFactor_bbdensity_vs_apical_area', savelink_parameter_plots, 'NaN', final_sort_order);
plot_function(quadrant_bb_density(:, 1), clumpingfactor_bbddensity(:,1), 'Time [min]', 'Clumping factor (Quadrant BB density)', 'Clumping factor (Quadrant BB density) vs Time', 'ClumpingFactor_bbdensity_vs_time', savelink_parameter_plots, 'NaN', final_sort_order);

% Clumping factor (Quadrant Mean Actin Intensity) plotted against time and apical domain area
plot_function(quad_halves_meanint_norm(:, 2), clumpingfactor_meanint(:,1), 'Apical area [\mum^2]', 'Clumping factor (Quadrant Mean Actin Intensity)', 'Clumping factor (Quadrant Mean Actin Intensity) vs Apical area', 'ClumpingFactor_meanint_vs_apical_area', savelink_parameter_plots, 'NaN', final_sort_order);
plot_function(quad_halves_meanint_norm(:, 1), clumpingfactor_meanint(:,1), 'Time [min]', 'Clumping factor (Quadrant Mean Actin Intensity)', 'Clumping factor (Quadrant Mean Actin Intensity) vs Time', 'ClumpingFactor_meanint_vs_time', savelink_parameter_plots, 'NaN', final_sort_order);

% Clumping factor (Quadrant Total Actin Intensity) plotted against time and apical domain area
plot_function(quad_halves_totalint_norm(:, 2), clumpingfactor_totalint(:,1), 'Apical area [\mum^2]', 'Clumping factor (Quadrant Total Actin Intensity)', 'Clumping factor (Quadrant Total Actin Intensity) vs Apical area', 'ClumpingFactor_totalint_vs_apical_area', savelink_parameter_plots, 'NaN', final_sort_order);
plot_function(quad_halves_totalint_norm(:, 1), clumpingfactor_totalint(:,1), 'Time [min]', 'Clumping factor (Quadrant Total Actin Intensity)', 'Clumping factor (Quadrant Total Actin Intensity) vs Time', 'ClumpingFactor_totalint_vs_time', savelink_parameter_plots, 'NaN', final_sort_order);

% Clumping factor (Quadrant New BB count) plotted against time and apical domain area
plot_function(quadrant_new_BBs(:, 2), clumpingfactor_newBBcount(:,1), 'Apical area [\mum^2]', 'Clumping factor (Quadrant New BB count)', 'Clumping factor (Quadrant New BB count) vs Apical area', 'ClumpingFactor_newbbcount_vs_apical_area', savelink_parameter_plots, 'NaN', final_sort_order);
plot_function(quadrant_new_BBs(:, 1), clumpingfactor_newBBcount(:,1), 'Time [min]', 'Clumping factor (Quadrant New BB count)', 'Clumping factor (Quadrant New BB count) vs Time', 'ClumpingFactor_newbbcount_vs_time', savelink_parameter_plots, 'NaN', final_sort_order);

close all;

%% Saving workspace
save('workspace_bb_density_distribution_expansion_bias');

%% Saving the figures as montage

bb_density_expansion_bias = '../Plots/bb_density_distribution_expansion_bias/parameter_plots'; % location from where the plots will be fetched

montage_fig = '../Plots/montage';
fig1 = fullfile(bb_density_expansion_bias, 'quad_area_absolute_vs_time.tif');
fig2 = fullfile(bb_density_expansion_bias, 'quad_area_absolute_vs_area.tif');
fig3 = fullfile(bb_density_expansion_bias, 'quad_bbcount_absolute_vs_time.tif');
fig4 = fullfile(bb_density_expansion_bias, 'quad_bbcount_absolute_vs_area.tif');
fig5 = fullfile(bb_density_expansion_bias, 'quad_arearate_absolute_vs_time.tif');
fig6 = fullfile(bb_density_expansion_bias, 'quad_arearate_absolute_vs_area.tif');
fig7 = fullfile(bb_density_expansion_bias, 'quad_bbdensity_absolute_vs_time.tif');
fig8 = fullfile(bb_density_expansion_bias, 'quad_bbdensity_absolute_vs_area.tif');
fig9 = fullfile(bb_density_expansion_bias, 'quad_area_normalised_vs_time.tif');
fig10 = fullfile(bb_density_expansion_bias, 'quad_area_normalised_vs_area.tif');
fig11 = fullfile(bb_density_expansion_bias, 'quad_bbcount_normalised_vs_time.tif');
fig12 = fullfile(bb_density_expansion_bias, 'quad_bbcount_normalised_vs_area.tif');
fig13 = fullfile(bb_density_expansion_bias, 'quad_arearate_normalised_vs_time.tif');
fig14 = fullfile(bb_density_expansion_bias, 'quad_arearate_normalised_vs_area.tif');
fig15 = fullfile(bb_density_expansion_bias, 'quad_bbdensity_normalised_vs_time.tif');
fig16 = fullfile(bb_density_expansion_bias, 'quad_bbdensity_normalised_vs_area.tif');
montage({fig1, fig2, fig3, fig4, fig5, fig6, fig7, fig8, fig9, fig10, fig11, fig12, fig13, fig14, fig15, fig16});
saveas(gcf, fullfile(montage_fig,'slide_22_3_bb_density_expansion_bias'), 'tif'); close all;

fig17 = fullfile(bb_density_expansion_bias, 'quad_bbcount_vs_quadrant_area.tif');
fig18 = fullfile(bb_density_expansion_bias, 'quad_bbcount_vs_apicalarea_bbcount.tif');
% fig19 = fullfile(bb_density_expansion_bias, 'quad_arearate_vs_apicalarea_rate.tif'); % to be uncommented if needed (also the actual figure plot in the above section needs to be uncommented; and the fig19 should be added in the montage below)
fig20 = fullfile(bb_density_expansion_bias, 'quad_bbdensity_vs_apicalarea_bbdensity.tif');
montage({fig17, fig18, fig20});
saveas(gcf, fullfile(montage_fig,'slide_22_4_bb_density_expansion_bias'), 'tif'); close all;

fig21 = fullfile(bb_density_expansion_bias, 'half_area_absolute_vs_time.tif');
fig22 = fullfile(bb_density_expansion_bias, 'half_area_absolute_vs_area.tif');
fig23 = fullfile(bb_density_expansion_bias, 'half_BBcount_absolute_vs_time.tif');
fig24 = fullfile(bb_density_expansion_bias, 'half_BBcount_absolute_vs_area.tif');
fig25 = fullfile(bb_density_expansion_bias, 'half_BBdensity_absolute_vs_time.tif');
fig26 = fullfile(bb_density_expansion_bias, 'half_BBdensity_absolute_vs_area.tif');
fig27 = fullfile(bb_density_expansion_bias, 'half_arearate_absolute_vs_time.tif');
fig28 = fullfile(bb_density_expansion_bias, 'half_arearate_absolute_vs_area.tif');
fig29 = fullfile(bb_density_expansion_bias, 'half_area_normalised_vs_time.tif');
fig30 = fullfile(bb_density_expansion_bias, 'half_area_normalised_vs_area.tif');
fig31 = fullfile(bb_density_expansion_bias, 'half_BBcount_normalised_vs_time.tif');
fig32 = fullfile(bb_density_expansion_bias, 'half_BBcount_normalised_vs_area.tif');
fig33 = fullfile(bb_density_expansion_bias, 'half_BBdensity_normalised_vs_time.tif');
fig34 = fullfile(bb_density_expansion_bias, 'half_BBdensity_normalised_vs_area.tif');
fig35 = fullfile(bb_density_expansion_bias, 'half_arearate_normalised_vs_time.tif');
fig36 = fullfile(bb_density_expansion_bias, 'half_arearate_normalised_vs_area.tif');
montage({fig21, fig22, fig23, fig24, fig25, fig26, fig27, fig28, fig29, fig30, fig31, fig32, fig33, fig34, fig35, fig36});
saveas(gcf, fullfile(montage_fig,'slide_22_1_bb_density_expansion_bias'), 'tif'); close all;


fig37 = fullfile(bb_density_expansion_bias, 'half_bbcount_vs_apicalarea_bbcount.tif');
fig38 = fullfile(bb_density_expansion_bias, 'half_bbdensity_vs_apicalarea_bbdensity.tif');
% fig39 = fullfile(bb_density_expansion_bias, 'half_(area_rate)_vs_apicalarea_(area_rate).tif'); % to be uncommented if needed (also the actual figure plot in the above section needs to be uncommented; and the fig55 should be added in the montage below)
fig40 = fullfile(bb_density_expansion_bias, 'half_area_vs_half_bb_count.tif');
montage({fig37, fig38, fig40});
saveas(gcf, fullfile(montage_fig,'slide_22_2_bb_density_expansion_bias'), 'tif'); close all;

fig41 = fullfile(bb_density_expansion_bias, 'half_mean_actin_intensity_vs_time.tif');
fig42 = fullfile(bb_density_expansion_bias, 'half_mean_actin_intensity_vs_area.tif');
fig43 = fullfile(bb_density_expansion_bias, 'half_total_actin_intensity_vs_time.tif');
fig44 = fullfile(bb_density_expansion_bias, 'half_total_actin_intensity_vs_area.tif');
fig45 = fullfile(bb_density_expansion_bias, 'half_mean_actin_int_vs_apicalarea_mean_actin_int.tif');
fig46 = fullfile(bb_density_expansion_bias, 'half_total_actin_int_vs_apicalarea_total_actin_int.tif');                                
fig47 = fullfile(bb_density_expansion_bias, 'quad_mean_actin_intensity_vs_time.tif');
fig48 = fullfile(bb_density_expansion_bias, 'quad_mean_actin_intensity_vs_area.tif');
fig49 = fullfile(bb_density_expansion_bias, 'quad_total_actin_intensity_vs_time.tif');
fig50 = fullfile(bb_density_expansion_bias, 'quad_total_actin_intensity_vs_area.tif');
fig51 = fullfile(bb_density_expansion_bias, 'quad_mean_actin_int_vs_apicalarea_mean_actin_int.tif');
fig52 = fullfile(bb_density_expansion_bias, 'quad_total_actin_int_vs_apicalarea_total_actin_int.tif');
montage({fig41, fig42, fig43, fig44, fig45, fig46, fig47, fig48, fig49, fig50, fig51, fig52});
saveas(gcf, fullfile(montage_fig,'slide_22_5_bb_density_expansion_bias'), 'tif'); close all;

fig53 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_area_vs_apical_area.tif');
fig54 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_area_vs_time.tif');
fig55 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_arearate_vs_apical_area.tif');
fig56 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_arearate_vs_time.tif');
fig57 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_bbcount_vs_apical_area.tif');
fig58 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_bbcount_vs_time.tif');
fig59 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_bbdensity_vs_apical_area.tif');
fig60 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_bbdensity_vs_time.tif');
fig61 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_meanint_vs_apical_area.tif');
fig62 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_meanint_vs_time.tif');
fig63 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_totalint_vs_apical_area.tif');
fig64 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_totalint_vs_time.tif');
fig65 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_newbbcount_vs_apical_area.tif');
fig66 = fullfile(bb_density_expansion_bias, 'ClumpingFactor_newbbcount_vs_time.tif');
montage({fig53, fig54, fig55, fig56, fig57, fig58, fig59, fig60, fig61, fig62, fig63, fig64, fig65, fig66});
saveas(gcf, fullfile(montage_fig,'slide_22_6_bb_density_expansion_bias'), 'tif'); close all;

fig67 = fullfile(bb_density_expansion_bias, 'half_Newbbcount_absolute_vs_time.tif');
fig68 = fullfile(bb_density_expansion_bias, 'half_Newbbcount_absolute_vs_area.tif');
fig69 = fullfile(bb_density_expansion_bias, 'half_Newbbcount_normalised_vs_time.tif');
fig70 = fullfile(bb_density_expansion_bias, 'half_Newbbcount_normalised_vs_area.tif');
fig71 = fullfile(bb_density_expansion_bias, 'quad_Newbbcount_absolute_vs_time.tif');
fig72 = fullfile(bb_density_expansion_bias, 'quad_Newbbcount_absolute_vs_area.tif');
fig73 = fullfile(bb_density_expansion_bias, 'quad_Newbbcount_normalised_vs_time.tif');
fig74 = fullfile(bb_density_expansion_bias, 'quad_Newbbcount_normalised_vs_area.tif');
fig75 = fullfile(bb_density_expansion_bias, 'half_Newbbcount_vs_apicalarea_Newbbcount.tif');
fig76 = fullfile(bb_density_expansion_bias, 'quad_Newbbcount_vs_apicalarea_Newbbcount.tif');
montage({fig69, fig70, fig71, fig72, fig73, fig74, fig75, fig76});
saveas(gcf, fullfile(montage_fig,'slide_22_7_bb_density_expansion_bias'), 'tif'); close all;

% User prompt
disp('Run the macro "quad_halves_tif_saving.ijm". Then press a key !')
pause;

disp('Finished !');
toc

%% Function that extracts the quadrant coordinates and quadrant area

function [quad_area_vec_x, quad_area_vec_y, quad_area_pgon, quad_area, quad_no_of_BB, quad_no_of_NewBB] = finding_quadrant_area(sortorder, cur_centroid_x, cur_centroid_y, cur_area_crd_x, cur_area_crd_y, quad_idx, quadrant_theta, quad_limits, curr_bb_coord_x, curr_bb_coord_y, curr_Newbb_coord_x, curr_Newbb_coord_y, type_of_coordinates)

[~, sort_idx_theta] = sort(quadrant_theta, sortorder); % getting (i.e. sorting) the angles along the quadrant in the corresponding direction (for ex: (0 -to- pi/2); (pi/2 -to- pi) etc..)

cur_area_crd_x_theta_sort = cur_area_crd_x(quad_idx); % isolating the x coordinates from area periphery coordinates based on quadrant angle logical array
cur_area_crd_y_theta_sort = cur_area_crd_y(quad_idx); % isolating the y coordinates from area periphery coordinates based on quadrant angle logical array
sort_value_cur_area_crd_x_quad = cur_area_crd_x_theta_sort(sort_idx_theta); % sorting the x coordinates of the quadrant based on angle
sort_value_cur_area_crd_y_quad = cur_area_crd_y_theta_sort(sort_idx_theta); % sorting the y coordinates of the quadrant based on angle

if contains(type_of_coordinates, 'with_cortex')
    cur_centroid_x = 0;
    cur_centroid_y = 0;
end

if quad_limits == [0, pi/2] | quad_limits == [-pi/2, 0]
    quad_area_vec_x = vertcat(cur_centroid_x, cur_centroid_x, sort_value_cur_area_crd_x_quad, sort_value_cur_area_crd_x_quad(end,1), cur_centroid_x); % connecting the quadrant x coordinates to the centroid x coordinate
    quad_area_vec_y = vertcat(cur_centroid_y, sort_value_cur_area_crd_y_quad(1,1), sort_value_cur_area_crd_y_quad, cur_centroid_y, cur_centroid_y); % connecting the quadrant y coordinates to the centroid y coordinate
    quad_area_pgon = polyshape(quad_area_vec_x, quad_area_vec_y);
else
    quad_area_vec_x = vertcat(cur_centroid_x, sort_value_cur_area_crd_x_quad(1,1), sort_value_cur_area_crd_x_quad, cur_centroid_x, cur_centroid_x); % connecting the quadrant x coordinates to the centroid x coordinate
    quad_area_vec_y = vertcat(cur_centroid_y, cur_centroid_y, sort_value_cur_area_crd_y_quad, sort_value_cur_area_crd_y_quad(end,1), cur_centroid_y); % connecting the quadrant y coordinates to the centroid y coordinate
    quad_area_pgon = polyshape(quad_area_vec_x, quad_area_vec_y); % getting the coordinates of the closed quadrant using polyshape function
end
% getting the quadrant area
quad_area = polyarea(quad_area_vec_x, quad_area_vec_y); % polyarea function is an alternative to the polygon area for obtaining the area of the polygon.

% matching the locations of BBs to the corresponding quadrants
quad_BB_match = isinterior(quad_area_pgon, curr_bb_coord_x, curr_bb_coord_y); % finding those BBs that are present within the quadrant (for the quadrant coordinates that are centroid adjusted i.e. (0,0))
quad_no_of_BB = nnz(quad_BB_match); % removing zeros from difference in array length

% matching the locations of newly appearing BBs to the corresponding quadrants
quad_NewBB_match = isinterior(quad_area_pgon, curr_Newbb_coord_x, curr_Newbb_coord_y); % finding those new BBs that are appearing within the quadrant (for the quadrant coordinates that are centroid adjusted i.e. (0,0))
quad_no_of_NewBB = nnz(quad_NewBB_match); % removing zeros from difference in array length
end

%% Function that plots the quadrants of the apical area and the BBs

function quad_plot_imgs(tmepoints, Image_dime, pixelwidth, area_quadrant_bb_details, quad_pogn, quad_Indx, plot_save_name, savelink_area_bb_quad)
parfor ii = 1:tmepoints
    figure(ii);
    set(gcf, 'position', [10, 10, Image_dime(1,1), Image_dime(1,2)]); % set(gcf, 'position', [10, 10, 500, 500]); 

    plot(quad_pogn{ii,1}, 'EdgeColor', 'k', 'FaceColor', 'none'); set (gca, 'YDir', 'reverse');
    hold on
    plot(quad_pogn{ii,2}, 'EdgeColor', 'm', 'FaceColor', 'none');
    hold on
    plot(quad_pogn{ii,3}, 'EdgeColor', 'b', 'FaceColor', 'none');
    hold on
    plot(quad_pogn{ii,4}, 'EdgeColor', 'r', 'FaceColor', 'none');
    hold on
    plot(area_quadrant_bb_details{ii,1}(quad_Indx{ii,1},1), area_quadrant_bb_details{ii,1}(quad_Indx{ii,1},2), 'k*', 'MarkerSize', 3);
    hold on
    plot(area_quadrant_bb_details{ii,1}(quad_Indx{ii,2},1), area_quadrant_bb_details{ii,1}(quad_Indx{ii,2},2), 'm*', 'MarkerSize', 3);
    hold on
    plot(area_quadrant_bb_details{ii,1}(quad_Indx{ii,3},1), area_quadrant_bb_details{ii,1}(quad_Indx{ii,3},2), 'b*', 'MarkerSize', 3);
    hold on
    plot(area_quadrant_bb_details{ii,1}(quad_Indx{ii,4},1), area_quadrant_bb_details{ii,1}(quad_Indx{ii,4},2), 'r*', 'MarkerSize', 3);
    hold on
    plot(area_quadrant_bb_details{ii,6}(:,1), area_quadrant_bb_details{ii,6}(:,2), 'b.', 'MarkerSize', 4);
    hold off; box on;
    % xlim([-(343*pixelwidth/2) (343*pixelwidth/2)]); ylim([-(343*pixelwidth/2) (343*pixelwidth/2)]); 
    xlim([-(Image_dime(1,1)*pixelwidth/2) (Image_dime(1,1)*pixelwidth/2)]); ylim([-(Image_dime(1,2)*pixelwidth/2) (Image_dime(1,2)*pixelwidth/2)]);
    axis equal;
    % Uncomment below line if you dont want to plot the axes in other words if you want to plot the area and quadrants as images, then uncomment this line
    % axis off
    xlabel('x [\mum]');  ylabel('y [\mum]'); title('Quadrants in apical domain'); set(gca,'fontsize',10);
    parfor_save(plot_save_name, savelink_area_bb_quad, ii);
end
end

%% Function that extracts the top-bottom & left-right half coordinates

function [half_area_vec_x, half_area_vec_y] = finding_half_area(sortorder, cur_centroid_x, cur_centroid_y, cur_area_crd_x, cur_area_crd_y, half_idx, half_theta, half_limits, type_of_coordinates)

[~, sort_idx_theta] = sort(half_theta, sortorder); % getting (i.e. sorting) the angles along the quadrant in the corresponding direction (for ex: (0 -to- pi/2); (pi/2 -to- pi) etc..)

cur_area_crd_x_theta_sort = cur_area_crd_x(half_idx); % isolating the x coordinates from area periphery coordinates based on the halve's angle logical array
cur_area_crd_y_theta_sort = cur_area_crd_y(half_idx); % isolating the y coordinates from area periphery coordinates based on the halve's angle logical array
sort_value_cur_area_crd_x_half = cur_area_crd_x_theta_sort(sort_idx_theta); % sorting the x coordinates of the half, based on angle
sort_value_cur_area_crd_y_half = cur_area_crd_y_theta_sort(sort_idx_theta); % sorting the y coordinates of the half, based on angle

if contains(type_of_coordinates, 'with_cortex')
    cur_centroid_x = 0;
    cur_centroid_y = 0;
end

%limits_of_half_1_3 = [0, pi/2, pi, -pi/2];
if half_limits == [0, pi] | half_limits == [-pi, 0]
    half_area_vec_x = vertcat(sort_value_cur_area_crd_x_half(1,1), sort_value_cur_area_crd_x_half, sort_value_cur_area_crd_x_half(end,1), sort_value_cur_area_crd_x_half(1,1)); % connecting the halve's x coordinates to the centroid x coordinate
    half_area_vec_y = vertcat(cur_centroid_y, sort_value_cur_area_crd_y_half, cur_centroid_y, cur_centroid_y); % connecting the halve's y coordinates to the centroid y coordinate
elseif half_limits == [-pi/2, pi/2]
    half_area_vec_x = vertcat(cur_centroid_x, sort_value_cur_area_crd_x_half, cur_centroid_x, cur_centroid_x); % connecting the halve's x coordinates to the centroid x coordinate
    half_area_vec_y = vertcat(sort_value_cur_area_crd_y_half(1,1), sort_value_cur_area_crd_y_half, sort_value_cur_area_crd_y_half(end,1), sort_value_cur_area_crd_y_half(1,1)); % connecting the halve's y coordinates to the centroid y coordinate
elseif half_limits == [pi/2, pi]
    half_area_vec_x = vertcat(cur_centroid_x, sort_value_cur_area_crd_x_half, sort_value_cur_area_crd_x_half(end,1)); % connecting the halve's x coordinates to the centroid x coordinate
    half_area_vec_y = vertcat(sort_value_cur_area_crd_y_half(1,1), sort_value_cur_area_crd_y_half, cur_centroid_y); % connecting the halve's y coordinates to the centroid y coordinate
elseif half_limits == [-pi, -pi/2]
    half_area_vec_x = vertcat(sort_value_cur_area_crd_x_half(1,1), sort_value_cur_area_crd_x_half, cur_centroid_x); % connecting the halve's x coordinates to the centroid x coordinate
    half_area_vec_y = vertcat(cur_centroid_y, sort_value_cur_area_crd_y_half, sort_value_cur_area_crd_y_half(end,1)); % connecting the halve's y coordinates to the centroid y coordinate
end
end

%% Function that plots the top-bottom & left-right halves of the apical area and the BBs

function half_plots(half_type, col_no_1, col_no_2, tmepoints, Image_dime, pixelwidth, area_quadrant_bb_details, half_Indx, clrs, plot_save_name, savelink_halves)
parfor kk = 1:tmepoints
    figure(kk);
    set(gcf, 'position', [10, 10, Image_dime(1,1), Image_dime(1,2)]);

    plot(area_quadrant_bb_details{kk,col_no_1(1)}(:,1), area_quadrant_bb_details{kk,col_no_1(1)}(:,2), 'Color', clrs(1)); set (gca, 'YDir', 'reverse');
    hold on
    plot(area_quadrant_bb_details{kk,col_no_1(2)}(:,1), area_quadrant_bb_details{kk,col_no_1(2)}(:,2), 'Color', clrs(2));
    hold on
    plot(area_quadrant_bb_details{kk,1}(half_Indx{kk,col_no_2(1)},1), area_quadrant_bb_details{kk,1}(half_Indx{kk,col_no_2(1)},2), '*', 'Color', clrs(1), 'MarkerSize', 3);
    hold on
    plot(area_quadrant_bb_details{kk,1}(half_Indx{kk,col_no_2(2)},1), area_quadrant_bb_details{kk,1}(half_Indx{kk,col_no_2(2)},2), '*', 'Color', clrs(2), 'MarkerSize', 3);
    hold on
    plot(area_quadrant_bb_details{kk,6}(:,1), area_quadrant_bb_details{kk,6}(:,2), 'b.', 'MarkerSize', 4);
    hold off; box on;

    xlim([-(Image_dime(1,1)*pixelwidth/2) (Image_dime(1,1)*pixelwidth/2)]); ylim([-(Image_dime(1,2)*pixelwidth/2) (Image_dime(1,2)*pixelwidth/2)]);
    axis equal;
    % Uncomment below line if you dont want to plot the axes in other words if you want to plot the area and quadrants as images, then uncomment this line
    % axis off
    xlabel('x [\mum]');  ylabel('y [\mum]'); set(gca,'fontsize',10);

    if contains(half_type,'top_bottom')
        title('Top Bottom halves in apical domain');
    else
        title('Left Right halves in apical domain');
    end
    parfor_save(plot_save_name, savelink_halves, kk);
end
end

%% Function that plots the color coded BB density & Actin intensity for all the quadrants & halves

function actinInt_bbdensity_quad_half_imgs(type, area_quadrant_bb_details, plot_parameter, col_no, ylabl, plot_title, tmepoints, Image_dime, pixelwidth, plot_save_name, savelink_plot_colorcde)
parfor j = 1:tmepoints
    figure(j);
    set(gcf, 'position', [10, 10, Image_dime(1,1), Image_dime(1,2)]); % set(gcf, 'position', [10, 10, 500, 500]); 
    colormap parula;
    % patch based figure of quadrants & halves
    if contains(type, 'quad')
        x = area_quadrant_bb_details{j,2}(:,1); y = area_quadrant_bb_details{j,2}(:,2); c = ones(length(area_quadrant_bb_details{j,2}(:,1)),1)*plot_parameter(j,col_no(1));
        patch(x,y,c); set (gca, 'YDir', 'reverse');
        hold on;
        x = area_quadrant_bb_details{j,3}(:,1); y = area_quadrant_bb_details{j,3}(:,2); c = ones(length(area_quadrant_bb_details{j,3}(:,1)),1)*plot_parameter(j,col_no(2));
        patch(x,y,c);
        hold on;
        x = area_quadrant_bb_details{j,4}(:,1); y = area_quadrant_bb_details{j,4}(:,2); c = ones(length(area_quadrant_bb_details{j,4}(:,1)),1)*plot_parameter(j,col_no(3));
        patch(x,y,c);
        hold on;
        x = area_quadrant_bb_details{j,5}(:,1); y = area_quadrant_bb_details{j,5}(:,2); c = ones(length(area_quadrant_bb_details{j,5}(:,1)),1)*plot_parameter(j,col_no(4));
        patch(x,y,c);
        shading interp; clim([min(min(plot_parameter(:,col_no(1):col_no(4)))) max(max(plot_parameter(:,col_no(1):col_no(4))))]); % plot settings % clim([0 max(max(plot_parameter(:,col_no(1):col_no(2))))]); 
        hold on;
    elseif contains(type, 'top-bottom') || contains(type, 'left-right')
        x = area_quadrant_bb_details{j,col_no(1)}(:,1); y = area_quadrant_bb_details{j,col_no(1)}(:,2); c = ones(length(area_quadrant_bb_details{j,col_no(1)}(:,1)),1)*plot_parameter(j,col_no(1));
        patch(x,y,c); set (gca, 'YDir', 'reverse'); 
        hold on;
        x = area_quadrant_bb_details{j,col_no(2)}(:,1); y = area_quadrant_bb_details{j,col_no(2)}(:,2); c = ones(length(area_quadrant_bb_details{j,col_no(2)}(:,1)),1)*plot_parameter(j,col_no(2));
        patch(x,y,c);
        shading interp; clim([min(min(plot_parameter(:,col_no(1):col_no(2)))) max(max(plot_parameter(:,col_no(1):col_no(2))))]); % plot settings
        hold on;
    end
    % plotting BBs
    plot(area_quadrant_bb_details{j,6}(:,1), area_quadrant_bb_details{j,6}(:,2), 'k.', 'MarkerSize', 4);
    axis equal; box on; hold off;       
    % plot settings
    cb = colorbar; ylabel(cb, ylabl, 'FontSize', 10, 'Rotation', 270);
    % xlim([-(343*pixelwidth/2) (343*pixelwidth/2)]); ylim([-(343*pixelwidth/2) (343*pixelwidth/2)]); 
    xlim([-(Image_dime(1,1)*pixelwidth/2) (Image_dime(1,1)*pixelwidth/2)]); ylim([-(Image_dime(1,2)*pixelwidth/2) (Image_dime(1,2)*pixelwidth/2)]);
    xlabel('x [\mum]');  ylabel('y [\mum]'); title(plot_title); set(gca,'fontsize',10);
    parfor_save(plot_save_name, savelink_plot_colorcde, j);
end
end

%% Function that does the saving for the Parpool process
function parfor_save(plot_save_name, savelink_plot_colorcde, iterant)
saveas(gcf, fullfile(savelink_plot_colorcde, strcat(plot_save_name, sprintf('%01d',iterant))), 'tif'); % fig
close(figure(iterant));
end

%% Function for reordering the matrices

function [reordered_matrix, temp_mat_sort] = reordering_matrices(max_area_idx, input_mat, concerned_cols, sorted_col_order)

reordered_matrix = input_mat;
temp_mat(:,1) = concerned_cols(:,1);
temp_mat_start_val = abs(temp_mat(1,1));
temp_mat_end_val = abs(temp_mat(end,1));

if isempty(sorted_col_order)    
    temp_mat(:,2) = input_mat(max_area_idx, temp_mat_start_val:temp_mat_end_val);
    temp_mat_sort = sortrows(temp_mat, 2);
else    
    temp_mat_sort(:,1) = sorted_col_order;
end
reordered_matrix(:, temp_mat_start_val:1:temp_mat_end_val) = input_mat(:, abs(temp_mat_sort(:,1)));
end

%% Function for plotting the parameters

function plot_function(xaxis, yaxis, xaxis_label, yaxis_label, plot_title, save_title, savelink_parameter_plots, legend_count, final_sort_order)
close all;
figure(200);
linecolors = ["m" "k" "b" "r"]; 
quadrant_legends_4 = {strcat('Quadrant 1 (low BB density); Actual quadrant-', final_sort_order{1,2}), strcat('Quadrant 2; Actual quadrant-', final_sort_order{2,2}), strcat('Quadrant 3; Actual quadrant-', final_sort_order{3,2}), strcat('Quadrant 4 (high BB density); Actual quadrant-', final_sort_order{4,2})}; 
half_legends_2 = {strcat('Half 1 (low BB density); Actual half-', final_sort_order{5,2}), strcat('Half 2; Actual half-', final_sort_order{6,2}), strcat('Half 3; Actual half-', final_sort_order{7,2}), strcat('Half 4 (high BB density); Actual half-', final_sort_order{8,2})}; 

if contains(save_title, "Newbbcount")
    stem(xaxis, yaxis, 'LineWidth', 1); colororder(linecolors);
else
    plot(xaxis, yaxis, 'LineWidth', 1); colororder(linecolors);
end

xlabel(xaxis_label); ylabel(yaxis_label); title(plot_title); set(gca,'fontsize',14);
if legend_count == '4'
    legend(quadrant_legends_4, 'Location', 'best', 'fontsize', 10);
elseif contains(legend_count, 'half')
    legend(half_legends_2, 'Location', 'best', 'fontsize', 10);
end
saveas(gcf, fullfile(savelink_parameter_plots, save_title), 'fig'); saveas(gcf, fullfile(savelink_parameter_plots, save_title), 'tif');
close(figure(200));
end

%% Function for creating a matrix in a frame wise manner from the matrix, 'BB_Trajectory_data'

% The loop below is taken from the 'bb_appearance_distance_location.m'.
% The loop below creates a matrix in a frame wise manner called the "frame_wise_data" with the parameters:
% Frame number (Col 1), Area (Col 2), BB count (without trajectory filtering) in that frame (Col 3 & col 4), and BB coordinates (starting col 5, alternating x and y coordinates)
% "frame_wise_data" is made from the 'Trajectory_data'.
function [frame_wise_data_final] = frame_wise_BB_matrix_construction(Trajectory_data, Area_apicaldomain, No_of_BB)

first_frame = min(cellfun(@min, Trajectory_data(:,2))); % Finding the first frame
last_frame = max(cellfun(@max, Trajectory_data(:,2))); % Finding the last frames

bb_counter = 0; % initialisation
for i = first_frame:last_frame
    for j = 1:length(Trajectory_data) % searching through length of the Trajectory data i.e. through all trajectories and looking for frame numbers (i)
        matching_elements(j,1) = cellfun(@(x) x==i, Trajectory_data(j,2), 'un', 0); % finding whether the index of frame number within every cell of every trajectory through logical true or false operation
        idx = find(matching_elements{j,1}); % finding the exact index of that frame number
        if  isempty(idx)
            bb_counter = bb_counter + 0; % this is to skip those trajectories that do not have the frame number that is being searched
            continue
        elseif bb_counter == 0 % this is to make sure the first iteration of 'i' runs
            colval_for_xcord = bb_counter + 1; % fixing the column value for the BB x coordinate
            colval_for_ycord = bb_counter + 2; % fixing the column value for the BB y coordinate
            cord(1,colval_for_xcord) = Trajectory_data{j,3}(idx); % storing the x coordinate
            cord(1,colval_for_ycord) = Trajectory_data{j,4}(idx); % storing the y coordinate
            bb_counter = bb_counter + 1; % counter update
        else
            bb_counter = bb_counter + 1; % counter update
            colval_for_xcord = bb_counter + bb_counter - 1; % fixing the column value for the BB x coordinate
            colval_for_ycord = bb_counter + bb_counter; % fixing the column value for the BB y coordinate
            cord(1,colval_for_xcord) = Trajectory_data{j,3}(idx); % storing the x coordinate
            cord(1,colval_for_ycord) = Trajectory_data{j,4}(idx); % storing the y coordinate
        end
        % storing the different parameters in a framewise manner
        frame_wise_data(i,1) = i; % Frame number. Here 'i' can also be replaced by 'Trajectory_data{j,2}(idx)'.
        frame_wise_data(i,2) = Area_apicaldomain(Trajectory_data{j,2}(idx)); % Area
        frame_wise_data(i,3) = No_of_BB(Trajectory_data{j,2}(idx)); % BB count / no of BBs in the frame; This BB count is obtained from the workspace 'workspace_interim.mat' and corresponds to the 'No_of_BB' vector that is used to plot the Area vs BB_count plot. This BB count is obtained on processing 'all trajectories' without any filtering.
        frame_wise_data(i,4) = bb_counter; % BB count / no of BBs in the frame; This BB count is obtained while processing this loop and corresponds to the BB count numbers obtained on processed 'trajectories' (i.e. after applying the filters). The filters are applied in the for loop above this loop.
        % In general this BB count will correspond to less number of BBs than the BB count obtained from processing 'all trajectories'. That is because, while filtering based on the length of trajectories, many BBs will be left out. This effect will be amplified in the BB count obtained for the last few frames since
        % many BBs that reached the apical domain in the last few frames will have shorter trajecories. Since here we are processing the the data that is obtained after filtering the trajectories, we will get the x and y coordinates of only these BBs and process them further for obtaineing the different distances for which
        % this script is written. On the other hand, the BB_count from 'all trajecotries' without filtering will be used for plotting the Area vs BB_count plot and for obtaining the BB density since we need these data without any trajectory filtering based effects.
        frame_wise_data(i,5:(5+length(cord)-1)) = cord; % BB coordinates (x & y in alternating fashion)
    end
    bb_counter = 0; % resetting the counter
    clear cord
end

frame_wise_data(frame_wise_data==0) = nan; % replacing the zeros with nans.

% the logic below removes rows that are only filled with NaN. This is done in 3 steps:
% (1)goes through the 'frame_wise_data' and finds those rows that are filled only with NaN (these rows correspond to the frame numbers that are not part of any of the trajectories)
% (2)finds the indices of those rows
% (3)and removes those rows.
frame_wise_data_final = frame_wise_data; % reassigning the matrix
FindNaNelements = arrayfun(@(x) x, isnan(frame_wise_data_final(:,1)), 'un', 1); % finding those rows where the first column (i.e. frame number) is nan; If the frame number is nan,
% then it means that frame number does not exist in any of the trajectories; The result of this operation will be a logical array
idxNaNelements = find(FindNaNelements); % finding the indices where the logical result is '1'
frame_wise_data_final(idxNaNelements, :) = []; % using these indices to remove those rows where the logical result is '1'
% frame_wise_data_final is the matrix that stores all the parameters in a framewise manner
end

%% Function for fetching the new BB coordinates without filtering any trajectories
% This function is adapted from the 1st section of the script 'bb_appearance_distance_location.m' where the distance between the new BBs in the current frame and previous frame are computed. In the segment 
% below, all the details regarding distances are removed and we get only the new BB coordinates and arrange them in a Framewise manner in the resulting matrix 'table_bb_coordinates'
function [table_bb_coordinates] = new_BB_without_filter(TrajecInitPos, Time_interval, frm_nmb_modified, basalbody_count_modified)
new_basalbody_count_original = basalbody_count_modified * Time_interval; % Actually, 'basalbody_count_modified' is the basal body rate (which is basal body count / Time interval). Therefore, multiplying by 'Time_interval'
% getting the column that contains the frames where new BBs are appearing
bb_appearing_frames_orig = TrajecInitPos(:,2);

% in the logic below, we go to every frame where the new BBs are appearing and generate a matrix in a framewise manner
idx_begin_length = 1; % initialisation
idx_end_length = 1; % initialisation
frame_increment = 1; % initialisation
dummy_incre = 1; % initialisation
for j = 1:(length(bb_appearing_frames_orig)-1)
    curr_frame = bb_appearing_frames_orig(j);
    next_frame = bb_appearing_frames_orig(j+1);    
    if next_frame ~= curr_frame
        curr_xcrd = TrajecInitPos(idx_begin_length:idx_end_length,3); % getting all the BB coordinates in the current frame
        curr_ycrd = TrajecInitPos(idx_begin_length:idx_end_length,4);          
        if j ~= 1 && dummy_incre ~=1
            frame_increment = frame_increment + 1;            
            bbcoordinates_x(frame_increment, 1) = frm_nmb_modified(1,frame_increment); % storing the BB appearance frame numbers
            bbcoordinates_y(frame_increment, 1) = frm_nmb_modified(1,frame_increment); % storing the BB appearance frame numbers        
            for k = 1:length(curr_xcrd)             
                col = k+1;               
                bbcoordinates_x(frame_increment, col) = curr_xcrd(k); % Storing the x coordinates of the newly appearing BBs - without adjustment for centroid
                bbcoordinates_y(frame_increment, col) = curr_ycrd(k); % Storing the y coordinates of the newly appearing BBs - without adjustment for centroid
            end            
        else
            bbcoordinates_x(frame_increment, 1) = frm_nmb_modified(1,frame_increment); % storing the 1st frame number when the BB appears
            bbcoordinates_y(frame_increment, 1) = frm_nmb_modified(1,frame_increment); % storing the 1st frame number when the BB appears
            bbcoordinates_x(frame_increment, 2:length(curr_xcrd)+1) = curr_xcrd; % Storing the x coordinates of the newly appearing BBs - without adjustment for centroid - BBs appearing in the first frame (i.e. frame number obtained in the previous lines)
            bbcoordinates_y(frame_increment, 2:length(curr_xcrd)+1) = curr_ycrd; % Storing the y coordinates of the newly appearing BBs - without adjustment for centroid - BBs appearing in the first frame (i.e. frame number obtained in the previous lines)
        end                
        idx_begin_length = j+1;
        idx_end_length = j+1;
        dummy_incre = dummy_incre + 1;
    else
        idx_end_length = j+1;
    end
end

% below we make a table out of the matrices where we stored the frame numbers of newly appearing BBs and their corresponding x and y coordinates (without centroid adjustment)
% we will use this table (i.e the csv file) for getting the index based on number of BBs appeaaring in the new area and number of BBs appearing in the older areas.
% The resulting .csv file will be used by the Fiji macro that will be used in finding this index.
[~,c] = size(bbcoordinates_x);
table_bb_coordinates = table(bbcoordinates_x(:,1), new_basalbody_count_original(1,1:end-1)', 'VariableNames', {'Frame_no_of_BB_appearance', 'No_of_newly_appearing_BBs'}); % starting the table with the frame numbers where the new basal bodies appear and the corresponding number of basal bodies in each of these frames
% the loop below fills the table with the x and y coordinates of all BBs
for kl = 2:c % we are starting from 2 because the BB coordinates start from the second column in the bbcoordinates_x and bbcoordinates_y arrays.
    col_name_x = strcat('Xcrd_BB_',sprintf('%01d', (kl-1)));
    temp_tab_x = table(bbcoordinates_x(:,kl), 'VariableNames', {col_name_x});
    table_bb_coordinates = [table_bb_coordinates, temp_tab_x];
    col_name_y = strcat('Ycrd_BB_',sprintf('%01d', (kl-1)));
    temp_tab_y = table(bbcoordinates_y(:,kl), 'VariableNames', {col_name_y});
    table_bb_coordinates = [table_bb_coordinates, temp_tab_y];
end
end

%%
