import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:swasthya_doot/colors/color_constants.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:swasthya_doot/widgets/common_widget.dart';

class MyAskDidiScreen extends StatefulWidget {
  const MyAskDidiScreen({super.key});

  @override
  State<MyAskDidiScreen> createState() => _MyAskDidiScreenState();
}

class _MyAskDidiScreenState extends State<MyAskDidiScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> _messages =
      []; // now holds {'text', 'time', 'sender'}

  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _speech.stop();
    super.dispose();
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _startListening() async {
    if (_isListening) {
      _stopListening();
      return;
    }

    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorConstants.background_color,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ask Didi',
                    style: TextStyle(
                      fontSize: size.height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'आपका वॉयस-एक्टिवेटेड स्वास्थ्य सहायक',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                children:
                    _messages.reversed.map((msg) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: msg['sender'] == 'user'
                            ? _buildUserMessage(context, msg['text']!, msg['time']!)
                            : _buildBotMessage(context, msg['text']!, msg['time']!),
                      );
                    }).toList(),
              ),
            ),
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      child: Text('🤖', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    const TypingIndicator(),
                  ],
                ),
              ),
            Container(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 8,
                top: 8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            maxLines: 3,
                            minLines: 1,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText:
                                  'अपना स्वास्थ्य संबंधी सवाल टाइप करें...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.mic,
                                    size: 20,
                                    color:
                                        _isListening ? Colors.red : Colors.blue,
                                  ),
                                  onPressed: _startListening,
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    _stopListening();
                                    final userInput = _controller.text.trim();
                                    if (userInput.isEmpty) return;
                                    final time = TimeOfDay.now().format(
                                      context,
                                    );

                                    setState(() {
                                      _messages.add({
                                        'text': userInput,
                                        'time': time,
                                        'sender': 'user',
                                      });
                                      _controller.clear();
                                    });
                                    _scrollToBottom();

                                    setState(() {
                                      _isTyping = true;
                                    });

                                    final classification = await classifyText(
                                      userInput,
                                    );

                                    String botReply;
                                    if (classification == "health" ||
                                        classification == "greeting") {
                                      botReply = await fetchGptReply(userInput);
                                    } else {
                                      botReply =
                                          "[$classification] — मैं सिर्फ स्वास्थ्य से जुड़ी बातों में मदद कर सकती हूँ।";
                                    }

                                    setState(() {
                                      _messages.add({
                                        'text': botReply,
                                        'time': TimeOfDay.now().format(context),
                                        'sender': 'bot',
                                      });
                                      _isTyping = false;
                                    });
                                    _scrollToBottom();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'माइक्रोफ़ोन पर टैप करें बोलना शुरू करने के लिए या अपना सवाल टाइप करें.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                ],
              ),
            ),
            Gap(size.height * 0.1),
          ],
        ),
      ),
    );
  }
}

Widget _buildBotMessage(BuildContext context, String message, String time) {
  return GestureDetector(
    onLongPress: () {
      Clipboard.setData(ClipboardData(text: message));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Copied!')));
    },
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CircleAvatar(child: Text('🤖')),
        const SizedBox(width: 6),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 500),
                  child: Text(message, style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildUserMessage(BuildContext context, String message, String time) {
  return GestureDetector(
    onLongPress: () {
      Clipboard.setData(ClipboardData(text: message));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Copied!')));
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Material(
            elevation: 3,
            shadowColor: Colors.grey.withValues(
              alpha: 51,
              red: 158,
              green: 158,
              blue: 158,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Colors.green.shade400,
            child: Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 10, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        const CircleAvatar(child: Text('🙋')),
      ],
    ),
  );
}

Future<String> classifyText(String text) async {
  final response = await http.post(
    Uri.parse("http://50.16.106.96:8000/classify"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'text': text}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['label'];
  } else {
    return "other";
  }
}

Future<String> fetchGptReply(String text) async {
  final request = http.Request(
    'POST',
    Uri.parse("http://50.16.106.96:8000/ask-stream"),
  );
  request.headers['Content-Type'] = 'application/json';
  request.body = jsonEncode({'text': text});
  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    final chunks = response.body.split(RegExp(r'(?<=[।!?])'));
    return chunks.join(' ').trim();
  } else {
    return "माफ कीजिए, GPT से जवाब नहीं आया।";
  }
}
