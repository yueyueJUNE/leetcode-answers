public class Solution {
    public boolean exist(char[][] board, String word) {
        if (board == null || board[0] == null || board.length == 0 || board[0].length == 0 || word == null) return false;
        // find the first char of word in board
        for (int i = 0; i < board.length; i++) {
            for (int j = 0; j < board[0].length; j++) {
                if (word.charAt(0) == board[i][j]) {
                    if (dfs(i, j, 0, board, word )) {
                        return true;
                    }
                }
                
            }
        }
        return false;
    }
    
    public boolean dfs(int x, int y, int index, char[][] board, String word) {
        if (index == word.length()) {
            return true;
        }
        if (x < 0 || y < 0 || x >= board.length || y >= board[0].length || board[x][y] != word.charAt(index))
            return false;
        char tmp = board[x][y]; // save the point's value
        board[x][y] = '#'; // mark the point first
        boolean flag = dfs(x - 1, y, index + 1, board, word) ||
        dfs(x, y - 1, index + 1, board, word) ||
        dfs(x + 1, y, index + 1, board, word) ||
        dfs(x, y + 1, index + 1, board, word);
        board[x][y] = tmp;
        return flag;
    }
}
