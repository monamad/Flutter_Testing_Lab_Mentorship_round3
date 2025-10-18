import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart_controller.dart';

void main() {
  group('ShoppingCartController Tests', () {
    late ShoppingCartController controller;

    setUp(() {
      controller = ShoppingCartController();
    });

    group('Adding items', () {
      test('should add new item to empty cart', () {
        controller.addItem('1', 'iPhone', 999.99, discount: 1);

        expect(controller.items.length, equals(1));
        expect(controller.totalItems, equals(1));
        expect(controller.containsItem('1'), isTrue);
      });

      test('should increase quantity when adding same item', () {
        controller.addItem('1', 'iPhone', 999.99);
        controller.addItem('1', 'iPhone', 999.99);

        expect(controller.items.length, equals(1));
        expect(controller.totalItems, equals(2));
        expect(controller.getItem('1')?.quantity, equals(2));
      });
      test(
        'should not exceed max quantity when adding the same item repeatedly',
        () {
          for (var i = 0; i < 35; i++) {
            controller.addItem('limited', 'LimitedItem', 10.0);
          }

          final item = controller.getItem('limited');
          expect(item, isNotNull);
          expect(item?.quantity, equals(30));
          expect(controller.totalItems, equals(30));
        },
      );

      test('should add multiple different items', () {
        controller.addItem('1', 'iPhone', 999.99);
        controller.addItem('2', 'Galaxy', 899.99);

        expect(controller.items.length, equals(2));
        expect(controller.totalItems, equals(2));
        expect(controller.containsItem('1'), isTrue);
        expect(controller.containsItem('2'), isTrue);
      });
    });

    group('Removing items', () {
      test('should remove item from cart', () {
        controller.addItem('1', 'iPhone', 999.99);
        controller.removeItem('1');

        expect(controller.items.length, equals(0));
        expect(controller.isEmpty, isTrue);
        expect(controller.containsItem('1'), isFalse);
      });

      test('should not crash when removing non-existent item', () {
        expect(() => controller.removeItem('999'), returnsNormally);
        expect(controller.isEmpty, isTrue);
      });
    });

    group('Updating quantities', () {
      test('should update item quantity', () {
        controller.addItem('1', 'iPhone', 999.99);
        controller.updateQuantity('1', 3);

        expect(controller.getItem('1')?.quantity, equals(3));
        expect(controller.totalItems, equals(3));
      });

      test('should remove item when quantity set to 0', () {
        controller.addItem('1', 'iPhone', 999.99);
        controller.updateQuantity('1', 0);

        expect(controller.items.length, equals(0));
        expect(controller.containsItem('1'), isFalse);
      });

      test('should not crash when updating non-existent item', () {
        expect(() => controller.updateQuantity('999', 5), returnsNormally);
        expect(controller.isEmpty, isTrue);
      });
    });

    group('Cart calculations', () {
      test('should calculate correct subtotal', () {
        controller.addItem('1', 'iPhone', 100.0);
        controller.addItem('2', 'Galaxy', 200.0);
        controller.updateQuantity('1', 2);

        expect(controller.subtotal, equals(400.0));
      });

      test('should calculate correct discount', () {
        controller.addItem('1', 'iPhone', 100.0, discount: 0.1);
        controller.updateQuantity('1', 2);

        expect(controller.totalDiscount, equals(20.0));
      });
      test('should apply 100% discount resulting in zero total amount', () {
        controller.addItem('free', 'FreeItem', 50.0, discount: 1.0);
        controller.updateQuantity('free', 2);

        expect(controller.subtotal, equals(100.0));
        expect(controller.totalDiscount, equals(100.0));
        expect(controller.totalAmount, equals(0.0));
      });
      test('should calculate correct total amount', () {
        controller.addItem('1', 'iPhone', 100.0, discount: 0.1);
        controller.updateQuantity('1', 2);

        expect(controller.subtotal, equals(200.0));
        expect(controller.totalDiscount, equals(20.0));
        expect(controller.totalAmount, equals(180.0));
      });

      test('should return 0 for empty cart', () {
        expect(controller.subtotal, equals(0.0));
        expect(controller.totalDiscount, equals(0.0));
        expect(controller.totalAmount, equals(0.0));
        expect(controller.totalItems, equals(0));
      });
    });

    group('Clear cart', () {
      test('should clear all items', () {
        controller.addItem('1', 'iPhone', 999.99);
        controller.addItem('2', 'Galaxy', 899.99);

        controller.clearCart();

        expect(controller.isEmpty, isTrue);
        expect(controller.totalItems, equals(0));
        expect(controller.subtotal, equals(0.0));
      });
    });

    group('Item queries', () {
      test('should find existing item', () {
        controller.addItem('1', 'iPhone', 999.99);

        final item = controller.getItem('1');
        expect(item, isNotNull);
        expect(item?.name, equals('iPhone'));
        expect(item?.price, equals(999.99));
      });

      test('should return null for non-existent item', () {
        final item = controller.getItem('999');
        expect(item, isNull);
      });

      test('should correctly check if item exists', () {
        controller.addItem('1', 'iPhone', 999.99);

        expect(controller.containsItem('1'), isTrue);
        expect(controller.containsItem('999'), isFalse);
      });
    });
  });
}
