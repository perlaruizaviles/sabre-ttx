require 'yaml'

module TTx
    class RoomCodes 
        attr_reader :room_code_map

        def initialize
            @room_code_map = YAML.load_file(File.dirname(__FILE__) + '/../../assets/room-codes.yml')    
        end 

        def room_code_to_meaning(code)
            result = code.downcase.split('').each_with_index.map { |e, i| @room_code_map[i][e] }
            result.delete_if { |e| e.nil? || e.empty? }.join(', ')
        end 

    end 
end