CREATE DATABASE  IF NOT EXISTS `gsb_frais` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `gsb_frais`;


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `utilisateur`
--

DROP TABLE IF EXISTS `utilisateur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `utilisateur` (
  `id` char(4) NOT NULL,
  `nom` char(30) DEFAULT NULL,
  `prenom` char(30) DEFAULT NULL,
  `login` char(20) DEFAULT NULL,
  `mdp` char(40) DEFAULT NULL,
  `adresse` char(30) DEFAULT NULL,
  `cp` char(5) DEFAULT NULL,
  `ville` char(30) DEFAULT NULL,
  `dateEmbauche` date DEFAULT NULL,
  `idType` char(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_type_idx` (`idType`),
  CONSTRAINT `fk_type` FOREIGN KEY (`idType`) REFERENCES `type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilisateur`
--

LOCK TABLES `utilisateur` WRITE;
/*!40000 ALTER TABLE `utilisateur` DISABLE KEYS */;
INSERT INTO `utilisateur` (`id`, `nom`, `prenom`, `login`, `mdp`, `adresse`, `cp`, `ville`, `dateEmbauche`, `idType`) VALUES ('a131','Villechalane','Louis','lvillachane','3abf9eb797afe468902101efe6b4b00f7d50802a','8 rue des Charmes','46000','Cahors','2005-12-21','C'),('a17','Andre','David','dandre','12e0b9be32932a8028b0ef0432a0a0a99421f745','1 rue Petit','46200','Lalbenque','1998-11-23','V'),('a55','Bedos','Christian','cbedos','a34b9dfadee33917a63c3cdebdc9526230611f0b','1 rue Peranud','46250','Montcuq','1995-01-12','V'),('a93','Tusseau','Louis','ltusseau','f1c1d39e9898f3202a2eaa3dc38ae61575cd77ad','22 rue des Ternes','46123','Gramat','2000-05-01','V'),('b13','Bentot','Pascal','pbentot','178e1efaf000fdf2267edc43fad2a65197a0ab10','11 allée des Cerises','46512','Bessines','1992-07-09','V'),('b16','Bioret','Luc','lbioret','ab7fa51f9bf8fde35d9e5bcc5066d3b71dda00d2','1 Avenue gambetta','46000','Cahors','1998-05-11','V'),('b19','Bunisset','Francis','fbunisset','aa710ca3a1f12234bc2872aa0a6f88d6cf896ae4','10 rue des Perles','93100','Montreuil','1987-10-21','V'),('b25','Bunisset','Denise','dbunisset','40ff56dc0525aa08de29eba96271997a91e7d405','23 rue Manin','75019','paris','2010-12-05','V'),('b28','Cacheux','Bernard','bcacheux','51a4fac4890def1ef8605f0b2e6554c86b2eb919','114 rue Blanche','75017','Paris','2009-11-12','V'),('b34','Cadic','Eric','ecadic','2ed5ee95d2588be3650a935ff7687dee46d70fc8','123 avenue de la République','75011','Paris','2008-09-23','V'),('b4','Charoze','Catherine','ccharoze','8b16cf71ab0842bd871bce99a1ba61dd7e9d4423','100 rue Petit','75019','Paris','2005-11-12','V'),('b50','Clepkens','Christophe','cclepkens','7ddda57eca7a823c85ac0441adf56928b47ece76','12 allée des Anges','93230','Romainville','2003-08-11','V'),('b59','Cottin','Vincenne','vcottin','2f95d1cac7b8e7459376bf36b93ae7333026282d','36 rue Des Roches','93100','Monteuil','2001-11-18','V'),('c14','Daburon','François','fdaburon','5c7cc4a7f0123460c29c84d8f8a73bc86184adbb','13 rue de Chanzy','94000','Créteil','2002-02-11','V'),('c3','De','Philippe','pde','03b03872dd570959311f4fb9be01788e4d1a2abf','13 rue Barthes','94000','Créteil','2010-12-14','V'),('c54','Debelle','Michel','mdebelle','1fa95c2fac5b14c6386b73cbe958b663fc66fdfa','181 avenue Barbusse','93210','Rosny','2006-11-23','V'),('d13','Debelle','Jeanne','jdebelle','18c2cad6adb7cee7884f70108cfd0a9b448be9be','134 allée des Joncs','44000','Nantes','2000-05-11','V'),('d51','Debroise','Michel','mdebroise','46b609fe3aaa708f5606469b5bc1c0fa85010d76','2 Bld Jourdain','44000','Nantes','2001-04-17','V'),('e22','Desmarquest','Nathalie','ndesmarquest','abc20ea01dabd079ddd63fd9006e7232e442973c','14 Place d Arc','45000','Orléans','2005-11-12','V'),('e24','Desnost','Pierre','pdesnost','8eaa8011ec8aa8baa63231a21d12f4138ccc1a3d','16 avenue des Cèdres','23200','Guéret','2001-02-05','V'),('e39','Dudouit','Frédéric','fdudouit','55072fa16c988da8f1fb31e40e4ac5f325ac145d','18 rue de l église','23120','GrandBourg','2000-08-01','V'),('e49','Duncombe','Claude','cduncombe','577576f0b2c56c43b596f701b782870c8742c592','19 rue de la tour','23100','La souteraine','1987-10-10','V'),('e5','Enault-Pascreau','Céline','cenault','cc0fb4115bb04c613fd1b95f4792fc44f07e9f4f','25 place de la gare','23200','Gueret','1995-09-01','V'),('e52','Eynde','Valérie','veynde','d06ace8d729693904c304625e6a6fab6ab9e9746','3 Grand Place','13015','Marseille','1999-11-01','V'),('f21','Finck','Jacques','jfinck','6d8b2060b60132d9bdb09d37913fbef637b295f2','10 avenue du Prado','13002','Marseille','2001-11-10','V'),('f39','Frémont','Fernande','ffremont','aa45efe9ecbf37db0089beeedea62ceb57db7f17','4 route de la mer','13012','Allauh','1998-10-01','V'),('f4','Gest','Alain','agest','1af7dedacbbe8ce324e316429a816daeff4c542f','30 avenue de la mer','13025','Berre','1985-11-01','V')('a1','th','jb','jb','d532dde6b3552d20b518f7494e33151c6cdf4218','193 Cours ','33000','Bordeaux','2013-04-01','V'),('a2','th','jb','assus','3abf9eb797afe468902101efe6b4b00f7d50802a','193 Cours ','33000','Bordeaux','2013-04-01','C');
/*!40000 ALTER TABLE `utilisateur` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

