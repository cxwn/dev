import java.util.Scanner;

public class InpuTest {
    public static void main(String[] args){
        Scanner input = new Scanner(System.input);
        int age = input.nextInt();
        String name = input.next();
        System.out.println(age + name);
    }
}
