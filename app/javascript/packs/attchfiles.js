
document.addEventListener("DOMContentLoaded", (event) => {
	SelectFiles = function showSelectFiles(_event){
		var filelistTag = '';

		try
		{
			var selectfileElemnet = _event.target;
			if(null == selectfileElemnet){
				return;
				
			}

			var filelist = selectfileElemnet.files;
			var filesCnt = filelist.length;

			for(i = 0; i < filesCnt; i++){
				if(null == filelist[i]){
					continue;
				}
				filelistTag += "<li>"+filelist[i].name+"</li>";
			}

			
			var filelistElemnet = document.getElementById("filelist");
			if(null != filelistElemnet)
			{	
				filelistElemnet.innerHTML += filelistTag;		
			}

		}
		catch( _e )
		{
			console.log(_e);
		}
	}
	
	OpenSelect = function OpenSelect(){
		document.getElementById('reportroom_attachment').click();
	}
	
});
