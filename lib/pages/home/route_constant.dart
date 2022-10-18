import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class RouteConstant {
  // static Map<String, RouteObject> getRouteMap = {
  //   "AR": RouteObject("home".tr(gender: "ar_title"), "home".tr(gender: "ar_subtitle"), "/asset_registration",
  //       MdiIcons.accessPointPlus),
  //   "INV": RouteObject("home".tr(gender: "inv_titile"), "home".tr(gender: "inv_subtitle"), "/asset_inventory",
  //       MdiIcons.warehouse),
  //   "TI": RouteObject("home".tr(gender: "ti_titile"), "home".tr(gender: "ti_subtitle"), "/transfer_in",
  //       MdiIcons.inboxArrowDown),
  //   "TO": RouteObject("home".tr(gender: "to_titile"), "home".tr(gender: "to_subtitle"), "/transfer_out",
  //       MdiIcons.inboxArrowUp),
  //   "ARTN": RouteObject("home".tr(gender: "artn_titile"), "home".tr(gender: "artn_subtitle"), "/asset_return",
  //       MdiIcons.messageArrowLeft),
  //   "ADIS": RouteObject("home".tr(gender: "adis_titile"), "home".tr(gender: "adis_subtitle"), "/asset_disposal",
  //     MdiIcons.trashCan,),
  //   "ST": RouteObject("home".tr(gender: "st_titile"), "home".tr(gender: "st_subtitle"), "/stock_take",
  //       MdiIcons.fileDocumentMultipleOutline),
  //   // "SS": RouteObject("Sensor Setting", "Configure your scanner", "/sensor_settings",
  //   // MdiIcons.fileDocumentMultipleOutline),
  //
  //
  //
  //   // RouteObject("Senser Setting", "For Debug", "/debug", MdiIcons.deathStar)
  // };

  static Map<String, RouteObject> getRouteMap() {
    return {
      "AR": RouteObject(
          "home".tr(gender: "ar_title"), "home".tr(gender: "ar_subtitle"),
          "/asset_registration",
          MdiIcons.accessPointPlus),
      "INV": RouteObject(
          "home".tr(gender: "inv_titile"), "home".tr(gender: "inv_subtitle"),
          "/asset_inventory",
          MdiIcons.warehouse),
      "TI": RouteObject(
          "home".tr(gender: "ti_titile"), "home".tr(gender: "ti_subtitle"),
          "/transfer_in",
          MdiIcons.inboxArrowDown),
      "TO": RouteObject(
          "home".tr(gender: "to_titile"), "home".tr(gender: "to_subtitle"),
          "/transfer_out",
          MdiIcons.inboxArrowUp),
      "ARTN": RouteObject(
          "home".tr(gender: "artn_titile"), "home".tr(gender: "artn_subtitle"),
          "/asset_return",
          MdiIcons.messageArrowLeft),
      "ADIS": RouteObject(
        "home".tr(gender: "adis_titile"), "home".tr(gender: "adis_subtitle"),
        "/asset_disposal",
        MdiIcons.trashCan,),
      "ST": RouteObject(
          "home".tr(gender: "st_titile"), "home".tr(gender: "st_subtitle"),
          "/stock_take",
          MdiIcons.fileDocumentMultipleOutline),
      // "SS": RouteObject("Sensor Setting", "Configure your scanner", "/sensor_settings",
      // MdiIcons.fileDocumentMultipleOutline),


      // RouteObject("Senser Setting", "For Debug", "/debug", MdiIcons.deathStar)
    };
  }

  static List<RouteObject> getRouteObjectList = getRouteMap().values.toList();
  static List<String?> getRouteKeysList = getRouteMap().keys.toList();

}

class RouteObject {
  String title;
  String description;
  String routeName;
  IconData icons;
  RouteObject(this.title, this.description, this.routeName, this.icons);
}