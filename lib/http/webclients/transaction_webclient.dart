import 'dart:convert';

import 'package:estudando_flutter2/http/webclient.dart';
import 'package:estudando_flutter2/models/contact.dart';
import 'package:estudando_flutter2/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebClient {

  List<Transaction> _toTransactions(response) {
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = List();

    for(Map<String, dynamic> transactionJson in decodedJson) {

        final Map<String, dynamic> contactJson = transactionJson['contact'];

        final Transaction transaction = Transaction( transactionJson['value'], 
              Contact(0, contactJson['name'], 
                          contactJson['accountNumber'], ) );

        transactions.add(transaction);
    }
    return transactions;
  }

  Transaction _toTransaction(response) {
    Map<String, dynamic> json = jsonDecode(response.body);
    final Map<String, dynamic> contactJson = json['contact'];
    return Transaction( json['value'], 
        Contact(0, contactJson['name'], 
                    contactJson['accountNumber'], ) );
  }

  Map<String, dynamic> _toMap(transaction){
    final Map<String, dynamic> transactionMap = {
        'value' : transaction.value,
        'contact' : {
          'name' : transaction.contact.name,
          'accountNumber' : transaction.contact.accountNumber
        }
    };
    return transactionMap;
  }

  Future<List<Transaction>> findAll() async {

    final Response response = await client.get(baseUrl).timeout(Duration(seconds: 5));
    final List<Transaction> transactions = _toTransactions(response);
    return transactions;
  }

  Future<Transaction> save(Transaction transaction) async {
    
    final Map<String, dynamic> transactionMap = _toMap(transaction);
    final String transactionJson = jsonEncode(transactionMap);

    final Response response = await client.post(baseUrl, 
                                      headers: { 'Content-type' : 'application/json',
                                                'password'  : '1000' }, 
                                                body: transactionJson);
  
    return _toTransaction(response);
  }
}