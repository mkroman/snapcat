module DataHelper
  extend self

  def data_for(status, type = :image)
    File.open(
      "#{SPEC_ROOT}/support/snaps/#{type}_#{status}#{file_extension(type)}",
      'rb'
    ).read
  end

  private

  def file_extension(type)
    if type == :image
      '.jpg'
    elsif type == :video
      '.mp4'
    end
  end
end
