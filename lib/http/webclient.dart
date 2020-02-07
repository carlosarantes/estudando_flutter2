import 'dart:convert';

import 'package:estudando_flutter2/models/contact.dart';
import 'package:estudando_flutter2/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print(data);
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
      print(data);
      return data;
  }
}

Future<List<Transaction>> findAll() async {

  final Client client = HttpClientWithInterceptor.build(interceptors: [
    LoggingInterceptor()
  ]);

  final Response response = await client.get('http://192.168.0.15:8080/transactions');
  
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