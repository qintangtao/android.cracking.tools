adb connect 127.0.0.1:62001
adb forward tcp:27042 tcp:27042
adb forward tcp:27043 tcp:27043
adb shell /data/local/tmp/frida-server