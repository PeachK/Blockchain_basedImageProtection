function [ zeroWatermark ] = feaXorWat( arnWaterm, arnFeatureImage )
% �������ܣ�ˮӡ������ͼ�����
% arnWaterm:���ҵ�ˮӡͼ��
% arnFeatureImage�����ҵ�����ͼ��
%���������
[row, col] = size(arnFeatureImage);
zeroW = zeros(row, col);
for i=1:row
    for j=1:col
        zeroW(i,j) = xor(arnWaterm(i,j),arnFeatureImage(i,j));
    end
end
zeroWatermark = zeroW;
end

