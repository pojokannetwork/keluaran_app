import 'package:flutter/material.dart';
import 'services/fetch_service.dart';
import 'services/db_service.dart';
import 'services/analytics.dart';
import 'widgets/frequency_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keluaran Analitik',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const ResultPage(),
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});
  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<ResultData> results = [];
  String? pasar; // null = semua, or "HK"/"SGP"/"SDY"
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { loading = true; });
    try {
      final fetched = await fetchResults();
      await DBService.upsertAll(fetched);
      final stored = await DBService.getAll();
      setState(() {
        results = stored;
      });
    } catch (e) {
      final stored = await DBService.getAll();
      setState(() {
        results = stored;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update data: $e')),
        );
      }
    } finally {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayed = results;
    final freq = digitFrequency(displayed, pasar: pasar);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Keluaran'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) => setState(() => pasar = val == 'Semua' ? null : val),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Semua', child: Text('Semua')),
              PopupMenuItem(value: 'HK', child: Text('HK')),
              PopupMenuItem(value: 'SGP', child: Text('SGP')),
              PopupMenuItem(value: 'SDY', child: Text('SDY')),
            ],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.filter_alt),
            ),
          ),
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: displayed.isEmpty
                      ? const Center(child: Text('Tidak ada data'))
                      : ListView.separated(
                          itemCount: displayed.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final r = displayed[i];
                            return ListTile(
                              title: Text('${r.tanggal} • ${r.hari}'),
                              subtitle: Text('SGP: ${r.sgp}  │  HK: ${r.hk}  │  SDY: ${r.sdy}'),
                            );
                          },
                        ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FrequencyChart(data: freq),
                ),
              ],
            ),
    );
  }
}
