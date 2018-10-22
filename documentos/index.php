<?php

/*
 * jQuery File Upload Plugin PHP Example
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */

//error_reporting(E_ALL | E_STRICT);
//require('../class/UploadHandler.php');

/*
extract($_POST);
$ref = explode("/", $publ_ref);
$mes = $ref[0];
$ano = $ref[1];
$fs = "/";
$path = "./".$publ_cli.$fs.$publ_dep.$fs.$ano.$fs.$mes;
if(!file_exists($path)){
	if(!mkdir($path, 0777, true))
		echo "FAILED<br>";
}
$options = array('upload_dir'=>$path.'/', 'upload_url'=>$path.'/');
*/
//$upload_handler = new UploadHandler();
header("location:../view/403.php?token=".$_SESSION['token']);