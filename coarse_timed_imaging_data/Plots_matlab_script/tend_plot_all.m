% % Change the following:
% 
% Trajectory_data{trajno,2}(1,1) - to - Trajectory_data{trajno,2}(end,1)
% Trajectory_data{trajno,3}(1,1) - to - Trajectory_data{trajno,3}(end,1)
% Trajectory_data{trajno,4}(1,1) - to - Trajectory_data{trajno,4}(end,1)
% TrajecInitPos - to - TrajecendPos
% t0 - to -end
% T0 - to - end
% entry - to - exit
% appearance - to - disappearance
% first - to - last
% appear - to -disappear

%%
clc
close all;
clear all;
disp('Copy the empty images to input folder. Then press a key !') 
pause;

%%
% Below we load the list of areas and the corresponding frames that are obtained with a 10 % area increment. The actual logic to obtain this is already in the "t0_time_dist_spatial_plot_Traj_after_filtering.m" file. 
% So for more details, check the second section (i.e. after the "clear all" section) in the "t0_time_dist_spatial_plot_Traj_after_filtering.m" file. 
load('workspace_with_t0_data', 'increment_index_area_final', 'raw_mean_int_whole_domain');
% Then we load the workspace variables from the "Gradients_BB_int_normalization_by_cortex_current".
load('workspace_interim_all.mat');

%% Getting the last time point (tend) / frame no of basal body disappearance

nu_of_trajectories = no_of_trajectories;

TrajecendPos = zeros(nu_of_trajectories,4);
for trajno = 1:nu_of_trajectories
    trajno_check (trajno) = trajno;
    kend = length(Trajectory_data{trajno,1});
    
    % this is to make sure that only those trajectories that are longer than "traj_filter_duration" (in no of frames) are taken for analysis - smaller trajectories are not plotted 
    if kend <= 2 % "traj_filter_duration" corresponds to the time (in frames) chosen based on the tracking plugin output. Check the "value_for_filter.txt". Check the description
        % in the first few lines of this script where this value "traj_filter_duration" is obtained as input.
        continue
    else
        TrajecendPos(trajno,1) = trajno; % Getting the trajectory no.
        TrajecendPos(trajno,2) = Trajectory_data{trajno,2}(end,1); % Getting the last frame at which the basalbody disappears
        TrajecendPos(trajno,3) = Trajectory_data{trajno,3}(end,1); % Getting the last position x coordinate of the basalbody
        TrajecendPos(trajno,4) = Trajectory_data{trajno,4}(end,1); % Getting the last position y coordinate of the basalbody
    end
end

% All those arrays that were not plotted were recorded as "0".
% So removing all "0" values from the following arrays i.e. removing all those trajectories that were not plotted.
to_be_removed = (TrajecendPos == 0); % to remove all those elements recorded as "0"
TrajecendPos (to_be_removed) = []; % removing all those elements recorded as "0"
no_ofrows = length(TrajecendPos) / 4; % here 4 denotes the no of columns in the "TrajecendPos" array before reshaping; 
TrajecendPos = reshape(TrajecendPos, [no_ofrows, 4]); % this allows to find the no of rows with which the array can be reshaped into "no_ofrows" and 4 columns

% defining non-default colors for color coding BB disappearance at different frames
%c8 = rgb('Maroon'); c9 = rgb('HotPink'); c10 = rgb('Indigo'); c11 = rgb('IndianRed'); c12 = rgb('GreenYellow'); c13 = rgb('BlueViolet'); c14 =  rgb('Tomato'); c15 = rgb('LimeGreen'); c16 = rgb('BlanchedAlmond'); c17 = rgb('Violet'); 
%c18 =  rgb('PaleGreen'); c19 = rgb('Gold'); c20 = rgb('Orange'); 
color_cellarray = {'g', 'c', 'y', 'r', 'm', 'w', rgb('HotPink'), rgb('GreenYellow'), rgb('Indigo'), rgb('IndianRed'), rgb('BlueViolet'), rgb('Tomato'), rgb('LimeGreen'),'b', rgb('BlanchedAlmond'), rgb('Violet'), rgb('PaleGreen'), rgb('Gold'), rgb('Maroon'), rgb('Orange')};

% starting values for basal body counting
frame_number = 1;
bb_initial_count = 1;
iij = 1;
idx_check = 1;

frame_last = max(TrajecendPos(:,2));
frm_nmb = zeros(1,frame_last);
TrajecendPos_sz = length(TrajecendPos(:,1));
for ij = 1:TrajecendPos_sz
    framenobb = TrajecendPos(ij,2);
    inputlink = '../Plots/tend_basalbody_position_all/bb_disappearance_input/bb_';
    bbimagesinp = strcat(inputlink, sprintf('%03d',framenobb), '.tif');
    savelink_tend = '../Plots/tend_basalbody_position_all/bb_disappearance_plot/bb_';
    bbimagesave = strcat(savelink_tend, sprintf('%02d',framenobb), '.tif');
    
    if isfile(bbimagesave)
        BBforproces = imread(bbimagesave);
    else
        BBforproces = imread(bbimagesinp);
    end
    imshow(BBforproces);  
    hold on
    BBimageplot = scatter(TrajecendPos(ij,3),TrajecendPos(ij,4));
    
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
    
    % getting count of the basalbodies disappearing at every frame
    if (frame_number == framenobb)
        frm_nmb (iij) = frame_number;
        basalbody_count(iij) = bb_initial_count;           
    else
        if frm_nmb (framenobb) == framenobb % This if loop makes sure to increment the BB count for the same frame if there are already BBs present
            frm_nmb (framenobb) = framenobb;
            basalbody_count(framenobb) =  basalbody_count(framenobb) + 1;
        else           
            while frame_number ~= framenobb
                frame_number = TrajecendPos(idx_check,2);
                iij = TrajecendPos(idx_check,2);
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
    bbimagesave = strcat(savelink_tend, sprintf('%02d',ij), '.tif');
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

savelink_tend = '../Plots/tend_basalbody_position_all/';
forsav = strcat(savelink_tend, 'TrajecendPos', '.csv');
csvwrite(forsav, TrajecendPos);

% The number of trjectories is redefined here to be used in the next section
% Previously the number of trajectories corresponds to all the trajectories for all the disappearing basal bodies); Then within the loop (while processing/plotting these trajectories) only those trajectories that are
% longer than 2 frames were selected.
% However here the nu_of_trajectories corresponds to only those trajectories that are longer than 2 frames. This change is done because of the way the data is stored in those files from which the data is input.

nu_of_trajectories = TrajecendPos(:,1);
sz_nu_of_trajectories = size(nu_of_trajectories);
nu_of_trajectories = sz_nu_of_trajectories(1,1);

frm_nmb_time = frm_nmb * Time_interval;
frm_nmb_time_zeroremoved = frm_nmb_time(frm_nmb_time~=0);
frm_nmb_time_zeroremoved = frm_nmb_time_zeroremoved(1,(1:end));
basalbody_count_original = basalbody_count; 
basalbody_count = basalbody_count / Time_interval; % This gives the rate: no of bb per minute
basalbody_count_modified = basalbody_count(basalbody_count~=0);
basalbody_count_modified_rate = basalbody_count_modified(1,(1:end));

figure(1);
stem(frm_nmb_time_zeroremoved(1,(1:(end-1))), basalbody_count_modified_rate(1,(1:(end-1))));
xlabel('Time [min]');  ylabel('BB exit rate (BB min^{-1})'); title('BB exit rate');
set(gca,'fontsize',18);
saveas(gcf, fullfile(savelink_tend, 'BB_exit_rate_time'),'fig'); saveas(gcf, fullfile(savelink_tend, 'BB_exit_rate_time'),'tif');

figure(2);
yyaxis left
stem(frm_nmb_time(1,(1:(end-1))), basalbody_count_original(1,(1:(end-1))));
yyaxis right
plot(Timepoint_2, MeanIntensity_apicaldomain, '-rx','LineWidth', 0.8);
xlabel('Time [min]');  yyaxis left; ylabel('BB exit count'); title('BB exit count and actin mean intensity');
yyaxis right; ylabel('Mean intensity [a.u]');
set(gca,'fontsize',18);
saveas(gcf, fullfile(savelink_tend, 'BB_exit_count_MeanInt_vs_time'),'fig'); saveas(gcf, fullfile(savelink_tend, 'BB_exit_count_MeanInt_vs_time'),'tif');

figure(3);
yyaxis left
stem(frm_nmb_time(1,(1:(end-1))), basalbody_count_original(1,(1:(end-1))));
yyaxis right
plot(Timepoint_2, TotalIntensity_apicaldomain, '-rx','LineWidth', 0.8);
xlabel('Time [min]');  yyaxis left; ylabel('BB exit count'); title('BB exit count and actin total intensity');
yyaxis right; ylabel('Total intensity [a.u]');
set(gca,'fontsize',18);
saveas(gcf, fullfile(savelink_tend, 'BB_exit_count_TotalInt_vs_time'),'fig'); saveas(gcf, fullfile(savelink_tend, 'BB_exit_count_TotalInt_vs_time'),'tif');

close all
%%
% The following is done to plot the BB flux which is: No of BB per unit time per unit area
% This "for" loop is to get the corresponding "area" values for the tend frames of all trajectories.

frm_nmb_modified = frm_nmb(frm_nmb~=0);
for iab = 1:length(basalbody_count_modified) % this loop goes through the the array that contains the tend of all trajectories
    frame_tend_BB_getting_value(iab) = frm_nmb_modified(iab); % getting individually the tend of all trajectories one by one
    Area_tend_BB(iab) = Area_apicaldomain(frame_tend_BB_getting_value(iab)); % Finding the corresponding area for the tend frame of every trajectory  
end

frm_nmb_time_modified = frm_nmb_modified * Time_interval;
% the last frame is omitted since all BB will in principle exit at the last frame since that is the last frame available
BB_flux = basalbody_count_modified_rate(1,(1:(end-1))) ./ Area_tend_BB(1,(1:(end-1))); 

figure(1);
bbflux_fig = scatter(frm_nmb_time_modified(1,(1:(end-1))), BB_flux, 'LineWidth',1); bbflux_fig.MarkerEdgeColor = 'k';
xlabel('Time[min]'); ylabel('BB exit flux [min^{-1}\mum^{-2}]'); title('BB exit flux'); set(gca,'fontsize',12); 
saveas(gcf, fullfile(savelink_tend, 'BB_exit_flux_time'), 'fig'); saveas(gcf, fullfile(savelink_tend, 'BB_exit_flux_time'), 'tif');

figure(2);
bbflux_fig = scatter(Area_tend_BB(1,(1:(end-1))), BB_flux, 'LineWidth',1); bbflux_fig.MarkerEdgeColor = 'k';
xlabel('Area [\mum^{2}]'); ylabel('BB exit flux [min^{-1}\mum^{-2}]'); title('BB exit flux'); set(gca,'fontsize',12); 
saveas(gcf, fullfile(savelink_tend, 'BB_exit_flux_area'), 'fig'); saveas(gcf, fullfile(savelink_tend, 'BB_exit_flux_area'), 'tif');

% Plotting the figure(1) from previous section against area
figure (3);
stem(Area_tend_BB(1,(1:(end-1))), basalbody_count_modified_rate(1,(1:(end-1))));
xlabel('Area [\mum^{2}]');  ylabel('BB exit rate (BB min^{-1})'); title('BB exit rate'); set(gca,'fontsize',18);
saveas(gcf, fullfile(savelink_tend, 'BB_exit_rate_area'),'fig'); saveas(gcf, fullfile(savelink_tend, 'BB_exit_rate_area'),'tif');

Area_tend_BB_exit_count = Area_apicaldomain(1:size(basalbody_count_original',1),1);
Area_tend_BB_exit_count(basalbody_count_original'==0) = 0;

figure(4);
yyaxis left
stem(Area_tend_BB_exit_count(1:end-1,1), basalbody_count_original(1,1:end-1));
yyaxis right
plot(Area_apicaldomain, MeanIntensity_apicaldomain, '-rx','LineWidth', 0.8);
xlabel('Area [\mum^{2}]');  yyaxis left; ylabel('BB exit count'); title({'BB exit count and actin', 'mean intensity vs Area'});
yyaxis right; ylabel('Mean intensity [a.u]');
set(gca,'fontsize',18);
saveas(gcf, fullfile(savelink_tend, 'BB_exit_count_MeanInt_vs_area'),'fig'); saveas(gcf, fullfile(savelink_tend, 'BB_exit_count_MeanInt_vs_area'),'tif');

figure(5);
yyaxis left
stem(Area_tend_BB_exit_count(1:end-1,1), basalbody_count_original(1,(1:(end-1))));
yyaxis right
plot(Area_apicaldomain, TotalIntensity_apicaldomain, '-rx','LineWidth', 0.8);
xlabel('Area [\mum^{2}]');  yyaxis left; ylabel('BB exit count'); title({'BB exit count and actin', 'total intensity vs Area'});
yyaxis right; ylabel('Total intensity [a.u]');
set(gca,'fontsize',18);
saveas(gcf, fullfile(savelink_tend, 'BB_exit_count_TotalInt_vs_area'),'fig'); saveas(gcf, fullfile(savelink_tend, 'BB_exit_count_TotalInt_vs_area'),'tif');

close all

%%
disp('Run the macro "Actin_intensity_for_bb_tend_ROIs_all.ijm". Then press a key !') 
pause;

%% Getting the meanintensity of actin before and after basal body disappearance 

BBTend = importdata('../Plots/tend_basalbody_position_all/bb_tend_ROIs_data/ActInt_at&sur_BBtend_ROIs.csv');
BBtend = BBTend.data;
clear BBTend
[bbtendrow, bbtendcol] = size(BBtend); % to get the no of rows and columns in the imported table
 
Trajectory_tend = BBtend(:,1);
Frame_tend = BBtend(:,2);
tot_Frame_tend = max(Frame_tend);
%nu_of_trajectories = length(); % Total no of trajectories in the imported table 
 
Trajectory_tend_data = cell(nu_of_trajectories,bbtendcol); % converting the imported table into a cell array.
counter_tend = zeros(1,bbtendrow);
 
% Loading the data into a cell array.
% In the this cell, each row will correspond to a basal body (bb) trajectory and each column will correspond to a parameter. Column1 - Trajectory no; 
% Column 2 - Frame number; Column3 - xcoordinate of the bb; Column4 - ycoordinate of the bb; Column5 - MeanIntBBposition; Column6 - TotalIntBBposition;
% Column7 - MeanIntBBsurround; Column8 - TotalIntBBsurround; Column9 - Area at BBposition; Column10 - Perimeter at BBposition; 
% Column11 - Area sorrounding BB position; Column12 - Perimeter surrounding BBposition; Column13 - Speed of basalbodies.
for i = 1:nu_of_trajectories
    actual_trajectory_no = TrajecendPos(i,1);
    for j = 1:bbtendcol
        for k = 1:bbtendrow
            if Trajectory_tend(k) == actual_trajectory_no
                counter_tend(k) = k;
            end
        end
        countlist_tend = unique(counter_tend);
        clear counter_tend;
        if countlist_tend(1) == 0
            rowstartvalue_tend = countlist_tend(2);
        else
            rowstartvalue_tend = countlist_tend(1);
        end
        rowendvalue_tend = countlist_tend(end);
        Trajectory_tend_data{i,j} = BBtend((rowstartvalue_tend:rowendvalue_tend),j); 
    end
    
end
%%

actinatBBpos = zeros(nu_of_trajectories,11);
for trajno = 1:nu_of_trajectories %nu_of_trajectories
    trajlengthh = length(Trajectory_tend_data{trajno,1});
    
    % this is to make sure that only those trajectories that are longer than "traj_filter_duration" (in no of frames) are taken for analysis - smaller trajectories are not plotted 
    if trajlengthh <= 2 % "traj_filter_duration" corresponds to the time (in frames) chosen based on the tracking plugin output. Check the "value_for_filter.txt". Check the description
        % in the first few lines of this script where this value "traj_filter_duration" is obtained as input.
        continue
    else
         tendframe = Trajectory_tend_data{trajno,2}(1,1); % Getting the last frame at which the basalbody disappears
        if (tendframe >= 5) && (tendframe <= (tot_Frame_tend-4)) % making sure that there are atleast 4 frames before and after the basal body disappearance
            actinatBBpos(trajno,1) = trajno; % Getting the trajectory no.
            actinatBBpos(trajno,2) = Trajectory_tend_data{trajno,2}(1,1); % Getting the last frame at which the basalbody disappears
            actinatBBpos(trajno,7) = Trajectory_tend_data{trajno,5}(tendframe,1); % Getting the mean intensity at the last frame in which the basalbody disappears, at the position of basalbody.
            actinatBBpos(trajno,7) = actinatBBpos(trajno,7) / raw_mean_int_whole_domain(tendframe,1); % cortex_meanint{1,tzeroframe};
            
            actinatBBpos(trajno,3) = Trajectory_tend_data{trajno,5}((tendframe - 4),1); % Getting the mean intensity at four frames before the frame at which the basalbody disappears, at the position of basalbody.
            actinatBBpos(trajno,3) = actinatBBpos(trajno,3) / raw_mean_int_whole_domain(tendframe-4,1); % cortex_meanint{1,(tzeroframe-4)};
            actinatBBpos(trajno,4) = Trajectory_tend_data{trajno,5}((tendframe - 3),1); % Getting the mean intensity at three frames before the frame at which the basalbody disappears, at the position of basalbody.
            actinatBBpos(trajno,4) = actinatBBpos(trajno,4) / raw_mean_int_whole_domain(tendframe-3,1); % cortex_meanint{1,(tzeroframe-3)};
            actinatBBpos(trajno,5) = Trajectory_tend_data{trajno,5}((tendframe - 2),1); % Getting the mean intensity at two frames before the frame at which the basalbody disappears, at the position of basalbody.
            actinatBBpos(trajno,5) = actinatBBpos(trajno,5) / raw_mean_int_whole_domain(tendframe-2,1); % cortex_meanint{1,(tzeroframe-2)};
            actinatBBpos(trajno,6) = Trajectory_tend_data{trajno,5}((tendframe - 1),1); % Getting the mean intensity at one frame before the frame at which the basalbody disappears, at the position of basalbody.
            actinatBBpos(trajno,6) = actinatBBpos(trajno,6) / raw_mean_int_whole_domain(tendframe-1,1); % cortex_meanint{1,(tzeroframe-1)};
            
            actinatBBpos(trajno,8) = Trajectory_tend_data{trajno,5}((tendframe + 1),1); % Getting the mean intensity at one frame after the frame at which the basalbody disappears, at the position of basalbody.
            actinatBBpos(trajno,8) = actinatBBpos(trajno,8) / raw_mean_int_whole_domain(tendframe+1,1); % cortex_meanint{1,(tzeroframe+1)};
            actinatBBpos(trajno,9) = Trajectory_tend_data{trajno,5}((tendframe + 2),1); % Getting the mean intensity at two frames after the frame at which the basalbody disappears, at the position of basalbody.
            actinatBBpos(trajno,9) = actinatBBpos(trajno,9) / raw_mean_int_whole_domain(tendframe+2,1); % cortex_meanint{1,(tzeroframe+2)};
            actinatBBpos(trajno,10) = Trajectory_tend_data{trajno,5}((tendframe + 3),1); % Getting the mean intensity at three frames after the frame at which the basalbody disappears, at the position of basalbody.
            actinatBBpos(trajno,10) = actinatBBpos(trajno,10) / raw_mean_int_whole_domain(tendframe+3,1); % cortex_meanint{1,(tzeroframe+3)};
            actinatBBpos(trajno,11) = Trajectory_tend_data{trajno,5}((tendframe + 4),1); % Getting the mean intensity at four frames after the frame at which the basalbody disappears, at the position of basalbody.
            actinatBBpos(trajno,11) = actinatBBpos(trajno,11) / raw_mean_int_whole_domain(tendframe+4,1); % cortex_meanint{1,(tzeroframe+4)};
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
xaxisvalues = {'t-4','t-3','t-2','t-1','tend','t+1','t+2','t+3','t+4'};
figure3 = figure;
axes3 = axes('Parent',figure3,'XTickLabel',xaxisvalues(1,:));
box(axes3,'on');
hold(axes3,'all');
plot(actinatBBpos(:,3:11)');
ylabel('Mean intensity of Actin'); title('Actin intensity during BB disappearance');
set(gca,'fontsize',18);
saveas(gcf, fullfile(savelink_tend, 'Actin_intensity_during_BB_disappearance_individual_trajectories'),'fig'); saveas(gcf, fullfile(savelink_tend, 'Actin_intensity_during_BB_disappearance_individual_trajectories'),'tif');

figure4 = figure;
axes4 = axes('Parent',figure4,'XTickLabel',xaxisvalues(1,:));
box(axes4,'on');
hold(axes4,'all');
plot(sum_actinatBBpos(:,3:11)');
ylabel('Mean intensity of Actin'); title('Actin intensity during BB disappearance (sum across trajectories)');
set(gca,'fontsize',10);
saveas(gcf, fullfile(savelink_tend, 'Actin_intensity_during_BB_disappearance_Sum'),'fig'); saveas(gcf, fullfile(savelink_tend, 'Actin_intensity_during_BB_disappearance_Sum'),'tif');

figure5 = figure;
axes5 = axes('Parent',figure5,'XTickLabel',xaxisvalues(1,:));
box(axes5,'on');
hold(axes5,'all');
hold on;
plot(avg_actinatBBpos(:,3:11)');
ylabel('Mean intensity of Actin'); title('Actin intensity during BB disappearance (Average across trajectories)');
set(gca,'fontsize',10);
saveas(gcf, fullfile(savelink_tend, 'Actin_intensity_during_BB_disappearance_Avg'),'fig'); saveas(gcf, fullfile(savelink_tend, 'Actin_intensity_during_BB_disappearance_Avg'),'tif');

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
ylabel('Mean intensity of Actin'); title('Actin intensity during BB disappearance (Average across trajectories-withStDev)');
set(gca,'fontsize',10);
saveas(gcf, fullfile(savelink_tend, 'Actin_intensity_during_BB_disappearance_Avg_STDev'),'fig'); saveas(gcf, fullfile(savelink_tend, 'Actin_intensity_during_BB_disappearance_Avg_STDev'),'tif');

close all;

%%
% saving as montage
montage_fig = '../Plots/montage';
savelink_tend = '../Plots/tend_basalbody_position_all/';

fig1 = fullfile(savelink_t0, 'Actin_intensity_during_BB_appearance_individual_trajectories.tif');
fig2 = fullfile(savelink_t0, 'Actin_intensity_during_BB_appearance_Sum.tif');
fig3 = fullfile(savelink_t0, 'Actin_intensity_during_BB_appearance_Avg.tif');
fig4 = fullfile(savelink_t0, 'Actin_intensity_during_BB_appearance_Avg_STDev.tif');
fig5 = fullfile(savelink_tend, 'Actin_intensity_during_BB_disappearance_individual_trajectories.tif');
fig6 = fullfile(savelink_tend, 'Actin_intensity_during_BB_disappearance_Sum.tif');
fig7 = fullfile(savelink_tend, 'Actin_intensity_during_BB_disappearance_Avg.tif');
fig8 = fullfile(savelink_tend, 'Actin_intensity_during_BB_disappearance_Avg_STDev.tif');
montage({fig1, fig2, fig3, fig4, fig5, fig6, fig7, fig8});
saveas(gcf, fullfile(montage_fig,'slide_15_1_entry_exit_actin_Int_all'), 'tif');

fig9 = fullfile(savelink_t0, 'BB_entry_rate_time.tif');
fig10 = fullfile(savelink_t0, 'BB_entry_rate_area.tif');
fig11 = fullfile(savelink_t0, 'BB_entry_count_MeanInt_vs_time.tif');
fig12 = fullfile(savelink_t0, 'BB_entry_count_TotalInt_vs_time.tif');
fig11_1 = fullfile(savelink_t0, 'BB_entry_count_MeanInt_vs_area.tif');
fig12_1 = fullfile(savelink_t0, 'BB_entry_count_TotalInt_vs_area.tif');
fig13 = fullfile(savelink_tend, 'BB_exit_rate_time.tif');
fig14 = fullfile(savelink_tend, 'BB_exit_rate_area.tif');
fig15 = fullfile(savelink_tend, 'BB_exit_count_MeanInt_vs_time.tif');
fig16 = fullfile(savelink_tend, 'BB_exit_count_TotalInt_vs_time.tif');
fig15_1 = fullfile(savelink_tend, 'BB_exit_count_MeanInt_vs_area.tif');
fig16_1 = fullfile(savelink_tend, 'BB_exit_count_TotalInt_vs_area.tif');
montage({fig9, fig10, fig11, fig12, fig11_1, fig12_1, fig13, fig14, fig15, fig16, fig15_1, fig16_1});
saveas(gcf, fullfile(montage_fig,'slide_15_2_BBrates_all'), 'tif');


fig17 = fullfile(savelink_t0, 'BB_entry_flux_time.tif');
fig18 = fullfile(savelink_t0, 'BB_entry_flux_area.tif');
fig19 = fullfile(savelink_tend, 'BB_exit_flux_time.tif');
fig20 = fullfile(savelink_tend, 'BB_exit_flux_area.tif');
montage({fig17, fig18, fig19, fig20});
saveas(gcf, fullfile(montage_fig,'slide_15_3_BBflux_all'), 'tif');

close all;
%%
save('workspace_with_tend_data_all');

%%




































