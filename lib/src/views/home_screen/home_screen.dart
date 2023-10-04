import 'package:demo/src/sql/sql_helper.dart';
import 'package:demo/src/views/manage_book_categories_screen/manage_book_categories_screen.dart';
import 'package:demo/src/views/manage_member/manage_member.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _bookTitleController.text = existingJournal['book_title'];
      _moneyController.text = existingJournal['money'];
    }
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: 15,
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 120,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(hintText: 'thành viên'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _bookTitleController,
                      decoration: const InputDecoration(hintText: 'Tên Sách'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _moneyController,
                      decoration: const InputDecoration(hintText: 'Tiền Mượn'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (id == null) {
                              await _addItem();
                            }
                            if (id != null) {
                              await _updateItem(id);
                            }
                            _titleController.text = '';
                            _bookTitleController.text = '';
                            _moneyController.text = '';

                            Navigator.of(context).pop();
                          },
                          child: Text(id == null ? 'Lưu' : 'Sửa'),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: Text('Huỷ'),
                        ),
                      ],
                    )
                  ],
                ),
              )),
        );
      },
    );

  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(_titleController.text, _bookTitleController.text,
        _moneyController.text);
    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(id, _titleController.text,
        _bookTitleController.text, _moneyController.text);
    _refreshJournals();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  Drawer(child: Information(context)),
      appBar: AppBar(
        title: const Text('Quản lý phiếu mượn',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                  color: Colors.orange[200],
                  margin: const EdgeInsets.all(15),
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_journals[index]['title']}',style: TextStyle(fontWeight: FontWeight.w500),),
                              Text('${_journals[index]['book_title']}',style: TextStyle(fontWeight: FontWeight.w500),),
                              Text('${_journals[index]['money']}',style: TextStyle(fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 0,
                          bottom: 0,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  _showForm(_journals[index]['id']);
                                },
                                child: Icon(Icons.edit),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: (){
                                  _deleteItem(_journals[index]['id']);
                                },
                                child: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }

  Widget Information(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 210,
              width: double.infinity,
              color: Colors.blue,
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.horizontal + 70),
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                  ),
                  Text(
                    'Kieu viet thang',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Icon(Icons.home),
              SizedBox(
                width: 15,
              ),
              Text(
                'Quản lý Phiếu Mượn',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
         Padding(
          padding: EdgeInsets.only(left: 15),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ManageBookCategoriesScreen()));
            },
            child: Row(
              children: [
                Icon(Icons.book),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Quản lý Loại Sách',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf),
              SizedBox(
                width: 15,
              ),
              Text(
                'Quản lý Sách',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
         Padding(
          padding: EdgeInsets.only(left: 15),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ManageMemberScreen()));
            },
            child: Row(
              children: [
                Icon(Icons.person),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Quản lý Thành Viên',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          height: 1,
          width: double.infinity,
          color: Colors.black.withOpacity(0.3),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              'Thống kê',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            )),
        SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Icon(Icons.multiline_chart),
              SizedBox(
                width: 15,
              ),
              Text(
                '10 Sách mượn nhiều nhất',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Icon(Icons.monetization_on),
              SizedBox(
                width: 15,
              ),
              Text(
                'Doanh thu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          height: 1,
          width: double.infinity,
          color: Colors.black.withOpacity(0.3),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              'Người dùng',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            )),
        SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Icon(Icons.key),
              SizedBox(
                width: 15,
              ),
              Text(
                'Đổi mật khẩu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Icon(Icons.logout),
              SizedBox(
                width: 15,
              ),
              Text(
                'Đăng xuất',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
