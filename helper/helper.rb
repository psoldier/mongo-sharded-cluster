def list_files(dir)
  Dir[ File.join(dir, '**', '*') ].reject { |p| File.directory? p }
end

def load_by_path path
  list_files(path).each do |filename|
    next if filename == '.' or filename == '..'
    #Guardo el archivo si es menor igual a 16MB
    if (File.size(filename) / 1_000_000) <= 16
      Archive.new(path_filename).save
    else
      puts "NO PROCESA: #{filename}. TAMAÑO: #{(File.size(filename) / 1_000_000)}MB"
    end
  end
end