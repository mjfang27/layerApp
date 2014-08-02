require 'rubygems'
require 'bundler'
require 'date'
Bundler.setup
require 'xctasks/test_task'

XCTasks::TestTask.new do |t|
  t.workspace = 'LayerSample.xcworkspace'
  t.schemes_dir = 'Tests/Schemes'
  t.runner = :xcpretty
  t.output_log = 'xcodebuild.log'
  t.settings["LAYER_TEST_HOST"] = (ENV['LAYER_TEST_HOST'] || 'localhost')
  t.subtasks = { app: 'LayerSampleTests' }
end
