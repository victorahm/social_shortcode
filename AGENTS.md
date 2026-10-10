# AGENTS.md

Guidance for AI agents (and humans) working on the **CamaleonCMS Social Shortcodes**
plugin.

## What this project is

A [CamaleonCMS](https://github.com/owen2345/camaleon-cms) plugin (Rails engine) that
registers shortcodes — `{youtube}`, `{instagram}`, `{x}`, `{tiktok}`, `{facebook}` —
so users can embed social network multimedia content inside Camaleon pages/posts.

- Repo: https://github.com/victorahm/social_shortcode
- Issue tracker: https://redmine.obsidianasystems.com/projects/social-shortcodes

## Ground rules

- **Read before you change.** The codebase is small; read the file you are editing in
  full first.
- **Match the existing style.** This is a scaffolded CamaleonCMS plugin: 2-space
  indentation, Ruby/Rails conventions, no new gems without asking.
- **No drive-by refactors.** Keep the diff scoped to the task (or the ticket).
- **Do not commit or push** unless the user explicitly asks for it.
- Keep `social_shortcode.gemspec`'s `camaleon_cms` dependency accurate if plugin API
  requirements change.

## Repository layout

```
app/
  controllers/plugins/social_shortcode/
    admin_controller.rb     # CamaleonCms::Apps::PluginsAdminController subclass
    front_controller.rb     # CamaleonCms::Apps::PluginsFrontController subclass
  helpers/plugins/social_shortcode/
    main_helper.rb          # hooks + shortcode registration (the core of the plugin)
  views/plugins/social_shortcode/
    admin/                  # index + settings views
    front/
config/
  camaleon_plugin.json      # plugin manifest: title, key, helpers, hooks
  routes.rb                 # plugin routes (note: the draw block is duplicated)
  initializers/custom_models.rb
lib/
  social_shortcode.rb       # requires the engine
  social_shortcode/engine.rb
  social_shortcode/version.rb
test/
  dummy/                    # Rails dummy app used by the test suite
  *_test.rb                 # Minitest
social_shortcode.gemspec
Gemfile / Rakefile
```

## How shortcodes work here

1. `config/camaleon_plugin.json` declares the manifest: the helper module
   (`Plugins::SocialShortcode::MainHelper`) and the hooks, including
   `"app_before_load": ["create_social_shortcodes"]`.
2. `app/helpers/plugins/social_shortcode/main_helper.rb` implements
   `create_social_shortcodes`, which calls CamaleonCMS' `shortcode_add` once per
   shortcode:

   ```ruby
   shortcode_add "youtube",
                 lambda { |attrs, args|
                   # attrs: hash of attributes written inside the shortcode
                   # args:  rendering context provided by CamaleonCMS
                   "…html…"
                 },
                 "Insert youtube video"
   ```

3. The lambda returns the HTML string that replaces `{shortcode attr="value"}` in the
   rendered content.

**To add a new shortcode**, add another `shortcode_add` call inside
`create_social_shortcodes` (one function per network keeps it readable) and document it
in `README.md`. Use `ActiveModel::Type::Boolean.new.cast(...)` for boolean attributes —
that is the pattern already used for `fullwidth`/`autoplay`.

### Conventions for shortcode lambdas

- Validate/normalize the URL; support both canonical and short/mobile URL forms
  (`youtube.com/watch`, `youtu.be`, `x.com`, `twitter.com`, …).
- Fall back to a plain link when the URL cannot be parsed — never raise into the
  render path.
- Escape user-provided values before interpolating them into HTML.
- Prefer official embed mechanisms (oEmbed endpoints, official iframes/blockquotes)
  over scraping, and document the chosen approach in the issue/PR.
- Return responsive markup when the caller asks for `fullwidth`.

## CamaleonCMS references

- Plugin docs/manifest format: https://github.com/owen2345/camaleon-cms
- `shortcode_add` is defined by CamaleonCMS; check the version you target before
  changing its signature or the `args` you rely on.
- Hooks available to this plugin are declared in `config/camaleon_plugin.json`
  (`on_active`, `on_inactive`, `plugin_options`, `app_before_load`).

## Known quirks (do not "fix" silently)

- `config/camaleon_plugin.json` uses `//` comments (not strict JSON) — CamaleonCMS
  tolerates them; keep them if you edit the file, and mention any change in the PR.
- `config/routes.rb` contains the same `Rails.application.routes.draw` block twice.
  Removing the duplicate is fine, but do it as its own commit/PR with a note.
- In the YouTube lambda, `md[1||2]` evaluates to `md[1]`, so `youtu.be` URLs do not
  resolve the video ID. Any fix here belongs with the "Update the YouTube shortcode"
  issue and needs a test.

## Commands

```bash
bundle install   # install dependencies
rake test        # run the Minitest suite (uses test/dummy)
rake             # default task = test
```

Ruby/Bundler are managed per-project; if `ruby` or `bundle` resolve to the wrong
version, check for a version manager config (`mise`/`asdf`/`.ruby-version`) before
installing anything globally.

## Tests

- Framework: **Minitest** via `rake test`.
- The dummy app lives in `test/dummy`; `test/test_helper.rb` boots it.
- Add a test for every behaviour change (at minimum: the shortcode lambda returns the
  expected HTML for valid and invalid input).

## Git / PR workflow

- Branch from `master`, one logical change per PR.
- Reference the tracking issue in the PR description.
- Run `rake test` before opening the PR; report the result in the description.
- Never push directly to `master`.
