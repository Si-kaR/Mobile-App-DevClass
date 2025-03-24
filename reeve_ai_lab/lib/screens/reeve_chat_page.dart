import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:reeve_ai_lab/services/api_service.dart';

class ReeveChatPage extends StatefulWidget {
  const ReeveChatPage({super.key});

  @override
  State<ReeveChatPage> createState() => _ReeveChatPageState();
}

class _ReeveChatPageState extends State<ReeveChatPage> {
  // Finally, adding ChatGPT's chat functionality as API
  // baseOption : http set up : define how long timeout can take
  final _openAI = OpenAI.instance.build(
    token: "apikeyOpenReeveAi",
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
        seconds: 5,
      ),
    ),
    enableLog: true, // plugin to see what's happening
  );

  // Current User
  final ChatUser _currentUser = ChatUser(
    id: '1',
    firstName: 'Robert',
    lastName: 'Sika',
  );

  // ReeveGPTUser
  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: 'Reeve',
    // lastName: '',
  );

  // List of messages
  List<ChatMessage> _messages = <ChatMessage>[];

  // List of users : to see those who are chatting/typing
  List<ChatUser> _typingUsers = <ChatUser>[]; // Empty list of users

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        // backgroundColor: const Color.fromRGBO(0, 166, 126,
        //     1), // Reeve Green - I'll change to pruple cuz I love purple
        backgroundColor: Colors.deepPurple,
        title: const Text(
          '🦚Reeve Ai',
          style: TextStyle(color: Colors.white), // White text
        ),
      ),

      // Body
      body: DashChat(
        currentUser: _currentUser,
        // onSend
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.grey, //User chat's grey
          containerColor: Colors.purple, // Reeve's chat's purple
          textColor: Colors.white, // White text
        ),
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        // List of messages
        messages: _messages,
        typingUsers: _typingUsers, // List of users who are typing
        // message option : this is where we change how the chat will look dialog will look like
      ),

      // Bottom Navigation Bar
    );
  }

  // Added Error Handling
  // Function to get chat response
  // Future<void> getChatResponse(ChatMessage m) async {
  //   setState(() {
  //     _messages.insert(0, m);
  //     _typingUsers.add(_gptChatUser);
  //   });

  //   // Prepare message history
  //   List<Messages> _messagesHistory = _messages.reversed.map((m) {
  //     return Messages(
  //       role: m.user == _currentUser ? Role.user : Role.assistant,
  //       content: m.text,
  //     );
  //   }).toList();

  //   try {
  //     // Build the request with the updated model
  //     final request = ChatCompleteText(
  //       model: Gpt4ChatModel(),
  //       messages: _messagesHistory.map((message) => message.toJson()).toList(),
  //       maxToken: 500,
  //     );

  //     // Get response from OpenAI
  //     final response = await _openAI.onChatCompletion(request: request);

  //     if (response != null && response.choices.isNotEmpty) {
  //       // Extract the first valid message from the response
  //       final reply = response.choices.first.message?.content ??
  //           "Sorry, I didn't understand that.";

  //       setState(() {
  //         _messages.insert(
  //           0,
  //           ChatMessage(
  //             text: reply,
  //             user: _gptChatUser,
  //             createdAt: DateTime.now(),
  //           ),
  //         );
  //       });
  //     }
  //   } catch (e) {
  //     // Handle errors gracefully
  //     setState(() {
  //       _messages.insert(
  //         0,
  //         ChatMessage(
  //           text: "Oops! Something went wrong. Please try again.",
  //           user: _gptChatUser,
  //           createdAt: DateTime.now(),
  //         ),
  //       );
  //     });
  //     debugPrint('Error fetching response: $e');
  //   } finally {
  //     setState(() {
  //       _typingUsers.remove(_gptChatUser);
  //     });
  //   }
  // }
  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });

    // Prepare message history
    List<Messages> _messagesHistory = _messages.reversed.map((msg) {
      return Messages(
        role: msg.user == _currentUser ? Role.user : Role.assistant,
        content: msg.text,
      );
    }).toList();

    try {
      // Build the request with the updated model
      final request = ChatCompleteText(
        model: Gpt4ChatModel(),
        messages: _messagesHistory.map((message) => message.toJson()).toList(),
        maxToken: 500,
      );

      // Get response from OpenAI
      final response = await _openAI.onChatCompletion(request: request);

      if (response != null && response.choices.isNotEmpty) {
        // Extract the first valid message from the response
        final reply = response.choices.first.message?.content ??
            "Sorry, I didn't understand that.";

        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              text: reply,
              user: _gptChatUser,
              createdAt: DateTime.now(),
            ),
          );
        });
      }
    } catch (e) {
      // Handle errors gracefully
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            text: "Oops! Something went wrong. Please try again.",
            user: _gptChatUser,
            createdAt: DateTime.now(),
          ),
        );
      });
      debugPrint('Error fetching response: $e');
    } finally {
      setState(() {
        _typingUsers.remove(_gptChatUser);
      });
    }
  }

  // Future<void> getChatResponse(ChatMessage m) async {
  //   // print(m.text); // Print the message to the console
  //   // Now display messages on screen
  //   setState(() {
  //     //0=index = at 0th index, whenever we get a new message add as first to our list
  //     //m= message
  //     _messages.insert(0,
  //         m); // Now when we type in the message dialog, and press send, it will be added to the list of messages as the first message
  //     _typingUsers.add(_gptChatUser);
  //   });

  //   // After setting baseOption + API.instance
  //   // Telling Reeve what current message and previous messages are : to have context of entire conversation
  //   // Generate specific list of message that I can pass to ChatGPT (ReeveAi)
  //   // Reverse the list of messages because that's how ReeveAi (ChatGPT) will understand the conversation as opposed to what's on the screen

  //   // Prepare message history
  //   List<Messages> _messagesHistory = _messages.reversed.map((msc) {
  //     if (m.user == _currentUser) {
  //       // determining where we're getting our message from
  //       return Messages(role: Role.user, content: m.text); // User's message
  //     } else {
  //       // return Messages(role: Role.system, content: m.text);
  //       return Messages(
  //           role: Role.assistant, content: m.text); // Reeve's message
  //     } // So ChatGPT will decide differentiate which message was from user and which id from Reeve ...to enable it have full context of the conversation
  //   }).toList(); // For every message loop over and change them to something else

  //   // Request
  //   // final request = ChatCompleteText(model: model, messages: messages)
  //   final request = ChatCompleteText(
  //     model: Gpt4ChatModel(),
  //     // model: GptTurbo0301ChatModel(), // cheapest model
  //     messages: _messagesHistory.map((message) => message.toJson()).toList(),
  //     maxToken: 500,
  //   );

  //   // Response
  //   final response = await _openAI.onChatCompletion(request: request);
  //   // request: request); // Saving outputs within response
  //   for (var element in response!.choices) {
  //     if (element.message != null) {
  //       // if chatGPT's message was received and it wasn't null we'l set state
  //       setState(() {
  //         _messages.insert(
  //             0,
  //             ChatMessage(
  //               text: element.message!.content,
  //               user: _gptChatUser,
  //               createdAt: DateTime.now(),
  //             ));
  //       });
  //     }
  //   }
  //   setState(() {
  //     _typingUsers.remove(_gptChatUser);
  //   });
  // }
}
