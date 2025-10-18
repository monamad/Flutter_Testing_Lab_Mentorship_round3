import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  group('ShoppingCart Widget Tests', () {
    testWidgets('should display all add buttons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      expect(find.text('Add iPhone'), findsOneWidget);
      expect(find.text('Add Galaxy'), findsOneWidget);
      expect(find.text('Add iPad'), findsOneWidget);
      expect(find.text('Add iPhone Again'), findsOneWidget);
    });

    testWidgets('should show empty cart message initially', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
      expect(find.text('Total Amount: \$0.00'), findsOneWidget);
    });

    testWidgets('should add item when button is tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      // Tap add iPhone button
      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();

      // Check if item appears
      expect(find.text('Cart is empty'), findsNothing);
      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.text('Total Items: 1'), findsOneWidget);
    });

    testWidgets('should show correct price and total', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      // Add iPhone
      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();

      // Check price display
      expect(find.text('Price: \$999.99 each'), findsOneWidget);
      expect(find.text('Item Total: \$999.99'), findsOneWidget);
      expect(find.text('Subtotal: \$999.99'), findsOneWidget);
    });

    testWidgets('should increase quantity when adding same item', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      // Add iPhone twice
      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add iPhone Again'));
      await tester.pumpAndSettle();

      // Should show quantity 2 and total items 2
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Total Items: 2'), findsOneWidget);
      expect(find.text('Item Total: \$1999.98'), findsOneWidget);
    });

    testWidgets('should remove item when delete button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      // Add an item
      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();

      // Tap delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Should be empty again
      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
    });

    testWidgets('should update quantity with plus/minus buttons', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      // Add an item
      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();

      // Increase quantity
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget); // quantity should be 2
      expect(find.text('Total Items: 2'), findsOneWidget);

      // Decrease quantity
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget); // quantity should be back to 1
      expect(find.text('Total Items: 1'), findsOneWidget);
    });

    testWidgets('should clear cart when clear button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      // Add some items
      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Galaxy'));
      await tester.pumpAndSettle();

      // Clear cart
      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();

      // Should be empty
      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
    });

    testWidgets('should show discount information', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      // Add iPhone (has 10% discount)
      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();

      // Check discount display
      expect(find.text('Discount: 10%'), findsOneWidget);
      expect(find.text('Total Discount: \$0.10'), findsOneWidget);
    });

    testWidgets('should add multiple different items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      // Add different items
      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Galaxy'));
      await tester.pumpAndSettle();

      // Should show 3 items
      expect(find.text('Total Items: 3'), findsOneWidget);
      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.text('Samsung Galaxy'), findsOneWidget);
      expect(find.text('iPad Pro'), findsOneWidget);
    });
  });
}
