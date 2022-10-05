a = 0.9; % Please change this value to 0.001, 0.01, 0.1, 0.9
eps = 0.000001;
result = 0;
x = 0;
while(1)
    change = (-1).^(x-1)*factorial(2*x)/(4.^x*factorial(x).^2*(2*x-1))*a.^x;
    result = result + change;
    if (abs(change) < eps)
        break;
    end
    %display(change)
    %display(x)
    x = x + 1;
end
fprintf('The computation takes %d turns \n',x);
fprintf('The original function result is %0.15f\n',(1+a).^0.5);
fprintf('The Taylor series evaluation result is %0.15f\n',result);