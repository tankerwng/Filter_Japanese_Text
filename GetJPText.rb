# encoding:  UTF-8

class GetJpText
 
 @@file_type = %w[.js .html .php] 

 def initialize(path, result_path)
 @path = path
 @result_path = result_path 
 end

 def check_jp_text_exist(s)
   #puts s
   return false if s.nil?
   begin
     temp = /[ぁ-んァ-ヴ一-龠亜-煕]/u =~ s
     return true if !temp.nil?
     rescue ArgumentError
     end  
     return false
 end
 
 def check_comment_line(s)
    return true if s.nil?
    begin
    temp = /.*([\/\/|\/*|\/*]).+/u =~ s
    return false if temp.nil?
    rescue ArgumentError
    return false  
    end
    return true
 end

 def write2File(num, path, line_str)
    file = File.new(@result_path,"a")
    file.puts "#{num} \t #{path} \t #{line_str}"
    file.close
 end


 def readFileLine(path)
   File.open(path) do |file|
    num = 1
    file.each_line do |line|
    line.force_encoding("UTF-8")
    begin
    temp_line = line.strip
    rescue ArgumentError
    temp_line = nil 
    end
     if !check_comment_line(temp_line)
     write2File(num, path, temp_line)  if check_jp_text_exist(temp_line)
     end 
     num = num+1
    end
   end
 end

 def exec
  file_name_array = Array.new
  get_as_file_list(file_name_array,@path)
  file_name_array = file_name_array.each{|x| puts x}
  file_name_array.each {|path| readFileLine(path) }
 end

 def get_as_file_list(file_name_array,path)
  if File.directory?(path)
    dir = Dir.new(path)
    dir.each do |p|   
      if p!="." && p!=".." && p!= ".svn"  
      if File.directory?("#{path}\\#{p}")
          get_as_file_list(file_name_array, "#{path}\\#{p}")
        else
          file_name_array.push("#{path}\\#{p}") if @@file_type.include?(File.extname("#{path}\\#{p}"))  
        end
       end 
    end
  else
   file_name_array.push(path) if @@file_type.include?(File.extname(path))     
  end
    return  file_name_array
 end

end


g = GetJpText.new("D:\\proj\\korea_majimon\\trunk\\v4.4\\server", "D:\\proj\\korea_majimon\\trunk\\v4.4\\server\\result.txt")
g.exec