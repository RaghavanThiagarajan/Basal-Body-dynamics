% Raghavan Thiagarajan, 17th April 2021, DanStem, Copenhagen

% This script imports all the data related to the actin intensity measurements from the high resolution imaging experiments and plots them in different formats.

clear all;
close all;
clc;

% making directory for saving the plots
data_folder = uigetdir(pwd, 'Select the folder that contains the list of all .csv files');%% select "Result_Data" folder
cd(data_folder);
plots_folder = mkdir (fullfile(data_folder, '..', 'plots')); % making a folder for saving the plots
plot_save_link = fullfile(data_folder, '..', 'plots'); % creating the link for saving the plots

%% concatenating all individual .csv files into one master .csv file
% The measurements (BB count, actin intensity at the position of BBs, actin intensity outside the BBs (i.e. all outside area - not just donuts), CDFs (25, 50, 75) of actin intensity at the position of BBs, CDFs (25, 50, 75) of actin intensity in the surrounding positinos of BBs i.e. Donuts etc)
% are saved as individual .csv file for every cell. So, first we import all the .csv files (of all cells) in the chosen folder and concatenate them one after another into a single .csv file. This is done using tabularTextDatastore. 
% https://se.mathworks.com/matlabcentral/answers/362333-how-to-import-multiple-csv-files-into-one-and-read-it-from-certain-folder
% https://se.mathworks.com/help/matlab/ref/matlab.io.datastore.tabulartextdatastore.html
% https://se.mathworks.com/help/matlab/import_export/read-and-analyze-data-in-a-tabulartextdatastore.html

filelocation = './';
delete('all_msmts.csv'); % deleting the master 'all_msmts.csv' file in case it exists; Because, if the master 'all_msmts.csv' file exists and we make a new master 'all_msmts.csv', since the existing master 'all_msmts.csv' is also a .csv file, the data in this master 'all_msmts.csv' will also be included in the new master .csv file
ds = tabularTextDatastore(filelocation,'FileExtensions','.csv');
parameters = readall(ds); % this will be the master table with all the data
writetable(parameters, 'all_msmts.csv'); % we save the master table as concatenated master .csv file

%% Import the data from the master .csv file and start plotting
% extracting the data from the master table; we extract only those columns (column2:columnEnd) since they contain the numeric data; the first column has text / string data
master_data = table2array(parameters(:, 2:end)); 
% getting all the data one-by-one
area = master_data(:,1); % area
bbcount = master_data(:,2); % BB count
actinInt_wholeapical_area_norm = master_data(:,8); % mean intensity (cortex normalised) of actin of the whole apical area
actinInt_atBBpos_norm = master_data(:,4); % collective mean intensity (cortex normalised) of actin at the position of all BBs (meaning, in the Fiji script, all BB ROIs were combined using XOR and the mean intensity of actin under all these BB ROIs were obtained as one value - unlike the CDFs which were obtained from individual BB ROI based values)
actinInt_ExcludingBB_norm = master_data(:,6); % collective mean intensity (cortex normalised) of actin from the whole apical area except the BB positions (meaning, in the Fiji script, the whole apical area ROI excluding the BB ROIs was used to get the mean intensity of actin as one value - this is different from the CDFs of BB surrounding regions (or donuts) which were obtained from individual ROIs that surround the BBs)
actinInt_BBPosExclBB_ratio = actinInt_ExcludingBB_norm ./ actinInt_atBBpos_norm; % Ratio of actin intensity between the BB surrounding region and at the position of BBs
% Below are the values at the 25%, 50% & 75% from the CDF plots obtained from two kind of actin intensities (already normalised to cortex intensity): 'at BB position' & 'in the surrounding region of the BB i.e. donut'
CDF25_BBpos = master_data(:,10); % value at 25% in the CDF plot of actin intensity at BB position
CDF25_BBSurr = master_data(:,11); % value at 25% in the CDF plot of actin intensity in the surrounding region of BBs i.e. donuts
CDF25_BBposSur_ratio = CDF25_BBSurr ./ CDF25_BBpos; % ratio 
CDF50_BBpos = master_data(:,12); % value at 50% in the CDF plot of actin intensity at BB position
CDF50_BBSurr = master_data(:,13); % value at 50% in the CDF plot of actin intensity in the surrounding region of BBs i.e. donuts
CDF50_BBposSur_ratio = CDF50_BBSurr ./ CDF50_BBpos; % ratio
CDF75_BBpos = master_data(:,14); % value at 75% in the CDF plot of actin intensity at BB position
CDF75_BBSurr = master_data(:,15); % value at 75% in the CDF plot of actin intensity in the surrounding region of BBs i.e. donuts
CDF75_BBposSur_ratio = CDF75_BBSurr ./ CDF75_BBpos; % ratio
range_coverage_idx = master_data(:,16); % index quantifying the overlap between the full apical domain histogram and the histograms of BB positions and BB surrounding - sensitive to outliers (for further details, check the script 'intensity_bb_actin_data_organise_ver06.m' in the folder: local_discretization_squares_histogram)
binned_coverage_idx = master_data(:,17); % index quantifying the overlap between the full apical domain histogram and the histograms of BB positions and BB surrounding - compensated for extreme outliers (for further details, check the script 'intensity_bb_actin_data_organise_ver06.m' in the folder: local_discretization_squares_histogram)
overlap_coefficient = master_data(:,18); % index quantifying the overlap between the full apical domain histogram and the histograms of BB positions and BB surrounding - based on probabilites (for further details, check the script 'intensity_bb_actin_data_organise_ver06.m' in the folder: local_discretization_squares_histogram)
avg_actinInt_BBpos_norm = master_data(:,19); % averaged actin intensity (normalised) of the BB position; this is obtained by collecting  the intensities of actin at BB position of all BBs in a apical domain and by taking the average of these intensities; this is a bit different from "actinInt_atBBpos_norm" where the ROI itself includes all the BBs (i.e. BB position) and then imageJ already collects the average instead of performing the average after collecting from multiple BB ROIs. But these values will be more or less the same.
avg_actinInt_BBSurr_norm = master_data(:,20); % averaged actin intensity (normalised) surrounding the BB; this is obtained by collecting  the intensities of actin in the surrounding regions of all BBs in a apical domain and by taking the average of these intensities; this is different from "actinInt_ExcludingBB_norm" where all the areas other than BBs are used for getting the averaged intensity. Whereas here, only the immediate surrounding regions i.e. donuts are included.
avg_actinInt_BBPosSurr_norm = master_data(:,21); % average of the ratio of "avg_actinInt_BBSurr_norm" / "avg_actinInt_BBpos_norm".

%% initial inputs for plotting

% inputing the operation type for setting the area and time threshold
operation_type = 1;
[minimum_area_threshold, max_threshold_area, max_threshold_time] = operation_type_value(operation_type);

% Breakpoints for different parameters for both control & MO
% defining the breakpoint area value based on which the bins are split - this value is decided based on the piecewise linear fit plot & its results
% the following values are obtained from the 'Piecewise_fit_summary.txt' file under the breakpoint_plots folder - these values are different depending on whether it is control or MO
if contains(plot_save_link, 'ctrl') % control condition
    % this value "may" change depending on the CDF percentage i.e. 25 % ,50 % or 75 %; So change accordingly for each of the CDFs if required
    bin_breakpoint_avgdactinInt_BBpos = 160; 
    bin_breakpoint_avgdactinInt_BBsur = 159;
    bin_breakpoint_avgdactinInt_BBpossurRatio = 178; 
    bin_breakpoint_wholeAreaActin_int = 118;
    bin_breakpoint_collective_int = 173;
    bin_breakpoint_25 = 180;
    bin_breakpoint_50 = 186;
    bin_breakpoint_75 = 170;   
elseif contains(plot_save_link, 'mo') % MO condition
    % this value "may" change depending on the CDF percentage i.e. 25 % ,50 % or 75 %; So change accordingly for each of the CDFs if required
    % For statistics, the same breakpoint point values used for control are also used to check how the MO data compares to control
    bin_breakpoint_avgdactinInt_BBpos = 160;
    bin_breakpoint_avgdactinInt_BBsur = 159;
    bin_breakpoint_avgdactinInt_BBpossurRatio = 178;
    bin_breakpoint_wholeAreaActin_int = 118;
    bin_breakpoint_collective_int = 173;
    bin_breakpoint_25 = 180;
    bin_breakpoint_50 = 186;
    bin_breakpoint_75 = 170;   
end

%% Plotting

% Averaged actin intensity at the position of BBs vs area
% This averaged actin intensity (normalised) of the BB position is obtained by collecting  the intensities of actin at BB position of all BBs in a apical domain and by taking the average of these intensities; this is a bit different from "actinInt_atBBpos_norm" where the ROI itself includes all the BBs (i.e. BB position) and then imageJ already collects the average instead of performing the average after collecting from multiple BB ROIs. But these values will be more or less the same.
area_data = area; time_data = []; new_parameter = avg_actinInt_BBpos_norm; XData = []; bininterval_for_Binparameter = 50; bininterval_string = 50; % modify bininterval if needed
xLabel = 'Area [\mum^2]'; yLabel = 'Actin intensity at BB pos (normalised)'; plot_Title = {'Averaged actin intensity across apical domain', 'at the position of BBs (normalised)'}; save_title = 'avgActinIntBBpos_vs_area'; 
[binned_xy, XData, YData] = avg_plot_prep(area_data, time_data, new_parameter, XData, bininterval_for_Binparameter, bininterval_string, save_title, xLabel, yLabel, plot_Title, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, plot_save_link);
% storing for future use
AvgActinInt_BBpos_x = XData; AvgActinInt_BBpos_y = YData; binXY_AvgActinInt_BBpos = binned_xy; 
clear area_data time_data new_parameter XData par_dat binned_xy YData

%%
% plotting the histograms for different bins of averaged actin intensity at BB pos
% getting the avgd actin intensity at BB pos (this allows us to see how the distribution of the intensity look like in the different bins)
bin_breakpoint_idx_below = AvgActinInt_BBpos_x <= bin_breakpoint_avgdactinInt_BBpos; % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = AvgActinInt_BBpos_x > bin_breakpoint_avgdactinInt_BBpos; % getting all the indices above the bin_breakpoint value
binXY_avgdactinIntBBpos_mat_bin1 = AvgActinInt_BBpos_y(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_collective_actin_intensity(1:3,2)'); % each row in binXY_collective_actin_intensity corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 50 µm2; So 1:3 corresponds to 3 bins between 50 - 150 µm2.
binXY_avgdactinIntBBpos_mat_bin2 = AvgActinInt_BBpos_y(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_collective_actin_intensity(4:end,2)'); % each row in binXY_collective_actin_intensity corresponds to one bin; The bin width (or bin interval) is 50 µm2; So 4:end corresponds to all the bins between 150 - 350 µm2.
parameter_1 = binXY_avgdactinIntBBpos_mat_bin1; bininterval_1 = 0.1; 
parameter_2 = binXY_avgdactinIntBBpos_mat_bin2; bininterval_2 = 0.1; 
XLabel = 'Actin Int at BB pos'; TiTle = {'Averaged actin intensity across apical domain', 'at the position of BBs (normalised)'}; save_title = 'avgActinIntBBpos'; 
[avgdActIntBBpos_bins_AvgTraj] = hist_plots_for_bins(bin_breakpoint_avgdactinInt_BBpos, parameter_1, bininterval_1, parameter_2, bininterval_2, XLabel, TiTle, save_title, plot_save_link);
cdf_distr_plots(bin_breakpoint_avgdactinInt_BBpos, parameter_1, parameter_2, XLabel, TiTle, save_title, plot_save_link);
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

%% Averaged actin intensity in the surrounding BB position vs area
% This averaged actin intensity (normalised) from the surrounding BB position; this is obtained by collecting  the intensities of actin in the surrounding regions of all BBs in a apical domain and by taking the average of these intensities; this is different from "actinInt_ExcludingBB_norm" where all the areas other than BBs are used for getting the averaged intensity. Whereas here, only the immediate surrounding regions i.e. donuts are included.
area_data = area; time_data = []; new_parameter = avg_actinInt_BBSurr_norm; XData = []; bininterval_for_Binparameter = 50; bininterval_string = 50; % modify bininterval if needed
xLabel = 'Area [\mum^2]'; yLabel = 'Actin intensity surrounding BB (normalised)'; plot_Title = {'Averaged actin intensity across apical domain', 'surrounding the BBs (normalised)'}; save_title = 'avgActinIntBBsur_vs_area'; 
[binned_xy, XData, YData] = avg_plot_prep(area_data, time_data, new_parameter, XData, bininterval_for_Binparameter, bininterval_string, save_title, xLabel, yLabel, plot_Title, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, plot_save_link);
% storing for future use
AvgActinInt_BBsur_x = XData; AvgActinInt_BBsur_y = YData; binXY_AvgActinInt_BBsur = binned_xy; 
clear area_data time_data new_parameter XData par_dat binned_xy YData

%%
% plotting the histograms for different bins of averaged actin intensity surrounding BBs
% getting the avgd actin intensity surrounding the BBS (this allows us to see how the distribution of the intensity look like in the different bins)
bin_breakpoint_idx_below = AvgActinInt_BBsur_x <= bin_breakpoint_avgdactinInt_BBsur; % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = AvgActinInt_BBsur_x > bin_breakpoint_avgdactinInt_BBsur; % getting all the indices above the bin_breakpoint value
binXY_avgdactinIntBBsur_mat_bin1 = AvgActinInt_BBsur_y(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_collective_actin_intensity(1:3,2)'); % each row in binXY_collective_actin_intensity corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 50 µm2; So 1:3 corresponds to 3 bins between 50 - 150 µm2.
binXY_avgdactinIntBBsur_mat_bin2 = AvgActinInt_BBsur_y(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_collective_actin_intensity(4:end,2)'); % each row in binXY_collective_actin_intensity corresponds to one bin; The bin width (or bin interval) is 50 µm2; So 4:end corresponds to all the bins between 150 - 350 µm2.
parameter_1 = binXY_avgdactinIntBBsur_mat_bin1; bininterval_1 = 0.1; 
parameter_2 = binXY_avgdactinIntBBsur_mat_bin2; bininterval_2 = 0.1; 
XLabel = 'Actin Int surrounding BBs'; TiTle = {'Averaged actin intensity across apical domain', 'surrounding BBs (normalised)'}; save_title = 'avgActinIntBBsur'; 
[avgdActIntBBsur_bins_AvgTraj] = hist_plots_for_bins(bin_breakpoint_avgdactinInt_BBsur, parameter_1, bininterval_1, parameter_2, bininterval_2, XLabel, TiTle, save_title, plot_save_link);
cdf_distr_plots(bin_breakpoint_avgdactinInt_BBsur, parameter_1, parameter_2, XLabel, TiTle, save_title, plot_save_link);
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

%% Ratio of Averaged actin intensity in the surrounding to the actin intensity at the BB position vs area
% average of the ratio of "avg_actinInt_BBSurr_norm" / "avg_actinInt_BBpos_norm".
area_data = area; time_data = []; new_parameter = avg_actinInt_BBPosSurr_norm; XData = []; bininterval_for_Binparameter = 50; bininterval_string = 50; % modify bininterval if needed
xLabel = 'Area [\mum^2]'; yLabel = {'Ratio of actin intensity from surrounding', 'to BB position (normalised)'}; plot_Title = {'Ratio of Averaged actin intensity across apical domain', 'btw surrounding to BB position (normalised)'}; save_title = 'avgActinIntBBpossurRatio_vs_area'; 
[binned_xy, XData, YData] = avg_plot_prep(area_data, time_data, new_parameter, XData, bininterval_for_Binparameter, bininterval_string, save_title, xLabel, yLabel, plot_Title, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, plot_save_link);
% storing for future use
AvgActinInt_BBpossurRatio_x = XData; AvgActinInt_BBpossurRatio_y = YData; binXY_AvgActinInt_BBpossurRatio = binned_xy; 
clear area_data time_data new_parameter XData par_dat binned_xy YData

%%
% plotting the histograms for different bins of Ratio of averaged actin intensity btw surrounding to BB pos
% getting the ratio of avgd actin intensity btw surrounding and BB pos (this allows us to see how the distribution of the intensity look like in the different bins)
bin_breakpoint_idx_below = AvgActinInt_BBpossurRatio_x <= bin_breakpoint_avgdactinInt_BBpossurRatio; % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = AvgActinInt_BBpossurRatio_x > bin_breakpoint_avgdactinInt_BBpossurRatio; % getting all the indices above the bin_breakpoint value
binXY_avgdactinIntBBpossurRatio_mat_bin1 = AvgActinInt_BBpossurRatio_y(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_collective_actin_intensity(1:3,2)'); % each row in binXY_collective_actin_intensity corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 50 µm2; So 1:3 corresponds to 3 bins between 50 - 150 µm2.
binXY_avgdactinIntBBpossurRatio_mat_bin2 = AvgActinInt_BBpossurRatio_y(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_collective_actin_intensity(4:end,2)'); % each row in binXY_collective_actin_intensity corresponds to one bin; The bin width (or bin interval) is 50 µm2; So 4:end corresponds to all the bins between 150 - 350 µm2.
parameter_1 = binXY_avgdactinIntBBpossurRatio_mat_bin1; bininterval_1 = 0.1; 
parameter_2 = binXY_avgdactinIntBBpossurRatio_mat_bin2; bininterval_2 = 0.1; 
XLabel = 'Ratio of Actin Int btw surrounding and BB pos'; TiTle = {'Ratio of Averaged actin intensity across apical domain', 'btw surrounding and BB pos (normalised)'}; save_title = 'avgActinIntBBpossurRatio'; 
[avgdActIntBBpossurRatio_bins_AvgTraj] = hist_plots_for_bins(bin_breakpoint_avgdactinInt_BBpossurRatio, parameter_1, bininterval_1, parameter_2, bininterval_2, XLabel, TiTle, save_title, plot_save_link);
cdf_distr_plots(bin_breakpoint_avgdactinInt_BBpossurRatio, parameter_1, parameter_2, XLabel, TiTle, save_title, plot_save_link);
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

%% Whole apical area mean intensity of actin vs area
area_data = area; time_data = []; new_parameter = actinInt_wholeapical_area_norm; XData = []; bininterval_for_Binparameter = 50; bininterval_string = 50; % modify bininterval if needed
xLabel = 'Area [\mum^2]'; yLabel = 'Apical area intensity (normalised)'; plot_Title = {'Actin intensity across whole apical area', '(normalised)'}; save_title = 'apicalAreaInt_vs_area'; 
[binned_xy, XData, YData] = avg_plot_prep(area_data, time_data, new_parameter, XData, bininterval_for_Binparameter, bininterval_string, save_title, xLabel, yLabel, plot_Title, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, plot_save_link);
% storing for future use
apicalArea_actin_intensity_x = XData; apicalArea_actin_intensity_y = YData; binXY_apicalArea_actin_intensity = binned_xy; 
clear area_data time_data new_parameter XData par_dat binned_xy YData

%%
% plotting the histograms for different bins of Whole apical area actin intensity
% getting the whole apical area actin intensity (this allows us to see how the distribution of the intensity look like in the different bins)
bin_breakpoint_idx_below = apicalArea_actin_intensity_x <= bin_breakpoint_wholeAreaActin_int; % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = apicalArea_actin_intensity_x > bin_breakpoint_wholeAreaActin_int; % getting all the indices above the bin_breakpoint value
binXY_ApicalAreaActinIntensity_mat_bin1 = apicalArea_actin_intensity_y(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_collective_actin_intensity(1:3,2)'); % each row in binXY_collective_actin_intensity corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 50 µm2; So 1:3 corresponds to 3 bins between 50 - 150 µm2.
binXY_ApicalAreaActinIntensity_mat_bin2 = apicalArea_actin_intensity_y(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_collective_actin_intensity(4:end,2)'); % each row in binXY_collective_actin_intensity corresponds to one bin; The bin width (or bin interval) is 50 µm2; So 4:end corresponds to all the bins between 150 - 350 µm2.
parameter_1 = binXY_ApicalAreaActinIntensity_mat_bin1; bininterval_1 = 0.1; 
parameter_2 = binXY_ApicalAreaActinIntensity_mat_bin2; bininterval_2 = 0.1; 
XLabel = 'Whole Apical area intensity'; TiTle = {'Actin intensity across whole apical area', '(normalised)'}; save_title = 'apicalAreaActinInt'; 
[apicalAreaActinInt_bins_AvgTraj] = hist_plots_for_bins(bin_breakpoint_wholeAreaActin_int, parameter_1, bininterval_1, parameter_2, bininterval_2, XLabel, TiTle, save_title, plot_save_link);
cdf_distr_plots(bin_breakpoint_wholeAreaActin_int, parameter_1, parameter_2, XLabel, TiTle, save_title, plot_save_link);
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

%% Ratio of collective mean intensity of actin (check the descriptions of 'actinInt_atBBpos_norm' & 'actinInt_ExcludingBB_norm') vs area
area_data = area; time_data = []; new_parameter = actinInt_BBPosExclBB_ratio; XData = []; bininterval_for_Binparameter = 50; bininterval_string = 50; % modify bininterval if needed
xLabel = 'Area [\mum^2]'; yLabel = 'Ratio of actin intensities'; plot_Title = {'Ratio of Actin intensity (collective mean intensities', 'of "at BB position" & "all area excluding BBs")'}; save_title = 'actinInt_vs_area'; 
[binned_xy, XData, YData] = avg_plot_prep(area_data, time_data, new_parameter, XData, bininterval_for_Binparameter, bininterval_string, save_title, xLabel, yLabel, plot_Title, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, plot_save_link);
% storing for future use
collective_actin_intensity_x = XData; collective_actin_intensity_y = YData; binXY_collective_actin_intensity = binned_xy; 
clear area_data time_data new_parameter XData par_dat binned_xy YData

%%
% plotting the histograms for different bins of collective actin intensity
% getting the collective actin intensity (this allows us to see how the distribution of the intensity look like in the different bins)
bin_breakpoint_idx_below = collective_actin_intensity_x <= bin_breakpoint_collective_int; % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = collective_actin_intensity_x > bin_breakpoint_collective_int; % getting all the indices above the bin_breakpoint value
binXY_collectiveActinIntensity_mat_bin1 = collective_actin_intensity_y(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_collective_actin_intensity(1:3,2)'); % each row in binXY_collective_actin_intensity corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 50 µm2; So 1:3 corresponds to 3 bins between 50 - 150 µm2.
binXY_collectiveActinIntensity_mat_bin2 = collective_actin_intensity_y(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_collective_actin_intensity(4:end,2)'); % each row in binXY_collective_actin_intensity corresponds to one bin; The bin width (or bin interval) is 50 µm2; So 4:end corresponds to all the bins between 150 - 350 µm2.
parameter_1 = binXY_collectiveActinIntensity_mat_bin1; bininterval_1 = 0.1; 
parameter_2 = binXY_collectiveActinIntensity_mat_bin2; bininterval_2 = 0.1; 
XLabel = 'Ratio of actin intensities'; TiTle = {'Ratio of Actin intensity (collective mean intensities', 'of "at BB position" & "all area excluding BBs")'}; save_title = 'actinInt'; 
[collectiveactinInt_bins_AvgTraj] = hist_plots_for_bins(bin_breakpoint_collective_int, parameter_1, bininterval_1, parameter_2, bininterval_2, XLabel, TiTle, save_title, plot_save_link);
cdf_distr_plots(bin_breakpoint_collective_int, parameter_1, parameter_2, XLabel, TiTle, save_title, plot_save_link);
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

%% Ratio of CDF 25 plot (ratio of: CDF from intensities at BB position & surrounding BB regions i.e. donut) vs area
area_data = area; time_data = []; new_parameter = CDF25_BBposSur_ratio; XData = []; bininterval_for_Binparameter = 50; bininterval_string = 50; % modify bininterval if needed
xLabel = 'Area [\mum^2]'; yLabel = 'Ratio of CDF at 25 %'; plot_Title = {'Ratio of CDF at 25 %,' '("at BB position" & "surrounding BB regions i.e. donuts")'}; save_title = 'CDF25_vs_area'; 
[binned_xy, XData, YData] = avg_plot_prep(area_data, time_data, new_parameter, XData, bininterval_for_Binparameter, bininterval_string, save_title, xLabel, yLabel, plot_Title, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, plot_save_link);
% storing for future use
CDF25_x = XData; CDF25_y = YData; binXY_CDF25 = binned_xy; 
clear area_data time_data new_parameter XData par_dat binned_xy YData

%%
% plotting the histograms for different bins of CDF25
% getting the CDF25 (this allows us to see how the distribution of CDF25 look like in the different bins)
bin_breakpoint_idx_below = CDF25_x <= bin_breakpoint_25; % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = CDF25_x > bin_breakpoint_25; % getting all the indices above the bin_breakpoint value
binXY_CDF25_mat_bin1 = CDF25_y(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_CDF25(1:3,2)'); % each row in binXY_CDF25 corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 50 µm2; So 1:3 corresponds to 3 bins between 50 - 150 µm2.
binXY_CDF25_mat_bin2 = CDF25_y(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_CDF25(4:end,2)'); % each row in binXY_CDF25 corresponds to one bin; The bin width (or bin interval) is 50 µm2; So 4:end corresponds to all the bins between 150 - 350 µm2.
parameter_1 = binXY_CDF25_mat_bin1; bininterval_1 = 0.05; 
parameter_2 = binXY_CDF25_mat_bin2; bininterval_2 = 0.05; 
XLabel = 'Ratio of CDF at 25 %'; TiTle = {'Ratio of CDF at 25 %,' '("at BB position" & "surrounding BB regions i.e. donuts")'}; save_title = 'CDF25'; 
[CDF25_bins_AvgTraj] = hist_plots_for_bins(bin_breakpoint_25, parameter_1, bininterval_1, parameter_2, bininterval_2, XLabel, TiTle, save_title, plot_save_link);
cdf_distr_plots(bin_breakpoint_25, parameter_1, parameter_2, XLabel, TiTle, save_title, plot_save_link);
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

%% Ratio of CDF 50 plot (ratio of: CDF from intensities at BB position & surrounding BB regions i.e. donut) vs area
area_data = area; time_data = []; new_parameter = CDF50_BBposSur_ratio; XData = []; bininterval_for_Binparameter = 50; bininterval_string = 50; % modify bininterval if needed
xLabel = 'Area [\mum^2]'; yLabel = 'Ratio of CDF at 50 %'; plot_Title = {'Ratio of CDF at 50 %,' '("at BB position" & "surrounding BB regions i.e. donuts")'}; save_title = 'CDF50_vs_area'; 
[binned_xy, XData, YData] = avg_plot_prep(area_data, time_data, new_parameter, XData, bininterval_for_Binparameter, bininterval_string, save_title, xLabel, yLabel, plot_Title, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, plot_save_link);
% storing for future use
CDF50_x = XData; CDF50_y = YData; binXY_CDF50 = binned_xy; 
clear area_data time_data new_parameter XData par_dat binned_xy YData

%%
% plotting the histograms for different bins of CDF50
% getting the CDF50 (this allows us to see how the distribution of CDF50 look like in the different bins)
bin_breakpoint_idx_below = CDF50_x <= bin_breakpoint_50; % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = CDF50_x > bin_breakpoint_50; % getting all the indices above the bin_breakpoint value
binXY_CDF50_mat_bin1 = CDF50_y(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_CDF50(1:3,2)'); % each row in binXY_CDF50 corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 50 µm2; So 1:3 corresponds to 3 bins between 50 - 150 µm2.
binXY_CDF50_mat_bin2 = CDF50_y(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_CDF50(4:end,2)'); % each row in binXY_CDF50 corresponds to one bin; The bin width (or bin interval) is 50 µm2; So 4:end corresponds to all the bins between 150 - 350 µm2.
parameter_1 = binXY_CDF50_mat_bin1; bininterval_1 = 0.05; 
parameter_2 = binXY_CDF50_mat_bin2; bininterval_2 = 0.05; 
XLabel = 'Ratio of CDF at 50 %'; TiTle = {'Ratio of CDF at 50 %,' '("at BB position" & "surrounding BB regions i.e. donuts")'}; save_title = 'CDF50'; 
[CDF50_bins_AvgTraj] = hist_plots_for_bins(bin_breakpoint_50, parameter_1, bininterval_1, parameter_2, bininterval_2, XLabel, TiTle, save_title, plot_save_link);
cdf_distr_plots(bin_breakpoint_50, parameter_1, parameter_2, XLabel, TiTle, save_title, plot_save_link);
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

%% Ratio of CDF 75 plot (ratio of: CDF from intensities at BB position & surrounding BB regions i.e. donut) vs area
area_data = area; time_data = []; new_parameter = CDF75_BBposSur_ratio; XData = []; bininterval_for_Binparameter = 50; bininterval_string = 50; % modify bininterval if needed
xLabel = 'Area [\mum^2]'; yLabel = 'Ratio of CDF at 75 %'; plot_Title = {'Ratio of CDF at 75 %,' '("at BB position" & "surrounding BB regions i.e. donuts")'}; save_title = 'CDF75_vs_area'; 
[binned_xy, XData, YData] = avg_plot_prep(area_data, time_data, new_parameter, XData, bininterval_for_Binparameter, bininterval_string, save_title, xLabel, yLabel, plot_Title, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, plot_save_link);
% storing for future use
CDF75_x = XData; CDF75_y = YData; binXY_CDF75 = binned_xy; 
clear area_data time_data new_parameter XData par_dat binned_xy YData

%%
% plotting the histograms for different bins of CDF75
% getting the CDF75 (this allows us to see how the distribution of CDF75 look like in the different bins)
bin_breakpoint_idx_below = CDF75_x <= bin_breakpoint_75; % getting all the indices below and equal to the bin_breakpoint value
bin_breakpoint_idx_above = CDF75_x > bin_breakpoint_75; % getting all the indices above the bin_breakpoint value
binXY_CDF75_mat_bin1 = CDF75_y(bin_breakpoint_idx_below); % Previous bin split logic: cell2mat(binXY_CDF75(1:3,2)'); % each row in binXY_CDF75 corresponds to one bin; The bin width (or bin interval) by which the data is segregated is 75 µm2; So 1:3 corresponds to 3 bins between 75 - 175 µm2.
binXY_CDF75_mat_bin2 = CDF75_y(bin_breakpoint_idx_above); % Previous bin split logic: cell2mat(binXY_CDF75(4:end,2)'); % each row in binXY_CDF75 corresponds to one bin; The bin width (or bin interval) is 75 µm2; So 4:end corresponds to all the bins between 175 - 375 µm2.
parameter_1 = binXY_CDF75_mat_bin1; bininterval_1 = 0.05; 
parameter_2 = binXY_CDF75_mat_bin2; bininterval_2 = 0.05; 
XLabel = 'Ratio of CDF at 75 %'; TiTle = {'Ratio of CDF at 75 %,' '("at BB position" & "surrounding BB regions i.e. donuts")'}; save_title = 'CDF75'; 
[CDF75_bins_AvgTraj] = hist_plots_for_bins(bin_breakpoint_75, parameter_1, bininterval_1, parameter_2, bininterval_2, XLabel, TiTle, save_title, plot_save_link);
cdf_distr_plots(bin_breakpoint_75, parameter_1, parameter_2, XLabel, TiTle, save_title, plot_save_link);
clear parameter_1 parameter_2 bin_breakpoint_idx_below bin_breakpoint_idx_above

%% Range coverage index vs area (we execute this section only to get the area filtered Range coverage index and not for plotting Range coverage index against area - because range coverage index is not very informative)
area_data = area; time_data = []; new_parameter = range_coverage_idx; XData = []; bininterval_for_Binparameter = 50; bininterval_string = 50; % modify bininterval if needed
xLabel = []; yLabel = []; plot_Title = []; save_title = []; % the empty arrays here allow us to create condition under "avgd_plots" function which makes sure the plotting is skipped for this section / if plotting is needed in future, just give proper values to xLabel, yLabel, plot_Title and save_title.
[binned_xy, XData, YData] = avg_plot_prep(area_data, time_data, new_parameter, XData, bininterval_for_Binparameter, bininterval_string, save_title, xLabel, yLabel, plot_Title, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, plot_save_link);
% storing for future use
range_coverage_idx_x = XData; range_coverage_idx_y = YData; binXY_range_coverage_idx = binned_xy; 
clear area_data time_data new_parameter XData par_dat binned_xy YData

%% Binned coverage index vs area (we execute this section only to get the area filtered Binned coverage index and not for plotting Binned coverage index against area - because binned coverage index is not very informative)
area_data = area; time_data = []; new_parameter = binned_coverage_idx; XData = []; bininterval_for_Binparameter = 50; bininterval_string = 50; % modify bininterval if needed
xLabel = []; yLabel = []; plot_Title = []; save_title = []; % the empty arrays here allow us to create condition under "avgd_plots" function which makes sure the plotting is skipped for this section / if plotting is needed in future, just give proper values to xLabel, yLabel, plot_Title and save_title.
[binned_xy, XData, YData] = avg_plot_prep(area_data, time_data, new_parameter, XData, bininterval_for_Binparameter, bininterval_string, save_title, xLabel, yLabel, plot_Title, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, plot_save_link);
% storing for future use
binned_coverage_idx_x = XData; binned_coverage_idx_y = YData; binXY_binned_coverage_idx = binned_xy; 
clear area_data time_data new_parameter XData par_dat binned_xy YData

%% Overlap Coefficient vs area (we execute this section only to get the area filtered Overlap coefficient and not for plotting Overlap coefficient against area - because overlap coefficient is not very informative)
area_data = area; time_data = []; new_parameter = overlap_coefficient; XData = []; bininterval_for_Binparameter = 50; bininterval_string = 50; % modify bininterval if needed
xLabel = []; yLabel = []; plot_Title = []; save_title = []; % the empty arrays here allow us to create condition under "avgd_plots" function which makes sure the plotting is skipped for this section / if plotting is needed in future, just give proper values to xLabel, yLabel, plot_Title and save_title.
[binned_xy, XData, YData] = avg_plot_prep(area_data, time_data, new_parameter, XData, bininterval_for_Binparameter, bininterval_string, save_title, xLabel, yLabel, plot_Title, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, plot_save_link);
% storing for future use
overlap_coefficient_x = XData; overlap_coefficient_y = YData; binXY_overlap_coefficient = binned_xy; 
clear area_data time_data new_parameter XData par_dat binned_xy YData

%% No of cells

No_of_cells_analyzed_for_collective_actin_intensity = sum(any(~isnan(collective_actin_intensity_y), 2)) % finds the no of columns in 'collective_actin_intensity_y' that has atleast one non-NaN value
No_of_cells_analyzed_for_CDF_25_50_75 = sum(any(~isnan(CDF25_y), 2)) % finds the no of columns in 'CDF25_y' that has atleast one non-NaN value

%% saving workspace

close all;
%cd(plot_save_link);
save(fullfile(plot_save_link, 'workspace_high_res_data.mat'));

%% Saving the figures as montage_2

% this function goes through all the .tif files in this folder (Result_Data) and puts them together as a montage. But it doesnt follow any order rather just goest from 1st to last file in the order it appears in the folder

delete('montage.tif'); % deleting the montage file in case it exists; Because, if the montage exists and we make a new montage, since the existing montage is also a.tif file, this will also be included in the new montage

Tif_filelist = dir(fullfile(plot_save_link, '*.tif')); % getting the list of all .tif files in the folder
tifile_count = length(Tif_filelist);
tif_stack = cell(1, tifile_count); % preallocation

for i = 1:tifile_count
    tif_filepath = fullfile(plot_save_link, Tif_filelist(i).name); % getting the .tif files one-by-one
    tif_stack{i} = imread(tif_filepath); % storing each image in the preallocated cell array 
end

montage(tif_stack); % make montage o f all the images stored in the cell array
saveas(gcf, fullfile(plot_save_link,'montage'), 'tif'); 

%%
close all;
disp('finished !');

%% Function
% This function takes the input and applies the area_time_shift function and then calls the 'avg_plots' function for plotting
function [binned_xy, XData, YData] = avg_plot_prep(area_data, time_data, new_parameter, XData, bininterval_for_Binparameter, bininterval_string, save_title, xLabel, yLabel, plot_Title, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold, plot_save_link)
[ar_dat, tme_dat, par_dat] = area_time_shift(area_data, time_data, new_parameter, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold); % calling function 'area_time_shift'
par_dat(par_dat==0) = nan; % changing all zeros to nans.
[ar_dat] = nanconversion(ar_dat, par_dat); % calling the function that converts the zeros (coming from difference in column length) to nans.
if isempty(XData)
    XData = ar_dat;
end
YData = par_dat; Binparameter = XData;
[binned_xy] = avgd_plots(Binparameter, XData, YData, bininterval_for_Binparameter, xLabel, yLabel, plot_Title, plot_save_link, save_title); % , bininterval_string % calling the function
% clear area_data time_data new_parameter ar_dat tme_dat par_dat XData YData Binparameter binned_xy
end

%% Function NaN conversion
% this function converts only the zeros that are coming from the difference in column length are converted to nans - (meaning the actual zeros which are generated to indicate the missing elements are not used here). This is done by taking the array of the
% parameter (for ex: area) in which there are no zeros from missing elements and the zeros from difference in column length are converted to nans. Then the indices of nans in this array are used to introduce nans in the other parameters (for ex BB count).

function [mod_xdata] = nanconversion(xdata, ydata)
a_a = ydata(:); % linearising the area array so that we can find the row numbers that correspond to nans. This will be used as reference.
[row, ~] = find(isnan(a_a)); % finding the rows in which nans are present
xdata(row) = nan; % converting all these rows to nans.
mod_xdata = xdata;
clear a_a row
end

%% Function NaN padding
% This function pads vectors with NaNs to bring them to same size (any no of vectors can be input to this function)
% Using the function below, we go through each cell of all the cell arrays and find the cell with the maximum number of elements. Then we pad rest of the cells with NaNs to reach similar number of elements. This way: (1)
% all cells are made to be of same length i.e same number of elements; (2) the padding (to equalise the length) is done with NaNs; (3) by this we make sure that all zeros that were legitimately generated remain in place
% without getting replaced by nans (because the usual procedure is to replace the zeros that were generated to equalise the lengths with nans and in this process even the legitimately created zeros will be replaced with NaNs / this procedure allows to overcome this issue).
function [v3] = nan_padding(v_all) % getting the cell array 'v_all' as input
maxNo_rows = max(cellfun(@(c) size(c,1), v_all)); % finding the cell with the maximum length in the cell array 'v_all'
v3 = cell2mat((cellfun(@(x) {padarray(x,[maxNo_rows-size(x,1),0], NaN, 'Post')}, v_all))); % filling all the cells (i.e. vectors) in the cell array with NaN to bring them to the same size as the longest cell in this cell array and then convert it into a matrix
end

%% Function Area-time shift
% This function can do three things for 'area', 'time' and a third 'parameter', depending on the 'operation_type' called:
% '1' plots rawdata without any restriction or thresholds
% '2' removes data corresponding to 0 - 'minimum_area_threshold' and the corresponding time is also removed;
% '3' restricts the area threshold to 'max_threshold_area' and time to 'max_threshold_time';
% '4' combines both (i) removal of 0 - 'minimum_area_threshold' and corresponding time; and (ii) restricting the area threshold to 'max_threshold_area' and restricting time to 'max_threshold_time';

function [ar_dat, tme_dat, par_dat] = area_time_shift(area_data, time_data, new_parameter, max_threshold_area, max_threshold_time, operation_type, minimum_area_threshold)

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
    end
end
end

%% Function to choose the area threshold

% The operation type decides the type of thresholding to be applied while plotting;
% Enter one of these numbers ('1', '2', '3') for the 'operation_type' below.
% '1' plots rawdata without any restriction or thresholds
% '2' removes data corresponding to 0 - 'minimum_area_threshold' and the corresponding time is also removed;
% '3' restricts the area threshold to 'max_threshold_area' and time to 'max_threshold_time';
% '4' combines both (i) removal of 0 - 'minimum_area_threshold' and corresponding time; and (ii) restricting the area threshold to 'max_threshold_area' and restricting time to 'max_threshold_time';

function [minimum_area_threshold, max_threshold_area, max_threshold_time] = operation_type_value(idx)

operation_type = idx; %

% The values below are already preselected for control / wildtype data
% minimum_area_threshold - Ctrl: 50; alphaActininMO: 50; minimum area (in µm2) above which the data should be plotted
% max_threshold_area - Ctrl: 337; alphaActininMO: 150; Maximum area (in µm2) upto which the data should be plotted
% max_threshold_time - Ctrl: 150; alphaActininMO: 150; Maximum time (in min) upto which the data should be plotted

if operation_type == 1 % plotting Rawdata without any restriction or thresholds
    minimum_area_threshold = 0; % Min. Area in µm2
    max_threshold_area = 330; % Max. Area in µm2
    max_threshold_time = 250; % Max. time in min
    avg_plots_folder_name = strcat('./Avg_plots_Rawdata');

elseif operation_type == 2 % plotting data without this area range (0 - 'minimum_area_threshold') and also removing the corresponding times;
    minimum_area_threshold = 50; % Min. threshold Area in µm2
    max_threshold_area = 350; % Max. Area in µm2
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

%% Function Plotting the averages

function [binned_xy] = avgd_plots(binparameter, x_axis, y_axis, bininterval, Xlabel, Ylabel, Plot_title, plot_save_link, save_title) % , bininterval_string

if ~isempty(Xlabel) % this if condition makes sure that the plots are generated only if Xlabel has some value and is not empty. This is to make sure the plots for "Range coverage index", "Binned coverage index" and "overlap coefficient" are not plotted - check these sections to know more
    % collective plot
    figure(100);
    plot(x_axis, y_axis, 'ko', 'MarkerSize', 5); xlabel(Xlabel); ylabel(Ylabel); title(Plot_title); set(gca,'fontsize',12);
    save_name = strcat(save_title, '_avg_collective_plot');
    saveas(gcf, fullfile(plot_save_link, save_name), 'fig'); saveas(gcf, fullfile(plot_save_link, save_name), 'tif');
end

%----------- Binning and Averaging -----------%
% getting the x, y values and assigning the bin parameter
binparameter = binparameter(~isnan(binparameter));
x_axis = x_axis(~isnan(x_axis));
y_axis = y_axis(~isnan(y_axis));

% In general, bins can be created in two ways: (1) using the bin centers and (2) using the bin edges. Both can be used. But usually, using bin edges is better because then the mean of the bin will become the bin center. Whereas in the
% case of bin center based bins, the bin center is decided and the data are aggregated to the corresponding bin basket accordingly. Therefore the bin center based bins can be thought of as a "slightly forced" approach.
% However, if the trends of the plots are strong, these two approaches may not make a big difference. But if the trend is subtle, then bin edges based bins might be a slightly better option. 
% Below, we have made two different ways bin edges based approach. The only difference is how the start and end of the bins are decided. Check the binrange & binrange_1, and their comments to understand better. We have the flexibility to change between the two ways. 
% (1) If you want the bin edges to be simply min and max of binparameter (currently used): then use the variable "bin" instead of "bin_1" for calcualting the x & y means (i.e. x_bin_mean) and use the variable "edges" instead of "edges_1" for getting the bin values (i.e binned_xy).
% (2) If you want the bin edges to be min and max of binparameter but adjusted to bininterval: then use the variable "bin_1" instead of "bin" for calcualting the x & y means (i.e. x_bin_mean) and use the variable "edges_1" instead of "edges" for getting the bin values (i.e binned_xy).

% Creating bins for those plotting that use those plots where a parameter is plotted against area, time or another parameter; these bins are used only for plotting and are not returned as a product of this function
binrange = min(binparameter) : bininterval : (max(binparameter)+bininterval); % here, bins are defined by their bin centers; For example, while creating bins for values between 0-350, the bins will be around bincenter: 25-50-75, 75-100-125, 125-150-175, 175-200-225, 225-250-275, 275-300-325
[N, edges, bin] = histcounts(binparameter, binrange); % however, using hist counts changes it to bin edges based approach.
% binsum_y = accumarray(bin(:), y_axis(:));

% Creating bins for histogram plots where different bins (based on binedges) are plotted as histograms.
% This is mainly used for plotting the histograms of values of different parameters "upto 150 µm2" and "beyond 150µm2"; These bins (i.e. based on bin edges) are returned as a product of this function i.e. as "binned_xy" which will be then used for plotting the histograms
lower_binEdge = floor(min(binparameter)/bininterval) * bininterval;
upper_binEdge = ceil(max(binparameter)/bininterval) * bininterval;
binrange_1 = lower_binEdge : bininterval : upper_binEdge; % here bins are defined by their bin edges_1; For example, while creating bins for values between 0-350, the bins will be within the bin edge: 0-50, 51-100, 101-150, 151-200, 201-250, 251-300, 301-350 
[N_1, edges_1, bin_1] = histcounts(binparameter, binrange_1); % histcounts used the bin edges based approach

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

% computing the average and standard deviation for the bins of x
x_bin_mean = accumarray(bin(:), x_axis(:), [], @mean); [sort_x_bin_mean, idx_sort_x_bin_mean] = sort(x_bin_mean);
x_bin_std = accumarray(bin(:), x_axis(:), [], @std); sort_x_bin_std = x_bin_std(idx_sort_x_bin_mean);
% computing the average and standard deviation for the bins of y
y_bin_mean = accumarray(bin(:), y_axis(:), [], @mean); sort_y_bin_mean = y_bin_mean(idx_sort_x_bin_mean);
y_bin_std = accumarray(bin(:), y_axis(:), [], @std); sort_y_bin_std = y_bin_std(idx_sort_x_bin_mean);

if ~isempty(Xlabel) % this if condition makes sure that the plots are generated only if Xlabel has some value and is not empty. This is to make sure the plots for "Range coverage index", "Binned coverage index" and "overlap coefficient" are not plotted - check these sections to know more
    % plotting the bin averages - standard deviation as shaded region
    figure(101);
    c1 = sort_y_bin_mean + sort_y_bin_std;
    c2 = sort_y_bin_mean - sort_y_bin_std;
    x2 = [sort_x_bin_mean', fliplr(sort_x_bin_mean')];
    inbtw = [c1', fliplr(c2')];
    fill(x2, inbtw, 'k', 'FaceAlpha', '0.1');
    hold on;
    plot(sort_x_bin_mean, sort_y_bin_mean, 'k', 'LineWidth', 2);
    xlabel(Xlabel);  ylabel(Ylabel); title(Plot_title);  set(gca,'fontsize',12);
    save_name_avg_1 = strcat(save_title, '_avg_plot_shaded_bin'); % _', num2str(bininterval_string)
    saveas(gcf, fullfile(plot_save_link, save_name_avg_1), 'fig'); saveas(gcf, fullfile(plot_save_link, save_name_avg_1), 'tif');

    % plotting the bin averages - standard deviation error bars
    figure(102);
    errorbar(x_bin_mean, y_bin_mean, y_bin_std, 'vertical', 'o', 'color', 'k', 'MarkerSize', 1, 'MarkerEdgeColor', 'black'); % 'MarkerSize', 10, 'MarkerEdgeColor', 'black'
    hold on;
    errorbar(x_bin_mean, y_bin_mean, x_bin_std, 'horizontal', 'o', 'color', 'k', 'MarkerSize', 1, 'MarkerEdgeColor', 'black');
    xlabel(Xlabel);  ylabel(Ylabel); title(Plot_title);  set(gca,'fontsize',12);
    save_name_avg_2 = strcat(save_title, '_avg_plot_errorbar_bin'); % _', num2str(bininterval_string)
    saveas(gcf, fullfile(plot_save_link, save_name_avg_2), 'fig'); saveas(gcf, fullfile(plot_save_link, save_name_avg_2), 'tif');

    % pause;
    close (figure(100), figure(101), figure(102));
end

end

%% Function that generates the combined histogram plots

function [a2] = hist_plots_for_bins(bin_breakpoint, parameter_1, bininterval_1, parameter_2, bininterval_2, XLabel, TiTle, save_title, plot_save_link)
figure(100);
% first bin (upto 150 µm2)
binparameter_1 = parameter_1(~isnan(parameter_1));
binrange_1 = min(binparameter_1):bininterval_1:max(binparameter_1); % setting the bin range based on the input data
[N_1, ~] = histcounts(binparameter_1, binrange_1); % here 'N' corresponds to the counts or the repeats of the data; and edges is same as the binrange defined above.
binrange_mod_1 = binrange_1(1:end-1); % changing the binrange length to match the length of N so that they can be plotted together.
histplot = histogram(binparameter_1, binrange_mod_1, 'Normalization', 'pdf'); histplot.FaceColor = 'g'; histplot.FaceAlpha = 0.3; histplot.LineWidth = 0.01; histplot.EdgeColor = 'none'; % either barplot or histogram plot can be used
hold on;

% second bin (beyond 150  µm2)
binparameter_2 = parameter_2(~isnan(parameter_2));
binrange_2 = min(binparameter_2):bininterval_2:max(binparameter_2); % setting the bin range based on the input data
[N_2, ~] = histcounts(binparameter_2, binrange_2); % here 'N' corresponds to the counts or the repeats of the data; and edges is same as the binrange defined above.
binrange_mod_2 = binrange_2(1:end-1); % changing the binrange length to match the length of N so that they can be plotted together.
histplot = histogram(binparameter_2, binrange_mod_2, 'Normalization', 'pdf'); histplot.FaceColor = 'k'; histplot.FaceAlpha = 0.3; histplot.LineWidth = 0.01; histplot.EdgeColor = 'none'; % either barplot or histogram plot can be used
% clear parameter_2 bininterval binparameter_2 binrange_mod_2 N_2

xlabel(XLabel);  ylabel('Probability density'); title(TiTle);  set(gca,'fontsize',12); legend_1 = strcat("Upto ", num2str(bin_breakpoint), " µm2"); legend_2 = strcat("Beyond ", num2str(bin_breakpoint), " µm2"); legend (legend_1, legend_2); save_title = strcat(save_title, '_PDF');
saveas(gcf, fullfile(plot_save_link, save_title), 'fig'); saveas(gcf, fullfile(plot_save_link, save_title), 'tif');
%pause;
close (figure(100));
% below we concatenate the two input vectors 'binparameter_1' & 'binparameter_2' so that they are stored as one matrix and is easy for saving in the excel sheet for future statistical analysis
a0 = {binparameter_1, binparameter_2}; % concatenating two arrays with different lengths as cell array
a1 = nan_padding(a0); % padding the length difference (between the arrays) with NaNs
a2 = [a1(:,1), a1(:,2)]; % concatenating the two columns of the cell array and storing them as a standard matric
end

%% Function that generates the CDF plots i.e. alternative to the PDF plots

function cdf_distr_plots(bin_breakpoint, parameter_1, parameter_2, XLabel, TiTle, save_title, plot_save_link)
figure(101);

cdf_1 = cdfplot(parameter_1); set(cdf_1, 'LineStyle', '-', 'Color', 'g');
hold on;
cdf_2 = cdfplot(parameter_2); set(cdf_2, 'LineStyle', '-', 'Color', 'k');
xlabel(XLabel);  ylabel('Cumulative probability'); title(TiTle);  set(gca,'fontsize',12); legend_1 = strcat("Upto ", num2str(bin_breakpoint), " µm2"); legend_2 = strcat("Beyond ", num2str(bin_breakpoint), " µm2"); legend (legend_1, legend_2); save_title = strcat(save_title, '_CDF');
saveas(gcf, fullfile(plot_save_link, save_title), 'fig'); saveas(gcf, fullfile(plot_save_link, save_title), 'tif');

%pause;
close (figure(101));

end

%%









