
% This function is to plo the FFT for speed

function get_input = FFT_autocorr_plot(Input1, Input2)

fft_quantity = Input2;
%fft_quantity = fft_quantity - nanmean(fft_quantity); 
fft_y = abs(fftn(fft_quantity(1:end-1))).^2;
N = length(fft_y);
p = fft_y(1:floor(N/2));
Time_interval = Input1;
Totaltime = N*Time_interval;
freq = (1:floor(N/2)) / Totaltime;
figure(111);
get_input = plot(freq, p, 'b+-', 'LineWidth',1);set(gca,'FontSize',16);
xlabel('Frequency [1/min]'); ylabel('Amplitude'); title('Power spectrum'); set(gca,'fontsize',12);

end

