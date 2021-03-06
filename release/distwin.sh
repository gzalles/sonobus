#!/bin/bash

if [ -z "$1" ] ; then
   echo "Usage: $0 <version> <certpassword>"
   exit 1
fi

VERSION=$1

CERTPASS=$2

CERTFILE='C:\Users\jesse\src\cert\SonosaurusCodeSigningSectigoCert.p12'

mkdir -p SonoBus/Plugins

cp -v ../doc/README_WINDOWS.txt SonoBus/README.txt
cp -v ../Builds/VisualStudio2017/x64/Release/Standalone\ Plugin/SonoBus.exe SonoBus/
cp -v ../Builds/VisualStudio2017/x64/Release/VST3/SonoBus.vst3 SonoBus/Plugins/
cp -v ../Builds/VisualStudio2017/x64/Release/VST/SonoBus.dll SonoBus/Plugins/

# sign executable
#signtool.exe sign /v /t "http://timestamp.digicert.com" /f SonosaurusCodeSigningSectigoCert.p12 /p "$CERTPASS" SonoBus/SonoBus.exe

mkdir -p instoutput
rm -f instoutput/*


iscc /O"instoutput" "/Ssigntool=signtool.exe sign /t http://timestamp.digicert.com /f ${CERTFILE} /p ${CERTPASS} \$f"  /DSBVERSION="${VERSION}" wininstaller.iss

#signtool.exe sign /v /t "http://timestamp.digicert.com" /f SonosaurusCodeSigningSectigoCert.p12 /p "$CERTPASS" instoutput/

ZIPFILE=sonobus-${VERSION}-win.zip

cp -v ../doc/README_WINDOWS.txt instoutput/README.txt

rm -f ${ZIPFILE}

(cd instoutput; zip  ../${ZIPFILE} SonoBus\ Installer.exe README.txt )
