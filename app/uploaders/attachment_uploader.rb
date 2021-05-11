class AttachmentUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :fog
  else 
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  	"uploads/#{model.class.to_s.underscore}/#{model.id}"
	 #storage 
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb, if: :image? do
     process resize_to_fit: [100, 100]
  end
=begin
	 convert-이미지 인코딩 형식을 지정된 형식으로 변경합니다. jpg
resize_to_limit-원래 종횡비를 유지하면서 지정된 크기에 맞게 이미지 크기를 조정합니다. 지정된 크기보다 큰 경우에만 이미지 크기를 조정합니다. 결과 이미지는 작은 치수에 지정된 것보다 짧거나 좁을 수 있지만 지정된 값보다 크지는 않습니다.
resize_to_fit-원래 종횡비를 유지하면서 지정된 크기에 맞게 이미지 크기를 조정합니다. 이미지는 작은 치수에 지정된 것보다 짧거나 좁을 수 있지만 지정된 값보다 크지는 않습니다.
resize_to_fill-원본 이미지의 가로 세로 비율을 유지하면서 지정된 크기에 맞게 이미지 크기를 조정합니다. 필요한 경우 더 큰 크기로 이미지를 자릅니다. 선택적으로 "중력"을 지정할 수 있습니다 (예 : "Center"또는 "NorthEast").
resize_and_pad-원래 종횡비를 유지하면서 지정된 크기에 맞게 이미지 크기를 조정합니다. 필요한 경우 나머지 영역을 지정된 색상으로 채 웁니다. 기본값은 투명 (gif 및 png의 경우, jpeg의 경우 흰색)입니다. 선택적으로, 위와 같이 "중력"이 지정 될 수 있습니다.
=end
  

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  #def extension_whitelist
  #   %w(jpg jpeg gif png)
  #end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
	
  protected
  
  def image?( _file )
	 _file.content_type.include? 'image' 
  end

end
