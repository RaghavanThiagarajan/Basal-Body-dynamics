% This is the run file to control and run all the analysis and plots for
% the BB analysis. This sscript is execued in 3 steps: 
% (1) The whole ROI and discretized ROI properties are plotted along with different properties for individual trajectories; 
% (2) Only those analysis/plots for BB trajectories longer than 40 min are executed; 
% (3) Then all BB trajectories are analysed and plotted (this means those BB trajectories that are at leas 4 min in length)

%% Initial characterisation plots - filtered trajectories
run('Gradients_BB_int_normalization_by_cortex_Traj_after_filtering');

%% Crosscorrelation - filtered trajectories
run('crosscorrelation_Traj_after_filtering');

%% t0 plots - filtered trajectories
run('t0_plot_Traj_filtered');

%% tend plots - filtered trajectories
run('tend_plot_Traj_filtered');

%% Initial characterisation plots - all trajectories
run('Gradients_BB_int_normalization_by_cortex_all');

%% Crosscorrelation - all trajectories
run('crosscorrelation_all');

%% t0 plots - all trajectories
run('t0_plot_all');

%% tend plots - all trajectories
run('tend_plot_all');

%% Tessalation
run('tessalation_areas');

%% Drift quantification
run('drift_mandar');

%% BB distances (new BB & existing BBs)
run('bb_appearance_distance_location');

%% MSD data coarsegrained
run('msd_coarsegrained');

%% x-y step distances 
run('xy_step_distance_plots');

%% BB mean interdistance from density
run('bb_mean_inter_distance');

%% Quadrant analysis
run('area_expansion_bbdensity_bias');

%% Reconstructing the trajectories
run('trajectory_reconstruct');

%% Plotting t0 & tend BB position in images
clc
disp('Run the .ijm script: "t0_&_tend_basalbody_position_MIP.ijm"; Then press a key !');
pause;

%%
clc
disp('All Analysis Complete !');

%%


