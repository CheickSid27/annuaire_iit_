import 'dart:async';
import 'dart:io';
import 'package:Udirectory/main.dart';
import 'package:Udirectory/model/login_response.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ParseHandler {
  //Logique de l'auth

  //Si on est auth
  Future<ParseUser?> isAuth() async {
    //Exists?
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    //Vérifier si null
    if (currentUser == null) return null;
    //Attendre une réponse
    final ParseResponse? userResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);
    if (userResponse == null && !userResponse!.success) {
      await currentUser.logout();
      return null;
    }
    return currentUser;
  }

  //Création
  Future<LoginResponse> createUser(
      {required String username,
      required String emailAddress,
      required String password,
      required String? role,
      required String? filiere,
      required String? module,
      required String? poste,
      required String? annee,
      required String? numero}) async {
    ParseUser user = ParseUser(username, password, emailAddress);
    user.set('role', role);
    user.set('filiere', filiere);
    user.set('module', module);
    user.set('poste', poste);
    user.set('annee', annee);
    user.set('numero', numero);
    ParseResponse response = await user.signUp();
    return responseLog(response);
  }

  //Connexion
  Future<LoginResponse> signIn(
      {required String emailAddress, required String password}) async {
    ParseUser user = ParseUser(emailAddress, password, null);
    ParseResponse response = await user.login();
    return responseLog(response);
  }

  //déconnexion
  logout(ParseUser user, BuildContext context) async {
    await user.logout();
    goBack(context);
  }

  //Gestion de la réponse
  LoginResponse responseLog(ParseResponse response) {
    if (response.success) {
      return LoginResponse(result: true, error: null);
    } else {
      return LoginResponse(result: false, error: response.error?.message);
    }
  }

  //Go to main
  goBack(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
        (Route<dynamic> route) => false);
  }

  // Réinitialisation du mot de passe
Future<LoginResponse> resetPassword(String emailAddress) async {
  ParseUser user = ParseUser(emailAddress, null, null);
  final ParseResponse response = await user.requestPasswordReset();
  return responseLog(response);
}


  //Update User
  Future<bool> updateUser(
      {required ParseUser user,
      required String key,
      required dynamic value}) async {
    user.set(key, value);
    await user.save();
    return true;
  }

  //Gestion des images
  Future<ParseFile?> saveImage(File file) async {
    final ParseFile parseFile = ParseFile(file);
    final result = await parseFile.save();
    return (result.success) ? parseFile : null;
  }

  String? getImageForUser(ParseUser user) {
    ParseFile? parseFile = user["image"] as ParseFile?;
    return (parseFile == null) ? null : parseFile["url"] as String;
  }

  String? getImageforChat(ParseObject object) {
    ParseFile? parseFile = object["image"] as ParseFile;
    return (parseFile == null) ? null : parseFile["url"] as String;
  }

//   //Obtenir Utilisateurs

  Future<List<ParseObject>> getAllUsers() async {
    QueryBuilder<ParseUser> queryBuilder =
        QueryBuilder<ParseUser>(ParseUser.forQuery());
    ParseResponse parseResponse = await queryBuilder.query();
    return responseQuery(parseResponse);
  }

  Future<List<ParseObject>> list({required ParseUser parseUser}) async {
    ParseObject? mylist = await getContactsTable(id: parseUser.objectId!);
    final list = mylist?["liste"] ?? [];
    QueryBuilder<ParseUser> queryBuilder =
        QueryBuilder<ParseUser>(ParseUser.forQuery());
    queryBuilder.whereNotEqualTo("objectId", parseUser.objectId);
    queryBuilder.whereNotContainedIn("objectId", list);
    ParseResponse parseResponse = await queryBuilder.query();
    return responseQuery(parseResponse);
  }

  List<ParseObject> responseQuery(ParseResponse response) {
    if (response.success && response.result != null) {
      return response.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<ParseObject?> getContactsTable({required String id}) async {
    ParseObject parseObject = ParseObject("Contacts");
    QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(parseObject);
    queryBuilder.whereContains("userId", id);
    ParseResponse response = await queryBuilder.query();
    final result = responseQuery(response);
    if (result.isEmpty) return null;
    return result.first;
  }

  // Filtrer les utilisateurs par rôle
  Future<List<ParseObject>> getUsersByRole(String role) async {
    QueryBuilder<ParseUser> queryBuilder =
        QueryBuilder<ParseUser>(ParseUser.forQuery());
    queryBuilder.whereEqualTo('role', role);
    ParseResponse parseResponse = await queryBuilder.query();
    return responseQuery(parseResponse);
  }

//Rechercher les utilisateur avec le Nom
  Future<List<ParseObject>> searchUsersByUsername(
      String username, ParseUser currentUser) async {
    QueryBuilder<ParseUser> queryBuilder =
        QueryBuilder<ParseUser>(ParseUser.forQuery());
    queryBuilder.whereContains("username", username);
    queryBuilder.whereNotEqualTo("objectId", currentUser.objectId);
    ParseResponse parseResponse = await queryBuilder.query();
    return responseQuery(parseResponse);
  }

  Stream<List<ParseObject>> searchUsersByUsernameStream(
      String username, ParseUser currentUser) {
    StreamController<List<ParseObject>> controller =
        StreamController<List<ParseObject>>();

    void performSearch() async {
      if (username.isNotEmpty) {
        List<ParseObject> results =
            await searchUsersByUsername(username, currentUser);
        controller.add(results);
      } else {
        controller.add([]);
      }
    }

    // Appeler performSearch() chaque fois que le nom d'utilisateur change
    // pour mettre à jour les résultats de recherche en temps réel.
    controller.onListen = performSearch;
    controller.onCancel = () {};

    return controller.stream;
  }

//   //Ajout de likes(
//   Future<bool> addLikes({required ParseUser user, required String? id}) async {
//     if (id == null) return false;
//     List<dynamic> likes = user["likes"] ?? [];
//     if (!likes.contains(id!)) {
//       likes.add(id!);
//     }
//     final updated = await updateUser(user: user, key: "likes", value: likes);
//     print(updated);
//     return updated;
//   }

//   //Matches

//   Future<bool> checkMatch({required ParseUser me, required ParseUser potentialMatch}) async {
//     List<dynamic>? potentialLikes = potentialMatch["likes"];
//     if (potentialLikes == null) return false;
//     if (potentialLikes.contains(me.objectId!)) {
//       await updateLikes(me: me, newLike: potentialMatch);
//       await updateLikes(me: potentialMatch, newLike: me);
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> updateLikes({required ParseUser me, required ParseUser newLike}) async {
//     ParseObject? object =  await getContactsTable(id: me.objectId!);
//     if (object == null) {
//       List<dynamic> list = [newLike.objectId!];
//       final newO = ParseObject("Contacts")
//         ..set("userId", me.objectId!)
//         ..set("matches", list);
//       await newO.save();
//       await conversation(from: me.objectId!, to: newLike.objectId!);
//       return true;
//     } else {
//       List<dynamic> list = object!["matches"];
//       list.add(newLike.objectId!);
//       object.set("matches", list);
//       await object.save();
//       //Créa objet conversation
//       await conversation(from: me.objectId!, to: newLike.objectId!);
//       return true;
//     }
//   }

//   Future<ParseObject> conversation({required String from, required String to}) async {
//     ParseObject conv = ParseObject("Conversation");
//     QueryBuilder<ParseObject> queryBuilder = QueryBuilder<ParseObject>(conv);
//     queryBuilder.whereArrayContainsAll("participants", [from, to]);
//     ParseResponse r = await queryBuilder.query();
//     List<ParseObject> result = responseQuery(r);
//     if (result.isEmpty) {
//       //Créer une nouvelle conv
//       ParseObject object = ParseObject("Conversation")
//           ..set("participants", [from, to]);
//       await object.save();
//       return object;
//     } else {
//       return result.first;
//     }
//   }

//   //Obtenir les conversations
//   Future<List<UserConversation>> getMatches({required ParseUser myUser}) async {
//     ParseObject? contact = await getContactsTable(id: myUser.objectId!);
//     //Récupérer l'array avec la liste des id que j'ai matche
//     List<dynamic> array = contact?["matches"] ?? [];
//     //Récupere tous les users de cet array
//     QueryBuilder<ParseUser> queryBuilder = QueryBuilder<ParseUser>(ParseUser.forQuery());
//     queryBuilder.whereNotEqualTo("objectId", myUser.objectId!);
//     queryBuilder.whereContainedIn("objectId", array);
//     final response = await queryBuilder.query();
//     final resultUsers = responseQuery(response);
//     //Convertir les users en List de String
//     final List<dynamic> usersId = resultUsers.map((user) => user.objectId).toList();
//     //Obtenir les conversations ou ces listes sont contenues
//     final conversations = await getAllConversations(ids: usersId);
//     //Créer Liste vide uC
//     List<UserConversation> userConversation = [];
//     //Boucler pour récupérer user et conversation qui lui conrrespond
//     resultUsers.forEach((element) {
//       ParseObject conversation = conversations.firstWhere((ParseObject conv) {
//         List<dynamic> participants = conv["participants"];
//         return (participants.contains(element.objectId) && (participants.contains(myUser.objectId)));
//       });
//       userConversation.add(UserConversation(user: element as ParseUser, conversation: conversation));
//     });
//     return userConversation;
//   }

//   Future<List<ParseObject>> getAllConversations({required List<dynamic> ids}) async {
//     QueryBuilder<ParseObject> queryBuilder = QueryBuilder<ParseObject>(ParseObject("Conversation"));
//     queryBuilder.whereContainedIn("participants", ids);
//     var r = await queryBuilder.query();
//     return responseQuery(r);
//   }

//   Future<bool> sendMessage({required String from, required String to, String? text, ParseFile? image}) async {
//     //Obtenir la conversationActuelle;
//     ParseObject currentConversation = await conversation(from: from, to: to);
//     int date = DateTime.now().millisecondsSinceEpoch;
//     ParseObject newMessage = ParseObject("Message");
//     newMessage.set("from", from);
//     newMessage.set("to", to);
//     newMessage.set("date", date);
//     if (text != null) {
//       newMessage.set("text", text!);
//     }
//     if (image != null) {
//       newMessage.set("image", image!);
//     }
//     newMessage.set("conversation", ParseObject("Conversation")..objectId = currentConversation.objectId);
//     await newMessage.save();
//     Map<String, dynamic> lastMessage = {
//       "from": from,
//       "to": to,
//       "text": text,
//       "date": date
//     };
//     currentConversation.set("lastMessage", lastMessage);
//     await currentConversation.save();
//     return true;
//   }

//   QueryBuilder<ParseObject> queryMessages({required String pointer}) {
//     ParseObject message = ParseObject("Message");
//     QueryBuilder<ParseObject> queryBuilder = QueryBuilder<ParseObject>(message);
//     queryBuilder.whereEqualTo("conversation", (ParseObject("Conversation")..objectId = pointer));
//     queryBuilder.orderByAscending("date");

//     return queryBuilder;
//   }
}
