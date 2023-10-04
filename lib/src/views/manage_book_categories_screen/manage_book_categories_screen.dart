import 'package:demo/src/sql/sql_helper.dart';
import 'package:flutter/material.dart';

class ManageBookCategoriesScreen extends StatefulWidget {
  const ManageBookCategoriesScreen({super.key});

  @override
  State<ManageBookCategoriesScreen> createState() => _ManageBookCategoriesScreenState();
}

class _ManageBookCategoriesScreenState extends State<ManageBookCategoriesScreen> {

  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getManagesBook();
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

  final TextEditingController _maLoaiSachController = TextEditingController();
  final TextEditingController _tenLoaiSachController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      _maLoaiSachController.text = existingJournal['maLoaiSach'];
      _tenLoaiSachController.text = existingJournal['tenLoaiSach'];
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
                      controller: _maLoaiSachController,
                      decoration: const InputDecoration(hintText: 'Mã thành viên'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _tenLoaiSachController,
                      decoration: const InputDecoration(hintText: 'Tên Thành Viên'),
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
                            _maLoaiSachController.text = '';
                            _tenLoaiSachController.text = '';

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
    await SQLHelper.createManageBook(_maLoaiSachController.text, _tenLoaiSachController.text);
    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateManageBook(id, _maLoaiSachController.text,
        _tenLoaiSachController.text);
    _refreshJournals();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteManageBook(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý thành viên',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
                        Text(
                          '${_journals[index]['maLoaiSach']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${_journals[index]['tenLoaiSach']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500),
                        ),
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
                          child: const Icon(Icons.edit),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            _deleteItem(_journals[index]['id']);
                          },
                          child: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
