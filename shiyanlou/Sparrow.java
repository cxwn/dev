public class Sparrow extends Bird {
    public void call(){
        System.out.println("Sparrow call.");
    }
    public void run(){
        System.out.println("Sparrow run.");
    }
    public void show(){
        System.out.println();
    }
    public static void main(String[] args){
        Sparrow s = new Sparrow();
        s.call();
        s.run();
    }
}
