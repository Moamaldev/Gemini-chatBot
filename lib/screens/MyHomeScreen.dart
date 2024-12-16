import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geminiai/methods/Message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geminiai/theam/theamState.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class MyHomeScreen extends ConsumerStatefulWidget {
  const MyHomeScreen({super.key});

  @override
  ConsumerState<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends ConsumerState<MyHomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _message = [];
  bool isloding = false;

  callGeminiModel() async {
    try {
      if (_controller.text.isNotEmpty) {
        _message.add(Message(text: _controller.text, isUser: true));
        isloding = true;
      }

      final model = GenerativeModel(
          model: 'gemini-pro', apiKey: dotenv.env['GOOGLE_API_KEY']!);
      final prompt = _controller.text.trim();
      final content = [Content.text(prompt)];
      final respons = await model.generateContent(content);

// from gemini
      setState(() {
        _message.add(Message(text: respons.text!, isUser: false));
        isloding = false;
      });
      _controller.clear();
    } catch (e) {
      print("e in callGeminiModel : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    final currentTheam = ref.watch(themeProvider);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 1,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/gpt-robot.png',
                    color: Colors.blueAccent,
                    width: 35,
                    height: 25,
                  ),
                  SizedBox(
                    width: w * 0.02,
                  ),
                  Text(
                    'Gemini Gpt Clone',
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ],
              ),
              GestureDetector(
                  onTap: () {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                  child: (currentTheam == ThemeMode.light)
                      ? Icon(
                          Icons.dark_mode,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.light_mode,
                          color: Colors.blueAccent,
                        ))
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _message.isEmpty
                  ? Center(
                      child: Text(
                        'Schreib Etwas...',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _message.length,
                      itemBuilder: (ctx, i) {
                        final message = _message[i];
                        return ListTile(
                          title: Align(
                            alignment: message.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: message.isUser
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                    borderRadius: message.isUser
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20))
                                        : const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),
                                child: Text(
                                  message.text,
                                  style: message.isUser
                                      ? Theme.of(context).textTheme.bodyMedium
                                      : Theme.of(context).textTheme.bodySmall,
                                )),
                          ),
                        );
                      }),
            ),

            //user input
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 25, top: 16.0, right: 16, left: 16),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: _controller,
                        style: Theme.of(context).textTheme.titleSmall,
                        decoration: InputDecoration(
                            prefix: Padding(padding: EdgeInsets.all(8)),
                            hintText: "Schreib dein NachRecht",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: h * 0.009)),
                      ),
                    ),
                    SizedBox(
                      width: w * 0.03,
                    ),
                    isloding == true
                        ? Padding(
                            padding: EdgeInsets.all(16),
                            child: SizedBox(
                              width: w * 0.020,
                              height: h * 0.020,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              child: Icon(Icons.send_rounded,
                                  color: Colors.blueAccent),
                              onTap: callGeminiModel,
                            ),
                          )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
