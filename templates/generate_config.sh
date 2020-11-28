echo -n "prenom : " > /dev/stderr ; read prenom; echo 'export prenom="'$prenom'"'
echo -n "nom : " > /dev/stderr ; read nom ; echo 'export nom="'$nom'"'
echo -n "date de naissance (JJ/MM/AAAA): " > /dev/stderr ; read naissance_date ; echo 'export naissance_date="'$naissance_date'"'
echo -n "lieu de naissance : " > /dev/stderr ; read naissance_lieu ; echo 'export naissance_lieu="'$naissance_lieu'"'
echo -n "adresse (rue code_postal ville): " > /dev/stderr ; read adresse ; echo 'export adresse="'$adresse'"'
echo -n "motif travail (x si vrai sinon vide): " > /dev/stderr ; read motif_travail ; echo 'export motif_travail="'$motif_travail'"'
echo -n "motif achats_culturel_cultuel (x si vrai sinon vide) : " > /dev/stderr ; read motif_courses ; echo 'export motif_courses="'$motif_courses'"'
echo -n "motif sante (x si vrai sinon vide) : " > /dev/stderr ; read motif_sante ; echo 'export motif_sante="'$motif_sante'"'
echo -n "motif famille (x si vrai sinon vide) : " > /dev/stderr ; read motif_famille ; echo 'export motif_famille="'$motif_famille'"'
echo -n "motif handicap (x si vrai sinon vide) : " > /dev/stderr ; read motif_handicap ; echo 'export motif_handicap="'$motif_handicap'"'
echo -n "motif sport_animaux (x si vrai sinon vide) : " > /dev/stderr ; read motif_sport ; echo 'export motif_sport="'$motif_sport'"'
echo -n "motif judiciaire (x si vrai sinon vide) : " > /dev/stderr ; read motif_judiciaire ; echo 'export motif_judiciaire="'$motif_judiciaire'"'
echo -n "motif missions (x si vrai sinon vide) : " > /dev/stderr ; read motif_missions ;  echo 'export motif_missions="'$motif_missions'"'
echo -n "motif enfants (x si vrai sinon vide) : " > /dev/stderr ; read motif_enfants ;  echo 'export motif_enfants="'$motif_enfants'"'
echo -n "lieu de signature (même ville que adresse) : " > /dev/stderr ; read fait_lieu ; echo 'export fait_lieu="'$fait_lieu'"'
echo -n "date de signature (JJ/MM/AAAA, si vide la date courante sera utilisée) : " > /dev/stderr ; read fait_date ;
if test ! "$fait_date"; then fait_date='`date +"%d/%m/%Y"`' ; creation_date='`date --date="16 minutes ago" +"%d/%m/%Y"`'  ; fi
echo 'export fait_date="'$fait_date'"'
echo -n "heure de signature (06 pour 6h45, si vide l'heure courante sera utilisée) : " > /dev/stderr ; read fait_heures ;
if ! test "$fait_heures"; then fait_heures='`date +"%H"`' ; creation_heures='`date --date="16 minutes ago" +"%H"`'  ;  fi
echo 'export fait_heures="'$fait_heures'"'
echo -n "minute de signature (45 pour 6h45, si vide l'heure courante sera utilisée) : " > /dev/stderr ; read fait_minutes ;
if ! test "$fait_minutes"; then fait_minutes='`date +"%M"`' ; creation_minutes='`date --date="16 minutes ago" +"%M"`'  ;  fi
echo 'export fait_minutes="'$fait_minutes'"'
if test ! "$creation_date"; then creation_date="$fait_date" ; fi
echo 'export creation_date="'$creation_date'"'
if test ! "$creation_heures"; then creation_heures="$fait_heures" ; fi
echo 'export creation_heures="'$creation_heures'"'
if test ! "$creation_minutes"; then creation_minutes="$fait_minutes" ; fi
echo 'export creation_minutes="'$creation_minutes'"'
echo
