# SquadGoals

A tiny app to allow open-source contributors to opt-in to GitHub teams.

## What it does

The #SquadGoals app provides an interface whereby community members can see a list of open GitHub teams, and provide them with the ability to freely join any team at the click of a button.

![screenshot](https://cloud.githubusercontent.com/assets/282759/13612933/e7271ece-e537-11e5-987a-057799f96e7c.png)

## Setup

### Credentials

You'll need a few different credentials for things to work:

#### A bot account

You'll need a dedicated "bot" account to add users to the organization:

1. [Create a bot account](https://github.com/signup) (a standard GitHub account not used by a human) that has *admin* rights to your organization.
2. [Create a personal access token](https://github.com/settings/tokens/new) for that user, with `admin:org` scope.

#### An OAuth application

You'll also need to create an OAuth application to validate users:

1. Create an OAuth application *within your organization* via `https://github.com/organizations/[YOUR-ORGANIZATION-NAME]/settings/applications/new`
2. The homepage URL should be the URL to your production instance.
3. You can leave the callback URL blank. The default is fine.

## Developing locally and deploying

1. Create [an OAuth app](github.com/settings/applications/new) (see above)
2. Create a personal access token for a user with admin rights to the organization (see above)
3. Add `gem 'squad_gaols' to your project's Gemfile`
4. Add the following to your project's `config.ru` file:

```ruby
require 'squad_goals'
run SquadGoals::App
```

## Configuration

The following environmental values should be set:

* `GITHUB_ORG_ID` - The name of the org to add users to
* `GITHUB_CLIENT_ID` - Your OAuth app's client ID
* `GITHUB_CLIENT_SECRET` - Your OAuth app's client secret
* `GITHUB_TOKEN` - A personal access token for a user with admin rights to the organization
* `GITHUB_TEAMS` - Comma-separated list of team names you'd like to allow access to, e.g, `red-team,blue-team`

### Customizing Views

There are three views, `success`, `forbidden`, and `error`. They're pretty boring by default, so you may want to swap them out for something a bit my snazzy. If you had a views directory along side your `config.ru`, you can do so like this in your `config.ru` file:

```ruby
require 'squad_goals'
SquadGoals.views_dir = File.expand_path("./views", File.dirname(__FILE__))
run SquadGoals::App
```

These are just sinatra `.erb` views. Take a look at [the default views](https://github.com/benbalter/squad_goals/tree/master/lib/squad_goals/views) for an example.

### Customizing static assets

You can also do the same with `SquadGoals.public_dir` for serving static assets (AddToOrg comes bundled with Bootstrap by default).

```ruby
require 'squad_goals'
SquadGoals.public_dir = File.expand_path("./public", File.dirname(__FILE__))
run SquadGoals::App
```
