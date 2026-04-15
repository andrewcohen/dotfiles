function setup(config)
  config.action("open file in $EDITOR", function()
    local file = context.file()
    if not file then
      flash("No file selected")
      return
    end

    exec_shell(string.format(
      [[sh -lc 'exec "${EDITOR:-vi}" "$1"' sh %q]],
      file
    ))
  end, {
    key = "ctrl+e",
    scope = "revisions.details",
    desc = "open selected file in $EDITOR",
  })

  config.action("jj git export", function()
    exec_shell("sh -lc 'jj git export'")
  end, {
    key = "e",
    scope = "git",
    desc = "run jj git export",
  })
end
