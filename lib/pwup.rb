require 'pathname'
require 'tmpdir'

require 'picasa'

module PwUp

  class PwUp
    # FILE_TYPES = %w[.rar .zip]
    COMMANDS = {
      ".rar" => "unrar x -ep \"%<file>s\" %<target_dir>s",
      ".zip" => "unzip -j \"%<file>s\" -d %<target_dir>s",
    }
    IMAGE_TYPES = %w[*.jpg *.png *.gif]

    def initialize(email, password)
      @email = email
      @password = password
      @picasa = Picasa::Picasa.new
      p @picasa.login(email, password)
    end

    def process!(files, album_name)
      # create a tmp folder
      target_dir = Dir.mktmpdir('pwup', '/tmp')
      # these are the compressed ones or directories
      unless files.respond_to? :each
        files = [files]
      end
      files.each do |file|
        unless process? file
          puts "Skipping, can't process file #{file}"
          next
        end
        # unpack file there
        puts "Unpacking #{file}"
        unpack file, target_dir
      end
      # filter only the images
      p1 = Pathname.new target_dir
      images = Dir.glob(IMAGE_TYPES.map {|i| p1 + "**" + i} ,File::FNM_CASEFOLD)
      puts "Found #{images.length} images"
      # exit if no images where found
      return if images.length == 0
      puts "Uploading to #{album_name}"
      # create album
      album = @picasa.create_album(
        title: album_name,
        summary: album_name,
        location: "",
        keywords: "",
        )
      puts "album name = #{album.name}"
      images.each_with_index do |image, index|
        file_name = image
        image_data = open(file_name, "rb").read
        @picasa.post_photo(
          image_data,
          album: album.name,
          summary: file_name,
          title: file_name
          )
        puts "photo #{file_name} uploaded to #{album.name} - #{index+1} of #{images.length}"
      end
      return album
    end

    private
    def process?(file)
      ext = File.extname(file)
      COMMANDS.include? ext.downcase and File.exists? file or File.directory? file
    end

    def unpack(file, target_dir)
      # if it's a dir, copy all content to the target_dir
      if File.directory? file
        p1 = Pathname.new file
        images = Dir.glob(IMAGE_TYPES.map {|i| p1 + "**" + i} ,File::FNM_CASEFOLD)
        FileUtils.cp(images, target_dir)
      else
        ext = File.extname(file)
        command = COMMANDS[ext] % {:file=>file, :target_dir=>target_dir}
        system(command)
      end
    end
  end
end
