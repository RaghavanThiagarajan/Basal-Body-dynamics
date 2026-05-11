%%
close all;
clear all;
clc;
disp('Copy the empty images to input folder. Then press a key !')
pause;

%%
% The below logic to create a table (.csv file) that contains, apical domain areas (in the 2nd column) with a 10% increase between areas.  Meaning, starting from the first
% area (or the first frame), the areas are incremented by 10% and only these areas are included in this table. It will be more clear if you look at the third column where the
% starting value is the percentage of area (w.ro.to the maximum area the apical domain reaches). Then starting from this first value, subsequent areas with 10 % increase are found and listed.
% The first column is the indices of all these areas obtained from the Area_apicaldomain and area_percent. The second column is the areas in micrometer squared. Fourth column is 
% the actual area percent that is closest (based on the area_apicaldomain) to the calculated area percent in the third column.

load('workspace_interim.mat', 'Framelist', 'Timelist', 'Area_apicaldomain'); % loading only the time interval and area of apical domain
area_percent = round((Area_apicaldomain(:,1) * 100) / max(Area_apicaldomain)); % calculating the area percent starting from the first area (or first frame) w.r.to the maximum area of the apical domain.

pch = 1; % intitiation value
increment_index_area(pch,1) = pch; % starting index value
increment_index_area(pch,2) = Area_apicaldomain(pch); % starting Area apical domain
increment_index_area(pch,3) = area_percent(pch); % starting caclulated area percent
increment_index_area(pch,4) = area_percent(pch); % starting actual area percent
curr_area_percent = area_percent(pch);

% This while loop goes through the "area_percent" array and only gets the area_percent with an incrementation of 10% starting from the first value. Then it gets the corresponding index, 
% actual area, and the actual area_percent.
while curr_area_percent < 100
    curr_area_percent = increment_index_area(pch,3) + 10;
    [c, incre_area_index] = min(abs(area_percent - curr_area_percent));
    % this if loop is used to combine the subsequent area percent with the previous areapercent if the no of frames between the two area percent
    % is less than 5 frames. (this was arbitrarily chosen to have a minimum of 5> frames between two area percents separated by 10%)
    if (incre_area_index - pch) < 5
      increment_index_area(pch,1:4) = 0;
    end    
    pch = incre_area_index;
    increment_index_area(pch,1) = incre_area_index;
    increment_index_area(pch,2) = Area_apicaldomain(pch);
    increment_index_area(pch,3) = curr_area_percent;
    increment_index_area(pch,4) = area_percent(pch);    
end

% in some cases, the area reaches a plateau and within this plateau the maximum area (or 100% area) is reached before the final time point. In
% that case, the areas in the frames following the frame that had 100% area will be recorded as negative percentages and also it doesnt make any sense
% to make increments of 10% after reaching the 100% area. This if loop takes care of this issue. If the 100% area is reached before the final
% frame, then the following frames are split into 15 frames and then they are concatenated to the lists that were generated in the previous while
% loop. To avoid confusion, take a data set where the 100% area is reached before the last frame and check the third and fourth columns. It will be easy to understand.
if pch < length(area_percent)    
    for pch_ext = (pch+15): 15 : length(area_percent)
        pch = pch_ext;
        increment_index_area(pch,1) = pch;
        increment_index_area(pch,2) = Area_apicaldomain(pch);
        increment_index_area(pch,3) = area_percent(pch);
        increment_index_area(pch,4) = area_percent(pch);
    end    
    %this if loop is to make sure the last frame is recorded even if it does not satisfy the 15 frame difference.
    if pch ~= length(area_percent)
        pch = length(area_percent);
        increment_index_area(pch,1) = pch;
        increment_index_area(pch,2) = Area_apicaldomain(pch);
        increment_index_area(pch,3) = area_percent(pch);
        increment_index_area(pch,4) = area_percent(pch);
    end
end

% Here we remove all the zeros to get only those values that are incremented by 10%
no_of_non_zero_rows = sum(~(all(increment_index_area==0,4)));
nonzero_increment_index_area = nonzeros(increment_index_area);
increment_index_area_final = reshape(nonzero_increment_index_area, no_of_non_zero_rows(1,1), 4);
% Here the data is saved as a table for future reference.
table_saving = table(increment_index_area_final(:,1), increment_index_area_final(:,2), increment_index_area_final(:,3), increment_index_area_final(:,4), 'VariableNames', {'Index_from_Area_apicaldomain', 'Actual_area_from_Area_apicaldomain','Calculated_area_percent', 'Actual_area_percent_from_area_percent'});
lctn = fullfile('../data', 'Area_percent.csv');
writetable(table_saving, lctn, 'WriteVariableNames', true);

clearvars -except increment_index_area_final
load('workspace_interim.mat');

% disp('Finished !');

%% Getting the first time point (t0) / frame no of basal body appearance

nu_of_trajectories = no_of_trajectories;

TrajecInitPos = zeros(nu_of_trajectories,4);
for trajno = 1:nu_of_trajectories
    trajno_check (trajno) = trajno;
    kend = length(Trajectory_data{trajno,1});
    
    % this is to make sure that only those trajectories that are longer than "traj_filter_duration" (in no of frames) are taken for analysis - smaller trajectories are not plotted 
    if kend <= traj_filter_duration % "traj_filter_duration" corresponds to the time (in frames) chosen based on the tracking plugin output. Check the "value_for_filter.txt". Check the description
        % in the first few lines of this script where this value "traj_filter_duration" is obtained as input.
        continue
    else
        TrajecInitPos(trajno,1) = trajno; % Getting the trajectory no.
        TrajecInitPos(trajno,2) = Trajectory_data{trajno,2}(1,1); % Getting the first frame at which the basalbody appears
        TrajecInitPos(trajno,3) = Trajectory_data{trajno,3}(1,1); % Getting the first position x coordinate of the basalbody
        TrajecInitPos(trajno,4) = Trajectory_data{trajno,4}(1,1); % Getting the first position y coordinate of the basalbody
    end
end

% All those arrays that were not plotted were recorded as "0".
% So removing all "0" values from the following arrays i.e. removing all those trajectories that were not plotted.
to_be_removed = (TrajecInitPos == 0); % to remove all those elements recorded as "0"
TrajecInitPos (to_be_removed) = []; % removing all those elements recorded as "0"
no_ofrows = length(TrajecInitPos) / 4; % here 4 denotes the no of columns in the "TrajecInitPos" array before reshaping;
TrajecInitPos = reshape(TrajecInitPos, [no_ofrows, 4]); % this allows to find the no of rows with which the array can be reshaped into "no_ofrows" and 4 columns

% defining non-default colors for color coding BB appearance at different frames
%c8 = rgb('Maroon'); c9 = rgb('HotPink'); c10 = rgb('Indigo'); c11 = rgb('IndianRed'); c12 = rgb('GreenYellow'); c13 = rgb('BlueViolet'); c14 =  rgb('Tomato'); c15 = rgb('LimeGreen'); c16 = rgb('BlanchedAlmond'); c17 = rgb('Violet');
%c18 =  rgb('PaleGreen'); c19 = rgb('Gold'); c20 = rgb('Orange');
color_cellarray = {'g', 'c', 'y', 'r', 'm', 'w', rgb('HotPink'), rgb('GreenYellow'), rgb('Indigo'), rgb('IndianRed'), rgb('BlueViolet'), rgb('Tomato'), rgb('LimeGreen'),'b', rgb('BlanchedAlmond'), rgb('Violet'), rgb('PaleGreen'), rgb('Gold'), rgb('Maroon'), rgb('Orange')};

% starting values for basal body counting
frame_number = 1;
bb_initial_count = 1;
iij = 1;
idx_check = 1;

frame_last = max(TrajecInitPos(:,2));
frm_nmb = zeros(1,frame_last);
TrajecInitPos_sz = length(TrajecInitPos(:,1));
for ij = 1:TrajecInitPos_sz
    framenobb = TrajecInitPos(ij,2);
    inputlink = strcat('../Plots/t0_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/bb_appearance_input/bb_');
    bbimagesinp = strcat(inputlink, sprintf('%03d',framenobb), '.tif');
    savelink_t0 = strcat('../Plots/t0_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/bb_appearance_plot/bb_');
    bbimagesave = strcat(savelink_t0, sprintf('%02d',framenobb), '.tif');
    
    if isfile(bbimagesave)
        BBforproces = imread(bbimagesave);
    else
        BBforproces = imread(bbimagesinp);
    end
    imshow(BBforproces);
    hold on
    BBimageplot = scatter(TrajecInitPos(ij,3),TrajecInitPos(ij,4));
    
    % plotting the basalbodies with different colors for a range of 20
    % frames i.e. every 20 frames the basalbody color will be changed
    % c = ceil(framenobb / 20); % this value is used for color coding the frames for BB appearance; this number was a random choice. 20 also corresponds to the number of colors in the color_array
    % BBimageplot.MarkerEdgeColor = color_cellarray{c};
    
    % the for loop below makes sure that the frames that have apical areas within a 10% range are given the same color for the basal bodies.
    for row_valu_1 = 1:length(increment_index_area_final)
        if framenobb == increment_index_area_final(end,1)
            BBimageplot.MarkerEdgeColor = color_cellarray{length(increment_index_area_final)-1};
            break
        elseif (framenobb >= increment_index_area_final(row_valu_1,1) && framenobb < increment_index_area_final(row_valu_1+1,1))
            BBimageplot.MarkerEdgeColor = color_cellarray{row_valu_1};
            break
        end
    end      
    
    % getting count of the basalbodies appearing at every frame
    if (frame_number == framenobb)
        frm_nmb (iij) = frame_number;
        basalbody_count(iij) = bb_initial_count;
    else
        if frm_nmb (framenobb) == framenobb % This if loop makes sure to increment the BB count for the same frame if there are already BBs present
            frm_nmb (framenobb) = framenobb;
            basalbody_count(framenobb) =  basalbody_count(framenobb) + 1;
        else
            while frame_number ~= framenobb
                frame_number = TrajecInitPos(idx_check,2);
                iij = TrajecInitPos(idx_check,2);
                idx_check = idx_check + 1;
            end
            idx_check = 1;
            frm_nmb(iij) = frame_number;
            bb_initial_count = 1;
            basalbody_count(iij) = bb_initial_count;
        end
    end
    bb_initial_count = bb_initial_count + 1;
    
    
    f = getframe(gca);
    im = frame2im(f);
    imwrite(im,bbimagesave);
end

close all

% this for loop is just to fill the image sequence if in case there are
% frames where there are no basal bodies getting initiated
for ij = 1:max(Frame_no)
    bbimagesinp = strcat(inputlink, sprintf('%03d',ij), '.tif');
    bbimagesave = strcat(savelink_t0, sprintf('%02d',ij), '.tif');
    if isfile(bbimagesave)
        continue
    else
        bbi = imread(bbimagesinp);
        imshow(bbi);
        f = getframe(gca);
        im = frame2im(f);
        imwrite(im,bbimagesave);
    end
    
end

close all

savelink_t0 = strcat('../Plots/t0_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/');
forsav = strcat(savelink_t0, 'TrajecInitPos', '.csv');
csvwrite(forsav, TrajecInitPos);

% The number of trjectories is redefined here to be used in the next section
% Previously the number of trajectories corresponds to all the trajectories for all the appearing basal bodies); Then within the loop (while processing/plotting these trajectories) only those trajectories that are
% longer than "traj_filter_duration" (no of frames) were selected.
% However here the nu_of_trajectories corresponds to only those trajectories that are longer than "traj_filter_duration" (no of frames). This change is done because of the way the data is stored in those files from which the data is input.

nu_of_trajectories = TrajecInitPos(:,1);
sz_nu_of_trajectories = size(nu_of_trajectories);
nu_of_trajectories = sz_nu_of_trajectories(1,1);

frm_nmb_time = frm_nmb * Time_interval;
frm_nmb_time_zeroremoved = frm_nmb_time(frm_nmb_time~=0);
diff_in_frm_nmb_time_zeroremoved = frm_nmb_time_zeroremoved(2:end) - frm_nmb_time_zeroremoved(1:end-1);  % getting the difference in time between the subsequent BB entry frames
frm_nmb_time_zeroremoved = frm_nmb_time_zeroremoved(1,(2:end));
basalbody_count_original = basalbody_count; 
basalbody_count_modified = basalbody_count(basalbody_count~=0);
basalbody_count_modified_rate = basalbody_count_modified(1,(2:end)) ./ diff_in_frm_nmb_time_zeroremoved; % This gives the rate: no of bb per minute

figure(1);
stem(frm_nmb_time_zeroremoved, basalbody_count_modified_rate);
xlabel('Time [min]');  ylabel('BB entry rate (BB min^{-1})'); title('BB entry rate');
set(gca,'fontsize',18);
saveas(gcf, fullfile(savelink_t0, 'BB_entry_rate_time'),'fig'); saveas(gcf, fullfile(savelink_t0, 'BB_entry_rate_time'),'tif');

figure(2);
yyaxis left
stem(frm_nmb_time, basalbody_count_original);
yyaxis right
plot(Timepoint_2, MeanIntensity_apicaldomain, '-rx','LineWidth', 0.8);
xlabel('Time [min]');  yyaxis left; ylabel('BB entry count'); title('BB entry count and actin mean intensity');
yyaxis right; ylabel('Mean intensity [a.u]');
set(gca,'fontsize',18);
saveas(gcf, fullfile(savelink_t0, 'BB_entry_count_MeanInt_vs_time'),'fig'); saveas(gcf, fullfile(savelink_t0, 'BB_entry_count_MeanInt_vs_time'),'tif');

figure(3);
yyaxis left
stem(frm_nmb_time, basalbody_count_original);
yyaxis right
plot(Timepoint_2, TotalIntensity_apicaldomain, '-rx','LineWidth', 0.8);
xlabel('Time [min]');  yyaxis left; ylabel('BB entry count'); title('BB entry count and actin total intensity vs Area');
yyaxis right; ylabel('Total intensity [a.u]');
set(gca,'fontsize',18);
saveas(gcf, fullfile(savelink_t0, 'BB_entry_count_TotalInt_vs_time'),'fig'); saveas(gcf, fullfile(savelink_t0, 'BB_entry_count_TotalInt_vs_time'),'tif');

close all

%%
% The following is done to plot the BB flux which is: No of BB per unit time per unit area
% This "for" loop is to get the corresponding "area" values for the t0 frames of all trajectories. 

frm_nmb_modified = frm_nmb(frm_nmb~=0);
for iab = 1:length(basalbody_count_modified) % this loop goes through the the array that contains the t0 of all trajectories
    frame_t0_BB_getting_value(iab) = frm_nmb_modified(iab); % getting individually the t0 of all trajectories one by one
    Area_t0_BB(iab) = Area_apicaldomain(frame_t0_BB_getting_value(iab)); % Finding the corresponding area for the t0 frame of every trajectory
end

frm_nmb_time_modified = frm_nmb_modified * Time_interval;
frm_nmb_time_modified = frm_nmb_time_modified(1,(2:end));
Area_t0_BB = Area_t0_BB(1,(2:end));
BB_flux = basalbody_count_modified_rate ./ Area_t0_BB;
BB_flux = BB_flux(1,(1:end));
Area_t0_BB = Area_t0_BB(1,(1:end));

figure(1);
bbflux_fig = scatter(frm_nmb_time_modified, BB_flux, 'LineWidth',1); bbflux_fig.MarkerEdgeColor = 'k';
xlabel('Time [min]');  ylabel('BB entry flux [min^{-1}\mum^{-2}]'); title('BB entry flux'); set(gca,'fontsize',12);
saveas(gcf, fullfile(savelink_t0, 'BB_entry_flux_time'), 'fig'); saveas(gcf, fullfile(savelink_t0, 'BB_entry_flux_time'), 'tif');

figure(2);
bbflux_fig = scatter(Area_t0_BB, BB_flux, 'LineWidth',1); bbflux_fig.MarkerEdgeColor = 'k';
xlabel('Area [\mum^{2}]');  ylabel('BB entry flux [min^{-1}\mum^{-2}]'); title('BB entry flux'); set(gca,'fontsize',12);
saveas(gcf, fullfile(savelink_t0, 'BB_entry_flux_area'), 'fig'); saveas(gcf, fullfile(savelink_t0, 'BB_entry_flux_area'), 'tif');

% Plotting the figure(1) from previous section against area
figure(3);
stem(Area_t0_BB, basalbody_count_modified_rate, 'LineWidth',1);
xlabel('Area [\mum^{2}]');  ylabel('BB entry rate [min^{-1}]'); title('BB entry rate'); set(gca,'fontsize',12);
saveas(gcf, fullfile(savelink_t0, 'BB_entry_rate_area'), 'fig'); saveas(gcf, fullfile(savelink_t0, 'BB_entry_rate_area'), 'tif');

Area_t0_BB_entry_count = Area_apicaldomain(1:size(basalbody_count_original',1),1);
Area_t0_BB_entry_count(basalbody_count_original==0) = 0;

figure(4);
yyaxis left
stem(Area_t0_BB_entry_count, basalbody_count_original);
yyaxis right
plot(Area_apicaldomain, MeanIntensity_apicaldomain, '-rx','LineWidth', 0.8);
xlabel('Area [\mum^{2}]');  yyaxis left; ylabel('BB entry count'); title({'BB entry count and actin', 'mean intensity vs Area'});
yyaxis right; ylabel('Mean intensity [a.u]');
set(gca,'fontsize',18);
saveas(gcf, fullfile(savelink_t0, 'BB_entry_count_MeanInt_vs_area'),'fig'); saveas(gcf, fullfile(savelink_t0, 'BB_entry_count_MeanInt_vs_area'),'tif');

figure(5);
yyaxis left
stem(Area_t0_BB_entry_count, basalbody_count_original);
yyaxis right
plot(Area_apicaldomain, TotalIntensity_apicaldomain, '-rx','LineWidth', 0.8);
xlabel('Area [\mum^{2}]');  yyaxis left; ylabel('BB entry count'); title({'BB entry count and actin', 'total intensity vs Area'});
yyaxis right; ylabel('Total intensity [a.u]');
set(gca,'fontsize',18);
saveas(gcf, fullfile(savelink_t0, 'BB_entry_count_TotalInt_vs_area'),'fig'); saveas(gcf, fullfile(savelink_t0, 'BB_entry_count_TotalInt_vs_area'),'tif');

close all

%%
disp('Run the macro "Actin_intensity_for_bb_t0_ROIs_Traj_after_filtering.ijm". Then press a key !')
pause;

%% Getting the meanintensity of actin before and after basal body appearance

BBT0 = importdata(strcat('../Plots/t0_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/bb_t0_ROIs_data/ActInt_at&sur_BBt0_ROIs', '.csv'));
BBt0 = BBT0.data;
clear BBT0
[bbt0row, bbt0col] = size(BBt0); % to get the no of rows and columns in the imported table

Trajectory_t0 = BBt0(:,1);
Frame_t0 = BBt0(:,2);
tot_Frame_t0 = max(Frame_t0);
%nu_of_trajectories = length(); % Total no of trajectories in the imported table

Trajectory_t0_data = cell(nu_of_trajectories,bbt0col); % converting the imported table into a cell array.
counter_t0 = zeros(1,bbt0row);

% Loading the data into a cell array.
% In the this cell, each row will correspond to a basal body (bb) trajectory and each column will correspond to a parameter. Column1 - Trajectory no;
% Column 2 - Frame number; Column3 - xcoordinate of the bb; Column4 - ycoordinate of the bb; Column5 - MeanIntBBposition; Column6 - TotalIntBBposition;
% Column7 - MeanIntBBsurround; Column8 - TotalIntBBsurround; Column9 - Area at BBposition; Column10 - Perimeter at BBposition;
% Column11 - Area sorrounding BB position; Column12 - Perimeter surrounding BBposition; Column13 - Speed of basalbodies.
for i = 1:nu_of_trajectories
    actual_trajectory_no = TrajecInitPos(i,1);
    for j = 1:bbt0col
        for k = 1:bbt0row
            if Trajectory_t0(k) == actual_trajectory_no
                counter_t0(k) = k;
            end
        end
        countlist_t0 = unique(counter_t0);
        clear counter_t0;
        if countlist_t0(1) == 0
            rowstartvalue_t0 = countlist_t0(2);
        else
            rowstartvalue_t0 = countlist_t0(1);
        end
        rowendvalue_t0 = countlist_t0(end);
        Trajectory_t0_data{i,j} = BBt0((rowstartvalue_t0:rowendvalue_t0),j);
    end
    
end
%%
% Loading the raw actin mean intensity for the whole domain from files that were obtained from the imageJ processing
% this raw actin mean intensity can be used for normalizing the actin intensity at the position of BB appearance
raw_mean_int_whole_domain = nan(No_of_timepoints,1);
for noftime = 1:No_of_timepoints    
    WholeROImeasure = strcat(WholeRoimeasure, sprintf('%01d',noftime), '.txt');
    Whole_roimeasure = importdata(WholeROImeasure);
    Whole_roi_measure = Whole_roimeasure.data;
    raw_mean_int_whole_domain(noftime,1) = Whole_roi_measure(1,3);
    clear Whole_roimeasure;
    clear Whole_roi_measure;   
end

actinatBBpos = zeros(nu_of_trajectories,11);
for trajno = 1:nu_of_trajectories %nu_of_trajectories
    trajlengthh = length(Trajectory_t0_data{trajno,1});
    
    % this is to make sure that only those trajectories that are longer than "traj_filter_duration" (in no of frames) are taken for analysis - smaller trajectories are not plotted 
    if trajlengthh <= traj_filter_duration % "traj_filter_duration" corresponds to the time (in frames) chosen based on the tracking plugin output. Check the "value_for_filter.txt". Check the description
        % in the first few lines of this script where this value "traj_filter_duration" is obtained as input.
        continue
    else
        tzeroframe = Trajectory_t0_data{trajno,2}(1,1); % Getting the first frame at which the basalbody appears
        if (tzeroframe >= 5) && (tzeroframe <= (tot_Frame_t0-4)) % making sure that there are atleast 4 frames before and after the basal body appearance
            actinatBBpos(trajno,1) = trajno; % Getting the trajectory no.
            actinatBBpos(trajno,2) = Trajectory_t0_data{trajno,2}(1,1); % Getting the first frame at which the basalbody appears
            actinatBBpos(trajno,7) = Trajectory_t0_data{trajno,5}(tzeroframe,1); % Getting the mean intensity at the first frame in which the basalbody appears, at the position of basalbody.
            actinatBBpos(trajno,7) = actinatBBpos(trajno,7) / raw_mean_int_whole_domain(tzeroframe,1); % cortex_meanint{1,tzeroframe};
            
            actinatBBpos(trajno,3) = Trajectory_t0_data{trajno,5}((tzeroframe - 4),1); % Getting the mean intensity at four frames before the frame at which the basalbody appears, at the position of basalbody.
            actinatBBpos(trajno,3) = actinatBBpos(trajno,3) / raw_mean_int_whole_domain(tzeroframe-4,1); % cortex_meanint{1,(tzeroframe-4)};
            actinatBBpos(trajno,4) = Trajectory_t0_data{trajno,5}((tzeroframe - 3),1); % Getting the mean intensity at three frames before the frame at which the basalbody appears, at the position of basalbody.
            actinatBBpos(trajno,4) = actinatBBpos(trajno,4) / raw_mean_int_whole_domain(tzeroframe-3,1); % cortex_meanint{1,(tzeroframe-3)};
            actinatBBpos(trajno,5) = Trajectory_t0_data{trajno,5}((tzeroframe - 2),1); % Getting the mean intensity at two frames before the frame at which the basalbody appears, at the position of basalbody.
            actinatBBpos(trajno,5) = actinatBBpos(trajno,5) / raw_mean_int_whole_domain(tzeroframe-2,1); % cortex_meanint{1,(tzeroframe-2)};
            actinatBBpos(trajno,6) = Trajectory_t0_data{trajno,5}((tzeroframe - 1),1); % Getting the mean intensity at one frame before the frame at which the basalbody appears, at the position of basalbody.
            actinatBBpos(trajno,6) = actinatBBpos(trajno,6) / raw_mean_int_whole_domain(tzeroframe-1,1); % cortex_meanint{1,(tzeroframe-1)};
            
            actinatBBpos(trajno,8) = Trajectory_t0_data{trajno,5}((tzeroframe + 1),1); % Getting the mean intensity at one frame after the frame at which the basalbody appears, at the position of basalbody.
            actinatBBpos(trajno,8) = actinatBBpos(trajno,8) / raw_mean_int_whole_domain(tzeroframe+1,1); % cortex_meanint{1,(tzeroframe+1)};
            actinatBBpos(trajno,9) = Trajectory_t0_data{trajno,5}((tzeroframe + 2),1); % Getting the mean intensity at two frames after the frame at which the basalbody appears, at the position of basalbody.
            actinatBBpos(trajno,9) = actinatBBpos(trajno,9) / raw_mean_int_whole_domain(tzeroframe+2,1); % cortex_meanint{1,(tzeroframe+2)};
            actinatBBpos(trajno,10) = Trajectory_t0_data{trajno,5}((tzeroframe + 3),1); % Getting the mean intensity at three frames after the frame at which the basalbody appears, at the position of basalbody.
            actinatBBpos(trajno,10) = actinatBBpos(trajno,10) / raw_mean_int_whole_domain(tzeroframe+3,1); % cortex_meanint{1,(tzeroframe+3)};
            actinatBBpos(trajno,11) = Trajectory_t0_data{trajno,5}((tzeroframe + 4),1); % Getting the mean intensity at four frames after the frame at which the basalbody appears, at the position of basalbody.
            actinatBBpos(trajno,11) = actinatBBpos(trajno,11) / raw_mean_int_whole_domain(tzeroframe+4,1); % cortex_meanint{1,(tzeroframe+4)};
        else
            continue
        end
    end
end
beforeprocessing = actinatBBpos;

% mintzeroframe = zeros(nu_of_trajectories,1);
% for trajno = 1:nu_of_trajectories
%     mintzeroframee = actinatBBpos(trajno,:);
%     %mintzerofram = mintzeroframee(mintzeroframee~=0);
%     mintzeroframe(trajno,1) = min(mintzeroframee);
% end
%
% for trajno = 1:nu_of_trajectories
%     actinatBBpos(trajno,3:11) = actinatBBpos(trajno,3:11) / mintzeroframe(trajno,1);
% end


% the for loop below is used if normalization is done w.r.to the t0/tend value.
% for trajno = 1:nu_of_trajectories
%     actinatBBpos(trajno,3:11) = actinatBBpos(trajno,3:11) / actinatBBpos(trajno,7);
% end

% the statement below is used (uncommented) if the above for loop is not used i.e. if the normalization w.r.to t0/tend value is not done. 
% if the above for loop is used, then this statement needs to be commented
actinatBBpos(actinatBBpos==0) = NaN;

% Getting the sum of all trajectories to make it one plot
sum_actinatBBpos = nansum(actinatBBpos);
avg_actinatBBpos = nanmean(actinatBBpos);
std_actinatBBpos = nanstd(actinatBBpos);


%%
xaxisvalues = {'t-4','t-3','t-2','t-1','t0','t+1','t+2','t+3','t+4'};
figure3 = figure;
axes3 = axes('Parent',figure3,'XTickLabel',xaxisvalues(1,:));
box(axes3,'on');
hold(axes3,'all');
plot(actinatBBpos(:,3:11)');
ylabel('Mean intensity of Actin'); title('Actin intensity during BB appearance');
set(gca,'fontsize',18);
saveas(gcf, fullfile(savelink_t0, 'Actin_intensity_during_BB_appearance_individual_trajectories'),'fig'); saveas(gcf, fullfile(savelink_t0, 'Actin_intensity_during_BB_appearance_individual_trajectories'),'tif');

figure4 = figure;
axes4 = axes('Parent',figure4,'XTickLabel',xaxisvalues(1,:));
box(axes4,'on');
hold(axes4,'all');
plot(sum_actinatBBpos(:,3:11)');
ylabel('Mean intensity of Actin'); title('Actin intensity during BB appearance (sum across trajectories)');
set(gca,'fontsize',10);
saveas(gcf, fullfile(savelink_t0, 'Actin_intensity_during_BB_appearance_Sum'),'fig'); saveas(gcf, fullfile(savelink_t0, 'Actin_intensity_during_BB_appearance_Sum'),'tif');

figure5 = figure;
axes5 = axes('Parent',figure5,'XTickLabel',xaxisvalues(1,:));
box(axes5,'on');
hold(axes5,'all');
hold on;
plot(avg_actinatBBpos(:,3:11)');
ylabel('Mean intensity of Actin'); title('Actin intensity during BB appearance (Average across trajectories)');
set(gca,'fontsize',10);
saveas(gcf, fullfile(savelink_t0, 'Actin_intensity_during_BB_appearance_Avg'),'fig'); saveas(gcf, fullfile(savelink_t0, 'Actin_intensity_during_BB_appearance_Avg'),'tif');

% Figure 6 is same as Figure 5 except that the "Standard deviation" along
% with the mean. Extra functionalities had to be added in order to plot the
% standard deviation as shaded area. These are explained below in comments
figure6 = figure;
x_dummy = 1:1:length(avg_actinatBBpos(:,3:11)'); % dummy x axis is created to be used for filling the area between the standard deviations to obtain the shaded area.
axes5 = axes('Parent',figure6,'XTickLabel',xaxisvalues(1,:));
box(axes5,'on');
hold(axes5,'all');
curve1 = avg_actinatBBpos(:,3:11) + std_actinatBBpos(:,3:11); % getting the positive standard deviation
curve2 = avg_actinatBBpos(:,3:11) - std_actinatBBpos(:,3:11); % getting the negative standard deviation
secondaxis = [x_dummy, fliplr(x_dummy)]; % creating the area w.r.to x axis to create the shade
Middle = [curve1, fliplr(curve2)]; % creating the area w.r.to y axis to create the shade
fill(secondaxis, Middle, 'k','FaceAlpha','0.1'); % filling the area
hold on;
plot(avg_actinatBBpos(:,3:11)');
ylabel('Mean intensity of Actin'); title('Actin intensity during BB appearance (Average across trajectories-withStDev)');
set(gca,'fontsize',10);
saveas(gcf, fullfile(savelink_t0, 'Actin_intensity_during_BB_appearance_Avg_STDev'),'fig'); saveas(gcf, fullfile(savelink_t0, 'Actin_intensity_during_BB_appearance_Avg_STDev'),'tif');

close all;

%%
save('workspace_with_t0_data');


%%




































