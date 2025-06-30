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
    model: 'gemini-pro',
    apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
  );
  final List<ChatMessage> _messages = <ChatMessage>[];
  final ChatUser _currentUser = ChatUser(id: '0', firstName: 'User');
  final ChatUser _geminiUser = ChatUser(id: '1', firstName: 'Gemini');
  late final GeminiService _geminiService;

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
        title: const Text('Budget AI Chatbot'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: DashChat(
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
    );
  }

  Future<void> _onSend(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
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
          text: 'Error: ${e.toString()}',
        ),
      );
    }
  }

  void _showBudgetConfirmationDialog(List<Budget> budgets) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Budgets'),
          content: SingleChildScrollView(
            child: ListBody(
              children: budgets
                  .map(
                    (budget) => Text(
                      '${budget.name}: ₦${budget.amount.toStringAsFixed(2)}',
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
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
              child: const Text('Confirm'),
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
