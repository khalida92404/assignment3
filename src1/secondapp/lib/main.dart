import 'package:flutter/material.dart';
void main() => runApp(Admin());

enum page{dashBoard, manage}

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  page _selectedpage=page.dashBoard;
 Color active=Colors.red;
 Color notActive=Colors.black;
 TextEditingController categoryController=TextEditingController();
  TextEditingController sampleController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:Scaffold(
        appBar: AppBar(
            title: Row(
              children: [
                Expanded(
                  child: FlatButton.icon(onPressed: (){
                    setState(() {
                      _selectedpage=page.dashBoard;
                    });
                  }, icon: Icon(Icons.dashboard,color: _selectedpage==page.dashBoard?active:notActive,),
                      label: Text('DashBoard')),
                ),
                Expanded(child: FlatButton.icon(onPressed: (){
                  setState(() {
                    _selectedpage=page.manage;
                  });
                }, icon: Icon(Icons.sort,color:_selectedpage==page.manage?active:notActive,),
                    label:Text('Manage')))
              ],
            )
        ),
        body: _loadScreen()));
  }
  Widget _loadScreen(){
    switch (_selectedpage){
      case page.dashBoard:
        return Column(
          children: [
            ListTile(
              subtitle: FlatButton.icon(onPressed: null, icon: Icon(Icons.attach_money), label: Text('money'),),
            ),
            Expanded(
              child: GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                children: [
                  Padding(padding: const EdgeInsets.all(20),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(onPressed: null, icon: Icon(Icons.people_outline), label: Text('Users')),
                      ),
                    ),),
                  Padding(padding: const EdgeInsets.all(20),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(onPressed: null, icon: Icon(Icons.category),
                            label: Text('Category')),
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(20),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(onPressed: null, icon: Icon(Icons.people_outline), label: Text('Test')),
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(20),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(onPressed: null, icon: Icon(Icons.people_outline), label: Text('Orders')),
                      ),
                    ),
                  ),

                ],),

            )
          ],
        );
        break;
      case page.manage:return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Tests'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.change_history),
            title: Text('category history'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Sample Type'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('fasting or not'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Category'),
            onTap: (){
              _categoryBox();
            },
          ),
        ],
      );

    }
  }

  void _categoryBox() {
    var _add=new AlertDialog(

        content:Form(
          child: TextFormField(
            controller: categoryController,
            decoration: InputDecoration(
              hintText: 'add tests category'
            ),
            validator: (value){
              if(value.isEmpty){
                return 'category should be added';
              }
              else return null;
            },
          ),
        ),
      actions: [
        FlatButton(
          onPressed: (){},
          child: Text('add'),

        ),

        FlatButton(onPressed: (){
           Navigator.pop(context);
        },
        child: Text('cancel'),)
      ],
    );


  }
}
