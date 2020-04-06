all: attestation.pdf

attestation.pdf: build/attestation.svg
	inkscape --export-pdf=attestation.pdf build/attestation.svg

build/attestation.svg: config.inc build/qr.inc templates/attestation.svg.tmpl
	bash -c "source config.inc ; source build/qr.inc; envsubst < templates/attestation.svg.tmpl  > build/attestation.svg"

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
