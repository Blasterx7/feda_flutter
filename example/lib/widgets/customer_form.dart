import 'package:flutter/material.dart';

class CustomerForm extends StatefulWidget {
  final Map<String, dynamic>? initialValues;
  final bool autoValidate;
  final void Function(Map<String, dynamic> payload) onSubmit;
  final String submitLabel;

  const CustomerForm({
    super.key,
    this.initialValues,
    this.autoValidate = false,
    required this.onSubmit,
    this.submitLabel = 'Create',
  });

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _first;
  late TextEditingController _last;
  late TextEditingController _email;
  late TextEditingController _phone;
  late TextEditingController _phoneCountry;

  @override
  void initState() {
    super.initState();
    final init = widget.initialValues ?? {};
    _first = TextEditingController(text: init['firstname'] as String? ?? '');
    _last = TextEditingController(text: init['lastname'] as String? ?? '');
    _email = TextEditingController(text: init['email'] as String? ?? '');
    _phone = TextEditingController(
      text: init['phone_number']?['number'] as String? ?? '',
    );
    _phoneCountry = TextEditingController(
      text: init['phone_number']?['country'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    _phone.dispose();
    _phoneCountry.dispose();
    super.dispose();
  }

  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid && widget.autoValidate == false) {
      setState(() {});
      return;
    }
    final payload = {
      'firstname': _first.text.trim(),
      'lastname': _last.text.trim(),
      'email': _email.text.trim().isEmpty ? null : _email.text.trim(),
      'phone_number': {
        'number': _phone.text.trim(),
        'country': _phoneCountry.text.trim().toUpperCase(),
      },
    };
    widget.onSubmit(payload);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Form(
          key: _formKey,
          autovalidateMode: widget.autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _first,
                decoration: const InputDecoration(labelText: 'First name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _last,
                decoration: const InputDecoration(labelText: 'Last name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Email (optional)',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final ok = RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(v.trim());
                  return ok ? null : 'Invalid email';
                },
              ),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      controller: _phoneCountry,
                      decoration: const InputDecoration(
                        labelText: 'Country (ISO)',
                      ),
                      validator: (v) => (v == null || v.trim().length != 2)
                          ? '2-letter ISO'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 5,
                    child: TextFormField(
                      controller: _phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.submitLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
