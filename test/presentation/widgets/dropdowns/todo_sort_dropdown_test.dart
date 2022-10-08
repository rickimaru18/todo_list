import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/src/presentation/widgets/dropdowns/todo_sort_dropdown.dart';

import '../../../build_widget.dart';

void main() {
  testWidgets(
    'TodoSortDropdown UI and event checks',
    (WidgetTester tester) async {
      TodoSortBy sortBy = TodoSortBy.none;

      await buildWidget(
        tester,
        TodoSortDropdown(
          onSortBy: (TodoSortBy value) => sortBy = value,
          initialValue: sortBy,
        ),
      );

      expect(find.text('Sort by'), findsOneWidget);
      expect(find.text(sortBy.prettyName), findsOneWidget);

      await tester.tap(find.byType(TodoSortDropdown));
      await tester.pumpAndSettle();

      for (final TodoSortBy tmp in TodoSortBy.values) {
        expect(find.text(tmp.prettyName), findsNWidgets(2));
      }

      await tester.tap(find.text(TodoSortBy.highToLowPriority.prettyName).last);
      await tester.pumpAndSettle();

      expect(sortBy, TodoSortBy.highToLowPriority);
      expect(find.text(sortBy.prettyName), findsOneWidget);
    },
  );

  group('[TodoSortByExt checks]', () {
    test('"prettyName" checks', () {
      TodoSortBy sortBy = TodoSortBy.none;
      expect(sortBy.prettyName, 'None');

      sortBy = TodoSortBy.name;
      expect(sortBy.prettyName, 'Name');

      sortBy = TodoSortBy.highToLowPriority;
      expect(sortBy.prettyName, 'Priority: high -> low');

      sortBy = TodoSortBy.lowToHighPriority;
      expect(sortBy.prettyName, 'Priority: low -> high');

      sortBy = TodoSortBy.dueDateAscending;
      expect(sortBy.prettyName, 'Due date: urgent -> non-urgent');

      sortBy = TodoSortBy.dueDateDescending;
      expect(sortBy.prettyName, 'Due date: non-urgent -> urgent');
    });
  });
}
