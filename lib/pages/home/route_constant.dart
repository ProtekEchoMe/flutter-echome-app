import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/*class RouteConstant {
  static List<RouteObject> getRouteList = [
    RouteObject("Assets Registration", "Add new asset", "/asset_registration", MdiIcons.accessPointPlus),
    RouteObject("Asset Inventory", "Check you inventory", "/asset_inventory", MdiIcons.warehouse),
    RouteObject("Transfer In", "Receive from other site", "/transfer_in", MdiIcons.inboxArrowDown),
    RouteObject("Transfer Out", "Send to other site", "/transfer_out",  MdiIcons.inboxArrowUp),
    RouteObject("Assets Disposal", "Disposal and write-off", "/asset_disposal", MdiIcons.trashCan,),
    RouteObject("Stock Take", "Count your asset", "/stock_take", MdiIcons.fileDocumentMultipleOutline),

    // RouteObject("Senser Setting", "For Debug", "/debug", MdiIcons.deathStar)
  ];
}*/

class RouteConstant {
  static Map<String, RouteObject> getRouteMap = {
    "AR": RouteObject("Assets Registration", "Add new asset", "/asset_registration",
        MdiIcons.accessPointPlus),
    "INV": RouteObject("Asset Inventory", "Check you inventory", "/asset_inventory",
        MdiIcons.warehouse),
    "TI": RouteObject("Transfer In", "Receive from other site", "/transfer_in",
        MdiIcons.inboxArrowDown),
    "TO": RouteObject("Transfer Out", "Send to other site", "/transfer_out",
        MdiIcons.inboxArrowUp),
    "ARTN": RouteObject("Asset Return", "Return to Inventory", "/asset_return",
        MdiIcons.messageArrowLeft),
    "ADIS": RouteObject("Assets Disposal", "Disposal and write-off", "/asset_disposal",
      MdiIcons.trashCan,),
    "ST": RouteObject("Stock Take", "Count your asset", "/stock_take",
        MdiIcons.fileDocumentMultipleOutline),
    // "SS": RouteObject("Sensor Setting", "Configure your scanner", "/sensor_settings",
    // MdiIcons.fileDocumentMultipleOutline),



    // RouteObject("Senser Setting", "For Debug", "/debug", MdiIcons.deathStar)
  };

  static List<RouteObject> getRouteObjectList = getRouteMap.values.toList();
  static List<String?> getRouteKeysList = getRouteMap.keys.toList();

  // static List<RouteObject> getRouteList = [
  //   RouteObject("Assets Registration", "Add new asset", "/asset_registration", MdiIcons.accessPointPlus),
  //   RouteObject("Asset Inventory", "Check you inventory", "/asset_inventory", MdiIcons.warehouse),
  //   RouteObject("Transfer In", "Receive from other site", "/transfer_in", MdiIcons.inboxArrowDown),
  //   RouteObject("Transfer Out", "Send to other site", "/transfer_out",  MdiIcons.inboxArrowUp),
  //   RouteObject("Asset Return", "Return to Inventory", "/asset_return",  MdiIcons.messageArrowLeft),
  //   RouteObject("Assets Disposal", "Disposal and write-off", "/asset_disposal", MdiIcons.trashCan,),
  //   RouteObject("Stock Take", "Count your asset", "/stock_take", MdiIcons.fileDocumentMultipleOutline),
  //
  //   // RouteObject("Senser Setting", "For Debug", "/debug", MdiIcons.deathStar)
  // ];

  static List<RouteObject> get RouteByACList {

    return [
  RouteObject("Assets Registration", "Add new asset", "/asset_registration", MdiIcons.accessPointPlus),
  RouteObject("Asset Inventory", "Check you inventory", "/asset_inventory", MdiIcons.warehouse),
  RouteObject("Transfer In", "Receive from other site", "/transfer_in", MdiIcons.inboxArrowDown),
  RouteObject("Transfer Out", "Send to other site", "/transfer_out",  MdiIcons.inboxArrowUp),
  RouteObject("Asset Return", "Return to Inventory", "/asset_return",  MdiIcons.messageArrowLeft),
  RouteObject("Assets Disposal", "Disposal and write-off", "/asset_disposal", MdiIcons.trashCan,),
  RouteObject("Stock Take", "Count your asset", "/stock_take", MdiIcons.fileDocumentMultipleOutline)];
  }

// RouteObject("Senser Setting", "For Debug", "/debug", MdiIcons.deathStar)
}

class RouteObject {
  String title;
  String description;
  String routeName;
  IconData icons;
  RouteObject(this.title, this.description, this.routeName, this.icons);
}