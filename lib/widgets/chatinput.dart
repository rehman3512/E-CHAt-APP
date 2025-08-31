// import 'package:flutter/material.dart';
// import '../../constants/appcolors/appcolors.dart';
//
// class ChatInput extends StatelessWidget {
//   final TextEditingController c;
//   final VoidCallback onSend;
//   final VoidCallback onAttach;
//   const ChatInput({super.key, required this.c, required this.onSend, required this.onAttach});
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
//         color: AppColors.surface,
//         child: Row(children: [
//           IconButton(onPressed: onAttach, icon: const Icon(Icons.add), splashRadius: 22),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(24),
//                 border: Border.all(color: const Color(0xFFE5E7EB)),
//               ),
//               child: TextField(
//                 controller: c,
//                 minLines: 1,
//                 maxLines: 5,
//                 decoration: const InputDecoration(
//                     hintText: "Type a message ...", border: InputBorder.none),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: onSend,
//             child: const CircleAvatar(
//               radius: 22,
//               backgroundColor: Color(0xFF2563EB),
//               child: Icon(Icons.send, color: Colors.white, size: 18),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }
//
// void showAttachSheet(BuildContext context,
//     {required VoidCallback onCamera,
//       required VoidCallback onGallery,
//       required VoidCallback onLocation,
//       required VoidCallback onDocument,
//       required VoidCallback onContact,
//       required VoidCallback onRecord}) {
//   showModalBottomSheet(
//     context: context,
//     shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
//     builder: (_) => Padding(
//       padding: const EdgeInsets.all(16),
//       child: Wrap(spacing: 18, runSpacing: 18, children: [
//         _item(Icons.camera_alt, "Camera", onCamera),
//         _item(Icons.photo, "Gallery", onGallery),
//         _item(Icons.mic, "Record", onRecord),
//         _item(Icons.location_on, "My Location", onLocation),
//         _item(Icons.insert_drive_file, "Document", onDocument),
//         _item(Icons.person, "Contact", onContact),
//       ]),
//     ),
//   );
// }
//
// Widget _item(IconData i, String t, VoidCallback onTap) => GestureDetector(
//   onTap: onTap,
//   child: Column(mainAxisSize: MainAxisSize.min, children: [
//     const CircleAvatar(radius: 26, child: Icon(Icons.arrow_upward, color: Colors.transparent)),
//     CircleAvatar(radius: 26, child: Icon(i)),
//     const SizedBox(height: 6),
//     Text(t, style: const TextStyle(fontSize: 12)),
//   ]),
// );


import 'package:chattingapp/constants/appcolors/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ChatInput extends StatefulWidget {
  final TextEditingController c;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final ValueChanged<String>? onTextChanged;
  final bool isRecording;

  const ChatInput({
    super.key,
    required this.c,
    required this.onSend,
    required this.onAttach,
    this.onTextChanged,
    this.isRecording = false,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool _isRecording = false;
  bool _showSendButton = false;

  @override
  void initState() {
    super.initState();
    widget.c.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    widget.c.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    setState(() {
      _showSendButton = widget.c.text.trim().isNotEmpty;
    });
    if (widget.onTextChanged != null) {
      widget.onTextChanged!(widget.c.text);
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    // Start recording logic here
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    // Stop recording logic here
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Attachment Button
            IconButton(
              onPressed: widget.onAttach,
              icon: Icon(Icons.attach_file, color: Colors.grey[600]),
              splashRadius: 22,
            ),

            // Camera Button
            IconButton(
              onPressed: () {
                // Camera functionality
                _showAttachmentOptions(context);
              },
              icon: Icon(Icons.camera_alt, color: Colors.grey[600]),
              splashRadius: 22,
            ),

            // Text Input Field
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    // Emoji Button
                    IconButton(
                      onPressed: () {
                        // Emoji picker functionality
                        _showEmojiPicker(context);
                      },
                      icon: Icon(Icons.emoji_emotions_outlined,
                          color: Colors.grey[600], size: 22),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    const SizedBox(width: 4),

                    // Text Field
                    Expanded(
                      child: TextField(
                        controller: widget.c,
                        minLines: 1,
                        maxLines: 5,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 4),
                        ),
                        onChanged: (value) {
                          _handleTextChange();
                        },
                      ),
                    ),

                    const SizedBox(width: 4),

                    // Voice Message Button
                    GestureDetector(
                      onLongPress: _startRecording,
                      onLongPressEnd: (details) => _stopRecording(),
                      child: Icon(
                        Icons.mic,
                        color: _isRecording ? Colors.red : Colors.grey[600],
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Send Button or Record Button
            if (_showSendButton && !_isRecording)
              GestureDetector(
                onTap: widget.onSend,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor, // Use your app's primary color
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 18),
                ),
              )
            else if (_isRecording)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.stop, color: Colors.white, size: 18),
              )
            else
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.send, color: Colors.grey[600], size: 18),
              ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Camera Option
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.camera_alt, color: Colors.white),
                ),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement camera functionality
                },
              ),

              // Gallery Option
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.photo_library, color: Colors.white),
                ),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement gallery functionality
                },
              ),

              // Document Option
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.insert_drive_file, color: Colors.white),
                ),
                title: const Text('Document'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement document picker
                },
              ),

              // Contact Option
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.contact_page, color: Colors.white),
                ),
                title: const Text('Contact'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement contact sharing
                },
              ),

              // Location Option
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.location_on, color: Colors.white),
                ),
                title: const Text('Location'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement location sharing
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmojiPicker(BuildContext context) {
    // Emoji picker implementation
    // You can use packages like emoji_picker or create your own
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 250,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Emoji Picker', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // Placeholder for emoji grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemCount: 40,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    widget.c.text = '${widget.c.text}😊';
                    Navigator.pop(context);
                  },
                  child: const Text('😊', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Updated Attachment Sheet Function
void showAttachSheet(BuildContext context,
    {required VoidCallback onCamera,
      required VoidCallback onGallery,
      required VoidCallback onLocation,
      required VoidCallback onDocument,
      required VoidCallback onContact,
      required VoidCallback onRecord}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share using',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildAttachmentItem(Icons.camera_alt, "Camera", onCamera, Colors.teal),
                _buildAttachmentItem(Icons.photo, "Gallery", onGallery, Colors.blue),
                _buildAttachmentItem(Icons.mic, "Audio", onRecord, Colors.orange),
                _buildAttachmentItem(Icons.location_on, "Location", onLocation, Colors.red),
                _buildAttachmentItem(Icons.insert_drive_file, "Document", onDocument, Colors.purple),
                _buildAttachmentItem(Icons.person, "Contact", onContact, Colors.green),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

Widget _buildAttachmentItem(IconData icon, String title, VoidCallback onTap, Color color) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(0.2),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}