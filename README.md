# Générateur d'attestation de déplacement dérogatoire COVID19

## Comment générer ?

Depuis votre console, à la racine du projet, tapez la commande ``make``.

Si vous n'avez pas de fichier de configuration, un assistant vous demandera de saisir les valeurs du formulaire.

L'attestation généré se trouve à la racine du projet sous le nom ``attestation.pdf``

**Attention :** La génération est basée sur Makefile qui utilise l'heure de votre système pour savoir ce qu'il doit être fait. Si vous souhaitez générer plusieurs attestations par minutes, veillez à *cleaner* avant de relancer une génération sinon l'attestation contiendra les données de la première exécution de la minute considérée :

    make clean ; make

### Docker

    Si vous avez Docker, vous pouvez également utilser la commande suivante pour lancer le make par l'intermédiaire de celui-ci :

    docker-compose up -d

## Quelles dépendances ?

    apt-get install inkscape gettext-base python-qrcode pdftk

## Comment ca fonctionne ?

Le fichier Makefile vient remplir une version SVG de l'attestation du ministère de l'intérieur et un qr code contenant les informations attendues est généré.
