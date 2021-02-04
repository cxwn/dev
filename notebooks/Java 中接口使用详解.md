
1. Java中，一个类实现某个接口，必须重写接口中的所有方法吗？

不一定，关键要看子类是否是抽象类。

如果子类是非抽象类，则必须实现接口中的所有方法；
```java
public class Array {
    public static void main(String[] args){
        int [] num = {1,3,5,4};
        System.out.println(num.length);
    }
    
}

public class Sparrow extends Bird {
    public void call(){
        System.out.println("Sparrow call.");
    }
    public void run(){
        System.out.println("Sparrow run.");
    }
    public static void main(String[] args){
        Sparrow s = new Sparrow();
        s.call();
        s.run();
    }
}
```
如果子类是抽象类，则可以不实现接口中的所有方法，因为抽象类中允许有抽象方法的存在！