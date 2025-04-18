import 'package:get/get.dart';
import 'package:doctor_vedio/ex/ex_hint.dart';
import '../../../../api/student_api.dart';

class PsychologyLogic extends GetxController {
  // 状态变量
  final RxBool isLoading = false.obs;
  final RxBool isCompleted = false.obs;
  final RxBool isAllCompleted = false.obs;
  final Rx<Map<String, dynamic>?> currentQuestion = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    loadNextQuestion();
  }

  // 加载下一个问题
  Future<void> loadNextQuestion() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await StudentApi.questionPull(params: {
        "current_id": currentQuestion.value?['id']?.toString() ?? "",
      });

      isLoading.value = false;
      if (response["questions"] != null && response["questions"].isNotEmpty) {
        currentQuestion.value = response["questions"];
      } else {
        isCompleted.value = true;
      }
      if (response["complete_count"] != null && response["complete_count"] >= 2) {
        isAllCompleted.value = true;
      }
    } catch (e) {
      isLoading.value = false;
      "服务出了点问题".toHint();
    }
  }

  // 将 ABC 转换为 123
  int _convertAnswerToNumber(String answer) {
    switch (answer.toUpperCase()) {
      case 'A':
        return 1;
      case 'B':
        return 2;
      case 'C':
        return 3;
      default:
        return 1;
    }
  }

  // 提交答案
  Future<void> submitAnswer(String answer) async {
    if (isLoading.value || currentQuestion.value == null) return;

    if (isAllCompleted.value) {
      "您已回答完两轮答题，无需再测试".toHint();
      return;
    }

    try {
      await StudentApi.submit({
        "question_id": currentQuestion.value!['id'],
        "answer": _convertAnswerToNumber(answer),  // 使用转换后的数字
      });

      // 加载下一题
      loadNextQuestion();
    } catch (e) {
      "服务出了点小问题".toHint();
    }
  }

  // 重置测试
  void resetTest() {
    isCompleted.value = false;
    currentQuestion.value = null;
    loadNextQuestion();
  }
}