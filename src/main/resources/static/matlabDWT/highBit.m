function [ highBit ] = highBit( x )
%求一个值得最高位,测试有效。
y = num2str(x);
y1 = y(1);
highBit = str2num(y1);
end

