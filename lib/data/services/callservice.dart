// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class CallService {
//   final _db = FirebaseFirestore.instance;
//
//   Future<void> startVoiceCall(String chatId, String callerId, String calleeId) async {
//     await _db.collection('calls').doc(chatId).set({
//       'type': 'voice',
//       'callerId': callerId,
//       'calleeId': calleeId,
//       'startedAt': FieldValue.serverTimestamp(),
//       'active': true,
//     }, SetOptions(merge: true));
//   }
//
//   Future<void> startVideoCall(String chatId, String callerId, String calleeId) async {
//     await _db.collection('calls').doc(chatId).set({
//       'type': 'video',
//       'callerId': callerId,
//       'calleeId': calleeId,
//       'startedAt': FieldValue.serverTimestamp(),
//       'active': true,
//     }, SetOptions(merge: true));
//   }
//
//   Stream<DocumentSnapshot<Map<String, dynamic>>> callStream(String chatId) {
//     return _db.collection('calls').doc(chatId).snapshots();
//   }
//
//   Future<void> endCall(String chatId) async {
//     await _db.collection('calls').doc(chatId).update({'active': false});
//   }
// }


import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// --------------------------
  /// 🔹 FIRESTORE Metadata Calls
  /// --------------------------

  Future<void> startVoiceCall(String chatId, String callerId, String calleeId) async {
    await _firestore.collection('calls').doc(chatId).set({
      'type': 'voice',
      'callerId': callerId,
      'calleeId': calleeId,
      'startedAt': FieldValue.serverTimestamp(),
      'active': true,
    }, SetOptions(merge: true));
  }

  Future<void> startVideoCall(String chatId, String callerId, String calleeId) async {
    await _firestore.collection('calls').doc(chatId).set({
      'type': 'video',
      'callerId': callerId,
      'calleeId': calleeId,
      'startedAt': FieldValue.serverTimestamp(),
      'active': true,
    }, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> callStream(String chatId) {
    return _firestore.collection('calls').doc(chatId).snapshots();
  }

  Future<void> endCall(String chatId) async {
    await _firestore.collection('calls').doc(chatId).update({'active': false});
  }

  /// --------------------------
  /// 🔹 WebRTC Functions
  /// --------------------------

  Future<void> initCall(String callId, bool isCaller) async {
    // local stream capture
    final mediaConstraints = {
      'audio': true,
      'video': true,
    };
    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);

    // peer connection
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    });

    // add local tracks
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    // listen remote stream
    _peerConnection!.onTrack = (event) {
      print("Remote stream mil gaya");
    };

    // save ICE candidates to Firestore
    _peerConnection!.onIceCandidate = (candidate) {
      _firestore.collection("calls/$callId/candidates").add(candidate.toMap());
    };

    if (isCaller) {
      // Create Offer
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      _firestore.doc("calls/$callId").set({
        'offer': offer.toMap(),
      });
    } else {
      // Listen for offer
      _firestore.doc("calls/$callId").snapshots().listen((snapshot) async {
        if (snapshot.data()?['offer'] != null) {
          var offer = snapshot.data()!['offer'];
          await _peerConnection!.setRemoteDescription(
              RTCSessionDescription(offer['sdp'], offer['type']));

          // create answer
          var answer = await _peerConnection!.createAnswer();
          await _peerConnection!.setLocalDescription(answer);
          _firestore.doc("calls/$callId").update({'answer': answer.toMap()});
        }
      });
    }

    // listen for answer
    _firestore.doc("calls/$callId").snapshots().listen((snapshot) async {
      if (await _peerConnection!.getRemoteDescription() == null) // ✅ new way
          {
        var answer = snapshot.data()!['answer'];
        await _peerConnection!.setRemoteDescription(
            RTCSessionDescription(answer['sdp'], answer['type']));
      }
    });

    // listen for ICE candidates
    _firestore.collection("calls/$callId/candidates").snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        var cand = doc.data();
        _peerConnection!.addCandidate(RTCIceCandidate(
          cand['candidate'],
          cand['sdpMid'],
          cand['sdpMLineIndex'],
        ));
      }
    });
  }

  MediaStream? getLocalStream() => _localStream;
}
