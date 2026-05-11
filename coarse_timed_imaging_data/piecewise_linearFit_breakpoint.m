% Raghavan Thiagarajan, reNEW Copenhagen, May 2025

% This script is to generate piecewise linear regression fit for plots. For example, lets say we have a plot where the independent parameter has a particular trend that is changing over time and we want to find when exactly the trend change
% kicks in w.r.t the dependent parameter. Then we can use this script to find the point at which the trend change starts. We call this as Breakpoint in this script. 

% In order to do this, first we get the parameters (both dependent & independent) and set a range of breakpoints. Then we fit a linear regression model starting from the first point, incrementally through all
% the points. We fit this model using the equation y = mx + m1(x-breakpoint) + c; Here, m1(x-breakpoint) accounts for the change in trend. Then we find the Sum of Squared Errors (SSE) for every brekpoint value. The SSE value
% indicates how close are the fit data to the raw data - smaller the SSE value, closer are the fit data and the raw data. So we find the SSE value for a range of breakpoints and then find for which breakpoint, the SSE is
% most minimum. This is the actual breakpoint where the plot changes its trend.  For each of this breakpoint, we also find the p value and check if it is smaller than 0.05. If the p value is smaller than 0.05, then the trend 
% change at this break point is statistically significant. IF not, then it means the trend change before and after the breakpoint is not strong enough to conclude that there's a real (non-random) difference before and after the breakpoint. 
% IF needed, one can always widen the breakpoint range to check for breakpoints in other positions. Since the breakpoint is estimated based  on when the SSE value is lowest (for the given range of breakpoints), we 
% find only the dominant breakpoint here. Once we have the breakpoint, then% we fit the data until the breakpoint with one linear fit and the data beyond breakpoint with another linear fit. We also show the actual fit
% that is continuous throughout the data. 

% This analysis is done mainly for those data where we found a trend change happening around 150µm2. So instead of showing  "guide for the eye" in the plots, we wanted to show a legitimate fit highlighting where the fit changes its trend.

% This script should be run after running the 'average script' for the coarse timed data of both control & MO and all the scripts for the fine timed data of both control & MO

clear all;
close all;
clc;

%% Coarse timed data
% control data
folder_coarsetimed_ctrl = uigetdir(pwd, 'Select the folder for the coarse timed data that contains the averaged workspace file (Control condition)'); % select the "Result_Data" folder for Control condition
cd(folder_coarsetimed_ctrl);
load('workspace_all_avg_data.mat', 'binXY_isotropicity_vs_area', 'binXY_expansionrate_vs_area', 'binXY_lnVarianceTessalation_vs_area', 'binXY_VarianceTessalation_vs_area', 'binXY_MeanInterdist_vs_area', 'binXY_NearNeighbdist_vs_area', 'binXY_NewExistdist_vs_area', 'binXY_NewNewBBdist_vs_area', 'binXY_clumpingFactor_bbdensity_vs_area', 'binXY_clumpingFactor_meanint_vs_area', 'binXY_LocalClustering_vs_area', 'binXY_GlobalClustering_vs_area');
mkdir '.\Avg_plots_(50-300µm2_Area_&_upto_150min)\breakpoint_plots'; % making a folder for saving the plots
plot_save_link_coarsetimed_ctrl = strcat(folder_coarsetimed_ctrl, '.\Avg_plots_(50-300µm2_Area_&_upto_150min)\breakpoint_plots'); % creating the link for saving the plots
breakpoint_range_start = 50; breakpoint_range_end = 200;
coarsegrained_data_input(plot_save_link_coarsetimed_ctrl, binXY_isotropicity_vs_area, binXY_expansionrate_vs_area, binXY_lnVarianceTessalation_vs_area, binXY_VarianceTessalation_vs_area, binXY_MeanInterdist_vs_area, binXY_NearNeighbdist_vs_area,...
    binXY_NewExistdist_vs_area, binXY_NewNewBBdist_vs_area, binXY_clumpingFactor_bbdensity_vs_area, binXY_clumpingFactor_meanint_vs_area, binXY_LocalClustering_vs_area, binXY_GlobalClustering_vs_area, breakpoint_range_start, breakpoint_range_end);
save(fullfile(plot_save_link_coarsetimed_ctrl, 'workspace_breakpoint_data'));
montage_saving(plot_save_link_coarsetimed_ctrl); % saving the montage
clear all;
fclose('all');

%%
% MO data
folder_coarsetimed_MO = uigetdir(pwd, 'Select the folder for the coarse timed data that contains the averaged workspace file (MO condition)'); % select the "Result_Data" folder for Control condition
cd(folder_coarsetimed_MO);
load('workspace_all_avg_data.mat', 'binXY_isotropicity_vs_area', 'binXY_expansionrate_vs_area', 'binXY_lnVarianceTessalation_vs_area', 'binXY_VarianceTessalation_vs_area', 'binXY_MeanInterdist_vs_area', 'binXY_NearNeighbdist_vs_area', 'binXY_NewExistdist_vs_area', 'binXY_NewNewBBdist_vs_area', 'binXY_clumpingFactor_bbdensity_vs_area', 'binXY_clumpingFactor_meanint_vs_area', 'binXY_LocalClustering_vs_area', 'binXY_GlobalClustering_vs_area');
mkdir '.\Avg_plots_(50-300µm2_Area_&_upto_150min)\breakpoint_plots'; % making a folder for saving the plots
plot_save_link_coarsetimed_MO = strcat(folder_coarsetimed_MO, '.\Avg_plots_(50-300µm2_Area_&_upto_150min)\breakpoint_plots'); % creating the link for saving the plots
breakpoint_range_start = 50; breakpoint_range_end = 130;
coarsegrained_data_input(plot_save_link_coarsetimed_MO, binXY_isotropicity_vs_area, binXY_expansionrate_vs_area, binXY_lnVarianceTessalation_vs_area, binXY_VarianceTessalation_vs_area, binXY_MeanInterdist_vs_area, binXY_NearNeighbdist_vs_area,...
    binXY_NewExistdist_vs_area, binXY_NewNewBBdist_vs_area, binXY_clumpingFactor_bbdensity_vs_area, binXY_clumpingFactor_meanint_vs_area, binXY_LocalClustering_vs_area, binXY_GlobalClustering_vs_area, breakpoint_range_start, breakpoint_range_end);
save(fullfile(plot_save_link_coarsetimed_MO, 'workspace_breakpoint_data'));
montage_saving(plot_save_link_coarsetimed_MO); % saving the montage
clear all;
fclose('all');

%% NBI Fine timed data
% control data
folder_finetimed_ctrl = uigetdir(pwd, 'Select the Result_Data folder for the fine timed data (Control condition)'); % select the "Result_Data" folder for Control condition
cd(folder_finetimed_ctrl);
load('workspace_A3_PlotMSDmean_new_RT.mat', 'binXY_alphaLongAvgTraj_area', 'binXY_alphaShortAvgTraj_area', 'binXY_transitionTimeAvgTraj_area', 'binXY_DiffStrengthAvgTraj_area');
mkdir '.\breakpoint_plots'; % making a folder for saving the plots
plot_save_link_finetimed_ctrl = strcat(folder_finetimed_ctrl, '.\breakpoint_plots'); % creating the link for saving the plots
% Fixing the breakpoint search window:
breakpoint_range_alphaLong_start = 20; breakpoint_range_alphaLong_end = 250;
breakpoint_range_alphaShort_start = 20; breakpoint_range_alphaShort_end = 250;
breakpoint_range_TransitionTime_start = 20; breakpoint_range_TransitionTime_end = 250;
breakpoint_range_diffStrength_start = 20; breakpoint_range_diffStrength_end = 250;
% calling the function for plotting
finetimed_data_input(plot_save_link_finetimed_ctrl, binXY_alphaLongAvgTraj_area, binXY_alphaShortAvgTraj_area, binXY_transitionTimeAvgTraj_area, binXY_DiffStrengthAvgTraj_area, breakpoint_range_alphaLong_start, breakpoint_range_alphaLong_end,...
    breakpoint_range_alphaShort_start, breakpoint_range_alphaShort_end, breakpoint_range_TransitionTime_start, breakpoint_range_TransitionTime_end, breakpoint_range_diffStrength_start, breakpoint_range_diffStrength_end);
save(fullfile(plot_save_link_finetimed_ctrl, 'workspace_breakpoint_data'));
montage_saving(plot_save_link_finetimed_ctrl); % saving the montage
clear all;
fclose('all');

%%
% MO data
folder_finetimed_MO = uigetdir(pwd, 'Select the Result_Data folder for the fine timed data (MO condition)'); % select the "Result_Data" folder for MO condition
cd(folder_finetimed_MO);
load('workspace_A3_PlotMSDmean_new_RT.mat', 'binXY_alphaLongAvgTraj_area', 'binXY_alphaShortAvgTraj_area', 'binXY_transitionTimeAvgTraj_area', 'binXY_DiffStrengthAvgTraj_area');
mkdir '.\breakpoint_plots'; % making a folder for saving the plots
plot_save_link_finetimed_MO = strcat(folder_finetimed_MO, '.\breakpoint_plots'); % creating the link for saving the plots
% Fixing the breakpoint search window:
breakpoint_range_alphaLong_start = 20; breakpoint_range_alphaLong_end = 250;
breakpoint_range_alphaShort_start = 20; breakpoint_range_alphaShort_end = 250;
breakpoint_range_TransitionTime_start = 20; breakpoint_range_TransitionTime_end = 215;
breakpoint_range_diffStrength_start = 20; breakpoint_range_diffStrength_end = 250;
% calling the function for plotting
finetimed_data_input(plot_save_link_finetimed_MO, binXY_alphaLongAvgTraj_area, binXY_alphaShortAvgTraj_area, binXY_transitionTimeAvgTraj_area, binXY_DiffStrengthAvgTraj_area, breakpoint_range_alphaLong_start, breakpoint_range_alphaLong_end,...
    breakpoint_range_alphaShort_start, breakpoint_range_alphaShort_end, breakpoint_range_TransitionTime_start, breakpoint_range_TransitionTime_end, breakpoint_range_diffStrength_start, breakpoint_range_diffStrength_end);
save(fullfile(plot_save_link_finetimed_MO, 'workspace_breakpoint_data'));
montage_saving(plot_save_link_finetimed_MO); % saving the montage
clear all;
fclose('all');

%% High resolution data
% Control
folder_highres_ctrl = uigetdir(pwd, 'Select the folder that contains the ánalysis workspace file that generated the plots for the High resolution data (Control condition)'); % select the "Result_Data" folder for Control condition
cd(folder_highres_ctrl);
load('workspace_high_res_data.mat', 'AvgActinInt_BBpos_x', 'AvgActinInt_BBpos_y', 'AvgActinInt_BBsur_x', 'AvgActinInt_BBsur_y', 'AvgActinInt_BBpossurRatio_x', 'AvgActinInt_BBpossurRatio_y', 'apicalArea_actin_intensity_x', 'apicalArea_actin_intensity_y', 'collective_actin_intensity_x', 'collective_actin_intensity_y', 'CDF25_x', 'CDF25_y', 'CDF50_x', 'CDF50_y', 'CDF75_x', 'CDF75_y');
mkdir './breakpoint_plots'; % making a folder for saving the plots
plot_save_link_highres_ctrl = strcat(folder_highres_ctrl, '/breakpoint_plots'); % creating the link for saving the plots
% Fixing the breakpoint search window:
breakpoint_range_bbpos_start = 150; breakpoint_range_bbpos_end = 280; % 120-250 % 50-280
breakpoint_range_bbsur_start = 150; breakpoint_range_bbsur_end = 280; % 120-250 % 120-280
breakpoint_range_bbposurratio_start = 70; breakpoint_range_bbposurratio_end = 250; % 85-175 % 70-250
breakpoint_range_apicalareaactinInt_start = 50; breakpoint_range_apicalareaactinInt_end = 280; % 120-250 % 50-280
breakpoint_range_collectiveIntRatio_start = 50; breakpoint_range_collectiveIntRatio_end = 250; % 100-145 % 50-250
breakpoint_range_cdf25_start = 50; breakpoint_range_cdf25_end = 250; % 85-175 % 50-250
breakpoint_range_cdf50_start = 50; breakpoint_range_cdf50_end = 250; % 85-175 % 50-250
breakpoint_range_cdf75_start = 70; breakpoint_range_cdf75_end = 250; % 85-175 % 70-280
% calling the function for plotting
highres_data_input(plot_save_link_highres_ctrl,[AvgActinInt_BBpos_x(~isnan(AvgActinInt_BBpos_x)), AvgActinInt_BBpos_y(~isnan(AvgActinInt_BBpos_y))], [AvgActinInt_BBsur_x(~isnan(AvgActinInt_BBsur_x)), AvgActinInt_BBsur_y(~isnan(AvgActinInt_BBsur_y))], [AvgActinInt_BBpossurRatio_x(~isnan(AvgActinInt_BBpossurRatio_x)), AvgActinInt_BBpossurRatio_y(~isnan(AvgActinInt_BBpossurRatio_y))],...
    [apicalArea_actin_intensity_x(~isnan(apicalArea_actin_intensity_x)), apicalArea_actin_intensity_y(~isnan(apicalArea_actin_intensity_y))], [collective_actin_intensity_x(~isnan(collective_actin_intensity_x)), collective_actin_intensity_y(~isnan(collective_actin_intensity_x))], [CDF25_x(~isnan(CDF25_x)), CDF25_y(~isnan(CDF25_x))], [CDF50_x(~isnan(CDF50_x)), CDF50_y(~isnan(CDF50_x))], [CDF75_x(~isnan(CDF75_x)), CDF75_y(~isnan(CDF75_x))],...
    breakpoint_range_bbpos_start, breakpoint_range_bbpos_end, breakpoint_range_bbsur_start, breakpoint_range_bbsur_end, breakpoint_range_bbposurratio_start, breakpoint_range_bbposurratio_end,...
    breakpoint_range_apicalareaactinInt_start, breakpoint_range_apicalareaactinInt_end, breakpoint_range_collectiveIntRatio_start, breakpoint_range_collectiveIntRatio_end, breakpoint_range_cdf25_start, breakpoint_range_cdf25_end, breakpoint_range_cdf50_start, breakpoint_range_cdf50_end, breakpoint_range_cdf75_start, breakpoint_range_cdf75_end);
save(fullfile(plot_save_link_highres_ctrl, 'workspace_breakpoint_data'));
montage_saving(plot_save_link_highres_ctrl); % saving the montage
clear all;
fclose('all');

%%
% MO
folder_highres_MO = uigetdir(pwd, 'Select the folder that contains the ánalysis workspace file that generated the plots for the High resolution data (MO condition)'); % select the "Result_Data" folder for MO condition
cd(folder_highres_MO);
load('workspace_high_res_data.mat', 'AvgActinInt_BBpos_x', 'AvgActinInt_BBpos_y', 'AvgActinInt_BBsur_x', 'AvgActinInt_BBsur_y', 'AvgActinInt_BBpossurRatio_x', 'AvgActinInt_BBpossurRatio_y', 'apicalArea_actin_intensity_x', 'apicalArea_actin_intensity_y', 'collective_actin_intensity_x', 'collective_actin_intensity_y', 'CDF25_x', 'CDF25_y', 'CDF50_x', 'CDF50_y', 'CDF75_x', 'CDF75_y');
mkdir './breakpoint_plots'; % making a folder for saving the plots
plot_save_link_highres_MO = strcat(folder_highres_MO, '/breakpoint_plots'); % creating the link for saving the plots
% Fixing the breakpoint search window:
breakpoint_range_bbpos_start = 50; breakpoint_range_bbpos_end = 180; 
breakpoint_range_bbsur_start = 50; breakpoint_range_bbsur_end = 180;
breakpoint_range_bbposurratio_start = 50; breakpoint_range_bbposurratio_end = 180;
breakpoint_range_apicalareaactinInt_start = 50; breakpoint_range_apicalareaactinInt_end = 180; 
breakpoint_range_collectiveIntRatio_start = 50; breakpoint_range_collectiveIntRatio_end = 180;
breakpoint_range_cdf25_start = 50; breakpoint_range_cdf25_end = 220;
breakpoint_range_cdf50_start = 50; breakpoint_range_cdf50_end = 200; 
breakpoint_range_cdf75_start = 80; breakpoint_range_cdf75_end = 220;
% calling the function for plotting
highres_data_input(plot_save_link_highres_MO,[AvgActinInt_BBpos_x(~isnan(AvgActinInt_BBpos_x)), AvgActinInt_BBpos_y(~isnan(AvgActinInt_BBpos_y))], [AvgActinInt_BBsur_x(~isnan(AvgActinInt_BBsur_x)), AvgActinInt_BBsur_y(~isnan(AvgActinInt_BBsur_y))], [AvgActinInt_BBpossurRatio_x(~isnan(AvgActinInt_BBpossurRatio_x)), AvgActinInt_BBpossurRatio_y(~isnan(AvgActinInt_BBpossurRatio_y))],...
    [apicalArea_actin_intensity_x(~isnan(apicalArea_actin_intensity_x)), apicalArea_actin_intensity_y(~isnan(apicalArea_actin_intensity_y))], [collective_actin_intensity_x(~isnan(collective_actin_intensity_x)), collective_actin_intensity_y(~isnan(collective_actin_intensity_x))], [CDF25_x(~isnan(CDF25_x)), CDF25_y(~isnan(CDF25_x))], [CDF50_x(~isnan(CDF50_x)), CDF50_y(~isnan(CDF50_x))], [CDF75_x(~isnan(CDF75_x)), CDF75_y(~isnan(CDF75_x))],...
    breakpoint_range_bbpos_start, breakpoint_range_bbpos_end, breakpoint_range_bbsur_start, breakpoint_range_bbsur_end, breakpoint_range_bbposurratio_start, breakpoint_range_bbposurratio_end,...
    breakpoint_range_apicalareaactinInt_start, breakpoint_range_apicalareaactinInt_end, breakpoint_range_collectiveIntRatio_start, breakpoint_range_collectiveIntRatio_end, breakpoint_range_cdf25_start, breakpoint_range_cdf25_end, breakpoint_range_cdf50_start, breakpoint_range_cdf50_end, breakpoint_range_cdf75_start, breakpoint_range_cdf75_end);
save(fullfile(plot_save_link_highres_MO, 'workspace_breakpoint_data'));
montage_saving(plot_save_link_highres_MO); % saving the montage
clear all;
fclose('all');

disp('finished !');

%% Function for plotting the coarse timed data

function coarsegrained_data_input(save_link, isotropicity, expansion_rate, ln_variance_tessalation, Variance_tessalation, mean_interdist, nearest_neighbour_dist, NewExistdist, NewNewBBdist, clumpingFactor_bbdensity, clumpingFactor_actinmeanint, local_clustering, global_clustering, breakpoint_range_start, breakpoint_range_end)

% opening a text file to write the summary of all piecewise fit details for all parameters
txt_file = fullfile(save_link, 'Piecewise_fit_summary.txt');
fid = fopen(txt_file, 'a');
fprintf(fid, '\n--- PIECEWISE FIT SUMMARY ---\n');

% isotropicity
input_x = vertcat(isotropicity{:,1}); input_y = vertcat(isotropicity{:,2}); YLabel = 'Isotropicity'; Title = 'Isotropicity vs Area'; save_title = 'isotropicity';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_start, breakpoint_range_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% area expansion rate
input_x = vertcat(expansion_rate{:,1}); input_y = vertcat(expansion_rate{:,2}); YLabel = 'Area expansion rate [\mum^2 min^{-1}]'; Title = 'Expansion rate vs Area'; save_title = 'expansionrate';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_start, breakpoint_range_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% log of variance in tessalation area
input_x = vertcat(ln_variance_tessalation{:,1}); input_y = vertcat(ln_variance_tessalation{:,2}); YLabel = 'ln(variance) (normalised)'; Title = 'log of variance in tessalation area  vs area'; save_title = 'lnVarianceTessalation';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_start, breakpoint_range_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Variance in tessalation area
input_x = vertcat(Variance_tessalation{:,1}); input_y = vertcat(Variance_tessalation{:,2}); YLabel = 'Variance (normalised by MeanArea squared)'; Title = 'Variance in tessalation area  vs area'; save_title = 'VarianceTessalation';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_start, breakpoint_range_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Mean interdistance
input_x = vertcat(mean_interdist{:,1}); input_y = vertcat(mean_interdist{:,2}); YLabel = 'Mean interdistance [\mum]'; Title = 'BB mean interdistance (density based) vs Area'; save_title = 'MeanInterdist';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_start, breakpoint_range_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Nearest Neighbor distance
input_x = vertcat(nearest_neighbour_dist{:,1}); input_y = vertcat(nearest_neighbour_dist{:,2}); YLabel = 'Nearest Neighbor distance [\mum]'; Title = 'Nearest neighbor distance vs Area'; save_title = 'NearestNeighbordist';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_start, breakpoint_range_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% distances between new & already exiting BBs
input_x = vertcat(NewExistdist{:,1}); input_y = vertcat(NewExistdist{:,2}); YLabel = 'Minimum BB appearance distance [\mum]'; Title = {'Min BB appearance distance', '(new & already existing BB) vs Area'}; save_title = 'MinBBappearance_New_already_BB_dist';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_start, breakpoint_range_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% distances between new BBs in current & previous frames
input_x = vertcat(NewNewBBdist{:,1}); input_y = vertcat(NewNewBBdist{:,2}); YLabel = 'Minimum BB appearance distance [\mum]'; Title = {'Min BB appearance distance', '(new & new BB) vs Area'}; save_title = 'MinBBappearance_NewNew_BB_dist';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_start, breakpoint_range_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% clumping factor (BB density)
input_x = vertcat(clumpingFactor_bbdensity{:,1}); input_y = vertcat(clumpingFactor_bbdensity{:,2}); YLabel = 'Clumping Factor (BB density)'; Title = {'Clumping factor (bb density) vs Area'}; save_title = 'clumping factor_bbdensity';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_start, breakpoint_range_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% clumping factor (Actin mean int.)
input_x = vertcat(clumpingFactor_actinmeanint{:,1}); input_y = vertcat(clumpingFactor_actinmeanint{:,2}); YLabel = 'Clumping Factor (Actin Mean Int.)'; Title = {'Clumping factor (Actin Mean Int) vs Area'}; save_title = 'clumping factor_ActinMeanInt';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_start, breakpoint_range_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Local Clustering index
input_x = vertcat(local_clustering{:,1}); input_y = vertcat(local_clustering{:,2}); YLabel = 'Local clustering index'; Title = {'Local clustering index vs Area'}; save_title = 'Local_clustering_index';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_start, breakpoint_range_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Global Clustering index
input_x = vertcat(global_clustering{:,1}); input_y = vertcat(global_clustering{:,2}); YLabel = 'Global clustering index'; Title = {'Global clustering index vs Area'}; save_title = 'Global_clustering_index';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_start, breakpoint_range_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% saving and closing the text file
fclose(fid);

end

%% Function for plotting the NBI fine timed data

function finetimed_data_input(save_link, alphaLongAvgTraj, alphaShortAvgTraj, transitionTimeAvgTraj, DiffStrengthlongAvgTraj, breakpoint_range_alphaLong_start, breakpoint_range_alphaLong_end,...
    breakpoint_range_alphaShort_start, breakpoint_range_alphaShort_end, breakpoint_range_TransitionTime_start, breakpoint_range_TransitionTime_end, breakpoint_range_diffStrength_start, breakpoint_range_diffStrength_end)

% opening a text file to write the summary of all piecewise fit details for all parameters
txt_file = fullfile(save_link, 'Piecewise_fit_summary.txt');
fid = fopen(txt_file, 'a');
fprintf(fid, '\n--- PIECEWISE FIT SUMMARY ---\n');

% alpha value Long (Avg trajectories)
input_x = [alphaLongAvgTraj{:,1}]'; input_y = [alphaLongAvgTraj{:,2}]'; YLabel = '\alpha value'; Title = 'Alpha value long (Avg trajectories) vs Area'; save_title = 'alphaLongAvgTraj';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_alphaLong_start, breakpoint_range_alphaLong_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% alpha value Short (Avg trajectories)
input_x = [alphaShortAvgTraj{:,1}]'; input_y = [alphaShortAvgTraj{:,2}]'; YLabel = '\alpha value'; Title = 'Alpha value short (Avg trajectories) vs Area'; save_title = 'alphaShortAvgTraj';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_alphaShort_start, breakpoint_range_alphaShort_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Transition time (Avg trajectories)
input_x = [transitionTimeAvgTraj{:,1}]'; input_y = [transitionTimeAvgTraj{:,2}]'; YLabel = 'Transition time [s]'; Title = {'Transition time (after averaging', 'across trajectories) vs Area'}; save_title = 'TransitionTimeAvgTraj';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_TransitionTime_start, breakpoint_range_TransitionTime_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Diffusion strength Long (Avg trajectories)
input_x = [DiffStrengthlongAvgTraj{:,1}]'; input_y = [DiffStrengthlongAvgTraj{:,2}]'; YLabel = 'Diff. Strength. [\mum^2 min^{-1}]'; Title = {'Diffusion strength long (after averaging', 'across trajectories) vs Area'}; save_title = 'DiffStrengthAvgTraj';
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_diffStrength_start, breakpoint_range_diffStrength_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% saving and closing the text file
fclose(fid);

end

%% Function for plotting the High resolution data

function highres_data_input(save_link, AvgActinInt_BBpos_input, AvgActinInt_BBsur_input, AvgActinInt_BBpossurRatio_input, apicalArea_actin_intensity_input, collective_actin_intensity_input, CDF25_input, CDF50_input, CDF75_input, ...
    breakpoint_range_bbpos_start, breakpoint_range_bbpos_end, breakpoint_range_bbsur_start, breakpoint_range_bbsur_end, breakpoint_range_bbposurratio_start, breakpoint_range_bbposurratio_end, breakpoint_range_apicalareaactinInt_start, breakpoint_range_apicalareaactinInt_end, ...
    breakpoint_range_collectiveIntRatio_start, breakpoint_range_collectiveIntRatio_end, breakpoint_range_cdf25_start, breakpoint_range_cdf25_end, breakpoint_range_cdf50_start, breakpoint_range_cdf50_end, breakpoint_range_cdf75_start, breakpoint_range_cdf75_end)

% opening a text file to write the summary of all piecewise fit details for all parameters
txt_file = fullfile(save_link, 'Piecewise_fit_summary.txt');
fid = fopen(txt_file, 'a');
fprintf(fid, '\n--- PIECEWISE FIT SUMMARY ---\n');

% Averaged actin intensity at the position of BBs vs area
% This averaged actin intensity (normalised) of the BB position is obtained by collecting  the intensities of actin at BB position of all BBs in a apical domain and by taking the average of these intensities; this is a bit different from "actinInt_atBBpos_norm" where the ROI itself includes all the BBs (i.e. BB position) and then imageJ already collects the average instead of performing the average after collecting from multiple BB ROIs. But these values will be more or less the same.
input_x = AvgActinInt_BBpos_input(:,1); input_y = AvgActinInt_BBpos_input(:,2); YLabel = 'Actin intensity at BB pos (normalised)'; Title = {'Averaged actin intensity of apical domain', 'at the position of BBs (normalised)'}; save_title = 'avgActinIntBBpos';
% input_x = input_x(~isnan(input_x)); input_y = input_y(~isnan(input_x)); 
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_bbpos_start, breakpoint_range_bbpos_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Averaged actin intensity in the surrounding BB position vs area
% This averaged actin intensity (normalised) from the surrounding BB position; this is obtained by collecting  the intensities of actin in the surrounding regions of all BBs in a apical domain and by taking the average of these intensities; this is different from "actinInt_ExcludingBB_norm" where all the areas other than BBs are used for getting the averaged intensity. Whereas here, only the immediate surrounding regions i.e. donuts are included.
input_x = AvgActinInt_BBsur_input(:,1); input_y = AvgActinInt_BBsur_input(:,2); YLabel = 'Actin intensity surrounding BB (normalised)'; Title = {'Averaged actin intensity of apical domain', 'surrounding the BBs (normalised)'}; save_title = 'avgActinIntBBsur';
% input_x = input_x(~isnan(input_x)); input_y = input_y(~isnan(input_x)); 
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_bbsur_start, breakpoint_range_bbsur_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Ratio of Averaged actin intensity in the surrounding to the actin intensity at the BB position vs area
% average of the ratio of "avg_actinInt_BBSurr_norm" / "avg_actinInt_BBpos_norm".
input_x = AvgActinInt_BBpossurRatio_input(:,1); input_y = AvgActinInt_BBpossurRatio_input(:,2); YLabel = 'Ratio of actin intensity from surrounding to BB position'; Title = {'Ratio of Averaged actin intensity of apical domain', 'btw surrounding to BB position (normalised)'}; save_title = 'avgActinIntBBpossurRatio';
% input_x = input_x(~isnan(input_x)); input_y = input_y(~isnan(input_x)); 
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_bbposurratio_start, breakpoint_range_bbposurratio_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Ratio of whole apical area mean actin intensities
input_x = apicalArea_actin_intensity_input(:,1); input_y = apicalArea_actin_intensity_input(:,2); YLabel = 'Whole apical area actin intensity'; Title = {'Whole apical Area Actin Intensity', '(normalised) vs Area'}; save_title = 'ApicalAreaactinInt';
% input_x = input_x(~isnan(input_x)); input_y = input_y(~isnan(input_x)); 
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_apicalareaactinInt_start, breakpoint_range_apicalareaactinInt_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Ratio of collective mean actin intensities
input_x = collective_actin_intensity_input(:,1); input_y = collective_actin_intensity_input(:,2); YLabel = 'Ratio of actin intensities'; Title = {'Ratio of Actin intensity (collective mean intensities', 'of "at BB position" & "all area excluding BBs") vs Area'}; save_title = 'actinInt';
% input_x = input_x(~isnan(input_x)); input_y = input_y(~isnan(input_x)); 
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_collectiveIntRatio_start, breakpoint_range_collectiveIntRatio_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Ratio of CDF 25
input_x = CDF25_input(:,1); input_y = CDF25_input(:,2); YLabel = 'Ratio of CDF at 25 %'; Title = {'Ratio of CDF at 25 % ("at BB position" & ,' '"surrounding BB regions i.e. donuts") vs Area'}; save_title = 'CDF25';
% input_x = input_x(~isnan(input_x)); input_y = input_y(~isnan(input_x)); 
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_cdf25_start, breakpoint_range_cdf25_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Ratio of CDF 50
input_x = CDF50_input(:,1); input_y = CDF50_input(:,2); YLabel = 'Ratio of CDF at 50 %'; Title = {'Ratio of CDF at 50 % ("at BB position" & ,' '"surrounding BB regions i.e. donuts") vs Area'}; save_title = 'CDF50';
% input_x = input_x(~isnan(input_x)); input_y = input_y(~isnan(input_x)); 
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_cdf50_start, breakpoint_range_cdf50_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% Ratio of CDF 75
input_x = CDF75_input(:,1); input_y = CDF75_input(:,2); YLabel = 'Ratio of CDF at 75 %'; Title = {'Ratio of CDF at 75 % ("at BB position" & ,' '"surrounding BB regions i.e. donuts") vs Area'}; save_title = 'CDF75';
% input_x = input_x(~isnan(input_x)); input_y = input_y(~isnan(input_x)); 
piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_cdf75_start, breakpoint_range_cdf75_end, YLabel, Title, save_title, fid, save_link);
clear input_x input_y

% saving and closing the text file
fclose(fid);

end

%% Function for finding the Piecewise Fit at best breakpoint
% This script identifies the best breakpoint within a given range and provides a sumary of slopes for both fits.

function [best_bp, slope1, slope2, pvalue_breakpoint, sse_breakpoint] = piecewise_fit_at_breakpoint (input_x, input_y, breakpoint_range_start, breakpoint_range_end, YLabel, Title, save_title, fid, save_link)

% Fetching data
x = input_x; % Sample x data used for verification: linspace(50, 350, 200)';
y = input_y; % Sample y data used for verification where change is introduced at the value 150: [0.6*x(x<150); 0.6*150 + 0.2*(x(x>=150)-150)] + randn(size(x))*10;  

% Setting the range to search for a breakpoint 
candidate_bps = breakpoint_range_start:1:breakpoint_range_end;
sse_all = zeros(size(candidate_bps)); % preallocation for SSE
pvals = zeros(size(candidate_bps)); % preallocation for pvalue
slopes_before = zeros(size(candidate_bps)); % preallocation for the first slope
slopes_after = zeros(size(candidate_bps)); % preallocation for the second slope

%Looping through each candidate breakpoint and fitting a piecewise linear model
for i = 1:length(candidate_bps)
    bp = candidate_bps(i);
    
    % getting the predictors: x1 is just x, x2 is (x - bp) if x > bp, else 0
    x1 = x;
    x2 = max(0, x - bp);
    
    % getting the matrix for piecewise linear fit
    X = [ones(size(x1)), x1, x2];
    
    % fitting the model using linear regression
    b = X \ y;
    
    % getting the fitted values
    yfit = X * b;
    
    % Saving the sum of squared errors (SSE) for this fit
    sse_all(i) = sum((y - yfit).^2);
    
    % getting the slopes before and after the breakpoint
    slopes_before(i) = b(2);
    slopes_after(i) = b(2) + b(3);
    
    % fitting the linear model to extract p-value of slope change
    tbl = table(y, x1, x2); % assembling the data into a table format where y, and x before breakingpoint (x1) and y after breakingpoint (x2) are stored as individual columns
    mdl = fitlm(tbl, 'y ~ x1 + x2'); % fitting the data in the table using the equation: y = mx + m1(x-breakpoint) + c
    pvals(i) = mdl.Coefficients.pValue(3);  % p-value for slope change (x2)
end

% finding the best breakpoint with lowest SSE
[~, idx_best] = min(sse_all); % lowest SSE
best_bp = candidate_bps(idx_best); % finding the best breakpoint using the index of the lowest SSE

% getting the fit with best breakpoint
x1 = x;
x2 = max(0, x - best_bp);
X = [ones(size(x)), x1, x2];
b = X \ y;
yfit = X * b;

% sorting the data for smooth plotting
[sorted_x, sort_idx] = sort(x);
sorted_yfit = yfit(sort_idx);

% getting the slopes
slope1 = b(2); % slope of the first fit (of the first portion of the plot before the breakpoint)
slope2 = b(2) + b(3); % slope of the second fit (of the second portion of the plot after the breakpoint)

% all plots
% plotting the SSE & p values
figure(1); 
subplot(2,1,1);
plot(candidate_bps, sse_all, 'b-o', 'LineWidth', 2);
xlabel('Breakpoint (µm²)'); ylabel('SSE');
title(Title, '(Fit Quality (SSE) vs. Breakpoint)'); grid on;
xline(best_bp, '--r', 'Best');

subplot(2,1,2);
plot(candidate_bps, pvals, 'm-o', 'LineWidth', 2);
xlabel('Breakpoint (µm²)'); ylabel('p-value for slope change');
title(Title, '(Significance of Slope Change)'); box on; grid on;
yline(0.05, '--k', 'p=0.05');
xline(best_bp, '--r', 'Best'); save_title_sse_pvalue = strcat(save_title, '_sse_', 'pvalue');
saveas(gcf, fullfile(save_link, save_title_sse_pvalue), 'fig'); saveas(gcf, fullfile(save_link, save_title_sse_pvalue), 'tif');

% plotting the fits
figure(2);
scatter(x, y, 20, 'k', 'filled'); hold on; % rawdata
plot(sorted_x, sorted_yfit, 'r--', 'LineWidth', 2);  % continuous fit line

% plotting the piecewise segments as solid lines
% getting the x&y coordinates for the fit before & after the breakpoint
x_before = x(x <= best_bp);
x_after = x(x > best_bp);
y_before = b(1) + b(2)*x_before; 
y_after = b(1) + b(2)*x_after + b(3)*(x_after - best_bp);
plot(x_before, y_before, 'b-', 'LineWidth', 2); % plotting the fit for the portion before the breakpoint
plot(x_after, y_after, 'g-', 'LineWidth', 2); % plotting the fit for the portion beyond the breakpoint

% annotations
xline(best_bp, '--r', ['Breakpoint = ', num2str(best_bp), ' µm²']); % drawing a vertical line at the breakpoint
legend('Data', 'Piecewise Fit', 'Segment 1', 'Segment 2'); xlabel('Area [µm²]'); ylabel(YLabel); title(Title); box on; % grid on;
saveas(gcf, fullfile(save_link, save_title), 'fig'); saveas(gcf, fullfile(save_link, save_title), 'tif');

% Saving & writing the summary
fprintf(fid, strcat('\n', YLabel));
fprintf(fid, '\nBest Breakpoint: %.2f µm²\n', best_bp);
fprintf(fid, 'Slope Before Breakpoint: %.4f\n', slope1);
fprintf(fid, 'Slope After Breakpoint: %.4f\n', slope2);
pvalue_breakpoint = pvals(idx_best);
fprintf(fid, 'Slope Change p-value: %.4f\n', pvals(idx_best));
sse_breakpoint = sse_all(idx_best);
fprintf(fid, 'SSE at Best Fit: %.2f\n', sse_all(idx_best));

close all;

end

%% Saving the figures as montage

function montage_saving(save_link)
cd(save_link);
delete('montage.tif'); % deleting the montage file in case it exists; Because, if the montage exists and we make a new montage, since the existing montage is also a.tif file, this will also be included in the new montage

Tif_filelist = dir(fullfile(save_link, '*.tif')); % getting the list of all .tif files in the folder
tifile_count = length(Tif_filelist);
tif_stack = cell(1, tifile_count); % preallocation

for i = 1:tifile_count
    tif_filepath = fullfile(save_link, Tif_filelist(i).name); % getting the .tif files one-by-one
    tif_stack{i} = imread(tif_filepath); % storing each image in the preallocated cell array 
end

montage(tif_stack); % make montage of all the images stored in the cell array
saveas(gcf, fullfile(save_link,'montage'), 'tif'); 
close all;

end

%%