---
scope: learn
draft: true
---
# CONSTANT POOL

```c
CONSTANT_Utf8_info {
    u1 tag;                 // tag = 1
    u2 length;              // UTF8 编码字符串所占用的字节数
    u1 bytes[length];       // 包含字符串编码的字节数组
}
CONSTANT_Integer_info {
    u1 tag;                 // tag = 3
    u4 bytes;
}
CONSTANT_Float_info {
    u1 tag;                 // tag = 4
    u4 bytes;
}
CONSTANT_Long_info {
    u1 tag;                 // tag = 5
    u4 high_bytes;
    u4 low_bytes;
}
CONSTANT_Double_info {
    u1 tag;                 // tag = 6
    u4 high_bytes;
    u4 low_bytes;
}
CONSTANT_Class_info {
    u1 tag;                 // tag = 7
    u2 name_index;          // 指向全限定类名 UTF8 字符串常量在常量池中的索引
}
CONSTANT_String_info {
    u1 tag;                 // tag = 8
    u2 string_index;
}
CONSTANT_Fieldref_info {
    u1 tag;                 // tag = 9
    u2 class_index;         // 指向声明字段的类或接口描述符CONSTANT_Class_info的索引项
    u2 name_and_type_index; // 指向字段描述符CONSTANT_NameAndType_info的索引项
}
CONSTANT_Methodref_info {
    u1 tag;                 // tag = 10
    u2 class_index;         // 指向声明方法的类描述符CONSTANT_Class_info的索引项
    u2 name_and_type_index; // 指向名称及类型描述符CONSTANT_NameAndType_info的索引项
}
CONSTANT_InterfaceMethodref_info {
    u1 tag;                 // tag = 11
    u2 class_index;         // 指向声明方法的接口描述符CONSTANT_Class_info的索引项
    u2 name_and_type_index; // 指向名称及类型描述符CONSTANT_NameAndType_info的索引项
}
CONSTANT_NameAndType_info {
    u1 tag;                 // tag = 12
    u2 name_index;          // 指向该字段或方法名称常量项的索引
    u2 descriptor_index;    // 指向该字段或方法描述符常量项的索引
}
CONSTANT_MethodHandle_info {
    u1 tag;                 // tag = 15
    u1 reference_kind;      // 值必须在1-9之间，决定了方法句柄的类型，方法句柄的类型的值表示方法句柄字节码的行为
    u2 reference_index;     // 值必须是对常量池的有效索引
}
CONSTANT_MethodType_info {
    u1 tag;                 // tag = 16
    u2 descriptor_index;    // 值必须对常量池的有效索引，常量池在该处的项必须是CONSTANT_Utf8_info表示方法的描述符
}
CONSTANT_Dynamic_info {
    u1 tag;                 // tag = 17
    u2 bootstrap_method_attr_index; // 值必须对当前Class文件中引导方法表的bootstrap_methods[]数组的有效索引
    u2 name_and_type_index;         // 值必须对当前常量池的有效索引，常量池中在该索引出的项必须是CONSTANT_NameAndType_info结构，表示方法名和方法描述符
}
CONSTANT_InvokeDynamic_info {
    u1 tag;                 // tag = 18
    u2 bootstrap_method_attr_index; // 值必须对当前Class文件中引导方法表的bootstrap_methods[]数组的有效索引
    u2 name_and_type_index;         // 值必须对当前常量池的有效索引，常量池中在该索引出的项必须是CONSTANT_NameAndType_info结构，表示方法名和方法描述符
}
CONSTANT_Module_info {
    u1 tag;                 // tag = 19
    u2 name_index;          // 值必须对常量池的有效索引，常量池在该处的项必须是CONSTANT_Utf8_info表示模块名
}
CONSTANT_Package_info {
    u1 tag;                 // tag = 20
    u2 name_index;          // 值必须对常量池的有效索引，常量池在该处的项必须是CONSTANT_Utf8_info表示包名
}
```

# This Class, Super Class and Interface Set




# Fields

```c
field_info {
    u2              access_flags;
    u2              name_index;
    u2              descriptor_index;
    u2              attributes_count;
    attribute_info  attributes[attributes_count];
}
```

Table 4.5-A. Field access and property flags

| FlagName      | Value  | Interpretation                                                                    |
| ------------- | ------ | --------------------------------------------------------------------------------- |
| ACC_PUBLIC    | 0x0001 | Declared public; may be accessed from outside its package.                        | 
| ACC_PRIVATE   | 0x0002 | Declared private; usable only within the defining class.                          |
| ACC_PROTECTED | 0x0004 | Declared protected; may be accessed within subclasses.                            |
| ACC_STATIC    | 0x0008 | Declared static.                                                                  |
| ACC_FINAL     | 0x0010 | Declared final; never directly assigned to after object construction (JLS §17.5). |
| ACC_VOLATILE  | 0x0040 | Declared volatile; cannot be cached.                                              |
| ACC_TRANSIENT | 0x0080 | Declared transient; not written or read by a persistent object manager.           |
| ACC_SYNTHETIC | 0x1000 | Declared synthetic; not present in the source code.                               |
| ACC_ENUM      | 0x4000 | Declared as an element of an enum.                                                |

# Methods

```c
method_info {
    u2              access_flags;
    u2              name_index;
    u2              descriptor_index;
    u2              attributes_count;
    attribute_info  attributes[attributes_count];
}
```

(ClassFile|Code|field_info|method_info|ConstantValue|Expressions|SourceFile|LineNumberTable|LocalVariableTable|InnerClasses|Synthetic|Deprecated|EnclosingMethod|Signature|SourceDebugExtension|LocalVariableTypeTable|RuntimeVisibleAnnotations|RuntimeInvisibleAnnotations|RuntimeVisibleParameterAnnotations|RuntimeInVisibleParameterAnnotations|AnnotationDefault|StackMapTable|BootstrapMethods|RuntimeVisibleTypeAnnotations|RuntimeInVisibleTypeAnnotations|MethodParameters)

Table 4.6-A. Method access and property flags
| Flag Name        | Value  | Interpretation                                                 |
| ---------------- | ------ | -------------------------------------------------------------- |
| ACC_PUBLIC       | 0x0001 | Declared public; may be accessed from outside its package.     |
| ACC_PRIVATE      | 0x0002 | Declared private; accessible only within the defining class.   |
| ACC_PROTECTED    | 0x0004 | Declared protected; may be accessed within subclasses.         |
| ACC_STATIC       | 0x0008 | Declared static.                                               |
| ACC_FINAL        | 0x0010 | Declared final; must not be overridden (§5.4.5).               |
| ACC_SYNCHRONIZED | 0x0020 | Declared synchronized; invocation is wrapped by a monitor use. |
| ACC_BRIDGE       | 0x0040 | A bridge method, generated by the compiler.                    |
| ACC_VARARGS      | 0x0080 | Declared with variable number of arguments.                    |
| ACC_NATIVE       | 0x0100 | Declared native; implemented in a language other than Java.    |
| ACC_ABSTRACT     | 0x0400 | Declared abstract; no implementation is provided.              |
| ACC_STRICT       | 0x0800 | Declared strictfp; floating-point mode is FP strict.           |
| ACC_SYNTHETIC    | 0x1000 | Declared synthetic; not present in the source code.            | 


# Attributes

```c
attribute_info {
    u2  attribute_name_index;
    u4  attribute_length;
    u1  info[attribute_length];
}
```

Within the context of their use in this specification, that is, in the attributes tables
of the class file structures in which they appear, the names of these predefined
attributes are reserved.


Any conditions on the presence of a predefined attribute in an attributes table
are specified explicitly in the section which describes the attribute. If no conditions
are specified, then the attribute may appear any number of times in an attributes
table.

The predefined attributes are categorized into three groups according to their
purpose:

1. Five attributes are critical to correct interpretation of the class file by the Java
Virtual Machine:

- ConstantValue
- Code
- StackMapTable
- Exceptions
- BootstrapMethods

In a class file of version V, each of these attributes must be recognized
and correctly read by an implementation of the Java Virtual Machine if the
implementation recognizes class files of version V, and V is at least the version
where the attribute was first defined, and the attribute appears in a location
where it is defined to appear.

2. Twelve attributes are critical to correct interpretation of the class file by the
class libraries of the Java SE platform:

- InnerClasses
- EnclosingMethod
- Synthetic
- Signature
- RuntimeVisibleAnnotations
- RuntimeInvisibleAnnotations
- RuntimeVisibleParameterAnnotations
- RuntimeInvisibleParameterAnnotations
- RuntimeVisibleTypeAnnotations
- RuntimeInvisibleTypeAnnotations
- AnnotationDefault
- MethodParameters

Each of these attributes in a class file of version V must be recognized and
correctly read by an implementation of the class libraries of the Java SE
platform if the implementation recognizes class files of version V, and V is at
least the version where the attribute was first defined, and the attribute appears
in a location where it is defined to appear.
3. Six attributes are not critical to correct interpretation of the class file by either
the Java Virtual Machine or the class libraries of the Java SE platform, but are
useful for tools:
- SourceFile
- SourceDebugExtension
- LineNumberTable
- LocalVariableTable
- LocalVariableTypeTable
- Deprecated

Use of these attributes by an implementation of the Java Virtual Machine or the
class libraries of the Java SE platform is optional. An implementation may use
the information that these attributes contain, or otherwise must silently ignore
these attributes.

Table 4.7-A. Predefined class file attributes (by section)

| Attribute                              | Section | class file | Java SE |
| -------------------------------------- | ------- | ---------- | ------- |
| `ConstantValue`                        | §4.7.2  | 45.3       | 1.0.2   | 
| `Code`                                 | §4.7.3  | 45.3       | 1.0.2   |
| `StackMapTable`                        | §4.7.4  | 50.0       | 6       |
| `Exceptions`                           | §4.7.5  | 45.3       | 1.0.2   |
| `InnerClasses`                         | §4.7.6  | 45.3       | 1.1     |
| `EnclosingMethod`                      | §4.7.7  | 49.0       | 5.0     |
| `Synthetic`                            | §4.7.8  | 45.3       | 1.1     |
| `Signature`                            | §4.7.9  | 49.0       | 5.0     |
| `SourceFile`                           | §4.7.10 | 45.3       | 1.0.2   |
| `SourceDebugExtension`                 | §4.7.11 | 49.0       | 5.0     |
| `LineNumberTable`                      | §4.7.12 | 45.3       | 1.0.2   |
| `LocalVariableTable`                   | §4.7.13 | 45.3       | 1.0.2   |
| `LocalVariableTypeTable`               | §4.7.14 | 49.0       | 5.0     |
| `Deprecated`                           | §4.7.15 | 45.3       | 1.1     |
| `RuntimeVisibleAnnotations`            | §4.7.16 | 49.0       | 5.0     |
| `RuntimeInvisibleAnnotations`          | §4.7.17 | 49.0       | 5.0     |
| `RuntimeVisibleParameterAnnotations`   | §4.7.18 | 49.0       | 5.0     |
| `RuntimeInvisibleParameterAnnotations` | §4.7.19 | 49.0       | 5.0     |
| `RuntimeVisibleTypeAnnotations`        | §4.7.20 | 52.0       | 8       |
| `RuntimeInvisibleTypeAnnotations`      | §4.7.21 | 52.0       | 8       |
| `AnnotationDefault`                    | §4.7.22 | 49.0       | 5.0     |
| `BootstrapMethods`                     | §4.7.23 | 51.0       | 7       |
| `MethodParameters`                     | §4.7.24 | 52.0       | 8       |


Table 4.7-B. Predefined class file attributes (by class file version)

| Attribute                              | class file | Java SE | Section |
| -------------------------------------- | ---------- | ------- | ------- |
| `ConstantValue`                        | 45.3       | 1.0.2   | §4.7.2  |
| `Code`                                 | 45.3       | 1.0.2   | §4.7.3  |
| `Exceptions`                           | 45.3       | 1.0.2   | §4.7.5  |
| `SourceFile`                           | 45.3       | 1.0.2   | §4.7.10 |
| `LineNumberTable`                      | 45.3       | 1.0.2   | §4.7.12 |
| `LocalVariableTable`                   | 45.3       | 1.0.2   | §4.7.13 |
| `InnerClasses`                         | 45.3       | 1.1     | §4.7.6  |
| `Synthetic`                            | 45.3       | 1.1     | §4.7.8  |
| `Deprecated`                           | 45.3       | 1.1     | §4.7.15 |
| `EnclosingMethod`                      | 49.0       | 5.0     | §4.7.7  |
| `Signature`                            | 49.0       | 5.0     | §4.7.9  |
| `SourceDebugExtension`                 | 49.0       | 5.0     | §4.7.11 |
| `LocalVariableTypeTable`               | 49.0       | 5.0     | §4.7.14 |
| `RuntimeVisibleAnnotations`            | 49.0       | 5.0     | §4.7.16 |
| `RuntimeInvisibleAnnotations`          | 49.0       | 5.0     | §4.7.17 |
| `RuntimeVisibleParameterAnnotations`   | 49.0       | 5.0     | §4.7.18 |
| `RuntimeInvisibleParameterAnnotations` | 49.0       | 5.0     | §4.7.19 |
| `AnnotationDefault`                    | 49.0       | 5.0     | §4.7.22 |
| `StackMapTable`                        | 50.0       | 6       | §4.7.4  |
| `BootstrapMethods`                     | 51.0       | 7       | §4.7.23 |
| `RuntimeVisibleTypeAnnotations`        | 52.0       | 8       | §4.7.20 |
| `RuntimeInvisibleTypeAnnotations`      | 52.0       | 8       | §4.7.21 |
| `MethodParameters`                     | 52.0       | 8       | §4.7.24 |


Table 4.7-C. Predefined class file attributes (by location)

| Attribute                              | Location                                            | class file |
| -------------------------------------- | --------------------------------------------------- | ---------- |
| `SourceFile`                           | `ClassFile`                                         | 45.3       |
| `InnerClasses`                         | `ClassFile`                                         | 45.3       |
| `EnclosingMethod`                      | `ClassFile`                                         | 49.0       |
| `SourceDebugExtension`                 | `ClassFile`                                         | 49.0       |
| `BootstrapMethods`                     | `ClassFile`                                         | 51.0       |
| `ConstantValue`                        | `field_info`                                        | 45.3       |
| `Code`                                 | `method_info`                                       | 45.3       |
| `Exceptions`                           | `method_info`                                       | 45.3       |
| `RuntimeVisibleParameterAnnotations`   | `method_info`                                       | 49.0       |
| `RuntimeInvisibleParameterAnnotations` | `method_info`                                       | 49.0       |
| `AnnotationDefault`                    | `method_info`                                       | 49.0       |
| `MethodParameters`                     | `method_info`                                       | 52.0       |
| `Synthetic`                            | `ClassFile`, `field_info`, `method_info`            | 45.3       |
| `Deprecated`                           | `ClassFile`, `field_info`, `method_info`            | 45.3       |
| `Signature`                            | `ClassFile`, `field_info`, `method_info`            | 49.0       |
| `RuntimeVisibleAnnotations`            | `ClassFile`, `field_info`, `method_info`            | 49.0       |
| `RuntimeInvisibleAnnotations`          | `ClassFile` , `field_info` , `method_info`          | 49.0       |
| `LineNumberTable`                      | `Code`                                              | 45.3       |
| `LocalVariableTable`                   | `Code`                                              | 45.3       |
| `LocalVariableTypeTable`               | `Code`                                              | 49.0       |
| `StackMapTable`                        | `Code`                                              | 50.0       |
| `RuntimeVisibleTypeAnnotations`        | `ClassFile`, `field_info`, `method_info`, `Code`    | 52.0       |
| `RuntimeInvisibleTypeAnnotations`      | `ClassFile` , `field_info` , `method_info` , `Code` | 52.0       |

