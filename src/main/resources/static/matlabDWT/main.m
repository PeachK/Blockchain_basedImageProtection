function result = main()
    a=1;
    b=2;
    n=3;
    rawImage='D:\IdealProject\ImageUp-ipfs-eth\src\main\resources\static\matlabDWT\lena512.bmp';
    watermarkImage='D:\IdealProject\ImageUp-ipfs-eth\src\main\resources\static\matlabDWT\waterm16.jpg';
    zeroPathName='D:\IdealProject\ImageUp-ipfs-eth\src\main\resources\static\zeroImage\zeroWatermark01.jpg';
    generate(rawImage,watermarkImage,a,b,n,zeroPathName);
    disp("generate success");
    result=verify(rawImage,watermarkImage,zeroPathName,a,b,n);
%    if result==1
%        disp("认证成功");
%    elseif result==0
%        disp("认证失败");
%    end
end