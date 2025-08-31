import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class GroupCallService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  /// Join a group call
  Future<void> joinGroupCall(String groupId, String userId) async {
    // 1️⃣ Capture local audio/video stream
    final mediaConstraints = {'audio': true, 'video': true};
    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);

    // 2️⃣ Create PeerConnection
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    });

    // 3️⃣ Add local tracks
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    // 4️⃣ Listen for remote streams
    _peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        if (kDebugMode) {
          print("Group me ek nayi remote stream aayi");
        }
      }
    };

    // 5️⃣ Push ICE candidates to Firestore
    _peerConnection!.onIceCandidate = (candidate) {
      _firestore
          .collection("groupCalls/$groupId/participants/$userId/candidates")
          .add(candidate.toMap());
    };

    // 6️⃣ Create Offer and set local description
    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    await _firestore.doc("groupCalls/$groupId/participants/$userId").set({
      'offer': offer.toMap(),
      'joinedAt': FieldValue.serverTimestamp(),
    });

    // 7️⃣ Listen for answers from other participants
    _firestore.collection("groupCalls/$groupId/participants").snapshots().listen(
          (snap) async {
        for (var doc in snap.docs) {
          if (doc.id != userId && doc.data()['answer'] != null) {
            var answer = doc.data()['answer'];
            RTCSessionDescription answerDesc =
            RTCSessionDescription(answer['sdp'], answer['type']);
            await _peerConnection!.setRemoteDescription(answerDesc);
          }
        }
      },
    );
  }

  /// Get your local stream (camera/mic)
  MediaStream? getLocalStream() => _localStream;
}
