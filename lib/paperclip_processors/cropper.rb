module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      if crop_command
        crop_command + super.join(' ').sub(/ -crop \S+/, '').split(' ')
      else
        super
      end
    end

    def crop_command
      target = @attachment.instance
      if target.cropping?
        # ratio = target.image_geometry(:original).width / target.image_geometry(:large).width
        ratio = target.get_crop_ratio
        x = target.crop_x.to_i * ratio
        y = target.crop_y.to_i * ratio
        w = target.crop_w.to_i * ratio
        h = target.crop_h.to_i * ratio
        # " -crop '#{target.crop_w}x#{target.crop_h}+#{target.crop_x}+#{target.crop_y}' "
        ["-crop", "#{w}x#{h}+#{x}+#{y}"]
      end
    end
  end
end
