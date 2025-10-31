
import 'fetch_service.dart';

Map<String, int> digitFrequency(List<ResultData> results, {String? pasar}) {
  final freq = <String, int>{};

  Iterable<String> values(ResultData r) {
    if (pasar == 'HK') return [r.hk];
    if (pasar == 'SGP') return [r.sgp];
    if (pasar == 'SDY') return [r.sdy];
    return [r.sgp, r.hk, r.sdy];
  }

  for (final r in results) {
    for (final num in values(r)) {
      for (final ch in num.split('')) {
        if (RegExp(r'^\d$').hasMatch(ch)) {
          freq[ch] = (freq[ch] ?? 0) + 1;
        }
      }
    }
  }

  return Map.fromEntries(
    List.generate(10, (i) => '$i').map((d) => MapEntry(d, freq[d] ?? 0)),
  );
}
