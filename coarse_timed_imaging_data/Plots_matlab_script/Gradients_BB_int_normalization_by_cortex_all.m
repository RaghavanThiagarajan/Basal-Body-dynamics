%% Raghavan Thiagarajan, DanStem, Copenhagen, July 2020

% This is one of the first scripts in the pipeline for BB analysis where we get the characteristics of all BB trajectories without any filtering. Here we get all the basic parameters like area, BB count, actin intensities and generate 
% most of the parent matrices that will be used later in many of the scripts down the pipeline.

%%
% Creating directories for saving the plots
close all;
clearvars -except traj_segregate_duration;
clc;
 
 
%% Loading data
% Loading stack dimensions 
 
Imagedim = importdata('../data/Gradients_of_actin_intensity/Image_dimensions.txt');
Image_dime = Imagedim.data;
pixelwidth = Image_dime(1,3); % In micrometers. For conversion between micrometers and pixels.
frame_interval = Image_dime(1,5); % In sec
Time_interval = frame_interval/60; % In minutes
No_of_timepoints = Image_dime(1,6); % In no. of frames        
No_of_slices = Image_dime(1,7); % In no. of z slices 
voxeldepth = Image_dime(1,8); % In micrometers. Spacing / interval between two z slices.
 
Ap_slice = 1; % Slice corresponding to the apical domain (maximum intensity slice)        (CHANGE THIS !!!)
zslice_acquired_thickness = 1; % In micrometers. Thickness of each acquired slice.        (CHANGE THIS !!!)
zslice_total_thickness = zslice_acquired_thickness + voxeldepth; % In micrometers. Ex: Slice thickness = 1 micrometer; Slice interval = 0.25 micrometer; Total thickness per slice = 1.25 micrometer.
 
% Importing background intensity measurements and cortical measurements
% All_background = cell(1, No_of_timepoints);
cortex_meanint = cell(1, No_of_timepoints);
cortex_totalint = cell(1, No_of_timepoints);
 
for i = 1:No_of_timepoints
    
        % % Loading the background intensity files
        % background = '../data/Background_actin_intensity_ROI_data/Full_Measure/Measure_background_results_t_';
        % backgroundsubtraction = strcat(background, sprintf('%01d',i), '.txt');
        % Backgroundsubtraction = importdata(backgroundsubtraction);
        % Background_Subtraction = Backgroundsubtraction.data;
        % Background_meanint = Background_Subtraction(:,3);
        % All_background{1,i} = Background_meanint;
        % clear Backgroundsubtraction;
        % clear Background_Subtraction;        
        
        % Loading the intensity files for cortex
        cortex = '../data/Gradients_of_actin_intensity/Cortex_intensity_ROI_data/Full_Measure/Mean_Intensity_t_';
        cortexintensity = strcat(cortex, sprintf('%01d',i), '.txt');
        cortexintensity = importdata(cortexintensity);
        cortex_intensity = cortexintensity.data;
        cortex_area = cortex_intensity(:,2); 
        cortex_meanintensity = cortex_intensity(:,3); 
        cortex_totalintensity = cortex_intensity(:,22); 
        cortex_meanint{1,i} = cortex_meanintensity; % - All_background{1,i};
        cortex_totalint{1,i} = cortex_totalintensity; % - (All_background{1,i} .* cortex_area);
        clear cortexintensity;
        clear cortex_intensity;
        
end
 
%% Plotting whole ROI properties
 
% Loading data files obtained from the imageJ processing
Input.Wholeroimeasure = '../data/Gradients_of_actin_intensity/Whole_ROI_Measure/whole_roi_measure_t';
WholeRoimeasure = Input.Wholeroimeasure; 
Area_apicaldomain = zeros(No_of_timepoints,1); Circularity_apicaldomain = zeros(No_of_timepoints,1); Timepoint = zeros(No_of_timepoints,1);
MeanIntensity_apicaldomain = zeros(No_of_timepoints,1); TotalIntensity_apicaldomain = zeros(No_of_timepoints,1); centroid_movement = zeros(No_of_timepoints,1);
CortexMeanint_apical = zeros(No_of_timepoints,1); CortexTotint_apical = zeros(No_of_timepoints,1);
 
for i = 1:No_of_timepoints
        
    % Loading the data files
    WholeROImeasure = strcat(WholeRoimeasure, sprintf('%01d',i), '.txt');
    Whole_roimeasure = importdata(WholeROImeasure);
    Whole_roi_measure = Whole_roimeasure.data;
    clear Whole_roimeasure;
    
    Area_stack = Whole_roi_measure(:,2);    
    Area_apicaldomain(i,1) = Whole_roi_measure(Ap_slice,2);
    
    Circularity_stack = Whole_roi_measure(:,20);
    Circularity_apicaldomain(i,1) = Whole_roi_measure(Ap_slice,20);
    
    major_axis(i,1) = Whole_roi_measure(Ap_slice,17);
    minor_axis(i,1) = Whole_roi_measure(Ap_slice,18);
    ellipse_angle(i,1) = Whole_roi_measure(Ap_slice,19);
    aspect_ratio(i,1) = major_axis(i,1) / minor_axis(i,1);
    
    CortexMeanint_apical(i,1) = cortex_meanint{1,i}(Ap_slice,1);
    CortexTotint_apical(i,1) = cortex_totalint{1,i}(Ap_slice,1);
    
    % Centroid measurement
    % The "if loop" makes sure that the distance is calculated when there are two points.
%     Centroid_stackx = Whole_roi_measure(:,8); Centroid_stacky = Whole_roi_measure(:,9);
%     Centroid_stack = (Centroid_stackx + Centroid_stacky) / 2;
%     Centroid_apicaldomainx = Whole_roi_measure(Ap_slice,8); Centroid_apicaldomainy = Whole_roi_measure(Ap_slice,9);
%     centroid_current_x = Centroid_apicaldomainx; centroid_current_y = Centroid_apicaldomainy;
%     
%     if i == 1
%         centroid_movement(i,1) = 0;
%     else
%         centroid_movement(i,1) = sqrt((centroid_previous_x - centroid_current_x)^2 + (centroid_previous_y - centroid_current_y)^2);
%     end
%     
%     centroid_previous_x = Centroid_apicaldomainx; centroid_previous_y = Centroid_apicaldomainy;
    
    
    MeanIntensity_stack = Whole_roi_measure(:,3);
    % MeanIntensity_stack = MeanIntensity_stack - All_background{1,i};
    % MeanIntensity_stack = MeanIntensity_stack / (max(MeanIntensity_stack));    
    MeanIntensity_stack = MeanIntensity_stack ./ cortex_meanint{1,i};
    MeanInt_apicaldomain = Whole_roi_measure(Ap_slice,3); 
    % MeanInt_apicaldomain = MeanInt_apicaldomain - All_background{1,i}(Ap_slice,1); 
    MeanIntensity_apicaldomain(i,1) = MeanInt_apicaldomain / cortex_meanint{1,i}(Ap_slice,1);
        
    TotalIntensity_stack = Whole_roi_measure(:,22); 
    % TotalIntensity_stack = TotalIntensity_stack - (All_background{1,i} .* Area_stack);
    % TotalIntensity_stack = TotalIntensity_stack / (max(TotalIntensity_stack));
    TotalIntensity_stack = TotalIntensity_stack ./ cortex_totalint{1,i};
    TotalInt_apicaldomain = Whole_roi_measure(Ap_slice,22); 
    % TotalInt_apicaldomain = TotalInt_apicaldomain - (All_background{1,i}(Ap_slice,1) * Area_apicaldomain(i,1)); 
    TotalIntensity_apicaldomain(i,1) = TotalInt_apicaldomain / cortex_totalint{1,i}(Ap_slice,1);
        
    Zslice = Whole_roi_measure(:,28);
    Zheight = Zslice .* zslice_total_thickness; % In micrometers. 
    
    Timepoint(i,1) =  i * Time_interval; % In minutes
    Time_3Dplot = Timepoint(i,1).*ones(size(Area_stack)); 
        
%     figure(2); 
%     plot3(Zheight, Time_3Dplot, Area_stack, 'b-x','LineWidth', 0.8); 
%     hold on    
%          
%     figure(4);
%     plot3(Zheight, Time_3Dplot, Circularity_stack, 'm-x','LineWidth', 0.8); 
%     hold on 
%     
%     figure(6); 
%     plot3(Zheight, Time_3Dplot, MeanIntensity_stack, 'r-x','LineWidth', 0.8); 
%     hold on
%     
%     figure(8); 
%     plot3(Zheight, Time_3Dplot, TotalIntensity_stack, 'k-x','LineWidth', 0.8); 
%     hold on
    
end

% A new array "Timepoint_2" is created here so that this can be used later
% down in the script where Area, Basalbody count and mean intensities will
% be plotted together. This new Array had to be created because the array
% "Timepoint" will change in between.
Timepoint_2 = Timepoint;

%% Plotting the discretized areas (rectangles) (only for mean intensity and total intensity)
 
 
% Plotting the intensity gradient for full stack
% Loading data for width
Input.discretized__data_LR = '../data/Gradients_of_actin_intensity/Discretized_ROI_Results/Discretized_ROI_Cell_width/Left-to-right_direction/L-R_Cellwidth_t_';
Discretized__Data_LR = Input.discretized__data_LR;
Input.discretized_data_TB = '../data/Gradients_of_actin_intensity/Discretized_ROI_Results/Discretized_ROI_Cell_width/Top-bottom_direction/T-B_Cellwidth_t_';
Discretized__Data_TB = Input.discretized_data_TB;
 
% Loading data for intensity
Input.discretized_int_LR = '../data/Gradients_of_actin_intensity/Discretized_ROI_Results/Discretized_ROI_Full_Measure/Left-to-right_direction/L-R_Fullmeasure_t_';
Discretized_int_LR = Input.discretized_int_LR;
Input.discretized_int_TB = '../data/Gradients_of_actin_intensity/Discretized_ROI_Results/Discretized_ROI_Full_Measure/Top-bottom_direction/T-B_Fullmeasure_t_';
Discretized_int_TB = Input.discretized_int_TB;

All_Area_LR = cell(No_of_timepoints,No_of_slices);
All_Area_TB = cell(No_of_timepoints,No_of_slices);
All_Meanintensity_LR = cell(No_of_timepoints,No_of_slices);
All_Meanintensity_TB = cell(No_of_timepoints,No_of_slices);
All_Totalintensity_LR = cell(No_of_timepoints,No_of_slices);
All_Totalintensity_TB = cell(No_of_timepoints,No_of_slices);
All_Width_LR_values = cell(No_of_timepoints,No_of_slices);
All_Width_TB_values = cell(No_of_timepoints,No_of_slices);
 
% Importing all the data and storing in corresponding cell arrays.
for i = 1:No_of_timepoints
    
    for j = 1:No_of_slices
        
        % Loading data for intensity
        % (LR direction)
        Discretized_dataa_LR = strcat(Discretized_int_LR, sprintf('%01d',i), '_slice_', sprintf('%01d',j), '.txt');
        Discretized_data_LR = importdata(Discretized_dataa_LR);
        Discretized_Data_LR = Discretized_data_LR.data;
        clear Discretized_data_LR;
        % (TB direction)
        Discretized_dataa_TB = strcat(Discretized_int_TB, sprintf('%01d',i), '_slice_', sprintf('%01d',j), '.txt');
        Discretized_data_TB = importdata(Discretized_dataa_TB);
        Discretized_Data_TB = Discretized_data_TB.data;
        clear Discretized_data_TB;
        
        % Data input for area
        All_Area_LR{i,j} = Discretized_Data_LR(:,2); % (LR direction)
        All_Area_TB{i,j} = Discretized_Data_TB(:,2); % (TB direction)
        
        % Data input for mean intensity 
        % (LR direction)
        Meanintensity_LR = Discretized_Data_LR(:,3);
        % Meanintensity_LR = Meanintensity_LR - All_background{1,i}(j,1);
        % Meanintensity_LR = Meanintensity_LR / max(Meanintensity_LR);
        Meanintensity_LR = Meanintensity_LR / cortex_meanint{1,i}(j,1);
        All_Meanintensity_LR{i,j} = Meanintensity_LR;
        % (TB direction)
        Meanintensity_TB = Discretized_Data_TB(:,3);
        % Meanintensity_TB = Meanintensity_TB - All_background{1,i}(j,1);
        % Meanintensity_TB = Meanintensity_TB / max(Meanintensity_TB);
        Meanintensity_TB = Meanintensity_TB / cortex_meanint{1,i}(j,1); 
        All_Meanintensity_TB{i,j} = Meanintensity_TB;
        
        % Data input for total intensity
        % (LR direction)
        Totalintensity_LR = Discretized_Data_LR(:,22);
        % Totalintensity_LR = Totalintensity_LR - (All_background{1,i}(j,1) * All_Area_LR{i,j});
        % Totalintensity_LR = Totalintensity_LR / max(Totalintensity_LR);
        Totalintensity_LR = Totalintensity_LR / cortex_totalint{1,i}(j,1); 
        All_Totalintensity_LR{i,j} = Totalintensity_LR;
        % (TB direction)
        Totalintensity_TB = Discretized_Data_TB(:,22);
        % Totalintensity_TB = Totalintensity_TB - (All_background{1,i}(j,1) * All_Area_TB{i,j});
        % Totalintensity_TB = Totalintensity_TB / max(Totalintensity_TB);
        Totalintensity_TB = Totalintensity_TB / cortex_totalint{1,i}(j,1); 
        All_Totalintensity_TB{i,j} = Totalintensity_TB;
        
        clear Discretized_Data_LR;
        clear Discretized_Data_TB;
        
        % Data input for cell width
        % (LR direction)
        Discretized_width_LR = strcat(Discretized__Data_LR, sprintf('%01d',i), '_slice_', sprintf('%01d',j), '.txt'); 
        Discretized_width_LR = importdata(Discretized_width_LR);
        Discretized_Width_LR = Discretized_width_LR.data;
        clear Discretized_width_LR;
        Width_LR_values = Discretized_Width_LR(:,1);
        All_Width_LR_values{i,j} = Width_LR_values;
        % (TB direction)
        Discretized_width_TB = strcat(Discretized__Data_TB, sprintf('%01d',i), '_slice_', sprintf('%01d',j), '.txt');
        Discretized_width_TB = importdata(Discretized_width_TB);
        Discretized_Width_TB = Discretized_width_TB.data;
        clear Discretized_width_TB;
        Width_TB_values = Discretized_Width_TB(:,1); 
        All_Width_TB_values{i,j} = Width_TB_values;        
        
        clear Discretized_Width_LR;
        clear Discretized_Width_TB;
    end
    
end

%% Plotting actin intensities at the position of basalbodies and around basalbodies.
 
% % Loading stack dimensions 
Imagedim = importdata('../data/Actinint_at&around_basalbody_position/Image_dimensions.txt');
Image_dime = Imagedim.data;
pixelwidth = Image_dime(1,3); % In micrometers. For conversion between micrometers and pixels.
frame_interval = Image_dime(1,5); % In sec
Time_interval = frame_interval/60; % In minutes
No_of_timepoints = Image_dime(1,6); % In no. of frames        
No_of_slices = Image_dime(1,7); % In no. of z slices 
voxeldepth = Image_dime(1,8); % In micrometers. Spacing / interval between two z slices.
 
BBTrack = importdata('../data/Actinint_at&around_basalbody_position/Actin_intensity_at_&_around_BB_position.csv');
BBtrack = BBTrack.data;
clear BBTrack
[bbrow,bbcol] = size(BBtrack); % to get the no of rows and columns in the imported table
 
Trajectory = BBtrack(:,1);
Frame_no = BBtrack(:,2);
no_of_trajectories = Trajectory(end); % Total no of trajectories in the imported table
 
Trajectory_data = cell(no_of_trajectories,bbcol); % converting the imported table into a cell array.
counter = zeros(1,bbrow);
 
% Loading the data into a cell array.
% In the this cell, each row will correspond to a basal body (bb) trajectory and each column will correspond to a parameter. Column1 - Trajectory no; 
% Column 2 - Frame number; Column3 - xcoordinate of the bb; Column4 - ycoordinate of the bb; Column5 - MeanIntBBposition; Column6 - TotalIntBBposition;
% Column7 - MeanIntBBsurround; Column8 - TotalIntBBsurround; Column9 - Area at BBposition; Column10 - Perimeter at BBposition; 
% Column11 - Area sorrounding BB position; Column12 - Perimeter surrounding BBposition; Column13 - speed of basalbodies.
for i = 1:no_of_trajectories
    for j = 1:bbcol
        for k = 1:bbrow
            if Trajectory(k) == i
                counter(k) = k;
            end
        end
        countlist = unique(counter);
        clear counter;
        if countlist(1) == 0
            rowstartvalue = countlist(2);
        else
            rowstartvalue = countlist(1);
        end
        rowendvalue = countlist(end);
        Trajectory_data{i,j} = BBtrack((rowstartvalue:rowendvalue),j); 
    end
    
end

% To get the number of basalbodies in each frame
Framelist = unique(Frame_no); % ordered list of all frame numbers from the table
Timelist_original = Framelist * Time_interval; % In minutes
Last_frame = No_of_timepoints * Time_interval; % No_of_timepoints corresponds to the last frame of the movie analysed or total no of time points in "no of frames"

%%
% This "if loop" is to ensure that the length of Framelist array is the same as the total no of frames. Because sometimes, since basal bodies in the initial frames are not at all tracked, these initial frames dont get
% recorded in the "Actin_intensity_at_&_around_BB_position.csv" file. In this case, this array cannot be used to plot area and other parameters that occur in all frames. So to compensate for this, this "if loop" is
% introduced. This if loop will bring in the previous "time" array from the whole ROI plotting section.
if length(Timelist_original) ~= No_of_timepoints
    Timelist = Timepoint_2;    
else
    Timelist = Timelist_original;
end
Framerepeat = histc(Frame_no,Framelist); % count / No of times each frame number repeats in the table 
No_of_BB = Framerepeat; % Because Framerepeat corresponds to the number of basalbodies per frame.
% This "if loop" makes sure that the "No_of_BB" array is the same length as "Timepoint_2" array in "whole ROi properties" section. Sometimes some frames do not have any basal bodies. These frames are not entered in the
% "Actin_intensity_at_&_around_BB_position.csv" file and the corresponding basal body count is not updated as zero. But this "if loop" finds out those frames where there are no basal bodies and updates them as zero.
% This newly updated array(No_of_BB_rearranged) contains the "no of basal bodies" value in those frames where there are basal bodies and "zero" in those frames where there are no basal bodies.
if length(No_of_BB) ~= No_of_timepoints
    Timelist_bb = zeros(size(Timepoint_2)); No_of_BB_rearranged = zeros(size(Timepoint_2));
    for iaa = 1:length(Timelist_original)
        Timelist_original_value = Timelist_original(iaa);
        Timepoint_2_idx = (Timepoint_2==Timelist_original_value); % finding the index of "Timelist_original_value" in the "Timepoint_2" array
        Timelist_bb(Timepoint_2_idx) = Timelist_original_value;
        No_of_BB_rearranged(Timepoint_2_idx) = No_of_BB(iaa);
    end
    No_of_BB = No_of_BB_rearranged;    
end
Trajectorylist = unique(Trajectory);  % ordered list of all Trajectories from the table
Trajectoryrepeat = histc(Trajectory,Trajectorylist); % count / No of times each Trajectory repeats in the table 
 
% figure(1); 
% yyaxis left
% plot(Timelist, Area_apicaldomain, '-bx','LineWidth', 0.8);
% yyaxis right
% plot(Timelist, No_of_BB, '-rx','LineWidth', 0.8);
% xlabel('Time [min]');  title('Area & basalbodies in apical domain'); set(gca,'fontsize',18);
% yyaxis left; ylabel('Area [\mum^2]'); 
% yyaxis right; ylabel('Basalbody count','rotation',270,'VerticalAlignment','middle'); % , 'Position',[5.4 25 0]
% BB_apical = '../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain/General'; 
% saveas(gcf, fullfile(BB_apical, 'Area_&_BB_time_apicaldomain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Area_&_BB_time_apicaldomain'), 'tif');
 
% figure(2); 
% plot(Area_apicaldomain, No_of_BB, '-kx','LineWidth', 0.8);
% xlabel('Area [\mum^2]');  ylabel('Basalbody count'); title('Area & basalbodies relation in apical domain'); set(gca,'fontsize',18);
% BB_apical = '../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain/General'; 
% saveas(gcf, fullfile(BB_apical, 'Area_&_BB_relation_apicaldomain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Area_&_BB_relation_apicaldomain'), 'tif');
 
% figure(3);
% yyaxis left
% plot(Timelist, MeanIntensity_apicaldomain, '-bx','LineWidth', 0.8);
% yyaxis right
% plot(Timelist, No_of_BB, '-rx','LineWidth', 0.8);
% xlabel('Time [min]');  title('Meanintensity & basalbodies in apical domain'); set(gca,'fontsize',18);
% yyaxis left; ylabel('Mean intensity'); 
% yyaxis right; ylabel('Basalbody count','rotation',270,'VerticalAlignment','middle'); % , 'Position',[5.4 25 0]
% BB_apical = '../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain/General'; 
% saveas(gcf, fullfile(BB_apical, 'Meanint_&_BB_time_apicaldomain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Meanint_&_BB_time_apicaldomain'), 'tif');
 
% figure(4);
% yyaxis left
% plot(Timelist, TotalIntensity_apicaldomain, '-bx','LineWidth', 0.8);
% yyaxis right
% plot(Timelist, No_of_BB, '-rx','LineWidth', 0.8);
% xlabel('Time [min]'); title('Totalintensity & basalbodies in apical domain'); set(gca,'fontsize',18); 
% yyaxis left; ylabel('Total intensity'); 
% yyaxis right; ylabel('Basalbody count','rotation',270,'VerticalAlignment','middle');  % ,'Position',[5.4 25 0]
% BB_apical = '../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain/General'; 
% saveas(gcf, fullfile(BB_apical, 'Totalint_&_BB_time_apicaldomain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Totalint_&_BB_time_apicaldomain'), 'tif');

% figure(411);
% area_rate = nan(length(Area_apicaldomain),1);
% for a_rate = 1:length(Area_apicaldomain)
%     ar_diff = Area_apicaldomain(a_rate + 1) - Area_apicaldomain(a_rate);
%     area_rate(a_rate,1) = ar_diff / Time_interval;    
% end
% whole_area_rate = (Area_apicaldomain(end) - Area_apicaldomain(1)) / (Timelist(end) - Timelist(1)); % area rate for the whole apical expansion [\mum^2 min^-1]
% plot(Timelist, area_rate, '-kx','LineWidth', 0.8);
% xlabel('Time [min]');  ylabel('Area rate [\mum^2 min^-1]'); title('Area rate'); set(gca,'fontsize',18);
% BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General'); 
% saveas(gcf, fullfile(BB_apical, 'Area_rate'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Area_rate'), 'tif');
 
% To get the speed, meanint and totalint of basalbodies for each trajectory
%distance = NaN(no_of_trajectories,Framelist(end)); timeforspeed = NaN(no_of_trajectories,Framelist(end)); speed = NaN(no_of_trajectories,Framelist(end));
 
for trajno = 1:no_of_trajectories
    kend = length(Trajectory_data{trajno,1}); % this gives the trajectory length
       
    % this is to make sure that only those trajectories that are longer than 2 frames are taken for analysis - smaller trajectories are not plotted 
    if kend <= 2 % 2 corresponds to the time in frames that was arbitrarily chosen; this means any basal body that does not stay continuously for 3 frames will be rejected as an artefact of thresholding / tracking
        continue
    else   
        % the loop continues for only those trajectories that are longer than 2 minutes
        for k = 1: (kend-1)
            distance(trajno,k) = (sqrt((Trajectory_data{trajno,3}(k+1,1) - Trajectory_data{trajno,3}(k,1))^2 + (Trajectory_data{trajno,4}(k+1,1) - Trajectory_data{trajno,4}(k,1))^2)) * pixelwidth;
            timestep(trajno,k) = Trajectory_data{trajno,2}(k+1,1) * Time_interval;
            timeforspeed(trajno,k) = (Trajectory_data{trajno,2}(k+1,1) - Trajectory_data{trajno,2}(k,1)) * Time_interval;
            speed(trajno,k) =  distance(trajno,k) / timeforspeed(trajno,k);
        end
        % getting FFT for speed - to check if there is any oscillation
        get_input = FFT_speed_plot(Time_interval, speed(trajno,:)); % Calling the function "FFT_speed_plot" and feeding the input
        figure(111);
        BB_apical = '../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain/Mean_intensity/';
        BB_apical_fig = strcat('Speed_meanint_pos_surrounding_BB_in_apical_domain_traj_', sprintf('%01d',trajno), '_FFT_speed');
        saveas(gcf, fullfile(BB_apical, BB_apical_fig),'fig'); saveas(gcf,fullfile(BB_apical, BB_apical_fig),'tif');
        close(figure(111));        
        
        % getting total distance
        timestack = Trajectory_data{trajno,2} .* Time_interval;
        totaldistance(trajno,1) = (sqrt((Trajectory_data{trajno,3}(kend,1) - Trajectory_data{trajno,3}(1,1))^2 + (Trajectory_data{trajno,4}(kend,1) - Trajectory_data{trajno,4}(1,1))^2)) * pixelwidth;
        % this "if loop" makes sure that there are no trajectories with distance = 0. Sometimes there are trajectories that are just two frames and the basal body doesnt change position. In these cases, the
        % distance is recorded as zero and this creates confusion in other operation down the script where "zeros" are removed from this "totaldistance" array. Therefore any trajectory with a distance less
        % than "1" is recorded as "1".
        if totaldistance(trajno,1) < 1
            totaldistance(trajno,1) = 1;
        end
        % Trajectory duration
        time_traj_end(trajno,1) = Trajectory_data{trajno,2}(end,1) * Time_interval;
        time_traj_initial(trajno,1) = Trajectory_data{trajno,2}(1,1) * Time_interval;
        total_traj_duration(trajno,1) = time_traj_end(trajno,1) - time_traj_initial(trajno,1);
        
        % Basalbody speed
        totalspeed(trajno,1) = totaldistance (trajno,1) / total_traj_duration(trajno,1);
        
        % To subtract the mean & total intensities with the background intensities of corresponding frames.
        totnoofframes = length(Trajectory_data{trajno,2});
        MeanInt_BBposition = zeros(totnoofframes,1); TotalInt_BBposition = zeros(totnoofframes,1);
        MeanInt_BBsurround = zeros(totnoofframes,1); TotalInt_BBsurround = zeros(totnoofframes,1);
        
        for ab = 1:totnoofframes            
            corresframeno = Trajectory_data{trajno,2}(ab,1);
            MeanInt_BBposition(ab,1) = Trajectory_data{trajno,5}(ab,1); % - All_background{1,corresframeno}(Ap_slice,1);
            MeanInt_BBposition(ab,1) = MeanInt_BBposition(ab,1) / cortex_meanint{1,corresframeno}(Ap_slice,1);
            
            TotalInt_BBposition(ab,1) = Trajectory_data{trajno,6}(ab,1); % - All_background{1,corresframeno}(Ap_slice,1);
            TotalInt_BBposition(ab,1) = TotalInt_BBposition(ab,1) / cortex_totalint{1,corresframeno}(Ap_slice,1);
            
            MeanInt_BBsurround(ab,1) = Trajectory_data{trajno,7}(ab,1); % - All_background{1,corresframeno}(Ap_slice,1);
            MeanInt_BBsurround(ab,1) = MeanInt_BBsurround(ab,1) / cortex_meanint{1,corresframeno}(Ap_slice,1);
            
            TotalInt_BBsurround(ab,1) = Trajectory_data{trajno,8}(ab,1); % - All_background{1,corresframeno}(Ap_slice,1);
            TotalInt_BBsurround(ab,1) = TotalInt_BBsurround(ab,1) / cortex_totalint{1,corresframeno}(Ap_slice,1);            
        end
        
        % getting FFT for MeanInt at BB position and  - to check if there is any oscillation
        get_input = FFT_meanInt_plot(Time_interval, MeanInt_BBposition((2:kend),:), MeanInt_BBsurround((2:kend),:)); % Calling the function "FFT_meanInt_plot" and feeding the input
        figure(111);
        BB_apical = '../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain/Mean_intensity/';
        BB_apical_fig = strcat('Speed_meanint_pos_surrounding_BB_in_apical_domain_traj_', sprintf('%01d',trajno), '_FFT_meanInt');
        saveas(gcf, fullfile(BB_apical, BB_apical_fig),'fig'); saveas(gcf,fullfile(BB_apical, BB_apical_fig),'tif');
        close(figure(111));
                
        % getting the first time point "t0" of all trajectories
        trajectoryno(trajno,1) = trajno;
        frame_t0_of_all_trajectories(trajno,1) = Trajectory_data{trajno,2}(1,1); % getting the t0 "frame" of that trajecotry
        time_t0_of_all_trajectories(trajno,1) = Trajectory_data{trajno,2}(1,1) * Time_interval; % getting the t0 "time" of that trajecotry
        
        % getting the last time point "tend" of all trajectories
        frame_tend_of_all_trajectories(trajno,1) = Trajectory_data{trajno,2}(end,1); % getting the t0 "frame" of that trajecotry
        time_tend_of_all_trajectories(trajno,1) = Trajectory_data{trajno,2}(end,1) * Time_interval; % getting the t0 "time" of that trajecotry
        
        figure(5);
        plot(timestep(trajno,(1:kend-1)),distance(trajno,:), '-rx','LineWidth', 0.8);
        hold on
        figure(55); histogram(distance(trajno,:), 'FaceColor', 'r', 'FaceAlpha', 0.05, 'EdgeColor', 'none'); hold on; % bar(distance(trajno,:),'r', 'FaceAlpha', 0.05); hold on 
        figure(6);
        plot(timestep(trajno,(1:kend-1)),speed(trajno,:), '-bx','LineWidth', 0.8);
        hold on
        figure(56); histogram(speed(trajno,:), 'FaceColor', 'b', 'FaceAlpha', 0.05, 'EdgeColor', 'none'); hold on; % bar(speed(trajno,:),'b', 'FaceAlpha', 0.05); hold on
        figure(7);
        plot(timestack,MeanInt_BBposition,'-kx','LineWidth', 0.8); %
        hold on
        figure(57); histogram(MeanInt_BBposition, 'FaceColor', 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'none'); hold on; % bar(MeanInt_BBposition,'k', 'FaceAlpha', 0.05); hold on 
        figure(8);
        plot(timestack,TotalInt_BBposition,'-gx','LineWidth', 0.8); %
        hold on
        figure(58); histogram(TotalInt_BBposition, 'FaceColor', 'g', 'FaceAlpha', 0.05, 'EdgeColor', 'none'); hold on; % bar(TotalInt_BBposition,'g', 'FaceAlpha', 0.05); hold on 
        figure(9);
        plot(timestack,MeanInt_BBsurround,'-kx','LineWidth', 0.8); %
        hold on
        figure(59); histogram(MeanInt_BBsurround, 'FaceColor', 'k', 'FaceAlpha', 0.05, 'EdgeColor', 'none'); hold on; %  bar(MeanInt_BBsurround,'k', 'FaceAlpha', 0.05); hold on 
        figure(10);
        plot(timestack,TotalInt_BBsurround,'-gx','LineWidth', 0.8); %
        hold on
        figure(60); histogram(TotalInt_BBsurround, 'FaceColor', 'g', 'FaceAlpha', 0.05, 'EdgeColor', 'none'); hold on; %  bar(TotalInt_BBsurround,'g', 'FaceAlpha', 0.05); hold on 
        
        figure(11);
        yyaxis left
        plot(timestep(trajno,(1:kend-1)),speed(trajno,:), '-bx','LineWidth', 0.8);
        yyaxis right
        plot(timestep(trajno,(1:kend-1)),MeanInt_BBposition((2:kend),:),'-kx','LineWidth', 0.8);
        hold on
        plot(timestep(trajno,(1:kend-1)),MeanInt_BBsurround((2:kend),:),'-rx','LineWidth', 0.8);
        xlabel('Time [min]'); title('Speed,meanint,BB pos&surrounding in apical domain'); set(gca,'fontsize',18);
        pos = get(gca, 'Position'); xoffset = -0.023; pos(1) = pos(1) + xoffset; set(gca, 'Position', pos);
        yyaxis left; ylabel('speed [\mum/min]');
        yyaxis right; ylabel('Mean intensity','rotation',270,'VerticalAlignment','middle','Position',[5.37 0.825 0]);
        BB_apical = '../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain/Mean_intensity/';
        BB_apical_fig = strcat('Speed_meanint_pos_surrounding_BB_in_apical_domain_traj_', sprintf('%01d',trajno));
        saveas(gcf, fullfile(BB_apical, BB_apical_fig),'fig'); saveas(gcf,fullfile(BB_apical, BB_apical_fig),'tif');
        close(figure(11));        
           
        figure(12);
        yyaxis left
        plot(timestep(trajno,(1:kend-1)),speed(trajno,:), '-bx','LineWidth', 0.8);
        yyaxis right
        plot(timestep(trajno,(1:kend-1)),TotalInt_BBposition((2:kend),:),'-kx','LineWidth', 0.8);
        hold on
        plot(timestep(trajno,(1:kend-1)),TotalInt_BBsurround((2:kend),:),'-rx','LineWidth', 0.8);
        xlabel('Time [min]'); title('Speed,totalint,BB pos&surrounding in apical domain'); set(gca,'fontsize',18);
        pos = get(gca, 'Position'); xoffset = -0.023; pos(1) = pos(1) + xoffset; set(gca, 'Position', pos);
        yyaxis left; ylabel('speed [\mum/min]');
        yyaxis right; ylabel('Total intensity','rotation',270,'VerticalAlignment','middle','Position',[5.37 0.825 0]);
        BB_apical = '../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain/Total_intensity/';
        BB_apical_fig = strcat('Speed_totalint_pos_surrounding_BB_in_apical_domain_traj_', sprintf('%01d',trajno));
        saveas(gcf, fullfile(BB_apical, BB_apical_fig),'fig'); saveas(gcf,fullfile(BB_apical, BB_apical_fig),'tif');
        close(figure(12));
        
        clear timeforspeed; clear speed; clear distance;
    
    end
end
 
% While plotting selected trajectories (for example only those trajectories that are longer than 2 frames), rest of the trajectory data gets recorded as "zero". So there will be lot of zeros in all those arrays containing
% trajectory data.
% But bar plot doesnt plot repetitive elements; so removing all "0" values from the following arrays i.e. removing all those trajectories that were not plotted
% The array "time_t0_of_all_trajectories_modified" corresponds to the t0 of eavery trajectory. This time is plotted against "totaldistance", "totaltime" and "totalspeed". The other way is to plot against the
% trajectory number instead of t0 of trajectories.
trajectoryno_modified = trajectoryno(trajectoryno~=0); 

frame_t0_of_all_trajectories_modified = frame_t0_of_all_trajectories(frame_t0_of_all_trajectories~=0);
time_t0_of_all_trajectories_modified = time_t0_of_all_trajectories(time_t0_of_all_trajectories~=0);

frame_tend_of_all_trajectories_modified = frame_tend_of_all_trajectories(frame_tend_of_all_trajectories~=0); 
time_tend_of_all_trajectories_modified = time_tend_of_all_trajectories(frame_tend_of_all_trajectories~=0); 

totaldistance_modified = totaldistance(totaldistance~=0);
total_traj_duration_modified =  total_traj_duration( total_traj_duration~=0);
totalspeed_modified = totalspeed(totalspeed~=0);

% This "for" loop is to get the corresponding "area" values for the t0 frames of all trajectories. This allows to plot the "Total distance", "Total duration" and "Cumulative Speed" of basal bodies
for iab = 1:length(frame_t0_of_all_trajectories_modified) % this loop goes through the the array that contains the t0 of all trajectories
    frame_t0_getting_value(iab) = frame_t0_of_all_trajectories_modified(iab); % getting individually the t0 of all trajectories one by one
    Area_t0(iab) = Area_apicaldomain(frame_t0_getting_value(iab)); % Finding the corresponding area for the t0 frame of every trajectory  
end

% This "for" and "if" loops isolate two categories of trajectories: (1) long trajectories: these are the trajectories of BB that remain at the end of the movie and are atleast more than "traj_segregate_duration" min in duration; (2) short
% trajectories: these are the trajectories that are shorter than "traj_segregate_duration" min duration. This categorisation allows to see if those BB that remain at the end and having longer duration are behaving differently from those BB
% that stay for shorter duration - in terms of speed. The figures resulting from this categorisation are plotted as figures 132-135, 142-145, 152-155.
for iab = 1:length(frame_tend_of_all_trajectories_modified)
    if (time_tend_of_all_trajectories_modified(iab) == Last_frame) && (total_traj_duration_modified(iab) > traj_segregate_duration) % "traj_segregate_duration" min is an arbitrary time point that was chosen to distinguish long and short trajectories
        long_traj_frame_no(iab) = trajectoryno_modified(iab); 
        long_traj_time_t0(iab) = time_t0_of_all_trajectories_modified(iab); 
        long_traj_Area_t0(iab) = Area_t0(iab);
        long_traj_totaldistance(iab) = totaldistance_modified(iab);
        long_traj_duration(iab) = total_traj_duration_modified(iab);
        long_traj_speed(iab) = totalspeed_modified(iab);
    elseif total_traj_duration_modified(iab) < traj_segregate_duration % "traj_segregate_duration" min is an arbitrary time point that was chosen to distinguish long and short trajectories
        short_traj_frame_no(iab) = trajectoryno_modified(iab);
        short_traj_time_t0(iab) = time_t0_of_all_trajectories_modified(iab);
        short_traj_Area_t0(iab) = Area_t0(iab);
        short_traj_totaldistance(iab) = totaldistance_modified(iab);
        short_traj_duration(iab) = total_traj_duration_modified(iab);
        short_traj_speed(iab) = totalspeed_modified(iab);
    end
end

% getting the average values of the long and short trajectories that were obtained from the for loop above
% Long trajectories
if   (exist('long_traj_frame_no', 'var') == 0)||(isempty(long_traj_frame_no))
    long_traj_frame_no = 0; 
    long_traj_time_t0 = 0;
    long_traj_Area_t0 = 0;
    long_traj_totaldistance = 0; avg_long_traj_totaldistance = 0; stdev_long_traj_totaldistance = 0;
    long_traj_duration = 0; avg_long_traj_duration = 0; stdev_long_traj_duration = 0;
    long_traj_speed = 0; avg_long_traj_speed = 0; stdev_long_traj_speed = 0;
else
    long_traj_frame_no = long_traj_frame_no(long_traj_frame_no~=0); % getting only the non-zero values
    long_traj_time_t0 = long_traj_time_t0(long_traj_time_t0~=0);
    long_traj_Area_t0 = long_traj_Area_t0(long_traj_Area_t0~=0);
    long_traj_totaldistance = long_traj_totaldistance(long_traj_totaldistance~=0); avg_long_traj_totaldistance = nanmean(long_traj_totaldistance); stdev_long_traj_totaldistance = nanstd(long_traj_totaldistance);
    long_traj_duration = long_traj_duration(long_traj_duration~=0); avg_long_traj_duration = nanmean(long_traj_duration); stdev_long_traj_duration = nanstd(long_traj_duration);
    long_traj_speed = long_traj_speed(long_traj_speed~=0); avg_long_traj_speed = nanmean(long_traj_speed); stdev_long_traj_speed = nanstd(long_traj_speed);
end

% Short trajectories
short_traj_frame_no = short_traj_frame_no(short_traj_frame_no~=0); % getting only the non-zero values
short_traj_time_t0 = short_traj_time_t0(short_traj_time_t0~=0);
short_traj_Area_t0 = short_traj_Area_t0(short_traj_Area_t0~=0);
short_traj_totaldistance = short_traj_totaldistance(short_traj_totaldistance~=0); avg_short_traj_totaldistance = nanmean(short_traj_totaldistance); stdev_short_traj_totaldistance = nanstd(short_traj_totaldistance);
short_traj_duration = short_traj_duration(short_traj_duration~=0); avg_short_traj_duration = nanmean(short_traj_duration); stdev_short_traj_duration = nanstd(short_traj_duration);
short_traj_speed = short_traj_speed(short_traj_speed~=0); avg_short_traj_speed = nanmean(short_traj_speed); stdev_short_traj_speed = nanstd(short_traj_speed);

% Plotting and comparing the average of "total distance", "total duration" and "cumulative speed" of long and short trajectories
% Specific inclusions here correspond to box plot plotting.
figure(16);
dist_1 = short_traj_totaldistance; dist_2 = long_traj_totaldistance; dist = [dist_1 dist_2];
grp = [zeros(1,length(dist_1)), ones(1,length(dist_2))];
boxplot(dist, grp, 'labels', {'Short trajectories','Long trajectories'}); ylabel('Distance [\mum]');
hold on 
avgs(1,1) = avg_short_traj_totaldistance; avgs(1,2) = avg_long_traj_totaldistance;
plot(avgs, '*k'); title('Mean distance of "long & short" BB trajectories'); set(gca,'fontsize',12); BB_apical = '../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain/General'; 
saveas(gcf, fullfile(BB_apical, 'Mean_distance_of_long_&_short_BB_trajectories'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Mean_distance_of_long_&_short_BB_trajectories'), 'tif');

figure(17);
dist_1 = short_traj_duration; dist_2 = long_traj_duration; dist = [dist_1 dist_2];
grp = [zeros(1,length(dist_1)), ones(1,length(dist_2))];
boxplot(dist, grp, 'labels', {'Short trajectories','Long trajectories'}); ylabel('Time [min]');
hold on 
avgs(1,1) = avg_short_traj_duration; avgs(1,2) = avg_long_traj_duration;
plot(avgs, '*k'); title('Mean duration of "long & short" BB trajectories'); set(gca,'fontsize',12); BB_apical = '../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain/General'; 
saveas(gcf, fullfile(BB_apical, 'Mean_duration_of_long_&_short_BB_trajectories'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Mean_duration_of_long_&_short_BB_trajectories'), 'tif');

figure(18);
dist_1 = short_traj_speed; dist_2 = long_traj_speed; dist = [dist_1 dist_2];
grp = [zeros(1,length(dist_1)), ones(1,length(dist_2))];
boxplot(dist, grp, 'labels', {'Short trajectories','Long trajectories'}); ylabel('Speed [\mum/min]');
hold on 
avgs(1,1) = avg_short_traj_speed; avgs(1,2) = avg_long_traj_speed;
plot(avgs, '*k'); title('Mean speed of "long & short" BB trajectories'); set(gca,'fontsize',12); BB_apical = '../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain/General'; 
saveas(gcf, fullfile(BB_apical, 'Mean_speed_of_long_&_short_BB_trajectories'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Mean_speed_of_long_&_short_BB_trajectories'), 'tif');

% Scatter plot and histogram of "total distance", "total duration" and "cumulative speed" of all trajectories as scatter plot
figure(13);
scatter(time_t0_of_all_trajectories_modified, totaldistance_modified); % plot against time / all trajectories
hold on
figure(131);
scatter(Area_t0, totaldistance_modified); % plot against area / all trajectories
hold on

figure(14);
scatter(time_t0_of_all_trajectories_modified, total_traj_duration_modified); % plot against time / all trajectories
hold on
figure(141);
scatter(Area_t0, total_traj_duration_modified); % plot against area / all trajectories
hold on

figure(15);
scatter(time_t0_of_all_trajectories_modified, totalspeed_modified); % plot against time / all trajectories
hold on
figure(151);
scatter(Area_t0, totalspeed_modified); % plot against area / all trajectories
hold on

% This if loop plots the "long trajectories" (described before) and makes a montage. This if loop makes sure that the long trajectories are plotted only if they exist.
if exist('long_traj_Area_t0','var')    
    figure(132);
    scatter(long_traj_Area_t0, long_traj_totaldistance); % plot against area / all trajectories
    xlabel('Area [\mum^2]');  ylabel('Distance [\mum]'); title('Total distance of "long" BB trajectories in apical domain-area'); set(gca,'fontsize',12);
    saveas(gcf, fullfile(BB_apical, 'Total_dist_of_long_BB_traject_in_apical domain_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Total_dist_of_long_BB_traject_in_apical domain_area'), 'tif');
    figure(133);
    scatter(long_traj_time_t0, long_traj_totaldistance); % plot against area / all trajectories
    xlabel('Time [min]');  ylabel('Distance [\mum]'); title('Total distance of "long" BB trajectories in apical domain-time'); set(gca,'fontsize',12);
    saveas(gcf, fullfile(BB_apical, 'Total_dist_of_long_BB_traject_in_apical domain_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Total_dist_of_long_BB_traject_in_apical domain_time'), 'tif');
    figure(142);
    scatter(long_traj_Area_t0, long_traj_duration); % plot against area / all trajectories
    xlabel('Area [\mum^2]');  ylabel('Duration [min]'); title('Total time of "long" BB trajectories in apical domain-area'); set(gca,'fontsize',12);
    saveas(gcf, fullfile(BB_apical, 'Total_duration_of_long_BB_traject_in_apical domain_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Total_duration_of_long_BB_traject_in_apical domain_area'), 'tif');
    figure(143);
    scatter(long_traj_time_t0, long_traj_duration); % plot against area / all trajectories
    xlabel('Time [min]');  ylabel('Duration [min]'); title('Total time of "long" BB trajectories in apical domain-time'); set(gca,'fontsize',12);
    saveas(gcf, fullfile(BB_apical, 'Total_duration_of_long_BB_traject_in_apical domain_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Total_duration_of_long_BB_traject_in_apical domain_time'), 'tif');
    figure(152);
    scatter(long_traj_Area_t0, long_traj_speed); % plot against area / all trajectories
    xlabel('Area [\mum^2]');  ylabel('Speed [\mum / min]'); title('Avg speed of "long" BB trajectories in apical domain-area'); set(gca,'fontsize',12);
    saveas(gcf, fullfile(BB_apical, 'Avg_speed_of_long_BB_traject_in_apical domain_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Avg_speed_of_long_BB_traject_in_apical domain_area'), 'tif');
    figure(153);
    scatter(long_traj_time_t0, long_traj_speed); % plot against area / all trajectories
    xlabel('Time [min]');  ylabel('Speed [\mum / min]'); title('Avg speed of "long" BB trajectories in apical domain-time'); set(gca,'fontsize',12);
    saveas(gcf, fullfile(BB_apical, 'Avg_speed_of_long_BB_traject_in_apical domain_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Avg_speed_of_long_BB_traject_in_apical domain_time'), 'tif');
    
    fig132 = fullfile(BB_apical, 'Total_dist_of_long_BB_traject_in_apical domain_area.tif');
    fig133 = fullfile(BB_apical, 'Total_dist_of_long_BB_traject_in_apical domain_time.tif');
    fig142 = fullfile(BB_apical, 'Total_duration_of_long_BB_traject_in_apical domain_area.tif');
    fig143 = fullfile(BB_apical, 'Total_duration_of_long_BB_traject_in_apical domain_time.tif');
    fig152 = fullfile(BB_apical, 'Avg_speed_of_long_BB_traject_in_apical domain_area.tif');
    fig153 = fullfile(BB_apical, 'Avg_speed_of_long_BB_traject_in_apical domain_time.tif');
    montage({fig133, fig143, fig153, fig132, fig142, fig152}); montage_fig = '../Plots/montage';
    saveas(gcf, fullfile(montage_fig,'slide_4_2_1_all'), 'tif');
end

% This if loop plots the "short trajectories" (described before) and makes a montage. This if loop makes sure that the short trajectories are plotted only if they exist.
if exist('short_traj_Area_t0','var') 
    figure(134);
    scatter(short_traj_Area_t0, short_traj_totaldistance); % plot against area / all trajectories
    xlabel('Area [\mum^2]');  ylabel('Distance [\mum]'); title('Total distance of "short" BB trajectories in apical domain-area'); set(gca,'fontsize',12);
    saveas(gcf, fullfile(BB_apical, 'Total_dist_of_short_BB_traject_in_apical domain_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Total_dist_of_short_BB_traject_in_apical domain_area'), 'tif');
    figure(135);
    scatter(short_traj_time_t0, short_traj_totaldistance); % plot against area / all trajectories
    xlabel('Time [min]');  ylabel('Distance [\mum]'); title('Total distance of "short" BB trajectories in apical domain-time'); set(gca,'fontsize',12);
    saveas(gcf, fullfile(BB_apical, 'Total_dist_of_short_BB_traject_in_apical domain_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Total_dist_of_short_BB_traject_in_apical domain_time'), 'tif');
    figure(144);
    scatter(short_traj_Area_t0, short_traj_duration); % plot against area / all trajectories
    xlabel('Area [\mum^2]');  ylabel('Duration [min]'); title('Total time of "short" BB trajectories in apical domain-area'); set(gca,'fontsize',12);
    saveas(gcf, fullfile(BB_apical, 'Total_duration_of_short_BB_traject_in_apical domain_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Total_duration_of_short_BB_traject_in_apical domain_area'), 'tif');
    figure(145);
    scatter(short_traj_time_t0, short_traj_duration); % plot against area / all trajectories
    xlabel('Time [min]');  ylabel('Duration [min]'); title('Total time of "short" BB trajectories in apical domain-time'); set(gca,'fontsize',12);
    saveas(gcf, fullfile(BB_apical, 'Total_duration_of_short_BB_traject_in_apical domain_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Total_duration_of_short_BB_traject_in_apical domain_time'), 'tif');
    figure(154);
    scatter(short_traj_Area_t0, short_traj_speed); % plot against area / all trajectories
    xlabel('Area [\mum^2]');  ylabel('Speed [\mum / min]'); title('Avg speed of "short" BB trajectories in apical domain-area'); set(gca,'fontsize',12);
    saveas(gcf, fullfile(BB_apical, 'Avg_speed_of_short_BB_traject_in_apical domain_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Avg_speed_of_short_BB_traject_in_apical domain_area'), 'tif');
    figure(155);
    scatter(short_traj_time_t0, short_traj_speed); % plot against area / all trajectories
    xlabel('Time [min]');  ylabel('Speed [\mum / min]'); title('Avg speed of "short" BB trajectories in apical domain-time'); set(gca,'fontsize',12);
    saveas(gcf, fullfile(BB_apical, 'Avg_speed_of_short_BB_traject_in_apical domain_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Avg_speed_of_short_BB_traject_in_apical domain_time'), 'tif');
    
    fig134 = fullfile(BB_apical, 'Total_dist_of_short_BB_traject_in_apical domain_area.tif');
    fig135 = fullfile(BB_apical, 'Total_dist_of_short_BB_traject_in_apical domain_time.tif');
    fig144 = fullfile(BB_apical, 'Total_duration_of_short_BB_traject_in_apical domain_area.tif');
    fig145 = fullfile(BB_apical, 'Total_duration_of_short_BB_traject_in_apical domain_time.tif');
    fig154 = fullfile(BB_apical, 'Avg_speed_of_short_BB_traject_in_apical domain_area.tif');
    fig155 = fullfile(BB_apical, 'Avg_speed_of_short_BB_traject_in_apical domain_time.tif');
    montage({fig135, fig145, fig155, fig134, fig144, fig154}); montage_fig = '../Plots/montage';
    saveas(gcf, fullfile(montage_fig,'slide_4_2_2_all'), 'tif');
end

% savelink for the figures
BB_apical = '../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain/General'; 

figure(5);
xlabel('Time [min]');  ylabel('Distance [\mum]'); title('Step distance of BB trajectories in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Step_distance_of_BB_trajectories_apicaldomain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Step_distance_of_BB_trajectories_apicaldomain'), 'tif');
figure(55);
xlabel('Step distance [\mum]'); ylabel('Counts'); title('Step distance of BB trajectories in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Step_distance_of_BB_trajectories_apicaldomain_histogram'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Step_distance_of_BB_trajectories_apicaldomain_histogram'), 'tif');
 
figure(6);
xlabel('Time [min]');  ylabel('speed [\mum / min]'); title('Instantaneous speed of BBs in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Instantaneous_speed_of_BBs_apicaldomain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Instantaneous_speed_of_BBs_apicaldomain'), 'tif');
figure(56);
xlabel('speed [\mum / min]'); ylabel('Counts'); title('Instantaneous speed of BBs in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Instantaneous_speed_of_BBs_apicaldomain_histogram'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Instantaneous_speed_of_BBs_apicaldomain_histogram'), 'tif');

figure(7);
xlabel('Time [min]');  ylabel('Mean intensity [a.u]'); title('Meanintensity at BB position in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Meanintensity_at_BB_position_in_apical_domain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Meanintensity_at_BB_position_in_apical_domain'), 'tif');
figure(57);
xlabel('Mean intensity [a.u]'); ylabel('Counts'); title('Meanintensity at BB position in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Meanintensity_at_BB_position_in_apical_domain_histogram'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Meanintensity_at_BB_position_in_apical_domain_histogram'), 'tif');

figure(8);
xlabel('Time [min]');  ylabel('Total intensity [a.u]'); title('Totalintensity at BB position in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Totalintensity_at_BB_position_in_apical_domain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Totalintensity_at_BB_position_in_apical_domain'), 'tif');
figure(58);
xlabel('Total intensity [a.u]'); ylabel('Counts'); title('Totalintensity at BB position in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Totalintensity_at_BB_position_in_apical_domain_histogram'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Totalintensity_at_BB_position_in_apical_domain_histogram'), 'tif');

figure(9);
xlabel('Time [min]');  ylabel('Mean intensity [a.u]'); title('Meanintensity surrounding BB in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Meanintensity_surounding_BB_in_apical_domain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Meanintensity_surounding_BB_in_apical_domain'), 'tif');
figure(59);
xlabel('Mean intensity [a.u]'); ylabel('Counts'); title('Meanintensity surrounding BB in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Meanintensity_surounding_BB_in_apical_domain_histogram'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Meanintensity_surounding_BB_in_apical_domain_histogram'), 'tif');

figure(10);
xlabel('Time [min]');  ylabel('Total intensity [a.u]'); title('Totalintensity surrounding BB in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Totalintensity_surounding_BB_in_apical_domain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Totalintensity_surounding_BB_in_apical_domain'), 'tif');
figure(60);
xlabel('Total intensity [a.u]');  ylabel('Counts'); title('Totalintensity surrounding BB in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Totalintensity_surounding_BB_in_apical_domain_histogram'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Totalintensity_surounding_BB_in_apical_domain_histogram'), 'tif');
 
figure(13);
xlabel('Time [min]');  ylabel('Distance [\mum]'); title('Total distance of all BB trajectories in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Total_dist_of_all_BB_traject_in_apical domain_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Total_dist_of_all_BB_traject_in_apical domain_time'), 'tif');
figure(14);
xlabel('Time [min]');  ylabel('Duration [min]'); title('Total time of all BB trajectories in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Total_duration_of_all_BB_traject_in_apical_domain_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Total_duration_of_all_BB_traject_in_apical_domain_time'), 'tif');
figure(15);
xlabel('Time [min]');  ylabel('Speed [\mum / min]'); title('Avg speed of all BB trajectories in apical domain'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Avg_speed_of_all_BB_traject_in_apical_domain_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Avg_speed_of_all_BB_traject_in_apical_domain_time'), 'tif');

figure(131);
xlabel('Area [\mum^2]');  ylabel('Distance [\mum]'); title('Total distance of all BB trajectories in apical domain-area'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Total_dist_of_all_BB_traject_in_apical domain_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Total_dist_of_all_BB_traject_in_apical domain_area'), 'tif');
figure(141);
xlabel('Area [\mum^2]');  ylabel('Duration [min]'); title('Total time of all BB trajectories in apical domain-area'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Total_duration_of_all_BB_traject_in_apical_domain_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Total_duration_of_all_BB_traject_in_apical_domain_area'), 'tif');
figure(151);
xlabel('Area [\mum^2]');  ylabel('Speed [\mum / min]'); title('Avg speed of all BB trajectories in apical domain-area'); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'Avg_speed_of_all_BB_traject_in_apical_domain_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Avg_speed_of_all_BB_traject_in_apical_domain_area'), 'tif');

close all;

% saving as montage
montage_fig = '../Plots/montage';

fig13 = fullfile(BB_apical, 'Total_dist_of_all_BB_traject_in_apical domain_time.tif');
fig14 = fullfile(BB_apical, 'Total_duration_of_all_BB_traject_in_apical_domain_time.tif');
fig15 = fullfile(BB_apical, 'Avg_speed_of_all_BB_traject_in_apical_domain_time.tif');
fig131 = fullfile(BB_apical, 'Total_dist_of_all_BB_traject_in_apical domain_area.tif');
fig141 = fullfile(BB_apical, 'Total_duration_of_all_BB_traject_in_apical_domain_area.tif');
fig151 = fullfile(BB_apical, 'Avg_speed_of_all_BB_traject_in_apical_domain_area.tif');
montage({fig13, fig14, fig15, fig131, fig141, fig151});
saveas(gcf, fullfile(montage_fig,'slide_4_1_all'), 'tif');

fig16 = fullfile(BB_apical, 'Mean_distance_of_long_&_short_BB_trajectories.tif');
fig17 = fullfile(BB_apical, 'Mean_duration_of_long_&_short_BB_trajectories.tif');
fig18 = fullfile(BB_apical, 'Mean_speed_of_long_&_short_BB_trajectories.tif');
montage({fig16, fig17, fig18});
saveas(gcf, fullfile(montage_fig,'slide_4_2_3_all'), 'tif');

fig5 = fullfile(BB_apical, 'Step_distance_of_BB_trajectories_apicaldomain.tif');
fig55 = fullfile(BB_apical, 'Step_distance_of_BB_trajectories_apicaldomain_histogram.tif');
fig6 = fullfile(BB_apical, 'Instantaneous_speed_of_BBs_apicaldomain.tif');
fig56 = fullfile(BB_apical, 'Instantaneous_speed_of_BBs_apicaldomain_histogram.tif');
montage({fig5, fig55, fig6, fig56});
saveas(gcf, fullfile(montage_fig,'slide_5_all'), 'tif');

fig7 = fullfile(BB_apical, 'Meanintensity_at_BB_position_in_apical_domain.tif');
fig57 = fullfile(BB_apical, 'Meanintensity_at_BB_position_in_apical_domain_histogram.tif');
fig8 = fullfile(BB_apical, 'Totalintensity_at_BB_position_in_apical_domain.tif');
fig58 = fullfile(BB_apical, 'Totalintensity_at_BB_position_in_apical_domain_histogram.tif');
fig9 = fullfile(BB_apical, 'Meanintensity_surounding_BB_in_apical_domain.tif');
fig59 = fullfile(BB_apical, 'Meanintensity_surounding_BB_in_apical_domain_histogram.tif');
fig10 = fullfile(BB_apical, 'Totalintensity_surounding_BB_in_apical_domain.tif');
fig60 = fullfile(BB_apical, 'Totalintensity_surounding_BB_in_apical_domain_histogram.tif');
montage({fig7, fig57, fig8, fig58, fig9 fig59, fig10, fig60});
saveas(gcf, fullfile(montage_fig,'slide_6_all'), 'tif');

close all;
 