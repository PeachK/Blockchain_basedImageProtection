% º∆À„œ‡À∆–‘
function NC = nc(ImageA,ImageB)

if (size(ImageA,1) ~= size(ImageB,1)) or (size(ImageA,2) ~= size(ImageB,2))
    error('ImageA <> ImageB');
    NC = 0;
    return ;
end

[row, col] = size(ImageA);
S = 0;
K = numel(ImageA);
for i = 1:row
    for j = 1:col
        S = S + xor(ImageA(i,j),ImageB(i,j));
    end
end
NC = 1 - S/K;
return


