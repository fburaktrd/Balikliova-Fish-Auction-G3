class AuctionTable {
  final String id;
  final String coopHeadId;
  String? isPublished;
  List<List<dynamic>> seafoodProducts = [];

  AuctionTable(
      {required this.id,
      required this.coopHeadId,
      required this.seafoodProducts,
      this.isPublished});
}
