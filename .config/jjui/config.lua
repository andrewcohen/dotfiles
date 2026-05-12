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

  config.action("jj workspace update-stale", function()
    exec_shell("sh -lc 'jj workspace update-stale'")
  end, {
    key = "w",
    scope = "revisions",
    desc = "run jj workspace update-stale",
  })

  config.action("copy change id", function()
    local id = context.change_id()
    if not id then
      flash("No revision selected")
      return
    end
    local ok, err = copy_to_clipboard(id)
    if ok then
      flash("Copied " .. id)
    else
      flash({ text = "Copy failed: " .. (err or "unknown"), error = true })
    end
  end, {
    key = "Y",
    scope = "revisions",
    desc = "copy selected change id to clipboard",
  })
end
