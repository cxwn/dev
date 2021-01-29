public class People {
    double height;
    int age;
    int sex;
    void cry(){
        System.out.println("I am crying......");
    }
    void laugh(){
        System.out.println("I am laugh...  ...");
    }
    void printBaseMes(){
        System.out.println("我的身高是" + height + "cm");
        System.out.println("我的年龄是" + age + "岁");
        if  (this.sex == 0){
            System.out.println("我的性别是男");
        }
        else{
            System.out.println("我的性别是女性！");
        }
    }
    
public static void main(String[] agrs) {
    People ivandu = new People();
    ivandu.cry();
    ivandu.laugh();
}   
}