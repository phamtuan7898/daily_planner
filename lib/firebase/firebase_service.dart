import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/model/Task_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hàm lấy danh sách công việc theo ngày
  Future<List<Task>> fetchTasksByDate(String selectedDate) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tasks')
          .where('date', isEqualTo: selectedDate)
          .get();

      if (snapshot.docs.isEmpty) {
        print("Không có công việc nào cho ngày này");
        return []; // Trả về danh sách rỗng
      }

      // Chuyển đổi các tài liệu từ Firestore thành danh sách Task
      return snapshot.docs.map((doc) {
        return Task.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Lỗi khi lấy dữ liệu: $e");
      return [];
    }
  }
}
