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
    register_instagram_shortcode
    register_x_shortcode
    register_tiktok_shortcode
    register_facebook_shortcode
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

  def register_instagram_shortcode
    shortcode_add "instagram",
                   lambda{ |attrs, args|
                     url = attrs['url'].to_s.strip
                     unless instagram_media_url?(url)
                       return args[:shortcode].to_s if url.blank? || !url.match?(%r{\Ahttps?://}i)
                       safe_url = ERB::Util.html_escape(url)
                       return "<a href='#{safe_url}'>#{safe_url}</a>"
                     end

                     safe_url = ERB::Util.html_escape(url)
                     "<blockquote class='instagram-media' data-instgrm-permalink='#{safe_url}' " \
                     "data-instgrm-version='14' " \
                     "style='background:#FFF;border:0;border-radius:3px;" \
                     "box-shadow:0 0 1px 0 rgba(0,0,0,0.5),0 1px 10px 0 rgba(0,0,0,0.15);" \
                     "margin:1px;max-width:540px;min-width:326px;padding:0;width:99.375%'>" \
                     "<a href='#{safe_url}'>View this post on Instagram</a></blockquote>" \
                     "<script async src='https://www.instagram.com/embed.js' charset='utf-8'></script>"
                    },
                   "Insert instagram post"
  end

  def register_x_shortcode
    shortcode_add "x",
                   lambda{ |attrs, args|
                     url = attrs['url'].to_s.strip
                     unless x_status_url?(url)
                       return args[:shortcode].to_s if url.blank? || !url.match?(%r{\Ahttps?://}i)
                       safe_url = ERB::Util.html_escape(url)
                       return "<a href='#{safe_url}'>#{safe_url}</a>"
                     end

                     safe_url = ERB::Util.html_escape(url)
                     theme = attrs['theme'].to_s.casecmp('dark').zero? ? 'dark' : 'light'
                     "<blockquote class='twitter-tweet' data-theme='#{theme}'>" \
                     "<a href='#{safe_url}'>View this post on X</a></blockquote>" \
                     "<script async src='https://platform.twitter.com/widgets.js' charset='utf-8'></script>"
                    },
                   "Insert X (Twitter) post"
  end

  def register_tiktok_shortcode
    shortcode_add "tiktok",
                   lambda{ |attrs, args|
                     url = attrs['url'].to_s.strip
                     video_id = tiktok_video_id(url)
                     if video_id.nil?
                       return args[:shortcode].to_s if url.blank? || !url.match?(%r{\Ahttps?://}i)
                       safe_url = ERB::Util.html_escape(url)
                       return "<a href='#{safe_url}'>#{safe_url}</a>"
                     end

                     safe_url = ERB::Util.html_escape(url)
                     "<blockquote class='tiktok-embed' cite='#{safe_url}' data-video-id='#{video_id}' " \
                     "data-embed-from='oembed' style='max-width:605px;min-width:325px'>" \
                     "<section><a href='#{safe_url}'>Watch this video on TikTok</a></section></blockquote>" \
                     "<script async src='https://www.tiktok.com/embed.js'></script>"
                    },
                   "Insert TikTok video"
  end

  def register_facebook_shortcode
    shortcode_add "facebook",
                   lambda{ |attrs, args|
                     url = attrs['url'].to_s.strip
                     unless facebook_share_url?(url)
                       return args[:shortcode].to_s if url.blank? || !url.match?(%r{\Ahttps?://}i)
                       safe_url = ERB::Util.html_escape(url)
                       return "<a href='#{safe_url}'>#{safe_url}</a>"
                     end

                     href = ERB::Util.url_encode(url)
                     allow = "allow='autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share'"
                     if facebook_video_url?(url)
                       ratio = url.match?(%r{/reel/}i) ? '9/16' : '16/9'
                       src = "https://www.facebook.com/plugins/video.php?href=#{href}&amp;show_text=false&amp;width=560"
                       "<iframe width='560' height='315' src='#{src}' " \
                       "style='border:none;overflow:hidden;width:560px;max-width:100%;height:auto;aspect-ratio:#{ratio}' " \
                       "frameborder='0' scrolling='no' loading='lazy' #{allow} allowfullscreen></iframe>"
                     else
                       src = "https://www.facebook.com/plugins/post.php?href=#{href}&amp;show_text=true&amp;width=500"
                       "<iframe width='500' height='700' src='#{src}' " \
                       "style='border:none;overflow:hidden;width:500px;max-width:100%' " \
                       "frameborder='0' scrolling='no' loading='lazy' #{allow} allowfullscreen></iframe>"
                     end
                    },
                   "Insert Facebook post or reel"
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

  def instagram_media_url?(value)
    value.match?(%r{\A(?:https?:)?//?(?:www\.)?instagram\.com/(?:p|reel|tv)/[A-Za-z0-9_-]+(?:[/?#].*)?\z}i)
  end

  def x_status_url?(value)
    value.match?(%r{\A(?:https?:)?//?(?:www\.|mobile\.)?(?:x|twitter)\.com/[^/]+/status/\d+(?:\?.*)?\z}i)
  end

  def tiktok_video_id(value)
    md = value.match(%r{\A(?:https?:)?//?(?:www\.|m\.)?tiktok\.com/@[^/]+/video/(?<id>\d+)(?:[/?#].*)?\z}i)
    md && md[:id]
  end

  def facebook_share_url?(value)
    md = facebook_url_parts(value)
    return false unless md

    segments = md[:path].split('/').reject(&:empty?)
    return true if segments.size >= 2

    md[:query].to_s.match?(/(?:\A|&)(?:story_fbid|fbid|v)=/)
  end

  def facebook_video_url?(value)
    md = facebook_url_parts(value)
    return false unless md

    return true if "/#{md[:path]}".match?(%r{/(?:reel|videos?|watch|live|v)/}i)
    md[:query].to_s.match?(/(?:\A|&)v=/)
  end

  def facebook_url_parts(value)
    value.match(%r{\A(?:https?:)?//?(?:www\.|m\.|web\.)?facebook\.com/(?<path>[^?#]*)(?:\?(?<query>[^#]*))?}i)
  end
end
