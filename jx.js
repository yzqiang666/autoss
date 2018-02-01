alert('1111111');
var jx_str0=["+|iqiyi|youku|https://jiexi.071811.cc/jx.php?url=",
        "+|youku|http://jx.vgoodapi.com/jx.php?url=",
        "-|iqiyi|http://www.wmxz.wang/video.php?url=",
	"-|youku|http://aikan-tv.com/?url=",
        "-|http://jx.vgoodapi.com/jx.php?url="]; 



var s=window.location.href;
var index=s.indexOf('?');
var url='http://v.youku.com/v_show/id_XMzM0MTU4ODQ5Mg==.html?spm=a2h03.8164468.2069780.8';
if (index>0) url=s.substring(index+1);


var jx_str0=["+|iqiyi|youku|https://jiexi.071811.cc/jx.php?url=",
             "+|youku|http://jx.vgoodapi.com/jx.php?url=",
             "-|iqiyi|http://www.wmxz.wang/video.php?url=",
			 "-|youku|http://aikan-tv.com/?url=",
			 "-|http://jx.vgoodapi.com/jx.php?url="]; 
			 
var j=-1;
var jx_str = new Array();
var s='';
var cc=0;
for (i=0;i<jx_str0.length;i++)  {

  var ss = jx_str0[i].split('|');
  var found = false;

  for (j=1;j<ss.length-1;j++) {
    var temp='.'+ss[j]+'.';
	if (url.indexOf(temp)>=0) { found = true; break;  }
  }

  if (ss[0] == '-') found = ! found; 

  if (found) {
     if (cc==0) changeurl(ss[ss.length-1],null);
     cc++;
     if (s.indexOf(ss[ss.length-1])<0)  s = s + '<button  onclick="changeurl(\'' +  ss[ss.length-1]+'\',this);">' + cc+ '线</button>';
  }  


}
document.getElementById('tongdao').innerHTML = s;
alert('2222222222222222');
