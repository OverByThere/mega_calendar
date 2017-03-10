require 'issues_controller_patch.rb'
require 'users_controller_patch.rb'
require 'vpim'

Redmine::Plugin.register :mega_calendar do
  name 'Mega Calendar plugin'
  author 'Andreas Treubert'
  description 'Better calendar for redmine'
  version '1.4.0'
  url 'https://github.com/berti92/mega_calendar'
  author_url 'https://github.com/berti92'
  requires_redmine :version_or_higher => '3.0.1'
  menu(:top_menu, :calendar, { :controller => 'calendar', :action => 'index' }, :caption => :calendar, :if => Proc.new {(!Setting.plugin_mega_calendar['allowed_users'].blank? && Setting.plugin_mega_calendar['allowed_users'].include?(User.current.id.to_s) ? true : false)})
  menu(:top_menu, :holidays, { :controller => 'holidays', :action => 'index' }, :caption => :holidays, :if => Proc.new {(!Setting.plugin_mega_calendar['allowed_users'].blank? && Setting.plugin_mega_calendar['allowed_users'].include?(User.current.id.to_s) ? true : false)})
  menu(:top_menu, :board, { :controller => 'agile_boards', :action => 'index', :project_id => nil}, :caption => "Agile Board")
  menu(:top_menu, :issue, { :controller => 'issues', :action => 'new', :project_id => nil, :id => nil, :'issue[project_id]' => '3', 'issue[tracker_id]' => '3', :'issue[start_date]' => '', :'issue[description]' => 'Device:


URL (if applicable):


What happened:


What you expected to happen:


'}, :caption => "New Issue")
menu(:top_menu, :knowledgebase,  { :controller => 'wiki', :action => 'show', :project_id => 'dans-tasklist'}, :caption => "Knowledgebase")
  Rails.configuration.to_prepare do
    IssuesController.send(:include, IssuesControllerPatch)
    UsersController.send(:include, UsersControllerPatch)
  end
  settings :default => {'default_holiday_color' => 'D59235', 'default_event_color' => '4F90FF', 'sub_path' => '/', 'week_start' => '1', 'allowed_users' => User.where(["users.login IS NOT NULL AND users.login <> ''"]).collect {|x| x.id.to_s}}, :partial => 'settings/mega_calendar_settings'
end
