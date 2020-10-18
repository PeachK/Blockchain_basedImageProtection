<!DOCTYPE html>
<head>
    <meta charset="UTF-8" />
    <title>图片上传Demo</title>
</head>
<body>
<h1 >图片上传Demo</h1>


<form action="fileUpload" method="post" enctype="multipart/form-data">
    <p>选择文件: <input type="file" name="fileName"/></p>


    <p><input type="submit" value="提交"/></p>
</form>
<#--判断是否上传文件-->
<#if msg??>
    <span>${msg}</span><br>
<#else>
    <span>${msg!("文件未上传")}</span><br>
</#if>
<#--显示图片，一定要在img中的src发请求给controller，否则直接跳转是乱码-->
<#if fileName??>
<span>要显示的文件名是：${fileName}</span><br>
<#--<script>-->
    <#--function getPath(){-->
        <#--var path=-->
    <#--}-->
<#--</script>-->
<img src="show?fileName=${fileName}"  style="width: 100px"/>
<#else>
<img src="show" style="width: 200px"/>
</#if>

<#if fileName??>
<br><span>要处理的文件名是：${fileName}</span><br>

<form action="process?fileName=${fileName}" method="post" enctype="multipart/form-data">



    <p><input type="submit" value="图片处理"/></p>
</form>
    <img src="showWater?fileName=${fileName}" style="width: 200px"/>
</#if>
</body>
</html>
