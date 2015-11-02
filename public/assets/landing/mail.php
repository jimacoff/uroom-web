<?php
$name = $_POST['name'];
$email = $_POST['email'];
$message = $_POST['message'];
$formcontent="From: $name \nMessage: $message";
$recipient = "hello@roomieapp.io";
$subject = $_POST['subject'];
$mailheader = $email;
if(mail($recipient, $subject, $formcontent, $mailheader)) {
        header( "Location: http://roomieapp.io/index.html" );
    } else {
        echo "Could not connect to server.";
    }
?>
