var headerPhoto;
var logo;

$(document).ready(function()
{
	var topic = window.location.pathname.substring(1);

	headerPhoto = $("content#photo");
	logo = $("content.logo");

	var scrollPosition = 0;

	if(topic == ""){
		topic = "Home";
	}

	$("a[href^='http://'].external").attr("target","_blank");

	$(document).on('keydown', 'input#query', function(e) {
	    if(e.which == 13) {
	    	window.location = "http://wiki.xxiivv.com/"+$("input#query").val();
	        return false;
	    }
	});

	window.requestAnimationFrame(resizeThirds);
	window.requestAnimationFrame(scrollHeader);

	resizeThirds();
	
	apiContact(topic);
});

$(window).resize(function()
{
	window.requestAnimationFrame(resizeThirds);
});

$(window).load(function()
{
	window.requestAnimationFrame(scrollHeader);
});

$(window).scroll(function ()
{
	window.requestAnimationFrame(scrollHeader);
});

function apiContact(topic)
{
	$.ajax({ type: "POST", url: "http://api.xxiivv.com/xxiivv/analytics", data: { values:"{\"term\":\""+topic+"\",\"value\":\"1\"}" }
	}).done(function( content_raw ) {
		console.log(content_raw);
	});
}

function scrollHeader()
{
	if( $(window).height() > $(window).width() ){ return; }
	scrollPosition = $("body").scrollTop();
	headerHeight = $(window).height();
	percentHeaderScrolled = scrollPosition/headerHeight;
	positionPercentage = 50 + (scrollPosition*0.4)/10;
	headerPhoto.css("background-position-y", Math.floor(positionPercentage)+"%").css("opacity", 1-(percentHeaderScrolled*1) );
}

// Mobile LOD
function resizeThirds()
{
	scrollPosition = $("body").scrollTop();
	if($("html").width() < 1100){
		$("html").addClass("mobile");
	}
	else{
		$("html").removeClass("mobile");
	}
}

