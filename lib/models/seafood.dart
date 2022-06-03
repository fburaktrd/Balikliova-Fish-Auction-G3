class Seafood {
  String productName;
  double basePrice;
  double latestBid;
  double amount;
  Seafood({
    required this.productName,
    required this.basePrice,
    required this.amount,
    required this.latestBid,
  });

  String getproductName() {
    return this.productName;
  }

  double getFishAmount() {
    return this.amount;
  }

  void setLatestBid(double bid) {
    this.latestBid = bid;
  }

  double getBasePrice() {
    return this.basePrice;
  }

  double getLatestBid() {
    if (this.latestBid == null) {
      return 0;
    } else {
      return this.latestBid;
    }
  }

  void setInfo(List<dynamic> food) {
    this.productName = food[1];
    this.amount = food[2];
    this.basePrice = food[3];
  }
}