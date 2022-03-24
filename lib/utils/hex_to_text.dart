class HexToText {
  static String getString (String str) {
    String result = "";
    for(var i = 0; i < str.length; i += 2){
      result += String.fromCharCode(int.parse(str.substring(i,i+2), radix: 16));
    }
    return result;
  }
}