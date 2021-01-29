public class StaticTest {
    public static String string = "shiyanlou";
    public static void main(String[] srgs){
        System.out.println(StaticTest.string);
        StaticTest  staticTest = new StaticTest();
        System.out.println(staticTest.string);
    }
    
}
