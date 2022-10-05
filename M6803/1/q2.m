mantissa = '00000000000000000000001'; %For (a), please use 111100101100010101101010
exponent = '00000001'; %For (a), please use 01011000
% The first bit of mantissa is used to represent the sign.

sign = mantissa(1);
mantissa(1)="1";
exp_sum = 0;
for i=1:length(exponent)
    exp_sum = exp_sum + str2num(exponent(i))*2^(length(exponent)-i);
end
exp_sum = exp_sum-127;
%display(exp_sum)
base_mat = 0:-1:-23;
base_mat = base_mat + exp_sum;
result = 0;
for i=1:length(mantissa)
    result = result + str2num(mantissa(i))*2^base_mat(i);
end
if str2num(sign) > 0.5
    result = -result;
end
display(result);