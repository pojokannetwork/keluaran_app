import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class ResultData {
  final String tanggal;
  final String hari;
  final String sgp;
  final String hk;
  final String sdy;

  ResultData({
    required this.tanggal,
    required this.hari,
    required this.sgp,
    required this.hk,
    required this.sdy,
  });
}

Future<List<ResultData>> fetchResults() async {
  final url = 'https://spinoria.guru/angka-keluaran/';
  final res = await http.get(Uri.parse(url), headers: {
    'User-Agent': 'Mozilla/5.0 (Android; Mobile) KeluaranApp/1.0'
  });

  if (res.statusCode != 200) {
    throw Exception('Gagal ambil data: ${res.statusCode}');
  }

  final doc = html.parse(res.body);
  // Selector generik: sesuaikan jika struktur HTML berubah
  final rows = doc.querySelectorAll('table tr');
  final results = <ResultData>[];

  for (final row in rows.skip(1)) {
    final cols = row.querySelectorAll('td').map((e) => e.text.trim()).toList();
    // Diharapkan urutan kolom: tanggal, hari, SGP, HK, SDY
    if (cols.length >= 5 && cols[0].isNotEmpty) {
      results.add(ResultData(
        tanggal: cols[0],
        hari: cols[1],
        sgp: cols[2],
        hk: cols[3],
        sdy: cols[4],
      ));
    }
  }
  return results;
}
