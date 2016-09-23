adb wait-for-device
adb devices
adb shell rm -f /data/local/tmp/%1
adb push %1 /data/local/tmp/%1
adb shell pm install -r /data/local/tmp/%1