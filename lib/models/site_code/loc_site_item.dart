class LocSiteItem {
  int? id;
  String? siteCode;
  String? address;
  String? description;

  LocSiteItem({this.id, this.siteCode, this.address, this.description});

  LocSiteItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteCode = json['siteCode'];
    address = json['address'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['siteCode'] = this.siteCode;
    data['address'] = this.address;
    data['description'] = this.description;
    return data;
  }
}