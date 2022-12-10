//Package Imports
import 'package:flutter/foundation.dart';

//Project Imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:gtribe/model/rtc_stats.dart';

class PeerTrackNode extends ChangeNotifier {
  HMSPeer peer;
  String uid;
  HMSVideoTrack? track;
  HMSAudioTrack? audioTrack;
  bool isOffscreen;
  int? networkQuality;
  RTCStats? stats;
  int audioLevel;

  PeerTrackNode(
      {required this.peer,
      this.track,
      this.audioTrack,
      required this.uid,
      this.isOffscreen = true,
      this.networkQuality = -1,
      this.stats,
      this.audioLevel = -1});

  @override
  String toString() {
    return 'PeerTrackNode{peerId: ${peer.peerId}, name: ${peer.name}, track: $track}, isVideoOn: $isOffscreen }';
  }

  @override
  int get hashCode => peer.peerId.hashCode;

  void notify() {
    notifyListeners();
  }

  void setOffScreenStatus(bool currentState) {
    isOffscreen = currentState;
    notify();
  }

  void setAudioLevel(int audioLevel) {
    this.audioLevel = audioLevel;
    if (!isOffscreen) {
      notify();
    }
  }

  void setNetworkQuality(int? networkQuality) {
    if (networkQuality != null) {
      this.networkQuality = networkQuality;
      if (!isOffscreen) {
        notify();
      }
    }
  }
}
