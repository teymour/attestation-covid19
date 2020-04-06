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

build/qr.txt: config.inc templates/qr.txt.tmpl
	bash -c "source config.inc ; envsubst < templates/qr.txt.tmpl > build/qr.txt"

config.inc:
	bash templates/generate_config.sh > config.inc
