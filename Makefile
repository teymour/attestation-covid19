config_file=config/config.inc
output_file=attestation.pdf
build_path=build
qr_bin=qr

all: $(output_file)

config: cleanconfig $(config_file)

ifupdateneeded: $(config_file)
	if grep "date +" $(config_file) > /dev/null ; then touch $(config_file) ; fi

$(output_file): $(build_path)/attestation_page1.pdf $(build_path)/attestation_page2.pdf
	pdftk $^ cat output $@

$(build_path)/attestation_page%.pdf: $(build_path)/attestation_page%.svg
	inkscape --export-pdf=$@ $<

$(build_path)/attestation_page1.svg: $(build_path)/config.inc $(build_path)/qr.inc templates/attestation_page1.svg.tmpl
	bash -c "source $(build_path)/config.inc ; source $(build_path)/qr.inc; envsubst < templates/attestation_page1.svg.tmpl  > $(build_path)/attestation_page1.svg"

$(build_path)/attestation_page2.svg: $(build_path)/qr.inc templates/attestation_page2.svg.tmpl
	bash -c "source $(build_path)/qr.inc; envsubst < templates/attestation_page2.svg.tmpl  > $(build_path)/attestation_page2.svg"

$(build_path)/qr.inc: $(build_path)/qr.png
		echo -n "export qrcode=\"" > $(build_path)/qr.inc
		base64 < $(build_path)/qr.png | tr '\n' ' ' | sed 's/ //g' >> $(build_path)/qr.inc
		echo '"' >> $(build_path)/qr.inc

$(build_path)/qr.png: $(build_path)/qr.txt
	cat $(build_path)/qr.txt | $(qr_bin) > $(build_path)/qr.png

$(build_path)/qr.txt: $(build_path)/config.inc templates/qr.txt.tmpl $(build_path)/.created
	bash -c "source $(build_path)/config.inc ; cat templates/qr.txt.tmpl | tr -d '\n' | envsubst > $(build_path)/qr.txt"

$(build_path)/config.inc: $(build_path)/.created $(config_file)
	bash templates/config_avec_multimotifs.sh $(config_file) > $(build_path)/config.inc

$(config_file):
	bash templates/generate_config.sh > $(config_file)

$(build_path)/.created:
	mkdir -p $(build_path)
	touch $(build_path)/.created

clean:
	rm -f $(build_path)/* $(output_file)

cleanconfig:
	rm $(config_file)

test: generatetestfile
	config_file=config/config_test.inc make -e realtest 

realtest: clean generatetestfile testqrcode testpages clean
	rm -rf $(build_path)/* $(output_file) config/config_test.inc
	printf "\n\n\n====================================\n          Tests concluants\n====================================\n\n\n"

generatetestfile: exemples/output.txt
	cat exemples/output.txt | bash templates/generate_config.sh > config/config_test.inc 2> /dev/null

testqrcode: $(build_path)/pdf_page-0.txt $(build_path)/pdf_page-1.txt $(build_path)/pdforiginal_page-0.txt $(build_path)/pdforiginal_page-1.txt
	diff $(build_path)/pdf_page-0.txt $(build_path)/pdforiginal_page-0.txt && echo QRCODE page 1 OK
	diff $(build_path)/pdf_page-1.txt $(build_path)/pdforiginal_page-1.txt && echo QRCODE page 2 OK

testpages: $(build_path)/diff_page-0.jpg $(build_path)/diff_page-1.jpg

$(build_path)/diff_page-%.jpg: $(build_path)/pdf_page-%.jpg $(build_path)/pdforiginal_page-%.jpg
	perceptualdiff --threshold 1200 $^ --output $@ && echo Page OK

$(build_path)/pdf_page-%.jpg: $(build_path)/pdf_page.pdf
	convert -size 2000x2000 $(build_path)/pdf_page.pdf $(build_path)/pdf_page.jpg

$(build_path)/pdforiginal_page-%.jpg: $(build_path)/pdforiginal_page.pdf
	convert -size 2000x2000 $(build_path)/pdforiginal_page.pdf $(build_path)/pdforiginal_page.jpg

$(build_path)/pdf_page.pdf: $(output_file)
	cp $(output_file) $(build_path)/pdf_page.pdf

$(build_path)/pdforiginal_page.pdf: exemples/attestation_originale.pdf
	cp exemples/attestation_originale.pdf $(build_path)/pdforiginal_page.pdf

$(build_path)/pdf%.txt: $(build_path)/pdf%.jpg
	zbarimg  $< > $@ 2> /dev/null
