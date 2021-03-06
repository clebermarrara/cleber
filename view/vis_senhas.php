<div class="row">
	<div class="col-md-12">
		<div class="box box-success" id="firms">
			<div class="box-header with-border">
				<h3 class="box-title">Senhas Cadastradas</h3>
				<small>[<?=$cod ." - ".$rs->pegar("empresa","tri_clientes","cod = ".$cod);?>]</small>
			</div><!-- /.box-header -->
			<div id="slc" class="box-body">
			<?php
				require_once("../model/recordset.php");
				require_once("../class/class.functions.php");
				date_default_timezone_set("America/Sao_Paulo");
				$fn = new functions();
				$rs = new recordset();
				$rs2 = new recordset();
				$perm = $per->getPermissao("form_senhas.php",$_SESSION['usu_cod']);
			?>

				<table class="table table-striped" id="empr">
					<tr>
						<th>#</th>
						<th class="hidden-xs">Descri&ccedil;&atilde;o</th>
						<th>Acessar</th>
						<th>Usu&aacute;rio</th>
						<th class="hidden-xs">Senha</th>
						<th>A&ccedil;&otilde;es</th>
					</tr>	
			<?php
				$sql = "SELECT sen_cod, sen_desc, sen_acesso, sen_user, sen_senha, sen_id FROM senhas WHERE sen_cod=".$cod;
				$rs->FreeSql($sql);
				//echo $rs->sql;
				if($rs->linhas==0):
				echo "<tr><td colspan=7> Nenhuma solicita&ccedil;&atilde;o...</td></tr>";
				else:
					while($rs->GeraDados()){
					?>
						<tr>
							<td><?=$rs->fld("sen_id");?></td>
							<td class="hidden-xs"><?=$rs->fld("sen_desc");?></td>
							<td><a href="<?=$rs->fld("sen_acesso");?>" target="_blank"><?=$rs->fld("sen_acesso");?></td>
							<td><?=$rs->fld("sen_user");?></td>
							<td class="hidden-xs"><?=$rs->fld("sen_senha");?></td>
							
							<td class="">
								<a class='btn btn-xs btn-info' data-toggle='tooltip' data-placement='bottom' title='Visualizar' href="form_senhas.php?token=<?=$_SESSION['token']?>&clicod=<?=$rs->fld('sen_cod')?>&sen_id=<?=$rs->fld('sen_id')?>">
								<i class='fa fa-search'></i> </a>
								<?php
									if($perm['E']==1){?>
										<a class="btn btn-xs btn-danger" data-toggle='tooltip' data-placement='bottom' title='Excluir' href="javascript:del(<?=$rs->fld('sen_id');?>,'excEmpresa','a senha nº');">
											<i class="fa fa-trash"></i>
										</a>
									<?php } ?>
							</td>
						</tr>
					<?php  
					}
					echo "<tr><td colspan=7><strong>".$rs->linhas." Senha(s)</strong></td></tr>";
				endif;		
				?>
			</table>
			</div>
			<div class="box-footer">
				<a class='btn btn-sm btn-success' data-toggle='tooltip' data-placement='bottom' title='Nova Senha' href="form_senhas.php?token=<?=$_SESSION['token']?>&clicod=<?=$cod;?>"><i class="fa fa-plus"></i> Nova</a>
			</div>
		</div><!-- ./box -->
	</div><!-- ./col -->
</div>
<script src="<?=$hosted;?>/sistema/assets/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="<?=$hosted;?>/sistema/assets/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="<?=$hosted;?>/sistema/assets/plugins/datatables/dataTables.bootstrap.min.js"></script> 
