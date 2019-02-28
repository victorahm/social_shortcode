module Plugins::SocialShortcode::MainHelper
  def self.included(klass)
    # klass.helper_method [:my_helper_method] rescue "" # here your methods accessible from views
  end

  # here all actions on going to active
  # you can run sql commands like this:
  # results = ActiveRecord::Base.connection.execute(query);
  # plugin: plugin model
  def social_shortcode_on_active(plugin)
  end

  # here all actions on going to inactive
  # plugin: plugin model
  def social_shortcode_on_inactive(plugin)
  end

  # here all actions to upgrade for a new version
  # plugin: plugin model
  def social_shortcode_on_upgrade(plugin)
  end

  # hook listener to add settings link below the title of current plugin (if it is installed)
  # args: {plugin (Hash), links (Array)}
  # permit to add unlimmited of links...
  def social_shortcode_on_plugin_options(args)
    args[:links] << link_to('Settings', admin_plugins_social_shortcode_settings_path)
  end

  def create_social_shortcodes
    shortcode_add "youtube",
                   lambda{ |attrs, args|
                     video = attrs['video']
                     regexp = Regexp.new('^(?:https?:\/\/)?(?:www\.)?youtube.com\/watch\?v=([a-zA-Z0-9_-]+)|youtu\.be\/([a-zA-Z0-9_-]+)')
                     md=regexp.match video
                     attributes = ''
                     attributes += "?autoplay=1" if attrs.keys.include?('autoplay') && ActiveModel::Type::Boolean.new.cast(attrs['autoplay'])

                     frame = "<iframe width='560' height='315' src='https://www.youtube.com/embed/#{md[1||2]}#{attributes}' frameborder='0' allowfullscreen></iframe>"
                     if attrs.keys.include? 'fullwidth'
                       fw = ActiveModel::Type::Boolean.new.cast attrs['fullwidth']
                       if fw
                         frame = "<div class='embed-responsive embed-responsive-16by9'>#{frame}</div>"
                       end
                     end
                     frame
                    },
                   "Insert youtube video"
  end
end
