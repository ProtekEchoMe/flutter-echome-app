import 'package:echo_me_mobile/models/transfer_in/transfer_in_header_item.dart';

class TransferInScanPageArguments {
  final String tiNum;
  TransferInHeaderItem? item;
  TransferInScanPageArguments({ required this.tiNum, TransferInHeaderItem? item}){
    this.item = item;
  }
}