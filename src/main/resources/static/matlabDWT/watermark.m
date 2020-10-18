function zeroWatermark = watermark(x)
%% 水印生成；x:最大奇异值矩阵
[row, col] = size(x);
for i = 1:row
    for j = 1:col
        if mod(highBit(x(i,j)),2) == 0            
            x(i,j) = 1;% 最大奇异值的最高位，若为偶数，则1；反则0.
        else
            x(i,j) = 0;
        end
    end
end
zeroWatermark = x;
end