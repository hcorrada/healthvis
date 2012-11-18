#' This function writes the HTML/javascript for the publish button
#'
#' \code{writePublish} writes the HTML for the button
#'
#' @export
writePublish <- function(){

	paste('\n\t\t\t
		<script>
			function callServer(){

			      var alltext = document.documentElement.innerHTML;
//				var alltext = JSON.stringify(document.documentElement.innerHTML);
//				var alltext = "server";
//				alert(JSON.parse(JSON.stringify(alltext)));
				var client = new XMLHttpRequest();

				client.onreadystatechange = function () {
				  if (this.readyState == 4 && this.status == 200) {
					    alert(this.responseText);
				  } else if (this.readyState == 4) {
					//alert("readyState= "+this.readyState+" status= "+this.status+" statusText= "+this.statusText);
					  alert("No response from server, error code:"+this.status);
				  }
				};
				client.open("POST", "http://54.243.80.145/get_data.php", true);
//				client.open("GET", "http://remysharp.com/demo/cors.php");
//				client.setRequestHeader("X-Requested-With", "XMLHttpRequest");
//				client.setRequestHeader("Content-Type", "text/plain"); 
				client.send(alltext);
				client.send();
		}
		</script>
		<script type="text/javascript">
			function hello(){
				var answer = confirm("Really publish figure?");
				if(answer){
					callServer();
					//alert("Publish mechanism coming soon!");
				}
			}
		</script>
		<button type="button" onclick=hello()>
			Publish your figure!
		</button>')
}
