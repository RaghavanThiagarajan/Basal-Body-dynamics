% Raghavan Thigarajan, 31 December 2024, reNEW, Copenhagen

% This script is used for plotting all the trajectories in individual frames. The main motivation for the script came for this reason: we wanted to use the trajectories plotted by the particle tracker 2d/3d plugin in Fiji
% (Sbalzarini's plugin) in the figures. However because the plugin marks the interpolated trajectory steps in red color, the trajectories visually look bit weird with a mix of red here and there. Therefore to avoid this, we decided to
% replot all the trajectories so that they look visually appealing.
% However, the BB data matrix 'Trajectory_data' is organised w.r.to frames. Meaning, the row numbers correspond to trajectories and each column contains the data (i..e frames, x & y coordinates etc) of that trajectory. In order to plot all
% trajectories in individual frames (i.e. every frame will show all the trajectories present in that frame and we will have a stack of such frames), it is convenient to re-order all the 'Trajectory_data' in such a
% way that row numbers correspond to frame numbers and each row/frame contains the corresponding data (i.e trajectory numbers of all trajectories present in the frame, their x & y coordinates). This will allow to plot all the
% trajectories in every frame. The final matrix 'traj_reconstruct_cellarray' is constructed in a way that for every row/frame, the trajectory numbers of all trajectories recorded for this frame are stored in column 2, and the x & y coordinates of all these
% trajectories not only for this frame but also for the previous frames are stored in column 3 & 4 respectively. This way we can just plot all the x & y of every row in a separate figure and build a stack.

% Below when we plot the trajectories, for easy visualization, we remove all trajectories that are less than 4 steps for those frames after 50. Also we plot only trajectories that are found in the current frame or current frame minus 3 frames.
% If a trajectory is not found in any of these 4 frames, then it is not displayed in the subsequent frames.

%%
tic
clc
close all
clear all

%% section 1: first we collect all the data and reorganise them for easy plotting

% Initialising folders, savelinks, and importing data
mkdir '../Plots/drift_plots/individual_trajectories';
load('workspace_interim.mat', 'Image_dime', 'pixelwidth', 'Time_interval', 'No_of_timepoints', 'Trajectory_data', 'traj_filter_duration');

% Getting the frame numbers that have trajectories.
% Detail: When compared to the actual BB image stack, not all frames are found in the final tracked image stack (which is the output of the particle 2d/3d plugin). This could be because of two reasons: (1) Sometimes, some frames do not record any trajectories
% simply because the BBs in this frame are not detected or they are detected but not inlcuded as part of any trajectory. Usually, these are the earliest frames where there are less number of BBs and BBs are still not docked properly meaning they enter and exit
% every frame. So these frames will not be included in the tracking; (2) Another reason is, I might have manually deleted a frame (or max. 2 frames) because of some particle detection issue, acquision issue or some other things. This frame will not be present
% in the final tracked data stack compared to the original image stack. In any case, its not that all cells/experiments will be missing some frames. This is only for those cells/experiments where there are some missing frames because of these reasons. On the
% other hand, even if there are missing frames, at max there is one or 2 frames missing. Not more than that. So if there are such missing frames, the total no. of frame numbers / time points will be different compared to the original image stack. Therefore,
% I go through the 2nd column of the cell array Trajectory_data, put the contents of all the cells together, sort them and then fetch only the non-repetitive or unique numbers. so this array (all_fram_nos) contains the frame numbers that contain trajectories
% and length of this array 'all_fram_nos' is the total no of frames.
all_fram_nos = unique(sort(cell2mat(Trajectory_data(:,2)), 'ascend'));

% getting the total number of frames in which we can identify a trajectory
no_of_frames = length(all_fram_nos);
% getting the total number of trajectories
totno_of_trajs = size(Trajectory_data,1);

% creating a new cell array in which we will store the trajectory coordinates for every frame.
% Meaning, in this cell array, the rows corresponds to the frame numbers. And in each row (i.e. for each frame), we store the frame number in column 1, the trajectory numbers that are recorded as cell contents in column 2; the x coordinates of each trajectory for that frame and all the
% previous frames in column 3; the y coordinates of each trajectory for that frame and all the previous frames in column 4. In columns 3 & 4, the rows correspond to the no of frames and each column corresponds to a trajectory.
traj_reconstruct_cellarray = cell(no_of_frames, 4);

% Filling the first column with time points
traj_reconstruct_cellarray(:, 1) = num2cell(all_fram_nos);

% In the for loop below, we go through every trajectory and look for the data corresponding to that particular frame and fill the "traj_reconstruct_cellarray".
for i = 1:no_of_frames % getting the data for every frame
    % preallocating the columns 2,3 & 4 of traj_reconstruct_cellarray
    traj_reconstruct_cellarray{i, 2} = []; % trajectory numbers
    x_cordnts = NaN(no_of_frames, totno_of_trajs); % x coordinates
    y_cordnts = NaN(no_of_frames, totno_of_trajs); % y coordinates

    % Defining the frame window upto which the trajectories should be checked and added for this frame
    % This allows us to plot only those trajectories that are found in the current frame or current frame minus (number below) frames
    frame_window = (i-3) : i;
    frame_window = frame_window(frame_window >= 1);

    % fetching the data for corresponding time point 'i' for every trajectory
    for j = 1:totno_of_trajs
        framenumbers = Trajectory_data{j, 2}; % getting framenumbers for this trajectory
        xcrdns = Trajectory_data{j, 3}; % getting x coordinates for this trajectory
        ycrdns = Trajectory_data{j, 4}; % getting y coordinates for this trajectory

        frame_window_idx = find(ismember(framenumbers, frame_window)); % checking if this trajectory is present in the current frame or current frame minus (numberin 'frame_window') frames
        % if the trajectory is present in the current frame or in the current frame minus (numberin 'frame_window') frames, then the trajectory numbers and x&y coordinates are filled for this row/column
        if ~isempty(frame_window_idx)
            traj_reconstruct_cellarray{i, 2} = [traj_reconstruct_cellarray{i, 2}; j]; % trajectory numbers
            framenumber_limit = find(framenumbers <= i, 1, 'last');
            x_cordnts(1:framenumber_limit, j) = xcrdns(1:framenumber_limit); % x coordinates of all trajectories found in the current frame
            y_cordnts(1:framenumber_limit, j) = ycrdns(1:framenumber_limit); % y coordinates of all trajectories found in the current frame
        end
    end
    traj_reconstruct_cellarray{i,3} = x_cordnts(1:i, :); % storing the x coordinates in the 'traj_reconstruct_cellarray' matrix for this row/frame
    traj_reconstruct_cellarray{i,4} = y_cordnts(1:i, :); % storing the y coordinates in the 'traj_reconstruct_cellarray' matrix for this row/frame
end

%% section 2: here we plot all the data in the cell array 'traj_reconstruct_cellarray' in individual frames

% Predefining a colormap for consistent trajectory colors
% Below we use a function from the Matlab file exchange called 'distinguishable_colors.m'; This file is saved along with this script in the Plots_matlab_script folder; this function generates one color per trajectory
cmap = distinguishable_colors(totno_of_trajs);
% Below we have two cases to switch: (1) 'highres_image': this case produces high resolution image as output but it does not exactly fit/match the size of the raw image (i.e. the .tif microscopy image of BB). So these images can be used independently but not for side-by-side
% comparison of raw BB image the output track image; (2) 'matching_rawdata': this case produces an image that is exactly the same size and resolution of the raw BB image. In order to get the same size and resolution, we use the cleared raw image of BB as input and plot the
% trajectories on top of these images. This allows side-by-side comparison of raw image and the plotted images
type_of_output_image = 'matching_rawdata'; % The two options are 'matching_rawdata' & 'highres_image'
switch type_of_output_image
    %=====================%=====================%
    case 'highres_image'
        mkdir '../Plots/drift_plots/individual_trajectories/fig_highres';
        mkdir '../Plots/drift_plots/individual_trajectories/tif_highres';
        save_link_indvid_traj_fig_highres = '../Plots/drift_plots/individual_trajectories/fig_highres';
        save_link_indvid_traj_tif_highres = '../Plots/drift_plots/individual_trajectories/tif_highres';
        parfor i = 1:no_of_frames
            % Create a new figure for each frame
            fig = figure(i);
            % Explicitly set figure properties
            set(fig, 'Color', 'k'); % Set figure background to black
            set(fig, 'position', [10, 10, Image_dime(1,1), Image_dime(1,2)]); % setting the size of the image to be the same size as the stack used for image analysis in Fiji
            set(fig, 'InvertHardcopy', 'off'); % to make sure the figure background is black; this option works when used in combination with 'print' command for saving the figures as tif files.
            % Explicitly set axes properties
            axs = axes('Parent', fig);
            set(axs, 'Color', 'k', 'XColor', 'w', 'YColor', 'w', 'GridColor', 'w'); %
            set(axs, 'YDir', 'reverse'); % Reverse Y-axis direction
            hold on; % Retain properties while plotting            
            % Below we go through every trajectory in this frame and plot it
            for j = 1:totno_of_trajs
                x_pts = traj_reconstruct_cellarray{i, 3}(:, j);
                y_pts = traj_reconstruct_cellarray{i, 4}(:, j);
                if ~all(isnan(x_pts)) && (i <= 50 || length(x_pts(~isnan(x_pts))) > 4)  % Skip if all points are NaN or if the length of trajectory is less than 4 frames for frames more than 50
                    % plotting the whole trajectory
                    plot(x_pts, y_pts, '-', 'Color', cmap(j, :), 'LineWidth', 1); % Using cmap(j,:), we plot the same color for the trajectories across frames; otherwise the color of the trajectories change across frames making it difficult to track
                    % plot the starting point
                    % plot(x_pts(1), y_pts(1), '.', 'MarkerSize', 6, 'Color', 'w');
                    % plot the endpoint
                    end_x_pt = x_pts(find(~isnan(x_pts), 1, 'last')); % finding the last point in x_pts that is not NaN
                    end_y_pt = y_pts(find(~isnan(y_pts), 1, 'last')); % finding the last point in y_pts that is not NaN
                    plot(end_x_pt, end_y_pt, '.', 'MarkerSize', 6, 'Color', 'w'); % 'Color', cmap(j, :)
                end
            end
            % Set limits and other properties
            xlim([1 Image_dime(1,1)]); ylim([1 Image_dime(1,2)]);
            axis off;
            % Save the figure for this frame
            parfor_save('t_', save_link_indvid_traj_fig_highres, save_link_indvid_traj_tif_highres, i);
        end
        %=====================%=====================%
    case 'matching_rawdata'
        mkdir '../Plots/drift_plots/individual_trajectories/tif_raw_bb_imgs';
        % In this case, we will use the raw .tif BB images as input instead of creating a new figure as we did in the previous case. For this, first we need the cleared .tif images of BBs. So we copy the
        % cleared BB images that were previously used for plotting the BB appearance and disappearance.
        input_imgs_link_indvid_traj_tif = '../Plots/drift_plots/individual_trajectories/bb_imgs_input/';
        sourcefolder = strcat('../Plots/t0_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/bb_appearance_input');
        save_link_indvid_traj_tif_raw = '../Plots/drift_plots/individual_trajectories/tif_raw_bb_imgs';
        % The if condition below makes sure the folder is copied only if it doesnt exist
        if ~isfolder(input_imgs_link_indvid_traj_tif)
            copyfile(sourcefolder, input_imgs_link_indvid_traj_tif);
            disp('waiting for 10 seconds to copy the input images');
            pause(10);
            clc;
        else
            disp('"bb_imgs_input" folder present')
        end
        parfor i = 1:no_of_frames
            % importing the BB raw image on which the trajectories will be plotted
            bbimagesinp = strcat(input_imgs_link_indvid_traj_tif, 'bb_', sprintf('%03d',i), '.tif');
            BBforproces = imread(bbimagesinp);
            imshow(BBforproces);
            hold on;
            % Below we go through every trajectory in this frame and plot it
            for j = 1:totno_of_trajs
                x_pts = traj_reconstruct_cellarray{i, 3}(:, j);
                y_pts = traj_reconstruct_cellarray{i, 4}(:, j);
                if ~all(isnan(x_pts)) && (i <= 50 || length(x_pts(~isnan(x_pts))) > 4)  % Skip if all points are NaN or if the length of trajectory is less than 4 frames for frames more than 50
                    % plotting the whole trajectory
                    plot(x_pts, y_pts, '-', 'Color', cmap(j, :), 'LineWidth', 1); % Using cmap(j,:), we plot the same color for the trajectories across frames; otherwise the color of the trajectories change across frames making it difficult to track
                    % plot the starting point
                    % plot(x_pts(1), y_pts(1), '.', 'MarkerSize', 6, 'Color', 'w');
                    % plot the endpoint
                    end_x_pt = x_pts(find(~isnan(x_pts), 1, 'last')); % finding the last point in x_pts that is not NaN
                    end_y_pt = y_pts(find(~isnan(y_pts), 1, 'last')); % finding the last point in y_pts that is not NaN
                    plot(end_x_pt, end_y_pt, '.', 'MarkerSize', 6, 'Color', 'w'); % 'Color', cmap(j, :)
                end
            end
            % Save the modified image
            bbimagesave = strcat(save_link_indvid_traj_tif_raw, '/bb_',sprintf('%02d',i), '.tif');
            f = getframe(gca);
            im = frame2im(f);
            imwrite(im, bbimagesave);
        end
end
clc;
close all;

%% saving workspace
save('workspace_trajectories_reconstructed')

%% Function that does the saving for the Parpool process
function parfor_save(plot_save_name, savelink_plot_colorcde_fig,  savelink_plot_colorcde_tif, iterant)
saveas(gcf, fullfile(savelink_plot_colorcde_fig, strcat(plot_save_name, sprintf('%01d',iterant))), 'fig');
figlink = fullfile(savelink_plot_colorcde_tif, strcat(plot_save_name, sprintf('%01d',iterant), '.tif'));
% exportgraphics(gcf, figlink); % 'Resolution',300
print(gcf, figlink, '-dtiff', '-r300'); % print is a way to save the figures as tiff file where the size of the image output is strictly maintained
%close(figure(iterant));
end

%%











