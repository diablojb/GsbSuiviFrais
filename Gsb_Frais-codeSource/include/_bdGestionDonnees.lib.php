<?php

/**
 * Regroupe les fonctions d'accés aux données.
 * @package default
 * @author jeanbaptiste
 */

/**
 * Se connecte au serveur de données MySql.                      
 * Se connecte au serveur de données MySql à partir de valeurs
 * prédéfinies de connexion (hôte, compte utilisateur et mot de passe). 
 * Retourne l'identifiant de connexion si succés obtenu, le booléen false 
 * si probléme de connexion.
 * @return resource identifiant de connexion
 */
function connecterServeurBD() {
    $hote = "localhost";
    $login = "root";
    $mdp = "";
    return mysql_connect($hote, $login, $mdp);
}

/**
 * Sélectionne (rend active) la base de données.
 * Sélectionne (rend active) la BD prédéfinie gsb_frais sur la connexion
 * identifiée par $idconnexion. Retourne true si succés, false sinon.
 * @param resource $idconnexion identifiant de connexion
 * @return boolean succés ou échec de sélection BD 
 */
function activerBD($idconnexion) {
    $bd = "Gsb_Frais";
    $query = "SET CHARACTER SET utf8";
    // Modification du jeu de caractéres de la connexion
    $res = mysql_query($query, $idconnexion);
    $ok = mysql_select_db($bd, $idconnexion);
    return $ok;
}

/**
 * Ferme la connexion au serveur de données.
 * Ferme la connexion au serveur de données identifiée par l'identifiant de 
 * connexion $idconnexion.
 * @param resource $idconnexion identifiant de connexion
 * @return void  
 */
function deconnecterServeurBD($idconnexion) {
    mysql_close($idconnexion);
}

/**
 * Echappe les caractéres spéciaux d'une chaîne.
 * Envoie la chaéne $str échappée, céd avec les caractéres considérés spéciaux
 * par MySql (tq la quote simple) précédés d'un \, ce qui annule leur effet spécial
 * @param string $str chaéne à échapper
 * @return string chaîne échappée 
 */
function filtrerChainePourBD($str) {
    if (!get_magic_quotes_gpc()) {
        // si la directive de configuration magic_quotes_gpc est activée dans php.ini,
        // toute chaîne reçue par get, post ou cookie est déjà échappée 
        // par conséquent, il ne faut pas échapper la chaîne une seconde fois                              
        $str = mysql_real_escape_string($str);
    }
    return $str;
}

/**
 * Fournit les informations sur un utilisateur demandé. 
 * Retourne les informations de l'utilisateur d'id $unId sous la forme d'un tableau
 * associatif dont les clés sont les noms des colonnes(id, nom, prenom).
 * @param resource $idconnexion identifiant de connexion
 * @param string $unId id de l'utilisateur
 * @return array  tableau associatif de utilisateur
 */
function obtenirDetailUtilisateur($idconnexion, $unId) {
    $id = filtrerChainePourBD($unId);
    $requete = "SELECT Utilisateur.id, nom,prenom, libelleType FROM Utilisateur INNER JOIN Type ON Utilisateur.idType=Type.id WHERE Utilisateur.id='" . $id . "'";
    $idJeuRes = mysql_query($requete, $idconnexion);
    $ligne = false;
    if ($idJeuRes) {
        $ligne = mysql_fetch_assoc($idJeuRes);
        mysql_free_result($idJeuRes);
    }
    return $ligne;
}

/**
 * Fournit les informations d'une fiche de frais. 
 * Retourne les informations de la fiche de frais du mois de $unMois (MMAAAA)
 * sous la forme d'un tableau associatif dont les clés sont les noms des colonnes
 * (nbJustitificatifs, idEtat, libelleEtat, dateModif, montantValide).
 * @param resource $idconnexion identifiant de connexion
 * @param string $unMois mois demandé (MMAAAA)
 * @param string $unIdVisiteur id visiteur  
 * @return array tableau associatif de la fiche de frais
 */
function obtenirDetailFicheFrais($idconnexion, $unMois, $unIdVisiteur) {
    $unMois = filtrerChainePourBD($unMois);
    $ligne = false;
    $requete = "SELECT IFNULL(nbJustificatifs,0) AS nbJustificatifs, Etat.id AS idEtat, libelle AS libelleEtat, dateModif, montantValide 
    FROM FicheFrais INNER JOIN Etat ON idEtat = Etat.id 
    WHERE idVisiteur='" . $unIdVisiteur . "' AND mois='" . $unMois . "'";
    $idJeuRes = mysql_query($requete, $idconnexion);
    if ($idJeuRes) {
        $ligne = mysql_fetch_assoc($idJeuRes);
    }
    mysql_free_result($idJeuRes);
    return $ligne;
}

/**
 * Vérifie si une fiche de frais existe ou non. 
 * Retourne true si la fiche de frais du mois de $unMois (MMAAAA) du visiteur 
 * $idVisiteur existe, false sinon. 
 * @param resource $idconnexion identifiant de connexion
 * @param string $unMois mois demandé (MMAAAA)
 * @param string $unIdVisiteur id visiteur  
 * @return booléen existence ou non de la fiche de frais
 */
function existeFicheFrais($idconnexion, $unMois, $unIdVisiteur) {
    $unMois = filtrerChainePourBD($unMois);
    $requete = "SELECT idVisiteur FROM FicheFrais WHERE idVisiteur='" . $unIdVisiteur .
            "' AND mois='" . $unMois . "'";
    $idJeuRes = mysql_query($requete, $idconnexion);
    $ligne = false;
    if ($idJeuRes) {
        $ligne = mysql_fetch_assoc($idJeuRes);
        mysql_free_result($idJeuRes);
    }
    // si $ligne est un tableau, la fiche de frais existe, sinon elle n'exsite pas
    return is_array($ligne);
}

/**
 * Fournit le mois de la derniére fiche de frais d'un visiteur.
 * Retourne le mois de la derniére fiche de frais du visiteur d'id $unIdVisiteur.
 * @param resource $idconnexion identifiant de connexion
 * @param string $unIdVisiteur id visiteur  
 * @return string dernier mois sous la forme AAAAMM
 */
function obtenirDernierMoisSaisi($idconnexion, $unIdVisiteur) {
    $requete = "SELECT max(mois) AS dernierMois FROM FicheFrais WHERE idVisiteur='" .
            $unIdVisiteur . "'";
    $idJeuRes = mysql_query($requete, $idconnexion);
    $dernierMois = false;
    if ($idJeuRes) {
        $ligne = mysql_fetch_assoc($idJeuRes);
        $dernierMois = $ligne["dernierMois"];
        mysql_free_result($idJeuRes);
    }
    return $dernierMois;
}

/**
 * Ajoute une nouvelle fiche de frais et les éléments forfaitisés associés, 
 * Ajoute la fiche de frais du mois de $unMois (MMAAAA) du visiteur 
 * $idVisiteur, avec les éléments forfaitisés associés dont la quantité initiale
 * est affectée à 0. Clét éventuellement la fiche de frais précédente du visiteur. 
 * @param resource $idconnexion identifiant de connexion
 * @param string $unMois mois demandé (MMAAAA)
 * @param string $unIdVisiteur id visiteur  
 * @return void
 */
function ajouterFicheFrais($idconnexion, $unMois, $unIdVisiteur) {
    $unMois = filtrerChainePourBD($unMois);
    // modification de la derniére fiche de frais du visiteur
    $dernierMois = obtenirDernierMoisSaisi($idconnexion, $unIdVisiteur);
    $laDerniereFiche = obtenirDetailFicheFrais($idconnexion, $dernierMois, $unIdVisiteur);
    if (is_array($laDerniereFiche) && $laDerniereFiche['idEtat'] == 'CR') {
        modifierEtatFicheFrais($idconnexion, $dernierMois, $unIdVisiteur, 'CL');
    }
    // ajout de la fiche de frais à l'état Créé
    $req = "CALL ajoutFicheFrais('" . $unIdVisiteur . "', '" . $unMois . "', '0', 'NULL' , '" . date("Y-m-d") . "', 'CR', '4cvd')";
    mysql_query($req, $idconnexion);

    // ajout des éléments forfaitisés
    $requete = "SELECT id FROM FraisForfait";
    $idJeuRes = mysql_query($requete, $idconnexion);
    if ($idJeuRes) {
        $ligne = mysql_fetch_assoc($idJeuRes);
        while (is_array($ligne)) {
            $idFraisForfait = $ligne["id"];
            //insertion d'une ligne frais forfait
            $req = "CALL ajoutLigneFrais('" . $unIdVisiteur . "', '" . $unMois . "', '" . $idFraisForfait . "')";
            mysql_query($req, $idconnexion);
            // passage au frais forfait suivant
            $ligne = mysql_fetch_assoc($idJeuRes);
        }
        mysql_free_result($idJeuRes);
    }
}

/**
 * Retourne le texte de la requéte select concernant les mois pour lesquels un 
 * visiteur a une fiche de frais. 
 * 
 * La requéte de sélection fournie permettra d'obtenir les mois (AAAAMM) pour 
 * lesquels le visiteur $unIdVisiteur a une fiche de frais. 
 * @param string $unIdVisiteur id visiteur 
 * @param char(2) $unEtat l etat des fiches 
 * @return string texte de la requéte select
 */
function obtenirReqMoisFicheFrais($unIdVisiteur, $unEtat) {
    $unIdVisiteur = filtrerChainePourBD($unIdVisiteur);
    $unEtat = filtrerChainePourBD($unEtat);
    if ($unEtat == null) {
        $req = "SELECT FicheFrais.mois AS mois FROM  FicheFrais WHERE FicheFrais.idVisiteur ='"
                . $unIdVisiteur . "'  ORDER BY FicheFrais.mois DESC ";
    } else {
        $req = "SELECT FicheFrais.mois AS mois FROM  FicheFrais WHERE FicheFrais.idVisiteur ='"
                . $unIdVisiteur . "' AND idEtat = '" . $unEtat . "'  ORDER BY FicheFrais.mois DESC ";
    }
    return $req;
}

/**
 * Retourne le texte de la requéte select concernant les éléments forfaitisés 
 * d'un visiteur pour un mois donnés. 
 * 
 * La requéte de sélection fournie permettra d'obtenir l'id, le libellé et la
 * quantité des éléments forfaitisés de la fiche de frais du visiteur
 * d'id $idVisiteur pour le mois $mois    
 * @param string $unMois mois demandé (MMAAAA)
 * @param string $unIdVisiteur id visiteur  
 * @return string texte de la requête select
 */
function obtenirReqEltsForfaitFicheFrais($unMois, $unIdVisiteur) {
    $unMois = filtrerChainePourBD($unMois);
    $requete = "SELECT idFraisForfait, libelle, quantite FROM LigneFraisForfait
              INNER JOIN FraisForfait ON FraisForfait.id = LigneFraisForfait.idFraisForfait
              WHERE idVisiteur='" . $unIdVisiteur . "' AND mois='" . $unMois . "'";
    return $requete;
}

/**
 * Retourne le texte de la requête select concernant les éléments hors forfait 
 * d'un visiteur pour un mois donnés. 
 * 
 * La requéte de sélection fournie permettra d'obtenir l'id, la date, le libellé 
 * et le montant des éléments hors forfait de la fiche de frais du visiteur
 * d'id $idVisiteur pour le mois $mois    
 * @param string $unMois mois demandé (MMAAAA)
 * @param string $unIdVisiteur id visiteur  
 * @return string texte de la requéte select
 */
function obtenirReqEltsHorsForfaitFicheFrais($unMois, $unIdVisiteur) {
    $unMois = filtrerChainePourBD($unMois);
    $requete = "SELECT id, date, libelle, montant FROM LigneFraisHorsForfait
              WHERE idVisiteur='" . $unIdVisiteur
            . "' AND mois='" . $unMois . "'";
    return $requete;
}

/**
 * Supprime une ligne hors forfait.
 * Supprime dans la BD la ligne hors forfait d'id $unIdLigneHF
 * @param resource $idconnexion identifiant de connexion
 * @param string $idLigneHF id de la ligne hors forfait
 * @return void
 */
function supprimerLigneHF($idconnexion, $unIdLigneHF) {
    $unIdLigneHF = filtrerChainePourBD($unIdLigneHF);
    $requete = "DELETE FROM LigneFraisHorsForfait WHERE id = " . $unIdLigneHF;
    mysql_query($requete, $idconnexion);
}

/**
 * Ajoute une nouvelle ligne hors forfait.
 * Insére dans la BD la ligne hors forfait de libellé $unLibelleHF du montant 
 * $unMontantHF ayant eu lieu à la date $uneDateHF pour la fiche de frais du mois
 * $unMois du visiteur d'id $unIdVisiteur
 * @param resource $idconnexion identifiant de connexion
 * @param string $unMois mois demandé (AAMMMM)
 * @param string $unIdVisiteur id du visiteur
 * @param string $uneDateHF date du frais hors forfait
 * @param string $unLibelleHF libellé du frais hors forfait 
 * @param double $unMontantHF montant du frais hors forfait
 * @return void
 */
function ajouterLigneHF($idconnexion, $unMois, $unIdVisiteur, $uneDateHF, $unLibelleHF, $unMontantHF) {
    $unLibelleHF = filtrerChainePourBD($unLibelleHF);
    $uneDateHF = filtrerChainePourBD(convertirDateFrancaisVersAnglais($uneDateHF));
    $unMois = filtrerChainePourBD($unMois);
    $req = "CALL ajoutLigneHF('" . $unMois . "','" . $unIdVisiteur . "',  '" . $uneDateHF . "', '" . $unLibelleHF . "', '" . $unMontantHF . "')";
    mysql_query($req, $idconnexion);
}

/**
 * Modifie les quantités des éléments forfaitisés d'une fiche de frais. 
 * Met à jour les éléments forfaitisés contenus  
 * dans $desEltsForfaits pour le visiteur $unIdVisiteur et
 * le mois $unMois dans la table LigneFraisForfait, après avoir filtré 
 * (annulé l'effet de certains caractéres considérés comme spéciaux par 
 *  MySql) chaque donnée   
 * @param resource $idconnexion identifiant de connexion
 * @param string $unMois mois demandé (MMAAAA) 
 * @param string $unIdVisiteur  id visiteur
 * @param array $desEltsForfait tableau des quantités des éléments hors forfait
 * avec pour clés les identifiants des frais forfaitisés 
 * @return void  
 */
function modifierEltsForfait($idconnexion, $unMois, $unIdVisiteur, $desEltsForfait) {
    $unMois = filtrerChainePourBD($unMois);
    $unIdVisiteur = filtrerChainePourBD($unIdVisiteur);
    foreach ($desEltsForfait as $idFraisForfait => $quantite) {
        $req = "CALL modifEltsForfait('" . $unIdVisiteur . "', '" . $idFraisForfait . "', '" . $unMois . "', '" . $quantite . "')";
        mysql_query($req, $idconnexion);
    }
}

/**
 * Contrôle les informations de connexionn d'un utilisateur.
 * Vérifie si les informations de connexion $unLogin, $unMdp sont ou non valides.
 * Retourne les informations de l'utilisateur sous forme de tableau associatif 
 * dont les clés sont les noms des colonnes (id, nom, prenom, login, mdp)
 * si login et mot de passe existent, le booléen false sinon. 
 * @param resource $idconnexion identifiant de connexion
 * @param string $unLogin login 
 * @param string $unMdp mot de passe 
 * @return array tableau associatif ou booléen false 
 */
function verifierInfosConnexion($idconnexion, $unLogin, $unMdp) {
    // le mot de passe est crypté dans la base avec la fonction de hachage sha1
    $unLogin = filtrerChainePourBD($unLogin);
    $unMdp = sha1(filtrerChainePourBD($unMdp));
    $req = "SELECT id, nom, prenom, login, mdp FROM Utilisateur WHERE login='" . $unLogin. "' AND mdp='" . $unMdp . "'";
    $idJeuRes = mysql_query($req, $idconnexion);
    $ligne = false;
    if ($idJeuRes) {
        $ligne = mysql_fetch_assoc($idJeuRes);
        mysql_free_result($idJeuRes);
    }
    return $ligne;
}

/**
 * Modifie l'état et la date de modification d'une fiche de frais

 * Met à jour l'état de la fiche de frais du visiteur $unIdVisiteur pour
 * le mois $unMois à la nouvelle valeur $unEtat et passe la date de modifé
 * la date d'aujourd'hui
 * @param resource $idconnexion identifiant de connexion
 * @param string $unIdVisiteur 
 * @param string $unMois mois sous la forme aaaamm
 * @return void 
 */
function modifierEtatFicheFrais($idconnexion, $unMois, $unIdVisiteur, $unEtat) {
    $unEtat = filtrerChainePourBD($unEtat);
    $unIdVisiteur = filtrerChainePourBD($unIdVisiteur);
    $unMois = filtrerChainePourBD($unMois);
    $req = "CALL modifFicheFrais('" . $unEtat . "', '" . $unIdVisiteur . "', '" . $unMois . "')";
    mysql_query($req, $idconnexion);
}

/**
 * fonction pour retourner la requête des utilisateurs "visiteur médicaux"
 * 
 * retourne la requête pour la liste des utilisateurs médicaux suivant l'ordre des nom
 * (id, nom, prenom)
 * @return string $req
 * @author jean-baptiste
 */
function obtenirReqListeVisiteur() {
    $req = "SELECT id,nom,prenom FROM Utilisateur WHERE idType = 'V' ORDER BY nom ASC";
    return $req;
}

/**
 * Cloture des fiches de frais antérieur au mois actuelle
 * 
 * permet de cloturé les fiches de frais du mois antérieure 
 * et si le cas nécésiste dans créer une.
 * @param resource $idconnexion id de connexion base de données
 * @param string $mois mois sous la forme aaaamm
 * @return void
 */
function cloturerFichesFrais($idconnexion, $unMois) {
    $unMois = filtrerChainePourBD($unMois);
    $req = "SELECT idVisiteur, mois FROM FicheFrais WHERE idEtat = 'CR' AND CAST(mois AS unsigned) < '" . $unMois . "'";
    $idJeuFichesFrais = mysql_query($req, $idconnexion);
    while ($lgFicheFrais = mysql_fetch_array($idJeuFichesFrais)) {
        modifierEtatFicheFrais($idconnexion, $lgFicheFrais['mois'], $lgFicheFrais['idVisiteur'], 'CL');
        //teste de l'existence de la fiche que l'on viens de modifier
        $existeFicheFrais = existeFicheFrais($idconnexion, $mois, $lgFicheFrais['idVisiteur']);
        //cas si la fiche n'est pas présente, on la créer
        if (!$existeFicheFrais) {
            ajouterFicheFrais($idconnexion, $mois, $lgFicheFrais['idVisiteur']);
        }
    }
}

/**
 * Modifie les quantités des éléments non forfaitisés d'une fiche de frais
 * 
 * Met à jour les éléments non forfatisés contenus dans le tableau $eltsHorsForfait
 * @param resource $idconnexion l'id de connexion à la base de données
 * @param array $eltsHorsForfait tableaux représentant les lignes hors forfait
 */
function modifierEltsHorsForfait($idconnexion, $eltsHorsForfait) {
    foreach ($eltsHorsForfait as $cle => $val) {
        switch ($cle) {
            case 'id':
                $idFraisHorsForfait = $val;
                break;
            case 'libelle':
                $libelleHorsForfait = $val;
                break;
            case 'date':
                $dateHorsForfait = $val;
                break;
            case 'montant':
                $montantHorsForfait = $val;
                break;
        }
        //modification des données
        $req = "CALL modifEltsHF('" . filtrerChainePourBD($libelleHorsForfait) . "', 
                '" . convertirDateFrancaisVersAnglais($dateHorsForfait) . "',
                '" . $montantHorsForfait . "',
                '" . filtrerChainePourBD($idFraisHorsForfait) . "')";
        mysql_query($req, $idconnexion);
    }
}

/**
 * Reporte d'un mois une ligne de frais hors forfait
 * 
 * Reporte la ligne hors forfait dont les justificatifs ne sont pas arrivés à temps
 * @param resource $idconnexion id de connexion
 * @param int $idLigneHorsForfait identifiant de la ligne hors forfait
 */
function reporterLigneHorsForfait($idconnexion, $idLigneHorsForfait) {
    $idLigneHorsForfait = filtrerChainePourBD($idLigneHorsForfait);
    $req = "CALL reportLigneHorsForfait('" . $idLigneHorsForfait . "')";
    //appel de la procédure stocké.
    mysql_query($req, $idconnexion);
}

/**
 * Modifie les justificatis d'une fiche de frais
 * 
 * Permet de mettre à jour la fiche de frais de l'utilisateur
 * pour apporter des justificatif
 * @param resource $idconnexion id de connexion a la base de données
 * @param string $unMois le mois retourné sous forme aaaamm
 * @param string $idUtilisateur l'identifiant de l'utilisateur(Visiteur)
 * @param int $nbrJustificatifs le nombre de justificatifs
 */
function modifierNbJustificatifsFicheFrais($idconnexion, $unMois, $idUtilisateur, $nbrJustificatifs) {
    $nbrJustificatifs = filtrerChainePourBD($nbrJustificatifs);
    $idUtilisateur = filtrerChainePourBD($idUtilisateur);
    $unMois = filtrerChainePourBD($unMois);
    $req = "CALL modifNbrJustificatifs('" . $nbrJustificatifs . "','" . $idUtilisateur . "','" . $unMois . "')";
    mysql_query($req, $idconnexion);
}

/**
 *  Retourne le type de véhicule de l'utilisateur séléctionné
 * 
 * Retourne les type de véhicule de l'utilisateur séléctionné 
 * pour le mois données. Cette fonction retourne son id,libelle,indemnite
 * @param resource $idconnexion id de connexion a la base de données
 * @param string $mois chaine de date au format aaaamm
 * @param string $idUtilisateur identifiant de l'utilisateur
 * @return array tableau des éléments du type de voiture ou false
 */
function obtenirTypeVehicule($idconnexion, $mois, $idUtilisateur) {
    $idUtilisateur = filtrerChainePourBD($idUtilisateur);
    $mois = filtrerChainePourBD($mois);
    $req = "SELECT id, libelleType, indemniteKm FROM TypeVehicule AS vehi INNER JOIN FicheFrais AS fich ON fich.idTypeVehicule = vehi.id WHERE idVisiteur='" . $idUtilisateur . "' AND mois='" . $mois . "'";
    $idJeuTypeVehicule = mysql_query($req, $idconnexion);
    $ligne = false;
    if ($idJeuTypeVehicule) {
        $ligne = mysql_fetch_array($idJeuTypeVehicule);
        //libération des ressources
        mysql_free_result($idJeuTypeVehicule);
    }
    return $ligne;
}

/**
 * Fonction qui retourne la requête des typeVehicule
 * 
 * Fonction qui permet de retourné la liste des Types de Véhicule
 * suivant l'ordre d'insertion dans la base de données.
 * @return string requête
 */
function obtenirReqListeTypesVehicules() {
    $req = "SELECT id, libelleType, indemniteKm FROM TypeVehicule ORDER BY id";
    return $req;
}

/**
 * Modifier le type de véhicule
 * 
 * Modifie le type de véhicule de la fiche de frais de l'utilisateur (visiteur médical)
 * pour le mois donné
 * @param resource $idconnexion identifiant de connexion base de données
 * @param string $idUtilisateur l'identifiant de l'utilisateur(visiteur)
 * @param string $mois le mois donnée sous la forme aaaamm
 * @param string $typeVehicule le type de végicule 
 * @return void
 */
function modifierTypeVehiculeFicheFrais($idconnexion, $idUtilisateur, $unMois, $typeVehicule) {
    $idUtilisateur = filtrerChainePourBD($idUtilisateur);
    $unMois = filtrerChainePourBD($unMois);
    $typeVehicule = filtrerChainePourBD($typeVehicule);
    $req = "CALL changementTypeVehicule('" . $typeVehicule . "', '" . $idUtilisateur . "' , '" . $unMois . "')";
    //envoie la requête de modification via une procédure stockée
    mysql_query($req, $idconnexion);
}

/**
 * obtenirReqFicheAPayer
 * 
 * permet de retourner la chaine de requete pour les fiches 
 * a payer.
 * @return string la chaine de la requête sql
 */
function obtenirReqFicheAPayer() {
    $req = "SELECT Utilisateur.id, nom, prenom, FicheFrais.mois, SUM(FraisF.montantForfaitNoKm + IndemKm.montantIndemKm) AS montantForfait,";
    $req .= "      (FicheFrais.montantValide - SUM(FraisF.montantForfaitNoKm + IndemKm.montantIndemKm)) AS montantHorsForfait, FicheFrais.montantValide AS totalFicheFrais";
    $req .= " FROM Utilisateur ";
    $req .= "      INNER JOIN FicheFrais ON (Utilisateur.id=FicheFrais.idVisiteur)";
    $req .= "      INNER JOIN (";
    $req .= "	     SELECT Utilisateur.id, FicheFrais.mois, SUM(LigneFraisForfait.quantite * FraisForfait.montant) AS montantForfaitNoKm";
    $req .= "         FROM Utilisateur INNER JOIN FicheFrais ON Utilisateur.id=FicheFrais.idVisiteur";
    $req .= "                          INNER JOIN LigneFraisForfait ON (FicheFrais.idVisiteur = LigneFraisForfait.idVisiteur  AND FicheFrais.mois = LigneFraisForfait.mois)";
    $req .= "                          INNER JOIN FraisForfait ON LigneFraisForfait.idFraisForfait = FraisForfait.id";
    $req .= "         WHERE FicheFrais.idEtat = 'VA'";
    $req .= "           AND Utilisateur.idType = 'V'";
    $req .= "           AND LigneFraisForfait.idFraisForfait != 'KM'";
    $req .= "	      GROUP BY Utilisateur.id, FicheFrais.mois";
    $req .= "         ) AS FraisF ON (FicheFrais.idVisiteur = FraisF.id AND FicheFrais.mois = FraisF.mois)";
    $req .= "      INNER JOIN(";
    $req .= "         SELECT Utilisateur.id, FicheFrais.mois, SUM(LigneFraisForfait.quantite * indemniteKm) AS montantIndemKm";
    $req .= "         FROM Utilisateur INNER JOIN FicheFrais ON Utilisateur.id=FicheFrais.idVisiteur";
    $req .= "                          INNER JOIN LigneFraisForfait ON (FicheFrais.idVisiteur = LigneFraisForfait.idVisiteur  AND FicheFrais.mois = LigneFraisForfait.mois)";
    $req .= "                          INNER JOIN TypeVehicule ON Fichefrais.idTypeVehicule = TypeVehicule.id";
    $req .= "         WHERE FicheFrais.idEtat = 'VA'";
    $req .= "           AND Utilisateur.idType = 'V'";
    $req .= "           AND LigneFraisForfait.idFraisForfait = 'KM'";
    $req .= "	      GROUP BY Utilisateur.id, FicheFrais.mois";
    $req .= "         ) AS IndemKm ON (FraisF.id = IndemKm.id AND FraisF.mois = IndemKm.mois)";
    $req .= " WHERE FicheFrais.idEtat = 'VA'";
    $req .= "   AND Utilisateur.idType = 'V'";
    $req .= " GROUP BY Utilisateur.id, nom, prenom, FicheFrais.mois";
    return $req;
}

?>
