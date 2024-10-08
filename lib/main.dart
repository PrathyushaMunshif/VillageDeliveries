import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:flutter/services.dart';

void main() {
  runApp(DeliveryApp());
}

// echo "# Vg" >> README.md
// git init
// git add README.md
// git commit -m "first commit"
// git branch -M main
// git remote add origin https://github.com/PrathyushaMunshif/Vg.git
// git push -u origin main

class DeliveryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales Entry',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: CardTheme(color: Colors.blue.shade50),
        useMaterial3: true,
      ),
      home: DeliveryBoysPage(),
    );
  }
}

class DeliveryBoysPage extends StatefulWidget {
  @override
  _DeliveryBoysPageState createState() => _DeliveryBoysPageState();
}

class _DeliveryBoysPageState extends State<DeliveryBoysPage> {
  List<DeliveryBoy> deliveryBoys = [];
  DateTime selectedDate = DateTime.now();

  // Filter delivery boys based on selected date
  List<DeliveryBoy> getFilteredData() {
    return deliveryBoys.map((boy) {
      // final boy1 = List<DeliveryBoy>();
      // List<deliveryBoys> 
      // Filter the sales entries for each delivery boy based on the selected date
      boy.salesEntries = boy.salesEntries.where((entry) => isSameDate(entry.date, selectedDate)).toList();
      return boy;
    }).toList().reversed.toList();
  }

  // Helper function to compare two dates (ignores time)
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  List<DeliveryBoy> getData(){
   return deliveryBoys.reversed.toList();
  }

  void _addDeliveryBoy(String name) {
    if (name.isNotEmpty) {
      setState(() {
        deliveryBoys.add(DeliveryBoy(name: name));
      });
    }
  }

  void _enterSalesDetails(DeliveryBoy boy) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => SalesDetailsPage(boy: boy),
            ),
          )
          .then((_) {
        setState(() {});
      });
    });
  }

  void _viewSalesDetails(DeliveryBoy boy) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DeliveryBoySalesPage(boy: boy),
        ),
      );
    });
  }

  double _calculateTotalSalesForAllDeliveryBoys() {
    return deliveryBoys.fold(0, (total, boy) => total + boy.totalAmount);
  }

  double _calculateTotalCashForAllDeliveryBoys() {
    return deliveryBoys.fold(0, (total, boy) => total + boy.totalCash);
  }

  double _calculateTotalUPIForAllDeliveryBoys() {
    return deliveryBoys.fold(0, (total, boy) => total + boy.totalUPI);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: const Text(
                'Delivery Boys',
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center, // Center the text within the available space
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today, size: 20, color: Colors.black), // Small date picker icon
              onPressed: _pickDate, // Function to open date picker
            ),
          ],
        ),
        backgroundColor: Colors.cyan[700],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: getFilteredData().length,
              itemBuilder: (context, index) {
                DeliveryBoy boy = getFilteredData()[index];
                return ListTile(
                  title: Text(boy.name),
                  subtitle: Text(
                    'Cash: ₹${boy.totalCash.toStringAsFixed(2)}, '
                    'UPI: ₹${boy.totalUPI.toStringAsFixed(2)}, '
                    'Total: ₹${boy.totalAmount.toStringAsFixed(2)}',
                  ),
                  onTap: () => _viewSalesDetails(boy),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _enterSalesDetails(boy),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Cash: ₹${_calculateTotalCashForAllDeliveryBoys().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Total UPI: ₹${_calculateTotalUPIForAllDeliveryBoys().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Total Amount: ₹${_calculateTotalSalesForAllDeliveryBoys().toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDeliveryBoyDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDeliveryBoyDialog() {
    String name = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Delivery Boy'),
          content: TextField(
            onChanged: (value) {
              name = value;
            },
            decoration: InputDecoration(hintText: 'Enter name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  _addDeliveryBoy(name);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class DeliveryBoy {
  String name;
  List<SalesEntry> salesEntries = [];

  // List<SalesEntry> salesData() {
  //   return salesEntries.reversed.toList();
  // }
  // List<DeliveryBoy> getData(){
  //  return deliveryBoys.reversed.toList();
  // }

  DeliveryBoy({required this.name});

  // Total cash collected
  double get totalCash {
    return salesEntries.fold(0, (total, entry) => total + entry.cash);
  }

  // Total UPI collected
  double get totalUPI {
    return salesEntries.fold(0, (total, entry) => total + entry.upi);
  }

  // Total (cash + UPI)
  double get totalAmount {
    return totalCash + totalUPI;
  }

  void addSalesEntry(String customerName, double cash, double upi, DateTime date, DateTime time) {
    salesEntries.add(SalesEntry(customerName: customerName, cash: cash, upi: upi, date: date, time: time));
  }

  void updateSalesEntry(SalesEntry entry, String customerName, double cash, double upi) {
    entry.customerName = customerName;
    entry.cash = cash;
    entry.upi = upi;
  }
}

class SalesEntry {
  String customerName;
  double cash;
  double upi;
  DateTime date;
  DateTime time;

  SalesEntry({required this.customerName, required this.cash, required this.upi, required this.date, required this.time});
}

class SalesDetailsPage extends StatefulWidget {
  final DeliveryBoy boy;

  SalesDetailsPage({required this.boy});

  @override
  _SalesDetailsPageState createState() => _SalesDetailsPageState();
}

class _SalesDetailsPageState extends State<SalesDetailsPage> {
  String customerName = '';
  double cash = 0;
  double upi = 0;
  DateTime selectedDate = DateTime.now(); // Set the default date to now
  DateTime selectedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
          backgroundColor: Colors.cyan[700],
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(40),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        );
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales for ${widget.boy.name}'),
        centerTitle: true,
        backgroundColor: Colors.cyan[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Customer Name'),
              onChanged: (value) {
                setState(() {
                  customerName = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Cash Collected (₹)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: (value) {
                setState(() {
                  cash = double.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'UPI Collected (₹)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: (value) {
                setState(() {
                  upi = double.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Total Amount Collected (₹)',
              ),
              controller: TextEditingController(
                text: (cash + upi).toStringAsFixed(2),
              ),
              readOnly: true,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(selectedDate)),
              readOnly: true,
              style: const TextStyle(color: Colors.grey),
              // onTap: () async {
              //   final DateTime? picked = await showDatePicker(
              //     context: context,
              //     initialDate: selectedDate,
              //     firstDate: DateTime(2000),
              //     lastDate: DateTime(2101),
              //   );
              //   if (picked != null && picked != selectedDate) {
              //     setState(() {
              //       selectedDate = picked;
              //     });
              //   }
              // },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Time',
                suffixIcon: Icon(Icons.access_time),
              ),
              controller: TextEditingController(
                text: DateFormat('HH:mm:ss').format(selectedTime), // Display current time in HH:mm:ss format
              ),
              readOnly: true,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: style,
              onPressed: () {
                if (customerName.isNotEmpty && (cash > 0 || upi > 0)) {

                  setState(() {
                    widget.boy.addSalesEntry(customerName, cash, upi, selectedDate, selectedTime);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryBoySalesPage extends StatefulWidget {
  final DeliveryBoy boy;

  DeliveryBoySalesPage({required this.boy});

  @override
  _DeliveryBoySalesPageState createState() => _DeliveryBoySalesPageState();
}

class _DeliveryBoySalesPageState extends State<DeliveryBoySalesPage> {
  void _editSalesEntry(SalesEntry entry) {
    showDialog(
      context: context,
      builder: (context) {
        String customerName = entry.customerName;
        double cash = entry.cash;
        double upi = entry.upi;
        // DateTime selectedDate = entry.date;

        return AlertDialog(
          title: Text('Edit Sales'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: customerName),
                decoration: InputDecoration(labelText: 'Customer Name'),
                onChanged: (value) {
                  customerName = value;
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: cash.toStringAsFixed(2)),
                decoration: InputDecoration(labelText: 'Cash Collected (₹)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                onChanged: (value) {
                  cash = double.tryParse(value) ?? 0;
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: upi.toStringAsFixed(2)),
                decoration: InputDecoration(labelText: 'UPI Collected (₹)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                onChanged: (value) {
                  upi = double.tryParse(value) ?? 0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  widget.boy.updateSalesEntry(entry, customerName, cash, upi);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales for ${widget.boy.name}'),
        centerTitle: true,
        backgroundColor: Colors.cyan[700],
      ),
      body: ListView.builder(
      itemCount: widget.boy.salesEntries.length,
      itemBuilder: (context, index) {
        SalesEntry entry = widget.boy.salesEntries.reversed.toList()[index];
        return Card(
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures space between customerName and cash/UPI
              children: [
                Text(
                  '${entry.customerName}', 
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${entry.cash.toStringAsFixed(0)}, @${entry.upi.toStringAsFixed(0)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            subtitle: Text(
              '${DateFormat('MMM dd').format(entry.date)} ${DateFormat('HH:mm').format(entry.time)}',
            ),
            // trailing: IconButton(
            //   icon: Icon(Icons.edit, size: 20), // Icon button aligned to the right
            //   onPressed: () {
            //     _editSalesEntry(entry);
            //   },
            // ),
          ),
        );
      },
    ),


    );
  }
}