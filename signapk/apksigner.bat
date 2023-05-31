zipalign -v 4 %1.apk %1_align.apk
zipalign -c -v 4 %1_align.apk
D:\Users\open\android-studio-ide-193.6626763-windows\android-sdk\build-tools\29.0.2\apksigner sign --ks myKey.jks --ks-key-alias key0 %1_align.apk