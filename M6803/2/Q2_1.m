% Creating dataset
t_plt = 0:0.001:2*pi;
t_5 = 0:2*pi/4:2*pi;
t_20 = 0:2*pi/19:2*pi;
t_50 = 0:2*pi/49:2*pi;
y_5 = sin(t_5);
y_20 = sin(t_20);
y_50 = sin(t_50);

% For (a) polynomial fitting, return is coefficients.
poly_coef_5 = PolyFit(t_5,y_5)';
poly_coef_20 = PolyFit(t_20,y_20)';
poly_coef_50 = PolyFit(t_50,y_50)';
%plotting
t = [t_plt.^0; t_plt; t_plt.^2; t_plt.^3; t_plt.^4];
poly_res_5 = poly_coef_5*t;
poly_res_20 = poly_coef_20*t;
poly_res_50 = poly_coef_50*t;
plotting(poly_res_5, poly_res_20, poly_res_50, 'Polynomial');

% For (b) cubic spline inte, return is also coefficients.
spline_coef_5 = Spline(t_5,y_5);
spline_coef_20 = Spline(t_20,y_20);
spline_coef_50 = Spline(t_50,y_50);
%plotting
spline_res_5 = t_plt; %create blank result container
spline_res_20 = t_plt;
spline_res_50 = t_plt;
for i = 1:length(t_plt)
    spline_res_5(i) = eval_spline(spline_coef_5,t_plt(i), 2*pi/4);
    spline_res_20(i) = eval_spline(spline_coef_20,t_plt(i), 2*pi/19);
    spline_res_50(i) = eval_spline(spline_coef_50,t_plt(i), 2*pi/49);
end
plotting(spline_res_5, spline_res_20, spline_res_50, 'Spline');

% For (c) Lagrange Interpolating, return is direct result.
%plotting
lag_res_5 = Lagrange(t_plt,t_5,y_5);
lag_res_20 = Lagrange(t_plt,t_20,y_20);
lag_res_50 = Lagrange(t_plt,t_50,y_50);
plotting(lag_res_5, lag_res_20, lag_res_50, 'Lagrange');

function val = eval_spline(coef,t, interval_len)
    i = floor(t/interval_len)+1;
    if i > size(coef,1)
        %disp("reaching end")
        i = size(coef,1);
    end
    t = mod(t,interval_len);
    val = coef(i,1) + coef(i,2)*t + coef(i,3)*t^2 + coef(i,4)*t^3;
end
function plotting(res_5, res_20, res_50,type)
%This function will plot each result vs. gt and abs(difference) between fitting curve and sinx(x). 
%Creating x-axis and ground truth in plot
t_5 = 0:2*pi/4:2*pi;
t_20 = 0:2*pi/19:2*pi;
t_50 = 0:2*pi/49:2*pi;
y_5 = sin(t_5);
y_20 = sin(t_20);
y_50 = sin(t_50);
t_plt = 0:0.001:2*pi;
gt = sin(t_plt);
%calculate errors
err_5 = abs(res_5-gt);
err_20 = abs(res_20-gt);
err_50 = abs(res_50-gt);
%plt
figure;
subplot(3,2,1);
plot(t_plt,res_5,t_plt,gt,'--',t_5,y_5,'*');
legend('fitting curve','ground truth','data point');
title([type,' with 5 data points'])
subplot(3,2,2);
plot(t_plt, err_5);
title('Absolute errors with 5 data points');
subplot(3,2,3);
plot(t_plt,res_20,t_plt,gt,'--',t_20,y_20,'*');
legend('fitting curve','ground truth','data point');
title([type,' with 20 data points'])
subplot(3,2,4);
plot(t_plt, err_20);
title('Absolute errors with 20 data points');
subplot(3,2,5);
plot(t_plt,res_50,t_plt,gt,'--',t_50,y_50,'*');
legend('fitting curve','ground truth','data point');
title([type,' with 50 data points'])
subplot(3,2,6);
plot(t_plt, err_50);
title('Absolute errors with 50 data points');
end