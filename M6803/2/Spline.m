function B=Spline(x,y)
% This function will implement cubic spline.
% For n points, we should have n-1 segments, so 4(n-1) unknowns.
% P_i(t) = B_0i + B_1i(t-t_i) + B_2i(t-t_i)^2 + B_3i(t-t_i)^3
% Constraints should be:
% P_i(t_i) = y_i
% P_i(t_i+1) = y_i+1
% P_i'(t_i+1) = P_i+1'(t_i+1)
% P_i''(t_i+1) = P_i+1''(t_i+1)
% Denote P_i'' by m_i, we get
% h_i*m_i+2(h_i+h_i+1)*m_i+1+h_i+1m_i+2 = 6 ((y2-y1)/h1 - (y1-y)/h)
% And boundary conditions: P_0'' = 0, P_n'' = 0
n = length(x);
H =  zeros(n);
Y = zeros(n,1);
% Hm=Y
for i = 2:n-1
    H(i,i-1) = x(i)-x(i-1);%hi-1
    H(i,i) = 2*(x(i+1)-x(i)+x(i)-x(i-1));%2(h_i-1+h_i)
    H(i,i+1) = x(i+1)-x(i);%h_i
end
H(1,1)=1;
H(n,n)=1;
for i = 2:n-1 %6*(y_i+1-y_i)/h_i-6*(y_i-y_i-1)/h_i-1
    Y(i,1) = 6*((y(i+1)-y(i))/(x(i+1)-x(i))-(y(i)-y(i-1))/(x(i)-x(i-1)));
end
m = H\Y;
B = zeros(n-1,4);
for i = 1:n-1
    B(i,1) = y(i);
    B(i,2) = (y(i+1)-y(i))/(x(i+1)-x(i)) - (x(i+1)-x(i))/2*m(i,1) - (x(i+1)-x(i))/6*(m(i+1,1)-m(i,1));
    B(i,3) = m(i,1)/2;
    B(i,4) = (m(i+1,1)-m(i,1))/(6*(x(i+1)-x(i)));
end
end