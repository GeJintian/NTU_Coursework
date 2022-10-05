a = 50; % Please change this value to 0.5, 5, 50
eps = 0.000001;
result = 0;
x = 0;
while(1)
    change = a.^(2*x+1)*(-1).^x/factorial(2*x+1);
    result = result + change;
    if (abs(change) < eps)
        break;
    end
    %display(change)
    %display(x)
    x = x + 1;
end
fprintf('The computation takes %d turns \n',x);
fprintf('The original function result is %0.15f\n',sin(a));
fprintf('The Taylor series evaluation result is %0.15f\n',result);