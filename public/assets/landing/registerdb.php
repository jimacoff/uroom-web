<?php
Include('connect.php');
$email = $_POST['email'];


$query = "INSERT INTO signup (email) VALUES ('$email')";
$data = mysql_query ($query)or die(mysql_error());

if($data) {
  header( "Location: http://roomieapp.io/registered.html" );
} else {
  echo "Could not connect to server.";
}
?>
