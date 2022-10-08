import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/core/utils/date_utils.dart';

void main() {
  group('["compareDatesNullable" checks]', () {
    test('Ascending checks', () {
      DateTime? d1;
      DateTime? d2;

      int res = compareDatesNullable(d1, d2);
      expect(res, 0);

      d2 = DateTime(2022);
      res = compareDatesNullable(d1, d2);
      expect(res, 1);

      d1 = DateTime(d2.year, d2.month + 1);
      res = compareDatesNullable(d1, d2);
      expect(res, 1);

      d2 = DateTime(d1.year, d1.month + 1);
      res = compareDatesNullable(d1, d2);
      expect(res, -1);
    });

    test('Descending checks', () {
      DateTime? d1;
      DateTime? d2;

      int res = compareDatesNullable(d1, d2, isDescending: true);
      expect(res, 0);

      d2 = DateTime(2022);
      res = compareDatesNullable(d1, d2, isDescending: true);
      expect(res, 1);

      d1 = DateTime(d2.year, d2.month + 1);
      res = compareDatesNullable(d1, d2, isDescending: true);
      expect(res, -1);

      d2 = DateTime(d1.year, d1.month + 1);
      res = compareDatesNullable(d1, d2, isDescending: true);
      expect(res, 1);
    });
  });

  group('[DateExt checks]', () {
    test('"isSameYMD" checks', () {
      DateTime d1 = DateTime(2022);
      DateTime d2 = DateTime(2022);

      bool res = d1.isSameYMD(d2);
      expect(res, true);

      d1 = d1.add(const Duration(days: 1));
      res = d1.isSameYMD(d2);
      expect(res, false);

      d2 = d1.add(const Duration(days: 1));
      res = d1.isSameYMD(d2);
      expect(res, false);

      d1 = d2.add(const Duration(hours: 23));
      res = d1.isSameYMD(d2);
      expect(res, true);
    });
  });
}
