一.工具介绍
jarsigner是JDK提供的针对jar包签名的通用工具,
位于JDK/bin/jarsigner.exe

apksigner是Google官方提供的针对Android apk签名及验证的专用工具,
位于Android SDK/build-tools/SDK版本/apksigner.bat

不管是apk包,还是jar包,本质都是zip格式的压缩包,所以它们的签名过程都差不多(仅限V1签名),
以上两个工具都可以对Android apk包进行签名.

1.V1和V2签名的区别
从Android 7.0开始, 谷歌增加新签名方案 V2 Scheme (APK Signature);
但Android 7.0以下版本, 只能用旧签名方案 V1 scheme (JAR signing)

V1签名:
    来自JDK(jarsigner), 对zip压缩包的每个文件进行验证, 签名后还能对压缩包修改(移动/重新压缩文件)
    对V1签名的apk/jar解压,在META-INF存放签名文件(MANIFEST.MF, CERT.SF, CERT.RSA), 
    其中MANIFEST.MF文件保存所有文件的SHA1指纹(除了META-INF文件), 由此可知: V1签名是对压缩包中单个文件签名验证

V2签名:
    来自Google(apksigner), 对zip压缩包的整个文件验证, 签名后不能修改压缩包(包括zipalign),
    对V2签名的apk解压,没有发现签名文件,重新压缩后V2签名就失效, 由此可知: V2签名是对整个APK签名验证

    V2签名优点很明显:
        签名更安全(不能修改压缩包)
        签名验证时间更短(不需要解压验证),因而安装速度加快

注意: apksigner工具默认同时使用V1和V2签名,以兼容Android 7.0以下版本


2.zipalign和V2签名
位于Android SDK/build-tools/SDK版本/zipalign.exe
zipalign 是对zip包对齐的工具,使APK包内未压缩的数据有序排列对齐,从而减少APP运行时内存消耗
zipalign -v 4 in.apk out.apk   //4字节对齐优化
zipalign -c -v 4 in.apk        //检查APK是否对齐

zipalign可以在V1签名后执行
但zipalign不能在V2签名后执行,只能在V2签名之前执行！！！


二.签名步骤
1.生成密钥对(已有密钥库,可忽略)
Eclipse或Android Studio在Debug时,对App签名都会使用一个默认的密钥库:
    默认在C:\Users\用户名\.android\debug.keystore
    密钥库名:   debug.keystore
    密钥别名:   androiddebugkey
    密钥库密码: android

1.生成密钥对
    进入JDK/bin, 输入命令 
    keytool -genkeypair -keystore 密钥库名 -alias 密钥别名 -validity 天数 -keyalg RSA

    参数:
        -genkeypair  生成一条密钥对(由私钥和公钥组成)
        -keystore    密钥库名字以及存储位置(默认当前目录)
        -alias       密钥对的别名(密钥库可以存在多个密钥对,用于区分不同密钥对)
        -validity    密钥对的有效期(单位: 天)
        -keyalg      生成密钥对的算法(常用RSA/DSA,DSA只用于签名,默认采用DSA)
        -delete      删除一条密钥

    提示: 可重复使用此条命令,在同一密钥库中创建多条密钥对

    例如:     
        在debug.keystore中新增一对密钥,别名是release
        keytool -genkeypair -keystore debug.keystore -alias release -validity 30000

2.查看密钥库
    进入JDK/bin, 输入命令
    keytool -list -v -keystore 密钥库名

    参数:
        -list 查看密钥列表
        -v    查看密钥详情

    例如:
        keytool -list -v -keystore debug.keystore
        现在debug.keystore密钥库中有两对密钥, 别名分别是androiddebugkey release

2.签名
1.方法一(jarsigner,只支持V1签名)
    进入JDK/bin, 输入命令
    jarsigner -keystore 密钥库名 xxx.apk 密钥别名

    从JDK7开始, jarsigner默认算法是SHA256, 但Android 4.2以下不支持该算法,
    所以需要修改算法, 添加参数 -digestalg SHA1 -sigalg SHA1withRSA
    jarsigner -keystore 密钥库名 -digestalg SHA1 -sigalg SHA1withRSA xxx.apk 密钥别名

    参数:
        -digestalg  摘要算法
        -sigalg     签名算法

    例如:
        用JDK7及以上jarsigner签名,不支持Android 4.2 以下
        jarsigner -keystore debug.keystore MyApp.apk androiddebugkey

        用JDK7及以上jarsigner签名,兼容Android 4.2 以下            
        jarsigner -keystore debug.keystore -digestalg SHA1 -sigalg SHA1withRSA MyApp.apk androiddebugkey

2.方法二(apksigner,默认同时使用V1和V2签名)
    进入Android SDK/build-tools/SDK版本, 输入命令
    apksigner sign --ks 密钥库名 --ks-key-alias 密钥别名 xxx.apk

    若密钥库中有多个密钥对,则必须指定密钥别名
    apksigner sign --ks 密钥库名 --ks-key-alias 密钥别名 xxx.apk

    禁用V2签名
    apksigner sign --v2-signing-enabled false --ks 密钥库名 xxx.apk

    参数:
        --ks-key-alias       密钥别名,若密钥库有一个密钥对,则可省略,反之必选
        --v1-signing-enabled 是否开启V1签名,默认开启
        --v2-signing-enabled 是否开启V2签名,默认开启

    例如:
        在debug.keystore密钥库只有一个密钥对
        apksigner sign --ks debug.keystore MyApp.apk

        在debug.keystore密钥库中有多个密钥对,所以必须指定密钥别名
        apksigner sign --ks debug.keystore --ks-key-alias androiddebugkey MyApp.apk

3.签名验证
1.方法一(keytool,只支持V1签名校验)
    进入JDK/bin, 输入命令
    keytool -printcert -jarfile MyApp.apk (显示签名证书信息)

    参数:
        -printcert           打印证书内容
        -jarfile <filename>  已签名的jar文件 或apk文件   

2.方法二(apksigner,支持V1和V2签名校验)
    进入Android SDK/build-tools/SDK版本, 输入命令
    apksigner verify -v --print-certs xxx.apk

    参数:
        -v, --verbose 显示详情(显示是否使用V1和V2签名)
        --print-certs 显示签名证书信息

    例如:
        apksigner verify -v MyApp.apk

        Verifies
        Verified using v1 scheme (JAR signing): true
        Verified using v2 scheme (APK Signature Scheme v2): true
        Number of signers: 1