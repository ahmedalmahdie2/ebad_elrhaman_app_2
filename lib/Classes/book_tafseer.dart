import 'package:quranandsunnahapp/Screens/tafseer_screen.dart';

class TafseerBook 
{
  int id;
  String bookName;
  int index;
  TafseerBook({this.id,this.bookName,this.index});
  factory TafseerBook.fromJson(Map<String,dynamic> json,int index)
  {
    return TafseerBook(
      index: index,
      id:json["id"],
      bookName:json["book_name"]
    );
  }
}