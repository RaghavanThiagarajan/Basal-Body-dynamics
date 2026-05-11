%  Raghavan Thiagarajan, reNEW,  Copenhagen, 2022 November.

% This script goes through all the experimental folders, collects the saved
% data of individual experiments / cells and generates ensemble plots and
% average plots

%% Standard clearance
tic
clc
clear all;
close all;

%% Choosing the experiment type (Control / Perturbation)

% The experiment type decides the type of experiment being analysed:
% '1' corresponds to control / wildtype experiments
% '2' corresponds to alphaActinin MO experiments

experiment_type = 1; %

% The operation type decides the type of thresholding to be applied while plotting;
% Enter one of these numbers ('1', '2', '3', '4') for the 'operation_type' below.
% '1' plots rawdata without any restriction or thresholds
% '2' removes data corresponding to 0 - 'minimum_area_threshold' and the corresponding time is also removed;
% '3' restricts the area threshold to 'max_threshold_area' and time to 'max_threshold_time';
% '4' combines both (i) removal of 0 - 'minimum_area_threshold' and corresponding time; and (ii) restricting the area threshold to 'max_threshold_area' and restricting time to 'max_threshold_time';

operation_type = 4; %

main_folder_link = uigetdir('Select folder'); % select "Result_Data" folder
cd(main_folder_link);
[minimum_area_threshold, max_threshold_area, max_threshold_time, avg_plots_folder_name] = experiment_and_operation(experiment_type, operation_type); % function that sets the maximum and minimum threshold area and time depending on the choice of 'experiment_type' & 'operation_type'
mkdir(avg_plots_folder_name); % Creating a new folder for saving the plots
BB_apical_avg = avg_plots_folder_name; % location where the plots will be saved
montage_folder = strcat(avg_plots_folder_name, '/montage');
mkdir(montage_folder);
BB_apical_avg_montage = montage_folder; % location where the montages will be saved

%% Data collection from all experiments / cells
% The loop below goes through all the experimental folders within the chosen folder and collects data for plotting the ensemble plots and average plots

subfolder_list_1 = dir(main_folder_link);
%no_of_subfolder_list_1 = sum([subfolder_list_1(~ismember({subfolder_list_1.name},{'.','..'})).isdir]);
subfolders_1 = {subfolder_list_1([subfolder_list_1.isdir]).name};
subfolders_1 = subfolders_1(~ismember(subfolders_1,{'.', '..'}));
no_of_subfolders_1 = length(subfolders_1);
no_of_cells = 0;

for i = 1:no_of_subfolders_1 % here no_of_subfolders_1 corresponds to the number of experiments. Therefore increment i refers the same.
    subfolders_2_link =[main_folder_link, '\', subfolders_1{i}];
    cd(subfolders_2_link);
    if exist('analy', 'dir')
        analy_check =[subfolders_2_link, '\', 'analy'];
        cd(analy_check);
        if exist('Plots_matlab_script', 'dir')
            file_link_1 = [analy_check, '\', 'Plots_matlab_script\'];
            cd(file_link_1);
            % ================================================================================%
            % ============loading all the required parameters from different cells============%
            no_of_cells = no_of_cells + 1;

            load('workspace_interim.mat', 'Timelist', 'Area_apicaldomain', 'Area_apicaldomain_percent', 'residual_area', 'residual_area_percent', 'bb_area', 'bb_area_percent', 'sum_of_residual_bb_areas', 'No_of_BB', 'MeanIntensity_apicaldomain', 'TotalIntensity_apicaldomain', 'area_rate', 'norm_area_rate', 'whole_area_rate', 'aspect_ratio', 'Circularity_apicaldomain',...
                'MeanInt_BBposition_traj_atmaxarea_only', 'TotalInt_BBposition_traj_atmaxarea_only', 'MeanInt_BBsurround_traj_atmaxarea_only', 'TotalInt_BBsurround_traj_atmaxarea_only', 'MeanInt_BB_SurPos_ratio_traj_atmaxarea_only', 'TotalInt_BB_SurPos_ratio_traj_atmaxarea_only', 'MeanInt_BBposition_traj_atmaxarea_only_aligned', 'TotalInt_BBposition_traj_atmaxarea_only_aligned',...
                'MeanInt_BBsurround_traj_atmaxarea_only_aligned', 'TotalInt_BBsurround_traj_atmaxarea_only_aligned', 'MeanInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned', 'TotalInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned', 'Timelist_clone_traj_atmaxarea_only', 'Area_apicaldomain_clone_traj_atmaxarea_only', 'MeanInt_atBBpos_1st_frame',...
                'MeanInt_atBBpos_max_apical_area', 'TotalInt_atBBpos_1st_frame', 'TotalInt_atBBpos_max_apical_area', 'MeanInt_atBBSurr_1st_frame', 'MeanInt_atBBSurr_max_apical_area', 'TotalInt_atBBSurr_1st_frame', 'TotalInt_atBBSurr_max_apical_area', 'MeanInt_ratio_BBSurPos_1st_frame', 'MeanInt_ratio_BBSurPos_max_apical_area', 'TotalInt_ratio_BBSurPos_1st_frame', 'TotalInt_ratio_BBSurPos_max_apical_area');
            timelist((1:length(Timelist)),no_of_cells) = Timelist;
            area_apicaldomain((1:length(Area_apicaldomain)), no_of_cells) = Area_apicaldomain;
            area_apicaldomain_percent((1:length(Area_apicaldomain_percent)), no_of_cells) = Area_apicaldomain_percent;
            no_of_bb((1:length(No_of_BB)), no_of_cells) = No_of_BB;
            Residual_Area((1:length(residual_area)), no_of_cells) = residual_area;
            Residual_Area_percent((1:length(residual_area_percent)), no_of_cells) = residual_area_percent;
            BB_area((1:length(bb_area)), no_of_cells) = bb_area;
            BB_area_percent((1:length(bb_area_percent)), no_of_cells) = bb_area_percent;
            Sum_of_Residual_bb_areas_percent((1:length(sum_of_residual_bb_areas)), no_of_cells) = sum_of_residual_bb_areas;
            meanintensity_apicaldomain((1:length(MeanIntensity_apicaldomain)), no_of_cells) = MeanIntensity_apicaldomain;
            totalintensity_apicaldomain((1:length(TotalIntensity_apicaldomain)), no_of_cells) = TotalIntensity_apicaldomain;
            Area_rate((1:length(area_rate)), no_of_cells) = area_rate;
            Norm_Area_rate((1:length(norm_area_rate)), no_of_cells) = norm_area_rate;
            Whole_area_rate(1, no_of_cells) = whole_area_rate;
            isotropicity((1:length(aspect_ratio)), no_of_cells) = aspect_ratio;
            circularity((1:length(Circularity_apicaldomain)), no_of_cells) = Circularity_apicaldomain;
            meanint_atBBpos_Traj_atMaxArea_Only{no_of_cells} = MeanInt_BBposition_traj_atmaxarea_only(:);
            totalint_atBBpos_Traj_atMaxArea_Only{no_of_cells} = TotalInt_BBposition_traj_atmaxarea_only(:);
            meanint_atBBSurr_Traj_atMaxArea_Only{no_of_cells} = MeanInt_BBsurround_traj_atmaxarea_only(:);
            totalint_atBBSurr_Traj_atMaxArea_Only{no_of_cells} = TotalInt_BBsurround_traj_atmaxarea_only(:);
            meanint_BB_SurPos_ratio_Traj_atMaxArea_Only{no_of_cells} = MeanInt_BB_SurPos_ratio_traj_atmaxarea_only(:);
            totalint_BB_SurPos_ratio_Traj_atMaxArea_Only{no_of_cells} = TotalInt_BB_SurPos_ratio_traj_atmaxarea_only(:);
            meanint_BBpos_Traj_atMaxArea_Only_Aligned{no_of_cells} = MeanInt_BBposition_traj_atmaxarea_only_aligned(:);
            totalint_BBpos_Traj_atMaxArea_Only_Aligned{no_of_cells} = TotalInt_BBposition_traj_atmaxarea_only_aligned(:);
            meanint_BBSurr_Traj_atMaxArea_Only_Aligned{no_of_cells} = MeanInt_BBsurround_traj_atmaxarea_only_aligned(:);
            totalint_BBSurr_Traj_atMaxArea_Only_Aligned{no_of_cells} = TotalInt_BBsurround_traj_atmaxarea_only_aligned(:);
            meanint_BB_SurPos_ratio_Traj_atMaxArea_Only_Aligned{no_of_cells} = MeanInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned(:);
            totalint_BB_SurPos_ratio_Traj_atMaxArea_Only_Aligned{no_of_cells} = TotalInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned(:);
            Timelist_clone_Traj_atMaxArea_Only{no_of_cells} = Timelist_clone_traj_atmaxarea_only(:);
            Area_apicaldomain_clone_Traj_atMaxArea_Only{no_of_cells} = Area_apicaldomain_clone_traj_atmaxarea_only(:);
            meanint_atBBpos_1stframe(1:length(MeanInt_atBBpos_1st_frame), no_of_cells) = MeanInt_atBBpos_1st_frame;
            meanint_atBBpos_maxapicalarea(1:length(MeanInt_atBBpos_max_apical_area), no_of_cells) = MeanInt_atBBpos_max_apical_area;
            totalint_atBBpos_1stframe(1:length(TotalInt_atBBpos_1st_frame), no_of_cells) = TotalInt_atBBpos_1st_frame;
            totalint_atBBpos_maxapicalarea(1:length(TotalInt_atBBpos_max_apical_area), no_of_cells) = TotalInt_atBBpos_max_apical_area;
            meanint_atBBSurr_1stframe(1:length(MeanInt_atBBSurr_1st_frame), no_of_cells) = MeanInt_atBBSurr_1st_frame;
            meanint_atBBSurr_maxapicalarea(1:length(MeanInt_atBBSurr_max_apical_area), no_of_cells) = MeanInt_atBBSurr_max_apical_area;
            totalint_atBBSurr_1stframe(1:length(TotalInt_atBBSurr_1st_frame), no_of_cells) = TotalInt_atBBSurr_1st_frame;
            totalint_atBBSurr_maxapicalarea(1:length(TotalInt_atBBSurr_max_apical_area), no_of_cells) = TotalInt_atBBSurr_max_apical_area;
            meanint_ratio_BBSurPos_1stframe(1:length(MeanInt_ratio_BBSurPos_1st_frame), no_of_cells) = MeanInt_ratio_BBSurPos_1st_frame;
            meanint_ratio_BBSurPos_maxapicalarea(1:length(MeanInt_ratio_BBSurPos_max_apical_area), no_of_cells) = MeanInt_ratio_BBSurPos_max_apical_area;
            totalint_ratio_BBSurPos_1stframe(1:length(TotalInt_ratio_BBSurPos_1st_frame), no_of_cells) = TotalInt_ratio_BBSurPos_1st_frame;
            totalint_ratio_BBSurPos_maxapicalarea(1:length(TotalInt_ratio_BBSurPos_max_apical_area), no_of_cells) = TotalInt_ratio_BBSurPos_max_apical_area;
            clear Timelist Area_apicaldomain Area_apicaldomain_percent residual_area residual_area_percent bb_area bb_area_percent sum_of_residual_bb_areas No_of_BB MeanIntensity_apicaldomain TotalIntensity_apicaldomain area_rate norm_area_rate whole_area_rate aspect_ratio Circularity_apicaldomain...
                MeanInt_BBposition_traj_atmaxarea_only TotalInt_BBposition_traj_atmaxarea_only MeanInt_BBsurround_traj_atmaxarea_only TotalInt_BBsurround_traj_atmaxarea_only MeanInt_BB_SurPos_ratio_traj_atmaxarea_only TotalInt_BB_SurPos_ratio_traj_atmaxarea_only Timelist_clone_traj_atmaxarea_only Area_apicaldomain_clone_traj_atmaxarea_only MeanInt_BBposition_traj_atmaxarea_only_aligned TotalInt_BBposition_traj_atmaxarea_only_aligned MeanInt_BBsurround_traj_atmaxarea_only_aligned TotalInt_BBsurround_traj_atmaxarea_only_aligned...
                MeanInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned TotalInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned MeanInt_atBBpos_1st_frame MeanInt_atBBpos_max_apical_area TotalInt_atBBpos_1st_frame TotalInt_atBBpos_max_apical_area MeanInt_atBBSurr_1st_frame MeanInt_atBBSurr_max_apical_area TotalInt_atBBSurr_1st_frame TotalInt_atBBSurr_max_apical_area MeanInt_ratio_BBSurPos_1st_frame MeanInt_ratio_BBSurPos_max_apical_area TotalInt_ratio_BBSurPos_1st_frame TotalInt_ratio_BBSurPos_max_apical_area

            load('workspace_with_t0_data.mat', 'frm_nmb_time_modified', 'Area_t0_BB', 'basalbody_count_original', 'basalbody_count_modified_rate', 'BB_flux');
            t0_time((1:length(frm_nmb_time_modified)), no_of_cells) = frm_nmb_time_modified;
            area_t0_bb((1:length(Area_t0_BB)), no_of_cells) = Area_t0_BB;
            NEW_BB_entry_count((1:length(basalbody_count_original)), no_of_cells) = basalbody_count_original;
            bbEntry_rate((1:length(basalbody_count_modified_rate)), no_of_cells) = basalbody_count_modified_rate;
            bbEntryFlux((1:length(BB_flux)), no_of_cells) = BB_flux;
            clear frm_nmb_time frm_nmb_time_modified Area_t0_BB basalbody_count_original basalbody_count_modified_rate BB_flux

            load('workspace_with_tend_data.mat', 'frm_nmb_time_modified', 'Area_tend_BB', 'basalbody_count_original', 'basalbody_count_modified_rate', 'BB_flux');
            Tend_time = frm_nmb_time_modified(1,(1:(end-1))); Area_Tend_bb = Area_tend_BB(1,(1:(end-1))); BasalBody_Count_Original = basalbody_count_original(1,(1:(end-1))); BBExit_rate = basalbody_count_modified_rate(1,(1:(end-1)));
            tend_time((1:length(Tend_time)), no_of_cells) = Tend_time;
            area_tend_bb((1:length(Area_Tend_bb)), no_of_cells) = Area_Tend_bb;
            NEW_BB_exit_count(1:length(BasalBody_Count_Original), no_of_cells) = BasalBody_Count_Original;
            bbExit_rate((1:length(BBExit_rate)), no_of_cells) = BBExit_rate;
            bbExitFlux((1:length(BB_flux)), no_of_cells) = BB_flux;
            clear frm_nmb_time frm_nmb_time_modified Area_tend_BB basalbody_count_original basalbody_count_modified_rate Tend_time Area_Tend_bb BBExit_rate BB_flux

            load('workspace_bb_mean_inter_distance_density.mat', 'bb_density_norm', 'mintd', 'local_clustering', 'global_clustering', 'area_for_plotting_clustering', 'time_for_plotting_clustering');
            BB_density_norm((1:length(bb_density_norm)), no_of_cells) = bb_density_norm;
            Mintd((1:length(mintd)), no_of_cells) = mintd;
            Local_Clustering((1:length(local_clustering)), no_of_cells) = local_clustering;
            Global_Clustering((1:length(global_clustering)), no_of_cells) = global_clustering;
            Area_Clustering((1:length(area_for_plotting_clustering)), no_of_cells) = area_for_plotting_clustering;
            Time_Clustering((1:length(time_for_plotting_clustering)), no_of_cells) = time_for_plotting_clustering;
            clear bb_density_norm mintd local_clustering global_clustering area_for_plotting_clustering time_for_plotting_clustering

            load('workspace_tessalations_all.mat', 'variance_voronoi_fin', 'variance_voronoi_fin_norm', 'time', 'Area_apicaldomain', 'No_of_BB');
            time_Variancetessalation_all((1:length(time)), no_of_cells) = time;
            Area_apicaldomain_Variancetessalation_all((1:length(Area_apicaldomain)), no_of_cells) = Area_apicaldomain;
            No_of_BB_Variancetessalation_all((1:length(No_of_BB)), no_of_cells) = No_of_BB;
            Variance_voronoi_fin_all((1:length(variance_voronoi_fin)), no_of_cells) = variance_voronoi_fin;
            Variance_voronoi_fin_norm_all((1:length(variance_voronoi_fin_norm)), no_of_cells) = variance_voronoi_fin_norm;
            clear variance_voronoi_fin_norm variance_voronoi_fin time Area_apicaldomain No_of_BB
            load('workspace_tessalations_without_border_cells', 'variance_voronoi_fin', 'variance_voronoi_fin_norm', 'time', 'Area_apicaldomain', 'No_of_BB');
            time_Variancetessalation_edge_removed((1:length(time)), no_of_cells) = time;
            Area_apicaldomain_Variancetessalation_edge_removed((1:length(Area_apicaldomain)), no_of_cells) = Area_apicaldomain;
            No_of_BB_Variancetessalation_edge_removed((1:length(No_of_BB)), no_of_cells) = No_of_BB;
            Variance_voronoi_fin_edge_removed((1:length(variance_voronoi_fin)), no_of_cells) = variance_voronoi_fin;
            Variance_voronoi_fin_norm_edge_removed((1:length(variance_voronoi_fin_norm)), no_of_cells) = variance_voronoi_fin_norm;
            clear variance_voronoi_fin_norm variance_voronoi_fin time Area_apicaldomain No_of_BB

            load('workspace_drift.mat', 'tm', 'Xmean', 'Ymean', 'drift_slope', 'no_of_durmax_points', 'Xp_save', 'Yp_save', 'time_dur_save', 'Nlrge', 'dl', 'dr', 'tortsty', 'dotp'); % for tortuosity, use 'tort' if outlier tortuosity needs to be removed, otherwise if you want to use all the values without filtering anything, use 'tortsty'. for more details, check the drift_mandar.m script
            Drift_time((1:length(tm)), no_of_cells) = tm;
            Drift_xmean((1:length(Xmean)), no_of_cells) = Xmean;
            Drift_ymean((1:length(Ymean)), no_of_cells) = Ymean;
            Drift_slope(1, no_of_cells) = drift_slope;
            No_of_Durmax_points(1, no_of_cells) = no_of_durmax_points;
            XP_Save((1:length(Xp_save)),no_of_cells) = Xp_save;
            YP_Save((1:length(Yp_save)),no_of_cells) = Yp_save;
            Time_Dur_Save((1:length(time_dur_save)),no_of_cells) = time_dur_save;
            nLrge(1, no_of_cells) = Nlrge;
            ContourLength{no_of_cells} = dl;
            EndToEndLength{no_of_cells} = dr;
            Tort{no_of_cells} = tortsty;
            Dotp{no_of_cells} = dotp;
            clear tm Xmean Ymean drift_slope no_of_durmax_points Xp_save Yp_save time_dur_save Nlrge dl dr tortsty dotp

            load('workspace_BB_distance_consequent_frames.mat', 'Time_interval', 'bbcoordinates_x', 'area_t0_bb_mod', 'No_of_BB_t0_mod', 'bb_density_t0', 'distn_in_micron', 'bb_dist_barplot', 'area_fraction', 'bb_in_area_fraction', 'linearised_New_BB_Distc_Full_micron', 'avg_new_new_bb_Mindist', 'avg_new_new_bb_Alldist');
            dist_in_micr = distn_in_micron(:); dummy_ones = ones(size(distn_in_micron)); [row, ~] = find(isnan(dist_in_micr)); % we linearise the 'distn_in_micron' matrix and get some other parameters so that the matrices of 'area_t0_bb_mod' & 'No_of_BB_t0_mod'  can be adjusted to the size of 'distn_in_micron'
            Distn_in_micron((1:length(dist_in_micr)), no_of_cells) = dist_in_micr;
            % adjusting the size of 'area_t0_bb_mod' matrix to match the 'distn_in_micron' matrix
            ar_t0_bb_1 = area_t0_bb_mod'; ar_t0_bb_2 = ar_t0_bb_1 .* dummy_ones;
            ar_t0_bb_2(row) = nan; ar_t0_bb_3 = ar_t0_bb_2(:);
            Area_t0_BB_mod((1:length(ar_t0_bb_3)), no_of_cells) = ar_t0_bb_3;
            % adjusting the size of 'No_of_BB_t0_mod' matrix to match the 'distn_in_micron' matrix
            no_t0_bb_1 = No_of_BB_t0_mod'; no_t0_bb_2 = no_t0_bb_1 .* dummy_ones;
            no_t0_bb_2(row) = nan; no_t0_bb_3 = no_t0_bb_2(:);
            no_of_bb_t0_mod((1:length(no_t0_bb_3)), no_of_cells) = no_t0_bb_3;
            % adjusting the size of 'bb_density_t0' matrix to match the 'distn_in_micron' matrix
            bb_density_t0_1 = bb_density_t0'; bb_density_t0_2 = bb_density_t0_1 .* dummy_ones;
            bb_density_t0_2(row) = nan; bb_density_t0_3 = bb_density_t0_2(:);
            bb_density_t0_mod((1:length(bb_density_t0_3)), no_of_cells) = bb_density_t0_3;
            % adjusting the size of 'bbcoordinates_x' matrix to match the 'distn_in_micron' matrix; 'bbcoordinates_x' contains the frame numbers of all newly appearing basal bodies
            bb_cord_x_0 = bbcoordinates_x(:,1) * Time_interval; bb_cord_x_1 = bb_cord_x_0 .* dummy_ones;
            bb_cord_x_1(row) = nan; bb_cord_x_2 = bb_cord_x_1(:);
            time_bb_appear_dist((1:length(bb_cord_x_2)), no_of_cells) = bb_cord_x_2;
            % fetching other parameters
            BB_dist_barplot((1:length(bb_dist_barplot)), no_of_cells) = bb_dist_barplot;
            Area_Fraction((1:length(area_fraction)), no_of_cells) = area_fraction;
            BB_in_Area_fraction((1:length(bb_in_area_fraction)), no_of_cells) = bb_in_area_fraction;
            new_BB_appearance_all_dist_time{no_of_cells} = linearised_New_BB_Distc_Full_micron(:,1) * Time_interval; % getting the times corresponding to all BB distances (between current frame and previous frame new BBs)
            new_BB_appearance_all_dist_area{no_of_cells} = linearised_New_BB_Distc_Full_micron(:,2); % getting the areas corresponding to all BB distances (between current frame and previous frame new BBs)
            new_BB_appearance_all_dist{no_of_cells} = linearised_New_BB_Distc_Full_micron(:,4); % getting all the BB distances (between current frame and previous frame new BBs)
            Avg_New_New_bb_mindist{no_of_cells} = avg_new_new_bb_Mindist; % getting the matrix related to the averaged (per frame) minimum distance between new BB in current frame to new BBs in the old frame; Here, col1 is time in min; col2 is area; col3 is no of new BBs; col4 is mean of min distances; col5 is std of min distances
            Avg_New_New_bb_alldist{no_of_cells} = avg_new_new_bb_Alldist; % getting the matrix related to the averaged (per frame) all distances between new BB in current frame to new BBs in the old frame; Here, col1 is time in min; col2 is area; col3 is no of new BBs; col4 is mean of all distances; col5 is std of all distances
            clear area_t0_bb_mod No_of_BB_t0_mod bb_density_t0 distn_in_micron dist_in_micr dummy_ones row ar_t0_bb_1 ar_t0_bb_2 ar_t0_bb_3 no_t0_bb_1 no_t0_bb_2 no_t0_bb_3 Time_interval bbcoordinates_x bb_cord_x_0 bb_cord_x_1 bb_cord_x_2 bb_dist_barplot area_fraction bb_in_area_fraction linearised_New_BB_Distc_Full_micron avg_new_new_bb_Mindist avg_new_new_bb_Alldist

            load('workspace_BB_distance_same_frame.mat', 'Time_interval', 'linearised_new_bb_appearance_distance_micron_ful_mat', 'linearised_Dist_Full_micron', 'linearised_neighbor_dist_micron_ful_mat', 'linearised_Distc_Full_micron', 'avg_new_Exist_bb_Mindist', 'avg_new_Exist_bb_Alldist', 'avg_Near_Neighbour_bb_Mindist', 'avg_Exist_bb_Alldist');
            new_vs_exist_bb_min_dist(1:length(linearised_new_bb_appearance_distance_micron_ful_mat(:,4)), no_of_cells) = linearised_new_bb_appearance_distance_micron_ful_mat(:,4); % getting minimal distance between new BB and already existing BBs in the current frame
            new_vs_exist_bb_min_dist_area(1:length(linearised_new_bb_appearance_distance_micron_ful_mat(:,2)), no_of_cells) = linearised_new_bb_appearance_distance_micron_ful_mat(:,2); % getting area
            new_vs_exist_bb_min_dist_frameno(1:length(linearised_new_bb_appearance_distance_micron_ful_mat(:,1)), no_of_cells) = linearised_new_bb_appearance_distance_micron_ful_mat(:,1); % getting frame numbers
            new_vs_exist_bb_min_dist_time = new_vs_exist_bb_min_dist_frameno * Time_interval; % converting frame numbers to min
            new_vs_exist_bb_min_dist_bbcount(1:length(linearised_new_bb_appearance_distance_micron_ful_mat(:,3)), no_of_cells) = linearised_new_bb_appearance_distance_micron_ful_mat(:,3); % getting BB count
            new_vs_exist_bb_all_dist_time(1:length(linearised_Dist_Full_micron(:,1)), no_of_cells) = linearised_Dist_Full_micron(:,1) * Time_interval; % getting the times for all distances between new BB and already existing BBs in the current frame
            new_vs_exist_bb_all_dist_area(1:length(linearised_Dist_Full_micron(:,2)), no_of_cells) = linearised_Dist_Full_micron(:,2); % getting the area for all distances between new BB and already existing BBs in the current frame
            new_vs_exist_bb_all_dist(1:length(linearised_Dist_Full_micron(:,4)), no_of_cells) = linearised_Dist_Full_micron(:,4); % getting all distances between new BB and already existing BBs in the current frame
            Avg_New_Exist_bb_mindist{no_of_cells} = avg_new_Exist_bb_Mindist; % getting the matrix related to the averaged (per frame) minimum distance between new BB in current frame to existing BBs in the current frame; Here, col1 is time in min; col2 is area; col3 is mean of min distances; col4 is std of min distances
            Avg_New_Exist_bb_alldist{no_of_cells} = avg_new_Exist_bb_Alldist; % getting the matrix related to the averaged (per frame) all distances between new BB in current frame to existing BBs in the current frame; Here, col1 is time in min; col2 is area; col3 is mean of all distances; col4 is std of all distances
            neighbor_bb_min_dist(1:length(linearised_neighbor_dist_micron_ful_mat(:,4)), no_of_cells) = linearised_neighbor_dist_micron_ful_mat(:,4); % getting nearest neighbor distance between existing BBs in the current frame
            neighbor_bb_min_dist_area(1:length(linearised_neighbor_dist_micron_ful_mat(:,2)), no_of_cells) = linearised_neighbor_dist_micron_ful_mat(:,2); % getting area
            neighbor_bb_min_dist_frameno(1:length(linearised_neighbor_dist_micron_ful_mat(:,1)), no_of_cells) = linearised_neighbor_dist_micron_ful_mat(:,1); % getting frame number
            neighbor_bb_min_dist_time = neighbor_bb_min_dist_frameno * Time_interval; % converting frame numbers to min
            neighbor_bb_min_dist_bbcount(1:length(linearised_neighbor_dist_micron_ful_mat(:,3)), no_of_cells) = linearised_neighbor_dist_micron_ful_mat(:,3); % getting BB count
            neighbor_bb_all_dist_time(1:length(linearised_Distc_Full_micron(:,1)), no_of_cells) = linearised_Distc_Full_micron(:,1) * Time_interval; % getting the times for all distances between existing BBs in the current frame
            neighbor_bb_all_dist_area(1:length(linearised_Distc_Full_micron(:,2)), no_of_cells) = linearised_Distc_Full_micron(:,2); % getting the area for all distances between existing BBs in the current frame
            neighbor_bb_all_dist(1:length(linearised_Distc_Full_micron(:,4)), no_of_cells) = linearised_Distc_Full_micron(:,4); % getting all distances between existing BBs in the current frame
            Avg_near_neighbour_bb_mindist{no_of_cells} = avg_Near_Neighbour_bb_Mindist; % getting the matrix related to the averaged (per frame) nearest neighbor distance between all the existing BBs in the current frame; Here, col1 is time in min; col2 is area; col3 is mean of min distances; col4 is std of min distances
            Avg_exist_bb_alldist{no_of_cells} = avg_Exist_bb_Alldist; % getting the matrix related to the averaged (per frame) all distances between all the existing BBs in the current frame; Here, col1 is time in min; col2 is area; col3 is mean of min distances; col4 is std of min distances
            clear Time_interval linearised_new_bb_appearance_distance_micron_ful_mat linearised_Dist_Full_micron linearised_neighbor_dist_micron_ful_mat linearised_Distc_Full_micron avg_new_Exist_bb_Mindist avg_new_Exist_bb_Alldist avg_Near_Neighbour_bb_Mindist avg_Exist_bb_Alldist

            load('workspace_BB_step_distance_speed.mat', 'distance_mod', 'speed_mod', 'x_distance_mod', 'y_distance_mod', 'x_y_distance_mod');
            step_dist_mod{no_of_cells} = distance_mod;
            inst_speed_mod{no_of_cells} = speed_mod;
            step_x_dist_mod{no_of_cells} = x_distance_mod;
            step_y_dist_mod{no_of_cells} = y_distance_mod;
            step_x_y_dist_mod{no_of_cells} = x_y_distance_mod;
            clear distance_mod speed_mod x_distance_mod y_distance_mod x_y_distance_mod

            if exist('workspace_dist_early_late_expansion_150um2.mat', 'file') % works only for control data and not for alphaActininMO since this analysis is not done for alphaActininMO
                load('workspace_dist_early_late_expansion_150um2.mat', 'contourDist_actualAreaVal_areapercent_all_norm', 'EndToEndDist_actualAreaVal_areapercent_all_norm', 'tortuosity_early_expansion_AreaVal', 'tortuosity_late_expansion_AreaVal', 'tortuosity_25_PercentArea', 'tortuosity_50_PercentArea', 'tortuosity_75_PercentArea', 'tortuosity_100_PercentArea');
                contour_dist_1to150um2(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,1);
                contour_dist_150um2_finalarea(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,2);
                contour_dist_25pct(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,3);
                contour_dist_50pct(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,4);
                contour_dist_75pct(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,5);
                contour_dist_100pct(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,6);
                endtoend_dist_1to150um2(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,1);
                endtoend_dist_150um2_finalarea(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,2);
                endtoend_dist_25pct(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,3);
                endtoend_dist_50pct(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,4);
                endtoend_dist_75pct(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,5);
                endtoend_dist_100pct(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,6);
                Tortuosity_Earlyexpansion = tortuosity_early_expansion_AreaVal; Tortuosity_Lateexpansion = tortuosity_late_expansion_AreaVal; Tortuosity_25PercentArea = tortuosity_25_PercentArea;
                Tortuosity_50PercentArea = tortuosity_50_PercentArea; Tortuosity_75PercentArea = tortuosity_75_PercentArea; Tortuosity_100PercentArea = tortuosity_100_PercentArea;
                clear contourDist_actualAreaVal_areapercent_all_norm EndToEndDist_actualAreaVal_areapercent_all_norm tortuosity_early_expansion_AreaVal tortuosity_late_expansion_AreaVal tortuosity_25_PercentArea tortuosity_50_PercentArea tortuosity_75_PercentArea tortuosity_100_PercentArea
            end

            load('workspace_msd_coarsegrained.mat', 'xaxis', 'xaxis_min', 'yaxis', 'avg_Diff_strength_fit', 'trajectories_mod', 'no_of_trajectories', 'longestTrajectory');
            MSD_xaxis((1:length(xaxis)), no_of_cells) = xaxis;
            MSD_xaxis_min((1:length(xaxis_min)), no_of_cells) = xaxis_min;
            Length_xaxis(1, no_of_cells) = no_of_cells;
            Length_xaxis(2, no_of_cells) = length(xaxis);
            MSD_yaxis((1:length(yaxis)), no_of_cells) = yaxis;
            Avg_Diff_strength_fit(1, no_of_cells) = avg_Diff_strength_fit;
            msd_traj((1:length(trajectories_mod)), no_of_cells) = trajectories_mod;
            No_of_Trajectories(1, no_of_cells) = no_of_trajectories;
            Longesttrajectory(1, no_of_cells) = longestTrajectory;
            clear xaxis xaxis_min yaxis avg_Diff_strength_fit trajectories_mod no_of_trajectories longestTrajectory

            load('workspace_bb_density_distribution_expansion_bias.mat', 'quadrant_areas_at_max_apical_area_norm', 'quadrant_BB_count_at_max_apical_area_norm', 'whole_quadrant_area_rates_at_max_apical_area_norm', 'quad_BB_density_at_max_apical_area_norm', 'quad_actinMeanIntnorm_at_max_apical_area', 'quad_actinTotalIntnorm_at_max_apical_area', 'quadrant_total_NewBB_count_norm',...
                'half_areas_at_max_apical_area_norm', 'half_BB_count_at_max_apical_area_norm', 'whole_half_area_rates_at_max_apical_area_norm', 'half_BB_density_at_max_apical_area_norm', 'half_actinMeanIntnorm_at_max_apical_area', 'half_actinTotalIntnorm_at_max_apical_area', 'half_total_NewBB_count_norm',...
                'quadrant_area_reordered', 'quadrant_BBs_reordered', 'quad_area_rate_reordered', 'quadrant_bb_density_for_plot_reordered', 'quad_halves_meanint_norm_reordered', 'quad_halves_totalint_norm_reordered', 'quadrant_new_BBs_reordered',...
                'quadrant_area_reordered_norm', 'quadrant_BBs_reordered_norm', 'quad_area_rate_reordered_norm', 'quadrant_bb_density_for_plot_reordered_norm', 'quadrant_new_BBs_reordered_norm',...
                'clumpingfactor_area', 'clumpingfactor_area_max_apical_area', 'clumpingfactor_arearate', 'clumpingfactor_arearate_max_apical_area', 'clumpingfactor_bbcount', 'clumpingfactor_bbcount_max_apical_area', 'clumpingfactor_bbddensity', 'clumpingfactor_bbddensity_max_apical_area', 'clumpingfactor_meanint', 'clumpingfactor_meanint_max_apical_area', 'clumpingfactor_totalint', 'clumpingfactor_totalint_max_apical_area', 'clumpingfactor_newBBcount', 'clumpingfactor_newBBcount_max_apical_area');
            Quad_Area{1, no_of_cells} = quadrant_area_reordered; Quad_BBcount{1, no_of_cells} = quadrant_BBs_reordered; Quad_arearate{1, no_of_cells} = quad_area_rate_reordered; Quad_bbdensity{1, no_of_cells} = quadrant_bb_density_for_plot_reordered; Quad_newBBs{1, no_of_cells} = quadrant_new_BBs_reordered;
            Quad_Area_norm{1, no_of_cells} = quadrant_area_reordered_norm; Quad_BBcount_norm{1, no_of_cells} = quadrant_BBs_reordered_norm; Quad_arearate_norm{1, no_of_cells} = quad_area_rate_reordered_norm; Quad_bbdensity_norm{1, no_of_cells} = quadrant_bb_density_for_plot_reordered_norm; Quad_meanIntnorm{1, no_of_cells} = quad_halves_meanint_norm_reordered; Quad_totalIntnorm{1, no_of_cells} = quad_halves_totalint_norm_reordered; Quad_newBBs_norm{1, no_of_cells} = quadrant_new_BBs_reordered_norm;
            ClumpingFactor_Area(1:length(clumpingfactor_area), no_of_cells) = clumpingfactor_area; ClumpingFactor_Area_max_apical_area(1, no_of_cells) = clumpingfactor_area_max_apical_area; ClumpingFactor_AreaRate(1:length(clumpingfactor_arearate), no_of_cells) = clumpingfactor_arearate; ClumpingFactor_AreaRate_max_apical_area(1, no_of_cells) = clumpingfactor_arearate_max_apical_area; ClumpingFactor_BBCount(1:length(clumpingfactor_bbcount), no_of_cells) = clumpingfactor_bbcount; ClumpingFactor_BBCount_max_apical_area(1, no_of_cells) = clumpingfactor_bbcount_max_apical_area;
            ClumpingFactor_BBDensity(1:length(clumpingfactor_bbddensity), no_of_cells) = clumpingfactor_bbddensity; ClumpingFactor_BBDensity_max_apical_area(1, no_of_cells) = clumpingfactor_bbddensity_max_apical_area; ClumpingFactor_MeanInt(1:length(clumpingfactor_meanint), no_of_cells) = clumpingfactor_meanint; ClumpingFactor_MeanInt_max_apical_area(1, no_of_cells) = clumpingfactor_meanint_max_apical_area; ClumpingFactor_TotalInt(1:length(clumpingfactor_totalint), no_of_cells) = clumpingfactor_totalint; ClumpingFactor_TotalInt_max_apical_area(1, no_of_cells) = clumpingfactor_totalint_max_apical_area;
            ClumpingFactor_NewBBCount(1:length(clumpingfactor_newBBcount), no_of_cells) = clumpingfactor_newBBcount; ClumpingFactor_NewBBCount_max_apical_area(1, no_of_cells) = clumpingfactor_newBBcount_max_apical_area;
            Quad_Area_max_apical_area_norm(no_of_cells, 1:4) = quadrant_areas_at_max_apical_area_norm; Quad_BBcount_max_apical_area_norm(no_of_cells, 1:4) = quadrant_BB_count_at_max_apical_area_norm; Quad_arearate_max_apical_area_norm(no_of_cells, 1:4) = whole_quadrant_area_rates_at_max_apical_area_norm; Quad_BBdensity_at_max_apical_area_norm(no_of_cells, 1:4) = quad_BB_density_at_max_apical_area_norm;
            Quad_actinMeanIntnorm_at_max_apical_area(no_of_cells, 1:4) = quad_actinMeanIntnorm_at_max_apical_area; Quad_actinTotalIntnorm_at_max_apical_area(no_of_cells, 1:4) = quad_actinTotalIntnorm_at_max_apical_area; Quad_NewBB_cumulative_count(no_of_cells, 1:4) = quadrant_total_NewBB_count_norm;
            Half_areas_at_max_apical_area_norm(no_of_cells, 1:4) = half_areas_at_max_apical_area_norm; Half_BB_count_at_max_apical_area_norm(no_of_cells, 1:4) = half_BB_count_at_max_apical_area_norm; Half_area_rates_at_max_apical_area_norm(no_of_cells, 1:4) = whole_half_area_rates_at_max_apical_area_norm; Half_BB_density_at_max_apical_area_norm(no_of_cells, 1:4) = half_BB_density_at_max_apical_area_norm;
            Half_actinMeanIntnorm_at_max_apical_area(no_of_cells, 1:4) = half_actinMeanIntnorm_at_max_apical_area; Half_actinTotalIntnorm_at_max_apical_area(no_of_cells, 1:4) = half_actinTotalIntnorm_at_max_apical_area; Half_NewBB_cumulative_count(no_of_cells, 1:4) = half_total_NewBB_count_norm;
            clear quadrant_areas_at_max_apical_area_norm quadrant_BB_count_at_max_apical_area_norm whole_quadrant_area_rates_at_max_apical_area_norm quad_BB_density_at_max_apical_area_norm quad_actinMeanIntnorm_at_max_apical_area quad_actinTotalIntnorm_at_max_apical_area quadrant_total_NewBB_count_norm quadrant_area_reordered quadrant_BBs_reordered quad_area_rate_reordered quadrant_bb_density_for_plot_reordered quad_halves_meanint_norm_reordered quad_halves_totalint_norm_reordered ...
                quadrant_new_BBs_reordered quadrant_area_reordered_norm quadrant_BBs_reordered_norm quad_area_rate_reordered_norm quadrant_bb_density_for_plot_reordered_norm quadrant_new_BBs_reordered_norm clumpingfactor_area clumpingfactor_area_max_apical_area clumpingfactor_arearate clumpingfactor_arearate_max_apical_area clumpingfactor_bbcount clumpingfactor_bbcount_max_apical_area clumpingfactor_bbddensity clumpingfactor_bbddensity_max_apical_area clumpingfactor_meanint clumpingfactor_meanint_max_apical_area clumpingfactor_totalint clumpingfactor_totalint_max_apical_area clumpingfactor_newBBcount clumpingfactor_newBBcount_max_apical_area...
                half_areas_at_max_apical_area_norm half_BB_count_at_max_apical_area_norm whole_half_area_rates_at_max_apical_area_norm half_BB_density_at_max_apical_area_norm half_actinMeanIntnorm_at_max_apical_area half_actinTotalIntnorm_at_max_apical_area half_total_NewBB_count_norm

            name{1, no_of_cells} = subfolders_1{i};
            % ============loading all the required parameters from different cells============%
            % ================================================================================%
        end
    else
        subfolder_list_2 = dir(subfolders_2_link);
        subfolders_2 = {subfolder_list_2([subfolder_list_2.isdir]).name};
        subfolders_2 = subfolders_2(~ismember(subfolders_2,{'.', '..'}));
        no_of_subfolders_2 = length(subfolders_2);
        for j = 1:no_of_subfolders_2
            subfolders_3_link =[subfolders_2_link, '\', subfolders_2{j}];
            cd(subfolders_3_link);
            if exist('analy', 'dir')
                analy_check =[subfolders_3_link, '\', 'analy'];
                cd(analy_check);
                if exist('Plots_matlab_script', 'dir')
                    file_link_1 = [analy_check, '\', 'Plots_matlab_script\'];
                    cd(file_link_1);
                    % ================================================================================%
                    % ============loading all the required parameters from different cells============%
                    no_of_cells = no_of_cells + 1;

                    load('workspace_interim.mat', 'Timelist', 'Area_apicaldomain', 'Area_apicaldomain_percent', 'residual_area', 'residual_area_percent', 'bb_area', 'bb_area_percent', 'sum_of_residual_bb_areas', 'No_of_BB', 'MeanIntensity_apicaldomain', 'TotalIntensity_apicaldomain', 'area_rate', 'norm_area_rate', 'whole_area_rate', 'aspect_ratio', 'Circularity_apicaldomain',...
                        'MeanInt_BBposition_traj_atmaxarea_only', 'TotalInt_BBposition_traj_atmaxarea_only', 'MeanInt_BBsurround_traj_atmaxarea_only', 'TotalInt_BBsurround_traj_atmaxarea_only', 'MeanInt_BB_SurPos_ratio_traj_atmaxarea_only', 'TotalInt_BB_SurPos_ratio_traj_atmaxarea_only', 'MeanInt_BBposition_traj_atmaxarea_only_aligned', 'TotalInt_BBposition_traj_atmaxarea_only_aligned',...
                        'MeanInt_BBsurround_traj_atmaxarea_only_aligned', 'TotalInt_BBsurround_traj_atmaxarea_only_aligned', 'MeanInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned', 'TotalInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned', 'Timelist_clone_traj_atmaxarea_only', 'Area_apicaldomain_clone_traj_atmaxarea_only', 'MeanInt_atBBpos_1st_frame',...
                        'MeanInt_atBBpos_max_apical_area', 'TotalInt_atBBpos_1st_frame', 'TotalInt_atBBpos_max_apical_area', 'MeanInt_atBBSurr_1st_frame', 'MeanInt_atBBSurr_max_apical_area', 'TotalInt_atBBSurr_1st_frame', 'TotalInt_atBBSurr_max_apical_area', 'MeanInt_ratio_BBSurPos_1st_frame', 'MeanInt_ratio_BBSurPos_max_apical_area', 'TotalInt_ratio_BBSurPos_1st_frame', 'TotalInt_ratio_BBSurPos_max_apical_area');
                    timelist((1:length(Timelist)),no_of_cells) = Timelist;
                    area_apicaldomain((1:length(Area_apicaldomain)), no_of_cells) = Area_apicaldomain;
                    area_apicaldomain_percent((1:length(Area_apicaldomain_percent)), no_of_cells) = Area_apicaldomain_percent;
                    no_of_bb((1:length(No_of_BB)), no_of_cells) = No_of_BB;
                    Residual_Area((1:length(residual_area)), no_of_cells) = residual_area;
                    Residual_Area_percent((1:length(residual_area_percent)), no_of_cells) = residual_area_percent;
                    BB_area((1:length(bb_area)), no_of_cells) = bb_area;
                    BB_area_percent((1:length(bb_area_percent)), no_of_cells) = bb_area_percent;
                    Sum_of_Residual_bb_areas_percent((1:length(sum_of_residual_bb_areas)), no_of_cells) = sum_of_residual_bb_areas;
                    meanintensity_apicaldomain((1:length(MeanIntensity_apicaldomain)), no_of_cells) = MeanIntensity_apicaldomain;
                    totalintensity_apicaldomain((1:length(TotalIntensity_apicaldomain)), no_of_cells) = TotalIntensity_apicaldomain;
                    Area_rate((1:length(area_rate)), no_of_cells) = area_rate;
                    Norm_Area_rate((1:length(norm_area_rate)), no_of_cells) = norm_area_rate;
                    Whole_area_rate(1, no_of_cells) = whole_area_rate;
                    isotropicity((1:length(aspect_ratio)), no_of_cells) = aspect_ratio;
                    circularity((1:length(Circularity_apicaldomain)), no_of_cells) = Circularity_apicaldomain;
                    meanint_atBBpos_Traj_atMaxArea_Only{no_of_cells} = MeanInt_BBposition_traj_atmaxarea_only(:);
                    totalint_atBBpos_Traj_atMaxArea_Only{no_of_cells} = TotalInt_BBposition_traj_atmaxarea_only(:);
                    meanint_atBBSurr_Traj_atMaxArea_Only{no_of_cells} = MeanInt_BBsurround_traj_atmaxarea_only(:);
                    totalint_atBBSurr_Traj_atMaxArea_Only{no_of_cells} = TotalInt_BBsurround_traj_atmaxarea_only(:);
                    meanint_BB_SurPos_ratio_Traj_atMaxArea_Only{no_of_cells} = MeanInt_BB_SurPos_ratio_traj_atmaxarea_only(:);
                    totalint_BB_SurPos_ratio_Traj_atMaxArea_Only{no_of_cells} = TotalInt_BB_SurPos_ratio_traj_atmaxarea_only(:);
                    meanint_BBpos_Traj_atMaxArea_Only_Aligned{no_of_cells} = MeanInt_BBposition_traj_atmaxarea_only_aligned(:);
                    totalint_BBpos_Traj_atMaxArea_Only_Aligned{no_of_cells} = TotalInt_BBposition_traj_atmaxarea_only_aligned(:);
                    meanint_BBSurr_Traj_atMaxArea_Only_Aligned{no_of_cells} = MeanInt_BBsurround_traj_atmaxarea_only_aligned(:);
                    totalint_BBSurr_Traj_atMaxArea_Only_Aligned{no_of_cells} = TotalInt_BBsurround_traj_atmaxarea_only_aligned(:);
                    meanint_BB_SurPos_ratio_Traj_atMaxArea_Only_Aligned{no_of_cells} = MeanInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned(:);
                    totalint_BB_SurPos_ratio_Traj_atMaxArea_Only_Aligned{no_of_cells} = TotalInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned(:);
                    Timelist_clone_Traj_atMaxArea_Only{no_of_cells} = Timelist_clone_traj_atmaxarea_only(:);
                    Area_apicaldomain_clone_Traj_atMaxArea_Only{no_of_cells} = Area_apicaldomain_clone_traj_atmaxarea_only(:);
                    meanint_atBBpos_1stframe(1:length(MeanInt_atBBpos_1st_frame), no_of_cells) = MeanInt_atBBpos_1st_frame;
                    meanint_atBBpos_maxapicalarea(1:length(MeanInt_atBBpos_max_apical_area), no_of_cells) = MeanInt_atBBpos_max_apical_area;
                    totalint_atBBpos_1stframe(1:length(TotalInt_atBBpos_1st_frame), no_of_cells) = TotalInt_atBBpos_1st_frame;
                    totalint_atBBpos_maxapicalarea(1:length(TotalInt_atBBpos_max_apical_area), no_of_cells) = TotalInt_atBBpos_max_apical_area;
                    meanint_atBBSurr_1stframe(1:length(MeanInt_atBBSurr_1st_frame), no_of_cells) = MeanInt_atBBSurr_1st_frame;
                    meanint_atBBSurr_maxapicalarea(1:length(MeanInt_atBBSurr_max_apical_area), no_of_cells) = MeanInt_atBBSurr_max_apical_area;
                    totalint_atBBSurr_1stframe(1:length(TotalInt_atBBSurr_1st_frame), no_of_cells) = TotalInt_atBBSurr_1st_frame;
                    totalint_atBBSurr_maxapicalarea(1:length(TotalInt_atBBSurr_max_apical_area), no_of_cells) = TotalInt_atBBSurr_max_apical_area;
                    meanint_ratio_BBSurPos_1stframe(1:length(MeanInt_ratio_BBSurPos_1st_frame), no_of_cells) = MeanInt_ratio_BBSurPos_1st_frame;
                    meanint_ratio_BBSurPos_maxapicalarea(1:length(MeanInt_ratio_BBSurPos_max_apical_area), no_of_cells) = MeanInt_ratio_BBSurPos_max_apical_area;
                    totalint_ratio_BBSurPos_1stframe(1:length(TotalInt_ratio_BBSurPos_1st_frame), no_of_cells) = TotalInt_ratio_BBSurPos_1st_frame;
                    totalint_ratio_BBSurPos_maxapicalarea(1:length(TotalInt_ratio_BBSurPos_max_apical_area), no_of_cells) = TotalInt_ratio_BBSurPos_max_apical_area;
                    clear Timelist Area_apicaldomain Area_apicaldomain_percent residual_area residual_area_percent bb_area bb_area_percent sum_of_residual_bb_areas No_of_BB MeanIntensity_apicaldomain TotalIntensity_apicaldomain area_rate norm_area_rate whole_area_rate aspect_ratio Circularity_apicaldomain...
                        MeanInt_BBposition_traj_atmaxarea_only TotalInt_BBposition_traj_atmaxarea_only MeanInt_BBsurround_traj_atmaxarea_only TotalInt_BBsurround_traj_atmaxarea_only MeanInt_BB_SurPos_ratio_traj_atmaxarea_only TotalInt_BB_SurPos_ratio_traj_atmaxarea_only Timelist_clone_traj_atmaxarea_only Area_apicaldomain_clone_traj_atmaxarea_only MeanInt_BBposition_traj_atmaxarea_only_aligned TotalInt_BBposition_traj_atmaxarea_only_aligned MeanInt_BBsurround_traj_atmaxarea_only_aligned TotalInt_BBsurround_traj_atmaxarea_only_aligned...
                        MeanInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned TotalInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned MeanInt_atBBpos_1st_frame MeanInt_atBBpos_max_apical_area TotalInt_atBBpos_1st_frame TotalInt_atBBpos_max_apical_area MeanInt_atBBSurr_1st_frame MeanInt_atBBSurr_max_apical_area TotalInt_atBBSurr_1st_frame TotalInt_atBBSurr_max_apical_area MeanInt_ratio_BBSurPos_1st_frame MeanInt_ratio_BBSurPos_max_apical_area TotalInt_ratio_BBSurPos_1st_frame TotalInt_ratio_BBSurPos_max_apical_area

                    load('workspace_with_t0_data.mat', 'frm_nmb_time_modified', 'Area_t0_BB', 'basalbody_count_original', 'basalbody_count_modified_rate', 'BB_flux');
                    t0_time((1:length(frm_nmb_time_modified)), no_of_cells) = frm_nmb_time_modified;
                    area_t0_bb((1:length(Area_t0_BB)), no_of_cells) = Area_t0_BB;
                    NEW_BB_entry_count((1:length(basalbody_count_original)), no_of_cells) = basalbody_count_original;
                    bbEntry_rate((1:length(basalbody_count_modified_rate)), no_of_cells) = basalbody_count_modified_rate;
                    bbEntryFlux((1:length(BB_flux)), no_of_cells) = BB_flux;
                    clear frm_nmb_time frm_nmb_time_modified Area_t0_BB basalbody_count_original basalbody_count_modified_rate BB_flux

                    load('workspace_with_tend_data.mat', 'frm_nmb_time_modified', 'Area_tend_BB', 'basalbody_count_original', 'basalbody_count_modified_rate', 'BB_flux');
                    Tend_time = frm_nmb_time_modified(1,(1:(end-1))); Area_Tend_bb = Area_tend_BB(1,(1:(end-1))); BasalBody_Count_Original = basalbody_count_original(1,(1:(end-1))); BBExit_rate = basalbody_count_modified_rate(1,(1:(end-1)));
                    tend_time((1:length(Tend_time)), no_of_cells) = Tend_time;
                    area_tend_bb((1:length(Area_Tend_bb)), no_of_cells) = Area_Tend_bb;
                    NEW_BB_exit_count(1:length(BasalBody_Count_Original), no_of_cells) = BasalBody_Count_Original;
                    bbExit_rate((1:length(BBExit_rate)), no_of_cells) = BBExit_rate;
                    bbExitFlux((1:length(BB_flux)), no_of_cells) = BB_flux;
                    clear frm_nmb_time frm_nmb_time_modified Area_tend_BB basalbody_count_original basalbody_count_modified_rate Tend_time Area_Tend_bb BBExit_rate BB_flux

                    load('workspace_bb_mean_inter_distance_density.mat', 'bb_density_norm', 'mintd', 'local_clustering', 'global_clustering', 'area_for_plotting_clustering', 'time_for_plotting_clustering');
                    BB_density_norm((1:length(bb_density_norm)), no_of_cells) = bb_density_norm;
                    Mintd((1:length(mintd)), no_of_cells) = mintd;
                    Local_Clustering((1:length(local_clustering)), no_of_cells) = local_clustering;
                    Global_Clustering((1:length(global_clustering)), no_of_cells) = global_clustering;
                    Area_Clustering((1:length(area_for_plotting_clustering)), no_of_cells) = area_for_plotting_clustering;
                    Time_Clustering((1:length(time_for_plotting_clustering)), no_of_cells) = time_for_plotting_clustering;
                    clear bb_density_norm mintd local_clustering global_clustering area_for_plotting_clustering time_for_plotting_clustering

                    load('workspace_tessalations_all.mat', 'variance_voronoi_fin', 'variance_voronoi_fin_norm', 'time', 'Area_apicaldomain', 'No_of_BB');
                    time_Variancetessalation_all((1:length(time)), no_of_cells) = time;
                    Area_apicaldomain_Variancetessalation_all((1:length(Area_apicaldomain)), no_of_cells) = Area_apicaldomain;
                    No_of_BB_Variancetessalation_all((1:length(No_of_BB)), no_of_cells) = No_of_BB;
                    Variance_voronoi_fin_all((1:length(variance_voronoi_fin)), no_of_cells) = variance_voronoi_fin;
                    Variance_voronoi_fin_norm_all((1:length(variance_voronoi_fin_norm)), no_of_cells) = variance_voronoi_fin_norm;
                    clear variance_voronoi_fin_norm variance_voronoi_fin time Area_apicaldomain No_of_BB
                    load('workspace_tessalations_without_border_cells', 'variance_voronoi_fin', 'variance_voronoi_fin_norm', 'time', 'Area_apicaldomain', 'No_of_BB');
                    time_Variancetessalation_edge_removed((1:length(time)), no_of_cells) = time;
                    Area_apicaldomain_Variancetessalation_edge_removed((1:length(Area_apicaldomain)), no_of_cells) = Area_apicaldomain;
                    No_of_BB_Variancetessalation_edge_removed((1:length(No_of_BB)), no_of_cells) = No_of_BB;
                    Variance_voronoi_fin_edge_removed((1:length(variance_voronoi_fin)), no_of_cells) = variance_voronoi_fin;
                    Variance_voronoi_fin_norm_edge_removed((1:length(variance_voronoi_fin_norm)), no_of_cells) = variance_voronoi_fin_norm;
                    clear variance_voronoi_fin_norm variance_voronoi_fin time Area_apicaldomain No_of_BB

                    load('workspace_drift.mat', 'tm', 'Xmean', 'Ymean', 'drift_slope', 'no_of_durmax_points', 'Xp_save', 'Yp_save', 'time_dur_save', 'Nlrge', 'dl', 'dr', 'tortsty', 'dotp'); % for tortuosity, use 'tort' if outlier tortuosity needs to be removed, otherwise if you want to use all the values without filtering anything, use 'tortsty'. for more details, check the drift_mandar.m script
                    Drift_time((1:length(tm)), no_of_cells) = tm;
                    Drift_xmean((1:length(Xmean)), no_of_cells) = Xmean;
                    Drift_ymean((1:length(Ymean)), no_of_cells) = Ymean;
                    Drift_slope(1, no_of_cells) = drift_slope;
                    No_of_Durmax_points(1, no_of_cells) = no_of_durmax_points;
                    XP_Save((1:length(Xp_save)),no_of_cells) = Xp_save;
                    YP_Save((1:length(Yp_save)),no_of_cells) = Yp_save;
                    Time_Dur_Save((1:length(time_dur_save)),no_of_cells) = time_dur_save;
                    nLrge(1, no_of_cells) = Nlrge;
                    ContourLength{no_of_cells} = dl;
                    EndToEndLength{no_of_cells} = dr;
                    Tort{no_of_cells} = tortsty;
                    Dotp{no_of_cells} = dotp;
                    clear tm Xmean Ymean drift_slope no_of_durmax_points Xp_save Yp_save time_dur_save Nlrge dl dr tortsty dotp

                    load('workspace_BB_distance_consequent_frames.mat', 'Time_interval', 'bbcoordinates_x', 'area_t0_bb_mod', 'No_of_BB_t0_mod', 'bb_density_t0', 'distn_in_micron', 'bb_dist_barplot', 'area_fraction', 'bb_in_area_fraction', 'linearised_New_BB_Distc_Full_micron', 'avg_new_new_bb_Mindist', 'avg_new_new_bb_Alldist');
                    dist_in_micr = distn_in_micron(:); dummy_ones = ones(size(distn_in_micron)); [row, ~] = find(isnan(dist_in_micr)); % we linearise the 'distn_in_micron' matrix and get some other parameters so that the matrices of 'area_t0_bb_mod' & 'No_of_BB_t0_mod'  can be adjusted to the size of 'distn_in_micron'
                    Distn_in_micron((1:length(dist_in_micr)), no_of_cells) = dist_in_micr;
                    % adjusting the size of 'area_t0_bb_mod' matrix to match the 'distn_in_micron' matrix
                    ar_t0_bb_1 = area_t0_bb_mod'; ar_t0_bb_2 = ar_t0_bb_1 .* dummy_ones;
                    ar_t0_bb_2(row) = nan; ar_t0_bb_3 = ar_t0_bb_2(:);
                    Area_t0_BB_mod((1:length(ar_t0_bb_3)), no_of_cells) = ar_t0_bb_3;
                    % adjusting the size of 'No_of_BB_t0_mod' matrix to match the 'distn_in_micron' matrix
                    no_t0_bb_1 = No_of_BB_t0_mod'; no_t0_bb_2 = no_t0_bb_1 .* dummy_ones;
                    no_t0_bb_2(row) = nan; no_t0_bb_3 = no_t0_bb_2(:);
                    no_of_bb_t0_mod((1:length(no_t0_bb_3)), no_of_cells) = no_t0_bb_3;
                    % adjusting the size of 'bb_density_t0' matrix to match the 'distn_in_micron' matrix
                    bb_density_t0_1 = bb_density_t0'; bb_density_t0_2 = bb_density_t0_1 .* dummy_ones;
                    bb_density_t0_2(row) = nan; bb_density_t0_3 = bb_density_t0_2(:);
                    bb_density_t0_mod((1:length(bb_density_t0_3)), no_of_cells) = bb_density_t0_3;
                    % adjusting the size of 'bbcoordinates_x' matrix to match the 'distn_in_micron' matrix; 'bbcoordinates_x' contains the frame numbers of all newly appearing basal bodies
                    bb_cord_x_0 = bbcoordinates_x(:,1) * Time_interval; bb_cord_x_1 = bb_cord_x_0 .* dummy_ones;
                    bb_cord_x_1(row) = nan; bb_cord_x_2 = bb_cord_x_1(:);
                    time_bb_appear_dist((1:length(bb_cord_x_2)), no_of_cells) = bb_cord_x_2;
                    % fetching other parameters
                    BB_dist_barplot((1:length(bb_dist_barplot)), no_of_cells) = bb_dist_barplot;
                    Area_Fraction((1:length(area_fraction)), no_of_cells) = area_fraction;
                    BB_in_Area_fraction((1:length(bb_in_area_fraction)), no_of_cells) = bb_in_area_fraction;
                    new_BB_appearance_all_dist_time{no_of_cells} = linearised_New_BB_Distc_Full_micron(:,1) * Time_interval; % getting the times corresponding to all BB distances (between current frame and previous frame new BBs)
                    new_BB_appearance_all_dist_area{no_of_cells} = linearised_New_BB_Distc_Full_micron(:,2); % getting the areas corresponding to all BB distances (between current frame and previous frame new BBs)
                    new_BB_appearance_all_dist{no_of_cells} = linearised_New_BB_Distc_Full_micron(:,4); % getting all the BB distances (between current frame and previous frame new BBs)
                    Avg_New_New_bb_mindist{no_of_cells} = avg_new_new_bb_Mindist; % getting the matrix related to the averaged (per frame) minimum distance between new BB in current frame to new BBs in the old frame; Here, col1 is time in min; col2 is area; col3 is no of new BBs; col4 is mean of min distances; col5 is std of min distances
                    Avg_New_New_bb_alldist{no_of_cells} = avg_new_new_bb_Alldist; % getting the matrix related to the averaged (per frame) all distances between new BB in current frame to new BBs in the old frame; Here, col1 is time in min; col2 is area; col3 is no of new BBs; col4 is mean of all distances; col5 is std of all distances
                    clear area_t0_bb_mod No_of_BB_t0_mod bb_density_t0 distn_in_micron dist_in_micr dummy_ones row ar_t0_bb_1 ar_t0_bb_2 ar_t0_bb_3 no_t0_bb_1 no_t0_bb_2 no_t0_bb_3 Time_interval bbcoordinates_x bb_cord_x_0 bb_cord_x_1 bb_cord_x_2 bb_dist_barplot area_fraction bb_in_area_fraction linearised_New_BB_Distc_Full_micron avg_new_new_bb_Mindist avg_new_new_bb_Alldist

                    load('workspace_BB_distance_same_frame.mat', 'Time_interval', 'linearised_new_bb_appearance_distance_micron_ful_mat', 'linearised_Dist_Full_micron', 'linearised_neighbor_dist_micron_ful_mat', 'linearised_Distc_Full_micron', 'avg_new_Exist_bb_Mindist', 'avg_new_Exist_bb_Alldist', 'avg_Near_Neighbour_bb_Mindist', 'avg_Exist_bb_Alldist');
                    new_vs_exist_bb_min_dist(1:length(linearised_new_bb_appearance_distance_micron_ful_mat(:,4)), no_of_cells) = linearised_new_bb_appearance_distance_micron_ful_mat(:,4); % getting minimal distance between new BB and already existing BBs in the current frame
                    new_vs_exist_bb_min_dist_area(1:length(linearised_new_bb_appearance_distance_micron_ful_mat(:,2)), no_of_cells) = linearised_new_bb_appearance_distance_micron_ful_mat(:,2); % getting area
                    new_vs_exist_bb_min_dist_frameno(1:length(linearised_new_bb_appearance_distance_micron_ful_mat(:,1)), no_of_cells) = linearised_new_bb_appearance_distance_micron_ful_mat(:,1); % getting frame numbers
                    new_vs_exist_bb_min_dist_time = new_vs_exist_bb_min_dist_frameno * Time_interval; % converting frame numbers to min
                    new_vs_exist_bb_min_dist_bbcount(1:length(linearised_new_bb_appearance_distance_micron_ful_mat(:,3)), no_of_cells) = linearised_new_bb_appearance_distance_micron_ful_mat(:,3); % getting BB count
                    new_vs_exist_bb_all_dist_time(1:length(linearised_Dist_Full_micron(:,1)), no_of_cells) = linearised_Dist_Full_micron(:,1) * Time_interval; % getting the times for all distances between new BB and already existing BBs in the current frame
                    new_vs_exist_bb_all_dist_area(1:length(linearised_Dist_Full_micron(:,2)), no_of_cells) = linearised_Dist_Full_micron(:,2); % getting the area for all distances between new BB and already existing BBs in the current frame
                    new_vs_exist_bb_all_dist(1:length(linearised_Dist_Full_micron(:,4)), no_of_cells) = linearised_Dist_Full_micron(:,4); % getting all distances between new BB and already existing BBs in the current frame
                    Avg_New_Exist_bb_mindist{no_of_cells} = avg_new_Exist_bb_Mindist; % getting the matrix related to the averaged (per frame) minimum distance between new BB in current frame to existing BBs in the current frame; Here, col1 is time in min; col2 is area; col3 is mean of min distances; col4 is std of min distances
                    Avg_New_Exist_bb_alldist{no_of_cells} = avg_new_Exist_bb_Alldist; % getting the matrix related to the averaged (per frame) all distances between new BB in current frame to existing BBs in the current frame; Here, col1 is time in min; col2 is area; col3 is mean of all distances; col4 is std of all distances
                    neighbor_bb_min_dist(1:length(linearised_neighbor_dist_micron_ful_mat(:,4)), no_of_cells) = linearised_neighbor_dist_micron_ful_mat(:,4); % getting nearest neighbor distance between existing BBs in the current frame
                    neighbor_bb_min_dist_area(1:length(linearised_neighbor_dist_micron_ful_mat(:,2)), no_of_cells) = linearised_neighbor_dist_micron_ful_mat(:,2); % getting area
                    neighbor_bb_min_dist_frameno(1:length(linearised_neighbor_dist_micron_ful_mat(:,1)), no_of_cells) = linearised_neighbor_dist_micron_ful_mat(:,1); % getting frame number
                    neighbor_bb_min_dist_time = neighbor_bb_min_dist_frameno * Time_interval; % converting frame numbers to min
                    neighbor_bb_min_dist_bbcount(1:length(linearised_neighbor_dist_micron_ful_mat(:,3)), no_of_cells) = linearised_neighbor_dist_micron_ful_mat(:,3); % getting BB count
                    neighbor_bb_all_dist_time(1:length(linearised_Distc_Full_micron(:,1)), no_of_cells) = linearised_Distc_Full_micron(:,1) * Time_interval; % getting the times for all distances between existing BBs in the current frame
                    neighbor_bb_all_dist_area(1:length(linearised_Distc_Full_micron(:,2)), no_of_cells) = linearised_Distc_Full_micron(:,2); % getting the area for all distances between existing BBs in the current frame
                    neighbor_bb_all_dist(1:length(linearised_Distc_Full_micron(:,4)), no_of_cells) = linearised_Distc_Full_micron(:,4); % getting all distances between existing BBs in the current frame
                    Avg_near_neighbour_bb_mindist{no_of_cells} = avg_Near_Neighbour_bb_Mindist; % getting the matrix related to the averaged (per frame) nearest neighbor distance between all the existing BBs in the current frame; Here, col1 is time in min; col2 is area; col3 is mean of min distances; col4 is std of min distances
                    Avg_exist_bb_alldist{no_of_cells} = avg_Exist_bb_Alldist; % getting the matrix related to the averaged (per frame) all distances between all the existing BBs in the current frame; Here, col1 is time in min; col2 is area; col3 is mean of min distances; col4 is std of min distances
                    clear Time_interval linearised_new_bb_appearance_distance_micron_ful_mat linearised_Dist_Full_micron linearised_neighbor_dist_micron_ful_mat linearised_Distc_Full_micron avg_new_Exist_bb_Mindist avg_new_Exist_bb_Alldist avg_Near_Neighbour_bb_Mindist avg_Exist_bb_Alldist

                    load('workspace_BB_step_distance_speed.mat', 'distance_mod', 'speed_mod', 'x_distance_mod', 'y_distance_mod', 'x_y_distance_mod');
                    step_dist_mod{no_of_cells} = distance_mod;
                    inst_speed_mod{no_of_cells} = speed_mod;
                    step_x_dist_mod{no_of_cells} = x_distance_mod;
                    step_y_dist_mod{no_of_cells} = y_distance_mod;
                    step_x_y_dist_mod{no_of_cells} = x_y_distance_mod;
                    clear distance_mod speed_mod x_distance_mod y_distance_mod x_y_distance_mod

                    if exist('workspace_dist_early_late_expansion_150um2.mat', 'file') % works only for control data and not for alphaActininMO since this analysis is not done for alphaActininMO
                        load('workspace_dist_early_late_expansion_150um2.mat', 'contourDist_actualAreaVal_areapercent_all_norm', 'EndToEndDist_actualAreaVal_areapercent_all_norm', 'tortuosity_early_expansion_AreaVal', 'tortuosity_late_expansion_AreaVal', 'tortuosity_25_PercentArea', 'tortuosity_50_PercentArea', 'tortuosity_75_PercentArea', 'tortuosity_100_PercentArea');
                        contour_dist_1to150um2(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,1);
                        contour_dist_150um2_finalarea(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,2);
                        contour_dist_25pct(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,3);
                        contour_dist_50pct(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,4);
                        contour_dist_75pct(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,5);
                        contour_dist_100pct(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,6);
                        endtoend_dist_1to150um2(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,1);
                        endtoend_dist_150um2_finalarea(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,2);
                        endtoend_dist_25pct(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,3);
                        endtoend_dist_50pct(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,4);
                        endtoend_dist_75pct(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,5);
                        endtoend_dist_100pct(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,6);
                        Tortuosity_Earlyexpansion = tortuosity_early_expansion_AreaVal; Tortuosity_Lateexpansion = tortuosity_late_expansion_AreaVal; Tortuosity_25PercentArea = tortuosity_25_PercentArea;
                        Tortuosity_50PercentArea = tortuosity_50_PercentArea; Tortuosity_75PercentArea = tortuosity_75_PercentArea; Tortuosity_100PercentArea = tortuosity_100_PercentArea;
                        clear contourDist_actualAreaVal_areapercent_all_norm EndToEndDist_actualAreaVal_areapercent_all_norm tortuosity_early_expansion_AreaVal tortuosity_late_expansion_AreaVal tortuosity_25_PercentArea tortuosity_50_PercentArea tortuosity_75_PercentArea tortuosity_100_PercentArea
                    end

                    load('workspace_msd_coarsegrained.mat', 'xaxis', 'xaxis_min', 'yaxis', 'avg_Diff_strength_fit', 'trajectories_mod', 'no_of_trajectories', 'longestTrajectory');
                    MSD_xaxis((1:length(xaxis)), no_of_cells) = xaxis;
                    MSD_xaxis_min((1:length(xaxis_min)), no_of_cells) = xaxis_min;
                    Length_xaxis(1, no_of_cells) = no_of_cells;
                    Length_xaxis(2, no_of_cells) = length(xaxis);
                    MSD_yaxis((1:length(yaxis)), no_of_cells) = yaxis;
                    Avg_Diff_strength_fit(1, no_of_cells) = avg_Diff_strength_fit;
                    msd_traj((1:length(trajectories_mod)), no_of_cells) = trajectories_mod;
                    No_of_Trajectories(1, no_of_cells) = no_of_trajectories;
                    Longesttrajectory(1, no_of_cells) = longestTrajectory;
                    clear xaxis xaxis_min yaxis avg_Diff_strength_fit trajectories_mod no_of_trajectories longestTrajectory

                    load('workspace_bb_density_distribution_expansion_bias.mat', 'quadrant_areas_at_max_apical_area_norm', 'quadrant_BB_count_at_max_apical_area_norm', 'whole_quadrant_area_rates_at_max_apical_area_norm', 'quad_BB_density_at_max_apical_area_norm', 'quad_actinMeanIntnorm_at_max_apical_area', 'quad_actinTotalIntnorm_at_max_apical_area', 'quadrant_total_NewBB_count_norm',...
                        'half_areas_at_max_apical_area_norm', 'half_BB_count_at_max_apical_area_norm', 'whole_half_area_rates_at_max_apical_area_norm', 'half_BB_density_at_max_apical_area_norm', 'half_actinMeanIntnorm_at_max_apical_area', 'half_actinTotalIntnorm_at_max_apical_area', 'half_total_NewBB_count_norm',...
                        'quadrant_area_reordered', 'quadrant_BBs_reordered', 'quad_area_rate_reordered', 'quadrant_bb_density_for_plot_reordered', 'quad_halves_meanint_norm_reordered', 'quad_halves_totalint_norm_reordered', 'quadrant_new_BBs_reordered',...
                        'quadrant_area_reordered_norm', 'quadrant_BBs_reordered_norm', 'quad_area_rate_reordered_norm', 'quadrant_bb_density_for_plot_reordered_norm', 'quadrant_new_BBs_reordered_norm',...
                        'clumpingfactor_area', 'clumpingfactor_area_max_apical_area', 'clumpingfactor_arearate', 'clumpingfactor_arearate_max_apical_area', 'clumpingfactor_bbcount', 'clumpingfactor_bbcount_max_apical_area', 'clumpingfactor_bbddensity', 'clumpingfactor_bbddensity_max_apical_area', 'clumpingfactor_meanint', 'clumpingfactor_meanint_max_apical_area', 'clumpingfactor_totalint', 'clumpingfactor_totalint_max_apical_area', 'clumpingfactor_newBBcount', 'clumpingfactor_newBBcount_max_apical_area');
                    Quad_Area{1, no_of_cells} = quadrant_area_reordered; Quad_BBcount{1, no_of_cells} = quadrant_BBs_reordered; Quad_arearate{1, no_of_cells} = quad_area_rate_reordered; Quad_bbdensity{1, no_of_cells} = quadrant_bb_density_for_plot_reordered; Quad_newBBs{1, no_of_cells} = quadrant_new_BBs_reordered;
                    Quad_Area_norm{1, no_of_cells} = quadrant_area_reordered_norm; Quad_BBcount_norm{1, no_of_cells} = quadrant_BBs_reordered_norm; Quad_arearate_norm{1, no_of_cells} = quad_area_rate_reordered_norm; Quad_bbdensity_norm{1, no_of_cells} = quadrant_bb_density_for_plot_reordered_norm; Quad_meanIntnorm{1, no_of_cells} = quad_halves_meanint_norm_reordered; Quad_totalIntnorm{1, no_of_cells} = quad_halves_totalint_norm_reordered; Quad_newBBs_norm{1, no_of_cells} = quadrant_new_BBs_reordered_norm;
                    ClumpingFactor_Area(1:length(clumpingfactor_area), no_of_cells) = clumpingfactor_area; ClumpingFactor_Area_max_apical_area(1, no_of_cells) = clumpingfactor_area_max_apical_area; ClumpingFactor_AreaRate(1:length(clumpingfactor_arearate), no_of_cells) = clumpingfactor_arearate; ClumpingFactor_AreaRate_max_apical_area(1, no_of_cells) = clumpingfactor_arearate_max_apical_area; ClumpingFactor_BBCount(1:length(clumpingfactor_bbcount), no_of_cells) = clumpingfactor_bbcount; ClumpingFactor_BBCount_max_apical_area(1, no_of_cells) = clumpingfactor_bbcount_max_apical_area;
                    ClumpingFactor_BBDensity(1:length(clumpingfactor_bbddensity), no_of_cells) = clumpingfactor_bbddensity; ClumpingFactor_BBDensity_max_apical_area(1, no_of_cells) = clumpingfactor_bbddensity_max_apical_area; ClumpingFactor_MeanInt(1:length(clumpingfactor_meanint), no_of_cells) = clumpingfactor_meanint; ClumpingFactor_MeanInt_max_apical_area(1, no_of_cells) = clumpingfactor_meanint_max_apical_area; ClumpingFactor_TotalInt(1:length(clumpingfactor_totalint), no_of_cells) = clumpingfactor_totalint; ClumpingFactor_TotalInt_max_apical_area(1, no_of_cells) = clumpingfactor_totalint_max_apical_area;
                    ClumpingFactor_NewBBCount(1:length(clumpingfactor_newBBcount), no_of_cells) = clumpingfactor_newBBcount; ClumpingFactor_NewBBCount_max_apical_area(1, no_of_cells) = clumpingfactor_newBBcount_max_apical_area;
                    Quad_Area_max_apical_area_norm(no_of_cells, 1:4) = quadrant_areas_at_max_apical_area_norm; Quad_BBcount_max_apical_area_norm(no_of_cells, 1:4) = quadrant_BB_count_at_max_apical_area_norm; Quad_arearate_max_apical_area_norm(no_of_cells, 1:4) = whole_quadrant_area_rates_at_max_apical_area_norm; Quad_BBdensity_at_max_apical_area_norm(no_of_cells, 1:4) = quad_BB_density_at_max_apical_area_norm;
                    Quad_actinMeanIntnorm_at_max_apical_area(no_of_cells, 1:4) = quad_actinMeanIntnorm_at_max_apical_area; Quad_actinTotalIntnorm_at_max_apical_area(no_of_cells, 1:4) = quad_actinTotalIntnorm_at_max_apical_area; Quad_NewBB_cumulative_count(no_of_cells, 1:4) = quadrant_total_NewBB_count_norm;
                    Half_areas_at_max_apical_area_norm(no_of_cells, 1:4) = half_areas_at_max_apical_area_norm; Half_BB_count_at_max_apical_area_norm(no_of_cells, 1:4) = half_BB_count_at_max_apical_area_norm; Half_area_rates_at_max_apical_area_norm(no_of_cells, 1:4) = whole_half_area_rates_at_max_apical_area_norm; Half_BB_density_at_max_apical_area_norm(no_of_cells, 1:4) = half_BB_density_at_max_apical_area_norm;
                    Half_actinMeanIntnorm_at_max_apical_area(no_of_cells, 1:4) = half_actinMeanIntnorm_at_max_apical_area; Half_actinTotalIntnorm_at_max_apical_area(no_of_cells, 1:4) = half_actinTotalIntnorm_at_max_apical_area; Half_NewBB_cumulative_count(no_of_cells, 1:4) = half_total_NewBB_count_norm;
                    clear quadrant_areas_at_max_apical_area_norm quadrant_BB_count_at_max_apical_area_norm whole_quadrant_area_rates_at_max_apical_area_norm quad_BB_density_at_max_apical_area_norm quad_actinMeanIntnorm_at_max_apical_area quad_actinTotalIntnorm_at_max_apical_area quadrant_total_NewBB_count_norm quadrant_area_reordered quadrant_BBs_reordered quad_area_rate_reordered quadrant_bb_density_for_plot_reordered quad_halves_meanint_norm_reordered quad_halves_totalint_norm_reordered ...
                        quadrant_new_BBs_reordered quadrant_area_reordered_norm quadrant_BBs_reordered_norm quad_area_rate_reordered_norm quadrant_bb_density_for_plot_reordered_norm quadrant_new_BBs_reordered_norm clumpingfactor_area clumpingfactor_area_max_apical_area clumpingfactor_arearate clumpingfactor_arearate_max_apical_area clumpingfactor_bbcount clumpingfactor_bbcount_max_apical_area clumpingfactor_bbddensity clumpingfactor_bbddensity_max_apical_area clumpingfactor_meanint clumpingfactor_meanint_max_apical_area clumpingfactor_totalint clumpingfactor_totalint_max_apical_area clumpingfactor_newBBcount clumpingfactor_newBBcount_max_apical_area...
                        half_areas_at_max_apical_area_norm half_BB_count_at_max_apical_area_norm whole_half_area_rates_at_max_apical_area_norm half_BB_density_at_max_apical_area_norm half_actinMeanIntnorm_at_max_apical_area half_actinTotalIntnorm_at_max_apical_area half_total_NewBB_count_norm

                    name{1, no_of_cells} = strcat(subfolders_1{i},'_', subfolders_2{j});
                    % ============loading all the required parameters from different cells============%
                    % ================================================================================%
                end
            else
                subfolder_list_3 = dir(subfolders_3_link);
                subfolders_3 = {subfolder_list_3([subfolder_list_3.isdir]).name};
                subfolders_3 = subfolders_3(~ismember(subfolders_3,{'.', '..'}));
                no_of_subfolders_3 = length(subfolders_3);
                for k = 1:no_of_subfolders_3
                    subfolders_4_link =[subfolders_3_link, '\', subfolders_3{k}];
                    cd(subfolders_4_link);
                    if exist('analy', 'dir')
                        analy_check =[subfolders_4_link, '\', 'analy'];
                        cd(analy_check);
                        if exist('Plots_matlab_script', 'dir')
                            file_link_1 = [analy_check, '\', 'Plots_matlab_script\'];
                            cd(file_link_1);
                            % ================================================================================%
                            % ============loading all the required parameters from different cells============%
                            no_of_cells = no_of_cells + 1;

                            load('workspace_interim.mat', 'Timelist', 'Area_apicaldomain', 'Area_apicaldomain_percent', 'residual_area', 'residual_area_percent', 'bb_area', 'bb_area_percent', 'sum_of_residual_bb_areas', 'No_of_BB', 'MeanIntensity_apicaldomain', 'TotalIntensity_apicaldomain', 'area_rate', 'norm_area_rate', 'whole_area_rate', 'aspect_ratio', 'Circularity_apicaldomain',...
                                'MeanInt_BBposition_traj_atmaxarea_only', 'TotalInt_BBposition_traj_atmaxarea_only', 'MeanInt_BBsurround_traj_atmaxarea_only', 'TotalInt_BBsurround_traj_atmaxarea_only', 'MeanInt_BB_SurPos_ratio_traj_atmaxarea_only', 'TotalInt_BB_SurPos_ratio_traj_atmaxarea_only', 'MeanInt_BBposition_traj_atmaxarea_only_aligned', 'TotalInt_BBposition_traj_atmaxarea_only_aligned',...
                                'MeanInt_BBsurround_traj_atmaxarea_only_aligned', 'TotalInt_BBsurround_traj_atmaxarea_only_aligned', 'MeanInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned', 'TotalInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned', 'Timelist_clone_traj_atmaxarea_only', 'Area_apicaldomain_clone_traj_atmaxarea_only', 'MeanInt_atBBpos_1st_frame',...
                                'MeanInt_atBBpos_max_apical_area', 'TotalInt_atBBpos_1st_frame', 'TotalInt_atBBpos_max_apical_area', 'MeanInt_atBBSurr_1st_frame', 'MeanInt_atBBSurr_max_apical_area', 'TotalInt_atBBSurr_1st_frame', 'TotalInt_atBBSurr_max_apical_area', 'MeanInt_ratio_BBSurPos_1st_frame', 'MeanInt_ratio_BBSurPos_max_apical_area', 'TotalInt_ratio_BBSurPos_1st_frame', 'TotalInt_ratio_BBSurPos_max_apical_area');
                            timelist((1:length(Timelist)),no_of_cells) = Timelist;
                            area_apicaldomain((1:length(Area_apicaldomain)), no_of_cells) = Area_apicaldomain;
                            area_apicaldomain_percent((1:length(Area_apicaldomain_percent)), no_of_cells) = Area_apicaldomain_percent;
                            no_of_bb((1:length(No_of_BB)), no_of_cells) = No_of_BB;
                            Residual_Area((1:length(residual_area)), no_of_cells) = residual_area;
                            Residual_Area_percent((1:length(residual_area_percent)), no_of_cells) = residual_area_percent;
                            BB_area((1:length(bb_area)), no_of_cells) = bb_area;
                            BB_area_percent((1:length(bb_area_percent)), no_of_cells) = bb_area_percent;
                            Sum_of_Residual_bb_areas_percent((1:length(sum_of_residual_bb_areas)), no_of_cells) = sum_of_residual_bb_areas;
                            meanintensity_apicaldomain((1:length(MeanIntensity_apicaldomain)), no_of_cells) = MeanIntensity_apicaldomain;
                            totalintensity_apicaldomain((1:length(TotalIntensity_apicaldomain)), no_of_cells) = TotalIntensity_apicaldomain;
                            Area_rate((1:length(area_rate)), no_of_cells) = area_rate;
                            Norm_Area_rate((1:length(norm_area_rate)), no_of_cells) = norm_area_rate;
                            Whole_area_rate(1, no_of_cells) = whole_area_rate;
                            isotropicity((1:length(aspect_ratio)), no_of_cells) = aspect_ratio;
                            circularity((1:length(Circularity_apicaldomain)), no_of_cells) = Circularity_apicaldomain;
                            meanint_atBBpos_Traj_atMaxArea_Only{no_of_cells} = MeanInt_BBposition_traj_atmaxarea_only(:);
                            totalint_atBBpos_Traj_atMaxArea_Only{no_of_cells} = TotalInt_BBposition_traj_atmaxarea_only(:);
                            meanint_atBBSurr_Traj_atMaxArea_Only{no_of_cells} = MeanInt_BBsurround_traj_atmaxarea_only(:);
                            totalint_atBBSurr_Traj_atMaxArea_Only{no_of_cells} = TotalInt_BBsurround_traj_atmaxarea_only(:);
                            meanint_BB_SurPos_ratio_Traj_atMaxArea_Only{no_of_cells} = MeanInt_BB_SurPos_ratio_traj_atmaxarea_only(:);
                            totalint_BB_SurPos_ratio_Traj_atMaxArea_Only{no_of_cells} = TotalInt_BB_SurPos_ratio_traj_atmaxarea_only(:);
                            meanint_BBpos_Traj_atMaxArea_Only_Aligned{no_of_cells} = MeanInt_BBposition_traj_atmaxarea_only_aligned(:);
                            totalint_BBpos_Traj_atMaxArea_Only_Aligned{no_of_cells} = TotalInt_BBposition_traj_atmaxarea_only_aligned(:);
                            meanint_BBSurr_Traj_atMaxArea_Only_Aligned{no_of_cells} = MeanInt_BBsurround_traj_atmaxarea_only_aligned(:);
                            totalint_BBSurr_Traj_atMaxArea_Only_Aligned{no_of_cells} = TotalInt_BBsurround_traj_atmaxarea_only_aligned(:);
                            meanint_BB_SurPos_ratio_Traj_atMaxArea_Only_Aligned{no_of_cells} = MeanInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned(:);
                            totalint_BB_SurPos_ratio_Traj_atMaxArea_Only_Aligned{no_of_cells} = TotalInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned(:);
                            Timelist_clone_Traj_atMaxArea_Only{no_of_cells} = Timelist_clone_traj_atmaxarea_only(:);
                            Area_apicaldomain_clone_Traj_atMaxArea_Only{no_of_cells} = Area_apicaldomain_clone_traj_atmaxarea_only(:);
                            meanint_atBBpos_1stframe(1:length(MeanInt_atBBpos_1st_frame), no_of_cells) = MeanInt_atBBpos_1st_frame;
                            meanint_atBBpos_maxapicalarea(1:length(MeanInt_atBBpos_max_apical_area), no_of_cells) = MeanInt_atBBpos_max_apical_area;
                            totalint_atBBpos_1stframe(1:length(TotalInt_atBBpos_1st_frame), no_of_cells) = TotalInt_atBBpos_1st_frame;
                            totalint_atBBpos_maxapicalarea(1:length(TotalInt_atBBpos_max_apical_area), no_of_cells) = TotalInt_atBBpos_max_apical_area;
                            meanint_atBBSurr_1stframe(1:length(MeanInt_atBBSurr_1st_frame), no_of_cells) = MeanInt_atBBSurr_1st_frame;
                            meanint_atBBSurr_maxapicalarea(1:length(MeanInt_atBBSurr_max_apical_area), no_of_cells) = MeanInt_atBBSurr_max_apical_area;
                            totalint_atBBSurr_1stframe(1:length(TotalInt_atBBSurr_1st_frame), no_of_cells) = TotalInt_atBBSurr_1st_frame;
                            totalint_atBBSurr_maxapicalarea(1:length(TotalInt_atBBSurr_max_apical_area), no_of_cells) = TotalInt_atBBSurr_max_apical_area;
                            meanint_ratio_BBSurPos_1stframe(1:length(MeanInt_ratio_BBSurPos_1st_frame), no_of_cells) = MeanInt_ratio_BBSurPos_1st_frame;
                            meanint_ratio_BBSurPos_maxapicalarea(1:length(MeanInt_ratio_BBSurPos_max_apical_area), no_of_cells) = MeanInt_ratio_BBSurPos_max_apical_area;
                            totalint_ratio_BBSurPos_1stframe(1:length(TotalInt_ratio_BBSurPos_1st_frame), no_of_cells) = TotalInt_ratio_BBSurPos_1st_frame;
                            totalint_ratio_BBSurPos_maxapicalarea(1:length(TotalInt_ratio_BBSurPos_max_apical_area), no_of_cells) = TotalInt_ratio_BBSurPos_max_apical_area;
                            clear Timelist Area_apicaldomain Area_apicaldomain_percent residual_area residual_area_percent bb_area bb_area_percent sum_of_residual_bb_areas No_of_BB MeanIntensity_apicaldomain TotalIntensity_apicaldomain area_rate norm_area_rate whole_area_rate aspect_ratio Circularity_apicaldomain...
                                MeanInt_BBposition_traj_atmaxarea_only TotalInt_BBposition_traj_atmaxarea_only MeanInt_BBsurround_traj_atmaxarea_only TotalInt_BBsurround_traj_atmaxarea_only MeanInt_BB_SurPos_ratio_traj_atmaxarea_only TotalInt_BB_SurPos_ratio_traj_atmaxarea_only Timelist_clone_traj_atmaxarea_only Area_apicaldomain_clone_traj_atmaxarea_only MeanInt_BBposition_traj_atmaxarea_only_aligned TotalInt_BBposition_traj_atmaxarea_only_aligned MeanInt_BBsurround_traj_atmaxarea_only_aligned TotalInt_BBsurround_traj_atmaxarea_only_aligned...
                                MeanInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned TotalInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned MeanInt_atBBpos_1st_frame MeanInt_atBBpos_max_apical_area TotalInt_atBBpos_1st_frame TotalInt_atBBpos_max_apical_area MeanInt_atBBSurr_1st_frame MeanInt_atBBSurr_max_apical_area TotalInt_atBBSurr_1st_frame TotalInt_atBBSurr_max_apical_area MeanInt_ratio_BBSurPos_1st_frame MeanInt_ratio_BBSurPos_max_apical_area TotalInt_ratio_BBSurPos_1st_frame TotalInt_ratio_BBSurPos_max_apical_area

                            load('workspace_with_t0_data.mat', 'frm_nmb_time_modified', 'Area_t0_BB', 'basalbody_count_original', 'basalbody_count_modified_rate', 'BB_flux');
                            t0_time((1:length(frm_nmb_time_modified)), no_of_cells) = frm_nmb_time_modified;
                            area_t0_bb((1:length(Area_t0_BB)), no_of_cells) = Area_t0_BB;
                            NEW_BB_entry_count((1:length(basalbody_count_original)), no_of_cells) = basalbody_count_original;
                            bbEntry_rate((1:length(basalbody_count_modified_rate)), no_of_cells) = basalbody_count_modified_rate;
                            bbEntryFlux((1:length(BB_flux)), no_of_cells) = BB_flux;
                            clear frm_nmb_time frm_nmb_time_modified Area_t0_BB basalbody_count_original basalbody_count_modified_rate BB_flux

                            load('workspace_with_tend_data.mat', 'frm_nmb_time_modified', 'Area_tend_BB', 'basalbody_count_original', 'basalbody_count_modified_rate', 'BB_flux');
                            Tend_time = frm_nmb_time_modified(1,(1:(end-1))); Area_Tend_bb = Area_tend_BB(1,(1:(end-1))); BasalBody_Count_Original = basalbody_count_original(1,(1:(end-1))); BBExit_rate = basalbody_count_modified_rate(1,(1:(end-1)));
                            tend_time((1:length(Tend_time)), no_of_cells) = Tend_time;
                            area_tend_bb((1:length(Area_Tend_bb)), no_of_cells) = Area_Tend_bb;
                            NEW_BB_exit_count(1:length(BasalBody_Count_Original), no_of_cells) = BasalBody_Count_Original;
                            bbExit_rate((1:length(BBExit_rate)), no_of_cells) = BBExit_rate;
                            bbExitFlux((1:length(BB_flux)), no_of_cells) = BB_flux;
                            clear frm_nmb_time frm_nmb_time_modified Area_tend_BB basalbody_count_original basalbody_count_modified_rate Tend_time Area_Tend_bb BBExit_rate BB_flux

                            load('workspace_bb_mean_inter_distance_density.mat', 'bb_density_norm', 'mintd', 'local_clustering', 'global_clustering', 'area_for_plotting_clustering', 'time_for_plotting_clustering');
                            BB_density_norm((1:length(bb_density_norm)), no_of_cells) = bb_density_norm;
                            Mintd((1:length(mintd)), no_of_cells) = mintd;
                            Local_Clustering((1:length(local_clustering)), no_of_cells) = local_clustering;
                            Global_Clustering((1:length(global_clustering)), no_of_cells) = global_clustering;
                            Area_Clustering((1:length(area_for_plotting_clustering)), no_of_cells) = area_for_plotting_clustering;
                            Time_Clustering((1:length(time_for_plotting_clustering)), no_of_cells) = time_for_plotting_clustering;
                            clear bb_density_norm mintd local_clustering global_clustering area_for_plotting_clustering time_for_plotting_clustering

                            load('workspace_tessalations_all.mat', 'variance_voronoi_fin', 'variance_voronoi_fin_norm', 'time', 'Area_apicaldomain', 'No_of_BB');
                            time_Variancetessalation_all((1:length(time)), no_of_cells) = time;
                            Area_apicaldomain_Variancetessalation_all((1:length(Area_apicaldomain)), no_of_cells) = Area_apicaldomain;
                            No_of_BB_Variancetessalation_all((1:length(No_of_BB)), no_of_cells) = No_of_BB;
                            Variance_voronoi_fin_all((1:length(variance_voronoi_fin)), no_of_cells) = variance_voronoi_fin;
                            Variance_voronoi_fin_norm_all((1:length(variance_voronoi_fin_norm)), no_of_cells) = variance_voronoi_fin_norm;
                            clear variance_voronoi_fin_norm variance_voronoi_fin time Area_apicaldomain No_of_BB
                            load('workspace_tessalations_without_border_cells', 'variance_voronoi_fin', 'variance_voronoi_fin_norm', 'time', 'Area_apicaldomain', 'No_of_BB');
                            time_Variancetessalation_edge_removed((1:length(time)), no_of_cells) = time;
                            Area_apicaldomain_Variancetessalation_edge_removed((1:length(Area_apicaldomain)), no_of_cells) = Area_apicaldomain;
                            No_of_BB_Variancetessalation_edge_removed((1:length(No_of_BB)), no_of_cells) = No_of_BB;
                            Variance_voronoi_fin_edge_removed((1:length(variance_voronoi_fin)), no_of_cells) = variance_voronoi_fin;
                            Variance_voronoi_fin_norm_edge_removed((1:length(variance_voronoi_fin_norm)), no_of_cells) = variance_voronoi_fin_norm;
                            clear variance_voronoi_fin_norm variance_voronoi_fin time Area_apicaldomain No_of_BB

                            load('workspace_drift.mat', 'tm', 'Xmean', 'Ymean', 'drift_slope', 'no_of_durmax_points', 'Xp_save', 'Yp_save', 'time_dur_save', 'Nlrge', 'dl', 'dr', 'tortsty', 'dotp'); % for tortuosity, use 'tort' if outlier tortuosity needs to be removed, otherwise if you want to use all the values without filtering anything, use 'tortsty'. for more details, check the drift_mandar.m script
                            Drift_time((1:length(tm)), no_of_cells) = tm;
                            Drift_xmean((1:length(Xmean)), no_of_cells) = Xmean;
                            Drift_ymean((1:length(Ymean)), no_of_cells) = Ymean;
                            Drift_slope(1, no_of_cells) = drift_slope;
                            No_of_Durmax_points(1, no_of_cells) = no_of_durmax_points;
                            XP_Save((1:length(Xp_save)),no_of_cells) = Xp_save;
                            YP_Save((1:length(Yp_save)),no_of_cells) = Yp_save;
                            Time_Dur_Save((1:length(time_dur_save)),no_of_cells) = time_dur_save;
                            nLrge(1, no_of_cells) = Nlrge;
                            ContourLength{no_of_cells} = dl;
                            EndToEndLength{no_of_cells} = dr;
                            Tort{no_of_cells} = tortsty;
                            Dotp{no_of_cells} = dotp;
                            clear tm Xmean Ymean drift_slope no_of_durmax_points Xp_save Yp_save time_dur_save Nlrge dl dr tortsty dotp

                            load('workspace_BB_distance_consequent_frames.mat', 'Time_interval', 'bbcoordinates_x', 'area_t0_bb_mod', 'No_of_BB_t0_mod', 'bb_density_t0', 'distn_in_micron', 'bb_dist_barplot', 'area_fraction', 'bb_in_area_fraction', 'linearised_New_BB_Distc_Full_micron', 'avg_new_new_bb_Mindist', 'avg_new_new_bb_Alldist');
                            dist_in_micr = distn_in_micron(:); dummy_ones = ones(size(distn_in_micron)); [row, ~] = find(isnan(dist_in_micr)); % we linearise the 'distn_in_micron' matrix and get some other parameters so that the matrices of 'area_t0_bb_mod' & 'No_of_BB_t0_mod'  can be adjusted to the size of 'distn_in_micron'
                            Distn_in_micron((1:length(dist_in_micr)), no_of_cells) = dist_in_micr;
                            % adjusting the size of 'area_t0_bb_mod' matrix to match the 'distn_in_micron' matrix
                            ar_t0_bb_1 = area_t0_bb_mod'; ar_t0_bb_2 = ar_t0_bb_1 .* dummy_ones;
                            ar_t0_bb_2(row) = nan; ar_t0_bb_3 = ar_t0_bb_2(:);
                            Area_t0_BB_mod((1:length(ar_t0_bb_3)), no_of_cells) = ar_t0_bb_3;
                            % adjusting the size of 'No_of_BB_t0_mod' matrix to match the 'distn_in_micron' matrix
                            no_t0_bb_1 = No_of_BB_t0_mod'; no_t0_bb_2 = no_t0_bb_1 .* dummy_ones;
                            no_t0_bb_2(row) = nan; no_t0_bb_3 = no_t0_bb_2(:);
                            no_of_bb_t0_mod((1:length(no_t0_bb_3)), no_of_cells) = no_t0_bb_3;
                            % adjusting the size of 'bb_density_t0' matrix to match the 'distn_in_micron' matrix
                            bb_density_t0_1 = bb_density_t0'; bb_density_t0_2 = bb_density_t0_1 .* dummy_ones;
                            bb_density_t0_2(row) = nan; bb_density_t0_3 = bb_density_t0_2(:);
                            bb_density_t0_mod((1:length(bb_density_t0_3)), no_of_cells) = bb_density_t0_3;
                            % adjusting the size of 'bbcoordinates_x' matrix to match the 'distn_in_micron' matrix; 'bbcoordinates_x' contains the frame numbers of all newly appearing basal bodies
                            bb_cord_x_0 = bbcoordinates_x(:,1) * Time_interval; bb_cord_x_1 = bb_cord_x_0 .* dummy_ones;
                            bb_cord_x_1(row) = nan; bb_cord_x_2 = bb_cord_x_1(:);
                            time_bb_appear_dist((1:length(bb_cord_x_2)), no_of_cells) = bb_cord_x_2;
                            % fetching other parameters
                            BB_dist_barplot((1:length(bb_dist_barplot)), no_of_cells) = bb_dist_barplot;
                            Area_Fraction((1:length(area_fraction)), no_of_cells) = area_fraction;
                            BB_in_Area_fraction((1:length(bb_in_area_fraction)), no_of_cells) = bb_in_area_fraction;
                            new_BB_appearance_all_dist_time{no_of_cells} = linearised_New_BB_Distc_Full_micron(:,1) * Time_interval; % getting the times corresponding to all BB distances (between current frame and previous frame new BBs)
                            new_BB_appearance_all_dist_area{no_of_cells} = linearised_New_BB_Distc_Full_micron(:,2); % getting the areas corresponding to all BB distances (between current frame and previous frame new BBs)
                            new_BB_appearance_all_dist{no_of_cells} = linearised_New_BB_Distc_Full_micron(:,4); % getting all the BB distances (between current frame and previous frame new BBs)
                            Avg_New_New_bb_mindist{no_of_cells} = avg_new_new_bb_Mindist; % getting the matrix related to the averaged (per frame) minimum distance between new BB in current frame to new BBs in the old frame; Here, col1 is time in min; col2 is area; col3 is no of new BBs; col4 is mean of min distances; col5 is std of min distances
                            Avg_New_New_bb_alldist{no_of_cells} = avg_new_new_bb_Alldist; % getting the matrix related to the averaged (per frame) all distances between new BB in current frame to new BBs in the old frame; Here, col1 is time in min; col2 is area; col3 is no of new BBs; col4 is mean of all distances; col5 is std of all distances
                            clear area_t0_bb_mod No_of_BB_t0_mod bb_density_t0 distn_in_micron dist_in_micr dummy_ones row ar_t0_bb_1 ar_t0_bb_2 ar_t0_bb_3 no_t0_bb_1 no_t0_bb_2 no_t0_bb_3 Time_interval bbcoordinates_x bb_cord_x_0 bb_cord_x_1 bb_cord_x_2 bb_dist_barplot area_fraction bb_in_area_fraction linearised_New_BB_Distc_Full_micron avg_new_new_bb_Mindist avg_new_new_bb_Alldist

                            load('workspace_BB_distance_same_frame.mat', 'Time_interval', 'linearised_new_bb_appearance_distance_micron_ful_mat', 'linearised_Dist_Full_micron', 'linearised_neighbor_dist_micron_ful_mat', 'linearised_Distc_Full_micron', 'avg_new_Exist_bb_Mindist', 'avg_new_Exist_bb_Alldist', 'avg_Near_Neighbour_bb_Mindist', 'avg_Exist_bb_Alldist');
                            new_vs_exist_bb_min_dist(1:length(linearised_new_bb_appearance_distance_micron_ful_mat(:,4)), no_of_cells) = linearised_new_bb_appearance_distance_micron_ful_mat(:,4); % getting minimal distance between new BB and already existing BBs in the current frame
                            new_vs_exist_bb_min_dist_area(1:length(linearised_new_bb_appearance_distance_micron_ful_mat(:,2)), no_of_cells) = linearised_new_bb_appearance_distance_micron_ful_mat(:,2); % getting area
                            new_vs_exist_bb_min_dist_frameno(1:length(linearised_new_bb_appearance_distance_micron_ful_mat(:,1)), no_of_cells) = linearised_new_bb_appearance_distance_micron_ful_mat(:,1); % getting frame numbers
                            new_vs_exist_bb_min_dist_time = new_vs_exist_bb_min_dist_frameno * Time_interval; % converting frame numbers to min
                            new_vs_exist_bb_min_dist_bbcount(1:length(linearised_new_bb_appearance_distance_micron_ful_mat(:,3)), no_of_cells) = linearised_new_bb_appearance_distance_micron_ful_mat(:,3); % getting BB count
                            new_vs_exist_bb_all_dist_time(1:length(linearised_Dist_Full_micron(:,1)), no_of_cells) = linearised_Dist_Full_micron(:,1) * Time_interval; % getting the times for all distances between new BB and already existing BBs in the current frame
                            new_vs_exist_bb_all_dist_area(1:length(linearised_Dist_Full_micron(:,2)), no_of_cells) = linearised_Dist_Full_micron(:,2); % getting the area for all distances between new BB and already existing BBs in the current frame
                            new_vs_exist_bb_all_dist(1:length(linearised_Dist_Full_micron(:,4)), no_of_cells) = linearised_Dist_Full_micron(:,4); % getting all distances between new BB and already existing BBs in the current frame
                            Avg_New_Exist_bb_mindist{no_of_cells} = avg_new_Exist_bb_Mindist; % getting the matrix related to the averaged (per frame) minimum distance between new BB in current frame to existing BBs in the current frame; Here, col1 is time in min; col2 is area; col3 is mean of min distances; col4 is std of min distances
                            Avg_New_Exist_bb_alldist{no_of_cells} = avg_new_Exist_bb_Alldist; % getting the matrix related to the averaged (per frame) all distances between new BB in current frame to existing BBs in the current frame; Here, col1 is time in min; col2 is area; col3 is mean of all distances; col4 is std of all distances
                            neighbor_bb_min_dist(1:length(linearised_neighbor_dist_micron_ful_mat(:,4)), no_of_cells) = linearised_neighbor_dist_micron_ful_mat(:,4); % getting nearest neighbor distance between existing BBs in the current frame
                            neighbor_bb_min_dist_area(1:length(linearised_neighbor_dist_micron_ful_mat(:,2)), no_of_cells) = linearised_neighbor_dist_micron_ful_mat(:,2); % getting area
                            neighbor_bb_min_dist_frameno(1:length(linearised_neighbor_dist_micron_ful_mat(:,1)), no_of_cells) = linearised_neighbor_dist_micron_ful_mat(:,1); % getting frame number
                            neighbor_bb_min_dist_time = neighbor_bb_min_dist_frameno * Time_interval; % converting frame numbers to min
                            neighbor_bb_min_dist_bbcount(1:length(linearised_neighbor_dist_micron_ful_mat(:,3)), no_of_cells) = linearised_neighbor_dist_micron_ful_mat(:,3); % getting BB count
                            neighbor_bb_all_dist_time(1:length(linearised_Distc_Full_micron(:,1)), no_of_cells) = linearised_Distc_Full_micron(:,1) * Time_interval; % getting the times for all distances between existing BBs in the current frame
                            neighbor_bb_all_dist_area(1:length(linearised_Distc_Full_micron(:,2)), no_of_cells) = linearised_Distc_Full_micron(:,2); % getting the area for all distances between existing BBs in the current frame
                            neighbor_bb_all_dist(1:length(linearised_Distc_Full_micron(:,4)), no_of_cells) = linearised_Distc_Full_micron(:,4); % getting all distances between existing BBs in the current frame
                            Avg_near_neighbour_bb_mindist{no_of_cells} = avg_Near_Neighbour_bb_Mindist; % getting the matrix related to the averaged (per frame) nearest neighbor distance between all the existing BBs in the current frame; Here, col1 is time in min; col2 is area; col3 is mean of min distances; col4 is std of min distances
                            Avg_exist_bb_alldist{no_of_cells} = avg_Exist_bb_Alldist; % getting the matrix related to the averaged (per frame) all distances between all the existing BBs in the current frame; Here, col1 is time in min; col2 is area; col3 is mean of min distances; col4 is std of min distances
                            clear Time_interval linearised_new_bb_appearance_distance_micron_ful_mat linearised_Dist_Full_micron linearised_neighbor_dist_micron_ful_mat linearised_Distc_Full_micron avg_new_Exist_bb_Mindist avg_new_Exist_bb_Alldist avg_Near_Neighbour_bb_Mindist avg_Exist_bb_Alldist

                            load('workspace_BB_step_distance_speed.mat', 'distance_mod', 'speed_mod', 'x_distance_mod', 'y_distance_mod', 'x_y_distance_mod');
                            step_dist_mod{no_of_cells} = distance_mod;
                            inst_speed_mod{no_of_cells} = speed_mod;
                            step_x_dist_mod{no_of_cells} = x_distance_mod;
                            step_y_dist_mod{no_of_cells} = y_distance_mod;
                            step_x_y_dist_mod{no_of_cells} = x_y_distance_mod;
                            clear distance_mod speed_mod x_distance_mod y_distance_mod x_y_distance_mod

                            if exist('workspace_dist_early_late_expansion_150um2.mat', 'file') % works only for control data and not for alphaActininMO since this analysis is not done for alphaActininMO
                                load('workspace_dist_early_late_expansion_150um2.mat', 'contourDist_actualAreaVal_areapercent_all_norm', 'EndToEndDist_actualAreaVal_areapercent_all_norm', 'tortuosity_early_expansion_AreaVal', 'tortuosity_late_expansion_AreaVal', 'tortuosity_25_PercentArea', 'tortuosity_50_PercentArea', 'tortuosity_75_PercentArea', 'tortuosity_100_PercentArea');
                                contour_dist_1to150um2(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,1);
                                contour_dist_150um2_finalarea(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,2);
                                contour_dist_25pct(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,3);
                                contour_dist_50pct(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,4);
                                contour_dist_75pct(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,5);
                                contour_dist_100pct(1:length(contourDist_actualAreaVal_areapercent_all_norm), no_of_cells) = contourDist_actualAreaVal_areapercent_all_norm(:,6);
                                endtoend_dist_1to150um2(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,1);
                                endtoend_dist_150um2_finalarea(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,2);
                                endtoend_dist_25pct(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,3);
                                endtoend_dist_50pct(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,4);
                                endtoend_dist_75pct(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,5);
                                endtoend_dist_100pct(1:length(EndToEndDist_actualAreaVal_areapercent_all_norm), no_of_cells) = EndToEndDist_actualAreaVal_areapercent_all_norm(:,6);
                                Tortuosity_Earlyexpansion = tortuosity_early_expansion_AreaVal; Tortuosity_Lateexpansion = tortuosity_late_expansion_AreaVal; Tortuosity_25PercentArea = tortuosity_25_PercentArea;
                                Tortuosity_50PercentArea = tortuosity_50_PercentArea; Tortuosity_75PercentArea = tortuosity_75_PercentArea; Tortuosity_100PercentArea = tortuosity_100_PercentArea;
                                clear contourDist_actualAreaVal_areapercent_all_norm EndToEndDist_actualAreaVal_areapercent_all_norm tortuosity_early_expansion_AreaVal tortuosity_late_expansion_AreaVal tortuosity_25_PercentArea tortuosity_50_PercentArea tortuosity_75_PercentArea tortuosity_100_PercentArea
                            end

                            load('workspace_msd_coarsegrained.mat', 'xaxis', 'xaxis_min', 'yaxis', 'avg_Diff_strength_fit', 'trajectories_mod', 'no_of_trajectories', 'longestTrajectory');
                            MSD_xaxis((1:length(xaxis)), no_of_cells) = xaxis;
                            MSD_xaxis_min((1:length(xaxis_min)), no_of_cells) = xaxis_min;
                            Length_xaxis(1, no_of_cells) = no_of_cells;
                            Length_xaxis(2, no_of_cells) = length(xaxis);
                            MSD_yaxis((1:length(yaxis)), no_of_cells) = yaxis;
                            Avg_Diff_strength_fit(1, no_of_cells) = avg_Diff_strength_fit;
                            msd_traj((1:length(trajectories_mod)), no_of_cells) = trajectories_mod;
                            No_of_Trajectories(1, no_of_cells) = no_of_trajectories;
                            Longesttrajectory(1, no_of_cells) = longestTrajectory;
                            clear xaxis xaxis_min yaxis avg_Diff_strength_fit trajectories_mod no_of_trajectories longestTrajectory

                            load('workspace_bb_density_distribution_expansion_bias.mat', 'quadrant_areas_at_max_apical_area_norm', 'quadrant_BB_count_at_max_apical_area_norm', 'whole_quadrant_area_rates_at_max_apical_area_norm', 'quad_BB_density_at_max_apical_area_norm', 'quad_actinMeanIntnorm_at_max_apical_area', 'quad_actinTotalIntnorm_at_max_apical_area', 'quadrant_total_NewBB_count_norm',...
                                'half_areas_at_max_apical_area_norm', 'half_BB_count_at_max_apical_area_norm', 'whole_half_area_rates_at_max_apical_area_norm', 'half_BB_density_at_max_apical_area_norm', 'half_actinMeanIntnorm_at_max_apical_area', 'half_actinTotalIntnorm_at_max_apical_area', 'half_total_NewBB_count_norm',...
                                'quadrant_area_reordered', 'quadrant_BBs_reordered', 'quad_area_rate_reordered', 'quadrant_bb_density_for_plot_reordered', 'quad_halves_meanint_norm_reordered', 'quad_halves_totalint_norm_reordered', 'quadrant_new_BBs_reordered',...
                                'quadrant_area_reordered_norm', 'quadrant_BBs_reordered_norm', 'quad_area_rate_reordered_norm', 'quadrant_bb_density_for_plot_reordered_norm', 'quadrant_new_BBs_reordered_norm',...
                                'clumpingfactor_area', 'clumpingfactor_area_max_apical_area', 'clumpingfactor_arearate', 'clumpingfactor_arearate_max_apical_area', 'clumpingfactor_bbcount', 'clumpingfactor_bbcount_max_apical_area', 'clumpingfactor_bbddensity', 'clumpingfactor_bbddensity_max_apical_area', 'clumpingfactor_meanint', 'clumpingfactor_meanint_max_apical_area', 'clumpingfactor_totalint', 'clumpingfactor_totalint_max_apical_area', 'clumpingfactor_newBBcount', 'clumpingfactor_newBBcount_max_apical_area');
                            Quad_Area{1, no_of_cells} = quadrant_area_reordered; Quad_BBcount{1, no_of_cells} = quadrant_BBs_reordered; Quad_arearate{1, no_of_cells} = quad_area_rate_reordered; Quad_bbdensity{1, no_of_cells} = quadrant_bb_density_for_plot_reordered; Quad_newBBs{1, no_of_cells} = quadrant_new_BBs_reordered;
                            Quad_Area_norm{1, no_of_cells} = quadrant_area_reordered_norm; Quad_BBcount_norm{1, no_of_cells} = quadrant_BBs_reordered_norm; Quad_arearate_norm{1, no_of_cells} = quad_area_rate_reordered_norm; Quad_bbdensity_norm{1, no_of_cells} = quadrant_bb_density_for_plot_reordered_norm; Quad_meanIntnorm{1, no_of_cells} = quad_halves_meanint_norm_reordered; Quad_totalIntnorm{1, no_of_cells} = quad_halves_totalint_norm_reordered; Quad_newBBs_norm{1, no_of_cells} = quadrant_new_BBs_reordered_norm;
                            ClumpingFactor_Area(1:length(clumpingfactor_area), no_of_cells) = clumpingfactor_area; ClumpingFactor_Area_max_apical_area(1, no_of_cells) = clumpingfactor_area_max_apical_area; ClumpingFactor_AreaRate(1:length(clumpingfactor_arearate), no_of_cells) = clumpingfactor_arearate; ClumpingFactor_AreaRate_max_apical_area(1, no_of_cells) = clumpingfactor_arearate_max_apical_area; ClumpingFactor_BBCount(1:length(clumpingfactor_bbcount), no_of_cells) = clumpingfactor_bbcount; ClumpingFactor_BBCount_max_apical_area(1, no_of_cells) = clumpingfactor_bbcount_max_apical_area;
                            ClumpingFactor_BBDensity(1:length(clumpingfactor_bbddensity), no_of_cells) = clumpingfactor_bbddensity; ClumpingFactor_BBDensity_max_apical_area(1, no_of_cells) = clumpingfactor_bbddensity_max_apical_area; ClumpingFactor_MeanInt(1:length(clumpingfactor_meanint), no_of_cells) = clumpingfactor_meanint; ClumpingFactor_MeanInt_max_apical_area(1, no_of_cells) = clumpingfactor_meanint_max_apical_area; ClumpingFactor_TotalInt(1:length(clumpingfactor_totalint), no_of_cells) = clumpingfactor_totalint; ClumpingFactor_TotalInt_max_apical_area(1, no_of_cells) = clumpingfactor_totalint_max_apical_area;
                            ClumpingFactor_NewBBCount(1:length(clumpingfactor_newBBcount), no_of_cells) = clumpingfactor_newBBcount; ClumpingFactor_NewBBCount_max_apical_area(1, no_of_cells) = clumpingfactor_newBBcount_max_apical_area;
                            Quad_Area_max_apical_area_norm(no_of_cells, 1:4) = quadrant_areas_at_max_apical_area_norm; Quad_BBcount_max_apical_area_norm(no_of_cells, 1:4) = quadrant_BB_count_at_max_apical_area_norm; Quad_arearate_max_apical_area_norm(no_of_cells, 1:4) = whole_quadrant_area_rates_at_max_apical_area_norm; Quad_BBdensity_at_max_apical_area_norm(no_of_cells, 1:4) = quad_BB_density_at_max_apical_area_norm;
                            Quad_actinMeanIntnorm_at_max_apical_area(no_of_cells, 1:4) = quad_actinMeanIntnorm_at_max_apical_area; Quad_actinTotalIntnorm_at_max_apical_area(no_of_cells, 1:4) = quad_actinTotalIntnorm_at_max_apical_area; Quad_NewBB_cumulative_count(no_of_cells, 1:4) = quadrant_total_NewBB_count_norm;
                            Half_areas_at_max_apical_area_norm(no_of_cells, 1:4) = half_areas_at_max_apical_area_norm; Half_BB_count_at_max_apical_area_norm(no_of_cells, 1:4) = half_BB_count_at_max_apical_area_norm; Half_area_rates_at_max_apical_area_norm(no_of_cells, 1:4) = whole_half_area_rates_at_max_apical_area_norm; Half_BB_density_at_max_apical_area_norm(no_of_cells, 1:4) = half_BB_density_at_max_apical_area_norm;
                            Half_actinMeanIntnorm_at_max_apical_area(no_of_cells, 1:4) = half_actinMeanIntnorm_at_max_apical_area; Half_actinTotalIntnorm_at_max_apical_area(no_of_cells, 1:4) = half_actinTotalIntnorm_at_max_apical_area; Half_NewBB_cumulative_count(no_of_cells, 1:4) = half_total_NewBB_count_norm;
                            clear quadrant_areas_at_max_apical_area_norm quadrant_BB_count_at_max_apical_area_norm whole_quadrant_area_rates_at_max_apical_area_norm quad_BB_density_at_max_apical_area_norm quad_actinMeanIntnorm_at_max_apical_area quad_actinTotalIntnorm_at_max_apical_area quadrant_total_NewBB_count_norm quadrant_area_reordered quadrant_BBs_reordered quad_area_rate_reordered quadrant_bb_density_for_plot_reordered quad_halves_meanint_norm_reordered quad_halves_totalint_norm_reordered ...
                                quadrant_new_BBs_reordered quadrant_area_reordered_norm quadrant_BBs_reordered_norm quad_area_rate_reordered_norm quadrant_bb_density_for_plot_reordered_norm quadrant_new_BBs_reordered_norm clumpingfactor_area clumpingfactor_area_max_apical_area clumpingfactor_arearate clumpingfactor_arearate_max_apical_area clumpingfactor_bbcount clumpingfactor_bbcount_max_apical_area clumpingfactor_bbddensity clumpingfactor_bbddensity_max_apical_area clumpingfactor_meanint clumpingfactor_meanint_max_apical_area clumpingfactor_totalint clumpingfactor_totalint_max_apical_area clumpingfactor_newBBcount clumpingfactor_newBBcount_max_apical_area...
                                half_areas_at_max_apical_area_norm half_BB_count_at_max_apical_area_norm whole_half_area_rates_at_max_apical_area_norm half_BB_density_at_max_apical_area_norm half_actinMeanIntnorm_at_max_apical_area half_actinTotalIntnorm_at_max_apical_area half_total_NewBB_count_norm

                            name{1, no_of_cells} = strcat(subfolders_1{i},'_', subfolders_2{j}, '_', subfolders_3{k});
                            % ============loading all the required parameters from different cells============%
                            % ================================================================================%
                        end
                    end
                end
            end
        end
    end
end

%% Data Curation
% In this section, we make changes like zero to nanconversions and adjusting lengths of different parameters to their corresponding areas and time.
% Below we are changing all zeros to nans in the below matrices. We are sure that there are no zeros in these matrices other than those zeros coming from the concatenation of different arrays with different lengths.
timelist(timelist==0) = nan;  area_apicaldomain(area_apicaldomain==0) = nan; Residual_Area(Residual_Area==0) = nan; Residual_Area_percent(Residual_Area_percent==0) = nan; BB_area(BB_area==0) = nan; BB_area_percent(BB_area_percent==0) = nan; Sum_of_Residual_bb_areas_percent(Sum_of_Residual_bb_areas_percent==0) = nan; isotropicity(isotropicity==0) = nan; circularity(circularity==0) = nan;
meanintensity_apicaldomain(meanintensity_apicaldomain==0) = nan; totalintensity_apicaldomain(totalintensity_apicaldomain==0) = nan; Area_rate(Area_rate==0) = nan; Norm_Area_rate(Norm_Area_rate==0) = nan; t0_time(t0_time==0) = nan; area_t0_bb(area_t0_bb==0) = nan; % NEW_BB_entry_count = NEW_BB_entry_count(NEW_BB_entry_count~=0); NEW_BB_exit_count = NEW_BB_exit_count(NEW_BB_exit_count~=0);
bbEntry_rate(bbEntry_rate==0) = nan; bbEntryFlux(bbEntryFlux==0) = nan; tend_time(tend_time==0) = nan; area_tend_bb(area_tend_bb==0) = nan; bbExit_rate(bbExit_rate==0) = nan;
bbExitFlux(bbExitFlux==0) = nan;  BB_density_norm(BB_density_norm==0) = nan; Mintd(Mintd==0) = nan; Local_Clustering(Local_Clustering==0) = nan; Global_Clustering(Global_Clustering==0) = nan; Area_Clustering(Area_Clustering==0) = nan; Time_Clustering(Time_Clustering==0) = nan;
BB_density_norm_modified = arrayfun(@(x,y) (y~=0).*((x<=y).*x + (x>y).*(y/2)) + (y==0).*x, BB_density_norm, no_of_bb); % This condition is introduced here because, during initial times / smaller areas, while subtracting the initial area from the current area (to adjust area in a way that area starts from zero so that the relationship between BB density & area is ~ linear) the values can be super small that when they are used to divide the BB count in that frame, the resulting values is humngous (For ex: 5/0.0067).
% Therefore, to remove this artifact, we do the following: (1) if the value of 'BB_density_norm' is more than the corresponding value of 'no_of_bb', then it is replaced by half of the corresponding value of 'no_of_bb'; (2) if value of 'BB_density_norm' is less than the corresponding value of 'no_of_bb', then the value in 'BB_density_norm' is retained; (3) if 'no_of_bb' is zero, then the value in 'BB_density_norm' is retained;
Variance_voronoi_fin_all(Variance_voronoi_fin_all==0) = nan; Variance_voronoi_fin_norm_all(Variance_voronoi_fin_norm_all==0) = nan; time_Variancetessalation_all(time_Variancetessalation_all==0) = nan; Area_apicaldomain_Variancetessalation_all(Area_apicaldomain_Variancetessalation_all==0) = nan; No_of_BB_Variancetessalation_all(No_of_BB_Variancetessalation_all==0) = nan;
Variance_voronoi_fin_edge_removed(Variance_voronoi_fin_edge_removed==0) = nan; Variance_voronoi_fin_norm_edge_removed(Variance_voronoi_fin_norm_edge_removed==0) = nan; time_Variancetessalation_edge_removed(time_Variancetessalation_edge_removed==0) = nan; Area_apicaldomain_Variancetessalation_edge_removed(Area_apicaldomain_Variancetessalation_edge_removed==0) = nan; No_of_BB_Variancetessalation_edge_removed(No_of_BB_Variancetessalation_edge_removed==0) = nan;
Drift_time(Drift_time==0) = nan; Distn_in_micron(Distn_in_micron==0) = nan; BB_dist_barplot(BB_dist_barplot==0) = nan;
MSD_xaxis(MSD_xaxis==0) = nan; MSD_xaxis_min(MSD_xaxis_min==0) = nan; MSD_yaxis(MSD_yaxis==0) = nan;
new_vs_exist_bb_min_dist(new_vs_exist_bb_min_dist==0) = nan; new_vs_exist_bb_min_dist_area(new_vs_exist_bb_min_dist_area==0) = nan; new_vs_exist_bb_min_dist_time(new_vs_exist_bb_min_dist_time==0) = nan; new_vs_exist_bb_all_dist(new_vs_exist_bb_all_dist==0) = nan; new_vs_exist_bb_all_dist_area(new_vs_exist_bb_all_dist_area==0) = nan; new_vs_exist_bb_all_dist_time(new_vs_exist_bb_all_dist_time==0) = nan;
neighbor_bb_min_dist(neighbor_bb_min_dist==0) = nan; neighbor_bb_min_dist_area(neighbor_bb_min_dist_area==0) = nan; neighbor_bb_min_dist_time(neighbor_bb_min_dist_time==0) = nan; neighbor_bb_all_dist(neighbor_bb_all_dist==0) = nan; neighbor_bb_all_dist_area(neighbor_bb_all_dist_area==0) = nan; neighbor_bb_all_dist_time(neighbor_bb_all_dist_time==0) = nan;
meanint_atBBpos_1stframe(meanint_atBBpos_1stframe==0) = nan; meanint_atBBpos_maxapicalarea(meanint_atBBpos_maxapicalarea==0) = nan; totalint_atBBpos_1stframe(totalint_atBBpos_1stframe==0) = nan; totalint_atBBpos_maxapicalarea(totalint_atBBpos_maxapicalarea==0) = nan; meanint_atBBSurr_1stframe(meanint_atBBSurr_1stframe==0) = nan; meanint_atBBSurr_maxapicalarea(meanint_atBBSurr_maxapicalarea==0) = nan;
totalint_atBBSurr_1stframe(totalint_atBBSurr_1stframe==0) = nan; totalint_atBBSurr_maxapicalarea(totalint_atBBSurr_maxapicalarea==0) = nan; meanint_ratio_BBSurPos_1stframe(meanint_ratio_BBSurPos_1stframe==0) = nan; meanint_ratio_BBSurPos_maxapicalarea(meanint_ratio_BBSurPos_maxapicalarea==0) = nan; totalint_ratio_BBSurPos_1stframe(totalint_ratio_BBSurPos_1stframe==0) = nan; totalint_ratio_BBSurPos_maxapicalarea(totalint_ratio_BBSurPos_maxapicalarea==0) = nan;

if exist('contour_dist_1to150um2', 'var') % works only for control data and not for alphaActininMO since this analysis is not done for alphaActininMO
    contour_dist_1to150um2_linearised = nonzeros(contour_dist_1to150um2); contour_dist_150um2_finalarea_linearised = nonzeros(contour_dist_150um2_finalarea); contour_dist_25pct_linearised = nonzeros(contour_dist_25pct); contour_dist_50pct_linearised = nonzeros(contour_dist_50pct); contour_dist_75pct_linearised = nonzeros(contour_dist_75pct); contour_dist_100pct_linearised = nonzeros(contour_dist_100pct);endtoend_dist_1to150um2_linearised = nonzeros(endtoend_dist_1to150um2);
    endtoend_dist_150um2_finalarea_linearised = nonzeros(endtoend_dist_150um2_finalarea); endtoend_dist_25pct_linearised = nonzeros(endtoend_dist_25pct); endtoend_dist_50pct_linearised = nonzeros(endtoend_dist_50pct); endtoend_dist_75pct_linearised = nonzeros(endtoend_dist_75pct); endtoend_dist_100pct_linearised = nonzeros(endtoend_dist_100pct); Tortuosity_Earlyexpansion_linearised = nonzeros(Tortuosity_Earlyexpansion); Tortuosity_Lateexpansion_linearised = nonzeros(Tortuosity_Lateexpansion);
    Tortuosity_25PercentArea_linearised = nonzeros(Tortuosity_25PercentArea); Tortuosity_50PercentArea_linearised = nonzeros(Tortuosity_50PercentArea); Tortuosity_75PercentArea_linearised = nonzeros(Tortuosity_75PercentArea); Tortuosity_100PercentArea_linearised = nonzeros(Tortuosity_100PercentArea);
end

% Below we use a function that pads vectors with NaNs to bring them to same size
[MeanInt_atBBpos_traj_atmaxarea_only] = nan_padding(meanint_atBBpos_Traj_atMaxArea_Only); [TotalInt_atBBpos_traj_atmaxarea_only] = nan_padding(totalint_atBBpos_Traj_atMaxArea_Only);
[MeanInt_atBBSurr_traj_atmaxarea_only] = nan_padding(meanint_atBBSurr_Traj_atMaxArea_Only); [TotalInt_atBBSurr_traj_atmaxarea_only] = nan_padding(totalint_atBBSurr_Traj_atMaxArea_Only);
[MeanInt_BB_SurPos_ratio_traj_atmaxarea_only] = nan_padding(meanint_BB_SurPos_ratio_Traj_atMaxArea_Only); [TotalInt_BB_SurPos_ratio_traj_atmaxarea_only] = nan_padding(totalint_BB_SurPos_ratio_Traj_atMaxArea_Only);
[MeanInt_atBBpos_traj_atmaxarea_only_aligned] = nan_padding(meanint_BBpos_Traj_atMaxArea_Only_Aligned); [TotalInt_atBBpos_traj_atmaxarea_only_aligned] = nan_padding(totalint_BBpos_Traj_atMaxArea_Only_Aligned);
[MeanInt_atBBSurr_traj_atmaxarea_only_aligned] = nan_padding(meanint_BBSurr_Traj_atMaxArea_Only_Aligned); [TotalInt_atBBSurr_traj_atmaxarea_only_aligned] = nan_padding(totalint_BBSurr_Traj_atMaxArea_Only_Aligned);
[MeanInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned] = nan_padding(meanint_BB_SurPos_ratio_Traj_atMaxArea_Only_Aligned); [TotalInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned] = nan_padding(totalint_BB_SurPos_ratio_Traj_atMaxArea_Only_Aligned);
[TimeList_Clone_traj_atmaxarea_only] = nan_padding(Timelist_clone_Traj_atMaxArea_Only); [Area_ApicalDomain_clone_traj_atmaxarea_only] = nan_padding(Area_apicaldomain_clone_Traj_atMaxArea_Only);
[step_dist_fin] = nan_padding(step_dist_mod); [inst_speed_fin] = nan_padding(inst_speed_mod);
[step_x_dist_fin] = nan_padding(step_x_dist_mod); [step_y_dist_fin] = nan_padding(step_y_dist_mod); [step_x_y_dist_fin] = nan_padding(step_x_y_dist_mod);
[new_BB_appearance_all_dist_fin] = nan_padding(new_BB_appearance_all_dist); [new_BB_appearance_all_dist_area_fin] = nan_padding(new_BB_appearance_all_dist_area); [new_BB_appearance_all_dist_time_fin] = nan_padding(new_BB_appearance_all_dist_time);
Avg_NewNewBB_MinDist = cell2mat(Avg_New_New_bb_mindist(:)); Avg_NewNewBB_AllDist = cell2mat(Avg_New_New_bb_alldist(:)); Avg_NewExistBB_MinDist = cell2mat(Avg_New_Exist_bb_mindist(:)); Avg_NewExistBB_AllDist = cell2mat(Avg_New_Exist_bb_alldist(:)); Avg_NearNeighbourBB_MinDist = cell2mat(Avg_near_neighbour_bb_mindist(:)); Avg_ExistBB_AllDist = cell2mat(Avg_exist_bb_alldist(:)); % linearising all these arrows
[ContourLength_fin] = nan_padding(ContourLength); [EndToEndLength_fin] = nan_padding(EndToEndLength); [Tortuosity_fin] = nan_padding(Tort); [Dotp_fin] = nan_padding(Dotp);
% for the array "no_of_bb", changing zeros to nans is done bit differently. Because there are zeros which should not be converted to nans. These are the zeros which
% correspond to those frames where there are no basal bodies. So these zeros are different from the zeros that are created because of difference in the length of arrays
% between different cells. Therefore we need to make sure that only those zeros coming from the difference in array lengths are converted to nans and the other zeros remain as such.
% to understand this logic, implement the example of Madhan ravi from this link (https://se.mathworks.com/matlabcentral/answers/554263-replacing-values-in-matrix-with-nan-s-based-on-row-and-column)
[no_of_bb] = nanconversion(no_of_bb, area_apicaldomain); % calling the function that converts the zeros (coming from difference in column length) to nans.
% applying the same logic to other similar arrays - to make sure only those zeros coming from the difference in length of arrays are converted to nans.
% adjusting the time & area for BB density
BB_density_norm(BB_density_norm==Inf) = nan;
timelist_bbDensity = timelist;
area_bbDensity = area_apicaldomain;
[timelist_bbDensity] = nanconversion(timelist_bbDensity, BB_density_norm); % calling the function that converts the zeros (coming from difference in column length) to nans.
[area_bbDensity] = nanconversion(area_bbDensity, BB_density_norm); % calling the function that converts the zeros (coming from difference in column length) to nans.
% adjusting the time & area for BB mean interdistance (density based)
timelist_bbmintd = timelist;
area_bbmintd = area_apicaldomain;
[timelist_bbmintd] = nanconversion(timelist_bbmintd, Mintd); % calling the function that converts the zeros (coming from difference in column length) to nans.
[area_bbmintd] = nanconversion(area_bbmintd, Mintd); % calling the function that converts the zeros (coming from difference in column length) to nans.
% adjusting the area, time, new bb entry count & new bb exit count
[NEW_BB_entry_count] = nanconversion(NEW_BB_entry_count, area_apicaldomain(1:size(NEW_BB_entry_count,1),:)); % calling the function that converts the zeros (coming from difference in column length) to nans.
area_NEW_BB_entry_count = area_apicaldomain(1:size(NEW_BB_entry_count,1),:);
area_NEW_BB_entry_count(NEW_BB_entry_count==0) = 0;
timelist_NEW_BB_entry_count = timelist(1:size(NEW_BB_entry_count,1),:);
timelist_NEW_BB_entry_count(NEW_BB_entry_count==0) = 0;
%NEW_BB_entry_count(NEW_BB_entry_count==0) = nan; area_NEW_BB_entry_count(area_NEW_BB_entry_count==0) = nan; timelist_NEW_BB_entry_count(timelist_NEW_BB_entry_count==0) = nan;
[NEW_BB_exit_count] = nanconversion(NEW_BB_exit_count, area_apicaldomain(1:size(NEW_BB_exit_count,1),:)); % calling the function that converts the zeros (coming from difference in column length) to nans.
area_NEW_BB_exit_count = area_apicaldomain(1:size(NEW_BB_exit_count,1),:);
area_NEW_BB_exit_count(NEW_BB_exit_count==0) = 0;
timelist_NEW_BB_exit_count = timelist(1:size(NEW_BB_exit_count,1),:);
timelist_NEW_BB_exit_count(NEW_BB_exit_count==0) = 0;
%NEW_BB_exit_count(NEW_BB_exit_count==0) = nan; area_NEW_BB_exit_count(area_NEW_BB_exit_count==0) = nan; timelist_NEW_BB_exit_count(timelist_NEW_BB_exit_count==0) = nan;
% adjusting the x & y drift vectors
[Drift_xmean] = nanconversion(Drift_xmean, Drift_time); % calling the function that converts the zeros (coming from difference in column length) to nans.
[Drift_ymean] = nanconversion(Drift_ymean, Drift_time); % calling the function that converts the zeros (coming from difference in column length) to nans.
% adjusting the area for area rate
sz_area_rate = size(Area_rate,1); sz_area = size(area_apicaldomain,1); strt_value = sz_area - sz_area_rate + 1;
Area_area_rate = area_apicaldomain(strt_value:end, :);
[Area_area_rate] = nanconversion(Area_area_rate, Area_rate); % calling the function that converts the zeros (coming from difference in column length) to nans.
% adjusting the time for area rate
timelist_area_rate = timelist(strt_value:end, :);
[timelist_area_rate] = nanconversion(timelist_area_rate, Area_rate); % calling the function that converts the zeros (coming from difference in column length) to nans.
clear sz_area_rate sz_area strt_value
% adjusting the time & area for variance in tessalation areas
time_variance_tessalation_all = time_Variancetessalation_all;
area_variance_tessalation_all = Area_apicaldomain_Variancetessalation_all;
no_of_bb_variance_tessalation_all = No_of_BB_Variancetessalation_all;
[time_variance_tessalation_all] = nanconversion(time_variance_tessalation_all, Variance_voronoi_fin_norm_all); % calling the function that converts the zeros (coming from difference in column length) to nans.
[area_variance_tessalation_all] = nanconversion(area_variance_tessalation_all, Variance_voronoi_fin_norm_all); % calling the function that converts the zeros (coming from difference in column length) to nans.
[no_of_bb_variance_tessalation_all] = nanconversion(no_of_bb_variance_tessalation_all, Variance_voronoi_fin_norm_all); % calling the function that converts the zeros (coming from difference in column length) to nans.
time_variance_tessalation_edge_removed = time_Variancetessalation_edge_removed;
area_variance_tessalation_edge_removed = Area_apicaldomain_Variancetessalation_edge_removed;
no_of_bb_variance_tessalation_edge_removed = No_of_BB_Variancetessalation_edge_removed;
[time_variance_tessalation_edge_removed] = nanconversion(time_variance_tessalation_edge_removed, Variance_voronoi_fin_norm_edge_removed); % calling the function that converts the zeros (coming from difference in column length) to nans.
[area_variance_tessalation_edge_removed] = nanconversion(area_variance_tessalation_edge_removed, Variance_voronoi_fin_norm_edge_removed); % calling the function that converts the zeros (coming from difference in column length) to nans.
[no_of_bb_variance_tessalation_edge_removed] = nanconversion(no_of_bb_variance_tessalation_edge_removed, Variance_voronoi_fin_norm_edge_removed); % calling the function that converts the zeros (coming from difference in column length) to nans.
% adjusting the MSD x axis & for MSD y axis
msd_xaxis = MSD_xaxis;
msd_xaxis_min = MSD_xaxis_min;
[msd_xaxis] = nanconversion(msd_xaxis, MSD_yaxis); % calling the function that converts the zeros (coming from difference in column length) to nans.
[msd_xaxis_min] = nanconversion(msd_xaxis_min, MSD_yaxis); % calling the function that converts the zeros (coming from difference in column length) to nans.
% adjusting the Minimum new BB appearance distance and neighbor distance
[new_vs_exist_bb_min_dist_area] = nanconversion(new_vs_exist_bb_min_dist_area, new_vs_exist_bb_min_dist);
[new_vs_exist_bb_min_dist_time] = nanconversion(new_vs_exist_bb_min_dist_time, new_vs_exist_bb_min_dist);
[new_vs_exist_bb_min_dist_bbcount] = nanconversion(new_vs_exist_bb_min_dist_bbcount, new_vs_exist_bb_min_dist);
new_vs_exist_bb_min_dist_bbdensity = new_vs_exist_bb_min_dist_bbcount./new_vs_exist_bb_min_dist_area;
[neighbor_bb_min_dist_area] = nanconversion(neighbor_bb_min_dist_area, neighbor_bb_min_dist);
[neighbor_bb_min_dist_time] = nanconversion(neighbor_bb_min_dist_time, neighbor_bb_min_dist);
[neighbor_bb_min_dist_bbcount] = nanconversion(neighbor_bb_min_dist_bbcount, neighbor_bb_min_dist);
neighbor_bb_min_dist_bbdensity = neighbor_bb_min_dist_bbcount./neighbor_bb_min_dist_area;

% Quadrant, top/bottom halves & left/right halves data curation
% Below we use different functions to make cell arrays for quadrant and half data for both absolute and half data
ClumpingFactor_Area(ClumpingFactor_Area==0) = nan; ClumpingFactor_AreaRate(ClumpingFactor_AreaRate==0) = nan; ClumpingFactor_BBCount(ClumpingFactor_BBCount==0) = nan; ClumpingFactor_BBDensity(ClumpingFactor_BBDensity==0) = nan; ClumpingFactor_MeanInt(ClumpingFactor_MeanInt==0) = nan; ClumpingFactor_TotalInt(ClumpingFactor_TotalInt==0) = nan; ClumpingFactor_NewBBCount(ClumpingFactor_NewBBCount==0) = nan;
% below we use the function 'cell_to_array' that extracts the parameter after converting cell array to standard array
[Quad_timelist] = cell_to_array(Quad_Area, 1); % the number '1' corresponds to the time in the array 'Quad_Area'
[Quad_apical_area_list] = cell_to_array(Quad_Area, 2); % the number '2' corresponds to the apical area in the array 'Quad_Area'
% absolute values of parameters for quadrants
[Quad_areas_quadrant_1] = cell_to_array(Quad_Area, 3); [Quad_areas_quadrant_2] = cell_to_array(Quad_Area, 4); [Quad_areas_quadrant_3] = cell_to_array(Quad_Area, 5); [Quad_areas_quadrant_4] = cell_to_array(Quad_Area, 6); % the numbers '3', '4', '5', '6' on the RHS correspond to the columns containing the area of four individual quadrants in the array 'Quad_Area' for all time points
all_quad_areas = {Quad_areas_quadrant_1, Quad_areas_quadrant_2, Quad_areas_quadrant_3, Quad_areas_quadrant_4};
[Quad_BBcount_quadrant_1] = cell_to_array(Quad_BBcount, 3); [Quad_BBcount_quadrant_2] = cell_to_array(Quad_BBcount, 4); [Quad_BBcount_quadrant_3] = cell_to_array(Quad_BBcount, 5); [Quad_BBcount_quadrant_4] = cell_to_array(Quad_BBcount, 6); % the numbers '3', '4', '5', '6' on the RHS correspond to the columns containing the BB counts in each of the four quadrants from the array 'Quad_BBcount' for all time points
all_quad_BBcount = {Quad_BBcount_quadrant_1, Quad_BBcount_quadrant_2, Quad_BBcount_quadrant_3, Quad_BBcount_quadrant_4};
[Quad_AreaRate_quadrant_1] = cell_to_array(Quad_arearate, 3); [Quad_AreaRate_quadrant_2] = cell_to_array(Quad_arearate, 4); [Quad_AreaRate_quadrant_3] = cell_to_array(Quad_arearate, 5); [Quad_AreaRate_quadrant_4] = cell_to_array(Quad_arearate, 6); % the numbers '3', '4', '5', '6' on the RHS correspond to the columns containing the rate of area expansion of the four individual quadrants from the array 'Quad_arearate' for all time points
all_quad_AreaRate = {Quad_AreaRate_quadrant_1, Quad_AreaRate_quadrant_2, Quad_AreaRate_quadrant_3, Quad_AreaRate_quadrant_4};
[Quad_BBdensity_quadrant_1] = cell_to_array(Quad_bbdensity, 3); [Quad_BBdensity_quadrant_2] = cell_to_array(Quad_bbdensity, 4); [Quad_BBdensity_quadrant_3] = cell_to_array(Quad_bbdensity, 5); [Quad_BBdensity_quadrant_4] = cell_to_array(Quad_bbdensity, 6); % the numbers '3', '4', '5', '6' on the RHS correspond to the columns containing the BB density for the four individual quadrants from the array 'Quad_bbdensity' for all time points
all_quad_BBdensity = {Quad_BBdensity_quadrant_1, Quad_BBdensity_quadrant_2, Quad_BBdensity_quadrant_3, Quad_BBdensity_quadrant_4};
all_quad_BBdensity_modified = cellfun(@(x,y) (y~=0).*((x<=y).*x + (x>y).*(y/2)) + (y==0).*x, all_quad_BBdensity, all_quad_BBcount, 'UniformOutput', false); % This condition is introduced here because, during initial times / smaller areas, while subtracting the initial area from the current area (to adjust area in a way that area starts from zero so that the relationship between BB density & area is ~ linear) the values can be super small that when they are used to divide the BB count in that frame, the resulting values is humngous (For ex: 5/0.0067).
% Therefore, to remove this artifact, we do the following: (1) if the value of 'all_quad_BBdensity' is more than the corresponding value of 'all_quad_BBcount', then it is replaced by half of the corresponding value of 'all_quad_BBcount'; (2) if value of 'all_quad_BBdensity' is less than the corresponding value of 'all_quad_BBcount', then the value in 'all_quad_BBdensity' is retained; (3) if 'all_quad_BBcount' is zero, then the value in 'all_quad_BBdensity' is retained;
[Quad_newBBs_quadrant_1] = cell_to_array(Quad_newBBs, 3); [Quad_newBBs_quadrant_2] = cell_to_array(Quad_newBBs, 4); [Quad_newBBs_quadrant_3] = cell_to_array(Quad_newBBs, 5); [Quad_newBBs_quadrant_4] = cell_to_array(Quad_newBBs, 6); % the numbers '3', '4', '5', '6' on the RHS correspond to the columns containing the count of newly appearing BBs for the four individual quadrants from the array 'Quad_newBBs' for all time points
all_quad_newBBs = {Quad_newBBs_quadrant_1, Quad_newBBs_quadrant_2, Quad_newBBs_quadrant_3, Quad_newBBs_quadrant_4};
% normalised values of parameters for quadrants
[Quad_areas_quadrant_1_norm] = cell_to_array(Quad_Area_norm, 3); [Quad_areas_quadrant_2_norm] = cell_to_array(Quad_Area_norm, 4); [Quad_areas_quadrant_3_norm] = cell_to_array(Quad_Area_norm, 5); [Quad_areas_quadrant_4_norm] = cell_to_array(Quad_Area_norm, 6); % the numbers '3', '4', '5', '6' on the RHS correspond to the columns containing the area of four individual quadrants in the array 'Quad_Area_norm' for all time points
all_quad_areas_norm = {Quad_areas_quadrant_1_norm, Quad_areas_quadrant_2_norm, Quad_areas_quadrant_3_norm, Quad_areas_quadrant_4_norm};
[Quad_BBcount_quadrant_1_norm] = cell_to_array(Quad_BBcount_norm, 3); [Quad_BBcount_quadrant_2_norm] = cell_to_array(Quad_BBcount_norm, 4); [Quad_BBcount_quadrant_3_norm] = cell_to_array(Quad_BBcount_norm, 5); [Quad_BBcount_quadrant_4_norm] = cell_to_array(Quad_BBcount_norm, 6); % the numbers '3', '4', '5', '6' on the RHS correspond to the columns containing the BB counts in each of the four quadrants from the array 'Quad_BBcount_norm' for all time points
all_quad_BBcount_norm = {Quad_BBcount_quadrant_1_norm, Quad_BBcount_quadrant_2_norm, Quad_BBcount_quadrant_3_norm, Quad_BBcount_quadrant_4_norm};
[Quad_AreaRate_quadrant_1_norm] = cell_to_array(Quad_arearate_norm, 3); [Quad_AreaRate_quadrant_2_norm] = cell_to_array(Quad_arearate_norm, 4); [Quad_AreaRate_quadrant_3_norm] = cell_to_array(Quad_arearate_norm, 5); [Quad_AreaRate_quadrant_4_norm] = cell_to_array(Quad_arearate_norm, 6); % the numbers '3', '4', '5', '6' on the RHS correspond to the columns containing the rate of area expansion of the four individual quadrants from the array 'Quad_arearate_norm' for all time points
all_quad_AreaRate_norm = {Quad_AreaRate_quadrant_1_norm, Quad_AreaRate_quadrant_2_norm, Quad_AreaRate_quadrant_3_norm, Quad_AreaRate_quadrant_4_norm};
[Quad_BBdensity_quadrant_1_norm] = cell_to_array(Quad_bbdensity_norm, 3); [Quad_BBdensity_quadrant_2_norm] = cell_to_array(Quad_bbdensity_norm, 4); [Quad_BBdensity_quadrant_3_norm] = cell_to_array(Quad_bbdensity_norm, 5); [Quad_BBdensity_quadrant_4_norm] = cell_to_array(Quad_bbdensity_norm, 6); % the numbers '3', '4', '5', '6' on the RHS correspond to the columns containing the BB density for the four individual quadrants from the array 'Quad_bbdensity_norm' for all time points
all_quad_BBdensity_norm = {Quad_BBdensity_quadrant_1_norm, Quad_BBdensity_quadrant_2_norm, Quad_BBdensity_quadrant_3_norm, Quad_BBdensity_quadrant_4_norm};
all_quad_BBdensity_norm_modified = cellfun(@(x,y) (y~=0).*((x<=y).*x + (x>y).*(y/2)) + (y==0).*x, all_quad_BBdensity_norm, all_quad_BBcount_norm, 'UniformOutput', false); % This condition is introduced here because, during initial times / smaller areas, while subtracting the initial area from the current area (to adjust area in a way that area starts from zero so that the relationship between BB density & area is ~ linear) the values can be super small that when they are used to divide the BB count in that frame, the resulting values is humngous (For ex: 5/0.0067).
% Therefore, to remove this artifact, we do the following: (1) if the value of 'all_quad_BBdensity_norm' is more than the corresponding value of 'all_quad_BBcount_norm', then it is replaced by half of the corresponding value of 'all_quad_BBcount_norm'; (2) if value of 'all_quad_BBdensity_norm' is less than the corresponding value of 'all_quad_BBcount_norm', then the value in 'all_quad_BBdensity_norm' is retained; (3) if 'all_quad_BBcount_norm' is zero, then the value in 'all_quad_BBdensity_norm' is retained;
[Quad_meanIntnorm_quadrant_1] = cell_to_array(Quad_meanIntnorm, 3); [Quad_meanIntnorm_quadrant_2] = cell_to_array(Quad_meanIntnorm, 4); [Quad_meanIntnorm_quadrant_3] = cell_to_array(Quad_meanIntnorm, 5); [Quad_meanIntnorm_quadrant_4] = cell_to_array(Quad_meanIntnorm, 6); % the numbers '3', '4', '5', '6' on the RHS correspond to the columns containing the mean actin intensity for the four individual quadrants from the array 'Quad_meanIntnorm' for all time points
all_quad_meanIntnorm = {Quad_meanIntnorm_quadrant_1, Quad_meanIntnorm_quadrant_2, Quad_meanIntnorm_quadrant_3, Quad_meanIntnorm_quadrant_4};
[Quad_totalIntnorm_quadrant_1] = cell_to_array(Quad_totalIntnorm, 3); [Quad_totalIntnorm_quadrant_2] = cell_to_array(Quad_totalIntnorm, 4); [Quad_totalIntnorm_quadrant_3] = cell_to_array(Quad_totalIntnorm, 5); [Quad_totalIntnorm_quadrant_4] = cell_to_array(Quad_totalIntnorm, 6); % the numbers '3', '4', '5', '6' on the RHS correspond to the columns containing the total actin intensity for the four individual quadrants from the array 'Quad_totalIntnorm' for all time points
all_quad_totalIntnorm = {Quad_totalIntnorm_quadrant_1, Quad_totalIntnorm_quadrant_2, Quad_totalIntnorm_quadrant_3, Quad_totalIntnorm_quadrant_4};
[Quad_newBBs_norm_quadrant_1] = cell_to_array(Quad_newBBs_norm, 3); [Quad_newBBs_norm_quadrant_2] = cell_to_array(Quad_newBBs_norm, 4); [Quad_newBBs_norm_quadrant_3] = cell_to_array(Quad_newBBs_norm, 5); [Quad_newBBs_norm_quadrant_4] = cell_to_array(Quad_newBBs_norm, 6); % the numbers '3', '4', '5', '6' on the RHS correspond to the columns containing the count of newly appearing BBs for the four individual quadrants from the array 'Quad_newBBsnorm' for all time points
all_quad_newBBs_norm = {Quad_newBBs_norm_quadrant_1, Quad_newBBs_norm_quadrant_2, Quad_newBBs_norm_quadrant_3, Quad_newBBs_norm_quadrant_4};
% absolute values of parameters for the halves
[Half_areas_half_1] = cell_to_array(Quad_Area, 7); [Half_areas_half_2] = cell_to_array(Quad_Area, 8); [Half_areas_half_3] = cell_to_array(Quad_Area, 9); [Half_areas_half_4] = cell_to_array(Quad_Area, 10); % the numbers '7' & '8' correspond to the columns that contain area of top/bottom halfs in the array 'Quad_Area'; '7' & '8' corresponds to the smaller and larger halves (based on area) respectively
all_Half_areas = {Half_areas_half_1, Half_areas_half_2, Half_areas_half_3, Half_areas_half_4};
[Half_BBcount_half_1] = cell_to_array(Quad_BBcount, 7); [Half_BBcount_half_2] = cell_to_array(Quad_BBcount, 8); [Half_BBcount_half_3] = cell_to_array(Quad_BBcount, 9); [Half_BBcount_half_4] = cell_to_array(Quad_BBcount, 10); % the numbers '7' & '8' correspond to the columns that contain the BB count of top/bottom halfs in the array 'Quad_BBcount'; '7' & '8' corresponds to the smaller and larger halves (based on area) respectively
all_Half_BBcount = {Half_BBcount_half_1, Half_BBcount_half_2, Half_BBcount_half_3, Half_BBcount_half_4};
[Half_AreaRate_half_1] = cell_to_array(Quad_arearate, 7); [Half_AreaRate_half_2] = cell_to_array(Quad_arearate, 8); [Half_AreaRate_half_3] = cell_to_array(Quad_arearate, 9); [Half_AreaRate_half_4] = cell_to_array(Quad_arearate, 10); % the numbers '7' & '8' correspond to the columns that contain the area expansion rate of top/bottom halfs in the array 'Quad_arearate'; '7' & '8' corresponds to the smaller and larger halves (based on area) respectively
all_Half_AreaRate = {Half_AreaRate_half_1, Half_AreaRate_half_2, Half_AreaRate_half_3, Half_AreaRate_half_4};
[Half_BBdensity_half_1] = cell_to_array(Quad_bbdensity, 7); [Half_BBdensity_half_2] = cell_to_array(Quad_bbdensity, 8); [Half_BBdensity_half_3] = cell_to_array(Quad_bbdensity, 9); [Half_BBdensity_half_4] = cell_to_array(Quad_bbdensity, 10); % the numbers '7' & '8' correspond to the columns that contain the BB density of top/bottom halfs in the array 'Quad_bbdensity'; '7' & '8' corresponds to the smaller and larger halves (based on area) respectively
all_Half_BBdensity = {Half_BBdensity_half_1, Half_BBdensity_half_2, Half_BBdensity_half_3, Half_BBdensity_half_4};
all_Half_BBdensity_modified = cellfun(@(x,y) (y~=0).*((x<=y).*x + (x>y).*(y/2)) + (y==0).*x, all_Half_BBdensity, all_Half_BBcount, 'UniformOutput', false); % This condition is introduced here because, during initial times / smaller areas, while subtracting the initial area from the current area (to adjust area in a way that area starts from zero so that the relationship between BB density & area is ~ linear) the values can be super small that when they are used to divide the BB count in that frame, the resulting values is humngous (For ex: 5/0.0067).
% Therefore, to remove this artifact, we do the following: (1) if the value of 'all_Half_BBdensity' is more than the corresponding value of 'all_Half_BBcount', then it is replaced by half of the corresponding value of 'all_Half_BBcount'; (2) if value of 'all_Half_BBdensity' is less than the corresponding value of 'all_Half_BBcount', then the value in 'all_Half_BBdensity' is retained; (3) if 'all_Half_BBcount' is zero, then the value in 'all_Half_BBdensity' is retained;
[Half_newBBs_half_1] = cell_to_array(Quad_newBBs, 7); [Half_newBBs_half_2] = cell_to_array(Quad_newBBs, 8); [Half_newBBs_half_3] = cell_to_array(Quad_newBBs, 9); [Half_newBBs_half_4] = cell_to_array(Quad_newBBs, 10); % the numbers '7' & '8' correspond to the columns that contain the total actin intensity of top/bottom halfs in the array 'Quad_newBBs'; '7' & '8' corresponds to the smaller and larger halves (based on area) respectively
all_Half_newBBs = {Half_newBBs_half_1, Half_newBBs_half_2, Half_newBBs_half_3, Half_newBBs_half_4};
% normalised values of parameters for the halves
[Half_areas_half_1_norm] = cell_to_array(Quad_Area_norm, 7); [Half_areas_half_2_norm] = cell_to_array(Quad_Area_norm, 8); [Half_areas_half_3_norm] = cell_to_array(Quad_Area_norm, 9); [Half_areas_half_4_norm] = cell_to_array(Quad_Area_norm, 10); % the numbers '7' & '8' correspond to the columns that contain area of top/bottom halfs in the array 'Quad_Area_norm'; '7' & '8' corresponds to the smaller and larger halves (based on area) respectively
all_Half_areas_norm = {Half_areas_half_1_norm, Half_areas_half_2_norm, Half_areas_half_3_norm, Half_areas_half_4_norm};
[Half_BBcount_half_1_norm] = cell_to_array(Quad_BBcount_norm, 7); [Half_BBcount_half_2_norm] = cell_to_array(Quad_BBcount_norm, 8); [Half_BBcount_half_3_norm] = cell_to_array(Quad_BBcount_norm, 9); [Half_BBcount_half_4_norm] = cell_to_array(Quad_BBcount_norm, 10); % the numbers '7' & '8' correspond to the columns that contain the BB count of top/bottom halfs in the array 'Quad_BBcount_norm'; '7' & '8' corresponds to the smaller and larger halves (based on area) respectively
all_Half_BBcount_norm = {Half_BBcount_half_1_norm, Half_BBcount_half_2_norm, Half_BBcount_half_3_norm, Half_BBcount_half_4_norm};
[Half_AreaRate_half_1_norm] = cell_to_array(Quad_arearate_norm, 7); [Half_AreaRate_half_2_norm] = cell_to_array(Quad_arearate_norm, 8); [Half_AreaRate_half_3_norm] = cell_to_array(Quad_arearate_norm, 9); [Half_AreaRate_half_4_norm] = cell_to_array(Quad_arearate_norm, 10); % the numbers '7' & '8' correspond to the columns that contain the area expansion rate of top/bottom halfs in the array 'Quad_arearate_norm'; '7' & '8' corresponds to the smaller and larger halves (based on area) respectively
all_Half_AreaRate_norm = {Half_AreaRate_half_1_norm, Half_AreaRate_half_2_norm, Half_AreaRate_half_3_norm, Half_AreaRate_half_4_norm};
[Half_BBdensity_half_1_norm] = cell_to_array(Quad_bbdensity_norm, 7); [Half_BBdensity_half_2_norm] = cell_to_array(Quad_bbdensity_norm, 8); [Half_BBdensity_half_3_norm] = cell_to_array(Quad_bbdensity_norm, 9); [Half_BBdensity_half_4_norm] = cell_to_array(Quad_bbdensity_norm, 10); % the numbers '7' & '8' correspond to the columns that contain the BB density of top/bottom halfs in the array 'Quad_bbdensity_norm'; '7' & '8' corresponds to the smaller and larger halves (based on area) respectively
all_Half_BBdensity_norm = {Half_BBdensity_half_1_norm, Half_BBdensity_half_2_norm, Half_BBdensity_half_3_norm, Half_BBdensity_half_4_norm};
all_Half_BBdensity_norm_modified = cellfun(@(x,y) (y~=0).*((x<=y).*x + (x>y).*(y/2)) + (y==0).*x, all_Half_BBdensity_norm, all_Half_BBcount_norm, 'UniformOutput', false); % This condition is introduced here because, during initial times / smaller areas, while subtracting the initial area from the current area (to adjust area in a way that area starts from zero so that the relationship between BB density & area is ~ linear) the values can be super small that when they are used to divide the BB count in that frame, the resulting values is humngous (For ex: 5/0.0067).
% Therefore, to remove this artifact, we do the following: (1) if the value of 'all_Half_BBdensity_norm' is more than the corresponding value of 'all_Half_BBcount_norm', then it is replaced by half of the corresponding value of 'all_Half_BBcount_norm'; (2) if value of 'all_Half_BBdensity_norm' is less than the corresponding value of 'all_Half_BBcount_norm', then the value in 'all_Half_BBdensity_norm' is retained; (3) if 'all_Half_BBcount_norm' is zero, then the value in 'all_Half_BBdensity_norm' is retained;
[Half_meanIntnorm_half_1] = cell_to_array(Quad_meanIntnorm, 7); [Half_meanIntnorm_half_2] = cell_to_array(Quad_meanIntnorm, 8); [Half_meanIntnorm_half_3] = cell_to_array(Quad_meanIntnorm, 9); [Half_meanIntnorm_half_4] = cell_to_array(Quad_meanIntnorm, 10); % the numbers '7' & '8' correspond to the columns that contain the mean actin intensity of top/bottom halfs in the array 'Quad_meanIntnorm'; '7' & '8' corresponds to the smaller and larger halves (based on area) respectively
all_Half_meanIntnorm = {Half_meanIntnorm_half_1, Half_meanIntnorm_half_2, Half_meanIntnorm_half_3, Half_meanIntnorm_half_4};
[Half_totalIntnorm_half_1] = cell_to_array(Quad_totalIntnorm, 7); [Half_totalIntnorm_half_2] = cell_to_array(Quad_totalIntnorm, 8); [Half_totalIntnorm_half_3] = cell_to_array(Quad_totalIntnorm, 9); [Half_totalIntnorm_half_4] = cell_to_array(Quad_totalIntnorm, 10); % the numbers '7' & '8' correspond to the columns that contain the total actin intensity of top/bottom halfs in the array 'Quad_totalIntnorm'; '7' & '8' corresponds to the smaller and larger halves (based on area) respectively
all_Half_totalIntnorm = {Half_totalIntnorm_half_1, Half_totalIntnorm_half_2, Half_totalIntnorm_half_3, Half_totalIntnorm_half_4};
[Half_newBBs_norm_half_1] = cell_to_array(Quad_newBBs_norm, 7); [Half_newBBs_norm_half_2] = cell_to_array(Quad_newBBs_norm, 8); [Half_newBBs_norm_half_3] = cell_to_array(Quad_newBBs_norm, 9); [Half_newBBs_norm_half_4] = cell_to_array(Quad_newBBs_norm, 10); % the numbers '7' & '8' correspond to the columns that contain the total actin intensity of top/bottom halfs in the array 'Quad_newBBs_norm'; '7' & '8' corresponds to the smaller and larger halves (based on area) respectively
all_Half_newBBs_norm = {Half_newBBs_norm_half_1, Half_newBBs_norm_half_2, Half_newBBs_norm_half_3, Half_newBBs_norm_half_4};

cd(main_folder_link);

%% All plots

%------------------------------- Area, Time & BB count ---------------------------------%
% Area vs Time
area_data = area_apicaldomain; time_data = timelist; new_parameter = no_of_bb; % input parameters to the function 'area_time_shift'
[ar_dat, tme_dat, par_dat] = area_time_shift(area_data, time_data, new_parameter, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling function 'area_time_shift'
ar_dat(ar_dat==0) = nan; % changing all zeros to nans.
[tme_dat] = nanconversion(tme_dat, ar_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
% plots
XData = tme_dat; YData = ar_dat; Binparameter = XData; bininterval_for_Binparameter = 5; save_title = 'Area_vs_Time';
xLabel = 'Time [min]'; yLabel = 'Area [\mum^2]'; plot_Title = 'Area vs Time';
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, BB_apical_avg, save_title); % calling the function
clear XData YData Binparameter binned_xy

% BB count vs Area
par_dat(par_dat==0) = nan; % changing all zeros to nans.
[ar_dat] = nanconversion(ar_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
% plots
XData = ar_dat; YData = par_dat; Binparameter = XData; bininterval_for_Binparameter = 10; save_title = 'BB_count_vs_Area';
xLabel = 'Area [\mum^2]'; yLabel = 'BB count'; plot_Title = 'BB count vs Area';
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, BB_apical_avg, save_title); % calling the function
clear XData YData Binparameter binned_xy

% BB count vs Time
[tme_dat] = nanconversion(tme_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
% plots
XData = tme_dat; YData = par_dat; Binparameter = XData; bininterval_for_Binparameter = 5; save_title = 'BB_count_vs_Time';
xLabel = 'Time [min]'; yLabel = 'BB count'; plot_Title = 'BB count vs Time';
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, BB_apical_avg, save_title); % calling the function
clear area_data time_data new_parameter ar_dat tme_dat par_dat XData YData Binparameter binned_xy

%--------------------------- Isotropicity & Circularity -------------------------------------%

% Isotropicity vs Time
area_data = area_apicaldomain; time_data = timelist; new_parameter = isotropicity;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Isotropicity'; plot_Title_1 = 'Isotropicity of apical domain vs area'; save_title_1 = 'isotropicity_vs_area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Isotropicity'; plot_Title_2 = 'Isotropicity of apical domain vs Time'; save_title_2 = 'isotropicity_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_isotropicity_vs_area = binXY_parameter_vs_area; isotropicity_XData_area = XData_area; isotropicity_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Circularity vs Time
area_data = area_apicaldomain; time_data = timelist; new_parameter = circularity;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Circularity'; plot_Title_1 = 'Circularity of apical domain vs area'; save_title_1 = 'circularity_vs_area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Circularity'; plot_Title_2 = 'Circularity of apical domain vs Time'; save_title_2 = 'circularity_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_circularity_vs_area = binXY_parameter_vs_area; circularity_XData_area = XData_area; circularity_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

%--------------------------- Area contribution plots -------------------------------------%

% Residual Area (absolute) vs Time (Residual area is the area that do not contain BBs)
area_data = area_apicaldomain; time_data = timelist; new_parameter = Residual_Area; bininterval_for_Binparameter = 5;
xLabel = 'Time [min]'; yLabel = 'Area [\mum^2]'; plot_Title = {'Area expansion - contribution of Apical domain', '[absolute area value] vs Time'}; save_title = 'Area_contribution_apicaldomain_vs_Time';
[binned_xy] = parameter_vs_time(area_data, time_data, new_parameter, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, save_title, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling the function
clear area_data time_data new_parameter bininterval_for_Binparameter xLabel yLabel plot_Title save_title binned_xy

% BB Area (absolute) vs Time (BB area is the area occupied by the BBs)
area_data = area_apicaldomain; time_data = timelist; new_parameter = BB_area; bininterval_for_Binparameter = 5;
xLabel = 'Time [min]'; yLabel = 'Area [\mum^2]'; plot_Title = {'Area expansion - contribution of BB', '[absolute area value] vs Time'}; save_title = 'Area_contribution_BB_vs_Time';
[binned_xy] = parameter_vs_time(area_data, time_data, new_parameter, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, save_title, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling the function
clear area_data time_data new_parameter bininterval_for_Binparameter xLabel yLabel plot_Title save_title binned_xy
% -------------- % -------------- %
% combining the area (absolute) contribution plots
plot_name = fullfile(BB_apical_avg, 'Area_contribution_apicaldomain_vs_Time'); %
q1 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q1_1 = findobj(q1, 'type', 'Patch'); q1_1.FaceColor = 'm'; q1_1.EdgeColor = 'm'; q1_2 = findobj(q1, 'type', 'line'); q1_2.Color = 'm';
q11 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q11); q11_1 = gca; set(q11_1.Children, 'Color', 'm');
q111 = openfig(strcat(plot_name, '_collective_plot', '.fig')); figure(q111); q111_1 = gca; set(q111_1.Children, 'Color', 'm');
delete(strcat(plot_name, '_collective_plot', '.fig')); delete(strcat(plot_name, '_avg_plot_shaded', '.fig')); delete(strcat(plot_name, '_avg_plot_errorbar', '.fig')); delete(strcat(plot_name, '_collective_plot', '.tif')); delete(strcat(plot_name, '_avg_plot_shaded', '.tif')); delete(strcat(plot_name, '_avg_plot_errorbar', '.tif'));

plot_name = fullfile(BB_apical_avg, 'Area_contribution_BB_vs_Time'); %
q2 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q2_1 = findobj(q2, 'type', 'Patch'); q2_1.FaceColor = 'b'; q2_1.EdgeColor = 'b'; q2_2 = findobj(q2, 'type', 'line'); q2_2.Color = 'b'; copyobj(get(gca(q2), 'Children'), gca(q1));
q12 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q12); q12_1 = gca; set(q12_1.Children, 'Color', 'b'); copyobj(get(q12_1, 'Children'), gca(q11));
q122 = openfig(strcat(plot_name, '_collective_plot', '.fig')); figure(q122); q122_1 = gca; set(q122_1.Children, 'Color', 'b'); copyobj(get(q122_1, 'Children'), gca(q111));
delete(strcat(plot_name, '_collective_plot', '.fig')); delete(strcat(plot_name, '_avg_plot_shaded', '.fig')); delete(strcat(plot_name, '_avg_plot_errorbar', '.fig')); delete(strcat(plot_name, '_collective_plot', '.tif')); delete(strcat(plot_name, '_avg_plot_shaded', '.tif')); delete(strcat(plot_name, '_avg_plot_errorbar', '.tif'));

plot_name = fullfile(BB_apical_avg, 'Area_vs_Time');
q3 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q3_1 = findobj(q3, 'type', 'Patch'); q3_1.FaceColor = 'k'; q3_1.EdgeColor = 'k'; q3_2 = findobj(q3, 'type', 'line'); q3_2.Color = 'k'; copyobj(get(gca(q3), 'Children'), gca(q1));
q13 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q13); q13_1 = gca; set(q13_1.Children, 'Color', 'k'); copyobj(get(q13_1, 'Children'), gca(q11));
q133 = openfig(strcat(plot_name, '_collective_plot', '.fig')); figure(q133); q133_1 = gca; set(q133_1.Children, 'Color', 'k'); copyobj(get(q133_1, 'Children'), gca(q111));

close(q2, q12, q122, q3, q13, q133); % , q3, q13 % include the ', q3, q13' if the lines above were uncommented
legnd_list = ["" "Apical area" "" "BB area" "" "Whole apical area"]; figure(q111); legend(legnd_list, 'Location', 'best', 'fontsize', 10); figure(q11); legend(legnd_list, 'Location', 'best', 'fontsize', 10); figure(q1); legend(legnd_list, 'Location', 'best', 'fontsize', 10);
saveas(q1, fullfile(BB_apical_avg, 'Area_contribution_absolute_avg_plot_shaded'), 'fig'); saveas(q1, fullfile(BB_apical_avg, 'Area_contribution_absolute_avg_plot_shaded'), 'tif');
saveas(q11, fullfile(BB_apical_avg, 'Area_contribution_absolute_avg_plot_errorbar'), 'fig'); saveas(q11, fullfile(BB_apical_avg, 'Area_contribution_absolute_avg_plot_errorbar'), 'tif');
saveas(q111, fullfile(BB_apical_avg, 'Area_contribution_absolute_collective_plot'), 'fig'); saveas(q111, fullfile(BB_apical_avg, 'Area_contribution_absolute_collective_plot'), 'tif');
close(q1, q11, q111);

% -------------- % -------------- %

% Residual Area (in percentage) vs Time (Residual area is the area that do not contain BBs)
area_data = area_apicaldomain; time_data = timelist; new_parameter = Residual_Area_percent; bininterval_for_Binparameter = 5;
xLabel = 'Time [min]'; yLabel = 'Area [%]'; plot_Title = {'Area expansion - contribution of Apical domain', '[percentage] vs Time'}; save_title = 'Area_contribution_apicaldomain_percent_vs_Time';
[binned_xy] = parameter_vs_time(area_data, time_data, new_parameter, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, save_title, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling the function
clear area_data time_data new_parameter bininterval_for_Binparameter xLabel yLabel plot_Title save_title binned_xy

% BB Area (in percentage) vs Time (BB area is the area occupied by the BBs)
area_data = area_apicaldomain; time_data = timelist; new_parameter = BB_area_percent; bininterval_for_Binparameter = 5;
xLabel = 'Time [min]'; yLabel = 'Area [%]'; plot_Title = {'Area expansion - contribution of BB', '[percentage] vs Time'}; save_title = 'Area_contribution_BB_percent_vs_Time';
[binned_xy] = parameter_vs_time(area_data, time_data, new_parameter, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, save_title, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling the function
clear area_data time_data new_parameter bininterval_for_Binparameter xLabel yLabel plot_Title save_title binned_xy

% Total Area (in percentage) vs Time (Total area is the sum of area that do not contain the BBs plus the area occupied by the BBs); this area is the same as the Area of Apical domain which is the first figure
area_data = area_apicaldomain; time_data = timelist; new_parameter = Sum_of_Residual_bb_areas_percent; bininterval_for_Binparameter = 5;
xLabel = 'Time [min]'; yLabel = 'Area [%]'; plot_Title = {'Area expansion - contribution of Apical domain & BB', '[percentage] vs Time'}; save_title = 'Area_contribution_apicaldomain_BB_percent_vs_Time';
[binned_xy] = parameter_vs_time(area_data, time_data, new_parameter, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, save_title, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling the function
clear area_data time_data new_parameter bininterval_for_Binparameter xLabel yLabel plot_Title save_title binned_xy
% -------------- % -------------- %
% combining the area (percent) contribution plots
plot_name = fullfile(BB_apical_avg, 'Area_contribution_apicaldomain_percent_vs_Time'); %
q1 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q1_1 = findobj(q1, 'type', 'Patch'); q1_1.FaceColor = 'm'; q1_1.EdgeColor = 'm'; q1_2 = findobj(q1, 'type', 'line'); q1_2.Color = 'm';
q11 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q11); q11_1 = gca; set(q11_1.Children, 'Color', 'm');
q111 = openfig(strcat(plot_name, '_collective_plot', '.fig')); figure(q111); q111_1 = gca; set(q111_1.Children, 'Color', 'm');
delete(strcat(plot_name, '_collective_plot', '.fig')); delete(strcat(plot_name, '_avg_plot_shaded', '.fig')); delete(strcat(plot_name, '_avg_plot_errorbar', '.fig')); delete(strcat(plot_name, '_collective_plot', '.tif')); delete(strcat(plot_name, '_avg_plot_shaded', '.tif')); delete(strcat(plot_name, '_avg_plot_errorbar', '.tif'));

plot_name = fullfile(BB_apical_avg, 'Area_contribution_BB_percent_vs_Time'); %
q2 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q2_1 = findobj(q2, 'type', 'Patch'); q2_1.FaceColor = 'b'; q2_1.EdgeColor = 'b'; q2_2 = findobj(q2, 'type', 'line'); q2_2.Color = 'b'; copyobj(get(gca(q2), 'Children'), gca(q1));
q12 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q12); q12_1 = gca; set(q12_1.Children, 'Color', 'b'); copyobj(get(q12_1, 'Children'), gca(q11));
q122 = openfig(strcat(plot_name, '_collective_plot', '.fig')); figure(q122); q122_1 = gca; set(q122_1.Children, 'Color', 'b'); copyobj(get(q122_1, 'Children'), gca(q111));
delete(strcat(plot_name, '_collective_plot', '.fig')); delete(strcat(plot_name, '_avg_plot_shaded', '.fig')); delete(strcat(plot_name, '_avg_plot_errorbar', '.fig')); delete(strcat(plot_name, '_collective_plot', '.tif')); delete(strcat(plot_name, '_avg_plot_shaded', '.tif')); delete(strcat(plot_name, '_avg_plot_errorbar', '.tif'));

plot_name = fullfile(BB_apical_avg, 'Area_contribution_apicaldomain_BB_percent_vs_Time'); %
q3 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q3_1 = findobj(q3, 'type', 'Patch'); q3_1.FaceColor = 'k'; q3_1.EdgeColor = 'k'; q3_2 = findobj(q3, 'type', 'line'); q3_2.Color = 'k'; copyobj(get(gca(q3), 'Children'), gca(q1));
q13 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q13); q13_1 = gca; set(q13_1.Children, 'Color', 'k'); copyobj(get(q13_1, 'Children'), gca(q11));
q133 = openfig(strcat(plot_name, '_collective_plot', '.fig')); figure(q133); q133_1 = gca; set(q133_1.Children, 'Color', 'k'); copyobj(get(q133_1, 'Children'), gca(q111));
delete(strcat(plot_name, '_collective_plot', '.fig')); delete(strcat(plot_name, '_avg_plot_shaded', '.fig')); delete(strcat(plot_name, '_avg_plot_errorbar', '.fig')); delete(strcat(plot_name, '_collective_plot', '.tif')); delete(strcat(plot_name, '_avg_plot_shaded', '.tif')); delete(strcat(plot_name, '_avg_plot_errorbar', '.tif'));

close(q2, q12, q122, q3, q13, q133); % , q3, q13 % include the ', q3, q13' if the lines above were uncommented
legnd_list = ["" "Apical area" "" "BB area" "" "Whole apical area"]; figure(q111); legend(legnd_list, 'Location', 'best', 'fontsize', 10); figure(q11); legend(legnd_list, 'Location', 'best', 'fontsize', 10); figure(q1); legend(legnd_list, 'Location', 'best', 'fontsize', 10);
saveas(q1, fullfile(BB_apical_avg, 'Area_contribution_percent_avg_plot_shaded'), 'fig'); saveas(q1, fullfile(BB_apical_avg, 'Area_contribution_percent_avg_plot_shaded'), 'tif');
saveas(q11, fullfile(BB_apical_avg, 'Area_contribution_percent_avg_plot_errorbar'), 'fig'); saveas(q11, fullfile(BB_apical_avg, 'Area_contribution_percent_avg_plot_errorbar'), 'tif');
saveas(q111, fullfile(BB_apical_avg, 'Area_contribution_percent_collective_plot'), 'fig'); saveas(q111, fullfile(BB_apical_avg, 'Area_contribution_percent_collective_plot'), 'tif');
close(q1, q11, q111);

%----------------------------- Rate of apical area expansion -----------------------------------%

% Rate of apical domain area expansion vs Area & Time
area_data = Area_area_rate; time_data = timelist_area_rate; new_parameter = Area_rate;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Rate of area expansion [\mum^2 min^{-1}]'; plot_Title_1 = 'Rate of apical domain area expansion vs Area'; save_title_1 = 'Rate_of_apical_domain_area_expansion_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Rate of area expansion [\mum^2 min^{-1}]'; plot_Title_2 = 'Rate of apical domain area expansion vs Time'; save_title_2 = 'Rate_of_apical_domain_area_expansion_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_expansionrate_vs_area = binXY_parameter_vs_area; expansion_rate_XData_area = XData_area; expansion_rate_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

%----------------------------- Rate of normalised apical area expansion -----------------------------------%

% % Rate of normalised area expansion vs Area & Time
% area_data = Area_area_rate; time_data = timelist_area_rate; new_parameter = Norm_Area_rate;
% bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Rate of normalised area expansion [min^{-1}]'; plot_Title_1 = 'Rate of normalised area expansion vs Area'; save_title_1 = 'Rate_of_normalised_area_expansion_vs_Area';
% bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Rate of normalised area expansion [min^{-1}]'; plot_Title_2 = 'Rate of normalised area expansion vs Time'; save_title_2 = 'Rate_of_normalised_area_expansion_vs_Time';
% [binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
% clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

%---------------------------- BB mean interdistance plots ------------------------------------%

% BB mean interdistance (density based) vs Area & Time
area_data = area_bbmintd; time_data = timelist_bbmintd; new_parameter = Mintd;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Mean interdistance [\mum]'; plot_Title_1 = 'BB mean interdistance (density based) vs Area'; save_title_1 = 'BB_mean_interdistance_(density_based)_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Mean interdistance [\mum]'; plot_Title_2 = 'BB mean interdistance (density based) vs Time'; save_title_2 = 'BB_mean_interdistance_(density_based)_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_MeanInterdist_vs_area = binXY_parameter_vs_area; MeanInterdist_XData_area = XData_area; MeanInterdist_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

%---------------------------- Local Clustering index ------------------------------------%

% Local clustering index vs Area & Time
area_data = Area_Clustering; time_data = Time_Clustering; new_parameter = Local_Clustering;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Local clustering index'; plot_Title_1 = 'Local clustering index vs Area'; save_title_1 = 'LC_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Local clustering index'; plot_Title_2 = 'Local clustering index vs Time'; save_title_2 = 'LC_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_LocalClustering_vs_area = binXY_parameter_vs_area; local_clustering_XData_area = XData_area; local_clustering_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

%---------------------------- Global Clustering index ------------------------------------%

% Global clustering index vs Area & Time
area_data = Area_Clustering; time_data = Time_Clustering; new_parameter = Global_Clustering;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Global clustering index'; plot_Title_1 = 'Global clustering index vs Area'; save_title_1 = 'GC_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Global clustering index'; plot_Title_2 = 'Global clustering index vs Time'; save_title_2 = 'GC_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_GlobalClustering_vs_area = binXY_parameter_vs_area; global_clustering_XData_area = XData_area; global_clustering_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

%----------------------------- Intensity (whole area) plots -----------------------------------%

% Mean intensity of apical domain vs Area & Time
area_data = area_apicaldomain; time_data = timelist; new_parameter = meanintensity_apicaldomain;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Mean intensity (normalised)'; plot_Title_1 = 'Mean intensity of apical domain vs area'; save_title_1 = 'Mean_intensity_of_apical_domain_vs_area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Mean intensity (normalised)'; plot_Title_2 = 'Mean intensity of apical domain vs Time'; save_title_2 = 'Mean_intensity_of_apical_domain_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Total intensity of apical domain vs Area & Time
area_data = area_apicaldomain; time_data = timelist; new_parameter = totalintensity_apicaldomain;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Total intensity (normalised)'; plot_Title_1 = 'Total intensity of apical domain vs Area'; save_title_1 = 'Total_intensity_of_apical_domain_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Total intensity (normalised)'; plot_Title_2 = 'Total intensity of apical domain vs Time'; save_title_2 = 'Total_intensity_of_apical_domain_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

%----------------------------- Intensity (at BB position) plots -----------------------------------%

% Mean intensity of BB position vs Area & Time
area_data = Area_ApicalDomain_clone_traj_atmaxarea_only; time_data = TimeList_Clone_traj_atmaxarea_only; new_parameter = MeanInt_atBBpos_traj_atmaxarea_only;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Mean intensity (normalised)'; plot_Title_1 = 'Mean intensity of BB position vs area'; save_title_1 = 'Mean_intensity_of_BBPos_vs_area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Mean intensity (normalised)'; plot_Title_2 = 'Mean intensity of BB position vs Time'; save_title_2 = 'Mean_intensity_of_BBPos_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Total intensity of BB position vs Area & Time
area_data = Area_ApicalDomain_clone_traj_atmaxarea_only; time_data = TimeList_Clone_traj_atmaxarea_only; new_parameter = TotalInt_atBBpos_traj_atmaxarea_only;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Total intensity (normalised)'; plot_Title_1 = 'Total intensity of BB position vs Area'; save_title_1 = 'Total_intensity_of_BBPos_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Total intensity (normalised)'; plot_Title_2 = 'Total intensity of BB position vs Time'; save_title_2 = 'Total_intensity_of_BBPos_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Mean intensity of BB position vs Time (Trajectories aligned); 'Trajectories aligned' refers to the data where the first time point of all Trajectories are aligned to be the starting point instead of aligning to the actual corresponding area/time point value
area_data = Area_ApicalDomain_clone_traj_atmaxarea_only; time_data = TimeList_Clone_traj_atmaxarea_only; new_parameter = MeanInt_atBBpos_traj_atmaxarea_only_aligned; bininterval_for_Binparameter = 5;
xLabel = 'Time [min]'; yLabel = 'Mean intensity (normalised)'; plot_Title = {'Mean intensity of BB position vs Time', '(Trajectories aligned)'}; save_title = 'Mean_intensity_of_BBPos_aligned_vs_Time';
[binned_xy] = parameter_vs_time(area_data, time_data, new_parameter, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, save_title, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling the function
clear area_data time_data new_parameter bininterval_for_Binparameter xLabel yLabel plot_Title save_title binned_xy

% Total intensity of BB position vs Time (Trajectories aligned); 'Trajectories aligned' refers to the data where the first time point of all Trajectories are aligned to be the starting point instead of aligning to the actual corresponding area/time point value
area_data = Area_ApicalDomain_clone_traj_atmaxarea_only; time_data = TimeList_Clone_traj_atmaxarea_only; new_parameter = TotalInt_atBBpos_traj_atmaxarea_only_aligned; bininterval_for_Binparameter = 5;
xLabel = 'Time [min]'; yLabel = 'Total intensity (normalised)'; plot_Title = {'Total intensity of BB position vs Time', '(Trajectories aligned)'}; save_title = 'Total_intensity_of_BBPos_aligned_vs_Time';
[binned_xy] = parameter_vs_time(area_data, time_data, new_parameter, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, save_title, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling the function
clear area_data time_data new_parameter bininterval_for_Binparameter xLabel yLabel plot_Title save_title binned_xy

%----------------------------- Intensity (at BB surrounding) plots -----------------------------------%

% Mean intensity of BB surrounding vs Area & Time
area_data = Area_ApicalDomain_clone_traj_atmaxarea_only; time_data = TimeList_Clone_traj_atmaxarea_only; new_parameter = MeanInt_atBBSurr_traj_atmaxarea_only;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Mean intensity (normalised)'; plot_Title_1 = 'Mean intensity of BB surrounding vs area'; save_title_1 = 'Mean_intensity_of_BBSur_vs_area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Mean intensity (normalised)'; plot_Title_2 = 'Mean intensity of BB surrounding vs Time'; save_title_2 = 'Mean_intensity_of_BBSur_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Total intensity of BB surrounding vs Area & Time
area_data = Area_ApicalDomain_clone_traj_atmaxarea_only; time_data = TimeList_Clone_traj_atmaxarea_only; new_parameter = TotalInt_atBBSurr_traj_atmaxarea_only;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Total intensity (normalised)'; plot_Title_1 = 'Total intensity of BB surrounding vs Area'; save_title_1 = 'Total_intensity_of_BBSur_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Total intensity (normalised)'; plot_Title_2 = 'Total intensity of BB surrounding vs Time'; save_title_2 = 'Total_intensity_of_BBSur_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Mean intensity of BB surrounding vs Time (Trajectories aligned); 'Trajectories aligned' refers to the data where the first time point of all Trajectories are aligned to be the starting point instead of aligning to the actual corresponding area/time point value
area_data = Area_ApicalDomain_clone_traj_atmaxarea_only; time_data = TimeList_Clone_traj_atmaxarea_only; new_parameter = MeanInt_atBBSurr_traj_atmaxarea_only_aligned; bininterval_for_Binparameter = 5;
xLabel = 'Time [min]'; yLabel = 'Mean intensity (normalised)'; plot_Title = {'Mean intensity of BB surrounding vs Time', '(Trajectories aligned)'}; save_title = 'Mean_intensity_of_BBSur_aligned_vs_Time';
[binned_xy] = parameter_vs_time(area_data, time_data, new_parameter, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, save_title, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling the function
clear area_data time_data new_parameter bininterval_for_Binparameter xLabel yLabel plot_Title save_title binned_xy

% Total intensity of BB surrounding vs Time (Trajectories aligned); 'Trajectories aligned' refers to the data where the first time point of all Trajectories are aligned to be the starting point instead of aligning to the actual corresponding area/time point value
area_data = Area_ApicalDomain_clone_traj_atmaxarea_only; time_data = TimeList_Clone_traj_atmaxarea_only; new_parameter = TotalInt_atBBSurr_traj_atmaxarea_only_aligned; bininterval_for_Binparameter = 5;
xLabel = 'Time [min]'; yLabel = 'Total intensity (normalised)'; plot_Title = {'Total intensity of BB surrounding vs Time', '(Trajectories aligned)'}; save_title = 'Total_intensity_of_BBSur_aligned_vs_Time';
[binned_xy] = parameter_vs_time(area_data, time_data, new_parameter, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, save_title, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling the function
clear area_data time_data new_parameter bininterval_for_Binparameter xLabel yLabel plot_Title save_title binned_xy

%----------------------------- Intensity (ratio of BB surrounding-to-Position) plots -----------------------------------%

% Ratio of mean intensity (of BB surrounding-to-position) vs Area & Time
area_data = Area_ApicalDomain_clone_traj_atmaxarea_only; time_data = TimeList_Clone_traj_atmaxarea_only; new_parameter = MeanInt_BB_SurPos_ratio_traj_atmaxarea_only;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Mean intensity (normalised)'; plot_Title_1 = 'Mean intensity ratio of BB surrounding-to-Position vs area'; save_title_1 = 'Mean_intensity_of_ratio_BBSurPos_vs_area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Mean intensity (normalised)'; plot_Title_2 = 'Mean intensity ratio of BB surrounding-to-Position vs Time'; save_title_2 = 'Mean_intensity_of_ratio_BBSurPos_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Ratio of total intensity (of BB surrounding-to-position) vs Area & Time
area_data = Area_ApicalDomain_clone_traj_atmaxarea_only; time_data = TimeList_Clone_traj_atmaxarea_only; new_parameter = TotalInt_BB_SurPos_ratio_traj_atmaxarea_only;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Total intensity (normalised)'; plot_Title_1 = 'Total intensity ratio of BB surrounding-to-Position vs Area'; save_title_1 = 'Total_intensity_of_ratio_BBSurPos_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Total intensity (normalised)'; plot_Title_2 = 'Total intensity ratio of BB surrounding-to-Position vs Time'; save_title_2 = 'Total_intensity_of_ratio_BBSurPos_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Ratio of mean intensity (of BB surrounding-to-position) vs Time (Trajectories aligned); 'Trajectories aligned' refers to the data where the first time point of all Trajectories are aligned to be the starting point instead of aligning to the actual corresponding area/time point value
area_data = Area_ApicalDomain_clone_traj_atmaxarea_only; time_data = TimeList_Clone_traj_atmaxarea_only; new_parameter = MeanInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned; bininterval_for_Binparameter = 5;
xLabel = 'Time [min]'; yLabel = 'Mean intensity (normalised)'; plot_Title = {'Mean intensity ratio of BB surrounding-to-Position vs Time', '(Trajectories aligned)'}; save_title = 'Mean_intensity_of_ratio_BBSurPos_aligned_vs_Time';
[binned_xy] = parameter_vs_time(area_data, time_data, new_parameter, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, save_title, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling the function
clear area_data time_data new_parameter bininterval_for_Binparameter xLabel yLabel plot_Title save_title binned_xy

% Ratio of total intensity (of BB surrounding-to-position) vs Time (Trajectories aligned); 'Trajectories aligned' refers to the data where the first time point of all Trajectories are aligned to be the starting point instead of aligning to the actual corresponding area/time point value
area_data = Area_ApicalDomain_clone_traj_atmaxarea_only; time_data = TimeList_Clone_traj_atmaxarea_only; new_parameter = TotalInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned; bininterval_for_Binparameter = 5;
xLabel = 'Time [min]'; yLabel = 'Total intensity (normalised)'; plot_Title = {'Total intensity ratio of BB surrounding-to-Position vs Time', '(Trajectories aligned)'}; save_title = 'Total_intensity_of_ratio_BBSurPos_aligned_vs_Time';
[binned_xy] = parameter_vs_time(area_data, time_data, new_parameter, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, save_title, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling the function
clear area_data time_data new_parameter bininterval_for_Binparameter xLabel yLabel plot_Title save_title binned_xy

%----------------------------- Intensity box plots (BB position; BB surrounding; Ratio) -----------------------------------%

% Mean Int. at BB position; comparison between 1st & last frames (i.e. max. apical area frame)
[meanint_atBBpos_1stframe_maxarea] = prepping_plotting_box_plots(meanint_atBBpos_1stframe, meanint_atBBpos_maxapicalarea, 'Mean intensity (normalised)', 'Mean intensity at BB position', 'comparison_1st_last_frames_meanInt_BBpos', BB_apical_avg, 'comparison_1stframe_maxArea');

% Total Int. at BB position; comparison between 1st & last frames (i.e. max. apical area frame)
[totalint_atBBpos_1stframe_maxarea] = prepping_plotting_box_plots(totalint_atBBpos_1stframe, totalint_atBBpos_maxapicalarea, 'Total intensity (normalised)', 'Total intensity at BB position', 'comparison_1st_last_frames_totalInt_BBpos', BB_apical_avg, 'comparison_1stframe_maxArea');

% Mean Int. at BB surrounding; comparison between 1st & last frames (i.e. max. apical area frame)
[meanint_atBBsurr_1stframe_maxarea] = prepping_plotting_box_plots(meanint_atBBSurr_1stframe, meanint_atBBSurr_maxapicalarea, 'Mean intensity (normalised)', 'Mean intensity at BB surrounding', 'comparison_1st_last_frames_meanInt_BBsur', BB_apical_avg, 'comparison_1stframe_maxArea');

% Total Int. at BB surrounding; comparison between 1st & last frames (i.e. max. apical area frame)
[totalint_atBBsurr_1stframe_maxarea] = prepping_plotting_box_plots(totalint_atBBSurr_1stframe, totalint_atBBSurr_maxapicalarea, 'Total intensity (normalised)', 'Total intensity at BB surrounding', 'comparison_1st_last_frames_totalInt_BBsur', BB_apical_avg, 'comparison_1stframe_maxArea');

% Mean Int. (ratio of BB surrounding-to-position); comparison between 1st & last frames (i.e. max. apical area frame)
[meanint_atBBsurPos_1stframe_maxarea] = prepping_plotting_box_plots(meanint_ratio_BBSurPos_1stframe, meanint_ratio_BBSurPos_maxapicalarea, 'Ratio of mean intensity', 'Ratio of mean intensity at BB surrounding-to-position', 'comparison_1st_last_frames_meanInt_ratioBBsurpos', BB_apical_avg, 'comparison_1stframe_maxArea');

% Total Int. (ratio of BB surrounding-to-position); comparison between 1st & last frames (i.e. max. apical area frame)
[totalint_atBBsurPos_1stframe_maxarea] = prepping_plotting_box_plots(totalint_ratio_BBSurPos_1stframe, meanint_ratio_BBSurPos_maxapicalarea, 'Ratio of total intensity', 'Ratio of total intensity at BB surrounding-to-position', 'comparison_1st_last_frames_totalInt_ratioBBsurpos', BB_apical_avg, 'comparison_1stframe_maxArea');

%-------------------------------- BB entry & exit counts --------------------------------%

% BB entry count vs Area & Time
area_data = area_NEW_BB_entry_count; time_data = timelist_NEW_BB_entry_count; new_parameter = NEW_BB_entry_count;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'BB entry count'; plot_Title_1 = 'BB entry count vs Area'; save_title_1 = 'BB_entry_count_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'BB entry count'; plot_Title_2 = 'BB entry count vs Time'; save_title_2 = 'BB_entry_count_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_NewBBEntryCount_vs_area = binXY_parameter_vs_area; NewBBEntryCount_XData_area = XData_area; NewBBEntryCount_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% BB exit count vs Area & Time
area_data = area_NEW_BB_exit_count; time_data = timelist_NEW_BB_exit_count; new_parameter = NEW_BB_exit_count;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'BB exit count'; plot_Title_1 = 'BB exit count vs Area'; save_title_1 = 'BB_exit_count_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'BB exit count'; plot_Title_2 = 'BB exit count vs Time'; save_title_2 = 'BB_exit_count_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, 3, minimum_area_threshold); % here the 'operation_type' is changed to 3; Because the BBs start exiting at later areas and therefore a minimum threshold area or time cannot be fixed; the 'operation type' only sets a max. threshold for area & time
binXY_NewBBExitCount_vs_area = binXY_parameter_vs_area; NewBBExitCount_XData_area = XData_area; NewBBExitCount_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time


%-------------------------------- BB entry & exit rate --------------------------------%

% BB entry rate vs Area & Time
area_data = area_t0_bb; time_data = t0_time; new_parameter = bbEntry_rate;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'BB entry rate [min^{-1}]'; plot_Title_1 = 'BB entry rate vs Area'; save_title_1 = 'BB_entry_rate_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'BB entry rate [min^{-1}]'; plot_Title_2 = 'BB entry rate vs Time'; save_title_2 = 'BB_entry_rate_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_NewBBEntryRate_vs_area = binXY_parameter_vs_area; NewBBEntryRate_XData_area = XData_area; NewBBEntryRate_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% BB exit rate vs Area & Time
area_data = area_tend_bb(1:end-1, :); time_data = tend_time(1:end-1, :); new_parameter = bbExit_rate;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'BB exit rate (BB min^{-1})'; plot_Title_1 = 'BB exit rate vs Area'; save_title_1 = 'BB_exit_rate_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'BB exit rate (BB min^{-1})'; plot_Title_2 = 'BB exit rate vs Time'; save_title_2 = 'BB_exit_rate_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, 3, minimum_area_threshold); % here the 'operation_type' is changed to 3; Because the BBs start exiting at later areas and therefore a minimum threshold area or time cannot be fixed; the 'operation type' only sets a max. threshold for area & time
binXY_NewBBExitRate_vs_area = binXY_parameter_vs_area; NewBBExitRate_XData_area = XData_area; NewBBExitRate_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

%------------------------------- BB entry & exit flux ---------------------------------%

% BB entry flux vs Area & Time
area_data = area_t0_bb; time_data = t0_time; new_parameter = bbEntryFlux;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'BB entry flux [min^{-1}\mum^{-2}]'; plot_Title_1 = 'BB entry flux vs Area'; save_title_1 = 'BB_entry_flux_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'BB entry flux [min^{-1}\mum^{-2}]'; plot_Title_2 = 'BB entry flux vs Time'; save_title_2 = 'BB_entry_flux_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% BB exit flux vs Area & Time
area_data = area_tend_bb; time_data = tend_time; new_parameter = bbExitFlux;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'BB exit flux [min^{-1}\mum^{-2}]'; plot_Title_1 = 'BB exit flux vs Area'; save_title_1 = 'BB_exit_flux_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'BB exit flux [min^{-1}\mum^{-2}]'; plot_Title_2 = 'BB exit flux vs Time'; save_title_2 = 'BB_exit_flux_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, 3, minimum_area_threshold); % here the 'operation_type' is changed to 3; Because the BBs start exiting at later areas and therefore a minimum threshold area or time cannot be fixed; the 'operation type' only sets a max. threshold for area & time
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

%------------------------------- BB density ---------------------------------%

% BB density vs Area & Time
area_data = area_bbDensity; time_data = timelist_bbDensity; new_parameter = BB_density_norm_modified;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'BB density [\mum^{-2}]'; plot_Title_1 = 'BB density vs Area'; save_title_1 = 'BB_density_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'BB density [\mum^{-2}]'; plot_Title_2 = 'BB density vs Time'; save_title_2 = 'BB_density_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

%------------------------------ Variance in tessalation areas ----------------------------------%

% Log of variance in tessalation areas vs Area, time & BB count (all tessalations)
Variance_voronoi_fin_log_all = log(Variance_voronoi_fin_all);
Variance_voronoi_fin_log_all_norm = (Variance_voronoi_fin_log_all - min(Variance_voronoi_fin_log_all)) ./ (max(Variance_voronoi_fin_log_all) - min(Variance_voronoi_fin_log_all)); % performing Min-Max Normalization
area_data = area_variance_tessalation_all; time_data = time_variance_tessalation_all; new_parameter = Variance_voronoi_fin_log_all_norm; new_parameter_2 = no_of_bb_variance_tessalation_all;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'ln(variance) (normalised)'; plot_Title_1 = {'Natural log of Variance vs Area', '(All tessalations)'}; save_title_1 = 'Variance_Log_in_tessalation_areas_vs_Area_all_tessalations';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'ln(variance) (normalised)'; plot_Title_2 = {'Natural log of Variance vs Time', '(All tessalations)'}; save_title_2 = 'Variance_Log_in_tessalation_areas_vs_Time_all_tessalations';
bininterval_for_Binparameter_3 = 5; xLabel_3 = 'BB count'; yLabel_3 = 'ln(variance) (normalised)'; plot_Title_3 = {'Natural log of Variance vs BB count', '(All tessalations)'}; save_title_3 = 'Variance_Log_in_tessalation_areas_vs_BB_count_all_tessalations';
[binXY_tessalation_vs_area, XData_area, YData_area, binXY_tessalation_vs_time, binXY_tessalation_vs_3rdparameter] = parameter_vs_area_time_third_parameter(area_data, time_data, new_parameter, new_parameter_2, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, bininterval_for_Binparameter_3, xLabel_3, yLabel_3, plot_Title_3, save_title_3, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_lnVarianceTessalation_vs_area = binXY_tessalation_vs_area; lnVarianceTessalation_XData_area = XData_area; lnVarianceTessalation_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 bininterval_for_Binparameter_3 xLabel_3 yLabel_3 plot_Title_3 save_title_3 binXY_tessalation_vs_area XData_area YData_area binXY_tessalation_vs_time binXY_tessalation_vs_3rdparameter

% Variance in tessalation areas vs Area, time & BB count (all tessalations)
area_data = area_variance_tessalation_all; time_data = time_variance_tessalation_all; new_parameter = Variance_voronoi_fin_norm_all; new_parameter_2 = no_of_bb_variance_tessalation_all;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = {'Variance in tessalation areas', '(normalised by MeanArea squared)'}; plot_Title_1 = {'Variance in tessalation areas vs Area', '(All tessalations)'}; save_title_1 = 'Variance_in_tessalation_areas_vs_Area_all_tessalations';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = {'Variance in tessalation areas', '(normalised by MeanArea squared)'}; plot_Title_2 = {'Variance in tessalation areas vs Time', '(All tessalations)'}; save_title_2 = 'Variance_in_tessalation_areas_vs_Time_all_tessalations';
bininterval_for_Binparameter_3 = 5; xLabel_3 = 'BB count'; yLabel_3 = {'Variance in tessalation areas', '(normalised by MeanArea squared)'}; plot_Title_3 = {'Variance in tessalation areas vs BB count', '(All tessalations)'}; save_title_3 = 'Variance_in_tessalation_areas_vs_BB_count_all_tessalations';
[binXY_tessalation_vs_area, XData_area, YData_area, binXY_tessalation_vs_time, binXY_tessalation_vs_3rdparameter] = parameter_vs_area_time_third_parameter(area_data, time_data, new_parameter, new_parameter_2, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, bininterval_for_Binparameter_3, xLabel_3, yLabel_3, plot_Title_3, save_title_3, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_VarianceTessalation_vs_area = binXY_tessalation_vs_area; VarianceTessalation_XData_area = XData_area; VarianceTessalation_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 bininterval_for_Binparameter_3 xLabel_3 yLabel_3 plot_Title_3 save_title_3 binXY_tessalation_vs_area XData_area YData_area binXY_tessalation_vs_time binXY_tessalation_vs_3rdparameter

% Log of variance in tessalation areas vs Area, time & BB count (edge tessalations removed / border cells removed)
Variance_voronoi_fin_log_edge_removed = log(Variance_voronoi_fin_edge_removed);
Variance_voronoi_fin_log_edge_removed_norm = (Variance_voronoi_fin_log_edge_removed - min(Variance_voronoi_fin_log_edge_removed)) ./ (max(Variance_voronoi_fin_log_edge_removed) - min(Variance_voronoi_fin_log_edge_removed));
area_data = area_variance_tessalation_edge_removed; time_data = time_variance_tessalation_edge_removed; new_parameter = Variance_voronoi_fin_log_edge_removed_norm;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = {'ln(variance) (normalised)'}; plot_Title_1 = {'Natural log of Variance vs Area', '(without edge tessalations / border cells)'}; save_title_1 = 'Variance_log_in_tessalation_areas_vs_Area_no_edge_tessalations';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = {'ln(variance) (normalised)'}; plot_Title_2 = {'Natural log of Variance vs Time', '(without edge tessalations / border cells)'}; save_title_2 = 'Variance_log_in_tessalation_areas_vs_Time_no_edge_tessalations';
bininterval_for_Binparameter_3 = 5; xLabel_3 = 'BB count'; yLabel_3 = {'ln(variance) (normalised)'}; plot_Title_3 = {'Natural log of Variance vs BB count', '(without edge tessalations / border cells)'}; save_title_3 = 'Variance_log_in_tessalation_areas_vs_BB_count_no_edge_tessalations';
[binXY_tessalation_vs_area, XData_area, YData_area, binXY_tessalation_vs_time, binXY_tessalation_vs_3rdparameter] = parameter_vs_area_time_third_parameter(area_data, time_data, new_parameter, new_parameter_2, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, bininterval_for_Binparameter_3, xLabel_3, yLabel_3, plot_Title_3, save_title_3, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 bininterval_for_Binparameter_3 xLabel_3 yLabel_3 plot_Title_3 save_title_3 binXY_tessalation_vs_area XData_area YData_area binXY_tessalation_vs_time binXY_tessalation_vs_3rdparameter

% Variance in tessalation areas vs Area, time & BB count (edge tessalations removed / border cells removed)
area_data = area_variance_tessalation_edge_removed; time_data = time_variance_tessalation_edge_removed; new_parameter = Variance_voronoi_fin_norm_edge_removed;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = {'Variance in tessalation areas', '(normalised by MeanArea squared)'}; plot_Title_1 = {'Variance in tessalation areas vs Area', '(without edge tessalations / border cells)'}; save_title_1 = 'Variance_in_tessalation_areas_vs_Area_no_edge_tessalations';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = {'Variance in tessalation areas', '(normalised by MeanArea squared)'}; plot_Title_2 = {'Variance in tessalation areas vs Time', '(without edge tessalations / border cells)'}; save_title_2 = 'Variance_in_tessalation_areas_vs_Time_no_edge_tessalations';
bininterval_for_Binparameter_3 = 5; xLabel_3 = 'BB count'; yLabel_3 = {'Variance in tessalation areas', '(normalised by MeanArea squared)'}; plot_Title_3 = {'Variance in tessalation areas vs BB count', '(without edge tessalations / border cells)'}; save_title_3 = 'Variance_in_tessalation_areas_vs_BB_count_no_edge_tessalations';
[binXY_tessalation_vs_area, XData_area, YData_area, binXY_tessalation_vs_time, binXY_tessalation_vs_3rdparameter] = parameter_vs_area_time_third_parameter(area_data, time_data, new_parameter, new_parameter_2, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, bininterval_for_Binparameter_3, xLabel_3, yLabel_3, plot_Title_3, save_title_3, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 bininterval_for_Binparameter_3 xLabel_3 yLabel_3 plot_Title_3 save_title_3 binXY_tessalation_vs_area XData_area YData_area binXY_tessalation_vs_time binXY_tessalation_vs_3rdparameter

%------------------------------- Drift ---------------------------------%

% Average Drift in x & y vs BB Time (average drift of BBs from each / individual cell)
figure(100); plot(Drift_time, Drift_xmean,  '-k'); xlabel('Time [min]'); ylabel('Rotated x distance [\mum]'); title({'Average Drift in x vs BB Time', '[average drift of BBs from each / individual cell]'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical_avg, 'Average_Drift_in_x_vs_BB_Time_individual_cell'), 'fig'); saveas(gcf, fullfile(BB_apical_avg, 'Average_Drift_in_x_vs_BB_Time_individual_cell'), 'tif');
figure(101); plot(Drift_time, Drift_ymean,  '-k'); xlabel('Time [min]'); ylabel('Rotated y distance [\mum]'); title({'Average Drift in y vs BB Time', '[average drift of BBs from each / individual cell]'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical_avg, 'Average_Drift_in_y_vs_BB_Time_individual_cell'), 'fig'); saveas(gcf, fullfile(BB_apical_avg, 'Average_Drift_in_y_vs_BB_Time_individual_cell'), 'tif');
close (figure(100), figure(101));

% Average drift from all trajectories pooled from all cells
% Drift calculation (for more information, check the "drift_mandar.m" script)
XP_Save_mod = XP_Save(~cellfun(@isempty, XP_Save));
YP_Save_mod = YP_Save(~cellfun(@isempty, YP_Save));
Time_Dur_Save_mod = Time_Dur_Save(~cellfun(@isempty, Time_Dur_Save));
No_of_Durmax_points_min = min(No_of_Durmax_points);
nLrge_total = sum(nLrge);
Xmean = zeros(No_of_Durmax_points_min, 1); % changed by RT
Ymean = zeros(No_of_Durmax_points_min, 1); % changed by RT
for i = 1 : nLrge_total

    % % The section below is to restrict the drift analysis to 2.5 h; Meaning, if we want to analyse the trajectories only upto 2.5 h / 150 min.
    % % Right now, the analysis analyzes trajectories for the entire experiment. In order to analyse only for 2.5 h, uncomment the section below and then uncomment the current plot lines involving temp_time & temp_XP_save and temp_time & temp_YP_save; and
    % % then comment the original plot lines.
    % %------------------------------%
    % finding_time_interval = diff(Time_Dur_Save_mod{1,1}(2:10)); % finding the difference between the values of time vector to find out if the time interval is 0.5 or 1 minute (Note: all trajectories are already in minutes)
    % min_finding_time_interval = min(finding_time_interval); % finding the minimum difference (sometimes multiple differences can be observed if the frames in this trajectory are not continuous)
    % if min_finding_time_interval == 0.5 % checking the condition against the minimum time interval obtained from the difference of the current trajectory
    %     time_threshold_drift = 300; % setting the no of frames to 2.5 h if the frame interval was 0.5 minute
    % else
    %     time_threshold_drift = 150; % setting the no of frames to 2.5 h if the frame interval was 1 minute
    % end
    % % below we create temporary vectors to substittue the "XP_Save_mod" and "YP_Save_mod" for plotting    
    % temp_time = Time_Dur_Save_mod{i,1}; 
    % temp_time = temp_time(temp_time <= time_threshold_drift);
    % temp_XP_save =  XP_Save_mod{i,1};
    % temp_XP_save = temp_XP_save(1:length(temp_time));
    % temp_YP_save = YP_Save_mod{i,1};
    % temp_YP_save = temp_YP_save(1:length(temp_time));
    %------------------------------%

    figure(100)
    plot(Time_Dur_Save_mod{i,1}, XP_Save_mod{i,1}, 'LineWidth', 0.1, 'Color', [0.7, 0.7, 0.7]); % changed by RT
    %plot(temp_time, temp_XP_save, 'LineWidth', 0.1, 'Color', [0.7, 0.7, 0.7]); % changed by RT
    hold on
    xlabel('Time [min]');
    ylabel('Rotated x distance [µm]');
    figure(101)
    plot(Time_Dur_Save_mod{i,1}, YP_Save_mod{i,1}, 'LineWidth', 0.1, 'Color', [0.7, 0.7, 0.7]); % changed by RT
    %plot(temp_time, temp_YP_save, 'LineWidth', 0.1, 'Color', [0.7, 0.7, 0.7]); % changed by RT
    hold on;
    xlabel('Time [min]');
    ylabel('Rotated y distance [µm]');
    Xmean = Xmean + XP_Save_mod{i,1}((1:No_of_Durmax_points_min), 1); % changed by RT
    Ymean = Ymean + YP_Save_mod{i,1}((1:No_of_Durmax_points_min), 1); % changed by RT
end
Drift_time_mod = Drift_time((1:No_of_Durmax_points_min), 1);
Xmean = Xmean/nLrge_total;
Ymean = Ymean/nLrge_total;
figure(100);
plot(Drift_time_mod, Xmean, 'r-', 'LineWidth', 1.5); % changed by RT
figure(101)
plot(Drift_time_mod, Ymean, 'r-', 'LineWidth', 1.5); % changed by RT
saveas(gcf, fullfile(BB_apical_avg, 'AvgDrift_in_y_vs_BB_Time_all_trajectories'), 'fig'); saveas(gcf, fullfile(BB_apical_avg, 'AvgDrift_in_y_vs_BB_Time_all_trajectories'), 'tif');
% fitting straight line and Set up fittype and options.
ft = fittype('poly1');
% Fit model to data.
[fitresult, gof] = fit(Drift_time_mod, Xmean, ft ); % changed by RT
p1 = fitresult.p1;
p2 = fitresult.p2;
y = p1*Drift_time_mod + p2;
drift_slope_avg = p1; % -This is the final average drift. This is obtained by plotting all the BB trajectories from all cells, then plotting the average of these plots and then by finding the slope of this average plot.
% This slope is then called the average drift and the unit is (micrometer per minute)
figure(100);
hold on
plot(Drift_time_mod', y, 'b');
saveas(gcf, fullfile(BB_apical_avg, 'AvgDrift_in_x_vs_BB_Time_all_trajectories'), 'fig'); saveas(gcf, fullfile(BB_apical_avg, 'AvgDrift_in_x_vs_BB_Time_all_trajectories'), 'tif');
clear ft p1 p2
close (figure(100), figure(101));

% Average Drift vs Rate of apical area expansion
figure(100); plot(Whole_area_rate, Drift_slope,  'ok'); xlabel('Rate of area expansion [\mum^2 min^{-1}]'); ylabel('Drift [\mum min^{-1}]'); title('Average Drift vs Rate of apical area expansion'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical_avg, 'Average_Drift_vs_Rate_of_apical_area_expansion'), 'fig'); saveas(gcf, fullfile(BB_apical_avg, 'Average_Drift_vs_Rate_of_apical_area_expansion'), 'tif');
close (figure(100));

%------------------------------- Contour length, End-to-End length & Tortuosity ---------------------------------%

% Contour length
parameter = ContourLength_fin; bininterval = 8; Xlabel = 'Contour length [\mum]'; Ylabel = 'Probability density'; Plot_title = 'Contour length of all trajectories'; save_title = 'contour_length_all_trajs';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

% End-to-End length length
parameter = EndToEndLength_fin; bininterval = 1; Xlabel = 'End-to-End length [\mum]'; Ylabel = 'Probability density'; Plot_title = 'End-to-End straight length of all trajectories'; save_title = 'endtoend_length_all_trajs';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

% Tortuosity
Tortuosity_finall = Tortuosity_fin(Tortuosity_fin < 350); % I decided to use this filter of choosing all the toruosity values below 350 because, 350 is roughly the ratio of the approximate maximum contour length (taken as 165 µm) and approximate minimum end-to-end length (taken as 0.5 µm). The max and min values, 165 µm & 0.5 µm were taken based on the contour length plots and
% end-to-end length plots from the above. The tortuosity values above 350 are considered outliers because those end-to-end lengths that are smaller than 0.5 µm indicate that the start and the end points of the trajectories were very close to one another. These kind of trajectories were very less in number and plotting these values shrank the histogram.
% This shrinking made it difficult to see the actual distribution of tortuosity values that were in the range of 1- 100. Majority of the tortuosity values were within this range and values more than 100 were very sparse and less in number. Thats why i am choosing to plot only the values until 350.
parameter = Tortuosity_finall; bininterval = 1; Xlabel = 'Tortuosity'; Ylabel = 'Probability density'; Plot_title = 'Tortuosity of all trajectories'; save_title = 'tortuosity';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%------------------------------- Dot product ---------------------------------%

% Dot product (to know if the trajectory moves in the direction of periphery or in the opposite direction)
parameter = Dotp_fin; bininterval = 0.1; Xlabel = 'Trajectory direction'; Ylabel = 'Probability density'; Plot_title = {'Dot product (to know if the trajectory moves in', ' the direction of periphery or in the opposite direction)'}; save_title = 'Dotproduct_traj_direction';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
% plotting the no of trajectories that go towards the periphery and that go away from the periphery
dotp_fin_neg = Dotp_fin(Dotp_fin < 0); no_of_neg_dotpvalues = numel(dotp_fin_neg); % getting the positive values in the array 'Dotp_fin' and counting the number of positive values
dotp_fin_pos = Dotp_fin(Dotp_fin > 0); no_of_pos_dotpvalues = numel(dotp_fin_pos); % getting the negative values in the array 'Dotp_fin' and counting the number of negative values
Trajdirections = {sprintf('Away from \\newline Periphery'), sprintf('Towards \\newlinePeriphery')}; % setting the string array to be used as Xlabel
total_dotpvalues = no_of_neg_dotpvalues + no_of_pos_dotpvalues;
Trajdirections_values = [(no_of_neg_dotpvalues*100/total_dotpvalues), (no_of_pos_dotpvalues*100/total_dotpvalues)]; % getting the positive & negative values into one array
figure(101); bar(Trajdirections_values, 'LineWidth', 1, 'FaceColor', 'r', 'EdgeColor', 'b'); set(gca,'fontsize',16);  xticklabels(Trajdirections); ylabel('No. of Trajectories [%]'); % xtickangle(45);
saveas(gcf, fullfile(BB_apical_avg, 'Dotproduct_traj_direction_count'), 'fig'); saveas(gcf, fullfile(BB_apical_avg, 'Dotproduct_traj_direction_count'), 'tif');
close(figure(101));
clear parameter

%------------------------------- BB characteristics ---------------------------------%

% BB step distance
parameter = step_dist_fin; bininterval = 0.025; Xlabel = 'Step distance [\mum]'; Ylabel = 'Probability density'; Plot_title = 'BB Step distance'; save_title = 'BB_Step_distance';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

% BB instantaneous speed
parameter = inst_speed_fin; bininterval = 0.025; Xlabel = 'Speed [\mum / min]'; Ylabel = 'Probability density'; Plot_title = 'BB Instantaneous speed'; save_title = 'BB_Instantaneous_speed';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

% BB difference in x coordinate steps
parameter = step_x_dist_fin; bininterval = 0.025; Xlabel = 'x step [\mum]'; Ylabel = 'Probability density'; Plot_title = 'Difference in "x" steps of BB tracks'; save_title = 'Difference_in_x_steps_of_BB_tracks';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

% BB difference in y coordinate steps
parameter = step_y_dist_fin; bininterval = 0.025; Xlabel = 'y step [\mum]'; Ylabel = 'Probability density'; Plot_title = 'Difference in "y" steps of BB tracks'; save_title = 'Difference_in_y_steps_of_BB_tracks';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

% BB difference in x & y coordinate steps pooled together
parameter = step_x_y_dist_fin; bininterval = 0.025; Xlabel = 'x & y steps [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Difference in "x & y" coordinate steps', 'of BB tracks, pooled together'}; save_title = 'Difference_in_x_y_steps';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%----------------------------- All BB appearance distances (new BB in current & new BB in previous frame) -----------------------------------%

% BB appearance distance (All distances between new BB in the current & previous frames)  vs Area & Time
area_data = new_BB_appearance_all_dist_area_fin; time_data = new_BB_appearance_all_dist_time_fin; new_parameter = new_BB_appearance_all_dist_fin;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'BB appearance distance [\mum]'; plot_Title_1 = {'Distances of newly appearing BB,', '[between the current and previous frames vs Area]'}; save_title_1 = 'All_distances_newBB_current_&_previous_frames_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'BB appearance distance [\mum]'; plot_Title_2 = {'Distances of newly appearing BB,', '[between the current and previous frames vs Time]'}; save_title_2 = 'All_distances_newBB_current_&_previous_frames_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_new_new_allDist_vs_area = binXY_parameter_vs_area; new_new_allDist_XData_area = XData_area; new_new_allDist_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% BB appearance distance (All distances between new BB in the current & previous frames)
parameter = new_new_allDist_YData_area; bininterval = 0.5; Xlabel = 'BB appearance distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Distances of newly appearing BB,', '[between the current and previous frames]'}; save_title = 'All_distances_newBB_current_&_previous_frames';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%----------------------------- Averaged (per frame) - All BB appearance distances (new BB in current & new BB in previous frame) -----------------------------------%

% BB appearance distance - Averaged (per frame) - (All distances between new BB in the current & previous frames)
save_title = 'All_Avgd_distances_newBB_current_&_previous_frames';
[AvgNewNewBBAllDist_XData_area, AvgNewNewBBAllDist_XData_time, AvgNewNewBBAllDist_YData_area] = area_time_shift_for_histograms(Avg_NewNewBB_AllDist(:,2), Avg_NewNewBB_AllDist(:,1), Avg_NewNewBB_AllDist(:,4), max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, save_title);
parameter = AvgNewNewBBAllDist_YData_area; bininterval = 0.5; Xlabel = 'BB appearance distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Distances of newly appearing BB, averaged per frame', '[between the current and previous frames]'};
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%------------------------------- Minimal BB appearance distance (new BB in current frame & new BB in previous frame) ---------------------------------%

% Minimal BB appearance distance (Minimal distance between new BB in current frame & new BB in previous frame)  vs Area, Time, BB count, BB density
area_data = Area_t0_BB_mod; time_data = time_bb_appear_dist; new_parameter = Distn_in_micron; new_parameter_2 = no_of_bb_t0_mod; new_parameter_3 = bb_density_t0_mod;
bininterval_for_Binparameter_1 = 25; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Minimum BB appearance distance [\mum]'; plot_Title_1 = 'BB appearance distance vs Area'; save_title_1 = 'BB_appearance_distance_vs_Area';
bininterval_for_Binparameter_2 = 15; xLabel_2 = 'Time [min]'; yLabel_2 = 'Minimum BB appearance distance [\mum]'; plot_Title_2 = 'BB appearance distance vs Time'; save_title_2 = 'BB_appearance_distance_vs_Time';
bininterval_for_Binparameter_3 = 5; xLabel_3 = 'BB count'; yLabel_3 = 'Minimum BB appearance distance [\mum]'; plot_Title_3 = 'BB appearance distance vs BB count'; save_title_3 = 'BB_appearance_distance_vs_BB_count';
bininterval_for_Binparameter_4 = 0.025; xLabel_4 = 'BB density [\mum^{-2}]'; yLabel_4 = 'Minimum BB appearance distance [\mum]'; plot_Title_4 = 'BB appearance distance vs BB density'; save_title_4 = 'BB_appearance_distance_vs_BB_density';
[binXY_bbdist_vs_area, XData_area, YData_area, binXY_bbdist_vs_time, binXY_bbdist_vs_3rdparameter, binXY_bbdist_vs_4thparameter] = parameter_vs_area_time_third_fourth_parameter(area_data, time_data, new_parameter, new_parameter_2, new_parameter_3, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, ...
    bininterval_for_Binparameter_3, xLabel_3, yLabel_3, plot_Title_3, save_title_3, bininterval_for_Binparameter_4, xLabel_4, yLabel_4, plot_Title_4, save_title_4, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_NewNewBBdist_vs_area = binXY_bbdist_vs_area; NewNewBBappearancedist_XData_area = XData_area; NewNewBBappearancedist_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 bininterval_for_Binparameter_3 xLabel_3 yLabel_3 plot_Title_3 save_title_3 bininterval_for_Binparameter_4 xLabel_4 yLabel_4 plot_Title_4 save_title_4 binXY_bbdist_vs_area XData_area YData_area binXY_bbdist_vs_time binXY_bbdist_vs_3rdparameter binXY_bbdist_vs_4thparameter

% Minimal BB appearance distance (Minimal distance between new BB in current frame & new BB in previous frame)
parameter = NewNewBBappearancedist_YData_area; bininterval = 0.5; Xlabel = 'Minimum BB appearance distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Minimum BB appearance distance', '[between the current and previous frames]'}; save_title = 'Minimum_BB_appearance_distance';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%------------------------------- Averaged (per frame) - Minimal BB appearance distance (new BB in current frame & new BB in previous frame) ---------------------------------%

% Minimal BB appearance distance - Averaged (per frame) - (Minimal distance between new BB in current frame & new BB in previous frame)
save_title = 'Minimum_BB_appearance_Avgd_distance';
[AvgNewNewBBMinDist_XData_area, AvgNewNewBBMinDist_XData_time, AvgNewNewBBMinDist_YData_area] = area_time_shift_for_histograms(Avg_NewNewBB_MinDist(:,2), Avg_NewNewBB_MinDist(:,1), Avg_NewNewBB_MinDist(:,4), max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, save_title);
parameter = AvgNewNewBBMinDist_YData_area; bininterval = 0.5; Xlabel = 'Minimum BB appearance distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Minimum BB appearance distance, averaged per frame', '[between the current and previous frames]'};
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%------------------------------- Distance fraction ---------------------------------%

% New BB count vs Distance fraction
% Note that although Distance fraction is plotted, the variable / array is named as area fraction just to prevent changing the name at various places. Originally it was area fraction. But then I took a sqrt to make it
% into a distance fraction. For more details check "bb_appearance_distance_location.m".
figure(100);
Area_Fraction_linear = Area_Fraction(:); BB_in_Area_fraction_linear = BB_in_Area_fraction(:);
bininterval_for_Binparameter = 0.1;
binrange_area_frac = min(Area_Fraction_linear) : bininterval_for_Binparameter : max(Area_Fraction_linear)+bininterval_for_Binparameter; % setting the binrange for the area fraction
[~, edges_area_frac, bin_area_frac] = histcounts(Area_Fraction_linear, binrange_area_frac); % obtaining the counts and bin edges for area fraction
binsum_bb_in_area_frac = accumarray(bin_area_frac(:), BB_in_Area_fraction_linear(:)); % obtaining the bin sum in bb_in_area_fraction over the bin ranges of area fraction
barplot_area_frac = bar(edges_area_frac(1:end-1), binsum_bb_in_area_frac); barplot_area_frac.FaceColor = 'b'; barplot_area_frac.EdgeColor = 'r';
xlabel('Distance fraction'); ylabel('No. of newly appearing BBs'); title('New BB count vs Distance fraction'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical_avg, 'New_BB_count_vs_Distance_fraction'), 'fig'); saveas(gcf, fullfile(BB_apical_avg, 'New_BB_count_vs_Distance_fraction'), 'tif');
clear bininterval_for_Binparameter binrange_area_frac edges_area_frac bin_area_frac binsum_bb_in_area_frac barplot_area_frac
close (figure(100));

%--------------------------------- All BB appearance distance (new BB & already existing BBs in the same frame) -------------------------------%

% BB appearance distance (All distances between new BB and the already existing BBs in the same frame) vs Area & Time
area_data = new_vs_exist_bb_all_dist_area; time_data = new_vs_exist_bb_all_dist_time; new_parameter = new_vs_exist_bb_all_dist;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'BB appearance distance [\mum]'; plot_Title_1 = {'Distances of all newly appearing BB,', 'to all already existing BBs in the same frame vs Area'}; save_title_1 = 'All_distances_newBB_existingBB_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'BB appearance distance [\mum]'; plot_Title_2 = {'Distances of all newly appearing BB,', 'to all already existing BBs in the same frame vs Time'}; save_title_2 = 'All_distances_newBB_existingBB_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_new_existing_allDist_vs_area = binXY_parameter_vs_area; new_existing_allDist_XData_area = XData_area; new_existing_allDist_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% BB appearance distance (All distances between new BB and the already existing BBs in the same frame)
parameter = new_existing_allDist_YData_area; bininterval = 0.5; Xlabel = 'BB appearance distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Distances of all newly appearing BB,', 'to all already existing BBs in the same frame'}; save_title = 'All_distances_newBB_existingBB';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%--------------------------------- Averaged (per frame) - All BB appearance distance (new BB & already existing BBs in the same frame) -------------------------------%

% BB appearance distance - Averaged (per frame) - (All distances between new BB and the already existing BBs in the same frame)
save_title = 'All_Avgd_distances_newBB_existingBB';
[AvgNewExistBBAllDist_XData_area, AvgNewExistBBAllDist_XData_time, AvgNewExistBBAllDist_YData_area] = area_time_shift_for_histograms(Avg_NewExistBB_AllDist(:,2), Avg_NewExistBB_AllDist(:,1), Avg_NewExistBB_AllDist(:,3), max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, save_title);
parameter = AvgNewExistBBAllDist_YData_area; bininterval = 0.5; Xlabel = 'BB appearance distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Distances of all newly appearing BB, averaged per frame', 'to all already existing BBs in the same frame'};
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%------------------------------- Minimal BB appearance distance (new BB & already existing BBs in the same frame) ---------------------------------%

% Minimal BB appearance distance (Minimal distance between new BB and the already existing BBs in the same frame) vs Area, Time, BB count, BB density
area_data = new_vs_exist_bb_min_dist_area; time_data = new_vs_exist_bb_min_dist_time; new_parameter = new_vs_exist_bb_min_dist; new_parameter_2 = new_vs_exist_bb_min_dist_bbcount; new_parameter_3 = new_vs_exist_bb_min_dist_bbdensity;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Minimum BB appearance distance [\mum]'; plot_Title_1 = {'Minimum distance of a newly appearing BB to the,', 'closest, already existing BB in the same frame vs Area'}; save_title_1 = 'Minimum_distance_newBB_existingBB_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Minimum BB appearance distance [\mum]'; plot_Title_2 = {'Minimum distance of a newly appearing BB to the,', 'closest, already existing BB in the same frame vs Time'}; save_title_2 = 'Minimum_distance_newBB_existingBB_vs_Time';
bininterval_for_Binparameter_3 = 5; xLabel_3 = 'BB count'; yLabel_3 = 'Minimum BB appearance distance [\mum]'; plot_Title_3 = {'Minimum distance of a newly appearing BB to the,', 'closest, already existing BB in the same frame vs BB count'}; save_title_3 = 'Minimum_distance_newBB_existingBB_vs_BB_count';
bininterval_for_Binparameter_4 = 0.025; xLabel_4 = 'BB density [\mum^{-2}]'; yLabel_4 = 'Minimum BB appearance distance [\mum]'; plot_Title_4 = {'Minimum distance of a newly appearing BB to the,', 'closest, already existing BB in the same frame vs BB density'}; save_title_4 = 'Minimum_distance_newBB_existingBB_vs_BB_density';
[binXY_bbdist_vs_area, XData_area, YData_area, binXY_bbdist_vs_time, binXY_bbdist_vs_3rdparameter, binXY_bbdist_vs_4thparameter] = parameter_vs_area_time_third_fourth_parameter(area_data, time_data, new_parameter, new_parameter_2, new_parameter_3, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, ...
    bininterval_for_Binparameter_3, xLabel_3, yLabel_3, plot_Title_3, save_title_3, bininterval_for_Binparameter_4, xLabel_4, yLabel_4, plot_Title_4, save_title_4, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_NewExistdist_vs_area = binXY_bbdist_vs_area; NewExistingBBappearancedist_XData_area = XData_area; NewExistingBBappearancedist_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 bininterval_for_Binparameter_3 xLabel_3 yLabel_3 plot_Title_3 save_title_3 bininterval_for_Binparameter_4 xLabel_4 yLabel_4 plot_Title_4 save_title_4 binXY_bbdist_vs_area XData_area YData_area binXY_bbdist_vs_time binXY_bbdist_vs_3rdparameter binXY_bbdist_vs_4thparameter

% Minimal BB appearance distance (Minimal distance between new BB and the already existing BBs in the same frame)
parameter = NewExistingBBappearancedist_YData_area; bininterval = 0.05; Xlabel = 'Minimum BB appearance distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Minimum distance of a newly appearing BB,', 'to the closest, already existing BB in the same frame'}; save_title = 'Minimum_distance_newBB_existingBB';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%------------------------------- Averaged (per frame) - Minimal BB appearance distance (new BB & already existing BBs in the same frame) ---------------------------------%

% Minimal BB appearance distance - Averaged (per frame) - (Minimal distance between new BB and the already existing BBs in the same frame)
save_title = 'Minimum_Avgd_distance_newBB_existingBB';
[AvgNewExistBBMinDist_XData_area, AvgNewExistBBMinDist_XData_time, AvgNewExistBBMinDist_YData_area] = area_time_shift_for_histograms(Avg_NewExistBB_MinDist(:,2), Avg_NewExistBB_MinDist(:,1), Avg_NewExistBB_MinDist(:,3), max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, save_title);
parameter = AvgNewExistBBMinDist_YData_area; bininterval = 0.05; Xlabel = 'Minimum BB appearance distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Minimum distance of a newly appearing BB, averaged per frame', 'to the closest, already existing BB in the same frame'};
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%------------------------------ All inter BB distances (between all BBs in the same frame) ----------------------------------%

% Inter BB distance (All distances between every BB and all other BBs in the same frame) vs Area & Time
area_data = neighbor_bb_all_dist_area; time_data = neighbor_bb_all_dist_time; new_parameter = neighbor_bb_all_dist;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Distance between BBs [\mum]'; plot_Title_1 = {'Distance between all BBs', 'in every frame vs Area'}; save_title_1 = 'Distance_between_all_BBs_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Distance between BBs [\mum]'; plot_Title_2 = {'Distance between all BBs', 'in every frame vs Time'}; save_title_2 = 'Distance_between_all_BBs_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_Existing_allDist_vs_area = binXY_parameter_vs_area; Existing_allDist_XData_area = XData_area; Existing_allDist_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Inter BB distance (All distances between every BB and all other BBs in the same frame)
parameter = Existing_allDist_YData_area; bininterval = 0.5; Xlabel = 'Distance between BBs [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Distance between all BBs', 'in every frame'}; save_title = 'Distance_between_all_BBs';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%------------------------------ Averaged (per frame) - All inter BB distances (between all BBs in the same frame) ----------------------------------%

% Inter BB distance - Averaged (per frame) - (All distances between every BB and all other BBs in the same frame)
save_title = 'Avgd_Distance_between_all_BBs';
[AvgExistBBAllDist_XData_area, AvgExistBBAllDist_XData_time, AvgExistBBAllDist_YData_area] = area_time_shift_for_histograms(Avg_ExistBB_AllDist(:,2), Avg_ExistBB_AllDist(:,1), Avg_ExistBB_AllDist(:,3), max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, save_title);
parameter = AvgExistBBAllDist_YData_area; bininterval = 0.5; Xlabel = 'Distance between BBs [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Distance between all BBs, averaged per frame', 'in every frame'};
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%------------------------------- Nearest neighbor distance between BBs (between all BBs in the same frame) ---------------------------------%

% Nearest neighbor BB distance (Minimal distance between every BB and all other BBs in the same frame) vs Area, Time, BB count, BB density
area_data = neighbor_bb_min_dist_area; time_data = neighbor_bb_min_dist_time; new_parameter = neighbor_bb_min_dist; new_parameter_2 = neighbor_bb_min_dist_bbcount; new_parameter_3 = neighbor_bb_min_dist_bbdensity;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Nearest Neighbor distance [\mum]'; plot_Title_1 = {'Nearest neighbor distance of all BB,', 'over time i.e. vs Area'}; save_title_1 = 'Nearest_Neighbor_distance_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Nearest Neighbor distance [\mum]'; plot_Title_2 = {'Nearest neighbor distance of all BB,', 'over time i.e. vs Time'}; save_title_2 = 'Nearest_Neighbor_distance_vs_Time';
bininterval_for_Binparameter_3 = 5; xLabel_3 = 'BB count'; yLabel_3 = 'Nearest Neighbor distance [\mum]'; plot_Title_3 = {'Nearest neighbor distance of all BB,', 'over time i.e. vs BB count'}; save_title_3 = 'Nearest_Neighbor_distance_vs_BB_count';
bininterval_for_Binparameter_4 = 0.025; xLabel_4 = 'BB density [\mum^{-2}]'; yLabel_4 = 'Nearest Neighbor distance [\mum]'; plot_Title_4 = {'Nearest neighbor distance of all BB,', 'over time i.e. vs BB density'}; save_title_4 = 'Nearest_Neighbor_distance_vs_BB_density';
[binXY_bbdist_vs_area, XData_area, YData_area, binXY_bbdist_vs_time, binXY_bbdist_vs_3rdparameter, binXY_bbdist_vs_4thparameter] = parameter_vs_area_time_third_fourth_parameter(area_data, time_data, new_parameter, new_parameter_2, new_parameter_3, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, ...
    bininterval_for_Binparameter_3, xLabel_3, yLabel_3, plot_Title_3, save_title_3, bininterval_for_Binparameter_4, xLabel_4, yLabel_4, plot_Title_4, save_title_4, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_NearNeighbdist_vs_area = binXY_bbdist_vs_area; NearNeighbdist_XData_area = XData_area; NearNeighbdist_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 bininterval_for_Binparameter_3 xLabel_3 yLabel_3 plot_Title_3 save_title_3 bininterval_for_Binparameter_4 xLabel_4 yLabel_4 plot_Title_4 save_title_4 binXY_bbdist_vs_area XData_area YData_area binXY_bbdist_vs_time binXY_bbdist_vs_3rdparameter binXY_bbdist_vs_4thparameter

% Nearest neighbor BB distance (Minimal distance between every BB and all other BBs in the same frame)
parameter = NearNeighbdist_YData_area; bininterval = 0.075; Xlabel = 'Nearest Neighbor distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Nearest Neighbor distance of BBs', 'w.r.to all other BBs in every frame'}; save_title = 'Nearest_Neighbor_distance';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%------------------------------- Averaged (per frame) - Nearest neighbor distance between BBs (between all BBs in the same frame) ---------------------------------%

% Nearest neighbor BB distance - Averaged (per frame) - (Minimal distance between every BB and all other BBs in the same frame)
save_title = 'Nearest_Neighbor_Avgd_distance';
[AvgNearNeighbourBBMinDist_XData_area, AvgNearNeighbourBBMinDist_XData_time, AvgNearNeighbourBBMinDist_YData_area] = area_time_shift_for_histograms(Avg_NearNeighbourBB_MinDist(:,2), Avg_NearNeighbourBB_MinDist(:,1), Avg_NearNeighbourBB_MinDist(:,3), max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, save_title);
parameter = AvgNearNeighbourBBMinDist_YData_area; bininterval = 0.075; Xlabel = 'Nearest Neighbor distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Nearest Neighbor distance of BBs', 'w.r.to all other BBs in every frame'};
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%------------------------------ MSD of coarsegrained data ----------------------------------%

% MSD of coarsegrained data (plotting the average for every cell i.e. the average of all BB trajectories from every cell)
% standard plot
figure(100); plot(msd_xaxis_min, MSD_yaxis, 'color', 'k'); xlabel('Time [min]'); ylabel('MSD [\mum^2]'); title('MSD vs lagtime - standard plot'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical_avg, 'MSD_std_avg_of_individual_cell'), 'fig'); saveas(gcf, fullfile(BB_apical_avg, 'MSD_std_avg_of_individual_cell'), 'tif');
% loglog plot
figure(101); loglog(msd_xaxis, MSD_yaxis, 'color', 'k'); xlabel('Time [s]'); ylabel('MSD [\mum^2]'); title('MSD vs lagtime - log-log plot'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical_avg, 'MSD_loglog_avg_of_individual_cell'), 'fig'); saveas(gcf, fullfile(BB_apical_avg, 'MSD_loglog_avg_of_individual_cell'), 'tif');
close (figure(100), figure(101));

% Plotting the MSD for all trajectories i.e pooling all trajectories from all cells (unlike plotting the average for ever cell, as above) (for more information, check the "msd_coarsegrained.m" script)
noof_trajectorys = size(msd_traj,1);
for cell_no = 1:no_of_cells
    for trajno = 1:noof_trajectorys
        if isempty(msd_traj{trajno, cell_no})
            break
        end
        no_of_msds =  msd_traj{trajno, cell_no}.no; time_Interval = msd_traj{trajno, cell_no}.TimeInterval;
        xaxis = (1:no_of_msds)*time_Interval; 
        yaxis = msd_traj{trajno, cell_no}.msd(1:no_of_msds); 

        % % The section below is to restrict the MSD analysis to 2.5 h; Meaning, we want to analyse the trajectories only upto 2.5 h.
        % % Right now, the analysis analyzes trajectories for the entire experiment. In order to analyse only for 2.5 h, uncomment the section below.
        % %------------------------------%
        % time_threshold = 9000; % 9000 here corresponds to seconds. 9000 seconds is 2.5 h or 150 min
        % xaxis = xaxis(xaxis <= time_threshold); % limiting the x axis to 2.5 h
        % yaxis = yaxis(1:length(xaxis)); % limiting the y axis to 2.5 h
        %------------------------------%
        
        greycolor = [0.7, 0.7, 0.7]; % defining the x and y axis and the color for the plot
        figure(100);
        loglog(xaxis, yaxis, 'Color', greycolor); % plotting the msd in log-log format
        hold on;
        figure(101);
        xaxis_min = xaxis / 60; % converting the time units to minutes for plotting the standard plot
        std_plot = plot(xaxis_min, yaxis, 'r', 'LineWidth', 0.01); % plotting the msd in standard format; this command "std_plot.Color(4)=0.1;" can be used for setting the opacity for the lines
        hold on;
    end
end
clear cell_no trajno noof_trajectorys no_of_msds time_Interval xaxis yaxis xaxis_min

% Average MSD calculation

msd_traj_mod = msd_traj(~cellfun(@isempty, msd_traj)); % reassigning the "trajectories" cell array after removing all the empty arrays. The empty arrays are created because those trajectories
% less than "traj_filter_duration" are not analysed. The difference in the count (between the analysed and un-analysed trajectories) will be entered as empty arrays. These empty arrays are removed here.
no_of_trajec = length(msd_traj_mod); % obtaining the number of trajectories that were analysed
No_of_Trajectories_sum = sum(No_of_Trajectories);
ind_for_timeseries_of_longesttrajectory = find(Length_xaxis(2,:)==max(Length_xaxis(2,:)));
LongesTTrajectory = Longesttrajectory(ind_for_timeseries_of_longesttrajectory);

% below we obtain the average msd for all the trajectories
diff_coef_direct = zeros(1, no_of_trajec); % pre-assignment
diff_coef_fit = zeros(1, no_of_trajec); % pre-assignment
diff_strength_fit = zeros(1, no_of_trajec);
alpha_value = zeros(1, no_of_trajec); % pre-assignment
sum_of_msd = zeros(1, LongesTTrajectory); % pre-assignment
sum_of_msd_count = zeros(1, LongesTTrajectory); % pre-assignment
% the for loop goes through all the trajectories and sums the msd values so that an average can be obtained
for trajno = 1:no_of_trajec % note that the trajno here goes through the updated value of "no_of_trajectories"; so it will not take the same values as "trajno" in the above "for loop"
    no_of_msds = length(msd_traj_mod{trajno}.msd); % number of msd
    diff_coef_direct(trajno) = msd_traj_mod{trajno}.DiffusionCoefficient_direct; % fetching and storing the diffusion coefficients (obtained from first MSD value) of all trajectories
    diff_coef_fit(trajno) = msd_traj_mod{trajno}.DiffusionCoefficient_fitting; % fetching and storing the diffusion coefficients (obtained from fitting) of all trajectories
    alpha_value(trajno) = msd_traj_mod{trajno}.alpha_value; % fetching and storing the alpha value of all trajectories
    diff_strength_fit(trajno) = msd_traj_mod{trajno}.DiffusionCoefficient_fitting .* (round(msd_traj_mod{trajno}.TimeInterval) .^ (alpha_value(trajno)-1)); % fetching and storing the diffusion strengths (obtained from fitting) of all trajectories
    sum_of_msd(1:no_of_msds) = sum_of_msd(1:no_of_msds) + msd_traj_mod{trajno}.msd; % getting the sum of msds of all trajectories
    sum_of_msd_count(1:no_of_msds) = sum_of_msd_count(1:no_of_msds) + 1; % getting the msd counts
end

averageMSD = sum_of_msd ./ sum_of_msd_count; % average msd
% Below are the averages of diffusion coefficients & alpha values (obtained by taking the average of all diffusion coeffcients (or alpha values) obtained from plotting all the msds of all BB trajectories from all cells;
diff_coef_direct_minutes = diff_coef_direct .* 60; diff_coef_fit_minutes = diff_coef_fit .* 60; % converting the diffusion coefficients to (micrometer squared per minute)
avg_Dif_Coeff_direct = mean(diff_coef_direct_minutes); avg_Dif_Coeff_fit = mean(diff_coef_fit_minutes); % unit is (micrometer squared per minute)
avg_diff_strength_fit = mean(diff_strength_fit); % units in µm2/s; check the msd_coarsegrained.m to know what is diffusion strength
avg_alpha_value = mean(alpha_value); % dimensionless quantity
% avg_Diff_Coeff_direct_uncertainty = std(diff_coef_direct) / sqrt(length(diff_coef_direct)); % average diffusion coefficient uncertainty

% plotting the average MSD plots in log & linear space
figure(100);
xaxis = msd_xaxis(:, ind_for_timeseries_of_longesttrajectory); yaxis = averageMSD;

% % The section below is to restrict the MSD analysis to 2.5 h; Meaning, we want to analyse the trajectories only upto 2.5 h.
% % Right now, the analysis analyzes trajectories for the entire experiment. In order to analyse only for 2.5 h, uncomment the section below.
% %------------------------------%
% time_threshold = 9000; % 9000 here corresponds to seconds. 9000 seconds is 2.5 h or 150 min
% xaxis = xaxis(xaxis <= time_threshold); % limiting the x axis to 2.5 h
% yaxis = yaxis(1:length(xaxis)); % limiting the y axis to 2.5 h
% %------------------------------%

loglog(xaxis, yaxis, 'k', 'LineWidth', 1); % log-log plot
hold on;
% the function below gets both the alpha value and the diffusion coefficient for the Average plot; the diffusion coefficient is obtained by two means: (1) from the y intercept of the slope of MSD plot in log
% space (diff_coeff_fit_avg) & (2) from the first MSD value (diff_coef_direct_avg). For more details look at the function
[x_for_fit_avg, y_from_fit_model_lin_avg, alpha_value_avg_plot, diff_coeff_fit_avg_plot, diff_coef_direct_avg_plot] = msd_logplot_fitting(xaxis', yaxis); % calling the function for plot fitting & getting the alpha value & diffusion coefficient
% Below we change the units of the diffusion coefficients from (micrometer squared per second) to (micrometer squared per minute).
diff_coeff_fit_avg_plot = diff_coeff_fit_avg_plot * 60; % diff.coeff from the fit
diff_coef_direct_avg_plot = diff_coef_direct_avg_plot * 60; % diff. coeff from the first MSD value
loglog(x_for_fit_avg, y_from_fit_model_lin_avg, 'r-', 'LineWidth', 1.5); % plotting the fit
xlabel('Time [s]'); ylabel('MSD [\mum^2]'); title('MSD for coarsegrained data log-log plot');
saveas(gcf, fullfile(BB_apical_avg, 'MSD_loglog_avg_all_trajectories'), 'fig'); saveas(gcf, fullfile(BB_apical_avg, 'MSD_loglog_avg_all_trajectories'), 'tif');

figure(101);
% xaxis_min = msd_xaxis_min(:, ind_for_timeseries_of_longesttrajectory); % converting the time units to minutes for plotting the standard plot
xaxis_min = xaxis/60; % converting the time units to minutes for plotting the standard plot
plot(xaxis_min, yaxis, 'k', 'LineWidth', 1);% standard plot
xlabel('Time [min]'); ylabel('MSD [\mum^2]'); title('MSD for coarsegrained data Standard plot');
saveas(gcf, fullfile(BB_apical_avg, 'MSD_std_avg_all_trajectories'), 'fig'); saveas(gcf, fullfile(BB_apical_avg, 'MSD_std_avg_all_trajectories'), 'tif');
close (figure(100), figure(101));
clear xaxis yaxis xaxis_min

% plotting the distribution of Diffusion coefficients (here the diff.coeff. obtained from the first MSD value is plotted)
parameter = diff_coef_direct_minutes; bininterval = 0.005; Xlabel = 'Diffusion coefficients [\mum^2 min^{-1}]'; Ylabel = 'Probability density'; Plot_title = 'Diffusion coefficient (from 1st MSD value) of all trajectories'; save_title = 'diff_coeff_direct_all_trajs';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

% plotting the distribution of Diffusion coefficients (here the diff.coeff. obtained from fitting is plotted)
parameter = diff_coef_fit_minutes; bininterval = 0.01; Xlabel = 'Diffusion coefficients [\mum^2 min^{-1}]'; Ylabel = 'Probability density'; Plot_title = 'Diffusion coefficient (from fitting) of all trajectories'; save_title = 'diff_coeff_fit_all_trajs';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

% plotting the distribution of Diffusion strengths (based on the diff.coeff. obtained from fitting)
diff_strength_fit_min = diff_strength_fit*60; % conversion to minutes, so the units become  µm2/min;
parameter = diff_strength_fit_min; bininterval = 0.005; Xlabel = 'Diffusion strength [\mum^2 min^{-1}]'; Ylabel = 'Probability density'; Plot_title = 'Diffusion strength of all trajectories'; save_title = 'diff_strength_all_trajs';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

% plotting the distribution of alpha values
parameter = alpha_value; bininterval = 0.05; Xlabel = '\alpha value'; Ylabel = 'Probability density'; Plot_title = 'alpha value / slope of all trajectories'; save_title = 'alpha_value_all_trajs';
hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title);
clear parameter

%-------------------- Diffusion coefficient from coarse grained data ----------------------%

% Diffusion Strength of BBs from the coarsegrained data
figure(100); plot(Whole_area_rate, Avg_Diff_strength_fit,  'ok'); xlabel('Rate of area expansion [\mum^2 min^{-1}]'); ylabel('Diffusion Strength [\mum^2]'); title('Diff. strength vs Rate of apical area expansion'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical_avg, 'DiffStrength_vs_Area_rate'), 'fig'); saveas(gcf, fullfile(BB_apical_avg, 'DiffStrength_vs_Area_rate'), 'tif');
close (figure(100));

%% Quadrant analysis
%------------------------------- Quadrant Plots ---------------------------------%

% storing the names of all the temporary plots
quad_fig_names = {'quad_area_absolute_vs_area', 'quad_area_absolute_vs_time', 'quad_area_normalised_vs_area', 'quad_area_normalised_vs_time', ...
    'quad_bbcount_absolute_vs_area', 'quad_bbcount_absolute_vs_time', 'quad_bbcount_normalised_vs_area', 'quad_bbcount_normalised_vs_time'...
    'quad_arearate_absolute_vs_area', 'quad_arearate_absolute_vs_time', 'quad_arearate_normalised_vs_area', 'quad_arearate_normalised_vs_time', ...
    'quad_bbdensity_absolute_vs_area', 'quad_bbdensity_absolute_vs_time', 'quad_bbdensity_normalised_vs_area', 'quad_bbdensity_normalised_vs_time',...
    'quad_actinMeanIntnorm_vs_area', 'quad_actinMeanIntnorm_vs_time', 'quad_actinTotalIntnorm_vs_area', 'quad_actinTotalIntnorm_vs_time',...
    'quad_Newbbcount_absolute_vs_area', 'quad_Newbbcount_absolute_vs_time', 'quad_Newbbcount_normalised_vs_area', 'quad_Newbbcount_normalised_vs_time'};
half_fig_names = {'half_area_absolute_vs_area', 'half_area_absolute_vs_time', 'half_area_normalised_vs_area', 'half_area_normalised_vs_time', ...
    'half_BBcount_absolute_vs_area', 'half_BBcount_absolute_vs_time', 'half_BBcount_normalised_vs_area', 'half_BBcount_normalised_vs_time', ...
    'half_arearate_absolute_vs_area', 'half_arearate_absolute_vs_time', 'half_arearate_normalised_vs_area', 'half_arearate_normalised_vs_time'...
    'half_BBdensity_absolute_vs_area', 'half_BBdensity_absolute_vs_time', 'half_BBdensity_normalised_vs_area', 'half_BBdensity_normalised_vs_time', ...
    'half_ActinMeanIntnorm_vs_area', 'half_ActinMeanIntnorm_vs_time', 'half_ActinTotalIntnorm_vs_area', 'half_ActinTotalIntnorm_vs_time',...
    'half_Newbbcount_absolute_vs_area', 'half_Newbbcount_absolute_vs_time', 'half_Newbbcount_normalised_vs_area', 'half_Newbbcount_normalised_vs_time'};

% Quadrant, Top-bottom Half & Left-right Half Plots
% Quadrant plots
parfor qno = 1:4
    % Quadrant area vs Area & Time
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_quad_areas{1,qno}, 'Quadrant Area [\mum^2]', 'Quadrant Area [\mum^2]', {'Quadrant area (absolute) vs', 'apical domain area'}, 'Quadrant area (absolute) vs time', strcat(quad_fig_names{1,1}, sprintf('%01d',qno)), strcat(quad_fig_names{1,2}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    [~, XData_area, YData_area, ~] = quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_quad_areas_norm{1,qno}, 'Quadrant Area (normalised)', 'Quadrant Area (normalised)', {'Quadrant area (normalised) vs', 'apical domain area'}, 'Quadrant area (normalised) vs time', strcat(quad_fig_names{1,3}, sprintf('%01d',qno)), strcat(quad_fig_names{1,4}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    quad_areaNorm_YData_area_cell{qno} = YData_area; % saving all the 'YData_area' for getting the average of each quadrant of every cell
    quad_areaNorm_XData_area_cell_linearised{qno} = XData_area(~isnan(XData_area(:))); % linearised 'XData_area' for extracting the 'area_time_shifted' values (of all times)
    quad_areaNorm_YData_area_cell_linearised{qno} = YData_area(~isnan(YData_area(:))); % linearised 'YData_area' for extracting the 'area_time_shifted' values (of all times) that can be used for saving in the excel sheet
    % Quadrant BB count vs Area & Time
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_quad_BBcount{1,qno}, 'BB count', 'BB count', 'BB count (absolute) vs apical domain area', 'BB count (absolute) vs time', strcat(quad_fig_names{1,5}, sprintf('%01d',qno)), strcat(quad_fig_names{1,6}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    [~, XData_area, YData_area, ~] = quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_quad_BBcount_norm{1,qno}, 'BB count (normalised)', 'BB count (normalised)', 'BB count (normalised) vs apical domain area', 'BB count (normalised) vs time', strcat(quad_fig_names{1,7}, sprintf('%01d',qno)), strcat(quad_fig_names{1,8}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    quad_BBcountNorm_YData_area_cell{qno} = YData_area; % saving all the 'YData_area' for getting the average of each quadrant of every cell
    quad_BBcountNorm_XData_area_cell_linearised{qno} = XData_area(~isnan(XData_area(:))); % linearised 'XData_area' for extracting the 'area_time_shifted' values (of all times)
    quad_BBcountNorm_YData_area_cell_linearised{qno} = YData_area(~isnan(YData_area(:))); % for extracting the 'area_time_shifted' values (of all times) that can be used for saving in the excel sheet
    % Quadrant Area rate vs Area & Time
    quad_parameter_plots(Area_area_rate, timelist_area_rate, all_quad_AreaRate{1,qno}, 'Quadrant rate of expansion [\mum^2 min^{-1}]', 'Quadrant rate of expansion [\mum^2 min^{-1}]', {'Quadrant expansion rate', '(absolute) vs Area'}, {'Quadrant expansion rate', '(absolute) vs Time'}, strcat(quad_fig_names{1,9}, sprintf('%01d',qno)), strcat(quad_fig_names{1,10}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    [~, XData_area, YData_area, ~] = quad_parameter_plots(Area_area_rate, timelist_area_rate, all_quad_AreaRate_norm{1,qno}, 'Quadrant rate of expansion (normalised)', 'Quadrant rate of expansion (normalised)', {'Quadrant expansion rate', '(normalised) vs Area'}, {'Quadrant expansion rate', '(normalised) vs Time'}, strcat(quad_fig_names{1,11}, sprintf('%01d',qno)), strcat(quad_fig_names{1,12}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    quad_AreaRateNorm_YData_area_cell{qno} = YData_area; % saving all the 'YData_area' for getting the average of each quadrant of every cell
    quad_AreaRateNorm_XData_area_cell_linearised{qno} = XData_area(~isnan(XData_area(:))); % linearised 'XData_area' for extracting the 'area_time_shifted' values (of all times)
    quad_AreaRateNorm_YData_area_cell_linearised{qno} = YData_area(~isnan(YData_area(:))); % for extracting the 'area_time_shifted' values (of all times) that can be used for saving in the excel sheet
    % Quadrant BB density vs Area & Time
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_quad_BBdensity_modified{1,qno}, 'BB density (quadrants) [\mum^{-2}]', 'BB density (quadrants) [\mum^{-2}]', 'BB density (absolute) vs Area', 'BB density (absolute) vs Time', strcat(quad_fig_names{1,13}, sprintf('%01d',qno)), strcat(quad_fig_names{1,14}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    [~, XData_area, YData_area, ~] = quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_quad_BBdensity_norm_modified{1,qno}, 'BB density (quadrants) (normalised)', 'BB density (quadrants) (normalised)', 'BB density (normalised) vs Area', 'BB density (normalised) vs Time', strcat(quad_fig_names{1,15}, sprintf('%01d',qno)), strcat(quad_fig_names{1,16}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    quad_BBdensityNorm_YData_area_cell{qno} = YData_area; % saving all the 'YData_area' for getting the average of each quadrant of every cell
    quad_BBdensityNorm_XData_area_cell_linearised{qno} = XData_area(~isnan(XData_area(:))); % linearised 'XData_area' for extracting the 'area_time_shifted' values (of all times)
    quad_BBdensityNorm_YData_area_cell_linearised{qno} = YData_area(~isnan(YData_area(:))); % for extracting the 'area_time_shifted' values (of all times) that can be used for saving in the excel sheet
    % Quadrant Actin intensity (mean & total) vs Area & Time
    [~, XData_area, YData_area, ~] = quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_quad_meanIntnorm{1,qno}, 'Actin mean Int. (quadrants)', 'Actin mean Int. (quadrants)', 'Mean actin intensity of quadrants vs Area', 'Mean actin intensity of quadrants vs Time', strcat(quad_fig_names{1,17}, sprintf('%01d',qno)), strcat(quad_fig_names{1,18}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    quad_MeanIntnorm_YData_area_cell{qno} = YData_area; % saving all the 'YData_area' for getting the average of each quadrant of every cell
    quad_MeanIntnorm_XData_area_cell_linearised{qno} = XData_area(~isnan(XData_area(:))); % linearised 'XData_area' for extracting the 'area_time_shifted' values (of all times)
    quad_MeanIntnorm_YData_area_cell_linearised{qno} = YData_area(~isnan(YData_area(:))); % for extracting the 'area_time_shifted' values (of all times) that can be used for saving in the excel sheet
    [~, XData_area, YData_area, ~] = quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_quad_totalIntnorm{1,qno}, 'Actin total Int. (quadrants)', 'Actin total Int. (quadrants)', 'Total actin intensity of quadrants vs Area', 'Total actin intensity of quadrants vs Time', strcat(quad_fig_names{1,19}, sprintf('%01d',qno)), strcat(quad_fig_names{1,20}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    quad_TotalIntnorm_YData_area_cell{qno} = YData_area; % saving all the 'YData_area' for getting the average of each quadrant of every cell
    quad_TotalIntnorm_XData_area_cell_linearised{qno} = XData_area(~isnan(XData_area(:))); % linearised 'XData_area' for extracting the 'area_time_shifted' values (of all times)
    quad_TotalIntnorm_YData_area_cell_linearised{qno} = YData_area(~isnan(YData_area(:))); % for extracting the 'area_time_shifted' values (of all times) that can be used for saving in the excel sheet
    % Quadrant newBB count vs Area & Time
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_quad_newBBs{1,qno}, 'New BB count', 'New BB count', 'New BB count (absolute) vs Area', 'New BB count (absolute) vs Time', strcat(quad_fig_names{1,21}, sprintf('%01d',qno)), strcat(quad_fig_names{1,22}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    [~, XData_area, YData_area, ~] = quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_quad_newBBs_norm{1,qno}, 'New BB count (normalised)', 'New BB count (normalised)', 'New BB count (normalised) vs Area', 'New BB count (normalised) vs Time', strcat(quad_fig_names{1,23}, sprintf('%01d',qno)), strcat(quad_fig_names{1,24}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    quad_newBBCountnorm_YData_area_cell{qno} = YData_area; % saving all the 'YData_area' for getting the average of each quadrant of every cell
    quad_newBBCountnorm_XData_area_cell_linearised{qno} = XData_area(~isnan(XData_area(:))); % linearised 'XData_area' for extracting the 'area_time_shifted' values (of all times)
    quad_newBBCountnorm_YData_area_cell_linearised{qno} = YData_area(~isnan(YData_area(:))); % for extracting the 'area_time_shifted' values (of all times) that can be used for saving in the excel sheet

    % halves
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_Half_areas{1,qno}, 'Half section area [\mum^2]', 'Half section area [\mum^2]', {'Half section area (absolute) vs', 'apical domain area'}, 'Half section area (absolute) vs time', strcat(half_fig_names{1,1}, sprintf('%01d',qno)), strcat(half_fig_names{1,2}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_Half_areas_norm{1,qno}, 'Half section area (normalised)', 'Half section area (normalised)', {'Half section area (normalised) vs', 'apical domain area'}, 'Half section area (normalised) vs time', strcat(half_fig_names{1,3}, sprintf('%01d',qno)), strcat(half_fig_names{1,4}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    % Half BB count vs Area & Time
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_Half_BBcount{1,qno}, 'BB count', 'BB count', {'Half section BB count (absolute) vs', 'apical domain area'}, 'Half section BB count (absolute) vs time', strcat(half_fig_names{1,5}, sprintf('%01d',qno)), strcat(half_fig_names{1,6}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_Half_BBcount_norm{1,qno}, 'BB count (normalised)', 'BB count (normalised)', {'Half section BB count (normalised) vs', 'apical domain area'}, 'Half section BB count (normalised) vs time', strcat(half_fig_names{1,7}, sprintf('%01d',qno)), strcat(half_fig_names{1,8}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    % Half Area rate vs Area & Time
    quad_parameter_plots(Area_area_rate, timelist_area_rate, all_Half_AreaRate{1,qno}, 'Area rate [\mum^2 min^{-1}]', 'Area rate [\mum^2 min^{-1}]', {'Half section area expansion rate', '(absolute) vs apical domain area'}, {'Half section area', 'expansion rate (absolute) vs time'}, strcat(half_fig_names{1,9}, sprintf('%01d',qno)), strcat(half_fig_names{1,10}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    quad_parameter_plots(Area_area_rate, timelist_area_rate, all_Half_AreaRate_norm{1,qno}, 'Area rate (normalised)', 'Area rate (normalised)', {'Half section area expansion rate', '(normalised) vs apical domain area'}, {'Half section area', 'expansion rate (normalised) vs time'}, strcat(half_fig_names{1,11}, sprintf('%01d',qno)), strcat(half_fig_names{1,12}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    % Half BB density vs Area & Time
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_Half_BBdensity_modified{1,qno}, 'BB density [\mum^{-2}]', 'BB density [\mum^{-2}]', {'Half section BB density', '(absolute) vs apical domain area'}, {'Half section BB density', '(absolute) vs time'}, strcat(half_fig_names{1,13}, sprintf('%01d',qno)), strcat(half_fig_names{1,14}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_Half_BBdensity_norm_modified{1,qno}, 'BB density (normalised)', 'BB density (normalised)', {'Half section BB density', '(normalised) vs apical domain area'}, {'Half section BB density', '(normalised) vs time'}, strcat(half_fig_names{1,15}, sprintf('%01d',qno)), strcat(half_fig_names{1,16}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    % Half Actin intensity (mean & total) vs Area & Time
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_Half_meanIntnorm{1,qno}, 'Actin mean Int. (halves)', 'Actin mean Int. (halves)', {'Half section Mean actin Int.', '(absolute) vs apical domain area'}, {'Half section Mean actin Int.', '(absolute) vs time'}, strcat(half_fig_names{1,17}, sprintf('%01d',qno)), strcat(half_fig_names{1,18}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_Half_totalIntnorm{1,qno}, 'Actin total Int. (halves)', 'Actin total Int. (halves)', {'Half section Total actin Int.', '(absolute) vs apical domain area'}, {'Half section Total actin Int.', '(absolute) vs time'}, strcat(half_fig_names{1,19}, sprintf('%01d',qno)), strcat(half_fig_names{1,20}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    % Half newBB count vs Area & Time
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_Half_newBBs{1,qno}, 'New BB count', 'New BB count', {'Half section New BB count', '(absolute) vs apical domain area'}, {'Half section New BB count', '(absolute) vs time'}, strcat(half_fig_names{1,21}, sprintf('%01d',qno)), strcat(half_fig_names{1,22}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
    quad_parameter_plots(Quad_apical_area_list, Quad_timelist, all_Half_newBBs_norm{1,qno}, 'New BB count (normalised)', 'New BB count (normalised)', {'Half section New BB count', '(normalised) vs apical domain area'}, {'Half section New BB count', '(normalised) vs time'}, strcat(half_fig_names{1,23}, sprintf('%01d',qno)), strcat(half_fig_names{1,24}, sprintf('%01d',qno)), BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
end

% Below we are getting the average of 'area_time_shifted' parameter values (of all times) and then converting them from cell arrays to matrices, to be used for saving in the excel sheet and later for performing statistical analysis in graph pad prism
% Quadrant area
quad_areaNorm_YData_area_avg_cell = cellfun(@(x) mean(x, 1, 'omitnan'), quad_areaNorm_YData_area_cell, 'UniformOutput', false); % getting the average of this parameter for every quadrant across time points, for all cells. (For ex: time average of all values of this parameter (for ex: 'quadrant area') for quadrant 1), and similarlay for other qudrants. We use this average to compare across quadrants within one condition (for ex. control) and not between conditions. This averaging is different from the variance that we will obtain below where the variance is across quadrants for every time point - and this variance is used to compare between conditions
quad_areaNorm_YData_area_avg = (cell2mat(quad_areaNorm_YData_area_avg_cell'))'; % converting the cell array into a matrix of four columns where columns 1-4 correspond to the quadrants 1-4 & each row corresponds to a cell
% Quadrant BB count
quad_AreaRateNorm_YData_area_avg_cell = cellfun(@(x) mean(x, 1, 'omitnan'), quad_AreaRateNorm_YData_area_cell, 'UniformOutput', false); % getting the average of this parameter for every quadrant across time points, for all cells. (For ex: time average of all values of this parameter (for ex: 'quadrant area') for quadrant 1), and similarlay for other qudrants. We use this average to compare across quadrants within one condition (for ex. control) and not between conditions. This averaging is different from the variance that we will obtain below where the variance is across quadrants for every time point - and this variance is used to compare between conditions
quad_AreaRateNorm_YData_area_avg = (cell2mat(quad_AreaRateNorm_YData_area_avg_cell'))'; % converting the cell array into a matrix of four columns where columns 1-4 correspond to the quadrants 1-4 & each row corresponds to a cell
% Quadrant Area rate
quad_BBcountNorm_YData_area_avg_cell = cellfun(@(x) mean(x, 1, 'omitnan'), quad_BBcountNorm_YData_area_cell, 'UniformOutput', false); % getting the average of this parameter for every quadrant across time points, for all cells. (For ex: time average of all values of this parameter (for ex: 'quadrant area') for quadrant 1), and similarlay for other qudrants. We use this average to compare across quadrants within one condition (for ex. control) and not between conditions. This averaging is different from the variance that we will obtain below where the variance is across quadrants for every time point - and this variance is used to compare between conditions
quad_BBcountNorm_YData_area_avg = (cell2mat(quad_BBcountNorm_YData_area_avg_cell'))'; % converting the cell array into a matrix of four columns where columns 1-4 correspond to the quadrants 1-4 & each row corresponds to a cell
% Quadrant BB density
quad_BBdensityNorm_YData_area_avg_cell = cellfun(@(x) mean(x, 1, 'omitnan'), quad_BBdensityNorm_YData_area_cell, 'UniformOutput', false); % getting the average of this parameter for every quadrant across time points, for all cells. (For ex: time average of all values of this parameter (for ex: 'quadrant area') for quadrant 1), and similarlay for other qudrants. We use this average to compare across quadrants within one condition (for ex. control) and not between conditions. This averaging is different from the variance that we will obtain below where the variance is across quadrants for every time point - and this variance is used to compare between conditions
quad_BBdensityNorm_YData_area_avg = (cell2mat(quad_BBdensityNorm_YData_area_avg_cell'))'; % converting the cell array into a matrix of four columns where columns 1-4 correspond to the quadrants 1-4 & each row corresponds to a cell
% Quadrant Actin intensity
quad_MeanIntnorm_YData_area_avg_cell = cellfun(@(x) mean(x, 1, 'omitnan'), quad_MeanIntnorm_YData_area_cell, 'UniformOutput', false); % getting the average of this parameter for every quadrant across time points, for all cells. (For ex: time average of all values of this parameter (for ex: 'quadrant area') for quadrant 1), and similarlay for other qudrants. We use this average to compare across quadrants within one condition (for ex. control) and not between conditions. This averaging is different from the variance that we will obtain below where the variance is across quadrants for every time point - and this variance is used to compare between conditions
quad_MeanIntnorm_YData_area_avg = (cell2mat(quad_MeanIntnorm_YData_area_avg_cell'))'; % converting the cell array into a matrix of four columns where columns 1-4 correspond to the quadrants 1-4 & each row corresponds to a cell
quad_TotalIntnorm_YData_area_avg_cell = cellfun(@(x) mean(x, 1, 'omitnan'), quad_TotalIntnorm_YData_area_cell, 'UniformOutput', false); % getting the average of this parameter for every quadrant across time points, for all cells. (For ex: time average of all values of this parameter (for ex: 'quadrant area') for quadrant 1), and similarlay for other qudrants. We use this average to compare across quadrants within one condition (for ex. control) and not between conditions. This averaging is different from the variance that we will obtain below where the variance is across quadrants for every time point - and this variance is used to compare between conditions
quad_TotalIntnorm_YData_area_avg = (cell2mat(quad_TotalIntnorm_YData_area_avg_cell'))'; % converting the cell array into a matrix of four columns where columns 1-4 correspond to the quadrants 1-4 & each row corresponds to a cell
% Quadrant newBB count
quad_newBBCountnorm_YData_area_avg_cell = cellfun(@(x) mean(x, 1, 'omitnan'), quad_newBBCountnorm_YData_area_cell, 'UniformOutput', false); % getting the average of this parameter for every quadrant across time points, for all cells. (For ex: time average of all values of this parameter (for ex: 'quadrant area') for quadrant 1), and similarlay for other qudrants. We use this average to compare across quadrants within one condition (for ex. control) and not between conditions. This averaging is different from the variance that we will obtain below where the variance is across quadrants for every time point - and this variance is used to compare between conditions
quad_newBBCountnorm_YData_area_avg = (cell2mat(quad_newBBCountnorm_YData_area_avg_cell'))'; % converting the cell array into a matrix of four columns where columns 1-4 correspond to the quadrants 1-4 & each row corresponds to a cell

% Below we are converting the 'area_time_shifted', linearised, parameter values (of all times) from cell arrays to matrices, to be used for saving in the excel sheet and later for performing statistical analysis in graph pad prism; i decided not to plot the histograms for these parameters since i dont plan to use the histograms for the quad plots in the paper. I only plan to use the violin plots from the graph pad prism; thats why i am not using this data to make plots but only to save them in excel sheet for future use in graphpad prism
[quad_areaNorm_XData_area] = cell_to_array(quad_areaNorm_XData_area_cell_linearised, 1); clear quad_areaNorm_XData_area_cell_linearised; % The input '1' corresponds to the column number within the cell that needs to be used for making the matrix
[quad_areaNorm_YData_area] = cell_to_array(quad_areaNorm_YData_area_cell_linearised, 1); clear quad_areaNorm_YData_area_cell_linearised;
[quad_BBcountNorm_XData_area] = cell_to_array(quad_BBcountNorm_XData_area_cell_linearised, 1); clear quad_BBcountNorm_XData_area_cell_linearised;
[quad_BBcountNorm_YData_area] = cell_to_array(quad_BBcountNorm_YData_area_cell_linearised, 1); clear quad_BBcountNorm_YData_area_cell_linearised;
[quad_AreaRateNorm_XData_area] = cell_to_array(quad_AreaRateNorm_XData_area_cell_linearised, 1); clear quad_AreaRateNorm_XData_area_cell_linearised;
[quad_AreaRateNorm_YData_area] = cell_to_array(quad_AreaRateNorm_YData_area_cell_linearised, 1); clear quad_AreaRateNorm_YData_area_cell_linearised;
[quad_BBdensityNorm_XData_area] = cell_to_array(quad_BBdensityNorm_XData_area_cell_linearised, 1); clear quad_BBdensityNorm_XData_area_cell_linearised;
[quad_BBdensityNorm_YData_area] = cell_to_array(quad_BBdensityNorm_YData_area_cell_linearised, 1); clear quad_BBdensityNorm_YData_area_cell_linearised;
[quad_MeanIntnorm_XData_area] = cell_to_array(quad_MeanIntnorm_XData_area_cell_linearised, 1); clear quad_MeanIntnorm_XData_area_cell_linearised;
[quad_MeanIntnorm_YData_area] = cell_to_array(quad_MeanIntnorm_YData_area_cell_linearised, 1); clear quad_MeanIntnorm_YData_area_cell_linearised;
[quad_TotalIntnorm_XData_area] = cell_to_array(quad_TotalIntnorm_XData_area_cell_linearised, 1); clear quad_TotalIntnorm_XData_area_cell_linearised;
[quad_TotalIntnorm_YData_area] = cell_to_array(quad_TotalIntnorm_YData_area_cell_linearised, 1); clear quad_TotalIntnorm_YData_area_cell_linearised;
[quad_newBBCountnorm_XData_area] = cell_to_array(quad_newBBCountnorm_XData_area_cell_linearised, 1); clear quad_newBBCountnorm_XData_area_cell_linearised;
[quad_newBBCountnorm_YData_area] = cell_to_array(quad_newBBCountnorm_YData_area_cell_linearised, 1); clear quad_newBBCountnorm_YData_area_cell_linearised;

% Below we are getting the variances of the linearised matrices that we had obtained just above. The above matrices are used to compare the BB densities across quadrants within a condition (like control). However, below the variance is obtained across the 4 quadrants for every time point for each condition and then we use this data to compare between
% conditions like Control & MO. Here, each row corresponds to a time point where the value is the variance across 4 quadrants at every time point. This variance is different from the average that we had obtained above where the average is actually across time points for every quadrant and there it is used for comparing across quadrants within a condition.
quad_areaNorm_YData_area_var = var(quad_areaNorm_YData_area,0,2, 'omitnan'); % getting the variance across rows i.e. quadrants for every time point
quad_BBcountNorm_YData_area_var = var(quad_BBcountNorm_YData_area,0,2, 'omitnan');
quad_AreaRateNorm_YData_area_var = var(quad_AreaRateNorm_YData_area,0,2, 'omitnan');
quad_BBdensityNorm_YData_area_var = var(quad_BBdensityNorm_YData_area,0,2, 'omitnan');
quad_MeanIntnorm_YData_area_var = var(quad_MeanIntnorm_YData_area,0,2, 'omitnan');
quad_TotalIntnorm_YData_area_var = var(quad_TotalIntnorm_YData_area,0,2, 'omitnan');
quad_newBBCountnorm_YData_area_var = var(quad_newBBCountnorm_YData_area,0,2, 'omitnan');

% Combining the plots of different quadrants and halves
for plot_no = 1: max(length(quad_fig_names), length(half_fig_names))

    plot_name = fullfile(BB_apical_avg, strcat(quad_fig_names{plot_no}, '1'));
    q1 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q1_1 = findobj(q1, 'type', 'Patch'); q1_1.FaceColor = 'm'; q1_1.EdgeColor = 'm'; q1_2 = findobj(q1, 'type', 'line'); q1_2.Color = 'm';
    q11 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q11); q11_1 = gca; set(q11_1.Children, 'Color', 'm');
    delete(strcat(plot_name, '_collective_plot', '.fig')); delete(strcat(plot_name, '_avg_plot_shaded', '.fig')); delete(strcat(plot_name, '_avg_plot_errorbar', '.fig')); delete(strcat(plot_name, '_collective_plot', '.tif')); delete(strcat(plot_name, '_avg_plot_shaded', '.tif')); delete(strcat(plot_name, '_avg_plot_errorbar', '.tif'));

    plot_name = fullfile(BB_apical_avg, strcat(quad_fig_names{plot_no}, '2')); delete(strcat(plot_name, '_collective_plot', '.fig'));
    q2 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q2_1 = findobj(q2, 'type', 'Patch'); q2_1.FaceColor = 'k'; q2_1.EdgeColor = 'k'; q2_2 = findobj(q2, 'type', 'line'); q2_2.Color = 'k'; copyobj(get(gca(q2), 'Children'), gca(q1));
    q12 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q12); q12_1 = gca; set(q12_1.Children, 'Color', 'k'); copyobj(get(q12_1, 'Children'), gca(q11));
    delete(strcat(plot_name, '_avg_plot_shaded', '.fig')); delete(strcat(plot_name, '_avg_plot_errorbar', '.fig')); delete(strcat(plot_name, '_collective_plot', '.tif')); delete(strcat(plot_name, '_avg_plot_shaded', '.tif')); delete(strcat(plot_name, '_avg_plot_errorbar', '.tif'));

    plot_name = fullfile(BB_apical_avg, strcat(quad_fig_names{plot_no}, '3')); delete(strcat(plot_name, '_collective_plot', '.fig'));
    q3 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q3_1 = findobj(q3, 'type', 'Patch'); q3_1.FaceColor = 'b'; q3_1.EdgeColor = 'b'; q3_2 = findobj(q3, 'type', 'line'); q3_2.Color = 'b'; copyobj(get(gca(q3), 'Children'), gca(q1));
    q13 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q13); q13_1 = gca; set(q13_1.Children, 'Color', 'b'); copyobj(get(q13_1, 'Children'), gca(q11));
    delete(strcat(plot_name, '_avg_plot_shaded', '.fig')); delete(strcat(plot_name, '_avg_plot_errorbar', '.fig')); delete(strcat(plot_name, '_collective_plot', '.tif')); delete(strcat(plot_name, '_avg_plot_shaded', '.tif')); delete(strcat(plot_name, '_avg_plot_errorbar', '.tif'));

    plot_name = fullfile(BB_apical_avg, strcat(quad_fig_names{plot_no}, '4')); delete(strcat(plot_name, '_collective_plot', '.fig'));
    q4 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q4_1 = findobj(q4, 'type', 'Patch'); q4_1.FaceColor = 'r'; q4_1.EdgeColor = 'r'; q4_2 = findobj(q4, 'type', 'line'); q4_2.Color = 'r'; copyobj(get(gca(q4), 'Children'), gca(q1));
    q14 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q14); q14_1 = gca; set(q14_1.Children, 'Color', 'r'); copyobj(get(q14_1, 'Children'), gca(q11));
    delete(strcat(plot_name, '_avg_plot_shaded', '.fig')); delete(strcat(plot_name, '_avg_plot_errorbar', '.fig')); delete(strcat(plot_name, '_collective_plot', '.tif')); delete(strcat(plot_name, '_avg_plot_shaded', '.tif')); delete(strcat(plot_name, '_avg_plot_errorbar', '.tif'));

    close(q2, q12, q3, q13, q4, q14); legnd_list = ["" "Quadrant 1 (low BB density)" "" "Quadrant 2" "" "Quadrant 3" "" "Quadrant 4 (high BB density)"]; figure(q11); legend(legnd_list, 'Location', 'best', 'fontsize', 10); figure(q1); legend(legnd_list, 'Location', 'best', 'fontsize', 10);
    saveas(q1, fullfile(BB_apical_avg, strcat(quad_fig_names{plot_no}, '_avg_plot_shaded')), 'fig'); saveas(q1, fullfile(BB_apical_avg, strcat(quad_fig_names{plot_no}, '_avg_plot_shaded')), 'tif');
    saveas(q11, fullfile(BB_apical_avg, strcat(quad_fig_names{plot_no}, '_avg_plot_errorbar')), 'fig'); saveas(q11, fullfile(BB_apical_avg, strcat(quad_fig_names{plot_no}, '_avg_plot_errorbar')), 'tif');
    close(q1, q11);

    plot_name = fullfile(BB_apical_avg, strcat(half_fig_names{plot_no}, '1'));
    q1 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q1_1 = findobj(q1, 'type', 'Patch'); q1_1.FaceColor = 'm'; q1_1.EdgeColor = 'm'; q1_2 = findobj(q1, 'type', 'line'); q1_2.Color = 'm';
    q11 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q11); q11_1 = gca; set(q11_1.Children, 'Color', 'm');
    delete(strcat(plot_name, '_collective_plot', '.fig')); delete(strcat(plot_name, '_avg_plot_shaded', '.fig')); delete(strcat(plot_name, '_avg_plot_errorbar', '.fig')); delete(strcat(plot_name, '_collective_plot', '.tif')); delete(strcat(plot_name, '_avg_plot_shaded', '.tif')); delete(strcat(plot_name, '_avg_plot_errorbar', '.tif'));

    plot_name = fullfile(BB_apical_avg, strcat(half_fig_names{plot_no}, '2')); delete(strcat(plot_name, '_collective_plot', '.fig'));
    q2 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q2_1 = findobj(q2, 'type', 'Patch'); q2_1.FaceColor = 'k'; q2_1.EdgeColor = 'k'; q2_2 = findobj(q2, 'type', 'line'); q2_2.Color = 'k'; copyobj(get(gca(q2), 'Children'), gca(q1));
    q12 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q12); q12_1 = gca; set(q12_1.Children, 'Color', 'k'); copyobj(get(q12_1, 'Children'), gca(q11));
    delete(strcat(plot_name, '_avg_plot_shaded', '.fig')); delete(strcat(plot_name, '_avg_plot_errorbar', '.fig')); delete(strcat(plot_name, '_collective_plot', '.tif')); delete(strcat(plot_name, '_avg_plot_shaded', '.tif')); delete(strcat(plot_name, '_avg_plot_errorbar', '.tif'));

    plot_name = fullfile(BB_apical_avg, strcat(half_fig_names{plot_no}, '3')); delete(strcat(plot_name, '_collective_plot', '.fig'));
    q3 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q3_1 = findobj(q3, 'type', 'Patch'); q3_1.FaceColor = 'b'; q3_1.EdgeColor = 'b'; q3_2 = findobj(q3, 'type', 'line'); q3_2.Color = 'b'; copyobj(get(gca(q3), 'Children'), gca(q1));
    q13 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q13); q13_1 = gca; set(q13_1.Children, 'Color', 'b'); copyobj(get(q13_1, 'Children'), gca(q11));
    delete(strcat(plot_name, '_avg_plot_shaded', '.fig')); delete(strcat(plot_name, '_avg_plot_errorbar', '.fig')); delete(strcat(plot_name, '_collective_plot', '.tif')); delete(strcat(plot_name, '_avg_plot_shaded', '.tif')); delete(strcat(plot_name, '_avg_plot_errorbar', '.tif'));

    plot_name = fullfile(BB_apical_avg, strcat(half_fig_names{plot_no}, '4')); delete(strcat(plot_name, '_collective_plot', '.fig'));
    q4 = openfig(strcat(plot_name, '_avg_plot_shaded', '.fig')); q4_1 = findobj(q4, 'type', 'Patch'); q4_1.FaceColor = 'r'; q4_1.EdgeColor = 'r'; q4_2 = findobj(q4, 'type', 'line'); q4_2.Color = 'r'; copyobj(get(gca(q4), 'Children'), gca(q1));
    q14 = openfig(strcat(plot_name, '_avg_plot_errorbar', '.fig')); figure(q14); q14_1 = gca; set(q14_1.Children, 'Color', 'r'); copyobj(get(q14_1, 'Children'), gca(q11));
    delete(strcat(plot_name, '_avg_plot_shaded', '.fig')); delete(strcat(plot_name, '_avg_plot_errorbar', '.fig')); delete(strcat(plot_name, '_collective_plot', '.tif')); delete(strcat(plot_name, '_avg_plot_shaded', '.tif')); delete(strcat(plot_name, '_avg_plot_errorbar', '.tif'));

    close(q2, q12, q3, q13, q4, q14); legnd_list = ["" "Half 1 (low BB density)" "" "Half 2" "" "Half 3" "" "Half 4 (high BB density)"]; figure(q11); legend(legnd_list, 'Location', 'best', 'fontsize', 10); figure(q1); legend(legnd_list, 'Location', 'best', 'fontsize', 10);
    saveas(q1, fullfile(BB_apical_avg, strcat(half_fig_names{plot_no}, '_avg_plot_shaded')), 'fig'); saveas(q1, fullfile(BB_apical_avg, strcat(half_fig_names{plot_no}, '_avg_plot_shaded')), 'tif');
    saveas(q11, fullfile(BB_apical_avg, strcat(half_fig_names{plot_no}, '_avg_plot_errorbar')), 'fig'); saveas(q11, fullfile(BB_apical_avg, strcat(half_fig_names{plot_no}, '_avg_plot_errorbar')), 'tif');
    close(q1, q11);
end

% Box plot comparison between quadrants, Top-Bottom halves & Left-Right halves
% Quad apical area (at max/final apical area)
prm = Quad_Area_max_apical_area_norm; prm_mean = mean(prm, "omitnan"); Ylabel = 'Quadrant Area (normalised)'; Plot_title = {'Quadrant area (normalised) comparison at', 'maximum area / final time point'}; save_title = 'quad_area_comparison_at_max_area';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors
% Quad area rate (at max/final apical area)
prm = Quad_arearate_max_apical_area_norm; prm_mean = mean(prm, "omitnan"); Ylabel = 'Quadrant rate of expansion (normalised)'; Plot_title = {'Quadrant rate of expansion (normalised)', 'comparison at maximum area / final time point'}; save_title = 'quad_arearate_comparison_at_max_area';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors
% Quad BB count (at max/final apical area)
prm = Quad_BBcount_max_apical_area_norm; prm_mean = mean(prm, "omitnan"); Ylabel = 'BB count (normalised)'; Plot_title = {'Quadrant BB count (normalised) comparison at', 'maximum area / final time point'}; save_title = 'quad_bbcount_comparison_at_max_area';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors
% Quad BB density (at max/final apical area)
prm = Quad_BBdensity_at_max_apical_area_norm; prm_mean = mean(prm, "omitnan"); Ylabel = 'BB density (normalised)'; Plot_title = {'Quadrant BB density (normalised) comparison at', 'maximum area / final time point'}; save_title = 'quad_bbdensity_comparison_at_max_area';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors
% Quad Mean actin intensity (at max/final apical area)
prm = Quad_actinMeanIntnorm_at_max_apical_area; prm_mean = mean(prm, "omitnan"); Ylabel = 'Mean Actin Int. (normalised)'; Plot_title = {'Quadrant Mean actin Int. (normalised) comparison at', 'maximum area / final time point'}; save_title = 'quad_MeanIntnorm_comparison_at_max_area';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors
% Quad Total actin intensity (at max/final apical area)
prm = Quad_actinTotalIntnorm_at_max_apical_area; prm_mean = mean(prm, "omitnan"); Ylabel = 'Total Actin Int. (normalised)'; Plot_title = {'Quadrant Total actin Int. (normalised) comparison at', 'maximum area / final time point'}; save_title = 'quad_TotalIntnorm_comparison_at_max_area';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors
% Quad New BB count (cumulative count over all frames/times)
prm = Quad_NewBB_cumulative_count; prm_mean = mean(prm, "omitnan"); Ylabel = 'New BB cumulative count (normalised)'; Plot_title = {'Cumulative count of New BBs (normalised) in the quadrants', 'over all time points'}; save_title = 'quad_NewBB_total_count';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors

% Half area (at max/final apical area)
prm = Half_areas_at_max_apical_area_norm; prm_mean = mean(prm, "omitnan"); Ylabel = 'Half section area (normalised)'; Plot_title = {'Half section area (normalised) comparison', 'at maximum area / final time point'}; save_title = 'half_area_comparison_at_max_area';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_half_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors
% Half area rate (at max/final apical area)
prm = Half_BB_count_at_max_apical_area_norm; prm_mean = mean(prm, "omitnan"); Ylabel = 'Rate of expansion (normalised)'; Plot_title = {'Half section area expansion rate (normalised)', 'comparison at maximum area / final time point'}; save_title = 'half_arearate_comparison_at_max_area';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_half_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors
% Half BB count (at max/final apical area)
prm = Half_area_rates_at_max_apical_area_norm; prm_mean = mean(prm, "omitnan"); Ylabel = 'BB count (normalised)'; Plot_title = {'Half section BB count (normalised) comparison at', 'maximum area / final time point'}; save_title = 'half_bbcount_comparison_at_max_area';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_half_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors
% Half BB density (at max/final apical area)
prm = Half_BB_density_at_max_apical_area_norm; prm_mean = mean(prm, "omitnan"); Ylabel = 'BB density (normalised)'; Plot_title = {'Half section BB density (normalised) comparison at', 'maximum area / final time point'}; save_title = 'half_bbdensity_comparison_at_max_area';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_half_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors
% Half Mean Actin intensity (at max/final apical area)
prm = Half_actinMeanIntnorm_at_max_apical_area; prm_mean = mean(prm, "omitnan"); Ylabel = 'Mean Actin Int. (normalised)'; Plot_title = {'Half section Mean actin Int. (normalised) comparison at', 'maximum area / final time point'}; save_title = 'half_MeanIntnorm_comparison_at_max_area';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_half_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors
% Half Total Actin intensity (at max/final apical area)
prm = Half_actinTotalIntnorm_at_max_apical_area; prm_mean = mean(prm, "omitnan"); Ylabel = 'Total Actin Int. (normalised)'; Plot_title = {'Half section Total actin Int. (normalised) comparison at', 'maximum area / final time point'}; save_title = 'half_TotalIntnorm_comparison_at_max_area';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_half_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors
% Half New BB count (cumulative count over all frames/times)
prm = Half_NewBB_cumulative_count; prm_mean = mean(prm, "omitnan"); Ylabel = 'New BB cumulative count (normalised)'; Plot_title = {'Cumulative count of New BBs (normalised) in the Half', 'section, over all time points'}; save_title = 'half_NewBB_total_count';
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'quad_half_analy'); clear prm prm_mean; % this function plots the box plots for the input vectors

clear quad_fig_names half_fig_names
%%
% Below we get the clumping factor (i.e. heterogeneity) for all parameters
% Clumping factor (Area) plots vs Area & Time
area_data = area_apicaldomain; time_data = timelist; new_parameter = ClumpingFactor_Area;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Clumping Factor (Area)'; plot_Title_1 = 'Clumping factor (Area) vs Area'; save_title_1 = 'ClumpingFactor_Area_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Clumping Factor (Area)'; plot_Title_2 = 'Clumping factor (Area) vs Time'; save_title_2 = 'ClumpingFactor_Area_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_clumpingFactor_area_vs_area = binXY_parameter_vs_area; clumpingfactor_area_XData_area = XData_area; clumpingfactor_area_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Clumping factor (Area Rate) plots vs Area & Time
area_data = Area_area_rate; time_data = timelist_area_rate; new_parameter = ClumpingFactor_AreaRate;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Clumping Factor (Rate of expansion)'; plot_Title_1 = 'Clumping factor (Rate of expansion) vs Area'; save_title_1 = 'ClumpingFactor_AreaRate_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Clumping Factor (Rate of expansion)'; plot_Title_2 = 'Clumping factor (Rate of expansion) vs Time'; save_title_2 = 'ClumpingFactor_AreaRate_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_clumpingFactor_arearate_vs_area = binXY_parameter_vs_area; clumpingfactor_arearate_XData_area = XData_area; clumpingfactor_arearate_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Clumping factor (BB count) plots vs Area & Time
area_data = area_apicaldomain; time_data = timelist; new_parameter = ClumpingFactor_BBCount;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Clumping Factor (BB count)'; plot_Title_1 = 'Clumping factor (BB count) vs Area'; save_title_1 = 'ClumpingFactor_BBcount_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Clumping Factor (BB count)'; plot_Title_2 = 'Clumping factor (BB count) vs Time'; save_title_2 = 'ClumpingFactor_BBcount_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_clumpingFactor_bbcount_vs_area = binXY_parameter_vs_area; clumpingfactor_bbcount_XData_area = XData_area; clumpingfactor_bbcount_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Clumping factor (BB density) plots vs Area & Time
area_data = area_apicaldomain; time_data = timelist; new_parameter = ClumpingFactor_BBDensity;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Clumping Factor (BB density)'; plot_Title_1 = 'Clumping factor (BB density) vs Area'; save_title_1 = 'ClumpingFactor_BBdensity_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Clumping Factor (BB density)'; plot_Title_2 = 'Clumping factor (BB density) vs Time'; save_title_2 = 'ClumpingFactor_BBdensity_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_clumpingFactor_bbdensity_vs_area = binXY_parameter_vs_area; clumpingfactor_bbdensity_XData_area = XData_area; clumpingfactor_bbdensity_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Clumping factor (Actin Mean Int.) plots vs Area & Time
area_data = area_apicaldomain; time_data = timelist; new_parameter = ClumpingFactor_MeanInt;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Clumping Factor (Mean Int)'; plot_Title_1 = 'Clumping factor (Mean Int) vs Area'; save_title_1 = 'ClumpingFactor_MeanInt_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Clumping Factor (Mean Int)'; plot_Title_2 = 'Clumping factor (Mean Int) vs Time'; save_title_2 = 'ClumpingFactor_MeanInt_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_clumpingFactor_meanint_vs_area = binXY_parameter_vs_area; clumpingfactor_meanint_XData_area = XData_area; clumpingfactor_meanint_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Clumping factor (Actin Total Int.) plots vs Area & Time
area_data = area_apicaldomain; time_data = timelist; new_parameter = ClumpingFactor_TotalInt;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Clumping Factor (Total Int)'; plot_Title_1 = 'Clumping factor (Total Int) vs Area'; save_title_1 = 'ClumpingFactor_TotalInt_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Clumping Factor (Total Int)'; plot_Title_2 = 'Clumping factor (Total Int) vs Time'; save_title_2 = 'ClumpingFactor_TotalInt_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_clumpingFactor_totalint_vs_area = binXY_parameter_vs_area; clumpingfactor_totalint_XData_area = XData_area; clumpingfactor_totalint_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

% Clumping factor (New BB count) plots vs Area & Time
area_data = area_NEW_BB_entry_count; time_data = timelist_NEW_BB_entry_count; new_parameter = ClumpingFactor_NewBBCount;
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; yLabel_1 = 'Clumping Factor (New BB count)'; plot_Title_1 = 'Clumping factor (New BB count) vs Area'; save_title_1 = 'ClumpingFactor_NewBBcount_vs_Area';
bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]'; yLabel_2 = 'Clumping Factor (New BB count)'; plot_Title_2 = 'Clumping factor (New BB count) vs Time'; save_title_2 = 'ClumpingFactor_NewBBcount_vs_Time';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
binXY_clumpingFactor_newbbcount_vs_area = binXY_parameter_vs_area; clumpingfactor_newbbcount_XData_area = XData_area; clumpingfactor_newbbcount_YData_area = YData_area;
clear area_data time_data new_parameter bininterval_for_Binparameter_1 xLabel_1 yLabel_1 plot_Title_1 save_title_1 bininterval_for_Binparameter_2 xLabel_2 yLabel_2 plot_Title_2 save_title_2 binXY_parameter_vs_area XData_area YData_area binXY_parameter_vs_time

%% Contour & End-to-end distances for different area ranges
% This analysis was performed only for control data and not for alphaActininMO. Therefore the plots are generated only for control data
if experiment_type == 1

    prm = [contour_dist_1to150um2_linearised, contour_dist_150um2_finalarea_linearised]; prm_mean = mean(prm, "omitnan"); Ylabel = 'Contour distance (normalised)'; Plot_title = {'Comparing the contour distances between', 'early (0-150µm2) & late (150µm2-max area)'}; save_title = 'contour_dist_ActualArea_avg';
    box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'contour_end2end_dist_early_late'); clear prm prm_mean; % this function plots the box plots for the input vectors

    prm = [contour_dist_25pct_linearised, contour_dist_50pct_linearised, contour_dist_75pct_linearised, contour_dist_100pct_linearised]; prm_mean = mean(prm, "omitnan"); Ylabel = 'Contour distance (normalised)'; Plot_title = {'Comparing the contour distances between', 'different area percentages'}; save_title = 'contour_dist_PercentArea_avg';
    box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'contour_end2end_dist_percentage'); clear prm prm_mean; % this function plots the box plots for the input vectors

    prm = [endtoend_dist_1to150um2_linearised, endtoend_dist_150um2_finalarea_linearised]; prm_mean = mean(prm, "omitnan"); Ylabel = 'End-to-End distance (normalised)'; Plot_title = {'Comparing the End-to-end distances between', 'early (0-150µm2) & late (150µm2-max area)'}; save_title = 'endtoend_dist_ActualArea_avg';
    box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'contour_end2end_dist_early_late'); clear prm prm_mean; % this function plots the box plots for the input vectors

    prm = [endtoend_dist_25pct_linearised, endtoend_dist_50pct_linearised, endtoend_dist_75pct_linearised, endtoend_dist_100pct_linearised]; prm_mean = mean(prm, "omitnan"); Ylabel = 'End-to-End distance (normalised)'; Plot_title = {'Comparing the End-to-end distances between', 'different area percentages'}; save_title = 'endtoend_dist_PercentArea_avg';
    box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'contour_end2end_dist_percentage'); clear prm prm_mean; % this function plots the box plots for the input vectors

    prm = [Tortuosity_Earlyexpansion_linearised, Tortuosity_Lateexpansion_linearised]; prm_mean = mean(prm, "omitnan"); Ylabel = 'Tortuosity'; Plot_title = {'Tortuosity comparison between early', '& late expansion'}; save_title = 'tortuosity_ActualArea_avg';
    box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'contour_end2end_dist_early_late'); clear prm prm_mean; % this function plots the box plots for the input vectors

    prm = [Tortuosity_25PercentArea_linearised, Tortuosity_50PercentArea_linearised, Tortuosity_75PercentArea_linearised, Tortuosity_100PercentArea_linearised]; prm_mean = mean(prm, "omitnan"); Ylabel = 'Tortuosity'; Plot_title = {'Tortuosity comparison between', 'different percentages of expansion'}; save_title = 'tortuosity_PercentArea_avg';
    box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, 'contour_end2end_dist_percentage'); clear prm prm_mean; % this function plots the box plots for the input vectors
end

%% Plotting the histograms of bins (i.e. upto bin_breakpoint µm2 & beyond bin_breakpoint µm2)

% setting the row number in the "binXY_parameter_vs_area" matrix based on the experiment type i.e. control or MO. In other words, when we get the binned parameter values based on the area, for example lets say the binning is done with a bin interval of 10µm2 area, then in the matrix (for example, 'binXY_isotropicity_vs_area')
% that contains the binned values, each row corresponds to a bin interval of 10 µm2. For example, 1st row contains the bins for 50-60 µm2 (because we get only those values starting at 50µm2), 2nd row contains the bins for 60-70 µm2, 3rd row contains the bins for 70-80 µm2 and so on. Along this line, if we want to get all the bins
% that are 'upto 'bin_breakpoint' µm2' and all the bins that are 'beyond 'bin_breakpoint' µm2', then we need to find at which row the bins are 150µm2. We check this manually and find that the bins are 'bin_breakpoint' µm2 at row 10 and the bins are 80 µm2 at row 3. 150µm2 bin size is used for control data and 80µm2 bin size is used for MO data - because thats
% when the the plots change their trends in these conditions. In this matrix containing the bin values, 1st column corresponds to the area bins and 2nd column corresponds to the corresponding parameter (that is being plotted) bins.

% defining the breakpoint area value based on which the bins are split - this value is decided based on the piecewise linear fit plot & its results
% the following values are obtained from the 'Piecewise_fit_summary.txt' file under the breakpoint_plots folder - these values are different depending on whether it is control or MO
if experiment_type == 1
    % bin_breakpoint = [isotropicity; area_expansion_rate; log_of_variance_in_tessalation; Mean_Interdistance; Nearest_Neighbor_distance; distances_between_new_&_already_exiting_BBs; distances_between_new_BBs_in_current_&_previous_frames; clumping_factor_BBdensity; Local_Clustering; Global_Clustering];
    bin_breakpoint = [125; 145; 144; 136; 157; 185; 154; 123; 185; 154; 123; 57; 142; 132]; % manually entered after running the 'piecewise_linearFit_breakpoint.m' script for control condition
    % binRowNo = 10; % for control data % Previous bin split logic
elseif experiment_type == 2
    % bin_breakpoint = [isotropicity; area_expansion_rate; log_of_variance_in_tessalation; Mean_Interdistance; Nearest_Neighbor_distance; distances_between_new_&_already_exiting_BBs; distances_between_new_BBs_in_current_&_previous_frames; clumping_factor_BBdensity; Local_Clustering; Global_Clustering];
    bin_breakpoint = [86; 68; 63; 92; 85; 99; 86; 104; 99; 86; 104; 83; 76; 79]; % manually entered after running the 'piecewise_linearFit_breakpoint.m' script for MO condition
    % binRowNo = 3; % for MO data % Previous bin split logic
end

% plotting the histograms for different bins of isotropicity
bin_breakpoint_idx_below = isotropicity_XData_area <= bin_breakpoint(1); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = isotropicity_XData_area > bin_breakpoint(1); % getting all the indices above the bin_breakpoint value
binXY_isotropicity_mat_bin1 = isotropicity_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_isotropicity_vs_area(1:binRowNo, 2)); % each row in binXY_isotropicity_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_isotropicity_mat_bin2 = isotropicity_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_isotropicity_vs_area(binRowNo:end, 2)); % each row in binXY_isotropicity_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_isotropicity_mat_bin1; parameter_2 = binXY_isotropicity_mat_bin2; bininterval = 0.1; XLabel = 'Isotropcity'; Plot_title = 'Isotropicity (for two bins)'; save_title = 'binComparison_isotropcity'; legend_type = 'area_bins';
[binXY_Isotropicity_Bins] = hist_plots_for_bins(bin_breakpoint(1), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(1), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

% plotting the histograms for different bins of area expansion rate
bin_breakpoint_idx_below = expansion_rate_XData_area <= bin_breakpoint(2); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = expansion_rate_XData_area > bin_breakpoint(2); % getting all the indices above the bin_breakpoint value
binXY_expansionrate_mat_bin1 = expansion_rate_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_expansionrate_vs_area(1:binRowNo, 2)); % each row in binXY_expansionrate_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_expansionrate_mat_bin2 = expansion_rate_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_expansionrate_vs_area(binRowNo:end, 2)); % each row in binXY_expansionrate_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_expansionrate_mat_bin1; parameter_2 = binXY_expansionrate_mat_bin2; bininterval = 0.5; XLabel = 'Rate of area expansion [\mum^2 min^{-1}]'; Plot_title = {'Rate of apical domain area expansion', '(for two bins)'}; save_title = 'binComparison_expansionRate'; legend_type = 'area_bins';
[binXY_expansionrate_Bins] = hist_plots_for_bins(bin_breakpoint(2), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(2), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

% plotting the histograms for different bins of log of variance in tessalation
bin_breakpoint_idx_below = lnVarianceTessalation_XData_area <= bin_breakpoint(3); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = lnVarianceTessalation_XData_area > bin_breakpoint(3); % getting all the indices above the bin_breakpoint value
binXY_lnVarianceTessalation_mat_bin1 = lnVarianceTessalation_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_lnVarianceTessalation_vs_area(1:binRowNo, 2)); % each row in binXY_lnVarianceTessalation_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_lnVarianceTessalation_mat_bin2 = lnVarianceTessalation_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_lnVarianceTessalation_vs_area(binRowNo:end, 2)); % each row in binXY_lnVarianceTessalation_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_lnVarianceTessalation_mat_bin1; parameter_2 = binXY_lnVarianceTessalation_mat_bin2; bininterval = 0.05; XLabel = 'ln(variance) (normalised)'; Plot_title = {'Natural log of Variance', '(for two bins)'}; save_title = 'binComparison_lnVarianceTessalation'; legend_type = 'area_bins';
[binXY_lnVarianceTessalation_Bins] = hist_plots_for_bins(bin_breakpoint(3), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(3), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

% plotting the histograms for different bins of Variance in tessalation
bin_breakpoint_idx_below = VarianceTessalation_XData_area <= bin_breakpoint(4); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = VarianceTessalation_XData_area > bin_breakpoint(4); % getting all the indices above the bin_breakpoint value
binXY_VarianceTessalation_mat_bin1 = VarianceTessalation_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_lnVarianceTessalation_vs_area(1:binRowNo, 2)); % each row in binXY_lnVarianceTessalation_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_VarianceTessalation_mat_bin2 = VarianceTessalation_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_lnVarianceTessalation_vs_area(binRowNo:end, 2)); % each row in binXY_lnVarianceTessalation_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_VarianceTessalation_mat_bin1; parameter_2 = binXY_VarianceTessalation_mat_bin2; bininterval = 0.05; XLabel = 'Variance (Normalised by MeanArea squared)'; Plot_title = {'Variance', '(for two bins)'}; save_title = 'binComparison_VarianceTessalation'; legend_type = 'area_bins';
[binXY_VarianceTessalation_Bins] = hist_plots_for_bins(bin_breakpoint(4), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(4), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

% plotting the histograms for different bins of Mean Interdistance
bin_breakpoint_idx_below = MeanInterdist_XData_area <= bin_breakpoint(5); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = MeanInterdist_XData_area > bin_breakpoint(5); % getting all the indices above the bin_breakpoint value
binXY_MeanInterdist_mat_bin1 = MeanInterdist_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_MeanInterdist_vs_area(1:binRowNo, 2)); % each row in binXY_MeanInterdist_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_MeanInterdist_mat_bin2 = MeanInterdist_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_MeanInterdist_vs_area(binRowNo:end, 2)); % each row in binXY_MeanInterdist_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_MeanInterdist_mat_bin1; parameter_2 = binXY_MeanInterdist_mat_bin2; bininterval = 0.05; XLabel = 'Mean interdistance [\mum]'; Plot_title = {'BB mean interdistance (density based)', '(for two bins)'}; save_title = 'binComparison_MeanInterdist'; legend_type = 'area_bins';
[binXY_MeanInterdist_Bins] = hist_plots_for_bins(bin_breakpoint(5), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(5), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

% plotting the histograms for different bins of Nearest Neighbor distance
bin_breakpoint_idx_below = NearNeighbdist_XData_area <= bin_breakpoint(6); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = NearNeighbdist_XData_area > bin_breakpoint(6); % getting all the indices above the bin_breakpoint value
binXY_NearestNeighbordist_mat_bin1 = NearNeighbdist_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_NearNeighbdist_vs_area(1:binRowNo, 2)); % each row in binXY_NearNeighbdist_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_NearestNeighbordist_mat_bin2 = NearNeighbdist_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_NearNeighbdist_vs_area(binRowNo:end, 2)); % each row in binXY_NearNeighbdist_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_NearestNeighbordist_mat_bin1; parameter_2 = binXY_NearestNeighbordist_mat_bin2; bininterval = 0.1; XLabel = 'Nearest Neighbor distance [\mum]'; Plot_title = {'Nearest neighbor distance', '(for two bins)'}; save_title = 'binComparison_NearNeighbordist'; legend_type = 'area_bins';
[binXY_NearNeighdist_Bins] = hist_plots_for_bins(bin_breakpoint(6), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(6), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

% plotting the histograms for different bins of the distances between new & already exiting BBs
bin_breakpoint_idx_below = NewExistingBBappearancedist_XData_area <= bin_breakpoint(7); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = NewExistingBBappearancedist_XData_area > bin_breakpoint(7); % getting all the indices above the bin_breakpoint value
binXY_NewExistdist_mat_bin1 = NewExistingBBappearancedist_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_NewExistdist_vs_area(1:binRowNo, 2)); % each row in binXY_NewExistdist_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_NewExistdist_mat_bin2 = NewExistingBBappearancedist_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_NewExistdist_vs_area(binRowNo:end, 2)); % each row in binXY_NewExistdist_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_NewExistdist_mat_bin1; parameter_2 = binXY_NewExistdist_mat_bin2; bininterval = 0.1; XLabel = 'Minimum BB appearance distance [\mum]'; Plot_title = {'Min. dist. between new & existing BB', '(for two bins)'}; save_title = 'binComparison_NewExistBBdist'; legend_type = 'area_bins';
[binXY_NewExistdist_Bins] = hist_plots_for_bins(bin_breakpoint(7), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(7), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

% plotting the histograms for different bins of the distances between new BBs in current & previous frames
bin_breakpoint_idx_below = NewNewBBappearancedist_XData_area <= bin_breakpoint(8); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = NewNewBBappearancedist_XData_area > bin_breakpoint(8); % getting all the indices above the bin_breakpoint value
binXY_NewNewBBdist_mat_bin1 = NewNewBBappearancedist_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_NewNewBBdist_vs_area(1:binRowNo, 2)); % each row in binXY_NewNewBBdist_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_NewNewBBdist_mat_bin2 = NewNewBBappearancedist_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_NewNewBBdist_vs_area(binRowNo:end, 2)); % each row in binXY_NewNewBBdist_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_NewNewBBdist_mat_bin1; parameter_2 = binXY_NewNewBBdist_mat_bin2; bininterval = 1; XLabel = 'Minimum BB appearance distance [\mum]'; Plot_title = {'BB appearance distance', '(for two bins)'}; save_title = 'binComparison_BBappearancedist'; legend_type = 'area_bins';
[binXY_NewNewBBdist_Bins] = hist_plots_for_bins(bin_breakpoint(8), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(8), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

%---------------------------------------------------%

% plotting the histograms for different bins of Nearest Neighbor distance - Averaged (per frame)
bin_breakpoint_idx_below = AvgNearNeighbourBBMinDist_XData_area <= bin_breakpoint(9); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = AvgNearNeighbourBBMinDist_XData_area > bin_breakpoint(9); % getting all the indices above the bin_breakpoint value
binXY_AvgNearNeighbourBBMinDist_mat_bin1 = AvgNearNeighbourBBMinDist_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_NearNeighbdist_vs_area(1:binRowNo, 2)); % each row in binXY_NearNeighbdist_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_AvgNearNeighbourBBMinDist_mat_bin2 = AvgNearNeighbourBBMinDist_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_NearNeighbdist_vs_area(binRowNo:end, 2)); % each row in binXY_NearNeighbdist_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_AvgNearNeighbourBBMinDist_mat_bin1; parameter_2 = binXY_AvgNearNeighbourBBMinDist_mat_bin2; bininterval = 0.1; XLabel = 'Nearest Neighbor distance [\mum]'; Plot_title = {'Nearest neighbor distance, averaged per frame,', '(for two bins)'}; save_title = 'binComparison_NearNeighborAvgdist'; legend_type = 'area_bins';
[binXY_AvgNearNeighbourBBMinDist_Bins] = hist_plots_for_bins(bin_breakpoint(9), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(9), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

% plotting the histograms for different bins of the distances - Averaged (per frame) - between new & already exiting BBs
bin_breakpoint_idx_below = AvgNewExistBBMinDist_XData_area <= bin_breakpoint(10); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = AvgNewExistBBMinDist_XData_area > bin_breakpoint(10); % getting all the indices above the bin_breakpoint value
binXY_AvgNewExistBBMinDist_mat_bin1 = AvgNewExistBBMinDist_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_NewExistdist_vs_area(1:binRowNo, 2)); % each row in binXY_NewExistdist_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_AvgNewExistBBMinDist_mat_bin2 = AvgNewExistBBMinDist_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_NewExistdist_vs_area(binRowNo:end, 2)); % each row in binXY_NewExistdist_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_AvgNewExistBBMinDist_mat_bin1; parameter_2 = binXY_AvgNewExistBBMinDist_mat_bin2; bininterval = 0.1; XLabel = 'Minimum BB appearance distance [\mum]'; Plot_title = {'Min. dist., averaged per frame, between new & existing BB', '(for two bins)'}; save_title = 'binComparison_NewExistBBAvgdist'; legend_type = 'area_bins';
[binXY_AvgNewExistBBMinDist_Bins] = hist_plots_for_bins(bin_breakpoint(10), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(10), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

% plotting the histograms for different bins of the distances - Averaged (per frame) - between new BBs in current & previous frames
bin_breakpoint_idx_below = AvgNewNewBBMinDist_XData_area <= bin_breakpoint(11); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = AvgNewNewBBMinDist_XData_area > bin_breakpoint(11); % getting all the indices above the bin_breakpoint value
binXY_AvgNewNewBBMinDist_mat_bin1 = AvgNewNewBBMinDist_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_NewNewBBdist_vs_area(1:binRowNo, 2)); % each row in binXY_NewNewBBdist_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_AvgNewNewBBMinDist_mat_bin2 = AvgNewNewBBMinDist_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_NewNewBBdist_vs_area(binRowNo:end, 2)); % each row in binXY_NewNewBBdist_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_AvgNewNewBBMinDist_mat_bin1; parameter_2 = binXY_AvgNewNewBBMinDist_mat_bin2; bininterval = 1; XLabel = 'Minimum BB appearance distance [\mum]'; Plot_title = {'BB appearance distance, averaged per frame,', '(for two bins)'}; save_title = 'binComparison_BBappearanceAvgdist'; legend_type = 'area_bins';
[binXY_AvgNewNewBBMinDist_Bins] = hist_plots_for_bins(bin_breakpoint(11), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(11), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

%---------------------------------------------------%

% plotting the histograms for different bins of the clumping factor (BB density)
bin_breakpoint_idx_below = clumpingfactor_bbdensity_XData_area <= bin_breakpoint(12); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = clumpingfactor_bbdensity_XData_area > bin_breakpoint(12); % getting all the indices above the bin_breakpoint value
binXY_clumpingfactor_bbdensity_mat_bin1 = clumpingfactor_bbdensity_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_clumpingFactor_bbdensity_vs_area(1:binRowNo, 2)); % each row in binXY_clumpingFactor_bbdensity_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_clumpingfactor_bbdensity_mat_bin2 = clumpingfactor_bbdensity_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_clumpingFactor_bbdensity_vs_area(binRowNo:end, 2)); % each row in binXY_clumpingFactor_bbdensity_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_clumpingfactor_bbdensity_mat_bin1; parameter_2 = binXY_clumpingfactor_bbdensity_mat_bin2; bininterval = 0.01; XLabel = 'Clumping Factor (BB density)'; Plot_title = {'Clumping factor (BB density)', '(for two bins)'}; save_title = 'binComparison_clumpingfac_BBdensity'; legend_type = 'area_bins';
[binXY_clumpingfactor_bbdensity_Bins] = hist_plots_for_bins(bin_breakpoint(12), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(12), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

% plotting the histograms for different bins of the Local Clustering index
bin_breakpoint_idx_below = local_clustering_XData_area <= bin_breakpoint(13); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = local_clustering_XData_area > bin_breakpoint(13); % getting all the indices above the bin_breakpoint value
binXY_LocalClustering_mat_bin1 = local_clustering_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_LocalClustering_vs_area(1:binRowNo, 2)); % each row in binXY_LocalClustering_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_LocalClustering_mat_bin2 = local_clustering_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_LocalClustering_vs_area(binRowNo:end, 2)); % each row in binXY_LocalClustering_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_LocalClustering_mat_bin1; parameter_2 = binXY_LocalClustering_mat_bin2; bininterval = 0.01; XLabel = 'Local clustering index'; Plot_title = {'Local Clustering Index', '(for two bins)'}; save_title = 'binComparison_localclustering'; legend_type = 'area_bins';
[binXY_LocalClustering_Bins] = hist_plots_for_bins(bin_breakpoint(13), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(13), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

% plotting the histograms for different bins of the Global Clustering index
bin_breakpoint_idx_below = global_clustering_XData_area <= bin_breakpoint(14); % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = global_clustering_XData_area > bin_breakpoint(14); % getting all the indices above the bin_breakpoint value
binXY_GlobalClustering_mat_bin1 = global_clustering_YData_area(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_GlobalClustering_vs_area(1:binRowNo, 2)); % each row in binXY_GlobalClustering_vs_area corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 10 µm2; So 1:binRowNo corresponds to those bins between 50 - 150 µm2 or 50-80µm2 depending on the experiment_type.
binXY_GlobalClustering_mat_bin2 = global_clustering_YData_area(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_GlobalClustering_vs_area(binRowNo:end, 2)); % each row in binXY_GlobalClustering_vs_area corresponds to one bin; The bin width (or bin interval) is 10 µm2; So binRowNo:end corresponds to all the bins between 151 - 350 µm2 or 81-350µm2 depending on the experiment type.
parameter_1 = binXY_GlobalClustering_mat_bin1; parameter_2 = binXY_GlobalClustering_mat_bin2; bininterval = 0.01; XLabel = 'Global clustering index'; Plot_title = {'Global Clustering Index', '(for two bins)'}; save_title = 'binComparison_globalclustering'; legend_type = 'area_bins';
[binXY_GlobalClustering_Bins] = hist_plots_for_bins(bin_breakpoint(14), parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
cdf_distr_plots(bin_breakpoint(14), parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

%% Comparison between control & alphaActinin MO
%------------------------------ Box, PDF & CDF plots --------------------------------%

% Below we plot the average of parameters (at max area time point) between control and morpholino (parameters like: apical area, rate of expansion, )
if experiment_type == 1
    % obtaining the Ctrl data at max. apical area
    [~, time_threshold_idx] = min(abs(timelist - 150), [], 1); [~, timeclustering_threshold_idx] = min(abs(Time_Clustering - 150), [], 1); % here we get the row index of the 'timelist' matrix that corresponds to '150' minutes (i.e. 2.5 h). This is because, we are interested only in the time range of 2.5 h (to have similar experimental time lines for control & MO). So th idea is to use this index and search within range in the 'area_apicaldomain' matrix for max(area) and use that area as the maximum area
    [apical_area_at_max_apical_area_ctrl, max_apical_area_idx_ctrl] = arrayfun(@(i) max(area_apicaldomain(1:time_threshold_idx(i), i)), 1:size(area_apicaldomain, 2)); % extracting the max area within the range of 'time_threshold_idx' i.e. within 2.5 h range
    [BB_count_max_ctrl, ~] = arrayfun(@(i) max(no_of_bb(1:time_threshold_idx(i), i)), 1:size(no_of_bb, 2)); % extracting the max BB_count within the range of 'time_threshold_idx' i.e. within 2.5 h range
    BB_density_norm_at_max_apical_area_ctrl = BB_density_norm(max_apical_area_idx_ctrl); BB_mean_interdistance_at_max_apical_area_ctrl = Mintd(max_apical_area_idx_ctrl);
    Variance_voronoi_at_max_apical_area_ctrl = Variance_voronoi_fin_norm_all(max_apical_area_idx_ctrl); ln_Variance_voronoi_at_max_apical_area_ctrl = Variance_voronoi_fin_log_all_norm(max_apical_area_idx_ctrl); meanint_whole_area_at_max_apical_area_ctrl = meanintensity_apicaldomain(max_apical_area_idx_ctrl); totalint_whole_area_at_max_apical_area_ctrl = totalintensity_apicaldomain(max_apical_area_idx_ctrl); ClumpingFactor_Area_max_apical_area_ctrl = ClumpingFactor_Area_max_apical_area; ClumpingFactor_AreaRate_max_apical_area_ctrl = ClumpingFactor_AreaRate_max_apical_area; ClumpingFactor_BBCount_max_apical_area_ctrl = ClumpingFactor_BBCount_max_apical_area;
    ClumpingFactor_BBDensity_max_apical_area_ctrl = ClumpingFactor_BBDensity_max_apical_area; ClumpingFactor_MeanInt_max_apical_area_ctrl = ClumpingFactor_MeanInt_max_apical_area; ClumpingFactor_TotalInt_max_apical_area_ctrl = ClumpingFactor_TotalInt_max_apical_area; ClumpingFactor_NewBBCount_max_apical_area_ctrl = ClumpingFactor_NewBBCount_max_apical_area;
    isotropicity_at_max_apical_area_ctrl = isotropicity(max_apical_area_idx_ctrl); circularity_at_max_apical_area_ctrl = circularity(max_apical_area_idx_ctrl);
    [~, max_Area_Clustering_idx_ctrl] = arrayfun(@(i) max(Area_Clustering(1:time_threshold_idx(i), i)), 1:size(Area_Clustering, 2)); % extracting the max area index within the range of 'time_threshold_idx' i.e. within 2.5 h range
    Local_Clustering_at_max_apical_area_ctrl = Local_Clustering(max_Area_Clustering_idx_ctrl); Global_Clustering_at_max_apical_area_ctrl = Global_Clustering(max_Area_Clustering_idx_ctrl);
    % below we are getting the 'min_distance' & 'all_distance' value for the max_area; This requires elaborate steps to achieve which are below; this treatment is only for 'min_distance' & 'all_distance' matrices since there are many values corresponding
    % to one area and therefore the matrix size is different from the matrix size of area_apicaldomain
    for col = 1:size(neighbor_bb_all_dist,2) % this loop goes through all the columns of the all_dist array and gets all the all_dist values corresponding the max_area for each column
        all_dist_max_area_rows_ctrl = neighbor_bb_all_dist_area(:,col) == apical_area_at_max_apical_area_ctrl(col); % getting all the rows that correspond to the max_area
        min_dist_max_area_rows_ctrl = neighbor_bb_min_dist_area(:,col) == apical_area_at_max_apical_area_ctrl(col); % getting all the rows that correspond to the max_area
        neibor_min_dist_area_ctrl{col} = neighbor_bb_min_dist_area(min_dist_max_area_rows_ctrl,col); % 'minimum distances'; using the rows obtained above to get all the areas - this is only for checking
        neibor_min_dist_ctrl{col} = neighbor_bb_min_dist(min_dist_max_area_rows_ctrl,col); % 'minimum distances'; using the rows obtained above to get all the distances corresponding to the max_area
        neibor_all_dist_area_ctrl{col} = neighbor_bb_all_dist_area(all_dist_max_area_rows_ctrl,col); % 'all distances'; using the rows obtained above to get all the areas - this is only for checking
        neibor_all_dist_ctrl{col} = neighbor_bb_all_dist(all_dist_max_area_rows_ctrl,col); % 'all distances'; using the rows obtained above to get all the distances corresponding to the max_area
    end
    mean_neibor_min_dist_ctrl = cellfun(@(x) nanmean(x), neibor_min_dist_ctrl)'; % 'minimum distances'; getting the mean of 'all_distances' for the max_area frame
    nearneigbor_mindist_at_max_apical_area_ctrl = cell2mat(neibor_min_dist_ctrl(:)); % 'minimum distances'; listing all the 'all_distances' values from the max_area frame as a single column vector
    mean_neibor_all_dist_ctrl = cellfun(@(x) nanmean(x), neibor_all_dist_ctrl)'; % 'all distances'; getting the mean of 'all_distances' for the max_area frame
    all_interdist_at_max_apical_area_ctrl = cell2mat(neibor_all_dist_ctrl(:)); % 'all distances'; listing all the 'all_distances' values from the max_area frame as a single column vector

    % obtaining the average for Ctrl data at all time points
    apical_area_avg_all_times_ctrl = area_apicaldomain; whole_area_rate_ctrl = Whole_area_rate; bbcount_avg_all_times_ctrl = no_of_bb; bbdensity_avg_all_times_ctrl = BB_density_norm_modified; bbMeanInterdistance_avg_all_times_ctrl = Mintd; Local_Clustering_avg_all_times_ctrl = Local_Clustering; Global_Clustering_avg_all_times_ctrl = Global_Clustering; VarianceVoronoi_avg_all_times_ctrl = VarianceTessalation_YData_area; ln_VarianceVoronoi_avg_all_times_ctrl = lnVarianceTessalation_YData_area; MeanInt_wholearea_avg_all_times_ctrl = meanintensity_apicaldomain;
    TotalInt_wholearea_avg_all_times_ctrl = totalintensity_apicaldomain; dist_btw_newBB_avg_all_times_ctrl = NewNewBBappearancedist_YData_area; dist_all_btw_newBB_avg_all_times_ctrl = new_new_allDist_YData_area; dist_btw_new_existing_bb_avg_all_times_ctrl = NewExistingBBappearancedist_YData_area; dist_all_btw_new_existing_bb_avg_all_times_ctrl = new_existing_allDist_YData_area; near_neighbor_mindist_avg_all_times_ctrl = NearNeighbdist_YData_area; all_dist_avg_all_times_ctrl = Existing_allDist_YData_area;
    Avgdist_btw_newBB_avg_all_times_ctrl = AvgNewNewBBMinDist_YData_area; Avgdist_all_btw_newBB_avg_all_times_ctrl = AvgNewNewBBAllDist_YData_area; Avgdist_btw_new_existing_bb_avg_all_times_ctrl = AvgNewExistBBMinDist_YData_area; Avgdist_all_btw_new_existing_bb_avg_all_times_ctrl = AvgNewExistBBAllDist_YData_area; Avgnear_neighbor_mindist_avg_all_times_ctrl = AvgNearNeighbourBBMinDist_YData_area; Avgall_dist_avg_all_times_ctrl = AvgExistBBAllDist_YData_area;
    meanint_atBBpos_1stframe_ctrl = meanint_atBBpos_1stframe; meanint_atBBpos_maxapicalarea_ctrl = meanint_atBBpos_maxapicalarea; totalint_atBBpos_1stframe_ctrl = totalint_atBBpos_1stframe; totalint_atBBpos_maxapicalarea_ctrl = totalint_atBBpos_maxapicalarea; meanint_atBBSurr_1stframe_ctrl = meanint_atBBSurr_1stframe; meanint_atBBSurr_maxapicalarea_ctrl = meanint_atBBSurr_maxapicalarea; totalint_atBBSurr_1stframe_ctrl = totalint_atBBSurr_1stframe;
    totalint_atBBSurr_maxapicalarea_ctrl = totalint_atBBSurr_maxapicalarea; meanint_ratio_BBSurPos_1stframe_ctrl = meanint_ratio_BBSurPos_1stframe; meanint_ratio_BBSurPos_maxapicalarea_ctrl = meanint_ratio_BBSurPos_maxapicalarea; totalint_ratio_BBSurPos_1stframe_ctrl = totalint_ratio_BBSurPos_1stframe; totalint_ratio_BBSurPos_maxapicalarea_ctrl = totalint_ratio_BBSurPos_maxapicalarea;
    clumpingfactor_area_avg_all_times_ctrl = clumpingfactor_area_YData_area; clumpingfactor_arearate_avg_all_times_ctrl = clumpingfactor_arearate_YData_area; clumpingfactor_bbcount_avg_all_times_ctrl = clumpingfactor_bbcount_YData_area; clumpingfactor_bbdensity_avg_all_times_ctrl = clumpingfactor_bbdensity_YData_area;
    clumpingfactor_meanint_avg_all_times_ctrl = clumpingfactor_meanint_YData_area; clumpingfactor_totalint_avg_all_times_ctrl = clumpingfactor_totalint_YData_area; clumpingfactor_newbbcount_avg_all_times_ctrl = clumpingfactor_newbbcount_YData_area; isotropicity_avg_all_times_ctrl = isotropicity_YData_area; circularity_avg_all_times_ctrl = circularity_YData_area; Newbbentrycount_avg_all_times_ctrl = NewBBEntryCount_YData_area; Newbbentrycount_avg_all_times_ctrl(Newbbentrycount_avg_all_times_ctrl==0) = NaN; Newbbexitcount_avg_all_times_ctrl = NewBBExitCount_YData_area; 
    Newbbexitcount_avg_all_times_ctrl(Newbbexitcount_avg_all_times_ctrl==0) = NaN; Newbbentryrate_avg_all_times_ctrl =  NewBBEntryRate_YData_area; Newbbexitrate_avg_all_times_ctrl = NewBBExitRate_YData_area; contourlength_avg_all_times_ctrl = ContourLength_fin; endtoendlength_avg_all_times_ctrl = EndToEndLength_fin; tortuosity_avg_all_times_ctrl = Tortuosity_finall; bb_step_dist_avg_all_times_ctrl = step_dist_fin; bb_inst_speed_avg_all_times_ctrl = inst_speed_fin; Drift_slope_ctrl = Drift_slope; Diff_Coeff_fit_min_ctrl = diff_coef_fit_minutes; Diff_Strength_fit_ctrl = diff_strength_fit; AlphaValue_ctrl = alpha_value;
    quad_areaNorm_var_all_times_ctrl = quad_areaNorm_YData_area_var; quad_AreaRateNorm_var_all_times_ctrl = quad_AreaRateNorm_YData_area_var; quad_BBcountNorm_var_all_times_ctrl = quad_BBcountNorm_YData_area_var; quad_BBdensityNorm_var_all_times_ctrl = quad_BBdensityNorm_YData_area_var; quad_MeanIntnorm_var_all_times_ctrl = quad_MeanIntnorm_YData_area_var; quad_TotalIntnorm_var_all_times_ctrl = quad_TotalIntnorm_YData_area_var; quad_newBBCountnorm_var_all_times_ctrl = quad_newBBCountnorm_YData_area_var;

else
    % obtaining the Mo data at max. apical area
    [~, time_threshold_idx] = min(abs(timelist - 150), [], 1); [~, timeclustering_threshold_idx] = min(abs(Time_Clustering - 150), [], 1); % here we get the row index of the 'timelist' matrix that corresponds to '150' minutes (i.e. 2.5 h). This is because, we are interested only in the time range of 2.5 h (to have similar experimental time lines for control & MO). So th idea is to use this index and search within range in the 'area_apicaldomain' matrix for max(area) and use that area as the maximum area
    [apical_area_at_max_apical_area_mo, max_apical_area_idx_mo] = arrayfun(@(i) max(area_apicaldomain(1:time_threshold_idx(i), i)), 1:size(area_apicaldomain, 2)); % extracting the max area within the range of 'time_threshold_idx' i.e. within 2.5 h range
    [BB_count_max_mo, ~] = arrayfun(@(i) max(no_of_bb(1:time_threshold_idx(i), i)), 1:size(no_of_bb, 2)); % extracting the max BB_count within the range of 'time_threshold_idx' i.e. within 2.5 h range
    BB_density_norm_at_max_apical_area_mo = BB_density_norm(max_apical_area_idx_mo); BB_mean_interdistance_at_max_apical_area_mo = Mintd(max_apical_area_idx_mo);
    Variance_voronoi_at_max_apical_area_mo = Variance_voronoi_fin_norm_all(max_apical_area_idx_mo); ln_Variance_voronoi_at_max_apical_area_mo = Variance_voronoi_fin_log_all_norm(max_apical_area_idx_mo); meanint_whole_area_at_max_apical_area_mo = meanintensity_apicaldomain(max_apical_area_idx_mo); totalint_whole_area_at_max_apical_area_mo = totalintensity_apicaldomain(max_apical_area_idx_mo); ClumpingFactor_Area_max_apical_area_mo = ClumpingFactor_Area_max_apical_area; ClumpingFactor_AreaRate_max_apical_area_mo = ClumpingFactor_AreaRate_max_apical_area;
    ClumpingFactor_BBCount_max_apical_area_mo = ClumpingFactor_BBCount_max_apical_area; ClumpingFactor_BBDensity_max_apical_area_mo = ClumpingFactor_BBDensity_max_apical_area; ClumpingFactor_MeanInt_max_apical_area_mo = ClumpingFactor_MeanInt_max_apical_area; ClumpingFactor_TotalInt_max_apical_area_mo = ClumpingFactor_TotalInt_max_apical_area; ClumpingFactor_NewBBCount_max_apical_area_mo = ClumpingFactor_NewBBCount_max_apical_area;
    isotropicity_at_max_apical_area_mo = isotropicity(max_apical_area_idx_mo); circularity_at_max_apical_area_mo = circularity(max_apical_area_idx_mo);
    [~, max_Area_Clustering_idx_mo] = arrayfun(@(i) max(Area_Clustering(1:time_threshold_idx(i), i)), 1:size(Area_Clustering, 2)); % extracting the max area index within the range of 'time_threshold_idx' i.e. within 2.5 h range
    Local_Clustering_at_max_apical_area_mo = Local_Clustering(max_Area_Clustering_idx_mo); Global_Clustering_at_max_apical_area_mo = Global_Clustering(max_Area_Clustering_idx_mo);
    % below we are getting the 'min_distance' & 'all_distance' value for the max_area; This requires elaborate steps to achieve which are below; this treatment is only for 'min_distance' & 'all_distance' matrices since there are many values corresponding
    % to one area and therefore the matrix size is different from the matrix size of area_apicaldomain
    for col = 1:size(neighbor_bb_all_dist,2) % this loop goes through all the columns of the all_dist array and gets all the all_dist values corresponding the max_area for each column
        all_dist_max_area_rows_mo = neighbor_bb_all_dist_area(:,col) == apical_area_at_max_apical_area_mo(col); % getting all the rows that correspond to the max_area
        min_dist_max_area_rows_mo = neighbor_bb_min_dist_area(:,col) == apical_area_at_max_apical_area_mo(col); % getting all the rows that correspond to the max_area
        neibor_min_dist_area_mo{col} = neighbor_bb_min_dist_area(min_dist_max_area_rows_mo,col); % 'minimum distances'; using the rows obtained above to get all the areas - this is only for checking
        neibor_min_dist_mo{col} = neighbor_bb_min_dist(min_dist_max_area_rows_mo,col); % 'minimum distances'; using the rows obtained above to get all the distances corresponding to the max_area
        neibor_all_dist_area_mo{col} = neighbor_bb_all_dist_area(all_dist_max_area_rows_mo,col); % 'all distances'; using the rows obtained above to get all the areas - this is only for checking
        neibor_all_dist_mo{col} = neighbor_bb_all_dist(all_dist_max_area_rows_mo,col); % 'all distances'; using the rows obtained above to get all the distances corresponding to the max_area
    end
    mean_neibor_min_dist_mo = cellfun(@(x) nanmean(x), neibor_min_dist_mo)'; % 'minimum distances'; getting the mean of 'all_distances' for the max_area frame
    nearneigbor_mindist_at_max_apical_area_mo = cell2mat(neibor_min_dist_mo(:)); % 'minimum distances'; listing all the 'all_distances' values from the max_area frame as a single column vector
    mean_neibor_all_dist_mo = cellfun(@(x) nanmean(x), neibor_all_dist_mo)'; % 'all distances'; getting the mean of 'all_distances' for the max_area frame
    all_interdist_at_max_apical_area_mo = cell2mat(neibor_all_dist_mo(:)); % 'all distances'; listing all the 'all_distances' values from the max_area frame as a single column vector

    % obtaining the average for mo data at all time points
    apical_area_avg_all_times_mo = area_apicaldomain; whole_area_rate_mo = Whole_area_rate; bbcount_avg_all_times_mo = no_of_bb; bbdensity_avg_all_times_mo = BB_density_norm_modified; bbMeanInterdistance_avg_all_times_mo = Mintd; Local_Clustering_avg_all_times_mo = Local_Clustering; Global_Clustering_avg_all_times_mo = Global_Clustering; VarianceVoronoi_avg_all_times_mo = VarianceTessalation_YData_area; ln_VarianceVoronoi_avg_all_times_mo = lnVarianceTessalation_YData_area; MeanInt_wholearea_avg_all_times_mo = meanintensity_apicaldomain;
    TotalInt_wholearea_avg_all_times_mo = totalintensity_apicaldomain; dist_btw_newBB_avg_all_times_mo = NewNewBBappearancedist_YData_area; dist_all_btw_newBB_avg_all_times_mo = new_new_allDist_YData_area; dist_btw_new_existing_bb_avg_all_times_mo = NewExistingBBappearancedist_YData_area; dist_all_btw_new_existing_bb_avg_all_times_mo = new_existing_allDist_YData_area; near_neighbor_mindist_avg_all_times_mo = NearNeighbdist_YData_area; all_dist_avg_all_times_mo = Existing_allDist_YData_area;
    Avgdist_btw_newBB_avg_all_times_mo = AvgNewNewBBMinDist_YData_area; Avgdist_all_btw_newBB_avg_all_times_mo = AvgNewNewBBAllDist_YData_area; Avgdist_btw_new_existing_bb_avg_all_times_mo = AvgNewExistBBMinDist_YData_area; Avgdist_all_btw_new_existing_bb_avg_all_times_mo = AvgNewExistBBAllDist_YData_area; Avgnear_neighbor_mindist_avg_all_times_mo = AvgNearNeighbourBBMinDist_YData_area; Avgall_dist_avg_all_times_mo = AvgExistBBAllDist_YData_area;
    meanint_atBBpos_1stframe_mo = meanint_atBBpos_1stframe; meanint_atBBpos_maxapicalarea_mo = meanint_atBBpos_maxapicalarea; totalint_atBBpos_1stframe_mo = totalint_atBBpos_1stframe; totalint_atBBpos_maxapicalarea_mo = totalint_atBBpos_maxapicalarea; meanint_atBBSurr_1stframe_mo = meanint_atBBSurr_1stframe; meanint_atBBSurr_maxapicalarea_mo = meanint_atBBSurr_maxapicalarea; totalint_atBBSurr_1stframe_mo = totalint_atBBSurr_1stframe;
    totalint_atBBSurr_maxapicalarea_mo = totalint_atBBSurr_maxapicalarea; meanint_ratio_BBSurPos_1stframe_mo = meanint_ratio_BBSurPos_1stframe; meanint_ratio_BBSurPos_maxapicalarea_mo = meanint_ratio_BBSurPos_maxapicalarea; totalint_ratio_BBSurPos_1stframe_mo = totalint_ratio_BBSurPos_1stframe; totalint_ratio_BBSurPos_maxapicalarea_mo = totalint_ratio_BBSurPos_maxapicalarea;
    clumpingfactor_area_avg_all_times_mo = clumpingfactor_area_YData_area; clumpingfactor_arearate_avg_all_times_mo = clumpingfactor_arearate_YData_area; clumpingfactor_bbcount_avg_all_times_mo = clumpingfactor_bbcount_YData_area; clumpingfactor_bbdensity_avg_all_times_mo = clumpingfactor_bbdensity_YData_area;
    clumpingfactor_meanint_avg_all_times_mo = clumpingfactor_meanint_YData_area; clumpingfactor_totalint_avg_all_times_mo = clumpingfactor_totalint_YData_area; clumpingfactor_newbbcount_avg_all_times_mo = clumpingfactor_newbbcount_YData_area; isotropicity_avg_all_times_mo = isotropicity_YData_area; circularity_avg_all_times_mo = circularity_YData_area; Newbbentrycount_avg_all_times_mo = NewBBEntryCount_YData_area; Newbbentrycount_avg_all_times_mo(Newbbentrycount_avg_all_times_mo==0) = NaN; Newbbexitcount_avg_all_times_mo = NewBBExitCount_YData_area;
    Newbbexitcount_avg_all_times_mo(Newbbexitcount_avg_all_times_mo==0) = NaN; Newbbentryrate_avg_all_times_mo =  NewBBEntryRate_YData_area; Newbbexitrate_avg_all_times_mo = NewBBExitRate_YData_area; contourlength_avg_all_times_mo = ContourLength_fin; endtoendlength_avg_all_times_mo = EndToEndLength_fin; tortuosity_avg_all_times_mo = Tortuosity_finall; bb_step_dist_avg_all_times_mo = step_dist_fin; bb_inst_speed_avg_all_times_mo = inst_speed_fin; Drift_slope_mo = Drift_slope; Diff_Coeff_fit_min_mo = diff_coef_fit_minutes; Diff_Strength_fit_mo = diff_strength_fit; AlphaValue_mo = alpha_value;
    quad_areaNorm_var_all_times_mo = quad_areaNorm_YData_area_var; quad_AreaRateNorm_var_all_times_mo = quad_AreaRateNorm_YData_area_var; quad_BBcountNorm_var_all_times_mo = quad_BBcountNorm_YData_area_var; quad_BBdensityNorm_var_all_times_mo = quad_BBdensityNorm_YData_area_var; quad_MeanIntnorm_var_all_times_mo = quad_MeanIntnorm_YData_area_var; quad_TotalIntnorm_var_all_times_mo = quad_TotalIntnorm_YData_area_var; quad_newBBCountnorm_var_all_times_mo = quad_newBBCountnorm_YData_area_var;

    % plotting the ctrl & Mo data
    main_folder_link_ctrl = uigetdir(main_folder_link, 'Select the folder that contains the workspace of avg data for control condition'); % Select the "Result_Data" folder for the control condition
    ctrl_workspace_link = fullfile(main_folder_link_ctrl, 'workspace_all_avg_data.mat');
    load(ctrl_workspace_link, 'apical_area_at_max_apical_area_ctrl', 'max_apical_area_idx_ctrl', 'BB_count_max_ctrl', 'BB_density_norm_at_max_apical_area_ctrl', 'BB_mean_interdistance_at_max_apical_area_ctrl', 'Local_Clustering_at_max_apical_area_ctrl', 'Global_Clustering_at_max_apical_area_ctrl', 'Variance_voronoi_at_max_apical_area_ctrl', 'ln_Variance_voronoi_at_max_apical_area_ctrl', 'nearneigbor_mindist_at_max_apical_area_ctrl', 'all_interdist_at_max_apical_area_ctrl', 'meanint_whole_area_at_max_apical_area_ctrl', 'totalint_whole_area_at_max_apical_area_ctrl',...
        'ClumpingFactor_Area_max_apical_area_ctrl', 'ClumpingFactor_AreaRate_max_apical_area_ctrl', 'ClumpingFactor_BBCount_max_apical_area_ctrl', 'ClumpingFactor_BBDensity_max_apical_area_ctrl', 'ClumpingFactor_MeanInt_max_apical_area_ctrl', 'ClumpingFactor_TotalInt_max_apical_area_ctrl', 'ClumpingFactor_NewBBCount_max_apical_area_ctrl', 'isotropicity_at_max_apical_area_ctrl', 'circularity_at_max_apical_area_ctrl',...
        'apical_area_avg_all_times_ctrl', 'whole_area_rate_ctrl', 'bbcount_avg_all_times_ctrl', 'bbdensity_avg_all_times_ctrl', 'bbMeanInterdistance_avg_all_times_ctrl', 'Local_Clustering_avg_all_times_ctrl', 'Global_Clustering_avg_all_times_ctrl', 'VarianceVoronoi_avg_all_times_ctrl', 'ln_VarianceVoronoi_avg_all_times_ctrl', 'MeanInt_wholearea_avg_all_times_ctrl', 'TotalInt_wholearea_avg_all_times_ctrl', 'dist_btw_newBB_avg_all_times_ctrl', 'dist_all_btw_newBB_avg_all_times_ctrl', 'dist_btw_new_existing_bb_avg_all_times_ctrl', 'dist_all_btw_new_existing_bb_avg_all_times_ctrl', 'near_neighbor_mindist_avg_all_times_ctrl', 'all_dist_avg_all_times_ctrl',...
        'Avgdist_btw_newBB_avg_all_times_ctrl', 'Avgdist_all_btw_newBB_avg_all_times_ctrl', 'Avgdist_btw_new_existing_bb_avg_all_times_ctrl', 'Avgdist_all_btw_new_existing_bb_avg_all_times_ctrl', 'Avgnear_neighbor_mindist_avg_all_times_ctrl', 'Avgall_dist_avg_all_times_ctrl', 'meanint_atBBpos_1stframe_ctrl', 'meanint_atBBpos_maxapicalarea_ctrl', 'totalint_atBBpos_1stframe_ctrl', 'totalint_atBBpos_maxapicalarea_ctrl', 'meanint_atBBSurr_1stframe_ctrl', 'meanint_atBBSurr_maxapicalarea_ctrl', 'totalint_atBBSurr_1stframe_ctrl', 'totalint_atBBSurr_maxapicalarea_ctrl', 'meanint_ratio_BBSurPos_1stframe_ctrl', 'meanint_ratio_BBSurPos_maxapicalarea_ctrl', 'totalint_ratio_BBSurPos_1stframe_ctrl', 'totalint_ratio_BBSurPos_maxapicalarea_ctrl',...
        'clumpingfactor_area_avg_all_times_ctrl', 'clumpingfactor_arearate_avg_all_times_ctrl', 'clumpingfactor_bbcount_avg_all_times_ctrl', 'clumpingfactor_bbdensity_avg_all_times_ctrl', 'clumpingfactor_meanint_avg_all_times_ctrl', 'clumpingfactor_totalint_avg_all_times_ctrl', 'clumpingfactor_newbbcount_avg_all_times_ctrl',...
        'isotropicity_avg_all_times_ctrl', 'circularity_avg_all_times_ctrl', 'Newbbentrycount_avg_all_times_ctrl', 'Newbbexitcount_avg_all_times_ctrl', 'Newbbentryrate_avg_all_times_ctrl', 'Newbbexitrate_avg_all_times_ctrl', 'contourlength_avg_all_times_ctrl', 'endtoendlength_avg_all_times_ctrl', 'tortuosity_avg_all_times_ctrl', 'bb_step_dist_avg_all_times_ctrl', 'bb_inst_speed_avg_all_times_ctrl', 'Drift_slope_ctrl', 'Diff_Coeff_fit_min_ctrl', 'Diff_Strength_fit_ctrl', 'AlphaValue_ctrl', 'quad_areaNorm_var_all_times_ctrl', 'quad_AreaRateNorm_var_all_times_ctrl', 'quad_BBcountNorm_var_all_times_ctrl', 'quad_BBdensityNorm_var_all_times_ctrl', 'quad_MeanIntnorm_var_all_times_ctrl', 'quad_TotalIntnorm_var_all_times_ctrl', 'quad_newBBCountnorm_var_all_times_ctrl');

    
    %------------------------ Average at max. apical area ------------------------%

    % Apical area comparison between control & MO
    [apical_area_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(apical_area_at_max_apical_area_ctrl, apical_area_at_max_apical_area_mo, 'Apical area [\mum^2]', 'Apical area (at max. apical area)', 'comparisonCtrlMo_apicalarea_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % BB count comparison between control & MO
    [BBcount_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(BB_count_max_ctrl, BB_count_max_mo, 'BB count', 'BB count (at max. apical area)', 'comparisonCtrlMo_bbcount_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % BB density comparison between control & MO
    [BBdensitynorm_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(BB_density_norm_at_max_apical_area_ctrl, BB_density_norm_at_max_apical_area_mo, 'BB density [\mum^{-2}]', 'BB density comparison (at max. apical area)', 'comparisonCtrlMo_bbdensity_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % BB mean interdistance comparison between control & MO
    [BBmeanInterdistance_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(BB_mean_interdistance_at_max_apical_area_ctrl, BB_mean_interdistance_at_max_apical_area_mo, 'Mean interdistance [\mum]', {'BB mean interdistance', 'comparison (at max. apical area)'}, 'comparisonCtrlMo_bbmeaninterdistance_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Local clustering comparison between control & MO
    [Local_Clustering_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(Local_Clustering_at_max_apical_area_ctrl, Local_Clustering_at_max_apical_area_mo, 'Local clustering index', {'Local clustering', 'comparison (at max. apical area)'}, 'comparisonCtrlMo_localClustering_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Global clustering comparison between control & MO
    [Global_Clustering_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(Global_Clustering_at_max_apical_area_ctrl, Global_Clustering_at_max_apical_area_mo, 'Global clustering index', {'Global clustering', 'comparison (at max. apical area)'}, 'comparisonCtrlMo_globalClustering_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Variance in voronoi comparison between control & MO
    [VarianceVoronoi_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(Variance_voronoi_at_max_apical_area_ctrl, Variance_voronoi_at_max_apical_area_mo, {'Variance in tessalation areas', '(normalised by MeanArea squared)'}, {'Variance in tessalation area', ' (at max. apical area)'}, 'comparisonCtrlMo_bbVariance_in_tessalation_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % ln(Variance) in voronoi comparison between control & MO
    [ln_VarianceVoronoi_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(ln_Variance_voronoi_at_max_apical_area_ctrl, ln_Variance_voronoi_at_max_apical_area_mo, {'ln(Variance) in tessalation areas', '(Min-Max normalised)'}, {'Log of Variance in tessalation area', ' (at max. apical area)'}, 'comparisonCtrlMo_bbLogVariance_in_tessalation_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Nearest neighbor minimal distance comparison between control & MO
    [NeighborMinDist_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(nearneigbor_mindist_at_max_apical_area_ctrl, nearneigbor_mindist_at_max_apical_area_mo, 'Nearest Neighbor distance [\mum]', {'Nearest neighbor (minimum) distance', 'of all BBs (at max. apical area)'}, 'comparisonCtrlMo_nearest_neighbor_min_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % All distances comparison between control & MO
    [allInterDist_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(all_interdist_at_max_apical_area_ctrl, all_interdist_at_max_apical_area_mo, 'Distance between BBs [\mum]', {'Distance between all BBs', '(at max. apical area)'}, 'comparisonCtrlMo_distance_btw_all_BBs_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Mean intensity of actin in the whole apical area
    [meanIntWholeArea_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(meanint_whole_area_at_max_apical_area_ctrl, meanint_whole_area_at_max_apical_area_mo, 'Mean intensity (normalised)', {'Mean intensity of whole apical', 'area (at max. apical area)'}, 'comparisonCtrlMo_MeanIntArea_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Total intensity of actin in the whole apical area comparison between control & MO
    [totalIntWholeArea_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(totalint_whole_area_at_max_apical_area_ctrl, totalint_whole_area_at_max_apical_area_mo, 'Total intensity (normalised)', {'Total intensity of whole', 'apical area (at max. apical area)'}, 'comparisonCtrlMo_TotalIntArea_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Isotropicity comparison between control & MO
    [isotropicity_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(isotropicity_at_max_apical_area_ctrl, isotropicity_at_max_apical_area_mo, 'Isotropicity', {'Isotropicity (ratio of major-minor axes)', '(at max. apical area)'}, 'comparisonCtrlMo_isotropicity_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Circularity comparison between control & MO
    [circularity_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(circularity_at_max_apical_area_ctrl, circularity_at_max_apical_area_mo, 'Circularity', 'Circularity (at max. apical area)', 'comparisonCtrlMo_circularity_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Clumping factor (Area) comparison between control & MO
    [ClumpingFactor_Area_max_apical_area_ctrl_mo] = prepping_plotting_box_plots(ClumpingFactor_Area_max_apical_area_ctrl, ClumpingFactor_Area_max_apical_area_mo, 'Clumping factor (Area)', 'Clumping factor (Area) (at max. apical area)', 'comparisonCtrlMo_clumpingfac_Area_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Clumping factor (Area rate) comparison between control & MO
    [ClumpingFactor_AreaRate_max_apical_area_ctrl_mo] = prepping_plotting_box_plots(ClumpingFactor_AreaRate_max_apical_area_ctrl, ClumpingFactor_AreaRate_max_apical_area_mo, 'Clumping factor (Area rate)', 'Clumping factor (Area rate) (at max. apical area)', 'comparisonCtrlMo_clumpingfac_Arearate_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Clumping factor (BB count) comparison between control & MO
    [ClumpingFactor_BBCount_max_apical_area_ctrl_mo] = prepping_plotting_box_plots(ClumpingFactor_BBCount_max_apical_area_ctrl, ClumpingFactor_BBCount_max_apical_area_mo, 'Clumping factor (BB count)', 'Clumping factor (BB count) (at max. apical area)', 'comparisonCtrlMo_clumpingfac_BBcount_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Clumping factor (BB density) comparison between control & MO
    [clumpingFactor_BBDensity_at_MaxArea_ctrl_mo] = prepping_plotting_box_plots(ClumpingFactor_BBDensity_max_apical_area_ctrl, ClumpingFactor_BBDensity_max_apical_area_mo, 'Clumping factor (BB density)', 'Clumping factor (BB density) (at max. apical area)', 'comparisonCtrlMo_clumpingfac_BBdensity_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Clumping factor (Mean Int) comparison between control & MO
    [ClumpingFactor_MeanInt_max_apical_area_ctrl_mo] = prepping_plotting_box_plots(ClumpingFactor_MeanInt_max_apical_area_ctrl, ClumpingFactor_MeanInt_max_apical_area_mo, 'Clumping factor (Mean Int)', 'Clumping factor (Mean Int) (at max. apical area)', 'comparisonCtrlMo_clumpingfac_meanint_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Clumping factor (Total Int) comparison between control & MO
    [ClumpingFactor_TotalInt_max_apical_area_ctrl_mo] = prepping_plotting_box_plots(ClumpingFactor_TotalInt_max_apical_area_ctrl, ClumpingFactor_TotalInt_max_apical_area_mo, 'Clumping factor (Total Int)', 'Clumping factor (Total Int) (at max. apical area)', 'comparisonCtrlMo_clumpingfac_totalint_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Clumping factor (New BB count) comparison between control & MO
    [ClumpingFactor_NewBBCount_max_apical_area_ctrl_mo] = prepping_plotting_box_plots(ClumpingFactor_NewBBCount_max_apical_area_ctrl, ClumpingFactor_NewBBCount_max_apical_area_mo, 'Clumping factor (New BB count)', 'Clumping factor (New BB count) (at max. apical area)', 'comparisonCtrlMo_clumpingfac_newbbcount_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    %------------------------ Average of all time points ------------------------%

    % Apical area comparison between control & MO
    parameter_1 = apical_area_avg_all_times_ctrl; parameter_2 = apical_area_avg_all_times_mo; bininterval = 10; XLabel = 'Apical area [\mum^2]'; Ylabel = 'Apical area [\mum^2]'; Plot_title = 'Apical area (avg at all times)'; save_title = 'comparisonCtrlMo_apicalarea_fulavg'; legend_type = 'comparison_ctrl_mo';
    [apicalArea_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Whole area rate comparison between control & MO
    [wholeAreaRate_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(whole_area_rate_ctrl, whole_area_rate_mo, 'Rate of area expansion [\mum^2 min^{-1}]', {'Whole area expansion rate', '(avg at all times)'}, 'comparisonCtrlMo_wholearearate_fulavg', BB_apical_avg, 'comparison_ctrl_mo');

    % BB count comparison between control & MO
    parameter_1 = bbcount_avg_all_times_ctrl; parameter_2 = bbcount_avg_all_times_mo; bininterval = 5; XLabel = 'BB count'; Ylabel = 'BB count'; Plot_title = 'BB count (avg at all times)'; save_title = 'comparisonCtrlMo_bbcount_fulavg'; legend_type = 'comparison_ctrl_mo';
    [bbcount_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % BB density comparison between control & MO
    parameter_1 = bbdensity_avg_all_times_ctrl; parameter_2 = bbdensity_avg_all_times_mo; bininterval = 0.01; XLabel = 'BB density [\mum^{-2}]'; Ylabel = 'BB density [\mum^{-2}]'; Plot_title = 'BB density (avg at all times)'; save_title = 'comparisonCtrlMo_bbdensity_fulavg'; legend_type = 'comparison_ctrl_mo';
    [bbdensity_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % BB mean interdistance comparison between control & MO
    parameter_1 = bbMeanInterdistance_avg_all_times_ctrl; parameter_2 = bbMeanInterdistance_avg_all_times_mo; bininterval = 0.1; XLabel = 'Mean interdistance [\mum]'; Ylabel = 'Mean interdistance [\mum]'; Plot_title = {'BB mean interdistance', '(avg at all times)'}; save_title = 'comparisonCtrlMo_bbmeaninterdistance_fulavg'; legend_type = 'comparison_ctrl_mo';
    [bbMeanInterdistance_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Local clustering index comparison between control & MO
    parameter_1 = Local_Clustering_avg_all_times_ctrl; parameter_2 = Local_Clustering_avg_all_times_mo; bininterval = 0.01; XLabel = 'Local clustering index'; Ylabel = 'Local clustering index'; Plot_title = {'Local clustering index', '(avg at all times)'}; save_title = 'comparisonCtrlMo_localClustering_fulavg'; legend_type = 'comparison_ctrl_mo';
    [Local_Clustering_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Global clustering index comparison between control & MO
    parameter_1 = Global_Clustering_avg_all_times_ctrl; parameter_2 = Global_Clustering_avg_all_times_mo; bininterval = 0.01; XLabel = 'Global clustering index'; Ylabel = 'Global clustering index' ; Plot_title = {'Global clustering index', '(avg at all times)'}; save_title = 'comparisonCtrlMo_globalClustering_fulavg'; legend_type = 'comparison_ctrl_mo';
    [Global_Clustering_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Variance in voronoi comparison between control & MO
    parameter_1 = VarianceVoronoi_avg_all_times_ctrl; parameter_2 = VarianceVoronoi_avg_all_times_mo; bininterval = 0.05; XLabel =  {'Variance in tessalation areas', '(normalised by MeanArea squared)'}; Ylabel =  {'Variance in tessalation areas', '(normalised by MeanArea squared)'}; Plot_title = {'Variance in tessalation', 'area (avg at all times)'}; save_title = 'comparisonCtrlMo_bbVariance_in_tessalation_fulavg'; legend_type = 'comparison_ctrl_mo';
    [VarianceVoronoi_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Log of Variance in voronoi comparison between control & MO
    parameter_1 = ln_VarianceVoronoi_avg_all_times_ctrl; parameter_2 = ln_VarianceVoronoi_avg_all_times_mo; bininterval = 0.05; XLabel =  {'Log of Variance in tessalation areas', '(Min-Max normalised)'}; Ylabel =  {'Log of Variance in tessalation areas', '(Min-Max normalised)'}; Plot_title = {'Log of Variance in tessalation', 'area (avg at all times)'}; save_title = 'comparisonCtrlMo_bbLogVariance_in_tessalation_fulavg'; legend_type = 'comparison_ctrl_mo';
    [ln_VarianceVoronoi_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Mean Int. of whole area comparison between control & MO
    [MeanIntWholearea_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(MeanInt_wholearea_avg_all_times_ctrl, MeanInt_wholearea_avg_all_times_mo, 'Mean intensity (normalised)', {'Mean intensity of whole apical', 'area (avg at all times)'}, 'comparisonCtrlMo_MeanIntArea_fulavg', BB_apical_avg, 'comparison_ctrl_mo');

    % Total Int. of whole area comparison between control & MO
    [TotalIntWholearea_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(TotalInt_wholearea_avg_all_times_ctrl, TotalInt_wholearea_avg_all_times_mo, 'Total intensity (normalised)', {'Total intensity of whole apical', 'area (avg at all times)'}, 'comparisonCtrlMo_TotalIntArea_fulavg', BB_apical_avg, 'comparison_ctrl_mo');

    %-----------------------------------------------%

    % Distance (minimal) between new BB & previous new BB; comparison between control & MO
    parameter_1 = dist_btw_newBB_avg_all_times_ctrl; parameter_2 = dist_btw_newBB_avg_all_times_mo; bininterval = 1; XLabel = 'Distance [\mum]'; Ylabel = 'Distance [\mum]'; Plot_title = {'Distance (minimum) between current & previous', 'new BBs (avg at all times)'}; save_title = 'comparisonCtrlMo_newBBsmindist_fulavg'; legend_type = 'comparison_ctrl_mo';
    [distBtwNewBB_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Distance (all) between new BB & previous new BB; comparison between control & MO
    parameter_1 = dist_all_btw_newBB_avg_all_times_ctrl; parameter_2 = dist_all_btw_newBB_avg_all_times_mo; bininterval = 1; XLabel = 'Distance [\mum]'; Ylabel = 'Distance [\mum]'; Plot_title = {'Distance (all) between current & previous', 'new BBs (avg at all times)'}; save_title = 'comparisonCtrlMo_newBBsalldist_fulavg'; legend_type = 'comparison_ctrl_mo';
    [distAllBtwNewBB_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Distance (minimal) between new BB & existing BB; comparison between control & MO
    parameter_1 = dist_btw_new_existing_bb_avg_all_times_ctrl; parameter_2 = dist_btw_new_existing_bb_avg_all_times_mo; bininterval = 0.1; XLabel = 'Distance [\mum]'; Ylabel = 'Distance [\mum]'; Plot_title = {'Distance (minimal) between new & existing', 'BBs (avg at all times)'}; save_title = 'comparisonCtrlMo_NewExistingBBsmindist_fulavg'; legend_type = 'comparison_ctrl_mo';
    [distBtwNewExistingBB_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Distance (all) between new BB & existing BB; comparison between control & MO
    parameter_1 = dist_all_btw_new_existing_bb_avg_all_times_ctrl; parameter_2 = dist_all_btw_new_existing_bb_avg_all_times_mo; bininterval = 0.5; XLabel = 'Distance [\mum]'; Ylabel = 'Distance [\mum]'; Plot_title = {'Distance (all) between new & existing', 'BBs (avg at all times)'}; save_title = 'comparisonCtrlMo_NewExistingBBsalldist_fulavg'; legend_type = 'comparison_ctrl_mo';
    [distAllBtwNewExistingBB_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Nearest neighbor (minimal) distance comparison between control & MO
    parameter_1 = near_neighbor_mindist_avg_all_times_ctrl; parameter_2 = near_neighbor_mindist_avg_all_times_mo; bininterval = 0.1; XLabel = 'Nearest neighbor distance [\mum]'; Ylabel = 'Nearest neighbor distance [\mum]'; Plot_title = {'Nearest neighbor (Minimal)', 'distance (avg at all times)'}; save_title = 'comparisonCtrlMo_nearest_neighbor_dist_fulavg'; legend_type = 'comparison_ctrl_mo';
    [NeighborMinDist_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % All distances between BBs; comparison between control & MO
    parameter_1 = all_dist_avg_all_times_ctrl; parameter_2 = all_dist_avg_all_times_mo; bininterval = 0.5; XLabel = 'Distance between BBs [\mum]'; Ylabel = 'Distance between BBs [\mum]'; Plot_title = {'Distance between all BBs', '(avg at all times)'}; save_title = 'comparisonCtrlMo_distance_btw_all_BBs_fulavg'; legend_type = 'comparison_ctrl_mo';
    [AllDist_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Averaged (per frame) Distance (minimal) between new BB & previous new BB; comparison between control & MO
    parameter_1 = Avgdist_btw_newBB_avg_all_times_ctrl; parameter_2 = Avgdist_btw_newBB_avg_all_times_mo; bininterval = 1; XLabel = 'Distance [\mum]'; Ylabel = 'Distance [\mum]'; Plot_title = {'Distance (minimum), averaged per frame, between', 'current & previous new BBs (avg at all times)'}; save_title = 'comparisonCtrlMo_newBBsminAvgdist_fulavg'; legend_type = 'comparison_ctrl_mo';
    [AvgdistBtwNewBB_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Averaged (per frame) Distance (all) between new BB & previous new BB; comparison between control & MO
    parameter_1 = Avgdist_all_btw_newBB_avg_all_times_ctrl; parameter_2 = Avgdist_all_btw_newBB_avg_all_times_mo; bininterval = 1; XLabel = 'Distance [\mum]'; Ylabel = 'Distance [\mum]'; Plot_title = {'Distance (all), averaged per frame, between', 'current & previous new BBs (avg at all times)'}; save_title = 'comparisonCtrlMo_newBBsallAvgdist_fulavg'; legend_type = 'comparison_ctrl_mo';
    [AvgdistAllBtwNewBB_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Averaged (per frame) Distance (minimal) between new BB & existing BB; comparison between control & MO
    parameter_1 = Avgdist_btw_new_existing_bb_avg_all_times_ctrl; parameter_2 = Avgdist_btw_new_existing_bb_avg_all_times_mo; bininterval = 0.1; XLabel = 'Distance [\mum]'; Ylabel = 'Distance [\mum]'; Plot_title = {'Distance (minimal), averaged per frame, between', ' new & existing BBs (avg at all times)'}; save_title = 'comparisonCtrlMo_NewExistingBBsminAvgdist_fulavg'; legend_type = 'comparison_ctrl_mo';
    [AvgdistBtwNewExistingBB_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Averaged (per frame) Distance (all) between new BB & existing BB; comparison between control & MO
    parameter_1 = Avgdist_all_btw_new_existing_bb_avg_all_times_ctrl; parameter_2 = Avgdist_all_btw_new_existing_bb_avg_all_times_mo; bininterval = 0.5; XLabel = 'Distance [\mum]'; Ylabel = 'Distance [\mum]'; Plot_title = {'Distance (all), averaged per frame, between', ' new & existing BBs (avg at all times)'}; save_title = 'comparisonCtrlMo_NewExistingBBsallAvgdist_fulavg'; legend_type = 'comparison_ctrl_mo';
    [AvgdistAllBtwNewExistingBB_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Averaged (per frame) Nearest neighbor (minimal) distance comparison between control & MO
    parameter_1 = Avgnear_neighbor_mindist_avg_all_times_ctrl; parameter_2 = Avgnear_neighbor_mindist_avg_all_times_mo; bininterval = 0.1; XLabel = 'Nearest neighbor distance [\mum]'; Ylabel = 'Nearest neighbor distance [\mum]'; Plot_title = {'Nearest neighbor (Minimal) distance, averaged per frame,', '(avg at all times)'}; save_title = 'comparisonCtrlMo_nearest_neighbor_Avgdist_fulavg'; legend_type = 'comparison_ctrl_mo';
    [AvgNeighborMinDist_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Averaged (per frame) All distances between BBs; comparison between control & MO
    parameter_1 = Avgall_dist_avg_all_times_ctrl; parameter_2 = Avgall_dist_avg_all_times_mo; bininterval = 0.5; XLabel = 'Distance between BBs [\mum]'; Ylabel = 'Distance between BBs [\mum]'; Plot_title = {'Distance, averaged per frame, between all BBs', '(avg at all times)'}; save_title = 'comparisonCtrlMo_Avgdistance_btw_all_BBs_fulavg'; legend_type = 'comparison_ctrl_mo';
    [AvgAllDist_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    %-----------------------------------------------%

    % Mean Int. at BB position at 1st time point
    [meanIntatBBpos_1stframe_ctrl_mo] = prepping_plotting_box_plots(meanint_atBBpos_1stframe_ctrl, meanint_atBBpos_1stframe_mo, 'Mean intensity (normalised)', {'Mean intensity at BB position', '(at first time point)'}, 'comparisonCtrlMo_MeanIntBBpos_at1sttimepoint', BB_apical_avg, 'comparison_ctrl_mo');

    % Mean Int. at BB position at last time point (at max. area)
    [meanIntatBBpos_maxapicalarea_ctrl_mo] = prepping_plotting_box_plots(meanint_atBBpos_maxapicalarea_ctrl, meanint_atBBpos_maxapicalarea_mo, 'Mean intensity (normalised)', {'Mean intensity at BB position', '(at last time point / at max. area)'}, 'comparisonCtrlMo_MeanIntBBpos_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Total Int. at BB position at 1st time point
    [totalIntatBBpos_1stframe_ctrl_mo] = prepping_plotting_box_plots(totalint_atBBpos_1stframe_ctrl, totalint_atBBpos_1stframe_mo, 'Total intensity (normalised)', {'Total intensity at BB position', '(at first time point)'}, 'comparisonCtrlMo_TotalIntBBpos_at1sttimepoint', BB_apical_avg, 'comparison_ctrl_mo');

    % Total Int. at BB position at last time point (at max. area)
    [totalIntatBBpos_maxapicalarea_ctrl_mo] = prepping_plotting_box_plots(totalint_atBBpos_maxapicalarea_ctrl, totalint_atBBpos_maxapicalarea_mo, 'Total intensity (normalised)', {'Total intensity at BB position', '(at last time point / at max. area)'}, 'comparisonCtrlMo_TotalIntBBpos_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Mean Int. at BB surrounding at 1st time point
    [meanIntatBBsurr_1stframe_ctrl_mo] = prepping_plotting_box_plots(meanint_atBBSurr_1stframe_ctrl, meanint_atBBSurr_1stframe_mo, 'Mean intensity (normalised)', {'Mean intensity at BB surrounding', '(at first time point)'}, 'comparisonCtrlMo_MeanIntBBSurs_at1sttimepoint', BB_apical_avg, 'comparison_ctrl_mo');

    % Mean Int. at BB surrounding at last time point (at max. area)
    [meanIntatBBsurr_maxapicalarea_ctrl_mo] = prepping_plotting_box_plots(meanint_atBBSurr_maxapicalarea_ctrl, meanint_atBBSurr_maxapicalarea_mo, 'Mean intensity (normalised)', {'Mean intensity at BB surrounding', '(at last time point / at max. area)'}, 'comparisonCtrlMo_MeanIntBBSur_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Total Int. at BB surrounding at 1st time point
    [totalIntatBBsurr_1stframe_ctrl_mo] = prepping_plotting_box_plots(totalint_atBBSurr_1stframe_ctrl, totalint_atBBSurr_1stframe_mo, 'Total intensity (normalised)', {'Total intensity at BB surrounding', '(at first time point)'}, 'comparisonCtrlMo_TotalIntBBSur_at1sttimepoint', BB_apical_avg, 'comparison_ctrl_mo');

    % Total Int. at BB surrounding at last time point (at max. area)
    [totalIntatBBsurr_maxapicalarea_ctrl_mo] = prepping_plotting_box_plots(totalint_atBBSurr_maxapicalarea_ctrl, totalint_atBBSurr_maxapicalarea_mo, 'Total intensity (normalised)', {'Total intensity at BB surrounding', '(at last time point / at max. area)'}, 'comparisonCtrlMo_TotalIntBBSur_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Mean Int. ratio of BB surrounding-to-position at 1st time point
    parameter_1 = meanint_ratio_BBSurPos_1stframe_ctrl; parameter_2 = meanint_ratio_BBSurPos_1stframe_mo; bininterval = 0.05; XLabel = 'Mean intensity (normalised)'; Ylabel = 'Mean intensity (normalised)'; Plot_title = {'Mean intensity ratio of BB', 'surrounding-to-position (at first time point)'}; save_title = 'comparisonCtrlMo_MeanIntRatioBBSursPos_at1sttimepoint'; legend_type = 'comparison_ctrl_mo';
    [meanIntRatioBBsurPos_1stframe_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Mean Int. ratio of BB surrounding-to-position (at max. area)
    parameter_1 = meanint_ratio_BBSurPos_maxapicalarea_ctrl; parameter_2 = meanint_ratio_BBSurPos_maxapicalarea_mo; bininterval =  0.05; XLabel = 'Mean intensity (normalised)'; Ylabel = 'Mean intensity (normalised)'; Plot_title = {'Mean intensity ratio of BB surrounding-to-position', '(at last time point / at max. area)'}; save_title = 'comparisonCtrlMo_MeanIntRatioBBSurPos_atMaxArea'; legend_type = 'comparison_ctrl_mo';
    [meanIntRatioBBsurPos_maxapicalarea_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Total Int. ratio of BB surrounding-to-position at 1st time point
    [totalIntRatioBBsurPos_1stframe_ctrl_mo] = prepping_plotting_box_plots(totalint_ratio_BBSurPos_1stframe_ctrl, totalint_ratio_BBSurPos_1stframe_mo, 'Total intensity (normalised)', {'Total intensity ratio of BB', 'surrounding-to-position (at first time point)'}, 'comparisonCtrlMo_TotalIntRatioBBSurPos_at1sttimepoint', BB_apical_avg, 'comparison_ctrl_mo');

    % Total Int. ratio of BB surrounding-to-position at last time point (at max. area)
    [totalIntRatioBBsurPos_maxapicalarea_ctrl_mo] = prepping_plotting_box_plots(totalint_ratio_BBSurPos_maxapicalarea_ctrl, totalint_ratio_BBSurPos_maxapicalarea_mo, 'Total intensity (normalised)', {'Total intensity ratio of BB surrounding-to-position', '(at last time point / at max. area)'}, 'comparisonCtrlMo_TotalIntRatioBBSurPos_atMaxArea', BB_apical_avg, 'comparison_ctrl_mo');

    % Clumping factor (Area) comparison between control & MO
    parameter_1 = clumpingfactor_area_avg_all_times_ctrl; parameter_2 = clumpingfactor_area_avg_all_times_mo; bininterval =  0.005; XLabel = 'Clumping factor (Area)'; Ylabel = 'Clumping factor (Area)'; Plot_title = 'Clumping factor (Area) (avg at all times)'; save_title = 'comparisonCtrlMo_ClumpingFac_Area_fulavg'; legend_type = 'comparison_ctrl_mo';
    [clumpingfactor_area_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Clumping factor (Area Rate) comparison between control & MO
    parameter_1 = clumpingfactor_arearate_avg_all_times_ctrl; parameter_2 = clumpingfactor_arearate_avg_all_times_mo; bininterval =  0.05; XLabel = 'Clumping factor (Area rate)'; Ylabel = 'Clumping factor (Area rate)'; Plot_title = 'Clumping factor (Area rate) (avg at all times)'; save_title = 'comparisonCtrlMo_ClumpingFac_AreaRate_fulavg'; legend_type = 'comparison_ctrl_mo';
    [clumpingfactor_arearate_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Clumping factor (BB count) comparison between control & MO
    parameter_1 = clumpingfactor_bbcount_avg_all_times_ctrl; parameter_2 = clumpingfactor_bbcount_avg_all_times_mo; bininterval =  0.01; XLabel = 'Clumping factor (BB count)'; Ylabel = 'Clumping factor (BB count)'; Plot_title = 'Clumping factor (BB count) (avg at all times)'; save_title = 'comparisonCtrlMo_ClumpingFac_BBcount_fulavg'; legend_type = 'comparison_ctrl_mo';
    [clumpingfactor_bbcount_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Clumping factor (BB density) comparison between control & MO
    parameter_1 = clumpingfactor_bbdensity_avg_all_times_ctrl; parameter_2 = clumpingfactor_bbdensity_avg_all_times_mo; bininterval =  0.01; XLabel = 'Clumping factor (BB density)'; Ylabel = 'Clumping factor (BB density)'; Plot_title = 'Clumping factor (BB density) (avg at all times)'; save_title = 'comparisonCtrlMo_ClumpingFac_BBdensity_fulavg'; legend_type = 'comparison_ctrl_mo';
    [clumpingfactor_bbdensity_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Clumping factor (Mean Int) comparison between control & MO
    parameter_1 = clumpingfactor_meanint_avg_all_times_ctrl; parameter_2 = clumpingfactor_meanint_avg_all_times_mo; bininterval =  0.001; XLabel = 'Clumping factor (Mean Int)'; Ylabel = 'Clumping factor (Mean Int)'; Plot_title = 'Clumping factor (Mean Int) (avg at all times)'; save_title = 'comparisonCtrlMo_ClumpingFac_meanint_fulavg'; legend_type = 'comparison_ctrl_mo';
    [clumpingfactor_meanint_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Clumping factor (Total Int) comparison between control & MO
    parameter_1 = clumpingfactor_totalint_avg_all_times_ctrl; parameter_2 = clumpingfactor_totalint_avg_all_times_mo; bininterval =  0.005; XLabel = 'Clumping factor (Total Int)'; Ylabel = 'Clumping factor (Total Int)'; Plot_title = 'Clumping factor (Total Int) (avg at all times)'; save_title = 'comparisonCtrlMo_ClumpingFac_totalint_fulavg'; legend_type = 'comparison_ctrl_mo';
    [clumpingfactor_totalint_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Clumping factor (New BB count) comparison between control & MO
    parameter_1 = clumpingfactor_newbbcount_avg_all_times_ctrl; parameter_2 = clumpingfactor_newbbcount_avg_all_times_mo; bininterval =  0.1; XLabel = 'Clumping factor (New BB count)'; Ylabel = 'Clumping factor (New BB count)'; Plot_title = 'Clumping factor (New BB count) (avg at all times)'; save_title = 'comparisonCtrlMo_ClumpingFac_newbbcount_fulavg'; legend_type = 'comparison_ctrl_mo';
    [clumpingfactor_newbbcount_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Isotropicity comparison between control & MO
    parameter_1 = isotropicity_avg_all_times_ctrl; parameter_2 = isotropicity_avg_all_times_mo; bininterval = 0.01; XLabel = 'Isotropicity'; Ylabel = 'Isotropicity'; Plot_title = {'Isotropicity (ratio of major-minor axes)', '(avg at all times)'}; save_title = 'comparisonCtrlMo_isotropicity_fulavg'; legend_type = 'comparison_ctrl_mo';
    [isotropicity_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Circularity comparison between control & MO
    parameter_1 = circularity_avg_all_times_ctrl; parameter_2 = circularity_avg_all_times_mo; bininterval = 0.01; XLabel = 'Circularity'; Ylabel = 'Circularity'; Plot_title = 'Circularity (avg at all times)'; save_title = 'comparisonCtrlMo_circularity_fulavg'; legend_type = 'comparison_ctrl_mo';
    [circularity_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % BB entry count comparison between control & MO
    parameter_1 = Newbbentrycount_avg_all_times_ctrl; parameter_2 = Newbbentrycount_avg_all_times_mo; bininterval = 2; XLabel = 'BB entry count'; Ylabel = 'BB entry count'; Plot_title = 'BB entry count (avg at all times)'; save_title = 'comparisonCtrlMo_bbentrycount_fulavg'; legend_type = 'comparison_ctrl_mo';
    [Newbbentrycount_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2    

    % BB exit count comparison between control & MO
    parameter_1 = Newbbexitcount_avg_all_times_ctrl; parameter_2 = Newbbexitcount_avg_all_times_mo; bininterval = 2; XLabel = 'BB exit count'; Ylabel = 'BB exit count'; Plot_title = 'BB exit count (avg at all times)'; save_title = 'comparisonCtrlMo_bbexitcount_fulavg'; legend_type = 'comparison_ctrl_mo';
    [Newbbexitcount_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2    

    % BB entry rate comparison between control & MO
    parameter_1 = Newbbentryrate_avg_all_times_ctrl; parameter_2 = Newbbentryrate_avg_all_times_mo; bininterval = 0.5; XLabel = 'BB entry rate (BB min^{-1})'; Ylabel = 'BB entry rate (BB min^{-1})'; Plot_title = 'BB entry rate (avg at all times)'; save_title = 'comparisonCtrlMo_bbentryrate_fulavg'; legend_type = 'comparison_ctrl_mo';
    [Newbbentryrate_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2
    
    % BB exit rate comparison between control & MO
    parameter_1 = Newbbexitrate_avg_all_times_ctrl; parameter_2 = Newbbexitrate_avg_all_times_mo; bininterval = 0.5; XLabel = 'BB exit rate (BB min^{-1})'; Ylabel = 'BB exit rate (BB min^{-1})'; Plot_title = 'BB exit rate (avg at all times)'; save_title = 'comparisonCtrlMo_bbexitrate_fulavg'; legend_type = 'comparison_ctrl_mo';
    [Newbbexitrate_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Contour length comparison between control & MO
    parameter_1 = contourlength_avg_all_times_ctrl; parameter_2 = contourlength_avg_all_times_mo; bininterval = 2.5; XLabel = 'Contour length [\mum]'; Ylabel = 'Contour length [\mum]'; Plot_title = 'Contour length (avg at all times)'; save_title = 'comparisonCtrlMo_contourlength_fulavg'; legend_type = 'comparison_ctrl_mo';
    [contourlength_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % End-to-End length comparison between control & MO
    parameter_1 = endtoendlength_avg_all_times_ctrl; parameter_2 = endtoendlength_avg_all_times_mo; bininterval = 0.5; XLabel = 'End-to-End length [\mum]'; Ylabel = 'End-to-End length [\mum]'; Plot_title = 'End-to-End length (avg at all times)'; save_title = 'comparisonCtrlMo_endtoendlength_fulavg'; legend_type = 'comparison_ctrl_mo';
    [endtoendlength_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Tortuosity comparison between control & MO
    parameter_1 = tortuosity_avg_all_times_ctrl; parameter_2 = tortuosity_avg_all_times_mo; bininterval = 1.25; XLabel = 'Tortuosity'; Ylabel = 'Tortuosity'; Plot_title = 'Tortuosity (avg at all times)'; save_title = 'comparisonCtrlMo_tortuosity_fulavg'; legend_type = 'comparison_ctrl_mo';
    [tortuosity_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % BB step distance comparison between control & MO
    parameter_1 = bb_step_dist_avg_all_times_ctrl; parameter_2 = bb_step_dist_avg_all_times_mo; bininterval = 0.025; XLabel = 'BB step distance [\mum]'; Ylabel = 'BB step distance [\mum]'; Plot_title = 'BB step distance (avg at all times)'; save_title = 'comparisonCtrlMo_bbstepdist_fulavg'; legend_type = 'comparison_ctrl_mo';
    [bbStepDist_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % BB instantaneous speed comparison between control & MO
    parameter_1 = bb_inst_speed_avg_all_times_ctrl; parameter_2 = bb_inst_speed_avg_all_times_mo; bininterval = 0.025; XLabel = 'BB instantaneous speed [\mum s^{-1}]'; Ylabel = 'BB instantaneous speed [\mum s^{-1}]'; Plot_title = 'BB Instantaneous speed (avg at all times)'; save_title = 'comparisonCtrlMo_instspeed_fulavg'; legend_type = 'comparison_ctrl_mo';
    [bbInstSpeed_avgAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Drift slope comparison between control & MO
    [Drift_slope_ctrl_mo] = prepping_plotting_box_plots(Drift_slope_ctrl, Drift_slope_mo, 'Drift [\mum min^{-1}]', {'Average drift comparison', '(avg at all times)'}, 'comparisonCtrlMo_avg_drift_fulavg', BB_apical_avg, 'comparison_ctrl_mo');

    % Diff. Coeff. comparison between control & MO
    parameter_1 = Diff_Coeff_fit_min_ctrl; parameter_2 = Diff_Coeff_fit_min_mo; bininterval = 0.01; XLabel = 'Diffusion coefficient [\mum^2 min^{-1}]'; Ylabel = 'Diffusion coefficient [\mum^2 min^{-1}]'; Plot_title =  {'Diff. Coeff. from fitting (coarse grained)'}; save_title = 'comparisonCtrlMo_DiffCoef_fulavg'; legend_type = 'comparison_ctrl_mo';
    [DiffCoeff_fitMin_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Diff. Strength. comparison between control & MO
    parameter_1 = Diff_Strength_fit_ctrl; parameter_2 = Diff_Strength_fit_mo; bininterval = 0.00005; XLabel = 'Diffusion strength [\mum^2]'; Ylabel = 'Diffusion strength [\mum^2]'; Plot_title = {'Diff. strength from fitting (coarse grained)'}; save_title = 'comparisonCtrlMo_DiffStrength_fulavg'; legend_type = 'comparison_ctrl_mo';
    [DiffStrength_fitMin_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Alpha value comparison between control & MO
    parameter_1 = AlphaValue_ctrl; parameter_2 = AlphaValue_mo; bininterval = 0.1; XLabel = '\alpha value'; Ylabel = '\alpha value'; Plot_title = {'Alpha Value / Slope (coarse grained)'}; save_title = 'comparisonCtrlMo_alphavalue_fulavg'; legend_type = 'comparison_ctrl_mo';
    [AlphaValue_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2p

    %---------------------------Quad plots-----------------------------------%

    % Variance in quad apical area comparison between control & MO
    parameter_1 = quad_areaNorm_var_all_times_ctrl; parameter_2 = quad_areaNorm_var_all_times_mo; bininterval = 0.0001; XLabel = {'Variance of normalised Quadrant Area'}; Ylabel = {'Variance of normalised Quadrant Area'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant Area'}; save_title = 'comparisonCtrlMo_QuadArea_Var'; legend_type = 'comparison_ctrl_mo';
    [Quad_AreaNorm_varAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Variance in quad area rate comparison between control & MO
    parameter_1 = quad_AreaRateNorm_var_all_times_ctrl; parameter_2 = quad_AreaRateNorm_var_all_times_mo; bininterval =  0.0001; XLabel = {'Variance of normalised Quadrant expansion rate'}; Ylabel = {'Variance of normalised Quadrant expansion rate'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant Expansion rate'}; save_title = 'comparisonCtrlMo_QuadAreaRate_Var'; legend_type = 'comparison_ctrl_mo';
    [Quad_AreaRateNorm_varAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Variance in quad BB count comparison between control & MO
    parameter_1 = quad_BBcountNorm_var_all_times_ctrl; parameter_2 = quad_BBcountNorm_var_all_times_mo; bininterval =  0.0001; XLabel = {'Variance of normalised Quadrant BB count'}; Ylabel = {'Variance of normalised Quadrant BB count'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant BB count'}; save_title = 'comparisonCtrlMo_QuadBBcount_Var'; legend_type = 'comparison_ctrl_mo';
    [Quad_BBcountNorm_varAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Variance in quad BB density comparison between control & MO
    parameter_1 = quad_BBdensityNorm_var_all_times_ctrl; parameter_2 = quad_BBdensityNorm_var_all_times_mo; bininterval =  0.0001; XLabel = {'Variance of normalised Quadrant BB density'}; Ylabel = {'Variance of normalised Quadrant BB density'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant BB density'}; save_title = 'comparisonCtrlMo_QuadBBdensity_Var'; legend_type = 'comparison_ctrl_mo';
    [Quad_BBdensityNorm_varAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Variance in quad Actin MeanInt comparison between control & MO
    parameter_1 = quad_MeanIntnorm_var_all_times_ctrl; parameter_2 = quad_MeanIntnorm_var_all_times_mo; bininterval =  0.0001; XLabel = {'Variance of normalised Quadrant Mean Actin Intensity'}; Ylabel = {'Variance of normalised Quadrant Mean Actin Intensity'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant Mean Actin Intensity'}; save_title = 'comparisonCtrlMo_QuadMeanActinInt_Var'; legend_type = 'comparison_ctrl_mo';
    [Quad_MeanIntNorm_varAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Variance in quad Actin TotalInt comparison between control & MO
    parameter_1 = quad_TotalIntnorm_var_all_times_ctrl; parameter_2 = quad_TotalIntnorm_var_all_times_mo; bininterval =  0.0001; XLabel = {'Variance of normalised Quadrant Total Actin Intensity'}; Ylabel = {'Variance of normalised Quadrant Total Actin Intensity'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant Total Actin Intensity'}; save_title = 'comparisonCtrlMo_QuadTotalActinInt_Var'; legend_type = 'comparison_ctrl_mo';
    [Quad_TotalIntNorm_varAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2

    % Variance in quad New BB count comparison between control & MO
    parameter_1 = quad_newBBCountnorm_var_all_times_ctrl; parameter_2 = quad_newBBCountnorm_var_all_times_mo; bininterval =  0.0001; XLabel = {'Variance of normalised Quadrant New BB count'}; Ylabel = {'Variance of normalised Quadrant New BB count'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant New BB count'}; save_title = 'comparisonCtrlMo_QuadNewBBcount_Var'; legend_type = 'comparison_ctrl_mo';
    [Quad_NewBBcountNorm_varAllTimes_ctrl_mo] = prepping_plotting_box_plots(parameter_1, parameter_2, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % Box plot
    hist_plots_for_bins([], parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots([], parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2
end

%% Comparison between Ctrl & MO upto 140 µm2

% In this section we plot some of the parameters between control & MO - but only under 140 µm2 (defined as 'area_breakpoint' in this section). The reason is the following: The MO condition does not expand to the same extent as control - the control expands to 300 µm2 in 2.5 h. For the same time i.e 2.5 h, MO condition only expands to 140
% µm2. So the idea here is to compare, for all the parameters, only the data values that are under 140 µm2, between control & MO. In the section above, we compare all the parameters between control & MO, not based on Area but based on time. In other words, all the control data, upto 300
% µm2 is compared to all the MO data which is usually upto 150 µm2. So, one could say, that in the section above, the comparison is based on experimental time and not based on area. Whereas in this section, the comparison is strictly between the corresponding area ranges in control and MO.
% Here we perform the comparison only for those parameters for which we had to show the comparison between control and MO in the figures. More parameters can be added here (and then also to Excel sheet an montage) if needed.

area_breakpoint = 140; % 140 µm2 is the maximum area reached by the cells of MO condition in 2.5 h

% choosing the parameters based on the experiment type i.e condition - control / MO
if experiment_type == 1
    % obtaining the Ctrl data for all distances
    new_new_allDist_XData_area_ctrl = new_new_allDist_XData_area; new_new_allDist_YData_area_ctrl = new_new_allDist_YData_area; % All BB appearance distances (new BB in current & new BB in previous frame)
    NewNewBBappearancedist_XData_area_ctrl = NewNewBBappearancedist_XData_area; NewNewBBappearancedist_YData_area_ctrl = NewNewBBappearancedist_YData_area; % Minimal distance between new BB in current frame & new BB in previous frame
    new_existing_allDist_XData_area_ctrl = new_existing_allDist_XData_area; new_existing_allDist_YData_area_ctrl = new_existing_allDist_YData_area; % All distances between new BB and the already existing BBs in the same frame
    NewExistingBBappearancedist_XData_area_ctrl = NewExistingBBappearancedist_XData_area; NewExistingBBappearancedist_YData_area_ctrl = NewExistingBBappearancedist_YData_area; % Minimal distance between new BB and the already existing BBs in the same frame
    Existing_allDist_XData_area_ctrl = Existing_allDist_XData_area; Existing_allDist_YData_area_ctrl = Existing_allDist_YData_area; % Inter BB distance (All distances between every BB and all other BBs in the same frame)
    NearNeighbdist_XData_area_ctrl = NearNeighbdist_XData_area; NearNeighbdist_YData_area_ctrl = NearNeighbdist_YData_area; % Nearest neighbor BB distance (Minimal distance between every BB and all other BBs in the same frame)
    AvgNewNewBBAllDist_XData_area_ctrl = AvgNewNewBBAllDist_XData_area; AvgNewNewBBAllDist_YData_area_ctrl = AvgNewNewBBAllDist_YData_area; % All BB appearance distances, averaged per frame, (new BB in current & new BB in previous frame)
    AvgNewNewBBMinDist_XData_area_ctrl = AvgNewNewBBMinDist_XData_area; AvgNewNewBBMinDist_YData_area_ctrl = AvgNewNewBBMinDist_YData_area; % Minimal distance, averaged per frame, between new BB in current frame & new BB in previous frame
    AvgNewExistBBAllDist_XData_area_ctrl = AvgNewExistBBAllDist_XData_area; AvgNewExistBBAllDist_YData_area_ctrl = AvgNewExistBBAllDist_YData_area; % All distances, averaged per frame, between new BB and the already existing BBs in the same frame
    AvgNewExistBBMinDist_XData_area_ctrl = AvgNewExistBBMinDist_XData_area; AvgNewExistBBMinDist_YData_area_ctrl = AvgNewExistBBMinDist_YData_area; % Minimal distance, averaged per frame, between new BB and the already existing BBs in the same frame
    AvgExistBBAllDist_XData_area_ctrl = AvgExistBBAllDist_XData_area; AvgExistBBAllDist_YData_area_ctrl = AvgExistBBAllDist_YData_area; % Inter BB distance, averaged per frame, (All distances between every BB and all other BBs in the same frame)
    AvgNearNeighbourBBMinDist_XData_area_ctrl = AvgNearNeighbourBBMinDist_XData_area; AvgNearNeighbourBBMinDist_YData_area_ctrl = AvgNearNeighbourBBMinDist_YData_area; % Nearest neighbor BB distance, averaged per frame, (Minimal distance between every BB and all other BBs in the same frame)
    lnVarianceTessalation_XData_area_ctrl = lnVarianceTessalation_XData_area; lnVarianceTessalation_YData_area_ctrl = lnVarianceTessalation_YData_area; % Log of variance in tessalation areas
    VarianceTessalation_XData_area_ctrl = VarianceTessalation_XData_area; VarianceTessalation_YData_area_ctrl = VarianceTessalation_YData_area; % Variance in tessalation areas
    local_clustering_XData_area_ctrl = local_clustering_XData_area; local_clustering_YData_area_ctrl = local_clustering_YData_area; % Local clustering index
    global_clustering_XData_area_ctrl = global_clustering_XData_area; global_clustering_YData_area_ctrl = global_clustering_YData_area; % Global clustering index
    clumpingfactor_area_XData_area_ctrl = clumpingfactor_area_XData_area; clumpingfactor_area_YData_area_ctrl = clumpingfactor_area_YData_area; % clumping factor (Area)
    clumpingfactor_arearate_XData_area_ctrl = clumpingfactor_arearate_XData_area; clumpingfactor_arearate_YData_area_ctrl = clumpingfactor_arearate_YData_area; % clumping factor (Area rate)
    clumpingfactor_bbcount_XData_area_ctrl = clumpingfactor_bbcount_XData_area; clumpingfactor_bbcount_YData_area_ctrl = clumpingfactor_bbcount_YData_area; % clumping factor (BB count)
    clumpingfactor_bbdensity_XData_area_ctrl = clumpingfactor_bbdensity_XData_area; clumpingfactor_bbdensity_YData_area_ctrl = clumpingfactor_bbdensity_YData_area; % clumping factor (BB density)
    clumpingfactor_meanint_XData_area_ctrl = clumpingfactor_meanint_XData_area; clumpingfactor_meanint_YData_area_ctrl = clumpingfactor_meanint_YData_area; % clumping factor (Mean Int)
    clumpingfactor_totalint_XData_area_ctrl = clumpingfactor_totalint_XData_area; clumpingfactor_totalint_YData_area_ctrl = clumpingfactor_totalint_YData_area; % clumping factor (Total Int)
    clumpingfactor_newbbcount_XData_area_ctrl = clumpingfactor_newbbcount_XData_area; clumpingfactor_newbbcount_YData_area_ctrl = clumpingfactor_newbbcount_YData_area; % clumping factor (New BB count)
    quad_areaNorm_XData_area_ctrl = quad_areaNorm_XData_area; quad_areaNorm_YData_area_var_ctrl = quad_areaNorm_YData_area_var; quad_BBcountNorm_XData_area_ctrl = quad_BBcountNorm_XData_area; quad_BBcountNorm_YData_area_var_ctrl = quad_BBcountNorm_YData_area_var; quad_AreaRateNorm_XData_area_ctrl = quad_AreaRateNorm_XData_area; quad_AreaRateNorm_YData_area_var_ctrl = quad_AreaRateNorm_YData_area_var;
    quad_BBdensityNorm_XData_area_ctrl = quad_BBdensityNorm_XData_area; quad_BBdensityNorm_YData_area_var_ctrl = quad_BBdensityNorm_YData_area_var; quad_MeanIntnorm_XData_area_ctrl = quad_MeanIntnorm_XData_area; quad_MeanIntnorm_YData_area_var_ctrl = quad_MeanIntnorm_YData_area_var; quad_TotalIntnorm_XData_area_ctrl = quad_TotalIntnorm_XData_area; quad_TotalIntnorm_YData_area_var_ctrl = quad_TotalIntnorm_YData_area_var; quad_newBBCountnorm_XData_area_ctrl = quad_newBBCountnorm_XData_area; quad_newBBCountnorm_YData_area_var_ctrl = quad_newBBCountnorm_YData_area_var;

else
    % obtaining the Mo data for all distances
    new_new_allDist_XData_area_MO = new_new_allDist_XData_area; new_new_allDist_YData_area_MO = new_new_allDist_YData_area; % All BB appearance distances (new BB in current & new BB in previous frame)
    NewNewBBappearancedist_XData_area_MO = NewNewBBappearancedist_XData_area; NewNewBBappearancedist_YData_area_MO = NewNewBBappearancedist_YData_area; % Minimal distance between new BB in current frame & new BB in previous frame
    new_existing_allDist_XData_area_MO = new_existing_allDist_XData_area; new_existing_allDist_YData_area_MO = new_existing_allDist_YData_area; % All distances between new BB and the already existing BBs in the same frame
    NewExistingBBappearancedist_XData_area_MO = NewExistingBBappearancedist_XData_area; NewExistingBBappearancedist_YData_area_MO = NewExistingBBappearancedist_YData_area; % Minimal distance between new BB and the already existing BBs in the same frame
    Existing_allDist_XData_area_MO = Existing_allDist_XData_area; Existing_allDist_YData_area_MO = Existing_allDist_YData_area; % Inter BB distance (All distances between every BB and all other BBs in the same frame)
    NearNeighbdist_XData_area_MO = NearNeighbdist_XData_area; NearNeighbdist_YData_area_MO = NearNeighbdist_YData_area; % Nearest neighbor BB distance (Minimal distance between every BB and all other BBs in the same frame)
    AvgNewNewBBAllDist_XData_area_MO = AvgNewNewBBAllDist_XData_area; AvgNewNewBBAllDist_YData_area_MO = AvgNewNewBBAllDist_YData_area; % All BB appearance distances, averaged per frame, (new BB in current & new BB in previous frame)
    AvgNewNewBBMinDist_XData_area_MO = AvgNewNewBBMinDist_XData_area; AvgNewNewBBMinDist_YData_area_MO = AvgNewNewBBMinDist_YData_area; % Minimal distance, averaged per frame, between new BB in current frame & new BB in previous frame
    AvgNewExistBBAllDist_XData_area_MO = AvgNewExistBBAllDist_XData_area; AvgNewExistBBAllDist_YData_area_MO = AvgNewExistBBAllDist_YData_area; % All distances, averaged per frame, between new BB and the already existing BBs in the same frame
    AvgNewExistBBMinDist_XData_area_MO = AvgNewExistBBMinDist_XData_area; AvgNewExistBBMinDist_YData_area_MO = AvgNewExistBBMinDist_YData_area; % Minimal distance, averaged per frame, between new BB and the already existing BBs in the same frame
    AvgExistBBAllDist_XData_area_MO = AvgExistBBAllDist_XData_area; AvgExistBBAllDist_YData_area_MO = AvgExistBBAllDist_YData_area; % Inter BB distance, averaged per frame, (All distances between every BB and all other BBs in the same frame)
    AvgNearNeighbourBBMinDist_XData_area_MO = AvgNearNeighbourBBMinDist_XData_area; AvgNearNeighbourBBMinDist_YData_area_MO = AvgNearNeighbourBBMinDist_YData_area; % Nearest neighbor BB distance, averaged per frame, (Minimal distance between every BB and all other BBs in the same frame)
    lnVarianceTessalation_XData_area_MO = lnVarianceTessalation_XData_area; lnVarianceTessalation_YData_area_MO = lnVarianceTessalation_YData_area; % Log of variance in tessalation areas
    VarianceTessalation_XData_area_MO = VarianceTessalation_XData_area; VarianceTessalation_YData_area_MO = VarianceTessalation_YData_area; % Variance in tessalation areas
    local_clustering_XData_area_MO = local_clustering_XData_area; local_clustering_YData_area_MO = local_clustering_YData_area; % Local clustering index
    global_clustering_XData_area_MO = global_clustering_XData_area; global_clustering_YData_area_MO = global_clustering_YData_area; % Global clustering index
    clumpingfactor_area_XData_area_MO = clumpingfactor_area_XData_area; clumpingfactor_area_YData_area_MO = clumpingfactor_area_YData_area; % clumping factor (Area)
    clumpingfactor_arearate_XData_area_MO = clumpingfactor_arearate_XData_area; clumpingfactor_arearate_YData_area_MO = clumpingfactor_arearate_YData_area; % clumping factor (Area rate)
    clumpingfactor_bbcount_XData_area_MO = clumpingfactor_bbcount_XData_area; clumpingfactor_bbcount_YData_area_MO = clumpingfactor_bbcount_YData_area; % clumping factor (BB count)
    clumpingfactor_bbdensity_XData_area_MO = clumpingfactor_bbdensity_XData_area; clumpingfactor_bbdensity_YData_area_MO = clumpingfactor_bbdensity_YData_area; % clumping factor (BB density)
    clumpingfactor_meanint_XData_area_MO = clumpingfactor_meanint_XData_area; clumpingfactor_meanint_YData_area_MO = clumpingfactor_meanint_YData_area; % clumping factor (Mean Int)
    clumpingfactor_totalint_XData_area_MO = clumpingfactor_totalint_XData_area; clumpingfactor_totalint_YData_area_MO = clumpingfactor_totalint_YData_area; % clumping factor (Total Int)
    clumpingfactor_newbbcount_XData_area_MO = clumpingfactor_newbbcount_XData_area; clumpingfactor_newbbcount_YData_area_MO = clumpingfactor_newbbcount_YData_area; % clumping factor (New BB count)
    quad_areaNorm_XData_area_MO = quad_areaNorm_XData_area; quad_areaNorm_YData_area_var_MO = quad_areaNorm_YData_area_var; quad_BBcountNorm_XData_area_MO = quad_BBcountNorm_XData_area; quad_BBcountNorm_YData_area_var_MO = quad_BBcountNorm_YData_area_var; quad_AreaRateNorm_XData_area_MO = quad_AreaRateNorm_XData_area; quad_AreaRateNorm_YData_area_var_MO = quad_AreaRateNorm_YData_area_var;
    quad_BBdensityNorm_XData_area_MO = quad_BBdensityNorm_XData_area; quad_BBdensityNorm_YData_area_var_MO = quad_BBdensityNorm_YData_area_var; quad_MeanIntnorm_XData_area_MO = quad_MeanIntnorm_XData_area; quad_MeanIntnorm_YData_area_var_MO = quad_MeanIntnorm_YData_area_var; quad_TotalIntnorm_XData_area_MO = quad_TotalIntnorm_XData_area; quad_TotalIntnorm_YData_area_var_MO = quad_TotalIntnorm_YData_area_var; quad_newBBCountnorm_XData_area_MO = quad_newBBCountnorm_XData_area; quad_newBBCountnorm_YData_area_var_MO = quad_newBBCountnorm_YData_area_var;

    % fetching the ctrl data from the control data workspace
    load(ctrl_workspace_link, 'new_new_allDist_XData_area_ctrl', 'new_new_allDist_YData_area_ctrl', 'NewNewBBappearancedist_XData_area_ctrl', 'NewNewBBappearancedist_YData_area_ctrl', 'new_existing_allDist_XData_area_ctrl', 'new_existing_allDist_YData_area_ctrl', 'NewExistingBBappearancedist_XData_area_ctrl', 'NewExistingBBappearancedist_YData_area_ctrl',...
        'Existing_allDist_XData_area_ctrl', 'Existing_allDist_YData_area_ctrl', 'NearNeighbdist_XData_area_ctrl', 'NearNeighbdist_YData_area_ctrl', 'AvgNewNewBBAllDist_XData_area_ctrl', 'AvgNewNewBBAllDist_YData_area_ctrl', 'AvgNewNewBBMinDist_XData_area_ctrl', 'AvgNewNewBBMinDist_YData_area_ctrl',...
        'AvgNewExistBBAllDist_XData_area_ctrl', 'AvgNewExistBBAllDist_YData_area_ctrl', 'AvgNewExistBBMinDist_XData_area_ctrl', 'AvgNewExistBBMinDist_YData_area_ctrl', 'AvgExistBBAllDist_XData_area_ctrl', 'AvgExistBBAllDist_YData_area_ctrl', 'AvgNearNeighbourBBMinDist_XData_area_ctrl', 'AvgNearNeighbourBBMinDist_YData_area_ctrl',...
        'lnVarianceTessalation_XData_area_ctrl', 'lnVarianceTessalation_YData_area_ctrl', 'VarianceTessalation_XData_area_ctrl', 'VarianceTessalation_YData_area_ctrl', 'local_clustering_XData_area_ctrl', 'local_clustering_YData_area_ctrl', 'global_clustering_XData_area_ctrl', 'global_clustering_YData_area_ctrl', 'clumpingfactor_area_XData_area_ctrl', 'clumpingfactor_area_YData_area_ctrl', 'clumpingfactor_arearate_XData_area_ctrl', 'clumpingfactor_arearate_YData_area_ctrl', 'clumpingfactor_bbcount_XData_area_ctrl', 'clumpingfactor_bbcount_YData_area_ctrl',...
        'clumpingfactor_bbdensity_XData_area_ctrl', 'clumpingfactor_bbdensity_YData_area_ctrl', 'clumpingfactor_meanint_XData_area_ctrl', 'clumpingfactor_meanint_YData_area_ctrl', 'clumpingfactor_totalint_XData_area_ctrl', 'clumpingfactor_totalint_YData_area_ctrl', 'clumpingfactor_newbbcount_XData_area_ctrl', 'clumpingfactor_newbbcount_YData_area_ctrl', 'quad_areaNorm_XData_area_ctrl', 'quad_areaNorm_YData_area_var_ctrl', 'quad_BBcountNorm_XData_area_ctrl', 'quad_BBcountNorm_YData_area_var_ctrl', 'quad_AreaRateNorm_XData_area_ctrl', 'quad_AreaRateNorm_YData_area_var_ctrl',...
        'quad_BBdensityNorm_XData_area_ctrl', 'quad_BBdensityNorm_YData_area_var_ctrl', 'quad_MeanIntnorm_XData_area_ctrl', 'quad_MeanIntnorm_YData_area_var_ctrl', 'quad_TotalIntnorm_XData_area_ctrl', 'quad_TotalIntnorm_YData_area_var_ctrl', 'quad_newBBCountnorm_XData_area_ctrl', 'quad_newBBCountnorm_YData_area_var_ctrl');

    % plotting the histograms for control & MO only upto to 140µm2 area

    % All BB appearance distances (new BB in current & new BB in previous frame)
    area_breakpoint_idx_ctrl = new_new_allDist_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = new_new_allDist_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_NewNewAlldist_mat_ctrl = new_new_allDist_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_NewNewAlldist_mat_MO = new_new_allDist_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_NewNewAlldist_mat_ctrl; parameter_2 = binXY_NewNewAlldist_mat_MO; bininterval = 0.5; XLabel = 'BB appearance distance [\mum]'; Plot_title = {'Distances of newly appearing BB,', '[between the current and previous frames]', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_NewNewAlldist'; legend_type = 'comparison_ctrl_mo';
    [binXY_NewNewAlldist_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Minimal distance between new BB in current frame & new BB in previous frame
    area_breakpoint_idx_ctrl = NewNewBBappearancedist_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = NewNewBBappearancedist_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_NewNewMindist_mat_ctrl = NewNewBBappearancedist_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_NewNewMindist_mat_MO = NewNewBBappearancedist_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_NewNewMindist_mat_ctrl; parameter_2 = binXY_NewNewMindist_mat_MO; bininterval = 0.5; XLabel = 'Minimum BB appearance distance [\mum]'; Plot_title = {'Minimum BB appearance distance', '[between the current and previous frames]', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_NewNewMindist'; legend_type = 'comparison_ctrl_mo';
    [binXY_NewNewMindist_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % All distances between new BB and the already existing BBs in the same frame
    area_breakpoint_idx_ctrl = new_existing_allDist_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = new_existing_allDist_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_NewExistAlldist_mat_ctrl = new_existing_allDist_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_NewExistAlldist_mat_MO = new_existing_allDist_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_NewExistAlldist_mat_ctrl; parameter_2 = binXY_NewExistAlldist_mat_MO; bininterval = 0.5; XLabel = 'BB appearance distance [\mum]'; Plot_title = {'Distances of all newly appearing BB,', 'to all already existing BBs in the same frame', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_NewExistAlldist'; legend_type = 'comparison_ctrl_mo';
    [binXY_NewExistAlldist_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Minimal distance between new BB and the already existing BBs in the same frame
    area_breakpoint_idx_ctrl = NewExistingBBappearancedist_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = NewExistingBBappearancedist_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_NewExistMindist_mat_ctrl = NewExistingBBappearancedist_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_NewExistMindist_mat_MO = NewExistingBBappearancedist_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_NewExistMindist_mat_ctrl; parameter_2 = binXY_NewExistMindist_mat_MO; bininterval = 0.05; XLabel = 'Minimum BB appearance distance [\mum]'; Plot_title = {'Minimum distance of a newly appearing BB,', 'to the closest, already existing BB in the same frame', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_NewExistMindist'; legend_type = 'comparison_ctrl_mo';
    [binXY_NewExistMindist_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Inter BB distance (All distances between every BB and all other BBs in the same frame)
    area_breakpoint_idx_ctrl = Existing_allDist_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = Existing_allDist_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_ExistingAlldist_mat_ctrl = Existing_allDist_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_ExistingAlldist_mat_MO = Existing_allDist_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_ExistingAlldist_mat_ctrl; parameter_2 = binXY_ExistingAlldist_mat_MO; bininterval = 0.5; XLabel = 'Distance between BBs [\mum]'; Plot_title = {'Distance between all BBs in every frame', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_ExistingAlldist'; legend_type = 'comparison_ctrl_mo';
    [binXY_ExistingAlldist_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Nearest neighbor BB distance (Minimal distance between every BB and all other BBs in the same frame)
    area_breakpoint_idx_ctrl = NearNeighbdist_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = NearNeighbdist_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_NearNeigbdist_mat_ctrl = NearNeighbdist_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_NearNeigbdist_mat_MO = NearNeighbdist_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_NearNeigbdist_mat_ctrl; parameter_2 = binXY_NearNeigbdist_mat_MO; bininterval = 0.075; XLabel = 'Nearest Neighbor distance [\mum]'; Plot_title = {'Nearest Neighbor distance of BBs', 'w.r.to all other BBs in every frame', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_NearNeigbdist'; legend_type = 'comparison_ctrl_mo';
    [binXY_NearNeigbdist_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    %-----------------------------------------------------------%

    % All BB appearance distances - averaged (per frame) - (new BB in current & new BB in previous frame)
    area_breakpoint_idx_ctrl = AvgNewNewBBAllDist_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = AvgNewNewBBAllDist_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_AvgNewNewBBAllDist_mat_ctrl = AvgNewNewBBAllDist_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_AvgNewNewBBAllDist_mat_MO = AvgNewNewBBAllDist_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_AvgNewNewBBAllDist_mat_ctrl; parameter_2 = binXY_AvgNewNewBBAllDist_mat_MO; bininterval = 0.5; XLabel = 'BB appearance distance [\mum]'; Plot_title = {'Distances, averaged per frame, of newly appearing BB,', '[between the current and previous frames]', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_NewNewAllAvgdist'; legend_type = 'comparison_ctrl_mo';
    [binXY_AvgNewNewBBAllDist_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Minimal distance - averaged (per frame) - between new BB in current frame & new BB in previous frame
    area_breakpoint_idx_ctrl = AvgNewNewBBMinDist_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = AvgNewNewBBMinDist_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_AvgNewNewBBMinDist_mat_ctrl = AvgNewNewBBMinDist_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_AvgNewNewBBMinDist_mat_MO = AvgNewNewBBMinDist_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_AvgNewNewBBMinDist_mat_ctrl; parameter_2 = binXY_AvgNewNewBBMinDist_mat_MO; bininterval = 0.5; XLabel = 'Minimum BB appearance distance [\mum]'; Plot_title = {'Minimum BB appearance distance, averaged per frame,', '[between the current and previous frames]', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_NewNewMinAvgdist'; legend_type = 'comparison_ctrl_mo';
    [binXY_AvgNewNewBBMinDist_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % All distances - averaged (per frame) - between new BB and the already existing BBs in the same frame
    area_breakpoint_idx_ctrl = AvgNewExistBBAllDist_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = AvgNewExistBBAllDist_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_AvgNewExistBBAllDist_mat_ctrl = AvgNewExistBBAllDist_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_AvgNewExistBBAllDist_mat_MO = AvgNewExistBBAllDist_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_AvgNewExistBBAllDist_mat_ctrl; parameter_2 = binXY_AvgNewExistBBAllDist_mat_MO; bininterval = 0.5; XLabel = 'BB appearance distance [\mum]'; Plot_title = {'Distances, averaged per frame, of all newly appearing BB,', 'to all already existing BBs in the same frame', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_NewExistAllAvgdist'; legend_type = 'comparison_ctrl_mo';
    [binXY_AvgNewExistBBAllDist_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Minimal distance - averaged (per frame) - between new BB and the already existing BBs in the same frame
    area_breakpoint_idx_ctrl = AvgNewExistBBMinDist_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = AvgNewExistBBMinDist_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_AvgNewExistBBMinDist_mat_ctrl = AvgNewExistBBMinDist_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_AvgNewExistBBMinDist_mat_MO = AvgNewExistBBMinDist_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_AvgNewExistBBMinDist_mat_ctrl; parameter_2 = binXY_AvgNewExistBBMinDist_mat_MO; bininterval = 0.05; XLabel = 'Minimum BB appearance distance [\mum]'; Plot_title = {'Minimum distance, averaged per frame, of a newly appearing BB,', 'to the closest, already existing BB in the same frame', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_NewExistMinAvgdist'; legend_type = 'comparison_ctrl_mo';
    [binXY_AvgNewExistBBMinDist_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Inter BB distance - averaged (per frame) - (All distances between every BB and all other BBs in the same frame)
    area_breakpoint_idx_ctrl = AvgExistBBAllDist_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = AvgExistBBAllDist_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_AvgExistBBAllDist_mat_ctrl = AvgExistBBAllDist_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_AvgExistBBAllDist_mat_MO = AvgExistBBAllDist_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_AvgExistBBAllDist_mat_ctrl; parameter_2 = binXY_AvgExistBBAllDist_mat_MO; bininterval = 0.5; XLabel = 'Distance between BBs [\mum]'; Plot_title = {'Distance, averaged per frame, between all BBs in every frame', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_ExistingAllAvgdist'; legend_type = 'comparison_ctrl_mo';
    [binXY_AvgExistBBAllDist_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Nearest neighbor BB distance - averaged (per frame) -  (Minimal distance between every BB and all other BBs in the same frame)
    area_breakpoint_idx_ctrl = AvgNearNeighbourBBMinDist_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = AvgNearNeighbourBBMinDist_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_AvgNearNeighbourBBMinDist_mat_ctrl = AvgNearNeighbourBBMinDist_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_AvgNearNeighbourBBMinDist_mat_MO = AvgNearNeighbourBBMinDist_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_AvgNearNeighbourBBMinDist_mat_ctrl; parameter_2 = binXY_AvgNearNeighbourBBMinDist_mat_MO; bininterval = 0.075; XLabel = 'Nearest Neighbor distance [\mum]'; Plot_title = {'Nearest Neighbor distance, averaged per frame, of BBs', 'w.r.to all other BBs in every frame', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_NearNeigbAvgdist'; legend_type = 'comparison_ctrl_mo';
    [binXY_AvgNearNeighbourBBMinDist_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    %-----------------------------------------------------------%

    % Log of variance in tessalation areas
    area_breakpoint_idx_ctrl = lnVarianceTessalation_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = lnVarianceTessalation_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_lnVariance_mat_ctrl = lnVarianceTessalation_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_lnVariance_mat_MO = lnVarianceTessalation_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_lnVariance_mat_ctrl; parameter_2 = binXY_lnVariance_mat_MO; bininterval = 0.05; XLabel = {'Log of Variance in tessalation areas', '(Min-Max normalised)'}; Plot_title = {'Log of Variance in tessalation', 'area (avg at all times)', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_lnVariance'; legend_type = 'comparison_ctrl_mo';
    [binXY_lnVariance_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Variance in tessalation areas
    area_breakpoint_idx_ctrl = VarianceTessalation_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = VarianceTessalation_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_Variance_mat_ctrl = VarianceTessalation_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_Variance_mat_MO = VarianceTessalation_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_Variance_mat_ctrl; parameter_2 = binXY_Variance_mat_MO; bininterval = 0.05; XLabel = {'Variance in tessalation areas', '(normalised by MeanArea squared)'}; Plot_title = {'Variance in tessalation', 'area (avg at all times)', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_Variance'; legend_type = 'comparison_ctrl_mo';
    [binXY_Variance_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Local clustering index
    area_breakpoint_idx_ctrl = local_clustering_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = local_clustering_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_localClustering_mat_ctrl = local_clustering_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_localClustering_mat_MO = local_clustering_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_localClustering_mat_ctrl; parameter_2 = binXY_localClustering_mat_MO; bininterval = 0.01; XLabel = 'Local clustering index'; Plot_title = {'Local clustering index (avg at all times)', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_localClustering'; legend_type = 'comparison_ctrl_mo';
    [binXY_localClustering_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Global clustering index
    area_breakpoint_idx_ctrl = global_clustering_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = global_clustering_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_globalClustering_mat_ctrl = global_clustering_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_globalClustering_area_mat_MO = global_clustering_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_globalClustering_mat_ctrl; parameter_2 = binXY_globalClustering_area_mat_MO; bininterval = 0.01; XLabel = 'Global clustering index'; Plot_title = {'Global clustering index (avg at all times)', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_globalClustering'; legend_type = 'comparison_ctrl_mo';
    [binXY_globalClustering_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

   % Clumping factor (Area)
    area_breakpoint_idx_ctrl = clumpingfactor_area_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = clumpingfactor_area_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_clumpingfactor_area_mat_ctrl = clumpingfactor_area_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_clumpingfactor_area_mat_MO = clumpingfactor_area_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_clumpingfactor_area_mat_ctrl; parameter_2 = binXY_clumpingfactor_area_mat_MO; bininterval = 0.005; XLabel = 'Clumping factor (Area)'; Plot_title = {'Clumping factor (Area) (avg at all times)', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_Clumpingfac_area'; legend_type = 'comparison_ctrl_mo';
    [binXY_clumpingfactor_area_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Clumping factor (Area rate)
    area_breakpoint_idx_ctrl = clumpingfactor_arearate_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = clumpingfactor_arearate_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_clumpingfactor_arearate_mat_ctrl = clumpingfactor_arearate_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_clumpingfactor_arearate_mat_MO = clumpingfactor_arearate_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_clumpingfactor_arearate_mat_ctrl; parameter_2 = binXY_clumpingfactor_arearate_mat_MO; bininterval = 0.05; XLabel = 'Clumping factor (Area rate)'; Plot_title = {'Clumping factor (Area rate) (avg at all times)', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_Clumpingfac_arearate'; legend_type = 'comparison_ctrl_mo';
    [binXY_clumpingfactor_arearate_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Clumping factor (BB count)
    area_breakpoint_idx_ctrl = clumpingfactor_bbcount_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = clumpingfactor_bbcount_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_clumpingfactor_bbcount_mat_ctrl = clumpingfactor_bbcount_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_clumpingfactor_bbcount_mat_MO = clumpingfactor_bbcount_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_clumpingfactor_bbcount_mat_ctrl; parameter_2 = binXY_clumpingfactor_bbcount_mat_MO; bininterval = 0.01; XLabel = 'Clumping factor (BB count)'; Plot_title = {'Clumping factor (BB count) (avg at all times)', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_Clumpingfac_bbcount'; legend_type = 'comparison_ctrl_mo';
    [binXY_clumpingfactor_bbcount_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Clumping factor (BB density)
    area_breakpoint_idx_ctrl = clumpingfactor_bbdensity_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = clumpingfactor_bbdensity_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_clumpingfactor_bbdensity_mat_ctrl = clumpingfactor_bbdensity_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_clumpingfactor_bbdensity_mat_MO = clumpingfactor_bbdensity_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_clumpingfactor_bbdensity_mat_ctrl; parameter_2 = binXY_clumpingfactor_bbdensity_mat_MO; bininterval = 0.01; XLabel = 'Clumping factor (BB density)'; Plot_title = {'Clumping factor (BB density) (avg at all times)', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_Clumpingfac_BBdensity'; legend_type = 'comparison_ctrl_mo';
    [binXY_clumpingfactor_bbdensity_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Clumping factor (Mean Int)
    area_breakpoint_idx_ctrl = clumpingfactor_meanint_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = clumpingfactor_meanint_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_clumpingfactor_meanint_mat_ctrl = clumpingfactor_meanint_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_clumpingfactor_meanint_mat_MO = clumpingfactor_meanint_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_clumpingfactor_meanint_mat_ctrl; parameter_2 = binXY_clumpingfactor_meanint_mat_MO; bininterval = 0.001; XLabel = 'Clumping factor (Mean Int)'; Plot_title = {'Clumping factor (Mean Int) (avg at all times)', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_Clumpingfac_meanint'; legend_type = 'comparison_ctrl_mo';
    [binXY_clumpingfactor_meanint_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Clumping factor (Total Int)
    area_breakpoint_idx_ctrl = clumpingfactor_totalint_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = clumpingfactor_totalint_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_clumpingfactor_totalint_mat_ctrl = clumpingfactor_totalint_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_clumpingfactor_totalint_mat_MO = clumpingfactor_totalint_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_clumpingfactor_totalint_mat_ctrl; parameter_2 = binXY_clumpingfactor_totalint_mat_MO; bininterval = 0.005; XLabel = 'Clumping factor (Total Int)'; Plot_title = {'Clumping factor (Total Int) (avg at all times)', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_Clumpingfac_totalint'; legend_type = 'comparison_ctrl_mo';
    [binXY_clumpingfactor_totalint_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Clumping factor (New BB count)
    area_breakpoint_idx_ctrl = clumpingfactor_newbbcount_XData_area_ctrl <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = clumpingfactor_newbbcount_XData_area_MO <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_clumpingfactor_newbbcount_mat_ctrl = clumpingfactor_newbbcount_YData_area_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_clumpingfactor_newbbcount_mat_MO = clumpingfactor_newbbcount_YData_area_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_clumpingfactor_newbbcount_mat_ctrl; parameter_2 = binXY_clumpingfactor_newbbcount_mat_MO; bininterval = 0.1; XLabel = 'Clumping factor (New BB count)'; Plot_title = {'Clumping factor (New BB count) (avg at all times)', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_Clumpingfac_newbbcount'; legend_type = 'comparison_ctrl_mo';
    [binXY_clumpingfactor_newbbcount_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    %-----------------------------------------------------------%
    % Quad plots

    % Quad area (Variance across quadrants)
    area_breakpoint_idx_ctrl = quad_areaNorm_XData_area_ctrl(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = quad_areaNorm_XData_area_MO(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_QuadAreaNorm_mat_ctrl = quad_areaNorm_YData_area_var_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_QuadAreaNorm_mat_MO = quad_areaNorm_YData_area_var_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_QuadAreaNorm_mat_ctrl; parameter_2 = binXY_QuadAreaNorm_mat_MO; bininterval = 0.0001; XLabel = {'Variance of normalised Quadrant Area'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant Area', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_QuadAreaNormVar'; legend_type = 'comparison_ctrl_mo';
    [binXY_QuadAreaNormVar_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Quad area rate (Variance across quadrants)
    area_breakpoint_idx_ctrl = quad_AreaRateNorm_XData_area_ctrl(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = quad_AreaRateNorm_XData_area_MO(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_QuadAreaRate_mat_ctrl = quad_AreaRateNorm_YData_area_var_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_QuadAreaRate_mat_MO = quad_AreaRateNorm_YData_area_var_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_QuadAreaRate_mat_ctrl; parameter_2 = binXY_QuadAreaRate_mat_MO; bininterval = 0.0001; XLabel = {'Variance of normalised Quadrant expansion rate'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant Expansion rate', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_QuadAreaRateNormVar'; legend_type = 'comparison_ctrl_mo';
    [binXY_QuadAreaRateVar_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Quad BB count (Variance across quadrants)
    area_breakpoint_idx_ctrl = quad_BBcountNorm_XData_area_ctrl(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = quad_BBcountNorm_XData_area_MO(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_BBcountNorm_mat_ctrl = quad_BBcountNorm_YData_area_var_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_BBcountNorm_mat_MO = quad_BBcountNorm_YData_area_var_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_BBcountNorm_mat_ctrl; parameter_2 = binXY_BBcountNorm_mat_MO; bininterval = 0.0001; XLabel = {'Variance of normalised Quadrant BB count'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant BB count', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_QuadBBcountNormVar'; legend_type = 'comparison_ctrl_mo';
    [binXY_QuadBBcountNormVar_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Quad BB density (Variance across quadrants)
    area_breakpoint_idx_ctrl = quad_BBdensityNorm_XData_area_ctrl(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = quad_BBdensityNorm_XData_area_MO(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_BBdensityNorm_mat_ctrl = quad_BBdensityNorm_YData_area_var_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_BBdensityNorm_mat_MO = quad_BBdensityNorm_YData_area_var_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_BBdensityNorm_mat_ctrl; parameter_2 = binXY_BBdensityNorm_mat_MO; bininterval = 0.0001; XLabel = {'Variance of normalised Quadrant BB density'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant BB density', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_QuadBBdensityNormVar'; legend_type = 'comparison_ctrl_mo';
    [binXY_QuadBBdensityNormVar_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Quad Actin Mean Int. (Variance across quadrants)
    area_breakpoint_idx_ctrl = quad_MeanIntnorm_XData_area_ctrl(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = quad_MeanIntnorm_XData_area_MO(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_MeanIntNorm_mat_ctrl = quad_MeanIntnorm_YData_area_var_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_MeanIntNorm_mat_MO = quad_MeanIntnorm_YData_area_var_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_MeanIntNorm_mat_ctrl; parameter_2 = binXY_MeanIntNorm_mat_MO; bininterval = 0.0001; XLabel = {'Variance of normalised Quadrant Mean Actin Intensity'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant Mean Actin Intensity', 'for every time point (normalised)', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_QuadMeanIntNormVar'; legend_type = 'comparison_ctrl_mo';
    [binXY_QuadMeanIntNormVar_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Quad Actin Total Int. (Variance across quadrants)
    area_breakpoint_idx_ctrl = quad_TotalIntnorm_XData_area_ctrl(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = quad_TotalIntnorm_XData_area_MO(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_TotalIntNorm_mat_ctrl = quad_TotalIntnorm_YData_area_var_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_TotalIntNorm_mat_MO = quad_TotalIntnorm_YData_area_var_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_TotalIntNorm_mat_ctrl; parameter_2 = binXY_TotalIntNorm_mat_MO; bininterval = 0.0001; XLabel = {'Variance of normalised Quadrant Total Actin Intensity'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant Total Actin Intensity', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_QuadTotalIntNormVar'; legend_type = 'comparison_ctrl_mo';
    [binXY_QuadTotalIntNormVar_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

    % Quad New BB count Norm (Variance across quadrants)
    area_breakpoint_idx_ctrl = quad_newBBCountnorm_XData_area_ctrl(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the control data
    area_breakpoint_idx_MO = quad_newBBCountnorm_XData_area_MO(:,1) <= area_breakpoint; % getting all the indices below the area_breakpoint value for the MO data
    binXY_newBBCountnorm_mat_ctrl = quad_newBBCountnorm_YData_area_var_ctrl(area_breakpoint_idx_ctrl); % getting YData parameter values based on the indices obtained above for control data
    binXY_newBBCountnorm_mat_MO = quad_newBBCountnorm_YData_area_var_MO(area_breakpoint_idx_MO); % getting YData parameter values based on the indices obtained above for MO data
    parameter_1 = binXY_newBBCountnorm_mat_ctrl; parameter_2 = binXY_newBBCountnorm_mat_MO; bininterval = 0.0001; XLabel = {'Variance of normalised Quadrant New BB count'}; Plot_title = {'Variance (across 4 quadrants)', 'of normalised Quadrant New BB count', '(comparison between ctrl & MO - upto 140µm2)'}; save_title = 'compareCtrlMo_Upto140um2_QuadNewBBCountNormVar'; legend_type = 'comparison_ctrl_mo';
    [binXY_QuadnewBBCountnormVar_AreaUpto140um2] = hist_plots_for_bins(area_breakpoint, parameter_1, parameter_2, bininterval, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % PDF plot
    cdf_distr_plots(area_breakpoint, parameter_1, parameter_2, XLabel, Plot_title, save_title, BB_apical_avg, legend_type); % CDF plot
    clear parameter_1 parameter_2 area_breakpoint_idx_ctrl area_breakpoint_idx_MO

end

%% Saving the excel sheets

cd(main_folder_link);

% saving all the arrays for which statistical tests need to be done as an excel .xlsx file where each array is a sheet
% choosing the excel name based on the type (Ctrl / MO) of experiment i.e. 'experiment_type'
if experiment_type == 1
    excel_filename = 'workspaceArrays_inExcel_for_statistics_Ctrl.xlsx';
else
    excel_filename = 'workspaceArrays_inExcel_for_statistics_MO.xlsx';
end
delete(strcat(excel_filename)); % deleting the excel file in case it exists; Because, if the excel file exists and we write a new file, it may not completely overwrite but add to what is existing; So for safer side, we delete the already existing file.

% getting all the arrays names for which statistical tests needs to be done
array_names_for_saving_in_excel(1,:) = {'meanint_atBBpos_1stframe_maxarea', 'totalint_atBBpos_1stframe_maxarea', 'meanint_atBBsurr_1stframe_maxarea', 'totalint_atBBsurr_1stframe_maxarea', 'meanint_atBBsurPos_1stframe_maxarea', 'totalint_atBBsurPos_1stframe_maxarea',...
    'Quad_Area_max_apical_area_norm', 'Quad_arearate_max_apical_area_norm', 'Quad_BBcount_max_apical_area_norm', 'Quad_BBdensity_at_max_apical_area_norm', 'Quad_actinMeanIntnorm_at_max_apical_area', 'Quad_actinTotalIntnorm_at_max_apical_area', 'Quad_NewBB_cumulative_count',...
    'quad_areaNorm_YData_area', 'quad_AreaRateNorm_YData_area', 'quad_BBcountNorm_YData_area', 'quad_BBdensityNorm_YData_area', 'quad_MeanIntnorm_YData_area', 'quad_TotalIntnorm_YData_area', 'quad_newBBCountnorm_YData_area',...
    'quad_areaNorm_YData_area_avg', 'quad_AreaRateNorm_YData_area_avg', 'quad_BBcountNorm_YData_area_avg', 'quad_BBdensityNorm_YData_area_avg', 'quad_MeanIntnorm_YData_area_avg', 'quad_TotalIntnorm_YData_area_avg', 'quad_newBBCountnorm_YData_area_avg',...
    'Quad_AreaNorm_varAllTimes_ctrl_mo', 'Quad_AreaRateNorm_varAllTimes_ctrl_mo', 'Quad_BBcountNorm_varAllTimes_ctrl_mo', 'Quad_BBdensityNorm_varAllTimes_ctrl_mo', 'Quad_MeanIntNorm_varAllTimes_ctrl_mo', 'Quad_TotalIntNorm_varAllTimes_ctrl_mo', 'Quad_NewBBcountNorm_varAllTimes_ctrl_mo',...
    'apical_area_at_MaxArea_ctrl_mo', 'BBcount_at_MaxArea_ctrl_mo', 'BBdensitynorm_at_MaxArea_ctrl_mo', 'BBmeanInterdistance_at_MaxArea_ctrl_mo', 'Local_Clustering_at_MaxArea_ctrl_mo', 'Global_Clustering_at_MaxArea_ctrl_mo', 'VarianceVoronoi_at_MaxArea_ctrl_mo', 'ln_VarianceVoronoi_at_MaxArea_ctrl_mo', 'NeighborMinDist_at_MaxArea_ctrl_mo', 'allInterDist_at_MaxArea_ctrl_mo', 'meanIntWholeArea_at_MaxArea_ctrl_mo',...
    'totalIntWholeArea_at_MaxArea_ctrl_mo', 'ClumpingFactor_Area_max_apical_area_ctrl_mo', 'ClumpingFactor_AreaRate_max_apical_area_ctrl_mo', 'ClumpingFactor_BBCount_max_apical_area_ctrl_mo', 'clumpingFactor_BBDensity_at_MaxArea_ctrl_mo', 'ClumpingFactor_MeanInt_max_apical_area_ctrl_mo', 'ClumpingFactor_TotalInt_max_apical_area_ctrl_mo', 'ClumpingFactor_NewBBCount_max_apical_area_ctrl_mo', 'isotropicity_at_MaxArea_ctrl_mo', 'circularity_at_MaxArea_ctrl_mo',...
    'apicalArea_avgAllTimes_ctrl_mo', 'wholeAreaRate_avgAllTimes_ctrl_mo', 'bbcount_avgAllTimes_ctrl_mo', 'bbdensity_avgAllTimes_ctrl_mo', 'bbMeanInterdistance_avgAllTimes_ctrl_mo', 'Local_Clustering_avgAllTimes_ctrl_mo', 'Global_Clustering_avgAllTimes_ctrl_mo', 'VarianceVoronoi_avgAllTimes_ctrl_mo', 'ln_VarianceVoronoi_avgAllTimes_ctrl_mo', 'MeanIntWholearea_avgAllTimes_ctrl_mo', 'TotalIntWholearea_avgAllTimes_ctrl_mo'...
    'distBtwNewBB_avgAllTimes_ctrl_mo', 'distAllBtwNewBB_avgAllTimes_ctrl_mo', 'distBtwNewExistingBB_avgAllTimes_ctrl_mo', 'distAllBtwNewExistingBB_avgAllTimes_ctrl_mo', 'NeighborMinDist_avgAllTimes_ctrl_mo', 'AllDist_avgAllTimes_ctrl_mo', 'meanIntatBBpos_1stframe_ctrl_mo', 'meanIntatBBpos_maxapicalarea_ctrl_mo',...
    'AvgdistBtwNewBB_avgAllTimes_ctrl_mo', 'AvgdistAllBtwNewBB_avgAllTimes_ctrl_mo', 'AvgdistBtwNewExistingBB_avgAllTimes_ctrl_mo', 'AvgdistAllBtwNewExistingBB_avgAllTimes_ctrl_mo', 'AvgNeighborMinDist_avgAllTimes_ctrl_mo', 'AvgAllDist_avgAllTimes_ctrl_mo',...
    'totalIntatBBpos_1stframe_ctrl_mo', 'totalIntatBBpos_maxapicalarea_ctrl_mo', 'meanIntatBBsurr_1stframe_ctrl_mo', 'meanIntatBBsurr_maxapicalarea_ctrl_mo', 'totalIntatBBsurr_1stframe_ctrl_mo', 'totalIntatBBsurr_maxapicalarea_ctrl_mo', 'meanIntRatioBBsurPos_1stframe_ctrl_mo', 'meanIntRatioBBsurPos_maxapicalarea_ctrl_mo',...
    'totalIntRatioBBsurPos_1stframe_ctrl_mo', 'totalIntRatioBBsurPos_maxapicalarea_ctrl_mo', 'clumpingfactor_area_avgAllTimes_ctrl_mo', 'clumpingfactor_arearate_avgAllTimes_ctrl_mo', 'clumpingfactor_bbcount_avgAllTimes_ctrl_mo', 'clumpingfactor_bbdensity_avgAllTimes_ctrl_mo', 'clumpingfactor_meanint_avgAllTimes_ctrl_mo', 'clumpingfactor_totalint_avgAllTimes_ctrl_mo', 'clumpingfactor_newbbcount_avgAllTimes_ctrl_mo',...
    'isotropicity_avgAllTimes_ctrl_mo', 'circularity_avgAllTimes_ctrl_mo', 'Newbbentrycount_avgAllTimes_ctrl_mo', 'Newbbexitcount_avgAllTimes_ctrl_mo', 'Newbbentryrate_avgAllTimes_ctrl_mo', 'Newbbexitrate_avgAllTimes_ctrl_mo', 'contourlength_avgAllTimes_ctrl_mo', 'endtoendlength_avgAllTimes_ctrl_mo', 'tortuosity_avgAllTimes_ctrl_mo',...
    'bbStepDist_avgAllTimes_ctrl_mo', 'bbInstSpeed_avgAllTimes_ctrl_mo', 'Drift_slope_ctrl_mo', 'DiffCoeff_fitMin_ctrl_mo', 'DiffStrength_fitMin_ctrl_mo', 'AlphaValue_ctrl_mo',...
    'binXY_NewNewAlldist_AreaUpto140um2', 'binXY_NewNewMindist_AreaUpto140um2', 'binXY_NewExistAlldist_AreaUpto140um2', 'binXY_NewExistMindist_AreaUpto140um2', 'binXY_ExistingAlldist_AreaUpto140um2', 'binXY_NearNeigbdist_AreaUpto140um2', 'binXY_lnVariance_AreaUpto140um2', 'binXY_Variance_AreaUpto140um2', 'binXY_localClustering_AreaUpto140um2', 'binXY_globalClustering_AreaUpto140um2',...
    'binXY_clumpingfactor_area_AreaUpto140um2', 'binXY_clumpingfactor_arearate_AreaUpto140um2', 'binXY_clumpingfactor_bbcount_AreaUpto140um2', 'binXY_clumpingfactor_bbdensity_AreaUpto140um2', 'binXY_clumpingfactor_meanint_AreaUpto140um2', 'binXY_clumpingfactor_totalint_AreaUpto140um2', 'binXY_clumpingfactor_newbbcount_AreaUpto140um2',...
    'binXY_AvgNewNewBBAllDist_AreaUpto140um2', 'binXY_AvgNewNewBBMinDist_AreaUpto140um2', 'binXY_AvgNewExistBBAllDist_AreaUpto140um2', 'binXY_AvgNewExistBBMinDist_AreaUpto140um2', 'binXY_AvgExistBBAllDist_AreaUpto140um2', 'binXY_AvgNearNeighbourBBMinDist_AreaUpto140um2',...
    'binXY_QuadAreaNormVar_AreaUpto140um2', 'binXY_QuadAreaRateVar_AreaUpto140um2', 'binXY_QuadBBcountNormVar_AreaUpto140um2', 'binXY_QuadBBdensityNormVar_AreaUpto140um2', 'binXY_QuadMeanIntNormVar_AreaUpto140um2', 'binXY_QuadTotalIntNormVar_AreaUpto140um2', 'binXY_QuadnewBBCountnormVar_AreaUpto140um2',...
    'binXY_Isotropicity_Bins', 'binXY_expansionrate_Bins', 'binXY_lnVarianceTessalation_Bins', 'binXY_VarianceTessalation_Bins', 'binXY_MeanInterdist_Bins', 'binXY_NearNeighdist_Bins', 'binXY_AvgNearNeighbourBBMinDist_Bins', 'binXY_NewExistdist_Bins', 'binXY_AvgNewExistBBMinDist_Bins', 'binXY_NewNewBBdist_Bins', 'binXY_AvgNewNewBBMinDist_Bins', 'binXY_clumpingfactor_bbdensity_Bins', 'binXY_LocalClustering_Bins', 'binXY_GlobalClustering_Bins'};

% looping through all the array names so that each array will be saved as a sheet in the excel file; below we use the array names to extract the array data using the evalin function.
for ij = 1:length(array_names_for_saving_in_excel)
    name_1 = array_names_for_saving_in_excel{1,ij};
    % checking if the array exists - because some of the arrays (arrays for comparison plots between ctrl & MO) will exist only in MO and not in Ctrl
    if evalin('base', sprintf('exist(''%s'',''var'')', name_1)) % here the command 'exist('name_1', 'var')' is processed inside evalin; this way, we check if an array of this name exists in the base workspace which is the main workspace
        arrayName = evalin('base', name_1); % extracting the data component of the name_1 using evalin and then assigning it to arrayName
        % checking the length of the sheet name; because excel cannot accept sheet names that are longer than 31 characters
        if length(name_1) > 31
            sheetname = name_1(1:31); % if the sheet name is longer than 31 characters, then we use the characters until 31 units
        else
            sheetname = name_1;
        end
        % below we start by predefining a cell array inorder to store the arrays without NaNs; Below we will remove all the NaNs in each of these columns. After removing, the subsequent data is filled in these places so
        % that there are no empty spaces because of NaN removal. If one column has more data than the other, then padding is done with empty spaces. In order to do this, we convert this array into a
        % cell array and then use empty spaces for padding.
        array_withoutNaNs_1 = cell(size(arrayName, 1), size(arrayName, 2)); % predefining a cell array
        % this for loop goes through all the columns of the array and removes the NaNs
        for col = 1:size(arrayName,2)
            nonNaNvalues = arrayName(~isnan(arrayName(:,col)),col); % using logical indexing to get the non NaN values
            array_withoutNaNs_1(1:numel(nonNaNvalues), col) = num2cell(nonNaNvalues); % saving the non NaN values in a new array - this way we not only remove the NaNs but also fill those spaces with the subsequent data
            % finding the column that has the maximum number of nonempty cells
            num_of_rows = cellfun(@(x) ~isempty(x), array_withoutNaNs_1); % first we get the logical indices for all the non NaN values in each column
            num_nonemptyrows_col = sum(num_of_rows, 1); % then we get the total no of all the '1' logical indices i.e. total no of non NaN values for each column
            col_maxNonEmptyRows = max(num_nonemptyrows_col); % then, we comapre the total no of non NaN values between all the columns and get the maximum of these columns. This number is the maximum number of non NaN value rows in the whole array
            % below, we check if there are columns that have lesser no of rows. If there are, then we pad the rest of the rows with empty spaces so that they have the same row length as the longest column
            if numel(nonNaNvalues) < col_maxNonEmptyRows
                array_withoutNaNs_1(numel(nonNaNvalues)+1:end, col) = {''};
            end
        end
        array_withoutNaNs_2 = array_withoutNaNs_1(1:col_maxNonEmptyRows,:); % because of the preassignment, there can be a lot of rows at the end that are just empty spaces. Here we reassign this matrix so that only upto those rows that I have proper values are taken forward
        array_withoutNaNs = array_withoutNaNs_2;
        if size(array_withoutNaNs, 1) <= 1048576 % this is the maximum no of rows that an excel sheet can hold
            % writing the array as an excel sheet if the no of rows in the array is within the excel row limits
            writecell(array_withoutNaNs, excel_filename, 'Sheet', sheetname);
        else
            % writing the array as .csv file if the no of rows in the array exceeds the excel row limits
            writecell(array_withoutNaNs, [sheetname, '.csv']);
        end
        clear arrayName nonNaNvalues array_withoutNaNs_1 array_withoutNaNs_2 array_withoutNaNs num_of_rows num_nonemptyrows_col
    end
end

clear array_names_for_saving_in_excel

%% saving workspace

save('workspace_all_avg_data');

%% Montage
% Making montage from all the average figures
close all;
clc;

% assigning the list of plots to different cell arrays
area_related_plot = {'Area_vs_Time', 'Rate_of_apical_domain_area_expansion_vs_Area', 'Rate_of_apical_domain_area_expansion_vs_Time', 'isotropicity_vs_area', 'isotropicity_vs_Time', 'circularity_vs_area', 'circularity_vs_Time', 'Area_contribution_absolute', 'Area_contribution_percent'};
BB_related_plot = {'BB_count_vs_Area', 'BB_count_vs_Time', 'BB_density_vs_Area', 'BB_density_vs_Time', 'BB_entry_count_vs_Area', 'BB_entry_count_vs_Time', 'BB_exit_count_vs_Area', 'BB_exit_count_vs_Time', 'BB_entry_rate_vs_Area', 'BB_entry_rate_vs_Time', 'BB_exit_rate_vs_Area', 'BB_exit_rate_vs_Time', 'BB_entry_flux_vs_Area', 'BB_entry_flux_vs_Time', 'BB_exit_flux_vs_Area', 'BB_exit_flux_vs_Time'};
BB_characteristics = {'Average_Drift_in_x_vs_BB_Time_individual_cell', 'Average_Drift_in_y_vs_BB_Time_individual_cell', 'AvgDrift_in_y_vs_BB_Time_all_trajectories', 'AvgDrift_in_x_vs_BB_Time_all_trajectories', 'Average_Drift_vs_Rate_of_apical_area_expansion', 'contour_length_all_trajs', 'endtoend_length_all_trajs', 'tortuosity', 'Dotproduct_traj_direction', 'Dotproduct_traj_direction_count', 'BB_Step_distance', 'BB_Instantaneous_speed', 'Difference_in_x_steps_of_BB_tracks', 'Difference_in_y_steps_of_BB_tracks', 'Difference_in_x_y_steps', 'contour_dist_ActualArea_avg', 'contour_dist_PercentArea_avg', 'endtoend_dist_ActualArea_avg', 'endtoend_dist_PercentArea_avg', 'tortuosity_ActualArea_avg', 'tortuosity_PercentArea_avg'};
actin_intensity = {'Mean_intensity_of_apical_domain_vs_area', 'Mean_intensity_of_apical_domain_vs_Time', 'Total_intensity_of_apical_domain_vs_Area', 'Total_intensity_of_apical_domain_vs_Time', 'Mean_intensity_of_BBPos_vs_area', 'Mean_intensity_of_BBPos_vs_Time', 'Total_intensity_of_BBPos_vs_Area', 'Total_intensity_of_BBPos_vs_Time', 'Mean_intensity_of_BBSur_vs_area', 'Mean_intensity_of_BBSur_vs_Time', 'Total_intensity_of_BBSur_vs_Area', 'Total_intensity_of_BBSur_vs_Time', 'Mean_intensity_of_ratio_BBSurPos_vs_area', 'Mean_intensity_of_ratio_BBSurPos_vs_Time', 'Total_intensity_of_ratio_BBSurPos_vs_Area', 'Total_intensity_of_ratio_BBSurPos_vs_Time', 'Mean_intensity_of_BBPos_aligned_vs_Time', 'Total_intensity_of_BBPos_aligned_vs_Time', 'Mean_intensity_of_BBSur_aligned_vs_Time', 'Total_intensity_of_BBSur_aligned_vs_Time', 'Mean_intensity_of_ratio_BBSurPos_aligned_vs_Time', 'Total_intensity_of_ratio_BBSurPos_aligned_vs_Time'};
actin_intensity_boxplots = {'comparison_1st_last_frames_meanInt_BBpos', 'comparison_1st_last_frames_totalInt_BBpos', 'comparison_1st_last_frames_meanInt_BBsur', 'comparison_1st_last_frames_totalInt_BBsur', 'comparison_1st_last_frames_meanInt_ratioBBsurpos', 'comparison_1st_last_frames_totalInt_ratioBBsurpos'};
BB_mean_interdist_var_tessalation = {'BB_mean_interdistance_(density_based)_vs_Area', 'BB_mean_interdistance_(density_based)_vs_Time', 'LC_vs_Area', 'LC_vs_Time', 'GC_vs_Area', 'GC_vs_Time', 'Variance_Log_in_tessalation_areas_vs_Area_all_tessalations', 'Variance_Log_in_tessalation_areas_vs_Time_all_tessalations', 'Variance_Log_in_tessalation_areas_vs_BB_count_all_tessalations', 'Variance_in_tessalation_areas_vs_Area_all_tessalations', 'Variance_in_tessalation_areas_vs_Time_all_tessalations', 'Variance_in_tessalation_areas_vs_BB_count_all_tessalations', 'Variance_log_in_tessalation_areas_vs_Area_no_edge_tessalations', 'Variance_log_in_tessalation_areas_vs_Time_no_edge_tessalations', 'Variance_log_in_tessalation_areas_vs_BB_count_no_edge_tessalations', 'Variance_in_tessalation_areas_vs_Area_no_edge_tessalations', 'Variance_in_tessalation_areas_vs_Time_no_edge_tessalations', 'Variance_in_tessalation_areas_vs_BB_count_no_edge_tessalations'};
BB_new_new_BB_avg = {'BB_appearance_distance_vs_Area', 'BB_appearance_distance_vs_Time', 'BB_appearance_distance_vs_BB_count', 'BB_appearance_distance_vs_BB_density', 'All_distances_newBB_current_&_previous_frames_vs_Area', 'All_distances_newBB_current_&_previous_frames_vs_Time'};
BB_new_new_BB_hist = {'Minimum_BB_appearance_distance', 'Minimum_BB_appearance_Avgd_distance', 'All_distances_newBB_current_&_previous_frames', 'All_Avgd_distances_newBB_current_&_previous_frames', 'New_BB_count_vs_Distance_fraction'};
BB_new_existing_BB_avg = {'Minimum_distance_newBB_existingBB_vs_Area', 'Minimum_distance_newBB_existingBB_vs_Time', 'Minimum_distance_newBB_existingBB_vs_BB_count', 'Minimum_distance_newBB_existingBB_vs_BB_density', 'All_distances_newBB_existingBB_vs_Area', 'All_distances_newBB_existingBB_vs_Time'};
BB_new_existing_BB_hist = {'Minimum_distance_newBB_existingBB', 'Minimum_Avgd_distance_newBB_existingBB', 'All_distances_newBB_existingBB', 'All_Avgd_distances_newBB_existingBB'};
BB_near_neighbor_dist_avg = {'Nearest_Neighbor_distance_vs_Area', 'Nearest_Neighbor_distance_vs_Time', 'Nearest_Neighbor_distance_vs_BB_count', 'Nearest_Neighbor_distance_vs_BB_density', 'Distance_between_all_BBs_vs_Area', 'Distance_between_all_BBs_vs_Time'};
BB_near_neighbor_dist_hist = {'Nearest_Neighbor_distance', 'Nearest_Neighbor_Avgd_distance', 'Distance_between_all_BBs', 'Avgd_Distance_between_all_BBs'};
BB_msd = {'MSD_std_avg_of_individual_cell', 'MSD_loglog_avg_of_individual_cell', 'MSD_loglog_avg_all_trajectories', 'MSD_std_avg_all_trajectories', 'diff_coeff_direct_all_trajs', 'diff_coeff_fit_all_trajs', 'diff_strength_all_trajs', 'alpha_value_all_trajs', 'DiffStrength_vs_Area_rate'};
quad_fig = {'quad_area_absolute_vs_area', 'quad_area_normalised_vs_area', 'quad_area_absolute_vs_time', 'quad_area_normalised_vs_time', 'quad_bbcount_absolute_vs_area', 'quad_bbcount_normalised_vs_area', 'quad_bbcount_absolute_vs_time', 'quad_bbcount_normalised_vs_time', 'quad_arearate_absolute_vs_area', 'quad_arearate_normalised_vs_area', 'quad_arearate_absolute_vs_time', 'quad_arearate_normalised_vs_time', 'quad_bbdensity_absolute_vs_area', 'quad_bbdensity_normalised_vs_area', 'quad_bbdensity_absolute_vs_time', 'quad_bbdensity_normalised_vs_time', ...
    'quad_actinMeanIntnorm_vs_area', 'quad_actinMeanIntnorm_vs_time', 'quad_actinTotalIntnorm_vs_area', 'quad_actinTotalIntnorm_vs_time', 'quad_Newbbcount_absolute_vs_area', 'quad_Newbbcount_normalised_vs_area', 'quad_Newbbcount_absolute_vs_time', 'quad_Newbbcount_normalised_vs_time'};
half_fig = {'half_area_absolute_vs_area', 'half_area_normalised_vs_area', 'half_area_absolute_vs_time', 'half_area_normalised_vs_time', 'half_BBcount_absolute_vs_area', 'half_BBcount_normalised_vs_area', 'half_BBcount_absolute_vs_time', 'half_BBcount_normalised_vs_time', 'half_arearate_absolute_vs_area', 'half_arearate_normalised_vs_area', 'half_arearate_absolute_vs_time', 'half_arearate_normalised_vs_time', 'half_BBdensity_absolute_vs_area', 'half_BBdensity_normalised_vs_area', 'half_BBdensity_absolute_vs_time', 'half_BBdensity_normalised_vs_time',...
    'half_ActinMeanIntnorm_vs_area', 'half_ActinMeanIntnorm_vs_time', 'half_ActinTotalIntnorm_vs_area', 'half_ActinTotalIntnorm_vs_time', 'half_Newbbcount_absolute_vs_area', 'half_Newbbcount_normalised_vs_area', 'half_Newbbcount_absolute_vs_time', 'half_Newbbcount_normalised_vs_time'};
clumping_factor = {'ClumpingFactor_Area_vs_Area', 'ClumpingFactor_Area_vs_Time', 'ClumpingFactor_AreaRate_vs_Area', 'ClumpingFactor_AreaRate_vs_Time', 'ClumpingFactor_BBcount_vs_Area', 'ClumpingFactor_BBcount_vs_Time', 'ClumpingFactor_BBdensity_vs_Area', 'ClumpingFactor_BBdensity_vs_Time', 'ClumpingFactor_MeanInt_vs_Area', 'ClumpingFactor_MeanInt_vs_Time', 'ClumpingFactor_TotalInt_vs_Area', 'ClumpingFactor_TotalInt_vs_Time', 'ClumpingFactor_NewBBcount_vs_Area', 'ClumpingFactor_NewBBcount_vs_Time'};
quad_box_plots = {'quad_area_comparison_at_max_area', 'quad_arearate_comparison_at_max_area', 'quad_bbcount_comparison_at_max_area', 'quad_bbdensity_comparison_at_max_area', 'quad_MeanIntnorm_comparison_at_max_area', 'quad_TotalIntnorm_comparison_at_max_area', 'quad_NewBB_total_count'};
half_box_plots = {'half_area_comparison_at_max_area', 'half_arearate_comparison_at_max_area', 'half_bbcount_comparison_at_max_area', 'half_bbdensity_comparison_at_max_area', 'half_MeanIntnorm_comparison_at_max_area', 'half_TotalIntnorm_comparison_at_max_area', 'half_NewBB_total_count'};
comparison_areabins_plots_avg_all_times_PDF = {'binComparison_isotropcity_ctrl_PDF', 'binComparison_expansionRate_ctrl_PDF', 'binComparison_lnVarianceTessalation_ctrl_PDF', 'binComparison_MeanInterdist_ctrl_PDF', 'binComparison_NearNeighbordist_ctrl_PDF', 'binComparison_NearNeighborAvgdist_PDF', 'binComparison_NewExistBBdist_ctrl_PDF', 'binComparison_NewExistBBAvgdist_PDF', 'binComparison_BBappearancedist_ctrl_PDF', 'binComparison_BBappearanceAvgdist_PDF', 'binComparison_clumpingfac_BBdensity_ctrl_PDF', 'binComparison_localclustering_ctrl_PDF', 'binComparison_globalclustering_ctrl_PDF',...
    'binComparison_isotropcity_MO_PDF', 'binComparison_expansionRate_MO_PDF', 'binComparison_lnVarianceTessalation_MO_PDF', 'binComparison_MeanInterdist_MO_PDF', 'binComparison_NearNeighbordist_MO_PDF', 'binComparison_NewExistBBdist_MO_PDF', 'binComparison_BBappearancedist_MO_PDF', 'binComparison_clumpingfac_BBdensity_MO_PDF', 'binComparison_localclustering_MO_PDF', 'binComparison_globalclustering_MO_PDF'};
comparison_areabins_plots_avg_all_times_CDF = {'binComparison_isotropcity_ctrl_CDF', 'binComparison_expansionRate_ctrl_CDF', 'binComparison_lnVarianceTessalation_ctrl_CDF', 'binComparison_MeanInterdist_ctrl_CDF', 'binComparison_NearNeighbordist_ctrl_CDF', 'binComparison_NearNeighborAvgdist_CDF', 'binComparison_NewExistBBdist_ctrl_CDF', 'binComparison_NewExistBBAvgdist_CDF', 'binComparison_BBappearancedist_ctrl_CDF', 'binComparison_BBappearanceAvgdist_CDF', 'binComparison_clumpingfac_BBdensity_ctrl_CDF', 'binComparison_localclustering_ctrl_CDF', 'binComparison_globalclustering_ctrl_CDF',...
    'binComparison_isotropcity_MO_CDF', 'binComparison_expansionRate_MO_CDF', 'binComparison_lnVarianceTessalation_MO_CDF', 'binComparison_MeanInterdist_MO_CDF', 'binComparison_NearNeighbordist_MO_CDF', 'binComparison_NewExistBBdist_MO_CDF', 'binComparison_BBappearancedist_MO_CDF', 'binComparison_clumpingfac_BBdensity_MO_CDF', 'binComparison_localclustering_MO_CDF', 'binComparison_globalclustering_MO_CDF'};
comparison_plots_at_max_area_box = {'comparisonCtrlMo_apicalarea_atMaxArea', 'comparisonCtrlMo_bbcount_atMaxArea', 'comparisonCtrlMo_bbdensity_atMaxArea', 'comparisonCtrlMo_bbmeaninterdistance_atMaxArea', 'comparisonCtrlMo_localClustering_atMaxArea', 'comparisonCtrlMo_globalClustering_atMaxArea', 'comparisonCtrlMo_bbVariance_in_tessalation_atMaxArea', 'comparisonCtrlMo_bbLogVariance_in_tessalation_atMaxArea', 'comparisonCtrlMo_nearest_neighbor_min_atMaxArea', 'comparisonCtrlMo_distance_btw_all_BBs_atMaxArea', 'comparisonCtrlMo_MeanIntArea_atMaxArea', 'comparisonCtrlMo_TotalIntArea_atMaxArea',...
    'comparisonCtrlMo_clumpingfac_Area_atMaxArea', 'comparisonCtrlMo_clumpingfac_Arearate_atMaxArea', 'comparisonCtrlMo_clumpingfac_BBcount_atMaxArea', 'comparisonCtrlMo_clumpingfac_BBdensity_atMaxArea', 'comparisonCtrlMo_clumpingfac_meanint_atMaxArea', 'comparisonCtrlMo_clumpingfac_totalint_atMaxArea', 'comparisonCtrlMo_clumpingfac_newbbcount_atMaxArea', 'comparisonCtrlMo_isotropicity_atMaxArea', 'comparisonCtrlMo_circularity_atMaxArea'};
comparison_plots_avg_all_times_box = {'comparisonCtrlMo_apicalarea_fulavg', 'comparisonCtrlMo_wholearearate_fulavg', 'comparisonCtrlMo_bbcount_fulavg', 'comparisonCtrlMo_bbdensity_fulavg', 'comparisonCtrlMo_bbmeaninterdistance_fulavg', 'comparisonCtrlMo_localClustering_fulavg', 'comparisonCtrlMo_globalClustering_fulavg', 'comparisonCtrlMo_bbVariance_in_tessalation_fulavg', 'compareCtrlMo_Upto140um2_Variance', 'comparisonCtrlMo_bbLogVariance_in_tessalation_fulavg', 'compareCtrlMo_Upto140um2_lnVariance', 'comparisonCtrlMo_MeanIntArea_fulavg', 'comparisonCtrlMo_TotalIntArea_fulavg',...
    'comparisonCtrlMo_newBBsmindist_fulavg', 'comparisonCtrlMo_newBBsminAvgdist_fulavg', 'comparisonCtrlMo_newBBsalldist_fulavg', 'comparisonCtrlMo_newBBsallAvgdist_fulavg', 'comparisonCtrlMo_NewExistingBBsmindist_fulavg', 'comparisonCtrlMo_NewExistingBBsminAvgdist_fulavg', 'comparisonCtrlMo_NewExistingBBsalldist_fulavg', 'comparisonCtrlMo_NewExistingBBsallAvgdist_fulavg', 'comparisonCtrlMo_nearest_neighbor_dist_fulavg', 'comparisonCtrlMo_nearest_neighbor_Avgdist_fulavg', 'comparisonCtrlMo_distance_btw_all_BBs_fulavg', 'comparisonCtrlMo_Avgdistance_btw_all_BBs_fulavg',...
    'comparisonCtrlMo_MeanIntBBpos_at1sttimepoint', 'comparisonCtrlMo_MeanIntBBpos_atMaxArea', 'comparisonCtrlMo_TotalIntBBpos_at1sttimepoint', 'comparisonCtrlMo_TotalIntBBpos_atMaxArea', 'comparisonCtrlMo_MeanIntBBSurs_at1sttimepoint', 'comparisonCtrlMo_MeanIntBBSur_atMaxArea', 'comparisonCtrlMo_TotalIntBBSur_at1sttimepoint', 'comparisonCtrlMo_TotalIntBBSur_atMaxArea', 'comparisonCtrlMo_MeanIntRatioBBSursPos_at1sttimepoint', 'comparisonCtrlMo_MeanIntRatioBBSurPos_atMaxArea',...
    'comparisonCtrlMo_TotalIntRatioBBSurPos_at1sttimepoint', 'comparisonCtrlMo_TotalIntRatioBBSurPos_atMaxArea', 'comparisonCtrlMo_ClumpingFac_Area_fulavg', 'comparisonCtrlMo_ClumpingFac_AreaRate_fulavg', 'comparisonCtrlMo_ClumpingFac_BBcount_fulavg', 'comparisonCtrlMo_ClumpingFac_BBdensity_fulavg', 'comparisonCtrlMo_ClumpingFac_meanint_fulavg', 'comparisonCtrlMo_ClumpingFac_totalint_fulavg', 'comparisonCtrlMo_ClumpingFac_newbbcount_fulavg'...
    'compareCtrlMo_Upto140um2_Clumpingfac_BBdensity', 'comparisonCtrlMo_isotropicity_fulavg', 'comparisonCtrlMo_circularity_fulavg', 'comparisonCtrlMo_bbentrycount_fulavg', 'comparisonCtrlMo_bbexitcount_fulavg', 'comparisonCtrlMo_bbentryrate_fulavg', 'comparisonCtrlMo_bbexitrate_fulavg', 'comparisonCtrlMo_contourlength_fulavg', 'comparisonCtrlMo_endtoendlength_fulavg', 'comparisonCtrlMo_tortuosity_fulavg', 'comparisonCtrlMo_bbstepdist_fulavg', 'comparisonCtrlMo_instspeed_fulavg', 'comparisonCtrlMo_avg_drift_fulavg', 'comparisonCtrlMo_DiffCoef_fulavg', 'comparisonCtrlMo_DiffStrength_fulavg', 'comparisonCtrlMo_alphavalue_fulavg'};
comparison_ctrl_mo_plots_avg_all_times_PDF = {'comparisonCtrlMo_apicalarea_fulavg_PDF', 'comparisonCtrlMo_bbcount_fulavg_PDF', 'comparisonCtrlMo_bbdensity_fulavg_PDF', 'comparisonCtrlMo_bbmeaninterdistance_fulavg_PDF', 'comparisonCtrlMo_localClustering_fulavg_PDF', 'compareCtrlMo_Upto140um2_localClustering_PDF', 'comparisonCtrlMo_globalClustering_fulavg_PDF', 'compareCtrlMo_Upto140um2_globalClustering_PDF', 'comparisonCtrlMo_bbVariance_in_tessalation_fulavg_PDF', 'compareCtrlMo_Upto140um2_Variance_PDF', 'comparisonCtrlMo_bbLogVariance_in_tessalation_fulavg_PDF', 'compareCtrlMo_Upto140um2_lnVariance_PDF',...
    'comparisonCtrlMo_newBBsmindist_fulavg_PDF', 'comparisonCtrlMo_newBBsminAvgdist_fulavg_PDF', 'compareCtrlMo_Upto140um2_NewNewMindist_PDF', 'compareCtrlMo_Upto140um2_NewNewMinAvgdist_PDF', 'comparisonCtrlMo_newBBsalldist_fulavg_PDF', 'comparisonCtrlMo_newBBsallAvgdist_fulavg_PDF', 'compareCtrlMo_Upto140um2_NewNewAlldist_PDF', 'compareCtrlMo_Upto140um2_NewNewAllAvgdist_PDF', 'comparisonCtrlMo_NewExistingBBsmindist_fulavg_PDF', 'comparisonCtrlMo_NewExistingBBsminAvgdist_fulavg_PDF', 'compareCtrlMo_Upto140um2_NewExistMindist_PDF', 'compareCtrlMo_Upto140um2_NewExistMinAvgdist_PDF', 'comparisonCtrlMo_NewExistingBBsalldist_fulavg_PDF', 'comparisonCtrlMo_NewExistingBBsallAvgdist_fulavg_PDF', 'compareCtrlMo_Upto140um2_NewExistAlldist_PDF', 'compareCtrlMo_Upto140um2_NewExistAllAvgdist_PDF', 'comparisonCtrlMo_nearest_neighbor_dist_fulavg_PDF', 'comparisonCtrlMo_nearest_neighbor_Avgdist_fulavg_PDF', 'compareCtrlMo_Upto140um2_NearNeigbdist_PDF', 'compareCtrlMo_Upto140um2_NearNeigbAvgdist_PDF', 'comparisonCtrlMo_distance_btw_all_BBs_fulavg_PDF', 'comparisonCtrlMo_Avgdistance_btw_all_BBs_fulavg_PDF', 'compareCtrlMo_Upto140um2_ExistingAlldist_PDF', 'compareCtrlMo_Upto140um2_ExistingAllAvgdist_PDF',...
    'comparisonCtrlMo_MeanIntRatioBBSursPos_at1sttimepoint_PDF', 'comparisonCtrlMo_MeanIntRatioBBSurPos_atMaxArea_PDF', 'comparisonCtrlMo_ClumpingFac_Area_fulavg_PDF', 'comparisonCtrlMo_ClumpingFac_AreaRate_fulavg_PDF', 'comparisonCtrlMo_ClumpingFac_BBcount_fulavg_PDF', 'comparisonCtrlMo_ClumpingFac_BBdensity_fulavg_PDF', 'comparisonCtrlMo_ClumpingFac_meanint_fulavg_PDF', 'comparisonCtrlMo_ClumpingFac_totalint_fulavg_PDF', 'comparisonCtrlMo_ClumpingFac_newbbcount_fulavg_PDF',...
    'compareCtrlMo_Upto140um2_Clumpingfac_area_PDF', 'compareCtrlMo_Upto140um2_Clumpingfac_arearate_PDF', 'compareCtrlMo_Upto140um2_Clumpingfac_bbcount_PDF', 'compareCtrlMo_Upto140um2_Clumpingfac_BBdensity_PDF', 'compareCtrlMo_Upto140um2_Clumpingfac_meanint_PDF', 'compareCtrlMo_Upto140um2_Clumpingfac_totalint_PDF', 'compareCtrlMo_Upto140um2_Clumpingfac_newbbcount_PDF', 'comparisonCtrlMo_isotropicity_fulavg_PDF', 'comparisonCtrlMo_circularity_fulavg_PDF', 'comparisonCtrlMo_bbentrycount_fulavg_PDF', 'comparisonCtrlMo_bbexitcount_fulavg_PDF', 'comparisonCtrlMo_bbentryrate_fulavg_PDF', 'comparisonCtrlMo_bbexitrate_fulavg_PDF', 'comparisonCtrlMo_contourlength_fulavg_PDF', 'comparisonCtrlMo_endtoendlength_fulavg_PDF', 'comparisonCtrlMo_tortuosity_fulavg_PDF', 'comparisonCtrlMo_bbstepdist_fulavg_PDF', 'comparisonCtrlMo_instspeed_fulavg_PDF', 'comparisonCtrlMo_DiffCoef_fulavg_PDF', 'comparisonCtrlMo_DiffStrength_fulavg_PDF', 'comparisonCtrlMo_alphavalue_fulavg_PDF'};
comparison_ctrl_mo_plots_avg_all_times_CDF = {'comparisonCtrlMo_apicalarea_fulavg_CDF', 'comparisonCtrlMo_bbcount_fulavg_CDF', 'comparisonCtrlMo_bbdensity_fulavg_CDF', 'comparisonCtrlMo_bbmeaninterdistance_fulavg_CDF', 'comparisonCtrlMo_localClustering_fulavg_CDF', 'compareCtrlMo_Upto140um2_localClustering_CDF', 'comparisonCtrlMo_globalClustering_fulavg_CDF', 'compareCtrlMo_Upto140um2_globalClustering_CDF', 'comparisonCtrlMo_bbVariance_in_tessalation_fulavg_CDF', 'compareCtrlMo_Upto140um2_Variance_CDF', 'comparisonCtrlMo_bbLogVariance_in_tessalation_fulavg_CDF', 'compareCtrlMo_Upto140um2_lnVariance_CDF',...
    'comparisonCtrlMo_newBBsmindist_fulavg_CDF', 'comparisonCtrlMo_newBBsminAvgdist_fulavg_CDF', 'compareCtrlMo_Upto140um2_NewNewMindist_CDF', 'compareCtrlMo_Upto140um2_NewNewMinAvgdist_CDF', 'comparisonCtrlMo_newBBsalldist_fulavg_CDF', 'comparisonCtrlMo_newBBsallAvgdist_fulavg_CDF', 'compareCtrlMo_Upto140um2_NewNewAlldist_CDF', 'compareCtrlMo_Upto140um2_NewNewAllAvgdist_CDF', 'comparisonCtrlMo_NewExistingBBsmindist_fulavg_CDF', 'comparisonCtrlMo_NewExistingBBsminAvgdist_fulavg_CDF', 'compareCtrlMo_Upto140um2_NewExistMindist_CDF', 'compareCtrlMo_Upto140um2_NewExistMinAvgdist_CDF', 'comparisonCtrlMo_NewExistingBBsalldist_fulavg_CDF', 'comparisonCtrlMo_NewExistingBBsallAvgdist_fulavg_CDF', 'compareCtrlMo_Upto140um2_NewExistAlldist_CDF', 'compareCtrlMo_Upto140um2_NewExistAllAvgdist_CDF', 'comparisonCtrlMo_nearest_neighbor_dist_fulavg_CDF', 'comparisonCtrlMo_nearest_neighbor_Avgdist_fulavg_CDF', 'compareCtrlMo_Upto140um2_NearNeigbdist_CDF', 'compareCtrlMo_Upto140um2_NearNeigbAvgdist_CDF', 'comparisonCtrlMo_distance_btw_all_BBs_fulavg_CDF', 'comparisonCtrlMo_Avgdistance_btw_all_BBs_fulavg_CDF', 'compareCtrlMo_Upto140um2_ExistingAlldist_CDF', 'compareCtrlMo_Upto140um2_ExistingAllAvgdist_CDF',...
    'comparisonCtrlMo_MeanIntRatioBBSursPos_at1sttimepoint_CDF', 'comparisonCtrlMo_MeanIntRatioBBSurPos_atMaxArea_CDF', 'comparisonCtrlMo_ClumpingFac_Area_fulavg_CDF', 'comparisonCtrlMo_ClumpingFac_AreaRate_fulavg_CDF', 'comparisonCtrlMo_ClumpingFac_BBcount_fulavg_CDF', 'comparisonCtrlMo_ClumpingFac_BBdensity_fulavg_CDF', 'comparisonCtrlMo_ClumpingFac_meanint_fulavg_CDF', 'comparisonCtrlMo_ClumpingFac_totalint_fulavg_CDF', 'comparisonCtrlMo_ClumpingFac_newbbcount_fulavg_CDF',...
    'compareCtrlMo_Upto140um2_Clumpingfac_area_CDF', 'compareCtrlMo_Upto140um2_Clumpingfac_arearate_CDF', 'compareCtrlMo_Upto140um2_Clumpingfac_bbcount_CDF', 'compareCtrlMo_Upto140um2_Clumpingfac_BBdensity_CDF', 'compareCtrlMo_Upto140um2_Clumpingfac_meanint_CDF', 'compareCtrlMo_Upto140um2_Clumpingfac_totalint_CDF', 'compareCtrlMo_Upto140um2_Clumpingfac_newbbcount_CDF', 'comparisonCtrlMo_isotropicity_fulavg_CDF', 'comparisonCtrlMo_circularity_fulavg_CDF', 'comparisonCtrlMo_bbentrycount_fulavg_CDF', 'comparisonCtrlMo_bbexitcount_fulavg_CDF', 'comparisonCtrlMo_bbentryrate_fulavg_CDF', 'comparisonCtrlMo_bbexitrate_fulavg_CDF', 'comparisonCtrlMo_contourlength_fulavg_CDF', 'comparisonCtrlMo_endtoendlength_fulavg_CDF', 'comparisonCtrlMo_tortuosity_fulavg_CDF', 'comparisonCtrlMo_bbstepdist_fulavg_CDF', 'comparisonCtrlMo_instspeed_fulavg_CDF', 'comparisonCtrlMo_DiffCoef_fulavg_CDF', 'comparisonCtrlMo_DiffStrength_fulavg_CDF', 'comparisonCtrlMo_alphavalue_fulavg_CDF'};
comparison_ctrl_mo_plots_var_all_times_Quad = {'comparisonCtrlMo_QuadArea_Var', 'compareCtrlMo_Upto140um2_QuadAreaNormVar', 'comparisonCtrlMo_QuadAreaRate_Var', 'compareCtrlMo_Upto140um2_QuadAreaRateNormVar', 'comparisonCtrlMo_QuadBBcount_Var', 'compareCtrlMo_Upto140um2_QuadBBcountNormVar', 'comparisonCtrlMo_QuadBBdensity_Var', 'compareCtrlMo_Upto140um2_QuadBBdensityNormVar', 'comparisonCtrlMo_QuadMeanActinInt_Var', 'compareCtrlMo_Upto140um2_QuadMeanIntNormVar', 'comparisonCtrlMo_QuadTotalActinInt_Var', 'compareCtrlMo_Upto140um2_QuadTotalIntNormVar', 'comparisonCtrlMo_QuadNewBBcount_Var', 'compareCtrlMo_Upto140um2_QuadNewBBCountNormVar'};

% storing all the lists as a cell array for accessing the list (1,:) and as strings (2,:) for verifications
all_plot_names(1,:) = {area_related_plot, BB_related_plot, BB_characteristics, actin_intensity, actin_intensity_boxplots, BB_mean_interdist_var_tessalation, BB_new_new_BB_avg, BB_new_new_BB_hist, BB_new_existing_BB_avg, BB_new_existing_BB_hist, BB_near_neighbor_dist_avg, BB_near_neighbor_dist_hist, BB_msd, quad_fig, half_fig, clumping_factor, quad_box_plots, half_box_plots, comparison_areabins_plots_avg_all_times_PDF, comparison_areabins_plots_avg_all_times_CDF, comparison_plots_at_max_area_box, comparison_plots_avg_all_times_box, comparison_ctrl_mo_plots_avg_all_times_PDF, comparison_ctrl_mo_plots_avg_all_times_CDF, comparison_ctrl_mo_plots_var_all_times_Quad};
all_plot_names(2,:) = {'area_related_plot', 'BB_related_plot', 'BB_characteristics', 'actin_intensity', 'actin_intensity_boxplots', 'BB_mean_interdist_var_tessalation', 'BB_new_new_BB_avg', 'BB_new_new_BB_hist', 'BB_new_existing_BB_avg', 'BB_new_existing_BB_hist', 'BB_near_neighbor_dist_avg', 'BB_near_neighbor_dist_hist', 'BB_msd', 'quad_fig', 'half_fig', 'clumping_factor', 'quad_box_plots', 'half_box_plots', 'comparison_areabins_plots_avg_all_times_PDF', 'comparison_areabins_plots_avg_all_times_CDF', 'comparison_plots_at_max_area_box', 'comparison_plots_avg_all_times_box', 'comparison_ctrl_mo_plots_avg_all_times_PDF', 'comparison_ctrl_mo_plots_avg_all_times_CDF', 'comparison_ctrl_mo_plots_var_all_times_Quad'};

% categorising the list based on whether they have the three types of average plots '_collective_plot', '_avg_plot_shaded', '_avg_plot_errorbar' or just one plot (for example - histograms)
three_plot_types = {'area_related_plot', 'BB_related_plot', 'actin_intensity', 'BB_mean_interdist_var_tessalation', 'BB_new_new_BB_avg', 'BB_new_existing_BB_avg', 'BB_near_neighbor_dist_avg', 'quad_fig', 'half_fig', 'clumping_factor'};
one_plot_type = {'BB_characteristics', 'actin_intensity_boxplots', 'BB_new_new_BB_hist', 'BB_new_existing_BB_hist', 'BB_near_neighbor_dist_hist', 'BB_msd', 'quad_box_plots', 'half_box_plots', 'comparison_areabins_plots_avg_all_times_PDF', 'comparison_areabins_plots_avg_all_times_CDF', 'comparison_plots_at_max_area_box', 'comparison_plots_avg_all_times_box', 'comparison_ctrl_mo_plots_avg_all_times_PDF', 'comparison_ctrl_mo_plots_avg_all_times_CDF', 'comparison_ctrl_mo_plots_var_all_times_Quad'};

% the for loop below goes through all the cell array lists and make
% montages. Those lists that do not exist do not get plotted (for example, while running Ctrl, the comparison between ctrl & MO will not get plotted).
for ii = 1:length(all_plot_names)
    if ismember(all_plot_names{2,ii}, three_plot_types)
        for kk = 1:3
            if kk == 1
                sufix = '_collective_plot';
            elseif kk == 2
                sufix = '_avg_plot_shaded';
            elseif kk == 3
                sufix = '_avg_plot_errorbar';
            end
            making_montage(ii, sufix, all_plot_names, BB_apical_avg, BB_apical_avg_montage) % calling the function to make montage
        end
    elseif ismember(all_plot_names{2,ii}, one_plot_type)
        sufix = '';
        making_montage(ii, sufix, all_plot_names, BB_apical_avg, BB_apical_avg_montage) % calling the function to make montage
    end
end
%clear all_plot_names;

disp('Finished !')
toc
% --------------------- END --------------------- %

%% Function 20
% This function is to make the montage from the average plots
function making_montage(ii, sufix, all_plot_names, BB_apical_avg, BB_apical_avg_montage)
no_of_names = length(all_plot_names{1,ii});
filepaths = cell(1, no_of_names);
incrmnt = 1;
for jj = 1:no_of_names
    file_name_fetch = fullfile(BB_apical_avg, strcat(all_plot_names{1,ii}{jj}, sufix, '.tif'));
    if exist(file_name_fetch, 'file')
        filepaths{incrmnt} = file_name_fetch;
        imshow(filepaths{incrmnt});
        incrmnt = incrmnt + 1;
    else
        continue
    end
end
if any(~cellfun(@isempty, filepaths))
    filepaths = filepaths(~cellfun(@isempty, filepaths));
    montage(filepaths);
    saveas(gcf, fullfile(BB_apical_avg_montage, strcat(sprintf('%01d', ii), '_', all_plot_names{2,ii}, sufix)), 'tif');
end
close all;
clear filepaths
end

%% Function 19
% This function is used for plotting box plot comparisons for control & MO conditions. Here we obtain the values for the control & mo conditions and make them suitable for box plots
function [prm] = prepping_plotting_box_plots(ctrl_prm, mo_parm, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type)
v_all = {ctrl_prm(:), mo_parm(:)}; % The control and mo vectors are input as a cell after converting to a column vector using '(:)'
[v3] = nan_padding(v_all); % this function brings all vectors (i.e. vectors in each of the cells of the cell array) to the same size by padding with NaN; then it returns the vectors in matrix format as 'v3'
prm = [v3(:,1), v3(:,2)]; prm_mean = mean(prm, "omitnan");
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type); % this function plots the box plots for the input vectors
end

%% Function 18
% This function pads vectors with NaNs to bring them to same size (any no of vectors can be input to this function)
% Using the function below, we go through each cell of all the cell arrays and find the cell with the maximum number of elements. Then we pad rest of the cells with NaNs to reach similar number of elements. This way: (1)
% all cells are made to be of same length i.e same number of elements; (2) the padding (to equalise the length) is done with NaNs; (3) by this we make sure that all zeros that were legitimately generated remain in place
% without getting replaced by nans (because the usual procedure is to replace the zeros that were generated to equalise the lengths with nans and in this process even the legitimately created zeros will be replaced with NaNs / this procedure allows to overcome this issue).
function [v3] = nan_padding(v_all) % getting the cell array 'v_all' as input
maxNo_rows = max(cellfun(@(c) size(c,1), v_all)); % finding the cell with the maximum length in the cell array 'v_all'
v3 = cell2mat((cellfun(@(x) {padarray(x,[maxNo_rows-size(x,1),0], NaN, 'Post')}, v_all))); % filling all the cells (i.e. vectors) in the cell array with NaN to bring them to the same size as the longest cell in this cell array and then convert it into a matrix
end

%% Function 17
% this function works on the quadrant data; it collects the individual quadrants (stored as columns) of all cells (i.e. experiments) and puts them together so that the quadrants of all cells (i.e. experiments) are stored as one matrix
function [results_as_columns] = cell_to_array(input_cell_array, column_number)
extracted_columns = cellfun(@(x) x(:,column_number), input_cell_array, 'UniformOutput', false);
max_no_rows = max(cellfun(@(c) size(c,1), extracted_columns));
results_as_columns = cell2mat(cellfun(@(x) {padarray(x,[max_no_rows-size(x,1),0], NaN, 'Post')}, extracted_columns));
end

%% Function 16
% this function plots quadrant data; it obtains different quadrant parameters like area, rate of expansion, BB count and BB density all corresponding to individual quadrants and plots them against whole apical area and time
function [binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = quad_parameter_plots(area_data, time_data, new_parameter, yLabel_1, yLabel_2, plot_Title_1, plot_Title_2, save_title_1, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold)
bininterval_for_Binparameter_1 = 10; xLabel_1 = 'Area [\mum^2]'; bininterval_for_Binparameter_2 = 5; xLabel_2 = 'Time [min]';
[binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold);
% clear new_parameter yLabel_1 plot_Title_1 save_title_1 yLabel_2 plot_Title_2 save_title_2
end

%% Function 15
% This function is for fitting the MSD plot in log space
function [x_for_fit, y_from_fit_model_lin, alpha_value, diff_coeff_fit, diff_coef_direct] = msd_logplot_fitting(xaxis, yaxis)
xaxis_fit = xaxis; yaxis_fit = yaxis; % reassignment
xaxis_fit_range_seq = xaxis_fit(xaxis_fit < 700); % (max(xaxis)/4)); % setting the range on x axis upto which the fit will be estimated. This threshold allows to make sure that we are fitting the straight regions of the MSD plot (in log space) and avoid the farther regions of the plot that have lower statistics from the MSD.
xaxis_fit_range_idx = find(xaxis_fit_range_seq == xaxis_fit_range_seq(end));

xaxis_fit_1 = xaxis_fit(1:xaxis_fit_range_idx);
yaxis_fit_1 = yaxis_fit(1:xaxis_fit_range_idx);

% below we git the fit model for the input data
f = fit(log(xaxis_fit_1)', log(yaxis_fit_1)', 'poly1'); % getting the fit model for the logarithm of the data ('xaxis_fit_1' & 'yaxis_fit_1')
% below we apply the fit model (f) to the log of x values to generate the x & y values for plotting the fit
x_for_fit = logspace(log10(min(xaxis_fit_1)), log10(max(xaxis_fit_1)), 100); % 100 log-spaced x values; logspace works properly with log10 not with log.
y_from_fit_model = f(log(x_for_fit)); % getting the fitted values in log space for the input 'x_for_fit'; therefore the output fit values (y_from_fit_model) will also be in log.
y_from_fit_model_lin = exp(y_from_fit_model); % converting the fit values from log scale to linear scale
% loglog(x_for_fit, y_from_fit_model_lin, 'r-', 'LineWidth', 1.5); % plotting the fit

fit_slope = f.p1; % getting the slope of the fit
alpha_value = fit_slope; % The slope of the fit (of logarithmic data) is directly the alpha value
fit_intercept = f.p2; % getting the intercept of the fit from which the Diffusion Coefficient is calculated
diff_coeff_fit = exp(fit_intercept)/4; % getting the diffusion coefficient from the intercept using (D = exp(Yintercept of the fit)/4); here the units is in µm2/s.
time_Interval = 30; % unit in seconds; here the time interval is taken as 30 seconds simply because, below we use this time interval to get the first MSD value. The first MSD value means it is MSD(tau_1); Tau_1 is simply 1 * time interval. In my coarse grained experiments, the smallest time interval is 30 seconds. Since the first MSD value of the average MSD plot will start from the smallest time point, i took time interval as 30 s.
diff_coef_direct = yaxis_fit(1)/(4 * time_Interval); % getting the diffusion coefficient from the first MSD value using (MSD(t1)/(4*t1)) - (remember the t1 here is 1 and therefore needs to be multiplied by the time interval to bring to the proper units) (another way to get the diffusion coefficient in addition to getting from the y intercept i.e 'diff_coeff' above); Here the units is in µm2/s.
end

%% Function 14
% This function is similar to those used in 'parameter_vs_area', 'parameter_vs_time', 'parameter_vs_area_time', 'parameter_vs_area_time_third_parameter', 'parameter_vs_area_time_third_fourth_parameter'
% Here we apply the 'area_time_shift' function for those data coming from the histograms of different distances that were averaged per frame. Since for these parameters, we dont plot the 'time' or the 'area' evolution, we
% dont get the 'YData_area'. Therefore, we use this function i.e. 'area_time_shift_for_histograms' to get the 'YData_area'.
function [XData_area, XData_time, YData_area] = area_time_shift_for_histograms(area_data, time_data, new_parameter, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, save_title_1)
[ar_dat, tme_dat, par_dat] = area_time_shift(area_data, time_data, new_parameter, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, save_title_1); % calling function 'area_time_shift'
par_dat(par_dat==0) = nan; % changing all zeros to nans.
[ar_dat] = nanconversion(ar_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
YData = par_dat; XData = ar_dat;
XData_area = XData; YData_area = YData;
% parameter vs time
[tme_dat] = nanconversion(tme_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
XData_time = tme_dat;
end

%% Function 13
% This function plots any parameter vs area (for example: BB appearance distance (All distances between new BB and the already existing BBs in the same frame)  vs Area)
% Further, this function calls other functions below to make the plots
function [binned_xy] = parameter_vs_area(area_data, time_data, new_parameter, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, save_title, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold)
[ar_dat, tme_dat, par_dat] = area_time_shift(area_data, time_data, new_parameter, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling function 'area_time_shift'
par_dat(par_dat==0) = nan; % changing all zeros to nans.
[ar_dat] = nanconversion(ar_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
XData = ar_dat; YData = par_dat; Binparameter = XData; % plots
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, BB_apical_avg, save_title); % calling the function
end

%% Function 12
% This function plots any parameter vs time (for example: Residual Area (absolute) vs Time)
% Further, this function calls other functions below to make the plots
function [binned_xy] = parameter_vs_time(area_data, time_data, new_parameter, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, save_title, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold)
[ar_dat, tme_dat, par_dat] = area_time_shift(area_data, time_data, new_parameter, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling function 'area_time_shift'
par_dat(par_dat==0) = nan; % changing all zeros to nans.
[tme_dat] = nanconversion(tme_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
XData = tme_dat; YData = par_dat; Binparameter = XData; % plots
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, BB_apical_avg, save_title); % calling the function
clear area_data time_data new_parameter ar_dat tme_dat par_dat XData YData Binparameter bininterval_for_Binparameter
end

%% Function 11
% This function plots any parameter vs area & time (for example: BB mean interdistance (density based) vs Area & Time)
% Further, this function calls other functions below to make the plots
% parameter vs area
function [binXY_parameter_vs_area, XData_area, YData_area, binXY_parameter_vs_time] = parameter_vs_area_time(area_data, time_data, new_parameter, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold)
[ar_dat, tme_dat, par_dat] = area_time_shift(area_data, time_data, new_parameter, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, save_title_1); % calling function 'area_time_shift'
par_dat(par_dat==0) = nan; % changing all zeros to nans.
[ar_dat] = nanconversion(ar_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
YData = par_dat; XData = ar_dat; Binparameter = XData; % plots
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, BB_apical_avg, save_title_1); % calling the function
binXY_parameter_vs_area = binned_xy; XData_area = XData; YData_area = YData;
clear XData YData Binparameter binned_xy
% parameter vs time
[tme_dat] = nanconversion(tme_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
XData = tme_dat; YData = par_dat; Binparameter = XData; % plots
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, BB_apical_avg, save_title_2); % calling the function
binXY_parameter_vs_time = binned_xy; % XData_time = XData;
end

%% Function 10
% This function plots any parameter vs area, time & a third parameter (for example: Variance in tessalation areas vs Area, Time & BB count)
% Further, this function calls other functions below to make the plots
function [binXY_tessalation_vs_area, XData_area, YData_area, binXY_tessalation_vs_time, binXY_tessalation_vs_3rdparameter] = parameter_vs_area_time_third_parameter(area_data, time_data, new_parameter, new_parameter_2, ...
    bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, ...
    bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, ...
    bininterval_for_Binparameter_3, xLabel_3, yLabel_3, plot_Title_3, save_title_3, ...
    BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold)
% parameter vs area (For example: Variance in tessalation areas vs Area (all tessalations))
[ar_dat, tme_dat, par_dat] = area_time_shift(area_data, time_data, new_parameter, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling function 'area_time_shift'
par_dat(par_dat==0) = nan; % changing all zeros to nans.
[ar_dat] = nanconversion(ar_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
XData = ar_dat; YData = par_dat; Binparameter = XData; % plots
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, BB_apical_avg, save_title_1); % calling the function
binXY_tessalation_vs_area = binned_xy; XData_area = XData; YData_area = YData;
clear XData YData Binparameter binned_xy
% parameter vs time (For example: Variance in tessalation areas vs Time (all tessalations))
[tme_dat] = nanconversion(tme_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
XData = tme_dat; YData = par_dat; Binparameter = XData; % plots
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, BB_apical_avg, save_title_2); % calling the function
binXY_tessalation_vs_time = binned_xy;
clear XData YData Binparameter binned_xy
% parameter vs third_parameter (For example: Variance in tessalation areas vs BB count (all tessalations))
[ar_dat, tme_dat, par_2_dat] = area_time_shift(area_data, time_data, new_parameter_2, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling function 'area_time_shift'
par_dat(par_dat==0) = nan; % changing all zeros to nans.
[par_2_dat] = nanconversion(par_2_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
[par_dat] = nanconversion(par_dat, par_2_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
XData = par_2_dat; YData = par_dat; Binparameter = XData; % plots
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter_3, xLabel_3, yLabel_3, plot_Title_3, BB_apical_avg, save_title_3); % calling the function
binXY_tessalation_vs_3rdparameter = binned_xy;
end

%% Function 9
% This function plots any parameter vs area, time, a third parameter & another fourth parameter (for example: Minimal BB appearance distance vs Area, Time, BB count & BB density)
% Further, this function calls other functions below to make the plots
function [binXY_bbdist_vs_area, XData_area, YData_area, binXY_bbdist_vs_time, binXY_bbdist_vs_3rdparameter, binXY_bbdist_vs_4thparameter] = parameter_vs_area_time_third_fourth_parameter(area_data, time_data, new_parameter, new_parameter_2, new_parameter_3, ...
    bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, save_title_1, ...
    bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, save_title_2, ...
    bininterval_for_Binparameter_3, xLabel_3, yLabel_3, plot_Title_3, save_title_3, ...
    bininterval_for_Binparameter_4, xLabel_4, yLabel_4, plot_Title_4, save_title_4, ...
    BB_apical_avg, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold)
% Minimal BB appearance distance (Minimal distance between new BB in current frame and new BB in previous frame)  vs Area
[ar_dat, tme_dat, par_dat] = area_time_shift(area_data, time_data, new_parameter, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling function 'area_time_shift'
par_dat(par_dat==0) = nan; % changing all zeros to nans.
[ar_dat] = nanconversion(ar_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
XData = ar_dat; YData = par_dat; Binparameter = XData; % plots
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter_1, xLabel_1, yLabel_1, plot_Title_1, BB_apical_avg, save_title_1); % calling the function
binXY_bbdist_vs_area = binned_xy; XData_area = XData; YData_area = YData;
clear XData YData binned_xy
% Minimal BB appearance distance (Minimal distance between new BB in current frame and new BB in previous frame) vs Time
[tme_dat] = nanconversion(tme_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
XData = tme_dat; YData = par_dat; Binparameter = XData; % plots
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter_2, xLabel_2, yLabel_2, plot_Title_2, BB_apical_avg, save_title_2); % calling the function
binXY_bbdist_vs_time = binned_xy;
clear XData YData binned_xy
% Minimal BB appearance distance (Minimal distance between new BB in current frame and new BB in previous frame) vs BB count
[ar_dat, tme_dat, par_2_dat] = area_time_shift(area_data, time_data, new_parameter_2, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling function 'area_time_shift'
par_dat(par_dat==0) = nan; % changing all zeros to nans.
[par_2_dat] = nanconversion(par_2_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
XData = par_2_dat; YData = par_dat; Binparameter = XData; % plots
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter_3, xLabel_3, yLabel_3, plot_Title_3, BB_apical_avg, save_title_3); % calling the function
binXY_bbdist_vs_3rdparameter = binned_xy;
clear XData YData binned_xy
% Minimal BB appearance distance (Minimal distance between new BB in current frame and new BB in previous frame) vs BB density
[ar_dat, tme_dat, par_3_dat] = area_time_shift(area_data, time_data, new_parameter_3, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling function 'area_time_shift'
par_dat(par_dat==0) = nan; % changing all zeros to nans.
[par_3_dat] = nanconversion(par_3_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
XData = par_3_dat; YData = par_dat; Binparameter = XData; % plots
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter_4, xLabel_4, yLabel_4, plot_Title_4, BB_apical_avg, save_title_4); % calling the function
binXY_bbdist_vs_4thparameter = binned_xy;
end

%% Function 8
% This function sets the maximum and minimum threshold area and time depending on the choice of 'experiment_type' & 'operation_type'
function [minimum_area_threshold, max_threshold_area, max_threshold_time, avg_plots_folder_name] = experiment_and_operation(experiment_type, operation_type)

% The experiment type decides the type of experiment being analysed:
% '1' corresponds to control / wildtype experiments
% '2' corresponds to alphaActinin MO experiments

if experiment_type == 1 % Control / wildtype experiments

    % The values below are already preselected for control / wildtype data
    % minimum_area_threshold - Ctrl: 50;
    % max_threshold_area - Ctrl: 337;
    % max_threshold_time - Ctrl: 150;

    if operation_type == 1 % plotting Rawdata without any restriction or thresholds
        minimum_area_threshold = 0; % Min. Area in µm2
        max_threshold_area = 450; % Max. Area in µm2
        max_threshold_time = 250; % Max. time in min
        avg_plots_folder_name = './Avg_plots_Rawdata';

    elseif operation_type == 2 % plotting data without this area range (0 - 'minimum_area_threshold') and also removing the corresponding times;
        minimum_area_threshold = 50; % Min. threshold Area in µm2
        max_threshold_area = 450; % Max. Area in µm2
        max_threshold_time = 250; % Max. time in min
        avg_plots_folder_name = strcat('./Avg_plots_', '(', sprintf('%01d', minimum_area_threshold), 'µm2_Area_&_above)');

    elseif operation_type == 3 % plotting data upto the 'max_threshold_area' and to 'max_threshold_time'
        minimum_area_threshold = 0; % Min. Area in µm2
        max_threshold_area = 300; % Max. threshold Area in µm2 % 337 is the max.area
        max_threshold_time = 150; % Max. threshold time in min
        avg_plots_folder_name = strcat('./Avg_plots_', '(Upto_', sprintf('%01d', max_threshold_area), 'µm2_Area_&_', sprintf('%01d', max_threshold_time), 'min)');

    elseif operation_type == 4 % combined plotting of data without area (0 - 'minimum_area_threshold') & corresponding time and upto the 'max_threshold_area' and to 'max_threshold_time'
        minimum_area_threshold = 50; % Min. threshold Area in µm2
        max_threshold_area = 300; % Max. threshold Area in µm2 % 337 is the max.area
        max_threshold_time = 150; % Max. threshold time in min
        avg_plots_folder_name = strcat('./Avg_plots_', '(', sprintf('%01d', minimum_area_threshold), '-', sprintf('%01d', max_threshold_area), 'µm2_Area_&_', 'upto_', sprintf('%01d', max_threshold_time), 'min)');
    end

    % The experiment type decides the type of experiment being analysed:
    % '1' corresponds to control / wildtype experiments
    % '2' corresponds to alphaActinin MO experiments

elseif experiment_type == 2 % alphaActinin morpholino (MO) experiments

    % The values below are already preselected for alphaActinin MO data
    % minimum_area_threshold - alphaActininMO: 50; minimum area (in µm2) above which the data should be plotted
    % max_threshold_area - alphaActininMO: 130; Maximum area (in µm2) upto which the data should be plotted
    % max_threshold_time - alphaActininMO: 150; Maximum time (in min) upto which the data should be plotted

    if operation_type == 1 % plotting Rawdata without any restriction or thresholds
        minimum_area_threshold = 0; % Min. Area in µm2
        max_threshold_area = 450; % Max. Area in µm2
        max_threshold_time = 250; % Max. time in min
        avg_plots_folder_name = './Avg_plots_Rawdata';

    elseif operation_type == 2 % plotting data without this area range (0 - 'minimum_area_threshold') and also removing the corresponding times;
        minimum_area_threshold = 50; % Min. threshold Area in µm2
        max_threshold_area = 450; % Max. Area in µm2
        max_threshold_time = 250; % Max. time in min
        avg_plots_folder_name = strcat('./Avg_plots_', '(', sprintf('%01d', minimum_area_threshold), 'µm2_Area_&_above)');

    elseif operation_type == 3 % plotting data upto the 'max_threshold_area' and to 'max_threshold_time'
        minimum_area_threshold = 0; % Min. Area in µm2
        max_threshold_area = 300; % Max. threshold Area in µm2
        max_threshold_time = 150; % Max. threshold time in min
        avg_plots_folder_name = strcat('./Avg_plots_', '(Upto_', sprintf('%01d', max_threshold_area), 'µm2_Area_&_', sprintf('%01d', max_threshold_time), 'min)');

    elseif operation_type == 4 % combined plotting of data without area (0 - 'minimum_area_threshold') & corresponding time and upto the 'max_threshold_area' and to 'max_threshold_time'
        minimum_area_threshold = 50; % Min. threshold Area in µm2
        max_threshold_area = 300; % Max. threshold Area in µm2
        max_threshold_time = 150; % Max. threshold time in min
        avg_plots_folder_name = strcat('./Avg_plots_', '(', sprintf('%01d', minimum_area_threshold), '-', sprintf('%01d', max_threshold_area), 'µm2_Area_&_', 'upto_', sprintf('%01d', max_threshold_time), 'min)');
    end

end

end

%% Function 7
% this function converts only the zeros that are coming from the difference in column length are converted to nans - (meaning the actual zeros which are generated to indicate the missing elements are not used here). This is done by taking the array of the
% parameter (for ex: area) in which there are no zeros from missing elements and the zeros from difference in column length are converted to nans. Then the indices of nans in this array are used to introduce nans in the other parameters (for ex BB count).
function [mod_xdata] = nanconversion(xdata, ydata)
a_a = ydata(:); % linearising the area array so that we can find the row numbers that correspond to nans. This will be used as reference.
[row, ~] = find(isnan(a_a)); % finding the rows in which nans are present
xdata(row) = nan; % converting all these rows to nans.
mod_xdata = xdata;
clear a_a row
end

%% Function 6
% This function can do three things for 'area', 'time' and a third 'parameter', depending on the 'operation_type' called:
% '1' plots rawdata without any restriction or thresholds
% '2' removes data corresponding to 0 - 'minimum_area_threshold' and the corresponding time is also removed;
% '3' restricts the area threshold to 'max_threshold_area' and time to 'max_threshold_time';
% '4' combines both (i) removal of 0 - 'minimum_area_threshold' and corresponding time; and (ii) restricting the area threshold to 'max_threshold_area' and restricting time to 'max_threshold_time';
function [ar_dat, tme_dat, par_dat] = area_time_shift(area_data, time_data, new_parameter, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, save_title_1)

ar_temp_1 = area_data; % apical areas
tme_temp_1 = time_data; % time
par_temp_1 = new_parameter; % this parameter may correspond to "Area rate", "BB count", "BB density", "BB_interdistance" etc.
[~, nsamp] = size(ar_temp_1); % extracting the number of experiments
tme_min = zeros(nsamp, 1); % storing the time to be shifted

% plots
for i = 1:nsamp
    non_nan = ~isnan(ar_temp_1(:, i)); % remove the nans
    ar = ar_temp_1(non_nan, i); % area without nans
    % ar = ar/max_threshold_area; % normalizing w.r.t. max area
    if ~isempty(time_data)
        tme = tme_temp_1(non_nan, i); % time without nans
    end
    par = par_temp_1(non_nan, i); % parameter without nans

    if operation_type == 1 % plotting Rawdata without any restriction or thresholds
        if ~isempty(time_data) % if the 'time_data' is NOT empty i.e. if there are contents inside 'time_data'
            alrg(1:length(ar),i) = (ar > minimum_area_threshold); % any normalized area > 0.3 is chosen (can be adjusted)  % change 0.3 to 50 if normalized to max area (because then max area will be 1)
            ar_50shft = ar(alrg(1:length(ar),i)); % those areas above 50µm2
            par_50shft = par(alrg(1:length(ar),i)); % choosing the parameter range corresponding to those areas larger than 50µm2
            tme_50shft = tme(alrg(1:length(ar),i)); % only chose those times
            tme_min(i) = tme_50shft(1); % the time to be shifted
            tme_50shft = tme_50shft - tme_min(i); % shifted time (starting time is always zero)
            alrg(1:length(ar_50shft),i) = (ar_50shft <= max_threshold_area); % any normalized area <= 1 is chosen (1 is the max normalized area)  % change 1 to 'max_threshold_area' if the previous line is commented
            ar_area_shift = ar_50shft(alrg(1:length(ar_50shft),i)); % only those areas within the threshold
            par_area_shift = par_50shft(alrg(1:length(ar_50shft),i)); % choosing the parameter range corresponding to the area threshold
            tme_area_shift = tme_50shft(alrg(1:length(ar_50shft),i)); % only choose corresponding times
            blrg(1:length(tme_area_shift),i) = (tme_area_shift <= max_threshold_time); % introducing the time threshold
            tme_area_time_shift = tme_area_shift(blrg(1:length(tme_area_shift),i)); % only those times within the threshold
            ar_area_time_shift = ar_area_shift(blrg(1:length(tme_area_shift),i)); % only choose corresponding areas
            par_area_time_shift = par_area_shift(blrg(1:length(tme_area_shift),i)); % only choose corresponding areas
            ar_dat((1:length(ar_area_time_shift)), i) = ar_area_time_shift; % area (adjusted for the thresholds of area and time)
            tme_dat((1:length(tme_area_time_shift)), i) = tme_area_time_shift; % time (adjusted for the thresholds of area and time)
            par_dat((1:length(par_area_time_shift)), i) = par_area_time_shift; % parameter (adjusted for the thresholds of area and time)
        else
            alrg(1:length(ar),i) = (ar > minimum_area_threshold); % any normalized area > 0.3 is chosen (can be adjusted)  % change 0.3 to 50 if normalized to max area (because then max area will be 1)
            ar_50shft = ar(alrg(1:length(ar),i)); % those areas above 50µm2
            par_50shft = par(alrg(1:length(ar),i)); % choosing the parameter range corresponding to those areas larger than 50µm2
            alrg(1:length(ar_50shft),i) = (ar_50shft <= max_threshold_area); % any normalized area <= 1 is chosen (1 is the max normalized area)  % change 1 to 'max_threshold_area' if the previous line is commented
            ar_area_shift = ar_50shft(alrg(1:length(ar_50shft),i)); % only those areas within the threshold
            par_area_shift = par_50shft(alrg(1:length(ar_50shft),i)); % choosing the parameter range corresponding to the area threshold
            ar_dat((1:length(ar_area_shift)), i) = ar_area_shift; % area (adjusted for the thresholds of area and time)
            par_dat((1:length(par_area_shift)), i) = par_area_shift; % parameter (adjusted for the thresholds of area and time)
            tme_dat = [];
        end

    elseif operation_type == 2 % plotting data without this area range (0 - 'minimum_area_threshold') and also removing the corresponding times;
        if ~isempty(time_data) % if the 'time_data' is NOT empty i.e. if there are contents inside 'time_data'
            alrg(1:length(ar),i) = (ar > minimum_area_threshold); % any normalized area; change 'minimum_area_threshold' to a value less than '1' if normalized to max area (because then max area will be 1)
            ar_50shft = ar(alrg(1:length(ar),i)); % those areas above 50µm2
            par_50shft = par(alrg(1:length(ar),i)); % choosing the parameter range corresponding to those areas larger than 50µm2
            tme_50shft = tme(alrg(1:length(ar),i)); % only chose those times
            tme_min(i) = tme_50shft(1); % the time to be shifted
            tme_50shft = tme_50shft - tme_min(i); % shifted time (starting time is always zero)
            tme_dat((1:length(tme_50shft)), i) = tme_50shft; % time (adjusted to start after 50µm2 area)
            ar_dat((1:length(ar_50shft)), i) = ar_50shft; % area (adjusted to start after 50µm2 area)
            par_dat((1:length(par_50shft)), i) = par_50shft; % parameter (adjusted to start after 50µm2 area)
        else
            alrg(1:length(ar),i) = (ar > minimum_area_threshold); % any normalized area; change 'minimum_area_threshold' to a value less than '1' if normalized to max area (because then max area will be 1)
            ar_50shft = ar(alrg(1:length(ar),i)); % those areas above 50µm2
            par_50shft = par(alrg(1:length(ar),i)); % choosing the parameter range corresponding to those areas larger than 50µm2
            ar_dat((1:length(ar_50shft)), i) = ar_50shft; % area (adjusted to start after 50µm2 area)
            par_dat((1:length(par_50shft)), i) = par_50shft; % parameter (adjusted to start after 50µm2 area)
            tme_dat = [];
        end

    elseif operation_type == 3 % plotting data upto the 'max_threshold_area' and to 'max_threshold_time'
        if ~isempty(time_data) % if the 'time_data' is NOT empty i.e. if there are contents inside 'time_data'
            alrg(1:length(ar),i) = (ar <= max_threshold_area); % any normalized area <= 1 is chosen (1 is the max normalized area)  % change 1 to 'max_threshold_area' if the previous line is commented
            ar_area_shift = ar(alrg(1:length(ar),i)); % only those areas within the threshold
            par_area_shift = par(alrg(1:length(ar),i)); % choosing the parameter range corresponding to the area threshold
            tme_area_shift = tme(alrg(1:length(ar),i)); % only choose corresponding times
            blrg(1:length(tme_area_shift),i) = (tme_area_shift <= max_threshold_time); % introducing the time threshold
            tme_area_time_shift = tme_area_shift(blrg(1:length(tme_area_shift),i)); % only those times within the threshold
            ar_area_time_shift = ar_area_shift(blrg(1:length(tme_area_shift),i)); % only choose corresponding areas
            par_area_time_shift = par_area_shift(blrg(1:length(tme_area_shift),i)); % only choose corresponding areas
            ar_dat((1:length(ar_area_time_shift)), i) = ar_area_time_shift; % area (adjusted for the thresholds of area and time)
            tme_dat((1:length(tme_area_time_shift)), i) = tme_area_time_shift; % time (adjusted for the thresholds of area and time)
            par_dat((1:length(par_area_time_shift)), i) = par_area_time_shift; % parameter (adjusted for the thresholds of area and time)
        else
            alrg(1:length(ar),i) = (ar <= max_threshold_area); % any normalized area <= 1 is chosen (1 is the max normalized area)  % change 1 to 'max_threshold_area' if the previous line is commented
            ar_area_shift = ar(alrg(1:length(ar),i)); % only those areas within the threshold
            par_area_shift = par(alrg(1:length(ar),i)); % choosing the parameter range corresponding to the area threshold
            ar_dat((1:length(ar_area_shift)), i) = ar_area_shift; % area (adjusted for the thresholds of area and time)
            par_dat((1:length(par_area_shift)), i) = par_area_shift; % parameter (adjusted for the thresholds of area and time)
            tme_dat = [];
        end

    elseif operation_type == 4 % combined plotting of data without area (0 - 'minimum_area_threshold') & corresponding time and upto the 'max_threshold_area' and to 'max_threshold_time'

        if ~isempty(time_data) % if the 'time_data' is NOT empty i.e. if there are contents inside 'time_data'
            alrg(1:length(ar),i) = (ar > minimum_area_threshold); % any normalized area > 0.3 is chosen (can be adjusted)  % change 0.3 to 50 if normalized to max area (because then max area will be 1)
            ar_50shft = ar(alrg(1:length(ar),i)); % those areas above 50µm2
            par_50shft = par(alrg(1:length(ar),i)); % choosing the parameter range corresponding to those areas larger than 50µm2
            tme_50shft = tme(alrg(1:length(ar),i)); % only choose those times
            tme_min(i) = tme_50shft(1); % the time to be shifted
            tme_50shft = tme_50shft - tme_min(i); % shifted time (starting time is always zero)
            alrg(1:length(ar_50shft),i) = (ar_50shft <= max_threshold_area); % any normalized area <= 1 is chosen (1 is the max normalized area)  % change 1 to 'max_threshold_area' if the previous line is commented
            ar_area_shift = ar_50shft(alrg(1:length(ar_50shft),i)); % only those areas within the threshold
            par_area_shift = par_50shft(alrg(1:length(ar_50shft),i)); % choosing the parameter range corresponding to the area threshold
            tme_area_shift = tme_50shft(alrg(1:length(ar_50shft),i)); % only choose corresponding times
            blrg(1:length(tme_area_shift),i) = (tme_area_shift <= max_threshold_time); % introducing the time threshold
            tme_area_time_shift = tme_area_shift(blrg(1:length(tme_area_shift),i)); % only those times within the threshold
            ar_area_time_shift = ar_area_shift(blrg(1:length(tme_area_shift),i)); % only choose corresponding areas
            par_area_time_shift = par_area_shift(blrg(1:length(tme_area_shift),i)); % only choose corresponding areas
            if isempty(tme_area_time_shift)
                disp('The "tme_area_time_shift" vector in "area_time_shift" function is empty.');
                disp('This means, the parameter from the cell/expt number displayed below will not be taken into consideration for,');
                disp('-this parameter quantification since it doesnt fall within the threshold limits of time & area.');
                disp(strcat('Parameter:', save_title_1));
                disp(strcat('Expt/cell no:', sprintf('%01d',i)));
                disp('If you are seeing this message, then it means the expts/cells mentioned above will not be included in the average quantification only for this parameter.');
                disp('If that is fine, you dont have to do anything. Otherwise, you will have to change the area & time thresholds to allow more room for taking more data points.');
                ar_dat = NaN;
                tme_dat = NaN;
                par_dat = NaN;
            else
                tme_min(i) = tme_area_time_shift(1); % the time to be shifted
                tme_area_time_shift = tme_area_time_shift - tme_min(i); % shifted time (starting time is always zero)
                ar_dat((1:length(ar_area_time_shift)), i) = ar_area_time_shift; % area (adjusted for the thresholds of area and time)
                tme_dat((1:length(tme_area_time_shift)), i) = tme_area_time_shift; % time (adjusted for the thresholds of area and time)
                par_dat((1:length(par_area_time_shift)), i) = par_area_time_shift; % parameter (adjusted for the thresholds of area and time)
            end
        else
            alrg(1:length(ar),i) = (ar > minimum_area_threshold); % any normalized area > 0.3 is chosen (can be adjusted)  % change 0.3 to 50 if normalized to max area (because then max area will be 1)
            ar_50shft = ar(alrg(1:length(ar),i)); % those areas above 50µm2
            par_50shft = par(alrg(1:length(ar),i)); % choosing the parameter range corresponding to those areas larger than 50µm2
            alrg(1:length(ar_50shft),i) = (ar_50shft <= max_threshold_area); % any normalized area <= 1 is chosen (1 is the max normalized area)  % change 1 to 'max_threshold_area' if the previous line is commented
            ar_area_shift = ar_50shft(alrg(1:length(ar_50shft),i)); % only those areas within the threshold
            par_area_shift = par_50shft(alrg(1:length(ar_50shft),i)); % choosing the parameter range corresponding to the area threshold
            ar_dat((1:length(ar_area_shift)), i) = ar_area_shift; % area (adjusted for the thresholds of area and time)
            par_dat((1:length(par_area_shift)), i) = par_area_shift; % parameter (adjusted for the thresholds of area and time)
            tme_dat = [];
        end
    end
end
end

%% Function 5
% Function that generates the histogram plots i.e. the frequency distribution of a particular parameter
function hist_distr_plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title)

% Binning the data
figure(100);
binparameter = parameter(~isnan(parameter));
binrange = min(binparameter):bininterval:max(binparameter); % setting the bin range based on the input data
[N, ~] = histcounts(binparameter, binrange); % here 'N' corresponds to the counts or the repeats of the data; and edges is same as the binrange defined above.
binrange1 = binrange(1:end-1); % changing the binrange length to match the length of N so that they can be plotted together.
% barplot = bar(binrange1, N); barplot.FaceColor = 'r'; barplot.EdgeColor = 'b';  % barplot.LineWidth = 1; % either barplot or histogram plot can be used
histplot = histogram(binparameter, binrange1, 'Normalization', 'pdf'); histplot.FaceColor = 'r'; histplot.FaceAlpha = 1; histplot.EdgeColor = 'b'; histplot.LineWidth = 1; % either barplot or histogram plot can be used

xlabel(Xlabel);  ylabel(Ylabel); title(Plot_title);  set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical_avg, save_title), 'fig'); saveas(gcf, fullfile(BB_apical_avg, save_title), 'tif');
%pause;
close (figure(100));

clear parameter bininterval xLabel yLabel plot_Title BB_apical save_title

end

%% Function 4
% Function that generates plots that include collective plot of rawdata of individual cells, the average plots with standard deviation bars and shaded area
% bars
function [binned_xy] = avgd_plots(binparameter, x_axis, y_axis, bininterval, Xlabel, Ylabel, Plot_title, BB_apical_avg, save_title)

% collective plot
figure(100);
plot(x_axis, y_axis, 'ko-', 'MarkerSize', 2, 'LineWidth', 0.5); xlabel(Xlabel); ylabel(Ylabel); title(Plot_title); set(gca,'fontsize',12);
save_name = strcat(save_title, '_collective_plot');
saveas(gcf, fullfile(BB_apical_avg, save_name), 'fig'); saveas(gcf, fullfile(BB_apical_avg, save_name), 'tif');

%----------- Binning and Averaging -----------%
% getting the x, y values and assigning the bin parameter
binparameter = binparameter(~isnan(binparameter));
x_axis = x_axis(~isnan(x_axis));
y_axis = y_axis(~isnan(y_axis));

% Creating bins defined by bincenters - bincenter based plotting is only used in those plots where a parameter is plotted against area, time or another parameter; these bins are used only for plotting and are not returned as a product of this function
binrange = min(binparameter) : bininterval : (max(binparameter)+bininterval); % bins are defined by their bin centers; For example, while creating bins for values between 0-350, the bins will be around bincenter: 25-50-75, 75-100-125, 125-150-175, 175-200-225, 225-250-275, 275-300-325
[N, edges, bin] = histcounts(binparameter, binrange);
% binsum_y = accumarray(bin(:), y_axis(:));
% removing empty bins (where N == 0)
non_empty_bins = N > 0;
%----------------------%

% computing the average and standard deviation for the bins of x
x_bin_mean = accumarray(bin(:), x_axis(:), [], @mean);
x_bin_std = accumarray(bin(:), x_axis(:), [], @std);
% computing the average and standard deviation for the bins of y
y_bin_mean = accumarray(bin(:), y_axis(:), [], @mean);
y_bin_std = accumarray(bin(:), y_axis(:), [], @std);
% applying the non-empty bin filter to the bin means and standard deviations
x_bin_mean = x_bin_mean(non_empty_bins); y_bin_mean = y_bin_mean(non_empty_bins);
x_bin_std = x_bin_std(non_empty_bins); y_bin_std = y_bin_std(non_empty_bins);
% sorting the filtered x_bin_mean and using the sorted indices to sort other arrays
[sort_x_bin_mean, idx_sort_x_bin_mean] = sort(x_bin_mean);
sort_x_bin_std = x_bin_std(idx_sort_x_bin_mean);
sort_y_bin_mean = y_bin_mean(idx_sort_x_bin_mean);
sort_y_bin_std = y_bin_std(idx_sort_x_bin_mean);

% plotting the bin averages - standard deviation as shaded region
figure(101);
c1 = y_bin_mean + y_bin_std;
c2 = y_bin_mean - y_bin_std;
x2 = [x_bin_mean', fliplr(x_bin_mean')];
inbtw = [c1', fliplr(c2')];
fill(x2, inbtw, 'k', 'FaceAlpha', '0.1');
hold on;
plot(x_bin_mean, y_bin_mean, 'k', 'LineWidth', 2);
xlabel(Xlabel);  ylabel(Ylabel); title(Plot_title);  set(gca,'fontsize',12);
save_name_avg_1 = strcat(save_title, '_avg_plot_shaded');
saveas(gcf, fullfile(BB_apical_avg, save_name_avg_1), 'fig'); saveas(gcf, fullfile(BB_apical_avg, save_name_avg_1), 'tif'); % disp('Press a key'); pause;

% plotting the bin averages - standard deviation error bars
figure(102);
errorbar(x_bin_mean, y_bin_mean, y_bin_std, 'vertical', 'o', 'color', 'k', 'MarkerSize', 1, 'MarkerEdgeColor', 'black'); % 'MarkerSize', 10, 'MarkerEdgeColor', 'black'
hold on;
errorbar(x_bin_mean, y_bin_mean, x_bin_std, 'horizontal', 'o', 'color', 'k', 'MarkerSize', 1, 'MarkerEdgeColor', 'black');
xlabel(Xlabel);  ylabel(Ylabel); title(Plot_title);  set(gca,'fontsize',12);
save_name_avg_2 = strcat(save_title, '_avg_plot_errorbar');
saveas(gcf, fullfile(BB_apical_avg, save_name_avg_2), 'fig'); saveas(gcf, fullfile(BB_apical_avg, save_name_avg_2), 'tif');

%pause;
close (figure(100), figure(101), figure(102));

%----------- Binning and Averaging -----------%

% Creating bins defined by binedges - binedges based plotting is only used for histogram plots where different bins (based on binedges) are plotted as histograms.
% This is mainly used for plotting the histograms of values of different parameters "upto 150 µm2" and "beyond 150µm2"; These bins (i.e. based on bin edges) are returned as a product of this function i.e. as "binned_xy" which will be then used for plotting the histograms
lower_binEdge = floor(min(binparameter)/bininterval) * bininterval;
upper_binEdge = ceil(max(binparameter)/bininterval) * bininterval;
binrange_1 = lower_binEdge : bininterval : upper_binEdge; % here bins are defined by their bin edges_1; For example, while creating bins for values between 0-350, the bins will be within the bin edge: 0-50, 51-100, 101-150, 151-200, 201-250, 251-300, 301-350
[N_1, edges_1, bin_1] = histcounts(binparameter, binrange_1);

% In general, bins can be created in two ways: (1) using the bin centers and (2) using the bin edges. Both can be used. But usually, using bin edges is better because then the mean of the bin will become the bin center. Whereas in the
% case of bin center based bins, the bin center is decided and the data are aggregated to the corresponding bin basket accordingly. Therefore the bin center based bins can be thought of as a "slightly forced" approach.
% However, if the trends of the plots are strong, these two approaches may not make a big difference. But if the trend is subtle, then bin edges based bins might be a slightly better option. 
% Below, we have made two different ways bin edges based approach. The only difference is how the start and end of the bins are decided. Check the binrange & binrange_1, and their comments to understand better. We have the flexibility to change between the two ways. 
% (1) If you want the bin edges to be simply min and max of binparameter (currently used): then use the variable "bin" instead of "bin_1" for calcualting the x & y means (i.e. x_bin_mean) and use the variable "edges" instead of "edges_1" for getting the bin values (i.e binned_xy).
% (2) If you want the bin edges to be min and max of binparameter but adjusted to bininterval: then use the variable "bin_1" instead of "bin" for calcualting the x & y means (i.e. x_bin_mean) and use the variable "edges_1" instead of "edges" for getting the bin values (i.e binned_xy).

% getting the individual x & y values based on the binedges for returning at the end of this function as "binned_xy"
binned_xy = cell(length(edges)-1, 2); % preassignment for the cell array where the binned x & y axis values will be stored
% Below, the function discretize will place the values of x_axis into the corresponding bin based on the edges_1 and provide a output (i.e. bin_indices) that will contain the index of the bin to which each x_axis value belongs.
% bin_indices = discretize(x_axis, edges); % here the left edges are included meaning, for values between 0-350, the bins go like: 0-49, 50-99, 100-149, 150-199, 200-249, 250-299, 300-349
bin_indices = discretize(x_axis, edges, 'IncludedEdge','right'); % here the right edges are included meaning, for values between 0-350, the bins go like: 1-50, 51-100, 101-150, 151-200, 201-250, 251-300, 301-350
for i = 1:length(edges)-1
    binIdx = bin_indices == i; % her we find all those bin_indices values that match i. then we we create a logical array which when used as an index to x_axis & y_axis in the following lines, will collect only logically true values.
    binned_xy{i,1} = x_axis(binIdx); % placing the collected x_axis values based on binIdx (which is a logical array) in the appropriate bin
    binned_xy{i,2} = y_axis(binIdx); % placing the collected y_ axis values based on binIdx (which is a logical array) in the appropriate bin
end

%----------------------%
end

%% Function 3
% This function plots the box plots
function box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, BB_apical_avg, legend_type)

% setting the right legend
if contains(legend_type, 'comparison_ctrl_mo')
    % plotting the parameters between 'Control' and 'MO' conditions
    legnd_list = {'Control', 'alphaActinin MO'};
    linecolors = ['b' 'k'];
elseif contains(legend_type, 'comparison_1stframe_maxArea')
    % plotting the parameters between '1st frame' and 'max area frame' conditions
    legnd_list = {'First time point', 'Last time point'};
    linecolors = ['b' 'k'];
elseif contains(legend_type, 'quad_analy')
    % plotting the parameters between four quadrants in the quadrant analysis
    legnd_list = {'Quadrant 1 (low BB density)', 'Quadrant 2', 'Quadrant 3', 'Quadrant 4 (high BB density)'};
    linecolors = ['m' 'k' 'b' 'r'];
elseif contains(legend_type, 'quad_half_analy')
    % plotting the parameters between the two halves in the quadrant analysis
    legnd_list = {'Half 1 (low BB density)', 'Half 2', 'Half 3', 'Half 4 (high BB density)'};
    linecolors = ['m' 'k' 'b' 'r'];
elseif contains(legend_type, 'contour_end2end_dist_early_late')
    % plotting the contour and end2end distance parameters between the early and late phase areas of expansion
    legnd_list = {'Early expansion phase', 'Late expansion phase'};
    linecolors = ['b' 'k' 'm' 'r'];
elseif contains(legend_type, 'contour_end2end_dist_percentage')
    % plotting the contour and end2end distance parameters between the different percentages of area expansion
    legnd_list = {'0-25%', '25%-50%', '50%-75%', '75%-100%'};
    linecolors = ['b' 'k' 'm' 'r'];
end

% setting the right opacity for the edge color and the size
if contains(save_title, 'fulavg')
    edge_alphavalue = 1;
    size_data = 12;
else
    edge_alphavalue = 0.5;
    size_data = 15;
end

fig200 = figure(200);
% creating a swarm plot which is an alternative to scatter plot
grp1 = repmat(1:size(prm,2), size(prm,1), 1);
swarmchart(grp1(:), prm(:), 'o', 'r', 'MarkerFaceAlpha', 0, 'MarkerEdgeAlpha', edge_alphavalue, 'SizeData', size_data, 'XJitter', 'density', 'XJitterWidth', 0.9);
hold on;
% creating a box plot
grp2 = repmat(1:size(prm,2), 1, 1);
bxp1 = boxplot(prm, grp2, 'labels', legnd_list, 'BoxStyle', 'outline', 'Colors', linecolors, 'Symbol',''); %  in order to plot the outliers, add some symbols like '.', 'o'etc to 'symbol'. Right now, the outliers are disabled by leaving the space empty.
set(bxp1, 'LineWidth', 1);
hold on;
% plotting the mean
plot(prm_mean, 'x-m', 'LineWidth', 2); % plotting the mean value
ylabel(Ylabel); title(Plot_title);  set(gca,'fontsize',12);
saveas(fig200, fullfile(BB_apical_avg, save_title), 'fig'); saveas(fig200, fullfile(BB_apical_avg, save_title), 'tif');
close(figure(200));
clear prm prm_mean
%pause;
end

%% Function 2
% This function generates the combined histogram plots either for the set: 'Upto bin_breakpoint µm2', 'Beyond bin_breakpoint µm2'; or 'Control', 'MO'.

function [a2] = hist_plots_for_bins(bin_breakpoint, parameter_1, parameter_2, bininterval, XLabel, TiTle, save_title, plot_save_link, legend_type)
figure(100);
% first bin (upto bin_breakpoint µm2)
binparameter_1 = parameter_1(~isnan(parameter_1));
binrange_1 = min(binparameter_1):bininterval:max(binparameter_1); % setting the bin range based on the input data
[N_1, ~] = histcounts(binparameter_1, binrange_1); % here 'N' corresponds to the counts or the repeats of the data; and edges is same as the binrange defined above.
binrange_mod_1 = binrange_1(1:end-1); % changing the binrange length to match the length of N so that they can be plotted together.
histplot = histogram(binparameter_1, binrange_mod_1, 'Normalization', 'pdf'); histplot.FaceColor = 'g'; histplot.FaceAlpha = 0.3; histplot.LineWidth = 0.01; histplot.EdgeColor = 'none'; % either barplot or histogram plot can be used
hold on;

% second bin (beyond bin_breakpoint  µm2)
binparameter_2 = parameter_2(~isnan(parameter_2));
binrange_2 = min(binparameter_2):bininterval:max(binparameter_2); % setting the bin range based on the input data
[N_2, ~] = histcounts(binparameter_2, binrange_2); % here 'N' corresponds to the counts or the repeats of the data; and edges is same as the binrange defined above.
binrange_mod_2 = binrange_2(1:end-1); % changing the binrange length to match the length of N so that they can be plotted together.
histplot = histogram(binparameter_2, binrange_mod_2, 'Normalization', 'pdf'); histplot.FaceColor = 'k'; histplot.FaceAlpha = 0.3; histplot.LineWidth = 0.01; histplot.EdgeColor = 'none'; % either barplot or histogram plot can be used

if contains(legend_type, 'area_bins')
    if contains(pwd, 'MO')
        legnd_list = {char(strcat("Upto ", num2str(bin_breakpoint), " µm2")), char(strcat("Beyond ", num2str(bin_breakpoint), " µm2"))};
        save_title = strcat(save_title, '_MO_PDF');
    else
        legnd_list = {char(strcat("Upto ", num2str(bin_breakpoint), " µm2")), char(strcat("Beyond ", num2str(bin_breakpoint), " µm2"))};
        save_title = strcat(save_title, '_ctrl_PDF');
    end
    legend (legnd_list);
elseif contains(legend_type, 'comparison_ctrl_mo')
    legend ('Control', 'MO');
    save_title = strcat(save_title, '_PDF');
end

xlabel(XLabel);  ylabel('Probability density'); title(TiTle);  set(gca,'fontsize',12);
saveas(gcf, fullfile(plot_save_link, save_title), 'fig'); saveas(gcf, fullfile(plot_save_link, save_title), 'tif');
%pause;
close (figure(100));

% below we concatenate the two input vectors 'binparameter_1' & 'binparameter_2' so that they are stored as one matrix and is easy for saving in the excel sheet for future statistical analysis
a0 = {binparameter_1, binparameter_2}; % concatenating two arrays with different lengths as cell array
a1 = nan_padding(a0); % padding the length difference (between the arrays) with NaNs
a2 = [a1(:,1), a1(:,2)]; % concatenating the two columns of the cell array and storing them as a standard matric

end

%% Function 1
% This function generates the CDF plots i.e. alternative to the PDF plots

function cdf_distr_plots(bin_breakpoint, parameter_1, parameter_2, XLabel, TiTle, save_title, plot_save_link, legend_type)
figure(101);

cdf_1 = cdfplot(parameter_1(:)); set(cdf_1, 'LineStyle', '-', 'Color', 'g');
hold on;
cdf_2 = cdfplot(parameter_2(:)); set(cdf_2, 'LineStyle', '-', 'Color', 'k');

if contains(legend_type, 'area_bins')
    if contains(pwd, 'MO')
        legnd_list = {char(strcat("Upto ", num2str(bin_breakpoint), " µm2")), char(strcat("Beyond ", num2str(bin_breakpoint), " µm2"))};
        save_title = strcat(save_title, '_MO_CDF');
    else
        legnd_list = {char(strcat("Upto ", num2str(bin_breakpoint), " µm2")), char(strcat("Beyond ", num2str(bin_breakpoint), " µm2"))};
        save_title = strcat(save_title, '_ctrl_CDF');
    end
    legend (legnd_list);
elseif contains(legend_type, 'comparison_ctrl_mo')
    legend ('Control', 'MO');
    save_title = strcat(save_title, '_CDF');
end

xlabel(XLabel);  ylabel('Cumulative probability'); title(TiTle);  set(gca,'fontsize',12);
saveas(gcf, fullfile(plot_save_link, save_title), 'fig'); saveas(gcf, fullfile(plot_save_link, save_title), 'tif');

close (figure(101));

end

%%