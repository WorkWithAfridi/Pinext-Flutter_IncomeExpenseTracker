extension InputValidation on String {
  dynamic isCorrectPhoneNumber() {
    if (isEmpty) {
      return null;
    }
    if (RegExp(r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
        .hasMatch(this)) {
      return "Enter valid number";
    }
    return null;
  }

  dynamic isCorrectEmailAddress() {
    if (isEmpty) {
      return "Email required";
    }
    if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\"
            r".[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*")
        .hasMatch(this)) {
      return "Enter valid email";
    }
    return null;
  }

  dynamic isNotEmptryPassword() {
    if (isEmpty) {
      return "Password cannot be empty!";
    }
    return null;
  }

  dynamic isCorrectName() {
    if (isEmpty) {
      return "Username required";
    }
    if (!RegExp(r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
        .hasMatch(this)) {
      return "Enter valid username";
    }
    return null;
  }
}
