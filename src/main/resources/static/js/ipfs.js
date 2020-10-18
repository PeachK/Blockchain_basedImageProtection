//go to inquiry html
function inquiry(){
    $("#home").attr('class',"nav-link");
    $("#inquiry").attr('class',"nav-link active");
    $("#main11").html('<h1 class="cover-heading">查询图片</h1>\<' +
        'p class="lead">输入交易哈希值,查询图片</p><p class="lead"></p><div id="div02">\<' +
        'input type="text" name="transactionHash" id="inputIA" value="在此输入交易的hash值" onclick="clearValue(this)" />\<' +
        'input type="button" id="button-get" onclick="getImage()" value="获取图片" /><div class="imageBox">\返' +
        '回的图片：<img id="imgReturn" src="" /></div></div><p></p>');
    $("#imgReturn").bind('onerror',function(){this.style.display='none';});

    $("#inputIA").attr('class',"btn btn-lg btn-secondary");
    $("#button-get").attr('class',"btn btn-lg btn-secondary");
}

//f1   showImage1

function showImg(obj) {
    var file=$(obj)[0].files[0];    //获取文件信息
    var imgdata='';
    if(file)
    {
        var reader=new FileReader();  //调用FileReader
        reader.readAsDataURL(file); //将文件读取为 DataURL(base64)
        reader.onload=function(evt){   //读取操作完成时触发。
            $("#img").attr('src',evt.target.result)  //将img标签的src绑定为DataURL
        };
    }
    else{
        alert("上传失败");
    }
}


//ajax传图给后台，并获取到该次交易的hash值
function getTransactionHash(){
    // var file = $("#f1").files[0];
    // if(!/image\/\w+/.test(file.type)){
    //     alert("文件必须是图片");
    //     return false;
    // }
    var formData=new FormData();
    formData.append('filename',$('#f1').get(0).files[0]);
    $("#span01").text("获取中...");
    $.ajax({
        url:"/ipfsUpload",
        type:'POST',
        data:formData,
        dataType:'text',
        async:false,
        cache:false,
        contentType:false,
        processData:false,
        success:function (data,status){
            //把接收到的json格式receipt字符串转换为对象
            const ReceiptObj = JSON.parse(data);
            // console.log(data);
            //console.log(status);

            console.log(ReceiptObj);
            $("#span01").text(ReceiptObj.transactionHash);
            $("#span02").text(ReceiptObj.blockNumber);
            $("#span03").text(ReceiptObj.blockHash);
            $("#span04").text(ReceiptObj.gasUsed);

            $("#p5").html("<a href='' id='etherscan' target='_blank' >查看交易详情</a>");
            $("#etherscan").attr("href","https://rinkeby.etherscan.io/tx/"+ReceiptObj.transactionHash);


        },
        error:function(data){
            console.log(data);
            $("#span01").text("上传失败:"+data);
        }
    });

}
//ajax传一个ipfs地址给后台
//ajax传txH
function getImage(){
    $.ajax({
        url:"/ipfsShow",
        type:'POST',
        dataType:"text",
        data:{"transactionHash":$("#inputIA").val()},
        success:function (img,status){
            console.log(img);
            console.log(status);
            $("#imgReturn").attr('src',"data:image/png;base64,"+img);
        },
        error:function(data){
            console.log("接收失败"+data);
        }
    })
}
function clearValue(t1){
    $("#inputIA").one("click",function(){
        t1.value="";//绑定的事件只触发一次
    });
}