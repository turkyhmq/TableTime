<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/font-awesome.min.css">
<script src="js/jquery.js" type="text/javascript"></script>
<script src="js/bootstrap.bundle.min.js" type="text/javascript"></script>
<script src="js/jquery.validate.min.js" type="text/javascript"></script>
<script src="js/jquery.redirect.js" type="text/javascript"></script>
<script type="text/javascript">
$().ready(function(){
    $('.nav-link').each(function(){
        $(this).removeClass("active");
        href = $(this).attr('href');
        currenthref = document.location.href.split("/");
        if(href == currenthref[currenthref.length - 1]){
            $(this).addClass("active");
        }
    });

});
</script>
<style type="text/css">
header{
	height:120px;
	width:100%;
	background:#F60;
}

footer{
	height:50px;
	width:100%;
	background:#F60;
}
    .err,.required{color: #F00; }
    #topmenu{
        position: absolute; z-index: 1000;
    }
</style>
