import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool _isLoading = true;
  bool _hasPermission = false;
  bool _locationEnabled = false;
  bool _isSendingData = false;
  String _errorMessage = '';
  String _statusMessage = '';

  // Location data
  Position? _currentPosition;
  
  // Google Maps controller
  final Completer<GoogleMapController> _controller = Completer();
  
  // Markers for the map
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _checkPermissionAndGetLocation();
  }

  // Check location permissions and get user's location
  Future<void> _checkPermissionAndGetLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _statusMessage = '';
    });
    
    try {
      // Check location service enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _locationEnabled = false;
          _errorMessage = 'Location services are disabled. Please enable location in settings.';
        });
        return;
      }
      
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _hasPermission = false;
            _errorMessage = 'Location permission denied. Some features may not be available.';
          });
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _hasPermission = false;
          _errorMessage = 'Location permissions are permanently denied. Please enable location in app settings.';
        });
        return;
      }
      
      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _isLoading = false;
        _hasPermission = true;
        _locationEnabled = true;
        
        // Add marker for current location
        if (_currentPosition != null) {
          _markers.add(
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(
                _currentPosition!.latitude, 
                _currentPosition!.longitude
              ),
              infoWindow: const InfoWindow(title: 'Your Location'),
            ),
          );
        }
      });

      // Send location data to backend
      if (_currentPosition != null) {
        _sendLocationUpdate();
      }
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error getting location: ${e.toString()}';
      });
    }
  }
  
  // Send location update to the backend
  Future<void> _sendLocationUpdate() async {
    if (_currentPosition == null) return;
    
    setState(() {
      _isSendingData = true;
      _statusMessage = 'Updating location...';
    });
    
    try {
      // Get token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      
      if (token == null) {
        setState(() {
          _isSendingData = false;
          _statusMessage = 'Authentication required. Please login again.';
        });
        return;
      }
      
      // Prepare location data
      final locationData = {
        "latitude": _currentPosition!.latitude,
        "longitude": _currentPosition!.longitude,
        "accuracy": _currentPosition!.accuracy,
      };
      
      // Send data to backend
      final response = await http.post(
        Uri.parse('https://api.selfmade.plus/locations/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(locationData),
      );
      
      setState(() {
        _isSendingData = false;
      });
      
      // Handle response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          _statusMessage = 'Location updated successfully';
          
          // Clear status message after 3 seconds
          Timer(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _statusMessage = '';
              });
            }
          });
        });
      } else {
        // Try to parse error message
        Map<String, dynamic> responseData = {};
        try {
          responseData = jsonDecode(response.body);
        } catch (e) {
          // Non-JSON response
        }
        
        setState(() {
          _statusMessage = responseData['message'] ?? 
              'Failed to update location (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _isSendingData = false;
        _statusMessage = 'Network error: ${e.toString()}';
      });
    }
  }
  
  // Build the Google Map widget
  Widget _buildMap() {
    if (_currentPosition == null) {
      return const Center(
        child: Text('Location data not available'),
      );
    }
    
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 15,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      compassEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Coordinates display
              if (_currentPosition != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Current Location',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCoordinateCard(
                              'Latitude',
                              _currentPosition!.latitude.toStringAsFixed(6),
                              Icons.north,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildCoordinateCard(
                              'Longitude',
                              _currentPosition!.longitude.toStringAsFixed(6),
                              Icons.east,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              
              // Map or loading state
              Expanded(
                child: _isLoading 
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _errorMessage.isNotEmpty
                    ? _buildErrorView()
                    : _buildMap(),
              ),
            ],
          ),
          
          // Status message overlay
          if (_statusMessage.isNotEmpty)
            Positioned(
              top: _currentPosition != null ? 130 : 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _statusMessage.contains('successfully') 
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isSendingData)
                        Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(right: 8),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      Icon(
                        _statusMessage.contains('successfully')
                            ? Icons.check_circle
                            : Icons.info_outline,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _statusMessage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      // Refresh location button
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Update location button
          FloatingActionButton(
            backgroundColor: AppTheme.primaryColor,
            onPressed: _checkPermissionAndGetLocation,
            heroTag: 'refresh_location',
            child: const Icon(Icons.my_location),
            tooltip: 'Get Current Location',
          ),
          const SizedBox(height: 16),
          // Send update button
          if (_currentPosition != null && !_isSendingData)
            FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: _sendLocationUpdate,
              heroTag: 'send_location',
              child: const Icon(Icons.cloud_upload),
              tooltip: 'Send Location Update',
            ),
        ],
      ),
    );
  }
  
  // Build coordinate display card
  Widget _buildCoordinateCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Build error view
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_disabled,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _checkPermissionAndGetLocation,
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}