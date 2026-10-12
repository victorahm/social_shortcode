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
    register_youtube_shortcode
  end

  private

  def register_youtube_shortcode
    shortcode_add "youtube",
                   lambda{ |attrs, args|
                     video_id = youtube_video_id(attrs['video'])
                     if video_id.nil?
                       url = attrs['video'].to_s.strip
                       return args[:shortcode].to_s if url.blank? || !url.match?(%r{\Ahttps?://}i)
                       safe_url = ERB::Util.html_escape(url)
                       return "<a href='#{safe_url}'>#{safe_url}</a>"
                     end

                     query = 'rel=0&amp;playsinline=1'
                     query += '&amp;autoplay=1' if ActiveModel::Type::Boolean.new.cast(attrs['autoplay'])
                     src = "https://www.youtube.com/embed/#{video_id}?#{query}"

                     fullwidth = ActiveModel::Type::Boolean.new.cast(attrs['fullwidth'])
                     fill = fullwidth ? " style='position:absolute;top:0;left:0;width:100%;height:100%;border:0'" : ''
                     frame = "<iframe width='560' height='315' src='#{src}' title='YouTube video player' " \
                             "frameborder='0' loading='lazy' " \
                             "allow='accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share' " \
                             "referrerpolicy='strict-origin-when-cross-origin' allowfullscreen#{fill}></iframe>"

                     if fullwidth
                       frame = "<div class='embed-responsive embed-responsive-16by9' " \
                               "style='position:relative;width:100%;aspect-ratio:16/9;overflow:hidden'>#{frame}</div>"
                     end
                     frame
                    },
                   "Insert youtube video"
  end

  def youtube_video_id(value)
    raw = value.to_s.strip

    patterns = [
      %r{\A(?:https?:)?//?(?:www\.|m\.)?youtube\.com/(?:watch\?(?:[^#]*&)?v=|embed/|shorts/|live/|v/)(?<id>[A-Za-z0-9_-]{11})(?:[&#?/].*)?\z}i,
      %r{\A(?:https?:)?//?(?:www\.)?youtu\.be/(?<id>[A-Za-z0-9_-]{11})(?:[?&#].*)?\z}i
    ]
    patterns.each do |pattern|
      md = pattern.match(raw)
      return md[:id] if md
    end

    raw.match?(/\A[A-Za-z0-9_-]{11}\z/) ? raw : nil
  end
end
