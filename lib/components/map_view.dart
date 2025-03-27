import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  String _errorMessage = '';

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
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error getting location: ${e.toString()}';
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
      body: Column(
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
      // Refresh location button
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: _checkPermissionAndGetLocation,
        child: const Icon(Icons.my_location),
        tooltip: 'Get Current Location',
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