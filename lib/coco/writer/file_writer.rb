module Coco

  # Public: I write a single file.
  #
  module FileWriter

    # Public: Write a file.
    #
    # filename - String path+name of the file.
    # content  - String content to put in the file.
    #
    # Returns nothing.
    #
    def self.write(filename, content)
      File.open(filename, 'w') { |file| file.write(content) }
    end
  end
end
