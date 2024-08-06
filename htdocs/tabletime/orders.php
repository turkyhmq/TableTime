<?php require_once('Connections/conx.php'); ?>
<?php require_once('pgaccess.php'); 


if($act == "save"):
  // Get All information for resvation
  mysqli_select_db($conx, $database_conx);
  $qry = "UPDATE ".$dbprefix."reservations SET foodstatus=1";
  $rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
  header("Location: ".$current_page);
endif;

// Get All information for foods
mysqli_select_db($conx, $database_conx);
$qry = "SELECT * FROM ".$dbprefix."foods";
$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
$Foods = array();
while($rw = mysqli_fetch_object($rso)) array_push($Foods, $rw);

// Get All information for Restaurant
mysqli_select_db($conx, $database_conx);
$qry = "SELECT * FROM ".$dbprefix."restaurants";
$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
$Rests = array();
while($rw = mysqli_fetch_object($rso)) array_push($Rests, $rw);


// ALTER TABLE `reservations` ADD `foodstatus` INT NULL DEFAULT '0' AFTER `foodlist`;  
// Get All information
mysqli_select_db($conx, $database_conx);
$qry = "SELECT * FROM ".$dbprefix."reservations r
        LEFT JOIN ".$dbprefix."users u ON u.userid = r.userid
        LEFT JOIN ".$dbprefix."reservations re ON re.reserveid = r.reserveid
        LEFT JOIN ".$dbprefix."seattables s ON s.tableid = r.tableid   
        WHERE r.foodstatus = '0'";
$rso = mysqli_query($conx, $qry) or die(mysqli_error($conx));
$Reservs = array();
while($rw = mysqli_fetch_object($rso)) array_push($Reservs, $rw);




?>
<!DOCTYPE html>
<html lang="en" dir="ltr">

<head>
    <?php require_once('metadata.php') ?>
    <style type="text/css">
        .fa {
            font-size: 40px;
            text-align: center;
        }
    </style>
    <script>
        $().ready(function () {
            $('.chk').click(function () {
                reserveid = $(this).val();
                if ($(this).prop('checked')) {
                    window.open('<?php echo $current_page ?>?act=save&reserveid=' + reserveid, '_self');
                }
            });

            $('.print').click(function () {
                el = $(this).attr('data-el');
                Print(el);
            });

            function Print(el) {
                var prtContent = $('<div></div>'),
                    invoice = $('#' + el).html();
                prtContent.append(invoice);
                var WinPrint = window.open('', '', 'left=0,top=0,width=5,height=5,toolbar=0,scrollbars=0,status=0');
                WinPrint.document.write(prtContent.html());
                WinPrint.document.close();
                WinPrint.focus();
                WinPrint.print();
                WinPrint.close();
            }
        });
    </script>
</head>

<body>
    <?php require_once('header.php'); ?>
    <div class="container-xxl">
        <div class="row-xl">
            <div class="container" style="margin-top:10px; margin-bottom:10px;min-height: 500px;">
                <div class="row justify-content-center">
                    <div class="alert alert-secondary"><a href="dashboard.php">Dashboard</a> > Manage orders </div>
                    <div class="card">
                        <div class="card-body">
                            <div class="row row-cols-1 row-cols-md-3 g-4">
                                <table class="table table-striped">
                                    <tr>
                                        <th> Customer Name </th>
                                        <th> Restaurant </th>
                                        <th>Table Number</th>
                                        <th>Table Position</th>
                                        <th>Time</th>
                                        <th>Foods requests</th>
                                        <th>Action</th>
                                    </tr>
                                    <?php foreach ($Reservs as $Reserv) : ?>
                                        <tr>
                                            <td><?php echo $Reserv->fullname ?></td>
                                            <td>
                                                <?php
                                                // Loop through $Rests array to find the restaurant name
                                                foreach ($Rests as $restaurant) {
                                                    if ($restaurant->restid == $Reserv->restid) {
                                                        echo $restaurant->restname;
                                                        break; // Exit loop once the restaurant name is found
                                                    }
                                                }
                                                ?>
                                            </td>
                                            <td><?php echo $Reserv->tabnum ?></td>
                                            <td><?php echo $Reserv->tabposition ?></td>
                                            <td><?php echo date('Y-m-d - H:i', $Reserv->reservetime) ?></td>

                                            <td>
                                                <?php
                                                $fod = str_replace("{", "", $Reserv->foodlist);
                                                $fod = str_replace("}", "", $fod);
                                                $fod = str_replace(" ", "", $fod);
                                                $fods = explode(",", $fod);
                                                $Invo = [];
                                                foreach ($fods as $fodx) :
                                                    foreach ($Foods as $Food) :
                                                        $fprt = explode(":", $fodx);
                                                        if ($fprt[0] == $Food->foodid) :
                                                            echo $Food->foodname . '<br>  ';
                                                        endif;
                                                    endforeach;
                                                endforeach;
                                                ?>
                                            </td>
                                            <td>
                                                <?php
                                                $chk = '';
                                                if ($Reserv->foodstatus != "0") $chk = 'checked="checked" disabled="disabled"';
                                                ?>
                                                <!-- <input type="checkbox" id="chk" name="chk" class="chk" -->
                                                 <!--   value="<?php echo $Reserv->reserveid  ?>" <?php echo $chk ?> /> -->
                                                <i class="fa fa-print print" data-el="invo_<?php echo $Reserv->reserveid ?>"
                                                    style="font-size:20px"></i>
                                            </td>
                                            <td>
                                                <div id="invo_<?php echo $Reserv->reserveid ?>" style="display:none">
                                                    <h3>Request Invoice <?php echo $Reserv->reserveid ?></h3>
                                                    <table width="100%" border="1" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <th>S</th>
                                                            <th>Item</th>
                                                            <th>Price</th>
                                                        </tr>
                                                        <?php
                                                        $Total = 0;
                                                        foreach ($Foods as $Food) :
                                                            foreach ($fods as $f => $fodx) :
                                                                $fprt = explode(":", $fodx);
                                                                if ($fprt[0] == $Food->foodid) :
                                                        ?>
                                                                    <tr>
                                                                        <td><?php echo $f + 1 ?></td>
                                                                        <td><?php echo $Food->foodname ?></td>
                                                                        <td><?php echo $Food->price;
                                                                                $Total += $Food->price;  ?></td>
                                                                    </tr>
                                                        <?php
                                                                endif;
                                                            endforeach;
                                                        endforeach;
                                                        ?>
                                                        <tr>
                                                            <th colspan="2">Total</th>
                                                            <th><?php echo $Total ?></th>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                    <?php endforeach; ?>
                                </table>

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
