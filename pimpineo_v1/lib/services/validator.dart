
class UserValidator {

//para poder hacer la rectificaion entre las contrasenas
  String _contrasena = '';


//validacion del registro nombre

  String validateName(String value){
    if(value.isEmpty){
      return "Introduzca su nombre.";
    }
    else if(!value.contains(RegExp(r'(^[a-zA-Z ]*$)'))){
      return "El nombre no puede tener numeros.";
    }    
    return null;
  }

  String validatePassword(String value){
    if(value.isEmpty){
      return "Por favor cree su contrasena.";
    }
    else if(value.length < 6){
      return "Contrasena tiene menos de 6 caracteres.";
    }else if(!value.contains(RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{6,}$'))){ //regex que valida numeros y letras y mas de 6 caracteres
      return "Por su seguridad incluya numeros y letras.";
    }
    this._contrasena = value;
    return null;
  }

  String validateConfirmPassword(String value){
    if(value.isEmpty){
      return "Confirme su contrasena.";
    }
    else if(value != this._contrasena){
      return "Asegurese de que sus contrasenas coinciden.";
    } 
    return null;
  }

  String validatePhoneUS(String value){
    
    value = value.replaceAll('-', '').replaceAll('+', '');
    
    //make sure that this is only numbers and the length is equal to 11 
    String pattern = r'(^(?:[]9)?[0-9]{11}$)';
    RegExp expression = RegExp(pattern);
   
    if(value.isEmpty){
      return "Introduzca su numero telefonico.";
    }
    else if(value.length != 11 || !expression.hasMatch(value) || !value.startsWith('1')) {
      return "Siga el formato, ejemplo: +1-305-123-1234.";
    } 
    return null;
  }

  String validateEmail(String value){
    if(value.isEmpty){
      return "Introduzca su correo electronico.";
    }
    else if(value.contains(' ') || !value.contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))){
      return 'Introduzca una direccion de correo valida.';
    }
    return null;
  }


  //validacion log in

  String validateEmailLogIn(String value){
    if(value.isEmpty){
      return "Introduzca su correo electronico.";
    }
    else if(value.contains(' ') || !value.contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))){
      return 'Introduzca una direccion de correo valida.';
    }
    return null;
  }

  String validatePasswordLogIn(String value){
    if(value.isEmpty){
      return "Introduzca su contrasena.";
    }
    else if(value.length < 6){
      return "Contrasena tiene menos de 6 caracteres.";
    }else if(!value.contains(RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{6,}$'))){ //regex que valida numeros y letras y mas de 6 caracteres
      return "Por su seguridad incluya numeros y letras.";
    }
    this._contrasena = value;
    return null;
  }


  //validacion de agregar contactos

  String validateNombreContacto(String value){
    if(value.isEmpty){
      return "Por favor introduzca el nombre del contacto.";
    }
    else if(!value.contains(RegExp(r'(^[a-zA-Z ]*$)'))){
      return "El nombre no puede tener numeros.";
    }    
    return null;
  }
  
  String validatePhone(String value){
    if(value.length == 0){
      return 'Introduzca un numero de telefono.';
    }
    String value1 = value.replaceAll('-', '').replaceAll('+', '');
    var length;
    String pattern;

    if(value1[0] == '1'){
      length = 11;
      //make sure that this is only numbers and the length is equal to 10
      pattern = r'(^(?:[]9)?[0-9]{11}$)';
    }
    else{
      length = 10;
      //make sure that this is only numbers and the length is equal to 10
      pattern = r'(^(?:[]9)?[0-9]{10}$)';
    }

    RegExp expression = RegExp(pattern);
   
    if(value.isEmpty){
      return "Introduzca el numero de telefono del contacto.";
    }
    else if(!(value1.length == length) || (!expression.hasMatch(value1)) || !(value[0] == '+')) {
      return "(+53-5-1231234)/(+1-123-123-1234)";
    } 
    else{
      return null;
    }
    
  }

  String direccion(String value){
    if(value.isEmpty){
      return "Direccion del contacto.";
    }
    else{
      return null;
    }   
  }

  String municipio(String value){
    if(value.isEmpty){
      return "Municipio.";
    }
    else{
      return null;
    }   
  }

  String provincia(String value){
    if(value.isEmpty){
      return "Provincia.";
    }
    else{
      return null;
    }   
  }


  //validacion de los campos de las tarjetas de credito 

  String validateNombreCreditCard(String value){
    if(value.isEmpty){
      return "";
    }
    else if(!value.contains(RegExp(r'(^[a-zA-Z ]*$)'))){
      return "";
    }    
    return null;
  }

  String validateNumeroCreditCard(String value){
    //make sure that this is only numbers and the length is equal to 11
    String pattern = r'(^[0-9]+$)';
    RegExp expression = RegExp(pattern);
    String _onlyNumbers = value.replaceAll('-', '');
   
    if(value.isEmpty){
      return "";
    }
    if(_onlyNumbers[0]=='3'){
      if(_onlyNumbers.length < 15) {
        return "";
      } 
      else if (!expression.hasMatch(_onlyNumbers)){
        return "";
      }
    }
    else{
      if(_onlyNumbers.length < 16) {
        return "";
      } 
      else if (!expression.hasMatch(_onlyNumbers)){
        return "";
      }
    }
    
    return null;
  }

  String validateFechaCreditCard(String value){
    if(value.isEmpty){
      return '';
    }
    else if (value.replaceAll('/', '').length < 4){
      return '';
    }
    else if(value.replaceAll('/', '').length > 2){
      if(int.parse(value.replaceAll('/', '').substring(0,2)) > 12){
        return '';
      }
      else if(int.parse(value.replaceAll('/', '').substring(2)) < int.parse(DateTime.now().year.toString().substring(2))){
      return '';
      }
    }
    
    return null;
  }

  String validateCVVCreditCard(String value){
    
    String pattern = r'(^[0-9]+$)';
    RegExp expression = RegExp(pattern);

    if(value.length < 3){
      return "";
    }
    else if(!expression.hasMatch(value)) {
      return "";
    } 
    return null;
  }

  String validateZIPCreditCard(String value){
    String pattern = r'(^[0-9]+$)';
    RegExp expression = RegExp(pattern);

    if(value.length < 4){
      return "";
    }
    else if(!expression.hasMatch(value)) {
      return "";
    } 
    return null;
  }




}