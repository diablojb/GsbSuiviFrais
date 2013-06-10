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
-- Table structure for table `lignefraishorsforfait`
--

DROP TABLE IF EXISTS `lignefraishorsforfait`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lignefraishorsforfait` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idVisiteur` char(4) NOT NULL,
  `mois` char(6) NOT NULL,
  `libelle` varchar(100) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `montant` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idVisiteur` (`idVisiteur`,`mois`),
  CONSTRAINT `LigneFraisHorsForfait_ibfk_1` FOREIGN KEY (`idVisiteur`, `mois`) REFERENCES `fichefrais` (`idVisiteur`, `mois`)
) ENGINE=InnoDB AUTO_INCREMENT=3550 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lignefraishorsforfait`
--

LOCK TABLES `lignefraishorsforfait` WRITE;
/*!40000 ALTER TABLE `lignefraishorsforfait` DISABLE KEYS */;
INSERT INTO `lignefraishorsforfait` (`id`, `idVisiteur`, `mois`, `libelle`, `date`, `montant`) VALUES (1,'a131','201001','location véhicule','2010-01-24',310.00),(2,'a131','201001','achat d\'espace publicitaire','2010-01-03',80.00),(3,'a131','201001','achat d\'espace publicitaire','2010-01-07',57.00),(4,'a131','201001','taxi','2010-01-19',22.00),(5,'a131','201001','achat d\'espace publicitaire','2010-01-01',133.00),(6,'a131','201002','location salle conférence','2010-02-20',352.00),(7,'a131','201003','location équipement vidéo/sonore','2010-03-03',659.00),(8,'a131','201003','frais vestimentaire/représentation','2010-03-04',100.00),(9,'a131','201003','traiteur, alimentation, boisson','2010-03-21',28.00),(10,'a131','201003','Voyage SNCF','2010-03-15',65.00),(11,'a131','201004','repas avec praticien','2010-04-15',41.00),(12,'a131','201004','location véhicule','2010-04-10',346.00),(13,'a131','201005','achat d\'espace publicitaire','2010-05-06',140.00),(14,'a131','201005','frais vestimentaire/représentation','2010-05-11',417.00),(15,'a131','201005','repas avec praticien','2010-05-08',30.00),(16,'a131','201005','Voyage SNCF','2010-05-01',71.00),(17,'a131','201006','achat de matériel de papèterie','2010-06-13',13.00),(18,'a131','201006','location équipement vidéo/sonore','2010-06-21',510.00),(19,'a131','201006','Voyage SNCF','2010-06-19',128.00),(20,'a131','201006','taxi','2010-06-16',59.00),(21,'a131','201007','achat de matériel de papèterie','2010-07-05',13.00),(22,'a131','201007','location équipement vidéo/sonore','2010-07-11',313.00),(23,'a131','201007','location salle conférence','2010-07-07',128.00),(24,'a131','201007','traiteur, alimentation, boisson','2010-07-08',203.00),(25,'a131','201007','frais vestimentaire/représentation','2010-07-01',177.00),(26,'a131','201008','location véhicule','2010-08-11',345.00),(27,'a131','201008','location véhicule','2010-08-11',430.00),(28,'a131','201008','taxi','2010-08-20',40.00),(29,'a131','201008','achat d\'espace publicitaire','2010-08-07',117.00),(30,'a131','201008','repas avec praticien','2010-08-20',33.00),(31,'a131','201008','frais vestimentaire/représentation','2010-08-01',262.00),(32,'a131','201009','taxi','2010-09-14',25.00),(33,'a131','201009','taxi','2010-09-05',49.00),(34,'a131','201010','location équipement vidéo/sonore','2010-10-20',513.00),(35,'a131','201010','repas avec praticien','2010-10-22',43.00),(36,'a131','201010','taxi','2010-10-27',73.00),(37,'a131','201010','frais vestimentaire/représentation','2010-10-19',320.00),(38,'a131','201011','Voyage SNCF','2010-11-15',97.00),(39,'a131','201011','traiteur, alimentation, boisson','2010-11-23',110.00),(40,'a131','201011','repas avec praticien','2010-11-13',45.00),(41,'a131','201011','location véhicule','2010-11-10',162.00),(42,'a131','201012','location équipement vidéo/sonore','2010-12-01',813.00),(43,'a131','201101','frais vestimentaire/représentation','2011-01-02',34.00),(44,'a131','201101','taxi','2011-01-04',41.00),(45,'a131','201101','achat de matériel de papèterie','2011-01-14',48.00),(46,'a131','201102','location salle conférence','2011-02-09',355.00),(47,'a131','201102','achat d\'espace publicitaire','2011-02-01',116.00),(48,'a131','201102','achat d\'espace publicitaire','2011-02-07',34.00),(49,'a131','201103','location salle conférence','2011-03-19',282.00),(50,'a131','201103','achat d\'espace publicitaire','2011-03-01',29.00),(51,'a131','201103','taxi','2011-03-09',32.00),(52,'a131','201103','location équipement vidéo/sonore','2011-03-16',599.00),(53,'a131','201104','location équipement vidéo/sonore','2011-04-06',224.00),(54,'a131','201104','location véhicule','2011-04-13',270.00),(55,'a131','201104','Voyage SNCF','2011-04-07',105.00),(56,'a131','201104','location équipement vidéo/sonore','2011-04-23',330.00),(57,'a131','201105','location équipement vidéo/sonore','2011-05-25',800.00),(58,'a131','201105','repas avec praticien','2011-05-07',46.00),(59,'a131','201105','location véhicule','2011-05-14',426.00),(60,'a131','201106','achat de matériel de papèterie','2011-06-01',12.00),(61,'a131','201106','location équipement vidéo/sonore','2011-06-01',662.00),(62,'a131','201106','achat de matériel de papèterie','2011-06-04',16.00),(63,'a131','201106','frais vestimentaire/représentation','2011-06-17',95.00),(64,'a131','201107','location salle conférence','2011-07-13',489.00),(65,'a131','201107','traiteur, alimentation, boisson','2011-07-28',230.00),(66,'a131','201108','achat de matériel de papèterie','2011-08-22',42.00),(67,'a131','201108','taxi','2011-08-12',41.00),(68,'a131','201108','taxi','2011-08-05',39.00),(69,'a131','201108','frais vestimentaire/représentation','2011-08-06',84.00),(70,'a131','201109','Voyage SNCF','2011-09-19',111.00),(71,'a131','201110','rémunération intervenant/spécialiste','2011-10-04',791.00),(72,'a131','201111','Voyage SNCF','2011-11-11',34.00),(73,'a131','201111','traiteur, alimentation, boisson','2011-11-23',280.00),(74,'a131','201111','location équipement vidéo/sonore','2011-11-03',482.00),(75,'a131','201111','repas avec praticien','2011-11-12',33.00),(76,'a131','201112','traiteur, alimentation, boisson','2011-12-20',398.00),(77,'a131','201112','achat de matériel de papèterie','2011-12-22',32.00),(78,'a131','201112','location salle conférence','2011-12-20',299.00),(79,'a131','201112','taxi','2011-12-09',75.00),(80,'a131','201201','frais vestimentaire/représentation','2012-01-18',123.00),(81,'a131','201201','location véhicule','2012-01-24',225.00),(82,'a131','201202','location équipement vidéo/sonore','2012-02-20',488.00),(83,'a131','201202','achat de matériel de papèterie','2012-02-13',42.00),(84,'a131','201202','taxi','2012-02-02',25.00),(85,'a131','201203','Voyage SNCF','2012-03-09',120.00),(86,'a131','201204','frais vestimentaire/représentation','2012-04-21',117.00),(87,'a131','201204','traiteur, alimentation, boisson','2012-04-03',225.00),(88,'a131','201204','achat de matériel de papèterie','2012-04-17',33.00),(89,'a131','201204','Voyage SNCF','2012-04-19',104.00),(90,'a131','201204','achat d\'espace publicitaire','2012-04-28',147.00),(91,'a131','201204','taxi','2012-04-19',20.00),(92,'a131','201205','repas avec praticien','2012-05-04',45.00),(93,'a131','201205','rémunération intervenant/spécialiste','2012-05-26',750.00),(94,'a131','201205','Voyage SNCF','2012-05-15',138.00),(95,'a131','201206','achat d\'espace publicitaire','2012-06-09',134.00),(96,'a131','201206','repas avec praticien','2012-06-23',44.00),(97,'a131','201206','location équipement vidéo/sonore','2012-06-07',423.00),(98,'a131','201206','location salle conférence','2012-06-05',292.00),(99,'a131','201207','location véhicule','2012-07-06',324.00),(100,'a131','201208','frais vestimentaire/représentation','2012-08-02',148.00),(101,'a131','201208','achat d\'espace publicitaire','2012-08-27',139.00),(102,'a131','201208','traiteur, alimentation, boisson','2012-08-11',213.00),(103,'a131','201208','frais vestimentaire/représentation','2012-08-06',197.00),(104,'a131','201208','traiteur, alimentation, boisson','2012-08-11',128.00),(105,'a131','201209','achat d\'espace publicitaire','2012-09-01',33.00),(106,'a131','201209','Voyage SNCF','2012-09-11',119.00),(107,'a131','201210','location équipement vidéo/sonore','2012-10-13',531.00),(108,'a131','201210','traiteur, alimentation, boisson','2012-10-02',441.00),(109,'a131','201211','repas avec praticien','2012-11-25',46.00),(110,'a131','201212','frais vestimentaire/représentation','2012-12-08',165.00),(111,'a131','201212','taxi','2012-12-04',43.00),(112,'a131','201212','frais vestimentaire/représentation','2012-12-23',358.00),(113,'a131','201212','achat d\'espace publicitaire','2012-12-10',46.00),(114,'a131','201212','achat de matériel de papèterie','2012-12-19',30.00),(115,'a17','201001','location véhicule','2010-01-16',337.00),(116,'a17','201001','achat d\'espace publicitaire','2010-01-18',147.00),(117,'a17','201002','frais vestimentaire/représentation','2010-02-08',421.00),(118,'a17','201002','repas avec praticien','2010-02-20',49.00),(119,'a17','201002','achat d\'espace publicitaire','2010-02-18',104.00),(120,'a17','201002','location équipement vidéo/sonore','2010-02-15',649.00),(121,'a17','201003','repas avec praticien','2010-03-14',34.00),(122,'a17','201003','frais vestimentaire/représentation','2010-03-24',43.00),(123,'a17','201003','rémunération intervenant/spécialiste','2010-03-21',1051.00),(124,'a17','201003','achat de matériel de papèterie','2010-03-23',44.00),(125,'a17','201003','traiteur, alimentation, boisson','2010-03-07',162.00),(126,'a17','201003','rémunération intervenant/spécialiste','2010-03-25',783.00),(127,'a17','201004','location véhicule','2010-04-28',78.00),(128,'a17','201004','frais vestimentaire/représentation','2010-04-08',68.00),(129,'a17','201004','achat de matériel de papèterie','2010-04-24',21.00),(130,'a17','201004','location salle conférence','2010-04-19',390.00),(131,'a17','201005','traiteur, alimentation, boisson','2010-05-24',307.00),(132,'a17','201005','Voyage SNCF','2010-05-20',51.00),(133,'a17','201005','repas avec praticien','2010-05-07',44.00),(134,'a17','201005','taxi','2010-05-20',76.00),(135,'a17','201005','taxi','2010-05-23',37.00),(136,'a17','201005','location salle conférence','2010-05-15',131.00),(137,'a17','201006','repas avec praticien','2010-06-01',34.00),(138,'a17','201006','location équipement vidéo/sonore','2010-06-20',589.00),(139,'a17','201006','location salle conférence','2010-06-12',543.00),(140,'a17','201007','rémunération intervenant/spécialiste','2010-07-08',875.00),(141,'a17','201007','frais vestimentaire/représentation','2010-07-02',232.00),(142,'a17','201007','Voyage SNCF','2010-07-27',52.00),(143,'a17','201007','taxi','2010-07-17',77.00),(144,'a17','201007','traiteur, alimentation, boisson','2010-07-28',401.00),(145,'a17','201007','rémunération intervenant/spécialiste','2010-07-07',845.00),(146,'a17','201008','achat d\'espace publicitaire','2010-08-01',90.00),(147,'a17','201008','rémunération intervenant/spécialiste','2010-08-13',382.00),(148,'a17','201008','location salle conférence','2010-08-28',426.00),(149,'a17','201009','taxi','2010-09-10',44.00),(150,'a17','201009','taxi','2010-09-01',52.00),(151,'a17','201009','taxi','2010-09-05',61.00),(152,'a17','201009','location équipement vidéo/sonore','2010-09-16',148.00),(153,'a17','201009','achat d\'espace publicitaire','2010-09-24',92.00),(154,'a17','201009','location salle conférence','2010-09-19',496.00),(155,'a17','201010','achat d\'espace publicitaire','2010-10-26',91.00),(156,'a17','201011','frais vestimentaire/représentation','2010-11-21',260.00),(157,'a17','201011','frais vestimentaire/représentation','2010-11-27',137.00),(158,'a17','201011','location véhicule','2010-11-27',93.00),(159,'a17','201011','location salle conférence','2010-11-19',515.00),(160,'a17','201012','achat d\'espace publicitaire','2010-12-11',41.00),(161,'a17','201101','achat de matériel de papèterie','2011-01-23',29.00),(162,'a17','201101','traiteur, alimentation, boisson','2011-01-16',149.00),(163,'a17','201102','traiteur, alimentation, boisson','2011-02-20',200.00),(164,'a17','201102','taxi','2011-02-21',46.00),(165,'a17','201102','location équipement vidéo/sonore','2011-02-20',588.00),(166,'a17','201102','frais vestimentaire/représentation','2011-02-19',65.00),(167,'a17','201102','location salle conférence','2011-02-16',308.00),(168,'a17','201102','taxi','2011-02-17',38.00),(169,'a17','201103','location équipement vidéo/sonore','2011-03-26',373.00),(170,'a17','201103','rémunération intervenant/spécialiste','2011-03-06',627.00),(171,'a17','201103','repas avec praticien','2011-03-13',41.00),(172,'a17','201104','achat de matériel de papèterie','2011-04-27',47.00),(173,'a17','201104','achat de matériel de papèterie','2011-04-03',50.00),(174,'a17','201104','achat d\'espace publicitaire','2011-04-23',136.00),(175,'a17','201104','frais vestimentaire/représentation','2011-04-23',285.00),(176,'a17','201104','taxi','2011-04-07',71.00),(177,'a17','201104','repas avec praticien','2011-04-17',43.00),(178,'a17','201105','repas avec praticien','2011-05-16',42.00),(179,'a17','201106','repas avec praticien','2011-06-17',38.00),(180,'a17','201106','achat d\'espace publicitaire','2011-06-21',89.00),(181,'a17','201106','frais vestimentaire/représentation','2011-06-19',433.00),(182,'a17','201106','location véhicule','2011-06-23',298.00),(183,'a17','201106','repas avec praticien','2011-06-25',39.00),(184,'a17','201106','achat d\'espace publicitaire','2011-06-21',115.00),(185,'a17','201107','location salle conférence','2011-07-13',296.00),(186,'a17','201107','frais vestimentaire/représentation','2011-07-27',308.00),(187,'a17','201107','location équipement vidéo/sonore','2011-07-27',119.00),(188,'a17','201107','achat de matériel de papèterie','2011-07-01',30.00),(189,'a17','201108','repas avec praticien','2011-08-24',46.00),(190,'a17','201108','repas avec praticien','2011-08-10',34.00),(191,'a17','201108','location équipement vidéo/sonore','2011-08-23',356.00),(192,'a17','201108','location salle conférence','2011-08-16',520.00),(193,'a17','201108','achat d\'espace publicitaire','2011-08-02',120.00),(194,'a17','201109','frais vestimentaire/représentation','2011-09-14',256.00),(195,'a17','201109','achat de matériel de papèterie','2011-09-14',18.00),(196,'a17','201110','frais vestimentaire/représentation','2011-10-23',129.00),(197,'a17','201110','location véhicule','2011-10-18',291.00),(198,'a17','201110','taxi','2011-10-16',73.00),(199,'a17','201111','repas avec praticien','2011-11-20',40.00),(200,'a17','201111','achat d\'espace publicitaire','2011-11-28',129.00),(201,'a17','201111','traiteur, alimentation, boisson','2011-11-26',148.00),(202,'a17','201112','achat de matériel de papèterie','2011-12-28',10.00),(203,'a17','201112','traiteur, alimentation, boisson','2011-12-15',405.00),(204,'a17','201201','location véhicule','2012-01-14',340.00),(205,'a17','201201','location salle conférence','2012-01-06',309.00),(206,'a17','201202','rémunération intervenant/spécialiste','2012-02-06',250.00),(207,'a17','201202','Voyage SNCF','2012-02-03',138.00),(208,'a17','201202','taxi','2012-02-05',33.00),(209,'a17','201202','Voyage SNCF','2012-02-21',58.00),(210,'a17','201202','taxi','2012-02-21',54.00),(211,'a17','201202','achat de matériel de papèterie','2012-02-03',20.00),(212,'a17','201203','repas avec praticien','2012-03-14',31.00),(213,'a17','201203','Voyage SNCF','2012-03-23',90.00),(214,'a17','201203','Voyage SNCF','2012-03-04',54.00),(215,'a17','201203','taxi','2012-03-07',57.00),(216,'a17','201204','Voyage SNCF','2012-04-18',96.00),(217,'a17','201204','rémunération intervenant/spécialiste','2012-04-20',644.00),(218,'a17','201204','location équipement vidéo/sonore','2012-04-05',378.00),(219,'a17','201204','location véhicule','2012-04-17',295.00),(220,'a17','201204','location salle conférence','2012-04-21',386.00),(221,'a17','201204','location salle conférence','2012-04-10',371.00),(222,'a17','201205','Voyage SNCF','2012-05-22',150.00),(223,'a17','201206','location véhicule','2012-06-18',121.00),(224,'a17','201206','Voyage SNCF','2012-06-25',45.00),(225,'a17','201206','taxi','2012-06-12',31.00),(226,'a17','201206','achat de matériel de papèterie','2012-06-26',29.00),(227,'a17','201206','achat d\'espace publicitaire','2012-06-19',125.00),(228,'a17','201206','achat de matériel de papèterie','2012-06-01',46.00),(229,'a17','201207','location véhicule','2012-07-16',353.00),(230,'a17','201207','location équipement vidéo/sonore','2012-07-01',564.00),(231,'a17','201207','traiteur, alimentation, boisson','2012-07-08',431.00),(232,'a17','201207','taxi','2012-07-12',70.00),(233,'a17','201207','achat d\'espace publicitaire','2012-07-16',92.00),(234,'a17','201208','location équipement vidéo/sonore','2012-08-12',483.00),(235,'a17','201209','repas avec praticien','2012-09-20',34.00),(236,'a17','201209','location équipement vidéo/sonore','2012-09-09',168.00),(237,'a17','201210','repas avec praticien','2012-10-23',39.00),(238,'a17','201211','location équipement vidéo/sonore','2012-11-10',140.00),(239,'a17','201211','Voyage SNCF','2012-11-11',91.00),(240,'a17','201211','repas avec praticien','2012-11-27',41.00),(241,'a17','201211','location salle conférence','2012-11-15',343.00),(242,'a17','201211','Voyage SNCF','2012-11-18',96.00),(243,'a17','201212','location véhicule','2012-12-08',378.00),(244,'a17','201212','location véhicule','2012-12-20',288.00),(245,'a17','201212','location salle conférence','2012-12-13',171.00),(246,'a17','201212','achat de matériel de papèterie','2012-12-06',36.00),(247,'a17','201212','location équipement vidéo/sonore','2012-12-03',559.00),(3548,'a17','201306','essence ','2013-05-07',100.00),(3549,'a17','201307','test50000','2013-06-07',500.00);
/*!40000 ALTER TABLE `lignefraishorsforfait` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

