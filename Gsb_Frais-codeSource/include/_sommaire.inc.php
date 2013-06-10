<?php
/** 
 * Contient la division pour le sommaire, sujet à des variations suivant la 
 * connexion ou non d'un utilisateur, et dans l'avenir, suivant le type de cet utilisateur 
 * @package Default
 * @author jeanbaptiste
 */

?>
    <!-- Division pour le sommaire -->
    <div id="menuGauche">
     <div id="infosUtil">
    <?php      
      if (estUtilisateurConnecte() ) {
          $idUser = obtenirIdUserConnecte() ;
          $lgUser = obtenirDetailUtilisateur($idConnexion, $idUser);
          $nom = $lgUser['nom'];
          $prenom = $lgUser['prenom'];
          $libelleType = $lgUser['libelleType'];
    ?>
        <h2>
    <?php  
            echo $nom . " " . $prenom ;
    ?>
        </h2>
         <h3>
             <?php
             echo $libelleType; 
             ?>
         </h3>        
    <?php
       }
    ?>  
      </div>  
<?php      
  if (estUtilisateurConnecte() ) {
?>
        <ul id="menuList">
           <li class="smenu">
              <a href="cAccueil.php" title="Page d'accueil">Accueil</a>
           </li>
           <li class="smenu">
              <a href="cSeDeconnecter.php" title="Se déconnecter">Se déconnecter</a>
           </li>
           
           <?php
                if($libelleType == "Visiteur médical"){
            ?>
           <li class="smenu">
              <a href="cSaisieFicheFrais.php" title="Saisie fiche de frais du mois courant">Saisie fiche de frais</a>
           </li>
           <li class="smenu">
              <a href="cConsultFichesFrais.php" title="Consultation de mes fiches de frais">Mes fiches de frais</a>
           </li>
       
        <?php
                }
                if($libelleType == "Comptable"){
         ?>
            <li class="smenu">
                <a href="cValidationDesFrais.php"
                   title="Validation des fiches de Frais du mois précédent">
                    Validation des fiches de frais
                </a>
            </li>
            <li class="smenu">
                <a href="cMisePaiementFicheFrais.php"
                   title="Mise en paiement des fiches de frais des visiteur médicaux">
                    Suivi des mises en paiement des fiches de frais
                </a>
                   
            </li> 
        </ul>
        <?php                    
                }
          // affichage des éventuelles erreurs déjà détectées
          if ( nbErreurs($tabErreurs) > 0 ) {
              echo toStringErreurs($tabErreurs) ;
          }
  }
        ?>
    </div>
    