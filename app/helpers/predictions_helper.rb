# frozen_string_literal: true

module PredictionsHelper
  def bg_class(prediction)
    if prediction.nil?
      'bg-blue-50 dark:bg-blue-900/40'
    elsif prediction.actual_tricks.nil?
      'bg-yellow-50 dark:bg-yellow-900/40'
    elsif prediction.is_star? && prediction.actual_tricks == prediction.predicted_tricks
      'bg-green-100 dark:bg-green-900/40'
    elsif prediction.actual_tricks == prediction.predicted_tricks
      'bg-green-100 dark:bg-green-900/40'
    elsif prediction.is_star? && prediction.actual_tricks != prediction.predicted_tricks
      'bg-red-100 dark:bg-red-900/40'
    else
      'bg-red-100 dark:bg-red-900/40'
    end
  end
end
