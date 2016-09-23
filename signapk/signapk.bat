java -jar "%~dp0signapk.jar" "%~dp0platform.x509.pem" "%~dp0platform.pk8" %1 signed.apk
zipalign -v 4 signed.apk signed_align.apk
zipalign -c -v 4 signed_align.apk