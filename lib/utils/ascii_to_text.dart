class AscToText {
  static String getString (String str) {
    String result = "";
    for(var i = 0; i < str.length; i += 2){
      result += String.fromCharCode(int.parse(str.substring(i,i+2), radix: 16));
    }
    return result;
  }
  static String getAscIIString (String str){
     return str.codeUnits.map((e) => e.toRadixString(16)).join("");
  }
}