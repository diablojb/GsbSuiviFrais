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
-- Dumping events for database 'gsb_frais'
--

--
-- Dumping routines for database 'gsb_frais'
--
/*!50003 DROP FUNCTION IF EXISTS `calculerMontantValide` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 FUNCTION `calculerMontantValide`(`unIdVisiteur` CHAR(4), `unMois` CHAR(6)) RETURNS decimal(10,2)
    READS SQL DATA
BEGIN
   RETURN (
      SELECT SUM(IndemKm.montantIndemKm + FraisF.montantFraisF + FraisHF.montantFraisHF) AS totalFicheFrais
      FROM ( SELECT FicheFrais.idVisiteur, FicheFrais.mois, SUM(quantite*indemniteKm) AS montantIndemKm
	        FROM FicheFrais
			   INNER JOIN LigneFraisForfait
	               ON FicheFrais.idVisiteur = LigneFraisForfait.idVisiteur
	              AND FicheFrais.mois = LigneFraisForfait.mois
	           INNER JOIN TypeVehicule
	              ON FicheFrais.idTypeVehicule = TypeVehicule.id
	        WHERE LigneFraisForfait.idFraisForfait = 'KM'
	        GROUP BY FicheFrais.idVisiteur, FicheFrais.mois
	       ) AS IndemKm
         INNER JOIN (
	        SELECT FicheFrais.idVisiteur, FicheFrais.mois, SUM(quantite*montant) AS montantFraisF
	        FROM FicheFrais
			   INNER JOIN LigneFraisForfait
	               ON FicheFrais.idVisiteur = LigneFraisForfait.idVisiteur
	              AND FicheFrais.mois = LigneFraisForfait.mois
	           INNER JOIN FraisForfait
	              ON LigneFraisForfait.idFraisForfait = FraisForfait.id
	        WHERE LigneFraisForfait.idFraisForfait != 'KM'
	        GROUP BY FicheFrais.idVisiteur, FicheFrais.mois
            ) AS FraisF ON (IndemKm.idVisiteur = FraisF.idVisiteur AND IndemKm.mois = FraisF.mois)
         INNER JOIN (
		    SELECT idVisiteur, mois, SUM(montant) AS montantFraisHF
		    FROM LigneFraisHorsForfait
			/* Ne pas oublier de ne pas prendre en compte les lignes refusees */
			WHERE libelle NOT LIKE 'REFUSÉ :%'
		    GROUP BY idVisiteur, mois
			) AS FraisHF ON (FraisF.idVisiteur = FraisHF.idVisiteur AND FraisF.mois = FraisHF.mois)
      WHERE FraisF.idVisiteur = unIdVisiteur
        AND FraisF.mois = unMois
      GROUP BY FraisF.idVisiteur, FraisF.mois );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ajoutFicheFrais` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `ajoutFicheFrais`(
IN idUtilisateur char(4),
IN unMois char(6),
IN nbrJustificatifs int(11),
IN montant decimal(10,2),
IN dateModif date,
IN etat char(2),
IN typeVehicule char(5))
BEGIN
INSERT INTO `FicheFrais` (`idVisiteur`,
`mois`,
`nbJustificatifs`,
`montantValide`,
`dateModif`,
`idEtat`,
`idTypeVehicule`) 
VALUES (idUtilisateur, unMois, nbrJustificatifs, montant, dateModif,
etat, typeVehicule);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ajoutLigneFrais` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `ajoutLigneFrais`(IN idUtilisateur char(4),
IN unMois char(6),
IN idFraisForfait char(3))
BEGIN
INSERT INTO `LigneFraisForfait` (`idVisiteur`,`mois`,`idFraisForfait`,`quantite`)
VALUES (idUtilisateur, unMois, idFraisForfait, '0');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ajoutLigneHF` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `ajoutLigneHF`(IN unMois char(6),
IN idUtilisateur char(4),
IN uneDateHf date,
IN libelleHf varchar(100),
IN montantHf decimal(10,2))
BEGIN
INSERT INTO LigneFraisHorsForfait(`idVisiteur`,`mois`,`libelle`,`date`,`montant`)
VALUES(idUtilisateur,unMois,libelleHf,uneDateHF,montantHf);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `changementTypeVehicule` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `changementTypeVehicule`(IN typeVehicule CHAR(5), IN idUtilisateur CHAR(4), IN unMois CHAR(6))
BEGIN
	UPDATE FicheFrais
		SET idTypeVehicule = typeVehicule
		WHERE idVisiteur = idUtilisateur AND mois = unMois;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modifEltsForfait` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modifEltsForfait`(
IN idUtilisateur char(4),
IN idFrais char(3),
IN unMois char(6),
IN quantite int(11))
BEGIN
UPDATE `LigneFraisForfait` SET `quantite` = quantite
WHERE `idVisiteur` = idUtilisateur AND `mois` = unMois
	AND `idFraisForfait` = idFrais;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modifEltsHF` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modifEltsHF`(IN libelleHF varchar(100),
IN dateHF date,
IN montantHF decimal(10,2),
IN idHF int
)
BEGIN
UPDATE LigneFraisHorsForfait SET libelle = libelleHF,
								`date` = dateHF,
								`montant` = montantHF
	WHERE `id` = idHF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modifFicheFrais` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modifFicheFrais`(
IN idEtat char(2),
IN idUtilisateur char(4),
IN unMois char(6))
BEGIN
UPDATE `FicheFrais` SET `idEtat` = idEtat,
`dateModif` = CURRENT_DATE()
WHERE `idVisiteur` = idUtilisateur AND `mois` = unMois;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modifNbrJustificatifs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modifNbrJustificatifs`(IN nbrJustificatifs int, IN idUtilisateur char(4), IN unMois char(6))
BEGIN
UPDATE FicheFrais SET nbJustificatifs = nbrJustificatifs
WHERE idVisiteur = idUtilisateur AND mois = unMois;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `reporterLigneHorsForfait` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `reporterLigneHorsForfait`(IN unId INT)
BEGIN
	DECLARE vIdUtilisateur CHAR(4) DEFAULT NULL;
	DECLARE	vMoisSuivant CHAR(6);
	DECLARE	vFicheExiste BOOLEAN;
	DECLARE	vidTypeVehicule CHAR(5);
/* Recuperation de l'utilisateur(visiteur) et du mois suivant */
	SELECT idVisiteur, moisSuivant INTO vIdUtilisateur, vMoisSuivant
	FROM(SELECT idVisiteur, EXTRACT(YEAR_MONTH FROM DATE (CONCAT(LEFT(mois,4), '-',RIGHT(mois,2),-'00')) + INTERVAL 1 MONTH) AS moisSuivant
		FROM LigneFraisHorsForfait
		WHERE id=unId) as reqRecup;
/* vérification s'il existe une fiche dans le mois prochain */
	SELECT COUNT(*) INTO vFicheExiste
	FROM FicheFrais
	WHERE idVisiteur= vIdUtilisateur AND mois = vMoisSuivant;
/* si la fiche n'existe pas on la créer, avec les forfaits */
	IF vFicheExiste = FALSE THEN 
	-- récupération du type de véhicule du mois 
	SELECT idTypeVehicule INTO vIdTypeVehicule
	FROM FicheFrais AS fF INNER JOIN LigneFraisHorsForfait AS lF ON (fF.idVisiteur = lF.idVisiteur AND fF.mois = lF.mois)
	WHERE lF.id = unId;
	-- création de l enregistrement dans FicheFrais 
	INSERT INTO FicheFrais (idVisiteur, mois, nbJustificatifs, montantValide,  dateModif, idEtat, idTypeVehicule)
	VALUES (vIdUtilisateur, vMoisSuivant, '0', NULL,  CURRENT_DATE,'CR', vIdTypeVehicule);
	-- création de l enregistrement dans LigneFraisForfait 
	INSERT INTO LigneFraisForfait (idVisiteur, mois, idFraisForfait, quantite)
	VALUES (vIdUtilisateur, vMoisSuivant, 'ETP', 0),
	       (vIdUtilisateur, vMoisSuivant, 'KM', 0),
	       (vIdUtilisateur, vMoisSuivant, 'NUI', 0),
	       (vIdUtilisateur, vMoisSuivant, 'REP', 0);
	-- transfert de la ligne hors forfait sur le mois suivant
	UPDATE LigneFraisHorsForfait SET mois = vMoisSuivant WHERE id = unId;
	ELSE 
	-- tranfert de la ligne hros forfait sur le mois suivant
	UPDATE LigneFraisHorsForfait SET mois = vMoisSuivant WHERE id = unId;
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


