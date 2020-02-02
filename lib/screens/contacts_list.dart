import 'package:estudando_flutter2/dao/contact_dao.dart';
import 'package:estudando_flutter2/models/contact.dart';
import 'package:estudando_flutter2/screens/contact_form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {

final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text('Lista de Contatos'), ) ,
      body: 
        FutureBuilder<List<Contact>>(
          // future: findAll(),
          initialData: List(),
          future: _dao.findAll(),
          builder: (context, snapshot){

              switch(snapshot.connectionState){

                case ConnectionState.none:
                break;

                case ConnectionState.waiting:
                  return Center(
                            child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CircularProgressIndicator(),
                                    Text('Loading...'),
                                  ],
                                ),
                          );
                break;

                case ConnectionState.active:
                break;

                case ConnectionState.done:
                  final List<Contact> contacts = snapshot.data;
                  return ListView.builder(
                    itemBuilder: (context, index){
                      final Contact contact = contacts[index];
                      return _ContactItem(contact);
                    },
                    itemCount: contacts.length,
                  );                  
                  
                break;
              }

              return Text('Unknown error... try later...');
          },
        ),      
      floatingActionButton: FloatingActionButton(
         onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ContactForm(),
              ),
            );
         },
         child: Icon(
            Icons.add
         ),
      ),
    );
  }
}


class _ContactItem extends StatelessWidget{

  final Contact contact;

  const _ContactItem(this.contact);

  @override
  Widget build(BuildContext context) {
    return Card(
                child: ListTile(
                  title: Text(contact.name, style: TextStyle( fontSize: 24.0 ), ),
                  subtitle: Text(contact.accountNumber.toString(), style: TextStyle( fontSize: 16.0 ) ,),
                ),
              );
  }
  
}