% Correlation between different parameters

%% Standard autocorrelation for any parameter

for i = 1:5 % no of columns / cells
standard_autocorrelation(Local_Clustering(~isnan(Local_Clustering(:,i)),i)); % parameter for which the correlation is to be computed % Clumping_Factor % Local_Clustering % Global_Clustering
end

%% Below: cross correlation for quadrant data

% Apical area vs Apical BB count
cross_correlation_quad_half(Area_apicaldomain, No_of_BB, '\tau [min]', 'R_{Area}_{-BB count}(\tau)', {'Area - BB Count Cross correlation', '(Whole Apical area)'}, '');

%% Apical area vs BB density
cross_correlation_quad_half(Area_apicaldomain, bb_density, '\tau [min]', 'R_{Area}_{-BB density}(\tau)', {'Area - BB density Cross correlation', '(Whole Apical area)'}, '');

%% Apical area vs Mean actin Int
cross_correlation_quad_half(Area_apicaldomain, MeanIntensity_apicaldomain, '\tau [min]', 'R_{Area}_{-Mean Act.Int.}(\tau)', {'Area - Mean Act.Int. Cross correlation', '(Whole Apical area)'}, '');

%% BB count vs Mean actin Int
cross_correlation_quad_half(No_of_BB, MeanIntensity_apicaldomain, '\tau [min]', 'R_{BB count}_{-Mean Act.Int.}(\tau)', {'BB count - Mean Act.Int. Cross correlation', '(Whole Apical area)'}, '');

%% Area vs BB count (Transverse section)
cross_correlation_quad_half(quadrant_area_reordered_norm(:, 7:8), quadrant_BBs_reordered_norm(:, 7:8), '\tau [min]', 'R_{Area}_{-BB count}(\tau)', {'Area-BB Count Cross correlation', '(Transverse section)'}, '2_top_bottom');

%% Area vs BB density (Transverse section)
cross_correlation_quad_half(quadrant_area_reordered(:,7:8), quadrant_bb_density_reordered(:,7:8), '\tau [min]', 'R_{Area}_{-BB density}(\tau)', {'Area-BB density Cross correlation', '(Transverse section)'}, '2_top_bottom');

%% BB count vs Mean actin Intensity (Transverse section)
cross_correlation_quad_half(quadrant_BBs_reordered(:, 7:8), quad_halves_meanint_norm_reordered(:, 7:8), '\tau [min]', 'R_{BB count}_{-Mean Act.Int.}(\tau)', {'BB Count - Mean Act. Int. Cross correlation', '(Transverse section)'}, '2_top_bottom');

%% BB density vs Mean actin Intensity (Transverse section)
cross_correlation_quad_half(quadrant_bb_density_reordered(:,7:8), quad_halves_meanint_norm_reordered(:, 7:8), '\tau [min]', 'R_{BB density}_{-Mean Act.Int.}(\tau)', {'BB density - Mean Act. Int. Cross correlation', '(Transverse section)'}, '2_top_bottom');

%% Area vs BB count (Longitudinal section)
cross_correlation_quad_half(quadrant_area_reordered(:, 9:10), quadrant_BBs_reordered(:, 9:10), '\tau [min]', 'R_{Area}_{-BB count}(\tau)', {'Area-BB Count Cross correlation', '(Longitudinal section)'}, '2_left_right');

%% Area vs BB density (Longitudinal section)
cross_correlation_quad_half(quadrant_area_reordered(:,9:10), quadrant_bb_density_reordered(:,9:10), '\tau [min]', 'R_{Area}_{-BB density}(\tau)', {'Area-BB density Cross correlation', '(Longitudinal section)'}, '2_left_right');

%% BB count vs Mean actin Intensity (Longitudinal section)
cross_correlation_quad_half(quadrant_BBs_reordered(:, 9:10), quad_halves_meanint_norm_reordered(:, 9:10), '\tau [min]', 'R_{BB count}_{-Mean Act.Int.}(\tau)', {'BB Count - Mean Act. Int. Cross correlation', '(Longitudinal section)'}, '2_left_right');

%% BB density vs Mean actin Intensity (Longitudinal section)
cross_correlation_quad_half(quadrant_bb_density_reordered(:,9:10), quad_halves_meanint_norm_reordered(:, 9:10), '\tau [min]', 'R_{BB density}_{-Mean Act.Int.}(\tau)', {'BB density - Mean Act. Int. Cross correlation', '(Longitudinal section)'}, '2_left_right');

%% Area vs BB count (Quadrants)
cross_correlation_quad_half(quadrant_area_reordered(:, 3:6), quadrant_BBs_reordered(:, 3:6), '\tau [min]', 'R_{Area}_{-BB count}(\tau)', {'Area-BB Count Cross correlation', '(Quadrants)'}, '4');

%% Area vs BB density (Quadrants)
cross_correlation_quad_half(quadrant_area_reordered(:,3:6), quadrant_bb_density_reordered(:,3:6), '\tau [min]', 'R_{Area}_{-BB density}(\tau)', {'Area-BB density Cross correlation', '(Quadrants)'}, '4');

%% BB count vs Mean actin Intensity (Quadrants)
cross_correlation_quad_half(quadrant_bb_density_reordered(:,3:6), quad_halves_meanint_norm_reordered(:, 3:6), '\tau [min]', 'R_{BB density}_{-Mean Act.Int.}(\tau)', {'BB density - Mean Act. Int. Cross correlation', '(Quadrants)'}, '4');

%% BB density vs Mean actin Intensity (Quadrants)
cross_correlation_quad_half(quadrant_bb_density_reordered(:,3:6), quad_halves_meanint_norm_reordered(:, 3:6), '\tau [min]', 'R_{BB density}_{-Mean Act.Int.}(\tau)', {'BB density - Mean Act. Int. Cross correlation', '(Quadrants)'}, '4');

%% Correlations between the areas of smaller & larger halves of top/bottom side and smaller & larger halves of left/right side
area_smaller_halves = [quadrant_area_reordered(:,7), quadrant_area_reordered(:,9)]; area_larger_halves = [quadrant_area_reordered(:,8), quadrant_area_reordered(:,10)];
cross_correlation_quad_half(area_smaller_halves, area_larger_halves, '\tau [min]', 'R_{Smaller area}_{-Larger area}(\tau)', {'Smaller area vs Larger area Cross correlation', '(Top-Bottom & Left-Right halves)'}, 'both_halves');

%% Correlations between the BB counts of smaller & larger halves of top/bottom side and smaller & larger halves of left/right side
bbcount_smaller_halves = [quadrant_BBs_reordered(:,7), quadrant_BBs_reordered(:,9)]; bbcount_larger_halves = [quadrant_BBs_reordered(:,8), quadrant_BBs_reordered(:,10)];
cross_correlation_quad_half(bbcount_smaller_halves, bbcount_larger_halves, '\tau [min]', 'R_{Smaller area BB count}_{-Larger area BB count}(\tau)', {'Smaller area BB count vs Larger area BB count Cross correlation', '(Top-Bottom & Left-Right halves)'}, 'both_halves');

%% function for cross correlation of quadrant data

function cross_correlation_quad_half(array_1, array_2, xaxis_label, yaxis_label, plot_title, legend_count)
cols = size(array_1, 2);
linecolors = ["m" "k" "b" "r"];
% marker_signs = ['.' 'o' '*' 'square'];
quadrant_legends_4 = ["Quadrant 1 (smallest)" "Quadrant 2" "Quadrant 3" "Quadrant 4 (largest)"]; legends_2_left_right = ["Smallest Longitudinal side" "Largest Longitudinal side"]; legends_2_top_bottom = ["Smallest Transverse side" "Largest Transverse side"];
both_halves = ["Transverse section" "Longitudinal section"];
for i = 1:cols
col_1 = array_1(:,i);
col_2 = array_2(:,i); cols = [col_1,col_2];
[corr_param, lag_param] = xcorr(col_1, col_2, 'unbiased');
%corr_param = corr_param - (mean(col_1, 'omitnan') * mean(col_2, 'omitnan')); 
corr_param = corr_param / max(corr_param);
figure(100); 
plot(lag_param, corr_param, 'Marker', 'o' , 'MarkerSize', 4, 'MarkerEdgeColor', linecolors(i), 'LineStyle','none'); % marker_signs(i)
hold on;
end
if legend_count == '4'
    legend(quadrant_legends_4, 'Location', 'best', 'fontsize', 10);
elseif contains(legend_count, '2_top_bottom')
    legend(legends_2_top_bottom, 'Location', 'best', 'fontsize', 10);
elseif contains(legend_count, '2_left_right')
    legend(legends_2_left_right, 'Location', 'best', 'fontsize', 10);
elseif contains(legend_count, 'both_halves')
    legend(both_halves, 'Location', 'best', 'fontsize', 10);
end
xlabel(xaxis_label); ylabel(yaxis_label); title(plot_title); set(gca,'fontsize',14);
%saveas(gcf, fullfile(savelink_parameter_plots, save_title), 'fig'); saveas(gcf, fullfile(savelink_parameter_plots, save_title), 'tif');
%close(figure(200));
end

%% function for autocorrelation of any data

function standard_autocorrelation(input_data)

[corr_param, lag_param] = xcorr(input_data, 'unbiased');
%corr_param = corr_param - (mean(col_1, 'omitnan') * mean(col_2, 'omitnan')); 
corr_param = corr_param / max(corr_param);
figure(100); 
plot(lag_param, corr_param);

end