int compareDatesNullable(
  DateTime? date1,
  DateTime? date2, {
  bool isDescending = false,
}) {
  int res;

  if (date1 == date2) {
    res = 0;
  } else if ((date1 == null && date2 != null) ||
      (date1 != null && date2 == null)) {
    res = 1;
  } else {
    res = date1!.compareTo(date2!);

    if (isDescending) {
      res = res == 1
          ? -1
          : res == -1
              ? 1
              : res;
    }
  }

  return res;
}
