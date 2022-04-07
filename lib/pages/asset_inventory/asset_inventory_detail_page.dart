import 'package:echo_me_mobile/models/asset_inventory/asset_inventory_item.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:flutter/material.dart';

class AssetInventoryDetailPage extends StatefulWidget {
  AssetInventoryItem? item;
  AssetInventoryDetailPage({Key? key, AssetInventoryItem? item})
      : super(key: key) {
    this.item = item;
  }
  @override
  State<AssetInventoryDetailPage> createState() =>
      _AssetInventoryDetailPageState();
}

class _AssetInventoryDetailPageState extends State<AssetInventoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.item);
    var list = widget.item != null
        ? widget.item!
            .toJson()
            .keys
            .map((e) => [e, widget.item!.toJson()[e]])
            .toList()
        : [];
    print(list);
    return Scaffold(
      appBar: EchoMeAppBar(),
      body: SizedBox.expand(
        child: Column(
          children: [
            BodyTitle(
              title: "Inventory Details",
              clipTitle: "Hong Kong-DC",
            ),
            Expanded(
              child: AppContentBox(
                child: widget.item != null
                    ? ListView.separated(
                        itemBuilder: (ctx, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text((list[index] as List)[0].toString()),
                                  Text((list[index] as List)[1].toString()),
                                ],
                              ),
                        ),
                        separatorBuilder: (ctx, int) =>
                            const Divider(color: Colors.grey),
                        itemCount: widget.item!.toJson().length)
                    : const Center(child: Text("No data")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
