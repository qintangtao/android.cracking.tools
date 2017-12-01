# android逆向工具和辅助工具

## kstools
hook应用签名方法<br>

## signapk
签名工具<br>

## <base></base>smali_baksmali-2.0.5
* 反编译（把c:\classes.dex反编译为smali，输出到c:\classout目录）
```Bash
java -jar baksmali-2.0.5.jar -o c:\classout/ c:\classes.dex

```
* 编译（把c:\classout目录下的smali文件编译为c:\classes.dex）
```Bash
java -jar smali-2.0.5.jar c:\classout/ -o c:\classes.dex
```

## jd-gui-0.3.5.windows
".class"文件反编译工具<br>

## ExtractDexFromOat
OAT转DEX<br>

##GDA3.32
比JEB更快、更强、更小的Android反编译器<br>
采用C++完成核心解析功能<br>