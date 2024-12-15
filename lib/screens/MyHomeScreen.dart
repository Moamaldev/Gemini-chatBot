import 'package:flutter/material.dart';
import 'package:geminiai/methods/Message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geminiai/theam/theamState.dart';

class MyHomeScreen extends ConsumerStatefulWidget {
  const MyHomeScreen({super.key});

  @override
  ConsumerState<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends ConsumerState<MyHomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _message = [
    Message(text: 'Hi', isUser: true),
    Message(text: 'hallo , wie gehts ?', isUser: false),
    Message(text: 'Danke , Super und dir', isUser: true),
    Message(text: 'Gut', isUser: false),
  ];

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
              child: ListView.builder(
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
                                    : Theme.of(context).colorScheme.secondary,
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        child: Icon(
                          Icons.send_rounded,
                          color: _controller.text.isEmpty
                              ? Colors.grey
                              : Colors.blueAccent,
                        ),
                        onTap: () {
                          print('hhh');
                        },
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
