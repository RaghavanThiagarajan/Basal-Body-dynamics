%% Raghavan Thiagarajan, DanStem, Copenhagen, July 2020

% This script is a continuation of the 'Gradients_BB_int_normalization_by_cortex_Traj_after_filtering.m' script where we calculate the correlations between actin intensities & BB
% characteristics. Also we get the actin intensities in different places like BB position, surrounding and their ratios.

clear all;
close all;
clc;

load('workspace_interim.mat');

%% Section 1
% In this section, we get the intensities of actin at BB position, BB surrounding and find the auto & cross correlations between BB position & surrounding intensities; speed & intensities etc.
sum_corr_meanint_meanint_forplotting = zeros(1,1);
sum_corr_meanintsurrBB_meanintsurrBB_forplotting = zeros(1,1);
sum_corr_speed_speed_forplotting = zeros(1,1);
sum_corr_vx_vx_forplotting = zeros(1,1);
sum_corr_vy_vy_forplotting = zeros(1,1);
sum_corr_meanint_meanintsurrBB_forplotting = zeros(1,1);
sum_corr_meanint_speed_forplotting = zeros(1,1);
sum_corr_meanintsurrBB_speed_forplotting = zeros(1,1);
sum_corr_meanint_vx_forplotting = zeros(1,1);
sum_corr_meanint_vy_forplotting = zeros(1,1);
sum_corr_meanintsurrBB_vx_forplotting = zeros(1,1);
sum_corr_meanintsurrBB_vy_forplotting = zeros(1,1);
max_lag_length = 1;

for trajno = 1:no_of_trajectories
    kend = length(Trajectory_data{trajno,1});
    
    % this is to make sure that only those trajectories that are longer than "traj_filter_duration" (in no of frames) are taken for analysis - smaller trajectories are not plotted
    if kend <= traj_filter_duration % "traj_filter_duration" corresponds to the time (in frames) chosen based on the tracking plugin output. Check the "value_for_filter.txt". Check the description
        % in the first few lines of the script (Gradients_BB_int_normalization_by_cortex_Traj_after_filtering.m) where this value "traj_filter_duration" is obtained as input.
        continue
    else
        
        for k = 1: (kend-1)
            distance(trajno,k) = (sqrt((Trajectory_data{trajno,3}(k+1,1) - Trajectory_data{trajno,3}(k,1))^2 + (Trajectory_data{trajno,4}(k+1,1) - Trajectory_data{trajno,4}(k,1))^2)) * pixelwidth;
            timestep(trajno,k) = Trajectory_data{trajno,2}(k+1,1) * Time_interval;
            timeforspeed(trajno,k) = (Trajectory_data{trajno,2}(k+1,1) - Trajectory_data{trajno,2}(k,1)) * Time_interval;
            speed(trajno,k) =  distance(trajno,k) / timeforspeed(trajno,k);
            % getting velocity components
            V_x(trajno,k) = (Trajectory_data{trajno,3}(k+1,1) - Trajectory_data{trajno,3}(k,1)) / Time_interval; % x component of velocity Vx, given by: Vx = (x(t+dt)-x(t))/dt
            V_y(trajno,k) = (Trajectory_data{trajno,4}(k+1,1) - Trajectory_data{trajno,4}(k,1)) / Time_interval; % y component of velocity Vy, given by: Vy = (y(t+dt)-y(t))/dt
            V_angle(trajno,k) = atan(V_y(trajno,k) / V_x(trajno,k));
            V_angle(trajno,k) = radtodeg(V_angle(trajno,k));
        end
        
        timestack = Trajectory_data{trajno,2} .* Time_interval;
        totaldistance(trajno,1) = (sqrt((Trajectory_data{trajno,3}(kend,1) - Trajectory_data{trajno,3}(1,1))^2 + (Trajectory_data{trajno,4}(kend,1) - Trajectory_data{trajno,4}(1,1))^2)) * pixelwidth;
        totaltime(trajno,1) = Trajectory_data{trajno,2}(kend,1) - Trajectory_data{trajno,2}(1,1);
        totaltime(trajno,1) =  totaltime(trajno,1) * Time_interval;
        totalspeed(trajno,1) = totaldistance (trajno,1) / totaltime (trajno,1);
        
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
        
        trajectoryno(trajno) = trajno;
        time = timestep(trajno,(1:kend-1)); % - timestep(trajno, (1:1));
        % getting the speed and mean intensity of actin
        spd = speed(trajno,:);
        mi = MeanInt_BBposition((2:kend),:);
        msi = MeanInt_BBsurround((2:kend),:);
        vx = V_x(trajno,:);
        vy = V_y(trajno,:);
        vdir = V_angle(trajno,:);
        
        % Obtaining correlations
        % Autocorrelation of actin mean intensity at the position of BB
        [corr_meanint_meanint,lags_meanint_meanint] = xcorr(mi,mi, 'unbiased'); % getting correlation
        corr_meanint_meanint = corr_meanint_meanint - nanmean(mi)^2; % subtracting the mean correlation value
        % Autocorrelation of actin mean intensity in the surrounding position of BB
        [corr_meanintsurrBB_meanintsurrBB,lags_meanintsurrBB_meanintsurrBB] = xcorr(msi, msi, 'unbiased'); % getting correlation
        corr_meanintsurrBB_meanintsurrBB = corr_meanintsurrBB_meanintsurrBB - nanmean(msi)^2;
        % Autocorrelation of BB speed
        [corr_speed_speed,lags_speed_speed] = xcorr(spd,spd, 'unbiased'); % getting correlation
        corr_speed_speed = corr_speed_speed - nanmean(spd)^2;
        % Autocorrelation of vx
        [corr_vx_vx, lags_vx_vx] = xcorr(vx, vx, 'unbiased');
        corr_vx_vx = corr_vx_vx - nanmean(vx)^2;
        % Autocorrelation of vy
        [corr_vy_vy, lags_vy_vy] = xcorr(vy, vy, 'unbiased');
        corr_vy_vy = corr_vy_vy - nanmean(vy)^2;
        
        % Crosscorrelation of actin mean intensity at BB position with actin mean intensity in the surrounding position of BB
        [corr_meanint_meanintsurrBB, lags_meanint_meanintsurrBB] = xcorr(mi, msi, 'unbiased'); % getting correlation
        corr_meanint_meanintsurrBB = corr_meanint_meanintsurrBB - nanmean(mi)*nanmean(msi);
        % Crosscorrelation of actin mean intensity at BB position with BB speed
        [corr_meanint_speed, lags_speed_meanint] = xcorr(mi,spd, 'unbiased'); % getting correlation
        corr_meanint_speed = corr_meanint_speed - nanmean(mi)*nanmean(spd);
        % Crosscorrelation of actin mean intensity in the surrounding position of BB with BB speed
        [corr_meanintsurrBB_speed, lags_speed_meanintsurrBB] = xcorr(msi, spd, 'unbiased'); % getting correlation
        corr_meanintsurrBB_speed = corr_meanintsurrBB_speed - nanmean(msi)*nanmean(spd);
        % Crosscorrelation of actin mean intensity at BB position with vx
        [corr_meanint_vx, lags_meanint_vx] = xcorr(mi, vx, 'unbiased');
        corr_meanint_vx = corr_meanint_vx - nanmean(mi)*nanmean(vx);
        % Crosscorrelation of actin mean intensity at BB position with vy
        [corr_meanint_vy, lags_meanint_vy] = xcorr(mi, vy, 'unbiased');
        corr_meanint_vy = corr_meanint_vy - nanmean(mi)*nanmean(vy);
        % Crosscorrelation of actin mean intensity in the surrounding position of BB with vx
        [corr_meanintsurrBB_vx, lags_meanintsurrBB_vx] = xcorr(msi, vx, 'unbiased');
        corr_meanintsurrBB_vx = corr_meanintsurrBB_vx - nanmean(msi)*nanmean(vx);
        % Crosscorrelation of actin mean intensity in the surrounding position of BB with vy
        [corr_meanintsurrBB_vy, lags_meanintsurrBB_vy] = xcorr(msi, vy, 'unbiased');
        corr_meanintsurrBB_vy = corr_meanintsurrBB_vy - nanmean(msi)*nanmean(vy);
        
        % Changing the vector direction of the correlation functions for other operations down the script
        corr_meanint_meanint = corr_meanint_meanint';
        corr_meanintsurrBB_meanintsurrBB = corr_meanintsurrBB_meanintsurrBB';
        % corr_speed_speed = corr_speed_speed';
        %corr_vx_vx = corr_vx_vx';
        %corr_vy_vy = corr_vy_vy';
        corr_meanint_meanintsurrBB = corr_meanint_meanintsurrBB';
        corr_meanint_speed = corr_meanint_speed';
        corr_meanintsurrBB_speed = corr_meanintsurrBB_speed';
        corr_meanint_vx = corr_meanint_vx';
        corr_meanint_vy = corr_meanint_vy';
        corr_meanintsurrBB_vx = corr_meanintsurrBB_vx';
        corr_meanintsurrBB_vy = corr_meanintsurrBB_vy';
        
        % Changing the length of all correlation vectors so that only one half of the correlation function is plotted
        len_corr_meanint_speed = length(corr_meanint_speed); % getting the length of correlation vector
        split_speed_meanint = (len_corr_meanint_speed+1)/2; % finding the midpoint in the correlation vector
        
        % Autocorrelation of actin mean intensity at the position of BB
        corr_meanint_meanint_forplotting = corr_meanint_meanint(1, (split_speed_meanint:len_corr_meanint_speed)); % changing length of correlation vector
        lags_meanint_meanint_forplotting = lags_meanint_meanint(1, (split_speed_meanint:len_corr_meanint_speed)) * Time_interval; % changing length of the corresponding lagtime and converting to minutes
        % Autocorrelation of actin mean intensity in the surrounding position of BB
        corr_meanintsurrBB_meanintsurrBB_forplotting = corr_meanintsurrBB_meanintsurrBB(1, (split_speed_meanint:len_corr_meanint_speed)); % changing length of correlation vector
        lags_meanintsurrBB_meanintsurrBB_forplotting = lags_meanintsurrBB_meanintsurrBB(1, (split_speed_meanint:len_corr_meanint_speed)) * Time_interval; % changing length of the corresponding lagtime and converting to minutes
        % Autocorrelation of BB speed
        corr_speed_speed_forplotting = corr_speed_speed(1, (split_speed_meanint:len_corr_meanint_speed)); % changing length of correlation vector
        lags_speed_speed_forplotting = lags_speed_speed(1, (split_speed_meanint:len_corr_meanint_speed)) * Time_interval; % changing length of the corresponding lagtime and converting to minutes
        % Autocorrelation of BB vx
        corr_vx_vx_forplotting = corr_vx_vx(1,(split_speed_meanint:len_corr_meanint_speed));
        lags_vx_vx_forplotting = lags_vx_vx(1,(split_speed_meanint:len_corr_meanint_speed)) * Time_interval; % changing length of the corresponding lagtime and converting to minutes
        % Autocorrelation of BB vy
        corr_vy_vy_forplotting = corr_vy_vy(1,(split_speed_meanint:len_corr_meanint_speed));
        lags_vy_vy_forplotting = lags_vy_vy(1,(split_speed_meanint:len_corr_meanint_speed)) * Time_interval; % changing length of the corresponding lagtime and converting to minutes
        
        
        % Crosscorrelation of actin mean intensity at the position of BB and in the surrounding position of BB
        corr_meanint_meanintsurrBB_forplotting = corr_meanint_meanintsurrBB(1, (split_speed_meanint:len_corr_meanint_speed)); % changing length of correlation vector
        lags_meanint_meanintsurrBB_forplotting = lags_meanint_meanintsurrBB(1, (split_speed_meanint:len_corr_meanint_speed)) * Time_interval; % changing length of the corresponding lagtime and converting to minutes
        % Crosscorrelation of actin mean intensity at the position of BB and BB speed
        corr_meanint_speed_forplotting = corr_meanint_speed(1, (split_speed_meanint:len_corr_meanint_speed)); % changing length of correlation vector
        lags_speed_meanint_forplotting = lags_speed_meanint(1, (split_speed_meanint:len_corr_meanint_speed)) * Time_interval; % changing length of the corresponding lagtime and converting to minutes
        % Crosscorrelation of actin mean intensity in the surrounding position of BB and BB speed
        corr_meanintsurrBB_speed_forplotting = corr_meanintsurrBB_speed(1, (split_speed_meanint:len_corr_meanint_speed)); % changing length of correlation vector
        lags_speed_meanintsurrBB_forplotting = lags_speed_meanintsurrBB(1, (split_speed_meanint:len_corr_meanint_speed)) * Time_interval; % changing length of the corresponding lagtime and converting to minutes
        % Crosscorrelation of actin mean intensity at BB position with vx
        corr_meanint_vx_forplotting = corr_meanint_vx(1, (split_speed_meanint:len_corr_meanint_speed));
        lags_meanint_vx_forplotting = lags_meanint_vx(1, (split_speed_meanint:len_corr_meanint_speed)) * Time_interval; % changing length of the corresponding lagtime and converting to minutes
        % Crosscorrelation of actin mean intensity at BB position with vy
        corr_meanint_vy_forplotting = corr_meanint_vy(1, (split_speed_meanint:len_corr_meanint_speed));
        lags_meanint_vy_forplotting = lags_meanint_vy(1, (split_speed_meanint:len_corr_meanint_speed)) * Time_interval; % changing length of the corresponding lagtime and converting to minutes
        % Crosscorrelation of actin mean intensity at BB position with vx
        corr_meanintsurrBB_vx_forplotting = corr_meanintsurrBB_vx(1, (split_speed_meanint:len_corr_meanint_speed));
        lags_meanintsurrBB_vx_forplotting = lags_meanintsurrBB_vx(1, (split_speed_meanint:len_corr_meanint_speed)) * Time_interval; % changing length of the corresponding lagtime and converting to minutes
        % Crosscorrelation of actin mean intensity at BB position with vy
        corr_meanintsurrBB_vy_forplotting = corr_meanintsurrBB_vy(1, (split_speed_meanint:len_corr_meanint_speed));
        lags_meanintsurrBB_vy_forplotting = lags_meanintsurrBB_vy(1, (split_speed_meanint:len_corr_meanint_speed)) * Time_interval; % changing length of the corresponding lagtime and converting to minutes
        
        
        % Getting the sum of all correlation functions to later obtain the average and plot as one correlation function
        % This "if loop" makes sure that the length of correlation vector is adjusted so that a sum of subsequent arrays can be performed. An average of the sum will be obtained outside the loop below.
        % This is required because, depending the trajectory length, the correlation vector of that trajectory will also change. Vectors of different lengths cannot be "summed". Therefore they are adjusted to the
        % same length by padding zeros at the end of trajectories.
        
        if length(sum_corr_meanint_meanint_forplotting) < length (corr_meanint_meanint_forplotting)
            % Autocorrelation of actin mean intensity at the position of BB
            sum_corr_meanint_meanint_forplotting = [sum_corr_meanint_meanint_forplotting, zeros(1, length(corr_meanint_meanint_forplotting) - length(sum_corr_meanint_meanint_forplotting))];
            sum_corr_meanint_meanint_forplotting = sum_corr_meanint_meanint_forplotting + corr_meanint_meanint_forplotting;
            % Autocorrelation of actin mean intensity in the surrounding position of BB
            sum_corr_meanintsurrBB_meanintsurrBB_forplotting = [sum_corr_meanintsurrBB_meanintsurrBB_forplotting, zeros(1, length(corr_meanint_meanint_forplotting) - length(sum_corr_meanintsurrBB_meanintsurrBB_forplotting))];
            sum_corr_meanintsurrBB_meanintsurrBB_forplotting = sum_corr_meanintsurrBB_meanintsurrBB_forplotting + corr_meanintsurrBB_meanintsurrBB_forplotting;
            % Autocorrelation of BB speed
            sum_corr_speed_speed_forplotting = [sum_corr_speed_speed_forplotting, zeros(1, length(corr_meanint_meanint_forplotting) - length(sum_corr_speed_speed_forplotting))];
            sum_corr_speed_speed_forplotting = sum_corr_speed_speed_forplotting + corr_speed_speed_forplotting;
            % Autocorrelation of BB vx
            sum_corr_vx_vx_forplotting = [sum_corr_vx_vx_forplotting, zeros(1, length(corr_meanint_meanint_forplotting) - length(sum_corr_vx_vx_forplotting))];
            sum_corr_vx_vx_forplotting = sum_corr_vx_vx_forplotting + corr_vx_vx_forplotting;
            % Autocorrelation of BB vy
            sum_corr_vy_vy_forplotting = [sum_corr_vy_vy_forplotting, zeros(1, length(corr_meanint_meanint_forplotting) - length(sum_corr_vy_vy_forplotting))];
            sum_corr_vy_vy_forplotting = sum_corr_vy_vy_forplotting + corr_vy_vy_forplotting;
            % Crosscorrelation of actin mean intensity at the position of BB and in the surrounding position of BB
            sum_corr_meanint_meanintsurrBB_forplotting = [sum_corr_meanint_meanintsurrBB_forplotting, zeros(1, length(corr_meanint_meanint_forplotting) - length(sum_corr_meanint_meanintsurrBB_forplotting))];
            sum_corr_meanint_meanintsurrBB_forplotting = sum_corr_meanint_meanintsurrBB_forplotting + corr_meanint_meanintsurrBB_forplotting;
            % Crosscorrelation of actin mean intensity at the position of BB and BB speed
            sum_corr_meanint_speed_forplotting  = [sum_corr_meanint_speed_forplotting , zeros(1, length(corr_meanint_meanint_forplotting) - length(sum_corr_meanint_speed_forplotting))];
            sum_corr_meanint_speed_forplotting  = sum_corr_meanint_speed_forplotting  + corr_meanint_speed_forplotting ;
            % Crosscorrelation of actin mean intensity in the surrounding position of BB and BB speed
            sum_corr_meanintsurrBB_speed_forplotting  = [sum_corr_meanintsurrBB_speed_forplotting , zeros(1, length(corr_meanint_meanint_forplotting) - length(sum_corr_meanintsurrBB_speed_forplotting))];
            sum_corr_meanintsurrBB_speed_forplotting  = sum_corr_meanintsurrBB_speed_forplotting  + corr_meanintsurrBB_speed_forplotting;
            % Crosscorrelation of actin mean intensity at BB position with vx
            sum_corr_meanint_vx_forplotting = [sum_corr_meanint_vx_forplotting, zeros(1, length(corr_meanint_meanint_forplotting) - length(sum_corr_meanint_vx_forplotting))];
            sum_corr_meanint_vx_forplotting = sum_corr_meanint_vx_forplotting + corr_meanint_vx_forplotting;
            % Crosscorrelation of actin mean intensity at BB position with vy
            sum_corr_meanint_vy_forplotting = [sum_corr_meanint_vy_forplotting, zeros(1, length(corr_meanint_meanint_forplotting) - length(sum_corr_meanint_vy_forplotting))];
            sum_corr_meanint_vy_forplotting = sum_corr_meanint_vy_forplotting + corr_meanint_vy_forplotting;
             % Crosscorrelation of actin mean intensity in the surrounding position of BB with vx
            sum_corr_meanintsurrBB_vx_forplotting = [sum_corr_meanintsurrBB_vx_forplotting, zeros(1, length(corr_meanint_meanint_forplotting) - length(sum_corr_meanintsurrBB_vx_forplotting))];
            sum_corr_meanintsurrBB_vx_forplotting = sum_corr_meanintsurrBB_vx_forplotting + corr_meanintsurrBB_vx_forplotting;
            % Crosscorrelation of actin mean intensity in the surrounding position of BB with vy
            sum_corr_meanintsurrBB_vy_forplotting = [sum_corr_meanintsurrBB_vy_forplotting, zeros(1, length(corr_meanint_meanint_forplotting) - length(sum_corr_meanintsurrBB_vy_forplotting))];
            sum_corr_meanintsurrBB_vy_forplotting = sum_corr_meanintsurrBB_vy_forplotting + corr_meanintsurrBB_vy_forplotting;
                
        elseif length(sum_corr_meanint_meanint_forplotting) > length (corr_meanint_meanint_forplotting)
            % Autocorrelation of actin mean intensity at the position of BB
            padded_corr_meanint_meanint_forplotting = [corr_meanint_meanint_forplotting, zeros(1, length(sum_corr_meanint_meanint_forplotting) - length(corr_meanint_meanint_forplotting))];
            sum_corr_meanint_meanint_forplotting = sum_corr_meanint_meanint_forplotting + padded_corr_meanint_meanint_forplotting;
            % Autocorrelation of actin mean intensity in the surrounding position of BB
            padded_corr_meanintsurrBB_meanintsurrBB_forplotting = [corr_meanintsurrBB_meanintsurrBB_forplotting, zeros(1, length(sum_corr_meanint_meanint_forplotting) - length(corr_meanintsurrBB_meanintsurrBB_forplotting))];
            sum_corr_meanintsurrBB_meanintsurrBB_forplotting = sum_corr_meanintsurrBB_meanintsurrBB_forplotting + padded_corr_meanintsurrBB_meanintsurrBB_forplotting;
            % Autocorrelation of BB speed            
            padded_corr_speed_speed_forplotting = [corr_speed_speed_forplotting, zeros(1, length(sum_corr_meanint_meanint_forplotting) - length(corr_speed_speed_forplotting))];
            sum_corr_speed_speed_forplotting = sum_corr_speed_speed_forplotting + padded_corr_speed_speed_forplotting;
            % Autocorrelation of BB vx
            padded_corr_vx_vx_forplotting = [corr_vx_vx_forplotting, zeros(1, length(sum_corr_meanint_meanint_forplotting) - length(corr_vx_vx_forplotting))];
            sum_corr_vx_vx_forplotting = sum_corr_vx_vx_forplotting + padded_corr_vx_vx_forplotting;
            % Autocorrelation of BB vy
            padded_corr_vy_vy_forplotting = [corr_vy_vy_forplotting, zeros(1, length(sum_corr_meanint_meanint_forplotting) - length(corr_vy_vy_forplotting))];
            sum_corr_vy_vy_forplotting = sum_corr_vy_vy_forplotting + padded_corr_vy_vy_forplotting;            
            % Crosscorrelation of actin mean intensity at the position of BB and in the surrounding position of BB
            padded_corr_meanint_meanintsurrBB_forplotting = [corr_meanint_meanintsurrBB_forplotting, zeros(1, length(sum_corr_meanint_meanint_forplotting) - length(corr_meanint_meanintsurrBB_forplotting))];
            sum_corr_meanint_meanintsurrBB_forplotting = sum_corr_meanint_meanintsurrBB_forplotting + padded_corr_meanint_meanintsurrBB_forplotting;
            % Crosscorrelation of actin mean intensity at the position of BB and BB speed
            padded_corr_meanint_speed_forplotting  = [corr_meanint_speed_forplotting , zeros(1, length(sum_corr_meanint_meanint_forplotting) - length(corr_meanint_speed_forplotting))];
            sum_corr_meanint_speed_forplotting = sum_corr_meanint_speed_forplotting + padded_corr_meanint_speed_forplotting;
            % Crosscorrelation of actin mean intensity in the surrounding position of BB and BB speed
            padded_corr_meanintsurrBB_speed_forplotting  = [corr_meanintsurrBB_speed_forplotting , zeros(1, length(sum_corr_meanint_meanint_forplotting) - length(corr_meanintsurrBB_speed_forplotting))];
            sum_corr_meanintsurrBB_speed_forplotting = sum_corr_meanintsurrBB_speed_forplotting + padded_corr_meanintsurrBB_speed_forplotting;
            % Crosscorrelation of actin mean intensity at BB position with vx
            padded_corr_meanint_vx_forplotting = [corr_meanint_vx_forplotting, zeros(1, length(sum_corr_meanint_meanint_forplotting) - length(corr_meanint_vx_forplotting))];
            sum_corr_meanint_vx_forplotting = sum_corr_meanint_vx_forplotting + padded_corr_meanint_vx_forplotting;
            % Crosscorrelation of actin mean intensity at BB position with vy
            padded_corr_meanint_vy_forplotting = [corr_meanint_vy_forplotting, zeros(1, length(sum_corr_meanint_meanint_forplotting) - length(corr_meanint_vy_forplotting))];
            sum_corr_meanint_vy_forplotting = sum_corr_meanint_vy_forplotting + padded_corr_meanint_vy_forplotting;
            % Crosscorrelation of actin mean intensity in the surrounding position of BB with vx
            padded_corr_meanintsurrBB_vx_forplotting = [corr_meanintsurrBB_vx_forplotting, zeros(1, length(sum_corr_meanint_meanint_forplotting) - length(corr_meanintsurrBB_vx_forplotting))];
            sum_corr_meanintsurrBB_vx_forplotting = sum_corr_meanintsurrBB_vx_forplotting + padded_corr_meanintsurrBB_vx_forplotting;
            % Crosscorrelation of actin mean intensity in the surrounding position of BB with vy
            padded_corr_meanintsurrBB_vy_forplotting = [corr_meanintsurrBB_vy_forplotting, zeros(1, length(sum_corr_meanint_meanint_forplotting) - length(corr_meanintsurrBB_vy_forplotting))];
            sum_corr_meanintsurrBB_vy_forplotting = sum_corr_meanintsurrBB_vy_forplotting + padded_corr_meanintsurrBB_vy_forplotting;
        
        else
            sum_corr_meanint_meanint_forplotting = sum_corr_meanint_meanint_forplotting + corr_meanint_meanint_forplotting;
            sum_corr_meanintsurrBB_meanintsurrBB_forplotting = sum_corr_meanintsurrBB_meanintsurrBB_forplotting + corr_meanintsurrBB_meanintsurrBB_forplotting;
            sum_corr_speed_speed_forplotting = sum_corr_speed_speed_forplotting + corr_speed_speed_forplotting;
            sum_corr_vx_vx_forplotting =  sum_corr_vx_vx_forplotting +  corr_vx_vx_forplotting;
            sum_corr_vy_vy_forplotting =  sum_corr_vy_vy_forplotting +  corr_vy_vy_forplotting;            
            sum_corr_meanint_meanintsurrBB_forplotting = sum_corr_meanint_meanintsurrBB_forplotting + corr_meanint_meanintsurrBB_forplotting;
            sum_corr_meanint_speed_forplotting = sum_corr_meanint_speed_forplotting + corr_meanint_speed_forplotting;
            sum_corr_meanintsurrBB_speed_forplotting = sum_corr_meanintsurrBB_speed_forplotting + corr_meanintsurrBB_speed_forplotting;
            sum_corr_meanint_vx_forplotting = sum_corr_meanint_vx_forplotting + corr_meanint_vx_forplotting;
            sum_corr_meanint_vy_forplotting = sum_corr_meanint_vy_forplotting + corr_meanint_vy_forplotting;
            sum_corr_meanintsurrBB_vx_forplotting = sum_corr_meanintsurrBB_vx_forplotting + corr_meanintsurrBB_vx_forplotting;
            sum_corr_meanintsurrBB_vy_forplotting = sum_corr_meanintsurrBB_vy_forplotting + corr_meanintsurrBB_vy_forplotting;
        end
        
        if length(lags_meanint_meanint_forplotting) > max_lag_length
            max_lag_length = length(lags_meanint_meanint_forplotting);
            
            final_lags_meanint_meanint_forplotting = lags_meanint_meanint_forplotting; % Autocorrelation of actin mean intensity at the position of BB
            final_lags_meanintsurrBB_meanintsurrBB_forplotting = lags_meanintsurrBB_meanintsurrBB_forplotting; % Autocorrelation of actin mean intensity in the surrounding position of BB
            final_lags_speed_speed_forplotting = lags_speed_speed_forplotting; % Autocorrelation of BB speed
            final_lags_vx_vx_forplotting = lags_vx_vx_forplotting; % Autocorrelation of BB vx
            final_lags_vy_vy_forplotting = lags_vy_vy_forplotting; % Autocorrelation of BB vy
            final_lags_meanint_meanintsurrBB_forplotting = lags_meanint_meanintsurrBB_forplotting; % Crosscorrelation of actin mean intensity at the position of BB and in the surrounding position of BB
            final_lags_speed_meanint_forplotting = lags_speed_meanint_forplotting; % Crosscorrelation of actin mean intensity at the position of BB and BB speed
            final_lags_speed_meanintsurrBB_forplotting = lags_speed_meanintsurrBB_forplotting; % Crosscorrelation of actin mean intensity in the surrounding position of BB and BB speed
            final_lags_meanint_vx_forplotting = lags_meanint_vx_forplotting;
            final_lags_meanint_vy_forplotting = lags_meanint_vy_forplotting;
            final_lags_meanintsurrBB_vx_forplotting = lags_meanintsurrBB_vx_forplotting;
            final_lags_meanintsurrBB_vy_forplotting = lags_meanintsurrBB_vy_forplotting;           
        end
        
        figure(1);
        plot(lags_meanint_meanint_forplotting,corr_meanint_meanint_forplotting,'k-x');
        hold on
        figure(2);
        plot(lags_meanintsurrBB_meanintsurrBB_forplotting,corr_meanintsurrBB_meanintsurrBB_forplotting,'k-x');
        hold on
        figure(3);
        plot(lags_speed_speed_forplotting,corr_speed_speed_forplotting,'b-x');
        hold on
        figure(4);
        plot(lags_vx_vx_forplotting, corr_vx_vx_forplotting, 'r-x');
        hold on
        figure(5);
        plot(lags_vy_vy_forplotting, corr_vy_vy_forplotting, 'r-x');
        hold on
        figure(6);
        plot(lags_meanint_meanintsurrBB_forplotting,corr_meanint_meanintsurrBB_forplotting,'k-x');
        hold on
        figure(7);
        plot(lags_speed_meanint_forplotting,corr_meanint_speed_forplotting,'b-x');
        hold on
        figure(8);
        plot(lags_speed_meanintsurrBB_forplotting,corr_meanintsurrBB_speed_forplotting,'b-x');
        hold on
        figure(9);
        plot(lags_meanint_vx_forplotting, corr_meanint_vx_forplotting, 'r-x');
        hold on 
        figure(10);
        plot(lags_meanint_vy_forplotting, corr_meanint_vy_forplotting, 'r-x');
        hold on 
        figure(11);
        plot(lags_meanintsurrBB_vx_forplotting, corr_meanintsurrBB_vx_forplotting, 'r-x');
        hold on 
        figure(12);
        plot(lags_meanintsurrBB_vy_forplotting, corr_meanintsurrBB_vy_forplotting, 'r-x');
        hold on 
                
        clear timeforspeed; clear speed; clear distance; clear V_x; clear V_y; clear V_angle;  %disp(trajno);
               
    end
end

% for defining xlimit
maxxlimit = max(timestep(:)) + 10;

% savelink for the figures
correlation = strcat('../Plots/ActinInt_at&around_basalbody_position_', sprintf('%01d', traj_filter_duration), 'minlongTraj/Apical_domain/Correlations');

figure(1);
xlabel('Lag time [min]');  ylabel('C_{MeanIntensity-MeanIntensity}'); title('Autocorrelation (MeanIntensity-MeanIntensity) at BB position'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Autocorr--MeanInt-MeanInt_at_BB'),'fig'); saveas(gcf, fullfile(correlation, 'Autocorr--MeanInt-MeanInt_at_BB'),'tif');
figure(2);
xlabel('Lag time [min]');  ylabel('C_{MeanIntensity-MeanIntensity}'); title('Autocorrelation (MeanIntensity-MeanIntensity) - surrounding BB'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Autocorr--MeanInt-MeanInt_SurroundingBB'),'fig'); saveas(gcf, fullfile(correlation, 'Autocorr--MeanInt-MeanInt_SurroundingBB'),'tif');
figure(3);
xlabel('Lag time [min]');  ylabel('C_{speed-speed}'); title('Autocorrelation (speed-speed)'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); %xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Autocorr--speed-speed'),'fig'); saveas(gcf, fullfile(correlation, 'Autocorr--speed-speed'),'tif');
figure(4);
xlabel('Lag time [min]');  ylabel('C_{Vx-Vx}'); title('Autocorrelation (Vx-Vx)'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); %xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Autocorr--Vx-Vx'),'fig'); saveas(gcf, fullfile(correlation, 'Autocorr--Vx-Vx'),'tif');
figure(5);
xlabel('Lag time [min]');  ylabel('C_{Vy-Vy}'); title('Autocorrelation (Vy-Vy)'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); %xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Autocorr--Vy-Vy'),'fig'); saveas(gcf, fullfile(correlation, 'Autocorr--Vy-Vy'),'tif');
figure(6);
xlabel('Lag time [min]');  ylabel('C_{MeanIntensityatBB-MeanIntensitySurrBB}'); title('Crosscorrelation (MeanIntensityAtBB-MeanIntensitySurrBB)'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Crosscorr--MeanIntAtBB-MeanIntSurrBB'),'fig'); saveas(gcf, fullfile(correlation, 'Crosscorr--MeanIntAtBB-MeanIntSurrBB'),'tif');
figure(7);
xlabel('Lag time [min]'); ylabel('C_{MeanIntensity-Speed}'); title('Crosscorrelation (MeanIntensity-Speed) at BB position'); set(gca,'fontsize',10); % ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Crosscorr--MeanInt-Speed'),'fig'); saveas(gcf, fullfile(correlation, 'Crosscorr--MeanInt-Speed'),'tif');
figure(8);
xlabel('Lag time [min]');  ylabel('C_{MeanIntensity-Speed}'); title('Crosscorrelation (MeanIntensity-Speed) - surrounding BB'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Crosscorr--MeanInt_SurroundingBB-Speed'),'fig'); saveas(gcf, fullfile(correlation, 'Crosscorr--MeanInt_SurroundingBB-Speed'),'tif');
figure(9);
xlabel('Lag time [min]'); ylabel('C_{MeanIntensity-Vx}'); title('Crosscorrelation (MeanIntensity-Vx) at BB position'); set(gca,'fontsize',10); % ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Crosscorr--MeanInt-Vx'),'fig'); saveas(gcf, fullfile(correlation, 'Crosscorr--MeanInt-Vx'),'tif');
figure(10);
xlabel('Lag time [min]'); ylabel('C_{MeanIntensity-Vy}'); title('Crosscorrelation (MeanIntensity-Vy) at BB position'); set(gca,'fontsize',10); % ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Crosscorr--MeanInt-Vy'),'fig'); saveas(gcf, fullfile(correlation, 'Crosscorr--MeanInt-Vy'),'tif');
figure(11);
xlabel('Lag time [min]'); ylabel('C_{MeanIntensity-Vx}'); title('Crosscorrelation (MeanIntensity-Vx) - surrounding BB'); set(gca,'fontsize',10); % ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Crosscorr--MeanInt_SurroundingBB-Vx'),'fig'); saveas(gcf, fullfile(correlation, 'Crosscorr--MeanInt_SurroundingBB-Vx'),'tif');
figure(12);
xlabel('Lag time [min]'); ylabel('C_{MeanIntensity-Vy}'); title('Crosscorrelation (MeanIntensity-Vy) - surrounding BB'); set(gca,'fontsize',10); % ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Crosscorr--MeanInt_SurroundingBB-Vy'),'fig'); saveas(gcf, fullfile(correlation, 'Crosscorr--MeanInt_SurroundingBB-Vy'),'tif');

figure(13);
avg_corr_meanint_meanint_forplotting = sum_corr_meanint_meanint_forplotting / length((trajectoryno(trajectoryno~=0)));
plot(final_lags_meanint_meanint_forplotting, avg_corr_meanint_meanint_forplotting,'k-x');
xlabel('Lag time [min]');  ylabel('Averaged C_{MeanIntensity-MeanIntensity}'); title('Averaged autocorrelation (MeanIntensity-MeanIntensity) at BB position'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Averaged_autocorr--MeanInt-MeanInt'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_autocorr--MeanInt-MeanInt'),'tif');
% getting FFT for meanintensity-atBB autoccorelation - to confirm oscillation
get_input = FFT_autocorr_plot(Time_interval, avg_corr_meanint_meanint_forplotting); % Calling the function "FFT_autocorr_plot" and feeding the input
figure(111);
saveas(gcf, fullfile(correlation, 'Averaged_autocorr--MeanInt-MeanInt_FFT'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_autocorr--MeanInt-MeanInt_FFT'),'tif');
close(figure(111));

figure(14);
avg_corr_meanintsurrBB_meanintsurrBB_forplotting = sum_corr_meanintsurrBB_meanintsurrBB_forplotting / length((trajectoryno(trajectoryno~=0)));
plot(final_lags_meanintsurrBB_meanintsurrBB_forplotting, avg_corr_meanintsurrBB_meanintsurrBB_forplotting,'k-x');
xlabel('Lag time [min]');  ylabel('Averaged C_{MeanIntensity-MeanIntensity}'); title('Averaged autocorrelation (MeanIntensity-MeanIntensity) - surrounding BB'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Averaged_autocorr--MeanInt-MeanInt_SurroundingBB'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_autocorr--MeanInt-MeanInt_SurroundingBB'),'tif');
% getting FFT for meanintensity-BBsurround autoccorelation - to confirm oscillation
get_input = FFT_autocorr_plot(Time_interval, avg_corr_meanintsurrBB_meanintsurrBB_forplotting); % Calling the function "FFT_autocorr_plot" and feeding the input
figure(111);
saveas(gcf, fullfile(correlation, 'Averaged_autocorr--MeanInt-MeanInt_SurroundingBB_FFT'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_autocorr--MeanInt-MeanInt_SurroundingBB_FFT'),'tif');
close(figure(111));

figure(15);
avg_corr_speed_speed_forplotting = sum_corr_speed_speed_forplotting / length((trajectoryno(trajectoryno~=0)));
plot(final_lags_speed_speed_forplotting, avg_corr_speed_speed_forplotting,'b-x');
xlabel('Lag time [min]');  ylabel('Averaged C_{speed-speed}'); title('Averaged autocorrelation (speed-speed)'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); %xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Averaged_autocorr--speed-speed'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_autocorr--speed-speed'),'tif');
% getting FFT for speed autoccorelation - to confirm oscillation
get_input = FFT_autocorr_plot(Time_interval, avg_corr_speed_speed_forplotting); % Calling the function "FFT_autocorr_plot" and feeding the input
figure(111);
saveas(gcf, fullfile(correlation, 'Averaged_autocorr--speed-speed_FFT'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_autocorr--speed-speed_FFT'),'tif');
close(figure(111));

figure(16);
avg_corr_vx_vx_forplotting = sum_corr_vx_vx_forplotting / length((trajectoryno(trajectoryno~=0)));
plot(final_lags_vx_vx_forplotting, avg_corr_vx_vx_forplotting,'r-x');
xlabel('Lag time [min]');  ylabel('Averaged C_{Vx-Vx}'); title('Averaged autocorrelation (Vx-Vx)'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); %xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Averaged_autocorr--Vx-Vx'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_autocorr--Vx-Vx'),'tif');
% getting FFT for Vx autoccorelation - to confirm oscillation
get_input = FFT_autocorr_plot(Time_interval, avg_corr_vx_vx_forplotting); % Calling the function "FFT_autocorr_plot" and feeding the input
figure(111);
saveas(gcf, fullfile(correlation, 'Averaged_autocorr--Vx-Vx_FFT'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_autocorr--Vx-Vx_FFT'),'tif');
close(figure(111));

figure(17);
avg_corr_vy_vy_forplotting = sum_corr_vy_vy_forplotting / length((trajectoryno(trajectoryno~=0)));
plot(final_lags_vy_vy_forplotting, avg_corr_vy_vy_forplotting,'r-x');
xlabel('Lag time [min]');  ylabel('Averaged C_{Vy-Vy}'); title('Averaged autocorrelation (Vy-Vy)'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); %xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Averaged_autocorr--Vy-Vy'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_autocorr--Vy-Vy'),'tif');
% getting FFT for Vy autoccorelation - to confirm oscillation
get_input = FFT_autocorr_plot(Time_interval, avg_corr_vy_vy_forplotting); % Calling the function "FFT_autocorr_plot" and feeding the input
figure(111);
saveas(gcf, fullfile(correlation, 'Averaged_autocorr--Vy-Vy_FFT'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_autocorr--Vy-Vy_FFT'),'tif');
close(figure(111));

figure(18);
avg_corr_meanint_meanintsurrBB_forplotting = sum_corr_meanint_meanintsurrBB_forplotting / length((trajectoryno(trajectoryno~=0)));
plot(final_lags_meanint_meanintsurrBB_forplotting, avg_corr_meanint_meanintsurrBB_forplotting,'k-x');
xlabel('Lag time [min]');  ylabel('Averaged C_{MeanIntensityatBB-MeanIntensitySurrBB}'); title('Averaged Crosscorrelation (MeanIntensityAtBB-MeanIntensitySurrBB)'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanIntAtBB-MeanIntSurrBB'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanIntAtBB-MeanIntSurrBB'),'tif');
figure(19);
avg_corr_meanint_speed_forplotting = sum_corr_meanint_speed_forplotting / length((trajectoryno(trajectoryno~=0)));
plot(final_lags_speed_meanint_forplotting, avg_corr_meanint_speed_forplotting,'b-x');
xlabel('Lag time [min]'); ylabel('Averaged C_{MeanIntensity-Speed}'); title('Averaged Crosscorrelation (MeanIntensity-Speed) at BB position'); set(gca,'fontsize',10); % ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanInt-Speed'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanInt-Speed'),'tif');
figure(20);
avg_corr_meanintsurrBB_speed_forplotting = sum_corr_meanintsurrBB_speed_forplotting / length((trajectoryno(trajectoryno~=0)));
plot(final_lags_speed_meanintsurrBB_forplotting, avg_corr_meanintsurrBB_speed_forplotting,'b-x');
xlabel('Lag time [min]');  ylabel('Averaged C_{MeanIntensity-Speed}'); title('Averaged Crosscorrelation (MeanIntensity-Speed) - surrounding BB'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanInt_SurroundingBB-Speed'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanInt_SurroundingBB-Speed'),'tif');
figure(21);
avg_corr_meanint_vx_forplotting = sum_corr_meanint_vx_forplotting / length((trajectoryno(trajectoryno~=0)));
plot(final_lags_meanint_vx_forplotting, avg_corr_meanint_vx_forplotting,'r-x');
xlabel('Lag time [min]');  ylabel('Averaged C_{MeanIntensity-Vx}'); title('Averaged Crosscorrelation (MeanIntensity-Vx)at BB position'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanInt-Vx'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanInt-Vx'),'tif');
figure(22);
avg_corr_meanint_vy_forplotting = sum_corr_meanint_vy_forplotting / length((trajectoryno(trajectoryno~=0)));
plot(final_lags_meanint_vy_forplotting, avg_corr_meanint_vy_forplotting,'r-x');
xlabel('Lag time [min]');  ylabel('Averaged C_{MeanIntensity-Vy}'); title('Averaged Crosscorrelation (MeanIntensity-Vy)at BB position'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanInt-Vy'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanInt-Vy'),'tif');
figure(23);
avg_corr_meanintsurrBB_vx_forplotting = sum_corr_meanintsurrBB_vx_forplotting / length((trajectoryno(trajectoryno~=0)));
plot(final_lags_meanintsurrBB_vx_forplotting, avg_corr_meanintsurrBB_vx_forplotting,'r-x');
xlabel('Lag time [min]');  ylabel('Averaged C_{MeanIntensity-Vx}'); title('Averaged Crosscorrelation (MeanIntensity-Vx)- surrounding position'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanInt_SurroundingBB-Vx'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanInt_SurroundingBB-Vx'),'tif');
figure(24);
avg_corr_meanintsurrBB_vy_forplotting = sum_corr_meanintsurrBB_vy_forplotting / length((trajectoryno(trajectoryno~=0)));
plot(final_lags_meanintsurrBB_vy_forplotting, avg_corr_meanintsurrBB_vy_forplotting,'r-x');
xlabel('Lag time [min]');  ylabel('Averaged C_{MeanIntensity-Vy}'); title('Averaged Crosscorrelation (MeanIntensity-Vy)- surrounding position'); set(gca,'fontsize',10); %ylim([-0.01 1.1]); xlim([-1 maxxlimit]);
saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanInt_SurroundingBB-Vy'),'fig'); saveas(gcf, fullfile(correlation, 'Averaged_Crosscorr--MeanInt_SurroundingBB-Vy'),'tif');

close all;

%% Section 2
% Data organisation: The trajectories are aligned exactly against those frames where they start and where they end. In other words, the matrices containing the intensities include all timepoints of the experiment but the intensities are filled between those
% timepoints where the BB (i.e. trajectory) appears and disappears. So when we plot the intensities (against area or time), we get an idea of how the intensities evolve w.r.to the area expansion. The other way of organising is aligning all the starting points of 
% trajectories as 1st timepoint. This kind of organisation and plots can be seen in Section 3.

% In the section below, we get the intensities at BB position and in the surrounding, and plot them along with the ratio of surrounding-to-position
maxNoRows = numel(Timelist); % finding the total no of frames. Because, this will be the maximum length that a trajectory can have.
MeanInt_BBposition = NaN(maxNoRows,no_of_trajectories); % preallocation
TotalInt_BBposition = NaN(maxNoRows,no_of_trajectories); % preallocation
MeanInt_BBsurround = NaN(maxNoRows,no_of_trajectories); % preallocation
TotalInt_BBsurround = NaN(maxNoRows,no_of_trajectories); % preallocation

% The for loop below collects the different intensities for all trajectories; Here the trajectories are plotted exactly against those frames where they start and where they end
for trajno = 1:no_of_trajectories
    kend = length(Trajectory_data{trajno,1});

    % this is to make sure that only those trajectories that are longer than "traj_filter_duration" (in no of frames) are taken for analysis - smaller trajectories are not plotted
    if kend <= traj_filter_duration % "traj_filter_duration" corresponds to the time (in frames) chosen based on the tracking plugin output. Check the "value_for_filter.txt". Check the description
        % in the first few lines of the script (Gradients_BB_int_normalization_by_cortex_Traj_after_filtering.m) where this value "traj_filter_duration" is obtained as input.
        continue
    else
        for ab = 1:length(Trajectory_data{trajno,2}(:,1))
            corresframeno = Trajectory_data{trajno,2}(ab,1);
            MeanInt_BBposition(corresframeno,trajno) = Trajectory_data{trajno,5}(ab,1); % - All_background{1,corresframeno}(Ap_slice,1); 
            MeanInt_BBposition(corresframeno,trajno) = MeanInt_BBposition(corresframeno,trajno) / cortex_meanint{1,corresframeno}(Ap_slice,1);

            TotalInt_BBposition(corresframeno,trajno) = Trajectory_data{trajno,6}(ab,1); % - All_background{1,corresframeno}(Ap_slice,1);
            TotalInt_BBposition(corresframeno,trajno) = TotalInt_BBposition(corresframeno,trajno) / cortex_totalint{1,corresframeno}(Ap_slice,1);

            MeanInt_BBsurround(corresframeno,trajno) = Trajectory_data{trajno,7}(ab,1); % - All_background{1,corresframeno}(Ap_slice,1);
            MeanInt_BBsurround(corresframeno,trajno) = MeanInt_BBsurround(corresframeno,trajno) / cortex_meanint{1,corresframeno}(Ap_slice,1);

            TotalInt_BBsurround(corresframeno,trajno) = Trajectory_data{trajno,8}(ab,1); % - All_background{1,corresframeno}(Ap_slice,1);
            TotalInt_BBsurround(corresframeno,trajno) = TotalInt_BBsurround(corresframeno,trajno) / cortex_totalint{1,corresframeno}(Ap_slice,1);
        end
    end
end

% getting the ratio of the intensity of BB surrounding position to the intensity at the BB position
MeanInt_BB_SurPos_ratio = MeanInt_BBsurround ./ MeanInt_BBposition;
TotalInt_BB_SurPos_ratio = TotalInt_BBsurround ./ TotalInt_BBposition;

% getting the intensities at the first & final frame (at max. area) of trajectories 
% below we find those trajectories that exist at the final time point (i.e. max. area) and compare their intensities between the first time point to final max area time point
MaxAreaINdex = find(max_apical_area_idx);
traj_colms = find(~isnan(MeanInt_BBposition(MaxAreaINdex,:))); % finding the index of those columns (i.e. trajectories) that are found at the final time point (i.e. max area time point) - and these indices are stored in 'traj_colms'
[~, firstNonNaNRow] = max(~isnan(MeanInt_BBposition(:, traj_colms)), [], 1); % finding the first row index for those columns (from above) where the first non-NaN value appears (in other words, the row that corresponds to the starting point of the trajectory or BB appearance)

MeanInt_atBBpos_1st_frame = MeanInt_BBposition(sub2ind(size(MeanInt_BBposition), firstNonNaNRow, traj_colms))'; % getting the mean intensity at BB position in the starting frame for those trajectories that exist until final time point
MeanInt_atBBpos_max_apical_area = MeanInt_BBposition(MaxAreaINdex, traj_colms)'; % getting the mean intensity at BB position in the last frame (i.e. max. area) for those trajectories that exist until final time point
TotalInt_atBBpos_1st_frame = TotalInt_BBposition(sub2ind(size(TotalInt_BBposition), firstNonNaNRow, traj_colms))'; % getting the mean intensity at BB position in the starting frame for those trajectories that exist until final time point
TotalInt_atBBpos_max_apical_area = TotalInt_BBposition(MaxAreaINdex, traj_colms)'; % getting the mean intensity at BB position in the last frame (i.e. max. area) for those trajectories that exist until final time point

MeanInt_atBBSurr_1st_frame = MeanInt_BBsurround(sub2ind(size(MeanInt_BBsurround), firstNonNaNRow, traj_colms))'; % getting the mean intensity at BB position in the starting frame for those trajectories that exist until final time point
MeanInt_atBBSurr_max_apical_area = MeanInt_BBsurround(MaxAreaINdex, traj_colms)'; % getting the mean intensity at BB surrounding position in the last frame (i.e. max. area) for those trajectories that exist until final time point
TotalInt_atBBSurr_1st_frame = TotalInt_BBsurround(sub2ind(size(TotalInt_BBsurround), firstNonNaNRow, traj_colms))'; % getting the mean intensity at BB position in the starting frame for those trajectories that exist until final time point
TotalInt_atBBSurr_max_apical_area = TotalInt_BBsurround(MaxAreaINdex, traj_colms)'; % getting the mean intensity at BB surrounding position in the last frame (i.e. max. area) for those trajectories that exist until final time point

MeanInt_ratio_BBSurPos_1st_frame = MeanInt_BB_SurPos_ratio(sub2ind(size(MeanInt_BB_SurPos_ratio), firstNonNaNRow, traj_colms))'; % getting the mean intensity at BB position in the starting frame for those trajectories that exist until final time point
MeanInt_ratio_BBSurPos_max_apical_area = MeanInt_BB_SurPos_ratio(MaxAreaINdex, traj_colms)'; % ratio of the mean intensity of BB surrounding position to the intensity in the BB position at the last frame (i.e. max. area) for those trajectories that exist until final time point
TotalInt_ratio_BBSurPos_1st_frame = TotalInt_BB_SurPos_ratio(sub2ind(size(TotalInt_BB_SurPos_ratio), firstNonNaNRow, traj_colms))'; % getting the mean intensity at BB position in the starting frame for those trajectories that exist until final time point
TotalInt_ratio_BBSurPos_max_apical_area = TotalInt_BB_SurPos_ratio(MaxAreaINdex, traj_colms)'; % ratio of the total intensity of BB surrounding position to the intensity in the BB position at the last frame (i.e. max. area) for those trajectories that exist until final time point

% Plots
% creating a repetitive array of time and area to plot against the intensities
Timelist_clone = repmat(Timelist(1:size(MeanInt_BBposition,1),1), 1, size(MeanInt_BBposition,2));
Timelist_clone_all_times = Timelist_clone(:); % linearising the array for usage in average script
Area_apicaldomain_clone = repmat(Area_apicaldomain(1:size(MeanInt_BBposition,1),1), 1,size(MeanInt_BBposition,2));
Area_apicaldomain_clone_all_times = Area_apicaldomain_clone(:); % linearising the array for usage in average script

% Remember that in the figures (1-8) below, plots against time have been already plotted in 'Gradients_BB_int_normalization_by_cortex_Traj_after_filtering.m'. But the plots against area are not plotted. So these plots are again plotted.
% One important difference between the plots here and the already plotted ones in 'Gradients_BB_int_normalization_by_cortex_Traj_after_filtering.m': here, only those trajectories that exist at the end (max area / final time point) are 
% plotted to demonstrate that the final intensities (at max. area / final time point) are higher than the initial intensities. Rest of the trajectories are left out because they are not present at the max. area time point. If all the 
% trajecories are included, then the plots here and the ones from 'Gradients_BB_int_normalization_by_cortex_Traj_after_filtering.m' are the same when plotted against time. 

% getting only those trajectories that are found at the final time point i.e. max area
Timelist_clone_traj_atmaxarea_only = Timelist_clone(:,traj_colms); Area_apicaldomain_clone_traj_atmaxarea_only = Area_apicaldomain_clone(:,traj_colms);
MeanInt_BBposition_traj_atmaxarea_only = MeanInt_BBposition(:,traj_colms); TotalInt_BBposition_traj_atmaxarea_only = TotalInt_BBposition(:,traj_colms);
MeanInt_BBsurround_traj_atmaxarea_only = MeanInt_BBsurround(:,traj_colms); TotalInt_BBsurround_traj_atmaxarea_only = TotalInt_BBsurround(:,traj_colms);
MeanInt_BB_SurPos_ratio_traj_atmaxarea_only = MeanInt_BB_SurPos_ratio(:,traj_colms); TotalInt_BB_SurPos_ratio_traj_atmaxarea_only = MeanInt_BB_SurPos_ratio(:,traj_colms);

% Mean intensity at BB position against Time & Area
figure(1);
plot(Timelist_clone_traj_atmaxarea_only, MeanInt_BBposition_traj_atmaxarea_only, '.-b','LineWidth', 0.5, 'MarkerSize',0.2);
xlabel('Time [min]');  ylabel('Mean intensity (normalised)'); title('Mean Int. at BB position vs Time'); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'meanInt_bbpos_vs_time'),'fig'); saveas(gcf, fullfile(correlation, 'meanInt_bbpos_vs_time'),'tif');
figure(2);
plot(Area_apicaldomain_clone_traj_atmaxarea_only, MeanInt_BBposition_traj_atmaxarea_only, '.-k','LineWidth', 0.5, 'MarkerSize',0.2); 
xlabel('Area [\mum^2]');  ylabel('Mean intensity (normalised)'); title('Mean Int. at BB position vs Area'); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'meanInt_bbpos_vs_area'),'fig'); saveas(gcf, fullfile(correlation, 'meanInt_bbpos_vs_area'),'tif');

% Total intensity at BB position against Time & Area
figure(3);
plot(Timelist_clone_traj_atmaxarea_only, TotalInt_BBposition_traj_atmaxarea_only, '.-b','LineWidth', 0.5, 'MarkerSize',0.2);
xlabel('Time [min]');  ylabel('Total intensity (normalised)'); title('Total Int. at BB position vs Time'); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'totalInt_bbpos_vs_time'),'fig'); saveas(gcf, fullfile(correlation, 'totalInt_bbpos_vs_time'),'tif');
figure(4);
plot(Area_apicaldomain_clone_traj_atmaxarea_only, TotalInt_BBposition_traj_atmaxarea_only, '.-k','LineWidth', 0.5, 'MarkerSize',0.2); 
xlabel('Area [\mum^2]');  ylabel('Total intensity (normalised)'); title('Total Int. at BB position vs Area'); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'totalInt_bbpos_vs_area'),'fig'); saveas(gcf, fullfile(correlation, 'totalInt_bbpos_vs_area'),'tif');

% Mean intensity at BB surround against Time & Area
figure(5);
plot(Timelist_clone_traj_atmaxarea_only, MeanInt_BBsurround_traj_atmaxarea_only, '.-b','LineWidth', 0.5, 'MarkerSize',0.2);
xlabel('Time [min]');  ylabel('Mean intensity (normalised)'); title('Mean Int. at BB surrounding position vs Time'); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'meanInt_bbsurpos_vs_time'),'fig'); saveas(gcf, fullfile(correlation, 'meanInt_bbsurpos_vs_time'),'tif');
figure(6);
plot(Area_apicaldomain_clone_traj_atmaxarea_only, MeanInt_BBsurround_traj_atmaxarea_only, '.-k','LineWidth', 0.5, 'MarkerSize',0.2); 
xlabel('Area [\mum^2]');  ylabel('Mean intensity (normalised)'); title('Mean Int. at BB surrounding position vs Area'); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'meanInt_bbsurpos_vs_area'),'fig'); saveas(gcf, fullfile(correlation, 'meanInt_bbsurpos_vs_area'),'tif');

% Total intensity at BB surround against Time & Area
figure(7);
plot(Timelist_clone_traj_atmaxarea_only, TotalInt_BBsurround_traj_atmaxarea_only, '.-b','LineWidth', 0.5, 'MarkerSize',0.2);
xlabel('Time [min]');  ylabel('Total intensity (normalised)'); title('Total Int. at BB surrounding position vs Time'); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'totalInt_bbsurpos_vs_time'),'fig'); saveas(gcf, fullfile(correlation, 'totalInt_bbsurpos_vs_time'),'tif');
figure(8);
plot(Area_apicaldomain_clone_traj_atmaxarea_only, TotalInt_BBsurround_traj_atmaxarea_only, '.-k','LineWidth', 0.5, 'MarkerSize',0.2); 
xlabel('Area [\mum^2]');  ylabel('Total intensity (normalised)'); title('Total Int. at BB surrounding position vs Area'); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'totalInt_bbsurpos_vs_area'),'fig'); saveas(gcf, fullfile(correlation, 'totalInt_bbsurpos_vs_area'),'tif');

% Mean intensity ratio of (surrounding-to-position) against Time & Area
figure(9);
plot(Timelist_clone_traj_atmaxarea_only, MeanInt_BB_SurPos_ratio_traj_atmaxarea_only, '.-b','LineWidth', 0.5, 'MarkerSize',0.2);
xlabel('Time [min]');  ylabel('Mean intensity (Surrounding/position) (normalised)'); title('Ratio of Mean Int. (surrounding-to-position) vs Time'); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'meanInt_ratio_bbsurpos_vs_time'),'fig'); saveas(gcf, fullfile(correlation, 'meanInt_ratio_bbsurpos_vs_time'),'tif');
figure(10);
plot(Area_apicaldomain_clone_traj_atmaxarea_only, MeanInt_BB_SurPos_ratio_traj_atmaxarea_only, '.-b','LineWidth', 0.5, 'MarkerSize',0.2);
xlabel('Area [\mum^2]');  ylabel('Mean intensity (Surrounding/position) (normalised)'); title('Ratio of Mean Int. (surrounding-to-position) vs Area'); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'meanInt_ratio_bbsurpos_vs_area'),'fig'); saveas(gcf, fullfile(correlation, 'meanInt_ratio_bbsurpos_vs_area'),'tif');

% Total intensity ratio of (surrounding-to-position) against Time & Area
figure(11);
plot(Timelist_clone_traj_atmaxarea_only, TotalInt_BB_SurPos_ratio_traj_atmaxarea_only, '.-k','LineWidth', 0.5, 'MarkerSize',0.2); 
xlabel('Time [min]');  ylabel('Total intensity (Surrounding/position) (normalised)'); title('Ratio of Total Int. (surrounding-to-position) vs Time'); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'totalInt_ratio_bbsurpos_vs_time'),'fig'); saveas(gcf, fullfile(correlation, 'totalInt_ratio_bbsurpos_vs_time'),'tif');
figure(12);
plot(Area_apicaldomain_clone_traj_atmaxarea_only, TotalInt_BB_SurPos_ratio_traj_atmaxarea_only, '.-k','LineWidth', 0.5, 'MarkerSize',0.2); 
xlabel('Area [\mum^2]');  ylabel('Total intensity (Surrounding/position) (normalised)'); title('Ratio of Total Int. (surrounding-to-position) vs Area'); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'totalInt_ratio_bbsurpos_vs_area'),'fig'); saveas(gcf, fullfile(correlation, 'totalInt_ratio_bbsurpos_vs_area'),'tif');

close all;

% Mean intensity at BB position - Box plot comparison between 1st and last frame 
prepping_plotting_box_plots(MeanInt_atBBpos_1st_frame, MeanInt_atBBpos_max_apical_area, 'Mean Intensity (normalised)', {'Mean intensity at BB position', 'comparison btw 1st & last frame (max.area)'}, 'comparison_meanIntBBpos', correlation)

% Total intensity at BB position - Box plot comparison between 1st and last frame 
prepping_plotting_box_plots(TotalInt_atBBpos_1st_frame, TotalInt_atBBpos_max_apical_area, 'Total Intensity (normalised)', {'Total intensity at BB position', 'comparison btw 1st & last frame (max.area)'}, 'comparison_totalIntBBpos', correlation)

% Mean intensity at BB surrounding - Box plot comparison between 1st and last frame 
prepping_plotting_box_plots(MeanInt_atBBSurr_1st_frame, MeanInt_atBBSurr_max_apical_area, 'Mean Intensity (normalised)', {'Mean intensity at BB surrounding position', 'comparison btw 1st & last frame (max.area)'}, 'comparison_meanIntBBsurpos', correlation)

% Total intensity at BB surrounding - Box plot comparison between 1st and last frame 
prepping_plotting_box_plots(TotalInt_atBBSurr_1st_frame, TotalInt_atBBSurr_max_apical_area, 'Total Intensity (normalised)', {'Total intensity at BB surrounding position', 'comparison btw 1st & last frame (max.area)'}, 'comparison_totalIntBBsurpos', correlation)

% Mean intensity ratio of BB surrounding-to-BB position - Box plot comparison between 1st and last frame 
prepping_plotting_box_plots(MeanInt_ratio_BBSurPos_1st_frame, MeanInt_ratio_BBSurPos_max_apical_area, 'Mean Intensity (normalised)', {'Mean intensity ratio (surrounding to BB position)', 'comparison btw 1st & last frame (max.area)'}, 'comparison_meanIntBBratio', correlation)

% Total intensity ratio of BB surrounding-to-BB position - Box plot comparison between 1st and last frame 
prepping_plotting_box_plots(TotalInt_ratio_BBSurPos_1st_frame, TotalInt_ratio_BBSurPos_max_apical_area, 'Total Intensity (normalised)', {'Total intensity ratio (surrounding to BB position)', 'comparison btw 1st & last frame (max.area)'}, 'comparison_totalIntBBratio', correlation)

close all;

%% Section 3 
% Data organisation: The initial time point of all trajectories is aligned. In other words, the starting time point of all trajectories is by default assumed to be the first time point. So in this organisation, there is no reference to area expansion. 
% In this case, the intensities cannot be plotted against area simply because the starting points of all trajectories is aligned to be the same i.e. first time point is the starting timepoint of all trajectories. Therefore here we can only plot
% the intensities against the trajectory time and not against area. This plot will only tell us about how the intensities are evolving between the starting and the ending points of the trajectories. It does not tell us about how the intensities are evolving across area.
% The other way of organising is aligning the trajectories to their exact corresponding timepoints during the experiment i.e. the trajectories are aligned exactly against those frames where they start and where they end. Check section 2 for this kind of organisation and plots
% In this section, the suffix '_aligned' refers to those matrices/variables/plots that corresponds to the data of those trajectories where the starting point of all the trajectories are aligned to first time point 

MeanInt_BBposition_aligned = trajectory_aligning(MeanInt_BBposition); % calling the function for aligning the trajectories
TotalInt_BBposition_aligned = trajectory_aligning(TotalInt_BBposition); % calling the function for aligning the trajectories
MeanInt_BBsurround_aligned = trajectory_aligning(MeanInt_BBsurround); % calling the function for aligning the trajectories
TotalInt_BBsurround_aligned = trajectory_aligning(TotalInt_BBsurround); % calling the function for aligning the trajectories
MeanInt_BB_SurPos_ratio_aligned = MeanInt_BBsurround_aligned ./ MeanInt_BBposition_aligned;
TotalInt_BB_SurPos_ratio_aligned = TotalInt_BBsurround_aligned ./ TotalInt_BBposition_aligned;

% getting only those trajectories that are found at the final time point i.e. max area
MeanInt_BBposition_traj_atmaxarea_only_aligned = MeanInt_BBposition_aligned(:,traj_colms); TotalInt_BBposition_traj_atmaxarea_only_aligned = TotalInt_BBposition_aligned(:,traj_colms);
MeanInt_BBsurround_traj_atmaxarea_only_aligned = MeanInt_BBsurround_aligned(:,traj_colms); TotalInt_BBsurround_traj_atmaxarea_only_aligned = TotalInt_BBsurround_aligned(:,traj_colms);
MeanInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned = MeanInt_BB_SurPos_ratio_aligned(:,traj_colms); TotalInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned = MeanInt_BB_SurPos_ratio_aligned(:,traj_colms);

% Mean intensity at BB position against Time
figure(1);
plot(Timelist_clone_traj_atmaxarea_only, MeanInt_BBposition_traj_atmaxarea_only_aligned, '.-b','LineWidth', 0.5, 'MarkerSize',0.2);
xlabel('Time [min]');  ylabel('Mean intensity (normalised)'); title({'Mean Int. at BB position vs Time', '(Trajectories aligned)'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'meanInt_bbpos_vs_time_traj_aligned'),'fig'); saveas(gcf, fullfile(correlation, 'meanInt_bbpos_vs_time_traj_aligned'),'tif');

% Total intensity at BB position against Time
figure(2);
plot(Timelist_clone_traj_atmaxarea_only, TotalInt_BBposition_traj_atmaxarea_only_aligned, '.-b','LineWidth', 0.5, 'MarkerSize',0.2);
xlabel('Time [min]');  ylabel('Total intensity (normalised)'); title({'Total Int. at BB position vs Time', '(Trajectories aligned)'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'totalInt_bbpos_vs_time_traj_aligned'),'fig'); saveas(gcf, fullfile(correlation, 'totalInt_bbpos_vs_time_traj_aligned'),'tif');

% Mean intensity at BB surround against Time
figure(3);
plot(Timelist_clone_traj_atmaxarea_only, MeanInt_BBsurround_traj_atmaxarea_only_aligned, '.-b','LineWidth', 0.5, 'MarkerSize',0.2);
xlabel('Time [min]');  ylabel('Mean intensity (normalised)'); title({'Mean Int. at BB surrounding position vs Time', '(Trajectories aligned)'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'meanInt_bbsurpos_vs_time_traj_aligned'),'fig'); saveas(gcf, fullfile(correlation, 'meanInt_bbsurpos_vs_time_traj_aligned'),'tif');

% Total intensity at BB surround against Time
figure(4);
plot(Timelist_clone_traj_atmaxarea_only, TotalInt_BBsurround_traj_atmaxarea_only_aligned, '.-b','LineWidth', 0.5, 'MarkerSize',0.2);
xlabel('Time [min]');  ylabel('Total intensity (normalised)'); title({'Total Int. at BB surrounding position vs Time', '(Trajectories aligned)'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'totalInt_bbsurpos_vs_time_traj_aligned'),'fig'); saveas(gcf, fullfile(correlation, 'totalInt_bbsurpos_vs_time_traj_aligned'),'tif');

% Mean intensity ratio of (surrounding-to-position) against Time
figure(5);
plot(Timelist_clone_traj_atmaxarea_only, MeanInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned, '.-b','LineWidth', 0.5, 'MarkerSize',0.2);
xlabel('Time [min]');  ylabel('Mean intensity (Surrounding/position) (normalised)'); title({'Ratio of Mean Int. (surrounding-to-position) vs Time', '(Trajectories aligned)'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'meanInt_ratio_bbsurpos_vs_time_traj_aligned'),'fig'); saveas(gcf, fullfile(correlation, 'meanInt_ratio_bbsurpos_vs_time_traj_aligned'),'tif');

% Total intensity ratio of (surrounding-to-position) against Time
figure(6);
plot(Timelist_clone_traj_atmaxarea_only, TotalInt_BB_SurPos_ratio_traj_atmaxarea_only_aligned, '.-k','LineWidth', 0.5, 'MarkerSize',0.2); 
xlabel('Time [min]');  ylabel('Total intensity (Surrounding/position) (normalised)'); title({'Ratio of Total Int. (surrounding-to-position) vs Time', '(Trajectories aligned)'}); set(gca,'fontsize',12);
saveas(gcf, fullfile(correlation, 'totalInt_ratio_bbsurpos_vs_time_traj_aligned'),'fig'); saveas(gcf, fullfile(correlation, 'totalInt_ratio_bbsurpos_vs_time_traj_aligned'),'tif');

close all;

%%
save('workspace_interim'); % This is to save all the variables in the workspace from "Gradients_BB_int_normalization_by_cortex_current" so that it can be used while getting the BB exit data. This is important because lot of variables in the below script is reused in the BB exit 
% script "tend_Time_dist_spatial_plot". Therefore, after running this script: (1) All the workspace variables are again saved for future % use; (2) Then all variables are cleared; (3) And then the 
% "intermin_workspace" is loaded which will be utilised by the "tend_Time_dist_spatial_plot"; (4) Finally all variables will be saved from "tend_Time_dist_spatial_plot" script.

%%
% saving as montage
montage_fig = '../Plots/montage';

fig1 = fullfile(correlation, 'Autocorr--MeanInt-MeanInt_at_BB.tif');
fig13 = fullfile(correlation, 'Averaged_autocorr--MeanInt-MeanInt.tif');
fig131 = fullfile(correlation, 'Averaged_autocorr--MeanInt-MeanInt_FFT.tif');
fig2 = fullfile(correlation, 'Autocorr--MeanInt-MeanInt_SurroundingBB.tif');
fig14 = fullfile(correlation, 'Averaged_autocorr--MeanInt-MeanInt_SurroundingBB.tif');
fig141 = fullfile(correlation, 'Averaged_autocorr--MeanInt-MeanInt_SurroundingBB_FFT.tif');
montage({fig1, fig13, fig131, fig2, fig14, fig141});
saveas(gcf, fullfile(montage_fig,'slide_8'), 'tif');

fig3 = fullfile(correlation, 'Autocorr--speed-speed.tif');
fig15 = fullfile(correlation, 'Averaged_autocorr--speed-speed.tif');
fig151 = fullfile(correlation, 'Averaged_autocorr--speed-speed_FFT.tif');
montage({fig3, fig15, fig151});
saveas(gcf, fullfile(montage_fig,'slide_9_1'), 'tif');

fig4 = fullfile(correlation, 'Autocorr--Vx-Vx.tif');
fig16 = fullfile(correlation, 'Averaged_autocorr--Vx-Vx.tif');
fig161 = fullfile(correlation, 'Averaged_autocorr--Vx-Vx_FFT.tif');
fig5 = fullfile(correlation, 'Autocorr--Vy-Vy.tif');
fig17 = fullfile(correlation, 'Averaged_autocorr--Vy-Vy.tif');
fig171 = fullfile(correlation, 'Averaged_autocorr--Vy-Vy_FFT.tif');
montage({fig4, fig16, fig161, fig5, fig17, fig171});
saveas(gcf, fullfile(montage_fig,'slide_9_2'), 'tif');

fig6 = fullfile(correlation, 'Crosscorr--MeanIntAtBB-MeanIntSurrBB.tif');
fig18 = fullfile(correlation, 'Averaged_Crosscorr--MeanIntAtBB-MeanIntSurrBB.tif');
montage({fig6, fig18});
saveas(gcf, fullfile(montage_fig,'slide_10'), 'tif');

fig9 = fullfile(correlation, 'Crosscorr--MeanInt-Vx.tif');
fig21 = fullfile(correlation, 'Averaged_Crosscorr--MeanInt-Vx.tif');
fig11 = fullfile(correlation, 'Crosscorr--MeanInt_SurroundingBB-Vx.tif');
fig23 = fullfile(correlation, 'Averaged_Crosscorr--MeanInt_SurroundingBB-Vx.tif');
fig10 = fullfile(correlation, 'Crosscorr--MeanInt-Vy.tif');
fig22 = fullfile(correlation, 'Averaged_Crosscorr--MeanInt-Vy.tif');
fig12 = fullfile(correlation, 'Crosscorr--MeanInt_SurroundingBB-Vy.tif');
fig24 = fullfile(correlation, 'Averaged_Crosscorr--MeanInt_SurroundingBB-Vy.tif');
montage({fig9, fig21, fig11, fig23, fig10, fig22, fig12, fig24});
saveas(gcf, fullfile(montage_fig,'slide_11'), 'tif');

fig7 = fullfile(correlation, 'Crosscorr--MeanInt-Speed.tif');
fig19 = fullfile(correlation, 'Averaged_Crosscorr--MeanInt-Speed.tif');
fig8 = fullfile(correlation, 'Crosscorr--MeanInt_SurroundingBB-Speed.tif');
fig20 = fullfile(correlation, 'Averaged_Crosscorr--MeanInt_SurroundingBB-Speed.tif');
montage({fig7, fig19, fig8, fig20});
saveas(gcf, fullfile(montage_fig,'slide_12'), 'tif');

fig25 = fullfile(correlation, 'meanInt_bbpos_vs_time.tif');
fig26 = fullfile(correlation, 'meanInt_bbpos_vs_area.tif');
fig27 = fullfile(correlation, 'totalInt_bbpos_vs_time.tif');
fig28 = fullfile(correlation, 'totalInt_bbpos_vs_area.tif');
fig29 = fullfile(correlation, 'meanInt_bbsurpos_vs_time.tif');
fig30 = fullfile(correlation, 'meanInt_bbsurpos_vs_area.tif');
fig31 = fullfile(correlation, 'totalInt_bbsurpos_vs_time.tif');
fig32 = fullfile(correlation, 'totalInt_bbsurpos_vs_area.tif');
fig33 = fullfile(correlation, 'meanInt_ratio_bbsurpos_vs_time.tif');
fig34 = fullfile(correlation, 'meanInt_ratio_bbsurpos_vs_area.tif');
fig35 = fullfile(correlation, 'totalInt_ratio_bbsurpos_vs_time.tif');
fig36 = fullfile(correlation, 'totalInt_ratio_bbsurpos_vs_area.tif');

fig37 = fullfile(correlation, 'meanInt_bbpos_vs_time_traj_aligned.tif');
fig38 = fullfile(correlation, 'totalInt_bbpos_vs_time_traj_aligned.tif');
fig39 = fullfile(correlation, 'meanInt_bbsurpos_vs_time_traj_aligned.tif');
fig40 = fullfile(correlation, 'totalInt_bbsurpos_vs_time_traj_aligned.tif');
fig41 = fullfile(correlation, 'meanInt_ratio_bbsurpos_vs_time_traj_aligned.tif');
fig42 = fullfile(correlation, 'totalInt_ratio_bbsurpos_vs_time_traj_aligned.tif');

fig43 = fullfile(correlation, 'comparison_meanIntBBpos.tif');
fig44 = fullfile(correlation, 'comparison_totalIntBBpos.tif');
fig45 = fullfile(correlation, 'comparison_meanIntBBsurpos.tif');
fig46 = fullfile(correlation, 'comparison_totalIntBBsurpos.tif');
fig47 = fullfile(correlation, 'comparison_meanIntBBratio.tif');
fig48 = fullfile(correlation, 'comparison_totalIntBBratio.tif');

montage({fig25, fig26, fig27, fig28, fig29, fig30, fig31, fig32, fig33, fig34, fig35, fig36, fig37, fig38, fig39, fig40, fig41, fig42, fig43, fig44, fig45, fig46, fig47, fig48});
saveas(gcf, fullfile(montage_fig,'slide_13'), 'tif');

close all;

disp('Finished !');


%% Function to align the trajectories
% This function gets a matrix (mix of NaN & non-NaN values) and does the following. It goes to every column, finds the row number of the first nonNaN value and
% shifts it to the first row. Essentially it also shifts all the nonNaN values that follow this first nonNaN value. Therefore we get rid of all the NaNs before 
% the first nonNaN value in every column. 
% This function is used to make the mean & total intensity matrices where the trajectories (i.e. the intensities of trajectories) are aligned in such a way 
% that the first trajectory position (i.e. the intensity at the first trajectory position) becomes the starting value or shifted to the first row number. 
% Here each column corresponds to a trajectory.

function output_matrix = trajectory_aligning(input_matrix)
    [rw, cl] = size(input_matrix); % getting the size of the matrix
    output_matrix = nan(rw, cl); % making an output matrix of nans with the same size as input_matrix
    [~, firstNonNaNrow] = max(~isnan(input_matrix), [], 1); % finding the first nonNaN row in all the columns of the input_matrix
    % Below we find all those columns in which all rows are NaNs i.e. those columns where there no nonNaN values. The output here is a logical array where columns 
    % with all NaN values are marked as 1.
    nan_cols = all(isnan(input_matrix), 1);
    col_indices = ~nan_cols; % we invert the logical array obtained in the previous step so that columns with all NaN values are marked as 0 and columns that contain
    % atleast one nonNaN value are marked as 1.
    % In the for loop below, we go through the logical array 'col_indices' and get the list of nonNaN values in each column of input matrix and place them in the 
    % corresponding column of output matrix. This way we modify the trajectory data so that the starting points of all trajectories are by default the first rows 
    % of corresponding columns.
    for i = find(col_indices)
        nonNaN_cols = input_matrix(firstNonNaNrow(i):end, i);
        output_matrix(1:length(nonNaN_cols), i) = nonNaN_cols;
    end
end

%% Function 15 from the 'final_average_all_18_general.m'
% This function is used for plotting box plot comparisons for control & MO conditions. Here we obtain the values for the control & mo conditions and make them suitable for box plots
function prepping_plotting_box_plots(ctrl_prm, mo_parm, Ylabel, Plot_title, save_title, correlation)
v_all = {ctrl_prm(:), mo_parm(:)}; % The control and mo vectors are input as a cell after converting to a column vector using '(:)'
[v3] = nan_padding(v_all); % this function brings all vectors (i.e. vectors in each of the cells of the cell array) to the same size by padding with NaN; then it returns the vectors in matrix format as 'v3'
prm = [v3(:,1), v3(:,2)]; prm_mean = mean(prm, "omitnan");
legnd_list = {'Initial time point', 'Final time point'}; linecolors = ['b' 'k'];
box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, correlation, legnd_list, linecolors); % this function plots the box plots for the input vectors
end

%% Function 14 from the 'final_average_all_18_general.m'
% This function pads vectors with NaNs to bring them to same size (any no of vectors can be input to this function)
% Using the function below, we go through each cell of all the cell arrays and find the cell with the maximum number of elements. Then we pad rest of the cells with NaNs to reach similar number of elements. This way: (1)
% all cells are made to be of same length i.e same number of elements; (2) the padding (to equalise the length) is done with NaNs; (3) by this we make sure that all zeros that were legitimately generated remain in place
% without getting replaced by nans (because the usual procedure is to replace the zeros that were generated to equalise the lengths with nans and in this process even the legitimately created zeros will be replaced with NaNs / this procedure allows to overcome this issue).
function [v3] = nan_padding(v_all) % getting the cell array 'v_all' as input
maxNo_rows = max(cellfun(@(c) size(c,1), v_all)); % finding the cell with the maximum length in the cell array 'v_all'
v3 = cell2mat((cellfun(@(x) {padarray(x,[maxNo_rows-size(x,1),0], NaN, 'Post')}, v_all))); % filling all the cells (i.e. vectors) in the cell array with NaN to bring them to the same size as the longest cell in this cell array and then convert it into a matrix
end

%% Function box plots from the 'final_average_all_18_general.m'
function box_plots_ctrl_mo_compare(prm, prm_mean, Ylabel, Plot_title, save_title, correlation, legnd_list, linecolors)
fig200 = figure(200);
% creating a swarm plot which is an alternative to scatter plot
grp1 = repmat(1:size(prm,2), size(prm,1), 1);
swarmchart(grp1(:), prm(:), 'o', 'r', 'MarkerFaceAlpha', 0, 'MarkerEdgeAlpha', 1, 'SizeData', 10);
hold on;
% creating a box plot
grp2 = repmat(1:size(prm,2), 1, 1);
bxp1 = boxplot(prm, grp2, 'labels', legnd_list, 'BoxStyle', 'outline', 'Colors', linecolors, 'Symbol',''); %  in order to plot the outliers, add some symbols like '.', 'o'etc to 'symbol'. Right now, the outliers are disabled by leaving the space empty.
set(bxp1, 'LineWidth', 1);
hold on;
% plotting the mean
plot(prm_mean, 'x-m', 'LineWidth', 2); % plotting the mean value
ylabel(Ylabel); title(Plot_title);  set(gca,'fontsize',12);
saveas(fig200, fullfile(correlation, save_title), 'fig'); saveas(fig200, fullfile(correlation, save_title), 'tif');
close(figure(200));
end

%%





