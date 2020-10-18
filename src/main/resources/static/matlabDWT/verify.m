function result=verify(rawImage,watermarkImage,zeroWatermark,a,b,n)
    threValue = 0.85;%设定阈值
    im01=imread(rawImage);
    waterm16 = imread(watermarkImage);
    thresh = graythresh(waterm16); %自动确定二值化阈值
    waterm16 = im2bw(waterm16, thresh);%二值化
    
    zeroWatermark = imread(zeroWatermark);
    thresh = graythresh(zeroWatermark); %自动确定二值化阈值
    zeroWatermark = im2bw(zeroWatermark, thresh);%二值化
    recWaterm16 = zero_watermark_ver( im01, zeroWatermark, a, b, n );

    S = nc(waterm16, recWaterm16);
    

    if S >= threValue
        result=1;%成功
    else
        result=0;%验证失败
    end
end