<?php
if ( is_file('/etc/sysconfig/gridengine')){
  $CONF_FILE='/etc/sysconfig/gridengine';
}elseif ( is_file('/etc/sysconfig/gridengine-8.1.9')){
  $CONF_FILE='/etc/sysconfig/gridengine-8.1.9';
}
$file_handle = fopen($CONF_FILE, "r")  or die("SGECUDA_MISSING_FILE=".$CONF_FILE); 
while (!feof($file_handle)) {
  $line = trim(fgets($file_handle));
  if (substr($line,0,1)=='#'){ //忽略#开头的行
    continue;
  }
  $tmpstr=substr($line,0,strpos($line,'='));
  switch ( $tmpstr)
  {
    case 'SGE_ROOT':
      $SGE_ROOT=(substr($line,(strpos($line,'=')+1),strlen($line)));
      break;
  }
}
fclose($file_handle);
// hname is hosname |  sid is sge job id |setid=0释放device_id
//$hname=gethostbyaddr($_SERVER['REMOTE_ADDR']);
if ( isset($_GET["hname"] )){
  $hname=$_GET["hname"];
}else{
  $hname=gethostbyaddr($_SERVER['REMOTE_ADDR']);
}
$NSLOTS=(int)($_GET["NSLOTS"]);

$sid=$_GET["sid"]; 
$setid=$_GET["setid"]; 

if ( is_file('/usr/bin/qstat-ge')){
  $QSTAT_CMD='/usr/bin/qstat-ge';
}elseif ( is_file('/opt/sge/bin/lx-amd64/qstat')){
  $QSTAT_CMD='/opt/sge/bin/lx-amd64/qstat';
}
// The command is : qstat -j 453 |grep ^hard\ resource_list:|awk '{print $3}'|sed 's/.\{0,\}ngpus=\([0-9]\{1,\}\).\{0,\}/\\1/g'
$SGE_CMD=$QSTAT_CMD." -j  $sid |grep ^hard\ resource_list:|awk '{print $3}'|sed 's/.\{0,\}ngpus=\([0-9]\{1,\}\).\{0,\}/\\1/g' ";

$tmpstr=exec(" SGE_ROOT=$SGE_ROOT $SGE_CMD ");
if ( $tmpstr >= 1){
  $ngpus=$tmpstr * $NSLOTS ;
}else{
  die("SGECUDA_NOt_GPU_JOB=1");
}
$mysqli = new mysqli("localhost","sgecuda","","sgecuda");
$mysqli->query("LOCK TABLES cuda_list write;");
if (  $setid  ){
  $SQL_SHOW="SELECT id,hostname,device_id FROM cuda_list      WHERE isInuse=false AND  hostname='$hname' LIMIT $ngpus ;\n";
  $SQL_SET="UPDATE cuda_list SET isInuse=true,sge_job_id=$sid WHERE isInuse=false AND  hostname='$hname' LIMIT $ngpus ;\n";
  $result = $mysqli->query($SQL_SHOW);
  $device_id_list='';
  while($row = $result->fetch_assoc()){
    $device_id_list=$row['device_id'].",".$device_id_list;
   }
  if (substr($device_id_list,strlen($device_id_list)-1,1)==',') 
    $device_id_list=substr($device_id_list,0,strlen($device_id_list)-1);
  echo 'CUDA_VISIBLE_DEVICES='.$device_id_list."\n";
  $result = $mysqli->query($SQL_SET);
}else { //数据库中释放对应sge_job_id的CUDA_VISIBLE_DEVICES
    $SQL_SET="UPDATE cuda_list SET isInuse=false,sge_job_id=0 WHERE isInuse=true AND sge_job_id='$sid';";
    $mysqli->query($SQL_SET);
    echo "CUDA_VISIBLE_DEVICES is free now\n";
}
$mysqli->query("UNLOCK TABLES;");
?>
