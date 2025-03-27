import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class AIAssistant extends StatefulWidget {
  const AIAssistant({Key? key}) : super(key: key);

  @override
  _AIAssistantState createState() => _AIAssistantState();
}

class Message {
  final String text;
  final bool isUserMessage;
  final String timestamp;
  
  Message({required this.text, required this.isUserMessage, required this.timestamp});
}

class _AIAssistantState extends State<AIAssistant> with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';
  final TextEditingController _textController = TextEditingController();
  bool _speechAvailable = false;
  bool _isLoading = false;
  String? _userId;
  
  // Message history
  List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  
  // Animation controller for wave animation
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _initSpeech();
    _getUserId();
    
    // Setup animation controller for voice waves
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    // Listen for changes to the text field
    _textController.addListener(() {
      setState(() {
        // This forces the send button to update its state
      });
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Get user ID from SharedPreferences
  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId');
    });
    print("User ID: $_userId");
  }

  void _initSpeech() async {
    try {
      print('Initializing speech recognition...');
      _speechAvailable = await _speech.initialize(
        onError: (error) {
          print('Speech recognition error: $error');
          setState(() => _isListening = false);
        },
        onStatus: (status) {
          print('Speech recognition status: $status');
          if (status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
      );
      print('Speech recognition available: $_speechAvailable');
      setState(() {});
    } catch (e) {
      print('Failed to initialize speech recognition: $e');
      _speechAvailable = false;
      setState(() {});
    }
  }

  void _startListening() async {
    if (!_speechAvailable) {
      print('Speech recognition not available, trying to initialize again');
      _initSpeech();
    }
    
    if (_speechAvailable) {
      print('Starting speech recognition');
      setState(() => _isListening = true);
      try {
        await _speech.listen(
          onResult: (result) {
            print('Recognized text: ${result.recognizedWords}');
            setState(() {
              _recognizedText = result.recognizedWords;
              _textController.text = _recognizedText;
            });
          },
        );
      } catch (e) {
        print('Error starting speech recognition: $e');
        setState(() => _isListening = false);
      }
    } else {
      print('Speech recognition still not available');
      setState(() => _isListening = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Speech recognition is not available on this device.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _stopListening() async {
    if (_isListening) {
      print('Stopping speech recognition');
      await _speech.stop();
      setState(() => _isListening = false);
    }
  }

  // Send message to AI API
  Future<void> _sendMessage() async {
    final message = _textController.text.trim();
    if (message.isEmpty) {
      print('Message is empty, not sending');
      return;
    }
    
    print('Sending message: $message');
    
    // Add user message to chat
    final now = DateTime.now().toUtc();
    final timestamp = now.toString();
    
    setState(() {
      _messages.add(Message(
        text: message,
        isUserMessage: true,
        timestamp: timestamp,
      ));
      _isLoading = true;
    });

    // Clear input field
    _textController.clear();
    _recognizedText = '';
    
    // Scroll to bottom
    _scrollToBottom();

    // Check if userId is available
    if (_userId == null) {
      await _getUserId();
      if (_userId == null) {
        setState(() {
          _messages.add(Message(
            text: "Error: User not authenticated. Please log in again.",
            isUserMessage: false,
            timestamp: timestamp,
          ));
          _isLoading = false;
        });
        _scrollToBottom();
        return;
      }
    }
    
    try {
      // Send request to API
      final response = await http.post(
        Uri.parse('https://guideai.selfmade.one/ai/ask'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': _userId,
          'message': message,
        }),
      );
      
      print('API response status: ${response.statusCode}');
      
      // Process response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _messages.add(Message(
            text: responseData['response'] ?? "No response received",
            isUserMessage: false,
            timestamp: responseData['timestamp'] ?? DateTime.now().toUtc().toString(),
          ));
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.add(Message(
            text: "Sorry, I couldn't process your request. Please try again later. (Status: ${response.statusCode})",
            isUserMessage: false,
            timestamp: timestamp,
          ));
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error sending message: $e');
      setState(() {
        _messages.add(Message(
          text: "Network error: Unable to reach the AI service. Please check your connection.",
          isUserMessage: false,
          timestamp: timestamp,
        ));
        _isLoading = false;
      });
    }
    
    _scrollToBottom();
  }
  
  // Process suggestion tap
  void _processSuggestion(String text) {
    _textController.text = text;
    _sendMessage();
  }
  
  // Scroll to bottom of chat
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.backgroundColor,
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          // Upper section - AI Assistant header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.smart_toy,
                    size: 32,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "AI Assistant",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "How can I help you today?",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Middle section - Chat area
          Expanded(
            child: _messages.isEmpty && !_isLoading
                ? _buildEmptyState()
                : _buildChatMessages(),
          ),
          
          // Bottom section - Input area
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Voice input visualization
                if (_isListening)
                  Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            9,
                            (index) {
                              final double height = (index % 3 == 0)
                                  ? 20 + 15 * _animationController.value
                                  : (index % 2 == 0)
                                      ? 30 - 10 * _animationController.value
                                      : 15 + 10 * _animationController.value;
                              
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 1),
                                width: 3,
                                height: height,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.5 + 0.5 * _animationController.value),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                
                // Text input field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: "Ask me anything...",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          enabled: !_isLoading,
                        ),
                      ),
                      // Microphone button
                      IconButton(
                        icon: Icon(
                          _isListening ? Icons.stop_circle : Icons.mic,
                          color: _isLoading
                              ? Colors.grey
                              : (_isListening ? Colors.red : AppTheme.primaryColor),
                          size: 28,
                        ),
                        onPressed: _isLoading 
                            ? null 
                            : () {
                                if (_isListening) {
                                  _stopListening();
                                } else {
                                  _startListening();
                                }
                              },
                      ),
                      // Send button
                      IconButton(
                        icon: _isLoading
                            ? SizedBox(
                                width: 20, 
                                height: 20, 
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.primaryColor,
                                )
                              )
                            : Icon(
                                Icons.send,
                                color: _textController.text.trim().isEmpty
                                    ? Colors.grey
                                    : AppTheme.primaryColor,
                              ),
                        onPressed: (_isLoading || _textController.text.trim().isEmpty)
                            ? null
                            : _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // AI Response Card
          Card(
            margin: EdgeInsets.symmetric(vertical: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                        child: Icon(
                          Icons.assistant,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Memory Assistant",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24),
                  Text(
                    "I'm ready to assist with your daily activities, remind you of important events, help identify people, or provide directions.",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Suggested queries
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "You can ask me:",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppTheme.secondaryTextColor,
              ),
            ),
          ),
          
          // Suggestion chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildSuggestionChip("Where am I?"),
              _buildSuggestionChip("What's my routine today?"),
              _buildSuggestionChip("Who is this person?"),
              _buildSuggestionChip("What's the weather today?"),
              _buildSuggestionChip("When is my next appointment?"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          // Loading indicator bubble
          return _buildMessageBubble(
            isUser: false, 
            message: "", 
            isLoading: true,
          );
        }
        
        final message = _messages[index];
        return _buildMessageBubble(
          isUser: message.isUserMessage,
          message: message.text,
        );
      },
    );
  }

  Widget _buildMessageBubble({
    required bool isUser, 
    required String message, 
    bool isLoading = false
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(isLoading ? 16 : 12),
        decoration: BoxDecoration(
          color: isUser 
              ? AppTheme.primaryColor 
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: 20, 
                  width: 20, 
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primaryColor,
                  ),
                ),
              )
            : Text(
                message,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }
  
  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      labelStyle: TextStyle(color: AppTheme.primaryColor),
      onPressed: () => _processSuggestion(text),
    );
  }
}