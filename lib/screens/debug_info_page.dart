import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../classes/messagging.dart' as messagging;
import '../classes/supabase.dart';

class DebugInfoPage extends StatelessWidget {
  const DebugInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: messagging.getFcmToken(),
            builder: (context, result) {
              final token = result.data;
              return ListView(children: [
                ListTile(
                  title: const Text("FCM token"),
                  subtitle: Text(token ?? "Not available"),
                  onLongPress: token == null
                      ? null
                      : () async {
                          await Clipboard.setData(ClipboardData(text: token));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Kopyalandı")));
                          }
                        },
                ),
                ElevatedButton(
                    onPressed: token == null ? null : triggerTestNotification,
                    child: const Text("Test bildirimi gönder"))
              ]);
            }));
  }
}
