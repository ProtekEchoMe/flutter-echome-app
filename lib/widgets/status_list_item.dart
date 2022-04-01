import 'package:flutter/material.dart';

class StatusListItem extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? status;
  final Function? callback;
  const StatusListItem(
      {Key? key, this.title, this.subtitle, this.status, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        title: Text(title ?? "", style: TextStyle(fontSize: 20),),
        subtitle: Text(
          subtitle ?? "",
          style: const TextStyle(fontSize: 10),
        ),
        trailing: SizedBox(
          width: 130, 
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    height: 30,
                    child: FittedBox(
                        child: Text(
                      status ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                      onPressed: () {
                        callback != null ? callback!() : null;
                      },
                      icon: Icon(Icons.arrow_forward)),
                )
              ]),
        ),
      ),
    );
  }
}
