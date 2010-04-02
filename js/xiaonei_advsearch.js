// ==UserScript==
// @include http://browse.xiaonei.com/advanced.do
// Fixed the problem that Opera cant display all of the university info.
// More info - http://bbs.operachina.com/viewtopic.php?f=41&t=42923
// by vvoody <wxj.g.sh{AT}gmail.com>
// ==/UserScript==

function xxoo()
{
    /* Revise the changeCountry function, the fixed code is commented. */
    UnivTabs.prototype.changeCountry = function(cid){
			
		 	var country = null;
			var prov = null;
			var provs_inner = "";
			var countryId = parseInt(cid);	
			
			for(var i=0;i<allUnivList.length;i++){
				country = allUnivList[i];
				if(i == countryId){			
					break;
				}
			}
			
			if(country!= null){
				prov = country.provs;
				if(prov!=null&& typeof(prov) == "object"){ // Modified!
					for(var j=0;j<prov.length;j++){
						if(j==0){
							provs_inner += 			
							'<li id="p_'+parseInt(country.id)+'_'+parseInt(prov[j].id)+'" class="active"><a href="#nogo" onclick="javascript:univtabs.changeUnivs('+
							cid+','+prov[j].id+')">'+prov[j].name+'</a></li>';
							this.activeProvTab = "p_"+parseInt(country.id)+"_"+parseInt(prov[j].id);
						}else
							provs_inner += 			
								'<li id="p_'+parseInt(country.id)+'_'+parseInt(prov[j].id)+'" ><a href="#nogo" onclick="javascript:univtabs.changeUnivs('+
								cid+','+prov[j].id+')">'+prov[j].name+'</a></li>';
					}
					univtabs.changeUnivs(cid,-2);
				}else{
					univtabs.changeUnivs(cid,-1);
				}
			}else{
				alert("此地区不存在");
			}
			$("popup-province").innerHTML = provs_inner;	
    };

    /* Revise the changeUnivs function, the fixed code is commented. */
    UnivTabs.prototype.changeUnivs = function(cid,pid){		
		if(parseInt(pid)<0){
			var activeCTab = "c_"+parseInt(cid);		
			if(this.activeCountryTab != -1) setElementStyle(this.activeCountryTab,'');
			if(getEl(activeCTab))
				setElementStyle(activeCTab,'active');
			this.activeCountryTab = activeCTab;
		}		
		
		if(parseInt(pid)>0){
			var activePTab = "p_"+parseInt(cid)+"_"+parseInt(pid);
			if(this.activeProvTab != -1&&$(this.activeProvTab)) 
				setElementStyle(this.activeProvTab,'');
			if(getEl(activePTab))
				setElementStyle(activePTab,'active');
			this.activeProvTab = activePTab;
		}
		
		var country = null;
		var univs_inner = "";
		for(var i=0;i<allUnivList.length;i++){
			country = allUnivList[i];
			if(parseInt(cid)==i)
					break;
		}
		if(parseInt(pid)==-2){
			pid = '1';
		}
		
		if(country.provs !=null&&typeof(country.provs) == "object"){ // Modified!
			var prov = null;
			for(var j=0; j < country.provs.length+1;j++){
				prov = country.provs[j-1];
				if(parseInt(pid)==j){	
					break;
				}
			}
			for(var k=0; k< prov.univs.length;k++){				
				univs_inner += '<li id="u_'+parseInt(prov.univs[k].id)+'">'+makeUnivHref(prov.univs[k].id,prov.univs[k].name)+'</li>';
			}
		}else{
			var univs = country.univs;
			if(univs!=null){
				for(var l=0;l<univs.length;l++){									
					univs_inner += '<li id="'+univs[l].id+'">'+makeUnivHref(univs[l].id,univs[l].name)+'</li>';
				}
			}
		}
		
		$("popup-unis").innerHTML = univs_inner;
    };

    /* Reload the default page (universities in China). */
    univtabs.changeCountry('0');
}

/* Register our own function in Opera. */
window.addEventListener('load', xxoo, false);
