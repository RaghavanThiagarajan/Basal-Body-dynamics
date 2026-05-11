% Raghavan Thiagarajan, 11th May 2025, reNEW, Copenhagen

% This script will plot the histogram comparisons between the control and
% alphaActinin Morpholino (MO) conditions for different parameters like alpha value (slope);
% transition time and Diff. strength etc.

% This script should be run after finishing the analysis for both control
% and MO conditions

clear all;
close all;
clc;

BB_apical_avg = fileparts(matlab.desktop.editor.getActiveFilename);
cd(BB_apical_avg);
mkdir '.\plots_comparison_ctrl_mo';
save_link = strcat(BB_apical_avg, '\plots_comparison_ctrl_mo');

% Fetching the parameters for control condition
data_folder = uigetdir(BB_apical_avg, 'Select the folder that contains the workspace for the control condition'); % select the "Result_Data" folder for Control condition
cd(data_folder);
load('workspace_high_res_data.mat', 'AvgActinInt_BBpos_y', 'avgdActIntBBpos_bins_AvgTraj', 'AvgActinInt_BBsur_y', 'avgdActIntBBsur_bins_AvgTraj', 'AvgActinInt_BBpossurRatio_y', 'avgdActIntBBpossurRatio_bins_AvgTraj', 'apicalArea_actin_intensity_y', 'apicalAreaActinInt_bins_AvgTraj',...
    'collective_actin_intensity_y', 'collectiveactinInt_bins_AvgTraj', 'CDF25_y', 'CDF25_bins_AvgTraj', 'CDF50_y', 'CDF50_bins_AvgTraj', 'CDF75_y', 'CDF75_bins_AvgTraj', 'range_coverage_idx_y', 'binned_coverage_idx_y', 'overlap_coefficient_y'); 
% reassigning the parameters
[AvgActinInt_BBpos_ctrl_1, AvgActinInt_BBpos_ctrl] = processed_matrix(AvgActinInt_BBpos_y(:));
[AvgActinInt_BBsur_ctrl_1, AvgActinInt_BBsur_ctrl] = processed_matrix(AvgActinInt_BBsur_y(:));
[AvgActinInt_BBpossurRatio_ctrl_1, AvgActinInt_BBpossurRatio_ctrl] = processed_matrix(AvgActinInt_BBpossurRatio_y(:));
[apicalArea_actin_intensity_ctrl_1, apicalArea_actin_intensity_ctrl] = processed_matrix(apicalArea_actin_intensity_y(:));
[collective_actin_intensity_ctrl_1, collective_actin_intensity_ctrl] = processed_matrix(collective_actin_intensity_y(:));
[CDF25_ctrl_1, CDF25_ctrl] = processed_matrix(CDF25_y(:));
[CDF50_ctrl_1, CDF50_ctrl] = processed_matrix(CDF50_y(:));
[CDF75_ctrl_1, CDF75_ctrl] = processed_matrix(CDF75_y(:));
[range_coverage_idx_ctrl_1, range_coverage_idx_ctrl] = processed_matrix(range_coverage_idx_y(:));
[binned_coverage_idx_ctrl_1, binned_coverage_idx_ctrl] = processed_matrix(binned_coverage_idx_y(:));
[overlap_coefficient_ctrl_1, overlap_coefficient_ctrl] = processed_matrix(overlap_coefficient_y(:));
avgdActIntBBpos_bins_AvgTraj_ctrl = avgdActIntBBpos_bins_AvgTraj; avgdActIntBBsur_bins_AvgTraj_ctrl = avgdActIntBBsur_bins_AvgTraj; avgIntBBPosSur_bins_AvgTraj_ctrl = avgdActIntBBpossurRatio_bins_AvgTraj; apicalAreaInt_bins_AvgTraj_ctrl = apicalAreaActinInt_bins_AvgTraj; collectiveInt_ctrl_bins_AvgTraj = collectiveactinInt_bins_AvgTraj; CDF25_bins_AvgTraj_ctrl = CDF25_bins_AvgTraj; CDF50_bins_AvgTraj_ctrl = CDF50_bins_AvgTraj; CDF75_bins_AvgTraj_ctrl = CDF75_bins_AvgTraj;
clear AvgActinInt_BBpos_y avgdActIntBBpos_bins_AvgTraj AvgActinInt_BBsur_y avgdActIntBBsur_bins_AvgTraj AvgActinInt_BBpossurRatio_y avgdActIntBBpossurRatio_bins_AvgTraj apicalArea_actin_intensity_y apicalAreaActinInt_bins_AvgTraj ...
    collective_actin_intensity_y collectiveactinInt_bins_AvgTraj CDF25_y CDF25_bins_AvgTraj CDF50_y CDF50_bins_AvgTraj CDF75_y CDF75_bins_AvgTraj range_coverage_idx_y binned_coverage_idx_y overlap_coefficient_y

% Fetching the parameters for MO condition
data_folder = uigetdir(BB_apical_avg, 'Select the folder that contains the workspace for the MO condition'); % select the "Result_Data" folder for MO condition
cd(data_folder);
load('workspace_high_res_data.mat', 'AvgActinInt_BBpos_y', 'avgdActIntBBpos_bins_AvgTraj', 'AvgActinInt_BBsur_y', 'avgdActIntBBsur_bins_AvgTraj', 'AvgActinInt_BBpossurRatio_y', 'avgdActIntBBpossurRatio_bins_AvgTraj', 'apicalArea_actin_intensity_y', 'apicalAreaActinInt_bins_AvgTraj',...
    'collective_actin_intensity_y', 'collectiveactinInt_bins_AvgTraj', 'CDF25_y', 'CDF25_bins_AvgTraj', 'CDF50_y', 'CDF50_bins_AvgTraj', 'CDF75_y', 'CDF75_bins_AvgTraj', 'range_coverage_idx_y', 'binned_coverage_idx_y', 'overlap_coefficient_y'); 
% reassigning the parameters
[AvgActinInt_BBpos_MO_1, AvgActinInt_BBpos_MO] = processed_matrix(AvgActinInt_BBpos_y(:));
[AvgActinInt_BBsur_MO_1, AvgActinInt_BBsur_MO] = processed_matrix(AvgActinInt_BBsur_y(:));
[AvgActinInt_BBpossurRatio_MO_1, AvgActinInt_BBpossurRatio_MO] = processed_matrix(AvgActinInt_BBpossurRatio_y(:));
[apicalArea_actin_intensity_MO_1, apicalArea_actin_intensity_MO] = processed_matrix(apicalArea_actin_intensity_y(:));
[collective_actin_intensity_MO_1, collective_actin_intensity_MO] = processed_matrix(collective_actin_intensity_y(:));
[CDF25_MO_1, CDF25_MO] = processed_matrix(CDF25_y(:));
[CDF50_MO_1, CDF50_MO] = processed_matrix(CDF50_y(:));
[CDF75_MO_1, CDF75_MO] = processed_matrix(CDF75_y(:));
[range_coverage_idx_MO_1, range_coverage_idx_MO] = processed_matrix(range_coverage_idx_y(:));
[binned_coverage_idx_MO_1, binned_coverage_idx_MO] = processed_matrix(binned_coverage_idx_y(:));
[overlap_coefficient_MO_1, overlap_coefficient_MO] = processed_matrix(overlap_coefficient_y(:));
avgdActIntBBpos_bins_AvgTraj_MO = avgdActIntBBpos_bins_AvgTraj; avgdActIntBBsur_bins_AvgTraj_MO = avgdActIntBBsur_bins_AvgTraj; avgIntBBPosSur_bins_AvgTraj_MO = avgdActIntBBpossurRatio_bins_AvgTraj; apicalAreaInt_bins_AvgTraj_MO = apicalAreaActinInt_bins_AvgTraj; collectiveInt_MO_bins_AvgTraj = collectiveactinInt_bins_AvgTraj; CDF25_bins_AvgTraj_MO = CDF25_bins_AvgTraj; CDF50_bins_AvgTraj_MO = CDF50_bins_AvgTraj; CDF75_bins_AvgTraj_MO = CDF75_bins_AvgTraj;
clear AvgActinInt_BBpos_y avgdActIntBBpos_bins_AvgTraj AvgActinInt_BBsur_y avgdActIntBBsur_bins_AvgTraj AvgActinInt_BBpossurRatio_y avgdActIntBBpossurRatio_bins_AvgTraj apicalArea_actin_intensity_y apicalAreaActinInt_bins_AvgTraj ...
    collective_actin_intensity_y collectiveactinInt_bins_AvgTraj CDF25_y CDF25_bins_AvgTraj CDF50_y CDF50_bins_AvgTraj CDF75_y CDF75_bins_AvgTraj range_coverage_idx_y binned_coverage_idx_y overlap_coefficient_y

legend_1 = 'Control'; legend_2 = 'alphaActinin MO'; % defining legends

%% plotting the PDFs and CDFs

% Averaged actin intensity at the position of BBs comparisons
% This averaged actin intensity (normalised) of the BB position is obtained by collecting  the intensities of actin at BB position of all BBs in a apical domain and by taking the average of these intensities; this is a bit different from "actinInt_atBBpos_norm" where the ROI itself includes all the BBs (i.e. BB position) and then imageJ already collects the average instead of performing the average after collecting from multiple BB ROIs. But these values will be more or less the same.
parameter_1 = AvgActinInt_BBpos_ctrl; parameter_2 = AvgActinInt_BBpos_MO; bininterval = 0.05; Xlabel = 'Actin Int at BB pos'; limits_x = max(vertcat(parameter_1(:), parameter_2(:))); Plot_title = {'Averaged actin intensity across apical domain', 'at the position of BBs (normalised)'}; save_title = 'avgActinIntBBpos';
[AvgActinInt_BBpos] = pdf_distr_plots(parameter_1, parameter_2, bininterval, Xlabel, limits_x, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting frequency distribution histograms
cdf_distr_plots(parameter_1(:), parameter_2(:), Xlabel, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting CDFs
clear parameter_1 parameter_2 bininterval Xlabel Ylabel limits_x Plot_title save_title 

%% Averaged actin intensity in the surrounding BB position comparisons
% This averaged actin intensity (normalised) from the surrounding BB position; this is obtained by collecting  the intensities of actin in the surrounding regions of all BBs in a apical domain and by taking the average of these intensities; this is different from "actinInt_ExcludingBB_norm" where all the areas other than BBs are used for getting the averaged intensity. Whereas here, only the immediate surrounding regions i.e. donuts are included.
parameter_1 = AvgActinInt_BBsur_ctrl; parameter_2 = AvgActinInt_BBsur_MO; bininterval = 0.05; Xlabel = 'Actin Int surrounding BBs'; limits_x = max(vertcat(parameter_1(:), parameter_2(:))); Plot_title = {'Averaged actin intensity across apical domain', 'surrounding BBs (normalised)'}; save_title = 'avgActinIntBBsur';
[AvgActinInt_BBsur] = pdf_distr_plots(parameter_1, parameter_2, bininterval, Xlabel, limits_x, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting frequency distribution histograms
cdf_distr_plots(parameter_1(:), parameter_2(:), Xlabel, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting CDFs
clear parameter_1 parameter_2 bininterval Xlabel Ylabel limits_x Plot_title save_title 

%% Ratio of Averaged actin intensity in the surrounding to the actin intensity at the BB position comparisons
% average of the ratio of "avg_actinInt_BBSurr_norm" / "avg_actinInt_BBpos_norm"
parameter_1 = AvgActinInt_BBpossurRatio_ctrl; parameter_2 = AvgActinInt_BBpossurRatio_MO; bininterval = 0.05; Xlabel = 'Ratio of Actin Int btw surrounding and BB pos'; limits_x = max(vertcat(parameter_1(:), parameter_2(:))); Plot_title = {'Ratio of Averaged actin intensity across apical domain', 'btw surrounding and BB pos (normalised)'}; save_title = 'avgActinIntBBpossurRatio';
[AvgActinInt_BBpossurRatio] = pdf_distr_plots(parameter_1, parameter_2, bininterval, Xlabel, limits_x, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting frequency distribution histograms
cdf_distr_plots(parameter_1(:), parameter_2(:), Xlabel, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting CDFs
clear parameter_1 parameter_2 bininterval Xlabel Ylabel limits_x Plot_title save_title 

%% Whole apical area mean intensity of actin vs area
parameter_1 = apicalArea_actin_intensity_ctrl; parameter_2 = apicalArea_actin_intensity_MO; bininterval = 0.05; Xlabel = 'Whole Apical area intensity'; limits_x = max(vertcat(parameter_1(:), parameter_2(:))); Plot_title = {'Actin intensity across whole apical area', '(normalised)'}; save_title = 'apicalAreaActinInt';
[apicalAreaActinInt] = pdf_distr_plots(parameter_1, parameter_2, bininterval, Xlabel, limits_x, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting frequency distribution histograms
cdf_distr_plots(parameter_1(:), parameter_2(:), Xlabel, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting CDFs
clear parameter_1 parameter_2 bininterval Xlabel Ylabel limits_x Plot_title save_title 

%% Ratio of collective actin intensity comparisons
% ratio of "actinInt_ExcludingBB_norm" / "actinInt_atBBpos_norm"
parameter_1 = collective_actin_intensity_ctrl; parameter_2 = collective_actin_intensity_MO; bininterval = 0.05; Xlabel = 'Ratio of actin intensities'; limits_x = max(vertcat(parameter_1(:), parameter_2(:))); Plot_title = {'Ratio of Actin intensity (collective mean intensities', 'of "at BB position" & "all area excluding BBs")'}; save_title = 'actinInt';
[collective_actin_intensity] = pdf_distr_plots(parameter_1, parameter_2, bininterval, Xlabel, limits_x, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting frequency distribution histograms
cdf_distr_plots(parameter_1(:), parameter_2(:), Xlabel, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting CDFs
clear parameter_1 parameter_2 bininterval Xlabel Ylabel limits_x Plot_title save_title 

%% Ratio of CDF25 comparisons
parameter_1 = CDF25_ctrl; parameter_2 = CDF25_MO; bininterval = 0.05; Xlabel = 'Ratio of CDF at 25 %'; limits_x = max(vertcat(parameter_1(:), parameter_2(:))); Plot_title = {'Ratio of CDF at 25 %', '("at BB position" & "surrounding BB regions i.e. donuts")'}; save_title = 'CDF25';
[CDF25] = pdf_distr_plots(parameter_1, parameter_2, bininterval, Xlabel, limits_x, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting frequency distribution histograms
cdf_distr_plots(parameter_1(:), parameter_2(:), Xlabel, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting CDFs
clear parameter_1 parameter_2 bininterval Xlabel Ylabel limits_x Plot_title save_title 

%% Ratio of CDF50 comparisons
parameter_1 = CDF50_ctrl; parameter_2 = CDF50_MO; bininterval = 0.05; Xlabel = 'Ratio of CDF at 50 %'; limits_x = max(vertcat(parameter_1(:), parameter_2(:))); Plot_title = {'Ratio of CDF at 50 %', '("at BB position" & "surrounding BB regions i.e. donuts")'}; save_title = 'CDF50';
[CDF50] = pdf_distr_plots(parameter_1, parameter_2, bininterval, Xlabel, limits_x, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting frequency distribution histograms
cdf_distr_plots(parameter_1(:), parameter_2(:), Xlabel, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting CDFs
clear parameter_1 parameter_2 bininterval Xlabel Ylabel limits_x Plot_title save_title 

%% Ratio of CDF75 comparisons
parameter_1 = CDF75_ctrl; parameter_2 = CDF75_MO; bininterval = 0.05; Xlabel = 'Ratio of CDF at 75 %'; limits_x = max(vertcat(parameter_1(:), parameter_2(:))); Plot_title = {'Ratio of CDF at 75 %', '("at BB position" & "surrounding BB regions i.e. donuts")'}; save_title = 'CDF75';
[CDF75] = pdf_distr_plots(parameter_1, parameter_2, bininterval, Xlabel, limits_x, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting frequency distribution histograms
cdf_distr_plots(parameter_1(:), parameter_2(:), Xlabel, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting CDFs
clear parameter_1 parameter_2 bininterval Xlabel Ylabel limits_x Plot_title save_title 

%% Range Coverage Index comparisons
parameter_1 = range_coverage_idx_ctrl; parameter_2 = range_coverage_idx_MO; bininterval = 0.05; Xlabel = 'Range Coverage Index'; limits_x = max(vertcat(parameter_1(:), parameter_2(:))); Plot_title = {'Range coverage index ("overlap between distributions', 'of full apical domain, BB pos and BB surr" - outlier sensitive)'}; save_title = 'range_coverage_idx';
[range_coverage_idx] = pdf_distr_plots(parameter_1, parameter_2, bininterval, Xlabel, limits_x, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting frequency distribution histograms
cdf_distr_plots(parameter_1(:), parameter_2(:), Xlabel, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting CDFs
clear parameter_1 parameter_2 bininterval Xlabel Ylabel limits_x Plot_title save_title 

%% Binned Coverage Index comparisons
parameter_1 = binned_coverage_idx_ctrl; parameter_2 = binned_coverage_idx_MO; bininterval = 0.05; Xlabel = 'Binned Coverage Index'; limits_x = max(vertcat(parameter_1(:), parameter_2(:))); Plot_title = {'Binned coverage index ("overlap between distributions', 'of full apical domain, BB pos and BB surr" - outlier compensated)'}; save_title = 'binned_coverage_idx';
[binned_coverage_idx] = pdf_distr_plots(parameter_1, parameter_2, bininterval, Xlabel, limits_x, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting frequency distribution histograms
cdf_distr_plots(parameter_1(:), parameter_2(:), Xlabel, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting CDFs
clear parameter_1 parameter_2 bininterval Xlabel Ylabel limits_x Plot_title save_title 

%% Overlap Coefficient comparisons
parameter_1 = overlap_coefficient_ctrl; parameter_2 = overlap_coefficient_MO; bininterval = 0.05; Xlabel = 'Overlap Coefficient'; limits_x = max(vertcat(parameter_1(:), parameter_2(:))); Plot_title = {'Overlap Coefficient ("overlap between distributions', 'of full apical domain, BB pos and BB surr" - based on probabilites)'}; save_title = 'overlap_coefficient';
[overlap_coefficient] = pdf_distr_plots(parameter_1, parameter_2, bininterval, Xlabel, limits_x, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting frequency distribution histograms
cdf_distr_plots(parameter_1(:), parameter_2(:), Xlabel, Plot_title, legend_1, legend_2, save_link, save_title); % calling the function for plotting CDFs
clear parameter_1 parameter_2 bininterval Xlabel Ylabel limits_x Plot_title save_title 

%% Saving the figures as montage

cd(save_link);
delete('montage_3.tif'); % deleting the montage file in case it exists; Because, if the montage exists and we make a new montage, since the existing montage is also a.tif file, this will also be included in the new montage

Tif_filelist = dir(fullfile(save_link, '*.tif')); % getting the list of all .tif files in the folder
tifile_count = length(Tif_filelist);
tif_stack = cell(1, tifile_count); % preallocation

for i = 1:tifile_count
    tif_filepath = fullfile(save_link, Tif_filelist(i).name); % getting the .tif files one-by-one
    tif_stack{i} = imread(tif_filepath); % storing each image in the preallocated cell array 
end

montage(tif_stack); % make montage of all the images stored in the cell array
saveas(gcf, fullfile(save_link,'montage_3'), 'tif'); 
close all;

%% saving workspace
save('workspace_ctrl_MO_comparisons', '-v7.3');

%% Saving the excel sheets

% saving all the arrays for which statistical tests need to be done as an excel .xlsx file where each array is a sheet
% choosing the excel name based on the type (Ctrl / MO) of experiment i.e. 'experiment_type'
excel_filename = 'workspaceArrays_inExcel_for_statistics_HighRes_data.xlsx';
delete(strcat(excel_filename)); % deleting the excel file in case it exists; Because, if the excel file exists and we write a new file, it may not completely overwrite but add to what is existing; So for safer side, we delete the already existing file.

% getting all the arrays names for which statistical tests needs to be done
array_names_for_saving_in_excel(1,:) = {'AvgActinInt_BBpos', 'avgdActIntBBpos_bins_AvgTraj_ctrl', 'avgdActIntBBpos_bins_AvgTraj_MO', 'AvgActinInt_BBsur', 'avgdActIntBBsur_bins_AvgTraj_ctrl', 'avgdActIntBBsur_bins_AvgTraj_MO', 'AvgActinInt_BBpossurRatio', 'avgIntBBPosSur_bins_AvgTraj_ctrl', 'avgIntBBPosSur_bins_AvgTraj_MO', 'apicalAreaActinInt', 'apicalAreaInt_bins_AvgTraj_ctrl', 'apicalAreaInt_bins_AvgTraj_MO'...
    'collective_actin_intensity', 'collectiveInt_ctrl_bins_AvgTraj', 'collectiveInt_MO_bins_AvgTraj', 'CDF25', 'CDF25_bins_AvgTraj_ctrl', 'CDF25_bins_AvgTraj_MO', 'CDF50', 'CDF50_bins_AvgTraj_ctrl', 'CDF50_bins_AvgTraj_MO', 'CDF75', 'CDF75_bins_AvgTraj_ctrl', 'CDF75_bins_AvgTraj_MO', 'range_coverage_idx', 'binned_coverage_idx', 'overlap_coefficient'};

% looping through all the array names so that each array will be saved as a sheet in the excel file; below we use the array names to extract the array data using the evalin function.
for ij = 1:length(array_names_for_saving_in_excel)
    name_1 = array_names_for_saving_in_excel{1,ij};
    % checking if the array exists - because some of the arrays (arrays for comparison plots between ctrl & MO) will exist only in MO and not in Ctrl
    if evalin('base', sprintf('exist(''%s'',''var'')', name_1)) % here the command 'exist('name_1', 'var')' is processed inside evalin; this way, we check if an array of this name exists in the base workspace which is the main workspace
        arrayName = evalin('base', name_1); % extracting the data component of the name_1 using evalin and then assigning it to arrayName
        % checking the length of the sheet name; because excel cannot accept sheet names that are longer than 31 characters
        if length(name_1) > 31
            sheetname = name_1(1:31); % if the sheet name is longer than 31 characters, then we use the characters until 31 units
        else
            sheetname = name_1;
        end
        % below we start by predefining a cell array inorder to store the arrays without NaNs; Below we will remove all the NaNs in each of these columns. After removing, the subsequent data is filled in these places so
        % that there are no empty spaces because of NaN removal. If one column has more data than the other, then padding is done with empty spaces. In order to do this, we convert this array into a
        % cell array and then use empty spaces for padding.
        array_withoutNaNs_1 = cell(size(arrayName, 1), size(arrayName, 2)); % predefining a cell array
        % this for loop goes through all the columns of the array and removes the NaNs
        for col = 1:size(arrayName,2)
            nonNaNvalues = arrayName(~isnan(arrayName(:,col)),col); % using logical indexing to get the non NaN values
            array_withoutNaNs_1(1:numel(nonNaNvalues), col) = num2cell(nonNaNvalues); % saving the non NaN values in a new array - this way we not only remove the NaNs but also fill those spaces with the subsequent data
            % finding the column that has the maximum number of nonempty cells
            num_of_rows = cellfun(@(x) ~isempty(x), array_withoutNaNs_1); % first we get the logical indices for all the non NaN values in each column
            num_nonemptyrows_col = sum(num_of_rows, 1); % then we get the total no of all the '1' logical indices i.e. total no of non NaN values for each column
            col_maxNonEmptyRows = max(num_nonemptyrows_col); % then, we comapre the total no of non NaN values between all the columns and get the maximum of these columns. This number is the maximum number of non NaN value rows in the whole array
            % below, we check if there are columns that have lesser no of rows. If there are, then we pad the rest of the rows with empty spaces so that they have the same row length as the longest column
            if numel(nonNaNvalues) < col_maxNonEmptyRows
                array_withoutNaNs_1(numel(nonNaNvalues)+1:end, col) = {''};
            end
        end
        array_withoutNaNs_2 = array_withoutNaNs_1(1:col_maxNonEmptyRows,:); % because of the preassignment, there can be a lot of rows at the end that are just empty spaces. Here we reassign this matrix so that only upto those rows that I have proper values are taken forward
        array_withoutNaNs = array_withoutNaNs_2;
        if size(array_withoutNaNs, 1) <= 1048576 % this is the maximum no of rows that an excel sheet can hold
            % writing the array as an excel sheet if the no of rows in the array is within the excel row limits
            writecell(array_withoutNaNs, excel_filename, 'Sheet', sheetname);
        else
            % writing the array as .csv file if the no of rows in the array exceeds the excel row limits
            writecell(array_withoutNaNs, [sheetname, '.csv']);
        end
        clear arrayName nonNaNvalues array_withoutNaNs_1 array_withoutNaNs_2 array_withoutNaNs num_of_rows num_nonemptyrows_col
    end
end

clear array_names_for_saving_in_excel

disp('Finished !');

%% Function to retain only those values that are non zeroes and non NaNs

function [output_1, output_2] = processed_matrix(input)
output_1 = input; % reassignment
output_2 = output_1(output_1 ~= 0 & ~isnan(output_1));
end

%% Function that generates the histogram plots i.e. the frequency distribution of a particular parameter

function [a2] = pdf_distr_plots(parameter_1, parameter_2, bininterval, Xlabel, limits_x, Plot_title, legend_1, legend_2, save_link, save_title)

% Binning the data
figure(100);

% getting the histogram values for parameter 1
binparameter_1 = parameter_1(~isnan(parameter_1));
binrange_1 = min(binparameter_1):bininterval:max(binparameter_1); % setting the bin range based on the input data
[N_1, ~] = histcounts(binparameter_1, binrange_1); % here 'N' corresponds to the counts or the repeats of the data; and edges is same as the binrange defined above.
binrange_mod_1 = binrange_1(1:end-1); % changing the binrange length to match the length of N so that they can be plotted together.
% barplot = bar(binrange_mod_1, N_1); barplot.FaceColor = 'r'; barplot.EdgeColor = 'b';  % barplot.LineWidth = 1; % either barplot or histogram plot can be used
histplot = histogram(binparameter_1, binrange_mod_1, 'Normalization', 'pdf'); histplot.FaceColor = 'g'; histplot.FaceAlpha = 0.3; histplot.LineWidth = 0.01; histplot.EdgeColor = 'none'; % either barplot or histogram plot can be used
hold on;

% getting the histogram values for parameter 2
binparameter_2 = parameter_2(~isnan(parameter_2));
binrange_2 = min(binparameter_2):bininterval:max(binparameter_2); % setting the bin range based on the input data
[N_2, ~] = histcounts(binparameter_2, binrange_2); % here 'N' corresponds to the counts or the repeats of the data; and edges is same as the binrange defined above.
binrange_mod_2 = binrange_2(1:end-1); % changing the binrange length to match the length of N so that they can be plotted together.
% barplot = bar(binrange_mod_2, N_2); barplot.FaceColor = 'r'; barplot.EdgeColor = 'b';  % barplot.LineWidth = 1; % either barplot or histogram plot can be used
histplot = histogram(binparameter_2, binrange_mod_2, 'Normalization', 'pdf'); histplot.FaceColor = 'k'; histplot.FaceAlpha = 0.3; histplot.LineWidth = 0.01; histplot.EdgeColor = 'none'; % either barplot or histogram plot can be used

xlabel(Xlabel);  ylabel('Probability density'); title(Plot_title);  set(gca,'fontsize',12); legend (legend_1, legend_2); save_title = strcat(save_title, '_PDF'); % xaxis_limit_min = get(gca, 'XLim'); xlim([xaxis_limit_min limits_x]);
saveas(gcf, fullfile(save_link, save_title), 'fig'); saveas(gcf, fullfile(save_link, save_title), 'tif');
close (figure(100));

% below we concatenate the two input vectors 'binparameter_1' & 'binparameter_2' so that they are stored as one matrix and is easy for saving in the excel sheet for future statistical analysis
a0 = {binparameter_1, binparameter_2}; % concatenating two arrays with different lengths as cell array
a1 = nan_padding(a0); % padding the length difference (between the arrays) with NaNs
a2 = [a1(:,1), a1(:,2)]; % concatenating the two columns of the cell array and storing them as a standard matrix

end

%% Function that generates the CDF plots i.e. alternative to the PDF plots

function cdf_distr_plots(parameter_1, parameter_2, Xlabel, Plot_title, legend_1, legend_2, save_link, save_title)
figure(101);

cdf_1 = cdfplot(parameter_1); set(cdf_1, 'LineStyle', '-', 'Color', 'g');
hold on;
cdf_2 = cdfplot(parameter_2); set(cdf_2, 'LineStyle', '-', 'Color', 'k');
xlabel(Xlabel);  ylabel('Cumulative probability'); title(Plot_title);  set(gca,'fontsize',12); legend (legend_1, legend_2); save_title = strcat(save_title, '_CDF');
if ~contains(save_title, 'step_distance_individTraj')
    saveas(gcf, fullfile(save_link, save_title), 'fig');
    % saving the plot as '.fig' format - The function, 'savefig', used below allows to save large sized .fig files using the -v7.3 automatically
    % figpath = fullfile(save_link, [save_title, '.fig']); savefig(gcf, figpath);
end
% saving the plot as .tif format
saveas(gcf, fullfile(save_link, save_title), 'tif');

close (figure(101));

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

%%

