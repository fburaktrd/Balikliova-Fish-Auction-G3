class AuctionTable{
  final String uid;
  List<String>? products;
  List<int>? basePrices;
  List<int>? quantities;
  List<int>? soldPrices;
  List<String>? rowID;

  AuctionTable({
      required this.uid,
      required this.products,
      required this.basePrices,
      required this.quantities,
      required this.soldPrices,
      required this.rowID
      });

}