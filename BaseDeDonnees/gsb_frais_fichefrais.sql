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
-- Table structure for table `fichefrais`
--

DROP TABLE IF EXISTS `fichefrais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fichefrais` (
  `idVisiteur` char(4) NOT NULL,
  `mois` char(6) NOT NULL,
  `nbJustificatifs` int(11) DEFAULT NULL,
  `montantValide` decimal(10,2) DEFAULT NULL,
  `dateModif` date DEFAULT NULL,
  `idEtat` char(2) DEFAULT 'CR',
  `idTypeVehicule` char(5) NOT NULL,
  PRIMARY KEY (`idVisiteur`,`mois`),
  KEY `idEtat` (`idEtat`),
  KEY `fk_typeVehicule_idx` (`idTypeVehicule`),
  CONSTRAINT `FicheFrais_ibfk_1` FOREIGN KEY (`idEtat`) REFERENCES `etat` (`id`),
  CONSTRAINT `FicheFrais_ibfk_2` FOREIGN KEY (`idVisiteur`) REFERENCES `utilisateur` (`id`),
  CONSTRAINT `fk_typeVehicule` FOREIGN KEY (`idTypeVehicule`) REFERENCES `typevehicule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fichefrais`
--

LOCK TABLES `fichefrais` WRITE;
/*!40000 ALTER TABLE `fichefrais` DISABLE KEYS */;
INSERT INTO `fichefrais` (`idVisiteur`, `mois`, `nbJustificatifs`, `montantValide`, `dateModif`, `idEtat`, `idTypeVehicule`) VALUES ('a131','201001',3,1768.48,'2010-03-04','RB','4cve'),('a131','201002',11,3046.96,'2010-04-02','RB','4cve'),('a131','201003',0,3599.50,'2010-05-03','RB','4cve'),('a131','201004',9,3790.96,'2010-06-06','RB','4cve'),('a131','201005',6,4604.58,'2010-07-03','RB','4cve'),('a131','201006',6,4076.46,'2010-08-01','RB','4cve'),('a131','201007',10,3328.84,'2010-09-04','RB','4cve'),('a131','201008',10,5154.58,'2010-10-03','RB','4cve'),('a131','201009',4,2911.54,'2010-11-05','RB','4cve'),('a131','201010',0,4783.82,'2010-12-07','RB','4cve'),('a131','201011',3,2731.04,'2011-01-05','RB','4cve'),('a131','201012',11,4492.06,'2011-02-04','RB','4cve'),('a131','201101',0,3341.98,'2011-03-03','RB','4cve'),('a131','201102',9,2136.42,'2011-04-06','RB','4cve'),('a131','201103',9,4581.48,'2011-05-08','RB','4cve'),('a131','201104',3,3537.02,'2011-06-04','RB','4cve'),('a131','201105',11,2936.66,'2011-07-01','RB','4cve'),('a131','201106',11,2955.12,'2011-08-01','RB','4cve'),('a131','201107',6,3655.40,'2011-09-06','RB','4cve'),('a131','201108',3,2690.22,'2011-10-04','RB','4cve'),('a131','201109',1,2756.82,'2011-11-06','RB','4cve'),('a131','201110',8,4883.06,'2011-12-08','RB','4cve'),('a131','201111',9,4738.18,'2012-01-02','RB','4cve'),('a131','201112',12,2922.90,'2012-02-06','RB','4cve'),('a131','201201',11,3085.84,'2012-03-07','RB','4cve'),('a131','201202',5,2675.86,'2012-04-07','RB','4cve'),('a131','201203',8,3437.44,'2012-05-06','RB','4cve'),('a131','201204',10,3216.44,'2012-06-04','RB','4cve'),('a131','201205',7,3187.10,'2012-07-04','RB','4cve'),('a131','201206',4,2946.14,'2012-08-07','RB','4cve'),('a131','201207',8,2538.94,'2012-09-03','RB','4cve'),('a131','201208',12,2635.22,'2012-10-08','RB','4cve'),('a131','201209',4,2622.84,'2012-11-08','RB','4cve'),('a131','201210',9,4384.66,'2012-12-02','RB','4cve'),('a131','201211',10,1793.92,'2012-12-04','RB','4cve'),('a131','201212',7,0.00,'2013-01-13','CL','56cvd'),('a131','201301',0,NULL,'2013-05-11','CL','56cvd'),('a131','201306',0,NULL,'2013-06-07','CL','4cvd'),('a17','201001',10,2677.06,'2010-03-02','RB','56cve'),('a17','201002',12,4203.04,'2010-04-05','RB','56cve'),('a17','201003',5,6038.76,'2010-05-07','RB','56cve'),('a17','201004',7,3234.22,'2010-06-01','RB','56cve'),('a17','201005',9,4550.90,'2010-07-03','RB','56cve'),('a17','201006',6,3430.90,'2010-08-05','RB','56cve'),('a17','201007',9,7036.84,'2010-09-06','RB','56cve'),('a17','201008',5,5142.82,'2010-10-02','RB','56cve'),('a17','201009',12,4510.46,'2010-11-05','RB','56cve'),('a17','201010',8,3593.62,'2010-12-03','RB','56cve'),('a17','201011',6,2183.40,'2011-01-01','RB','56cve'),('a17','201012',0,2110.66,'2011-02-06','RB','56cve'),('a17','201101',11,3147.64,'2011-03-01','RB','56cve'),('a17','201102',9,4143.20,'2011-04-07','RB','56cve'),('a17','201103',1,2953.44,'2011-05-05','RB','56cve'),('a17','201104',8,3389.98,'2011-06-06','RB','56cve'),('a17','201105',8,2439.30,'2011-07-02','RB','56cve'),('a17','201106',0,5167.64,'2011-08-05','RB','56cve'),('a17','201107',8,3999.10,'2011-09-02','RB','56cve'),('a17','201108',8,4509.54,'2011-10-04','RB','56cve'),('a17','201109',7,3604.20,'2011-11-02','RB','56cve'),('a17','201110',9,3609.56,'2011-12-06','RB','56cve'),('a17','201111',5,4421.86,'2012-01-03','RB','56cve'),('a17','201112',1,3116.58,'2012-02-02','RB','56cve'),('a17','201201',10,4916.58,'2012-03-02','RB','56cve'),('a17','201202',1,3937.72,'2012-04-04','RB','56cve'),('a17','201203',9,2636.48,'2012-05-01','RB','56cve'),('a17','201204',5,4992.48,'2012-06-03','RB','56cve'),('a17','201205',8,1860.82,'2012-07-05','RB','56cve'),('a17','201206',5,4993.76,'2012-08-02','RB','56cve'),('a17','201207',9,5313.34,'2012-09-08','RB','56cve'),('a17','201208',10,4663.24,'2012-10-08','RB','56cve'),('a17','201209',5,2540.92,'2012-11-05','RB','56cve'),('a17','201210',12,3108.24,'2012-12-08','RB','56cve'),('a17','201211',9,4024.71,'2013-06-08','RB','56cve'),('a17','201212',6,3794.01,'2013-06-08','RB','56cve'),('a17','201301',0,NULL,'2013-06-09','VA','56cvd'),('a17','201306',1,5631.56,'2013-06-09','CL','56cvd'),('a17','201307',0,NULL,'2013-06-09','CR','4cvd'),('a93','201306',0,0.00,'2013-06-09','CR','4cvd');
/*!40000 ALTER TABLE `fichefrais` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `gsb_frais`.`updateFiche`
BEFORE UPDATE ON `gsb_frais`.`fichefrais`
FOR EACH ROW
BEGIN
   /* Mettre a jour la somme a rembourser pour une fiche de frais a validee */
   IF NEW.idEtat = 'VA' THEN
      SET NEW.montantValide = calculerMontantValide(NEW.idVisiteur,NEW.mois);
   END IF;
   /* Passer l'etat a "Remboursée" pour une fiche de frais mise en paiement */
   IF NEW.idEtat = 'MP' THEN
      SET NEW.idEtat = 'RB';
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

