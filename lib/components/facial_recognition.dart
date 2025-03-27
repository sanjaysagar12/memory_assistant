import 'package:flutter/material.dart';
import 'dart:async';
import '../../theme/app_theme.dart';

class FacialRecognition extends StatefulWidget {
  const FacialRecognition({Key? key}) : super(key: key);

  @override
  _FacialRecognitionState createState() => _FacialRecognitionState();
}

class _FacialRecognitionState extends State<FacialRecognition> {
  bool _isCapturing = false;
  bool _hasPhoto = false;
  String _imagePath = '';
  String? _identifiedPerson;
  bool _isIdentifying = false;

  // User current information
  String _currentTime = "2025-03-27 18:54:58";
  String _username = "sanjaysagar12";

  // Sample photos and names for demonstration
  final List<Map<String, dynamic>> _samplePeople = [
    {
      'name': 'Sarah Johnson',
      'relation': 'Your Daughter',
      'image':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=250',
    },
    {
      'name': 'Michael Johnson',
      'relation': 'Your Son',
      'image':
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=250',
    },
    {
      'name': 'Emma Wilson',
      'relation': 'Your Granddaughter',
      'image':
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=250',
    },
    {
      'name': 'Robert Davis',
      'relation': 'Your Neighbor',
      'image':
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=250',
    },
  ];

  // Take a photo - simulated with a timer
  void _takePhoto() {
    setState(() {
      _isCapturing = true;
    });

    // Simulate camera capture delay
    Timer(Duration(seconds: 2), () {
      // Randomly select a sample person for demonstration
      final person =
          _samplePeople[DateTime.now().second % _samplePeople.length];

      setState(() {
        _isCapturing = false;
        _hasPhoto = true;
        _imagePath = person['image'];

        // Start identification process
        _identifyPerson(person);
      });
    });
  }

  // Identify the person - simulated with a timer
  void _identifyPerson(Map<String, dynamic> person) {
    setState(() {
      _isIdentifying = true;
    });

    // Simulate facial recognition processing
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isIdentifying = false;
        _identifiedPerson = '${person['name']} (${person['relation']})';
      });
    });
  }

  // Retry photo capture
  void _retakePhoto() {
    setState(() {
      _hasPhoto = false;
      _identifiedPerson = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Face Recognition"),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  _username,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppTheme.secondaryColor,
                  radius: 16,
                  child: Text(
                    _username.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Facial Recognition Icon/Title
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.face_retouching_natural,
                    size: 60,
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Who is this person?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryTextColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Take a photo to identify someone from your contacts",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 24),

                // Current time display
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        _currentTime,
                        style: TextStyle(color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Camera Preview / Captured Image Container
                Container(
                  height: 350,
                  width: 280,
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: _buildCameraContent(),
                  ),
                ),
                SizedBox(height: 24),

                // Identification Result
                if (_identifiedPerson != null)
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              "Successfully Identified:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          _identifiedPerson!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 24),

                // Action Buttons
                _buildActionButtons(),

                SizedBox(height: 20),

                // Footer
                Text(
                  "Memory Assistant App",
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "© 2025 ${_username}",
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build camera preview or captured photo
  Widget _buildCameraContent() {
    if (_isCapturing) {
      // Show camera animation during capture
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera, size: 40, color: Colors.white70),
              SizedBox(height: 20),
              CircularProgressIndicator(color: AppTheme.accentColor),
              SizedBox(height: 20),
              Text("Taking photo...", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      );
    } else if (_hasPhoto) {
      // Show captured photo
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            _imagePath,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              );
            },
          ),
          // Overlay during identification
          if (_isIdentifying)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppTheme.accentColor),
                    SizedBox(height: 16),
                    Text(
                      "Identifying person...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          // Face detection graphics for visual effect
          if (_identifiedPerson != null && !_isIdentifying)
            CustomPaint(painter: FaceDetectionPainter()),
        ],
      );
    } else {
      // Show camera preview placeholder
      return Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, size: 50, color: Colors.white70),
              SizedBox(height: 16),
              Text("Camera Preview", style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text(
                "Press the button below to take a photo",
                style: TextStyle(color: Colors.white60, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }

  // Build action buttons based on current state
  Widget _buildActionButtons() {
    if (_hasPhoto) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Retake button
          OutlinedButton.icon(
            onPressed: _isIdentifying ? null : _retakePhoto,
            icon: Icon(Icons.refresh),
            label: Text("Retake Photo"),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: BorderSide(color: AppTheme.primaryColor),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(width: 16),
          // Save/Done button
          ElevatedButton.icon(
            onPressed:
                _isIdentifying || _identifiedPerson == null
                    ? null
                    : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Person identification saved"),
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      );
                    },
            icon: Icon(Icons.check),
            label: Text("Confirm"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      );
    } else {
      // Take photo button
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: ElevatedButton.icon(
          onPressed: _isCapturing ? null : _takePhoto,
          icon: Icon(Icons.camera_alt),
          label: Text("Take Photo"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 3,
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}

// Custom painter for face detection graphics
class FaceDetectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppTheme.accentColor.withOpacity(0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    // Center position for face oval
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw face oval
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: size.width * 0.6,
        height: size.height * 0.8,
      ),
      paint,
    );

    // Draw points for facial landmarks
    final pointPaint =
        Paint()
          ..color = AppTheme.accentColor
          ..style = PaintingStyle.fill;

    // Draw eye markers
    canvas.drawCircle(Offset(centerX - 30, centerY - 30), 3, pointPaint);
    canvas.drawCircle(Offset(centerX + 30, centerY - 30), 3, pointPaint);

    // Draw nose marker
    canvas.drawCircle(Offset(centerX, centerY + 10), 3, pointPaint);

    // Draw mouth markers
    canvas.drawCircle(Offset(centerX - 25, centerY + 40), 3, pointPaint);
    canvas.drawCircle(Offset(centerX + 25, centerY + 40), 3, pointPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
