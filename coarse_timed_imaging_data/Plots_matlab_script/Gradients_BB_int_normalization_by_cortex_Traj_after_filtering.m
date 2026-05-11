%% Raghavan Thiagarajan, DanStem, Copenhagen, July 2020

% This is the first script in the pipeline for BB analysis. Here we get all the basic parameters like area, BB count, actin intensities and generate most of the parent matrices that will be used later in many of the
% scripts down the pipeline.

%%
% Creating directories for saving the plots
close all;
clear all;
clc;

% There are two things obtained below: 
% (1)The duration of small trajectories that are to be filtered. This value is obtained after performing the BB tracking using the Fiji plugin. At this point, different trajectory durations are checked 
% to see if some trajectories can be filtered out in order to get rid of the small trajectories (that results from inaccuracies during thresholding and particle detection). Usually I choose the duration that
% matches the no of trajectories with the no of BBs in the last frame.
% (2) The duration that is used to segregate long and short trajectories. This varies from cell to cell. For now, I am using (2/3)rd of the duration of a cell as the duration to segregate long and short
% trajectories. That is, trajectories with the duration that are (2/3)rd of the total movie duration will be designated as long trajectories and the rest will be designated as short trajectories. 
% This is an arbitrarily assumed value.

prompt = {'Enter the trajectory duration value that allowed the filtering of irrational trajectories [no of frames]'; 'Enter the duration to segregate long and short trajectories [min]'}; % trajectories that are below this duration are filtered out
dlgtitle = 'Trajectory filtering';
dims = [1 75];
definput = {'2', '2'};
answer = inputdlg(prompt, dlgtitle, dims, definput);
traj_filter_duration = str2num(answer{1});
traj_segregate_duration = str2num(answer{2});
txt=fopen('Trajectory_duration_filter.txt','a+');
fprintf(txt, ['\r\n','Enter the trajectory duration value that allowed the filtering of irrational trajectories [no of frames] = ']);
fprintf(txt, '%f \t', traj_filter_duration);
fprintf(txt, ['\r\n','Enter the duration to segregate long and short trajectories [min] = ']);
fprintf(txt, '%f \t', traj_segregate_duration);


% creating all folders
 
mkdir ../Plots Gradients_ActinIntensity
mkdir ../Plots/Gradients_ActinIntensity Whole_roi_msmts
mkdir ../Plots/Gradients_ActinIntensity/Whole_roi_msmts Apical_domain
mkdir ../Plots/Gradients_ActinIntensity/Whole_roi_msmts Full_stack
 
mkdir ../Plots/Gradients_ActinIntensity Discretized_roi_msmts 
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts Apical_domain
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Apical_domain Mean_intensity 
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Apical_domain/Mean_intensity Local_discretization
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Apical_domain Total_intensity
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Apical_domain/Total_intensity Local_discretization
 
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts Full_stack
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack Mean_intensity 
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack/Mean_intensity Left-to-right_direction
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack/Mean_intensity Top-bottom_direction
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack/Mean_intensity Local_discretization
 
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack Total_intensity 
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack/Total_intensity Left-to-right_direction
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack/Total_intensity Top-bottom_direction
mkdir ../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack/Total_intensity Local_discretization
 
mkdir ../Plots ActinInt_at&around_basalbody_position_all
 
mkdir ../Plots/ActinInt_at&around_basalbody_position_all Apical_domain
mkdir ../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain Correlations
mkdir ../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain General
mkdir ../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain Mean_intensity
mkdir ../Plots/ActinInt_at&around_basalbody_position_all/Apical_domain Total_intensity

foldr1 = strcat('ActinInt_at&around_basalbody_position_', sprintf('%01d',traj_filter_duration), 'minlongTraj');
f0 = strcat('../Plots/', foldr1); mkdir(f0);
f1 = strcat('../Plots/', foldr1, '/Apical_domain'); mkdir(f1);
f2 = strcat('../Plots/', foldr1, '/Apical_domain/Correlations'); mkdir(f2);
f3 = strcat('../Plots/', foldr1, '/Apical_domain/General'); mkdir(f3);
f4 = strcat('../Plots/', foldr1, '/Apical_domain/Mean_intensity'); mkdir(f4);
f5 = strcat('../Plots/', foldr1, '/Apical_domain/Total_intensity'); mkdir(f5);

% mkdir ../Plots/ActinInt_at&around_basalbody_position Full_stack
% mkdir ../Plots/ActinInt_at&around_basalbody_position/Full_stack Mean_intensity
% mkdir ../Plots/ActinInt_at&around_basalbody_position/Full_stack Total_intensity
 
mkdir ../Plots Basalbody_count
 
mkdir ../Plots/Basalbody_count Apical_domain
mkdir ../Plots/Basalbody_count/Apical_domain Local_discretization
 
mkdir ../Plots/Basalbody_count Full_stack
mkdir ../Plots/Basalbody_count/Full_stack Left-to-right_direction
mkdir ../Plots/Basalbody_count/Full_stack Top-bottom_direction
mkdir ../Plots/Basalbody_count/Full_stack Local_discretization

foldr1 = strcat('t0_basalbody_position_', sprintf('%01d',traj_filter_duration), 'minlongTraj');
f0 = strcat('../Plots/', foldr1); mkdir(f0);
f1 = strcat('../Plots/', foldr1, '/bb_appearance_input'); mkdir(f1);
f2 = strcat('../Plots/', foldr1, '/bb_appearance_plot'); mkdir(f2);

foldr1 = strcat('tend_basalbody_position_', sprintf('%01d',traj_filter_duration), 'minlongTraj');
f0 = strcat('../Plots/', foldr1); mkdir(f0);
f1 = strcat('../Plots/', foldr1, '/bb_disappearance_input'); mkdir(f1);
f2 = strcat('../Plots/', foldr1, '/bb_disappearance_plot'); mkdir(f2);

mkdir ../Plots t0_basalbody_position_all
mkdir ../Plots/t0_basalbody_position_all bb_appearance_input
mkdir ../Plots/t0_basalbody_position_all bb_appearance_plot

mkdir ../Plots tend_basalbody_position_all
mkdir ../Plots/tend_basalbody_position_all bb_disappearance_input
mkdir ../Plots/tend_basalbody_position_all bb_disappearance_plot

mkdir ../Plots montage 
 
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
 
Ap_slice = 1; % Slice corresponding to the apical domain (maximum intensity slice)        (CHANGE THIS !!!) % This need not be changed if all the analysis is only done on one slice instead of the whole Z stack.
zslice_acquired_thickness = 1; % In micrometers. Thickness of each acquired slice.        (CHANGE THIS !!!) % This need not be changed if all the analysis is only done on one slice instead of the whole Z stack.
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
        cortex_totalintensity = cortex_intensity(:,27); 
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
    Centroid_apicaldomainx = Whole_roi_measure(Ap_slice,8); Centroid_apicaldomainy = Whole_roi_measure(Ap_slice,9);
    centroid_current_x = Centroid_apicaldomainx; centroid_current_y = Centroid_apicaldomainy;
    
    if i == 1
        centroid_movement(i,1) = 0;
    else
        centroid_movement(i,1) = (sqrt((centroid_previous_x - centroid_current_x)^2 + (centroid_previous_y - centroid_current_y)^2));
    end
    
    centroid_previous_x = Centroid_apicaldomainx; centroid_previous_y = Centroid_apicaldomainy;
    
    
    MeanIntensity_stack = Whole_roi_measure(:,3);
    % MeanIntensity_stack = MeanIntensity_stack - All_background{1,i};
    % MeanIntensity_stack = MeanIntensity_stack / (max(MeanIntensity_stack));    
    MeanIntensity_stack = MeanIntensity_stack ./ cortex_meanint{1,i};
    MeanInt_apicaldomain = Whole_roi_measure(Ap_slice,3); 
    % MeanInt_apicaldomain = MeanInt_apicaldomain - All_background{1,i}(Ap_slice,1); 
    MeanIntensity_apicaldomain(i,1) = MeanInt_apicaldomain / cortex_meanint{1,i}(Ap_slice,1);
        
    TotalIntensity_stack = Whole_roi_measure(:,27); 
    % TotalIntensity_stack = TotalIntensity_stack - (All_background{1,i} .* Area_stack);
    % TotalIntensity_stack = TotalIntensity_stack / (max(TotalIntensity_stack));
    TotalIntensity_stack = TotalIntensity_stack ./ cortex_totalint{1,i};
    TotalInt_apicaldomain = Whole_roi_measure(Ap_slice,27); 
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

figure(1); 
plot(Timepoint, Area_apicaldomain, 'b-x','LineWidth', 0.8); 
figure(3);
plot(Timepoint, Circularity_apicaldomain, 'm-x','LineWidth', 0.8);
figure(5); 
plot(Timepoint, MeanIntensity_apicaldomain, 'r-x','LineWidth', 0.8);
figure(7); 
plot(Timepoint, TotalIntensity_apicaldomain, 'k-x','LineWidth', 0.8);
figure(9);
plot(Timepoint, centroid_movement, 'k-x','LineWidth', 0.8);
figure(10); 
plot(Timepoint, CortexMeanint_apical, 'k-x','LineWidth', 0.8);
figure(11);
plot(Timepoint, CortexTotint_apical, 'k-x','LineWidth', 0.8);
figure(12);
plot(Timepoint, aspect_ratio, 'm-x','LineWidth', 0.8);


figure(1);
xlabel('Time [min]');  ylabel('Area [\mum^2]'); title('Area apical domain'); set(gca,'fontsize',18);
Area_apical = '../Plots/Gradients_ActinIntensity/Whole_roi_msmts/Apical_domain'; 
saveas(gcf, fullfile(Area_apical, 'Area_apicaldomain'), 'fig'); saveas(gcf, fullfile(Area_apical, 'Area_apicaldomain'), 'tif');
% figure(2); 
% xlabel('Cell height [\mum]');  ylabel('Time [min]'); zlabel('Area [\mum^2]'); title('Area full stack'); set(gca,'fontsize',18);
% Area_stack = '../Plots/Gradients_ActinIntensity/Whole_roi_msmts/Full_stack/'; view(-7,72);
% saveas(gcf, fullfile(Area_stack, 'Area_fullstack'), 'fig'); saveas(gcf, fullfile(Area_stack, 'Area_fullstack'), 'tif');
 
figure(3); 
xlabel('Time [min]');  ylabel('Circularity'); title('Circularity apical domain'); set(gca,'fontsize',18);
Circularity_apical = '../Plots/Gradients_ActinIntensity/Whole_roi_msmts/Apical_domain' ; 
saveas(gcf, fullfile(Circularity_apical, 'Circularity_apicaldomain'), 'fig'); saveas(gcf, fullfile(Circularity_apical, 'Circularity_apicaldomain'), 'tif');
% figure(4); 
% xlabel('Cell height [\mum]');  ylabel('Time [min]'); zlabel('Circularity'); title('Circularity fullstack'); set(gca,'fontsize',18);
% Circularity_stack = '../Plots/Gradients_ActinIntensity/Whole_roi_msmts/Full_stack/'; view(-7,72);
% saveas(gcf, fullfile(Circularity_stack, 'Circularity_fullstack'), 'fig'); saveas(gcf, fullfile(Circularity_stack, 'Circularity_fullstack'), 'tif');
 
figure(5); 
xlabel('Time [min]');  ylabel('Mean intensity [a.u]'); title('Mean Intensity apical domain'); set(gca,'fontsize',18);
MeanIntensity_apical = '../Plots/Gradients_ActinIntensity/Whole_roi_msmts/Apical_domain'; 
saveas(gcf, fullfile(MeanIntensity_apical, 'MeanIntensity_apicaldomain'), 'fig'); saveas(gcf, fullfile(MeanIntensity_apical, 'MeanIntensity_apicaldomain'), 'tif');
% figure(6); 
% xlabel('Cell height [\mum]');  ylabel('Time [min]'); zlabel('Mean intensity [a.u]'); title('Mean Intensity full stack'); set(gca,'fontsize',18);
% MeanIntensity_stack = '../Plots/Gradients_ActinIntensity/Whole_roi_msmts/Full_stack/'; view(-7,72);
% saveas(gcf, fullfile(MeanIntensity_stack, 'MeanIntensity_fullstack'), 'fig'); saveas(gcf, fullfile(MeanIntensity_stack, 'MeanIntensity_fullstack'), 'tif');
 
figure(7); 
xlabel('Time [min]');  ylabel('Total intensity [a.u]'); title('Total Intensity apical domain'); set(gca,'fontsize',18);
TotalIntensity_apical = '../Plots/Gradients_ActinIntensity/Whole_roi_msmts/Apical_domain'; 
saveas(gcf, fullfile(TotalIntensity_apical, 'TotalIntensity_apicaldomain'), 'fig'); saveas(gcf, fullfile(TotalIntensity_apical, 'TotalIntensity_apicaldomain'), 'tif');
% figure(8); 
% xlabel('Cell height [\mum]');  ylabel('Time [min]'); zlabel('Total intensity [a.u]'); title('Total Intensity full stack'); set(gca,'fontsize',18);
% TotalIntensity_stack = '../Plots/Gradients_ActinIntensity/Whole_roi_msmts/Full_stack/'; view(-7,72);
% saveas(gcf, fullfile(TotalIntensity_stack, 'TotalIntensity_fullstack'), 'fig'); saveas(gcf, fullfile(TotalIntensity_stack, 'TotalIntensity_fullstack'), 'tif');

figure(9); 
xlabel('Time [min]');  ylabel('Centroid displacement [\mum]'); title('Centroid apical domain'); set(gca,'fontsize',18);
centroid_apical = '../Plots/Gradients_ActinIntensity/Whole_roi_msmts/Apical_domain'; 
saveas(gcf, fullfile(centroid_apical, 'Centroid_apicaldomain'), 'fig'); saveas(gcf, fullfile(centroid_apical, 'Centroid_apicaldomain'), 'tif');

figure(10); 
xlabel('Time [min]');  ylabel('Mean intensity [a.u]'); title('Cortex mean int apical domain'); set(gca,'fontsize',18);
cortexmeanint_apical = '../Plots/Gradients_ActinIntensity/Whole_roi_msmts/Apical_domain'; 
saveas(gcf, fullfile(cortexmeanint_apical, 'Cortex_mean_int_apicaldomain'), 'fig'); saveas(gcf, fullfile(cortexmeanint_apical, 'Cortex_mean_int_apicaldomain'), 'tif');

figure(11); 
xlabel('Time [min]');  ylabel('Total intensity [a.u]'); title('Cortex tot int apical domain'); set(gca,'fontsize',18);
cortextotint_apical = '../Plots/Gradients_ActinIntensity/Whole_roi_msmts/Apical_domain'; 
saveas(gcf, fullfile(cortextotint_apical, 'Cortex_tot_int_apicaldomain'), 'fig'); saveas(gcf, fullfile(cortextotint_apical, 'Cortex_tot_int_apicaldomain'), 'tif');

figure(12); 
xlabel('Time [min]');  ylabel('Isotropicity'); title('Expansion-isotropicity'); set(gca,'fontsize',18);
cortextotint_apical = '../Plots/Gradients_ActinIntensity/Whole_roi_msmts/Apical_domain'; 
saveas(gcf, fullfile(cortextotint_apical, 'Isotropicity_expansion'), 'fig'); saveas(gcf, fullfile(cortextotint_apical, 'Isotropicity_expansion'), 'tif');

close all;

% saving as montage
montage_fig = '../Plots/montage';
fig9 = fullfile(cortextotint_apical, 'Centroid_apicaldomain.tif');
fig3 = fullfile(cortextotint_apical, 'Circularity_apicaldomain.tif');
fig12 = fullfile(cortextotint_apical, 'Isotropicity_expansion.tif');
fig10 = fullfile(cortextotint_apical, 'Cortex_mean_int_apicaldomain.tif');
fig11 = fullfile(cortextotint_apical, 'Cortex_tot_int_apicaldomain.tif');

montage({fig9, fig3, fig12, fig10, fig11});
saveas(gcf, fullfile(montage_fig,'slide_3'), 'tif');
 
close all;
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
        Totalintensity_LR = Discretized_Data_LR(:,27);
        % Totalintensity_LR = Totalintensity_LR - (All_background{1,i}(j,1) * All_Area_LR{i,j});
        % Totalintensity_LR = Totalintensity_LR / max(Totalintensity_LR);
        Totalintensity_LR = Totalintensity_LR / cortex_totalint{1,i}(j,1); 
        All_Totalintensity_LR{i,j} = Totalintensity_LR;
        % (TB direction)
        Totalintensity_TB = Discretized_Data_TB(:,27);
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

max_meanintlist_LR = zeros(No_of_timepoints,No_of_slices); min_meanintlist_LR = zeros(No_of_timepoints,No_of_slices);
max_meanintlist_TB = zeros(No_of_timepoints,No_of_slices); min_meanintlist_TB = zeros(No_of_timepoints,No_of_slices);
max_totalintlist_LR = zeros(No_of_timepoints,No_of_slices); min_totalintlist_LR = zeros(No_of_timepoints,No_of_slices);
max_totalintlist_TB = zeros(No_of_timepoints,No_of_slices); min_totalintlist_TB = zeros(No_of_timepoints,No_of_slices);

for i = 1:No_of_timepoints
    for j = 1:No_of_slices
        
        % Fetching the intensity values corresponding to current timepoint and current slice for plotting
        Meanintensity_LR = All_Meanintensity_LR{i,j}; % Meanintensity (LR direction)
        Meanintensity_TB = All_Meanintensity_TB{i,j}; % Meanintensity (TB direction)
        Totalintensity_LR = All_Totalintensity_LR{i,j}; % Totalintensity (LR direction)
        Totalintensity_TB = All_Totalintensity_TB{i,j}; % Totalintensity (TB direction)
        max_meanintlist_LR(i,j) = max(Meanintensity_LR); min_meanintlist_LR(i,j) = min(Meanintensity_LR); 
        max_meanintlist_TB(i,j) = max(Meanintensity_TB); min_meanintlist_TB(i,j) = min(Meanintensity_TB);
        max_totalintlist_LR(i,j) = max(Totalintensity_TB); min_totalintlist_LR(i,j) = min(Totalintensity_TB);
        max_totalintlist_TB(i,j) = max(Totalintensity_TB); min_totalintlist_TB(i,j) = min(Totalintensity_TB);
               
    end
end

max_meanint_LR = max(max_meanintlist_LR); min_meanint_LR = min(min_meanintlist_LR); 
max_meanint_TB = max(max_meanintlist_TB); min_meanint_TB = min(min_meanintlist_TB);
max_totalint_LR = max(max_totalintlist_LR); min_totalint_LR = min(min_totalintlist_LR);
max_totalint_TB = max(max_totalintlist_TB); min_totalint_TB = min(min_totalintlist_TB);  
 
for i = 1:No_of_timepoints
    
    for j = 1:No_of_slices  
        
        % Fetching the intensity values corresponding to current timepoint and current slice for plotting
        Meanintensity_LR = All_Meanintensity_LR{i,j}; % Meanintensity (LR direction)
        Meanintensity_TB = All_Meanintensity_TB{i,j}; % Meanintensity (TB direction)
        Totalintensity_LR = All_Totalintensity_LR{i,j}; % Totalintensity (LR direction)
        Totalintensity_TB = All_Totalintensity_TB{i,j}; % Totalintensity (TB direction)
        
        %----------------------------------------------------------------------------------------------------------------------------%
        
%         % Fetching the width values corresponding to current timepoint and current slice for plotting
%         
%         % IF THE CELL EXPANDS TOWARDS RIGHT HAND SIDE----    Depending on the cell expansion side, (CHANGE THIS !!)
%         Width_LR = All_Width_LR_values{i,j}; % (LR direction)
%         Width_LR = Width_LR * pixelwidth;
%         Width_TB = All_Width_TB_values{i,j}; % (TB direction)
%         Width_TB = Width_TB * pixelwidth;
%         Width_LRmaxlimit = max(Width_LR)+(10 * pixelwidth); Width_LRminlimit = min(Width_LR);
%         Width_TBmaxlimit = max(Width_TB)+(10 * pixelwidth); Width_TBminlimit = min(Width_TB);
        
        %IF THE CELL EXPANDS TOWARDS LEFT HAND SIDE----, then for adjusting the cell expansion side:       Depending on the cell expansion side, (CHANGE THIS !!)
        %Finding the maximum cell length for the current slice across all time points 
        Width_LR_maxlist = zeros(No_of_timepoints,1);
        Width_TB_maxlist = zeros(No_of_timepoints,1);
        for t = 1:No_of_timepoints
            Width_LR_individual = All_Width_LR_values{t,j};
            Width_LR_maxlist(t) = Width_LR_individual(end);
            Width_TB_individual = All_Width_TB_values{t,j};
            Width_TB_maxlist(t) = Width_TB_individual(end);
        end
        % Adjusting for the expansion side
        % (LR direction)
        Width_LR_max = max(Width_LR_maxlist);
        clear Width_LR_maxlist;
        Width_LR_current = All_Width_LR_values{i,j};
        Width_LR_current_end =  Width_LR_current(end); % Width corresponding to the longest end of the cell for the current slice and current time
        Width_LR_adjust_value = abs(Width_LR_max - Width_LR_current_end);
        Width_LR_adjusted = (Width_LR_current + Width_LR_adjust_value);
        Width_LR_adjusted = max(Width_LR_adjusted) - Width_LR_adjusted;
        Width_LR = Width_LR_adjusted * pixelwidth;
        Width_LRmaxlimit = max(Width_LR)+(10 * pixelwidth); Width_LRminlimit = min(Width_LR);
                
        % (TB direction)
        Width_TB_max = max(Width_TB_maxlist);
        clear Width_TB_maxlist;
        Width_TB_current = All_Width_TB_values{i,j};
        Width_TB_current_end =  Width_TB_current(end); % Width corresponding to the longest end of the cell for the current slice and current time
        Width_TB_adjust_value = abs(Width_TB_max - Width_TB_current_end);
        Width_TB_adjusted = (Width_TB_current + Width_TB_adjust_value);
        Width_TB_adjusted = max(Width_TB_adjusted) - Width_TB_adjusted;
        Width_TB = Width_TB_adjusted * pixelwidth;  
        Width_TBmaxlimit = max(Width_TB)+(10 * pixelwidth); Width_TBminlimit = min(Width_TB);
        % Comment until here IF THE CELL EXPANDS TOWARDS LEFT HAND SIDE----     (CHANGE THIS !!)
        
%         % IF THE CELL EXPANDS ISOTROPICALLY----, then for adjusting the cell expansion side:       Depending on the cell expansion side, (CHANGE THIS !!)
%         % Finding the midpoint of cell length for the current slice across all time points 
%         Width_LR_medianlist = zeros(No_of_timepoints,1);
%         Width_TB_medianlist = zeros(No_of_timepoints,1);
%         for t = 1:No_of_timepoints
%             Width_LR_individual = All_Width_LR_values{t,j};
%             Width_LR_medianlist(t) = Width_LR_individual(ceil(end/2));
%             Width_TB_individual = All_Width_TB_values{t,j};
%             Width_TB_medianlist(t) = Width_TB_individual(ceil(end/2));
%         end
%         % Adjusting for the expansion side
%         % (LR direction)
%         Width_LR_current = All_Width_LR_values{i,j};
%         Width_LR_current_median =  round(Width_LR_current(ceil(end/2))); % Width corresponding to the median of the cell for the current slice and current time
%         Width_LR_adjusted = Width_LR_current - Width_LR_current_median;
%         Width_LR = Width_LR_adjusted * pixelwidth;
%         Width_LRmaxlimit = max(Width_LR)+(10 * pixelwidth); Width_LRminlimit = min(Width_LR) - (10 * pixelwidth);
%                        
%         % (TB direction)
%         Width_TB_current = All_Width_TB_values{i,j};
%         Width_TB_current_median =  Width_TB_current(ceil(end/2)); % Width corresponding to the median of the cell for the current slice and current time
%         Width_TB_adjusted = Width_TB_current - Width_TB_current_median;
%         Width_TB = Width_TB_adjusted * pixelwidth;
%         Width_TBmaxlimit = max(Width_TB)+(10 * pixelwidth); Width_TBminlimit = min(Width_TB) - (10 * pixelwidth);
%         % Comment until here IF THE CELL EXPANDS ISOTROPICALLY----     (CHANGE THIS !!)
        
        %----------------------------------------------------------------------------------------------------------------------------%
        
        % Height (Z) of the cell from Z stacks
        Zheight = j * zslice_total_thickness; % In micrometers.
        Zheight_LR = Zheight.*ones(size(Meanintensity_LR)); Zheight_LRmaxlimit = max(Zheight_LR)+10; %Zheight_LRminlimit = min(Zheight_LR);
        Zheight_TB = Zheight.*ones(size(Meanintensity_TB)); Zheight_TBmaxlimit = max(Zheight_TB)+10; %Zheight_TBminlimit = min(Zheight_TB);
        
        % Time
        Timepoint =  i * Time_interval; % In minutes
        Time_3Dplot_LR = Timepoint.*ones(size(Meanintensity_LR));
        Time_3Dplot_TB = Timepoint.*ones(size(Meanintensity_TB));
        
        mymap = [1 0 1
         1 0 1
         0 1 1
         0 1 1
         0 0 0
         0 0 0];
        
%         figure(1); 
%         plot3(Width_LR, Zheight_LR, Meanintensity_LR, 'LineWidth', 0.01); colorbar; %caxis([min_meanint_LR max_meanint_LR]); xlim([0 Width_LRmaxlimit]); ylim([0 Zheight_LRmaxlimit]);
%         surface([Width_LR(:), Width_LR(:)], [Zheight_LR(:), Zheight_LR(:)], [Meanintensity_LR(:), Meanintensity_LR(:)], [Meanintensity_LR(:), Meanintensity_LR(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 4);
%         colormap viridis; %colormap(mymap);
%         hold on
%                
%         figure(2); 
%         plot3(Zheight_TB, Width_TB, Meanintensity_TB, 'LineWidth', 0.01); colorbar; %caxis([min_meanint_TB max_meanint_TB]); xlim([0 Zheight_TBmaxlimit]); ylim([0 Width_TBmaxlimit]);
%         surface([Zheight_TB(:), Zheight_TB(:)], [Width_TB(:), Width_TB(:)], [Meanintensity_TB(:), Meanintensity_TB(:)], [Meanintensity_TB(:), Meanintensity_TB(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 4.5);
%         colormap viridis; %colormap(mymap);
%         hold on
%         
%         figure(3); 
%         plot3(Width_LR, Zheight_LR, Totalintensity_LR, 'LineWidth', 0.01); colorbar; %caxis([min_totalint_LR max_totalint_LR]); xlim([0 Width_LRmaxlimit]); ylim([0 Zheight_LRmaxlimit]);
%         surface([Width_LR(:), Width_LR(:)], [Zheight_LR(:), Zheight_LR(:)], [Totalintensity_LR(:), Totalintensity_LR(:)], [Totalintensity_LR(:), Totalintensity_LR(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 4);
%         colormap viridis; %colormap(mymap);
%         hold on
%         
%         figure(4); 
%         plot3(Zheight_TB, Width_TB, Totalintensity_TB, 'LineWidth', 0.01); colorbar; %caxis([min_totalint_TB max_totalint_TB]); xlim([0 Zheight_TBmaxlimit]); ylim([0 Width_TBmaxlimit]);
%         surface([Zheight_TB(:), Zheight_TB(:)], [Width_TB(:), Width_TB(:)], [Totalintensity_TB(:), Totalintensity_TB(:)], [Totalintensity_TB(:), Totalintensity_TB(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 4.5);
%         colormap viridis; %colormap(mymap);
%         hold on
        
        % Plotting the intensity gradients only for the apical domain
        
        if j == Ap_slice  
            
            figure(5); 
            plot3(Width_LR, Time_3Dplot_LR, Meanintensity_LR, 'LineWidth', 0.01); 
            surface([Width_LR(:), Width_LR(:)], [Time_3Dplot_LR(:), Time_3Dplot_LR(:)], [Meanintensity_LR(:), Meanintensity_LR(:)], [Meanintensity_LR(:), Meanintensity_LR(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 3);
            colormap viridis; %colormap(mymap);
            hold on
            
            figure(6); 
            plot3(Time_3Dplot_TB, Width_TB, Meanintensity_TB, 'LineWidth', 0.01); 
            surface([Time_3Dplot_TB(:), Time_3Dplot_TB(:)], [Width_TB(:), Width_TB(:)], [Meanintensity_TB(:), Meanintensity_TB(:)], [Meanintensity_TB(:), Meanintensity_TB(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 3.5);
            colormap viridis; %colormap(mymap);
            hold on
            
%             figure(7); 
%             plot3(Width_LR, Time_3Dplot_LR, Totalintensity_LR, 'LineWidth', 0.01); 
%             surface([Width_LR(:), Width_LR(:)], [Time_3Dplot_LR(:), Time_3Dplot_LR(:)], [Totalintensity_LR(:), Totalintensity_LR(:)], [Totalintensity_LR(:), Totalintensity_LR(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 4);
%             colormap viridis; %colormap(mymap);
%             hold on
%             
%             figure(8); 
%             plot3(Time_3Dplot_TB, Width_TB, Totalintensity_TB, 'LineWidth', 0.01); 
%             surface([Time_3Dplot_TB(:), Time_3Dplot_TB(:)], [Width_TB(:), Width_TB(:)], [Totalintensity_TB(:), Totalintensity_TB(:)], [Totalintensity_TB(:), Totalintensity_TB(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 4.5);
%             colormap viridis; %colormap(mymap);
%             hold on 
            
        end
            
    end
    
end
    
%     figure(1); 
%     xlabel('Distance (x) [\mum]');  ylabel(' Height (z) [\mum]'); zlabel('Mean intensity [a.u]'); title('Mean int gradient LR full stack'); 
%     set(gca,'fontsize',18); set(gca, 'Xdir', 'reverse'); 
%     Meanint_LR = '../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack/Mean_intensity/Left-to-right_direction/';
%     Meanint_fig_LR = strcat('Meanint_gradient_LR_fullstack_t_', sprintf('%01d',i)); view(2);
%     saveas(gcf, fullfile(Meanint_LR, Meanint_fig_LR),'fig'); saveas(gcf, fullfile(Meanint_LR, Meanint_fig_LR),'tif');
%     clf;        
%     
%     figure(2); 
%     xlabel('Height (z) [\mum]');  ylabel('Distance (y) [\mum]'); zlabel('Mean intensity [a.u]'); title('Mean int gradient TB full stack'); 
%     set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse');
%     Meanint_TB = '../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack/Mean_intensity/Top-bottom_direction/';
%     Meanint_fig_TB = strcat('Meanint_gradient_TB_fullstack_t_', sprintf('%01d',i)); view(2);
%     saveas(gcf, fullfile(Meanint_TB, Meanint_fig_TB),'fig'); saveas(gcf, fullfile(Meanint_TB, Meanint_fig_TB),'tif');
%     clf;
%     
%     figure(3); 
%     xlabel('Distance (x) [\mum]');  ylabel(' Height (z) [\mum]'); zlabel('Total intensity [a.u]'); title('Total int gradient LR full stack'); 
%     set(gca,'fontsize',18); set(gca, 'Xdir', 'reverse');
%     Totalint_LR = '../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack/Total_intensity/Left-to-right_direction';
%     Totalint_fig_LR = strcat('Totalint_gradient_LR_fullstack_t_', sprintf('%01d',i)); view(2);
%     saveas(gcf, fullfile(Totalint_LR, Totalint_fig_LR),'fig'); saveas(gcf, fullfile(Totalint_LR, Totalint_fig_LR),'tif');
%     clf;        
%     
%     figure(4); 
%     xlabel('Height (z) [\mum]');  ylabel('Distance (y) [\mum]'); zlabel('Total intensity [a.u]'); title('Total int gradient TB full stack'); 
%     set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse');
%     Totalint_TB = '../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack/Total_intensity/Top-bottom_direction';
%     Totalint_fig_TB = strcat('Totalint_gradient_TB_fullstack_t_', sprintf('%01d',i)); view(2);
%     saveas(gcf, fullfile(Totalint_TB, Totalint_fig_TB),'fig'); saveas(gcf, fullfile(Totalint_TB, Totalint_fig_TB),'tif');
%     clf;
 
figure(5); 
xlabel('Distance (x) [\mum]');  ylabel('Time [min]'); zlabel('Mean intensity [a.u]'); title('Mean int gradient LR apical domain'); 
xlim([Width_LRminlimit Width_LRmaxlimit]);  % (CHANGE THIS IF NEEDED !!)
set(gca,'fontsize',18); set(gca, 'Xdir', 'reverse'); colorbar; clim([min_meanint_LR max_meanint_LR]); 
Meanint_LR = '../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Apical_domain/Mean_intensity/';
Meanint_fig_LR = strcat('Meanint_gradient_LR_apicaldomain'); view(2);
saveas(gcf, fullfile(Meanint_LR, Meanint_fig_LR),'fig'); saveas(gcf, fullfile(Meanint_LR, Meanint_fig_LR),'tif');
        
figure(6); 
xlabel('Time [min]');  ylabel('Distance (y) [\mum]'); zlabel('Mean intensity [a.u]'); title('Mean int gradient TB apical domain'); 
set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse'); colorbar; clim([min_meanint_TB max_meanint_TB]); 
ylim([Width_TBminlimit Width_TBmaxlimit]);  % (CHANGE THIS IF NEEDED !!)
Meanint_TB = '../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Apical_domain/Mean_intensity/';
Meanint_fig_TB = strcat('Meanint_gradient_TB_apicaldomain'); view(2);
saveas(gcf, fullfile(Meanint_TB, Meanint_fig_TB),'fig'); saveas(gcf, fullfile(Meanint_TB, Meanint_fig_TB),'tif');
        
% figure(7); 
% xlabel('Distance (x) [\mum]');  ylabel('Time [min]'); zlabel('Total intensity [a.u]'); title('Total int gradient LR apical domain'); 
% set(gca,'fontsize',18); set(gca, 'Xdir', 'reverse'); colorbar; caxis([min_totalint_LR max_totalint_LR]); 
% xlim([Width_LRminlimit Width_LRmaxlimit]);  % (CHANGE THIS IF NEEDED !!)            
% Totalint_LR = '../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Apical_domain/Total_intensity/';
% Totalint_fig_LR = strcat('Totalint_gradient_LR_apicaldomain'); view(2);
% saveas(gcf, fullfile(Totalint_LR, Totalint_fig_LR),'fig'); saveas(gcf, fullfile(Totalint_LR, Totalint_fig_LR),'tif');
%         
% figure(8); 
% xlabel('Time [min]');  ylabel('Distance (y) [\mum]'); zlabel('Total intensity [a.u]'); title('Total int gradient TB apical domain'); 
% set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse'); colorbar; caxis([min_totalint_TB max_totalint_TB]);
% ylim([Width_TBminlimit Width_TBmaxlimit]);  % (CHANGE THIS IF NEEDED !!)
% Totalint_TB = '../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Apical_domain/Total_intensity/';
% Totalint_fig_TB = strcat('Totalint_gradient_TB_apicaldomain'); view(2);
% saveas(gcf, fullfile(Totalint_TB, Totalint_fig_TB),'fig'); saveas(gcf, fullfile(Totalint_TB, Totalint_fig_TB),'tif');

close all;

% saving as montage
montage_fig = '../Plots/montage';

fig5 = fullfile(Meanint_LR, 'Meanint_gradient_LR_apicaldomain.tif');
fig6 = fullfile(Meanint_TB, 'Meanint_gradient_TB_apicaldomain.tif');
montage({fig5,fig6});
saveas(gcf, fullfile(montage_fig,'slide_7_1'), 'tif');

close all;
 
%% Plotting the local discretization (squares) (only for mean intensity and total intensity)
 
% % Plotting the intensity gradient for full stack
% % Loading data for intensity
% Squares_intensity = '../data/Gradients_of_actin_intensity/Discretized_ROI_Results/Discretized_ROI_Full_Measure/Local_discretization/Square_Fullmeasure_t_';
% 
% SquareArea = cell(No_of_timepoints,No_of_slices);
% SquareX = cell(No_of_timepoints,No_of_slices); SquareY = cell(No_of_timepoints,No_of_slices);
% maxsqrX = zeros(No_of_timepoints,No_of_slices); minsqrX = zeros(No_of_timepoints,No_of_slices); 
% maxsqrY = zeros(No_of_timepoints,No_of_slices); minsqrY = zeros(No_of_timepoints,No_of_slices);
% Square_MeanInt = cell(No_of_timepoints,No_of_slices); Square_TotInt = cell(No_of_timepoints,No_of_slices);
% max_Square_MeanInt = zeros(No_of_timepoints,No_of_slices); max_Square_TotInt = zeros(No_of_timepoints,No_of_slices);
% min_Square_MeanInt = zeros(No_of_timepoints,No_of_slices); min_Square_TotInt = zeros(No_of_timepoints,No_of_slices);
%  
% for i = 1:No_of_timepoints
%         
%     for j = 1:No_of_slices
%         
%         % Data input for intensity
%         squares_intensity = strcat(Squares_intensity, sprintf('%01d',i), '_slice_', sprintf('%01d',j), '.txt');
%         
%         % Replacing the characters 'Infinity' present in the text file with the number 'zero'.
%         txt = fopen(squares_intensity,'r');
%         X = fread(txt);
%         X = char(X.');
%         Y = strrep(X, 'Infinity', '0');
%         txt=fopen(squares_intensity,'w');
%         fwrite(txt,Y);
%         
%         squares_Intensity = importdata(squares_intensity);
%         Squares_Intensity = squares_Intensity.data;
%         clear squares_Intensity;
%         
%         % Area
%         SquareArea{i,j} = Squares_Intensity(:,2); % In micrometer squared.         
%                
%         % X & Y coordinates
%         Squarex = Squares_Intensity(:,8); % In micrometers. 
%         SquareX{i,j} = Squarex / pixelwidth; % Dividing by the length of one pixel (in micrometers) converts to pixels i.e., to actual X coordinate of the pixel. This allows scaling of the X coordinates inorder to allow smooth interpolation.
%         Squarey = Squares_Intensity(:,9);  % In micrometers. 
%         SquareY{i,j} = Squarey / pixelwidth; % Dividing by the length of one pixel (in micrometers) converts to pixels i.e., to actual Y coordinate of the pixel. This allows scaling of the Y coordinates inorder to allow smooth interpolation.
%         maxsqrX(i,j) = max(SquareX{i,j}); minsqrX(i,j) = min(SquareX{i,j}); 
%         maxsqrY(i,j) = max(SquareY{i,j}); minsqrY(i,j) = min(SquareY{i,j}); 
%                 
%         % Mean intensity
%         Squaremeanint = Squares_Intensity(:,3);
%         % Squaremeanint = Squaremeanint - All_background{1,i}(j,1);
%         %Square_meanint = Square_meanint / max(Square_meanint);    
%         Square_MeanInt{i,j} = Squaremeanint / cortex_meanint{1,i}(j,1); 
%         max_Square_MeanInt(i,j) = max(Square_MeanInt{i,j}); min_Square_MeanInt(i,j) = min(Square_MeanInt{i,j});
%         
%         % Total intensity
%         Squaretotint = Squares_Intensity(:,27);
%         % Squaretotint = Squaretotint - (All_background{1,i}(j,1) * SquareArea{i,j});
%         % Square_TotInt{i,j} = Squaretotint / max(Squaretotint);   
%         Square_TotInt{i,j} = Squaretotint / cortex_totalint{1,i}(j,1); 
%         max_Square_TotInt(i,j) = max(Square_TotInt{i,j}); min_Square_TotInt(i,j) = min(Square_TotInt{i,j});
%         
%         fclose all;
%     end
% end
% 
% maxXlimit = max(maxsqrX)+50; minXlimit = min(minsqrX)-50;
% maxYlimit = max(maxsqrY)+50; minYlimit = min(minsqrY)-50;
% maxSquare_MeanIntlimit = max(max_Square_MeanInt); minSquare_MeanIntlimit = min(min_Square_MeanInt);
% maxSquare_TotIntlimit = max(max_Square_TotInt); minSquare_TotIntlimit = min(min_Square_TotInt);       
% 
% for i = 1:No_of_timepoints
%         
%     for j = 1:No_of_slices
%         
%         Square_x = SquareX{i,j}; Square_y = SquareY{i,j};
%         maxX = maxsqrX(i,j); minX = minsqrX(i,j);
%         maxY = maxsqrY(i,j); minY = minsqrY(i,j);       
%         Square_meanint = Square_MeanInt{i,j}; Square_totint = Square_TotInt{i,j};        
%         
%         % Converting vectors to matrix to make a surface plot
%         [Xq, Yq] = meshgrid(minX:maxX, minY:maxY);
%         F_meanint = scatteredInterpolant(Square_x, Square_y, Square_meanint); F_meanint.ExtrapolationMethod = 'none';
%         F_totint = scatteredInterpolant(Square_x, Square_y, Square_totint); F_totint.ExtrapolationMethod = 'none';
%         Vq_meanint = F_meanint(Xq, Yq);
%         Vq_totint = F_totint(Xq, Yq);
%                         
% %         figure(1);
% %         %scatter(Square_x, Square_y, 700, Square_meanint, 'fill'); 
% %         fig1 = surf(Xq, Yq, Vq_meanint); fig1.EdgeColor = 'none'; 
% %         colormap viridis; shading interp; colorbar; %caxis([minSquare_MeanIntlimit maxSquare_MeanIntlimit]); 
% %         xlabel('X coorindate');  ylabel('Y coorindate'); zlabel('Mean intensity [a.u]'); title('Local intensity (mean) full stack');  xlim([minXlimit maxXlimit]); ylim([minYlimit maxYlimit]);
% %         set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse'); view(2);
% %         Squareint = '../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack/Mean_intensity/Local_discretization/';
% %         Squareint_fig = strcat('Squareint_fullstack_t_', sprintf('%01d',i),'_slice_',sprintf('%01d',j));
% %         saveas(gcf, fullfile(Squareint, Squareint_fig),'fig'); saveas(gcf, fullfile(Squareint, Squareint_fig),'tif');
% %         
% %         figure(2);
% %         %scatter(Square_x, Square_y, 700, Square_totint, 'fill'); 
% %         fig2 = surf(Xq, Yq, Vq_totint); fig2.EdgeColor = 'none'; 
% %         colormap viridis; shading interp; colorbar; %caxis([minSquare_TotIntlimit maxSquare_TotIntlimit]); 
% %         xlabel('X coorindate');  ylabel('Y coorindate'); zlabel('Total intensity [a.u]'); title('Local intensity (total) full stack'); xlim([minXlimit maxXlimit]); ylim([minYlimit maxYlimit]);
% %         set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse'); view(2)
% %         Squareint = '../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Full_stack/Total_intensity/Local_discretization/';
% %         Squareint_fig = strcat('Squareint_fullstack_t_', sprintf('%01d',i),'_slice_',sprintf('%01d',j));
% %         saveas(gcf, fullfile(Squareint, Squareint_fig),'fig'); saveas(gcf, fullfile(Squareint, Squareint_fig),'tif');       
% %         
%         
%         if j == Ap_slice  
%             
%             figure(5);
%             %scatter(Square_x, Square_y, 700, Square_meanint, 'fill'); 
%             fig5 = surf(Xq, Yq, Vq_meanint); fig5.EdgeColor = 'none'; 
%             colormap viridis; shading interp; colorbar; %caxis([minSquare_MeanIntlimit maxSquare_MeanIntlimit]); 
%             xlabel('X coorindate');  ylabel('Y coorindate'); zlabel('Mean intensity [a.u]'); title('Local intensity (mean) full stack'); xlim([minXlimit maxXlimit]); ylim([minYlimit maxYlimit]);
%             set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse'); view(2)
%             Squareint = '../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Apical_domain/Mean_intensity/Local_discretization/';
%             Squareint_fig = strcat('Squareint_apicaldomain_t_', sprintf('%01d',i),'_slice_',sprintf('%01d',j));
%             saveas(gcf, fullfile(Squareint, Squareint_fig),'fig'); saveas(gcf, fullfile(Squareint, Squareint_fig),'tif');
%             
% %             figure(6);
% %             %scatter(Square_x, Square_y, 700, Square_totint, 'fill'); 
% %             fig6 = surf(Xq, Yq, Vq_totint); fig6.EdgeColor = 'none'; 
% %             colormap viridis; shading interp; colorbar; %caxis([minSquare_TotIntlimit maxSquare_TotIntlimit]); 
% %             xlabel('X coorindate');  ylabel('Y coorindate'); zlabel('Total intensity [a.u]'); title('Local intensity (total) full stack'); xlim([minXlimit maxXlimit]); ylim([minYlimit maxYlimit]);
% %             set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse'); view(2)
% %             Squareint = '../Plots/Gradients_ActinIntensity/Discretized_roi_msmts/Apical_domain/Total_intensity/Local_discretization/';
% %             Squareint_fig = strcat('Squareint_apicaldomain_t_', sprintf('%01d',i),'_slice_',sprintf('%01d',j));
% %             saveas(gcf, fullfile(Squareint, Squareint_fig),'fig'); saveas(gcf, fullfile(Squareint, Squareint_fig),'tif');
% %                         
%         end
%         
%                        
%     end
%     
%            
% end
%  
% close all;
%  
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
 
figure(1); 
yyaxis left
plot(Timelist, Area_apicaldomain, '-bx','LineWidth', 0.8);
yyaxis right
plot(Timelist, No_of_BB, '-rx','LineWidth', 0.8);
xlabel('Time [min]');  title('Area & basalbodies in apical domain'); set(gca,'fontsize',18);
yyaxis left; ylabel('Area [\mum^2]'); 
yyaxis right; ylabel('Basalbody count','rotation',270,'VerticalAlignment','middle'); % , 'Position',[5.4 25 0]
BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General'); 
saveas(gcf, fullfile(BB_apical, 'Area_&_BB_time_apicaldomain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Area_&_BB_time_apicaldomain'), 'tif');
 
figure(2); 
plot(Area_apicaldomain, No_of_BB, '-kx','LineWidth', 0.8);
xlabel('Area [\mum^2]');  ylabel('Basalbody count'); title('Area & basalbodies relation in apical domain'); set(gca,'fontsize',18);
BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General'); 
saveas(gcf, fullfile(BB_apical, 'Area_&_BB_relation_apicaldomain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Area_&_BB_relation_apicaldomain'), 'tif');
 
figure(3);
yyaxis left
plot(Timelist, MeanIntensity_apicaldomain, '-bx','LineWidth', 0.8);
yyaxis right
plot(Timelist, No_of_BB, '-rx','LineWidth', 0.8);
xlabel('Time [min]');  title('Meanintensity & basalbodies in apical domain'); set(gca,'fontsize',18);
yyaxis left; ylabel('Mean intensity'); 
yyaxis right; ylabel('Basalbody count','rotation',270,'VerticalAlignment','middle'); % , 'Position',[5.4 25 0]
BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General'); 
saveas(gcf, fullfile(BB_apical, 'Meanint_&_BB_time_apicaldomain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Meanint_&_BB_time_apicaldomain'), 'tif');
 
figure(4);
yyaxis left
plot(Timelist, TotalIntensity_apicaldomain, '-bx','LineWidth', 0.8);
yyaxis right
plot(Timelist, No_of_BB, '-rx','LineWidth', 0.8);
xlabel('Time [min]'); title('Totalintensity & basalbodies in apical domain'); set(gca,'fontsize',18); 
yyaxis left; ylabel('Total intensity'); 
yyaxis right; ylabel('Basalbody count','rotation',270,'VerticalAlignment','middle');  % ,'Position',[5.4 25 0]
BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General'); 
saveas(gcf, fullfile(BB_apical, 'Totalint_&_BB_time_apicaldomain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Totalint_&_BB_time_apicaldomain'), 'tif');

figure(333);
yyaxis left
plot(Timelist, MeanIntensity_apicaldomain, '-bx','LineWidth', 0.8);
yyaxis right
plot(Timelist, Area_apicaldomain, '-rx','LineWidth', 0.8);
xlabel('Time [min]');  title('Meanintensity & basalbodies in apical domain'); set(gca,'fontsize',18);
yyaxis left; ylabel('Mean intensity'); 
yyaxis right; ylabel('Area [\mum^2]','rotation',270,'VerticalAlignment','middle'); % , 'Position',[5.4 25 0]
BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General'); 
saveas(gcf, fullfile(BB_apical, 'Meanint_&_area_time_apicaldomain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Meanint_&_area_time_apicaldomain'), 'tif');
 
figure(444);
yyaxis left
plot(Timelist, TotalIntensity_apicaldomain, '-bx','LineWidth', 0.8);
yyaxis right
plot(Timelist, Area_apicaldomain, '-rx','LineWidth', 0.8);
xlabel('Time [min]'); title('Totalintensity & basalbodies in apical domain'); set(gca,'fontsize',18); 
yyaxis left; ylabel('Total intensity'); 
yyaxis right; ylabel('Area [\mum^2]','rotation',270,'VerticalAlignment','middle');  % ,'Position',[5.4 25 0]
BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General'); 
saveas(gcf, fullfile(BB_apical, 'Totalint_&_area_time_apicaldomain'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Totalint_&_area_time_apicaldomain'), 'tif');

% area rate calculation
figure(411);
% area_rate = nan(length(Area_apicaldomain)-1,1);
% for a_rate = 1:length(Area_apicaldomain)-1
%     ar_diff = (Area_apicaldomain(a_rate + 1) - Area_apicaldomain(a_rate));
%     area_rate(a_rate,1) = ar_diff / Time_interval;    
% end
area_rate_time_interval = 5; % choosing 5 min as the interval at which area rate is obtained
area_rate_frame_interval = round(area_rate_time_interval / Time_interval); % converting the 'area_rate_time_interval' into frames
ar_diff = Area_apicaldomain(area_rate_frame_interval:1:end, 1) - Area_apicaldomain(1:1:end-(area_rate_frame_interval-1), 1); % getting the difference in area for every 'area_rate_time_interval'
area_rate = ar_diff /  area_rate_time_interval; % getting the area rate
max_apical_area_idx = Area_apicaldomain == max(Area_apicaldomain);
whole_area_rate = (Area_apicaldomain(max_apical_area_idx) - Area_apicaldomain(1)) / (Timelist(max_apical_area_idx) - Timelist(1)); % area rate for the whole apical expansion [\mum^2 min^-1]
plot(Timelist(area_rate_frame_interval:1:end, 1), area_rate, '-kx','LineWidth', 0.8);
xlabel('Time [min]');  ylabel('Area rate [\mum^2 min^-1]'); title('Time vs Area rate'); set(gca,'fontsize',18);
BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General'); 
saveas(gcf, fullfile(BB_apical, 'Area_rate_vs_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Area_rate_vs_time'), 'tif');
figure(412);
plot(Area_apicaldomain(area_rate_frame_interval:1:end, 1), area_rate, '-bx','LineWidth', 0.8);
xlabel('Area [\mum^2]');  ylabel('Area rate [\mum^2 min^-1]'); title('Area vs Area rate'); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, 'Area_rate_vs_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Area_rate_vs_area'), 'tif');
% Normalised area rate
% By normalising the area to the max. area before finding the rate, we are then extending all areas (from the respective starting values) to a maximum of 1. This means we stretch all the areas to the same extent.
% Hence the normalised area rate becomes comparable across data sets.
normalisedArea = Area_apicaldomain/max(Area_apicaldomain); % normalising to the max. area
norm_ar_diff = normalisedArea(area_rate_frame_interval:1:end, 1) - normalisedArea(1:1:end-(area_rate_frame_interval-1), 1); % getting the difference in area for every 'area_rate_time_interval'
norm_area_rate = norm_ar_diff /  area_rate_time_interval; % getting the area rate
figure(413);
plot(Timelist(area_rate_frame_interval:1:end, 1), norm_area_rate, '-kx','LineWidth', 0.8);
xlabel('Time [min]');  ylabel('Rate of (normalised area) expansion [min^-1]'); title({'Rate of normalised area expansion', 'vs Time'}); set(gca,'fontsize',14);
saveas(gcf, fullfile(BB_apical, 'Area_rate_norm_vs_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Area_rate_norm_vs_time'), 'tif');
figure(414);
plot(Area_apicaldomain(area_rate_frame_interval:1:end, 1), norm_area_rate, '-bx','LineWidth', 0.8);
xlabel('Area [\mum^2]');  ylabel('Rate of (normalised area) expansion [min^-1]'); title({'Rate of normalised area expansion', 'vs Area'}); set(gca,'fontsize',14);
saveas(gcf, fullfile(BB_apical, 'Area_rate_norm_vs_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Area_rate_norm_vs_area'), 'tif');

% To get the speed, meanint and totalint of basalbodies for each trajectory
%distance = NaN(no_of_trajectories,Framelist(end)); timeforspeed = NaN(no_of_trajectories,Framelist(end)); speed = NaN(no_of_trajectories,Framelist(end));
 
for trajno = 1:no_of_trajectories
    kend = length(Trajectory_data{trajno,1}); % this gives the trajectory length
       
    % this is to make sure that only those trajectories that are longer than "traj_filter_duration" (in no of frames) are taken for analysis - smaller trajectories are not plotted 
    if kend <= traj_filter_duration % "traj_filter_duration" corresponds to the time (in frames) chosen based on the tracking plugin output. Check the "value_for_filter.txt". Check the description
        % in the first few lines of this script where this value "traj_filter_duration" is obtained as input.
        continue
    else   
        % the loop continues for only those trajectories that are longer than "traj_filter_duration" minutes
        for k = 1: (kend-1)
            distance(trajno,k) = (sqrt((Trajectory_data{trajno,3}(k+1,1) - Trajectory_data{trajno,3}(k,1))^2 + (Trajectory_data{trajno,4}(k+1,1) - Trajectory_data{trajno,4}(k,1))^2)) * pixelwidth;
            timestep(trajno,k) = Trajectory_data{trajno,2}(k+1,1) * Time_interval;
            timeforspeed(trajno,k) = (Trajectory_data{trajno,2}(k+1,1) - Trajectory_data{trajno,2}(k,1)) * Time_interval;
            speed(trajno,k) =  distance(trajno,k) / timeforspeed(trajno,k);
        end
        % getting FFT for speed - to check if there is any oscillation
        get_input = FFT_speed_plot(Time_interval, speed(trajno,:)); % Calling the function "FFT_speed_plot" and feeding the input
        figure(111);
        BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/Mean_intensity/'); 
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
        BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/Mean_intensity/'); 
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
        BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/Mean_intensity/'); 
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
        BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/Total_intensity/'); 
        BB_apical_fig = strcat('Speed_totalint_pos_surrounding_BB_in_apical_domain_traj_', sprintf('%01d',trajno));
        saveas(gcf, fullfile(BB_apical, BB_apical_fig),'fig'); saveas(gcf,fullfile(BB_apical, BB_apical_fig),'tif');
        close(figure(12));
        
        clear timeforspeed; clear speed; clear distance;
    
    end
end
 
% While plotting selected trajectories (for example only those trajectories that are longer than "traj_filter_duration" (no of frames)), rest of the trajectory data gets recorded as "zero". So there will be lot of zeros in all those arrays containing
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
plot(avgs, '*k'); title('Mean distance of "long & short" BB trajectories'); set(gca,'fontsize',12); BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General'); 
saveas(gcf, fullfile(BB_apical, 'Mean_distance_of_long_&_short_BB_trajectories'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Mean_distance_of_long_&_short_BB_trajectories'), 'tif');

figure(17);
dist_1 = short_traj_duration; dist_2 = long_traj_duration; dist = [dist_1 dist_2];
grp = [zeros(1,length(dist_1)), ones(1,length(dist_2))];
boxplot(dist, grp, 'labels', {'Short trajectories','Long trajectories'}); ylabel('Time [min]');
hold on 
avgs(1,1) = avg_short_traj_duration; avgs(1,2) = avg_long_traj_duration;
plot(avgs, '*k'); title('Mean duration of "long & short" BB trajectories'); set(gca,'fontsize',12); BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General'); 
saveas(gcf, fullfile(BB_apical, 'Mean_duration_of_long_&_short_BB_trajectories'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Mean_duration_of_long_&_short_BB_trajectories'), 'tif');

figure(18);
dist_1 = short_traj_speed; dist_2 = long_traj_speed; dist = [dist_1 dist_2];
grp = [zeros(1,length(dist_1)), ones(1,length(dist_2))];
boxplot(dist, grp, 'labels', {'Short trajectories','Long trajectories'}); ylabel('Speed [\mum/min]');
hold on 
avgs(1,1) = avg_short_traj_speed; avgs(1,2) = avg_long_traj_speed;
plot(avgs, '*k'); title('Mean speed of "long & short" BB trajectories'); set(gca,'fontsize',12); BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General'); 
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
    saveas(gcf, fullfile(montage_fig,'slide_4_2_1'), 'tif');
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
    saveas(gcf, fullfile(montage_fig,'slide_4_2_2'), 'tif');
end

% savelink for the figures
BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General'); 

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
xlabel('Total intensity [a.u]'); ylabel('Counts'); title('Totalintensity surrounding BB in apical domain'); set(gca,'fontsize',12);  
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

%% Plotting area splitup (area occupied by BBs and remaining area)

individual_bb_pos_area = BBtrack(1,9); % getting the area of a single BB
individual_bb_sur_area = BBtrack(1,11); % getting the surrounding area of a single BB
individual_bb_area = individual_bb_pos_area + individual_bb_sur_area; % total area contribution from a single BB

bb_pos_area = No_of_BB * individual_bb_pos_area; % area occupied by all BBs in every frame
bb_pos_area_percent = (bb_pos_area * 100) ./ Area_apicaldomain; % percentage of the area occupied by all BBs in every frame
bb_sur_area = No_of_BB * individual_bb_sur_area; % area ccupied by the surrounding area of all BBs in every frame
bb_sur_area_percent = (bb_sur_area * 100) ./ Area_apicaldomain; % percentage of area ccupied by the surrounding area of all BBs in every frame
bb_area = No_of_BB * individual_bb_pos_area; % total area occupied by all BBs in every frame; if the surrounding donut area needs to be included, then replace 'individual_bb_pos_area' with individual_bb_area
bb_area_percent = (bb_area * 100) ./ Area_apicaldomain; % percentage of total area occupied by all BBs in every frame

Area_apicaldomain_percent = (Area_apicaldomain * 100) ./ max(Area_apicaldomain); % total apical domain area percentage
residual_area = Area_apicaldomain - bb_area; % area that do not contain BBs
residual_area_percent = (residual_area * 100) ./ Area_apicaldomain; % percentage of area that do not contain BBs
sum_of_residual_bb_areas = ((residual_area + bb_area)*100) ./ max(Area_apicaldomain); % getting the sum of area with and without BBs to show that it is same as the actual apical domain area

time = (1 : No_of_timepoints) * Time_interval; % time for plotting

% Absolute area values
figure(1)
plot(time, Area_apicaldomain, 'r.-');
hold on
plot(time, residual_area, 'b.-');
hold on
plot(time, bb_area, 'm.-');
hold off
legend ('Actual area', 'Apical expansion', 'BB', 'location', 'best');
xlabel('Time [min]');  ylabel('Area [\mum^{2}]'); title({'Area expansion - contribution of Apical domain & BBs', '[absolute area value] vs Time'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'area_contribution_vs_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'area_contribution_vs_time'), 'tif');

% Areas in percentage for every timepoint
figure(2)
plot(time, Area_apicaldomain_percent, 'r-', 'LineWidth', 2);
hold on
plot(time, residual_area_percent, 'bo');
hold on
plot(time, bb_area_percent, 'mo');
hold on 
plot(time, sum_of_residual_bb_areas, 'ko');
hold off
legend ('Actual area', 'Apical expansion', 'BB', 'Sum of apical & BB contributions', 'location', 'best'); 
xlabel('Time [min]');  ylabel('Area [%]'); title({'Area expansion - contribution of Apical domain & BBs', '[area percentage] vs Time'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(BB_apical, 'area_contribution_percent_vs_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'area_contribution_percent_vs_time'), 'tif');

close all;

%%

% saving as montage
montage_fig = '../Plots/montage';

fig1 = fullfile(BB_apical, 'Area_&_BB_time_apicaldomain.tif');
fig2 = fullfile(BB_apical, 'Area_&_BB_relation_apicaldomain.tif');
fig21 = fullfile(BB_apical, 'area_contribution_vs_time.tif');
fig22 = fullfile(BB_apical, 'area_contribution_percent_vs_time.tif');
fig333 = fullfile(BB_apical, 'Meanint_&_area_time_apicaldomain.tif');
fig444 = fullfile(BB_apical, 'Totalint_&_area_time_apicaldomain.tif');
fig3 = fullfile(BB_apical, 'Meanint_&_BB_time_apicaldomain.tif');
fig4 = fullfile(BB_apical, 'Totalint_&_BB_time_apicaldomain.tif');
fig411 = fullfile(BB_apical, 'Area_rate_vs_time.tif');
fig412 = fullfile(BB_apical, 'Area_rate_vs_area.tif');
fig413 = fullfile(BB_apical, 'Area_rate_norm_vs_time.tif');
fig414 = fullfile(BB_apical, 'Area_rate_norm_vs_area.tif');

montage({fig1, fig2, fig21, fig22, fig333, fig444, fig3, fig4, fig411, fig412, fig413, fig414});
saveas(gcf, fullfile(montage_fig,'slide_2'), 'tif');

fig13 = fullfile(BB_apical, 'Total_dist_of_all_BB_traject_in_apical domain_time.tif');
fig14 = fullfile(BB_apical, 'Total_duration_of_all_BB_traject_in_apical_domain_time.tif');
fig15 = fullfile(BB_apical, 'Avg_speed_of_all_BB_traject_in_apical_domain_time.tif');
fig131 = fullfile(BB_apical, 'Total_dist_of_all_BB_traject_in_apical domain_area.tif');
fig141 = fullfile(BB_apical, 'Total_duration_of_all_BB_traject_in_apical_domain_area.tif');
fig151 = fullfile(BB_apical, 'Avg_speed_of_all_BB_traject_in_apical_domain_area.tif');
montage({fig13, fig14, fig15, fig131, fig141, fig151});
saveas(gcf, fullfile(montage_fig,'slide_4_1'), 'tif');

fig16 = fullfile(BB_apical, 'Mean_distance_of_long_&_short_BB_trajectories.tif');
fig17 = fullfile(BB_apical, 'Mean_duration_of_long_&_short_BB_trajectories.tif');
fig18 = fullfile(BB_apical, 'Mean_speed_of_long_&_short_BB_trajectories.tif');
montage({fig16, fig17, fig18});
saveas(gcf, fullfile(montage_fig,'slide_4_2_3'), 'tif');

fig5 = fullfile(BB_apical, 'Step_distance_of_BB_trajectories_apicaldomain.tif');
fig55 = fullfile(BB_apical, 'Step_distance_of_BB_trajectories_apicaldomain_histogram.tif');
fig6 = fullfile(BB_apical, 'Instantaneous_speed_of_BBs_apicaldomain.tif');
fig56 = fullfile(BB_apical, 'Instantaneous_speed_of_BBs_apicaldomain_histogram.tif');
montage({fig5, fig55, fig6, fig56});
saveas(gcf, fullfile(montage_fig,'slide_5'), 'tif');

fig7 = fullfile(BB_apical, 'Meanintensity_at_BB_position_in_apical_domain.tif');
fig57 = fullfile(BB_apical, 'Meanintensity_at_BB_position_in_apical_domain_histogram.tif');
fig8 = fullfile(BB_apical, 'Totalintensity_at_BB_position_in_apical_domain.tif');
fig58 = fullfile(BB_apical, 'Totalintensity_at_BB_position_in_apical_domain_histogram.tif');
fig9 = fullfile(BB_apical, 'Meanintensity_surounding_BB_in_apical_domain.tif');
fig59 = fullfile(BB_apical, 'Meanintensity_surounding_BB_in_apical_domain_histogram.tif');
fig10 = fullfile(BB_apical, 'Totalintensity_surounding_BB_in_apical_domain.tif');
fig60 = fullfile(BB_apical, 'Totalintensity_surounding_BB_in_apical_domain_histogram.tif');
montage({fig7, fig57, fig8, fig58, fig9 fig59, fig10, fig60});
saveas(gcf, fullfile(montage_fig,'slide_6'), 'tif');

close all;
 

%% 
%{
% Plotting basalbody intensities in the discretized regions as a proxy for basalbody count (for rectangles)
 
mkdir ../Plots Gradients_bbIntensity
mkdir ../Plots/Gradients_bbIntensity Whole_roi_msmts
mkdir ../Plots/Gradients_bbIntensity/Whole_roi_msmts Apical_domain
mkdir ../Plots/Gradients_bbIntensity/Whole_roi_msmts Full_stack
 
mkdir ../Plots/Gradients_bbIntensity Discretized_roi_msmts 
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts Apical_domain
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Apical_domain Mean_intensity 
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Apical_domain/Mean_intensity Local_discretization
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Apical_domain Total_intensity
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Apical_domain/Total_intensity Local_discretization
 
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts Full_stack
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack Mean_intensity 
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack/Mean_intensity Left-to-right_direction
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack/Mean_intensity Top-bottom_direction
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack/Mean_intensity Local_discretization
 
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack Total_intensity 
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack/Total_intensity Left-to-right_direction
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack/Total_intensity Top-bottom_direction
mkdir ../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack/Total_intensity Local_discretization

% Importing background intensity measurements and cortical measurements
All_bb_background = cell(1, No_of_timepoints);
for i = 1:No_of_timepoints
    
        % Loading the bb_background intensity files
        bb_background = '../data/Background_bb_intensity_ROI_data/Full_Measure/Measure_background_results_t_';
        bb_backgroundsubtraction = strcat(bb_background, sprintf('%01d',i), '.txt');
        bb_backgroundsubtraction = importdata(bb_backgroundsubtraction);
        bb_background_Subtraction = bb_backgroundsubtraction.data;
        bb_background_meanint = bb_background_Subtraction(:,3);
        All_bb_background{1,i} = bb_background_meanint;
        clear bb_backgroundsubtraction;
        clear bb_background_Subtraction; 
end
 
 
% Plotting the intensity gradient for full stack
% Loading data for width
Input.discretized__data_LR = '../data/Gradients_of_bb_intensity/Discretized_ROI_Results/Discretized_ROI_Cell_width/Left-to-right_direction/L-R_Cellwidth_t_';
Discretized__Data_LR = Input.discretized__data_LR;
Input.discretized_data_TB = '../data/Gradients_of_bb_intensity/Discretized_ROI_Results/Discretized_ROI_Cell_width/Top-bottom_direction/T-B_Cellwidth_t_';
Discretized__Data_TB = Input.discretized_data_TB;
 
% Loading data for intensity
Input.discretized_int_LR = '../data/Gradients_of_bb_intensity/Discretized_ROI_Results/Discretized_ROI_Full_Measure/Left-to-right_direction/L-R_Fullmeasure_t_';
Discretized_int_LR = Input.discretized_int_LR;
Input.discretized_int_TB = '../data/Gradients_of_bb_intensity/Discretized_ROI_Results/Discretized_ROI_Full_Measure/Top-bottom_direction/T-B_Fullmeasure_t_';
Discretized_int_TB = Input.discretized_int_TB;
 
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
        
        % Data input for mean intensity 
        % (LR direction)
        Meanintensity_LR = Discretized_Data_LR(:,3);
        Meanintensity_LR = Meanintensity_LR - All_bb_background{1,i}(j,1);
        %Meanintensity_LR = Meanintensity_LR / max(Meanintensity_LR);
        Meanintensity_LR = Meanintensity_LR / cortex_meanint{1,i}(j,1);
        All_Meanintensity_LR{i,j} = Meanintensity_LR;
        % (TB direction)
        Meanintensity_TB = Discretized_Data_TB(:,3);
        Meanintensity_TB = Meanintensity_TB - All_bb_background{1,i}(j,1);
        % Meanintensity_TB = Meanintensity_TB / max(Meanintensity_TB);
        Meanintensity_TB = Meanintensity_TB / cortex_meanint{1,i}(j,1); 
        All_Meanintensity_TB{i,j} = Meanintensity_TB;
        
        % Data input for total intensity
        % (LR direction)
        Totalintensity_LR = Discretized_Data_LR(:,27);
        Totalintensity_LR = Totalintensity_LR - All_bb_background{1,i}(j,1);
        % Totalintensity_LR = Totalintensity_LR / max(Totalintensity_LR);
        Totalintensity_LR = Totalintensity_LR / cortex_totalint{1,i}(j,1); 
        All_Totalintensity_LR{i,j} = Totalintensity_LR;
        % (TB direction)
        Totalintensity_TB = Discretized_Data_TB(:,27);
        Totalintensity_TB = Totalintensity_TB - All_bb_background{1,i}(j,1);
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

max_meanintlist_LR = zeros(No_of_timepoints,No_of_slices); min_meanintlist_LR = zeros(No_of_timepoints,No_of_slices);
max_meanintlist_TB = zeros(No_of_timepoints,No_of_slices); min_meanintlist_TB = zeros(No_of_timepoints,No_of_slices);
max_totalintlist_LR = zeros(No_of_timepoints,No_of_slices); min_totalintlist_LR = zeros(No_of_timepoints,No_of_slices);
max_totalintlist_TB = zeros(No_of_timepoints,No_of_slices); min_totalintlist_TB = zeros(No_of_timepoints,No_of_slices);

for i = 1:No_of_timepoints
    for j = 1:No_of_slices
        
        % Fetching the intensity values corresponding to current timepoint and current slice for plotting
        Meanintensity_LR = All_Meanintensity_LR{i,j}; % Meanintensity (LR direction)
        Meanintensity_TB = All_Meanintensity_TB{i,j}; % Meanintensity (TB direction)
        Totalintensity_LR = All_Totalintensity_LR{i,j}; % Totalintensity (LR direction)
        Totalintensity_TB = All_Totalintensity_TB{i,j}; % Totalintensity (TB direction)
        max_meanintlist_LR(i,j) = max(Meanintensity_LR); min_meanintlist_LR(i,j) = min(Meanintensity_LR); 
        max_meanintlist_TB(i,j) = max(Meanintensity_TB); min_meanintlist_TB(i,j) = min(Meanintensity_TB);
        max_totalintlist_LR(i,j) = max(Totalintensity_TB); min_totalintlist_LR(i,j) = min(Totalintensity_TB);
        max_totalintlist_TB(i,j) = max(Totalintensity_TB); min_totalintlist_TB(i,j) = min(Totalintensity_TB);
               
    end
end

max_meanint_LR = max(max_meanintlist_LR); min_meanint_LR = min(min_meanintlist_LR); 
max_meanint_TB = max(max_meanintlist_TB); min_meanint_TB = min(min_meanintlist_TB);
max_totalint_LR = max(max_totalintlist_LR); min_totalint_LR = min(min_totalintlist_LR);
max_totalint_TB = max(max_totalintlist_TB); min_totalint_TB = min(min_totalintlist_TB);  
 
 
for i = 1:No_of_timepoints
    
    for j = 1:No_of_slices
        
        % Fetching the intensity values corresponding to current timepoint and current slice for plotting
        Meanintensity_LR = All_Meanintensity_LR{i,j}; % Meanintensity (LR direction)
        Meanintensity_TB = All_Meanintensity_TB{i,j}; % Meanintensity (TB direction)
        Totalintensity_LR = All_Totalintensity_LR{i,j}; % Totalintensity (LR direction)
        Totalintensity_TB = All_Totalintensity_TB{i,j}; % Totalintensity (TB direction)
        
        %----------------------------------------------------------------------------------------------------------------------------%
        
        % %Fetching the width values corresponding to current timepoint and current slice for plotting
        
        % %IF THE CELL EXPANDS TOWARDS RIGHT HAND SIDE----    Depending on the cell expansion side, (CHANGE THIS !!)
%         Width_LR = All_Width_LR_values{i,j}; % (LR direction)
%         Width_LR = Width_LR * pixelwidth;
%         Width_TB = All_Width_TB_values{i,j}; % (TB direction)
%         Width_TB = Width_TB * pixelwidth;
%         Width_LRmaxlimit = max(Width_LR)+(10 * pixelwidth); Width_LRminlimit = min(Width_LR);
%         Width_TBmaxlimit = max(Width_TB)+(10 * pixelwidth); Width_TBminlimit = min(Width_TB);
        
        %IF THE CELL EXPANDS TOWARDS LEFT HAND SIDE----, then for adjusting the cell expansion side:       Depending on the cell expansion side, (CHANGE THIS !!)
        %Finding the maximum cell length for the current slice across all time points 
        Width_LR_maxlist = zeros(No_of_timepoints,1);
        Width_TB_maxlist = zeros(No_of_timepoints,1);
        for t = 1:No_of_timepoints
            Width_LR_individual = All_Width_LR_values{t,j};
            Width_LR_maxlist(t) = Width_LR_individual(end);
            Width_TB_individual = All_Width_TB_values{t,j};
            Width_TB_maxlist(t) = Width_TB_individual(end);
        end
        % Adjusting for the expansion side
        % (LR direction)
        Width_LR_max = max(Width_LR_maxlist);
        clear Width_LR_maxlist;
        Width_LR_current = All_Width_LR_values{i,j};
        Width_LR_current_end =  Width_LR_current(end); % Width corresponding to the longest end of the cell for the current slice and current time
        Width_LR_adjust_value = abs(Width_LR_max - Width_LR_current_end);
        Width_LR_adjusted = (Width_LR_current + Width_LR_adjust_value);
        Width_LR_adjusted = max(Width_LR_adjusted) - Width_LR_adjusted;
        Width_LR = Width_LR_adjusted * pixelwidth;
        Width_LRmaxlimit = max(Width_LR)+(10 * pixelwidth); Width_LRminlimit = min(Width_LR);
                
        % (TB direction)
        Width_TB_max = max(Width_TB_maxlist);
        clear Width_TB_maxlist;
        Width_TB_current = All_Width_TB_values{i,j};
        Width_TB_current_end =  Width_TB_current(end); % Width corresponding to the longest end of the cell for the current slice and current time
        Width_TB_adjust_value = abs(Width_TB_max - Width_TB_current_end);
        Width_TB_adjusted = (Width_TB_current + Width_TB_adjust_value);
        Width_TB_adjusted = max(Width_TB_adjusted) - Width_TB_adjusted;
        Width_TB = Width_TB_adjusted * pixelwidth;  
        Width_TBmaxlimit = max(Width_TB)+(10 * pixelwidth); Width_TBminlimit = min(Width_TB);
        % Comment until here IF THE CELL EXPANDS TOWARDS LEFT HAND SIDE----     (CHANGE THIS !!)
%         
%         % IF THE CELL EXPANDS ISOTROPICALLY----, then for adjusting the cell expansion side:       Depending on the cell expansion side, (CHANGE THIS !!)
%         % Finding the midpoint of cell length for the current slice across all time points 
%         Width_LR_medianlist = zeros(No_of_timepoints,1);
%         Width_TB_medianlist = zeros(No_of_timepoints,1);
%         for t = 1:No_of_timepoints
%             Width_LR_individual = All_Width_LR_values{t,j};
%             Width_LR_medianlist(t) = Width_LR_individual(ceil(end/2));
%             Width_TB_individual = All_Width_TB_values{t,j};
%             Width_TB_medianlist(t) = Width_TB_individual(ceil(end/2));
%         end
%         % Adjusting for the expansion side
%         % (LR direction)
%         Width_LR_current = All_Width_LR_values{i,j};
%         Width_LR_current_median =  round(Width_LR_current(ceil(end/2))); % Width corresponding to the median of the cell for the current slice and current time
%         Width_LR_adjusted = Width_LR_current - Width_LR_current_median;
%         Width_LR = Width_LR_adjusted * pixelwidth;
%         Width_LRmaxlimit = max(Width_LR)+(10 * pixelwidth); Width_LRminlimit = min(Width_LR) - (10 * pixelwidth);
%                        
%         % (TB direction)
%         Width_TB_current = All_Width_TB_values{i,j};
%         Width_TB_current_median =  Width_TB_current(ceil(end/2)); % Width corresponding to the median of the cell for the current slice and current time
%         Width_TB_adjusted = Width_TB_current - Width_TB_current_median;
%         Width_TB = Width_TB_adjusted * pixelwidth;
%         Width_TBmaxlimit = max(Width_TB)+(10 * pixelwidth); Width_TBminlimit = min(Width_TB) - (10 * pixelwidth);
%         % Comment until here IF THE CELL EXPANDS ISOTROPICALLY----     (CHANGE THIS !!)
        
        %----------------------------------------------------------------------------------------------------------------------------%
        
        % Height (Z) of the cell from Z stacks
        Zheight = j * zslice_total_thickness; % In micrometers.
        Zheight_LR = Zheight.*ones(size(Meanintensity_LR)); 
        Zheight_TB = Zheight.*ones(size(Meanintensity_TB)); 
        
        % Time
        Timepoint =  i * Time_interval; % In minutes
        Time_3Dplot_LR = Timepoint.*ones(size(Meanintensity_LR));
        Time_3Dplot_TB = Timepoint.*ones(size(Meanintensity_TB));
        
        mymap = [1 0 1
         1 0 1
         0 1 1
         0 1 1
         0 0 0
         0 0 0];
        
%         figure(1); 
%         plot3(Width_LR, Zheight_LR, Meanintensity_LR, 'LineWidth', 0.1); colorbar; %caxis([0 1]);
%         surface([Width_LR(:), Width_LR(:)], [Zheight_LR(:), Zheight_LR(:)], [Meanintensity_LR(:), Meanintensity_LR(:)], [Meanintensity_LR(:), Meanintensity_LR(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 4);
%         colormap viridis;
%         hold on
%                
%         figure(2); 
%         plot3(Zheight_TB, Width_TB, Meanintensity_TB, 'LineWidth', 0.1); colorbar; %caxis([0 1]);
%         surface([Zheight_TB(:), Zheight_TB(:)], [Width_TB(:), Width_TB(:)], [Meanintensity_TB(:), Meanintensity_TB(:)], [Meanintensity_TB(:), Meanintensity_TB(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 4.5);
%         colormap viridis;
%         hold on
%         
%         figure(3); 
%         plot3(Width_LR, Zheight_LR, Totalintensity_LR, 'LineWidth', 0.1); colorbar; %caxis([0 1]);
%         surface([Width_LR(:), Width_LR(:)], [Zheight_LR(:), Zheight_LR(:)], [Totalintensity_LR(:), Totalintensity_LR(:)], [Totalintensity_LR(:), Totalintensity_LR(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 4);
%         colormap viridis;
%         hold on
%         
%         figure(4); 
%         plot3(Zheight_TB, Width_TB, Totalintensity_TB, 'LineWidth', 0.1); colorbar; %caxis([0 1]);
%         surface([Zheight_TB(:), Zheight_TB(:)], [Width_TB(:), Width_TB(:)], [Totalintensity_TB(:), Totalintensity_TB(:)], [Totalintensity_TB(:), Totalintensity_TB(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 4.5);
%         colormap viridis;
%         hold on
        
        % Plotting the intensity gradients only for the apical domain
        
        if j == Ap_slice  
            
            figure(5); 
            plot3(Width_LR, Time_3Dplot_LR, Meanintensity_LR, 'LineWidth', 0.01);
            surface([Width_LR(:), Width_LR(:)], [Time_3Dplot_LR(:), Time_3Dplot_LR(:)], [Meanintensity_LR(:), Meanintensity_LR(:)], [Meanintensity_LR(:), Meanintensity_LR(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 3);
            colormap viridis;
            hold on
            
            figure(6); 
            plot3(Time_3Dplot_TB, Width_TB, Meanintensity_TB, 'LineWidth', 0.01);
            surface([Time_3Dplot_TB(:), Time_3Dplot_TB(:)], [Width_TB(:), Width_TB(:)], [Meanintensity_TB(:), Meanintensity_TB(:)], [Meanintensity_TB(:), Meanintensity_TB(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 3.5);
            colormap viridis;
            hold on
            
%             figure(7); 
%             plot3(Width_LR, Time_3Dplot_LR, Totalintensity_LR, 'LineWidth', 0.01); 
%             surface([Width_LR(:), Width_LR(:)], [Time_3Dplot_LR(:), Time_3Dplot_LR(:)], [Totalintensity_LR(:), Totalintensity_LR(:)], [Totalintensity_LR(:), Totalintensity_LR(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 4);
%             colormap viridis;
%             hold on
%             
%             figure(8); 
%             plot3(Time_3Dplot_TB, Width_TB, Totalintensity_TB, 'LineWidth', 0.01); 
%             surface([Time_3Dplot_TB(:), Time_3Dplot_TB(:)], [Width_TB(:), Width_TB(:)], [Totalintensity_TB(:), Totalintensity_TB(:)], [Totalintensity_TB(:), Totalintensity_TB(:)], 'EdgeColor','interp', 'FaceColor','none','LineWidth', 4.5);
%             colormap viridis;
%             hold on 
            
        end
            
    end
    
%     figure(1); 
%     xlabel('Distance (x) [\mum]');  ylabel(' Height (z) [\mum]'); zlabel('Mean intensity [a.u]'); title('Mean int gradient LR full stack'); set(gca,'fontsize',18);
%     Meanint_LR = '../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack/Mean_intensity/Left-to-right_direction/';
%     Meanint_fig_LR = strcat('Meanint_gradient_LR_fullstack_t_', sprintf('%01d',i)); set(gca, 'Xdir', 'reverse'); view(2);
%     saveas(gcf, fullfile(Meanint_LR, Meanint_fig_LR),'fig'); saveas(gcf, fullfile(Meanint_LR, Meanint_fig_LR),'tif');
%     clf;        
%     
%     figure(2); 
%     xlabel('Height (z) [\mum]');  ylabel('Distance (y) [\mum]'); zlabel('Mean intensity [a.u]'); title('Mean int gradient TB full stack'); set(gca,'fontsize',18);
%     Meanint_TB = '../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack/Mean_intensity/Top-bottom_direction/';
%     Meanint_fig_TB = strcat('Meanint_gradient_TB_fullstack_t_', sprintf('%01d',i)); set(gca, 'Ydir', 'reverse'); view(2);
%     saveas(gcf, fullfile(Meanint_TB, Meanint_fig_TB),'fig'); saveas(gcf, fullfile(Meanint_TB, Meanint_fig_TB),'tif');
%     clf;
%     
%     figure(3); 
%     xlabel('Distance (x) [\mum]');  ylabel(' Height (z) [\mum]'); zlabel('Total intensity [a.u]'); title('Total int gradient LR full stack'); set(gca,'fontsize',18);
%     Totalint_LR = '../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack/Total_intensity/Left-to-right_direction';
%     Totalint_fig_LR = strcat('Totalint_gradient_LR_fullstack_t_', sprintf('%01d',i)); set(gca, 'Xdir', 'reverse'); view(2);
%     saveas(gcf, fullfile(Totalint_LR, Totalint_fig_LR),'fig'); saveas(gcf, fullfile(Totalint_LR, Totalint_fig_LR),'tif');
%     clf;        
%     
%     figure(4); 
%     xlabel('Height (z) [\mum]');  ylabel('Distance (y) [\mum]'); zlabel('Total intensity [a.u]'); title('Total int gradient TB full stack'); set(gca,'fontsize',18);
%     Totalint_TB = '../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack/Total_intensity/Top-bottom_direction';
%     Totalint_fig_TB = strcat('Totalint_gradient_TB_fullstack_t_', sprintf('%01d',i)); set(gca, 'Ydir', 'reverse'); view(2);
%     saveas(gcf, fullfile(Totalint_TB, Totalint_fig_TB),'fig'); saveas(gcf, fullfile(Totalint_TB, Totalint_fig_TB),'tif');
%     clf;
    
end
 
figure(5); 
xlabel('Distance (x) [\mum]');  ylabel('Time [min]'); zlabel('Mean intensity [a.u]'); title('Mean int gradient LR apical domain'); 
set(gca,'fontsize',18); set(gca, 'Xdir', 'reverse'); colorbar; caxis([min_meanint_LR max_meanint_LR]); 
xlim([Width_LRminlimit Width_LRmaxlimit]);  % (CHANGE THIS IF NEEDED !!)
Meanint_LR = '../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Apical_domain/Mean_intensity/';
Meanint_fig_LR = strcat('Meanint_gradient_LR_apicaldomain'); set(gca, 'Xdir', 'reverse'); view(2);
saveas(gcf, fullfile(Meanint_LR, Meanint_fig_LR),'fig'); saveas(gcf, fullfile(Meanint_LR, Meanint_fig_LR),'tif');
        
figure(6); 
xlabel('Time [min]');  ylabel('Distance (y) [\mum]'); zlabel('Mean intensity [a.u]'); title('Mean int gradient TB apical domain'); 
set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse'); colorbar; caxis([min_meanint_TB max_meanint_TB]); 
ylim([Width_TBminlimit Width_TBmaxlimit]);  % (CHANGE THIS IF NEEDED !!)
Meanint_TB = '../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Apical_domain/Mean_intensity/';
Meanint_fig_TB = strcat('Meanint_gradient_TB_apicaldomain'); set(gca, 'Ydir', 'reverse'); view(2);
saveas(gcf, fullfile(Meanint_TB, Meanint_fig_TB),'fig'); saveas(gcf, fullfile(Meanint_TB, Meanint_fig_TB),'tif');
        
% figure(7); 
% xlabel('Distance (x) [\mum]');  ylabel('Time [min]'); zlabel('Total intensity [a.u]'); title('Total int gradient LR apical domain'); 
% set(gca,'fontsize',18); set(gca, 'Xdir', 'reverse'); colorbar; caxis([min_totalint_LR max_totalint_LR]); 
% xlim([Width_LRminlimit Width_LRmaxlimit]);  % (CHANGE THIS IF NEEDED !!)
% Totalint_LR = '../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Apical_domain/Total_intensity/';
% Totalint_fig_LR = strcat('Totalint_gradient_LR_apicaldomain'); set(gca, 'Xdir', 'reverse'); view(2);
% saveas(gcf, fullfile(Totalint_LR, Totalint_fig_LR),'fig'); saveas(gcf, fullfile(Totalint_LR, Totalint_fig_LR),'tif');
%         
% figure(8); 
% xlabel('Time [min]');  ylabel('Distance (y) [\mum]'); zlabel('Total intensity [a.u]'); title('Total int gradient TB apical domain'); 
% set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse'); colorbar; caxis([min_totalint_TB max_totalint_TB]);
% ylim([Width_TBminlimit Width_TBmaxlimit]);  % (CHANGE THIS IF NEEDED !!)
% Totalint_TB = '../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Apical_domain/Total_intensity/';
% Totalint_fig_TB = strcat('Totalint_gradient_TB_apicaldomain'); set(gca, 'Ydir', 'reverse'); view(2);
% saveas(gcf, fullfile(Totalint_TB, Totalint_fig_TB),'fig'); saveas(gcf, fullfile(Totalint_TB, Totalint_fig_TB),'tif');

close all;
 
% saving as montage
montage_fig = '../Plots/montage';

fig5 = fullfile(Meanint_LR, 'Meanint_gradient_LR_apicaldomain.tif');
fig6 = fullfile(Meanint_TB, 'Meanint_gradient_TB_apicaldomain.tif');
montage({fig5, fig6});
saveas(gcf, fullfile(montage_fig,'slide_7_2'), 'tif');

close all;

%}

%% Plotting the local discretization (squares) (only for mean intensity and total intensity)
 
% % Plotting the intensity gradient for full stack
% % Loading data for intensity
% Squares_intensity = '../data/Gradients_of_bb_intensity/Discretized_ROI_Results/Discretized_ROI_Full_Measure/Local_discretization/Square_Fullmeasure_t_';
%  
% for i = 1:No_of_timepoints
%         
%     for j = 1:No_of_slices
%         
%         % Data input for intensity
%         squares_intensity = strcat(Squares_intensity, sprintf('%01d',i), '_slice_', sprintf('%01d',j), '.txt');
%         
%         % Replacing the characters 'Infinity' present in the text file with the number 'zero'.
%         txt=fopen(squares_intensity,'r');
%         X = fread(txt);
%         X = char(X.');
%         Y = strrep(X, 'Infinity', '0');
%         txt=fopen(squares_intensity,'w');
%         fwrite(txt,Y);  
%         
%         squares_Intensity = importdata(squares_intensity);
%         Squares_Intensity = squares_Intensity.data;
%         clear squares_Intensity;
%         
%         % X & Y coordinates
%         Square_x = Squares_Intensity(:,8); % In micrometers. 
%         Square_x = Square_x / pixelwidth; % Dividing by the length of one pixel (in micrometers) converts to pixels i.e., to actual X coordinate of the pixel. This allows scaling of the X coordinates inorder to allow smooth interpolation.
%         Square_y = Squares_Intensity(:,9);  % In micrometers. 
%         Square_y = Square_y / pixelwidth; % Dividing by the length of one pixel (in micrometers) converts to pixels i.e., to actual Y coordinate of the pixel. This allows scaling of the Y coordinates inorder to allow smooth interpolation.
%         maxX = max(Square_x); minX = min(Square_x); 
%         maxY = max(Square_y); minY = min(Square_y); 
%                 
%         % Mean intensity
%         Square_meanint = Squares_Intensity(:,3);
%         Square_meanint = Square_meanint - All_bb_background{1,i}(j,1);
%         %Square_meanint = Square_meanint / max(Square_meanint);    
%         Square_meanint = Square_meanint / cortex_meanint{1,i}(j,1); 
%                                 
%         % Total intensity
%         Square_totint = Squares_Intensity(:,27);
%         Square_totint = Square_totint - All_bb_background{1,i}(j,1);
%         %Square_totint = Square_totint / max(Square_totint);   
%         Square_totint = Square_totint / cortex_totalint{1,i}(j,1); 
%         
%         % Converting vectors to matrix to make a surface plot
%         [Xq, Yq] = meshgrid(minX:maxX, minY:maxY);
%         F_meanint = scatteredInterpolant(Square_x, Square_y, Square_meanint); F_meanint.ExtrapolationMethod = 'none';
%         F_totint = scatteredInterpolant(Square_x, Square_y, Square_totint); F_totint.ExtrapolationMethod = 'none';
%         Vq_meanint = F_meanint(Xq, Yq);
%         Vq_totint = F_totint(Xq, Yq);
%                         
% %         figure(9);
% %         % scatter(Square_x, Square_y, 700, Square_meanint, 'fill'); 
% %         fig9 = surf(Xq, Yq, Vq_meanint); fig9.EdgeColor = 'none'; colormap viridis; colorbar; shading interp; %caxis([0.1 1]); 
% %         xlabel('X coorindate');  ylabel('Y coorindate'); zlabel('Mean intensity [a.u]'); title('Local intensity (mean) full stack');  xlim([0 400]); ylim([50 400]);
% %         set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse'); view(2);
% %         Squareint = '../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack/Mean_intensity/Local_discretization/';
% %         Squareint_fig = strcat('Squareint_fullstack_t_', sprintf('%01d',i),'_slice_',sprintf('%01d',j));
% %         saveas(gcf, fullfile(Squareint, Squareint_fig),'fig'); saveas(gcf, fullfile(Squareint, Squareint_fig),'tif');
% %         
% %         figure(10);
% %         % scatter(Square_x, Square_y, 700, Square_totint, 'fill'); 
% %         fig10 = surf(Xq, Yq, Vq_totint); fig10.EdgeColor = 'none'; colormap viridis; colorbar; shading interp; %caxis([0.1 1]); 
% %         xlabel('X coorindate');  ylabel('Y coorindate'); zlabel('Total intensity [a.u]'); title('Local intensity (total) full stack'); xlim([0 400]); ylim([50 400]);
% %         set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse'); view(2)
% %         Squareint = '../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Full_stack/Total_intensity/Local_discretization/';
% %         Squareint_fig = strcat('Squareint_fullstack_t_', sprintf('%01d',i),'_slice_',sprintf('%01d',j));
% %         saveas(gcf, fullfile(Squareint, Squareint_fig),'fig'); saveas(gcf, fullfile(Squareint, Squareint_fig),'tif');
%         
%         if j == Ap_slice  
%             
%             figure(11);
%             % scatter(Square_x, Square_y, 700, Square_meanint, 'fill'); 
%             fig11 = surf(Xq, Yq, Vq_meanint); fig11.EdgeColor = 'none'; colormap viridis; colorbar; shading interp; %caxis([0.1 1]); 
%             xlabel('X coorindate');  ylabel('Y coorindate'); zlabel('Mean intensity [a.u]'); title('Local intensity (mean) full stack'); xlim([minXlimit maxXlimit]); ylim([minYlimit maxYlimit]);
%             set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse'); view(2)
%             Squareint = '../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Apical_domain/Mean_intensity/Local_discretization/';
%             Squareint_fig = strcat('Squareint_apicaldomain_t_', sprintf('%01d',i),'_slice_',sprintf('%01d',j));
%             saveas(gcf, fullfile(Squareint, Squareint_fig),'fig'); saveas(gcf, fullfile(Squareint, Squareint_fig),'tif');
%             
% %             figure(12);
% %             % scatter(Square_x, Square_y, 700, Square_totint, 'fill'); 
% %             fig12 = surf(Xq, Yq, Vq_totint); fig12.EdgeColor = 'none'; colormap viridis; colorbar; shading interp; %caxis([0.1 1]); 
% %             xlabel('X coorindate');  ylabel('Y coorindate'); zlabel('Total intensity [a.u]'); title('Local intensity (total) full stack'); xlim([0 400]); ylim([50 400]);
% %             set(gca,'fontsize',18); set(gca, 'Ydir', 'reverse'); view(2)
% %             Squareint = '../Plots/Gradients_bbIntensity/Discretized_roi_msmts/Apical_domain/Total_intensity/Local_discretization/';
% %             Squareint_fig = strcat('Squareint_apicaldomain_t_', sprintf('%01d',i),'_slice_',sprintf('%01d',j));
% %             saveas(gcf, fullfile(Squareint, Squareint_fig),'fig'); saveas(gcf, fullfile(Squareint, Squareint_fig),'tif');
%                         
%         end
%                
%         fclose all;
%                              
%     end
%              
% end
%  
% close all;
%%

 
 
 

