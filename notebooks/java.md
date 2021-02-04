1. Java 中的 final 关键字可以用于声明属性（常量），方法和类。当 final 修饰属性时，代表该属性一旦被分配内存空间就必须初始化，它的含义是“这是无法改变的”或者“终态的”。在变量前面添加关键字 final 即可声明一个常量。在 Java 编码规范中，要求常量名必须大写。

2. 字符串连接有两种方法：

使用 +，比如 String s = "Hello " + "World!"。
使用 String 类的 concat() 方法。

3. 在面向对象中有一个非常重要的知识点，就是构造方法。每个类都有构造方法，在创建该类的对象的时候他们将被调用，如果没有定义构造方法，Java 编译器会提供一个默认构造方法。 创建一个对象的时候，至少调用一个构造方法。比如在新建一个对象 new Object()，括号中没有任何参数，代表调用一个无参构造方法（默认构造方法就是一个无参构造方法）。构造方法的名称必须与类名相同，一个类可以定义多个构造方法。

4. **静态成员：** Java 中被 static 修饰的成员称为静态成员或类成员。它属于整个类所有，而不是某个对象所有，即被类的所有对象所共享。静态成员可以使用类名直接访问，也可以使用对象名进行访问。

5. **静态方法:** 被 static 修饰的方法是静态方法，静态方法不依赖于对象，不需要将类实例化便可以调用，由于不实例化也可以调用，所以不能有 this，也不能访问非静态成员变量和非静态方法。但是非静态成员变量和非静态方法可以访问静态方法。

6. final 关键字可以修饰类、方法、属性和变量:
- final 修饰类，则该类不允许被继承，为最终类;
- final 修饰方法，则该方法不允许被覆盖（重写）;
- final 修饰属性：则该类的属性不会进行隐式的初始化（类的初始化属性必须有值）或在构造方法中赋值（但只能选其一）;
- final 修饰变量，则该变量的值只能赋一次值，即常量。

7. Java 的权限修饰符

|访问修饰符|本类|同包|子类|其他|说明|
|:--:|:--:|:--:|:--:|:--:|:--:|
|private|√||||**private**修饰的属性或者方法，只能在当前类中访问或者使用。|
|默认|√|√|||**默认**是什么修饰符都不加，默认在当前类中和同一包下都可以访问和使用。|
|protected|√|√|√||**protected**修饰的属性或者方法，对同一包内的类和所有子类可见。|
|public|√|√|√|√|**public**修饰的属性或者方法，对所有类可见。|

8. this 关键字代表当前对象。使用 this.属性 操作当前对象的属性，this.方法调用当前对象的方法。

9. Java 实现多继承的一个办法是 implements（实现）接口，但接口不能有非静态的属性，这一点请注意。

10. super 关键字在子类内部使用，代表父类对象。
- 访问父类的属性 super.属性名。
- 访问父类的方法 super.bark()。
- 子类构造方法需要调用父类的构造方法时，在子类的构造方法体里最前面的位置：super()。

11. 方法重载是指在一个类中定义多个同名的方法，但要求每个方法具有不同的参数的类型或参数的个数。方法重载一般用于创建一组任务相似但是参数不同的方法。方法重载有以下几种规则：
- 方法中的参数列表必须不同。比如：参数个数不同或者参数类型不同。
- 重载的方法中允许抛出不同的异常
- 可以有不同的返回值类型，但是参数列表必须不同。
- 可以有不同的访问修饰符。
```java
public class Test {
    void f(int a){
        System.out.println("i = " + a);
    }
    void f(float i){
        System.out.println("f = " + i);
    }
    void f(String s){
        System.out.println("s = " + s);
    }
    void f(String s1, String s2){
        System.out.println("s1 + s2 = " + s1 + s2);
    }
    void f(String s1, int a){
        System.out.println("s = " + s1+", i = " + a);
    }
    public static void main(String[] args){
        Test test =  new Test();
        test.f(2345);
        test.f(34.56f);
        test.f("abc");
        test.f("abc", "def");
        test.f("abc",3456);
    }
}
```

12. Java 实现多态有三个必要条件：继承、重写和向上转型（即父类引用指向子类对象）。只有满足上述三个条件，才能够在同一个继承结构中使用统一的逻辑实现代码处理不同的对象，从而达到执行不同的行为。多态的实现方式：Java 中多态的实现方式：继承父类进行方法重写，抽象类和抽象方法，接口实现。

```java
public class Animal {
    public int legNum;
    public void bark(){
        System.out.println("动物叫");
    }    
}
```
```java
public class Dog extends Animal {
    public void bark(){
        System.out.println("狗叫");
    }
}
```
---------------
```java
class Animal{
    public void bark(){
        System.out.println("动物叫");
    }
}

class Dog extends Animal{
    public void bark(){
        System.out.println("汪汪汪");
    }
    public void dogType(){
        System.out.println("这是什么品种的狗！");
    }
}
public class Test {
    public static void main(String[] args){
        Animal a = new Animal();
        Animal b = new Dog();
        Dog c = new Dog();
        a.bark();
        b.bark();
        c.dogType();
    }
}
```

13. 抽象类的适用场景：

- 在某些情况下，某个父类只是知道其子类应该包含怎样的方法，但无法准确知道这些子类如何实现这些方法。也就是说抽象类是约束子类必须要实现哪些方法，而并不关注方法如何去实现。
- 从多个具有相同特征的类中抽象出一个抽象类，以这个抽象类作为子类的模板，从而避免了子类设计的随意性。

14. 那抽象类如何用代码实现呢，它的规则如下：

- 用 abstract 修饰符定义抽象类;
- 用 abstract 修饰符定义抽象方法，只用声明，不需要实现;
- 包含抽象方法的类就是抽象类;
- 抽象类中可以包含普通的方法，也可以没有抽象方法;
- 抽象类的对象不能直接创建，通常是定义引用变量指向子类对象。

```java
public abstract class TelePhone {
    public abstract void call();
    public abstract void message();
}
```

```java
public class CellPhone extends TelePhone {
    public void call(){
        System.out.println("I can make a telephone call.");
    }
    public void message(){
        System.out.println("I can send a message.");
    }
    public static void main(String[] args){
        CellPhone a = new CellPhone();
        a.call();
        a.message();
    }
}
```

15. 接口用于描述类所具有的功能，而不提供功能的实现，功能的实现需要写在实现接口的类中，并且该类必须实现接口中未实现的方法。

在 Java8 中：

- 接口不能用于实例化对象;
- 接口中方法只能是抽象方法、default 方法、静态方法;
- 接口成员是 static final 类型;
- 接口支持多继承。

在 Java9 中，接口可以拥有私有方法和私有静态方法，但是只能被该接口中的 default 方法和静态方法使用。

通过接口实现多继承：

```java
修饰符 interface A extends 接口1，接口2{

}

修饰符 class A implements 接口1，接口2{

}
```

```java
public interface Animal {
    int leg = 5;
    public void eat();
    public void travel();
}
```

```java
public class Cat implements Animal {
    public void eat(){
        System.out.println("Eat!");
    }
    public void travel(){
        System.out.println("Travel.");
    }
    public static void main(String[] args){
        Cat a =  new Cat();
        a.eat();
        a.travel();
    }
}
```

16. 将一个类的定义放在另一个类的定义内部，这就是内部类。而包含内部类的类被称为外部类。内部类的主要作用如下：

- 内部类提供了更好的封装，可以把内部类隐藏在外部类之内，不允许同一个包中的其他类访问该类
- 内部类的方法可以直接访问外部类的所有数据，包括私有的数据
- 内部类所实现的功能使用外部类同样可以实现，只是有时使用内部类更方便
- 内部类允许继承多个非接口类型（具体将在以后的内容进行讲解）
> 注：内部类是一个编译时的概念，一旦编译成功，就会成为完全不同的两类。对于一个名为 outer 的外部类和其内部定义的名为 inner 的内部类。编译完成后出现 outer.class 和 outer$inner.class 两类。所以内部类的成员变量 / 方法名可以和外部类的相同。

```java
public class People {
    private String name = "lili";
    public class Student {
        String id = "20201212";
        public void stuinfo(){
            System.out.println("访问外部类中的name:" + name);
            System.out.println("访问内部类的ID：" + id);
        }
    }
    public static void main(String[] args){
        People a = new People();
        Student b = a.new Student();
        b.stuinfo();
    }
}
```

成员内部类的使用方法：

1. Student 类相当于 People 类的一个成员变量，所以 Student 类可以使用任意访问修饰符。
2. Student 类在 People 类里，所以访问范围在类里的所有方法均可以访问 People 的属性（即内部类里可以直接访问外部类的方法和属性，反之不行）。
3. 定义成员内部类后，必须使用外部类对象来创建内部类对象，即 内部类 对象名 = 外部类对象.new 内部类();。
4. 如果外部类和内部类具有相同的成员变量或方法，内部类默认访问自己的成员变量或方法，如果要访问外部类的成员变量，可以使用 this 关键字。如上述代码中：a.this。

> 注：成员内部类不能含有 static 的变量和方法，因为成员内部类需要先创建了外部类，才能创建它自己的。

17. 静态内部类通常被称为嵌套类。

静态内部类是 static 修饰的内部类，这种内部类的特点是：

- 静态内部类不能直接访问外部类的非静态成员，但可以通过 new 外部类().成员 的方式访问。
- 如果外部类的静态成员与内部类的成员名称相同，可通过 类名.静态成员 访问外部类的静态成员；如果外部类的静态成员与内部类的成员名称不相同，则可通过 成员名 直接- 调用外部类的静态成员。
- 创建静态内部类的对象时，不需要外部类的对象，可以直接创建 内部类 对象名 = new 内部类();。

```java
public class People {
    private String name = "lilei";
    static String ID = "630391197812151931";
    public static class Student {
        String ID  = "20150815";
        public void stuInfo(){
            System.out.println("访问外部类中的 name ：" + (new People().name));
            System.out.println("访问外部类中的 ID：" + People.ID);
            System.out.println("访问内部类中的 ID：" + ID);
        }
    }
    public static void main(String[] args){
        Student b = new Student();
        b.stuInfo();
    }
}
```

18. 局部内部类，局部内部类也像别的类一样进行编译，但是作用域不同，只在该方法或条件的作用域内才能使用，退出这些作用域后无法引用的。

```java
public class People {
    public void peopleInfo(){
        final String  sex = "man";
        class Student {
            String ID = "20150815";
            public void print(){
                System.out.println("访问外部类的方法中的常量 sex ：" + sex);
                System.out.println("访问内部类中的变量ID：" + ID);
            }
        }
        Student a = new Student();
        a.print();
    }
    public void peopleInfo2(boolean b){
        if(b){
            final String sex = "man";
            class Student {
                String ID = "20151234";
                public void print(){
                    System.out.println("访问外部类的方法中的常量 sex: " + sex );
                    System.out.println("访问内部类中的变量 ID：" + ID);
                }
            }
            Student a = new Student();
            a.print();
        }
    }
    public static void main(String[] args){
        People b = new People();
        System.out.println("定义在方法内：==========");
        b.peopleInfo();
        System.out.println("定义在作用域内：+++++++++");
        b.peopleInfo2(true);
    }
}
```

19. 匿名内部类就是没有名字的内部类。正因为没有名字，所以匿名内部类只能使用一次，它通常用来简化代码编写。但使用匿名内部类还有个前提条件：必须继承一个父类或实现一个接口。

```java
public class Outer {
    public Inner getInner(final String name, String city) {
        return new Inner() {
            private String nameStr = name;
            private String cityName = city;
            public String getName(){
                return nameStr;
            }
            public String getCity(){
                return cityName;
            }
        };
    }
    public static void main(String[] args){
        Outer outer = new Outer();
        Inner inner = outer.getInner("Inner", "NewYork");
        System.out.println(inner.getName());
        System.out.println(inner.getCity());
    }
}

interface Inner {
    String getName();
    String getCity();
}
```

匿名内部类是不能加访问修饰符的。要注意的是，new 匿名类，这个类是要先定义的, 如果不先定义，编译时会报错该类找不到。

同时，在上面的例子中，当所在的方法的形参需要在内部类里面使用时，该形参必须为 final。这里可以看到形参 name 已经定义为 final 了，而形参 city 没有被使用则不用定义为 final。


20. 包的作用

把功能相似或相关的类或接口组织在同一个包中，方便类的查找和使用。
包采用了树形目录的存储方式。同一个包中的类名字是不同的，不同的包中的类的名字是可以相同的，当同时调用两个不同包中相同类名的类时，应该加上包名加以区别。
包也限定了访问权限，拥有包访问权限的类才能访问某个包中的类。

如何在不同包中使用另一个包中的类？

使用 import 关键字。比如要导入包 com.shiyanlou 下 People 这个类，import com.shiyanlou.People;。同时如果 import com.shiyanlou.\*; 这是将包下的所有文件都导入进来，\* 是通配符。

包的命名规范是全小写字母拼写。

21. 定义泛型的规则：

- 只能是引用类型，不能是简单数据类型。
- 泛型参数可以有多个。
- 可以用使用 extends 语句或者 super 语句 如 <T extends superClass> 表示类型的上界，T 只能是 superClass 或其子类， <K super childClass> 表示类型的下界，K 只能是 childClass 或其父类。
- 可以是通配符类型，比如常见的 Class<?>。单独使用 ? 可以表示任意类型。也可以结合 extends 和 super 来进行限制。

```java
class Test<T> {
    private T ob;
    public Test(T ob){
        this.ob = ob;
    }
    public T getOb(){
        return ob;
    }
    public void setOb(T ob){
        this.ob = ob;
    }
    public void showType(){
        System.out.println("T的实际类型是：" + ob.getClass().getName());
    }
}

public class TestDemo {
    public static void main(String[] args){
        Test<Integer> intOb = new Test<Integer>(88);
        intOb.showType();
        int i = intOb.getOb();
        System.out.println("value = " + i);
        System.out.println("----------------------------");
        Test<String> strOb = new Test<String>("Hello Gen!");
        strOb.showType();
        String s  = strOb.getOb();
        System.out.println("value = " + s);
    }
}