# frozen_string_literal: true

module PredictionsHelper
  def bg_class(prediction)
    return 'bg-blue-50 dark:bg-blue-900/40' if prediction.nil?
  
    if prediction.is_star? && prediction.actual_tricks.nil?
      'bg-white dark:bg-gray-800/30' # Predicted star non joué
    else
      'bg-white dark:bg-gray-800/30' # Tout le reste reste neutre
    end
  end
  
end
