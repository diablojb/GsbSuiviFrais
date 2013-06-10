<?php
/**
 * script de contrôle et d'affiche du service de mise en paiement
 * des fiches de frais des utilisateur "visiteur médical"
 * @package default
 * @author jean-baptiste
 */
//les fichiers d'en-tête 
$repInclude = './include/';
require($repInclude . "_init.inc.php");

//verification de la connexion de l'utilisateur
if (!estUtilisateurConnecte()) {
    header("Location: cSeConnecter.php"); //redirection sur la page de connection
}
require($repInclude . "_entete.inc.html");
require($repInclude . "_sommaire.inc.php");

//mise en variables des données 
$idUtilisateur = lireDonnee("lstUtilisateur", "");
$idMois = lireDonnee("lstMois", "");
$etape = lireDonnee("etape", "");

//si l'étape et la mise en paiement de la fiche
if ($etape == "mettreEnPaiementFicheFrais") {
    //on appel la fonction modifierEtatFicheFrais avec un etat de MP
    modifierEtatFicheFrais($idConnexion, $idMois, $idUtilisateur, 'MP');
}
?>

<!-- Division principal -->
<div id="contenu">
    <h1>Suivi des paiements des fiches de frais</h1>
    <?php
    $lgVisiteur = obtenirDetailUtilisateur($idConnexion, $idUtilisateur);
    $numMois = intval(substr($idMois, 4, 2));
    $annee = intval(substr($idMois, 0, 4));
    if ($etape == "metreEnPaiementFicheFrais") {
        ?>
        <p class="info">La fiche de frais de <?php echo $lgVisiteur['nom'] . ' ' . $lgVisiteur['prenom']; ?>
            de <?php echo obtenirLibelleMois($numMois) . ' ' . $annee; ?> a bien été mise en paiement</p>
        <?php
    }

    $req = obtenirReqFicheAPayer();
    $idJeuFicheAPayer = mysql_query($req, $idConnexion);   
    unset($req);
    ?>
        <form id="frmChoixFichesAPayer" method="post" action="">
            <p>
                <input type="hidden" id="hdEtape" name="etape" value="mettreEnPaiementFicheFrais" />
                <input type="hidden" id="hdLstVisiteur" name="lstUtilisateur" value="" />
                <input type="hidden" id="hdLstMois" name="lstMois" value="" />
            </p>
            <div style="clear:left;"><h2>Fiches de frais validées</h2></div>
            <table style="color: white;" border="1">
                <tr>
                    <th rowspan="2" style="vertical-align: middle;">Visiteur&nbsp;médical</th>
                    <th rowspan="2" style="vertical-align: middle;">Mois</th>
                    <th colspan="3">Fiches de frais</th>
                    <th rowspan="2" style="vertical-align: middle;">Actions</th>
                </tr>
                <tr>
                    <th>Forfait</th>
                    <th>Hors forfait</th>
                    <th>Total</th>
                </tr>
                <?php
                while($lgFicheAPayer = mysql_fetch_array($idJeuFicheAPayer)){
                    $mois = $lgFicheAPayer['mois'];
                    $numMois = intval(substr($mois,4,2));
                    $annee = intval(substr($mois,0,4));
                    ?>
                <tr align="center">
                    <td style="width: 80px;white-space: nowrap;color: black;"><?php echo $lgFicheAPayer['nom'] . ' ' . $lgFicheAPayer['prenom'];?></td>
                    <td style="width: 80px;white-space: nowrap;color: black;"><?php echo obtenirLibelleMois($numMois) . ' ' . $annee;?></td>
                    <td style="width: 80px;white-space: nowrap;color: black;"><?php echo $lgFicheAPayer['montantForfait'];?></td>
                    <td style="width: 80px;white-space: nowrap;color: black;"><?php echo $lgFicheAPayer['montantHorsForfait'];?></td>
                    <td style="width: 80px;white-space: nowrap;color: black;"><?php echo $lgFicheAPayer['totalFicheFrais'];?></td>
                    <td style="width: 80px;white-space: nowrap;color: black;">  
                        <div id="actionFicheFrais<?php echo $lgFicheAPayer['id']; ?>" >
                        <a  onclick="mettreEnPaiementFicheFrais('<?php echo $lgFicheAPayer['id']; ?>','<?php echo $lgFicheAPayer['mois']; ?>');"
                           title="Mettre en paiement la fiche de frais">&nbsp;<img src="images/mettreEnPaiementIcon.png" class="icon" alt="Icone Mettre en Paiement" />
                            &nbsp;Mettre en paiement&nbsp;</a>
                        </div>
                    </td>
                </tr>
                <?php
                }
                ?>
            </table>
        </form>
</div>
<script type="text/javascript">
<?php 
require($repInclude . "_fonctionsMiseEnPaiement.inc.js");
?>
    </script>
<?php
//inclut les fichiers pour le pieds de la page
require($repInclude . "_pied.inc.html");
require($repInclude . "_fin.inc.php");
?>
