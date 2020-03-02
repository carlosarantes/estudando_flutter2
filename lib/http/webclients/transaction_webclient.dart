import 'dart:convert';

import 'package:estudando_flutter2/http/webclient.dart';
import 'package:estudando_flutter2/models/contact.dart';
import 'package:estudando_flutter2/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebClient {

  List<Transaction> _toTransactions(response) {
    final List<dynamic> decodedJson = jsonDecode(response.body);

    final List<Transaction> transactions = decodedJson.map( (dynamic json) {
        return Transaction.fromJson(json);
    }).toList();

    return transactions;
  }

  Future<List<Transaction>> findAll() async {

    final Response response = await client.get(baseUrl).timeout(Duration(seconds: 5));
    final List<Transaction> transactions = _toTransactions(response);
    return transactions;
  }

  Future<Transaction> save(Transaction transaction) async {
    
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(baseUrl, 
                                      headers: { 'Content-type' : 'application/json',
                                                'password'  : '1000' }, 
                                                body: transactionJson);
  
    return Transaction.fromJson(jsonDecode(response.body)); 
  }
}