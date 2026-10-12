# CamaleonCMS Social Shortcodes

A [CamaleonCMS](https://github.com/owen2345/camaleon-cms) plugin that provides a set of
shortcodes for embedding multimedia content from social networks — YouTube, Instagram,
Facebook, X (Twitter) and TikTok — directly inside Camaleon pages and posts.

Write a shortcode in the editor, save, and the plugin renders the corresponding
responsive embed in the frontend. No copy/paste of raw iframe HTML, no broken markup.

- **Repository:** https://github.com/victorahm/social_shortcode
- **License:** MIT

## Shortcodes

| Shortcode | Status | Description |
|-----------|--------|-------------|
| `[youtube]` | ✅ Available | Embeds a YouTube video (full URL, `youtu.be` link or video ID). |
| `[instagram]` | ✅ Available | Embeds an Instagram post, reel or video. |
| `[x]` | ✅ Available | Embeds an X (Twitter) post/tweet. |
| `[tiktok]` | ✅ Available | Embeds a TikTok video. |
| `[facebook]` | 🔜 Planned | Embeds a Facebook post or reel. |

### YouTube

```
[youtube video="https://www.youtube.com/watch?v=dQw4w9WgXcQ"]
[youtube video="https://youtu.be/dQw4w9WgXcQ" fullwidth="true"]
[youtube video="https://www.youtube.com/shorts/dQw4w9WgXcQ"]
[youtube video="dQw4w9WgXcQ" autoplay="true"]
```

The video renders in YouTube's current
[`https://www.youtube.com/embed/VIDEO_ID`](https://developers.google.com/youtube/player_parameters)
player format with the `rel=0` and `playsinline=1` parameters (and `autoplay=1`
when requested).

| Attribute | Default | Description |
|-----------|---------|-------------|
| `video` | — | **Required.** Full YouTube URL (`watch`, `shorts`, `embed`), `youtu.be` URL or bare 11-character video ID. |
| `fullwidth` | `false` | When `true`, wraps the embed in a responsive 16:9 container (`aspect-ratio`, 100% width). |
| `autoplay` | `false` | When `true`, adds `autoplay=1` to the embed URL. |

### Instagram

```
[instagram url="https://www.instagram.com/p/C8XYZabc123/"]
[instagram url="https://www.instagram.com/reel/C8XYZabc123/"]
```

The post renders with Instagram's official embed (blockquote + `embed.js`). Posts,
reels and IGTV videos (`/p/`, `/reel/`, `/tv/` URLs) are supported.

| Attribute | Default | Description |
|-----------|---------|-------------|
| `url` | — | **Required.** Instagram post, reel or TV URL. Any other URL falls back to a plain link. |

### X (Twitter)

```
[x url="https://x.com/jack/status/20"]
[x url="https://twitter.com/jack/status/20" theme="dark"]
```

The tweet renders with X's official embed (blockquote `twitter-tweet` +
`widgets.js`). Both `x.com` and `twitter.com` status URLs are accepted.

| Attribute | Default | Description |
|-----------|---------|-------------|
| `url` | — | **Required.** X/Twitter status URL (`…/user/status/123456`). Any other URL falls back to a plain link. |
| `theme` | `light` | Set to `dark` to render the embed with the dark theme. |

### TikTok

```
[tiktok url="https://www.tiktok.com/@scout2015/video/6718335390845095173"]
```

The video renders with the official TikTok embed markup (blockquote
`tiktok-embed` + `embed.js`) — the same HTML TikTok's oEmbed endpoint returns,
emitted directly so no network request happens at render time. Short links
(`vm.tiktok.com/…`) cannot be resolved server-side and fall back to a plain
link.

| Attribute | Default | Description |
|-----------|---------|-------------|
| `url` | — | **Required.** TikTok video URL (`…/@user/video/123456`). Any other URL falls back to a plain link. |

### Coming soon

This shortcode is planned and tracked as an issue:

```
[facebook url="https://www.facebook.com/user/posts/1234567890"]
```

## Requirements

- Ruby `>= 3.2`
- [CamaleonCMS](https://github.com/owen2345/camaleon-cms) `~> 2.9.4` (tested with Rails 7.1 – 8.1)

CamaleonCMS 2.9.x parses several of its own JSON configs in a comment-tolerant
way that only works on the `json` 2.x line. If your bundle resolves `json` 3,
pin it in your application's Gemfile:

```ruby
gem 'json', '< 3'
```

If Bundler then complains that a newer `json` was "already activated" during
boot, activate the pin before Bundler in `config/boot.rb`:

```ruby
gem 'json', '< 3'
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
```

## Installation

Add the plugin to your application's `Gemfile`:

```ruby
gem 'social_shortcode'
```

Then run:

```bash
bundle install
```

Start the server, log in to the CamaleonCMS admin panel, go to **Plugins**, find
**Social Shortcodes** and activate it. You can then use the shortcodes in any page
or post.

To use the git version instead of a released gem:

```ruby
gem 'social_shortcode', git: 'https://github.com/victorahm/social_shortcode.git'
```

## Usage

Insert a shortcode anywhere in the content of a page or post (the classic editor and
the HTML editor both work). On save/render the shortcode is replaced by the embed
markup. Shortcodes are registered through CamaleonCMS' `shortcode_add` API when the
plugin loads, and their names are declared to CamaleonCMS' boot-time
`ShortcodeRegistry` so the CMS recognizes them at save time.

Example:

```html
<p>Watch this video:</p>
[youtube video="https://youtu.be/dQw4w9WgXcQ" fullwidth="true"]
```

> **Note for editors:** since CamaleonCMS 2.9.4, saving content that contains a
> registered shortcode requires the `content_shortcodes` manager permission (or an
> administrator account). Non-admin authors without that permission are refused
> when saving a post whose content includes a shortcode.

## Development

The repo ships with a minimal dummy Rails application under `test/dummy` for local
development and tests (CamaleonCMS 2.9.x on Rails 8.1).

```bash
bundle install
rake test          # run the Minitest suite against the dummy app
bin/smoke_test     # install the plugin into a fresh CamaleonCMS app and render a shortcode
```

Plugin layout:

```
app/
  controllers/plugins/social_shortcode/   # admin + front controllers
  helpers/plugins/social_shortcode/       # hooks and shortcode registration
  views/plugins/social_shortcode/         # plugin admin/front views
config/
  camaleon_plugin.json                    # plugin manifest (title, hooks, helpers)
  routes.rb                               # plugin routes (admin + front)
lib/
  social_shortcode/engine.rb              # Rails engine
```

See [AGENTS.md](AGENTS.md) for guidance aimed at AI agents working on this codebase.

## Roadmap

Track progress and report problems in the project's issue tracker:
https://redmine.obsidianasystems.com/projects/social-shortcodes

- Add the Facebook shortcode

## Contributing

1. Fork the repository and create a feature branch.
2. Add or update tests for your change.
3. Run `rake test` and make sure everything passes.
4. Open a pull request describing the change and the issue it closes.

## License

The gem is available as open source under the terms of the
[MIT License](MIT-LICENSE).
