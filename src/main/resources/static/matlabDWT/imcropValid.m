function [ imcropValid ] = imcropValid( imnorm )
%函数功能：对归一化图像的有效区域进行裁剪（舍入）

%% 以归一化图像的几何中心裁剪256x256大小的有效区域
imcropValid = imcrop(imnorm, [128, 128, 255, 255]);%裁剪正方有效区域

end

