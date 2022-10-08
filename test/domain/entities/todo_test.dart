import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/src/domain/entities/todo.dart';

void main() {
  group('[Priority extension function checks]', () {
    test('"compareTo" descending checks', () {
      Priority p1 = Priority.none;
      Priority p2 = Priority.none;

      int res = p1.compareTo(p2);
      expect(res, 0);

      p2 = Priority.low;
      res = p1.compareTo(p2);
      expect(res, 1);

      p1 = Priority.medium;
      res = p1.compareTo(p2);
      expect(res, -1);

      p2 = Priority.high;
      res = p1.compareTo(p2);
      expect(res, 1);
    });

    test('"compareTo" ascending checks', () {
      Priority p1 = Priority.none;
      Priority p2 = Priority.none;

      int res = p1.compareTo(p2, isDescending: false);
      expect(res, 0);

      p2 = Priority.low;
      res = p1.compareTo(p2, isDescending: false);
      expect(res, 1);

      p1 = Priority.medium;
      res = p1.compareTo(p2, isDescending: false);
      expect(res, 1);

      p2 = Priority.high;
      res = p1.compareTo(p2, isDescending: false);
      expect(res, -1);
    });
  });
}
