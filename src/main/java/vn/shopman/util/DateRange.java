package vn.shopman.util;

import java.time.LocalDate;

public final class DateRange {
    private static final LocalDate FIRST_MYSQL_DATE = LocalDate.of(1000, 1, 1);
    private static final LocalDate LAST_INCLUSIVE_END = LocalDate.of(9999, 12, 30);

    private DateRange() {
    }

    // Converts an inclusive date range to a safe exclusive JDBC end date.
    public static LocalDate exclusiveEnd(LocalDate start, LocalDate end) {
        if (start == null || end == null
                || start.isBefore(FIRST_MYSQL_DATE)
                || end.isAfter(LAST_INCLUSIVE_END)
                || end.isBefore(start)) {
            throw new IllegalArgumentException("Khoảng ngày không hợp lệ.");
        }

        return end.plusDays(1);
    }
}
