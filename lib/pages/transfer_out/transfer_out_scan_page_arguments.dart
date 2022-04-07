
import 'package:echo_me_mobile/models/transfer_out/transfer_out_header_item.dart';

class TransferOutScanPageArguments {
  final String shipmentCode;
  TransferOutHeaderItem? item;
  TransferOutScanPageArguments({ required this.shipmentCode, TransferOutHeaderItem? item}){
    this.item = item;
  }
}
