function A = PolyFit(x,y)
%This function will return the fitted coefficient matrix of polynomial of
%power 4.
%A could be solved by AX=Y -> A=X\Y. X is 5x5, so Y is 5x1.
%So, only need to compute X,Y.
Y = zeros(5,1);
X = zeros(5);
for i = 1:5
    for j = 1:5
        X(i,j) = sum(x.^(i+j-2));
    end
end
for i = 1:5
    Y(i,1) = sum((x.^(i-1)).*y);
end
A = X\Y;
end
