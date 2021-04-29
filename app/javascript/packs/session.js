document.addEventListener("DOMContentLoaded", (event) => {
	
	history.pushState(null, null, null);

	window.addEventListener("popstate", function(){

		history.back();
	});
});

/*
window.function = function()
{
	alerobj = document.getElementById("alert-danger");

	if(alerobj)
	{
		alerobj.fadeTo(2000, 500).slideUp(500, function(){
		alerobj.slideUp(500);
		});

		console.log("alert obj");
	}
}
*/
