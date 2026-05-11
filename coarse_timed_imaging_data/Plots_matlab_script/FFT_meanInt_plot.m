
% This function is to plot the MeanInt_BB position and MeanInt_BBsurround

function get_input = FFT_meanInt_plot(Input1, Input2, Input3)

fft_quantity1 = Input2;
fft_quantity1 = fft_quantity1 - nanmean(fft_quantity1);
fft_y_1 = abs(fftn(fft_quantity1(1:end-1))).^2;

fft_quantity2 = Input3;
fft_quantity2 = fft_quantity2 - nanmean(fft_quantity2);
fft_y_2 = abs(fftn(fft_quantity2(1:end-1))).^2;

N = length(fft_y_1);

p_1 = fft_y_1(1:floor(N/2)); 
p_2 = fft_y_2(1:floor(N/2)); 

Time_interval = Input1;
Totaltime = N*Time_interval;
freq = (1:floor(N/2)) / Totaltime;
figure(111);
get_input = plot(freq, p_1, 'k+-', 'LineWidth',1);set(gca,'FontSize',16);
hold on;
plot(freq, p_2, 'ro-', 'LineWidth',1); set(gca,'FontSize',16); title('Power spectrum'); set(gca,'fontsize',12);
xlabel('Frequency [1/min]'); ylabel('Amplitude');

end
