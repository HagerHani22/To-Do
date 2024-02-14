class UserData{
   String ?name;
   String ?email;
   String? phone;
   String ?password;

  UserData({
 this.name,
 this.email,
 this.phone,
 this.password,
});
  UserData.fromJson(Map <String,Object?> json){
    name = json['name'].toString();
    email = json['email'].toString();
    phone = json['phone'].toString();
    password = json['password'].toString();
  }
}