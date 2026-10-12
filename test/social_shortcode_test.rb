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

  test 'engine declares the instagram shortcode to the boot-time ShortcodeRegistry' do
    assert_includes CamaleonCms::ShortcodeRegistry.names, 'instagram'
  end

  test 'engine declares the x shortcode to the boot-time ShortcodeRegistry' do
    assert_includes CamaleonCms::ShortcodeRegistry.names, 'x'
  end

  test 'engine declares the tiktok shortcode to the boot-time ShortcodeRegistry' do
    assert_includes CamaleonCms::ShortcodeRegistry.names, 'tiktok'
  end

  test 'renders a tiktok blockquote embed for a video url' do
    html = render('[tiktok url="https://www.tiktok.com/@scout2015/video/6718335390845095173"]')

    assert_includes html, "class='tiktok-embed'"
    assert_includes html, "data-video-id='6718335390845095173'"
    assert_includes html, "cite='https://www.tiktok.com/@scout2015/video/6718335390845095173'"
    assert_includes html, 'https://www.tiktok.com/embed.js'
    assert_includes html, '<a href='
  end

  test 'renders a tiktok blockquote embed for a video url without www' do
    html = render('[tiktok url="https://tiktok.com/@scout2015/video/6718335390845095173"]')

    assert_includes html, "data-video-id='6718335390845095173'"
  end

  test 'non tiktok http url falls back to a plain link without raising' do
    html = render('[tiktok url="https://example.com/not-tiktok"]')

    assert_equal "<a href='https://example.com/not-tiktok'>https://example.com/not-tiktok</a>", html
  end

  test 'unresolvable tiktok short link falls back to a plain link without raising' do
    html = render('[tiktok url="https://vm.tiktok.com/ZMabcdef/"]')

    assert_equal "<a href='https://vm.tiktok.com/ZMabcdef/'>https://vm.tiktok.com/ZMabcdef/</a>", html
  end

  test 'non http tiktok url falls back to the original shortcode without raising' do
    assert_equal '[tiktok url="javascript:alert(1)"]',
                 render('[tiktok url="javascript:alert(1)"]')
  end

  test 'missing tiktok url attribute keeps the original shortcode without raising' do
    assert_equal '[tiktok]', render('[tiktok]')
  end

  test 'renders an x blockquote embed for an x.com status url' do
    html = render('[x url="https://x.com/jack/status/20"]')

    assert_includes html, "class='twitter-tweet'"
    assert_includes html, "<a href='https://x.com/jack/status/20'>"
    assert_includes html, 'https://platform.twitter.com/widgets.js'
    assert_includes html, "data-theme='light'"
  end

  test 'renders an x blockquote embed for a twitter.com status url' do
    html = render('[x url="https://twitter.com/jack/status/20?s=20"]')

    assert_includes html, "class='twitter-tweet'"
    assert_includes html, "<a href='https://twitter.com/jack/status/20?s=20'>"
    assert_includes html, 'https://platform.twitter.com/widgets.js'
  end

  test 'x theme dark sets the blockquote data-theme' do
    html = render('[x url="https://x.com/jack/status/20" theme="dark"]')

    assert_includes html, "data-theme='dark'"
    refute_includes html, "data-theme='light'"
  end

  test 'non x http url falls back to a plain link without raising' do
    html = render('[x url="https://example.com/not-a-tweet"]')

    assert_equal "<a href='https://example.com/not-a-tweet'>https://example.com/not-a-tweet</a>", html
  end

  test 'x profile url without a status id falls back to a plain link' do
    html = render('[x url="https://x.com/jack"]')

    assert_equal "<a href='https://x.com/jack'>https://x.com/jack</a>", html
  end

  test 'non http x url falls back to the original shortcode without raising' do
    assert_equal '[x url="javascript:alert(1)"]',
                 render('[x url="javascript:alert(1)"]')
  end

  test 'missing x url attribute keeps the original shortcode without raising' do
    assert_equal '[x]', render('[x]')
  end

  test 'renders an instagram blockquote embed for a post url' do
    html = render('[instagram url="https://www.instagram.com/p/C8XYZabc123/"]')

    assert_includes html, "class='instagram-media'"
    assert_includes html, "data-instgrm-permalink='https://www.instagram.com/p/C8XYZabc123/'"
    assert_includes html, 'https://www.instagram.com/embed.js'
    assert_includes html, 'View this post on Instagram'
  end

  test 'renders an instagram blockquote embed for a reel url' do
    html = render('[instagram url="https://www.instagram.com/reel/C8XYZabc123/"]')

    assert_includes html, "class='instagram-media'"
    assert_includes html, "data-instgrm-permalink='https://www.instagram.com/reel/C8XYZabc123/'"
  end

  test 'renders an instagram blockquote embed for a tv url' do
    html = render('[instagram url="https://instagram.com/tv/C8XYZabc123"]')

    assert_includes html, "data-instgrm-permalink='https://instagram.com/tv/C8XYZabc123'"
  end

  test 'non instagram http url falls back to a plain link without raising' do
    html = render('[instagram url="https://example.com/not-instagram"]')

    assert_equal "<a href='https://example.com/not-instagram'>https://example.com/not-instagram</a>", html
  end

  test 'instagram url without a media path falls back to a plain link' do
    html = render('[instagram url="https://www.instagram.com/some_user/"]')

    assert_equal "<a href='https://www.instagram.com/some_user/'>https://www.instagram.com/some_user/</a>", html
  end

  test 'non http instagram url falls back to the original shortcode without raising' do
    assert_equal '[instagram url="javascript:alert(1)"]',
                 render('[instagram url="javascript:alert(1)"]')
  end

  test 'missing instagram url attribute keeps the original shortcode without raising' do
    assert_equal '[instagram]', render('[instagram]')
  end

  test 'renders an iframe for a full youtube watch url' do
    html = render('[youtube video="https://www.youtube.com/watch?v=dQw4w9WgXcQ"]')

    assert_includes html, "src='https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0&amp;playsinline=1'"
    assert_includes html, 'allowfullscreen'
    assert_includes html, "title='YouTube video player'"
  end

  test 'renders an iframe for a watch url without www' do
    html = render('[youtube video="https://youtube.com/watch?v=dQw4w9WgXcQ"]')

    assert_includes html, "src='https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0&amp;playsinline=1'"
  end

  test 'renders an iframe for a youtu.be short url' do
    html = render('[youtube video="https://youtu.be/dQw4w9WgXcQ"]')

    assert_includes html, "src='https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0&amp;playsinline=1'"
  end

  test 'renders an iframe for a youtu.be short url with query params' do
    html = render('[youtube video="https://youtu.be/dQw4w9WgXcQ?t=42"]')

    assert_includes html, "src='https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0&amp;playsinline=1'"
  end

  test 'renders an iframe for a bare video id' do
    html = render('[youtube video="dQw4w9WgXcQ"]')

    assert_includes html, "src='https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0&amp;playsinline=1'"
  end

  test 'renders an iframe for a shorts url' do
    html = render('[youtube video="https://www.youtube.com/shorts/dQw4w9WgXcQ"]')

    assert_includes html, "src='https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0&amp;playsinline=1'"
  end

  test 'renders an iframe for a watch url with extra params' do
    html = render('[youtube video="https://www.youtube.com/watch?feature=share&v=dQw4w9WgXcQ&list=PL123"]')

    assert_includes html, "src='https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0&amp;playsinline=1'"
  end

  test 'embed url carries the current documentation parameters' do
    html = render('[youtube video="https://www.youtube.com/watch?v=dQw4w9WgXcQ"]')

    assert_includes html, 'rel=0'
    assert_includes html, 'playsinline=1'
    assert_includes html, 'loading=\'lazy\''
  end

  test 'autoplay adds the autoplay query param' do
    html = render('[youtube video="https://www.youtube.com/watch?v=dQw4w9WgXcQ" autoplay="true"]')

    assert_includes html,
                    "src='https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0&amp;playsinline=1&amp;autoplay=1'"
  end

  test 'autoplay false does not add the autoplay query param' do
    html = render('[youtube video="https://www.youtube.com/watch?v=dQw4w9WgXcQ" autoplay="false"]')

    refute_includes html, 'autoplay=1'
  end

  test 'fullwidth wraps the iframe in a responsive container' do
    html = render('[youtube video="https://www.youtube.com/watch?v=dQw4w9WgXcQ" fullwidth="true"]')

    assert_includes html, "class='embed-responsive embed-responsive-16by9'"
    assert_includes html, 'aspect-ratio:16/9'
    assert_includes html, 'width:100%'
    assert_includes html, "src='https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0&amp;playsinline=1'"
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
