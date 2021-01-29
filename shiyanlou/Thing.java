public class Thing {
    public int age = 10;
    public Thing(int age){

    }
    public void getAge(){
        System.out.println(age);
    }
    public static void main(String[] args){
        Thing s = new Thing(20);
        s.getAge();
    }
}
