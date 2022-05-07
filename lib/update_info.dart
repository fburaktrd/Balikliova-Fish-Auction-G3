import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';


class Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: InformationScreen(),
          ),
        ),
      ),
      title: 'Online Fish Auction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class DeliveryOption {
  String deliveryAddress;
  int index;
  DeliveryOption({required this.deliveryAddress, required this.index});
}

class InformationScreen extends StatefulWidget {
  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final _username = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _address = TextEditingController();
  bool _valid_username = false;
  bool _valid_phone = false;
  bool _valid_password = false;
  int id = 0;

  String name = "Ayça";
  String username = "ayca_22";
  String phone = "555 666 77 88";
  List<String> addresses = ["Take-Away", "Urla", "İzmir"];
  String password = "oldPassword";
  bool visibleAddAddress = true;
  bool visibleDeleteAddress = true;
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
    return Form(
      child: Column(
        children: [
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Name: ${getName()}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 23.0,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    updateNameAlertDialog(context);
                  });
                },
                icon: Icon(Icons.edit),
                label: Text("Edit"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Username: ${getUsername()}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 23.0,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    updateUsernameAlertDialog(context);
                  });
                },
                icon: Icon(Icons.edit),
                label: Text("Edit"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Phone: ${getPhoneNumber()}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 23.0,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    updatePhoneAlertDialog(context);
                  });
                },
                icon: Icon(Icons.edit),
                label: Text("Edit"),
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
                icon: Icon(Icons.lock_rounded),
                label: Text("Update Password"),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Delivery Options",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 1.8,
                  fontSize: 20.0,
                ),
              ),
              Visibility(
                visible: visibleAddAddress,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      addNewAddressAlertDialog(context);
                    });
                  },
                  icon: Icon(Icons.add_location_alt),
                  label: Text("Add new address"),
                ),
              ),
            ],
          ),
          Container(
            child: Column(
              children: getDeliveryOptions()
                  .map(
                    (data) => RadioListTile(
                      title: Text("${data.deliveryAddress}"),
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
              icon: Icon(Icons.delete_rounded),
              label: Text("Delete chosen option"),
            ),
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
              icon: Icon(Icons.save),
              label: Text("Save chosen as delivery option"),
            ),
          ),
        ],
      ),
    );
  }

  String getName() {
    return this.name;
  }

  void setName(String text) {
    this.name = text;
  }

  String getUsername() {
    return this.username;
  }

  void setUsername(String text) {
    this.username = text;
  }

  String getPhoneNumber() {
    return this.phone;
  }

  void setPhoneNumber(String text) {
    this.phone = text;
  }

  void setPassword(String newPassword) {
    this.password = newPassword;
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
      DeliveryOption del_opt =
          new DeliveryOption(deliveryAddress: addresses[i], index: i);
      deliveryOptions.add(del_opt);
    }
    return deliveryOptions;
  }

  void updatePhoneAlertDialog(BuildContext context) {
    PhoneNumber TRphoneCode = PhoneNumber(isoCode: 'TR');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Update Phone"),
          content: InternationalPhoneNumberInput(
            inputDecoration: InputDecoration(
              hintText: "5xx xxx xx xx",
            ),
            onInputChanged: (PhoneNumber number) {},
            onInputValidated: (bool value) {},
            maxLength: 13,
            autoValidateMode: AutovalidateMode.disabled,
            initialValue: TRphoneCode,
            formatInput: true,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            inputBorder: OutlineInputBorder(),
            onSaved: (PhoneNumber number) {},
            textFieldController: _phone,
          ),
          actions: <Widget>[
            new ElevatedButton.icon(
              icon: Icon(Icons.cancel),
              label: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Save"),
              onPressed: () {
                if (checkPhone(context, _phone.text)) {
                  setPhoneNumber(_phone.text);
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
          title: new Text("Update Password"),
          content: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
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
            new ElevatedButton.icon(
              icon: Icon(Icons.cancel),
              label: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Save"),
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
          title: new Text("Update Userame"),
          content: TextFormField(
            decoration: InputDecoration(
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
            new ElevatedButton.icon(
              icon: Icon(Icons.cancel),
              label: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Save"),
              onPressed: () {
                if (checkUsername(context, _username.text)) {
                  setUsername(_username.text);
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
          title: new Text("Update Name"),
          content: TextFormField(
            maxLength: 15,
            decoration: InputDecoration(
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
            new ElevatedButton.icon(
              icon: Icon(Icons.cancel),
              label: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Save"),
              onPressed: () {
                if (checkName(context, _name.text)) {
                  setName(_name.text);
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
    //Adres range ini kontrol eder.
    return true; //Adres range içerisindeyse true, değilse false return eder.
  }

  void addNewAddress(String newAddress) {
    this.addresses.add(newAddress);
  }

  void displayFailMessage(BuildContext context, String message) {
    displayMessage("Fail", context, message);
  }

  void deleteChosenOption(int index) {
    this.addresses.removeAt(index);
  }

  void setChosenAddress(int index) {
    //replace 2 adresses. index 0 daki adres chosen (aktif) seçilmiş delivery option olarak kabul edilir.
    String tempAddress = this.addresses[0];
    this.addresses[0] = this.addresses[index];
    this.addresses[index] = tempAddress;
  }

  void displaySuccessMessage(BuildContext context, String message) {
    displayMessage("Success", context, message);
  }

  void displayMessage(String title, BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("${title}"),
          content: new Text("${message}."),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("OK"),
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
          title: new Text("New Address"),
          content: TextFormField(
            maxLines: 8, //or null
            decoration: InputDecoration(
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
            new ElevatedButton.icon(
              icon: Icon(Icons.cancel),
              label: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Save"),
              onPressed: () {
                if (checkAddress(context, _address.text)) {
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
