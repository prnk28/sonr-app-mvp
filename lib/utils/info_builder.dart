// Class Used to Create Strings
// Utilized in Profile_info widget

String getGreeting(String name){
  var firstname = name.split(" ");
  return "Hello, " + firstname[0] + ".";
}

