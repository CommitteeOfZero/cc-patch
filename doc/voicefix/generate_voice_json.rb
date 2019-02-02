require 'json'

c0data_entry = 19
jppc_entry = 0
envita_entry = 0

mapping = {}

envita_additions = File.read("envita_additions.txt").each_line.map(&:chomp)

File.read("envita_filenames.txt").each_line.map(&:chomp).each do |file|
    if envita_additions.include? file
        mapping[envita_entry] = c0data_entry
        c0data_entry += 1
    else
        mapping[envita_entry] = [5, jppc_entry]
        jppc_entry += 1
    end
    envita_entry += 1
end

voice_json = { "fileRedirection" => { "voice" => mapping } }.to_json

File.write("voice.json", voice_json)