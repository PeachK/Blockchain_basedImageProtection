function [ imcropValid ] = imcropValid( imnorm )
%�������ܣ��Թ�һ��ͼ�����Ч������вü������룩

%% �Թ�һ��ͼ��ļ������Ĳü�256x256��С����Ч����
imcropValid = imcrop(imnorm, [128, 128, 255, 255]);%�ü�������Ч����

end

