import 'package:expat_info/provider/sign_in_provider.dart';
import 'package:expat_info/screens/display_info.dart';
import 'package:expat_info/screens/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class InfoInputPage extends StatefulWidget {
  const InfoInputPage({Key? key}) : super(key: key);

  @override
  State<InfoInputPage> createState() => _InfoInputPageState();
}

class _InfoInputPageState extends State<InfoInputPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController languageController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController personalStatementController =
      TextEditingController();

  final RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();

  // Additional controllers for new fields
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController profilePictureController =
      TextEditingController(); // This is used for uploading a new profile picture

  DateTime? selectedDate;
  String? selectedGender;
  String? selectedReligion;
  String? selectedLanguage;

  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  List<DropdownMenuItem<String>> buildDropdownItems(List<String> items) {
    return items
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Load existing data for editing
    loadExistingData();
  }

  void loadExistingData() async {
    final sp = context.read<SignInProvider>();
    await sp.getAdditionalUserData();
    ageController.text = sp.age ?? '';
    dobController.text = sp.dob ?? '';
    addressController.text = sp.address ?? '';
    phoneNumberController.text = sp.phoneNumber ?? '';
    personalStatementController.text = sp.personalStatement ?? '';
    genderController.text = sp.gender ?? '';
    religionController.text = sp.religion ?? '';
    languageController.text = sp.language ?? '';

    // Load existing data for name and email
    nameController.text = sp.name ?? '';
    emailController.text = sp.email ?? '';

    // Additional: Load existing profile picture URL into controller
    imageUrlController.text = sp.imageUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.cyanColor.withOpacity(.9),
      appBar: AppBar(
        backgroundColor: AppColors.mainBGColor,
        title: const Text(
          'Update Your Personal Information',
          style: TextStyle(
              color: AppColors.cyanColor, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Full Names: ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextField(
                  controller: nameController,
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Email: ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextField(
                  controller: emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Invalid email format';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Phone: ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextField(
                  controller: phoneNumberController,
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length > 11) {
                      return 'Phone number must not be more than  11 digits';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Address: ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextField(
                  controller: addressController,
                  labelText: 'Address',
                  hintText: 'Enter your address',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Age: ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextField(
                  controller: ageController,
                  labelText: 'Age',
                  hintText: 'Enter yourAge',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Age';
                    }
                    int age = int.tryParse(value) ?? 0;

                    if (age <= 0 || age > 100) {
                      return 'Age must be between 1 and 100';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Bio: ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextField(
                  controller: personalStatementController,
                  labelText: 'Personal Statement',
                  hintText: 'Tell us about You',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your personal statement';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Date of Birth: ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: TextEditingController(
                          text: selectedDate != null
                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                              : ''),
                      labelText: 'Date of Birth',
                      hintText: 'Select your date of birth',
                      validator: (value) {
                        if (selectedDate == null) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          dobController.text = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Gender: ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    // labelText: 'Gender',
                    hintText: 'Select your gender',
                  ),
                  value: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                      genderController.text = value ?? '';
                    });
                  },
                  onSaved: (value) {
                    // This is called when the form is saved
                    // You can update a controller here as well
                    genderController.text = value ?? '';
                  },
                  items: buildDropdownItems(['Male', 'Female', 'Other']),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Religion: ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    // labelText: 'Religion',
                    hintText: 'Select your religion',
                  ),
                  value: selectedReligion,
                  onChanged: (value) {
                    setState(() {
                      selectedReligion = value;
                      religionController.text = value ?? '';
                    });
                  },
                  onSaved: (value) {
                    // This is called when the form is saved
                    // You can update a controller here as well
                    religionController.text = value ?? '';
                  },
                  items: buildDropdownItems([
                    'Christianity',
                    'Islam',
                    'Hinduism',
                    'Buddhism',
                    'Other'
                  ]),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your religion';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Language: ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    hintText: 'Select your language',
                  ),
                  value: selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value;
                      languageController.text = value ?? '';
                    });
                  },
                  onSaved: (value) {
                    // This is called when the form is saved
                    // You can update a controller here as well
                    languageController.text = value ?? '';
                  },
                  items: buildDropdownItems(
                      ['English', 'Spanish', 'French', 'Chinese', 'Other']),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your language';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainBGColor,
                        // onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final sp = context.read<SignInProvider>();
                          await sp.saveAdditionalUserData(
                            name: nameController.text,
                            email: emailController.text,
                            age: ageController.text,
                            // dob: dobController.text,
                            gender: genderController.text,
                            language: languageController.text,
                            address: addressController.text,
                            phoneNumber: phoneNumberController.text,
                            religion: religionController.text,
                            personalStatement: personalStatementController.text,
                            dob: selectedDate != null
                                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                : '',
                          );

                          if (sp.hasError) {
                            // Handle errors
                            showErrorMessage(
                                sp.errorCode ?? 'An error occurred.');
                          } else {
                            Get.back(); // Close the edit page
                            showSuccessSnackbar();
                          }
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.cyanColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showSuccessSnackbar() {
    Get.snackbar(
      'Success',
      'Data saved successfully!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
