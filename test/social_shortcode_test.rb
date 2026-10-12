require 'test_helper'

class SocialShortcodeTest < ActiveSupport::TestCase
  # Minimal host mirroring how CamaleonCMS mixes its shortcode helper with a
  # plugin's helpers to register and render shortcodes (see
  # CamaleonCms::CamaleonController and CamaleonCms::HooksHelper).
  class ShortcodeHost
    include CamaleonCms::ShortCodeHelper
    include Plugins::SocialShortcode::MainHelper
  end

  setup do
    CurrentRequest.reset
    @host = ShortcodeHost.new
    @host.shortcodes_init
    @host.create_social_shortcodes
  end

  test 'gemspec plugin is discovered by PluginRoutes in gem mode' do
    info = PluginRoutes.plugin_info('social_shortcode')

    assert info.present?, 'expected PluginRoutes to discover the social_shortcode gem plugin'
    assert info['gem_mode']
    assert_equal ['Plugins::SocialShortcode::MainHelper'], info['helpers']
    assert_equal ['create_social_shortcodes'], info['hooks']['app_before_load']
    assert_equal ['social_shortcode_on_active'], info['hooks']['on_active']
    assert_equal ['social_shortcode_on_inactive'], info['hooks']['on_inactive']
  end

  test 'engine declares the youtube shortcode to the boot-time ShortcodeRegistry' do
    assert_includes CamaleonCms::ShortcodeRegistry.names, 'youtube'
  end

  test 'renders an iframe for a full youtube watch url' do
    html = render('[youtube video="https://www.youtube.com/watch?v=dQw4w9WgXcQ"]')

    assert_includes html, "src='https://www.youtube.com/embed/dQw4w9WgXcQ'"
    assert_includes html, 'allowfullscreen'
  end

  test 'renders an iframe for a watch url without www' do
    html = render('[youtube video="https://youtube.com/watch?v=dQw4w9WgXcQ"]')

    assert_includes html, "src='https://www.youtube.com/embed/dQw4w9WgXcQ'"
  end

  test 'autoplay adds the autoplay query param' do
    html = render('[youtube video="https://www.youtube.com/watch?v=dQw4w9WgXcQ" autoplay="true"]')

    assert_includes html, "src='https://www.youtube.com/embed/dQw4w9WgXcQ?autoplay=1'"
  end

  test 'autoplay false does not add the autoplay query param' do
    html = render('[youtube video="https://www.youtube.com/watch?v=dQw4w9WgXcQ" autoplay="false"]')

    refute_includes html, 'autoplay'
  end

  test 'fullwidth wraps the iframe in a responsive container' do
    html = render('[youtube video="https://www.youtube.com/watch?v=dQw4w9WgXcQ" fullwidth="true"]')

    assert_includes html, "class='embed-responsive embed-responsive-16by9'"
    assert_includes html, "src='https://www.youtube.com/embed/dQw4w9WgXcQ'"
  end

  test 'unparseable http url falls back to a plain link without raising' do
    html = render('[youtube video="https://example.com/not-youtube"]')

    assert_equal "<a href='https://example.com/not-youtube'>https://example.com/not-youtube</a>", html
  end

  test 'non http url falls back to the original shortcode without raising' do
    assert_equal '[youtube video="javascript:alert(1)"]',
                 render('[youtube video="javascript:alert(1)"]')
    assert_equal '[youtube video="not a url"]',
                 render('[youtube video="not a url"]')
  end

  test 'missing video attribute keeps the original shortcode without raising' do
    assert_equal '[youtube]', render('[youtube]')
  end

  private

  def render(content)
    @host.do_shortcode(content)
  end
end
