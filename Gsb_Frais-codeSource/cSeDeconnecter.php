<?php  
/** 
 * Script de contrôle et d'affichage du cas d'utilisation "Se déconnecter"
 * @package default
 * @author jeanbaptiste
 */
  $repInclude = './include/';
  require($repInclude . "_init.inc.php");
  
  deconnecterUtilisateur();  
  header("Location:cSeConnecter.php");
  
?>