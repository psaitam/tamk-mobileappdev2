import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jako/features/auth/providers/auth_providers.dart';
import 'package:jako/features/expenses/domain/expense.dart';
import 'package:jako/features/expenses/providers/expenses_providers.dart';
import 'package:jako/features/people/domain/person.dart';
import 'package:jako/features/people/providers/people_providers.dart';

class AddExpensePage extends ConsumerStatefulWidget {
  final Expense? existingExpense;

  const AddExpensePage({super.key, this.existingExpense});

  bool get isEdit => existingExpense != null;

  @override
  ConsumerState<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends ConsumerState<AddExpensePage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  XFile? _attachment;
  bool _uploading = false;

  String? _paidByPersonId;
  final Set<String> _participantIds = {};

  @override
  void initState() {
    super.initState();

    final expense = widget.existingExpense;
    if (expense != null) {
      _titleController.text = expense.title;
      _amountController.text = expense.amount.toStringAsFixed(2);
      _paidByPersonId = expense.paidByPersonId;
      _participantIds.addAll(expense.participantIds);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final peopleAsync = ref.watch(peopleStreamProvider);
    final authAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add expense')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (€)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 24),

              peopleAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error loading friends: $e'),
                data: (people) {
                  return authAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error loading user: $e'),
                    data: (user) {
                      if (user == null) {
                        return const Text('Not authenticated');
                      }

                      final allPeople = [
                        Person(
                          id: user.uid,
                          name:
                              (user.displayName == null ||
                                  user.displayName!.isEmpty)
                              ? 'You'
                              : user.displayName!,
                          email: user.email,
                        ),
                        ...people,
                      ];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Paid by',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          _buildPayerSelector(allPeople),
                          const SizedBox(height: 16),
                          const Text(
                            'Participants',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _buildParticipantsSelector(allPeople),
                        ],
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              if (_attachment != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.file(
                        File(_attachment!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

              OutlinedButton.icon(
                onPressed: _uploading ? null : _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Add receipt'),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _uploading ? null : _onSavePressed,
                  child: _uploading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save expense'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPayerSelector(List<Person> people) {
    return DropdownButtonFormField<String>(
      value: _paidByPersonId,
      hint: const Text('Select who paid'),
      items: people
          .map(
            (person) =>
                DropdownMenuItem(value: person.id, child: Text(person.name)),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _paidByPersonId = value;
        });
      },
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }

  Widget _buildParticipantsSelector(List<Person> people) {
    return Column(
      children: people.map((person) {
        final isSelected = _participantIds.contains(person.id);

        return CheckboxListTile(
          value: isSelected,
          title: Text(person.name),
          onChanged: (checked) {
            setState(() {
              if (checked == true) {
                _participantIds.add(person.id);
              } else {
                _participantIds.remove(person.id);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Future<void> _onSavePressed() async {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();

    if (title.isEmpty) {
      _showError('Please enter a title');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    if (_paidByPersonId == null) {
      _showError('Please select who paid');
      return;
    }

    if (_participantIds.isEmpty) {
      _showError('Please select at least one participant');
      return;
    }

    final auth = ref.read(authStateProvider).value!;
    final repo = ref.read(expensesRepositoryProvider);

    final isEdit = widget.isEdit;
    final expenseId = isEdit
        ? widget.existingExpense!.id
        : repo.createExpenseRef().id;

    String? attachmentUrl;

    try {
      if (_attachment != null) {
        setState(() => _uploading = true);

        final storage = FirebaseStorage.instance;
        final storageRef = storage
            .ref()
            .child('receipts')
            .child(auth.uid)
            .child('$expenseId.jpg');

        await storageRef.putFile(File(_attachment!.path));
        attachmentUrl = await storageRef.getDownloadURL();
      }

      if (isEdit) {
        await repo.updateExpense(
          expenseId: expenseId,
          title: title,
          amount: amount,
          paidByPersonId: _paidByPersonId!,
          participantIds: _participantIds.toList(),
          attachmentUrl: attachmentUrl ?? widget.existingExpense!.attachmentUrl,
        );
      } else {
        final expenseRef = repo.createExpenseRef();

        await repo.addExpenseWithRef(
          ref: expenseRef,
          title: title,
          amount: amount,
          paidByPersonId: _paidByPersonId!,
          participantIds: _participantIds.toList(),
          attachmentUrl: attachmentUrl,
        );
      }

      if (mounted) {
        if (widget.isEdit) {
          Navigator.of(context).pop(); // close edit page
          Navigator.of(context).pop(); // close details page
        } else {
          Navigator.of(context).pop(); // close add page
        }
      }
    } catch (e) {
      _showError('Failed to save expense: $e');
    } finally {
      if (mounted) {
        setState(() => _uploading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );

    if (image != null) {
      setState(() {
        _attachment = image;
      });
    }
  }
}
