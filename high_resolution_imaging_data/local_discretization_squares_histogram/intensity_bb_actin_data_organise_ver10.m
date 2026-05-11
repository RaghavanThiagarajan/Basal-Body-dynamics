
% Raghavan Thiagarajan, 11th May 2021, DanStem, Copenhagen.
% Modified on 21st July 2021, DanStem, Copenhagen.
% This script is run after completing the analysis steps as described in "actin_mesh_analysis_steps_MIP.txt". This script will do the following; (1) normalise all intensity values to cortex; 
% (2) make a table of different values along with experiment name in one of the parent folders of the script; (3) make the following plots: frequencey distribution of
% actin intensity at and in the surrounding position of BBs; and make cumulative Distribution function (CDF) of those intensities. (4) save all the x axis and y axis values of all 
% plots that are generated in the same folder as the script.
% This script is an adaptation/extension of "csv_data_organise_RT". Check this script for more details. This script uses the "outerjoin" function from:
% https://se.mathworks.com/help/matlab/ref/outerjoin.html

clear all;
clc;
close all;
save_location = cd;
% splitting the directory so that some of the folder names can be used for naming some of the files
save_location_split = strsplit(save_location, filesep); 

% Loading the intensity files for cortex
cortex = '../data/Gradients_of_actin_intensity/Cortex_intensity_ROI_data/Full_Measure/Mean_Intensity_t_1.txt';
cortexintensity = importdata(cortex);
cortex_intensity = cortexintensity.data;
cortex_meanintensity = cortex_intensity(:,3);

% fetching and extracting the actin intensity values at the position of bbs
% and in the surrounding region of bbs.
filelocation_bbpos_bbsurr = '../data/Actinint_at&around_basalbody_position/Actin_intensity_at_&_around_BB_position.csv';
ds_bbpos_bbsurr = tabularTextDatastore(filelocation_bbpos_bbsurr); % ds = tabularTextDatastore(filelocation,'FileExtensions','.txt');
% Selecting those variable columns that are to be plotted.
ds_bbpos_bbsurr.SelectedVariableNames = {'MeanInt_BBposition', 'MeanInt_BBsurround'};
bbpos_bbsurr_values = readall(ds_bbpos_bbsurr);
Meanint_BBposition = bbpos_bbsurr_values.MeanInt_BBposition / cortex_meanintensity; % normalising with cortex intensity
bbpos_bbsurr_values.Meanint_BBposition_normalised = Meanint_BBposition; % appending to the existing table "bbpos_bbsurr_values"
avg_Meanint_BBposition_norm = mean(Meanint_BBposition, 'omitnan'); % average of the vector "Meanint_BBposition"
Meanint_BBsurround = bbpos_bbsurr_values.MeanInt_BBsurround / cortex_meanintensity; % normalising with cortex intensity
bbpos_bbsurr_values.Meanint_BBsurround_normalised = Meanint_BBsurround; % appending to the existing table "bbpos_bbsurr_values"
avg_Meanint_BBsurround_norm = mean(Meanint_BBsurround, 'omitnan'); % average of the vector "Meanint_BBsurround"
bbpos_bbsurr_values.no_of_rows = (1:height(bbpos_bbsurr_values))'; % a new column of "row numbers" is added. This column and a similar column in the other
% table below (square_discretizations_values) will act as key variables (check the "outerjoin" link).
avg_Meanint_BBposSurrRatio_norm = mean((Meanint_BBsurround ./ Meanint_BBposition), 'omitnan'); % ratio of the actin intensity at BB position to BB surrounding

% plotting the probability distribution function (PDF)
figure(2);
histogram(Meanint_BBposition, 'Normalization', 'pdf', 'FaceColor', 'g', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;
histogram(Meanint_BBsurround, 'Normalization', 'pdf', 'FaceColor', 'k', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;
legend ('Actin intensity at BB pos', 'Actin intensity at Surrounding pos');
xlabel('Mean actin intensity [a.u]'); ylabel('Probability density'); title('Meanintensity at bb position and surrounding (Freq. Distrib.)'); set(gca,'fontsize',12);
saveas(gcf, fullfile(save_location, 'Meanintensity_at_bb_pos_&_surr_FreqDist'), 'fig'); saveas(gcf, fullfile(save_location, 'Meanintensity_at_bb_pos_&_surr_FreqDist'), 'tif');
%------------------------------------------------------------------------%

% fetching and extracting the actin intensity throughout the cell using
% square discretization
filelocation_sqr_discretization = '../data/Gradients_of_actin_intensity/Discretized_ROI_Results/Discretized_ROI_Full_Measure/Local_discretization/';
ds_square_discretizations = tabularTextDatastore(filelocation_sqr_discretization,'FileExtensions','.txt');
% Selecting those variable columns that are to be plotted.
ds_square_discretizations.SelectedVariableNames = {'Mean'};
square_discretizations_values = readall(ds_square_discretizations);
square_discretizations_values.Properties.VariableNames(1) = {'Mean_int_square_discretizations'};
%square_discretizations_values = renamevars(square_discretizations_values, 'Mean', 'Mean_int_square_discretizations'); % renaming the column "Mean" as "Mean_int_square_discretizations"
Mean_square_discretizations = square_discretizations_values.Mean_int_square_discretizations / cortex_meanintensity; % normalising with cortex intensity
square_discretizations_values.Mean_int_square_discretizations_normalised = Mean_square_discretizations; % appending to the existing table "square_discretizations_values"
square_discretizations_values.no_of_rows = (1:height(square_discretizations_values))'; % a new column of "row numbers" is added. This column and a similar column in the other
% table below (bbpos_bbsurr_values) will act as key variables (check the "outerjoin" link).

figure(3);
histogram(Mean_square_discretizations, 'Normalization', 'pdf', 'FaceColor', 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
xlabel('Mean actin intensity [a.u]'); ylabel('Probability density'); title('Meanintensity of all square discretizations (Freq. Distrib.)'); set(gca,'fontsize',12);
saveas(gcf, fullfile(save_location, 'Meanintensity_of_all_square_discretizations_FreqDist'), 'fig'); saveas(gcf, fullfile(save_location, 'Meanintensity_of_all_square_discretizations_FreqDist'), 'tif');

% Combining the PDFs of full apical domain (square discretization) and BB position and BB surrounding
fig2_axs = get(figure(2), 'CurrentAxes'); fig3_axs = get(figure(3), 'CurrentAxes'); copyobj(allchild(fig2_axs), fig3_axs); % reassigning the figures to new handles and copying the figure objects from one figure to another
% fig2 = figure(2); fig3 = figure(3); copyobj(get(gca(fig2), 'Children'), gca(fig3)); % reassigning the figures to new handles and copying the figure objects from one figure to another
title({'Combined meanintensity distributions', '(square discretizations, bb position and surrounding)'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(save_location, 'Meanintensity_of_combined_FreqDist'), 'fig'); saveas(gcf, fullfile(save_location, 'Meanintensity_of_combined_FreqDist'), 'tif');
clear fig2 fig3 % clearing these figure handles helps in making the workspace file smaller in size
%------------------------------------------------------------------------%

% Calculation of overlap between the full histogram and histograms of actin intensities at BB position and at surrounding regions.
% Here, full histogram refers to the actin intensities across the entire apical domain - this is calculated by discretizing the apical domain with small squares and collecting actin intensities in each of these squares.
% In one of the above sections, we plot the actin intensity histograms at BB position, BB surrounding and full apical domain. However this only gives a visual impression and does not give a value that can quantify the
% overlap between BB position and BB surrounding against full apical domain. We calculate these values in this section. We calculate three indices to calculate the overlap: (1) Range coverage; (2) Binned coverage; 
% (3) Overlap coefficient. In all these cases, 0 means there is no overlap and 1 means, there is perfect overlap. The formulas for each of these parameters can be found in the documents in the Science tid bits folder. 

% (1) Range coverage: This is the fraction of full apical domain values that fall inside the min-max range of the combined BB position abd BB surrounding values. We do this in the following manner: 
% 1. We combine and concatenate the BB position and BB surrounding values - lets call this "combined vector"
% 2. Then we find the min and max of the combined vector
% 3. We check and find the no. of overlap values. that is, no of the full apical domain values that fall  within this min and max values of the combined vector. 
% 4. We divide the no of overlap values by total no of full apical domain  values. This will give the Range coverage index.

% (2) Binned coverage: This is the fraction of bins that contain at least one full apical domain value in addition to the values from the combined vector. In other words, how many of the full apical domain bins are
% overlapping with the values from the combined vector. We need this binned coverage in addition to range coverage because, since range coverage takes into account the min and max values of the combined vector, it is
% sensitive to outliers. However, here in the binned coverage, we split the full apical domain values into bins and ask which of these bins contain values from the combined vector. We do this in the following manner:
% 1. We combine the full apical domain values and the combined vector (We use the combined vector in the previous Range coverage calculation here.) values into one vector - lets call this "global combined vector"
% 2. We get the min and max of this global combined vector.
% 3. We choose the no of bins - this number is decided in a way that, we split the entire range of full apical domain values into small bins and at the same time we make sure we dont create too many bins that the bin size is so small that the probability of finding values from combined vector into these values can be low. 5 might be a good value for the number of bins. 
% 4. We find the bin edges for the global combined vector
% 5. We allocate values from combined vector and full apical domain to the bins.
% 6. Get the total number of values (both from combined vector and full apical domain) that are in the bins and divide this by the total number of values that are in the full apical domain. This will give the Binned coverage index

% (3) Overlap coefficient: This is simply the fraction of the distribution that the two histograms share. We use the bin values allocated from the combined vector and full apical domain here.
% 1. Get the counts per bin for both combined vector and the full apical domain values and then get their probabilites by dividing these counts by the total no of combined vector values and full apical domain values.
% 2. For each of the position in the bins (that contain the probabilites), get the minima, and then get their sum. This will give the overlap coefficient.

bbpossurr_combined = [Meanint_BBposition(:); Meanint_BBsurround(:)]; % getting the combined vector by concatenating BB position and BB surrounding values

% 1. Range Coverage
min_bbpossurcombined = min(bbpossurr_combined); % finding the min of combined vector
max_bbpossurcombined = max(bbpossurr_combined); % finding the max of combined vector
overlap_in_range = (Mean_square_discretizations >= min_bbpossurcombined) & (Mean_square_discretizations <= max_bbpossurcombined); % finding the full apical domain values that are within the range of min and max of the combined vector
RangeCoverageIdx = mean(overlap_in_range); % This is the Range coverage index

% 2. Binned Coverage
global_combined_vector = [bbpossurr_combined(:); Mean_square_discretizations(:)]; % concatenating the combined vector and the full apical domain values
nbins = 5; % choosing 5 as the no of bins over which the values will be split
min_GlobalCombinedVector = min(global_combined_vector); % finding the min of global combined vector
max_GlobalCombinedVector = max(global_combined_vector); % finding the max of global combined vector
binEdges = linspace(min_GlobalCombinedVector, max_GlobalCombinedVector, nbins+1); % getting the bin edges between the min and max of the global combined vector for a total nbins+1
counts_bbpossurCombinedVector = histcounts(bbpossurr_combined, binEdges); % getting the counts within each bin that contain the values from bbpossurr_combined
counts_MeanSquareDiscretizations = histcounts(Mean_square_discretizations, binEdges); % getting the counts within each bin that contain the values from Mean_square_discretizations
bins_with_values_bbpossurCombinedVector = counts_bbpossurCombinedVector > 0; % output is a logical array - this gives '1' for all those bins that contain values from bbpossurCombinedVector
bins_with_values_MeanSquareDiscretizations = counts_MeanSquareDiscretizations > 0; % output is a logical array - this gives '1' for all those bins that contain values from MeanSquareDiscretizations
BinnedCoverageIdx = sum(bins_with_values_bbpossurCombinedVector & bins_with_values_MeanSquareDiscretizations) / sum(bins_with_values_MeanSquareDiscretizations); % This is the binned coverage index

% 3. Overlap Coefficient
p_bbpossurCombinedVector = counts_bbpossurCombinedVector / sum(counts_bbpossurCombinedVector); % probability of bbpossurCombinedVector in each bin
p_MeanSquareDiscretizations = counts_MeanSquareDiscretizations / sum(counts_MeanSquareDiscretizations); % probability of MeanSquareDiscretizations in each bin
OverlapCoefficient = sum(min(p_bbpossurCombinedVector, p_MeanSquareDiscretizations)); % This is the overlap coefficient

%------------------------------------------------------------------------%
% plotting the cumulative distribution function (CDF)
figure(4);
bb1 = cdfplot(Meanint_BBposition); set(bb1, 'LineStyle', '-', 'Color', 'g');
hold on
surr1 = cdfplot(Meanint_BBsurround); set(surr1, 'LineStyle', '-', 'Color', 'k');
legend ('Actin intensity at BB pos', 'Actin intensity at Surrounding pos');
hold on

% Below we are getting the quarter, half and three-quarter values of the y axis of CDF plot and the corresponding x axis values. These values will correspond to 0.25, 
% 0.5 and 0.75 in the y axis since the  maximum of CDF y-axis is 1. Then we will get the corresponding x values. We do this for the following reason: in our CDF plot, 
% the x axis are the intensity values and the y axis is the CDF probability. The plot that is on the more right hand side is the plot that has higher intensity values. 
% So here we compare the Meanint_BBposition and the Meanint_BBsurround values for the 0.25, 0.5 and 0.75 values of the y axis. Below we are getting all these values.

[val_bb_25, idx_bb_25] = min(abs(bb1.YData - 0.25)); % getting the index of the value closest to 0.25 in y axis of CDF plot of Meanint_BBposition
mean_int_bb_25 = bb1.XData(idx_bb_25); % using the index obtained in the previous line to get the corresponding x axis value i.e. the corresponding value in Meanint_BBposition
[val_surr_25, idx_surr_25] = min(abs(surr1.YData - 0.25)); % same as above for Meanint_BBsurround
mean_int_surr_25 = surr1.XData(idx_bb_25); % % same as above for Meanint_BBsurround

[val_bb_50, idx_bb_50] = min(abs(bb1.YData - 0.50)); % getting the index of the value closest to 0.50 in y axis of CDF plot of Meanint_BBposition
mean_int_bb_50 = bb1.XData(idx_bb_50); % using the index obtained in the previous line to get the corresponding x axis value i.e. the corresponding value in Meanint_BBposition
[val_surr_50, idx_surr_50] = min(abs(surr1.YData - 0.50)); % same as above for Meanint_BBsurround
mean_int_surr_50 = surr1.XData(idx_bb_50); % same as above for Meanint_BBsurround

[val_bb_75, idx_bb_75] = min(abs(bb1.YData - 0.75)); % getting the index of the value closest to 0.75 in y axis of CDF plot of Meanint_BBposition
mean_int_bb_75 = bb1.XData(idx_bb_75); % using the index obtained in the previous line to get the corresponding x axis value i.e. the corresponding value in Meanint_BBposition
[val_surr_75, idx_surr_75] = min(abs(surr1.YData - 0.75)); % same as above for Meanint_BBsurround
mean_int_surr_75 = surr1.XData(idx_bb_75); % same as above for Meanint_BBsurround

% plotting the significant points i.e. 0.25, 0.5 and 0.75 in the same plot as in figure (4) i.e. along with the CDF plot.
sig_points_x = [bb1.XData(idx_bb_25), bb1.XData(idx_bb_50), bb1.XData(idx_bb_75) ,surr1.XData(idx_surr_25), ...
    surr1.XData(idx_surr_50), surr1.XData(idx_surr_75)]; % storing the x values of the significant points to make the plotting easy.
sig_points_y = [bb1.YData(idx_bb_25), bb1.YData(idx_bb_50), bb1.YData(idx_bb_75) ,surr1.YData(idx_surr_25), ...
    surr1.YData(idx_surr_50), surr1.YData(idx_surr_75)]; % storing the y values of the significant points to make the plotting easy.
plot(sig_points_x, sig_points_y, 'm*'); 

% saving figure (4)
xlabel('Mean actin intensity [a.u]'); ylabel('F(x)'); title('Meanintensity at bb position and surrounding (CDF)'); set(gca,'fontsize',12);
saveas(gcf, fullfile(save_location, 'Meanintensity_at_bb_pos_&_surr_CDF'), 'fig'); saveas(gcf, fullfile(save_location, 'Meanintensity_at_bb_pos_&_surr_CDF'), 'tif');

% Saving the Xdata and YData of the CDF plots to table
cdf_data_1 = array2table([bb1.XData', bb1.YData'], 'VariableNames', {'CDF_xaxis_intensity_BBpos', 'CDF_yaxis_F_x_BBpos'});
cdf_data_2 = array2table([surr1.XData', surr1.YData'], 'VariableNames',{'CDF_xaxis_intensity_BBsurr', 'CDF_yaxis_F_x_BBsurr'});
% In the next two lines below a new column of "row numbers" is added to both tables. These two columns will act as key variables (check the "outerjoin" link) for joining those tables.
cdf_data_1.no_of_rows = (1:height(cdf_data_1))'; 
cdf_data_2.no_of_rows = (1:height(cdf_data_2))'; 
cdf_data = outerjoin(cdf_data_1, cdf_data_2); % performing outerjoin
cdf_data.no_of_rows_cdf_data_1 = []; cdf_data.no_of_rows_cdf_data_2 = []; % deleting those columns that were used as key variables (in order to perform outerjoin)
cdf_data.no_of_rows = (1:height(cdf_data))'; % Creating a new column of "row numbers" again inorder to perform with outerjoin with the table below.
%------------------------------------------------------------------------%

% Outerjoin allows merging of two tables with different dimensions.
parameters_1 = outerjoin(bbpos_bbsurr_values, square_discretizations_values);
parameters_1.no_of_rows = (1:height(parameters_1))'; % a new column of "row numbers" is added. This column and a similar column in the other
% table (cdf_data) will act as key variables (check the "outerjoin" link).
all_parameters = outerjoin(parameters_1, cdf_data);
% deleting all the key variables columns which were created to perform outerjoin i.e. to combine tables of different lengths; all these key variable columns start with "no_of_rows.."
% and their column numbers or column indices are : 5, 8, 9, 14. These column indices are used to delete the columns in the line below.
all_parameters(:, [5,8,9,14]) = [];

writetable(all_parameters, 'all_msmts.csv'); % saving the final table file.
%------------------------------------------------------------------------%

% We want to make one master .csv file that has the following parameters for all the experiments (actin mesh images from fixed embryos):
% "Filename", "Measured Area", "No of BBs", "mean intensity of actin at the position of all BB s (averaged over area of all BB s) with and without normalisation (by cortex)",
% "mean intensity of actin in the area outside the BB s (averaged over area outside all BB s) with and without normalisation (by cortex)",
% "mean intensity of actin in the apical area with and without normalisation (by cortex)", "cortex mean intensity", "intensity values from the x axis of CDF plot for the y axis CDF 
% probabilities of 0.25, 0.5 and 0.75 (check below for more details)".
% Howevever directly appending a data to an existing .csv file seems to be complicated with Matlab 2017b. Therefore here we create one .csv file for
% every experiment with the parameters mentioned above ad then at the end of analysis, and we manually copy/paste it to the master .csv file.

% getting the file name
file_location = '../../rawdata/';
filename = dir(fullfile(file_location,'*.czi')); % now "h" is a structure component that has the following fields: "name"; "folder"; "date". One can get these items separately.
rawfilename = filename.name;

% getting the "measured area"
file_location = '../data/Gradients_of_actin_intensity/Whole_ROI_Measure/whole_roi_measure_t1.txt';
area_value_data = importdata(file_location);
area_value_data = area_value_data.data;
area_value = area_value_data(:,2);
area_meanInt_value = area_value_data(:,3);
area_meanInt_value_norm = area_meanInt_value / cortex_meanintensity;
clear area_value_data;

% getting the no of BBs
file_location = '../data/Actinint_at&around_basalbody_position/Actin_intensity_at_&_around_BB_position.csv';
No_of_BB_value_data = importdata(file_location);
No_of_BB_value_data = No_of_BB_value_data.data;
No_of_BB_value = No_of_BB_value_data(end,1);
clear No_of_BB_value_data;

% getting the mean intensity of actin at all the positions of BBs and in all the area outside the BBs.
file_location = '../data/Actinint_at&around_basalbody_position/BB_&_outside_BB_msmts.csv';
importing_values_data = importdata(file_location);
importing_values_data = importing_values_data.data;
meanInt_outside_BBs = importing_values_data(1,2);
meanInt_outside_BBs_norm = meanInt_outside_BBs / cortex_meanintensity;
meanInt_at_all_BBs = importing_values_data(2,2);
meanInt_at_all_BBs_norm = meanInt_at_all_BBs / cortex_meanintensity;
clear importing_values_data;

% loading all these values to cell array to be stored as table later.
temp_cell = cell(1,22);
temp_cell{1,1} = rawfilename;
temp_cell{1,2} = area_value;
temp_cell{1,3} = No_of_BB_value;
temp_cell{1,4} = meanInt_at_all_BBs;
temp_cell{1,5} = meanInt_at_all_BBs_norm;
temp_cell{1,6} = meanInt_outside_BBs;
temp_cell{1,7} = meanInt_outside_BBs_norm;
temp_cell{1,8} = area_meanInt_value;
temp_cell{1,9} = area_meanInt_value_norm;
temp_cell{1,10} = cortex_meanintensity;
temp_cell{1,11} = mean_int_bb_25;
temp_cell{1,12} = mean_int_surr_25;
temp_cell{1,13} = mean_int_bb_50;
temp_cell{1,14} = mean_int_surr_50;
temp_cell{1,15} = mean_int_bb_75;
temp_cell{1,16} = mean_int_surr_75;
temp_cell{1,17} = RangeCoverageIdx;
temp_cell{1,18} = BinnedCoverageIdx;
temp_cell{1,19} = OverlapCoefficient;
temp_cell{1,20} = avg_Meanint_BBposition_norm;
temp_cell{1,21} = avg_Meanint_BBsurround_norm;
temp_cell{1,22} = avg_Meanint_BBposSurrRatio_norm;

varnames = {'File_name', 'Measured_area_micrometersquared', 'No_of_BBs' , 'mean_actin_int_at_the_pos_of_all_BBs', ...
    'cortex_normalized_mean_actin_int_at_the_pos_of_all_BBs', 'mean_actin_int_outside_the_area_of_all_BBs', ...
    'cortex_normalized_mean_actin_int_outside_the_area_of_all_BBs', 'apical_area_actin_mean_intensity', ...
    'cortex_normalized_apical_area_actin_mean_intensity', 'cortex_meanintensity', ...
    'BB_int_at_CDF_25', 'Surr_int_at_CDF_25', 'BB_int_at_CDF_5', 'Surr_int_at_CDF_5', ...
    'BB_int_at_CDF_75', 'Surr_int_at_CDF_75', 'Range_Coverage_Index', 'Binned_Coverage_Idx', 'Overlap_Coefficient',...
    'avg_Meanint_BBposition_norm', 'avg_Meanint_BBsurround_norm', 'avg_Meanint_BBposSurrRatio_norm'};

% making a table out of cell array and saving this table in order to append
% it later to the main results file.
file_location = '../../';
cd(file_location);
currentable = cell2table(temp_cell, 'VariableNames', varnames);
writetable(currentable, 'results.csv');

% saving the results file and the plots in the common folder to collect all results in file in one location.
file_location = '../../../all_plots_data/data/';
finalname_0 = strcat('a', num2str(ceil(area_value)),'_', save_location_split{8}, '_', save_location_split{9},'_results');
finalname_0 = fullfile(file_location, finalname_0);
finalname_1 = [finalname_0 '.csv'];
% If file already exists with the same area value then append incremental suffix
[finalname] = filename_with_suffix(finalname_0, finalname_1);
writetable(currentable, finalname);

figure(2);
file_location = '../../../all_plots_data/histograms/';
finalname_0 = strcat('a', num2str(ceil(area_value)), '_', save_location_split{8}, '_', save_location_split{9});
finalname_0 = fullfile(file_location, finalname_0);
finalname_1 = [finalname_0 '.tif'];
% If file already exists with the same area value then append incremental suffix
[finalname] = filename_with_suffix(finalname_0, finalname_1);
saveas(gcf, finalname);

figure(4);
file_location = '../../../all_plots_data/cdf_plots/';
finalname_0 = strcat('a', num2str(ceil(area_value)), '_', save_location_split{8}, '_', save_location_split{9});
finalname_0 = fullfile(file_location, finalname_0);
finalname_1 = [finalname_0 '.tif'];
% If file already exists with the same area value then append incremental suffix
[finalname] = filename_with_suffix(finalname_0, finalname_1);
saveas(gcf, finalname);

%------------------------------------------------------------------------%

% saving workspace
cd(save_location);
save('full_workspace');
close all;

disp('finished !');

%% Function to increment the filename with a suffix if files with same names already exist.
% For example if there is a file a124_mo_airyscan_results.csv already exists, then a second file with the same name will overwrite the previous file instead of including a ne second file. This function, instead will add a suffix
% and keep the second file like this: a124_mo_airyscan_results_1.csv. This way, the suffix will keep increasing as 1,2,3... and all files will be saved.
function [finalname] = filename_with_suffix(finalname_0, finalname_1)
count = 1;
while isfile(finalname_1)
    if contains(finalname_1, '.csv')
        finalname_1 = sprintf('%s_%d.csv', finalname_0, count);
    elseif contains(finalname_1, '.tif')
        finalname_1 = sprintf('%s_%d.tif', finalname_0, count);
    end
    count = count + 1;
end
finalname = finalname_1;
end































