$:.unshift File.join(File.dirname(__FILE__))
require 'tmpdir'
require 'picasa'

module PwUp

  class PwUp
    # FILE_TYPES = %w[.rar .zip]
    COMMANDS = {
      ".rar" => "unrar x %<file>s %<target_dir>s",
      ".zip" => "unzip %<file>s -d %<target_dir>s",
    }
    IMAGE_TYPES = %w[.jpg .png .gif]

    def initialize(email, password)
      @email = email
      @password = password
      @picasa = Picasa::Picasa.new
      p @picasa.login(email, password)
    end

    def process!(files, album_name)
      # create a tmp folder
      target_dir = Dir.mktmpdir('pwup', '/tmp')
      # these are the compressed ones
      files.each do |file|
        if not process? file
          puts "Skipping, can't process file #{file}"
          next
        end
        # unpack file there
        puts "Unpacking #{file}"
        unpack file, target_dir
      end
      # filter only the images
      images = Dir.foreach(target_dir).to_a.select {|f| IMAGE_TYPES.include? File.extname(f).downcase}
      puts "Found #{images.length} images"
      # exit if no images where found
      return if images.length == 0
      puts "Uploading to #{album_name}"
      # create album
      album = @picasa.create_album(:title => album_name,
      :summary => album_name,
      :location => "", :keywords => "")
      puts "album name = #{album.name}"
      images.each do |image|
        file_name = File.join(target_dir, image)
        puts "Reading #{file_name}"
        image_data = open(file_name, "rb").read
        photo = @picasa.post_photo(image_data, :album => album.name,
        :summary => file_name, :title => file_name)
        puts "photo #{file_name} uploaded to #{album.name}"
      end
    end

    private
    def process?(file)
      ext = File.extname(file)
      COMMANDS.include? ext.downcase and File.exists? file
    end

    def unpack(file, target_dir)
      ext = File.extname(file)
      command = COMMANDS[ext] % {:file=>file, :target_dir=>target_dir}
      system(command)
    end
  end
end
