import 'package:myapp/controllers/auctionTableController.dart';

class AuctionTable {
  final String id;
  final String coopHeadId;
  bool isPublished = false;
  AuctionTableController controller = AuctionTableController();
  List<List<dynamic>> seafoodProducts = [];

  AuctionTable(
      {required this.id,
      required this.coopHeadId,
      required this.seafoodProducts,
      this.isPublished = false});

  void updateRowTable(String rowNo, List<dynamic> updatedInfo) {
    print(this.id);
    controller.updateProductToTableDb(this.id, rowNo, updatedInfo);
  }

  void publishTable() {
    this.isPublished = true;
    controller.publishTable(this.id);
  }

  void addProduct(List<dynamic> productInfo) {
    this.seafoodProducts.add(productInfo);
    controller.addProductToTableDb(this.id, productInfo);
  }
}
