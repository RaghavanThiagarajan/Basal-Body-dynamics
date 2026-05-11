
%% Standard clearance
clear all
clc
close all

%% Load the corresponding workspace
load('workspace_interim.mat');

%% clear the parameters that are to be reanalysed

clear area_rate_time_interval area_rate_frame_interval ar_diff area_rate max_apical_area_idx whole_area_rate

%% Perform the operation that needs to be redone / repeated

figure(411);
area_rate_time_interval = 5; % choosing 5 min as the interval at which area rate is obtained
area_rate_frame_interval = round(area_rate_time_interval / Time_interval); % converting the 'area_rate_time_interval' into frames
ar_diff = Area_apicaldomain(area_rate_frame_interval:1:end, 1) - Area_apicaldomain(1:1:end-(area_rate_frame_interval-1), 1); % getting the difference in area for every 'area_rate_time_interval'
area_rate = ar_diff /  area_rate_time_interval; % getting the area rate
max_apical_area_idx = Area_apicaldomain == max(Area_apicaldomain);
whole_area_rate = (Area_apicaldomain(max_apical_area_idx) - Area_apicaldomain(1)) / (Timelist(max_apical_area_idx) - Timelist(1)); % area rate for the whole apical expansion [\mum^2 min^-1]
plot(Timelist(area_rate_frame_interval:1:end, 1), area_rate, '-kx','LineWidth', 0.8);
xlabel('Time [min]');  ylabel('Area rate [\mum^2 min^-1]'); title('Area rate'); set(gca,'fontsize',18);
BB_apical = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/General'); 
saveas(gcf, fullfile(BB_apical, 'Area_rate_vs_time'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Area_rate_vs_time'), 'tif');
figure(412);
plot(Area_apicaldomain(area_rate_frame_interval:1:end, 1), area_rate, '-bx','LineWidth', 0.8);
xlabel('Area [\mum^2]');  ylabel('Area rate [\mum^2 min^-1]'); title('Area vs Area rate'); set(gca,'fontsize',18);
saveas(gcf, fullfile(BB_apical, 'Area_rate_vs_area'), 'fig'); saveas(gcf, fullfile(BB_apical, 'Area_rate_vs_area'), 'tif');

for_deletion = strcat(BB_apical, '/', 'Area_rate.tif');
delete(for_deletion);

%% save the workspace again
save('workspace_interim');

%% Replot the montage

close all;
% saving as montage
montage_fig = '../Plots/montage';

fig1 = fullfile(BB_apical, 'Area_&_BB_time_apicaldomain.tif');
fig2 = fullfile(BB_apical, 'Area_&_BB_relation_apicaldomain.tif');
fig21 = fullfile(BB_apical, 'area_contribution_vs_time.tif');
fig22 = fullfile(BB_apical, 'area_contribution_percent_vs_time.tif');
fig3 = fullfile(BB_apical, 'Meanint_&_BB_time_apicaldomain.tif');
fig4 = fullfile(BB_apical, 'Totalint_&_BB_time_apicaldomain.tif');
fig411 = fullfile(BB_apical, 'Area_rate_vs_time.tif');
fig412 = fullfile(BB_apical, 'Area_rate_vs_area.tif');

montage({fig1, fig2, fig21, fig22, fig3, fig4, fig411,fig412});
saveas(gcf, fullfile(montage_fig,'slide_2'), 'tif');

close all;

disp('Finished');
%%



