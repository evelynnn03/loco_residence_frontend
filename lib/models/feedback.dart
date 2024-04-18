
  class Feedback {
    final String unitNo;
    final String feedbackDetails;
    final String feedbackCategory;
    final int feedbackRating;
    Feedback({
      required this.unitNo,
      required this.feedbackDetails,
      required this.feedbackCategory,
      required this.feedbackRating,
    });

    factory Feedback.fromMap(Map<String, dynamic> data) {
      return Feedback(
          unitNo: data['Unit No'],
          feedbackDetails: data['Feedback Details'] ?? '',
          feedbackCategory: data['Feedback Category'],
          feedbackRating: data['Feedback Rating']);
    }

    Map<String, dynamic> toMap() {
      return {
        'Unit No': unitNo,
        'Feedback Details': feedbackDetails,
        'Feedback Category': feedbackCategory,
        'Feedback Rating': feedbackRating,
      };
    }
  }
