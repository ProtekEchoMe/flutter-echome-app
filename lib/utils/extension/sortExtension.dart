
extension SortBy on List {
  sortBy(List<String> keys) {
    sort((b, a) {
      for(int k=0; k<keys.length; k++) {
        String key = keys[k];
        int comparison = Comparable.compare((a[key]??""), (b[key]??""));
        if(comparison != 0){
          return comparison;
        }
      }
      return 0;
    });
  }

  sortOrderLineBy(List<String> keys, List<int> orderList) {
    sort((( b,  a) {

      // keys.forEach((key) {
      //
      // });

      for(int k=0; k<keys.length; k++) {
        String key = keys[k];
        var c = a;

        int comparison = Comparable.compare(
            a.getVariablebyName(key), b.getVariablebyName(key));
        if(comparison != 0){
          return (orderList[k] > 0) ? comparison: -comparison;
        }
        // return 0;
      }
      return 0;
    }));
  }


}