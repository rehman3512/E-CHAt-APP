import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

class GroupCallScreen extends StatefulWidget {
  final String groupId;
  final String userId;

  const GroupCallScreen({super.key, required this.groupId, required this.userId});

  @override
  State<GroupCallScreen> createState() => _GroupCallScreenState();
}

class _GroupCallScreenState extends State<GroupCallScreen> {
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  bool muted = false;
  bool videoOff = false;

  @override
  void initState() {
    super.initState();
    _initRenderers();
    // yaha GroupCallService joinGroupCall() call karna hoga
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    for (var r in _remoteRenderers.values) {
      r.dispose();
    }
    super.dispose();
  }

  Widget _buildVideoTile(RTCVideoRenderer renderer, String name) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white24)),
      child: RTCVideoView(
        renderer,
        mirror: true,
        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final participants = [_localRenderer, ..._remoteRenderers.values];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Group Call"),
        actions: [
          IconButton(
            icon: Icon(Icons.call_end, color: Colors.red),
            onPressed: () => Get.back(),
          )
        ],
      ),
      body: GridView.builder(
        itemCount: participants.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: participants.length <= 2 ? 1 : 2,
        ),
        itemBuilder: (context, index) {
          return _buildVideoTile(participants[index], "User $index");
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(muted ? Icons.mic_off : Icons.mic, color: Colors.white),
              onPressed: () {
                setState(() => muted = !muted);
              },
            ),
            IconButton(
              icon: Icon(videoOff ? Icons.videocam_off : Icons.videocam,
                  color: Colors.white),
              onPressed: () {
                setState(() => videoOff = !videoOff);
              },
            ),
            IconButton(
              icon: Icon(Icons.switch_camera, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
