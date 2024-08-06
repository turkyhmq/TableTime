<?php require_once('Connections/conx.php'); ?>
<?php require_once('pgaccess.php'); 

// Delete assignment
if($act == "del"):
    $recordid = $_POST['recordid'];
    mysqli_select_db($conx, $database_conx);
    $qry = "DELETE FROM ".$dbprefix."restaurants_employee WHERE recordid = '$recordid'";
    $rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
    header("Location: ".$current_page);
endif;

// Get All information
mysqli_select_db($conx, $database_conx);
$qry = "SELECT * FROM ".$dbprefix."users WHERE roleid = '2'";
$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
$Users = array();
while($rw = mysqli_fetch_object($rso)) array_push($Users, $rw);

// Get All information
mysqli_select_db($conx, $database_conx);
$qry = "SELECT * FROM ".$dbprefix."restaurants WHERE ownerid = '$UserID'";
$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
$Rests = array();
while($rw = mysqli_fetch_object($rso)) array_push($Rests, $rw);

// Get All information
mysqli_select_db($conx, $database_conx);
$qry = "SELECT * FROM ".$dbprefix."restaurants_employee re
        LEFT JOIN ".$dbprefix."restaurants r ON r.restid = re.restid
        WHERE r.ownerid = '$UserID'";
$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
$RestUsers = array();
while($rw = mysqli_fetch_object($rso)) array_push($RestUsers, $rw);

?>
<!DOCTYPE html>
<html lang="en" dir="ltr">

    <head>
<?php require_once('metadata.php') ?>
</head>

<body>
<?php require_once('header.php'); ?>
<div class="container-xxl">
	<div class="row-xl">
        <div class="container" style="margin-top:10px; margin-bottom:10px;min-height: 500px;">
          <div class="row justify-content-center">
              <div class="alert alert-secondary"><a href="dashboard.php">Dashboard</a> > Assign Employees</div>
              <div class="card">
                <div class="card-body">
                  <div class="row">
                    <?php if($act == ""): ?>
                      <div class="col-1">
                      <a href="<?php echo $current_page.'?act=assign' ?>" class="btn btn-primary btn-sm">New Assign</a>
                      </div>
                      <div class="row">
                      <table width="100%" cellpadding="0" cellspacing="0" class="table table-striped">
                        <tr>
                          <th>Restaurant</th>
                          <th>Employee</th>
                          <th>Action</th>
                        </tr>
                        <?php foreach($RestUsers as $RestUser): ?>
                          <tr>
                          <td><?php foreach($Rests as $Rest) if($Rest->restid == $RestUser->restid) echo $Rest->restname ?></td>
                          <td><?php foreach($Users as $User) if($User->userid == $User->userid) echo $User->username ?></td>
                          <td>
                            <a href="<?php echo $current_page.'?act=del&recordid='.$RestUser->recordid ?>"><i class="fa fa-trash"></i></a>
                          </td>
                        </tr>
                        <?php endforeach; ?>
                      </table>
                      </div>
                    <?php endif; ?>
                    <?php if($act == "assign"): ?>
                      <form id="form1" name="form1" method="post">
                      <table width="100%" cellpadding="0" cellspacing="0" class="table table-striped">
                        <tr>
                          <td>Select Restaurant</td>
                          <td><select id="restid" name="restid">
                            <?php foreach($Rests as $Rest): ?>
                            <option value="<?php echo $Rest->restid ?>"><?php echo $Rest->restname ?></option>
                            <?php endforeach; ?>
                          </select></td>
                        </tr>
                        <tr>
                          <td>Select Employee</td>
                          <td><select id="userid" name="userid">
                            <?php foreach($Users as $User): ?>
                            <option value="<?php echo $User->userid ?>"><?php echo $User->username ?></option>
                            <?php endforeach; ?>
                          </select></td>
                        </tr>
                        <tr>
                          <td colspan="2">
                            <input type="submit" value="Save" class="btn btn-primary btn-sm" />
                            <a href="<?php echo $current_page ?>" class="btn btn-dark btn-sm">Cancel</a>
                          </td>
                        </tr>
                      </table>
                    </form>                   
                    <?php endif; ?>
                  </div>
                </div>
              </div>
          </div>
        </div>
    </div>
</div>
<?php require_once('footer.php'); ?>
</body>
</html>