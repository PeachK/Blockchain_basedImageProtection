function [ featureImage ] = featureGen( im )
% �������ܣ�����ԭʼͼ�����ɶ�Ӧ������ͼ��im:ԭʼͼ��featureIm:����ͼ��
%% ָ��ͼ���С
[row,col]=size(im);
if row ~= 512 || col ~= 512
    im = imresize(im,[512,512]);%�ص�ָ����С(������ת������Ч��)
end
%% ͼ���һ������
[row,col]=size(im);
[normim, normtform, xdata, ydata] = imnorm(im, row, col);%ͼ���һ��

%% ��һ��ͼ����Ч������ȡ����
[ imCropValid ] = imcropValid( normim );
%% dwt2:��ɢ2άС���任
[a1,h1,v1,d1]=dwt2(imCropValid, 'haar');
[a2,h2,v2,d2]=dwt2(a1, 'haar');%����С���任������С���任֮��ͼ��X0�ĳ�������Ϊԭ�����ķ�֮һ��
imcropValidRelow = double(a2);
%% �ֿ�����ֵ�ֽⲿ��
imcropValidRelowBlock = blkproc(imcropValidRelow,[4,4],'SVD');
%% ˮӡ���ɲ���
featureImage = watermark(imcropValidRelowBlock);
end

