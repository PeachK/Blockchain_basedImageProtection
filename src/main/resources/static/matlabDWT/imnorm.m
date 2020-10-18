function [normim, normtform, xdata, ydata] = imnorm(im, M, N)
% 图像归一化的实现:
% 参考：P. Dong, J.G. Brankov, N.P. Galatsanos, Y. Yang, and F. Davoine,
%      "Digital Watermarking Robust to Geometric Distortions," IEEE Trans.
%      Image Processing, Vol. 14, No. 12, pp. 2140-2150, 2005.
% 输入:
%   im: 灰度图像
% 输出:
%   normim: double类的归一化图像
%   normtform: 标准化的形式
%   xdata, ydata: 归一化图像的空间坐标（归一化空间坐标系，坐标原点在图像中心，x轴水平向右，y轴水平向上，归一化因子为x轴的一半，所以对于m*m大小的图像，xy轴的坐标范围为[-1,1]。）
if ~isa(im, 'double')
  im = double(im);
end

% 归一化步骤：
% 1.平移不变性:将坐标平移到图像质心（形心）
[cx, cy] = imcentroid(im);
tmat = [1 0 0; 0 1 0; -cx -cy 1];    %变换矩阵
mat = tmat;
tform = maketform('affine', mat);
[imt, xdata, ydata] = imtransform(im, tform, 'XYScale', 1);
%showim(imt, 'Translation', xdata, ydata);

% 2. X方向剪切不变性
[cx,cy] = imcentroid(imt);
u03 = immoment(imt, 0, 3, cx, cy);
u12 = immoment(imt, 1, 2, cx, cy);
u21 = immoment(imt, 2, 1, cx, cy);
u30 = immoment(imt, 3, 0, cx, cy);
rts = sort(roots([u03, 3*u12, 3*u21, u30]));
if isreal(rts)   %所有的根都是实数:选择中位数
  beta = rts(2);
else  % Choose the real one
  for i = 1:3
    if isreal(rts(i))
      beta = rts(i);
      break
    end
  end
end
xmat = [1 0 0; beta 1 0; 0 0 1];    % X-shearing matrix
mat = mat*xmat;
tform = maketform('affine', mat);
[imtx xdata ydata] = imtransform(im, tform, 'XYScale', 1);
%showim(imtx, 'Xshearing', xdata, ydata);

% 3.Y方向剪切不变性
[cx,cy] = imcentroid(imtx);
u11 = immoment(imtx, 1, 1, cx, cy);
u20 = immoment(imtx, 2, 0, cx, cy);
gamma = -u11/(u20+eps);
ymat = [1 gamma 0; 0 1 0; 0 0 1];    % Y-shearing matrix
mat = mat*ymat;
tform = maketform('affine', mat);
[imtxy, xdata, ydata] = imtransform(im, tform, 'XYScale', 1);
%showim(imtxy, 'Yshearing', xdata, ydata);

% 4. 各向异性缩放不变性
% 将图像的支持区域缩放到固定大小[512 512]
[r,c] = find(imtxy);
alpha = N/(max(c)-min(c)+1);
delta = M/(max(r)-min(r)+1);
smat = [alpha 0 0; 0 delta 0; 0 0 1];    % Scaling matrix
% Ensure u50>0 and u05>0
tmpmat = mat*smat;
tform = maketform('affine', tmpmat);
[imtxys, xdata, ydata] = imtransform(im, tform, 'XYScale', 1);
[cx, cy] = imcentroid(imtxys);
if immoment(imtxys, 5, 0, cx, cy) < 0
  alpha = -alpha;
end
if immoment(imtxys, 0, 5, cx, cy) < 0
  delta = -delta;
end
smat = [alpha 0 0; 0 delta 0; 0 0 1];    % Scaling matrix
mat = mat*smat;
tform = maketform('affine', mat);
[imtxys, xdata, ydata] = imtransform(im, tform, 'XYScale', 1);
%showim(imtxys, 'Scaling', xdata, ydata);

% 执行整体转换
normtform = maketform('affine', mat);
[normim, xdata, ydata] = imtransform(im, normtform, 'XYScale', 1);
% Remove black borders
[row,col] = find(round(normim));
minr = min(row);
maxr = max(row);
minc = min(col);
maxc = max(col);
%disp([maxr-minr+1,maxc-minc+1]);
if maxr-minr+1>M
    d=maxr-minr+1-M;
    if mod(d,2)==0
        maxr=maxr-d/2;
        minr=minr+d/2;
    else
        if sum(row==minr)>sum(row==maxr)
            maxr=maxr-(d-1)/2-1;
            minr=minr+(d-1)/2;
        else
            minr=minr+(d-1)/2+1;
            maxr=maxr-(d-1)/2;
        end
    end    
end
if maxc-minc+1>N
    d=maxc-minc+1-N;
    if mod(d,2)==0
        maxc=maxc-d/2;
        minc=minc+d/2;
    else
        if sum(col==minc)>sum(col==maxc)
            maxc=maxc-(d-1)/2-1;
            minc=minc+(d-1)/2;
        else
            minc=minc+(d-1)/2+1;
            maxc=maxc-(d-1)/2;
        end
    end    
end
%%%第一种策略
% if maxr-minr+1<M
%     d=M-(maxr-minr+1);
%     if mod(d,2)==0
%         maxr=maxr+d/2;
%         minr=minr-d/2;
%     else
%         if sum(row==minr)>sum(row==maxr)
%             maxr=maxr+(d-1)/2+1;
%             minr=minr-(d-1)/2;
%         else
%             minr=minr-(d-1)/2-1;
%             maxr=maxr+(d-1)/2;
%         end
%     end    
% end
% if maxc-minc+1<N
%     d=N-(maxc-minc+1);
%     if mod(d,2)==0
%         maxc=maxc+d/2;
%         minc=minc-d/2;
%     else
%         if sum(col==minc)>sum(col==maxc)
%             maxc=maxc+(d-1)/2+1;
%             minc=minc-(d-1)/2;
%         else
%             minc=minc-(d-1)/2-1;
%             maxc=maxc+(d-1)/2;
%         end
%     end    
% end
% if minr<1    
%     maxr=maxr+1-minr;
%     minr=1;
% end
% if minc<1    
%     maxc=maxc+1-minc;
%     minc=1;
% end

normim = normim(minr:maxr, minc:maxc);

%%%第二种策略
if maxr-minr+1~=M||maxc-minc+1~=N
    normim= imresize(normim,[M N], 'bicubic');
end

xdata(1) = xdata(1)+minc-1;
xdata(2) = maxc-minc+xdata(1);
ydata(1) = ydata(1)+minr-1;
ydata(2) = maxr-minr+ydata(1);
%showim(normim, 'Normalized', xdata, ydata);

function [cx, cy] = imcentroid(im)
% 计算图像形心
m00 = immoment(im, 0, 0);
cx = immoment(im, 1, 0)/(m00+eps);
cy = immoment(im, 0, 1)/(m00+eps);


function m = immoment(im, p, q, cx, cy)
% 计算图像矩
[y,x,v] = find(im);
if nargin == 5
  x = x - cx;
  y = y - cy;
end
if p==0 && q==0
  m = sum(v);
elseif p==0 && q==1
  m = sum(y .* v);
elseif p==1 && q==0
  m = sum(x .* v);
elseif p==1 && q==1
  m = sum(x .* y .* v);
else
  m = sum(x.^p .* y.^q .* v);
end

function showim(im, name, xdata, ydata)
figure('Name', name), imshow(uint8(im), 'XData', xdata, 'YData', ydata);
impixelinfo, axis on, axis([xdata ydata]);



