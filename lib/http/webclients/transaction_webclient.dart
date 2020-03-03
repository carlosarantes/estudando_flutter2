import 'dart:convert';

import 'package:estudando_flutter2/http/webclient.dart';
import 'package:estudando_flutter2/models/contact.dart';
import 'package:estudando_flutter2/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebClient {


  Future<List<Transaction>> findAll() async {

    final Response response = await client.get(baseUrl).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map( (dynamic json) => Transaction.fromJson(json)).toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(baseUrl, 
                                      headers: { 'Content-type' : 'application/json',
                                                'password'  : password }, 
                                                body: transactionJson);

    if (response.statusCode == 400) {
      throw Exception('Deu merda'); 
    }                                            

    if (response.statusCode == 401) {
      throw Exception('Poe a senha seu corno'); 
    }                          
  
    return Transaction.fromJson(jsonDecode(response.body)); 
  }
}