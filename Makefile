all: attestation.pdf

attestation.pdf: build/attestation_page1.pdf build/attestation_page2.pdf
	pdftk build/attestation_page1.pdf build/attestation_page2.pdf cat output attestation.pdf

build/attestation_page1.pdf: build/attestation_page1.svg
	inkscape --export-pdf=build/attestation_page1.pdf build/attestation_page1.svg

build/attestation_page2.pdf: build/attestation_page2.svg
	inkscape --export-pdf=build/attestation_page2.pdf build/attestation_page2.svg

build/attestation_page1.svg: config.inc build/qr.inc templates/attestation_page1.svg.tmpl
	bash -c "source config.inc ; source build/qr.inc; envsubst < templates/attestation_page1.svg.tmpl  > build/attestation_page1.svg"

build/attestation_page2.svg: build/qr.inc templates/attestation_page2.svg.tmpl
	bash -c "source build/qr.inc; envsubst < templates/attestation_page2.svg.tmpl  > build/attestation_page2.svg"

build/qr.inc: build/qr.png
		echo -n "export qrcode=\"" > build/qr.inc
		base64 < build/qr.png | tr '\n' ' ' | sed 's/ //g' >> build/qr.inc
		echo '"' >> build/qr.inc

build/qr.png: build/qr.txt
	cat build/qr.txt | qr > build/qr.png

build/qr.txt: config.inc templates/qr.txt.tmpl build/.created
	bash -c "source config.inc ; cat templates/qr.txt.tmpl | tr -d '\n' | envsubst > build/qr.txt"

config.inc:
	bash templates/generate_config.sh > config.inc

build/.created:
	mkdir -p build
	touch build/.created

clean:
	rm -rf build attestation.pdf

test: generatetestfile testqrcode testpages

generatetestfile: exemples/output.txt
	cat exemples/output.txt | bash templates/generate_config.sh > config.inc

testqrcode: build/pdf_page-0.txt build/pdf_page-1.txt build/pdforiginal_page-0.txt build/pdforiginal_page-1.txt
	diff build/pdf_page-0.txt build/pdforiginal_page-0.txt && echo QRCODE page 1 OK
	diff build/pdf_page-1.txt build/pdforiginal_page-1.txt && echo QRCODE page 2 OK

testpages: build/diff_page1.jpg build/diff_page2.jpg

build/diff_page1.jpg: build/pdf_page-0.jpg build/pdforiginal_page-0.jpg
	perceptualdiff build/pdf_page-0.jpg build/pdforiginal_page-0.jpg --output build/diff_page1.jpg

build/diff_page2.jpg: build/pdf_page-1.jpg build/pdforiginal_page-1.jpg
	perceptualdiff build/pdf_page-1.jpg build/pdforiginal_page-1.jpg --output build/diff_page2.jpg

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
