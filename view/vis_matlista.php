<?php
	session_start("portal");
	require_once("../model/recordset.php");
	require_once("../class/class.functions.php");

	$fn = new functions();
	$rs = new recordset();

	/*
	$sql = "SELECT * FROM alerta_compras a 
			LEFT JOIN mat_cadastro b ON a.alerta_matId = b.mcad_id
			WHERE (a.alerta_matcomp - a.alerta_matentr) <= a.alerta_matmin
			AND a.alerta_matId NOT IN (SELECT mat_cadId FROM mat_historico WHERE mat_operacao = 'I' AND mat_lista IS NOT NULL )
			";
	  |-----------------------ALTERAÇÃO-----------------------|
	  | Data: 		22.10.2018
	  | Alteração:	A lista será preenchida através dos 
	  |				pedidos de compra feitos na solicitação
	  |-------------------------------------------------------|
	*/
	$sql = "SELECT * FROM mat_historico a
			LEFT JOIN mat_cadastro b ON a.mat_cadId = b.mcad_id
			WHERE 1
			AND mat_operacao = 'I' 
			AND mat_status =  0";
	$rs->FreeSql($sql);
	//echo $rs->sql;
	if($rs->linhas==0):
	echo "<tr><td colspan=6> Nenhum produto para compras</td></tr>";
	else: ?>
		<?php
		$soma = 0;
		while($rs->GeraDados()){
			
			?>
			<tr>
				<td><input type="checkbox" name="serv_cods[]" value="<?=$rs->fld("mat_id");?>" /></td>
				<td><?=$rs->fld("mat_id");?></td>
				<td><?=$rs->fld("mcad_desc");?></td>
				<td><?=$rs->fld("mat_qtd");?></td>
				
				
					
			</tr>
		<?php  
		}
		?>
		<?php endif;?>
	
