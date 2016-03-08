class DimensionsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
  	# Return if no image is given to the edit
  	return if value.queued_for_write[:original].nil?
    # I'm not sure about this:
    dimensions = Paperclip::Geometry.from_file(value.queued_for_write[:original].path)
    # But this is what you need to know:
    width = options[:width]
    height = options[:height] 

    record.errors[attribute] << "Width must be #{width}px or higher" unless dimensions.width >= width
    record.errors[attribute] << "Height must be #{height}px or higher" unless dimensions.height >= height
  end
end