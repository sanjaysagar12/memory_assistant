import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MemoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final String timestamp;
  final VoidCallback? onTap;

  const MemoryCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.timestamp,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with title overlay
            Stack(
              children: [
                // Memory image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image, color: Colors.grey[500]),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Title overlay with gradient
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Memory description
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
            ),
            // Timestamp and view more button
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Timestamp
                  Text(
                    timestamp,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  // View details icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}