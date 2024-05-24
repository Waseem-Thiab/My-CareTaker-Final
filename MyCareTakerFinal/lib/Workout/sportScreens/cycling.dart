import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class cycling extends StatefulWidget {
  const cycling({super.key});

  @override
  State<cycling> createState() => _cyclingState();
}

class _cyclingState extends State<cycling> {
  final videoURL = "https://www.youtube.com/watch?v=4ssLDk1eX9w";

  late YoutubePlayerController _controller;
  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(videoURL);
    _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cycling',
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () => debugPrint('Ready'),
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(
                    isExpanded: true,
                    colors: const ProgressBarColors(
                        playedColor: Colors.blue, handleColor: Colors.blueGrey),
                  ),
                  const PlaybackSpeedButton(),
                  FullScreenButton()
                ],
              ),
            ),
            _buildSectionTitle('Required Tools'),
            _buildToolItem(
              'Helmet',
              'A well-fitted helmet is essential for safety during cycling.',
              'assets/cycling/helmet.png',
            ),
            _buildToolItem(
                'Bike Pump',
                'Keep your tires properly inflated for better performance and to prevent flats.',
                'assets/cycling/air.png'),
            _buildToolItem(
                'Multi-tool',
                'Carry a multi-tool for on-the-go adjustments and minor repairs during rides.',
                'assets/cycling/tool.png'),
            const SizedBox(height: 10),
            const Text(
              'Cycling Tips',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            _buildSectionTitle('Warm-up Routines'),
            _buildListTile(
              'Dynamic Stretching',
              'Engage in dynamic stretches to loosen up muscles and increase flexibility before cycling.',
            ),
            _buildListTile(
              'Light Cardio',
              'Start with light pedaling or a short easy ride to warm up muscles and increase heart rate gradually.',
            ),
            _buildListTile(
              'Warm-up Sets',
              'Do a few short sets at a moderate intensity to prepare muscles for more intense cycling.',
            ),
            const SizedBox(height: 20.0),
            _buildSectionTitle('Beginners Cycling Tips'),
            _buildListTile(
              'Proper Bike Fit',
              'Ensure your bike is properly adjusted to your body measurements to prevent injuries and improve performance.',
            ),
            _buildListTile(
              'Hydration',
              'Stay hydrated before, during, and after cycling to maintain performance and prevent dehydration.',
            ),
            _buildListTile(
              'Safety Gear',
              'Always wear a helmet and appropriate safety gear to protect yourself in case of accidents.',
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle) {
    return ListTile(
      title: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color.fromARGB(255, 34, 89, 241),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildToolItem(String toolName, String subtitle, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toolName,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
