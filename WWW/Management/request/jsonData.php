<?php 
if (!isset($_GET['id'])) { die('set ID!'); }

sleep(1);

$id_string = str_replace('catid_','',$_GET['id']);
$id_string_tmp = $id_string;
$id_array = explode('-',$id_string_tmp);
$JSON_NAME 	= 'CAT '.$id_string;
$JSON_TYPE 	= 'tree';
$JSON_ID 	= $id_string;
$limit = rand(1,8);

echo '{'."\r\n";
	echo "\t".'"name"'."\t\t".':"'.$JSON_NAME.'",'."\r\n";
	echo "\t".'"type"'."\t\t".':"'.$JSON_TYPE.'",'."\r\n";
	echo "\t".'"id"'."\t\t".':"catid_'.$JSON_ID.'",'."\r\n";
	echo "\t".'"categories"'."\t".': ['."\r\n";
	for ($i = 0; $i < $limit; $i++) {
		$new_id = $i+1;
		echo "\t\t".'{ "name"'."\t".':"CAT:'.$id_string.'-'.$new_id.'",'."\r\n";
		echo "\t\t".'  "id"'."\t\t".':"catid_'.$id_string.'-'.$new_id.'"'."\t\t".'}';
		if ($new_id < $limit) { echo ','; }
		echo "\r\n";
	}
	echo "\t".']'."\r\n";
echo '}';

?>