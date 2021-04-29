
ContentLoaded = function(event) {
	
	SelectReport = function selectReport(_type){
		document.location.href = "/reportrooms/type/"+_type;
	}
	
	ShowReport = function showReport(_type){
		document.location.href = "/reportrooms/"+_type;
	}
	
	Vaildform = function vaildform(_event){

		selectobj =	document.getElementById('reportroom_type');
		contentobj = document.getElementById('reportroom_contents');
		plancontensobj = document.getElementById('reportroom_plancontents');
		
		if( selectobj.selectedIndex == 0)
		{
			swal("신의 눈", "보고 방을 선택해주세요.");
			// alert("보고 방을 선택해주세요.");
			return false;
		}
		
		if(contentobj.value.length < 1)
		{
			swal("신의 눈", "내용을 입력해주세요.");
			return false;
		}

		return true;
	}
		
	// textarea key event
	TextareaKeydown = function (event){
		var keycode = event.keyCode;
		
		// 탭 키
		if(keycode == 9){
			event.preventDefault();
		    
			textareaobj = document.getElementById(event.target.id);
			if( null == textareaobj){
				return;
			}           
			
			var valueStart = textareaobj.selectionStart;
			textareaobj.value = textareaobj.value.substring(0, textareaobj.selectionStart) + "\t" + textareaobj.value.substring(textareaobj.selectionEnd);
            textareaobj.selectionEnd = valueStart+1; 	
		}
		// 엔터 키
		else if(keycode == 13){
			event.stopPropagation();
			
		}
	}
	
	
	setTimeout(function() {
		alertobj = document.getElementById("alertmsg");
		if(alertobj)
		{
			alertobj.style.display = "none";
		}
	}, 3000);

	// 글 읽기 표시 처리
	{
		buttons = document.getElementsByClassName("btn collapsed");
		roomtypeobj = document.getElementById("roomtype");
		//console.log(buttons);
		if(null == roomtypeobj)
		{
			return;
		}

	 	roomtype = roomtypeobj.dataset.type;
		if(null == roomtype)
		{
			return;
		}

		if(null != buttons)
		{
			for(idx = 0; idx < buttons.length; ++idx)
			{
/*
				targetid = buttons[idx].dataset.target;
				
				frame  = document.getElementById(targetid.replace("#", ""));
				if(null != frame)
				{
					try
					{
						frame.addEventListener('click', function() {
							alert("ASDFAS");
						});

					}
					catch(error)
					{
						console.error(error);
					}
						
				}
*/			
				$(buttons[idx].dataset.target).on('shown.bs.collapse', function(_event) {
					//document.location.href =  "/reportrooms/${buttons[idx].dataset.target.replace('#accordion')}";
					obj = _event['target'];
					if(null != obj)
					{
						targetid = obj.id;
						if( null != targetid)
						{
							id = targetid.replace('accordion', "");
							path = "/reportrooms/read";
							param = `type=${roomtype}&id=${id}`;
							//document.location.href = path;
							httpRequest = new XMLHttpRequest();
							if(null == httpRequest)
							{
								//alert("nil");
								return;
							}
							httpRequest.onreadystatechange = function(){
								if(this.readyState == this.DONE)
								{
									//console.log(this.status);
									if(this.status != 200)
									{
											return
									}
									//console.log(this.responseText);
									
									try
								{
									jobj = JSON.parse(this.responseText);
										// font = document.getElementById(`font${jobj.id}`);
										bg = document.querySelector(`.bg${jobj.id}`);
										if(null != bg)
										{
											// console.log(bg);
											// font.style.color = "blue";
											bg.style.backgroundColor ="white";
										}
									}
									catch(ex)
									{
										console.log(ex);
									}
								}
							}
							
							httpRequest.open('POST', path);
							httpRequest.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
							httpRequest.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
							httpRequest.send(param);
						}	
					}
				});
			}	
		}
	}
}

window.addEventListener("DOMContentLoaded", ContentLoaded);


/*
window.addEventListener("load", function(){
	alert("asdf232523asdf");
});
*/
