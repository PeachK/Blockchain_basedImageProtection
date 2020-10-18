function [ zeroWatermark ] = zero_watermark_gen( im, waterm16, a, b, n )
% im:原始图像 waterm16：水印图像 a,b,n:置乱参数
%   零水印生成
%% 指定图像大小
[row,col]=size(im);
if row ~= 512 || col ~= 512
    im = imresize(im,[512,512]);%回到指定大小(对于旋转还是有效的)
end
%% 图像归一化部分
[row,col]=size(im);
[normim, normtform, xdata, ydata] = imnorm(im, row, col);%图像归一化
%% 归一化图像有效区域提取部分
[ imCropValid ] = imcropValid( normim );
%% dwt2:离散2维小波变换
[a1,h1,v1,d1]=dwt2(imCropValid, 'haar');
[a2,h2,v2,d2]=dwt2(a1, 'haar');%二级小波变换，两次小波变换之后，图像X0的长宽都变为原来的四分之一。
imcropValidRelow = double(a2);
%% 分块奇异值分解部分
imcropValidRelowBlock = blkproc(imcropValidRelow,[4,4],'SVD');
%% 水印生成部分
featureImage = watermark(imcropValidRelowBlock);
%% 置乱特征图像
arnFeatureImage = arnold(featureImage, a, b, n);%置乱特征图像
%% 置乱水印图像
arnWaterm = arnold(waterm16, a, b, n);%置乱水印图像
%% 特征和水印异或，生成零水印
 zeroWatermark = feaXorWat( arnWaterm, arnFeatureImage );
end

