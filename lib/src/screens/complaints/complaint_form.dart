import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:loco_frontend/src/provider/complaint_provider.dart';
import 'package:loco_frontend/src/widgets/buttons.dart';
import 'package:loco_frontend/src/widgets/text_field.dart';
import 'package:provider/provider.dart';
import '../../widgets/calendar.dart';
import '../../widgets/drop_down_field.dart';

class ComplaintForm extends StatefulWidget {
  const ComplaintForm({Key? key}) : super(key: key);
  static const routeName = '/complaint-form';

  @override
  State<ComplaintForm> createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _category;
  DateTime? _selectedDate;
  File? _imageFile;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Facility',
    'Payment',
    'Bookings',
    'Services',
    'Other'
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (image != null) {
      final File file = File(image.path);
      final int fileSize = await file.length();

      // Check file size (5MB limit)
      if (fileSize > 5 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image size must be less than 5MB')),
          );
        }
        return;
      }

      setState(() {
        _imageFile = file;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showCalendar(
      context,
      minDate: DateTime(2023),
      maxDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _validateForm()) {
      setState(() {
        _isSubmitting = true; // Indicate that the form is being submitted
      });

      // Simulate API call or make the actual API call
      try {
        final complaintData = {
          'title': _titleController.text,
          'category': _category,
          'date': _dateController.text,
          'description': _descriptionController.text,
          'image': _imageFile?.path,
        };

        debugPrint(complaintData.toString());

        // Call the createComplaint method and await its result
        await Provider.of<ComplaintProvider>(context, listen: false)
            .createComplaint(
          _titleController.text,
          _descriptionController.text,
          _selectedDate!,
          _imageFile?.path,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Complaint submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Reset form
        _formKey.currentState!.reset();
        setState(() {
          _titleController.clear();
          _descriptionController.clear();
          _category = null;
          _selectedDate = null;
          _dateController.clear();
          _imageFile = null;
          _isSubmitting = false; // Reset the submission state
        });
      } catch (error) {
        // Show an error message in case of failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit complaint: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          MyButton(
            text: _isSubmitting ? 'Submitting...' : 'Submit Complaint',
            onTap: () {
              if (_formKey.currentState!.validate()) {
                _submitForm();
              }
            },
          );
        });
      }
    }
  }

  bool _validateForm() {
    if (_category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return false;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double smallSizedBoxHeight(height) => height < 600 ? 20 : 30;
    double largeSizedBoxHeight(height) => height < 600 ? 30 : 40;

    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Submit Complaint',
          style: GlobalVariables.appbarStyle(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Field
              MyTextField(
                controller: _titleController,
                labelText: 'Complaint Title',
                keyboardType: TextInputType.text,
                helperText:
                    'Provide a short, descriptive title for your complaint',
                validator: (value) {
                  if (value == null || value.length < 5) {
                    return 'Title must be at least 5 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: smallSizedBoxHeight(screenHeight)),

              // Category Dropdown
              MyDropdownField(
                label: 'Category',
                helper: 'Choose the category that best fits your complaint',
                items: _categories,
                value: _category,
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue;
                  });
                },
              ),
              SizedBox(height: smallSizedBoxHeight(screenHeight)),

              // Date Picker
              MyTextField(
                controller: _dateController,
                labelText: 'Date of Incident',
                helperText: 'Select the date when the incident occurred',
                obscureText: false,
                keyboardType: TextInputType.none,

                // SHOW THE CALENDER
                onTap: () {
                  _selectDate(context);
                },

                prefixIcon: Icons.date_range,
              ),
              SizedBox(height: smallSizedBoxHeight(screenHeight)),
              // Description Field
              MyTextField(
                controller: _descriptionController,
                maxLines: 5,
                labelText: 'Description',
                keyboardType: TextInputType.text,
                helperText: 'Please describe your complaint in detail',
                validator: (value) {
                  if (value == null || value.length < 20) {
                    return 'Description must be at least 20 characters';
                  }
                  return null;
                },
                isDescriptionBox: true,
              ),
              SizedBox(height: smallSizedBoxHeight(screenHeight)),

              // Image Upload
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyButton(
                    onTap: _pickImage,
                    text: _imageFile == null ? 'Upload Image' : 'Change Image',
                    iconData: Icons.image,
                  ),
                  if (_imageFile != null) ...[
                    const SizedBox(height: 8),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Upload a picture related to your complaint (max 5MB)',
                      style: GlobalVariables.helperStyle(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: largeSizedBoxHeight(screenHeight)),

              // Submit Button
              MyButton(
                text: _isSubmitting ? 'Submitting...' : 'Submit Complaint',
                onTap: () {
                  if (!_isSubmitting) {
                    _submitForm();
                  }
                },
              ),
              SizedBox(height: smallSizedBoxHeight(screenHeight)),
            ],
          ),
        ),
      ),
    );
  }
}
