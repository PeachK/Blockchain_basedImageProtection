function S1 = SVD(x)
%% 块奇异值分解测试
im = double(x);
S = svd(im);
S1 = S(1,1);
end

% %% 参考程序
% size=512; 
% N=32;
% K=8; 
% D=zeros(size);
% E=0.01;
% 
% %读入原始图像
% I=imread('f:\lena.bmp');
% subplot(2,2,1);
% imshow(I);
% title('原始图像');
% I=double(I)/512;
% 
% %读入水印
% J=imread('f:\1234.bmp');
% subplot(2,2,2);
% imshow(J);
% title('水印图像');
% %对水印缩放
% J=double(imresize(J,[64,64]));
% subplot(2,2,3);
% imshow(J);
% title('缩放水印图像');
% 
% %%%%%%%%%%%%% 嵌入算法 %%%%%%%%%%%%%%%
% clear all; 
% clc;
% %%%%%% 读取水印图像 %%%%%%%%
% 
% omark=double(imread('muxiao.bmp'))/255;
% mo=size(omark,1); %以1的比例大小返回omark
% no=size(omark,2);
% %%自己的
% watermark_source =imread('c:\1234.bmp');
% subplot(2,2,2);
% imshow(watermark_source);
% title('水印图像');
% %对水印缩放
% watermark_source =double(imresize(watermark_source,[32,32]));
% subplot(2,2,3);
% imshow(watermark_source);
% title('缩放水印图像');
% 
% %步骤1  
% arnold_image= Arnold(watermark_source,10,0);%读入水印arnold变换，
% arnold_image=double(arnold_image);
% %%%%% 以下生成水印信息 %%%%%%
% mark=omark;
% alpha=30;
% rand1=randn(1,8);%返回矩阵nxm
% rand2=randn(1,8);
% %%%%%% 读取宿主图像 %%%%%%%%
% cimage=imread('lena.bmp');
% figure(1);
% subplot(2,3,1),imshow(cimage,[]),title('原始的宿主图像');
% [mc,nc]=size(cimage); 
% [m,n,p] = size(rand(2,3,4));
% m =2;
% n =3;
% p =4;
% cda0=blkproc(cimage,[8,8],'dct2'); %用'dct2'函数处理cimage，输出[8,8]%%%%%%%%%%%%%
% 
% %%自己的
% I=imread('c:\123.bmp');
% subplot(2,2,1);
% imshow(I);
% title('原始图像');
% I=double(I)/512;
% 
% %%%%%%% 嵌入水印 %%%%%%%%%
% cda1=cda0;  
% for i=1:mo 
%     for j=1:no 
%         x=(i-1)*8;y=(j-1)*8;
%         if mark(i,j)==1
%         k=rand1;
%         else
%         k=rand2; 
%         end
%     cda1(x+1,y+8)=cda0(x+1,y+8)+alpha*k(1);
%     cda1(x+2,y+7)=cda0(x+2,y+7)+alpha*k(2);
%     cda1(x+3,y+6)=cda0(x+3,y+6)+alpha*k(3);
%     cda1(x+4,y+5)=cda0(x+4,y+5)+alpha*k(4);
%     cda1(x+5,y+4)=cda0(x+5,y+4)+alpha*k(5);
%     cda1(x+6,y+3)=cda0(x+6,y+3)+alpha*k(6);
%     cda1(x+7,y+2)=cda0(x+7,y+2)+alpha*k(7);
%     cda1(x+8,y+1)=cda0(x+8,y+1)+alpha*k(8);
%     end
% end
% %%%%%% 嵌入水印后图象 %%%%%%
% wimage=blkproc(cda1,[8,8],'idct2'); 
% wimage_1=uint8(wimage);
% imwrite(wimage_1,'withmark.bmp','bmp');
% subplot(2,3,2),imshow(wimage,[]),title('嵌入水印后图象');
% %%自己的
% [LS1,BS1]=lpdec(I,'9-7');
% [LS2,BS2]=lpdec(LS1,'9-7');
% [B1, ... ,B1024]=dfbdec_1(BS2,'pkva',10)输出2的nx1
% for i=1:1024
%   [UL,SL,VL]=svd(Bi);
%   ULi=UL;VLi=VL;SLi=SL;
%   SLi=SL;
%   %将每个分块矩阵的最大奇异值 组成新的矩阵S(32x32)；
%   Q(i,j)=|S(i,j)/a|;
%   for i=1:32
%         for j=1:32
%             if mod(Q(i,j),2)==w''(i,j)
%                 then 
%                 S'(i,j) = Q(i,j)*a+a/2;
%                 if mod(Q(i,j),2)~=w''(i,j)
%                    for a=0:a/2
%                     if S'(i,j)=(Q(i,j)-1)*a+a/2;
%                     else S'(i,j)=(Q(i,j)+1)*a+a/2;
%                     end
%                    end
%                 end
%    
%     %将 组成新的矩阵S'(32x32)分块形成1024个每个分块矩阵最大奇异值标记为B'i
%     for i=1:1024
%       B'i=ULi*SLi*VLi;
%   
%       
%      BS2 = dfbrec_l([B1, ... ,B1024], 'pkva');
%      LS1 =lprec(BS2,'9-7');
%        I =lprec(LS1,'9-7');
    
                

%%%%%%%%%%%%%% 进行攻击测试 %%%%%%%%%%%
%wimage=imread('c:\123.bmp');测试的时候去掉这两行就可以了
%wimage=double(wimage);
% disp(‘1-->加入白噪声’);
% disp(‘2-->高斯低通滤波’);
% disp(‘3-->剪切图像’);
% disp(‘4-->旋转攻击’);
% disp(‘5-->直接检测’)
% begin=input(‘请选择攻击（1-5）：’)
% switch begin
% %%%%%%% 加入白噪声 %%%%%%%%
%     case 1
% Aimage1=wimage;
% Wnoise=20*randn(size(Aimage1));% randn(size(A)) returns an array the same size as A.
% Aimage1=Aimage1+Wnoise;
% subplot(2,3,4),imshow(Aimage1,[]),title(‘加入白噪声后的图象’);
% att=Aimage1;
% imwrite(att,'whitenoiseimage.bmp');
% %%%%%%% 高斯低通滤波 %%%%%%%
%     case 2
% Aimage2=wimage;
% H=fspecial('gaussian',[4,4],0.5);
% Aimage2=imfilter(Aimage2,H);% imshow(I,[low high]) f you use an empty matrix ([]) for [low %high], imshow uses [min(I(:)) max(I(:))]; that is, the minimum value in I is displayed as black, and the %maximum value is displayed as white.
% subplot(2,3,4),imshow(Aimage2,[]),title(‘高斯低通滤波后的图象’);
% att=Aimage2;
% imwrite(att,'gaussianimage.bmp')
% %%%%%%%% 剪切攻击 %%%%%%%%
%     case 3
% Aimage3=wimage;
% Aimage3(1:128,1:128)=256;
% subplot(2,3,4),imshow(Aimage3,[]),title(‘剪切后的图象’);
% att=Aimage3;
% imwrite(att,'cutpartimage.bmp');
% %%%%%%%% 旋转攻击 %%%%%%%%
%     case 4
% Aimage4=wimage;
% Aimage4=imrotate(Aimage4,10,'bilinear','crop');
% Aimage_4=mat2gray(Aimage4); %I = mat2gray(A) sets the values of amin and amax to the minimum and maximum values in A.
% subplot(2,3,4),imshow(Aimage_4,[]),title(‘旋转10 度后的图象’);
% att=Aimage_4;
% imwrite(att,'rotatedimage.bmp');
% %%%%%%% 没有受到攻击 %%%%%%%
%     case 5
% subplot(2,3,4),imshow(wimage,[]),title(‘直接提取的图像’);
% att=wimage;
% imwrite(att,'directimage.bmp');
% end
% %%%%%%%%%%%%% 提取水印 %%%%%%%%%%%%%%
% tmark_0=att;
% tmark_0=blkproc(tmark_0,[8,8],'dct2');
% pass=zeros(1,8);
% for i=1:mo
%     for j=1:no
%         x=(i-1)*8;y=(j-1)*8;
%         pass(1)=tmark_0(x+1,y+8);
%         pass(2)=tmark_0(x+2,y+7);
%         pass(3)=tmark_0(x+3,y+6);
%         pass(4)=tmark_0(x+4,y+5);
%         pass(5)=tmark_0(x+5,y+4);
%         pass(6)=tmark_0(x+6,y+3);
%         pass(7)=tmark_0(x+7,y+2);
%         pass(8)=tmark_0(x+8,y+1);
%         if (corr2(pass,rand1)>corr2(pass,rand2))
%              tmark_1(i,j)=1;
%         else
%              tmark_1(i,j)=0;
%         end
%     end
% end
% %%%%%%%%%% 计算NC（归一化相关系数）%%%%%%%%
% g_mark=double(tmark_1);
% o_mark=double(omark);
% [m,n]=size(g_mark);
% nc_0=0;
% nc_1=0;
% nc_2=0;
% for i=1:m
%     for j=1:n
%         nc_0=nc_0+g_mark(i,j)*o_mark(i,j);
%         nc_1=nc_1+o_mark(i,j)*o_mark(i,j);
%         nc_2=nc_2+g_mark(i,j)*g_mark(i,j);
%     end
% end
% NC=nc_0/sqrt(nc_1*nc_2);
% %%%%%% 显示提取水印 %%%%%%%%
% subplot(2,3,5),imshow('muxiao.bmp'),title(‘原始水印图像’);
% subplot(2,3,6),imshow(tmark_1,[]);
% name=‘提取得水印图像’;
% title(strcat(num2str(name),'NC=',num2str(NC)));
% %%%%%%%%%%峰值信噪比(PSNR)%%%%%%%%
% 在噪声攻击中，衡量水印性能的一个重要参数就是signal-to-nosieratio，即：信噪比SNR。下面在MATLAB的运行环境下，给出计算SNR的实用程序。
% 输入：M原始图像
% N修改后的图像
% 输出：Sn信噪比
% ********************
% function Sn=SNR(M,N)
% if(size(M)～=size(N))
% error('错误：两个输入图像大小不一致！')
% end
% if(isrgb(M))
% aux=RGBtoYIQ(M);
% A=double(aux(:,:,1));
% size(A);
% aux=RGBtoYIQ(N);
% B=double(aux(:,:,1));
% else
% A=double(M);
% B=double(N);
% [m,n]=size(A);
% sumaI=0;
% sumaDif=0;
% for u=1:m
% for v=1:n
% sumaI=sumI+A(u,v)^2;
% sumaDif=sumaDif+(A(u,v)-
% B(u,v))^2;
% end
% end
% if(sumaDif==0)
% sumaDif=1;
% end
% Sn=sumaI/sumaDif;
% Sn=10*log10(Sn);