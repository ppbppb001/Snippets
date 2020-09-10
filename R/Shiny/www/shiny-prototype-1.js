window.addEventListener("beforeunload", (event) => {
	// Cancel the event as stated by the standard.
    event.preventDefault();
    // Chrome requires returnValue to be set.
    event.returnValue = "Hello!";
});
      
/* 
window.onbeforeunload = function() {
return "You will lost your work if you leave/refresh this page.";
};
*/
      
/* Disable F5 key */
function maskF5(e) { 
	if ((e.which || e.keyCode) == 116) {
		alert("F5 key is masked to prevent reloading the page.")
        e.preventDefault()
	} 
};
$(document).on("keydown", maskF5);
