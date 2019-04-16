require 'redmine'

Redmine::Plugin.register :redmine_status_report do
  name 'Redmine Status Report plugin'
  author 'Artur Safin <mr@artsaf.in>'
  description 'Shows status statistics for an issue'
  version '1.0.0'
  url 'https://github.com/artsafin/redmine_status_report'
  author_url 'https://github.com/artsafin'
end

require_dependency File.dirname(__FILE__) + '/lib/redmine_status_report.rb'
