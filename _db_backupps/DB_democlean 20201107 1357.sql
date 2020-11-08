-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.1.72-community-log


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema vboss_democlean
--

CREATE DATABASE IF NOT EXISTS vboss_democlean;
USE vboss_democlean;

--
-- Definition of table `account_service`
--

DROP TABLE IF EXISTS `account_service`;
CREATE TABLE `account_service` (
  `COD_ACCOUNT_SERVICE` int(10) NOT NULL AUTO_INCREMENT,
  `GRUPO` varchar(80) DEFAULT NULL,
  `TIPO` varchar(20) DEFAULT NULL,
  `FORNECEDOR` varchar(80) DEFAULT NULL,
  `CONTA_USR` varchar(250) DEFAULT NULL,
  `CONTA_SENHA` varchar(50) DEFAULT NULL,
  `CONTA_EXTRA1` varchar(50) DEFAULT NULL,
  `CONTA_EXTRA2` varchar(50) DEFAULT NULL,
  `CONTA_EXTRA3` varchar(50) DEFAULT NULL,
  `ENDER_URL` varchar(250) DEFAULT NULL,
  `OBS` longtext,
  `ORDEM` int(10) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DT_INS` datetime DEFAULT NULL,
  `SYS_USR_INS` varchar(50) DEFAULT NULL,
  `SYS_DT_UPD` datetime DEFAULT NULL,
  `SYS_USR_UPD` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_ACCOUNT_SERVICE`),
  KEY `DT_INATIVO` (`DT_INATIVO`),
  KEY `FORNECEDOR` (`FORNECEDOR`),
  KEY `GRUPO` (`GRUPO`),
  KEY `TIPO` (`TIPO`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `account_service`
--

/*!40000 ALTER TABLE `account_service` DISABLE KEYS */;
INSERT INTO `account_service` (`COD_ACCOUNT_SERVICE`,`GRUPO`,`TIPO`,`FORNECEDOR`,`CONTA_USR`,`CONTA_SENHA`,`CONTA_EXTRA1`,`CONTA_EXTRA2`,`CONTA_EXTRA3`,`ENDER_URL`,`OBS`,`ORDEM`,`DT_INATIVO`,`SYS_DT_INS`,`SYS_USR_INS`,`SYS_DT_UPD`,`SYS_USR_UPD`) VALUES 
 (54,'FAMILIA','ftp','Locaweb','ftpminhafamilia.com.br','senhaexemplo',NULL,NULL,NULL,'www.minhafamilia.com.br','Exemplo de cadastro de uma conta de serviço do tipo FTP',NULL,NULL,'2007-01-20 00:00:00',NULL,'2010-02-23 00:00:00','_athenas'),
 (55,'FAMILIA','e-mail','Locaweb','pai@minhafamilia.com.br','senhaexemplo','pop.minhafamilia.com.br','smtp.minhafamilia.com.br',NULL,'webmail.minhafamilia.com.br',NULL,NULL,NULL,'2007-01-20 00:00:00',NULL,'2009-05-07 00:00:00','_athenas'),
 (56,'FAMILIA','e-mail','Locaweb','mae@minhafamilia.com.br','senhaexemplo','pop.minhafamilia.com.br','smtp.minhafamilia.com.br',NULL,'webmail.minhafamilia.com.br','alias 1: neusa@minhafamilia.com.br\r\n',NULL,NULL,'2007-01-20 00:00:00',NULL,'2009-05-07 00:00:00','_athenas'),
 (57,'FAMILIA','painel','Locaweb','fillho@minhafamilia.com.br','senhaexemplo','pop.minhafamilia.com.br','smtp.minhafamilia.com.br',NULL,'webmail.minhafamilia.com.br','alias 1: carlos@minhafamilia.com.br',NULL,NULL,'2007-01-20 00:00:00',NULL,'2008-12-19 00:00:00','_athenas');
/*!40000 ALTER TABLE `account_service` ENABLE KEYS */;


--
-- Definition of table `adm_cargo`
--

DROP TABLE IF EXISTS `adm_cargo`;
CREATE TABLE `adm_cargo` (
  `COD_CARGO` int(10) NOT NULL AUTO_INCREMENT,
  `TITULO` varchar(50) DEFAULT NULL,
  `UNIDADE` varchar(250) DEFAULT NULL,
  `DEPARTAMENTO` varchar(250) DEFAULT NULL,
  `SETOR` varchar(250) DEFAULT NULL,
  `SUP_HIERARQUICO` varchar(250) DEFAULT NULL,
  `DESCRICAO` longtext,
  `ATIVIDADES` longtext,
  `QUALIFICACOES` longtext,
  `COMPETENCIAS` longtext,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_ID_USUARIO_ALT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_CARGO`),
  UNIQUE KEY `Index_504F1178_D21A_4435` (`COD_CARGO`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `adm_cargo`
--

/*!40000 ALTER TABLE `adm_cargo` DISABLE KEYS */;
INSERT INTO `adm_cargo` (`COD_CARGO`,`TITULO`,`UNIDADE`,`DEPARTAMENTO`,`SETOR`,`SUP_HIERARQUICO`,`DESCRICAO`,`ATIVIDADES`,`QUALIFICACOES`,`COMPETENCIAS`,`DT_INATIVO`,`SYS_DTT_INS`,`SYS_DTT_ALT`,`SYS_ID_USUARIO_INS`,`SYS_ID_USUARIO_ALT`) VALUES 
 (1,'GERENTE DE PROJETOS','RS','DESENVOLVIMENTO','Projetos/Planejamento','Diretor de Desenvolvimento','<br>Consiste no planejamento, organização, direção e controle dos recursos de uma empresa para um objetivo de relativamente curto prazo que foi estabelecido para a concretização de objetivos específicos;<br>\r\n* PMI (Project Mangement Institute) (2004), define Gestão de Projectos, tão simplesmente, como sendo o processo através do qual se aplicam conhecimentos, capacidades, instrumentos e técnicas às atividades do projeto de forma a satisfazer as necessidades e expectativas dos diversos stakeholders envolvidos no mesmo;<br>','<ul>\r\n<li>Gerencia, planeja e coordena as atividades da área de Sistemas, desenvolvendo estudos sobre viabilidade técnico-econômica, destinados a aplicação e implantação de novos projetos computadorizados, definindo com os usuários suas necessidades e características, elaborando cronogramas de trabalho, definindo linguagem mais adequada, gerando alternativas de montagem dos sistemas, especificação de documentos e controles e testando os sistemas, para avaliar suas funções e aplicações, solucionando as deficiências encontradas. \r\n</li>\r\n<li>Supervisiona a implantação de sistemas e métodos de trabalho, normas e procedimentos, formulários e arranjos físicos, bem como definindo, codificando e testando os programas desenvolvidos. \r\n</li>\r\n<li>Coordena os trabalhos de manutenção dos sistemas já implantados e seus módulos, baseado em seu desempenho e avaliação dos resultados apurados, providenciando processamento das alterações necessárias, a fim de que atendam às novas exigências dos usuários.\r\n</li>\r\n</ul>','<ul>\r\n<li>Escolaridade: 3º completo</li>\r\n<li>Pré-requisito: PMI </li>\r\n<li>Cursos complementares: PMI  </li>\r\n<li>Aperfeiçoamento: MBA em Gestão de Projetos</li>\r\n<li>Tempo Experiência : 6 a 8 anos na área software</li>\r\n<li>Maturação: 6 meses</li>\r\n</ul>','GP, LD, SV, RH, IP, RE, CE, PL, CR, CQ',NULL,'2010-01-26 00:00:00','2011-11-04 14:52:56','wqertqwer','aless'),
 (2,'COORDENADOR DE EQUIPE','RS','DESENVOLVIMENTO','Projetos/Operacional','Gerente de Projetos','<br>Consiste no planejamento, organização, direção e controle das equipes e sua disponibilidade em cada projeto. Verificação do rendimento, ajustes, conferência dos prazos e motivação de pessoal; <br><br>\r\nAferição constante de tempo previsto X realizado para tarefas de desenvolvimento. Controle de qualidade do serviço e avaliação de rendimento do pessoal;\r\n','<br><li> Coordenação, controle e validação do andamento e desempenho da equipe quando da execução de tarefas de projetos ligadas ao desenvolvimento de sistemas. \r\n<br><li> Experiência na área de desenvolvimento para avaliar e qualificar requisitos mínimos de rendimento da equipe de programação.\r\n<br><li> Gestão dos processos de desenvolvimento, erros e correções, re-alocação de recursos humanos e avaliação de tempo quando da execução de não conformidades X novas requisições X disponibilidade de pessoal.   \r\n<br>','<br><li> Escolaridade: 3º completo\r\n<br><li> Cursos complementares\r\n<br><li> Pré-requisito: Sólidos conhecimentos de programação e DB\r\n<br><li> Aperfeiçoamento: PMI, MBA em Gestão de Processos e/ou Projetos\r\n<br><li> Tempo Experiência: de 5 anos na área de desenvolvimento\r\n<br><li> Maturação: 6 meses<br>','LD, SV, RH, IP, CE, PL, CR',NULL,'2011-11-04 11:47:17','2011-11-04 14:54:16','tatiana','tatiana'),
 (3,'PROGRAMADOR SÊNIOR/PLENO','RS','DESENVOLVIMENTO','Operacional','Coordenador de Equipe','<br>O cargo necessita uma vasta experiência em desenvolvimento de software de diversas áreas, tipos e plataformas. Domina os conceitos e abstrações necessárias a diversos tipos de aplicações e casos.<br>','<br><li> Auxilio constante no processo de desenvolvimento gerando alternativas e remodelando interfaces, estrutura de banco e tudo mais que se faça necessário para o atendimento dos requisitos zelando pela estrutura final do produto. \r\n<br><li> Audita organização de códigos, estruturas e técnicas de programação utilizada, responsável pela qualidade interna do desenvolvimento.\r\n<br><li> Qualifica e classifica conformidades, determina padrões e exceções para desenvolvimento, variáveis, funções objetos e métodos no desenvolvimento de sistemas em geral na empresa.   \r\n<br>','<br><li> Escolaridade: 3º em curso\r\n<br><li> Pré-requisito: Sólidos conhecimentos de programação e DB \r\n<br><li> Aperfeiçoamento: PMI, MBA em Gestão de Processos e/ou Projetos\r\n<br><li> Tempo Experiência: de 10 anos na área de desenvolvimento\r\n<br><li> Maturação: 6 meses\r\n<br>\r\n','SV, RH, IP, RE, CE, CR, CQ',NULL,'2011-11-04 11:51:33','2011-11-04 14:54:37','tatiana','tatiana'),
 (4,'PROGRAMADOR Web/Desk TL','RS','DESENVOLVIMENTO','Operacional','Coord. de Equipe ou Progr. Sênior/Pleno','<br>Programador líder. Além das atividades do cargo relativo a programação irá liderar equipes de programadores, supervisionar suas atividades das equipes técnicas em apoio ao coordenador de equipe, visando assegurar que todas as atividades sejam executadas dentro das normas e políticas estabelecidas pela empresa, fazendo cumprir os cronogramas acordados e a satisfação do cliente. <br>','<br><li> Liderança de equipe em execução de tarefas de programação. Tomada de decisões lógicas e funcionais assumindo a responsabilidade perante as mesmas e por suas apresentação a coordenadoria ou gerencia de projetos. \r\n<br><li> Responsável pela clareza dos códigos gerados pela equipe, garantia do uso dos padrões estabelecidos pela empresa ou projeto. Na ausência do Coordenador de Equipe, assume as funções e responsabilidades.\r\n<br><li> Desenvolvimento de software segundo as atividade dos demais cargos de programação.   \r\n<br>','<br><li> Escolaridade: 3º em curso\r\n<br><li> Pré-requisito: Sólidos conhecimentos de programação e DB \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo Experiência: de 2 anos na área de desenvolvimento\r\n<br><li>Maturação: De 6 a 8 meses\r\n<br>','SV, RH, IP, RE, CE, CR, CQ',NULL,'2011-11-04 12:01:53','2011-11-04 14:55:04','tatiana','tatiana'),
 (5,'PROGRAMADOR Web/Desk I, II, III','RS','DESENVOLVIMENTO','Operacional','Progr. Sênior/Pleno ou Progr. Web/Desk TL','<br>Proceder a codificação dos programas de computador, estudando os objetivos propostos, analisando as características dos dados de entrada e o processamento necessário a obtenção dos dados de saída desejados. <br>','<br><li> Executar a compilação de linguagens de programação, visando conferir e acertar sintaxe do programa.\r\n<br><li> Realizar testes em condições operacionais simuladas, visando verificar se o programa executa corretamente dentro do especificado e com a performance adequada.\r\n<br><li> Modificar programas, alterando o processamento, a codificação e demais elementos, visando corrigir falhas e/ou atender alterações de sistemas e necessidades novas.\r\n<br><li> Aperfeiçoar conhecimentos técnicos, através de pesquisas, estudo de manuais e participação em cursos, visando a otimização da utilização dos recursos disponíveis na empresa.\r\n<br><li> Realizar simulações e criar ambientes de produção a fim de aferir os resultados dos programas.\r\n<br><li> Criar documentações complementares, como \"helps\", instruções de operação ou de acertos de consistência.\r\n<br>','<br><li> Escolaridade	3º em curso\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo Experiência: de 1, 2 e 3 anos na área de desenvolvimento\r\n<br><li> Maturação: De 6 a 8 meses\r\n<br>','SV, RH, IP, RE, CE, CR, CQ',NULL,'2011-11-04 12:05:09','2011-11-04 14:54:57','tatiana','tatiana'),
 (6,'PROGRAMADOR SQL BÀSICO','RS','DESENVOLVIMENTO','Operacional','Ger. Projetos / Coord. Equipe / Progr. SQL -DBA','<br>Proceder a codificação de programas de computador em linguagem PL/SQL (metadata – scheme), estudando os objetivos propostos e implicações, otimização de processos, consultas e fluxo de regras de negócios, analisando as características dos dados de entrada e o processamento necessário a obtenção dos dados de saída desejados. <br>','<br><li> Modelagem de Banco de dados Relacional. Sólidos conhecimentos sobre o processo envolvendo ‘metadata’ – storedprocedures, triggers e eventos envolvidos. \r\n<br><li> Executar a compilação de dos metadatas e garantir a organização e propagação das mudanças executadas em cada banco de um mesmo produto ou kernel. Linguagens de programação, visando conferir e acertar sintaxe do programa.\r\n<br><li> Realizar testes em condições operacionais simuladas, visando verificar se o programa PL/SQL – stored procedure, trigger, etc... executa corretamente dentro do especificado e com a performance adequada.\r\n<br><li> Modificar programas PL/SQL, alterando o processamento, a codificação e demais elementos, visando corrigir falhas e/ou atender alterações de sistemas e necessidades novas.\r\n<br><li> Aperfeiçoar conhecimentos técnicos, através de pesquisas, estudo de manuais e participação em cursos, visando a otimização da utilização dos recursos disponíveis na empresa.\r\n<br><li> Realizar simulações e criar ambientes de produção a fim de aferir os resultados dos programas.\r\n<br><li> Criar documentações complementares, como \"helps\", instruções de operação ou de acertos de consistência, regras de negócios d cada banco e/ou cliente.\r\n<br>','<br><li> Escolaridade	3º em curso\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo	Experiência: de 3 anos na área de desenvolvimento – sólidos conhecimentos de SQL\r\n<br><li> Maturação: De 6 a 8 meses\r\n<br>','SV, RH, IP, RE, CE, CR, CQ',NULL,'2011-11-04 12:07:45','2011-11-04 14:54:44','tatiana','tatiana'),
 (7,'PROGRAMADOR SQL PLENO-DBA','RS','DESENVOLVIMENTO','Operacional','Gerente de Projetos / Coordenador de Equipe','Administração de Bancos de Dados, processos de backup/restore, replicações, otimizações e organização. Proceder a codificação de programas de computador em linguagem PL/SQL (metadata – scheme), estudando os objetivos propostos e implicações, otimização de processos, consultas e fluxo de regras de negócios. \r\n','<br><li> Administração geral de Bancos de Dados. \r\n<br><li> Configuração de servidores, avaliação de atualizações de servidores de BD, upgrades. Análise de impacto de mudanças e manutenção de padrões ISO/ANSI.\r\n<br><li> Criação/Manutenção de rotinas de replicação, segurança e backup/restore de múltiplas base de dados. Migração de BD, modelagem de BD Relacional. Manipulação de ‘metadata’ – stored procedures, triggers e eventos envolvidos. \r\n<br><li> Executar a compilação de dos metadatas e garantir a organização e propagação das mudanças executadas em cada banco de um mesmo produto ou kernel. Linguagens de programação, visando conferir e acertar sintaxe do programa.\r\n<br><li> Realizar testes em condições operacionais simuladas, visando verificar se o programa PL/SQL – stored procedure, trigger, etc... executa corretamente dentro do especificado e com a performance adequada.\r\n<br><li> Modificar programas PL/SQL, alterando o processamento, a codificação e demais elementos, visando corrigir falhas e/ou atender alterações de sistemas e necessidades novas.\r\n<br><li> Supervisionar operações de programadores SQL I e realizar simulações e criar ambientes de produção a fim de aferir os resultados dos programas.\r\n<br><li> Criar documentações complementares, como \"helps\", instruções de operação ou de acertos de consistência, regras de negócios d cada banco e/ou cliente.\r\n<br>','<br><li> Escolaridade: 3º em curso\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo	Experiência: 5 anos na área de desenvolvimento – sólidos conhecimentos de SQL\r\n<br><li> Maturação: De 6 a 8 meses\r\n<br>\r\n','SV, RH, IP, RE, CE, CR, CQ',NULL,'2011-11-04 12:11:21','2011-11-04 14:54:51','tatiana','tatiana'),
 (8,'ANALISTA DE REQUISITOS','RS','DESENVOLVIMENTO','Operacional','Programador SQL - DBA','Levantamento e análise de requisitos de software. Definição de escopo e funcionalidade do software ou de partes dele. Elaboração de especificações funcionais, de manuais de orientação ao usuário. Esclarecimentos funcionais dos produtos do GRUPO PROEVENTO.  Necessária experiência em elaboração de manuais de orientação ao usuário. \r\n','<br><li> Análise de requisitos de software com o cliente ou modelagem de necessidades de mercado. \r\n<br><li> Avaliação de cada demanda/requisito e suas implicações lógicas e funcionais sobre o projeto ou produto como um todo e então proceder a elaboração de documentos de modelagem de requisitos, textos e diagramas funcionais.\r\n<br><li> Responsável pela manutenção de documentos relativos ao escopo de projeto e demandas/requisitos levantados, bem como das regras de negócio pré-existentes de cada produto.\r\n<br><li> Aprimorar-se e adquirir sólidos conhecimentos e experiência nos processos de desenvolvimento de software da empresa. – Deve ser capaz de, através do estudo dos frameworks/kernels existentes, confrontar as demandas/requisitos buscando a solução mais otimizada e natural em relação as difer3ntes especificidades dos framework existentes e sua melhor adequação aos requisitos envolvidos. \r\n<br><li> Criar documentações complementares, como \"helps\", instruções de operação ou de acertos de consistência, regras de negócios de cada sistema e/ou cliente.\r\n<br><li> Responsável por manter toda a documentação de requisitos, “confrontamento” com as possibilidades, anuência dos stakeholders e equipe de desenvolvimento.\r\n<br>','<br><li> Escolaridade: 3º em curso \r\n<br><li> Pré-requisito: Superior em Ciências da Computação, Análise de Sistemas, Tecnologia da Informação\r\n<br><li> Aperfeiçoamento:  \r\n<br><li> Tempo Experiência: 5 anos na área de desenvolvimento – sólidos conhecimentos de SQL\r\n<br><li> Maturação: De 6 a 8 meses\r\n','SV, RH, IP, RE, CE, CR, CQ<br>\r\nSerá um diferencial o conhecimento da área contábil e fiscal voltada para a área de TI.',NULL,'2011-11-04 12:13:37','2011-11-04 14:54:04','tatiana','tatiana'),
 (9,'ENGENHEIRO DE TESTES','RS','DESENVOLVIMENTO','Projetos/Planejamento','Gerente de Projetos / Coordenador de Equipe','O engenheiro (ou arquiteto) de teste é o técnico responsável pelo levantamento de necessidades relacionadas à montagem da infraestrutura de teste, incluindo-se o ambiente de teste, a arquitetura de solução, as restrições tecnológicas, as ferramentas de teste. É também responsável pela elaboração do Plano de Testes, pela liderança técnica do trabalho de teste e pela comunicação entre a equipe de teste e a equipe de projeto (ou equipe de desenvolvimento).\r\n','<br><li> Elaboração de planos de teste e coordenação da execução dos testes e documentos envolvidos.\r\n<br><li> Gestão da qualidade de software e confronto a norma ISO 9126 - funcionalidade, confiabilidade, usabilidade, eficiência, manutenibilidade e portabilidade. \r\n<br><li> De forma geral, mensurar o bom funcionamento do software, o que envolve compará-lo com elementos como especificações, outros softwares da mesma linha, versões anteriores do mesmo produto, inferências pessoais, expectativas do cliente, normas relevantes, leis aplicáveis, entre outros. \r\n(enquanto a especificação do software diz respeito ao processo de verificação do software, a expectativa do cliente diz respeito ao processo de validação do software).\r\n<br><li> Aplicação/ Implantação de técnicas de teste funcionais - como Caixa Branca, Caixa Preta, Caixa Cinza, Regressão e não funcionais.  Aplicação de testes de unidade, teste de integração, teste de sistema, teste de aceitação, teste de operação, teste alfa/beta e teste RC.\r\n<br><li> * na empresa usamos o princípio de programação XP, desta forma  o engenheiro de teste deve estar ligado diretamente ao desenvolvimento.\r\n','<br><li> Escolaridade: 3º em curso\r\n<br><li> Pré-requisito: Curso na área de TI\r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo Experiência: de 1 ano na área de desenvolvimento\r\n<br><li> Maturação: 6 meses\r\n','SV, RH, IP, RE, CE, CR, CQ',NULL,'2011-11-04 12:16:03','2011-11-04 14:54:29','tatiana','tatiana'),
 (10,'DESIGN WEB / INTERFACE','RS','DESENVOLVIMENTO','Projetos/Planejamento','Gerente de Projetos / Coordenador de Equipe','Desenvolvimento gráfico, design e layout geral de materiais, documentos, identidade visual e interface de sistemas.\r\n','<br><li> Elaboração de planos de interface de software, desenho de telas de sistemas e projetos para análise funcional.\r\n<br><li> Identidade visual – da empresa ou de clientes (produtos, documentos, logomarcas, cartões, etc...)\r\n<br><li> Ergonomia de Software – avaliação e manutenção de padrões de interface de software, aplicações desktop ou web.\r\n<br><li> Web Design – desenvolvimento web, campanhas, animações, etc...\r\n<br><li> Responsável pela gestão e organização de todo material gráfico (digital ou não) da empresa e de clientes.\r\n','<br><li> Escolaridade: 3º em curso\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo	Experiência: de 2 anos na área de TI\r\n<br><li> Maturação: 6 meses\r\n','SV, RH, IP, RE, CE, CR, CQ',NULL,'2011-11-04 12:17:56','2011-11-04 14:54:24','tatiana','tatiana'),
 (11,'TESTER','RS','DESENVOLVIMENTO','Projetos/Planejamento','Engenheiro de Teste / Coordenador de Equipe','Técnico responsável pela execução dos testes (execução do plano de testes elaborado pelo engenheiro de teste). No caso de programação XP o tester trabalha junto ao programador executando os testes de unidade.\r\n','<br><li> O testador é o técnico responsável pela execução de teste. \r\n<br><li> Ele deve observar as condições de teste e respectivos passos de teste documentados pelo engenheiro ou analista de teste e evidenciar os resultados de execução. \r\n<br><li> Em casos de execuções de teste mal-sucedidas, esse profissional pode também registrar ocorrências de teste (na maioria das vezes, bugs) em canais através dos quais os desenvolvedores tomarão conhecimento das mesmas e tomarão as providências de correção ou de esclarecimentos.\r\n<br><li> Elaboração e manipulação de documentos (artefatos) de teste.\r\n<br>','<br><li> Escolaridade: 2º completo\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo	Experiência: de 2 anos na área de TI	\r\n<br><li> Maturação: 6 meses\r\n','SV, IP, RE, CE, CR, CQ',NULL,'2011-11-04 12:19:45','2011-11-04 14:55:10','tatiana','tatiana'),
 (12,'ATENDIMENTO Pleno e Básico','RS','SUPORTE / ATENDIMENTO','Suporte/Atendimento','Coordenador de Equipe / Diretor','Atendimento a clientes (pós-venda), treinamento, suporte inicial/configurações e operações de plataforma em geral. Triagem inicial de chamados, manutenção de atendimento a clientes (controle dos chamados, ligações, estatísticas,  e-mails, documentações, etc...)\r\n','<br><li> O profissional de Atendimento é responsável pelo treinamento a clientes sobre as ferramentas e serviços comercializados pela empresa. \r\n<br><li> Criar, manter e redigir relatórios de atendimento com fins a “fedback” para o departamento comercial. \r\n<br><li> Antecipar ações e contatos, junto ao cliente. Postura pro-ativa e antecipação de ações em datas comemorativas ou especiais para o cliente.\r\n<br><li> Abrir portas para o departamento comercial, pois deve muni-lo com informações relevantes de cada cliente, estando atento e registrando contatos e atendimentos. Antecipar novas necessidades do cliente e fazer a ligação com produtos e serviços da empresa promovendo uma nova venda.\r\n<br><li> Conhecer e manter relações com os clientes, mantendo histórico dos contatos e conversas anteriores\r\n<br><li> Gerar indicadores para avaliar qualidade do atendimento no geral ao cliente  (suporte,  técnico, etc...  - criar e manter ferramentas para avaliar nivel de satisfação do cliente em diversas áreas, tempo de resposta, etc.. - Elaboração e manipulação de documentos, planilhas, e-mails, etc...\r\n<br><li> Efetuar tarefas de pós-venda e visita a clientes\r\n<br><li> Pode ser requisitado eventualmente para execução de testes em sistemas/produtos fornecidos pela empresa \r\n','<br><li> Escolaridade	2º completo\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo	Experiência: de 2 anos na área de TI	\r\n<br><li> Maturação: 6 meses\r\n','LD, SV, AP, RH, IP, CE, CR <br>\r\nBoa apresentação, ser articulado, clareza de ideias, organizado, prática em uso de ferramentas Office/OpenOffice\r\n',NULL,'2011-11-04 12:25:52','2011-11-04 14:57:58','tatiana','tatiana'),
 (13,'SUPORTE BÁSICO','RS','SUPORTE / ATENDIMENTO','Suporte/Atendimento','Coordenador de Equipe / Diretor','Atendimento técnico a clientes internos e externos, treinamento da equipe de atendimento, suporte ao uso e configuração dos sistemas/produtos. Triagem secundária de chamados, \r\n','<br><li> Responsável pelo domínio de operação e regras de negócio de todos os produtos e serviços da empresa. \r\n<br><li> Capacidade de prestar treinamento e suporte para equipe interna e externa. Responsável pelo treinamento do profissional de Atendimento, que deverá efetuar treinamento ao cliente. *O profissional de suporte pode ser solicitado a realizar treinamento a clientes, mas sua função relativa a treinamento é a de treinamento  interno.\r\n<br><li> Adequar o uso das ferramentas a vários cenários propostos pelo cliente e/ou situações diversas.\r\n<br><li> Atendimento ao SAC/CHAMADOS e capacidade de triagem de requisições ao dep. técnico ou outra área como comercial e/ou diretoria. Capacidade de identificação de demandas e requisitos, diferenciação básica entre atualizações, problemas, dúvidas e sugestões. \r\n<br><li> Realizar a manualização dos produtos/serviços, bem como a manutenção dos documentos, revisões e atualizações necessárias.\r\n<br><li> Gerar indicadores para avaliar qualidade do atendimento no geral ao cliente  (suporte,  técnico, etc...  - criar e manter ferramentas para avaliar nível de satisfação do cliente em diversas áreas, tempo de resposta, etc.. - Elaboração e manipulação de documentos, planilhas, e-mails, etc...\r\n<br><li> Eventual atendimento telefônico.\r\n<br><li> Pode ser requisitado eventualmente para execução de testes em sistemas/produtos fornecidos pela empresa\r\n','<br><li> Escolaridade	2º completo\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: Desejável curso técnico de TI ou Superior Incompleto\r\n<br><li> Tempo	Experiência: de 2 anos na área de TI	\r\n<br><li> Maturação: 6 meses\r\n','LD, SV, AP, RH, IP, CE, CR<br>\r\nClareza de ideias, organizado, pro-ativo\r\n',NULL,'2011-11-04 12:28:29','2011-11-04 14:56:56','tatiana','tatiana'),
 (14,'SUPORTE PLENO','RS','SUPORTE / ATENDIMENTO','Suporte/Atendimento','Coordenador de Equipe / Diretor','Atendimento técnico a clientes internos e externos, treinamento da equipe de atendimento, suporte ao uso e configuração dos sistemas/produtos. Triagem secundária de chamados, \r\n','<br><li> Disponibilidade para realização de todas as atividades correspondentes ao cargo de SUPORTE BÁSICO. \r\n<br><li> Gestão e controle de todos só cenários aplicados a cada cliente no uso de um ou mais produtos/serviços da empresa.\r\n<br><li> Gerar indicadores para avaliar qualidade do atendimento no geral ao cliente  (suporte,  técnico, etc...  - criar e manter ferramentas para avaliar nível de satisfação do cliente em diversas áreas, tempo de resposta, etc.. - Elaboração e manipulação de documentos, planilhas, e-mails, etc...\r\n<br><li> Gestão da manualização e regras de negócio aplicadas a cada produto x cliente.\r\n<br><li> Análise de requisitos de clientes, triagem para comercial ou desenvolvimento e elaboração de documento formalizando requisição de cliente quando necessária e fora do escopo de chamado (novas implementações).\r\n','<br<<li> Escolaridade: 3º grau completo\r\n<br<<li> Pré-requisito: \r\n<br<<li> Aperfeiçoamento: Desejável curso técnico de TI\r\n<br<<li> Tempo	Experiência: de 2 anos na área de TI\r\n<br<<li> Maturação: 6 meses\r\n','LD, SV, AP, RH, IP, CE, CR<br>\r\nLiderança, clareza de ideias, organizado, pro-atividade',NULL,'2011-11-04 12:35:03','2011-11-04 14:56:17','tatiana','tatiana'),
 (15,'TÉCNICO BÁSICO','RS','SUPORTE / ATENDIMENTO','Tecnologia e Configuração','Coordenador de Equipe / Diretor','Execução técnica de operações e configurações de hardware/software e elementos de infra-estrutura de TI. \r\n','<br><li> Instalação e configuração lógica e física de redes de computador. \r\n<br><li> Instalação de software e hardware.\r\n<br><li> Execução de backups.\r\n<br><li> Manutenção preventiva e corretiva de hardware\r\n<br><li> Eventual atendimento telefônico.\r\n<br><li> Pode ser requisitado eventualmente para execução de testes em sistemas/produtos fornecidos pela empresa\r\n','<br><li> Escolaridade: 3º grau completo\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: Desejável curso técnico de TI\r\n<br><li> Tempo	Experiência: de 2 anos na área de TI\r\n<br><li> Maturação: 6 meses\r\n','LD, SV, AP, RH, IB, CE, CR<br>\r\nLiderança, clareza de ideias, organizado, pro-atividade\r\n',NULL,'2011-11-04 12:36:54','2011-11-04 14:56:32','tatiana','tatiana'),
 (16,'TÉCNICO PLENO','RS','SUPORTE / ATENDIMENTO','Tecnologia e Configuração','Coordenador de Equipe / Diretor','Execução técnica, controle e gestão de operações e configurações de hardware/software e elementos de infra-estrutura de TI. ','<br><li> Disponibilidade para realização de todas as atividades correspondentes ao cargo de TÈCNICO BÁSICO.\r\n<br><li> Planejamento de redes (física, lógica, topologia, etc...)\r\n<br><li> Controle de inventário e especificação de hardware\r\n<br><li> Gestão e organização de backups\r\n<br><li> Gestão da manutenção preventiva e corretiva de hardware\r\n<br><li> Responsável por montagem da estratégia e execução das políticas de segurança de rede\r\n<br><li> Gerenciamento e configuração de servidores e usuários de rede\r\n<br><li> Pesquisa e desenvolvimento de novas tecnologias\r\n','<br><li> Escolaridade: 3º grau completo\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: Desejável curso técnico de TI\r\n<br><li> Tempo	Experiência: de 2 anos na área de TI	\r\n<br><li> Maturação: 6 meses\r\n','LD, SV, AP, RH, IP, CE, CR<br>\r\nLiderança, clareza de ideias, organizado, pro-atividade\r\n',NULL,'2011-11-04 13:52:41','2011-11-04 14:55:25','tatiana','tatiana'),
 (17,'RECEPCIONISTA','RS','ADMINISTRATIVO / FINANCEIRO','Administrativo','Gerente Administrativo / Diretor Administrativo','Atendimento telefônico, portaria, correspondência (envio, triagem e recebimento), abertura e fechamento da empresa, serviço de copa básico – café, água, etc para clientes e colaboradores.\r\n','<br><li> O profissional recepcionista deve zelar pelo bom atendimento e recepção ao indivíduo que venha a ter contato e/ou acesso as dependências da empresa. \r\n<br><li> Criar, manter e redigir listas de contatos a clientes. \r\n<br><li> Envio de mala direta tanto para informativos internos e externos como datas comemorativas gerais e/ou específicas – como feriados regionais, nacionais ou mesmo férias e agendamentos de manutenção de serviços e visitas a cliente. \r\n<br><li> Deve estar ciente da agenda da empresa (ausência de sócios, colaboradores etc...). É responsável pelo devido registro, repasse e captação de recados sejam estes verbais ou telefônicos, internos ou externos.\r\n<br><li> Zelar pela organização das instalações físicas – salas, mesas, banheiros, cozinha.\r\n<br><li> Eventual serviços externos – correios, bancos, supermercado, ferragem, etc...\r\n<br><li> Controle e agendamento de reuniões em geral – sejam externas ou internas, de equipe ou diretoria, etc...\r\n<br><li> Efetuar e receber ligações - anotação e histórico de recados.\r\n','<br><li> Escolaridade: 2º completo\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo Experiência:\r\n<br><li> Maturação: 6 meses\r\n','AP, RH, IP, CE, CR <br>\r\nBoa apresentação, ser articulado, clareza de ideias, organizado, prática em uso de ferramentas WEB (google, agendas, etc...)\r\n',NULL,'2011-11-04 13:54:41','2011-11-04 15:00:38','tatiana','tatiana'),
 (18,'ADMIN. ADJUNTO BÁSICO','RS','ADMINISTRATIVO / FINANCEIRO','Administrativo / RH','Gerente Administrativo / Diretor Administrativo','Relação e andamento do fluxo de trabalho, operações e controle de almoxarifado, folha ponto, manutenção dos manuais e regras de boas práticas e comportamento na empresa, orçamentos e enviar cobrança de inadimplentes.\r\n','<br><li> Uma das responsabilidades do cargo é zelar para o cumprimento das regras de boas práticas e comportamento dentro da empresa. \r\n<br><li> Gerencia/ emitir documentos de cobrança – pedidos, contratos, notas fiscais e boletos.\r\n<br><li> Controle das demandas de almoxarifado, insumos em geral, distribuição de materiais de escritório e controle do inventário de equipamentos e mobiliário. \r\n<br><li> Observação da “Folha Ponto” e apresentação/lembrete dos acertos a serem feitos – zelar para que não se a cumulem horas positivas ou negativas para cada colaborador.\r\n<br><li> Orçamento para compra de materiais e equipamentos\r\n<br><li> Envio e ligações de cobrança ou ajustes financeiros a clientes\r\n<br><li> Eventual serviços de recepcionista - atendimento telefônico, etc...\r\n','<br><li> Escolaridade: 2º completo\r\n<br><li> Cursos complementares 	Pré-requisito: \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo Experiência:\r\n<br><li> Maturação: 6 meses\r\n','AP, RH, IP, CE, CR <br>\r\nBoa apresentação, ser articulado, clareza de ideias, organizado, prática em uso de ferramentas WEB (google, agendas, etc...)\r\n',NULL,'2011-11-04 13:56:56','2011-11-04 14:59:54','tatiana','tatiana'),
 (19,'ADMIN. ADJUNTO PLENO','RS','ADMINISTRATIVO / FINANCEIRO','Administrativo / RH','Gerente Administrativo / Diretor Administrativo','Eventual atendimento telefônico, recrutamento e demissões, endomarketing, Ombudsmann, gerenciamento de benefícios dos colaboradores, contas a pagar e receber, apoio direto ao gerente/diretor administrativo/financeiro na elaboração de relatórios e métricas.','<br><li> Disponibilidade para realização de todas as atividades correspondentes ao cargo de ADMINISTRATIVO ADJUNTO PLENO.\r\n<br><li> Controle (criação, organização e envio) de Mala Direta a clientes – promoções, anúncios, documentação, informativos, etc...\r\n<br><li> Agendamento de contas a pagar e receber\r\n<br><li> Atualização das leis e acordos trabalhistas com o sindicato\r\n<br><li> PQA – Pesquisa de satisfação - aplicação do conceito internamente)\r\n<br><li> Gerenciamento do Manual de Boias práticas – Edição e Ajustes\r\n<br><li> Recrutamento, seleção, demissão e abertura de vagas baseado nas solicitações dos setores.\r\n<br><li> Ombudsmann e controle da central telefônica – auditoria de gastos. Auxiliar a Gerência/Diretoria ana formataçãod e relatórios e previções orçamentárias de longo, médio e curto prazo – para pagamentos e recebimentos.\r\n<br><li> Gerenciamento de fpérias, benefícios e pagamentos de salários\r\n<br><li> Eventual atendimento telefônico\r\n','<br><li> Escolaridade: 2º completo\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo Experiência:\r\n<br><li> Maturação: 6 meses\r\n','SV, AP, RH, IP, CE, CR <br>\r\nBoa apresentação, ser articulado, clareza de ideias, organizado, prática em uso de ferramentas OFFICE e WEB\r\n',NULL,'2011-11-04 13:58:49','2011-11-04 15:00:22','tatiana','tatiana'),
 (20,'COMERCIAL ADJUNTO','SP','COMERCIAL / MARKETING','Comercial/Marketing','Gerente Comercial / Diretor Comercial-Marketing','Cargo responsável a execução de tarefas relativas ao departamento comercial e marketing, com zelo total pela boa relação entre a empresa e o cliente, satisfação, clareza e organização dos serviços/produtos comercializados.\r\n','<br><li> Manutenção dos documentos contratuais (controle e antecipação dos vencimentos e renovações), confecção e gerenciamento das propostas.\r\n<br><li> Auxlilia na execução e formulação de pesquisas de mercado, ações de marketing e divulgação.\r\n<br><li> Projetar a imagem da empresa no mercado, criação e pesquisa de ferramentas nesta área.\r\n<br><li> Elaborar programa de treinamento para equipe de vendas (programas motivacionais)\r\n<br><li> Manter contato com patrocinadores de eventos que envolvam a divulgação do nome da empresa\r\n<br><li> Divulgação da marca, e estratágias de marketing – custos x benefício x aplicabilidade e planejamento\r\n<br><li> Apoio gerencial e execução de tarefas do ADMINISTRATIVO ADJUNTO que remetam ação ao cliente\r\n<br><li> Controle, planejamento e execução de divulgação de marca, produtos e serviços da empresa em mídias sociais e ferramentas atualizadas de mercado.\r\n<br><li> Eventual atendimento telefônico\r\n','<br><li> Escolaridade: 2º completo\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo Experiência:\r\n<br><li> Maturação: 6 meses\r\n','LD, SV, AP, RH, IP, RE, CE, PL, CR, CQ <br>\r\nBoa apresentação, ser articulado, clareza de ideias, organizado, prática em uso de ferramentas de Marketing.\r\n',NULL,'2011-11-04 14:04:35','2011-11-04 14:53:08','tatiana','tatiana'),
 (21,'RELACIONAMENTO CLIENTE','SP','COMERCIAL / MARKETING','Marketing','Gerente Comercial / Diretor Comercial-Marketing','Cargo onde a preocupação esta na ouvidoria ao cliente e antecipação de ações, planejamento e organização para melhor atender e formatar uma percepção positiva da empresa e dos serviços.\r\n','<br><li> Manter contato e relação interpessoal com cliente (datas comemorativas, eventos etc...).\r\n<br><li> Subsidiar os processo de negociação com o cliente.\r\n<br><li> Auxiliar na interpretação e aplicação de PQA – clietne. Identifica os desejos e ecessidades do cliente para que sejam revertidos em ações da empresa ou memso em modificações de valores e ou produtos.\r\n<br><li> Divulgação das versões upgrades e melhorias dos serviços e sistemas, bem como materiais gráficos ou digitais.\r\n<br><li> Orçamento, planejamento e execução de campanhas, brindes, festas, eventos e prol do melhor relacionamento da empresa com o cliente.\r\n','<br><li> Escolaridade: 2º completo\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo Experiência:\r\n<br><li> Maturação: 6 meses\r\n','SV, AP, RH, IP, RE, CE, PL, CR <br>\r\nBoa apresentação, ser articulado, clareza de ideias, organizado, prática em uso de ferramentas de Marketing.\r\n',NULL,'2011-11-04 14:07:56','2011-11-04 14:58:31','tatiana','tatiana'),
 (22,'IMPLANTADOR','SP-RS','COMERCIAL / MARKETING','Comercial / Técnica','Ger. Comercial / Dir. Comercial-Marketing / Ger. Projetos','Preparação da entrega e instalação dos produto junto ao cliente. Trabalha  reorganizando as rotinas no cliente para que as mesmas sejam executadas com o uso da ferramenta. \r\n','<br><li> Visita técinca a cliente, apresentação técnica de produto.\r\n<br><li> Instalação de sistemas e implamtação de rotinas e processos. Capaxidade de síntese e percepção de fluxo e rotinas.\r\n<br><li> Levantamento das adequações de hardware, espaço físico, elétrico, mobiliário e ambiente.\r\n<br><li> Faz o levantamento dos processos do cliente, reorganizando-os e estruturando para uso dentro da lógica apresentada pelo produto a ser implantado.\r\n<br><li> Geração de documentos de implantação descrevendo processo anteriores e processos “como ficarão”.\r\n<br><li> Formador de KEYUSERS – e aplicação dos Manuais de sistema desenvolvidos pela gerência de Atendimento/Suporte. Geração de sugestões e melhorias do material.\r\n<br><li> Possível prospecção de clientes e percepção da possibilidade de venda de novos serviços e ou produtos da empresa.\r\n<br><li> Disponibilidade para viagens e relocação de cidade por períodos de implantação conforme a necessidade do cliente. Eventual atendimento telefônico.\r\n','<br><li> Escolaridade	2º completo\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo	Experiência:\r\n<br><li> Maturação: 6 meses\r\n','V, AP, RH, IP, RE, CE, PL, CR <br>\r\nBoa apresentação, ser articulado, clareza de ideias, organizado, prática em uso de ferramentas TI – Redes, Servidores, SISOP.\r\n',NULL,'2011-11-04 14:09:42','2011-11-04 14:57:13','tatiana','tatiana'),
 (23,'REPRESENTANTE COMERCIAL','SP','COMERCIAL / MARKETING','Comercial / Técnica','Ger. Comercial / Dir. Comercial-Marketing / Ger. Projetos','Preparação da entrega e instalação dos produto junto ao cliente. Trabalha  reorganizando as rotinas no cliente para que as mesmas sejam executadas com o uso da ferramenta. \r\n','<br><li> Proospectar clietnes e efetuar a venda dos produtos do portfolio da empresa de acordo com o plano estratégico de vendas traçado anualmente.\r\n<br><li> Contato inciial, histório e adminstração de negociações tanto para produtos como serviçoes.\r\n<br><li> Análise de mercado em relação a receptividade. Gerar documentos de feedbacks sobre requisitos comuns do mercado prospectado.\r\n<br><li> Habilidade de captação de requisitos – documentação destes requisitos e confrontação com os requisitos atendidos pelos produtos.\r\n<br><li> Possível represetnaçãod a empresa em eventos.\r\n<br><li> Porspectar paceiros de negócios.\r\n<br><li> Geração de documentos de implantação descrevendo processo anteriores e processos “como ficarão”.\r\n<br><li> Possível prospecção de clientes e percepção da possibilidade de venda de novos serviços e ou produtos da empresa.\r\n<br><li> Disponibilidade para viagens e relocação de cidade por períodos de implantação conforme a necessidade do cliente. Eventual atendimento telefônico.\r\n','<br><li> Escolaridade: 2º completo\r\n<br><li> Pré-requisito: \r\n<br><li> Aperfeiçoamento: \r\n<br><li> Tempo	Experiência:\r\n<br><li> Maturação: 6 meses','SV, AP, RH, IP, RE, CE, PL, CR <br>\r\nBoa apresentação, ser articulado, clareza de ideias, organizado, prática em uso de ferramentas TI – Redes, Servidores, SISOP.\r\n',NULL,'2011-11-04 14:20:44','2011-11-04 14:57:40','tatiana','tatiana'),
 (24,'CONSELHO DIRETOR','SP-RS','DIRETORIA',NULL,NULL,'\r\nConselho composto pelos sócios atuantes no grupo, com a responsabilidade de ditar os rumos gerais da empresa, dirigir os negócios e fomentar o planejamento estratégico.','<br><li> Organização do planejamento estratégico, responsabilidade legal e financeira.\r\n<br><li> Direção da empresa, cobranças das gerências e formação do Grupo Supervisor.\r\n<br><li> Planejamento etratégico anual dando rumo as metas que devem ser desenvolvidas pelas gerências.',NULL,NULL,NULL,'2011-11-04 15:01:42',NULL,'tatiana',NULL),
 (25,'GRUPO SUPERVISOR','RS',NULL,NULL,'CONSELHO DIRETOR','Grupo por colaboradores indicados anualmente pelo conselho diretor com a finalidade de auditar as metas de cada departamento e trazer as avaliações, críticas e sugestões a cada gerente sobre o andamento de seu departamento. \r\n','<br><li> Reunião anual com cada GERENTE, auditando as metas, realizações e cobrança das metas a divulgar para o próximo anuário. \r\n<br><li> Responsabildiade de divulgação das metas anuais de cada departamento para os demais colaboradores, assim como a divulgação da avaliação anual individual de cada gerência\r\n<br><li> Criar ferramentas para captação de sugestões, observações e críticas. \r\n<br><li> Agir com seriedade e discrição – todo e qualquer material produzido pelo grupo serpa considerado sigilo, devendo ser apresentado somente em reunião com o respectivo Gerente ou com o próprio Conselho.\r\n','<br>Tempo: Desejado mais de 5 nos e empresa<br>','As pessoas que formam esse grupo devem se candidatar para tal e a substituição pode ser feita por indicação de um membro antigo desde que com o aceite o conselho que pode também retirar ou substituir qualquer membro do grupo sem aviso prévio.<br><br>\r\nSugestão INICIAL (exercício 2012): CLEVEROSN, TATIANA, NETO e THAIS\r\n<br>',NULL,'2011-11-04 15:03:50','2011-11-04 15:06:45','tatiana','tatiana');
/*!40000 ALTER TABLE `adm_cargo` ENABLE KEYS */;


--
-- Definition of table `adm_classe`
--

DROP TABLE IF EXISTS `adm_classe`;
CREATE TABLE `adm_classe` (
  `COD_CLASSE` int(10) NOT NULL AUTO_INCREMENT,
  `ID_CLASSE` varchar(10) DEFAULT NULL,
  `DESCRICAO` varchar(250) DEFAULT NULL,
  `PESO_MIN` int(10) DEFAULT NULL,
  `PESO_MAX` int(10) DEFAULT NULL,
  `PONTOS` int(10) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_ID_USUARIO_ALT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_CLASSE`),
  UNIQUE KEY `Index_77196C48_9AE8_4931` (`COD_CLASSE`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `adm_classe`
--

/*!40000 ALTER TABLE `adm_classe` DISABLE KEYS */;
INSERT INTO `adm_classe` (`COD_CLASSE`,`ID_CLASSE`,`DESCRICAO`,`PESO_MIN`,`PESO_MAX`,`PONTOS`,`DT_INATIVO`,`SYS_DTT_INS`,`SYS_DTT_ALT`,`SYS_ID_USUARIO_INS`,`SYS_ID_USUARIO_ALT`) VALUES 
 (1,'1',NULL,200,214,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (2,'2',NULL,215,230,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (3,'3',NULL,231,247,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (4,'4',NULL,248,265,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (5,'5',NULL,266,284,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (6,'6',NULL,285,304,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (7,'7',NULL,305,326,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (8,'8',NULL,327,350,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (9,'9',NULL,351,375,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (10,'10',NULL,376,402,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (11,'11',NULL,403,431,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (12,'12',NULL,432,463,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (13,'13',NULL,464,496,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (14,'14',NULL,497,532,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (15,'15',NULL,533,571,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (16,'16',NULL,572,612,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (17,'17',NULL,613,656,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (18,'18',NULL,657,704,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (19,'19',NULL,705,755,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (20,'20',NULL,756,809,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (21,'21',NULL,810,868,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (22,'22',NULL,869,930,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (23,'23',NULL,931,998,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (24,'24',NULL,999,1070,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (25,'25',NULL,1071,1148,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (26,'26',NULL,1148,NULL,NULL,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL);
/*!40000 ALTER TABLE `adm_classe` ENABLE KEYS */;


--
-- Definition of table `adm_competencia`
--

DROP TABLE IF EXISTS `adm_competencia`;
CREATE TABLE `adm_competencia` (
  `COD_COMPETENCIA` int(10) NOT NULL AUTO_INCREMENT,
  `SIGLA` varchar(3) DEFAULT NULL,
  `COMPETENCIA` varchar(250) DEFAULT NULL,
  `CONCEITO` longtext,
  `PESO` int(10) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_ID_USUARIO_ALT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_COMPETENCIA`),
  UNIQUE KEY `Index_4E532FA5_AD80_40E6` (`COD_COMPETENCIA`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `adm_competencia`
--

/*!40000 ALTER TABLE `adm_competencia` DISABLE KEYS */;
INSERT INTO `adm_competencia` (`COD_COMPETENCIA`,`SIGLA`,`COMPETENCIA`,`CONCEITO`,`PESO`,`DT_INATIVO`,`SYS_DTT_INS`,`SYS_DTT_ALT`,`SYS_ID_USUARIO_INS`,`SYS_ID_USUARIO_ALT`) VALUES 
 (1,'GP','Gestão de pessoas','Dominar os conceitos e os princípios da gestão de equipes e as ferramentas e procssos de seleção, avaliação, ensino e desenvolvimento de pessoas, de modo a manter um quadro capacitado, motivado e comprometido.',8,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (2,'LD','Liderança','Dominar os conceitos e os princípios e ser capaz de inspirar e estimular pessoas e grupos na realização de missões, atribuir tarefas, acompanhar, orientar e facilitar.',8,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (3,'SV','Supervisão','Dominar o processo de atribuir tarefas, acompanhar, orientar e revisar trabalho.',8,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (4,'AP','Atendimento ao público','Dominar o processo de prestar atendimento eficaz, informar e orientar o público interno e externo de modo a satisfazer aos interessados e preservar a boa imagem da empresa.',4,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (5,'AC','Atendimento ao cliente','Dominar o processo de prestar atendimento comercial eficaz aos atuais e potenciais clientes, de modo a preservar e ajudar a incrementar os negócios da empresa.',4,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (6,'RH','Relações humanas','Dominar o processo de relacionamento interpessoal e intergrupal, de forma a gerar ambiente e relações de trabalho harmoniosos, profisionais, éticos e produtivos.',4,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (7,'IB','Informática Usuário Nível 1','Dominar, como usuário, os recursos fundamentais de microinformática: sistemas operacionais, editor de texto, planilha eletrônica, aplicativos de apresentação, internet e intranet.',2,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (8,'IP','Informática Usuário Nível 2','Dominar todos os itens de informática Usuário Nível 1, sendo alguns em nível avançado, e/ou softwares/aplicativos profissionais e sistemas informatizados em uso na empresa.',5,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (9,'MF','Matemática Financeira','Dominar o processo de efetuar os cálculos de juros, custo financeiro, projeções de valores, valor presente, valor futuro, amortizações, fatores de correção etc.',5,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (10,'RE','Comunicação escrita','Dominar as técnicas de escrever em nível especial, escrever corretamente no idioma nacional e/ou conhecer os formatos oficiais e usuais de redação nos negócios: relatórios, atas, ofícios, cartas, etc.',5,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (11,'CE','Comunicação e Expressão','Dominar o processo de exposição de idéias e fatos por meio da fala e da expressão corporal, de forma a se fazer entender com clareza e objetividade, convencer e gerar empatia nos interlocutores.',3,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (12,'TN','Técnicas de negociação','Dominar o processo de negociar interesses econômico-financeiros e de atendimento de demandas, no âmbito interno e/ou externo da empresa, de modo a atingir integralmente os objetivos preservando os direitos envolvidos.',6,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (13,'EA','Estatístia Aplicada','Dominar os conceitos e cálculos estatísticos e saber interpretar os resultados nas aplicações requeridas pelos controles e estudos de interesse da empresa.',6,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (14,'ES','Espanhol','Dominar técnicas de leitura, escrita e conversação no idioma espanhol.',6,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (15,'IN','Inglês','Dominar técnicas de leitura, escrita e conversação no idioma inglês.',7,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (16,'PF','Prática Comercial/Fiscal','Conhecer e saber interpretar as normas que regem as trasações comerciais, a emissão e controle de notas fiscais e faturas e a apuração dos tributos.',5,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (17,'PD','Produtos/Serviços','Conhecer a área de atuação e os diversos produtos e serviços da empresa.',5,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (18,'TV','Técnicas de Vendas','Dominar o processo de conquista e manutenção de clientes para a empresa e de levar os clientes a se interessarem e se decidirem pela aquisição dos produtos/serviços.',6,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (19,'LB','Legislação Tributária','Conhecer e saber interpretar as normas que regem a aplicação dos tributos federais, estaduais e municipais à empresa de modo a conduzir as atividades, orientações e decisões em consonância com os seus dispositivos.',6,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (20,'LT','Legislação Trabalhista','Conhecer e saber interpretar as normas que regem as relações de trabalho, de modo a conduzir as atividades, orientações e decisões em consonância com os seus dispositivos.',6,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (21,'LC','Legislação Comercial','Conhecer e saber interpretar as normas que regem as transações comerciais que afetam a empresa, de modo a conduzir as atividades, orientações e decisões em consonância com os seus dispositivos.',6,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (22,'PL','Planejamento','Dominar o processo de antecipar cenários, planejar, controlar e executar as tarefas.',7,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (23,'HB','Habilitação de Motorista Categoria B','Possuir habilitação legal e saber conduzir veículos com capacidade de até 3.500 Kg ou para até nove passageiros.',7,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (24,'SQ','Sistema de Qualidade','Conhecer e saber aplicar conceitos, instrumentos e processos do Sistema da Qualidade adotados pela empresa.',4,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (25,'KB','Kanban','Conhecer e saber aplicar conceitos do sistema Kanban de gestão do fluxo de produção.',4,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (26,'KZ','Kaizen','Conhecer e saber aplicar conceitos do processo de melhorias contínuas denominado Kaizen.',4,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (27,'5S','5 Esses','Conhecer e saber aplicar conceitos do sistema 5 Ss de organização e limpeza.',5,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (28,'DC','Diagrama de Causa e Efeito','Conhecer e saber aplicar conceitos e técnicas do processo de análise e solução de problemas denominada Diagrama de Causa e Efeito ou Diagrama Espinha de Peixe.',5,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (29,'CD','Cad/3D','Conhecer e saber trabalhar com os aplicativos de desenho informatizado.',7,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL),
 (30,'ID','Leitura e Interpretação de Desenho','Saber ler e entender diagramas, plantas, fluxogramas e outras formas de apresentação de objetos e estruturas.',5,NULL,'2009-08-04 17:00:00',NULL,'alessandro',NULL);
/*!40000 ALTER TABLE `adm_competencia` ENABLE KEYS */;


--
-- Definition of table `ag_agenda`
--

DROP TABLE IF EXISTS `ag_agenda`;
CREATE TABLE `ag_agenda` (
  `COD_AGENDA` int(10) NOT NULL AUTO_INCREMENT,
  `ID_RESPONSAVEL` varchar(50) DEFAULT NULL,
  `ID_ULT_EXECUTOR` varchar(50) DEFAULT NULL,
  `ID_CITADOS` longtext,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `TITULO` varchar(250) DEFAULT NULL,
  `DESCRICAO` longtext,
  `SITUACAO` varchar(50) DEFAULT NULL,
  `PRIORIDADE` varchar(50) DEFAULT NULL,
  `PREV_DT_INI` datetime DEFAULT NULL,
  `PREV_HORAS` double(15,5) DEFAULT NULL,
  `DT_REALIZADO` datetime DEFAULT NULL,
  `ARQUIVO_ANEXO` longtext,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_AGENDA`),
  KEY `DT_AGENDA` (`PREV_DT_INI`),
  KEY `DT_REALIZADO` (`DT_REALIZADO`),
  KEY `ID_CONVOCADOS` (`ID_CITADOS`(45)),
  KEY `ID_ULT_EXECUTOR` (`ID_ULT_EXECUTOR`),
  KEY `ID_USUARIO` (`ID_RESPONSAVEL`),
  KEY `PREV_DT_INI` (`PREV_HORAS`),
  KEY `PRIORIDADE` (`PRIORIDADE`),
  KEY `SITUACAO` (`SITUACAO`),
  KEY `SYS_ID_USUARIO_INS` (`SYS_ID_USUARIO_INS`),
  KEY `TITULO` (`TITULO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ag_agenda`
--

/*!40000 ALTER TABLE `ag_agenda` DISABLE KEYS */;
/*!40000 ALTER TABLE `ag_agenda` ENABLE KEYS */;


--
-- Definition of table `ag_categoria`
--

DROP TABLE IF EXISTS `ag_categoria`;
CREATE TABLE `ag_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  KEY `DT_INATIVO` (`DT_INATIVO`),
  KEY `NOME` (`NOME`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ag_categoria`
--

/*!40000 ALTER TABLE `ag_categoria` DISABLE KEYS */;
INSERT INTO `ag_categoria` (`COD_CATEGORIA`,`NOME`,`DESCRICAO`,`DT_INATIVO`) VALUES 
 (1,'Reunião',NULL,NULL),
 (2,'Encontro',NULL,NULL),
 (3,'Conferência',NULL,NULL),
 (4,'Almoço',NULL,NULL),
 (5,'Jantar',NULL,NULL),
 (15,'Visita',NULL,NULL),
 (16,'Viagem',NULL,NULL),
 (18,'Aniversário',NULL,NULL),
 (19,'Comemoração',NULL,NULL),
 (20,'Feriado',NULL,NULL),
 (21,'Treinamento',NULL,NULL);
/*!40000 ALTER TABLE `ag_categoria` ENABLE KEYS */;


--
-- Definition of table `ag_resposta`
--

DROP TABLE IF EXISTS `ag_resposta`;
CREATE TABLE `ag_resposta` (
  `COD_AG_RESPOSTA` int(10) NOT NULL AUTO_INCREMENT,
  `COD_AGENDA` int(10) DEFAULT NULL,
  `ID_FROM` varchar(50) DEFAULT NULL,
  `ID_TO` longtext,
  `RESPOSTA` longtext,
  `HORAS` double(15,5) DEFAULT NULL,
  `DTT_RESPOSTA` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_AG_RESPOSTA`),
  KEY `ID_SENDTO` (`ID_TO`(45)),
  KEY `ID_USUARIO` (`ID_FROM`),
  KEY `TL_RESPOSTACOD_TODOLIST` (`COD_AGENDA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ag_resposta`
--

/*!40000 ALTER TABLE `ag_resposta` DISABLE KEYS */;
/*!40000 ALTER TABLE `ag_resposta` ENABLE KEYS */;


--
-- Definition of table `aslw_categoria`
--

DROP TABLE IF EXISTS `aslw_categoria`;
CREATE TABLE `aslw_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` longtext,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  KEY `DT_INATIVO` (`DT_INATIVO`),
  KEY `IDX_NOME` (`NOME`)
) ENGINE=InnoDB AUTO_INCREMENT=617 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `aslw_categoria`
--

/*!40000 ALTER TABLE `aslw_categoria` DISABLE KEYS */;
INSERT INTO `aslw_categoria` (`COD_CATEGORIA`,`NOME`,`DESCRICAO`,`DT_INATIVO`) VALUES 
 (610,'Financeiro',NULL,NULL),
 (611,'Gerencial',NULL,NULL),
 (612,'Serviços',NULL,NULL),
 (613,'Administrativo',NULL,NULL),
 (614,'Cadastramento',NULL,NULL),
 (615,'PontoRH',NULL,NULL),
 (616,'Outros',NULL,NULL);
/*!40000 ALTER TABLE `aslw_categoria` ENABLE KEYS */;


--
-- Definition of table `aslw_relatorio`
--

DROP TABLE IF EXISTS `aslw_relatorio`;
CREATE TABLE `aslw_relatorio` (
  `COD_RELATORIO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `NOME` varchar(80) DEFAULT NULL,
  `DESCRICAO` longtext,
  `EXECUTOR` varchar(255) DEFAULT NULL,
  `PARAMETRO` longtext,
  `SYS_CRIA` varchar(50) DEFAULT NULL,
  `SYS_ALTERA` varchar(50) DEFAULT NULL,
  `DT_CRIACAO` datetime DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `DT_ALTERACAO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_RELATORIO`),
  KEY `ASLW_RELATORIOCOD_CATEGORIA` (`COD_CATEGORIA`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `aslw_relatorio`
--

/*!40000 ALTER TABLE `aslw_relatorio` DISABLE KEYS */;
INSERT INTO `aslw_relatorio` (`COD_RELATORIO`,`COD_CATEGORIA`,`NOME`,`DESCRICAO`,`EXECUTOR`,`PARAMETRO`,`SYS_CRIA`,`SYS_ALTERA`,`DT_CRIACAO`,`DT_INATIVO`,`DT_ALTERACAO`) VALUES 
 (15,290,'Total de REGISTROS PONTO',NULL,'ExecASLW.asp','SELECT COUNT(COD_PONTO) as TOTAL  FROM PT_PONTO','aless','aless','2007-06-08 00:00:00',NULL,'2007-06-08 00:00:00'),
 (16,290,'Total de REGISTRO PONTO_DIA',NULL,'ExecASLW.asp','SELECT Count(*) as TOTAL FROM PT_TOTAL_DIA','aless','aless','2007-06-08 00:00:00',NULL,'2007-06-08 00:00:00'),
 (19,290,'Listagem de usuarios ativos','Listagem dos usuários ativos com seus códigos, nome e apelido.','ExecASLW.asp','SELECT COD_USUARIO, TIPO, ID_USUARIO, NOME, apelido FROM USUARIO WHERE DT_INATIVO is NULL\r\n ORDER By TIPO DESC, NOME','aless','aless','2007-06-10 00:00:00',NULL,'2011-05-30 00:00:00'),
 (21,290,'TotHoras PREV x REAL em BS FECHADOS',NULL,'ExecASLW.asp','SELECT \r\n   CL.NOME_COMERCIAL\r\n  ,SUM(TL.PREV_HORAS) AS TotPREV\r\n  ,SUM(TR.HORAS) as TotREAL \r\nFROM \r\n   BS_BOLETIM AS BS\r\n  ,TL_TODOLIST AS TL\r\n  ,ENT_CLIENTE as CL\r\n  ,TL_RESPOSTA as TR\r\nWHERE \r\n   BS.SITUACAO like <ASLW_ASPAS>FECHADO<ASLW_ASPAS>  AND \r\n   BS.COD_CLIENTE = CL.COD_CLIENTE AND \r\n   BS.COD_BOLETIM = TL.COD_BOLETIM AND \r\n   TR.COD_TODOLIST = TL.COD_TODOLIST\r\nGROUP BY \r\n  CL.NOME_COMERCIAL\r\nORDER BY \r\n  CL.NOME_COMERCIAL','aless','aless','2007-09-12 00:00:00',NULL,'2007-09-12 00:00:00'),
 (22,290,'TotHoras REAL em TODO avulsos fechados',NULL,'ExecASLW.asp','SELECT \r\n  TL.TITULO\r\n ,SUM(TR.HORAS) as TotREAL \r\nFROM \r\n  TL_TODOLIST AS TL\r\n ,TL_RESPOSTA as TR\r\nWHERE \r\n   TR.COD_TODOLIST = TL.COD_TODOLIST  AND \r\n   TL.COD_BOLETIM is NULL  AND \r\n   TL.SITUACAO like <ASLW_ASPAS>FECHADO<ASLW_ASPAS>\r\nGROUP BY\r\n  TL.TITULO','aless','clvsutil','2007-09-12 00:00:00',NULL,'2007-10-18 00:00:00'),
 (23,290,'Listagem HORAS de Consultor em ATIVIDADES/BS','Listagem de horas gastas pelos consultores nos BS','ExecASLW.asp','SELECT \r\n   TR.DTT_RESPOSTA AS DATA\r\n  ,TR.ID_FROM AS CONSULTOR\r\n  ,CL.NOME_COMERCIAL AS CLIENTE\r\n  ,BS.COD_BOLETIM\r\n  ,BS.TITULO AS BOLETIM\r\n  ,TR.HORAS\r\nFROM \r\n   BS_BOLETIM AS BS\r\n  ,TL_TODOLIST AS TL\r\n  ,TL_RESPOSTA AS TR\r\n  ,ENT_CLIENTE AS CL\r\nWHERE BS.SITUACAO LIKE <ASLW_ASPAS>FECHADO<ASLW_ASPAS> \r\nAND BS.COD_CLIENTE = CL.COD_CLIENTE\r\nAND BS.COD_BOLETIM = TL.COD_BOLETIM\r\nAND TR.COD_TODOLIST = TL.COD_TODOLIST\r\nAND TR.SYS_ID_USUARIO_INS <> <ASLW_APOSTROFE><ASLW_APOSTROFE>\r\nORDER BY \r\n   CL.NOME_COMERCIAL\r\n  ,BS.TITULO\r\n  ,TR.DTT_RESPOSTA','clvsutil','clvsutil','2007-10-18 00:00:00',NULL,'2007-10-18 00:00:00'),
 (34,289,'Planos de Contas não usados',NULL,'ExecASLW.asp','SELECT COD_PLANO_CONTA FROM FIN_CONTA_PAGAR_RECEBER WHERE COD_PLANO_CONTA NOT IN (SELECT DISTINCT COD_PLANO_CONTA FROM FIN_PLANO_CONTA)','cleverson','cleverson','2010-03-16 00:00:00','2010-03-16 00:00:00','2010-03-16 00:00:00'),
 (35,290,'Lista dados dos Clientes','Lista os dados dos clientes ativos e inativos','ExecASLW.asp','\r\n\r\nSELECT \r\n  COD_CLIENTE\r\n, RAZAO_SOCIAL\r\n, NOME_FANTASIA\r\n, NOME_COMERCIAL\r\n, NUM_DOC\r\n, TIPO_DOC\r\n, INSC_ESTADUAL\r\n, INSC_MUNICIPAL\r\n, FONE_1\r\n, FONE_2\r\n, FAX\r\n, EMAIL\r\n, SITE\r\n, CONTATO\r\n, DT_CADASTRO\r\n, DT_INATIVO\r\n\r\n, ENTR_ENDERECO\r\n, ENTR_NUMERO\r\n, ENTR_COMPLEMENTO\r\n, ENTR_CEP\r\n, ENTR_BAIRRO\r\n, ENTR_CIDADE\r\n, ENTR_ESTADO\r\n, ENTR_PAIS\r\n\r\n, FATURA_ENDERECO\r\n, FATURA_COMPLEMENTO\r\n, FATURA_NUMERO\r\n, FATURA_CEP\r\n, FATURA_BAIRRO\r\n, FATURA_CIDADE\r\n, FATURA_ESTADO\r\n, FATURA_PAIS\r\n\r\n, COBR_ENDERECO\r\n, COBR_NUMERO\r\n, COBR_COMPLEMENTO\r\n, COBR_CEP\r\n, COBR_BAIRRO\r\n, COBR_CIDADE\r\n, COBR_ESTADO\r\n, COBR_PAIS\r\nFROM ENT_CLIENTE\r\nORDER BY RAZAO_SOCIAL','cleverson',NULL,'2010-10-20 00:00:00',NULL,NULL),
 (36,290,'Atendimentos dos CHAMADOS em GERAL','Relação dos chamados com descrição dos chamados e tarefas, tempo das respostas e tempo gasto executando tarefa. Busca somente tarefas fechadas.','ExecASLW.asp','SELECT T1.COD_CHAMADO, T1.TITULO AS CHAM_TITULO, T1.DESCRICAO AS CHAM_DESCRICAO\r\n     , T1.SYS_DTT_INS AS CHAM_DATA\r\n     , T1.SYS_ID_USUARIO_INS AS SOLICITANTE \r\n     , T1.PRIORIDADE AS CHAM_PRIORIDADE\r\n     , T2.TITULO AS TAREFA_TITULO, T2.DESCRICAO AS TAREFA_DESCRICAO\r\n     , T4.NOME AS CATEGORIA\r\n     , T2.PRIORIDADE AS TAREFA_PRIORIDADE\r\n     , MIN(T3.DTT_RESPOSTA) AS PRIM_EXEC\r\n     , MAX(T3.DTT_RESPOSTA) AS ULT_EXEC\r\n     , SUM(T3.HORAS) AS TOTAL\r\nFROM CH_CHAMADO T1, TL_TODOLIST T2, TL_RESPOSTA T3, TL_CATEGORIA T4\r\nWHERE T1.COD_CLI = {COD_CLIENTE}\r\nAND T1.COD_TODOLIST = T2.COD_TODOLIST\r\nAND T2.COD_TODOLIST = T3.COD_TODOLIST\r\nAND T2.SITUACAO = <ASLW_APOSTROFE>FECHADO<ASLW_APOSTROFE>\r\nAND T2.COD_CATEGORIA = T4.COD_CATEGORIA\r\nAND T2.PREV_DT_INI BETWEEN STR_TO_DATE(<ASLW_APOSTROFE>{PR_DT_INI}<ASLW_APOSTROFE>,<ASLW_APOSTROFE><ASLW_PERCENT>d/<ASLW_PERCENT>m/<ASLW_PERCENT>Y<ASLW_APOSTROFE>) AND STR_TO_DATE(<ASLW_APOSTROFE>{PR_DT_FIM}<ASLW_APOSTROFE>,<ASLW_APOSTROFE><ASLW_PERCENT>d/<ASLW_PERCENT>m/<ASLW_PERCENT>Y<ASLW_APOSTROFE>)\r\nGROUP BY T1.COD_CHAMADO, T1.TITULO, T1.DESCRICAO, T1.SYS_DTT_INS, T1.PRIORIDADE, T2.TITULO, T2.DESCRICAO, T4.NOME, T2.PRIORIDADE','cleverson','tatiana','2011-02-23 00:00:00',NULL,'2011-07-05 00:00:00'),
 (38,290,'Atendimentos vs Desbloqueio dos CHAMADOS','Relação dos chamados com descrição dos chamados e tarefas, tempo das respostas e tempo gasto executando tarefa. Busca somente tarefas fechadas.','ExecASLW.asp','SELECT T1.COD_CHAMADO, T1.TITULO AS CHAM_TITULO\r\n     , T1.DESCRICAO\r\n     , T1.SYS_DTT_INS AS CHAM_DATA\r\n     , T1.SYS_ID_USUARIO_INS AS SOLICITANTE \r\n     , T4.NOME\r\n     , T1.SYS_DTT_DESBLOQUEIO\r\n     , MIN(T3.DTT_RESPOSTA) AS PRIM_EXEC\r\n     , MAX(T3.DTT_RESPOSTA) AS ULT_EXEC\r\n     , SUM(T3.HORAS) AS TOTAL\r\n     ,T1.SYS_ID_USUARIO_DESBLOQUEIO as DSBL_USR\r\n     ,T1.HORAS  as DSBL_HORAS\r\n     ,T1.VALOR  as DSBL_VALO\r\nFROM CH_CHAMADO T1, TL_TODOLIST T2, TL_RESPOSTA T3, CH_CATEGORIA T4\r\nWHERE T1.COD_CLI = {COD_CLIENTE}\r\nAND T1.COD_TODOLIST = T2.COD_TODOLIST\r\nAND T2.COD_TODOLIST = T3.COD_TODOLIST\r\nAND T2.SITUACAO = <ASLW_APOSTROFE>FECHADO<ASLW_APOSTROFE>\r\nAND T1.COD_CATEGORIA = T4.COD_CATEGORIA\r\nAND T2.PREV_DT_INI BETWEEN STR_TO_DATE(<ASLW_APOSTROFE>{PR_DT_INI}<ASLW_APOSTROFE>,<ASLW_APOSTROFE><ASLW_PERCENT>d/<ASLW_PERCENT>m/<ASLW_PERCENT>Y<ASLW_APOSTROFE>) AND STR_TO_DATE(<ASLW_APOSTROFE>{PR_DT_FIM}<ASLW_APOSTROFE>,<ASLW_APOSTROFE><ASLW_PERCENT>d/<ASLW_PERCENT>m/<ASLW_PERCENT>Y<ASLW_APOSTROFE>)\r\nGROUP BY T1.COD_CHAMADO, T1.TITULO, T1.DESCRICAO, T1.SYS_DTT_INS, T4.NOME, T1.SYS_DTT_DESBLOQUEIO\r\n,T1.SYS_ID_USUARIO_DESBLOQUEIO ,T1.HORAS, T1.VALOR','aless','tatiana','2011-05-30 00:00:00',NULL,'2011-07-05 00:00:00'),
 (39,289,'Relação Clientes Ativos x Valores SINTETICO','Relação de clientes ativos e valores dos títulos\r\n','ExecASLW.asp','SELECT T1.COD_CLIENTE, T1.RAZAO_SOCIAL, T1.NOME_FANTASIA, T1.NUM_DOC AS DOC \r\n     , (SELECT DATE_FORMAT(MIN(T3.SYS_DT_CRIACAO),<ASLW_APOSTROFE><ASLW_PERCENT>Y/<ASLW_PERCENT>m<ASLW_APOSTROFE>) FROM FIN_CONTA_PAGAR_RECEBER T3 WHERE COD_CLIENTE = T3.CODIGO AND T3.TIPO LIKE <ASLW_APOSTROFE>ENT_CLIENTE<ASLW_APOSTROFE> AND T3.PAGAR_RECEBER = 0) AS PRI_TIT \r\n     , (SELECT TRUNCATE(SUM(T2.VLR_CONTA),0) FROM FIN_CONTA_PAGAR_RECEBER T2 WHERE COD_CLIENTE = T2.CODIGO AND T2.TIPO LIKE <ASLW_APOSTROFE>ENT_CLIENTE<ASLW_APOSTROFE> AND T2.PAGAR_RECEBER = 0) AS TOT_EMITIDO \r\n     , (SELECT TRUNCATE(SUM(T4.VLR_LCTO),0) FROM FIN_LCTO_ORDINARIO T4, FIN_CONTA_PAGAR_RECEBER T5 WHERE T4.COD_CONTA_PAGAR_RECEBER = T5.COD_CONTA_PAGAR_RECEBER AND COD_CLIENTE = T5.CODIGO AND T5.TIPO LIKE <ASLW_APOSTROFE>ENT_CLIENTE<ASLW_APOSTROFE> AND T5.PAGAR_RECEBER = 0) AS TOT_PAGO \r\nFROM ENT_CLIENTE T1 \r\nWHERE T1.DT_INATIVO IS NULL \r\nGROUP BY T1.COD_CLIENTE, T1.RAZAO_SOCIAL, T1.NOME_FANTASIA, T1.NUM_DOC \r\nORDER BY 6 DESC, T1.RAZAO_SOCIAL \r\n','cleverson','cleverson','2011-08-18 00:00:00',NULL,'2011-09-01 00:00:00'),
 (40,289,'Relação Clientes Inativos x Valores SINTETICO','Relação de clientes inativos e valores dos títulos','ExecASLW.asp','SELECT T1.COD_CLIENTE, T1.RAZAO_SOCIAL, T1.NOME_FANTASIA, T1.NUM_DOC AS DOC \r\n     , (SELECT DATE_FORMAT(MIN(T3.SYS_DT_CRIACAO),<ASLW_APOSTROFE><ASLW_PERCENT>Y/<ASLW_PERCENT>m<ASLW_APOSTROFE>) FROM FIN_CONTA_PAGAR_RECEBER T3 WHERE COD_CLIENTE = T3.CODIGO AND T3.TIPO LIKE <ASLW_APOSTROFE>ENT_CLIENTE<ASLW_APOSTROFE> AND T3.PAGAR_RECEBER = 0) AS PRI_TIT \r\n     , (SELECT TRUNCATE(SUM(T2.VLR_CONTA),0) FROM FIN_CONTA_PAGAR_RECEBER T2 WHERE COD_CLIENTE = T2.CODIGO AND T2.TIPO LIKE <ASLW_APOSTROFE>ENT_CLIENTE<ASLW_APOSTROFE> AND T2.PAGAR_RECEBER = 0) AS TOT_EMITIDO \r\n     , (SELECT TRUNCATE(SUM(T4.VLR_LCTO),0) FROM FIN_LCTO_ORDINARIO T4, FIN_CONTA_PAGAR_RECEBER T5 WHERE T4.COD_CONTA_PAGAR_RECEBER = T5.COD_CONTA_PAGAR_RECEBER AND COD_CLIENTE = T5.CODIGO AND T5.TIPO LIKE <ASLW_APOSTROFE>ENT_CLIENTE<ASLW_APOSTROFE> AND T5.PAGAR_RECEBER = 0) AS TOT_PAGO \r\nFROM ENT_CLIENTE T1 \r\nWHERE T1.DT_INATIVO IS NOT NULL \r\nGROUP BY T1.COD_CLIENTE, T1.RAZAO_SOCIAL, T1.NOME_FANTASIA, T1.NUM_DOC \r\nORDER BY 6 DESC, T1.RAZAO_SOCIAL \r\n','cleverson','cleverson','2011-08-18 00:00:00',NULL,'2011-09-01 00:00:00'),
 (41,289,'Relação Clientes Ativos x Valores ANALITICO','Relação de clientes ativos e valores dos títulos\r\n','ExecASLW.asp','SELECT T1.COD_CLIENTE, T1.RAZAO_SOCIAL, T1.NOME_FANTASIA, T1.NUM_DOC AS DOC, DATE_FORMAT(T3.DT_VCTO,<ASLW_APOSTROFE><ASLW_PERCENT>d/<ASLW_PERCENT>m/<ASLW_PERCENT>Y<ASLW_APOSTROFE>) AS DT_VCTO, T3.VLR_CONTA, T5.NOME AS PLANO_CONTA, T1.TIPO_DOC \r\nFROM ENT_CLIENTE T1 \r\nLEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T3 ON (T1.COD_CLIENTE = T3.CODIGO AND T3.TIPO LIKE <ASLW_APOSTROFE>ENT_CLIENTE<ASLW_APOSTROFE> AND T3.PAGAR_RECEBER = 0)\r\nLEFT OUTER JOIN FIN_PLANO_CONTA T5 ON (T3.COD_PLANO_CONTA = T5.COD_PLANO_CONTA)\r\nWHERE T1.DT_INATIVO IS NULL \r\nORDER BY T1.TIPO_DOC DESC, T1.RAZAO_SOCIAL, T5.NOME, T3.DT_VCTO\r\n','cleverson','cleverson','2011-09-01 00:00:00',NULL,'2011-09-01 00:00:00'),
 (42,290,'Descrição Itens NF por CLIENTE','Descrição Itens NF por CLIENTE - situação=EMITIDA','ExecASLW.asp','SELECT T2.NUM_NF, t2.DT_EMISSAO, T2.CLI_NOME, T1.TIT_SERVICO, T1.DESC_SERVICO, T1.DESC_EXTRA, T1.VALOR\r\nFROM (NF_ITEM AS T1 INNER JOIN NF_NOTA AS T2 ON T1.COD_NF=T2.COD_NF)\r\nWHERE T2.SITUACAO like <ASLW_ASPAS>EMITIDA<ASLW_ASPAS> AND ((T2.COD_CLI) LIKE <ASLW_APOSTROFE><ASLW_PERCENT>{cliente}<ASLW_PERCENT><ASLW_APOSTROFE>)\r\nGROUP BY T2.NUM_NF, t2.DT_EMISSAO, T2.CLI_NOME, T1.TIT_SERVICO, T1.DESC_SERVICO, T1.DESC_EXTRA, T1.VALOR\r\nORDER BY T2.NUM_NF','tatiana','tatiana','2011-12-07 00:00:00',NULL,'2011-12-07 00:00:00'),
 (43,293,'Lista de EMAIL de clientes ATIVOS','Lista RAZÃO SOCIAL, NOME FANTASIA, NOME COMERCIAL E EMAIL de clientes ATIVOS','ExecASLW.asp','SELECT razao_social, nome_fantasia, nome_comercial, contato, email FROM ent_cliente \r\nWHERE DT_INATIVO is NULL;','tatiana','tatiana','2012-03-30 00:00:00',NULL,'2012-03-30 00:00:00'),
 (44,289,'Lançamentos Gerais',NULL,'ExecASLW.asp','SELECT\r\n    if((PGR.PAGAR_RECEBER=0),<ASLW_APOSTROFE>ENTRADA<ASLW_APOSTROFE>,<ASLW_APOSTROFE>SAIDA<ASLW_APOSTROFE>) AS OPERACAO \r\n   ,PGR.TIPO                                                                              \r\n   ,PGR.CODIGO AS COD_ENTIDADE \r\n   ,case PGR.TIPO\r\n     when <ASLW_APOSTROFE>ENT_CLIENTE<ASLW_APOSTROFE>     then CLI.RAZAO_SOCIAL\r\n     when <ASLW_APOSTROFE>ENT_FORNECEDOR<ASLW_APOSTROFE>  then FRC.RAZAO_SOCIAL\r\n     when <ASLW_APOSTROFE>ENT_COLABORADOR<ASLW_APOSTROFE> then COL.NOME\r\n    end AS NOME \r\n   ,PGR.HISTORICO                                                        \r\n   ,ORD.VLR_LCTO AS VALOR \r\n   ,ORD.DT_LCTO AS DATA \r\n   ,CTA2.NOME AS CONTA_REALIZADA \r\n   ,PC.COD_REDUZIDO PL_COD_REDUZIDO\r\n   ,PC.NOME AS NOME_PLANO_CONTA \r\n   ,CC.COD_REDUZIDO CC_COD_REDUZIDO\r\n   ,CC.NOME AS NOME_CENTRO_CUSTO\r\nFROM FIN_CONTA_PAGAR_RECEBER PGR \r\n       	LEFT OUTER JOIN FIN_LCTO_ORDINARIO ORD  ON (PGR.COD_CONTA_PAGAR_RECEBER = ORD.COD_CONTA_PAGAR_RECEBER)\r\n       	LEFT OUTER JOIN FIN_CONTA          CTA2 ON (ORD.COD_CONTA = CTA2.COD_CONTA )   \r\n       	LEFT OUTER JOIN FIN_PLANO_CONTA    PC   ON (ORD.COD_PLANO_CONTA = PC.COD_PLANO_CONTA) \r\n       	LEFT OUTER JOIN FIN_CENTRO_CUSTO   CC   ON (ORD.COD_CENTRO_CUSTO = CC.COD_CENTRO_CUSTO) \r\n        LEFT OUTER JOIN ENT_CLIENTE        CLI  ON (PGR.CODIGO = CLI.COD_CLIENTE)\r\n        LEFT OUTER JOIN ENT_FORNECEDOR     FRC  ON (PGR.CODIGO = FRC.COD_FORNECEDOR)\r\n        LEFT OUTER JOIN ENT_COLABORADOR    COL  ON (PGR.CODIGO = COL.COD_COLABORADOR)\r\nWHERE ORD.SYS_DT_CANCEL IS NULL \r\nAND ORD.DT_LCTO BETWEEN STR_TO_DATE(<ASLW_APOSTROFE>{PR_DT_INI}<ASLW_APOSTROFE>,<ASLW_APOSTROFE>d/m/Y<ASLW_APOSTROFE>) AND STR_TO_DATE(<ASLW_APOSTROFE>{PR_DT_FIM}<ASLW_APOSTROFE>,<ASLW_APOSTROFE>d/m/Y<ASLW_APOSTROFE>)\r\n\r\n\r\nUNION \r\n \r\n SELECT\r\n    if(LCT.OPERACAO=<ASLW_APOSTROFE>DESPESA<ASLW_APOSTROFE>,<ASLW_APOSTROFE>SAIDA<ASLW_APOSTROFE>,<ASLW_APOSTROFE>ENTRADA<ASLW_APOSTROFE>) AS OPERACAO \r\n   ,LCT.TIPO \r\n   ,LCT.CODIGO AS COD_ENTIDADE\r\n   ,case LCT.TIPO\r\n     when <ASLW_APOSTROFE>ENT_CLIENTE<ASLW_APOSTROFE>     then CLI.RAZAO_SOCIAL\r\n     when <ASLW_APOSTROFE>ENT_FORNECEDOR<ASLW_APOSTROFE>  then FRC.RAZAO_SOCIAL\r\n     when <ASLW_APOSTROFE>ENT_COLABORADOR<ASLW_APOSTROFE> then COL.NOME\r\n    end AS NOME \r\n   ,LCT.HISTORICO \r\n   ,LCT.VLR_LCTO AS VALOR \r\n   ,LCT.DT_LCTO AS DATA \r\n   ,CTA2.NOME AS CONTA_REALIZADA \r\n   ,PC.COD_REDUZIDO PL_COD_REDUZIDO\r\n   ,PC.NOME AS NOME_PLANO_CONTA \r\n   ,CC.COD_REDUZIDO CC_COD_REDUZIDO\r\n   ,CC.NOME AS NOME_CENTRO_CUSTO\r\nFROM FIN_LCTO_EM_CONTA LCT \r\n       	LEFT OUTER JOIN FIN_CONTA          CTA2 ON (LCT.COD_CONTA = CTA2.COD_CONTA )   \r\n       	LEFT OUTER JOIN FIN_PLANO_CONTA    PC   ON (LCT.COD_PLANO_CONTA = PC.COD_PLANO_CONTA) \r\n       	LEFT OUTER JOIN FIN_CENTRO_CUSTO   CC   ON (LCT.COD_CENTRO_CUSTO = CC.COD_CENTRO_CUSTO) \r\n        LEFT OUTER JOIN ENT_CLIENTE        CLI  ON (LCT.CODIGO = CLI.COD_CLIENTE)\r\n        LEFT OUTER JOIN ENT_FORNECEDOR     FRC  ON (LCT.CODIGO = FRC.COD_FORNECEDOR)\r\n        LEFT OUTER JOIN ENT_COLABORADOR    COL  ON (LCT.CODIGO = COL.COD_COLABORADOR)\r\nWHERE \r\n    LCT.DT_LCTO BETWEEN STR_TO_DATE(<ASLW_APOSTROFE>{PR_DT_INI}<ASLW_APOSTROFE>,<ASLW_APOSTROFE>d/m/Y<ASLW_APOSTROFE>) AND STR_TO_DATE(<ASLW_APOSTROFE>{PR_DT_FIM}<ASLW_APOSTROFE>,<ASLW_APOSTROFE>d/m/Y<ASLW_APOSTROFE>)\r\n\r\nORDER BY\r\n  9\r\n ,8\r\n ,10','kiko','kiko','2012-09-26 00:00:00',NULL,'2012-09-26 00:00:00');
/*!40000 ALTER TABLE `aslw_relatorio` ENABLE KEYS */;


--
-- Definition of table `bs_boletim`
--

DROP TABLE IF EXISTS `bs_boletim`;
CREATE TABLE `bs_boletim` (
  `COD_BOLETIM` int(10) NOT NULL AUTO_INCREMENT,
  `COD_PROJETO` int(10) DEFAULT NULL,
  `COD_CLIENTE` int(10) DEFAULT NULL,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `ID_RESPONSAVEL` varchar(50) DEFAULT NULL,
  `TITULO` varchar(255) DEFAULT NULL,
  `DESCRICAO` longtext,
  `SITUACAO` varchar(50) DEFAULT NULL,
  `PRIORIDADE` varchar(50) DEFAULT NULL,
  `MODELO` tinyint(1) NOT NULL DEFAULT '0',
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_ID_USUARIO_ALT` varchar(50) DEFAULT NULL,
  `COD_ANTIGO` int(10) DEFAULT NULL,
  `TIPO` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`COD_BOLETIM`),
  KEY `BSCOD_CLIENTE` (`COD_CLIENTE`),
  KEY `COD_SETOR` (`COD_CATEGORIA`),
  KEY `ID_RESPONSAVEL` (`ID_RESPONSAVEL`),
  KEY `MODELO` (`MODELO`),
  KEY `TITULO` (`TITULO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `bs_boletim`
--

/*!40000 ALTER TABLE `bs_boletim` DISABLE KEYS */;
/*!40000 ALTER TABLE `bs_boletim` ENABLE KEYS */;


--
-- Definition of table `bs_categoria`
--

DROP TABLE IF EXISTS `bs_categoria`;
CREATE TABLE `bs_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  KEY `DT_INATIVO` (`DT_INATIVO`),
  KEY `NOME` (`NOME`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `bs_categoria`
--

/*!40000 ALTER TABLE `bs_categoria` DISABLE KEYS */;
INSERT INTO `bs_categoria` (`COD_CATEGORIA`,`NOME`,`DESCRICAO`,`DT_INATIVO`) VALUES 
 (1,'Administrativo',NULL,NULL),
 (2,'Financeiro',NULL,NULL),
 (3,'Produção',NULL,NULL),
 (4,'Pesquisa',NULL,NULL),
 (5,'Marketing',NULL,NULL),
 (6,'Pessoas - RH',NULL,NULL),
 (7,'Qualidade',NULL,NULL),
 (9,'Evento',NULL,NULL);
/*!40000 ALTER TABLE `bs_categoria` ENABLE KEYS */;


--
-- Definition of table `bs_equipe`
--

DROP TABLE IF EXISTS `bs_equipe`;
CREATE TABLE `bs_equipe` (
  `COD_EQUIPE` int(10) NOT NULL AUTO_INCREMENT,
  `COD_BOLETIM` int(10) DEFAULT NULL,
  `ID_USUARIO` varchar(50) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_EQUIPE`),
  KEY `BS_EQUIPECOD_BS` (`COD_BOLETIM`),
  KEY `ID_RESPONSAVEL` (`ID_USUARIO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `bs_equipe`
--

/*!40000 ALTER TABLE `bs_equipe` DISABLE KEYS */;
/*!40000 ALTER TABLE `bs_equipe` ENABLE KEYS */;


--
-- Definition of table `cfg_aviso`
--

DROP TABLE IF EXISTS `cfg_aviso`;
CREATE TABLE `cfg_aviso` (
  `COD_CFG_AVISO` int(10) NOT NULL AUTO_INCREMENT,
  `AVISAR_MANAGER_BS_TODO` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`COD_CFG_AVISO`),
  UNIQUE KEY `Index_FC0E93B9_8BB1_45D0` (`COD_CFG_AVISO`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cfg_aviso`
--

/*!40000 ALTER TABLE `cfg_aviso` DISABLE KEYS */;
INSERT INTO `cfg_aviso` (`COD_CFG_AVISO`,`AVISAR_MANAGER_BS_TODO`) VALUES 
 (1,0);
/*!40000 ALTER TABLE `cfg_aviso` ENABLE KEYS */;


--
-- Definition of table `cfg_boleto`
--

DROP TABLE IF EXISTS `cfg_boleto`;
CREATE TABLE `cfg_boleto` (
  `COD_CFG_BOLETO` int(10) NOT NULL AUTO_INCREMENT,
  `DESCRICAO` longtext,
  `CEDENTE_NOME` varchar(50) DEFAULT NULL,
  `CEDENTE_ENDERECO` longtext,
  `CEDENTE_AGENCIA` varchar(50) DEFAULT NULL,
  `CEDENTE_CNPJ` varchar(20) DEFAULT NULL,
  `CEDENTE_CODIGO` varchar(10) DEFAULT NULL,
  `CEDENTE_CODIGO_DV` varchar(10) DEFAULT NULL,
  `COD_CLIENTE` varchar(10) DEFAULT NULL,
  `BANCO_CODIGO` int(10) DEFAULT NULL,
  `BANCO_DV` varchar(50) DEFAULT NULL,
  `BANCO_IMG` varchar(50) DEFAULT NULL,
  `BOLETO_ACEITE` varchar(10) DEFAULT NULL,
  `BOLETO_CARTEIRA` varchar(10) DEFAULT NULL,
  `BOLETO_ESPECIE` varchar(10) DEFAULT NULL,
  `BOLETO_TIPO_DOC` varchar(20) DEFAULT NULL,
  `LOCAL_PGTO` varchar(255) DEFAULT NULL,
  `INSTRUCOES` longtext,
  `MODELO_HTML` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CFG_BOLETO`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cfg_boleto`
--

/*!40000 ALTER TABLE `cfg_boleto` DISABLE KEYS */;
INSERT INTO `cfg_boleto` (`COD_CFG_BOLETO`,`DESCRICAO`,`CEDENTE_NOME`,`CEDENTE_ENDERECO`,`CEDENTE_AGENCIA`,`CEDENTE_CNPJ`,`CEDENTE_CODIGO`,`CEDENTE_CODIGO_DV`,`COD_CLIENTE`,`BANCO_CODIGO`,`BANCO_DV`,`BANCO_IMG`,`BOLETO_ACEITE`,`BOLETO_CARTEIRA`,`BOLETO_ESPECIE`,`BOLETO_TIPO_DOC`,`LOCAL_PGTO`,`INSTRUCOES`,`MODELO_HTML`,`DT_INATIVO`) VALUES 
 (1,'Boleto Itaú','ATHENAS SOFTWARE & SYSTEMS','Av. Paulista, 1499 sl 901 Bela Vista CEP 01311-928 São Paulo - SP/Brasil  +55 11 3251.2002','0367','10.812.688/0001-68','76458','6',NULL,341,'7',NULL,'N','109','R$','DM','Até o vencimento, preferencialmente no Itaú<br>\r\nApós o vencimento, somente no Itaú','- Pagável em qualquer banco até o vencimento.<br>\r\n- Cobrar 0,10% de juros por dia de atraso<br>\r\n- Cobrar multa de 2% após o vencimento<br>\r\n- Este título será protestado após 05 dias do vencimento<br>','Boleto_Itau.asp',NULL);
/*!40000 ALTER TABLE `cfg_boleto` ENABLE KEYS */;


--
-- Definition of table `cfg_nf`
--

DROP TABLE IF EXISTS `cfg_nf`;
CREATE TABLE `cfg_nf` (
  `COD_CFG_NF` int(10) NOT NULL AUTO_INCREMENT,
  `SERIE` varchar(10) DEFAULT NULL,
  `DESCRICAO` longtext,
  `TIPO` varchar(50) DEFAULT NULL,
  `ULT_NUM_NF` int(10) DEFAULT NULL,
  `ULT_NUM_FORM` int(10) DEFAULT NULL,
  `MODELO_HTML` varchar(255) DEFAULT NULL,
  `NUM_LINHAS` int(10) DEFAULT NULL,
  `TAM_LINHA` int(10) DEFAULT NULL,
  `ALIQ_ISSQN` double(15,5) DEFAULT NULL,
  `ALIQ_IRPJ` double(15,5) DEFAULT NULL,
  `ALIQ_COFINS` double(15,5) DEFAULT NULL,
  `ALIQ_PIS` double(15,5) DEFAULT NULL,
  `ALIQ_CSOCIAL` double(15,5) DEFAULT NULL,
  `ALIQ_IRRF` double(15,5) DEFAULT NULL,
  `VLR_LIM_IRRF` double(15,5) DEFAULT NULL,
  `VLR_LIM_REDUCAO` double(15,5) DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `COD_FORNEC` int(10) DEFAULT NULL,
  PRIMARY KEY (`COD_CFG_NF`),
  KEY `IDX_ISSQN` (`ALIQ_ISSQN`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cfg_nf`
--

/*!40000 ALTER TABLE `cfg_nf` DISABLE KEYS */;
INSERT INTO `cfg_nf` (`COD_CFG_NF`,`SERIE`,`DESCRICAO`,`TIPO`,`ULT_NUM_NF`,`ULT_NUM_FORM`,`MODELO_HTML`,`NUM_LINHAS`,`TAM_LINHA`,`ALIQ_ISSQN`,`ALIQ_IRPJ`,`ALIQ_COFINS`,`ALIQ_PIS`,`ALIQ_CSOCIAL`,`ALIQ_IRRF`,`VLR_LIM_IRRF`,`VLR_LIM_REDUCAO`,`ORDEM`,`DT_INATIVO`,`COD_FORNEC`) VALUES 
 (2,'01','Serviços ATHENAS','PADRAO',4300,4300,'NOTA_SERVICO_XP_IE7.asp',10,112,2.00000,4.85000,3.00000,0.65000,1.00000,1.50000,10.00000,5000.00000,50,'2009-09-15 00:00:00',124),
 (3,'02','Modelo para emissão de RECIBO','PADRAO',101536,940,'RECIBO_SIMPLES.asp',10,112,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,5000.00000,100,NULL,131),
 (4,'03','Serviços ATHENAS - 2009','PADRAO',4473,4473,'NOTA_SERVICO2009_XP_IE7.asp',7,112,2.00000,4.85000,3.00000,0.65000,1.00000,1.50000,10.00000,5000.00000,0,'2010-01-18 00:00:00',124),
 (5,'04','Modelo para NF-e PMSP','PADRAO',1898,931,'RECIBO_NFe_2010.asp',7,110,2.00000,4.85000,3.00000,0.65000,1.00000,1.50000,10.00000,5000.00000,110,NULL,131);
/*!40000 ALTER TABLE `cfg_nf` ENABLE KEYS */;


--
-- Definition of table `ch_anexo`
--

DROP TABLE IF EXISTS `ch_anexo`;
CREATE TABLE `ch_anexo` (
  `COD_ANEXO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CHAMADO` int(10) DEFAULT NULL,
  `ARQUIVO` varchar(250) DEFAULT NULL,
  `DESCRICAO` longtext,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_ANEXO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ch_anexo`
--

/*!40000 ALTER TABLE `ch_anexo` DISABLE KEYS */;
/*!40000 ALTER TABLE `ch_anexo` ENABLE KEYS */;


--
-- Definition of table `ch_categoria`
--

DROP TABLE IF EXISTS `ch_categoria`;
CREATE TABLE `ch_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  KEY `DT_INATIVO` (`DT_INATIVO`),
  KEY `NOME` (`NOME`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ch_categoria`
--

/*!40000 ALTER TABLE `ch_categoria` DISABLE KEYS */;
INSERT INTO `ch_categoria` (`COD_CATEGORIA`,`NOME`,`DESCRICAO`,`DT_INATIVO`) VALUES 
 (1,'ALTERAÇÃO',NULL,NULL),
 (2,'PROBLEMA',NULL,NULL),
 (3,'SUGESTAO',NULL,NULL),
 (4,'DÚVIDA',NULL,NULL);
/*!40000 ALTER TABLE `ch_categoria` ENABLE KEYS */;


--
-- Definition of table `ch_chamado`
--

DROP TABLE IF EXISTS `ch_chamado`;
CREATE TABLE `ch_chamado` (
  `COD_CHAMADO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `COD_CLI` int(10) DEFAULT NULL,
  `TITULO` varchar(255) DEFAULT NULL,
  `DESCRICAO` longtext,
  `SIGILOSO` longtext,
  `SITUACAO` varchar(50) DEFAULT NULL,
  `PRIORIDADE` varchar(50) DEFAULT NULL,
  `ARQUIVO_ANEXO` varchar(250) DEFAULT NULL,
  `COD_TODOLIST` int(10) DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_DTT_UPD` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_UPD` varchar(50) DEFAULT NULL,
  `SYS_DTT_DESBLOQUEIO` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_DESBLOQUEIO` varchar(50) DEFAULT NULL,
  `DESBLOQUEIO` longtext,
  `DESBLOQUEIO_SIGI` longtext,
  `HORAS` double(15,5) DEFAULT NULL,
  `VALOR` double(15,5) DEFAULT NULL,
  `EXTRA` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`COD_CHAMADO`),
  KEY `COD_CATEGORIA` (`COD_CATEGORIA`),
  KEY `COD_CLI` (`COD_CLI`),
  KEY `PRIORIDADE` (`PRIORIDADE`),
  KEY `SITUACAO` (`SITUACAO`),
  KEY `SYS_ID_USUARIO_INS` (`SYS_ID_USUARIO_INS`),
  KEY `SYS_ID_USUARIO_INS1` (`SYS_ID_USUARIO_UPD`),
  KEY `TITULO` (`TITULO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ch_chamado`
--

/*!40000 ALTER TABLE `ch_chamado` DISABLE KEYS */;
/*!40000 ALTER TABLE `ch_chamado` ENABLE KEYS */;


--
-- Definition of table `contrato`
--

DROP TABLE IF EXISTS `contrato`;
CREATE TABLE `contrato` (
  `COD_CONTRATO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CONTRATO_PAI` int(10) DEFAULT NULL,
  `TITULO` varchar(250) DEFAULT NULL,
  `CODIFICACAO` varchar(100) DEFAULT NULL,
  `SITUACAO` varchar(50) DEFAULT 'ABERTO' COMMENT 'ABERTO, FATURADO',
  `CODIGO` int(11) DEFAULT NULL,
  `TIPO` varchar(20) DEFAULT NULL,
  `OBS` longtext,
  `DT_INI` datetime DEFAULT NULL,
  `DT_FIM` datetime DEFAULT NULL,
  `DT_ASSINATURA` datetime DEFAULT NULL,
  `DOC_CONTRATO` varchar(250) DEFAULT NULL,
  `NUM_PARC` int(10) DEFAULT NULL,
  `VLR_TOTAL` double(15,2) DEFAULT NULL,
  `FREQUENCIA` varchar(20) DEFAULT NULL,
  `DT_BASE_VCTO` datetime DEFAULT NULL,
  `TP_RENOVACAO` varchar(30) DEFAULT 'RENOVAVEL' COMMENT 'RENOVAVEL, NAO_RENOVAVEL, AUTO_RENOVAVEL',
  `TP_COBRANCA` varchar(20) DEFAULT 'PAGAR' COMMENT 'PAGAR, RECEBER',
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DT_INSERCAO` datetime DEFAULT NULL,
  `SYS_INS_ID_USUARIO` varchar(120) DEFAULT NULL,
  `SYS_DT_ALTERACAO` datetime DEFAULT NULL,
  `SYS_ALT_ID_USUARIO` varchar(120) DEFAULT NULL,
  `ALIQ_ISSQN_SERVICO` double(15,3) DEFAULT NULL,
  `VLR_PARCELA` double(15,2) DEFAULT NULL,
  `TP_REAJUSTE` varchar(20) DEFAULT NULL,
  `FATOR_REAJUSTE` double(15,3) DEFAULT NULL,
  `DT_BASE_CONTRATO` date DEFAULT NULL,
  `DTT_VLR_REAJUSTE` datetime DEFAULT NULL,
  `DTT_PROX_REAJUSTE` datetime DEFAULT NULL,
  `DTT_ULT_REAJUSTE` datetime DEFAULT NULL,
  `SYS_DEL_ID_USUARIO` varchar(120) DEFAULT NULL,
  `SYS_DT_CANCEL` datetime DEFAULT NULL,
  `MOTIVO_CANC_DEL` longtext,
  PRIMARY KEY (`COD_CONTRATO`),
  KEY `DT_ASSINATURA` (`DT_ASSINATURA`),
  KEY `DT_FIM` (`DT_FIM`),
  KEY `ID` (`DT_INI`),
  KEY `NUM` (`CODIFICACAO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `contrato`
--

/*!40000 ALTER TABLE `contrato` DISABLE KEYS */;
/*!40000 ALTER TABLE `contrato` ENABLE KEYS */;


--
-- Definition of table `contrato_anexo`
--

DROP TABLE IF EXISTS `contrato_anexo`;
CREATE TABLE `contrato_anexo` (
  `COD_ANEXO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CONTRATO` int(10) DEFAULT NULL,
  `ARQUIVO` varchar(250) DEFAULT NULL,
  `DESCRICAO` longtext,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_ANEXO`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `contrato_anexo`
--

/*!40000 ALTER TABLE `contrato_anexo` DISABLE KEYS */;
INSERT INTO `contrato_anexo` (`COD_ANEXO`,`COD_CONTRATO`,`ARQUIVO`,`DESCRICAO`,`SYS_DTT_INS`,`SYS_ID_USUARIO_INS`) VALUES 
 (2,1,'{n6uu00fqdrma104smv75fj66d0_150213193540}_2.txt','','2013-02-21 16:41:54','demo'),
 (5,4,'{13s2tj9644gs4nno832jnd37v1_190313180451}_LogoMarca_UBRAFE_ReciboAvulso.gif','UBRAFE','2013-03-19 18:05:09','demo'),
 (6,5,'{13s2tj9644gs4nno832jnd37v1_190313180451}_LogoMarca_UBRAFE_ReciboAvulso.gif','UBRAFE','2013-03-19 18:07:55','demo'),
 (9,2,'{2tikph5u3gfin03li19vbu0bd7_210213164958}_Brazil.gif','','2013-05-02 17:45:09','demo');
/*!40000 ALTER TABLE `contrato_anexo` ENABLE KEYS */;


--
-- Definition of table `contrato_parcela`
--

DROP TABLE IF EXISTS `contrato_parcela`;
CREATE TABLE `contrato_parcela` (
  `COD_CONTRATO_PARCELA` int(11) NOT NULL AUTO_INCREMENT,
  `COD_CONTRATO` int(11) DEFAULT NULL,
  `VLR_PARCELA` double(15,2) DEFAULT NULL,
  `DT_VENC` date DEFAULT NULL,
  PRIMARY KEY (`COD_CONTRATO_PARCELA`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `contrato_parcela`
--

/*!40000 ALTER TABLE `contrato_parcela` DISABLE KEYS */;
INSERT INTO `contrato_parcela` (`COD_CONTRATO_PARCELA`,`COD_CONTRATO`,`VLR_PARCELA`,`DT_VENC`) VALUES 
 (11,1,10.99,'2013-02-01'),
 (12,1,10.99,'2013-02-02'),
 (13,1,10.99,'2013-02-03'),
 (14,1,10.99,'2013-02-04'),
 (19,3,1000.00,'2013-03-12'),
 (20,3,1000.00,'2013-03-27'),
 (21,3,1000.00,'2013-04-11'),
 (22,3,1000.00,'2013-04-26'),
 (23,3,1000.00,'2013-05-11'),
 (24,3,1000.00,'2013-05-26'),
 (25,3,1000.00,'2013-06-10'),
 (26,3,1000.00,'2013-06-25'),
 (27,3,1000.00,'2013-07-10'),
 (28,3,1000.00,'2013-07-25'),
 (33,4,9.98,'2013-03-05'),
 (34,4,9.98,'2013-03-06'),
 (35,5,9.98,'2013-03-07'),
 (36,5,9.98,'2013-03-08'),
 (41,6,10.00,'2013-05-01'),
 (46,2,5000.00,'2013-02-21'),
 (47,2,5000.00,'2013-02-22'),
 (48,2,5000.00,'2013-02-23'),
 (49,2,5000.00,'2013-02-24');
/*!40000 ALTER TABLE `contrato_parcela` ENABLE KEYS */;


--
-- Definition of table `contrato_servico`
--

DROP TABLE IF EXISTS `contrato_servico`;
CREATE TABLE `contrato_servico` (
  `COD_CONTRATO_SERVICO` int(11) NOT NULL AUTO_INCREMENT,
  `COD_CONTRATO` int(11) NOT NULL,
  `COD_SERVICO` int(11) NOT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `QTDE` int(11) NOT NULL DEFAULT '0',
  `VALOR` double(15,5) DEFAULT '0.00000',
  PRIMARY KEY (`COD_CONTRATO_SERVICO`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `contrato_servico`
--

/*!40000 ALTER TABLE `contrato_servico` DISABLE KEYS */;
INSERT INTO `contrato_servico` (`COD_CONTRATO_SERVICO`,`COD_CONTRATO`,`COD_SERVICO`,`DESCRICAO`,`QTDE`,`VALOR`) VALUES 
 (1,1,123,'Locação de Modem 3G',1,0.00000),
 (3,3,121,'02798 - Licenciamento ou cessão de direito de uso de programas de computador, inlusive distribuição',1,0.00000),
 (5,4,118,'Locação de Coletor de Dados',9,9.98000),
 (6,5,118,'Locação de Coletor de Dados',9,9.98000),
 (8,6,118,'Locação de Coletor de Dados',1,0.00000),
 (10,2,121,'02798 - Licenciamento ou cessão de direito de uso de programas de computador, inlusive distribuição',1,0.00000);
/*!40000 ALTER TABLE `contrato_servico` ENABLE KEYS */;


--
-- Definition of table `en_alternativa`
--

DROP TABLE IF EXISTS `en_alternativa`;
CREATE TABLE `en_alternativa` (
  `COD_ALTERNATIVA` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `COD_QUESTAO` int(11) DEFAULT NULL,
  `ALTERNATIVA` varchar(250) DEFAULT NULL,
  `TIPO` varchar(10) DEFAULT 'OBJETIVA',
  `NUM_VOTOS` int(11) DEFAULT '0',
  `RESPOSTAS` text,
  PRIMARY KEY (`COD_ALTERNATIVA`),
  KEY `EN_ALTERNATIVACOD_QUESTAO` (`COD_QUESTAO`),
  KEY `NUM_VOTOS` (`NUM_VOTOS`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `en_alternativa`
--

/*!40000 ALTER TABLE `en_alternativa` DISABLE KEYS */;
/*!40000 ALTER TABLE `en_alternativa` ENABLE KEYS */;


--
-- Definition of table `en_enquete`
--

DROP TABLE IF EXISTS `en_enquete`;
CREATE TABLE `en_enquete` (
  `COD_ENQUETE` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `TITULO` varchar(250) DEFAULT NULL,
  `TIPO_ENTIDADE` varchar(50) DEFAULT 'ENT_COLABORADOR',
  `DT_INI` datetime DEFAULT NULL,
  `DT_FIM` datetime DEFAULT NULL,
  `QUORUM` int(10) unsigned NOT NULL COMMENT 'Valor referente ao a exibiçao minima da enquete',
  PRIMARY KEY (`COD_ENQUETE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `en_enquete`
--

/*!40000 ALTER TABLE `en_enquete` DISABLE KEYS */;
/*!40000 ALTER TABLE `en_enquete` ENABLE KEYS */;


--
-- Definition of table `en_log`
--

DROP TABLE IF EXISTS `en_log`;
CREATE TABLE `en_log` (
  `COD_LOG` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `COD_ENQUETE` int(11) DEFAULT NULL,
  `ID_USUARIO` varchar(50) DEFAULT NULL,
  `IP` varchar(50) DEFAULT NULL,
  `DATA` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_LOG`),
  KEY `EN_LOGCOD_QUESTAO` (`COD_ENQUETE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `en_log`
--

/*!40000 ALTER TABLE `en_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `en_log` ENABLE KEYS */;


--
-- Definition of table `en_questao`
--

DROP TABLE IF EXISTS `en_questao`;
CREATE TABLE `en_questao` (
  `COD_QUESTAO` int(11) NOT NULL AUTO_INCREMENT,
  `COD_ENQUETE` int(11) DEFAULT NULL,
  `ORDEM` int(11) DEFAULT NULL,
  `QUESTAO` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`COD_QUESTAO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `en_questao`
--

/*!40000 ALTER TABLE `en_questao` DISABLE KEYS */;
/*!40000 ALTER TABLE `en_questao` ENABLE KEYS */;


--
-- Definition of table `ent_cliente`
--

DROP TABLE IF EXISTS `ent_cliente`;
CREATE TABLE `ent_cliente` (
  `COD_CLIENTE` int(10) NOT NULL AUTO_INCREMENT,
  `SIGLA_PONTO` varchar(5) DEFAULT NULL,
  `RAZAO_SOCIAL` varchar(250) DEFAULT NULL,
  `NOME_FANTASIA` varchar(250) DEFAULT NULL,
  `NOME_COMERCIAL` varchar(250) DEFAULT NULL,
  `NUM_DOC` varchar(20) DEFAULT NULL,
  `TIPO_DOC` char(1) DEFAULT NULL,
  `INSC_ESTADUAL` varchar(20) DEFAULT NULL,
  `FONE_2` varchar(250) DEFAULT NULL,
  `FAX` varchar(250) DEFAULT NULL,
  `EMAIL` varchar(250) DEFAULT NULL,
  `SITE` varchar(250) DEFAULT NULL,
  `CONTATO` varchar(250) DEFAULT NULL,
  `DT_CADASTRO` datetime DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DT_ALTERACAO` datetime DEFAULT NULL,
  `ENTR_ENDERECO` varchar(250) DEFAULT NULL,
  `ENTR_NUMERO` varchar(20) DEFAULT NULL,
  `ENTR_COMPLEMENTO` varchar(100) DEFAULT NULL,
  `ENTR_CEP` varchar(20) DEFAULT NULL,
  `ENTR_BAIRRO` varchar(250) DEFAULT NULL,
  `ENTR_CIDADE` varchar(250) DEFAULT NULL,
  `ENTR_ESTADO` varchar(50) DEFAULT NULL,
  `ENTR_PAIS` varchar(250) DEFAULT NULL,
  `FATURA_NUMERO` varchar(20) DEFAULT NULL,
  `FATURA_CEP` varchar(20) DEFAULT NULL,
  `FATURA_BAIRRO` varchar(250) DEFAULT NULL,
  `FATURA_CIDADE` varchar(250) DEFAULT NULL,
  `FATURA_ESTADO` varchar(50) DEFAULT NULL,
  `FATURA_PAIS` varchar(250) DEFAULT NULL,
  `COBR_ENDERECO` varchar(250) DEFAULT NULL,
  `COBR_NUMERO` varchar(20) DEFAULT NULL,
  `COBR_COMPLEMENTO` varchar(100) DEFAULT NULL,
  `COBR_CEP` varchar(20) DEFAULT NULL,
  `COBR_BAIRRO` varchar(250) DEFAULT NULL,
  `COBR_CIDADE` varchar(250) DEFAULT NULL,
  `COBR_ESTADO` varchar(50) DEFAULT NULL,
  `COBR_PAIS` varchar(250) DEFAULT NULL,
  `CLASSE` varchar(20) DEFAULT NULL,
  `INSC_MUNICIPAL` varchar(20) DEFAULT NULL,
  `COD_ANTIGO` int(10) DEFAULT NULL,
  `OLD_FONE_1` varchar(250) DEFAULT NULL,
  `OLD_FATURA_ENDERECO` varchar(250) DEFAULT NULL,
  `OLD_FATURA_COMPLEMENTO` varchar(100) DEFAULT NULL,
  `FONE_1` varchar(25) DEFAULT NULL,
  `FATURA_ENDERECO` varchar(190) DEFAULT NULL,
  `FATURA_COMPLEMENTO` varchar(40) DEFAULT NULL,
  `TEM_ALIQ_IRPJ` tinyint(1) DEFAULT '0',
  `ALIQ_IRPJ` double(15,3) DEFAULT NULL,
  `TIPO_CHAMADO` varchar(50) DEFAULT 'LIVRE',
  `COD_BANCO` int(11) DEFAULT NULL,
  `AGENCIA` varchar(50) DEFAULT NULL,
  `CONTA` varchar(50) DEFAULT NULL,
  `FAVORECIDO` varchar(120) DEFAULT NULL,
  `OBS` longtext,
  PRIMARY KEY (`COD_CLIENTE`),
  UNIQUE KEY `SIGLA_PONTO` (`SIGLA_PONTO`),
  KEY `CLASSE` (`CLASSE`),
  KEY `CONTATO` (`CONTATO`),
  KEY `ndxCNPJ` (`NUM_DOC`),
  KEY `ndxEMAIL` (`EMAIL`),
  KEY `NOME_COMERCIAL` (`NOME_COMERCIAL`),
  KEY `NOME_FANTASIA` (`NOME_FANTASIA`),
  KEY `RAZAO_SOCIAL` (`RAZAO_SOCIAL`),
  KEY `TIPO_DOC` (`TIPO_DOC`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ent_cliente`
--

/*!40000 ALTER TABLE `ent_cliente` DISABLE KEYS */;
INSERT INTO `ent_cliente` (`COD_CLIENTE`,`SIGLA_PONTO`,`RAZAO_SOCIAL`,`NOME_FANTASIA`,`NOME_COMERCIAL`,`NUM_DOC`,`TIPO_DOC`,`INSC_ESTADUAL`,`FONE_2`,`FAX`,`EMAIL`,`SITE`,`CONTATO`,`DT_CADASTRO`,`DT_INATIVO`,`SYS_DT_ALTERACAO`,`ENTR_ENDERECO`,`ENTR_NUMERO`,`ENTR_COMPLEMENTO`,`ENTR_CEP`,`ENTR_BAIRRO`,`ENTR_CIDADE`,`ENTR_ESTADO`,`ENTR_PAIS`,`FATURA_NUMERO`,`FATURA_CEP`,`FATURA_BAIRRO`,`FATURA_CIDADE`,`FATURA_ESTADO`,`FATURA_PAIS`,`COBR_ENDERECO`,`COBR_NUMERO`,`COBR_COMPLEMENTO`,`COBR_CEP`,`COBR_BAIRRO`,`COBR_CIDADE`,`COBR_ESTADO`,`COBR_PAIS`,`CLASSE`,`INSC_MUNICIPAL`,`COD_ANTIGO`,`OLD_FONE_1`,`OLD_FATURA_ENDERECO`,`OLD_FATURA_COMPLEMENTO`,`FONE_1`,`FATURA_ENDERECO`,`FATURA_COMPLEMENTO`,`TEM_ALIQ_IRPJ`,`ALIQ_IRPJ`,`TIPO_CHAMADO`,`COD_BANCO`,`AGENCIA`,`CONTA`,`FAVORECIDO`,`OBS`) VALUES 
 (1,'DEMO','DEMOCLEAN','DEMOCLEAN','DEMOCLEAN',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,'2016-04-12 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'LIVRE',1,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `ent_cliente` ENABLE KEYS */;


--
-- Definition of table `ent_colaborador`
--

DROP TABLE IF EXISTS `ent_colaborador`;
CREATE TABLE `ent_colaborador` (
  `COD_COLABORADOR` int(10) NOT NULL AUTO_INCREMENT,
  `COD_ANTIGO` int(10) DEFAULT NULL,
  `NOME` varchar(250) DEFAULT NULL,
  `CPF` varchar(20) DEFAULT NULL,
  `RG` varchar(20) DEFAULT NULL,
  `FONE_1` varchar(250) DEFAULT NULL,
  `FONE_2` varchar(250) DEFAULT NULL,
  `CELULAR` varchar(250) DEFAULT NULL,
  `EMAIL` varchar(250) DEFAULT NULL,
  `EMAIL_EXTRA` varchar(250) DEFAULT NULL,
  `ENDERECO` varchar(250) DEFAULT NULL,
  `NUMERO` varchar(20) DEFAULT NULL,
  `COMPLEMENTO` varchar(100) DEFAULT NULL,
  `CEP` varchar(20) DEFAULT NULL,
  `BAIRRO` varchar(250) DEFAULT NULL,
  `CIDADE` varchar(250) DEFAULT NULL,
  `ESTADO` varchar(50) DEFAULT NULL,
  `PAIS` varchar(250) DEFAULT NULL,
  `DT_CADASTRO` datetime DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `COD_CARGO` int(10) DEFAULT NULL,
  `ID_CLASSE` int(10) DEFAULT NULL,
  `ESCOLARIDADE` longtext,
  `CURSOS` longtext,
  `COMPETENCIAS` longtext,
  `RECEBIMENTOS_MES` double(15,5) DEFAULT NULL,
  `TRIBUTACAO_MEDIA_MES` double(15,5) DEFAULT NULL,
  `TRIBUTACAO_NOMINAL_MES` double(15,5) DEFAULT NULL,
  `CUSTO_HORA` double(15,5) DEFAULT NULL,
  `DT_NASC` date DEFAULT NULL,
  `ORGAO_EXPEDITOR` varchar(10) DEFAULT NULL,
  `FILIAL_VINCULADA` varchar(50) DEFAULT NULL,
  `DT_CONTRATACAO` date DEFAULT NULL,
  `DT_DESLIGAMENTO` date DEFAULT NULL,
  `SETOR` varchar(250) DEFAULT NULL,
  `MSN_MESSENGER` varchar(250) DEFAULT NULL,
  `REMUNERACAO_MENSAL` double DEFAULT NULL,
  `REGIME` varchar(50) DEFAULT NULL,
  `DT_ASSIN_CARTEIRA` date DEFAULT NULL,
  `UTILIZA_VT` varchar(10) DEFAULT NULL,
  `VLR_VT_UNIT` double DEFAULT NULL,
  `QTDE_VT_DIA` int(11) DEFAULT NULL,
  `UTILIZA_VRVA` varchar(10) DEFAULT NULL,
  `VLR_VRVA` double DEFAULT NULL,
  `AUXILIO_ESTUDO` varchar(10) DEFAULT NULL,
  `COD_BANCO` int(11) DEFAULT NULL,
  `AGENCIA` varchar(50) DEFAULT NULL,
  `CONTA` varchar(50) DEFAULT NULL,
  `FORMA_PGTO` varchar(50) DEFAULT NULL,
  `FOTO` varchar(250) DEFAULT NULL,
  `FILIACAO_PAI` varchar(250) DEFAULT NULL,
  `FILIACAO_MAE` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`COD_COLABORADOR`),
  KEY `EMAIL` (`EMAIL_EXTRA`),
  KEY `ndxCNPJ` (`CPF`),
  KEY `ndxEMAIL` (`EMAIL`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ent_colaborador`
--

/*!40000 ALTER TABLE `ent_colaborador` DISABLE KEYS */;
INSERT INTO `ent_colaborador` (`COD_COLABORADOR`,`COD_ANTIGO`,`NOME`,`CPF`,`RG`,`FONE_1`,`FONE_2`,`CELULAR`,`EMAIL`,`EMAIL_EXTRA`,`ENDERECO`,`NUMERO`,`COMPLEMENTO`,`CEP`,`BAIRRO`,`CIDADE`,`ESTADO`,`PAIS`,`DT_CADASTRO`,`DT_INATIVO`,`COD_CARGO`,`ID_CLASSE`,`ESCOLARIDADE`,`CURSOS`,`COMPETENCIAS`,`RECEBIMENTOS_MES`,`TRIBUTACAO_MEDIA_MES`,`TRIBUTACAO_NOMINAL_MES`,`CUSTO_HORA`,`DT_NASC`,`ORGAO_EXPEDITOR`,`FILIAL_VINCULADA`,`DT_CONTRATACAO`,`DT_DESLIGAMENTO`,`SETOR`,`MSN_MESSENGER`,`REMUNERACAO_MENSAL`,`REGIME`,`DT_ASSIN_CARTEIRA`,`UTILIZA_VT`,`VLR_VT_UNIT`,`QTDE_VT_DIA`,`UTILIZA_VRVA`,`VLR_VRVA`,`AUXILIO_ESTUDO`,`COD_BANCO`,`AGENCIA`,`CONTA`,`FORMA_PGTO`,`FOTO`,`FILIACAO_PAI`,`FILIACAO_MAE`) VALUES 
 (1,NULL,'_athenas',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PORTO ALEGRE',NULL,NULL,NULL,NULL,0,'CLT',NULL,NULL,0,NULL,NULL,0,NULL,1,NULL,NULL,'CHEQUE','{euhjakbjgddedliqvoq9pf3uv4_120416110006}_FOTO.jpg',NULL,NULL),
 (2,NULL,'_admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PORTO ALEGRE',NULL,NULL,NULL,NULL,0,'CLT',NULL,NULL,0,NULL,NULL,0,NULL,1,NULL,NULL,'CHEQUE','{euhjakbjgddedliqvoq9pf3uv4_120416110020}_FOTO.jpg',NULL,NULL),
 (3,NULL,'ALESSANDER PIRES OLIVEIRA','99299999999','9999832251','51-9161.0705','51-3779.2824','51-9161.0705','athaless@gmail.com',NULL,'Rua Cap. Arisoly Vargas','55','ap 707','90680-560','Glória','Porto Alegre','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1973-06-25','ssp','PORTO ALEGRE','1996-08-26',NULL,'DESENVOLVIMENTO',NULL,0,'SOCIO',NULL,NULL,0,NULL,NULL,0,NULL,2,'3115','10382-6','DEPOSITO','{euhjakbjgddedliqvoq9pf3uv4_120416105949}_FOTO.jpg','Irineu de Souza Oliveira','Alzira Maria Pires Oliveira');
/*!40000 ALTER TABLE `ent_colaborador` ENABLE KEYS */;


--
-- Definition of table `ent_fornecedor`
--

DROP TABLE IF EXISTS `ent_fornecedor`;
CREATE TABLE `ent_fornecedor` (
  `COD_FORNECEDOR` int(10) NOT NULL AUTO_INCREMENT,
  `RAZAO_SOCIAL` varchar(250) DEFAULT NULL,
  `NOME_FANTASIA` varchar(250) DEFAULT NULL,
  `NOME_COMERCIAL` varchar(250) DEFAULT NULL,
  `NUM_DOC` varchar(20) DEFAULT NULL,
  `TIPO_DOC` char(1) DEFAULT NULL,
  `INSC_ESTADUAL` varchar(20) DEFAULT NULL,
  `FONE_1` varchar(250) DEFAULT NULL,
  `FONE_2` varchar(250) DEFAULT NULL,
  `FAX` varchar(250) DEFAULT NULL,
  `EMAIL` varchar(250) DEFAULT NULL,
  `SITE` varchar(250) DEFAULT NULL,
  `CONTATO` varchar(250) DEFAULT NULL,
  `DT_CADASTRO` datetime DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DT_ALTERACAO` datetime DEFAULT NULL,
  `ENTR_ENDERECO` varchar(250) DEFAULT NULL,
  `ENTR_NUMERO` varchar(20) DEFAULT NULL,
  `ENTR_COMPLEMENTO` varchar(100) DEFAULT NULL,
  `ENTR_CEP` varchar(20) DEFAULT NULL,
  `ENTR_BAIRRO` varchar(250) DEFAULT NULL,
  `ENTR_CIDADE` varchar(250) DEFAULT NULL,
  `ENTR_ESTADO` varchar(50) DEFAULT NULL,
  `ENTR_PAIS` varchar(250) DEFAULT NULL,
  `FATURA_ENDERECO` varchar(250) DEFAULT NULL,
  `FATURA_NUMERO` varchar(20) DEFAULT NULL,
  `FATURA_COMPLEMENTO` varchar(100) DEFAULT NULL,
  `FATURA_CEP` varchar(20) DEFAULT NULL,
  `FATURA_BAIRRO` varchar(250) DEFAULT NULL,
  `FATURA_CIDADE` varchar(250) DEFAULT NULL,
  `FATURA_ESTADO` varchar(50) DEFAULT NULL,
  `FATURA_PAIS` varchar(250) DEFAULT NULL,
  `COBR_ENDERECO` varchar(250) DEFAULT NULL,
  `COBR_NUMERO` varchar(20) DEFAULT NULL,
  `COBR_COMPLEMENTO` varchar(100) DEFAULT NULL,
  `COBR_CEP` varchar(20) DEFAULT NULL,
  `COBR_BAIRRO` varchar(250) DEFAULT NULL,
  `COBR_CIDADE` varchar(250) DEFAULT NULL,
  `COBR_ESTADO` varchar(50) DEFAULT NULL,
  `COBR_PAIS` varchar(250) DEFAULT NULL,
  `INSC_MUNICIPAL` varchar(20) DEFAULT NULL,
  `COD_ANTIGO` int(10) DEFAULT NULL,
  `TEM_ALIQ_IRPJ` tinyint(1) DEFAULT '0',
  `ALIQ_IRPJ` double(15,3) DEFAULT NULL,
  `COD_BANCO` int(11) DEFAULT NULL,
  `AGENCIA` varchar(50) DEFAULT NULL,
  `CONTA` varchar(50) DEFAULT NULL,
  `FAVORECIDO` varchar(120) DEFAULT NULL,
  `OBS` longtext,
  PRIMARY KEY (`COD_FORNECEDOR`),
  KEY `CONTATO` (`CONTATO`),
  KEY `ndxCNPJ` (`NUM_DOC`),
  KEY `ndxEMAIL` (`EMAIL`),
  KEY `NOME_COMERCIAL` (`NOME_COMERCIAL`),
  KEY `NOME_FANTASIA` (`NOME_FANTASIA`),
  KEY `RAZAO_SOCIAL` (`RAZAO_SOCIAL`),
  KEY `TIPO_DOC` (`TIPO_DOC`)
) ENGINE=InnoDB AUTO_INCREMENT=340 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ent_fornecedor`
--

/*!40000 ALTER TABLE `ent_fornecedor` DISABLE KEYS */;
INSERT INTO `ent_fornecedor` (`COD_FORNECEDOR`,`RAZAO_SOCIAL`,`NOME_FANTASIA`,`NOME_COMERCIAL`,`NUM_DOC`,`TIPO_DOC`,`INSC_ESTADUAL`,`FONE_1`,`FONE_2`,`FAX`,`EMAIL`,`SITE`,`CONTATO`,`DT_CADASTRO`,`DT_INATIVO`,`SYS_DT_ALTERACAO`,`ENTR_ENDERECO`,`ENTR_NUMERO`,`ENTR_COMPLEMENTO`,`ENTR_CEP`,`ENTR_BAIRRO`,`ENTR_CIDADE`,`ENTR_ESTADO`,`ENTR_PAIS`,`FATURA_ENDERECO`,`FATURA_NUMERO`,`FATURA_COMPLEMENTO`,`FATURA_CEP`,`FATURA_BAIRRO`,`FATURA_CIDADE`,`FATURA_ESTADO`,`FATURA_PAIS`,`COBR_ENDERECO`,`COBR_NUMERO`,`COBR_COMPLEMENTO`,`COBR_CEP`,`COBR_BAIRRO`,`COBR_CIDADE`,`COBR_ESTADO`,`COBR_PAIS`,`INSC_MUNICIPAL`,`COD_ANTIGO`,`TEM_ALIQ_IRPJ`,`ALIQ_IRPJ`,`COD_BANCO`,`AGENCIA`,`CONTA`,`FAVORECIDO`,`OBS`) VALUES 
 (2,'BRASIL TELECOM','BRASIL TELECOM','BRASIL TELECOM','76.535.764/0002-24','J','096/2.845.833','102',NULL,NULL,NULL,'http://www.brasiltelecom.com.br/',NULL,'2007-08-16 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (3,'FRUTEIRA DO DEDE','FRUTEIRA DO DEDE','FRUTEIRA DO DEDE',NULL,'F',NULL,'51-3333 2336',NULL,NULL,NULL,NULL,NULL,'2007-08-16 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (4,'INSTITUTO DE ENSINO E TECNOLOGIA','INSTITUTO DE ENSINO E TECNOLOGIA','INETEC',NULL,'J',NULL,'51-33114228',NULL,NULL,NULL,NULL,NULL,'2007-08-16 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Rua Doutor Timoteo','475','102','90570041','Floresta','Porto Alegre','RS',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (5,'SUL-AMERICANA TECNOLOGIA E INFORMATICA LTDA','SOUTHTECH SUPER DATACENTER','SOUTHTECH','02.639.055/0001-71','J','096/3158813','51-30262006',NULL,NULL,NULL,NULL,NULL,'2007-08-16 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (6,'MINISTERIO DA FAZENDA','MINISTERIO DA FAZENDA','MINISTERIO DA FAZENDA',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-08-16 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (7,'COMPANHIA ESTADUAL DE DISTRIBUIÇÃO DE ENERGIA ELETRICA','CEEE','CEEE','08.467.115/0001-00','J','096/3156659','51-33824900','51-33824172',NULL,NULL,NULL,NULL,'2007-08-21 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (8,'LM CORRETORA DE IMOVEIS','LM CORRETORA DE IMOVEIS','LM CORRETORA DE IMOVEIS','89.975.791/0001-89','J',NULL,'51-33327707','51-30190117',NULL,NULL,NULL,NULL,'2007-08-21 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (9,'LOCAWEB LTDA','LOCAWEB','LOCAWEB','02.351.877/0001-52','J',NULL,'IDC 40620203','Luis 98926408',NULL,NULL,'www.locaweb.com.br','Luis Debastiani','2007-08-24 00:00:00',NULL,NULL,'Av. Pres. Juscelino Kubitschek,','1830','10 andar - Torre 4','04543900','Vila Nova','São Paulo','SP','BRASIL','Av. Pres. Juscelino Kubitschek,','1830','10 andar - Torre 4','04543900','Vila Nova','São Paulo','SP','BRASIL','Av. Pres. Juscelino Kubitschek,','1830','10 andar - Torre 4','04543900','Vila Nova','São Paulo','SP','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (10,'JURANDIR DA SILVEIRA','BUENO EXPRESS MOTOBOY','BUENO EXPRESS',NULL,'F',NULL,'51-30617366',NULL,NULL,NULL,NULL,NULL,'2007-08-28 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (11,'BANCO ITAU S.A.','BANCO ITAU','BANCO ITAU',NULL,'J',NULL,'51-33284430',NULL,NULL,NULL,NULL,NULL,'2007-08-28 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'AV JOAO WALLING','1800',NULL,'91349-900','PASSO D AREIA','PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (12,'GOVERNO FEDERAL','GOVERNO FEDERAL','GOVERNO FEDERAL',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-08-28 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (13,'TAXI','TAXI','TAXI',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-08-28 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (14,'B2W - COMPANHIA GLOBAL DE VAREJO','AMERICANAS.COM','AMERICANAS.COM','00.776.574/0007-41','J','206.245.559.115','4003-4848',NULL,NULL,NULL,NULL,NULL,'2007-08-29 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (15,'PIZZARIA BIANCA','PIZZARIA BIANCA','PIZZARIA BIANCA',NULL,'F',NULL,'51-33285644',NULL,NULL,NULL,NULL,NULL,'2007-08-29 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Av Plínio Brasil Milano','1817',NULL,NULL,'Higienópolis','Porto Alegre','RS','Brasil',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (16,'NUCLEO DE INFORMACAO E COORDENACAO DO PONTO BR','REGISTRO.BR','NIC.BR','05.506.560/0001-36','J',NULL,'11-55093500',NULL,NULL,NULL,'www.registro.br',NULL,'2007-08-30 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'AV DAS NACOES UNIDAS','11541','7o ANDAR','04578000',NULL,'SAO PAULO','SP','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (17,'EMPRESA BRASILEIRA DE CORREIOS E TELEGRAFOS','EBCT','CORREIOS','73.409.120/0001-10','J','ISENTA','51-33812291',NULL,NULL,NULL,'www.ebct.com.br',NULL,'2007-09-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'AV. PROTASIO ALVES','2946',NULL,'90410-971','PETROPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (18,'CCA CONSULTORIA E AUDITORIA SS LTDA','CCA','CCA','91.344.374/0001-80','J',NULL,'51-30271700',NULL,NULL,NULL,NULL,'MISSAK','2007-09-03 00:00:00',NULL,NULL,'RUA VISCONE DO RIO BRANCO','477',NULL,'90220-231','FLORESTA','PORTO ALEGRE','RIO GRANDE DO SUL','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (19,'IMOBILIARIA SUMARE LTDA','IMOBILIARIA SUMARE','IMOBILIARIA SUMARE','88.804.273/0001-30','J',NULL,'51-32240740',NULL,NULL,'imobsumare@via-rs.net','www.imobiliariasumare.com.br',NULL,'2007-09-04 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PRÇ PROF. SAINT PASTOUS','85',NULL,'90050-170',NULL,'PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (20,'ATP - ASSOC DAS EMPRSAS DE TRANSP DE PASSAGEIROS DE P.A','ATP','ATP','90.298.993/0001-12','J',NULL,'51-33348155',NULL,NULL,NULL,NULL,NULL,'2007-09-06 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'AV PROTASIO ALVES','3885',NULL,'91310-002','PETROPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (21,'SECRETARIA MUNICIPAL DA FAZENDA - PORTO ALEGRE','SECRETARIA MUNICIPAL DA FAZENDA - PORTO ALEGRE','SECRETARIA MUNICIPAL DA FAZENDA - PORTO ALEGRE',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-09-10 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (22,'BANRISUL','BANRISUL','BANRISUL',NULL,'J',NULL,'5133374066',NULL,NULL,NULL,NULL,'ALAN','2007-09-10 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (23,'FABESUL  DISTRIBUIDORA LTDA','FABESUL','FABESUL','89.054.050/0001-65','J','096/0758062','51-33578000',NULL,NULL,NULL,'www.fabesul.com.br','Mônica','2007-09-12 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'RUA JULIO KOVALSKI','225',NULL,'91040-380','JARDOM SÃO PEDRO','PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (24,'CONTAL CONTABILIDADE LTDA','CONTAL','CONTAL','90.511.882/0001-42','J',NULL,'51-33614560','51-33623499',NULL,'contal@contalcontabilidade.com.br','http://www.contalcontabilidade.com.br','PAULO','2007-09-13 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'AV ASSIS BRASIL','979',NULL,'91010-004','PASSO D AREIA','PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (25,'FERRAGEM BAIRRO CHIC LTDA','FERRAGEM BAIRRO CHIC','FERRAGEM BAIRRO CHIC',NULL,'J',NULL,'51-33303170',NULL,NULL,NULL,NULL,NULL,'2007-09-13 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (26,'NORTON ESTEVES CALAZANS JUNIOR','NORTON - DESIGNER','NORTON - DESIGNER','741.164.280-00','F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-09-17 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (28,'TAM','TAM','TAM',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-09-26 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (29,'COMPUJOB','COMPUJOB','COMPUJOB',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-09-26 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (30,'MEGAMIDIA','MEGAMIDIA','MEGAMIDIA',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-09-26 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (31,'NETWORK SOLUTIONS','NETWORK SOLUTIONS','NETWORK SOLUTIONS',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-09-26 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (32,'SINDICATO DOS TRABALHADORES EM PROCESSAMENTO DE DADOS NO ESTADO DO RGS','SINDPPD-RS','SINDPPD-RS','90.273.442/0001-02','J',NULL,NULL,NULL,NULL,NULL,'www.sindppd-rs.org.br/',NULL,'2007-09-28 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'RUA AFONSO PENA','251',NULL,'90160-020','ZENHA','PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (33,'EMBRATEL','EMBRATEL','EMBRATEL',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-10-01 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (34,'SULLCOPY INFORMATICA COM E REP. LTDA','SULLCOPY INFORMATICA COM E REP. LTDA','SULLCOPY','07.704.395/0001-52','J',NULL,'(41) 30294971',NULL,NULL,'contato@sullcopy.com.br','http://www.sullcopy.com.br','FLAVIO','2007-10-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (35,'PANVEL FARMACIAS','PANVEL FARMACIAS','PANVEL',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-10-05 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (36,'CASA DO MONITOR INFORMATICA','CASA DO MONITOR INFORMATICA','CASA DO MONITOR INFORMATICA',NULL,'J',NULL,'51-33431916',NULL,NULL,'casadomonitor@terra.com.br',NULL,NULL,'2007-10-15 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'AV CEARA','605',NULL,'90240-510',NULL,'PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (37,'BAZAR MARJU','BAZAR MARJU','BAZAR MARJU','04.462.229/0001/07','J','096/2875899','51-30237277',NULL,NULL,NULL,NULL,NULL,'2007-10-16 00:00:00',NULL,NULL,'AV PROTASIO ALVES','2512',NULL,'90410-006','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','AV PROTASIO ALVES','2512',NULL,'90410-006','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','AV PROTASIO ALVES','2512',NULL,'90410-006','PETROPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (38,'ELAINE - FAXINA','ELAINE - FAXINA','ELAINE - FAXINA',NULL,'F',NULL,'51-32230602','51-91091269',NULL,NULL,NULL,NULL,'2007-10-29 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (39,'SPK TECNOLOGIA LTDA','SPK TECNOLOGIA','SPK TECNOLOGIA','05.338/0001-41','J','Munic.: 3.173.858-3','11-21651606',NULL,NULL,NULL,NULL,NULL,'2007-11-09 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'RUA JOAQUIM FLORIANO - ED. CORP','00466','1204','04534-002',NULL,'SAO PAULO','SP','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (40,'COM. DE MAT. PARA INFO. PAULO ANDRADE DA SILVA','OFFISUL','OFFISUL','05.443.356/0001-13','J',NULL,'51-30295600',NULL,'51-3269.2280','offisul@terra.com.br',NULL,'AURE','2007-11-14 00:00:00',NULL,NULL,'AV. VINTE E QUATRO DE OUTUBRO','1100','405/B','90510-001','MOINHOS DE VENTO','PORTO ALEGRE','RS','BRASIL','AV. VINTE E QUATRO DE OUTUBRO','1100','405/B','90510-001','MOINHOS DE VENTO','PORTO ALEGRE','RS','BRASIL','AV. VINTE E QUATRO DE OUTUBRO','1100','405/B','90510-001','MOINHOS DE VENTO','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (41,'THAWTE','THAWTE','THAWTE',NULL,'J',NULL,NULL,NULL,NULL,NULL,'www.thawte.com',NULL,'2007-11-27 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (42,'PARQUE DAS AGUAS','PARQUE DAS AGUAS','PARQUE DAS AGUAS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-12-11 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (43,'DIGIMER PRODUTOS DE INFORMATICA','DIGIMER','DIGIMER','88.153.119/0003-07','J','096/2650412','51-32872400',NULL,NULL,NULL,'www.digimer.com.br',NULL,'2007-12-31 00:00:00',NULL,NULL,'JOAO WALLIG','1800','loja 1231','91349-900',NULL,'PORTO ALEGRE','RS','BRASIL','JOAO WALLIG','1800','loja 1231','91349-900',NULL,'PORTO ALEGRE','RS','BRASIL','JOAO WALLIG','1800','loja 1231','91349-900',NULL,'PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (44,'SECRETARIA ESTADUAL DA FAZENDA','SECRETARIA ESTADUAL DA FAZENDA','SECRETARIA ESTADUAL DA FAZENDA',NULL,'J',NULL,'51-32145000','51-32145550',NULL,NULL,NULL,NULL,'2008-01-09 00:00:00',NULL,NULL,'SIQUEIRA CAMPOS','1044',NULL,NULL,NULL,'PORTO ALEGRE','RS','BRASIL','SIQUEIRA CAMPOS','1044',NULL,NULL,NULL,'PORTO ALEGRE','RS','BRASIL','SIQUEIRA CAMPOS','1044',NULL,NULL,NULL,'PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (45,'DEVMEDIA GROUP','DEVMEDIA GROUP','DEVMEDIA GOUP',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-01-14 00:00:00',NULL,NULL,'AVENIDA 13 DE MAIO','13','718','20031-901','CENTRO','RIO DE JANEIRO','RJ','BRASIL','AVENIDA 13 DE MAIO','13','718','20031-901','CENTRO','RIO DE JANEIRO','RJ','BRASIL','AVENIDA 13 DE MAIO','13','718','20031-901','CENTRO','RIO DE JANEIRO','RJ','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (46,'COMPANHIA ZAFFARI COMERCIO E INDUSTRIA','ZAFFARI','ZAFFARI','93.015.006/0004-66','J','096/0185348','51-33343567',NULL,NULL,NULL,NULL,NULL,'2008-01-15 00:00:00',NULL,NULL,'AVENIDA PROTASIO ALVES','2700',NULL,'90410-006','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','AVENIDA PROTASIO ALVES','2700',NULL,'90410-006','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','AVENIDA PROTASIO ALVES','2700',NULL,'90410-006','PETROPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (47,'MARITIMA SEGUROS','MARITIMA','MARITIMA','61.383.493/0001-80','J',NULL,'0800-701-9119','11-33352990',NULL,'tecnicare@maritima.com.br','www.maritima.com.br',NULL,'2008-01-15 00:00:00',NULL,NULL,'RUA CEL. XAVIER DE TOLEDO','114','9o ANDAR','01048-902',NULL,'SAO PAULO','SP','BRASIL','RUA CEL. XAVIER DE TOLEDO','114','9o ANDAR','01048-902',NULL,'SAO PAULO','SP','BRASIL','RUA CEL. XAVIER DE TOLEDO','114','9o ANDAR','01048-902',NULL,'SAO PAULO','SP','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (48,'PRINT PRESS FORMULARIOS LTDA','PRINT PRESS','PRIN PRESS','94.990.835/0001-80','J','096/2326771','51-32210388',NULL,NULL,NULL,'www.printpress.com.br','ANA CRISTINA','2008-01-15 00:00:00',NULL,NULL,'RUA GASPAR MARTINS','304',NULL,'90220-160','FLORESTA','PORTO ALEGRE','RS','BRASIL','RUA GASPAR MARTINS','304',NULL,'90220-160','FLORESTA','PORTO ALEGRE','RS','BRASIL','RUA GASPAR MARTINS','304',NULL,'90220-160','FLORESTA','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (49,'SULCOPY','SULCOPY','SULCOPY',NULL,'J',NULL,'51-33317992',NULL,NULL,NULL,NULL,'LEANDRO','2008-01-15 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (50,'ANATEL','ANATEL','ANATEL',NULL,'J',NULL,'0800.332001',NULL,NULL,NULL,NULL,NULL,'2008-01-15 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (51,'PARRILA DEL SUR','PARRILA DEL SUR','PARRILA DEL SUR','08.672.961/0001-54','J',NULL,'51-32543335',NULL,NULL,NULL,NULL,NULL,'2008-02-20 00:00:00',NULL,NULL,'RUA AMELIA TELES','385',NULL,'90460-070','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','RUA AMELIA TELES','385',NULL,'90460-070','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','RUA AMELIA TELES','385',NULL,'90460-070','PETROPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (52,'DIGITAL METAPHROS CORP DALLAS TX','DIGITAL METAPHROS','DIGITAL METAPHROS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-02-21 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (53,'POSTO DE GASOLINA','POSTO DE GASOLINA','POSTO DE GASOLINA',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-03-04 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (54,'GRUPO SINOS','DIARIO DE CANOAS','DIARIO DE CANOAS','91.665.570/0001-56','J','Munic, 000719','51-30654000',NULL,NULL,NULL,NULL,NULL,'2008-03-04 00:00:00',NULL,NULL,'RUA JORNAL NH','99',NULL,'93334-350',NULL,'NOVO HAMBURGO','RS','BRASIL','RUA JORNAL NH','99',NULL,'93334-350',NULL,'NOVO HAMBURGO','RS','BRASIL','RUA JORNAL NH','99',NULL,'93334-350',NULL,'NOVO HAMBURGO','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (55,'FORNECEDORES DIVERSOS','FORNECEDORES DIVERSOS','FORNECEDORES DIVERSOS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-03-06 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (56,'BELUCE COPIAS','BELUCE COPIAS','BELUCE COPIA',NULL,'F',NULL,'51-33306766',NULL,NULL,NULL,NULL,NULL,'2008-03-12 00:00:00',NULL,NULL,'AV. PROTASIO ALVES','2403',NULL,NULL,NULL,'PORT ALEGRE','RS','BRASIL','AV. PROTASIO ALVES','2403',NULL,NULL,NULL,'PORT ALEGRE','RS','BRASIL','AV. PROTASIO ALVES','2403',NULL,NULL,NULL,'PORT ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (57,'CHIELE CONSTRUCOES LTDA','CHIELE CONSTRUCOES LTDA','CHIELE CONSTRUCOES LTDA','87.111.563/0001-35','J',NULL,'5133345635','33381151','33381479',NULL,NULL,'RICARDO','2008-03-14 00:00:00',NULL,NULL,'PROTASIO ALVES','2959','205','90.410-003','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','PROTASIO ALVES','2959','205','90.410-003','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','PROTASIO ALVES','2959','205','90.410-003','PETROPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (58,'PHILDEN','PHILDEN','PHILDEN',NULL,'J',NULL,'51-33755000','4001-4040',NULL,NULL,NULL,NULL,'2008-04-01 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (59,'CASA DE FERRAGENS','CASA DE FERRAGENS','CASA DE FERRAGENS',NULL,'J',NULL,'5133337516',NULL,NULL,NULL,'www.casadeferragens.com.br',NULL,'2008-04-15 00:00:00',NULL,NULL,'AV. BAGE','616',NULL,'90460-150','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','AV. BAGE','616',NULL,'90460-150','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','AV. BAGE','616',NULL,'90460-150','PETROPOLIS','PORTO ALEGRE','RS','AV. BAGE',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (60,'HELP.COM - TEMPLATES','HELP.COM - TEMPLATES','HELP.COM - TEMPLATES',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-04-22 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (62,'GVT - GLOBAL VILLAGE TELECOM LTDA','GVT','GVT','03.420.926/0004-77','J',NULL,'103 25',NULL,NULL,NULL,'www.gvt.com.br',NULL,'2008-05-06 00:00:00',NULL,NULL,'AV CARLOS GOMES','466','12 ANDAR','90480-000','PETRÓPOLIS','PORTO ALEGRE','RS','BRASIL','AV CARLOS GOMES','466','12 ANDAR','90480-000','PETRÓPOLIS','PORTO ALEGRE','RS','BRASIL','AV CARLOS GOMES','466','12 ANDAR','90480-000','PETRÓPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (63,'HABIBS','HABIBS','HABIBS','04.579.031/0001-08','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-05-15 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (64,'MAGAZINE LUIZA S.A.','MAGAZINE LUIZA','MAGAZINE LUIZA','47.960.950/0324-06','J',NULL,'51-33784500',NULL,NULL,NULL,NULL,NULL,'2008-05-16 00:00:00',NULL,NULL,'AV JOAO WALLIG','1800',NULL,'91430-000',NULL,'PORTO ALEGRE','RS','BRASIL','AV JOAO WALLIG','1800',NULL,'91430-000',NULL,'PORTO ALEGRE','RS','BRASIL','AV JOAO WALLIG','1800',NULL,'91430-000',NULL,'PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (65,'PAPELARIA','PAPELARIA','PAPELARIA',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-05-21 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (66,'MAC DONALDS','MAC DONALDS','MAC DONALDS',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-06-04 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (67,'GROOMING PLACE','GROOMING PLACE','GROOMING PLACE',NULL,'J',NULL,'51-30613329','51-30613328',NULL,NULL,NULL,NULL,'2008-06-16 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (68,'CHINA IN BOX','CHINA IN BOX','CHINA IN BOX',NULL,'J',NULL,'51-33331411',NULL,NULL,NULL,NULL,NULL,'2008-06-17 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (69,'KING HOST','KING HOST','KING HOST',NULL,'J',NULL,'51-33015464',NULL,NULL,NULL,NULL,NULL,'2008-06-18 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (70,'RESTAURANTE PUEBLO','RESTAURANTE PUEBLO','RESTAURANTE PUEBLO',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-07-08 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (71,'BOBBY E KETTY','BOBBY E KETTY','BOBBY E KETTY','92.534.940/0002-0','J',NULL,'51-33158280',NULL,NULL,NULL,NULL,NULL,'2008-07-09 00:00:00',NULL,NULL,'AV. IPIRANGA','5200','LOJA 114','90610-000','AZENHA','PORTO ALEGRE','RS','BRASIL','AV. IPIRANGA','5200','LOJA 114','90610-000','AZENHA','PORTO ALEGRE','RS','BRASIL','AV. IPIRANGA','5200','LOJA 114','90610-000','AZENHA','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (72,'CIA DAS PIZZAS','CIA DAS PIZZAS','CIA DAS PIZZAS',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-07-10 00:00:00',NULL,NULL,'RUA VINTE E QUATRO DE OUTUBRO','1521',NULL,'90510-003',NULL,'PORTO ALEGRE','RS','BRASIL','RUA VINTE E QUATRO DE OUTUBRO','1521',NULL,'90510-003',NULL,'PORTO ALEGRE','RS','BRASIL','RUA VINTE E QUATRO DE OUTUBRO','1521',NULL,'90510-003',NULL,'PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (73,'MAZER','MAZER','MAZER','94.623.741/0001-72','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-07-10 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (74,'CASA DO NOBREAK','CASA DO NOBREAK','CASA DO NOBREAK','94.811.387/0001-00','J','M: 122.634-2-7','51-33461909','51-33466350',NULL,'CNB@casadonobreak.com.br','www.casadonobreak.com.br','LIZIANE','2008-07-18 00:00:00',NULL,NULL,'AV SAO PAULO','867',NULL,'90230-161','SAO GERAL','PORTO ALEGRE','RS','BRASIL','AV SAO PAULO','867',NULL,'90230-161','SAO GERAL','PORTO ALEGRE','RS','BRASIL','AV SAO PAULO','867',NULL,'90230-161','SAO GERAL','PORTO ALEGRE','RS','AV SAO PAULO',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (75,'EASY TEK COM SERV INF LTDA','EASY WAY','EASY WAY','06.881.579/0001-25','J',NULL,'51-3374-0066',NULL,NULL,NULL,NULL,NULL,'2008-07-23 00:00:00',NULL,NULL,'SIMAO KAPPEL','247',NULL,NULL,'NAVEGANTES','PORTO ALEGRE','RS','BRASIL','SIMAO KAPPEL','247',NULL,NULL,'NAVEGANTES','PORTO ALEGRE','RS','BRASIL','SIMAO KAPPEL','247',NULL,NULL,'NAVEGANTES','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (76,'BR9 PRODUTORA','BR9 PRODUTORA','BR9 PRODUTORA',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-08-12 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (77,'FRATELLO SOLE','FRATELLO SOLE','FRATELLO SOLE','03.593.809/0001-62','J',NULL,'51-33285065',NULL,NULL,'www.fratellosole.com.br',NULL,'Gabriela','2008-08-20 00:00:00',NULL,NULL,'AV JOAO WALLIG, 1800','1278',NULL,'91340-001','CHACARA DAS PEDRAS','PORTO ALEGRE','RS','BRASIL','AV JOAO WALLIG, 1800','1278',NULL,'91340-001','CHACARA DAS PEDRAS','PORTO ALEGRE','RS','BRASIL','AV JOAO WALLIG, 1800','1278',NULL,'91340-001','CHACARA DAS PEDRAS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (78,'B2W COMPANHIA GLOBAL DE VAREJO','SUBMARINO','SUBMARINO','00.776.574/0001-56','J','492.513.778.117',NULL,NULL,NULL,NULL,NULL,NULL,'2008-08-22 00:00:00',NULL,NULL,'RUA HENRY FORD','643',NULL,'06210-108','PRES ALTINO','OSASCO','SP','BRASIL','RUA HENRY FORD','643',NULL,'06210-108','PRES ALTINO','OSASCO','SP','BRASIL','RUA HENRY FORD','643',NULL,'06210-108','PRES ALTINO','OSASCO','SP','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (80,'TELEDATICA COMERCIO DE SUP. DE INF. LTDA','TELEDATICA','TELEDATICA','93.839.280/0001-07','J','096/2174718','51-32176666',NULL,NULL,NULL,NULL,'Alessandra','2008-09-08 00:00:00',NULL,NULL,'AV. PADRE CACIQUE','230','301','90810-240','PRAIA DE BELAS','PORTO ALEGRE','RS','BRASIL','AV. PADRE CACIQUE','230','301','90810-240','PRAIA DE BELAS','PORTO ALEGRE','RS','BRASIL','AV. PADRE CACIQUE','230','301','90810-240','PRAIA DE BELAS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (81,'CADEIRAS JCM','CADEIRAS JCM','CADEIRAS JCM',NULL,'F',NULL,'51-33428413',NULL,NULL,NULL,NULL,NULL,'2008-09-17 00:00:00',NULL,NULL,'RUA DONA MARGARIDA','1200',NULL,NULL,NULL,'PORTO ALEGRE','RS','BRASIL','RUA DONA MARGARIDA','1200',NULL,NULL,NULL,'PORTO ALEGRE','RS','BRASIL','RUA DONA MARGARIDA','1200',NULL,NULL,NULL,'PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (82,'SOS CABOS ESPECIAIS','SOS CABOS ESPECIAIS','SOS CABOS ESPECIAIS',NULL,'J',NULL,'51-33427712',NULL,NULL,'soscabos@uol.com.br','www.soscabos.com.br','Renato','2008-09-17 00:00:00',NULL,NULL,'AV BRASIL','1434','203',NULL,NULL,'PORTO ALEGRE','RS','BRASIL','AV BRASIL','1434','203',NULL,NULL,'PORTO ALEGRE','RS','BRASIL','AV BRASIL','1434','203',NULL,NULL,'PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (83,'CADESUL - S. E. FARINA E CIA LTDA','CADESUL','CADESUL','07.160.629/0001-48','J','096/3061780','51-33438575',NULL,NULL,'cadesul@cadesul.com.br','www.cadesul.com.br','Angela','2008-09-19 00:00:00',NULL,NULL,'AV 24 DE OUTUBRO','1350',NULL,'90510-001','AUXILIADORA','PORTO ALEGRE','RS','BRASIL','AV 24 DE OUTUBRO','1350',NULL,'90510-001','AUXILIADORA','PORTO ALEGRE','RS','BRASIL','AV 24 DE OUTUBRO','1350',NULL,'90510-001','AUXILIADORA','PORTO ALEGRE','RS','AV 24 DE OUTUBRO',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (84,'BAGGIOTO MANUTENCAO E CONSERTOS LTDA ME','OFICINA IJUI','OFICINA IJUI',NULL,'J',NULL,'51-33304838',NULL,NULL,NULL,NULL,NULL,'2008-09-19 00:00:00',NULL,NULL,'AV IJUI','24',NULL,'90460-150','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','AV IJUI','24',NULL,'90460-150','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','AV IJUI','24',NULL,'90460-150','PETROPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (85,'COMPANHIA BRASILEIRA DE SOLUCOES E SERVICOS','CBSS','CBSS','04.740.876/0001-25','J',NULL,NULL,NULL,NULL,NULL,'www.cbss.com.br',NULL,'2008-09-29 00:00:00',NULL,NULL,'ALAMEDA RIO NEGRO','858','10 ANDAR','06454-000','ALPHAVILLE','SAO PAULO','RS','BRASIL','ALAMEDA RIO NEGRO','858','10 ANDAR','06454-000','ALPHAVILLE','SAO PAULO','RS','BRASIL','ALAMEDA RIO NEGRO','858','10 ANDAR','06454-000','ALPHAVILLE','SAO PAULO','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (86,'IAGENTEMAIL','IAGENTEMAIL','IAGENTEMAIL',NULL,'J',NULL,'51- 93423937','51-33987638',NULL,NULL,NULL,NULL,'2008-10-16 00:00:00',NULL,NULL,'RUA SPORT CLUBE SAO JOSE','54','506',NULL,NULL,'PORTO ALEGRE','RS','BRASIL','RUA SPORT CLUBE SAO JOSE','54','506',NULL,NULL,'PORTO ALEGRE','RS','BRASIL','RUA SPORT CLUBE SAO JOSE','54','506',NULL,NULL,'PORTO ALEGRE','RS','RUA SPORT CLUBE SAO JOSE',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (87,'LORENA TUR HOTEL','LORENA TUR HOTEL','LORENA TUR HOTEL',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-10-17 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (89,'OPECO OPER COMS IMPORT E EXPORT LTDA','OPECO OPER COMS IMPORT E EXPORT LTDA','E-STORE',NULL,'J',NULL,NULL,NULL,NULL,NULL,'www.e-store.com.br',NULL,'2008-10-23 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (90,'FARMACIA','FARMACIA','FARMACIA',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-10-28 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (91,'TECNICO TELEFONIA','TECNICO TELEFONIA','TECNICO TELEFONIA',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-10-28 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (92,'ZECA MUDANCAS','ZECA MUDANCAS','ZECA MUDANCAS',NULL,'F',NULL,'51-91742419',NULL,NULL,NULL,NULL,'ZECA','2008-11-04 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (93,'PAULO CHIELLE','PAULO CHIELLE','PAULO CHIELLE',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-11-17 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (95,'RENI PASINATO E CIA LTDA','CONTINENTAL AR CONDICIONADO','CONTINENTAL AR CONDICIONADO',NULL,'J',NULL,'51-32259166',NULL,NULL,'continental@continentalrs.com.br',NULL,NULL,'2008-11-20 00:00:00',NULL,NULL,'AV FARRAPOS','1043',NULL,NULL,'FLORESTA','PORTO ALEGRE','RS','BRASIL','AV FARRAPOS','1043',NULL,NULL,'FLORESTA','PORTO ALEGRE','RS','BRASIL','AV FARRAPOS','1043',NULL,NULL,'FLORESTA','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (96,'GODADDY','GODADDY','GODADDY',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-11-24 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ESTADOS UNIDOS',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ESTADOS UNIDOS',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ESTADOS UNIDOS',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (97,'TEMPLATE HELP','TEMPLATE HELP','TEMPLATE HELP',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-11-24 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ESTADOS UNIDOS',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ESTADOS UNIDOS',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ESTADOS UNIDOS',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (98,'SHARE IT','SHARE IT','SHARE IT',NULL,'J',NULL,NULL,NULL,NULL,NULL,'www.shareit.com',NULL,'2008-11-28 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (100,'MARCINEIRO','MARCINEIRO','MARCINEIRO',NULL,'F',NULL,'51-99411255',NULL,NULL,NULL,NULL,'CELSO','2008-12-01 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (101,'UNIVERSO ON LINE S/A','UOL','UOL','01.109.184/0004-38','J',NULL,'4003-1100','11-30388474','11-30388100','atendimentoidc@uolhostidc.com.br',NULL,NULL,'2008-12-09 00:00:00',NULL,NULL,'AV BRIGADEIRO FARIA LIMA','1384','3 A 7 ANDARES','01452-002','JARDIM PAULISTANO','SÃO PAULO','SP','BRASIL','AV BRIGADEIRO FARIA LIMA','1384','3 A 7 ANDARES','01452-002','JARDIM PAULISTANO','SÃO PAULO','SP','BRASIL','AV BRIGADEIRO FARIA LIMA','1384','3 A 7 ANDARES','01452-002','JARDIM PAULISTANO','SÃO PAULO','SP','AV BRIGADEIRO FARIA LIMA',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (102,'FRAGATA RESTAURANTE E PIZZARIA','FRAGATA','FRAGATA','08.322.704/0001-92','J',NULL,'51-30614059',NULL,NULL,NULL,NULL,NULL,'2008-12-09 00:00:00',NULL,NULL,'AV ASSIS BRASIL','864',NULL,'91010-001','STA MARIA GORETI','PORTO ALEGRE','RS','BRASIL','AV ASSIS BRASIL','864',NULL,'91010-001','STA MARIA GORETI','PORTO ALEGRE','RS','BRASIL','AV ASSIS BRASIL','864',NULL,'91010-001','STA MARIA GORETI','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (103,'ASSOC DOS TRANSP. INTERMUNIC. METROPOL. DE PASSAGEIROS','ATM','ATM','97.133.060/0001-14','J',NULL,'51-32205900',NULL,NULL,NULL,NULL,NULL,'2008-12-12 00:00:00',NULL,NULL,'LARGO VISCONDE DO CAIRU','12',NULL,'90030-110','CENTRO','PORTO ALEGRE','RS','BRASIL','LARGO VISCONDE DO CAIRU','12',NULL,'90030-110','CENTRO','PORTO ALEGRE','RS','BRASIL','LARGO VISCONDE DO CAIRU','12',NULL,'90030-110','CENTRO','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (104,'ULBRA SAUDE','ULBRA SAUDE','ULBRA SAUDE',NULL,'J',NULL,'51-3464-9625 (agendamento)','3215-4000 (central)',NULL,NULL,NULL,NULL,'2008-12-12 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (105,'PIZZARIA PORTO BAKERS','PIZZARIA PORTO BAKERS','PIZZARIA PORTO BAKERS',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-12-22 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (106,'VINICIUS COLLING','VINICIUS COLLING','VINICIUS COLLING',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-12-23 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (107,'SKO - MARCAS E PATENTES','SKO','SKO','05.912.255/0001-44','J',NULL,'51-33429323',NULL,NULL,'sko@sko.com.br',NULL,NULL,'2008-12-29 00:00:00',NULL,NULL,'RUA DONA LEOPOLDINA','270',NULL,'90550-130',NULL,'PORTO ALEGRE','RS','BRASIL','RUA DONA LEOPOLDINA','270',NULL,'90550-130',NULL,'PORTO ALEGRE','RS','BRASIL','RUA DONA LEOPOLDINA','270',NULL,'90550-130',NULL,'PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (108,'FLORICULTURA BLUMEN GARTEN','FLORICULTURA BLUMEN GARTEN','FLORICULTURA BLUMEN GARTEN',NULL,'J',NULL,'51-33381588',NULL,NULL,NULL,'www.blumengarten.com.br',NULL,'2008-12-29 00:00:00',NULL,NULL,'RUA DR SALVADOR FRANCA','1750',NULL,NULL,'JARDIM BOTANICO','PORTO ALEGRE','RS','BRASIL','RUA DR SALVADOR FRANCA','1750',NULL,NULL,'JARDIM BOTANICO','PORTO ALEGRE','RS','BRASIL','RUA DR SALVADOR FRANCA','1750',NULL,NULL,'JARDIM BOTANICO','PORTO ALEGRE','RS','RUA DR SALVADOR FRANCA',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (109,'TABELIONATO DE NOTAS PRESSER','TABELIONATO DE NOTAS PRESSER','TABELIONATO DE NOTAS PRESSER','268.110.980-72','F',NULL,'51-33411022',NULL,NULL,NULL,'http://www.tabelionatopresser.com.br/',NULL,'2008-12-30 00:00:00',NULL,NULL,'AV ASSIS BRASIL','1795',NULL,'91010-005','PASSO DA AREIA','PORTO ALEGRE','RS','BRASIL','AV ASSIS BRASIL','1795',NULL,'91010-005','PASSO DA AREIA','PORTO ALEGRE','RS','BRASIL','AV ASSIS BRASIL','1795',NULL,'91010-005','PASSO DA AREIA','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (110,'TERRA','TERRA','TERRA',NULL,'F',NULL,'51-32209297',NULL,NULL,NULL,NULL,NULL,'2009-01-06 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (111,'HOTEIS DIVERSOS','HOTEIS DIVERSOS','HOTEIS DIVERSOS',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-01-09 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (112,'LANCHONETES DIVERSAS','LANCHONETES DIVERSAS','LANCHONETES DIVERSAS',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-01-09 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (113,'RODOVIARIA','RODOVIARIA','RODOVIARIA',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-01-09 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (114,'NET VIRTUA','NET VIRTUA','NET VIRTUA',NULL,'J',NULL,'0800 70 10 358','4004 7777',NULL,NULL,NULL,NULL,'2009-01-19 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (115,'POWER CARD - MANOELINA ALMEIDA M. GRAFICA','POWERCARD','POWERCARD',NULL,'J',NULL,NULL,NULL,NULL,NULL,'www.powercard.com.br',NULL,'2009-01-29 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (116,'BBSI INFORMATICA LTDA','BBSI','BBSI',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-01-30 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (117,'FRUTEIRA DO PAULINHO','FRUTEIRA DO PAULINHO','FRUTEIRA DO PAULINHO',NULL,'J',NULL,'33332380',NULL,NULL,NULL,NULL,NULL,'2009-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (118,'ESTACIONAMENTO','ESTACIONAMENTO','ESTACIONAMENTO',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-04 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (119,'ELEMENTS.INFO','ELEMENTS.INFO','ELEMENTS.INFO',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-05 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (120,'POP - SERRALHEIRO','POP - SERRALHEIRO','POP - SERRALHEIRO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-09 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (121,'SEPRORGS','SEPRORGS','SEPRORGS',NULL,'J',NULL,'51-3311.5533',NULL,NULL,NULL,'www.seprorgs.org.br',NULL,'2009-03-12 00:00:00',NULL,NULL,'Rua Felipe Camarão','690','404','90035-140','Bon Fim','Porto Alegre','RS','BRASIL','Rua Felipe Camarão','690','404','90035-140','Bon Fim','Porto Alegre','RS','BRASIL','Rua Felipe Camarão','690','404','90035-140','Bon Fim','Porto Alegre','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (122,'MEDICO DO TRABALHO','MEDICO DO TRABALHO','MEDICO DO TRABALHO',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-17 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (123,'MEGA INFO','MEGA INFO','MEGA INFO','08.346.584/0001-63','J','096/3200852','51-33920250',NULL,NULL,'megainfo10@yahoo.com.br','megainfo10.com.br',NULL,'2009-03-31 00:00:00',NULL,NULL,'AV PLINIO BRASIL MILANO','251 X',NULL,'90520-002','AUXILIADORA','PORTO ALEGRE','RS','BRASIL','AV PLINIO BRASIL MILANO','251 X',NULL,'90520-002','AUXILIADORA','PORTO ALEGRE','RS','BRASIL','AV PLINIO BRASIL MILANO','251 X',NULL,'90520-002','AUXILIADORA','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (124,'ATHENAS INFORMÁTICA IMPORTAÇÃO E EXPORTAÇÃO LTDA.','ATHENAS SOFTWARE AND SYSTEMS','ATHENAS','01.390.825/0001-22','J',NULL,'51-33888466',NULL,'51-33306993','athenas@athenas.com.br','http://www.athenas.com.br','ALESSANDER','2009-04-13 00:00:00',NULL,NULL,'RUA JOAO ABOTT','319','503','90460-150','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','RUA JOAO ABOTT','319','503','90460-150','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','RUA JOAO ABOTT','319','503','90460-150','PETROPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (126,'BIG SUPERMERCADOS','BIG SUPERMERCADOS','BIG SUPERMERCADOS',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-22 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (127,'TRIANON BAURU','TRIANON BAURU','TRIANON BAURU',NULL,'J',NULL,'51-33334447',NULL,NULL,NULL,NULL,NULL,'2009-05-13 00:00:00',NULL,NULL,'Av PROTASIO ALVES','978',NULL,NULL,NULL,'PORTO ALEGRE','RS','BRASIL','Av PROTASIO ALVES','978',NULL,NULL,NULL,'PORTO ALEGRE','RS','BRASIL','Av PROTASIO ALVES','978',NULL,NULL,NULL,'PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (129,'CARLOS RIBEIRO ARCANJO','CARLOS LUIZ BARBOSA RIBEIRO','CARLOS RIBEIRO ARCANJO','93211970010','F','RG 1060952122','51-85956342',NULL,NULL,'cbrarcanjo@gmail.com',NULL,NULL,'2009-05-13 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (130,'RICOPY','RICOPY','RICOPY',NULL,'J',NULL,'51 33317992',NULL,NULL,NULL,'www.ricopy.com.br/','Andressa','2009-05-29 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (131,'PROEVENTO TECNOLOGIA LTDA','GRUPO PROEVENTO','GRUPO PROEVENTO','10.812.688/0001-68','J','148.593.094.119','+55(11)3251-2002','+55(51)3330-9599',NULL,'adm@proevento.com.br','www.proevento.com.br',NULL,'2008-01-21 00:00:00',NULL,NULL,'AV. PAULISTA','1499','901','01311-928','BELA VISTA','SÃO PAULO','SP','BRASIL','AV. PAULISTA','1499','901','01311-928','BELA VISTA','SÃO PAULO','SP','BRASIL','AV. PAULISTA','1499','901','01311-928','BELA VISTA','SÃO PAULO','SP','BRASIL','3912.278-6',51,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (132,'TELEFÔNICA BRASIL S.A','TELEFÔNICA BRASIL S.A','TELEFÔNICA','02.558.157/0001-62','F','108.383.949.112',NULL,NULL,NULL,NULL,NULL,NULL,'2008-02-25 00:00:00',NULL,NULL,'RUA MARTINIANO DE CARVALHO','851',NULL,'01321-001','BELA VISTA','SÃO PAULO','SP','BRASIL','RUA MARTINIANO DE CARVALHO','851',NULL,'01321-001','BELA VISTA','SÃO PAULO','SP','BRASIL','RUA MARTINIANO DE CARVALHO','851',NULL,'01321-001','BELA VISTA','SÃO PAULO','SP','BRASIL',NULL,53,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (133,'BANCO ABN AMRO REAL S.A','DESPESAS COM CARTÃO DE CRÉDITO','DESPESAS COM CARTÃO DE CRÉDITO',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-02-25 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,54,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (134,'WEB HOSTING DO BRASIL SERVIÇOS DE INFORMÁTICA LTDA','WEB HOSTING DO BRASIL SERVIÇOS DE INFORMÁTICA LTDA','WEB HOSTING - DATADROME','08354053000112','J',NULL,'(51) 3387-3700',NULL,NULL,NULL,NULL,NULL,'2008-02-25 00:00:00',NULL,NULL,'AV. PROTÁSIO ALVES','2854','SALA 2504','90410006','PETRÓPOLIS','PORTO ALEGRE','RS','BRASIL','AV. PROTÁSIO ALVES','2854','SALA 2504','90410006','PETRÓPOLIS','PORTO ALEGRE','RS','BRASIL','AV. PROTÁSIO ALVES','2854','SALA 2504','90410006','PETRÓPOLIS','PORTO ALEGRE','RS','AV. PROTÁSIO ALVES',NULL,55,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (135,'BORSAN SERVIÇOS DIGITAIS LTDA','BORSAN SERVIÇOS DIGITAIS LTDA','BORSAN','08091781000189','J','201768642','(51) 3561-8361',NULL,NULL,NULL,NULL,NULL,'2008-02-25 00:00:00',NULL,NULL,'RUA HENRIQUE BECKMANN','214',NULL,'93600000','NOVA ESTÂNCIA','ESTÂNCIA VELHA','RS','BRASIL','RUA HENRIQUE BECKMANN','214',NULL,'93600000','NOVA ESTÂNCIA','ESTÂNCIA VELHA','RS','BRASIL','RUA HENRIQUE BECKMANN','214',NULL,'93600000','NOVA ESTÂNCIA','ESTÂNCIA VELHA','RS','BRASIL',NULL,57,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (136,'DESPESAS ESPORÁDICAS','DESPESAS ESPORÁDICAS','DESPESAS ESPORÁDICAS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-02-25 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,58,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (137,'FEIRA & CIA EVENTOS','FEIRA & CIA EVENTOS','FEIRA & CIA','07.387.421/0001-66','J',NULL,'(11) 3025-5555',NULL,NULL,NULL,'www.feiraecia.com.br',NULL,'2008-02-25 00:00:00',NULL,NULL,'AV. SÃO GUALTER','620',NULL,'05455000','ALTO DOS PINHEIROS','SÃO PAULO','SP','BRASIL','AV. SÃO GUALTER','620',NULL,'05455000','ALTO DOS PINHEIROS','SÃO PAULO','SP','BRASIL','AV. SÃO GUALTER','620',NULL,'05455000','ALTO DOS PINHEIROS','SÃO PAULO','SP','AV. SÃO GUALTER',NULL,59,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (138,'TERRA','TERRA','TERRA',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-03-11 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,60,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (139,'OFICINA IJUI','OFICINA IJUI','OFICINA IJUI',NULL,'J',NULL,'51-33304838',NULL,NULL,NULL,NULL,NULL,'2008-11-26 00:00:00',NULL,NULL,'AV IJUI','24',NULL,NULL,'PETROPOLIS','PORTO ALEGRE','RS','BRASIL','AV IJUI','24',NULL,NULL,'PETROPOLIS','PORTO ALEGRE','RS','BRASIL','AV IJUI','24',NULL,NULL,'PETROPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,61,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (140,'GRUPO HS','GRUPO HS','GRUPO HS',NULL,'F','ref produto 236','33736802','Daiane',NULL,NULL,'www.grupohs.com.br',NULL,'2008-12-01 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'cod cliente 16142',62,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (141,'CADESUL','CADESUL','CADESUL',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-12-01 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,63,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (144,'PORTO BAKERS','PORTO BAKERS','PORTO BAKERS',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2008-12-12 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,66,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (145,'NET','NET','NET','73.676.512/0001-46','F','096/2389102',NULL,NULL,NULL,NULL,NULL,NULL,'2009-01-02 00:00:00',NULL,NULL,'RUA SILVEIRO','1111',NULL,'90850-000','MORRO SANTA TEREZA','PORTO ALEGRE','RS','BRASIL','RUA SILVEIRO','1111',NULL,'90850-000','MORRO SANTA TEREZA','PORTO ALEGRE','RS','BRASIL','RUA SILVEIRO','1111',NULL,'90850-000','MORRO SANTA TEREZA','PORTO ALEGRE','RS','BRASIL',NULL,67,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (146,'NEXTEL','NEXTEL','NEXTEL','66.970.229/0006-71','J','096/2755109',NULL,NULL,NULL,NULL,NULL,NULL,'2009-01-02 00:00:00',NULL,NULL,'AV. CARLOS GOMES','409','413','90480-000','AUXILIADORA','PORTO ALEGRE','RS','BRASIL','AV. CARLOS GOMES','409','413','90480-000','AUXILIADORA','PORTO ALEGRE','RS','BRASIL','AV. CARLOS GOMES','409','413','90480-000','AUXILIADORA','PORTO ALEGRE','RS','BRASIL',NULL,68,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (148,'FLORICULTURA','FLORICULTURA','FLORICULTURA',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-01-14 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,70,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (149,'TAXI','TAXI','TAXI',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-01-21 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,71,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (151,'EASYWAY','EASYWAY','EASYWAY',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-02-18 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,73,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (152,'DE CHAVES','DE CHAVES','DE CHAVES','74.791.443/0001-84','J',NULL,'51-32251717',NULL,NULL,NULL,NULL,NULL,'2009-05-29 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,74,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (153,'FIBRACEM METALURGICA','FIBRACEM METALURGICA','FIBRACEM METALURGICA','02.210.281/0001-99','J',NULL,'41-33334611',NULL,NULL,NULL,NULL,NULL,'2009-07-13 00:00:00',NULL,NULL,'RUA MAJOR VICENTE DE CASTRO','2643',NULL,'81030-020',NULL,'CURITIBA','PR','BRASIL','RUA MAJOR VICENTE DE CASTRO','2643',NULL,'81030-020',NULL,'CURITIBA','PR','BRASIL','RUA MAJOR VICENTE DE CASTRO','2643',NULL,'81030-020',NULL,'CURITIBA','PR','BRASIL',NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (154,'SEVERO ROTH','SEVERO ROTH','SEVERO ROTH',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-07-13 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (155,'TOTOSINHO','TOTOSINHO','TOTOSINHO',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-07-13 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (156,'Servidor','Servidor','Servidor',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-07-30 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (158,'CENTRO DO COMERCIO VAREJISTA DO RS','CENTRO DO COMERCIO VAREJISTA DO RS','CENTRO DO COMERCIO VAREJISTA DO RS','87.932.778/0001-17','J','ISENTO','5132113244',NULL,NULL,NULL,NULL,NULL,'2009-08-07 00:00:00',NULL,NULL,'PRAÇA OSVALDO VRUZ','15','614',NULL,'CENTRO','PORTO ALEGRE','RS','BRASIL','PRAÇA OSVALDO VRUZ','15','614',NULL,'CENTRO','PORTO ALEGRE','RS','BRASIL','PRAÇA OSVALDO VRUZ','15','614',NULL,'CENTRO','PORTO ALEGRE','RS','BRASIL',NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (159,'M S R RIBEIRO E S S LTDA ME','ACTIVE DELFHI','ACTIVE DELFHI',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-08-25 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (160,'ELETRECISTA- EURECI','ELETRECISTA- EURECI','ELETRECISTA- EURECI',NULL,'F',NULL,'99074102',NULL,NULL,NULL,NULL,NULL,'2009-09-15 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (161,'ITAU','ITAU -LUCIANA',NULL,NULL,'F',NULL,'32258311',NULL,'32258847',NULL,NULL,NULL,'2009-09-15 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (162,'ALL PRESS','ALL PRESS',NULL,NULL,'F',NULL,'33439990',NULL,NULL,NULL,NULL,NULL,'2009-09-15 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (163,'CONTABIL PLUS','CONTIL',NULL,NULL,'F',NULL,'30133900',NULL,NULL,NULL,NULL,NULL,'2009-09-23 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PRAÇA OSVALDO CRUZ','15','1514',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (164,'BM ELETRO ELTRONICA','BM ELETRO ELTRONICA 1','BM ELETRO ELTRONICA 2',NULL,'F',NULL,'34964400',NULL,NULL,NULL,NULL,NULL,'2009-10-06 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'BUARQUE DE MACEDO','175',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (165,'ABT MATERIAIS ELETRICOS','ABT MATERIAIS ELETRICOS',NULL,NULL,'F',NULL,'30183838',NULL,NULL,NULL,NULL,NULL,'2009-10-06 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'AV SAO PEDRO','924',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (166,'FERRAGEM PARATI','FERRAGEM PARATI','FERRAGEM PARATI',NULL,'F',NULL,'33342612',NULL,NULL,NULL,NULL,NULL,'2009-10-06 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'AV SATURNINO DE BRITO','1591',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (167,'SESC','SESC','SESC',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-10-20 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PROTASIO ALVES 6220',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (168,'GRAFICA EXPRESSA','GRAFICA EXPRESSA','GRAFICA EXPRESSA','91313007000119','J',NULL,'33887106','33317967',NULL,NULL,NULL,NULL,'2009-11-11 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (169,'PLUG AUDIOVISUAL LOCAÇOES E CO','PLUG AUDIOVISUAL LOCAÇOES E CO','PLUG AUDIOVISUAL LOCAÇOES E CO','05615288/0001-22','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-01-07 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (170,'PLANAL IMOVEIS SS LTDA','PLANAL IMOVEIS SS LTDA','PLANAL IMOVEIS',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-01-07 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (172,'GRUPO CMS','GRUPO CMS','GRUPO CMS',NULL,'F',NULL,'11 3115 0519','11 3106 7079',NULL,NULL,NULL,NULL,'2010-01-07 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (173,'HOME PARK ESTACIONAMENTO','HOME PARK ESTACIONAMENTO','HOME PARK ESTACIONAMENTO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-01-07 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (174,'DIVERSOS','DIVERSOS','DIVERSOS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-01 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (175,'FGTS','FGTS','FGTS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-02 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (176,'VIVO S/A','VIVO','VIVO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-02 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (178,'ISSQN','ISSQN','ISSQN',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-02 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (179,'CARTÃO ITAU','CARTÃO ITAU','CARTÃO ITAU',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-02 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (180,'TARIFAS BANCARIAS','TARIFAS BANCARIAS','TARIFAS BANCARIAS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-02 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (181,'RENDIMENTO APLICAÇÃO AUTOMATICA','RENDIMENTO APLICAÇÃO AUTOMATICA','RENDIMENTO APLICAÇÃO AUTOMATICA',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-02 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (182,'PAPELARIA VIRADOURO','PAPELARIA VIRADOURO','PAPELARIA VIRADOURO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-02 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (183,'INES - FAXINA SP','INES - FAXINA SP','INES - FAXINA SP',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-02 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (184,'IRRF S/ SALARIOS','IRRF S/ SALARIOS','IRRF S/ SALARIOS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-02 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (185,'SINDPD','SINDPD','SINDPD',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-02 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (186,'GPS - INSS','GPS - INSS','GPS - INSS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-02 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (187,'GPS - INSS','GPS - INSS','GPS - INSS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-02 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (188,'ELETROPAULO','ELETROPAULO','ELETROPAULO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-02 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (189,'CORREIO','CORREIO','CORREIO',NULL,'F',NULL,'33320040','92593234','93035645','acfmontserrat@terra.com.br','33320065',NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (190,'VIP- ADRIANA ZANCO','VIP- ADRIANA ZANCO','VIP- ADRIANA ZANCO','07682177000164','J','0963112392','33881666','30195076',NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'RUA BARÃO DO AMAZONAS','306','01','90670000','PETRÓPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (191,'VISA VALE - VR/VA','VISA VALE - VR/VA','VISA VALE - VR/VA',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (192,'COFINS','COFINS','COFINS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (193,'TEU BILHETE METROPOLITANO','TEU BILHETE METROPOLITANO','TEU BILHETE METROPOLITANO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO `ent_fornecedor` (`COD_FORNECEDOR`,`RAZAO_SOCIAL`,`NOME_FANTASIA`,`NOME_COMERCIAL`,`NUM_DOC`,`TIPO_DOC`,`INSC_ESTADUAL`,`FONE_1`,`FONE_2`,`FAX`,`EMAIL`,`SITE`,`CONTATO`,`DT_CADASTRO`,`DT_INATIVO`,`SYS_DT_ALTERACAO`,`ENTR_ENDERECO`,`ENTR_NUMERO`,`ENTR_COMPLEMENTO`,`ENTR_CEP`,`ENTR_BAIRRO`,`ENTR_CIDADE`,`ENTR_ESTADO`,`ENTR_PAIS`,`FATURA_ENDERECO`,`FATURA_NUMERO`,`FATURA_COMPLEMENTO`,`FATURA_CEP`,`FATURA_BAIRRO`,`FATURA_CIDADE`,`FATURA_ESTADO`,`FATURA_PAIS`,`COBR_ENDERECO`,`COBR_NUMERO`,`COBR_COMPLEMENTO`,`COBR_CEP`,`COBR_BAIRRO`,`COBR_CIDADE`,`COBR_ESTADO`,`COBR_PAIS`,`INSC_MUNICIPAL`,`COD_ANTIGO`,`TEM_ALIQ_IRPJ`,`ALIQ_IRPJ`,`COD_BANCO`,`AGENCIA`,`CONTA`,`FAVORECIDO`,`OBS`) VALUES 
 (194,'PIS','PIS','PIS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (195,'WHIP WEB & DESIGN','WHIP WEB & DESIGN','WHIP WEB & DESIGN',NULL,'F',NULL,'51 3391-5184',NULL,NULL,'whip@whip.com.br','www.whip.com.br',NULL,'2010-02-03 00:00:00',NULL,NULL,'R. Sport Clube São José','54','CJ 506','91030-510','Rio Grande do Sul','Porto Alegre','RS','Brasil','R. Sport Clube São José','54','CJ 506','91030-510','Rio Grande do Sul','Porto Alegre','RS','Brasil','R. Sport Clube São José','54','CJ 506','91030-510','Rio Grande do Sul','Porto Alegre','RS','Brasil',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (196,'OMINT','OMINT','OMINT',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (197,'VB - TRANSPORTE EMTU','VB - TRANSPORTE EMTU','VB - TRANSPORTE EMTU',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (198,'SPTRANS -BILHETE UNICO','SPTRANS -BILHETE UNICO','SPTRANS -BILHETE UNICO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (199,'SN BRASIL - CONTADOR/SP','SN BRASIL - CONTADOR/SP','SN BRASIL - CONTADOR/SP',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (200,'DARF','DARF','DARF',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (201,'I.R.P.J. S/ LUCRO PRESUMIDO DO 4 TRIMESTRE DE 2009','I.R.P.J. S/ LUCRO PRESUMIDO DO 4 TRIMESTRE DE 2009','I.R.P.J. S/ LUCRO PRESUMIDO DO 4 TRIMESTRE DE 2009',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (202,'CONTR. SOCIAL LUCRO PRESUMIDO DO 4 TRIMESTRE DE 2009','CONTR. SOCIAL LUCRO PRESUMIDO DO 4 TRIMESTRE DE 2009','CONTR. SOCIAL LUCRO PRESUMIDO DO 4 TRIMESTRE DE 2009',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (203,'DELL COMPUTADORES','DELL COMPUTADORES','DELL COMPUTADORES',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (204,'APPLE COMPUTER','APPLE COMPUTER','APPLE COMPUTER',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (205,'TAM','TAM','TAM',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (206,'GOL','GOL','GOL',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (207,'EXTRA.COM.BR','EXTRA.COM.BR','EXTRA.COM.BR',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (208,'ITAU (PROVISÃO 13SAL)','ITAU (PROVISÃO 13SAL)','ITAU (PROVISÃO 13SAL)',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-10 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (209,'ITAU (PROVISÃO NATAL)','ITAU (PROVISÃO NATAL)','ITAU (PROVISÃO NATAL)',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-10 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (210,'MICHEL-CENTRAL TELEFONICA','MICHEL-CENTRAL TELEFONICA','MICHEL-CENTRAL TELEFONICA',NULL,'F',NULL,'51-81266020',NULL,NULL,NULL,NULL,NULL,'2010-02-12 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (211,'LELLO PRINT','LELLO PRINT','LELLO PRINT',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-17 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (212,'INTERAÇÃO','INTERAÇÃO','INTERAÇÃO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-17 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (213,'FNAC','FNAC','FNAC',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-17 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (214,'CPTEL','CPTEL','CPTEL',NULL,'F',NULL,'51-33252538',NULL,NULL,NULL,NULL,NULL,'2010-02-18 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (215,'ABACOS','ABACOS','ABACOS','116740950112','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-24 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (216,'ETNA HOME STORE','ETNA HOME STORE','ETNA HOME STORE',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-03-09 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (222,'LOJA DE BEBIDAS ON LINE','LOJA DE BEBIDAS ON LINE','LOJA DE BEBIDAS ON LINE','03.820.259/0001-77','J','096/2814105','51-30286460','51-30286461','51-30288009',NULL,NULL,NULL,'2010-03-11 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (223,'META INFORMÁTICA LTDA','META INFORMÁTICA LTDA','META INFORMÁTICA LTDA',NULL,'F',NULL,'51-33466805','51-30298805',NULL,'ASSIS TEC PROVIEW',NULL,NULL,'2010-03-12 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'AV PARA','1099',NULL,NULL,'SÃO GERALDO','PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (224,'MAURICIO - AR CONDICIONADO','MAURICIO - AR CONDICIONADO','MAURICIO - AR CONDICIONADO',NULL,'F',NULL,'51-81254428',NULL,NULL,NULL,NULL,NULL,'2010-03-19 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (225,'ITAU- JAIR- ATHENAS','ITAU- JAIR- ATHENAS','ITAU- JAIR- ATHENAS',NULL,'F',NULL,'51-33619013','51-33284430 agen',NULL,NULL,NULL,NULL,'2010-03-22 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (226,'BORDADOS PONTOCORE LTDA ME','PONTOCORE','PONTOCORE',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-03-24 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (227,'VALLU AGENCIA DE MOTOBOY LTDA','FENIX','FENIX',NULL,'F',NULL,'37331148','37351711',NULL,NULL,NULL,NULL,'2010-04-08 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (228,'Micronasa Informática e Comércio Ltda','Micronasa Informática e Comércio Ltda','Micronasa Informática e Comércio Ltda','04.083.900/0001-09','J',NULL,'5524-5386',NULL,NULL,'diretoria@micronasa.com.br',NULL,NULL,'2010-04-15 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (229,'3ETEC INFORMÁTICA LTDA','3ETEC INFORMÁTICA LTDA','3ETEC INFORMÁTICA LTDA','10.902.616/0001-01','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-04-15 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (230,'Pão de Açúcar','Pão de Açúcar','Pão de Açúcar',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-04-20 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (231,'NM DE R PINHEIRO - ME','GRÁFICA PINHEIRO','GRÁFICA PINHEIRO','07.725.090/0001-27','J',NULL,'(11) 5021-3366',NULL,NULL,NULL,NULL,'NILZA','2010-04-22 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (232,'PORTO SEGURO CIA DE SEGUROS GERAIS','PORTO SEGURO','PORTO SEGURO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-04-26 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (233,'MOREIRA GOMES DESCARTÁVEIS LTDA','MULTIPACK','MULTIPACK','11.104.214/0001-24','J',NULL,'3949-1100',NULL,NULL,NULL,NULL,'fabricio','2010-05-19 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (234,'Refrigeração Andreatta Ltda','Refrigeração Andreatta Ltda','Refrigeração Andreatta Ltda','09440342000105','J',NULL,'51-99643669',NULL,NULL,NULL,NULL,'Rene','2010-05-21 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'51655128',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (235,'SOUSA LEMOS IMOVEIS LTDA','SOUSA LEMOS IMOVEIS LTDA','SOUSA LEMOS IMOVEIS LTDA',NULL,'F',NULL,'3266-3051',NULL,NULL,NULL,NULL,NULL,'2010-05-31 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (236,'AQUARIO ENCADERNAÇÕES','AQUARIO ENCADERNAÇÕES','AQUARIO ENCADERNAÇÕES','97165435000128','J',NULL,'33284696',NULL,NULL,NULL,NULL,NULL,'2010-06-24 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Rua Luiz Luz','190',NULL,'90520590','Boa Vista','Porto Alegre','RS','Brasil',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (237,'SOLLUÇÃO COMUNICAÇÃO VISUAL','SOLLUÇÃO COMUNICAÇÃO VISUAL','SOLLUÇÃO COMUNICAÇÃO VISUAL',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-06-28 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (238,'WORK MÓVEIS','WORK MÓVEIS','WORK MÓVEIS','02.756.227/0001-97','J','115.443.535.115','011 3223-6498',NULL,NULL,NULL,NULL,NULL,'2010-07-01 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (239,'TFE - TAXA DE FISCALIZAÇÃO DE ESTABELECIMENTO','TFE - TAXA DE FISCALIZAÇÃO DE ESTABELECIMENTO','TFE - TAXA DE FISCALIZAÇÃO DE ESTABELECIMENTO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-07-05 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (240,'Atual Card','Atual Card','Atual Card',NULL,'F',NULL,'41.3341-9508',NULL,NULL,NULL,NULL,NULL,'2010-07-15 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (241,'8º TABELIONATO - LEOCACIO NETO','8º TABELIONATO - LEOCACIO NETO','8º TABELIONATO - LEOCACIO NETO','20191650070','F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-07-23 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PROTASIO ALVES','2830',NULL,'90460150','PETROPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (242,'CATIA CILENE KONNORATE','CATIA CILENE KONNORATE','CATIA CILENE KONNORATE','08721476000123','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-08-04 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PROTASIO ALVES','2387',NULL,'90410002','PETROPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (243,'ARMELIN CONFEITARIA','ARMELIN CONFEITARIA','ARMELIN CONFEITARIA','03875413000108','J','0962817430','51-33437743',NULL,NULL,NULL,NULL,NULL,'2010-08-10 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'AV. CRISTOVÃO COLOMBO','2782',NULL,'90560-002','HIGIENÓPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (244,'WAL MART','WAL MART','WAL MART',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-08-11 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (245,'TI WORKS SOLUTIONS INFORMATICA LTDA','TI WORKS - Gestao de Recursos Humanos','TI WORKS','03.643.664/0001-67','J',NULL,'(51)30181588',NULL,NULL,'giovana@tiworksrh.com.br','www.tiworksrh.com.br','Giovana','2010-08-18 00:00:00',NULL,NULL,'RUA DOM PEDRO II','891','605','90550-142','SAO JOAO','PORTO ALEGRE','RS','BRASIL','RUA DOM PEDRO II','891','605','90550-142','SAO JOAO','PORTO ALEGRE','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'229.036-2-3',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (246,'VOKO INTERSTEEL MOVEIS LTDA','VOKO INTERSTEEL MOVEIS LTDA','VOKO','67.694.489/0001-10','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-08-19 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (247,'DONE TECNOLOGIA DA INFORMAÇÃO LTDA','DONE TECNOLOGIA DA INFORMAÇÃO LTDA','DONE TECNOLOGIA DA INFORMAÇÃO LTDA','03.420.367/0001-52','J','17.9508.2-1','051 3061-3663','9142-4418 Luciano',NULL,'lgbassani@done.com.br',NULL,NULL,'2010-09-13 00:00:00',NULL,NULL,'AV. SÃO PEDRO','1001','CONJ 204','90230-121','São Geraldo','PORTO ALEGRE','RS','BRASIL','AV. SÃO PEDRO','1001','CONJ 204','90230-121','São Geraldo','PORTO ALEGRE','RS','BRASIL','AV. SÃO PEDRO','1001','CONJ 204','90230-121','São Geraldo','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (248,'PONTO FRIO.COM','PONTO FRIO.COM','PONTO FRIO.COM','09.358.108/0002-06','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-09-23 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (249,'KALUNGA','KALUNGA','KALUNGA',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-09-23 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (250,'NOBRE OFÍCIO MOVÉIS E DECORAÇÕES','NOBRE OFÍCIO MOVÉIS E DECORAÇÕES','NOBRE OFÍCIO MOVÉIS E DECORAÇÕES',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-09-24 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (251,'ANGELA - FAXINA SP','ANGELA - FAXINA SP','ANGELA - FAXINA SP','111.171.798-26','F',NULL,'7241-0407',NULL,NULL,NULL,NULL,NULL,'2010-09-24 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (252,'LEROY MERLIN','LEROY MERLIN','LEROY MERLIN',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-10-18 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (253,'Comércio de Vidros Atlanticbox LTDA ME','ATLANTIC BOX','ATLANTIC BOX','54.769.096/0001-86','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-10-19 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (254,'R J DIEHL COM  DE MAT PARA MOV LTDA','R J DIEHL','R J DIEHL','92224062000103','J','096/2016551','51 32224655',NULL,NULL,NULL,NULL,NULL,'2010-10-27 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Rua Moura Azevedo','379',NULL,'90230151','SAO GERALDO','Porto Alegre','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (255,'4º TABELIONATO DE NOTAS','4º TABELIONATO DE NOTAS','4º TABELIONATO DE NOTAS','87382289000139','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-10-29 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (256,'ETS RENTALS -COMERCIO LOCACAO E IMPORTACAO DE EQUIPAMENTOS LTDA-ME','COMÉRCIO E LOCAÇÃO DE EQUIPAMENTOS LTDA','MICROESPAÇO AUTOMAÇÃO','08.723.770/0001-74','J','149.626.730.110','(11) 3277-2972',NULL,NULL,'microespaco@microespaco.com.br',NULL,'Everaldo T. Soubhia','2010-11-11 00:00:00',NULL,NULL,'AV LINS DE VASCONCELOS','89','SOBRELOJA',NULL,NULL,'SÃO PAULO','SP','BRASIL','AV LINS DE VASCONCELOS','89','SOBRELOJA',NULL,NULL,'SÃO PAULO','SP','BRASIL','AV LINS DE VASCONCELOS','89','SOBRELOJA',NULL,NULL,'SÃO PAULO','SP','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (257,'DROGARIA MANCUSO & ANDRIOLA LTDA','DROGABEL','DROGABEL','05.692.196/0001-46','J','0962992445',NULL,NULL,NULL,NULL,NULL,NULL,'2010-11-25 00:00:00',NULL,NULL,'AV PROTASIO ALVES','2633',NULL,'90410-002','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','AV PROTASIO ALVES','2633',NULL,'90410-002','PETROPOLIS','PORTO ALEGRE','RS','BRASIL','AV PROTASIO ALVES','2633',NULL,'90410-002','PETROPOLIS','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (258,'MBX Eventos Ltda','MBX Eventos Ltda','MBX Eventos Ltda',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-11-30 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (259,'Claro S/A','Claro','Claro - quiosque bourbom','40.432.544/0099-50','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-12-08 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Porto Alegre','RS',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (260,'CAPITAL DE GIRO - ITAU','CAPITAL DE GIRO - ITAU','CAPITAL DE GIRO - ITAU',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2011-01-27 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (261,'PLITHY INFORMATICA LTDA ME','PLITHY LOCAÇÕES','PLITHY',NULL,'F',NULL,'15*6822 Márcio','15*10887 Lygia','11-38585454','lygia@plithy.com.br','www.plithy.com.br',NULL,'2011-03-10 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'rua carandai','371',NULL,NULL,'casa verde',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (262,'HIDRAULICO - Everaldo','HIDRAULICO - Everaldo','HIDRAULICO - Everaldo',NULL,'F',NULL,'(51) 9985-9342',NULL,NULL,NULL,NULL,NULL,'2011-03-10 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (263,'ANA RITA PINHEIRO DA SILVA','( RITA) ANA RITA PINHEIRO DA SILVA','ANA RITA PINHEIRO DA SILVA','36154628072','F','RG 4016646657','11-78930339',NULL,NULL,'comercial@proevento.com.br',NULL,NULL,'2011-03-15 00:00:00',NULL,NULL,'Rua Baden Powel','494',NULL,'91110-040','Parque Minuano','Porto Alegre','RS','BRASIL','Rua Baden Powel','494',NULL,'91110-040','Parque Minuano','Porto Alegre','RS','BRASIL','Rua Baden Powel','494',NULL,'91110-040','Parque Minuano','Porto Alegre','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (264,'FREELANCER','FREELANCER','FREELANCER',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2011-03-24 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (265,'Fenomenal Loja Virtual','Fenomenal','Fenomenal',NULL,'F',NULL,NULL,NULL,NULL,'paula@fenomenal.com.br','PAULOA',NULL,'2011-06-07 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (266,'GOLDEN CROSS','GOLDEN CROSS','GOLDEN CROSS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2011-06-28 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (267,'KD EVENTOS CULTURAIS LTDA','KD EVENTOS CULTURAIS LTDA','KD EVENTOS CULTURAIS LTDA','09.619.430/0001-60','J',NULL,'(21) 2245-2778',NULL,NULL,NULL,NULL,NULL,'2011-07-01 00:00:00',NULL,NULL,'RUA DOUTOR LUIZ JANUARIO','406','SALA 303','28.990-000','CENTRO','SAQUAREMA','RJ','BRASIL','RUA DOUTOR LUIZ JANUARIO','406','SALA 303','28.990-000','CENTRO','SAQUAREMA','RJ','BRASIL','RUA DOUTOR LUIZ JANUARIO','406','SALA 303','28.990-000','CENTRO','SAQUAREMA','RJ','BRASIL','9989-5',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (268,'IMOBILIARIA LEINDECKER','IMOBILIARIA LEINDECKER','IMOBILIARIA LEINDECKER',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2011-07-04 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (269,'SUL AMÉRICA SEGURO SAÚDE S.A','SUL AMÉRICA','SUL AMÉRICA',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2011-07-11 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (270,'EVERALDO','EVERALDO','EVERALDO',NULL,'F',NULL,'99859342',NULL,NULL,NULL,NULL,NULL,'2011-07-14 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (271,'Paraiso das Flores','Paraiso das Flores','Paraiso das Flores',NULL,'F',NULL,'3333 7723','9912-0647',NULL,NULL,NULL,'Toninho','2011-07-14 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (272,'CME - Comercial de Materiais Elétricos.','CME - Comercial de Materiais Elétricos.','CME - Comercial de Materiais Elétricos.',NULL,'F',NULL,'32273477',NULL,'32273334',NULL,NULL,NULL,'2011-07-14 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (273,'RTEX','RTEX','RTEX',NULL,'F',NULL,'7774-1703',NULL,NULL,NULL,NULL,'RENATO','2011-07-25 00:00:00',NULL,NULL,'RUA DOUTOR CASTRO RAMOS','411',NULL,NULL,'VILA NIVI','SÃO PAULO','SP','BRASIL','RUA DOUTOR CASTRO RAMOS','411',NULL,NULL,'VILA NIVI','SÃO PAULO','SP','BRASIL','RUA DOUTOR CASTRO RAMOS','411',NULL,NULL,'VILA NIVI','SÃO PAULO','SP','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (274,'WMS SUPERMERCADOS DO BRASIL LTDA','NACIONAL SUPERMERCADO','NACIONAL SUPERMERCADO','93209765003728','J','096/2115622',NULL,NULL,NULL,NULL,NULL,NULL,'2011-08-25 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2036572-1',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (275,'INNOVARE EVENTOS LTDA','INNOVARE EVENTOS LTDA','INNOVARE EVENTOS LTDA','02.146.031/0001-80','J','2.628.179-1','(11) 9972-8523',NULL,NULL,NULL,NULL,NULL,'2011-09-13 00:00:00',NULL,NULL,'Rua Orwille Derby','148',NULL,'03112-030','Mooca','São Paulo','SP','BRASIL','Rua Orwille Derby','148',NULL,'03112-030','Mooca','São Paulo','SP','BRASIL','Rua Orwille Derby','148',NULL,'03112-030','Mooca','São Paulo','SP','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (276,'DATADESK INFORMÁTICA','DATADESK INFORMÁTICA','DATADESK INFORMÁTICA','07.080.866/0001-07','J','096/3054635','(51) 3346-2235','3346-2312',NULL,'datadesk@datadesk.com.br',NULL,'MICHELE LEAL','2011-09-23 00:00:00',NULL,NULL,'Av. Viena','35',NULL,'90240-020','São Geraldo','PORTO ALEGRE','RS','BRASIL','Av. Viena','35',NULL,'90240-020','São Geraldo','PORTO ALEGRE','RS','BRASIL','Av. Viena','35',NULL,'90240-020','São Geraldo','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (277,'MARCIO ANTUNES (técnico)','MARCIO ANTUNES (técnico)','MARCIO ANTUNES (técnico)','30340169899','F','RG 24.598.313-2','11-96259644',NULL,NULL,'sonicmalic@hotmail.com',NULL,NULL,'2011-09-29 00:00:00',NULL,NULL,'Rua Joaquim Norberto','395',NULL,NULL,NULL,NULL,NULL,NULL,'Rua Joaquim Norberto','395',NULL,NULL,NULL,'São Paulo','SP','BRASIL','Rua Joaquim Norberto','395',NULL,NULL,NULL,NULL,NULL,NULL,'Itau-Ag2959 CC.13161',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (278,'A&E JARDINS','A&E JARDINS','A&E JARDINS','10231180000176','J',NULL,'34466559','98073268',NULL,'aejardins@gmail.com',NULL,NULL,'2011-09-30 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (279,'Atlas - Manutenção dos Elevadores','Atlas - Manutenção dos Elevadores',NULL,NULL,'F',NULL,'3360-3838',NULL,NULL,NULL,NULL,NULL,'2011-10-13 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (280,'LIDER ETIQUETAS LTDA','LIDER ETIQUETAS LTDA','LIDER ETIQUETAS LTDA','10791444000146','J','0963299913','51 30221482',NULL,NULL,NULL,NULL,NULL,'2011-10-14 00:00:00',NULL,NULL,'AV. NILO RUSCHEL','160',NULL,'91260220','PROTASIO ALVES','PORTO ALEGRE','RS','BRASIL','AV. NILO RUSCHEL','160',NULL,'91260220','PROTASIO ALVES','PORTO ALEGRE','RS','BRASIL','AV. NILO RUSCHEL','160',NULL,'91260220','PROTASIO ALVES','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (281,'SWAT NETWORK LTDA','Former Consultoria em Projetos','SWAT NETWORK LTDA','03.750.548/0001-47','J','096/2807036',NULL,NULL,NULL,NULL,NULL,NULL,'2011-10-21 00:00:00',NULL,NULL,'RUA DR. CAMPOS VELHO','519','APTO 602',NULL,NULL,'PORTO ALEGRE','RS','BRASIL','RUA DR. CAMPOS VELHO','519','APTO 602',NULL,NULL,'PORTO ALEGRE','RS','BRASIL','RUA DR. CAMPOS VELHO','519','APTO 602',NULL,NULL,'PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (282,'TELIUM TELECOMINICAÇÕES LTDA','TELIUM TELECOMINICAÇÕES LTDA','TELIUM TELECOMINICAÇÕES LTDA','07.272.054/0001-55','J',NULL,'(11) 4003-5900',NULL,NULL,NULL,NULL,NULL,'2011-10-21 00:00:00',NULL,NULL,'AV DAS NAÇOES UNIDAS','13.797','BLOCO 3 - 1º e 2º AND','04794-00','MORUMBI','SÃO PAULO','SP','BRASIL','AV DAS NAÇOES UNIDAS','13.797','BLOCO 3 - 1º e 2º AND','04794-00','MORUMBI','SÃO PAULO','SP','BRASIL','AV DAS NAÇOES UNIDAS','13.797','BLOCO 3 - 1º e 2º AND','04794-00','MORUMBI','SÃO PAULO','SP','BRASIL','3.387.358-5',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (283,'GOOGLE BRASIL INTERNET LTDA','GOOGLE','GOOGLE',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2011-11-14 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (284,'IMK EVENTOS LTDA - ME','IMK EVENTOS LTDA','IMK EVENTOS LTDA','10.781.481/0001-73','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2011-12-06 00:00:00',NULL,NULL,'RUA FRANCISCA COSTA D. TITA','613',NULL,'74075-300','SETOR AEROPORTO','GOIANIA','GO','BRASIL','RUA FRANCISCA COSTA D. TITA','613',NULL,'74075-300','SETOR AEROPORTO','GOIANIA','GO','BRASIL','RUA FRANCISCA COSTA D. TITA','613',NULL,'74075-300','SETOR AEROPORTO','GOIANIA','GO','BRASIL','264.059-7',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (286,'IMPRETEC ARTES GRÁFICAS LTDA','IMPRETEC ARTES GRÁFICAS LTDA','IMPRETEC ARTES GRÁFICAS LTDA','04174501000145','J',NULL,'(51)30129629','(51)30287090','(51)30287090','impretec@terra.com.br','www.impretec.com.br',NULL,'2011-12-16 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Av. Ipiranga','5200','quiosque 39',NULL,NULL,'Porto Alegre','RS','Brasil',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'192.139.2.1',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (287,'BICDATA SERVICOS E COMERCIO DE EQUIPAMENTOS ELETRONICOS LTDA','BicData','BicData','07.429.811/0001-51','J','117072669110','11 2978-4411',NULL,NULL,NULL,NULL,NULL,'2011-12-28 00:00:00',NULL,NULL,'Rua Quedas','486',NULL,'02082-030','PARADA INGLESA','São Paulo','SP','BRASIL','Rua Quedas','486',NULL,'02082-030','PARADA INGLESA','São Paulo','SP','BRASIL','Rua Quedas','486',NULL,'02082-030','PARADA INGLESA','São Paulo','SP','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (288,'Serasa S.A','Serasa Experian','Serasa Experian','62.173.620/0001-80','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-01-04 00:00:00',NULL,NULL,'AL DOS QUINIMURAS','187',NULL,'04068-000','INDIANOPOLIS','SÃO PAULO','SP','BRASIL','AL DOS QUINIMURAS','187',NULL,'04068-000','INDIANOPOLIS','SÃO PAULO','SP','BRASIL','AL DOS QUINIMURAS','187',NULL,'04068-000','INDIANOPOLIS','SÃO PAULO','SP','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (289,'IRRF S/ FÉRIAS','IRRF S/ FÉRIAS','IRRF S/ FÉRIAS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-01-12 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (290,'MORONI URQUIDI (freelancer Virtual Bag)','MORONI URQUIDI (freelancer Virtual Bag)','MORONI URQUIDI (freelancer Virtual Bag)','388.917.918-57','F',NULL,NULL,NULL,NULL,'moroniurquidi@gmail.com <moroniurquidi@gmail.com>',NULL,NULL,'2012-01-25 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (291,'WEBER ALVES (técnico)','WEBER ALVES (técnico)','WEBER ALVES (técnico)','213.827.62879','F','RG: 23.175.950-2','11-7185-5895','11-7024-1686','11 5077-4458',NULL,NULL,NULL,'2012-01-25 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (292,'EDUARDO SILVA ALVES (técnico)','EDUARDO SILVA ALVES (técnico)','EDUARDO SILVA ALVES (técnico)','360.883.628-47','F','RG:42.920.674-4',NULL,NULL,NULL,NULL,NULL,NULL,'2012-01-25 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (293,'EDUARDO ROBERTO MORAES (técnico)','EDUARDO ROBERTO MORAES (técnico)','EDUARDO ROBERTO MORAES (técnico)','249.446.868-03','F','RG:  24.885.267-X','(11)2309 7255','(11) 8990-4732',NULL,'edu.r.moraes@bol.com.br',NULL,NULL,'2012-01-25 00:00:00',NULL,NULL,'R. Tuiuti','589','ap114 bl 4','03081-000','Tatuape','São Paulo','SP','Brasil','R. Tuiuti','589','ap114 bl 4','03081-000','Tatuape','São Paulo','SP','Brasil','R. Tuiuti','589','ap114 bl 4','03081-000','Tatuape','São Paulo','SP','Brasil',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (294,'GJR - OLIVEIRA e RUY LTDA.','GELSON - AR CONDICIONADO','GELSON - AR CONDICIONADO','02.465.973/0001-21','J',NULL,'9962-6266',NULL,NULL,NULL,NULL,NULL,'2012-01-26 00:00:00',NULL,NULL,'Av. Brasiliano Indio de Moraes','342','2',NULL,NULL,'Porto Alegre','RS','BRASIL','Av. Brasiliano Indio de Moraes','342','2',NULL,NULL,'Porto Alegre','RS','BRASIL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'167.837.2.7',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (295,'VANESSA PORTO - FREELANCER','VANESSA PORTO - FREELANCER','VANESSA PORTO - FREELANCER',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-02-16 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (296,'DANILO GUEDES - FREELANCER','DANILO GUEDES - FREELANCER','DANILO GUEDES - FREELANCER',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-02-16 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (297,'NESPRESSO','NESPRESSO','NESPRESSO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-02-28 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (298,'ISTOCK INTERNACIONAL','ISTOCK INTERNACIONAL','ISTOCK INTERNACIONAL',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-02-28 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (299,'LIA JANAINA FERLA BARBOSA - ME','SOS SERVIÇOS - Tele Carimbo','SOS SERVIÇOS - Tele Carimbo','02257912000179','J','096/3437542','(51)3328 4334','(51)9962 1948',NULL,'telecarimbo@telecarimbo.com.br','www.telecarimbo.com.br',NULL,'2012-03-13 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'AV. PLINIO BRASIL MILANO','1100','Loja 102',NULL,'Higenópolis','Porto Alegre','RS','Brasil',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (300,'Janaina da Silva - FREELANCER','Janaina da Silva - FREELANCER','Janaina da Silva - FREELANCER',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-03-14 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (301,'MONICA FERRAZ - FREELANCER','MONICA FERRAZ - FREELANCER','MONICA FERRAZ - FREELANCER',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-03-14 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (302,'Maria Isabel Thompson - FREELANCER','Maria Isabel Thompson - FREELANCER','Maria Isabel Thompson - FREELANCER',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-03-14 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (303,'LEONARDO PERUSATO MERLINO','ARMAZEM DE CAMISETAS','ARMAZEM DE CAMISETAS','10931636000100','J','096/3314068','(51)3029 8123',NULL,NULL,NULL,'www.armazemdecamisetas.com.br',NULL,'2012-03-19 00:00:00',NULL,NULL,'Av. Alberto Bins','821',NULL,'90030-143','CENTRO','PORTO ALEGRE','RS','BRASIL','Av. Alberto Bins','821',NULL,'90030-143','CENTRO','PORTO ALEGRE','RS','BRASIL','Av. Alberto Bins','821',NULL,'90030-143','CENTRO','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (304,'CONTRIBUIÇÃO PREVIDENCIÁRIA','CONTRIBUIÇÃO PREVIDENCIÁRIA','CONTRIBUIÇÃO PREVIDENCIÁRIA',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-03-23 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (305,'EZEQUIEL TRISCH','EZEQUIEL TRISCH','EZEQUIEL TRISCH','14.573.581/0001-65','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-03-29 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'54424720',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (306,'DIANA BERTRAMI - FREELANCER','DIANA BERTRAMI - FREELANCER','DIANA BERTRAMI - FREELANCER','346.738.078/63','F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-04-05 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (307,'NOVA INTERNET E DESIGN LTDA','NOVA DESIGN STUDIO','NOVA INTERNET E DESIGN LTDA','11296216000162','J',NULL,'(51) 3026-3651',NULL,NULL,'nova@nova.art.br','www.nova.art.br','Norton','2012-04-05 00:00:00',NULL,NULL,'Av. França','1400','204','90230-220','São João','Porto Alegre','RS','Brasil','Av. França','1400','204','90230-220','São João','Porto Alegre','RS','Brasil','Av. França','1400','204','90230-220','São João','Porto Alegre','RS','Brasil',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (308,'CARTORIO DO 12º TABELIÃO DE NOTAS','CARTORIO DO 12º TABELIÃO DE NOTAS','CARTORIO DO 12º TABELIÃO DE NOTAS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-04-13 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (309,'DISK DRINK','DISK DRINK','DISK DRINK','66.132.952/0001-95','J',NULL,'(11) 3064-8400','(11) 3064-1312',NULL,NULL,NULL,NULL,'2012-04-13 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (310,'ANT REFRIGERAÇÃO','ANT REFRIGERAÇÃO','ANT REFRIGERAÇÃO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-04-18 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (311,'RICARDO ELETRO','RICARDO ELETRO','RICARDO ELETRO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-04-19 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (312,'SHOP TIME','SHOP TIME','SHOP TIME',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-04-19 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (313,'CIELO','CIELO','CIELO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-04-20 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (314,'PAULO ADDAIR - FREELANCER','PAULO ADDAIR - FREELANCER','PAULO ADDAIR - FREELANCER','007.234.198-09','F',NULL,'(11) 7152 4433','(11) 9831 0844',NULL,'pauloadd@gmail.com',NULL,NULL,'2012-05-09 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (315,'CLUBE FARRAPOS - HOTEL DE TRANSITO','CLUBE FARRAPOS - HOTEL DE TRANSITO','CLUBE FARRAPOS - HOTEL DE TRANSITO','92.989.003/0001-18','J','ISENTO','51 3382-8016','51 3381-3214',NULL,NULL,NULL,NULL,'2012-05-10 00:00:00',NULL,NULL,'R PROF CRISTIANO FISCHER','1331',NULL,'91.410-001','PARTENON','PORTO ALEGRE','RS','BRASIL','R PROF CRISTIANO FISCHER','1331',NULL,'91.410-001','PARTENON','PORTO ALEGRE','RS','BRASIL','R PROF CRISTIANO FISCHER','1331',NULL,'91.410-001','PARTENON','PORTO ALEGRE','RS','BRASIL',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (316,'DevMedia Editora','DevMedia Editora','DevMedia Editora',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-05-14 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (317,'Taiane Ramos Moreira (Técnico Freelancer)','Taiane Ramos Moreira (Técnico Freelancer)','Taiane Ramos Moreira (Técnico Freelancer)',NULL,'F',NULL,'11-54319639','11-58316792',NULL,'taiane_rm@hotmail.com',NULL,NULL,'2012-05-17 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (318,'HOTEL FORMULE 1','HOTEL FORMULE 1','HOTEL FORMULE 1',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-06-11 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (319,'Daiany de Melo Marcelino da Silva','DAIANY DE MELO - FREELANCER','DAIANY DE MELO - FREELANCER',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-07-13 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (320,'Mauricio Bettim','MAURICIO BETTIM - FREELANCER','MAURICIO BETTIM - FREELANCER',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-07-13 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (321,'Associação Brasileira de Empresas de Eventos','ABEOC','ABEOC',NULL,'J',NULL,'(48) 3039-1058',NULL,NULL,NULL,NULL,NULL,'2012-07-27 00:00:00',NULL,NULL,'R.Feliciano Nunes Pires','35',NULL,'88015-220','Centro','Florianópolis','SC',' Brasil','R.Feliciano Nunes Pires','35',NULL,'88015-220','Centro','Florianópolis','SC',' Brasil','R.Feliciano Nunes Pires','35',NULL,'88015-220','Centro','Florianópolis','SC',' Brasil',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (322,'BALÃO DA INFORMATICA','SUPER BALÃO','SUPER BALÃO',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-08-06 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (323,'AUGUSTOS RIO COPA HOTEL ','HOTEL AUGUSTO\'S RIO ','HOTEL AUGUSTO\'S RIO ',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-08-22 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (324,'TREND FAIRS','TREND FAIRS','TREND FAIRS',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-08-23 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (325,'ADECIL COMERCIAL LTDA','ADECIL','ADECIL',NULL,'J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-08-23 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (326,'MEETING PROFESSIONALS ','MEETING PROFESSIONALS ','MEETING PROFESSIONALS ',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-08-23 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (327,'WEBJET LINHAS AEREAS ','WEBJET','WEBJET',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-08-23 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (328,'MARIA APARECIDA TERRA JUSTINO ME.','ROGERS DECORAÇÃO','ROGERS DECORAÇÃO','02.748.406/0001-82','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-08-27 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (329,'CORDOES DIGITAL LTDA','CORDOES DIGITAL LTDA ','CORDOES DIGITAL LTDA','14.393.991/0001-24','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-08-29 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (330,'ADRIANA RUANOBA SCARZELLA - tradutora Espanhol','ADRIANA RUANOBA SCARZELLA - tradutora Espanhol','ADRIANA RUANOBA SCARZELLA - tradutora Espanhol',NULL,'F',NULL,NULL,NULL,NULL,'ars144@hotmail.com',NULL,'Adriana','2012-08-29 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Rua Carazinho','576','Ap. 401',NULL,'Petrópolis','Porto Alegre','RS','Brasil',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (331,'CALINCA BONIATTI','CALINCA BONIATTI','CALINCA BONIATTI',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-09-18 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (332,'Yoshimoto','Yoshimoto','MANUTENÇÃO DOS PORTÕES - CONDOMINIO BLUE TOWER',NULL,'F',NULL,'(051)3335-3326',NULL,NULL,NULL,NULL,NULL,'2012-09-24 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (333,'GRAFICA POWER','GRAFICA POWER','GRAFICA POWER',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-09-24 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (334,'GARE DR - GUIA DE ARRECADAÇÃO ESTADUAL','GARE DR - GUIA DE ARRECADAÇÃO ESTADUAL','GARE DR - GUIA DE ARRECADAÇÃO ESTADUAL',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-09-25 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (335,'GOL LOG SERVICO DE CARGAS AEREAS','GOL LOG SERVICO DE CARGAS AEREAS','GOL LOG SERVICO DE CARGAS AEREAS','07.575651/0001-63','J','0963179330',NULL,NULL,NULL,NULL,NULL,NULL,'2012-10-01 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (336,'PRO IMAGEM EQUIPAMENTOS AUDIO VISUAL','PRO IMAGEM EQUIPAMENTOS AUDIO VISUAL','PRO IMAGEM EQUIPAMENTOS AUDIO VISUAL','07.876.878/0001-34','J',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-10-08 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (337,'Dayan Zanenga Golanski','Dayan Zanenga Golanski','Dayan Zanenga Golanski',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-10-11 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (338,'TEAR PAULISTA CONFECCOES LTDA','TEAR PAULISTA CONFECCOES LTDA','TEAR PAULISTA CONFECCOES LTDA',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-10-15 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),
 (339,'Criart Letras Com. Visual','Criart Letras ','Criart Letras ',NULL,'F',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2012-10-18 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `ent_fornecedor` ENABLE KEYS */;


--
-- Definition of table `ent_historico`
--

DROP TABLE IF EXISTS `ent_historico`;
CREATE TABLE `ent_historico` (
  `COD_HISTORICO` int(11) NOT NULL AUTO_INCREMENT,
  `TIPO` varchar(50) DEFAULT NULL,
  `CODIGO` int(11) DEFAULT NULL,
  `TEXTO` text,
  `ARQUIVO_ANEXO` longtext,
  `SYS_DTT_INS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `SYS_USR_INS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_HISTORICO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ent_historico`
--

/*!40000 ALTER TABLE `ent_historico` DISABLE KEYS */;
/*!40000 ALTER TABLE `ent_historico` ENABLE KEYS */;


--
-- Definition of table `fin_banco`
--

DROP TABLE IF EXISTS `fin_banco`;
CREATE TABLE `fin_banco` (
  `COD_BANCO` int(10) NOT NULL AUTO_INCREMENT,
  `NUM_BANCO` varchar(50) DEFAULT NULL,
  `NOME` varchar(250) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_BANCO`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fin_banco`
--

/*!40000 ALTER TABLE `fin_banco` DISABLE KEYS */;
INSERT INTO `fin_banco` (`COD_BANCO`,`NUM_BANCO`,`NOME`,`DT_INATIVO`) VALUES 
 (1,'001','Banco do Brasil',NULL),
 (2,'341','Itaú',NULL),
 (3,'041','Banrisul',NULL),
 (4,'409','Unibanco',NULL),
 (5,'237','Bradesco','2007-05-11 00:00:00'),
 (6,'104','Caixa Economica Federal',NULL);
/*!40000 ALTER TABLE `fin_banco` ENABLE KEYS */;


--
-- Definition of table `fin_centro_custo`
--

DROP TABLE IF EXISTS `fin_centro_custo`;
CREATE TABLE `fin_centro_custo` (
  `COD_CENTRO_CUSTO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CENTRO_CUSTO_PAI` int(10) DEFAULT NULL,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(250) DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `NIVEL` int(10) DEFAULT NULL,
  `COD_REDUZIDO` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_CENTRO_CUSTO`),
  KEY `DT_INATIVO` (`DT_INATIVO`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fin_centro_custo`
--

/*!40000 ALTER TABLE `fin_centro_custo` DISABLE KEYS */;
INSERT INTO `fin_centro_custo` (`COD_CENTRO_CUSTO`,`COD_CENTRO_CUSTO_PAI`,`NOME`,`DESCRICAO`,`ORDEM`,`DT_INATIVO`,`NIVEL`,`COD_REDUZIDO`) VALUES 
 (1,NULL,'PROEVENTO','PROEVENTO',0,NULL,1,'01'),
 (9,1,'GERAL','GERAL',100,NULL,2,'01.01'),
 (10,1,'APLICAÇÃO FINANCEIRA','APLICAÇÃO FINANCEIRA',200,NULL,2,'01.02'),
 (11,1,'PROD 3CPD','PROD 3CPD',300,NULL,2,'01.03'),
 (12,11,'PROD 3CPD - GERAL','PROD 3CPD - GERAL',400,NULL,3,'01.03.01'),
 (13,11,'PROD 3CPD - PROSPECT','PROD 3CPD - PROSPECT',500,NULL,3,'01.03.02'),
 (14,11,'PROD 3CPD - GAUCHAFARMA','PROD 3CPD - GAUCHAFARMA',600,NULL,3,'01.03.03'),
 (15,11,'PROD 3CPD - MONTREALFARMA','PROD 3CPD - MONTREALFARMA',700,NULL,3,'01.03.04'),
 (16,11,'PROD 3CPD - CM','PROD 3CPD - CM',800,NULL,3,'01.03.05'),
 (17,1,'PROD ATHEMIS','PROD ATHEMIS',900,NULL,2,'01.04'),
 (18,17,'PROD ATHEMIS - GERAL','PROD ATHEMIS - GERAL',1000,NULL,3,'01.04.01'),
 (19,17,'PROD ATHEMIS - PROSPECT','PROD ATHEMIS - PROSPECT',1100,NULL,3,'01.04.02'),
 (20,17,'PROD ATHEMIS - GAUCHAFARMA','PROD ATHEMIS - GAUCHAFARMA',1200,NULL,3,'01.04.03'),
 (21,17,'PROD ATHEMIS - MONTREALFARMA','PROD ATHEMIS - MONTREALFARMA',1300,NULL,3,'01.04.04'),
 (22,1,'PROD 3SEC','PROD 3SEC',1400,NULL,2,'01.05'),
 (23,22,'PROD 3SEC - GERAL','PROD 3SEC - GERAL',1500,NULL,3,'01.05.01'),
 (24,22,'PROD 3SEC - PROSPECT','PROD 3SEC - PROSPECT',1600,NULL,3,'01.05.02'),
 (25,22,'PROD 3SEC - CM','PROD 3SEC - CM',1700,NULL,3,'01.05.03'),
 (26,22,'PROD 3SEC - COREN','PROD 3SEC - COREN',1800,NULL,3,'01.05.04'),
 (27,1,'PROD COLETOR','PROD COLETOR',1900,NULL,2,'01.06'),
 (28,27,'PROD COLETOR - GERAL','PROD COLETOR - GERAL',2000,NULL,3,'01.06.01'),
 (29,27,'PROD COLETOR - PROSPECT','PROD COLETOR - PROSPECT',2100,NULL,3,'01.06.02'),
 (30,27,'PROD COLETOR - CM','PROD COLETOR - CM',2200,NULL,3,'01.06.03'),
 (31,27,'PROD COLETOR - PREAT a PORTER','PROD COLETOR - PREAT a PORTER',2300,NULL,3,'01.06.04'),
 (32,27,'PROD COLETOR - HAIR BRASIL','PROD COLETOR - HAIR BRASIL',2400,NULL,3,'01.06.05'),
 (33,27,'PROD COLETOR - INTERMODAL','PROD COLETOR - INTERMODAL',2500,NULL,3,'01.06.06'),
 (34,27,'PROD COLETOR - HOSPITALAR','PROD COLETOR - HOSPITALAR',2600,NULL,3,'01.06.07'),
 (35,27,'PROD COLETOR - CBAC','PROD COLETOR - CBAC',2700,NULL,3,'01.06.08'),
 (36,27,'PROD COLETOR - ABUP','PROD COLETOR - ABUP',2800,NULL,3,'01.06.09'),
 (37,27,'PROD COLETOR - EXPO ENFERMAGEM','PROD COLETOR - EXPO ENFERMAGEM',2900,NULL,3,'01.06.10'),
 (38,1,'PROD DATAWIDE','PROD DATAWIDE',3000,NULL,2,'01.07'),
 (39,38,'PROD DATAWIDE - GERAL','PROD DATAWIDE - GERAL',3100,NULL,3,'01.07.01'),
 (40,38,'PROD DATAWIDE - PROSPECT','PROD DATAWIDE - PROSPECT',3200,NULL,3,'01.07.02'),
 (41,38,'PROD DATAWIDE - ABRH','PROD DATAWIDE - ABRH',3300,NULL,3,'01.07.03'),
 (42,38,'PROD DATAWIDE - ABUP','PROD DATAWIDE - ABUP',3400,NULL,3,'01.07.04'),
 (43,38,'PROD DATAWIDE - CM','PROD DATAWIDE - CM',3500,NULL,3,'01.07.05'),
 (44,1,'PROD LOCAÇÃO DE HW','PROD LOCAÇÃO DE HW',3600,NULL,2,'01.08'),
 (45,44,'PROD LOCAÇÃO DE HW - GERAL','PROD LOCAÇÃO DE HW - GERAL',3700,NULL,3,'01.08.01'),
 (46,44,'PROD LOCAÇÃO DE HW - PROSPECT','PROD LOCAÇÃO DE HW - PROSPECT',3800,NULL,3,'01.08.02'),
 (47,44,'PROD LOCAÇÃO DE HW - ABUP','PROD LOCAÇÃO DE HW - ABUP',3900,NULL,3,'01.08.03'),
 (48,44,'PROD LOCAÇÃO DE HW - CM','PROD LOCAÇÃO DE HW - CM',4000,NULL,3,'01.08.04'),
 (49,44,'PROD LOCAÇÃO DE HW - FEHOESP','PROD LOCAÇÃO DE HW - FEHOESP',4100,NULL,3,'01.08.05'),
 (50,44,'PROD LOCAÇÃO DE HW - OTA','PROD LOCAÇÃO DE HW - OTA',4200,NULL,3,'01.08.06'),
 (51,44,'PROD LOCAÇÃO DE HW - SCAMILO','PROD LOCAÇÃO DE HW - SCAMILO',4300,NULL,3,'01.08.07'),
 (52,1,'PROD LOCAÇÃO DE RH','PROD LOCAÇÃO DE RH',4400,NULL,2,'01.09'),
 (53,52,'PROD LOCAÇÃO DE RH - GERAL','PROD LOCAÇÃO DE RH - GERAL',4500,NULL,3,'01.09.01'),
 (54,52,'PROD LOCAÇÃO DE RH - PROSPECT','PROD LOCAÇÃO DE RH - PROSPECT',4600,NULL,3,'01.09.02'),
 (55,52,'PROD LOCAÇÃO DE RH - ABUP','PROD LOCAÇÃO DE RH - ABUP',4700,NULL,3,'01.09.03'),
 (56,52,'PROD LOCAÇÃO DE RH - CM','PROD LOCAÇÃO DE RH - CM',4800,NULL,3,'01.09.04'),
 (57,52,'PROD LOCAÇÃO DE RH - FEHOESP','PROD LOCAÇÃO DE RH - FEHOESP',4900,NULL,3,'01.09.05'),
 (58,52,'PROD LOCAÇÃO DE RH - OTA','PROD LOCAÇÃO DE RH - OTA',5000,NULL,3,'01.09.06'),
 (59,52,'PROD LOCAÇÃO DE RH - SCAMILO','PROD LOCAÇÃO DE RH - SCAMILO',5100,NULL,3,'01.09.07'),
 (60,1,'PROD MANUTENCAO HW','PROD MANUTENCAO HW',5200,NULL,2,'01.10'),
 (61,60,'PROD MANUTENCAO HW - GERAL','PROD MANUTENCAO HW - GERAL',5300,NULL,3,'01.10.01'),
 (62,60,'PROD MANUTENCAO HW - PROSPECT','PROD MANUTENCAO HW - PROSPECT',5400,NULL,3,'01.10.02'),
 (63,60,'PROD MANUTENCAO HW - CM','PROD MANUTENCAO HW - CM',5500,NULL,3,'01.10.03'),
 (64,1,'PROD MANUTENCAO SW','PROD MANUTENCAO SW',5600,NULL,2,'01.11'),
 (65,64,'PROD MANUTENCAO SW - GERAL','PROD MANUTENCAO SW - GERAL',5700,NULL,3,'01.11.01'),
 (66,64,'PROD MANUTENCAO SW - PROSPECT','PROD MANUTENCAO SW - PROSPECT',5800,NULL,3,'01.11.02'),
 (67,1,'PROD PLANTÃO TÉCNICO','PROD PLANTÃO TÉCNICO',5900,NULL,2,'01.12'),
 (68,67,'PROD PLANTÃO TÉCNICO - GERAL','PROD PLANTÃO TÉCNICO - GERAL',6000,NULL,3,'01.12.01'),
 (69,67,'PROD PLANTÃO TÉCNICO - PROSPECT','PROD PLANTÃO TÉCNICO - PROSPECT',6100,NULL,3,'01.12.02'),
 (70,1,'PROD REDE','PROD REDE',6200,NULL,2,'01.13'),
 (71,70,'PROD REDE - GERAL','PROD REDE - GERAL',6300,NULL,3,'01.13.01'),
 (72,70,'PROD REDE - PROSPECT','PROD REDE - PROSPECT',6400,NULL,3,'01.13.02'),
 (73,70,'PROD REDE - CM','PROD REDE - CM',6500,NULL,3,'01.13.03'),
 (74,1,'PROD REDECONN','PROD REDECONN',6600,NULL,2,'01.14'),
 (75,74,'PROD REDECONN - GERAL','PROD REDECONN - GERAL',6700,NULL,3,'01.14.01'),
 (76,74,'PROD REDECONN - PROSPECT','PROD REDECONN - PROSPECT',6800,NULL,3,'01.14.02'),
 (77,74,'PROD REDECONN - REDEMAC','PROD REDECONN - REDEMAC',6900,NULL,3,'01.14.03'),
 (78,1,'PROD TRADE UNION','PROD TRADE UNION',7000,NULL,2,'01.15'),
 (79,78,'PROD TRADE UNION - GERAL','PROD TRADE UNION - GERAL',7100,NULL,3,'01.15.01'),
 (80,78,'PROD TRADE UNION - PROSPECT','PROD TRADE UNION - PROSPECT',7200,NULL,3,'01.15.02'),
 (81,78,'PROD TRADE UNION - SINDIEVENTOS','PROD TRADE UNION - SINDIEVENTOS',7300,NULL,3,'01.15.03'),
 (82,78,'PROD TRADE UNION - SINDIPROM','PROD TRADE UNION - SINDIPROM',7400,NULL,3,'01.15.04'),
 (83,78,'PROD TRADE UNION - UBRAFE','PROD TRADE UNION - UBRAFE',7500,NULL,3,'01.15.05'),
 (84,1,'PROD VBOSS','PROD VBOSS',7600,NULL,2,'01.16'),
 (85,84,'PROD VBOSS - GERAL','PROD VBOSS - GERAL',7700,NULL,3,'01.16.01'),
 (86,84,'PROD VBOSS - PROSPECT','PROD VBOSS - PROSPECT',7800,NULL,3,'01.16.02'),
 (87,84,'PROD VBOSS - STA CLARA','PROD VBOSS - STA CLARA',7900,NULL,3,'01.16.03'),
 (88,1,'PROD VISTA','PROD VISTA',8000,NULL,2,'01.17'),
 (89,88,'PROD VISTA - GERAL','PROD VISTA - GERAL',8100,NULL,3,'01.17.01'),
 (90,88,'PROD VISTA - PROSPECT','PROD VISTA - PROSPECT',8200,NULL,3,'01.17.02'),
 (91,88,'PROD VISTA - AB EVENTOS','PROD VISTA - AB EVENTOS',8300,NULL,3,'01.17.03'),
 (92,88,'PROD VISTA - ABUP','PROD VISTA - ABUP',8400,NULL,3,'01.17.04'),
 (93,88,'PROD VISTA - BOEING','PROD VISTA - BOEING',8500,NULL,3,'01.17.05'),
 (94,88,'PROD VISTA - CM','PROD VISTA - CM',8600,NULL,3,'01.17.06'),
 (95,88,'PROD VISTA - COREN','PROD VISTA - COREN',8700,NULL,3,'01.17.07'),
 (96,88,'PROD VISTA - CRAPR','PROD VISTA - CRAPR',8800,NULL,3,'01.17.08'),
 (97,88,'PROD VISTA - FEHOESP','PROD VISTA - FEHOESP',8900,NULL,3,'01.17.09'),
 (98,88,'PROD VISTA - OTA','PROD VISTA - OTA',9000,NULL,3,'01.17.10'),
 (99,88,'PROD VISTA - QE','PROD VISTA - QE',9100,NULL,3,'01.17.11'),
 (100,88,'PROD VISTA - SCAMILO','PROD VISTA - SCAMILO',9200,NULL,3,'01.17.12'),
 (101,1,'PROD WEB','PROD WEB',9300,NULL,2,'01.18'),
 (102,101,'PROD WEB - GERAL','PROD WEB - GERAL',9400,NULL,3,'01.18.01'),
 (103,101,'PROD WEB - PROSPECT','PROD WEB - PROSPECT',9500,NULL,3,'01.18.02'),
 (104,88,'PROD VISTA - SINDIEVENTOS','PROD VISTA - SINDIEVENTOS',9210,NULL,3,'01.17.13'),
 (105,88,'PROD VISTA - MALU LOSSO','PROD VISTA - MALU LOSSO',9220,NULL,3,'01.17.14'),
 (107,44,'PROD LOCAÇÃO DE HW - HSM','PROD LOCAÇÃO DE HW - HSM',4310,NULL,3,'01.08.08'),
 (108,44,'PROD LOCAÇÃO DE HW - CRA','PROD LOCAÇÃO DE HW - CRA',4320,NULL,3,'01.08.09'),
 (109,17,'PROD ATHEMIS - CCA','PROD ATHEMIS - CCA',1320,NULL,3,'01.04.05'),
 (110,64,'PROD MANUTENCAO SW - CM','PROD MANUTENCAO SW - CM',5820,NULL,3,'01.11.03'),
 (111,1,'PROD VIRTUALBAG','PROD VIRTUALBAG',9600,NULL,2,'01.19'),
 (112,111,'PROD VIRTUALBAG - GERAL','PROD VIRTUALBAG - GERAL',9700,NULL,3,'01.19.01'),
 (113,111,'PROD VIRTUALBAG - PROSPECT','PROD VIRTUALBAG - PROSPECT',9800,NULL,3,'01.19.02'),
 (114,101,'PROD WEB - UBRAFE','PROD WEB - UBRAFE',9510,NULL,3,'01.18.03'),
 (115,101,'PROD WEB - MERCEDES','PROD WEB - MERCEDES',9520,NULL,3,'01.18.04'),
 (116,88,'PROD VISTA - COART','PROD VISTA - COART',9230,NULL,3,'01.17.15'),
 (117,88,'PROD VISTA - TRAVELWEEK','PROD VISTA - TRAVELWEEK',9240,NULL,3,'01.17.16'),
 (118,44,'PROD LOCAÇÃO DE HW - TRAVELWEEK','PROD LOCAÇÃO DE HW - TRAVELWEEK',4330,NULL,3,'01.08.10'),
 (119,44,'PROD LOCAÇÃO DE HW - HAIR BRASIL','PROD LOCAÇÃO DE HW - HAIR BRASIL',4340,NULL,3,'01.08.11'),
 (120,44,'PROD LOCAÇÃO DE HW - COREN','PROD LOCAÇÃO DE HW - COREN',4350,NULL,3,'01.08.12'),
 (121,88,'PROD VISTA - POLI JUNIOR','PROD VISTA - POLI JUNIOR',9250,NULL,3,'01.17.17'),
 (122,88,'PROD VISTA - ABRH','PROD VISTA - ABRH',9260,NULL,3,'01.17.18'),
 (123,88,'PROD VISTA - TECNOGOLD','PROD VISTA - TECNOGOLD',9270,NULL,3,'01.17.19'),
 (124,44,'PROD LOCAÇÃO DE HW - HOSPITALAR','PROD LOCAÇÃO DE HW - HOSPITALAR',4360,NULL,3,'01.08.13'),
 (125,27,'PROD COLETOR - MUNDOGEO','PROD COLETOR - MUNDOGEO',2910,NULL,3,'01.06.11'),
 (126,88,'PROD VISTA - MUNDOGEO','PROD VISTA - MUNDOGEO',9280,NULL,3,'01.17.20'),
 (127,88,'PROD VISTA - REAL ALLIANCE','PROD VISTA - REAL ALLIANCE',9290,NULL,3,'01.17.21'),
 (128,44,'PROD LOCAÇÃO DE HW - ASSINTECAL','PROD LOCAÇÃO DE HW - ASSINTECAL',NULL,NULL,3,'01.08.14'),
 (129,22,'PROD 3SEC - ASSINTECAL','PROD 3SEC - ASSINTECAL',NULL,NULL,3,'01.05.05'),
 (130,88,'PROD VISTA - ASSINTECAL','PROD VISTA - ASSINTECAL',NULL,NULL,3,'01.17.22'),
 (131,88,'PROD VISTA - IBGM','PROD VISTA - IBGM',NULL,NULL,3,'01.17.23'),
 (132,27,'PROD COLETOR - CONARH','PROD COLETOR - CONARH',NULL,NULL,3,'01.06.12'),
 (133,27,'PROD COLETOR - INSPIRAMAIS','PROD COLETOR - INSPIRAMAIS',NULL,NULL,3,'01.06.13'),
 (134,27,'PROD COLETOR - REABILITAÇÃO','PROD COLETOR - REABILITAÇÃO',NULL,NULL,3,'01.06.14'),
 (135,88,'PROD VISTA - ABAV','PROD VISTA - ABAV',NULL,NULL,3,'01.17.24'),
 (136,88,'PROD VISTA - IMAGINARE','PROD VISTA - IMAGINARE',NULL,NULL,3,'01.17.25'),
 (137,44,'PROD LOCAÇÃO DE HW - CONARH ABRH','PROD LOCAÇÃO DE HW - CONARH ABRH',NULL,NULL,3,'01.08.15'),
 (138,27,'PROD COLETOR - ABAV','PROD COLETOR - ABAV',NULL,NULL,3,'01.06.15'),
 (139,27,'PROD COLETOR - MALU LOSSO','PROD COLETOR - MALU LOSSO',NULL,NULL,3,'01.06.16'),
 (140,27,'PROD COLETOR - REAL ALLIANCE','PROD COLETOR - REAL ALLIANCE',NULL,NULL,3,'01.06.17'),
 (141,88,'PROD VISTA - IBM/GMARTINE','PROD VISTA - IBM/GMARTINE',NULL,NULL,3,'01.17.26');
/*!40000 ALTER TABLE `fin_centro_custo` ENABLE KEYS */;


--
-- Definition of table `fin_cheque`
--

DROP TABLE IF EXISTS `fin_cheque`;
CREATE TABLE `fin_cheque` (
  `COD_CHEQUE` int(10) NOT NULL AUTO_INCREMENT,
  `COD_BANCO` int(10) DEFAULT NULL,
  `NOMINAL` varchar(250) DEFAULT NULL,
  `NUM_CHEQUE` varchar(50) DEFAULT NULL,
  `DT_CHEQUE` datetime DEFAULT NULL,
  `VLR_CHEQUE` double(15,5) DEFAULT NULL,
  `CIDADE` varchar(250) DEFAULT NULL,
  `SYS_DT_CRIACAO` datetime DEFAULT NULL,
  `SYS_COD_USER_CRIACAO` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`COD_CHEQUE`),
  KEY `DT_CHEQUE` (`DT_CHEQUE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fin_cheque`
--

/*!40000 ALTER TABLE `fin_cheque` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_cheque` ENABLE KEYS */;


--
-- Definition of table `fin_conta`
--

DROP TABLE IF EXISTS `fin_conta`;
CREATE TABLE `fin_conta` (
  `COD_CONTA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(250) DEFAULT NULL,
  `TIPO` varchar(50) DEFAULT NULL,
  `COD_BANCO` int(10) DEFAULT NULL,
  `AGENCIA` varchar(50) DEFAULT NULL,
  `CONTA` varchar(50) DEFAULT NULL,
  `DT_CADASTRO` datetime DEFAULT NULL,
  `VLR_SALDO_INI` double(15,5) DEFAULT NULL,
  `VLR_SALDO` double(15,5) DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CONTA`),
  KEY `DT_INATIVO` (`DT_INATIVO`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fin_conta`
--

/*!40000 ALTER TABLE `fin_conta` DISABLE KEYS */;
INSERT INTO `fin_conta` (`COD_CONTA`,`NOME`,`DESCRICAO`,`TIPO`,`COD_BANCO`,`AGENCIA`,`CONTA`,`DT_CADASTRO`,`VLR_SALDO_INI`,`VLR_SALDO`,`ORDEM`,`DT_INATIVO`) VALUES 
 (1,'ITAU','CONTA CORRENTE PRINCIPAL (SP)','CONTA CORRENTE',2,'0367','76458-6','2005-01-01 00:00:00',0.00000,0.00000,10,NULL),
 (2,'CAIXA RS','DINHEIRO EM CAIXA FILIAL - Porto Alegre/RS','DINHEIRO',NULL,NULL,NULL,'2005-01-01 00:00:00',0.00000,0.00000,20,NULL),
 (3,'CAIXA SP','DINHEIRO EM CAIXA MATRIZ - São Paulo/SP','DINHEIRO',NULL,NULL,NULL,'2005-01-01 00:00:00',0.00000,0.00000,30,NULL),
 (4,'CARTAO ITAU','CARTAO DE CREDITO CORPORATIVO','CARTAO DE CREDITO',2,'0367','76458-6','2005-01-01 00:00:00',0.00000,0.00000,40,NULL),
 (7,'ITAU (EMPRESTIMO)','EMPRESTIMOS TOMADOS PELO PROEVENTO','OUTROS',1,NULL,NULL,'2005-01-01 00:00:00',0.00000,0.00000,70,NULL),
 (8,'ITAUVEST PLUS - Reserva coletores','Fundo para guardar o dinheiro para o repasse dos coletores','INVESTIMENTOS',2,NULL,NULL,'2011-03-04 00:00:00',0.00000,0.00000,50,NULL),
 (9,'ITAU MAX DI - Reserva Coletores','Fundo para guardar o dinheiro para o repasse dos coletores','INVESTIMENTOS',2,NULL,NULL,'2011-05-06 00:00:00',0.00000,0.00000,55,NULL),
 (10,'ITAU MAX RF - Reserva 13','Fundo para guardar o dinheiro para o pagamento do 13 salario','INVESTIMENTOS',2,NULL,NULL,'2012-04-10 00:00:00',0.00000,0.00000,60,NULL),
 (11,'ITAU ESPECIAL DI - Reserva Convenção','Fundo para guardar o dinheiro para convençao Proevento','INVESTIMENTOS',2,NULL,NULL,'2012-04-24 00:00:00',0.00000,0.00000,65,NULL);
/*!40000 ALTER TABLE `fin_conta` ENABLE KEYS */;


--
-- Definition of table `fin_conta_pagar_receber`
--

DROP TABLE IF EXISTS `fin_conta_pagar_receber`;
CREATE TABLE `fin_conta_pagar_receber` (
  `COD_CONTA_PAGAR_RECEBER` int(10) NOT NULL AUTO_INCREMENT,
  `PAGAR_RECEBER` tinyint(1) NOT NULL DEFAULT '0',
  `COD_GRUPO` varchar(5) DEFAULT NULL,
  `TIPO` varchar(50) DEFAULT NULL,
  `CODIGO` int(10) DEFAULT NULL,
  `COD_CONTA` int(10) DEFAULT NULL,
  `COD_PLANO_CONTA` int(10) DEFAULT NULL,
  `COD_CENTRO_CUSTO` int(10) DEFAULT NULL,
  `DT_EMISSAO` datetime DEFAULT NULL,
  `DT_VCTO` datetime DEFAULT NULL,
  `VLR_CONTA` double(15,5) DEFAULT NULL,
  `HISTORICO` varchar(250) DEFAULT NULL,
  `TIPO_DOCUMENTO` varchar(120) DEFAULT NULL,
  `NUM_DOCUMENTO` varchar(50) DEFAULT NULL,
  `OBS` longtext,
  `EXTRA` longtext,
  `SITUACAO` varchar(15) DEFAULT NULL,
  `COD_NF` int(10) DEFAULT NULL,
  `NUM_NF` varchar(20) DEFAULT NULL,
  `NUM_IMPRESSOES` int(10) DEFAULT NULL,
  `COD_CONTRATO` int(11) DEFAULT NULL,
  `SYS_DT_CRIACAO` datetime DEFAULT NULL,
  `SYS_COD_USER_CRIACAO` varchar(120) DEFAULT NULL,
  `SYS_DT_ULT_LCTO` datetime DEFAULT NULL,
  `SYS_COD_USER_ULT_LCTO` varchar(120) DEFAULT NULL,
  `SYS_DT_CANCEL` datetime DEFAULT NULL,
  `SYS_COD_USER_CANCEL` varchar(120) DEFAULT NULL,
  `SYS_DT_ALTERACAO` datetime DEFAULT NULL,
  `SYS_COD_USER_ALTERACAO` varchar(120) DEFAULT NULL,
  `COD_MIGRACAO` int(11) DEFAULT NULL,
  `COD_NF_MIGRACAO` int(11) DEFAULT NULL,
  `NUM_NF_MIGRACAO` varchar(20) DEFAULT NULL,
  `ARQUIVO_ANEXO` varchar(250) DEFAULT NULL,
  `MARCA_NFE` varchar(20) DEFAULT NULL,
  `VLR_CONTA_ORIG` double(15,3) DEFAULT NULL,
  PRIMARY KEY (`COD_CONTA_PAGAR_RECEBER`),
  KEY `COD_CENTRO_CUSTO` (`COD_CENTRO_CUSTO`),
  KEY `COD_CONTA` (`COD_CONTA`),
  KEY `COD_GRUPO` (`COD_GRUPO`),
  KEY `COD_PLANO_CONTA` (`COD_PLANO_CONTA`),
  KEY `CODIGO` (`CODIGO`),
  KEY `NUM_NF` (`NUM_NF`),
  KEY `SITUACAO` (`SITUACAO`),
  KEY `TIPO` (`TIPO`),
  KEY `DT_VCTO` (`DT_VCTO`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fin_conta_pagar_receber`
--

/*!40000 ALTER TABLE `fin_conta_pagar_receber` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_conta_pagar_receber` ENABLE KEYS */;


--
-- Definition of table `fin_conta_pagar_receber_taxas`
--

DROP TABLE IF EXISTS `fin_conta_pagar_receber_taxas`;
CREATE TABLE `fin_conta_pagar_receber_taxas` (
  `COD_CONTA_TAXAS` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CONTA_PAGAR_RECEBER` int(10) DEFAULT NULL,
  `TIPO` varchar(50) DEFAULT NULL,
  `CODIGO` int(10) DEFAULT NULL,
  `VLR_BASE` double(15,3) DEFAULT NULL,
  `TOTAL_IRRF` double(15,3) DEFAULT NULL,
  `TOTAL_PIS` double(15,3) DEFAULT NULL,
  `TOTAL_COFINS` double(15,3) DEFAULT NULL,
  `TOTAL_CSOCIAL` double(15,3) DEFAULT NULL,
  `TOTAL_IRPJ` double(15,3) DEFAULT NULL,
  `TOTAL_ISSQN` double(15,3) DEFAULT NULL,
  `TOTAL_IMPOSTOS` double(15,3) DEFAULT NULL,
  `TOTAL_REDUCAO` double(15,3) DEFAULT NULL,
  `VLR_FINAL` double(15,3) DEFAULT NULL,
  `COD_ACUM_IRRF` int(10) DEFAULT NULL,
  `COD_ACUM_REDUCAO` int(10) DEFAULT NULL,
  `TOTAL_ACUM_IRRF` double(15,3) DEFAULT NULL,
  `TOTAL_ACUM_REDUCAO` double(15,3) DEFAULT NULL,
  `COD_CFG_NF` int(10) DEFAULT NULL,
  `ALIQ_IRRF` double(15,3) DEFAULT NULL,
  `ALIQ_PIS` double(15,3) DEFAULT NULL,
  `ALIQ_COFINS` double(15,3) DEFAULT NULL,
  `ALIQ_CSOCIAL` double(15,3) DEFAULT NULL,
  `ALIQ_IRPJ` double(15,3) DEFAULT NULL,
  `ALIQ_ISSQN` double(15,3) DEFAULT NULL,
  `SYS_DT_CRIACAO` datetime DEFAULT NULL,
  `SYS_COD_USER_CRIACAO` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`COD_CONTA_TAXAS`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fin_conta_pagar_receber_taxas`
--

/*!40000 ALTER TABLE `fin_conta_pagar_receber_taxas` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_conta_pagar_receber_taxas` ENABLE KEYS */;


--
-- Definition of table `fin_lcto_em_conta`
--

DROP TABLE IF EXISTS `fin_lcto_em_conta`;
CREATE TABLE `fin_lcto_em_conta` (
  `COD_LCTO_EM_CONTA` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CONTA` int(10) DEFAULT NULL,
  `OPERACAO` varchar(50) DEFAULT NULL,
  `TIPO` varchar(50) DEFAULT NULL,
  `CODIGO` int(10) DEFAULT NULL,
  `HISTORICO` varchar(250) DEFAULT NULL,
  `COD_PLANO_CONTA` int(10) DEFAULT NULL,
  `COD_CENTRO_CUSTO` int(10) DEFAULT NULL,
  `NUM_LCTO` varchar(50) DEFAULT NULL,
  `DT_LCTO` datetime DEFAULT NULL,
  `VLR_LCTO` double(15,5) DEFAULT NULL,
  `OBS` longtext,
  `SYS_DT_CRIACAO` datetime DEFAULT NULL,
  `SYS_COD_USER_CRIACAO` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`COD_LCTO_EM_CONTA`),
  KEY `COD_CENTRO_CUSTO` (`COD_CENTRO_CUSTO`),
  KEY `COD_CONTA` (`COD_CONTA`),
  KEY `COD_PLANO_CONTA` (`COD_PLANO_CONTA`),
  KEY `CODIGO` (`CODIGO`),
  KEY `TIPO` (`TIPO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fin_lcto_em_conta`
--

/*!40000 ALTER TABLE `fin_lcto_em_conta` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_lcto_em_conta` ENABLE KEYS */;


--
-- Definition of table `fin_lcto_ordinario`
--

DROP TABLE IF EXISTS `fin_lcto_ordinario`;
CREATE TABLE `fin_lcto_ordinario` (
  `COD_LCTO_ORDINARIO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CONTA_PAGAR_RECEBER` int(10) DEFAULT NULL,
  `TIPO` varchar(50) DEFAULT NULL,
  `CODIGO` varchar(50) DEFAULT NULL,
  `COD_CONTA` int(10) DEFAULT NULL,
  `COD_PLANO_CONTA` int(10) DEFAULT NULL,
  `COD_CENTRO_CUSTO` int(10) DEFAULT NULL,
  `HISTORICO` varchar(250) DEFAULT NULL,
  `NUM_LCTO` varchar(50) DEFAULT NULL,
  `DT_LCTO` datetime DEFAULT NULL,
  `VLR_ORIG` double(15,5) DEFAULT NULL,
  `VLR_MULTA` double(15,5) DEFAULT NULL,
  `VLR_JUROS` double(15,5) DEFAULT NULL,
  `VLR_DESC` double(15,5) DEFAULT NULL,
  `VLR_LCTO` double(15,5) DEFAULT NULL,
  `OBS` longtext,
  `EXTRA` longtext,
  `SYS_DT_CRIACAO` datetime DEFAULT NULL,
  `SYS_COD_USER_CRIACAO` varchar(120) DEFAULT NULL,
  `SYS_DT_CANCEL` datetime DEFAULT NULL,
  `SYS_COD_USER_CANCEL` varchar(120) DEFAULT NULL,
  `COD_PLANO_CONTA_ORIG` int(10) DEFAULT NULL,
  `COD_MIGRACAO` int(11) DEFAULT NULL,
  PRIMARY KEY (`COD_LCTO_ORDINARIO`),
  KEY `COD_CENTRO_CUSTO` (`COD_CENTRO_CUSTO`),
  KEY `COD_CONTA` (`COD_CONTA`),
  KEY `COD_CONTA_PAGAR_RECEBER` (`COD_CONTA_PAGAR_RECEBER`),
  KEY `COD_PLANO_CONTA` (`COD_PLANO_CONTA`),
  KEY `CODIGO` (`CODIGO`),
  KEY `TIPO` (`TIPO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fin_lcto_ordinario`
--

/*!40000 ALTER TABLE `fin_lcto_ordinario` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_lcto_ordinario` ENABLE KEYS */;


--
-- Definition of table `fin_lcto_transf`
--

DROP TABLE IF EXISTS `fin_lcto_transf`;
CREATE TABLE `fin_lcto_transf` (
  `COD_LCTO_TRANSF` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CONTA_ORIG` int(10) DEFAULT NULL,
  `COD_CONTA_DEST` int(10) DEFAULT NULL,
  `NUM_LCTO` varchar(50) DEFAULT NULL,
  `VLR_LCTO` double(15,5) DEFAULT NULL,
  `DT_LCTO` datetime DEFAULT NULL,
  `HISTORICO` varchar(250) DEFAULT NULL,
  `OBS` longtext,
  `SYS_DT_CRIACAO` datetime DEFAULT NULL,
  `SYS_COD_USER_CRIACAO` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`COD_LCTO_TRANSF`),
  KEY `COD_CONTA` (`COD_CONTA_ORIG`),
  KEY `COD_CONTA1` (`COD_CONTA_DEST`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fin_lcto_transf`
--

/*!40000 ALTER TABLE `fin_lcto_transf` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_lcto_transf` ENABLE KEYS */;


--
-- Definition of table `fin_plano_conta`
--

DROP TABLE IF EXISTS `fin_plano_conta`;
CREATE TABLE `fin_plano_conta` (
  `COD_PLANO_CONTA` int(10) NOT NULL AUTO_INCREMENT,
  `COD_PLANO_CONTA_PAI` int(10) DEFAULT NULL,
  `COD_REDUZIDO` varchar(50) DEFAULT NULL,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(250) DEFAULT NULL,
  `NIVEL` int(10) DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  `DRE` tinyint(1) NOT NULL DEFAULT '0',
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_PLANO_CONTA`),
  KEY `DT_INATIVO` (`DT_INATIVO`)
) ENGINE=InnoDB AUTO_INCREMENT=496 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fin_plano_conta`
--

/*!40000 ALTER TABLE `fin_plano_conta` DISABLE KEYS */;
INSERT INTO `fin_plano_conta` (`COD_PLANO_CONTA`,`COD_PLANO_CONTA_PAI`,`COD_REDUZIDO`,`NOME`,`DESCRICAO`,`NIVEL`,`ORDEM`,`DRE`,`DT_INATIVO`) VALUES 
 (458,NULL,'','PROEVENTO','',1,NULL,1,NULL),
 (459,458,'1','RECEITAS EM GERAL','RECEITAS EM GERAL',2,100,-1,NULL),
 (460,458,'2','DESPESAS EM GERAL','DESPESAS EM GERAL',2,200,-1,NULL),
 (461,458,'3','DIRETORIA DESPESAS','DIRETORIA DESPESAS',2,300,-1,NULL),
 (462,459,'1.01','RECEITA LICENÇA DE USO VISTA','RECEITA LICENÇA DE USO VISTA',3,10,-1,NULL),
 (463,459,'1.02','RECEITA LICENÇA DE USO STUDIO','RECEITA LICENÇA DE USO STUDIO',3,20,-1,NULL),
 (464,459,'1.03','RECEITA PLANTÃO TÉCNICO','RECEITA PLANTÃO TÉCNICO',3,30,-1,NULL),
 (465,459,'1.04','RECEITA COLETOR DE DADOS','RECEITA COLETOR DE DADOS',3,40,-1,NULL),
 (466,459,'1.05','RECEITA LOCAÇAO DE HW','RECEITA LOCAÇAO DE HW',3,50,-1,NULL),
 (467,459,'1.06','RECEITA LOCAÇÃO DE RH','RECEITA LOCAÇÃO DE RH',3,60,-1,NULL),
 (468,460,'2.01','DESPESAS SALARIOS','DESPESAS SALARIOS',3,10,-1,NULL),
 (469,460,'2.02','DESPESAS ENCARGOS PESSOAL','DESPESAS ENCARGOS PESSOAL',3,20,-1,NULL),
 (470,460,'2.03','DESPESAS CMV INFRA-ESTRUTURA','DESPESAS CMV INFRA-ESTRUTURA',3,30,-1,NULL),
 (471,460,'2.04','DESPESAS ESCRITORIO TELECOM','DESPESAS ESCRITORIO TELECOM',3,40,-1,NULL),
 (472,460,'2.05','DESPESAS MATERIAL ESCRITORIO','DESPESAS MATERIAL ESCRITORIO',3,50,-1,NULL),
 (473,460,'2.06','DESPESAS ALUGUEL','DESPESAS ALUGUEL',3,60,-1,NULL),
 (474,460,'2.07','DESPESAS COMERCIAL','DESPESAS COMERCIAL',3,70,-1,NULL),
 (475,460,'2.08','DESPESAS OPERACIONAL','DESPESAS OPERACIONAL',3,80,-1,NULL),
 (476,460,'2.09','DESPESAS ESCRITORIO INFRA','DESPESAS ESCRITORIO INFRA',3,90,-1,NULL),
 (477,460,'2.10','DESPESAS IMOBILIZADO','DESPESAS IMOBILIZADO',3,100,-1,NULL),
 (478,460,'2.11','DESPESAS MARKETING','DESPESAS MARKETING',3,110,-1,NULL),
 (479,460,'2.12','DESPESAS TERCEIROS','DESPESAS TERCEIROS',3,120,-1,NULL),
 (480,460,'2.13','DESPESAS CMV OPERACIONAL','DESPESAS CMV OPERACIONAL',3,130,-1,NULL),
 (481,460,'2.14','DESPESAS TREINAMENTO','DESPESAS TREINAMENTO',3,140,-1,NULL),
 (482,460,'2.15','DESPESAS BANCÁRIAS','DESPESAS BANCÁRIAS',3,150,-1,NULL),
 (483,461,'3.01','DIRETORIA DISTRIB LUCROS','DIRETORIA DISTRIB LUCROS',3,10,-1,NULL),
 (484,461,'3.02','DIRETORIA INTEGRALIZAÇÃO','DIRETORIA INTEGRALIZAÇÃO',3,20,-1,NULL),
 (486,460,'2.16','DESPESAS IMPOSTOS','DESPESAS IMPOSTOS EM GERAL',3,160,-1,NULL),
 (487,459,'1.07','RECEITA LICENÇA DE USO TRADE UNION','RECEITA LICENÇA DE USO TRADE UNION',3,21,-1,NULL),
 (488,459,'1.09','APLICAÇÃO FINANCEIRA','APLICAÇÃO FINANCEIRA',3,70,1,NULL),
 (489,459,'1.08','RECEITA LICENÇA DE USO DATAWIDE','RECEITA LICENÇA DE USO DATAWIDE',3,23,1,NULL),
 (490,459,'1.10','RECEITA WEB (ATHCSM/HOSP/SIS WEB)','RECEITA WEB (ATHCSM/HOSP/SIS WEB)',3,26,0,NULL),
 (491,459,'1.11','RECEITA MANUTENCAO HW','RECEITA MANUTENCAO HW',3,65,0,NULL),
 (492,459,'1.12','PRESTACAO DE SERVICOS','PRESTACAO DE SERVICOS',3,27,1,NULL),
 (493,460,'2.17','DESPESAS JUROS','DESPESAS JUROS',3,170,1,NULL),
 (494,459,'1.13','RECEITA LICENÇA DE VIRTUAL BOSS','RECEITA LICENÇA DE VIRTUAL BOSS',3,25,1,NULL),
 (495,460,'2.18','DESPESAS ASSOCIAÇÕES/FILIAÇÕES','DESPESAS ASSOCIAÇÕES/FILIAÇÕES',3,NULL,1,NULL);
/*!40000 ALTER TABLE `fin_plano_conta` ENABLE KEYS */;


--
-- Definition of table `fin_plano_prev_orca`
--

DROP TABLE IF EXISTS `fin_plano_prev_orca`;
CREATE TABLE `fin_plano_prev_orca` (
  `COD_PLANO_PREV_ORCA` int(10) NOT NULL AUTO_INCREMENT,
  `COD_PREV_ORCA` int(10) DEFAULT NULL,
  `COD_PLANO_CONTA` int(10) DEFAULT NULL,
  `COD_REDUZIDO` varchar(50) DEFAULT NULL,
  `VALOR` double(15,5) DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_ALT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_PLANO_PREV_ORCA`),
  KEY `COD_PLANO_CONTA` (`COD_PLANO_CONTA`),
  KEY `COD_PREV_ORCA` (`COD_PREV_ORCA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fin_plano_prev_orca`
--

/*!40000 ALTER TABLE `fin_plano_prev_orca` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_plano_prev_orca` ENABLE KEYS */;


--
-- Definition of table `fin_prev_orca`
--

DROP TABLE IF EXISTS `fin_prev_orca`;
CREATE TABLE `fin_prev_orca` (
  `COD_PREV_ORCA` int(10) NOT NULL AUTO_INCREMENT,
  `DESCRICAO` varchar(250) DEFAULT NULL,
  `DT_PREV_INI` datetime DEFAULT NULL,
  `DT_PREV_FIM` datetime DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_PREV_ORCA`),
  KEY `DT_PREV_FIM` (`DT_PREV_FIM`),
  KEY `DT_PREV_INI` (`DT_PREV_INI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fin_prev_orca`
--

/*!40000 ALTER TABLE `fin_prev_orca` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_prev_orca` ENABLE KEYS */;


--
-- Definition of table `fin_saldo_ac`
--

DROP TABLE IF EXISTS `fin_saldo_ac`;
CREATE TABLE `fin_saldo_ac` (
  `COD_SALDO_AC` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CONTA` int(10) DEFAULT NULL,
  `MES` int(10) DEFAULT NULL,
  `ANO` int(10) DEFAULT NULL,
  `VALOR` double(15,5) DEFAULT NULL,
  `RECALCULADO` tinyint(1) NOT NULL DEFAULT '0',
  `SYS_COD_USER_ULT_LCTO` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`COD_SALDO_AC`),
  UNIQUE KEY `COD_SALDO_AC` (`COD_SALDO_AC`),
  KEY `ANO` (`ANO`),
  KEY `COD_CONTA` (`COD_CONTA`),
  KEY `MES` (`MES`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fin_saldo_ac`
--

/*!40000 ALTER TABLE `fin_saldo_ac` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_saldo_ac` ENABLE KEYS */;


--
-- Definition of table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
CREATE TABLE `inventario` (
  `COD_INVENTARIO` int(10) NOT NULL AUTO_INCREMENT,
  `ID_ITEM` varchar(50) DEFAULT NULL,
  `NOME_ITEM` varchar(255) DEFAULT NULL,
  `DESC_ITEM` longtext,
  `DT_COMPRA` datetime DEFAULT NULL,
  `LOCAL_COMPRA` longtext,
  `PRC_COMPRA` double(15,5) DEFAULT NULL,
  `DT_GARANTIA` datetime DEFAULT NULL,
  `TIPO` varchar(30) DEFAULT NULL,
  `MARCA` varchar(255) DEFAULT NULL,
  `DIVISAO` varchar(255) DEFAULT NULL,
  `PROPRIEDADE` varchar(255) DEFAULT NULL,
  `OBS` longtext,
  `ARQUIVO_ANEXO` longtext,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DT_INS` datetime DEFAULT NULL,
  `SYS_USR_INS` varchar(20) DEFAULT NULL,
  `SYS_DT_ALT` datetime DEFAULT NULL,
  `SYS_USR_ALT` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`COD_INVENTARIO`),
  UNIQUE KEY `Index_E45BA8A0_0CF8_426F` (`COD_INVENTARIO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `inventario`
--

/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;


--
-- Definition of table `mb_dado`
--

DROP TABLE IF EXISTS `mb_dado`;
CREATE TABLE `mb_dado` (
  `COD_DADO` int(10) NOT NULL AUTO_INCREMENT,
  `ID` varchar(10) DEFAULT NULL,
  `CDU` varchar(50) DEFAULT NULL,
  `CDD` varchar(50) DEFAULT NULL,
  `TITULO` varchar(250) DEFAULT NULL,
  `PRODUTOR` varchar(250) DEFAULT NULL,
  `ANO` int(10) DEFAULT NULL,
  `MIDIA` varchar(20) DEFAULT NULL,
  `FORMATO` varchar(20) DEFAULT NULL,
  `TAMANHO` varchar(20) DEFAULT NULL,
  `PRAZO_EMPR` int(10) DEFAULT NULL,
  `LOCADO` char(1) DEFAULT NULL,
  `LOCALIZACAO` varchar(20) DEFAULT NULL,
  `AQUISICAO` datetime DEFAULT NULL,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `PROPRIEDADE` varchar(250) DEFAULT NULL,
  `EXTRA` varchar(50) DEFAULT NULL,
  `IMG_THUMB` varchar(250) DEFAULT NULL,
  `IMG` varchar(250) DEFAULT NULL,
  `OBS` longtext,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_ID_USUARIO_ALT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_DADO`),
  UNIQUE KEY `Index_7984326E_41E4_46AB` (`COD_DADO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_dado`
--

/*!40000 ALTER TABLE `mb_dado` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_dado` ENABLE KEYS */;


--
-- Definition of table `mb_dado_categoria`
--

DROP TABLE IF EXISTS `mb_dado_categoria`;
CREATE TABLE `mb_dado_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  UNIQUE KEY `Index_9A7808EB_4E82_450D` (`COD_CATEGORIA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_dado_categoria`
--

/*!40000 ALTER TABLE `mb_dado_categoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_dado_categoria` ENABLE KEYS */;


--
-- Definition of table `mb_dado_item`
--

DROP TABLE IF EXISTS `mb_dado_item`;
CREATE TABLE `mb_dado_item` (
  `COD_DADO_ITEM` int(10) NOT NULL AUTO_INCREMENT,
  `COD_DADO` int(10) DEFAULT NULL,
  `TITULO` varchar(250) DEFAULT NULL,
  `EXTRA` varchar(250) DEFAULT NULL,
  `TAMANHO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`COD_DADO_ITEM`),
  UNIQUE KEY `Index_A9C8EC68_5EB2_41A9` (`COD_DADO_ITEM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_dado_item`
--

/*!40000 ALTER TABLE `mb_dado_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_dado_item` ENABLE KEYS */;


--
-- Definition of table `mb_disco`
--

DROP TABLE IF EXISTS `mb_disco`;
CREATE TABLE `mb_disco` (
  `COD_DISCO` int(10) NOT NULL AUTO_INCREMENT,
  `ID` varchar(10) DEFAULT NULL,
  `CDU` varchar(50) DEFAULT NULL,
  `CDD` varchar(50) DEFAULT NULL,
  `TITULO` varchar(250) DEFAULT NULL,
  `BANDA` varchar(250) DEFAULT NULL,
  `EDICAO` varchar(10) DEFAULT NULL,
  `GRAVADORA` varchar(50) DEFAULT NULL,
  `SELO` varchar(50) DEFAULT NULL,
  `PRODUTOR` varchar(250) DEFAULT NULL,
  `ANO` int(10) DEFAULT NULL,
  `TEMPO` varchar(10) DEFAULT NULL,
  `MIDIA` varchar(20) DEFAULT NULL,
  `PRAZO_EMPR` int(10) DEFAULT NULL,
  `LOCADO` char(1) DEFAULT NULL,
  `IDIOMA` varchar(20) DEFAULT NULL,
  `LOCALIZACAO` varchar(20) DEFAULT NULL,
  `AQUISICAO` datetime DEFAULT NULL,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `ESTILO` varchar(50) DEFAULT NULL,
  `PROPRIEDADE` varchar(250) DEFAULT NULL,
  `EXTRA` varchar(50) DEFAULT NULL,
  `IMG_THUMB` varchar(250) DEFAULT NULL,
  `IMG` varchar(250) DEFAULT NULL,
  `OBS` longtext,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_ID_USUARIO_ALT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_DISCO`),
  UNIQUE KEY `Index_29CFFDDB_2CF3_4A3B` (`COD_DISCO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_disco`
--

/*!40000 ALTER TABLE `mb_disco` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_disco` ENABLE KEYS */;


--
-- Definition of table `mb_disco_categoria`
--

DROP TABLE IF EXISTS `mb_disco_categoria`;
CREATE TABLE `mb_disco_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  UNIQUE KEY `Index_C787BDFA_65EC_47ED` (`COD_CATEGORIA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_disco_categoria`
--

/*!40000 ALTER TABLE `mb_disco_categoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_disco_categoria` ENABLE KEYS */;


--
-- Definition of table `mb_disco_item`
--

DROP TABLE IF EXISTS `mb_disco_item`;
CREATE TABLE `mb_disco_item` (
  `COD_DISCO_ITEM` int(10) NOT NULL AUTO_INCREMENT,
  `COD_DISCO` int(10) DEFAULT NULL,
  `TITULO` varchar(250) DEFAULT NULL,
  `AUTORES` varchar(250) DEFAULT NULL,
  `TEMPO` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`COD_DISCO_ITEM`),
  UNIQUE KEY `Index_48452C98_BF5C_47D3` (`COD_DISCO_ITEM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_disco_item`
--

/*!40000 ALTER TABLE `mb_disco_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_disco_item` ENABLE KEYS */;


--
-- Definition of table `mb_livro`
--

DROP TABLE IF EXISTS `mb_livro`;
CREATE TABLE `mb_livro` (
  `COD_LIVRO` int(10) NOT NULL AUTO_INCREMENT,
  `ID` varchar(10) DEFAULT NULL,
  `CDU` varchar(50) DEFAULT NULL,
  `CDD` varchar(50) DEFAULT NULL,
  `TITULO` varchar(250) DEFAULT NULL,
  `AUTORES` longtext,
  `EDITORA` varchar(250) DEFAULT NULL,
  `EDICAO` varchar(10) DEFAULT NULL,
  `ANO` int(10) DEFAULT NULL,
  `CODBAR` varchar(25) DEFAULT NULL,
  `ISBN` varchar(25) DEFAULT NULL,
  `LOCALIZACAO` varchar(20) DEFAULT NULL,
  `PRAZO_EMPR` int(10) DEFAULT NULL,
  `LOCADO` char(1) DEFAULT NULL,
  `IDIOMA` varchar(20) DEFAULT NULL,
  `AQUISICAO` datetime DEFAULT NULL,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `ASSUNTO` varchar(250) DEFAULT NULL,
  `CLASSE` varchar(250) DEFAULT NULL,
  `VOLUME` varchar(10) DEFAULT NULL,
  `PROPRIEDADE` varchar(250) DEFAULT NULL,
  `EXTRA` varchar(50) DEFAULT NULL,
  `IMG_THUMB` varchar(250) DEFAULT NULL,
  `IMG` varchar(250) DEFAULT NULL,
  `RESENHA` longtext,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_ID_USUARIO_ALT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_LIVRO`),
  UNIQUE KEY `Index_3D5FD521_2D6C_48BC` (`COD_LIVRO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_livro`
--

/*!40000 ALTER TABLE `mb_livro` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_livro` ENABLE KEYS */;


--
-- Definition of table `mb_livro_categoria`
--

DROP TABLE IF EXISTS `mb_livro_categoria`;
CREATE TABLE `mb_livro_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  UNIQUE KEY `Index_6B030CEF_02DB_4156` (`COD_CATEGORIA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_livro_categoria`
--

/*!40000 ALTER TABLE `mb_livro_categoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_livro_categoria` ENABLE KEYS */;


--
-- Definition of table `mb_manual`
--

DROP TABLE IF EXISTS `mb_manual`;
CREATE TABLE `mb_manual` (
  `COD_MANUAL` int(10) NOT NULL AUTO_INCREMENT,
  `ID` varchar(10) DEFAULT NULL,
  `CDU` varchar(50) DEFAULT NULL,
  `CDD` varchar(50) DEFAULT NULL,
  `TITULO` varchar(250) DEFAULT NULL,
  `AUTORES` longtext,
  `EDITORA` varchar(250) DEFAULT NULL,
  `EDICAO` varchar(10) DEFAULT NULL,
  `ANO` int(10) DEFAULT NULL,
  `CODBAR` varchar(25) DEFAULT NULL,
  `ISBN` varchar(25) DEFAULT NULL,
  `LOCALIZACAO` varchar(20) DEFAULT NULL,
  `PRAZO_EMPR` int(10) DEFAULT NULL,
  `LOCADO` char(1) DEFAULT NULL,
  `IDIOMA` varchar(20) DEFAULT NULL,
  `AQUISICAO` datetime DEFAULT NULL,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `ASSUNTO` varchar(250) DEFAULT NULL,
  `CLASSE` varchar(250) DEFAULT NULL,
  `VOLUME` varchar(10) DEFAULT NULL,
  `PROPRIEDADE` varchar(250) DEFAULT NULL,
  `EXTRA` varchar(50) DEFAULT NULL,
  `IMG_THUMB` varchar(250) DEFAULT NULL,
  `IMG` varchar(250) DEFAULT NULL,
  `RESENHA` longtext,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_ID_USUARIO_ALT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_MANUAL`),
  UNIQUE KEY `Index_473B28DF_4553_4773` (`COD_MANUAL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_manual`
--

/*!40000 ALTER TABLE `mb_manual` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_manual` ENABLE KEYS */;


--
-- Definition of table `mb_manual_categoria`
--

DROP TABLE IF EXISTS `mb_manual_categoria`;
CREATE TABLE `mb_manual_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  UNIQUE KEY `Index_BACCF704_D7E5_487A` (`COD_CATEGORIA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_manual_categoria`
--

/*!40000 ALTER TABLE `mb_manual_categoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_manual_categoria` ENABLE KEYS */;


--
-- Definition of table `mb_revista`
--

DROP TABLE IF EXISTS `mb_revista`;
CREATE TABLE `mb_revista` (
  `COD_REVISTA` int(10) NOT NULL AUTO_INCREMENT,
  `ID` varchar(10) DEFAULT NULL,
  `CDU` varchar(50) DEFAULT NULL,
  `CDD` varchar(50) DEFAULT NULL,
  `NOME` varchar(250) DEFAULT NULL,
  `CAPA` varchar(250) DEFAULT NULL,
  `EDITORA` varchar(250) DEFAULT NULL,
  `EDICAO` varchar(10) DEFAULT NULL,
  `MES` int(10) DEFAULT NULL,
  `ANO` int(10) DEFAULT NULL,
  `CODBAR` varchar(25) DEFAULT NULL,
  `ISSN` varchar(25) DEFAULT NULL,
  `LOCALIZACAO` varchar(20) DEFAULT NULL,
  `PRAZO_EMPR` int(10) DEFAULT NULL,
  `LOCADO` char(1) DEFAULT NULL,
  `IDIOMA` varchar(20) DEFAULT NULL,
  `AQUISICAO` datetime DEFAULT NULL,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `ASSUNTO` varchar(250) DEFAULT NULL,
  `CLASSE` varchar(250) DEFAULT NULL,
  `VOLUME` varchar(10) DEFAULT NULL,
  `PROPRIEDADE` varchar(250) DEFAULT NULL,
  `EXTRA` varchar(50) DEFAULT NULL,
  `PERIODICIDADE` varchar(20) DEFAULT NULL,
  `IMG_THUMB` varchar(250) DEFAULT NULL,
  `IMG` varchar(250) DEFAULT NULL,
  `RESENHA` longtext,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_ID_USUARIO_ALT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_REVISTA`),
  UNIQUE KEY `Index_807617F0_2B23_4AC0` (`COD_REVISTA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_revista`
--

/*!40000 ALTER TABLE `mb_revista` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_revista` ENABLE KEYS */;


--
-- Definition of table `mb_revista_categoria`
--

DROP TABLE IF EXISTS `mb_revista_categoria`;
CREATE TABLE `mb_revista_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  UNIQUE KEY `Index_22761AF1_0448_4362` (`COD_CATEGORIA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_revista_categoria`
--

/*!40000 ALTER TABLE `mb_revista_categoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_revista_categoria` ENABLE KEYS */;


--
-- Definition of table `mb_video`
--

DROP TABLE IF EXISTS `mb_video`;
CREATE TABLE `mb_video` (
  `COD_VIDEO` int(10) NOT NULL AUTO_INCREMENT,
  `ID` varchar(10) DEFAULT NULL,
  `CDU` varchar(50) DEFAULT NULL,
  `CDD` varchar(50) DEFAULT NULL,
  `TITULO_ORIG` varchar(250) DEFAULT NULL,
  `TITULO_TRAD` varchar(250) DEFAULT NULL,
  `ATORES` longtext,
  `DIRECAO` varchar(250) DEFAULT NULL,
  `EDICAO` varchar(10) DEFAULT NULL,
  `TEMPO` varchar(10) DEFAULT NULL,
  `PRODUTOR` varchar(250) DEFAULT NULL,
  `ANO` int(10) DEFAULT NULL,
  `NACIONALIDADE` varchar(50) DEFAULT NULL,
  `DISTRIBUIDORA` varchar(250) DEFAULT NULL,
  `DIST_CONTATO` varchar(250) DEFAULT NULL,
  `MIDIA` varchar(20) DEFAULT NULL,
  `PRAZO_EMPR` int(10) DEFAULT NULL,
  `LOCADO` char(1) DEFAULT NULL,
  `IDIOMAS` varchar(250) DEFAULT NULL,
  `LEGENDAS` varchar(250) DEFAULT NULL,
  `LOCALIZACAO` varchar(20) DEFAULT NULL,
  `AQUISICAO` datetime DEFAULT NULL,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `TEMATICA` varchar(250) DEFAULT NULL,
  `CLASSE` varchar(250) DEFAULT NULL,
  `VOLUME` varchar(10) DEFAULT NULL,
  `PROPRIEDADE` varchar(250) DEFAULT NULL,
  `EXTRA` varchar(50) DEFAULT NULL,
  `IMG_THUMB` varchar(250) DEFAULT NULL,
  `IMG` varchar(250) DEFAULT NULL,
  `RESENHA` longtext,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_ID_USUARIO_ALT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_VIDEO`),
  UNIQUE KEY `Index_D33881A6_405C_4C56` (`COD_VIDEO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_video`
--

/*!40000 ALTER TABLE `mb_video` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_video` ENABLE KEYS */;


--
-- Definition of table `mb_video_categoria`
--

DROP TABLE IF EXISTS `mb_video_categoria`;
CREATE TABLE `mb_video_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  UNIQUE KEY `Index_C6B82998_1902_4406` (`COD_CATEGORIA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mb_video_categoria`
--

/*!40000 ALTER TABLE `mb_video_categoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `mb_video_categoria` ENABLE KEYS */;


--
-- Definition of table `msg_anexo`
--

DROP TABLE IF EXISTS `msg_anexo`;
CREATE TABLE `msg_anexo` (
  `COD_MSG_ANEXO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_MENSAGEM` int(10) DEFAULT NULL,
  `ARQUIVO` varchar(255) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`COD_MSG_ANEXO`),
  KEY `MSG_ANEXOCOD_MENSAGEM` (`COD_MENSAGEM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `msg_anexo`
--

/*!40000 ALTER TABLE `msg_anexo` DISABLE KEYS */;
/*!40000 ALTER TABLE `msg_anexo` ENABLE KEYS */;


--
-- Definition of table `msg_destinatario`
--

DROP TABLE IF EXISTS `msg_destinatario`;
CREATE TABLE `msg_destinatario` (
  `COD_MSG_DESTINATARIO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_MENSAGEM` int(10) DEFAULT NULL,
  `COD_USER_DESTINATARIO` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`COD_MSG_DESTINATARIO`),
  KEY `MSG_DESTINATARIOCOD_MENSAGEM` (`COD_MENSAGEM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `msg_destinatario`
--

/*!40000 ALTER TABLE `msg_destinatario` DISABLE KEYS */;
/*!40000 ALTER TABLE `msg_destinatario` ENABLE KEYS */;


--
-- Definition of table `msg_mensagem`
--

DROP TABLE IF EXISTS `msg_mensagem`;
CREATE TABLE `msg_mensagem` (
  `COD_MENSAGEM` int(10) NOT NULL AUTO_INCREMENT,
  `COD_EMPRESA` int(10) DEFAULT NULL,
  `ASSUNTO` varchar(250) DEFAULT NULL,
  `MENSAGEM` longtext,
  `DT_ENVIO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_MENSAGEM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `msg_mensagem`
--

/*!40000 ALTER TABLE `msg_mensagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `msg_mensagem` ENABLE KEYS */;


--
-- Definition of table `msg_pasta`
--

DROP TABLE IF EXISTS `msg_pasta`;
CREATE TABLE `msg_pasta` (
  `COD_MSG_PASTA` int(10) NOT NULL AUTO_INCREMENT,
  `COD_MENSAGEM` int(10) DEFAULT NULL,
  `COD_USER` varchar(120) DEFAULT NULL,
  `PASTA` varchar(250) DEFAULT NULL,
  `LIDO` tinyint(1) NOT NULL DEFAULT '0',
  `DT_LIDO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_MSG_PASTA`),
  KEY `COD_USUARIO` (`COD_USER`),
  KEY `MSG_PASTACOD_MENSAGEM` (`COD_MENSAGEM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `msg_pasta`
--

/*!40000 ALTER TABLE `msg_pasta` DISABLE KEYS */;
/*!40000 ALTER TABLE `msg_pasta` ENABLE KEYS */;


--
-- Definition of table `msg_remetente`
--

DROP TABLE IF EXISTS `msg_remetente`;
CREATE TABLE `msg_remetente` (
  `COD_MSG_REMETENTE` int(10) NOT NULL AUTO_INCREMENT,
  `COD_MENSAGEM` int(10) DEFAULT NULL,
  `COD_USER_REMETENTE` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`COD_MSG_REMETENTE`),
  KEY `MSG_REMETENTECOD_MENSAGEM` (`COD_MENSAGEM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `msg_remetente`
--

/*!40000 ALTER TABLE `msg_remetente` DISABLE KEYS */;
/*!40000 ALTER TABLE `msg_remetente` ENABLE KEYS */;


--
-- Definition of table `msg_temp_anexo`
--

DROP TABLE IF EXISTS `msg_temp_anexo`;
CREATE TABLE `msg_temp_anexo` (
  `COD_MSG_TEMP_ANEXO` int(10) NOT NULL AUTO_INCREMENT,
  `SESSION` varchar(255) DEFAULT NULL,
  `ARQUIVO` varchar(255) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`COD_MSG_TEMP_ANEXO`),
  KEY `MSG_ANEXOCOD_MENSAGEM` (`SESSION`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `msg_temp_anexo`
--

/*!40000 ALTER TABLE `msg_temp_anexo` DISABLE KEYS */;
/*!40000 ALTER TABLE `msg_temp_anexo` ENABLE KEYS */;


--
-- Definition of table `nf_item`
--

DROP TABLE IF EXISTS `nf_item`;
CREATE TABLE `nf_item` (
  `COD_NF_ITEM` int(10) NOT NULL AUTO_INCREMENT,
  `COD_NF` int(10) DEFAULT NULL,
  `COD_SERVICO` int(10) DEFAULT NULL,
  `TIT_SERVICO` varchar(255) DEFAULT NULL,
  `DESC_SERVICO` varchar(255) DEFAULT NULL,
  `DESC_EXTRA` varchar(255) DEFAULT NULL,
  `OBS_SERVICO` longtext,
  `VALOR_ORIG` double(15,5) DEFAULT NULL,
  `VALOR` double(15,5) DEFAULT NULL,
  `PRC_COMISSAO` double(15,5) DEFAULT NULL,
  `VLR_COMISSAO` double(15,5) DEFAULT NULL,
  PRIMARY KEY (`COD_NF_ITEM`),
  KEY `COD_NF` (`COD_NF`),
  KEY `COD_SERVICO` (`COD_SERVICO`),
  KEY `NF_NOTANF_ITEM` (`COD_NF`),
  CONSTRAINT `nf_item_cod_nf_fkey` FOREIGN KEY (`COD_NF`) REFERENCES `nf_nota` (`COD_NF`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `nf_item`
--

/*!40000 ALTER TABLE `nf_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `nf_item` ENABLE KEYS */;


--
-- Definition of table `nf_nota`
--

DROP TABLE IF EXISTS `nf_nota`;
CREATE TABLE `nf_nota` (
  `COD_NF` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CFG_NF` int(10) DEFAULT NULL,
  `NUM_NF` varchar(20) DEFAULT NULL,
  `SERIE` varchar(10) DEFAULT NULL,
  `SITUACAO` varchar(20) DEFAULT NULL,
  `DT_EMISSAO` datetime DEFAULT NULL,
  `ARQUIVO` varchar(250) DEFAULT NULL,
  `COD_CLI` int(10) DEFAULT NULL,
  `TIPO` varchar(20) DEFAULT NULL,
  `CLI_NOME` varchar(255) DEFAULT NULL,
  `CLI_ENDER` varchar(255) DEFAULT NULL,
  `CLI_NUM_DOC` varchar(20) DEFAULT NULL,
  `CLI_INSC_ESTADUAL` varchar(20) DEFAULT NULL,
  `CLI_CEP` varchar(20) DEFAULT NULL,
  `CLI_BAIRRO` varchar(250) DEFAULT NULL,
  `CLI_CIDADE` varchar(250) DEFAULT NULL,
  `CLI_ESTADO` varchar(50) DEFAULT NULL,
  `CLI_FONE` varchar(25) DEFAULT NULL,
  `OBS_NF` longtext,
  `COD_CONTRATO` int(10) DEFAULT NULL,
  `NUM_CONTRATO` varchar(100) DEFAULT NULL,
  `OBS_CONTRATO` longtext,
  `TOT_SERVICO` double(15,5) DEFAULT NULL,
  `TOT_NF` double(15,5) DEFAULT NULL,
  `TOT_IMPOSTO` double(15,5) DEFAULT NULL,
  `TOT_IMPOSTO_CLI` double(15,5) DEFAULT NULL,
  `VLR_ISSQN` double(15,5) DEFAULT NULL,
  `VLR_IRPJ` double(15,5) DEFAULT NULL,
  `VLR_COFINS` double(15,5) DEFAULT NULL,
  `VLR_PIS` double(15,5) DEFAULT NULL,
  `VLR_CSOCIAL` double(15,5) DEFAULT NULL,
  `VLR_IRRF` double(15,5) DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_DTT_EMISSAO` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_EMISSAO` varchar(50) DEFAULT NULL,
  `SYS_DTT_CANCEL` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_CANCEL` varchar(50) DEFAULT NULL,
  `VLR_COMISSAO` double(15,5) DEFAULT NULL,
  `PRZ_VCTO` varchar(50) DEFAULT NULL,
  `COD_NF_IRRF` int(10) DEFAULT NULL,
  `COD_NF_REDUCAO` int(10) DEFAULT NULL,
  `VLR_IRRF_ACUM` double(15,5) DEFAULT NULL,
  `VLR_REDUCAO_ACUM` double(15,5) DEFAULT NULL,
  `SYS_DTT_UPD` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_UPD` varchar(50) DEFAULT NULL,
  `COD_CONTA_PAGAR_RECEBER` int(11) DEFAULT NULL,
  `SYS_DTT_INATIVO` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INATIVO` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_NF`),
  KEY `ALIQ_ISSQN` (`VLR_ISSQN`),
  KEY `CFG_NFNF_NOTA` (`COD_CFG_NF`),
  KEY `NUM_DOC` (`CLI_NUM_DOC`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `nf_nota`
--

/*!40000 ALTER TABLE `nf_nota` DISABLE KEYS */;
/*!40000 ALTER TABLE `nf_nota` ENABLE KEYS */;


--
-- Definition of table `nf_nota_form`
--

DROP TABLE IF EXISTS `nf_nota_form`;
CREATE TABLE `nf_nota_form` (
  `COD_NOTA_FORM` int(10) NOT NULL AUTO_INCREMENT,
  `NUM_NF` varchar(50) DEFAULT NULL,
  `NUM_FORM` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_NOTA_FORM`),
  KEY `NUM_FORM` (`NUM_FORM`),
  KEY `NUM_NF` (`NUM_NF`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `nf_nota_form`
--

/*!40000 ALTER TABLE `nf_nota_form` DISABLE KEYS */;
/*!40000 ALTER TABLE `nf_nota_form` ENABLE KEYS */;


--
-- Definition of table `notepad`
--

DROP TABLE IF EXISTS `notepad`;
CREATE TABLE `notepad` (
  `COD_NOTEPAD` int(10) NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` varchar(50) DEFAULT NULL,
  `TEXTO` longtext,
  `TITULO` varchar(250) DEFAULT NULL,
  `SYS_DTT_INS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `SYS_DTT_UPD` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `TIPO` varchar(50) DEFAULT NULL,
  `USUARIOS` longtext,
  PRIMARY KEY (`COD_NOTEPAD`),
  KEY `ID_USUARIO` (`ID_USUARIO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `notepad`
--

/*!40000 ALTER TABLE `notepad` DISABLE KEYS */;
/*!40000 ALTER TABLE `notepad` ENABLE KEYS */;


--
-- Definition of table `prj_backlog`
--

DROP TABLE IF EXISTS `prj_backlog`;
CREATE TABLE `prj_backlog` (
  `COD_PRJ_BACKLOG` int(10) NOT NULL AUTO_INCREMENT,
  `COD_PROJETO` int(10) NOT NULL,
  `TITULO` varchar(255) DEFAULT NULL,
  `DESCRICAO` longtext,
  `TAMANHO` double(15,5) DEFAULT NULL,
  `ROI` double(15,5) DEFAULT NULL,
  `STATUS` varchar(20) DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_ID_USUARIO_ALT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_PRJ_BACKLOG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `prj_backlog`
--

/*!40000 ALTER TABLE `prj_backlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `prj_backlog` ENABLE KEYS */;


--
-- Definition of table `prj_categoria`
--

DROP TABLE IF EXISTS `prj_categoria`;
CREATE TABLE `prj_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  UNIQUE KEY `Index_5617C1BE_0CC5_4982` (`COD_CATEGORIA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `prj_categoria`
--

/*!40000 ALTER TABLE `prj_categoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `prj_categoria` ENABLE KEYS */;


--
-- Definition of table `prj_projeto`
--

DROP TABLE IF EXISTS `prj_projeto`;
CREATE TABLE `prj_projeto` (
  `COD_PROJETO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CONTRATO` int(10) DEFAULT NULL,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `ID_RESPONSAVEL` varchar(50) DEFAULT NULL,
  `TITULO` varchar(255) DEFAULT NULL,
  `DESCRICAO` longtext,
  `FASE_ATUAL` varchar(30) DEFAULT NULL,
  `PREV_TOT_HORAS` int(10) DEFAULT NULL,
  `VLR_CONTRATO_TOTAL` double(15,5) DEFAULT NULL,
  `VLR_CONTRATO_HORA` double(15,5) DEFAULT NULL,
  `DT_INICIO` datetime DEFAULT NULL,
  `DT_DEADLINE` datetime DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_ID_USUARIO_ALT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_PROJETO`),
  UNIQUE KEY `Index_1DB61564_901E_495F` (`COD_PROJETO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `prj_projeto`
--

/*!40000 ALTER TABLE `prj_projeto` DISABLE KEYS */;
/*!40000 ALTER TABLE `prj_projeto` ENABLE KEYS */;


--
-- Definition of table `prj_projeto_fase`
--

DROP TABLE IF EXISTS `prj_projeto_fase`;
CREATE TABLE `prj_projeto_fase` (
  `COD_PROJETO_FASE` int(10) NOT NULL AUTO_INCREMENT,
  `COD_PROJETO` int(10) DEFAULT NULL,
  `FASE` varchar(30) DEFAULT NULL,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_PROJETO_FASE`),
  UNIQUE KEY `Index_E72E9FFA_8CF7_47E2` (`COD_PROJETO_FASE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `prj_projeto_fase`
--

/*!40000 ALTER TABLE `prj_projeto_fase` DISABLE KEYS */;
/*!40000 ALTER TABLE `prj_projeto_fase` ENABLE KEYS */;


--
-- Definition of table `processo`
--

DROP TABLE IF EXISTS `processo`;
CREATE TABLE `processo` (
  `COD_PROCESSO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `ID_PROCESSO` varchar(20) DEFAULT NULL,
  `NOME` varchar(250) DEFAULT NULL,
  `DESCRICAO` longtext,
  `AUTORES` longtext,
  `DATA` datetime DEFAULT NULL,
  `SYS_DT_CRIACAO` datetime DEFAULT NULL,
  `SYS_INS_ID_USUARIO` varchar(120) DEFAULT NULL,
  `SYS_DT_ALTERACAO` varchar(120) DEFAULT NULL,
  `SYS_ALT_ID_USUARIO` varchar(120) DEFAULT NULL,
  `DT_HOMOLOGACAO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_PROCESSO`),
  KEY `ID` (`ID_PROCESSO`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `processo`
--

/*!40000 ALTER TABLE `processo` DISABLE KEYS */;
INSERT INTO `processo` (`COD_PROCESSO`,`COD_CATEGORIA`,`ID_PROCESSO`,`NOME`,`DESCRICAO`,`AUTORES`,`DATA`,`SYS_DT_CRIACAO`,`SYS_INS_ID_USUARIO`,`SYS_DT_ALTERACAO`,`SYS_ALT_ID_USUARIO`,`DT_HOMOLOGACAO`) VALUES 
 (5,1,'01 ACCS','AVISO DE COBRANÇA de CONTRATOS e SERVIÇOS','Processo de registro de \"avisos de cobrança\" no sistema VBoss para emissão das notas fiscais e registros das previsão nos sistema financeiro.','Aless, Luis Felipe e Mauro','2006-10-18 00:00:00','2006-11-08 12:50:22','clvsutil','21/07/2009 13:56:20','aless','2006-11-08 12:54:45'),
 (6,1,'02 ER','EMISSÃO DE RECIBO','Emissão de recido, arquivamento  e aviso ao cliente','Aless, Luis Felipe e Mauro','2006-10-25 00:00:00','2006-11-08 12:50:22','clvsutil','23/11/2006 10:18:01','alan','2006-11-08 12:54:45'),
 (7,1,'03 ENF','EMISSÃO DE NOTA FISCAL','Emissão de nota fiscal, arquivamento e aviso ao cliente','Aless, Luis Felipe e Mauro','2006-10-25 00:00:00','2006-11-08 12:50:22','clvsutil',NULL,NULL,'2006-11-08 12:54:45'),
 (8,1,'04 EB','EMISSÃO DE BOLETO',NULL,'Aless, Luis Felipe e Mauro','2006-10-25 00:00:00','2006-11-08 12:50:22','aless',NULL,NULL,'2006-11-08 12:54:45'),
 (9,1,'05 CP - A','COBRANÇA DE CLIENTES','Processo para controle de cobrança, lançamentos dos pagamentos dos clientes e avisos de cobranças em atrasos.','Aless, Luis Felipe e Mauro','2006-11-22 00:00:00','2006-11-27 09:50:00','aless',NULL,NULL,NULL),
 (11,1,'05 CP - B','COBRANÇA DE CLIENTES','Processo para controle de cobrança, lançamentos dos pagamentos dos clientes e avisos de cobranças em atrasos.','Aless, Cleverson','2006-11-22 00:00:00','2006-11-27 09:50:00','aless',NULL,NULL,NULL);
/*!40000 ALTER TABLE `processo` ENABLE KEYS */;


--
-- Definition of table `processo_categoria`
--

DROP TABLE IF EXISTS `processo_categoria`;
CREATE TABLE `processo_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  KEY `DT_INATIVO` (`DT_INATIVO`),
  KEY `NOME` (`NOME`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `processo_categoria`
--

/*!40000 ALTER TABLE `processo_categoria` DISABLE KEYS */;
INSERT INTO `processo_categoria` (`COD_CATEGORIA`,`NOME`,`DESCRICAO`,`DT_INATIVO`) VALUES 
 (1,'Administrativo',NULL,NULL),
 (2,'Financeiro',NULL,NULL),
 (3,'Produção',NULL,NULL),
 (4,'Chamado',NULL,NULL),
 (5,'Marketing',NULL,NULL),
 (6,'Sistema',NULL,NULL),
 (7,'Qualidade',NULL,NULL);
/*!40000 ALTER TABLE `processo_categoria` ENABLE KEYS */;


--
-- Definition of table `processo_tarefa`
--

DROP TABLE IF EXISTS `processo_tarefa`;
CREATE TABLE `processo_tarefa` (
  `COD_TAREFA` int(10) NOT NULL AUTO_INCREMENT,
  `COD_PROCESSO` int(10) DEFAULT NULL,
  `NUMERO` int(10) DEFAULT NULL,
  `DESC_OQUE` longtext,
  `DESC_QUEM` longtext,
  `DESC_QUANDO` longtext,
  `COMPLEMENTAR` longtext,
  `ARQ_ANEXO` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`COD_TAREFA`),
  KEY `PROCESSOPROCESSO_TAREFA` (`COD_PROCESSO`),
  CONSTRAINT `processo_tarefa_cod_processo_fkey` FOREIGN KEY (`COD_PROCESSO`) REFERENCES `processo` (`COD_PROCESSO`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `processo_tarefa`
--

/*!40000 ALTER TABLE `processo_tarefa` DISABLE KEYS */;
INSERT INTO `processo_tarefa` (`COD_TAREFA`,`COD_PROCESSO`,`NUMERO`,`DESC_OQUE`,`DESC_QUEM`,`DESC_QUANDO`,`COMPLEMENTAR`,`ARQ_ANEXO`) VALUES 
 (4,5,1,'Criar \"ToDo\" para Dir. Financeiro - Título: \" FECHAMENTO de CONTRATO - [nome do cliente]\" (categoria contrato)','Responsável pelo contrato (quem assina)','Novo contrato assinado',NULL,NULL),
 (5,5,2,'Deixar as vias do contrato no escaninho de \"ENTRADA\" na mesa do Dir. Financeiro','Responsável pelo contrato (quem assina)','Depois de 1',NULL,NULL),
 (6,5,3,'No caso de novos clientes, cadastrá-los no \"Laçador\" (Z:/) (ManClientes.exe)','Secretária',NULL,NULL,NULL),
 (7,5,4,'Nos casos de cobranças de horas (já incluídas em contrato), enviar email para secretária','Responsável pelo contrato (quem assina)','Depois de 1',NULL,NULL),
 (8,5,5,'Imprimir email e deixar \"ENTRADA\" na mesa do Dir. Financeiro','Secretária','Depois de 4',NULL,NULL),
 (9,5,6,'Revisão do contrato (datas, valores, assinaturas, etc)','Dir. Financeiro','Depois de 2',NULL,NULL),
 (10,5,7,'Lançamento no sistema financeiro das previsões de recebimento','Dir. Financeiro','Depois de 4',NULL,NULL),
 (11,5,8,'Arquivamento do contrato na pasta de contratos do clientes','Dir. Financeiro','Depois de 5',NULL,NULL),
 (12,5,9,'Criar \"ToDos\" para todos os recebimentos previstos pelo(s) contrato(s), como lembrete de emissão de cobrança (contratos mensais + valores sem contrato). Título: \"EMITIR NF -[cliente]\" ou \"EMITIR RECIBO - [cliente]','Dir. Financeiro','Depois de 6','ER, ENF',NULL),
 (13,6,1,'Verificar no ToDo os processos titulados: \"EMITIR RECIBO - [cliente]','Secretária','diariamente (manhã)',NULL,NULL),
 (14,6,2,'Acessar o documento modelo (zeus/administrativo/...), preencher os dados conforme observações do ToDo e cadastro do cliente.','Secretária','Depois de 1',NULL,NULL),
 (15,6,3,'Emitir Recibo em 2 vias.','Secretária','Depois de 2',NULL,NULL),
 (16,6,4,'Revisar/Corrigir e encaminhar para Dir Financeiro auditar','Secretária','Depois de 3',NULL,NULL),
 (17,6,5,'Auditar (ERRO ou OK)','Dir. Financeiro','Depois de 4',NULL,NULL),
 (18,6,6,'ERRO: anular recibo, e voltar ao passo 2 corrigindo os erros apontados','Secretária','Depois de 5',NULL,NULL),
 (19,6,7,'OK: Enviar e-mail de aviso e/ou mandar pelo correio. Observar no próprio ToDo casos de NÃO ENVIO','Secretária','Depois de 5',NULL,NULL),
 (20,6,8,'Gerar ToDo (Resp. Dir Financeiro, Executor: Secretária ). Título \"CONF. PGTO - NF\"','Secretária','Depois de 7',NULL,NULL),
 (21,6,9,'Se o recibo foi emitido, pode fechar a tarefa que a gerou \"EMITIR RECIBO - [cliente]. Na resposta colocar o número da nota emitida','Secretária','Depois de 7',NULL,NULL),
 (22,6,10,'Arquivar documentos na movimentação do mês referente (pela data de cobrança)','Secretária','Depois de 9',NULL,NULL),
 (23,7,1,'Verificar no ToDo os processos titulados: \"EMITIR NF - [cliente]','Secretária','diariamente (manhã)',NULL,NULL),
 (24,7,2,'Acessar o módulo de Emissão de Notas (NotaServico.exe) do \"Laçador\"  (Z:\\) - Inserir nota','Secretária','Depois de 1',NULL,NULL),
 (25,7,3,'Conferir com próximo número de nota a ser gerado (com o formulário)','Secretária','Depois de 2',NULL,NULL),
 (26,7,4,'Preencher os dados conforme observações do ToDo (itens da NF descritos nele). Não alterar campos que não estejam especificados nas instruções do ToDo','Secretária','Depois de 3',NULL,NULL),
 (27,7,5,'Emitir Nota Fiscal','Secretária','Depois de 4',NULL,NULL),
 (28,7,6,'Revisar/Corrigir e encaminhar para Dir Financeiro auditar (caso este não esteja disponível encaminhar para outro diretor e/ou gerente de conta - NÃO TRANCAR PROCESSO )','Secretária','Depois de 5',NULL,NULL),
 (29,7,7,'Auditar (ERRO ou OK)','Dir. Financeiro','Depois de 6',NULL,NULL),
 (30,7,8,'ERRO: cancelar nota no sistema (e seu respectivo título) e fisicamente juntar as vias, marcá-las como CANCELADO - pode colocar o motivo junto e por fim voltar ao passo 2 corrigindo os erros apontados','Secretária','Depois de 7',NULL,NULL),
 (31,7,9,'OK: Emitir Boleto','Secretária','Depois de 7','EB',NULL),
 (32,7,10,'Juntar a Nota (via do Cliente) com o Boleto emitido e enviar para o cliente - pelo correio. Observar no próprio ToDo casos de NÃO ENVIO','Secretária','Depois de 9',NULL,NULL),
 (33,7,11,'Se a nota foi emitida, pode fechar a tarefa que a gerou \"EMITIR NF - [cliente]. Na resposta colocar o número da nota emitida','Secretária','Depois de 10',NULL,NULL),
 (34,7,12,'Gerar ToDo (Resp. Dir Financeiro, Executor: Secretária ). Título \"CONF. PGTO - [cliente] (nf)\".','Secretária','Depois de 10',NULL,NULL),
 (35,7,13,'Arquivar documentos na movimentação do mês referente (pela data de cobrança). Separar as vias das notas para o contator','Secretária','Depois de 12',NULL,NULL),
 (36,8,1,'Acessar o módulo de Emissão de Boletos (Titulo.exe) do \"Laçador\"  (Z:\\) - Imprimir Duplicatas','Secretária','F003/06',NULL,NULL),
 (37,8,2,'Emitir todas as duplicatas não impressas','Secretária','Depois de 1',NULL,NULL),
 (38,8,3,'Capturar a tela do Boleto','Secretária','Depois de 2',NULL,NULL),
 (39,8,4,'Mandar e-mail de aviso de cobrança também com o boleto em anexo - imagem capturada no processo EB. Observar no próprio ToDo casos de NÃO ENVIO','Secretária','Depois de 3',NULL,NULL),
 (40,9,1,'Tirar diariamente extrato bancário e movimentação de títulos e enviar por e-mail para secretária','Dir. Financeiro','diário',NULL,NULL),
 (41,9,2,'Conferência dos títulos e depósitos recebidos','Secretária','Depois de 1',NULL,NULL),
 (42,9,3,'Baixa dos títulos no sistema laçador','Secretária','Depois de 2',NULL,NULL),
 (43,9,4,'Fechar o ToDo relativo aos recebimentos efetuados (tarefa correspondente)','Secretária','Depois de 3',NULL,NULL),
 (44,9,5,'Cruzamento dos ToDo(s) em aberto com os Títulos em aberto no laçador','Secretária','Depois de 4',NULL,NULL),
 (45,9,6,'Emitir relatório no sistema Laçador dos Títulos vencidos e não pagos a mais de <b>5 dias</b>','Secretária','Depois de 5',NULL,NULL),
 (46,9,7,'Enviar por e-mail para Dir. Financeiro (cópia para os demais diretores) os clietnes inadimplentes','Secretária','Depois de 6',NULL,NULL),
 (47,9,8,'Caso não haja restrição do Dir. Financeiro em até 24h, enviar o <b>Primeiro</b> aviso de cobrança para o cliente, com cópia para financeiro@athenas.com.br. Ver modelo anexo.','Secretária','Depois de 7',NULL,NULL),
 (48,9,9,'Criar uma resposta no ToDo com a mensagem: PRIMEIRO AVISO DE COBRANÇA ENVIADO e solicitar ao responsável do ToDo re-agendamento para 15 dias dessa data.','Secretária','Depois de 8',NULL,NULL),
 (49,9,10,'Em caso de negociação com o cliente, solicitar autorizaçào ao Dir. Financeiro e informar no ToDo as instruções','Secretária','Depois de 9',NULL,NULL),
 (50,9,11,'Enviar por e-mail para Dir. Financeiro (com cópia para os demais diretores) os clientes inadimplentes a mais de <b>15 dias</b>','Secretária','Depois de 10',NULL,NULL),
 (51,9,12,'Entrar em contato por telefone e enviar por e-mail o segundo aviso de cobrança com cópia para financeiro@athenas.com.br. Ver modelo anexo.','Secretária','Depois de 11',NULL,NULL),
 (52,9,13,'Criar uma resposta no ToDo com a mensagem: SEGUNDO AVISO DE COBRANÇA ENVIADO e solicitar ao responsável do ToDo re-agendamento para <b>15 dias</b> dessa data.','Secretária','Depois de 12',NULL,NULL),
 (53,9,14,'Enviar por e-mail para Dir. Financeiro (com cópia para os demais diretores) os clientes inadimplentes a mais de <b>25 dias</b>','Secretária','Depois de 13',NULL,NULL),
 (54,9,15,'Clientes que já tiverem recebido o segundo aviso, o Dir. Financeiro sinalizará exceções, caso contrário segue re-agendamento de 15 em 15 dias com limite de 90. Criando semrpe as respostas com TERCEIRO, QUARTO, QUINTO e SEXTO AVISO DE COBRANÇA ENVIADO, relacionando todos os valores em aberto. Enviar e-mail para o cliente. Ver modelo anexo.','Secretária','Depois de 14',NULL,NULL),
 (55,9,16,'O Todo Correspondente deve ser repassado ao Dir. Financeiro quando houver mais de <b>06 avisos</b> de cobrança','Secretária','Depois de 15',NULL,NULL),
 (57,11,1,'Tirar diariamente extrato bancário e movimentação de títulos e enviar por e-mail para secretária','Diário','Diário',NULL,NULL),
 (58,11,2,'Conferência dos títulos e depósitos recebidos','Dir. Financeiro','Depois de 1',NULL,NULL),
 (59,11,3,'Baixa dos títulos no sistema laçador','Secretária','Depois de 2',NULL,NULL),
 (60,11,4,'Fechar o ToDo relativo aos recebimentos efetuados (tarefa correspondente)','Secretária','Depois de 3',NULL,NULL),
 (61,11,5,'Cruzamento dos ToDo(s) em aberto com os Títulos em aberto no laçador','Secretária','Depois de 4',NULL,NULL),
 (62,11,6,'Emitir relatório no sistema Laçador dos Títulos vencidos e não pagos a mais de <b>5 dias</b>','Secretária','Depois de 5',NULL,NULL),
 (63,11,7,'Enviar por e-mail para Dir. Financeiro (cópia para os demais diretores) os clientes inadimplentes','Secretária','Depois de 6',NULL,NULL),
 (64,11,8,'Caso não haja restrição do Dir. Financeiro em até 24h, enviar o <b>Primeiro</b> aviso de cobrança para o cliente, com cópia para financeiro@athenas.com.br. Ver modelo anexo.\r\n<br><br>\r\nColocar no ToDo correspondente uma resposta com o texto: <b>PRIMEIRO AVISO DE COBRANÇA ENVIADO</b>. Solicitar ao responsável pelo ToDo o seu re-agendamenteo imediato para <b>15 dias</b> após a data deste aviso de cobrança','Secretária','Depois de 7',NULL,NULL),
 (65,11,9,'Para os não pagos (em aberto atrasados), que já tiverem recebido o primeiro aviso de cobrança, significa então que estarão inadimplentes a ~20 dias. Deve ser enviado por e-mail o segundo aviso de cobranca (ver modelo anexo) e efetuado contato <b>telefônico</b> com o cliente (passar para os sócios via e-mail as informações pertinentes deste contato)\r\n<br><br>\r\nColocar no ToDo correspondente uma resposta com o texto: <b>SEGUNDO AVISO DE COBRANÇA ENVIADO</b>. Solicitar ao responsável pelo ToDo o seu re-agendamenteo imediato para <b>15 dias</b> após a data deste aviso de cobrança.','Secretária','Diário',NULL,NULL),
 (66,11,10,'Clientes que já receberam avisos posteriores ao segundo, ou seja, <b>terceiro, quarto, quinto ou sexto avisos </b>. \r\nSolicitar ao responsável pelo ToDo o seu re-agendamenteo imediato para <b>15 dias</b> após a data deste aviso de cobrança - <u>O Dir Financeiro sinalizará exceções</u>, caso contrário segue o re-agendamento de 15 em 15 dias com limite de 90 dias e/ou seis avisos no total','Secretária','Diário',NULL,NULL),
 (67,11,11,'O ToDo deve ser repassado ao Dir. Financeiro quando já houver mais de 6 avisos de cobrança.','Secretária','Depois de 10',NULL,NULL);
/*!40000 ALTER TABLE `processo_tarefa` ENABLE KEYS */;


--
-- Definition of table `pt_desconto`
--

DROP TABLE IF EXISTS `pt_desconto`;
CREATE TABLE `pt_desconto` (
  `COD_DESCONTO` int(10) NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` varchar(10) DEFAULT NULL,
  `MES` int(10) DEFAULT NULL,
  `ANO` int(10) DEFAULT NULL,
  `TOTAL_HR` int(10) DEFAULT NULL,
  `TOTAL_MIN` int(10) DEFAULT NULL,
  `OBS` longtext,
  PRIMARY KEY (`COD_DESCONTO`),
  UNIQUE KEY `Index_F22C6095_EDA4_4854` (`COD_DESCONTO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pt_desconto`
--

/*!40000 ALTER TABLE `pt_desconto` DISABLE KEYS */;
/*!40000 ALTER TABLE `pt_desconto` ENABLE KEYS */;


--
-- Definition of table `pt_feriado`
--

DROP TABLE IF EXISTS `pt_feriado`;
CREATE TABLE `pt_feriado` (
  `COD_FERIADO` int(10) NOT NULL AUTO_INCREMENT,
  `DATA_DIA` int(10) DEFAULT NULL,
  `DATA_MES` int(10) DEFAULT NULL,
  `DESCRICAO` varchar(250) DEFAULT NULL,
  `DATA_ANO` int(10) DEFAULT NULL,
  `UF` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`COD_FERIADO`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=431;

--
-- Dumping data for table `pt_feriado`
--

/*!40000 ALTER TABLE `pt_feriado` DISABLE KEYS */;
INSERT INTO `pt_feriado` (`COD_FERIADO`,`DATA_DIA`,`DATA_MES`,`DESCRICAO`,`DATA_ANO`,`UF`) VALUES 
 (1,1,1,'NACIONAL - Confraternização Universal',0,NULL),
 (2,2,2,'MUNICIPAL - Poa - Nossa Senhora dos Navegantes',2008,NULL),
 (6,21,4,'NACIONAL - Tiradentes',0,NULL),
 (7,1,5,'NACIONAL - Dia do Trabalho',0,NULL),
 (8,22,5,'NACIONAL - Corpus Christi',2008,NULL),
 (9,7,9,'NACIONAL - Independência do Brasil',0,NULL),
 (10,20,9,'ESTADUAL RS - Revolução Farroupilha',2008,NULL),
 (11,12,10,'NACIONAL - Nossa Sr.a Aparecida - Padroeira do Brasil',0,NULL),
 (12,2,11,'NACIONAL - Finados',0,NULL),
 (13,15,11,'NACIONAL - Proclamação da República',0,NULL),
 (14,25,12,'NACIONAL - Natal',0,NULL),
 (15,4,2,'ATHENAS',2008,NULL),
 (16,5,2,'Carnaval',2008,NULL),
 (17,4,2,'Carnaval',2008,NULL),
 (18,21,3,'Páscoa',2008,NULL),
 (19,23,2,'Carnaval',2009,NULL),
 (20,24,2,'Carnaval',2009,NULL),
 (21,10,4,'Paixão de Cristo',2009,NULL),
 (22,11,6,'Corpus Christ',2009,NULL),
 (23,15,2,'Carnaval',2010,NULL),
 (24,16,2,'Carnaval',2010,NULL),
 (25,2,4,'Paixão de Cristo',2010,NULL),
 (26,3,6,'Corpus Christi',2010,NULL),
 (37,9,7,'MUNICIPAL SP - Revolução constitucionalíssima.',2010,NULL),
 (38,8,3,'NACIONAL - Carnaval',2011,NULL),
 (39,22,4,'NACIONAL - Paixão de Cristo',2011,NULL),
 (40,25,1,'MUNICIPAL - SP - Aniversário da cidade',2011,NULL),
 (41,24,12,'Para não considerar horas previstas',2010,NULL),
 (42,31,12,'Para não considerar horas previstas',2010,NULL),
 (43,23,6,'CORPUS CHRISTI',2011,NULL),
 (44,25,1,'MUNICIPAL - SP - Aniversário da cidade',2012,'SP'),
 (45,21,2,'NACIONAL - Carnaval',2012,NULL),
 (46,20,2,'FOLGA cedida pela empresa - CARNAVAL',2012,NULL),
 (47,2,2,'MUNICIPAL - Poa - Nossa Senhora dos Navegantes',NULL,'RS'),
 (48,6,4,'NACIONAL - Paixão de Cristo',2012,NULL),
 (49,7,6,'NACIONAL - CORPUS CHRISTI',2012,NULL),
 (50,9,7,'MUNICIPAL SP - Revolução constitucionalíssima.',2012,'SP'),
 (51,20,9,'ESTADUAL - RS - Rev. Farropilha',2012,'RS');
/*!40000 ALTER TABLE `pt_feriado` ENABLE KEYS */;


--
-- Definition of table `pt_folga`
--

DROP TABLE IF EXISTS `pt_folga`;
CREATE TABLE `pt_folga` (
  `COD_FOLGA` int(10) NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` varchar(50) DEFAULT NULL,
  `DT_INI` datetime DEFAULT NULL,
  `DT_FIM` datetime DEFAULT NULL,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `OBS` longtext,
  PRIMARY KEY (`COD_FOLGA`),
  KEY `DT_FIM` (`DT_FIM`),
  KEY `DT_INI` (`DT_INI`),
  KEY `ID_USUARIO` (`ID_USUARIO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pt_folga`
--

/*!40000 ALTER TABLE `pt_folga` DISABLE KEYS */;
/*!40000 ALTER TABLE `pt_folga` ENABLE KEYS */;


--
-- Definition of table `pt_folga_categoria`
--

DROP TABLE IF EXISTS `pt_folga_categoria`;
CREATE TABLE `pt_folga_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  KEY `DT_INATIVO` (`DT_INATIVO`),
  KEY `NOME` (`NOME`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pt_folga_categoria`
--

/*!40000 ALTER TABLE `pt_folga_categoria` DISABLE KEYS */;
INSERT INTO `pt_folga_categoria` (`COD_CATEGORIA`,`NOME`,`DESCRICAO`,`DT_INATIVO`) VALUES 
 (1,'LICENÇA - FÉRIAS',NULL,NULL),
 (2,'LICENÇA - MATERINIDADE',NULL,NULL),
 (3,'LICENÇA - PATERNIDADE',NULL,NULL),
 (4,'LICENÇA - MÉDICA',NULL,NULL),
 (5,'ATESTADO',NULL,NULL),
 (15,'FALTA JUSTIFICADA',NULL,NULL);
/*!40000 ALTER TABLE `pt_folga_categoria` ENABLE KEYS */;


--
-- Definition of table `pt_ponto`
--

DROP TABLE IF EXISTS `pt_ponto`;
CREATE TABLE `pt_ponto` (
  `COD_PONTO` int(10) NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` varchar(10) DEFAULT NULL,
  `COD_EMPRESA` varchar(50) DEFAULT NULL,
  `DATA_DIA` int(10) DEFAULT NULL,
  `DATA_MES` int(10) DEFAULT NULL,
  `DATA_ANO` int(10) DEFAULT NULL,
  `HORA_IN` varchar(50) DEFAULT NULL,
  `HORA_OUT` varchar(50) DEFAULT NULL,
  `STATUS` varchar(10) DEFAULT NULL,
  `OBS` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`COD_PONTO`),
  KEY `ID_USUARIO` (`ID_USUARIO`),
  KEY `STATUS` (`STATUS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pt_ponto`
--

/*!40000 ALTER TABLE `pt_ponto` DISABLE KEYS */;
/*!40000 ALTER TABLE `pt_ponto` ENABLE KEYS */;


--
-- Definition of table `pt_total_dia`
--

DROP TABLE IF EXISTS `pt_total_dia`;
CREATE TABLE `pt_total_dia` (
  `COD_TOTAL_DIA` int(10) NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` varchar(10) DEFAULT NULL,
  `DATA_DIA` int(10) DEFAULT NULL,
  `DATA_MES` int(10) DEFAULT NULL,
  `DATA_ANO` int(10) DEFAULT NULL,
  `TOTAL` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_TOTAL_DIA`),
  KEY `DATA_ANO` (`DATA_ANO`),
  KEY `DATA_DIA` (`DATA_DIA`),
  KEY `DATA_MES` (`DATA_MES`),
  KEY `ID_USUARIO` (`ID_USUARIO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pt_total_dia`
--

/*!40000 ALTER TABLE `pt_total_dia` DISABLE KEYS */;
/*!40000 ALTER TABLE `pt_total_dia` ENABLE KEYS */;


--
-- Definition of table `pt_total_dia_empresa`
--

DROP TABLE IF EXISTS `pt_total_dia_empresa`;
CREATE TABLE `pt_total_dia_empresa` (
  `COD_TOTAL_DIA_EMPRESA` int(10) NOT NULL AUTO_INCREMENT,
  `COD_EMPRESA` varchar(50) DEFAULT NULL,
  `ID_USUARIO` varchar(10) DEFAULT NULL,
  `DATA_DIA` int(10) DEFAULT NULL,
  `DATA_MES` int(10) DEFAULT NULL,
  `DATA_ANO` int(10) DEFAULT NULL,
  `TOTAL` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_TOTAL_DIA_EMPRESA`),
  KEY `DATA_ANO` (`DATA_ANO`),
  KEY `DATA_DIA` (`DATA_DIA`),
  KEY `DATA_MES` (`DATA_MES`),
  KEY `ID_USUARIO` (`ID_USUARIO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pt_total_dia_empresa`
--

/*!40000 ALTER TABLE `pt_total_dia_empresa` DISABLE KEYS */;
/*!40000 ALTER TABLE `pt_total_dia_empresa` ENABLE KEYS */;


--
-- Definition of table `recado`
--

DROP TABLE IF EXISTS `recado`;
CREATE TABLE `recado` (
  `COD_RECADO` int(10) NOT NULL AUTO_INCREMENT,
  `ID_USUARIO_TO` varchar(50) DEFAULT NULL,
  `TEXTO` longtext,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_DTT_VIEW` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_RECADO`),
  KEY `ID_USUARIO` (`ID_USUARIO_TO`),
  KEY `SYS_ID_USUARIO_INS` (`SYS_ID_USUARIO_INS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `recado`
--

/*!40000 ALTER TABLE `recado` DISABLE KEYS */;
/*!40000 ALTER TABLE `recado` ENABLE KEYS */;


--
-- Definition of table `sv_categoria`
--

DROP TABLE IF EXISTS `sv_categoria`;
CREATE TABLE `sv_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  KEY `DT_INATIVO` (`DT_INATIVO`),
  KEY `NOME` (`NOME`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sv_categoria`
--

/*!40000 ALTER TABLE `sv_categoria` DISABLE KEYS */;
INSERT INTO `sv_categoria` (`COD_CATEGORIA`,`NOME`,`DESCRICAO`,`DT_INATIVO`) VALUES 
 (3,'Produtos',NULL,NULL),
 (5,'Sistemas Desktop',NULL,NULL),
 (8,'Específicos',NULL,NULL),
 (9,'Web Systems',NULL,NULL),
 (10,'Outros',NULL,NULL),
 (13,'Desenvolvimento',NULL,NULL),
 (14,'Web',NULL,NULL);
/*!40000 ALTER TABLE `sv_categoria` ENABLE KEYS */;


--
-- Definition of table `sv_servico`
--

DROP TABLE IF EXISTS `sv_servico`;
CREATE TABLE `sv_servico` (
  `COD_SERVICO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `TITULO` varchar(255) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `OBS` longtext,
  `VALOR` double(15,5) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `ALIQ_ISSQN` double(15,3) DEFAULT NULL,
  PRIMARY KEY (`COD_SERVICO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sv_servico`
--

/*!40000 ALTER TABLE `sv_servico` DISABLE KEYS */;
/*!40000 ALTER TABLE `sv_servico` ENABLE KEYS */;


--
-- Definition of table `sys_app_direito`
--

DROP TABLE IF EXISTS `sys_app_direito`;
CREATE TABLE `sys_app_direito` (
  `COD_APP_DIREITO` int(10) NOT NULL AUTO_INCREMENT,
  `ID_APP` varchar(250) DEFAULT NULL,
  `ID_DIREITO` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_APP_DIREITO`),
  KEY `DIREITO_ID` (`ID_DIREITO`),
  KEY `ID_MODULO` (`ID_APP`),
  KEY `SYS_DIREITOSYS_APP_DIREITO` (`ID_DIREITO`)
) ENGINE=InnoDB AUTO_INCREMENT=265 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sys_app_direito`
--

/*!40000 ALTER TABLE `sys_app_direito` DISABLE KEYS */;
INSERT INTO `sys_app_direito` (`COD_APP_DIREITO`,`ID_APP`,`ID_DIREITO`) VALUES 
 (2,'modulo_USUARIO','INS'),
 (3,'modulo_USUARIO','UPD'),
 (4,'modulo_USUARIO','DEL'),
 (5,'modulo_USUARIO','VIEW'),
 (6,'modulo_TODOLIST','INS'),
 (7,'modulo_TODOLIST','UPD'),
 (8,'modulo_TODOLIST','DEL'),
 (9,'modulo_TODOLIST','VIEW'),
 (10,'modulo_PROCESSO','INS'),
 (11,'modulo_PROCESSO','UPD'),
 (12,'modulo_PROCESSO','DEL'),
 (13,'modulo_PROCESSO','VIEW'),
 (14,'modulo_PONTO','INS'),
 (15,'modulo_PONTO','UPD'),
 (16,'modulo_PONTO','DEL'),
 (17,'modulo_PONTO','VIEW'),
 (18,'modulo_MSG','INS'),
 (19,'modulo_MSG','UPD'),
 (20,'modulo_MSG','DEL'),
 (21,'modulo_MSG','VIEW'),
 (22,'modulo_ICONPAINEL','INS'),
 (23,'modulo_ICONPAINEL','UPD'),
 (24,'modulo_ICONPAINEL','DEL'),
 (25,'modulo_ICONPAINEL','VIEW'),
 (26,'modulo_COLABORADOR','INS'),
 (27,'modulo_COLABORADOR','UPD'),
 (28,'modulo_COLABORADOR','DEL'),
 (29,'modulo_COLABORADOR','VIEW'),
 (30,'modulo_CLIENTE','INS'),
 (31,'modulo_CLIENTE','UPD'),
 (32,'modulo_CLIENTE','DEL'),
 (33,'modulo_CLIENTE','VIEW'),
 (34,'modulo_BS','INS'),
 (35,'modulo_BS','UPD'),
 (36,'modulo_BS','DEL'),
 (37,'modulo_BS','VIEW'),
 (38,'modulo_FORNECEDOR','INS'),
 (39,'modulo_FORNECEDOR','UPD'),
 (40,'modulo_FORNECEDOR','DEL'),
 (41,'modulo_FORNECEDOR','VIEW'),
 (42,'modulo_ACCOUNT','INS'),
 (43,'modulo_ACCOUNT','UPD'),
 (44,'modulo_ACCOUNT','DEL'),
 (45,'modulo_ACCOUNT','VIEW'),
 (46,'modulo_AGENDA','INS'),
 (47,'modulo_AGENDA','UPD'),
 (48,'modulo_AGENDA','DEL'),
 (49,'modulo_AGENDA','VIEW'),
 (55,'modulo_BS','COPY'),
 (56,'modulo_USUARIO','UPD_DIR'),
 (57,'modulo_CONTRATO','INS'),
 (58,'modulo_CONTRATO','UPD'),
 (59,'modulo_CONTRATO','DEL'),
 (60,'modulo_CONTRATO','VIEW'),
 (61,'modulo_DBManager','FULL'),
 (63,'modulo_FIN_CONTAS','INS'),
 (64,'modulo_FIN_CONTAS','UPD'),
 (65,'modulo_FIN_CONTAS','DEL'),
 (66,'modulo_FIN_CONTAS','VIEW'),
 (68,'modulo_FIN_LCTOCONTA','INS'),
 (70,'modulo_FIN_LCTOCONTA','DEL'),
 (71,'modulo_FIN_LCTOCONTA','VIEW'),
 (72,'modulo_HORARIO','INS'),
 (73,'modulo_HORARIO','UPD'),
 (74,'modulo_HORARIO','DEL'),
 (75,'modulo_HORARIO','VIEW'),
 (76,'modulo_MENU','INS'),
 (77,'modulo_MENU','UPD'),
 (78,'modulo_MENU','DEL'),
 (79,'modulo_MENU','VIEW'),
 (80,'modulo_TODOLIST','INS_MULT'),
 (81,'modulo_AGENDA','INS_MULT'),
 (82,'modulo_TODOLIST','INS_RESP'),
 (83,'modulo_FILEEXPLORER','FULL'),
 (85,'modulo_BS','INS_RESP'),
 (86,'modulo_USUARIO','COPY'),
 (87,'modulo_RELAT_ASLW','INS'),
 (88,'modulo_RELAT_ASLW','UPD'),
 (89,'modulo_RELAT_ASLW','DEL'),
 (90,'modulo_RELAT_ASLW','VIEW'),
 (91,'modulo_RELAT_ASLW','EXEC'),
 (92,'modulo_FIN_PAINEL','VIEW'),
 (93,'modulo_FIN_CCUSTOS','INS'),
 (94,'modulo_FIN_CCUSTOS','UPD'),
 (95,'modulo_FIN_CCUSTOS','DEL'),
 (96,'modulo_FIN_CCUSTOS','VIEW'),
 (97,'modulo_FIN_FLUXOCAIXA','VIEW'),
 (98,'modulo_FIN_FLUXOCAIXA','INS'),
 (99,'modulo_FIN_FLUXOCAIXA','DEL'),
 (100,'modulo_FIN_PCONTAS','VIEW'),
 (101,'modulo_FIN_PCONTAS','INS'),
 (102,'modulo_FIN_PCONTAS','DEL'),
 (103,'modulo_FIN_PCONTAS','UPD'),
 (104,'modulo_FIN_TITULOS','DEL'),
 (105,'modulo_FIN_TITULOS','VIEW'),
 (106,'modulo_FIN_TITULOS','INS'),
 (107,'modulo_ICONPAINEL','COPY'),
 (108,'modulo_CATEGORIAS','VIEW'),
 (109,'modulo_CATEGORIAS','INS'),
 (110,'modulo_CATEGORIAS','DEL'),
 (111,'modulo_CATEGORIAS','UPD'),
 (112,'modulo_CATEGORIA_ASLW','VIEW'),
 (113,'modulo_CATEGORIA_ASLW','INS'),
 (114,'modulo_CATEGORIA_ASLW','DEL'),
 (115,'modulo_CATEGORIA_ASLW','UPD'),
 (116,'modulo_CATEGORIA_BS','VIEW'),
 (117,'modulo_CATEGORIA_BS','INS'),
 (118,'modulo_CATEGORIA_BS','DEL'),
 (119,'modulo_CATEGORIA_BS','UPD'),
 (120,'modulo_CATEGORIA_TL','VIEW'),
 (121,'modulo_CATEGORIA_TL','INS'),
 (122,'modulo_CATEGORIA_TL','DEL'),
 (123,'modulo_CATEGORIA_TL','UPD'),
 (124,'modulo_FIN_PREV_ORCA','VIEW'),
 (125,'modulo_FIN_PREV_ORCA','INS'),
 (126,'modulo_FIN_PREV_ORCA','UPD'),
 (127,'modulo_FIN_PREV_ORCA','DEL'),
 (128,'modulo_FIN_LIVRO_CX','VIEW'),
 (129,'modulo_FIN_PREV_REAL','VIEW'),
 (130,'modulo_FIN_BOLETO','VIEW'),
 (131,'modulo_FIN_BOLETO','INS'),
 (132,'modulo_FIN_BOLETO','UPD'),
 (133,'modulo_FIN_BOLETO','DEL'),
 (134,'modulo_FIN_SERVICO','INS'),
 (135,'modulo_FIN_SERVICO','UPD'),
 (136,'modulo_FIN_SERVICO','DEL'),
 (137,'modulo_FIN_SERVICO','VIEW'),
 (138,'modulo_FIN_NF','INS'),
 (139,'modulo_FIN_NF','VIEW'),
 (140,'modulo_FIN_NF','UPD'),
 (141,'modulo_FIN_NF','DEL'),
 (142,'modulo_FIN_NF_CFG','INS'),
 (143,'modulo_FIN_NF_CFG','UPD'),
 (144,'modulo_FIN_NF_CFG','DEL'),
 (145,'modulo_FIN_NF_CFG','VIEW'),
 (146,'modulo_PONTO_FOLGA','VIEW'),
 (147,'modulo_PONTO_FOLGA','INS'),
 (148,'modulo_PONTO_FOLGA','UPD'),
 (149,'modulo_PONTO_FOLGA','DEL'),
 (150,'modulo_INVENTARIO','INS'),
 (151,'modulo_INVENTARIO','UPD'),
 (152,'modulo_INVENTARIO','DEL'),
 (153,'modulo_INVENTARIO','VIEW'),
 (154,'modulo_FIN_LCTO_GERAIS','VIEW'),
 (155,'modulo_FIN_NF','PREVIEW'),
 (156,'modulo_FIN_NF','PRINT'),
 (158,'modulo_TODOLIST','UPD_ALL_TODO'),
 (159,'modulo_BS','UPD_ALL_BS'),
 (160,'modulo_PONTO_DESCONTO','INS'),
 (161,'modulo_PONTO_DESCONTO','UPD'),
 (162,'modulo_PONTO_DESCONTO','VIEW'),
 (163,'modulo_PONTO_DESCONTO','DEL'),
 (164,'modulo_PONTO_FERIADO','INS'),
 (165,'modulo_PONTO_FERIADO','UPD'),
 (166,'modulo_PONTO_FERIADO','VIEW'),
 (167,'modulo_PONTO_FERIADO','DEL'),
 (169,'modulo_TODOLIST','COPY'),
 (170,'modulo_CHAMADO','INS'),
 (171,'modulo_CHAMADO','VIEW'),
 (172,'modulo_CHAMADO','UPD'),
 (173,'modulo_CHAMADO','ATENDE'),
 (174,'modulo_ADM_CLASSES','INS'),
 (175,'modulo_ADM_CLASSES','UPD'),
 (176,'modulo_ADM_CLASSES','DEL'),
 (177,'modulo_ADM_CLASSES','VIEW'),
 (178,'modulo_ADM_COMPETENCIAS','INS'),
 (179,'modulo_ADM_COMPETENCIAS','UPD'),
 (180,'modulo_ADM_COMPETENCIAS','DEL'),
 (181,'modulo_ADM_COMPETENCIAS','VIEW'),
 (182,'modulo_ADM_CARGOS','INS'),
 (183,'modulo_ADM_CARGOS','UPD'),
 (184,'modulo_ADM_CARGOS','DEL'),
 (185,'modulo_ADM_CARGOS','VIEW'),
 (186,'modulo_FIN_TITULOS','UPD'),
 (187,'modulo_DBManager','RED_BUTTON'),
 (188,'modulo_CHAMADO','DEL'),
 (189,'modulo_RESPOSTA','VIEW'),
 (190,'modulo_COLABORADOR','DADOS_RH'),
 (191,'modulo_FIN_LCTOCONTA','UPD'),
 (192,'modulo_FIN_BALANCETE','VIEW'),
 (193,'modulo_FIN_TITULOS','INS_NO_MES'),
 (194,'modulo_FIN_TITULOS','DEL_NO_MES'),
 (195,'modulo_FIN_LCTOCONTA','INS_NO_MES'),
 (196,'modulo_FIN_LCTOCONTA','DEL_NO_MES'),
 (197,'modulo_FIN_EXTRATO','VIEW'),
 (198,'modulo_FIN_TITULOS','CALC_TAXAS'),
 (199,'modulo_FIN_TITULOS','RECALC_TAXAS'),
 (200,'modulo_CONTRATO','PROCESSA'),
 (201,'modulo_PEDIDO','INS'),
 (202,'modulo_PEDIDO','UPD'),
 (203,'modulo_PEDIDO','DEL'),
 (204,'modulo_PEDIDO','VIEW'),
 (205,'modulo_PEDIDO','FATURA'),
 (206,'modulo_MB_LIVRO','INS'),
 (207,'modulo_MB_LIVRO','UPD'),
 (208,'modulo_MB_LIVRO','DEL'),
 (209,'modulo_MB_LIVRO','VIEW'),
 (210,'modulo_MB_LIVRO','IMPORT'),
 (211,'modulo_MB_REVISTA','INS'),
 (212,'modulo_MB_REVISTA','UPD'),
 (213,'modulo_MB_REVISTA','DEL'),
 (214,'modulo_MB_REVISTA','VIEW'),
 (215,'modulo_MB_REVISTA','IMPORT'),
 (216,'modulo_MB_MANUAL','INS'),
 (217,'modulo_MB_MANUAL','UPD'),
 (218,'modulo_MB_MANUAL','DEL'),
 (219,'modulo_MB_MANUAL','VIEW'),
 (220,'modulo_MB_MANUAL','IMPORT'),
 (221,'modulo_MB_DISCO','INS'),
 (222,'modulo_MB_DISCO','UPD'),
 (223,'modulo_MB_DISCO','DEL'),
 (224,'modulo_MB_DISCO','VIEW'),
 (225,'modulo_MB_DISCO','IMPORT'),
 (226,'modulo_MB_VIDEO','INS'),
 (227,'modulo_MB_VIDEO','UPD'),
 (228,'modulo_MB_VIDEO','DEL'),
 (229,'modulo_MB_VIDEO','VIEW'),
 (230,'modulo_MB_VIDEO','IMPORT'),
 (231,'modulo_MB_DADO','INS'),
 (232,'modulo_MB_DADO','UPD'),
 (233,'modulo_MB_DADO','DEL'),
 (234,'modulo_MB_DADO','VIEW'),
 (235,'modulo_MB_DADO','IMPORT'),
 (236,'modulo_RESPOSTA','UPLOAD'),
 (237,'modulo_CHAMADO','DESBLOQUEIA'),
 (239,'modulo_FIN_TITULOS','PAGAR'),
 (240,'modulo_FIN_TITULOS','RECEBER'),
 (241,'modulo_FIN_FLUXOCAIXA','PAGAR'),
 (242,'modulo_FIN_FLUXOCAIXA','RECEBER'),
 (243,'modulo_FIN_TITULOS_ENT','VIEW'),
 (244,'modulo_PROJETO_BACKLOG','INS'),
 (245,'modulo_PROJETO_BACKLOG','UPD'),
 (246,'modulo_PROJETO_BACKLOG','DEL'),
 (247,'modulo_PROJETO_BACKLOG','VIEW'),
 (248,'modulo_PROJETO','INS'),
 (249,'modulo_PROJETO','UPD'),
 (250,'modulo_PROJETO','DEL'),
 (251,'modulo_PROJETO','VIEW'),
 (252,'modulo_CONTRATO','COPY'),
 (253,'modulo_PONTO','UPD_ALL_PONTO'),
 (254,'modulo_ENQUETE','VIEW'),
 (255,'modulo_ENQUETE','DEL'),
 (256,'modulo_ENQUETE','UPD'),
 (257,'modulo_ENQUETE','INS'),
 (258,'modulo_IMPORTACAO','INS'),
 (259,'modulo_FIN_NFREPORT','VIEW'),
 (263,'modulo_IMPORTACAO','INS'),
 (264,'modulo_TODOLIST','TRANS');
/*!40000 ALTER TABLE `sys_app_direito` ENABLE KEYS */;


--
-- Definition of table `sys_app_direito_usuario`
--

DROP TABLE IF EXISTS `sys_app_direito_usuario`;
CREATE TABLE `sys_app_direito_usuario` (
  `COD_APP_DIREITO_USUARIO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_APP_DIREITO` int(10) DEFAULT NULL,
  `ID_USUARIO` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_APP_DIREITO_USUARIO`),
  KEY `COD_APP_DIREITO` (`COD_APP_DIREITO`),
  KEY `ID_USUARIO` (`ID_USUARIO`),
  KEY `SYS_APP_DIREITOSYS_APP_DIREITO_` (`COD_APP_DIREITO`)
) ENGINE=InnoDB AUTO_INCREMENT=25946 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sys_app_direito_usuario`
--

/*!40000 ALTER TABLE `sys_app_direito_usuario` DISABLE KEYS */;
INSERT INTO `sys_app_direito_usuario` (`COD_APP_DIREITO_USUARIO`,`COD_APP_DIREITO`,`ID_USUARIO`) VALUES 
 (8751,83,'_athenas'),
 (8752,131,'_athenas'),
 (8753,132,'_athenas'),
 (8754,133,'_athenas'),
 (8755,130,'_athenas'),
 (8756,93,'_athenas'),
 (8757,94,'_athenas'),
 (8758,95,'_athenas'),
 (8759,96,'_athenas'),
 (8760,63,'_athenas'),
 (8761,64,'_athenas'),
 (8762,65,'_athenas'),
 (8763,66,'_athenas'),
 (8764,98,'_athenas'),
 (8765,99,'_athenas'),
 (8766,97,'_athenas'),
 (8767,154,'_athenas'),
 (8768,68,'_athenas'),
 (8769,70,'_athenas'),
 (8770,71,'_athenas'),
 (8771,128,'_athenas'),
 (8772,138,'_athenas'),
 (8773,140,'_athenas'),
 (8774,141,'_athenas'),
 (8775,139,'_athenas'),
 (8776,155,'_athenas'),
 (8777,156,'_athenas'),
 (8778,142,'_athenas'),
 (8779,143,'_athenas'),
 (8780,144,'_athenas'),
 (8781,145,'_athenas'),
 (8782,92,'_athenas'),
 (8783,101,'_athenas'),
 (8784,103,'_athenas'),
 (8785,102,'_athenas'),
 (8786,100,'_athenas'),
 (8787,125,'_athenas'),
 (8788,126,'_athenas'),
 (8789,127,'_athenas'),
 (8790,124,'_athenas'),
 (8791,129,'_athenas'),
 (8792,134,'_athenas'),
 (8793,135,'_athenas'),
 (8794,136,'_athenas'),
 (8795,137,'_athenas'),
 (8796,106,'_athenas'),
 (8797,104,'_athenas'),
 (8798,105,'_athenas'),
 (8799,38,'_athenas'),
 (8800,39,'_athenas'),
 (8801,40,'_athenas'),
 (8802,41,'_athenas'),
 (8803,72,'_athenas'),
 (8804,73,'_athenas'),
 (8805,74,'_athenas'),
 (8806,75,'_athenas'),
 (8807,22,'_athenas'),
 (8808,23,'_athenas'),
 (8809,24,'_athenas'),
 (8810,25,'_athenas'),
 (8811,107,'_athenas'),
 (8812,150,'_athenas'),
 (8813,151,'_athenas'),
 (8814,152,'_athenas'),
 (8815,153,'_athenas'),
 (8816,76,'_athenas'),
 (8817,77,'_athenas'),
 (8818,78,'_athenas'),
 (8819,79,'_athenas'),
 (8820,18,'_athenas'),
 (8821,19,'_athenas'),
 (8822,20,'_athenas'),
 (8823,21,'_athenas'),
 (8824,14,'_athenas'),
 (8825,15,'_athenas'),
 (8826,16,'_athenas'),
 (8827,17,'_athenas'),
 (8828,147,'_athenas'),
 (8829,148,'_athenas'),
 (8830,149,'_athenas'),
 (8831,146,'_athenas'),
 (8832,10,'_athenas'),
 (8833,11,'_athenas'),
 (8834,12,'_athenas'),
 (8835,13,'_athenas'),
 (8836,87,'_athenas'),
 (8837,88,'_athenas'),
 (8838,89,'_athenas'),
 (8839,90,'_athenas'),
 (8840,91,'_athenas'),
 (8841,6,'_athenas'),
 (8842,7,'_athenas'),
 (8843,8,'_athenas'),
 (8844,9,'_athenas'),
 (8845,82,'_athenas'),
 (8846,80,'_athenas'),
 (9890,160,'_athenas'),
 (9891,161,'_athenas'),
 (9892,163,'_athenas'),
 (9893,162,'_athenas'),
 (9894,164,'_athenas'),
 (9895,165,'_athenas'),
 (9896,167,'_athenas'),
 (9897,166,'_athenas'),
 (10921,42,'_athenas'),
 (10922,43,'_athenas'),
 (10923,44,'_athenas'),
 (10924,45,'_athenas'),
 (10925,46,'_athenas'),
 (10926,47,'_athenas'),
 (10927,48,'_athenas'),
 (10928,49,'_athenas'),
 (10929,81,'_athenas'),
 (10930,34,'_athenas'),
 (10931,35,'_athenas'),
 (10932,36,'_athenas'),
 (10933,37,'_athenas'),
 (10934,55,'_athenas'),
 (10935,85,'_athenas'),
 (10936,159,'_athenas'),
 (10937,113,'_athenas'),
 (10938,115,'_athenas'),
 (10939,114,'_athenas'),
 (10940,112,'_athenas'),
 (10941,117,'_athenas'),
 (10942,119,'_athenas'),
 (10943,118,'_athenas'),
 (10944,116,'_athenas'),
 (10945,121,'_athenas'),
 (10946,123,'_athenas'),
 (10947,122,'_athenas'),
 (10948,120,'_athenas'),
 (10949,109,'_athenas'),
 (10950,111,'_athenas'),
 (10951,110,'_athenas'),
 (10952,108,'_athenas'),
 (10953,84,'_athenas'),
 (10954,30,'_athenas'),
 (10955,31,'_athenas'),
 (10956,32,'_athenas'),
 (10957,33,'_athenas'),
 (10958,26,'_athenas'),
 (10959,27,'_athenas'),
 (10960,28,'_athenas'),
 (10961,29,'_athenas'),
 (10962,57,'_athenas'),
 (10963,58,'_athenas'),
 (10964,59,'_athenas'),
 (10965,60,'_athenas'),
 (12823,2,'_athenas'),
 (12824,3,'_athenas'),
 (12825,4,'_athenas'),
 (12826,5,'_athenas'),
 (12827,86,'_athenas'),
 (12828,56,'_athenas'),
 (15579,84,'aless'),
 (16293,61,'_athenas'),
 (16294,187,'_athenas'),
 (25156,42,'aless'),
 (25157,43,'aless'),
 (25158,44,'aless'),
 (25159,45,'aless'),
 (25160,182,'aless'),
 (25161,183,'aless'),
 (25162,184,'aless'),
 (25163,185,'aless'),
 (25164,174,'aless'),
 (25165,175,'aless'),
 (25166,176,'aless'),
 (25167,177,'aless'),
 (25168,178,'aless'),
 (25169,179,'aless'),
 (25170,180,'aless'),
 (25171,181,'aless'),
 (25172,46,'aless'),
 (25173,47,'aless'),
 (25174,48,'aless'),
 (25175,49,'aless'),
 (25176,81,'aless'),
 (25177,34,'aless'),
 (25178,35,'aless'),
 (25179,36,'aless'),
 (25180,37,'aless'),
 (25181,55,'aless'),
 (25182,85,'aless'),
 (25183,159,'aless'),
 (25184,109,'aless'),
 (25185,111,'aless'),
 (25186,110,'aless'),
 (25187,108,'aless'),
 (25188,113,'aless'),
 (25189,115,'aless'),
 (25190,114,'aless'),
 (25191,112,'aless'),
 (25192,117,'aless'),
 (25193,119,'aless'),
 (25194,118,'aless'),
 (25195,116,'aless'),
 (25196,121,'aless'),
 (25197,123,'aless'),
 (25198,122,'aless'),
 (25199,120,'aless'),
 (25200,170,'aless'),
 (25201,172,'aless'),
 (25202,171,'aless'),
 (25203,173,'aless'),
 (25204,237,'aless'),
 (25205,30,'aless'),
 (25206,31,'aless'),
 (25207,32,'aless'),
 (25208,33,'aless'),
 (25209,26,'aless'),
 (25210,27,'aless'),
 (25211,28,'aless'),
 (25212,29,'aless'),
 (25213,190,'aless'),
 (25214,57,'aless'),
 (25215,58,'aless'),
 (25216,59,'aless'),
 (25217,60,'aless'),
 (25218,200,'aless'),
 (25219,61,'aless'),
 (25220,187,'aless'),
 (25221,83,'aless'),
 (25222,192,'aless'),
 (25223,131,'aless'),
 (25224,132,'aless'),
 (25225,133,'aless'),
 (25226,130,'aless'),
 (25227,93,'aless'),
 (25228,94,'aless'),
 (25229,95,'aless'),
 (25230,96,'aless'),
 (25231,63,'aless'),
 (25232,64,'aless'),
 (25233,65,'aless'),
 (25234,66,'aless'),
 (25235,197,'aless'),
 (25236,98,'aless'),
 (25237,99,'aless'),
 (25238,97,'aless'),
 (25239,241,'aless'),
 (25240,242,'aless'),
 (25241,68,'aless'),
 (25242,191,'aless'),
 (25243,70,'aless'),
 (25244,71,'aless'),
 (25245,195,'aless'),
 (25246,196,'aless'),
 (25247,154,'aless'),
 (25248,128,'aless'),
 (25249,138,'aless'),
 (25250,140,'aless'),
 (25251,141,'aless'),
 (25252,139,'aless'),
 (25253,155,'aless'),
 (25254,156,'aless'),
 (25255,142,'aless'),
 (25256,143,'aless'),
 (25257,144,'aless'),
 (25258,145,'aless'),
 (25259,92,'aless'),
 (25260,101,'aless'),
 (25261,103,'aless'),
 (25262,102,'aless'),
 (25263,100,'aless'),
 (25264,125,'aless'),
 (25265,126,'aless'),
 (25266,127,'aless'),
 (25267,124,'aless'),
 (25268,129,'aless'),
 (25269,134,'aless'),
 (25270,135,'aless'),
 (25271,136,'aless'),
 (25272,137,'aless'),
 (25273,106,'aless'),
 (25274,186,'aless'),
 (25275,104,'aless'),
 (25276,105,'aless'),
 (25277,193,'aless'),
 (25278,194,'aless'),
 (25279,198,'aless'),
 (25280,199,'aless'),
 (25281,239,'aless'),
 (25282,240,'aless'),
 (25283,243,'aless'),
 (25284,38,'aless'),
 (25285,39,'aless'),
 (25286,40,'aless'),
 (25287,41,'aless'),
 (25288,72,'aless'),
 (25289,73,'aless'),
 (25290,74,'aless'),
 (25291,75,'aless'),
 (25292,22,'aless'),
 (25293,23,'aless'),
 (25294,24,'aless'),
 (25295,25,'aless'),
 (25296,107,'aless'),
 (25297,150,'aless'),
 (25298,151,'aless'),
 (25299,152,'aless'),
 (25300,153,'aless'),
 (25301,231,'aless'),
 (25302,232,'aless'),
 (25303,233,'aless'),
 (25304,234,'aless'),
 (25305,235,'aless'),
 (25306,221,'aless'),
 (25307,222,'aless'),
 (25308,223,'aless'),
 (25309,224,'aless'),
 (25310,225,'aless'),
 (25311,206,'aless'),
 (25312,207,'aless'),
 (25313,208,'aless'),
 (25314,209,'aless'),
 (25315,210,'aless'),
 (25316,216,'aless'),
 (25317,217,'aless'),
 (25318,218,'aless'),
 (25319,219,'aless'),
 (25320,220,'aless'),
 (25321,211,'aless'),
 (25322,212,'aless'),
 (25323,213,'aless'),
 (25324,214,'aless'),
 (25325,215,'aless'),
 (25326,226,'aless'),
 (25327,227,'aless'),
 (25328,228,'aless'),
 (25329,229,'aless'),
 (25330,230,'aless'),
 (25331,76,'aless'),
 (25332,77,'aless'),
 (25333,78,'aless'),
 (25334,79,'aless'),
 (25335,18,'aless'),
 (25336,19,'aless'),
 (25337,20,'aless'),
 (25338,21,'aless'),
 (25339,201,'aless'),
 (25340,202,'aless'),
 (25341,203,'aless'),
 (25342,204,'aless'),
 (25343,205,'aless'),
 (25344,14,'aless'),
 (25345,15,'aless'),
 (25346,16,'aless'),
 (25347,17,'aless'),
 (25348,160,'aless'),
 (25349,161,'aless'),
 (25350,163,'aless'),
 (25351,162,'aless'),
 (25352,164,'aless'),
 (25353,165,'aless'),
 (25354,167,'aless'),
 (25355,166,'aless'),
 (25356,147,'aless'),
 (25357,148,'aless'),
 (25358,149,'aless'),
 (25359,146,'aless'),
 (25360,10,'aless'),
 (25361,11,'aless'),
 (25362,12,'aless'),
 (25363,13,'aless'),
 (25364,244,'aless'),
 (25365,245,'aless'),
 (25366,246,'aless'),
 (25367,247,'aless'),
 (25368,87,'aless'),
 (25369,88,'aless'),
 (25370,89,'aless'),
 (25371,90,'aless'),
 (25372,91,'aless'),
 (25373,189,'aless'),
 (25374,236,'aless'),
 (25375,6,'aless'),
 (25376,7,'aless'),
 (25377,8,'aless'),
 (25378,9,'aless'),
 (25379,169,'aless'),
 (25380,82,'aless'),
 (25381,80,'aless'),
 (25382,158,'aless'),
 (25383,2,'aless'),
 (25384,3,'aless'),
 (25385,4,'aless'),
 (25386,5,'aless'),
 (25387,86,'aless'),
 (25388,56,'aless'),
 (25671,42,'demo'),
 (25672,43,'demo'),
 (25673,44,'demo'),
 (25674,45,'demo'),
 (25675,182,'demo'),
 (25676,183,'demo'),
 (25677,184,'demo'),
 (25678,185,'demo'),
 (25679,174,'demo'),
 (25680,175,'demo'),
 (25681,176,'demo'),
 (25682,177,'demo'),
 (25683,178,'demo'),
 (25684,179,'demo'),
 (25685,180,'demo'),
 (25686,181,'demo'),
 (25687,46,'demo'),
 (25688,47,'demo'),
 (25689,48,'demo'),
 (25690,49,'demo'),
 (25691,81,'demo'),
 (25692,34,'demo'),
 (25693,35,'demo'),
 (25694,36,'demo'),
 (25695,37,'demo'),
 (25696,55,'demo'),
 (25697,85,'demo'),
 (25698,159,'demo'),
 (25699,109,'demo'),
 (25700,111,'demo'),
 (25701,110,'demo'),
 (25702,108,'demo'),
 (25703,113,'demo'),
 (25704,115,'demo'),
 (25705,114,'demo'),
 (25706,112,'demo'),
 (25707,117,'demo'),
 (25708,119,'demo'),
 (25709,118,'demo'),
 (25710,116,'demo'),
 (25711,121,'demo'),
 (25712,123,'demo'),
 (25713,122,'demo'),
 (25714,120,'demo'),
 (25715,170,'demo'),
 (25716,172,'demo'),
 (25717,188,'demo'),
 (25718,171,'demo'),
 (25719,173,'demo'),
 (25720,237,'demo'),
 (25721,30,'demo'),
 (25722,31,'demo'),
 (25723,32,'demo'),
 (25724,33,'demo'),
 (25725,26,'demo'),
 (25726,27,'demo'),
 (25727,28,'demo'),
 (25728,29,'demo'),
 (25729,190,'demo'),
 (25730,57,'demo'),
 (25731,58,'demo'),
 (25732,59,'demo'),
 (25733,60,'demo'),
 (25734,200,'demo'),
 (25735,61,'demo'),
 (25736,187,'demo'),
 (25737,83,'demo'),
 (25738,192,'demo'),
 (25739,131,'demo'),
 (25740,132,'demo'),
 (25741,133,'demo'),
 (25742,130,'demo'),
 (25743,93,'demo'),
 (25744,94,'demo'),
 (25745,95,'demo'),
 (25746,96,'demo'),
 (25747,63,'demo'),
 (25748,64,'demo'),
 (25749,65,'demo'),
 (25750,66,'demo'),
 (25751,197,'demo'),
 (25752,98,'demo'),
 (25753,99,'demo'),
 (25754,97,'demo'),
 (25755,68,'demo'),
 (25756,191,'demo'),
 (25757,70,'demo'),
 (25758,71,'demo'),
 (25759,195,'demo'),
 (25760,196,'demo'),
 (25761,154,'demo'),
 (25762,128,'demo'),
 (25763,138,'demo'),
 (25764,140,'demo'),
 (25765,141,'demo'),
 (25766,139,'demo'),
 (25767,155,'demo'),
 (25768,156,'demo'),
 (25769,142,'demo'),
 (25770,143,'demo'),
 (25771,144,'demo'),
 (25772,145,'demo'),
 (25773,92,'demo'),
 (25774,101,'demo'),
 (25775,103,'demo'),
 (25776,102,'demo'),
 (25777,100,'demo'),
 (25778,125,'demo'),
 (25779,126,'demo'),
 (25780,127,'demo'),
 (25781,124,'demo'),
 (25782,129,'demo'),
 (25783,134,'demo'),
 (25784,135,'demo'),
 (25785,136,'demo'),
 (25786,137,'demo'),
 (25787,106,'demo'),
 (25788,186,'demo'),
 (25789,104,'demo'),
 (25790,105,'demo'),
 (25791,193,'demo'),
 (25792,194,'demo'),
 (25793,198,'demo'),
 (25794,199,'demo'),
 (25795,239,'demo'),
 (25796,240,'demo'),
 (25797,243,'demo'),
 (25798,38,'demo'),
 (25799,39,'demo'),
 (25800,40,'demo'),
 (25801,41,'demo'),
 (25802,72,'demo'),
 (25803,73,'demo'),
 (25804,74,'demo'),
 (25805,75,'demo'),
 (25806,22,'demo'),
 (25807,23,'demo'),
 (25808,24,'demo'),
 (25809,25,'demo'),
 (25810,107,'demo'),
 (25811,150,'demo'),
 (25812,151,'demo'),
 (25813,152,'demo'),
 (25814,153,'demo'),
 (25815,231,'demo'),
 (25816,232,'demo'),
 (25817,233,'demo'),
 (25818,234,'demo'),
 (25819,235,'demo'),
 (25820,221,'demo'),
 (25821,222,'demo'),
 (25822,223,'demo'),
 (25823,224,'demo'),
 (25824,225,'demo'),
 (25825,206,'demo'),
 (25826,207,'demo'),
 (25827,208,'demo'),
 (25828,209,'demo'),
 (25829,210,'demo'),
 (25830,216,'demo'),
 (25831,217,'demo'),
 (25832,218,'demo'),
 (25833,219,'demo'),
 (25834,220,'demo'),
 (25835,211,'demo'),
 (25836,212,'demo'),
 (25837,213,'demo'),
 (25838,214,'demo'),
 (25839,215,'demo'),
 (25840,226,'demo'),
 (25841,227,'demo'),
 (25842,228,'demo'),
 (25843,229,'demo'),
 (25844,230,'demo'),
 (25845,76,'demo'),
 (25846,77,'demo'),
 (25847,78,'demo'),
 (25848,79,'demo'),
 (25849,18,'demo'),
 (25850,19,'demo'),
 (25851,20,'demo'),
 (25852,21,'demo'),
 (25853,201,'demo'),
 (25854,202,'demo'),
 (25855,203,'demo'),
 (25856,204,'demo'),
 (25857,205,'demo'),
 (25858,14,'demo'),
 (25859,15,'demo'),
 (25860,16,'demo'),
 (25861,17,'demo'),
 (25862,253,'demo'),
 (25863,160,'demo'),
 (25864,161,'demo'),
 (25865,163,'demo'),
 (25866,162,'demo'),
 (25867,164,'demo'),
 (25868,165,'demo'),
 (25869,167,'demo'),
 (25870,166,'demo'),
 (25871,147,'demo'),
 (25872,148,'demo'),
 (25873,149,'demo'),
 (25874,146,'demo'),
 (25875,10,'demo'),
 (25876,11,'demo'),
 (25877,12,'demo'),
 (25878,13,'demo'),
 (25879,248,'demo'),
 (25880,249,'demo'),
 (25881,250,'demo'),
 (25882,251,'demo'),
 (25883,244,'demo'),
 (25884,245,'demo'),
 (25885,246,'demo'),
 (25886,247,'demo'),
 (25887,87,'demo'),
 (25888,88,'demo'),
 (25889,89,'demo'),
 (25890,90,'demo'),
 (25891,91,'demo'),
 (25892,189,'demo'),
 (25893,236,'demo'),
 (25894,6,'demo'),
 (25895,7,'demo'),
 (25896,8,'demo'),
 (25897,9,'demo'),
 (25898,169,'demo'),
 (25899,82,'demo'),
 (25900,80,'demo'),
 (25901,158,'demo'),
 (25902,2,'demo'),
 (25903,3,'demo'),
 (25904,4,'demo'),
 (25905,5,'demo'),
 (25906,86,'demo'),
 (25907,56,'demo'),
 (25921,257,'_athenas'),
 (25922,256,'_athenas'),
 (25923,255,'_athenas'),
 (25924,254,'_athenas'),
 (25925,257,'aless'),
 (25926,256,'aless'),
 (25927,255,'aless'),
 (25928,254,'aless'),
 (25941,257,'demo'),
 (25942,256,'demo'),
 (25943,255,'demo'),
 (25944,254,'demo'),
 (25945,258,'demo');
/*!40000 ALTER TABLE `sys_app_direito_usuario` ENABLE KEYS */;


--
-- Definition of table `sys_config_var`
--

DROP TABLE IF EXISTS `sys_config_var`;
CREATE TABLE `sys_config_var` (
  `COD_CONFIG` int(10) NOT NULL AUTO_INCREMENT,
  `COD_VAR` varchar(50) DEFAULT NULL,
  `VALOR` varchar(250) DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  PRIMARY KEY (`COD_CONFIG`),
  UNIQUE KEY `Index_6677B531_9073_46F0` (`COD_CONFIG`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sys_config_var`
--

/*!40000 ALTER TABLE `sys_config_var` DISABLE KEYS */;
INSERT INTO `sys_config_var` (`COD_CONFIG`,`COD_VAR`,`VALOR`,`ORDEM`) VALUES 
 (1,'DIAS_UTEIS','22',10),
 (2,'EXPEDIENTE','8:45',20),
 (3,'TOT_HORAS_MES','192:30',30),
 (4,'CUSTO_GERAL_MES','5500',40),
 (5,'CUSTO_INVEST_MES','0',50),
 (6,'CUSTO_FIXO_HORA','29.10',60),
 (7,'CUSTO_TOT_HORA','135,22',70);
/*!40000 ALTER TABLE `sys_config_var` ENABLE KEYS */;


--
-- Definition of table `sys_direito`
--

DROP TABLE IF EXISTS `sys_direito`;
CREATE TABLE `sys_direito` (
  `COD_DIREITO` int(10) NOT NULL AUTO_INCREMENT,
  `ID_DIREITO` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(250) DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  PRIMARY KEY (`COD_DIREITO`),
  UNIQUE KEY `NOME` (`ID_DIREITO`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sys_direito`
--

/*!40000 ALTER TABLE `sys_direito` DISABLE KEYS */;
INSERT INTO `sys_direito` (`COD_DIREITO`,`ID_DIREITO`,`DESCRICAO`,`ORDEM`) VALUES 
 (1,'INS','Inserções em geral',10),
 (2,'UPD','Alterações em geral',20),
 (3,'DEL','Exclusões em geral',30),
 (4,'VIEW','Visualizar dados (grade e/ou detail)',40),
 (5,'INS_MULT','Inserções multiplas ou em laço',100),
 (6,'COPY','Duplicação/Copia',50),
 (7,'UPD_DIR','Alteração de Direitos de usuários',60),
 (8,'INS_RESP','Inserção de respostas para Tarefas/TODOs',70),
 (9,'FULL','Controle TOTAL para aplicações especiais',80),
 (10,'EXEC','Direito de executar uma aplicação',90),
 (11,'PREVIEW','Pré-visualização',110),
 (12,'PRINT','Impressão',120),
 (13,'CLOSE','Fechamentos em geral',130),
 (14,'UPD_ALL_TODO','Alterações em qualquer Tarefa/TODO',140),
 (15,'UPD_ALL_BS','Alterações em qualquer Atividade/BS',150),
 (17,'RED_BUTTON','Direito especial para executar operações críticas',170),
 (18,'ATENDE','Atendimentos em geral',180),
 (19,'DADOS_RH','Manipula apenas Dados de RH (view, ins, upd)',190),
 (20,'INS_NO_MES','Inserções em geral apenas no mês',200),
 (21,'UPD_NO_MES','Alterações em geral apenas no mês',210),
 (22,'DEL_NO_MES','Exclusões em geral apenas no mês',220),
 (23,'CALC_TAXAS','Cálculo de Taxas',230),
 (24,'RECALC_TAXAS','Recálculo de Taxas',240),
 (25,'PROCESSA','Processamento em geral',250),
 (26,'FATURA','Faturamento em geral',260),
 (27,'IMPORT','Importações em geral',270),
 (28,'UPLOAD','Upload de arquivos em geral',280),
 (29,'DESBLOQUEIA','Desbloqueios em geral',290),
 (30,'REAJUSTA','Resjuste das parcelas dos contratos',300),
 (31,'PAGAR','Manipular apenas títulos a pagar',310),
 (32,'RECEBER','Manipular apenas títulos a receber',320),
 (33,'UPD_ALL_PONTO','Alterações em qualquer Reg. de Ponto',165),
 (34,'TRANS','Transfência de responsavel de tarefas',330);
/*!40000 ALTER TABLE `sys_direito` ENABLE KEYS */;


--
-- Definition of table `sys_entidade`
--

DROP TABLE IF EXISTS `sys_entidade`;
CREATE TABLE `sys_entidade` (
  `COD_ENTIDADE` int(10) NOT NULL AUTO_INCREMENT,
  `TIPO` varchar(120) DEFAULT NULL,
  `DESCRICAO` varchar(120) DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  PRIMARY KEY (`COD_ENTIDADE`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sys_entidade`
--

/*!40000 ALTER TABLE `sys_entidade` DISABLE KEYS */;
INSERT INTO `sys_entidade` (`COD_ENTIDADE`,`TIPO`,`DESCRICAO`,`ORDEM`) VALUES 
 (1,'ENT_FORNECEDOR','Fornecedores',10),
 (2,'ENT_CLIENTE','Clientes',20),
 (3,'ENT_COLABORADOR','Colaboradores / Funcionários',30);
/*!40000 ALTER TABLE `sys_entidade` ENABLE KEYS */;


--
-- Definition of table `sys_grp_user`
--

DROP TABLE IF EXISTS `sys_grp_user`;
CREATE TABLE `sys_grp_user` (
  `COD_GRP_USER` int(10) NOT NULL AUTO_INCREMENT,
  `TIPO` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(50) DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  PRIMARY KEY (`COD_GRP_USER`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sys_grp_user`
--

/*!40000 ALTER TABLE `sys_grp_user` DISABLE KEYS */;
INSERT INTO `sys_grp_user` (`COD_GRP_USER`,`TIPO`,`DESCRICAO`,`ORDEM`) VALUES 
 (2,'SU','Super Usuário',10),
 (3,'MANAGER','Administrador',20),
 (4,'NORMAL','Colaborador',30),
 (5,'CLIENTE','Cliente',40),
 (6,'VISITANTE','Visitante',50);
/*!40000 ALTER TABLE `sys_grp_user` ENABLE KEYS */;


--
-- Definition of table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `COD_MENU` int(10) NOT NULL AUTO_INCREMENT,
  `COD_MENU_PAI` int(10) DEFAULT NULL,
  `GRP_USER` varchar(50) DEFAULT NULL,
  `ROTULO` varchar(255) DEFAULT NULL,
  `LINK` longtext,
  `ID_APP` varchar(250) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  `IMG` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`COD_MENU`),
  KEY `ID_APP` (`ID_APP`),
  KEY `ParentID` (`COD_MENU_PAI`)
) ENGINE=InnoDB AUTO_INCREMENT=923 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sys_menu`
--

/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` (`COD_MENU`,`COD_MENU_PAI`,`GRP_USER`,`ROTULO`,`LINK`,`ID_APP`,`DT_INATIVO`,`ORDEM`,`IMG`) VALUES 
 (100,-1,NULL,'Configurações',NULL,NULL,NULL,1000,'bg_panel_top.gif'),
 (101,100,NULL,'Meus Dados','../modulo_USUARIO/Update.asp',NULL,NULL,1010,'Bullet.gif'),
 (105,100,NULL,'Anotações','../modulo_NOTEPAD/default.htm',NULL,NULL,1020,'Bullet.gif'),
 (110,100,NULL,'Menu Principal','../modulo_MENU/default.htm',NULL,NULL,1030,'Bullet.gif'),
 (115,100,NULL,'Categorias','../modulo_CATEGORIAS/default.htm',NULL,NULL,1040,'Bullet.gif'),
 (120,100,NULL,'Tipo Boleto','../modulo_FIN_BOLETO/default.htm',NULL,NULL,1050,'Bullet.gif'),
 (125,100,NULL,'Config. Aviso','../modulo_AVISO_CFG/Default.htm',NULL,NULL,1060,'Bullet.gif'),
 (130,100,NULL,'Config. NF/Recibo','../modulo_FIN_NF_CFG/default.htm',NULL,NULL,1070,'Bullet.gif'),
 (140,100,NULL,'Planos de Contas','../modulo_FIN_PCONTAS/default.htm',NULL,NULL,1080,'Bullet.gif'),
 (150,100,NULL,'Centros de Custos','../modulo_FIN_CCUSTOS/default.htm',NULL,NULL,1090,'Bullet.gif'),
 (200,-1,NULL,'Sistema',NULL,NULL,NULL,2000,'bg_panel_top.gif'),
 (201,200,'SU','DB Explorer','../modulo_DBManager/athdefault.asp',NULL,NULL,2010,'Bullet.gif'),
 (205,200,'SU','File Explorer','../../FileManager.asp',NULL,NULL,2020,'Bullet.gif'),
 (210,200,'SU','Ajusta Saldos Finan','../_database/AjustaSaldos.asp',NULL,NULL,2030,'Bullet.gif'),
 (211,200,'MANAGER','DB Explorer','../modulo_DBManager/athdefault.asp',NULL,NULL,2010,'Bullet.gif'),
 (212,200,'MANAGER','File Explorer','../../FileManager.asp',NULL,NULL,2020,'Bullet.gif'),
 (213,200,'MANAGER','Ajusta Saldos Finan','../_database/AjustaSaldos.asp',NULL,NULL,2030,'Bullet.gif'),
 (215,200,NULL,'System Info','../modulo_SYSINFO/systeminfo.aspx',NULL,NULL,2040,'Bullet.gif'),
 (220,200,NULL,'System Components','../modulo_SYSCOMP/objcheck.asp',NULL,NULL,2050,'Bullet.gif'),
 (300,-1,NULL,'Usuários',NULL,NULL,NULL,3000,'bg_panel_top.gif'),
 (301,300,NULL,'Usuários','../modulo_USUARIO/Default.htm',NULL,NULL,3010,'Bullet.gif'),
 (305,300,NULL,'Carga Horária','../modulo_HORARIO/Default.htm',NULL,NULL,3030,'Bullet.gif'),
 (310,300,NULL,'Registro de Horas','../modulo_PONTO/Default.htm',NULL,NULL,3040,'Bullet.gif'),
 (315,300,NULL,'Descontos de Horas','../modulo_PONTO_DESCONTO/Default.htm',NULL,NULL,3050,'Bullet.gif'),
 (320,300,NULL,'Folgas Agendadas','../modulo_PONTO_FOLGA/Default.htm',NULL,NULL,3060,'Bullet.gif'),
 (325,300,NULL,'Feriados e Recessos','../modulo_PONTO_FERIADO/Default.htm',NULL,NULL,3070,'Bullet.gif'),
 (330,300,NULL,'Cálculo de Horas Extras','http://www.calculoexato.com.br/adel/trabalhistas/VHE/index.asp',NULL,NULL,3080,'Bullet.gif'),
 (400,-1,NULL,'Cadastros',NULL,NULL,NULL,4000,'bg_panel_top.gif'),
 (401,400,NULL,'Clientes','../modulo_CLIENTE/Default.htm',NULL,NULL,4010,'Bullet.gif'),
 (405,400,NULL,'Fornecedores','../modulo_FORNECEDOR/Default.htm',NULL,NULL,4020,'Bullet.gif'),
 (410,400,NULL,'Colaboradores','../modulo_COLABORADOR/Default.htm',NULL,NULL,4030,'Bullet.gif'),
 (415,400,NULL,'Inventário','../modulo_INVENTARIO/Default.htm',NULL,NULL,4040,'Bullet.gif'),
 (420,400,NULL,'Serviços','../modulo_FIN_SERVICO/default.htm',NULL,NULL,4050,'Bullet.gif'),
 (425,400,NULL,'Accounts','../modulo_ACCOUNT/Default.htm',NULL,NULL,4060,'Bullet.gif'),
 (500,-1,NULL,'Financeiro',NULL,NULL,NULL,5000,'bg_panel_top.gif'),
 (501,500,NULL,'Painel Geral','../modulo_FIN_PAINEL/default.htm',NULL,NULL,5010,'Bullet.gif'),
 (505,500,NULL,'Contas Banco','../modulo_FIN_CONTAS/default.htm',NULL,NULL,5015,'Bullet.gif'),
 (510,500,NULL,'Lctos em Conta','../modulo_FIN_LCTOCONTA/default.htm',NULL,NULL,5020,'Bullet.gif'),
 (515,500,NULL,'Títulos (Geral)','../modulo_FIN_TITULOS/default.asp?var_situacao=LCTO_TOTAL',NULL,NULL,5030,'Bullet.gif'),
 (520,500,NULL,'Fluxo de Caixa','../modulo_FIN_FLUXOCAIXA/default.htm',NULL,NULL,5040,'Bullet.gif'),
 (525,500,NULL,'Lctos Gerais','../modulo_FIN_LCTO_GERAIS/Default.htm',NULL,NULL,5050,'Bullet.gif'),
 (530,500,NULL,'NF/Recibo','../modulo_FIN_NF/default.htm',NULL,NULL,5060,'Bullet.gif'),
 (535,500,NULL,'Contratos','../modulo_CONTRATO/default.htm',NULL,NULL,5070,'Bullet.gif'),
 (540,500,NULL,'Pedidos','../modulo_PEDIDO/default.htm',NULL,'2015-02-10 00:00:00',5080,'Bullet.gif'),
 (600,-1,NULL,'Gestão',NULL,NULL,NULL,6000,'bg_panel_top.gif'),
 (601,600,NULL,'Agenda','../modulo_AGENDA/Default.htm',NULL,NULL,6005,'Bullet.gif'),
 (605,600,NULL,'Processos','../modulo_PROCESSO/default.htm',NULL,NULL,6010,'Bullet.gif'),
 (615,600,NULL,'Cargos','../modulo_ADM_CARGOS/Default.htm',NULL,NULL,6030,'Bullet.gif'),
 (620,600,NULL,'Classes','../modulo_ADM_CLASSES/Default.htm',NULL,NULL,6040,'Bullet.gif'),
 (625,600,NULL,'Competências','../modulo_ADM_COMPETENCIAS/Default.htm',NULL,NULL,6050,'Bullet.gif'),
 (700,-1,NULL,'Controle de Projetos',NULL,NULL,NULL,7000,'bg_panel_top.gif'),
 (701,700,NULL,'Projetos/Project','../modulo_PROJETO/default.htm',NULL,NULL,7010,'Bullet.gif'),
 (705,700,NULL,'Atividades/BS','../modulo_BS/default.htm',NULL,NULL,7020,'Bullet.gif'),
 (710,700,NULL,'Tarefas/ToDoList','../modulo_TODOLIST/default.htm',NULL,NULL,7030,'Bullet.gif'),
 (715,700,NULL,'Chamados','../modulo_CHAMADO/Default.htm',NULL,NULL,7040,'Bullet.gif'),
 (720,700,NULL,'Respostas','../modulo_RESPOSTA/default.htm',NULL,NULL,7050,'Bullet.gif'),
 (800,-1,NULL,'Biblioteca',NULL,NULL,NULL,8000,'bg_panel_top.gif'),
 (801,800,NULL,'Livros','../modulo_MB_LIVRO/default.htm',NULL,NULL,8010,'Bullet.gif'),
 (805,800,NULL,'Revistas','../modulo_MB_REVISTA/default.htm',NULL,NULL,8020,'Bullet.gif'),
 (810,800,NULL,'Manuais','../modulo_MB_MANUAL/default.htm',NULL,NULL,8030,'Bullet.gif'),
 (815,800,NULL,'Discos','../modulo_MB_DISCO/default.htm',NULL,NULL,8040,'Bullet.gif'),
 (820,800,NULL,'Vídeos','../modulo_MB_VIDEO/default.htm',NULL,NULL,8050,'Bullet.gif'),
 (825,800,NULL,'Dados','../modulo_MB_DADO/default.htm',NULL,NULL,8060,'Bullet.gif'),
 (900,-1,NULL,'Relatórios',NULL,NULL,NULL,9000,'bg_panel_top.gif'),
 (901,900,NULL,'Relatórios ASL','../modulo_RELAT_ASLW',NULL,NULL,9020,'Bullet.gif'),
 (905,900,NULL,'Balancete','../modulo_FIN_BALANCETE/default.htm',NULL,NULL,9030,'Bullet.gif'),
 (910,900,NULL,'Livro Caixa','../modulo_FIN_LIVRO_CX/Default.htm',NULL,NULL,9040,'Bullet.gif'),
 (915,900,NULL,'Extrato','../modulo_FIN_EXTRATO/Default.htm',NULL,NULL,9050,'Bullet.gif'),
 (916,500,NULL,'Títulos (por Entidade)','../modulo_FIN_TITULOS_ENT/default.asp',NULL,NULL,5035,'Bullet.gif'),
 (917,700,NULL,'Backlog','../modulo_PROJETO_BACKLOG/default.htm',NULL,NULL,7060,'Bullet.gif'),
 (918,100,NULL,'Upload de Arquivos','../athUploader.asp?var_file_prefix=false&var_dir=//upload//demo',NULL,NULL,1100,'Bullet.gif'),
 (919,600,NULL,'Enquete','../modulo_ENQUETE/Default.htm',NULL,NULL,6007,'Bullet.gif'),
 (920,200,NULL,'Importação Excel','../modulo_IMPORTACAO/ImportExcel.asp',NULL,NULL,2025,'Bullet.gif'),
 (921,900,NULL,'NF Report','../modulo_FIN_NFREPORT',NULL,NULL,9060,'Bullet.gif'),
 (922,200,NULL,'Importação Excel','../modulo_IMPORTACAO/ImportExcel.asp',NULL,NULL,2025,'Bullet.gif');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;


--
-- Definition of table `sys_menu_var`
--

DROP TABLE IF EXISTS `sys_menu_var`;
CREATE TABLE `sys_menu_var` (
  `COD_VAR` varchar(50) NOT NULL DEFAULT '',
  `VALOR` varchar(250) DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  PRIMARY KEY (`COD_VAR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sys_menu_var`
--

/*!40000 ALTER TABLE `sys_menu_var` DISABLE KEYS */;
INSERT INTO `sys_menu_var` (`COD_VAR`,`VALOR`,`ORDEM`) VALUES 
 ('DELAY','200',40),
 ('DOWN_BG','#515960',100),
 ('DOWN_TEXT','#D4EB8D',90),
 ('FONT_STYLE','font-family: Verdana, Tahoma, Arial,Trebuchet MS; font-size:9px; font-weight:bold; text-decoration:none;padding: 4px',110),
 ('HEIGHT','24',20),
 ('MAX_TOPITENS','12',0),
 ('OUT_BG','#38424E',80),
 ('OUT_TEXT','white',70),
 ('OVER_BG','#8D9499',60),
 ('OVER_TEXT','white',50),
 ('TYPE','horizontal',30),
 ('WIDTH','130',10);
/*!40000 ALTER TABLE `sys_menu_var` ENABLE KEYS */;


--
-- Definition of table `sys_mx`
--

DROP TABLE IF EXISTS `sys_mx`;
CREATE TABLE `sys_mx` (
  `COD_MX` int(10) NOT NULL AUTO_INCREMENT,
  `ROTULO` varchar(120) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `LINK` longtext,
  `TARGET` varchar(50) DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_MX`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sys_mx`
--

/*!40000 ALTER TABLE `sys_mx` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_mx` ENABLE KEYS */;


--
-- Definition of table `sys_mx_item`
--

DROP TABLE IF EXISTS `sys_mx_item`;
CREATE TABLE `sys_mx_item` (
  `COD_MX_ITEM` int(10) NOT NULL AUTO_INCREMENT,
  `COD_MX` int(10) DEFAULT NULL,
  `ROTULO` varchar(120) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `LINK` longtext,
  `TARGET` varchar(50) DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_MX_ITEM`),
  KEY `ID_APP` (`TARGET`),
  KEY `ParentID` (`COD_MX`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sys_mx_item`
--

/*!40000 ALTER TABLE `sys_mx_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_mx_item` ENABLE KEYS */;


--
-- Definition of table `sys_mx_item_sub`
--

DROP TABLE IF EXISTS `sys_mx_item_sub`;
CREATE TABLE `sys_mx_item_sub` (
  `COD_MX_ITEM_SUB` int(10) NOT NULL AUTO_INCREMENT,
  `COD_MX_ITEM` int(10) DEFAULT NULL,
  `COD_MX` int(10) DEFAULT NULL,
  `TIPO` varchar(120) DEFAULT NULL,
  `ROTULO` varchar(255) DEFAULT NULL,
  `DESCRICAO` varchar(50) DEFAULT NULL,
  `IMG` varchar(255) DEFAULT NULL,
  `LINK` longtext,
  `TARGET` varchar(50) DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_MX_ITEM_SUB`),
  KEY `ID_APP` (`TARGET`),
  KEY `ParentID` (`COD_MX`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sys_mx_item_sub`
--

/*!40000 ALTER TABLE `sys_mx_item_sub` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_mx_item_sub` ENABLE KEYS */;


--
-- Definition of table `sys_painel`
--

DROP TABLE IF EXISTS `sys_painel`;
CREATE TABLE `sys_painel` (
  `COD_PAINEL` int(10) NOT NULL AUTO_INCREMENT,
  `ROTULO` varchar(120) DEFAULT NULL,
  `DESCRICAO` varchar(250) DEFAULT NULL,
  `IMG` varchar(250) DEFAULT NULL,
  `LINK` varchar(250) DEFAULT NULL,
  `LINK_PARAM` varchar(250) DEFAULT NULL,
  `TARGET` varchar(250) DEFAULT NULL,
  `ORDEM` int(10) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `ID_USUARIO` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_PAINEL`)
) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sys_painel`
--

/*!40000 ALTER TABLE `sys_painel` DISABLE KEYS */;
INSERT INTO `sys_painel` (`COD_PAINEL`,`ROTULO`,`DESCRICAO`,`IMG`,`LINK`,`LINK_PARAM`,`TARGET`,`ORDEM`,`DT_INATIVO`,`ID_USUARIO`) VALUES 
 (1,'Capa/Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_PAINEL/principal.htm',NULL,'mainframe',10,'2007-03-23 00:00:00',NULL),
 (2,NULL,NULL,'ICO_VBOSS_02.gif','',NULL,'vbNucleo',20,'2007-01-12 09:21:23',NULL),
 (3,NULL,NULL,'ICO_VBOSS_03.gif','',NULL,'vbNucleo',30,'2007-01-12 09:21:23',NULL),
 (4,'Chat/Fórum',NULL,'ICO_VBOSS_04.gif','',NULL,'vbNucleo',40,'2007-01-12 09:21:23',NULL),
 (5,NULL,NULL,'ICO_VBOSS_05.gif','',NULL,'vbNucleo',50,'2007-01-12 09:21:23',NULL),
 (6,NULL,NULL,'ICO_VBOSS_06.gif','',NULL,'vbNucleo',60,'2007-01-12 09:21:23',NULL),
 (7,'Configurações',NULL,'ICO_VBOSS_07.gif','',NULL,'vbNucleo',70,'2007-01-12 09:21:23',NULL),
 (8,NULL,NULL,'ICO_VBOSS_08.gif','',NULL,'vbNucleo',80,'2007-01-12 09:21:23',NULL),
 (9,NULL,NULL,'ICO_VBOSS_09.gif','',NULL,'vbNucleo',90,'2007-01-12 09:21:23',NULL),
 (10,'DB Explorer',NULL,'ICO_VBOSS_10.gif','../modulo_DBManager/athDefault.asp',NULL,'vbNucleo',150,'2011-08-30 00:00:00','aless'),
 (11,NULL,NULL,'ICO_VBOSS_11.gif','',NULL,'vbNucleo',110,'2007-01-12 09:21:23',NULL),
 (12,'Processos',NULL,'ICO_VBOSS_12.gif','../modulo_PROCESSO/default.htm',NULL,'vbNucleo',20,NULL,'aless'),
 (13,NULL,NULL,'ICO_VBOSS_13.gif','',NULL,'vbNucleo',130,'2007-01-12 09:21:23',NULL),
 (14,NULL,NULL,'ICO_VBOSS_14.gif','',NULL,'vbNucleo',140,'2007-01-12 09:21:23',NULL),
 (15,NULL,NULL,'ICO_VBOSS_15.gif','',NULL,'vbNucleo',150,'2007-01-12 09:21:23',NULL),
 (16,NULL,NULL,'ICO_VBOSS_16.gif','',NULL,'vbNucleo',160,'2007-01-12 09:21:23',NULL),
 (17,NULL,NULL,'ICO_VBOSS_17.gif','',NULL,'vbNucleo',170,'2007-01-12 09:21:23',NULL),
 (18,NULL,NULL,'ICO_VBOSS_18.gif','',NULL,'vbNucleo',180,'2007-01-12 09:21:23',NULL),
 (19,NULL,NULL,'ICO_VBOSS_19.gif','',NULL,'vbNucleo',190,'2007-01-12 09:21:23',NULL),
 (20,NULL,NULL,'ICO_VBOSS_20.gif','',NULL,'vbNucleo',200,'2007-01-12 09:21:23',NULL),
 (21,'Relatórios',NULL,'ICO_VBOSS_21.gif','',NULL,'vbNucleo',210,'2007-01-12 09:21:23',NULL),
 (22,'Pagamentos',NULL,'ICO_VBOSS_22.gif','',NULL,'vbNucleo',220,'2007-01-12 09:21:23',NULL),
 (23,'Notas Fiscais',NULL,'ICO_VBOSS_23.gif','',NULL,'vbNucleo',230,'2007-01-12 09:21:23',NULL),
 (24,NULL,NULL,'ICO_VBOSS_24.gif','',NULL,'vbNucleo',240,'2007-01-12 09:21:23',NULL),
 (25,'Contatos',NULL,'ICO_VBOSS_25.gif','',NULL,'vbNucleo',250,'2007-01-12 09:21:23',NULL),
 (27,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',10,NULL,'aless'),
 (28,'Webmail Athenas',NULL,'ICO_VBOSS_06.gif','http://webmail.athenas.com.br',NULL,'vbNucleo',250,'2011-08-30 00:00:00','aless'),
 (31,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',20,'2007-08-17 00:00:00','dennis'),
 (33,'DB Explorer',NULL,'ICO_VBOSS_10.gif','../modulo_DBManager/athDefault.asp',NULL,'vbNucleo',40,NULL,'dennis'),
 (34,'Webmail Athenas',NULL,'ICO_VBOSS_06.gif','http://webmail.athenas.com.br',NULL,'vbNucleo',80,NULL,'dennis'),
 (35,'Ponto',NULL,'ICO_VBOSS_24.gif','JavaScript:	window.open(\'../modulo_PONTO/INS_UPD.ASP\',\'Ponto\',\'width=357, height=370, left=30, top=30, scrollbars=0, status=0\');',NULL,'vbmainFrame',5,NULL,'dennis'),
 (36,'Processos',NULL,'ICO_VBOSS_11.gif','../modulo_PROCESSO/default.htm',NULL,'vbNucleo',10,NULL,'clvsutil'),
 (37,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',50,NULL,NULL),
 (38,'Processos',NULL,'ICO_VBOSS_12.gif','../modulo_PROCESSO/default.htm',NULL,'vbNucleo',100,NULL,NULL),
 (39,'DB Explorer',NULL,'ICO_VBOSS_10.gif','../modulo_DBManager/athDefault.asp',NULL,'vbmainFrame',150,NULL,NULL),
 (40,'Chat/Fórum',NULL,'ICO_VBOSS_04.gif',NULL,NULL,'vbNucleo',40,NULL,NULL),
 (44,'Chat/Fórum',NULL,'ICO_VBOSS_04.gif',NULL,NULL,'vbNucleo',80,'2007-05-18 00:00:00','dennis'),
 (45,'Webmail Athenas',NULL,'ICO_VBOSS_06.gif','http://webmail.athenas.com.br',NULL,'vbNucleo',250,NULL,'kiko'),
 (46,'Processos',NULL,'ICO_VBOSS_12.gif','../modulo_PROCESSO/default.htm',NULL,'vbNucleo',100,NULL,'kiko'),
 (48,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',10,NULL,'kiko'),
 (49,'Account Services',NULL,'ICO_VBOSS_11.gif','../modulo_ACCOUNT/default.htm',NULL,'vbNucleo',200,NULL,'kiko'),
 (53,'DB Explorer',NULL,'ICO_VBOSS_10.gif','../modulo_DBManager/athDefault.asp',NULL,'vbmainFrame',150,NULL,'tatiana'),
 (54,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',50,NULL,'tatiana'),
 (56,'Webmail Athenas',NULL,'ICO_VBOSS_06.gif','http://webmail.athenas.com.br',NULL,'vbNucleo',250,NULL,'neto'),
 (57,'Processos',NULL,'ICO_VBOSS_12.gif','../modulo_PROCESSO/default.htm',NULL,'vbNucleo',100,NULL,'neto'),
 (58,'DB Explorer',NULL,'ICO_VBOSS_10.gif','../modulo_DBManager/athDefault.asp',NULL,'vbmainFrame',150,NULL,'neto'),
 (59,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',50,NULL,'neto'),
 (60,'Account Services',NULL,'ICO_VBOSS_11.gif','../modulo_ACCOUNT/default.htm',NULL,'vbNucleo',200,NULL,'neto'),
 (62,'Webmail Athenas',NULL,'ICO_VBOSS_06.gif','http://webmail.athenas.com.br',NULL,'vbNucleo',250,NULL,'mauro'),
 (63,'Processos',NULL,'ICO_VBOSS_12.gif','../modulo_PROCESSO/default.htm',NULL,'vbNucleo',100,NULL,'mauro'),
 (64,'DB Explorer',NULL,'ICO_VBOSS_10.gif','../modulo_DBManager/athDefault.asp',NULL,'vbmainFrame',150,NULL,'mauro'),
 (65,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',50,NULL,'mauro'),
 (66,'Account Services',NULL,'ICO_VBOSS_11.gif','../modulo_ACCOUNT/default.htm',NULL,'vbNucleo',200,NULL,'mauro'),
 (67,'Yahoo Mail',NULL,'ICO_VBOSS_06.gif','http://www.yahoo.com.br/mail',NULL,'_blank',300,NULL,'clvsutil'),
 (68,'Finanças',NULL,'ICO_VBOSS_22.gif','../modulo_FIN_PAINEL/default.htm',NULL,'vbNucleo',30,NULL,'clvsutil'),
 (69,'DB Explorer',NULL,'ICO_VBOSS_10.gif','../modulo_DBManager/athDefault.asp',NULL,'vbmainFrame',200,NULL,'clvsutil'),
 (70,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',20,NULL,'clvsutil'),
 (71,'Account Services',NULL,'ICO_VBOSS_03.gif','../modulo_ACCOUNT/default.htm',NULL,'vbNucleo',40,NULL,'clvsutil'),
 (72,'Webmail Athenas',NULL,'ICO_VBOSS_06.gif','http://webmail.athenas.com.br',NULL,'vbNucleo',250,NULL,'alan'),
 (73,'Processos',NULL,'ICO_VBOSS_12.gif','../modulo_PROCESSO/default.htm',NULL,'vbNucleo',100,NULL,'alan'),
 (74,'DB Explorer',NULL,'ICO_VBOSS_10.gif','../modulo_DBManager/athDefault.asp',NULL,'vbmainFrame',150,NULL,'alan'),
 (75,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',50,NULL,'alan'),
 (76,'Account Services',NULL,'ICO_VBOSS_11.gif','../modulo_ACCOUNT/default.htm',NULL,'vbNucleo',200,NULL,'alan'),
 (79,'Finanças',NULL,'ICO_VBOSS_22.gif','../modulo_FIN_PAINEL/default.htm',NULL,'vbNucleo',20,NULL,'[Selecione]'),
 (80,'DB Schema',NULL,'ICO_VBOSS_07.gif','../modulo_DBSchema/dbadmin.asp',NULL,'vbmainFrame',210,NULL,'clvsutil'),
 (82,'Processos',NULL,'ICO_VBOSS_11.gif','../modulo_PROCESSO/default.htm',NULL,'vbNucleo',210,NULL,'clvborges'),
 (83,'Mensagens',NULL,'ICO_VBOSS_06.gif','../modulo_MSG/default.htm',NULL,'vbNucleo',240,NULL,'clvborges'),
 (84,'Finanças',NULL,'ICO_VBOSS_22.gif','../modulo_FIN_PAINEL/default.htm',NULL,'vbNucleo',200,NULL,'clvborges'),
 (85,'DB Explorer',NULL,'ICO_VBOSS_10.gif','../modulo_DBManager/athDefault.asp',NULL,'vbmainFrame',100,NULL,'clvborges'),
 (86,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',230,NULL,'clvborges'),
 (87,'Account Services',NULL,'ICO_VBOSS_03.gif','../modulo_ACCOUNT/default.htm',NULL,'vbNucleo',220,NULL,'clvborges'),
 (88,'DB Schema',NULL,'ICO_VBOSS_07.gif','../modulo_DBSchema/dbadmin.asp',NULL,'vbmainFrame',110,NULL,'clvborges'),
 (94,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'_athenas'),
 (95,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'_admin'),
 (97,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'mauro'),
 (98,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'kiko'),
 (99,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'tamyres'),
 (100,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'neto'),
 (101,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'luciano'),
 (102,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'rodrigo'),
 (103,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'alan'),
 (105,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'clvsutil'),
 (106,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'ezequiel'),
 (107,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'dennis'),
 (108,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'clvborges'),
 (109,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'rmatos'),
 (110,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'madison'),
 (111,'Agenda','Agenda','ICO_VBOSS_01.gif','../modulo_AGENDA/Default.htm',NULL,'vbNucleo',10,NULL,'_athenas'),
 (112,'Agenda','Agenda','ICO_VBOSS_01.gif','../modulo_AGENDA/Default.htm',NULL,'vbNucleo',10,NULL,'_admin'),
 (113,'Agenda','Agenda','ICO_VBOSS_01.gif','../modulo_AGENDA/Default.htm',NULL,'vbNucleo',10,NULL,'tamyres'),
 (114,'Agenda','Agenda','ICO_VBOSS_01.gif','../modulo_AGENDA/Default.htm',NULL,'vbNucleo',10,NULL,'luciano'),
 (115,'Agenda','Agenda','ICO_VBOSS_01.gif','../modulo_AGENDA/Default.htm',NULL,'vbNucleo',10,NULL,'rodrigo'),
 (116,'Agenda','Agenda','ICO_VBOSS_01.gif','../modulo_AGENDA/Default.htm',NULL,'vbNucleo',10,NULL,'ezequiel'),
 (117,'Agenda','Agenda','ICO_VBOSS_01.gif','../modulo_AGENDA/Default.htm',NULL,'vbNucleo',10,NULL,'rmatos'),
 (118,'Agenda','Agenda','ICO_VBOSS_01.gif','../modulo_AGENDA/Default.htm',NULL,'vbNucleo',10,NULL,'madison'),
 (119,'Painel Financeiro',NULL,'ICO_VBOSS_14.gif','../modulo_FIN_PAINEL/default.htm',NULL,'vbmainFrame',5,NULL,'tatiana'),
 (120,'Account Services',NULL,'ICO_VBOSS_11.gif','../modulo_ACCOUNT/default.htm',NULL,'vbNucleo',200,NULL,'Alessandro'),
 (121,'Account Services',NULL,'ICO_VBOSS_11.gif','../modulo_ACCOUNT/default.htm',NULL,'vbNucleo',200,NULL,'tatiana'),
 (122,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'Alessandro'),
 (125,'Tarefas','Tarefas','ICO_VBOSS_08.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',100,NULL,'tatiana'),
 (126,'Ponto',NULL,'ICO_VBOSS_01.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'fabiano'),
 (127,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'roberta'),
 (128,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'leonardo'),
 (129,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'gabriel'),
 (130,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'adriano'),
 (131,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'tiago'),
 (132,'Ponto','Registro Ponto','ICO_VBOSS_18.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'raissa'),
 (133,'Ponto','Registro Ponto','ICO_VBOSS_18.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'everton'),
 (134,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'mauricio'),
 (135,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'alexandre'),
 (136,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'edipo'),
 (137,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'lu'),
 (138,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'mateus'),
 (139,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'rafael'),
 (140,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'glauber'),
 (141,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'william'),
 (142,'Ponto',NULL,'ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'leandro'),
 (144,'Financeiro',NULL,'ICO_VBOSS_22.gif','../modulo_FIN_PAINEL/default.htm',NULL,'vbNucleo',50,NULL,'mauro'),
 (145,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',20,NULL,'leandro'),
 (147,'Tarefas',NULL,'ICO_VBOSS_30.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',250,NULL,'clvborges'),
 (148,'Ponto',NULL,'ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'marcio'),
 (149,'teste','teste','ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm','teste','vbNucleo',1,NULL,'glauber'),
 (150,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',2,NULL,'raissa'),
 (151,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',2,NULL,'alexandre'),
 (152,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',2,NULL,'edipo'),
 (153,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',2,NULL,'everton'),
 (154,'Ponto',NULL,'ICO_VBOSS_17.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'larissa'),
 (155,'Painel Financeiro',NULL,'ICO_VBOSS_14.gif','../modulo_FIN_PAINEL/default.htm',NULL,'vbNucleo',20,NULL,'larissa'),
 (156,'Fluxo de Caixa',NULL,'ICO_VBOSS_20.gif','http://www.virtualboss.com.br/virtualboss/modulo_FIN_FLUXOCAIXA/default.htm',NULL,'vbmainFrame',30,NULL,'larissa'),
 (157,'Inserir Previsão',NULL,'ICO_VBOSS_10.gif','http://www.virtualboss.com.br/virtualboss/modulo_FIN_TITULOS/default.asp',NULL,'vbmainFrame',10,NULL,'larissa'),
 (158,'Nota Fiscal',NULL,'ICO_VBOSS_23.gif','http://www.virtualboss.com.br/virtualboss/modulo_FIN_NF/default.htm',NULL,'vbmainFrame',40,NULL,'larissa'),
 (159,'Lançamentos',NULL,'ICO_VBOSS_22.gif','http://www.virtualboss.com.br/virtualboss/modulo_FIN_LCTOCONTA/default.htm',NULL,'vbmainFrame',20,NULL,'larissa'),
 (160,'FORNECEDORES','FORNECEDORES','ICO_VBOSS_07.gif','../modulo_FORNECEDOR/default.htm',NULL,'vbNucleo',70,NULL,'larissa'),
 (161,'Ponto','Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'portela'),
 (162,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'tatiana'),
 (163,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'fabiana'),
 (164,'Agenda','Agenda','ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',20,NULL,'fabiana'),
 (165,'Tarefas','Tarefas','ICO_VBOSS_08.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',30,NULL,'fabiana'),
 (167,'Bater ponto',NULL,'ICO_VBOSS_29.gif','../modulo_PONTO/INS_UPD.ASP',NULL,'_blank',1,NULL,'portela'),
 (168,'Ponto','Registro Ponto','ICO_VBOSS_17.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'achutti'),
 (169,'Tarefas','Tarefas','ICO_VBOSS_08.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',20,NULL,'achutti'),
 (170,'Ponto','Registro Ponto','ICO_VBOSS_17.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'aloisio'),
 (171,'Tarefas','Tarefas','ICO_VBOSS_08.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',20,NULL,'aloisio'),
 (172,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'cleverson'),
 (173,'DB Explorer',NULL,'ICO_VBOSS_10.gif','../modulo_DBManager/athDefault.asp',NULL,'vbmainFrame',100,NULL,'cleverson'),
 (174,'DB Schema',NULL,'ICO_VBOSS_07.gif','../modulo_DBSchema/dbadmin.asp',NULL,'vbmainFrame',110,NULL,'cleverson'),
 (175,'Finanças',NULL,'ICO_VBOSS_22.gif','../modulo_FIN_PAINEL/default.htm',NULL,'vbNucleo',200,NULL,'cleverson'),
 (176,'Processos',NULL,'ICO_VBOSS_11.gif','../modulo_PROCESSO/default.htm',NULL,'vbNucleo',210,NULL,'cleverson'),
 (177,'Account Services',NULL,'ICO_VBOSS_03.gif','../modulo_ACCOUNT/default.htm',NULL,'vbNucleo',220,NULL,'cleverson'),
 (178,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',230,NULL,'cleverson'),
 (179,'Mensagens',NULL,'ICO_VBOSS_06.gif','../modulo_MSG/default.htm',NULL,'vbNucleo',240,NULL,'cleverson'),
 (180,'Tarefas',NULL,'ICO_VBOSS_30.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',310,NULL,'cleverson'),
 (183,'PONTO',NULL,'ICO_VBOSS_11.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'analet'),
 (184,'PONTO',NULL,'ICO_VBOSS_11.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'ingrid'),
 (185,'Tarefas','Tarefas','ICO_VBOSS_20.gif','../modulo_TODOLIST/insert.asp',NULL,'_blank',3,NULL,'portela'),
 (187,'Ponto',NULL,'ICO_VBOSS_11.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'barbara'),
 (188,'Atividades',NULL,'ICO_VBOSS_29.gif','../modulo_BS/default.htm',NULL,'vbNucleo',300,NULL,'cleverson'),
 (189,'Tarefas',NULL,'ICO_VBOSS_08.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',20,NULL,'barbara'),
 (190,'Ponto',NULL,'ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'andre'),
 (191,'Ponto',NULL,'ICO_VBOSS_11.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'thais'),
 (193,'ATIVIDADES',NULL,'ICO_VBOSS_30.gif','../modulo_BS/default.htm',NULL,'vbNucleo',3,NULL,'raissa'),
 (196,'pfSense','Firewall','ICO_VBOSS_11.gif','http://10.1.20.1/',NULL,'vbNucleo',1000,NULL,'kiko'),
 (197,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'vinicius'),
 (198,'Chamados',NULL,'ICO_VBOSS_26.gif','../modulo_CHAMADO/default.htm',NULL,'vbNucleo',250,NULL,'cleverson'),
 (199,'Painel Financeiro','Painel Financeiro','ICO_VBOSS_22.gif','../modulo_FIN_PAINEL/default.htm',NULL,'vbNucleo',20,NULL,'kiko'),
 (200,'Mensagens',NULL,'ICO_VBOSS_06.gif','../modulo_MSG/default.htm',NULL,'vbNucleo',10,NULL,'clvsutil_gaucha'),
 (201,'Chamados',NULL,'ICO_VBOSS_26.gif','../modulo_CHAMADO/default.htm',NULL,'vbNucleo',20,NULL,'clvsutil_gaucha'),
 (202,'Inserir',NULL,'ICO_VBOSS_13.gif','../modulo_CHAMADO/Insert.asp',NULL,'vbNucleo',30,NULL,'clvsutil_gaucha'),
 (205,'NF/Recibo','NF/Recibo','ICO_VBOSS_23.gif','../modulo_FIN_NF/default.htm',NULL,'vbNucleo',30,NULL,'kiko'),
 (206,'Tarefas','Tarefas','ICO_VBOSS_12.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',30,NULL,'thais'),
 (207,'Colaboradores','Colaboradores','ICO_VBOSS_04.gif','../modulo_COLABORADOR/Default.htm',NULL,'vbNucleo',35,NULL,'thais'),
 (208,'Fornecedores','Fornecedores','ICO_VBOSS_20.gif','../modulo_FORNECEDOR/default.htm',NULL,'vbNucleo',25,NULL,'thais'),
 (209,'Account Services','Account Services','ICO_VBOSS_03.gif','../modulo_ACCOUNT/default.htm',NULL,'vbNucleo',15,NULL,'thais'),
 (210,'Cliente','Cliente','ICO_VBOSS_07.gif','../modulo_CLIENTE/default.htm',NULL,'vbNucleo',35,NULL,'thais'),
 (211,'Ponto','Ponto','ICO_VBOSS_17.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'gabriel'),
 (212,'Colaboradores','Colaboradores','ICO_VBOSS_21.gif','../modulo_COLABORADOR/default.htm',NULL,'vbNucleo',40,NULL,'kiko'),
 (215,'ATIVIDADES','ATIVIDADES','ICO_VBOSS_30.gif','../modulo_BS/default.htm',NULL,'vbNucleo',3,NULL,'rodrigo'),
 (217,'Tarefas','Tarefas','ICO_VBOSS_08.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',30,NULL,'leonardo'),
 (218,'Atividades','Atividades','ICO_VBOSS_20.gif','../modulo_BS/default.htm',NULL,'vbNucleo',40,NULL,'leonardo'),
 (220,'Atividades','atividades','ICO_VBOSS_29.gif','../modulo_BS/default.htm',NULL,'vbNucleo',125,NULL,'tatiana'),
 (221,'Chat/Fórum',NULL,'ICO_VBOSS_04.gif',NULL,NULL,'vbNucleo',40,NULL,'gabriel'),
 (222,'Processos',NULL,'ICO_VBOSS_12.gif','../modulo_PROCESSO/default.htm',NULL,'vbNucleo',100,NULL,'gabriel'),
 (223,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',50,NULL,'gabriel'),
 (224,'Mensagens','Mensagens','ICO_VBOSS_06.gif','../modulo_MSG/default.htm',NULL,'vbNucleo',100,NULL,'gabriel'),
 (225,'Ponto','Registro de horários','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'lumertz'),
 (226,'Chat/Fórum',NULL,'ICO_VBOSS_04.gif',NULL,NULL,'vbNucleo',40,NULL,NULL),
 (227,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',50,NULL,NULL),
 (228,'Ponto','Ponto','ICO_VBOSS_03.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'gabriel'),
 (230,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'achutti'),
 (231,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'alan'),
 (232,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'aloisio'),
 (233,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'andre'),
 (234,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'barbara'),
 (235,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'cleverson'),
 (236,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'everton'),
 (237,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'ezequiel'),
 (238,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'fabiana'),
 (239,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'fabiano'),
 (240,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'gabriel'),
 (241,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'ingrid'),
 (242,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'kiko'),
 (243,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'leandro'),
 (244,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'leonardo'),
 (245,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'lumertz'),
 (246,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'mauro'),
 (247,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'neto'),
 (248,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'raissa'),
 (249,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'rodrigo'),
 (250,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'tatiana'),
 (251,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'thais'),
 (252,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'vinicius'),
 (255,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'eduardo'),
 (256,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',50,NULL,'eduardo'),
 (257,'Tarefas','Tarefas','ICO_VBOSS_08.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',100,NULL,'eduardo'),
 (258,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'rita'),
 (259,'Agenda',NULL,'ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',10,NULL,'rita'),
 (260,'NF/Recibo','NF/Recibo','ICO_VBOSS_23.gif','../modulo_FIN_NF/default.htm',NULL,'vbNucleo',30,NULL,'rita'),
 (261,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'rita'),
 (262,'UPLOADS','para exibição dos uploads feitos... (modificar depois, pois é uma brecha de segurança)','ICO_VBOSS_07.gif','http://www.virtualboss.com.br/virtualboss/upload/default.asp',NULL,'vbMainFrame',5000,NULL,'aless'),
 (263,'UPLOADS','para podermso visualizar o material de uplod, logs, etc...','ICO_VBOSS_07.gif','http://www.virtualboss.com.br/virtualboss/upload/proevento/_log/',NULL,'vbNucleo',5000,NULL,'cleverson'),
 (265,'Processos',NULL,'ICO_VBOSS_11.gif','../modulo_PROCESSO/default.htm',NULL,'vbNucleo',10,NULL,'clvsutil'),
 (266,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'inara'),
 (267,'PONTO',NULL,'ICO_VBOSS_11.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'inara'),
 (268,'Atividades','Atividades','ICO_VBOSS_30.gif','../modulo_BS/default.htm',NULL,'vbNucleo',23,NULL,'aless'),
 (269,'Projetos','Projetos','ICO_VBOSS_29.gif','../modulo_PROJETO/default.htm',NULL,'vbNucleo',22,NULL,'aless'),
 (270,'Tarefas','Tarefas','ICO_VBOSS_28.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',24,NULL,'aless'),
 (271,'Material','Material gráfico da empresa','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'vbNucleo',10000,NULL,'rita'),
 (274,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'aless'),
 (279,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'aless'),
 (284,'pfSense',NULL,'ICO_VBOSS_11.gif','http://10.1.20.1/',NULL,'vbNucleo',1000,NULL,'aless'),
 (285,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'vargas'),
 (286,'Agenda','Agenda','ICO_VBOSS_01.gif','../modulo_AGENDA/Default.htm',NULL,'vbNucleo',10,NULL,'iluy'),
 (287,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'iluy'),
 (288,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',0,NULL,'iluy'),
 (289,'Agenda','Agenda','ICO_VBOSS_01.gif','../modulo_AGENDA/Default.htm',NULL,'vbNucleo',10,NULL,'vargas'),
 (290,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'vargas'),
 (291,'Tarefas','Tarefas','ICO_VBOSS_08.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',100,NULL,'ingrid'),
 (292,'Accounts PROEVENTO','Accounts','ICO_VBOSS_07.gif','../modulo_ACCOUNT/default.htm',NULL,'vbNucleo',10,NULL,'leonardo'),
 (293,'PONTO',NULL,'ICO_VBOSS_11.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'randi'),
 (294,'Tarefas','Tarefas','ICO_VBOSS_08.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',100,NULL,'randi'),
 (295,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'randi'),
 (296,'COMERCIAL','DOCUMENTO DE USO COMERCIAL FOLLOW_UP','ICO_VBOSS_20.gif','https://docs.google.com/spreadsheet/ccc?key=0Ap02owZblkqfdEVFdzJnaEFkYnpqeEFGNmtpSkhYWmc',NULL,'_blank',11,NULL,'fabiano'),
 (297,'Comercial','Follow_up','ICO_VBOSS_20.gif','https://docs.google.com/spreadsheet/ccc?key=0Ap02owZblkqfdEVFdzJnaEFkYnpqeEFGNmtpSkhYWmc',NULL,'_blank',11,NULL,'randi'),
 (298,'Follow-up Comercial','Follow-up Comercial','ICO_VBOSS_20.gif','https://docs.google.com/spreadsheet/ccc?key=0Ap02owZblkqfdEVFdzJnaEFkYnpqeEFGNmtpSkhYWmc',NULL,'vbNucleo',11,NULL,'rodrigo'),
 (300,'CONTROLE GERAL DE EVENTOS','CONTROLE GERAL DE EVENTOS','ICO_VBOSS_28.gif','https://docs.google.com/spreadsheet/ccc?key=0Ap02owZblkqfdDBTVnJhdlRicUZNc3c0ME1GVXZ1akE',NULL,'_blank',12,NULL,'fabiano'),
 (301,'Tabela Geral de Eventos','Tabela Geral de Eventos','ICO_VBOSS_28.gif','https://docs.google.com/spreadsheet/ccc?key=0Ap02owZblkqfdDBTVnJhdlRicUZNc3c0ME1GVXZ1akE',NULL,'vbNucleo',13,NULL,'rodrigo'),
 (302,'CONTAS PARTICULARES','TAREFAS_SANDUBA','ICO_VBOSS_14.gif','https://docs.google.com/spreadsheet/ccc?key=0AqrxOVYnqAuddEZIbGFjcG1WLVZlVG9HVGpXeWpiUEE#gid=0',NULL,'_blank',6000,NULL,'fabiano'),
 (303,'METAS','METAS','ICO_VBOSS_22.gif','https://docs.google.com/spreadsheet/ccc?key=0AqrxOVYnqAuddGlXUTRxR3dfRmNIam1nZW9JWldMNHc',NULL,'_blank',13,NULL,'fabiano'),
 (304,'Metas VISTA','Metas e objetivos pVISTA','ICO_VBOSS_22.gif','https://docs.google.com/spreadsheet/ccc?key=0AoPiKkJUYhfCdGtQTG1HVm1KYzQwc3IxbXVMVXNsbWc',NULL,'vbNucleo',70,NULL,'rodrigo'),
 (305,'Mapeamento Mercado Vista','Planilha do estudo de mercado do sistema Vista','ICO_VBOSS_14.gif','https://docs.google.com/spreadsheet/ccc?key=0Ap02owZblkqfdGR6VVh2N2RzU1FuZ19BZFo0OVpNSmc',NULL,'_blank',11,NULL,'randi'),
 (306,'Mercado VISTA','Mercado pVISTA/DW/VBAG','ICO_VBOSS_18.gif','https://docs.google.com/spreadsheet/ccc?key=0Ap02owZblkqfdGR6VVh2N2RzU1FuZ19BZFo0OVpNSmc',NULL,'vbNucleo',80,NULL,'rodrigo'),
 (307,'Ponto','ponto','ICO_VBOSS_27.gif',NULL,NULL,'vbNucleo',10,'2012-02-16 00:00:00','jonatas'),
 (308,'Ponto','ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'jonatas'),
 (309,'Tarefas','tarefas','ICO_VBOSS_28.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',20,NULL,'jonatas'),
 (310,'MERCADO VISTA','MERCADO VISTA','ICO_VBOSS_18.gif','https://docs.google.com/spreadsheet/ccc?key=0Ap02owZblkqfdGR6VVh2N2RzU1FuZ19BZFo0OVpNSmc',NULL,'_blank',30,NULL,'fabiano'),
 (311,'Coletores 2012','Coletores 2012','ICO_VBOSS_12.gif','https://docs.google.com/spreadsheet/ccc?key=0Ap02owZblkqfdFEyU0NGbm5qaHNZOTFOdGtoTVo5c3c',NULL,'vbNucleo',90,NULL,'rita'),
 (312,'Coletores 2012','Coletores 2012','ICO_VBOSS_12.gif','https://docs.google.com/spreadsheet/ccc?key=0Ap02owZblkqfdFEyU0NGbm5qaHNZOTFOdGtoTVo5c3c',NULL,'vbNucleo',80,NULL,'barbara'),
 (313,'Coletores 2012','Coletores 2012','ICO_VBOSS_12.gif','https://docs.google.com/spreadsheet/ccc?key=0Ap02owZblkqfdFEyU0NGbm5qaHNZOTFOdGtoTVo5c3c',NULL,'vbNucleo',90,NULL,'rodrigo'),
 (314,'Coletores 2012','Coletores 2012','ICO_VBOSS_20.gif','https://docs.google.com/spreadsheet/ccc?key=0Ap02owZblkqfdFEyU0NGbm5qaHNZOTFOdGtoTVo5c3c',NULL,'vbNucleo',80,NULL,'kiko'),
 (315,'AGENDA PARTICULAR','AGENDA PARTICULAR','ICO_VBOSS_11.gif','https://docs.google.com/spreadsheet/ccc?key=0AqrxOVYnqAuddHU3QWRraktwOUhvbThBcUI3T3pmOVE#gid=0',NULL,'_blank',5500,NULL,'fabiano'),
 (316,'Ponto',NULL,'ICO_VBOSS_11.gif','../modulo_PONTO/Default.htm',NULL,'vbNucleo',10,NULL,'cleisson'),
 (317,'Tarefas','Tarefas','ICO_VBOSS_12.gif','../modulo_TODOLIST/default.htm',NULL,'vbNucleo',30,NULL,'cleisson'),
 (318,'Material','Material Gráfico e Arquivos úteis','ICO_VBOSS_15.gif','http://www.athcsm4.com.br/gproevento/_material_grafico/',NULL,'_blank',5000,NULL,'cleisson'),
 (319,'Chamado','Chamado','ICO_VBOSS_04.gif','../modulo_CHAMADO/default.htm',NULL,'vbNucleo',50,NULL,'leonardo'),
 (322,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'_athenas'),
 (323,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'_admin'),
 (324,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'aless'),
 (325,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'mauro'),
 (326,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'kiko'),
 (327,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'tamyres'),
 (328,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'neto'),
 (329,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'luciano'),
 (330,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'rodrigo'),
 (331,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'alan'),
 (332,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'tatiana'),
 (333,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'clvsutil'),
 (334,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'ezequiel'),
 (335,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'dennis'),
 (336,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'clvborges'),
 (337,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'rmatos'),
 (338,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'madison'),
 (339,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'alessandro'),
 (340,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'roberta'),
 (341,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'leonardo'),
 (342,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'gabriel'),
 (343,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'fabiano'),
 (344,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'adriano'),
 (345,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'tiago'),
 (346,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'raissa'),
 (347,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'everton'),
 (348,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'mauricio'),
 (349,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'alexandre'),
 (350,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'edipo'),
 (351,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'lu'),
 (352,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'mateus'),
 (353,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'rafael'),
 (354,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'glauber'),
 (355,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'william'),
 (356,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'leandro'),
 (357,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'marcio'),
 (358,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'larissa'),
 (359,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'cleverson'),
 (360,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'portela'),
 (361,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'fabiana'),
 (362,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'achutti'),
 (363,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'aloisio'),
 (364,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'analet'),
 (365,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'ingrid'),
 (366,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'barbara'),
 (367,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'andre'),
 (368,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'vargas'),
 (369,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'thais'),
 (370,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'vinicius'),
 (371,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'lumertz'),
 (372,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'eduardo'),
 (373,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'barbara_od'),
 (374,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'fabiana_od'),
 (375,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'fabiano_od'),
 (376,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'ingrid_od'),
 (377,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'raissa_od'),
 (378,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'rita'),
 (379,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'inara'),
 (380,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'_athteste'),
 (381,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'iluy'),
 (382,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'randi'),
 (383,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'jonatas'),
 (384,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf',NULL,'vbMainFrame',10111,NULL,'cleisson'),
 (385,'MAT PROMOCIONAL','MATERIAL PROMOCIONAL','ICO_VBOSS_26.gif','https://docs.google.com/spreadsheet/ccc?key=0AoPiKkJUYhfCdDZSU05SX1l6R1lMWTlodU9nWnN4TkE   ',NULL,'vbNucleo',100,NULL,'rodrigo'),
 (386,'MAT PROMOCIONAL','MATERIAL PROMOCIONAL','ICO_VBOSS_26.gif','https://docs.google.com/spreadsheet/ccc?key=0AoPiKkJUYhfCdDZSU05SX1l6R1lMWTlodU9nWnN4TkE   ',NULL,'vbNucleo',100,NULL,'randi'),
 (387,'MAT PROMOCIONAL','MATERIAL PROMOCIONAL','ICO_VBOSS_26.gif','https://docs.google.com/spreadsheet/ccc?key=0AoPiKkJUYhfCdDZSU05SX1l6R1lMWTlodU9nWnN4TkE   ',NULL,'vbNucleo',100,NULL,'fabiano'),
 (388,'Atividades','Atividades','ICO_VBOSS_16.gif','../modulo_BS/default.htm',NULL,'vbNucleo',4,NULL,'jonatas'),
 (389,'Atividades','Atividades','ICO_VBOSS_07.gif','../modulo_BS/default.htm',NULL,'vbNucleo',1,NULL,'jonatas'),
 (390,'Agenda','Agenda','ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm',NULL,'vbNucleo',2,NULL,'leonardo'),
 (391,'Ponto','Registro Ponto','ICO_VBOSS_27.gif','../modulo_PONTO/Default.htm','','vbNucleo',0,NULL,'demo'),
 (392,'Agenda','','ICO_VBOSS_01.gif','../modulo_AGENDA/default.htm','','vbNucleo',10,NULL,'demo'),
 (393,'Processos','','ICO_VBOSS_12.gif','../modulo_PROCESSO/default.htm','','vbNucleo',20,NULL,'demo'),
 (394,'Projetos','Projetos','ICO_VBOSS_29.gif','../modulo_PROJETO/default.htm','','vbNucleo',22,NULL,'demo'),
 (395,'Atividades','Atividades','ICO_VBOSS_30.gif','../modulo_BS/default.htm','','vbNucleo',23,NULL,'demo'),
 (396,'Tarefas','Tarefas','ICO_VBOSS_28.gif','../modulo_TODOLIST/default.htm','','vbNucleo',24,NULL,'demo'),
 (400,'CRONOGRAMA EVENTOS','Cronograma de Eventos','ICO_VBOSS_24.gif','http://virtualboss.proevento.com.br/virtualboss/upload/PROEVENTO/AGENDA_EVENTOS_TECNICOS.pdf','','vbMainFrame',10111,NULL,'demo');
/*!40000 ALTER TABLE `sys_painel` ENABLE KEYS */;


--
-- Definition of table `tl_anexo`
--

DROP TABLE IF EXISTS `tl_anexo`;
CREATE TABLE `tl_anexo` (
  `COD_ANEXO` int(10) NOT NULL AUTO_INCREMENT,
  `COD_TODOLIST` int(10) DEFAULT NULL,
  `ARQUIVO` varchar(250) DEFAULT NULL,
  `DESCRICAO` longtext,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_ANEXO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_anexo`
--

/*!40000 ALTER TABLE `tl_anexo` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_anexo` ENABLE KEYS */;


--
-- Definition of table `tl_categoria`
--

DROP TABLE IF EXISTS `tl_categoria`;
CREATE TABLE `tl_categoria` (
  `COD_CATEGORIA` int(10) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(50) DEFAULT NULL,
  `DESCRICAO` varchar(255) DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_CATEGORIA`),
  KEY `DT_INATIVO` (`DT_INATIVO`),
  KEY `NOME` (`NOME`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_categoria`
--

/*!40000 ALTER TABLE `tl_categoria` DISABLE KEYS */;
INSERT INTO `tl_categoria` (`COD_CATEGORIA`,`NOME`,`DESCRICAO`,`DT_INATIVO`) VALUES 
 (1,'Contrato',NULL,NULL),
 (2,'Proposta',NULL,NULL),
 (3,'Geral',NULL,NULL),
 (4,'Admin',NULL,NULL),
 (5,'Financeiro',NULL,NULL),
 (15,'Contato',NULL,NULL),
 (16,'Pessoal',NULL,NULL),
 (19,'Consultoria',NULL,NULL),
 (20,'Design',NULL,NULL),
 (21,'Site',NULL,NULL),
 (22,'Sistema',NULL,NULL),
 (23,'Suporte',NULL,NULL),
 (25,'Conselho',NULL,NULL),
 (26,'Treinamento',NULL,NULL),
 (27,'Pesquisa',NULL,NULL),
 (28,'Chamado',NULL,NULL),
 (29,'RH',NULL,NULL);
/*!40000 ALTER TABLE `tl_categoria` ENABLE KEYS */;


--
-- Definition of table `tl_resposta`
--

DROP TABLE IF EXISTS `tl_resposta`;
CREATE TABLE `tl_resposta` (
  `COD_TL_RESPOSTA` int(10) NOT NULL AUTO_INCREMENT,
  `COD_TODOLIST` int(10) DEFAULT NULL,
  `ID_FROM` varchar(50) DEFAULT NULL,
  `ID_TO` varchar(50) DEFAULT NULL,
  `RESPOSTA` longtext,
  `SIGILOSO` longtext,
  `HORAS` double(15,5) DEFAULT NULL,
  `DTT_RESPOSTA` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `COD_ANTIGO` int(10) DEFAULT NULL,
  `ARQUIVO_ANEXO` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`COD_TL_RESPOSTA`),
  KEY `ID_SENDTO` (`ID_TO`),
  KEY `ID_USUARIO` (`ID_FROM`),
  KEY `TL_RESPOSTACOD_TODOLIST` (`COD_TODOLIST`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_resposta`
--

/*!40000 ALTER TABLE `tl_resposta` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_resposta` ENABLE KEYS */;


--
-- Definition of table `tl_todolist`
--

DROP TABLE IF EXISTS `tl_todolist`;
CREATE TABLE `tl_todolist` (
  `COD_TODOLIST` int(10) NOT NULL AUTO_INCREMENT,
  `COD_BOLETIM` int(10) DEFAULT NULL,
  `COD_CLI` int(10) DEFAULT NULL,
  `ID_RESPONSAVEL` varchar(50) DEFAULT NULL,
  `ID_ULT_EXECUTOR` varchar(50) DEFAULT NULL,
  `COD_CATEGORIA` int(10) DEFAULT NULL,
  `TITULO` varchar(250) DEFAULT NULL,
  `DESCRICAO` longtext,
  `SITUACAO` varchar(50) DEFAULT NULL,
  `PRIORIDADE` varchar(50) DEFAULT NULL,
  `PREV_HORAS` double(15,5) DEFAULT NULL,
  `PREV_DT_INI` datetime DEFAULT NULL,
  `PREV_DT_FIM` datetime DEFAULT NULL,
  `DT_REALIZADO` datetime DEFAULT NULL,
  `ARQUIVO_ANEXO` longtext,
  `SYS_DTT_INS` datetime DEFAULT NULL,
  `SYS_DTT_ALT` datetime DEFAULT NULL,
  `SYS_ID_USUARIO_INS` varchar(50) DEFAULT NULL,
  `SYS_EVALUATE` int(10) DEFAULT '0',
  `SYS_EVALUATE_OBS` longtext,
  `SYS_EVALUATE_ID_USUARIO` varchar(50) DEFAULT NULL,
  `PREV_HR_INI` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`COD_TODOLIST`),
  KEY `COD_BOLETIM` (`COD_BOLETIM`),
  KEY `DT_REALIZADO` (`DT_REALIZADO`),
  KEY `ID_ULT_EXECUTOR` (`ID_ULT_EXECUTOR`),
  KEY `ID_USUARIO` (`ID_RESPONSAVEL`),
  KEY `PREV_DT_FIM` (`PREV_DT_FIM`),
  KEY `PREV_DT_INI` (`PREV_DT_INI`),
  KEY `PRIORIDADE` (`PRIORIDADE`),
  KEY `SITUACAO` (`SITUACAO`),
  KEY `SYS_ID_USUARIO_INS` (`SYS_ID_USUARIO_INS`),
  KEY `TITULO` (`TITULO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_todolist`
--

/*!40000 ALTER TABLE `tl_todolist` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_todolist` ENABLE KEYS */;


--
-- Definition of table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario` (
  `COD_USUARIO` int(10) NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` varchar(50) DEFAULT NULL,
  `CODIGO` int(10) DEFAULT NULL,
  `TIPO` varchar(50) DEFAULT NULL,
  `NOME` varchar(50) DEFAULT NULL,
  `SENHA` varchar(250) DEFAULT NULL,
  `GRP_USER` varchar(250) DEFAULT NULL,
  `OBS` varchar(200) DEFAULT NULL,
  `EMAIL` varchar(255) DEFAULT NULL,
  `EMAIL_EXTRA` varchar(250) DEFAULT NULL,
  `DIR_DEFAULT` varchar(50) DEFAULT NULL,
  `FOTO` varchar(250) DEFAULT NULL,
  `DT_CRIACAO` datetime DEFAULT NULL,
  `DT_INATIVO` datetime DEFAULT NULL,
  `SYS_DT_ALT` datetime DEFAULT NULL,
  `SYS_USR_ALT` varchar(50) DEFAULT NULL,
  `APELIDO` varchar(50) DEFAULT NULL,
  `ENT_CLIENTE_REF` text,
  `LOGIN_FACEBOOK` varchar(50) DEFAULT NULL COMMENT 'E-mail ou ID do usuário no Facebook',
  `ID_USUARIO_MODELO` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`COD_USUARIO`),
  UNIQUE KEY `ID_USUARIO` (`ID_USUARIO`),
  KEY `CODIGO` (`CODIGO`),
  KEY `TIPO` (`TIPO`),
  KEY `ID_USUARIO_MODELO` (`ID_USUARIO_MODELO`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `usuario`
--

/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` (`COD_USUARIO`,`ID_USUARIO`,`CODIGO`,`TIPO`,`NOME`,`SENHA`,`GRP_USER`,`OBS`,`EMAIL`,`EMAIL_EXTRA`,`DIR_DEFAULT`,`FOTO`,`DT_CRIACAO`,`DT_INATIVO`,`SYS_DT_ALT`,`SYS_USR_ALT`,`APELIDO`,`ENT_CLIENTE_REF`,`LOGIN_FACEBOOK`,`ID_USUARIO_MODELO`) VALUES 
 (1,'_athenas',1,'ENT_COLABORADOR','Athenas Software & Systems','13b3b7b9413eb6c843a29a8fdae17934','SU','*Não trocar senha sem antes falar com ALESS*  !!!\r\nsenha - [masterdemo]','athaless@gmail.com',NULL,'','',NULL,NULL,'2016-04-12 10:52:29','demo','_athenas','','',''),
 (2,'demo',2,'ENT_COLABORADOR','ADMINISTRADOR','fe01ce2a7fbac8fafaed7c982a04e229','MANAGER','senha: demo','athaless@gmail.com',NULL,'','',NULL,NULL,'2016-10-04 10:59:27','demo','demo','3812;4887;4635;3843;4886;3747;16;4447;3806;3769;4978;3800;4667;4972;4704;4710;3807;3;3990;85;4937;4692;72;108;4685;4691;111;4819;3799;3844;4881;15;4709;3842;4815;3959;3958;3804','',''),
 (3,'aless',3,'ENT_COLABORADOR','Alessander Pires Oliveira','e509e2e25285a3703143986d1a923569','MANAGER','','demo@proevento.com.br',NULL,'','{11b163453b130951a2db852014b98fd3}_ALESS.png',NULL,NULL,'2014-02-07 12:49:13','demo','Mateus','','',NULL),
 (5,'gabriel',1,'ENT_COLABORADOR','Gabriel Schunck','99f77257642f55ddf07e06f01e6a5f7c','MANAGER','','gabriel.schunck@gmail.com',NULL,'','','2016-10-04 11:17:05',NULL,NULL,NULL,'gabriel',NULL,'','_athenas');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;


--
-- Definition of table `usuario_horario`
--

DROP TABLE IF EXISTS `usuario_horario`;
CREATE TABLE `usuario_horario` (
  `COD_HORARIO` int(10) NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` varchar(50) DEFAULT NULL,
  `DIA_SEMANA` varchar(50) DEFAULT NULL,
  `IN_1` varchar(8) DEFAULT NULL,
  `OUT_1` varchar(8) DEFAULT NULL,
  `IN_2` varchar(8) DEFAULT NULL,
  `OUT_2` varchar(8) DEFAULT NULL,
  `IN_3` varchar(8) DEFAULT NULL,
  `OUT_3` varchar(8) DEFAULT NULL,
  `IN_extra` varchar(8) DEFAULT NULL,
  `OUT_extra` varchar(8) DEFAULT NULL,
  `TOTAL` varchar(50) DEFAULT NULL,
  `COD_EMPRESA` varchar(50) DEFAULT NULL,
  `OBS` longtext,
  PRIMARY KEY (`COD_HORARIO`),
  KEY `DIA_SEMANA` (`DIA_SEMANA`),
  KEY `ID_USUARIO` (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `usuario_horario`
--

/*!40000 ALTER TABLE `usuario_horario` DISABLE KEYS */;
INSERT INTO `usuario_horario` (`COD_HORARIO`,`ID_USUARIO`,`DIA_SEMANA`,`IN_1`,`OUT_1`,`IN_2`,`OUT_2`,`IN_3`,`OUT_3`,`IN_extra`,`OUT_extra`,`TOTAL`,`COD_EMPRESA`,`OBS`) VALUES 
 (1,'demo','SEG','08:00:00','12:00:00','13:00:00','17:00:00',NULL,NULL,NULL,NULL,'08:00:00','DEMO',NULL),
 (2,'demo','TER','08:00:00','12:00:00','13:00:00','17:00:00',NULL,NULL,NULL,NULL,'08:00:00','DEMO',NULL),
 (3,'demo','QUA','08:00:00','12:00:00','13:00:00','17:00:00',NULL,NULL,NULL,NULL,'08:00:00','DEMO',NULL),
 (4,'demo','QUI','08:00:00','12:00:00','13:00:00','17:00:00',NULL,NULL,NULL,NULL,'08:00:00','DEMO',NULL),
 (5,'demo','SEX','08:00:00','12:00:00','13:00:00','17:00:00',NULL,NULL,NULL,NULL,'08:00:00','DEMO',NULL),
 (6,'aless','SEG','08:00:00','12:00:00','13:00:00','17:00:00',NULL,NULL,NULL,NULL,'08:00:00','DEMO',NULL),
 (7,'aless','TER','08:00:00','12:00:00','13:00:00','17:00:00',NULL,NULL,NULL,NULL,'08:00:00','DEMO',NULL),
 (8,'aless','QUA','08:00:00','12:00:00','13:00:00','17:00:00',NULL,NULL,NULL,NULL,'08:00:00','DEMO',NULL),
 (9,'aless','QUI','08:00:00','12:00:00','13:00:00','17:00:00',NULL,NULL,NULL,NULL,'08:00:00','DEMO',NULL),
 (10,'aless','SEX','08:00:00','12:00:00','13:00:00','17:00:00',NULL,NULL,NULL,NULL,'08:00:00','DEMO',NULL);
/*!40000 ALTER TABLE `usuario_horario` ENABLE KEYS */;


--
-- Definition of table `usuario_log`
--

DROP TABLE IF EXISTS `usuario_log`;
CREATE TABLE `usuario_log` (
  `COD_USUARIO_LOG` int(10) NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` varchar(20) DEFAULT NULL,
  `NUM_SESSAO` varchar(50) DEFAULT NULL,
  `DT_LOGIN` datetime DEFAULT NULL,
  `DT_LOGOUT` datetime DEFAULT NULL,
  `EXTRA` longtext,
  `DT_OCORRENCIA` datetime DEFAULT NULL,
  PRIMARY KEY (`COD_USUARIO_LOG`),
  KEY `ID_USER` (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `usuario_log`
--

/*!40000 ALTER TABLE `usuario_log` DISABLE KEYS */;
INSERT INTO `usuario_log` (`COD_USUARIO_LOG`,`ID_USUARIO`,`NUM_SESSAO`,`DT_LOGIN`,`DT_LOGOUT`,`EXTRA`,`DT_OCORRENCIA`) VALUES 
 (1,'demo','664278183','2016-04-12 10:45:32','2016-10-04 10:58:43','LOGIN / SYSTEM LOGOUT','2016-10-04 10:58:43'),
 (2,'demo','478846743','2016-10-04 10:58:43',NULL,'LOGIN','2016-10-04 10:58:43');
/*!40000 ALTER TABLE `usuario_log` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
