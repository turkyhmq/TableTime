<?php require_once('Connections/conx.php'); ?>
<?php require_once('pgaccess.php');

// Delete assignment
if(isset($_POST['act']) && $_POST['act'] == "del"):
    $recordid = $_POST['recordid'];
    $qry = "DELETE FROM ".$dbprefix."restaurants_employee WHERE recordid = ?";
    $stmt = mysqli_prepare($conx, $qry);
    mysqli_stmt_bind_param($stmt, 'i', $recordid);
    mysqli_stmt_execute($stmt);
    header("Location: ".$current_page);
    exit();
endif;

// Assign employee to restaurant
if(isset($_POST['assignemp']) && $_POST['assignemp'] == "ok"):
    $restid = $_POST['restid'];
    $empid = $_POST['userid'];
    
    // Check if employee already assigned to this restaurant
    $existingQuery = "SELECT * FROM ".$dbprefix."restaurants_employee WHERE restid = ? AND userid = ?";
    $existingStmt = mysqli_prepare($conx, $existingQuery);
    mysqli_stmt_bind_param($existingStmt, 'ii', $restid, $empid);
    mysqli_stmt_execute($existingStmt);
    mysqli_stmt_store_result($existingStmt);
    $existingCount = mysqli_stmt_num_rows($existingStmt);
    
    if($existingCount > 0) {
        // Employee already assigned to this restaurant
        $error_message = "This employee is already assigned to the restaurant.";
    }

    // Check if employee already assigned to another restaurant
    $assignedQuery = "SELECT * FROM ".$dbprefix."restaurants_employee WHERE userid = ?";
    $assignedStmt = mysqli_prepare($conx, $assignedQuery);
    mysqli_stmt_bind_param($assignedStmt, 'i', $empid);
    mysqli_stmt_execute($assignedStmt);
    mysqli_stmt_store_result($assignedStmt);
    $assignedCount = mysqli_stmt_num_rows($assignedStmt);
    
    if($assignedCount > 0) {
        // Employee already assigned to another restaurant
        $error_message = "This employee is already assigned to another restaurant.";
    }

    if(!isset($error_message)) {
        // If employee not already assigned, proceed with assignment
        $qry = "INSERT INTO ".$dbprefix."restaurants_employee (restid, userid) VALUES (?, ?)";
        $stmt = mysqli_prepare($conx, $qry);
        mysqli_stmt_bind_param($stmt, 'ii', $restid, $empid);
        mysqli_stmt_execute($stmt);
        header("Location: ".$current_page);
        exit();
    }
endif;

// Get all users
$Users = fetchRecords($conx, "SELECT * FROM ".$dbprefix."users WHERE roleid = '2'");

// Get restaurants owned by current user
$Rests = fetchRecords($conx, "SELECT * FROM ".$dbprefix."restaurants WHERE ownerid = '$UserID'");

// Get restaurants and assigned employees for current user
$RestUsers = fetchRecords($conx, "SELECT re.*, r.restname, u.username 
                FROM ".$dbprefix."restaurants_employee re
                LEFT JOIN ".$dbprefix."restaurants r ON r.restid = re.restid
                LEFT JOIN ".$dbprefix."users u ON u.userid = re.userid
                WHERE r.ownerid = '$UserID'");

function fetchRecords($conx, $qry) {
    $result = mysqli_query($conx, $qry) or die(mysqli_error($conx));
    $records = array();
    while($row = mysqli_fetch_object($result)) {
        $records[] = $row;
    }
    return $records;
}
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
        <div class="container" style="margin-top:10px; margin-bottom:10px;min-height: 400px;">
            <div class="row justify-content-center">
                <div class="alert alert-secondary"><a href="dashboard.php">Dashboard</a> > Assign Employees</div>
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <?php if(empty($act)): ?>
                            <div class="col-1">
                                <a href="<?php echo $current_page.'?act=assign' ?>" class="btn btn-primary btn-sm">New<br>Assign</a>
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
                                            <td><?php echo $RestUser->restname ?></td>
                                            <td><?php echo $RestUser->username ?></td>
                                            <td>
                                                <form method="post">
                                                    <input type="hidden" name="act" value="del">
                                                    <input type="hidden" name="recordid" value="<?php echo $RestUser->recordid ?>">
                                                    <button type="submit" class="btn btn-danger"><i class="fa fa-trash"></i></button>                    
                                                </form>
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
                                            <td>
                                                <select id="restid" name="restid">
                                                    <?php foreach($Rests as $Rest): ?>
                                                    <option value="<?php echo $Rest->restid ?>"><?php echo $Rest->restname ?></option>
                                                    <?php endforeach; ?>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Select Employee</td>
                                            <td>
                                                <select id="userid" name="userid">
                                                    <?php foreach($Users as $User): ?>
                                                    <option value="<?php echo $User->userid ?>"><?php echo $User->username ?></option>
                                                    <?php endforeach; ?>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <input type="submit" value="Save" class="btn btn-primary btn-sm" />
                                                <a href="<?php echo $current_page ?>" class="btn btn-dark btn-sm">Cancel</a>
                                            </td>
                                        </tr>
                                    </table>
                                    <input type="hidden" name="assignemp" id="assignemp" value="ok">
                                </form>
                                <?php endif; ?>
                                <?php if(isset($error_message)): ?>
                                    <div class="alert alert-danger"><?php echo $error_message; ?></div>
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
