// import 'package:flutter/material.dart';

// class WithdrawlScreen extends StatefulWidget {
//   const WithdrawlScreen({super.key});

//   @override
//   State<WithdrawlScreen> createState() => _WithdrawlScreenState();
// }

// class _WithdrawlScreenState extends State<WithdrawlScreen> {
//   final TextEditingController _amountController = TextEditingController();
//   bool _isBankAccountSelected = false;

//   @override
//   void dispose() {
//     _amountController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: const Icon(Icons.trending_up, color: Colors.black),
//         title: const Text(
//           'Earnings',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Today's Earnings Card
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 border: Border.all(color: const Color.fromARGB(255, 202, 201, 201)),
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     'Today Earnings On 10 Apr',
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     '₹1250',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
            
//             // Wallet Balance and Customer Tips Row
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey[300]!),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Wallet Balance',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         const Text(
//                           '₹1250',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey[300]!),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Customer Tips',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         const Text(
//                           '₹100',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
            
//             // Enter Amount Section
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Enter Ammount',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: _amountController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     hintText: 'Enter Withdrawl Ammount',
//                     hintStyle: TextStyle(
//                       color: Colors.grey[400],
//                       fontSize: 14,
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey[50],
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(color: Colors.green, width: 2),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
            
//             // Withdrawl Money To Section
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Withdrawl Money To',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 TextButton.icon(
//                   onPressed: () {},
//                   icon: const Icon(
//                     Icons.add,
//                     size: 18,
//                     color: Colors.green,
//                   ),
//                   label: const Text(
//                     'Add Account',
//                     style: TextStyle(
//                       color: Colors.green,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   style: TextButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
            
//             // Bank Account Card
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _isBankAccountSelected = !_isBankAccountSelected;
//                 });
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: _isBankAccountSelected ? Colors.green : Colors.grey[300]!,
//                     width: _isBankAccountSelected ? 2 : 1,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color: Colors.green[50],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         Icons.account_balance,
//                         color: Colors.green[700],
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'SBI Bank Account',
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             '••••••••••••123',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 13,
//                               letterSpacing: 1,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       width: 20,
//                       height: 20,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: _isBankAccountSelected ? Colors.green : Colors.grey[400]!,
//                           width: 2,
//                         ),
//                         color: _isBankAccountSelected ? Colors.green : Colors.white,
//                       ),
//                       child: _isBankAccountSelected
//                           ? const Icon(
//                               Icons.check,
//                               size: 14,
//                               color: Colors.white,
//                             )
//                           : null,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
            
//             // Confirm Withdrawl Button
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   foregroundColor: Colors.green,
//                   side: const BorderSide(color: Colors.green, width: 2),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: const Text(
//                   'Confirm Withdrawl',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



















import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veggify_delivery_app/models/Wallet/account.dart';
import 'package:veggify_delivery_app/provider/Wallet/wallet_provider.dart';

class WithdrawlScreen extends StatefulWidget {
  const WithdrawlScreen({super.key});

  @override
  State<WithdrawlScreen> createState() => _WithdrawlScreenState();
}

class _WithdrawlScreenState extends State<WithdrawlScreen> {
  final TextEditingController _amountController = TextEditingController();
  AccountModel? _selectedAccount;
  bool _isBankAccountSelected = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final prov = Provider.of<WalletProvider>(context, listen: false);
      prov.loadWallet();
      prov.loadAccounts();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _showAddAccountDialog() async {
    final _acNo = TextEditingController();
    final _bank = TextEditingController();
    final _holder = TextEditingController();
    final _ifsc = TextEditingController();
    final _upi = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Account'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _acNo, decoration: const InputDecoration(labelText: 'Account Number')),
              TextField(controller: _bank, decoration: const InputDecoration(labelText: 'Bank Name')),
              TextField(controller: _holder, decoration: const InputDecoration(labelText: 'Account Holder Name')),
              TextField(controller: _ifsc, decoration: const InputDecoration(labelText: 'IFSC Code')),
              TextField(controller: _upi, decoration: const InputDecoration(labelText: 'UPI (optional)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_acNo.text.trim().isEmpty || _bank.text.trim().isEmpty || _holder.text.trim().isEmpty || _ifsc.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill required fields')));
                return;
              }

              final account = AccountModel(
                id: '',
                accountNumber: _acNo.text.trim(),
                bankName: _bank.text.trim(),
                accountHolderName: _holder.text.trim(),
                ifscCode: _ifsc.text.trim(),
                upiId: _upi.text.trim().isEmpty ? null : _upi.text.trim(),
              );

              final ok = await Provider.of<WalletProvider>(context, listen: false).addAccount(account);
              Navigator.pop(ctx, ok);
              if (ok) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account added')));
              } else {
                final err = Provider.of<WalletProvider>(context, listen: false).error ?? 'Failed to add account';
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result == true) {
      await Provider.of<WalletProvider>(context, listen: false).loadAccounts();
    }
  }

  Future<void> _confirmWithdraw() async {
    final prov = Provider.of<WalletProvider>(context, listen: false);
    final walletBal = prov.wallet?.walletBalance ?? 0.0;
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid amount')));
      return;
    }
    if (amount > walletBal) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient balance')));
      return;
    }
    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select account to withdraw to')));
      return;
    }

    final ok = await prov.withdraw(amount, _selectedAccount!);
    if (ok) {
      _amountController.clear();
      setState(() {
        _selectedAccount = null;
        _isBankAccountSelected = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Withdraw request submitted')));
    } else {
      final err = prov.error ?? 'Withdraw failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(builder: (context, prov, _) {
      final wallet = prov.wallet;
      final accounts = prov.accounts;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const Icon(Icons.trending_up, color: Colors.black),
          title: const Text(
            'Earnings',
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 202, 201, 201)),
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(children: [
                Text('Today Earnings', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 8),
                Text('₹${wallet?.todayEarnings?.toStringAsFixed(0) ?? '0'}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ]),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Wallet Balance', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('₹${wallet?.walletBalance?.toStringAsFixed(0) ?? '0'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text('Enter Ammount', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Enter Withdrawl Ammount', filled: true, fillColor: Colors.grey[50], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.green, width: 2)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
            ),

            const SizedBox(height: 24),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Withdrawl Money To', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              TextButton.icon(onPressed: _showAddAccountDialog, icon: const Icon(Icons.add, size: 18, color: Colors.green), label: const Text('Add Account', style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w500)), style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8))),
            ]),

            const SizedBox(height: 12),

            if (accounts.isEmpty)
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: const Text('No account added'))
            else
              Column(children: accounts.map((a) {
                final selected = _selectedAccount?.id == a.id;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAccount = a;
                      _isBankAccountSelected = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: selected ? Colors.green : Colors.grey.shade300, width: selected ? 2 : 1)),
                    child: Row(children: [
                      Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)), child: Icon(Icons.account_balance, color: Colors.green[700], size: 24)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(a.bankName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)), const SizedBox(height: 4), Text('••••••${a.accountNumber.length > 4 ? a.accountNumber.substring(a.accountNumber.length - 4) : a.accountNumber}', style: TextStyle(color: Colors.grey[600]))])),
                      Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: selected ? Colors.green : Colors.grey[400]!, width: 2), color: selected ? Colors.green : Colors.white), child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null),
                    ]),
                  ),
                );
              }).toList()),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: prov.state == WalletState.submitting ? null : _confirmWithdraw,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green, side: const BorderSide(color: Colors.green, width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: prov.state == WalletState.submitting ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Confirm Withdrawl', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),

            if (prov.state == WalletState.error && prov.error != null) ...[
              const SizedBox(height: 12),
              Text('Error: ${prov.error}', style: const TextStyle(color: Colors.red)),
            ],
          ]),
        ),
      );
    });
  }
}
