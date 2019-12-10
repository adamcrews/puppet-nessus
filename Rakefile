require 'jsonlint/rake_task'
require 'metadata-json-lint/rake_task'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet_blacksmith/rake_tasks'
require 'puppet-strings/tasks'
require 'puppetlabs_spec_helper/rake_tasks'
require 'rubocop/rake_task'
require 'semantic_puppet'
require 'git'

GREEN="\033[32m".freeze
RESET="\033[0m".freeze
TAG_PATTERN="v%s".freeze

exclude_paths = [
  'bundle/**/*',
  'pkg/**/*',
  'vendor/**/*',
  'spec/**/*'
]

JsonLint::RakeTask.new do |t|
  t.paths = %w[**/*.json]
end

Blacksmith::RakeTask.new do |t|
  t.tag_pattern = TAG_PATTERN # Use a custom pattern with git tag. %s is replaced with the version number.
end

MetadataJsonLint.options.strict_license = false

PuppetLint.configuration.disable_80chars
PuppetLint.configuration.disable_140chars
PuppetLint.configuration.disable_autoloader_layout
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.relative = true

PuppetSyntax.check_hiera_keys = true
PuppetSyntax.exclude_paths = exclude_paths

Rake::Task[:lint].clear

namespace :validate do
  desc 'Run all module validation tests.'
  task all: [
    'jsonlint',
    'lint',
    'metadata_lint',
    'syntax:hiera',
    'syntax:manifests',
    'syntax:templates',
    'rubocop',
    'spec',
    'strings:generate'
  ]
end

desc 'all in 1'
task release: [
  'validate:all',
  'release:tagging',
  'release:propagate'
]

namespace :release do
  desc 'Module propagatie to the forge'
  task :propagate do
    begin
      Rake::Task['module:push'].invoke
    rescue StandardError => e
      raise("Module release upload mislukt: #{e.message}")
    end
  end
  desc 'Module tagging adhv metadata.json, local tag and push remote tag'
  task :tagging do
    begin
      Rake::Task['module:clean'].invoke
      Rake::Task['module:tag'].invoke
      git = Git.open(File.dirname(__FILE__), log: Logger.new(STDOUT))
      
      version = TAG_PATTERN % [Blacksmith::Modulefile.new.version]
      
      git.push(git.remote, "refs/tags/#{version}")
    rescue StandardError => e
      raise("Module release tagging mislukt: #{e.message}")
    end
  end
end
