#!/bin/bash

originalconfigfile=$1

cat $originalconfigfile;
. $originalconfigfile

echo -n 'export motifs_join="'
bash -c 'if test "'$motif_travail'" ; then echo -n "travail-"; fi ; if test "'$motif_courses'" ; then echo -n "courses-"; fi ;if test "'$motif_sante'" ; then echo -n "sante-"; fi ; if test "'$motif_famille'" ; then echo -n "famille-"; fi ; if test "'$motif_sport'" ; then echo -n "sport-"; fi ; if test "'$motif_judiciaire'" ; then echo -n "judiciaire-"; fi ; if test "'$motif_missions'" ; then echo -n "missions-"; fi ; ' | sed 's/-$//'
echo '"'
