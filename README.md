# Mova-I18n

**Mova-I18n** overwrites `translate/t` method of [I18n][i18n] in a way that delegates it to
[Mova][mova] internals without major breaking of I18n API. This speeds up translation
lookups while staying compatible with libraries that rely on I18n.

## Status

Not tested in production.

## Installation

Add this line to your application's Gemfile and run `bundle`:

```ruby
gem 'mova-i18n'
```

## Configuration

No configuration is needed if you have in-memory `I18n::Backend::Simple` backend (used in Rails
apps by default). Mova-I18n will use I18n setup (including locale fallbacks) and automatically
load translations stored in local files.

When using other persistent key-value storage, you probably need chain configuration like this:

```ruby
require "mova/storage/chain"
require "mova/storage/readonly"
require "mova/storage/memory"
redis = ActiveSupport::Cache::RedisStore.new("localhost:6379/0")
chain = Mova::Storage::Chain.new(Mova::Storage::Readonly.new(redis), Mova::Storage::Memory.new)
I18n.mova.translator = Mova::I18nTranslator.new(storage: chain)
```

Note, that you must pass your storage wrapped in `Readonly`, otherwise `I18n.reload!` will clear
all translations stored there when Rails boots up. It will also protect your storage from having 
incompatible data written to it, such as hashes or procs (those are partially supported and can be 
handled normally only with in-memory storage). Such configuration allows to override Rails default
translations in your backend, since first storage takes precedence over next one.

## Compatibility

### Supported

* the following `I18n.translate` calls:

```ruby
I18n.t(:key)
I18n.t("key")
I18n.t(:key, locale: :fr)
I18n.t(:key, raise: true)
I18n.t(:key, throw: true)
I18n.t(:key, fallback: true) # i.e. disabled locale fallback
I18n.t(:key, default: :default_key_lookup)
I18n.t(:key, default: "default translation")
I18n.t(:key, default: [:default_key_lookup1, :default_key_lookup2])
I18n.t(:key, default: [:default_key_lookup1, "default translation"])
I18n.t(:key, scope: :key_scope)
I18n.t(:key, scope: [:key_scope_part1, :key_scope_part2])
I18n.t(:key, interpolation1: "value1", interpolation2: "value2")
I18n.t(:key, count: 3)
```

Any combination of `locale`, `raise/throw`, `default`, `scope`, `count`, `fallback` options
is also supported.

* `I18n.localize` and `I18n.transliterate`

* locale fallbacks

### Partially supported

*  storing values other than String or nil is possible only with in-memory storage or with chain
including in-memory storage (see "Configuration"). Although it violates one of the Mova design principles,
Mova-I18n tries to be compatible with Rails localization helpers that require hashes to be
returned from `I18n.t`, so it writes to and retrieves a couple of hashes from a storage.

### Not supported

*  translations as procs, using procs in defaults. Actually, you can store them (see "Partially
supported"), but they'll never be called. The only exception are the pluralization and transliteration
rules (for compatibility with [Rails-I18n][rails-i18n] project).

   This means that **`default` option in Rails 4.x views won't work**, because Rails wraps it in a proc
call. Although using `default` in a template is a bad practice anyway.

*  bulk translation via `I18n.t([:first_key, :second_key])`. Use map instead.
*  cascade lookup

[mova]: https://github.com/mova-rb/mova
[i18n]: https://github.com/svenfuchs/i18n
[rails-i18n]: https://github.com/svenfuchs/rails-i18n
