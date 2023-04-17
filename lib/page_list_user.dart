
import 'package:belajarapi/page_detail_user.dart';
import 'package:belajarapi/users_model.dart';
import 'package:flutter/material.dart';

import 'api_data_source.dart';

class PageListUsers extends StatelessWidget {
  const PageListUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List dari User"),
      ),
      body: _buildListUsersBody(),
    );
  }

  Widget _buildListUsersBody(){
    return Container(
      child: FutureBuilder(
        future: ApiDataSource.instance.loadUsers(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasError){
            // Jika data ada error maka akan ditampilkan hasil error
            return _buildErrorSection();
          }
          if(snapshot.hasData){
            // Jika data ada dan berhasil maka akan ditampilkan hasil datanya
            UsersModel usersModel = UsersModel.fromJson(snapshot.data);
            return _buildSuccessSection(usersModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return Text("Error");
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(UsersModel users) {
    return ListView.builder(
      itemCount: users.data!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemUsers(context, users.data![index]);
      },
    );
  }

  Widget _buildItemUsers(BuildContext context, Data userData) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PageDetailUser(idUser: userData.id!,))
      ),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 100,
              child: Image.network(userData.avatar!),
            ),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userData.firstName! + " " + userData.lastName!),
                Text(userData.email!)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
