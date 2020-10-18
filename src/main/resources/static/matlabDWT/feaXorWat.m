function [ zeroWatermark ] = feaXorWat( arnWaterm, arnFeatureImage )
% 函数功能：水印与特征图像异或
% arnWaterm:置乱的水印图像
% arnFeatureImage：置乱的特征图像
%按行列异或
[row, col] = size(arnFeatureImage);
zeroW = zeros(row, col);
for i=1:row
    for j=1:col
        zeroW(i,j) = xor(arnWaterm(i,j),arnFeatureImage(i,j));
    end
end
zeroWatermark = zeroW;
end

