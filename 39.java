public class Solution {
    public List<List<Integer>> combinationSum(int[] candidates, int target) {
        List<List<Integer>> res = new ArrayList<List<Integer>>();
        Arrays.sort(candidates);
        helper(target, res, new ArrayList<Integer>(),candidates,0);
        return res;
    }
    
    public void helper(int target, List<List<Integer>> res, List<Integer> comb, int[] candidates, int start){
        if(target < 0) return;
        if(target == 0) {
            res.add(new ArrayList<Integer>(comb));
            return;
        }
        
        for(int i = start; i < candidates.length; i++) {
            comb.add(candidates[i]);
            helper(target - candidates[i], res, comb, candidates,i);
            comb.remove(comb.size() - 1);
        }
        
    }
    
    
}
