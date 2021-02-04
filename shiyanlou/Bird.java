public abstract class Bird {
    public final int legs = 2;
    public Bird(){}
    public void call(){
        System.out.println("Bird call.");
    }
    public abstract void run();
}
