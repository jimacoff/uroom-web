<?php
$hostname="localhost"; //local server name default localhost
$username="roomslvm_site";  //mysql username default is root.
$password="LCz-u42-XUt-Kzp";       //blank if no password is set for mysql.
$database="roomslvm_signups";  //database name which you created
$con=mysql_connect($hostname,$username,$password);
if(! $con) {
  die('Connection Failed'.mysql_error());
  echo "Failed";
}

mysql_select_db($database,$con);
?>
