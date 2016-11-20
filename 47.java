public class Solution {
    public List<List<Integer>> permuteUnique(int[] nums) {
        List<List<Integer>> res = new ArrayList<>();
        List<Integer> list = new ArrayList<>();
        Arrays.sort(nums);
        boolean[] visited = new boolean[nums.length];
        this.helper(nums, list, res, visited);
        return res;
    }
    
    private void helper(int[] nums, List<Integer> list, List<List<Integer>> res, boolean[] visited) {
        if(nums.length == list.size()){
            res.add(new ArrayList<Integer>(list));
            return;
        }
        
        for(int i = 0; i < nums.length; i++) {
            if(visited[i] || i > 0 && nums[i] == nums[i-1] && !visited[i - 1]) {
                continue;
            }
            visited[i] = true;
            list.add(nums[i]);
            helper(nums, list, res, visited);
            visited[i] = false;
            list.remove(list.size() - 1);
        }
    }
}
