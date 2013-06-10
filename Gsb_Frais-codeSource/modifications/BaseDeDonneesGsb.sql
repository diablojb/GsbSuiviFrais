SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `gsb_frais` DEFAULT CHARACTER SET latin1 ;
USE `gsb_frais` ;

-- -----------------------------------------------------
-- Table `gsb_frais`.`etat`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `gsb_frais`.`etat` (
  `id` CHAR(2) NOT NULL ,
  `libelle` VARCHAR(30) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `gsb_frais`.`type`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `gsb_frais`.`type` (
  `id` CHAR(1) NOT NULL DEFAULT '' ,
  `libelleType` CHAR(30) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `gsb_frais`.`utilisateur`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `gsb_frais`.`utilisateur` (
  `id` CHAR(4) NOT NULL ,
  `nom` CHAR(30) NULL DEFAULT NULL ,
  `prenom` CHAR(30) NULL DEFAULT NULL ,
  `login` CHAR(20) NULL DEFAULT NULL ,
  `mdp` CHAR(40) NULL DEFAULT NULL ,
  `adresse` CHAR(30) NULL DEFAULT NULL ,
  `cp` CHAR(5) NULL DEFAULT NULL ,
  `ville` CHAR(30) NULL DEFAULT NULL ,
  `dateEmbauche` DATE NULL DEFAULT NULL ,
  `idType` CHAR(1) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_type_idx` (`idType` ASC) ,
  CONSTRAINT `fk_type`
    FOREIGN KEY (`idType` )
    REFERENCES `gsb_frais`.`type` (`id` ))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `gsb_frais`.`typevehicule`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `gsb_frais`.`typevehicule` (
  `id` CHAR(5) NOT NULL DEFAULT '' ,
  `libelleType` CHAR(30) NULL DEFAULT NULL ,
  `indemniteKm` DECIMAL(5,2) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `gsb_frais`.`fichefrais`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `gsb_frais`.`fichefrais` (
  `idVisiteur` CHAR(4) NOT NULL ,
  `mois` CHAR(6) NOT NULL ,
  `nbJustificatifs` INT(11) NULL DEFAULT NULL ,
  `montantValide` DECIMAL(10,2) NULL DEFAULT NULL ,
  `dateModif` DATE NULL DEFAULT NULL ,
  `idEtat` CHAR(2) NULL DEFAULT 'CR' ,
  `idTypeVehicule` CHAR(5) NOT NULL ,
  PRIMARY KEY (`idVisiteur`, `mois`) ,
  INDEX `idEtat` (`idEtat` ASC) ,
  INDEX `fk_typeVehicule_idx` (`idTypeVehicule` ASC) ,
  CONSTRAINT `FicheFrais_ibfk_1`
    FOREIGN KEY (`idEtat` )
    REFERENCES `gsb_frais`.`etat` (`id` ),
  CONSTRAINT `FicheFrais_ibfk_2`
    FOREIGN KEY (`idVisiteur` )
    REFERENCES `gsb_frais`.`utilisateur` (`id` ),
  CONSTRAINT `fk_typeVehicule`
    FOREIGN KEY (`idTypeVehicule` )
    REFERENCES `gsb_frais`.`typevehicule` (`id` ))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `gsb_frais`.`fraisforfait`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `gsb_frais`.`fraisforfait` (
  `id` CHAR(3) NOT NULL ,
  `libelle` CHAR(20) NULL DEFAULT NULL ,
  `montant` DECIMAL(5,2) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `gsb_frais`.`lignefraisforfait`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `gsb_frais`.`lignefraisforfait` (
  `idVisiteur` CHAR(4) NOT NULL ,
  `mois` CHAR(6) NOT NULL ,
  `idFraisForfait` CHAR(3) NOT NULL ,
  `quantite` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`idVisiteur`, `mois`, `idFraisForfait`) ,
  INDEX `idFraisForfait` (`idFraisForfait` ASC) ,
  CONSTRAINT `LigneFraisForfait_ibfk_1`
    FOREIGN KEY (`idVisiteur` , `mois` )
    REFERENCES `gsb_frais`.`fichefrais` (`idVisiteur` , `mois` ),
  CONSTRAINT `LigneFraisForfait_ibfk_2`
    FOREIGN KEY (`idFraisForfait` )
    REFERENCES `gsb_frais`.`fraisforfait` (`id` ))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `gsb_frais`.`lignefraishorsforfait`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `gsb_frais`.`lignefraishorsforfait` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `idVisiteur` CHAR(4) NOT NULL ,
  `mois` CHAR(6) NOT NULL ,
  `libelle` VARCHAR(100) NULL DEFAULT NULL ,
  `date` DATE NULL DEFAULT NULL ,
  `montant` DECIMAL(10,2) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `idVisiteur` (`idVisiteur` ASC, `mois` ASC) ,
  CONSTRAINT `LigneFraisHorsForfait_ibfk_1`
    FOREIGN KEY (`idVisiteur` , `mois` )
    REFERENCES `gsb_frais`.`fichefrais` (`idVisiteur` , `mois` ))
ENGINE = InnoDB
AUTO_INCREMENT = 3553
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- procedure ajoutFicheFrais
-- -----------------------------------------------------

DELIMITER $$
USE `gsb_frais`$$
CREATE  PROCEDURE `ajoutFicheFrais`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ajoutLigneFrais
-- -----------------------------------------------------

DELIMITER $$
USE `gsb_frais`$$
CREATE  PROCEDURE `ajoutLigneFrais`(IN idUtilisateur char(4),
IN unMois char(6),
IN idFraisForfait char(3))
BEGIN
INSERT INTO `LigneFraisForfait` (`idVisiteur`,`mois`,`idFraisForfait`,`quantite`)
VALUES (idUtilisateur, unMois, idFraisForfait, '0');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ajoutLigneHF
-- -----------------------------------------------------

DELIMITER $$
USE `gsb_frais`$$
CREATE  PROCEDURE `ajoutLigneHF`(IN unMois char(6),
IN idUtilisateur char(4),
IN uneDateHf date,
IN libelleHf varchar(100),
IN montantHf decimal(10,2))
BEGIN
INSERT INTO LigneFraisHorsForfait(`idVisiteur`,`mois`,`libelle`,`date`,`montant`)
VALUES(idUtilisateur,unMois,libelleHf,uneDateHF,montantHf);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function calculerMontantValide
-- -----------------------------------------------------

DELIMITER $$
USE `gsb_frais`$$
CREATE  FUNCTION `calculerMontantValide`(`unIdVisiteur` CHAR(4), `unMois` CHAR(6)) RETURNS decimal(10,2)
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure changementTypeVehicule
-- -----------------------------------------------------

DELIMITER $$
USE `gsb_frais`$$
CREATE  PROCEDURE `changementTypeVehicule`(IN typeVehicule CHAR(5), IN idUtilisateur CHAR(4), IN unMois CHAR(6))
BEGIN
	UPDATE FicheFrais
		SET idTypeVehicule = typeVehicule
		WHERE idVisiteur = idUtilisateur AND mois = unMois;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modifEltsForfait
-- -----------------------------------------------------

DELIMITER $$
USE `gsb_frais`$$
CREATE  PROCEDURE `modifEltsForfait`(
IN idUtilisateur char(4),
IN idFrais char(3),
IN unMois char(6),
IN quantite int(11))
BEGIN
UPDATE `LigneFraisForfait` SET `quantite` = quantite
WHERE `idVisiteur` = idUtilisateur AND `mois` = unMois
	AND `idFraisForfait` = idFrais;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modifEltsHF
-- -----------------------------------------------------

DELIMITER $$
USE `gsb_frais`$$
CREATE  PROCEDURE `modifEltsHF`(IN libelleHF varchar(100),
IN dateHF date,
IN montantHF decimal(10,2),
IN idHF int
)
BEGIN
UPDATE LigneFraisHorsForfait SET libelle = libelleHF,
								`date` = dateHF,
								`montant` = montantHF
	WHERE `id` = idHF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modifFicheFrais
-- -----------------------------------------------------

DELIMITER $$
USE `gsb_frais`$$
CREATE  PROCEDURE `modifFicheFrais`(
IN idEtat char(2),
IN idUtilisateur char(4),
IN unMois char(6))
BEGIN
UPDATE `FicheFrais` SET `idEtat` = idEtat,
`dateModif` = CURRENT_DATE()
WHERE `idVisiteur` = idUtilisateur AND `mois` = unMois;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modifNbrJustificatifs
-- -----------------------------------------------------

DELIMITER $$
USE `gsb_frais`$$
CREATE PROCEDURE `modifNbrJustificatifs`(IN nbrJustificatifs int, IN idUtilisateur char(4), IN unMois char(6))
BEGIN
UPDATE FicheFrais SET nbJustificatifs = nbrJustificatifs
WHERE idVisiteur = idUtilisateur AND mois = unMois;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure reporterLigneHorsForfait
-- -----------------------------------------------------

DELIMITER $$
USE `gsb_frais`$$
CREATE  PROCEDURE `reporterLigneHorsForfait`(IN unId INT)
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
END$$

DELIMITER ;
USE `gsb_frais`;

DELIMITER $$
USE `gsb_frais`$$
CREATE TRIGGER `gsb_frais`.`updateFiche`
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
END$$


DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
