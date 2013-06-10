<?php
/**
 * Page pour la validation des frais et le contrôle de la validation des fiches de frais
 * @package default
 * @author jeanbaptiste
 */
//fichiers d'initialisation
$repInclude = './include/';
require($repInclude . "_init.inc.php");

// vérification de l'utilisateur s'il est bien en ligne
if (!estUtilisateurConnecte()) {
    header("Location: cSeConnecter.php");
}
//fichier d'entête si l'utilisateur est bien connecté
require($repInclude . "_entete.inc.html");
require($repInclude . "_sommaire.inc.php");

// affectation du mois précédent pour la validation des fiches de frais
$mois = sprintf("%04d%02d", date("Y"), date("m"));
// Cloture des fiches de frais antérieur au mois courant et au besoin, création des fiches pour le mois courant
cloturerFichesFrais($idConnexion, $mois);

// acquisition des données entrées depuis le code , ici l'id de visiteur, le mois et l'étape du traitement
$visiteurChoisi = lireDonnee("lstVisiteur", "");
$moisChoisi = lireDonnee("lstMois", "");
$nouveauTypeVehicule = lireDonnee("lstVehicule", "");
$etape = lireDonnee("etape", "");
// acquisition des quantités des éléments forfaitisés 
$tabQteEltsForfait = lireDonneePost("txtEltsForfait", "");
// acquisition des informations des éléments hors forfait
$tabEltsHorsForfait = lireDonneePost("txtEltsHorsForfait", "");
$nbJustificatifs = lireDonneePost("nbJustificatifs", "");
// structure de décision sur les différentes étapes du cas d'utilisation
if ($etape == "choixVisiteur") {
// L'utilisateur a choisi un visiteur
} elseif ($etape == "choixMois") {
// L'utilisateur a choisi un mois
} elseif ($etape == "actualiserVehicule") {
    // L'utilisateur actualise le type de vehicule
    modifierTypeVehiculeFicheFrais($idConnexion, $visiteurChoisi, $moisChoisi, $nouveauTypeVehicule);
} elseif ($etape == "actualiserFraisForfait") {
// L'utilisateur actualise les informations des frais forfaitisés
// l'utilisateur valide les éléments forfaitisés         
// vérification des quantités des éléments forfaitisés
    $ok = verifierEntiersPositifs($tabQteEltsForfait);
    if (!$ok) {
        ajouterErreur($tabErreurs, "Chaque quantité doit être renseignée et être un nombre positif.");
    } else { // mise à jour des quantités des éléments forfaitisés
        modifierEltsForfait($idConnexion, $moisChoisi, $visiteurChoisi, $tabQteEltsForfait);
    }
} elseif ($etape == "actualiserFraisHorsForfait") {
// L'utilisateur actualise les informations des frais hors forfait
// l'utilisateur valide les éléments non forfaitisés      
// Une suppression est donc considérée comme une actualisation puisque c'est 
// le libellé qui est mis à jour   
    foreach ($tabEltsHorsForfait as $cle => $val) {        
        switch ($cle) {
            case 'id':
                break;
            case 'libelle':
                $libelleFraisHorsForfait = $val;
                break;
            case 'date':
                $dateFraisHorsForfait = $val;
                break;
            case 'montant':
                $montantFraisHorsForfait = $val;
                break;
        }
    // vérification de la validité des données d'une ligne de frais hors forfait
    verifierLigneFraisHF($dateFraisHorsForfait, $libelleFraisHorsForfait, $montantFraisHorsForfait, $tabEltsHorsForfait);
    }

    if (nbErreurs($tabErreurs) == 0) {
// mise à jour des quantités des éléments non forfaitisés
        modifierEltsHorsForfait($idConnexion, $tabEltsHorsForfait);
    }
} elseif ($etape == "reporterLigneFraisHF") {
// L'utilisateur demande le report d'une ligne hors forfait dont les justificatifs ne sont pas arrivés à temps
    reporterLigneHorsForfait($idConnexion, $tabEltsHorsForfait['id']);
} elseif ($etape == "actualiserNbJustificatifs") {
// L'utilisateur actualise le nombre de justificatifs
    $ok = estEntierPositif($nbJustificatifs);
    if (!$ok) {
        ajouterErreur($tabErreurs, "Le nombre de justificatifs doit être renseigné et positif.");
    } else {
// mise à jour du nombre de justificatifs
        modifierNbJustificatifsFicheFrais($idConnexion, $moisChoisi, $visiteurChoisi, $nbJustificatifs);
    }
} elseif ($etape == "validerFiche") {
// L'utilisateur valide la fiche
    modifierEtatFicheFrais($idConnexion, $moisChoisi, $visiteurChoisi, 'VA');
}
?>

<!-- Division principale -->
<div id="contenu">
    <h1>Validation des frais par visiteur </h1>
    <?php
    // Gestion des messages d'informations
    if ($etape == "actualiserVehicule") {
        if (nbErreurs($tabErreurs) > 0) {
            echo toStringErreurs($tabErreurs);
        } else {
            ?>
            <p class="info">L'actualisation du type de véhicule a bien été enregistré</p>        
            <?php
        }
    }
    if ($etape == "actualiserFraisForfait") {
        if (nbErreurs($tabErreurs) > 0) {
            echo toStringErreurs($tabErreurs);
        } else {
            ?>
            <p class="info">L'actualisation des quantités au forfait a bien été enregistrée</p>        
            <?php
        }
    }
    if ($etape == "actualiserFraisHorsForfait") {
        if (nbErreurs($tabErreurs) > 0) {
            echo toStringErreurs($tabErreurs);
        } else {
            ?>
            <p class="info">L'actualisation de la ligne de frais hors forfait a bien été enregistrée</p>        
            <?php
        }
    }
    if ($etape == "reporterLigneFraisHF") {
        ?>
        <p class="info">La ligne de frais hors forfait a bien été reportée</p>        
        <?php
    }
    if ($etape == "actualiserNbJustificatifs") {
        if (nbErreurs($tabErreurs) > 0) {
            echo toStringErreurs($tabErreurs);
        } else {
            ?>
            <p class="info">L'actualisation du nombre de justificatifs a bien été enregistré</p>        
            <?php
        }
    }
    if ($etape == "validerFiche") {
        $lgVisiteur = obtenirDetailUtilisateur($idConnexion, $visiteurChoisi);
        ?>
        <p class="info">La fiche de frais du visiteur <?php echo $lgVisiteur['prenom'] . " " . $lgVisiteur['nom']; ?> pour <?php echo obtenirLibelleMois(intval(substr($moisChoisi, 4, 2))) . " " . intval(substr($moisChoisi, 0, 4)); ?> a bien été enregistrée</p>        
        <?php
        // On réinitialise le mois choisi pour forcer la disparition du bas de page, la réactualisation des mois et le choix d'un nouveau mois
        $moisChoisi = "";
    }
    ?>
    <form id="frmChoixVisiteur" method="post" action="">
        <p>
            <input type="hidden" name="etape" value="choixVisiteur" />
            <label class="titre">Choisir le visiteur :</label>
            <select name="lstVisiteur" id="lstIdVisiteur" onchange="changerVisiteur(this.options[this.selectedIndex].value);">
                <?php
                // Si aucun visiteur n'a encore été choisi, on place en premier une invitation au choix
                if ($visiteurChoisi == "") {
                    ?>
                    <option value="-1">Rechercher le visiteur médical</option>
                    <?php
                }
                // On propose tous les utilisateurs qui sont des visteurs médicaux
                $req = obtenirReqListeVisiteur();
                $idJeuVisiteurs = mysql_query($req, $idConnexion);
                while ($lgVisiteur = mysql_fetch_array($idJeuVisiteurs)) {
                    ?>
                    <option value="<?php echo filtrerChainePourNavig($lgVisiteur['id']); ?>"<?php if ($visiteurChoisi == $lgVisiteur['id']) { ?> selected="selected"<?php } ?>><?php echo filtrerChainePourNavig($lgVisiteur['nom']) . " " . filtrerChainePourNavig($lgVisiteur['prenom']); ?></option>
                    <?php
                }
                mysql_free_result($idJeuVisiteurs);
                ?>
            </select>
        </p>
    </form>
    <?php
// Si aucun visiteur n'a encore été choisi on n'affiche pas le form de choix de mois
    if ($visiteurChoisi != "") {
        ?>
        <form id="frmChoixMois" method="post" action="">
            <p>
                <input type="hidden" name="etape" value="choixMois" />
                <input type="hidden" name="lstVisiteur" value="<?php echo $visiteurChoisi; ?>" />
                <?php
                // On propose tous les mois pour lesquels le visiteur dispose d'une fiche de frais cloturée
                $req = obtenirReqMoisFicheFrais($visiteurChoisi, 'CL');
                $idJeuMois = mysql_query($req, $idConnexion);
                $lgMois = mysql_fetch_assoc($idJeuMois);
                // 4-a Aucune fiche de frais n'existe le système affiche "Pas de fiche de frais pour ce visiteur ce mois". Retour au 2
                if (empty($lgMois)) {
                    ajouterErreur($tabErreurs, "Pas de fiche de frais à valider pour ce visiteur, veuillez choisir un autre visiteur");
                    echo toStringErreurs($tabErreurs);
                } else {
                    ?>
                    <label >Mois :</label>
                    <select name="lstMois" id="lstIdDateValid"  onchange="javascript:this.form.submit();">
                        <?php
                        // Si aucun mois n'a encore été choisi, on place en premier une invitation au choix
                        if ($moisChoisi == "") {
                            ?>
                            <option value="-1">Quel mois?</option>
                            <?php
                        }
                        while (is_array($lgMois)) {
                            $mois = $lgMois["mois"];
                            $noMois = intval(substr($mois, 4, 2));
                            $annee = intval(substr($mois, 0, 4));
                            ?>    
                            <option value="<?php echo $mois; ?>"<?php if ($moisChoisi == $mois) { ?> selected="selected"<?php } ?>><?php echo obtenirLibelleMois($noMois) . ' ' . $annee; ?></option>
                            <?php
                            $lgMois = mysql_fetch_assoc($idJeuMois);
                        }
                        mysql_free_result($idJeuMois);
                    }
                    ?>            
                </select>
            </p>        
        </form>
        <?php
    }
// On n'affiche le form de Gestion de Frais que s'il y a un mois qui a été sélectionné
    if ($visiteurChoisi != "" && $moisChoisi != "") {
        // Traitement des frais si un visiteur et un mois ont été choisis
        $req = obtenirReqEltsForfaitFicheFrais($moisChoisi, $visiteurChoisi);
        $idJeuEltsForfait = mysql_query($req, $idConnexion);
        unset($req);
        $lgEltsForfait = mysql_fetch_assoc($idJeuEltsForfait);
        while (is_array($lgEltsForfait)) {
            // On place la bonne valeur en fonction de l'identifiant de forfait
            switch ($lgEltsForfait['idFraisForfait']) {
                case "ETP":
                    $etp = $lgEltsForfait['quantite'];
                    break;
                case "KM":
                    $km = $lgEltsForfait['quantite'];
                    break;
                case "NUI":
                    $nui = $lgEltsForfait['quantite'];
                    break;
                case "REP":
                    $rep = $lgEltsForfait['quantite'];
                    break;
            }
            $lgEltsForfait = mysql_fetch_assoc($idJeuEltsForfait);
        }
        mysql_free_result($idJeuEltsForfait);
        ?>
        <form id="frmChoixVehicule" method="post" action="">
            <table style="border:none;" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="border:none;">
                        <p>
                            <input type="hidden" name="etape" value="actualiserVehicule" />
                            <input type="hidden" name="lstVisiteur" value="<?php echo $visiteurChoisi; ?>" />
                            <input type="hidden" name="lstMois" value="<?php echo $moisChoisi; ?>" />
                            <label class="titre">Choisir le véhicule :</label>
                            <select name="lstVehicule" id="lstIdVehicule"  onchange="afficheMsgInfosChangerVehicule();">
                                <?php
                                $typeVehicule = obtenirTypeVehicule($idConnexion, $moisChoisi, $visiteurChoisi);
                                // Si aucun vehicule n'a encore été déclaré, on place en premier une invitation au choix
                                if (!$typeVehicule) {
                                    ?>
                                    <option value="-1">Séléctionné un type de véhicule</option>
                                    <?php
                                }
                                // On propose tous les types de véhicules
                                $req = obtenirReqListeTypesVehicules();
                                $idJeuVehicules = mysql_query($req, $idConnexion);
                                while ($lgVehicule = mysql_fetch_array($idJeuVehicules)) {
                                    ?>
                                    <option value="<?php echo $lgVehicule['id']; ?>"<?php if ($typeVehicule != false and $typeVehicule['id'] == $lgVehicule['id']) { ?> selected="selected"<?php } ?>><?php echo filtrerChainePourNavig($lgVehicule['libelleType']) . " (" . $lgVehicule['indemniteKm']. ")"; ?></option>
                                    <?php
                                }
                                mysql_free_result($idJeuVehicules);
                                ?>
                            </select>
                        </p>
                    </td>
                    <td style="border:none;">
                        <div id="actionsChoixVehicule">
                            <a class="infoAction"  id="lkActualiserTypeVehicule" onclick="actualiserTypeVehicule('<?php echo $typeVehicule['id']; ?>', '<?php echo $typeVehicule['libelleType']; ?>');" title="Actualiser le type de véhicule">&nbsp;<img src="images/actualiserIcon.png" class="icon" alt="icone Actualiser" />&nbsp;Actualiser&nbsp;</a>
                            <a class="infoAction" id="lkReinitialiserTypeVehicule" onclick="reinitialiserTypeVehicule();" title="Réinitialiser le type de véhicule">&nbsp;<img src="images/reinitialiserIcon.png" class="icon" alt="icone Réinitialiser" />&nbsp;Réinitialiser&nbsp;</a>
                        </div>
                    </td>
                </tr>
            </table>
        </form>
        <div id="msgTypeVehicule" class="infoAction">Attention, la modification doit être actualisée pour être réellement prises en compte...</div>
        <form id="frmFraisForfait" method="post" action="">
            <p>
                <input type="hidden" name="etape" value="actualiserFraisForfait" />
                <input type="hidden" name="lstVisiteur" value="<?php echo $visiteurChoisi; ?>" />
                <input type="hidden" name="lstMois" value="<?php echo $moisChoisi; ?>" />
            </p>
            <div style="clear:left;"><h2>Frais au forfait</h2></div>
            <table style="color:white;" border="1">
                <tr><th>Repas midi</th><th>Nuitée </th><th>Etape</th><th>Km </th><th>Actions</th></tr>
                <tr align="center">
                    <td style="width:80px;"><input type="text" size="3" id="idREP" name="txtEltsForfait[REP]" value="<?php echo $rep; ?>" style="text-align:right;" onchange="afficheMsgInfosForfaitAActualisees();" /></td>
                    <td style="width:80px;"><input type="text" size="3" id="idNUI" name="txtEltsForfait[NUI]" value="<?php echo $nui; ?>" style="text-align:right;" onchange="afficheMsgInfosForfaitAActualisees();" /></td> 
                    <td style="width:80px;"><input type="text" size="3" id="idETP" name="txtEltsForfait[ETP]" value="<?php echo $etp; ?>" style="text-align:right;" onchange="afficheMsgInfosForfaitAActualisees();" /></td>
                    <td style="width:80px;"><input type="text" size="3" id="idKM" name="txtEltsForfait[KM]" value="<?php echo $km; ?>" style="text-align:right;" onchange="afficheMsgInfosForfaitAActualisees();" /></td>
                    <td>
                        <div id="actionsFraisForfait" >
                            <a class="infoAction" id="lkActualiserLigneFraisForfait" onclick="actualiserLigneFraisForfait(<?php echo $rep; ?>,<?php echo $nui; ?>,<?php echo $etp; ?>,<?php echo $km; ?>);" title="Actualiser la ligne de frais forfaitisé">&nbsp;<img src="images/actualiserIcon.png" class="icon" alt="icone Actualiser" />&nbsp;Actualiser&nbsp;</a>
                            <a class="infoAction" id="lkReinitialiserLigneFraisForfait" onclick="reinitialiserLigneFraisForfait();" title="Réinitialiser la ligne de frais forfaitisé">&nbsp;<img src="images/reinitialiserIcon.png" class="icon" alt="icone Réinitialiser" />&nbsp;Réinitialiser&nbsp;</a>
                        </div>
                    </td>
                </tr>
            </table>
        </form>
        <div id="msgFraisForfait" class="infoAction">Attention, les modifications doivent être actualisées pour être réellement prises en compte...</div>
        <p class="titre">&nbsp;</p>
        <div style="clear:left;"><h2>Hors forfait</h2></div>
        <?php
        // On récupère les lignes hors forfaits
        $req = obtenirReqEltsHorsForfaitFicheFrais($moisChoisi, $visiteurChoisi);
        $idJeuEltsHorsForfait = mysql_query($req, $idConnexion);
        $lgEltsHorsForfait = mysql_fetch_assoc($idJeuEltsHorsForfait);
        while (is_array($lgEltsHorsForfait)) {
            ?>
            <form id="frmFraisHorsForfait<?php echo $lgEltsHorsForfait['id']; ?>" method="post" action="">
                <p>
                    <input type="hidden" id="idEtape<?php echo $lgEltsHorsForfait['id']; ?>" name="etape" value="actualiserFraisHorsForfait" />
                    <input type="hidden" name="lstVisiteur" value="<?php echo $visiteurChoisi; ?>" />
                    <input type="hidden" name="lstMois" value="<?php echo $moisChoisi; ?>" />
                    <input type="hidden" name="txtEltsHorsForfait[id]" value="<?php echo $lgEltsHorsForfait['id']; ?>" />
                </p>
                <table style="color:white;" border="1">
                    <tr><th>Date</th><th>Libellé </th><th>Montant</th><th>Actions</th></tr>
                    <?php
                    // Si les frais n'ont pas déjà été refusés, on affiche normalement
                    if (strpos(filtrerChainePourNavig($lgEltsHorsForfait['libelle']), 'REFUSÉ : ') === false) {
                        ?>
                        <tr>
                            <?php
                        }
                        // Sinon on met la ligne en grisée
                        else {
                            ?>
                        <tr style="background-color:gainsboro;">
                            <?php
                        }
                        ?>                          
                        <td style="width:100px;"><input type="text" size="12" id="idDate<?php echo $lgEltsHorsForfait['id']; ?>" name="txtEltsHorsForfait[date]" value="<?php echo convertirDateAnglaisVersFrancais($lgEltsHorsForfait['date']); ?>" onchange="afficheMsgInfosHorsForfaitAActualisees(<?php echo $lgEltsHorsForfait['id']; ?>);" /></td>
                        <td style="width:220px;"><input type="text" size="30" id="idLibelle<?php echo $lgEltsHorsForfait['id']; ?>" name="txtEltsHorsForfait[libelle]" value="<?php echo filtrerChainePourNavig($lgEltsHorsForfait['libelle']); ?>" onchange="afficheMsgInfosHorsForfaitAActualisees(<?php echo $lgEltsHorsForfait['id']; ?>);" /></td> 
                        <td style="width:90px;"><input type="text" size="10" id="idMontant<?php echo $lgEltsHorsForfait['id']; ?>" name="txtEltsHorsForfait[montant]" value="<?php echo $lgEltsHorsForfait['montant']; ?>" style="text-align:right;" onchange="afficheMsgInfosHorsForfaitAActualisees(<?php echo $lgEltsHorsForfait['id']; ?>);" /></td>
                        <td>
                            <div id="actionsFraisHorsForfait<?php echo $lgEltsHorsForfait['id']; ?>" >
                                <a class="infoAction" id="lkActualiserLigneFraisHF<?php echo $lgEltsHorsForfait['id']; ?>" onclick="actualiserLigneFraisHF(<?php echo $lgEltsHorsForfait['id']; ?>, '<?php echo convertirDateAnglaisVersFrancais($lgEltsHorsForfait['date']); ?>', '<?php echo filtrerChainePourBD($lgEltsHorsForfait['libelle']); ?>',<?php echo $lgEltsHorsForfait['montant']; ?>);" title="Actualiser la ligne de frais hors forfait">&nbsp;<img src="images/actualiserIcon.png" class="icon" alt="icone Actualiser" />&nbsp;Actualiser&nbsp;</a>
                                <a class="infoAction" id="lkReinitialiserLigneFraisHF<?php echo $lgEltsHorsForfait['id']; ?>" onclick="reinitialiserLigneFraisHorsForfait(<?php echo $lgEltsHorsForfait['id']; ?>);" title="Réinitialiser la ligne de frais hors forfait">&nbsp;<img src="images/reinitialiserIcon.png" class="icon" alt="icone Réinitialiser" />&nbsp;Réinitialiser&nbsp;</a>
                                <?php
                                // L'option "Supprimer" n'est proposée que si les frais n'ont pas déjà été refusés
                                if (strpos($lgEltsHorsForfait['libelle'], 'REFUSÉ : ') === false) {
                                    ?>
                                    <a class="infoAction" onclick="reporterLigneFraisHF(<?php echo $lgEltsHorsForfait['id']; ?>);" title="Reporter la ligne de frais hors forfait">&nbsp;<img src="images/reporterIcon.png" class="icon" alt="icone Reporter" />&nbsp;Reporter&nbsp;</a>
                                    <a class="infoAction" onclick="refuseLigneFraisHF(<?php echo $lgEltsHorsForfait['id']; ?>);" title="Supprimer la ligne de frais hors forfait">&nbsp;<img src="images/refuserIcon.png" class="icon" alt="icone Supprimer" />&nbsp;Supprimer&nbsp;</a>
                                    <?php
                                } else {
                                    ?>
                                    <a class="infoAction" onclick="reintegrerLigneFraisHF(<?php echo $lgEltsHorsForfait['id']; ?>);" title="Réintégrer la ligne de frais hors forfait">&nbsp;<img src="images/reintegrerIcon.png" class="icon" alt="icone Réintégrer" />&nbsp;Réintégrer&nbsp;</a>
                                    <?php
                                }
                                ?>
                            </div>
                        </td>
                    </tr>
                </table>
            </form>
            <div id="msgFraisHorsForfait<?php echo $lgEltsHorsForfait['id']; ?>" class="infoAction">Attention, les modifications doivent être actualisées pour être réellement prises en compte...</div>
            <?php
            $lgEltsHorsForfait = mysql_fetch_assoc($idJeuEltsHorsForfait);
        }
        ?>
        <form id="frmNbJustificatifs" method="post" action="">
            <p>
                <input type="hidden" name="etape" value="actualiserNbJustificatifs" />
                <input type="hidden" name="lstVisiteur" value="<?php echo $visiteurChoisi; ?>" />
                <input type="hidden" name="lstMois" value="<?php echo $moisChoisi; ?>" />
            </p>
            <div class="titre">Nombre de justificatifs :
                <?php
                $laFicheFrais = obtenirDetailFicheFrais($idConnexion, $moisChoisi, $visiteurChoisi);
                ?>
                <input type="text" class="zone" size="4" id="idNbJustificatifs" name="nbJustificatifs" value="<?php echo $laFicheFrais['nbJustificatifs']; ?>" style="text-align:center;" onchange="afficheMsgNbJustificatifs();" />
                <div id="actionsNbJustificatifs" >
                    <a class="infoAction" id="lkActualiserNbJustificatifs" onclick="actualiserNbJustificatifs(<?php echo $laFicheFrais['nbJustificatifs']; ?>);" title="Actualiser le nombre de justificatifs">&nbsp;<img src="images/actualiserIcon.png" class="icon" alt="icone Actualiser" />&nbsp;Actualiser&nbsp;</a>
                    <a class="infoAction" id="lkReinitialiserNbJustificatifs" onclick="reinitialiserNbJustificatifs();" title="Réinitialiser le nombre de justificatifs">&nbsp;<img src="images/reinitialiserIcon.png" class="icon" alt="icone Réinitialiser" />&nbsp;Réinitialiser&nbsp;</a>
                </div>
            </div>
        </form>
        <div id="msgNbJustificatifs" class="infoAction">Attention, le nombre de justificatifs doit être actualisé pour être réellement pris en compte...</div>

        <form id="frmValidFiche" method="post" action="">
            <p>
                <input type="hidden" name="etape" value="validerFiche" />
                <input type="hidden" name="lstVisiteur" value="<?php echo $visiteurChoisi; ?>" />
                <input type="hidden" name="lstMois" value="<?php echo $moisChoisi; ?>" />
                <input class="zone" type="button" onclick="changerVisiteur();" value="Changer de visiteur" />
                <input class="zone" type="button" onclick="validerFiche();" value="Valider cette fiche" />
            </p>
        </form>

        <?php
    }
    ?>
</div>

<script type="text/javascript">
<?php
require($repInclude . "_fonctionsValidFichesFrais.inc.js");
?>
</script>
<?php
require($repInclude . "_pied.inc.html");
require($repInclude . "_fin.inc.php");
?>