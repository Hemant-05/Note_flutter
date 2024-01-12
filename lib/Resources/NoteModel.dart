class Note{
   final int? id;
   String title;
   String content;
   String date;
   String time;
   int imp;
  Note(
   {this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.time,
    required this.imp,
});
  factory Note.fromJson(Map<String,dynamic> json){
    return Note(
      id : json['id'],
      title : json['title'],
      content : json['content'],
      date : json['date'],
      time : json['time'],
      imp: json['imp']?? 0,
    );
  }
  Map<String,dynamic> toJson(){
    var data = <String,dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['date'] = date;
    data['time'] = time;
    data['imp'] = imp;
    return data;
  }
}