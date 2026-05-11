clc;
clear all;
close all;

mkdir ../Plots drift_plots; % introduced by RT
loadlink = '../Input_basalbody_tracks/'; % introduced by RT
savelink = '../Plots/drift_plots'; % introduced by RT

load('workspace_interim', 'Time_interval', 'pixelwidth', 'traj_filter_duration', 'traj_segregate_duration'); % introduced by RT % we are loading this to get some input values

%ApicalSurf = Dir{iex} + "Apical_domain_periphery_cordinates.csv";
BBCoords = loadlink + "Table_based_on_trajectories.csv";

%ApiSur = readmatrix(ApicalSurf); 
%Tr_data = readmatrix(BBCoords);
Tr_data_table = readtable(BBCoords);
Tr_data = table2array(Tr_data_table);

% there are NaN entries corresponding to headers for each column"
trajs = unique(Tr_data(~isnan(Tr_data(:, 2)), 2)); 
Ntrajs = length(trajs);

dt = Time_interval; % in minutes % introduced by RT
x = cell(Ntrajs, 1);
y = cell(Ntrajs, 1);
vx = cell(Ntrajs, 1);
vy = cell(Ntrajs, 1);
frames = cell(Ntrajs, 1);
frm = cell(Ntrajs, 1);

for i = 1:Ntrajs
        a = Tr_data(:,2) == i;
        frames{i} = Tr_data(a, 3);
        frm{i} = Tr_data(a, 3) * dt;
        x{i} = Tr_data(a, 4) * pixelwidth; % pixelwidth allows conversion to micrometers
        y{i} = Tr_data(a, 5) * pixelwidth; % pixelwidth allows conversion to micrometers
        vx{i} = (diff(x{i})./diff(frm{i})); 
        vy{i} = (diff(y{i})./diff(frm{i})); 
end

large_traj = [];

%-------------------%
% Applying filter for the trajectory length
% the 'traj_segregate_duration' and 'traj_filter_duration' are two values that are used to filter trajectories. 
%'traj_filter_duration' is used at the end of the Particle tracker 2D/3D plugin to remove irrational trajectories based on the length of trajectories (so this number is essentially 'no of frames').
% traj_segregate_duration is used to segregate long and short trajectories. This value is the 2/3rd of the total experiment / movie time. So trajectories longer than 2/3rd of the movie are called 
% long trajectories and trajectories less than this value are called small trajectories. This value is in minutes.
% In this script where we get the mean drift of the trajectories, we can choose to take into account only certain no of trajectories by applying one of these filters: 'traj_segregate_duration' or 'traj_filter_duration'.
% For now, I am using 'traj_filter_duration' since I want to take those trajectories that are processed by scripts that end with '...Traj_after_filtering'
% If in future, it is decided to find the drift of long trajectories, then use 'traj_segregate_duration'. If it is decided to find the drift of short trajectories, then subtract 'traj_segregate_duration' from 'total experiment time' and use this value.
% then change 'traj_segregate_duration' instead of 'traj_filter_duration' for 'durmax' down the script. "Remember - 'durmax' should be in the unit of 'minutes' and not 'no of frames'"

durmax = round(traj_filter_duration * Time_interval); % Getting the no of frames that are used to remove the irrational trajectories; This value is in minutes after multiplying with Time_interval; Check the  file "value_for_filter.txt" file for this value. 
% Use 'traj_segregate_duration' if you want to get the no of frames that are longer than (2/3)rd of the movie size. This value is in minutes. Check the  file "value_for_filter.txt" file for this value. the reason for using the (2/3)rd of the movie size can be to use longer 
% trajectories so that we can check if they are directed or not. In other words, whether trajectories that exist for long times are directed or not.
no_of_durmax_points = round(durmax / dt); % getting the total no of points / values for a time series where maxtime is 'durmax'
%-------------------%

for i = 1:Ntrajs
    figure(1) % opening the figure for plotting trajectories
    % below we filter the trajectories based on length; trajectories larger than 'durmax' are chosen
    if (length(frm{i}) > no_of_durmax_points) % changed by RT
        large_traj = [large_traj; i]; 
        % plotting the trajectories
        plot(x{i}, y{i})
        hold on;
    end
end

axis equal;
figure(1);
xlabel('x axis [\mum]'); ylabel('y axis [\mum]');
saveas(gcf, fullfile(savelink, 'trajectories'),'fig'); saveas(gcf, fullfile(savelink, 'trajectories'),'tif');

Nlrge = length(large_traj); % number of trajectories with time points > no_of_durmax_points
Vcorr = cell(Nlrge, 1);
tlags = cell(Nlrge, 1);
maxlag = [];

for i = 1:Nlrge
    jn = large_traj(i);
    velx = vx{jn};
    vely = vy{jn};
    vel = sqrt(velx.^2 + vely.^2);

    vhatx = velx./vel;
    vhaty = vely./vel;

    [Vxc, lags] = xcorr(velx, 'biased');
    [Vyc, lags] = xcorr(vely, 'biased');
    Vc = Vxc + Vyc;
    Vc = Vc./max(Vc);
%     figure(2) % Uncomment this figure if you want to plot the velocity correlation; If this is cuncommented, then it is better to uncomment to figure(4) also
%     plot(lags, Vc, 'r+-');
%     hold on
    Vcorr{i} = Vc;
    tlags{i} = lags;
    maxlag = [maxlag;max(abs(lags))];
end


minmaxlag = min(maxlag);

VelCorr = zeros(minmaxlag + 1, 1);

dl = zeros(Nlrge, 1);
dr = zeros(Nlrge, 1);

Xmean = zeros(no_of_durmax_points, 1); % changed by RT
Ymean = zeros(no_of_durmax_points, 1); % changed by RT
Xp_save = cell(Nlrge,1); % introduced by RT
Yp_save = cell(Nlrge,1); % introduced by RT
time_dur_save = cell(Nlrge,1); % introduced by RT
 
for i = 1:Nlrge
    jn = large_traj(i);
    time_dur = frm{jn}; % introduced by RT
    time_dur = time_dur - time_dur(1); % introduced by RT
    
    % Figures that plot unrotated x axis / x distance and y axis / y distance separately of the trajectories
    X = x{jn} - x{jn}(1);
    Y = y{jn} - y{jn}(1);
%     figure(10) % Uncomment these lines of figure(10) and (11) in order to plot the x and y axes of trajectories
%     plot(X); 
%     hold on 
%     figure(11)
%     plot(Y);
%     hold on

    Vx = vx{jn};
    Vy = vy{jn};

    th = atan2(mean(Vy), mean(Vx));
    Xp = X*cos(th) + Y*sin(th);
    Yp = Y*cos(th) - X*sin(th);
    
    Xp_save{i,1} = Xp;
    Yp_save{i,1} = Yp;
    time_dur_save{i,1} = time_dur;

    % Figures (12) and (13) plot 'rotated' x axis / x distance and y axis / y distance separately of the trajectories
    figure(12)
    plot(time_dur, Xp, 'LineWidth', 0.1, 'Color', [0.7, 0.7, 0.7]); % changed by RT
    hold on
    xlabel('Time [min]');
    ylabel('Rotated x distance [µm]');

    figure(13)
    plot(time_dur, Yp, 'LineWidth', 0.1, 'Color', [0.7, 0.7, 0.7]); % changed by RT
    hold on;
    xlabel('Time [min]');
    ylabel('Rotated y distance [µm]');
    %pause(1)

    dl(i) = sum(sqrt(vx{jn}.^2 + vy{jn}.^2)); % getting the contour distance of the trajectories
    dr(i) = sqrt(sum(vx{jn})^2 + sum(vy{jn})^2); % getting the end-to-end straight distance of the trajectories

    a = (tlags{i} >= 0 & tlags{i} <= minmaxlag);
    VelCorr = VelCorr + Vcorr{i}(a);
    tl = tlags{i}(a);

    Xmean = Xmean + Xp(1:no_of_durmax_points); % changed by RT
    Ymean = Ymean + Yp(1:no_of_durmax_points); % changed by RT
end
tm = dt:dt:durmax; % time axis for plotting the Xmean and Ymean % introduced by RT
Xmean = Xmean/Nlrge;
Ymean = Ymean/Nlrge;

figure(12);
plot(tm, Xmean, 'r-', 'LineWidth', 1.5); % changed by RT

figure(13)
plot(tm, Ymean, 'r-', 'LineWidth', 1.5); % changed by RT

% Plotting the average velocity correlation (I had already plotted this in the 'crosscorrelation_Traj_after_filtering.m and 'crosscorrelation_all')
VelCorr = VelCorr/Nlrge;
% figure(4) % Uncomment these lines if you want to plot the average velocity correlation; If this is uncommented, then it is better to uncomment figure(2) also
% plot(tl, VelCorr, 'ro-');
% xlabel('lags');
% ylabel('Average Cv')

%% Plotting the fit for the 'rotated' x axis / x distance and y axis / y distance plots (these are already plotted above); here we are just adding the fits

time = (1:length(Xmean));
time = time';
time = time * dt; % introduced by RT; this is to convert the unit of time to frames.

% fitting straight line
% Set up fittype and options.
ft = fittype('poly1');

% Fit model to data.
[fitresult, gof] = fit(tm', Xmean, ft ); % changed by RT

p1 = fitresult.p1;
p2 = fitresult.p2;
y1 = p1*time + p2;
drift_slope = p1; % introduced by RT % this is the slope value that needs to be plotted against the area rate value to see if there is a relationship between rate
% of expansion and the existence of drift. For ex: drift slope is high when the rate of expansion is high or viceversa.

figure(12);
hold on
plot(time, y1, 'b')

% introduced by RT
figure(12);
saveas(gcf, fullfile(savelink, 'rotated_x_plot'),'fig');
saveas(gcf, fullfile(savelink, 'rotated_x_plot'),'tif');

figure(13);
saveas(gcf, fullfile(savelink, 'rotated_y_plot'),'fig');
saveas(gcf, fullfile(savelink, 'rotated_y_plot'),'tif');

%%
% figure that plots the tortuosity
% In the resulting histogram, if more number of counts are found for tortuosity values less than '1', then it means 'contour length' is less than 'end-to-end straight distance'. 
% Vice versa, it means the 'contour length' is more than 'end-to-end straight distance'. 
% In other words, if the torutosity is less than 1, then it means the trajectories are straighter and if the tortuosity is more than 1 then it means the trajectories more convoluted.
figure(6)
tortsty = dl./dr;
tort = tortsty(tortsty < 100); % removing all tortuosities that are more than 100 since all these data must be outliers because both the start and end points of the trajectories are very close.
% tort = tortsty(~isinf(tortsty)); % removing 'infinities',  if they are present. Because, sometimes, the start and the end point of the trajectory can be same since they start and finish in the same point.
% in this case, the end-to-end distance will be zero and when zero is in the denominator while calculating tortuosity (contour length / end-to-end distance), it gives infinity. Therefore we have to remove infinity.
histogram(tort, 25, 'FaceColor', 'b', 'EdgeColor', 'r', 'LineWidth', 1.5, 'FaceAlpha', 0.8);
xlabel('Tortuosity'); ylabel('Counts'); title('Tortuosity');
saveas(gcf, fullfile(savelink, 'tortuosity'),'fig'); saveas(gcf, fullfile(savelink, 'tortuosity'),'tif');

%% Plotting the MSD and mean distances

% dsr = cell(Nlrge, 1);
% dxs = cell(Nlrge, 1);
% dys = cell(Nlrge, 1);
% dns = cell(Nlrge, 1); % for MSS
% dur = zeros(Nlrge, 1);
% 
% n = 3; % for the MSS
% 
% for i = 1:Nlrge
%         jn = large_traj(i);
%         X = x{jn};
%         Y = y{jn};
%         [dsx2, dsx, nums] = MSD(X);
%         [dsy2, dsy, nums] = MSD(Y);
%         [dsn, nums] = MD(X, Y, n);
%         dsr{i} = dsx2 + dsy2;
%         dxs{i} = dsx;
%         dys{i} = dsy;
%         dns{i} = dsn;
% 
%         dur(i) = length(dsx);
% 
% %         figure(7) % MSD plot of the trajectories; this is separately plotted in 'msd_coarsegrained.m'; Uncomment this to include this plot - also uncomment the two figures called as figure(7) down the script
% %         N = 1:length(dsr{i});
% %         loglog(N, dsr{i}, 'Color', [0.7, 0.7, 0.7], 'LineWidth', 0.1);
% %         hold on
% %         figure(8) % Mean displacement in x (of the trajectories), i.e it is just the mean displacement without the squared in the mean squared displacement; Uncomment this to include this plot - also uncomment the figure(8) down the script
% %         plot(N, dxs{i}, 'Color', [0.7, 0.7, 0.7], 'LineWidth', 0.1);
% %         hold on;
% %         figure(9) % Mean displacement in y (of the trajectories), i.e it is just the mean displacement without the squared in the mean squared displacement; Uncomment this to include this plot - also uncomment the figure(9) down the script
% %         plot(N, dys{i}, 'Color', [0.7, 0.7, 0.7], 'LineWidth', 0.1);
% %         hold on;
% end
% 
% % plotting the mean MSD and the mean displacements for figures (7), (8) & (9) respectively
% tmax = min(dur);
% drsmean = zeros(tmax, 1);
% dsxmean = zeros(tmax, 1);
% dsymean = zeros(tmax, 1);
% dsnmean = zeros(tmax, 1);
% 
% for i = 1:Nlrge
%     jn = large_traj(i);
%     drsmean = drsmean + dsr{i}(1:tmax);
%     dsxmean = dsxmean + dxs{i}(1:tmax);
%     dsymean = dsymean + dys{i}(1:tmax);
%     dsnmean = dsnmean + dns{i}(1:tmax);
% end
% 
% drsmean = drsmean/Nlrge;
% dsxmean = dsxmean/Nlrge;
% dsymean = dsymean/Nlrge;
% dsnmean = dsnmean/Nlrge;

% figure(7) % plotting the mean MSD
% loglog(drsmean, 'r-', 'LineWidth', 1.5);
% figure(8) % plotting the mean displacement in x 
% plot(dsxmean, 'r-', 'LineWidth', 1.5)
% figure(9) % plotting the mean displacement in y 
% plot(dsymean, 'r-', 'LineWidth', 1.5)
% figure(7)
% loglog(dsnmean, 'b-', 'LineWidth', 1.5)
% figure(20)
% time = 0:(length(dsnmean)-1);
% plot(log(time(2:end)), log(dsnmean(2:end)),'b-');
% hold on
% plot(log(time(2:end)), log(drsmean(2:end)), 'r-');

%% 
% Plotting the dot product of the displacements between the start-end points and start-centroid points of the trajectories
% This dot product helps in identifying whether the trajectory has moved away from the starting point: (1) in the direction of periphery or; (2) in the direction of center (i.e. taking a U turn). In this histogram plot, if
% there are more counts in +1 than -1, then it means more trajectories are moving towards the periphery and vice versa means more trajectories are reversing their direction towards the center.
% loading data from previous workspaces for getting the centroid
load('workspace_BB_distance_consequent_frames', 'Whole_roi_measure_all_data');
%dotp = zeros(Ntrajs, 1);

% In the for loop below, we go through the list of trajectories and then find the dot product between the displacement and the position vector
% that are obtained from the first and last coordinates of the every trajectory 
for kk = 1:Ntrajs % going through the list of trajectories; Ntrajs is the total no of trajectories
    
    if length(x{kk}) > traj_filter_duration % only those trajectories that are longer than 'traj_filter_duration' are used
        
        % getting the x and y coordinates of the trajectory
        xtr = x{kk};
        ytr = y{kk};
        
        % getting the frame number
        fram_numb = frames{kk}(1,1) + 1;
        
        % getting the centroid coordinates
        Xc = Whole_roi_measure_all_data(fram_numb, 8);
        Yc = Whole_roi_measure_all_data(fram_numb, 9);
        
        % start coordinates
        xo = xtr(1);
        yo = ytr(1);
        
        % end coordinates
        xe = xtr(end);
        ye = ytr(end);
        
        % displacement between the end and the start coordinates
        ux = xe - xo;
        uy = ye - yo;
        
        % position vector w.r.t. centroid
        rx = xo - Xc;
        ry = yo - Yc;
        
        % getting the distance magnitude 
        umag = sqrt(ux^2 + uy^2);
        rmag = sqrt(rx^2 + ry^2);
        
        % Dot product 
        dotp(kk) = (ux*rx + uy*ry)/(umag*rmag);            
    else
        dotp(kk) = NaN; % this is to mark the dotp of all trajectories that are shorter than 'traj_filter_duration' as NaN. I.e. those that are skipped by the if condition before.
    end   
    
end
dotp = dotp(~isnan(dotp)); % removing all nans from the dotp
%dotp = dotp(~(dotp==0)); % removing all zeros from the dotp
% plotting the histogram of the dotproduct
% in this histogram, more no of counts in positive values corresponds to more trajectories moving towards periphery. 
% And vice versa, that is more no of counts in negative values corresponds to more trajectories moving opposite to the periphery
figure(14);
histogram(dotp, 20, 'FaceColor', 'r', 'EdgeColor', 'b', 'LineWidth', 1.5, 'FaceAlpha', 0.8);
xlabel('Trajectory direction'); ylabel('Counts'); title({'Dot product (to know if the trajectory moves in', ' the direction of periphery or in the opposite direction)'});
saveas(gcf, fullfile(savelink, 'dotproduct_traj_direction'),'fig'); saveas(gcf, fullfile(savelink, 'dotproduct_traj_direction'),'tif');

close all;

%%
% saving as montage
montage_fig = '../Plots/montage';
fig1 = fullfile(savelink, 'rotated_x_plot.tif');
fig2 = fullfile(savelink, 'rotated_y_plot.tif');
fig3 = fullfile(savelink, 'trajectories.tif');
fig4 = fullfile(savelink, 'tortuosity.tif');
fig5 = fullfile(savelink, 'dotproduct_traj_direction.tif');
montage({fig1, fig2, fig3, fig4, fig5});
saveas(gcf, fullfile(montage_fig,'slide_18_BB_drift'), 'tif');

close all;

%%
save('workspace_drift');
disp('Finished !');

%%

% analyze the time-trajectory
function [ds2, ds, nums] = MSD(x)   
    N = length(x);
    ds = zeros(N, 1);
    ds2 = zeros(N,1);
    tlag = zeros(N,1);
    nums = zeros(N,1);
    for i = 1:N
        i;
        x2 = x(i:N);
        x1 = x(1:N-(i-1));
        ds(i) = mean(x2-x1);
        ds2(i) = mean((x2-x1).^2);
        nums(i) = length(x1);
    end
end

function [dsn, nums] = MD(x, y, n)   
    N = length(x);
    dsn = zeros(N,1);
    tlag = zeros(N,1);
    nums = zeros(N,1);
    for i = 1:N
        i;
        x2 = x(i:N);
        x1 = x(1:N-(i-1));
        
        y2 = y(i:N);
        y1 = y(1:N-(i-1));

        r21 = sqrt((x2-x1).^2 + (y2 - y1).^2);
        dsn(i) = mean(r21.^n);
        nums(i) = length(x1);
    end
end
%%




 