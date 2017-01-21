public class Solution {
    public List<List<Integer>> combine(int n, int k) {
        List<List<Integer>> res = new ArrayList<List<Integer>>();
        List<Integer> ans = new ArrayList<Integer>();
        helper(res, ans, 1, n, k);
        return res;
    }
    
    public void helper(List<List<Integer>> res, List<Integer> ans, int start, int n, int k){
        
        if(k == ans.size()) {
            res.add(new ArrayList<Integer>(ans));
            return;
        }
        for(int i = start; i <= n; i++) {
            ans.add(i);
            helper(res, ans, i+1, n, k);
            ans.remove(ans.size()-1);
        }
        
    }
    
}
