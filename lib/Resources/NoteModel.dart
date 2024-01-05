class Note{
   final int? id;
   String title;
   String content;
   String date;
   String time;
  Note(
   {this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.time
});
  factory Note.fromJson(Map<String,dynamic> json){
    return Note(
      id : json['id'],
      title : json['title'],
      content : json['content'],
      date : json['date'],
      time : json['time'],);
  }
  Map<String,dynamic> toJson(){
    var data = <String,dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}