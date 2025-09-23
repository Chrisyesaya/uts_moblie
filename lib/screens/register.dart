import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset('assets/background_video.mp4');
      
      await _videoController.initialize();
      
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
          _hasError = false;
        });
      }
      
      // Mematikan suara video
      _videoController.setVolume(0.0);
      _videoController.play();
      _videoController.setLooping(true);
      
    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _isVideoInitialized = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Widget _buildVideoBackground() {
    if (_hasError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text(
                'Video tidak dapat dimuat',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isVideoInitialized) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.yellow),
              SizedBox(height: 10),
              Text(
                'Memuat video...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController.value.size.width,
              height: _videoController.value.size.height,
              child: VideoPlayer(_videoController),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildVideoBackground(),

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Card(
                  color: Theme.of(context).cardColor.withOpacity(0.95),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 50,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'BUAT AKUN BARU',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 25),
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Konfirmasi Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              _handleRegistration(context);
                            },
                            child: Text(
                              'DAFTAR',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: RichText(
                            text: TextSpan(
                              text: 'Sudah punya akun? ',
                              style: TextStyle(color: Colors.grey[700]),
                              children: [
                                TextSpan(
                                  text: 'Login disini',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleRegistration(BuildContext context) {
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap isi semua field'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password tidak cocok'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password minimal 6 karakter'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Provider.of<AuthProvider>(context, listen: false)
        .login(_usernameController.text);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pendaftaran berhasil!'),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.pushReplacementNamed(context, '/login');
  }
}