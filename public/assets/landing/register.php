<?php
$email = $_POST['email'];
$formcontent="";
$recipient = "roomiesignups@gmail.com";
$subject = "Forte User Registered!";
$mailheader = $email;
if(mail($recipient, $subject, $formcontent, $mailheader)) {
        header( "Location: http://roomieapp.io/registered.html" );
    } else {
        echo "Could not connect to server.";
    }
?>
