% Raghavan Thiagarajan; Part of BB analysis pipeline

% In this script, we do two things: (1) Find the mean interdistance of BBs (1/sqrt(BB density)); and (2) Get the local and global clustering indices. In general, these parameters can be obtained for two types of data: 
% (i) for all trajectories; or (ii) trajectories after filtering using 'traj_filter_duration'. It is important to note that the way this code is written, calculates the clustering indices only for trajectories after 
% filtering and not for all trajectories. Because the data (i.e. matrices) used for calculating the culstering indices (Avg_Dist & filtered_frame_wise_data_final) were obtained from other scripts where these data were 
% calculated for trajectories after filtering. On the other hand, the mean interdastance can be calculated for both trajectories after filtering or for all trajectories by switching the cases. So in case we want to obtain 
% the mean interdistance for trajectories after filtering or for all trajectories, we just have to switch the case and obtain the plots. However, while running the whole script i.e. while running the mean interdistance 
% section together with the clustering index section, we should ALWAYS use the case with the trajectories after filtering (i.e. with_traj_filtering). Because, this code is written in a way that the parameters from the mean 
% interdistance section are used for calculating the clustering index section. If the mean interdistance is calculated for all trajectories, and since clustering index section borrows data from other scripts that are already 
% calculated for trajectories after filtering, it will lead to a mismatch. So while the running the script as a whole, the case for mean interdistance section should be always: 'with_traj_filtering'. 
% While running mean interdistance section alone, the 'without_traj_filtering' case can be used.


clc;
clear all;
close all;

%% Mean interdistance of BB

mkdir '../Plots/BB_mean_interdistance'
BB_apical = '../Plots/BB_mean_interdistance/';

load('workspace_interim.mat', 'Area_apicaldomain', 'No_of_BB', 'Timelist');
load('workspace_BB_distance_same_frame.mat', 'pixelwidth', 'neighbor_dist', 'Area_This_Frame', 'Curent_frame_number_min', 'Avg_Dist', 'Filtered_frame_wise_data_final');

% The switch below uses two cases for allowing to switch in future: (1) to get the bb density & interdistance after filtering the trajectories to 'traj_filter_duration'; (2) to get the bb density & interdistance of all BBs without any cap for
% filtering; The value for the 'switch' is changed accordingly
data_used_for_calculating_bbdensity = 'with_traj_filtering'; % the other option is 'without_traj_filtering'
switch data_used_for_calculating_bbdensity
    case 'with_traj_filtering'
        NoofBB = neighbor_dist(:,2); % no of BBs in each frame after filtering the trajectories
        framesused = neighbor_dist(:,1); % frame numbers that are used for processing
        framenumbers_orig(1:size(Area_apicaldomain,1), 1) = 1:size(Area_apicaldomain,1); % getting the framenumbers based on the total no of frames.
        % Below, before calculating the BB density for the trajectory filtered data (i.e. neighbor_dist), we first adjust the size of the area & BB count vectors (i.e. Area_This_Frame & NoofBB) to match the size of the actual area & BB count 
        % vectors (i.e. Area_apicaldomain & No_of_BB). This is because, some frames are missing in the trajectory filtered data and hence the 'Area_This_Frame' & 'NoofBB' will be smaller in size than the actual 'Area_apicaldomain' & 'No_of_BB'.
        % So we insert NaNs in the place of those frames that are missing or skipped. This allows to keep the same size as the original area & BB count data but the data itself (only for BB count and not for area) is different.
        framenumbers_adjusted = nan(size(framenumbers_orig)); % preassigning nans
        [~, loc] = ismember(framesused, framenumbers_orig); % finding those indices that show a exact match between the two vectors
        framenumbers_adjusted(loc) = framesused; % filling the data only in those indices where there is a perfect match. The rest of the indices will remain as NaNs.
        % getting area
        Area_This_Frame_adjusted = nan(size(framenumbers_orig)); % preassigning nans
        Area_This_Frame_adjusted(loc) = Area_This_Frame; % filling the data only in those indices where there is a perfect match. The rest of the indices will remain as NaNs.
        % getting BB count
        NoofBB_adjusted = nan(size(framenumbers_orig)); % preassigning nans
        NoofBB_adjusted(loc) = NoofBB; % filling the data only in those indices where there is a perfect match. The rest of the indices will remain as NaNs.
        % getting the time
        Curent_frame_number_min_adjusted = nan(size(framenumbers_orig)); % preassigning nans
        Curent_frame_number_min_adjusted(loc) = Curent_frame_number_min; % preassigning nans
        
        % calculating the bb density
        bb_density = NoofBB_adjusted ./ Area_This_Frame_adjusted;
        bb_density(bb_density==0) = NaN;
        first_nonNaNIdx = find(~isnan(Area_This_Frame_adjusted), 1, 'first'); % here we find the first non nan value in the 'Area_This_Frame_adjusted' vector. Sometimes, the first value of the vector can be nan and if it is so, then the whole 'area_norm' will become nan. This step makes sure that first non nan value is used for the subtraction in the next step.
        first_area_value = Area_This_Frame_adjusted(first_nonNaNIdx); % getting the first non nan value
        area_norm = abs(round(Area_This_Frame_adjusted - first_area_value)); % This adjustment is done to the area. Without this, the BB_density vs area plot shows an increasing behavior. This behavior arises because
        % the starting area is not zero. Once this is adjusted by subtracting the initial area from all areas, then the BB density vs area plot shows a constant behavior.
        bb_density_norm = NoofBB_adjusted ./ area_norm;
        bb_density_norm(bb_density_norm==0) = NaN;
        % Mean inter distance (abbreviated as mintd)
        mintd = 1 ./ sqrt(bb_density);
        % mintd_norm = 1 ./ sqrt(bb_density_norm);
        area_for_plotting = Area_This_Frame_adjusted;
        time_for_plotting = Curent_frame_number_min_adjusted;

    case 'without_traj_filtering'
        bb_density = No_of_BB ./ Area_apicaldomain;
        bb_density(bb_density==0) = NaN;
        area_norm = abs(round(Area_apicaldomain - Area_apicaldomain(1))); % This adjustment is done to the area. Without this, the BB_density vs area plot shows an increasing behavior. This behavior arises because
        % the starting area is not zero. Once this is adjusted by subtracting the initial area from all areas, then the BB density vs area plot shows a constant behavior.
        bb_density_norm = No_of_BB ./ area_norm;
        bb_density_norm(bb_density_norm==0) = NaN;
        % Mean inter distance (abbreviated as mintd)
        mintd = 1 ./ sqrt(bb_density);
        % mintd_norm = 1 ./ sqrt(bb_density_norm);
        area_for_plotting = Area_apicaldomain;
        time_for_plotting = Timelist;
end

% figure(1);
% plot(area_for_plotting, No_of_BB, '-kx','LineWidth', 0.8);
% xlabel('Area [\mum^2]');  ylabel('Basalbody count'); title('Area & basalbodies relation in apical domain'); set(gca,'fontsize',18);

figure(2);
plot(area_for_plotting, bb_density, 'rx','LineWidth', 0.8);
xlabel('Area [\mum^2]');  ylabel('BB density'); title('BB density vs Area'); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, 'BB_density_vs_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'BB_density_vs_area'), 'tif');

figure(3);
plot(area_for_plotting, bb_density_norm, 'rx','LineWidth', 0.8);
xlabel('Area [\mum^2]');  ylabel('BB density (area adjusted)'); title('BB density (area adjusted) vs Area'); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, 'BB_density(area_adjusted)_vs_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'BB_density(area_adjusted)_vs_area'), 'tif');

figure(4);
plot(area_for_plotting, mintd, '-bx','LineWidth', 0.8);
xlabel('Area [\mum^2]');  ylabel('Mean inter distance of BBs'); title('Mean inter distance of basal bodies vs Area'); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, 'Mean_inter_distance_of_basal_bodies_vs_Area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Mean_inter_distance_of_basal_bodies_vs_Area'), 'tif');

figure(5);
plot(time_for_plotting, mintd, '-bx','LineWidth', 0.8);
xlabel('Time [min]');  ylabel('Mean inter distance of BBs'); title('Mean inter distance of basal bodies vs Time'); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, 'Mean_inter_distance_of_basal_bodies_vs_Time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Mean_inter_distance_of_basal_bodies_vs_Time'), 'tif');

close all;

%% Clustering analysis (Local & Global clustering)

% The clustering analyses below is based on the code from Mandar Inamdar from IIT Bombay
% The local clustering gives an idea of how much the BBs are closer to each other locally. So it is calculated based on distances between the BBs. For a given frame / time point, it is calculated as: mean(nearest neighbor distances)/(1/sqrt(BB density)).
% The global clustering gives an idea of how the BBs are distributed for a given area. So it is calculated based on BB positions. For a given frame / time point, it is calculated as: sqrt((distribution angle^2 + (1-normalized radial distances)^2)/N)

%----------------------%----------------------%

% Local clustering
% The local clustering index is formulated in a way that '0' indicates perfect distribution and '1' indicates clustering
mintd1 = mintd(~isnan(mintd)); % getting only the non NaN values
area_for_plotting_clustering = area_for_plotting(~isnan(mintd)); % getting only those area values corresponding to the non NaN values of mean interdistance (mintd)
time_for_plotting_clustering = time_for_plotting(~isnan(mintd)); % getting only those time values corresponding to the non NaN values of mean interdistance (mintd)

% The switch below uses two cases for allowing to switch in future: (1) In 'RT' we use the nearest neighbor distance and mean interdistance value that were calculated from my scripts;
% (2) In 'Mandar', we freshly calculate these parameters from the BB coordinates based on Mandar's script; For consistencey, I am using the case 'RT'. However I have confirmed that the case 'Mandar' also gives the same result
local_clustering_approach = 'RT'; % other option is 'Mandar'
switch local_clustering_approach
    case 'RT'
        d_obs = Avg_Dist; % getting the average of nearest neighbor distances for every frame
        d_hex = mintd1; % getting the mean interdistance for every frame
        LC_1 = 1-(d_obs./d_hex); % making sure the values are less than 1
        % The idea here is to bring the values of final local clustering (i.e. LC_2) between the range of 0-1. The values are made sure to be below 1 by subtracting from 1 (above). On the other hand, the
        % values are made sure to be 0 or above 0 using max(0, vector) (below). However if the ratio of 'd_obs./d_hex' has NaNs, then the subsequent step of max(0, vector) will
        % convert these NaNs to 0. But these 0s are not legitimate since they are just converted from NaNs. So below, we make sure only the non NaN values are converted to the range between 0-1. The NaNs are retained.
        LC_2 = LC_1;
        LC_2(~isnan(LC_2)) = max(0, LC_2(~isnan(LC_2))); % retaining NaNs while shifting the non NaN values between 0-1

    case 'Mandar'
        % in the loop below, we use the 'Filtered_frame_wise_data_final' data to go through each frame and get the BB coordinates
        for kk = 1:size(Filtered_frame_wise_data_final,1) % looping until the total no of rows or no of frames with BBs i.e. the rows of the framewisedata
            No_bb_this_Frame = Filtered_frame_wise_data_final(kk, 4); % getting the no of already existing BBs in this frame - obtained from the loop above (i.e. after applying all the filtering on the trajectories)
            XCrd_List_all_bb = Filtered_frame_wise_data_final(kk, 5:2:((No_bb_this_Frame*2)+3)); % getting the list of x coordinates for all BBs in this frame
            YCrd_List_all_bb = Filtered_frame_wise_data_final(kk, 6:2:((No_bb_this_Frame*2)+4)); % getting the list of y coordinates for all BBs in this frame
            % below we call the function to calculate the local clustering index
            [LC_1] = LC(XCrd_List_all_bb, YCrd_List_all_bb, area_for_plotting_clustering(kk,1), pixelwidth); % calls the function that calculates the local clustering from the x &  coordinates from scratch
            LC_2(kk,1) = LC_1;
        end
end
local_clustering = LC_2; % reassigning

% plotting
figure(1);
plot(area_for_plotting_clustering, local_clustering, 'r-.','LineWidth', 0.8);
xlabel('Area [\mum^2]');  ylabel('Local clustering index'); title('Local clustering vs Area'); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, 'LC_vs_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'LC_vs_area'), 'tif');

figure(2);
plot(time_for_plotting_clustering, local_clustering, 'b-.','LineWidth', 0.8);
xlabel('Time [min]');  ylabel('Local clustering index'); title('Local clustering vs Time'); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, 'LC_vs_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'LC_vs_time'), 'tif');

close all;

%----------------------%----------------------%

% Global clustering
% The global clustering index is formulated in a way that '0' indicates perfect distribution and '1' indicates clustering

load('workspace_bb_density_distribution_expansion_bias.mat', 'area_periphery_coord', 'centroid_coord');
centroid_crd = centroid_coord(Filtered_frame_wise_data_final(:,1), :); % getting the centroid (already in micrometers) only for those frames for which we are analyzing
num_random_pts = 1000; % defining the number of random positions to be used for getting the radial distances while doing the simulations

% in the loop below, we use the 'Filtered_frame_wise_data_final' data to go through each frame and get the BB coordinates
for kk = 1:size(Filtered_frame_wise_data_final,1) % looping until the total no of frames with BBs i.e. the rows of the framewisedata
    No_bb_this_Frame = Filtered_frame_wise_data_final(kk, 4); % getting the no of already existing BBs in this frame - obtained from the loop above (i.e. after applying all the filtering on the trajectories)
    XCrd_List_all_bb = Filtered_frame_wise_data_final(kk, 5:2:((No_bb_this_Frame*2)+3)) * pixelwidth; % getting the list of x coordinates for all BBs in this frame and converting to micrometers
    YCrd_List_all_bb = Filtered_frame_wise_data_final(kk, 6:2:((No_bb_this_Frame*2)+4)) * pixelwidth; % getting the list of y coordinates for all BBs in this frame and converting to micrometers
    % getting the area periphery coorindates which is already in micrometers
    periphery_crd_x = area_periphery_coord(:,kk+(kk-1));
    periphery_crd_y = area_periphery_coord(:,kk+kk);
    % getting the centroid coordinates which is already in micrometers
    centroid_crd_x = centroid_crd(kk,1);
    centroid_crd_y = centroid_crd(kk,2);
    % total no of particles / BBs in this frame
    N = length(XCrd_List_all_bb);
    % area for this frame
    area = area_for_plotting_clustering(kk,1);

    % Below we start getting different parameters for calculating the global clustering index
    % First, we get the standard deviation of radial distances for the BBs in this frame
    % Convert to polar coordinates
    [theta, r] = cart2pol(XCrd_List_all_bb - centroid_crd_x, YCrd_List_all_bb - centroid_crd_y); % we subtract the centroid to make sure that the distances are always calculated w.r.t the center
    % Getting the Angular Clustering (Mean Resultant Length) for the BBs
    Clust_theta = abs(sum(exp(1j * theta)) / N); % High when clustered in angle
    % Getting the Radial Dispersion for the BBs
    sigma_r = std(r); % Standard deviation of radial distances of BBs
    sigma_r(sigma_r==0) = NaN; % Those frames that do not have BBs will be recorded as zeros. So these zeros are converted to NaNs

    % Second, we get the standard deviation of radial distances for randomly distributed particles that will be simulated within the area (i.e. area periphery coordinates) of this frame.
    % Here, to simulate random particle positions within the area (i.e. area periphery coordinates), we do the following: (1) we make a grid based on the min and max values of the periphery coordinates; (2) within
    % this grid, we generate a lot of random particles (i.e. particle positions); (3) then we randomly select from those particles that overlap between the grid and the area occupied by the area periphery
    % coordinates. This is how we end up getting random particle positions within the area periphery coordinates for this frame.
    % getting the range of the grid, this is given by the minimum and the maximum of the area periphery coordinates that set the boundary. Therefore, based on these min and max values, we set a bounding rectangle grid
    Xrange = max(periphery_crd_x) - min(periphery_crd_x); % range in x
    Yrange = max(periphery_crd_y) - min(periphery_crd_y); % range in y
    % Below, by multiplying with '2' we double the number of particles (num_random_pts) that will be placed within the grid (i.e. meshgrid); by doubling we are making sure that
    % we get enough particles when we collect random particles from the area occupied by the area periphery coordinates
    optim_grid_size = num_random_pts * 2;
    % Below we set the stepsize to be used in the meshgrid; this step size will dictate the total no of particles that can be placed within the grid; Because step used for stretching the the range of the grid sets
    % the no of particles / points that can be within this grid
    stepsize = sqrt((Xrange * Yrange)/optim_grid_size);
    % Create a grid covering the bounding box of the periphery
    [Xgrid, Ygrid] = meshgrid(min(periphery_crd_x):stepsize:max(periphery_crd_x), min(periphery_crd_y):stepsize:max(periphery_crd_y));
    % Getting those grid coordinates that are inside the area periphery coordinates
    inside_crds = inpolygon(Xgrid, Ygrid, periphery_crd_x, periphery_crd_y);
    % Getting the indices of those grid coordinates inside the area periphery coordinates
    matching_crds = [Xgrid(inside_crds), Ygrid(inside_crds)];
    % Randomly selecting the coordinates (i.e. particle positions) from the matching_crds inside the area periphery coordinates
    rand_crds = matching_crds(randperm(size(matching_crds, 1), num_random_pts), :);
    % Convert to polar coordinates and getting the theta and radial distances for the randomly selected coordinates
    [theta_rand, r_rand] = cart2pol(rand_crds(:, 1) - centroid_crd_x, rand_crds(:, 2) - centroid_crd_y);
    N_rand = length(rand_crds(:,1)); % getting the total number of random particles; this will be always 'num_random_pts'
    % Getting the Angular Clustering (Mean Resultant Length) for the randomly selected coordinates (i.e. particle positions)
    Clust_theta_rand = abs(sum(exp(1j * theta_rand)) / N_rand); % High when clustered in angle
    % The normalization factor below (i.e. sigma_r_rand) will be the radial distance of the particles in the reference scenario which is the simulated random positions of particles.
    % However, how the sigma_r_rand is obtained can be different: (1) it can be the radial distance for the areas corresponding to every frame as done here; (2) it can be distance given by R/sqrt(18) which is specifically for a constant
    % circle area (the distances change because of the randomization of the particle positions for every frame); (3) or could be the Radius of gyration (Rg); When I checked, the results didnt change dramatically between these 3 scenarios. So I am using scenario (1) now.
    % Scenario (1)
    sigma_r_rand = std(r_rand); % Standard deviation of radial distances of random particle positions
    % Scenario (2)
    % sigma_r_rand = R / sqrt(18); % Here R can be a constant value like 8 µm (which is roughly the radius of final size of apical domain areas) or it can be simply sqrt(area) for this frame.
    % Scenario (3) - Rg
    % x_cm = mean(XCrd_List_all_bb, 'omitnan'); % getting the center of mass of x coordinates
    % y_cm = mean(YCrd_List_all_bb, 'omitnan'); % getting the center of mass of y coordinates
    % Rg = sqrt((XCrd_List_all_bb - x_cm).^2 + (YCrd_List_all_bb - y_cm).^2); % getting the distance of every particle from the center of mass for this frame
    % sigma_r_rand = std(Rg, 'omitnan'); % getting the standard deviation of Rg

    % Third, we normalize the dispersion of radial distances
    % This normalization is required to allow comparison between the standard deviation of radial distances between different experiments. Because the radial distance is ultimately dictated by the size of the
    % area which will change from cell to cell. However a similar normalization is not required for angle (i.e. Clust_theta) because the angles are not going to change depending on the cells or area.
    Disp_r = sigma_r / sigma_r_rand;
    Disp_r_norm = min(max(Disp_r, 0), 1); % capping the Disp_r between 0 and 1; The values can be more than 1 if the distribution of BBs is more dispersed than the reference scenario. The idea is to normalize w.r.t some random distribution which inherently does not show
    % any patterning or clustering. So if the distribution of BBs show some patterning or clustering, the random distribution can be used to normalize. However if the actual distribution if BBs is more dispersed than the random, then we are fine and thats why we cap at
    % 1. In principle there is no need to cap at 0 because Disp_r can never be negative but this is just for consistency.
    Disp_r_norm(Disp_r_norm == 0) = NaN; % converting all zeros to NaNs

    % getting the global clustering index
    GC = sqrt((Clust_theta^2 + (1 - Disp_r_norm)^2) / 2);

    % capping all the values between 0 and 1 except for NaNs
    if isnan(GC)
        GC = NaN;
    else
        GC = min(max(GC, 0), 1);
    end

    global_clustering(kk) = GC; % storing the global clustering indices for all frames
end

% plotting
figure(1);
plot(area_for_plotting_clustering, global_clustering, 'r-.','LineWidth', 0.8);
xlabel('Area [\mum^2]');  ylabel('Global clustering index'); title('Global clustering vs Area'); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, 'GC_vs_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'GC_vs_area'), 'tif');

figure(2);
plot(time_for_plotting_clustering, global_clustering, 'b-.','LineWidth', 0.8);
xlabel('Time [min]');  ylabel('Global clustering index'); title('Global clustering vs Time'); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, 'GC_vs_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'GC_vs_time'), 'tif');

close all;


%% saving workspace
save('workspace_bb_mean_inter_distance_density');

%% saving all the figures as montage
montage_fig = '../Plots/montage';

fig1 = fullfile(BB_apical, 'BB_density_vs_area.tif');
fig2 = fullfile(BB_apical, 'BB_density(area_adjusted)_vs_area.tif');
fig3 = fullfile(BB_apical, 'Mean_inter_distance_of_basal_bodies_vs_Area.tif');
fig4 = fullfile(BB_apical, 'Mean_inter_distance_of_basal_bodies_vs_Time.tif');
fig5 = fullfile(BB_apical, 'LC_vs_area.tif');
fig6 = fullfile(BB_apical, 'LC_vs_time.tif');
fig7 = fullfile(BB_apical, 'GC_vs_area.tif');
fig8 = fullfile(BB_apical, 'GC_vs_time.tif');

montage({fig1, fig2, fig3, fig4, fig5, fig6, fig7, fig8});
saveas(gcf, fullfile(montage_fig,'slide_16_bb_interdistance'), 'tif');

close all;

disp('Finished !');

%% Function to calculate the LC (local clustering)

function [LC_00] = LC(x, y, area, pxwidth)
% Assume x and y are the coordinates of the basal bodies

% Compute pairwise distances
distMatrix = squareform(pdist([x', y']));
N = length(x);

% Set diagonal elements to Inf to exclude self-distance
distMatrix(logical(eye(N))) = Inf;

% Find the nearest-neighbor distance for each BB
nearestDistances = min(distMatrix, [], 2) * pxwidth;

% Compute the mean nearest-neighbor distance
d_obs = mean(nearestDistances);

% Compute the expected nearest-neighbor distance for a random distribution
% d_exp = R * sqrt(pi / (4 * N));

% Compute the expected nearest-neighbor distance for a hexagonal lattice
% d_hex = R * sqrt((2 * pi) / (N * sqrt(3)));
% d_hex = R * sqrt(pi/N);
d_hex = sqrt(area/N); % this is the mean interdistance equivalent to mintd1

% Define the scale-free Local Clustering metric and clip to [0,1]
LC_0 = 1-(d_obs / d_hex);
% The idea here is to bring the values of final local clustering (i.e. LC_2) between the range of 0-1. The values are made sure to be below 1 by subtracting from 1 (above). On the other hand, the
% values are made sure to be 0 or above 0 using max(0, vector) (below). However if the ratio of 'd_obs./d_hex' has -Inf, then the subsequent step of max(0, vector) will
% convert these -Inf to 0. But these 0s are not legitimate since they are just converted from -Inf. So below, we make sure only the non -Inf values are converted to the range 0-1 and
% the -Inf are converted to NaNs.
if LC_0 == -Inf || isnan(LC_0)
    LC_00 = NaN;
else
    LC_00 = max(0, LC_0);
end
end

%%






















