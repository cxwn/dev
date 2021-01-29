public class MaxAndMin {
    public static void main(String[] args) {
        int [] nums = {313, 89, 123, 323, 313, 15, 90, 56, 39};
        int max = nums[0];
        int min = nums[0];
        for (int i = 0; i < nums.length; i++){
            if (nums[i] > max){
                max = nums[i];
            }
            if (nums[i] < min){
                min = nums[i];
            }
        }
        System.out.println("Max: "+ max +"\n"+"Min: "+ min);
    }
}
