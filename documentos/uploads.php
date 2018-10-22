<?php
session_start("portal");
require_once("../class/class.functions.php");
$rs = new recordset();
$rs1 = new recordset();
$fn = new functions();
$actual_link = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://".$_SERVER["HTTP_HOST"]."/sistema";
$cod = $rs->autocod("envcli_id","doc_envclientes");
$msg = "";
extract($_POST);
$ref = explode("/", $publ_ref);
$mes = $ref[0];
$ano = $ref[1];
$fs = "/";
$depto = $rs->pegar("dep_nome","departamentos","dep_id=".$publ_dep);
$path = "./".$publ_cli.$fs.$depto.$fs.$ano.$fs.$mes;

// Criando a pasta do Ano/Mes, caso ainda não exista

if(!file_exists($path)){
	if(!mkdir($path, 0777, true))
		echo "FAILED<br>";
}

// Enviando arquivo para a pasta Ano/Mes, caso o arquivo não exista.
if(isset($_FILES['attachments'])){
	$fname = basename($_FILES['attachments']['name'][0]);
	$targetFile = $path."/".str_replace(" ", "_", $fname);

	if(file_exists($targetFile)){
		$msg = array("status" => 0, "msg" => "Arquivo $fname Já existe no servidor!");
	}
	
	else if(move_uploaded_file($_FILES['attachments']['tmp_name'][0], $targetFile)){
		$msg = array("status" => 1, "msg" => "Arquivo $fname foi salvo na pasta do Cliente!", "path" => $targetFile);
		// Atualizar a tabela impostos_enviados
		$sql = "UPDATE impostos_enviados SET env_enviado = 1 , env_user=".$_SESSION['usu_cod'].",env_data='".date("Y-m-d H:i:s")."'
				WHERE 1
				AND env_compet = '{$publ_ref}'
				AND env_codEmp = {$publ_cli}
				AND env_codImp = {$publ_imposto}
				";
		//echo $sql;
		$rs->FreeSql($sql);
		// Enviar arquivo para o banco de dados
		$sql = "SELECT env_id, env_codEmp, b.imp_id, b.imp_nome, b.imp_venc FROM impostos_enviados a
					JOIN tipos_impostos b ON b.imp_id = a.env_codImp
				WHERE 1
					AND env_compet = '{$publ_ref}'
					AND env_codEmp = {$publ_cli}
					AND env_codImp = {$publ_imposto}";
		$rs->FreeSql($sql);
		$rs->GeraDados();
						
		$dados = array();
		$dados['envcli_empresa']	= $rs->fld("env_codEmp");
		$dados['envcli_impId']		= $rs->fld("imp_id");
		$dados['envcli_impnome']	= $rs->fld("imp_nome");
		$dados['envcli_arquivo']	= $actual_link."/documentos/".$targetFile;
		$dados['envcli_arqnome']	= $fname;
		$dados['envcli_envpor']		= $_SESSION['usu_cod'];
		$dados['envcli_visual']		= 0 ;
		$dados['envcli_ativo']		= 1;
		//$dados['envcli_vencto']		= $ano."-".$mes."-".$rs->fld("imp_venc");
		$dados['envcli_id']			= $cod;
		if(!$rs->Insere($dados, "doc_envclientes")){
			$msg["email"] = "Arquivo armazenado para envio.";	
		}
		else{
			$msg["email"] = "Ocorreu um erro. Arquivo não será enviado";	
		}

		// Enviar para tabela de Emails
		
		/*
		$sq = "SELECT * FROM doc_envclientes a
				JOIN tri_clientes b ON a.envcli_empresa = b.cod
				LEFT JOIN usuarios c ON c.usu_cod = a.envcli_envpor
			WHERE envcli_id = {$cod}";
		$rs1->FreeSql($sq);
		//echo $sq;
		if($rs1->linhas==0){
			$msg["mensagem"] = "Não encontramos destinatário para a mensagem!";
		}
		else{
			$rs1->FreeSql($sq);
			$rs1->GeraDados();
			$cod_mds = $rs->autocod("mds_id","maildocumento");
			$dados2 = array();
			$dados2["mds_id"] = $cod_mds;
			$dados2['mds_dest'] = $rs1->fld("email");
			$message = file_get_contents("../view/template_senddocs.html");
			$message = str_replace("{RESP}", $rs1->fld("responsavel"),$message);
			$message = str_replace("{CLIENTE}", $rs1->fld("apelido"),$message);
			$message = str_replace("{IMPOSTO}", htmlentities($rs1->fld("envcli_impnome")),$message);
			$message = str_replace("{SIGN}", $rs1->fld("usu_sign"),$message);
			$message = str_replace("{LINK}", $rs1->fld("envcli_id"),$message);
			//$message = str_replace("{VENCTO}", $fn->data_br($rs1->fld("envcli_vencto")),$message);
			//$message = str_replace("{OBSERVACOES}", $rs1->fld("apelido"),$message);
			$dados2['mds_body'] = stripslashes($message);
			$dados2['mds_sender'] = $rs1->fld("usu_cod");
			$dados2['mds_status'] = 0;
			
			$rs1->Insere($dados2,"maildocumento");
		}
		*/
	}
	exit(json_encode($msg));
}
// Envia para a tabela de emails
// Rotinas nas Ferramentas ADMIN

?>
