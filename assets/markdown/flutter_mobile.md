# Flutter Android 国内构建指南

> QQ 交流群 1020669215

## 配置国内镜像源加速构建

### Flutter 3.29.0 以下版本

**修改 `android/build.gradle`**：

```groovy
allprojects {
    repositories {
        // 国内镜像源
        maven { url 'https://maven.aliyun.com/repository/public/' }
        maven { url 'https://maven.aliyun.com/repository/google/' }
        maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
        maven { url 'https://storage.flutter-io.cn/download.flutter.io' }

        // 原始源（备用）
        google()
        jcenter()
        mavenCentral()
        gradlePluginPortal()
    }
}
```

**修改 `android/settings.gradle`**：

```groovy
repositories {
    // 国内镜像源
    maven { url 'https://maven.aliyun.com/repository/public/' }
    maven { url 'https://maven.aliyun.com/repository/google/' }
    maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
    maven { url 'https://storage.flutter-io.cn/download.flutter.io' }

    // 原始源（备用）
    google()
    jcenter()
    mavenCentral()
    gradlePluginPortal()
}
```

**修改 `android/gradle/wrapper/gradle-wrapper.properties`**：

```properties
# 将原有的
# distributionUrl=https\://services.gradle.org/distributions/gradle-8.10.2-all.zip
# 替换为：
distributionUrl=https\://mirrors.cloud.tencent.com/gradle/gradle-8.10.2-all.zip
```

### Flutter 3.29.0 及以上版本

对于使用 `.kts` 后缀的 Gradle 配置文件，使用以下格式：

```kotlin
repositories {
    maven("https://storage.flutter-io.cn/download.flutter.io")
    maven("https://maven.aliyun.com/repository/public/")
    maven("https://maven.aliyun.com/repository/google/")
    maven("https://maven.aliyun.com/repository/gradle-plugin")
}
```

## 应用签名配置

### 1. 生成密钥库

在命令提示符中执行：

```bash
keytool -genkey -v -keystore [项目路径]/android/app/myapp-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias myapp
```

### 2. 配置密钥信息

创建文件：`[项目路径]/android/key.properties`

```properties
storePassword=你的密码
keyPassword=你的密码
keyAlias=myapp
storeFile=myapp-keystore.jks
```

### 3. 配置 Gradle 签名设置

**在 `android/app/build.gradle` 文件开头添加**：

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

**替换原有的 `buildTypes` 配置**：

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

## 版本兼容性对照表

### Java 与 Gradle 版本对应关系

> ⚠️ 重要提示：使用特定 Java 版本时，请确保选择兼容的 Gradle 版本

| Java 版本 | 工具链支持版本 | Gradle 最低支持版本 |
| --------- | -------------- | ------------------- |
| 8         | N/A            | 2.0                 |
| 9         | N/A            | 4.3                 |
| 10        | N/A            | 4.7                 |
| 11        | N/A            | 5.0                 |
| 12        | N/A            | 5.4                 |
| 13        | N/A            | 6.0                 |
| 14        | N/A            | 6.3                 |
| 15        | 6.7            | 6.7                 |
| 16        | 7.0            | 7.0                 |
| 17        | 7.3            | 7.3                 |
| 18        | 7.5            | 7.5                 |
| 19        | 7.6            | 7.6                 |
| 20        | 8.1            | 8.3                 |
| 21        | 8.4            | 8.5                 |
| 22        | 8.7            | 8.8                 |
| 23        | 8.10           | 8.10                |
| 24        | N/A            | N/A                 |

> 📝 说明：
>
> - "工具链支持版本"指 Gradle 对该 Java 版本的工具链支持
> - "Gradle 最低支持版本"指可以运行该 Gradle 版本所需的最低 Java 版本

### Kotlin 与 Gradle 版本对应关系

> 🔍 注意：选择 Kotlin 版本时，请确保与项目使用的 Gradle 版本兼容

| Kotlin 版本 | 最低 Gradle 版本 | Kotlin 语言版本 |
| ----------- | ---------------- | --------------- |
| 1.3.10      | 5.0              | 1.3             |
| 1.3.11      | 5.1              | 1.3             |
| 1.3.20      | 5.2              | 1.3             |
| 1.3.21      | 5.3              | 1.3             |
| 1.3.31      | 5.5              | 1.3             |
| 1.3.41      | 5.6              | 1.3             |
| 1.3.50      | 6.0              | 1.3             |
| 1.3.61      | 6.1              | 1.3             |
| 1.3.70      | 6.3              | 1.3             |
| 1.3.71      | 6.4              | 1.3             |
| 1.3.72      | 6.5              | 1.3             |
| 1.4.20      | 6.8              | 1.3             |
| 1.4.31      | 7.0              | 1.4             |
| 1.5.21      | 7.2              | 1.4             |
| 1.5.31      | 7.3              | 1.4             |
| 1.6.21      | 7.5              | 1.4             |
| 1.7.10      | 7.6              | 1.4             |
| 1.8.10      | 8.0              | 1.8             |
| 1.8.20      | 8.2              | 1.8             |
| 1.9.0       | 8.3              | 1.8             |
| 1.9.10      | 8.4              | 1.8             |
| 1.9.20      | 8.5              | 1.8             |
| 1.9.22      | 8.7              | 1.8             |
| 1.9.23      | 8.9              | 1.8             |
| 1.9.24      | 8.10             | 1.8             |
| 2.0.20      | 8.11             | 1.8             |
| 2.0.21      | 8.12             | 1.8             |

> 💡 版本选择建议：
>
> - 建议使用最新的稳定版本组合
> - 确保项目中的 Kotlin、Gradle 和 Java 版本相互兼容
> - 升级版本时应该逐步进行，避免跨越太多版本

### 快速版本选择指南

根据您的 Java 版本，以下是推荐的版本组合：

#### Java 8 用户

- Gradle: 2.0 - 7.3
- Kotlin: 1.3.10 - 1.5.31

#### Java 11 用户

- Gradle: 5.0 - 7.6
- Kotlin: 1.3.10 - 1.7.10

#### Java 17 用户（推荐）

- Gradle: 7.3 或更高
- Kotlin: 1.5.31 或更高

#### Java 21 用户（最新）

- Gradle: 8.5 或更高
- Kotlin: 1.9.20 或更高

> ⚠️ 注意事项：
>
> 1. 版本升级前请先备份项目
> 2. 建议在测试环境中先进行验证
> 3. 注意查看各版本的发行说明中的破坏性变更
> 4. 确保所有项目依赖都兼容新版本
