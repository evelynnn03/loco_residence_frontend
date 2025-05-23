import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:loco_frontend/src/models/similar_complaint.dart';
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
  bool _isForce = false;

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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || !_validateForm()) {
      return;
    }

    final complaintProvider =
        Provider.of<ComplaintProvider>(context, listen: false);

    try {
      final result = await complaintProvider.createComplaint(
        _titleController.text,
        _descriptionController.text,
        _category!,
        _selectedDate!,
        _imageFile,
        _isForce,
      );

      if (mounted) {
        if (result['success']) {
          //get the message from service
          final message =
              result['message'] ?? 'Complaint submitted successfully';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
            ),
          );
          complaintProvider.fetchAllComplaints();
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
        } else if (!result['success'] &&
            result['error'] == 'Similar complaints already exist') {
          final List<SimilarComplaint> similarComplaints =
              result['similarComplaints'];

          // Show a dialog with similar complaints
          showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Column(
                  children: [
                    Text('Similar Complaints'),
                    Text(
                      'Long press to know why',
                      style: TextStyle(
                          fontSize: 11, color: GlobalVariables.primaryGrey),
                    )
                  ],
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        similarComplaints.length, // Assuming you have this list
                    itemBuilder: (context, index) {
                      final complaint = similarComplaints[index];
                      return Tooltip(
                        textStyle: TextStyle(
                            fontSize: GlobalVariables.responsiveFontSize(
                                context, 11.0),
                            color: Colors.white),
                        message: similarComplaints[index].similarityReason,
                        preferBelow: true,
                        decoration: BoxDecoration(
                          color: GlobalVariables.primaryGrey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListTile(
                          title: Text(
                            complaint.title,
                            style: TextStyle(
                              fontSize: GlobalVariables.responsiveFontSize(
                                  context, 14.0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            complaint.description,
                            style: TextStyle(
                              fontSize: GlobalVariables.responsiveFontSize(
                                  context, 11.0),
                              color: GlobalVariables.primaryGrey,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 40,
                            height: 40,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CircularProgressIndicator(
                                  value: complaint
                                      .similarityScore, // Value between 0.0 and 1.0
                                  backgroundColor: Colors.grey[200],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          GlobalVariables.primaryColor),
                                ),
                                Center(
                                  child: Text(
                                    '${(complaint.similarityScore * 100).toInt()}%',
                                    style: TextStyle(
                                      fontSize:
                                          GlobalVariables.responsiveFontSize(
                                              context, 10.0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  MyButton(
                      text: 'Submit Anyway',
                      onTap: () async {
                        _isForce = true;
                        Navigator.pop(context);
                        await _submitForm();
                        _isForce = false; // Reset the force submission flag
                      }),
                  const SizedBox(height: 8),
                  MyButton(
                      text: 'Cancel',
                      onTap: () {
                        _isForce = false;
                        Navigator.pop(context);
                      }),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['error'] ?? 'Failed to submit complaint'),
              backgroundColor: Colors.red,
              duration:
                  const Duration(seconds: 5), // Give more time to read error
              action: SnackBarAction(
                label: 'Dismiss',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                textColor: Colors.white,
              ),
            ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: ${error.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              textColor: Colors.white,
            ),
          ),
        );
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
    _dateController.dispose();
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
                          child: FutureBuilder<bool>(
                            future: _imageFile!
                                .exists(), // Check if the file exists
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasData && snapshot.data!) {
                                return Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                // Show SnackBar if the image is unavailable
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Image Unavailable'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                });
                                return const Center(
                                    child: Text('Image Unavailable'));
                              }
                            },
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
