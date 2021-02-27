# Comment mettre à jour le template d'attestation

Régulièrement le ministère met à jour le PDF d'attestation.

Voici un tuto très incomplet qui permet d'aider à dans cette tache :

1/ Générer un PDF depuis le site du gouvernement

Indiquer les informations qui sont proposées par défaut par le site. On les trouve également normalement dans ``config/config_test.inc``.

Sauver ce PDF dans ``exemples/attestation_originale.pdf``

2/ Mettre à jour les fichiers conf pour les tests

Changer les informations qui ont évoluer dans le fichier ``config/config_test.inc`` et ``exemples/output.txt``

3/ Transformer le PDF en SVG

    pdf2svg exemples/attestation_originale.pdf generation.svg 1

4/ Comparer le SVG avec le template et éditer le template

En général, j'utilise l'outil de diff ``meld`` pour identifier les parties qui ont changées.

    meld generation.svg templates/attestation_page1.svg.tmpl

En général le SVG produit est constitué d'une permière partie contenant la forme des lettres ayant comme identifiant de type ``glyph0-1``.

Le template instrument le SVG via des variables de templates qui permettent :

 - soit d'inscrire du texte comme ici avec l'inscription du prénom : https://github.com/teymour/attestation-covid19/blob/d3db55f1bc272290f8d67de1767692003832250d/templates/attestation_page1.svg.tmpl#L6550
 - soit de gérer des éléments de stle comme ici pour affiche la coche d'une case : https://github.com/teymour/attestation-covid19/blob/d3db55f1bc272290f8d67de1767692003832250d/templates/attestation_page1.svg.tmpl#L6577

Il se peut que de nouvelles options soient à ajouter. Il faut donc faire évoluer les fichiers :

 - ``templates/config_avec_multimotifs.sh``
 - ``exemples/output.txt``
 - ``templates/generate_config.sh`` 
 - ``config/config.inc.example``

Concernant le QRCode, la plus grosse difficulté est de le placé au pixel prêt. C'est réalisé ici : https://github.com/teymour/attestation-covid19/blob/d3db55f1bc272290f8d67de1767692003832250d/templates/attestation_page1.svg.tmpl#L6634

Pour l'édition du SVG, il m'arrive de le faire directement de meld, mais pour les grosses modifications il faut parfois passer par ``inkscape``. Dans ce cas, il faut ouvrir et manipuler le SVG généré via la commande : 

    make build/attestation_page1.svg

et tracker via ``meld`` ou ``diff`` les modifications utiles (inkscape est bavard et ajoute donc des choses peu intéressantes). 

4/ Tester votre modification

Une option de make permet de tester ses modifications pour voir si le PDF généré est bien (quasi) identique au PDF original :

    make test

Si le placement de tous les éléments et la génération du QRCode sont corrects, la règle make indique : 


    ====================================
              Tests concluants
    ====================================

Si ce n'est pas le cas, recommencer les étapes 4/ et 5/ (en général une 10aine de fois ;) ).

5/ Proposer une pull request sur ce dépot histoire que votre modification profite à tout le monde !! ;)
