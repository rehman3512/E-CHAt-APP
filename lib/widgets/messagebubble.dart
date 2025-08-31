//
// import 'package:chattingapp/data/models/messagemodel.dart';
// import 'package:flutter/material.dart';
//
//
//
// class MessageBubble extends StatelessWidget {
//   final MessageModel m;
//   final bool isMe;
//   const MessageBubble({super.key, required this.m, required this.isMe});
//
//   @override
//   Widget build(BuildContext context) {
//     final bg = isMe ? const Color(0xFF2563EB) : Colors.white;
//     final fg = isMe ? Colors.white : const Color(0xFF111827);
//     final radius = BorderRadius.only(
//       topLeft: const Radius.circular(12),
//       topRight: const Radius.circular(12),
//       bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(4),
//       bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(12),
//     );
//
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         decoration: BoxDecoration(color: bg, borderRadius: radius, boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           )
//         ]),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//           if ((m.imageUrl ?? '').isNotEmpty)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.network(m.imageUrl!, width: 220, fit: BoxFit.cover),
//             ),
//           if (m.text.isNotEmpty)
//             Text(m.text, style: TextStyle(color: fg, fontSize: 14, height: 1.25)),
//           const SizedBox(height: 4),
//           Text(
//             _hhmm(m.createdAt.toDate()),
//             style: TextStyle(color: fg.withOpacity(0.8), fontSize: 10),
//           ),
//         ]),
//       ),
//     );
//   }
//
//   String _hhmm(DateTime d) =>
//       '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
// }



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chattingapp/data/models/messagemodel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel m;
  final bool isMe;
  final bool showStatus;

  const MessageBubble({
    super.key,
    required this.m,
    required this.isMe,
    this.showStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) const SizedBox(width: 8),

          // Message Content
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: _getMessagePadding(),
              decoration: BoxDecoration(
                color: _getMessageColor(),
                borderRadius: _getBorderRadius(),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Message
                  if (m.type == 'image' && m.imageUrl != null && m.imageUrl!.isNotEmpty)
                    _buildImageMessage(),

                  // Document Message
                  if (m.type == 'file' && m.docUrl != null && m.docUrl!.isNotEmpty)
                    _buildDocumentMessage(),

                  // Audio Message
                  if (m.type == 'audio' && m.audioUrl != null && m.audioUrl!.isNotEmpty)
                    _buildAudioMessage(),

                  // Video Message
                  if (m.type == 'video' && m.videoUrl != null && m.videoUrl!.isNotEmpty)
                    _buildVideoMessage(),

                  // Text Message (show only if not empty)
                  if (m.text.isNotEmpty && m.type == 'text')
                    Text(
                      m.text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),

                  if (m.text.isNotEmpty && m.type != 'text')
                    const SizedBox(height: 4),

                  // Message Time and Status
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(m.createdAt.toDate()),
                        style: TextStyle(
                          fontSize: 11,
                          color: isMe ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      if (isMe && showStatus) ...[
                        const SizedBox(width: 4),
                        Icon(
                          m.status == 'read'
                              ? Icons.done_all
                              : Icons.done,
                          size: 14,
                          color: m.status == 'read' ? Colors.blue : Colors.white70,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildImageMessage() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: m.imageUrl!,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
              height: 200,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              height: 200,
              child: const Icon(Icons.error),
            ),
          ),
        ),
        if (m.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            m.text,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDocumentMessage() {
    return Row(
      children: [
        const Icon(Icons.insert_drive_file, size: 40, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Document',
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (m.text.isNotEmpty)
                Text(
                  m.text,
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.black54,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioMessage() {
    return Row(
      children: [
        Icon(Icons.audiotrack, size: 24, color: isMe ? Colors.white : Colors.black),
        const SizedBox(width: 8),
        Text(
          'Audio message',
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoMessage() {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.black45,
                width: double.infinity,
                height: 150,
                child: const Icon(Icons.play_arrow, size: 50, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'VIDEO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (m.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            m.text,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ],
    );
  }

  EdgeInsets _getMessagePadding() {
    switch (m.type) {
      case 'image':
      case 'video':
        return const EdgeInsets.all(8);
      case 'file':
        return const EdgeInsets.all(12);
      case 'audio':
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      default:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    }
  }

  Color _getMessageColor() {
    switch (m.type) {
      case 'image':
      case 'video':
      case 'file':
      case 'audio':
        return isMe ? Colors.teal.shade700 : Colors.grey.shade200;
      default:
        return isMe ? Colors.teal.shade600 : Colors.white;
    }
  }

  BorderRadius _getBorderRadius() {
    if (isMe) {
      return const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      );
    } else {
      return const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      );
    }
  }
}