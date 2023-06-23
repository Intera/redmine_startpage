module RedmineStartpage
  module WelcomeControllerPatch
    module PrependMethods
      def forward_to_startpage
        settings = Setting.plugin_redmine_startpage.reject {|a| a.blank?}
        return unless settings["active"]
        options = {
          :id => settings["id"],
          :project => settings["project_id"],
          :controller => settings["controller"],
          :action => settings["action"],
          settings["argname"] => settings["argvalue"]
        }
        options = options.reject {|key, value| key.blank? || value.blank?}
        redirect_to options unless options.empty?
      end
    end
    def self.install
      WelcomeController.class_eval do
        prepend PrependMethods
        before_action :forward_to_startpage, :only => :index
      end
    end
  end
end

Redmine::Plugin.register :redmine_startpage do
  name "Redmine Startpage"
  author "Txinto Vaz"
  description "Select almost any redmine sub page as start page"
  version "0.2.0"
  url "https://github.com/intera/redmine_startpage"
  settings :default => {
             "active" => false,
             "project_id"  => "",
             "controller"  => "",
             "action" => "",
             "id" => "",
             "argname" => "",
             "argvalue" => ""
           }, :partial => "settings/startpage"
  RedmineStartpage::WelcomeControllerPatch.install
end
