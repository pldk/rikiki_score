# frozen_string_literal: true

Rails.application.config.to_prepare do
  SimpleForm.setup do |config|
    # Default class for buttons
    config.button_class = 'my-2 bg-blue-500 hover:bg-blue-700 text-white font-bold text-sm py-2 px-4 rounded'

    # Define the default class of the input wrapper of the boolean input.
    config.boolean_label_class = ''

    # How the label text should be generated altogether with the required text.
    config.label_text = ->(label, required, _explicit_label) { "#{label} #{required}" }

    # Define the way to render check boxes / radio buttons with labels.
    config.boolean_style = :inline

    # You can wrap each item in a collection of radio/check boxes with a tag
    config.item_wrapper_tag = :div

    # Defines if the default input wrapper class should be included in radio
    # collection wrappers.
    config.include_default_input_wrapper_class = false

    # CSS class to add for error notification helper.
    config.error_notification_class = 'text-white px-6 py-4 border-0 rounded relative mb-4 bg-red-400'

    # Method used to tidy up errors. Specify any Rails Array method.
    # :first lists the first message for each field.
    # :to_sentence to list all errors for each field.
    config.error_method = :to_sentence

    # add validation classes to `input_field`
    config.input_field_error_class = 'border-red-500'
    config.input_field_valid_class = 'border-green-400'
    config.label_class = 'text-sm font-medium text-gray-600'

    # Vertical form wrappers (as you already have)
    config.wrappers :vertical_form, tag: 'div', class: 'mb-4' do |b|
      b.use :html5
      b.use :placeholder
      b.optional :maxlength
      b.optional :minlength
      b.optional :pattern
      b.optional :min_max
      b.optional :readonly
      b.use :label, class: 'block', error_class: 'text-red-500'
      b.use :input,
            class: 'shadow appearance-none border border-gray-300 rounded w-full py-2 px-3 bg-white focus:outline-none focus:ring-0 focus:border-blue-500 text-gray-400 leading-6 transition-colors duration-200 ease-in-out',
            error_class: 'border-red-500',
            valid_class: 'border-green-400'
      b.use :full_error, wrap_with: { tag: 'p', class: 'mt-2 text-red-500 text-xs italic' }
      b.use :hint, wrap_with: { tag: 'p', class: 'mt-2 text-grey-700 text-xs italic' }
    end

    # (garde tous tes autres wrappers comme boolean, collection, file, multi_select, range)
    config.wrappers :vertical_boolean, tag: 'div', class: 'mb-4 flex items-start', error_class: '' do |b|
      b.use :html5
      b.optional :readonly
      b.wrapper tag: 'div', class: 'flex items-center h-5' do |ba|
        ba.use :input,
               class: 'focus:ring-2 focus:ring-indigo-500:focus ring-offset-2 h-4 w-4 text-indigo-600 border-gray-300 rounded'
      end
      b.wrapper tag: 'div', class: 'ml-3 text-sm' do |bb|
        bb.use :label, class: 'block', error_class: 'text-red-500'
        bb.use :hint, wrap_with: { tag: 'p', class: 'block text-grey-700 text-xs italic' }
        bb.use :full_error, wrap_with: { tag: 'p', class: 'block text-red-500 text-xs italic' }
      end
    end

    # (idéalement, tu copies tous tes wrappers actuels comme vertical_collection, vertical_file, etc.)

    # Default wrapper
    config.default_wrapper = :vertical_form

    # Wrapper mappings
    config.wrapper_mappings = {
      boolean: :vertical_boolean,
      check_boxes: :vertical_collection,
      date: :vertical_multi_select,
      datetime: :vertical_multi_select,
      file: :vertical_file,
      radio_buttons: :vertical_collection,
      range: :vertical_range,
      time: :vertical_multi_select
    }
  end
end
