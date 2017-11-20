# android.cracking.tools
android逆向工具和辅助工具

kstools: hook应用签名方法
signapk: 签名工具
smali_baksmali-2.0.5: 反编译和编译工具
	反编译：
		java -jar baksmali-2.0.5.jar -o c:\classout/ c:\classes.dex
		把c:\classes.dex反编译为smali，输出到c:\classout目录
	编译：
		java -jar smali-2.0.5.jar c:\classout/ -o c:\classes.dex
		把c:\classout目录下的smali文件编译为c:\classes.dex
jd-gui-0.3.5.windows：".class"文件反编译工具