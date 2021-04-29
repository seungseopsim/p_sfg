 function setDateBox1() {
	const url = new URLSearchParams(location.search);
	const year1 = url.get('month').split('-');
    var dt = new Date();
	var year_1 = year1[0];
	var year_2 = "";
    var com_year = dt.getFullYear();

	   
    for (var y = (com_year); y >= (com_year-3); y--) {
      $("#year_1_select").append("<option value='" + y + "'>" + y + " 년" + "</option>");
    }
	  
	  $("#year_1_select").val(year_1).prop("selected",true);

  };


 function setDateBoxDouble() {
	const url = new URLSearchParams(location.search);
	const yearStart = url.get('start').split('-');
	const yearEnd = url.get('end').split('-');
    var dt = new Date();
	var year_1 = yearStart[0];
	var year_2 = yearEnd[0];
    var com_year = dt.getFullYear();

	   
    for (var y = (com_year); y >= (com_year-3); y--) {
      $("#year_1_select").append("<option value='" + y + "'>" + y + " 년" + "</option>");
    }
	  
	  $("#year_1_select").val(year_1).prop("selected",true);


    for (var y = (com_year); y >= (com_year -3); y--) {
      $("#year_2_select").append("<option value='" + y + "'>" + y + " 년" + "</option>");
    }
	  
	  $("#year_2_select").val(year_1).prop("selected",true);
  };
	  	  