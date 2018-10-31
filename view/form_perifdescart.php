<?php
/*inclusão dos principais itens da página */

$sec = "COMP";
$pag = "novo_periferico.php";
require_once("../config/main.php");
require_once("../config/valida.php");
require_once("../config/mnutop.php");
require_once("../config/menu.php");
require_once("../config/modals.php");
require_once("../class/class.functions.php");
require_once("../class/class.permissoes.php");
$per = new permissoes();
$con =$per->getPermissao($pag,$_SESSION['usu_cod']);
$rs= new recordset();
$rs2= new recordset();
$hide= "";
										
?>

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
		<!-- Content Header (Page header) -->
        <section class="content-header">
			<h1>
				Máquinas
			</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
				<li>Solicita&ccedil;&atilde;o</li>
				<li>Periféricos</li>
				<li class="active">Descartar</li>
			</ol>
        </section>
        <!-- Main content -->
        <section class="content">
			<div class="row">
			<div class="col-md-12">
				<!-- general form elements -->
					<div class="box box-primary	">
						<div class="box-header with-border">
							<h3 class="box-title">Periféricos</h3>
						</div><!-- /.box-header -->
						<!-- form start -->
						<form role="form" id="cad_maq">
							<div class="box-body">
								<div class="row">
									<?php
									if(isset($_GET['perid'])){
										$whr = " WHERE per_id=".$_GET['perid'];
										$sql = "SELECT * FROM perifericos a
								        			LEFT JOIN maquinas b ON a.per_maqid = b.maq_id
								        		".$whr;
								        $rs2->FreeSql($sql);
								        //echo $rs2->sql;
								        if($rs2->linhas>0){
								        	$rs2->GeraDados();
								        }
										if($rs2->fld("per_descart")==1){
										    $hide = "hide";
										}
									}
									?>
									<div class="form-group col-md-3">
										<label for="maq_login">Tipo:</label>
										<input type="text" class="form-control" disabled="" value="<?=$rs2->fld("per_tipo");?>" name="per_tipo" id="per_tipo"/>
										<input type="hidden" value="<?=$rs2->fld("per_id");?>" name="perid" id="perid"/>
										<input type="hidden" value="<?=$_SESSION['token'];?>" name="token" id="token"/>
									</div>
									<div class="form-group col-md-3">
										<label for="maq_user">Modelo:</label>
										<input type="text" class="form-control" id="per_modelo" name="per_modelo" value="<?=$rs2->fld("per_modelo");?>" />
									</div>
								</div>

								<div class="row">
									<div class="form-group col-md-12">
										<label for="maq_sys">Descrição do descarte:</label>
										<textarea class="form-control" id="per_obs"><?=$rs2->fld("per_obs");?></textarea>
									</div>
								
								</div>
								
							<div id="consulta"></div>
							<div id="formerrosdescarte" class="clearfix" style="display:none;">
								<div class="callout callout-danger">
									<h4>Erros no preenchimento do formul&aacute;rio.</h4>
									<p>Verifique os erros no preenchimento acima:</p>
									<ol>
										<!-- Erros são colocados aqui pelo validade -->
									</ol>
								</div>
							</div>
						</div>
						<div class="box-footer">
							<button class="btn btn-sm btn-danger <?=$hide;?>" type="button" id="bt_descarte"><i class="fa fa-times"></i> Descartar</button>
						</div>
						</form>
					</div><!-- ./box -->
				</div><!-- ./col -->
			</div>
		
		</section>
	</div>
	<?php
		require_once("../config/footer.php");
	?></div><!-- ./wrapper -->


<script src="<?=$hosted;?>/sistema/assets/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<!-- Bootstrap 3.3.5 -->
<script src="<?=$hosted;?>/sistema/assets/bootstrap/js/bootstrap.min.js"></script>
<!-- FastClick -->
<script src="<?=$hosted;?>/sistema/assets/plugins/fastclick/fastclick.min.js"></script>
<!-- AdminLTE App -->
<script src="<?=$hosted;?>/sistema/assets/dist/js/app.min.js"></script>
<!-- Slimscroll -->
<script src="<?=$hosted;?>/sistema/assets/plugins/slimScroll/jquery.slimscroll.min.js"></script>

<!-- InputMask -->
<script src="<?=$hosted;?>/sistema/assets/plugins/input-mask/jquery.inputmask.js"></script>
<script src="<?=$hosted;?>/sistema/assets/plugins/input-mask/jquery.inputmask.date.extensions.js"></script>
<script src="<?=$hosted;?>/sistema/assets/plugins/input-mask/jquery.inputmask.extensions.js"></script>

<script src="<?=$hosted;?>/sistema/assets/js/maskinput.js"></script>
<script src="<?=$hosted;?>/sistema/assets/js/jmask.js"></script>
<script src="<?=$hosted;?>/sistema/js/action_maquinas.js"></script>
<script src="<?=$hosted;?>/sistema/js/controle.js"></script>
<script src="<?=$hosted;?>/sistema/js/jquery.cookie.js"></script>
<script src="<?=$hosted;?>/sistema/js/functions.js"></script>
<script src="https://cdn.ckeditor.com/4.7.3/standard/ckeditor.js"></script>

<!-- SELECT2 TO FORMS-->
<script src="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.0/js/select2.min.js"></script>
<!--CHOSEN-->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.6.2/chosen.jquery.min.js"></script>
<!-- Validation -->
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script>
<script>
	/*------------------------|INICIA TOOLTIPS E POPOVERS|---------------------------------------*/
	$(document).ready(function () {
		CKEDITOR.replace('per_obs');		
	});
	
</script>

</body>
</html>	