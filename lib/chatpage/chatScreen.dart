import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class GeminiChatScreen extends StatefulWidget {
  const GeminiChatScreen({super.key});

  @override
  State<GeminiChatScreen> createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen>
    with AutomaticKeepAliveClientMixin {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "user");
  ChatUser geminiUser = ChatUser(id: "1", firstName: "Geni", profileImage: "https://i.pinimg.com/736x/b9/db/fe/b9dbfe45445cfb500882fec0b46d6b49.jpg");
  XFile? selectedFile; // Store the selected image or video
  MediaType? selectedMediaType; // To distinguish between image and video

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure to call super.build when using mixin
    return Scaffold(
      appBar: AppBar(
        title: Text("FitTrack", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.black,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        if (selectedFile != null) // Show the media preview if a file is selected
          Container(
            margin: const EdgeInsets.all(8.0),
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(12),
            ),
            child: selectedMediaType == MediaType.image
                ? Image.file(File(selectedFile!.path), fit: BoxFit.cover)
                : Center(child: Icon(Icons.videocam, color: Colors.white, size: 50)),
          ),
        Expanded(
          child: DashChat(
            inputOptions: InputOptions(
              inputDecoration: InputDecoration(
                filled: true,
                fillColor: Colors.black,
                hintText: "Say hi, ask about your form by sending a picture/video",
                hintStyle: TextStyle(color: Colors.white60),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              inputTextStyle: const TextStyle(color: Colors.white),
              alwaysShowSend: true,
              trailing: [
                PopupMenuButton<String>(
                  icon: Icon(Icons.attach_file, color: Colors.white),
                  onSelected: (String value) {
                    if (value == 'Image') {
                      _selectMedia(MediaType.image);
                    } else if (value == 'Video') {
                      _selectMedia(MediaType.video);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(value: 'Image', child: Text('Send Image')),
                      PopupMenuItem(value: 'Video', child: Text('Send Video')),
                    ];
                  },
                ),
              ],
            ),
            currentUser: currentUser,
            onSend: _sendMessage,
            messages: messages,
          ),
        ),
      ],
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    // Add the selected file to the message if available
    if (selectedFile != null) {
      chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: chatMessage.text,
        medias: [
          ChatMedia(url: selectedFile!.path, fileName: "", type: selectedMediaType!)
        ],
      );
    }

    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? mediaData;
      if (selectedFile != null) {
        mediaData = [File(selectedFile!.path).readAsBytesSync()];
      }
      gemini.streamGenerateContent(question, images: mediaData).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts
              ?.fold("", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts
              ?.fold("", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print("Error$e");
    } finally {
      selectedFile = null; // Clear the selected file after sending
    }
  }

  void _selectMedia(MediaType type) async {
    ImagePicker picker = ImagePicker();
    XFile? file;
    if (type == MediaType.image) {
      file = await picker.pickImage(source: ImageSource.gallery);
    } else if (type == MediaType.video) {
      file = await picker.pickVideo(source: ImageSource.gallery);
    }

    if (file != null) {
      setState(() {
        selectedFile = file; // Store the selected file (image or video)
        selectedMediaType = type; // Store the media type (image or video)
      });
    }
  }

  @override
  bool get wantKeepAlive => true; // Ensure that the state is kept alive
}
