# AndroidStudio 创建 Dart 文件模板

> QQ 交流群 1020669215
> 以下模板创建的文件都会把 小写下划线转换为规范的 Dart 类类名。

## 创建 Class 文件

```dart
#set($className = "")
#foreach($part in $NAME.split("_"))
  #set($className = $className + $part.substring(0, 1).toUpperCase() + $part.substring(1))
#end
class ${className}{

}
```

## 创建 Stateless 文件

```dart
import 'package:flutter/material.dart';

#set($className = "")
#foreach($part in $NAME.split("_"))
  #set($className = $className + $part.substring(0, 1).toUpperCase() + $part.substring(1))
#end
class ${className} extends StatelessWidget {
  const ${className}({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Text('${className}'),
    );
  }
}
```

## 创建 Stateful 文件

```dart
import 'package:flutter/material.dart';

#set($className = "")
#foreach($part in $NAME.split("_"))
  #set($className = $className + $part.substring(0, 1).toUpperCase() + $part.substring(1))
#end
class ${className} extends StatefulWidget {
  const ${className}({super.key});

  @override
  State<${className}> createState() => _${className}State();
}

class _${className}State extends State<${className}> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('${className}'),
      ),
    );
  }
}
```

## 创建 GetController 文件

```dart
import 'package:get/get.dart';

#set($className = "")
#foreach($part in $NAME.split("_"))
  #set($className = $className + $part.substring(0, 1).toUpperCase() + $part.substring(1))
#end
class ${className} extends GetxController {

}
```

## 创建 GetBinding 文件

```dart
import 'package:get/get.dart';

#set($className = "")
#foreach($part in $NAME.split("_"))
  #set($className = $className + $part.substring(0, 1).toUpperCase() + $part.substring(1))
#end
class ${className} extends Bindings {
  @override
  void dependencies() {

  }
}
```
