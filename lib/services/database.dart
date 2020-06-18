import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/shared/constants.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  getUserByUsername(String name) async {
    return Firestore.instance
        .collection('users')
        .where("name", isGreaterThanOrEqualTo: name)
        .getDocuments();
  }

  getUserByUserEmail(String email) async {
    return Firestore.instance
        .collection('users')
        .where("email", isEqualTo: email)
        .getDocuments();
  }

  //collection reference
  final CollectionReference wiggleCollection =
      Firestore.instance.collection('users');
  final cloudReference = Firestore.instance.collection('cloud');
  final feedReference = Firestore.instance.collection('feed');
  final followersReference = Firestore.instance.collection('followers');
  final followingReference = Firestore.instance.collection('followings');
  final gameReference = Firestore.instance.collection('game');
  final triviaReference = Firestore.instance.collection('trivia');
  final maleReference = Firestore.instance.collection('male');
  final femaleReference = Firestore.instance.collection('female');
  final compatibilityReference = Firestore.instance.collection('compatibility');
  final bondReference = Firestore.instance.collection('Bond');
  final susReference = Firestore.instance.collection('Sus ChatRoom');

  Future updateGame(String gameRoomID, List player1, List player2) async {
    return gameReference.document(gameRoomID).setData({
      'player1': player1,
      'player2': player2,
    });
  }

  Future updateTrivia(
      {String triviaRoomID,
      String question,
      String answer1,
      String answer2}) async {
    return triviaReference
        .document(triviaRoomID)
        .collection('questions')
        .document(question)
        .setData({
      'answer1': answer1,
      'answer2': answer2,
    });
  }

  Future createTriviaRoom(
      String triviaRoomID, String player1, String player2) async {
    return triviaReference.document(triviaRoomID).setData({
      'player1': player1,
      'player2': player2,
    });
  }

  Future uploadCompatibiltyAnswers({
    UserData userData,
    Wiggle wiggle,
    String compatibilityRoomID,
    List<String> myAnswers,
  }) async {
    return compatibilityReference
        .document(compatibilityRoomID)
        .collection('${userData.name} answers')
        .document(userData.name)
        .setData({
      '${userData.name} answers': myAnswers,
    });
  }

  Future uploadFriendCompatibiltyAnswers({
    UserData userData,
    Wiggle wiggle,
    String compatibilityRoomID,
    List<String> myAnswers,
  }) async {
    return compatibilityReference
        .document(compatibilityRoomID)
        .collection('${wiggle.name} answers')
        .document(wiggle.name)
        .setData({
      '${wiggle.name} answers': myAnswers,
    });
  }

  Future uploadCompatibiltyQuestions({
    UserData userData,
    Wiggle wiggle,
    String compatibilityRoomID,
    List<String> questions,
  }) async {
    return compatibilityReference
        .document(compatibilityRoomID)
        .collection('questions')
        .document(compatibilityRoomID)
        .setData({
      'questions': questions,
    });
  }

  Future createCompatibilityRoom(
      {String compatibilityRoomID, String player1, String player2}) async {
    return compatibilityReference.document(compatibilityRoomID).setData({
      'player1': player1,
      'player2': player2,
    });
  }

  Future acceptRequest(String ownerID, String ownerName, String userDp,
      String userID, String senderEmail) {
    return feedReference
        .document(ownerID)
        .collection('feed')
        .document(senderEmail)
        .setData({
      'type': 'request',
      'ownerID': ownerID,
      'ownerName': ownerName,
      'timestamp': DateTime.now(),
      'userDp': userDp,
      'userID': userID,
      'status': 'accepted',
      'senderEmail': senderEmail
    });
  }

  getRequestStatus(String ownerID, String ownerName, String userDp,
      String userID, String senderEmail) async {
    return feedReference
        .document(ownerID)
        .collection('feed')
        //.document(senderEmail)
        .where('senderEmail', isEqualTo: senderEmail)
        // .get();
        .where('type', isEqualTo: 'request')
        .snapshots();
  }

  Future uploadBondData(
      {UserData userData,
      bool myAnon,
      Wiggle wiggle,
      bool friendAnon,
      String chatRoomID}) async {
    return bondReference.document(chatRoomID).setData({
      "${userData.name} Email": userData.email,
      "${userData.name} Anon": myAnon,
      "${wiggle.name} Email": wiggle.email,
      "${wiggle.name} Anon": friendAnon,
    });
  }

  getBond(String chatRoomID) async {
    return Firestore.instance
        .collection('Bond')
        .document(chatRoomID)
        .snapshots();
    // .get();
  }

  Future uploadWhoData(
      {String email,
      String name,
      String nickname,
      bool isAnonymous,
      String dp,
      String gender,
      int score}) async {
    return gender == 'Male'
        ? maleReference.document(email).setData({
            "name": name,
            "email": email,
            "nickname": nickname,
            "dp": dp,
            "score": score,
            "isAnonymous": isAnonymous
          })
        : femaleReference.document(email).setData({
            "name": name,
            "email": email,
            "nickname": nickname,
            "dp": dp,
            "score": score,
            "isAnonymous": isAnonymous
          });
  }
  Future uploadPhotos(String photo)async {
      return await wiggleCollection.document(uid).collection('photos').document().setData({
       'photo':photo
      });
  }

  Stream<QuerySnapshot> getphotos(){
    return wiggleCollection.document(uid).collection('photos').snapshots();
  }



  Future uploadUserData(
      String email,
      String name,
      String nickname,
      String gender,
      String block,
      String bio,
      String dp,
      bool isAnonymous) async {
    followersReference.document(email).collection('userFollowing');
    followingReference.document(email).collection('userFollowers');
    return await wiggleCollection.document(uid).setData({
      "email": email,
      "name": name,
      "nickname": nickname,
      "gender": gender,
      "block": block,
      "bio": bio,
      "dp": dp,
      "isAnonymous": isAnonymous,
      'anonBio': '',
      'anonInterest': '',
      'anonDp': ''
    });
  }

  Future updateAnonymous(bool isAnonymous) async {
    return await wiggleCollection
        .document(uid)
        .updateData({"isAnonymous": isAnonymous});
  }

  Future updateAnonData(
      String anonBio, String anonInterest, String anonDp) async {
    return await wiggleCollection.document(uid).updateData(
        {'anonBio': anonBio, 'anonInterest': anonInterest, 'anonDp': anonDp});
  }

  Future updateUserData(
      String email,
      String name,
      String nickname,
      String gender,
      String block,
      String bio,
      String dp,
      bool isAnonymous) async {
    return await wiggleCollection.document(uid).setData({
      "email": email,
      "name": name,
      "nickname": nickname,
      "gender": gender,
      "block": block,
      "bio": bio,
      "dp": dp,
      "isAnonymous": isAnonymous,
      'anonBio': '',
      'anonInterest': '',
      'anonDp': ''
    });
  }

  //wiggle list from snapshot
  List<Wiggle> _wiggleListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Wiggle(
          id: this.uid,
          email: doc.data['email'] ?? '',
          dp: doc.data['dp'] ?? '',
          name: doc.data['name'] ?? '',
          bio: doc.data['bio'] ?? '',
          community: doc.data['community'] ?? '',
          gender: doc.data['gender'] ?? '',
          block: doc.data['block'] ?? '',
          nickname: doc.data['nickname'] ?? '',
          isAnonymous: doc.data['isAnonymous'] ?? false,
          anonBio: doc.data['anonBio'] ?? '',
          anonInterest: doc.data['anonInterest'] ?? '',
          anonDp: doc.data['anonDp'] ?? '');
    }).toList();
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        email: snapshot.data['email'],
        block: snapshot.data['block'],
        bio: snapshot.data['bio'],
        name: snapshot.data['name'],
        gender: snapshot.data['gender'],
        dp: snapshot.data['dp'],
        nickname: snapshot.data['nickname'],
        isAnonymous: snapshot.data['isAnonymous'],
        anonBio: snapshot.data['anonBio'] ?? '',
        anonInterest: snapshot.data['anonInterest'] ?? '',
        anonDp: snapshot.data['anonDp'] ?? '');
  }

  //get wiggle stream
  Stream<List<Wiggle>> get wiggles {
    return wiggleCollection.snapshots().map(_wiggleListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return wiggleCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  createChatRoom(String chatRoomID, dynamic chatRoomMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomID)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  createAnonymousChatRoom(String chatRoomID, dynamic chatRoomMap) {
    Firestore.instance
        .collection("Anonymous ChatRoom")
        .document(chatRoomID)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  createSusChatRoom(String chatRoomID, dynamic chatRoomMap) {
    Firestore.instance
        .collection("Sus ChatRoom")
        .document(chatRoomID)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) async {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .document(messageMap['time'].toString())
        .setData(messageMap)
        // .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addSusConversationMessages(String chatRoomId, messageMap) async {
    Firestore.instance
        .collection("Sus ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .document(messageMap['time'].toString())
        .setData(messageMap)
        // .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addAnonymousConversationMessages(String chatRoomId, messageMap) async {
    Firestore.instance
        .collection("Anonymous ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .document(messageMap['time'].toString())
        .setData(messageMap)
        // .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getSusConversationMessages(String chatRoomId) async {
    return Firestore.instance
        .collection("Sus ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getAnonymousConversationMessages(String chatRoomId) async {
    return Firestore.instance
        .collection("Anonymous ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getPosts() async {
    return Firestore.instance
        .collection("posts")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  getMyCompatibilityResults(wiggle, userData, compatibilityRoomID) async {
    return await Firestore.instance
        .collection("compatibility")
        .document(compatibilityRoomID)
        .collection("${userData.name} answers")
        .snapshots();
  }

  getFriendCompatibilityResults(wiggle, userData, compatibilityRoomID) async {
    return await Firestore.instance
        .collection("compatibility")
        .document(compatibilityRoomID)
        .collection("${wiggle.name} answers")
        .snapshots();
  }

  getCompatibilityQuestions(wiggle, userData, compatibilityRoomID) async {
    return await Firestore.instance
        .collection("compatibility")
        .document(compatibilityRoomID)
        .collection("questions")
        .snapshots();
  }

  getDocCompatibilityQuestions(wiggle, userData, compatibilityRoomID) async {
    return await Firestore.instance
        .collection("compatibility")
        .document(compatibilityRoomID)
        .collection("questions")
        .getDocuments();
  }

  getDocMyCompatibilityAnswers(wiggle, userData, compatibilityRoomID) async {
    return await Firestore.instance
        .collection("compatibility")
        .document(compatibilityRoomID)
        .collection("${userData.name} answers")
        .getDocuments();
  }

  getDocFriendCompatibilityAnswers(
      wiggle, userData, compatibilityRoomID) async {
    return await Firestore.instance
        .collection("compatibility")
        .document(compatibilityRoomID)
        .collection("${wiggle.name} answers")
        .getDocuments();
  }

  getWho(String gender) async {
    return gender == "Female"
        ? Firestore.instance
            .collection('male')
            .orderBy("score", descending: true)
            .getDocuments()
        : Firestore.instance
            .collection('female')
            .orderBy("score", descending: true)
            .getDocuments();
  }

  getReceivertoken(String email) async {
    return Firestore.instance
        .collection('users')
        .document(email)
        .collection('tokens')
        .getDocuments();
  }

  getChatRooms(String userName) async {
    return Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  getAnonymousChatRooms(String userName) async {
    return Firestore.instance
        .collection("Anonymous ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  getSusChatRooms(String userName) async {
    return Firestore.instance
        .collection("Sus ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
