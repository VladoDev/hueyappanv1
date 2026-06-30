require 'xcodeproj'
require 'fileutils'

project_path = 'ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# 1. Create Configurations
# Duplicate Debug, Release, Profile to -development and -production
# For the Project
['Debug', 'Release', 'Profile'].each do |base_name|
  ['development', 'production'].each do |flavor|
    new_name = "#{base_name}-#{flavor}"
    unless project.build_configurations.map(&:name).include?(new_name)
      base_config = project.build_configurations.find { |c| c.name == base_name }
      new_config = project.new(Xcodeproj::Project::XCBuildConfiguration)
      new_config.name = new_name
      new_config.build_settings = base_config.build_settings.dup
      new_config.base_configuration_reference = base_config.base_configuration_reference
      project.build_configurations << new_config
    end
  end
end

# For the Targets (Runner)
runner_target = project.targets.find { |t| t.name == 'Runner' }
['Debug', 'Release', 'Profile'].each do |base_name|
  ['development', 'production'].each do |flavor|
    new_name = "#{base_name}-#{flavor}"
    
    config = runner_target.build_configurations.find { |c| c.name == new_name }
    if config.nil?
      base_config = runner_target.build_configurations.find { |c| c.name == base_name }
      config = project.new(Xcodeproj::Project::XCBuildConfiguration)
      config.name = new_name
      config.build_settings = base_config.build_settings.dup
      config.base_configuration_reference = base_config.base_configuration_reference
      runner_target.build_configuration_list.build_configurations << config
    end
    
    # Update Bundle Identifier and FLUTTER_TARGET
    if flavor == 'production'
      config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.vlad.hueyappan'
      config.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = 'AppIcon'
      config.build_settings['FLUTTER_TARGET'] = 'lib/main_production.dart'
    else
      config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.conventohueyapan.hueyappanv1'
      config.build_settings['FLUTTER_TARGET'] = 'lib/main_development.dart'
    end
  end
end

# 2. Add Run Script Phase for GoogleService-Info.plist
phase_name = 'Select GoogleService-Info.plist'
unless runner_target.shell_script_build_phases.find { |p| p.name == phase_name }
  phase = project.new(Xcodeproj::Project::PBXShellScriptBuildPhase)
  phase.name = phase_name
  phase.shell_script = <<-SCRIPT
if [ "${CONFIGURATION}" = "Debug-production" ] || [ "${CONFIGURATION}" = "Release-production" ] || [ "${CONFIGURATION}" = "Profile-production" ]; then
  cp "${PROJECT_DIR}/Runner/GoogleService-Info-production.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
else
  cp "${PROJECT_DIR}/Runner/GoogleService-Info.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
fi
  SCRIPT
  
  # Insert before 'Copy Bundle Resources'
  copy_resources_index = runner_target.build_phases.index { |p| p.class == Xcodeproj::Project::PBXResourcesBuildPhase }
  runner_target.build_phases.insert(copy_resources_index, phase)
end

project.save

# 3. Create Schemes
schemes_dir = File.join(project_path, 'xcshareddata', 'xcschemes')
FileUtils.mkdir_p(schemes_dir)

def create_scheme(schemes_dir, flavor)
  scheme_xml = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<Scheme LastUpgradeVersion = "1510" version = "1.3">
   <BuildAction parallelizeBuildables = "YES" buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry buildForTesting = "YES" buildForRunning = "YES" buildForProfiling = "YES" buildForArchiving = "YES" buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "97C146ED1CF9000F007C117D"
               BuildableName = "Runner.app"
               BlueprintName = "Runner"
               ReferencedContainer = "container:Runner.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction buildConfiguration = "Debug-#{flavor}" selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB" shouldUseLaunchSchemeArgsEnv = "YES">
      <Testables>
      </Testables>
   </TestAction>
   <LaunchAction buildConfiguration = "Debug-#{flavor}" selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB" launchStyle = "0" useCustomWorkingDirectory = "NO" ignoresPersistentStateOnLaunch = "NO" debugDocumentVersioning = "YES" debugServiceExtension = "internal" allowLocationSimulation = "YES">
      <BuildableProductRunnable runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "97C146ED1CF9000F007C117D"
            BuildableName = "Runner.app"
            BlueprintName = "Runner"
            ReferencedContainer = "container:Runner.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction buildConfiguration = "Profile-#{flavor}" shouldUseLaunchSchemeArgsEnv = "YES" savedToolIdentifier = "" useCustomWorkingDirectory = "NO" debugDocumentVersioning = "YES">
      <BuildableProductRunnable runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "97C146ED1CF9000F007C117D"
            BuildableName = "Runner.app"
            BlueprintName = "Runner"
            ReferencedContainer = "container:Runner.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction buildConfiguration = "Debug-#{flavor}">
   </AnalyzeAction>
   <ArchiveAction buildConfiguration = "Release-#{flavor}" revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
  XML
  File.write(File.join(schemes_dir, "#{flavor}.xcscheme"), scheme_xml)
end

create_scheme(schemes_dir, 'development')
create_scheme(schemes_dir, 'production')
puts "Xcode project updated successfully."
