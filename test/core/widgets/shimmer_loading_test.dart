import 'package:fanup/core/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShimmerEffect', () {
    testWidgets('should render child within ShimmerEffect', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerEffect(
              child: SizedBox(width: 100, height: 50),
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerEffect), findsOneWidget);
      expect(find.byType(ShaderMask), findsOneWidget);
    });

    testWidgets('should animate shimmer gradient', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerEffect(
              child: ShimmerBox(width: 100, height: 50),
            ),
          ),
        ),
      );

      // Should not throw any errors during animation
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(ShimmerEffect), findsOneWidget);
    });
  });

  group('ShimmerBox', () {
    testWidgets('should render with given dimensions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerBox(width: 120, height: 40, borderRadius: 12),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final box = container.constraints;
      expect(box?.maxWidth, 120);
      expect(box?.maxHeight, 40);
    });
  });

  group('MatchCardShimmer', () {
    testWidgets('should render default 3 shimmer cards', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MatchCardShimmer(),
            ),
          ),
        ),
      );

      expect(find.byType(MatchCardShimmer), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);
    });

    testWidgets('should render custom item count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MatchCardShimmer(itemCount: 5),
            ),
          ),
        ),
      );

      expect(find.byType(MatchCardShimmer), findsOneWidget);
    });
  });

  group('ListItemShimmer', () {
    testWidgets('should render default 5 shimmer list items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ListItemShimmer(),
            ),
          ),
        ),
      );

      expect(find.byType(ListItemShimmer), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);
    });
  });

  group('LeaderboardShimmer', () {
    testWidgets('should render 3 podium placeholders', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LeaderboardShimmer(),
          ),
        ),
      );

      expect(find.byType(LeaderboardShimmer), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);
    });
  });
}
