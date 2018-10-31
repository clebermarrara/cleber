-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           5.6.17 - MySQL Community Server (GPL)
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Copiando estrutura para tabela priore_sys.alerta_compras
DROP TABLE IF EXISTS `alerta_compras`;
CREATE TABLE IF NOT EXISTS `alerta_compras` (
  `alerta_id` int(11) NOT NULL AUTO_INCREMENT,
  `alerta_matId` int(11) DEFAULT NULL,
  `alerta_matcomp` int(11) DEFAULT '0',
  `alerta_matentr` int(11) DEFAULT '0',
  `alerta_matmin` int(11) DEFAULT NULL,
  `alerta_matqtdcp` int(11) DEFAULT NULL,
  PRIMARY KEY (`alerta_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda Dados de produtos que estão no mínimo do estoque';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para procedure priore_sys.alerta_materiais
DROP PROCEDURE IF EXISTS `alerta_materiais`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `alerta_materiais`()
BEGIN
DECLARE n_reg INT;
DECLARE n_ini INT UNSIGNED DEFAULT 1;
DECLARE c_atual INT;
DECLARE comp_atual INT;
DECLARE entr_atual INT;
DECLARE minimo_atual INT;
DECLARE qtdcp_atual INT;
TRUNCATE alerta_compras;

SELECT count(mcad_id) INTO n_reg FROM mat_cadastro WHERE mcad_alerta = 1;

WHILE n_ini < n_reg DO
	SELECT mcad_id INTO c_atual FROM mat_cadastro WHERE mcad_alerta = 1 LIMIT n_ini,1;
	SELECT sum(mat_qtd) INTO comp_atual FROM mat_historico WHERE mat_cadId = c_atual AND mat_operacao = "I" AND mat_status=99;
	SELECT sum(mat_qtd) INTO entr_atual FROM mat_historico WHERE mat_cadId = c_atual AND mat_operacao = "O" AND mat_status=99;
	SELECT mcad_minimo INTO minimo_atual FROM mat_cadastro WHERE mcad_id = c_atual;
	SELECT mcad_compra INTO qtdcp_atual FROM mat_cadastro WHERE mcad_id = c_atual;
		
	INSERT INTO alerta_compras (alerta_matId, alerta_matcomp, alerta_matentr, alerta_matmin, alerta_matqtdcp)
								VALUES(c_atual, comp_atual, entr_atual, minimo_atual, qtdcp_atual);
	SET n_ini = n_ini+1;
END WHILE;
UPDATE alerta_compras SET alerta_matcomp = 0 WHERE alerta_matcomp IS NULL;
UPDATE alerta_compras SET alerta_matentr = 0 WHERE alerta_matentr IS NULL;
END//
DELIMITER ;

-- Copiando estrutura para tabela priore_sys.artigos
DROP TABLE IF EXISTS `artigos`;
CREATE TABLE IF NOT EXISTS `artigos` (
  `art_id` int(11) NOT NULL AUTO_INCREMENT,
  `art_categ` smallint(6) NOT NULL,
  `art_title` varchar(200) NOT NULL,
  `art_title2` varchar(200) NOT NULL,
  `art_briefing` text NOT NULL,
  `art_description` text NOT NULL,
  `art_content` text NOT NULL,
  `art_author` varchar(100) NOT NULL,
  `art_email` varchar(100) NOT NULL,
  `art_images` varchar(200) NOT NULL,
  `art_release` datetime NOT NULL,
  `art_references` varchar(500) NOT NULL,
  `art_short` varchar(30) NOT NULL,
  PRIMARY KEY (`art_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.art_categorias
DROP TABLE IF EXISTS `art_categorias`;
CREATE TABLE IF NOT EXISTS `art_categorias` (
  `cat_id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_desc` varchar(50) NOT NULL,
  `cat_ativo` smallint(6) NOT NULL DEFAULT '1',
  PRIMARY KEY (`cat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.calendario
DROP TABLE IF EXISTS `calendario`;
CREATE TABLE IF NOT EXISTS `calendario` (
  `cal_id` int(11) NOT NULL AUTO_INCREMENT,
  `cal_eveid` int(11) DEFAULT NULL,
  `cal_eveusu` varchar(200) DEFAULT NULL,
  `cal_dataini` date DEFAULT NULL,
  `cal_horaini` time DEFAULT NULL,
  `cal_datafim` date DEFAULT NULL,
  `cal_horafim` time DEFAULT NULL,
  `cal_url` varchar(200) DEFAULT NULL,
  `cal_criado` int(11) DEFAULT NULL,
  `cal_obs` text,
  PRIMARY KEY (`cal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='calendário de eventos\r\nUtiliza tabela eventos';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.certidoes
DROP TABLE IF EXISTS `certidoes`;
CREATE TABLE IF NOT EXISTS `certidoes` (
  `certid_id` int(11) NOT NULL AUTO_INCREMENT,
  `certid_cod` int(11) NOT NULL,
  `certid_tipoId` int(11) NOT NULL,
  `certid_validade` date NOT NULL,
  `certid_status` tinyint(4) NOT NULL,
  PRIMARY KEY (`certid_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.certificados
DROP TABLE IF EXISTS `certificados`;
CREATE TABLE IF NOT EXISTS `certificados` (
  `cer_id` int(11) NOT NULL AUTO_INCREMENT,
  `cer_cli` int(11) DEFAULT NULL,
  `cer_tipo` tinytext,
  `cer_entidade` varchar(50) DEFAULT NULL,
  `cer_media` varchar(50) DEFAULT NULL,
  `cer_pin` varchar(50) DEFAULT NULL,
  `cer_puk` varchar(50) DEFAULT NULL,
  `cer_validade` date DEFAULT NULL,
  `cer_valhora` time DEFAULT NULL,
  `cer_local` varchar(50) DEFAULT NULL,
  `cer_status` smallint(6) DEFAULT NULL,
  `cer_cadem` datetime DEFAULT NULL,
  `cer_cadpor` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`cer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.chamados
DROP TABLE IF EXISTS `chamados`;
CREATE TABLE IF NOT EXISTS `chamados` (
  `cham_id` int(11) NOT NULL AUTO_INCREMENT,
  `cham_empvinc` int(11) NOT NULL DEFAULT '0',
  `cham_dept` int(11) NOT NULL DEFAULT '0',
  `cham_task` varchar(30) NOT NULL,
  `cham_solic` int(11) NOT NULL COMMENT 'Quem solicitou',
  `cham_trat` int(11) NOT NULL COMMENT 'Quem tratou',
  `cham_percent` int(11) NOT NULL,
  `cham_maquina` tinyint(4) NOT NULL COMMENT 'Maquina Relacionada',
  `cham_status` int(11) NOT NULL,
  `cham_sla` time DEFAULT NULL,
  `cham_aval` double(3,2) NOT NULL COMMENT 'Nota de 0 à 5',
  `cham_abert` timestamp NOT NULL,
  `cham_tratini` timestamp NOT NULL,
  `cham_tratfim` timestamp NOT NULL,
  PRIMARY KEY (`cham_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela que gerencia os chamados internos';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.chamados_legal
DROP TABLE IF EXISTS `chamados_legal`;
CREATE TABLE IF NOT EXISTS `chamados_legal` (
  `cleg_id` int(11) NOT NULL AUTO_INCREMENT,
  `cleg_empvinc` int(11) NOT NULL DEFAULT '0',
  `cleg_depto` int(11) NOT NULL DEFAULT '0',
  `cleg_empresa` smallint(6) NOT NULL,
  `cleg_solic` int(11) NOT NULL COMMENT 'Quem solicitou',
  `cleg_para` int(11) NOT NULL,
  `cleg_trat` int(11) NOT NULL COMMENT 'Quem tratou',
  `cleg_percent` int(11) NOT NULL,
  `cleg_via` tinytext NOT NULL,
  `cleg_contato` varchar(50) NOT NULL,
  `cleg_status` int(11) NOT NULL,
  `cleg_sla` time DEFAULT NULL,
  `cleg_aval` double(3,2) NOT NULL COMMENT 'Nota de 0 à 5',
  `cleg_abert` timestamp NOT NULL,
  `cleg_tratini` timestamp NOT NULL,
  `cleg_tratfim` timestamp NOT NULL,
  `cleg_datafim` date NOT NULL COMMENT 'Data para previsão da tarefa',
  `cleg_subtar` int(11) DEFAULT NULL,
  PRIMARY KEY (`cleg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='Tabela que gerencia os chamados internos';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.chamlegal_checklist
DROP TABLE IF EXISTS `chamlegal_checklist`;
CREATE TABLE IF NOT EXISTS `chamlegal_checklist` (
  `clegchk_id` int(11) NOT NULL AUTO_INCREMENT,
  `clegchk_clegId` int(11) DEFAULT NULL,
  `clegchk_item` int(11) DEFAULT NULL,
  `clegchk_ativo` int(11) DEFAULT NULL,
  `clegchk_seppor` int(11) DEFAULT NULL,
  `clegchk_dtsep` datetime DEFAULT NULL,
  PRIMARY KEY (`clegchk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.chamleg_obs
DROP TABLE IF EXISTS `chamleg_obs`;
CREATE TABLE IF NOT EXISTS `chamleg_obs` (
  `chlegobs_id` int(11) NOT NULL AUTO_INCREMENT,
  `chlegobs_chamid` int(11) NOT NULL,
  `chlegobs_obs` varchar(4000) NOT NULL,
  `chlegobs_user` int(11) NOT NULL,
  `chlegobs_horario` timestamp NOT NULL,
  PRIMARY KEY (`chlegobs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='Tabela para observações dos chamados';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.cham_obs
DROP TABLE IF EXISTS `cham_obs`;
CREATE TABLE IF NOT EXISTS `cham_obs` (
  `chobs_id` int(11) NOT NULL AUTO_INCREMENT,
  `chobs_chamid` int(11) NOT NULL,
  `chobs_obs` varchar(4000) NOT NULL,
  `chobs_user` int(11) NOT NULL,
  `chobs_horario` timestamp NOT NULL,
  PRIMARY KEY (`chobs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela para observações dos chamados';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.chat
DROP TABLE IF EXISTS `chat`;
CREATE TABLE IF NOT EXISTS `chat` (
  `chat_id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_msg` varchar(5000) DEFAULT NULL,
  `chat_de` int(11) DEFAULT NULL,
  `chat_para` int(11) DEFAULT NULL,
  `chat_lido` int(11) DEFAULT NULL,
  `chat_hora` timestamp NULL DEFAULT NULL,
  `chat_view` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Armazena conversas online com o Admin\r\n';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.checklists
DROP TABLE IF EXISTS `checklists`;
CREATE TABLE IF NOT EXISTS `checklists` (
  `chk_id` int(11) NOT NULL AUTO_INCREMENT,
  `chk_item` varchar(100) DEFAULT NULL,
  `chk_dep` int(11) DEFAULT NULL,
  `chk_ordem` int(11) DEFAULT NULL,
  `chk_depref` int(11) DEFAULT NULL,
  `chk_modulo` varchar(50) DEFAULT NULL,
  `chk_tarefaVinculo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`chk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.classes
DROP TABLE IF EXISTS `classes`;
CREATE TABLE IF NOT EXISTS `classes` (
  `classe_id` int(11) NOT NULL AUTO_INCREMENT,
  `classe_desc` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`classe_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Armazena a Classe dos usuários.\r\nTabela criada caso haja necessidade de o sistema ser utilizado por mais de uma empresa';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.clientes_arquivos
DROP TABLE IF EXISTS `clientes_arquivos`;
CREATE TABLE IF NOT EXISTS `clientes_arquivos` (
  `cliarq_id` int(11) NOT NULL AUTO_INCREMENT,
  `cliarq_empresa` int(11) DEFAULT NULL,
  `cliarq_arqId` int(11) DEFAULT NULL,
  `cliarq_venc` int(11) DEFAULT NULL,
  `cliarq_ativo` int(11) DEFAULT NULL,
  `cliarq_detalhes` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`cliarq_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='This table keeps the type of files customers need to send in order to proceed the closure.';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.clientes_tel
DROP TABLE IF EXISTS `clientes_tel`;
CREATE TABLE IF NOT EXISTS `clientes_tel` (
  `ctel_id` int(11) NOT NULL AUTO_INCREMENT,
  `ctel_lista` int(11) NOT NULL,
  `ctel_cod` int(11) NOT NULL,
  `ctel_nome` varchar(200) NOT NULL,
  `ctel_doc` varchar(18) NOT NULL,
  PRIMARY KEY (`ctel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.codstatus
DROP TABLE IF EXISTS `codstatus`;
CREATE TABLE IF NOT EXISTS `codstatus` (
  `st_cod` int(11) NOT NULL AUTO_INCREMENT,
  `st_codstatus` int(11) DEFAULT '0',
  `st_desc` varchar(50) DEFAULT '0',
  `st_opcaode` varchar(50) DEFAULT '0',
  `st_icone` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`st_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='SERVE PARA TODAS AS TABELAS QUE TEM ALGUM STATUS :)';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.comunicacao
DROP TABLE IF EXISTS `comunicacao`;
CREATE TABLE IF NOT EXISTS `comunicacao` (
  `com_id` int(11) NOT NULL AUTO_INCREMENT,
  `com_cod` int(11) DEFAULT NULL,
  `com_canal` varchar(50) DEFAULT NULL,
  `com_depto` int(11) DEFAULT NULL,
  `com_obs` varchar(1000) DEFAULT NULL,
  `com_usu` int(11) DEFAULT NULL,
  `com_data` datetime DEFAULT NULL,
  `com_ativo` int(11) DEFAULT NULL,
  PRIMARY KEY (`com_id`),
  KEY `fkComDepto` (`com_depto`),
  CONSTRAINT `fkComDepto` FOREIGN KEY (`com_depto`) REFERENCES `departamentos` (`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.contatos
DROP TABLE IF EXISTS `contatos`;
CREATE TABLE IF NOT EXISTS `contatos` (
  `con_cod` int(11) NOT NULL AUTO_INCREMENT,
  `con_cli_cnpj` varchar(18) DEFAULT '0',
  `con_tipo` varchar(30) DEFAULT '0',
  `con_contato` varchar(255) DEFAULT '0',
  PRIMARY KEY (`con_cod`),
  KEY `FKCli_cod` (`con_cli_cnpj`),
  CONSTRAINT `FKCli_cod` FOREIGN KEY (`con_cli_cnpj`) REFERENCES `empresas` (`emp_cnpj`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='tabela de contatos ligadas ao cliente';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.contatos_cli
DROP TABLE IF EXISTS `contatos_cli`;
CREATE TABLE IF NOT EXISTS `contatos_cli` (
  `ctcli_id` int(11) NOT NULL AUTO_INCREMENT,
  `ctcli_lista` int(11) NOT NULL DEFAULT '0',
  `ctcli_tel` varchar(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ctcli_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.controle_horas
DROP TABLE IF EXISTS `controle_horas`;
CREATE TABLE IF NOT EXISTS `controle_horas` (
  `ch_id` int(11) NOT NULL AUTO_INCREMENT,
  `ch_data` date NOT NULL,
  `ch_colab` int(11) NOT NULL,
  `ch_hora_entrada` time NOT NULL,
  `ch_hora_saida` time NOT NULL,
  `ch_usucad` int(11) NOT NULL,
  `ch_horacad` timestamp NOT NULL,
  `ch_status` int(11) NOT NULL,
  `ch_referido` int(11) NOT NULL,
  `ch_aprovadopor` int(11) NOT NULL,
  `ch_horario` int(11) NOT NULL,
  PRIMARY KEY (`ch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.cpcviews
DROP TABLE IF EXISTS `cpcviews`;
CREATE TABLE IF NOT EXISTS `cpcviews` (
  `cpc_id` int(11) NOT NULL AUTO_INCREMENT,
  `cpc_cli` int(11) DEFAULT NULL,
  `cpc_usuario` int(11) DEFAULT NULL,
  `cpc_times` int(11) DEFAULT NULL,
  `cpc_lastseen` datetime DEFAULT NULL,
  PRIMARY KEY (`cpc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='It helps to Get how many accesses the CPC has by customer.';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.dados_user
DROP TABLE IF EXISTS `dados_user`;
CREATE TABLE IF NOT EXISTS `dados_user` (
  `dados_id` int(11) NOT NULL AUTO_INCREMENT,
  `dados_nome` varchar(100) DEFAULT '0',
  `dados_cpf` varchar(14) DEFAULT '0',
  `dados_rg` varchar(30) DEFAULT '0',
  `dados_sexo` enum('0','1') DEFAULT '0',
  `dados_escol` varchar(50) DEFAULT NULL,
  `dados_cep` varchar(8) DEFAULT NULL,
  `dados_rua` varchar(200) DEFAULT NULL,
  `dados_num` varchar(20) DEFAULT NULL,
  `dados_compl` varchar(50) DEFAULT NULL,
  `dados_bairro` varchar(50) DEFAULT NULL,
  `dados_cidade` varchar(50) DEFAULT NULL,
  `dados_uf` varchar(50) DEFAULT NULL,
  `dados_usu_email` varchar(200) DEFAULT NULL,
  `dados_habil` varchar(200) DEFAULT NULL,
  `dados_usucor` varchar(10) DEFAULT NULL,
  `dados_notas` varchar(200) DEFAULT NULL,
  `dados_nasc` date DEFAULT '0000-00-00',
  PRIMARY KEY (`dados_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela para dados do usuario.\r\nPartilha informações com a tabela contato.';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para evento priore_sys.deletar_inativo
DROP EVENT IF EXISTS `deletar_inativo`;
DELIMITER //
CREATE DEFINER=`br_admin`@`%` EVENT `deletar_inativo` ON SCHEDULE EVERY 10 MINUTE STARTS '2015-09-21 13:14:05' ON COMPLETION NOT PRESERVE DISABLE DO UPDATE logado SET log_status="0" WHERE NOT(NOW() BETWEEN log_horario AND log_expira)//
DELIMITER ;

-- Copiando estrutura para tabela priore_sys.departamentos
DROP TABLE IF EXISTS `departamentos`;
CREATE TABLE IF NOT EXISTS `departamentos` (
  `dep_id` int(11) NOT NULL AUTO_INCREMENT,
  `dep_nome` varchar(50) DEFAULT NULL,
  `dep_tema` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cadastra Departamentos da empresa';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.desconto_horas
DROP TABLE IF EXISTS `desconto_horas`;
CREATE TABLE IF NOT EXISTS `desconto_horas` (
  `desc_id` int(11) NOT NULL AUTO_INCREMENT,
  `desc_colab` int(11) NOT NULL,
  `desc_horas` float(4,2) NOT NULL,
  `desc_data` datetime NOT NULL,
  `desc_usucad` int(11) NOT NULL,
  `desc_obs` text NOT NULL,
  PRIMARY KEY (`desc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Essa tabela é responsável por descontar as horas calculadas pelo controle de horas e registrar as ações.';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para evento priore_sys.DISPARA_ALERTA_COMPRA
DROP EVENT IF EXISTS `DISPARA_ALERTA_COMPRA`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` EVENT `DISPARA_ALERTA_COMPRA` ON SCHEDULE EVERY 10 MINUTE STARTS '2017-08-21 07:20:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
CALL alerta_materiais;
END//
DELIMITER ;

-- Copiando estrutura para tabela priore_sys.docs_entrada
DROP TABLE IF EXISTS `docs_entrada`;
CREATE TABLE IF NOT EXISTS `docs_entrada` (
  `doc_id` int(11) NOT NULL AUTO_INCREMENT,
  `doc_tipo` int(11) DEFAULT NULL,
  `doc_ref` varchar(7) DEFAULT NULL,
  `doc_empresa` smallint(6) DEFAULT NULL,
  `doc_cli` int(11) DEFAULT NULL,
  `doc_dep` int(11) DEFAULT NULL,
  `doc_resp` int(11) DEFAULT NULL,
  `doc_data` timestamp NULL DEFAULT NULL,
  `doc_datarec` timestamp NULL DEFAULT NULL,
  `doc_obs` varchar(400) NOT NULL DEFAULT '0',
  `doc_status` int(11) DEFAULT NULL,
  `doc_recpor` int(11) DEFAULT NULL,
  `doc_origem` varchar(50) DEFAULT NULL,
  `doc_local` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`doc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.documentos
DROP TABLE IF EXISTS `documentos`;
CREATE TABLE IF NOT EXISTS `documentos` (
  `doc_cod` int(11) NOT NULL AUTO_INCREMENT,
  `doc_cli_cnpj` varchar(18) DEFAULT NULL,
  `doc_finalidade` varchar(3) DEFAULT NULL,
  `doc_tipo` varchar(255) DEFAULT NULL,
  `doc_ender` text,
  `doc_dtenv` date DEFAULT NULL,
  `doc_user_env` varchar(200) DEFAULT NULL,
  `doc_desc` varchar(300) DEFAULT NULL,
  `doc_visto` int(11) DEFAULT NULL,
  PRIMARY KEY (`doc_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='armazena os documentos dos clientes';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.doc_envclientes
DROP TABLE IF EXISTS `doc_envclientes`;
CREATE TABLE IF NOT EXISTS `doc_envclientes` (
  `envcli_id` int(11) NOT NULL AUTO_INCREMENT,
  `envcli_empresa` smallint(6) NOT NULL,
  `envcli_impId` int(11) NOT NULL,
  `envcli_impnome` varchar(50) DEFAULT NULL,
  `envcli_arqnome` varchar(100) NOT NULL DEFAULT '0',
  `envcli_arquivo` text NOT NULL COMMENT 'Armazena o caminho do arquivo a ser enviado via e-mail',
  `envcli_visual` tinyint(4) NOT NULL,
  `envcli_envpor` tinyint(4) NOT NULL,
  `envcli_vispor` varchar(50) NOT NULL,
  `envcli_visem` datetime NOT NULL,
  `envcli_ativo` tinyint(4) NOT NULL COMMENT 'Indica se o documento esta ativo',
  `envcli_vencto` date NOT NULL,
  `envcli_pago` tinyint(4) NOT NULL COMMENT 'Indica se o cliente efetuou o pagamento',
  `envcli_emailed` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`envcli_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela para armazenar dados de arquivos enviados ao cliente para envio posterior no email.';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.doc_recebidos
DROP TABLE IF EXISTS `doc_recebidos`;
CREATE TABLE IF NOT EXISTS `doc_recebidos` (
  `drec_id` int(11) NOT NULL AUTO_INCREMENT,
  `drec_empCod` int(11) NOT NULL,
  `drec_docId` int(11) NOT NULL,
  `drec_compet` varchar(7) NOT NULL,
  `drec_entId` int(11) NOT NULL,
  PRIMARY KEY (`drec_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.empresas
DROP TABLE IF EXISTS `empresas`;
CREATE TABLE IF NOT EXISTS `empresas` (
  `emp_codigo` int(11) NOT NULL AUTO_INCREMENT,
  `emp_cnpj` varchar(18) NOT NULL,
  `emp_cod_ac` varchar(18) NOT NULL,
  `emp_senha_ac` varchar(30) NOT NULL,
  `emp_validadesen` date NOT NULL,
  `emp_razao` varchar(50) NOT NULL,
  `emp_nome` varchar(50) NOT NULL,
  `emp_nasc` date DEFAULT NULL,
  `emp_ie` varchar(18) NOT NULL DEFAULT '000.000.000.000' COMMENT 'Número de Registro da Empresa dentro do Estado',
  `emp_im` varchar(8) DEFAULT NULL COMMENT 'Número de Registro da Empresa dentro do Município',
  `emp_cnae` varchar(7) DEFAULT NULL,
  `emp_crt` varchar(7) DEFAULT NULL,
  `emp_cep` varchar(10) NOT NULL,
  `emp_logr` varchar(70) NOT NULL,
  `emp_num` varchar(10) NOT NULL,
  `emp_compl` varchar(30) NOT NULL,
  `emp_bairro` varchar(50) NOT NULL,
  `emp_cidade` varchar(30) NOT NULL,
  `emp_uf` varchar(2) NOT NULL,
  `emp_resp` varchar(50) NOT NULL,
  `emp_evento` enum('1','2') NOT NULL,
  `emp_logo` varchar(100) NOT NULL,
  `emp_obs` longtext NOT NULL,
  `emp_benef` varchar(50) NOT NULL,
  PRIMARY KEY (`emp_codigo`),
  UNIQUE KEY `emp_cnpj` (`emp_cnpj`),
  KEY `emp_cnpj_2` (`emp_cnpj`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.entradas_recebidos
DROP TABLE IF EXISTS `entradas_recebidos`;
CREATE TABLE IF NOT EXISTS `entradas_recebidos` (
  `drec_id` int(11) NOT NULL AUTO_INCREMENT,
  `drec_empCod` int(11) NOT NULL,
  `drec_docId` int(11) NOT NULL,
  `drec_compet` varchar(7) NOT NULL,
  `drec_entId` int(11) NOT NULL,
  PRIMARY KEY (`drec_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.entrada_docs
DROP TABLE IF EXISTS `entrada_docs`;
CREATE TABLE IF NOT EXISTS `entrada_docs` (
  `doc_id` int(11) NOT NULL AUTO_INCREMENT,
  `doc_tipo` int(11) DEFAULT NULL,
  `doc_ref` varchar(7) DEFAULT NULL,
  `doc_empresa` smallint(6) DEFAULT NULL,
  `doc_cli` int(11) DEFAULT NULL,
  `doc_dep` int(11) DEFAULT NULL,
  `doc_resp` int(11) DEFAULT NULL,
  `doc_data` timestamp NULL DEFAULT NULL,
  `doc_datarec` timestamp NULL DEFAULT NULL,
  `doc_obs` varchar(400) NOT NULL DEFAULT '0',
  `doc_status` int(11) DEFAULT NULL,
  `doc_recpor` int(11) DEFAULT NULL,
  `doc_origem` varchar(50) DEFAULT NULL,
  `doc_local` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`doc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.eventos
DROP TABLE IF EXISTS `eventos`;
CREATE TABLE IF NOT EXISTS `eventos` (
  `eve_id` int(11) NOT NULL AUTO_INCREMENT,
  `eve_desc` varchar(50) NOT NULL DEFAULT '0',
  `eve_tema` varchar(50) NOT NULL DEFAULT '0',
  `eve_cor` varchar(50) NOT NULL DEFAULT '0',
  `eve_dep` tinytext NOT NULL,
  PRIMARY KEY (`eve_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cria eventos no Sistema';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.feriados
DROP TABLE IF EXISTS `feriados`;
CREATE TABLE IF NOT EXISTS `feriados` (
  `fer_id` int(11) NOT NULL AUTO_INCREMENT,
  `fer_data` date NOT NULL,
  `fer_desc` varchar(50) NOT NULL,
  PRIMARY KEY (`fer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='cadastro dos feriados do ano';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.homologacoes
DROP TABLE IF EXISTS `homologacoes`;
CREATE TABLE IF NOT EXISTS `homologacoes` (
  `hom_id` int(11) NOT NULL AUTO_INCREMENT,
  `hom_data` datetime NOT NULL,
  `hom_empvinculo` int(11) NOT NULL,
  `hom_datahom` date NOT NULL,
  `hom_docs` varchar(50) NOT NULL,
  `hom_empresa` int(11) NOT NULL,
  `hom_empregado` varchar(100) NOT NULL,
  `hom_inden` int(11) NOT NULL,
  `hom_local` varchar(200) NOT NULL,
  `hom_horario` varchar(20) NOT NULL,
  `hom_valor` decimal(10,2) NOT NULL,
  `hom_status` int(11) NOT NULL,
  `hom_cadpor` int(11) NOT NULL,
  `hom_realpor` int(11) NOT NULL,
  `hom_realdata` datetime NOT NULL,
  PRIMARY KEY (`hom_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='This table keeps data regarding homologations and send a notify with an email to the company''s responsible.\r\nIt avoids the employee to forget any detail of this process...';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.homologa_check
DROP TABLE IF EXISTS `homologa_check`;
CREATE TABLE IF NOT EXISTS `homologa_check` (
  `homchk_id` int(11) NOT NULL AUTO_INCREMENT,
  `homchk_homId` int(11) DEFAULT NULL,
  `homchk_item` int(11) DEFAULT NULL,
  `homchk_ativo` int(11) DEFAULT NULL,
  `homchk_seppor` int(11) DEFAULT NULL,
  `homchk_dtsep` datetime DEFAULT NULL,
  PRIMARY KEY (`homchk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.homologa_obs
DROP TABLE IF EXISTS `homologa_obs`;
CREATE TABLE IF NOT EXISTS `homologa_obs` (
  `homobs_id` int(11) NOT NULL AUTO_INCREMENT,
  `homobs_homId` int(11) NOT NULL,
  `homobs_user` int(11) unsigned zerofill NOT NULL,
  `homobs_data` timestamp NOT NULL,
  `homobs_obs` varchar(4000) NOT NULL,
  PRIMARY KEY (`homobs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='This table keeps all observations made on the items of the table homolocacoes.';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.horarios
DROP TABLE IF EXISTS `horarios`;
CREATE TABLE IF NOT EXISTS `horarios` (
  `horario_id` int(11) NOT NULL AUTO_INCREMENT,
  `horario_nome` varchar(50) NOT NULL DEFAULT '0',
  `horario_entrada` time NOT NULL DEFAULT '00:00:00',
  `horario_saida` time NOT NULL DEFAULT '00:00:00',
  `horario_ativo` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`horario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.implantacoes
DROP TABLE IF EXISTS `implantacoes`;
CREATE TABLE IF NOT EXISTS `implantacoes` (
  `impla_id` int(11) NOT NULL AUTO_INCREMENT,
  `impla_data` datetime DEFAULT NULL,
  `impla_vinc` int(11) DEFAULT NULL,
  `impla_dataimp` date DEFAULT NULL,
  `impla_dtbol` int(11) DEFAULT NULL,
  `impla_empresa` int(11) DEFAULT NULL,
  `impla_obs` varchar(50) DEFAULT NULL,
  `impla_status` int(11) DEFAULT NULL,
  `impla_cadpor` int(11) DEFAULT NULL,
  `impla_valor` float(6,2) DEFAULT '0.00',
  `impla_realpor` int(11) DEFAULT NULL,
  `impla_dtreal` datetime DEFAULT NULL,
  PRIMARY KEY (`impla_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='This table keeps data regarding the processe that the customers need to provide to us in order to starting make the accountancy job\r\n';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.implanta_check
DROP TABLE IF EXISTS `implanta_check`;
CREATE TABLE IF NOT EXISTS `implanta_check` (
  `impchk_id` int(11) NOT NULL AUTO_INCREMENT,
  `impchk_impId` int(11) DEFAULT NULL,
  `impchk_item` int(11) DEFAULT NULL,
  `impchk_ativo` int(11) DEFAULT NULL,
  `impchk_seppor` int(11) DEFAULT NULL,
  `impchk_dtsep` datetime DEFAULT NULL,
  PRIMARY KEY (`impchk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.implanta_obs
DROP TABLE IF EXISTS `implanta_obs`;
CREATE TABLE IF NOT EXISTS `implanta_obs` (
  `impobs_id` int(11) NOT NULL AUTO_INCREMENT,
  `impobs_impId` int(11) DEFAULT NULL,
  `impobs_user` int(11) DEFAULT NULL,
  `impobs_data` datetime DEFAULT NULL,
  `impobs_obs` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`impobs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.impostos_enviados
DROP TABLE IF EXISTS `impostos_enviados`;
CREATE TABLE IF NOT EXISTS `impostos_enviados` (
  `env_id` int(11) NOT NULL AUTO_INCREMENT,
  `env_codEmp` int(11) NOT NULL,
  `env_codImp` int(11) NOT NULL,
  `env_compet` varchar(50) NOT NULL,
  `env_mov` int(11) DEFAULT NULL,
  `env_movdata` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `env_movuser` int(11) DEFAULT NULL,
  `env_gerado` int(11) DEFAULT NULL,
  `env_geradodata` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `env_geradouser` int(11) DEFAULT NULL,
  `env_geradotent` int(11) DEFAULT '0',
  `env_conferido` int(11) DEFAULT NULL,
  `env_conferidodata` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `env_conferidouser` int(11) DEFAULT NULL,
  `env_conferidotent` int(11) DEFAULT '0',
  `env_data` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `env_enviado` int(11) DEFAULT NULL,
  `env_user` int(11) DEFAULT NULL,
  `env_confenvdata` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `env_confenv` int(11) DEFAULT NULL,
  `env_confenvuser` int(11) DEFAULT NULL,
  PRIMARY KEY (`env_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda informações sobre envio de impostos\r\nNão vinculado com o envio real.';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.irpf_cotas
DROP TABLE IF EXISTS `irpf_cotas`;
CREATE TABLE IF NOT EXISTS `irpf_cotas` (
  `icot_id` int(11) NOT NULL AUTO_INCREMENT,
  `icot_ir_id` int(11) NOT NULL DEFAULT '0',
  `icot_parc` int(11) NOT NULL,
  `icot_valor` float(11,2) NOT NULL,
  `icot_ref` varchar(7) NOT NULL,
  `icot_print` enum('Y','N') DEFAULT 'N',
  `icot_quem` int(11) DEFAULT NULL,
  `icot_datas` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`icot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Armazena os valores e vencimentos para pagamento de cotas no caso de IAP';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.irpf_mailsender
DROP TABLE IF EXISTS `irpf_mailsender`;
CREATE TABLE IF NOT EXISTS `irpf_mailsender` (
  `ims_id` int(11) NOT NULL AUTO_INCREMENT,
  `ims_dest` varchar(400) DEFAULT NULL,
  `ims_arquivo` varchar(4000) DEFAULT NULL,
  `ims_nomearquivo` varchar(4000) DEFAULT NULL,
  `ims_assunto` varchar(100) DEFAULT NULL,
  `ims_message` varchar(1000) DEFAULT NULL,
  `ims_clicpf` varchar(14) DEFAULT NULL,
  `ims_star` int(11) DEFAULT NULL,
  `ims_enviado` int(11) DEFAULT NULL,
  `ims_user` varchar(50) DEFAULT NULL,
  `ims_hora` datetime DEFAULT NULL,
  PRIMARY KEY (`ims_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='It sends emails to the customer based on the file clicked by the user';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.irpf_outrosdocs
DROP TABLE IF EXISTS `irpf_outrosdocs`;
CREATE TABLE IF NOT EXISTS `irpf_outrosdocs` (
  `irdocs_id` int(11) NOT NULL AUTO_INCREMENT,
  `irdocs_cli_id` int(11) NOT NULL,
  `irdocs_tipo` varchar(50) NOT NULL,
  `irdocs_dado` varchar(50) NOT NULL,
  PRIMARY KEY (`irdocs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Outros documentos para imposto de renda';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.irpf_recibo
DROP TABLE IF EXISTS `irpf_recibo`;
CREATE TABLE IF NOT EXISTS `irpf_recibo` (
  `irec_id` int(11) NOT NULL AUTO_INCREMENT,
  `irec_emt_por` int(11) DEFAULT NULL,
  `irec_data` timestamp NULL DEFAULT NULL,
  `irec_pago` int(11) DEFAULT NULL,
  `irec_ativo` int(11) DEFAULT NULL,
  `irec_forma` varchar(50) DEFAULT NULL,
  `irec_pagodata` timestamp NULL DEFAULT NULL,
  `irec_valor` float(13,2) DEFAULT '0.00',
  `irec_compl` varchar(50) DEFAULT NULL,
  `irec_obs` varchar(200) DEFAULT NULL,
  `irec_recpor` int(11) DEFAULT NULL,
  PRIMARY KEY (`irec_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Gerencia o status do Recibo';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.irpf_retorno
DROP TABLE IF EXISTS `irpf_retorno`;
CREATE TABLE IF NOT EXISTS `irpf_retorno` (
  `iret_id` int(11) NOT NULL AUTO_INCREMENT,
  `iret_ir_id` int(11) NOT NULL DEFAULT '0',
  `iret_tipo` varchar(3) NOT NULL,
  `iret_valor` float(11,2) NOT NULL,
  `iret_cotas` int(11) NOT NULL,
  `iret_datalib` date NOT NULL,
  `iret_pagto` varchar(50) NOT NULL,
  PRIMARY KEY (`iret_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Armazena o retorno do imposto';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.irpf_selic
DROP TABLE IF EXISTS `irpf_selic`;
CREATE TABLE IF NOT EXISTS `irpf_selic` (
  `isel_id` int(11) NOT NULL AUTO_INCREMENT,
  `isel_ref` varchar(7) NOT NULL,
  `isel_taxa` float(3,2) NOT NULL,
  PRIMARY KEY (`isel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Armazena as taxas mensais da SELIC de acordo com o site da Receita\r\n';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.irrf
DROP TABLE IF EXISTS `irrf`;
CREATE TABLE IF NOT EXISTS `irrf` (
  `ir_Id` int(11) NOT NULL AUTO_INCREMENT,
  `ir_cli_id` int(11) DEFAULT NULL,
  `ir_tipo` varchar(50) DEFAULT NULL,
  `ir_compl` varchar(50) DEFAULT NULL,
  `ir_valor` double(11,2) DEFAULT NULL,
  `ir_ano` varchar(4) DEFAULT NULL,
  `ir_status` int(11) DEFAULT NULL,
  `ir_cad_user` int(11) DEFAULT NULL,
  `ir_ult_user` int(11) DEFAULT NULL,
  `ir_dataent` timestamp NULL DEFAULT NULL,
  `ir_dataalt` timestamp NULL DEFAULT NULL,
  `ir_reciboId` int(11) DEFAULT NULL,
  `ir_pendencia` int(11) DEFAULT '0',
  PRIMARY KEY (`ir_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela que armazena impostos de Renda realizados';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.irrf_historico
DROP TABLE IF EXISTS `irrf_historico`;
CREATE TABLE IF NOT EXISTS `irrf_historico` (
  `irh_id` int(11) NOT NULL AUTO_INCREMENT,
  `irh_ir_id` int(11) DEFAULT NULL,
  `irh_usu_cod` int(11) DEFAULT NULL,
  `irh_obs` varchar(200) DEFAULT NULL,
  `irh_dataalt` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`irh_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Armazena as alterações realizadas em cada registro no IRRF';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.listados
DROP TABLE IF EXISTS `listados`;
CREATE TABLE IF NOT EXISTS `listados` (
  `lver_id` int(11) NOT NULL AUTO_INCREMENT,
  `lver_listaId` int(11) DEFAULT NULL,
  `lver_maquina` varchar(15) DEFAULT NULL,
  `lver_respostas` varchar(500) DEFAULT NULL,
  `lver_obs` varchar(1000) DEFAULT NULL,
  `lver_feitopor` int(11) NOT NULL,
  PRIMARY KEY (`lver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.listagens
DROP TABLE IF EXISTS `listagens`;
CREATE TABLE IF NOT EXISTS `listagens` (
  `lista_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `lista_desc` varchar(50) DEFAULT NULL,
  `lista_depto` smallint(6) DEFAULT NULL,
  `lista_criadopor` smallint(6) DEFAULT NULL,
  `lista_data` datetime DEFAULT NULL,
  PRIMARY KEY (`lista_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.lista_verificacao
DROP TABLE IF EXISTS `lista_verificacao`;
CREATE TABLE IF NOT EXISTS `lista_verificacao` (
  `lista_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `lista_empresa` smallint(6) NOT NULL,
  `lista_empvinc` smallint(6) NOT NULL,
  `lista_data` date NOT NULL,
  `lista_compet` varchar(7) NOT NULL,
  `lista_user` smallint(6) NOT NULL,
  `lista_datacad` datetime NOT NULL,
  `lista_datafin` datetime NOT NULL,
  `lista_status` int(11) DEFAULT NULL,
  PRIMARY KEY (`lista_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.logado
DROP TABLE IF EXISTS `logado`;
CREATE TABLE IF NOT EXISTS `logado` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `log_user` varchar(100) NOT NULL DEFAULT '0',
  `log_classe` tinyint(4) NOT NULL DEFAULT '0',
  `log_token` varchar(100) NOT NULL DEFAULT '0',
  `log_horario` timestamp NULL DEFAULT NULL,
  `log_expira` timestamp NULL DEFAULT NULL,
  `log_status` enum('1','0') DEFAULT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela para Logados';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.logs_altera
DROP TABLE IF EXISTS `logs_altera`;
CREATE TABLE IF NOT EXISTS `logs_altera` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `log_cod` int(11) NOT NULL,
  `log_acao` varchar(100) NOT NULL,
  `log_altera` varchar(4000) NOT NULL,
  `log_user` int(11) NOT NULL,
  `log_data` date NOT NULL,
  `log_datahora` datetime NOT NULL,
  `log_icon` varchar(50) NOT NULL,
  `log_cor` varchar(50) NOT NULL,
  PRIMARY KEY (`log_id`),
  KEY `log_id` (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.ltempo
DROP TABLE IF EXISTS `ltempo`;
CREATE TABLE IF NOT EXISTS `ltempo` (
  `tem_id` int(11) NOT NULL AUTO_INCREMENT,
  `tem_data` date DEFAULT NULL,
  `tem_hora` datetime DEFAULT NULL,
  `tem_usu_id` int(11) DEFAULT NULL,
  `tem_Titulo` varchar(200) DEFAULT '0',
  `tem_icone` varchar(50) DEFAULT '0',
  `tem_cor` varchar(50) DEFAULT '0',
  `tem_desc` varchar(400) DEFAULT '0',
  `tem_local` varchar(50) DEFAULT '0',
  PRIMARY KEY (`tem_id`),
  KEY `FKusu` (`tem_usu_id`),
  CONSTRAINT `FKusu` FOREIGN KEY (`tem_usu_id`) REFERENCES `usuarios` (`usu_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='guarda eventos para a linnha do tempo';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.maildocumento
DROP TABLE IF EXISTS `maildocumento`;
CREATE TABLE IF NOT EXISTS `maildocumento` (
  `mds_id` int(11) NOT NULL AUTO_INCREMENT,
  `mds_dest` varchar(400) NOT NULL,
  `mds_subj` varchar(100) NOT NULL,
  `mds_anexos` text,
  `mds_body` text NOT NULL,
  `mds_comp` varchar(7) NOT NULL,
  `mds_sender` smallint(6) NOT NULL,
  `mds_hora` datetime NOT NULL,
  `mds_status` smallint(6) NOT NULL,
  PRIMARY KEY (`mds_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.maquinas
DROP TABLE IF EXISTS `maquinas`;
CREATE TABLE IF NOT EXISTS `maquinas` (
  `maq_id` int(11) NOT NULL AUTO_INCREMENT,
  `maq_empvinc` int(11) NOT NULL,
  `maq_cliente` int(11) NOT NULL,
  `maq_ip` varchar(20) NOT NULL,
  `maq_user` int(11) NOT NULL,
  `maq_usuario` varchar(50) NOT NULL,
  `maq_sistema` varchar(50) NOT NULL,
  `maq_memoria` varchar(50) NOT NULL,
  `maq_hd` varchar(50) NOT NULL,
  `maq_ativa` int(11) NOT NULL,
  `maq_tipo` varchar(50) NOT NULL,
  PRIMARY KEY (`maq_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.mat_cadastro
DROP TABLE IF EXISTS `mat_cadastro`;
CREATE TABLE IF NOT EXISTS `mat_cadastro` (
  `mcad_id` int(11) NOT NULL AUTO_INCREMENT,
  `mcad_catid` int(11) NOT NULL DEFAULT '0',
  `mcad_desc` varchar(50) NOT NULL DEFAULT '0',
  `mcad_minimo` int(11) NOT NULL DEFAULT '0',
  `mcad_alerta` int(11) NOT NULL DEFAULT '0',
  `mcad_compra` int(11) NOT NULL DEFAULT '0',
  `mcad_ultpreco` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`mcad_id`),
  KEY `fkCate` (`mcad_catid`),
  CONSTRAINT `fkCate` FOREIGN KEY (`mcad_catid`) REFERENCES `mat_categorias` (`mcat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cadastro de materiais\r\n';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.mat_categorias
DROP TABLE IF EXISTS `mat_categorias`;
CREATE TABLE IF NOT EXISTS `mat_categorias` (
  `mcat_id` int(11) NOT NULL AUTO_INCREMENT,
  `mcat_desc` varchar(50) NOT NULL,
  PRIMARY KEY (`mcat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Categorias de Materiais';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.mat_historico
DROP TABLE IF EXISTS `mat_historico`;
CREATE TABLE IF NOT EXISTS `mat_historico` (
  `mat_id` int(11) NOT NULL AUTO_INCREMENT,
  `mat_empcod` int(11) DEFAULT NULL,
  `mat_catId` int(11) NOT NULL,
  `mat_cadId` int(11) NOT NULL,
  `mat_operacao` enum('I','O') NOT NULL,
  `mat_data` datetime NOT NULL,
  `mat_qtd` int(11) NOT NULL DEFAULT '0',
  `mat_status` int(11) NOT NULL,
  `mat_obs` varchar(200) NOT NULL,
  `mat_usuSol` int(11) DEFAULT NULL,
  `mat_entregue` datetime DEFAULT NULL,
  `mat_usuDisp` int(11) DEFAULT NULL,
  `mat_lista` int(11) DEFAULT NULL,
  PRIMARY KEY (`mat_id`),
  KEY `fkCat` (`mat_catId`),
  KEY `fkCad` (`mat_cadId`),
  CONSTRAINT `fkCad` FOREIGN KEY (`mat_cadId`) REFERENCES `mat_cadastro` (`mcad_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fkCat` FOREIGN KEY (`mat_catId`) REFERENCES `mat_cadastro` (`mcad_catid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='historico de movimentação dos materiais';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.mat_listas
DROP TABLE IF EXISTS `mat_listas`;
CREATE TABLE IF NOT EXISTS `mat_listas` (
  `mlist_id` int(11) NOT NULL AUTO_INCREMENT,
  `mlist_data` date NOT NULL DEFAULT '0000-00-00',
  `mlist_venc` date NOT NULL DEFAULT '0000-00-00',
  `mlist_solic` int(11) NOT NULL DEFAULT '0',
  `mlist_atend` int(11) NOT NULL DEFAULT '0',
  `mlist_status` int(11) NOT NULL DEFAULT '0',
  `mlist_ativo` int(11) NOT NULL DEFAULT '0',
  `mlist_useralt` int(11) DEFAULT NULL,
  `mlist_dataalt` datetime DEFAULT NULL,
  PRIMARY KEY (`mlist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.mensagens
DROP TABLE IF EXISTS `mensagens`;
CREATE TABLE IF NOT EXISTS `mensagens` (
  `men_id` int(11) NOT NULL AUTO_INCREMENT,
  `men_depto` int(11) NOT NULL,
  `men_titulo` varchar(50) NOT NULL,
  `men_corpo` text NOT NULL,
  `men_dtini` date NOT NULL,
  `men_dtfim` date NOT NULL,
  PRIMARY KEY (`men_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.mensagens_view
DROP TABLE IF EXISTS `mensagens_view`;
CREATE TABLE IF NOT EXISTS `mensagens_view` (
  `mview_id` int(11) NOT NULL AUTO_INCREMENT,
  `mview_msgId` int(11) NOT NULL,
  `mview_usu` int(11) NOT NULL,
  `mview_abert` datetime NOT NULL,
  `mview_fech` datetime NOT NULL,
  PRIMARY KEY (`mview_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.menu_triangulo
DROP TABLE IF EXISTS `menu_triangulo`;
CREATE TABLE IF NOT EXISTS `menu_triangulo` (
  `mnu_id` int(11) NOT NULL AUTO_INCREMENT,
  `mnu_cod` int(11) DEFAULT NULL,
  `mnu_titulo` varchar(100) DEFAULT NULL,
  `mnu_sess` varchar(50) DEFAULT NULL,
  `mnu_sysSessao` varchar(50) DEFAULT NULL,
  `mnu_icon` varchar(50) DEFAULT NULL,
  `mnu_link` varchar(50) DEFAULT NULL,
  `mnu_niveis` varchar(50) DEFAULT NULL,
  `mnu_filhos` enum('1','0') DEFAULT NULL,
  `mnu_hier` enum('P','F') DEFAULT NULL,
  PRIMARY KEY (`mnu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Menus do Sistema para permissionamento';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.metas
DROP TABLE IF EXISTS `metas`;
CREATE TABLE IF NOT EXISTS `metas` (
  `metas_id` int(11) NOT NULL AUTO_INCREMENT,
  `metas_colab` int(11) NOT NULL,
  `metas_dataini` date NOT NULL,
  `metas_datafin` date NOT NULL,
  `metas_criadopor` smallint(6) NOT NULL,
  PRIMARY KEY (`metas_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.metas_ocorrencias
DROP TABLE IF EXISTS `metas_ocorrencias`;
CREATE TABLE IF NOT EXISTS `metas_ocorrencias` (
  `metasobs_id` int(11) NOT NULL AUTO_INCREMENT,
  `metasobs_tarId` smallint(6) NOT NULL,
  `metasobs_obs` text NOT NULL,
  `metasobs_por` smallint(6) NOT NULL,
  `metasobs_data` datetime NOT NULL,
  PRIMARY KEY (`metasobs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.obrigacoes
DROP TABLE IF EXISTS `obrigacoes`;
CREATE TABLE IF NOT EXISTS `obrigacoes` (
  `ob_id` int(11) NOT NULL AUTO_INCREMENT,
  `ob_cod` int(11) DEFAULT NULL,
  `ob_titulo` int(11) DEFAULT NULL,
  `ob_depto` int(11) DEFAULT NULL,
  `ob_venc` int(11) DEFAULT NULL,
  `ob_ativo` int(11) DEFAULT NULL,
  PRIMARY KEY (`ob_id`),
  KEY `fkObDepto` (`ob_depto`),
  KEY `ob_id` (`ob_id`),
  CONSTRAINT `fkObDepto` FOREIGN KEY (`ob_depto`) REFERENCES `departamentos` (`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.particularidades
DROP TABLE IF EXISTS `particularidades`;
CREATE TABLE IF NOT EXISTS `particularidades` (
  `part_id` int(11) NOT NULL AUTO_INCREMENT,
  `part_cod` int(11) NOT NULL,
  `part_titulo` varchar(50) NOT NULL DEFAULT '0',
  `part_usu` int(11) NOT NULL,
  `part_depto` int(11) NOT NULL,
  `part_data` datetime NOT NULL,
  `part_dataoc` date NOT NULL,
  `part_obs` text NOT NULL,
  `part_tipo` int(11) NOT NULL,
  `part_lei` varchar(50) NOT NULL,
  `part_link` varchar(200) NOT NULL,
  `part_ativo` int(11) NOT NULL,
  PRIMARY KEY (`part_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.perifericos
DROP TABLE IF EXISTS `perifericos`;
CREATE TABLE IF NOT EXISTS `perifericos` (
  `per_id` int(11) NOT NULL AUTO_INCREMENT,
  `per_empvinc` int(11) NOT NULL,
  `per_maqid` int(11) NOT NULL,
  `per_tipo` varchar(50) NOT NULL,
  `per_modelo` varchar(50) NOT NULL,
  `per_status` varchar(50) NOT NULL,
  `per_ativo` int(11) NOT NULL,
  `per_datacad` timestamp NOT NULL,
  `per_usucad` int(11) NOT NULL,
  PRIMARY KEY (`per_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.permissoes
DROP TABLE IF EXISTS `permissoes`;
CREATE TABLE IF NOT EXISTS `permissoes` (
  `pem_id` int(11) NOT NULL AUTO_INCREMENT,
  `pem_desc` varchar(50) DEFAULT NULL,
  `pem_pag` varchar(50) NOT NULL,
  `pem_permissoes` varchar(500) NOT NULL DEFAULT '{"1":{"A":1,"E":1,"C":1,"I":1},"2":{"A":0,"E":0,"C":0,"I":0},"3":{"A":0,"E":0,"C":0,"I":0},"4":{"A":0,"E":0,"C":0,"I":0},"5":{"A":0,"E":0,"C":0,"I":0},"6":{"A":0,"E":0,"C":0,"I":0},"7":{"A":0,"E":0,"C":0,"I":0},"8":{"A":0,"E":0,"C":0,"I":0}}',
  PRIMARY KEY (`pem_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Gerencia o acesso ao conteudo e funcionalidades';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.permissoes_indiv
DROP TABLE IF EXISTS `permissoes_indiv`;
CREATE TABLE IF NOT EXISTS `permissoes_indiv` (
  `pem_id` int(11) NOT NULL AUTO_INCREMENT,
  `pem_user` int(11) NOT NULL,
  `pem_pag` varchar(50) NOT NULL,
  `pem_permissoes` varchar(500) NOT NULL,
  `pem_desc` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`pem_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Keep the individual permissions.\r\nThe same fields that the table permission.\r\nWhen a colaborator has a permission set uo here, this permission overwrite the group permission.';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.porte_empresa
DROP TABLE IF EXISTS `porte_empresa`;
CREATE TABLE IF NOT EXISTS `porte_empresa` (
  `port_id` int(11) NOT NULL AUTO_INCREMENT,
  `port_tipo` int(11) NOT NULL,
  `port_tam` varchar(10) NOT NULL,
  `port_func` varchar(50) NOT NULL,
  PRIMARY KEY (`port_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.recalculos
DROP TABLE IF EXISTS `recalculos`;
CREATE TABLE IF NOT EXISTS `recalculos` (
  `rec_id` int(11) NOT NULL AUTO_INCREMENT,
  `rec_data` datetime NOT NULL,
  `rec_doc` int(11) NOT NULL,
  `rec_user` int(11) NOT NULL,
  `rec_emp` int(11) NOT NULL COMMENT 'Empresa do func logado. Recebe $_SESSION[emp_cod'']',
  `rec_cli` int(11) NOT NULL COMMENT 'Empresa escolhida. tri_clientes',
  `rec_compet` varchar(50) NOT NULL,
  `rec_val` float(7,2) NOT NULL,
  `rec_qtd` tinyint(4) NOT NULL,
  `rec_usuSol` int(11) NOT NULL,
  `rec_obs` varchar(200) DEFAULT NULL,
  `rec_status` int(11) NOT NULL,
  PRIMARY KEY (`rec_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Armazena dados de recalculo';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.senhas
DROP TABLE IF EXISTS `senhas`;
CREATE TABLE IF NOT EXISTS `senhas` (
  `sen_id` int(11) NOT NULL AUTO_INCREMENT,
  `sen_cod` int(11) NOT NULL,
  `sen_desc` varchar(50) NOT NULL,
  `sen_acesso` varchar(200) NOT NULL,
  `sen_user` varchar(40) NOT NULL,
  `sen_senha` varchar(40) NOT NULL,
  `sen_obs` text NOT NULL,
  `sen_usercad` int(11) NOT NULL,
  `sen_dtcad` datetime NOT NULL,
  PRIMARY KEY (`sen_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.servicos
DROP TABLE IF EXISTS `servicos`;
CREATE TABLE IF NOT EXISTS `servicos` (
  `ser_id` int(11) NOT NULL AUTO_INCREMENT,
  `ser_data` timestamp NOT NULL,
  `ser_usuario` int(11) NOT NULL,
  `ser_cliente` int(11) NOT NULL,
  `ser_venc` date NOT NULL,
  `ser_obs` varchar(1000) COLLATE utf8_bin NOT NULL,
  `ser_status` int(11) NOT NULL,
  `ser_lista` int(11) NOT NULL,
  PRIMARY KEY (`ser_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Lista de servicos';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.serv_hist
DROP TABLE IF EXISTS `serv_hist`;
CREATE TABLE IF NOT EXISTS `serv_hist` (
  `shist_id` int(11) NOT NULL AUTO_INCREMENT,
  `shist_serid` int(11) NOT NULL,
  `shist_data` timestamp NOT NULL,
  `shist_user` int(11) NOT NULL,
  `shist_obs` varchar(400) NOT NULL,
  PRIMARY KEY (`shist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='histórico dos serviços';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.serv_saidas
DROP TABLE IF EXISTS `serv_saidas`;
CREATE TABLE IF NOT EXISTS `serv_saidas` (
  `said_id` int(11) NOT NULL AUTO_INCREMENT,
  `said_usuario` int(11) NOT NULL,
  `said_data` timestamp NOT NULL,
  `said_lista` int(11) NOT NULL,
  `said_venc` date NOT NULL,
  `said_status` int(11) NOT NULL,
  `said_ativo` int(11) NOT NULL,
  `said_useralt` int(11) NOT NULL,
  `said_dataalt` timestamp NOT NULL,
  PRIMARY KEY (`said_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.sistema
DROP TABLE IF EXISTS `sistema`;
CREATE TABLE IF NOT EXISTS `sistema` (
  `sys_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `sys_nome` varchar(20) COLLATE utf8_bin NOT NULL,
  `sys_versao` varchar(10) COLLATE utf8_bin NOT NULL,
  `sys_retorno` varchar(255) COLLATE utf8_bin NOT NULL,
  `sys_empresa` varchar(50) COLLATE utf8_bin NOT NULL,
  `sys_cnpj` varchar(18) COLLATE utf8_bin NOT NULL,
  `sys_mail` varchar(255) COLLATE utf8_bin NOT NULL,
  `sys_senha` varchar(20) COLLATE utf8_bin NOT NULL,
  `sys_logo` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `sys_dominio` varchar(100) COLLATE utf8_bin NOT NULL,
  `sys_site` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `sys_usaLigacoes` tinyint(4) DEFAULT '0',
  `sys_usaClientes` tinyint(4) DEFAULT '0',
  `sys_usaServicos` tinyint(4) DEFAULT '0',
  `sys_usaAtendLig` tinyint(4) DEFAULT '0',
  `sys_usaGerenciador` tinyint(4) DEFAULT '0',
  `sys_usaDocumentos` tinyint(4) DEFAULT '0',
  `sys_usaRelSaidas` tinyint(4) DEFAULT '0',
  `sys_usaRelLig` tinyint(4) DEFAULT '0',
  `sys_usaRelDocs` tinyint(4) DEFAULT '0',
  `sys_usaIrpf` tinyint(4) DEFAULT '0',
  `sys_usaChamados` tinyint(4) DEFAULT '0',
  `sys_usaControleHoras` tinyint(4) DEFAULT '0',
  `sys_usaComputadores` tinyint(4) DEFAULT '0',
  `sys_usaColaboradores` tinyint(4) DEFAULT '0',
  `sys_usaCalendario` tinyint(4) DEFAULT '0',
  `sys_usaAssinaturas` tinyint(4) DEFAULT '0',
  `sys_usaMateriais` tinyint(4) DEFAULT '0',
  `sys_usaRecalculo` tinyint(4) DEFAULT '0',
  `sys_usaRelEnvios` tinyint(4) DEFAULT '0',
  `sys_usaHomologa` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`sys_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tab_municipios
DROP TABLE IF EXISTS `tab_municipios`;
CREATE TABLE IF NOT EXISTS `tab_municipios` (
  `id` varchar(50) DEFAULT NULL,
  `iduf` int(11) DEFAULT NULL,
  `nome` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='municipios da sefaz';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tarefas
DROP TABLE IF EXISTS `tarefas`;
CREATE TABLE IF NOT EXISTS `tarefas` (
  `task_id` int(11) NOT NULL AUTO_INCREMENT,
  `task_desc` varchar(50) NOT NULL,
  `task_tipo` varchar(3) NOT NULL,
  `task_campo` varchar(3) NOT NULL,
  `task_ativo` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tarmetas
DROP TABLE IF EXISTS `tarmetas`;
CREATE TABLE IF NOT EXISTS `tarmetas` (
  `tarmetas_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `tarmetas_metasId` smallint(6) NOT NULL,
  `tarmetas_emp` smallint(6) NOT NULL,
  `tarmetas_comp` varchar(7) NOT NULL,
  `tarmetas_obri` smallint(6) NOT NULL,
  `tarmetas_incl` datetime DEFAULT NULL,
  `tarmetas_por` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`tarmetas_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tbl_estado
DROP TABLE IF EXISTS `tbl_estado`;
CREATE TABLE IF NOT EXISTS `tbl_estado` (
  `est_cod` tinyint(4) DEFAULT NULL,
  `est_sigla` varchar(2) DEFAULT NULL,
  `est_estado` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='guarda codigos do estado uteis para NFE';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tipos_arquivos
DROP TABLE IF EXISTS `tipos_arquivos`;
CREATE TABLE IF NOT EXISTS `tipos_arquivos` (
  `tarq_id` int(11) NOT NULL AUTO_INCREMENT,
  `tarq_nome` varchar(100) NOT NULL,
  `tarq_depart` int(11) NOT NULL,
  `tarq_desc` varchar(1000) NOT NULL,
  `tarq_status` int(11) NOT NULL DEFAULT '1',
  `tarq_formato` varchar(50) NOT NULL,
  `tarq_duplica` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`tarq_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tipos_calc
DROP TABLE IF EXISTS `tipos_calc`;
CREATE TABLE IF NOT EXISTS `tipos_calc` (
  `calc_id` int(11) NOT NULL AUTO_INCREMENT,
  `calc_desc` varchar(50) NOT NULL,
  `calc_preco` double(7,2) NOT NULL,
  PRIMARY KEY (`calc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Armazena os calculos que podem ser executados.\r\nFornece dados para a tabela recalculos.';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tipos_certidoes
DROP TABLE IF EXISTS `tipos_certidoes`;
CREATE TABLE IF NOT EXISTS `tipos_certidoes` (
  `tipocertid_id` int(11) NOT NULL AUTO_INCREMENT,
  `tipocertid_desc` varchar(50) NOT NULL,
  `tipocertid_tipo` tinytext NOT NULL,
  `tipocertid_dias` tinyint(4) NOT NULL,
  PRIMARY KEY (`tipocertid_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tipos_doc
DROP TABLE IF EXISTS `tipos_doc`;
CREATE TABLE IF NOT EXISTS `tipos_doc` (
  `tdoc_id` int(11) NOT NULL AUTO_INCREMENT,
  `tdoc_tipo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`tdoc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela que contempla os tipos de docs';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tipos_empresas
DROP TABLE IF EXISTS `tipos_empresas`;
CREATE TABLE IF NOT EXISTS `tipos_empresas` (
  `tipemp_Id` int(11) NOT NULL AUTO_INCREMENT,
  `tipemp_cod` int(11) DEFAULT NULL,
  `tipemp_desc` varchar(50) NOT NULL,
  PRIMARY KEY (`tipemp_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tipos_impostos
DROP TABLE IF EXISTS `tipos_impostos`;
CREATE TABLE IF NOT EXISTS `tipos_impostos` (
  `imp_id` int(11) NOT NULL AUTO_INCREMENT,
  `imp_nome` varchar(50) NOT NULL,
  `imp_desc` varchar(1000) NOT NULL,
  `imp_tipo` varchar(30) NOT NULL,
  `imp_venc` int(11) DEFAULT NULL,
  `imp_mes` int(11) DEFAULT NULL,
  `imp_depto` int(11) NOT NULL,
  `imp_cadpor` int(11) NOT NULL,
  `imp_dtcad` datetime NOT NULL,
  `imp_ativo` int(11) NOT NULL,
  `imp_regra` varchar(50) DEFAULT NULL,
  `imp_tdocId` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`imp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tipos_obs
DROP TABLE IF EXISTS `tipos_obs`;
CREATE TABLE IF NOT EXISTS `tipos_obs` (
  `tipobs_id` int(11) NOT NULL AUTO_INCREMENT,
  `tipobs_desc` varchar(50) NOT NULL,
  PRIMARY KEY (`tipobs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tipo_serv
DROP TABLE IF EXISTS `tipo_serv`;
CREATE TABLE IF NOT EXISTS `tipo_serv` (
  `tip_cod` int(11) NOT NULL AUTO_INCREMENT,
  `tip_ser_id` int(11) NOT NULL DEFAULT '0',
  `tip_serv` varchar(100) NOT NULL DEFAULT '0',
  `tip_desc` varchar(1000) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tip_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela de tipos de serviços.\r\nUtiliza ser_id da tabela services para link de categoria';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.trata_arquivos
DROP TABLE IF EXISTS `trata_arquivos`;
CREATE TABLE IF NOT EXISTS `trata_arquivos` (
  `trata_id` int(11) NOT NULL AUTO_INCREMENT,
  `trata_cliarqEmp` int(11) NOT NULL,
  `trata_cliarqarqid` int(11) NOT NULL,
  `trata_competencia` varchar(7) NOT NULL,
  `trata_mov` int(11) NOT NULL,
  `trata_movpor` int(11) NOT NULL,
  `trata_movdata` datetime NOT NULL,
  `trata_resp` int(11) NOT NULL COMMENT 'Keep the current responsible',
  `trata_finpor` int(11) NOT NULL COMMENT 'Keep the person who finished the treatment',
  `trata_status` int(11) DEFAULT NULL,
  `trata_stdata` datetime NOT NULL,
  `trata_erro` int(11) NOT NULL,
  PRIMARY KEY (`trata_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='This table keeps the information of each file treated by either the importer (employee which is responsible to make the import or the owner, who is responsible to close the company)';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.trata_arquivos_obs
DROP TABLE IF EXISTS `trata_arquivos_obs`;
CREATE TABLE IF NOT EXISTS `trata_arquivos_obs` (
  `traobs_id` int(11) NOT NULL AUTO_INCREMENT,
  `traobs_trataId` int(11) NOT NULL,
  `traobs_usuario` int(11) NOT NULL,
  `traobs_data` datetime DEFAULT NULL,
  `traobs_dt` date DEFAULT NULL,
  `traobs_obs` varchar(1000) NOT NULL,
  PRIMARY KEY (`traobs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tributos
DROP TABLE IF EXISTS `tributos`;
CREATE TABLE IF NOT EXISTS `tributos` (
  `tr_id` int(11) NOT NULL AUTO_INCREMENT,
  `tr_cod` int(11) NOT NULL,
  `tr_titulo` int(11) NOT NULL,
  `tr_depto` int(11) NOT NULL,
  `tr_ativo` int(11) NOT NULL,
  PRIMARY KEY (`tr_id`),
  KEY `FkTrDpeto` (`tr_depto`),
  CONSTRAINT `FkTrDpeto` FOREIGN KEY (`tr_depto`) REFERENCES `departamentos` (`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tri_clientes
DROP TABLE IF EXISTS `tri_clientes`;
CREATE TABLE IF NOT EXISTS `tri_clientes` (
  `cod` int(11) NOT NULL,
  `cnpj` varchar(18) DEFAULT NULL,
  `apelido` varchar(50) DEFAULT NULL,
  `cnae` varchar(10) DEFAULT NULL,
  `cpr` varchar(4) DEFAULT NULL,
  `inscr` varchar(15) DEFAULT NULL,
  `empresa` varchar(100) DEFAULT NULL,
  `obs` varchar(300) DEFAULT NULL,
  `regiao` varchar(50) DEFAULT NULL,
  `responsavel` varchar(40) DEFAULT NULL,
  `tipo_emp` int(11) DEFAULT NULL,
  `num_emp` int(11) DEFAULT '0',
  `email` text,
  `site` varchar(200) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `tribut` varchar(25) DEFAULT NULL,
  `carteira` varchar(300) DEFAULT ' {"1":{"user":"","data":""},"2":{"user":"","data":""},"4":{"user":"","data":""}}',
  `ativo` int(11) DEFAULT '1',
  `uda` int(11) DEFAULT '0',
  `malote` int(11) DEFAULT '0',
  `mail` int(11) DEFAULT '0',
  `emp_vinculo` int(11) DEFAULT NULL,
  `emp_inicio` date DEFAULT NULL,
  `emp_nire` varchar(15) DEFAULT NULL,
  `emp_inscmun` varchar(15) DEFAULT NULL,
  `emp_capital` float DEFAULT NULL,
  `emp_integraliza` varchar(50) DEFAULT NULL,
  `emp_usamalote` tinyint(4) DEFAULT NULL,
  `emp_usarevista` tinyint(4) DEFAULT NULL,
  `emp_datajucesp` date DEFAULT '0000-00-00',
  `emp_logradouro` varchar(200) DEFAULT NULL,
  `emp_numero` smallint(6) DEFAULT NULL,
  `emp_complemento` varchar(20) DEFAULT NULL,
  `emp_bairro` varchar(30) DEFAULT NULL,
  `emp_cidade` varchar(30) DEFAULT NULL,
  `emp_uf` varchar(2) DEFAULT NULL,
  `emp_cep` varchar(8) DEFAULT NULL,
  `emp_atividades` varchar(100) DEFAULT NULL,
  `emp_dataie` date DEFAULT '0000-00-00',
  `emp_dataim` date DEFAULT '0000-00-00',
  `emp_datacnpj` date DEFAULT '0000-00-00',
  `emp_datatrib` date DEFAULT '0000-00-00',
  `emp_dificult` tinyint(4) DEFAULT NULL,
  `emp_usaca` tinyint(4) DEFAULT NULL,
  `emp_capor` tinyint(4) DEFAULT NULL,
  `emp_prioridade` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`cod`),
  KEY `cod` (`cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela de Clientes para o projeto Triangulo';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tri_ligac
DROP TABLE IF EXISTS `tri_ligac`;
CREATE TABLE IF NOT EXISTS `tri_ligac` (
  `sol_cod` int(11) NOT NULL AUTO_INCREMENT,
  `sol_data` timestamp NULL DEFAULT NULL,
  `sol_datareal` timestamp NULL DEFAULT NULL,
  `sol_emp` varchar(50) CHARACTER SET latin1 DEFAULT '0',
  `sol_tel` varchar(15) CHARACTER SET latin1 DEFAULT '0',
  `sol_empcod` smallint(6) DEFAULT '0',
  `sol_cont` varchar(50) CHARACTER SET latin1 DEFAULT '0',
  `sol_fcom` varchar(50) CHARACTER SET latin1 DEFAULT '0',
  `sol_obs` varchar(400) CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `sol_por` varchar(50) CHARACTER SET latin1 DEFAULT '0',
  `sol_status` varchar(50) CHARACTER SET latin1 DEFAULT '0',
  `sol_real_por` varchar(50) CHARACTER SET latin1 DEFAULT '0',
  `sol_pres` int(11) DEFAULT NULL,
  PRIMARY KEY (`sol_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.tri_solic
DROP TABLE IF EXISTS `tri_solic`;
CREATE TABLE IF NOT EXISTS `tri_solic` (
  `sol_cod` int(11) NOT NULL AUTO_INCREMENT,
  `sol_data` timestamp NULL DEFAULT NULL,
  `sol_datareal` timestamp NULL DEFAULT NULL,
  `sol_emp` varchar(50) DEFAULT '0',
  `sol_empcod` smallint(6) DEFAULT '0',
  `sol_tel` varchar(15) DEFAULT '0',
  `sol_cont` varchar(50) DEFAULT '0',
  `sol_fcom` varchar(50) DEFAULT '0',
  `sol_obs` varchar(400) NOT NULL DEFAULT '0',
  `sol_por` int(11) DEFAULT '0',
  `sol_status` int(11) DEFAULT '0',
  `sol_real_por` int(11) DEFAULT '0',
  PRIMARY KEY (`sol_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Solicitações de Contatos Externos';

-- Exportação de dados foi desmarcado.
-- Copiando estrutura para tabela priore_sys.usuarios
DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `usu_cod` int(11) NOT NULL AUTO_INCREMENT,
  `usu_nome` varchar(100) DEFAULT '0',
  `usu_senha` varchar(80) DEFAULT '0',
  `usu_cpf` varchar(14) DEFAULT '0',
  `usu_emp_cnpj` varchar(18) DEFAULT '0',
  `usu_empcod` tinyint(4) DEFAULT '0',
  `usu_classe` tinyint(4) DEFAULT '0',
  `usu_email` varchar(200) DEFAULT '0',
  `usu_ativo` enum('0','1') DEFAULT '0',
  `usu_dep` varchar(50) DEFAULT '0',
  `usu_horario` int(11) DEFAULT '1',
  `usu_lider` enum('Y','N') DEFAULT 'N',
  `usu_ramal` varchar(5) DEFAULT 'N',
  `usu_pausa` varchar(30) DEFAULT NULL,
  `usu_foto` varchar(150) DEFAULT '0',
  `usu_sign` varchar(150) DEFAULT NULL,
  `usu_empresas` varchar(100) DEFAULT '0',
  `usu_contagens` text,
  PRIMARY KEY (`usu_cod`),
  KEY `usu_cod` (`usu_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Armazena usuarios do sistema';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
