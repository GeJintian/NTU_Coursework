a = 2;
b = 4;
c = 2;% Change the value of a, b, c here.
epsilon = 0.000000001;
if abs(b^2 - 4 * a * c) < epsilon * b^2
    root = -b/(2*a);
    fprintf('Only 1 root, which is %0.5f\n',root);
else
    if (b^2 - 4 * a * c > 0)
        root1 = (-b+sqrt(b^2 - 4 * a * c))/(2*a);
        root2 = (-b-sqrt(b^2 - 4 * a * c))/(2*a);
        fprintf('2 real roots, which are %0.5f and %0.5f\n',root1,root2);
    else
        root1 = (-b+sqrt(b^2 - 4 * a * c))/(2*a);
        root2 = (-b-sqrt(b^2 - 4 * a * c))/(2*a);
        fprintf('2 complex roots, which are %0.5f+%0.5fj and %0.5f+%0.5fj\n',real(root1),imag(root1),real(root2),imag(root2));
    end
end