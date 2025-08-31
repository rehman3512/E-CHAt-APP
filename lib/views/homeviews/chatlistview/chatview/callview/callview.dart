// import 'package:chattingapp/data/services/callservice.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
//
//
// class CallScreen extends StatefulWidget {
//   final String callId;
//   final bool isCaller;
//   const CallScreen({super.key, required this.callId, required this.isCaller});
//
//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }
//
// class _CallScreenState extends State<CallScreen> {
//   final CallService _callService = CallService();
//   RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//
//   @override
//   void initState() {
//     super.initState();
//     _localRenderer.initialize();
//     _remoteRenderer.initialize();
//     _initCall();
//   }
//
//   Future<void> _initCall() async {
//     await _callService.initCall(widget.callId, widget.isCaller);
//
//     setState(() {
//       _localRenderer.srcObject = _callService.getLocalStream();
//     });
//   }
//
//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           RTCVideoView(_remoteRenderer),
//           Positioned(
//             right: 16,
//             top: 16,
//             width: 120,
//             height: 160,
//             child: RTCVideoView(_localRenderer, mirror: true),
//           ),
//           Positioned(
//             bottom: 30,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: FloatingActionButton(
//                 backgroundColor: Colors.red,
//                 child: Icon(Icons.call_end),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }



import 'package:chattingapp/data/models/messagemodel.dart';
import 'package:chattingapp/data/models/usermodel.dart';
import 'package:chattingapp/views/homeviews/chatlistview/chatview/chatinfo/chatinfo.dart';
import 'package:chattingapp/widgets/chatinput.dart';
import 'package:chattingapp/widgets/messagebubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chattingapp/controller/chatcontroller.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';


class ChatView extends StatefulWidget {
  final String chatId, peerId, peerName, peerPhone;
  const ChatView({
    super.key,
    required this.chatId,
    required this.peerId,
    required this.peerName,
    required this.peerPhone,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final RxString _peerStatus = 'online'.obs;
  final RxString _lastSeen = ''.obs;
  final ImagePicker _picker = ImagePicker();
  final ChatController _chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
    _setupPeerPresenceListener();
  }

  void _markMessagesAsRead() async {
    if (widget.peerId.isNotEmpty) {
      final unreadMessages = await _firestore
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .where('read', isEqualTo: false)
          .where('senderId', isEqualTo: widget.peerId)
          .get();

      for (var doc in unreadMessages.docs) {
        await doc.reference.update({'read': true});
      }
    }
  }

  void _setupPeerPresenceListener() {
    if (widget.peerId.isNotEmpty) {
      _firestore.collection('users').doc(widget.peerId).snapshots().listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data()!;
          final online = data['online'] ?? false;
          final lastSeen = data['lastSeen'] as Timestamp?;

          _peerStatus.value = online ? 'online' : 'offline';

          if (lastSeen != null && !online) {
            _lastSeen.value = _formatLastSeen(lastSeen.toDate());
          } else {
            _lastSeen.value = '';
          }
        }
      });
    }
  }

  String _formatLastSeen(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'last seen just now';
    if (difference.inMinutes < 60) return 'last seen ${difference.inMinutes} minutes ago';
    if (difference.inHours < 24) return 'last seen ${difference.inHours} hours ago';
    if (difference.inDays < 7) return 'last seen ${difference.inDays} days ago';

    return 'last seen ${DateFormat('dd/MM/yyyy').format(date)}';
  }

  void _makeVoiceCall() async {
    // Request microphone permission
    if (await Permission.microphone.request().isGranted) {
      Get.to(() => VoiceCallScreen(
        peerId: widget.peerId,
        peerName: widget.peerName,
        isCaller: true,
      ));
    } else {
      Get.snackbar('Permission Required', 'Microphone permission is needed for voice calls');
    }
  }

  void _makeVideoCall() async {
    // Request camera and microphone permissions
    if (await Permission.camera.request().isGranted &&
        await Permission.microphone.request().isGranted) {
      Get.to(() => VideoCallScreen(
        peerId: widget.peerId,
        peerName: widget.peerName,
        isCaller: true,
      ));
    } else {
      Get.snackbar('Permission Required', 'Camera and microphone permissions are needed for video calls');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        await _chatController.sendImage(File(image.path));
        Get.snackbar('Success', 'Image sent successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send image: $e');
    }
  }

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        await _chatController.sendDoc(file);
        Get.snackbar('Success', 'Document sent successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send document: $e');
    }
  }

  Future<void> _recordAudio() async {
    try {
      // Implement audio recording logic here
      // You'll need to use a package like audiorecorder or sound_record
      Get.snackbar('Info', 'Audio recording feature will be implemented');
    } catch (e) {
      Get.snackbar('Error', 'Failed to record audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = _currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: InkWell(
          onTap: () {
            Get.to(() => ChatInfoScreen(
              peerId: widget.peerId,
              peerName: widget.peerName,
              peerPhone: widget.peerPhone,
              peerPhoto: "",
              chatId: widget.chatId,
            ));
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: widget.peerId.isNotEmpty
                    ? const Icon(Icons.person, color: Colors.teal)
                    : const Icon(Icons.group, color: Colors.teal),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.peerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Obx(() => Text(
                      _peerStatus.value == 'online'
                          ? 'online'
                          : _lastSeen.value,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Voice call button
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: _makeVoiceCall,
          ),
          // Video call button
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: _makeVideoCall,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'info', child: Text('View Info')),
              const PopupMenuItem(value: 'mute', child: Text('Mute Notifications')),
              const PopupMenuItem(value: 'clear', child: Text('Clear Chat')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _chatController.streamMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients && messages.isNotEmpty) {
                    _scrollController.jumpTo(0.0);
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == me;

                    // Show date headers
                    final currentDate = message.createdAt.toDate();
                    final showDateHeader = index == 0 ||
                        (index > 0 &&
                            messages[index-1].createdAt.toDate().day != currentDate.day);

                    return Column(
                      children: [
                        if (showDateHeader)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              DateFormat('MMM dd, yyyy').format(currentDate),
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ),
                        MessageBubble(
                          m: message,
                          isMe: isMe,
                          showStatus: isMe && widget.peerId.isNotEmpty,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          // Modified Chat Input with voice button on the right
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                // Attachment button
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.teal),
                  onPressed: () => _showAttachmentSheet(context),
                ),
                // Text input field
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Send button (appears when text is entered)
                if (_textController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.teal),
                    onPressed: () {
                      if (_textController.text.trim().isNotEmpty) {
                        _chatController.sendText(_textController.text.trim()).then((_) {
                          _textController.clear();
                        });
                      }
                    },
                  ),
                // Voice button (appears when no text is entered)
                if (_textController.text.isEmpty)
                  IconButton(
                    icon: const Icon(Icons.mic, color: Colors.teal),
                    onPressed: _recordAudio,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.image, color: Colors.green),
                title: const Text('Gallery'),
                onTap: () {
                  Get.back();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Camera'),
                onTap: () {
                  Get.back();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.audiotrack, color: Colors.orange),
                title: const Text('Audio'),
                onTap: () {
                  Get.back();
                  _recordAudio();
                },
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.purple),
                title: const Text('Document'),
                onTap: () {
                  Get.back();
                  _pickDocument();
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.red),
                title: const Text('Location'),
                onTap: () {
                  Get.back();
                  // Implement location sharing
                  Get.snackbar('Info', 'Location sharing feature will be implemented');
                },
              ),
              ListTile(
                leading: const Icon(Icons.contact_page, color: Colors.teal),
                title: const Text('Contact'),
                onTap: () {
                  Get.back();
                  // Implement contact sharing
                  Get.snackbar('Info', 'Contact sharing feature will be implemented');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}