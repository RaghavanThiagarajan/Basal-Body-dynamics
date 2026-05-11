% Raghavan Thiagarajan, 25th April 2023, reNEW, Copenhagen

% This script computes the Mean Squared Displacement (MSD) for the coarse grained data. We call the data from the confocal imaging as
% coarse grained since the time interval for confocal imaging is either 30 s or 1 min. On the other hand the High speed imaging data is called
% fine timed data since the time interval is roughly 20 ms.

% This script is inspired from the following links:
% (1) https://stackoverflow.com/questions/7489048/calculating-mean-squared-displacement-msd-with-matlab
% (2) https://chemistry.stackexchange.com/questions/106906/how-can-i-get-self-diffusion-coefficient-from-msd-mean-sqaure-displacement
% (3) https://measurebiology.org/wiki/Calculating_MSD_and_Diffusion_Coefficients

% Here we calculate the MSD for all the BB trajectories in every cell and plot them in both standard and log-log formats. Then the Diffusion coefficient is obtained
% by dividing the msd value by 4t. We also obtain the MSD uncertainty. Finally we plot the average MSD plots and also obtain the average diffusion coefficient for all trajectories.

clc
clear all
close all

mkdir '../Plots/msd_plots_coarsegrained_data'
BB_apical_msd = '../Plots/msd_plots_coarsegrained_data';

% loading parameters from the workspace of other scripts; Trajectory_data is the cell array where all the trajectory related details like trajectory number, frame number and x & y coordinates are stored
load('workspace_interim', 'pixelwidth', 'Image_dime', 'Trajectory_data', 'no_of_trajectories', 'traj_filter_duration');
% pre-assigning a new cell array where we will store the diffusion coefficients, all the msd and related details
time_Interval = Image_dime(1,5); % getting the time interval in seconds; Check the section in "Gradients_BB_int_normalization_by_cortex_Traj_after_filtering.m" script where image dimensions including time interval is obtained. 
trajectories = cell(1, no_of_trajectories);
longestTrajectory = 0; % initial value
k = 0; % initial value

% this for loop goes through all the trajectories one-by-one and then to obtain the msd
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
        temp_traj = Trajectory_data(trajno,:); % temporary storage of all details for the updated trajectory number 'trajno'
        no_of_steps = size(temp_traj{1,1},1); % total number of time points for for this trajectory        
        trajectories{trajno_updated} = struct(); % assigning a structure array for the storage of msd and related details
        no_of_msds = no_of_steps-1; % number of msds to be obtained for the trajectory
        trajectories{trajno_updated}.msd = zeros(1, no_of_msds); % pre-assignment
        trajectories{trajno_updated}.msduncertainity = zeros(1, no_of_msds); % pre-assignment
        trajectories{trajno_updated}.no = no_of_msds; % pre-assignment
        trajectories{trajno_updated}.TimeInterval = time_Interval; % time interval of this particular experiment / cell
        % this for loop goes through every step / timepoint within the trajecotry 'trajno' and obtains the x & y coordinates to calculate the msd.
        for lagtime = 1:no_of_msds
            dx = temp_traj{1,3}(1:1:end-lagtime) - temp_traj{1,3}(lagtime+1:1:end); % x coordinate
            dx = dx * pixelwidth; % conversion to micrometers
            dy = temp_traj{1,4}(1:1:end-lagtime) - temp_traj{1,4}(lagtime+1:1:end); % y coordinate
            dy = dy * pixelwidth; % conversion to micrometers
            squared_displacement = dx.^2 + dy.^2; % squared displacement
            msd = mean(squared_displacement); % mean of squared displacement
            trajectories{trajno_updated}.msd(lagtime) = msd; % storing the msd
            trajectories{trajno_updated}.msduncertainity(lagtime) = std(squared_displacement) / sqrt(length(squared_displacement)); % uncertainty for the msd            
        end        
        longestTrajectory = max(longestTrajectory, no_of_steps); % finding the longest BB trajectory
        xaxis = (1:no_of_msds)*time_Interval; yaxis = trajectories{trajno_updated}.msd(1:no_of_msds); greycolor = [0.7, 0.7, 0.7]; % defining the x and y axis and the color for the plot
        figure(1); 
        loglog(xaxis, yaxis, 'Color', greycolor); hold on; % plotting the msd in log-log format
        % the function below gets both the alpha value and the diffusion coefficient for all the plots; the diffusion coefficient is obtained by two means: (1) from the y intercept of the slope of MSD plot in log
        % space (diff_coeff_fit) & (2) from the first MSD value (diff_coef_direct). For more details look at the function
        [~, ~, alpha_value, diff_coeff_fit, diff_coef_direct] = msd_logplot_fitting(xaxis, yaxis, time_Interval); % calling the function for plot fitting
        trajectories{trajno_updated}.DiffusionCoefficient_direct = diff_coef_direct; % diffusion coefficient from the first MSD value
        trajectories{trajno_updated}.DiffusionCoefficient_fitting = diff_coeff_fit; % diffusion coefficient from the yintercept of the fit of the MSD plot in log space
        trajectories{trajno_updated}.alpha_value = alpha_value; % alpha value from the slope of the fit of the MSD plot in log space
        figure(2); 
        xaxis_min = xaxis / 60; % converting the time units to minutes for plotting the standard plot
        std_plot = plot(xaxis_min, yaxis, 'r', 'LineWidth', 0.01); hold on; % plotting the msd in standard format; this command "std_plot.Color(4)=0.1;" can be used for setting the opacity for the lines
        clear temp_traj;
    end
end
clear no_of_msds xaxis yaxis
trajectories_mod = trajectories(~cellfun(@isempty, trajectories)); % reassigning the "trajectories" cell array after removing all the empty arrays. The empty arrays are created because those trajectories 
% less than "traj_filter_duration" are not analysed. The difference in the count (between the analysed and un-analysed trajectories) will be entered as empty arrays. These empty arrays are removed here.
no_of_trajectories = length(trajectories_mod); % obtaining the number of trajectories that were analysed
%%
% below we obtain the average msd for all the trajectories
dif_Coef_direct = zeros(1, no_of_trajectories); % pre-assignment
dif_Coef_fit = zeros(1, no_of_trajectories); % pre-assignment
sum_of_msd = zeros(1, longestTrajectory); % pre-assignment
sum_of_msd_count = zeros(1, longestTrajectory); % pre-assignment
% the for loop goes through all the trajectories and sums the msd values so that an average can be obtained
for trajno = 1:no_of_trajectories % note that the trajno here goes through the updated value of "no_of_trajectories"; so it will not take the same values as "trajno" in the above "for loop"
    no_of_msds = length(trajectories_mod{trajno}.msd); % number of msd
    dif_Coef_direct(trajno) = trajectories_mod{trajno}.DiffusionCoefficient_direct; % fetching and storing the diffusion coefficients (from the first MSD value) of all trajectories
    dif_Coef_fit(trajno) = trajectories_mod{trajno}.DiffusionCoefficient_fitting; % fetching and storing the diffusion coefficients (from y intercept of the slope of MSD plot) of all trajectories
    sum_of_msd(1:no_of_msds) = sum_of_msd(1:no_of_msds) + trajectories_mod{trajno}.msd; % getting the sum of msds of all trajectories
    sum_of_msd_count(1:no_of_msds) = sum_of_msd_count(1:no_of_msds) + 1; % getting the msd counts
end

averageMSD = sum_of_msd ./ sum_of_msd_count; % average msd
avg_Diff_Coeff_direct = mean(dif_Coef_direct); % average of diffusion coefficients for all the trajectories in this cell
avg_Diff_Coeff_direct_uncertainty = std(dif_Coef_direct) / sqrt(length(dif_Coef_direct)); % average msd uncertainty
avg_Diff_Coeff_fit = mean(dif_Coef_fit); % average of diffusion coefficients for all the trajectories in this cell
avg_Diff_Coeff_fit_uncertainity = std(dif_Coef_fit) / sqrt(length(dif_Coef_fit)); % average msd uncertainity
% Below we get the diffusion strength by normalising the diffusion coefficient because, the slope / alpha values of the plots have a wide range between 0 - 1.5 i.e. from sub diffusive to super diffusive regimes. Depending on the
% range, the alpha value will change. since the alpha value changes, the units of diffusion coefficient will also change. Because the formula is MSD = 4Dt^alpha. When the regime is diffusion, then alpha = 1 and
% hence MSD = 4Dt^1 and consequently the units of t is seconds. However when the regime changes to sub diffusion (for ex. = 0.5) or super diffusion (for ex. = 1.5), then alpha becomes a fraction and hence MSD = 4Dt^fraction and consequently the
% unit of t is second^(0.5 or 1.5). Hence the units of diffusion coefficients are not anymore µm^2 per second but µm^2 per second^(some fraction). Now if we combine the diffusion coefficients of different trajectories with different regimes,
% then we are combining values with different units which is not the right thing to do. Therefore, we have to normalise the diffusion coefficient by multiplying it with some 'time parameter'. So in the coarse timed data, we multiply it
% by the frame interval. Multiplying by the frame interval brings the unit back to 'per second'. But the fraction needs to be taken care of. So we multiply by (frame interval^(alpha-1)). 
% So wherever we are supposed to use the diffusion coefficient, it is not right to use the diffusion coefficients but normalised diffusion coefficent which we can call as diffusion strength or transport coefficient. For further clarification, 
% check the pdf (MSD_6) in science tid bits folder.
alpha_val_vector = cellfun(@(x) x.alpha_value, trajectories_mod); % storing all the alpha values into a vector
diffusion_strength_fit = dif_Coef_fit .* (time_Interval .^ (alpha_val_vector-1)); % this is the normalised diffusion coefficient. Here, the normalisation is done with the time interval. So the units become µm2/s.
avg_Diff_strength_fit = mean(diffusion_strength_fit); % average of diffusion strength for all the trajectories in this cell

figure(1);
xaxis = (1:longestTrajectory) * time_Interval; yaxis = averageMSD;
loglog(xaxis, yaxis, 'k', 'LineWidth', 1); % log-log plot
hold on;
% the function below gets both the alpha value and the diffusion coefficient for the Average plot; the diffusion coefficient is obtained by two means: (1) from the y intercept of the slope of MSD plot in log
% space (diff_coeff_fit_avg) & (2) from the first MSD value (diff_coef_direct_avg). For more details look at the function
[x_for_fit_avg, y_from_fit_model_lin_avg, alpha_value, diff_coeff_fit, diff_coef_direct] = msd_logplot_fitting(xaxis, yaxis, time_Interval); % calling the function for plot fitting & getting the alpha value & diffusion coefficient
loglog(x_for_fit_avg, y_from_fit_model_lin_avg, 'r-', 'LineWidth', 1.5); % plotting the fit
xlabel('Time [s]'); ylabel('MSD [\mum^2]'); title('MSD for coarsegrained data log-log plot');
saveas(gcf, fullfile(BB_apical_msd, 'MSD_coarsegrained_data_log_log_plot'), 'fig'); saveas(gcf, fullfile(BB_apical_msd, 'MSD_coarsegrained_data_log_log_plot'), 'tif');

figure(2);
xaxis_min = xaxis / 60; % converting the time units to minutes for plotting the standard plot
plot(xaxis_min, yaxis, 'k', 'LineWidth', 1);% standard plot
xlabel('Time [min]'); ylabel('MSD [\mum^2]'); title('MSD for coarsegrained data Standard plot');
saveas(gcf, fullfile(BB_apical_msd, 'MSD_coarsegrained_data_standard_plot'), 'fig'); saveas(gcf, fullfile(BB_apical_msd, 'MSD_coarsegrained_data_standard_plot'), 'tif');
close all;

save('workspace_msd_coarsegrained');

%%
% Saving the figures as montage
montage_fig = '../Plots/montage';
fig1 = fullfile(BB_apical_msd, 'MSD_coarsegrained_data_log_log_plot.tif');
fig2 = fullfile(BB_apical_msd, 'MSD_coarsegrained_data_standard_plot.tif');
montage({fig1, fig2});
saveas(gcf, fullfile(montage_fig,'slide_20_msd_coarsegrained'), 'tif');

close all;

disp('Finished !');

%% Function for fitting the MSD plot in log space
function [x_for_fit, y_from_fit_model_lin, alpha_value, diff_coeff_fit, diff_coef_direct] = msd_logplot_fitting(xaxis, yaxis, time_Interval)
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
diff_coef_direct = yaxis_fit(1)/(4 * time_Interval); % getting the diffusion coefficient from the first MSD value using (MSD(t1)/(4*t1)) - (remember the t1 here is 1 and therefore needs to be multiplied by the time interval to bring to the proper units) (another way to get the diffusion coefficient in addition to getting from the y intercept i.e 'diff_coeff' above); Here the units is in µm2/s.
end

%%


