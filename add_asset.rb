require 'xcodeproj'

project_path = 'ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

# Check if file already exists in main group
file_path = 'Runner/siren.wav'
group = project.main_group.find_subpath('Runner', false)
file_ref = group.find_file_by_path('siren.wav')

unless file_ref
  file_ref = group.new_file('siren.wav')
  # Add to resources build phase
  resources_build_phase = target.resources_build_phase
  resources_build_phase.add_file_reference(file_ref, true)
  project.save
  puts "Added siren.wav to project"
else
  puts "siren.wav already in project"
end
