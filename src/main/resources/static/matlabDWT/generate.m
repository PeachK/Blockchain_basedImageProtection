% ˮӡ�㷨������
function generate(rawImage,watermarkImage,a,b,n,zeroPathName) 

   %����ͼƬ��Ӧ�ø�����·����zeroPathName����ˮӡҪ����ĵ�ַ���ļ���

   % filename01 = 'lena512.bmp';
   im01 = imread(rawImage);%��ȡԭʼͼ��

   % filename02 = 'waterm16.jpg';
   waterm16 = imread(watermarkImage);%��ȡˮӡͼ��
    thresh = graythresh(waterm16); %�Զ�ȷ����ֵ����ֵ
    waterm16 = im2bw(waterm16, thresh);%��ֵ��

    %disp('���������Ҳ�����a,b,n����');
    %a = input('a = :');
    %b = input('b = :');
    %n = input('n = :');

    zeroWatermark = zero_watermark_gen( im01, waterm16, a, b, n );
    
    %����ˮӡ���浽����
    imwrite(zeroWatermark,zeroPathName);
end
%��֤����
