public class Solution {
    public List<List<Integer>> subsetsWithDup(int[] nums) {
        
        List<List<Integer>> res = new ArrayList<List<Integer>>();
        Arrays.sort(nums);
        helper(nums, 0, res, new ArrayList<Integer>());
        return res;
        
    }
    
    public void helper(int[] nums, int start, List<List<Integer>> res, List<Integer> comb) {
        
        res.add(new ArrayList<Integer>(comb));
        
        for(int i = start; i < nums.length; i++) {
            
            if(i > start && nums[i] == nums[i-1]) continue; //skip duplicate subsets and i>start must be written first
            
            comb.add(nums[i]);
            helper(nums, i+1, res, comb);
            comb.remove(comb.size() - 1);
            
        }
    }
}
