public class Solution {
    public List<List<String>> solveNQueens(int n) {
        List<List<String>> res = new ArrayList<List<String>>();
        char[][] board = new char[n][n];
        for(int i = 0; i < n; i++)
            for(int j = 0; j < n; j++)
                board[i][j] = '.';
        dfs(board, 0, res);
        return res;
    }
    
    private void dfs(char[][] board, int i, List<List<String>> res) {
        if(i == board.length) {
            res.add(construct(board));
            return;
        }
        
        for(int j = 0; j < board.length; j++) {
            if(isValid(board, i, j)) {
                board[i][j] = 'Q';
                dfs(board, i + 1, res);
                board[i][j] = '.';
            }
        }
    }
    
    private boolean isValid(char[][] board, int i, int j) {
        for(int p = 0; p < i; p++) {
            for(int q = 0; q < board.length; q++) {
                if(board[p][q] =='Q' && (q==j || Math.abs(q-j) == Math.abs(p-i)))
                    return false;
            }
        }
        return true;
    }
    
    private List<String> construct(char[][] board) {
        List<String> res = new ArrayList<>();
        for(int i = 0; i < board.length; i++) {
            String s = new String(board[i]);
            res.add(s);
        }
        return res;
    }
}
