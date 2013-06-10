<?php
/** 
 * Initialise les ressources nécessaires au fonctionnement de l'application
 * @package default
 * @author jeanbaptiste
 */
  require("_bdGestionDonnees.lib.php");
  require("_gestionSession.lib.php");
  require("_utilitairesEtGestionErreurs.lib.php");
  // démarrage ou reprise de la session
  initSession();
  $tabErreurs = array();
    
  // Demande-t-on une déconnexion ?
  $demandeDeconnexion = lireDonneeUrl("cmdDeconnecter");
  if ( $demandeDeconnexion == "on") {
      deconnecterUtilisateur();
      header("Location: cAccueil.php");
  }
    
  // établissement d'une connexion avec le serveur de données 
  // puis sélection de la BD qui contient les données des utilisateurs et de leurs frais
  $idConnexion=connecterServeurBD();
  if (!$idConnexion) {
      ajouterErreur($tabErreurs, "Echec de la connexion au serveur MySql");
  }
  elseif (!activerBD($idConnexion)) {
      ajouterErreur($tabErreurs, "La base de données gsb_frais est inexistante ou non accessible");
  }
  
?>