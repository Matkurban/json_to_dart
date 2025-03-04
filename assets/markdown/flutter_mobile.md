
# Flutter Android编译慢问题

## 1. 修改Flutter Gradle镜像源为国内的镜像

### 1.1 [项目路径]\android\build.gradle

```groovy
allprojects {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/public/' }
        maven { url 'https://maven.aliyun.com/repository/google/' }
        maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
        maven { url "https://storage.flutter-io.cn/download.flutter.io" }
        google()
        jcenter()
        mavenCentral()
        gradlePluginPortal()
    }
}
```

### 1.2 [项目路径]\android\settings.gradle

```groovy
    repositories {
        maven { url 'https://maven.aliyun.com/repository/public/' }
        maven { url 'https://maven.aliyun.com/repository/google/' }
        maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
        maven { url "https://storage.flutter-io.cn/download.flutter.io" }
        google()
        jcenter()
        mavenCentral()
        gradlePluginPortal()
    }
```
### 1.3 [项目路径]\android\gradle\wrapper\gradle-wrapper.properties

```text
删除: distributionUrl=https\://services.gradle.org/distributions/gradle-8.10.2-all.zip
改成: distributionUrl=https\://mirrors.cloud.tencent.com/gradle/gradle-8.10.2-all.zip
```

# 构建和发布为 Android 应用

## 1. 创建密钥库

执行以下 CMD 命令来创建密钥库：

```cmd
C:\Program Files\Java\jdk-21\bin\keytool.exe -genkey -v -keystore [项目]/android/app/myapp-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias myapp
```

## 2. 从 app 中引用密钥库

创建一个名为 `[project]/android/key.properties` 的文件，并包含以下内容：

```properties
storePassword=你的密码
keyPassword=你的密码
keyAlias=myapp
storeFile=myapp-keystore.jks
```

## 3. 在 Gradle 中配置签名

### 3.1 修改 `build.gradle` 文件

在以 release 模式下构建你的应用时，修改 `[project]/android/app/build.gradle` 文件，以通过 Gradle 配置你的上传密钥。在文件中的第 28 行左右添加以下代码：

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

```

### 3.2 找到 `buildTypes` 代码块

在 `build.gradle` 文件的第 63 行左右找到 `buildTypes` 代码块：

```groovy
buildTypes {
    release {
        // TODO: Add your own signing config for the release build.
        // Signing with the debug keys for now,
        // so `flutter run --release` works.
        signingConfig signingConfigs.debug
    }
}
```

### 3.3 替换为自定义配置

将上述 `buildTypes` 代码块替换为以下内容：

```groovy
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}
```

---

通过以上步骤，你已经成功配置了 Android 应用的签名信息，并可以构建和发布你的应用。




