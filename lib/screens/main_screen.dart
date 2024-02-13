import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quran/models/quran_model.dart';
import 'package:http/http.dart' as http;
import 'package:quran/screens/audio_screen.dart';
import 'package:quran/widgets/scroll_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<Quran>> surahs;

  Future<List<Quran>> fetchSurahs() async {
    String url = 'https://equran.id/api/v2/surat';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)['data'];
      List<Quran> data =
          jsonResponse.map((data) => Quran.fromJson(data)).toList();

      return data;
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    surahs = fetchSurahs();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quran App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.green[100],
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            surahs = fetchSurahs();
          });
        },
        child: Container(
          child: FutureBuilder<List<Quran>>(
              future: surahs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final surah = snapshot.data![index];
                      return Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AudioScreen(
                                  data: surah,
                                ),
                              ),
                            );
                          },
                          tileColor: Colors.white,
                          leading: Text('${surah.tempatTurun!}'),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${surah.namaLatin!} - ${surah.nama!}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Arti : ${surah.arti!}'),
                              Text('Jumlah Ayat : ${surah.jumlahAyat}'),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  '${surah.deskripsi!}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return const Text('No data');
                }
              }),
        ),
      ),
      floatingActionButton: ScrollButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        },
        scrollController: _scrollController,
      ),
    );
  }
}
