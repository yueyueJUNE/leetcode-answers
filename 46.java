public class Solution {
    public List<List<Integer>> permute(int[] nums) {
        List<List<Integer>> res = new ArrayList<>();
        List<Integer> list = new ArrayList<>();
        this.helper(nums, list, res);
        return res;
    }
    
    private void helper(int[] nums, List<Integer> list, List<List<Integer>> res) {
        if(nums.length == list.size()){
            res.add(new ArrayList<Integer>(list));
            return;
        }
        
        for(int i = 0; i < nums.length; i++) {
            if(list.contains(nums[i])) {
                continue;
            }
            list.add(nums[i]);
            helper(nums, list, res);
            list.remove(list.size() - 1);
        }
    }
}
