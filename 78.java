public class Solution {
    public List<List<Integer>> subsets(int[] nums) {
        List<List<Integer>> res = new ArrayList<List<Integer>>();
        List<Integer> ans = new ArrayList<Integer>();
        Arrays.sort(nums);
        helper(res, ans, 0, nums);
        return res;
    }
    
    public void helper(List<List<Integer>> res, List<Integer> ans, int start, int[] nums){
        
        res.add(new ArrayList<Integer>(ans));
        
        for(int i = start; i < nums.length; i++) {
            ans.add(nums[i]);
            helper(res, ans, i+1, nums);
            ans.remove(ans.size()-1);
        }
        
    }
}
