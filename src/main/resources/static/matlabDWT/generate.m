% 水印算法主程序
function generate(rawImage,watermarkImage,a,b,n,zeroPathName) 

   %两个图片都应该给绝对路径，zeroPathName是零水印要保存的地址和文件名

   % filename01 = 'lena512.bmp';
   im01 = imread(rawImage);%读取原始图像

   % filename02 = 'waterm16.jpg';
   waterm16 = imread(watermarkImage);%读取水印图像
    thresh = graythresh(waterm16); %自动确定二值化阈值
    waterm16 = im2bw(waterm16, thresh);%二值化

    %disp('请输入置乱参数（a,b,n）：');
    %a = input('a = :');
    %b = input('b = :');
    %n = input('n = :');

    zeroWatermark = zero_watermark_gen( im01, waterm16, a, b, n );
    
    %把零水印保存到本地
    imwrite(zeroWatermark,zeroPathName);
end
%验证部分
