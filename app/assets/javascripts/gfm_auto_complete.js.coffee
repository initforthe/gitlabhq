# Creates the variables for setting up GFM auto-completion

window.GitLab ?= {}
GitLab.GfmAutoComplete =
  # Emoji
  Emoji:
    data: []
    template: '<li data-value="${insert}">${name} <img alt="${name}" height="20" src="${image}" width="20" /></li>'

  # Team Members
  Members:
    data: []
    url: ''
    params:
      private_token: ''
    template: '<li data-value="${name}">${name} <small>${name}</small></li>'

  # Add GFM auto-completion to all input fields, that accept GFM input.
  setup: ->
    input = $('.js-gfm-input')

    # Emoji
    input.atWho ':',
      data: @Emoji.data
      tpl: @Emoji.template

    # Team Members
    input.atWho '@',
      tpl: @Members.template
      callback: (query, callback) =>
        $.getJSON(@Members.url, @Members.params).done (members) =>
          callback(members)

