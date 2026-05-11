% Raghavan Thiagarajan, reNEW, Copenhagen, 22nd November 2022

% This script is to generate a frame-wise matrix of tessalated areas and
% get the variance of the tessalated areas for every frame. This script is
% to be run after making voronoi tessalations of basal bodies in Fiji and
% running the "Analyze particles".

close all;
clear all;
clc;

mkdir '../Plots/tessalation'
BB_apical = '../Plots/tessalation'; % location where the plots will be saved

load('workspace_with_t0_data.mat', 'increment_index_area_final'); % loading the 'increment_index_area_final' which contains the all the parameters after grouping areas in 10% bins

% 1 - processing all tessalations including the edge tessalations; 
% 2 - processing after excluding the border cells (i.e. after excluding edge tessalations)

for operation_type = 1:2

    if operation_type == 1
        tessalated_results = readtable('../tessalation/Results.csv','PreserveVariableNames',true); % tessalation results that includes all the cells within the apical domain
        tessalated_summary = readtable('../tessalation/Summary_of_voronoi_apical_domain.csv','PreserveVariableNames',true); % tessalation results that includes all the cells within the apical domain
        title_suffix = '(all tessalations)';
        save_name = '_all_tessalations';
        workspace_name = 'workspace_tessalations_all';
    else
        tessalated_results = readtable('../tessalation/Results_without_border_cells.csv','PreserveVariableNames',true); % tessalation results that does not include border cells i.e. the cells close to the periphery of the apical domain (because they make big areas due to the way the voronoi tessalation is made)
        tessalated_summary = readtable('../tessalation/Summary_of_voronoi_apical_domain_without_border_cells.csv','PreserveVariableNames',true); % tessalation results that does not include border cells i.e. the cells close to the periphery of the apical domain (because they make big areas due to the way the voronoi tessalation is made)
        title_suffix = '(without border cells)';
        save_name = '_without_border_cells';
        workspace_name = 'workspace_tessalations_without_border_cells';
    end

[tessal_result_row,tessal_result_col] = size(tessalated_results); % get the no of rows and columns in the imported table
[tessal_summary_row,tessal_summary_col] = size(tessalated_summary); % get the no of rows and columns in the imported table

tot_frames = max(tessalated_results.Slice); % get the total number of frames in the stack
frames_with_bb = length(tessalated_summary.Slice); % get the total number of frames that are tessalated
max_tessalations = max(tessalated_summary.Count); % getting the maximum number of tessalations within one frame in the stack
cols = nan(max_tessalations, tot_frames); % creating a matrix to store the voronoi tessalation areas for each frame
slice_list = nan(frames_with_bb, 1); % getting the list of the frame numbers that are tessalated
incrmnt_idx_area_fin_area_col = nan((100*size(cols,1)), size(increment_index_area_final,1)-1);

% this for loop goes through all the frames with tessalations, gets the
% areas for all tessalations for every frame and sorts them in a frame-wise
% manner. Also it gets the variance of the tessalated areas.
for curr_slice = 1 : frames_with_bb
    
    no_of_entries = length(find(tessalated_results.Slice == curr_slice)); % getting the no of tessalations in the frame "curr_slice"
    
    if no_of_entries > 2 % this is to make sure that only frames with tessalations are further processed (frames with less than 2 BBs will not be tessalated)
        
        slice_list(curr_slice) = curr_slice; % getting the list of frames that are tessalated
        start_idx = find(tessalated_results.Slice == curr_slice, 1, 'first'); % get the index of the first entry for the slice no "curr_slice"
        end_idx = find(tessalated_results.Slice == curr_slice, 1, 'last' ); % get the index of the last entry for the slice no "curr_slice"
        secnd_idx = start_idx + 1; % get the index of the second entry for the slice no "curr_slice"
        area_column = tessalated_results.Area(secnd_idx:end_idx); % getting the areas of the tessalations for the frame "curr_slice"
        cols(1:size(area_column),curr_slice) = area_column; % filling the array "cols" with the tessalated areas - in future this matrix can be used to obtain all the tessalated areas in case I want to plot using origin lab
        mean_voronoi(curr_slice,1) = nanmean(cols(:,curr_slice)); % getting the mean for the tessalated areas for every frame; the unit of mean area is micrometer squared
        variance_voronoi_temp = nanvar(cols(:,curr_slice)); % getting the variance for the tessalated areas for every frame
        stdev_voronoi_temp = nanstd(cols(:,curr_slice)); % getting the standard deviation for the tessalated areas for every frame
        if variance_voronoi_temp == 0 && stdev_voronoi_temp == 0; variance_voronoi_temp = 0.01; stdev_voronoi_temp = 0.01; end % this one-line if loop is to make sure that the variance & standard deviation get a minimal value during situations where the variance & stdev are zero (For example when all the values for which we are finding the variance are same).
        variance_voronoi(curr_slice,1) = variance_voronoi_temp;      
        stdev_voronoi(curr_slice,1) = stdev_voronoi_temp;
        
        % the for loop is taken from the t0 and tend basalbody scripts.
        % the for loop below makes sure that the frames that have apical areas within a 10% range are grouped together so that their tessalation areas can be plotted as CDFs.
        for row_valu_1 = 1:length(increment_index_area_final)
            if curr_slice == increment_index_area_final(end,1)
                [row_nan, col_nan] = find(isnan(incrmnt_idx_area_fin_area_col(:,end)), 1, 'first');
                end_idx = (row_nan + length(area_column))-1;
                incrmnt_idx_area_fin_area_col(row_nan:end_idx, end) = area_column;
                break
            elseif (curr_slice >= increment_index_area_final(row_valu_1,1) && curr_slice < increment_index_area_final(row_valu_1+1,1))
                [row_nan, ~] = find(isnan(incrmnt_idx_area_fin_area_col(:,row_valu_1)), 1, 'first');
                end_idx = (row_nan + length(area_column))-1;
                incrmnt_idx_area_fin_area_col(row_nan:end_idx, row_valu_1) = area_column;
                break
            end
        end
    end
end

% getting some parameters from the previous analysis
load('workspace_interim.mat', 'Time_interval', 'Area_apicaldomain', 'No_of_BB'); % loading only the time interval and area of apical domain
time = slice_list * Time_interval;
area_orig = Area_apicaldomain;
variance_voronoi_fin = variance_voronoi; % reassignment
variance_voronoi_fin(variance_voronoi_fin==0) = NaN; % replacing all the zeros with NaNs - because frames with less than 2 bbs will not have any voronoi tessalation and will be recorded here as nan
mean_voronoi_fin = mean_voronoi; % reassignment
mean_voronoi_fin(mean_voronoi_fin==0) = NaN; % replacing all the zeros with NaNs - because frames with less than 2 bbs will not have any voronoi tessalation and will be recorded here as nan
variance_voronoi_fin_norm = variance_voronoi_fin ./ ((mean_voronoi_fin).^2); % here we divide the variance by mean voronoi area squared; the unit of mean area squared is micrometer to the power of 4; this allows the normalisation of variance since the unit of variance is micrometer to the power of 4.
stdev_voronoi_fin = stdev_voronoi; % reassignment
stdev_voronoi_fin(stdev_voronoi_fin==0) = NaN; % replacing all the zeros with NaNs - because frames with less than 2 bbs will not have any voronoi tessalation and will be recorded here as nan
stdev_voronoi_fin_norm = stdev_voronoi_fin ./ mean_voronoi_fin; % here we divide the stDev by mean area; the unit of mean area is micrometer squared; this allows the normalisation of stDev since the unit of stDev is micrometer squared.

figure(1)
% plot(time, variance_voronoi_fin, 'b-x', 'Linewidth', 0.8); ylabel('Variance of tessalation areas'); 
plot(time, variance_voronoi_fin_norm, 'b-x', 'Linewidth', 0.8); ylabel({'Variance of tessalation areas', '[normalised to mean area squared]'}); 
xlabel('Time [min]'); title({'Variance of tessalation areas vs Time', title_suffix}); set(gca,'fontsize',18); 
saveas(gcf, fullfile(BB_apical, strcat('Variance_of_tessalation_areas_vs_time', save_name)), 'fig'); saveas(gcf, fullfile(BB_apical, strcat('Variance_of_tessalation_areas_vs_time', save_name)), 'tif');

figure(2)
% plot(Area_apicaldomain, variance_voronoi_fin, 'r-o', 'Linewidth', 0.8); ylabel('Variance of tessalation areas'); 
plot(Area_apicaldomain, variance_voronoi_fin_norm, 'r-o', 'Linewidth', 0.8); ylabel({'Variance of tessalation areas', '[norrmalised to mean area squared]'}); 
xlabel('Area [\mum^2]'); title({'Variance of tessalation areas vs Apical Area', title_suffix}); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, strcat('Variance_of_tessalation_areas_vs_apical_area', save_name)), 'fig'); saveas(gcf, fullfile(BB_apical, strcat('Variance_of_tessalation_areas_vs_apical_area', save_name)), 'tif');

figure(3)
% plot(Area_apicaldomain, stdev_voronoi_fin, 'r-*', 'Linewidth', 0.8); ylabel('Standard deviation of tessalation areas'); 
plot(Area_apicaldomain, stdev_voronoi_fin_norm, 'r-*', 'Linewidth', 0.8); ylabel({'Standard deviation of tessalation areas', '[norrmalised to mean area]'}); 
xlabel('Area [\mum^2]'); title({'StDev of tessalation areas vs Apical Area', title_suffix}); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, strcat('StDev_of_tessalation_areas_vs_apical_area', save_name)), 'fig'); saveas(gcf, fullfile(BB_apical, strcat('StDev_of_tessalation_areas_vs_apical_Area', save_name)), 'tif');

figure(4)
% plot(No_of_BB, variance_voronoi_fin, 'k-o', 'Linewidth', 0.8); ylabel('Variance of tessalation areas'); 
plot(No_of_BB, variance_voronoi_fin_norm, 'k-o', 'Linewidth', 0.8); ylabel({'Variance of tessalation areas', '[norrmalised to mean area squared]'}); 
xlabel('BB count'); title({'Variance of tessalation areas vs BB count', title_suffix}); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, strcat('Variance_of_tessalation_areas_vs_BB_count', save_name)), 'fig'); saveas(gcf, fullfile(BB_apical, strcat('Variance_of_tessalation_areas_vs_BB_count', save_name)), 'tif');

figure(5)
color_cellarray = {'g', 'c', 'y', 'r', 'm', rgb('HotPink'), rgb('GreenYellow'), rgb('Indigo'), rgb('IndianRed'), rgb('BlueViolet'), rgb('Tomato'), rgb('LimeGreen'),'b', rgb('BlanchedAlmond'), rgb('Violet'), rgb('PaleGreen'), rgb('Gold'), rgb('Maroon'), rgb('Orange')};
firstNonNaNcol = find(any(~isnan(incrmnt_idx_area_fin_area_col)), 1 , 'first'); % here we find the first column that has non NaN values. Since this CDF plots the tessalation area of every 10% area, sometimes, within this 10% area, there are no BBs. Therefore this column (corresponding to this 10% area) gets
% recorded as NaNs. NaNs cannot be plotted as CDF and this loop throws an
% error. To avoid this, we find the first column that has non NaN values and use that as the starting value where the loop starts.
for i = firstNonNaNcol : size(incrmnt_idx_area_fin_area_col,2)
    area_pct = increment_index_area_final(i+1,4); area_pct = num2str(area_pct);
    lgnd = strcat('Area percentage =  ', area_pct, '%');
    cdf_plot = cdfplot(incrmnt_idx_area_fin_area_col(:,i)); set(cdf_plot, 'LineStyle', '-', 'LineWidth', 2, 'DisplayName', lgnd, 'color', color_cellarray{i});
    hold on
end
legend ('location', 'northeast'); 
xlabel('Area [\mum^2]'); ylabel('F(x)'); title({'Tessalation areas at 10% interval (CDF)', title_suffix}); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, strcat('CDF_of_tessalation_areas_at_10%_interval', save_name)), 'fig'); saveas(gcf, fullfile(BB_apical, strcat('CDF_of_tessalation_areas_at_10%_interval', save_name)), 'tif');

close all;

save(workspace_name);
clearvars -except BB_apical increment_index_area_final

end

%%
% Saving the figures as montage
montage_fig = '../Plots/montage';
fig1 = fullfile(BB_apical, 'Variance_of_tessalation_areas_vs_time_all_tessalations.tif');
fig11 = fullfile(BB_apical, 'Variance_of_tessalation_areas_vs_time_without_border_cells.tif');

fig2 = fullfile(BB_apical, 'Variance_of_tessalation_areas_vs_apical_Area_all_tessalations.tif');
fig22 = fullfile(BB_apical, 'Variance_of_tessalation_areas_vs_apical_Area_without_border_cells.tif');

fig3 = fullfile(BB_apical, 'StDev_of_tessalation_areas_vs_apical_Area_all_tessalations.tif');
fig33 = fullfile(BB_apical, 'StDev_of_tessalation_areas_vs_apical_Area_without_border_cells.tif');

fig4 = fullfile(BB_apical, 'Variance_of_tessalation_areas_vs_BB_count_all_tessalations.tif');
fig44 = fullfile(BB_apical, 'Variance_of_tessalation_areas_vs_BB_count_without_border_cells.tif');

fig5 = fullfile(BB_apical, 'CDF_of_tessalation_areas_at_10%_interval_all_tessalations.tif');
fig55 = fullfile(BB_apical, 'CDF_of_tessalation_areas_at_10%_interval_without_border_cells.tif');

montage({fig1, fig11, fig2, fig22, fig3, fig33, fig4, fig44, fig5, fig55});
saveas(gcf, fullfile(montage_fig,'slide_17_bb_distribution_from_tessalation_areas'), 'tif');

close all;

disp('Finished !');

%%








