module Previewer
  class Engine < ::Rails::Engine
    isolate_namespace Previewer

    # initializer "action_mailer.set_configs" do |app|
    #   app.config.action_mailer.show_previews = true
    # end

    config.after_initialize do
      config.action_mailer.show_previews = true
      # config.action_mailer.preview_path = File.expand_path('../../')
    end
  end
end
