    /**
     * Permet de mettre en paiement une fiche de frais
     * 
     * Permet de mettre en paiement une fiche de frais
     * avec idUtilisateur (Visiteur médical) 
     * idMois(l'identifiant du mois actuelle)
     * @param char(4) idVisiteur
     * @param char(6) idMois
     * @returns void
     */
    function mettreEnPaiementFicheFrais(idUtilisateur,idMois){
        document.getElementById("hdLstVisiteur").value = idUtilisateur;
        document.getElementById("hdLstMois").value = idMois;
        document.getElementById("frmChoixFichesAPayer").submit();
    };


