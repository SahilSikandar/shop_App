// ignore_for_file: public_member_api_docs, sort_constructors_first
class CartItemModel {
  String id;
  String title;
  double price;
  int quantity;
  String imgUrl;
  CartItemModel(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity,
      required this.imgUrl});
}
