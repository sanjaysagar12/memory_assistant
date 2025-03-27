import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../theme/app_theme.dart';

class AIAssistant extends StatefulWidget {
  const AIAssistant({Key? key}) : super(key: key);

  @override
  _AIAssistantState createState() => _AIAssistantState();
}

class _AIAssistantState extends State<AIAssistant> with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';
  TextEditingController _textController = TextEditingController();
  bool _speechAvailable = false;
  
  // Animation controller for wave animation
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _initSpeech();
    
    // Setup animation controller for voice waves
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onError: (error) => print('Speech recognition error: $error'),
      onStatus: (status) {
        print('Speech recognition status: $status');
        if (status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
    );
    setState(() {});
  }

  void _startListening() async {
    if (_speechAvailable) {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
            _textController.text = _recognizedText;
          });
        },
      );
    } else {
      setState(() => _isListening = false);
      print('Speech recognition not available');
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }
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
      child: Center(
        child: Column(
          children: [
            // Upper section - AI Assistant header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.smart_toy,
                      size: 48,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "AI Assistant",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "How can I help you today?",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            
            // Middle section - Chat area
            Expanded(
              child: Container(
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
                              _recognizedText.isNotEmpty
                                  ? "I heard: $_recognizedText"
                                  : "I'm ready to assist with your daily activities, remind you of important events, help identify people, or provide directions.",
                              style: TextStyle(
                                fontSize: 15,
                                color: AppTheme.secondaryTextColor,
                              ),
                            ),
                            if (_recognizedText.isNotEmpty) ...[
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    icon: Icon(Icons.refresh),
                                    label: Text("Clear"),
                                    onPressed: () {
                                      setState(() {
                                        _recognizedText = '';
                                        _textController.clear();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
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
                      ],
                    ),
                  ],
                ),
              ),
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
                          ),
                        ),
                        // Microphone button
                        IconButton(
                          onPressed: _isListening ? _stopListening : _startListening,
                          icon: Icon(
                            _isListening ? Icons.stop_circle : Icons.mic,
                            color: _isListening ? Colors.red : AppTheme.primaryColor,
                            size: 28,
                          ),
                        ),
                        // Send button
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: AppTheme.primaryColor,
                          ),
                          onPressed: _textController.text.isEmpty
                              ? null
                              : () {
                                  // Process the text input
                                  print('Processing: ${_textController.text}');
                                  // Clear after processing if needed
                                  // _textController.clear();
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      labelStyle: TextStyle(color: AppTheme.primaryColor),
      onPressed: () {
        setState(() {
          _textController.text = text;
        });
      },
    );
  }
}