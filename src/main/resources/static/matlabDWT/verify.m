function result=verify(rawImage,watermarkImage,zeroWatermark,a,b,n)
    threValue = 0.85;%�趨��ֵ
    im01=imread(rawImage);
    waterm16 = imread(watermarkImage);
    thresh = graythresh(waterm16); %�Զ�ȷ����ֵ����ֵ
    waterm16 = im2bw(waterm16, thresh);%��ֵ��
    
    zeroWatermark = imread(zeroWatermark);
    thresh = graythresh(zeroWatermark); %�Զ�ȷ����ֵ����ֵ
    zeroWatermark = im2bw(zeroWatermark, thresh);%��ֵ��
    recWaterm16 = zero_watermark_ver( im01, zeroWatermark, a, b, n );

    S = nc(waterm16, recWaterm16);
    

    if S >= threValue
        result=1;%�ɹ�
    else
        result=0;%��֤ʧ��
    end
end