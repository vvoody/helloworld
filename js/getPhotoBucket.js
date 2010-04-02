//
var pics = new Array();
var counter = 0;
var prefix = "mediaUrl_";
var pic_element = document.getElementById( prefix + counter );
while( pic_element ) {
    pics[counter] = pic_element.value;
    ++counter;
    pic_element = document.getElmentById( prefix + counter );
}

for(i=0;i<counter;++i) {
    document.write( "<a href=" + pics[i] + ">" + pics[i] + "</a>" + "<br>");
}

/*
javascript:pics=new Array();counter=0;prefix="mediaUrl_";x=document.getElementById(prefix+counter);while(x){pics[counter]=x.value;++counter;x=document.getElementById(prefix+counter);}i=0;for(i=0;i<counter;i++){document.write("<a href='"+pics[i]+"'>"+pics[i]+"</a>"+"<br>");}
*/
