require_relative './createDirIfNeeded'
require_relative './downloadAndWrite'

def downloadIfNeeded(filename:, url:, targetDirectory:)
  targetFileName = targetDirectory + filename

  if !File.exist?(targetFileName)
    createDirIfNeeded(targetDirectory)
    downloadAndWrite(url, targetFileName)
  else
    # puts "opening #{targetFileName}"
    File.read(targetFileName)
  end
end