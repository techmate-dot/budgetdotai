import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:provider/provider.dart';
import '../services/gemini_service.dart';
import '../providers/budget_provider.dart';
import '../models/budget.dart';

class ChatBotAiPage extends StatefulWidget {
  const ChatBotAiPage({Key? key}) : super(key: key);

  @override
  State<ChatBotAiPage> createState() => _ChatBotAiPageState();
}

class _ChatBotAiPageState extends State<ChatBotAiPage> {
  final _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
  );
  final List<ChatMessage> _messages = <ChatMessage>[];
  final ChatUser _currentUser = ChatUser(id: '0', firstName: 'User');
  final ChatUser _geminiUser = ChatUser(id: '1', firstName: 'Budget Buddy');
  late final GeminiService _geminiService;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.insert(
      0,
      ChatMessage(
        user: _geminiUser,
        createdAt: DateTime.now(),
        text: 'Hello! I can help you create budgets. Tell me what you need.',
      ),
    );
    _geminiService = GeminiService(model: _model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Buddy'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Stack(
        children: [
          DashChat(
            currentUser: _currentUser,
            onSend: _onSend,
            messages: _messages,
            messageOptions: const MessageOptions(
              currentUserContainerColor: Color.fromRGBO(0, 166, 126, 1),
              containerColor: Color.fromRGBO(67, 104, 80, 1),
              textColor: Colors.white,
            ),
            inputOptions: InputOptions(
              inputTextStyle: const TextStyle(color: Colors.white),
              inputDecoration: InputDecoration(
                hintText: 'Type your budget request...',
                hintStyle: const TextStyle(color: Colors.white54),
                fillColor: Colors.blueGrey[800],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
              ),
              sendButtonBuilder: (send) {
                return IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: send,
                );
              },
            ),
          ),
          if (_isTyping)
            Positioned(
              left: 0,
              right: 0,
              bottom: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(67, 104, 80, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Budget Buddy is typing',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onSend(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });
    try {
      final List<Budget> budgets = await _geminiService.processUserRequest(
        message.text,
      );
      if (budgets.isNotEmpty) {
        _showBudgetConfirmationDialog(budgets);
      } else {
        final geminiResponse = await _geminiService.getChatResponse(
          message.text,
        );
        _messages.insert(
          0,
          ChatMessage(
            user: _geminiUser,
            createdAt: DateTime.now(),
            text: geminiResponse,
          ),
        );
      }
    } catch (e) {
      _messages.insert(
        0,
        ChatMessage(
          user: _geminiUser,
          createdAt: DateTime.now(),
          text: 'Error: \${e.toString()}',
        ),
      );
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }

  void _showBudgetConfirmationDialog(List<Budget> budgets) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          title: const Text(
             'Confirm Budgets',
             style: TextStyle(color: Colors.white),
           ),
          content: SingleChildScrollView(
            child: ListBody(
              children: budgets
                  .map(
                    (budget) => Text(
                      '${budget.name}: ₦${budget.amount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _messages.insert(
                    0,
                    ChatMessage(
                      user: _geminiUser,
                      createdAt: DateTime.now(),
                      text: 'Budget creation cancelled.',
                    ),
                  );
                });
              },
            ),
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                final budgetProvider = Provider.of<BudgetProvider>(
                  context,
                  listen: false,
                );
                for (final budget in budgets) {
                  budgetProvider.addBudget(budget);
                }
                Navigator.of(context).pop();
                setState(() {
                  _messages.insert(
                    0,
                    ChatMessage(
                      user: _geminiUser,
                      createdAt: DateTime.now(),
                      text: 'Budgets created successfully!',
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}
