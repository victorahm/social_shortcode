module SocialShortcode
  class Engine < ::Rails::Engine
    # Declare the shortcode names to CamaleonCMS' boot-time registry (>= 2.9.4)
    # so its save-time content gate recognizes shortcodes written into posts
    # without a frontend request. Rendering is still wired per request through
    # the "app_before_load" hook in the plugin manifest.
    initializer "social_shortcode.register_shortcodes" do
      CamaleonCms::ShortcodeRegistry.register("youtube")
      CamaleonCms::ShortcodeRegistry.register("instagram")
    end
  end
end
