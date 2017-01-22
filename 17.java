/*
String 字符串常量
StringBuffer 字符串变量（线程安全）
StringBuilder 字符串变量（非线程安全）
简要的说， String 类型和 StringBuffer 类型的主要性能区别其实在于 String 是不可变的对象, 因此在每次对 String 类型进行改变的时候其实都等同于生成了一个新的 String 对象，然后将指针指向新的 String 对象，所以经常改变内容的字符串最好不要用 String ，因为每次生成对象都会对系统性能产生影响，特别当内存中无引用对象多了以后， JVM 的 GC 就会开始工作，那速度是一定会相当慢的。
而如果是使用 StringBuffer 类则结果就不一样了，每次结果都会对 StringBuffer 对象本身进行操作，而不是生成新的对象，再改变对象引用。所以在一般情况下我们推荐使用 StringBuffer ，特别是字符串对象经常改变的情况下。而在某些特别情况下， String 对象的字符串拼接其实是被 JVM 解释成了 StringBuffer 对象的拼接，所以这些时候 String 对象的速度并不会比 StringBuffer 对象慢，而特别是以下的字符串对象生成中， String 效率是远要比 StringBuffer 快的：
*/

/*
solution use string 
 
public class Solution {
    
    private static final String[] KEYS = { "", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz" };
    
    public List<String> letterCombinations(String digits) {
        
        List<String> ret = new LinkedList<String>();
        
        if(digits == null || digits.length() == 0) return ret; //Don't forget this line
        
        combination("", digits, 0, ret);
        return ret;
    }
    
    private void combination(String prefix, String digits, int offset, List<String> ret) {
        if (offset == digits.length()) {
            ret.add(prefix);
            return;
        }
        String letters = KEYS[(digits.charAt(offset) - '0')];
        for (int i = 0; i < letters.length(); i++) {
            combination(prefix + letters.charAt(i), digits, offset + 1, ret);
        }
    }
}
*/

public class Solution {
    
    private static final String[] KEYS = { "", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz" };
    
    public List<String> letterCombinations(String digits) {
        
        List<String> ret = new LinkedList<String>();
        
        if(digits == null || digits.length() == 0) return ret; //Don't forget this line
        
        StringBuffer sb = new StringBuffer();
        
        combination(sb, digits, 0, ret);
        return ret;
    }
    
    private void combination(StringBuffer sb, String digits, int offset, List<String> ret) {
        if (offset == digits.length()) {
            ret.add(sb.toString());
            return;
        }
        String letters = KEYS[(digits.charAt(offset) - '0')];
        for (int i = 0; i < letters.length(); i++) {
            sb.append(letters.charAt(i));
            combination(sb, digits, offset + 1, ret);
            sb.deleteCharAt(sb.length() - 1);
        }
    }
}
