// Small helpers to safely parse JSON values into Dart primitive types.
// Centralizing these avoids duplicating parsing logic across models.

num parseNum(dynamic v, {num fallback = 0}) {
  if (v == null) return fallback;
  if (v is num) return v;
  if (v is String) return num.tryParse(v) ?? fallback;
  try {
    return num.parse(v.toString());
  } catch (_) {
    return fallback;
  }
}

num? parseNumNullable(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  if (v is String) return num.tryParse(v);
  try {
    return num.parse(v.toString());
  } catch (_) {
    return null;
  }
}

int? parseIntNullable(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  try {
    return int.parse(v.toString());
  } catch (_) {
    return null;
  }
}

DateTime? parseDate(dynamic v) {
  if (v == null) return null;
  try {
    return DateTime.tryParse(v.toString());
  } catch (_) {
    return null;
  }
}
