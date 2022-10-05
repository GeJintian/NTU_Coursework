% Define the polynomial coefficient matrix here.
% coef_matrix is a m*n matrix. The value a_ij means the coefficient of
% x^i*y^j. Index starts from 0.
% For example, a matrix like
% |1, 2, 3, 4|
% |0, 1, 0, 0|
% |3, 1, 0, 0|
% will give f(x,y) = 1 + 2y + 3y^2 + 4y^3 + xy + 3x^2 + (x^2)y.

%The coefficient matrix of the polynomial required by the question is:
%[0 2 -3; 4 2 0; 1 0 0; 0 0 0; -2 0 0]
%For my own polynomials, they are:
%[0 8 -1; 6 0 0; -1 0 0] (-x^2+6x-y^2+8y)
%[]
%Please copy these matrices to replace the value of coef_matrix below to
%see the result.
coef_matrix = [0 19 -1 7 -3; 10 0 0 0 0; -1 0 0 0 0; 10 0 0 0 0; -2 0 0 0 0];
maxit = 1000;
f = polyno(coef_matrix);
fsurf(f,[-10 10 -10 10]);
tmp_x = 0;
tmp_y = 0;
[x_min,y_min] = steepest_descent(0,0,maxit,0.00001,f);
x = x_min;
y = y_min;
fprintf('Optimum point is at (%f, %f)\n',x,y);
fprintf('Maximum value is %f\n',eval(subs(f)));

function f = polyno(coef_matrix)
    % coef_matrix is a m*n matrix. The value a_ij means the coefficient of
    % x^i*y^j. Index starts from 0.
     syms x y;
     f = 0;
     [m,n] = size(coef_matrix);
     for i = 1:m
         for j = 1:n
             f = f + coef_matrix(i,j) * x^(i-1)*y^(j-1);
         end
     end
end

function [x_prev,y_prev] = steepest_descent(init_x, init_y, maxit, es, f)
%This compute steepest_descent. h is found by golden section. Partial
%differentials are computed by diff() function. It can also be computed as
%(f(x+a)-f(x))/a, but I suppose using diff() should be enough.
syms x y;
dif_x = diff(f,x);
dif_y = diff(f,y);
%plot surface here.
%figure;
fsurf(f,[-10 10 -10 10]);
hold on;
x = init_x;
y = init_y;
plot3(x,y,eval(subs(f)),'.b','markersize',10);
for i = 0:maxit
    %disp('s1');
    x_prev = init_x;
    y_prev = init_y;
    x = init_x;
    y = init_y;
    h = golden_section(init_x, init_y, eval(subs(dif_x)), eval(subs(dif_y)),1 , 10, -10, 0.00001, f);
    init_x = init_x - h*eval(subs(dif_x));
    init_y = init_y - h*eval(subs(dif_y));
    x = init_x;
    y = init_y;
    %disp(init_x);
    if sqrt((init_x-x_prev)^2+(init_y-y_prev)^2) < es
        plot3(x,y,eval(subs(f)),'*r','markersize',10);
        %disp('return');
        return
    end
    plot3(x,y,eval(subs(f)),'.g','markersize',20);
end
disp('Reaching maximum iter, not converge.');
end

function new_up = golden_section(init_x, init_y, dif_x, dif_y, prev_val, upper, lower, es, f)
% This function will compute golden ratio search to find the max step.
R=(sqrt(5)-1)/2;
new_up = upper - R*(upper-lower);
new_low = lower + R*(upper-lower);
%disp(new_up);
syms x y;
x = init_x - new_up*dif_x;
y = init_y - new_up*dif_y;
value_up = eval(subs(f));
x = init_x - new_low*dif_x;
y = init_y - new_low*dif_y;
value_low = eval(subs(f));
if value_low < value_up
    if new_up > new_low
        lower = new_low;
    else
        upper = new_low;
    end
else
    if new_up > new_low
        upper = new_up;
    else
        lower = new_up;
    end
end
if abs(prev_val - new_up) <= es
    return
else
    new_up = golden_section(init_x,init_y,dif_x,dif_y,new_up,upper,lower,es,f);
end
end
