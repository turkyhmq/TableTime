<?php require_once('Connections/conx.php'); ?>
<?php require_once('pgaccess.php'); 

?>
<!DOCTYPE html>
<html lang="en" dir="ltr">

    <head>
<?php require_once('metadata.php') ?>
<style type="text/css">
  .fa{font-size: 40px; text-align: center;}
</style>
</head>

<body>
<?php require_once('header.php'); ?>
<div class="container-xxl">
	<div class="row-xl">
        <div class="container" style="margin-top:10px; margin-bottom:10px;min-height: 500px;">
          <div class="row justify-content-center">
              <div class="alert alert-secondary">Dashboard</div>
              <div class="card">
                <div class="card-body">
                  <div class="row row-cols-1 row-cols-md-3 g-4">
                    <!---1--->
                    <div class="col">
                      <div class="card">
                      <i class="fa fa-user"></i> 
                        <div class="card-body">
                          <div align="center"><a href="profile.php">My Profile</a></div>
                        </div>
                      </div>
                    </div>
                    <!---2--->
                    <div class="col">
                      <div class="card">
                      <i class="fa fa-users"></i> 
                        <div class="card-body">
                        <div align="center"><a href="user_model.php">Manage Users</a></div>
                        </div>
                      </div>
                    </div>
                    <!---3--->
                    <div class="col">
                      <div class="card">
                      <i class="fa fa-cogs"></i> 
                        <div class="card-body">
                        <div align="center"><a href="assignemployee.php">Assign Employees</a></div>
                        </div>
                      </div>
                    </div>
                    <!---4--->
                    <div class="col">
                      <div class="card">
                      <i class="fa fa-cutlery"></i> 
                        <div class="card-body">
                        <div align="center"><a href="food_model.php">Manage Foods</a></div>
                        </div>
                      </div>
                    </div>
                    <!---5--->
                    <div class="col">
                      <div class="card">
                      <i class="fa fa-list-ul"></i> 
                        <div class="card-body">
                        <div align="center"><a href="orders.php">Orders</a></div>
                        </div>
                      </div>
                    </div>
                    <!---6--->
                    <div class="col">
                      <div class="card">
                      <i class="fa fa-sign-out"></i> 
                        <div class="card-body">
                        <div align="center"><a href="dashboard.php?doLogout=true">Logout</a></div>
                        </div>
                      </div>
                    </div>
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