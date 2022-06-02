import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:myapp/models/database.dart';

import 'navBar.dart';

class DeliveryOption {
  String deliveryAddress;
  int index;
  DeliveryOption({required this.deliveryAddress, required this.index});
}

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final _username = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _address = TextEditingController();
  final bool _valid_username = false;
  final bool _valid_phone = false;
  final bool _valid_password = false;
  bool _isLoading = true;
  int id = 0;

  String name = "";
  String username = "";
  String phone = "";
  List<String> addresses = ["MORDOĞAN", "BALIKLIOVA", "URLA", "ILDIR"];
  String password = "";
  String role_node = "";

  bool visibleAddAddress = true;
  bool visibleDeleteAddress = true;
  var user_info;
  var role;
  @override
  void initState() {
    Database()
        .ref
        .child("Roles")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((res) {
      Database()
          .ref
          .child(res.value == "CUSTOMER" ? "Customer" : "Cooperative_Head")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((userRes) {
        user_info = userRes.value;
        print(FirebaseAuth.instance.currentUser!.uid);
        name = user_info["name"];
        phone = user_info["phoneNumber"];
        username = user_info["username"];

        if (user_info["role"] == "CUSTOMER") {
          role_node = "Customer";
        } else if (user_info["role"] == "COOP_HEAD") {
          role_node = "Cooperative_Head";
        }

        setState(() {
          _isLoading = false;
          print(user_info);
        });
      });
    });

    //ROLES: CUSTOMER, COOP_HEAD, COOP_CREW, COOP_CREW_MEMBER
    //role -> Customer -> CUSTOMER

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (getDeliveryOptions().length > 4) {
      visibleAddAddress = false;
    } else {
      visibleAddAddress = true;
    }

    if (getDeliveryOptions().isEmpty) {
      visibleDeleteAddress = false;
    } else {
      visibleDeleteAddress = true;
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Change Information")),
        resizeToAvoidBottomInset: false,
        drawer: const navBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: (_isLoading == true
                ? const CircularProgressIndicator(color: Colors.blue)
                : Form(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Name: ${getName()}",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 23.0,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                              height: 1,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  updateNameAlertDialog(context);
                                });
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text("Edit"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Username: ${getUsername()}",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 23.0,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                              height: 1,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  updateUsernameAlertDialog(context);
                                });
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text("Edit"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Phone: ${getPhoneNumber()}",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 23.0,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                              height: 1,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  updatePhoneAlertDialog(context);
                                });
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text("Edit"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  updatePasswordAlertDialog(context);
                                });
                              },
                              icon: const Icon(Icons.lock_rounded),
                              label: const Text("Update Password"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Delivery Options",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.8,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                              height: 1,
                            ),
                            Visibility(
                              visible: visibleAddAddress,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    addNewAddressAlertDialog(context);
                                  });
                                },
                                icon: const Icon(Icons.add_location_alt),
                                label: const Text("Add new address"),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: getDeliveryOptions()
                                .map(
                                  (data) => RadioListTile(
                                    title: Text(data.deliveryAddress),
                                    groupValue: id,
                                    value: data.index,
                                    onChanged: (val) {
                                      setState(
                                        () {
                                          id = data.index;
                                        },
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Visibility(
                          visible: visibleDeleteAddress,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                deleteChosenOption(id);
                              });
                            },
                            icon: const Icon(Icons.delete_rounded),
                            label: const Text("Delete chosen option"),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                          height: 5,
                        ),
                        Visibility(
                          visible: visibleDeleteAddress,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                setChosenAddress(id);
                                id = 0;
                              });
                            },
                            icon: const Icon(Icons.save),
                            label: const Text("Save chosen as delivery option"),
                          ),
                        ),
                      ],
                    ),
                  )),
          ),
        ),
      ),
    );
  }

  String getName() {
    return name;
  }

  void setName(String text) {
    name = text;
  }

  String getUsername() {
    return username;
  }

  void setUsername(String text) {
    username = text;
  }

  String getPhoneNumber() {
    return phone;
  }

  void setPhoneNumber(String text) {
    phone = text;
  }

  void setPassword(String newPassword) {
    password = newPassword;
  }

  bool checkUsernameExists(String newUsername) {
    //username sistemde daha önceden var mı kontrol eder.
    return false; //returns false if user doesn't exist
  }

  bool checkPhoneExists(String newPhone) {
    //phone sistemde daha önceden var mı kontrol eder.
    return false; //returns false if user doesn't exist
  }

  List<String> getAddresses() {
    return addresses;
  }

  List<DeliveryOption> getDeliveryOptions() {
    List<String> addresses = getAddresses();
    List<DeliveryOption> deliveryOptions = [];
    for (int i = 0; i < addresses.length; i++) {
      DeliveryOption delOpt =
          DeliveryOption(deliveryAddress: addresses[i], index: i);
      deliveryOptions.add(delOpt);
    }
    return deliveryOptions;
  }

  void setInfoDb(String roleNode, String infoLabel, String value) {
    Database()
        .ref
        .child(roleNode)
        .child(user_info["uid"])
        .child(infoLabel)
        .set(value);
  }

  void updatePhoneAlertDialog(BuildContext context) {
    PhoneNumber TRphoneCode = PhoneNumber(isoCode: 'TR');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Phone"),
          content: InternationalPhoneNumberInput(
            inputDecoration: const InputDecoration(
              hintText: "5xx xxx xx xx",
            ),
            onInputChanged: (PhoneNumber number) {},
            onInputValidated: (bool value) {},
            maxLength: 13,
            autoValidateMode: AutovalidateMode.disabled,
            initialValue: TRphoneCode,
            formatInput: true,
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            inputBorder: const OutlineInputBorder(),
            onSaved: (PhoneNumber number) {},
            textFieldController: _phone,
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save"),
              onPressed: () {
                if (checkPhone(context, _phone.text)) {
                  phone = _phone.text;
                  setInfoDb(role_node, "phoneNumber", phone);
                  Navigator.of(context).pop();
                  displaySuccessMessage(
                      context, "Phone number succesfully updated.");
                }
              },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  void updatePasswordAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Password"),
          content: TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              labelText: "New Password",
              hintText: "Enter new password here..",
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              //errorText: _valid_password ? 'Password is .' : null,
            ),
            controller: _password,
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save"),
              onPressed: () {
                if (checkPassword(context, _password.text)) {
                  setPassword(_password.text);
                  Navigator.of(context).pop();
                  displaySuccessMessage(
                      context, "Password succesfully updated.");
                }
              },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  void updateUsernameAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Userame"),
          content: TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.drive_file_rename_outline),
              labelText: "Username",
              hintText: "Enter username here..",
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            controller: _username,
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save"),
              onPressed: () {
                if (checkUsername(context, _username.text)) {
                  username = _username.text;
                  setInfoDb(role_node, "username", username);
                  Navigator.of(context).pop();
                  displaySuccessMessage(
                      context, "Username successfully updated.");
                }
              },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  void updateNameAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Name"),
          content: TextFormField(
            maxLength: 15,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person),
              labelText: "Name",
              hintText: "Enter name here..",
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            controller: _name,
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save"),
              onPressed: () {
                if (checkName(context, _name.text)) {
                  name = _name.text;

                  //Setting user name to db
                  setInfoDb(role_node, "name", name);
                  Navigator.of(context).pop();
                  displaySuccessMessage(context, "Name successfully updated.");
                }
              },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  bool checkName(BuildContext context, String newName) {
    if (newName.length > 3) {
      return true;
    } else {
      displayFailMessage(context, "Name too short.");
      return false;
    }
  }

  bool checkUsername(BuildContext context, String newUsername) {
    if (newUsername.length < 4) {
      displayFailMessage(context, "Username too short.");
      return false;
    } else if (checkUsernameExists(newUsername)) {
      displayFailMessage(context, "Username already exists.");
      return false;
    } else {
      return true;
    }
  }

  bool checkPhone(BuildContext context, String newPhone) {
    if (newPhone.length != 13) {
      displayFailMessage(context, "Phone number is invalid.");
      return false;
    } else if (checkPhoneExists(newPhone)) {
      displayFailMessage(context, "Phone number is already in usage.");
      return false;
    } else {
      if (newPhone.startsWith("5")) {
        return true;
      } else {
        displayFailMessage(context, "Phone should start with 5.");
        return false;
      }
    }
  }

  bool checkPassword(BuildContext context, String newPassword) {
    if (newPassword.length > 6) {
      return true;
    } else {
      displayFailMessage(context, "Password too short.");
      return false;
    }
  }

  bool checkAddress(BuildContext context, String newAddress) {
    if (newAddress.length > 5) {
      if (checkAddressRange(newAddress)) {
        return true;
      } else {
        displayFailMessage(context, "Address out of range.");
        return false;
      }
    } else {
      displayFailMessage(context, "Address explanation too short.");
      return false;
    }
  }

  bool checkAddressRange(String newAddress) {
    if (!(addresses.contains(newAddress))) {
      return false;
    }
    return true; //Adres range içerisindeyse true, değilse false return eder.
  }

  void addNewAddress(String newAddress) {
    addresses.add(newAddress);
  }

  void displayFailMessage(BuildContext context, String message) {
    displayMessage("Fail", context, message);
  }

  void deleteChosenOption(int index) {
    addresses.removeAt(index);
  }

  void setChosenAddress(int index) {
    //replace 2 adresses. index 0 daki adres chosen (aktif) seçilmiş delivery option olarak kabul edilir.
    String tempAddress = addresses[0];
    addresses[0] = addresses[index];
    addresses[index] = tempAddress;
  }

  void displaySuccessMessage(BuildContext context, String message) {
    displayMessage("Success", context, message);
  }

  void displayMessage(String title, BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text("$message."),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addNewAddressAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("New Address"),
          content: TextFormField(
            maxLines: 8, //or null
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.location_pin),
              labelText: "Address",
              hintText: "Enter address here..",
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            controller: _address,
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save"),
              onPressed: () {
                if (checkAddress(context, _address.text)) {
                  //Think about it... Burak
                  addNewAddress(_address.text);
                  Navigator.of(context).pop();
                  displaySuccessMessage(context, "Address added successfully.");
                }
              },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {});
    });
  }
}
