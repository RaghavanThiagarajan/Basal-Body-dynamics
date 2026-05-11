% Raghavan Thiagarajan, reNEW, Copenhagen, 21st March 2023

% This first section of the script is used to get the Minimum distance between every BB that newly appeared in the current frame with all the newly appeared BBs in the previous frame. In
% order to do this: (1) the BB coordinates are adjusted for the fluctuations in centroid (that comes from the slight imperfections in the image
% registration); then, (2) we find all the frames where there are newly appearing BBs. We go to each of this frame and get the coordinates of
% all the newly appeared BBs. We start with one of these BBs in this frame and find the distance between this BB and all the newly appeared BBs in the previous frame (this could be
% the immediate previous frame or couple of frames before - the frame in which new BBs appeared). We find the minimum of these distances and call
% this is as the minimum distance by which the BB in this current frame is distanced from the newly appeared BBs in the previous frames. We do this
% for all the newly appeared BBs in this frame and call these as the minimal distances by which each of these BBs are separated from the
% previously appeared BBs; (3) Then we plot a barplot of these distances to find the peak of the barplot which will be the minimal distance by
% which the BBs is separated from their previous BBs. We also plot the minimum BB distance against Area, BB count and BB rate.

close all
clear all
clc

mkdir '../Plots/BB_appearance_distance'
BB_apical = '../Plots/BB_appearance_distance'; % location where the plots will be saved

% loading the values from the previous analyses which will be used in this script.
load('workspace_interim.mat', 'pixelwidth', 'No_of_timepoints', 'No_of_BB');
load('workspace_with_t0_data.mat', 'TrajecInitPos', 'Time_interval', 'frm_nmb', 'frm_nmb_modified', 'basalbody_count_modified', 'Area_apicaldomain');
new_basalbody_count_original = basalbody_count_modified * Time_interval; % Actually, 'basalbody_count_modified' is the basal body rate (which is basal body count / Time interval). Therefore, multiplying by 'Time_interval'
% gives the new basal body count (i.e. no of new BBs that appeared in this frame)

% getting the column that contains the frames where new BBs are appearing
bb_appearing_frames_orig = TrajecInitPos(:,2);

% opening the files to get the centroid values
Input.Wholeroimeasure = '../data/Gradients_of_actin_intensity/Whole_ROI_Measure/whole_roi_measure_t';
WholeRoimeasure = Input.Wholeroimeasure;
for i = 1:No_of_timepoints
    % Loading the data files
    WholeROImeasure = strcat(WholeRoimeasure, sprintf('%01d',i), '.txt');
    Whole_roimeasure = importdata(WholeROImeasure);
    Whole_roi_measure_1 = Whole_roimeasure.data;
    Whole_roi_measure_all_data(i,:) = Whole_roi_measure_1;
    clear Whole_roimeasure;
end

% Getting the area and the no of BBs corresponding to those frames where new BBs appear. In other words, getting the area and no of BBs (in that frame) for the t0 of all trajectories.
% this for loop is taken from the script: 't0_time_dist_spatial_plot_Traj_after_filtering.m'
frm_nmb_modified = frm_nmb(frm_nmb~=0);
for iab = 1:length(new_basalbody_count_original) % this loop goes through the the array that contains the t0 of all trajectories
    frame_t0_BB_getting_value(iab) = frm_nmb_modified(iab); % getting individually the t0 of all trajectories one by one
    Area_t0_BB(1,iab) = Area_apicaldomain(frame_t0_BB_getting_value(iab)); % Finding the corresponding area for the t0 frame of every trajectory
    No_of_BB_t0(1,iab) = No_of_BB(frame_t0_BB_getting_value(iab)); % Finding the corresponding BB count for the t0 frame of every trajectory
    centroid_xx_um(iab,1) = Whole_roi_measure_all_data(iab,8); % Finding the corresponding x coordinate of centroid for the t0 frame of every trajectory
    centroid_yy_um(iab,1) = Whole_roi_measure_all_data(iab,9); % Finding the corresponding y coordinate of centroid for the t0 frame of every trajectory    
end

centroid_xx = centroid_xx_um / pixelwidth; % Original centroid values (i.e centroid_xx_um) are in micrometers. So here we convert them to pixels so that all operations are done in pixels and in the final step we convert them to micrometers
centroid_yy = centroid_yy_um / pixelwidth; % Original centroid values (i.e centroid_yy_um) are in micrometers. So here we convert them to pixels so that all operations are done in pixels and in the final step we convert them to micrometers

% assigning the centroid of the first frame as the master centroid since all the BB coordinates will be adjusted to this centroid.
master_centroid_x = centroid_xx(1,1);
master_centroid_y = centroid_yy(2,1);

% in the logic below, we go to every frame where the new BBs are appearing and find the distance between these BBs and the new BBs that appeared in the previous frame.
rrw = length(new_basalbody_count_original); ccl = max(new_basalbody_count_original) * max(new_basalbody_count_original);
new_bb_distc_full = nan(rrw, ccl+2);
new_bb_distc_full(:,1) = frame_t0_BB_getting_value;
new_bb_distc_full(:,2) = Area_t0_BB;
new_bb_distc_full(:,3) = zeros(length(Area_t0_BB), 1);
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
        curr_xcoord = curr_xcrd + (master_centroid_x - centroid_xx(frame_increment,1)); % adjusting the fluctuations in centroid
        curr_ycoord = curr_ycrd + (master_centroid_y - centroid_yy(frame_increment,1));
        
        if j ~= 1 && dummy_incre ~=1
            frame_increment = frame_increment + 1;
            distances(frame_increment,1) = frm_nmb_modified(1,frame_increment); % making a new matrix called 'distances' where the frame number and all the coordinates of the new BBs appearing this frame will be stored.
            bbcoordinates_x(frame_increment, 1) = frm_nmb_modified(1,frame_increment); % storing the BB appearance frame numbers
            bbcoordinates_y(frame_increment, 1) = frm_nmb_modified(1,frame_increment); % storing the BB appearance frame numbers
            
            % the logic below in the for loop uses a trick (taught by Mandar Inamdar, IIT Bombay) to find the distance between every single BB in the current
            % frame and all the BBs in the previous frame without using a for loop to go through every BB in the previous frame. To understand the logic behind the trick,
            % check the script: 'distance_btw_groups_of_particles_without_for_loop.m' in the folder with the miscellaneous scripts.
            Start_Colum = 4;
            for k = 1:length(curr_xcoord)
                % Begin calculating the distances
                No_of_bb_in_previous_frame = length(previous_coord(:,1));
                dummy_vec = ones(No_of_bb_in_previous_frame,1);
                
                dx = previous_coord(:,1)*dummy_vec' - dummy_vec*curr_xcoord(k)';
                dy = previous_coord(:,2)*dummy_vec' - dummy_vec*curr_ycoord(k)';
                
                dist = sqrt(dx.^2 + dy.^2);
                
                newbbdistcfull = dist(:,1);
                len_newbbdistfull = length(newbbdistcfull);
                End_Colum = Start_Colum + len_newbbdistfull - 1;
                new_bb_distc_full(frame_increment, 3) = k; % no of new BBs
                new_bb_distc_full(frame_increment, Start_Colum:End_Colum) = newbbdistcfull';
                Start_Colum = Start_Colum + len_newbbdistfull;
                
                dist_min_mat = min(dist);
                dist_min = dist_min_mat(1,1); % getting the minimum of all the distances that were obtained between the BB in the current frame with all the BBs in the previous frame
                col = k+1;
                distances(frame_increment, col) = dist_min; % storing the final result in the 'distances' matrix
                
                bbcoordinates_x(frame_increment, col) = curr_xcrd(k); % Storing the x coordinates of the newly appearing BBs - without adjustment for centroid
                bbcoordinates_y(frame_increment, col) = curr_ycrd(k); % Storing the y coordinates of the newly appearing BBs - without adjustment for centroid
            end
            % End calculating the distances
        else
            bbcoordinates_x(frame_increment, 1) = frm_nmb_modified(1,frame_increment); % storing the 1st frame number when the BB appears
            bbcoordinates_y(frame_increment, 1) = frm_nmb_modified(1,frame_increment); % storing the 1st frame number when the BB appears
            bbcoordinates_x(frame_increment, 2:length(curr_xcrd)+1) = curr_xcrd; % Storing the x coordinates of the newly appearing BBs - without adjustment for centroid - BBs appearing in the first frame (i.e. frame number obtained in the previous lines)
            bbcoordinates_y(frame_increment, 2:length(curr_xcrd)+1) = curr_ycrd; % Storing the y coordinates of the newly appearing BBs - without adjustment for centroid - BBs appearing in the first frame (i.e. frame number obtained in the previous lines)
        end
        clear vars previous_coord;
        previous_coord(:,1) = curr_xcoord; previous_coord(:,2) = curr_ycoord;
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
[r,c] = size(bbcoordinates_x);
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
lctn = fullfile('../data', 'Newly_appearing_BB_coordinates.csv');
writetable(table_bb_coordinates, lctn, 'WriteVariableNames', true);

% converting all the distances from pixel units to micrometer units
distn = distances;
distn(distn==0) = NaN;
distn_in_px = distn;
distn_in_micron = distn_in_px(:,2:end) * pixelwidth;
% plotting the histogram of 'all distances' by calling the function 'Distribution_Plots'
% for plotting the histogram of 'all distances', we are using the function 'Distribution_Plots' but not for plotting the histogram of the minimal distances. This is because, this section for plotting all distances was
% included after the function was introduced along with section 2
New_BB_Distc_Full_micron = new_bb_distc_full;
New_BB_Distc_Full_micron(:,4:end) = New_BB_Distc_Full_micron(:,4:end) * pixelwidth;
parameter = New_BB_Distc_Full_micron(:,4:end); bininterval = 0.5; Xlabel = 'BB appearance distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'BB appearance, all distances,', 'between the current and previous frames'}; save_title = 'BB_appearance_all_distances';
Distribution_Plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical, save_title);

% plotting against area
figure(1);
area_t0_bb_mod = Area_t0_BB(1,2:end);
bb_dist = plot(area_t0_bb_mod, distn_in_micron, 'rx');
xlabel('Area [\mum^{2}]');  ylabel('Minimum BB appearance distance [\mum]'); title({'Minimum BB appearance distance', '[between the current and previous frames]', 'vs Area'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'BB_appearance_dist_vs_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'BB_appearance_dist_vs_area'), 'tif');

% plotting against time
figure(111);
Frame_t0_bb_geting_valu_min = bbcoordinates_x(:,1) * Time_interval;
bb_dist = plot(Frame_t0_bb_geting_valu_min, distn_in_micron, 'mx');
xlabel('Time [min]');  ylabel('Minimum BB appearance distance [\mum]'); title({'Minimum BB appearance distance', '[between the current and previous frames]', 'vs Time'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'BB_appearance_dist_vs_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'BB_appearance_dist_vs_time'), 'tif');

% plotting against number of BBs
figure(2);
No_of_BB_t0_mod =No_of_BB_t0(1,2:end);
bb_dist = plot(No_of_BB_t0_mod, distn_in_micron, 'bx');
xlabel('BB count');  ylabel('Minimum BB appearance distance [\mum]'); title({'Minimum BB appearance distance', '[between the current and previous frames]', 'vs BB count'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'BB_appearance_dist_vs_BB_count'), 'fig'); saveas(gcf, fullfile(BB_apical, 'BB_appearance_dist_vs_BB_count'), 'tif');

% % Getting the BB rate
% numb_of_bb = new_basalbody_count_original(1,2:end);
% figure(3);
% bb_dist = plot(numb_of_bb, distn_in_micron, 'kx');
% xlabel('BB rate [min^{-1}]');  ylabel('Minimum BB appearance distance [\mum]'); title({'Minimum BB appearance distance', '[between the current and previous frames]', 'vs BB rate'}); set(gca,'fontsize',12);
% saveas(gcf, fullfile(BB_apical, 'BB_appearance_dist_vs_BB_rate'), 'fig'); saveas(gcf, fullfile(BB_apical, 'BB_appearance_dist_vs_BB_rate'), 'tif');

% plotting against BB density
figure(4);
bb_density_t0 = No_of_BB_t0_mod./area_t0_bb_mod;
plot(bb_density_t0, distn_in_micron, 'kx');
xlabel('BB density [\mum^{-2}]');  ylabel('Minimum BB appearance distance [\mum]'); title({'Minimum BB appearance distance', '[between the current and previous frames]', 'vs BB density'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'BB_appearance_dist_vs_BB_density'), 'fig'); saveas(gcf, fullfile(BB_apical, 'BB_appearance_dist_vs_BB_density'), 'tif');

% plotting the distribution
parameter = distn_in_micron; bininterval = 1; Xlabel = 'Minimum BB appearance distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Minimum BB appearance distance', '[between the current and previous frames]'}; save_title = 'BB_appearance_dist_barplot';
Distribution_Plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical, save_title);

% converting the matrix of BB distances into a single column vector so that it can be used while pooling all the BB distances from all cells and
% plotting them all as one barplot.
bb_dist_barplot = distn_in_micron(:);

% the for loop below gets the linearised array of "all BB distances" for using in the average script
[rr, ccL] = size(New_BB_Distc_Full_micron);
rowcount = rr * ccL;
cum_bb_count = 0;
linearised_New_BB_Distc_Full_micron = nan(rowcount, 4); % preassignment
for m = 1:rr % this loop goes through all the rows of the 'New_BB_Distc_Full_micron' matrix
    No_of_distances = size(New_BB_Distc_Full_micron(~isnan(New_BB_Distc_Full_micron(m, 4:end))),2); % no of distances (obtained between the new BB in this frame & previous frame) in this frame
    linearised_New_BB_Distc_Full_micron(cum_bb_count+1:cum_bb_count+No_of_distances, 1) = New_BB_Distc_Full_micron(m,1); % assigning frame number
    linearised_New_BB_Distc_Full_micron(cum_bb_count+1:cum_bb_count+No_of_distances, 2) = New_BB_Distc_Full_micron(m,2); % assigning area
    linearised_New_BB_Distc_Full_micron(cum_bb_count+1:cum_bb_count+No_of_distances, 3) = No_of_distances; % assigning BB count
    linearised_New_BB_Distc_Full_micron(cum_bb_count+1:cum_bb_count+No_of_distances, 4) = New_BB_Distc_Full_micron(m, 4:4+No_of_distances-1); % assigning BB distances
    cum_bb_count = cum_bb_count + No_of_distances; % getting the cumulative BB no after every iteration
end
% in the above matrix (linearised_New_BB_Distc_Full_micron), each of the columns contain the following parameters:
% frame number (col1), area (col2), Number of BBs (col3), distances (col4)

% Getting the average of the minimum and all distances for every frame; As opposed to the data above where all individual distances taken, here we
% average the individual distances for every frame and get one value per frame for both 'minimum' distance and 'all' distances 
% minimum of distances
avg_new_new_bb_Mindist(:,1) =  Frame_t0_bb_geting_valu_min; % Time in minutes
avg_new_new_bb_Mindist(:,2) =  Area_t0_BB(1, 1:end-1); % Area
avg_new_new_bb_Mindist(:,3) = New_BB_Distc_Full_micron(1:end-1,3); % No of new BBs in the corresponding frame
avg_new_new_bb_Mindist(:,4) = mean(distn_in_micron, 2, 'omitnan'); % average of minimum of distances for every new BB in the current frame to all the new BB in the previous frame
avg_new_new_bb_Mindist(:,5) = std(distn_in_micron, 0, 2, 'omitnan'); % standard deviation of minimum of distances for every new BB in the current frame to all the new BB in the previous frame
% plotting the distribution
parameter = avg_new_new_bb_Mindist(:,4); bininterval = 1; Xlabel = {'Averaged Minimum BB appearance', 'distance [\mum]'}; Ylabel = 'Probability density'; Plot_title = {'Averaged Minimum BB appearance distance', '[between the current and previous frames]'}; save_title = 'BB_appearance_dist_barplot_avgd';
Distribution_Plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical, save_title);
% all distances
avg_new_new_bb_Alldist(:,1) = New_BB_Distc_Full_micron(1:end-1, 1) * Time_interval; % Time in minutes
avg_new_new_bb_Alldist(:,2:3) =  New_BB_Distc_Full_micron(1:end-1, 2:3); % Area & No of new BBs in the corresponding frame
avg_new_new_bb_Alldist(:,4) = mean(New_BB_Distc_Full_micron(1:end-1, 4:end), 2, 'omitnan'); % average of all distances for every new BB in the current frame to all the new BB in the previous frame
avg_new_new_bb_Alldist(:,5) = std(New_BB_Distc_Full_micron(1:end-1, 4:end), 0, 2, 'omitnan'); % standard deviation of all distances for every new BB in the current frame to all the new BB in the previous frame
% plotting the distribution
parameter = avg_new_new_bb_Alldist(:,4); bininterval = 0.5; Xlabel = 'Averaged BB appearance distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Averaged BB appearance, all distances,', '[between the current and previous frames]'}; save_title = 'BB_appearance_all_distances_avgd';
Distribution_Plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical, save_title);

%%
disp('Run the macro "Area_fraction.ijm". Then press a key !')
pause;

%%
% This section is used to obtain the information on where the new BBs are appearing within the apical domain. The details are below and similar detail can be found in the beginning of "Area_fraction.ijm" script.

% The idea (from Mandar Inamdar, IIT Bombay) is to go to every frame (where BBs appear) and get two informations: (1) ratio of all area contours in the previous frame to the contour of the current frame (where
% the new BBs have appeared), which we call as "area fraction"; (2) find out the number of BBs that are appearing within the donut / annulus of the area contours, which we call as "BB in
% coresponding area fraction". For example, suppose we have 6 new BBs appearing in Frame 5 and that these BBs are appearing in the following regions: 2 BBs within area contour 1 (A1),
% 1 BB in-between area contours 1 and 2 (A2 & A3), 3 BBs in-between area contours 3 and 4 (A3 & A4), then the "area fractions" and the corresponding "BB in corresponding area fractions" will be:
% Area fractions:                     (A1/A5), (A2/A5), (A3/A5), (A4/A5), (A5/A5)
% BB in corresponding area fractions:   2,        0,       1,       3,       0
% We will obtain this information for all frames from frame 1 to last frame. Therefore, as the frame numbers increase, the data points in ("Area fractions" and "BB in corresponding area fractions") will
% also increase. Open the files ("Area_fraction_table.csv" & "BB_in_area_fraction_table.csv") saved from the "Area_fraction.ijm" script for better understanding. Also, the last area fraction for all frames will
% be "1". Look at the last fraction in the above example (A5/A5). This corresponds to the newest region appeared during the apical expansion. And we are getting the corresponding number of BBs
% for each donut / annulus of subsequent area contours. After getting this data for all the frames in the cell using the "Area_fraction.ijm" script, we will use the section below  to bin the data points based
% on "Area fraction" and plot "Area fraction" bins in the x axis and the corresponding bins from "BBs in corresponding area fraction" in the y axis.
% In this plot, if we see more number of BBs appearing towards "1" then we we can claim that newer BBs are appearing in the newer regions. On the other hand if we seem more number of BBs
% appearing towards "0" or the "lowest value" in the plot, then we can claim that the newer BBs are appearing in the center. If we see more number of BBs appearing in a particular area fraction,
% then we know the favorite spot of BB appearance. This is the general idea. Note that the area fraction can also be expressed as the sqrt(area fraction). Since the sqrt(area fraction) will correspond to the distance.

% Note that although Distance fraction is plotted, the variable / array is named as area fraction just to prevent changing the name at various places. Originally it is area fraction. But then I took a sqrt (below) to make it
% into a distance fraction.

mkdir '../Plots/BB_appearance_location'
BB_apical_area_frac = '../Plots/BB_appearance_location'; % location where the plots will be saved

% fetching the area fraction values from the .csv file generated from "Area_fraction.ijm" script.
area_fraction_table = readtable('../data/Area_fraction.csv');
area_fraction_matrix = table2array(area_fraction_table);
area_fraction_1d_matrix = area_fraction_matrix(:); % converting the matrix to 1D matrix
area_fraction_1d_matrix_no_nan = area_fraction_1d_matrix(~isnan(area_fraction_1d_matrix)); % removing nans
area_fraction = area_fraction_1d_matrix_no_nan; % reassigning to a convenient name
area_fraction = sqrt(area_fraction); % expressing area fraction as square root converts the fraction to a distance fraction. Distance fraction is a better way of representation than area fraction

% fetching the bb_in_area_fraction values from the .csv file generated from "Area_fraction.ijm" script.
bb_in_area_fraction_table = readtable('../data/BB_in_area_fraction.csv');
bb_in_area_fraction_matrix = table2array(bb_in_area_fraction_table);
bb_in_area_fraction_1d_matrix = bb_in_area_fraction_matrix(:); % converting the matrix to 1D matrix
bb_in_area_fraction_1d_matrix_no_nan = bb_in_area_fraction_1d_matrix(~isnan(bb_in_area_fraction_1d_matrix)); % removing nans
bb_in_area_fraction = bb_in_area_fraction_1d_matrix_no_nan; % reassigning to a convenient name

% plotting barplot
figure(7);
bininterval = 0.1; % interval for binning
binrange_area_frac = min(area_fraction):bininterval:max(area_fraction)+bininterval; % setting the binrange for the area fraction
[N_area_frac, edges_area_frac, bin_area_frac] = histcounts(area_fraction, binrange_area_frac); % obtaining the counts and bin edges for area fraction
binsum_bb_in_area_frac = accumarray(bin_area_frac(:), bb_in_area_fraction(:)); % obtaining the bin sum in bb_in_area_fraction over the bin ranges of area fraction
barplot_area_frac = bar(edges_area_frac(1:end-1), binsum_bb_in_area_frac); barplot_area_frac.FaceColor = 'b'; barplot_area_frac.EdgeColor = 'r';
xlabel('Distance fraction'); ylabel('New BB count'); title('Location of newly appeaaring BBs'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical_area_frac, 'Distance_fraction_vs_new_BB_appearance'), 'fig'); saveas(gcf, fullfile(BB_apical_area_frac, 'Distance_fraction_vs_new_BB_appearance'), 'tif');

%%
% saving workspace
save('workspace_BB_distance_consequent_frames');

%%

% Raghavan Thiagarajan, reNEW, Copenhagen, 22nd September 2023

% The section below is used to get two quantifications:
% (1) The minimum distance at which the new BBs appear w.r.to the already existing BBs in the same frame.
% (2) The nearest neighbor distance or the minimal separation between BBs in the same frame.

% Inorder to get these two quantifications, first we create a matrix where the Frame number, Area, No of BBs in the frame and The coordinates of the BBs are arranged in a frame wise manner. This is done by constructing a
% new matrix from the 'Trajectory_Data' matrix. Then we use a similar matrix created in the above section that arranges the Frame number, BB count and BB coordinates in a framewise manner. Using these two matrices, for the
% 1st point, we obtain: % (1) the distances between all newly appearing BBs in every frame w.r.to the already existing BBs (1). This is done by finding the distance between every new BB and every other already existing BB.
% Then we find the minima of these distances and call that as the minimal distance at which the new BB appears w.r.to the existing BBs. From this data, we make 3 plots: (i) a histogram of minimal distances of every new BB;
% (ii) a histogram of all distances (not only the minimal but also other distance) of every new BB with every other BB; (iii) a plot of minimal distances against corresponding area.

% Then for the 2nd point, we obtain the minimal separation distance between BBs during the distribution process through the nearest neighbor method. Here we go to every frame, and find the distances between every BB with
% every other BB. This creates a list of distances for every BB (w.r.to every other BB). We find the minima of this distance and call this as the nearest neighbor distance. We do this for all BBs in that frame and similarly
% for all frames. From this data, we make 3 plots: (i) a histogram of minimal distance between every BB and every other BB or the nearest neighbor distance; (ii) a histogram of all distances between every BB and every
% other BB; (iii) a plot of nearest neighbor distance against the corresponding area.

clear all
close all
clc

BB_apical = '../Plots/BB_appearance_distance'; % location where the plots will be saved

% loading the values from the previous analyses which will be used in this script
load('workspace_interim.mat', 'Area_apicaldomain', 'Time_interval', 'pixelwidth', 'No_of_timepoints', 'No_of_BB', 'traj_filter_duration', 'no_of_trajectories', 'Trajectory_data');

% the for loop below removes those trajectories that are smaller than "traj_filter_duration" in the 'Trajectory_data' array. In other words, we
% reconstruct the 'Trajectory_data' array with only those trajectories that are longer than "traj_filter_duration".
% the reconsructed array is called 'Filtered_Trajectory_data'.
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
        Filtered_Trajectory_data(trajno_updated, 1:length(Trajectory_data(trajno,:))) = Trajectory_data(trajno,:);
    end
end

% The loop below creates a matrix in a frame wise manner called the "Filtered_frame_wise_data" with the parameters:
% Frame number (Col 1), Area (Col 2), BB count (without trajectory filtering) in that frame (Col 3), BB count (after filtering trajectories) in that frame (col 4) and BB coordinates (starting col 5, alternating x and y coordinates)
% "Filtered_frame_wise_data" is made from the 'Filtered_Trajectory_data' where 'Filtered_Trajectory_data' is the matrix that only has trajectories that are longer than "traj_filter_duration". If we need to create a similar
% frame wise matrix for the 'Trajectory_data' with all trajectories, then just replace the 'Filtered_Trajectory_data' in the snippet below with 'Trajectory_data'.
first_frame = min(cellfun(@min, Filtered_Trajectory_data(:,2))); % Finding the first frame
last_frame = max(cellfun(@max, Filtered_Trajectory_data(:,2))); % Finding the last frames

bb_counter = 0; % initialisation
for i = first_frame:last_frame
    for j = 1:length(Filtered_Trajectory_data) % searching through length of the Trajectory data i.e. through all trajectories and looking for frame numbers (i)
        matching_elements(j,1) = cellfun(@(x) x==i, Filtered_Trajectory_data(j,2), 'un', 0); % finding whether the index of frame number within every cell of every trajectory through logical true or false operation
        idx = find(matching_elements{j,1}); % finding the exact index of that frame number
        if  isempty(idx)
            bb_counter = bb_counter + 0; % this is to skip those trajectories that do not have the frame number that is being searched
            continue
        elseif bb_counter == 0 % this is to make sure the first iteration of 'i' runs
            colval_for_xcord = bb_counter + 1; % fixing the column value for the BB x coordinate
            colval_for_ycord = bb_counter + 2; % fixing the column value for the BB y coordinate
            cord(1,colval_for_xcord) = Filtered_Trajectory_data{j,3}(idx); % storing the x coordinate
            cord(1,colval_for_ycord) = Filtered_Trajectory_data{j,4}(idx); % storing the y coordinate
            bb_counter = bb_counter + 1; % counter update
        else
            bb_counter = bb_counter + 1; % counter update
            colval_for_xcord = bb_counter + bb_counter - 1; % fixing the column value for the BB x coordinate
            colval_for_ycord = bb_counter + bb_counter; % fixing the column value for the BB y coordinate
            cord(1,colval_for_xcord) = Filtered_Trajectory_data{j,3}(idx); % storing the x coordinate
            cord(1,colval_for_ycord) = Filtered_Trajectory_data{j,4}(idx); % storing the y coordinate
        end
        % storing the different parameters in a framewise manner
        Filtered_frame_wise_data(i,1) = i; % Frame number. Here 'i' can also be replaced by 'Filtered_Trajectory_data{j,2}(idx)'.
        Filtered_frame_wise_data(i,2) = Area_apicaldomain(Filtered_Trajectory_data{j,2}(idx)); % Area
        Filtered_frame_wise_data(i,3) = No_of_BB(Filtered_Trajectory_data{j,2}(idx)); % BB count / no of BBs in the frame; This BB count is obtained from the workspace 'workspace_interim.mat' and corresponds to the 'No_of_BB' vector that is used to plot the Area vs BB_count plot. This BB count is obtained on processing 'all trajectories' without any filtering.
        Filtered_frame_wise_data(i,4) = bb_counter; % BB count / no of BBs in the frame; This BB count is obtained while processing this loop and corresponds to the BB count numbers obtained on processed 'trajectories' (i.e. after applying the filters). The filters are applied in the for loop above this loop.
        % In general this BB count will correspond to less number of BBs than the BB count obtained from processing 'all trajectories'. That is because, while filtering based on the length of trajectories, many BBs will be left out. This effect will be amplified in the BB count obtained for the last few frames since
        % many BBs that reached the apical domain in the last few frames will have shorter trajecories. Since here we are processing the the data that is obtained after filtering the trajectories, we will get the x and y coordinates of only these BBs and process them further for obtaineing the different distances for which
        % this script is written. On the other hand, the BB_count from 'all trajecotries' without filtering will be used for plotting the Area vs BB_count plot and for obtaining the BB density since we need these data without any trajectory filtering based effects.
        Filtered_frame_wise_data(i,5:(5+length(cord)-1)) = cord; % BB coordinates (x & y in alternating fashion)
    end
    bb_counter = 0; % resetting the counter
    clear cord
end

Filtered_frame_wise_data(Filtered_frame_wise_data==0) = nan; % replacing the zeros with nans.

% the logic below removes rows that are only filled with NaN. This is done in 3 steps:
% (1)goes through the 'Filtered_frame_wise_data' and finds those rows that are filled only with NaN (these rows correspond to the frame numbers that are not part of any of the trajectories)
% (2)finds the indices of those rows
% (3)and removes those rows.
Filtered_frame_wise_data_final = Filtered_frame_wise_data; % reassigning the matrix
FindNaNelements = arrayfun(@(x) x, isnan(Filtered_frame_wise_data_final(:,1)), 'un', 1); % finding those rows where the first column (i.e. frame number) is nan; If the frame number is nan,
% then it means that frame number does not exist in any of the trajectories; The result of this operation will be a logical array
idxNaNelements = find(FindNaNelements); % finding the indices where the logical result is '1'
Filtered_frame_wise_data_final(idxNaNelements,:) = []; % using these indices to remove those rows where the logical result is '1'
% Filtered_frame_wise_data_final is the matrix that stores all the parameters in a framewise manner

%------------------------------------------%
% Here we implement the 1st point as described in the introduction: The minimum distance at which the new BBs appear w.r.to the already existing BBs in the same frame.

% loading the values from the previous analyses which will be used in this script
load('workspace_BB_distance_consequent_frames', 'table_bb_coordinates');
array_new_bb_coordinates = table2array(table_bb_coordinates); % converting the table to array
array_new_bb_coordinates(array_new_bb_coordinates==0) = nan; % replacing the zeros by nans
clear table_bb_coordinates

[rw, cl] = size(array_new_bb_coordinates);
new_bb_appearance_distance = nan(rw,cl); % preassignment of the matrix where the "minimal distances" of new BBs will be stored
new_bb_appearance_distance(:,1) = array_new_bb_coordinates(:,1); % storing the frame numbers
new_bb_appearance_distance(:,2) = array_new_bb_coordinates(:,2); % storing the new BB count
new_bb_count = sum(array_new_bb_coordinates(:,2)); % finding the total number of new BBs that are appearing
max_no_of_new_BB = max(array_new_bb_coordinates(:,2)); % finding the maximum of the new BB count appearing per frame
max_no_of_BB = max(Filtered_frame_wise_data_final(:,4)); % finding the maximum of no of BBs per frame / in other words, it is "resembles in terms of trend" the max of BB count in the BB count vs area plot
totcol = max_no_of_new_BB * max_no_of_BB; % total no of columns to create a matrix where "all the distances" of new BBs will be stored
Dist_Full = nan(rw, totcol+2); % preassignment of the matrix where "all the distances" of new BBs will be stored
Dist_Full(:,1) = array_new_bb_coordinates(:,1); % storing the frame numbers
Dist_Full(:,2) = array_new_bb_coordinates(:,2); % storing the new BB count
sz_array_new_bb_coordinates = size(array_new_bb_coordinates);
len_array_new_bb_coordinates = sz_array_new_bb_coordinates(1,1); % finding the no of rows or no of frames that get new BBs

% In the loop below, we will find the distances of all newly appearing BBs w.r.to the already existing BBs. We will store these distances in the 'Dist_Full' matrix. Then we will find the minima of the distances for every new BB and store them in the
% 'new_bb_appearance_distance' matrix.
for ii = 2:len_array_new_bb_coordinates % going through the whole length of the array that contains the new BB data in a frame wise manner
    bb_appearing_frame = array_new_bb_coordinates(ii,1); % frame at which the new BB appears
    no_of_newly_appearing_bbs_this_frame = array_new_bb_coordinates(ii,2); % no of newly appearing BBs in this frame
    xcrd_list_new_bb = array_new_bb_coordinates(ii,3:2:((no_of_newly_appearing_bbs_this_frame*2)+1)); % x coordinate list of all the new BBs
    ycrd_list_new_bb = array_new_bb_coordinates(ii,4:2:((no_of_newly_appearing_bbs_this_frame*2)+2)); % y coordinate list of all the new BBs
    
    frame_idx = find(Filtered_frame_wise_data_final(:,1)==bb_appearing_frame); % getting the corresponding index of the frame (i.e. 'bb_appearing_frame') that is currently running in the loop, in the 'Filtered_frame_wise_data_final' matrix
    current_frame_no(ii,1) = Filtered_frame_wise_data_final(frame_idx, 1); % getting the frame number that is currently running in the loop
    area_this_frame(ii,1) = Filtered_frame_wise_data_final(frame_idx, 2); % getting the corresponding area for this frame
    actual_no_bb_this_frame(ii,1) = Filtered_frame_wise_data_final(frame_idx, 3); % getting the actual no of already existing BBs in this frame - obtained frm the BB_count of all trajectories without any filtering; this will be used for obtaining the 'BB density'
    no_bb_this_frame = Filtered_frame_wise_data_final(frame_idx, 4); % getting the no of already existing BBs in this frame - obtained from the loop above (i.e. after applying all the filtering on the trajectories) - (for clarity look into the description related to 'Filtered_frame_wise_data(i,4)')
    xcrd_list_all_bb = Filtered_frame_wise_data_final(frame_idx, 5:2:((no_bb_this_frame*2)+3))'; % getting the xcoordinate list of all the already existing BBs
    ycrd_list_all_bb = Filtered_frame_wise_data_final(frame_idx, 6:2:((no_bb_this_frame*2)+4))'; % getting the ycoordinate list of all the already existing BBs
    Dummy_vec = ones(length(xcrd_list_all_bb),1); % getting the dummy vector for computing the distances
    % the logic below in the for loop uses a trick (taught by Mandar Inamdar, IIT Bombay) to find the distance between every new BB in the current
    % frame and all the already exisitng BBs in the same frame without using a for loop to go through every BB. To understand the logic behind the trick,
    % check the script: 'distance_btw_groups_of_particles_without_for_loop.m' in the folder with the miscellaneous scripts.
    start_col = 3;
    for jj = 1:no_of_newly_appearing_bbs_this_frame
        curr_xcrd = xcrd_list_new_bb(1,jj);
        curr_ycrd = ycrd_list_new_bb(1,jj);
        
        dxx = xcrd_list_all_bb*Dummy_vec' - Dummy_vec*curr_xcrd';
        dyy = ycrd_list_all_bb*Dummy_vec' - Dummy_vec*curr_ycrd';
        Dist = sqrt(dxx.^2 + dyy.^2);
        
        Dist(Dist==0) = nan; % changing the zeros (that were obtained on finding the distance between the coordinates of the same BB) to nans
        dist_full = Dist(:,1);
        len_dist_full = length(dist_full);
        end_col = start_col + len_dist_full - 1;
        Dist_Full(ii, start_col:end_col) = dist_full'; % storing all the distances
        start_col = start_col + len_dist_full;
        Dist_min_mat = min(Dist);
        Dist_min = Dist_min_mat(1,1); % getting the minimum of all the distances
        new_bb_appearance_distance (ii, 2+jj) = Dist_min; % storing the minima of the distances
    end
end

new_bb_appearance_distance_micron_ful_mat = new_bb_appearance_distance;
new_bb_appearance_distance_micron_ful_mat(:,3:end) = new_bb_appearance_distance(:,3:end) * pixelwidth; % converting x and y coordinates from pixel values to microns
new_bb_appearance_distance_micron = new_bb_appearance_distance_micron_ful_mat(:,3:end);
% plotting the histogram of 'the minimal distances' by calling the function 'Distribution_Plots'.
parameter = new_bb_appearance_distance_micron; bininterval = 0.05; Xlabel = 'Minimum distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Minimum distance of a newly appearing BB,', 'to the closest, already existing BB in the same frame'}; save_title = 'Minimum_distance_newBB_existingBB';
Distribution_Plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical, save_title);
% plotting the histogram of 'all distances' by calling the function 'Distribution_Plots'
Dist_Full_micron = Dist_Full;
Dist_Full_micron(:,3:end) = Dist_Full(:,3:end) * pixelwidth;
parameter = Dist_Full_micron(:,3:end); bininterval = 0.5; Xlabel = 'Distance of newly appearing BBs [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Distance of newly appearing BBs', 'w.r.to all the existing BBs in the same frame'}; save_title = 'Distance_newBB_existingBB';
Distribution_Plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical, save_title);

%plotting the minimal distances against area
figure(1)
avg_dist = nanmean(new_bb_appearance_distance_micron,2);
% stdev_dist = nanstd(new_bb_appearance_distance_micron,0,2); % errorbar(area_this_frame, avg_dist, stdev_dist, 'ro'); % to be used if needed
plot(area_this_frame, avg_dist, 'ro');
xlabel('Area [\mum^2]'); ylabel('Minimum distance [\mum]'); title({'Avg minimum distance of a newly appearing BB, to the closest,', 'already existing BB in the same frame vs Area'}); set(gca,'fontsize',16);
saveas(gcf, fullfile(BB_apical, 'Minimum_distance_newBB_existingBB_vs_Area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Minimum_distance_newBB_existingBB_vs_Area'), 'tif');

%plotting the minimal distances against time
figure(111)
current_frame_no_min = current_frame_no * Time_interval;
% stdev_dist = nanstd(new_bb_appearance_distance_micron,0,2); % errorbar(current_frame_no_min, avg_dist, stdev_dist, 'mo'); % to be used if needed
plot(current_frame_no_min, avg_dist, 'mo');
xlabel('Time [min]'); ylabel('Minimum distance [\mum]'); title({'Avg minimum distance of a newly appearing BB, to the closest,', 'already existing BB in the same frame vs Time'}); set(gca,'fontsize',16);
saveas(gcf, fullfile(BB_apical, 'Minimum_distance_newBB_existingBB_vs_Time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Minimum_distance_newBB_existingBB_vs_Time'), 'tif');

%plotting the minimal distances against BB count
figure(2)
% stdev_dist = nanstd(new_bb_appearance_distance_micron,0,2); % errorbar(actual_no_bb_this_frame, avg_dist, stdev_dist, 'bo'); % to be used if needed
plot(actual_no_bb_this_frame, avg_dist, 'bo');
xlabel('BB count'); ylabel('Minimum distance [\mum]'); title({'Avg minimum distance of a newly appearing BB, to the closest,', 'already existing BB in the same frame vs BB count'}); set(gca,'fontsize',16);
saveas(gcf, fullfile(BB_apical, 'Minimum_distance_newBB_existingBB_vs_BB_count'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Minimum_distance_newBB_existingBB_vs_BB_count'), 'tif');

%plotting the minimal distances against BB density
figure(3)
BbDensitY = actual_no_bb_this_frame./area_this_frame; % getting the bb density
% stdev_dist = nanstd(new_bb_appearance_distance_micron,0,2); % errorbar(BbDensitY, avg_dist, stdev_dist, 'ko'); % to be used if needed
plot(BbDensitY, avg_dist, 'ko');
xlabel('BB density [\mum^{-2}]'); ylabel('Minimum distance [\mum]'); title({'Avg minimum distance of a newly appearing BB, to the closest,', 'already existing BB in the same frame vs BB density'}); set(gca,'fontsize',16);
saveas(gcf, fullfile(BB_apical, 'Minimum_distance_newBB_existingBB_vs_BB_density'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Minimum_distance_newBB_existingBB_vs_BB_density'), 'tif');

% getting the linearised array of frame numbers, areas and "minimal BB distances" for using in the average script by calling the function 'linear array'
input_matrix = new_bb_appearance_distance_micron_ful_mat; count_of_BBs = new_bb_count; FrameWiseData = Filtered_frame_wise_data_final; checkstring = 'new_bb_appearance_distance_micron_ful_mat';
[linearised_new_bb_appearance_distance_micron_ful_mat] = linear_array(input_matrix, count_of_BBs, FrameWiseData, checkstring); % this is the vector (linearised_new_bb_appearance_distance_micron_ful_mat) where the linearised array of minimal BB distances with other parameters are stored

% getting the linearised array of frame numbers, areas and "all BB distances" for using in the average script by calling the function 'linear array'
CountOfbbs = max(Dist_Full_micron(:,2)) * max(Filtered_frame_wise_data_final(:,4));
input_matrix = Dist_Full_micron; count_of_BBs = CountOfbbs; FrameWiseData = Filtered_frame_wise_data_final; checkstring = 'Dist_Full_micron';
[linearised_Dist_Full_micron] = linear_array(input_matrix, count_of_BBs, FrameWiseData, checkstring); % this is the vector (linearised_new_bb_appearance_distance_micron_ful_mat) where the linearised array of minimal BB distances with other parameters are stored

% Getting the average of the minimum and all distances for every frame; As opposed to the data above where all individual distances taken, here we
% average the individual distances for every frame and get one value per frame for both 'minimum' distance and 'all' distances 
% minimum of distances
avg_new_Exist_bb_Mindist(:,1) =  current_frame_no_min(2:end, 1); % Time in minutes
avg_new_Exist_bb_Mindist(:,2) =  area_this_frame(2:end, 1); % Area
avg_new_Exist_bb_Mindist(:,3) = mean(new_bb_appearance_distance_micron(2:end,:), 2, 'omitnan'); % average of minimum of distances for every new BB in the current frame to all the existing BBs in the current frame
avg_new_Exist_bb_Mindist(:,4) = std(new_bb_appearance_distance_micron(2:end,:), 0, 2, 'omitnan'); % standard deviation of minimum of distances for every new BB in the current frame to all the existing BBs in the current frame
% plotting the distribution
parameter = avg_new_Exist_bb_Mindist(:,3); bininterval = 0.05; Xlabel = 'Averaged Minimum distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Averaged Minimum distance of a newly appearing BB,', 'to the closest, already existing BB in the same frame'}; save_title = 'Minimum_distance_newBB_existingBB_avgd';
Distribution_Plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical, save_title);
% all distances
avg_new_Exist_bb_Alldist(:,1) = Dist_Full_micron(2:end, 1) * Time_interval; % Time in minutes
avg_new_Exist_bb_Alldist(:,2) =  area_this_frame(2:end, 1); % Area & No of new BBs in the corresponding frame
avg_new_Exist_bb_Alldist(:,3) = mean(Dist_Full_micron(2:end, 3:end), 2, 'omitnan'); % average of all distances for every new BB in the current frame to all the existing BBs in the current frame
avg_new_Exist_bb_Alldist(:,4) = std(Dist_Full_micron(2:end, 3:end), 0, 2, 'omitnan'); % standard deviation of all distances for every new BB in the current frame to all the existing BBs in the current frame
% plotting the histogram of 'all distances' by calling the function 'Distribution_Plots'
parameter = avg_new_Exist_bb_Alldist(:,3); bininterval = 0.5; Xlabel = {'Averaged distance of newly', 'appearing BBs [\mum]'}; Ylabel = 'Probability density'; Plot_title = {'Averaged distance of newly appearing BBs', 'w.r.to all the existing BBs in the same frame'}; save_title = 'Distance_newBB_existingBB_avgd';
Distribution_Plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical, save_title);

%------------------------------------------%

% Here we implement the 2nd point as described in the introduction: The nearest neighbor distance between the BBs in the same frame
[ro, co] = size(Filtered_frame_wise_data_final);
neighbor_dist = nan(ro, co); % preassignment of the matrix where the "nearest neighbor distances" of all BBs in a frame will be stored
neighbor_dist(:,1) = Filtered_frame_wise_data_final(:,1); % storing the framenumbers
neighbor_dist(:,2) = Filtered_frame_wise_data_final(:,4); % storing the BBcount
sz_framewisedata = size(Filtered_frame_wise_data_final);
len_framewisedata = sz_framewisedata(1,1); % finding the no of rows or no of frames with BBs i.e. the length of the framewisedata
Bb_CounT = max(Filtered_frame_wise_data_final(:,4));
Total_CL = Bb_CounT^2;
Distc_Full = nan(ro, Total_CL+2); % preassignment of the matrix where "all the distances" of all BBs in a frame will be stored
Distc_Full(:,1) = Filtered_frame_wise_data_final(:,1); % storing the framenumbers
Distc_Full(:,2) = Filtered_frame_wise_data_final(:,4); % storing the BBcount

% In the loop below, we will find the distances of all existing BBs w.r.to other BBs. We will store these distances in the 'Distc_Full' matrix. Then we will find the minima of the distances which will be the nearest neighbor distance
% for every new BB and store them in the 'neighbor_dist' matrix.
for kk = 1:len_framewisedata % going through the whole length of the array that contains all the BB data in a frame wise manner
    Curent_frame_number(kk,1) = Filtered_frame_wise_data_final(kk, 1); % getting the frame number that is currently running in the loop
    Area_This_Frame(kk,1) = Filtered_frame_wise_data_final(kk, 2); % getting the area for the corresponding frame that is currently running in the loop, in the 'Filtered_frame_wise_data_final' matrix
    Actual_No_BB_this_Frame(kk,1) = Filtered_frame_wise_data_final(kk, 3); % getting the actual no of already existing BBs in this frame - obtained frm the BB_count of all trajectories without any filtering; this will be used for obtaining the 'BB density'
    No_bb_this_Frame = Filtered_frame_wise_data_final(kk, 4); % getting the no of already existing BBs in this frame - obtained from the loop above (i.e. after applying all the filtering on the trajectories) - (for clarity look into the description related to 'Filtered_frame_wise_data(i,4)')
    XCrd_List_all_bb = Filtered_frame_wise_data_final(kk, 5:2:((No_bb_this_Frame*2)+3)); % getting the list of x coordinates for all BBs in this frame
    YCrd_List_all_bb = Filtered_frame_wise_data_final(kk, 6:2:((No_bb_this_Frame*2)+4)); % getting the list of y coordinates for all BBs in this frame
    DummY_Vec = ones(length(XCrd_List_all_bb),1); % getting the dummy vector for computing the distances
    % the logic below in the for loop uses a trick (taught by Mandar Inamdar, IIT Bombay) to find the distance between every new BB in the current
    % frame and all the already exisitng BBs in the same frame without using a for loop to go through every BB. To understand the logic behind the trick,
    % check the script: 'distance_btw_groups_of_particles_without_for_loop.m' in the folder with the miscellaneous scripts.
    strt_cl = 3;
    for ll = 1:No_bb_this_Frame
        Cur_Xcrd = XCrd_List_all_bb(1,ll);
        Cur_Ycrd = YCrd_List_all_bb(1,ll);
        
        dXX = XCrd_List_all_bb'*DummY_Vec' - DummY_Vec*Cur_Xcrd';
        dYY = YCrd_List_all_bb'*DummY_Vec' - DummY_Vec*Cur_Ycrd';
        distc = sqrt(dXX.^2 + dYY.^2);
        
        distc(distc==0) = nan; % changing the zeros (that were obtained on finding the distance between the coordinates of the same BB) to nans
        distc_full = distc(:,1);
        len_distc_full = length(distc_full);
        End_cl = strt_cl + len_distc_full - 1;
        Distc_Full(kk, strt_cl:End_cl) = distc_full'; % storing all the distances
        strt_cl = strt_cl + len_distc_full;
        distc_min_mat = min(distc);
        distc_min = distc_min_mat(1,1); % getting the minimum / nearest neighbor of all the distances
        neighbor_dist (kk, 2+ll) = distc_min; % storing the nearest neighbor distance
    end
end

neighbor_dist_micron_ful_mat = neighbor_dist;
neighbor_dist_micron_ful_mat(:,3:end) = neighbor_dist(:,3:end) * pixelwidth; % converting x and y coordinate pixel distances to microns
neighbor_dist_micron = neighbor_dist_micron_ful_mat(:,3:end);
% plotting the histogram of 'the minimal distances / nearest neighbor distances' by calling the function 'Distribution_Plots'.
parameter = neighbor_dist_micron; bininterval = 0.075; Xlabel = 'Nearest Neighbor distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Nearest Neighbor distance of BBs', 'w.r.to all other BBs in every frame'}; save_title = 'Nearest_Neighbor_distance';
Distribution_Plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical, save_title);
% plotting the histogram of 'all distances' by calling the function 'Distribution_Plots'
Distc_Full_micron = Distc_Full;
Distc_Full_micron(:,3:end) = Distc_Full(:,3:end) * pixelwidth;
parameter = Distc_Full_micron(:,3:end); bininterval = 0.5; Xlabel = 'Distance between BBs [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Distance between all BBs', 'in every frame'}; save_title = 'Distance_between_all_BBs';
Distribution_Plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical, save_title);

%plotting the nearest neighbor distances against area
figure(4)
Avg_Dist = nanmean(neighbor_dist_micron,2);
% Stdev_Dist = nanstd(neighbor_dist_micron,0,2); errorbar(Area_This_Frame, Avg_Dist, Stdev_Dist, 'r*'); % to be used if needed
plot(Area_This_Frame, Avg_Dist, 'r*');
xlabel('Area [\mum^2]'); ylabel('Nearest Neighbor distance [\mum]'); title({'Nearest neighbor distance of all BB,', 'over time / Area'}); set(gca,'fontsize',16);
saveas(gcf, fullfile(BB_apical, 'Nearest_Neighbor_distance_vs_Area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Nearest_Neighbor_distance_vs_Area'), 'tif');

%plotting the nearest neighbor distances against time
figure(444)
Curent_frame_number_min = Curent_frame_number * Time_interval;
% Stdev_Dist = nanstd(neighbor_dist_micron,0,2); errorbar(Curent_frame_number_min, Avg_Dist, Stdev_Dist, 'm*'); % to be used if needed
plot(Curent_frame_number_min, Avg_Dist, 'm*');
xlabel('Time [min]'); ylabel('Nearest Neighbor distance [\mum]'); title({'Nearest neighbor distance of all BB,', 'over time / Time'}); set(gca,'fontsize',16);
saveas(gcf, fullfile(BB_apical, 'Nearest_Neighbor_distance_vs_Time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Nearest_Neighbor_distance_vs_Time'), 'tif');

%plotting the nearest neighbor distances against number of bbs
figure(5)
% Stdev_Dist = nanstd(neighbor_dist_micron,0,2); errorbar(Actual_No_BB_this_Frame, Avg_Dist, Stdev_Dist, 'b*'); % to be used if needed
plot(Actual_No_BB_this_Frame, Avg_Dist, 'b*');
xlabel('BB count'); ylabel('Nearest Neighbor distance [\mum]'); title({'Nearest neighbor distance of all BB,', 'against BB count'}); set(gca,'fontsize',16);
saveas(gcf, fullfile(BB_apical, 'Nearest_Neighbor_distance_vs_BB_count'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Nearest_Neighbor_distance_vs_BB_count'), 'tif');

%plotting the nearest neighbor distances against BB density
figure(6)
bBdensiTy = Actual_No_BB_this_Frame./Area_This_Frame; % getting the bb density
% Stdev_Dist = nanstd(neighbor_dist_micron,0,2); errorbar(bBdensiTy, Avg_Dist, Stdev_Dist, 'k*'); % to be used if needed
plot(bBdensiTy, Avg_Dist, 'k*');
xlabel('BB density [\mum^{-2}]'); ylabel('Nearest Neighbor distance [\mum]'); title({'Nearest neighbor distance of all BB,', 'against BB density'}); set(gca,'fontsize',16);
saveas(gcf, fullfile(BB_apical, 'Nearest_Neighbor_distance_vs_BB_density'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Nearest_Neighbor_distance_vs_BB_density'), 'tif');

% getting the linearised array of frame numbers, areas and "nearest neighbor BB distances" for using in the average script by calling the function 'linear_array'
input_matrix = neighbor_dist_micron_ful_mat; count_of_BBs = Bb_CounT; FrameWiseData = Filtered_frame_wise_data_final; checkstring = 'neighbor_dist_micron_ful_mat';
[linearised_neighbor_dist_micron_ful_mat] = linear_array(input_matrix, count_of_BBs, FrameWiseData, checkstring); % this is the vector (linearised_neighbor_dist_micron_ful_mat) where the linearised array of nearest neighbor BB distances with other parameters are stored

% getting the linearised array of frame numbers, areas and "all BB distances" for using in the average script by calling the function 'linear_array'
input_matrix = Distc_Full_micron; count_of_BBs = Total_CL; FrameWiseData = Filtered_frame_wise_data_final; checkstring = 'Distc_Full_micron';
[linearised_Distc_Full_micron] = linear_array(input_matrix, count_of_BBs, FrameWiseData, checkstring); % this is the vector (linearised_Distc_Full_micron) where the linearised array of nearest neighbor BB distances with other parameters are stored

% Getting the average of the minimum and all distances for every frame; As opposed to the data above where all individual distances taken, here we
% average the individual distances for every frame and get one value per frame for both 'minimum' distance and 'all' 
% minimum of distances
avg_Near_Neighbour_bb_Mindist(:,1) =  Curent_frame_number_min; % Time in minutes
avg_Near_Neighbour_bb_Mindist(:,2) =  Area_This_Frame; % Area
avg_Near_Neighbour_bb_Mindist(:,3) = mean(neighbor_dist_micron, 2, 'omitnan'); % average of nearest neighbor distances for all existing BBs in the current frame
avg_Near_Neighbour_bb_Mindist(:,4) = std(neighbor_dist_micron, 0, 2, 'omitnan'); % standard deviation of nearest neighbor distances for all existing BBs in the current frame
% plotting the distribution
parameter = avg_Near_Neighbour_bb_Mindist(:,3); bininterval = 0.05; Xlabel = 'Averaged Nearest Neighbor distance [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Averaged Nearest Neighbor distance of BBs', 'w.r.to all other BBs in every frame'}; save_title = 'Nearest_Neighbor_distance_avgd';
Distribution_Plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical, save_title);
% all distances
avg_Exist_bb_Alldist(:,1) = Distc_Full_micron(:, 1) * Time_interval; % Time in minutes
avg_Exist_bb_Alldist(:,2) =  Area_This_Frame; % Area & No of new BBs in the corresponding frame
avg_Exist_bb_Alldist(:,3) = mean(Distc_Full_micron(:, 3:end), 2, 'omitnan'); % average of all distances for all existing BBs in the current frame
avg_Exist_bb_Alldist(:,4) = std(Distc_Full_micron(:, 3:end), 0, 2, 'omitnan'); % standard deviation of all distances for all existing BBs in the current frame
% plotting the distribution
parameter = avg_Exist_bb_Alldist(:,3); bininterval = 0.25; Xlabel = 'Averaged Distance between BBs [\mum]'; Ylabel = 'Probability density'; Plot_title = {'Averaged Distance between all BBs', 'in every frame'}; save_title = 'Distance_between_all_BBs_avgd';
Distribution_Plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical, save_title);

close all;

%%
% saving workspace
save('workspace_BB_distance_same_frame');

%%
% Saving the figures as montage

BB_apical_area_frac = '../Plots/BB_appearance_location'; % location from where some plots will be fetched

montage_fig = '../Plots/montage';
fig1 = fullfile(BB_apical, 'BB_appearance_dist_vs_area.tif');
fig2 = fullfile(BB_apical, 'BB_appearance_dist_vs_BB_count.tif');
fig222 = fullfile(BB_apical, 'BB_appearance_dist_vs_time.tif');
%fig3 = fullfile(BB_apical, 'BB_appearance_dist_vs_BB_rate.tif'); % can be uncommented and used if needed; the figure is ready to be plotted but commented in the script above
fig4 = fullfile(BB_apical, 'BB_appearance_dist_vs_BB_density.tif');
fig5 = fullfile(BB_apical, 'BB_appearance_dist_barplot.tif');
fig55 = fullfile(BB_apical, 'BB_appearance_dist_barplot_avgd.tif');
fig6 = fullfile(BB_apical, 'BB_appearance_all_distances.tif');
fig66 = fullfile(BB_apical, 'BB_appearance_all_distances_avgd.tif');
fig7 = fullfile(BB_apical_area_frac, 'Distance_fraction_vs_new_BB_appearance.tif');
fig8 = fullfile(BB_apical, 'Minimum_distance_newBB_existingBB.tif');
fig88 = fullfile(BB_apical, 'Minimum_distance_newBB_existingBB_avgd.tif');
fig9 = fullfile(BB_apical, 'Distance_newBB_existingBB.tif');
fig99 = fullfile(BB_apical, 'Distance_newBB_existingBB_avgd.tif');
fig10 = fullfile(BB_apical, 'Minimum_distance_newBB_existingBB_vs_Area.tif');
fig101 = fullfile(BB_apical, 'Minimum_distance_newBB_existingBB_vs_Time.tif');
fig11 = fullfile(BB_apical, 'Minimum_distance_newBB_existingBB_vs_BB_count.tif');
fig12 = fullfile(BB_apical, 'Minimum_distance_newBB_existingBB_vs_BB_density.tif');
fig13 = fullfile(BB_apical, 'Nearest_Neighbor_distance.tif');
fig133 = fullfile(BB_apical, 'Nearest_Neighbor_distance_avgd.tif');
fig14 = fullfile(BB_apical, 'Distance_between_all_BBs.tif');
fig144 = fullfile(BB_apical, 'Distance_between_all_BBs_avgd.tif');
fig15 = fullfile(BB_apical, 'Nearest_Neighbor_distance_vs_Area.tif');
fig151 = fullfile(BB_apical, 'Nearest_Neighbor_distance_vs_Time.tif');
fig16 = fullfile(BB_apical, 'Nearest_Neighbor_distance_vs_BB_count.tif');
fig17 = fullfile(BB_apical, 'Nearest_Neighbor_distance_vs_BB_density.tif');

montage({fig1, fig2, fig222, fig4, fig5, fig55, fig6, fig66, fig7, fig8, fig88, fig9, fig99, fig10, fig101, fig11, fig12, fig13, fig133, fig14, fig144, fig15, fig151, fig16, fig17});
saveas(gcf, fullfile(montage_fig,'slide_19_bb_distances'), 'tif');

close all;

disp('Finished !');


%%
% this function works for the 2nd section of the code where distances between the new BBs and the already existing BBs & neighbor distances are obtained
% this function is used to linearise the final matrices so that they can be used in the average script
function [output_linear_matrix] = linear_array(input_matrix, count_of_BBs, FrameWiseData, checkstring, StartColumn)
[rr, ~] = size(input_matrix);
cum_bb_count = 0;
linearised_input_matrix = nan(count_of_BBs, 4); % preassignment
for m = 1:rr % this loop goes through all the rows of the 'input_matrix' matrix
    noNewBB = input_matrix(m,2); % no of new BBs in this frame
    corres_frame_idx = FrameWiseData(:,1)==input_matrix(m,1); % getting the index of the frame number
    if contains(checkstring, 'Dist_Full_micron') || contains(checkstring, 'Distc_Full_micron') % checking if the input_matrix consists of 'the minimal distances' or 'all distances' in both cases of "new vs existing BBs" and "amongst existing BBs"
        noexistingBB = FrameWiseData(corres_frame_idx, 4); % No of BBs in this frame (only if the input matrix consists of 'all distances'); % getting the no of already existing BBs in this
        % frame - obtained from one of the loops above (i.e. after applying all the filtering on the trajectories) - (for clarity look into the description related to 'Filtered_frame_wise_data(i,4)')
    else
        noexistingBB = 1; % If the input matrix consists of 'minimal distances'
    end
    No_Bb_this_frame = noNewBB * noexistingBB;
    linearised_input_matrix(cum_bb_count+1:cum_bb_count+No_Bb_this_frame, 1) = input_matrix(m,1); % assigning frame number
    
    corres_area = FrameWiseData(corres_frame_idx,2); % getting area
    linearised_input_matrix(cum_bb_count+1:cum_bb_count+No_Bb_this_frame, 2) = corres_area; % assigning area
    
    corres_BB_count = FrameWiseData(corres_frame_idx,3); % getting BB count
    linearised_input_matrix(cum_bb_count+1:cum_bb_count+No_Bb_this_frame, 3) = corres_BB_count; % assigning BB count
    
    linearised_input_matrix(cum_bb_count+1:cum_bb_count+No_Bb_this_frame, 4) = input_matrix(m, 3:3+No_Bb_this_frame-1); % assigning BB distances
    cum_bb_count = cum_bb_count + No_Bb_this_frame; % getting the cumulative BB no after every iteration
end
output_linear_matrix = linearised_input_matrix; % newly constructed linearised matrix
end

%%
% this function works for the 2nd section of the code where distances between the new BBs and the already existing BBs & neighbor distances are obtained
% Function that generates the histogram plots i.e. the frequency distribution of a particular parameter
function Distribution_Plots(parameter, bininterval, Xlabel, Ylabel, Plot_title, BB_apical, save_title)
% Binning the data
figure(100);
binparameter = parameter(~isnan(parameter));
binrange = min(binparameter):bininterval:max(binparameter); % setting the bin range based on the input data which is the distances
[N, ~] = histcounts(binparameter, binrange); % here 'N' corresponds to the counts or the repeats of the data; and edges is same as the binrange defined above.
binrange1 = binrange(1:end-1); % changing the binrange length to match the length of N so that they can be plotted together.
% barplot = bar(binrange1, N); barplot.FaceColor = 'r'; barplot.EdgeColor = 'b';
histplot = histogram(binparameter, binrange1, 'Normalization', 'pdf'); histplot.FaceColor = 'r'; histplot.FaceAlpha = 1; histplot.EdgeColor = 'b'; histplot.LineWidth = 1; % either barplot or histogram plot can be used

xlabel(Xlabel);  ylabel(Ylabel); title(Plot_title);  set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, save_title), 'fig'); saveas(gcf, fullfile(BB_apical, save_title), 'tif');
%pause;
close (figure(100));

clear parameter bininterval xLabel yLabel plot_Title BB_apical save_title

end

%%


























