function showSheet(title,cancelButtonTitle,destructiveButtonTitle,otherButtonTitle) {
    var url='kcactionsheet://?';
    var paramas=title+'&'+cancelButtonTitle+'&'+destructiveButtonTitle;
    if(otherButtonTitle){
        paramas+='&'+otherButtonTitle;
    }
    window.location.href=url+ encodeURIComponent(paramas);
}


var checkbox = document.getElementById('SP1');
checkbox.onclick = function(){
    check();
}


function check(){
    var checkbox = document.getElementById('SP1');
//    alert(checkbox.checked);//是否被选中
    if(checkbox.checked){
        //选中了
        showSheet('系统提示','取消','确定','按钮1勾选');
    }
    
}

var checkbox2 = document.getElementById('SP2');
checkbox2.onclick = function(){
    check2();
}


function check2(){
    var checkbox = document.getElementById('SP2');
    //    alert(checkbox.checked);//是否被选中
    if(checkbox.checked){
        //选中了
        showSheet('系统提示','取消','确定','按钮2勾选');
    }
    
}

var checkbox3 = document.getElementById('SP3');
checkbox3.onclick = function(){
    check3();
}


function check3(){
    var checkbox = document.getElementById('SP3');
    //    alert(checkbox.checked);//是否被选中
    if(checkbox.checked){
        //选中了
        showSheet('系统提示','取消','确定','按钮3勾选');
    }
    
}