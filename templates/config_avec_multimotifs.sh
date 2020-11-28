#!/bin/bash

originalconfigfile=$1

cat $originalconfigfile;
. $originalconfigfile

echo -n 'export motifs_join="'
bash -c 'if test "'$motif_travail'" ; then echo -n "travail, "; fi ; if test "'$motif_courses'" ; then echo -n "achats_culturel_cultuel, "; fi ;if test "'$motif_sante'" ; then echo -n "sante, "; fi ; if test "'$motif_famille'" ; then echo -n "famille, "; fi ; if test '"$motif_handicap"' ; then echo -n "handicap, " ; fi ;  if test "'$motif_sport'" ; then echo -n "sport_animaux, "; fi ; if test "'$motif_judiciaire'" ; then echo -n "convocation, "; fi ; if test "'$motif_missions'" ; then echo -n "missions, "; fi ; if test '"$motif_enfants"' ; then echo -n "enfants, " ; fi ; ' | sed 's/, $//'
echo '"'
