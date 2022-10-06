%{
function A = Lagrange(x,y)
%a_i = det(M_i)/det(M)
n = length(x);
A = zeros(1,n);
M = zeros(n,n);
for i = 1:n
    M(:,i) = x'.^(i-1);
end
m_det = det(M);
for i = 1:n
    Mi = M;
    Mi(:,i) = y';
    A(1,i) = det(Mi)/m_det;
end
end
%}
function out = Lagrange(t,x,y)
% Originally I want to compute Lagrange interpolating from definition: a_i
% = det(M_i)/det(M), but I failed. So I have to compute it based on
% formulation.
% This function will return the final results directly.
m = length(t);
out = t;
for k = 1:m
val = 0;
n = length(x);
for i = 1:n
    tmp = 1;
    for j = 1:n
        if j~=i
            tmp = tmp*(t(k)-x(j))/(x(i)-x(j));
        end
    end
    val = val + y(i)*tmp;
end
out(k) = val;
end
end