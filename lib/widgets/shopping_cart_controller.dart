class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final double discount; // Discount percentage (0.0 to 1.0)

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.discount = 0.0,
  });

  double get itemTotal => price * quantity;
  double get itemDiscount => discount * quantity;
}

class ShoppingCartController {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(String id, String name, double price, {double discount = 0.0}) {
    final existingIndex = _items.indexWhere((item) => item.id == id);
    print(existingIndex);

    if (existingIndex != -1) {
      // If item exists, increase quantity
      _items[existingIndex].quantity++;
    } else {
      // Add new item
      _items.add(
        CartItem(id: id, name: name, price: price, discount: discount),
      );
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }

  void updateQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
    }
  }

  void clearCart() {
    _items.clear();
  }

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.itemTotal);
  }

  double get totalDiscount {
    return _items.fold(0.0, (sum, item) => sum + item.itemDiscount);
  }

  double get totalAmount {
    return subtotal - totalDiscount;
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty => _items.isEmpty;

  bool containsItem(String id) {
    return _items.any((item) => item.id == id);
  }

  CartItem? getItem(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}
