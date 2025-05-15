import 'dart:developer';

import 'package:acopiatech/services/auth/auth_exceptions.dart';
import 'package:cloud_functions/cloud_functions.dart';

Future<void> assignAdminRole(String email) async {
  try {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'assignAdminRoleCallable',
    );
    log('Assigning role to $email');

    final result = await callable.call({'email': email});
    log(result.data['message']);
  } on FirebaseFunctionsException catch (e) {
    log(e.code);
    log(e.message!);
    throw CouldNotAssignAdminRoleException();
  }
}
