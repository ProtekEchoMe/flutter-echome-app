import 'package:flutter/material.dart';

class StatusListItem extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? status;
  final Function? callback;
  final double? titleTextSize;
  final double? subtitleTextSize;
  const StatusListItem(
      {Key? key,
      this.title,
      this.subtitle,
      this.status,
      this.callback,
      this.titleTextSize,
      this.subtitleTextSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback != null ? callback!() : null;
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        child: ListTile(
          leading: SizedBox(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description),
            ],
          )),
          title: Text(
            title ?? "",
            style: TextStyle(fontSize: titleTextSize ?? 20),
          ),
          subtitle: Text(
            subtitle ?? "",
            style: TextStyle(fontSize: subtitleTextSize ?? 10),
          ),
          trailing: SizedBox(
            width: status != null ? 130 : 40,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  status != null
                      ? Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5)),
                            height: 30,
                            child: FittedBox(
                                child: Text(
                              status!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                        onPressed: null, icon: Icon(Icons.arrow_forward)),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
