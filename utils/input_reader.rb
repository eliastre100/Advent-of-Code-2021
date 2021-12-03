class InputReader
  class << self
    def read_commands(file)
      File.readlines(file).map do |line|
        command = line.split(' ')
        {
          command: command[0],
          argument: command[1].to_i
        }
      end
    end

    def read_numbers(file)
      File.readlines(file).map(&:to_i)
    end

    def read_string(file)
      File.readlines(file)
    end
  end
end
