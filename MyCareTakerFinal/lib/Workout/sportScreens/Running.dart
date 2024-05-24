import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Running extends StatefulWidget {
  const Running({super.key});

  @override
  State<Running> createState() => _RunningState();
}

class _RunningState extends State<Running> {
  final videoURL = "https://www.youtube.com/watch?v=sScNDZu2MWk";

  late YoutubePlayerController _controller;
  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(videoURL);
    _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Running",
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              height: 200,
              margin: const EdgeInsets.all(5),
              child: ClipRRect(
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
                          playedColor: Colors.blue,
                          handleColor: Colors.blueGrey),
                    ),
                    const PlaybackSpeedButton(),
                    FullScreenButton()
                  ],
                ),
              ),
            ),
            _buildSectionTitle('Tips for Beginners'),
            _buildTipItem(
              'Start Slow',
              'If you\'re new to running, begin with a mix of walking and jogging to build endurance.',
            ),
            _buildTipItem(
              'Proper Footwear',
              'Invest in good running shoes that provide support and cushioning to prevent injuries.',
            ),
            _buildTipItem(
              'Hydration',
              'Drink water before, during, and after your run to stay hydrated.',
            ),
            _buildTipItem(
              'Listen to Your Body',
              'Pay attention to any signs of discomfort or pain and adjust your pace or distance accordingly.',
            ),
            _buildTipItem(
              'Warm-up and Cool Down',
              'Always start with a gentle warm-up like brisk walking or dynamic stretches, and finish with a cooldown to help your body recover.',
            ),
            const SizedBox(height: 20.0),
            _buildSectionTitle('Warm-Up Exercises'),
            _buildExerciseItem('Jog in Place', "assets/running/jog.png"),
            const SizedBox(
              height: 5,
            ),
            _buildExerciseItem('Leg Swings', "assets/running/leg_swing.png"),
            const SizedBox(
              height: 5,
            ),
            _buildExerciseItem('Arm Circles', "assets/running/arm_circles.png"),
            const SizedBox(
              height: 5,
            ),
            _buildExerciseItem('High Knees', "assets/running/high_knees.jpg"),
            const SizedBox(
              height: 5,
            ),
            _buildExerciseItem('Butt Kicks', "assets/running/Butt_Kicks.png"),
            const SizedBox(height: 20.0),
            _buildSectionTitle('Running Drills'),
            _buildDrillItem('Strides', "assets/running/str.png"),
            const SizedBox(
              height: 5,
            ),
            _buildDrillItem('Hill Repeats', "assets/running/mountain.png"),
            const SizedBox(
              height: 5,
            ),
            _buildDrillItem('Interval Training', "assets/running/clock.png"),
            const SizedBox(height: 20.0),
            _buildSectionTitle('Cool Down'),
            _buildExerciseItem('Slow Jog/Walk', "assets/running/jog.png"),
            const SizedBox(
              height: 5,
            ),
            _buildExerciseItem('Stretching', "assets/running/stretching.png"),
            const SizedBox(height: 20.0),
            _buildSectionTitle('Safety Tips'),
            _buildTipItem(
              'Be Visible',
              'If running in low-light conditions, wear reflective gear and/or carry a flashlight to make yourself visible to drivers.',
            ),
            _buildTipItem(
              'Stay Alert',
              'Pay attention to your surroundings and avoid distractions like wearing headphones at high volume.',
            ),
            _buildTipItem(
              'Run Against Traffic',
              'If running on roads without sidewalks, run facing oncoming traffic to see and react to vehicles.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Color.fromARGB(255, 34, 89, 241),
            ),
            const SizedBox(width: 10.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 10.0),
      ],
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

  Widget _buildExerciseItem(String title, String imagePath) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        height: 60,
        width: 60,
      ),
      title: Text(title),
    );
  }

  Widget _buildDrillItem(String title, String imagePath) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        height: 60,
        width: 60,
      ),
      title: Text(title),
    );
  }
}
