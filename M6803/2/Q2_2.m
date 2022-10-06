% Creating dataset
t_plt = 0:0.001:2*pi;
t_20 = 0:2*pi/19:2*pi;
y_o = sin(t_20);

y_e2 = random_noise(y_o,0.02);
y_e10 = random_noise(y_o,0.1);
y_e20 = random_noise(y_o,0.2);

% For (a) polynomial fitting, return is coefficients.
poly_coef_e2 = PolyFit(t_20,y_e2)';
poly_coef_e10 = PolyFit(t_20,y_e10)';
poly_coef_e20 = PolyFit(t_20,y_e20)';
%plotting
t = [t_plt.^0; t_plt; t_plt.^2; t_plt.^3; t_plt.^4];
poly_res_e2 = poly_coef_e2*t;
poly_res_e10 = poly_coef_e10*t;
poly_res_e20 = poly_coef_e20*t;
plotting(poly_res_e2, poly_res_e10, poly_res_e20,y_e2,y_e10,y_e20, 'Polynomial');

% For (b) cubic spline inte, return is also coefficients.
spline_coef_e2 = Spline(t_20,y_e2);
spline_coef_e10 = Spline(t_20,y_e10);
spline_coef_e20 = Spline(t_20,y_e20);
%plotting
spline_res_e2 = t_plt; %create blank result container
spline_res_e10 = t_plt;
spline_res_e20 = t_plt;
for i = 1:length(t_plt)
    spline_res_e2(i) = eval_spline(spline_coef_e2,t_plt(i), 2*pi/19);
    spline_res_e10(i) = eval_spline(spline_coef_e10,t_plt(i), 2*pi/19);
    spline_res_e20(i) = eval_spline(spline_coef_e20,t_plt(i), 2*pi/19);
end
plotting(spline_res_e2, spline_res_e10, spline_res_e20,y_e2,y_e10,y_e20, 'Spline');

% For (c) Lagrange Interpolating, return is direct result.
%plotting
lag_res_e2 = Lagrange(t_plt,t_20,y_e2);
lag_res_e10 = Lagrange(t_plt,t_20,y_e10);
lag_res_e20 = Lagrange(t_plt,t_20,y_e20);
plotting(lag_res_e2, lag_res_e10, lag_res_e20,y_e2,y_e10,y_e20, 'Lagrange');

function out = random_noise(y,p)
% p = 0.02, 0.1, 0.2
n = length(y);
out = y;
for i = 1:n
    out(i) = out(i) + (rand-0.5)*p;
end
end
function val = eval_spline(coef,t, interval_len)
    i = floor(t/interval_len)+1;
    if i > size(coef,1)
        %disp("reaching end")
        i = size(coef,1);
    end
    t = mod(t,interval_len);
    val = coef(i,1) + coef(i,2)*t + coef(i,3)*t^2 + coef(i,4)*t^3;
end
function plotting(res_e2, res_e10, res_e20,data_e2, data_e10, data_e20, type)
%This function will plot each result vs. gt and abs(difference) between fitting curve and sinx(x). 
%Creating x-axis and ground truth in plot
t_20 = 0:2*pi/19:2*pi;
t_plt = 0:0.001:2*pi;
gt = sin(t_plt);
%calculate errors
err_5 = abs(res_e2-gt);
err_20 = abs(res_e10-gt);
err_50 = abs(res_e20-gt);
%plt
figure;
subplot(3,2,1);
plot(t_plt,res_e2,t_plt,gt,'--',t_20,data_e2,'*');
legend('fitting curve','ground truth','data point');
title([type,' with 2% error'])
subplot(3,2,2);
plot(t_plt, err_5);
title('Absolute difference with fitting and ground truth');
subplot(3,2,3);
plot(t_plt,res_e10,t_plt,gt,'--',t_20,data_e10,'*');
legend('fitting curve','ground truth','data point');
title([type,' with 10% error'])
subplot(3,2,4);
plot(t_plt, err_20);
title('Absolute difference with fitting and ground truth');
subplot(3,2,5);
plot(t_plt,res_e20,t_plt,gt,'--',t_20,data_e20,'*');
legend('fitting curve','ground truth','data point');
title([type,' with 20% error'])
subplot(3,2,6);
plot(t_plt, err_50);
title('Absolute difference with fitting and ground truth');
end