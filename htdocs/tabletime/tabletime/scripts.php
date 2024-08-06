<?php
require_once('Connections/conx.php');

 function validateEmail($email) {
	return filter_var($email, FILTER_VALIDATE_EMAIL);
 }

 function validatePassword($password){
	$state = true; $passwordErr = '';
	 if(!empty($password) && isset( $password )) {
		$state = true;
		if(!preg_match("#[0-9]+#",$password)) {
			$passwordErr = "Your Password Must Contain At Least 1 Number!";
			$state = false;
		}
		elseif(!preg_match("#[A-Z]+#",$password)) {
			$passwordErr = "Your Password Must Contain At Least 1 Capital Letter!";
			$state = false;
		}
		elseif(!preg_match("#[a-z]+#",$password)) {
			$passwordErr = "Your Password Must Contain At Least 1 Lowercase Letter!";
			$state = false;
		}
		elseif(!preg_match("#[\W]+#",$password)) {
			$passwordErr = "Your Password Must Contain At Least 1 Special Character!";
			$state = false;
		} 
	} else {
		$passwordErr = "Please enter password   ";
		$state = false;
	}
	 $passvalid = array("valid"=>$state, "msg"=>$passwordErr);
	return $passvalid;
}



$act = '';
if(isset($_POST['act'])) $act = $_POST['act'];

$ImgPath = 'http://'.$_SERVER['HTTP_HOST'].'/tabletime/restimgs/';

// when register
if($act == "register"):
	$username = $_POST['username'];
	$password = $_POST['password'];
	$fullname = $_POST['fullname'];
	$mobile = $_POST['mobile'];
	$email = $_POST['email'];
    $groupkey = ["SingingCharacter.select"=>1, "SingingCharacter.owner"=>2, "SingingCharacter.user"=>3];
	$roleid = $groupkey[$_POST['roleid']];

	if($username =="" ):
		$Ary = array("status"=>"error", "msg"=>"Username required");
		$res = array("response"=>$Ary);
		die(json_encode($res, JSON_UNESCAPED_UNICODE));
	endif;

	$passchk = validatePassword($password);

	if(!$passchk['valid']):
		$Ary = array("status"=>"error", "msg"=>$passchk['msg']);
		$res = array("response"=>$Ary);
		die(json_encode($res, JSON_UNESCAPED_UNICODE));
	endif;

	if($fullname =="" ):
		$Ary = array("status"=>"error", "msg"=>"Full name required");
		$res = array("response"=>$Ary);
		die(json_encode($res, JSON_UNESCAPED_UNICODE));
	endif;

	if($mobile=="" ):
		$Ary = array("status"=>"error", "msg"=>"Mobile required");
		$res = array("response"=>$Ary);
		die(json_encode($res, JSON_UNESCAPED_UNICODE));
    else:
        if(strlen($mobile) != 10):
            $Ary = array("status"=>"error", "msg"=>"Mobile number must be 10 digits");
            $res = array("response"=>$Ary);
            die(json_encode($res, JSON_UNESCAPED_UNICODE));
        else:
            if(!is_numeric($mobile)):
                $Ary = array("status"=>"error", "msg"=>"Mobile number must be numbers only");
                $res = array("response"=>$Ary);
                die(json_encode($res, JSON_UNESCAPED_UNICODE));
            endif;
        endif;
	endif;

	if($email =="" ):
		$Ary = array("status"=>"error", "msg"=>"Email required");
		$res = array("response"=>$Ary);
		die(json_encode($res, JSON_UNESCAPED_UNICODE));
    else:
        if(!validateEmail($email)):
            $Ary = array("status"=>"error", "msg"=>"Valid Email is required");
            $res = array("response"=>$Ary);
            die(json_encode($res, JSON_UNESCAPED_UNICODE));
        endif;
	endif;

    mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."users WHERE username = '$username'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$UsrAry = array();
	while($rw = mysqli_fetch_object($rso)) array_push($UsrAry, $rw);
	
	if(count($UsrAry) > 0):
		$Ary = array("status"=>"error", "msg"=>"Username already exists!");
		$res = array("response"=>$Ary);
		die(json_encode($res, JSON_UNESCAPED_UNICODE));
	endif;

	mysqli_select_db($conx, $database_conx);
	$qry = "INSERT INTO ".$dbprefix."users ( roleid, username, password, fullname, mobile, email) 
			VALUES ('$roleid', '$username','$password','$fullname','$mobile', '$email')";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	
	$Ary = array("status"=>"done", "msg"=>"Account Created");
	$res = array("response"=>$Ary);

	echo json_encode($res, JSON_UNESCAPED_UNICODE);
endif;

if($act == "login"):
	$username = $_POST['username'];
	$password = $_POST['password'];
    
	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."users WHERE username='".$username."' AND password='".$password."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$UserAry = array();
	while($rw = mysqli_fetch_object($rso)) array_push($UserAry, $rw);

	$row = array("status"=>"no", "userid"=>"0", "msg"=>"Faild! Invalid username/password", "roleid"=>0);
	foreach($UserAry as $User):
		$userid = $User->userid;
		$grpid = $User->roleid;
	endforeach;


	$rows = $UserAry;
	if(count($UserAry) > 0)
		$row = array("status"=>"done", "userid"=>$userid, "roleid"=>$grpid,  "rows"=>$rows, "msg"=>"Successful logged in");

	$res = array("response"=>$row);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);
endif;



// forget password section
if($act == "forgetpass"):
	$email = urldecode($_POST['email']);
	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."users WHERE email='".$email."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$found = mysqli_num_rows($rso);
	if($found > 0){
		$Rows = array();
		while($rw = mysqli_fetch_object($rso)) array_push($Rows, $rw);
		foreach($Rows as $Row):
			$email = $Row->email;
			$username = $Row->username;
			$password = $Row->password;
		endforeach;
		if(mail($email, "Your password from app","Username: ".$username."
Password: ".$password)){
			$ary = array("response"=>array("status"=>"yes", "msg"=>"Your password sent to your inbox"));
		}else{
			$ary = array("response"=>array("status"=>"no", "msg"=>"Mail not sent!!".$email));
		}
	}else{
		$ary = array("response"=>array("status"=>"no", "msg"=>"This email does not exists in our system!"));
	}
	echo json_encode($ary);
endif;

if($act == "getUserById"):
	$userid = $_POST['userid'];

	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."users WHERE userid='".$userid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$UserAry = array();
	while($rw = mysqli_fetch_object($rso)) array_push($UserAry, $rw);

	$rows = [$UserAry];	
	
	if(count($UserAry) > 0) 
        $row = array("status"=>"done", "msg"=>"user data loaded", "rows"=>$rows);

	$res = array("response"=>$row);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);
endif;


if($act == "updateprofile"):
	$username = $_POST['username'];
	$password = $_POST['password'];
	$fullname = $_POST['fullname'];
	$email = $_POST['email'];
	$mobile = $_POST['mobile'];
	$userid = $_POST['userid'];

	if($username =="" ):
		$Ary = array("status"=>"error", "msg"=>"Username required");
		$res = array("response"=>$Ary);
		die(json_encode($res, JSON_UNESCAPED_UNICODE));
	endif;

	if($password =="" ):
		$Ary = array("status"=>"error", "msg"=>"Password required");
		$res = array("response"=>$Ary);
		die(json_encode($res, JSON_UNESCAPED_UNICODE));
    else:
        if(strlen($password) != 8):
            $Ary = array("status"=>"error", "msg"=>"Password must be 8 digits");
            $res = array("response"=>$Ary);
            die(json_encode($res, JSON_UNESCAPED_UNICODE));
        endif;
	endif;

	if($fullname =="" ):
		$Ary = array("status"=>"error", "msg"=>"Full name required");
		$res = array("response"=>$Ary);
		die(json_encode($res, JSON_UNESCAPED_UNICODE));
	endif;

	if($mobile=="" ):
		$Ary = array("status"=>"error", "msg"=>"Mobile required");
		$res = array("response"=>$Ary);
		die(json_encode($res, JSON_UNESCAPED_UNICODE));
    else:
        if(strlen($mobile) != 10):
            $Ary = array("status"=>"error", "msg"=>"Mobile number must be 10 digits");
            $res = array("response"=>$Ary);
            die(json_encode($res, JSON_UNESCAPED_UNICODE));
        else:
            if(!is_numeric($mobile)):
                $Ary = array("status"=>"error", "msg"=>"Mobile number must be numbers only");
                $res = array("response"=>$Ary);
                die(json_encode($res, JSON_UNESCAPED_UNICODE));
            endif;
        endif;
	endif;

	if($email =="" ):
		$Ary = array("status"=>"error", "msg"=>"Email required");
		$res = array("response"=>$Ary);
		die(json_encode($res, JSON_UNESCAPED_UNICODE));
    else:
        if(!validateEmail($email)):
            $Ary = array("status"=>"error", "msg"=>"Valid Email is required");
            $res = array("response"=>$Ary);
            die(json_encode($res, JSON_UNESCAPED_UNICODE));
        endif;
	endif;

	mysqli_select_db($conx, $database_conx);
	$qry = "UPDATE ".$dbprefix."users SET
			username='$username', password='$password', fullname='$fullname', mobile='$mobile',
            email = '$email'
			WHERE userid = '$userid'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."users WHERE userid='".$userid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$UserAry = array();
	while($rw = mysqli_fetch_object($rso)) array_push($UserAry, $rw);

	$rows = [$UserAry];	

	$Ary = array("status"=>"done", "msg"=>"Profile Updated", "rows"=>$rows);
	$res = array("response"=>$Ary);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);
endif;   

if($act == "getRest"):
	$userid = $_POST['userid'];
	$roleid = $_POST['roleid'];

	// reload data
	mysqli_select_db($conx, $database_conx);
	// if owner
	$qry = "SELECT * FROM ".$dbprefix."restaurants WHERE ownerid='".$userid."'";
	// if employee
	if($roleid == "2"):
		$qry = "SELECT * FROM ".$dbprefix."restaurants_employee re
				LEFT JOIN ".$dbprefix."restaurants r ON r.restid = re.restid
				WHERE re.userid='".$userid."'";
	endif;
	// if customer
	if($roleid == "3"):
		$qry = "SELECT * FROM ".$dbprefix."".$dbprefix."restaurants";
	endif;
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$Rows = array();
	while($rw = mysqli_fetch_object($rso)) array_push($Rows, $rw);

	$rows = [$ImgPath, $Rows];

	$Ary = array("status"=>"done", "msg"=>"data loaded", "rows"=>$rows);
	$res = array("response"=>$Ary);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);	
endif;

if($act == "upload"):
    $tmp_name = $_FILES['image']['tmp_name'];
	$userid = $_POST['userid'];
    $name = $_POST['userid'].'_'.time().'.png';
    $folder = $_POST["foldername"];
     move_uploaded_file($tmp_name, "$folder/$name");
    
	$Ary = array("status"=>"done", "action"=>"done", "msg"=>"image uploaded", "newimgname"=>$name, "folder"=>$folder);
	$res = array("response"=>$Ary);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);
endif;


if($act == "saveRest"):
	$userid = $_POST['userid'];
	$name = $_POST['restname'];
	$email = $_POST['email'];
	$phone = $_POST['phone'];
	$address = $_POST['address'];
	$restimg = $_POST['restimg'];
	

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "INSERT INTO ".$dbprefix."restaurants (ownerid, restname,  restemail, restphone, address, restpic)
			VALUES ('$userid','$name','$email','$phone','$address','$restimg')";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."restaurants WHERE ownerid='".$userid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$Rows = array();
	while($rw = mysqli_fetch_object($rso)) array_push($Rows, $rw);

	$Ary = array("status"=>"done", "msg"=>"Profile Updated", "rows"=>$Rows);
	$res = array("response"=>$Ary);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);	
endif;

if($act == "delRest"):
	$userid = $_POST['userid'];
	$restid = $_POST['restid'];

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "DELETE FROM ".$dbprefix."restaurants WHERE restid='".$restid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."restaurants WHERE ownerid='".$userid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$Rows = array();
	while($rw = mysqli_fetch_object($rso)) array_push($Rows, $rw);

	$Ary = array("status"=>"done", "msg"=>"data loaded", "rows"=>$Rows);
	$res = array("response"=>$Ary);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);	
endif;

if($act == "getTables"):
	$userid = $_POST['userid'];
	$restid = $_POST['restid'];

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."seattables  WHERE restid='".$restid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$Rows = array();
	while($rw = mysqli_fetch_object($rso)) array_push($Rows, $rw);

	$rows = [$restid, $Rows];

	$Ary = array("status"=>"done", "msg"=>"data loaded", "rows"=>$rows);
	$res = array("response"=>$Ary);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);	
endif;

if($act == "saveTable"):
	$userid = $_POST['userid'];
	$restid = $_POST['restid'];
	$nfc = $_POST['nfc'];
	$tablenum = $_POST['tablenum'];
	$chairnum = $_POST['chairnum'];

	// check data
	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."seattables WHERE tabnfc='".$nfc."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$nfcRows = array();
	while($rw = mysqli_fetch_object($rso)) array_push($nfcRows, $rw);
	if(count($nfcRows) > 0):
		$Ary = array("status"=>"error", "msg"=>"NFC already taken", "rows"=>[]);
		$res = array("response"=>$Ary);
		die(json_encode($res, JSON_UNESCAPED_UNICODE));	
	endif;

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "INSERT INTO ".$dbprefix."seattables (`restid`, `tabnfc`, `tabnum`, `tabchairs`, `tabstatus`)
			VALUES ('$restid', '$nfc', '$tablenum', '$chairnum', '0')";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	
	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."seattables WHERE restid='".$restid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$Rows = array();
	while($rw = mysqli_fetch_object($rso)) array_push($Rows, $rw);

	$rows = [$restid, $Rows];

	$Ary = array("status"=>"done", "msg"=>"data loaded", "rows"=>$rows);
	$res = array("response"=>$Ary);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);	
endif;

if($act == "delTable"):
	$userid = $_POST['userid'];
	$restid = $_POST['restid'];
	$tableid = $_POST['tableid'];

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "DELETE FROM ".$dbprefix."seattables WHERE tableid='".$tableid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."seattables WHERE restid='".$restid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$Rows = array();
	while($rw = mysqli_fetch_object($rso)) array_push($Rows, $rw);

	$rows = [$restid, $Rows];

	$Ary = array("status"=>"done", "msg"=>"data loaded", "rows"=>$rows);
	$res = array("response"=>$Ary);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);	
endif;


if($act == "setTable"):
	$userid = $_POST['userid'];
	$state = $_POST['tabstate'];
	$tableid = $_POST['tableid'];
	$restid = $_POST['restid'];

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "UPDATE ".$dbprefix."seattables SET tabstatus = '$state'
			WHERE tableid='".$tableid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."seattables WHERE restid='".$restid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$Rows = array();
	while($rw = mysqli_fetch_object($rso)) array_push($Rows, $rw);

	$rows = [$restid, $Rows];

	$Ary = array("status"=>"done", "msg"=>"data loaded", "rows"=>$rows);
	$res = array("response"=>$Ary);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);	
endif;

if($act == "reserveDetail"):
	$userid = $_POST['userid'];
	$tableid = $_POST['tableid'];
	$restid = $_POST['restid'];

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."seattables WHERE tableid='".$tableid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$Rows = array();
	while($rw = mysqli_fetch_object($rso)) array_push($Rows, $rw);

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."foods WHERE restid='".$restid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$Foods = array();
	while($rw = mysqli_fetch_object($rso)) array_push($Foods, $rw);
	
	$rows = [$Rows, $Foods];

	$Ary = array("status"=>"done", "msg"=>"data loaded", "rows"=>$rows);
	$res = array("response"=>$Ary);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);	
endif;

if($act == "reserve"):
	$userid = $_POST['userid'];
	$tableid = $_POST['tableid'];
	$foodlist = $_POST['foodlist'];
	$dateandtime = $_POST['dateandtime'];
	$prts = explode(" ", $dateandtime);
	$d = explode("-", $prts[0]);
	$t = explode(":", $prts[1]);
	$reservetime = mktime($t[0], $t[1], 0, $d[1], $d[0], $d[2]);	// unix time - google for it for more info

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "INSERT INTO ".$dbprefix."reservations (`userid`, `tableid`, `reservetime`, `foodlist`)
			VALUES ('$userid', '$tableid', '".$reservetime."', '$foodlist')";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));

	// reserve the table 
	mysqli_select_db($conx, $database_conx);
	$qry = "UPDATE ".$dbprefix."seattables SET
			tabstatus = '0'
			WHERE tableid = '$tableid'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));

	$rows = [];

	$Ary = array("status"=>"done", "msg"=>"data loaded", "rows"=>$rows);
	$res = array("response"=>$Ary);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);	
endif;
if($act == "getReserves"):
	$userid = $_POST['userid'];

	// reload data
	mysqli_select_db($conx, $database_conx);
	$qry = "SELECT * FROM ".$dbprefix."reservations r
			LEFT JOIN ".$dbprefix."seattables s ON s.tableid = r.tableid
			LEFT JOIN ".$dbprefix."restaurants rt ON rt.restid = s.restid
			WHERE r.userid='".$userid."'";
	$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
	$Rests = array();
	while($rw = mysqli_fetch_object($rso)) array_push($Rests, $rw);
	
	$rows = $Rests;

	$Ary = array("status"=>"done", "msg"=>"data loaded", "rows"=>$rows);
	$res = array("response"=>$Ary);
	echo json_encode($res, JSON_UNESCAPED_UNICODE);	
endif;
?>