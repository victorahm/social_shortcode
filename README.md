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
| `{youtube}` | ✅ Available | Embeds a YouTube video (full URL, `youtu.be` link or video ID). |
| `{instagram}` | 🔜 Planned | Embeds an Instagram post. |
| `{x}` | 🔜 Planned | Embeds an X (Twitter) post/tweet. |
| `{tiktok}` | 🔜 Planned | Embeds a TikTok video. |
| `{facebook}` | 🔜 Planned | Embeds a Facebook post or reel. |

### YouTube

```
{youtube video="https://www.youtube.com/watch?v=dQw4w9WgXcQ"}
{youtube video="https://youtu.be/dQw4w9WgXcQ" fullwidth="true"}
{youtube video="dQw4w9WgXcQ" autoplay="true"}
```

| Attribute | Default | Description |
|-----------|---------|-------------|
| `video` | — | **Required.** Full YouTube URL, `youtu.be` URL or bare video ID. |
| `fullwidth` | `false` | When `true`, wraps the embed in a responsive 16:9 container. |
| `autoplay` | `false` | When `true`, adds `autoplay=1` to the embed URL. |

### Coming soon

These shortcodes are planned and tracked as issues:

```
{instagram url="https://www.instagram.com/p/XXXXXXXXXXX/"}
{x url="https://x.com/user/status/1234567890"}
{tiktok url="https://www.tiktok.com/@user/video/1234567890"}
{facebook url="https://www.facebook.com/user/posts/1234567890"}
```

## Requirements

- Ruby + Rails (as required by CamaleonCMS)
- [CamaleonCMS](https://github.com/owen2345/camaleon-cms) `~> 2.0`

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
plugin loads.

Example:

```html
<p>Watch this video:</p>
{youtube video="https://youtu.be/dQw4w9WgXcQ" fullwidth="true"}
```

## Development

The repo ships with a dummy Rails application under `test/dummy` for local
development and tests.

```bash
bundle install
rake test          # run the Minitest suite
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

- Update the plugin to the latest CamaleonCMS version
- Update the YouTube shortcode to follow YouTube's current embed documentation
- Add Instagram, X (Twitter), TikTok and Facebook shortcodes

## Contributing

1. Fork the repository and create a feature branch.
2. Add or update tests for your change.
3. Run `rake test` and make sure everything passes.
4. Open a pull request describing the change and the issue it closes.

## License

The gem is available as open source under the terms of the
[MIT License](MIT-LICENSE).
