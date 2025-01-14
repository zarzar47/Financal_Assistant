import 'package:finance_app/backend_API.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This is the section for the modal that allows us to INPUT DATA to enter new transactions
class AddTransactionButton extends StatelessWidget {
  const AddTransactionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 40.0,
          color: Color.fromARGB(255, 156, 39, 177),
        ),
        onPressed: () => showTransactionForm(context),
        // child: const Text('Add Transaction'),
      ),
    );
  }

  void showTransactionForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TransactionFormDialog();
      },
    );
  }
}

class TransactionFormDialog extends StatefulWidget {
  const TransactionFormDialog({super.key});

  @override
  _TransactionFormDialogState createState() => _TransactionFormDialogState();
}

class _TransactionFormDialogState extends State<TransactionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final String _categoryController = "Food";
  final String _subCategoryController = "";
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Transaction Details'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration:
                    const InputDecoration(labelText: 'Date (DD-MM-YYYY)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    DateTime now = DateTime.now();
                    String formattedDate =
                        "${now.day}-${now.month}-${now.year}";
                    _dateController.text = formattedDate;
                    // return 'Date is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Description (optional)'),
              ),
              TextFormField(
                controller: _locationController,
                decoration:
                    const InputDecoration(labelText: 'Location (optional)'),
              ),
              // TODO
              //adding Image selector to add images in the long run (to build memories ig)
              // const SizedBox(height: 10),
              // Row(
              //   children: [
              //     ElevatedButton(
              //       onPressed: () async {
              //         // Simulate picking an image
              //         setState(() {
              //           _imagePath = 'example_image_path.jpg';
              //         });
              //       },
              //       child: const Text('Upload Picture (optional)'),
              //     ),
              //     if (_imagePath != null) const SizedBox(width: 10),
              //     if (_imagePath != null)
              //       const Icon(Icons.check_circle, color: Colors.green),
              //   ],
              // ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _buildTransactionSummary();
              Navigator.pop(context);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  _buildTransactionSummary() {
    Map<String, dynamic> result = {
      "Price": int.parse(_priceController.text),
      "Category": _categoryController.isEmpty ? "N/A" : _categoryController,
      "Subcategory":
          _subCategoryController.isEmpty ? "N/A" : _subCategoryController,
      "Date": _dateController.text,
      "Description": _descriptionController.text.isEmpty
          ? "N/A"
          : _descriptionController.text,
      "Location":
          _locationController.text.isEmpty ? "N/A" : _locationController.text,
      "Picture": _imagePath ?? "None",
    };
    print("Result of transaction $result");
    // Database().addTransToFirebase(result);
    Provider.of<Database>(context, listen: false).addTransaction(
      result,
    );
    // return result;
  }

  @override
  void dispose() {
    _priceController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
