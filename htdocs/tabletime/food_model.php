<?php 
require_once('Connections/conx.php');
require_once('pgaccess.php');

// Add New Field
$editFormAction = $_SERVER['PHP_SELF'];
if (isset($_SERVER['QUERY_STRING'])) {
  $editFormAction .= "?" . htmlentities($_SERVER['QUERY_STRING']);
}

$Types = ["", "Appetizers", "Seafood", "Chicken", "Meats", "Pizza", "Pastries", "Hot Drinks", "Cold Drinks", "Desserts", "Salads", "Sandwiches"];

// Insert New 
if ((isset($_POST["MM_insert"])) && ($_POST["MM_insert"] == "frmnewadd")) {
  $qry2 = sprintf("INSERT INTO ".$dbprefix."foods (restid, foodname, price, foodtype, calories) 
                VALUES ( %s, %s, %s, %s, %s)",
                        GetSQLValueString($_POST['restid'], "text"),
                        GetSQLValueString($_POST['foodname'], "text"),
                        GetSQLValueString($_POST['price'], "text"),
                        GetSQLValueString($_POST['foodtype'], "text"),
                        GetSQLValueString($_POST['calories'], "text"));
  $Result1 = mysqli_query($conx, $qry2) or die(mysqli_error($conx));

  header(sprintf("Location: %s", $current_page));
}

// Edit 
if ((isset($_POST["MM_insert2"])) && ($_POST["MM_insert2"] == "frmedit")) {
  $qry = sprintf("UPDATE ".$dbprefix."foods SET foodname=%s, price=%s, foodtype=%s, calories=%s   WHERE foodid=%s",
                        GetSQLValueString($_POST['foodname2'], "text"),
                        GetSQLValueString($_POST['price2'], "text"),
                        GetSQLValueString($_POST['foodtype2'], "text"),
                        GetSQLValueString($_POST['calories2'], "text"),
                        GetSQLValueString($_POST['foodid2'], "text"));

  $Result1 = mysqli_query($conx, $qry) or die(mysqli_error($conx));

  header(sprintf("Location: %s", $current_page));

}

// Delete 
if ((isset($_POST["MM_insert3"])) && ($_POST["MM_insert3"] == "frmdel")) {
  $qry = sprintf("DELETE FROM ".$dbprefix."foods WHERE foodid=%s",
                       GetSQLValueString($_POST['foodid3'], "double"));

  mysqli_select_db($conx, $database_conx);
  $Result1 = mysqli_query($conx, $qry) or die(mysqli_error($conx));

  header(sprintf("Location: %s", $current_page));
}

// Get All information
mysqli_select_db($conx, $database_conx);
$qry = "SELECT * FROM ".$dbprefix."restaurants";
$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
$Rests = array();
while($rw = mysqli_fetch_object($rso)) array_push($Rests, $rw);


// Get All information
mysqli_select_db($conx, $database_conx);
$qry = "SELECT * FROM ".$dbprefix."foods f
      LEFT JOIN ".$dbprefix."restaurants r ON r.restid = f.restid";
$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
$Foods = array();
while($rw = mysqli_fetch_object($rso)) array_push($Foods, $rw);

// Get Selected  information
$foodid = '';
if(isset($_GET['foodid'])):
  $foodid = $_GET['foodid'];	// selected id
    mysqli_select_db($conx, $database_conx);
    $qry = "SELECT * FROM ".$dbprefix."foods WHERE foodid='$foodid'";
    $rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
    $OneRecord = array();
    while($rw = mysqli_fetch_object($rso)) array_push($OneRecord, $rw);
endif;

?>
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
<?php require_once('metadata.php') ?>
<style>
  .ui-helper-hidden-accessible{display: none;}
</style>
<script type="text/javascript">
$().ready(function(){
    $('.edit').click(function(){
        var id = $(this).attr("id").split("_");
        window.open('<?php echo $current_page ?>?act=edit&foodid=' + id[1],'_self');
    });
    $('.del').click(function(){
        var id = $(this).attr("id").split("_");
        window.open('<?php echo $current_page ?>?act=del&foodid=' + id[1],'_self');
    });
    
    $('.cancel').click(function(){
        var id = $(this).attr("id").split("_");
        window.open('<?php echo $current_page ?>','_self');
    });

});
</script>

</head>

<body>
<?php require_once('header.php'); ?>
<div class="container-xxl">
    <div class="row-xl">
        <div class="container" style="margin-top:10px; margin-bottom:10px;min-height: 500px;">
          <div class="row justify-content-center">
              <div class="alert alert-secondary"><a href="dashboard.php">Dashboard</a> > Manage Foods </div>
              <div class="card">
                <div class="card-body">
<?php if($act == ""): ?>
    <fieldset>
<legend>List</legend>
      <button class="addnew btn btn-primary btn-sm" onClick="window.open('<?php echo $current_page ?>?act=addnew','_self')">
          <i class="fa fa-plus"></i> Add New
        </button>
    <?php if(count($Foods) > 0): ?>
      <table width="100%" cellpadding="0" cellspacing="0" class="table table-stripped">
        <tr style="background-color: #f2f2f2;">
        <td width="436"><strong>Resturant name </strong></td>
          <td width="436"><strong>Food </strong></td>
          <td width="594"><strong>Type</strong></td>
          <td width="594"><strong>Calories</strong></td>
          <td width="594"><strong>Price <?php echo '(SAR)'; ?></strong></td>
          <td width="106"><strong>Action</strong></td>
        </tr>
        <?php foreach($Foods as $row): ?>
        <tr>
          <td><?php echo $row->restname; ?></td>
          <td><?php echo $row->foodname; ?></td>
          <td><?php if($row->foodtype!="") echo $Types[trim($row->foodtype)] ?></td>
          <td><?php echo $row->calories; ?></td>
          <td><?php echo $row->price; ?></td>
          <td>
            <a href="#" id="edit_<?php echo $row->foodid ?>" class="edit btn"><i class="fa fa-edit"></i></a> 
            <a href="#" id="del_<?php echo $row->foodid ?>"title="Delete" class="del btn" style="background-color: red; color: white;"><i class="fa fa-trash"></i></a>
          </td>
        </tr>
        <?php endforeach; ?>
      </table>
      <?php else: ?>
      <div>No records exists</div>
      <?php endif; ?>
    </fieldset>

    <?php endif; if($act == "addnew"): ?>
    <fieldset>
    <legend>New record</legend>
        <?php if(isset($_GET['exists']) && $_GET['exists'] == "yes"): ?>
        <div style="color: #F00"><?php echo $_GET['fld'] ?>already exists</div>
        <?php endif; ?>
    <form id="frmnewadd" name="frmnewadd" method="POST" enctype="multipart/form-data" >
      <table align="center" cellpadding="0" cellspacing="0" class="table">
      <tr>
          <td>Select resturant:</td>
          <td><select id="restid" name="restid">
            <?php foreach($Rests as $Rest): ?>
            <option value="<?php echo $Rest->restid ?>"><?php echo $Rest->restname ?></option>
            <?php endforeach; ?>
        </select>
          </td>
        </tr>
                <tr>
          <td>Food name:</td>
          <td><input type="text" id="foodname" name="foodname" /></td>
        </tr>
        <td>Food Type:</td>
          <td><select id="foodtype" name="foodtype">
            <?php foreach($Types as $t=>$Type): ?>
            <option value="<?php echo $t ?>"><?php echo $Type ?></option>
            <?php endforeach; ?>
            </select>
          </td>
        </tr>
        <td>Calories:</td>
          <td><input type="text" id="calories" name="calories" /></td>
        </tr>                
        <tr>
        <td>Price:</td>
          <td><input type="text" id="price" name="price" /></td>
        </tr>
        <tr>
          <td><input type="submit" name="Submit" id="button" value="Save" class="btn btn-primary" />
            <input type="button" name="cancel" id="cancel" value="Cancel" class="btn btn-secondary cancel" /></td>
        </tr>
      </table>
      <input type="hidden" name="MM_insert" value="frmnewadd" />
    </form>
    </fieldset>

    <?php endif; ?>
    
    <?php if($act == "edit"): ?>
    <fieldset>
    <legend>Update record</legend>
    <form id="frmedit" name="frmedit" method="post" enctype="multipart/form-data" >
    <?php if(isset($_GET['exists']) && $_GET['exists'] == "yes"): ?>
      <div style="color: #F00"><?php echo $_GET['fld']; ?> already exists</div>
    <?php endif; ?>
    <?php foreach($OneRecord as $row): ?>
      <table align="center" cellpadding="0" cellspacing="0" class="table">
      <tr>
          <td>Food name:</td>
          <td><input type="text" id="foodname2" name="foodname2" value="<?php echo $row->foodname ?>" /></td>
        </tr>
        </tr>
        <td>Food Type:</td>
          <td><select id="foodtype2" name="foodtype2">
            <?php foreach($Types as $t=>$Type): ?>
            <option value="<?php echo $t ?>" <?php if($row->foodtype == $t) echo 'selected'; ?>><?php echo $Type ?></option>
            <?php endforeach; ?>
            </select>
          </td>
        </tr>
        <td>Calories:</td>
          <td><input type="text" id="calories2" name="calories2" value="<?php echo $row->calories ?>" /></td>
        </tr>                
        <tr>
        <td>Price:</td>
          <td><input type="text" id="price2" name="price2" value="<?php echo $row->price ?>" />
        </td>
        </tr>
        <tr>
          <td><input type="submit" name="Submit" id="button" value="Update" class="btn btn-primary" />
            <input type="button" name="cancel" id="cancel" value="Cancel" class="btn btn-secondary cancel" /></td>
        </tr>
      </table>
      <input type="hidden" name="foodid2" value="<?php echo $row->foodid ?>" />
      <input type="hidden" name="MM_insert2" value="frmedit" />
      <?php endforeach; ?>
    </form>
    </fieldset>

    <?php endif; ?>
    <?php if($act == "del"): ?>
    <fieldset>
    <legend>Delete record</legend>
    <?php foreach($OneRecord as $row): ?>
    <form id="frmdel" name="frmdel" method="post">
    <table align="center" cellpadding="0" cellspacing="0" class="table">
      <col width="64" span="2" />
      <tr>
        <td>Food name:</td>
        <td><?php echo $row->foodname ?></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td><input type="submit" name="button3" id="button3" value="Confirm delete" class="btn btn-danger" />
        <input type="button" name="cancel" id="cancel" value="Cancel" class="btn btn-secondary cancel" /></td>
      </tr>
    </table>
      <input type="hidden" name="foodid3" value="<?php echo $row->foodid ?>" />
      <input type="hidden" name="MM_insert3" value="frmdel" />
    </form>    
    <?php endforeach; ?>
    </fieldset>
    <?php endif; ?>
                </div>
          </div>
        </div>
    </div>
</div>
</div>
<?php require_once('footer.php'); ?>
</body>
</html>