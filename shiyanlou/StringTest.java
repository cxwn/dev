public class StringTest {
    public static void main(String[] args){
        String s = new String("Java");
        String m = "java";
        System.out.println("用equals()比较，java和Java结果为：" + s.equals(m));
        System.out.println("用equalsIgnoreCasr()比较，java和Java的 结果为："+s.equalsIgnoreCase(m));
    }    
}
