config_file=config.inc

all: ifupdateneeded attestation.pdf

config: cleanconfig $(config_file)

ifupdateneeded: $(config_file)
	if grep "date +" $(config_file) > /dev/null ; then touch $(config_file) ; fi

attestation.pdf: build/attestation_page1.pdf build/attestation_page2.pdf
	pdftk $^ cat output $@

build/attestation_page%.pdf: build/attestation_page%.svg
	inkscape --export-pdf=$@ $<

build/attestation_page1.svg: build/config.inc build/qr.inc templates/attestation_page1.svg.tmpl
	bash -c "source build/config.inc ; source build/qr.inc; envsubst < templates/attestation_page1.svg.tmpl  > build/attestation_page1.svg"

build/attestation_page2.svg: build/qr.inc templates/attestation_page2.svg.tmpl
	bash -c "source build/qr.inc; envsubst < templates/attestation_page2.svg.tmpl  > build/attestation_page2.svg"

build/qr.inc: build/qr.png
		echo -n "export qrcode=\"" > build/qr.inc
		base64 < build/qr.png | tr '\n' ' ' | sed 's/ //g' >> build/qr.inc
		echo '"' >> build/qr.inc

build/qr.png: build/qr.txt
	cat build/qr.txt | qr > build/qr.png

build/qr.txt: build/config.inc templates/qr.txt.tmpl build/.created
	bash -c "source build/config.inc ; cat templates/qr.txt.tmpl | tr -d '\n' | envsubst > build/qr.txt"

build/config.inc: build/.created $(config_file)
	bash templates/config_avec_multimotifs.sh $(config_file) > build/config.inc

$(config_file):
	bash templates/generate_config.sh > $(config_file)

build/.created:
	mkdir -p build
	touch build/.created

clean:
	rm -f build/* attestation.pdf

cleanconfig:
	rm $(config_file)

test: clean generatetestfile testqrcode testpages clean
	rm -rf build/* attestation.pdf config_test.inc
	printf "\n\n\n====================================\n          Tests concluants\n====================================\n\n\n"

generatetestfile: exemples/output.txt
	$(eval config_file=config_test.inc)
	cat exemples/output.txt | bash templates/generate_config.sh > $(config_file) 2> /dev/null

testqrcode: build/pdf_page-0.txt build/pdf_page-1.txt build/pdforiginal_page-0.txt build/pdforiginal_page-1.txt
	diff build/pdf_page-0.txt build/pdforiginal_page-0.txt && echo QRCODE page 1 OK
	diff build/pdf_page-1.txt build/pdforiginal_page-1.txt && echo QRCODE page 2 OK

testpages: build/diff_page-0.jpg build/diff_page-1.jpg

build/diff_page-%.jpg: build/pdf_page-%.jpg build/pdforiginal_page-%.jpg
	perceptualdiff --threshold 1200 $^ --output $@ && echo Page OK

build/pdf_page-%.jpg: build/pdf_page.pdf
	convert -size 2000x2000 build/pdf_page.pdf build/pdf_page.jpg

build/pdforiginal_page-%.jpg: build/pdforiginal_page.pdf
	convert -size 2000x2000 build/pdforiginal_page.pdf build/pdforiginal_page.jpg

build/pdf_page.pdf: attestation.pdf
	cp attestation.pdf build/pdf_page.pdf

build/pdforiginal_page.pdf: exemples/attestation_originale.pdf
	cp exemples/attestation_originale.pdf build/pdforiginal_page.pdf

build/pdf%.txt: build/pdf%.jpg
	zbarimg  $< > $@ 2> /dev/null
