function zeroWatermark = watermark(x)
%% ˮӡ���ɣ�x:�������ֵ����
[row, col] = size(x);
for i = 1:row
    for j = 1:col
        if mod(highBit(x(i,j)),2) == 0            
            x(i,j) = 1;% �������ֵ�����λ����Ϊż������1������0.
        else
            x(i,j) = 0;
        end
    end
end
zeroWatermark = x;
end